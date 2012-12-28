Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab2L1DMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 22:12:16 -0500
Received: from mga11.intel.com ([192.55.52.93]:31006 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024Ab2L1DMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 22:12:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,366,1355126400"; 
   d="log'?scan'208";a="267688288"
Date: Fri, 28 Dec 2012 11:11:54 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Paul E. McKenney" <paul.mckenney@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Call Trace dump on cpuidle_play_dead()
Message-ID: <20121228031154.GA18436@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Paul,

FYI, I got the below call trace dump when rebooting kernel inside KVM:

 * Asking all remaining processes to terminate...       
[  102.397875] Task dump for CPU 1:
[  102.398126] swapper/1       R running      0     0      1 0x00000000
[  102.398645]  810c9ad7 810ef4bb af31848b 00000598 50ce7b76 ffffffff 8e53b380 00000017
[  102.399320]  8e98cd45 00000000 8e537ec0 81d47ccc 8c45ff4c 81716e65 8e537640 8c45ff70
[  102.400078]  00000000 8ee9e400 0000d248 8c45ff44 810c59db 00000000 81d47ccc 0000d248
[  102.400100] Call Trace:
[  102.400100]  [<810c9ad7>] ? sched_clock_cpu+0x247/0x290
[  102.400100]  [<810ef4bb>] ? ktime_get+0xbb/0x1a0
[  102.400100]  [<81716e65>] ? cpuidle_play_dead+0x25/0x170
[  102.400100]  [<810c59db>] ? idle_task_exit+0x10b/0x220
[  102.400100]  [<81045bb4>] ? native_play_dead+0x2c4/0x340
[  102.400100]  [<81013faf>] ? cpu_idle+0x18f/0x220
[  102.400100]  [<818533f3>] ? start_secondary+0x4ca/0x4de

and it's bisected down to

[b637a328bd4f43a0e146d1eef0142b650ba0d644] rcu: Print remote CPU's stacks in stall warnings

Thanks,
Fengguang

--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-fat-8822-2012-12-17-09-56-54-3.7.0-00758-g2a74dbb-4"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.7.0-00758-g2a74dbb (kbuild@bee) (gcc version 4.7.2 (Debian 4.7.2-4) ) #4 SMP PREEMPT Mon Dec 17 09:52:16 CST 2012
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]
[    0.000000] Base memory trampoline at [8008f000] 8f000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x0fbfffff] page 2M
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x027fa000-0x027fffff]
[    0.000000] cma: dma_contiguous_reserve(limit 00000000)
[    0.000000] cma: dma_contiguous_reserve: reserving 16 MiB for global area
[    0.000000] cma: dma_declare_contiguous(size 1000000, base 00000000, limit 00000000)
[    0.000000] cma: CMA: reserved 16 MiB at 0d400000
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128260(97%)
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
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00010000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000] free_area_init_node: node 0, pgdat 81d45020, node_mem_map 8e53f200
[    0.000000]   Normal zone: 512 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 64897 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
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
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffff9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 10 pages/cpu @8e52b000 s25792 r0 d15168 u40960
[    0.000000] pcpu-alloc: s25792 r0 d15168 u40960 alloc=10*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr e52d740
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64897
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=linus/master log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2012-12-17-09-52-37-linus:master:2a74dbb-2a74dbb-i386-randconfig-b902-4-fat BOOT_IMAGE=kernel-tests/kernels/i386-randconfig-b902/2a74dbb/vmlinuz-3.7.0-00758-g2a74dbb
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 191832k/262136k available (8663k kernel code, 69804k reserved, 4941k data, 612k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffe6d000 - 0xfffff000   (1608 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x907fe000 - 0xff7fe000   (1776 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x8fffe000   ( 255 MB)
[    0.000000]       .init : 0x81d4b000 - 0x81de4000   ( 612 kB)
[    0.000000]       .data : 0x81875d4d - 0x81d49220   (4941 kB)
[    0.000000]       .text : 0x81000000 - 0x81875d4d   (8663 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=128, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=8c400000 soft=8c402000
[    0.000000] console [ttyS0] enabled
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 3199.986 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 6402.63 BogoMIPS (lpj=10666620)
[    0.006666] pid_max: default: 4096 minimum: 301
[    0.006666] Mount-cache hash table entries: 512
[    0.006666] Initializing cgroup subsys debug
[    0.006666] Initializing cgroup subsys devices
[    0.006666] Initializing cgroup subsys perf_event
[    0.006732] mce: CPU supports 10 MCE banks
[    0.007127] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.007127] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.007127] tlb_flushall_shift: 6
[    0.008768] Freeing SMP alternatives: 12k freed
[    0.011142] ACPI: Core revision 20121018
[    0.012460] Getting VERSION: 50014
[    0.012756] Getting VERSION: 50014
[    0.013050] Getting ID: 0
[    0.013348] Getting ID: f000000
[    0.013622] Getting LVT0: 8700
[    0.013884] Getting LVT1: 8400
[    0.014149] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.014645] enabled ExtINT on CPU#0
[    0.015647] ENABLING IO-APIC IRQs
[    0.015930] init IO_APIC IRQs
[    0.016233]  apic 2 pin 0 not connected
[    0.016560] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.016688] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.017357] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.018018] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.018732] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.020019] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.020678] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.021342] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.022005] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.022669] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.023352] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.024028] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.024696] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.025365] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.026040] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.026683]  apic 2 pin 16 not connected
[    0.027014]  apic 2 pin 17 not connected
[    0.027339]  apic 2 pin 18 not connected
[    0.027663]  apic 2 pin 19 not connected
[    0.028036]  apic 2 pin 20 not connected
[    0.028362]  apic 2 pin 21 not connected
[    0.028691]  apic 2 pin 22 not connected
[    0.029018]  apic 2 pin 23 not connected
[    0.029480] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.030004] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.030910] Using local APIC timer interrupts.
[    0.030910] calibrating APIC timer ...
[    0.033333] ... lapic delta = 6252598
[    0.033333] ... PM-Timer delta = 358106
[    0.033333] ... PM-Timer result ok
[    0.033333] ..... delta 6252598
[    0.033333] ..... mult: 268547066
[    0.033333] ..... calibration result: 3334718
[    0.033333] ..... CPU clock speed is 3201.2622 MHz.
[    0.033333] ..... host bus clock speed is 1000.1718 MHz.
[    0.033400] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.056897] CPU 1 irqstacks, hard=8c46e000 soft=8c470000
[    0.057464] smpboot: Booting Node   0, Processors  #1 OK
[    0.006666] Initializing CPU#1
[    0.006666] kvm-clock: cpu 1, msr 0:fffd041, secondary cpu clock
[    0.006666] masked ExtINT on CPU#1
[    0.073440] Brought up 2 CPUs
[    0.073428] KVM setup async PF for cpu 1
[    0.073428] kvm-stealtime: cpu 1, msr e537740
[    0.076670] smpboot: Total of 2 processors activated (12805.27 BogoMIPS)
[    0.077513] CPU0 attaching sched-domain:
[    0.077846]  domain 0: span 0-1 level CPU
[    0.078182]   groups: 0 1
[    0.078439] CPU1 attaching sched-domain:
[    0.078758]  domain 0: span 0-1 level CPU
[    0.079098]   groups: 1 0
[    0.080859] cma: cma_init_reserved_areas()
[    0.081207] cma: cma_create_area(base 0000d400, count 1000)
[    0.081703] cma: cma_create_area: returned 8fff0540
[    0.082150] NET: Registered protocol family 16
[    0.083817] i2c-core: driver [dummy] registered
[    0.084870] ACPI: bus type pci registered
[    0.085410] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=0
[    0.085920] PCI: Using configuration type 1 for base access
[    0.093544] i2c-core: driver [max7300] registered
[    0.093884] i2c-core: driver [mcp230xx] registered
[    0.094317] i2c-core: driver [sx150x] registered
[    0.094782] ACPI: Added _OSI(Module Device)
[    0.095128] ACPI: Added _OSI(Processor Device)
[    0.095494] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.095874] ACPI: Added _OSI(Processor Aggregator Device)
[    0.097235] ACPI: EC: Look up EC in DSDT
[    0.099411] ACPI: Interpreter enabled
[    0.099768] ACPI: (supports S0 S3 S5)
[    0.100119] ACPI: Using IOAPIC for interrupt routing
[    0.104393] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.105160] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.105711] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.106480] pci_root PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.106690] pci_root PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.107688] PCI host bridge to bus 0000:00
[    0.108037] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.108480] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.108989] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.110004] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.110563] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebfffff]
[    0.111204] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.111941] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.112777] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.115084] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    0.116249] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.116934] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.117577] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.118251] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.120043] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.121422] pci 0000:00:02.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    0.126360] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.126812] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.127932] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.129034] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.133165] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.133418] pci 0000:00:04.0: [8086:2668] type 00 class 0x040300
[    0.134265] pci 0000:00:04.0: reg 10: [mem 0xfebf0000-0xfebf3fff]
[    0.137305] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.138449] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    0.139806] pci 0000:00:05.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    0.143559] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.144886] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    0.145944] pci 0000:00:06.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    0.149923] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.150734] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.151800] pci 0000:00:07.0: reg 14: [mem 0xfebf7000-0xfebf7fff]
[    0.156035] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.156989] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    0.158046] pci 0000:00:08.0: reg 14: [mem 0xfebf8000-0xfebf8fff]
[    0.163355] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.165048] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    0.166351] pci 0000:00:09.0: reg 14: [mem 0xfebf9000-0xfebf9fff]
[    0.170134] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.171372] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    0.172430] pci 0000:00:0a.0: reg 14: [mem 0xfebfa000-0xfebfafff]
[    0.175940] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    0.177005] pci 0000:00:0b.0: reg 10: [mem 0xfebfb000-0xfebfb00f]
[    0.179668] pci_bus 0000:00: on NUMA node 0
[    0.180100] ACPI: Invalid Power Resource to register!
[    0.180525] ACPI: Invalid Power Resource to register!
[    0.180941] ACPI: Invalid Power Resource to register!
[    0.181359] ACPI: Invalid Power Resource to register!
[    0.181776] ACPI: Invalid Power Resource to register!
[    0.182191] ACPI: Invalid Power Resource to register!
[    0.182663] ACPI: Invalid Power Resource to register!
[    0.183199] ACPI: Invalid Power Resource to register!
[    0.183344] ACPI: Invalid Power Resource to register!
[    0.183760] ACPI: Invalid Power Resource to register!
[    0.184184] ACPI: Invalid Power Resource to register!
[    0.184599] ACPI: Invalid Power Resource to register!
[    0.185015] ACPI: Invalid Power Resource to register!
[    0.185434] ACPI: Invalid Power Resource to register!
[    0.185906] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.191818] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.192429] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.193027] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.193594] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.194180] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.194867] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.195570] vgaarb: loaded
[    0.195794] vgaarb: bridge control possible 0000:00:02.0
[    0.196248] i2c-core: driver [88PM80X] registered
[    0.196694] i2c-core: driver [WM8400] registered
[    0.197103] i2c-core: driver [wm831x] registered
[    0.197554] i2c-core: driver [wm8350] registered
[    0.197934] tps65010: version 2 May 2005
[    0.198271] i2c-core: driver [tps65010] registered
[    0.198715] i2c-core: driver [tps65010] unregistered
[    0.210048] i2c-core: driver [tps65010] registered
[    0.210466] i2c-core: driver [tps65010] unregistered
[    0.223378] i2c-core: driver [tps65010] registered
[    0.223987] i2c-core: driver [tps65010] unregistered
[    0.224389] tps65010: no chip?
[    0.224667] i2c-core: driver [tps65217] registered
[    0.225079] i2c-core: driver [tps65912] registered
[    0.225494] i2c-core: driver [mc13xxx] registered
[    0.225912] i2c-core: driver [da903x] registered
[    0.226310] i2c-core: driver [lp8788] registered
[    0.226702] i2c-core: driver [da9055] registered
[    0.227200] i2c-core: driver [max77686] registered
[    0.227638] i2c-core: driver [max77693] registered
[    0.228047] i2c-core: driver [max8907] registered
[    0.228479] i2c-core: driver [tps6586x] registered
[    0.228890] i2c-core: driver [tps65090] registered
[    0.229298] i2c-core: driver [palmas] registered
[    0.229731] i2c-core: driver [rc5t583] registered
[    0.230110] ACPI: bus type usb registered
[    0.230508] usbcore: registered new interface driver usbfs
[    0.231073] usbcore: registered new interface driver hub
[    0.231697] usbcore: registered new device driver usb
[    0.231697] Linux video capture interface: v2.00
[    0.231697] pps_core: LinuxPPS API ver. 1 registered
[    0.233347] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.234094] PTP clock support registered
[    0.234572] PCI: Using ACPI for IRQ routing
[    0.234970] PCI: pci_cache_line_size set to 64 bytes
[    0.235570] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    0.236054] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.237304] Switching to clocksource kvm-clock
[    0.237845] pnp: PnP ACPI init
[    0.238111] ACPI: bus type pnp registered
[    0.238505] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    0.239340] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.239340] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    0.240210] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.240858] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    0.241610] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.242172] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    0.242870] pnp 00:03: [dma 2]
[    0.243153] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.243768] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    0.244450] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.245025] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    0.245735] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.246444] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.247134] pnp: PnP ACPI: found 7 devices
[    0.247501] ACPI: ACPI bus type pnp unregistered
[    0.282912] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.283397] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.283849] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.284352] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    0.284894] NET: Registered protocol family 1
[    0.285266] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.285785] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.286268] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.286819] pci 0000:00:02.0: Boot video device
[    0.287263] PCI: CLS 0 bytes, default 64
[    0.287921] Unpacking initramfs...
[    1.593939] Freeing initrd memory: 25284k freed
[    1.599225] apm: BIOS not found.
[    1.601640] NatSemi SCx200 Driver
[    1.602379] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=60 verbose=0 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 stall_cpu=0 stall_cpu_holdoff=10 n_barrier_cbs=0 onoff_interval=0 onoff_holdoff=0
[    1.609233] fuse init (API version 7.20)
[    1.618900] list_sort_test: start testing list_sort()
[    1.619822] i2c-core: driver [lm3630_bl] registered
[    1.620316] i2c-core: driver [lm3639_bl] registered
[    1.620747] i2c-core: driver [lp855x] registered
[    1.621161] i2c-core: driver [adp8860_bl] using legacy suspend method
[    1.621683] i2c-core: driver [adp8860_bl] using legacy resume method
[    1.622191] i2c-core: driver [adp8860_bl] registered
[    1.622635] no IO addresses supplied
[    1.622989] usbcore: registered new interface driver udlfb
[    1.623521] usbcore: registered new interface driver smscufx
[    1.624189] i2c-core: driver [ssd1307fb] registered
[    1.624762] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.625358] ACPI: Power Button [PWRF]
[    1.628354] isapnp: Scanning for PnP cards...
[    1.989925] isapnp: No Plug & Play device found
[    1.990361] r3964: Philips r3964 Driver $Revision: 1.10 $
[    1.990804] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.012602] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.013635] Cyclades driver 2.6
[    2.029150] toshiba: not a supported Toshiba laptop
[    2.029580] ppdev: user-space parallel port driver
[    2.029968] scx200_gpio: no SCx200 gpio present
[    2.030432] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
[    2.031020] platform pc8736x_gpio.0: no device found
[    2.031450] nsc_gpio initializing
[    2.031739] telclk_interrupt = 0xf non-mcpbl0010 hw.
[    2.032167] SyncLink PC Card driver $Revision: 4.34 $, tty major#250
[    2.032768] [drm] Initialized drm 1.1.0 20060810
[    2.033173] usbcore: registered new interface driver udl
[    2.034363] parport_pc 00:04: reported by Plug and Play ACPI
[    2.034858] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[    2.035772] i2c-core: driver [apds9802als] using legacy suspend method
[    2.036293] i2c-core: driver [apds9802als] using legacy resume method
[    2.036852] i2c-core: driver [apds9802als] registered
[    2.037279] i2c-core: driver [isl29020] registered
[    2.037694] i2c-core: driver [tsl2550] using legacy suspend method
[    2.038191] i2c-core: driver [tsl2550] using legacy resume method
[    2.038683] i2c-core: driver [tsl2550] registered
[    2.039078] i2c-core: driver [ds1682] registered
[    2.039490] i2c-core: driver [hmc6352] registered
[    2.039891] i2c-core: driver [eeprom] registered
[    2.040414] i2c-core: driver [lis3lv02d_i2c] registered
[    2.040941] i2c-core: driver [htcpld-chip] registered
[    2.041399] i2c-core: driver [arizona] registered
[    2.041803] i2c-core: driver [wm8994] registered
[    2.042198] i2c-core: driver [smsc] registered
[    2.042783] slram: not enough parameters.
[    2.043164] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.044182] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.045040] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.045782] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.046575] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.047384] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.048153] NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba NAND 128MiB 1,8V 8-bit), page size: 512, OOB size: 16
[    2.049068] flash size: 128 MiB
[    2.049325] page size: 512 bytes
[    2.049593] OOB area size: 16 bytes
[    2.049879] sector size: 16 KiB
[    2.050210] pages number: 262144
[    2.050583] pages per sector: 32
[    2.050844] bus width: 8
[    2.051051] bits in sector size: 14
[    2.051331] bits in page size: 9
[    2.051643] bits in OOB size: 4
[    2.051901] flash size with OOB: 135168 KiB
[    2.052236] page address bytes: 4
[    2.052555] sector address bytes: 3
[    2.052840] options: 0x42
[    2.053820] Scanning device for bad blocks
[    2.068982] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    2.069496] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    2.090023] onenand_wait: timeout! ctrl=0x0000 intr=0x0000
[    2.090628] OneNAND Manufacturer: Samsung (0xec)
[    2.091005] OneNAND 16MB 1.8V 16-bit (0x04)
[    2.091344] OneNAND version = 0x001e
[    2.091641] Lock scheme is Continuous Lock
[    2.091985] Scanning device for bad blocks
[    2.092512] Creating 1 MTD partitions on "OneNAND simulator":
[    2.092975] 0x000000000000-0x000001000000 : "OneNAND simulator partition"
[    2.093951] parport_pc 00:04: registered master spi32766 (dynamic)
[    2.094507] parport_pc 00:04: master is unqueued, this is deprecated
[    2.095030] spi spi32766.0: spi_bitbang_setup, 166 nsec/bit
[    2.095494] spi spi32766.0: setup mode 0, 3wire, 8 bits/w, 6000000 Hz max --> 0
[    2.096116] parport_pc 00:04: registered child spi32766.0
[    2.096560] spi spi32766.0: spidev_lm70 at spi32766.0
[    2.097176] i2c-core: driver [spi-xcomm] registered
[    2.097670] HSI/SSI char device loaded
[    2.098055] parport0: no more devices allowed
[    2.098411] ks0108: ERROR: parport didn't register new device
[    2.098879] cfag12864b: ERROR: ks0108 is not initialized
[    2.099307] cfag12864bfb: ERROR: cfag12864b is not initialized
[    2.099804] Databook TCIC-2 PCMCIA probe: not found.
[    2.100658] usbcore: registered new interface driver cdc_acm
[    2.101120] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[    2.101814] usbcore: registered new interface driver usbserial
[    2.102309] usbcore: registered new interface driver belkin_sa
[    2.102810] usbserial: USB Serial support registered for Belkin / Peracom / GoHubs USB Serial Adapter
[    2.103667] usbcore: registered new interface driver digi_acceleport
[    2.104417] usbserial: USB Serial support registered for Digi 2 port USB adapter
[    2.105049] usbserial: USB Serial support registered for Digi 4 port USB adapter
[    2.105678] usbcore: registered new interface driver io_edgeport
[    2.106182] usbserial: USB Serial support registered for Edgeport 2 port adapter
[    2.106897] usbserial: USB Serial support registered for Edgeport 4 port adapter
[    2.107767] usbserial: USB Serial support registered for Edgeport 8 port adapter
[    2.108391] usbserial: USB Serial support registered for EPiC device
[    2.108930] usbcore: registered new interface driver f81232
[    2.109399] usbserial: USB Serial support registered for f81232
[    2.109902] usbcore: registered new interface driver ftdi_sio
[    2.110535] usbserial: USB Serial support registered for FTDI USB Serial Device
[    2.111148] usbcore: registered new interface driver funsoft
[    2.111632] usbserial: USB Serial support registered for funsoft
[    2.112137] usbcore: registered new interface driver garmin_gps
[    2.112639] usbserial: USB Serial support registered for Garmin GPS usb/tty
[    2.113222] usbcore: registered new interface driver ipaq
[    2.113876] usbserial: USB Serial support registered for PocketPC PDA
[    2.114484] usbcore: registered new interface driver iuu_phoenix
[    2.114991] usbserial: USB Serial support registered for iuu_phoenix
[    2.115574] usbcore: registered new interface driver keyspan_pda
[    2.116078] usbserial: USB Serial support registered for Keyspan PDA
[    2.116611] usbserial: USB Serial support registered for Keyspan PDA - (prerenumeration)
[    2.117419] usbserial: USB Serial support registered for Xircom / Entregra PGS - (prerenumeration)
[    2.118154] usbcore: registered new interface driver kl5kusb105
[    2.118655] usbserial: USB Serial support registered for KL5KUSB105D / PalmConnect
[    2.119285] usbcore: registered new interface driver metro_usb
[    2.119778] usbserial: USB Serial support registered for Metrologic USB to Serial
[    2.120614] usbcore: registered new interface driver mos7840
[    2.121291] usbserial: USB Serial support registered for Moschip 7840/7820 USB Serial Driver
[    2.122040] usbcore: registered new interface driver omninet
[    2.122575] usbserial: USB Serial support registered for ZyXEL - omni.net lcd plus usb
[    2.123231] usbcore: registered new interface driver opticon
[    2.123866] usbserial: USB Serial support registered for opticon
[    2.124587] usbcore: registered new interface driver oti6858
[    2.125243] usbserial: USB Serial support registered for oti6858
[    2.125786] usbcore: registered new interface driver qcaux
[    2.126247] usbserial: USB Serial support registered for qcaux
[    2.126816] usbcore: registered new interface driver quatech2
[    2.127504] usbserial: USB Serial support registered for Quatech 2nd gen USB to Serial Driver
[    2.128202] usbcore: registered new interface driver safe_serial
[    2.128709] usbserial: USB Serial support registered for safe_serial
[    2.129236] usbcore: registered new interface driver siemens_mpi
[    2.129742] usbserial: USB Serial support registered for siemens_mpi
[    2.130395] usbcore: registered new interface driver sierra
[    2.130875] usbserial: USB Serial support registered for Sierra USB modem
[    2.131446] usbcore: registered new interface driver visor
[    2.131911] usbserial: USB Serial support registered for Handspring Visor / Palm OS
[    2.132547] usbserial: USB Serial support registered for Sony Clie 5.0
[    2.133091] usbserial: USB Serial support registered for Sony Clie 3.5
[    2.133782] usbcore: registered new interface driver vivopay_serial
[    2.134310] usbserial: USB Serial support registered for vivopay-serial
[    2.134866] usbcore: registered new interface driver zte_ev
[    2.135336] usbserial: USB Serial support registered for zte_ev
[    2.136017] usbcore: registered new interface driver appledisplay
[    2.136543] usbcore: registered new interface driver cypress_cy7c63
[    2.137202] usbcore: registered new interface driver emi26 - firmware loader
[    2.137799] usbcore: registered new interface driver idmouse
[    2.138279] usbcore: registered new interface driver isight_firmware
[    2.138815] usbcore: registered new interface driver trancevibrator
[    2.139338] i2c-core: driver [isp1301] registered
[    2.139815] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    2.141371] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.141858] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.186165] mousedev: PS/2 mouse device common for all mice
[    2.187070] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    2.188161] rtc_cmos 00:00: RTC can wake from S4
[    2.188753] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    2.189331] rtc0: alarms up to one day, 114 bytes nvram, hpet irqs
[    2.189918] i2c-core: driver [rtc-ds1307] registered
[    2.190416] i2c-core: driver [rtc-ds1374] registered
[    2.190880] i2c-core: driver [rtc-ds1672] registered
[    2.191326] i2c-core: driver [rtc-fm3130] registered
[    2.191752] i2c-core: driver [rtc-isl12022] registered
[    2.192344] i2c-core: driver [rtc-pcf8563] registered
[    2.192777] i2c-core: driver [pcf8583] registered
[    2.193239] i2c-core: driver [rtc-rv3029c2] registered
[    2.193892] i2c-core: driver [rtc-rx8025] registered
[    2.194395] i2c-core: driver [rtc-rx8581] registered
[    2.194822] i2c-core: driver [rtc-s35390a] registered
[    2.195335] rtc-test rtc-test.0: rtc core: registered test as rtc1
[    2.195905] rtc-test rtc-test.1: rtc core: registered test as rtc2
[    2.196449] i2c-core: driver [rtc-x1205] registered
[    2.197009] i2c-core: driver [smbus_alert] registered
[    2.197482] i2c-parport: adapter type unspecified
[    2.197867] i2c-parport-light: adapter type unspecified
[    2.198327] isa i2c-pca-isa.0: Please specify I/O base
[    2.198804] i2c-core: driver [cx25840] registered
[    2.199207] i2c-core: driver [tda7432] registered
[    2.199614] i2c-core: driver [saa6588] registered
[    2.200080] i2c-core: driver [tda9840] registered
[    2.200613] i2c-core: driver [saa7110] registered
[    2.201016] i2c-core: driver [saa7185] registered
[    2.201413] i2c-core: driver [saa7191] registered
[    2.201822] i2c-core: driver [adv7170] registered
[    2.202224] i2c-core: driver [adv7180] using legacy suspend method
[    2.202725] i2c-core: driver [adv7180] using legacy resume method
[    2.203211] i2c-core: driver [adv7180] registered
[    2.203677] i2c-core: driver [vpx3220] registered
[    2.204081] i2c-core: driver [bt856] registered
[    2.204473] i2c-core: driver [bt866] registered
[    2.204865] i2c-core: driver [ths7303] registered
[    2.205319] i2c-core: driver [tvp5150] registered
[    2.205727] i2c-core: driver [cs5345] registered
[    2.206121] i2c-core: driver [vp27smpx] registered
[    2.206537] i2c-core: driver [upd64031a] registered
[    2.207104] i2c-core: driver [ak881x] registered
[    2.207506] i2c-core: driver [tuner] registered
[    2.207880] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver chip loaded successfully
[    2.208605] usbcore: registered new interface driver b2c2_flexcop_usb
[    2.209146] usbcore: registered new interface driver em28xx
[    2.209608] Em28xx: Initialized (Em28xx dvb Extension) extension
[    2.210187] smssdio: Siano SMS1xxx SDIO driver
[    2.210699] smssdio: Copyright Pierre Ossman
[    2.211191] usbcore: registered new interface driver radio-mr800
[    2.211701] i2c-core: driver [radio-tea5764] registered
[    2.212143] i2c-core: driver [saa7706h] registered
[    2.212537] pps_parport: parallel port PPS client
[    2.212921] parport0: no more devices allowed
[    2.213273] pps_parport: couldn't register with parport0
[    2.213815] i2c-core: driver [w83793] registered
[    2.214215] i2c-core: driver [w83795] registered
[    2.214618] i2c-core: driver [ad7418] registered
[    2.215012] i2c-core: driver [adm1026] registered
[    2.215415] i2c-core: driver [adm1031] registered
[    2.215821] i2c-core: driver [adt7410] registered
[    2.216221] i2c-core: driver [adt7411] registered
[    2.216628] i2c-core: driver [adt7462] registered
[    2.217130] i2c-core: driver [adt7475] registered
[    2.217524] applesmc: supported laptop not found!
[    2.217903] applesmc: driver init failed (ret=-19)!
[    2.218316] i2c-core: driver [atxp1] registered
[    2.218713] i2c-core: driver [ds620] registered
[    2.219104] i2c-core: driver [ds1621] registered
[    2.219504] i2c-core: driver [emc1403] registered
[    2.219909] i2c-core: driver [emc2103] registered
[    2.220518] i2c-core: driver [emc6w201] registered
[    2.221056] f71882fg: Not a Fintek device
[    2.221397] f71882fg: Not a Fintek device
[    2.221752] i2c-core: driver [fschmd] registered
[    2.222147] i2c-core: driver [g760a] registered
[    2.222541] i2c-core: driver [gl520sm] registered
[    2.222962] i2c-core: driver [hih6130] registered
[    2.223451] i2c-core: driver [jc42] registered
[    2.223833] i2c-core: driver [lineage_pem] registered
[    2.224264] i2c-core: driver [lm63] registered
[    2.224705] i2c-core: driver [lm73] registered
[    2.225087] i2c-core: driver [lm77] registered
[    2.225496] i2c-core: driver [lm78] registered
[    2.225880] i2c-core: driver [lm80] registered
[    2.226263] i2c-core: driver [lm85] registered
[    2.226651] i2c-core: driver [lm90] registered
[    2.227240] i2c-core: driver [lm92] registered
[    2.227631] i2c-core: driver [ltc4151] registered
[    2.228035] i2c-core: driver [ltc4261] registered
[    2.228438] i2c-core: driver [max1619] registered
[    2.228841] i2c-core: driver [max1668] registered
[    2.229263] i2c-core: driver [max6650] registered
[    2.229693] pc87360: PC8736x not detected, module not inserted
[    2.230247] i2c-core: driver [pcf8591] registered
[    2.230725] i2c-core: driver [sht21] registered
[    2.231112] i2c-core: driver [smm665] registered
[    2.231523] i2c-core: driver [smsc47m192] registered
[    2.231945] i2c-core: driver [thmc50] registered
[    2.232363] i2c-core: driver [w83l785ts] registered
[    2.232780] i2c-core: driver [w83l786ng] registered
[    2.233225] lguest: mapped switcher at ffc00000
[    2.233873] cpuidle: using governor ladder
[    2.234344] cpuidle: using governor menu
[    2.234681] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    2.235154] wbsd: Copyright(c) Pierre Ossman
[    2.235541] VUB300 Driver rom wait states = 1C irqpoll timeout = 0400
[    2.236432] usbcore: registered new interface driver vub300
[    2.237194] i2c-core: driver [BD2802] registered
[    2.237613] i2c-core: driver [leds-lm3642] registered
[    2.238046] i2c-core: driver [leds-pca953x] registered
[    2.238542] i2c-core: driver [leds-tca6507] registered
[    2.238990] i2c-core: driver [leds-pca955x] registered
[    2.239419] i2c-core: driver [leds-pca9633] registered
[    2.239864] usbcore: registered new interface driver Abilis Systems as10x usb driver
[    2.240789] i2c-core: driver [olpc_dcon] registered
[    2.241265] parport0: no more devices allowed
[    2.241623] panel: panel_attach: port->number=0 parport=0, parport_register_device() failed
[    2.242282] panel: driver version 0.9.5 not yet registered
[    2.242747] usbcore: registered new interface driver tranzport
[    2.243237] usbcore: registered new interface driver alphatrack
[    2.243803] i2c-core: driver [synaptics_rmi4_i2c] registered
[    2.244594] usbcore: registered new interface driver cedusb
[    2.245260] Audio Excel DSP 16 init driver Copyright (C) Riccardo Facchetti 1995-98
[    2.245872] aedsp16: I/O, IRQ and DMA are mandatory
[    2.246266] MediaTrix audio driver Copyright (C) by Hannu Savolainen 1993-1996
[    2.246990] I/O, IRQ, DMA and type are mandatory
[    2.247519] ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen 1993-1996
[    2.248208] ad1848: No ISAPnP cards found, trying standard ones...
[    2.248709] sb: Init: Starting Probe...
[    2.249040] sb: Init: Done
[    2.249283] Cyrix Kahlua VSA1 XpressAudio support (c) Copyright 2003 Red Hat Inc
[    2.250594] 
[    2.250594] printing PIC contents
[    2.250990] ... PIC  IMR: ffff
[    2.251241] ... PIC  IRR: 1113
[    2.251500] ... PIC  ISR: 0000
[    2.251752] ... PIC ELCR: 0c00
[    2.252051] printing local APIC contents on CPU#0/0:
[    2.252882] ... APIC ID:      00000000 (0)
[    2.253500] ... APIC VERSION: 00050014
[    2.254089] ... APIC TASKPRI: 00000000 (00)
[    2.254735] ... APIC PROCPRI: 00000000
[    2.255370] ... APIC LDR: 01000000
[    2.255370] ... APIC DFR: ffffffff
[    2.255370] ... APIC SPIV: 000001ff
[    2.255370] ... APIC ISR field:
[    2.255370] 0000000000000000000000000000000000000000000000000000000000000000
[    2.255370] ... APIC TMR field:
[    2.255370] 0000000000000000000000000000000000000000000000000000000000000000
[    2.255370] ... APIC IRR field:
[    2.255370] 0000000000000000000000000000000000000000000000000000000020008000
[    2.255370] ... APIC ESR: 00000000
[    2.255370] ... APIC ICR: 000008fd
[    2.255370] ... APIC ICR2: 02000000
[    2.255370] ... APIC LVTT: 000000ef
[    2.255370] ... APIC LVTPC: 00010000
[    2.255370] ... APIC LVT0: 00010700
[    2.255370] ... APIC LVT1: 00000400
[    2.255370] ... APIC LVTERR: 000000fe
[    2.255370] ... APIC TMICT: 000326df
[    2.255370] ... APIC TMCCT: 00000000
[    2.255370] ... APIC TDCR: 00000003
[    2.255370] 
[    2.266902] number of MP IRQ sources: 15.
[    2.267231] number of IO-APIC #2 registers: 24.
[    2.267600] testing the IO APIC.......................
[    2.268028] IO APIC #2......
[    2.268265] .... register #00: 00000000
[    2.268581] .......    : physical APIC id: 00
[    2.268932] .......    : Delivery Type: 0
[    2.269255] .......    : LTS          : 0
[    2.269582] .... register #01: 00170011
[    2.269892] .......     : max redirection entries: 17
[    2.270318] .......     : PRQ implemented: 0
[    2.270671] .......     : IO APIC version: 11
[    2.271024] .... register #02: 00000000
[    2.271338] .......     : arbitration: 00
[    2.271668] .... IRQ redirection table:
[    2.271980]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    2.272430]  00 00  1    0    0   0   0    0    0    00
[    2.272876]  01 03  0    0    0   0   0    1    1    31
[    2.273318]  02 03  0    0    0   0   0    1    1    30
[    2.273780]  03 03  0    0    0   0   0    1    1    33
[    2.274222]  04 03  1    0    0   0   0    1    1    34
[    2.274667]  05 03  1    1    0   0   0    1    1    35
[    2.275106]  06 03  0    0    0   0   0    1    1    36
[    2.275549]  07 03  0    0    0   0   0    1    1    37
[    2.275988]  08 03  0    0    0   0   0    1    1    38
[    2.276428]  09 03  0    1    0   0   0    1    1    39
[    2.276894]  0a 03  1    1    0   0   0    1    1    3A
[    2.277337]  0b 03  1    1    0   0   0    1    1    3B
[    2.277785]  0c 03  0    0    0   0   0    1    1    3C
[    2.278227]  0d 03  0    0    0   0   0    1    1    3D
[    2.278673]  0e 03  0    0    0   0   0    1    1    3E
[    2.279113]  0f 03  0    0    0   0   0    1    1    3F
[    2.279557]  10 00  1    0    0   0   0    0    0    00
[    2.279998]  11 00  1    0    0   0   0    0    0    00
[    2.280491]  12 00  1    0    0   0   0    0    0    00
[    2.280930]  13 00  1    0    0   0   0    0    0    00
[    2.281368]  14 00  1    0    0   0   0    0    0    00
[    2.281811]  15 00  1    0    0   0   0    0    0    00
[    2.282249]  16 00  1    0    0   0   0    0    0    00
[    2.282691]  17 00  1    0    0   0   0    0    0    00
[    2.283122] IRQ to pin mappings:
[    2.283402] IRQ0 -> 0:2
[    2.283638] IRQ1 -> 0:1
[    2.283865] IRQ3 -> 0:3
[    2.284093] IRQ4 -> 0:4
[    2.284320] IRQ5 -> 0:5
[    2.284552] IRQ6 -> 0:6
[    2.284779] IRQ7 -> 0:7
[    2.285005] IRQ8 -> 0:8
[    2.285231] IRQ9 -> 0:9
[    2.285461] IRQ10 -> 0:10
[    2.285700] IRQ11 -> 0:11
[    2.285939] IRQ12 -> 0:12
[    2.286178] IRQ13 -> 0:13
[    2.286417] IRQ14 -> 0:14
[    2.286661] IRQ15 -> 0:15
[    2.286950] .................................... done.
[    2.287366] Using IPI No-Shortcut mode
[    2.288351] rtc_cmos 00:00: setting system clock to 2012-12-17 01:55:02 UTC (1355709302)
[    2.289000] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    2.290075] Freeing unused kernel memory: 612k freed
mountall: ply-event-loop.c:497: ply_event_loop_new: Assertion `loop->epoll_fd >= 0' failed.
General error mounting filesystems.
A maintenance shell will now be started.
CONTROL-D will terminate this shell and reboot the system.
wfg: rebooting
[    2.384689] Unregister pv shared memory for cpu 1
[    2.385177] Unregister pv shared memory for cpu 0
[    2.385999] Disabling non-boot CPUs ...
[    2.386703] rcutorture thread rcu_torture_fakewriter parking due to system shutdown
[    2.387334] rcutorture thread rcu_torture_writer parking due to system shutdown
[    2.387351] rcutorture thread rcu_torture_fakewriter parking due to system shutdown
[    2.389919] CPU0 attaching NULL sched-domain.
[    2.390302] CPU1 attaching NULL sched-domain.
[    2.390693] CPU0 attaching NULL sched-domain.
[    2.600068] tsc: Refined TSC clocksource calibration: 3200.116 MHz
plymouth-upstart-bridge: ply-event-loop.c:497: ply_event_loop_new: Assertion `loop->epoll_fd >= 0' failed.
/etc/lsb-base-logging.sh: line 5:   132 Aborted                 plymouth --ping > /dev/null 2>&1
 * Asking all remaining processes to terminate...       
[  102.397875] Task dump for CPU 1:
[  102.398126] swapper/1       R running      0     0      1 0x00000000
[  102.398645]  810c9ad7 810ef4bb af31848b 00000598 50ce7b76 ffffffff 8e53b380 00000017
[  102.399320]  8e98cd45 00000000 8e537ec0 81d47ccc 8c45ff4c 81716e65 8e537640 8c45ff70
[  102.400078]  00000000 8ee9e400 0000d248 8c45ff44 810c59db 00000000 81d47ccc 0000d248
[  102.400100] Call Trace:
[  102.400100]  [<810c9ad7>] ? sched_clock_cpu+0x247/0x290
[  102.400100]  [<810ef4bb>] ? ktime_get+0xbb/0x1a0
[  102.400100]  [<81716e65>] ? cpuidle_play_dead+0x25/0x170
[  102.400100]  [<810c59db>] ? idle_task_exit+0x10b/0x220
[  102.400100]  [<81045bb4>] ? native_play_dead+0x2c4/0x340
[  102.400100]  [<81013faf>] ? cpu_idle+0x18f/0x220
[  102.400100]  [<818533f3>] ? start_secondary+0x4ca/0x4de

--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="2a74dbb-bisect.log"
Content-Transfer-Encoding: quoted-printable

git checkout 11b84c585764155d7cc75f95f1bdc86432e5e3cb

2012-12-23-18:05:52 11b84c585764155d7cc75f95f1bdc86432e5e3cb compiling
/home/wfg/linux

2012-12-23-18:07:26 detecting boot state 3.7.0-bisect-00066-g11b84c5 #3 1..=
2.3.4.5....6OK ..OK .7OK .OK 8OK .OK 9.10OK .11.OK 12.OK 13.OK 14.OK 15OK .=
1617.OK .18OK ..OK .192021OK .22OK .OK ..OK 2324OK 2526OK .27OK .28OK .OK .=
=2E29..OK .30OK .OK 31.32OK .33..OK .OK 3435OK ..OK 3637OK .OK ..38OK 39.40=
OK 41OK .42OK .43OK .4445.....OK .46OK .OK 47OK .4849.OK ..OK 5051OK 52OK .=
OK 53OK .5455OK .OK .5657...OK .58.OK .OK 59OK .606162.OK .63OK .64OK 65OK =
=2EOK .66.67OK .68..OK .OK 69OK .70OK .71.OK .OK .7273..OK .OK .OK 74.7576O=
K 7778OK 79.80.OK .81.OK .OK 82OK ..8384.OK .OK 85.86..OK .OK .OK ..87OK 88=
OK ..8990...OK .91OK .OK ..9293OK .94OK .95.....OK .OK ..96OK 97OK .OK .989=
9100OK ..101OK .OK .OK .102103..OK .104..OK .OK .105.OK 106OK .107108.OK .O=
K .109110OK ..111OK 112OK .OK .113114115.OK .OK 116OK .117118OK 119OK .1201=
21OK .122...OK .123124.OK ..125OK 126.OK 127.128OK .OK 129OK .OK .130OK .13=
1132133OK .OK 134OK ..135.....OK .OK ..OK .136137OK 138139..OK .140OK .OK .=
OK .141142143OK .OK 144145....OK .146..OK .OK .OK 147OK 148.149150..OK 151O=
K .OK .OK .152OK 153OK 154155156...OK .OK 157OK .158159OK .160.OK .161..OK =
=2EOK ..OK 162OK 163.164165......OK .OK .OK 166OK .167168...OK .OK ..OK 169=
OK 170.171.OK ..172..OK .173OK .OK .OK .174175.....OK .OK .OK 176177178.OK =
=2EOK .179180....OK .OK .OK .181182.OK .183.OK .OK .OK .OK 184185186OK 187O=
K .188189..OK ..190.OK .OK ..191OK .192..OK .193OK ..194OK 195.OK 196.197.O=
K ..198199.OK .200OK .201OK .202OK .203.OK ..204OK ..205..OK ..206..OK .OK =
=2E207OK 208OK ..OK 209210211212OK .213.....OK .OK .214215OK .216...OK .OK =
=2EOK 217218219OK 220OK .221222OK .223..OK .OK ..OK 224.OK 225226......OK .=
OK .OK 227OK .OK .228OK 229.OK 230OK .OK 231232OK .233OK .234235OK 236.237.=
=2E....OK ..OK 238OK 239OK .OK 240OK 241242.OK 243OK 244OK .245OK 246247OK =
=2EOK 248OK ..249250......OK ..251OK 252OK .OK 253254OK .OK 255.OK 256OK 25=
7OK .OK .OK 258259OK .260261262.......OK .OK .OK ..263264OK .265OK .OK .OK =
=2E266OK 267OK 268.OK .269OK ..270271........OK .OK .OK .272OK .OK 273274OK=
 275.OK 276.277OK .OK .278279OK ..280....OK .OK .OK 281OK 282.OK 283OK .OK =
284285286OK .287OK .288.OK .OK .OK 289.290OK ..291....OK .292OK .293OK .OK =
294OK .OK 295.OK 296OK 297OK ..298OK 299.OK 300.301OK 302.303304..OK .305OK=
 .306OK .307..OK .OK .OK 308.OK 309OK ..310OK 311312OK ..OK 313OK .314..OK =
=2E315OK ..OK 316.317.OK .OK 318.OK 319320.OK .OK .OK .OK 321.OK .OK 322323=
324OK 325326OK 327.OK 328.329OK .330OK .331..OK ..OK 332333.334OK .335.OK .=
OK .OK 336OK .OK .OK 337.OK 338339OK 340341OK 342.OK 343344..OK .345OK .OK =
=2E346.OK 347348349OK .OK .350351OK .OK 352.OK 353OK .OK 354355OK .OK 356OK=
 .357358359OK .360.OK .361OK ..362363.OK .OK ..OK 364365OK 366.OK 367OK .OK=
 368.OK 369370OK 371OK .OK 372.373374...OK ..375376.OK .377OK .OK .OK .378.=
379.OK .OK ..OK .OK 380OK 381OK ..OK 382.383384..OK .OK .385386OK .387OK .3=
88OK .OK .389390391..OK .OK .392393OK .OK 394OK ..395..OK .OK .396OK 397.OK=
 398.399OK ..OK 400OK .401402..OK .OK .403OK 404.405OK .406...OK .OK ..OK 4=
07408OK 409OK 410411OK .OK 412413OK 414.415OK .416OK ..OK 417.418......OK .=
OK .OK .OK 419.OK 420OK 421OK 422423OK 424OK 425.OK 426OK 427428OK 429.OK 4=
30431.......OK .432OK .OK 433.OK 434OK .OK 435.OK 436OK 437OK 438439OK .440=
OK .441OK .OK 442443.444..OK .OK 445.OK .446OK .447.448.OK .OK .449OK 450OK=
 .OK .451OK 452OK 453454OK .455456..OK .OK .457458OK ..OK 459460OK 461.OK 4=
62.OK 463OK ..464.OK .OK .OK 465OK ...466OK 467468OK .469OK .470471..OK .OK=
 472.473OK .474.OK ..475.OK .476..OK .OK .OK 477OK 478OK .479480OK 481482OK=
 .483.OK .OK 484.OK 485..486OK .487488.....OK .OK ..OK 489490OK 491OK .492O=
K 493OK 494.OK 495496OK .497498.OK .OK .OK 499500501502......OK .OK .503.OK=
 504OK 505.506OK 507OK .OK 508509OK .510OK .511OK .512OK 513.514...OK ..515=
OK .OK .OK 516517518OK .OK .519OK 520OK .521OK .522OK .523OK .524OK 525OK .=
526OK .527528.OK .OK ..OK 529.530OK .531.OK .OK ..OK 532533534OK ..OK 535OK=
 ..OK 536537OK .OK 538539540..OK ..541542OK .543.OK .544OK .OK .OK 545.546O=
K ..547OK ..OK .548OK .OK 549OK .550551552OK ..553OK ..OK 554OK .OK 555.556=
OK 557OK ..558....OK ..OK 559.OK 560OK .OK ..561OK 562OK 563.564OK ..OK 565=
566OK .567OK ..568.OK 569..OK ..OK 570571..OK .OK 572OK .573OK 574575.OK 57=
6.OK 577OK .578579OK 580.581OK ..OK 582583584OK .585.OK .OK 586.587OK .588.=
OK .OK .OK .589OK .OK 590OK 591.OK 592593594OK .595OK .596OK 597598599OK .6=
00OK .601OK .602...OK ..OK 603OK ..OK 604OK .OK 605.OK 606OK 607OK 608OK 60=
9.OK .610OK 611.OK 612613OK .614OK .615..OK .616OK .OK .617618OK .OK .OK .6=
19OK .OK 620621OK 622OK .OK .OK 623OK 624.OK 625626OK 627628629..OK .630..O=
K ..631632OK .OK ..OK 633634OK 635.636OK 637.OK .638OK 639OK 640OK ..641642=
OK .643...OK ..644..OK .OK .OK 645.OK 646OK 647648.OK 649.OK 650.OK 651OK 6=
52OK 653.OK 654655656..OK .OK .657658OK .OK .659660OK .OK .661662OK 663664.=
OK .OK .OK ..665OK 666OK 667668..OK 669OK 670OK ..671OK .OK .672673.OK .OK =
674OK .675676..OK .OK .OK 677.OK 678.679OK 680OK 681.682OK 683OK ..OK 684OK=
 685.OK 686OK ..OK 687688689...OK ..OK 690691OK .OK .692693OK 694OK ..695OK=
 .OK 696..OK .697OK 698.OK 699OK 700.701702703.OK .704OK ..705OK .OK .OK 70=
6..707OK 708OK ..709710.OK ..711OK 712713OK ..OK 714..OK 715.OK 716.717.OK =
=2E718.OK .OK .719720OK .OK ..721722OK ..OK 723724725OK .726OK .OK .727OK 7=
28OK .729730.OK .731.OK .732..OK .OK 733OK ..OK 734735736737OK .738..OK 739=
OK .OK .OK 740.741OK 742.743OK ..744.OK .745..OK .OK .OK .746OK .OK 7477487=
49OK .750751OK .752OK .OK 753OK ..754755OK .756.OK .757OK .758....OK .OK .O=
K ..OK 759OK 760.OK 761762OK 763OK 764OK 765OK .OK 766.767768769OK 770771OK=
 .772......OK .OK 773OK .OK .774OK 775OK 776OK .OK 777OK .778OK 779780OK .O=
K .781OK .OK 782783784785....OK ..786787OK .OK .788OK ..OK 789790OK .791792=
OK 793794OK .OK 795.796..OK .797..OK .OK .798.OK ..799OK 800OK .801OK 802OK=
 .OK 803OK .804OK .805OK 806807.808..OK .809OK .OK .OK 810.811.OK ..OK 812O=
K .OK 813.OK 814815OK 816OK 817OK .818OK .OK 819820821OK 822OK 823824.825OK=
 .OK 826OK ...827..OK .828.OK .OK ..OK 829830OK 831832OK .OK 833OK .OK .834=
OK 835OK 836837OK 838839840OK .OK ...841OK 842843..OK .OK .OK .OK 844845OK =
846847.848..OK .OK .OK .OK .OK 849.850851OK 852OK 853.OK .854OK .855856.OK =
=2E857OK .OK .858OK .859860.....OK .861OK .OK 862OK .OK ..863OK 864OK 865OK=
 866OK .OK .867OK 868.OK 869OK .OK 870871.872...OK .873OK .874...OK .OK ..O=
K 875876877OK .OK .OK .OK .878OK 879OK 880881OK ..882883884OK ..OK 885.886.=
OK .887.OK .OK .OK 888OK .889.890891892OK .OK .893OK .894OK 895OK .OK .896.=
OK 897OK .OK .898.OK 899.900.OK .OK 901902OK .OK ..903OK 904905906OK ..907O=
K ..OK .OK .908OK .909OK 910.911OK 912913OK 914OK .OK .915916OK 917OK .OK .=
OK 918919920OK 921922..OK .OK ..OK 923OK .OK 924.OK 925926OK .OK 927.OK 928=
OK .929930931OK .OK .OK .OK 932933OK 934.935936.OK .937OK ..938OK .OK 939.9=
40941OK .OK 942.OK 943OK ..944OK 945.OK 946OK .OK .OK 947948.949OK 950951OK=
 .952OK .953OK .OK .954955OK .956OK ..957OK ..958OK .OK .959OK 960.961OK  S=
UCCESS
bisect: good commit 11b84c585764155d7cc75f95f1bdc86432e5e3cb
git bisect start 2a74dbb9a86e8102dcd07d284135b4530a84826e 11b84c585764155d7=
cc75f95f1bdc86432e5e3cb --
Bisecting: 4419 revisions left to test after this (roughly 12 steps)
[98870901cce098bbe94d90d2c41d8d1fa8d94392] mm/bootmem.c: remove unused wrap=
per function reserve_bootmem_generic()
git bisect run /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2012-12-23-18:52:58 98870901cce098bbe94d90d2c41d8d1fa8d94392 compiling
/home/wfg/linux

2012-12-23-18:54:36 detecting boot state 3.7.0-bisect-00054-g9887090 #4 .1.=
23.4...OK 5OK .6.OK 7OK .8OK .9OK .10..OK .OK ..1112..OK .OK ..13.OK .OK 14=
=2EOK 15.16OK ..OK 1718OK .19202122.OK .OK 23OK .242526OK .27.OK .OK 28OK .=
29OK .3031OK .OK .OK 323334OK .OK 35.OK 36OK .OK 37.38OK 3940....OK .OK 41O=
K .OK .OK .4243OK 44.OK 4546OK .47OK .OK 48495051.OK .52...53OK .OK .5455.O=
K .OK 56OK ..OK .57OK 58.5960OK .OK .OK .OK .61.OK 626364OK ..6566...OK .67=
=2E.OK .OK 68.OK 69.7071..OK .OK .OK 72OK .OK 737475OK 76.77...OK ..OK 7879=
OK 80.81..OK .82...OK ..83OK 84.OK .OK 85.86OK 8788OK . TEST FAILURE
Bisecting: 2087 revisions left to test after this (roughly 11 steps)
[8966961b31c251b854169e9886394c2a20f2cea7] Merge tag 'staging-3.8-rc1' of g=
it://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2012-12-23-18:58:43 8966961b31c251b854169e9886394c2a20f2cea7 compiling
/home/wfg/linux

2012-12-23-19:00:12 detecting boot state 3.7.0-bisect-02064-g8966961 #5 ..1=
=2E....2..34.5OK .6.78OK .OK 910.OK .11.......OK ..12OK .OK 13OK .14OK .OK =
15.OK 1617OK 18OK .192021..........OK ...OK 22.OK .2324OK ..OK 25OK 26OK .O=
K .272829....30.31...OK ..32OK 33OK .OK ..OK 34OK 35.36OK .OK .OK .373839OK=
 ..40OK .41OK .42...OK .OK .OK 4344OK 45OK .46OK 47OK .4849.OK ..OK .50.OK =
51.OK 5253.54OK .OK 55OK .5657.OK .58.OK .59.OK ..60..OK .OK .OK .61OK .OK =
62OK .63OK 6465OK 66OK .676869..OK ..70.OK ..71...OK ..OK 72.OK 73OK 74OK .=
OK .75.OK 7677.78..OK ..7980OK .OK .8182...OK .OK .OK 83OK .84OK .85OK .OK =
86OK 87OK 88OK .OK 89.90OK 91.92..OK ..93.OK .OK .OK .OK 9495OK .96OK 97.OK=
 98.OK .99OK 100OK .OK 101.OK .102OK 103104105106OK .107....OK .OK 108OK .O=
K 109.OK .110111OK .OK 112113OK .114.OK ..OK .115OK .OK .116117118.OK .OK 1=
19.OK 120.121OK .OK .OK .122OK 123OK 124.OK ..125126.OK ..OK 127OK 128OK .O=
K .129OK .130OK 131.OK 132133134..OK ..OK 135136.OK .OK ..137138OK 139OK .1=
40141OK .142OK .OK ..OK 143OK 144OK 145146OK .147.OK 148OK .149150..OK .OK =
=2E.151OK 152OK .153OK 154.155.OK .OK .OK 156OK .157OK 158OK 159.160OK 161O=
K .162163...OK .OK ...164OK .OK .165166.OK .OK .OK 167.OK 168169OK 170OK .O=
K .171OK 172OK 173174175...OK .OK .176OK .177OK .178179.OK .OK 180OK .181OK=
 .182OK .183OK 184185186OK .187....OK .OK .OK .OK .188189190.OK .191OK .192=
OK ..OK .193OK .194195OK 196OK .197198.....OK .OK .OK .OK .199200OK 201202O=
K .203OK ..OK 204.OK 205OK 206.OK ..207208209.....OK 210OK .OK .OK .OK .211=
OK 212213OK .214215OK .216.OK .217OK .OK .OK ..218219220.OK ..221...OK .OK =
222OK 223OK .OK .OK 224OK .OK 225226227228OK .229..OK .OK ..230231232....OK=
 .233OK ..OK 234OK 235OK 236OK .OK 237OK .238.239240OK 241.242OK ..OK 243.2=
44245...OK ..246.OK .OK 247.OK 248OK 249.OK 250251OK 252OK .OK ..253254255O=
K ..OK 256OK 257.258..OK .259.OK ..OK 260261.OK ..OK 262263264.OK .OK .OK .=
=2E.265OK 266267OK .268269270OK ..OK 271.272.OK .OK .273274275.......OK .OK=
 .OK 276.OK 277OK 278OK .OK 279280OK 281OK .282283OK .OK 284285OK .286.....=
=2E.OK .OK .287OK 288OK 289290OK 291OK .OK 292OK 293.OK 294OK 295OK .296OK =
297298299......OK .300OK .OK .301OK .OK 302.303OK .304.OK .OK ..305OK 30630=
7308OK .309.OK .310...OK .311..OK .OK .312OK .OK 313314OK .OK 315.316.OK .O=
K 317OK .OK .OK .318319320...OK .321...OK ..OK 322OK .323OK 324.OK 325.326O=
K .327.OK .OK .OK 328OK ..329330.OK .331OK ..332...OK .OK .333334.OK .OK ..=
335336.OK ..337OK .OK .338.339340..OK ..OK 341342343.OK .OK 344OK .345346.O=
K .OK .347348.OK .OK ..349350OK .OK .OK 351OK ..352353..OK .354OK .OK .3553=
56.OK ..OK .357358..OK .OK ...359OK 360OK .OK 361OK 362OK .363OK 364OK 365.=
366..OK .367OK .OK 368369......OK .OK ..370OK 371372.OK .OK .OK 373..OK 374=
375OK .OK 376377378379......OK ..380..OK .OK .OK .381382OK .OK .383384OK .O=
K .OK .385OK ..386387388OK ..OK 389.390.OK .OK ..391392OK ..393.OK ..394395=
=2EOK .396.OK ..OK .397OK .398OK 399400OK .401402OK ..403.OK ..404.OK .OK .=
=2E405....OK .OK .OK .OK 406OK ..407OK 408OK 409410411OK 412413414415OK .OK=
 ..416........OK .417.OK .OK .OK .OK 418OK .OK 419OK 420OK 421OK 4224234244=
25426427.........OK .428..OK .OK .OK .429OK .OK 430OK ..OK .OK 431OK .OK 43=
2OK 433434435OK 436OK 437.438OK ..439.......OK .440OK ..441.OK 442.OK .OK .=
OK .OK 443.444445446OK .447..OK .OK 448449.OK .450.OK .OK 451452..OK .453.O=
K .454OK .OK .OK .OK .OK 455.OK 456457OK 458OK 459.OK 460.OK 461462.OK .463=
OK .464OK .465....OK .OK .OK 466OK ..OK 467468OK .469OK 470471OK 472OK 4734=
74475.OK .476.OK ..477....OK .OK ..478OK ..479OK ..OK .480OK 481OK .OK 482O=
K 483484OK 485486487488.OK ..489...OK .OK .490491492....OK .OK ..OK 493494O=
K .OK .OK 495OK 496.497OK 498499500...OK .OK 501OK ..502.....OK .OK 503504.=
OK .OK ..OK 505OK 506OK .507OK .508509510OK .OK 511512OK .513.OK ..514.....=
=2E.OK .OK .515OK .516OK .OK 517OK .518OK 519OK 520.OK 521522.OK .OK 523524=
=2E...OK ..525..OK .OK 526OK ..527OK 528529OK .530OK 531OK .532OK .OK 533.5=
34..OK .535.OK ..536.OK .537.OK .OK .OK .538OK .OK 539.OK 540.OK 541OK 542.=
OK 543544.OK 545.546..OK ..547OK .548...OK .OK ...OK 549OK 550OK .OK 551OK =
=2E552OK .553OK 554555OK .OK 556.557558.OK .559OK ..560OK ..561..OK ..OK 56=
2563OK .OK 564OK .OK 565.OK 566567568OK .OK 569OK ..OK 570571572573.OK .574=
OK ..575.OK ..576OK .577OK 578OK .OK .OK 579OK .OK .580581OK 582OK .OK 583O=
K .OK .584585OK 586.587OK .OK 588.589OK .OK .OK 590591.OK 592593OK .594.OK =
=2E.OK ..595OK .596OK .597OK .OK .598599600OK .OK .OK .601.OK 602603604.OK =
605.OK ..606..OK ..OK .OK 607608OK .609OK 610OK 611OK 612.613OK .614OK 615O=
K ..616617OK 618.OK 619OK .620621...OK .OK 622.OK 623OK 624OK .OK .625OK 62=
6OK .627OK 628.629OK .OK .OK 630.OK 631632OK .OK 633OK ..634...OK .635OK .6=
36OK .OK 637OK .638OK .OK 639OK .640OK ..641OK .642643OK ..644OK .645.646.O=
K ..OK 647.648OK .649OK ..OK 650651OK 652653.OK ..OK 654655OK ..OK 65665765=
8OK ..659...OK .660OK .661.OK .OK .OK 662OK .663664.OK .665OK .OK .OK .OK 6=
66667668OK 669.670..OK .671OK .672OK .OK .673..OK .674.OK ..675OK 676.OK .O=
K 677.678OK .679OK .680......OK ..681OK ..682OK 683..OK ..684OK ..OK 685.68=
6687OK .688..OK .689OK .690OK ..691..OK 692.OK .OK ..OK 693OK 694.OK 695696=
=2E.OK .697.OK .698OK ..OK 699700.OK .701..OK .702..OK .OK .OK .703OK 70470=
5OK 706707OK 708.709OK .OK 710.711712...OK ..713...OK .OK 714715OK .OK 716O=
K ..OK 717718OK .719OK 720721..OK .722OK .723..OK .724..OK ..OK 725726OK .7=
27.OK .OK .728OK .729OK 730OK 731.OK 732733OK .734OK .735..OK ..736...OK .7=
37OK .738.OK .739OK .OK .740OK .OK 741742OK .OK 743744OK 745746OK .747748.O=
K .749...OK .750OK .751.OK 752OK .753OK .OK 754OK .OK .OK 755OK .756.OK .75=
7OK ..758.759.OK .760.OK .761OK .762.OK .763OK .OK .764765.OK .766OK ..OK .=
=2E767OK .768OK ..769OK 770771772OK .773..OK ..OK 774OK 775OK .776777OK 778=
=2E779OK .780OK .OK ..781782.OK .OK .OK 783784OK 785.OK 786.787OK .788OK .O=
K 789.790..OK .OK .791792.OK ...793OK .794OK .OK .OK .795OK 796797798OK 799=
800OK .801OK .OK .802803..OK .OK ..804..OK ..OK 805.OK .806807OK .808OK .OK=
 ..OK 809OK 810.811812OK .813OK .814..OK ..815.OK .OK 816OK ..817818OK .OK =
819.820..OK .821OK .822OK .OK .823824OK 825826..OK .827.OK .828.OK .OK .829=
OK 830OK 831832OK 833.OK 834.835OK .OK .OK 836.837OK 838.839....OK .840OK .=
OK 841OK .OK 842.843.OK .844.OK .845.OK .OK 846OK 847.OK .848.849..OK ..OK =
850851OK ..OK 852853854.OK .855.....OK .OK .OK 856857OK 858859OK .860OK .86=
1.OK .OK .OK 862863.OK 864.865....OK ..OK 866OK .OK .867868869.OK .870OK ..=
OK 871.OK 872OK .873874875......OK .OK .OK 876.877OK 878OK 879.880881...OK =
=2EOK .OK ..882.883884OK .885..OK .886....OK .OK ..887OK .888.889.OK .OK ..=
OK .890OK 891892893OK 894.895.......OK .OK 896OK .897OK 898.OK 899.900OK .O=
K 901902OK .OK 903.OK 904OK .905906....OK ..OK 907.908...OK .OK .OK .OK 909=
910OK 911912OK .OK 913914.OK .915.OK .916OK ..917.....OK .918OK .OK 919.OK =
920OK ..921OK 922OK 923.924OK 925926OK .OK 927.928929..OK ..930....OK .931O=
K .932OK .OK 933OK .OK .OK 934935OK 936937.OK ..OK 938939940...OK .941OK .9=
42OK ..943OK .OK .OK .OK 944.945OK 946.OK 947948..OK ..949.OK .950OK .OK 95=
1OK .952953OK .954..OK .955.OK ..OK 956OK .OK 957.958OK 959960....OK .OK .O=
K  SUCCESS
Bisecting: 1047 revisions left to test after this (roughly 10 steps)
[22a40fd9a60388aec8106b0baffc8f59f83bb1b4] Merge tag 'dlm-3.8' of git://git=
=2Ekernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2012-12-23-19:48:16 22a40fd9a60388aec8106b0baffc8f59f83bb1b4 compiling
/home/wfg/linux

2012-12-23-19:49:52 detecting boot state 3.7.0-bisect-03109-g22a40fd #6 123=
45.6..OK ..789....OK .10.OK .OK 11.OK .12OK .1314..OK .15...OK .OK 16.OK 17=
18.....OK ..19OK .20OK 21OK ..2223OK .OK 24.OK 25OK .26...27..OK .28OK 29OK=
 .OK 30.31OK .32.OK .33OK .34..OK .35OK .36..OK .37..OK 38.OK .39OK 40.OK 4=
14243OK 44OK .4546OK .OK 4748.OK .49.OK .50.OK . TEST FAILURE
Bisecting: 520 revisions left to test after this (roughly 9 steps)
[aefb058b0c27dafb15072406fbfd92d2ac2c8790] Merge branch 'irq-core-for-linus=
' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2012-12-23-19:52:28 aefb058b0c27dafb15072406fbfd92d2ac2c8790 compiling
/home/wfg/linux

2012-12-23-19:54:03 detecting boot state 3.7.0-bisect-02583-gaefb058 #7 ...=
=2E.123456.7.8.OK .OK .9OK 1011OK .12OK .1314OK ..OK 1516.OK .OK 17OK ..OK =
18OK .19OK 20OK .2122OK 23OK .OK 24.OK 2526OK .OK 27.28OK .OK 29.30OK .31.O=
K .OK .OK .3233OK 34.OK 35.3637OK 38.OK 39OK .4041OK ..42OK 43.44OK .45...O=
K .OK .4647OK 4849OK .OK .50OK 5152OK 53OK .54.55OK ..OK 56OK 57.OK 585960.=
=2EOK .OK .61OK .62.63OK ..OK .64OK .65OK .66.OK .OK .67OK 68.OK 6970...OK =
=2E71OK 72OK ..73OK .74OK ...757677.78 TEST FAILURE
Bisecting: 281 revisions left to test after this (roughly 8 steps)
[fb37ef98015f864d22be223a0e0d93547cd1d4ef] USB: mark uas driver as BROKEN
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2012-12-23-19:57:25 fb37ef98015f864d22be223a0e0d93547cd1d4ef compiling
/home/wfg/linux

2012-12-23-19:59:01 detecting boot state 3.7.0-rc6-bisect #8 .1..2..34.567O=
K .8OK 9OK 101112...OK .OK .13OK .14OK .1516.OK .OK 17OK .OK 18.OK 1920OK .=
21OK .OK 2223.....OK ..OK 2425OK .OK 26..27OK .OK ..OK 28OK 29.OK 30313233O=
K .34..OK ..3536.OK .37OK .38OK .39..OK ..40.OK .OK 41OK .42OK .43...OK .OK=
 .4445OK .46OK .4748.OK ..49OK .50OK ..OK .51.52...OK ..OK 53.OK 54.55.OK .=
OK .5657.OK .58OK .59.OK ..OK .60OK .61OK 62.OK 636465.....OK .OK 6667OK .6=
8OK ..OK 6970OK .71OK .72OK .OK .OK .73OK 747576....OK .OK .OK 777879.OK .O=
K .80OK 8182OK .83OK .OK 8485OK ..OK 8687..OK .OK 88.89..OK ..OK 9091OK 92O=
K .93OK .94OK .OK .9596OK ..OK 9798OK .99OK ..100...OK .OK .OK 101OK ..OK 1=
02OK 103104105106OK .OK ..OK 107OK .108109110..OK .111OK .112.OK ..OK 11311=
4.OK .OK .OK .OK .OK 115OK .OK 116117118OK 119.OK 120121.122OK ..OK 1231241=
25OK ..OK 126.127...OK .OK .128OK 129OK .130131.OK .OK 132OK .OK ..133134OK=
 .OK 135136OK .137OK 138139140..OK .OK .141142OK .OK .143.OK 144OK .145146.=
OK .147OK .OK .148.OK 149OK 150OK .151152...OK .153.OK ..OK .154.OK 155.156=
OK .157.OK .158OK .OK .159OK 160OK 161OK .162.163164OK ..165166..OK ..OK .1=
67168..OK ..169OK .170OK .171OK 172OK .OK 173OK .174175OK ...OK 176OK ..177=
OK 178179OK .180.....OK .OK .OK 181OK 182.OK 183184185OK .OK ..OK 186OK 187=
OK ..OK 188189190191........OK .OK 192.OK 193OK .OK .194195.OK .196OK ..OK =
=2E197OK 198199200201...OK ..OK 202203.OK .204..OK .OK ..OK 205.OK 206OK .2=
07OK 208.OK .OK 209210OK 211OK .212213....OK .214....OK .OK .OK .215OK 2162=
17OK 218.OK 219OK .220221222..OK .223......OK .OK ..224OK 225OK 226OK 227OK=
 .OK 228OK 229.OK 230231OK .232233234235.........OK .OK .OK .OK 23623723823=
9OK .OK 240OK .241OK 242OK .OK .243OK .244245246......OK .OK .OK .OK 247248=
OK 249250OK ..OK .OK 251252.OK 253254OK ..OK 255256.257258.....OK .OK ..OK =
259260.261OK ..OK 262OK 263OK 264OK .OK 265OK 266OK .267268OK 269..270.OK .=
=2EOK 271.272OK ..OK 273OK ..274275OK .OK 276.OK 277OK .OK 278OK .OK 279OK =
=2E280OK 281OK 282283284OK .285OK .286.OK .287.OK .OK ..OK 288289290.OK .29=
1OK .292OK .OK .OK 293OK 294OK .OK 295OK .296OK 297298299......OK .OK .3003=
01OK 302.OK 303..OK 304OK .305OK 306OK .307OK 308OK .OK 309310311312.....OK=
 .OK .OK .OK 313314315316OK .317OK .OK .318OK .OK .OK 319.OK 320321322....O=
K .323OK .324.OK .325OK .326OK 327.328OK .329OK .OK .330OK 331332OK .333334=
335..OK .OK .336337.OK .338OK .OK .339OK 340341OK 342343.OK .OK .OK .344345=
OK 346OK ..OK 347348.OK 349.350....OK .OK .OK 351OK .OK .352353354355.OK ..=
OK .356357OK .OK .OK .358359OK 360.361...OK ..OK 362363OK 364OK .365....OK =
=2EOK 366OK .367368.OK ..OK .369OK .370.371OK .372OK .373374OK .375......OK=
 .OK .376377..OK .OK .OK 378379OK .OK 380OK .OK 381OK 382.383OK 384.OK 3853=
86.OK .387..OK .OK .388389390.OK .OK 391OK .392OK 393OK .OK 394.OK 395OK .O=
K 396OK .397OK 398399OK 400401402..OK ..OK 403404405.OK .406OK .OK .407OK .=
408OK .OK .OK 409.OK 410OK .OK .411412OK 413414..OK .OK .OK .415OK .4164174=
18.OK .OK .OK 419420OK .421422OK 423424OK .OK .OK .OK 425426.OK 427428OK .4=
29.OK .OK .OK 430.431.OK .OK 432OK .OK .OK 433434OK .435436..OK ..OK 437OK =
438439OK 440.OK 441.442OK .OK 443.444...OK .OK .445OK .446.447..OK ..OK 448=
OK 449OK .450OK 451OK .OK 452453OK 454OK .455456OK .457.OK ..OK .458.459...=
OK .OK ..OK 460OK 461.OK .OK 462.OK 463464OK 465.466OK 467.OK 468.OK 469470=
OK .471.....OK ..472.OK ..OK 473OK .OK 474OK .OK 475OK .476OK 477478OK 4794=
80OK 481.482483..OK .484..OK .485OK .OK 486.487.OK .488OK .OK .OK .OK 489OK=
 490OK .OK 491OK .OK 492493494495OK 496497..OK ..498OK 499.500..OK .OK 5015=
02OK .OK .503OK 504OK .505OK 506OK .OK .OK 507OK ..OK 508509510.OK .OK 511.=
OK 512OK .OK .513514515OK ..516OK ..517OK ..518OK .OK ..OK 519OK 520OK .OK =
=2E521522523OK .524.OK .OK .525.526...OK .527.OK .528OK .529OK .OK .OK .530=
531OK 532OK .533534OK 535OK .536537538539.OK .540OK .541OK ..542..OK ..543O=
K ..OK .OK 544.OK 545OK .546547OK .OK .OK 548.549550OK 551.OK 552.OK 553554=
=2E..OK ..OK 555556557OK .558OK .559OK .OK .OK 560OK .561OK 562OK 563.564OK=
 565.OK 566.567.OK ..OK .568OK .569...OK .570..OK .OK 571OK .OK 572OK .573O=
K .574575.OK ..576OK .577OK .OK .578OK .OK .579580OK ..OK 581.582OK .OK 583=
=2EOK 584OK ..OK 585.OK 586.587.OK .588..OK .589OK .OK .590.591.OK .592OK .=
OK .OK .OK 593594595596.OK .OK 597.598.OK ..OK 599.600OK .601.OK .602603OK =
=2E604OK .OK ..605OK ..OK 606.607..OK ..608..OK ..OK 609.610.OK .OK .611OK =
612613.OK ..614OK ..OK 615OK .616.617.OK .618OK .619OK .620.OK ..621OK .622=
=2EOK .OK .OK 623OK 624625626OK 627.628OK .OK .OK 629.630.OK ..OK 631OK .OK=
 .632633OK .634...OK ..OK 635OK .OK 636OK .637OK 638.OK 639640641OK 642643O=
K .OK .OK .644645OK 646647OK ..648...OK .OK .OK .OK 649650.651..OK .OK .OK =
652OK .OK 653.654655OK 656OK 657OK ..658659.OK ..660..OK .OK .OK 661OK .662=
=2E663664OK .665OK .666OK .OK .OK 667OK .668OK 669OK 670.671672OK ..OK 673.=
674.OK .675OK .676.OK .OK 677.678.OK ..OK 679.OK 680OK 681.682OK .OK ..683O=
K .OK 684685.686OK .687OK ..688.OK .689..OK .OK 690OK ..691....OK .OK .OK 6=
92OK 693OK .694OK 695OK 696OK 697OK .698699700...OK .OK .701702..OK .OK .70=
3704.OK .OK .OK .705OK 706707708OK 709.OK .OK .710711712..OK .OK 713OK 714O=
K .715716...OK .OK .OK 717718OK 719720721.OK .OK .722723724OK ..OK 725726OK=
 ..727...OK ..728OK .OK .729OK .730.731OK ..732OK 733.734.OK .OK .735736.OK=
 ..737.OK .OK .738OK .OK 739OK 740.OK 741OK ..742OK .743..OK .OK .744745OK =
=2E746....OK .747.OK ..748OK .OK 749.750OK .OK .751OK 752OK .753754OK .OK .=
755756..OK 757..OK .OK .758OK .OK .759760.OK .OK .OK .OK 761762763OK 764OK =
=2EOK .765766767...OK .OK .768OK 769770OK .771772..OK .OK .773774OK ..775OK=
 .776.OK .OK 777OK ..778779..OK .OK .OK ..OK 780781OK 782OK 783784OK 785OK =
786OK 787788789...OK .790OK .791.OK .792..OK .OK 793.OK 794OK .795OK 796.OK=
 ..OK 797OK 798OK .OK 799800801802OK .OK 803OK .804805.OK .806..OK .807OK .=
808OK .OK 809OK .810OK .811.812OK .813OK .OK .OK ..814OK .815816817OK .818.=
=2E.OK ..819OK .OK .OK 820.OK 821822823OK 824.825..OK .OK .OK 826OK .OK 827=
OK ..OK 828OK 829.830831OK .OK 832OK .833OK 834.835OK ..836OK ..837...OK .O=
K .OK .838839OK 840OK .OK .OK 841OK 842843OK .OK 844OK 845OK 846.847OK 848O=
K 849.850851.....OK 852.OK ..853854OK .OK .OK .OK 855856OK 857OK 858.OK .OK=
 859OK 860OK .861OK 862OK .863OK 864865866OK ..867..OK ..868..OK .OK .OK 86=
9OK .870871OK .OK 872OK .OK 873OK 874875OK .OK 876OK 877OK ..878879880..OK =
=2EOK .881OK 882.883OK ..OK 884OK .885886.OK .OK ..887OK 888OK 889.OK 89089=
1OK 892OK .893.894895OK .OK .896OK .897898OK .899OK .OK ..900..OK .OK 901OK=
 .902OK 903OK .OK ..OK 904905OK .OK .906.OK .OK 907OK 908OK ..OK 909910911O=
K 912OK ..913914OK .915OK .OK .916917.OK .918919.OK .OK 920.OK 921OK ..922O=
K 923.OK 924..OK 925OK 926OK ..OK .927928OK 929OK .930.OK 931OK .OK .932OK =
933934.935.OK .OK ..OK 936.937OK .938OK ..939OK .OK 940OK ..OK .941OK .942.=
OK 943OK 944OK 945.OK .946947948.OK .949OK ..OK 950951.OK 952.OK .953954OK =
955OK 956OK .OK .957OK 958959960961OK .OK .OK .962.OK 963964965OK 966OK .96=
7OK .968969OK  SUCCESS
Bisecting: 140 revisions left to test after this (roughly 7 steps)
[3ba89e96610b85b5a2f3a146f65342e38af27a79] staging: dgrp: dgrp_tty.c: Remov=
e the TIOCSSOFTCAR ioctl handler from dgrp driver
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2012-12-23-20:44:12 3ba89e96610b85b5a2f3a146f65342e38af27a79 compiling
/home/wfg/linux

2012-12-23-20:45:21 detecting boot state 3.7.0-rc6-bisect-00141-g3ba89e9 #9=
 1..23..45...6OK 7.8..OK .9OK .OK ..OK .10OK 11OK .12.OK 131415OK .OK ..161=
7OK .OK .18OK 1920.OK ..OK 2122.OK .OK 2324OK .25OK .OK .OK .OK 26272829OK =
=2EOK 3031OK .OK .OK 32OK 33.34OK .OK .35OK .3637.....OK .OK .OK .OK 3839OK=
 .404142OK .OK .43OK 44.45OK .46OK .OK .4748.......OK .OK .49OK 50OK .OK .5=
1OK 5253OK 54.55OK 56OK .57.58.......OK .59..OK .OK 60.61OK .OK 62OK .OK .6=
3OK .OK 6465OK .OK 66676869....OK .70OK 71.OK .72.OK .73OK .OK .74OK 75OK .=
OK .76OK .77OK 78.79OK .OK 80.81OK ..82OK .83.....OK .OK .OK ..OK 84OK 85OK=
 86OK .878889OK .90OK .91OK .OK 92.93........OK ..94OK .OK .OK ..OK 95OK .9=
6979899OK .100OK .OK .101102.......OK .OK 103104105OK .OK .OK 106OK 107OK 1=
08OK 109OK 110OK .OK ..111112......OK .OK 113OK ..114OK .OK ..OK 115OK 116.=
117OK 118.OK 119.120.OK .OK .121122123...OK .OK 124125OK ..126..OK .OK 127O=
K .OK .OK 128129130OK 131OK .OK .132133134.OK .OK .135136OK ..137.OK ..138.=
=2E.OK .OK .OK 139OK .OK 140OK .OK 141.OK 142OK 143144.145OK ..OK .146147..=
=2EOK .148..OK ..149OK .OK 150151OK .152OK .OK 153.154OK ...155.OK .OK .156=
157..OK .158.OK .OK .OK 159OK 160161OK .OK 162163164.OK .OK ..165OK .OK ..1=
66.OK .167...OK .168.OK .OK 169OK .OK ..OK 170171OK 172OK 173174175OK .OK .=
=2E176OK 177.178.OK ..OK 179.180OK .181.OK ..182.OK .OK ..OK 183OK 184OK .O=
K 185.186OK .OK 187.OK .OK 188.189OK 190191.192....OK ..193..OK .OK 194OK .=
=2E195OK .OK 196OK .197OK 198OK 199OK .200.201202OK 203.204OK 205.206...OK =
=2E.OK 207.208OK .OK .209210OK .OK .OK 211.212OK .OK .OK .OK ..OK 213OK 214=
=2EOK 215216217218.OK .219OK .220.OK ..OK .221OK 222.223OK ..OK 224225226..=
OK ..OK .227OK 228..229OK 230231OK .232233OK 234.OK 235.236...OK .OK .OK .2=
37238OK 239.240OK .OK ..241OK 242OK .OK ..OK 243OK 244OK 245.OK 246.OK 2472=
48249OK .OK .250.251..OK ..252.OK .OK .OK ..253OK 254OK .OK .255256OK .257O=
K .OK ..258259260OK .OK ..261262...OK ..263OK ..264OK 265OK .OK 266.267....=
OK .OK .OK 268OK .269OK 270271OK .OK 272273274.OK ..275OK 276OK 277OK .2782=
79.....OK .OK .OK 280281282OK .OK .OK 283.284OK .OK .285286OK .OK .287.288.=
OK .289.OK .OK .290OK .291OK 292293OK .294.OK .OK .295.OK 296297OK .298..OK=
 ..299OK ..300.OK ..OK .OK 301302OK ..OK 303OK .304OK .305OK .306.307...OK =
=2E308OK .309..OK .310...OK .311OK .OK .OK .OK 312OK 313OK .OK 314.315OK 31=
6317OK ..318319OK .320........OK ..321322.OK ..OK 323OK 324325OK 326OK .327=
=2EOK 328OK 329.OK 330331332....OK ..333..OK .334.OK .OK 335OK ..OK 336337O=
K .338OK .339.OK .340.341OK 342OK .343344.OK .345.OK .346....OK ..OK 347OK =
=2EOK .OK .348OK .349OK .OK .OK 350..OK .351352OK 353.354355......OK ..356.=
OK .OK ..OK .357358359360..OK .OK .OK .OK ..OK 361362363364365OK 366367.OK =
=2E.368....OK .OK .OK .OK 369.370371372...OK .OK .OK 373OK 374.OK .OK 37537=
6377OK 378.379380OK .381....OK .OK .OK ..382383...OK ..384385OK .OK .OK .OK=
 386OK 387OK 388OK 389.OK 390.391392393...OK .OK .OK ..394395396OK .OK .397=
OK 398.OK 399.OK 400.OK 401OK .OK .OK 402OK .OK 403404.405..OK 406.OK .OK .=
OK 407.OK 408.409OK .410411OK ..OK 412.413.OK ..OK .414OK .OK 415OK ..OK 41=
6417418OK 419420OK .OK .OK 421.OK .OK .422.OK 423.OK 424.425..OK .OK ..OK 4=
26.427OK .OK .OK 428.429430OK .431.OK .OK ..OK ..OK 432OK .433434435436.OK =
=2EOK .OK 437438439.OK .440OK .OK .441OK .442443....OK .OK .OK .OK 444OK 44=
5OK .446.447OK 448.OK 449..OK 450.OK .451452OK .OK .453454....OK .OK .OK ..=
OK 455OK .OK 456..OK .457OK 458OK 459460OK .OK 461462463OK 464OK 465.466...=
=2E..OK .467468OK ..469OK 470.OK .471OK 472OK 473474OK 475OK .OK 476.OK .OK=
 477478479480....OK .OK 481.482OK ...483OK .OK .OK 484OK 485OK .OK 48648748=
8489OK .OK .OK 490.491.492493.OK .OK .494495OK .OK .496.OK .497.OK .OK .OK =
=2EOK 498.499500.OK .501OK .OK ...502OK 503OK .504505.OK ..506OK 507.508..O=
K .509OK .OK .OK 510.OK 511512513...OK .OK ..OK .OK .514515.OK 516517OK 518=
519.OK .OK ..520..OK .521OK ..522523..OK .524.OK ...OK .OK 525OK 526OK .OK =
=2EOK 527528OK .529530531OK .532..OK .533...OK 534.OK .535..OK .OK .536OK .=
OK 537.OK .OK 538OK .OK 539540OK ..541.OK 542543.OK .OK .544545....OK .OK .=
546OK 547.OK 548.549OK ..550OK 551OK .OK .OK .OK .552553OK 554OK 555.556557=
OK .558OK .559OK .OK .560561.OK .562OK .OK 563.564..OK .OK .OK .OK .565566O=
K 567OK .568OK .569OK 570571OK 572OK ..573574575.OK .OK 576577.....OK .OK .=
OK 578OK 579OK .580581OK .582583OK .584585OK 586OK .587588OK .OK .589.590..=
=2E..OK .591.OK .OK 592OK .OK .OK 593594OK .595.596OK 597OK 598OK .OK .OK .=
OK 599600.OK 601602603....OK .OK .604605OK 606OK .607OK 608.OK .609.610.OK =
=2EOK .OK .OK .OK ..OK 611612613614615616OK .OK 617OK ...OK 618619.OK 620.O=
K .621622623.....OK .OK .624OK .OK .OK 625OK .OK 626.627OK 628OK 629OK 630.=
OK 631OK .632633OK .634OK 635.636637638...OK ..639OK .OK .640OK 641OK 642OK=
 .OK .OK .643.644OK 645646OK 647OK .648OK .OK 649OK ...650651652..OK .OK .O=
K .653654655OK .656OK ..OK 657OK .658OK .659OK 660.661.OK ..OK ..662663664.=
=2EOK .OK 665OK .OK 666667668669OK .OK .OK 670OK 671.672.OK 673OK ..OK 674.=
OK 675.OK 676.677....OK .678OK .OK 679680681..OK .OK 682OK ..OK 683OK .684O=
K 685686OK ..OK 687688OK .689....OK .690OK .OK .691692.OK .693OK .OK ..OK 6=
94OK 695OK ..696697..OK .698OK .699.OK ..OK .700701...OK .OK .OK .702703OK =
=2EOK 704705.OK .OK .OK 706707708..OK .709.......OK .710OK .OK .711.712OK .=
OK 713.714715.OK .OK ..716.....OK .717.OK .718OK ..719OK 720OK ..721..OK ..=
722..OK ..OK 723724.OK .725.OK .OK .726727OK .728729.OK .OK 730731..OK ..OK=
 732.OK 733OK .734735.OK ..736OK .OK ..737OK 738OK .739740..OK ..OK 741742O=
K .OK 743744745.OK .OK .746747....OK .OK 748.OK .OK 749.750751OK .OK .OK 75=
2OK .753754OK .755...OK .756...OK .OK .757OK .758.OK ..OK 759OK 760761OK .7=
62OK .OK .763OK 764765....OK .766.OK ..767OK .OK .OK .768769OK 770771OK ..O=
K 772773.OK .774.OK .775..OK .776...OK .OK 777OK .OK 778.OK 779780.781OK .O=
K .OK .OK 782783784OK .785OK .786..OK ..787.OK .788OK 789790OK .OK .791OK .=
OK 792OK ..OK 793794795796797.OK .OK .798799.OK .OK ..800...OK ..OK 801802O=
K .OK ..803804OK .OK .OK 805OK .806807OK ..808..OK .OK .809..OK ..OK 810.81=
1.OK .OK .OK 812813OK .OK 814815OK 816817818OK 819OK .OK 820.OK 821822823..=
=2E..OK .824...OK .OK 825.OK 826OK .827OK .OK .OK 828.829OK 830OK 831OK .83=
2OK .833834OK .835836.......OK .OK 837OK .OK 838OK .839.OK 840OK .OK 841OK =
=2E.OK 842OK 843OK 844OK ..OK 845OK 846847848OK 849850851OK .852....OK .OK =
853.854OK 855856..OK ..OK 857OK ..OK 858OK .OK .OK 859OK 860861OK 862863864=
865..OK .866OK .OK .OK 867868869..OK ..OK 870OK ..871OK .OK .OK .OK 872OK 8=
73OK .OK 874875876877OK 878OK .879880.OK .881OK .882883.OK .884OK .OK .885.=
OK ..OK 886.OK 887OK 888OK .OK 889OK 890891892893.OK ..OK 894OK ..OK 895896=
897.OK ...898899.OK .OK .900OK .901OK .OK .902OK .903904OK 905.906.OK .OK .=
OK .907908909.OK ...910911OK .OK 912913.OK ..914OK .OK ..OK 915916OK 917OK =
918.919OK 920921...OK .OK .OK 922.923OK 924.925.OK .OK ..926OK 927OK .OK ..=
OK 928OK 929OK 930OK ..931932933OK .OK .934OK 935.OK 936.937....OK ..938.OK=
 .939OK .OK .940941OK .OK ..OK .OK 942OK ..943944....OK .945OK .OK .946947O=
K .948..OK .OK ..949950OK  SUCCESS
Bisecting: 70 revisions left to test after this (roughly 6 steps)
[e455a9b92d6e19a3f0f7eb6f6241efa566a7e81a] memory_hotplug: handle empty zon=
e when online_movable/online_kernel
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2012-12-23-21:32:33 e455a9b92d6e19a3f0f7eb6f6241efa566a7e81a compiling
/home/wfg/linux

2012-12-23-21:34:09 detecting boot state 3.7.0-bisect-00389-ge455a9b #10 1.=
=2E2..3....4.OK .OK ..OK 56OK 789OK 10OK .1112OK .13.OK .14OK .15...OK .OK =
=2E1617..OK .OK .OK 18OK .OK 19OK 2021OK 2223OK 242526OK ..OK 2728OK .29...=
OK ..30.OK .31OK .32.OK 33OK .OK .OK .34OK 35.OK 36.37OK 38OK .39OK 40OK .4=
142..43OK .44OK .45..OK .46..OK .OK .47OK .OK .OK 48OK .4950OK .51OK 525354=
OK ..OK 555657..OK .58...OK ..59OK .60.OK .OK 61OK .OK .OK 62OK 63OK 6465OK=
 66OK .OK 67.6869.OK .OK .7071OK .72.....OK .73.OK .74OK 75OK .OK 76OK .777=
8OK .OK 79OK ..80818283....OK .84.OK .OK .85OK 8687OK ..OK 88OK .8990..OK .=
OK .OK 91OK .OK 92.OK 939495...OK .96OK ..97...OK ..OK 9899..OK .100OK 101O=
K .OK .OK 102OK ..OK 103104105106..OK .OK .107108..OK .OK .OK 109.110.OK .1=
11.OK 112OK .113OK 114115116OK .OK 117118...OK .119OK .OK .120.121.OK .122O=
K ..123OK .OK 124OK .OK 125OK 126127OK .OK 128OK .129130OK .131OK ..132OK .=
=2E133...OK .OK .OK 134OK .135.136.OK ..137OK .OK 138OK ..139140OK ..141OK =
=2E.142.OK .143OK ...144OK .OK .145146OK .OK .147OK 148149.OK .OK .150151OK=
 152.153....OK .154.OK .155OK .OK .OK 156OK .157158159OK .OK 160OK .161OK .=
=2E.162..OK .163.....OK .164.OK .OK 165166OK .OK .OK ..167OK .OK 168169.OK =
=2EOK 170.171172..OK .173.....OK .OK .174175.OK .OK .176OK 177OK 178.179OK =
=2E.OK .OK 180181.182183.OK .184.OK .185.OK .186...OK ..OK 187.OK 188..189O=
K 190OK .191192OK .193194OK .195OK ..196....OK .197..OK .OK .OK .198OK 1992=
00.OK 201OK 202.OK 203OK .204.205..OK .206OK .207....OK ..OK 208209OK ..OK =
210OK 211212OK .OK 213OK 214215.OK 216.217OK ..218....OK .OK 219.220.OK .OK=
 .221OK 222.223OK .OK .OK 224225226.OK .OK .227228..OK .229OK .230..OK .231=
OK ..232OK .OK .OK .OK 233234OK 235OK 236OK .237238.OK 239....OK .240..OK .=
=2E241OK .242.OK .OK .OK .OK 243.OK 244OK 245OK ...246OK 247248249..OK .250=
=2E.OK .251OK .252..OK .OK .OK 253OK .OK 254.255OK 256OK .OK 257OK 258OK .2=
59260261..OK ..262.....OK .OK 263.264OK .265OK 266OK .OK .OK ..OK 267268269=
OK 270.271.....OK .272OK ..OK 273.274..OK .OK ..275OK 276277OK .OK ..278OK =
279.OK 280281OK .282OK .OK .OK .283OK .OK 284.285OK ..OK 286287OK .OK .OK .=
288289290OK .OK .291OK .OK 292293OK .294295.OK .OK .OK 296297OK 298OK .299O=
K 300OK .301302..OK .OK 303.304OK 305OK 306OK .307OK .OK 308309310.OK .OK .=
OK 311312OK 313.314OK 315OK .316317.OK .318OK .OK .OK 319OK 320OK 321.322OK=
 323.OK 324OK 325.OK 326OK .327328OK .329.OK .330.OK .OK ..331OK .OK .OK 33=
2OK 333OK .334OK .335.336337OK 338339OK .OK 340.341..OK .342.OK .343..OK .O=
K 344345OK .346.OK .OK .347OK .348OK 349350OK .OK 351OK .352353OK 354.OK 35=
5OK 356.OK 357OK 358.359.....OK .360OK .OK 361OK ..OK 362363OK 364OK .OK 36=
5.OK 366OK 367368OK 369370371OK .372.OK ..OK 373.374.OK .375.OK .OK .OK .37=
6OK 377.OK 378OK .OK 379OK .OK 380OK ..OK 381382383384.OK .OK .385386.....O=
K .OK .OK 387OK .OK 388389OK 390OK 391.OK 392OK 393OK 394OK .395396397398OK=
 .OK .399400OK .OK ..401OK 402OK ..403...OK .404.OK .OK .OK ..OK 405OK 406O=
K .OK .407408OK 409.410411OK ..OK .412413.OK .414......OK .OK .OK .OK .415O=
K 416OK 417418OK 419OK .OK 420.421OK 422423OK ..424425...........OK .OK 426=
OK ..OK .OK 427OK 428429430OK 431OK ..432OK 433.OK 434435.........OK ..436.=
OK .OK .OK 437OK 438OK ..439OK 440.441OK .OK 442443OK .444....OK ..445.OK .=
446..OK .OK .OK 447OK 448OK 449OK .OK .450451OK 452453OK 454455.456OK ..457=
=2EOK .458..OK .459OK ..460.OK .461OK .462OK .OK .463OK 464OK .465OK .466OK=
 .OK 467468.469......OK .OK .470471472OK .473...OK ..OK 474OK .OK .OK ..475=
476OK 477478....OK .479.OK ..OK 480.OK 481482OK ..483484OK ..485.OK .OK .OK=
 486OK 487.488489..OK .490OK .OK .491OK .492493.OK .OK ..494495....OK .OK .=
496OK 497OK .OK .498OK 499.OK 500OK .501502...OK ..503.OK ..504.OK ..505..O=
K .OK ..OK 506OK 507OK .OK .508509OK 510OK .511512513.OK .OK .514515OK 516.=
517...OK .OK .518519OK .OK .520521522OK .OK .523OK 524OK .OK 525.526.OK .52=
7OK .OK .528OK 529.530...OK .OK .OK 531532OK .OK 533534OK .OK 535OK ..536.O=
K ..OK 537OK .538OK 539OK .540541...OK .OK 542OK ..OK 543OK .544545..OK ...=
546547OK .OK 548OK .549550OK .OK 551OK ..552.OK .553OK .554OK .OK .555OK 55=
6557...OK ..OK .558OK 559560OK 561OK ..562OK 563564...OK .OK ..OK 565.566..=
=2E...OK .OK .OK 567OK 568.569OK .OK 570OK .571572OK .OK 573OK .574575.....=
=2E.OK .576OK ..OK 577.OK 578579.OK .580OK .OK .581582..OK .583..OK .OK .58=
4.OK .585OK 586OK .587.OK .588OK .OK ..589590OK ..591.OK .OK .592593.OK .59=
4OK .OK .OK 595.OK 596597.OK .598599.OK ..600OK 601602OK .603OK .OK .OK 604=
605606.OK .OK .OK 607608609OK .610.OK .OK .611OK .OK .OK 612.613.OK .614..O=
K .OK 615OK 616OK 617OK .OK 618.619.OK .620OK 621.622OK .623624OK .625..OK =
=2E626.OK 627.OK .OK .628629630...OK 631OK .OK .OK 632633634.OK .635OK .636=
OK ..OK 637OK 638.OK 639.640.....OK .OK 641OK .642643OK 644OK ..645OK .646.=
OK .647OK ..648......OK .OK 649OK .OK 650651OK .OK 652OK .653654....OK .655=
OK .OK 656.657OK .OK 658.OK 659.OK 660661OK .OK 662OK .OK 663664665OK .666O=
K ..667.OK ..OK 668669OK .670OK ..OK 671672673OK .OK 674OK .675OK 676OK .OK=
 677678679680....OK .OK .OK 681682683OK .684OK ..OK 685686OK 687688OK .OK .=
OK 689OK 690691692...OK .OK 693.694....OK 695.OK ..OK 696OK 697.698OK .OK 6=
99.OK .OK 700.701.OK .702OK .703.....OK .704.OK .705OK .OK .OK 706.OK 707OK=
 708.OK 709OK 710OK 711712713714...OK .OK ..715OK .716....OK .OK .OK .717OK=
 .718OK 719OK 720.721OK 722.723....OK ..724725.....OK .OK .726OK 727OK .OK =
728OK .OK .OK 729730731732733.OK .OK ..734OK .735.......OK ..736..OK .OK 73=
7OK .OK .OK .OK 738739OK 740741OK 742.743..OK .744.OK ..745...OK .746...OK =
=2EOK 747OK 748OK .OK .OK 749OK .750OK .751752OK 753754755..OK ..756..OK .7=
57...OK ..758..OK .759OK .OK .OK 760.OK 761762OK .763764..OK ..765766..OK .=
767..OK ..768OK .OK .769OK .OK 770OK ..771772773OK ..OK 774.775.OK .OK .776=
OK .777...OK .OK .OK 778.779OK 780OK .OK .781782OK 783.OK 784785786.OK .787=
OK .788OK .789.OK .790OK .OK .791792.OK .793OK .OK .OK 794.795OK 796OK .OK =
797OK 798OK .799800801...OK .802OK .OK .OK 803804805OK .OK 806807OK .808OK =
=2EOK .OK 809.OK 810OK 811812OK 813.814..OK .815OK ..816.OK .817OK .818.OK =
=2E..OK 819OK ..OK ..820821822.OK .823.OK ..OK 824OK .OK 825OK .826827.OK .=
OK 828.829OK .OK 830OK .831OK 832OK ..833834OK ..835.OK .836OK .OK 837OK 83=
8OK .OK 839.840.OK .841OK .OK .842OK 843844.845OK .846....OK .847OK .848OK =
=2EOK 849.850OK 851OK .OK ..852853OK .OK .854OK ..OK 855856857OK 858....OK =
=2EOK .OK ..OK 859OK 860861862863OK .OK .OK .864OK 865OK .866OK 867OK .868O=
K 869.870......OK .OK .OK .OK 871OK .OK 872873874875OK ..OK .OK 876.OK 8778=
78OK .OK 879880881...OK .882.OK .OK 883OK ..OK 884.OK 885.886OK .OK 887888.=
OK .OK ..OK 889OK 890891892OK .893...OK ..894OK ..OK 895OK .896897OK .OK 89=
8OK .OK .OK 899OK ..900901902OK ..903...OK ..904.OK ..OK .OK 905OK 906OK 90=
7908909OK .910.OK .OK .OK .911912OK .913914915..OK .916...OK .OK .OK 917918=
OK .OK 919920921OK .922923OK .OK .924925OK .OK 926927..OK ..928....OK ..929=
OK 930OK .931OK .932933934OK 935OK ..936OK 937OK 938.939.....OK .940OK .941=
OK .OK 942.943..OK .OK .944945.OK .OK .946OK .947OK 948949950OK 951952OK ..=
OK 953954..OK ..955..OK .956OK  SUCCESS
Bisecting: 24 revisions left to test after this (roughly 5 steps)
[aac1cda34b84a9411d6b8d18c3658f094c834911] Merge branches 'urgent.2012.10.2=
7a', 'doc.2012.11.16a', 'fixes.2012.11.13a', 'srcu.2012.10.27a', 'stall.201=
2.11.13a', 'tracing.2012.11.08a' and 'idle.2012.10.24a' into HEAD
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2012-12-23-22:21:48 aac1cda34b84a9411d6b8d18c3658f094c834911 compiling
/home/wfg/linux

2012-12-23-22:23:26 detecting boot state 3.7.0-rc2-bisect-00047-gaac1cda #1=
1 1234..567...8.9101112.....OK ..OK 13OK ..OK 1415OK .1617OK 18.19...OK .OK=
 .20OK 21OK .OK .222324...OK .25.OK .OK ..OK 26.OK 27.28OK .29OK 3031OK .OK=
 32OK .3334OK .35OK .36......OK .37OK ..OK .38OK .OK .OK 3940OK 41.42OK 43.=
OK 4445....OK .46..OK .OK ..474849OK .OK 50OK .OK 51OK .OK 52.5354OK 555657=
=2E..OK .58OK .59.OK .OK .OK .606162.OK 63OK .OK 64.OK .OK 65OK .OK 6667.68=
=2E.OK .69OK .OK 70OK ..71..OK ..OK 72OK 737475OK ..7677OK .78OK ...79OK 80=
=2EOK 81.82OK .OK .OK 8384OK .8586OK .OK ..87OK 8889.OK ..90OK .91OK ...92O=
K .93OK .OK 94OK .95OK 96OK 97OK .OK .9899 TEST FAILURE
Bisecting: 25 revisions left to test after this (roughly 5 steps)
[7bd8f2a74bcbd39f4277766f4d49441c45dd10a0] rcu: Add tracing for synchronize=
_sched_expedited()
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2012-12-23-22:28:07 7bd8f2a74bcbd39f4277766f4d49441c45dd10a0 compiling
/home/wfg/linux

2012-12-23-22:29:38 detecting boot state 3.7.0-rc2-bisect-00020-g7bd8f2a #1=
2 ..1...2.34.5OK .67OK 8OK .OK 9.OK ..1011...OK .OK .OK .12OK .OK .13OK 14.=
1516.OK .OK .OK .17.18.OK .OK .OK .19..20...OK .OK .OK 2122OK 2324OK .OK .2=
526OK ..27OK ..28OK .29OK .30..OK ..31.OK .OK 32.OK 3334OK ..OK 3536OK .37O=
K .OK 38.39OK 40OK 41.OK 42OK .4344.OK .45OK .46OK .OK 47.OK 48OK .4950..OK=
 .51OK .OK .OK 52OK 53OK .OK 54OK .55.56OK .57OK .58OK .OK 59.60OK .OK 61.6=
2...OK ..OK .63OK 64.OK 6566OK ..OK 67.OK 6869OK ..OK .OK 70717273..OK ..74=
OK .OK 75.OK 7677..OK .OK .78OK 79.80...OK .OK .OK 8182OK 8384OK .85OK .OK =
868788.OK .OK .8990.....OK ..OK 9192OK .OK ..OK 93OK 94OK .95969798OK .9910=
0.....OK .OK 101.102.OK ..103.OK .OK 104105OK 106OK 107OK 108109110111....O=
K .OK 112113.OK .114...OK .115.OK .116OK .OK 117.OK 118OK .OK 119.OK 120.12=
1..OK .122123..OK .124OK .125.OK .126OK .127.OK .OK ..OK 128129130OK .OK .1=
31132..OK ..OK 133OK .OK 134.135OK 136OK .137138....OK .OK .OK .139140141OK=
 .OK .142OK 143144OK .OK .145146OK ..147.....OK .OK .OK 148.149OK 150.15115=
2OK .OK .OK .153154OK 155OK .156.OK .OK 157.158OK .159OK .OK 160.161...OK .=
=2EOK 162OK .OK 163OK .164.OK 165166OK .167OK 168.169.OK 170OK .OK ..171.OK=
 .172..OK ..173.OK .174OK .OK 175.OK .OK 176OK ..177OK 178179.OK .OK 180.18=
1182OK .183.OK .184...OK .OK 185186.OK ..187OK .OK .OK 188OK 189.190OK 191O=
K .OK .192193194.OK .195...OK .OK ..196197OK .198.OK .OK .199OK 200OK .OK 2=
01202203OK .OK 204205.....OK .206OK .OK 207208.OK .OK 209.OK 210211OK ..212=
=2EOK .OK 213OK 214OK 215.216...OK .OK 217218.OK .OK .219OK 220.OK 22122222=
3OK .224....OK .225OK .OK .OK 226227OK 228.OK 229230OK .OK 231OK .OK 232233=
234OK .235....OK .236.OK .OK 237238.OK .OK 239OK .240241OK ..OK 242.OK 243.=
244.OK .245OK .246.OK .247.OK .OK 248OK .249250OK ..OK 251OK 252253OK .OK 2=
54.OK 255.OK 256.257...OK .OK .OK 258259OK 260.OK 261OK .262263..OK .OK 264=
265..OK .266OK .267.OK .268OK .269.OK .OK 270OK .OK 271.272OK .273...OK .27=
4...OK 275.OK .276.OK .277..OK ..OK 278279280281.OK .282..OK ..283OK .284..=
=2E...OK .285OK .OK .OK 286.287288OK .289..OK .290.OK .291......OK .292OK .=
=2EOK .293294OK .295296OK .OK 297298.OK .299..........OK .OK .OK 300OK 301O=
K 302303OK .OK 304OK 305.306OK 307.308...........OK .OK .309OK 310OK 311OK =
312..313OK 314OK .OK 315316317...OK .318.....OK .OK .OK 319320OK .321OK 322=
=2E323OK ..OK 324.325..OK .326......OK .327328OK .OK 329OK 330OK ..331OK .O=
K 332OK .333334.OK .335...OK .336OK .337.OK .OK 338OK .OK 339.OK 340.OK 341=
=2E342..OK 343..OK .344OK .OK 345346OK .OK .347348OK .349...OK .OK .350OK 3=
51OK 352353354355OK 356OK .357OK .358OK ..OK 359OK .360361.......OK .OK .OK=
 362OK 363.OK .364365OK 366OK 367OK .OK .368OK .369370OK .371........OK .OK=
 .OK 372.373OK 374OK 375376OK .377OK .OK .378OK .379380381.........OK .OK 3=
82OK .383OK .384385OK .386387OK ..OK 388OK 389OK .390391392...OK .393..OK .=
OK .OK 394395OK 396..397OK .398.OK .OK ..399400.....OK .OK .OK 401OK 402.OK=
 403OK 404405OK 406407OK .OK .408OK 409OK .410411.OK .OK .412413...OK .414O=
K .OK ..OK 415OK 416417OK .OK .418OK .419420421422OK ..OK 423.424.OK .425..=
OK .426..OK .OK .OK .OK 427.OK 428429OK 430OK .OK 431OK .OK 432433OK .43443=
5.OK ..436.....OK .OK .437438OK .OK .OK 439440441..OK .OK .OK 442OK 443OK .=
444445OK ..446447.....OK .OK 448OK ..OK 449OK 450451452...OK .OK 453.OK 454=
OK ....455456.OK .457..OK .458.OK .OK .OK 459460461.OK ..462OK ..463...OK .=
OK .OK ...OK 464.465466.OK .467.OK .OK .OK 468.469470..OK .471...OK ..OK .4=
72473OK 474OK .OK .475476.OK .OK .477OK 478479.OK .480......OK .481.OK .482=
OK ..483.OK .OK ..OK .484OK .OK 485.486487...OK .488..OK .489.OK ..490...OK=
 ..491.OK .OK .OK .492OK 493OK 494495496.OK .497.OK .OK .498499..OK .500...=
=2EOK .OK .501.OK .OK .OK 502503OK .504505OK 506.507508OK .OK .509510....OK=
 .511..OK .512...OK .513514OK ..OK .515OK ...516517518....OK .519...OK .OK =
=2E520521.OK .OK .522523OK .OK ..524525...OK .526....OK ..527..OK ..528.OK =
=2EOK .OK 529530531OK .OK 532OK ..533534...OK .OK .535.....OK .OK .OK 536OK=
 537538539OK .540OK .OK ..541OK 542543OK .544.......OK .OK 545OK .546OK 547=
548549.OK .OK 550.551OK ..OK .552553..OK .554.OK .555.OK .556OK ..OK 557OK =
=2EOK .OK 558559560561OK 562OK .563564OK .OK .565.566..OK .OK .567568OK .56=
9.OK .OK 570.OK .571OK 572OK .573574.OK ..575576OK .OK 577.578..OK .OK .OK =
579580581OK .582.OK .OK 583.OK 584OK ..585586OK .OK .587OK 588.589.OK .590.=
OK .591OK 592.OK 593OK .OK 594.595OK ..596....OK .OK .OK 597OK .598OK .OK 5=
99600601602OK .603OK ..OK 604605OK .606OK .OK .OK .607OK 608.609...OK .610.=
OK ..OK .611OK 612613614.OK .OK 615OK .OK 616OK 617OK .618OK 619620621622..=
=2EOK .623...OK .OK ..OK .OK 624625626OK 627628OK 629OK .630OK 631.OK 632OK=
 .633OK 634635636.......OK ..OK 637OK .638OK .OK 639.640OK 641642OK .OK 643=
644OK 645OK .OK .OK .646647648649OK .650.OK .651...OK .OK .OK 652OK .OK 653=
654OK .OK 655656OK 657.658OK 659OK .OK .OK 660.OK 661662.OK 663664...OK .OK=
 665666.OK .OK .667OK .OK 668669OK .OK 670.671OK 672.OK .673674OK 675OK .67=
6677678OK ..OK 679.680.OK .681OK ..OK 682683OK .OK 684OK .OK 685.686.687...=
OK .OK .OK .688.689OK 690691OK ..OK 692.693...OK .694OK .OK .OK .695OK .696=
697OK .OK 698.OK 699700OK .OK .OK 701.702703OK 704.705..OK .OK ..706OK ..OK=
 707OK .708709OK 710OK .OK 711712.OK .713..OK .714OK .715....OK ..716OK 717=
718OK .OK .OK 719OK .OK 720721.722.OK .723OK 724725.....OK ..OK 726727OK .O=
K .728OK 729OK .OK 730731OK 732733OK ...734.OK .735...OK ..736OK .737738..O=
K 739OK .OK .OK 740741.OK 742.743OK .744.....OK .OK .OK 745746.OK 747.....O=
K .OK 748OK 749OK 750751OK .752753....OK .OK .754OK 755756757.....OK .758OK=
 759OK .OK 760OK .761OK .OK 762763.OK .OK .OK 764OK .OK 765766OK 767.768...=
OK 769.OK .OK 770771..OK .772OK .773OK .OK 774.OK 775OK .OK 776OK 777OK .77=
8779OK ..780OK .781...OK .782OK .OK 783.784...OK .OK .OK .OK 785OK 786.787.=
OK .788OK ..789OK ..790OK .OK 791792.....OK .OK .793OK 794OK .795796797..OK=
 .OK 798799OK .800..OK .OK .OK 801..OK 802OK .803804OK ..805OK .OK .OK 806O=
K 807808809...OK .810..OK .OK 811OK .OK 812OK .813814815OK .OK .OK 816OK .O=
K .817818819.OK .820..OK .821OK .822OK .823OK .824.OK .OK ..OK 825OK 826.82=
7828OK .OK .829830OK .831OK ..832OK .OK ..OK 833834..OK .OK .835OK .836.OK =
=2E.837OK .OK .OK 838.839.OK ..OK 840841.OK ..842...OK .843OK .844.OK .OK .=
OK 845.OK 846.OK 847OK ..848.OK .849850..OK .851OK .852...OK .OK .853OK .85=
4.OK .OK .OK .855OK 856OK 857858859OK .860.OK .861....OK .862OK .OK .863.86=
4....OK .865OK ..OK .OK 866OK 867.868869...OK .OK .870871872OK ..873874...O=
K .OK .875.OK 876OK 877.OK 878879880881882..OK .OK ..883884OK .OK .885886OK=
 887....OK .OK ..OK 888OK 889890OK .891OK 892893OK .OK 894.895OK ..OK 896OK=
 .897898.....OK .899OK .900OK .901OK .OK .OK .902OK .903OK 904OK .OK 905906=
OK 907OK .908.909..OK ..OK 910911..OK .912OK .OK 913OK .OK 914OK 915OK ..OK=
 916917OK .918OK 919920921....OK .OK .922OK 923.924...OK .925OK .OK .OK 926=
OK 927OK .928929OK 930.931..OK .932OK .OK 933.934935.OK .936..OK .937.OK .O=
K ..OK 938939.940OK 941.OK 942943.OK .944945OK .946......OK .947OK .948OK .=
OK .OK 949OK 950OK 951952953OK .OK .954OK .955........OK .956OK .957OK .OK =
=2E958OK 959OK 960OK .OK 961OK 962OK .963OK 964965966967......OK .968OK .OK=
  SUCCESS
Bisecting: 19 revisions left to test after this (roughly 4 steps)
[351573a86d0ef17cbba1c5436706602692781bfe] rcu: Fix TINY_RCU rcu_is_cpu_rru=
pt_from_idle check
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2012-12-23-23:19:43 351573a86d0ef17cbba1c5436706602692781bfe compiling
/home/wfg/linux

2012-12-23-23:21:16 detecting boot state 3.7.0-rc2-bisect-00006-g351573a #1=
3 1.2.34..56.7OK .8.......OK .9OK .OK 10OK .OK .OK .11OK 1213OK 14OK 1516OK=
 .17OK 181920...OK .21....OK .2223..OK .OK .OK 24.OK 25OK .OK 262728OK 29OK=
 30.3132.......OK .OK 33.34OK .35OK ..OK 36OK .OK .OK 37.OK 38OK 39OK .OK .=
OK 40OK 41.424344....OK .OK 45.46OK .OK .OK 4748OK 49OK .5051OK .52OK .53OK=
 .OK 5455OK .56..OK .OK 57.58OK .59OK .60OK .OK 61OK .OK 626364...OK .65OK =
=2E.66OK ..OK 67OK .686970..OK ..OK .OK 71727374...OK ..7576.OK .OK 77OK 78=
=2E79...OK .OK 80.OK ..8182...OK .OK .8384.OK .OK 85.OK 8687..OK .88.OK .89=
=2E.OK .90OK .OK .OK .919293OK 94.OK 95OK .9697.....OK .98..OK .99...OK .OK=
 .OK 100101102OK .OK .OK 103OK 104.105106......OK .107....OK .OK 108OK .109=
110.OK ..OK 111OK ..112113114..OK ..115...OK .116OK .OK ..117118...OK .OK .=
OK .119120121.OK .122...OK .123..OK .OK .124OK 125.126OK .OK .OK 127OK ..12=
8OK 129130.131.OK .132...OK .OK .133.OK .134.OK .135.OK .136OK .OK 137OK .O=
K .138OK .139140OK 141142....OK ..OK 143OK .144OK 145146OK .OK 147.148...OK=
 .OK .OK 149OK 150..151152...OK .OK .153OK 154OK .OK 155156157.OK .158....O=
K ..OK 159.OK 160OK ..OK 161162OK 163164OK 165.166.OK .167.....OK .OK .OK .=
168169.OK .OK 170171OK .OK .172OK 173174175OK .176177.OK .178...OK .OK 179.=
OK 180OK ..181182.OK .183.OK .OK .OK 184.OK .185186187.OK .188OK .189OK .OK=
 .190191OK 192.OK 193.194....OK .OK .OK 195OK .OK .OK 196OK .197198199OK .O=
K 200201OK .202OK .203..OK .204.....OK .OK ..OK .205206OK 207OK ..OK .208OK=
 209210211212OK ..213.OK .214....OK .OK 215216OK .OK .217218..OK .OK .OK 21=
9OK 220OK .OK .221OK 222223224OK 225.OK 226227....OK .228OK .OK 229.230...O=
K .OK .231232OK .233OK .OK .OK .OK 234235.236.237...OK ..OK 238239.OK 240OK=
 .241242OK .243...OK .244OK ..245.OK .OK .OK .246.247248OK 249OK ..OK 250.O=
K 251OK .252OK 253.254.....OK .OK .255256..OK .257OK .OK .OK .258259OK 2602=
61OK 262263OK 264OK .265266267.OK .OK 268.269....OK ..270.OK .271OK .OK ..O=
K 272273274OK 275OK .276277.OK .OK .OK .278279...OK .OK .280281OK .282OK .O=
K .OK .283OK .OK 284285286OK ..OK .287288OK 289290....OK .OK .OK .291292293=
=2E.OK ..OK 294OK 295OK .OK ...OK 296297OK 298299300...OK .OK .301...OK .OK=
 302303...OK .304.OK .OK .OK 305OK ..OK .306307308..OK ..309310.OK .OK 311.=
312..OK ...313.OK .OK .314OK .OK .OK 315OK .OK 316317318OK 319OK .320321...=
=2EOK ..322OK .OK ..323OK 324325OK 326.OK .327328..OK .OK ..OK 329330331332=
OK .OK ..333334OK .OK .OK 335.336OK .337OK .338.OK .OK 339340OK .341OK .342=
OK .343OK ...344OK 345OK ..346347348OK ..OK ..349350351.OK .OK .352OK 353.O=
K 354.OK 355356..OK .OK ..357OK 358OK .OK .359360.OK .OK .OK ..OK 361362OK =
=2E363OK .OK 364.OK 365OK 366367OK 368OK .369OK ...370.OK .OK ..371...OK ..=
OK .OK 372OK 373OK .374OK 375OK 376OK 377OK .378.OK 379380.OK 381382.383.OK=
 .OK ..384....OK .OK .385OK .OK .OK ..OK 386OK 387OK 388OK 389390OK .OK 391=
OK 392.OK 393.394395396OK ..397OK 398399.400.....OK .401.OK .402OK .OK 403O=
K .OK ..404405OK 406OK ..407OK 408OK .OK 409410OK 411.412413...OK .OK ..OK =
414415416OK .417.OK ..418..OK ..OK .OK 419OK 420OK ..OK 421OK 422.OK 423424=
OK 425426427428.OK .429OK .430.OK .OK ..431432..OK ..433OK .OK .434OK 43543=
6OK .OK 437OK 438OK .439440OK 441442OK 443OK .OK .444445..OK .OK ..446.....=
OK ..OK 447OK .OK 448OK .449OK .OK 450.OK .451.452OK .OK 453.454.OK .455...=
=2E.OK .OK .456OK 457458OK .OK ..OK .459OK 460OK 461.462OK 463464......OK .=
OK 465OK .466467...OK .468OK .OK ..OK 469OK 470OK .OK 471.472473.OK ..OK 47=
4OK .475476..OK .477..OK .OK 478479OK ..OK 480OK ..481482OK .483OK .OK ..48=
4.OK .485......OK .OK .OK 486OK 487OK 488489OK 490491492.OK ..493OK ..49449=
5......OK .OK 496497OK .OK 498.OK 499OK .OK .OK 500501502503OK ..504OK 5055=
06...OK .OK 507.508.OK .509OK .510OK .511.OK .512OK .OK .513514OK 515OK .OK=
 516OK .517518....OK .519....OK .520OK .OK 521522.OK .OK .OK 523OK .524OK 5=
25OK ..526OK 527.528...OK .529OK .OK .530531.OK ..OK 532OK ..533534OK ..535=
=2EOK .OK .536OK 537538.OK .OK .539540.OK .OK .541OK .OK .542543OK 544.545.=
OK .OK .OK .546547..OK .548..OK .549..OK .550.OK .OK .551OK 552OK 553OK 554=
OK .555OK .OK 556OK 557558559.OK .560......OK ..OK 561OK 562.OK .563564OK .=
565OK .OK .566OK .567568.OK ..569...OK .OK .570571OK 572573.OK .574.575..OK=
 .OK 576577.OK .578....OK ..OK 579OK .580581.OK .OK 582.583.OK .584OK .585.=
OK .586....OK .OK 587588OK .OK .589OK .590.OK 591..592.OK .593OK .594..OK .=
OK 595.OK 596OK .597598OK .599...OK .OK 600OK 601602OK .OK .OK .603OK 604.O=
K .OK 605.606...OK .OK 607.OK 608609...OK .OK .OK 610611.612OK .OK 613OK 61=
4615OK 616617.OK .618.OK .619.OK .620.OK .OK 621.OK 622.623OK ..624OK 625.O=
K 626OK 627.628....OK 629OK .OK .OK 630631632OK .OK .633OK .OK .634635OK 63=
6.OK 637OK 638639640...OK ..OK 641OK .642OK 643OK 644OK .645646...OK ..OK 6=
47648OK .OK .OK 649OK .650651..OK .652.OK .OK 653OK ..OK 654OK 655656OK .OK=
 657.658OK 659660OK .OK .OK 661662663.OK .664OK ..665.OK ..OK 666667OK .OK =
=2EOK 668OK 669.670..OK ..OK 671OK 672OK ..OK 673674675.OK .676OK .677.OK .=
678OK .OK 679680OK ..OK 681OK .682OK 683.OK 684OK ..OK 685OK ..OK 686.687..=
OK .688OK .689OK .690OK ..691..OK .692OK ..693.OK .OK .694.OK .OK .695OK 69=
6697OK 698..OK 699.700.OK .OK .701OK 702703OK .704....OK .OK ..705.OK .OK .=
OK 706OK ..707708OK 709710OK .711OK .OK ..712OK .713.OK ..714.....OK .715OK=
 716OK .OK .OK 717718719OK 720.721OK .722.OK ..723OK ..724.OK .OK .725726.O=
K .727.OK 728OK .OK ..729OK 730.OK 731OK .732733OK .734.OK .OK 735736.OK .O=
K .737738OK .739OK .OK 740OK ..OK 741742OK .OK .743OK 744745.OK .746...OK .=
OK ..747748..OK .OK 749.OK 750OK .751OK 752OK 753OK .754755OK ..756....OK .=
OK .757758759..OK .OK .OK 760.OK 761762OK 763OK 764.OK 765OK 766.767768...O=
K .769.OK .770OK .771...OK .772OK .OK 773OK .OK 774OK .775776OK .OK 777OK .=
778779OK .OK .780781...OK .782OK ..OK 783.OK 784OK .785OK 786.OK 787788..OK=
 .OK 789.OK 790OK .OK 791792793...OK .794OK .OK .795OK 796OK 797.798..OK .O=
K 799800.OK .OK 801OK .802803......OK .OK .OK .804OK 805806807OK .808..OK .=
809OK .OK ..810........OK .OK .OK 811812.OK 813814OK 815.816.OK ..817818...=
OK .819...OK .820OK .OK .OK .OK 821.OK 822OK .823OK 824OK .825.826.....OK .=
=2EOK 827828....OK .829OK .OK ..OK 830OK ..OK 831OK 832833834835.OK .836OK =
=2E837...OK .838...OK .839OK .840OK .841OK 842OK .OK 843OK ..OK 844.8458468=
47.OK ..848.OK ..849OK .850.OK .851.OK ..852OK .853OK .OK .854OK 855OK 856.=
857OK .OK ..OK 858.859.OK .860.OK ..861862..OK ..863OK .OK .OK .864OK 86586=
6OK 867868OK .869OK 870871.OK .OK ..872873874OK ..875...OK ..OK 876OK .OK .=
=2EOK 877878OK 879.880881882..OK .OK 883OK .OK 884OK 885886887OK ..888889..=
OK .890OK ..OK 891892OK 893OK ..894895896OK .OK .OK 897OK 898899OK .900901O=
K .OK ..902.OK .903.OK .OK 904OK ..905OK .OK .OK .906907OK 908OK .OK .909OK=
 .910911..OK .912OK .OK 913.OK 914OK .915OK 916917OK .OK 918.919.OK ..OK 92=
0OK 921.922923....OK .924OK 925.926..OK .OK .OK .927.928OK .929...OK .930OK=
 .OK ..OK 931932933OK .934OK ..OK 935.OK 936.OK 937938OK .OK .OK ..939OK .9=
40.OK .OK .941942OK .OK .OK 943.944945.OK .946OK .947OK .OK 948OK .949OK 95=
0.OK .951OK 952OK 953954OK 955956OK ..957958.OK .959.OK .960OK .OK 961.962O=
K .963.OK ..964OK .OK 965OK .OK  SUCCESS
Bisecting: 13 revisions left to test after this (roughly 3 steps)
[d484a215139cf556cb718a7ec7042260b7fc2d28] rcu: Add documentation for the n=
ew rcuexp debugfs trace file
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2012-12-24-00:10:25 d484a215139cf556cb718a7ec7042260b7fc2d28 compiling
/home/wfg/linux

2012-12-24-00:11:59 detecting boot state 3.7.0-rc2-bisect-00006-gd484a21 #1=
4 1...2.3..4..5.OK 6OK ..7OK 8OK .OK .9OK 10OK 111213.OK .14.OK .15.OK ..16=
17.OK .18.OK .OK .OK 1920OK .OK 21.OK 2223OK 2425OK ..2627OK .OK .28.OK .29=
=2E.OK .30....OK .OK 31OK .OK 32OK .OK 33.3435OK .OK .OK 363738..OK .39..OK=
 .40OK .41OK .42..OK .OK 4344OK .OK .45OK .4647.OK .OK .48..OK .49...OK .50=
OK 51OK .52OK .OK .53OK 54OK .5556....57OK .58.OK .OK .5960OK .61...OK ..OK=
 62OK ..636465OK ..OK .666768OK ..69..OK ..70OK .71OK .72.OK .OK ..73OK .74=
OK ..OK 75767778.....OK .79OK .OK .8081.OK .OK .OK .8283OK ..84...OK .OK .8=
58687..OK .OK .8889.OK .OK .9091OK .92OK .93..OK .OK .OK .OK 9495OK 9697OK =
=2EOK .98..OK .OK ..OK 99100OK 101OK .102.103.OK .104...OK .OK .OK .OK 1051=
06107OK 108OK .109110.OK .OK .OK 111.112113114..OK ..115.OK .116OK .OK 117O=
K .OK .OK 118.119120OK 121122OK .OK 123OK .124125OK .OK ..126127.OK .128.OK=
 ..OK 129.OK 130OK .131OK 132OK ..OK 133134OK 135136OK 137OK ...138139OK .1=
40.OK .141OK .OK .OK 142.143OK .OK .OK 144OK .145OK 146.147OK .OK 148149.OK=
 .OK ..150.OK .OK 151152..OK .OK .OK .OK 153OK .OK 154OK 155156OK 157158159=
OK .OK 160.161..OK ..162OK .OK 163.164165OK .OK .OK .166167168OK .OK 169OK =
=2EOK 170OK ..OK 171OK 172173174175..OK .176OK ..177OK 178.179OK ..OK 18018=
1.OK 182OK .183184OK .OK .OK .OK 185OK .186187188OK .189.OK .OK .190OK 1911=
92.OK .OK .193OK 194.OK .OK 195OK 196197198OK ..OK 199OK 200OK ..OK 201202.=
OK 203204OK .205OK .OK 206.207.....OK .208OK .OK .OK 209210211OK 212OK .OK =
213.OK 214OK .215.OK 216217OK .218OK .219OK .220.....OK .221.OK .OK .OK 222=
OK .223OK 224OK 225.OK 226.227OK 228OK .OK .229OK .230OK .231232....OK ..23=
3.OK .234OK .OK 235OK .OK 236237OK .OK 238OK .239OK 240241.OK 242OK .OK 243=
=2E244OK 245246...OK .OK 247OK ..248.OK .249OK .OK .250OK 251OK .OK .OK 252=
253254255.OK .OK 256OK ..257.OK .258.OK ...259OK .260OK .OK .261262.OK ..OK=
 263OK ..OK 264265266OK .267268OK 269270...OK ..OK 271272.273.OK ..274.OK .=
275..OK .OK 276.OK 277278OK .OK 279.OK 280OK 281.OK 282.283OK .OK .284.OK .=
285.OK ..286OK 287288.OK .289OK .290OK .OK ..291292OK 293OK 294OK .295OK 29=
6OK .297OK 298OK .299300OK .301OK ..OK 302OK .303OK 304.OK 305OK .306OK .OK=
 307308309OK ..310OK 311.312OK .OK .313OK .OK 314.315.OK .OK .316317OK .OK =
318.OK 319320OK ..321OK .OK ..OK .322323324.OK ..OK 325OK ..326.OK .OK .327=
OK 328.OK 329OK .330..331OK ..332333OK .OK ..334OK 335OK .OK .336337OK .OK =
=2E338OK 339340OK .341....OK .OK .342OK .OK ..343344OK .OK .345.OK .346OK .=
OK .347OK .348349OK .350.OK .351..OK .OK 352.353OK .OK .354.OK 355.356OK ..=
=2EOK 357OK 358OK .OK 359360OK 361OK .362..363OK .364..OK .365..OK .OK .OK =
366OK .OK 367368369OK 370371.OK 372373OK 374OK .375.376OK .OK .377378OK 379=
OK .380381...OK .382OK ..OK 383OK 384.OK 385OK .OK 386.OK 387388OK .389390O=
K .OK 391OK .392OK 393.OK 394395..OK .396..OK .OK ..397OK 398OK .OK .OK 399=
=2EOK 400401402OK .OK 403OK .404OK 405.OK .406407OK ..408....OK .OK .409OK =
410411OK .OK .OK 412413414415OK .OK ...........416OK .417....418OK ....4194=
20.......OK ..421..OK .422....OK ..423424OK .OK ..425426..OK ..427..OK .428=
=2E....OK .OK .429.OK .OK .430431432.OK .433..OK ..434435....OK .OK .436437=
=2E........................OK .OK .438439440...OK .441.............OK ..442=
=2EOK .OK .443OK ..444OK 445446447....OK .448...OK .OK .449450.OK .451.OK .=
OK .OK ....452453454OK 455456....OK .OK .457458OK .459.OK ..460.....OK .OK =
461OK .OK 462OK 463464465OK .OK ..466OK .467.OK .468.....OK .469OK ..OK 470=
OK ..471OK 472OK ..473OK 474OK 475OK .OK 476477478OK ..479480..OK .OK .481O=
K 482OK .483484OK .OK 485.486OK .OK .OK ..487OK 488OK 489490491OK .OK 492OK=
 .493494OK .OK .OK 495.496497..OK .OK .498OK 499OK .500501.OK ..OK .502OK 5=
03.OK 504OK 505OK .506.OK .OK 507OK 508509.510511OK .OK 512.513OK 514.OK .5=
15...OK .OK .OK 516517518.519.OK .OK .OK ..OK 520OK 521.OK .522..OK 523524O=
K .525526....OK .OK .527OK 528.529530OK .531.OK ...OK 532.533OK .OK .OK .53=
4OK 535OK 536537538539540...OK .OK .OK 541OK .542OK .OK 543.544545OK 546OK =
=2E547...OK .OK .OK .548OK .OK 549.550551552.OK .553OK ..OK 554OK 555.OK 55=
6OK .557558OK .559OK ..560.OK .561OK .OK 562.OK 563..564OK 565OK .566OK .OK=
 567568OK 569OK .OK 570.OK 571572.OK 573574..OK .575OK ..OK 576577.OK .OK 5=
78579..OK .OK 580OK .581OK .582OK .OK 583OK .584OK .585586OK .OK .587588OK =
=2EOK .589590.OK .591OK ..OK 592593..OK .594OK .595.OK .OK .OK 596OK .OK 59=
7598OK .599600OK .OK .601602OK .OK .603.OK .604OK .605OK .OK .606607OK .OK =
=2EOK 608OK 609610611.OK ..612OK .OK .613614...OK .OK 615OK ..616617....OK =
=2E618OK 619.620621OK ..622.OK .OK 623OK .624625...OK .OK 626.OK .627OK .62=
8OK 629OK ..630OK .OK .631632633.OK ..OK 634635OK .OK ..636637OK ..638OK .6=
39.OK .640.OK ...641OK .OK .642643644OK .OK 645.646.OK .OK .647648OK 649OK =
=2E650651OK .OK .652653.OK .OK .654OK 655656657.OK .658OK .659660..OK .OK .=
661OK 662OK ...OK 663OK 664OK ..665666OK .OK 667.668.OK .669OK ..670OK 6716=
72...OK .673.OK .OK ..OK 674OK .675676OK 677OK 678OK .679OK 680.681...OK .6=
82...OK .683....OK .OK 684OK .OK .OK 685686687OK 688OK ..OK 689690691..OK .=
692.........OK .OK .................693....................................=
=2E...........................OK 694.695696..................OK 697..OK .OK=
 .OK 698OK 699OK ...OK .700701702703......OK .704...OK .705706...OK .OK ..O=
K .OK 707708OK .709710711....OK .712OK .713.OK .714........................=
=2E........................................................................=
=2E........................................................................=
=2E..........................................................OK .OK ..71571=
6...................OK ..717..OK .OK .OK ...OK 718OK 719720721722723.......=
OK .724......OK .OK 725.726OK .OK .OK .OK .OK 727.728.729730731..OK .OK .73=
2733..OK ..734OK .735..OK .736.OK .OK 737738OK .OK 739OK 740OK .OK .741...O=
K ..OK 742.743.OK .744.OK .OK ..OK 745OK .OK 746...747748OK ..749OK 750.751=
=2EOK ..OK 752753.OK .754..OK .OK 755756OK .757758.OK .OK ..759OK .OK 76076=
1OK 762763764765.OK .766.OK ..767..OK .768OK ..OK 769770..OK ..771OK .OK .7=
72OK 773OK .774775OK 776777778.OK .OK .779OK .780OK .781..OK .OK .782OK ..7=
83OK .OK .OK .OK 784OK .785786787OK 788.OK .789790791..OK .792..OK ..793OK =
=2EOK 794OK .795OK 796OK .OK .797OK 798OK .799800OK .OK .OK 801..802OK .OK =
=2E803804...OK .805OK .OK .806807OK .808OK ..OK .OK 809OK 810811OK 812813.O=
K 814.815OK .816817...OK .818OK .OK .819OK .OK .820OK 821822.OK 823OK .OK 8=
24.825OK .826...OK .827.OK .828..OK .OK 829830831...OK ..832...OK .OK 83383=
4.OK .835..OK .OK 836OK .837838...OK ...839.OK .OK 840.841OK .842......OK .=
843OK .OK .844845OK ..846847.OK .848OK .OK 849.850.....OK .851852OK .853..O=
K .854OK 855856OK .OK 857.858OK ...859...OK .OK .OK .OK 860.861..OK .862..O=
K 863OK ..864865OK .866867.....OK ..OK 868.869OK 870871..OK .872OK .OK .873=
874OK .OK .875876OK .OK 877878.....OK .OK .OK .OK 879880881882OK ..883.OK .=
=2E884OK 885OK .886.OK .887...OK .OK 888.OK 889890.OK 891.892..OK .OK .OK .=
OK 893OK .OK 894.895.896OK ..897....OK .OK .898OK .OK 899OK .900901...OK .O=
K ..902OK .OK 903OK .904905OK 906907OK .908OK 909OK .OK 910OK .911912OK 913=
914..OK ..915.OK .916OK ..917OK .OK .OK 918OK .919OK .920.OK 921.OK .OK 922=
OK .OK .923924925OK ..926.OK .927OK .928OK .OK 929OK .OK 930OK 931932OK 933=
934..OK .OK .935OK .OK 936OK ..OK 937.938OK .939...OK .OK 940.OK 941OK .OK =
=2EOK 942.943944.OK .945OK ..946OK .OK 947OK .948OK 949950...OK .951OK .952=
=2EOK .953OK .OK ..OK .954.OK 955OK .956OK 957958.OK .OK .OK .959960..OK .O=
K 961.962.OK .963.OK .OK .OK 964.965OK 966OK 967OK .968OK 969970.OK .OK  SU=
CCESS
Bisecting: 8 revisions left to test after this (roughly 3 steps)
[af71befa282ddf51c09509978abe1e83de8fe7eb] rcu: Wordsmith help text for RCU=
_USER_QS kernel parameter
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2012-12-24-01:09:13 af71befa282ddf51c09509978abe1e83de8fe7eb compiling
/home/wfg/linux

2012-12-24-01:10:45 detecting boot state 3.7.0-rc2-bisect-00005-gaf71bef #1=
5 12.3...45.67OK .8...OK ..OK .91011OK .OK ..1213OK 14OK .OK 15OK .1617OK 1=
8OK .19.20..OK .OK 21.22...OK ..23OK ..OK 24OK .25OK 26.OK 27OK .28OK 29OK =
30OK .31.32......OK ..33.OK ..OK 3435OK 36OK ..OK .OK 37OK 38OK 3940OK .414=
2.43.....OK .OK .4445..OK 46OK .OK .OK .47OK 4849OK 50.OK 51OK 52OK ..53545=
5OK .OK 5657.....OK .OK 5859OK .6061OK .62.OK .OK .OK 63.64OK 65OK ..66OK 6=
768OK .69..70OK .OK .OK 71OK 72.7374.OK ..75...OK ..76OK 77OK .OK .78OK .79=
OK .80OK .OK .OK 81.82OK 83...OK ..OK 84OK .8586OK ..OK 87OK 88.OK 8990OK .=
=2EOK .9192...OK .93...OK .OK 94.OK 95.9697OK ..OK 98OK .OK .OK .99OK 10010=
1OK 102103104.....OK .OK 105OK .OK .106.OK 107108.OK .109110.OK .OK ..OK 11=
1112OK 113114OK 115OK .116117OK 118.119OK .120OK .OK 121.122..OK .123124...=
OK .OK .125OK 126OK .127OK 128OK .129130OK 131132OK .133134OK .OK .OK .1351=
36..OK ..137..OK .OK 138.OK 139140OK .OK .OK .OK .OK .141OK 142.143144145OK=
 .OK ..146147....OK ..OK .148149.....OK ..OK 150OK 151OK .OK 152.153OK 154O=
K 155156157158OK .OK .159OK 160.161......OK ..OK 162163..OK .OK .OK 164OK .=
165OK .OK .166.OK 167168OK 169.170...OK .OK 171172...OK .173..OK .174OK ..O=
K 175OK 176OK .OK .OK 177178179180181...OK .OK 182.183.....OK ..184OK .OK .=
185186OK .OK .OK .OK 187188189OK .190191192.OK .OK 193194....OK .195..OK .O=
K .OK 196197198OK .OK .199OK 200OK .OK .OK 201202203OK 204OK .205OK 206.207=
=2E.OK .208OK .209..OK .OK .210OK 211.212.OK .OK 213OK .OK 214215OK 216.217=
OK .OK 218.OK 219220..OK .OK 221OK .OK .222223OK .224.OK .OK .225226OK .OK =
227228OK .OK 229.OK 230OK .231OK .232233OK .OK 234235OK .OK 236237.....OK .=
OK 238OK 239.OK 240OK 241242OK 243.244OK .OK 245OK ..246..OK .OK .247.OK 24=
8.249..OK .OK .OK 250OK 251.OK .252253254...OK ...OK 255256OK 257OK .OK .25=
8.259OK .OK .260.OK ..261OK .262OK .OK .263....OK .OK .OK .OK 264265OK .OK =
266.267.OK 268.269.OK .OK .OK 270271272273OK .274..OK .275..OK .OK ..OK 276=
277OK .OK .OK 278OK 279.280281OK 282.OK 283OK .284285...OK .286OK .287..OK =
=2E.OK 288289.OK .OK ..OK 290OK 291OK ..292293OK 294.OK 295296....OK .OK .2=
97.298OK .OK .299300.OK .OK .OK .301.OK 302OK 303OK 304.OK 305306307308.OK =
=2EOK .309310OK .OK .311312313.....OK .314OK .OK .OK 315316317OK 318OK ..31=
9320.OK .OK .321322.OK .OK .323324325...OK ..326OK .OK .OK 327OK .328329OK =
330OK ..331332.....OK .OK .333334...OK ..OK 335336OK .337..OK .OK .338339OK=
 .OK 340341.OK 342OK .343OK ..344OK .345.OK .346OK .347..OK .348.OK .OK .OK=
 .OK 349OK .350351OK 352353354..OK .OK 355OK .356357.OK .358...OK .359360..=
=2EOK .OK .OK 361OK 362363364OK 365OK .OK .366OK 367368369...OK .370.OK ..3=
71....OK .OK .OK 372OK 373OK .374OK 375OK 376OK .OK 377OK 378OK .379380381O=
K 382.383....OK .OK 384.385...OK .386OK .OK 387388OK .OK .OK .OK 389390OK .=
391392393..OK .394OK ..395OK .396OK ..397.OK ..OK 398.399OK .OK .OK 400OK 4=
01OK .OK 402.403OK 404405406OK 407408OK .409..OK ..OK 410.411OK .412....OK =
=2EOK 413OK .OK .414OK .OK .OK 415OK .416OK .417418419.OK .OK .OK .420OK 42=
1.422..OK .OK .423424...OK .425OK ..OK .OK 426OK 427OK ..428OK 429OK 430OK =
431432433434OK 435.436OK .437....OK .438OK .439OK .440..OK .OK .OK .OK .OK =
441OK 442443OK 444445OK .446OK 447.448OK .449.OK .450.....OK .451.OK .OK 45=
2OK .OK .OK .453OK .454OK 455456457458...OK .459.....OK ..460OK .461OK .OK =
=2E462OK 463OK .OK 464OK 465466467OK 468469470..OK .471.OK ..472OK .OK 473.=
OK 474OK .475..OK .476OK ..OK .477OK .OK 478479..OK .480OK .481..OK .482OK =
=2EOK 483OK ..484.OK .OK 485.OK 486OK .487OK 488OK ..OK 489490491...OK .492=
OK .493OK ..OK 494OK .495496OK 497.OK 498499.OK .OK .500OK .OK 501.502.OK .=
503.OK .504....OK .OK .OK 505506OK 507OK 508509510.OK .511512OK 513OK ..514=
=2E..OK .515....OK 516OK .OK .517OK 518OK 519OK .520OK 521522OK 523524.525.=
OK .526......OK .OK .OK 527528OK 529OK .530531OK .OK .OK 532OK .OK .5335345=
35.OK .536..OK .OK .537OK .538OK 539OK .OK 540.OK 541OK 542543544.OK ..545O=
K ..OK 546547548OK .549..OK .550OK .OK .551OK 552OK .553OK 554.555OK 556557=
=2EOK .558.OK .OK 559OK ..OK 560561562.OK 563OK ..OK 564565566OK .OK ..567O=
K .OK 568.569..OK .OK .OK .OK 570571572573..OK .574OK .OK .OK .575576.OK .O=
K .577OK .OK 578.579580...OK ..OK 581OK .582..OK 583OK 584OK ..585586.OK .O=
K .OK 587OK 588.589590....OK .591OK .592....OK .OK ..593OK .OK 594..OK 5955=
96OK .OK 597598OK .OK 599OK .600601..OK ..602...OK .OK 603OK .OK .604.605OK=
 606OK .OK .OK .607608OK .609610OK .OK 611..612613....OK .614..OK .OK 615OK=
 ..616617.OK .OK ..OK 618OK 619.OK 620621622OK .OK .623OK .624625626....OK =
=2E627.OK .OK .OK ..628OK 629630OK 631.OK 632OK ..633OK .OK 634635OK .63663=
7638639...OK ............................640OK ............................=
=2E...........................OK ..........................................=
=2E......................................OK .641642643................OK .6=
44....OK .OK ...OK .OK .OK 645.646647648649650..OK ..651.........OK .652..O=
K .653OK .OK .OK .OK .OK ...............654OK ...655656657658659...........=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E..............................................................OK .OK .66=
0661662......................OK .OK ...663.OK 664OK .665666667668..........=
=2E.OK .OK .669670.OK .671OK ..OK 672OK ..673.674675676677.....OK .OK ..678=
=2E....OK .679.OK .680.OK .OK 681OK 682OK 683OK 684.685..OK .OK 686687OK .6=
88.OK ..689....OK .OK .OK ..OK 690OK 691OK .692OK .693694695OK .696OK ..697=
=2E..OK .698.....OK .699OK .OK .700OK .....................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E............................................................701.........=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E...........................................OK ..........................=
=2E.......................OK 702.703........................OK .OK ..704OK =
705OK .OK .OK ...706707708............OK .709710...OK .OK .OK .711712OK 713=
OK .OK ....714715716717.....OK .OK .OK ..OK .OK 718719.720.OK ..721..OK .72=
2OK .OK 723OK 724OK 725726...OK .OK 727OK 728OK 729OK .730..OK ..731....OK =
=2EOK 732OK .OK ..733734OK .OK .OK .OK 735736OK 737.OK 738OK 739740741..OK =
=2E742....OK ..743.OK .OK .OK .OK .744745746.OK ..OK .OK 747.OK 748.7497507=
51.....OK .752....OK .OK .OK .OK .753.754755OK ..OK 756OK .OK .OK 757758.75=
9760......OK 761.OK .OK .OK 762763764OK .765.OK .OK .766OK 767OK ..76876977=
0.......OK .OK 771772OK .OK .OK .773OK 774OK .OK .775776.OK .777.OK .OK .77=
8.779.......OK .OK .OK 780OK 781OK .782783OK 784OK 785OK ..786OK 787.788.OK=
 .789OK ..790791.....OK .OK .OK 792793OK 794OK .OK 795796OK .797OK .OK .798=
799OK .OK .800801.....OK .802OK ..OK 803804OK .OK 805OK 806807808OK ..809OK=
 ..OK 810811OK 812.813814.OK .815....OK .OK .OK 816817OK 818OK 819820OK .82=
1OK 822.OK .823OK .824825.OK ..826OK 827.828....OK .829OK .OK .830OK .83183=
2OK 833834.OK .OK .OK 835836837838OK .OK .839OK 840.841....OK .OK 842843OK =
=2EOK 844.845.OK .OK 846OK .847OK .OK .OK 848.OK 849850.851..OK .OK 852.853=
OK .OK .854855OK .856.OK ..OK 857.OK 858859OK .OK ..860861OK .862OK .863OK =
=2EOK ..864.OK .OK 865.OK 866..867..OK ..OK 868..OK 869OK ..870OK 871OK .87=
2873.OK ..874OK 875.876..OK .877....OK .878....OK .OK ........OK 879OK .880=
=2E.OK .881...............OK .OK .882.OK .OK 883..884OK 885886887...OK .888=
=2E......OK ..OK 889OK ..890OK 891OK .892.893OK .894OK .895OK .896897.....O=
K .898....OK .899OK ...OK 900OK 901OK .902903OK .OK ..OK 904905906....OK .9=
07OK .908..OK .OK 909910OK .OK .OK 911.912OK 913OK 914OK ..915916..OK ..OK =
917.918.....OK .OK .OK 919.OK 920921OK .OK .OK .922923924OK 925926OK .927.O=
K .928.....OK .OK 929OK .930931932OK .OK .OK .OK 933OK ..934.935OK 936937..=
=2E..OK .938....OK ..OK 939.OK 940.941OK .942.OK ..OK 943OK 944945946947...=
=2EOK .948.OK .949OK .OK ..OK 950951.952.OK .OK .OK .OK 953OK .954OK 955OK =
956957958959...OK .960OK ..961.OK .OK .962OK .OK 963964965.OK .966OK .OK .O=
K 967OK .OK 968OK 969970.OK 971972973OK .974..OK .OK .OK 975.976977OK 978.9=
79.OK .980.OK ..OK 981OK  SUCCESS
Bisecting: 4 revisions left to test after this (roughly 2 steps)
[cda4dc813071e6cb04944c5a140610bd06acd295] rcutorture: Use DEFINE_STATIC_SR=
CU()
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2012-12-24-02:38:32 cda4dc813071e6cb04944c5a140610bd06acd295 compiling
/home/wfg/linux

2012-12-24-02:40:08 detecting boot state 3.7.0-rc2-bisect-00004-gcda4dc8 #1=
6 .1...23.....4OK 56OK ..OK 7OK .8910OK 11..12OK .13....OK .14OK .15...OK .=
OK ..16OK 1718OK .OK .19OK 2021OK .OK 22OK .23.2425..OK .26OK .27...OK .OK =
28.OK .2930OK .OK ..OK .31OK 32OK .33OK 34OK 35..36OK 37.OK .3839..OK .4041=
=2EOK .42...OK ..OK .43.OK 44OK .4546OK .OK ..OK .474849.OK .OK ..5051..OK =
=2E52OK ..53OK 5455..OK .56..57.OK .OK .OK .OK 58.5960OK .OK ..6162OK .63.O=
K .64OK .65.OK ..66OK 67.68...OK .OK 69OK ..7071OK 72OK .OK .OK .73747576OK=
 .OK ..77OK ...OK 78.79..OK ..80.OK .OK .OK .81.82OK 83OK .OK ..8485OK ...8=
6OK ..OK 87.88..OK .OK .8990OK .OK ..91OK .OK ..92OK 93OK .OK 94.OK 95.OK .=
=2E9697OK ..OK 98.99.OK .OK .100101102OK .103..OK ..104105.OK ..106OK .OK .=
OK 107.OK 108109OK .110111.OK .OK .OK .112113OK 114.115..OK .116117.OK .118=
OK .OK .119120OK .OK ..OK 121122OK .OK .123OK 124OK 125126127.OK .OK .12812=
9OK .130....OK .OK .131132..OK .OK ..OK 133134OK ..OK 135OK 136.OK 137OK .1=
38139140...OK .141142...OK .OK .OK .143144OK 145OK ..146OK 147OK .OK .OK 14=
8..149.150151..OK .OK .152153OK ..154.OK .OK 155.156OK .OK .OK .157.OK 158.=
=2EOK 159OK .OK 160OK .OK .161162OK 163.OK ..OK 164165166..OK ..167..OK .OK=
 .OK .OK .168169170171172.OK .OK .OK .173.OK .OK 174OK 175OK ..176177OK ..1=
78....OK .179OK .OK .180181....OK .182OK .OK .OK ..OK .OK 183OK 18418518618=
7OK 188OK ..189OK .OK .190191OK .192....OK .193.....OK .OK .OK ..OK ..19419=
5OK 196197198OK .199200OK 201202....OK .203......OK .204.OK .OK .OK .OK 205=
OK .OK .206OK 207OK .OK 208OK 209210OK 211..212213214......OK .OK .215216.O=
K .217OK ..OK 218219OK .OK .OK .OK 220.221OK .OK .OK ..222223224OK 225..226=
OK .227OK .228OK .229.OK ..230..OK ..OK 231..232.OK .OK .233OK 234235236OK =
=2E.237.OK .OK 238.239..OK .240.OK .OK .241242OK .OK .OK 243OK 244OK 245.24=
6OK 247.248OK ..OK 249250OK .251...OK .OK ..252.OK ..OK 253OK 254OK .OK .OK=
 .255256OK 257.OK 258259OK 260261....OK ..262.OK ..OK .263264OK .OK ..265.O=
K .OK 266.OK 267OK .OK 268OK 269270271272...OK .273...OK .OK .274275OK .OK =
276.277278..OK .OK ..OK 279OK .OK .280281.282.OK .283OK .OK .284285.OK .OK =
286.287OK .OK .288289290OK .OK .OK 291.292OK .293OK ..294OK ..295OK .OK .29=
6OK .OK 297.298OK 299.300OK 301OK ..302303..OK .OK .OK .OK 304305OK 306.307=
=2EOK .308OK .309.OK .OK .310OK 311OK .OK 312.313314...OK ..OK 315316317..O=
K .318.OK .OK 319OK ..320OK .OK 321OK ..OK .322OK 323.324OK .325326.OK .OK =
=2E.327328OK 329330OK .OK .331332OK ..333OK ..334335OK .OK 336.OK .337338..=
OK .OK .OK 339340OK .OK 341OK 342343OK 344OK .OK 345346347...OK .OK .OK 348=
OK 349.350351OK ..352...OK .353OK ..OK 354355.OK 356357OK 358.359..OK .OK .=
OK .360OK 361362.OK 363.364..OK .OK 365366OK .367OK .OK 368OK ..369370..OK =
=2EOK .371..OK .OK .OK 372.OK .....373OK .374.375OK 376377.378379...OK ..38=
0.OK ..381....OK .382OK .OK ..383OK 384OK .385.OK 386OK .OK ..387388.OK ...=
389.OK ..390.OK .OK .391392..OK .393OK .394OK ..395396OK .OK .397OK 398.399=
OK ...OK 400.OK .401402OK ..OK 403404405.OK .406...OK .407408OK .OK .OK .40=
9OK 410OK .OK 411OK .412.OK 413OK 414415.416417....OK .418.................=
=2E........................................................................=
=2E........................................................................=
=2E.........................................OK ..419420421.................=
=2E....OK .OK ..422.OK .OK .OK ......423424425........OK ...426...........O=
K .OK .OK ...OK ...427428429430431OK ...432...............OK 433OK 434OK 43=
5OK 436OK 437OK 438OK 439440441............OK .OK .OK .OK .442443OK 4444454=
46OK 447OK .OK .OK ...448449450451452.....OK ..453...OK ..OK 454OK .OK .455=
456...OK .OK .OK 457OK 458OK .459.460461462.OK .463........................=
=2E..................................................OK ...................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E...............................................464.OK 465466............=
=2E.........OK ..OK .OK ..467OK .OK 468OK 469OK ....470471...........OK ..4=
72OK .OK 473.474OK .OK .OK 475476477OK .OK .OK .OK ..478OK ...479..........=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E.....................................480OK 481OK ...482............OK ..=
=2E...483484.OK .485..OK .OK ..OK .OK ..486487488489490....OK .491.OK .OK .=
OK ....492...OK .OK .OK ..493494495OK 496OK ...497..OK .498.OK ..499.OK .OK=
 ..500.501...OK .OK 502OK .OK 503..OK 504OK 505.506OK .507..OK .508OK .OK 5=
09510...OK .OK .511OK .OK 512.OK 513OK 514OK .515516OK 517518519OK ..OK 520=
=2EOK .521522.OK .523....OK .524OK .525OK .526527OK .OK 528.OK .OK 52953053=
1532.OK .OK ..533534.....OK .535OK .536.OK .OK 537OK .OK 538.539OK .540OK .=
OK ..OK 541.542OK 543......544OK ................................545OK 546.=
547548.....................OK .549OK 550OK .OK ...OK .OK 551552553.554555..=
=2E.......OK 556..OK .557.OK .558..OK .OK .OK ..OK .OK 559..560561562563...=
=2EOK .564OK ..OK 565.566..........OK ...567OK 568569.OK 570OK .571OK .572.=
=2E..........OK .OK .OK .OK ....573574OK 575576OK 577578OK 579580..........=
=2E.......OK .OK 581OK .OK .OK .OK .OK 582..583584585586587588........OK .5=
89......OK ..590.OK .OK .OK 591OK .OK 592..593594595OK .596.......OK 597...=
OK .OK 598.OK 599.600OK .OK .OK .601OK .602OK 603.604605606.OK .607..OK .60=
8..OK .609.OK ..610...OK .611OK .OK 612613OK .OK .OK ...OK .614615616OK .61=
7618....OK ..OK .619620OK 621622OK ..623...OK .624OK .OK .OK ..OK ..OK 6256=
26627628629630..OK .OK ..OK 631632633OK 634.635..OK .636.OK .OK 637OK .OK 6=
38OK 639.640OK 641642OK ..OK .OK 643.OK .644OK 645646647.648..OK .OK 649.65=
0OK .651OK ..OK 652OK .OK 653OK .654655656OK ..657OK .OK .OK 658OK .OK 659O=
K 660.661662OK .663OK .OK 664.665OK .666.OK .667OK .OK .668669670OK ..671OK=
 .672.OK .OK .OK 673OK ..674675.OK ...OK 676677OK 678OK .679OK 680.OK .681O=
K 682OK .OK 683.684685.OK .OK ..686OK 687OK .688OK 689.OK 690OK ..OK .OK 69=
1692OK .OK 693.694695696.OK .OK .697698...OK .OK .OK .OK .699700701...OK .O=
K .OK 702.703OK 704OK 705OK .OK .706.707708709.OK ..OK 710.711OK .OK ..7127=
13..OK ..OK 714OK .OK 715.716717OK .718OK ...719.OK ..OK 720721722.OK .OK .=
OK 723724725.OK .726.OK .OK .OK 727728OK .OK 729730.OK 731732733.OK .OK .OK=
 .734.735OK 736.OK .737738OK ..739..OK .740.OK .OK 741OK .OK 742743OK 74474=
5746747.OK .OK 748OK .OK .749OK .OK 750.751OK ..752OK .753OK ..754755..OK .=
OK .OK .OK .756757OK 758759760OK .OK .OK .761OK .762763OK 764.OK 765.766OK =
=2EOK ..767...OK .OK 768OK .OK .OK 769770OK 771772773OK 774.OK 775OK .OK .O=
K 776OK 777778OK 779OK .780781..OK .782...OK .OK .OK .OK 783OK 784.OK 78578=
6OK 787788789OK .OK .790OK ..791OK 792OK .793794795OK 796.797....OK .OK 798=
=2E799OK .OK 800OK .OK 801.OK 802OK .803OK .804805OK .OK .OK 806OK .OK .OK =
807808809810811.OK .812OK ..813OK .814.OK .OK .815OK 816OK .817.818.OK .819=
=2EOK .OK 820OK .OK ..821822OK 823824OK .825826OK .827..OK 828OK ..OK 829OK=
 ..830831...OK .832.OK .OK 833.OK 834OK .OK .OK 835836.837..OK .838OK .839.=
OK .OK .OK 840841842..OK ..843OK .844OK ..OK 845846OK .OK 847OK ..848.OK .O=
K 849850..OK ..OK 851OK .852..OK .OK ..OK .853OK 854.OK 855OK 856.OK 857OK =
=2E858859860.OK .861OK .862OK ..863......OK ..OK .OK 864.865OK 866OK .OK .O=
K 867.OK 868869OK 870OK ..871......OK .872...OK ..OK 873OK .874OK .OK 875OK=
 876OK .877OK 878879880OK ..881882.OK .883.......OK ..OK 884OK .OK 885OK .8=
86OK .887OK 888OK .889.890OK .891892OK .893...OK .OK .894895OK .OK 896.897.=
=2EOK .OK ..OK 898.OK 899900OK .OK .OK 901.902OK 903904905906.OK .OK .907OK=
 908.OK 909.910...OK .911OK .OK ..912OK 913.914OK ..OK .OK .OK 915916917OK =
=2EOK 918919920OK .921OK 922923.924..OK .925..OK ...OK 926927...OK ..OK .OK=
 928OK .OK 929930OK 931OK 932OK 933934935936..OK .937...OK .OK .OK .938.OK =
939940..OK ..OK 941OK .942OK .OK 943OK .OK 944OK 945..OK 946947.948....OK .=
OK .949OK 950951952..OK ..953OK ..954OK .OK .955OK 956.OK .OK 957.958OK 959=
960OK .961962OK ..OK 963OK .964965.OK .OK ..OK 966.967.OK .968..OK .OK .OK =
969OK .OK 970971OK .OK 972.OK .973OK 974OK 975976977..OK ..OK 978979980OK .=
981...OK .982OK  SUCCESS
Bisecting: 2 revisions left to test after this (roughly 1 step)
[eee058826100e5a344f11601e0c47baeaf07c77b] rcu: Add grace-period informatio=
n to RCU CPU stall warnings
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2012-12-24-04:01:10 eee058826100e5a344f11601e0c47baeaf07c77b compiling
/home/wfg/linux

2012-12-24-04:02:50 detecting boot state 3.7.0-rc2-bisect-00002-geee0588 #1=
7 ..123......OK 4.56OK .7OK 89OK .10OK .11OK .OK .OK .1213..14OK ..15OK .OK=
 16.OK 1718..OK .OK 19OK 20.21.OK .OK .2223.OK .OK .24OK 2526.OK 27.28OK .O=
K 29OK .3031.OK .32OK .OK 3334.OK .OK .3536.OK ..OK 37.OK 3839.4041OK ..OK =
42OK .4344OK .45OK .OK .4647..OK .OK 4849..OK .OK 50.OK 51OK .OK 52OK .53OK=
 .5455OK 56OK .57OK .5859.OK .OK 6061OK 62.63.....OK 6465OK .OK .OK 66OK .O=
K 6768.6970OK .OK .OK 7172OK 73.OK 747576.....OK .OK 7778OK ..OK 7980OK .OK=
 .OK 81.OK 8283OK . TEST FAILURE
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[b637a328bd4f43a0e146d1eef0142b650ba0d644] rcu: Print remote CPU's stacks i=
n stall warnings
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2012-12-24-04:06:30 b637a328bd4f43a0e146d1eef0142b650ba0d644 compiling
/home/wfg/linux

2012-12-24-04:07:23 detecting boot state 3.7.0-rc2-bisect-00001-gb637a32 #1=
8 1..2.3.4.....56OK 7OK 8OK .OK .910OK 1112OK 13OK ..1415.OK .16OK .17..OK =
=2E18OK .OK .1920OK .21OK ..OK 22OK .OK 23.24OK 25OK ..26..OK .27.OK ..28OK=
 .OK .2930OK .31.OK .32OK .33OK .OK ...OK 34OK ..3536OK .37.OK .38.OK ..OK =
39OK 40.41OK ..OK 42.43..OK .OK .44OK 45OK 46..4748OK 495051.OK .52OK .OK 5=
354..OK .55.....OK .OK ..56OK 57OK .OK 58OK .59 TEST FAILURE
b637a328bd4f43a0e146d1eef0142b650ba0d644 is the first bad commit
commit b637a328bd4f43a0e146d1eef0142b650ba0d644
Author: Paul E. McKenney <paul.mckenney@linaro.org>
Date:   Wed Sep 19 16:58:38 2012 -0700

    rcu: Print remote CPU's stacks in stall warnings
   =20
    The RCU CPU stall warnings rely on trigger_all_cpu_backtrace() to
    do NMI-based dump of the stack traces of all CPUs.  Unfortunately, a
    number of architectures do not implement trigger_all_cpu_backtrace(), in
    which case RCU falls back to just dumping the stack of the running CPU.
    This is unhelpful in the case where the running CPU has detected that
    some other CPU has stalled.
   =20
    This commit therefore makes the running CPU dump the stacks of the
    tasks running on the stalled CPUs.
   =20
    Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

:040000 040000 b0b009620cf76271983472be6eed321f7ddbc03b 0d9da215e57876e4567=
e40d9bc5948b786a5e327 M	include
:040000 040000 587f24096f9e09f14e00417146ce230d51f0975e 600cda207009454960f=
f97ad43e56612e2b29f9d M	kernel
bisect run success

=3D=3D=3D=3D=3D=3D=3D=3D=3D linux-next =3D=3D=3D=3D=3D=3D=3D=3D=3D

2012-12-24-04:10:30 0233d95bf1d83b10b0c031cb7c03997ccb34da12 compiling
/home/wfg/linux

2012-12-24-04:12:11 detecting boot state 3.7.0-bisect-next-20121221 #19 12.=
=2E3....456.OK .OK .78.OK .9.OK .10OK .11OK 12.1314..OK .15.OK .OK 16OK ..1=
7..OK ..OK 18.OK .192021..OK .22OK .23.OK .24OK .OK ..25.OK .OK ..OK 26OK 2=
7OK ................................................OK .28..29....... TEST =
FAILURE
ERROR# 1: /c/kernel-tests/bisect:25: main: $BISECT_TEST $KBUILD_OUTPUT

--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.7.0 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
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
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
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
# CONFIG_KERNEL_GZIP is not set
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
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
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_RCU_FAST_NO_HZ is not set
CONFIG_TREE_RCU_TRACE=y
# CONFIG_RCU_BOOST is not set
CONFIG_RCU_NOCB_CPU=y
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
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
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_HAVE_UID16=y
# CONFIG_UID16 is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
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
# CONFIG_SLUB_DEBUG is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
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
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_GENERIC_KERNEL_THREAD=y
CONFIG_GENERIC_KERNEL_EXECVE=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_BIGSMP is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_WANT_INTEL_MID is not set
# CONFIG_X86_RDC321X is not set
CONFIG_X86_32_NON_STANDARD=y
# CONFIG_X86_NUMAQ is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_STA2X11 is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_LGUEST_GUEST is not set
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
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
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_CYRIX_32 is not set
CONFIG_CPU_SUP_AMD=y
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_ANCIENT_MCE=y
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_VM86 is not set
CONFIG_TOSHIBA=y
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
CONFIG_VMSPLIT_2G=y
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x80000000
CONFIG_HIGHMEM=y
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
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_CLEANCACHE=y
# CONFIG_HIGHPTE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
CONFIG_DEBUG_HOTPLUG_CPU0=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
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
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_I2C=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
CONFIG_APM_IGNORE_USER_SUSPEND=y
CONFIG_APM_DO_ENABLE=y
# CONFIG_APM_CPU_IDLE is not set
# CONFIG_APM_DISPLAY_BLANK is not set
# CONFIG_APM_ALLOW_INTS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K6=y
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_POWERNOW_K7_ACPI=y
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
# CONFIG_X86_SPEEDSTEP_SMI is not set
CONFIG_X86_P4_CLOCKMOD=y
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
CONFIG_X86_LONGRUN=y
# CONFIG_X86_LONGHAUL is not set
CONFIG_X86_E_POWERSAVER=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

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
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
CONFIG_SCx200=y
# CONFIG_SCx200HR_TIMER is not set
CONFIG_OLPC=y
# CONFIG_OLPC_XO15_SCI is not set
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_I82365 is not set
CONFIG_TCIC=y
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
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
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=16
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
CONFIG_CMA_AREAS=7

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_OF_PARTS=y
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_CHAR=y
CONFIG_HAVE_MTD_OTP=y
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
# CONFIG_MTD_JEDECPROBE is not set
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
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_PHYSMAP is not set
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=y
# CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
CONFIG_MTD_DATAFLASH_OTP=y
# CONFIG_MTD_M25P80 is not set
# CONFIG_MTD_SST25L is not set
CONFIG_MTD_SLRAM=y
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOC2000 is not set
# CONFIG_MTD_DOC2001 is not set
# CONFIG_MTD_DOC2001PLUS is not set
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_BCH=y
CONFIG_MTD_NAND_ECC_BCH=y
# CONFIG_MTD_SM_COMMON is not set
# CONFIG_MTD_NAND_MUSEUM_IDS is not set
# CONFIG_MTD_NAND_DENALI is not set
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
# CONFIG_MTD_NAND_DISKONCHIP is not set
# CONFIG_MTD_NAND_DOCG4 is not set
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_CS553X=y
CONFIG_MTD_NAND_NANDSIM=y
# CONFIG_MTD_NAND_PLATFORM is not set
# CONFIG_MTD_ALAUDA is not set
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
CONFIG_MTD_ONENAND_GENERIC=y
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y
CONFIG_MTD_ONENAND_SIM=y

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
# CONFIG_MTD_UBI is not set
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
CONFIG_PROC_DEVICETREE=y
# CONFIG_OF_SELFTEST is not set
CONFIG_OF_PROMTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_DEVICE=y
CONFIG_OF_I2C=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
CONFIG_OF_MTD=y
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_PC_PCMCIA is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_ISAPNP=y
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
# CONFIG_AD525X_DPOT is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
CONFIG_DS1682=y
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_BMP085_SPI is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
CONFIG_EEPROM_93XX46=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_GTCO is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=y
# CONFIG_CYZ_INTR is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
# CONFIG_N_HDLC is not set
# CONFIG_N_GSM is not set
CONFIG_TRACE_ROUTER=y
CONFIG_TRACE_SINK=y
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
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=y
CONFIG_SERIAL_MAX310X=y
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_OF_PLATFORM is not set
CONFIG_SERIAL_SCCNXP=y
CONFIG_SERIAL_SCCNXP_CONSOLE=y
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_XILINX_PS_UART=y
# CONFIG_SERIAL_XILINX_PS_UART_CONSOLE is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
# CONFIG_DTLK is not set
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
CONFIG_CARDMAN_4000=y
# CONFIG_CARDMAN_4040 is not set
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=y

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
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_ISA=y
# CONFIG_SCx200_I2C is not set
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_DEBUG_CORE=y
CONFIG_I2C_DEBUG_ALGO=y
CONFIG_I2C_DEBUG_BUS=y
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_BUTTERFLY is not set
CONFIG_SPI_GPIO=y
CONFIG_SPI_LM70_LLP=y
CONFIG_SPI_OC_TINY=y
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_XCOMM=y
CONFIG_SPI_XILINX=y
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=y

#
# PPS support
#
CONFIG_PPS=y
CONFIG_PPS_DEBUG=y

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_PARPORT=y
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9055 is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
CONFIG_GPIO_MAX7300=y
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_RC5T583 is not set
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_STMPE=y
CONFIG_GPIO_TPS65912=y
# CONFIG_GPIO_WM831X is not set
# CONFIG_GPIO_WM8350 is not set
CONFIG_GPIO_WM8994=y
# CONFIG_GPIO_ADP5588 is not set
# CONFIG_GPIO_ADNP is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_SODAVILLE is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
CONFIG_GPIO_MCP23S08=y
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_74X164 is not set

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_TPS6586X=y
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
# CONFIG_WM8350_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_OLPC is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9030 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_AD7314 is not set
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
# CONFIG_SENSORS_DA9055 is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4151=y
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=y
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_WM8350=y
CONFIG_SENSORS_APPLESMC=y
# CONFIG_SENSORS_MC13783_ADC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
CONFIG_FAIR_SHARE=y
# CONFIG_STEP_WISE is not set
CONFIG_USER_SPACE=y
CONFIG_CPU_THERMAL=y
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
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
# CONFIG_MFD_LM3533 is not set
# CONFIG_TPS6105X is not set
CONFIG_TPS65010=y
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
# CONFIG_STMPE_SPI is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_SMSC=y
CONFIG_PMIC_DA903X=y
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_LP8788=y
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM5102 is not set
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_ABX500_CORE is not set
CONFIG_EZX_PCAP=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_LPC_SCH is not set
# CONFIG_LPC_ICH is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_TPS65090=y
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_PALMAS=y
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_TUNER=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_VMALLOC=y
CONFIG_VIDEOBUF_DVB=y
CONFIG_DVB_CORE=y
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y

#
# Media drivers
#
CONFIG_MEDIA_USB_SUPPORT=y

#
# Analog/digital TV USB devices
#

#
# Digital TV USB devices
#
# CONFIG_DVB_TTUSB_BUDGET is not set
# CONFIG_DVB_TTUSB_DEC is not set
# CONFIG_SMS_USB_DRV is not set
CONFIG_DVB_B2C2_FLEXCOP_USB=y
# CONFIG_DVB_B2C2_FLEXCOP_USB_DEBUG is not set

#
# Webcam, TV (analog/digital) USB devices
#
CONFIG_VIDEO_EM28XX=y
CONFIG_VIDEO_EM28XX_DVB=y
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_SMS_SDIO_DRV=y
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_SI470X is not set
CONFIG_USB_MR800=y
# CONFIG_USB_DSBR is not set
# CONFIG_RADIO_SHARK2 is not set
# CONFIG_I2C_SI4713 is not set
# CONFIG_RADIO_SI4713 is not set
# CONFIG_USB_KEENE is not set
CONFIG_RADIO_TEA5764=y
# CONFIG_RADIO_TEA5764_XTAL is not set
CONFIG_RADIO_SAA7706H=y
# CONFIG_RADIO_TEF6862 is not set
# CONFIG_RADIO_WL1273 is not set

#
# Texas Instruments WL128x FM driver (ST based)
#
# CONFIG_V4L_RADIO_ISA_DRIVERS is not set
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_DVB_B2C2_FLEXCOP=y
CONFIG_SMS_SIANO_MDTV=y
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_VIDEO_TVEEPROM=y

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_TVAUDIO is not set
CONFIG_VIDEO_TDA7432=y
CONFIG_VIDEO_TDA9840=y
# CONFIG_VIDEO_TEA6415C is not set
# CONFIG_VIDEO_TEA6420 is not set
# CONFIG_VIDEO_MSP3400 is not set
CONFIG_VIDEO_CS5345=y
# CONFIG_VIDEO_CS53L32A is not set
# CONFIG_VIDEO_TLV320AIC23B is not set
# CONFIG_VIDEO_WM8775 is not set
# CONFIG_VIDEO_WM8739 is not set
CONFIG_VIDEO_VP27SMPX=y

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=y

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=y
# CONFIG_VIDEO_ADV7183 is not set
# CONFIG_VIDEO_BT819 is not set
CONFIG_VIDEO_BT856=y
CONFIG_VIDEO_BT866=y
# CONFIG_VIDEO_KS0127 is not set
CONFIG_VIDEO_SAA7110=y
# CONFIG_VIDEO_SAA711X is not set
CONFIG_VIDEO_SAA7191=y
# CONFIG_VIDEO_TVP514X is not set
CONFIG_VIDEO_TVP5150=y
# CONFIG_VIDEO_TVP7002 is not set
CONFIG_VIDEO_VPX3220=y

#
# Video and audio decoders
#
# CONFIG_VIDEO_SAA717X is not set
CONFIG_VIDEO_CX25840=y

#
# MPEG video encoders
#
CONFIG_VIDEO_CX2341X=y

#
# Video encoders
#
# CONFIG_VIDEO_SAA7127 is not set
CONFIG_VIDEO_SAA7185=y
CONFIG_VIDEO_ADV7170=y
# CONFIG_VIDEO_ADV7175 is not set
# CONFIG_VIDEO_ADV7343 is not set
# CONFIG_VIDEO_ADV7393 is not set
CONFIG_VIDEO_AK881X=y

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=y
# CONFIG_VIDEO_UPD64083 is not set

#
# Miscelaneous helper chips
#
CONFIG_VIDEO_THS7303=y
# CONFIG_VIDEO_M52790 is not set

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y

#
# Customize TV tuners
#
# CONFIG_MEDIA_TUNER_SIMPLE is not set
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
# CONFIG_MEDIA_TUNER_TEA5761 is not set
# CONFIG_MEDIA_TUNER_TEA5767 is not set
CONFIG_MEDIA_TUNER_MT20XX=y
# CONFIG_MEDIA_TUNER_MT2060 is not set
# CONFIG_MEDIA_TUNER_MT2063 is not set
CONFIG_MEDIA_TUNER_MT2266=y
# CONFIG_MEDIA_TUNER_MT2131 is not set
CONFIG_MEDIA_TUNER_QT1010=y
CONFIG_MEDIA_TUNER_XC2028=y
# CONFIG_MEDIA_TUNER_XC5000 is not set
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MXL5005S=y
# CONFIG_MEDIA_TUNER_MXL5007T is not set
CONFIG_MEDIA_TUNER_MC44S803=y
# CONFIG_MEDIA_TUNER_MAX2165 is not set
# CONFIG_MEDIA_TUNER_TDA18218 is not set
CONFIG_MEDIA_TUNER_FC0011=y
CONFIG_MEDIA_TUNER_FC0012=y
CONFIG_MEDIA_TUNER_FC0013=y
# CONFIG_MEDIA_TUNER_TDA18212 is not set
CONFIG_MEDIA_TUNER_E4000=y
# CONFIG_MEDIA_TUNER_FC2580 is not set
# CONFIG_MEDIA_TUNER_TUA9001 is not set

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
# CONFIG_DVB_STB0899 is not set
# CONFIG_DVB_STB6100 is not set
# CONFIG_DVB_STV090x is not set
CONFIG_DVB_STV6110x=y

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=y
# CONFIG_DVB_TDA18271C2DD is not set

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=y
# CONFIG_DVB_CX24123 is not set
CONFIG_DVB_MT312=y
# CONFIG_DVB_ZL10036 is not set
CONFIG_DVB_ZL10039=y
# CONFIG_DVB_S5H1420 is not set
CONFIG_DVB_STV0288=y
# CONFIG_DVB_STB6000 is not set
# CONFIG_DVB_STV0299 is not set
CONFIG_DVB_STV6110=y
CONFIG_DVB_STV0900=y
# CONFIG_DVB_TDA8083 is not set
CONFIG_DVB_TDA10086=y
CONFIG_DVB_TDA8261=y
CONFIG_DVB_VES1X93=y
# CONFIG_DVB_TUNER_ITD1000 is not set
CONFIG_DVB_TUNER_CX24113=y
CONFIG_DVB_TDA826X=y
CONFIG_DVB_TUA6100=y
CONFIG_DVB_CX24116=y
# CONFIG_DVB_SI21XX is not set
CONFIG_DVB_DS3000=y
# CONFIG_DVB_MB86A16 is not set
CONFIG_DVB_TDA10071=y

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=y
# CONFIG_DVB_SP887X is not set
# CONFIG_DVB_CX22700 is not set
# CONFIG_DVB_CX22702 is not set
# CONFIG_DVB_S5H1432 is not set
# CONFIG_DVB_DRXD is not set
# CONFIG_DVB_L64781 is not set
CONFIG_DVB_TDA1004X=y
# CONFIG_DVB_NXT6000 is not set
# CONFIG_DVB_MT352 is not set
# CONFIG_DVB_ZL10353 is not set
CONFIG_DVB_DIB3000MB=y
# CONFIG_DVB_DIB3000MC is not set
CONFIG_DVB_DIB7000M=y
# CONFIG_DVB_DIB7000P is not set
CONFIG_DVB_DIB9000=y
CONFIG_DVB_TDA10048=y
# CONFIG_DVB_AF9013 is not set
CONFIG_DVB_EC100=y
# CONFIG_DVB_HD29L2 is not set
# CONFIG_DVB_STV0367 is not set
# CONFIG_DVB_CXD2820R is not set
CONFIG_DVB_RTL2830=y
# CONFIG_DVB_RTL2832 is not set

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=y
CONFIG_DVB_TDA10021=y
CONFIG_DVB_TDA10023=y
CONFIG_DVB_STV0297=y

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
# CONFIG_DVB_NXT200X is not set
# CONFIG_DVB_OR51211 is not set
# CONFIG_DVB_OR51132 is not set
CONFIG_DVB_BCM3510=y
CONFIG_DVB_LGDT330X=y
CONFIG_DVB_LGDT3305=y
CONFIG_DVB_LG2160=y
CONFIG_DVB_S5H1409=y
# CONFIG_DVB_AU8522_DTV is not set
# CONFIG_DVB_AU8522_V4L is not set
# CONFIG_DVB_S5H1411 is not set

#
# ISDB-T (terrestrial) frontends
#
# CONFIG_DVB_S921 is not set
# CONFIG_DVB_DIB8000 is not set
# CONFIG_DVB_MB86A20S is not set

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=y
# CONFIG_DVB_TUNER_DIB0070 is not set
# CONFIG_DVB_TUNER_DIB0090 is not set

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=y
CONFIG_DVB_LNBP22=y
CONFIG_DVB_ISL6405=y
CONFIG_DVB_ISL6421=y
CONFIG_DVB_ISL6423=y
CONFIG_DVB_A8293=y
CONFIG_DVB_LGS8GL5=y
CONFIG_DVB_LGS8GXX=y
CONFIG_DVB_ATBM8830=y
# CONFIG_DVB_TDA665x is not set
CONFIG_DVB_IX2505V=y
# CONFIG_DVB_IT913X_FE is not set
# CONFIG_DVB_M88RS2000 is not set
# CONFIG_DVB_AF9033 is not set

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_USB=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=y
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
CONFIG_FB_SYS_FOPS=y
# CONFIG_FB_WMT_GE_ROPS is not set
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
CONFIG_FB_S1D13XXX=y
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
# CONFIG_FB_SM501 is not set
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=y
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_L4F00242T03=y
CONFIG_LCD_LMS283GF05=y
# CONFIG_LCD_LTV350QV is not set
CONFIG_LCD_ILI9320=y
# CONFIG_LCD_TDO24M is not set
CONFIG_LCD_VGG2432A4=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_LCD_S6E63M0=y
CONFIG_LCD_LD9040=y
CONFIG_LCD_AMS369FG06=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_PWM is not set
# CONFIG_BACKLIGHT_DA903X is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP8860=y
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_LM3630=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_TPS65217=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
# CONFIG_LOGO_LINUX_CLUT224 is not set
CONFIG_FB_SSD1307=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
# CONFIG_SND is not set
CONFIG_SOUND_PRIME=y
# CONFIG_SOUND_MSNDCLAS is not set
# CONFIG_SOUND_MSNDPIN is not set
CONFIG_SOUND_OSS=y
# CONFIG_SOUND_TRACEINIT is not set
# CONFIG_SOUND_DMAP is not set
# CONFIG_SOUND_VMIDI is not set
CONFIG_SOUND_TRIX=y
# CONFIG_TRIX_HAVE_BOOT is not set
# CONFIG_SOUND_MSS is not set
# CONFIG_SOUND_MPU401 is not set
# CONFIG_SOUND_PAS is not set
# CONFIG_SOUND_PSS is not set
CONFIG_SOUND_SB=y
# CONFIG_SOUND_YM3812 is not set
# CONFIG_SOUND_UART6850 is not set
CONFIG_SOUND_AEDSP16=y
# CONFIG_SC6600 is not set
CONFIG_SOUND_KAHLUA=y

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

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB_CBAF=y
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
# CONFIG_USB_XHCI_HCD is not set
# CONFIG_USB_EHCI_HCD is not set
CONFIG_USB_OXU210HP_HCD=y
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_ISP1362_HCD=y
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_HCD_SSB=y
# CONFIG_USB_CHIPIDEA is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=y
# CONFIG_USB_SERIAL_CONSOLE is not set
# CONFIG_USB_SERIAL_GENERIC is not set
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
CONFIG_USB_SERIAL_BELKIN=y
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
CONFIG_USB_SERIAL_FTDI_SIO=y
CONFIG_USB_SERIAL_FUNSOFT=y
CONFIG_USB_SERIAL_VISOR=y
CONFIG_USB_SERIAL_IPAQ=y
# CONFIG_USB_SERIAL_IR is not set
CONFIG_USB_SERIAL_EDGEPORT=y
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
CONFIG_USB_SERIAL_F81232=y
CONFIG_USB_SERIAL_GARMIN=y
# CONFIG_USB_SERIAL_IPW is not set
CONFIG_USB_SERIAL_IUU=y
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
# CONFIG_USB_SERIAL_KEYSPAN is not set
CONFIG_USB_SERIAL_KLSI=y
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
CONFIG_USB_SERIAL_METRO=y
# CONFIG_USB_SERIAL_MOS7720 is not set
CONFIG_USB_SERIAL_MOS7840=y
# CONFIG_USB_SERIAL_MOTOROLA is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
CONFIG_USB_SERIAL_OTI6858=y
CONFIG_USB_SERIAL_QCAUX=y
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_HP4X is not set
CONFIG_USB_SERIAL_SAFE=y
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIEMENS_MPI=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=y
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
CONFIG_USB_SERIAL_XIRCOM=y
# CONFIG_USB_SERIAL_OPTION is not set
CONFIG_USB_SERIAL_OMNINET=y
CONFIG_USB_SERIAL_OPTICON=y
CONFIG_USB_SERIAL_VIVOPAY_SERIAL=y
# CONFIG_USB_SERIAL_ZIO is not set
CONFIG_USB_SERIAL_ZTE=y
# CONFIG_USB_SERIAL_SSU100 is not set
CONFIG_USB_SERIAL_QT2=y
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
CONFIG_USB_EMI26=y
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
CONFIG_USB_APPLEDISPLAY=y
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
CONFIG_USB_ISIGHTFW=y
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=y

#
# USB Physical Layer drivers
#
CONFIG_USB_ISP1301=y
CONFIG_USB_RCAR_PHY=y
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=y
CONFIG_NOP_USB_XCEIV=y
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_VUB300=y
# CONFIG_MMC_USHC is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_NET48XX=y
# CONFIG_LEDS_WRAP is not set
CONFIG_LEDS_PCA9532=y
CONFIG_LEDS_PCA9532_GPIO=y
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP8788=y
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA9633=y
# CONFIG_LEDS_WM831X_STATUS is not set
# CONFIG_LEDS_WM8350 is not set
# CONFIG_LEDS_DA903X is not set
# CONFIG_LEDS_DAC124S085 is not set
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_LT3593 is not set
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_LM355x is not set
CONFIG_LEDS_OT200=y
# CONFIG_LEDS_BLINKM is not set
# CONFIG_LEDS_TRIGGERS is not set

#
# LED Triggers
#
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_PROC is not set
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1672=y
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_MAX8907 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_ISL12022=y
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF8583=y
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_RC5T583 is not set
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y
# CONFIG_RTC_DRV_EM3027 is not set
CONFIG_RTC_DRV_RV3029C2=y

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
CONFIG_RTC_DRV_M41T94=y
CONFIG_RTC_DRV_DS1305=y
CONFIG_RTC_DRV_DS1390=y
CONFIG_RTC_DRV_MAX6902=y
CONFIG_RTC_DRV_R9701=y
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_DS3234 is not set
CONFIG_RTC_DRV_PCF2123=y

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=y
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
# CONFIG_RTC_DRV_V3020 is not set
CONFIG_RTC_DRV_DS2404=y
# CONFIG_RTC_DRV_WM831X is not set
CONFIG_RTC_DRV_WM8350=y

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_PCAP=y
# CONFIG_RTC_DRV_MC13XXX is not set
# CONFIG_RTC_DRV_SNVS is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
# CONFIG_DMADEVICES_VDEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=y
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=y
CONFIG_CFAG12864B_RATE=20
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV=y
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_USBIP_CORE is not set
# CONFIG_ECHO is not set
CONFIG_FB_OLPC_DCON=y
CONFIG_FB_OLPC_DCON_1_5=y
# CONFIG_ASUS_OLED is not set
CONFIG_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
# CONFIG_PANEL_CHANGE_MESSAGE is not set
CONFIG_TRANZPORT=y
# CONFIG_USB_SERIAL_QUATECH2 is not set
# CONFIG_DX_SEP is not set
# CONFIG_ZSMALLOC is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_BCM_WIMAX is not set
CONFIG_FT1000=y
# CONFIG_FT1000_USB is not set
# CONFIG_FT1000_PCMCIA is not set

#
# Speakup console speech
#
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
CONFIG_STAGING_MEDIA=y
CONFIG_DVB_AS102=y
# CONFIG_DVB_CXD2099 is not set
# CONFIG_VIDEO_DT3155 is not set

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
# CONFIG_ASHMEM is not set
# CONFIG_ANDROID_LOGGER is not set
CONFIG_ANDROID_TIMED_OUTPUT=y
CONFIG_ANDROID_TIMED_GPIO=y
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
CONFIG_ANDROID_INTF_ALARM_DEV=y
# CONFIG_USB_WPAN_HCD is not set
# CONFIG_WIMAX_GDM72XX is not set
CONFIG_NET_VENDOR_SILICOM=y
CONFIG_CED1401=y
CONFIG_DGRP=y
# CONFIG_SB105X is not set
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
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers (EXPERIMENTAL)
#
CONFIG_VIRT_DRIVERS=y
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
# CONFIG_FSNOTIFY is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=y
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=y
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_PREEMPT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
CONFIG_PROVE_RCU_DELAY=y
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_HIGHMEM=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_LIST is not set
CONFIG_TEST_LIST_SORT=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_RCU_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST_RUNNABLE=y
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
# CONFIG_RCU_CPU_STALL_INFO is not set
CONFIG_RCU_TRACE=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MMC_REQUEST=y
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
CONFIG_TEST_KSTRTOX=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
CONFIG_DOUBLEFAULT=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
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
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
# CONFIG_CRYPTO_CBC is not set
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
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
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
# CONFIG_CRYPTO_MD5 is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
# CONFIG_CRYPTO_SHA1 is not set
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_CAMELLIA=y
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_ZLIB=y
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
# CONFIG_VHOST_NET is not set
CONFIG_LGUEST=y
# CONFIG_BINARY_PRINTF is not set

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
# CONFIG_CRC16 is not set
# CONFIG_CRC_T10DIF is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_BCH=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CORDIC=y
# CONFIG_DDR is not set
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_ATA_SFF is not set
# CONFIG_DRM_TTM is not set
# CONFIG_ISDN_DRV_LOOP is not set
# CONFIG_PCI_ATS is not set

--MGYHOYXEY6WxJCY8--
