Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab0KKKJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 05:09:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:45833 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562Ab0KKKJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 05:09:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,182,1288594800"; 
   d="scan'208";a="572488514"
Date: Thu, 11 Nov 2010 18:09:21 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [BUG 2.6.27-rc1] find_busiest_group() LOCKUP
Message-ID: <20101111100921.GA25587@localhost>
References: <20101111100628.GA24728@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101111100628.GA24728@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 06:06:28PM +0800, Wu Fengguang wrote:
> Greetings,
> 
> I run into this kernel panic since 2.6.27-rc1.  2.6.36 boots OK.
> It's not yet fixed in 2.6.37-rc1-next-20101110. I can conveniently
> test any debug patches.
> 
> Thanks,
> Fengguang
> ---
> 
> 2.6.37-rc1-next-20101110 boot log

2.6.37-rc1 boot log, almost the same but stuck in find_next_bit():

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
[    0.000000] allocated 62914560 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 2666.516 MHz processor.
[    0.000028] Calibrating delay loop (skipped), value calculated using timer frequency.. 5333.03 BogoMIPS (lpj=10666064)
[    0.010995] pid_max: default: 32768 minimum: 301
[    0.018236] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.028644] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.036764] Mount-cache hash table entries: 256
[    0.042487] Initializing cgroup subsys debug
[    0.046892] Initializing cgroup subsys ns
[    0.051030] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.060093] Initializing cgroup subsys cpuacct
[    0.064674] Initializing cgroup subsys memory
[    0.069234] Initializing cgroup subsys devices
[    0.073811] Initializing cgroup subsys freezer
[    0.078386] Initializing cgroup subsys blkio
[    0.082905] CPU: Physical Processor ID: 0
[    0.087044] CPU: Processor Core ID: 0
[    0.090840] mce: CPU supports 9 MCE banks
[    0.094988] CPU0: Thermal monitoring enabled (TM1)
[    0.099921] using mwait in idle threads.
[    0.103969] Performance Events: PEBS fmt1+, Nehalem events, Intel PMU driver.
[    0.111449] ... version:                3
[    0.115583] ... bit width:              48
[    0.119802] ... generic registers:      4
[    0.123937] ... value mask:             0000ffffffffffff
[    0.129373] ... max period:             000000007fffffff
[    0.134816] ... fixed-purpose events:   3
[    0.138957] ... event mask:             000000070000000f
[    0.145671] ACPI: Core revision 20101013
[    0.171011] ftrace: allocating 29456 entries in 116 pages
[    0.185896] Setting APIC routing to flat
[    0.190577] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.236384] CPU0: Genuine Intel(R) CPU             000  @ 2.67GHz stepping 04
[    0.349319] lockdep: fixing up alternatives.
[    0.353960] Booting Node   0, Processors  #1lockdep: fixing up alternatives.
[    0.472080]  #2lockdep: fixing up alternatives.
[    0.588082]  #3lockdep: fixing up alternatives.
[    0.704042]  #4lockdep: fixing up alternatives.
[    0.820145]  Ok.
[    0.822112] Booting Node   1, Processors  #5lockdep: fixing up alternatives.
[    0.940140]  Ok.
[    0.942107] Booting Node   0, Processors  #6lockdep: fixing up alternatives.
[    1.060128]  Ok.
[    1.062100] Booting Node   1, Processors  #7 Ok.
[    1.176824] Brought up 8 CPUs
[    1.179908] Total of 8 processors activated (42666.32 BogoMIPS).
[    1.186105] Testing NMI watchdog ... OK.
[    6.770490] BUG: NMI Watchdog detected LOCKUP on CPU0, ip ffffffff815854e7, registers:
[    6.778665] CPU 0
[    6.780556] Modules linked in:
[    6.784094]
[    6.785702] Pid: 1, comm: swapper Not tainted 2.6.37-rc1 #10 X8DTN/X8DTN
[    6.792523] RIP: 0010:[<ffffffff815854e7>]  [<ffffffff815854e7>] find_next_bit+0x117/0x160
[    6.801043] RSP: 0018:ffff8801b9687870  EFLAGS: 00000006
[    6.806475] RAX: 0000000000000008 RBX: ffff8800bac0e410 RCX: 0000000000000000
[    6.813724] RDX: 0000000000000008 RSI: 0000000000000008 RDI: ffff8800bac0e410
[    6.820977] RBP: ffff8801b9687870 R08: 0000000000000000 R09: 00000000001d2c80
[    6.828232] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800ba40de48
[    6.835485] R13: ffff8801b9687b0c R14: 0000000000000000 R15: 00000000001d2c80
[    6.842740] FS:  0000000000000000(0000) GS:ffff8800ba400000(0000) knlGS:0000000000000000
[    6.851015] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    6.856873] CR2: 0000000000000000 CR3: 0000000002041000 CR4: 00000000000006f0
[    6.864121] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    6.871375] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    6.878630] Process swapper (pid: 1, threadinfo ffff8801b9686000, task ffff8800b3398000)
[    6.886904] Stack:
[    6.889029]  ffff8801b9687890 ffffffff81584d99 0000000000000007 00000000001d2c80
[    6.896861]  ffff8801b9687a40 ffffffff810a9fca 0000000000000001 ffff8801b96879e0
[    6.904696]  ffff8801b96879b0 ffff8801bfdd2c80 0000000000000007 0000000000000000
[    6.912530] Call Trace:
[    6.915094]  [<ffffffff81584d99>] cpumask_next_and+0x39/0x80
[    6.920873]  [<ffffffff810a9fca>] find_busiest_group+0x24a/0x1200
[    6.927087]  [<ffffffff810b08cf>] load_balance+0xdf/0xa60
[    6.932608]  [<ffffffff81c49b13>] ? schedule+0xdb3/0xee0
[    6.938040]  [<ffffffff81c49c29>] schedule+0xec9/0xee0
[    6.943293]  [<ffffffff81c4a69c>] schedule_timeout+0x30c/0x450
[    6.949246]  [<ffffffff81106a6b>] ? trace_hardirqs_off+0x1b/0x30
[    6.955367]  [<ffffffff810f606d>] ? local_clock+0x9d/0xb0
[    6.960888]  [<ffffffff81c4f0bc>] ? _raw_spin_unlock_irq+0x4c/0x70
[    6.967188]  [<ffffffff81c49fc5>] wait_for_common+0x185/0x220
[    6.973055]  [<ffffffff810b2250>] ? default_wake_function+0x0/0x30
[    6.979349]  [<ffffffff81c4a1b4>] wait_for_completion+0x24/0x30
[    6.985388]  [<ffffffff810eba42>] kthread_create+0xc2/0x160
[    6.991075]  [<ffffffff810e3c40>] ? rescuer_thread+0x0/0x2a0
[    6.996856]  [<ffffffff810a17cf>] ? complete+0x2f/0x80
[    7.002115]  [<ffffffff8110a35b>] ? trace_hardirqs_on+0x1b/0x30
[    7.008152]  [<ffffffff81212b50>] ? kmem_cache_alloc_notrace+0x160/0x1c0
[    7.014971]  [<ffffffff810e37d5>] __alloc_workqueue_key+0x465/0x8d0
[    7.021358]  [<ffffffff823c0a21>] cpuset_init_smp+0x5d/0x82
[    7.027052]  [<ffffffff8239f3fe>] kernel_init+0x1e7/0x337
[    7.032572]  [<ffffffff810529e4>] kernel_thread_helper+0x4/0x10
[    7.038614]  [<ffffffff81c4f690>] ? restore_args+0x0/0x30
[    7.044133]  [<ffffffff8239f217>] ? kernel_init+0x0/0x337
[    7.049652]  [<ffffffff810529e0>] ? kernel_thread_helper+0x0/0x10
[    7.055857] Code: d2 75 ce 48 83 c7 08 48 83 e8 40 49 83 c0 40 48 ff 05 be 59 a5 01 e9 2a ff ff ff 66 0f 1f 84 00 00 00 00 00 48 ff 05 99 59 a5 01 <c9> c3 0f 1f 80 00 00 00 00 49 8d 04 00 48 ff 05 bd 59 a5 01 c9
[    7.078960] ---[ end trace 4eaa2a86a8e2da22 ]---
[    7.083696] Kernel panic - not syncing: Non maskable interrupt
[    7.089643] Pid: 1, comm: swapper Tainted: G      D     2.6.37-rc1 #10
[    7.096283] Call Trace:
[    7.098850]  <NMI>  [<ffffffff81c4889e>] panic+0xad/0x260
[    7.104435]  [<ffffffff81c4f17d>] ? _raw_spin_unlock_irqrestore+0x9d/0xb0
[    7.111338]  [<ffffffff81c50e32>] die_nmi+0x182/0x1a0
[    7.116511]  [<ffffffff81c51a4a>] nmi_watchdog_tick+0x1ea/0x290
[    7.122542]  [<ffffffff81c502c0>] do_nmi+0x230/0x450
[    7.127620]  [<ffffffff81c4fbc0>] nmi+0x20/0x39
[    7.132267]  [<ffffffff815854e7>] ? find_next_bit+0x117/0x160
[    7.138124]  <<EOE>>  [<ffffffff81584d99>] cpumask_next_and+0x39/0x80
[    7.144747]  [<ffffffff810a9fca>] find_busiest_group+0x24a/0x1200
[    7.150956]  [<ffffffff810b08cf>] load_balance+0xdf/0xa60
[    7.156474]  [<ffffffff81c49b13>] ? schedule+0xdb3/0xee0
[    7.161899]  [<ffffffff81c49c29>] schedule+0xec9/0xee0
[    7.167151]  [<ffffffff81c4a69c>] schedule_timeout+0x30c/0x450
[    7.173099]  [<ffffffff81106a6b>] ? trace_hardirqs_off+0x1b/0x30
[    7.179224]  [<ffffffff810f606d>] ? local_clock+0x9d/0xb0
[    7.184737]  [<ffffffff81c4f0bc>] ? _raw_spin_unlock_irq+0x4c/0x70
[    7.191032]  [<ffffffff81c49fc5>] wait_for_common+0x185/0x220
[    7.196898]  [<ffffffff810b2250>] ? default_wake_function+0x0/0x30
[    7.203200]  [<ffffffff81c4a1b4>] wait_for_completion+0x24/0x30
[    7.209239]  [<ffffffff810eba42>] kthread_create+0xc2/0x160
[    7.214926]  [<ffffffff810e3c40>] ? rescuer_thread+0x0/0x2a0
[    7.220707]  [<ffffffff810a17cf>] ? complete+0x2f/0x80
[    7.225966]  [<ffffffff8110a35b>] ? trace_hardirqs_on+0x1b/0x30
[    7.231999]  [<ffffffff81212b50>] ? kmem_cache_alloc_notrace+0x160/0x1c0
[    7.238824]  [<ffffffff810e37d5>] __alloc_workqueue_key+0x465/0x8d0
[    7.245209]  [<ffffffff823c0a21>] cpuset_init_smp+0x5d/0x82
[    7.250902]  [<ffffffff8239f3fe>] kernel_init+0x1e7/0x337
[    7.256422]  [<ffffffff810529e4>] kernel_thread_helper+0x4/0x10
[    7.262455]  [<ffffffff81c4f690>] ? restore_args+0x0/0x30
[    7.267974]  [<ffffffff8239f217>] ? kernel_init+0x0/0x337
[    7.273486]  [<ffffffff810529e0>] ? kernel_thread_helper+0x0/0x10
[    8.307196] Rebooting in 10 seconds..
