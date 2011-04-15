Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab1DOOEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 10:04:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:23990 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425Ab1DOOEc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 10:04:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,219,1301900400"; 
   d="scan'208";a="910078969"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "haicheng.li@linux.intel.com" <haicheng.li@linux.intel.com>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "dave@linux.vnet.ibm.com" <dave@linux.vnet.ibm.com>,
        "gregkh@suse.de" <gregkh@suse.de>, "mingo@elte.hu" <mingo@elte.hu>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>
Date: Fri, 15 Apr 2011 22:04:26 +0800
Subject: RE: [0/7,v10] NUMA Hotplug Emulator (v10)
Thread-Topic: [0/7,v10] NUMA Hotplug Emulator (v10)
Thread-Index: AcvvrbNhhXB0n0wlRjmIHVrmwwTr2QLyDVFA
Message-ID: <749B9D3DBF0F054390025D9EAFF47F224A605265@shsmsx501.ccr.corp.intel.com>
References: <749B9D3DBF0F054390025D9EAFF47F224A3D6C35@shsmsx501.ccr.corp.intel.com>
In-Reply-To: <749B9D3DBF0F054390025D9EAFF47F224A3D6C35@shsmsx501.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any comments for those patches?

best regards
yang


> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Zhang, Yang Z
> Sent: Thursday, March 31, 2011 10:13 PM
> To: akpm@linux-foundation.org
> Cc: linux-mm@kvack.org; haicheng.li@linux.intel.com; lethal@linux-sh.org;
> Kleen, Andi; dave@linux.vnet.ibm.com; gregkh@suse.de; mingo@elte.hu;
> lenb@kernel.org; linux-kernel@vger.kernel.org; yinghai@kernel.org; Li, Xin
> Subject: [0/7,v10] NUMA Hotplug Emulator (v10)
> 
> * PATCHSET INTRODUCTION
> 
> patch 1: Documentation.
> patch 2: Adds a numa=possible=<N> command line option to set an additional
> N nodes
>                  as being possible for memory hotplug.
> 
> patch 3: Add node hotplug emulation, introduce debugfs node/add_node
> interface
> 
> patch 4: Abstract cpu register functions, make these interface friend for cpu
>                  hotplug emulation
> patch 5: Support cpu probe/release in x86, it provide a software method to hot
>                  add/remove cpu with sysfs interface.
> patch 6: Fake CPU socket with logical CPU on x86, to prevent the scheduling
>                  domain to build the incorrect hierarchy.
> patch 7: Implement per-node add_memory debugfs interface
> 
> * FEEDBACKDS & RESPONSES
> 
> v10:
> rebase the patches against 2.6.38-rc8
> 
> v9:
> 
> Solve the bug reported by Eric B Munson, check the return value of cpu_down
> when do
>  CPU release.
> 
> Solve the conflicts with Tejun Heo' Unificaton NUMA code, re-work patch 5
> based on his
> patch.
> 
> Some small changes on debugfs per-node add_memory interface.
> 
> v8:
> 
> Reconsider David's proposal, accept the per-node add_memory interface on
> debugfs.
> (p7).
> 
> v7:
> 
> David:    We don't need two different interfaces, one in sysfs and one in
> debugfs,
>           to hotplug memory.
> Response: We use the debugfs for memory hotplug emulation only, for sysfs
> memory probe
>           interface, we did not do any modifications, so we remove original
> patch 7
>                   from patchset.
> David:    Suggest new probe files in debugfs for each online node:
>                         /sys/kernel/debug/node_hotplug/add_node
> (already exists)
> 
> /sys/kernel/debug/node_hotplug/node0/add_memory
> 
> /sys/kernel/debug/node_hotplug/node1/add_memory
> 
> Response: We need not make a simple thing such complicated, We'd prefer to
>           rename the node_hotplug/probe interface as
> node_hotplug/add_memory.
>                         /sys/kernel/debug/node_hotplug/add_node
> (already exists)
>                         /sys/kernel/debug/node_hotplug/add_memory
> (rename probe as add_memory)
> 
> v6:
> 
> Greg KH:  Suggest to use interface node_hotplug/add_node
> David:    Agree with Greg's suggestion
> Response: We move the interface from node/add_node to
> node_hotplug/add_node, and we also move
>           memory/probe interface to node_hotplug/probe since both are
> related to memory hotplug.
> 
> Kletnieks Valdis: suggest to renumber the patch serie, and move patch 8/8 to
> patch 1/8.
> Response: Move patch 8/8 to patch 1/8, and we will include the full description
> in 0/8 when
>           we send patches in future.
> 
> 
> v5:
> 
> David: Suggests to use a flexible method to to do node hotplug emulation. After
>        review our 2 versions emulator implemetations, David provides a
> better solution
>            to solve both the flexibility and memory wasting issue.
> 
>            Add numa=possible=<N> command line option, provide sysfs
> inteface
>            /sys/devices/system/node/add_node interface, and move the
> inteface to debugfs
>            /sys/kernel/debug/hotplug/add_node after hearing the voice
> from community.
> 
> Greg KH: move the interface from hotplug/add_node to node/add_node
> 
> Response: Accept David's node=possible=<n> command line options. After
> talking
>        with David, he agree to add his patch to our patchset, thanks David's
> solution(patch 1).
> 
>            David's original interface /sys/kernel/debug/hotplug/add_node is
> not so clear for
>            node hotplug emulation, we accept Greg's suggestion, move the
> interface to ndoe/add_node
>            (patch 2)
> 
> Dave Hansen: For memory hotplug, Dave reminds Greg KH's advice, suggest us
> to use configfs replace
>        sysfs. After Dave knows that it is just for test purpose, Dave thinks
> debugfs should
>            be the best.
> 
> Response: memory probe sysfs interface already exists, I'd like to still keep it,
> and extend it
>        to support memory add on a specified node(patch 6).
> 
>            We accepts Dave's suggestion, implement memory probe
> interface with debugfs(patch 7).
> 
> Randy Dunlap: Correct many grammatical errors in our documentation(patch
> 8).
> 
> Response: Thanks for Randy's careful review, we already correct them.
> 
> v4:
> 
> Split CPU hotplug emulation code since David has send a patchset for node
> hotplug emulation.
> 
> v3 & v2:
> 
> 1) Patch 0
> Balbir & Greg: Suggest to use tool git/quilt to manage/send the patchset.
> Response: Thanks for the recommendation, With help from Fengguang, I get
> quilt
>                   working, it is a great tool.
> 
> 2) Patch 2
> Jaswinder Singh: if (hidden_num) is not required in patch 2
> Response: good catching, it is removed in v2.
> 
> 
> 3) Patch 3
> Dave Hansen: Suggest to create a dedicated sysfs file for each possible node.
> Greg:     How big would this "list" be?  What will it look like exactly?
> Haicheng: It should follow "one value per file". It intends to show acceptable
>                   parameters.
> 
>                   For example, if we have 4 fake offlined nodes, like node
> 2-5, then:
>                            $ cat /sys/devices/system/node/probe
>                                  2-5
> 
>                   Then user hotadds node3 to system:
>                            $ echo 3 > /sys/devices/system/node/probe
>                            $ cat /sys/devices/system/node/probe
>                                  2,4-5
> 
> Greg:   As you are trying to add a new sysfs file, please create the matching
>                 Documentation/ABI/ file as well.
> Response: We miss it, and we already add it in v2.
> 
> Patch 4 & 5:
> Paul Mundt: This looks like an incredibly painful interface. How about scrapping
> all
> of this _emu() mess and just reworking the register_cpu() interface?
> Response: accept Paul's suggestion, and remove the cpu _emu functions.
> 
> Patch 7:
> Dave Hansen: If we're going to put multiple values into the file now and
>                  add to the ABI, can we be more explicit about it?
>                 echo "physical_address=0x40000000 numa_node=3" >
> memory/probe
> Response: Dave's new interface was accpeted, and more we still keep the old
>               format for compatibility. We documented the these interfaces
> into
>                   Documentation/ABI in v2.
> Greg:   suggest to use configfs replace for the memory probe interface
> Andi:   This is a debugging interface. It doesn't need to have the
>                 most pretty interface in the world, because it will be only
> used for
>                 QA by a few people. it's just a QA interface, not the next
> generation
>                 of POSIX.
> Response: We still keep it as sysfs interface since node/cpu/memory probe
> interface
>                   are all in sysfs, we can create another group of patches
> to support
>                   configfs if we have this strong requirement in future.
> 
> v1:
> 
> the RFC version for NUMA Hotplug Emulator.
> 
> * WHAT IS HOTPLUG EMULATOR
> 
> NUMA hotplug emulator is collectively named for the hotplug emulation
> it is able to emulate NUMA Node Hotplug thru a pure software way. It
> intends to help people easily debug and test node/cpu/memory hotplug
> related stuff on a none-NUMA-hotplug-support machine, even an UMA
> machine.
> 
> The emulator provides mechanism to emulate the process of physcial cpu/mem
> hotadd, it provides possibility to debug CPU and memory hotplug on the
> machines
> without NUMA support for kenrel developers. It offers an interface for cpu
> and memory hotplug test purpose.
> 
> * WHY DO WE USE HOTPLUG EMULATOR
> 
> We are focusing on the hotplug emualation for a few months. The emualor
> helps
>  team to reproduce all the major hotplug bugs. It plays an important role to
> the hotplug code quality assuirance. Because of the hotplug emulator, we
> already
> move most of the debug working to virtual evironment.
> 
> * Principles & Usages
> 
> NUMA hotplug emulator include 3 different parts: node/CPU/memory hotplug
> emulation.
> 
> 1) Node hotplug emulation:
> 
> Adds a numa=possible=<N> command line option to set an additional N nodes
> as
> being possible for memory hotplug. This set of possible nodes control
> nr_node_ids and the sizes of several dynamically allocated node arrays.
> 
> This allows memory hotplug to create new nodes for newly added memory
> rather than binding it to existing nodes.
> 
> For emulation on x86, it would be possible to set aside memory for hotplugged
> nodes (say, anything above 2G) and to add an additional four nodes as being
> possible on boot with
> 
>         mem=2G numa=possible=4
> 
> and then creating a new 128M node at runtime:
> 
>         # echo 128M@0x80000000 >
> /sys/kernel/debug/node_hotplug/add_node
>         On node 1 totalpages: 0
>         init_memory_mapping: 0000000080000000-0000000088000000
>          0080000000 - 0088000000 page 2M
> 
> Once the new node has been added, its memory can be onlined.  If this
> memory represents memory section 16, for example:
> 
>         # echo online > /sys/devices/system/memory/memory16/state
>         Built 2 zonelists in Node order, mobility grouping on.  Total pages:
> 514846
>         Policy zone: Normal
>  [ The memory section(s) mapped to a particular node are visible via
>    /sys/devices/system/node_hotplug/node1, in this example. ]
> 
> 2) CPU hotplug emulation:
> 
> The emulator reserve CPUs throu grub parameter, the reserved CPUs can be
> hot-add/hot-remove in software method.
> 
> When hotplug a CPU with emulator, we are using a logical CPU to emulate the
> CPU
> hotplug process. For the CPU supported SMT, some logical CPUs are in the
> same
> socket, but it may located in different NUMA node after we have emulator.
> We
> put the logical CPU into a fake CPU socket, and assign it an unique
> phys_proc_id. For the fake socket, we put one logical CPU in only.
> 
>  - to hide CPUs
>         - Using boot option "maxcpus=N" hide CPUs
>           N is the number of initialize CPUs
>         - Using boot option "cpu_hpe=on" to enable cpu hotplug emulation
>       when cpu_hpe is enabled, the rest CPUs will not be initialized
> 
>  - to hot-add CPU to node
>         # echo node_id > cpu/probe
> 
>  - to hot-remove CPU
>         # echo cpu_id > cpu/release
> 
> 3) Memory hotplug emulation:
> 
> The emulator reserves memory before OS boots, the reserved memory region
> is
> removed from e820 table. Each online node has an add_memory interface, and
> memory can be hot-added via the per-ndoe add_memory debugfs interface.
> 
>  - reserve memory thru a kernel boot paramter
>         mem=1024m
> 
>  - add a memory section to node 3
>     # echo 0x40000000 > node_hotplug/node3/add_memory
> 
> * ACKNOWLEDGMENT
> 
> NUMA Hotplug Emulator includes a team's efforts, thanks all of them.
> They are:
> Andi Kleen, Haicheng Li, Shaohui Zheng, Fengguang Wu, David Rientjes,
> Yang Zhang and Yongkang You
> ---
> best regards
> yang
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
