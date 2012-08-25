Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab2HYDgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 23:36:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:3771 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586Ab2HYDga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 23:36:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,309,1344236400"; 
   d="scan'208";a="211083817"
Date: Sat, 25 Aug 2012 11:36:23 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: INFO: suspicious RCU usage in rcu_torture_writer()
Message-ID: <20120825033623.GA19330@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got this warning on 3.6.0-rc2. Full dmesg/config attached.

[    3.051375] Initializing RT-Tester: OK
[    3.052491] rcu-torture:--- Start of test: nreaders=2 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stut
ter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/1 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 onoff_interval=0 onoff_holdoff=0
[    3.059084] 
[    3.059451] ===============================
[    3.060454] [ INFO: suspicious RCU usage. ]
[    3.061482] 3.6.0-rc2-00010-g4c58c42 #59 Not tainted
[    3.062686] -------------------------------
[    3.063744] /c/kernel-tests/src/stable/kernel/rcutorture.c:990 suspicious rcu_dereference_check() usage!

 982         do {
 983                 schedule_timeout_uninterruptible(1);
 984                 rp = rcu_torture_alloc();
 985                 if (rp == NULL)
 986                         continue;
 987                 rp->rtort_pipe_count = 0;
 988                 udelay(rcu_random(&rand) & 0x3ff);
 989                 old_rp = rcu_dereference_check(rcu_torture_current,
>990                                                current == writer_task);
 991                 rp->rtort_mbtest = 1;
 992                 rcu_assign_pointer(rcu_torture_current, rp);
 993                 smp_wmb(); /* Mods to old_rp must follow rcu_assign_pointer() */
 994                 if (old_rp) {

Thanks,
Fengguang

--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-waimea-21045-2012-08-25-10-05-59-3.6.0-rc2-00010-g4c58c42-59"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.0-rc2-00010-g4c58c42 (kbuild@kbuild) (gcc version 4.7.1 (Debian 4.7.1-6) ) #59 PREEMPT Sat Aug 25 10:02:09 CST 2012
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x100000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at [c00fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x02ffffff]
[    0.000000] Base memory trampoline at [c008f000] 8f000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x0fbfffff] page 2M
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x02ffa000-0x02ffffff]
[    0.000000] cma: CMA: reserved 28 MiB at 0c800000
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 129004(98%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 0ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1eb57e1, boot clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00010000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000] free_area_init_node: node 0, pgdat c206e674, node_mem_map ce53f200
[    0.000000]   Normal zone: 512 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 64897 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] mapped IOAPIC to ffff9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1eb5780
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64897
[    0.000000] Kernel command line: trinity=2m hung_task_panic=1 branch=samsung/dma-mapping-next log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2012-08-25-10-02-26-samsung:dma-mapping-next:4c58c42-4c58c42-i386-randconfig-k809-8-waimea BOOT_IMAGE=kernel-tests/kernels/i386-randconfig-k809/4c58c42/vmlinuz-3.6.0-rc2-00010-g4c58c42
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 170200k/262136k available (10017k kernel code, 91436k reserved, 9512k data, 716k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff8c000 - 0xfffff000   ( 460 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff7fe000   ( 752 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc2313000 - 0xc23c6000   ( 716 kB)
[    0.000000]       .data : 0xc19c8401 - 0xc23126e0   (9512 kB)
[    0.000000]       .text : 0xc1000000 - 0xc19c8401   (10017 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=cbc02000 soft=cbc04000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ODEBUG: 15 of 15 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 3300.196 MHz processor
[    0.001999] Calibrating delay loop (skipped) preset value.. 6600.39 BogoMIPS (lpj=3300196)
[    0.003010] pid_max: default: 32768 minimum: 301
[    0.003788] Mount-cache hash table entries: 512
[    0.005810] Initializing cgroup subsys cpuacct
[    0.006014] Initializing cgroup subsys devices
[    0.007020] Initializing cgroup subsys freezer
[    0.008016] Initializing cgroup subsys net_cls
[    0.009185] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.009185] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.009185] tlb_flushall_shift is 0x6
[    0.010008] CPU: Intel Common KVM processor stepping 01
[    0.015341] ACPI: Core revision 20120711
[    0.027851] ftrace: allocating 28838 entries in 57 pages
[    0.038199] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.041316] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.042008] Getting VERSION: 50014
[    0.042519] Getting VERSION: 50014
[    0.043009] Getting ID: 0
[    0.043417] Getting ID: f000000
[    0.044008] Getting LVT0: 8700
[    0.044519] Getting LVT1: 8400
[    0.045063] enabled ExtINT on CPU#0
[    0.047105] ENABLING IO-APIC IRQs
[    0.047620] init IO_APIC IRQs
[    0.048003]  apic 2 pin 0 not connected
[    0.048598] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.049028] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.050027] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.051024] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.052026] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.053025] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.054024] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.055024] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.056023] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.057024] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.058024] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.059023] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.060024] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.061056] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.062023] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.063017]  apic 2 pin 16 not connected
[    0.063999]  apic 2 pin 17 not connected
[    0.064587]  apic 2 pin 18 not connected
[    0.064998]  apic 2 pin 19 not connected
[    0.065999]  apic 2 pin 20 not connected
[    0.066998]  apic 2 pin 21 not connected
[    0.067998]  apic 2 pin 22 not connected
[    0.068997]  apic 2 pin 23 not connected
[    0.069710] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.069997] Using local APIC timer interrupts.
[    0.069997] calibrating APIC timer ...
[    0.071989] ... lapic delta = 13812511
[    0.071989] ... PM-Timer delta = 791080
[    0.071989] APIC calibration not consistent with PM-Timer: 221ms instead of 100ms
[    0.071989] APIC delta adjusted to PM-Timer: 6249991 (13812511)
[    0.071989] TSC delta adjusted to PM-Timer: 330019444 (729344503)
[    0.071989] ..... delta 6249991
[    0.071989] ..... mult: 268475877
[    0.071989] ..... calibration result: 999998
[    0.071989] ..... CPU clock speed is 3300.0194 MHz.
[    0.071989] ..... host bus clock speed is 999.0998 MHz.
[    0.074975] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.083012] NET: Registered protocol family 16
[    0.086630] EISA bus registered
[    0.088135] ACPI: bus type pci registered
[    0.089495] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=0
[    0.090993] PCI: Using configuration type 1 for base access
[    0.118680] bio: create slab <bio-0> at 0
[    0.119281] ACPI: Added _OSI(Module Device)
[    0.119996] ACPI: Added _OSI(Processor Device)
[    0.120995] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.123019] ACPI: Added _OSI(Processor Aggregator Device)
[    0.128848] ACPI: EC: Look up EC in DSDT
[    0.153089] ACPI: Interpreter enabled
[    0.153901] ACPI: (supports S0 S5)
[    0.154229] ACPI: Using IOAPIC for interrupt routing
[    0.181132] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.183076] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.184083] pci_root PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.187038] PCI host bridge to bus 0000:00
[    0.187951] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under domain [bus 00-ff]
[    0.188979] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.190980] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.191981] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.193980] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.194980] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebfffff]
[    0.197068] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.199161] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.201184] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.204458] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    0.206912] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.208558] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.209991] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.212224] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.215082] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.218685] pci 0000:00:02.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    0.226608] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.229180] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.231018] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.233020] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.238014] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.240142] pci 0000:00:04.0: [8086:2668] type 00 class 0x040300
[    0.242035] pci 0000:00:04.0: reg 10: [mem 0xfebf0000-0xfebf3fff]
[    0.246276] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.248016] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    0.250385] pci 0000:00:05.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    0.256209] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.258022] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    0.260013] pci 0000:00:06.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    0.266099] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.267405] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.269704] pci 0000:00:07.0: reg 14: [mem 0xfebf7000-0xfebf7fff]
[    0.275647] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.277467] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    0.279381] pci 0000:00:08.0: reg 14: [mem 0xfebf8000-0xfebf8fff]
[    0.285262] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.287010] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    0.289007] pci 0000:00:09.0: reg 14: [mem 0xfebf9000-0xfebf9fff]
[    0.295125] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.297018] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    0.299008] pci 0000:00:0a.0: reg 14: [mem 0xfebfa000-0xfebfafff]
[    0.304673] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    0.306237] pci 0000:00:0b.0: reg 10: [mem 0xfebfb000-0xfebfb00f]
[    0.310692] pci_bus 0000:00: on NUMA node 0
[    0.311017] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.321425]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.379249] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.381134] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.383387] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.385685] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.387621] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.390741] SCSI subsystem initialized
[    0.390966] ACPI: bus type scsi registered
[    0.392044] libata version 3.00 loaded.
[    0.393987] ACPI: bus type usb registered
[    0.395005] usbcore: registered new interface driver usbfs
[    0.396002] usbcore: registered new interface driver hub
[    0.397102] usbcore: registered new device driver usb
[    0.399367] pps_core: LinuxPPS API ver. 1 registered
[    0.399946] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.403042] PCI: Using ACPI for IRQ routing
[    0.403951] PCI: pci_cache_line_size set to 64 bytes
[    0.405553] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    0.406958] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.409556] NET: Registered protocol family 8
[    0.409950] NET: Registered protocol family 20
[    0.412994] nfc: nfc_init: NFC Core ver 0.1
[    0.414033] NET: Registered protocol family 39
[    0.415050] cfg80211: Calling CRDA to update world regulatory domain
[    0.417510] Switching to clocksource kvm-clock
[    0.419275] Warning: could not register all branches stats
[    0.420500] Warning: could not register annotated branches stats
[    0.532520] pnp: PnP ACPI init
[    0.533364] ACPI: bus type pnp registered
[    0.534407] pnp 00:00: [bus 00-ff]
[    0.535212] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.536222] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.537412] pnp 00:00: [io  0x0d00-0xffff window]
[    0.538564] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.539863] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    0.541480] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.543104] pnp 00:01: [io  0x0070-0x0071]
[    0.544048] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.545867] pnp 00:01: [irq 8]
[    0.546612] pnp 00:01: [io  0x0072-0x0077]
[    0.547821] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.549815] pnp 00:02: [io  0x0060]
[    0.550767] pnp 00:02: [io  0x0064]
[    0.551643] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.553411] pnp 00:02: [irq 1]
[    0.554358] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.556047] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.558121] pnp 00:03: [irq 12]
[    0.559035] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.560824] pnp 00:04: [io  0x03f2-0x03f5]
[    0.561840] pnp 00:04: [io  0x03f7]
[    0.562640] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.564393] pnp 00:04: [irq 6]
[    0.565107] pnp 00:04: [dma 2]
[    0.566090] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.567962] pnp 00:05: [io  0x0378-0x037f]
[    0.568983] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.570948] pnp 00:05: [irq 7]
[    0.571897] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.573613] pnp 00:06: [io  0x03f8-0x03ff]
[    0.574541] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.576382] pnp 00:06: [irq 4]
[    0.577443] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.580108] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    0.581558] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.583842] pnp: PnP ACPI: found 8 devices
[    0.584763] ACPI: ACPI bus type pnp unregistered
[    0.624772] PM-Timer running at invalid rate: 108% of normal - aborting.
[    0.626609] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.627965] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.629336] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.630885] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    0.632458] NET: Registered protocol family 1
[    0.633571] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.635054] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.636512] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.646500] pci 0000:00:02.0: Boot video device
[    0.647790] PCI: CLS 0 bytes, default 64
[    0.649462] Unpacking initramfs...
[    2.525149] Freeing initrd memory: 25284k freed
[    3.032406] DMA-API: preallocated 32768 debug entries
[    3.033652] DMA-API: debugging enabled by kernel config
[    3.038152] The force parameter has not been set to 1 so the Iris poweroff handler will not be installed.
[    3.040442] NatSemi SCx200 Driver
[    3.043891] cryptomgr_test (17) used greatest stack depth: 7276 bytes left
[    3.051375] Initializing RT-Tester: OK
[    3.052491] rcu-torture:--- Start of test: nreaders=2 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/1 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 onoff_interval=0 onoff_holdoff=0
[    3.059084] 
[    3.059451] ===============================
[    3.060454] [ INFO: suspicious RCU usage. ]
[    3.061482] 3.6.0-rc2-00010-g4c58c42 #59 Not tainted
[    3.062686] -------------------------------
[    3.063744] /c/kernel-tests/src/stable/kernel/rcutorture.c:990 suspicious rcu_dereference_check() usage!
[    3.070158] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    3.076983] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    3.079498] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    3.080754] jffs2: version 2.2. (NAND) (SUMMARY)  
[    3.083776] QNX4 filesystem 0.2.3 registered.
[    3.085061] BeFS version: 0.9.3
[    3.085865] msgmni has been set to 437
[    3.091924] cryptomgr_test (43) used greatest stack depth: 6948 bytes left
[    3.097739] NET: Registered protocol family 38
[    3.099002] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    3.100869] io scheduler noop registered
[    3.101883] io scheduler deadline registered (default)
[    3.103175] io scheduler cfq registered
[    3.109329] 
[    3.109329] other info that might help us debug this:
[    3.109329] 
[    3.111397] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    3.113206] ACPI: Power Button [PWRF]
[    3.119370] r3964: Philips r3964 Driver $Revision: 1.10 $
[    3.121993] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.153885] 
[    3.153885] rcu_scheduler_active = 1, debug_locks = 1
[    3.155948] no locks held by rcu_torture_wri/27.
[    3.158297] 
[    3.158297] stack backtrace:
[    3.160399] Pid: 27, comm: rcu_torture_wri Not tainted 3.6.0-rc2-00010-g4c58c42 #59
[    3.162569] Call Trace:
[    3.163807]  [<c1095035>] lockdep_rcu_suspicious+0xd7/0xdf
[    3.165782]  [<c10b3bf3>] rcu_torture_writer+0x19e/0x27d
[    3.168880]  [<c10b3a55>] ? rcu_torture_fqs+0x100/0x100
[    3.170341]  [<c10676c0>] kthread+0x8d/0x92
[    3.171421]  [<c1067633>] ? insert_kthread_work+0xbd/0xbd
[    3.172876]  [<c19c7bc2>] kernel_thread_helper+0x6/0x10

[    3.507415] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.537680] DoubleTalk PC - not found
[    3.541934] Non-volatile memory driver v1.3
[    3.543601] scx200_gpio: no SCx200 gpio present
[    3.559607] nsc_gpio initializing
[    3.563874] telclk_interrupt = 0xf non-mcpbl0010 hw.
[    3.565397] ipmi message handler version 39.2
[    3.566811] IPMI System Interface driver.
[    3.587480] ipmi_si: Adding default-specified kcs state machine
[    3.590268] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[    3.592830] ipmi_si: Interface detection failed
[    3.600487] ipmi_si: Adding default-specified smic state machine
[    3.602497] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[    3.605443] ipmi_si: Interface detection failed
[    3.608567] ipmi_si: Adding default-specified bt state machine
[    3.631442] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[    3.633516] ipmi_si: Interface detection failed
[    3.635952] ipmi_si: Unable to find any System Interface(s)
[    3.662150] IPMI Watchdog: driver initialized
[    3.662875] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[    3.664591] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    3.684156] Hangcheck: Using getrawmonotonic().
[    3.717001] Compaq SMART2 Driver (v 2.6.0)
[    3.718281] HP CISS Driver (v 3.6.26)
[    3.722980] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    3.740790] lkdtm: No crash points registered, enable through debugfs
[    3.748126] usbcore: registered new interface driver pn533
[    3.749556] Uniform Multi-Platform E-IDE driver
[    3.757952] ide-gd driver 1.18
[    3.758907] ide-cd driver 5.00
[    3.779397] osst :I: Tape driver with OnStream support version 0.99.4
[    3.779397] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    3.785247] device id = 2440
[    3.785902] device id = 2480
[    3.795855] device id = 24c0
[    3.796552] device id = 24d0
[    3.797314] device id = 25a1
[    3.798079] device id = 2670
[    3.799162] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
[    3.800673] Could not find PAR responsible for SC520CDP Flash Bank #1
[    3.805816] Trying default address 0x8c00000
[    3.806834] SC520 CDP flash device: 0x800000 at 0x8800000
[    3.815143] Failed to ioremap_nocache
[    3.815924] NetSc520 flash device: 0x100000 at 0x200000
[    3.816974] Failed to ioremap_nocache
[    3.817740] Failed to ioremap_nocache
[    3.825181] scx200_docflash: NatSemi SCx200 DOCCS Flash Driver
[    3.903876] No recognised DiskOnChip devices found
[    3.905086] slram: not enough parameters.
[    3.989611] No valid DiskOnChip devices found
[    3.990856] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.993103] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    4.009666] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    4.011935] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    4.014209] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    4.031002] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    4.033671] NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba NAND 128MiB 1,8V 8-bit), page size: 512, OOB size: 16
[    4.036425] tsc: Refined TSC clocksource calibration: 3300.203 MHz
[    4.046229] flash size: 128 MiB
[    4.046745] page size: 512 bytes
[    4.047313] OOB area size: 16 bytes
[    4.047958] sector size: 16 KiB
[    4.048520] pages number: 262144
[    4.049112] pages per sector: 32
[    4.049619] bus width: 8
[    4.050147] bits in sector size: 14
[    4.050760] bits in page size: 9
[    4.051294] bits in OOB size: 4
[    4.121401] flash size with OOB: 135168 KiB
[    4.122304] page address bytes: 4
[    4.123003] sector address bytes: 3
[    4.123777] options: 0x42
[    4.124856] Scanning device for bad blocks
[    4.254134] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    4.270734] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    4.276481] usbcore: registered new interface driver alauda
[    4.301320] libphy: Fixed MDIO Bus: probed
[    4.319212] arcnet loaded.
[    4.319890] arcnet: RFC1051 "simple standard" (`s') encapsulation support loaded.
[    4.321823] arcnet: COM90xx chipset support
[    4.731466] S3: No ARCnet cards found.
[    4.742195] arcnet: COM90xx IO-mapped mode support (by David Woodhouse et el.)
[    4.744043] E-mail me if you actually test this driver, please!
[    4.745589]  arc%d: No autoprobe for IO mapped cards; you must specify the base address!
[    4.748384] arcnet: COM20020 ISA support (by David Woodhouse et al.)
[    4.749996]  arc%d: No autoprobe (yet) for IO mapped cards; you must specify the base address!
[    4.752640] PPP generic driver version 2.4.2
[    4.756799] PPP BSD Compression module registered
[    4.758805] PPP Deflate Compression module registered
[    4.760160] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256).
[    4.762375] airo(): Probing for PCI adapters
[    4.763601] airo(): Finished probing for PCI adapters
[    4.766329] usbcore: registered new interface driver zd1201
[    4.768821] libertas_sdio: Libertas SDIO driver
[    4.769979] libertas_sdio: Copyright Pierre Ossman
[    4.772169] usbcore: registered new interface driver i2400m_usb
[    4.773682] usbcore: registered new interface driver kaweth
[    4.775089] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[    4.777083] usbcore: registered new interface driver pegasus
[    4.778473] hso: /c/kernel-tests/src/stable/drivers/net/usb/hso.c: Option Wireless
[    4.781737] usbcore: registered new interface driver hso
[    4.783138] usbcore: registered new interface driver asix
[    4.784600] usbcore: registered new interface driver cdc_eem
[    4.786093] usbcore: registered new interface driver dm9601
[    4.787581] usbcore: registered new interface driver smsc75xx
[    4.789109] usbcore: registered new interface driver net1080
[    4.791671] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    4.793618] usbcore: registered new interface driver cdc_phonet
[    4.795165] usbcore: registered new interface driver sierra_net
[    4.796647] usbcore: registered new interface driver cdc_ncm
[    4.798160] fore200e: FORE Systems 200E-series ATM driver - version 0.3e
[    4.801100] idt77252_init: at c235016c
[    4.802146] adummy: version 1.0
[    4.804494] Fusion MPT base driver 3.04.20
[    4.805593] Copyright (c) 1999-2008 LSI Corporation
[    4.807139] Fusion MPT FC Host driver 3.04.20
[    4.808405] Fusion MPT SAS Host driver 3.04.20
[    4.809570] Fusion MPT LAN driver 3.04.20
[    4.812258] Generic UIO driver for PCI 2.3 devices version: 0.01.0
[    4.818907] aoe: AoE v47 initialised.
[    4.822611] usbcore: registered new interface driver hwa-rc
[    4.824278] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.828461] usbcore: registered new interface driver cdc_acm
[    4.830846] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[    4.832949] usbcore: registered new interface driver usblp
[    4.834561] usbcore: registered new interface driver libusual
[    4.836083] usbcore: registered new interface driver mdc800
[    4.837444] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
[    4.841997] usbcore: registered new interface driver usbserial
[    4.844114] usbcore: registered new interface driver usbserial_generic
[    4.846486] USB Serial support registered for generic
[    4.848629] usbserial: USB Serial Driver core
[    4.850566] usbcore: registered new interface driver ch341
[    4.852925] USB Serial support registered for ch341-uart
[    4.857755] usbcore: registered new interface driver cyberjack
[    4.860557] USB Serial support registered for Reiner SCT Cyberjack USB card reader
[    4.863876] usbcore: registered new interface driver cypress_m8
[    4.866777] USB Serial support registered for DeLorme Earthmate USB
[    4.869730] USB Serial support registered for HID->COM RS232 Adapter
[    4.872644] USB Serial support registered for Nokia CA-42 V2 Adapter
[    4.876740] usbcore: registered new interface driver io_edgeport
[    4.879593] USB Serial support registered for Edgeport 2 port adapter
[    4.882120] USB Serial support registered for Edgeport 4 port adapter
[    4.883731] USB Serial support registered for Edgeport 8 port adapter
[    4.885398] USB Serial support registered for EPiC device
[    4.886797] usbcore: registered new interface driver empeg
[    4.888939] USB Serial support registered for empeg
[    4.892653] usbcore: registered new interface driver f81232
[    4.894165] USB Serial support registered for f81232
[    4.895728] usbcore: registered new interface driver ftdi_sio
[    4.898094] USB Serial support registered for FTDI USB Serial Device
[    4.900355] ftdi_sio: v1.6.0:USB FTDI Serial Converters Driver
[    4.901901] usbcore: registered new interface driver funsoft
[    4.903945] USB Serial support registered for funsoft
[    4.906282] usbcore: registered new interface driver hp4x
[    4.908116] USB Serial support registered for hp4X
[    4.909376] usbcore: registered new interface driver ipaq
[    4.910781] USB Serial support registered for PocketPC PDA
[    4.912258] usbcore: registered new interface driver iuu_phoenix
[    4.914860] USB Serial support registered for iuu_phoenix
[    4.916569] usbcore: registered new interface driver keyspan
[    4.921813] USB Serial support registered for Keyspan - (without firmware)
[    4.925797] USB Serial support registered for Keyspan 1 port adapter
[    4.929128] USB Serial support registered for Keyspan 2 port adapter
[    4.931373] USB Serial support registered for Keyspan 4 port adapter
[    4.933882] usbcore: registered new interface driver kobil_sct
[    4.936740] USB Serial support registered for KOBIL USB smart card terminal
[    4.941336] usbcore: registered new interface driver mct_u232
[    4.942779] USB Serial support registered for MCT U232
[    4.944166] usbcore: registered new interface driver metro_usb
[    4.945661] USB Serial support registered for Metrologic USB to Serial
[    4.948107] usbcore: registered new interface driver mos7720
[    4.949534] USB Serial support registered for Moschip 2 port adapter
[    4.953270] usbcore: registered new interface driver mos7840
[    4.955340] USB Serial support registered for Moschip 7840/7820 USB Serial Driver
[    4.958425] usbcore: registered new interface driver navman
[    4.960956] USB Serial support registered for navman
[    4.963555] usbcore: registered new interface driver option
[    4.966131] USB Serial support registered for GSM modem (1-port)
[    4.969172] usbcore: registered new interface driver oti6858
[    4.972679] USB Serial support registered for oti6858
[    4.973996] usbcore: registered new interface driver pl2303
[    4.975506] USB Serial support registered for pl2303
[    4.976769] usbcore: registered new interface driver quatech2
[    4.978290] USB Serial support registered for Quatech 2nd gen USB to Serial Driver
[    4.980382] safe_serial: v0.1:USB Safe Encapsulated Serial
[    4.984416] usbcore: registered new interface driver safe_serial
[    4.988289] USB Serial support registered for safe_serial
[    4.990235] usbcore: registered new interface driver whiteheat
[    4.991670] USB Serial support registered for Connect Tech - WhiteHEAT - (prerenumeration)
[    4.995109] USB Serial support registered for Connect Tech - WhiteHEAT
[    4.997370] usbcore: registered new interface driver keyspan_pda
[    4.999918] USB Serial support registered for Keyspan PDA
[    5.004473] USB Serial support registered for Xircom / Entregra PGS - (prerenumeration)
[    5.006601] usbcore: registered new interface driver zio
[    5.008471] USB Serial support registered for zio
[    5.010267] usbcore: registered new interface driver cypress_cy7c63
[    5.012783] usbcore: registered new interface driver idmouse
[    5.014388] usbcore: registered new interface driver iowarrior
[    5.018309] usbcore: registered new interface driver ldusb
[    5.020186] usbcore: registered new interface driver usbtest
[    5.022392] usbcore: registered new interface driver trancevibrator
[    5.024480] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    5.029319] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.032057] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.034531] parkbd: no such parport
[    5.037088] mousedev: PS/2 mouse device common for all mice
[    5.038676] evbug: Connected device: input0 (Power Button at LNXPWRBN/button/input0)
[    5.044347] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    5.047781] evbug: Connected device: input1 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
[    5.050935] usbcore: registered new interface driver aiptek
[    5.055307] usbcore: registered new interface driver gtco
[    5.057445] cm109: Keymap for Komunikate KIP1000 phone loaded
[    5.060082] usbcore: registered new interface driver cm109
[    5.061803] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    5.064600] usbcore: registered new interface driver keyspan_remote
[    5.067571] wistron_btns: System unknown
[    5.069397] usbcore: registered new interface driver yealink
[    5.071806] rtc_cmos 00:01: RTC can wake from S4
[    5.076351] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[    5.078928] rtc0: alarms up to one day, 114 bytes nvram, hpet irqs
[    5.086147] rtc-test rtc-test.0: rtc core: registered test as rtc1
[    5.090367] rtc-test rtc-test.1: rtc core: registered test as rtc2
[    5.092886] pps_ldisc: PPS line discipline registered
[    5.114808] pps_parport: parallel port PPS client
[    5.116920] Driver for 1-wire Dallas network protocol.
[    5.121795] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
[    5.182809] applesmc: supported laptop not found!
[    5.183775] applesmc: driver init failed (ret=-19)!
[    5.203070] pc87360: PC8736x not detected, module not inserted
[    5.213406] ISDN subsystem Rev: 1.1.2.3/1.1.2.2/none/1.1.2.2/1.1.2.2
[    5.215369] Modular ISDN core version 1.1.29
[    5.216533] NET: Registered protocol family 34
[    5.236485] DSP module 2.0
[    5.237742] mISDN_dsp: DSP clocks every 64 samples. This equals 8 jiffies.
[    5.281603] AVM Fritz PCI driver Rev. 2.3
[    5.287769] Sedlbauer Speedfax+ Driver Rev. 2.0
[    5.296597] Winbond W6692 PCI driver Rev. 2.0
[    5.310950] Netjet PCI driver Rev. 2.0
[    5.320341] mISDNipac module version 2.0
[    5.328861] mISDN: ISAR driver Rev. 2.1
[    5.343951] dss1_divert module successfully installed
[    5.348567] HiSax: Linux Driver for passive ISDN cards
[    5.350468] HiSax: Version 3.5 (kernel)
[    5.355086] HiSax: Layer1 Revision 2.46.2.5
[    5.355906] HiSax: Layer2 Revision 2.30.2.4
[    5.356947] HiSax: TeiMgr Revision 2.20.2.3
[    5.361757] HiSax: Layer3 Revision 2.22.2.3
[    5.363461] HiSax: LinkLayer Revision 2.59.2.4
[    5.364751] HiSax: Total 1 card defined
[    5.369831] HiSax: Card 1 Protocol NONE Id=HiSax (0)
[    5.371209] HiSax: W6692 driver Rev. 1.18.2.4
[    5.375599] W6692: No PCI card found
[    5.377135] HiSax: Card Winbond 6692 not installed !
[    5.381738] HFC-4S/8S: Layer 1 driver module for HFC-4S/8S isdn chips, Revision: 1.10
[    5.383287] HFC-4S/8S: (C) 2003 Cornelius Consult, www.cornelius-consult.de
[    5.384792] HFC-4S/8S: found 0 cards
[    5.392268] hisax_isac: ISAC-S/ISAC-SX ISDN driver v0.1.0
[    5.393368] hisax_fcpcipnp: Fritz!Card PCI/PCIv2/PnP ISDN driver v0.0.1
[    5.394674] Error: Driver 'fcpci' is already registered, aborting...
[    5.399334] PCBIT-D device driver v 0.5-fjpc0 19991204 - Copyright (C) 1996 Universidade de Lisboa
[    5.401109] Trying to detect board using default settings
[    5.405581] IBM Active 2000 ISDN driver
[    5.406525] act2000: No cards defined yet
[    5.407351] gigaset: Driver for Gigaset 307x (debug build)
[    5.411842] gigaset: ISDN4Linux interface
[    5.412658] cpuidle: using governor ladder
[    5.413612] sdhci: Secure Digital Host Controller Interface driver
[    5.414889] sdhci: Copyright(c) Pierre Ossman
[    5.423912] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    5.428451] wbsd: Copyright(c) Pierre Ossman
[    5.429453] via_sdmmc: VIA SD/MMC Card Reader driver (C) 2008 VIA Technologies, Inc.
[    5.431102] VUB300 Driver rom wait states = 1C irqpoll timeout = 0400
[    5.437086] usbcore: registered new interface driver vub300
[    5.441751] usbcore: registered new interface driver ushc
[    5.444427] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    5.445880] usbip_core: USB/IP Core v1.0.0
[    5.447858] vhci_hcd vhci_hcd: USB/IP Virtual Host Controller
[    5.448859] vhci_hcd vhci_hcd: new USB bus registered, assigned bus number 1
[    5.453760] hub 1-0:1.0: USB hub found
[    5.454732] hub 1-0:1.0: 8 ports detected
[    5.457250] vhci_hcd: USB/IP 'Virtual' Host Controller (VHCI) Driver v1.0.0
[    5.459300] usbcore: registered new interface driver prism2_usb
[    5.460693] usbcore: registered new interface driver asus-oled
[    5.462105] usbcore: registered new interface driver r8712u
[    5.465856] beceem: Beceem Communications Inc. WiMAX driver, 5.2.45
[    5.467265] Copyright 2010. Beceem Communications Inc
[    5.468505] usbcore: registered new interface driver usbbcm
[    5.471256] ozwpan ozwpan: Ozmo Devices WPAN
[    5.472304] ozwpan ozwpan: new USB bus registered, assigned bus number 2
[    5.476364] hub 2-0:1.0: USB hub found
[    5.477278] hub 2-0:1.0: 8 ports detected
[    5.480264] usbcore: registered new interface driver gdm_wimax
[    5.485630] ieee802154hardmac ieee802154hardmac: Added ieee802154 HardMAC hardware
[    5.488851] ieee802154fakelb ieee802154fakelb: added ieee802154 hardware
[    5.491742] u32 classifier
[    5.492376]     input device check on
[    5.493298] NET: Registered protocol family 17
[    5.494396] NET: Registered protocol family 15
[    5.495562] NET: Registered protocol family 5
[    5.499530] lec:lane_module_init: lec.c: initialized
[    5.500659] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[    5.502641] DECnet: Routing cache hash table of 256 buckets, 11Kbytes
[    5.504136] NET: Registered protocol family 12
[    5.508077] NET: Registered protocol family 35
[    5.509164] 8021q: 802.1Q VLAN Support v1.8
[    5.510197] lib80211: common routines for IEEE802.11 drivers
[    5.511557] lib80211_crypt: registered algorithm 'NULL'
[    5.512802] 9pnet: Installing 9P2000 support
[    5.513889] NET: Registered protocol family 37
[    5.515107] NET: Registered protocol family 36
[    5.516657] 
[    5.516657] printing PIC contents
[    5.517820] ... PIC  IMR: ffff
[    5.518522] ... PIC  IRR: 1113
[    5.519249] ... PIC  ISR: 0000
[    5.519941] ... PIC ELCR: 0c00
[    5.520639] printing local APIC contents on CPU#0/0:
[    5.521600] ... APIC ID:      00000000 (0)
[    5.521600] ... APIC VERSION: 00050014
[    5.521600] ... APIC TASKPRI: 00000000 (00)
[    5.521600] ... APIC PROCPRI: 00000000
[    5.521600] ... APIC LDR: 01000000
[    5.521600] ... APIC DFR: ffffffff
[    5.521600] ... APIC SPIV: 000001ff
[    5.521600] ... APIC ISR field:
[    5.521600] 0000000000000000000000000000000000000000000000000000000000000000
[    5.521600] ... APIC TMR field:
[    5.521600] 0000000000000000000000000000000000000000000000000000000000000000
[    5.521600] ... APIC IRR field:
[    5.521600] 0000000000000000000000000000000000000000000000000000000000008000
[    5.521600] ... APIC ESR: 00000000
[    5.521600] ... APIC ICR: 000c4610
[    5.521600] ... APIC ICR2: 00000000
[    5.521600] ... APIC LVTT: 000000ef
[    5.521600] ... APIC LVTPC: 00010000
[    5.521600] ... APIC LVT0: 00010700
[    5.521600] ... APIC LVT1: 00000400
[    5.521600] ... APIC LVTERR: 000000fe
[    5.521600] ... APIC TMICT: 0000603f
[    5.521600] ... APIC TMCCT: 00000000
[    5.521600] ... APIC TDCR: 00000003
[    5.521600] 
[    5.544535] number of MP IRQ sources: 15.
[    5.545471] number of IO-APIC #2 registers: 24.
[    5.546494] testing the IO APIC.......................
[    5.547659] IO APIC #2......
[    5.548366] .... register #00: 00000000
[    5.549247] .......    : physical APIC id: 00
[    5.550241] .......    : Delivery Type: 0
[    5.551276] .......    : LTS          : 0
[    5.552223] .... register #01: 00170011
[    5.553112] .......     : max redirection entries: 17
[    5.554238] .......     : PRQ implemented: 0
[    5.555465] .......     : IO APIC version: 11
[    5.556464] .... register #02: 00000000
[    5.557344] .......     : arbitration: 00
[    5.558265] .... IRQ redirection table:
[    5.559732]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    5.560969]  00 00  1    0    0   0   0    0    0    00
[    5.562242]  01 01  0    0    0   0   0    1    1    31
[    5.563446]  02 01  0    0    0   0   0    1    1    30
[    5.564650]  03 01  1    0    0   0   0    1    1    33
[    5.566321]  04 01  1    0    0   0   0    1    1    34
[    5.567851]  05 01  0    1    0   0   0    1    1    35
[    5.569193]  06 01  1    0    0   0   0    1    1    36
[    5.570410]  07 01  1    0    0   0   0    1    1    37
[    5.571636]  08 01  0    0    0   0   0    1    1    38
[    5.572887]  09 01  0    1    0   0   0    1    1    39
[    5.574385]  0a 01  1    1    0   0   0    1    1    3A
[    5.575620]  0b 01  1    1    0   0   0    1    1    3B
[    5.576867]  0c 01  0    0    0   0   0    1    1    3C
[    5.578256]  0d 01  1    0    0   0   0    1    1    3D
[    5.579476]  0e 01  1    0    0   0   0    1    1    3E
[    5.580680]  0f 01  1    0    0   0   0    1    1    3F
[    5.581937]  10 00  1    0    0   0   0    0    0    00
[    5.583189]  11 00  1    0    0   0   0    0    0    00
[    5.584397]  12 00  1    0    0   0   0    0    0    00
[    5.585629]  13 00  1    0    0   0   0    0    0    00
[    5.586878]  14 00  1    0    0   0   0    0    0    00
[    5.588128]  15 00  1    0    0   0   0    0    0    00
[    5.589349]  16 00  1    0    0   0   0    0    0    00
[    5.590909]  17 00  1    0    0   0   0    0    0    00
[    5.592179] IRQ to pin mappings:
[    5.592891] IRQ0 -> 0:2
[    5.593515] IRQ1 -> 0:1
[    5.594176] IRQ3 -> 0:3
[    5.594784] IRQ4 -> 0:4
[    5.595428] IRQ5 -> 0:5
[    5.596100] IRQ6 -> 0:6
[    5.596692] IRQ7 -> 0:7
[    5.597375] IRQ8 -> 0:8
[    5.597983] IRQ9 -> 0:9
[    5.598629] IRQ10 -> 0:10
[    5.599321] IRQ11 -> 0:11
[    5.599961] IRQ12 -> 0:12
[    5.600627] IRQ13 -> 0:13
[    5.601324] IRQ14 -> 0:14
[    5.601984] IRQ15 -> 0:15
[    5.602784] .................................... done.
[    5.603953] Using IPI Shortcut mode
[    5.606287] registered taskstats version 1
[    5.611669] dmaengine: __dma_request_channel: fail ((null))
[    5.614635] ### of_selftest(): No testcase data in device tree; not running tests
[    5.618658] Freeing unused kernel memory: 716k freed
[    5.692791] hostname (78) used greatest stack depth: 6580 bytes left
[    5.747552] hwclock (81) used greatest stack depth: 6500 bytes left
[    6.026580] trinity (97) used greatest stack depth: 6452 bytes left
mountall: Event failed
[    6.484888] sed (159) used greatest stack depth: 6420 bytes left
[    6.579421] sed (180) used greatest stack depth: 6404 bytes left
[    6.948471] MAKEDEV (244) used greatest stack depth: 6388 bytes left
[    7.238737] sed (300) used greatest stack depth: 6356 bytes left
[    9.581380] mv (660) used greatest stack depth: 6344 bytes left
[    9.970973] chown (708) used greatest stack depth: 6340 bytes left

--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.6.0-rc2-00010-g4c58c42"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.6.0-rc2 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
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
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_FHANDLE=y
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
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
# RCU Subsystem
#
CONFIG_TINY_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_AMIGA_PARTITION=y
CONFIG_MSDOS_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
# CONFIG_LGUEST_GUEST is not set
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=5
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_XADD=y
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
# CONFIG_IOMMU_HELPER is not set
CONFIG_NR_CPUS=1
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
# CONFIG_VM86 is not set
# CONFIG_TOSHIBA is not set
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
# CONFIG_ARCH_DMA_ADDR_T_64BIT is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
CONFIG_HIGHPTE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_OLPC=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_EISA=y
# CONFIG_EISA_VLB_PRIMING is not set
# CONFIG_EISA_PCI_EISA is not set
# CONFIG_EISA_VIRTUAL_ROOT is not set
CONFIG_EISA_NAMES=y
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_OLPC=y
# CONFIG_OLPC_XO15_SCI is not set
CONFIG_ALIX=y
CONFIG_NET5501=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
CONFIG_YENTA=y
# CONFIG_YENTA_O2 is not set
CONFIG_YENTA_RICOH=y
# CONFIG_YENTA_TI is not set
CONFIG_YENTA_TOSHIBA=y
CONFIG_PCMCIA_PROBE=y
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
CONFIG_ATM=y
CONFIG_ATM_LANE=y
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_BRIDGE=y
CONFIG_NET_DSA=y
# CONFIG_NET_DSA_TAG_DSA is not set
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
CONFIG_ATALK=y
# CONFIG_DEV_APPLETALK is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
# CONFIG_WAN_ROUTER is not set
CONFIG_PHONET=y
CONFIG_IEEE802154=y
CONFIG_MAC802154=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_ATM is not set
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
CONFIG_NET_SCH_SFQ=y
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=y
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_MQPRIO=y
# CONFIG_NET_SCH_CHOKE is not set
# CONFIG_NET_SCH_QFQ is not set
CONFIG_NET_SCH_CODEL=y
# CONFIG_NET_SCH_FQ_CODEL is not set
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
CONFIG_NET_CLS_TCINDEX=y
# CONFIG_NET_CLS_FW is not set
CONFIG_NET_CLS_U32=y
# CONFIG_CLS_U32_PERF is not set
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_CLS_CGROUP=y
# CONFIG_NET_EMATCH is not set
# CONFIG_NET_CLS_ACT is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=y
CONFIG_NL80211_TESTMODE=y
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
CONFIG_CFG80211_REG_DEBUG=y
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
# CONFIG_CFG80211_DEFAULT_PS is not set
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
CONFIG_LIB80211=y
# CONFIG_LIB80211_DEBUG is not set
# CONFIG_MAC80211 is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_INPUT=y
CONFIG_NET_9P=y
# CONFIG_NET_9P_VIRTIO is not set
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
# CONFIG_CAIF_NETDEV is not set
CONFIG_CAIF_USB=y
CONFIG_NFC=y
CONFIG_NFC_NCI=y
CONFIG_NFC_HCI=y
# CONFIG_NFC_SHDLC is not set
CONFIG_NFC_LLCP=y

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_PN533=y
# CONFIG_NFC_WILINK is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
# CONFIG_DMA_SHARED_BUFFER is not set
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=16
CONFIG_CMA_SIZE_PERCENTAGE=10
# CONFIG_CMA_SIZE_SEL_MBYTES is not set
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
CONFIG_CMA_SIZE_SEL_MAX=y
CONFIG_CMA_ALIGNMENT=8
CONFIG_CMA_AREAS=7
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
# CONFIG_MTD_REDBOOT_PARTS is not set
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_OF_PARTS=y
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
# CONFIG_MTD_CHAR is not set
CONFIG_MTD_BLKDEVS=y
# CONFIG_MTD_BLOCK is not set
# CONFIG_MTD_BLOCK_RO is not set
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
CONFIG_RFD_FTL=y
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_PHYSMAP is not set
CONFIG_MTD_PHYSMAP_OF=y
CONFIG_MTD_SC520CDP=y
CONFIG_MTD_NETSC520=y
CONFIG_MTD_TS5500=y
CONFIG_MTD_SBC_GXX=y
CONFIG_MTD_SCx200_DOCFLASH=y
# CONFIG_MTD_AMD76XROM is not set
CONFIG_MTD_ICHXROM=y
CONFIG_MTD_ESB2ROM=y
CONFIG_MTD_CK804XROM=y
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
CONFIG_MTD_PCI=y
CONFIG_MTD_GPIO_ADDR=y
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set
CONFIG_MTD_LATCH_ADDR=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOC2000=y
CONFIG_MTD_DOC2001=y
# CONFIG_MTD_DOC2001PLUS is not set
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_DOCPROBE=y
CONFIG_MTD_DOCECC=y
CONFIG_MTD_DOCPROBE_ADVANCED=y
CONFIG_MTD_DOCPROBE_ADDRESS=0x0
CONFIG_MTD_DOCPROBE_HIGH=y
# CONFIG_MTD_DOCPROBE_55AA is not set
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=y
# CONFIG_MTD_NAND_VERIFY_WRITE is not set
# CONFIG_MTD_NAND_ECC_BCH is not set
CONFIG_MTD_SM_COMMON=y
# CONFIG_MTD_NAND_MUSEUM_IDS is not set
CONFIG_MTD_NAND_DENALI=y
CONFIG_MTD_NAND_DENALI_SCRATCH_REG_ADDR=0xFF108018
CONFIG_MTD_NAND_IDS=y
CONFIG_MTD_NAND_RICOH=y
CONFIG_MTD_NAND_DISKONCHIP=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH=y
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
# CONFIG_MTD_NAND_DOCG4 is not set
# CONFIG_MTD_NAND_CAFE is not set
# CONFIG_MTD_NAND_CS553X is not set
CONFIG_MTD_NAND_NANDSIM=y
# CONFIG_MTD_NAND_PLATFORM is not set
CONFIG_MTD_ALAUDA=y
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_RESERVE=1
# CONFIG_MTD_UBI_GLUEBI is not set
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
CONFIG_PROC_DEVICETREE=y
CONFIG_OF_SELFTEST=y
CONFIG_OF_PROMTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_DEVICE=y
CONFIG_OF_NET=y
CONFIG_OF_MDIO=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
CONFIG_OF_MTD=y
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
CONFIG_BLK_DEV_XD=y
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
CONFIG_BLK_CPQ_DA=y
CONFIG_BLK_CPQ_CISS_DA=y
CONFIG_CISS_SCSI_TAPE=y
CONFIG_BLK_DEV_DAC960=y
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
CONFIG_BLK_DEV_SX8=y
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
CONFIG_ATA_OVER_ETH=y
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_IBM_ASM=y
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
CONFIG_VMWARE_BALLOON=y
# CONFIG_PCH_PHUB is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_93CX6 is not set
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y

#
# Altera FPGA firmware download module
#
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_IDE_LEGACY=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECD=y
# CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS is not set
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
CONFIG_BLK_DEV_OFFBOARD=y
CONFIG_BLK_DEV_GENERIC=y
CONFIG_BLK_DEV_OPTI621=y
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
CONFIG_BLK_DEV_AMD74XX=y
# CONFIG_BLK_DEV_ATIIXP is not set
CONFIG_BLK_DEV_CMD64X=y
# CONFIG_BLK_DEV_TRIFLEX is not set
CONFIG_BLK_DEV_CS5520=y
# CONFIG_BLK_DEV_CS5530 is not set
CONFIG_BLK_DEV_CS5535=y
# CONFIG_BLK_DEV_CS5536 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
CONFIG_BLK_DEV_SC1200=y
# CONFIG_BLK_DEV_PIIX is not set
CONFIG_BLK_DEV_IT8172=y
CONFIG_BLK_DEV_IT8213=y
CONFIG_BLK_DEV_IT821X=y
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
CONFIG_BLK_DEV_SVWKS=y
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
CONFIG_BLK_DEV_TC86C001=y

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
# CONFIG_BLK_DEV_4DRIVES is not set
CONFIG_BLK_DEV_ALI14XX=y
CONFIG_BLK_DEV_DTC2278=y
# CONFIG_BLK_DEV_HT6560B is not set
# CONFIG_BLK_DEV_QD65XX is not set
# CONFIG_BLK_DEV_UMC8672 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
# CONFIG_SCSI_SAS_HOST_SMP is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=y
# CONFIG_SCSI_OSD_ULD is not set
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
# CONFIG_SATA_AHCI_PLATFORM is not set
CONFIG_SATA_INIC162X=y
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
# CONFIG_FUSION_SPI is not set
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_CTL is not set
CONFIG_FUSION_LAN=y
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=y
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_DUMMY=y
# CONFIG_EQUALIZER is not set
CONFIG_NET_FC=y
CONFIG_MII=y
CONFIG_IEEE802154_DRIVERS=y
CONFIG_IEEE802154_FAKEHARD=y
CONFIG_IEEE802154_FAKELB=y
CONFIG_NET_TEAM=y
# CONFIG_NET_TEAM_MODE_BROADCAST is not set
# CONFIG_NET_TEAM_MODE_ROUNDROBIN is not set
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=y
# CONFIG_NET_TEAM_MODE_LOADBALANCE is not set
CONFIG_MACVLAN=y
CONFIG_MACVTAP=y
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=y
CONFIG_ARCNET=y
# CONFIG_ARCNET_1201 is not set
CONFIG_ARCNET_1051=y
# CONFIG_ARCNET_RAW is not set
# CONFIG_ARCNET_CAP is not set
CONFIG_ARCNET_COM90xx=y
CONFIG_ARCNET_COM90xxIO=y
# CONFIG_ARCNET_RIM_I is not set
CONFIG_ARCNET_COM20020=y
CONFIG_ARCNET_COM20020_ISA=y
# CONFIG_ARCNET_COM20020_PCI is not set
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=y
CONFIG_ATM_LANAI=y
CONFIG_ATM_ENI=y
# CONFIG_ATM_ENI_DEBUG is not set
# CONFIG_ATM_ENI_TUNE_BURST is not set
CONFIG_ATM_FIRESTREAM=y
# CONFIG_ATM_ZATM is not set
# CONFIG_ATM_NICSTAR is not set
CONFIG_ATM_IDT77252=y
CONFIG_ATM_IDT77252_DEBUG=y
# CONFIG_ATM_IDT77252_RCV_ALL is not set
CONFIG_ATM_IDT77252_USE_SUNI=y
# CONFIG_ATM_AMBASSADOR is not set
# CONFIG_ATM_HORIZON is not set
CONFIG_ATM_IA=y
CONFIG_ATM_IA_DEBUG=y
CONFIG_ATM_FORE200E=y
CONFIG_ATM_FORE200E_USE_TASKLET=y
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
CONFIG_ATM_HE=y
# CONFIG_ATM_HE_USE_SUNI is not set
# CONFIG_ATM_SOLOS is not set

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=y
CONFIG_CAIF_SPI_SLAVE=y
CONFIG_CAIF_SPI_SYNC=y
CONFIG_CAIF_HSI=y

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
CONFIG_NET_DSA_MV88E6123_61_65=y
# CONFIG_ETHERNET is not set
# CONFIG_FDDI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AMD_PHY is not set
# CONFIG_MARVELL_PHY is not set
CONFIG_DAVICOM_PHY=y
# CONFIG_QSEMI_PHY is not set
CONFIG_LXT_PHY=y
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
# CONFIG_BCM87XX_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
# CONFIG_MICREL_PHY is not set
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_GPIO=y
CONFIG_MDIO_BUS_MUX=y
CONFIG_MDIO_BUS_MUX_GPIO=y
CONFIG_PLIP=y
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_DEFLATE=y
# CONFIG_PPP_FILTER is not set
# CONFIG_PPP_MPPE is not set
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPPOATM=y
# CONFIG_PPPOE is not set
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
CONFIG_SLIP=y
CONFIG_SLHC=y
# CONFIG_SLIP_COMPRESSED is not set
# CONFIG_SLIP_SMART is not set
# CONFIG_SLIP_MODE_SLIP6 is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
# CONFIG_USB_NET_CDCETHER is not set
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=y
CONFIG_USB_NET_DM9601=y
CONFIG_USB_NET_SMSC75XX=y
# CONFIG_USB_NET_SMSC95XX is not set
# CONFIG_USB_NET_GL620A is not set
CONFIG_USB_NET_NET1080=y
# CONFIG_USB_NET_PLUSB is not set
CONFIG_USB_NET_MCS7830=y
# CONFIG_USB_NET_RNDIS_HOST is not set
# CONFIG_USB_NET_CDC_SUBSET is not set
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_NET_QMI_WWAN is not set
CONFIG_USB_HSO=y
# CONFIG_USB_NET_INT51X1 is not set
CONFIG_USB_CDC_PHONET=y
# CONFIG_USB_IPHETH is not set
CONFIG_USB_SIERRA_NET=y
CONFIG_WLAN=y
CONFIG_AIRO=y
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
CONFIG_USB_ZD1201=y
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_ATH_COMMON is not set
# CONFIG_BRCMFMAC is not set
# CONFIG_HOSTAP is not set
# CONFIG_IPW2100 is not set
CONFIG_LIBERTAS=y
# CONFIG_LIBERTAS_USB is not set
CONFIG_LIBERTAS_SDIO=y
CONFIG_LIBERTAS_DEBUG=y
# CONFIG_LIBERTAS_MESH is not set
# CONFIG_WL_TI is not set
# CONFIG_MWIFIEX is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=y
CONFIG_WIMAX_I2400M_USB=y
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
# CONFIG_WAN is not set
CONFIG_ISDN=y
CONFIG_ISDN_I4L=y
CONFIG_ISDN_AUDIO=y
CONFIG_ISDN_TTY_FAX=y

#
# ISDN feature submodules
#
# CONFIG_ISDN_DRV_LOOP is not set
CONFIG_ISDN_DIVERSION=y

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=y

#
# D-channel protocol features
#
# CONFIG_HISAX_EURO is not set
# CONFIG_HISAX_1TR6 is not set
# CONFIG_HISAX_NI1 is not set
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
# CONFIG_HISAX_16_0 is not set
# CONFIG_HISAX_16_3 is not set
CONFIG_HISAX_TELESPCI=y
CONFIG_HISAX_S0BOX=y
CONFIG_HISAX_AVM_A1=y
CONFIG_HISAX_FRITZPCI=y
# CONFIG_HISAX_AVM_A1_PCMCIA is not set
CONFIG_HISAX_ELSA=y
# CONFIG_HISAX_IX1MICROR2 is not set
CONFIG_HISAX_DIEHLDIVA=y
CONFIG_HISAX_ASUSCOM=y
CONFIG_HISAX_TELEINT=y
# CONFIG_HISAX_HFCS is not set
# CONFIG_HISAX_SEDLBAUER is not set
# CONFIG_HISAX_SPORTSTER is not set
CONFIG_HISAX_MIC=y
CONFIG_HISAX_NETJET=y
# CONFIG_HISAX_NETJET_U is not set
# CONFIG_HISAX_NICCY is not set
# CONFIG_HISAX_ISURF is not set
CONFIG_HISAX_HSTSAPHIR=y
CONFIG_HISAX_BKM_A4T=y
CONFIG_HISAX_SCT_QUADRO=y
CONFIG_HISAX_GAZEL=y
# CONFIG_HISAX_HFC_PCI is not set
CONFIG_HISAX_W6692=y
# CONFIG_HISAX_HFC_SX is not set
CONFIG_HISAX_ENTERNOW_PCI=y
# CONFIG_HISAX_DEBUG is not set

#
# HiSax PCMCIA card service modules
#

#
# HiSax sub driver modules
#
# CONFIG_HISAX_ST5481 is not set
# CONFIG_HISAX_HFCUSB is not set
CONFIG_HISAX_HFC4S8S=y
CONFIG_HISAX_FRITZ_PCIPNP=y

#
# Active cards
#
# CONFIG_ISDN_DRV_ICN is not set
CONFIG_ISDN_DRV_PCBIT=y
# CONFIG_ISDN_DRV_SC is not set
CONFIG_ISDN_DRV_ACT2000=y
# CONFIG_ISDN_CAPI is not set
CONFIG_ISDN_DRV_GIGASET=y
CONFIG_GIGASET_I4L=y
# CONFIG_GIGASET_DUMMYLL is not set
# CONFIG_GIGASET_BASE is not set
# CONFIG_GIGASET_M105 is not set
# CONFIG_GIGASET_M101 is not set
CONFIG_GIGASET_DEBUG=y
CONFIG_MISDN=y
CONFIG_MISDN_DSP=y
# CONFIG_MISDN_L1OIP is not set

#
# mISDN hardware drivers
#
# CONFIG_MISDN_HFCPCI is not set
# CONFIG_MISDN_HFCMULTI is not set
# CONFIG_MISDN_HFCUSB is not set
CONFIG_MISDN_AVMFRITZ=y
CONFIG_MISDN_SPEEDFAX=y
# CONFIG_MISDN_INFINEON is not set
CONFIG_MISDN_W6692=y
CONFIG_MISDN_NETJET=y
CONFIG_MISDN_IPAC=y
CONFIG_MISDN_ISAR=y
CONFIG_ISDN_HDLC=y

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_GPIO=y
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_MATRIX is not set
CONFIG_KEYBOARD_NEWTON=y
# CONFIG_KEYBOARD_OPENCORES is not set
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_SUNKBD=y
# CONFIG_KEYBOARD_OMAP4 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
CONFIG_TABLET_USB_AIPTEK=y
CONFIG_TABLET_USB_GTCO=y
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_AD714X=y
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
CONFIG_INPUT_WISTRON_BTNS=y
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
CONFIG_INPUT_KEYSPAN_REMOTE=y
# CONFIG_INPUT_POWERMATE is not set
CONFIG_INPUT_YEALINK=y
CONFIG_INPUT_CM109=y
# CONFIG_INPUT_UINPUT is not set
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
CONFIG_N_GSM=y
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
CONFIG_SERIAL_8250_DETECT_IRQ=y
# CONFIG_SERIAL_8250_RSA is not set
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MFD_HSU=y
# CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_OF_PLATFORM is not set
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
CONFIG_DTLK=y
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=y
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
# CONFIG_I2C is not set
# CONFIG_SPI is not set
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
CONFIG_PPS_DEBUG=y
CONFIG_NTP_PPS=y

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=y
CONFIG_PPS_CLIENT_PARPORT=y
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
# CONFIG_PTP_1588_CLOCK is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_OF_GPIO=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_SCH is not set
CONFIG_GPIO_ICH=y
CONFIG_GPIO_VX855=y

#
# I2C GPIO expanders:
#

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
CONFIG_GPIO_LANGWELL=y
CONFIG_GPIO_PCH=y
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_SODAVILLE=y
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
# CONFIG_W1_MASTER_DS2490 is not set
# CONFIG_W1_MASTER_DS1WM is not set
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_OLPC=y
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_GPIO=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_SHT15=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_APPLESMC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set
CONFIG_ABX500_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_LPC_SCH=y
CONFIG_LPC_ICH=y
CONFIG_MFD_RDC321X=y
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_VX855=y
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set

#
# Media drivers
#

#
# Graphics support
#
# CONFIG_AGP is not set
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
CONFIG_STUB_POULSBO=y
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
# CONFIG_FB is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
# CONFIG_SOUND is not set

#
# HID support
#
# CONFIG_HID is not set

#
# USB HID support
#
# CONFIG_USB_HID is not set
# CONFIG_HID_PID is not set

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_SUSPEND is not set
CONFIG_USB_OTG_WHITELIST=y
CONFIG_USB_OTG_BLACKLIST_HUB=y
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=y
# CONFIG_USB_XHCI_HCD_DEBUGGING is not set
# CONFIG_USB_EHCI_HCD is not set
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=y
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set
# CONFIG_USB_HCD_SSB is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
# CONFIG_USB_STORAGE is not set
# CONFIG_USB_UAS is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=y
# CONFIG_USB_SERIAL_CONSOLE is not set
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
CONFIG_USB_SERIAL_CH341=y
CONFIG_USB_SERIAL_WHITEHEAT=y
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP210X is not set
CONFIG_USB_SERIAL_CYPRESS_M8=y
CONFIG_USB_SERIAL_EMPEG=y
CONFIG_USB_SERIAL_FTDI_SIO=y
CONFIG_USB_SERIAL_FUNSOFT=y
# CONFIG_USB_SERIAL_VISOR is not set
CONFIG_USB_SERIAL_IPAQ=y
# CONFIG_USB_SERIAL_IR is not set
CONFIG_USB_SERIAL_EDGEPORT=y
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
CONFIG_USB_SERIAL_F81232=y
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
CONFIG_USB_SERIAL_IUU=y
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
CONFIG_USB_SERIAL_KEYSPAN=y
CONFIG_USB_SERIAL_KEYSPAN_MPR=y
CONFIG_USB_SERIAL_KEYSPAN_USA28=y
CONFIG_USB_SERIAL_KEYSPAN_USA28X=y
# CONFIG_USB_SERIAL_KEYSPAN_USA28XA is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA28XB is not set
CONFIG_USB_SERIAL_KEYSPAN_USA19=y
CONFIG_USB_SERIAL_KEYSPAN_USA18X=y
# CONFIG_USB_SERIAL_KEYSPAN_USA19W is not set
CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QI=y
# CONFIG_USB_SERIAL_KEYSPAN_USA49W is not set
CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=y
# CONFIG_USB_SERIAL_KLSI is not set
CONFIG_USB_SERIAL_KOBIL_SCT=y
CONFIG_USB_SERIAL_MCT_U232=y
CONFIG_USB_SERIAL_METRO=y
CONFIG_USB_SERIAL_MOS7720=y
# CONFIG_USB_SERIAL_MOS7715_PARPORT is not set
CONFIG_USB_SERIAL_MOS7840=y
# CONFIG_USB_SERIAL_MOTOROLA is not set
CONFIG_USB_SERIAL_NAVMAN=y
CONFIG_USB_SERIAL_PL2303=y
CONFIG_USB_SERIAL_OTI6858=y
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
CONFIG_USB_SERIAL_HP4X=y
CONFIG_USB_SERIAL_SAFE=y
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
# CONFIG_USB_SERIAL_SIEMENS_MPI is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=y
CONFIG_USB_SERIAL_XIRCOM=y
CONFIG_USB_SERIAL_WWAN=y
CONFIG_USB_SERIAL_OPTION=y
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_VIVOPAY_SERIAL is not set
CONFIG_USB_SERIAL_ZIO=y
# CONFIG_USB_SERIAL_SSU100 is not set
CONFIG_USB_SERIAL_QT2=y
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
CONFIG_USB_CYPRESS_CY7C63=y
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=y
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set

#
# USB Physical Layer drivers
#
# CONFIG_USB_ATM is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
# CONFIG_UWB_I1480U is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
CONFIG_MMC_UNSAFE_RESUME=y
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
CONFIG_SDIO_UART=y
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
CONFIG_MMC_RICOH_MMC=y
# CONFIG_MMC_SDHCI_PLTFM is not set
CONFIG_MMC_WBSD=y
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MMC_VUB300=y
CONFIG_MMC_USHC=y
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_NET48XX=y
# CONFIG_LEDS_WRAP is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_TRIGGERS is not set

#
# LED Triggers
#
CONFIG_ACCESSIBILITY=y
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
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
CONFIG_RTC_DRV_TEST=y

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
CONFIG_RTC_DRV_DS1511=y
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_RP5C01=y
CONFIG_RTC_DRV_V3020=y

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
# CONFIG_DMADEVICES_VDEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
CONFIG_TIMB_DMA=y
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
CONFIG_UIO_CIF=y
# CONFIG_UIO_PDRV is not set
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_AEC=y
# CONFIG_UIO_SERCOS3 is not set
CONFIG_UIO_PCI_GENERIC=y
# CONFIG_UIO_NETX is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
CONFIG_ET131X=y
# CONFIG_SLICOSS is not set
CONFIG_USBIP_CORE=y
CONFIG_USBIP_VHCI_HCD=y
# CONFIG_USBIP_HOST is not set
# CONFIG_USBIP_DEBUG is not set
CONFIG_PRISM2_USB=y
# CONFIG_ECHO is not set
CONFIG_ASUS_OLED=y
# CONFIG_PANEL is not set
CONFIG_R8712U=y
# CONFIG_RTS_PSTOR is not set
CONFIG_RTS5139=y
# CONFIG_RTS5139_DEBUG is not set
# CONFIG_TRANZPORT is not set
# CONFIG_USB_SERIAL_QUATECH2 is not set
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#
CONFIG_IIO_ST_HWMON=y
CONFIG_IIO_SW_RING=y

#
# Accelerometers
#

#
# Analog to digital converters
#
# CONFIG_AD7606 is not set

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=y

#
# Capacitance to digital converters
#

#
# Direct Digital Synthesis
#

#
# Digital gyroscope sensors
#

#
# Network Analyzer, Impedance Converters
#

#
# Inertial measurement units
#

#
# Light sensors
#

#
# Magnetometer sensors
#

#
# Active energy metering IC
#

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
# CONFIG_IIO_PERIODIC_RTC_TRIGGER is not set
CONFIG_IIO_GPIO_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=y
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_ZRAM is not set
CONFIG_ZCACHE=y
CONFIG_ZSMALLOC=y
# CONFIG_CRYSTALHD is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_BCM_WIMAX=y
CONFIG_FT1000=y
# CONFIG_FT1000_USB is not set

#
# Speakup console speech
#
CONFIG_STAGING_MEDIA=y

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_PHONE is not set
CONFIG_USB_WPAN_HCD=y
# CONFIG_IPACK_BUS is not set
CONFIG_WIMAX_GDM72XX=y
CONFIG_WIMAX_GDM72XX_QOS=y
CONFIG_WIMAX_GDM72XX_K_MODE=y
CONFIG_WIMAX_GDM72XX_WIMAX2=y
CONFIG_WIMAX_GDM72XX_USB=y
# CONFIG_WIMAX_GDM72XX_SDIO is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
CONFIG_VIRT_DRIVERS=y
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Analog to digital converters
#

#
# Amplifiers
#

#
# Light sensors
#

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital to analog converters
#
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
# CONFIG_VME_TSI148 is not set

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=y

#
# VME Device Drivers
#
# CONFIG_VME_USER is not set
# CONFIG_VME_PIO2 is not set
# CONFIG_PWM is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
# CONFIG_EXT2_FS_POSIX_ACL is not set
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
# CONFIG_EXT3_FS_SECURITY is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_XATTR=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

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
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=y
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
CONFIG_JFFS2_FS_WBUF_VERIFY=y
CONFIG_JFFS2_SUMMARY=y
CONFIG_JFFS2_FS_XATTR=y
CONFIG_JFFS2_FS_POSIX_ACL=y
# CONFIG_JFFS2_FS_SECURITY is not set
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
CONFIG_JFFS2_RUBIN=y
# CONFIG_JFFS2_CMODE_NONE is not set
CONFIG_JFFS2_CMODE_PRIORITY=y
# CONFIG_JFFS2_CMODE_SIZE is not set
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
CONFIG_UBIFS_FS=y
CONFIG_UBIFS_FS_ADVANCED_COMPR=y
# CONFIG_UBIFS_FS_LZO is not set
CONFIG_UBIFS_FS_ZLIB=y
CONFIG_LOGFS=y
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_XATTR is not set
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZO is not set
# CONFIG_SQUASHFS_XZ is not set
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
# CONFIG_OMFS_FS is not set
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_PREEMPT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_HIGHMEM=y
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_WRITECOUNT=y
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_LIST=y
# CONFIG_TEST_LIST_SORT is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_RCU_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST_RUNNABLE=y
CONFIG_RCU_TRACE=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_LKDTM=y
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAIL_MMC_REQUEST=y
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
# CONFIG_LATENCYTOP is not set
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
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_EVENT_POWER_TRACING_DEPRECATED=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_PREEMPT_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
CONFIG_STACK_TRACER=y
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
# CONFIG_RING_BUFFER_BENCHMARK is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_TEST_KSTRTOX is not set
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DOUBLEFAULT is not set
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
# CONFIG_CRYPTO_SHA1 is not set
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=y
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
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
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
CONFIG_DDR=y

--mP3DRpeJDSE+ciuQ--
