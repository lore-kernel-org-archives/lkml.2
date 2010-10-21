Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab0JULKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 07:10:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39385 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755826Ab0JULJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 07:09:58 -0400
Date: Thu, 21 Oct 2010 13:09:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Baron <jbaron@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for
 trace_sched_wakeup.c
Message-ID: <20101021110925.GA27219@elte.hu>
References: <1287508282.16971.386.camel@gandalf.stny.rr.com>
 <20101019184111.GA17266@elte.hu>
 <20101020154045.GA18353@elte.hu>
 <20101020164324.GC7348@redhat.com>
 <20101020183329.GA12666@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101020183329.GA12666@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Jason Baron <jbaron@redhat.com> wrote:
> 
> > [...] Do we always fail after "Testing all events:" is printed? [...]
> 
> Yes, in all cases i checked. Sometimes it's an oops.

Such as this one:

[    6.724449] Testing event kmalloc_node: OK
[    6.744459] Testing event kmem_cache_alloc_node: 
[    6.749111] BUG: unable to handle kernel paging request at ffffffff
[    6.752000] IP: [<f6425f7c>] 0xf6425f7c
[    6.752000] *pde = 01384067 *pte = 00000000 
[    6.752000] Oops: 0002 [#1] PREEMPT SMP 
[    6.752000] last sysfs file: 
[    6.752000] Modules linked in:
[    6.752000] 
[    6.752000] Pid: 2, comm: kthreadd Not tainted 2.6.36-rc8-tip+ #50831 /
[    6.752000] EIP: 0060:[<f6425f7c>] EFLAGS: 00010282 CPU: 0
[    6.752000] EIP is at 0xf6425f7c
[    6.752000] EAX: ffffffff EBX: c1021c4f ECX: 00000001 EDX: 00000000
[    6.752000] ESI: f6425f7c EDI: fffffff4 EBP: f640c000 ESP: f6425ee4
[    6.752000]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[    6.752000] Process kthreadd (pid: 2, ti=f6424000 task=f640c000 task.ti=f6424000)
[    6.752000] Stack:
[    6.752000]  c1021c4f f640c02c 00800711 00000000 00000000 00000000 f6425f7c f6809880
[    6.752000] <0> f6425f7c 00000000 00000000 f6425f7c c1022a54 00000000 00000000 00000000
[    6.752000] <0> 00000000 00800711 00000000 00000000 00000000 c101d94a f6809880 c131f3a0
[    6.752000] Call Trace:
[    6.752000]  [<c1021c4f>] ? copy_process+0xa1/0xd6d
[    6.752000]  [<c1022a54>] ? do_fork+0x139/0x2ca
[    6.752000]  [<c101d94a>] ? dequeue_task+0xb9/0xc8
[    6.752000]  [<c1245597>] ? schedule+0x821/0x84b
[    6.752000]  [<c1038079>] ? kthread+0x0/0x68
[    6.752000]  [<c1007930>] ? kernel_thread+0x77/0x7f
[    6.752000]  [<c1038079>] ? kthread+0x0/0x68
[    6.752000]  [<c1002cbc>] ? kernel_thread_helper+0x0/0x10
[    6.752000]  [<c1038172>] ? kthreadd+0x91/0xc7
[    6.752000]  [<c10380e1>] ? kthreadd+0x0/0xc7
[    6.752000]  [<c1002cc2>] ? kernel_thread_helper+0x6/0x10
[    6.752000] Code: 98 80 f6 00 c0 40 f6 a9 37 61 f9 11 07 80 00 79 80 03 c1 c0 5f 42 f6 7c 5f 42 f6 30 79 00 c1 00 00 00 00 00 00 00 00 00 00 00 00 <00> 00 00 00 00 00 00 00 00 00 00 00 79 80 03 c1 70 3f 42 f6 00 
[    6.752000] EIP: [<f6425f7c>] 0xf6425f7c SS:ESP 0068:f6425ee4
[    6.752000] CR2: 00000000ffffffff
[    6.752000] ---[ end trace 6000cf675d3eddec ]---

(captured two days ago)

Full bootlog is attached below.

Thanks,

	Ingo

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.36-rc8-tip+ (mingo@sirius) (gcc version 4.4.4 20100514 (Red Hat 4.4.4-3) (GCC) ) #50831 SMP PREEMPT Tue Oct 19 09:15:35 CEST 2010
[    0.000000] CPU: vendor_id 'AuthenticAMD' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x3fff0 max_arch_pfn = 0x100000
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [c00f5680] f5680
[    0.000000]   mpc: f1400-f152c
[    0.000000] initial memory mapped : 0 - 01800000
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 17fb000-1800000
[    0.000000] 135MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0003fff0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003fff0
[    0.000000] On node 0 totalpages: 262015
[    0.000000] free_area_init_node: node 0, pgdat c1335e80, node_mem_map f6ffd200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 272 pages used for memmap
[    0.000000]   HighMem zone: 34530 pages, LIFO batch:7
[    0.000000] Using APIC driver default
[    0.000000] SFI: Simple Firmware Interface v0.81 http://simplefirmware.org
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000]   mpc: f1400-f152c
[    0.000000] MPTABLE: OEM ID: OEM00000
[    0.000000] MPTABLE: Product ID: PROD00000000
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] Bus #0 is PCI   
[    0.000000] Bus #1 is PCI   
[    0.000000] Bus #2 is PCI   
[    0.000000] Bus #3 is PCI   
[    0.000000] Bus #4 is PCI   
[    0.000000] Bus #5 is PCI   
[    0.000000] Bus #6 is ISA   
[    0.000000] I/O APIC #2 Version 17 at 0xFEC00000.
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] Int: type 0, pol 3, trig 3, bus 00, IRQ 28, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 3, trig 3, bus 00, IRQ 10, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 3, trig 3, bus 01, IRQ 00, APIC ID 2, APIC INT 05
[    0.000000] Int: type 0, pol 3, trig 3, bus 05, IRQ 1c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 3, pol 0, trig 0, bus 06, IRQ 00, APIC ID 2, APIC INT 00
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 1, trig 1, bus 06, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Lint: type 3, pol 0, trig 0, bus 00, IRQ 00, APIC ID ff, APIC LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 00, IRQ 00, APIC ID ff, APIC LINT 01
[    0.000000] Processors: 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:a0000000)
[    0.000000] converting mcount calls to 0f 1f 44 00 00
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 16 pages/cpu @f6800000 s41216 r0 d24320 u2097152
[    0.000000] pcpu-alloc: s41216 r0 d24320 u2097152 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 259967
[    0.000000] Kernel command line: root=/dev/sda1 earlyprintk=ttyS0,115200 console=ttyS0,115200 debug initcall_debug enforcing=0 apic=verbose ignore_loglevel sysrq_always_enabled selinux=0 nmi_watchdog=0 3 panic=1 3
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000377fe:0003fff0)
[    0.000000] Memory: 1034088k/1048512k available (2336k kernel code, 13972k reserved, 977k data, 256k init, 139208k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff17000 - 0xfffff000   ( 928 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc133d000 - 0xc137d000   ( 256 kB)
[    0.000000]       .data : 0xc1248211 - 0xc133c6c0   ( 977 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1248211   (2336 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] 	RCU debugfs-based tracing is enabled.
[    0.000000] 	Hierarchical RCU autobalancing is disabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:512
[    0.000000] CPU 0 irqstacks, hard=f6800000 soft=f6802000
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled, bootconsole disabled
[    0.000000] console [ttyS0] enabled, bootconsole disabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2010.152 MHz processor.
[    0.012004] Calibrating delay loop (skipped), value calculated using timer frequency.. 4020.30 BogoMIPS (lpj=8040608)
[    0.020003] pid_max: default: 4096 minimum: 301
[    0.024012] Security Framework initialized
[    0.028007] TOMOYO Linux initialized
[    0.032010] AppArmor: AppArmor disabled by boot time parameter
[    0.036007] Mount-cache hash table entries: 512
[    0.040113] Initializing cgroup subsys debug
[    0.044003] Initializing cgroup subsys ns
[    0.048004] Initializing cgroup subsys devices
[    0.052003] Initializing cgroup subsys freezer
[    0.056024] Performance Events: 
[    0.060300] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.064006] enabled ExtINT on CPU#0
[    0.068048] ExtINT not setup in hardware but reported by MP table
[    0.072085] ENABLING IO-APIC IRQs
[    0.076003] init IO_APIC IRQs
[    0.080003]  2-0 (apicid-pin) not connected
[    0.084006] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    0.088007] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
[    0.092008] IOAPIC[0]: Set routing entry (2-3 -> 0x29 -> IRQ 27 Mode:1 Active:1)
[    0.096000] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    0.096000] IOAPIC[0]: Set routing entry (2-5 -> 0x41 -> IRQ 29 Mode:1 Active:1)
[    0.096000] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[    0.096000] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    0.096000] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    0.096000] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:0 Active:0)
[    0.096000] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
[    0.096000] IOAPIC[0]: Set routing entry (2-11 -> 0x49 -> IRQ 35 Mode:1 Active:1)
[    0.096000] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    0.096000] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    0.096000] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
[    0.096000] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
[    0.096000]  2-16 2-17 2-18 2-19 2-20 2-21 2-22 2-23 (apicid-pin) not connected
[    0.096000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.096000] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.096000] ...trying to set up timer (IRQ0) through the 8259A ...
[    0.096000] ..... (found apic 0 pin 0) ...
[    0.136747] ....... works.
[    0.139452] CPU0: AuthenticAMD AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[    0.145238] Using local APIC timer interrupts.
[    0.145239] calibrating APIC timer ...
[    0.152000] ... lapic delta = 1256509
[    0.152000] ..... delta 1256509
[    0.152000] ..... mult: 53963277
[    0.152000] ..... calibration result: 804165
[    0.152000] ..... CPU clock speed is 2010.1658 MHz.
[    0.152000] ..... host bus clock speed is 201.0165 MHz.
[    0.152000] ... verify APIC timer
[    0.263679] ... jiffies delta = 25
[    0.264002] ... jiffies result ok
[    0.268013] calling  migration_init+0x0/0x57 @ 1
[    0.272005] initcall migration_init+0x0/0x57 returned 0 after 0 usecs
[    0.276003] calling  spawn_ksoftirqd+0x0/0x3f @ 1
[    0.284006] initcall spawn_ksoftirqd+0x0/0x3f returned 0 after 3906 usecs
[    0.288004] calling  init_workqueues+0x0/0x291 @ 1
[    0.296034] initcall init_workqueues+0x0/0x291 returned 0 after 3906 usecs
[    0.300003] calling  init_jump_label_module+0x0/0xa @ 1
[    0.304006] initcall init_jump_label_module+0x0/0xa returned 0 after 0 usecs
[    0.308003] calling  init_jump_label+0x0/0xd3 @ 1
[    0.312121] initcall init_jump_label+0x0/0xd3 returned 0 after 0 usecs
[    0.316005] calling  init_call_single_data+0x0/0x62 @ 1
[    0.320004] initcall init_call_single_data+0x0/0x62 returned 0 after 0 usecs
[    0.324003] calling  cpu_stop_init+0x0/0x81 @ 1
[    0.332008] initcall cpu_stop_init+0x0/0x81 returned 0 after 3906 usecs
[    0.336004] calling  tracer_alloc_buffers+0x0/0x174 @ 1
[    0.340024] Testing tracer nop: PASSED
[    0.344722] initcall tracer_alloc_buffers+0x0/0x174 returned 0 after 3906 usecs
[    0.348003] calling  init_trace_printk+0x0/0xa @ 1
[    0.352003] initcall init_trace_printk+0x0/0xa returned 0 after 0 usecs
[    0.368016] CPU 1 irqstacks, hard=f6a00000 soft=f6a02000
[    0.372009] Booting Node   0, Processors  #1 Ok.
[    0.016000] Initializing CPU#1
[    0.016000] masked ExtINT on CPU#1
[    0.468050] Brought up 2 CPUs
[    0.472003] Total of 2 processors activated (8041.16 BogoMIPS).
[    0.476110] devtmpfs: initialized
[    0.480207] calling  init_mmap_min_addr+0x0/0xd @ 1
[    0.484004] initcall init_mmap_min_addr+0x0/0xd returned 0 after 0 usecs
[    0.488003] calling  net_ns_init+0x0/0x15b @ 1
[    0.492005] initcall net_ns_init+0x0/0x15b returned 0 after 0 usecs
[    0.496004] calling  pci_reboot_init+0x0/0x3 @ 1
[    0.500003] initcall pci_reboot_init+0x0/0x3 returned 0 after 0 usecs
[    0.504003] calling  reboot_init+0x0/0x3 @ 1
[    0.508003] initcall reboot_init+0x0/0x3 returned 0 after 0 usecs
[    0.512003] calling  init_smp_flush+0x0/0x1a @ 1
[    0.516003] initcall init_smp_flush+0x0/0x1a returned 0 after 0 usecs
[    0.520003] calling  sysctl_init+0x0/0xf @ 1
[    0.524006] initcall sysctl_init+0x0/0xf returned 0 after 0 usecs
[    0.528003] calling  ksysfs_init+0x0/0x70 @ 1
[    0.532012] initcall ksysfs_init+0x0/0x70 returned 0 after 0 usecs
[    0.536003] calling  init_jiffies_clocksource+0x0/0xa @ 1
[    0.540005] initcall init_jiffies_clocksource+0x0/0xa returned 0 after 0 usecs
[    0.544003] calling  init_hw_breakpoint+0x0/0xbe @ 1
[    0.548008] initcall init_hw_breakpoint+0x0/0xbe returned 0 after 0 usecs
[    0.552003] calling  init_zero_pfn+0x0/0x10 @ 1
[    0.556003] initcall init_zero_pfn+0x0/0x10 returned 0 after 0 usecs
[    0.560004] calling  fsnotify_init+0x0/0x1b @ 1
[    0.564005] initcall fsnotify_init+0x0/0x1b returned 0 after 0 usecs
[    0.568003] calling  filelock_init+0x0/0x25 @ 1
[    0.572004] initcall filelock_init+0x0/0x25 returned 0 after 0 usecs
[    0.576003] calling  init_script_binfmt+0x0/0xc @ 1
[    0.580004] initcall init_script_binfmt+0x0/0xc returned 0 after 0 usecs
[    0.584003] calling  init_elf_binfmt+0x0/0xc @ 1
[    0.588004] initcall init_elf_binfmt+0x0/0xc returned 0 after 0 usecs
[    0.592003] calling  debugfs_init+0x0/0x46 @ 1
[    0.596006] initcall debugfs_init+0x0/0x46 returned 0 after 0 usecs
[    0.600003] calling  securityfs_init+0x0/0x3d @ 1
[    0.604006] initcall securityfs_init+0x0/0x3d returned 0 after 0 usecs
[    0.608003] calling  random32_init+0x0/0xa4 @ 1
[    0.612004] initcall random32_init+0x0/0xa4 returned 0 after 0 usecs
[    0.616003] calling  test_atomic64+0x0/0x5d6 @ 1
[    0.620005] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.624003] initcall test_atomic64+0x0/0x5d6 returned 0 after 3906 usecs
[    0.628003] calling  sfi_sysfs_init+0x0/0xb3 @ 1
[    0.632003] initcall sfi_sysfs_init+0x0/0xb3 returned 0 after 0 usecs
[    0.636003] calling  cpuidle_init+0x0/0x2e @ 1
[    0.640007] initcall cpuidle_init+0x0/0x2e returned 0 after 0 usecs
[    0.644003] calling  sock_init+0x0/0x4f @ 1
[    0.648018] initcall sock_init+0x0/0x4f returned 0 after 0 usecs
[    0.652003] calling  netpoll_init+0x0/0x2b @ 1
[    0.656003] initcall netpoll_init+0x0/0x2b returned 0 after 0 usecs
[    0.660003] calling  netlink_proto_init+0x0/0x14b @ 1
[    0.664009] NET: Registered protocol family 16
[    0.668013] initcall netlink_proto_init+0x0/0x14b returned 0 after 3906 usecs
[    0.672004] calling  olpc_init+0x0/0x210 @ 1
[    0.676004] initcall olpc_init+0x0/0x210 returned 0 after 0 usecs
[    0.680003] calling  bdi_class_init+0x0/0x3c @ 1
[    0.684024] initcall bdi_class_init+0x0/0x3c returned 0 after 0 usecs
[    0.688003] calling  kobject_uevent_init+0x0/0x19 @ 1
[    0.692007] initcall kobject_uevent_init+0x0/0x19 returned 0 after 0 usecs
[    0.696003] calling  gpiolib_sysfs_init+0x0/0x70 @ 1
[    0.700016] initcall gpiolib_sysfs_init+0x0/0x70 returned 0 after 0 usecs
[    0.704003] calling  pcibus_class_init+0x0/0xf @ 1
[    0.708010] initcall pcibus_class_init+0x0/0xf returned 0 after 0 usecs
[    0.712003] calling  pci_driver_init+0x0/0xa @ 1
[    0.716019] initcall pci_driver_init+0x0/0xa returned 0 after 0 usecs
[    0.720003] calling  tty_class_init+0x0/0x2b @ 1
[    0.724011] initcall tty_class_init+0x0/0x2b returned 0 after 0 usecs
[    0.728003] calling  vtconsole_class_init+0x0/0x9b @ 1
[    0.732028] initcall vtconsole_class_init+0x0/0x9b returned 0 after 0 usecs
[    0.736003] calling  amd_postcore_init+0x0/0x67 @ 1
[    0.740003] initcall amd_postcore_init+0x0/0x67 returned 0 after 0 usecs
[    0.744003] calling  arch_kdebugfs_init+0x0/0x1a @ 1
[    0.748006] initcall arch_kdebugfs_init+0x0/0x1a returned 0 after 0 usecs
[    0.752003] calling  init_pit_clocksource+0x0/0x9d @ 1
[    0.756003] initcall init_pit_clocksource+0x0/0x9d returned 0 after 0 usecs
[    0.760003] calling  kdump_buf_page_init+0x0/0x30 @ 1
[    0.764004] initcall kdump_buf_page_init+0x0/0x30 returned 0 after 0 usecs
[    0.768003] calling  dma_bus_init+0x0/0x2d @ 1
[    0.772011] initcall dma_bus_init+0x0/0x2d returned 0 after 0 usecs
[    0.776004] calling  dma_channel_table_init+0x0/0xc9 @ 1
[    0.780009] initcall dma_channel_table_init+0x0/0xc9 returned 0 after 0 usecs
[    0.784003] calling  pci_arch_init+0x0/0x5c @ 1
[    0.795465] PCI: PCI BIOS revision 3.00 entry at 0xf21d0, last bus=5
[    0.796002] PCI: Using configuration type 1 for base access
[    0.800004] initcall pci_arch_init+0x0/0x5c returned 0 after 11718 usecs
[    0.804003] calling  topology_init+0x0/0x32 @ 1
[    0.808020] initcall topology_init+0x0/0x32 returned 0 after 0 usecs
[    0.812003] calling  param_sysfs_init+0x0/0x1a0 @ 1
[    0.816736] initcall param_sysfs_init+0x0/0x1a0 returned 0 after 0 usecs
[    0.820004] calling  pm_sysrq_init+0x0/0x12 @ 1
[    0.824004] initcall pm_sysrq_init+0x0/0x12 returned 0 after 0 usecs
[    0.828003] calling  default_bdi_init+0x0/0x89 @ 1
[    0.832071] initcall default_bdi_init+0x0/0x89 returned 0 after 0 usecs
[    0.836004] calling  init_bio+0x0/0xbd @ 1
[    0.840004] bio: create slab <bio-0> at 0
[    0.844007] initcall init_bio+0x0/0xbd returned 0 after 3906 usecs
[    0.848003] calling  fsnotify_notification_init+0x0/0x72 @ 1
[    0.852005] initcall fsnotify_notification_init+0x0/0x72 returned 0 after 0 usecs
[    0.856003] calling  cryptomgr_init+0x0/0xa @ 1
[    0.860003] initcall cryptomgr_init+0x0/0xa returned 0 after 0 usecs
[    0.864003] calling  blk_settings_init+0x0/0x19 @ 1
[    0.868003] initcall blk_settings_init+0x0/0x19 returned 0 after 0 usecs
[    0.872003] calling  blk_ioc_init+0x0/0x22 @ 1
[    0.876003] initcall blk_ioc_init+0x0/0x22 returned 0 after 0 usecs
[    0.880003] calling  blk_softirq_init+0x0/0x50 @ 1
[    0.884004] initcall blk_softirq_init+0x0/0x50 returned 0 after 0 usecs
[    0.888003] calling  blk_iopoll_setup+0x0/0x50 @ 1
[    0.892003] initcall blk_iopoll_setup+0x0/0x50 returned 0 after 0 usecs
[    0.896003] calling  genhd_device_init+0x0/0x5d @ 1
[    0.900037] initcall genhd_device_init+0x0/0x5d returned 0 after 0 usecs
[    0.904004] calling  gpiolib_debugfs_init+0x0/0x1d @ 1
[    0.908007] initcall gpiolib_debugfs_init+0x0/0x1d returned 0 after 0 usecs
[    0.912003] calling  pci_slot_init+0x0/0x37 @ 1
[    0.916008] initcall pci_slot_init+0x0/0x37 returned 0 after 0 usecs
[    0.920003] calling  pnp_init+0x0/0xa @ 1
[    0.924015] initcall pnp_init+0x0/0xa returned 0 after 0 usecs
[    0.928003] calling  misc_init+0x0/0x95 @ 1
[    0.932014] initcall misc_init+0x0/0x95 returned 0 after 0 usecs
[    0.936003] calling  init_scsi+0x0/0x73 @ 1
[    0.940098] SCSI subsystem initialized
[    0.944004] initcall init_scsi+0x0/0x73 returned 0 after 3906 usecs
[    0.948003] calling  ata_init+0x0/0x281 @ 1
[    0.952023] libata version 3.00 loaded.
[    0.956004] initcall ata_init+0x0/0x281 returned 0 after 3906 usecs
[    0.960003] calling  phy_init+0x0/0x29 @ 1
[    0.964039] initcall phy_init+0x0/0x29 returned 0 after 0 usecs
[    0.968003] calling  usb_init+0x0/0x144 @ 1
[    0.972035] usbcore: registered new interface driver usbfs
[    0.976026] usbcore: registered new interface driver hub
[    0.980033] usbcore: registered new device driver usb
[    0.984004] initcall usb_init+0x0/0x144 returned 0 after 11718 usecs
[    0.988003] calling  serio_init+0x0/0x6c @ 1
[    0.992035] initcall serio_init+0x0/0x6c returned 0 after 0 usecs
[    0.996004] calling  input_init+0x0/0xde @ 1
[    1.000017] initcall input_init+0x0/0xde returned 0 after 0 usecs
[    1.004003] calling  pci_subsys_init+0x0/0x40 @ 1
[    1.008002] PCI: Probing PCI hardware
[    1.011662] PCI: Probing PCI hardware (bus 00)
[    1.012137] pci 0000:00:01.1: reg 10: [io  0xdc00-0xdc1f]
[    1.016015] pci 0000:00:01.1: reg 20: [io  0x4c00-0x4c3f]
[    1.020006] pci 0000:00:01.1: reg 24: [io  0x4c40-0x4c7f]
[    1.024012] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    1.028003] pci 0000:00:01.1: PME# disabled
[    1.032022] pci 0000:00:02.0: reg 10: [mem 0xda102000-0xda102fff]
[    1.036027] pci 0000:00:02.0: supports D1 D2
[    1.040004] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.044003] pci 0000:00:02.0: PME# disabled
[    1.048019] pci 0000:00:02.1: reg 10: [mem 0xfeb00000-0xfeb000ff]
[    1.052031] pci 0000:00:02.1: supports D1 D2
[    1.056002] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.060003] pci 0000:00:02.1: PME# disabled
[    1.064023] pci 0000:00:04.0: reg 10: [io  0xd400-0xd4ff]
[    1.068006] pci 0000:00:04.0: reg 14: [io  0xd800-0xd8ff]
[    1.072006] pci 0000:00:04.0: reg 18: [mem 0xda101000-0xda101fff]
[    1.076021] pci 0000:00:04.0: supports D1 D2
[    1.080029] pci 0000:00:06.0: reg 20: [io  0xf000-0xf00f]
[    1.084047] pci 0000:00:0a.0: reg 10: [mem 0xda100000-0xda100fff]
[    1.088006] pci 0000:00:0a.0: reg 14: [io  0xd000-0xd007]
[    1.092024] pci 0000:00:0a.0: supports D1 D2
[    1.096002] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.100003] pci 0000:00:0a.0: PME# disabled
[    1.104035] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.108003] pci 0000:00:0b.0: PME# disabled
[    1.112037] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.116003] pci 0000:00:0c.0: PME# disabled
[    1.120037] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.124003] pci 0000:00:0d.0: PME# disabled
[    1.128037] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.132003] pci 0000:00:0e.0: PME# disabled
[    1.136138] pci 0000:05:07.0: reg 10: [io  0xc000-0xc0ff]
[    1.140008] pci 0000:05:07.0: reg 14: [mem 0xda000000-0xda0000ff]
[    1.144038] pci 0000:05:07.0: supports D1 D2
[    1.148002] pci 0000:05:07.0: PME# supported from D1 D2 D3hot
[    1.152003] pci 0000:05:07.0: PME# disabled
[    1.156026] pci 0000:00:09.0: PCI bridge to [bus 05-05] (subtractive decode)
[    1.160003] pci 0000:00:09.0:   bridge window [io  0xc000-0xcfff]
[    1.164003] pci 0000:00:09.0:   bridge window [mem 0xda000000-0xda0fffff]
[    1.168004] pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.172003] pci 0000:00:09.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    1.176003] pci 0000:00:09.0:   bridge window [mem 0x00000000-0xffffffff] (subtractive decode)
[    1.180024] pci 0000:00:0b.0: PCI bridge to [bus 04-04]
[    1.184004] pci 0000:00:0b.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.188003] pci 0000:00:0b.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.192004] pci 0000:00:0b.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.196023] pci 0000:00:0c.0: PCI bridge to [bus 03-03]
[    1.200004] pci 0000:00:0c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.204003] pci 0000:00:0c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.208004] pci 0000:00:0c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.212023] pci 0000:00:0d.0: PCI bridge to [bus 02-02]
[    1.216004] pci 0000:00:0d.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.220003] pci 0000:00:0d.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.224004] pci 0000:00:0d.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.228038] pci 0000:01:00.0: reg 10: [mem 0xd0000000-0xd7ffffff pref]
[    1.232007] pci 0000:01:00.0: reg 14: [io  0xb000-0xb0ff]
[    1.236007] pci 0000:01:00.0: reg 18: [mem 0xd9000000-0xd900ffff]
[    1.240021] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.244016] pci 0000:01:00.0: supports D1 D2
[    1.248023] pci 0000:01:00.1: reg 10: [mem 0xd9010000-0xd901ffff]
[    1.252042] pci 0000:01:00.1: supports D1 D2
[    1.256011] pci 0000:00:0e.0: PCI bridge to [bus 01-01]
[    1.260004] pci 0000:00:0e.0:   bridge window [io  0xb000-0xbfff]
[    1.264003] pci 0000:00:0e.0:   bridge window [mem 0xd8000000-0xd9ffffff]
[    1.268004] pci 0000:00:0e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
[    1.272837] pci 0000:00:00.0: default IRQ router [10de:005e]
[    1.276018] PCI: pci_cache_line_size set to 64 bytes
[    1.280059] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
[    1.284003] reserve RAM buffer: 000000003fff0000 - 000000003fffffff 
[    1.288005] initcall pci_subsys_init+0x0/0x40 returned 0 after 273437 usecs
[    1.292003] calling  proto_init+0x0/0xa @ 1
[    1.296004] initcall proto_init+0x0/0xa returned 0 after 0 usecs
[    1.300003] calling  net_dev_init+0x0/0x16f @ 1
[    1.308059] initcall net_dev_init+0x0/0x16f returned 0 after 3906 usecs
[    1.312003] calling  neigh_init+0x0/0x65 @ 1
[    1.316003] initcall neigh_init+0x0/0x65 returned 0 after 0 usecs
[    1.320003] calling  fib_rules_init+0x0/0x93 @ 1
[    1.324004] initcall fib_rules_init+0x0/0x93 returned 0 after 0 usecs
[    1.328003] calling  genl_init+0x0/0x6a @ 1
[    1.332014] initcall genl_init+0x0/0x6a returned 0 after 0 usecs
[    1.336003] calling  cipso_v4_init+0x0/0x4f @ 1
[    1.340005] initcall cipso_v4_init+0x0/0x4f returned 0 after 0 usecs
[    1.344003] calling  netlbl_init+0x0/0x6a @ 1
[    1.348002] NetLabel: Initializing
[    1.352002] NetLabel:  domain hash size = 128
[    1.356002] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.360018] NetLabel:  unlabeled traffic allowed by default
[    1.364003] initcall netlbl_init+0x0/0x6a returned 0 after 15625 usecs
[    1.368003] calling  sysctl_init+0x0/0x37 @ 1
[    1.372004] initcall sysctl_init+0x0/0x37 returned 0 after 0 usecs
[    1.376003] calling  print_ICs+0x0/0x48e @ 1
[    1.380002] 
[    1.380003] printing PIC contents
[    1.384003] ... PIC  IMR: fffa
[    1.387057] ... PIC  IRR: 0001
[    1.388002] ... PIC  ISR: 0001
[    1.391053] ... PIC ELCR: 0828
[    1.392003] printing local APIC contents on CPU#0/0:
[    1.396000] ... APIC ID:      00000000 (0)
[    1.396000] ... APIC VERSION: 00040010
[    1.396000] ... APIC TASKPRI: 00000000 (00)
[    1.396000] ... APIC ARBPRI: 000000e0 (e0)
[    1.396000] ... APIC PROCPRI: 00000000
[    1.396000] ... APIC LDR: 01000000
[    1.396000] ... APIC DFR: ffffffff
[    1.396000] ... APIC SPIV: 000001ff
[    1.396000] ... APIC ISR field:
[    1.396000] 0000000000000000000000000000000000000000000000000000000000000000
[    1.396000] ... APIC TMR field:
[    1.396000] 0000000000000000000000000000000000000000000000000000000000000000
[    1.396000] ... APIC IRR field:
[    1.396000] 0000000000000000000000000000000000000000000000000000000000008000
[    1.396000] ... APIC ESR: 00000000
[    1.396000] ... APIC ICR: 000008fd
[    1.396000] ... APIC ICR2: 02000000
[    1.396000] ... APIC LVTT: 000200ef
[    1.396000] ... APIC LVTPC: 00010000
[    1.396000] ... APIC LVT0: 00010700
[    1.396000] ... APIC LVT1: 00000400
[    1.396000] ... APIC LVTERR: 000000fe
[    1.396000] ... APIC TMICT: 0000c454
[    1.396000] ... APIC TMCCT: 00000aa0
[    1.396000] ... APIC TDCR: 00000003
[    1.396000] 
[    1.396002] number of MP IRQ sources: 17.
[    1.400002] number of IO-APIC #2 registers: 24.
[    1.404002] testing the IO APIC.......................
[    1.408004] 
[    1.409497] IO APIC #2......
[    1.412002] .... register #00: 00000000
[    1.416002] .......    : physical APIC id: 00
[    1.420002] .......    : Delivery Type: 0
[    1.424002] .......    : LTS          : 0
[    1.428002] .... register #01: 00170011
[    1.432002] .......     : max redirection entries: 0017
[    1.436002] .......     : PRQ implemented: 0
[    1.440002] .......     : IO APIC version: 0011
[    1.444002] .... register #02: 00000000
[    1.448002] .......     : arbitration: 00
[    1.452001] .... IRQ redirection table:
[    1.456002]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    1.460004]  00 003 0    0    0   0   0    1    1    30
[    1.464004]  01 003 0    0    0   0   0    1    1    31
[    1.472004]  02 000 1    0    0   0   0    0    0    00
[    1.476004]  03 003 1    1    0   1   0    1    1    29
[    1.480004]  04 003 0    0    0   0   0    1    1    34
[    1.487232]  05 003 1    1    0   1   0    1    1    41
[    1.492004]  06 003 0    0    0   0   0    1    1    36
[    1.496004]  07 003 1    0    0   0   0    1    1    37
[    1.503232]  08 003 0    0    0   0   0    1    1    38
[    1.508004]  09 003 0    0    0   0   0    1    1    39
[    1.512004]  0a 003 0    0    0   0   0    1    1    3A
[    1.519231]  0b 003 1    1    0   1   0    1    1    49
[    1.524004]  0c 003 0    0    0   0   0    1    1    3C
[    1.528004]  0d 003 0    0    0   0   0    1    1    3D
[    1.532004]  0e 003 0    0    0   0   0    1    1    3E
[    1.540004]  0f 003 0    0    0   0   0    1    1    3F
[    1.540003] Clocksource tsc unstable (delta = 262786708 ns)
[    1.544004]  10 000 1    0    0   0   0    0    0    00
[    1.552004]  11 000 1    0    0   0   0    0    0    00
[    1.556004]  12 000 1    0    0   0   0    0    0    00
[    1.560004]  13 000 1    0    0   0   0    0    0    00
[    1.568004]  14 000 1    0    0   0   0    0    0    00
[    1.572004]  15 000 1    0    0   0   0    0    0    00
[    1.576004]  16 000 1    0    0   0   0    0    0    00
[    1.583232]  17 000 1    0    0   0   0    0    0    00
[    1.588002] IRQ to pin mappings:
[    1.592002] IRQ0 -> 0:0
[    1.594485] IRQ1 -> 0:1
[    1.596727] IRQ4 -> 0:4
[    1.599205] IRQ6 -> 0:6
[    1.600727] IRQ7 -> 0:7
[    1.604735] IRQ8 -> 0:8
[    1.607211] IRQ9 -> 0:9
[    1.608727] IRQ10 -> 0:10
[    1.612190] IRQ12 -> 0:12
[    1.614840] IRQ13 -> 0:13
[    1.616821] IRQ14 -> 0:14
[    1.620192] IRQ15 -> 0:15
[    1.622841] IRQ27 -> 0:3
[    1.624727] IRQ29 -> 0:5
[    1.628190] IRQ35 -> 0:11
[    1.630839] .................................... done.
[    1.632004] initcall print_ICs+0x0/0x48e returned 0 after 246093 usecs
[    1.636003] calling  clocksource_done_booting+0x0/0x4b @ 1
[    1.640005] initcall clocksource_done_booting+0x0/0x4b returned 0 after 0 usecs
[    1.644003] calling  rb_init_debugfs+0x0/0x25 @ 1
[    1.648010] initcall rb_init_debugfs+0x0/0x25 returned 0 after 0 usecs
[    1.652003] calling  tracer_init_debugfs+0x0/0x2c8 @ 1
[    1.656110] initcall tracer_init_debugfs+0x0/0x2c8 returned 0 after 0 usecs
[    1.660003] calling  init_trace_printk_function_export+0x0/0x26 @ 1
[    1.664006] initcall init_trace_printk_function_export+0x0/0x26 returned 0 after 0 usecs
[    1.668003] calling  event_trace_init+0x0/0x215 @ 1
[    1.676061] initcall event_trace_init+0x0/0x215 returned 0 after 3906 usecs
[    1.680005] calling  init_pipe_fs+0x0/0x39 @ 1
[    1.684021] initcall init_pipe_fs+0x0/0x39 returned 0 after 0 usecs
[    1.688004] calling  eventpoll_init+0x0/0xc6 @ 1
[    1.692005] initcall eventpoll_init+0x0/0xc6 returned 0 after 0 usecs
[    1.696004] calling  anon_inode_init+0x0/0xec @ 1
[    1.700013] initcall anon_inode_init+0x0/0xec returned 0 after 0 usecs
[    1.704003] calling  tomoyo_initerface_init+0x0/0x125 @ 1
[    1.708038] initcall tomoyo_initerface_init+0x0/0x125 returned 0 after 0 usecs
[    1.712003] calling  aa_create_aafs+0x0/0xd9 @ 1
[    1.716003] initcall aa_create_aafs+0x0/0xd9 returned 0 after 0 usecs
[    1.720003] calling  blk_scsi_ioctl_init+0x0/0x284 @ 1
[    1.724004] initcall blk_scsi_ioctl_init+0x0/0x284 returned 0 after 0 usecs
[    1.728003] calling  pnp_system_init+0x0/0xa @ 1
[    1.732026] initcall pnp_system_init+0x0/0xa returned 0 after 0 usecs
[    1.736003] calling  chr_dev_init+0x0/0xa5 @ 1
[    1.745103] initcall chr_dev_init+0x0/0xa5 returned 0 after 3906 usecs
[    1.748005] calling  pcibios_assign_resources+0x0/0x62 @ 1
[    1.752048] pci 0000:00:09.0: PCI bridge to [bus 05-05]
[    1.756003] pci 0000:00:09.0:   bridge window [io  0xc000-0xcfff]
[    1.760004] pci 0000:00:09.0:   bridge window [mem 0xda000000-0xda0fffff]
[    1.764003] pci 0000:00:09.0:   bridge window [mem pref disabled]
[    1.768004] pci 0000:00:0b.0: PCI bridge to [bus 04-04]
[    1.772002] pci 0000:00:0b.0:   bridge window [io  disabled]
[    1.776003] pci 0000:00:0b.0:   bridge window [mem disabled]
[    1.780003] pci 0000:00:0b.0:   bridge window [mem pref disabled]
[    1.784004] pci 0000:00:0c.0: PCI bridge to [bus 03-03]
[    1.788002] pci 0000:00:0c.0:   bridge window [io  disabled]
[    1.792003] pci 0000:00:0c.0:   bridge window [mem disabled]
[    1.796003] pci 0000:00:0c.0:   bridge window [mem pref disabled]
[    1.800004] pci 0000:00:0d.0: PCI bridge to [bus 02-02]
[    1.804002] pci 0000:00:0d.0:   bridge window [io  disabled]
[    1.808003] pci 0000:00:0d.0:   bridge window [mem disabled]
[    1.812003] pci 0000:00:0d.0:   bridge window [mem pref disabled]
[    1.816007] pci 0000:01:00.0: BAR 6: assigned [mem 0xd8000000-0xd801ffff pref]
[    1.820003] pci 0000:00:0e.0: PCI bridge to [bus 01-01]
[    1.824003] pci 0000:00:0e.0:   bridge window [io  0xb000-0xbfff]
[    1.828004] pci 0000:00:0e.0:   bridge window [mem 0xd8000000-0xd9ffffff]
[    1.832003] pci 0000:00:0e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
[    1.836009] pci 0000:00:09.0: setting latency timer to 64
[    1.840006] pci 0000:00:0b.0: setting latency timer to 64
[    1.844006] pci 0000:00:0c.0: setting latency timer to 64
[    1.848006] pci 0000:00:0d.0: setting latency timer to 64
[    1.852006] pci 0000:00:0e.0: setting latency timer to 64
[    1.856003] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    1.860003] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
[    1.864003] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    1.868003] pci_bus 0000:05: resource 1 [mem 0xda000000-0xda0fffff]
[    1.872002] pci_bus 0000:05: resource 4 [io  0x0000-0xffff]
[    1.876003] pci_bus 0000:05: resource 5 [mem 0x00000000-0xffffffff]
[    1.880003] pci_bus 0000:01: resource 0 [io  0xb000-0xbfff]
[    1.884003] pci_bus 0000:01: resource 1 [mem 0xd8000000-0xd9ffffff]
[    1.888003] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xd7ffffff 64bit pref]
[    1.892004] initcall pcibios_assign_resources+0x0/0x62 returned 0 after 136718 usecs
[    1.896003] calling  sysctl_core_init+0x0/0x28 @ 1
[    1.900008] initcall sysctl_core_init+0x0/0x28 returned 0 after 0 usecs
[    1.904003] calling  inet_init+0x0/0x1c1 @ 1
[    1.908012] NET: Registered protocol family 2
[    1.912030] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    1.916171] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.920701] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    1.924350] TCP: Hash tables configured (established 131072 bind 65536)
[    1.928003] TCP reno registered
[    1.931213] initcall inet_init+0x0/0x1c1 returned 0 after 19531 usecs
[    1.932004] calling  af_unix_init+0x0/0x41 @ 1
[    1.936003] NET: Registered protocol family 1
[    1.940007] initcall af_unix_init+0x0/0x41 returned 0 after 3906 usecs
[    1.944003] calling  populate_rootfs+0x0/0xdd @ 1
[    1.948084] initcall populate_rootfs+0x0/0xdd returned 0 after 0 usecs
[    1.952005] calling  pci_iommu_init+0x0/0x30 @ 1
[    1.956004] initcall pci_iommu_init+0x0/0x30 returned 0 after 0 usecs
[    1.960004] calling  i8259A_init_sysfs+0x0/0x27 @ 1
[    1.964032] initcall i8259A_init_sysfs+0x0/0x27 returned 0 after 0 usecs
[    1.968003] calling  sbf_init+0x0/0xd6 @ 1
[    1.972003] initcall sbf_init+0x0/0xd6 returned 0 after 0 usecs
[    1.976003] calling  i8237A_init_sysfs+0x0/0x19 @ 1
[    1.980020] initcall i8237A_init_sysfs+0x0/0x19 returned 0 after 0 usecs
[    1.984003] calling  add_rtc_cmos+0x0/0x69 @ 1
[    1.988023] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    1.992003] initcall add_rtc_cmos+0x0/0x69 returned 0 after 3906 usecs
[    1.996005] calling  cache_sysfs_init+0x0/0x51 @ 1
[    2.000004] initcall cache_sysfs_init+0x0/0x51 returned 0 after 0 usecs
[    2.004004] calling  ioapic_init_sysfs+0x0/0x80 @ 1
[    2.008021] initcall ioapic_init_sysfs+0x0/0x80 returned 0 after 0 usecs
[    2.012003] calling  add_pcspkr+0x0/0x28 @ 1
[    2.016018] initcall add_pcspkr+0x0/0x28 returned 0 after 0 usecs
[    2.020003] calling  proc_execdomains_init+0x0/0x1a @ 1
[    2.024006] initcall proc_execdomains_init+0x0/0x1a returned 0 after 0 usecs
[    2.028003] calling  ioresources_init+0x0/0x30 @ 1
[    2.032006] initcall ioresources_init+0x0/0x30 returned 0 after 0 usecs
[    2.036003] calling  uid_cache_init+0x0/0x72 @ 1
[    2.040004] initcall uid_cache_init+0x0/0x72 returned 0 after 0 usecs
[    2.044003] calling  init_posix_timers+0x0/0x149 @ 1
[    2.048004] initcall init_posix_timers+0x0/0x149 returned 0 after 0 usecs
[    2.052003] calling  init_posix_cpu_timers+0x0/0xc2 @ 1
[    2.056003] initcall init_posix_cpu_timers+0x0/0xc2 returned 0 after 0 usecs
[    2.060003] calling  nsproxy_cache_init+0x0/0x25 @ 1
[    2.064003] initcall nsproxy_cache_init+0x0/0x25 returned 0 after 0 usecs
[    2.068003] calling  create_proc_profile+0x0/0x186 @ 1
[    2.072003] initcall create_proc_profile+0x0/0x186 returned 0 after 0 usecs
[    2.076003] calling  timekeeping_init_device+0x0/0x19 @ 1
[    2.080025] initcall timekeeping_init_device+0x0/0x19 returned 0 after 0 usecs
[    2.084003] calling  init_clocksource_sysfs+0x0/0x3f @ 1
[    2.088023] initcall init_clocksource_sysfs+0x0/0x3f returned 0 after 0 usecs
[    2.092003] calling  init_timer_list_procfs+0x0/0x23 @ 1
[    2.096005] initcall init_timer_list_procfs+0x0/0x23 returned 0 after 0 usecs
[    2.100003] calling  futex_init+0x0/0x54 @ 1
[    2.104006] initcall futex_init+0x0/0x54 returned 0 after 0 usecs
[    2.108003] calling  proc_dma_init+0x0/0x1a @ 1
[    2.112005] initcall proc_dma_init+0x0/0x1a returned 0 after 0 usecs
[    2.116003] calling  proc_modules_init+0x0/0x1a @ 1
[    2.120005] initcall proc_modules_init+0x0/0x1a returned 0 after 0 usecs
[    2.124003] calling  kallsyms_init+0x0/0x1d @ 1
[    2.128005] initcall kallsyms_init+0x0/0x1d returned 0 after 0 usecs
[    2.132003] calling  crash_save_vmcoreinfo_init+0x0/0x341 @ 1
[    2.136026] initcall crash_save_vmcoreinfo_init+0x0/0x341 returned 0 after 0 usecs
[    2.140003] calling  crash_notes_memory_init+0x0/0x2d @ 1
[    2.144005] initcall crash_notes_memory_init+0x0/0x2d returned 0 after 0 usecs
[    2.148003] calling  audit_init+0x0/0x10a @ 1
[    2.152002] audit: initializing netlink socket (disabled)
[    2.156017] type=2000 audit(1287514719.156:1): initialized
[    2.160004] initcall audit_init+0x0/0x10a returned 0 after 7812 usecs
[    2.164003] calling  rcuclassic_trace_init+0x0/0xd7 @ 1
[    2.168027] initcall rcuclassic_trace_init+0x0/0xd7 returned 0 after 0 usecs
[    2.172003] calling  utsname_sysctl_init+0x0/0xd @ 1
[    2.176004] initcall utsname_sysctl_init+0x0/0xd returned 0 after 0 usecs
[    2.180005] calling  init_tracepoints+0x0/0xa @ 1
[    2.184004] initcall init_tracepoints+0x0/0xa returned 0 after 0 usecs
[    2.188003] calling  init_events+0x0/0x50 @ 1
[    2.192006] initcall init_events+0x0/0x50 returned 0 after 0 usecs
[    2.196003] calling  init_sched_switch_trace+0x0/0xa @ 1
[    2.212009] Testing tracer sched_switch: PASSED
[    2.352723] initcall init_sched_switch_trace+0x0/0xa returned 0 after 148437 usecs
[    2.360004] calling  init_irqsoff_tracer+0x0/0x21 @ 1
[    2.372003] Testing tracer irqsoff: PASSED
[    2.404004] Testing tracer preemptoff: PASSED
[    2.436004] Testing tracer preemptirqsoff: PASSED
[    2.464721] initcall init_irqsoff_tracer+0x0/0x21 returned 0 after 97656 usecs
[    2.468003] calling  init_wakeup_tracer+0x0/0x19 @ 1
[    2.484004] Testing tracer wakeup: PASSED
[    2.828010] Testing tracer wakeup_rt: PASSED
[    3.164720] initcall init_wakeup_tracer+0x0/0x19 returned 0 after 671875 usecs
[    3.168003] calling  init_mmio_trace+0x0/0xa @ 1
[    3.176007] initcall init_mmio_trace+0x0/0xa returned 0 after 0 usecs
[    3.180004] calling  init_per_zone_wmark_min+0x0/0x55 @ 1
[    3.188042] initcall init_per_zone_wmark_min+0x0/0x55 returned 0 after 0 usecs
[    3.192003] calling  kswapd_init+0x0/0x19 @ 1
[    3.200045] initcall kswapd_init+0x0/0x19 returned 0 after 0 usecs
[    3.204003] calling  setup_vmstat+0x0/0xa4 @ 1
[    3.208017] initcall setup_vmstat+0x0/0xa4 returned 0 after 0 usecs
[    3.216007] calling  mm_sysfs_init+0x0/0x1e @ 1
[    3.220009] initcall mm_sysfs_init+0x0/0x1e returned 0 after 0 usecs
[    3.224003] calling  proc_vmalloc_init+0x0/0x1d @ 1
[    3.232005] initcall proc_vmalloc_init+0x0/0x1d returned 0 after 0 usecs
[    3.236003] calling  init_emergency_pool+0x0/0x77 @ 1
[    3.244018] highmem bounce pool size: 64 pages
[    3.248004] initcall init_emergency_pool+0x0/0x77 returned 0 after 3906 usecs
[    3.256003] calling  hugetlb_init+0x0/0x2f6 @ 1
[    3.260003] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    3.264011] initcall hugetlb_init+0x0/0x2f6 returned 0 after 3906 usecs
[    3.272003] calling  ksm_init+0x0/0x121 @ 1
[    3.277768] initcall ksm_init+0x0/0x121 returned 0 after 0 usecs
[    3.280003] calling  fcntl_init+0x0/0x22 @ 1
[    3.288008] initcall fcntl_init+0x0/0x22 returned 0 after 0 usecs
[    3.292004] calling  proc_filesystems_init+0x0/0x1a @ 1
[    3.296015] initcall proc_filesystems_init+0x0/0x1a returned 0 after 0 usecs
[    3.304003] calling  fsnotify_mark_init+0x0/0x2d @ 1
[    3.311409] initcall fsnotify_mark_init+0x0/0x2d returned 0 after 0 usecs
[    3.316006] calling  dnotify_init+0x0/0x66 @ 1
[    3.320005] initcall dnotify_init+0x0/0x66 returned 0 after 0 usecs
[    3.328004] calling  inotify_user_setup+0x0/0x64 @ 1
[    3.332004] initcall inotify_user_setup+0x0/0x64 returned 0 after 0 usecs
[    3.340004] calling  proc_locks_init+0x0/0x1a @ 1
[    3.344006] initcall proc_locks_init+0x0/0x1a returned 0 after 0 usecs
[    3.348003] calling  init_mbcache+0x0/0xd @ 1
[    3.356003] initcall init_mbcache+0x0/0xd returned 0 after 0 usecs
[    3.360003] calling  dquot_init+0x0/0xef @ 1
[    3.364002] VFS: Disk quotas dquot_6.5.2
[    3.368018] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    3.376003] initcall dquot_init+0x0/0xef returned 0 after 11718 usecs
[    3.380003] calling  proc_cmdline_init+0x0/0x1a @ 1
[    3.388005] initcall proc_cmdline_init+0x0/0x1a returned 0 after 0 usecs
[    3.392003] calling  proc_cpuinfo_init+0x0/0x1a @ 1
[    3.400005] initcall proc_cpuinfo_init+0x0/0x1a returned 0 after 0 usecs
[    3.404003] calling  proc_devices_init+0x0/0x1a @ 1
[    3.408004] initcall proc_devices_init+0x0/0x1a returned 0 after 0 usecs
[    3.416003] calling  proc_interrupts_init+0x0/0x1a @ 1
[    3.420005] initcall proc_interrupts_init+0x0/0x1a returned 0 after 0 usecs
[    3.428003] calling  proc_loadavg_init+0x0/0x1a @ 1
[    3.432004] initcall proc_loadavg_init+0x0/0x1a returned 0 after 0 usecs
[    3.440003] calling  proc_meminfo_init+0x0/0x1a @ 1
[    3.444004] initcall proc_meminfo_init+0x0/0x1a returned 0 after 0 usecs
[    3.452003] calling  proc_stat_init+0x0/0x1a @ 1
[    3.456004] initcall proc_stat_init+0x0/0x1a returned 0 after 0 usecs
[    3.464003] calling  proc_uptime_init+0x0/0x1a @ 1
[    3.468004] initcall proc_uptime_init+0x0/0x1a returned 0 after 0 usecs
[    3.476003] calling  proc_version_init+0x0/0x1a @ 1
[    3.480005] initcall proc_version_init+0x0/0x1a returned 0 after 0 usecs
[    3.484003] calling  proc_softirqs_init+0x0/0x1a @ 1
[    3.492005] initcall proc_softirqs_init+0x0/0x1a returned 0 after 0 usecs
[    3.496003] calling  proc_kmsg_init+0x0/0x1d @ 1
[    3.504005] initcall proc_kmsg_init+0x0/0x1d returned 0 after 0 usecs
[    3.508003] calling  proc_page_init+0x0/0x36 @ 1
[    3.512006] initcall proc_page_init+0x0/0x36 returned 0 after 0 usecs
[    3.520003] calling  init_devpts_fs+0x0/0x39 @ 1
[    3.524023] initcall init_devpts_fs+0x0/0x39 returned 0 after 0 usecs
[    3.532003] calling  init_ext3_fs+0x0/0x5e @ 1
[    3.536005] initcall init_ext3_fs+0x0/0x5e returned 0 after 0 usecs
[    3.540003] calling  journal_init+0x0/0x81 @ 1
[    3.544004] initcall journal_init+0x0/0x81 returned 0 after 0 usecs
[    3.552003] calling  init_ramfs_fs+0x0/0xa @ 1
[    3.556004] initcall init_ramfs_fs+0x0/0xa returned 0 after 0 usecs
[    3.564003] calling  init_hugetlbfs_fs+0x0/0x7c @ 1
[    3.568018] initcall init_hugetlbfs_fs+0x0/0x7c returned 0 after 0 usecs
[    3.576003] calling  ipc_init+0x0/0x1c @ 1
[    3.580015] msgmni has been set to 1747
[    3.584007] initcall ipc_init+0x0/0x1c returned 0 after 3906 usecs
[    3.588003] calling  ipc_sysctl_init+0x0/0xd @ 1
[    3.592004] initcall ipc_sysctl_init+0x0/0xd returned 0 after 0 usecs
[    3.600003] calling  crypto_wq_init+0x0/0x28 @ 1
[    3.606125] initcall crypto_wq_init+0x0/0x28 returned 0 after 0 usecs
[    3.612003] calling  crypto_algapi_init+0x0/0x8 @ 1
[    3.616007] initcall crypto_algapi_init+0x0/0x8 returned 0 after 0 usecs
[    3.624003] calling  skcipher_module_init+0x0/0x2a @ 1
[    3.628003] initcall skcipher_module_init+0x0/0x2a returned 0 after 0 usecs
[    3.636003] calling  chainiv_module_init+0x0/0xa @ 1
[    3.640004] initcall chainiv_module_init+0x0/0xa returned 0 after 0 usecs
[    3.644003] calling  eseqiv_module_init+0x0/0xa @ 1
[    3.652003] initcall eseqiv_module_init+0x0/0xa returned 0 after 0 usecs
[    3.656003] calling  hmac_module_init+0x0/0xa @ 1
[    3.664003] initcall hmac_module_init+0x0/0xa returned 0 after 0 usecs
[    3.668003] calling  md5_mod_init+0x0/0xa @ 1
[    3.675176] initcall md5_mod_init+0x0/0xa returned 0 after 0 usecs
[    3.680004] calling  sha1_generic_mod_init+0x0/0xa @ 1
[    3.686522] initcall sha1_generic_mod_init+0x0/0xa returned 0 after 0 usecs
[    3.692003] calling  krng_mod_init+0x0/0xa @ 1
[    3.697950] initcall krng_mod_init+0x0/0xa returned 0 after 0 usecs
[    3.704012] calling  proc_genhd_init+0x0/0x30 @ 1
[    3.708007] initcall proc_genhd_init+0x0/0x30 returned 0 after 0 usecs
[    3.712004] calling  noop_init+0x0/0xd @ 1
[    3.716006] io scheduler noop registered (default)
[    3.724003] initcall noop_init+0x0/0xd returned 0 after 7812 usecs
[    3.728003] calling  btree_module_init+0x0/0x22 @ 1
[    3.732005] initcall btree_module_init+0x0/0x22 returned 0 after 0 usecs
[    3.740003] calling  percpu_counter_startup+0x0/0x12 @ 1
[    3.744004] initcall percpu_counter_startup+0x0/0x12 returned 0 after 0 usecs
[    3.752003] calling  audit_classes_init+0x0/0x4b @ 1
[    3.756006] initcall audit_classes_init+0x0/0x4b returned 0 after 0 usecs
[    3.764003] calling  pci_proc_init+0x0/0x55 @ 1
[    3.768073] initcall pci_proc_init+0x0/0x55 returned 0 after 0 usecs
[    3.776003] calling  pcie_portdrv_init+0x0/0x49 @ 1
[    3.780053] pcieport 0000:00:0b.0: setting latency timer to 64
[    3.788012] pcieport 0000:00:0c.0: setting latency timer to 64
[    3.792009] pcieport 0000:00:0d.0: setting latency timer to 64
[    3.796009] pcieport 0000:00:0e.0: setting latency timer to 64
[    3.804019] initcall pcie_portdrv_init+0x0/0x49 returned 0 after 23437 usecs
[    3.812005] calling  rand_initialize+0x0/0x21 @ 1
[    3.816036] initcall rand_initialize+0x0/0x21 returned 0 after 0 usecs
[    3.820003] calling  pty_init+0x0/0x295 @ 1
[    3.828063] initcall pty_init+0x0/0x295 returned 0 after 0 usecs
[    3.832003] calling  sysrq_init+0x0/0x69 @ 1
[    3.836007] initcall sysrq_init+0x0/0x69 returned 0 after 0 usecs
[    3.844003] calling  init_tis+0x0/0x80 @ 1
[    3.848017] initcall init_tis+0x0/0x80 returned 0 after 0 usecs
[    3.852003] calling  serial8250_init+0x0/0x141 @ 1
[    3.856002] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.884004] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.892095] initcall serial8250_init+0x0/0x141 returned 0 after 35156 usecs
[    3.896004] calling  isa_bus_init+0x0/0x2f @ 1
[    3.900018] initcall isa_bus_init+0x0/0x2f returned 0 after 0 usecs
[    3.908004] calling  topology_sysfs_init+0x0/0x40 @ 1
[    3.912013] initcall topology_sysfs_init+0x0/0x40 returned 0 after 0 usecs
[    3.920003] calling  cpqarray_init+0x0/0x223 @ 1
[    3.924002] Compaq SMART2 Driver (v 2.6.0)
[    3.928032] initcall cpqarray_init+0x0/0x223 returned -19 after 3906 usecs
[    3.936005] calling  spi_transport_init+0x0/0x60 @ 1
[    3.940023] initcall spi_transport_init+0x0/0x60 returned 0 after 0 usecs
[    3.948004] calling  init_sd+0x0/0x127 @ 1
[    3.952028] initcall init_sd+0x0/0x127 returned 0 after 0 usecs
[    3.956003] calling  ahci_init+0x0/0x11 @ 1
[    3.960049] initcall ahci_init+0x0/0x11 returned 0 after 0 usecs
[    3.968003] calling  piix_init+0x0/0x20 @ 1
[    3.972023] initcall piix_init+0x0/0x20 returned 0 after 0 usecs
[    3.976003] calling  nv_init+0x0/0x11 @ 1
[    3.980023] initcall nv_init+0x0/0x11 returned 0 after 0 usecs
[    3.988003] calling  amd_init+0x0/0x11 @ 1
[    3.992009] pata_amd 0000:00:06.0: version 0.4.1
[    3.996038] pata_amd 0000:00:06.0: setting latency timer to 64
[    4.004114] scsi0 : pata_amd
[    4.007071] scsi1 : pata_amd
[    4.008047] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[    4.016003] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[    4.020030] initcall amd_init+0x0/0x11 returned 0 after 27343 usecs
[    4.023964] calling  1_async_port_probe+0x0/0x92 @ 5
[    4.023991] calling  2_async_port_probe+0x0/0x92 @ 29
[    4.023993] async_waiting @ 29
[    4.040005] calling  oldpiix_init+0x0/0x11 @ 1
[    4.044022] initcall oldpiix_init+0x0/0x11 returned 0 after 0 usecs
[    4.052003] calling  via_init+0x0/0x11 @ 1
[    4.056021] initcall via_init+0x0/0x11 returned 0 after 0 usecs
[    4.064003] calling  e1000_init_module+0x0/0x2d @ 1
[    4.068002] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.7-k2
[    4.072002] e1000e: Copyright (c) 1999 - 2010 Intel Corporation.
[    4.080038] initcall e1000_init_module+0x0/0x2d returned 0 after 11718 usecs
[    4.084003] calling  e100_init_module+0x0/0x48 @ 1
[    4.092002] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    4.096002] e100: Copyright(c) 1999-2006 Intel Corporation
[    4.104033] initcall e100_init_module+0x0/0x48 returned 0 after 11718 usecs
[    4.108003] calling  tg3_init+0x0/0x11 @ 1
[    4.112023] initcall tg3_init+0x0/0x11 returned 0 after 0 usecs
[    4.120003] calling  skge_init_module+0x0/0x44 @ 1
[    4.124030] initcall skge_init_module+0x0/0x44 returned 0 after 0 usecs
[    4.132004] calling  net_olddevs_init+0x0/0x7e @ 1
[    4.136008] initcall net_olddevs_init+0x0/0x7e returned 0 after 0 usecs
[    4.144003] calling  init_nic+0x0/0x11 @ 1
[    4.148011] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
[    4.152015] IOAPIC[0]: Set routing entry (2-11 -> 0x49 -> IRQ 35 Mode:1 Active:1)
[    4.160006] forcedeth 0000:00:0a.0: PCI->APIC IRQ transform: INT A -> IRQ 35
[    4.168003] forcedeth 0000:00:0a.0: setting latency timer to 64
[    4.176025] nv_probe: set workaround bit for reversed mac addr
[    4.192501] ata1.00: ATA-6: HDS722525VLAT80, V36OA60A, max UDMA/100
[    4.196003] ata1.00: 488397168 sectors, multi 1: LBA48 
[    4.204008] ata1: nv_mode_filter: 0x3f39f&0x3f3ff->0x3f39f, BIOS=0x3f000 (0xc60000c0) ACPI=0x0
[    4.236414] ata1.00: configured for UDMA/100
[    4.240713] async_waiting @ 5
[    4.243683] async_continuing @ 5 after 0 usec
[    4.244111] scsi 0:0:0:0: Direct-Access     ATA      HDS722525VLAT80  V36O PQ: 0 ANSI: 5
[    4.248186] calling  3_sd_probe_async+0x0/0x177 @ 30
[    4.252035] initcall 1_async_port_probe+0x0/0x92 returned 0 after 226562 usecs
[    4.256005] async_continuing @ 29 after 230468 usec
[    4.260103] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    4.264057] sd 0:0:0:0: [sda] Write Protect is off
[    4.268004] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.272024] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.354415]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
[    4.356471] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.360004] initcall 3_sd_probe_async+0x0/0x177 returned 0 after 105468 usecs
[    4.428230] ata2.01: ATAPI: DVDRW IDE 16X, VER A079, max UDMA/66
[    4.432007] ata2: nv_mode_filter: 0x1f39f&0x73ff->0x739f, BIOS=0x7000 (0xc60000c0) ACPI=0x0
[    4.452164] ata2.01: configured for UDMA/33
[    4.456649] async_waiting @ 29
[    4.460002] async_continuing @ 29 after 0 usec
[    4.460754] scsi 1:0:1:0: CD-ROM            DVDRW    IDE 16X          A079 PQ: 0 ANSI: 5
[    4.472085] initcall 2_async_port_probe+0x0/0x92 returned 0 after 441406 usecs
[    4.700304] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 9, addr 00:13:d4:dc:41:12
[    4.708003] forcedeth 0000:00:0a.0: highdma csum gbit lnktim desc-v3
[    4.712020] initcall init_nic+0x0/0x11 returned 0 after 550781 usecs
[    4.720005] calling  rtl8139_init_module+0x0/0x11 @ 1
[    4.724012] 8139too: 8139too Fast Ethernet driver 0.9.28
[    4.728012] 8139too 0000:05:07.0: PCI->APIC IRQ transform: INT A -> IRQ 35
[    4.736384] 8139too 0000:05:07.0: eth1: RealTek RTL8139 at 0xc000, 00:c0:df:03:68:5d, IRQ 35
[    4.744016] initcall rtl8139_init_module+0x0/0x11 returned 0 after 19531 usecs
[    4.752004] calling  init_netconsole+0x0/0x183 @ 1
[    4.756004] console [netcon0] enabled
[    4.760002] netconsole: network logging started
[    4.764004] initcall init_netconsole+0x0/0x183 returned 0 after 7812 usecs
[    4.772003] calling  ehci_hcd_init+0x0/0x64 @ 1
[    4.776002] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.784014] ehci_hcd 0000:00:02.1: can't find IRQ for PCI INT B; probably buggy MP table
[    4.792003] ehci_hcd 0000:00:02.1: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.1 setup!
[    4.800004] ehci_hcd 0000:00:02.1: init 0000:00:02.1 fail, -19
[    4.804030] initcall ehci_hcd_init+0x0/0x64 returned 0 after 27343 usecs
[    4.812004] calling  ohci_hcd_mod_init+0x0/0x47 @ 1
[    4.816002] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.824013] ohci_hcd 0000:00:02.0: can't find IRQ for PCI INT A; probably buggy MP table
[    4.832002] ohci_hcd 0000:00:02.0: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.0 setup!
[    4.840003] ohci_hcd 0000:00:02.0: init 0000:00:02.0 fail, -19
[    4.848018] initcall ohci_hcd_mod_init+0x0/0x47 returned 0 after 31250 usecs
[    4.852003] calling  uhci_hcd_init+0x0/0x9e @ 1
[    4.856002] uhci_hcd: USB Universal Host Controller Interface driver
[    4.864026] initcall uhci_hcd_init+0x0/0x9e returned 0 after 7812 usecs
[    4.872004] calling  i8042_init+0x0/0x2c3 @ 1
[    4.876041] PNP: No PS/2 controller found. Probing ports directly.
[    5.405182] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.412045] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.416033] initcall i8042_init+0x0/0x2c3 returned 0 after 527343 usecs
[    5.420004] calling  mousedev_init+0x0/0x72 @ 1
[    5.428078] mice: PS/2 mouse device common for all mice
[    5.432005] initcall mousedev_init+0x0/0x72 returned 0 after 3906 usecs
[    5.440004] calling  atkbd_init+0x0/0x11 @ 1
[    5.444601] initcall atkbd_init+0x0/0x11 returned 0 after 0 usecs
[    5.448004] calling  init_ladder+0x0/0xa @ 1
[    5.452003] cpuidle: using governor ladder
[    5.456004] initcall init_ladder+0x0/0xa returned 0 after 3906 usecs
[    5.464003] calling  flow_cache_init_global+0x0/0x134 @ 1
[    5.468013] initcall flow_cache_init_global+0x0/0x134 returned 0 after 0 usecs
[    5.476003] calling  sysctl_ipv4_init+0x0/0x6d @ 1
[    5.480010] initcall sysctl_ipv4_init+0x0/0x6d returned 0 after 0 usecs
[    5.488003] calling  init_syncookies+0x0/0x12 @ 1
[    5.492043] initcall init_syncookies+0x0/0x12 returned 0 after 0 usecs
[    5.500003] calling  packet_init+0x0/0x35 @ 1
[    5.504003] NET: Registered protocol family 17
[    5.508008] initcall packet_init+0x0/0x35 returned 0 after 3906 usecs
[    5.516004] calling  update_mp_table+0x0/0x558 @ 1
[    5.520004] initcall update_mp_table+0x0/0x558 returned 0 after 0 usecs
[    5.524003] calling  lapic_insert_resource+0x0/0x31 @ 1
[    5.532004] initcall lapic_insert_resource+0x0/0x31 returned 0 after 0 usecs
[    5.540003] calling  print_ipi_mode+0x0/0x24 @ 1
[    5.544002] Using IPI No-Shortcut mode
[    5.548003] initcall print_ipi_mode+0x0/0x24 returned 0 after 3906 usecs
[    5.552003] calling  io_apic_bug_finalize+0x0/0x16 @ 1
[    5.560004] initcall io_apic_bug_finalize+0x0/0x16 returned 0 after 0 usecs
[    5.564004] calling  check_early_ioremap_leak+0x0/0x58 @ 1
[    5.572004] initcall check_early_ioremap_leak+0x0/0x58 returned 0 after 0 usecs
[    5.580004] calling  init_oops_id+0x0/0x36 @ 1
[    5.584006] initcall init_oops_id+0x0/0x36 returned 0 after 0 usecs
[    5.588003] calling  printk_late_init+0x0/0x3e @ 1
[    5.592003] initcall printk_late_init+0x0/0x3e returned 0 after 0 usecs
[    5.600003] calling  pm_qos_power_init+0x0/0xa8 @ 1
[    5.604081] initcall pm_qos_power_init+0x0/0xa8 returned 0 after 0 usecs
[    5.612004] calling  clear_boot_tracer+0x0/0x23 @ 1
[    5.616003] initcall clear_boot_tracer+0x0/0x23 returned 0 after 0 usecs
[    5.624003] calling  event_trace_self_tests_init+0x0/0x246 @ 1
[    5.628002] Running tests on trace events:
[    5.632002] Testing event kfree_skb: OK
[    5.652476] Testing event consume_skb: OK
[    5.672450] Testing event skb_copy_datagram_iovec: OK
[    5.692445] Testing event net_dev_xmit: OK
[    5.712453] Testing event net_dev_queue: OK
[    5.732448] Testing event netif_receive_skb: OK
[    5.752450] Testing event netif_rx: OK
[    5.768446] Testing event napi_poll: OK
[    5.788475] Testing event scsi_dispatch_cmd_start: OK
[    5.808441] Testing event scsi_dispatch_cmd_error: OK
[    5.828453] Testing event scsi_dispatch_cmd_done: OK
[    5.848444] Testing event scsi_dispatch_cmd_timeout: OK
[    5.868446] Testing event scsi_eh_wakeup: OK
[    5.888439] Testing event lock_kernel: OK
[    5.908467] Testing event unlock_kernel: OK
[    5.928443] Testing event block_rq_abort: 
[    5.972116] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    5.984014] OK
[    5.984014] Testing event block_rq_requeue: OK
[    6.004458] Testing event block_rq_complete: OK
[    6.024460] Testing event block_rq_insert: OK
[    6.044453] Testing event block_rq_issue: OK
[    6.064447] Testing event block_bio_bounce: OK
[    6.084457] Testing event block_bio_complete: OK
[    6.104441] Testing event block_bio_backmerge: OK
[    6.124459] Testing event block_bio_frontmerge: OK
[    6.144444] Testing event block_bio_queue: OK
[    6.164454] Testing event block_getrq: OK
[    6.184446] Testing event block_sleeprq: OK
[    6.204440] Testing event block_plug: OK
[    6.224442] Testing event block_unplug_timer: OK
[    6.244452] Testing event block_unplug_io: OK
[    6.264454] Testing event block_split: OK
[    6.284455] Testing event block_remap: OK
[    6.304447] Testing event block_rq_remap: OK
[    6.324451] Testing event writeback_nothread: OK
[    6.344442] Testing event writeback_queue: OK
[    6.364453] Testing event writeback_exec: OK
[    6.384447] Testing event writeback_pages_written: OK
[    6.404457] Testing event writeback_nowork: OK
[    6.424441] Testing event writeback_wake_thread: OK
[    6.444443] Testing event writeback_wake_forker_thread: OK
[    6.464445] Testing event writeback_bdi_register: OK
[    6.485625] Testing event writeback_bdi_unregister: OK
[    6.504457] Testing event writeback_thread_start: OK
[    6.524457] Testing event writeback_thread_stop: OK
[    6.544443] Testing event wbc_writeback_start: OK
[    6.564452] Testing event wbc_writeback_written: OK
[    6.584446] Testing event wbc_writeback_wait: OK
[    6.604457] Testing event wbc_balance_dirty_start: OK
[    6.624440] Testing event wbc_balance_dirty_written: OK
[    6.644459] Testing event wbc_balance_dirty_wait: OK
[    6.664444] Testing event wbc_writepage: OK
[    6.686792] Testing event kmalloc: OK
[    6.704446] Testing event kmem_cache_alloc: OK
[    6.724449] Testing event kmalloc_node: OK
[    6.744459] Testing event kmem_cache_alloc_node: 
[    6.749111] BUG: unable to handle kernel paging request at ffffffff
[    6.752000] IP: [<f6425f7c>] 0xf6425f7c
[    6.752000] *pde = 01384067 *pte = 00000000 
[    6.752000] Oops: 0002 [#1] PREEMPT SMP 
[    6.752000] last sysfs file: 
[    6.752000] Modules linked in:
[    6.752000] 
[    6.752000] Pid: 2, comm: kthreadd Not tainted 2.6.36-rc8-tip+ #50831 /
[    6.752000] EIP: 0060:[<f6425f7c>] EFLAGS: 00010282 CPU: 0
[    6.752000] EIP is at 0xf6425f7c
[    6.752000] EAX: ffffffff EBX: c1021c4f ECX: 00000001 EDX: 00000000
[    6.752000] ESI: f6425f7c EDI: fffffff4 EBP: f640c000 ESP: f6425ee4
[    6.752000]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[    6.752000] Process kthreadd (pid: 2, ti=f6424000 task=f640c000 task.ti=f6424000)
[    6.752000] Stack:
[    6.752000]  c1021c4f f640c02c 00800711 00000000 00000000 00000000 f6425f7c f6809880
[    6.752000] <0> f6425f7c 00000000 00000000 f6425f7c c1022a54 00000000 00000000 00000000
[    6.752000] <0> 00000000 00800711 00000000 00000000 00000000 c101d94a f6809880 c131f3a0
[    6.752000] Call Trace:
[    6.752000]  [<c1021c4f>] ? copy_process+0xa1/0xd6d
[    6.752000]  [<c1022a54>] ? do_fork+0x139/0x2ca
[    6.752000]  [<c101d94a>] ? dequeue_task+0xb9/0xc8
[    6.752000]  [<c1245597>] ? schedule+0x821/0x84b
[    6.752000]  [<c1038079>] ? kthread+0x0/0x68
[    6.752000]  [<c1007930>] ? kernel_thread+0x77/0x7f
[    6.752000]  [<c1038079>] ? kthread+0x0/0x68
[    6.752000]  [<c1002cbc>] ? kernel_thread_helper+0x0/0x10
[    6.752000]  [<c1038172>] ? kthreadd+0x91/0xc7
[    6.752000]  [<c10380e1>] ? kthreadd+0x0/0xc7
[    6.752000]  [<c1002cc2>] ? kernel_thread_helper+0x6/0x10
[    6.752000] Code: 98 80 f6 00 c0 40 f6 a9 37 61 f9 11 07 80 00 79 80 03 c1 c0 5f 42 f6 7c 5f 42 f6 30 79 00 c1 00 00 00 00 00 00 00 00 00 00 00 00 <00> 00 00 00 00 00 00 00 00 00 00 00 79 80 03 c1 70 3f 42 f6 00 
[    6.752000] EIP: [<f6425f7c>] 0xf6425f7c SS:ESP 0068:f6425ee4
[    6.752000] CR2: 00000000ffffffff
[    6.752000] ---[ end trace 6000cf675d3eddec ]---
