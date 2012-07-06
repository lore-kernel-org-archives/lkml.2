Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab2GFNLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 09:11:44 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:59371 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab2GFNLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 09:11:42 -0400
X-Nat-Received: from [202.181.97.72]:49875 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1341580298.9948
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net
Subject: [linux-next-20120706] inconsistent lock state warning
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201207062211.CBH48441.OSHVtQJFFMLOOF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 6 Jul 2012 22:11:36 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 06072012 #8532155, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I got this warning upon boot. From where should I start debugging?

[    5.407664] ide0 at 0x170-0x177,0x376 on irq 15
[    5.413198] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    5.414264] ide-gd driver 1.18
[    5.415129] ide-cd driver 5.00
[    5.419466]
[    5.419528] =================================
[    5.419590] [ INFO: inconsistent lock state ]
[    5.419653] 3.5.0-rc5-next-20120706 #51 Not tainted
[    5.419715] ---------------------------------
[    5.419777] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
[    5.419840] swapper/0/1 [HC1[1]:SC0[0]:HE0:SE1] takes:
[    5.419902]  (&input_pool.lock){?.+...}, at: [<c1252880>] mix_pool_bytes.clone.0+0x20/0x50
[    5.421829] {HARDIRQ-ON-W} state was registered at:
[    5.421829]   [<c1077acc>] __lock_acquire+0x4fc/0x1390
[    5.421829]   [<c10789db>] lock_acquire+0x7b/0xa0
[    5.421829]   [<c13dfd06>] _raw_spin_lock+0x36/0x70
[    5.421829]   [<c12525f7>] account+0x27/0xf0
[    5.421829]   [<c1252aba>] extract_entropy+0x2a/0x70
[    5.421829]   [<c1252a30>] xfer_secondary_pool+0xd0/0x130
[    5.421829]   [<c1252aa7>] extract_entropy+0x17/0x70
[    5.421829]   [<c1252bc3>] get_random_bytes+0x23/0x30
[    5.421829]   [<c13327a3>] neigh_hash_alloc+0x63/0xa0
[    5.421829]   [<c13351cd>] neigh_table_init+0x6d/0x250
[    5.421829]   [<c15cd7bc>] arp_init+0x10/0x48
[    5.421829]   [<c15cdbe8>] inet_init+0x16c/0x269
[    5.421829]   [<c100110f>] do_one_initcall+0x2f/0x170
[    5.421829]   [<c159f53c>] kernel_init+0xec/0x18e
[    5.421829]   [<c13e13ba>] kernel_thread_helper+0x6/0xd
[    5.421829] irq event stamp: 2348792
[    5.421829] hardirqs last  enabled at (2348791): [<c13e0754>] restore_all_notrace+0x0/0x18
[    5.421829] hardirqs last disabled at (2348792): [<c13e13a7>] common_interrupt+0x27/0x34
[    5.421829] softirqs last  enabled at (2348758): [<c1037b71>] __do_softirq+0xe1/0x130
[    5.421829] softirqs last disabled at (2348743): [<c1004ce7>] do_softirq+0x87/0xd0
[    5.421829]
[    5.421829] other info that might help us debug this:
[    5.421829]  Possible unsafe locking scenario:
[    5.421829]
[    5.421829]        CPU0
[    5.421829]        ----
[    5.421829]   lock(&input_pool.lock);
[    5.421829]   <Interrupt>
[    5.421829]     lock(&input_pool.lock);
[    5.421829]
[    5.421829]  *** DEADLOCK ***
[    5.421829]
[    5.421829] 2 locks held by swapper/0/1:
[    5.421829]  #0:  (&__lockdep_no_validate__){......}, at: [<c125ce38>] __driver_attach+0x48/0x90
[    5.421829]  #1:  (&__lockdep_no_validate__){......}, at: [<c125ce44>] __driver_attach+0x54/0x90
[    5.421829]
[    5.421829] stack backtrace:
[    5.421829] Pid: 1, comm: swapper/0 Not tainted 3.5.0-rc5-next-20120706 #51
[    5.421829] Call Trace:
[    5.421829]  [<c1076038>] print_usage_bug+0x1f8/0x240
[    5.421829]  [<c1076e0d>] mark_lock+0x30d/0x3d0
[    5.421829]  [<c1073a6b>] ? trace_hardirqs_off+0xb/0x10
[    5.421829]  [<c1076080>] ? print_usage_bug+0x240/0x240
[    5.421829]  [<c1077e92>] __lock_acquire+0x8c2/0x1390
[    5.421829]  [<c11eab97>] ? __debug_check_no_obj_freed+0x117/0x180
[    5.421829]  [<c1073a6b>] ? trace_hardirqs_off+0xb/0x10
[    5.421829]  [<c1073a6b>] ? trace_hardirqs_off+0xb/0x10
[    5.421829]  [<c10d55c1>] ? kfree+0xc1/0xf0
[    5.421829]  [<c1106a08>] ? bio_kmalloc_destructor+0x8/0x10
[    5.421829]  [<c10789db>] lock_acquire+0x7b/0xa0
[    5.421829]  [<c1252880>] ? mix_pool_bytes.clone.0+0x20/0x50
[    5.421829]  [<c13dfe75>] _raw_spin_lock_irqsave+0x45/0x80
[    5.421829]  [<c1252880>] ? mix_pool_bytes.clone.0+0x20/0x50
[    5.421829]  [<c1252880>] mix_pool_bytes.clone.0+0x20/0x50
[    5.421829]  [<c105ec32>] ? sched_clock_local+0xb2/0x190
[    5.421829]  [<c1252ec2>] add_timer_randomness+0x52/0xd0
[    5.421829]  [<c1252f64>] add_disk_randomness+0x24/0x30
[    5.421829]  [<c11be7c0>] blk_update_bidi_request+0x50/0x80
[    5.421829]  [<c11be813>] blk_end_bidi_request+0x23/0x70
[    5.421829]  [<c11be8b2>] blk_end_request+0x12/0x20
[    5.421829]  [<c1270696>] ide_end_rq+0x26/0x50
[    5.421829]  [<c12706eb>] ide_complete_rq+0x2b/0x60
[    5.421829]  [<c127d942>] cdrom_newpc_intr+0x182/0x870
[    5.421829]  [<c127d7c0>] ? cdrom_analyze_sense_data+0x200/0x200
[    5.421829]  [<c127096b>] ide_intr+0x1ab/0x210
[    5.421829]  [<c1094dee>] handle_irq_event_percpu+0x3e/0x170
[    5.421829]  [<c1097bf1>] ? handle_edge_irq+0x11/0x100
[    5.421829]  [<c1094f4e>] ? handle_irq_event+0x2e/0x60
[    5.421829]  [<c1094f57>] handle_irq_event+0x37/0x60
[    5.421829]  [<c1097be0>] ? handle_level_irq+0xe0/0xe0
[    5.421829]  [<c1097c38>] handle_edge_irq+0x58/0x100
[    5.421829]  <IRQ>  [<c100406d>] ? do_IRQ+0x3d/0xb0
[    5.421829]  [<c13e13ae>] ? common_interrupt+0x2e/0x34
[    5.421829]  [<c1275b8f>] ? ide_output_data+0x9f/0x110
[    5.421829]  [<c127130f>] ? ide_set_handler+0x3f/0x50
[    5.421829]  [<c1276ea4>] ? ide_transfer_pc+0x194/0x270
[    5.421829]  [<c107739b>] ? trace_hardirqs_on+0xb/0x10
[    5.421829]  [<c1276b50>] ? ide_delayed_transfer_pc+0x30/0x30
[    5.421829]  [<c12712b2>] ? ide_execute_command+0x62/0x80
[    5.421829]  [<c1276d10>] ? ide_check_atapi_device+0x150/0x150
[    5.421829]  [<c127716b>] ? ide_issue_pc+0x1eb/0x270
[    5.421829]  [<c1276b50>] ? ide_delayed_transfer_pc+0x30/0x30
[    5.421829]  [<c127e170>] ? ide_cd_do_request+0x140/0x250
[    5.421829]  [<c1270e12>] ? do_ide_request+0x252/0x580
[    5.421829]  [<c107741c>] ? debug_check_no_locks_freed+0x7c/0x130
[    5.421829]  [<c11bbb87>] ? __blk_run_queue+0x17/0x20
[    5.421829]  [<c11bb187>] ? __elv_add_request+0x97/0x1d0
[    5.421829]  [<c11c25d3>] ? blk_execute_rq_nowait+0x33/0xd0
[    5.421829]  [<c11c25f7>] ? blk_execute_rq_nowait+0x57/0xd0
[    5.421829]  [<c11c2729>] ? blk_execute_rq+0xb9/0x130
[    5.421829]  [<c11c2570>] ? blk_rq_map_user+0x220/0x220
[    5.421829]  [<c1107bc7>] ? bio_copy_user_iov+0x2c7/0x3a0
[    5.421829]  [<c127e370>] ? ide_cd_queue_pc+0xc0/0x1a0
[    5.421829]  [<c127f1ec>] ? ide_cdrom_packet+0xac/0x110
[    5.421829]  [<c12cd910>] ? cdrom_mode_sense+0x50/0x60
[    5.421829]  [<c127d1f3>] ? ide_cdrom_get_capabilities+0x53/0x70
[    5.421829]  [<c127eda2>] ? ide_cd_probe+0x302/0x600
[    5.421829]  [<c1136001>] ? sysfs_addrm_finish+0x11/0x50
[    5.421829]  [<c1136da9>] ? sysfs_do_create_link+0xb9/0x1f0
[    5.421829]  [<c1055753>] ? __blocking_notifier_call_chain+0xa3/0xb0
[    5.421829]  [<c126f78f>] ? generic_ide_probe+0x1f/0x30
[    5.421829]  [<c125cc7f>] ? driver_probe_device+0x6f/0x1e0
[    5.421829]  [<c125ce71>] ? __driver_attach+0x81/0x90
[    5.421829]  [<c125b558>] ? bus_for_each_dev+0x48/0x70
[    5.421829]  [<c125ca29>] ? driver_attach+0x19/0x20
[    5.421829]  [<c125cdf0>] ? driver_probe_device+0x1e0/0x1e0
[    5.421829]  [<c125c47e>] ? bus_add_driver+0xae/0x250
[    5.421829]  [<c126f7a0>] ? generic_ide_probe+0x30/0x30
[    5.421829]  [<c126f7a0>] ? generic_ide_probe+0x30/0x30
[    5.421829]  [<c125d315>] ? driver_register+0x65/0x110
[    5.421829]  [<c15c3508>] ? ide_cdrom_init+0x1c/0x1e
[    5.421829]  [<c100110f>] ? do_one_initcall+0x2f/0x170
[    5.421829]  [<c15c34ec>] ? ide_gd_init+0x1e/0x1e
[    5.421829]  [<c159f53c>] ? kernel_init+0xec/0x18e
[    5.421829]  [<c159f3f5>] ? parse_early_options+0x35/0x35
[    5.421829]  [<c159f450>] ? repair_env_string+0x5b/0x5b
[    5.421829]  [<c13e13ba>] ? kernel_thread_helper+0x6/0xd
[    5.435452] ide-cd: hda: ATAPI 1X CD-ROM drive, 32kB Cache
[    5.435514] cdrom: Uniform CD-ROM driver Revision: 3.20
