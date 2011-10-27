Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab1J0FUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 01:20:48 -0400
Received: from [61.129.102.50] ([61.129.102.50]:17444 "EHLO mail.eln.com.cn"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750755Ab1J0FUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 01:20:47 -0400
Message-ID: <4EA8EA22.2070102@iblink.com.cn>
Date: Thu, 27 Oct 2011 13:20:34 +0800
From: Tony <kernel@iblink.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: system hang after kernel kthreadd blocked INFO
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
My mysql servers were hung frequently every day.
All 5 mysql server.
Server OS include: fedora 11,fedora 14,fedora 15  x86_64
filesystem include: ext4,xfs
Hardware: dell R410
RAID card is "ioc0: LSISAS1068E B3: Capabilities={Initiator}" ,use 
driver mptsas and I was checked raid by using lsiutil, raid is fine.
memory size includes 16G and 32G.

The kernel which I have userd include 3.0.* and 3.1.*-rc*.Alway hung and 
messages are same.
After system alarms "INFO:.......", all operations don't responsed 
anymore,except ping from other PC,ssh  doesn't responsed too.
Could someone help me? Thanks!!!

info in /var/log/messages is:
Oct 27 11:26:38 db3 kernel: [125110.089507] INFO: task kthreadd:2 
blocked for more than 120 seconds.
Oct 27 11:26:38 db3 kernel: [125110.089548] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 27 11:26:38 db3 kernel: [125110.089606] kthreadd        D 
0000000000000000     0     2      0 0x00000000
Oct 27 11:26:38 db3 kernel: [125110.089656]  ffff88080b82b000 
0000000000000046 0000000000000000 ffff8807fb15c000
Oct 27 11:26:38 db3 kernel: [125110.089717]  ffff88080b863fd8 
ffff88080b863fd8 ffff88080b863fd8 ffff88080b82b000
Oct 27 11:26:38 db3 kernel: [125110.089777]  ffff88082fd113f8 
0000000000000000 ffff88080b82b000 ffff88080b82b048
Oct 27 11:26:38 db3 kernel: [125110.089837] Call Trace:
Oct 27 11:26:38 db3 kernel: [125110.089868]  [<ffffffff8102eff7>] ? 
pick_next_task_fair+0xb7/0x100
Oct 27 11:26:38 db3 kernel: [125110.089903]  [<ffffffff8102abaf>] ? 
__wake_up_common+0x4f/0x80
Oct 27 11:26:38 db3 kernel: [125110.089937]  [<ffffffff811f3d72>] ? 
delay_tsc+0x42/0x80
Oct 27 11:26:38 db3 kernel: [125110.089968]  [<ffffffff811ee248>] ? 
__prop_inc_single+0x28/0x50
Oct 27 11:26:38 db3 kernel: [125110.090002]  [<ffffffff81090f10>] ? 
__lock_page+0x70/0x70
Oct 27 11:26:38 db3 kernel: [125110.090035]  [<ffffffff81397c26>] ? 
io_schedule+0x56/0x80
Oct 27 11:26:38 db3 kernel: [125110.090067]  [<ffffffff81090f19>] ? 
sleep_on_page+0x9/0x10
Oct 27 11:26:38 db3 kernel: [125110.090098]  [<ffffffff8139810f>] ? 
__wait_on_bit+0x4f/0x80
Oct 27 11:26:38 db3 kernel: [125110.090130]  [<ffffffff810910cf>] ? 
wait_on_page_bit+0x6f/0x80
Oct 27 11:26:38 db3 kernel: [125110.090164]  [<ffffffff81059c00>] ? 
autoremove_wake_function+0x30/0x30
Oct 27 11:26:38 db3 kernel: [125110.090199]  [<ffffffff8109e975>] ? 
shrink_page_list+0x405/0x810
Oct 27 11:26:38 db3 kernel: [125110.090231]  [<ffffffff8109efa2>] ? 
putback_lru_pages+0x222/0x290
Oct 27 11:26:38 db3 kernel: [125110.090267]  [<ffffffff8109d567>] ? 
update_isolated_counts+0x147/0x170
Oct 27 11:26:38 db3 kernel: [125110.090301]  [<ffffffff8109f255>] ? 
shrink_inactive_list+0x245/0x3d0
Oct 27 11:26:38 db3 kernel: [125110.090335]  [<ffffffff811f3d72>] ? 
delay_tsc+0x42/0x80
Oct 27 11:26:38 db3 kernel: [125110.090366]  [<ffffffff8109f832>] ? 
shrink_zone+0x452/0x5f0
Oct 27 11:26:38 db3 kernel: [125110.090399]  [<ffffffff810a6127>] ? 
wait_iff_congested+0xa7/0x100
Oct 27 11:26:38 db3 kernel: [125110.090431]  [<ffffffff81059bd0>] ? 
__init_waitqueue_head+0x30/0x30
Oct 27 11:26:38 db3 kernel: [125110.090465]  [<ffffffff810a02bd>] ? 
do_try_to_free_pages+0x9d/0x3e0
Oct 27 11:26:38 db3 kernel: [125110.090499]  [<ffffffff810a0708>] ? 
try_to_free_pages+0x78/0x80
Oct 27 11:26:38 db3 kernel: [125110.090532]  [<ffffffff81097f00>] ? 
__alloc_pages_nodemask+0x4d0/0x7f0
Oct 27 11:26:38 db3 kernel: [125110.090568]  [<ffffffff8103c83b>] ? 
copy_process+0xfb/0x1260
Oct 27 11:26:38 db3 kernel: [125110.090601]  [<ffffffff81000ca8>] ? 
__switch_to+0xc8/0x310
Oct 27 11:26:38 db3 kernel: [125110.090633]  [<ffffffff8103daec>] ? 
do_fork+0x10c/0x240
Oct 27 11:26:38 db3 kernel: [125110.090664]  [<ffffffff81397602>] ? 
__schedule+0x372/0x860
Oct 27 11:26:38 db3 kernel: [125110.090697]  [<ffffffff81009661>] ? 
kernel_thread+0x81/0x90
Oct 27 11:26:38 db3 kernel: [125110.090729]  [<ffffffff810593b0>] ? 
__init_kthread_worker+0x30/0x30
Oct 27 11:26:38 db3 kernel: [125110.090764]  [<ffffffff8139baf0>] ? 
gs_change+0x13/0x13
Oct 27 11:26:38 db3 kernel: [125110.090795]  [<ffffffff8105976d>] ? 
kthreadd+0xfd/0x140
Oct 27 11:26:38 db3 kernel: [125110.090826]  [<ffffffff8139baf4>] ? 
kernel_thread_helper+0x4/0x10
Oct 27 11:26:38 db3 kernel: [125110.090859]  [<ffffffff81059670>] ? 
tsk_fork_get_node+0x10/0x10
Oct 27 11:26:38 db3 kernel: [125110.090892]  [<ffffffff8139baf0>] ? 
gs_change+0x13/0x13
Oct 27 11:26:38 db3 kernel: [125110.090933] INFO: task irqbalance:819 
blocked for more than 120 seconds.
Oct 27 11:26:38 db3 kernel: [125110.090966] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 27 11:26:38 db3 kernel: [125110.091017] irqbalance      D 
0000000000000000     0   819      1 0x00000000
Oct 27 11:26:38 db3 kernel: [125110.091056]  ffff8807f9dbe000 
0000000000000086 0000000000000000 ffff8807fb179000
Oct 27 11:26:38 db3 kernel: [125110.091116]  ffff8807f2e9ffd8 
ffff8807f2e9ffd8 ffff8807f2e9ffd8 ffff8807f9dbe000
Oct 27 11:26:38 db3 kernel: [125110.091176]  ffff88082fd513f8 
0000000000000000 ffff8807f90eb000 00000000010eb048
Oct 27 11:26:38 db3 kernel: [125110.091236] Call Trace:
Oct 27 11:26:38 db3 kernel: [125110.091261]  [<ffffffff81399c99>] ? 
_raw_spin_unlock_irq+0x9/0x20
Oct 27 11:26:38 db3 kernel: [125110.091295]  [<ffffffff8102ebe4>] ? 
finish_task_switch+0x64/0xe0
Oct 27 11:26:38 db3 kernel: [125110.091327]  [<ffffffff8102abaf>] ? 
__wake_up_common+0x4f/0x80
Oct 27 11:26:38 db3 kernel: [125110.091360]  [<ffffffff811f3d72>] ? 
delay_tsc+0x42/0x80
Oct 27 11:26:38 db3 kernel: [125110.091391]  [<ffffffff811ee248>] ? 
__prop_inc_single+0x28/0x50
Oct 27 11:26:38 db3 kernel: [125110.091423]  [<ffffffff81090f10>] ? 
__lock_page+0x70/0x70
Oct 27 11:26:38 db3 kernel: [125110.091455]  [<ffffffff81397c26>] ? 
io_schedule+0x56/0x80
Oct 27 11:26:38 db3 kernel: [125110.091486]  [<ffffffff81090f19>] ? 
sleep_on_page+0x9/0x10
Oct 27 11:26:38 db3 kernel: [125110.091517]  [<ffffffff8139810f>] ? 
__wait_on_bit+0x4f/0x80
Oct 27 11:26:38 db3 kernel: [125110.091549]  [<ffffffff810910cf>] ? 
wait_on_page_bit+0x6f/0x80
Oct 27 11:26:38 db3 kernel: [125110.091581]  [<ffffffff81059c00>] ? 
autoremove_wake_function+0x30/0x30
Oct 27 11:26:38 db3 kernel: [125110.091615]  [<ffffffff8109e975>] ? 
shrink_page_list+0x405/0x810
Oct 27 11:26:38 db3 kernel: [125110.091648]  [<ffffffff8109efa2>] ? 
putback_lru_pages+0x222/0x290
Oct 27 11:26:38 db3 kernel: [125110.091681]  [<ffffffff8109d567>] ? 
update_isolated_counts+0x147/0x170
Oct 27 11:26:38 db3 kernel: [125110.091715]  [<ffffffff81399c9d>] ? 
_raw_spin_unlock_irq+0xd/0x20
Oct 27 11:26:38 db3 kernel: [125110.091748]  [<ffffffff8109f255>] ? 
shrink_inactive_list+0x245/0x3d0
Oct 27 11:26:38 db3 kernel: [125110.091782]  [<ffffffff811f3d72>] ? 
delay_tsc+0x42/0x80
Oct 27 11:26:38 db3 kernel: [125110.091813]  [<ffffffff8109f832>] ? 
shrink_zone+0x452/0x5f0
Oct 27 11:26:38 db3 kernel: [125110.091845]  [<ffffffff810a6127>] ? 
wait_iff_congested+0xa7/0x100
Oct 27 11:26:38 db3 kernel: [125110.091878]  [<ffffffff81059bd0>] ? 
__init_waitqueue_head+0x30/0x30
Oct 27 11:26:38 db3 kernel: [125110.091911]  [<ffffffff810a02bd>] ? 
do_try_to_free_pages+0x9d/0x3e0
Oct 27 11:26:38 db3 kernel: [125110.091945]  [<ffffffff810a0708>] ? 
try_to_free_pages+0x78/0x80
Oct 27 11:26:38 db3 kernel: [125110.091978]  [<ffffffff81097f00>] ? 
__alloc_pages_nodemask+0x4d0/0x7f0
Oct 27 11:26:38 db3 kernel: [125110.092014]  [<ffffffff810c9f21>] ? 
new_slab+0x61/0x210
Oct 27 11:26:38 db3 kernel: [125110.092047]  [<ffffffff81393f59>] ? 
__slab_alloc.constprop.17+0x157/0x266
Oct 27 11:26:38 db3 kernel: [125110.092083]  [<ffffffff81132739>] ? 
stat_open+0x49/0xb0
Oct 27 11:26:38 db3 kernel: [125110.092116]  [<ffffffff810f34c8>] ? 
inode_init_always+0xe8/0x1a0
Oct 27 11:26:38 db3 kernel: [125110.092149]  [<ffffffff810fa2e0>] ? 
seq_release_private+0x60/0x60
Oct 27 11:26:38 db3 kernel: [125110.092182]  [<ffffffff810cabc7>] ? 
__kmalloc+0x117/0x170
Oct 27 11:26:38 db3 kernel: [125110.092214]  [<ffffffff81132739>] ? 
stat_open+0x49/0xb0
Oct 27 11:26:38 db3 kernel: [125110.092245]  [<ffffffff8112a535>] ? 
proc_reg_open+0xa5/0x190
Oct 27 11:26:38 db3 kernel: [125110.092277]  [<ffffffff811326f0>] ? 
meminfo_proc_show+0x4c0/0x4c0
Oct 27 11:26:38 db3 kernel: [125110.092310]  [<ffffffff8112a490>] ? 
proc_alloc_inode+0xa0/0xa0
Oct 27 11:26:38 db3 kernel: [125110.092344]  [<ffffffff810d9698>] ? 
__dentry_open+0x108/0x2f0
Oct 27 11:26:38 db3 kernel: [125110.092377]  [<ffffffff810e94e4>] ? 
do_last+0x1e4/0x820
Oct 27 11:26:38 db3 kernel: [125110.092409]  [<ffffffff810e7e65>] ? 
path_init+0x2e5/0x3c0
Oct 27 11:26:38 db3 kernel: [125110.092440]  [<ffffffff810e9d68>] ? 
path_openat+0xd8/0x3f0
Oct 27 11:26:38 db3 kernel: [125110.092472]  [<ffffffff810ea0e5>] ? 
do_filp_open+0x45/0xb0
Oct 27 11:26:38 db3 kernel: [125110.092504]  [<ffffffff810f5c44>] ? 
alloc_fd+0xe4/0x140
Oct 27 11:26:38 db3 kernel: [125110.092536]  [<ffffffff810daa37>] ? 
do_sys_open+0xf7/0x1e0
Oct 27 11:26:38 db3 kernel: [125110.092568]  [<ffffffff8139a612>] ? 
system_call_fastpath+0x16/0x1b
Oct 27 11:26:38 db3 kernel: [125110.092605] INFO: task mysqld:1465 
blocked for more than 120 seconds.
Oct 27 11:26:38 db3 kernel: [125110.092637] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 27 11:26:38 db3 kernel: [125110.092689] mysqld          D 
0000000000000000     0  1465   1203 0x00000000
Oct 27 11:26:38 db3 kernel: [125110.092728]  ffff8807f2829000 
0000000000000086 ffff8807f8a47ac8 ffff8807fb179000
Oct 27 11:26:38 db3 kernel: [125110.092788]  ffff8807f8a47fd8 
ffff8807f8a47fd8 ffff8807f8a47fd8 ffff8807f2829000
Oct 27 11:26:38 db3 kernel: [125110.092847]  ffff8807f8a47fd8 
ffffffff812e6670 ffff880733e6db40 ffff8807f2829000
Oct 27 11:26:38 db3 kernel: [125110.092907] Call Trace:
Oct 27 11:26:38 db3 kernel: [125110.092934]  [<ffffffff812e6670>] ? 
dm_request+0x100/0x1b0
Oct 27 11:26:38 db3 kernel: [125110.092967]  [<ffffffff811db708>] ? 
generic_make_request+0x228/0x330
Oct 27 11:26:38 db3 kernel: [125110.093001]  [<ffffffff812e5e1f>] ? 
dm_merge_bvec+0xdf/0x150
Oct 27 11:26:38 db3 kernel: [125110.093033]  [<ffffffff811db86c>] ? 
submit_bio+0x5c/0xd0
Oct 27 11:26:38 db3 kernel: [125110.093064]  [<ffffffff81397c26>] ? 
io_schedule+0x56/0x80
Oct 27 11:26:38 db3 kernel: [125110.093098]  [<ffffffff8110d85f>] ? 
__blockdev_direct_IO+0x90f/0xc10
Oct 27 11:26:38 db3 kernel: [125110.093134]  [<ffffffff81185940>] ? 
xfs_mru_cache_done+0x10/0x10
Oct 27 11:26:38 db3 kernel: [125110.093168]  [<ffffffff8117699a>] ? 
xfs_vm_direct_IO+0xaa/0x130
Oct 27 11:26:38 db3 kernel: [125110.093201]  [<ffffffff81176f50>] ? 
__xfs_get_blocks+0x3c0/0x3c0
Oct 27 11:26:38 db3 kernel: [125110.093234]  [<ffffffff81176af0>] ? 
xfs_finish_ioend_sync+0x20/0x20
Oct 27 11:26:38 db3 kernel: [125110.093267]  [<ffffffff810f2a1a>] ? 
file_update_time+0xfa/0x180
Oct 27 11:26:38 db3 kernel: [125110.093300]  [<ffffffff810921e5>] ? 
generic_file_direct_write+0xe5/0x1c0
Oct 27 11:26:38 db3 kernel: [125110.093335]  [<ffffffff81394f39>] ? 
xfs_file_dio_aio_write+0x1b0/0x1bf
Oct 27 11:26:38 db3 kernel: [125110.093369]  [<ffffffff8117cf48>] ? 
xfs_file_aio_write+0x298/0x2b0
Oct 27 11:26:38 db3 kernel: [125110.093405]  [<ffffffff8106990a>] ? 
futex_wake+0xfa/0x120
Oct 27 11:26:38 db3 kernel: [125110.093437]  [<ffffffff810dae18>] ? 
do_sync_write+0xb8/0xf0
Oct 27 11:26:38 db3 kernel: [125110.093468]  [<ffffffff81399c99>] ? 
_raw_spin_unlock_irq+0x9/0x20
Oct 27 11:26:38 db3 kernel: [125110.093502]  [<ffffffff8102ebe4>] ? 
finish_task_switch+0x64/0xe0
Oct 27 11:26:38 db3 kernel: [125110.093535]  [<ffffffff810db58a>] ? 
vfs_write+0xaa/0x170
Oct 27 11:26:38 db3 kernel: [125110.093566]  [<ffffffff810dba03>] ? 
sys_pwrite64+0x83/0xa0
Oct 27 11:26:38 db3 kernel: [125110.093598]  [<ffffffff8139a612>] ? 
system_call_fastpath+0x16/0x1b
Oct 27 11:26:38 db3 kernel: [125110.093631] INFO: task mysqld:1466 
blocked for more than 120 seconds.
Oct 27 11:26:38 db3 kernel: [125110.093663] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 27 11:26:38 db3 kernel: [125110.093715] mysqld          D 
0000000000000000     0  1466   1203 0x00000000
Oct 27 11:26:38 db3 kernel: [125110.093754]  ffff8807f282a000 
0000000000000086 ffff8807f2c29ac8 ffff8803112c7000
Oct 27 11:26:38 db3 kernel: [125110.095057]  ffff8807f2c29fd8 
ffff8807f2c29fd8 ffff8807f2c29fd8 ffff8807f282a000
Oct 27 11:26:38 db3 kernel: [125110.095117]  ffff8807f2c29fd8 
ffffffff812e6670 ffff88049bdae9c0 ffff8807f282a000
Oct 27 11:26:38 db3 kernel: [125110.095176] Call Trace:
Oct 27 11:26:38 db3 kernel: [125110.095201]  [<ffffffff812e6670>] ? 
dm_request+0x100/0x1b0
Oct 27 11:26:38 db3 kernel: [125110.095233]  [<ffffffff811db708>] ? 
generic_make_request+0x228/0x330
Oct 27 11:26:38 db3 kernel: [125110.095267]  [<ffffffff812e5e1f>] ? 
dm_merge_bvec+0xdf/0x150
Oct 27 11:26:38 db3 kernel: [125110.095299]  [<ffffffff811db86c>] ? 
submit_bio+0x5c/0xd0
Oct 27 11:26:38 db3 kernel: [125110.095330]  [<ffffffff81397c26>] ? 
io_schedule+0x56/0x80
Oct 27 11:26:38 db3 kernel: [125110.095361]  [<ffffffff8110d85f>] ? 
__blockdev_direct_IO+0x90f/0xc10
Oct 27 11:26:38 db3 kernel: [125110.095395]  [<ffffffff8117699a>] ? 
xfs_vm_direct_IO+0xaa/0x130
Oct 27 11:26:38 db3 kernel: [125110.095428]  [<ffffffff81176f50>] ? 
__xfs_get_blocks+0x3c0/0x3c0
Oct 27 11:26:38 db3 kernel: [125110.095462]  [<ffffffff81176af0>] ? 
xfs_finish_ioend_sync+0x20/0x20
Oct 27 11:26:38 db3 kernel: [125110.095495]  [<ffffffff810f2a1a>] ? 
file_update_time+0xfa/0x180
Oct 27 11:26:38 db3 kernel: [125110.095527]  [<ffffffff810921e5>] ? 
generic_file_direct_write+0xe5/0x1c0
Oct 27 11:26:38 db3 kernel: [125110.095562]  [<ffffffff81394f39>] ? 
xfs_file_dio_aio_write+0x1b0/0x1bf
Oct 27 11:26:38 db3 kernel: [125110.095596]  [<ffffffff810692d1>] ? 
get_futex_key+0x161/0x2c0
Oct 27 11:26:38 db3 kernel: [125110.095629]  [<ffffffff8117cf48>] ? 
xfs_file_aio_write+0x298/0x2b0
Oct 27 11:26:38 db3 kernel: [125110.095662]  [<ffffffff810dae18>] ? 
do_sync_write+0xb8/0xf0
Oct 27 11:26:38 db3 kernel: [125110.095694]  [<ffffffff81110157>] ? 
fsnotify+0x27/0x300
Oct 27 11:26:38 db3 kernel: [125110.095726]  [<ffffffff810db58a>] ? 
vfs_write+0xaa/0x170
Oct 27 11:26:38 db3 kernel: [125110.095757]  [<ffffffff810dba03>] ? 
sys_pwrite64+0x83/0xa0
Oct 27 11:26:38 db3 kernel: [125110.095789]  [<ffffffff8139a612>] ? 
system_call_fastpath+0x16/0x1b
Oct 27 11:26:38 db3 kernel: [125110.095822] INFO: task mysqld:1467 
blocked for more than 120 seconds.
Oct 27 11:26:38 db3 kernel: [125110.095854] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 27 11:26:38 db3 kernel: [125110.095906] mysqld          D 
0000000000000000     0  1467   1203 0x00000000
Oct 27 11:26:38 db3 kernel: [125110.095945]  ffff8807f282e000 
0000000000000086 ffff8807f2c2bac8 ffff8807fb179000
Oct 27 11:26:38 db3 kernel: [125110.096005]  ffff8807f2c2bfd8 
ffff8807f2c2bfd8 ffff8807f2c2bfd8 ffff8807f282e000
Oct 27 11:26:38 db3 kernel: [125110.096064]  ffff8807f2c2bfd8 
ffffffff812e6670 ffff8803286d26c0 ffff8807f282e000
Oct 27 11:26:38 db3 kernel: [125110.096124] Call Trace:
Oct 27 11:26:38 db3 kernel: [125110.096149]  [<ffffffff812e6670>] ? 
dm_request+0x100/0x1b0
Oct 27 11:26:38 db3 kernel: [125110.096181]  [<ffffffff811db708>] ? 
generic_make_request+0x228/0x330
Oct 27 11:26:38 db3 kernel: [125110.096214]  [<ffffffff812e5e1f>] ? 
dm_merge_bvec+0xdf/0x150
Oct 27 11:26:38 db3 kernel: [125110.096246]  [<ffffffff811db86c>] ? 
submit_bio+0x5c/0xd0
Oct 27 11:26:38 db3 kernel: [125110.096278]  [<ffffffff81397c26>] ? 
io_schedule+0x56/0x80
Oct 27 11:26:38 db3 kernel: [125110.096310]  [<ffffffff8110d85f>] ? 
__blockdev_direct_IO+0x90f/0xc10
Oct 27 11:26:38 db3 kernel: [125110.096344]  [<ffffffff8117699a>] ? 
xfs_vm_direct_IO+0xaa/0x130
Oct 27 11:26:38 db3 kernel: [125110.096376]  [<ffffffff81176f50>] ? 
__xfs_get_blocks+0x3c0/0x3c0
Oct 27 11:26:38 db3 kernel: [125110.096409]  [<ffffffff81176af0>] ? 
xfs_finish_ioend_sync+0x20/0x20
Oct 27 11:26:38 db3 kernel: [125110.096443]  [<ffffffff810f2a1a>] ? 
file_update_time+0xfa/0x180
Oct 27 11:26:38 db3 kernel: [125110.096475]  [<ffffffff810921e5>] ? 
generic_file_direct_write+0xe5/0x1c0
Oct 27 11:26:38 db3 kernel: [125110.096510]  [<ffffffff81394f39>] ? 
xfs_file_dio_aio_write+0x1b0/0x1bf
Oct 27 11:26:38 db3 kernel: [125110.096544]  [<ffffffff8117cf48>] ? 
xfs_file_aio_write+0x298/0x2b0
Oct 27 11:26:38 db3 kernel: [125110.096578]  [<ffffffff8106990a>] ? 
futex_wake+0xfa/0x120
Oct 27 11:26:38 db3 kernel: [125110.096609]  [<ffffffff810dae18>] ? 
do_sync_write+0xb8/0xf0
Oct 27 11:26:38 db3 kernel: [125110.096643]  [<ffffffff8105e163>] ? 
__srcu_read_lock+0x23/0x30
Oct 27 11:26:38 db3 kernel: [125110.096676]  [<ffffffff810db58a>] ? 
vfs_write+0xaa/0x170
Oct 27 11:26:38 db3 kernel: [125110.096707]  [<ffffffff810dba03>] ? 
sys_pwrite64+0x83/0xa0
Oct 27 11:26:38 db3 kernel: [125110.096739]  [<ffffffff8139a612>] ? 
system_call_fastpath+0x16/0x1b
Oct 27 11:26:38 db3 kernel: [125110.096772] INFO: task mysqld:1468 
blocked for more than 120 seconds.
Oct 27 11:26:38 db3 kernel: [125110.096805] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 27 11:26:38 db3 kernel: [125110.096856] mysqld          D 
0000000000000000     0  1468   1203 0x00000000
Oct 27 11:26:38 db3 kernel: [125110.096895]  ffff8807f2828000 
0000000000000086 ffff8807f1a8dac8 ffff8807fb1ab000
Oct 27 11:26:38 db3 kernel: [125110.096955]  ffff8807f1a8dfd8 
ffff8807f1a8dfd8 ffff8807f1a8dfd8 ffff8807f2828000
Oct 27 11:26:38 db3 kernel: [125110.097015]  ffff8807f1a8dfd8 
ffffffff812e6670 ffff88031a58fc00 ffff8807f2828000
Oct 27 11:26:38 db3 kernel: [125110.097074] Call Trace:
Oct 27 11:26:38 db3 kernel: [125110.097100]  [<ffffffff812e6670>] ? 
dm_request+0x100/0x1b0
Oct 27 11:26:38 db3 kernel: [125110.097131]  [<ffffffff811db708>] ? 
generic_make_request+0x228/0x330
Oct 27 11:26:38 db3 kernel: [125110.097165]  [<ffffffff812e5e1f>] ? 
dm_merge_bvec+0xdf/0x150
Oct 27 11:26:38 db3 kernel: [125110.097197]  [<ffffffff811db86c>] ? 
submit_bio+0x5c/0xd0
Oct 27 11:26:38 db3 kernel: [125110.097228]  [<ffffffff81397c26>] ? 
io_schedule+0x56/0x80
Oct 27 11:26:38 db3 kernel: [125110.097260]  [<ffffffff8110d85f>] ? 
__blockdev_direct_IO+0x90f/0xc10
Oct 27 11:26:38 db3 kernel: [125110.097294]  [<ffffffff8117699a>] ? 
xfs_vm_direct_IO+0xaa/0x130
Oct 27 11:26:38 db3 kernel: [125110.097327]  [<ffffffff81176f50>] ? 
__xfs_get_blocks+0x3c0/0x3c0
Oct 27 11:26:38 db3 kernel: [125110.097360]  [<ffffffff81176af0>] ? 
xfs_finish_ioend_sync+0x20/0x20
Oct 27 11:26:38 db3 kernel: [125110.097393]  [<ffffffff810f2a1a>] ? 
file_update_time+0xfa/0x180
Oct 27 11:26:38 db3 kernel: [125110.097426]  [<ffffffff810921e5>] ? 
generic_file_direct_write+0xe5/0x1c0
Oct 27 11:26:38 db3 kernel: [125110.097461]  [<ffffffff81394f39>] ? 
xfs_file_dio_aio_write+0x1b0/0x1bf
Oct 27 11:26:38 db3 kernel: [125110.097495]  [<ffffffff810692d1>] ? 
get_futex_key+0x161/0x2c0
Oct 27 11:26:38 db3 kernel: [125110.097527]  [<ffffffff8117cf48>] ? 
xfs_file_aio_write+0x298/0x2b0
Oct 27 11:26:38 db3 kernel: [125110.097561]  [<ffffffff810dae18>] ? 
do_sync_write+0xb8/0xf0
Oct 27 11:26:38 db3 kernel: [125110.097593]  [<ffffffff81110310>] ? 
fsnotify+0x1e0/0x300
Oct 27 11:26:38 db3 kernel: [125110.097624]  [<ffffffff810db58a>] ? 
vfs_write+0xaa/0x170
Oct 27 11:26:38 db3 kernel: [125110.097656]  [<ffffffff810dba03>] ? 
sys_pwrite64+0x83/0xa0
Oct 27 11:26:38 db3 kernel: [125110.097688]  [<ffffffff8139a612>] ? 
system_call_fastpath+0x16/0x1b
Oct 27 11:26:38 db3 kernel: [125110.097767] INFO: task mysqld:22040 
blocked for more than 120 seconds.
Oct 27 11:26:38 db3 kernel: [125110.097799] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 27 11:26:38 db3 kernel: [125110.097850] mysqld          D 
0000000000000000     0 22040   1203 0x00000000
Oct 27 11:26:38 db3 kernel: [125110.097890]  ffff8806f3741000 
0000000000000086 ffff88055dbffac8 ffff8807fb114000
Oct 27 11:26:38 db3 kernel: [125110.097950]  ffff88055dbfffd8 
ffff88055dbfffd8 ffff88055dbfffd8 ffff8806f3741000
Oct 27 11:26:38 db3 kernel: [125110.098009]  ffff88055dbfffd8 
ffffffff812e6670 ffff8806fa001300 ffff8806f3741000
Oct 27 11:26:38 db3 kernel: [125110.098069] Call Trace:
Oct 27 11:26:38 db3 kernel: [125110.098094]  [<ffffffff812e6670>] ? 
dm_request+0x100/0x1b0
Oct 27 11:26:38 db3 kernel: [125110.098126]  [<ffffffff811db708>] ? 
generic_make_request+0x228/0x330
Oct 27 11:26:38 db3 kernel: [125110.098159]  [<ffffffff812e5e1f>] ? 
dm_merge_bvec+0xdf/0x150
Oct 27 11:26:38 db3 kernel: [125110.098191]  [<ffffffff811db86c>] ? 
submit_bio+0x5c/0xd0
Oct 27 11:26:38 db3 kernel: [125110.098223]  [<ffffffff81397c26>] ? 
io_schedule+0x56/0x80
Oct 27 11:26:38 db3 kernel: [125110.098254]  [<ffffffff8110d85f>] ? 
__blockdev_direct_IO+0x90f/0xc10
Oct 27 11:26:38 db3 kernel: [125110.098289]  [<ffffffff8117699a>] ? 
xfs_vm_direct_IO+0xaa/0x130
Oct 27 11:26:38 db3 kernel: [125110.098321]  [<ffffffff81176f50>] ? 
__xfs_get_blocks+0x3c0/0x3c0
Oct 27 11:26:38 db3 kernel: [125110.098354]  [<ffffffff81176af0>] ? 
xfs_finish_ioend_sync+0x20/0x20
Oct 27 11:26:38 db3 kernel: [125110.098388]  [<ffffffff810f2a1a>] ? 
file_update_time+0xfa/0x180
Oct 27 11:26:38 db3 kernel: [125110.098420]  [<ffffffff810921e5>] ? 
generic_file_direct_write+0xe5/0x1c0
Oct 27 11:26:38 db3 kernel: [125110.098455]  [<ffffffff81394f39>] ? 
xfs_file_dio_aio_write+0x1b0/0x1bf
Oct 27 11:26:38 db3 kernel: [125110.098489]  [<ffffffff8117cf48>] ? 
xfs_file_aio_write+0x298/0x2b0
Oct 27 11:26:38 db3 kernel: [125110.098523]  [<ffffffff8106990a>] ? 
futex_wake+0xfa/0x120
Oct 27 11:26:38 db3 kernel: [125110.098554]  [<ffffffff810dae18>] ? 
do_sync_write+0xb8/0xf0
Oct 27 11:26:38 db3 kernel: [125110.098587]  [<ffffffff810db58a>] ? 
vfs_write+0xaa/0x170
Oct 27 11:26:38 db3 kernel: [125110.098618]  [<ffffffff810dba03>] ? 
sys_pwrite64+0x83/0xa0
Oct 27 11:26:38 db3 kernel: [125110.098650]  [<ffffffff8139a612>] ? 
system_call_fastpath+0x16/0x1b
Oct 27 11:26:38 db3 kernel: [125110.098758] INFO: task kworker/u:0:25606 
blocked for more than 120 seconds.
Oct 27 11:26:38 db3 kernel: [125110.098792] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 27 11:26:38 db3 kernel: [125110.098843] kworker/u:0     D 
0000000000000000     0 25606      2 0x00000000
Oct 27 11:26:38 db3 kernel: [125110.098882]  ffff8807f2bb7000 
0000000000000046 ffff88078ef99e4c ffff88080b82b000
Oct 27 11:26:38 db3 kernel: [125110.098943]  ffff88078ef99fd8 
ffff88078ef99fd8 ffff88078ef99fd8 ffff8807f2bb7000
Oct 27 11:26:38 db3 kernel: [125110.099002]  0000000000000200 
ffff8807f2bb7000 0000004000000040 0000000000000282
Oct 27 11:26:38 db3 kernel: [125110.099062] Call Trace:
Oct 27 11:26:38 db3 kernel: [125110.099088]  [<ffffffff8102b779>] ? 
sched_slice+0x49/0x90
Oct 27 11:26:38 db3 kernel: [125110.099121]  [<ffffffff811e9dcd>] ? 
cpumask_next_and+0x2d/0x40
Oct 27 11:26:38 db3 kernel: [125110.099154]  [<ffffffff8102d035>] ? 
select_task_rq_fair+0x825/0x950
Oct 27 11:26:38 db3 kernel: [125110.099189]  [<ffffffff812011e0>] ? 
swiotlb_dma_mapping_error+0x10/0x20
Oct 27 11:26:38 db3 kernel: [125110.099223]  [<ffffffff811e9dcd>] ? 
cpumask_next_and+0x2d/0x40
Oct 27 11:26:38 db3 kernel: [125110.099256]  [<ffffffff81398005>] ? 
schedule_timeout+0x195/0x1f0
Oct 27 11:26:38 db3 kernel: [125110.099289]  [<ffffffff8102c349>] ? 
check_preempt_wakeup+0x149/0x210
Oct 27 11:26:38 db3 kernel: [125110.099322]  [<ffffffff81396fdd>] ? 
wait_for_common+0xdd/0x1a0
Oct 27 11:26:38 db3 kernel: [125110.099355]  [<ffffffff81036070>] ? 
try_to_wake_up+0x290/0x290
Oct 27 11:26:38 db3 kernel: [125110.099387]  [<ffffffff81059544>] ? 
kthread_create_on_node+0x94/0x120
Oct 27 11:26:38 db3 kernel: [125110.099431]  [<ffffffff810552b0>] ? 
rescuer_thread+0x240/0x240
Oct 27 11:26:38 db3 kernel: [125110.099466]  [<ffffffff810ca598>] ? 
kmem_cache_alloc+0x98/0xb0
Oct 27 11:26:38 db3 kernel: [125110.099502]  [<ffffffff81053073>] ? 
create_worker+0xb3/0x1a0
Oct 27 11:26:38 db3 kernel: [125110.099537]  [<ffffffff81053405>] ? 
manage_workers+0x115/0x210
Oct 27 11:26:38 db3 kernel: [125110.099573]  [<ffffffff8105555a>] ? 
worker_thread+0x2aa/0x330
Oct 27 11:26:38 db3 kernel: [125110.099607]  [<ffffffff810552b0>] ? 
rescuer_thread+0x240/0x240
Oct 27 11:26:38 db3 kernel: [125110.099639]  [<ffffffff8105942e>] ? 
kthread+0x7e/0x90
Oct 27 11:26:38 db3 kernel: [125110.099670]  [<ffffffff8139baf4>] ? 
kernel_thread_helper+0x4/0x10
Oct 27 11:26:38 db3 kernel: [125110.099703]  [<ffffffff810593b0>] ? 
__init_kthread_worker+0x30/0x30
Oct 27 11:26:38 db3 kernel: [125110.099737]  [<ffffffff8139baf0>] ? 
gs_change+0x13/0x13


dmesg:
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.1.0 (root@db3) (gcc version 4.6.0 
20110603 (Red Hat 4.6.0-10) (GCC) ) #1 SMP Tue Oct 25 16:51:49 CST 2011
[    0.000000] Command line: ro 
root=UUID=3b925ad3-1530-4efa-85ea-2b497a73f9fa rd_NO_LUKS rd_NO_LVM 
rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYTABLE=us
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cf379000 (usable)
[    0.000000]  BIOS-e820: 00000000cf379000 - 00000000cf38f000 (reserved)
[    0.000000]  BIOS-e820: 00000000cf38f000 - 00000000cf3ce000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cf3ce000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fe000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000830000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: Dell Inc. PowerEdge R410/0WWR83, BIOS 1.6.3 02/07/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 
(usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 
(usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x830000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-EBFFF uncachable
[    0.000000]   EC000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 base 0080000000 mask FFC0000000 write-back
[    0.000000]   2 base 00C0000000 mask FFF0000000 write-back
[    0.000000]   3 base 0100000000 mask FF00000000 write-back
[    0.000000]   4 base 0200000000 mask FE00000000 write-back
[    0.000000]   5 base 0400000000 mask FC00000000 write-back
[    0.000000]   6 base 0800000000 mask FFE0000000 write-back
[    0.000000]   7 base 0820000000 mask FFF0000000 write-back
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106
[    0.000000] e820 update range: 00000000d0000000 - 0000000100000000 
(usable) ==> (reserved)
[    0.000000] last_pfn = 0xcf379 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009c000] 9c000 size 8192
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000cf379000
[    0.000000]  0000000000 - 00c0000000 page 1G
[    0.000000]  00c0000000 - 00cf200000 page 2M
[    0.000000]  00cf200000 - 00cf379000 page 4k
[    0.000000] kernel direct mapping tables up to cf379000 @ 
1fffd000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-0000000830000000
[    0.000000]  0100000000 - 0800000000 page 1G
[    0.000000]  0800000000 - 0830000000 page 2M
[    0.000000] kernel direct mapping tables up to 830000000 @ 
cf377000-cf379000
[    0.000000] RAMDISK: 37bf5000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f10c0 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000000f11c4 0009C (v01 DELL   PE_SC3 
00000001 DELL 00000001)
[    0.000000] ACPI: FACP 00000000cf3b3f9c 000F4 (v03 DELL   PE_SC3 
00000001 DELL 00000001)
[    0.000000] ACPI: DSDT 00000000cf38f000 03B51 (v01 DELL   PE_SC3 
00000001 INTL 20050624)
[    0.000000] ACPI: FACS 00000000cf3b6000 00040
[    0.000000] ACPI: APIC 00000000cf3b3478 0015E (v01 DELL   PE_SC3 
00000001 DELL 00000001)
[    0.000000] ACPI: SPCR 00000000cf3b35d8 00050 (v01 DELL   PE_SC3 
00000001 DELL 00000001)
[    0.000000] ACPI: HPET 00000000cf3b362c 00038 (v01 DELL   PE_SC3 
00000001 DELL 00000001)
[    0.000000] ACPI: DM__ 00000000cf3b3668 001C0 (v01 DELL   PE_SC3 
00000001 DELL 00000001)
[    0.000000] ACPI: MCFG 00000000cf3b38c4 0003C (v01 DELL   PE_SC3 
00000001 DELL 00000001)
[    0.000000] ACPI: WD__ 00000000cf3b3904 00134 (v01 DELL   PE_SC3 
00000001 DELL 00000001)
[    0.000000] ACPI: SLIC 00000000cf3b3a3c 00024 (v01 DELL   PE_SC3 
00000001 DELL 00000001)
[    0.000000] ACPI: ERST 00000000cf392cd4 00270 (v01 DELL   PE_SC3 
00000001 DELL 00000001)
[    0.000000] ACPI: HEST 00000000cf392f44 003A8 (v01 DELL   PE_SC3 
00000001 DELL 00000001)
[    0.000000] ACPI: BERT 00000000cf392b54 00030 (v01 DELL   PE_SC3 
00000001 DELL 00000001)
[    0.000000] ACPI: EINJ 00000000cf392b84 00150 (v01 DELL   PE_SC3 
00000001 DELL 00000001)
[    0.000000] ACPI: SRAT 00000000cf3b3bc0 00370 (v01 DELL   PE_SC3 
00000001 DELL 00000001)
[    0.000000] ACPI: TCPA 00000000cf3b3f34 00064 (v02 DELL   PE_SC3 
00000001 DELL 00000001)
[    0.000000] ACPI: SSDT 00000000cf3b7000 0220C (v01  INTEL PPM RCM 
80000001 INTL 20061109)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0020bfffff] PMD -> 
[ffff88080f600000-ffff88082f5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00830000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x000000a0
[    0.000000]     0: 0x00000100 -> 0x000cf379
[    0.000000]     0: 0x00100000 -> 0x00830000
[    0.000000] On node 0 totalpages: 8385289
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 4 pages reserved
[    0.000000]   DMA zone: 3916 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 828345 pages, LIFO batch:31
[    0.000000]   Normal zone: 117760 pages used for memmap
[    0.000000]   Normal zone: 7418880 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 
0-23
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec80000] gsi_base[32])
[    0.000000] IOAPIC[1]: apic_id 1, version 32, address 0xfec80000, GSI 
32-55
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 72
[    0.000000] Allocating PCI resources starting at d0000000 (gap: 
d0000000:10000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 
nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88082fc00000 s73792 
r8192 d24512 u262144
[    0.000000] pcpu-alloc: s73792 r8192 d24512 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. 
Total pages: 8251141
[    0.000000] Kernel command line: ro 
root=UUID=3b925ad3-1530-4efa-85ea-2b497a73f9fa rd_NO_LUKS rd_NO_LVM 
rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYTABLE=us
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 4194304 (order: 13, 
33554432 bytes)
[    0.000000] Inode-cache hash table entries: 2097152 (order: 12, 
16777216 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 32888888k/34340864k available (3704k kernel code, 
799708k absent, 652268k reserved, 2839k data, 484k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, 
CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:1288 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 268435456 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't 
want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.010000] Detected 2128.422 MHz processor.
[    0.000004] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 4256.84 BogoMIPS (lpj=21284220)
[    0.000151] pid_max: default: 32768 minimum: 301
[    0.000263] Mount-cache hash table entries: 256
[    0.000480] Initializing cgroup subsys cpuacct
[    0.000555] Initializing cgroup subsys memory
[    0.000632] Initializing cgroup subsys devices
[    0.000724] CPU: Physical Processor ID: 1
[    0.000794] CPU: Processor Core ID: 0
[    0.000867] mce: CPU supports 9 MCE banks
[    0.000946] CPU0: Thermal monitoring enabled (TM1)
[    0.001023] using mwait in idle threads.
[    0.001921] Freeing SMP alternatives: 16k freed
[    0.001999] ACPI: Core revision 20110623
[    0.003682] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.103741] CPU0: Intel(R) Xeon(R) CPU           E5606  @ 2.13GHz 
stepping 02
[    0.218361] Performance Events: PEBS fmt1+, Westmere events, Intel 
PMU driver.
[    0.218592] ... version:                3
[    0.218662] ... bit width:              48
[    0.218731] ... generic registers:      4
[    0.218801] ... value mask:             0000ffffffffffff
[    0.218873] ... max period:             000000007fffffff
[    0.218945] ... fixed-purpose events:   3
[    0.219015] ... event mask:             000000070000000f
[    0.219302] NMI watchdog enabled, takes one hw-pmu counter.
[    0.219450] Booting Node   0, Processors  #1
[    0.219550] smpboot cpu 1: start_ip = 9c000
[    0.398430] NMI watchdog enabled, takes one hw-pmu counter.
[    0.398567]  #2
[    0.398617] smpboot cpu 2: start_ip = 9c000
[    0.578283] NMI watchdog enabled, takes one hw-pmu counter.
[    0.578452]  #3
[    0.578501] smpboot cpu 3: start_ip = 9c000
[    0.758254] NMI watchdog enabled, takes one hw-pmu counter.
[    0.758383]  #4
[    0.758432] smpboot cpu 4: start_ip = 9c000
[    0.938198] NMI watchdog enabled, takes one hw-pmu counter.
[    0.938372]  #5
[    0.938421] smpboot cpu 5: start_ip = 9c000
[    1.118073] NMI watchdog enabled, takes one hw-pmu counter.
[    1.118205]  #6
[    1.118254] smpboot cpu 6: start_ip = 9c000
[    1.298020] NMI watchdog enabled, takes one hw-pmu counter.
[    1.298185]  #7 Ok.
[    1.298251] smpboot cpu 7: start_ip = 9c000
[    1.477895] NMI watchdog enabled, takes one hw-pmu counter.
[    1.477986] Brought up 8 CPUs
[    1.478055] Total of 8 processors activated (34049.19 BogoMIPS).
[    1.483402] NET: Registered protocol family 16
[    1.483546] ACPI FADT declares the system doesn't support PCIe ASPM, 
so disable it
[    1.483641] ACPI: bus type pci registered
[    1.483753] dca service started, version 1.12.1
[    1.483855] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 
0xe0000000-0xefffffff] (base 0xe0000000)
[    1.483954] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    1.511468] PCI: Using configuration type 1 for base access
[    1.512503] bio: create slab <bio-0> at 0
[    1.513819] ACPI: Added _OSI(Module Device)
[    1.513894] ACPI: Added _OSI(Processor Device)
[    1.513965] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.514036] ACPI: Added _OSI(Processor Aggregator Device)
[    1.514679] ACPI: EC: Look up EC in DSDT
[    1.515554] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    1.516540] ACPI: Interpreter enabled
[    1.516610] ACPI: (supports S0 S5)
[    1.516773] ACPI: Using IOAPIC for interrupt routing
[    1.519541] HEST: Table parsing has been initialized.
[    1.519616] PCI: Using host bridge windows from ACPI; if necessary, 
use "pci=nocrs" and report a bug
[    1.519885] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.520090] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.520167] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.520243] pci_root PNP0A08:00: host bridge window [mem 
0x000a0000-0x000bffff]
[    1.520336] pci_root PNP0A08:00: host bridge window [mem 
0xd0000000-0xfdffffff]
[    1.520429] pci_root PNP0A08:00: host bridge window [mem 
0xfed40000-0xfed44fff]
[    1.520539] pci 0000:00:00.0: [8086:3403] type 0 class 0x000600
[    1.520589] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    1.520593] pci 0000:00:00.0: PME# disabled
[    1.520614] pci 0000:00:01.0: [8086:3408] type 1 class 0x000604
[    1.520662] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.520665] pci 0000:00:01.0: PME# disabled
[    1.520686] pci 0000:00:03.0: [8086:340a] type 1 class 0x000604
[    1.520733] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    1.520737] pci 0000:00:03.0: PME# disabled
[    1.520759] pci 0000:00:07.0: [8086:340e] type 1 class 0x000604
[    1.520806] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    1.520810] pci 0000:00:07.0: PME# disabled
[    1.520836] pci 0000:00:14.0: [8086:342e] type 0 class 0x000800
[    1.520900] pci 0000:00:14.1: [8086:3422] type 0 class 0x000800
[    1.520963] pci 0000:00:14.2: [8086:3423] type 0 class 0x000800
[    1.521031] pci 0000:00:16.0: [8086:3430] type 0 class 0x000880
[    1.521045] pci 0000:00:16.0: reg 10: [mem 0xdf0e0000-0xdf0e3fff 64bit]
[    1.521110] pci 0000:00:16.1: [8086:3431] type 0 class 0x000880
[    1.521123] pci 0000:00:16.1: reg 10: [mem 0xdf0e4000-0xdf0e7fff 64bit]
[    1.521186] pci 0000:00:16.2: [8086:3432] type 0 class 0x000880
[    1.521199] pci 0000:00:16.2: reg 10: [mem 0xdf0e8000-0xdf0ebfff 64bit]
[    1.521262] pci 0000:00:16.3: [8086:3433] type 0 class 0x000880
[    1.521275] pci 0000:00:16.3: reg 10: [mem 0xdf0ec000-0xdf0effff 64bit]
[    1.521338] pci 0000:00:16.4: [8086:3429] type 0 class 0x000880
[    1.521351] pci 0000:00:16.4: reg 10: [mem 0xdf0f0000-0xdf0f3fff 64bit]
[    1.521414] pci 0000:00:16.5: [8086:342a] type 0 class 0x000880
[    1.521426] pci 0000:00:16.5: reg 10: [mem 0xdf0f4000-0xdf0f7fff 64bit]
[    1.521489] pci 0000:00:16.6: [8086:342b] type 0 class 0x000880
[    1.521502] pci 0000:00:16.6: reg 10: [mem 0xdf0f8000-0xdf0fbfff 64bit]
[    1.521565] pci 0000:00:16.7: [8086:342c] type 0 class 0x000880
[    1.521578] pci 0000:00:16.7: reg 10: [mem 0xdf0fc000-0xdf0fffff 64bit]
[    1.521643] pci 0000:00:1a.0: [8086:3a37] type 0 class 0x000c03
[    1.521687] pci 0000:00:1a.0: reg 20: [io  0xec40-0xec5f]
[    1.521730] pci 0000:00:1a.1: [8086:3a38] type 0 class 0x000c03
[    1.521774] pci 0000:00:1a.1: reg 20: [io  0xec60-0xec7f]
[    1.521827] pci 0000:00:1a.7: [8086:3a3c] type 0 class 0x000c03
[    1.521849] pci 0000:00:1a.7: reg 10: [mem 0xdf0de000-0xdf0de3ff]
[    1.521922] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    1.521926] pci 0000:00:1a.7: PME# disabled
[    1.521948] pci 0000:00:1d.0: [8086:3a34] type 0 class 0x000c03
[    1.521993] pci 0000:00:1d.0: reg 20: [io  0xec80-0xec9f]
[    1.522036] pci 0000:00:1d.1: [8086:3a35] type 0 class 0x000c03
[    1.522079] pci 0000:00:1d.1: reg 20: [io  0xeca0-0xecbf]
[    1.522123] pci 0000:00:1d.2: [8086:3a36] type 0 class 0x000c03
[    1.522166] pci 0000:00:1d.2: reg 20: [io  0xecc0-0xecdf]
[    1.522210] pci 0000:00:1d.3: [8086:3a39] type 0 class 0x000c03
[    1.522253] pci 0000:00:1d.3: reg 20: [io  0xece0-0xecff]
[    1.522305] pci 0000:00:1d.7: [8086:3a3a] type 0 class 0x000c03
[    1.522327] pci 0000:00:1d.7: reg 10: [mem 0xdf0df000-0xdf0df3ff]
[    1.522400] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.522404] pci 0000:00:1d.7: PME# disabled
[    1.522423] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    1.522481] pci 0000:00:1f.0: [8086:3a16] type 0 class 0x000601
[    1.522563] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 
0c00 (mask 007f)
[    1.522659] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 
0ca0 (mask 000f)
[    1.522755] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 
00e0 (mask 000f)
[    1.522882] pci 0000:00:1f.2: [8086:3a20] type 0 class 0x000101
[    1.522898] pci 0000:00:1f.2: reg 10: [io  0xe8e0-0xe8e7]
[    1.522906] pci 0000:00:1f.2: reg 14: [io  0xe8d0-0xe8d3]
[    1.522914] pci 0000:00:1f.2: reg 18: [io  0xe8e8-0xe8ef]
[    1.522922] pci 0000:00:1f.2: reg 1c: [io  0xe8d4-0xe8d7]
[    1.522930] pci 0000:00:1f.2: reg 20: [io  0xec00-0xec0f]
[    1.522938] pci 0000:00:1f.2: reg 24: [io  0xec10-0xec1f]
[    1.522981] pci 0000:00:1f.5: [8086:3a26] type 0 class 0x000101
[    1.522997] pci 0000:00:1f.5: reg 10: [io  0xe8f0-0xe8f7]
[    1.523005] pci 0000:00:1f.5: reg 14: [io  0xe8d8-0xe8db]
[    1.523013] pci 0000:00:1f.5: reg 18: [io  0xe8f8-0xe8ff]
[    1.523021] pci 0000:00:1f.5: reg 1c: [io  0xe8dc-0xe8df]
[    1.523029] pci 0000:00:1f.5: reg 20: [io  0xec20-0xec2f]
[    1.523037] pci 0000:00:1f.5: reg 24: [io  0xec30-0xec3f]
[    1.523123] pci 0000:01:00.0: [14e4:163b] type 0 class 0x000200
[    1.523139] pci 0000:01:00.0: reg 10: [mem 0xda000000-0xdbffffff 64bit]
[    1.523206] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    1.523210] pci 0000:01:00.0: PME# disabled
[    1.523238] pci 0000:01:00.1: [14e4:163b] type 0 class 0x000200
[    1.523254] pci 0000:01:00.1: reg 10: [mem 0xdc000000-0xddffffff 64bit]
[    1.523321] pci 0000:01:00.1: PME# supported from D0 D3hot D3cold
[    1.523325] pci 0000:01:00.1: PME# disabled
[    1.523347] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.523423] pci 0000:00:01.0:   bridge window [mem 0xda000000-0xddffffff]
[    1.523474] pci 0000:02:00.0: [1000:0058] type 0 class 0x000100
[    1.523486] pci 0000:02:00.0: reg 10: [io  0xfc00-0xfcff]
[    1.523498] pci 0000:02:00.0: reg 14: [mem 0xdf2ec000-0xdf2effff 64bit]
[    1.523511] pci 0000:02:00.0: reg 1c: [mem 0xdf2f0000-0xdf2fffff 64bit]
[    1.523526] pci 0000:02:00.0: reg 30: [mem 0xdf100000-0xdf1fffff pref]
[    1.523548] pci 0000:02:00.0: supports D1 D2
[    1.523566] pci 0000:00:03.0: PCI bridge to [bus 02-02]
[    1.523640] pci 0000:00:03.0:   bridge window [io  0xf000-0xffff]
[    1.523644] pci 0000:00:03.0:   bridge window [mem 0xdf100000-0xdf2fffff]
[    1.523684] pci 0000:00:07.0: PCI bridge to [bus 03-03]
[    1.523796] pci 0000:04:03.0: [102b:0532] type 0 class 0x000300
[    1.523813] pci 0000:04:03.0: reg 10: [mem 0xd9800000-0xd9ffffff pref]
[    1.523823] pci 0000:04:03.0: reg 14: [mem 0xde7fc000-0xde7fffff]
[    1.523833] pci 0000:04:03.0: reg 18: [mem 0xde800000-0xdeffffff]
[    1.523867] pci 0000:04:03.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    1.523925] pci 0000:00:1e.0: PCI bridge to [bus 04-04] (subtractive 
decode)
[    1.524006] pci 0000:00:1e.0:   bridge window [mem 0xde000000-0xdeffffff]
[    1.524012] pci 0000:00:1e.0:   bridge window [mem 
0xd9800000-0xd9ffffff 64bit pref]
[    1.524016] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] 
(subtractive decode)
[    1.524019] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] 
(subtractive decode)
[    1.524021] pci 0000:00:1e.0:   bridge window [mem 
0x000a0000-0x000bffff] (subtractive decode)
[    1.524023] pci 0000:00:1e.0:   bridge window [mem 
0xd0000000-0xfdffffff] (subtractive decode)
[    1.524026] pci 0000:00:1e.0:   bridge window [mem 
0xfed40000-0xfed44fff] (subtractive decode)
[    1.524042] pci_bus 0000:00: on NUMA node 0
[    1.524046] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.524319] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[    1.524369] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    1.524417] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX7._PRT]
[    1.524470] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.COMP._PRT]
[    1.524588]  pci0000:00: Requesting ACPI _OSC control (0x15)
[    1.524822]  pci0000:00: ACPI _OSC control (0x15) granted
[    1.527136] ACPI: PCI Interrupt Link [LK00] (IRQs 3 4 5 6 7 10 11 14 *15)
[    1.527746] ACPI: PCI Interrupt Link [LK01] (IRQs 3 4 5 6 7 10 11 *14 15)
[    1.528362] ACPI: PCI Interrupt Link [LK02] (IRQs 3 4 5 6 7 10 *11 14 15)
[    1.528970] ACPI: PCI Interrupt Link [LK03] (IRQs 3 4 5 6 7 *10 11 14 15)
[    1.529577] ACPI: PCI Interrupt Link [LK04] (IRQs 3 4 *5 6 7 10 11 14 15)
[    1.530185] ACPI: PCI Interrupt Link [LK05] (IRQs 3 4 5 *6 7 10 11 14 15)
[    1.530792] ACPI: PCI Interrupt Link [LK06] (IRQs 3 4 5 6 7 10 *11 14 15)
[    1.531398] ACPI: PCI Interrupt Link [LK07] (IRQs 3 4 5 6 7 10 11 *14 15)
[    1.532025] vgaarb: device added: 
PCI:0000:04:03.0,decodes=io+mem,owns=io+mem,locks=none
[    1.532121] vgaarb: loaded
[    1.532187] vgaarb: bridge control possible 0000:04:03.0
[    1.532313] SCSI subsystem initialized
[    1.532400] usbcore: registered new interface driver usbfs
[    1.532481] usbcore: registered new interface driver hub
[    1.532577] usbcore: registered new device driver usb
[    1.532674] PCI: Using ACPI for IRQ routing
[    1.539202] PCI: Discovered peer bus fe
[    1.539295] pci 0000:fe:00.0: [8086:2c70] type 0 class 0x000600
[    1.539315] pci 0000:fe:00.1: [8086:2d81] type 0 class 0x000600
[    1.539337] pci 0000:fe:02.0: [8086:2d90] type 0 class 0x000600
[    1.539355] pci 0000:fe:02.1: [8086:2d91] type 0 class 0x000600
[    1.539373] pci 0000:fe:02.2: [8086:2d92] type 0 class 0x000600
[    1.539391] pci 0000:fe:02.3: [8086:2d93] type 0 class 0x000600
[    1.539409] pci 0000:fe:02.4: [8086:2d94] type 0 class 0x000600
[    1.539429] pci 0000:fe:02.5: [8086:2d95] type 0 class 0x000600
[    1.539448] pci 0000:fe:03.0: [8086:2d98] type 0 class 0x000600
[    1.539466] pci 0000:fe:03.1: [8086:2d99] type 0 class 0x000600
[    1.539484] pci 0000:fe:03.2: [8086:2d9a] type 0 class 0x000600
[    1.539503] pci 0000:fe:03.4: [8086:2d9c] type 0 class 0x000600
[    1.539522] pci 0000:fe:04.0: [8086:2da0] type 0 class 0x000600
[    1.539540] pci 0000:fe:04.1: [8086:2da1] type 0 class 0x000600
[    1.539558] pci 0000:fe:04.2: [8086:2da2] type 0 class 0x000600
[    1.539576] pci 0000:fe:04.3: [8086:2da3] type 0 class 0x000600
[    1.539596] pci 0000:fe:05.0: [8086:2da8] type 0 class 0x000600
[    1.539614] pci 0000:fe:05.1: [8086:2da9] type 0 class 0x000600
[    1.539632] pci 0000:fe:05.2: [8086:2daa] type 0 class 0x000600
[    1.539650] pci 0000:fe:05.3: [8086:2dab] type 0 class 0x000600
[    1.539670] pci 0000:fe:06.0: [8086:2db0] type 0 class 0x000600
[    1.539688] pci 0000:fe:06.1: [8086:2db1] type 0 class 0x000600
[    1.539706] pci 0000:fe:06.2: [8086:2db2] type 0 class 0x000600
[    1.539727] pci 0000:fe:06.3: [8086:2db3] type 0 class 0x000600
[    1.540125] PCI: Discovered peer bus ff
[    1.540210] pci 0000:ff:00.0: [8086:2c70] type 0 class 0x000600
[    1.540232] pci 0000:ff:00.1: [8086:2d81] type 0 class 0x000600
[    1.540256] pci 0000:ff:02.0: [8086:2d90] type 0 class 0x000600
[    1.540277] pci 0000:ff:02.1: [8086:2d91] type 0 class 0x000600
[    1.540298] pci 0000:ff:02.2: [8086:2d92] type 0 class 0x000600
[    1.540319] pci 0000:ff:02.3: [8086:2d93] type 0 class 0x000600
[    1.540341] pci 0000:ff:02.4: [8086:2d94] type 0 class 0x000600
[    1.540362] pci 0000:ff:02.5: [8086:2d95] type 0 class 0x000600
[    1.540384] pci 0000:ff:03.0: [8086:2d98] type 0 class 0x000600
[    1.540405] pci 0000:ff:03.1: [8086:2d99] type 0 class 0x000600
[    1.540426] pci 0000:ff:03.2: [8086:2d9a] type 0 class 0x000600
[    1.540447] pci 0000:ff:03.4: [8086:2d9c] type 0 class 0x000600
[    1.540470] pci 0000:ff:04.0: [8086:2da0] type 0 class 0x000600
[    1.540491] pci 0000:ff:04.1: [8086:2da1] type 0 class 0x000600
[    1.540512] pci 0000:ff:04.2: [8086:2da2] type 0 class 0x000600
[    1.540535] pci 0000:ff:04.3: [8086:2da3] type 0 class 0x000600
[    1.540559] pci 0000:ff:05.0: [8086:2da8] type 0 class 0x000600
[    1.540580] pci 0000:ff:05.1: [8086:2da9] type 0 class 0x000600
[    1.540601] pci 0000:ff:05.2: [8086:2daa] type 0 class 0x000600
[    1.540622] pci 0000:ff:05.3: [8086:2dab] type 0 class 0x000600
[    1.540646] pci 0000:ff:06.0: [8086:2db0] type 0 class 0x000600
[    1.540667] pci 0000:ff:06.1: [8086:2db1] type 0 class 0x000600
[    1.540688] pci 0000:ff:06.2: [8086:2db2] type 0 class 0x000600
[    1.540710] pci 0000:ff:06.3: [8086:2db3] type 0 class 0x000600
[    1.541119] PCI: pci_cache_line_size set to 64 bytes
[    1.541273] reserve RAM buffer: 00000000cf379000 - 00000000cfffffff
[    1.541359] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    1.541655] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    1.543760] Switching to clocksource hpet
[    1.543984] pnp: PnP ACPI init
[    1.544064] ACPI: bus type pnp registered
[    1.544269] pnp 00:00: [bus 00-ff]
[    1.544272] pnp 00:00: [io  0x0cf8-0x0cff]
[    1.544274] pnp 00:00: [io  0x0000-0x0cf7 window]
[    1.544276] pnp 00:00: [io  0x0d00-0xffff window]
[    1.544278] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    1.544280] pnp 00:00: [mem 0xd0000000-0xfdffffff window]
[    1.544282] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    1.544345] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 
(active)
[    1.544376] pnp 00:01: [io  0x0080-0x009f]
[    1.544378] pnp 00:01: [io  0x0000-0x001f]
[    1.544379] pnp 00:01: [io  0x00c0-0x00df]
[    1.544381] pnp 00:01: [dma 4]
[    1.544404] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.544421] pnp 00:02: [io  0x00f0-0x00ff]
[    1.544431] pnp 00:02: [irq 13]
[    1.544453] pnp 00:02: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.544471] pnp 00:03: [io  0x0061]
[    1.544555] system 00:03: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.544575] pnp 00:04: [io  0x0070-0x007f]
[    1.544581] pnp 00:04: [irq 8]
[    1.544603] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.544745] pnp 00:05: [io  0x03f8-0x03ff]
[    1.544751] pnp 00:05: [irq 4]
[    1.544833] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.544964] pnp 00:06: [io  0x02f8-0x02ff]
[    1.544970] pnp 00:06: [irq 3]
[    1.545052] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.545747] pnp 00:07: [io  0x0800-0x087f]
[    1.545749] pnp 00:07: [io  0x00e0-0x00e7]
[    1.545751] pnp 00:07: [io  0x0880-0x08ff]
[    1.545753] pnp 00:07: [io  0x0900-0x091f]
[    1.545754] pnp 00:07: [io  0x0920-0x0923]
[    1.545756] pnp 00:07: [io  0x0924]
[    1.545757] pnp 00:07: [io  0x0c00-0x0c7f]
[    1.545759] pnp 00:07: [io  0x0ca0-0x0ca7]
[    1.545761] pnp 00:07: [io  0x0ca9-0x0cab]
[    1.545762] pnp 00:07: [io  0x0cad-0x0caf]
[    1.545764] pnp 00:07: [io  0x0060]
[    1.545765] pnp 00:07: [io  0x0064]
[    1.545831] system 00:07: [io  0x0800-0x087f] has been reserved
[    1.545907] system 00:07: [io  0x0880-0x08ff] has been reserved
[    1.545981] system 00:07: [io  0x0900-0x091f] has been reserved
[    1.546055] system 00:07: [io  0x0920-0x0923] has been reserved
[    1.546130] system 00:07: [io  0x0924] has been reserved
[    1.546203] system 00:07: [io  0x0c00-0x0c7f] has been reserved
[    1.546277] system 00:07: [io  0x0ca0-0x0ca7] has been reserved
[    1.546352] system 00:07: [io  0x0ca9-0x0cab] has been reserved
[    1.546426] system 00:07: [io  0x0cad-0x0caf] has been reserved
[    1.546501] system 00:07: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.546540] pnp 00:08: [io  0x0ca8]
[    1.546542] pnp 00:08: [io  0x0cac]
[    1.546544] pnp 00:08: [irq 0 disabled]
[    1.546602] system 00:08: [io  0x0ca8] has been reserved
[    1.546676] system 00:08: [io  0x0cac] has been reserved
[    1.546750] system 00:08: Plug and Play ACPI device, IDs IPI0001 
PNP0c01 (active)
[    1.547299] pnp 00:09: [mem 0xe0000000-0xefffffff]
[    1.547360] system 00:09: [mem 0xe0000000-0xefffffff] has been reserved
[    1.547437] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.547477] pnp 00:0a: [mem 0xfed00000-0xfed003ff]
[    1.547503] pnp 00:0a: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.547516] pnp 00:0b: [mem 0xfed90000-0xfed91fff]
[    1.547574] system 00:0b: [mem 0xfed90000-0xfed91fff] has been reserved
[    1.547651] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.547787] pnp: PnP ACPI: found 12 devices
[    1.547858] ACPI: ACPI bus type pnp unregistered
[    1.553195] PCI: max bus depth: 1 pci_try_num: 2
[    1.553228] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.553303] pci 0000:00:01.0:   bridge window [mem 0xda000000-0xddffffff]
[    1.553384] pci 0000:00:03.0: PCI bridge to [bus 02-02]
[    1.553458] pci 0000:00:03.0:   bridge window [io  0xf000-0xffff]
[    1.553535] pci 0000:00:03.0:   bridge window [mem 0xdf100000-0xdf2fffff]
[    1.553615] pci 0000:00:07.0: PCI bridge to [bus 03-03]
[    1.553698] pci 0000:04:03.0: BAR 6: assigned [mem 
0xde000000-0xde00ffff pref]
[    1.553792] pci 0000:00:1e.0: PCI bridge to [bus 04-04]
[    1.553878] pci 0000:00:1e.0:   bridge window [mem 0xde000000-0xdeffffff]
[    1.553956] pci 0000:00:1e.0:   bridge window [mem 
0xd9800000-0xd9ffffff 64bit pref]
[    1.554069] pci 0000:00:01.0: PCI INT A -> GSI 53 (level, low) -> IRQ 53
[    1.554147] pci 0000:00:01.0: setting latency timer to 64
[    1.554153] pci 0000:00:03.0: PCI INT A -> GSI 53 (level, low) -> IRQ 53
[    1.554230] pci 0000:00:03.0: setting latency timer to 64
[    1.554235] pci 0000:00:07.0: PCI INT A -> GSI 53 (level, low) -> IRQ 53
[    1.554313] pci 0000:00:07.0: setting latency timer to 64
[    1.554319] pci 0000:00:1e.0: setting latency timer to 64
[    1.554323] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.554325] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.554327] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.554329] pci_bus 0000:00: resource 7 [mem 0xd0000000-0xfdffffff]
[    1.554331] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
[    1.554333] pci_bus 0000:01: resource 1 [mem 0xda000000-0xddffffff]
[    1.554335] pci_bus 0000:02: resource 0 [io  0xf000-0xffff]
[    1.554337] pci_bus 0000:02: resource 1 [mem 0xdf100000-0xdf2fffff]
[    1.554339] pci_bus 0000:04: resource 1 [mem 0xde000000-0xdeffffff]
[    1.554341] pci_bus 0000:04: resource 2 [mem 0xd9800000-0xd9ffffff 
64bit pref]
[    1.554343] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]
[    1.554345] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]
[    1.554347] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
[    1.554349] pci_bus 0000:04: resource 7 [mem 0xd0000000-0xfdffffff]
[    1.554351] pci_bus 0000:04: resource 8 [mem 0xfed40000-0xfed44fff]
[    1.554353] pci_bus 0000:fe: resource 0 [io  0x0000-0xffff]
[    1.554355] pci_bus 0000:fe: resource 1 [mem 0x00000000-0xffffffffff]
[    1.554358] pci_bus 0000:ff: resource 0 [io  0x0000-0xffff]
[    1.554360] pci_bus 0000:ff: resource 1 [mem 0x00000000-0xffffffffff]
[    1.554392] NET: Registered protocol family 2
[    1.554510] IP route cache hash table entries: 524288 (order: 10, 
4194304 bytes)
[    1.555371] TCP established hash table entries: 524288 (order: 11, 
8388608 bytes)
[    1.557559] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    1.558481] TCP: Hash tables configured (established 524288 bind 65536)
[    1.558557] TCP reno registered
[    1.558647] UDP hash table entries: 16384 (order: 8, 1572864 bytes)
[    1.559348] UDP-Lite hash table entries: 16384 (order: 8, 1572864 bytes)
[    1.560128] NET: Registered protocol family 1
[    1.573967] pci 0000:04:03.0: Boot video device
[    1.574041] PCI: CLS 64 bytes, default 64
[    1.574088] Trying to unpack rootfs image as initramfs...
[    1.655163] Freeing initrd memory: 4076k freed
[    1.656041] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.656117] Placing 64MB software IO TLB between ffff8800cb377000 - 
ffff8800cf377000
[    1.656211] software IO TLB at phys 0xcb377000 - 0xcf377000
[    1.735511] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.893658] SGI XFS with security attributes, large block/inode 
numbers, no debug enabled
[    1.894138] msgmni has been set to 32768
[    1.894310] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 253)
[    1.894404] io scheduler noop registered
[    1.894473] io scheduler deadline registered (default)
[    1.894725] pcieport 0000:00:01.0: setting latency timer to 64
[    1.894772] pcieport 0000:00:01.0: irq 72 for MSI/MSI-X
[    1.894824] pcieport 0000:00:03.0: setting latency timer to 64
[    1.894859] pcieport 0000:00:03.0: irq 73 for MSI/MSI-X
[    1.894907] pcieport 0000:00:07.0: setting latency timer to 64
[    1.894941] pcieport 0000:00:07.0: irq 74 for MSI/MSI-X
[    1.895070] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.895167] ACPI: Power Button [PWRF]
[    1.895258] ACPI: acpi_idle registered with cpuidle
[    1.895435] Monitor-Mwait will be used to enter C-1 state
[    1.895471] Monitor-Mwait will be used to enter C-3 state
[    1.897165] ERST: Error Record Serialization Table (ERST) support is 
initialized.
[    1.897399] GHES: APEI firmware first mode is enabled by APEI bit and 
WHEA _OSC.
[    1.897493] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    1.897602] ioatdma 0000:00:16.0: PCI INT A -> GSI 51 (level, low) -> 
IRQ 51
[    1.897690] ioatdma 0000:00:16.0: setting latency timer to 64
[    1.897725] ioatdma 0000:00:16.0: irq 75 for MSI/MSI-X
[    1.897986] ioatdma 0000:00:16.1: PCI INT B -> GSI 52 (level, low) -> 
IRQ 52
[    1.898084] ioatdma 0000:00:16.1: setting latency timer to 64
[    1.898121] ioatdma 0000:00:16.1: irq 76 for MSI/MSI-X
[    1.898359] ioatdma 0000:00:16.2: PCI INT C -> GSI 53 (level, low) -> 
IRQ 53
[    1.898453] ioatdma 0000:00:16.2: setting latency timer to 64
[    1.898488] ioatdma 0000:00:16.2: irq 77 for MSI/MSI-X
[    1.898682] ioatdma 0000:00:16.3: PCI INT D -> GSI 54 (level, low) -> 
IRQ 54
[    1.898773] ioatdma 0000:00:16.3: setting latency timer to 64
[    1.898807] ioatdma 0000:00:16.3: irq 78 for MSI/MSI-X
[    1.898960] ioatdma 0000:00:16.4: PCI INT A -> GSI 51 (level, low) -> 
IRQ 51
[    1.899048] ioatdma 0000:00:16.4: setting latency timer to 64
[    1.899081] ioatdma 0000:00:16.4: irq 79 for MSI/MSI-X
[    1.899224] ioatdma 0000:00:16.5: PCI INT B -> GSI 52 (level, low) -> 
IRQ 52
[    1.899314] ioatdma 0000:00:16.5: setting latency timer to 64
[    1.899349] ioatdma 0000:00:16.5: irq 80 for MSI/MSI-X
[    1.899495] ioatdma 0000:00:16.6: PCI INT C -> GSI 53 (level, low) -> 
IRQ 53
[    1.899584] ioatdma 0000:00:16.6: setting latency timer to 64
[    1.899615] ioatdma 0000:00:16.6: irq 81 for MSI/MSI-X
[    1.899752] ioatdma 0000:00:16.7: PCI INT D -> GSI 54 (level, low) -> 
IRQ 54
[    1.899841] ioatdma 0000:00:16.7: setting latency timer to 64
[    1.899874] ioatdma 0000:00:16.7: irq 82 for MSI/MSI-X
[    1.900911] brd: module loaded
[    1.901039] Fusion MPT base driver 3.04.19
[    1.901108] Copyright (c) 1999-2008 LSI Corporation
[    1.901183] Fusion MPT SAS Host driver 3.04.19
[    1.901281] mptsas 0000:02:00.0: PCI INT A -> GSI 32 (level, low) -> 
IRQ 32
[    1.901432] mptbase: ioc0: Initiating bringup
[    2.653394] Refined TSC clocksource calibration: 2128.000 MHz.
[    2.653479] Switching to clocksource tsc
[    3.453048] ioc0: LSISAS1068E B3: Capabilities={Initiator}
[    3.453321] mptsas 0000:02:00.0: setting latency timer to 64
[   33.404391] scsi0 : ioc0: LSISAS1068E B3, FwRev=00192f00h, Ports=1, 
MaxQ=266, IRQ=32
[   33.439076] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 
9, phy 0, sas_addr 0x5000cca0182f5c05
[   33.440105] scsi 0:0:0:0: Direct-Access     HITACHI  HUS156045VLS600 
  E516 PQ: 0 ANSI: 6
[   33.443725] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 
1, phy 1, sas_addr 0x5000cca0181b0a6d
[   33.444679] scsi 0:0:1:0: Direct-Access     HITACHI  HUS156045VLS600 
  E516 PQ: 0 ANSI: 6
[   33.448284] mptsas: ioc0: attaching raid volume, channel 1, id 0
[   33.449160] scsi 0:1:0:0: Direct-Access     Dell     VIRTUAL DISK 
  1028 PQ: 0 ANSI: 5
[   33.456035] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   33.456135] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 19 (level, low) 
-> IRQ 19
[   33.456225] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[   33.456229] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[   33.456255] sd 0:1:0:0: [sda] 877920256 512-byte logical blocks: (449 
GB/418 GiB)
[   33.456397] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned 
bus number 1
[   33.456517] ehci_hcd 0000:00:1a.7: debug port 1
[   33.456919] sd 0:1:0:0: [sda] Write Protect is off
[   33.457007] sd 0:1:0:0: [sda] Mode Sense: 03 00 00 08
[   33.457211] sd 0:1:0:0: [sda] Got wrong page
[   33.457289] sd 0:1:0:0: [sda] Assuming drive cache: write through
[   33.458522] sd 0:1:0:0: [sda] Got wrong page
[   33.458599] sd 0:1:0:0: [sda] Assuming drive cache: write through
[   33.460460] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[   33.460474] ehci_hcd 0000:00:1a.7: irq 19, io mem 0xdf0de000
[   33.466969]  sda: sda1 sda2 sda3
[   33.468240] sd 0:1:0:0: [sda] Got wrong page
[   33.468320] sd 0:1:0:0: [sda] Assuming drive cache: write through
[   33.468399] sd 0:1:0:0: [sda] Attached SCSI disk
[   33.480374] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   33.480474] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   33.480550] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[   33.480643] usb usb1: Product: EHCI Host Controller
[   33.480714] usb usb1: Manufacturer: Linux 3.1.0 ehci_hcd
[   33.480787] usb usb1: SerialNumber: 0000:00:1a.7
[   33.480914] hub 1-0:1.0: USB hub found
[   33.480988] hub 1-0:1.0: 4 ports detected
[   33.481102] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 21 (level, low) 
-> IRQ 21
[   33.481190] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   33.481193] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   33.481269] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned 
bus number 2
[   33.482536] ehci_hcd 0000:00:1d.7: debug port 1
[   33.486480] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[   33.486493] ehci_hcd 0000:00:1d.7: irq 21, io mem 0xdf0df000
[   33.510362] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   33.510456] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   33.510532] usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[   33.510624] usb usb2: Product: EHCI Host Controller
[   33.510696] usb usb2: Manufacturer: Linux 3.1.0 ehci_hcd
[   33.510768] usb usb2: SerialNumber: 0000:00:1d.7
[   33.510886] hub 2-0:1.0: USB hub found
[   33.510957] hub 2-0:1.0: 4 ports detected
[   33.511071] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   33.511161] uhci_hcd: USB Universal Host Controller Interface driver
[   33.511260] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 17 (level, low) 
-> IRQ 17
[   33.511342] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[   33.511345] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   33.511420] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned 
bus number 3
[   33.511543] uhci_hcd 0000:00:1a.0: irq 17, io base 0x0000ec40
[   33.511643] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   33.511719] usb usb3: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[   33.511811] usb usb3: Product: UHCI Host Controller
[   33.511883] usb usb3: Manufacturer: Linux 3.1.0 uhci_hcd
[   33.511955] usb usb3: SerialNumber: 0000:00:1a.0
[   33.512075] hub 3-0:1.0: USB hub found
[   33.512146] hub 3-0:1.0: 2 ports detected
[   33.512250] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 18 (level, low) 
-> IRQ 18
[   33.512330] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[   33.512333] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   33.512410] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned 
bus number 4
[   33.512536] uhci_hcd 0000:00:1a.1: irq 18, io base 0x0000ec60
[   33.512636] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   33.512712] usb usb4: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[   33.512805] usb usb4: Product: UHCI Host Controller
[   33.512876] usb usb4: Manufacturer: Linux 3.1.0 uhci_hcd
[   33.512949] usb usb4: SerialNumber: 0000:00:1a.1
[   33.513063] hub 4-0:1.0: USB hub found
[   33.513134] hub 4-0:1.0: 2 ports detected
[   33.513234] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 21 (level, low) 
-> IRQ 21
[   33.513314] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   33.513317] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   33.513391] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned 
bus number 5
[   33.513508] uhci_hcd 0000:00:1d.0: irq 21, io base 0x0000ec80
[   33.513607] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   33.513683] usb usb5: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[   33.513776] usb usb5: Product: UHCI Host Controller
[   33.513847] usb usb5: Manufacturer: Linux 3.1.0 uhci_hcd
[   33.513919] usb usb5: SerialNumber: 0000:00:1d.0
[   33.514035] hub 5-0:1.0: USB hub found
[   33.514105] hub 5-0:1.0: 2 ports detected
[   33.514209] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 20 (level, low) 
-> IRQ 20
[   33.514289] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   33.514292] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   33.514368] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned 
bus number 6
[   33.514490] uhci_hcd 0000:00:1d.1: irq 20, io base 0x0000eca0
[   33.514591] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[   33.514667] usb usb6: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[   33.514760] usb usb6: Product: UHCI Host Controller
[   33.514831] usb usb6: Manufacturer: Linux 3.1.0 uhci_hcd
[   33.514904] usb usb6: SerialNumber: 0000:00:1d.1
[   33.515019] hub 6-0:1.0: USB hub found
[   33.515089] hub 6-0:1.0: 2 ports detected
[   33.515190] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 21 (level, low) 
-> IRQ 21
[   33.515270] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   33.515273] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   33.515349] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned 
bus number 7
[   33.515462] uhci_hcd 0000:00:1d.2: irq 21, io base 0x0000ecc0
[   33.515560] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[   33.515636] usb usb7: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[   33.515729] usb usb7: Product: UHCI Host Controller
[   33.515800] usb usb7: Manufacturer: Linux 3.1.0 uhci_hcd
[   33.515872] usb usb7: SerialNumber: 0000:00:1d.2
[   33.515987] hub 7-0:1.0: USB hub found
[   33.516058] hub 7-0:1.0: 2 ports detected
[   33.516155] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 20 (level, low) 
-> IRQ 20
[   33.516235] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[   33.516238] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   33.516312] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned 
bus number 8
[   33.516429] uhci_hcd 0000:00:1d.3: irq 20, io base 0x0000ece0
[   33.516528] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[   33.516604] usb usb8: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[   33.516697] usb usb8: Product: UHCI Host Controller
[   33.516768] usb usb8: Manufacturer: Linux 3.1.0 uhci_hcd
[   33.516840] usb usb8: SerialNumber: 0000:00:1d.3
[   33.516955] hub 8-0:1.0: USB hub found
[   33.517026] hub 8-0:1.0: 2 ports detected
[   33.517180] i8042: PNP: No PS/2 controller found. Probing ports directly.
[   33.519997] serio: i8042 KBD port at 0x60,0x64 irq 1
[   33.520073] serio: i8042 AUX port at 0x60,0x64 irq 12
[   33.520167] mousedev: PS/2 mouse device common for all mice
[   33.520266] rtc_cmos 00:04: RTC can wake from S4
[   33.520411] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[   33.520512] rtc0: alarms up to one day, y3k, 242 bytes nvram, hpet irqs
[   33.520693] device-mapper: ioctl: 4.21.0-ioctl (2011-07-06) 
initialised: dm-devel@redhat.com
[   33.520966] cpuidle: using governor ladder
[   33.521127] usbcore: registered new interface driver usbhid
[   33.521200] usbhid: USB HID core driver
[   33.521307] TCP cubic registered
[   33.521375] TCP htcp registered
[   33.521443] NET: Registered protocol family 17
[   33.601291] Freeing unused kernel memory: 484k freed
[   33.601478] Write protecting the kernel read-only data: 6144k
[   33.602838] Freeing unused kernel memory: 372k freed
[   33.606151] Freeing unused kernel memory: 964k freed
[   33.647464] dracut: dracut-009-12.fc15
[   33.659026] udev[137]: starting version 167
[   33.728842] dracut: Starting plymouth daemon
[   33.800330] usb 1-3: new high speed USB device number 2 using ehci_hcd
[   33.960579] usb 1-3: New USB device found, idVendor=0424, idProduct=2514
[   33.960665] usb 1-3: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[   33.961096] hub 1-3:1.0: USB hub found
[   33.961327] hub 1-3:1.0: 4 ports detected
[   34.002218] EXT4-fs (sda1): INFO: recovery required on readonly 
filesystem
[   34.002303] EXT4-fs (sda1): write access will be enabled during recovery
[   35.052726] EXT4-fs (sda1): orphan cleanup on readonly fs
[   35.052807] EXT4-fs (sda1): ext4_orphan_cleanup: deleting 
unreferenced inode 422458
[   35.052833] EXT4-fs (sda1): 1 orphan inode deleted
[   35.052904] EXT4-fs (sda1): recovery complete
[   35.063544] EXT4-fs (sda1): mounted filesystem with ordered data 
mode. Opts: (null)
[   35.201718] dracut: Checking filesystems
[   35.201808] dracut: fsck -T -t noopts=_netdev -A -a
[   35.217779] dracut: /dev/sda1: clean, 268110/663552 files, 
1449695/2622603 blocks
[   35.217991] dracut: Remounting 
/dev/disk/by-uuid/3b925ad3-1530-4efa-85ea-2b497a73f9fa with -o ro,
[   35.233537] EXT4-fs (sda1): mounted filesystem with ordered data 
mode. Opts: (null)
[   35.245782] dracut: Mounted root filesystem /dev/sda1
[   35.677728] dracut: Switching root
[   36.291322] systemd[1]: systemd 26 running in system mode. (+PAM 
+LIBWRAP +AUDIT +SELINUX +SYSVINIT +LIBCRYPTSETUP; fedora)
[   36.318184] systemd[1]: /sbin/modprobe failed with error code 1.
[   36.326870] systemd[1]: Set hostname to <db3>.
[   36.410718] systemd[1]: Failed to connect to audit log: Protocol not 
supported
[   37.199411] systemd-readahead-replay[492]: Bumped block_nr parameter 
of /dev/sda to 16384. This is a temporary hack and should be removed one 
day.
[   37.289247] systemd[1]: Failed to open /dev/autofs: No such file or 
directory
[   37.289252] systemd[1]: Failed to initialize automounter: No such 
file or directory
[   37.289260] systemd[1]: Unit dev-hugepages.automount entered failed 
state.
[   37.289274] systemd[1]: Failed to open /dev/autofs: No such file or 
directory
[   37.289277] systemd[1]: Failed to initialize automounter: No such 
file or directory
[   37.289284] systemd[1]: Unit sys-kernel-debug.automount entered 
failed state.
[   37.289314] systemd[1]: Failed to open /dev/autofs: No such file or 
directory
[   37.289317] systemd[1]: Failed to initialize automounter: No such 
file or directory
[   37.289324] systemd[1]: Unit proc-sys-fs-binfmt_misc.automount 
entered failed state.
[   37.289395] systemd[1]: Failed to open /dev/autofs: No such file or 
directory
[   37.289399] systemd[1]: Failed to initialize automounter: No such 
file or directory
[   37.289406] systemd[1]: Unit sys-kernel-security.automount entered 
failed state.
[   37.289427] systemd[1]: Failed to open /dev/autofs: No such file or 
directory
[   37.289430] systemd[1]: Failed to initialize automounter: No such 
file or directory
[   37.289436] systemd[1]: Unit dev-mqueue.automount entered failed state.
[   37.839956] EXT4-fs (sda1): re-mounted. Opts: (null)
[   39.308315] udev[521]: starting version 167
[   39.609550] bnx2: Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 
v2.1.11 (July 20, 2011)
[   39.609688] bnx2 0000:01:00.0: PCI INT A -> GSI 36 (level, low) -> IRQ 36
[   39.609771] bnx2 0000:01:00.0: setting latency timer to 64
[   39.614312] ACPI Error: No handler for Region [IPMI] 
(ffff88080b839240) [IPMI] (20110623/evregion-373)
[   39.614503] ACPI Error: Region IPMI (ID=7) has no handler 
(20110623/exfldio-292)
[   39.614688] ACPI Error: Method parse/execution failed 
[\_SB_.PMI0._GHL] (Node ffff88080b838b18), AE_NOT_EXIST 
(20110623/psparse-536)
[   39.614980] ACPI Error: Method parse/execution failed 
[\_SB_.PMI0._PMC] (Node ffff88080b838a78), AE_NOT_EXIST 
(20110623/psparse-536)
[   39.615272] ACPI Exception: AE_NOT_EXIST, Evaluating _PMC 
(20110623/power_meter-773)
[   39.621807] scsi 0:0:0:0: Attached scsi generic sg0 type 0
[   39.621908] scsi 0:0:1:0: Attached scsi generic sg1 type 0
[   39.622007] sd 0:1:0:0: Attached scsi generic sg2 type 0
[   39.622357] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   39.623598] EDAC MC: Ver: 2.1.0
[   39.624358] EDAC MC1: Giving out device to 'i7core_edac.c' 'i7 core 
#1': DEV 0000:fe:03.0
[   39.624496] EDAC PCI0: Giving out device to module 'i7core_edac' 
controller 'EDAC PCI controller': DEV '0000:fe:03.0' (POLLED)
[   39.624869] EDAC MC0: Giving out device to 'i7core_edac.c' 'i7 core 
#0': DEV 0000:ff:03.0
[   39.625036] EDAC PCI1: Giving out device to module 'i7core_edac' 
controller 'EDAC PCI controller': DEV '0000:ff:03.0' (POLLED)
[   39.625138] EDAC i7core: Driver loaded.
[   39.643127] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   39.663786] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   39.665137] dcdbas dcdbas: Dell Systems Management Base Driver 
(version 5.6.0-3.2)
[   39.683700] bnx2 0000:01:00.0: eth0: Broadcom NetXtreme II BCM5716 
1000Base-T (C0) PCI Express found at mem da000000, IRQ 36, node addr 
78:2b:cb:38:bc:78
[   39.683847] bnx2 0000:01:00.1: PCI INT B -> GSI 48 (level, low) -> IRQ 48
[   39.683929] bnx2 0000:01:00.1: setting latency timer to 64
[   39.685736] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   39.689737] bnx2 0000:01:00.1: eth1: Broadcom NetXtreme II BCM5716 
1000Base-T (C0) PCI Express found at mem dc000000, IRQ 48, node addr 
78:2b:cb:38:bc:79
[   39.706415] 00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   39.827906] udev[524]: renamed network interface eth1 to em2
[   39.877857] udev[525]: renamed network interface eth0 to em1
[   40.585757] Adding 4200992k swap on /dev/sda2.  Priority:0 extents:1 
across:4200992k
[   41.087958] systemd-fsck[734]: /dev/mapper/DATA-db: recovering journal
[   42.162838] systemd-fsck[734]: /dev/mapper/DATA-db: clean, 
14213/13410304 files, 34832070/53635072 blocks
[   42.459770] EXT4-fs (dm-0): mounted filesystem with ordered data 
mode. Opts: (null)
[   52.777061] systemd-fsck[751]: /sbin/fsck.xfs: XFS file system.
[   53.161524] XFS (dm-2): Mounting Filesystem
[   53.232847] XFS (dm-2): Starting recovery (logdev: internal)
[   53.305479] XFS (dm-2): Ending recovery (logdev: internal)
[   55.293575] dmeventd (809): /proc/809/oom_adj is deprecated, please 
use /proc/809/oom_score_adj instead.
[   55.294001] dmeventd[809]: dmeventd ready for processing.
[   55.379419] lvm[809]: Monitoring snapshot DATA-dbdata_backup_4
[   55.483318] acpid[820]: starting up with proc fs
[   55.483547] acpid[820]: skipping incomplete file 
/etc/acpi/events/videoconf
[   55.483642] acpid[820]: 1 rule loaded
[   55.483720] acpid[820]: waiting for events: event logging is off
[   55.603221] smartd[819]: smartd 5.41 2011-06-09 r3365 
[x86_64-linux-3.1.0] (local build)
[   55.603326] smartd[819]: Copyright (C) 2002-11 by Bruce Allen, 
http://smartmontools.sourceforge.net
[   55.603427] smartd[819]: Opened configuration file /etc/smartd.conf
[   55.603507] smartd[819]: Configuration file /etc/smartd.conf was 
parsed, found DEVICESCAN, scanning devices
[   55.604545] smartd[819]: Device: /dev/sda, opened
[   55.605203] smartd[819]: Device: /dev/sda, IE (SMART) not enabled, 
skip device
[   55.605315] smartd[819]: Try 'smartctl -s on /dev/sda' to turn on 
SMART features
[   55.605427] smartd[819]: Monitoring 0 ATA and 0 SCSI devices
[   55.716392] /usr/sbin/crond[821]: (CRON) INFO (running with inotify 
support)
[   55.845737] ERST: NVRAM ERST Log Address Range is not implemented yet
[   55.846056] mcelog.setup[822]: read: Function not implemented
[   56.571810] mcelog[829]: mcelog: Unsupported new Family 6 Model 2c 
CPU: only decoding architectural errors
[   57.013870] bonding: Ethernet Channel Bonding Driver: v3.7.1 (April 
27, 2011)
[   57.013967] bonding: In ALB mode you might experience client 
disconnections upon reconnection of a link if the bonding module updelay 
parameter (0 msec) is incompatible with the forwarding delay time of the 
switch
[   57.014102] bonding: MII link monitoring set to 100 ms
[   57.058247] bonding: bond0: Adding slave em1.
[   57.059911] bnx2 0000:01:00.0: irq 83 for MSI/MSI-X
[   57.059920] bnx2 0000:01:00.0: irq 84 for MSI/MSI-X
[   57.059927] bnx2 0000:01:00.0: irq 85 for MSI/MSI-X
[   57.059935] bnx2 0000:01:00.0: irq 86 for MSI/MSI-X
[   57.059944] bnx2 0000:01:00.0: irq 87 for MSI/MSI-X
[   57.059951] bnx2 0000:01:00.0: irq 88 for MSI/MSI-X
[   57.059958] bnx2 0000:01:00.0: irq 89 for MSI/MSI-X
[   57.059966] bnx2 0000:01:00.0: irq 90 for MSI/MSI-X
[   57.059973] bnx2 0000:01:00.0: irq 91 for MSI/MSI-X
[   57.152341] bnx2 0000:01:00.0: em1: using MSIX
[   57.155161] bonding: bond0: enslaving em1 as an active interface with 
a down link.
[   57.194490] bonding: bond0: Adding slave em2.
[   57.195991] bnx2 0000:01:00.1: irq 92 for MSI/MSI-X
[   57.196000] bnx2 0000:01:00.1: irq 93 for MSI/MSI-X
[   57.196008] bnx2 0000:01:00.1: irq 94 for MSI/MSI-X
[   57.196015] bnx2 0000:01:00.1: irq 95 for MSI/MSI-X
[   57.196024] bnx2 0000:01:00.1: irq 96 for MSI/MSI-X
[   57.196032] bnx2 0000:01:00.1: irq 97 for MSI/MSI-X
[   57.196038] bnx2 0000:01:00.1: irq 98 for MSI/MSI-X
[   57.196045] bnx2 0000:01:00.1: irq 99 for MSI/MSI-X
[   57.196052] bnx2 0000:01:00.1: irq 100 for MSI/MSI-X
[   57.282031] bnx2 0000:01:00.1: em2: using MSIX
[   57.284808] bonding: bond0: enslaving em2 as an active interface with 
a down link.
[   59.858529] bnx2 0000:01:00.0: em1: NIC Copper Link is Up, 1000 Mbps 
full duplex
[   59.959300] bonding: bond0: link status definitely up for interface 
em1, 1000 Mbps full duplex.
[   59.959412] bonding: bond0: making interface em1 the new active one.
[   59.962146] bonding: bond0: first active interface up!
[   60.041871] bnx2 0000:01:00.1: em2: NIC Copper Link is Up, 1000 Mbps 
full duplex
[   60.069254] bonding: bond0: link status definitely up for interface 
em2, 1000 Mbps full duplex.
[   60.223389] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.7 (July 
20, 2011)
