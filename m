Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab2FMNRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 09:17:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:39126 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab2FMNRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 09:17:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165130343"
Date: Wed, 13 Jun 2012 21:17:25 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Johannes Berg <johannes.berg@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [BUG] iwldvm lock oops
Message-ID: <20120613131725.GA2052@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Emmanuel,

The kernel compiled from commit b35032f ("iwlwifi: don't configure a
txq that is being disabled") in

        git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git  master

triggers a kernel oops below.

That particular commit may well not be the root cause. I'm just hoping
you may have better idea which recent change may be relevant.

[   48.050140] iwldvm: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[   48.195291] iwldvm: Copyright(c) 2003-2012 Intel Corporation
[   48.269132] ------------[ cut here ]------------
[   48.272840] WARNING: at /c/kernel-tests/usb/kernel/mutex.c:198 __mutex_lock_common+0xf6/0x387()
[   48.272840] Hardware name: Bochs
[   48.272840] Modules linked in:
[   48.272840] Pid: 1, comm: swapper/0 Not tainted 3.5.0-rc1+ #1
[   48.272840] Call Trace:
[   48.272840]  [<ffffffff81090271>] warn_slowpath_common+0x83/0x9c
[   48.272840]  [<ffffffff820b2afb>] ? iwl_opmode_register+0x23/0xbb
[   48.272840]  [<ffffffff810902a4>] warn_slowpath_null+0x1a/0x1c
[   48.272840]  [<ffffffff82e93011>] __mutex_lock_common+0xf6/0x387
[   48.272840]  [<ffffffff820b2afb>] ? iwl_opmode_register+0x23/0xbb
[   48.272840]  [<ffffffff82e93615>] ? __mutex_unlock_slowpath+0x116/0x126
[   48.272840]  [<ffffffff810ddb01>] ? trace_hardirqs_on_caller+0x123/0x17f
[   48.272840]  [<ffffffff82e933b1>] mutex_lock_nested+0x40/0x45
[   48.272840]  [<ffffffff820b2afb>] iwl_opmode_register+0x23/0xbb
[   48.272840]  [<ffffffff84660e4f>] ? mwl8k_driver_init+0x1b/0x1b
[   48.272840]  [<ffffffff84660ea1>] iwl_init+0x52/0x73
[   48.272840]  [<ffffffff81002099>] do_one_initcall+0x7f/0x13a
[   48.272840]  [<ffffffff84603d39>] kernel_init+0x170/0x1f8
[   48.272840]  [<ffffffff84603590>] ? do_early_param+0x8c/0x8c
[   48.272840]  [<ffffffff82e9db74>] kernel_thread_helper+0x4/0x10
[   48.272840]  [<ffffffff82e95db0>] ? retint_restore_args+0x13/0x13
[   48.272840]  [<ffffffff84603bc9>] ? start_kernel+0x3e7/0x3e7
[   48.272840]  [<ffffffff82e9db70>] ? gs_change+0x13/0x13
[   48.272840] ---[ end trace 695977a38adc57f4 ]---
[   48.272840] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   48.272840] IP: [<ffffffff816c0d70>] __list_add+0x3d/0xad
[   48.272840] PGD 0
[   48.272840] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   48.272840] CPU 0
[   48.272840] Modules linked in:
[   48.272840]
[   48.272840] Pid: 1, comm: swapper/0 Tainted: G        W    3.5.0-rc1+ #1 Bochs Bochs
[   48.272840] RIP: 0010:[<ffffffff816c0d70>]  [<ffffffff816c0d70>] __list_add+0x3d/0xad
[   48.272840] RSP: 0018:ffff880017365db0  EFLAGS: 00010046
[   48.272840] RAX: ffffffff853e7100 RBX: 0000000000000000 RCX: 0000000000000000
[   48.272840] RDX: ffffffff853e7100 RSI: 0000000000000000 RDI: ffff880017365e10
[   48.272840] RBP: ffff880017365dd0 R08: 0000000000000000 R09: ffffffff85139e70
[   48.272840] R10: 00000000ffffffff R11: 00000000ffffffff R12: ffffffff853e7100
[   48.272840] R13: ffff880017365e10 R14: ffff880017360040 R15: ffffffff820b2afb
[   48.272840] FS:  0000000000000000(0000) GS:ffff880017400000(0000) knlGS:0000000000000000
[   48.272840] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   48.272840] CR2: 0000000000000000 CR3: 0000000004014000 CR4: 00000000000006f0
[   48.272840] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   48.272840] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   48.272840] Process swapper/0 (pid: 1, threadinfo ffff880017364000, task ffff880017360040)
[   48.272840] Stack:
[   48.272840]  00000000ffffffff ffffffff853e70b0 0000000000000246 ffffffff853e70b8
[   48.272840]  ffff880017365e60 ffffffff82e93045 ffffffff820b2afb ffff880017360040
[   48.272840]  ffffffff82e93615 ffffffff853e7100 0000000000000002 ffffffff853e7128
[   48.272840] Call Trace:
[   48.272840]  [<ffffffff82e93045>] __mutex_lock_common+0x12a/0x387
[   48.272840]  [<ffffffff820b2afb>] ? iwl_opmode_register+0x23/0xbb
[   48.272840]  [<ffffffff82e93615>] ? __mutex_unlock_slowpath+0x116/0x126
[   48.272840]  [<ffffffff82e933b1>] mutex_lock_nested+0x40/0x45
[   48.272840]  [<ffffffff820b2afb>] iwl_opmode_register+0x23/0xbb
[   48.272840]  [<ffffffff84660e4f>] ? mwl8k_driver_init+0x1b/0x1b
[   48.272840]  [<ffffffff84660ea1>] iwl_init+0x52/0x73
[   48.272840]  [<ffffffff81002099>] do_one_initcall+0x7f/0x13a
[   48.272840]  [<ffffffff84603d39>] kernel_init+0x170/0x1f8
[   48.272840]  [<ffffffff84603590>] ? do_early_param+0x8c/0x8c
[   48.272840]  [<ffffffff82e9db74>] kernel_thread_helper+0x4/0x10
[   48.272840]  [<ffffffff82e95db0>] ? retint_restore_args+0x13/0x13
[   48.272840]  [<ffffffff84603bc9>] ? start_kernel+0x3e7/0x3e7
[   48.272840]  [<ffffffff82e9db70>] ? gs_change+0x13/0x13
[   48.272840] Code: 41 53 4c 8b 42 08 49 39 f0 74 20 49 89 d1 48 89 f1 48 c7 c2 88 d8 a9 83 be 1d 00 00 00 48 c7 c7 36 d7 a9 83 31 c0 e8 77 f5 9c ff <4c> 8b 03 4d 39 e0 74 20 49 89 d9 4c 89 e1 48 c7 c2 d5 d8 a9 83
[   48.272840] RIP  [<ffffffff816c0d70>] __list_add+0x3d/0xad
[   48.272840]  RSP <ffff880017365db0>
[   48.272840] CR2: 0000000000000000
[   48.272840] ---[ end trace 695977a38adc57f5 ]---
[   48.272840] note: swapper/0[1] exited with preempt_count 1
[   53.626234] swapper/0 (1) used greatest stack depth: 3736 bytes left
[   53.691089] BUG: scheduling while atomic: swapper/0/1/0x10000002
[   53.757370] INFO: lockdep is turned off.
[   53.822948] Modules linked in:
[   53.884699] Pid: 1, comm: swapper/0 Tainted: G      D W    3.5.0-rc1+ #1
[   53.947786] Call Trace:
[   54.009694]  [<ffffffff82e45fc1>] __schedule_bug+0x66/0x75
[   54.074043]  [<ffffffff82e93ca9>] __schedule+0x95/0x5ff
[   54.138611]  [<ffffffff810bcc33>] __cond_resched+0x27/0x32
[   54.201513]  [<ffffffff82e9426f>] _cond_resched+0x19/0x22
[   54.263749]  [<ffffffff82e9339b>] mutex_lock_nested+0x2a/0x45
[   54.328471]  [<ffffffff81134392>] perf_event_exit_task+0x2d/0x1cc
[   54.390278]  [<ffffffff81094c39>] do_exit+0x321/0x81f
[   54.454589]  [<ffffffff810929ca>] ? kmsg_dump+0x87/0x145
[   54.520481]  [<ffffffff82e96b15>] oops_end+0xb0/0xb8
[   54.587708]  [<ffffffff82e4522e>] no_context+0x250/0x27b
[   54.655396]  [<ffffffff82e45421>] __bad_area_nosemaphore+0x1c8/0x1e8
[   54.723800]  [<ffffffff8111e7c8>] ? irq_trace+0x14/0x21
[   54.793704]  [<ffffffff82e45454>] bad_area_nosemaphore+0x13/0x15
[   54.863119]  [<ffffffff82e98fba>] do_page_fault+0x1b3/0x3d6
[   54.932158]  [<ffffffff810d9e8c>] ? trace_hardirqs_off+0xd/0xf
[   55.003047]  [<ffffffff810d9e8c>] ? trace_hardirqs_off+0xd/0xf
[   55.067450]  [<ffffffff82e95997>] ? _raw_spin_unlock_irqrestore+0x3e/0x61
[   55.131685]  [<ffffffff8111e7c8>] ? irq_trace+0x14/0x21
[   55.193687]  [<ffffffff8111eee0>] ? time_hardirqs_off+0x26/0x2a
[   55.256207]  [<ffffffff82e962a6>] ? error_sti+0x5/0x6
[   55.318594]  [<ffffffff816aff3d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   55.382552]  [<ffffffff810d9e00>] ? trace_hardirqs_off_caller+0x1f/0x9e
[   55.446638]  [<ffffffff816aff3d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   55.509327]  [<ffffffff820b2afb>] ? iwl_opmode_register+0x23/0xbb
[   55.570097]  [<ffffffff82e96055>] page_fault+0x25/0x30
[   55.630741]  [<ffffffff820b2afb>] ? iwl_opmode_register+0x23/0xbb
[   55.690780]  [<ffffffff816c0d70>] ? __list_add+0x3d/0xad
[   55.750381]  [<ffffffff82e93045>] __mutex_lock_common+0x12a/0x387
[   55.808248]  [<ffffffff820b2afb>] ? iwl_opmode_register+0x23/0xbb
[   55.865275]  [<ffffffff82e93615>] ? __mutex_unlock_slowpath+0x116/0x126
[   55.922696]  [<ffffffff82e933b1>] mutex_lock_nested+0x40/0x45
[   55.981706]  [<ffffffff820b2afb>] iwl_opmode_register+0x23/0xbb
[   56.040514]  [<ffffffff84660e4f>] ? mwl8k_driver_init+0x1b/0x1b
[   56.098181]  [<ffffffff84660ea1>] iwl_init+0x52/0x73
[   56.155184]  [<ffffffff81002099>] do_one_initcall+0x7f/0x13a
[   56.216123]  [<ffffffff84603d39>] kernel_init+0x170/0x1f8
[   56.274993]  [<ffffffff84603590>] ? do_early_param+0x8c/0x8c
[   56.335556]  [<ffffffff82e9db74>] kernel_thread_helper+0x4/0x10
[   56.394430]  [<ffffffff82e95db0>] ? retint_restore_args+0x13/0x13
[   56.454955]  [<ffffffff84603bc9>] ? start_kernel+0x3e7/0x3e7
[   56.514499]  [<ffffffff82e9db70>] ? gs_change+0x13/0x13
[   56.574506] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
[   56.574506]
[   56.578138] [sched_delayed] sched: RT throttling activated

Thanks,
Fengguang
