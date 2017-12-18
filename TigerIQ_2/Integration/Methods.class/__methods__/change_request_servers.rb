

def main
  fill_dialog_field(fetch_list_data)
end

def fetch_list_data
  server_list = nil
  filter = group_filter

  query_cr.each do |server|
    $evm.log(:info, "Server: #{server}")

    vm = $evm.vmdb(:Vm).find_by(:name=>server)
    # vm = $evm.vmdb(:Vm).find_tagged_with(:all => '/my_cat/my_tag', :ns => "/managed")

    if vm
      $evm.log(:info, "VM tags: #{vm.tags}")

      if vm.tagged_with?(group_filter['category'], group_filter['tag'])
        server_list = "#{server_list},#{vm.name}"
      end
    else
      $evm.log(:info, "Server not found in VMDB")
    end
  end

  server_list = 'No accessible VMs' if server_list.nil?
  server_list
end

def fill_dialog_field(valid_servers)
  dialog_field = $evm.object

  dialog_field["value"] = valid_servers
end


def cr
  $evm.root['dialog_cr']
end

def query_cr
  case cr.to_s
  when '1111'
    ['svr1', 'svr2', 'svr3']
  when '2222'
    ['svr1', 'svr2', 'svr3']
  when '2222'
    ['svr1', 'svr2', 'svr3']
  else
    []
  end
end

def group_filter
  # irb(main):032:0> $evm.vmdb(:MiqGroup).find_by(:description=>"op_limited").filters['managed'].first.first
  # => "/managed/owner/win2008_test"
  cat_tag = {}
  filter = $evm.root['miq_group'].filters['managed'].first.first rescue nil
  unless filter.nil?
    match = filter.match(/managed\/(.*)\/(.*)/)
    cat_tag = {'category' => match[1], 'tag' => match[2]} unless match.nil?
  end
  cat_tag
end

$evm.root.attributes.sort.each { |k, v| $evm.log(:info, "\t Attribute: #{k} = #{v}")}

main
