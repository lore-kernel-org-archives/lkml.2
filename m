Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab1LVQcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 11:32:35 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63426 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab1LVQcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 11:32:32 -0500
Message-ID: <4EF35B9A.1000709@gmail.com>
Date: Thu, 22 Dec 2011 08:32:26 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2 locks held by kswapd0/25
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

not sure what this is, but showed up with the current on my machine.
I was building glibc on qemu with fedora and was trying to mount an 
external disk drive but cant. seems the terminal just sits there.
dmesg shows this..:


  [16455.540093] usb 1-3: new high-speed USB device number 19 using ehci_hcd
[16455.657839] scsi8 : usb-storage 1-3:1.0
[16456.659451] scsi 8:0:0:0: Direct-Access     LGE      Android Platform 
0000 PQ: 0 ANSI: 2
[16456.665061] sd 8:0:0:0: [sdb] Attached SCSI removable disk
[16456.665372] sd 8:0:0:0: Attached scsi generic sg2 type 0
[17169.651321] kvm: 9881: cpu0 unimplemented perfctr wrmsr: 0xc1 data 0xabcd
[17640.437029] INFO: task kswapd0:25 blocked for more than 120 seconds.
[17640.437034] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[17640.437038] kswapd0         D f5763dc4     0    25      2 0x00000000
[17640.437044]  f5763dd4 00000046 00000002 f5763dc4 f5d0ca20 000002b9 
c16d2040 644aac07
[17640.437052]  00000fea c16d2040 00008355 00000000 f6006040 f5d0c5c0 
c1b4ee78 f5763da4
[17640.437060]  c11fd67b c105971d 00000000 00000046 c1b4ee78 00000046 
00000001 f5763db4
[17640.437069] Call Trace:
[17640.437081]  [<c11fd67b>] ? do_raw_spin_lock+0x3b/0xf0
[17640.437087]  [<c105971d>] ? prepare_to_wait+0x1d/0x70
[17640.437091]  [<c11fd7be>] ? do_raw_spin_unlock+0x4e/0x90
[17640.437097]  [<c1454ae0>] schedule+0x30/0x50
[17640.437102]  [<c115ef05>] ext4_ioend_wait+0x65/0x90
[17640.437106]  [<c10598b0>] ? __init_waitqueue_head+0x50/0x50
[17640.437110]  [<c115e540>] ext4_evict_inode+0x10/0x360
[17640.437113]  [<c11fd7be>] ? do_raw_spin_unlock+0x4e/0x90
[17640.437119]  [<c110977c>] evict+0x8c/0x170
[17640.437122]  [<c1109cfa>] dispose_list+0x2a/0x40
[17640.437126]  [<c110a5a2>] prune_icache_sb+0x122/0x2a0
[17640.437131]  [<c10f517c>] prune_super+0xfc/0x160
[17640.437137]  [<c10be93a>] shrink_slab+0x14a/0x210
[17640.437141]  [<c10c0cf7>] kswapd+0x537/0x7c0
[17640.437145]  [<c10598b0>] ? __init_waitqueue_head+0x50/0x50
[17640.437149]  [<c10c07c0>] ? shrink_zone+0x5b0/0x5b0
[17640.437152]  [<c1059283>] kthread+0x73/0x80
[17640.437156]  [<c1059210>] ? __init_kthread_worker+0x60/0x60
[17640.437161]  [<c145d53e>] kernel_thread_helper+0x6/0xd
[17640.437165] 2 locks held by kswapd0/25:
[17640.437167]  #0:  (shrinker_rwsem){......}, at: [<c10be814>] 
shrink_slab+0x24/0x210
[17640.437175]  #1:  (&type->s_umount_key#22){......}, at: [<c10f5021>] 
grab_super_passive+0x41/0xa0
[17880.437076] INFO: task kswapd0:25 blocked for more than 120 seconds.
[17880.437084] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[17880.437091] kswapd0         D f5763dc4     0    25      2 0x00000000
[17880.437102]  f5763dd4 00000046 00000002 f5763dc4 f5d0ca20 00000000 
c16d2040 87d11622
[17880.437120]  0000100c c16d2040 87d0e5ac 0000100c f6206040 f5d0c5c0 
c1b4ee78 f5763da4
[17880.437137]  c11fd67b c105971d 00000000 00000046 c1b4ee78 00000046 
00000001 f5763db4
[17880.437154] Call Trace:
[17880.437169]  [<c11fd67b>] ? do_raw_spin_lock+0x3b/0xf0
[17880.437179]  [<c105971d>] ? prepare_to_wait+0x1d/0x70
[17880.437186]  [<c11fd7be>] ? do_raw_spin_unlock+0x4e/0x90
[17880.437196]  [<c1454ae0>] schedule+0x30/0x50
[17880.437205]  [<c115ef05>] ext4_ioend_wait+0x65/0x90
[17880.437213]  [<c10598b0>] ? __init_waitqueue_head+0x50/0x50
[17880.437221]  [<c115e540>] ext4_evict_inode+0x10/0x360
[17880.437228]  [<c11fd7be>] ? do_raw_spin_unlock+0x4e/0x90
[17880.437238]  [<c110977c>] evict+0x8c/0x170
[17880.437246]  [<c1109cfa>] dispose_list+0x2a/0x40
[17880.437253]  [<c110a5a2>] prune_icache_sb+0x122/0x2a0
[17880.437262]  [<c10f517c>] prune_super+0xfc/0x160
[17880.437271]  [<c10be93a>] shrink_slab+0x14a/0x210
[17880.437279]  [<c10c0cf7>] kswapd+0x537/0x7c0
[17880.437288]  [<c10598b0>] ? __init_waitqueue_head+0x50/0x50
[17880.437296]  [<c10c07c0>] ? shrink_zone+0x5b0/0x5b0
[17880.437303]  [<c1059283>] kthread+0x73/0x80
[17880.437311]  [<c1059210>] ? __init_kthread_worker+0x60/0x60
[17880.437320]  [<c145d53e>] kernel_thread_helper+0x6/0xd
[17880.437327] 2 locks held by kswapd0/25:
[17880.437331]  #0:  (shrinker_rwsem){......}, at: [<c10be814>] 
shrink_slab+0x24/0x210
[17880.437345]  #1:  (&type->s_umount_key#22){......}, at: [<c10f5021>] 
grab_super_passive+0x41/0xa0
[18000.437048] INFO: task kswapd0:25 blocked for more than 120 seconds.
[18000.437053] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[18000.437056] kswapd0         D f5763dc4     0    25      2 0x00000000
[18000.437061]  f5763dd4 00000046 00000002 f5763dc4 f5d0ca20 00000000 
c16d2040 87d11622
[18000.437069]  0000100c c16d2040 87d0e5ac 0000100c f6206040 f5d0c5c0 
c1b4ee78 f5763da4
[18000.437077]  c11fd67b c105971d 00000000 00000046 c1b4ee78 00000046 
00000001 f5763db4
[18000.437086] Call Trace:
[18000.437096]  [<c11fd67b>] ? do_raw_spin_lock+0x3b/0xf0
[18000.437102]  [<c105971d>] ? prepare_to_wait+0x1d/0x70
[18000.437105]  [<c11fd7be>] ? do_raw_spin_unlock+0x4e/0x90
[18000.437111]  [<c1454ae0>] schedule+0x30/0x50
[18000.437116]  [<c115ef05>] ext4_ioend_wait+0x65/0x90
[18000.437119]  [<c10598b0>] ? __init_waitqueue_head+0x50/0x50
[18000.437123]  [<c115e540>] ext4_evict_inode+0x10/0x360
[18000.437126]  [<c11fd7be>] ? do_raw_spin_unlock+0x4e/0x90
[18000.437132]  [<c110977c>] evict+0x8c/0x170
[18000.437135]  [<c1109cfa>] dispose_list+0x2a/0x40
[18000.437139]  [<c110a5a2>] prune_icache_sb+0x122/0x2a0
[18000.437143]  [<c10f517c>] prune_super+0xfc/0x160
[18000.437148]  [<c10be93a>] shrink_slab+0x14a/0x210
[18000.437152]  [<c10c0cf7>] kswapd+0x537/0x7c0
[18000.437156]  [<c10598b0>] ? __init_waitqueue_head+0x50/0x50
[18000.437160]  [<c10c07c0>] ? shrink_zone+0x5b0/0x5b0
[18000.437163]  [<c1059283>] kthread+0x73/0x80
[18000.437167]  [<c1059210>] ? __init_kthread_worker+0x60/0x60
[18000.437171]  [<c145d53e>] kernel_thread_helper+0x6/0xd
[18000.437175] 2 locks held by kswapd0/25:
[18000.437177]  #0:  (shrinker_rwsem){......}, at: [<c10be814>] 
shrink_slab+0x24/0x210
[18000.437184]  #1:  (&type->s_umount_key#22){......}, at: [<c10f5021>] 
grab_super_passive+0x41/0xa0
[18153.336057] usb 1-3: USB disconnect, device number 19
[18480.437105] INFO: task chromium-browse:8641 blocked for more than 120 
seconds.
[18480.437113] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[18480.437120] chromium-browse D ef3b3ccc     0  8641      1 0x00000004
[18480.437131]  ef3b3cdc 00200046 00000002 ef3b3ccc c332a758 00000000 
c16d2040 8e67746f
[18480.437149]  000010b2 c16d2040 8e640e14 000010b2 f6206040 c332a2e0 
f67d4a78 ef3b3cac
[18480.437166]  c11fd67b c105971d 00000000 00200046 f67d4a78 00200046 
00000001 ef3b3cbc
[18480.437183] Call Trace:
[18480.437198]  [<c11fd67b>] ? do_raw_spin_lock+0x3b/0xf0
[18480.437209]  [<c105971d>] ? prepare_to_wait+0x1d/0x70
[18480.437217]  [<c11fd7be>] ? do_raw_spin_unlock+0x4e/0x90
[18480.437227]  [<c1454ae0>] schedule+0x30/0x50
[18480.437237]  [<c1108c8a>] __wait_on_freeing_inode+0x7a/0xa0
[18480.437245]  [<c10598f0>] ? autoremove_wake_function+0x40/0x40
[18480.437253]  [<c1108d10>] find_inode_fast+0x60/0xa0
[18480.437261]  [<c1456dd5>] ? _raw_spin_lock+0x45/0x50
[18480.437268]  [<c110a05b>] iget_locked+0x5b/0x190
[18480.437277]  [<c1159fd1>] ext4_iget+0x21/0x800
[18480.437286]  [<c1060039>] ? prepare_kernel_cred+0x119/0x160
[18480.437294]  [<c11fd67b>] ? do_raw_spin_lock+0x3b/0xf0
[18480.437303]  [<c116137f>] ext4_lookup+0x7f/0x120
[18480.437310]  [<c11fd7be>] ? do_raw_spin_unlock+0x4e/0x90
[18480.437317]  [<c145723d>] ? _raw_spin_unlock+0x1d/0x30
[18480.437325]  [<c10fb932>] d_alloc_and_lookup+0x32/0x60
[18480.437332]  [<c10fdae4>] do_lookup+0x294/0x370
[18480.437340]  [<c10fe939>] path_lookupat+0xf9/0x690
[18480.437348]  [<c10e6404>] ? kmem_cache_alloc+0x44/0xe0
[18480.437357]  [<c11f7f86>] ? strncpy_from_user+0x46/0x80
[18480.437364]  [<c10feef7>] do_path_lookup+0x27/0xb0
[18480.437372]  [<c1100031>] user_path_at_empty+0x41/0x80
[18480.437381]  [<c10f6535>] ? cp_new_stat64+0xe5/0x110
[18480.437388]  [<c110008a>] user_path_at+0x1a/0x20
[18480.437395]  [<c10f6983>] vfs_fstatat+0x43/0x70
[18480.437403]  [<c10f69eb>] vfs_stat+0x1b/0x20
[18480.437410]  [<c10f6c51>] sys_stat64+0x11/0x30
[18480.437418]  [<c11081a4>] ? dynamic_dname+0x34/0x70
[18480.437427]  [<c145cfab>] ? sysenter_do_call+0x1e/0x33
[18480.437434]  [<c145cf9f>] sysenter_do_call+0x12/0x33
[18480.437441] 1 lock held by chromium-browse/8641:
[18480.437446]  #0:  (&sb->s_type->i_mutex_key#13){......}, at: 
[<c10fdac0>] do_lookup+0x270/0x370
[18600.437127] INFO: task chromium-browse:8622 blocked for more than 120 
seconds.
[18600.437135] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[18600.437141] chromium-browse D d5925de8     0  8622      1 0x00000000
[18600.437152]  d5925df8 00200046 00000002 d5925de8 f53554f0 00000000 
c16d2040 3ca75704
[18600.437170]  000010c7 c16d2040 3ca7312e 000010c7 f6006040 c9b022e0 
c9b022e0 000001b2
[18600.437187]  c9b022e0 00000000 f51ae080 d5925de4 00200246 00000001 
00000000 00000000
[18600.437204] Call Trace:
[18600.437219]  [<c104229b>] ? exit_mm+0x2b/0x100
[18600.437229]  [<c1454ae0>] schedule+0x30/0x50
[18600.437236]  [<c10422d5>] exit_mm+0x65/0x100
[18600.437244]  [<c1042497>] do_exit+0x127/0x760
[18600.437252]  [<c104ba22>] ? recalc_sigpending+0x12/0x40
[18600.437259]  [<c104bdbc>] ? dequeue_signal+0x2c/0x190
[18600.437267]  [<c1042d63>] do_group_exit+0x33/0x90
[18600.437274]  [<c104df7a>] get_signal_to_deliver+0x17a/0x540
[18600.437283]  [<c145723d>] ? _raw_spin_unlock+0x1d/0x30
[18600.437291]  [<c1001f97>] do_signal+0x47/0x810
[18600.437300]  [<c1070f36>] ? do_futex+0xf6/0x8f0
[18600.437309]  [<c110d325>] ? mntput_no_expire+0x25/0xd0
[18600.437316]  [<c110d3e3>] ? mntput+0x13/0x20
[18600.437324]  [<c10f3e11>] ? fput+0x171/0x230
[18600.437332]  [<c10717f4>] ? sys_futex+0xc4/0x130
[18600.437341]  [<c11f823b>] ? copy_to_user+0x4b/0x60
[18600.437348]  [<c1002945>] do_notify_resume+0x65/0x70
[18600.437356]  [<c14578c3>] work_notifysig+0x13/0x18
[18600.437365]  [<c1450000>] ? audit_log_exit+0xdd0/0xe7d
[18600.437371] no locks held by chromium-browse/8622.
[18600.437376] INFO: task chromium-browse:8629 blocked for more than 120 
seconds.
[18600.437382] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[18600.437387] chromium-browse D 00000000     0  8629      1 0x00000000
[18600.437397]  f5c59df8 00200046 c9b05730 00000000 f5355900 00200046 
c16d2040 3ca52c31
[18600.437413]  000010c7 c16d2040 00000000 00000000 f6006040 c9b05730 
c9b05730 000001b2
[18600.437429]  c9b05730 00000000 f51ae080 f5c59de4 00200246 00000001 
00000000 00000000
[18600.437446] Call Trace:
[18600.437454]  [<c104229b>] ? exit_mm+0x2b/0x100
[18600.437461]  [<c1454ae0>] schedule+0x30/0x50
[18600.437468]  [<c10422d5>] exit_mm+0x65/0x100
[18600.437475]  [<c1042497>] do_exit+0x127/0x760
[18600.437483]  [<c103772e>] ? scheduler_ipi+0x4e/0xf0
[18600.437491]  [<c1016622>] ? smp_reschedule_interrupt+0x22/0x30
[18600.437499]  [<c1457971>] ? reschedule_interrupt+0x31/0x38
[18600.437507]  [<c1042d63>] do_group_exit+0x33/0x90
[18600.437514]  [<c14571af>] ? _raw_spin_unlock_irq+0x1f/0x40
[18600.437522]  [<c104df7a>] get_signal_to_deliver+0x17a/0x540
[18600.437531]  [<c11fd7be>] ? do_raw_spin_unlock+0x4e/0x90
[18600.437538]  [<c1001f97>] do_signal+0x47/0x810
[18600.437546]  [<c1457971>] ? reschedule_interrupt+0x31/0x38
[18600.437553]  [<c11fd7be>] ? do_raw_spin_unlock+0x4e/0x90
[18600.437563]  [<c112afb3>] ? sys_epoll_wait+0x63/0x390
[18600.437571]  [<c10375d0>] ? try_to_wake_up+0x240/0x240
[18600.437578]  [<c11f823b>] ? copy_to_user+0x4b/0x60
[18600.437585]  [<c1002945>] do_notify_resume+0x65/0x70
[18600.437593]  [<c14578c3>] work_notifysig+0x13/0x18
[18600.437598] no locks held by chromium-browse/8629.
[18600.437603] INFO: task chromium-browse:8630 blocked for more than 120 
seconds.
[18600.437609] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[18600.437614] chromium-browse D c9d03de8     0  8630      1 0x00000000
[18600.437624]  c9d03df8 00200046 00000002 c9d03de8 f51a2218 0114e9f0 
c16d2040 3ca7312e
[18600.437640]  000010c7 c16d2040 00000000 00000000 f6006040 c332b450 
c332b450 000001b2
[18600.437657]  c332b450 00000000 f51ae080 c9d03de4 00200246 00000001 
00000000 00000000
[18600.437673] Call Trace:
[18600.437681]  [<c104229b>] ? exit_mm+0x2b/0x100
[18600.437688]  [<c1454ae0>] schedule+0x30/0x50
[18600.437695]  [<c10422d5>] exit_mm+0x65/0x100
[18600.437702]  [<c1042497>] do_exit+0x127/0x760
[18600.437709]  [<c104ba22>] ? recalc_sigpending+0x12/0x40
[18600.437716]  [<c104bdbc>] ? dequeue_signal+0x2c/0x190
[18600.437723]  [<c1042d63>] do_group_exit+0x33/0x90
[18600.437731]  [<c104df7a>] get_signal_to_deliver+0x17a/0x540
[18600.437739]  [<c1001f97>] do_signal+0x47/0x810
[18600.437746]  [<c11fd7be>] ? do_raw_spin_unlock+0x4e/0x90
[18600.437754]  [<c1059998>] ? finish_wait+0x48/0x60
[18600.437764]  [<c1103e90>] ? sys_select+0x90/0xb0
[18600.437771]  [<c1002945>] do_notify_resume+0x65/0x70
[18600.437779]  [<c14578c3>] work_notifysig+0x13/0x18
[18600.437784] no locks held by chromium-browse/8630.
[18600.437789] INFO: task chromium-browse:8631 blocked for more than 120 
seconds.
[18600.437794] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[18600.437799] chromium-browse D 00000000     0  8631      1 0x00000000
[18600.437808]  c9ffddf8 00200046 c9b068a0 00000000 f5355420 00200046 
c16d2040 3ca6f456
[18600.437825]  000010c7 c16d2040 00000000 00000000 f6006040 c9b068a0 
c9b068a0 000001b2
[18600.437841]  c9b068a0 00000000 f51ae080 c9ffdde4 00200246 00000001 
00000000 00000000
[18600.437857] Call Trace:
[18600.437865]  [<c104229b>] ? exit_mm+0x2b/0x100
[18600.437872]  [<c1454ae0>] schedule+0x30/0x50
[18600.437879]  [<c10422d5>] exit_mm+0x65/0x100
[18600.437886]  [<c1042497>] do_exit+0x127/0x760
[18600.437893]  [<c104ba22>] ? recalc_sigpending+0x12/0x40
[18600.437901]  [<c104bdbc>] ? dequeue_signal+0x2c/0x190
[18600.437908]  [<c1042d63>] do_group_exit+0x33/0x90
[18600.437916]  [<c104df7a>] get_signal_to_deliver+0x17a/0x540
[18600.437923]  [<c1001f97>] do_signal+0x47/0x810
[18600.437932]  [<c10f2087>] ? rw_verify_area+0x67/0x120
[18600.437939]  [<c10f2547>] ? vfs_read+0x87/0x160
[18600.437946]  [<c10f19a0>] ? do_sync_write+0xe0/0xe0
[18600.437953]  [<c10f39c0>] ? fget_light+0x30/0x130
[18600.437960]  [<c10f2674>] ? sys_read+0x54/0x70
[18600.437967]  [<c1002945>] do_notify_resume+0x65/0x70
[18600.437975]  [<c14578c3>] work_notifysig+0x13/0x18
[18600.437980] no locks held by chromium-browse/8631.
[18600.437985] INFO: task chromium-browse:8632 blocked for more than 120 
seconds.
[18600.437990] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[18600.437995] chromium-browse D c79fbde8     0  8632      1 0x00000000
[18600.438029]  c79fbdf8 00200046 00000002 c79fbde8 f5355f18 0114e9f0 
c16d2040 3ca6d05a
[18600.438048]  000010c7 c16d2040 00000000 00000000 f6006040 c9b01170 
c9b01170 000001b2
[18600.438080]  c9b01170 00000000 f51ae080 c79fbde4 00200246 00000001 
00000000 00000000
[18600.438116] Call Trace:
[18600.438126]  [<c104229b>] ? exit_mm+0x2b/0x100
[18600.438138]  [<c1454ae0>] schedule+0x30/0x50
[18600.438148]  [<c10422d5>] exit_mm+0x65/0x100
[18600.438159]  [<c1042497>] do_exit+0x127/0x760
[18600.438170]  [<c104ba22>] ? recalc_sigpending+0x12/0x40
[18600.438179]  [<c104bdbc>] ? dequeue_signal+0x2c/0x190
[18600.438193]  [<c1042d63>] do_group_exit+0x33/0x90
[18600.438203]  [<c104df7a>] get_signal_to_deliver+0x17a/0x540
[18600.438214]  [<c1001f97>] do_signal+0x47/0x810
[18600.438225]  [<c1070f36>] ? do_futex+0xf6/0x8f0
[18600.438240]  [<c145a790>] ? vmalloc_fault+0xe3/0xe3
[18600.438249]  [<c105e2f6>] ? up_read+0x16/0x30
[18600.438258]  [<c145a96b>] ? do_page_fault+0x1db/0x4c0
[18600.438267]  [<c10717f4>] ? sys_futex+0xc4/0x130
[18600.438277]  [<c11f823b>] ? copy_to_user+0x4b/0x60
[18600.438287]  [<c1002945>] do_notify_resume+0x65/0x70
[18600.438300]  [<c14578c3>] work_notifysig+0x13/0x18
[18600.438310]  [<c1450000>] ? audit_log_exit+0xdd0/0xe7d
[18600.438318] no locks held by chromium-browse/8632.
[18600.438327] INFO: task chromium-browse:8641 blocked for more than 120 
seconds.
[18600.438334] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[18600.438341] chromium-browse D ef3b3ccc     0  8641      1 0x00000004
[18600.438358]  ef3b3cdc 00200046 00000002 ef3b3ccc c332a758 00000000 
c16d2040 8e67746f
[18600.438388]  000010b2 c16d2040 8e640e14 000010b2 f6206040 c332a2e0 
f67d4a78 ef3b3cac
[18600.438424]  c11fd67b c105971d 00000000 00200046 f67d4a78 00200046 
00000001 ef3b3cbc
[18600.438453] Call Trace:
[18600.438467]  [<c11fd67b>] ? do_raw_spin_lock+0x3b/0xf0
[18600.438479]  [<c105971d>] ? prepare_to_wait+0x1d/0x70
[18600.438492]  [<c11fd7be>] ? do_raw_spin_unlock+0x4e/0x90
[18600.438507]  [<c1454ae0>] schedule+0x30/0x50
[18600.438519]  [<c1108c8a>] __wait_on_freeing_inode+0x7a/0xa0
[18600.438529]  [<c10598f0>] ? autoremove_wake_function+0x40/0x40
[18600.438544]  [<c1108d10>] find_inode_fast+0x60/0xa0
[18600.438554]  [<c1456dd5>] ? _raw_spin_lock+0x45/0x50
[18600.438566]  [<c110a05b>] iget_locked+0x5b/0x190
[18600.438577]  [<c1159fd1>] ext4_iget+0x21/0x800
[18600.438591]  [<c1060039>] ? prepare_kernel_cred+0x119/0x160
[18600.438602]  [<c11fd67b>] ? do_raw_spin_lock+0x3b/0xf0
[18600.438618]  [<c116137f>] ext4_lookup+0x7f/0x120
[18600.438629]  [<c11fd7be>] ? do_raw_spin_unlock+0x4e/0x90
[18600.438638]  [<c145723d>] ? _raw_spin_unlock+0x1d/0x30
[18600.438650]  [<c10fb932>] d_alloc_and_lookup+0x32/0x60
[18600.438661]  [<c10fdae4>] do_lookup+0x294/0x370
[18600.438672]  [<c10fe939>] path_lookupat+0xf9/0x690
[18600.438685]  [<c10e6404>] ? kmem_cache_alloc+0x44/0xe0
[18600.438695]  [<c11f7f86>] ? strncpy_from_user+0x46/0x80
[18600.438709]  [<c10feef7>] do_path_lookup+0x27/0xb0
[18600.438718]  [<c1100031>] user_path_at_empty+0x41/0x80
[18600.438734]  [<c10f6535>] ? cp_new_stat64+0xe5/0x110
[18600.438748]  [<c110008a>] user_path_at+0x1a/0x20
[18600.438759]  [<c10f6983>] vfs_fstatat+0x43/0x70
[18600.438770]  [<c10f69eb>] vfs_stat+0x1b/0x20
[18600.438784]  [<c10f6c51>] sys_stat64+0x11/0x30
[18600.438797]  [<c11081a4>] ? dynamic_dname+0x34/0x70
[18600.438807]  [<c145cfab>] ? sysenter_do_call+0x1e/0x33
[18600.438817]  [<c145cf9f>] sysenter_do_call+0x12/0x33
[18600.438825] 1 lock held by chromium-browse/8641:
[18600.438831]  #0:  (&sb->s_type->i_mutex_key#13){......}, at: 
[<c10fdac0>] do_lookup+0x270/0x370
[20058.757063] usb 1-3: new high-speed USB device number 20 using ehci_hcd
[20058.874935] scsi9 : usb-storage 1-3:1.0
[20059.878221] scsi 9:0:0:0: Direct-Access     WDC WD60 WP-32LPV0 
  0000 PQ: 0 ANSI: 0
[20059.879606] sd 9:0:0:0: Attached scsi generic sg2 type 0
[20059.880654] sd 9:0:0:0: [sdb] 12000556 512-byte logical blocks: (6.14 
GB/5.72 GiB)
[20059.881656] sd 9:0:0:0: [sdb] Write Protect is off
[20059.881661] sd 9:0:0:0: [sdb] Mode Sense: 27 00 00 00
[20059.882529] sd 9:0:0:0: [sdb] No Caching mode page present
[20059.882535] sd 9:0:0:0: [sdb] Assuming drive cache: write through
[20059.886692] sd 9:0:0:0: [sdb] No Caching mode page present
[20059.886701] sd 9:0:0:0: [sdb] Assuming drive cache: write through
[20061.596450]  sdb: sdb1
[20061.600993] sd 9:0:0:0: [sdb] No Caching mode page present
[20061.600997] sd 9:0:0:0: [sdb] Assuming drive cache: write through
[20061.601018] sd 9:0:0:0: [sdb] Attached SCSI disk

will keep an eye on this, and if it continues I will try a bisect on it.

Justin P. Mattock
