Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab0E3CqU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 22:46:20 -0400
Received: from troy.hostgo.com ([64.62.143.130]:59562 "EHLO troy.hostgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130Ab0E3CqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 22:46:16 -0400
From: Thomas Fjellstrom <tfjellstrom@strangesoft.net>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: via 8237 sata errors
Date: Sat, 29 May 2010 20:46:05 -0600
User-Agent: KMail/1.13.3 (Linux/2.6.33-2-amd64; KDE/4.4.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005292046.06344.tfjellstrom@strangesoft.net>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - troy.hostgo.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - strangesoft.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting a rather nasty set of messages from dmesg when trying to use
a couple SATA II WD 2TB Green drives with an older system (via 8237 based).
They seem to work fine on a newer p35 based system.

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.32-5-686 (Debian 2.6.32-13) (maks@debian.org) (gcc version 4.3.4 (Debian 4.3.4-10) ) #1 SMP Wed May 19 19:51:54 UTC 2010
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
[    0.000000]  BIOS-e820: 000000007fff0000 - 000000007fff8000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007fff8000 - 0000000080000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.3 present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x7fff0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 base 0E0000000 mask FF8000000 write-combining
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped : 0 - 01800000
[    0.000000] init_memory_mapping: 0000000000000000-00000000373fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037000000 page 2M
[    0.000000]  0037000000 - 00373fe000 page 4k
[    0.000000] kernel direct mapping tables up to 373fe000 @ 10000-16000
[    0.000000] RAMDISK: 377b7000 - 37fef725
[    0.000000] Allocated new RAMDISK: 00100000 - 00938725
[    0.000000] Move RAMDISK from 00000000377b7000 - 0000000037fef724 to 00100000 - 00938724
[    0.000000] ACPI: RSDP 000fa9f0 00014 (v00 AMI   )
[    0.000000] ACPI: RSDT 7fff0000 0002C (v01 AMIINT VIA_K7   00000010 MSFT 00000097)
[    0.000000] ACPI: FACP 7fff0030 00081 (v01 AMIINT VIA_K7   00000011 MSFT 00000097)
[    0.000000] ACPI: DSDT 7fff0120 03718 (v01    VIA   VIA_K7 00001000 MSFT 0100000D)
[    0.000000] ACPI: FACS 7fff8000 00040
[    0.000000] ACPI: APIC 7fff00c0 00054 (v01 AMIINT VIA_K7   00000009 MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1163MB HIGHMEM available.
[    0.000000] 883MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 373fe000
[    0.000000]   low ram: 0 - 373fe000
[    0.000000]   node 0 low ram: 00000000 - 373fe000
[    0.000000]   node 0 bootmap 00012000 - 00018e80
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00373fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0001000000 - 00014c4154]    TEXT DATA BSS ==> [0001000000 - 00014c4154]
[    0.000000]   #4 [000009d800 - 0000100000]    BIOS reserved ==> [000009d800 - 0000100000]
[    0.000000]   #5 [00014c5000 - 00014cb108]              BRK ==> [00014c5000 - 00014cb108]
[    0.000000]   #6 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
[    0.000000]   #7 [0000100000 - 0000938725]      NEW RAMDISK ==> [0000100000 - 0000938725]
[    0.000000]   #8 [0000012000 - 0000019000]          BOOTMAP ==> [0000012000 - 0000019000]
[    0.000000] found SMP MP-table at [c00fb990] fb990
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000373fe
[    0.000000]   HighMem  0x000373fe -> 0x0007fff0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007fff0
[    0.000000] On node 0 totalpages: 524159
[    0.000000] free_area_init_node: node 0, pgdat c13ae680, node_mem_map c14cd200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1736 pages used for memmap
[    0.000000]   Normal zone: 220470 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2328 pages used for memmap
[    0.000000]   HighMem zone: 295642 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 3, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:7ec00000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Embedded 14 pages/cpu @c2800000 s34136 r0 d23208 u4194304
[    0.000000] pcpu-alloc: s34136 r0 d23208 u4194304 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 520063
[    0.000000] Kernel command line: root=UUID=956b3463-56e8-4aa3-8eca-b7f5e9ef90b3 ro quiet
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000373fe:0007fff0)
[    0.000000] Memory: 2065056k/2097088k available (2490k kernel code, 30644k reserved, 1317k data, 376k init, 1191880k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd56000 - 0xfffff000   (2724 kB)
[    0.000000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.000000]     vmalloc : 0xf7bfe000 - 0xff3fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf73fe000   ( 883 MB)
[    0.000000]       .init : 0xc13b9000 - 0xc1417000   ( 376 kB)
[    0.000000]       .data : 0xc126ebad - 0xc13b81e0   (1317 kB)
[    0.000000]       .text : 0xc1000000 - 0xc126ebad   (2490 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:1280
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1670.720 MHz processor.
[    0.004006] Calibrating delay loop (skipped), value calculated using timer frequency.. 3341.44 BogoMIPS (lpj=6682880)
[    0.004038] Security Framework initialized
[    0.004050] SELinux:  Disabled at boot.
[    0.004061] Mount-cache hash table entries: 512
[    0.004267] Initializing cgroup subsys ns
[    0.004273] Initializing cgroup subsys cpuacct
[    0.004279] Initializing cgroup subsys devices
[    0.004283] Initializing cgroup subsys freezer
[    0.004287] Initializing cgroup subsys net_cls
[    0.004321] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004326] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004332] mce: CPU supports 4 MCE banks
[    0.004361] Performance Events: AMD PMU driver.
[    0.004371] ... version:                0
[    0.004374] ... bit width:              48
[    0.004376] ... generic registers:      4
[    0.004379] ... value mask:             0000ffffffffffff
[    0.004382] ... max period:             00007fffffffffff
[    0.004385] ... fixed-purpose events:   0
[    0.004388] ... event mask:             000000000000000f
[    0.004393] Checking 'hlt' instruction... OK.
[    0.020374] SMP alternatives: switching to UP code
[    0.024698] Freeing SMP alternatives: 13k freed
[    0.024716] ACPI: Core revision 20090903
[    0.032481] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.033679] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.073374] CPU0: AMD Athlon(tm) XP 2200+ stepping 00
[    0.076001] Brought up 1 CPUs
[    0.076001] Total of 1 processors activated (3341.44 BogoMIPS).
[    0.076001] CPU0 attaching NULL sched-domain.
[    0.076001] devtmpfs: initialized
[    0.076001] regulator: core version 0.5
[    0.076001] NET: Registered protocol family 16
[    0.076001] ACPI: bus type pci registered
[    0.076001] PCI: PCI BIOS revision 2.10 entry at 0xfdb11, last bus=1
[    0.076001] PCI: Using configuration type 1 for base access
[    0.076001] bio: create slab <bio-0> at 0
[    0.076001] ACPI: EC: Look up EC in DSDT
[    0.082130] ACPI: Interpreter enabled
[    0.082140] ACPI: (supports S0 S1 S4 S5)
[    0.082165] ACPI: Using IOAPIC for interrupt routing
[    0.086148] ACPI: Power Resource [URP1] (off)
[    0.086186] ACPI: Power Resource [URP2] (off)
[    0.086222] ACPI: Power Resource [FDDP] (off)
[    0.086258] ACPI: Power Resource [LPTP] (off)
[    0.086414] ACPI: No dock devices found.
[    0.086567] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.086627] pci 0000:00:00.0: reg 10 32bit mmio pref: [0xe0000000-0xe7ffffff]
[    0.086718] pci 0000:00:01.0: supports D1
[    0.086759] pci 0000:00:05.0: reg 10 32bit mmio: [0xdffec000-0xdffeffff]
[    0.086767] pci 0000:00:05.0: reg 14 io port: [0xec00-0xecff]
[    0.086789] pci 0000:00:05.0: reg 30 32bit mmio pref: [0xdffc0000-0xdffdffff]
[    0.086810] pci 0000:00:05.0: supports D1 D2
[    0.086814] pci 0000:00:05.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.086819] pci 0000:00:05.0: PME# disabled
[    0.086862] pci 0000:00:08.0: reg 10 32bit mmio pref: [0xdfdf0000-0xdfdfffff]
[    0.086897] pci 0000:00:08.0: reg 30 32bit mmio pref: [0xdfff0000-0xdfff7fff]
[    0.086956] pci 0000:00:0f.0: reg 10 io port: [0xe800-0xe807]
[    0.086964] pci 0000:00:0f.0: reg 14 io port: [0xe400-0xe403]
[    0.086971] pci 0000:00:0f.0: reg 18 io port: [0xe000-0xe007]
[    0.086979] pci 0000:00:0f.0: reg 1c io port: [0xdc00-0xdc03]
[    0.086986] pci 0000:00:0f.0: reg 20 io port: [0xd800-0xd80f]
[    0.086994] pci 0000:00:0f.0: reg 24 io port: [0xd400-0xd4ff]
[    0.087062] pci 0000:00:0f.1: reg 20 io port: [0xfc00-0xfc0f]
[    0.087141] pci 0000:00:10.0: reg 20 io port: [0xd000-0xd01f]
[    0.087165] pci 0000:00:10.0: supports D1 D2
[    0.087168] pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.087173] pci 0000:00:10.0: PME# disabled
[    0.087208] pci 0000:00:10.4: reg 10 32bit mmio: [0xdffe7e00-0xdffe7eff]
[    0.087247] pci 0000:00:10.4: supports D1 D2
[    0.087250] pci 0000:00:10.4: PME# supported from D0 D1 D2 D3hot D3cold
[    0.087255] pci 0000:00:10.4: PME# disabled
[    0.087314] HPET not enabled in BIOS. You might try hpet=force boot option
[    0.087391] pci 0000:01:00.0: reg 10 32bit mmio pref: [0xd0000000-0xd7ffffff]
[    0.087399] pci 0000:01:00.0: reg 14 io port: [0xb800-0xb8ff]
[    0.087405] pci 0000:01:00.0: reg 18 32bit mmio: [0xdfef0000-0xdfefffff]
[    0.087421] pci 0000:01:00.0: reg 30 32bit mmio pref: [0xdfec0000-0xdfedffff]
[    0.087440] pci 0000:01:00.0: supports D1 D2
[    0.087469] pci 0000:01:00.1: reg 10 32bit mmio pref: [0xc8000000-0xcfffffff]
[    0.087476] pci 0000:01:00.1: reg 14 32bit mmio: [0xdfee0000-0xdfeeffff]
[    0.087505] pci 0000:01:00.1: supports D1 D2
[    0.087548] pci 0000:00:01.0: bridge io port: [0xb000-0xbfff]
[    0.087553] pci 0000:00:01.0: bridge 32bit mmio: [0xdfe00000-0xdfefffff]
[    0.087559] pci 0000:00:01.0: bridge 32bit mmio pref: [0xbfd00000-0xdfcfffff]
[    0.087567] pci_bus 0000:00: on NUMA node 0
[    0.087574] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.089796] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.089919] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.090040] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.090159] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 *12 14 15)
[    0.090278] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.090397] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.090516] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.090635] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.090764] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.090769] vgaarb: loaded
[    0.090856] PCI: Using ACPI for IRQ routing
[    0.091048] Switching to clocksource tsc
[    0.091997] pnp: PnP ACPI init
[    0.091997] ACPI: bus type pnp registered
[    0.091997] pnp: PnP ACPI: found 8 devices
[    0.091997] ACPI: ACPI bus type pnp unregistered
[    0.091999] PnPBIOS: Disabled by ACPI PNP
[    0.092017] system 00:01: ioport range 0x290-0x297 has been reserved
[    0.092022] system 00:01: ioport range 0x3f0-0x3f1 has been reserved
[    0.092027] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.092032] system 00:01: ioport range 0x400-0x40f has been reserved
[    0.092037] system 00:01: ioport range 0x820-0x821 has been reserved
[    0.092043] system 00:01: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.126867] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.126873] pci 0000:00:01.0:   IO window: 0xb000-0xbfff
[    0.126880] pci 0000:00:01.0:   MEM window: 0xdfe00000-0xdfefffff
[    0.126885] pci 0000:00:01.0:   PREFETCH window: 0xbfd00000-0xdfcfffff
[    0.126904] pci 0000:00:01.0: setting latency timer to 64
[    0.126911] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.126915] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.126919] pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
[    0.126923] pci_bus 0000:01: resource 1 mem: [0xdfe00000-0xdfefffff]
[    0.126927] pci_bus 0000:01: resource 2 pref mem [0xbfd00000-0xdfcfffff]
[    0.126979] NET: Registered protocol family 2
[    0.127115] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.127757] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.129780] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.130921] TCP: Hash tables configured (established 131072 bind 65536)
[    0.130925] TCP reno registered
[    0.131083] NET: Registered protocol family 1
[    0.131111] pci 0000:00:01.0: disabling DAC on VIA PCI bridge
[    0.131178] pci 0000:00:11.0: Bypassing VIA 8237 APIC De-Assert Message
[    0.131187] pci 0000:01:00.0: Boot video device
[    0.131273] Unpacking initramfs...
[    0.430896] Freeing initrd memory: 8417k freed
[    0.445263] audit: initializing netlink socket (disabled)
[    0.445287] type=2000 audit(1275186513.444:1): initialized
[    0.445620] highmem bounce pool size: 64 pages
[    0.445629] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.447660] VFS: Disk quotas dquot_6.5.2
[    0.447744] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.447862] msgmni has been set to 1723
[    0.448150] alg: No test for stdrng (krng)
[    0.448189] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.448194] io scheduler noop registered
[    0.448197] io scheduler anticipatory registered
[    0.448200] io scheduler deadline registered
[    0.448246] io scheduler cfq registered (default)
[    0.448462] isapnp: Scanning for PnP cards...
[    0.801848] isapnp: No Plug & Play device found
[    0.803774] Linux agpgart interface v0.103
[    0.803914] agpgart: Detected VIA KT400/KT400A/KT600 chipset
[    0.812547] agpgart-via 0000:00:00.0: AGP aperture is 128M @ 0xe0000000
[    0.812583] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.813055] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.813059] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    0.813228] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.813356] mice: PS/2 mouse device common for all mice
[    0.813419] rtc_cmos 00:03: RTC can wake from S4
[    0.813484] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.813533] rtc0: alarms up to one year, y3k, 114 bytes nvram
[    0.813549] cpuidle: using governor ladder
[    0.813552] cpuidle: using governor menu
[    0.813559] No iBFT detected.
[    0.814123] TCP cubic registered
[    0.814329] NET: Registered protocol family 10
[    0.814975] lo: Disabled Privacy Extensions
[    0.815451] Mobile IPv6
[    0.815456] NET: Registered protocol family 17
[    0.815480] Using IPI No-Shortcut mode
[    0.815570] PM: Resume from disk failed.
[    0.815582] registered taskstats version 1
[    0.815863] rtc_cmos 00:03: setting system clock to 2010-05-30 02:28:34 UTC (1275186514)
[    0.815900] Initalizing network drop monitor service
[    0.815939] Freeing unused kernel memory: 376k freed
[    0.816521] Write protecting the kernel text: 2492k
[    0.816548] Write protecting the kernel read-only data: 916k
[    0.840078] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.840803] udev: starting version 154
[    0.899562] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    1.067992] SCSI subsystem initialized
[    1.096600] skge 0000:00:05.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.096616] skge 0000:00:05.0: PCI: Disallowing DAC for device
[    1.096656] skge 1.13 addr 0xdffec000 irq 16 chip Yukon-Lite rev 9
[    1.097826] skge eth0: addr 00:19:5b:86:3e:fb
[    1.106253] libata version 3.00 loaded.
[    1.134481] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    1.134517] megaraid: probe new device 0x101e:0x1960:0x101e:0x0511: bus 0:slot 8:func 0
[    1.134550] megaraid 0000:00:08.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.135825] usbcore: registered new interface driver usbfs
[    1.136077] usbcore: registered new interface driver hub
[    1.136295] usbcore: registered new device driver usb
[    1.140724] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.156035] megaraid: fw version:[N661] bios version:[1.01]
[    1.196050] megaraid 0000:00:08.0: PCI: Disallowing DAC for device
[    1.196054] megaraid: DMA mask for 64-bit failed
[    1.196307] scsi0 : LSI Logic MegaRAID driver
[    1.196718] sata_via 0000:00:0f.0: version 2.4
[    1.196752] sata_via 0000:00:0f.0: PCI INT B -> GSI 20 (level, low) -> IRQ 20
[    1.196827] sata_via 0000:00:0f.0: routed to hard irq line 11
[    1.197797] scsi[0]: scanning scsi channel 0 [Phy 0] for non-raid devices
[    1.197817] scsi1 : sata_via
[    1.197976] scsi2 : sata_via
[    1.198034] ata1: SATA max UDMA/133 cmd 0xe800 ctl 0xe400 bmdma 0xd800 irq 20
[    1.198038] ata2: SATA max UDMA/133 cmd 0xe000 ctl 0xdc00 bmdma 0xd808 irq 20
[    1.198226] ehci_hcd 0000:00:10.4: PCI INT C -> GSI 21 (level, low) -> IRQ 21
[    1.198260] ehci_hcd 0000:00:10.4: EHCI Host Controller
[    1.198292] ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 1
[    1.198372] ehci_hcd 0000:00:10.4: irq 21, io mem 0xdffe7e00
[    1.208014] ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00
[    1.208059] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.208063] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.208068] usb usb1: Product: EHCI Host Controller
[    1.208071] usb usb1: Manufacturer: Linux 2.6.32-5-686 ehci_hcd
[    1.208074] usb usb1: SerialNumber: 0000:00:10.4
[    1.208213] usb usb1: configuration #1 chosen from 1 choice
[    1.208261] hub 1-0:1.0: USB hub found
[    1.208278] hub 1-0:1.0: 2 ports detected
[    1.208518] pata_via 0000:00:0f.1: version 0.3.4
[    1.208540] pata_via 0000:00:0f.1: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.208903] scsi3 : pata_via
[    1.209050] scsi4 : pata_via
[    1.211032] ata3: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 irq 14
[    1.211037] ata4: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xfc08 irq 15
[    1.238137] scsi[0]: scanning scsi channel 1 [Phy 1] for non-raid devices
[    1.242852] scsi[0]: scanning scsi channel 2 [Phy 2] for non-raid devices
[    1.400013] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.428535] ata3.00: ATA-6: ST3160021A, 8.01, max UDMA/100
[    1.428540] ata3.00: 312581808 sectors, multi 16: LBA48 
[    1.444390] ata3.00: configured for UDMA/100
[    1.586345] ata1.00: ATA-8: WDC WD20EADS-00R6B0, 01.00A01, max UDMA/133
[    1.586350] ata1.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    1.600459] ata1.00: configured for UDMA/133
[    1.600476] scsi: waiting for bus probes to complete ...
[    4.144021] floppy0: no floppy controllers found
[    4.183781] scsi[0]: scanning scsi channel 3 [Phy 3] for non-raid devices
[    4.188443] scsi[0]: scanning scsi channel 4 [virtual] for logical drives
[    4.188944] scsi 0:4:0:0: Direct-Access     MegaRAID LD 0 RAID0  915G N661 PQ: 0 ANSI: 2
[    4.196926] scsi 1:0:0:0: Direct-Access     ATA      WDC WD20EADS-00R 01.0 PQ: 0 ANSI: 5
[    4.400016] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.672136] ata2.00: ATA-8: WDC WD20EADS-00R6B0, 01.00A01, max UDMA/133
[    4.672141] ata2.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    4.688340] ata2.00: configured for UDMA/133
[    4.688511] scsi 2:0:0:0: Direct-Access     ATA      WDC WD20EADS-00R 01.0 PQ: 0 ANSI: 5
[    4.688935] scsi 3:0:0:0: Direct-Access     ATA      ST3160021A       8.01 PQ: 0 ANSI: 5
[    4.867043] sd 0:4:0:0: [sda] 1875419136 512-byte logical blocks: (960 GB/894 GiB)
[    4.867066] sd 0:4:0:0: [sda] Write Protect is off
[    4.867071] sd 0:4:0:0: [sda] Mode Sense: 00 00 00 00
[    4.867087] sd 0:4:0:0: [sda] Asking for cache data failed
[    4.867130] sd 0:4:0:0: [sda] Assuming drive cache: write through
[    4.867250] sd 1:0:0:0: [sdb] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    4.867331] sd 1:0:0:0: [sdb] Write Protect is off
[    4.867335] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    4.867369] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.867572] sd 0:4:0:0: [sda] Asking for cache data failed
[    4.867610] sd 0:4:0:0: [sda] Assuming drive cache: write through
[    4.867649]  sda:
[    4.867720]  sdb:
[    4.867946] sd 2:0:0:0: [sdc] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    4.868058] sd 2:0:0:0: [sdc] Write Protect is off
[    4.868063] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    4.868096] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.868271]  sdc:
[    4.868484] sd 3:0:0:0: [sdd] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    4.868559] sd 3:0:0:0: [sdd] Write Protect is off
[    4.868564] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    4.868597] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.868770]  sdd: sdd1 sdd2
[    4.872652] uhci_hcd: USB Universal Host Controller Interface driver
[    4.872743] uhci_hcd 0000:00:10.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    4.872757] uhci_hcd 0000:00:10.0: UHCI Host Controller
[    4.873654] sd 3:0:0:0: [sdd] Attached SCSI disk
[    4.873687] uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
[    4.873719] uhci_hcd 0000:00:10.0: irq 21, io base 0x0000d000
[    4.873783] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    4.873787] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.873791] usb usb2: Product: UHCI Host Controller
[    4.873795] usb usb2: Manufacturer: Linux 2.6.32-5-686 uhci_hcd
[    4.873798] usb usb2: SerialNumber: 0000:00:10.0
[    4.873976] usb usb2: configuration #1 chosen from 1 choice
[    4.874069] hub 2-0:1.0: USB hub found
[    4.874087] hub 2-0:1.0: 2 ports detected
[    4.890762]  unknown partition table
[    4.891236] sd 0:4:0:0: [sda] Asking for cache data failed
[    4.891280] sd 0:4:0:0: [sda] Assuming drive cache: write through
[    4.891320] sd 0:4:0:0: [sda] Attached SCSI disk
[    4.902987] ldm_parse_tocblock(): Cannot find TOCBLOCK, database may be corrupt.
[    4.903033] ldm_parse_tocblock(): Cannot find TOCBLOCK, database may be corrupt.
[    4.917566] ldm_parse_tocblock(): Cannot find TOCBLOCK, database may be corrupt.
[    4.917613] ldm_parse_tocblock(): Cannot find TOCBLOCK, database may be corrupt.
[    4.937463]  [LDM] sdc1
[    4.939755] sd 2:0:0:0: [sdc] Attached SCSI disk
[    4.952235]  [LDM] sdb1
[    4.953972] sd 1:0:0:0: [sdb] Attached SCSI disk
[    5.314368] md: linear personality registered for level -1
[    5.318770] md: multipath personality registered for level -4
[    5.322538] md: raid0 personality registered for level 0
[    5.328874] md: raid1 personality registered for level 1
[    5.332288] async_tx: api initialized (async)
[    5.333691] xor: automatically using best checksumming function: pIII_sse
[    5.352006]    pIII_sse  :  4379.000 MB/sec
[    5.352010] xor: using function: pIII_sse (4379.000 MB/sec)
[    5.420048] raid6: int32x1    693 MB/s
[    5.488054] raid6: int32x2    713 MB/s
[    5.556023] raid6: int32x4    586 MB/s
[    5.624086] raid6: int32x8    535 MB/s
[    5.692037] raid6: mmxx1     1385 MB/s
[    5.760013] raid6: mmxx2     2367 MB/s
[    5.828029] raid6: sse1x1    1254 MB/s
[    5.896006] raid6: sse1x2    2042 MB/s
[    5.896009] raid6: using algorithm sse1x2 (2042 MB/s)
[    5.906037] md: raid6 personality registered for level 6
[    5.906043] md: raid5 personality registered for level 5
[    5.906046] md: raid4 personality registered for level 4
[    5.916633] md: raid10 personality registered for level 10
[    6.022443] PM: Starting manual resume from disk
[    6.022449] PM: Resume from partition 8:49
[    6.022452] PM: Checking hibernation image.
[    6.022721] PM: Error -22 checking image file
[    6.022724] PM: Resume from disk failed.
[    6.097662] kjournald starting.  Commit interval 5 seconds
[    6.097679] EXT3-fs: mounted filesystem with ordered data mode.
[    7.717185] udev: starting version 154
[    8.278190] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    8.278204] ACPI: Power Button [PWRB]
[    8.278774] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    8.278787] ACPI: Sleep Button [SLPB]
[    8.278941] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    8.278947] ACPI: Power Button [PWRF]
[    8.294525] processor LNXCPU:00: registered as cooling_device0
[    8.730770] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    8.948844] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    9.004501] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    9.062984] ACPI: I/O resource vt596_smbus [0x400-0x407] conflicts with ACPI region SMOV [0x400-0x406]
[    9.063034] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    9.086668] Error: Driver 'pcspkr' is already registered, aborting...
[    9.131685] [drm] Initialized drm 1.1.0 20060810
[    9.211478] [drm] radeon defaulting to userspace modesetting.
[    9.211619] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    9.211917] [drm] Initialized radeon 1.32.0 20080528 for 0000:01:00.0 on minor 0
[   11.400030] floppy0: no floppy controllers found
[   12.383113] Adding 3903752k swap on /dev/sdd1.  Priority:-1 extents:1 across:3903752k 
[   12.655225] EXT3 FS on sdd2, internal journal
[   12.790558] loop: module loaded
[   14.130415] skge eth0: enabling interface
[   14.137668] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   16.514145] skge eth0: Link is up at 1000 Mbps, full duplex, flow control both
[   16.514468] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   26.764010] eth0: no IPv6 routers present
[   81.362326] md: nonpersistent superblock ...
[   81.362334] md: bind<sdb1>
[   81.362369] md: nonpersistent superblock ...
[   81.362373] md: bind<sdc1>
[   81.375783] raid0: looking at sdc1
[   81.375789] raid0:   comparing sdc1(3907024896)
[   81.375793]  with sdc1(3907024896)
[   81.375795] raid0:   END
[   81.375797] raid0:   ==> UNIQUE
[   81.375799] raid0: 1 zones
[   81.375802] raid0: looking at sdb1
[   81.375805] raid0:   comparing sdb1(3907024896)
[   81.375808]  with sdc1(3907024896)
[   81.375810] raid0:   EQUAL
[   81.375813] raid0: FINAL 1 zones
[   81.375820] raid0: done.
[   81.375823] raid0 : md_size is 7814049792 sectors.
[   81.375826] ******* md0 configuration *********
[   81.375829] zone0=[sdb1/sdc1/]
[   81.375834]         zone offset=0kb device offset=0kb size=3907024896kb
[   81.375837] **********************************
[   81.375839] 
[   81.375860] md0: detected capacity change from 0 to 4000793493504
[   81.379948]  md0: AHDI p2 p3
[  106.457983] fuse init (API version 7.13)
[  283.308963] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  283.309007] ata2.00: BMDMA stat 0x4
[  283.309045] ata2.00: failed command: READ DMA
[  283.309089] ata2.00: cmd c8/00:08:08:08:30/00:00:00:00:00/e0 tag 0 dma 4096 in
[  283.309091]          res 41/04:00:08:08:30/00:00:00:00:00/e0 Emask 0x1 (device error)
[  283.309171] ata2.00: status: { DRDY ERR }
[  283.309207] ata2.00: error: { ABRT }
[  283.324886] ata2.00: configured for UDMA/133
[  283.324904] ata2: EH complete
[  293.152233] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  293.152281] ata2.00: BMDMA stat 0x4
[  293.152324] ata2.00: failed command: READ DMA
[  293.152374] ata2.00: cmd c8/00:08:08:08:30/00:00:00:00:00/e0 tag 0 dma 4096 in
[  293.152376]          res 41/04:00:08:08:30/00:00:00:00:00/e0 Emask 0x1 (device error)
[  293.152478] ata2.00: status: { DRDY ERR }
[  293.152520] ata2.00: error: { ABRT }
[  293.169153] ata2.00: configured for UDMA/133
[  293.169175] ata2: EH complete
[  302.974467] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  302.974521] ata2.00: BMDMA stat 0x4
[  302.974563] ata2.00: failed command: READ DMA
[  302.974613] ata2.00: cmd c8/00:08:08:08:30/00:00:00:00:00/e0 tag 0 dma 4096 in
[  302.974615]          res 41/04:00:08:08:30/00:00:00:00:00/e0 Emask 0x1 (device error)
[  302.974717] ata2.00: status: { DRDY ERR }
[  302.974758] ata2.00: error: { ABRT }
[  302.988395] ata2.00: configured for UDMA/133
[  302.988407] ata2: EH complete
[  312.833746] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  312.833795] ata2.00: BMDMA stat 0x4
[  312.833836] ata2.00: failed command: READ DMA
[  312.833885] ata2.00: cmd c8/00:08:08:08:30/00:00:00:00:00/e0 tag 0 dma 4096 in
[  312.833887]          res 41/04:00:08:08:30/00:00:00:00:00/e0 Emask 0x1 (device error)
[  312.833988] ata2.00: status: { DRDY ERR }
[  312.834030] ata2.00: error: { ABRT }
[  312.848704] ata2.00: configured for UDMA/133
[  312.848713] ata2: EH complete
[  322.756097] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  322.756144] ata2.00: BMDMA stat 0x4
[  322.756186] ata2.00: failed command: READ DMA
[  322.756234] ata2.00: cmd c8/00:08:08:08:30/00:00:00:00:00/e0 tag 0 dma 4096 in
[  322.756237]          res 41/04:00:08:08:30/00:00:00:00:00/e0 Emask 0x1 (device error)
[  322.756338] ata2.00: status: { DRDY ERR }
[  322.756379] ata2.00: error: { ABRT }
[  322.773043] ata2.00: configured for UDMA/133
[  322.773052] ata2: EH complete
[  332.623395] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  332.623442] ata2.00: BMDMA stat 0x4
[  332.623483] ata2.00: failed command: READ DMA
[  332.623532] ata2.00: cmd c8/00:08:08:08:30/00:00:00:00:00/e0 tag 0 dma 4096 in
[  332.623534]          res 41/04:00:08:08:30/00:00:00:00:00/e0 Emask 0x1 (device error)
[  332.623636] ata2.00: status: { DRDY ERR }
[  332.623677] ata2.00: error: { ABRT }
[  332.636329] ata2.00: configured for UDMA/133
[  332.636342] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  332.636347] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] [descriptor]
[  332.636354] Descriptor sense data with sense descriptors (in hex):
[  332.636357]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[  332.636368]         00 30 08 08 
[  332.636373] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[  332.636379] sd 2:0:0:0: [sdc] CDB: Read(10): 28 00 00 30 08 08 00 00 08 00
[  332.636390] end_request: I/O error, dev sdc, sector 3147784
[  332.636437] Buffer I/O error on device md0, logical block 786449
[  332.636493] ata2: EH complete
[  342.429638] ata2.00: limiting speed to UDMA/100:PIO4
[  342.429644] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[  342.429691] ata2.00: BMDMA stat 0x4
[  342.429733] ata2.00: failed command: READ DMA
[  342.429781] ata2.00: cmd c8/00:08:08:08:30/00:00:00:00:00/e0 tag 0 dma 4096 in
[  342.429783]          res 41/04:00:08:08:30/00:00:00:00:00/e0 Emask 0x1 (device error)
[  342.429885] ata2.00: status: { DRDY ERR }
[  342.429926] ata2.00: error: { ABRT }
[  342.429975] ata2: soft resetting link
[  347.624011] ata2: link is slow to respond, please be patient (ready=0)
[  352.088701] ata2.00: configured for UDMA/100
[  352.088711] ata2: EH complete
[  365.337220] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  365.337267] ata2.00: BMDMA stat 0x4
[  365.337309] ata2.00: failed command: READ DMA
[  365.337358] ata2.00: cmd c8/00:08:08:08:30/00:00:00:00:00/e0 tag 0 dma 4096 in
[  365.337360]          res 41/04:00:08:08:30/00:00:00:00:00/e0 Emask 0x1 (device error)
[  365.337462] ata2.00: status: { DRDY ERR }
[  365.337503] ata2.00: error: { ABRT }
[  365.353164] ata2.00: configured for UDMA/100
[  365.353174] ata2: EH complete
[  375.243552] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  375.243599] ata2.00: BMDMA stat 0x4
[  375.243641] ata2.00: failed command: READ DMA
[  375.243690] ata2.00: cmd c8/00:08:08:08:30/00:00:00:00:00/e0 tag 0 dma 4096 in
[  375.243692]          res 41/04:00:08:08:30/00:00:00:00:00/e0 Emask 0x1 (device error)
[  375.243793] ata2.00: status: { DRDY ERR }
[  375.243834] ata2.00: error: { ABRT }
[  375.264503] ata2.00: configured for UDMA/100
[  375.264512] ata2: EH complete
[  385.098840] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  385.098886] ata2.00: BMDMA stat 0x4
[  385.098928] ata2.00: failed command: READ DMA
[  385.098976] ata2.00: cmd c8/00:08:08:08:30/00:00:00:00:00/e0 tag 0 dma 4096 in
[  385.098979]          res 41/04:00:08:08:30/00:00:00:00:00/e0 Emask 0x1 (device error)
[  385.099080] ata2.00: status: { DRDY ERR }
[  385.099121] ata2.00: error: { ABRT }
[  385.112780] ata2.00: configured for UDMA/100
[  385.112789] ata2: EH complete
[  394.934110] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  394.934158] ata2.00: BMDMA stat 0x4
[  394.934199] ata2.00: failed command: READ DMA
[  394.934248] ata2.00: cmd c8/00:08:08:08:30/00:00:00:00:00/e0 tag 0 dma 4096 in
[  394.934250]          res 41/04:00:08:08:30/00:00:00:00:00/e0 Emask 0x1 (device error)
[  394.934351] ata2.00: status: { DRDY ERR }
[  394.934393] ata2.00: error: { ABRT }
[  394.949068] ata2.00: configured for UDMA/100
[  394.949077] ata2: EH complete
[  404.759367] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  404.759414] ata2.00: BMDMA stat 0x4
[  404.759455] ata2.00: failed command: READ DMA
[  404.759504] ata2.00: cmd c8/00:08:08:08:30/00:00:00:00:00/e0 tag 0 dma 4096 in
[  404.759506]          res 41/04:00:08:08:30/00:00:00:00:00/e0 Emask 0x1 (device error)
[  404.759607] ata2.00: status: { DRDY ERR }
[  404.759648] ata2.00: error: { ABRT }
[  404.772313] ata2.00: configured for UDMA/100
[  404.772324] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  404.772330] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] [descriptor]
[  404.772336] Descriptor sense data with sense descriptors (in hex):
[  404.772339]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[  404.772350]         00 30 08 08 
[  404.772355] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[  404.772361] sd 2:0:0:0: [sdc] CDB: Read(10): 28 00 00 30 08 08 00 00 08 00
[  404.772371] end_request: I/O error, dev sdc, sector 3147784
[  404.772418] Buffer I/O error on device md0, logical block 786449
[  404.772473] ata2: EH complete

Both of the 2TB drives are jumpered to SATA I. I also tested them both on
another machine while jumpered to SATA I, and it seemed to handle a
bonnie++ test just fine.

-- 
Thomas Fjellstrom
tfjellstrom@strangesoft.net
