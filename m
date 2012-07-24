Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab2GXJH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 05:07:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:12041 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824Ab2GXJHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 05:07:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="126182843"
Date: Tue, 24 Jul 2012 17:07:20 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Testing tracer wakeup_rt: .. no entries found ..FAILED!
Message-ID: <20120724090720.GA10434@localhost>
References: <20120724090330.GA9830@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120724090330.GA9830@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 05:03:30PM +0800, Fengguang Wu wrote:
> Hi Steven,
> 
> This looks like some old bug, so I directly report to you w/o trying
> to bisect it. It only happens on the attached i386 randconfig and
> happens in about half of the kvm boots.
> 
> [    1.380369] Testing tracer irqsoff: [    1.524917] 
> [    1.525217] ===============================
> [    1.525868] [ INFO: suspicious RCU usage. ]
> [    1.526556] 3.5.0+ #1289 Not tainted
> [    1.527124] -------------------------------
> [    1.527799] /c/kernel-tests/src/linux/include/linux/rcupdate.h:730 rcu_read_lock() used illegally while idle!
> [    1.529375] 
> [    1.529375] other info that might help us debug this:
> [    1.529375] 
> [    1.530667] 
> [    1.530667] RCU used illegally from idle CPU!
> [    1.530667] rcu_scheduler_active = 1, debug_locks = 1
> [    1.532383] RCU used illegally from extended quiescent state!
> [    1.533297] 2 locks held by swapper/0/0:
> 
> [    1.533924]  #0: [    1.534271]  (max_trace_lock){......}, at: [<410e9d67>] check_critical_timing+0x67/0x1b0
> [    1.534883]  #1:  (rcu_read_lock){.+.+..}, at: [<410e1ea0>] __update_max_tr+0x0/0x200
> 
> [    1.534883] stack backtrace:
> [    1.534883] Pid: 0, comm: swapper/0 Not tainted 3.5.0+ #1289
> [    1.534883] Call Trace:
> [    1.534883]  [<41093a76>] lockdep_rcu_suspicious+0xc6/0x100
> [    1.534883]  [<410e2071>] __update_max_tr+0x1d1/0x200
> [    1.534883]  [<410e1ea0>] ? tracing_record_cmdline+0x130/0x130
> [    1.534883]  [<410e30f5>] update_max_tr_single+0x1f5/0x240
> [    1.534883]  [<410e294c>] ? __trace_stack+0x1c/0x30
> [    1.534883]  [<410e9e96>] check_critical_timing+0x196/0x1b0
> [    1.534883]  [<4100b858>] ? default_idle+0x468/0x4c0
> [    1.534883]  [<4100b858>] ? default_idle+0x468/0x4c0
> [    1.534883]  [<410ea47f>] time_hardirqs_on+0xff/0x110
> [    1.534883]  [<410961eb>] ? trace_hardirqs_on+0xb/0x10
> [    1.534883]  [<4100b858>] ? default_idle+0x468/0x4c0
> [    1.534883]  [<41096031>] trace_hardirqs_on_caller+0x11/0x1c0
> [    1.534883]  [<410961eb>] trace_hardirqs_on+0xb/0x10
> [    1.534883]  [<4100b858>] default_idle+0x468/0x4c0
> [    1.534883]  [<4100c4e6>] cpu_idle+0x186/0x190
> [    1.534883]  [<412953c3>] rest_init+0x127/0x134
> [    1.534883]  [<4129529c>] ? __read_lock_failed+0x14/0x14
> [    1.534883]  [<4141b9e0>] start_kernel+0x36f/0x375
> [    1.534883]  [<4141b4a6>] ? repair_env_string+0x51/0x51
> [    1.534883]  [<4141b2d4>] i386_start_kernel+0x8a/0x8f
> [    1.534883] 
> [    1.534883] ===============================

And this warning shows up in one of the dozens of boots, for the same
kconfig.

[    2.320434] Testing tracer wakeup: PASSED
[    2.840288] Testing tracer wakeup_rt: .. no entries found ..FAILED!
[    3.280861] ------------[ cut here ]------------
[    3.281967] WARNING: at /c/kernel-tests/src/linux/kernel/trace/trace.c:834 register_tracer+0x1b0/0x270()
[    3.284162] Hardware name: Bochs
[    3.284933] Modules linked in:
[    3.285695] Pid: 1, comm: swapper/0 Not tainted 3.5.0+ #1371
[    3.287032] Call Trace:
[    3.287626]  [<41035c32>] warn_slowpath_common+0x72/0xa0
[    3.288938]  [<410e7dd0>] ? register_tracer+0x1b0/0x270
[    3.290280]  [<410e7dd0>] ? register_tracer+0x1b0/0x270
[    3.291516]  [<41035c82>] warn_slowpath_null+0x22/0x30
[    3.292723]  [<410e7dd0>] register_tracer+0x1b0/0x270
[    3.293921]  [<41434c7a>] ? init_irqsoff_tracer+0x11/0x11
[    3.295269]  [<41434c95>] init_wakeup_tracer+0x1b/0x1d
[    3.296464]  [<41001112>] do_one_initcall+0x112/0x160
[    3.297639]  [<4141fadd>] kernel_init+0xf7/0x18e
[    3.298724]  [<4141f455>] ? do_early_param+0x7a/0x7a
[    3.299879]  [<4141f9e6>] ? start_kernel+0x375/0x375
[    3.301093]  [<412b15c2>] kernel_thread_helper+0x6/0x10
[    3.302352] ---[ end trace 57f7151f6a5def05 ]---

Thanks,
Fengguang

