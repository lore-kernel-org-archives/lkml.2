Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab0KMMAl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 07:00:41 -0500
Received: from mga14.intel.com ([143.182.124.37]:34945 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754264Ab0KMMAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 07:00:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,191,1288594800"; 
   d="scan'208";a="348299405"
Date: Sat, 13 Nov 2010 20:00:30 +0800
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
Message-ID: <20101113120030.GA31517@localhost>
References: <20101111100628.GA24728@localhost>
 <1289478978.2084.74.camel@laptop>
 <20101111124015.GA9706@localhost>
 <1289480656.2084.80.camel@laptop>
 <20101113084018.GA23098@localhost>
 <1289644224.2084.521.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289644224.2084.521.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 06:30:24PM +0800, Peter Zijlstra wrote:
> On Sat, 2010-11-13 at 16:40 +0800, Wu Fengguang wrote:
> > > Will try and figure out how the heck that's happening, Ingo any clue?
> > 
> > It's back to normal on 2.6.37-rc1 when reverting commit 50f2d7f682f9
> > ("x86, numa: Assign CPUs to nodes in round-robin manner on fake NUMA").
> > 
> > The interesting part is, the commit was introduced in 
> > 2.6.36-rc7..2.6.36, however 2.6.36 boots OK, while 2.6.37-rc1 panics.
> 
> Argh, that commit again..
> 
> Does this fix it: http://lkml.org/lkml/2010/11/12/8

No it still panics. Here is the dmesg.

Thanks,
Fengguang
---

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
[    0.000000] ODEBUG: 15 of 15 active objects replaced
[    0.000000] hpet clockevent registered
[    0.001000] Fast TSC calibration using PIT
[    0.002000] Detected 2666.733 MHz processor.
[    0.000009] Calibrating delay loop (skipped), value calculated using timer frequency.. 5333.46 BogoMIPS (lpj=2666733)
[    0.010813] pid_max: default: 32768 minimum: 301
[    0.018252] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.028528] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.036421] Mount-cache hash table entries: 256
[    0.041300] Initializing cgroup subsys debug
[    0.045664] Initializing cgroup subsys ns
[    0.049767] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.058788] Initializing cgroup subsys cpuacct
[    0.063328] Initializing cgroup subsys memory
[    0.067805] Initializing cgroup subsys devices
[    0.072340] Initializing cgroup subsys freezer
[    0.076910] CPU: Physical Processor ID: 0
[    0.081008] CPU: Processor Core ID: 0
[    0.084761] mce: CPU supports 9 MCE banks
[    0.088876] CPU0: Thermal monitoring enabled (TM1)
[    0.093767] using mwait in idle threads.
[    0.097777] Performance Events: PEBS fmt1+, Nehalem events, Intel PMU driver.
[    0.105138] ... version:                3
[    0.109239] ... bit width:              48
[    0.113423] ... generic registers:      4
[    0.117521] ... value mask:             0000ffffffffffff
[    0.122918] ... max period:             000000007fffffff
[    0.128319] ... fixed-purpose events:   3
[    0.132415] ... event mask:             000000070000000f
[    0.138807] ACPI: Core revision 20101013
[    0.162629] ftrace: allocating 24175 entries in 95 pages
[    0.177831] Setting APIC routing to flat
[    0.182351] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.198414] CPU0: Genuine Intel(R) CPU             000  @ 2.67GHz stepping 04
[    0.312081] lockdep: fixing up alternatives.
[    0.317087] Booting Node   0, Processors  #1lockdep: fixing up alternatives.
[    0.416915]  #2lockdep: fixing up alternatives.
[    0.513688]  #3lockdep: fixing up alternatives.
[    0.610394]  #4lockdep: fixing up alternatives.
[    0.707133]  Ok.
[    0.709070] Booting Node   1, Processors  #5lockdep: fixing up alternatives.
[    0.808855]  Ok.
[    0.810787] Booting Node   0, Processors  #6lockdep: fixing up alternatives.
[    0.910602]  Ok.
[    0.912532] Booting Node   1, Processors  #7 Ok.
[    1.007347] Brought up 8 CPUs
[    1.010412] Total of 8 processors activated (42661.40 BogoMIPS).
[    1.016551] Testing NMI watchdog ... OK.
[    1.044508] CPU0 attaching sched-domain:
[    1.048524]  domain 0: span 0-3 level MC
[    1.052578]   groups: 0 1 2 3
[    1.055836]   domain 1: span 0-4,6 level CPU
[    1.060235]    groups: 0-3 (cpu_power = 4096) 5,7 (cpu_power = 4096)
[    1.066875] ERROR: repeated CPUs
[    1.070189]
[    1.071778] ERROR: groups don't span domain->span
[    1.076564]    domain 2: span 0-7 level NODE
[    1.080966]     groups: 0-4,6 (cpu_power = 4096) 5,7 (cpu_power = 4096)
[    1.087884] CPU1 attaching sched-domain:
[    1.091899]  domain 0: span 0-3 level MC
[    1.095957]   groups: 1 2 3 0
[    1.099201]   domain 1: span 0-4,6 level CPU
[    1.103608]    groups: 0-3 (cpu_power = 4096) 5,7 (cpu_power = 4096)
[    1.110273] ERROR: repeated CPUs
[    1.113594]
[    1.115177] ERROR: groups don't span domain->span
[    1.119966]    domain 2: span 0-7 level NODE
[    1.124371]     groups: 0-4,6 (cpu_power = 4096) 5,7 (cpu_power = 4096)
[    1.131280] CPU2 attaching sched-domain:
[    1.135295]  domain 0: span 0-3 level MC
[    1.139353]   groups: 2 3 0 1
[    1.142609]   domain 1: span 0-4,6 level CPU
[    1.147008]    groups: 0-3 (cpu_power = 4096) 5,7 (cpu_power = 4096)
[    1.153664] ERROR: repeated CPUs
[    1.156979]
[    1.158567] ERROR: groups don't span domain->span
[    1.163357]    domain 2: span 0-7 level NODE
[    1.167759]     groups: 0-4,6 (cpu_power = 4096) 5,7 (cpu_power = 4096)
[    1.174681] CPU3 attaching sched-domain:
[    1.178688]  domain 0: span 0-3 level MC
[    1.182746]   groups: 3 0 1 2
[    1.185997]   domain 1: span 0-4,6 level CPU
[    1.190400]    groups: 0-3 (cpu_power = 4096) 5,7 (cpu_power = 4096)
[    1.197059] ERROR: repeated CPUs
[    1.200377]
[    1.201959] ERROR: groups don't span domain->span
[    1.206747]    domain 2: span 0-7 level NODE
[    1.211140]     groups: 0-4,6 (cpu_power = 4096) 5,7 (cpu_power = 4096)
[    1.218050] CPU4 attaching sched-domain:
[    1.222055]  domain 0: span 4-7 level MC
[    1.226112]   groups: 4 5 6 7
[    1.229358] ERROR: parent span is not a superset of domain->span
[    1.235452]   domain 1: span 0-4,6 level CPU
[    1.239858] ERROR: domain->groups does not contain CPU4
[    1.245163]    groups: 5,7 (cpu_power = 4096)
[    1.249742] ERROR: groups don't span domain->span
[    1.254535]    domain 2: span 0-7 level NODE
[    1.258935]     groups: 0-4,6 (cpu_power = 4096) 5,7 (cpu_power = 4096)
[    1.265836] CPU5 attaching sched-domain:
[    1.269841]  domain 0: span 4-7 level MC
[    1.273899]   groups: 5 6 7 4
[    1.277142] ERROR: parent span is not a superset of domain->span
[    1.283227]   domain 1: span 5,7 level CPU
[    1.287458]    groups: 5,7 (cpu_power = 4096)
[    1.292026]    domain 2: span 0-7 level NODE
[    1.296429]     groups: 5,7 (cpu_power = 4096) 0-4,6 (cpu_power = 4096)
[    1.304915] CPU6 attaching sched-domain:
[    1.308922]  domain 0: span 4-7 level MC
[    1.312979]   groups: 6 7 4 5
[    1.316248] ERROR: parent span is not a superset of domain->span
[    1.322344]   domain 1: span 0-4,6 level CPU
[    1.326742] ERROR: domain->groups does not contain CPU6
[    1.332048]    groups: 5,7 (cpu_power = 4096)
[    1.336623] ERROR: groups don't span domain->span
[    1.341437]    domain 2: span 0-7 level NODE
[    1.345841]     groups: 0-4,6 (cpu_power = 4096) 5,7 (cpu_power = 4096)
[    1.352755] CPU7 attaching sched-domain:
[    1.356764]  domain 0: span 4-7 level MC
[    1.360820]   groups: 7 4 5 6
[    1.364078] ERROR: parent span is not a superset of domain->span
[    1.370165]   domain 1: span 5,7 level CPU
[    1.374398]    groups: 5,7 (cpu_power = 4096)
[    1.378964]    domain 2: span 0-7 level NODE
[    1.383372]     groups: 5,7 (cpu_power = 4096) 0-4,6 (cpu_power = 4096)
[    6.526802] BUG: NMI Watchdog detected LOCKUP on CPU0, ip ffffffff810a9dc1, registers:
[    6.534902] CPU 0
[    6.536767] Modules linked in:
[    6.540213]
[    6.541792] Pid: 1, comm: swapper Tainted: G        W   2.6.37-rc1+ #111 X8DTN/X8DTN
[    6.549675] RIP: 0010:[<ffffffff810a9dc1>]  [<ffffffff810a9dc1>] find_busiest_group+0x761/0x1480
[    6.558650] RSP: 0018:ffff8801b966d870  EFLAGS: 00000012
[    6.564039] RAX: 0000000000000000 RBX: ffff8801b966daec RCX: 0000000000000000
[    6.571245] RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffff8800bac0e410
[    6.578455] RBP: ffff8801b966da30 R08: ffff8800bac0e410 R09: ffff8800bac0e400
[    6.585664] R10: 0000000000000003 R11: 0000000000000000 R12: 00000000001d2d00
[    6.592873] R13: 00000000001d2d00 R14: 00000000001d2d00 R15: 0000000000000008
[    6.600083] FS:  0000000000000000(0000) GS:ffff8800ba400000(0000) knlGS:0000000000000000
[    6.608312] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    6.614134] CR2: 0000000000000000 CR3: 0000000001ee1000 CR4: 00000000000006f0
[    6.621348] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    6.628558] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    6.635767] Process swapper (pid: 1, threadinfo ffff8801b966c000, task ffff8800b3778000)
[    6.643994] Stack:
[    6.646095]  ffff8801b966d890 ffff8801b966d9d0 0000000000000007 ffff8801bfdd2d00
[    6.653793]  0000000000000000 00000000001d2d00 ffff8801b966dae0 00000002b966d910
[    6.661476]  ffff8801b966d801 ffffffff810929ed ffff8800ba40de48 00000000000b306a
[    6.669171] Call Trace:
[    6.671706]  [<ffffffff810929ed>] ? __phys_addr+0x5d/0x120
[    6.677270]  [<ffffffff810b2614>] load_balance+0xe4/0xcb0
[    6.682747]  [<ffffffff810b0b54>] ? dequeue_task_fair+0x1f4/0x250
[    6.688926]  [<ffffffff8199be5d>] schedule+0xb0d/0x14b0
[    6.694235]  [<ffffffff810cc60e>] ? __sysctl_head_next+0x19e/0x1a0
[    6.700499]  [<ffffffff8199d2dd>] schedule_timeout+0x50d/0x570
[    6.706409]  [<ffffffff8110b9bc>] ? print_lock_contention_bug+0x2c/0x110
[    6.713187]  [<ffffffff810af7a1>] ? get_parent_ip+0x11/0x90
[    6.718843]  [<ffffffff819a7cbd>] ? sub_preempt_count+0x12d/0x1f0
[    6.725020]  [<ffffffff8199b10b>] wait_for_common+0x16b/0x290
[    6.730853]  [<ffffffff810b4950>] ? default_wake_function+0x0/0x20
[    6.737113]  [<ffffffff8199b34d>] wait_for_completion+0x1d/0x20
[    6.743112]  [<ffffffff810efdfb>] kthread_create+0x9b/0x150
[    6.748764]  [<ffffffff810e8310>] ? rescuer_thread+0x0/0x2a0
[    6.754506]  [<ffffffff81202078>] ? __kmalloc_node+0x2b8/0x340
[    6.760419]  [<ffffffff810e7d5a>] __alloc_workqueue_key+0x27a/0x830
[    6.766765]  [<ffffffff8263b23f>] cpuset_init_smp+0x56/0x8c
[    6.772417]  [<ffffffff8261d148>] kernel_init+0x17a/0x27c
[    6.777899]  [<ffffffff81051a24>] kernel_thread_helper+0x4/0x10
[    6.783899]  [<ffffffff819a2c14>] ? restore_args+0x0/0x30
[    6.789377]  [<ffffffff8261cfce>] ? kernel_init+0x0/0x27c
[    6.794859]  [<ffffffff81051a20>] ? kernel_thread_helper+0x0/0x10
[    6.801028] Code: ff 8b 42 08 48 05 00 02 00 00 48 c1 f8 0a 48 85 c0 48 89 45 c0 0f 94 c0 0f b6 c0 48 63 d0 48 83 c2 02 48 83 04 d5 58 21 09 82 01 <85> c0 0f 84 07 02 00 00 48 8b bd a8 fe ff ff 31 d2 83 7f 50 01
[    6.822637] ---[ end trace 4eaa2a86a8e2da23 ]---
[    6.827330] Kernel panic - not syncing: Non maskable interrupt
[    6.833236] Pid: 1, comm: swapper Tainted: G      D W   2.6.37-rc1+ #111
[    6.840018] Call Trace:
[    6.842548]  <NMI>  [<ffffffff810a9dc1>] ? find_busiest_group+0x761/0x1480
[    6.849539]  [<ffffffff8199acb0>] panic+0xb1/0x222
[    6.854414]  [<ffffffff810a9dc1>] ? find_busiest_group+0x761/0x1480
[    6.860763]  [<ffffffff819a4403>] die_nmi+0x153/0x180
[    6.865895]  [<ffffffff819a5049>] nmi_watchdog_tick+0x219/0x270
[    6.871902]  [<ffffffff819a38fa>] do_nmi+0x2fa/0x490
[    6.876955]  [<ffffffff819a3170>] nmi+0x20/0x39
[    6.881566]  [<ffffffff810a9dc1>] ? find_busiest_group+0x761/0x1480
[    6.887916]  <<EOE>>  [<ffffffff810929ed>] ? __phys_addr+0x5d/0x120
[    6.894301]  [<ffffffff810b2614>] load_balance+0xe4/0xcb0
[    6.899783]  [<ffffffff810b0b54>] ? dequeue_task_fair+0x1f4/0x250
[    6.905960]  [<ffffffff8199be5d>] schedule+0xb0d/0x14b0
[    6.911271]  [<ffffffff810cc60e>] ? __sysctl_head_next+0x19e/0x1a0
[    6.917533]  [<ffffffff8199d2dd>] schedule_timeout+0x50d/0x570
[    6.923443]  [<ffffffff8110b9bc>] ? print_lock_contention_bug+0x2c/0x110
[    6.930222]  [<ffffffff810af7a1>] ? get_parent_ip+0x11/0x90
[    6.935872]  [<ffffffff819a7cbd>] ? sub_preempt_count+0x12d/0x1f0
[    6.942051]  [<ffffffff8199b10b>] wait_for_common+0x16b/0x290
[    6.947881]  [<ffffffff810b4950>] ? default_wake_function+0x0/0x20
[    6.954140]  [<ffffffff8199b34d>] wait_for_completion+0x1d/0x20
[    6.960140]  [<ffffffff810efdfb>] kthread_create+0x9b/0x150
[    6.965792]  [<ffffffff810e8310>] ? rescuer_thread+0x0/0x2a0
[    6.971533]  [<ffffffff81202078>] ? __kmalloc_node+0x2b8/0x340
[    6.977445]  [<ffffffff810e7d5a>] __alloc_workqueue_key+0x27a/0x830
[    6.983793]  [<ffffffff8263b23f>] cpuset_init_smp+0x56/0x8c
[    6.989443]  [<ffffffff8261d148>] kernel_init+0x17a/0x27c
[    6.994924]  [<ffffffff81051a24>] kernel_thread_helper+0x4/0x10
[    7.000924]  [<ffffffff819a2c14>] ? restore_args+0x0/0x30
[    7.006402]  [<ffffffff8261cfce>] ? kernel_init+0x0/0x27c
[    7.011883]  [<ffffffff81051a20>] ? kernel_thread_helper+0x0/0x10
[    8.097122] Rebooting in 10 seconds..
