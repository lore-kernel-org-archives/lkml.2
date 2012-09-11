Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592Ab2IKBiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 21:38:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:32834 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204Ab2IKBh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 21:37:56 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <504E95DE.8000102@jp.fujitsu.com>
Date: Tue, 11 Sep 2012 10:37:34 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [V4 PATCH 00/26] memory,numa: introduce MOVABLE-dedicated node
 and online_movable for hotplug
References: <1347267558-6707-1-git-send-email-laijs@cn.fujitsu.com> <504E8874.5020605@jp.fujitsu.com> <504E9270.8040006@cn.fujitsu.com>
In-Reply-To: <504E9270.8040006@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lai,

2012/09/11 10:22, Lai Jiangshan wrote:
> On 09/11/2012 08:40 AM, Yasuaki Ishimatsu wrote:
>> Hi Lai,
>>
>> Using memory_online to hot-added node's memory, the following kernel messages
>> were shown. Is this a known issue?
>
> Thank you for your report.
>
> What operations did you have performed ?

My operations are as follows:

1. Hot-add a new node by container driver.
    In my system, container driver hot-addes a new nodes which includes CPUs and
    memorys.

2. echo online_movable to hot-added nodes's memory
    When container driver hot-adds a new nodes, my system creates node2 sysfs.
    And the sysfs has memory768-memory1023 sysfs. So I echo "online_movable"
    to memory1023/state file.
    # echo online_movable > memory1023/state

Thanks,
Yasuaki Ishimatsu

>
> Thanks.
> Lai
>
>>
>> [  327.837408] ------------[ cut here ]------------
>> [  327.892556] kernel BUG at mm/page_alloc.c:553!
>> [  327.945621] invalid opcode: 0000 [#1] SMP
>> [  327.994748] Modules linked in: sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables binfmt_misc vfat fat dm_mirror dm_region_hash dm_log dm_mod uinput iTCO_wdt iTCO_vendor_support coretemp kvm_intel kvm crc32c_intel microcode pcspkr i2c_i801 i2c_core lpc_ich mfd_core ioatdma i7core_edac edac_core sg e1000e igb dca sd_mod crc_t10dif lpfc scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas scsi_mod
>> [  328.560103] CPU 0
>> [  328.582021] Pid: 2445, comm: bash Not tainted 3.6.0-rc5-removable-node+ #1 FUJITSU-SV PRIMEQUEST 1800E/SB
>> [  328.698524] RIP: 0010:[<ffffffff8116ffdc>]  [<ffffffff8116ffdc>] free_pcppages_bulk+0x4ec/0x540
>> [  328.802580] RSP: 0018:ffff8807875f9b88  EFLAGS: 00010002
>> [  328.866025] RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000001
>> [  328.951273] RDX: 0000000000000002 RSI: ffffea007fe00000 RDI: ffff880764801680
>> [  329.036522] RBP: ffff8807875f9c38 R08: 0000000001ff8000 R09: ffff880764801740
>> [  329.121771] R10: 0000000001800000 R11: 0000000000000001 R12: 0000000000000002
>> [  329.207022] R13: ffffea007fe00000 R14: ffff880764801680 R15: ffffea007fe00020
>> [  329.292270] FS:  00007ff533e92700(0000) GS:ffff8807c1800000(0000) knlGS:0000000000000000
>> [  329.388942] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  329.457575] CR2: ffffffffff600400 CR3: 00000007b6826000 CR4: 00000000000007f0
>> [  329.542826] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [  329.628075] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> [  329.713326] Process bash (pid: 2445, threadinfo ffff8807875f8000, task ffff8807b72ccca0)
>> [  329.809993] Stack:
>> [  329.833984]  ffff881ff8000000 0000000000000000 0000000000000000 0000000000000000
>> [  329.922788]  ffffffff81c3f160 ffff8807875f9fd8 ffff8807648016e8 0000000100000002
>> [  330.011593]  ffff8807875f8000 ffff8807875f8000 0000000000000030 ffff8807c19d0e18
>> [  330.100400] Call Trace:
>> [  330.129588]  [<ffffffff811703c7>] free_hot_cold_page+0x187/0x1d0
>> [  330.201345]  [<ffffffff81170445>] __free_pages+0x35/0x50
>> [  330.264798]  [<ffffffff811c05ec>] __online_page_free+0x1c/0x20
>> [  330.334478]  [<ffffffff811c0616>] generic_online_page+0x26/0x30
>> [  330.405197]  [<ffffffff811c0271>] online_pages_range+0x61/0x90
>> [  330.474880]  [<ffffffff81078240>] walk_system_ram_range+0x140/0x150
>> [  330.549750]  [<ffffffff811c0210>] ? __online_page_increment_counters+0x20/0x20
>> [  330.636050]  [<ffffffff8165464b>] online_pages+0x22b/0x390
>> [  330.701584]  [<ffffffff8144d2ec>] memory_block_action+0xbc/0x1a0
>> [  330.773347]  [<ffffffff8166cbfa>] ? mutex_lock_nested+0x4a/0x60
>> [  330.844063]  [<ffffffff8144d453>] memory_block_change_state+0x83/0xf0
>> [  330.921013]  [<ffffffff8118ff9c>] ? might_fault+0x5c/0xb0
>> [  330.985502]  [<ffffffff8144d5f7>] store_mem_state+0x137/0x180
>> [  331.054150]  [<ffffffff8124a517>] ? sysfs_write_file+0x87/0x100
>> [  331.124867]  [<ffffffff814375f0>] dev_attr_store+0x20/0x30
>> [  331.190392]  [<ffffffff8124a533>] sysfs_write_file+0xa3/0x100
>> [  331.259038]  [<ffffffff811cc6d0>] vfs_write+0xd0/0x1a0
>> [  331.320411]  [<ffffffff811cc8a4>] sys_write+0x54/0xa0
>> [  331.380747]  [<ffffffff81679bd9>] system_call_fastpath+0x16/0x1b
>> [  331.452501] Code: ff ff 0f 0b eb fe 0f 0b 0f 1f 80 00 00 00 00 eb f7 0f 0b eb fe 48 c7 c7 80 3b c3 81 e8 ae 6c f6 ff 85 c0 0f 85 cb fd ff ff eb 8f <0f> 0b 66 90 eb fc 0f 0b eb fe 49 8b 47 e0 f6 c4 40 0f 1f 00 74
>> [  331.685087] RIP  [<ffffffff8116ffdc>] free_pcppages_bulk+0x4ec/0x540
>> [  331.761102]  RSP <ffff8807875f9b88>
>> [  331.802749] ---[ end trace f3112128f3ab7e75 ]---
>> [  331.859455] BUG: sleeping function called from invalid context at mm/slub.c:930
>> [  331.946779] in_atomic(): 1, irqs_disabled(): 1, pid: 2445, name: bash
>> [  332.023723] INFO: lockdep is turned off.
>> [  332.070554] irq event stamp: 301462
>> [  332.112196] hardirqs last  enabled at (301461): [<ffffffff816700f0>] _raw_spin_unlock_irq+0x30/0x50
>> [  332.220397] hardirqs last disabled at (301462): [<ffffffff8166f5cf>] _raw_spin_lock_irq+0x1f/0x90
>> [  332.326522] softirqs last  enabled at (301450): [<ffffffff81076a9c>] __do_softirq+0x18c/0x3e0
>> [  332.428493] softirqs last disabled at (301445): [<ffffffff8167af3c>] call_softirq+0x1c/0x30
>> [  332.528391] Pid: 2445, comm: bash Tainted: G      D      3.6.0-rc5-removable-node+ #1
>> [  332.621944] Call Trace:
>> [  332.651131]  [<ffffffff810a943a>] __might_sleep+0x18a/0x240
>> [  332.717699]  [<ffffffff811bddbb>] __kmalloc+0x6b/0x220
>> [  332.779079]  [<ffffffff814f5ab1>] ? efivar_create_sysfs_entry+0x41/0x1b0
>> [  332.859144]  [<ffffffff814f5ab1>] efivar_create_sysfs_entry+0x41/0x1b0
>> [  332.937130]  [<ffffffff814f5f9b>] efi_pstore_write+0x37b/0x3a0
>> [  333.006812]  [<ffffffff81670187>] ? _raw_spin_unlock_irqrestore+0x77/0x80
>> [  333.087916]  [<ffffffff8106d022>] ? kmsg_dump_get_buffer+0x1e2/0x2c0
>> [  333.163827]  [<ffffffff812bf3d0>] ? pstore_dump+0x1b0/0x220
>> [  333.230391]  [<ffffffff812bf34f>] pstore_dump+0x12f/0x220
>> [  333.294883]  [<ffffffff8106faab>] kmsg_dump+0x11b/0x2a0
>> [  333.357294]  [<ffffffff8106f9b6>] ? kmsg_dump+0x26/0x2a0
>> [  333.420746]  [<ffffffff8106bb6d>] oops_exit+0x1d/0x20
>> [  333.481085]  [<ffffffff816712fe>] oops_end+0x7e/0xf0
>> [  333.540386]  [<ffffffff8101a8eb>] die+0x5b/0x90
>> [  333.594489]  [<ffffffff81670c64>] do_trap+0xc4/0x170
>> [  333.653789]  [<ffffffff810186f5>] do_invalid_op+0x95/0xb0
>> [  333.718278]  [<ffffffff8116ffdc>] ? free_pcppages_bulk+0x4ec/0x540
>> [  333.792117]  [<ffffffff8134a56d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>> [  333.870098]  [<ffffffff81670420>] ? restore_args+0x30/0x30
>> [  333.935620]  [<ffffffff8167acbb>] invalid_op+0x1b/0x20
>> [  333.996991]  [<ffffffff8116ffdc>] ? free_pcppages_bulk+0x4ec/0x540
>> [  334.070825]  [<ffffffff8116fc09>] ? free_pcppages_bulk+0x119/0x540
>> [  334.144660]  [<ffffffff811703c7>] free_hot_cold_page+0x187/0x1d0
>> [  334.216417]  [<ffffffff81170445>] __free_pages+0x35/0x50
>> [  334.279868]  [<ffffffff811c05ec>] __online_page_free+0x1c/0x20
>> [  334.349549]  [<ffffffff811c0616>] generic_online_page+0x26/0x30
>> [  334.420269]  [<ffffffff811c0271>] online_pages_range+0x61/0x90
>> [  334.489957]  [<ffffffff81078240>] walk_system_ram_range+0x140/0x150
>> [  334.564832]  [<ffffffff811c0210>] ? __online_page_increment_counters+0x20/0x20
>> [  334.651125]  [<ffffffff8165464b>] online_pages+0x22b/0x390
>> [  334.716654]  [<ffffffff8144d2ec>] memory_block_action+0xbc/0x1a0
>> [  334.788411]  [<ffffffff8166cbfa>] ? mutex_lock_nested+0x4a/0x60
>> [  334.859130]  [<ffffffff8144d453>] memory_block_change_state+0x83/0xf0
>> [  334.936078]  [<ffffffff8118ff9c>] ? might_fault+0x5c/0xb0
>> [  335.000568]  [<ffffffff8144d5f7>] store_mem_state+0x137/0x180
>> [  335.069213]  [<ffffffff8124a517>] ? sysfs_write_file+0x87/0x100
>> [  335.139931]  [<ffffffff814375f0>] dev_attr_store+0x20/0x30
>> [  335.205459]  [<ffffffff8124a533>] sysfs_write_file+0xa3/0x100
>> [  335.274103]  [<ffffffff811cc6d0>] vfs_write+0xd0/0x1a0
>> [  335.335477]  [<ffffffff811cc8a4>] sys_write+0x54/0xa0
>> [  335.395815]  [<ffffffff81679bd9>] system_call_fastpath+0x16/0x1b
>> [  335.467571] BUG: scheduling while atomic: bash/2445/0x10000004
>> [  335.537243] INFO: lockdep is turned off.
>> [  335.584074] Modules linked in: sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables binfmt_misc vfat fat dm_mirror dm_region_hash dm_log dm_mod uinput iTCO_wdt iTCO_vendor_support coretemp kvm_intel kvm crc32c_intel microcode pcspkr i2c_i801 i2c_core lpc_ich mfd_core ioatdma i7core_edac edac_core sg e1000e igb dca sd_mod crc_t10dif lpfc scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas scsi_mod
>> [  336.149444] irq event stamp: 301462
>> [  336.191085] hardirqs last  enabled at (301461): [<ffffffff816700f0>] _raw_spin_unlock_irq+0x30/0x50
>> [  336.299285] hardirqs last disabled at (301462): [<ffffffff8166f5cf>] _raw_spin_lock_irq+0x1f/0x90
>> [  336.405411] softirqs last  enabled at (301450): [<ffffffff81076a9c>] __do_softirq+0x18c/0x3e0
>> [  336.507381] softirqs last disabled at (301445): [<ffffffff8167af3c>] call_softirq+0x1c/0x30
>> [  336.607278] Pid: 2445, comm: bash Tainted: G      D      3.6.0-rc5-removable-node+ #1
>> [  336.700831] Call Trace:
>> [  336.730023]  [<ffffffff810a7f0a>] __schedule_bug+0x6a/0x90
>> [  336.795549]  [<ffffffff8166e128>] __schedule+0x7d8/0x880
>> [  336.858999]  [<ffffffff810acc6a>] __cond_resched+0x2a/0x40
>> [  336.924529]  [<ffffffff8166e260>] _cond_resched+0x30/0x40
>> [  336.989017]  [<ffffffff811bddc0>] __kmalloc+0x70/0x220
>> [  337.050393]  [<ffffffff814f5ab1>] ? efivar_create_sysfs_entry+0x41/0x1b0
>> [  337.130456]  [<ffffffff814f5ab1>] efivar_create_sysfs_entry+0x41/0x1b0
>> [  337.208445]  [<ffffffff814f5f9b>] efi_pstore_write+0x37b/0x3a0
>> [  337.278125]  [<ffffffff81670187>] ? _raw_spin_unlock_irqrestore+0x77/0x80
>> [  337.359228]  [<ffffffff8106d022>] ? kmsg_dump_get_buffer+0x1e2/0x2c0
>> [  337.435138]  [<ffffffff812bf3d0>] ? pstore_dump+0x1b0/0x220
>> [  337.501705]  [<ffffffff812bf34f>] pstore_dump+0x12f/0x220
>> [  337.566194]  [<ffffffff8106faab>] kmsg_dump+0x11b/0x2a0
>> [  337.628607]  [<ffffffff8106f9b6>] ? kmsg_dump+0x26/0x2a0
>> [  337.692052]  [<ffffffff8106bb6d>] oops_exit+0x1d/0x20
>> [  337.752383]  [<ffffffff816712fe>] oops_end+0x7e/0xf0
>> [  337.811683]  [<ffffffff8101a8eb>] die+0x5b/0x90
>> [  337.865790]  [<ffffffff81670c64>] do_trap+0xc4/0x170
>> [  337.925090]  [<ffffffff810186f5>] do_invalid_op+0x95/0xb0
>> [  337.989579]  [<ffffffff8116ffdc>] ? free_pcppages_bulk+0x4ec/0x540
>> [  338.063413]  [<ffffffff8134a56d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>> [  338.141400]  [<ffffffff81670420>] ? restore_args+0x30/0x30
>> [  338.206928]  [<ffffffff8167acbb>] invalid_op+0x1b/0x20
>> [  338.268305]  [<ffffffff8116ffdc>] ? free_pcppages_bulk+0x4ec/0x540
>> [  338.342137]  [<ffffffff8116fc09>] ? free_pcppages_bulk+0x119/0x540
>> [  338.415973]  [<ffffffff811703c7>] free_hot_cold_page+0x187/0x1d0
>> [  338.487732]  [<ffffffff81170445>] __free_pages+0x35/0x50
>> [  338.551181]  [<ffffffff811c05ec>] __online_page_free+0x1c/0x20
>> [  338.620863]  [<ffffffff811c0616>] generic_online_page+0x26/0x30
>> [  338.691583]  [<ffffffff811c0271>] online_pages_range+0x61/0x90
>> [  338.761264]  [<ffffffff81078240>] walk_system_ram_range+0x140/0x150
>> [  338.836137]  [<ffffffff811c0210>] ? __online_page_increment_counters+0x20/0x20
>> [  338.922431]  [<ffffffff8165464b>] online_pages+0x22b/0x390
>> [  338.987959]  [<ffffffff8144d2ec>] memory_block_action+0xbc/0x1a0
>> [  339.059718]  [<ffffffff8166cbfa>] ? mutex_lock_nested+0x4a/0x60
>> [  339.130438]  [<ffffffff8144d453>] memory_block_change_state+0x83/0xf0
>> [  339.207385]  [<ffffffff8118ff9c>] ? might_fault+0x5c/0xb0
>> [  339.271879]  [<ffffffff8144d5f7>] store_mem_state+0x137/0x180
>> [  339.340520]  [<ffffffff8124a517>] ? sysfs_write_file+0x87/0x100
>> [  339.411238]  [<ffffffff814375f0>] dev_attr_store+0x20/0x30
>> [  339.476766]  [<ffffffff8124a533>] sysfs_write_file+0xa3/0x100
>> [  339.545410]  [<ffffffff811cc6d0>] vfs_write+0xd0/0x1a0
>> [  339.606784]  [<ffffffff811cc8a4>] sys_write+0x54/0xa0
>> [  339.667121]  [<ffffffff81679bd9>] system_call_fastpath+0x16/0x1b
>>
>> [  339.739266] BUG: sleeping function called from invalid context at mm/slub.c:930
>> [  339.826795] in_atomic(): 1, irqs_disabled(): 0, pid: 2445, name: bash
>> [  339.903925] INFO: lockdep is turned off.
>> [  339.950938] Pid: 2445, comm: bash Tainted: G      D W    3.6.0-rc5-removable-node+ #1
>> [  340.044702] Call Trace:
>> [  340.073958]  [<ffffffff810a943a>] __might_sleep+0x18a/0x240
>> [  340.140704]  [<ffffffff811bd4fb>] kmem_cache_alloc_trace+0x4b/0x1d0
>> [  340.215759]  [<ffffffff814f5acf>] efivar_create_sysfs_entry+0x5f/0x1b0
>> [  340.293928]  [<ffffffff814f5f9b>] efi_pstore_write+0x37b/0x3a0
>> [  340.363794]  [<ffffffff81670187>] ? _raw_spin_unlock_irqrestore+0x77/0x80
>> [  340.445071]  [<ffffffff8106d022>] ? kmsg_dump_get_buffer+0x1e2/0x2c0
>> [  340.521163]  [<ffffffff812bf3d0>] ? pstore_dump+0x1b0/0x220
>> [  340.587902]  [<ffffffff812bf34f>] pstore_dump+0x12f/0x220
>> [  340.652571]  [<ffffffff8106faab>] kmsg_dump+0x11b/0x2a0
>> [  340.715155]  [<ffffffff8106f9b6>] ? kmsg_dump+0x26/0x2a0
>> [  340.778739]  [<ffffffff8106bb6d>] oops_exit+0x1d/0x20
>> [  340.839300]  [<ffffffff816712fe>] oops_end+0x7e/0xf0
>> [  340.898737]  [<ffffffff8101a8eb>] die+0x5b/0x90
>> [  340.953042]  [<ffffffff81670c64>] do_trap+0xc4/0x170
>> [  341.012562]  [<ffffffff810186f5>] do_invalid_op+0x95/0xb0
>> [  341.077211]  [<ffffffff8116ffdc>] ? free_pcppages_bulk+0x4ec/0x540
>> [  341.151258]  [<ffffffff8134a56d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>> [  341.229428]  [<ffffffff81670420>] ? restore_args+0x30/0x30
>> [  341.295109]  [<ffffffff8167acbb>] invalid_op+0x1b/0x20
>> [  341.356736]  [<ffffffff8116ffdc>] ? free_pcppages_bulk+0x4ec/0x540
>> [  341.430789]  [<ffffffff8116fc09>] ? free_pcppages_bulk+0x119/0x540
>> [  341.504832]  [<ffffffff811703c7>] free_hot_cold_page+0x187/0x1d0
>> [  341.576803]  [<ffffffff81170445>] __free_pages+0x35/0x50
>> [  341.640459]  [<ffffffff811c05ec>] __online_page_free+0x1c/0x20
>> [  341.710291]  [<ffffffff811c0616>] generic_online_page+0x26/0x30
>> [  341.781224]  [<ffffffff811c0271>] online_pages_range+0x61/0x90
>> [  341.851126]  [<ffffffff81078240>] walk_system_ram_range+0x140/0x150
>> [  341.926211]  [<ffffffff811c0210>] ? __online_page_increment_counters+0x20/0x20
>> [  342.012703]  [<ffffffff8165464b>] online_pages+0x22b/0x390
>> [  342.078434]  [<ffffffff8144d2ec>] memory_block_action+0xbc/0x1a0
>> [  342.150325]  [<ffffffff8166cbfa>] ? mutex_lock_nested+0x4a/0x60
>> [  342.221165]  [<ffffffff8144d453>] memory_block_change_state+0x83/0xf0
>> [  342.298323]  [<ffffffff8118ff9c>] ? might_fault+0x5c/0xb0
>> [  342.362966]  [<ffffffff8144d5f7>] store_mem_state+0x137/0x180
>> [  342.431796]  [<ffffffff8124a517>] ? sysfs_write_file+0x87/0x100
>> [  342.502689]  [<ffffffff814375f0>] dev_attr_store+0x20/0x30
>> [  342.568387]  [<ffffffff8124a533>] sysfs_write_file+0xa3/0x100
>> [  342.637216]  [<ffffffff811cc6d0>] vfs_write+0xd0/0x1a0
>> [  342.698761]  [<ffffffff811cc8a4>] sys_write+0x54/0xa0
>> [  342.759236]  [<ffffffff81679bd9>] system_call_fastpath+0x16/0x1b
>> [  342.831184] BUG: scheduling while atomic: bash/2445/0x10000004
>> [  342.901189] INFO: lockdep is turned off.
>> [  342.948190] Modules linked in: sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables binfmt_misc vfat fat dm_mirror dm_region_hash dm_log dm_mod uinput iTCO_wdt iTCO_vendor_support coretemp kvm_intel kvm crc32c_intel microcode pcspkr i2c_i801 i2c_core lpc_ich mfd_core ioatdma i7core_edac edac_core sg e1000e igb dca sd_mod crc_t10dif lpfc scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas scsi_mod
>> [  343.519830] Pid: 2445, comm: bash Tainted: G      D W    3.6.0-rc5-removable-node+ #1
>> [  343.613552] Call Trace:
>> [  343.642773]  [<ffffffff810a7f0a>] __schedule_bug+0x6a/0x90
>> [  343.708445]  [<ffffffff8166e128>] __schedule+0x7d8/0x880
>> [  343.772084]  [<ffffffff814f5acf>] ? efivar_create_sysfs_entry+0x5f/0x1b0
>> [  343.852324]  [<ffffffff810acc6a>] __cond_resched+0x2a/0x40
>> [  343.918004]  [<ffffffff8166e260>] _cond_resched+0x30/0x40
>> [  343.982676]  [<ffffffff811bd500>] kmem_cache_alloc_trace+0x50/0x1d0
>> [  344.057721]  [<ffffffff814f5acf>] efivar_create_sysfs_entry+0x5f/0x1b0
>> [  344.135874]  [<ffffffff814f5f9b>] efi_pstore_write+0x37b/0x3a0
>> [  344.205752]  [<ffffffff81670187>] ? _raw_spin_unlock_irqrestore+0x77/0x80
>> [  344.287007]  [<ffffffff8106d022>] ? kmsg_dump_get_buffer+0x1e2/0x2c0
>> [  344.363106]  [<ffffffff812bf3d0>] ? pstore_dump+0x1b0/0x220
>> [  344.429885]  [<ffffffff812bf34f>] pstore_dump+0x12f/0x220
>> [  344.494584]  [<ffffffff8106faab>] kmsg_dump+0x11b/0x2a0
>> [  344.557185]  [<ffffffff8106f9b6>] ? kmsg_dump+0x26/0x2a0
>> [  344.620847]  [<ffffffff8106bb6d>] oops_exit+0x1d/0x20
>> [  344.681390]  [<ffffffff816712fe>] oops_end+0x7e/0xf0
>> [  344.740918]  [<ffffffff8101a8eb>] die+0x5b/0x90
>> [  344.795241]  [<ffffffff81670c64>] do_trap+0xc4/0x170
>> [  344.854734]  [<ffffffff810186f5>] do_invalid_op+0x95/0xb0
>> [  344.919416]  [<ffffffff8116ffdc>] ? free_pcppages_bulk+0x4ec/0x540
>> [  344.993473]  [<ffffffff8134a56d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>> [  345.071682]  [<ffffffff81670420>] ? restore_args+0x30/0x30
>> [  345.137431]  [<ffffffff8167acbb>] invalid_op+0x1b/0x20
>> [  345.199000]  [<ffffffff8116ffdc>] ? free_pcppages_bulk+0x4ec/0x540
>> [  345.273041]  [<ffffffff8116fc09>] ? free_pcppages_bulk+0x119/0x540
>> [  345.347082]  [<ffffffff811703c7>] free_hot_cold_page+0x187/0x1d0
>> [  345.419041]  [<ffffffff81170445>] __free_pages+0x35/0x50
>> [  345.482682]  [<ffffffff811c05ec>] __online_page_free+0x1c/0x20
>> [  345.552584]  [<ffffffff811c0616>] generic_online_page+0x26/0x30
>> [  345.623511]  [<ffffffff811c0271>] online_pages_range+0x61/0x90
>> [  345.693391]  [<ffffffff81078240>] walk_system_ram_range+0x140/0x150
>> [  345.768476]  [<ffffffff811c0210>] ? __online_page_increment_counters+0x20/0x20
>> [  345.854961]  [<ffffffff8165464b>] online_pages+0x22b/0x390
>> [  345.920712]  [<ffffffff8144d2ec>] memory_block_action+0xbc/0x1a0
>> [  345.992687]  [<ffffffff8166cbfa>] ? mutex_lock_nested+0x4a/0x60
>> [  346.063626]  [<ffffffff8144d453>] memory_block_change_state+0x83/0xf0
>> [  346.140786]  [<ffffffff8118ff9c>] ? might_fault+0x5c/0xb0
>> [  346.205491]  [<ffffffff8144d5f7>] store_mem_state+0x137/0x180
>> [  346.274370]  [<ffffffff8124a517>] ? sysfs_write_file+0x87/0x100
>> [  346.345299]  [<ffffffff814375f0>] dev_attr_store+0x20/0x30
>> [  346.411046]  [<ffffffff8124a533>] sysfs_write_file+0xa3/0x100
>> [  346.479894]  [<ffffffff811cc6d0>] vfs_write+0xd0/0x1a0
>> [  346.541493]  [<ffffffff811cc8a4>] sys_write+0x54/0xa0
>> [  346.602042]  [<ffffffff81679bd9>] system_call_fastpath+0x16/0x1b
>> ...
>>
>> Thanks,
>> Yasuaki Ishimatsu
>>
>> 2012/09/10 17:58, Lai Jiangshan wrote:
>>> 	A) Introduction:
>>>
>>> This patchset adds MOVABLE-dedicated node and online_movable for memory-management.
>>>
>>> It is used for anti-fragmentation(hugepage, big-order allocation...),
>>> hot-removal-of-memory(virtualization, power-conserve, move memory between systems
>>> to make better utilities of memories).
>>>
>>> This patchset is based on 650470d1da17c20bf9700f9446775a01cbda52c3 of newest tip tree.
>>>
>>> 	B) User Interface:
>>>
>>> When users(big system manager) need config some node/memory as MOVABLE:
>>> 	1 Use kernelcore_max_addr=XX when boot
>>> 	2 Use movable_online hotplug action when running
>>> We may introduce some more convenient interface, such as
>>> 	movable_node=NODE_LIST boot option.
>>>
>>> 	C) Patches
>>>
>>> Patch1-3      Fix problems of the current code.(all related with hotplug)
>>> Patch4        cleanup for node_state_attr
>>> Patch5        introduce N_MEMORY
>>> Patch6-18     use N_MEMORY instead N_HIGH_MEMORY.
>>>                 The patches are separated by subsystem,
>>>                 *these conversions was(must be) checked carefully*.
>>>                 Patch18 also changes the node_states initialization
>>> Patch19       Add config to allow MOVABLE-dedicated node
>>> Patch20-24    Add kernelcore_max_addr
>>> Patch25,26       Add online_movable and online_kernel
>>>
>>>
>>> 	D) changes
>>> change V4-v3
>>> 	rebase.
>>> 	online_movable/online_kernel can create a zone from empty
>>> 	or empyt a zone
>>>
>>> change V3-v2:
>>> 	Proper nodemask management
>>>
>>> change V2-V1:
>>>
>>> The original V1 patchset of MOVABLE-dedicated node is here:
>>> http://comments.gmane.org/gmane.linux.kernel.mm/78122
>>>
>>> The new V2 adds N_MEMORY and a notion of "MOVABLE-dedicated node".
>>> And fix some related problems.
>>>
>>> The orignal V1 patchset of "add online_movable" is here:
>>> https://lkml.org/lkml/2012/7/4/145
>>>
>>> The new V2 discards the MIGRATE_HOTREMOVE approach, and use a more straight
>>> implementation(only 1 patch).
>>> Lai Jiangshan (22):
>>>     page_alloc.c: don't subtract unrelated memmap from zone's present
>>>       pages
>>>     memory_hotplug: fix missing nodemask management
>>>     slub, hotplug: ignore unrelated node's hot-adding and hot-removing
>>>     node: cleanup node_state_attr
>>>     node_states: introduce N_MEMORY
>>>     cpuset: use N_MEMORY instead N_HIGH_MEMORY
>>>     procfs: use N_MEMORY instead N_HIGH_MEMORY
>>>     memcontrol: use N_MEMORY instead N_HIGH_MEMORY
>>>     oom: use N_MEMORY instead N_HIGH_MEMORY
>>>     mm,migrate: use N_MEMORY instead N_HIGH_MEMORY
>>>     mempolicy: use N_MEMORY instead N_HIGH_MEMORY
>>>     hugetlb: use N_MEMORY instead N_HIGH_MEMORY
>>>     vmstat: use N_MEMORY instead N_HIGH_MEMORY
>>>     kthread: use N_MEMORY instead N_HIGH_MEMORY
>>>     init: use N_MEMORY instead N_HIGH_MEMORY
>>>     vmscan: use N_MEMORY instead N_HIGH_MEMORY
>>>     page_alloc: use N_MEMORY instead N_HIGH_MEMORY change the node_states
>>>       initialization
>>>     hotplug: update nodemasks management
>>>     numa: add CONFIG_MOVABLE_NODE for movable-dedicated node
>>>     page_alloc: add kernelcore_max_addr
>>>     mm, memory-hotplug: add online_movable and online_kernel
>>>     memory_hotplug: handle empty zone when online_movable/online_kernel
>>>
>>> Yasuaki Ishimatsu (4):
>>>     x86: get pg_data_t's memory from other node
>>>     x86: use memblock_set_current_limit() to set memblock.current_limit
>>>     memblock: limit memory address from memblock
>>>     memblock: compare current_limit with end variable at
>>>       memblock_find_in_range_node()
>>>
>>>    Documentation/cgroups/cpusets.txt   |    2 +-
>>>    Documentation/kernel-parameters.txt |    9 ++
>>>    Documentation/memory-hotplug.txt    |   24 +++-
>>>    arch/x86/kernel/setup.c             |    4 +-
>>>    arch/x86/mm/init_64.c               |    4 +-
>>>    arch/x86/mm/numa.c                  |    8 +-
>>>    drivers/base/memory.c               |   19 ++-
>>>    drivers/base/node.c                 |   28 +++--
>>>    fs/proc/kcore.c                     |    2 +-
>>>    fs/proc/task_mmu.c                  |    4 +-
>>>    include/linux/cpuset.h              |    2 +-
>>>    include/linux/memblock.h            |    1 +
>>>    include/linux/memory.h              |    2 +
>>>    include/linux/memory_hotplug.h      |   13 ++-
>>>    include/linux/nodemask.h            |    5 +
>>>    init/main.c                         |    2 +-
>>>    kernel/cpuset.c                     |   32 ++--
>>>    kernel/kthread.c                    |    2 +-
>>>    mm/Kconfig                          |    8 +
>>>    mm/hugetlb.c                        |   24 ++--
>>>    mm/memblock.c                       |   10 +-
>>>    mm/memcontrol.c                     |   18 ++--
>>>    mm/memory_hotplug.c                 |  271 ++++++++++++++++++++++++++++++++---
>>>    mm/mempolicy.c                      |   12 +-
>>>    mm/migrate.c                        |    2 +-
>>>    mm/oom_kill.c                       |    2 +-
>>>    mm/page_alloc.c                     |   96 ++++++++-----
>>>    mm/page_cgroup.c                    |    2 +-
>>>    mm/slub.c                           |    4 +-
>>>    mm/vmscan.c                         |    4 +-
>>>    mm/vmstat.c                         |    4 +-
>>>    31 files changed, 476 insertions(+), 144 deletions(-)
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>
>>
>>
>


