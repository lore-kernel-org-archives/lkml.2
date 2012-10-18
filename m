Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab2JRLlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 07:41:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:24099 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802Ab2JRLlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 07:41:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,606,1344236400"; 
   d="scan'208";a="206029960"
Date: Thu, 18 Oct 2012 19:41:39 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [tracing] WARNING: at kernel/lockdep.c:3545 check_flags()
Message-ID: <20121018114139.GA29884@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Steven,

This warning occur from time to time in my tests:

[  593.080133] Testing tracer function: 
[  593.149895] ------------[ cut here ]------------
[  593.149895] WARNING: at /c/kernel-tests/src/stable/kernel/lockdep.c:3545 check_flags+0x1c8/0x1d0()
[  593.149895] Modules linked in:
[  593.149895] Pid: 1, comm: swapper/0 Not tainted 3.7.0-rc1-12129-gee2dd3c #3
[  593.149895] Call Trace:
[  593.149895]  <IRQ>  [<ffffffff810734cf>] warn_slowpath_common+0x8f/0xc0
[  593.149895]  [<ffffffff8107351a>] warn_slowpath_null+0x1a/0x20
[  593.149895]  [<ffffffff810fac08>] check_flags+0x1c8/0x1d0
[  593.149895]  [<ffffffff810fbfed>] lock_is_held+0x4d/0xa0
[  593.149895]  [<ffffffff8156d570>] ? notify_die+0x30/0x30
[  593.149895]  [<ffffffff81081b13>] ? __local_bh_enable+0x1d3/0x230
[  593.149895]  [<ffffffff81133cdf>] rcu_read_lock_held+0x7f/0x90
[  593.149895]  [<ffffffff81134208>] ftrace_ops_no_ops+0x188/0x190
[  593.149895]  [<ffffffff81573872>] trace+0x55/0x93
[  593.149895]  [<ffffffff81573872>] ? trace+0x55/0x93
[  593.149895]  [<ffffffff81566fc9>] ? _raw_spin_unlock_irq+0x99/0xc0
[  593.149895]  [<ffffffff8156d575>] ? sub_preempt_count+0x5/0x210
[  593.149895]  [<ffffffff8156d575>] ? sub_preempt_count+0x5/0x210
[  593.149895]  [<ffffffff81081b13>] ? __local_bh_enable+0x1d3/0x230
[  593.149895]  [<ffffffff810827ea>] __do_softirq+0x42a/0x710
[  593.149895]  [<ffffffff81574c7c>] call_softirq+0x1c/0x30
[  593.149895]  [<ffffffff81028a05>] do_softirq+0x1d5/0x2a0
[  593.149895]  [<ffffffff81082d3d>] irq_exit+0xad/0xc0
[  593.149895]  [<ffffffff81028035>] do_IRQ+0x75/0x100
[  593.149895]  [<ffffffff81567c72>] common_interrupt+0x72/0x72
[  593.149895]  <EOI>  [<ffffffff810fafbb>] ? mark_held_locks+0x9b/0x100
[  593.149895]  [<ffffffff815675f3>] ? _raw_spin_unlock_irqrestore+0xd3/0x130
[  593.149895]  [<ffffffff81307487>] __debug_object_init+0x1b7/0x580
[  593.149895]  [<ffffffff813078c6>] debug_object_init_on_stack+0x36/0x40
[  593.149895]  [<ffffffff8108a565>] init_timer_on_stack_key+0x35/0x80
[  593.149895]  [<ffffffff815616fb>] schedule_timeout+0x8b/0x470
[  593.149895]  [<ffffffff81573872>] ? trace+0x55/0x93
[  593.149895]  [<ffffffff81562fb7>] ? __mutex_unlock_slowpath+0x247/0x380
[  593.149895]  [<ffffffff81133487>] ? update_ftrace_function+0x17/0x150
[  593.149895]  [<ffffffff81561afe>] schedule_timeout_uninterruptible+0x1e/0x20
[  593.149895]  [<ffffffff8108ea60>] msleep+0x20/0x30
[  593.149895]  [<ffffffff81145a6a>] trace_selftest_startup_function+0xda/0x2b0
[  593.149895]  [<ffffffff81146c4c>] register_tracer+0x32c/0x430
[  593.149895]  [<ffffffff81c3aee4>] ? init_trace_printk_function_export+0x48/0x48
[  593.149895]  [<ffffffff81c3aef4>] init_function_trace+0x10/0x12
[  593.149895]  [<ffffffff8100223a>] do_one_initcall+0x1aa/0x270
[  593.149895]  [<ffffffff815313bc>] kernel_init+0x11c/0x370
[  593.149895]  [<ffffffff81c17878>] ? do_early_param+0xc6/0xc6
[  593.149895]  [<ffffffff810ca474>] ? schedule_tail+0x34/0x110
[  593.149895]  [<ffffffff815312a0>] ? rest_init+0x170/0x170
[  593.149895]  [<ffffffff815739ac>] ret_from_fork+0x7c/0xb0
[  593.149895]  [<ffffffff815312a0>] ? rest_init+0x170/0x170

And it's bisected down to an unbelievable simple commit..

commit 17bb615ad4f8d2d2c0f02794d27d7f83e0009ef4
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Mon May 23 15:27:46 2011 -0400

    tracing: Have event with function tracer check error return

Thanks,
Fengguang

--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-ant-9553-2012-10-18-11-24-29-3.7.0-rc1-12129-gee2dd3c-3"

[    0.000000] Linux version 3.7.0-rc1-12129-gee2dd3c (kbuild@hive) (gcc version 4.7.1 (GCC) ) #3 SMP PREEMPT Thu Oct 18 11:10:50 CST 2012
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=omap/master log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2012-10-18-11-14-21-omap:master:ee2dd3c-ee2dd3c-x86_64-randconfig-h092-3-ant noapic nolapic nohz=off BOOT_IMAGE=kernel-tests/kernels/x86_64-randconfig-h092/ee2dd3c/vmlinuz-3.7.0-rc1-12129-gee2dd3c
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at [ffff8800000fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x0e854000-0x0e8d5fff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128188(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd930 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000000ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0e8af000-0x0e8d5fff]
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000d400000-ffff88000d7fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3901 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 960 pages used for memmap
[    0.000000]   DMA32 zone: 60478 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1         
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] Bus #0 is PCI   
[    0.000000] Bus #1 is ISA   
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 09
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 10, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 14, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 18, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 1c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 20, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 24, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, APIC LINT 01
[    0.000000] Processors: 2
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 0000000000093000 - 0000000000094000
[    0.000000] PM: Registered nosave memory: 0000000000094000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] e820: [mem 0x10000000-0xfffbffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:4096 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88000de00000 s82496 r8192 d24000 u1048576
[    0.000000] pcpu-alloc: s82496 r8192 d24000 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 64379
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=omap/master log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2012-10-18-11-14-21-omap:master:ee2dd3c-ee2dd3c-x86_64-randconfig-h092-3-ant noapic nolapic nohz=off BOOT_IMAGE=kernel-tests/kernels/x86_64-randconfig-h092/ee2dd3c/vmlinuz-3.7.0-rc1-12129-gee2dd3c
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 200808k/262136k available (5589k kernel code, 500k absent, 60828k reserved, 6700k data, 700k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] NR_IRQS:262400 nr_irqs:512 16
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ODEBUG: 8 of 8 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using HPET reference calibration
[    0.000000] tsc: Detected 3191.613 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.059802] Calibrating delay loop (skipped), value calculated using timer frequency.. 6383.22 BogoMIPS (lpj=3191613)
[    0.066930] pid_max: default: 32768 minimum: 301
[    0.210703] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.222628] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.234511] Mount-cache hash table entries: 256
[    0.436000] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.436000] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.436000] tlb_flushall_shift: -1
[    0.461265] Freeing SMP alternatives: 12k freed
[    0.518808] ACPI: Core revision 20120913
[    7.503732] ACPI: setting ELCR to 0200 (from 0c00)
[    7.585231] smpboot: SMP disabled
[    7.593364] Performance Events: 
[    7.595377] no APIC, boot with the "lapic" boot parameter to force-enable it.
[    7.597249] no hardware sampling interrupt available.
[    7.599561] Broken PMU hardware detected, using software events only.
[    7.601273] Failed to access perfctr msr (MSR c0010004 is 0)
[    7.906434] Testing tracer nop: PASSED
[    7.942794] Brought up 1 CPUs
[    7.945281] ----------------
[    7.946271] | NMI testsuite:
[    7.947255] --------------------
[    7.948431]   remote IPI:  ok  |
[    7.951449]    local IPI:  ok  |
[   41.618362] --------------------
[   41.619242] Good, all   2 testcases passed! |
[   41.620201] ---------------------------------
[   41.622314] smpboot: Total of 1 processors activated (6383.22 BogoMIPS)
[   41.894512] devtmpfs: initialized
[   41.949401] device: 'platform': device_add
[   41.965236] PM: Adding info for No Bus:platform
[   41.996465] bus: 'platform': registered
[   42.012454] bus: 'cpu': registered
[   42.024421] device: 'cpu': device_add
[   42.054452] PM: Adding info for No Bus:cpu
[   42.109706] bus: 'memory': registered
[   42.117418] device: 'memory': device_add
[   42.127720] PM: Adding info for No Bus:memory
[   42.151698] device: 'memory0': device_add
[   42.168570] bus: 'memory': add device memory0
[   42.191564] PM: Adding info for memory:memory0
[   42.220228] device: 'memory1': device_add
[   42.225314] bus: 'memory': add device memory1
[   42.234319] PM: Adding info for memory:memory1
[   42.824670] atomic64 test passed for x86-64 platform with CX8 and with SSE
[   42.825500] device class 'regulator': registering
[   42.889473] Registering platform device 'reg-dummy'. Parent at platform
[   42.891309] device: 'reg-dummy': device_add
[   42.897458] bus: 'platform': add device reg-dummy
[   42.909354] PM: Adding info for platform:reg-dummy
[   42.919828] bus: 'platform': add driver reg-dummy
[   42.928290] bus: 'platform': driver_probe_device: matched device reg-dummy with driver reg-dummy
[   42.930348] bus: 'platform': really_probe: probing driver reg-dummy with device reg-dummy
[   42.952250] device: 'regulator.0': device_add
[   42.998257] PM: Adding info for No Bus:regulator.0
[   43.018233] regulator-dummy: no parameters
[   43.036596] driver: 'reg-dummy': driver_bound: bound to device 'reg-dummy'
[   43.040306] bus: 'platform': really_probe: bound device reg-dummy to driver reg-dummy
[   43.129443] NET: Registered protocol family 16
[   43.153370] device class 'bdi': registering
[   43.175401] device class 'gpio': registering
[   43.188841] device class 'pci_bus': registering
[   43.217430] bus: 'pci': registered
[   43.219690] device class 'tty': registering
[   43.298459] bus: 'node': registered
[   43.309416] device: 'node': device_add
[   43.334528] PM: Adding info for No Bus:node
[   43.404676] bus: 'spi': registered
[   43.405634] device class 'spi_master': registering
[   43.498487] ACPI: bus type pci registered
[   43.513375] PCI: Using configuration type 1 for base access
[   43.528419] device: 'node0': device_add
[   43.535689] bus: 'node': add device node0
[   43.548672] PM: Adding info for node:node0
[   43.634429] device: 'cpu0': device_add
[   43.642400] bus: 'cpu': add device cpu0
[   43.659434] PM: Adding info for cpu:cpu0
[   45.723410] device: 'default': device_add
[   45.755364] PM: Adding info for No Bus:default
[   45.829485] bio: create slab <bio-0> at 0
[   45.863855] device class 'block': registering
[   45.936429] ACPI: Added _OSI(Module Device)
[   45.940368] ACPI: Added _OSI(Processor Device)
[   45.944277] ACPI: Added _OSI(3.0 _SCP Extensions)
[   45.948240] ACPI: Added _OSI(Processor Aggregator Device)
[   46.296684] ACPI: EC: Look up EC in DSDT
[   61.835704] ACPI: Interpreter enabled
[   61.837462] ACPI: (supports S0 S3 S4 S5)
[   62.070683] ACPI: Using PIC for interrupt routing
[   62.155454] bus: 'acpi': registered
[   62.159708] bus: 'acpi': add driver power
[   62.272672] device: 'LNXSYSTM:00': device_add
[   62.291693] bus: 'acpi': add device LNXSYSTM:00
[   62.309745] PM: Adding info for acpi:LNXSYSTM:00
[   62.592521] device: 'device:00': device_add
[   62.604680] bus: 'acpi': add device device:00
[   62.621434] PM: Adding info for acpi:device:00
[   62.874467] device: 'PNP0A03:00': device_add
[   62.886726] bus: 'acpi': add device PNP0A03:00
[   62.907452] PM: Adding info for acpi:PNP0A03:00
[   63.622352] device: 'device:01': device_add
[   63.629359] bus: 'acpi': add device device:01
[   63.640315] PM: Adding info for acpi:device:01
[   63.781232] device: 'device:02': device_add
[   63.787346] bus: 'acpi': add device device:02
[   63.798342] PM: Adding info for acpi:device:02
[   63.943336] device: 'PNP0B00:00': device_add
[   63.950323] bus: 'acpi': add device PNP0B00:00
[   63.960344] PM: Adding info for acpi:PNP0B00:00
[   64.172241] device: 'PNP0303:00': device_add
[   64.178358] bus: 'acpi': add device PNP0303:00
[   64.188347] PM: Adding info for acpi:PNP0303:00
[   64.404276] device: 'PNP0F13:00': device_add
[   64.410325] bus: 'acpi': add device PNP0F13:00
[   64.421311] PM: Adding info for acpi:PNP0F13:00
[   64.627263] device: 'PNP0700:00': device_add
[   64.633339] bus: 'acpi': add device PNP0700:00
[   64.644310] PM: Adding info for acpi:PNP0700:00
[   65.161447] device: 'PNP0400:00': device_add
[   65.172457] bus: 'acpi': add device PNP0400:00
[   65.184317] PM: Adding info for acpi:PNP0400:00
[   65.651270] device: 'PNP0501:00': device_add
[   65.658387] bus: 'acpi': add device PNP0501:00
[   65.670203] PM: Adding info for acpi:PNP0501:00
[   66.001253] device: 'device:03': device_add
[   66.009254] bus: 'acpi': add device device:03
[   66.019316] PM: Adding info for acpi:device:03
[   66.164278] device: 'device:04': device_add
[   66.170434] bus: 'acpi': add device device:04
[   66.181345] PM: Adding info for acpi:device:04
[   66.323241] device: 'device:05': device_add
[   66.330248] bus: 'acpi': add device device:05
[   66.340342] PM: Adding info for acpi:device:05
[   66.504238] device: 'device:06': device_add
[   66.511348] bus: 'acpi': add device device:06
[   66.522341] PM: Adding info for acpi:device:06
[   66.711487] device: 'device:07': device_add
[   66.719669] bus: 'acpi': add device device:07
[   66.734559] PM: Adding info for acpi:device:07
[   66.977480] device: 'device:08': device_add
[   66.987703] bus: 'acpi': add device device:08
[   67.007703] PM: Adding info for acpi:device:08
[   67.235357] device: 'device:09': device_add
[   67.243412] bus: 'acpi': add device device:09
[   67.255378] PM: Adding info for acpi:device:09
[   67.429235] device: 'device:0a': device_add
[   67.435339] bus: 'acpi': add device device:0a
[   67.446282] PM: Adding info for acpi:device:0a
[   67.609232] device: 'device:0b': device_add
[   67.615341] bus: 'acpi': add device device:0b
[   67.619484] PM: Adding info for acpi:device:0b
[   67.783348] device: 'device:0c': device_add
[   67.790326] bus: 'acpi': add device device:0c
[   67.800336] PM: Adding info for acpi:device:0c
[   67.979584] device: 'device:0d': device_add
[   67.993680] bus: 'acpi': add device device:0d
[   68.014716] PM: Adding info for acpi:device:0d
[   68.174346] device: 'device:0e': device_add
[   68.181328] bus: 'acpi': add device device:0e
[   68.191333] PM: Adding info for acpi:device:0e
[   68.364000] device: 'device:0f': device_add
[   68.369292] bus: 'acpi': add device device:0f
[   68.380339] PM: Adding info for acpi:device:0f
[   68.553232] device: 'device:10': device_add
[   68.559435] bus: 'acpi': add device device:10
[   68.571359] PM: Adding info for acpi:device:10
[   68.746226] device: 'device:11': device_add
[   68.752393] bus: 'acpi': add device device:11
[   68.764383] PM: Adding info for acpi:device:11
[   68.932279] device: 'device:12': device_add
[   68.940317] bus: 'acpi': add device device:12
[   68.952238] PM: Adding info for acpi:device:12
[   69.149512] device: 'device:13': device_add
[   69.160377] bus: 'acpi': add device device:13
[   69.179404] PM: Adding info for acpi:device:13
[   69.385268] device: 'device:14': device_add
[   69.391344] bus: 'acpi': add device device:14
[   69.402364] PM: Adding info for acpi:device:14
[   69.584306] device: 'device:15': device_add
[   69.592389] bus: 'acpi': add device device:15
[   69.605297] PM: Adding info for acpi:device:15
[   69.818390] device: 'device:16': device_add
[   69.830444] bus: 'acpi': add device device:16
[   69.845691] PM: Adding info for acpi:device:16
[   70.067000] device: 'device:17': device_add
[   70.077514] bus: 'acpi': add device device:17
[   70.097457] PM: Adding info for acpi:device:17
[   70.279261] device: 'device:18': device_add
[   70.280000] bus: 'acpi': add device device:18
[   70.283361] PM: Adding info for acpi:device:18
[   70.441352] device: 'device:19': device_add
[   70.448259] bus: 'acpi': add device device:19
[   70.459328] PM: Adding info for acpi:device:19
[   70.696528] device: 'device:1a': device_add
[   70.707677] bus: 'acpi': add device device:1a
[   70.725396] PM: Adding info for acpi:device:1a
[   70.965583] device: 'device:1b': device_add
[   70.974726] bus: 'acpi': add device device:1b
[   70.991444] PM: Adding info for acpi:device:1b
[   71.261395] device: 'device:1c': device_add
[   71.269279] bus: 'acpi': add device device:1c
[   71.280411] PM: Adding info for acpi:device:1c
[   71.461297] device: 'device:1d': device_add
[   71.469312] bus: 'acpi': add device device:1d
[   71.481274] PM: Adding info for acpi:device:1d
[   71.662236] device: 'device:1e': device_add
[   71.669401] bus: 'acpi': add device device:1e
[   71.681393] PM: Adding info for acpi:device:1e
[   71.846271] device: 'device:1f': device_add
[   71.852344] bus: 'acpi': add device device:1f
[   71.863344] PM: Adding info for acpi:device:1f
[   72.027458] device: 'device:20': device_add
[   72.038802] bus: 'acpi': add device device:20
[   72.059464] PM: Adding info for acpi:device:20
[   72.237276] device: 'device:21': device_add
[   72.244258] bus: 'acpi': add device device:21
[   72.254340] PM: Adding info for acpi:device:21
[   72.412236] device: 'device:22': device_add
[   72.418341] bus: 'acpi': add device device:22
[   72.428330] PM: Adding info for acpi:device:22
[   73.136351] device: 'PNP0103:00': device_add
[   73.144312] bus: 'acpi': add device PNP0103:00
[   73.154582] PM: Adding info for acpi:PNP0103:00
[   73.694314] device: 'PNP0C0F:00': device_add
[   73.702389] bus: 'acpi': add device PNP0C0F:00
[   73.715334] PM: Adding info for acpi:PNP0C0F:00
[   74.166249] device: 'PNP0C0F:01': device_add
[   74.173408] bus: 'acpi': add device PNP0C0F:01
[   74.186396] PM: Adding info for acpi:PNP0C0F:01
[   74.607000] device: 'PNP0C0F:02': device_add
[   74.612512] bus: 'acpi': add device PNP0C0F:02
[   74.624387] PM: Adding info for acpi:PNP0C0F:02
[   75.003238] device: 'PNP0C0F:03': device_add
[   75.009343] bus: 'acpi': add device PNP0C0F:03
[   75.020336] PM: Adding info for acpi:PNP0C0F:03
[   75.395251] device: 'PNP0C0F:04': device_add
[   75.402250] bus: 'acpi': add device PNP0C0F:04
[   75.412332] PM: Adding info for acpi:PNP0C0F:04
[   75.667258] device: 'LNXCPU:00': device_add
[   75.673335] bus: 'acpi': add device LNXCPU:00
[   75.684330] PM: Adding info for acpi:LNXCPU:00
[   75.938213] device: 'LNXCPU:01': device_add
[   75.944316] bus: 'acpi': add device LNXCPU:01
[   75.954331] PM: Adding info for acpi:LNXCPU:01
[   76.091228] device: 'device:23': device_add
[   76.097335] bus: 'acpi': add device device:23
[   76.108333] PM: Adding info for acpi:device:23
[   76.134251] device: 'LNXPWRBN:00': device_add
[   76.140242] bus: 'acpi': add device LNXPWRBN:00
[   76.149251] PM: Adding info for acpi:LNXPWRBN:00
[   76.178426] bus: 'acpi': add driver ec
[   76.198548] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[   76.199294] bus: 'acpi': add driver pci_root
[   76.205429] bus: 'acpi': driver_probe_device: matched device PNP0A03:00 with driver pci_root
[   76.207236] bus: 'acpi': really_probe: probing driver pci_root with device PNP0A03:00
[   76.248000] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[   76.310236] device: 'pci0000:00': device_add
[   76.335353] PM: Adding info for No Bus:pci0000:00
[   76.341247] device: '0000:00': device_add
[   76.372338] PM: Adding info for No Bus:0000:00
[   76.383367] PCI host bridge to bus 0000:00
[   76.388397] pci_bus 0000:00: root bus resource [bus 00-ff]
[   76.391578] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[   76.394271] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[   76.397302] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[   76.399274] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebfffff]
[   76.411300] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[   76.425336] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[   76.435354] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[   76.449346] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[   76.460354] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[   76.468234] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[   76.470319] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[   76.476335] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[   76.482342] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[   76.487393] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[   76.505400] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[   76.510306] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[   76.515303] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[   76.520297] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[   76.537310] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[   76.544360] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[   76.549309] pci 0000:00:04.0: reg 10: [io  0xc040-0xc07f]
[   76.554310] pci 0000:00:04.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
[   76.576438] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[   76.582276] pci 0000:00:05.0: reg 10: [io  0xc080-0xc0bf]
[   76.586293] pci 0000:00:05.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[   76.609257] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[   76.614308] pci 0000:00:06.0: reg 10: [io  0xc0c0-0xc0ff]
[   76.619291] pci 0000:00:06.0: reg 14: [mem 0xfebf3000-0xfebf3fff]
[   76.642362] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[   76.647294] pci 0000:00:07.0: reg 10: [io  0xc100-0xc13f]
[   76.652308] pci 0000:00:07.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[   76.675304] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[   76.680308] pci 0000:00:08.0: reg 10: [io  0xc140-0xc17f]
[   76.685298] pci 0000:00:08.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[   76.707444] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[   76.713291] pci 0000:00:09.0: reg 10: [io  0xc180-0xc1bf]
[   76.717390] pci 0000:00:09.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[   76.737000] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[   76.738000] pci 0000:00:0a.0: reg 10: [mem 0xfebf7000-0xfebf700f]
[   76.806690] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   81.100614]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[   81.105242] device: '0000:00:00.0': device_add
[   84.458508] bus: 'pci': add device 0000:00:00.0
[   84.499434] PM: Adding info for pci:0000:00:00.0
[   84.511257] device: '0000:00:01.0': device_add
[   88.431287] bus: 'pci': add device 0000:00:01.0
[   88.473414] PM: Adding info for pci:0000:00:01.0
[   88.483212] device: '0000:00:01.1': device_add
[   92.320744] bus: 'pci': add device 0000:00:01.1
[   92.371504] PM: Adding info for pci:0000:00:01.1
[   92.382377] device: '0000:00:01.3': device_add
[   96.185687] bus: 'pci': add device 0000:00:01.3
[   96.262749] PM: Adding info for pci:0000:00:01.3
[   96.275476] device: '0000:00:02.0': device_add
[  100.745405] bus: 'pci': add device 0000:00:02.0
[  100.786341] PM: Adding info for pci:0000:00:02.0
[  100.795313] device: '0000:00:03.0': device_add
[  104.542390] bus: 'pci': add device 0000:00:03.0
[  104.578530] PM: Adding info for pci:0000:00:03.0
[  104.594332] device: '0000:00:04.0': device_add
[  107.936372] bus: 'pci': add device 0000:00:04.0
[  107.974345] PM: Adding info for pci:0000:00:04.0
[  107.982258] device: '0000:00:05.0': device_add
[  111.498401] bus: 'pci': add device 0000:00:05.0
[  111.536358] PM: Adding info for pci:0000:00:05.0
[  111.545265] device: '0000:00:06.0': device_add
[  115.134363] bus: 'pci': add device 0000:00:06.0
[  115.214442] PM: Adding info for pci:0000:00:06.0
[  115.224264] device: '0000:00:07.0': device_add
[  118.825393] bus: 'pci': add device 0000:00:07.0
[  118.863225] PM: Adding info for pci:0000:00:07.0
[  118.871263] device: '0000:00:08.0': device_add
[  122.869395] bus: 'pci': add device 0000:00:08.0
[  122.905344] PM: Adding info for pci:0000:00:08.0
[  122.913262] device: '0000:00:09.0': device_add
[  127.265448] bus: 'pci': add device 0000:00:09.0
[  127.315442] PM: Adding info for pci:0000:00:09.0
[  127.327263] device: '0000:00:0a.0': device_add
[  130.986291] bus: 'pci': add device 0000:00:0a.0
[  131.023342] PM: Adding info for pci:0000:00:0a.0
[  131.030835] driver: 'PNP0A03:00': driver_bound: bound to device 'pci_root'
[  131.031358] bus: 'acpi': really_probe: bound device PNP0A03:00 to driver pci_root
[  131.042420] bus: 'acpi': add driver pci_link
[  131.049858] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 with driver pci_link
[  131.050236] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:00
[  131.279353] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[  131.338377] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_link'
[  131.340375] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver pci_link
[  131.342426] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 with driver pci_link
[  131.344232] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:01
[  131.558241] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[  131.615276] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_link'
[  131.617361] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver pci_link
[  131.619422] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 with driver pci_link
[  131.620236] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:02
[  132.106621] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[  132.225492] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_link'
[  132.229473] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver pci_link
[  132.233717] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 with driver pci_link
[  132.234609] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:03
[  132.666425] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[  132.790489] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_link'
[  132.793736] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver pci_link
[  132.798444] bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 with driver pci_link
[  132.801550] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:04
[  133.205404] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[  133.296612] driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_link'
[  133.300442] bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver pci_link
[  133.383680] bus: 'pnp': registered
[  133.442445] bus: 'xen-backend': registered
[  133.506385] bus: 'xen': registered
[  133.512430] device class 'misc': registering
[  133.573422] device: 'vga_arbiter': device_add
[  133.703522] PM: Adding info for No Bus:vga_arbiter
[  133.743000] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[  133.747504] vgaarb: loaded
[  133.750506] vgaarb: bridge control possible 0000:00:02.0
[  133.753402] bus: 'spi': add driver wm831x
[  133.784422] bus: 'spi': add driver tps65912
[  133.817420] bus: 'spi': add driver ezx-pcap
[  133.851493] bus: 'spi': add driver da9052
[  133.926221] bus: 'serio': registered
[  133.927339] device class 'input': registering
[  133.938237] device class 'rtc': registering
[  133.948820] device class 'power_supply': registering
[  133.958694] device class 'watchdog': registering
[  133.970256] device class 'devfreq': registering
[  133.979374] PCI: Using ACPI for IRQ routing
[  133.981517] PCI: pci_cache_line_size set to 64 bytes
[  133.990459] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[  133.995392] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[  133.999346] device class 'net': registering
[  134.031241] device: 'lo': device_add
[  134.124346] PM: Adding info for No Bus:lo
[  134.248341] Switching to clocksource hpet
[  134.262089] CE: hpet increased min_delta_ns to 5000 nsec
[  134.451797] Warning: could not register all branches stats
[  134.457920] Warning: could not register annotated branches stats
[  161.465887] bus: 'pnp': add driver system
[  161.480794] pnp: PnP ACPI init
[  161.485894] device: 'pnp0': device_add
[  161.494668] PM: Adding info for No Bus:pnp0
[  161.496682] ACPI: bus type pnp registered
[  161.540750] pnp 00:00: [bus 00-ff]
[  161.544347] pnp 00:00: [io  0x0cf8-0x0cff]
[  161.547133] pnp 00:00: [io  0x0000-0x0cf7 window]
[  161.549780] pnp 00:00: [io  0x0d00-0xffff window]
[  161.553590] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[  161.556475] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[  161.564012] device: '00:00': device_add
[  161.573857] bus: 'pnp': add device 00:00
[  161.590233] PM: Adding info for pnp:00:00
[  161.600894] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[  161.650029] pnp 00:01: [io  0x0070-0x0071]
[  161.654654] pnp 00:01: [irq 8]
[  161.657932] pnp 00:01: [io  0x0072-0x0077]
[  161.662456] device: '00:01': device_add
[  161.678614] bus: 'pnp': add device 00:01
[  161.694635] PM: Adding info for pnp:00:01
[  161.701972] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[  161.821660] pnp 00:02: [io  0x0060]
[  161.824155] pnp 00:02: [io  0x0064]
[  161.826886] pnp 00:02: [irq 1]
[  161.831136] device: '00:02': device_add
[  161.844607] bus: 'pnp': add device 00:02
[  161.859975] PM: Adding info for pnp:00:02
[  161.867877] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[  161.994104] pnp 00:03: [irq 12]
[  161.998701] device: '00:03': device_add
[  162.013700] bus: 'pnp': add device 00:03
[  162.029974] PM: Adding info for pnp:00:03
[  162.037871] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[  162.172140] pnp 00:04: [io  0x03f2-0x03f5]
[  162.174986] pnp 00:04: [io  0x03f7]
[  162.177997] pnp 00:04: [irq 6]
[  162.181411] pnp 00:04: [dma 2]
[  162.185624] device: '00:04': device_add
[  162.202686] bus: 'pnp': add device 00:04
[  162.219581] PM: Adding info for pnp:00:04
[  162.227928] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[  162.460651] pnp 00:05: [io  0x0378-0x037f]
[  162.463658] pnp 00:05: [irq 7]
[  162.468113] device: '00:05': device_add
[  162.483646] bus: 'pnp': add device 00:05
[  162.499992] PM: Adding info for pnp:00:05
[  162.507710] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[  162.737959] pnp 00:06: [io  0x03f8-0x03ff]
[  162.740927] pnp 00:06: [irq 4]
[  162.744990] device: '00:06': device_add
[  162.759719] bus: 'pnp': add device 00:06
[  162.774618] PM: Adding info for pnp:00:06
[  162.782863] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[  163.436760] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[  163.440861] device: '00:07': device_add
[  163.456579] bus: 'pnp': add device 00:07
[  163.472567] PM: Adding info for pnp:00:07
[  163.479851] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[  164.117742] pnp: PnP ACPI: found 8 devices
[  164.119845] ACPI: ACPI bus type pnp unregistered
[  164.130104] device class 'mem': registering
[  164.145032] device: 'mem': device_add
[  164.176753] PM: Adding info for No Bus:mem
[  164.189164] device: 'kmem': device_add
[  164.214947] PM: Adding info for No Bus:kmem
[  164.225126] device: 'null': device_add
[  164.250190] PM: Adding info for No Bus:null
[  164.260107] device: 'port': device_add
[  164.285770] PM: Adding info for No Bus:port
[  164.295025] device: 'zero': device_add
[  164.320839] PM: Adding info for No Bus:zero
[  164.330047] device: 'full': device_add
[  164.355193] PM: Adding info for No Bus:full
[  164.364956] device: 'random': device_add
[  164.391810] PM: Adding info for No Bus:random
[  164.401123] device: 'urandom': device_add
[  164.428702] PM: Adding info for No Bus:urandom
[  164.437977] device: 'kmsg': device_add
[  164.463119] PM: Adding info for No Bus:kmsg
[  164.474050] device: 'oldmem': device_add
[  164.498875] PM: Adding info for No Bus:oldmem
[  164.511129] device: 'tty': device_add
[  164.541799] PM: Adding info for No Bus:tty
[  164.558572] device: 'console': device_add
[  164.585589] PM: Adding info for No Bus:console
[  164.594822] device class 'thermal': registering
[  164.640780] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[  164.642568] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[  164.644040] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[  164.645689] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[  164.688797] NET: Registered protocol family 2
[  164.824023] TCP established hash table entries: 8192 (order: 5, 131072 bytes)
[  164.851831] TCP bind hash table entries: 8192 (order: 7, 524288 bytes)
[  164.915831] TCP: Hash tables configured (established 8192 bind 8192)
[  164.933807] TCP: reno registered
[  164.941003] UDP hash table entries: 256 (order: 3, 40960 bytes)
[  164.950868] UDP-Lite hash table entries: 256 (order: 3, 40960 bytes)
[  164.993138] NET: Registered protocol family 1
[  164.994887] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[  164.997122] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[  165.000022] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[  165.002868] pci 0000:00:02.0: Boot video device
[  165.006999] PCI: CLS 0 bytes, default 64
[  165.169891] Unpacking initramfs...
[  313.310660] hrtimer: interrupt took 2797250 ns
[  552.428881] Freeing initrd memory: 23656k freed
[  591.985016] DMA-API: preallocated 32768 debug entries
[  591.986507] DMA-API: debugging enabled by kernel config
[  592.072738] Registering platform device 'pcspkr'. Parent at platform
[  592.075115] device: 'pcspkr': device_add
[  592.080996] bus: 'platform': add device pcspkr
[  592.092153] PM: Adding info for platform:pcspkr
[  592.121563] device: 'snapshot': device_add
[  592.148829] PM: Adding info for No Bus:snapshot
[  592.180299] bus: 'clocksource': registered
[  592.184146] device: 'clocksource': device_add
[  592.191676] PM: Adding info for No Bus:clocksource
[  592.195997] device: 'clocksource0': device_add
[  592.201808] bus: 'clocksource': add device clocksource0
[  592.211222] PM: Adding info for clocksource:clocksource0
[  592.228951] bus: 'platform': add driver alarmtimer
[  592.247485] Registering platform device 'alarmtimer'. Parent at platform
[  592.250154] device: 'alarmtimer': device_add
[  592.256173] bus: 'platform': add device alarmtimer
[  592.266755] PM: Adding info for platform:alarmtimer
[  592.273605] bus: 'platform': driver_probe_device: matched device alarmtimer with driver alarmtimer
[  592.275631] bus: 'platform': really_probe: probing driver alarmtimer with device alarmtimer
[  592.283575] driver: 'alarmtimer': driver_bound: bound to device 'alarmtimer'
[  592.285421] bus: 'platform': really_probe: bound device alarmtimer to driver alarmtimer
[  592.295782] Initialise module verification
[  593.080133] Testing tracer function: 
[  593.149895] ------------[ cut here ]------------
[  593.149895] WARNING: at /c/kernel-tests/src/stable/kernel/lockdep.c:3545 check_flags+0x1c8/0x1d0()
[  593.149895] Modules linked in:
[  593.149895] Pid: 1, comm: swapper/0 Not tainted 3.7.0-rc1-12129-gee2dd3c #3
[  593.149895] Call Trace:
[  593.149895]  <IRQ>  [<ffffffff810734cf>] warn_slowpath_common+0x8f/0xc0
[  593.149895]  [<ffffffff8107351a>] warn_slowpath_null+0x1a/0x20
[  593.149895]  [<ffffffff810fac08>] check_flags+0x1c8/0x1d0
[  593.149895]  [<ffffffff810fbfed>] lock_is_held+0x4d/0xa0
[  593.149895]  [<ffffffff8156d570>] ? notify_die+0x30/0x30
[  593.149895]  [<ffffffff81081b13>] ? __local_bh_enable+0x1d3/0x230
[  593.149895]  [<ffffffff81133cdf>] rcu_read_lock_held+0x7f/0x90
[  593.149895]  [<ffffffff81134208>] ftrace_ops_no_ops+0x188/0x190
[  593.149895]  [<ffffffff81573872>] trace+0x55/0x93
[  593.149895]  [<ffffffff81573872>] ? trace+0x55/0x93
[  593.149895]  [<ffffffff81566fc9>] ? _raw_spin_unlock_irq+0x99/0xc0
[  593.149895]  [<ffffffff8156d575>] ? sub_preempt_count+0x5/0x210
[  593.149895]  [<ffffffff8156d575>] ? sub_preempt_count+0x5/0x210
[  593.149895]  [<ffffffff81081b13>] ? __local_bh_enable+0x1d3/0x230
[  593.149895]  [<ffffffff810827ea>] __do_softirq+0x42a/0x710
[  593.149895]  [<ffffffff81574c7c>] call_softirq+0x1c/0x30
[  593.149895]  [<ffffffff81028a05>] do_softirq+0x1d5/0x2a0
[  593.149895]  [<ffffffff81082d3d>] irq_exit+0xad/0xc0
[  593.149895]  [<ffffffff81028035>] do_IRQ+0x75/0x100
[  593.149895]  [<ffffffff81567c72>] common_interrupt+0x72/0x72
[  593.149895]  <EOI>  [<ffffffff810fafbb>] ? mark_held_locks+0x9b/0x100
[  593.149895]  [<ffffffff815675f3>] ? _raw_spin_unlock_irqrestore+0xd3/0x130
[  593.149895]  [<ffffffff81307487>] __debug_object_init+0x1b7/0x580
[  593.149895]  [<ffffffff813078c6>] debug_object_init_on_stack+0x36/0x40
[  593.149895]  [<ffffffff8108a565>] init_timer_on_stack_key+0x35/0x80
[  593.149895]  [<ffffffff815616fb>] schedule_timeout+0x8b/0x470
[  593.149895]  [<ffffffff81573872>] ? trace+0x55/0x93
[  593.149895]  [<ffffffff81562fb7>] ? __mutex_unlock_slowpath+0x247/0x380
[  593.149895]  [<ffffffff81133487>] ? update_ftrace_function+0x17/0x150
[  593.149895]  [<ffffffff81561afe>] schedule_timeout_uninterruptible+0x1e/0x20
[  593.149895]  [<ffffffff8108ea60>] msleep+0x20/0x30
[  593.149895]  [<ffffffff81145a6a>] trace_selftest_startup_function+0xda/0x2b0
[  593.149895]  [<ffffffff81146c4c>] register_tracer+0x32c/0x430
[  593.149895]  [<ffffffff81c3aee4>] ? init_trace_printk_function_export+0x48/0x48
[  593.149895]  [<ffffffff81c3aef4>] init_function_trace+0x10/0x12
[  593.149895]  [<ffffffff8100223a>] do_one_initcall+0x1aa/0x270
[  593.149895]  [<ffffffff815313bc>] kernel_init+0x11c/0x370
[  593.149895]  [<ffffffff81c17878>] ? do_early_param+0xc6/0xc6
[  593.149895]  [<ffffffff810ca474>] ? schedule_tail+0x34/0x110
[  593.149895]  [<ffffffff815312a0>] ? rest_init+0x170/0x170
[  593.149895]  [<ffffffff815739ac>] ret_from_fork+0x7c/0xb0
[  593.149895]  [<ffffffff815312a0>] ? rest_init+0x170/0x170
[  593.149895] ---[ end trace 7b7690b588704ed7 ]---
[  593.149895] irq event stamp: 5027138
[  593.149895] hardirqs last  enabled at (5027136): [<ffffffff8114c3fa>] function_trace_call+0x16a/0x230
[  593.149895] hardirqs last disabled at (5027137): [<ffffffff810827a1>] __do_softirq+0x3e1/0x710
[  593.149895] softirqs last  enabled at (5027138): [<ffffffff810827ea>] __do_softirq+0x42a/0x710
[  593.149895] softirqs last disabled at (5027123): [<ffffffff81574c7c>] call_softirq+0x1c/0x30
[  593.278168] PASSED
[  593.279724] Testing ftrace regs(no arch support): PASSED
[  593.325857] Testing tracer preemptoff: PASSED
[  593.464913] Testing tracer wakeup: PASSED
[  593.614166] Testing tracer wakeup_rt: PASSED
[  593.792631] bus: 'event_source': registered
[  593.797816] device: 'breakpoint': device_add
[  593.802746] bus: 'event_source': add device breakpoint
[  593.811587] PM: Adding info for event_source:breakpoint
[  593.819974] device: 'tracepoint': device_add
[  593.824503] bus: 'event_source': add device tracepoint
[  593.833144] PM: Adding info for event_source:tracepoint
[  593.841050] device: 'software': device_add
[  593.845455] bus: 'event_source': add device software
[  593.854803] PM: Adding info for event_source:software

--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.7.0-rc1-12129-gee2dd3c"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.7.0-rc1 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_USER_QS=y
CONFIG_RCU_USER_QS_FORCE=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_CGROUPS is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_IPC_NS=y
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
CONFIG_AIO=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_GENERIC_KERNEL_THREAD=y
CONFIG_GENERIC_KERNEL_EXECVE=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_RCU_USER_QS=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_RELA=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_MODULE_SIG=y
CONFIG_MODULE_SIG_FORCE=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
# CONFIG_MODULE_SIG_SHA256 is not set
CONFIG_MODULE_SIG_SHA384=y
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=m
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PRIVILEGED_GUEST=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=500
CONFIG_XEN_SAVE_RESTORE=y
CONFIG_XEN_DEBUG_FS=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_PARAVIRT_DEBUG=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS=4096
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_I8K=m
CONFIG_MICROCODE=m
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_CLEANCACHE is not set
CONFIG_FRONTSWAP=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
# CONFIG_X86_PAT is not set
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_XEN_PCIDEV_FRONTEND=y
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
# CONFIG_ISA_DMA_API is not set
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
# CONFIG_IA32_EMULATION is not set
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=m
CONFIG_XFRM_USER=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_IPCOMP=m
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
# CONFIG_IPV6_ROUTE_INFO is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_BEET=m
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=m
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_GRE is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=m

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
# CONFIG_IP_DCCP_CCID3 is not set

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
CONFIG_TIPC=m
CONFIG_TIPC_ADVANCED=y
CONFIG_TIPC_PORTS=8191
# CONFIG_ATM is not set
CONFIG_L2TP=m
# CONFIG_L2TP_DEBUGFS is not set
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
# CONFIG_L2TP_ETH is not set
# CONFIG_BRIDGE is not set
CONFIG_NET_DSA=m
# CONFIG_NET_DSA_TAG_DSA is not set
# CONFIG_NET_DSA_TAG_EDSA is not set
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=m
# CONFIG_VLAN_8021Q_GVRP is not set
CONFIG_DECNET=m
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=m
CONFIG_LLC2=m
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
CONFIG_X25=m
CONFIG_LAPB=m
# CONFIG_WAN_ROUTER is not set
CONFIG_PHONET=m
CONFIG_IEEE802154=m
# CONFIG_IEEE802154_6LOWPAN is not set
CONFIG_MAC802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
# CONFIG_NET_SCH_PRIO is not set
CONFIG_NET_SCH_MULTIQ=m
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=m
# CONFIG_NET_SCH_CHOKE is not set
CONFIG_NET_SCH_QFQ=m
# CONFIG_NET_SCH_CODEL is not set
# CONFIG_NET_SCH_FQ_CODEL is not set
CONFIG_NET_SCH_PLUG=m

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_EMATCH is not set
# CONFIG_NET_CLS_ACT is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=m
CONFIG_BATMAN_ADV=m
CONFIG_BATMAN_ADV_BLA=y
CONFIG_BATMAN_ADV_DEBUG=y
# CONFIG_OPENVSWITCH is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_BQL=y
CONFIG_BPF_JIT=y

#
# Network testing
#
# CONFIG_NET_DROP_MONITOR is not set
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
# CONFIG_CAN_BCM is not set
# CONFIG_CAN_GW is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_SLCAN is not set
# CONFIG_CAN_DEV is not set
CONFIG_CAN_DEBUG_DEVICES=y
CONFIG_IRDA=m

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
CONFIG_IRCOMM=m
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
CONFIG_IRDA_DEBUG=y

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#

#
# FIR device drivers
#
# CONFIG_VLSI_FIR is not set
# CONFIG_BT is not set
CONFIG_AF_RXRPC=m
CONFIG_AF_RXRPC_DEBUG=y
# CONFIG_RXKAD is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_SPY=y
CONFIG_CFG80211=m
CONFIG_NL80211_TESTMODE=y
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_REG_DEBUG=y
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
# CONFIG_CFG80211_DEFAULT_PS is not set
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
CONFIG_LIB80211=m
CONFIG_LIB80211_DEBUG=y
# CONFIG_MAC80211 is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_NET_9P=m
CONFIG_NET_9P_VIRTIO=m
CONFIG_NET_9P_DEBUG=y
CONFIG_CAIF=m
CONFIG_CAIF_DEBUG=y
# CONFIG_CAIF_NETDEV is not set
CONFIG_CAIF_USB=m
CONFIG_CEPH_LIB=m
CONFIG_CEPH_LIB_PRETTYDEBUG=y
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
CONFIG_NFC=m
# CONFIG_NFC_NCI is not set
# CONFIG_NFC_HCI is not set
CONFIG_NFC_LLCP=y

#
# Near Field Communication (NFC) devices
#
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=m
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
# CONFIG_OMAP_OCP2SCP is not set
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=m

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_OSD is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_XEN_BLKDEV_FRONTEND=m
# CONFIG_XEN_BLKDEV_BACKEND is not set
CONFIG_VIRTIO_BLK=m
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=m
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=m
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=m
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
CONFIG_DS1682=m
# CONFIG_TI_DAC7512 is not set
CONFIG_VMWARE_BALLOON=m
CONFIG_BMP085=y
# CONFIG_BMP085_I2C is not set
CONFIG_BMP085_SPI=m
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_C2PORT=m
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
CONFIG_EEPROM_93XX46=m
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=m
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
# CONFIG_SCSI_NETLINK is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=m
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_ENCLOSURE is not set
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
# CONFIG_SCSI_FC_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=m
# CONFIG_SCSI_DH_RDAC is not set
CONFIG_SCSI_DH_HP_SW=m
CONFIG_SCSI_DH_EMC=m
CONFIG_SCSI_DH_ALUA=m
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
CONFIG_TARGET_CORE=m
# CONFIG_TCM_IBLOCK is not set
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_LOOPBACK_TARGET=m
# CONFIG_ISCSI_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
CONFIG_DUMMY=m
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
CONFIG_MII=m
CONFIG_NET_TEAM=m
# CONFIG_NET_TEAM_MODE_BROADCAST is not set
CONFIG_NET_TEAM_MODE_ROUNDROBIN=m
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=m
CONFIG_NET_TEAM_MODE_LOADBALANCE=m
CONFIG_MACVLAN=m
# CONFIG_MACVTAP is not set
# CONFIG_VXLAN is not set
CONFIG_NETCONSOLE=m
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=m
CONFIG_VETH=m
CONFIG_VIRTIO_NET=m
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=m
# CONFIG_CAIF_SPI_SLAVE is not set
# CONFIG_CAIF_HSI is not set

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
CONFIG_NET_DSA_MV88E6060=m
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_NET_VENDOR_BROADCOM is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_CALXEDA_XGMAC=m
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_DNET=m
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DE600 is not set
CONFIG_DE620=m
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
# CONFIG_IXGBE is not set
# CONFIG_NET_VENDOR_I825XX is not set
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
CONFIG_NET_VENDOR_MICREL=y
CONFIG_KS8851=m
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
# CONFIG_NET_VENDOR_MICROCHIP is not set
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
CONFIG_ETHOC=m
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R8169 is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_SEEQ8005=m
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_EPIC100 is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_STMICRO=y
CONFIG_STMMAC_ETH=m
CONFIG_STMMAC_PLATFORM=y
# CONFIG_STMMAC_PCI is not set
# CONFIG_STMMAC_DEBUG_FS is not set
CONFIG_STMMAC_DA=y
CONFIG_STMMAC_RING=y
# CONFIG_STMMAC_CHAINED is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_NET_VENDOR_WIZNET is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
# CONFIG_AMD_PHY is not set
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
# CONFIG_BCM87XX_PHY is not set
CONFIG_ICPLUS_PHY=m
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=m
CONFIG_LSI_ET1011C_PHY=m
CONFIG_MICREL_PHY=m
CONFIG_MDIO_BITBANG=m
CONFIG_MDIO_GPIO=m
# CONFIG_MICREL_KS8995MA is not set
CONFIG_PLIP=m
# CONFIG_PPP is not set
CONFIG_SLIP=m
CONFIG_SLHC=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLIP_SMART=y
CONFIG_SLIP_MODE_SLIP6=y
CONFIG_WLAN=y
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
CONFIG_ATH_COMMON=m
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K_PCI is not set
# CONFIG_ATH6KL is not set
# CONFIG_BRCMFMAC is not set
# CONFIG_HOSTAP is not set
# CONFIG_IPW2100 is not set
CONFIG_LIBERTAS=m
CONFIG_LIBERTAS_SDIO=m
CONFIG_LIBERTAS_SPI=m
# CONFIG_LIBERTAS_DEBUG is not set
# CONFIG_LIBERTAS_MESH is not set
# CONFIG_WL_TI is not set
# CONFIG_MWIFIEX is not set

#
# WiMAX Wireless Broadband devices
#

#
# Enable USB support to see WiMAX USB drivers
#
CONFIG_WAN=y
# CONFIG_HDLC is not set
# CONFIG_DLCI is not set
CONFIG_LAPBETHER=m
CONFIG_X25_ASY=m
CONFIG_SBNI=m
CONFIG_SBNI_MULTILINE=y
# CONFIG_IEEE802154_DRIVERS is not set
CONFIG_XEN_NETDEV_FRONTEND=m
# CONFIG_XEN_NETDEV_BACKEND is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=m
# CONFIG_INPUT_SPARSEKMAP is not set
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=m
CONFIG_KEYBOARD_ADP5589=m
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
CONFIG_KEYBOARD_QT2160=m
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_GPIO=m
CONFIG_KEYBOARD_GPIO_POLLED=m
CONFIG_KEYBOARD_TCA6416=m
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
CONFIG_KEYBOARD_LM8323=m
CONFIG_KEYBOARD_LM8333=m
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
CONFIG_KEYBOARD_MPR121=m
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
CONFIG_KEYBOARD_STOWAWAY=m
CONFIG_KEYBOARD_SUNKBD=m
# CONFIG_KEYBOARD_OMAP4 is not set
CONFIG_KEYBOARD_XTKBD=m
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
CONFIG_MOUSE_SERIAL=m
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=m
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=m
# CONFIG_TOUCHSCREEN_AD7877 is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
CONFIG_TOUCHSCREEN_CYTTSP_CORE=m
# CONFIG_TOUCHSCREEN_CYTTSP_I2C is not set
CONFIG_TOUCHSCREEN_CYTTSP_SPI=m
# CONFIG_TOUCHSCREEN_DA9052 is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_EGALAX is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=m
CONFIG_TOUCHSCREEN_GUNZE=m
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=m
CONFIG_TOUCHSCREEN_WACOM_I2C=m
CONFIG_TOUCHSCREEN_MAX11801=m
CONFIG_TOUCHSCREEN_MCS5000=m
# CONFIG_TOUCHSCREEN_MMS114 is not set
CONFIG_TOUCHSCREEN_MTOUCH=m
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
CONFIG_TOUCHSCREEN_EDT_FT5X06=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_PIXCIR is not set
CONFIG_TOUCHSCREEN_WM831X=m
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=m
CONFIG_TOUCHSCREEN_TSC_SERIO=m
CONFIG_TOUCHSCREEN_TSC2005=m
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_TOUCHSCREEN_PCAP=m
CONFIG_TOUCHSCREEN_ST1232=m
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_INPUT_MISC is not set
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
CONFIG_N_HDLC=m
CONFIG_N_GSM=m
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y
CONFIG_STALDRV=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=m
CONFIG_SERIAL_MAX310X=y
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_IFX6X60=m
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_XILINX_PS_UART=m
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
# CONFIG_HVC_XEN is not set
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=m
CONFIG_R3964=m
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=m
# CONFIG_TCG_TIS is not set
CONFIG_TCG_TIS_I2C_INFINEON=m
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=m
# CONFIG_TCG_INFINEON is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_PCA9541 is not set
CONFIG_I2C_MUX_PCA954x=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=m
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
CONFIG_I2C_DEBUG_BUS=y
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=m
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_LM70_LLP=m
CONFIG_SPI_OC_TINY=m
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=m
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_XCOMM=m
CONFIG_SPI_XILINX=m
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_HSI is not set

#
# PPS support
#
# CONFIG_PPS is not set

#
# PPS generators support
#

#
# PTP clock support
#

#
# Enable Device Drivers -> PPS to see the PTP clock options.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=m
CONFIG_GPIO_DA9052=m
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=m
CONFIG_GPIO_IT8761E=m
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=m
CONFIG_GPIO_MAX7300=m
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=m
CONFIG_GPIO_TPS65912=m
CONFIG_GPIO_WM831X=m
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=m
# CONFIG_GPIO_MCP23S08 is not set
# CONFIG_GPIO_MC33880 is not set
CONFIG_GPIO_74X164=m

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=m
# CONFIG_WM831X_BACKUP is not set
CONFIG_WM831X_POWER=m
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=m
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9052 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_LP8727=m
# CONFIG_CHARGER_GPIO is not set
CONFIG_CHARGER_MANAGER=y
CONFIG_CHARGER_SMB347=m
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_AD7314 is not set
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADCXX=m
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DA9052_ADC=m
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=m
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=m
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM70=m
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=m
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=m
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4151=m
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_MAX1111=m
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=m
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=m
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_DME1737=m
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_ADS1015=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_ADS7871=m
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA2XX=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_VIA_CPUTEMP=m
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=m
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=m
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=m
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM831X=m
CONFIG_SENSORS_APPLESMC=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
# CONFIG_DA9052_WATCHDOG is not set
# CONFIG_WM831X_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=m
# CONFIG_HP_WATCHDOG is not set
CONFIG_SC1200_WDT=m
CONFIG_PC87413_WDT=m
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=m
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=m
# CONFIG_W83697HF_WDT is not set
CONFIG_W83697UG_WDT=m
CONFIG_W83877F_WDT=m
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
CONFIG_SBC_EPX_C3_WATCHDOG=m
CONFIG_XEN_WDT=m

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
CONFIG_HTC_PASIC3=m
CONFIG_MFD_LM3533=m
CONFIG_TPS6105X=m
CONFIG_TPS65010=m
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65217=m
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_SPI=y
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TMIO is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_ARIZONA=y
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_ARIZONA_SPI=m
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_ABX500_CORE is not set
CONFIG_EZX_PCAP=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_LPC_SCH is not set
# CONFIG_LPC_ICH is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_WL1273_CORE=m
# CONFIG_MFD_RETU is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=m
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
# CONFIG_REGULATOR_GPIO is not set
# CONFIG_REGULATOR_AD5398 is not set
# CONFIG_REGULATOR_ARIZONA is not set
# CONFIG_REGULATOR_DA9052 is not set
# CONFIG_REGULATOR_FAN53555 is not set
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_MAX8649=m
CONFIG_REGULATOR_MAX8660=m
# CONFIG_REGULATOR_MAX8952 is not set
# CONFIG_REGULATOR_PCAP is not set
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=m
# CONFIG_REGULATOR_TPS6105X is not set
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=m
# CONFIG_REGULATOR_TPS65217 is not set
# CONFIG_REGULATOR_TPS6524X is not set
CONFIG_REGULATOR_TPS65912=m
CONFIG_REGULATOR_WM831X=m
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=m
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
CONFIG_FB_SYS_FOPS=m
# CONFIG_FB_WMT_GE_ROPS is not set
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=m
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=m
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=m
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
CONFIG_FB_SM501=m
# CONFIG_FB_VIRTUAL is not set
CONFIG_XEN_FBDEV_FRONTEND=m
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=m
CONFIG_FB_AUO_K190X=m
# CONFIG_FB_AUO_K1900 is not set
# CONFIG_FB_AUO_K1901 is not set
# CONFIG_EXYNOS_VIDEO is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
# CONFIG_SOUND is not set

#
# HID support
#
# CONFIG_HID is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_SSB is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_OMAP_USB2 is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_UWB is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_UNSAFE_RESUME=y
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
# CONFIG_MMC_BLOCK_BOUNCE is not set
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SPI is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3533 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP5521=m
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_PCA955X=m
# CONFIG_LEDS_PCA9633 is not set
CONFIG_LEDS_WM831X_STATUS=m
# CONFIG_LEDS_DA9052 is not set
# CONFIG_LEDS_DAC124S085 is not set
CONFIG_LEDS_REGULATOR=m
CONFIG_LEDS_BD2802=m
CONFIG_LEDS_LT3593=m
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_LM355x=m
CONFIG_LEDS_OT200=m
CONFIG_LEDS_BLINKM=m
# CONFIG_LEDS_TRIGGERS is not set

#
# LED Triggers
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=m
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
# CONFIG_RTC_DRV_ISL12022 is not set
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
# CONFIG_RTC_DRV_M41T80 is not set
CONFIG_RTC_DRV_BQ32K=m
CONFIG_RTC_DRV_S35390A=m
CONFIG_RTC_DRV_FM3130=m
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
CONFIG_RTC_DRV_EM3027=m
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
CONFIG_RTC_DRV_M41T94=m
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1390 is not set
CONFIG_RTC_DRV_MAX6902=m
# CONFIG_RTC_DRV_R9701 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_DS3234 is not set
CONFIG_RTC_DRV_PCF2123=m

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_DA9052=m
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=m
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=m
CONFIG_RTC_DRV_DS2404=m
# CONFIG_RTC_DRV_WM831X is not set

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_PCAP=m
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
# CONFIG_CFAG12864B is not set
CONFIG_UIO=m
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV=m
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
CONFIG_VIRTIO=m

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=m
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set

#
# Xen driver support
#
CONFIG_XEN_BALLOON=y
# CONFIG_XEN_BALLOON_MEMORY_HOTPLUG is not set
# CONFIG_XEN_SCRUB_PAGES is not set
# CONFIG_XEN_DEV_EVTCHN is not set
CONFIG_XEN_BACKEND=y
CONFIG_XENFS=m
CONFIG_XEN_COMPAT_XENFS=y
# CONFIG_XEN_SYS_HYPERVISOR is not set
CONFIG_XEN_XENBUS_FRONTEND=y
CONFIG_XEN_GNTDEV=m
CONFIG_XEN_GRANT_DEV_ALLOC=m
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_TMEM=y
CONFIG_XEN_PCIDEV_BACKEND=m
CONFIG_XEN_PRIVCMD=m
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_Q10 is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set

#
# Remoteproc drivers (EXPERIMENTAL)
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers (EXPERIMENTAL)
#
# CONFIG_VIRT_DRIVERS is not set
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
# CONFIG_EXTCON_ARIZONA is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=m
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4_FS is not set
CONFIG_FS_XIP=y
CONFIG_JBD=m
CONFIG_JBD_DEBUG=y
CONFIG_FS_MBCACHE=m
CONFIG_REISERFS_FS=m
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_FS_XATTR=y
# CONFIG_REISERFS_FS_POSIX_ACL is not set
# CONFIG_REISERFS_FS_SECURITY is not set
CONFIG_JFS_FS=m
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=m
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=m
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=m
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=m
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
# CONFIG_QFMT_V1 is not set
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m
# CONFIG_CUSE is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=m
# CONFIG_ADFS_FS_RW is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=m
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
CONFIG_EFS_FS=m
CONFIG_LOGFS=m
CONFIG_CRAMFS=m
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
CONFIG_OMFS_FS=m
CONFIG_HPFS_FS=m
CONFIG_QNX4FS_FS=m
CONFIG_QNX6FS_FS=m
# CONFIG_QNX6FS_DEBUG is not set
CONFIG_ROMFS_FS=m
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
CONFIG_PSTORE_FTRACE=y
# CONFIG_PSTORE_RAM is not set
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_EXOFS_FS=m
# CONFIG_EXOFS_DEBUG is not set
CONFIG_ORE=m
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NFS_FS is not set
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_CEPH_FS=m
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
# CONFIG_9P_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=m
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=m
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=m
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=m
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=m
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=m
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
# CONFIG_DEBUG_OBJECTS_FREE is not set
CONFIG_DEBUG_OBJECTS_TIMERS=y
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_DEBUG_ON=y
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_PREEMPT=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
# CONFIG_PROVE_RCU_DELAY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_BUGVERBOSE is not set
# CONFIG_DEBUG_INFO is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_LIST is not set
CONFIG_TEST_LIST_SORT=y
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
# CONFIG_RCU_CPU_STALL_INFO is not set
CONFIG_RCU_TRACE=y
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_BLOCK_EXT_DEVT=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_LKDTM=m
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAIL_MMC_REQUEST is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
# CONFIG_EVENT_POWER_TRACING_DEPRECATED is not set
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
# CONFIG_FUNCTION_GRAPH_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_PREEMPT_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
# CONFIG_BRANCH_TRACER is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_DYNAMIC_FTRACE is not set
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_EVENT_TRACE_TEST_SYSCALLS=y
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
CONFIG_RBTREE_TEST=m
CONFIG_INTERVAL_TREE_TEST=m
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_KSTRTOX=m
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=m
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_XOR=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=m
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER_X86=m
CONFIG_CRYPTO_GLUE_HELPER_X86=m

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=m
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=m
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_GHASH=m
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=m
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=m
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA1_SSSE3=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA=m
# CONFIG_CRYPTO_CAMELLIA_X86_64 is not set
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=m
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_X86_64=m
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=m
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
CONFIG_CRYPTO_TEA=m
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=m
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_USER_API=m
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=m
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
# CONFIG_VHOST_NET is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_CRC8=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=m
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y

--n8g4imXOkfNTN/H1--
