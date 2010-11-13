Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab0KMNKz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 08:10:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:23390 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209Ab0KMNKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 08:10:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,191,1288594800"; 
   d="scan'208";a="677170937"
Date: Sat, 13 Nov 2010 21:10:42 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Nikanth Karthikesan <knikanth@suse.de>,
        Yinghai Lu <yinghai@kernel.org>, David Rientjes <rientjes@google.com>,
        "Zheng, Shaohui" <shaohui.zheng@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-hotplug@vger.kernel.org" <linux-hotplug@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Venkatesh Pallipadi <venki@google.com>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: Re: [BUG 2.6.27-rc1] find_busiest_group() LOCKUP
Message-ID: <20101113131042.GA5522@localhost>
References: <20101111100628.GA24728@localhost>
 <1289478978.2084.74.camel@laptop>
 <20101111124015.GA9706@localhost>
 <1289480656.2084.80.camel@laptop>
 <20101113084018.GA23098@localhost>
 <1289644224.2084.521.camel@laptop>
 <20101113120030.GA31517@localhost>
 <1289653078.2084.675.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289653078.2084.675.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 08:57:58PM +0800, Peter Zijlstra wrote:
> On Sat, 2010-11-13 at 20:00 +0800, Wu Fengguang wrote:
> > On Sat, Nov 13, 2010 at 06:30:24PM +0800, Peter Zijlstra wrote:
> > > On Sat, 2010-11-13 at 16:40 +0800, Wu Fengguang wrote:
> > > > > Will try and figure out how the heck that's happening, Ingo any clue?
> > > > 
> > > > It's back to normal on 2.6.37-rc1 when reverting commit 50f2d7f682f9
> > > > ("x86, numa: Assign CPUs to nodes in round-robin manner on fake NUMA").
> > > > 
> > > > The interesting part is, the commit was introduced in 
> > > > 2.6.36-rc7..2.6.36, however 2.6.36 boots OK, while 2.6.37-rc1 panics.
> > > 
> > > Argh, that commit again..
> > > 
> > > Does this fix it: http://lkml.org/lkml/2010/11/12/8
> > 
> > No it still panics. Here is the dmesg.
> 
> OK, I'll let Nikanth have a look, if all else fails we can always
> revert that patch.

It's the same bug.

Just tried another machine, I get the same divide error.  The patch
posted in lkml/2010/11/12/8 does not fix it. But after reverting
commit 50f2d7f682f9, it boots OK.

Thanks,
Fengguang
---
PS. dmesg with divide error

[    0.000000] console [ttyS0] enabled, bootconsole disabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] allocated 167772160 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] ODEBUG: 15 of 15 active objects replaced
[    0.000000] hpet clockevent registered
[    0.001000] Fast TSC calibration using PIT
[    0.002000] Detected 2800.469 MHz processor.
[    0.000010] Calibrating delay loop (skipped), value calculated using timer frequency.. 5600.93 BogoMIPS (lpj=2800469)
[    0.010818] pid_max: default: 32768 minimum: 301
[    0.021745] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.035657] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.044553] Mount-cache hash table entries: 256
[    0.049469] Initializing cgroup subsys debug
[    0.053834] Initializing cgroup subsys ns
[    0.057940] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.066968] Initializing cgroup subsys cpuacct
[    0.071511] Initializing cgroup subsys memory
[    0.075988] Initializing cgroup subsys devices
[    0.080527] Initializing cgroup subsys freezer
[    0.085107] CPU: Physical Processor ID: 0
[    0.089209] CPU: Processor Core ID: 0
[    0.092974] mce: CPU supports 9 MCE banks
[    0.097095] CPU0: Thermal monitoring enabled (TM1)
[    0.101990] using mwait in idle threads.
[    0.106006] Performance Events: PEBS fmt1+, Westmere events, Intel PMU driver.
[    0.113535] ... version:                3
[    0.117641] ... bit width:              48
[    0.121828] ... generic registers:      4
[    0.125926] ... value mask:             0000ffffffffffff
[    0.131328] ... max period:             000000007fffffff
[    0.136734] ... fixed-purpose events:   3
[    0.140839] ... event mask:             000000070000000f
[    0.147297] ACPI: Core revision 20101013
[    0.175646] ftrace: allocating 24175 entries in 95 pages
[    0.190912] Setting APIC routing to flat
[    0.195562] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.211643] CPU0: Intel(R) Xeon(R) CPU           X5660  @ 2.80GHz stepping 01
[    0.325243] lockdep: fixing up alternatives.
[    0.330242] Booting Node   0, Processors  #1lockdep: fixing up alternatives.
[    0.430140]  #2lockdep: fixing up alternatives.
[    0.526962]  #3lockdep: fixing up alternatives.
[    0.623755]  #4lockdep: fixing up alternatives.
[    0.720588]  Ok.
[    0.722525] Booting Node   1, Processors  #5lockdep: fixing up alternatives.
[    0.822389]  Ok.
[    0.824327] Booting Node   0, Processors  #6
[    0.919089] TSC synchronization [CPU#0 -> CPU#6]:
[    0.924155] Measured 296 cycles TSC warp between CPUs, turning off TSC clock.
[    0.003999] Marking TSC unstable due to check_tsc_sync_source failed
[    0.557048] lockdep: fixing up alternatives.
[    0.558041]  Ok.
[    0.559004] Booting Node   1, Processors  #7 Ok.
[    0.632157] Brought up 8 CPUs
[    0.633006] Total of 8 processors activated (44799.46 BogoMIPS).
[    0.634048] Testing NMI watchdog ... OK.
[    0.658054] divide error: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    0.658999] last sysfs file:
[    0.658999] CPU 0
[    0.658999] Modules linked in:
[    0.658999]
[    0.658999] Pid: 1, comm: swapper Tainted: G        W   2.6.37-rc1+ #111 X8DTN/X8DTN
[    0.658999] RIP: 0010:[<ffffffff810a9d18>]  [<ffffffff810a9d18>] find_busiest_group+0x6b8/0x1480
[    0.658999] RSP: 0018:ffff88022f965870  EFLAGS: 00010006
[    0.658999] RAX: 0000000000100000 RBX: ffff88022f965aec RCX: 0000000000000000
[    0.658999] RDX: 0000000000000000 RSI: 0000000000000400 RDI: 0000000000000008
[    0.658999] RBP: ffff88022f965a30 R08: ffff88022fa00278 R09: ffff88022fa00268
[    0.658999] R10: 0000000000000003 R11: 0000000000000001 R12: 00000000001d2d00
[    0.658999] R13: 00000000001d2d00 R14: 00000000001d2d00 R15: 0000000000000008
[    0.658999] FS:  0000000000000000(0000) GS:ffff8800bc400000(0000) knlGS:0000000000000000
[    0.658999] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.658999] CR2: 0000000000000000 CR3: 0000000001ee1000 CR4: 00000000000006f0
[    0.658999] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.658999] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    0.658999] Process swapper (pid: 1, threadinfo ffff88022f964000, task ffff88042f45c000)
[    0.658999] Stack:
[    0.658999]  ffff88022f965890 ffff88022f9659d0 0000000000000006 ffff8800bcfd2d00
[    0.658999]  0000000000000000 00000000001d2d00 ffff88022f965ae0 000000022f965910
[    0.658999]  ffff88022f965801 ffffffff810929ed ffff8800bc40de48 000000000042f47c
[    0.658999] Call Trace:
[    0.658999]  [<ffffffff810929ed>] ? __phys_addr+0x5d/0x120
[    0.658999]  [<ffffffff810b2614>] load_balance+0xe4/0xcb0
[    0.658999]  [<ffffffff810b0b54>] ? dequeue_task_fair+0x1f4/0x250
[    0.658999]  [<ffffffff8199be5d>] schedule+0xb0d/0x14b0
[    0.658999]  [<ffffffff810cc60e>] ? __sysctl_head_next+0x19e/0x1a0
[    0.658999]  [<ffffffff8199d2dd>] schedule_timeout+0x50d/0x570
[    0.658999]  [<ffffffff8110b9bc>] ? print_lock_contention_bug+0x2c/0x110
[    0.658999]  [<ffffffff810af7a1>] ? get_parent_ip+0x11/0x90
[    0.658999]  [<ffffffff819a7cbd>] ? sub_preempt_count+0x12d/0x1f0
[    0.658999]  [<ffffffff8199b10b>] wait_for_common+0x16b/0x290
[    0.658999]  [<ffffffff810b4950>] ? default_wake_function+0x0/0x20
[    0.658999]  [<ffffffff8199b34d>] wait_for_completion+0x1d/0x20
[    0.658999]  [<ffffffff810efdfb>] kthread_create+0x9b/0x150
[    0.658999]  [<ffffffff810e8310>] ? rescuer_thread+0x0/0x2a0
[    0.658999]  [<ffffffff81202078>] ? __kmalloc_node+0x2b8/0x340
[    0.658999]  [<ffffffff810e7d5a>] __alloc_workqueue_key+0x27a/0x830
[    0.658999]  [<ffffffff8263b23f>] cpuset_init_smp+0x56/0x8c
[    0.658999]  [<ffffffff8261d148>] kernel_init+0x17a/0x27c
[    0.658999]  [<ffffffff81051a24>] kernel_thread_helper+0x4/0x10
[    0.658999]  [<ffffffff819a2c14>] ? restore_args+0x0/0x30
[    0.658999]  [<ffffffff8261cfce>] ? kernel_init+0x0/0x27c
[    0.658999]  [<ffffffff81051a20>] ? kernel_thread_helper+0x0/0x10
[    0.658999] Code: 04 f5 20 87 43 82 48 89 94 07 80 08 00 00 41 89 4f 08 90 4c 8b 8d e0 fe ff ff 48 8b 75 a8 31 d2 41 8b 49 08 48 89 f0 48 c1 e0 0a <48> f7 f1 48 8b 4d b0 31 d2 48 85 c9 0f 95 c2 48 89 45 a0 48 63
[    0.658999] RIP  [<ffffffff810a9d18>] find_busiest_group+0x6b8/0x1480
[    0.658999]  RSP <ffff88022f965870>
[    0.658999] ---[ end trace 4eaa2a86a8e2da23 ]---
[    0.658999] divide error: 0000 [#2] PREEMPT SMP DEBUG_PAGEALLOC
[    0.658999] last sysfs file:
[    0.658999] CPU 1
[    0.658999] Modules linked in:
[    0.658999]
[    0.658999] Pid: 2, comm: kthreadd Tainted: G      D W   2.6.37-rc1+ #111 X8DTN/X8DTN
[    0.658999] RIP: 0010:[<ffffffff810a3321>]  [<ffffffff810a3321>] select_task_rq_fair+0x691/0x9a0
[    0.658999] RSP: 0000:ffff88022f967c30  EFLAGS: 00010002
[    0.658999] RAX: 0000000000100000 RBX: 0000000000000400 RCX: 0000000000000000
[    0.658999] RDX: 0000000000000000 RSI: 0000000000000008 RDI: 0000000000000008
[    0.658999] RBP: ffff88022f967cf0 R08: ffff88022fa00278 R09: 0000000000000000
[    0.658999] R10: 0000000000000003 R11: 0000000000000000 R12: 0000000000000001
[    0.658999] R13: ffff88022fa00278 R14: ffff88022fa00268 R15: 0000000000000003
[    0.658999] FS:  0000000000000000(0000) GS:ffff8800bc600000(0000) knlGS:0000000000000000
[    0.658999] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.658999] CR2: 0000000000000000 CR3: 0000000001ee1000 CR4: 00000000000006e0
[    0.658999] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.658999] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    0.658999] Process kthreadd (pid: 2, threadinfo ffff88022f966000, task ffff88022f968000)
[    0.658999] Stack:
[    0.658999]  000000002f967c50 ffff8800bc7d2d18 ffff880200000006 00000000001d2d00
[    0.658999]  00000000001d2d00 0000000000000000 000000000000007d 0000000000000000
[    0.658999]  0000000800000001 ffff88022faa41b0 00000001810a59ea 0000000000000000
[    0.658999] Call Trace:
[    0.658999]  [<ffffffff810b4a01>] wake_up_new_task+0x51/0x2d0
[    0.658999]  [<ffffffff810eb83c>] ? __task_pid_nr_ns+0x10c/0x130
[    0.658999]  [<ffffffff810eb730>] ? __task_pid_nr_ns+0x0/0x130
[    0.658999]  [<ffffffff810bb0e3>] do_fork+0x693/0x7b0
[    0.658999]  [<ffffffff819a22e8>] ? _raw_spin_unlock_irq+0x68/0x90
[    0.658999]  [<ffffffff810a7a98>] ? finish_task_switch+0x118/0x1d0
[    0.658999]  [<ffffffff810af7a1>] ? get_parent_ip+0x11/0x90
[    0.658999]  [<ffffffff819a7cbd>] ? sub_preempt_count+0x12d/0x1f0
[    0.658999]  [<ffffffff8105c276>] kernel_thread+0x76/0x80
[    0.658999]  [<ffffffff810ef9a0>] ? kthread+0x0/0xd0
[    0.658999]  [<ffffffff81051a20>] ? kernel_thread_helper+0x0/0x10
[    0.658999]  [<ffffffff810f0006>] kthreadd+0x136/0x1a0
[    0.658999]  [<ffffffff8110d629>] ? trace_hardirqs_on_caller+0x29/0x210
[    0.658999]  [<ffffffff81051a24>] kernel_thread_helper+0x4/0x10
[    0.658999]  [<ffffffff819a2c14>] ? restore_args+0x0/0x30
[    0.658999]  [<ffffffff810efed0>] ? kthreadd+0x0/0x1a0
[    0.658999]  [<ffffffff81051a20>] ? kernel_thread_helper+0x0/0x10
[    0.658999] Code: 95 50 ff ff ff eb 99 0f 1f 00 45 89 f4 4c 8b 75 b0 48 89 d8 48 c1 e0 0a 31 d2 49 83 c7 02 41 8b 4e 08 4a 83 04 fd d8 ec 08 82 01 <48> f7 f1 45 85 e4 0f 85 33 01 00 00 31 d2 48 3b 45 a0 0f 92 c2
[    0.658999] RIP  [<ffffffff810a3321>] select_task_rq_fair+0x691/0x9a0
[    0.658999]  RSP <ffff88022f967c30>
[    0.658999] ---[ end trace 4eaa2a86a8e2da24 ]---
[    0.658999] note: kthreadd[2] exited with preempt_count 2
[    0.658999] note: swapper[1] exited with preempt_count 1
[    0.659015] swapper used greatest stack depth: 3680 bytes left
[    0.660011] Kernel panic - not syncing: Attempted to kill init!
[    0.661008] Pid: 1, comm: swapper Tainted: G      D W   2.6.37-rc1+ #111
[    0.662005] Call Trace:
[    0.663012]  [<ffffffff8199acb0>] panic+0xb1/0x222
[    0.664011]  [<ffffffff810c2ff0>] do_exit+0xd10/0xdb0
[    0.665009]  [<ffffffff819a2398>] ? _raw_spin_unlock_irqrestore+0x88/0xd0
[    0.666011]  [<ffffffff819a414c>] oops_end+0x10c/0x150
[    0.667011]  [<ffffffff8105623a>] die+0x8a/0xc0
[    0.668011]  [<ffffffff819a337c>] do_trap+0x11c/0x1c0
[    0.669011]  [<ffffffff81051bee>] do_divide_error+0xbe/0xe0
[    0.670011]  [<ffffffff810a9d18>] ? find_busiest_group+0x6b8/0x1480
[    0.671011]  [<ffffffff8110ae39>] ? trace_hardirqs_off_caller+0x29/0x150
[    0.672009]  [<ffffffff819a1028>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[    0.673017]  [<ffffffff819a2c44>] ? irq_return+0x0/0xc
[    0.674012]  [<ffffffff8105183b>] divide_error+0x1b/0x20
[    0.675013]  [<ffffffff810a9d18>] ? find_busiest_group+0x6b8/0x1480
[    0.676013]  [<ffffffff810929ed>] ? __phys_addr+0x5d/0x120
[    0.677018]  [<ffffffff810b2614>] load_balance+0xe4/0xcb0
[    0.678012]  [<ffffffff810b0b54>] ? dequeue_task_fair+0x1f4/0x250
[    0.679015]  [<ffffffff8199be5d>] schedule+0xb0d/0x14b0
[    0.680009]  [<ffffffff810cc60e>] ? __sysctl_head_next+0x19e/0x1a0
[    0.681015]  [<ffffffff8199d2dd>] schedule_timeout+0x50d/0x570
[    0.682009]  [<ffffffff8110b9bc>] ? print_lock_contention_bug+0x2c/0x110
[    0.683012]  [<ffffffff810af7a1>] ? get_parent_ip+0x11/0x90
[    0.684009]  [<ffffffff819a7cbd>] ? sub_preempt_count+0x12d/0x1f0
[    0.685010]  [<ffffffff8199b10b>] wait_for_common+0x16b/0x290
[    0.686010]  [<ffffffff810b4950>] ? default_wake_function+0x0/0x20
[    0.687012]  [<ffffffff8199b34d>] wait_for_completion+0x1d/0x20
[    0.688009]  [<ffffffff810efdfb>] kthread_create+0x9b/0x150
[    0.689008]  [<ffffffff810e8310>] ? rescuer_thread+0x0/0x2a0
[    0.690012]  [<ffffffff81202078>] ? __kmalloc_node+0x2b8/0x340
[    0.691021]  [<ffffffff810e7d5a>] __alloc_workqueue_key+0x27a/0x830
[    0.692012]  [<ffffffff8263b23f>] cpuset_init_smp+0x56/0x8c
[    0.693010]  [<ffffffff8261d148>] kernel_init+0x17a/0x27c
[    0.694009]  [<ffffffff81051a24>] kernel_thread_helper+0x4/0x10
[    0.695012]  [<ffffffff819a2c14>] ? restore_args+0x0/0x30
[    0.696010]  [<ffffffff8261cfce>] ? kernel_init+0x0/0x27c
[    0.697009]  [<ffffffff81051a20>] ? kernel_thread_helper+0x0/0x10
[    2.074478] Rebooting in 10 seconds..

