Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab1HPNtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 09:49:10 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:50374 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab1HPNtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 09:49:06 -0400
X-Nat-Received: from [202.181.97.72]:64981 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1313502543.2674
To: linux-kernel@vger.kernel.org
Subject: [2.6.35.14] kswapd: inconsistent lock state
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201108162249.DEE78661.MJQOVtLOFFFHSO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 16 Aug 2011 22:49:00 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 16082011 #5910994, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got one similar to https://lkml.org/lkml/2011/3/2/398 .
Bugfix not yet applied to 2.6.35.y ?

[    4.626250] pciehp 0000:00:16.1:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    4.629244] pciehp 0000:00:16.2:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    4.629887] 
[    4.629895] =================================
[    4.629919] [ INFO: inconsistent lock state ]
[    4.629985] 2.6.35.14 #2
[    4.629999] ---------------------------------
[    4.630017] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
[    4.630035] kswapd0/39 [HC0[0]:SC0[0]:HE1:SE1] takes:
[    4.630100]  (cpu_hotplug.lock){+.+.?.}, at: [<c044ef63>] get_online_cpus+0x33/0x50
[    4.630269] {RECLAIM_FS-ON-W} state was registered at:
[    4.630269]   [<c047b222>] mark_held_locks+0x62/0x90
[    4.630269]   [<c047b302>] lockdep_trace_alloc+0xb2/0xe0
[    4.630269]   [<c04ee8b3>] kmem_cache_alloc+0x23/0x160
[    4.630269]   [<c07d52f4>] timer_cpu_notify+0x56/0x244
[    4.630269]   [<c07de9a2>] notifier_call_chain+0x42/0x90
[    4.630269]   [<c046a9b9>] __raw_notifier_call_chain+0x19/0x20
[    4.630269]   [<c044edff>] __cpu_notify+0x1f/0x40
[    4.630269]   [<c07d4ec5>] _cpu_up+0x68/0x113
[    4.630269]   [<c07d4fe7>] cpu_up+0x77/0x86
[    4.630269]   [<c09d8361>] kernel_init+0xc6/0x1f3
[    4.630269]   [<c0409e02>] kernel_thread_helper+0x6/0x10
[    4.630269] irq event stamp: 35
[    4.630269] hardirqs last  enabled at (35): [<c07db125>] _raw_spin_unlock_irqrestore+0x35/0x60
[    4.630269] hardirqs last disabled at (34): [<c07da924>] _raw_spin_lock_irqsave+0x24/0x90
[    4.630269] softirqs last  enabled at (0): [<c044bb72>] copy_process+0x2b2/0xf00
[    4.630269] softirqs last disabled at (0): [<(null)>] (null)
[    4.630269] 
[    4.630269] other info that might help us debug this:
[    4.630269] no locks held by kswapd0/39.
[    4.630269] 
[    4.630269] stack backtrace:
[    4.630269] Pid: 39, comm: kswapd0 Not tainted 2.6.35.14 #2
[    4.630269] Call Trace:
[    4.630269]  [<c07d7ce7>] ? printk+0x18/0x21
[    4.630269]  [<c047a380>] print_usage_bug+0x150/0x160
[    4.630269]  [<c047b0f6>] mark_lock+0x2f6/0x3c0
[    4.630269]  [<c04781fb>] ? trace_hardirqs_off+0xb/0x10
[    4.630269]  [<c047a4b0>] ? check_usage_forwards+0x0/0xd0
[    4.630269]  [<c047bca7>] __lock_acquire+0x3e7/0x12e0
[    4.630269]  [<c046b500>] ? pm_qos_power_write+0xf0/0x120
[    4.630269]  [<c047cc26>] lock_acquire+0x86/0xb0
[    4.630269]  [<c044ef63>] ? get_online_cpus+0x33/0x50
[    4.630269]  [<c07d91b7>] __mutex_lock_common+0x47/0x360
[    4.630269]  [<c044ef63>] ? get_online_cpus+0x33/0x50
[    4.630269]  [<c07db125>] ? _raw_spin_unlock_irqrestore+0x35/0x60
[    4.630269]  [<c07d95aa>] mutex_lock_nested+0x3a/0x50
[    4.630269]  [<c044ef63>] ? get_online_cpus+0x33/0x50
[    4.630269]  [<c044ef63>] get_online_cpus+0x33/0x50
[    4.630269]  [<c04cf591>] restore_pgdat_percpu_threshold+0x11/0x100
[    4.630269]  [<c0465829>] ? prepare_to_wait+0x49/0x70
[    4.630269]  [<c04ca50d>] kswapd+0x83d/0x870
[    4.630269]  [<c047b63b>] ? trace_hardirqs_on+0xb/0x10
[    4.630269]  [<c07db0e2>] ? _raw_spin_unlock_irq+0x22/0x30
[    4.630269]  [<c043c911>] ? finish_task_switch+0x71/0xc0
[    4.630269]  [<c043c8a0>] ? finish_task_switch+0x0/0xc0
[    4.630269]  [<c07d8201>] ? schedule+0x361/0x820
[    4.630269]  [<c07db125>] ? _raw_spin_unlock_irqrestore+0x35/0x60
[    4.630269]  [<c04655a0>] ? autoremove_wake_function+0x0/0x40
[    4.630269]  [<c04c9cd0>] ? kswapd+0x0/0x870
[    4.630269]  [<c04651fc>] kthread+0x7c/0x90
[    4.630269]  [<c0465180>] ? kthread+0x0/0x90
[    4.630269]  [<c0409e02>] kernel_thread_helper+0x6/0x10
[    4.706205] pciehp 0000:00:16.2:pcie04: service driver pciehp loaded
[    4.707831] pciehp 0000:00:16.3:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
