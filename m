Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793Ab0CPNa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 09:30:26 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:59181 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966007Ab0CPNaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 09:30:23 -0400
Date: Tue, 16 Mar 2010 06:30:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, Steven Rostedt <rostedt@goodmis.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/rcu] rcu: Fix holdoff for accelerated GPs for last
	non-dynticked CPU
Message-ID: <20100316133015.GD6709@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1267311188-16603-1-git-send-email-paulmck@linux.vnet.ibm.com> <tip-622ea685f1fafdf84d612440535c84341f0860b8@git.kernel.org> <20100316110036.GA4554@elte.hu> <20100316110323.GA31038@elte.hu> <20100316115123.GA25467@elte.hu> <20100316121547.GA5019@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100316121547.GA5019@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 01:15:47PM +0100, Ingo Molnar wrote:
> 
> Weird: the crash occurs with v2.6.32 as well. Full crashlog attached below.

Hmmm...  Well, I guess that my recent patches might be causing some
other bug, but not this particular one.  ;-)

As noted below, it looks to me that rcutorture is trying to do what it
is supposed to, do a short delay and then continue through the loop.
Color me confused.

> 	Ingo
> 
> [    0.000000] Linux version 2.6.32-dirty (mingo@sirius) (gcc version 4.4.1 20091008 (Red Hat 4.4.1-20) (GCC) ) #116 SMP PREEMPT Tue Mar 16 15:12:26 CET 2010
> [    0.000000] Command line: root=/dev/sda6 earlyprintk=ttyS0,115200 console=ttyS0,115200 debug initcall_debug sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=0 panic=1 3
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000] CPU: vendor_id 'AuthenticAMD' unknown, using generic init.
> [    0.000000] CPU: Your system may be unstable.
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
> [    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
> [    0.000000]  BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> [    0.000000] bootconsole [earlyser0] enabled
> [    0.000000] debug: ignoring loglevel setting.
> [    0.000000] last_pfn = 0x3fff0 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-C7FFF write-protect
> [    0.000000]   C8000-FFFFF uncachable
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 0000000000 mask FFC0000000 write-back
> [    0.000000]   1 disabled
> [    0.000000]   2 disabled
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] initial memory mapped : 0 - 20000000
> [    0.000000] init_memory_mapping: 0000000000000000-000000003fff0000
> [    0.000000]  0000000000 - 003fe00000 page 2M
> [    0.000000]  003fe00000 - 003fff0000 page 4k
> [    0.000000] kernel direct mapping tables up to 3fff0000 @ 8000-b000
> [    0.000000] No NUMA configuration found
> [    0.000000] Faking a node at 0000000000000000-000000003fff0000
> [    0.000000] Bootmem setup node 0 0000000000000000-000000003fff0000
> [    0.000000]   NODE_DATA [0000000000009000 - 000000000003cfff]
> [    0.000000]   bootmap [000000000003d000 -  0000000000044fff] pages 8
> [    0.000000] (5 early reservations) ==> bootmem [0000000000 - 003fff0000]
> [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
> [    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
> [    0.000000]   #2 [0001000000 - 000770cc78]    TEXT DATA BSS ==> [0001000000 - 000770cc78]
> [    0.000000]   #3 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
> [    0.000000]   #4 [0000008000 - 0000009000]          PGTABLE ==> [0000008000 - 0000009000]
> [    0.000000] found SMP MP-table at [ffff8800000f5680] f5680
> [    0.000000]  [ffffea0000000000-ffffea00019fffff] PMD -> [ffff880007c00000-ffff8800095fffff] on node 0
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000000 -> 0x00001000
> [    0.000000]   DMA32    0x00001000 -> 0x00100000
> [    0.000000]   Normal   0x00100000 -> 0x00100000
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[2] active PFN ranges
> [    0.000000]     0: 0x00000000 -> 0x0000009f
> [    0.000000]     0: 0x00000100 -> 0x0003fff0
> [    0.000000] On node 0 totalpages: 262031
> [    0.000000]   DMA zone: 104 pages used for memmap
> [    0.000000]   DMA zone: 100 pages reserved
> [    0.000000]   DMA zone: 3795 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 6552 pages used for memmap
> [    0.000000]   DMA32 zone: 251480 pages, LIFO batch:31
> [    0.000000] SFI: Simple Firmware Interface v0.7 http://simplefirmware.org
> [    0.000000] Intel MultiProcessor Specification v1.4
> [    0.000000] MPTABLE: OEM ID: OEM00000
> [    0.000000] MPTABLE: Product ID: PROD00000000
> [    0.000000] MPTABLE: APIC at: 0xFEE00000
> [    0.000000] Processor #0 (Bootup-CPU)
> [    0.000000] Processor #1
> [    0.000000] I/O APIC #2 Version 17 at 0xFEC00000.
> [    0.000000] Processors: 2
> [    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 24
> [    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:a0000000)
> [    0.000000] NR_CPUS:4096 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 476 pages/cpu @ffff880009600000 s1925144 r0 d24552 u2097152
> [    0.000000] pcpu-alloc: s1925144 r0 d24552 u2097152 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 [0] 1 
> [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 255275
> [    0.000000] Policy zone: DMA32
> [    0.000000] Kernel command line: root=/dev/sda6 earlyprintk=ttyS0,115200 console=ttyS0,115200 debug initcall_debug sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=0 panic=1 3
> [    0.000000] debug: sysrq always enabled.
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] Initializing CPU#0
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Node 0: aperture @ 20000000 size 32 MB
> [    0.000000] Aperture pointing to e820 RAM. Ignoring.
> [    0.000000] Memory: 911788k/1048512k available (10324k kernel code, 388k absent, 136336k reserved, 8773k data, 3540k init)
> [    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] RCU-based detection of stalled CPUs is enabled.
> [    0.000000] NR_IRQS:4352
> [    0.000000] spurious 8259A interrupt: IRQ7.
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [ttyS0] enabled, bootconsole disabled
> [    0.000000] console [ttyS0] enabled, bootconsole disabled
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
> [    0.000000] ... CHAINHASH_SIZE:          16384
> [    0.000000]  memory used by lock dependency info: 6367 kB
> [    0.000000]  per task-struct memory footprint: 2688 bytes
> [    0.000000] ------------------------
> [    0.000000] | Locking API testsuite:
> [    0.000000] ----------------------------------------------------------------------------
> [    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
> [    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
> [    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
> [    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
> [    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
> [    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
> [    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
> [    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
> [    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
> [    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
> [    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
> [    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
> [    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq read-recursion/123:  ok  |
> [    0.000000]       soft-irq read-recursion/123:  ok  |
> [    0.000000]       hard-irq read-recursion/132:  ok  |
> [    0.000000]       soft-irq read-recursion/132:  ok  |
> [    0.000000]       hard-irq read-recursion/213:  ok  |
> [    0.000000]       soft-irq read-recursion/213:  ok  |
> [    0.000000]       hard-irq read-recursion/231:  ok  |
> [    0.000000]       soft-irq read-recursion/231:  ok  |
> [    0.000000]       hard-irq read-recursion/312:  ok  |
> [    0.000000]       soft-irq read-recursion/312:  ok  |
> [    0.000000]       hard-irq read-recursion/321:  ok  |
> [    0.000000]       soft-irq read-recursion/321:  ok  |
> [    0.000000] -------------------------------------------------------
> [    0.000000] Good, all 218 testcases passed! |
> [    0.000000] ---------------------------------
> [    0.000000] allocated 10485760 bytes of page_cgroup
> [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
> [    0.000000] ODEBUG: 0 of 0 active objects replaced
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] Detected 2010.507 MHz processor.
> [    0.010024] Calibrating delay loop (skipped), value calculated using timer frequency.. 4022.55 BogoMIPS (lpj=6701690)
> [    0.017398] Security Framework initialized
> [    0.020018] TOMOYO Linux initialized
> [    0.027078] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.030804] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.033809] Mount-cache hash table entries: 256
> [    0.038317] Initializing cgroup subsys debug
> [    0.040009] Initializing cgroup subsys ns
> [    0.043342] Initializing cgroup subsys memory
> [    0.046776] Initializing cgroup subsys freezer
> [    0.050241] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> [    0.053339] CPU: L2 Cache: 512K (64 bytes/line)
> [    0.056673] mce: CPU supports 5 MCE banks
> [    0.060007] MCE: unknown CPU type - not enabling MCE support.
> [    0.063341] numa_add_cpu cpu 0 node 0: mask now 0
> [    0.066672] Performance Events: 
> [    0.070053] Freeing SMP alternatives: 58k freed
> [    0.073409] ftrace: converting mcount calls to 0f 1f 44 00 00
> [    0.076676] ftrace: allocating 44576 entries in 175 pages
> [    0.083750] Setting APIC routing to flat
> [    0.086742] ExtINT not setup in hardware but reported by MP table
> [    0.090890] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
> [    0.093332] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> [    0.093332] ...trying to set up timer (IRQ0) through the 8259A ...
> [    0.093332] ..... (found apic 0 pin 0) ...
> [    0.129425] ....... works.
> [    0.130004] CPU0: AuthenticAMD AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
> [    0.246691] calling  migration_init+0x0/0x59 @ 1
> [    0.250234] initcall migration_init+0x0/0x59 returned 0 after 0 usecs
> [    0.253340] calling  spawn_ksoftirqd+0x0/0x5a @ 1
> [    0.260051] initcall spawn_ksoftirqd+0x0/0x5a returned 0 after 3255 usecs
> [    0.263341] calling  init_call_single_data+0x0/0xb6 @ 1
> [    0.266680] initcall init_call_single_data+0x0/0xb6 returned 0 after 0 usecs
> [    0.270007] calling  spawn_softlockup_task+0x0/0x75 @ 1
> [    0.273437] initcall spawn_softlockup_task+0x0/0x75 returned 0 after 0 usecs
> [    0.276673] calling  relay_init+0x0/0x8 @ 1
> [    0.280006] initcall relay_init+0x0/0x8 returned 0 after 0 usecs
> [    0.283347] calling  tracer_alloc_buffers+0x0/0x26d @ 1
> [    0.286885] Testing tracer nop: PASSED
> [    0.290736] initcall tracer_alloc_buffers+0x0/0x26d returned 0 after 3255 usecs
> [    0.293339] calling  init_trace_printk+0x0/0x8 @ 1
> [    0.296672] initcall init_trace_printk+0x0/0x8 returned 0 after 0 usecs
> [    0.300006] calling  trace_workqueue_early_init+0x0/0x12d @ 1
> [    0.303417] initcall trace_workqueue_early_init+0x0/0x12d returned 0 after 0 usecs
> [    0.316684] lockdep: fixing up alternatives.
> [    0.320156] Booting processor 1 APIC 0x1 ip 0x6000
> [    0.013332] Initializing CPU#1
> [    0.013332] Calibrating delay using timer specific routine.. 4021.84 BogoMIPS (lpj=6700559)
> [    0.013332] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> [    0.013332] CPU: L2 Cache: 512K (64 bytes/line)
> [    0.013332] numa_add_cpu cpu 1 node 0: mask now 0-1
> [    0.420082] CPU1: AuthenticAMD AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
> [    0.431283] Brought up 2 CPUs
> [    0.433339] Total of 2 processors activated (8044.40 BogoMIPS).
> [    0.437517] CPU0 attaching sched-domain:
> [    0.440010]  domain 0: span 0-1 level CPU
> [    0.446671]   groups: 0 1
> [    0.450032] CPU1 attaching sched-domain:
> [    0.453341]  domain 0: span 0-1 level CPU
> [    0.456671]   groups: 1 0
> [    0.461314] calling  init_mmap_min_addr+0x0/0x16 @ 1
> [    0.463349] initcall init_mmap_min_addr+0x0/0x16 returned 0 after 0 usecs
> [    0.466674] calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
> [    0.470011] initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 usecs
> [    0.473339] calling  net_ns_init+0x0/0x100 @ 1
> [    0.476698] initcall net_ns_init+0x0/0x100 returned 0 after 0 usecs
> [    0.480006] calling  cpufreq_tsc+0x0/0x28 @ 1
> [    0.483339] initcall cpufreq_tsc+0x0/0x28 returned 0 after 0 usecs
> [    0.486672] calling  pci_reboot_init+0x0/0x8 @ 1
> [    0.490005] initcall pci_reboot_init+0x0/0x8 returned 0 after 0 usecs
> [    0.493339] calling  init_smp_flush+0x0/0x42 @ 1
> [    0.496673] initcall init_smp_flush+0x0/0x42 returned 0 after 0 usecs
> [    0.500006] calling  sysctl_init+0x0/0x16 @ 1
> [    0.503346] initcall sysctl_init+0x0/0x16 returned 0 after 0 usecs
> [    0.506671] calling  ksysfs_init+0x0/0xc0 @ 1
> [    0.510054] initcall ksysfs_init+0x0/0xc0 returned 0 after 0 usecs
> [    0.513339] calling  async_init+0x0/0x60 @ 1
> [    0.516776] initcall async_init+0x0/0x60 returned 0 after 0 usecs
> [    0.520006] calling  init_jiffies_clocksource+0x0/0x12 @ 1
> [    0.523352] initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 usecs
> [    0.526672] calling  init_zero_pfn+0x0/0x35 @ 1
> [    0.530005] initcall init_zero_pfn+0x0/0x35 returned 0 after 0 usecs
> [    0.533338] calling  filelock_init+0x0/0x2e @ 1
> [    0.536752] initcall filelock_init+0x0/0x2e returned 0 after 0 usecs
> [    0.540005] calling  init_script_binfmt+0x0/0x14 @ 1
> [    0.543351] initcall init_script_binfmt+0x0/0x14 returned 0 after 0 usecs
> [    0.546671] calling  init_elf_binfmt+0x0/0x14 @ 1
> [    0.550005] initcall init_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
> [    0.553338] calling  init_compat_elf_binfmt+0x0/0x14 @ 1
> [    0.556672] initcall init_compat_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
> [    0.560005] calling  debugfs_init+0x0/0x5c @ 1
> [    0.563350] initcall debugfs_init+0x0/0x5c returned 0 after 0 usecs
> [    0.566672] calling  securityfs_init+0x0/0x53 @ 1
> [    0.570015] initcall securityfs_init+0x0/0x53 returned 0 after 0 usecs
> [    0.573338] calling  random32_init+0x0/0xcd @ 1
> [    0.576672] initcall random32_init+0x0/0xcd returned 0 after 0 usecs
> [    0.580005] calling  regulator_init+0x0/0x2e @ 1
> [    0.583337] regulator: core version 0.5
> [    0.586727] initcall regulator_init+0x0/0x2e returned 0 after 3255 usecs
> [    0.590005] calling  cpufreq_core_init+0x0/0x9b @ 1
> [    0.593347] initcall cpufreq_core_init+0x0/0x9b returned 0 after 0 usecs
> [    0.596671] calling  cpuidle_init+0x0/0x40 @ 1
> [    0.600019] initcall cpuidle_init+0x0/0x40 returned 0 after 0 usecs
> [    0.603338] calling  sock_init+0x0/0x5e @ 1
> [    0.607051] initcall sock_init+0x0/0x5e returned 0 after 0 usecs
> [    0.610006] calling  netpoll_init+0x0/0x14 @ 1
> [    0.613339] initcall netpoll_init+0x0/0x14 returned 0 after 0 usecs
> [    0.616671] calling  netlink_proto_init+0x0/0x14a @ 1
> [    0.620076] NET: Registered protocol family 16
> [    0.623416] initcall netlink_proto_init+0x0/0x14a returned 0 after 3255 usecs
> [    0.626672] calling  bdi_class_init+0x0/0x41 @ 1
> [    0.630215] initcall bdi_class_init+0x0/0x41 returned 0 after 0 usecs
> [    0.633339] calling  kobject_uevent_init+0x0/0x54 @ 1
> [    0.636690] initcall kobject_uevent_init+0x0/0x54 returned 0 after 0 usecs
> [    0.640005] calling  gpiolib_sysfs_init+0x0/0xa1 @ 1
> [    0.643441] initcall gpiolib_sysfs_init+0x0/0xa1 returned 0 after 0 usecs
> [    0.646672] calling  pcibus_class_init+0x0/0x19 @ 1
> [    0.650069] initcall pcibus_class_init+0x0/0x19 returned 0 after 0 usecs
> [    0.653338] calling  pci_driver_init+0x0/0x12 @ 1
> [    0.656765] initcall pci_driver_init+0x0/0x12 returned 0 after 0 usecs
> [    0.660005] calling  backlight_class_init+0x0/0x5d @ 1
> [    0.663406] initcall backlight_class_init+0x0/0x5d returned 0 after 0 usecs
> [    0.666671] calling  video_output_class_init+0x0/0x19 @ 1
> [    0.670070] initcall video_output_class_init+0x0/0x19 returned 0 after 0 usecs
> [    0.673338] calling  tty_class_init+0x0/0x38 @ 1
> [    0.676744] initcall tty_class_init+0x0/0x38 returned 0 after 0 usecs
> [    0.680006] calling  vtconsole_class_init+0x0/0xc2 @ 1
> [    0.683542] initcall vtconsole_class_init+0x0/0xc2 returned 0 after 0 usecs
> [    0.686673] calling  register_node_type+0x0/0x46 @ 1
> [    0.690081] initcall register_node_type+0x0/0x46 returned 0 after 0 usecs
> [    0.693338] calling  spi_init+0x0/0xb0 @ 1
> [    0.696827] initcall spi_init+0x0/0xb0 returned 0 after 0 usecs
> [    0.700005] calling  i2c_init+0x0/0x6a @ 1
> [    0.703524] i2c-core: driver [dummy] registered
> [    0.706691] initcall i2c_init+0x0/0x6a returned 0 after 3255 usecs
> [    0.710005] calling  amd_postcore_init+0x0/0xb2 @ 1
> [    0.713338] initcall amd_postcore_init+0x0/0xb2 returned 0 after 0 usecs
> [    0.716672] calling  arch_kdebugfs_init+0x0/0x2a8 @ 1
> [    0.723357] initcall arch_kdebugfs_init+0x0/0x2a8 returned 0 after 3255 usecs
> [    0.726673] calling  mtrr_if_init+0x0/0x61 @ 1
> [    0.730018] initcall mtrr_if_init+0x0/0x61 returned 0 after 0 usecs
> [    0.733338] calling  arch_init_ftrace_syscalls+0x0/0xe3 @ 1
> [    0.737746] initcall arch_init_ftrace_syscalls+0x0/0xe3 returned 0 after 0 usecs
> [    0.740005] calling  pci_arch_init+0x0/0x40 @ 1
> [    0.746670] PCI: Using configuration type 1 for base access
> [    0.750005] initcall pci_arch_init+0x0/0x40 returned 0 after 6510 usecs
> [    0.753338] calling  topology_init+0x0/0xf0 @ 1
> [    0.756911] initcall topology_init+0x0/0xf0 returned 0 after 0 usecs
> [    0.760005] calling  mtrr_init_finialize+0x0/0x3d @ 1
> [    0.763338] initcall mtrr_init_finialize+0x0/0x3d returned 0 after 0 usecs
> [    0.766671] calling  param_sysfs_init+0x0/0x3b2 @ 1
> [    0.801308] initcall param_sysfs_init+0x0/0x3b2 returned 0 after 29296 usecs
> [    0.803340] calling  pm_sysrq_init+0x0/0x1e @ 1
> [    0.806684] initcall pm_sysrq_init+0x0/0x1e returned 0 after 0 usecs
> [    0.810005] calling  audit_watch_init+0x0/0x2f @ 1
> [    0.813341] initcall audit_watch_init+0x0/0x2f returned 0 after 0 usecs
> [    0.816672] calling  init_slow_work+0x0/0x70 @ 1
> [    0.820041] initcall init_slow_work+0x0/0x70 returned 0 after 0 usecs
> [    0.823338] calling  default_bdi_init+0x0/0xc6 @ 1
> [    0.830250] initcall default_bdi_init+0x0/0xc6 returned 0 after 3255 usecs
> [    0.833339] calling  init_bio+0x0/0xda @ 1
> [    0.836945] bio: create slab <bio-0> at 0
> [    0.840101] initcall init_bio+0x0/0xda returned 0 after 3255 usecs
> [    0.843338] calling  fsnotify_init+0x0/0x12 @ 1
> [    0.846675] initcall fsnotify_init+0x0/0x12 returned 0 after 0 usecs
> [    0.850004] calling  fsnotify_notification_init+0x0/0x68 @ 1
> [    0.853455] initcall fsnotify_notification_init+0x0/0x68 returned 0 after 0 usecs
> [    0.856672] calling  cryptomgr_init+0x0/0x12 @ 1
> [    0.860005] initcall cryptomgr_init+0x0/0x12 returned 0 after 0 usecs
> [    0.863338] calling  blk_settings_init+0x0/0x2a @ 1
> [    0.866672] initcall blk_settings_init+0x0/0x2a returned 0 after 0 usecs
> [    0.870005] calling  blk_ioc_init+0x0/0x2a @ 1
> [    0.873377] initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
> [    0.876671] calling  blk_softirq_init+0x0/0x80 @ 1
> [    0.880004] initcall blk_softirq_init+0x0/0x80 returned 0 after 0 usecs
> [    0.883337] calling  blk_iopoll_setup+0x0/0xa5 @ 1
> [    0.886671] initcall blk_iopoll_setup+0x0/0xa5 returned 0 after 0 usecs
> [    0.890004] calling  genhd_device_init+0x0/0x66 @ 1
> [    0.893551] initcall genhd_device_init+0x0/0x66 returned 0 after 0 usecs
> [    0.896673] calling  gpiolib_debugfs_init+0x0/0x24 @ 1
> [    0.900062] initcall gpiolib_debugfs_init+0x0/0x24 returned 0 after 0 usecs
> [    0.903338] calling  mc33880_init+0x0/0x12 @ 1
> [    0.906775] initcall mc33880_init+0x0/0x12 returned 0 after 0 usecs
> [    0.910005] calling  mcp23s08_init+0x0/0x12 @ 1
> [    0.913412] initcall mcp23s08_init+0x0/0x12 returned 0 after 0 usecs
> [    0.916671] calling  pca953x_init+0x0/0x14 @ 1
> [    0.920078] i2c-core: driver [pca953x] registered
> [    0.923341] initcall pca953x_init+0x0/0x14 returned 0 after 3255 usecs
> [    0.926671] calling  pcf857x_init+0x0/0x14 @ 1
> [    0.930075] i2c-core: driver [pcf857x] registered
> [    0.933340] initcall pcf857x_init+0x0/0x14 returned 0 after 3255 usecs
> [    0.936671] calling  gpio_twl4030_init+0x0/0x12 @ 1
> [    0.940087] initcall gpio_twl4030_init+0x0/0x12 returned 0 after 0 usecs
> [    0.943338] calling  wm831x_gpio_init+0x0/0x12 @ 1
> [    0.946744] initcall wm831x_gpio_init+0x0/0x12 returned 0 after 0 usecs
> [    0.950006] calling  pci_slot_init+0x0/0x4b @ 1
> [    0.953348] initcall pci_slot_init+0x0/0x4b returned 0 after 0 usecs
> [    0.956671] calling  regulator_fixed_voltage_init+0x0/0x12 @ 1
> [    0.960086] initcall regulator_fixed_voltage_init+0x0/0x12 returned 0 after 0 usecs
> [    0.963338] calling  twl4030reg_init+0x0/0x12 @ 1
> [    0.966744] initcall twl4030reg_init+0x0/0x12 returned 0 after 0 usecs
> [    0.970005] calling  wm831x_dcdc_init+0x0/0x88 @ 1
> [    0.973629] initcall wm831x_dcdc_init+0x0/0x88 returned 0 after 0 usecs
> [    0.976672] calling  wm831x_isink_init+0x0/0x31 @ 1
> [    0.980086] initcall wm831x_isink_init+0x0/0x31 returned 0 after 0 usecs
> [    0.983338] calling  wm831x_ldo_init+0x0/0x68 @ 1
> [    0.986891] initcall wm831x_ldo_init+0x0/0x68 returned 0 after 0 usecs
> [    0.990005] calling  pcap_regulator_init+0x0/0x12 @ 1
> [    0.993420] initcall pcap_regulator_init+0x0/0x12 returned 0 after 0 usecs
> [    0.996671] calling  tps_65023_init+0x0/0x14 @ 1
> [    1.000076] i2c-core: driver [tps65023] registered
> [    1.003340] initcall tps_65023_init+0x0/0x14 returned 0 after 3255 usecs
> [    1.006670] calling  tps_6507x_init+0x0/0x14 @ 1
> [    1.010076] i2c-core: driver [tps6507x] registered
> [    1.013340] initcall tps_6507x_init+0x0/0x14 returned 0 after 3255 usecs
> [    1.016670] calling  misc_init+0x0/0xb7 @ 1
> [    1.020110] initcall misc_init+0x0/0xb7 returned 0 after 0 usecs
> [    1.023380] calling  vga_arb_device_init+0x0/0x80 @ 1
> [    1.026891] vgaarb: loaded
> [    1.029600] initcall vga_arb_device_init+0x0/0x80 returned 0 after 0 usecs
> [    1.030005] calling  tifm_init+0x0/0x85 @ 1
> [    1.033513] initcall tifm_init+0x0/0x85 returned 0 after 0 usecs
> [    1.036672] calling  wm831x_i2c_init+0x0/0x33 @ 1
> [    1.040075] i2c-core: driver [wm831x] registered
> [    1.043340] initcall wm831x_i2c_init+0x0/0x33 returned 0 after 3255 usecs
> [    1.046671] calling  wm8350_i2c_init+0x0/0x14 @ 1
> [    1.050074] i2c-core: driver [wm8350] registered
> [    1.053340] initcall wm8350_i2c_init+0x0/0x14 returned 0 after 3255 usecs
> [    1.056671] calling  tps_init+0x0/0xb2 @ 1
> [    1.060003] tps65010: version 2 May 2005
> [    1.063408] i2c-core: driver [tps65010] registered
> [    1.066795] i2c-core: driver [tps65010] unregistered
> [    1.083417] i2c-core: driver [tps65010] registered
> [    1.086761] i2c-core: driver [tps65010] unregistered
> [    1.103416] i2c-core: driver [tps65010] registered
> [    1.106761] i2c-core: driver [tps65010] unregistered
> [    1.110003] tps65010: no chip?
> [    1.113338] initcall tps_init+0x0/0xb2 returned -19 after 52083 usecs
> [    1.116671] calling  twl4030_init+0x0/0x14 @ 1
> [    1.120074] i2c-core: driver [twl4030] registered
> [    1.123340] initcall twl4030_init+0x0/0x14 returned 0 after 3255 usecs
> [    1.126671] calling  ezx_pcap_init+0x0/0x12 @ 1
> [    1.130085] initcall ezx_pcap_init+0x0/0x12 returned 0 after 0 usecs
> [    1.133338] calling  init_scsi+0x0/0x91 @ 1
> [    1.137735] SCSI subsystem initialized
> [    1.140007] initcall init_scsi+0x0/0x91 returned 0 after 3255 usecs
> [    1.143338] calling  ata_init+0x0/0x36c @ 1
> [    1.146801] libata version 3.00 loaded.
> [    1.150006] initcall ata_init+0x0/0x36c returned 0 after 3255 usecs
> [    1.153337] calling  phy_init+0x0/0x2e @ 1
> [    1.156920] initcall phy_init+0x0/0x2e returned 0 after 0 usecs
> [    1.160006] calling  twl4030_usb_init+0x0/0x12 @ 1
> [    1.163417] initcall twl4030_usb_init+0x0/0x12 returned 0 after 0 usecs
> [    1.166671] calling  nop_usb_xceiv_init+0x0/0x12 @ 1
> [    1.170087] initcall nop_usb_xceiv_init+0x0/0x12 returned 0 after 0 usecs
> [    1.173338] calling  usb_init+0x0/0x15a @ 1
> [    1.176880] usbcore: registered new interface driver usbfs
> [    1.180086] usbcore: registered new interface driver hub
> [    1.183423] usbcore: registered new device driver usb
> [    1.186672] initcall usb_init+0x0/0x15a returned 0 after 9765 usecs
> [    1.190004] calling  serio_init+0x0/0x86 @ 1
> [    1.193521] initcall serio_init+0x0/0x86 returned 0 after 0 usecs
> [    1.196672] calling  gameport_init+0x0/0x86 @ 1
> [    1.200173] initcall gameport_init+0x0/0x86 returned 0 after 0 usecs
> [    1.203338] calling  input_init+0x0/0x13d @ 1
> [    1.206778] initcall input_init+0x0/0x13d returned 0 after 0 usecs
> [    1.210004] calling  rtc_init+0x0/0x6c @ 1
> [    1.213403] initcall rtc_init+0x0/0x6c returned 0 after 0 usecs
> [    1.216671] calling  pps_init+0x0/0xb1 @ 1
> [    1.220070] LinuxPPS API ver. 1 registered
> [    1.223336] Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    1.226670] initcall pps_init+0x0/0xb1 returned 0 after 6510 usecs
> [    1.230004] calling  power_supply_class_init+0x0/0x38 @ 1
> [    1.233403] initcall power_supply_class_init+0x0/0x38 returned 0 after 0 usecs
> [    1.236670] calling  hwmon_init+0x0/0x106 @ 1
> [    1.240072] initcall hwmon_init+0x0/0x106 returned 0 after 0 usecs
> [    1.243337] calling  thermal_init+0x0/0x57 @ 1
> [    1.246734] initcall thermal_init+0x0/0x57 returned 0 after 0 usecs
> [    1.250004] calling  md_init+0x0/0xd0 @ 1
> [    1.253362] initcall md_init+0x0/0xd0 returned 0 after 0 usecs
> [    1.256673] calling  mmc_init+0x0/0x76 @ 1
> [    1.263407] initcall mmc_init+0x0/0x76 returned 0 after 3255 usecs
> [    1.266671] calling  leds_init+0x0/0x40 @ 1
> [    1.270069] initcall leds_init+0x0/0x40 returned 0 after 0 usecs
> [    1.273338] calling  pci_subsys_init+0x0/0x113 @ 1
> [    1.276669] PCI: Probing PCI hardware
> [    1.280041] PCI: Probing PCI hardware (bus 00)
> [    1.283488] PCI: Scanning bus 0000:00
> [    1.290059] pci 0000:00:00.0: found [10de:005e] class 000580 header type 00
> [    1.293418] pci 0000:00:00.0: calling quirk_resource_alignment+0x0/0x1a2
> [    1.296752] pci 0000:00:01.0: found [10de:0050] class 000601 header type 00
> [    1.300057] pci 0000:00:01.0: calling nvidia_force_enable_hpet+0x0/0xbf
> [    1.303336] HPET not enabled in BIOS. You might try hpet=force boot option
> [    1.306671] pci 0000:00:01.0: calling quirk_resource_alignment+0x0/0x1a2
> [    1.310035] pci 0000:00:01.1: found [10de:0052] class 000c05 header type 00
> [    1.313359] pci 0000:00:01.1: reg 10 io port: [0xdc00-0xdc1f]
> [    1.316694] pci 0000:00:01.1: reg 20 io port: [0x4c00-0x4c3f]
> [    1.320009] pci 0000:00:01.1: reg 24 io port: [0x4c40-0x4c7f]
> [    1.323348] pci 0000:00:01.1: calling quirk_resource_alignment+0x0/0x1a2
> [    1.326689] pci 0000:00:01.1: PME# supported from D3hot D3cold
> [    1.330006] pci 0000:00:01.1: PME# disabled
> [    1.333391] pci 0000:00:02.0: found [10de:005a] class 000c03 header type 00
> [    1.336692] pci 0000:00:02.0: reg 10 32bit mmio: [0xda102000-0xda102fff]
> [    1.340044] pci 0000:00:02.0: calling quirk_resource_alignment+0x0/0x1a2
> [    1.343355] pci 0000:00:02.0: supports D1 D2
> [    1.346669] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    1.350006] pci 0000:00:02.0: PME# disabled
> [    1.353371] pci 0000:00:02.1: found [10de:005b] class 000c03 header type 00
> [    1.356699] pci 0000:00:02.1: reg 10 32bit mmio: [0xfeb00000-0xfeb000ff]
> [    1.360044] pci 0000:00:02.1: calling quirk_resource_alignment+0x0/0x1a2
> [    1.363365] pci 0000:00:02.1: supports D1 D2
> [    1.366669] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
> [    1.370006] pci 0000:00:02.1: PME# disabled
> [    1.373398] pci 0000:00:04.0: found [10de:0059] class 000401 header type 00
> [    1.376692] pci 0000:00:04.0: reg 10 io port: [0xd400-0xd4ff]
> [    1.380009] pci 0000:00:04.0: reg 14 io port: [0xd800-0xd8ff]
> [    1.383343] pci 0000:00:04.0: reg 18 32bit mmio: [0xda101000-0xda101fff]
> [    1.386700] pci 0000:00:04.0: calling quirk_resource_alignment+0x0/0x1a2
> [    1.390022] pci 0000:00:04.0: supports D1 D2
> [    1.393371] pci 0000:00:06.0: found [10de:0053] class 000101 header type 00
> [    1.400018] pci 0000:00:06.0: reg 20 io port: [0xf000-0xf00f]
> [    1.403355] pci 0000:00:06.0: calling quirk_resource_alignment+0x0/0x1a2
> [    1.406723] pci 0000:00:09.0: found [10de:005c] class 000604 header type 01
> [    1.410029] pci 0000:00:09.0: calling quirk_resource_alignment+0x0/0x1a2
> [    1.413368] pci 0000:00:0a.0: found [10de:0057] class 000680 header type 00
> [    1.416692] pci 0000:00:0a.0: reg 10 32bit mmio: [0xda100000-0xda100fff]
> [    1.420010] pci 0000:00:0a.0: reg 14 io port: [0xd000-0xd007]
> [    1.423371] pci 0000:00:0a.0: calling quirk_resource_alignment+0x0/0x1a2
> [    1.426689] pci 0000:00:0a.0: supports D1 D2
> [    1.430002] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    1.436674] pci 0000:00:0a.0: PME# disabled
> [    1.440043] pci 0000:00:0b.0: found [10de:005d] class 000604 header type 01
> [    1.443387] pci 0000:00:0b.0: calling quirk_resource_alignment+0x0/0x1a2
> [    1.446705] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    1.450005] pci 0000:00:0b.0: PME# disabled
> [    1.453384] pci 0000:00:0c.0: found [10de:005d] class 000604 header type 01
> [    1.456721] pci 0000:00:0c.0: calling quirk_resource_alignment+0x0/0x1a2
> [    1.460038] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    1.463339] pci 0000:00:0c.0: PME# disabled
> [    1.466727] pci 0000:00:0d.0: found [10de:005d] class 000604 header type 01
> [    1.470054] pci 0000:00:0d.0: calling quirk_resource_alignment+0x0/0x1a2
> [    1.473372] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    1.476672] pci 0000:00:0d.0: PME# disabled
> [    1.480050] pci 0000:00:0e.0: found [10de:005d] class 000604 header type 01
> [    1.483387] pci 0000:00:0e.0: calling quirk_resource_alignment+0x0/0x1a2
> [    1.486705] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    1.490005] pci 0000:00:0e.0: PME# disabled
> [    1.493409] pci 0000:00:18.0: found [1022:1100] class 000600 header type 00
> [    1.496715] pci 0000:00:18.0: calling quirk_resource_alignment+0x0/0x1a2
> [    1.500046] pci 0000:00:18.1: found [1022:1101] class 000600 header type 00
> [    1.503381] pci 0000:00:18.1: calling quirk_resource_alignment+0x0/0x1a2
> [    1.506739] pci 0000:00:18.2: found [1022:1102] class 000600 header type 00
> [    1.510048] pci 0000:00:18.2: calling quirk_resource_alignment+0x0/0x1a2
> [    1.513363] pci 0000:00:18.3: found [1022:1103] class 000600 header type 00
> [    1.516715] pci 0000:00:18.3: calling quirk_resource_alignment+0x0/0x1a2
> [    1.520052] PCI: Fixups for bus 0000:00
> [    1.523339] pci 0000:00:09.0: scanning behind bridge, config 050500, pass 0
> [    1.523340] Clocksource tsc unstable (delta = 314902817 ns)
> [    1.526686] PCI: Scanning bus 0000:05
> [    1.530054] pci 0000:05:07.0: found [10ec:8139] class 000200 header type 00
> [    1.533362] pci 0000:05:07.0: reg 10 io port: [0xc000-0xc0ff]
> [    1.536677] pci 0000:05:07.0: reg 14 32bit mmio: [0xda000000-0xda0000ff]
> [    1.540044] pci 0000:05:07.0: calling quirk_resource_alignment+0x0/0x1a2
> [    1.543359] pci 0000:05:07.0: supports D1 D2
> [    1.546669] pci 0000:05:07.0: PME# supported from D1 D2 D3hot
> [    1.550006] pci 0000:05:07.0: PME# disabled
> [    1.553444] PCI: Fixups for bus 0000:05
> [    1.556669] pci 0000:00:09.0: transparent bridge
> [    1.560006] pci 0000:00:09.0: bridge io port: [0xc000-0xcfff]
> [    1.563339] pci 0000:00:09.0: bridge 32bit mmio: [0xda000000-0xda0fffff]
> [    1.566672] PCI: Bus scan for 0000:05 returning with max=05
> [    1.570006] pci 0000:00:0b.0: scanning behind bridge, config 040400, pass 0
> [    1.573351] PCI: Scanning bus 0000:04
> [    1.576787] PCI: Fixups for bus 0000:04
> [    1.580017] PCI: Bus scan for 0000:04 returning with max=04
> [    1.583339] pci 0000:00:0c.0: scanning behind bridge, config 030300, pass 0
> [    1.586685] PCI: Scanning bus 0000:03
> [    1.590121] PCI: Fixups for bus 0000:03
> [    1.593351] PCI: Bus scan for 0000:03 returning with max=03
> [    1.596673] pci 0000:00:0d.0: scanning behind bridge, config 020200, pass 0
> [    1.600018] PCI: Scanning bus 0000:02
> [    1.603454] PCI: Fixups for bus 0000:02
> [    1.606684] PCI: Bus scan for 0000:02 returning with max=02
> [    1.610006] pci 0000:00:0e.0: scanning behind bridge, config 010100, pass 0
> [    1.613351] PCI: Scanning bus 0000:01
> [    1.616698] pci 0000:01:00.0: found [1002:5b60] class 000300 header type 00
> [    1.620014] pci 0000:01:00.0: calling quirk_no_ata_d3+0x0/0x20
> [    1.623347] pci 0000:01:00.0: reg 10 32bit mmio pref: [0xd0000000-0xd7ffffff]
> [    1.626677] pci 0000:01:00.0: reg 14 io port: [0xb000-0xb0ff]
> [    1.630010] pci 0000:01:00.0: reg 18 32bit mmio: [0xd9000000-0xd900ffff]
> [    1.633364] pci 0000:01:00.0: reg 30 32bit mmio pref: [0x000000-0x01ffff]
> [    1.636674] pci 0000:01:00.0: calling quirk_resource_alignment+0x0/0x1a2
> [    1.640035] pci 0000:01:00.0: supports D1 D2
> [    1.643382] pci 0000:01:00.1: found [1002:5b70] class 000380 header type 00
> [    1.646680] pci 0000:01:00.1: calling quirk_no_ata_d3+0x0/0x20
> [    1.650012] pci 0000:01:00.1: reg 10 32bit mmio: [0xd9010000-0xd901ffff]
> [    1.653383] pci 0000:01:00.1: calling quirk_resource_alignment+0x0/0x1a2
> [    1.656697] pci 0000:01:00.1: supports D1 D2
> [    1.660048] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
> [    1.663553] PCI: Fixups for bus 0000:01
> [    1.666675] pci 0000:00:0e.0: bridge io port: [0xb000-0xbfff]
> [    1.670005] pci 0000:00:0e.0: bridge 32bit mmio: [0xd8000000-0xd9ffffff]
> [    1.673342] pci 0000:00:0e.0: bridge 64bit mmio pref: [0xd0000000-0xd7ffffff]
> [    1.676669] PCI: Bus scan for 0000:01 returning with max=01
> [    1.680006] pci 0000:00:09.0: scanning behind bridge, config 050500, pass 1
> [    1.683342] pci 0000:00:0b.0: scanning behind bridge, config 040400, pass 1
> [    1.686675] pci 0000:00:0c.0: scanning behind bridge, config 030300, pass 1
> [    1.690008] pci 0000:00:0d.0: scanning behind bridge, config 020200, pass 1
> [    1.693342] pci 0000:00:0e.0: scanning behind bridge, config 010100, pass 1
> [    1.696673] PCI: Bus scan for 0000:00 returning with max=05
> [    1.703618] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
> [    1.707286] pci 0000:00:00.0: default IRQ router [10de:005e]
> [    1.710540] initcall pci_subsys_init+0x0/0x113 returned 0 after 423176 usecs
> [    1.713337] calling  proto_init+0x0/0x12 @ 1
> [    1.716685] initcall proto_init+0x0/0x12 returned 0 after 0 usecs
> [    1.720003] calling  net_dev_init+0x0/0x1a1 @ 1
> [    1.723911] initcall net_dev_init+0x0/0x1a1 returned 0 after 0 usecs
> [    1.726670] calling  neigh_init+0x0/0x71 @ 1
> [    1.730004] initcall neigh_init+0x0/0x71 returned 0 after 0 usecs
> [    1.733336] calling  pktsched_init+0x0/0xd0 @ 1
> [    1.736695] initcall pktsched_init+0x0/0xd0 returned 0 after 0 usecs
> [    1.740003] calling  tc_filter_init+0x0/0x4c @ 1
> [    1.743336] initcall tc_filter_init+0x0/0x4c returned 0 after 0 usecs
> [    1.746669] calling  tc_action_init+0x0/0x4c @ 1
> [    1.750003] initcall tc_action_init+0x0/0x4c returned 0 after 0 usecs
> [    1.753336] calling  genl_init+0x0/0x8f @ 1
> [    1.756788] initcall genl_init+0x0/0x8f returned 0 after 0 usecs
> [    1.760003] calling  cipso_v4_init+0x0/0x88 @ 1
> [    1.763359] initcall cipso_v4_init+0x0/0x88 returned 0 after 0 usecs
> [    1.766670] calling  netlbl_init+0x0/0x81 @ 1
> [    1.770001] NetLabel: Initializing
> [    1.773335] NetLabel:  domain hash size = 128
> [    1.776668] NetLabel:  protocols = UNLABELED CIPSOv4
> [    1.780205] NetLabel:  unlabeled traffic allowed by default
> [    1.783337] initcall netlbl_init+0x0/0x81 returned 0 after 13020 usecs
> [    1.786669] calling  rfkill_init+0x0/0x5f @ 1
> [    1.790161] initcall rfkill_init+0x0/0x5f returned 0 after 0 usecs
> [    1.793337] calling  wpan_phy_class_init+0x0/0x19 @ 1
> [    1.796735] initcall wpan_phy_class_init+0x0/0x19 returned 0 after 0 usecs
> [    1.800003] calling  sysctl_init+0x0/0x48 @ 1
> [    1.803339] initcall sysctl_init+0x0/0x48 returned 0 after 0 usecs
> [    1.806672] calling  print_all_ICs+0x0/0x556 @ 1
> [    1.810010] initcall print_all_ICs+0x0/0x556 returned 0 after 0 usecs
> [    1.813336] calling  hpet_late_init+0x0/0xdc @ 1
> [    1.816670] initcall hpet_late_init+0x0/0xdc returned -19 after 0 usecs
> [    1.820004] calling  clocksource_done_booting+0x0/0x38 @ 1
> [    1.823340] Switching to clocksource jiffies
> [    1.826672] initcall clocksource_done_booting+0x0/0x38 returned 0 after 3255 usecs
> [    1.830003] calling  ftrace_init_debugfs+0x0/0x1eb @ 1
> [    1.833519] initcall ftrace_init_debugfs+0x0/0x1eb returned 0 after 0 usecs
> [    1.836670] calling  rb_init_debugfs+0x0/0x2f @ 1
> [    1.840047] initcall rb_init_debugfs+0x0/0x2f returned 0 after 0 usecs
> [    1.843337] calling  tracer_init_debugfs+0x0/0x340 @ 1
> [    1.850548] initcall tracer_init_debugfs+0x0/0x340 returned 0 after 3255 usecs
> [    1.853337] calling  init_trace_printk_function_export+0x0/0x2f @ 1
> [    1.856684] initcall init_trace_printk_function_export+0x0/0x2f returned 0 after 0 usecs
> [    1.860003] calling  stat_workqueue_init+0x0/0x2b @ 1
> [    1.863356] initcall stat_workqueue_init+0x0/0x2b returned 0 after 0 usecs
> [    1.866670] calling  event_trace_init+0x0/0x4a0 @ 1
> [    1.942723] initcall event_trace_init+0x0/0x4a0 returned 0 after 68359 usecs
> [    1.943339] calling  init_pipe_fs+0x0/0x4c @ 1
> [    1.946821] initcall init_pipe_fs+0x0/0x4c returned 0 after 0 usecs
> [    1.950003] calling  eventpoll_init+0x0/0xe3 @ 1
> [    1.953483] initcall eventpoll_init+0x0/0xe3 returned 0 after 0 usecs
> [    1.956669] calling  anon_inode_init+0x0/0x128 @ 1
> [    1.963482] initcall anon_inode_init+0x0/0x128 returned 0 after 3255 usecs
> [    1.966670] calling  fscache_init+0x0/0xaf @ 1
> [    1.970014] Slow work thread pool: Starting up
> [    1.973521] Slow work thread pool: Ready
> [    1.976779] FS-Cache: Loaded
> [    1.979658] initcall fscache_init+0x0/0xaf returned 0 after 6510 usecs
> [    1.980004] calling  cachefiles_init+0x0/0xa4 @ 1
> [    1.983515] CacheFiles: Loaded
> [    1.986671] initcall cachefiles_init+0x0/0xa4 returned 0 after 3255 usecs
> [    1.990003] calling  tomoyo_initerface_init+0x0/0x11c @ 1
> [    1.996811] initcall tomoyo_initerface_init+0x0/0x11c returned 0 after 3255 usecs
> [    2.000003] calling  blk_scsi_ioctl_init+0x0/0x289 @ 1
> [    2.003336] initcall blk_scsi_ioctl_init+0x0/0x289 returned 0 after 0 usecs
> [    2.006670] calling  chr_dev_init+0x0/0xc3 @ 1
> [    2.010991] initcall chr_dev_init+0x0/0xc3 returned 0 after 0 usecs
> [    2.013338] calling  firmware_class_init+0x0/0x79 @ 1
> [    2.016739] initcall firmware_class_init+0x0/0x79 returned 0 after 0 usecs
> [    2.020004] calling  ieee1394_init+0x0/0x260 @ 1
> [    2.023833] initcall ieee1394_init+0x0/0x260 returned 0 after 0 usecs
> [    2.026672] calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
> [    2.030017] initcall cpufreq_gov_performance_init+0x0/0x12 returned 0 after 0 usecs
> [    2.033336] calling  cpufreq_gov_userspace_init+0x0/0x12 @ 1
> [    2.036671] initcall cpufreq_gov_userspace_init+0x0/0x12 returned 0 after 0 usecs
> [    2.040003] calling  ssb_modinit+0x0/0x49 @ 1
> [    2.043439] initcall ssb_modinit+0x0/0x49 returned 0 after 0 usecs
> [    2.046670] calling  pcibios_assign_resources+0x0/0x74 @ 1
> [    2.050204] pci 0000:00:09.0: PCI bridge, secondary bus 0000:05
> [    2.053337] pci 0000:00:09.0:   IO window: 0xc000-0xcfff
> [    2.056673] pci 0000:00:09.0:   MEM window: 0xda000000-0xda0fffff
> [    2.060004] pci 0000:00:09.0:   PREFETCH window: disabled
> [    2.063338] pci 0000:00:0b.0: PCI bridge, secondary bus 0000:04
> [    2.066668] pci 0000:00:0b.0:   IO window: disabled
> [    2.070005] pci 0000:00:0b.0:   MEM window: disabled
> [    2.076669] pci 0000:00:0b.0:   PREFETCH window: disabled
> [    2.080005] pci 0000:00:0c.0: PCI bridge, secondary bus 0000:03
> [    2.083334] pci 0000:00:0c.0:   IO window: disabled
> [    2.086672] pci 0000:00:0c.0:   MEM window: disabled
> [    2.090004] pci 0000:00:0c.0:   PREFETCH window: disabled
> [    2.093338] pci 0000:00:0d.0: PCI bridge, secondary bus 0000:02
> [    2.096668] pci 0000:00:0d.0:   IO window: disabled
> [    2.100006] pci 0000:00:0d.0:   MEM window: disabled
> [    2.103337] pci 0000:00:0d.0:   PREFETCH window: disabled
> [    2.106678] pci 0000:01:00.0: BAR 6: got res [0xd8000000-0xd801ffff] bus [0xd8000000-0xd801ffff] flags 0x27200
> [    2.110005] pci 0000:00:0e.0: PCI bridge, secondary bus 0000:01
> [    2.113337] pci 0000:00:0e.0:   IO window: 0xb000-0xbfff
> [    2.116673] pci 0000:00:0e.0:   MEM window: 0xd8000000-0xd9ffffff
> [    2.120005] pci 0000:00:0e.0:   PREFETCH window: 0x000000d0000000-0x000000d7ffffff
> [    2.123351] pci 0000:00:09.0: setting latency timer to 64
> [    2.126681] pci 0000:00:0b.0: setting latency timer to 64
> [    2.130014] pci 0000:00:0c.0: setting latency timer to 64
> [    2.133347] pci 0000:00:0d.0: setting latency timer to 64
> [    2.136680] pci 0000:00:0e.0: setting latency timer to 64
> [    2.140004] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
> [    2.143335] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
> [    2.146669] pci_bus 0000:05: resource 0 io:  [0xc000-0xcfff]
> [    2.150002] pci_bus 0000:05: resource 1 mem: [0xda000000-0xda0fffff]
> [    2.153335] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
> [    2.156671] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
> [    2.160002] pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
> [    2.163335] pci_bus 0000:01: resource 1 mem: [0xd8000000-0xd9ffffff]
> [    2.166668] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xd7ffffff]
> [    2.170003] initcall pcibios_assign_resources+0x0/0x74 returned 0 after 117187 usecs
> [    2.173336] calling  sysctl_core_init+0x0/0x38 @ 1
> [    2.176694] initcall sysctl_core_init+0x0/0x38 returned 0 after 0 usecs
> [    2.180003] calling  inet_init+0x0/0x209 @ 1
> [    2.183625] NET: Registered protocol family 2
> [    2.187000] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
> [    2.190464] IPv4 FIB: Using LC-trie version 0.409
> [    2.197124] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
> [    2.203376] TCP bind hash table entries: 65536 (order: 10, 4718592 bytes)
> [    2.215136] TCP: Hash tables configured (established 131072 bind 65536)
> [    2.216713] TCP reno registered
> [    2.220429] initcall inet_init+0x0/0x209 returned 0 after 35807 usecs
> [    2.223337] calling  af_unix_init+0x0/0x55 @ 1
> [    2.226759] NET: Registered protocol family 1
> [    2.230033] initcall af_unix_init+0x0/0x55 returned 0 after 3255 usecs
> [    2.233336] calling  init_sunrpc+0x0/0x5d @ 1
> [    2.237131] RPC: Registered udp transport module.
> [    2.240004] RPC: Registered tcp transport module.
> [    2.243335] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [    2.246674] initcall init_sunrpc+0x0/0x5d returned 0 after 9765 usecs
> [    2.250003] calling  pci_apply_final_quirks+0x0/0x35 @ 1
> [    2.253351] pci 0000:00:00.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x12
> [    2.256706] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x20
> [    2.260004] pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x5be
> [    2.263337] pci 0000:00:00.0: calling pci_fixup_video+0x0/0xbd
> [    2.266677] pci 0000:00:01.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x12
> [    2.270005] pci 0000:00:01.0: calling quirk_cardbus_legacy+0x0/0x20
> [    2.273336] pci 0000:00:01.0: calling quirk_usb_early_handoff+0x0/0x5be
> [    2.276669] pci 0000:00:01.0: calling pci_fixup_video+0x0/0xbd
> [    2.280010] pci 0000:00:01.1: calling nv_msi_ht_cap_quirk_leaf+0x0/0x12
> [    2.283343] pci 0000:00:01.1: calling quirk_cardbus_legacy+0x0/0x20
> [    2.286669] pci 0000:00:01.1: calling quirk_usb_early_handoff+0x0/0x5be
> [    2.290002] pci 0000:00:01.1: calling pci_fixup_video+0x0/0xbd
> [    2.293343] pci 0000:00:02.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x12
> [    2.296677] pci 0000:00:02.0: calling quirk_cardbus_legacy+0x0/0x20
> [    2.300002] pci 0000:00:02.0: calling quirk_usb_early_handoff+0x0/0x5be
> [    2.316703] pci 0000:00:02.0: calling pci_fixup_video+0x0/0xbd
> [    2.320011] pci 0000:00:02.1: calling nv_msi_ht_cap_quirk_leaf+0x0/0x12
> [    2.323402] pci 0000:00:02.1: calling quirk_cardbus_legacy+0x0/0x20
> [    2.326669] pci 0000:00:02.1: calling quirk_usb_early_handoff+0x0/0x5be
> [    2.330027] pci 0000:00:02.1: calling pci_fixup_video+0x0/0xbd
> [    2.333344] pci 0000:00:04.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x12
> [    2.336677] pci 0000:00:04.0: calling quirk_cardbus_legacy+0x0/0x20
> [    2.340003] pci 0000:00:04.0: calling quirk_usb_early_handoff+0x0/0x5be
> [    2.343336] pci 0000:00:04.0: calling pci_fixup_video+0x0/0xbd
> [    2.346677] pci 0000:00:06.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x12
> [    2.350010] pci 0000:00:06.0: calling quirk_cardbus_legacy+0x0/0x20
> [    2.353336] pci 0000:00:06.0: calling quirk_usb_early_handoff+0x0/0x5be
> [    2.356669] pci 0000:00:06.0: calling pci_fixup_video+0x0/0xbd
> [    2.360010] pci 0000:00:09.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x12
> [    2.363338] pci 0000:00:09.0: calling quirk_cardbus_legacy+0x0/0x20
> [    2.366669] pci 0000:00:09.0: calling quirk_usb_early_handoff+0x0/0x5be
> [    2.370003] pci 0000:00:09.0: calling pci_fixup_video+0x0/0xbd
> [    2.373343] pci 0000:00:0a.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x12
> [    2.376677] pci 0000:00:0a.0: calling quirk_cardbus_legacy+0x0/0x20
> [    2.380002] pci 0000:00:0a.0: calling quirk_usb_early_handoff+0x0/0x5be
> [    2.383336] pci 0000:00:0a.0: calling pci_fixup_video+0x0/0xbd
> [    2.386677] pci 0000:00:0b.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x12
> [    2.390130] pci 0000:00:00.0: Found enabled HT MSI Mapping
> [    2.393337] pci 0000:00:0b.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x8a
> [    2.396684] pci 0000:00:0b.0: Found disabled HT MSI Mapping
> [    2.400016] pci 0000:00:00.0: Found enabled HT MSI Mapping
> [    2.403337] pci 0000:00:0b.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x70
> [    2.406671] pci 0000:00:0b.0: calling quirk_cardbus_legacy+0x0/0x20
> [    2.410002] pci 0000:00:0b.0: calling quirk_usb_early_handoff+0x0/0x5be
> [    2.413338] pci 0000:00:0b.0: calling pci_fixup_video+0x0/0xbd
> [    2.416677] pci 0000:00:0c.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x12
> [    2.420145] pci 0000:00:00.0: Found enabled HT MSI Mapping
> [    2.423336] pci 0000:00:0c.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x8a
> [    2.426684] pci 0000:00:0c.0: Found disabled HT MSI Mapping
> [    2.430016] pci 0000:00:00.0: Found enabled HT MSI Mapping
> [    2.433337] pci 0000:00:0c.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x70
> [    2.436670] pci 0000:00:0c.0: calling quirk_cardbus_legacy+0x0/0x20
> [    2.440002] pci 0000:00:0c.0: calling quirk_usb_early_handoff+0x0/0x5be
> [    2.443336] pci 0000:00:0c.0: calling pci_fixup_video+0x0/0xbd
> [    2.446677] pci 0000:00:0d.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x12
> [    2.450164] pci 0000:00:00.0: Found enabled HT MSI Mapping
> [    2.453336] pci 0000:00:0d.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x8a
> [    2.456684] pci 0000:00:0d.0: Found disabled HT MSI Mapping
> [    2.460016] pci 0000:00:00.0: Found enabled HT MSI Mapping
> [    2.463336] pci 0000:00:0d.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x70
> [    2.466670] pci 0000:00:0d.0: calling quirk_cardbus_legacy+0x0/0x20
> [    2.470002] pci 0000:00:0d.0: calling quirk_usb_early_handoff+0x0/0x5be
> [    2.473336] pci 0000:00:0d.0: calling pci_fixup_video+0x0/0xbd
> [    2.476677] pci 0000:00:0e.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x12
> [    2.480183] pci 0000:00:00.0: Found enabled HT MSI Mapping
> [    2.483336] pci 0000:00:0e.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x8a
> [    2.486684] pci 0000:00:0e.0: Found disabled HT MSI Mapping
> [    2.490016] pci 0000:00:00.0: Found enabled HT MSI Mapping
> [    2.493336] pci 0000:00:0e.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x70
> [    2.496670] pci 0000:00:0e.0: calling quirk_cardbus_legacy+0x0/0x20
> [    2.500002] pci 0000:00:0e.0: calling quirk_usb_early_handoff+0x0/0x5be
> [    2.503336] pci 0000:00:0e.0: calling pci_fixup_video+0x0/0xbd
> [    2.506678] pci 0000:00:18.0: calling quirk_amd_nb_node+0x0/0x56
> [    2.510008] pci 0000:00:18.0: calling quirk_cardbus_legacy+0x0/0x20
> [    2.513336] pci 0000:00:18.0: calling quirk_usb_early_handoff+0x0/0x5be
> [    2.516669] pci 0000:00:18.0: calling pci_fixup_video+0x0/0xbd
> [    2.520009] pci 0000:00:18.1: calling quirk_amd_nb_node+0x0/0x56
> [    2.523341] pci 0000:00:18.1: calling quirk_cardbus_legacy+0x0/0x20
> [    2.526669] pci 0000:00:18.1: calling quirk_usb_early_handoff+0x0/0x5be
> [    2.530002] pci 0000:00:18.1: calling pci_fixup_video+0x0/0xbd
> [    2.533343] pci 0000:00:18.2: calling quirk_amd_nb_node+0x0/0x56
> [    2.536674] pci 0000:00:18.2: calling quirk_cardbus_legacy+0x0/0x20
> [    2.540002] pci 0000:00:18.2: calling quirk_usb_early_handoff+0x0/0x5be
> [    2.543335] pci 0000:00:18.2: calling pci_fixup_video+0x0/0xbd
> [    2.546676] pci 0000:00:18.3: calling quirk_amd_nb_node+0x0/0x56
> [    2.550007] pci 0000:00:18.3: calling quirk_cardbus_legacy+0x0/0x20
> [    2.553335] pci 0000:00:18.3: calling quirk_usb_early_handoff+0x0/0x5be
> [    2.556669] pci 0000:00:18.3: calling pci_fixup_video+0x0/0xbd
> [    2.560010] pci 0000:05:07.0: calling quirk_cardbus_legacy+0x0/0x20
> [    2.563336] pci 0000:05:07.0: calling quirk_usb_early_handoff+0x0/0x5be
> [    2.566669] pci 0000:05:07.0: calling pci_fixup_video+0x0/0xbd
> [    2.570010] pci 0000:01:00.0: calling quirk_cardbus_legacy+0x0/0x20
> [    2.573335] pci 0000:01:00.0: calling quirk_usb_early_handoff+0x0/0x5be
> [    2.576669] pci 0000:01:00.0: calling pci_fixup_video+0x0/0xbd
> [    2.580005] pci 0000:01:00.0: Boot video device
> [    2.583344] pci 0000:01:00.1: calling quirk_cardbus_legacy+0x0/0x20
> [    2.586669] pci 0000:01:00.1: calling quirk_usb_early_handoff+0x0/0x5be
> [    2.590002] pci 0000:01:00.1: calling pci_fixup_video+0x0/0xbd
> [    2.593342] initcall pci_apply_final_quirks+0x0/0x35 returned 0 after 332030 usecs
> [    2.596669] calling  populate_rootfs+0x0/0xd7 @ 1
> [    2.600890] initcall populate_rootfs+0x0/0xd7 returned 0 after 0 usecs
> [    2.603336] calling  pci_iommu_init+0x0/0x12 @ 1
> [    2.606935] initcall pci_iommu_init+0x0/0x12 returned 0 after 0 usecs
> [    2.610001] calling  i8259A_init_sysfs+0x0/0x22 @ 1
> [    2.613594] initcall i8259A_init_sysfs+0x0/0x22 returned 0 after 0 usecs
> [    2.616668] calling  vsyscall_init+0x0/0x60 @ 1
> [    2.620014] initcall vsyscall_init+0x0/0x60 returned 0 after 0 usecs
> [    2.623334] calling  sbf_init+0x0/0xe9 @ 1
> [    2.626709] initcall sbf_init+0x0/0xe9 returned 0 after 0 usecs
> [    2.630001] calling  i8237A_init_sysfs+0x0/0x22 @ 1
> [    2.633452] initcall i8237A_init_sysfs+0x0/0x22 returned 0 after 0 usecs
> [    2.636668] calling  add_rtc_cmos+0x0/0x42 @ 1
> [    2.640157] platform rtc_cmos: registered platform RTC device (no PNP device found)
> [    2.643336] initcall add_rtc_cmos+0x0/0x42 returned 0 after 3255 usecs
> [    2.646669] calling  cache_sysfs_init+0x0/0x2ef @ 1
> [    2.650002] initcall cache_sysfs_init+0x0/0x2ef returned 0 after 0 usecs
> [    2.653374] calling  mce_init_device+0x0/0x2c9 @ 1
> [    2.656668] initcall mce_init_device+0x0/0x2c9 returned -5 after 0 usecs
> [    2.660002] initcall mce_init_device+0x0/0x2c9 returned with error code -5 
> [    2.663335] calling  threshold_init_device+0x0/0x82 @ 1
> [    2.666709] initcall threshold_init_device+0x0/0x82 returned 0 after 0 usecs
> [    2.670006] calling  inject_init+0x0/0x32 @ 1
> [    2.673334] Machine check injector initialized
> [    2.676672] initcall inject_init+0x0/0x32 returned 0 after 3255 usecs
> [    2.680041] calling  msr_init+0x0/0x12e @ 1
> [    2.683631] initcall msr_init+0x0/0x12e returned 0 after 0 usecs
> [    2.686669] calling  cpuid_init+0x0/0x12e @ 1
> [    2.690296] initcall cpuid_init+0x0/0x12e returned 0 after 0 usecs
> [    2.693377] calling  ioapic_init_sysfs+0x0/0xb3 @ 1
> [    2.696788] initcall ioapic_init_sysfs+0x0/0xb3 returned 0 after 0 usecs
> [    2.700001] calling  add_pcspkr+0x0/0x28 @ 1
> [    2.703438] initcall add_pcspkr+0x0/0x28 returned 0 after 0 usecs
> [    2.706708] calling  microcode_init+0x0/0x10a @ 1
> [    2.710000] microcode: no support for this CPU vendor
> [    2.713334] initcall microcode_init+0x0/0x10a returned -19 after 3255 usecs
> [    2.716669] calling  start_periodic_check_for_corruption+0x0/0x3c @ 1
> [    2.720041] initcall start_periodic_check_for_corruption+0x0/0x3c returned 0 after 0 usecs
> [    2.723334] calling  audit_classes_init+0x0/0xaf @ 1
> [    2.726692] initcall audit_classes_init+0x0/0xaf returned 0 after 0 usecs
> [    2.730002] calling  start_pageattr_test+0x0/0x47 @ 1
> [    2.736886] initcall start_pageattr_test+0x0/0x47 returned 0 after 0 usecs
> [    2.740062] calling  pt_dump_init+0x0/0x30 @ 1
> [    2.743356] initcall pt_dump_init+0x0/0x30 returned 0 after 0 usecs
> [    2.746668] calling  crypto_fpu_module_init+0x0/0x12 @ 1
> [    2.753388] initcall crypto_fpu_module_init+0x0/0x12 returned 0 after 3255 usecs
> [    2.756668] calling  aes_init+0x0/0x12 @ 1
> [    2.760167] initcall aes_init+0x0/0x12 returned 0 after 0 usecs
> [    2.762220] cryptomgr_test used greatest stack depth: 6168 bytes left
> [    2.763343] calling  init+0x0/0x12 @ 1
> [    2.766742] initcall init+0x0/0x12 returned 0 after 0 usecs
> [    2.770004] calling  aesni_init+0x0/0x164 @ 1
> [    2.773333] Intel AES-NI instructions are not detected.
> [    2.776668] initcall aesni_init+0x0/0x164 returned -19 after 3255 usecs
> [    2.780000] calling  crc32c_intel_mod_init+0x0/0x20 @ 1
> [    2.783381] initcall crc32c_intel_mod_init+0x0/0x20 returned -19 after 0 usecs
> [    2.786667] calling  init_vdso_vars+0x0/0x207 @ 1
> [    2.790016] initcall init_vdso_vars+0x0/0x207 returned 0 after 0 usecs
> [    2.793334] calling  ia32_binfmt_init+0x0/0x14 @ 1
> [    2.796712] initcall ia32_binfmt_init+0x0/0x14 returned 0 after 0 usecs
> [    2.800001] calling  sysenter_setup+0x0/0x2d0 @ 1
> [    2.803340] initcall sysenter_setup+0x0/0x2d0 returned 0 after 0 usecs
> [    2.806667] calling  init_aout_binfmt+0x0/0x14 @ 1
> [    2.810042] initcall init_aout_binfmt+0x0/0x14 returned 0 after 0 usecs
> [    2.813334] calling  init_sched_debug_procfs+0x0/0x2c @ 1
> [    2.816684] initcall init_sched_debug_procfs+0x0/0x2c returned 0 after 0 usecs
> [    2.820000] calling  proc_schedstat_init+0x0/0x22 @ 1
> [    2.823385] initcall proc_schedstat_init+0x0/0x22 returned 0 after 0 usecs
> [    2.826667] calling  proc_execdomains_init+0x0/0x22 @ 1
> [    2.830020] initcall proc_execdomains_init+0x0/0x22 returned 0 after 0 usecs
> [    2.833334] calling  ioresources_init+0x0/0x3c @ 1
> [    2.836728] initcall ioresources_init+0x0/0x3c returned 0 after 0 usecs
> [    2.840001] calling  uid_cache_init+0x0/0x8c @ 1
> [    2.843396] initcall uid_cache_init+0x0/0x8c returned 0 after 0 usecs
> [    2.846668] calling  init_posix_timers+0x0/0x17a @ 1
> [    2.850090] initcall init_posix_timers+0x0/0x17a returned 0 after 0 usecs
> [    2.853334] calling  init_posix_cpu_timers+0x0/0xe5 @ 1
> [    2.856668] initcall init_posix_cpu_timers+0x0/0xe5 returned 0 after 0 usecs
> [    2.860000] calling  nsproxy_cache_init+0x0/0x2d @ 1
> [    2.863459] initcall nsproxy_cache_init+0x0/0x2d returned 0 after 0 usecs
> [    2.866668] calling  create_proc_profile+0x0/0x24f @ 1
> [    2.870001] initcall create_proc_profile+0x0/0x24f returned 0 after 0 usecs
> [    2.873334] calling  timekeeping_init_device+0x0/0x22 @ 1
> [    2.876844] initcall timekeeping_init_device+0x0/0x22 returned 0 after 0 usecs
> [    2.880001] calling  init_clocksource_sysfs+0x0/0x50 @ 1
> [    2.883460] initcall init_clocksource_sysfs+0x0/0x50 returned 0 after 0 usecs
> [    2.886668] calling  init_timer_list_procfs+0x0/0x2c @ 1
> [    2.890053] initcall init_timer_list_procfs+0x0/0x2c returned 0 after 0 usecs
> [    2.893334] calling  init_tstats_procfs+0x0/0x2c @ 1
> [    2.896678] initcall init_tstats_procfs+0x0/0x2c returned 0 after 0 usecs
> [    2.900001] calling  lockdep_proc_init+0x0/0x7c @ 1
> [    2.903416] initcall lockdep_proc_init+0x0/0x7c returned 0 after 0 usecs
> [    2.906667] calling  futex_init+0x0/0x80 @ 1
> [    2.910044] initcall futex_init+0x0/0x80 returned 0 after 0 usecs
> [    2.913334] calling  proc_dma_init+0x0/0x22 @ 1
> [    2.916719] initcall proc_dma_init+0x0/0x22 returned 0 after 0 usecs
> [    2.920001] calling  kallsyms_init+0x0/0x25 @ 1
> [    2.923345] initcall kallsyms_init+0x0/0x25 returned 0 after 0 usecs
> [    2.926670] calling  crash_save_vmcoreinfo_init+0x0/0x46d @ 1
> [    2.930067] initcall crash_save_vmcoreinfo_init+0x0/0x46d returned 0 after 0 usecs
> [    2.933334] calling  crash_notes_memory_init+0x0/0x37 @ 1
> [    2.936675] initcall crash_notes_memory_init+0x0/0x37 returned 0 after 0 usecs
> [    2.940001] calling  backtrace_regression_test+0x0/0x105 @ 1
> [    2.943372] ====[ backtrace testing ]===========
> [    2.946665] Testing a backtrace from process context.
> [    2.949999] The following trace is a kernel self test and not a bug!
> [    2.953334] Pid: 1, comm: swapper Not tainted 2.6.32-dirty #116
> [    2.956705] Call Trace:
> [    2.960002]  [<ffffffff81087b1f>] ? backtrace_regression_test+0x0/0x105
> [    2.963335]  [<ffffffff81087b5c>] backtrace_regression_test+0x3d/0x105
> [    2.966669]  [<ffffffff81a0f1d2>] ? printk+0x41/0x43
> [    2.970041]  [<ffffffff810736a6>] ? timekeeping_get_ns+0x1b/0x3d
> [    2.973334]  [<ffffffff81073ee5>] ? ktime_get+0x5e/0x98
> [    2.976668]  [<ffffffff81087b1f>] ? backtrace_regression_test+0x0/0x105
> [    2.980001]  [<ffffffff81087b1f>] ? backtrace_regression_test+0x0/0x105
> [    2.983376]  [<ffffffff8100907d>] do_one_initcall+0x72/0x17f
> [    2.986670]  [<ffffffff8247f66c>] kernel_init+0x15f/0x1b5
> [    2.990002]  [<ffffffff8100cd9a>] child_rip+0xa/0x20
> [    2.993336]  [<ffffffff81040ab9>] ? finish_task_switch+0x74/0xab
> [    2.996708]  [<ffffffff8100c700>] ? restore_args+0x0/0x30
> [    3.000001]  [<ffffffff8247f50d>] ? kernel_init+0x0/0x1b5
> [    3.003334]  [<ffffffff8100cd90>] ? child_rip+0x0/0x20
> [    3.006666] Testing a backtrace from irq context.
> [    3.010038] The following trace is a kernel self test and not a bug!
> [    3.013353] Pid: 4, comm: ksoftirqd/0 Not tainted 2.6.32-dirty #116
> [    3.016663] Call Trace:
> [    3.019996]  <IRQ>  [<ffffffff8107caa6>] ? trace_hardirqs_on_caller+0xfa/0x13f
> [    3.026666]  [<ffffffff81087b11>] backtrace_test_irq_callback+0xe/0x1c
> [    3.030000]  [<ffffffff81052862>] tasklet_action+0x7e/0xdc
> [    3.033332]  [<ffffffff81053d95>] __do_softirq+0x10f/0x1ea
> [    3.036665]  [<ffffffff8100ce9c>] call_softirq+0x1c/0x28
> [    3.039996]  <EOI>  [<ffffffff8100ea59>] do_softirq+0x3d/0x88
> [    3.046665]  [<ffffffff810539a5>] ksoftirqd+0x9d/0x181
> [    3.049998]  [<ffffffff81053908>] ? ksoftirqd+0x0/0x181
> [    3.053334]  [<ffffffff8106b58e>] kthread+0x7f/0x87
> [    3.056665]  [<ffffffff8100cd9a>] child_rip+0xa/0x20
> [    3.059998]  [<ffffffff81040ab9>] ? finish_task_switch+0x74/0xab
> [    3.063331]  [<ffffffff8100c700>] ? restore_args+0x0/0x30
> [    3.066665]  [<ffffffff8106b50f>] ? kthread+0x0/0x87
> [    3.069998]  [<ffffffff8100cd90>] ? child_rip+0x0/0x20
> [    3.073356] Testing a saved backtrace.
> [    3.076666] The following trace is a kernel self test and not a bug!
> [    3.080000]  [<ffffffff81016e82>] save_stack_trace+0x2f/0x4c
> [    3.086711]  [<ffffffff81087c01>] backtrace_regression_test+0xe2/0x105
> [    3.093332]  [<ffffffff8100907d>] do_one_initcall+0x72/0x17f
> [    3.100038]  [<ffffffff8247f66c>] kernel_init+0x15f/0x1b5
> [    3.103332]  [<ffffffff8100cd9a>] child_rip+0xa/0x20
> [    3.106665]  [<ffffffffffffffff>] 0xffffffffffffffff
> [    3.109999] ====[ end of backtrace testing ]====
> [    3.113373] initcall backtrace_regression_test+0x0/0x105 returned 0 after 166015 usecs
> [    3.116667] calling  audit_init+0x0/0x153 @ 1
> [    3.119999] audit: initializing netlink socket (disabled)
> [    3.123398] type=2000 audit(1268788196.123:1): initialized
> [    3.126720] initcall audit_init+0x0/0x153 returned 0 after 6510 usecs
> [    3.130001] calling  audit_tree_init+0x0/0x49 @ 1
> [    3.133338] initcall audit_tree_init+0x0/0x49 returned 0 after 0 usecs
> [    3.136667] calling  hung_task_init+0x0/0x53 @ 1
> [    3.140105] initcall hung_task_init+0x0/0x53 returned 0 after 0 usecs
> [    3.143336] calling  rcu_torture_init+0x0/0x6b5 @ 1
> [    3.146684] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1
> [    3.150112] initcall rcu_torture_init+0x0/0x6b5 returned 0 after 3255 usecs
> [    3.153367] calling  utsname_sysctl_init+0x0/0x14 @ 1
> [    3.156683] initcall utsname_sysctl_init+0x0/0x14 returned 0 after 0 usecs
> [    3.160001] calling  ftrace_mod_cmd_init+0x0/0x12 @ 1
> [    3.163350] initcall ftrace_mod_cmd_init+0x0/0x12 returned 0 after 0 usecs
> [    3.166711] calling  init_events+0x0/0x64 @ 1
> [    3.170030] initcall init_events+0x0/0x64 returned 0 after 0 usecs
> [    3.173335] calling  init_sched_switch_trace+0x0/0x12 @ 1
> [    3.190032] Testing tracer sched_switch: PASSED
> [    3.327396] initcall init_sched_switch_trace+0x0/0x12 returned 0 after 143228 usecs
> [    3.330001] calling  init_stack_trace+0x0/0x12 @ 1
> [    3.343341] Testing tracer sysprof: .. no entries found ..FAILED!
> [    3.459513] initcall init_stack_trace+0x0/0x12 returned -1 after 120442 usecs
> [    3.460001] initcall init_stack_trace+0x0/0x12 returned with error code -1 
> [    3.463333] calling  init_function_trace+0x0/0x3e @ 1
> [    3.476680] Testing tracer function: 
> [    3.493420] BUG: unable to handle kernel NULL pointer dereference at 0000000000000789
> [    3.496660] IP: [<ffffffff81044c94>] push_rt_task+0x16/0x1ea
> [    3.496660] PGD 0 
> [    3.496660] Oops: 0000 [#1] PREEMPT SMP 
> [    3.500321] last sysfs file: 
> [    3.500321] CPU 1 
> [    3.500321] Pid: 36, comm: rcu_torture_fak Not tainted 2.6.32-dirty #116 
> [    3.500321] RIP: 0010:[<ffffffff81044c94>]  [<ffffffff81044c94>] push_rt_task+0x16/0x1ea
> [    3.500321] RSP: 0018:ffff88003cf6bda0  EFLAGS: 00010286
> [    3.500321] RAX: 00000000ffffffff RBX: 0000000000000001 RCX: 0000000000000001
> [    3.500321] RDX: 000000000000000a RSI: ffffffff8139782f RDI: 0000000000000001
> [    3.500321] RBP: ffff88003cf6bde0 R08: 0000000000000000 R09: ffff88003cf6bd20
> [    3.500321] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000e3b75
> [    3.500321] R13: 0000000000000001 R14: ffff88003cf6bfd8 R15: 00000000933c6a63
> [    3.500321] FS:  0000000000000000(0000) GS:ffff880009800000(0000) knlGS:0000000000000000
> [    3.500321] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [    3.500321] CR2: 0000000000000789 CR3: 0000000001001000 CR4: 00000000000006a0
> [    3.500321] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    3.500321] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [    3.500321] Process rcu_torture_fak (pid: 36, threadinfo ffff88003cf6a000, task ffff88003cf0d900)
> [    3.600086] .. no entries found ..FAILED!
> [    3.600100] initcall init_function_trace+0x0/0x3e returned -1 after 130208 usecs
> [    3.600106] initcall init_function_trace+0x0/0x3e returned with error code -1 
> [    3.600112] calling  init_irqsoff_tracer+0x0/0x14 @ 1
> [    3.500321] Stack:
> [    3.500321]  ffffffff8105bd68 ffff88003cf6bde0 00000000fffea488 0000000000000001
> [    3.500321] <0> 00000000000e3b75 0000000000000001 ffff88003cf6bfd8 00000000933c6a63
> [    3.500321] <0> ffff88003cf6be10 ffffffff81044f33 ffff88003cf6be10 ffffffff81040afe
> [    3.500321] Call Trace:
> [    3.500321]  [<ffffffff8105bd68>] ? del_timer_sync+0x0/0x8b
> [    3.500321]  [<ffffffff81044f33>] post_schedule_rt+0x19/0x22
> [    3.500321]  [<ffffffff81040afe>] ? sub_preempt_count+0xe/0x4d
> [    3.500321]  [<ffffffff813978fc>] delay_tsc+0x5f/0xd3
> [    3.500321]  [<ffffffff8109c8ce>] ? rcu_torture_fakewriter+0x0/0xf7
> [    3.500321]  [<ffffffff8139782f>] __delay+0xf/0x11
> [    3.500321]  [<ffffffff81397870>] __const_udelay+0x3f/0x41
> [    3.500321]  [<ffffffff81397887>] __udelay+0x15/0x17
> [    3.500321]  [<ffffffff8109c953>] rcu_torture_fakewriter+0x85/0xf7
> [    3.500321]  [<ffffffff8106b58e>] kthread+0x7f/0x87
> [    3.500321]  [<ffffffff8100cd9a>] child_rip+0xa/0x20
> [    3.500321]  [<ffffffff81040ab9>] ? finish_task_switch+0x74/0xab
> [    3.500321]  [<ffffffff8100c700>] ? restore_args+0x0/0x30
> [    3.500321]  [<ffffffff8106b50f>] ? kthread+0x0/0x87
> [    3.500321]  [<ffffffff8100cd90>] ? child_rip+0x0/0x20
> [    3.500321] Code: 20 83 f8 63 7f 0d 39 87 70 07 00 00 7e 05 e8 fa fd ff ff c9 c3 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 18 e8 bc 6d fc ff <83> bf 88 07 00 00 00 49 89 fc 0f 84 96 01 00 00 e8 5a 1b ff ff 

Other than the fact that there is a NULL pointer exception, this
stack trace looks normal.  :-/

rcu_torture_fakewriter() is as follows:

static int
rcu_torture_fakewriter(void *arg)
{
	DEFINE_RCU_RANDOM(rand);

	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task started");
	set_user_nice(current, 19);

	do {
		schedule_timeout_uninterruptible(1 + rcu_random(&rand)%10);
		udelay(rcu_random(&rand) & 0x3ff);
		cur_ops->sync();
		rcu_stutter_wait("rcu_torture_fakewriter");
	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);

	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task stopping");
	rcutorture_shutdown_absorb("rcu_torture_fakewriter");
	while (!kthread_should_stop())
		schedule_timeout_uninterruptible(1);
	return 0;
}

And we are in the udelay().

> [    3.500321] RIP  [<ffffffff81044c94>] push_rt_task+0x16/0x1ea
> [    3.500321]  RSP <ffff88003cf6bda0>
> [    3.500321] CR2: 0000000000000789
> [    3.770017] ---[ end trace 5a5d197966b56a2e ]---
> [    3.773984] Kernel panic - not syncing: Fatal exception
> [    3.779998] Pid: 36, comm: rcu_torture_fak Tainted: G      D    2.6.32-dirty #116
> [    3.786663] Call Trace:
> [    3.789113]  [<ffffffff81a0f0d9>] panic+0x84/0x13c
> [    3.793334]  [<ffffffff8100fcc3>] oops_end+0xaf/0xbf
> [    3.800001]  [<ffffffff81029b29>] no_context+0x1f3/0x202
> [    3.803334]  [<ffffffff8107b61c>] ? trace_hardirqs_off+0xd/0xf
> [    3.810001]  [<ffffffff8100ba96>] ? ftrace_call+0x5/0x2b
> [    3.813333]  [<ffffffff81029cbd>] __bad_area_nosemaphore+0x185/0x1a8
> [    3.820000]  [<ffffffff8100ba96>] ? ftrace_call+0x5/0x2b
> [    3.826667]  [<ffffffff81029cf3>] bad_area_nosemaphore+0x13/0x15
> [    3.833333]  [<ffffffff81029f9f>] do_page_fault+0x138/0x284
> [    3.836668]  [<ffffffff81a1292f>] page_fault+0x1f/0x30
> [    3.843333]  [<ffffffff8139782f>] ? __delay+0xf/0x11
> [    3.846666]  [<ffffffff81044c94>] ? push_rt_task+0x16/0x1ea
> [    3.853333]  [<ffffffff8105bd68>] ? del_timer_sync+0x0/0x8b
> [    3.860000]  [<ffffffff81044f33>] post_schedule_rt+0x19/0x22
> [    3.866666]  [<ffffffff81040afe>] ? sub_preempt_count+0xe/0x4d
> [    3.870000]  [<ffffffff813978fc>] delay_tsc+0x5f/0xd3
> [    3.876667]  [<ffffffff8109c8ce>] ? rcu_torture_fakewriter+0x0/0xf7
> [    3.883333]  [<ffffffff8139782f>] __delay+0xf/0x11
> [    3.886666]  [<ffffffff81397870>] __const_udelay+0x3f/0x41
> [    3.893333]  [<ffffffff81397887>] __udelay+0x15/0x17
> [    3.896667]  [<ffffffff8109c953>] rcu_torture_fakewriter+0x85/0xf7
> [    3.903333]  [<ffffffff8106b58e>] kthread+0x7f/0x87
> [    3.910000]  [<ffffffff8100cd9a>] child_rip+0xa/0x20
> [    3.913333]  [<ffffffff81040ab9>] ? finish_task_switch+0x74/0xab
> [    3.919999]  [<ffffffff8100c700>] ? restore_args+0x0/0x30
> [    3.926667]  [<ffffffff8106b50f>] ? kthread+0x0/0x87
> [    3.929999]  [<ffffffff8100cd90>] ? child_rip+0x0/0x20
> [    3.936671] Rebooting in 1 seconds..Press any key to enter the menu
