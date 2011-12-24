Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab1LXOLY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 09:11:24 -0500
Received: from lo.gmane.org ([80.91.229.12]:42958 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887Ab1LXOLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 09:11:21 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jonathan Hudson <jh+lkm@daria.co.uk>
Subject: 3.2rc7 rcu_preempt stalls and tasks blocked.
Date: Sat, 24 Dec 2011 14:09:12 +0000
Message-ID: <bcf.4ef5dd08.61f72@roo.daria.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 82-68-140-1.dsl.in-addr.zen.co.uk
X-Archive: encrypt
X-Newsreader: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ever since 3.1, I've been experiencing rcu_preempt stalls, tasks
blocked and subsequent lock ups on an eeepc 901. Judging by the thread
<https://bugs.archlinux.org/task/26847> on the Arch forums, this is not
an uncommon experience. 

3.2rc7 was built from kernel.org (no vendor patches) today, and it still
happens, particularly when both wired and wireless networks are enabled.


Dec 24 13:41:16 woozle kernel: [  147.243431] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=18002 jiffies)
Dec 24 13:41:16 woozle kernel: [  147.243461] INFO: Stall ended before state dump start
Dec 24 13:44:17 woozle kernel: [  327.350068] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=72034 jiffies)
Dec 24 13:44:17 woozle kernel: [  327.350099] INFO: Stall ended before state dump start
Dec 24 13:44:50 woozle kernel: [  360.523512] INFO: task Xorg:992 blocked for more than 120 seconds.
Dec 24 13:44:50 woozle kernel: [  360.523527] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 24 13:44:50 woozle kernel: [  360.523541] Xorg            D f3e0f0ec     0   992    975 0x00400000
Dec 24 13:44:50 woozle kernel: [  360.523562]  f3385e5c 00003086 f3342480 f3e0f0ec 00000001 8b5bbeb8 0000002c 00000010
Dec 24 13:44:50 woozle kernel: [  360.523593]  c064c140 f7402be0 c064c140 f6007140 f5505ea0 f4979a40 f3e0ebf0 f3e0eb1c
Dec 24 13:44:50 woozle kernel: [  360.523622]  0000001b 00000000 f3385e58 c01d7664 f7404660 00000000 f332f168 f3385e3c
Dec 24 13:44:50 woozle kernel: [  360.523651] Call Trace:
Dec 24 13:44:50 woozle kernel: [  360.523681]  [<c01d7664>] ? filemap_fault+0x84/0x3d0
Dec 24 13:44:50 woozle kernel: [  360.523709]  [<c02d0501>] ? cpumask_any_but+0x21/0x40
Dec 24 13:44:50 woozle kernel: [  360.523721]  [<c012d905>] ? flush_tlb_page+0x45/0xb0
Dec 24 13:44:50 woozle kernel: [  360.523730]  [<c046bec5>] schedule+0x35/0x50
Dec 24 13:44:50 woozle kernel: [  360.523738]  [<c046c475>] schedule_timeout+0x265/0x2e0
Dec 24 13:44:50 woozle kernel: [  360.523746]  [<c01f4635>] ? do_wp_page+0x325/0x7a0
Dec 24 13:44:50 woozle kernel: [  360.523756]  [<c021a975>] ? mem_cgroup_get_reclaim_stat_from_page+0x25/0x50
Dec 24 13:44:50 woozle kernel: [  360.523765]  [<c01f6232>] ? handle_pte_fault+0x232/0x8e0
Dec 24 13:44:50 woozle kernel: [  360.523774]  [<c046b307>] wait_for_common+0x97/0x120
Dec 24 13:44:50 woozle kernel: [  360.523783]  [<c0142360>] ? try_to_wake_up+0x210/0x210
Dec 24 13:44:50 woozle kernel: [  360.523792]  [<c01a6b20>] ? __call_rcu+0x120/0x120
Dec 24 13:44:50 woozle kernel: [  360.523800]  [<c046b3a7>] wait_for_completion+0x17/0x20
Dec 24 13:44:50 woozle kernel: [  360.523808]  [<c0163584>] wait_rcu_gp+0x34/0x40
Dec 24 13:44:50 woozle kernel: [  360.523815]  [<c0163590>] ? wait_rcu_gp+0x40/0x40
Dec 24 13:44:50 woozle kernel: [  360.523823]  [<c01a56f2>] synchronize_rcu+0x22/0x30
Dec 24 13:44:50 woozle kernel: [  360.523853]  [<f8c45112>] evdev_release+0x62/0xe0 [evdev]
Dec 24 13:44:50 woozle kernel: [  360.523862]  [<c0222f9a>] fput+0xaa/0x1e0
Dec 24 13:44:50 woozle kernel: [  360.523869]  [<c021f994>] filp_close+0x54/0x80
Dec 24 13:44:50 woozle kernel: [  360.523877]  [<c021fa32>] sys_close+0x72/0xc0
Dec 24 13:44:50 woozle kernel: [  360.523884]  [<c046f05f>] sysenter_do_call+0x12/0x28
Dec 24 13:44:50 woozle kernel: [  360.523918] INFO: task umount:1802 blocked for more than 120 seconds.
Dec 24 13:44:50 woozle kernel: [  360.523923] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 24 13:44:50 woozle kernel: [  360.523928] umount          D f082bddc     0  1802      1 0x00000000
Dec 24 13:44:50 woozle kernel: [  360.523938]  f082be54 00000086 c0648080 f082bddc c046be71 e315bbbf 0000002b f082be04
Dec 24 13:44:50 woozle kernel: [  360.523952]  c064c140 f082bdf4 c064c140 f6207140 f0eaf8e0 f23588c0 c046d2d6 00000000
Dec 24 13:44:50 woozle kernel: [  360.523966]  c058b14c 00000246 f0eaf8e0 22222222 22222222 c058b144 f082be34 00000246
Dec 24 13:44:50 woozle kernel: [  360.523981] Call Trace:
Dec 24 13:44:50 woozle kernel: [  360.523988]  [<c046be71>] ? preempt_schedule+0x31/0x50
Dec 24 13:44:50 woozle kernel: [  360.523997]  [<c046d2d6>] ? __mutex_lock_slowpath+0x216/0x2f0
Dec 24 13:44:50 woozle kernel: [  360.524006]  [<c046d0bd>] ? mutex_unlock+0xd/0x10
Dec 24 13:44:50 woozle kernel: [  360.524014]  [<c046bec5>] schedule+0x35/0x50
Dec 24 13:44:50 woozle kernel: [  360.524022]  [<c01a677d>] synchronize_rcu_expedited+0xbd/0x1e0
Dec 24 13:44:50 woozle kernel: [  360.524031]  [<c0166530>] ? abort_exclusive_wait+0x80/0x80
Dec 24 13:44:50 woozle kernel: [  360.524039]  [<c01ef71a>] bdi_unregister+0x15a/0x1a0
Dec 24 13:44:50 woozle kernel: [  360.524047]  [<c01f00e5>] bdi_destroy+0xd5/0x130
Dec 24 13:44:50 woozle kernel: [  360.524070]  [<f8bd5e1f>] fuse_conn_kill+0xdf/0xf0 [fuse]
Dec 24 13:44:50 woozle kernel: [  360.524086]  [<f8bd6278>] fuse_put_super+0x58/0x70 [fuse]
Dec 24 13:44:50 woozle kernel: [  360.524094]  [<c02234d1>] generic_shutdown_super+0x51/0xc0
Dec 24 13:44:50 woozle kernel: [  360.524102]  [<c01f0c5a>] ? pcpu_chunk_relocate+0x1a/0x90
Dec 24 13:44:50 woozle kernel: [  360.524110]  [<c02235c1>] kill_anon_super+0x11/0x20
Dec 24 13:44:50 woozle kernel: [  360.524126]  [<f8bd5455>] fuse_kill_sb_anon+0x45/0x60 [fuse]
Dec 24 13:44:50 woozle kernel: [  360.524137]  [<c02238cf>] deactivate_locked_super+0x2f/0x80
Dec 24 13:44:50 woozle kernel: [  360.524145]  [<c02241f7>] deactivate_super+0x47/0x60
Dec 24 13:44:50 woozle kernel: [  360.524153]  [<c023c117>] mntput_no_expire+0x87/0xd0
Dec 24 13:44:50 woozle kernel: [  360.524161]  [<c023c178>] mntput+0x18/0x30
Dec 24 13:44:50 woozle kernel: [  360.524168]  [<c023c925>] release_mounts+0x65/0x80
Dec 24 13:44:50 woozle kernel: [  360.524176]  [<c023ce31>] sys_umount+0x1a1/0x330
Dec 24 13:44:50 woozle kernel: [  360.524185]  [<c046f05f>] sysenter_do_call+0x12/0x28
Dec 24 13:46:50 woozle kernel: [  480.523467] INFO: task kworker/0:2:59 blocked for more than 120 seconds.
Dec 24 13:46:50 woozle kernel: [  480.523483] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 24 13:46:50 woozle kernel: [  480.523496] kworker/0:2     D f4d2bdc4     0    59      2 0x00000000
Dec 24 13:46:50 woozle kernel: [  480.523518]  f4d2bdd4 00000046 00000002 f4d2bdc4 f6007140 c04739c0 f4d2bd74 00000000
Dec 24 13:46:50 woozle kernel: [  480.523549]  c064c140 f6007140 c064c140 f6007140 f4ce8d20 c0584020 f2e7ad90 f4d2bd94
Dec 24 13:46:50 woozle kernel: [  480.523578]  c02d0478 00000001 f6207140 f4d2be78 c013f110 c01414b8 f4d2beec 00000400
Dec 24 13:46:50 woozle kernel: [  480.523607] Call Trace:
Dec 24 13:46:50 woozle kernel: [  480.523636]  [<c02d0478>] ? cpumask_next_and+0x28/0x40
Dec 24 13:46:50 woozle kernel: [  480.523656]  [<c013f110>] ? find_busiest_group+0x150/0xaf0
Dec 24 13:46:50 woozle kernel: [  480.523673]  [<c01414b8>] ? ttwu_do_activate.constprop.173+0x58/0x70
Dec 24 13:46:50 woozle kernel: [  480.523692]  [<c046bec5>] schedule+0x35/0x50
Dec 24 13:46:50 woozle kernel: [  480.523716]  [<c046c475>] schedule_timeout+0x265/0x2e0
Dec 24 13:46:50 woozle kernel: [  480.523727]  [<c046b307>] wait_for_common+0x97/0x120
Dec 24 13:46:50 woozle kernel: [  480.523735]  [<c0142360>] ? try_to_wake_up+0x210/0x210
Dec 24 13:46:50 woozle kernel: [  480.523744]  [<c01a6b20>] ? __call_rcu+0x120/0x120
Dec 24 13:46:50 woozle kernel: [  480.523752]  [<c046b3a7>] wait_for_completion+0x17/0x20
Dec 24 13:46:50 woozle kernel: [  480.523760]  [<c0163584>] wait_rcu_gp+0x34/0x40
Dec 24 13:46:50 woozle kernel: [  480.523767]  [<c0163590>] ? wait_rcu_gp+0x40/0x40
Dec 24 13:46:50 woozle kernel: [  480.523776]  [<c01a56f2>] synchronize_rcu+0x22/0x30
Dec 24 13:46:50 woozle kernel: [  480.523784]  [<c01a672e>] synchronize_rcu_expedited+0x6e/0x1e0
Dec 24 13:46:50 woozle kernel: [  480.523792]  [<c0155df8>] ? del_timer+0x68/0xf0
Dec 24 13:46:50 woozle kernel: [  480.523799]  [<c046e19d>] ? _raw_spin_unlock_bh+0x1d/0x20
Dec 24 13:46:50 woozle kernel: [  480.523808]  [<c03c1865>] synchronize_net+0x25/0x30
Dec 24 13:46:50 woozle kernel: [  480.523816]  [<c03de3bc>] dev_deactivate_many+0x1dc/0x1f0
Dec 24 13:46:50 woozle kernel: [  480.523824]  [<c03de3f4>] dev_deactivate+0x24/0x40
Dec 24 13:46:50 woozle kernel: [  480.523832]  [<c03d44aa>] linkwatch_do_dev+0x6a/0xb0
Dec 24 13:46:50 woozle kernel: [  480.523840]  [<c03d476b>] __linkwatch_run_queue+0xcb/0x180
Dec 24 13:46:50 woozle kernel: [  480.523848]  [<c03d4840>] linkwatch_event+0x20/0x30
Dec 24 13:46:50 woozle kernel: [  480.523856]  [<c01610ea>] process_one_work+0xfa/0x3e0
Dec 24 13:46:50 woozle kernel: [  480.523864]  [<c015f2c7>] ? destroy_worker+0x77/0xa0
Dec 24 13:46:50 woozle kernel: [  480.523872]  [<c03d4820>] ? __linkwatch_run_queue+0x180/0x180
Dec 24 13:46:50 woozle kernel: [  480.523881]  [<c01618b4>] worker_thread+0x124/0x2c0
Dec 24 13:46:50 woozle kernel: [  480.523889]  [<c0161790>] ? manage_workers.isra.27+0x1e0/0x1e0
Dec 24 13:46:50 woozle kernel: [  480.523897]  [<c0165e5d>] kthread+0x6d/0x80
Dec 24 13:46:50 woozle kernel: [  480.523905]  [<c0165df0>] ? kthread_worker_fn+0x160/0x160
Dec 24 13:46:50 woozle kernel: [  480.523913]  [<c046f5fe>] kernel_thread_helper+0x6/0x10
Dec 24 13:46:50 woozle kernel: [  480.523930] INFO: task NetworkManager:721 blocked for more than 120 seconds.
Dec 24 13:46:50 woozle kernel: [  480.523935] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 24 13:46:50 woozle kernel: [  480.523941] NetworkManager  D f36d9c68     0   721      1 0x00000000
Dec 24 13:46:50 woozle kernel: [  480.523950]  f36d9c78 00000086 00000002 f36d9c68 f36d9c1c f36d9f98 00000001 00000000
Dec 24 13:46:50 woozle kernel: [  480.523965]  c064c140 00000000 c064c140 f6207140 f4ddc460 f547b020 000004d0 f4ddc460
Dec 24 13:46:50 woozle kernel: [  480.523979]  00000296 c03b96fe 000000d0 f6207908 00000292 00000000 f089a6c0 f6207908
Dec 24 13:46:50 woozle kernel: [  480.523993] Call Trace:
Dec 24 13:46:50 woozle kernel: [  480.524002]  [<c03b96fe>] ? __alloc_skb+0x2e/0x200
Dec 24 13:46:50 woozle kernel: [  480.524011]  [<c016c8ed>] ? sched_clock_cpu+0x5d/0x150
Dec 24 13:46:50 woozle kernel: [  480.524019]  [<c046bec5>] schedule+0x35/0x50
Dec 24 13:46:50 woozle kernel: [  480.524027]  [<c046d1e0>] __mutex_lock_slowpath+0x120/0x2f0
Dec 24 13:46:50 woozle kernel: [  480.524035]  [<c046d3c0>] mutex_lock+0x10/0x20
Dec 24 13:46:50 woozle kernel: [  480.524042]  [<c03d2712>] rtnl_lock+0x12/0x20
Dec 24 13:46:50 woozle kernel: [  480.524049]  [<c03d2730>] rtnetlink_rcv+0x10/0x30
Dec 24 13:46:50 woozle kernel: [  480.524057]  [<c03e738d>] netlink_unicast+0x24d/0x290
Dec 24 13:46:50 woozle kernel: [  480.524065]  [<c03e7668>] netlink_sendmsg+0x1e8/0x320
Dec 24 13:46:50 woozle kernel: [  480.524074]  [<c03b1727>] sock_sendmsg+0xf7/0x120
Dec 24 13:46:50 woozle kernel: [  480.524084]  [<c03b1727>] ? sock_sendmsg+0xf7/0x120
Dec 24 13:46:50 woozle kernel: [  480.524101]  [<c02daae5>] ? _copy_from_user+0x35/0x50
Dec 24 13:46:50 woozle kernel: [  480.524109]  [<c03bc834>] ? verify_iovec+0x44/0xb0
Dec 24 13:46:50 woozle kernel: [  480.524117]  [<c03b1a72>] __sys_sendmsg+0x252/0x260
Dec 24 13:46:50 woozle kernel: [  480.524126]  [<c0222cd6>] ? fget_light+0x76/0xe0
Dec 24 13:46:50 woozle kernel: [  480.524136]  [<c03b0bb8>] ? sock_destroy_inode+0x28/0x30
Dec 24 13:46:50 woozle kernel: [  480.524144]  [<c03b0bb8>] ? sock_destroy_inode+0x28/0x30
Dec 24 13:46:50 woozle kernel: [  480.524153]  [<c0234b69>] ? __d_free+0x39/0x60
Dec 24 13:46:50 woozle kernel: [  480.524160]  [<c0234b69>] ? __d_free+0x39/0x60
Dec 24 13:46:50 woozle kernel: [  480.524168]  [<c0234b69>] ? __d_free+0x39/0x60
Dec 24 13:46:50 woozle kernel: [  480.524175]  [<c0222cd6>] ? fget_light+0x76/0xe0
Dec 24 13:46:50 woozle kernel: [  480.524183]  [<c03b3a9b>] sys_sendmsg+0x3b/0x60
Dec 24 13:46:50 woozle kernel: [  480.524190]  [<c03b4113>] sys_socketcall+0x263/0x2c0
Dec 24 13:46:50 woozle kernel: [  480.524199]  [<c014d419>] ? sys_time+0x19/0x40
Dec 24 13:46:50 woozle kernel: [  480.524206]  [<c046f05f>] sysenter_do_call+0x12/0x28
Dec 24 13:46:50 woozle kernel: [  480.524215] INFO: task ntpd:797 blocked for more than 120 seconds.
Dec 24 13:46:50 woozle kernel: [  480.524220] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 24 13:46:50 woozle kernel: [  480.524225] ntpd            D f3735e1c     0   797      1 0x00000004
Dec 24 13:46:50 woozle kernel: [  480.524234]  f3735e2c 00200086 00000002 f3735e1c 718df245 0000004f c0647ec0 00000000
Dec 24 13:46:50 woozle kernel: [  480.524248]  c064c140 00100100 c064c140 f6207140 f4e948c0 f547b020 f3758030 00200082
Dec 24 13:46:50 woozle kernel: [  480.524263]  00000000 718df245 00000000 f3735e04 c016ab76 00000000 00000000 00000001
Dec 24 13:46:50 woozle kernel: [  480.524276] Call Trace:
Dec 24 13:46:50 woozle kernel: [  480.524285]  [<c016ab76>] ? hrtimer_start_range_ns+0x26/0x30
Dec 24 13:46:50 woozle kernel: [  480.524293]  [<c016501e>] ? do_schedule_next_timer+0x3e/0xf0
Dec 24 13:46:50 woozle kernel: [  480.524302]  [<c046bec5>] schedule+0x35/0x50
Dec 24 13:46:50 woozle kernel: [  480.524309]  [<c046d1e0>] __mutex_lock_slowpath+0x120/0x2f0
Dec 24 13:46:50 woozle kernel: [  480.524318]  [<c046d3c0>] mutex_lock+0x10/0x20
Dec 24 13:46:50 woozle kernel: [  480.524325]  [<c03d2712>] rtnl_lock+0x12/0x20
Dec 24 13:46:50 woozle kernel: [  480.524332]  [<c03c7be5>] dev_ioctl+0x2c5/0x530
Dec 24 13:46:50 woozle kernel: [  480.524340]  [<c03b585c>] ? sk_prot_alloc+0x5c/0x210
Dec 24 13:46:50 woozle kernel: [  480.524348]  [<c0210b61>] ? kmem_cache_alloc+0x121/0x140
Dec 24 13:46:50 woozle kernel: [  480.524356]  [<c03b4b6c>] ? sock_init_data+0xac/0x1d0
Dec 24 13:46:50 woozle kernel: [  480.524364]  [<c0222a6e>] ? get_empty_filp+0x5e/0x1a0
Dec 24 13:46:50 woozle kernel: [  480.524374]  [<c0296dc4>] ? security_file_alloc+0x14/0x20
Dec 24 13:46:50 woozle kernel: [  480.524381]  [<c0222a9a>] ? get_empty_filp+0x8a/0x1a0
Dec 24 13:46:50 woozle kernel: [  480.524389]  [<c0415290>] ? udp4_seq_show+0x170/0x170
Dec 24 13:46:50 woozle kernel: [  480.524397]  [<c03b0fea>] sock_ioctl+0x8a/0x290
Dec 24 13:46:50 woozle kernel: [  480.524405]  [<c03b0f60>] ? sock_fasync+0x90/0x90
Dec 24 13:46:50 woozle kernel: [  480.524413]  [<c0231646>] do_vfs_ioctl+0x86/0x570
Dec 24 13:46:50 woozle kernel: [  480.524420]  [<c021facc>] ? fd_install+0x4c/0x60
Dec 24 13:46:50 woozle kernel: [  480.524428]  [<c03b1bf4>] ? sock_map_fd+0x24/0x30
Dec 24 13:46:50 woozle kernel: [  480.524435]  [<c03b2c9d>] ? sys_socket+0x4d/0x80
Dec 24 13:46:50 woozle kernel: [  480.524443]  [<c03b3f22>] ? sys_socketcall+0x72/0x2c0
Dec 24 13:46:50 woozle kernel: [  480.524451]  [<c0231b9f>] sys_ioctl+0x6f/0x80
Dec 24 13:46:50 woozle kernel: [  480.524458]  [<c046f05f>] sysenter_do_call+0x12/0x28
Dec 24 13:46:50 woozle kernel: [  480.524470] INFO: task Xorg:992 blocked for more than 120 seconds.
Dec 24 13:46:50 woozle kernel: [  480.524475] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 24 13:46:50 woozle kernel: [  480.524480] Xorg            D f3e0f0ec     0   992    975 0x00400000
Dec 24 13:46:50 woozle kernel: [  480.524489]  f3385e5c 00003086 f3342480 f3e0f0ec 00000001 8b5bbeb8 0000002c 00000010
Dec 24 13:46:50 woozle kernel: [  480.524503]  c064c140 f7402be0 c064c140 f6007140 f5505ea0 f4979a40 f3e0ebf0 f3e0eb1c
Dec 24 13:46:50 woozle kernel: [  480.524518]  0000001b 00000000 f3385e58 c01d7664 f7404660 00000000 f332f168 f3385e3c
Dec 24 13:46:50 woozle kernel: [  480.524532] Call Trace:
Dec 24 13:46:50 woozle kernel: [  480.524541]  [<c01d7664>] ? filemap_fault+0x84/0x3d0
Dec 24 13:46:50 woozle kernel: [  480.524548]  [<c02d0501>] ? cpumask_any_but+0x21/0x40
Dec 24 13:46:50 woozle kernel: [  480.524557]  [<c012d905>] ? flush_tlb_page+0x45/0xb0
Dec 24 13:46:50 woozle kernel: [  480.524565]  [<c046bec5>] schedule+0x35/0x50
Dec 24 13:46:50 woozle kernel: [  480.524572]  [<c046c475>] schedule_timeout+0x265/0x2e0
Dec 24 13:46:50 woozle kernel: [  480.524581]  [<c01f4635>] ? do_wp_page+0x325/0x7a0
Dec 24 13:46:50 woozle kernel: [  480.524590]  [<c021a975>] ? mem_cgroup_get_reclaim_stat_from_page+0x25/0x50
Dec 24 13:46:50 woozle kernel: [  480.524599]  [<c01f6232>] ? handle_pte_fault+0x232/0x8e0
Dec 24 13:46:50 woozle kernel: [  480.524607]  [<c046b307>] wait_for_common+0x97/0x120
Dec 24 13:46:50 woozle kernel: [  480.524615]  [<c0142360>] ? try_to_wake_up+0x210/0x210
Dec 24 13:46:50 woozle kernel: [  480.524623]  [<c01a6b20>] ? __call_rcu+0x120/0x120
Dec 24 13:46:50 woozle kernel: [  480.524630]  [<c046b3a7>] wait_for_completion+0x17/0x20
Dec 24 13:46:50 woozle kernel: [  480.524638]  [<c0163584>] wait_rcu_gp+0x34/0x40
Dec 24 13:46:50 woozle kernel: [  480.524645]  [<c0163590>] ? wait_rcu_gp+0x40/0x40
Dec 24 13:46:50 woozle kernel: [  480.524653]  [<c01a56f2>] synchronize_rcu+0x22/0x30
Dec 24 13:46:50 woozle kernel: [  480.524677]  [<f8c45112>] evdev_release+0x62/0xe0 [evdev]
Dec 24 13:46:50 woozle kernel: [  480.524685]  [<c0222f9a>] fput+0xaa/0x1e0
Dec 24 13:46:50 woozle kernel: [  480.524693]  [<c021f994>] filp_close+0x54/0x80
Dec 24 13:46:50 woozle kernel: [  480.524700]  [<c021fa32>] sys_close+0x72/0xc0
Dec 24 13:46:50 woozle kernel: [  480.524707]  [<c046f05f>] sysenter_do_call+0x12/0x28
Dec 24 13:46:50 woozle kernel: [  480.524739] INFO: task umount:1802 blocked for more than 120 seconds.
Dec 24 13:46:50 woozle kernel: [  480.524744] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 24 13:46:50 woozle kernel: [  480.524750] umount          D f082bddc     0  1802      1 0x00000000
Dec 24 13:46:50 woozle kernel: [  480.524759]  f082be54 00000086 c0648080 f082bddc c046be71 e315bbbf 0000002b f082be04
Dec 24 13:46:50 woozle kernel: [  480.524773]  c064c140 f082bdf4 c064c140 f6207140 f0eaf8e0 f23588c0 c046d2d6 00000000
Dec 24 13:46:50 woozle kernel: [  480.524787]  c058b14c 00000246 f0eaf8e0 22222222 22222222 c058b144 f082be34 00000246
Dec 24 13:46:50 woozle kernel: [  480.524801] Call Trace:
Dec 24 13:46:50 woozle kernel: [  480.524809]  [<c046be71>] ? preempt_schedule+0x31/0x50
Dec 24 13:46:50 woozle kernel: [  480.524817]  [<c046d2d6>] ? __mutex_lock_slowpath+0x216/0x2f0
Dec 24 13:46:50 woozle kernel: [  480.524826]  [<c046d0bd>] ? mutex_unlock+0xd/0x10
Dec 24 13:46:50 woozle kernel: [  480.524834]  [<c046bec5>] schedule+0x35/0x50
Dec 24 13:46:50 woozle kernel: [  480.524842]  [<c01a677d>] synchronize_rcu_expedited+0xbd/0x1e0
Dec 24 13:46:50 woozle kernel: [  480.524850]  [<c0166530>] ? abort_exclusive_wait+0x80/0x80
Dec 24 13:46:50 woozle kernel: [  480.524859]  [<c01ef71a>] bdi_unregister+0x15a/0x1a0
Dec 24 13:46:50 woozle kernel: [  480.524866]  [<c01f00e5>] bdi_destroy+0xd5/0x130
Dec 24 13:46:50 woozle kernel: [  480.524888]  [<f8bd5e1f>] fuse_conn_kill+0xdf/0xf0 [fuse]
Dec 24 13:46:50 woozle kernel: [  480.524904]  [<f8bd6278>] fuse_put_super+0x58/0x70 [fuse]
Dec 24 13:46:50 woozle kernel: [  480.524913]  [<c02234d1>] generic_shutdown_super+0x51/0xc0
Dec 24 13:46:50 woozle kernel: [  480.524920]  [<c01f0c5a>] ? pcpu_chunk_relocate+0x1a/0x90
Dec 24 13:46:50 woozle kernel: [  480.524928]  [<c02235c1>] kill_anon_super+0x11/0x20
Dec 24 13:46:50 woozle kernel: [  480.524944]  [<f8bd5455>] fuse_kill_sb_anon+0x45/0x60 [fuse]
Dec 24 13:46:50 woozle kernel: [  480.524955]  [<c02238cf>] deactivate_locked_super+0x2f/0x80
Dec 24 13:46:50 woozle kernel: [  480.524963]  [<c02241f7>] deactivate_super+0x47/0x60
Dec 24 13:46:50 woozle kernel: [  480.524972]  [<c023c117>] mntput_no_expire+0x87/0xd0
Dec 24 13:46:50 woozle kernel: [  480.524979]  [<c023c178>] mntput+0x18/0x30
Dec 24 13:46:50 woozle kernel: [  480.524986]  [<c023c925>] release_mounts+0x65/0x80
Dec 24 13:46:50 woozle kernel: [  480.524994]  [<c023ce31>] sys_umount+0x1a1/0x330
Dec 24 13:46:50 woozle kernel: [  480.525003]  [<c046f05f>] sysenter_do_call+0x12/0x28
Dec 24 13:46:50 woozle kernel: [  480.525011] INFO: task shutdown:1875 blocked for more than 120 seconds.
Dec 24 13:46:50 woozle kernel: [  480.525016] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 24 13:46:50 woozle kernel: [  480.525021] shutdown        D f08f9f20     0  1875   1874 0x00000000
Dec 24 13:46:50 woozle kernel: [  480.525030]  f08f9f30 00000086 00000002 f08f9f20 f08f9ebc c046e24b f08f9ee0 00000000
Dec 24 13:46:50 woozle kernel: [  480.525044]  c064c140 f08f9f18 c064c140 f6007140 f2b71a40 c0584020 00000002 f08f9ee8
Dec 24 13:46:50 woozle kernel: [  480.525059]  c046e19d f08f9f0c c0243bce 00100100 00200200 f3237000 00000002 f08f9f3c
Dec 24 13:46:50 woozle kernel: [  480.525073] Call Trace:
Dec 24 13:46:50 woozle kernel: [  480.525081]  [<c046e24b>] ? _raw_spin_unlock_irqrestore+0x2b/0x40
Dec 24 13:46:50 woozle kernel: [  480.525090]  [<c046e19d>] ? _raw_spin_unlock_bh+0x1d/0x20
Dec 24 13:46:50 woozle kernel: [  480.525098]  [<c0243bce>] ? bdi_queue_work+0x5e/0x160
Dec 24 13:46:50 woozle kernel: [  480.525106]  [<c046b3a7>] ? wait_for_completion+0x17/0x20
Dec 24 13:46:50 woozle kernel: [  480.525113]  [<c0243d40>] ? writeback_inodes_sb_nr+0x70/0x90
Dec 24 13:46:50 woozle kernel: [  480.525121]  [<c046bec5>] schedule+0x35/0x50
Dec 24 13:46:50 woozle kernel: [  480.525129]  [<c046def5>] rwsem_down_failed_common+0x95/0xe0
Dec 24 13:46:50 woozle kernel: [  480.525137]  [<c046df72>] rwsem_down_read_failed+0x12/0x14
Dec 24 13:46:50 woozle kernel: [  480.525147]  [<c02da0f7>] call_rwsem_down_read_failed+0x7/0xc
Dec 24 13:46:50 woozle kernel: [  480.525155]  [<c046d6f2>] ? down_read+0x12/0x20
Dec 24 13:46:50 woozle kernel: [  480.525162]  [<c0224559>] iterate_supers+0x69/0xc0
Dec 24 13:46:50 woozle kernel: [  480.525170]  [<c02497e0>] ? __sync_filesystem+0x90/0x90
Dec 24 13:46:50 woozle kernel: [  480.525178]  [<c024987b>] sys_sync+0x2b/0x60
Dec 24 13:46:50 woozle kernel: [  480.525185]  [<c046f05f>] sysenter_do_call+0x12/0x28


