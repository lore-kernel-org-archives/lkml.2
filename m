Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab2ENHqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 03:46:18 -0400
Received: from seven.medozas.de ([188.40.89.202]:43691 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087Ab2ENHqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 03:46:14 -0400
Date: Mon, 14 May 2012 09:46:10 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: irqs disabled: nobody cared on linux 3.2
Message-ID: <alpine.LNX.2.01.1205140923420.31253@frira.vanv.qr>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.


I have here the system/mainboard ASUS E35M-M, with 3 extra add-in
SATA extender cards, and have observed this in dmesg:

[ 3365.384727] irq 19: nobody cared (try booting with the "irqpoll" 
option)
<trace>
[ 3365.385915] Disabling IRQ #19
No. 19 in /proc/interrupts is
        CPU0       CPU1
 19:        295     201993   IO-APIC-fasteoi   ahci, sata_sil

Afterwards disk write went go down by a factor 3.5x.

Looking at the mainboard I do see VIA chips. So there goes all hope
for functional hardware. (The E35M-I board had no VIA
components and certainly ran fine.)

But maybe someone has a last hint?


--- Full report (dmesg, lspci, dmidecode, etc) ---
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.2.7-jng4-default (geeko@buildhost) (gcc version 4.6.2 (SUSE Linux) ) #1 SMP Wed Feb 22 12:14:08 UTC 2012 (1f01958)
[    0.000000] Command line: root=/dev/disk/by-label/nasroot splash=silent showopts nomodeset
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000092800 (usable)
[    0.000000]  BIOS-e820: 0000000000092800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000a7c3f000 (usable)
[    0.000000]  BIOS-e820: 00000000a7c3f000 - 00000000a7c95000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000a7c95000 - 00000000a7cb6000 (reserved)
[    0.000000]  BIOS-e820: 00000000a7cb6000 - 00000000a7cc7000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000a7cc7000 - 00000000a7cdd000 (reserved)
[    0.000000]  BIOS-e820: 00000000a7cdd000 - 00000000a7cde000 (usable)
[    0.000000]  BIOS-e820: 00000000a7cde000 - 00000000a7ce6000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000a7ce6000 - 00000000a7d49000 (reserved)
[    0.000000]  BIOS-e820: 00000000a7d49000 - 00000000a7d8c000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000a7d8c000 - 00000000a7f00000 (usable)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec10000 - 00000000fec11000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed61000 - 00000000fed71000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed80000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fef00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100001000 - 000000023f000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: System manufacturer System Product Name/E35M1-M, BIOS 0401 02/16/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x23f000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF write-through
[    0.000000]   C0000-D5FFF write-protect
[    0.000000]   D6000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F00000000 write-back
[    0.000000]   1 base 0A7F00000 mask FFFF00000 uncachable
[    0.000000]   2 base 0A8000000 mask FF8000000 uncachable
[    0.000000]   3 base 0B0000000 mask FF0000000 uncachable
[    0.000000]   4 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 000000023f000000 aka 9200M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000a7f00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xa7f00 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000fcde0] fcde0
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 20480
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000a7f00000
[    0.000000]  0000000000 - 0080000000 page 1G
[    0.000000]  0080000000 - 00a7e00000 page 2M
[    0.000000]  00a7e00000 - 00a7f00000 page 4k
[    0.000000] kernel direct mapping tables up to a7f00000 @ 1fffd000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-000000023f000000
[    0.000000]  0100000000 - 0200000000 page 1G
[    0.000000]  0200000000 - 023f000000 page 2M
[    0.000000] kernel direct mapping tables up to 23f000000 @ a7efe000-a7f00000
[    0.000000] RAMDISK: 37a8d000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f0430 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 00000000a7c89068 00054 (v01 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: FACP 00000000a7c8fd18 000F4 (v04 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI Warning: Optional field Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1 - not using it (20110623/tbfadt-560)
[    0.000000] ACPI: DSDT 00000000a7c89150 06BC6 (v02 ALASKA    A M I 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000a7ce5f80 00040
[    0.000000] ACPI: APIC 00000000a7c8fe10 00062 (v03 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 00000000a7c8fe78 0003C (v01 ALASKA    A M I 01072009 MSFT 00010013)
[    0.000000] ACPI: HPET 00000000a7c8feb8 00038 (v01 ALASKA    A M I 01072009 AMI  00000004)
[    0.000000] ACPI: SSDT 00000000a7c8fef0 003DE (v01 AMD    POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: SSDT 00000000a7c902d0 012FA (v02    AMD     ALIB 00000001 MSFT 04000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000023f000000
[    0.000000] Initmem setup node 0 0000000000000000-000000023f000000
[    0.000000]   NODE_DATA [000000023efec000 - 000000023effffff]
[    0.000000]  [ffffea0000000000-ffffea0007dfffff] PMD -> [ffff880236c00000-ffff88023d7fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0023f000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[5] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000092
[    0.000000]     0: 0x00000100 -> 0x000a7c3f
[    0.000000]     0: 0x000a7cdd -> 0x000a7cde
[    0.000000]     0: 0x000a7d8c -> 0x000a7f00
[    0.000000]     0: 0x00100001 -> 0x0023f000
[    0.000000] On node 0 totalpages: 1994037
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3909 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 669164 pages, LIFO batch:31
[    0.000000]   Normal zone: 17864 pages used for memmap
[    0.000000]   Normal zone: 1288759 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 0000000000092000 - 0000000000093000
[    0.000000] PM: Registered nosave memory: 0000000000093000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000a7c3f000 - 00000000a7c95000
[    0.000000] PM: Registered nosave memory: 00000000a7c95000 - 00000000a7cb6000
[    0.000000] PM: Registered nosave memory: 00000000a7cb6000 - 00000000a7cc7000
[    0.000000] PM: Registered nosave memory: 00000000a7cc7000 - 00000000a7cdd000
[    0.000000] PM: Registered nosave memory: 00000000a7cde000 - 00000000a7ce6000
[    0.000000] PM: Registered nosave memory: 00000000a7ce6000 - 00000000a7d49000
[    0.000000] PM: Registered nosave memory: 00000000a7d49000 - 00000000a7d8c000
[    0.000000] PM: Registered nosave memory: 00000000a7f00000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fec11000
[    0.000000] PM: Registered nosave memory: 00000000fec11000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed01000
[    0.000000] PM: Registered nosave memory: 00000000fed01000 - 00000000fed61000
[    0.000000] PM: Registered nosave memory: 00000000fed61000 - 00000000fed71000
[    0.000000] PM: Registered nosave memory: 00000000fed71000 - 00000000fed80000
[    0.000000] PM: Registered nosave memory: 00000000fed80000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000fef00000
[    0.000000] PM: Registered nosave memory: 00000000fef00000 - 0000000100000000
[    0.000000] PM: Registered nosave memory: 0000000100000000 - 0000000100001000
[    0.000000] Allocating PCI resources starting at a7f00000 (gap: a7f00000:38100000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88023ec00000 s77888 r8192 d24512 u1048576
[    0.000000] pcpu-alloc: s77888 r8192 d24512 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1961832
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/disk/by-label/nasroot splash=silent showopts nomodeset
[    0.000000] bootsplash: silent mode.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 7781796k/9420800k available (3920k kernel code, 1444652k absent, 194352k reserved, 5420k data, 820k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:33024 nr_irqs:512 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 63963136 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1647.879 MHz processor.
[    0.004006] Calibrating delay loop (skipped), value calculated using timer frequency.. 3295.75 BogoMIPS (lpj=6591516)
[    0.004123] pid_max: default: 32768 minimum: 301
[    0.004270] Security Framework initialized
[    0.004340] AppArmor: AppArmor initialized
[    0.008397] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.013843] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.016424] Mount-cache hash table entries: 256
[    0.016729] Initializing cgroup subsys cpuacct
[    0.016793] Initializing cgroup subsys memory
[    0.016890] Initializing cgroup subsys devices
[    0.016950] Initializing cgroup subsys freezer
[    0.017008] Initializing cgroup subsys net_cls
[    0.017065] Initializing cgroup subsys blkio
[    0.017132] Initializing cgroup subsys perf_event
[    0.017245] tseg: 00a7f00000
[    0.017250] CPU: Physical Processor ID: 0
[    0.017306] CPU: Processor Core ID: 0
[    0.017362] mce: CPU supports 6 MCE banks
[    0.018236] ACPI: Core revision 20110623
[    0.028376] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.068136] CPU0: AMD E-350 Processor stepping 00
[    0.072003] Performance Events: AMD PMU driver.
[    0.072003] ... version:                0
[    0.072003] ... bit width:              48
[    0.072003] ... generic registers:      4
[    0.072003] ... value mask:             0000ffffffffffff
[    0.072003] ... max period:             00007fffffffffff
[    0.072003] ... fixed-purpose events:   0
[    0.072003] ... event mask:             000000000000000f
[    0.072003] NMI watchdog enabled, takes one hw-pmu counter.
[    0.072003] Booting Node   0, Processors  #1 Ok.
[    0.072003] smpboot cpu 1: start_ip = 8d000
[    0.164052] NMI watchdog enabled, takes one hw-pmu counter.
[    0.164189] Brought up 2 CPUs
[    0.164246] Total of 2 processors activated (6591.80 BogoMIPS).
[    0.164877] devtmpfs: initialized
[    0.172867] PM: Registering ACPI NVS region at a7c3f000 (352256 bytes)
[    0.172867] PM: Registering ACPI NVS region at a7cb6000 (69632 bytes)
[    0.172867] PM: Registering ACPI NVS region at a7cde000 (32768 bytes)
[    0.172867] PM: Registering ACPI NVS region at a7d49000 (274432 bytes)
[    0.172867] print_constraints: dummy: 
[    0.172873] RTC time: 20:14:48, date: 05/13/12
[    0.173073] NET: Registered protocol family 16
[    0.173482] Extended Config Space enabled on 0 nodes
[    0.173572] ACPI: bus type pci registered
[    0.173765] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.173838] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.228546] PCI: Using configuration type 1 for base access
[    0.229014] mtrr: your CPUs had inconsistent fixed MTRR settings
[    0.229074] mtrr: probably your BIOS does not setup all CPUs.
[    0.229132] mtrr: corrected configuration.
[    0.230772] bio: create slab <bio-0> at 0
[    0.232217] ACPI: Added _OSI(Module Device)
[    0.232282] ACPI: Added _OSI(Processor Device)
[    0.232338] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.232394] ACPI: Added _OSI(Processor Aggregator Device)
[    0.237344] ACPI: EC: Look up EC in DSDT
[    0.240174] ACPI: Executed 3 blocks of module-level executable AML code
[    0.246251] ACPI Error: [RAMB] Namespace lookup failure, AE_NOT_FOUND (20110623/psargs-359)
[    0.246457] ACPI Exception: AE_NOT_FOUND, Could not execute arguments for [RAMW] (Region) (20110623/nsinit-349)
[    0.256998] ACPI: Interpreter enabled
[    0.257068] ACPI: (supports S0 S3 S4 S5)
[    0.257338] ACPI: Using IOAPIC for interrupt routing
[    0.271279] ACPI: No dock devices found.
[    0.271343] HEST: Table not found.
[    0.271403] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.271864] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.272721] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.272784] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.272845] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.272914] pci_root PNP0A03:00: host bridge window [mem 0x000c8000-0x000dffff]
[    0.272983] pci_root PNP0A03:00: host bridge window [mem 0xc0000000-0xffffffff]
[    0.273058] pci_root PNP0A03:00: ignoring host bridge window [mem 0x000c8000-0x000dffff] (conflicts with Video ROM [mem 0x000c0000-0x000ce1ff])
[    0.273149] pci 0000:00:00.0: [1022:1510] type 0 class 0x000600
[    0.273214] pci 0000:00:01.0: [1002:9802] type 0 class 0x000300
[    0.273230] pci 0000:00:01.0: reg 10: [mem 0xc0000000-0xcfffffff pref]
[    0.273240] pci 0000:00:01.0: reg 14: [io  0xf000-0xf0ff]
[    0.273251] pci 0000:00:01.0: reg 18: [mem 0xfe800000-0xfe83ffff]
[    0.273273] pci 0000:00:01.0: reg 24: [mem 0xfe500000-0xfe5fffff]
[    0.273318] pci 0000:00:01.0: supports D1 D2
[    0.273347] pci 0000:00:01.1: [1002:1314] type 0 class 0x000403
[    0.273361] pci 0000:00:01.1: reg 10: [mem 0xfe844000-0xfe847fff]
[    0.273434] pci 0000:00:01.1: supports D1 D2
[    0.273472] pci 0000:00:04.0: [1022:1512] type 1 class 0x000604
[    0.273550] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.273558] pci 0000:00:04.0: PME# disabled
[    0.273611] pci 0000:00:11.0: [1002:4391] type 0 class 0x000106
[    0.273638] pci 0000:00:11.0: reg 10: [io  0xf140-0xf147]
[    0.273652] pci 0000:00:11.0: reg 14: [io  0xf130-0xf133]
[    0.273667] pci 0000:00:11.0: reg 18: [io  0xf120-0xf127]
[    0.273681] pci 0000:00:11.0: reg 1c: [io  0xf110-0xf113]
[    0.273695] pci 0000:00:11.0: reg 20: [io  0xf100-0xf10f]
[    0.273709] pci 0000:00:11.0: reg 24: [mem 0xfe84f000-0xfe84f3ff]
[    0.273793] pci 0000:00:12.0: [1002:4397] type 0 class 0x000c03
[    0.273812] pci 0000:00:12.0: reg 10: [mem 0xfe84e000-0xfe84efff]
[    0.273911] pci 0000:00:12.2: [1002:4396] type 0 class 0x000c03
[    0.273937] pci 0000:00:12.2: reg 10: [mem 0xfe84d000-0xfe84d0ff]
[    0.274045] pci 0000:00:12.2: supports D1 D2
[    0.274049] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.274056] pci 0000:00:12.2: PME# disabled
[    0.274090] pci 0000:00:13.0: [1002:4397] type 0 class 0x000c03
[    0.274109] pci 0000:00:13.0: reg 10: [mem 0xfe84c000-0xfe84cfff]
[    0.274208] pci 0000:00:13.2: [1002:4396] type 0 class 0x000c03
[    0.274235] pci 0000:00:13.2: reg 10: [mem 0xfe84b000-0xfe84b0ff]
[    0.274342] pci 0000:00:13.2: supports D1 D2
[    0.274346] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.274353] pci 0000:00:13.2: PME# disabled
[    0.274388] pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
[    0.274497] pci 0000:00:14.2: [1002:4383] type 0 class 0x000403
[    0.274526] pci 0000:00:14.2: reg 10: [mem 0xfe840000-0xfe843fff 64bit]
[    0.274614] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.274621] pci 0000:00:14.2: PME# disabled
[    0.274645] pci 0000:00:14.3: [1002:439d] type 0 class 0x000601
[    0.274750] pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
[    0.274813] pci 0000:00:14.5: [1002:4399] type 0 class 0x000c03
[    0.274833] pci 0000:00:14.5: reg 10: [mem 0xfe84a000-0xfe84afff]
[    0.274934] pci 0000:00:15.0: [1002:43a0] type 1 class 0x000604
[    0.275039] pci 0000:00:15.0: supports D1 D2
[    0.275080] pci 0000:00:15.1: [1002:43a1] type 1 class 0x000604
[    0.275185] pci 0000:00:15.1: supports D1 D2
[    0.275226] pci 0000:00:15.2: [1002:43a2] type 1 class 0x000604
[    0.275330] pci 0000:00:15.2: supports D1 D2
[    0.275373] pci 0000:00:16.0: [1002:4397] type 0 class 0x000c03
[    0.275393] pci 0000:00:16.0: reg 10: [mem 0xfe849000-0xfe849fff]
[    0.275493] pci 0000:00:16.2: [1002:4396] type 0 class 0x000c03
[    0.275519] pci 0000:00:16.2: reg 10: [mem 0xfe848000-0xfe8480ff]
[    0.275626] pci 0000:00:16.2: supports D1 D2
[    0.275630] pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
[    0.275637] pci 0000:00:16.2: PME# disabled
[    0.275672] pci 0000:00:18.0: [1022:1700] type 0 class 0x000600
[    0.275729] pci 0000:00:18.1: [1022:1701] type 0 class 0x000600
[    0.275777] pci 0000:00:18.2: [1022:1702] type 0 class 0x000600
[    0.275829] pci 0000:00:18.3: [1022:1703] type 0 class 0x000600
[    0.275891] pci 0000:00:18.4: [1022:1704] type 0 class 0x000600
[    0.275944] pci 0000:00:18.5: [1022:1718] type 0 class 0x000600
[    0.275993] pci 0000:00:18.6: [1022:1716] type 0 class 0x000600
[    0.276071] pci 0000:00:18.7: [1022:1719] type 0 class 0x000600
[    0.276174] pci 0000:00:04.0: PCI bridge to [bus 01-01]
[    0.276319] pci 0000:00:14.4: PCI bridge to [bus 02-02] (subtractive decode)
[    0.276390] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.276396] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.276402] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.276407] pci 0000:00:14.4:   bridge window [mem 0xc0000000-0xffffffff] (subtractive decode)
[    0.276506] pci 0000:03:00.0: [11ab:7042] type 0 class 0x000100
[    0.276538] pci 0000:03:00.0: reg 10: [mem 0xfe400000-0xfe4fffff 64bit]
[    0.276556] pci 0000:03:00.0: reg 18: [io  0xe000-0xe0ff]
[    0.276705] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.276790] pci 0000:00:15.0: PCI bridge to [bus 03-03]
[    0.276853] pci 0000:00:15.0:   bridge window [io  0xe000-0xefff]
[    0.276860] pci 0000:00:15.0:   bridge window [mem 0xfe000000-0xfe4fffff]
[    0.276964] pci 0000:04:00.0: [10ec:8168] type 0 class 0x000200
[    0.276988] pci 0000:04:00.0: reg 10: [io  0xd000-0xd0ff]
[    0.277027] pci 0000:04:00.0: reg 18: [mem 0xd0004000-0xd0004fff 64bit pref]
[    0.277053] pci 0000:04:00.0: reg 20: [mem 0xd0000000-0xd0003fff 64bit pref]
[    0.277154] pci 0000:04:00.0: supports D1 D2
[    0.277158] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.277167] pci 0000:04:00.0: PME# disabled
[    0.284106] pci 0000:00:15.1: PCI bridge to [bus 04-04]
[    0.284187] pci 0000:00:15.1:   bridge window [io  0xd000-0xdfff]
[    0.284201] pci 0000:00:15.1:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
[    0.284315] pci 0000:05:00.0: [1b21:1080] type 1 class 0x000604
[    0.284459] pci 0000:00:15.2: PCI bridge to [bus 05-06]
[    0.284523] pci 0000:00:15.2:   bridge window [io  0xc000-0xcfff]
[    0.284531] pci 0000:00:15.2:   bridge window [mem 0xfe600000-0xfe7fffff]
[    0.284609] pci 0000:06:00.0: [1095:3114] type 0 class 0x000104
[    0.284645] pci 0000:06:00.0: reg 10: [io  0xc110-0xc117]
[    0.284666] pci 0000:06:00.0: reg 14: [io  0xc100-0xc103]
[    0.284686] pci 0000:06:00.0: reg 18: [io  0xc0f0-0xc0f7]
[    0.284706] pci 0000:06:00.0: reg 1c: [io  0xc0e0-0xc0e3]
[    0.284727] pci 0000:06:00.0: reg 20: [io  0xc0d0-0xc0df]
[    0.284747] pci 0000:06:00.0: reg 24: [mem 0xfe702000-0xfe7023ff]
[    0.284768] pci 0000:06:00.0: reg 30: [mem 0xfe680000-0xfe6fffff pref]
[    0.284825] pci 0000:06:00.0: supports D1 D2
[    0.284861] pci 0000:06:01.0: [1095:3114] type 0 class 0x000104
[    0.284897] pci 0000:06:01.0: reg 10: [io  0xc0c0-0xc0c7]
[    0.284917] pci 0000:06:01.0: reg 14: [io  0xc0b0-0xc0b3]
[    0.284937] pci 0000:06:01.0: reg 18: [io  0xc0a0-0xc0a7]
[    0.284958] pci 0000:06:01.0: reg 1c: [io  0xc090-0xc093]
[    0.284978] pci 0000:06:01.0: reg 20: [io  0xc080-0xc08f]
[    0.284999] pci 0000:06:01.0: reg 24: [mem 0xfe701000-0xfe7013ff]
[    0.285019] pci 0000:06:01.0: reg 30: [mem 0xfe600000-0xfe67ffff pref]
[    0.285075] pci 0000:06:01.0: supports D1 D2
[    0.285113] pci 0000:06:02.0: [1106:3044] type 0 class 0x000c00
[    0.285149] pci 0000:06:02.0: reg 10: [mem 0xfe700000-0xfe7007ff]
[    0.285169] pci 0000:06:02.0: reg 14: [io  0xc000-0xc07f]
[    0.285309] pci 0000:06:02.0: supports D2
[    0.285313] pci 0000:06:02.0: PME# supported from D2 D3hot D3cold
[    0.285323] pci 0000:06:02.0: PME# disabled
[    0.285406] pci 0000:05:00.0: PCI bridge to [bus 06-06] (subtractive decode)
[    0.285476] pci 0000:05:00.0:   bridge window [io  0xc000-0xcfff]
[    0.285484] pci 0000:05:00.0:   bridge window [mem 0xfe600000-0xfe7fffff]
[    0.285498] pci 0000:05:00.0:   bridge window [io  0xc000-0xcfff] (subtractive decode)
[    0.285503] pci 0000:05:00.0:   bridge window [mem 0xfe600000-0xfe7fffff] (subtractive decode)
[    0.285509] pci 0000:05:00.0:   bridge window [??? 0x00000000 flags 0x0] (subtractive decode)
[    0.285514] pci 0000:05:00.0:   bridge window [??? 0x00000000 flags 0x0] (subtractive decode)
[    0.285572] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.286078] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR14._PRT]
[    0.286169] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE20._PRT]
[    0.286257] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE21._PRT]
[    0.286358] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE22._PRT]
[    0.286455] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE22.BR23._PRT]
[    0.286594]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.286657]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    0.286726] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.305784] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 11 14 15) *0
[    0.306396] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 11 14 15) *0
[    0.307003] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 11 14 15) *0
[    0.307607] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 10 11 14 15) *0
[    0.308169] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 14 15) *0
[    0.308712] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 14 15) *0
[    0.309252] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 10 11 14 15) *0
[    0.309793] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 14 15) *0
[    0.310498] vgaarb: device added: PCI:0000:00:01.0,decodes=io+mem,owns=io+mem,locks=none
[    0.310498] vgaarb: loaded
[    0.310498] vgaarb: bridge control possible 0000:00:01.0
[    0.310498] SCSI subsystem initialized
[    0.310498] libata version 3.00 loaded.
[    0.310498] PCI: Using ACPI for IRQ routing
[    0.322179] PCI: pci_cache_line_size set to 64 bytes
[    0.322370] reserve RAM buffer: 0000000000092800 - 000000000009ffff 
[    0.322376] reserve RAM buffer: 00000000a7c3f000 - 00000000a7ffffff 
[    0.322384] reserve RAM buffer: 00000000a7cde000 - 00000000a7ffffff 
[    0.322390] reserve RAM buffer: 00000000a7f00000 - 00000000a7ffffff 
[    0.322395] reserve RAM buffer: 000000023f000000 - 000000023fffffff 
[    0.322654] NetLabel: Initializing
[    0.322711] NetLabel:  domain hash size = 128
[    0.322767] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.322845] NetLabel:  unlabeled traffic allowed by default
[    0.322911] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.323138] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.325057] Switching to clocksource hpet
[    0.328457] AppArmor: AppArmor Filesystem Enabled
[    0.328581] pnp: PnP ACPI init
[    0.328673] ACPI: bus type pnp registered
[    0.329213] pnp 00:00: [bus 00-ff]
[    0.329219] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.329224] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.329229] pnp 00:00: [io  0x0d00-0xffff window]
[    0.329237] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.329243] pnp 00:00: [mem 0x000c8000-0x000dffff window]
[    0.329248] pnp 00:00: [mem 0xc0000000-0xffffffff window]
[    0.329253] pnp 00:00: [mem 0x00000000 window]
[    0.329367] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.329476] pnp 00:01: [mem 0xe0000000-0xefffffff]
[    0.329602] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.329667] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.330813] pnp 00:02: [io  0x040b]
[    0.330818] pnp 00:02: [io  0x04d6]
[    0.330823] pnp 00:02: [io  0x0c00-0x0c01]
[    0.330827] pnp 00:02: [io  0x0c14]
[    0.330831] pnp 00:02: [io  0x0c50-0x0c51]
[    0.330835] pnp 00:02: [io  0x0c52]
[    0.330839] pnp 00:02: [io  0x0c6c]
[    0.330842] pnp 00:02: [io  0x0c6f]
[    0.330846] pnp 00:02: [io  0x0cd0-0x0cd1]
[    0.330850] pnp 00:02: [io  0x0cd2-0x0cd3]
[    0.330855] pnp 00:02: [io  0x0cd4-0x0cd5]
[    0.330859] pnp 00:02: [io  0x0cd6-0x0cd7]
[    0.330863] pnp 00:02: [io  0x0cd8-0x0cdf]
[    0.330867] pnp 00:02: [io  0x0800-0x089f]
[    0.330871] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    0.330876] pnp 00:02: [io  0x0000-0x000f]
[    0.330880] pnp 00:02: [io  0x0b20-0x0b3f]
[    0.330884] pnp 00:02: [io  0x0900-0x090f]
[    0.330888] pnp 00:02: [io  0x0910-0x091f]
[    0.330892] pnp 00:02: [io  0xfe00-0xfefe]
[    0.330896] pnp 00:02: [io  0x0060-0x005f disabled]
[    0.330900] pnp 00:02: [io  0x0064-0x0063 disabled]
[    0.330905] pnp 00:02: [mem 0xfec00000-0xfec00fff]
[    0.330910] pnp 00:02: [mem 0xfee00000-0xfee00fff]
[    0.330914] pnp 00:02: [mem 0xfed80000-0xfed8ffff]
[    0.330921] pnp 00:02: [mem 0xfed61000-0xfed70fff]
[    0.330926] pnp 00:02: [mem 0xfec10000-0xfec10fff]
[    0.330930] pnp 00:02: [mem 0xfed00000-0xfed00fff]
[    0.330935] pnp 00:02: [mem 0xffc00000-0xffffffff]
[    0.331119] system 00:02: [io  0x040b] has been reserved
[    0.331180] system 00:02: [io  0x04d6] has been reserved
[    0.331240] system 00:02: [io  0x0c00-0x0c01] has been reserved
[    0.331301] system 00:02: [io  0x0c14] has been reserved
[    0.331361] system 00:02: [io  0x0c50-0x0c51] has been reserved
[    0.331421] system 00:02: [io  0x0c52] has been reserved
[    0.331480] system 00:02: [io  0x0c6c] has been reserved
[    0.331540] system 00:02: [io  0x0c6f] has been reserved
[    0.331599] system 00:02: [io  0x0cd0-0x0cd1] has been reserved
[    0.331660] system 00:02: [io  0x0cd2-0x0cd3] has been reserved
[    0.331720] system 00:02: [io  0x0cd4-0x0cd5] has been reserved
[    0.331780] system 00:02: [io  0x0cd6-0x0cd7] has been reserved
[    0.331840] system 00:02: [io  0x0cd8-0x0cdf] has been reserved
[    0.331901] system 00:02: [io  0x0800-0x089f] has been reserved
[    0.331961] system 00:02: [io  0x0b20-0x0b3f] has been reserved
[    0.332055] system 00:02: [io  0x0900-0x090f] has been reserved
[    0.332117] system 00:02: [io  0x0910-0x091f] has been reserved
[    0.332178] system 00:02: [io  0xfe00-0xfefe] has been reserved
[    0.332240] system 00:02: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.332302] system 00:02: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.332364] system 00:02: [mem 0xfed80000-0xfed8ffff] has been reserved
[    0.332426] system 00:02: [mem 0xfed61000-0xfed70fff] has been reserved
[    0.332487] system 00:02: [mem 0xfec10000-0xfec10fff] has been reserved
[    0.332547] system 00:02: [mem 0xfed00000-0xfed00fff] has been reserved
[    0.332607] system 00:02: [mem 0xffc00000-0xffffffff] has been reserved
[    0.332667] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.332954] pnp 00:03: [io  0x0000-0xffffffffffffffff disabled]
[    0.332960] pnp 00:03: [io  0x0000-0xffffffffffffffff disabled]
[    0.332965] pnp 00:03: [io  0x0290-0x029f]
[    0.332969] pnp 00:03: [io  0x0a20-0x0a2f]
[    0.333071] system 00:03: [io  0x0290-0x029f] has been reserved
[    0.333131] system 00:03: [io  0x0a20-0x0a2f] has been reserved
[    0.333191] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.334160] pnp 00:04: [io  0x0378-0x037f]
[    0.334165] pnp 00:04: [io  0x0778-0x077f]
[    0.334184] pnp 00:04: [irq 5]
[    0.334189] pnp 00:04: [dma 0 disabled]
[    0.334544] pnp 00:04: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.334578] pnp 00:05: [dma 4]
[    0.334585] pnp 00:05: [io  0x0000-0x000f]
[    0.334590] pnp 00:05: [io  0x0081-0x0083]
[    0.334594] pnp 00:05: [io  0x0087]
[    0.334599] pnp 00:05: [io  0x0089-0x008b]
[    0.334603] pnp 00:05: [io  0x008f]
[    0.334607] pnp 00:05: [io  0x00c0-0x00df]
[    0.334674] pnp 00:05: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.334706] pnp 00:06: [io  0x0070-0x0071]
[    0.334715] pnp 00:06: [irq 8]
[    0.334776] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.334801] pnp 00:07: [io  0x0061]
[    0.334865] pnp 00:07: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.334935] pnp 00:08: [io  0x0010-0x001f]
[    0.334940] pnp 00:08: [io  0x0022-0x003f]
[    0.334945] pnp 00:08: [io  0x0044-0x005f]
[    0.334949] pnp 00:08: [io  0x0072-0x007f]
[    0.334953] pnp 00:08: [io  0x0080]
[    0.334957] pnp 00:08: [io  0x0084-0x0086]
[    0.334961] pnp 00:08: [io  0x0088]
[    0.334965] pnp 00:08: [io  0x008c-0x008e]
[    0.334969] pnp 00:08: [io  0x0090-0x009f]
[    0.334973] pnp 00:08: [io  0x00a2-0x00bf]
[    0.334978] pnp 00:08: [io  0x00e0-0x00ef]
[    0.334982] pnp 00:08: [io  0x04d0-0x04d1]
[    0.335111] system 00:08: [io  0x04d0-0x04d1] has been reserved
[    0.335174] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.335201] pnp 00:09: [io  0x00f0-0x00ff]
[    0.335210] pnp 00:09: [irq 13]
[    0.335276] pnp 00:09: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.335415] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.335482] pnp 00:0b: [io  0x0060]
[    0.335486] pnp 00:0b: [io  0x0064]
[    0.335496] pnp 00:0b: [irq 1]
[    0.335580] pnp 00:0b: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.336293] pnp 00:0c: [io  0x03f8-0x03ff]
[    0.336303] pnp 00:0c: [irq 4]
[    0.336307] pnp 00:0c: [dma 0 disabled]
[    0.336465] pnp 00:0c: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.336655] pnp 00:0d: [mem 0xa8000000-0xbfffffff]
[    0.336776] system 00:0d: [mem 0xa8000000-0xbfffffff] has been reserved
[    0.336841] system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.337226] pnp 00:0e: [mem 0xfed00000-0xfed003ff]
[    0.337311] pnp 00:0e: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.337329] pnp: PnP ACPI: found 15 devices
[    0.337386] ACPI: ACPI bus type pnp unregistered
[    0.348455] rpldhk 2.40, by Jan Engelhardt, 2004 - 2009
[    0.353088] PCI: max bus depth: 2 pci_try_num: 3
[    0.353169] pci 0000:00:04.0: BAR 14: assigned [mem 0xd0100000-0xd02fffff]
[    0.353234] pci 0000:00:04.0: BAR 15: assigned [mem 0xd0300000-0xd04fffff 64bit pref]
[    0.353307] pci 0000:00:04.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.353368] pci 0000:00:04.0: PCI bridge to [bus 01-01]
[    0.353427] pci 0000:00:04.0:   bridge window [io  0x1000-0x1fff]
[    0.353489] pci 0000:00:04.0:   bridge window [mem 0xd0100000-0xd02fffff]
[    0.353552] pci 0000:00:04.0:   bridge window [mem 0xd0300000-0xd04fffff 64bit pref]
[    0.353624] pci 0000:00:14.4: PCI bridge to [bus 02-02]
[    0.353695] pci 0000:00:15.0: PCI bridge to [bus 03-03]
[    0.353754] pci 0000:00:15.0:   bridge window [io  0xe000-0xefff]
[    0.353816] pci 0000:00:15.0:   bridge window [mem 0xfe000000-0xfe4fffff]
[    0.353884] pci 0000:00:15.1: PCI bridge to [bus 04-04]
[    0.353943] pci 0000:00:15.1:   bridge window [io  0xd000-0xdfff]
[    0.354008] pci 0000:00:15.1:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
[    0.354082] pci 0000:05:00.0: PCI bridge to [bus 06-06]
[    0.354142] pci 0000:05:00.0:   bridge window [io  0xc000-0xcfff]
[    0.354207] pci 0000:05:00.0:   bridge window [mem 0xfe600000-0xfe7fffff]
[    0.354279] pci 0000:00:15.2: PCI bridge to [bus 05-06]
[    0.354338] pci 0000:00:15.2:   bridge window [io  0xc000-0xcfff]
[    0.354400] pci 0000:00:15.2:   bridge window [mem 0xfe600000-0xfe7fffff]
[    0.354498] pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.354560] pci 0000:00:04.0: setting latency timer to 64
[    0.354577] pci 0000:00:15.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.354637] pci 0000:00:15.0: setting latency timer to 64
[    0.354648] pci 0000:00:15.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.354709] pci 0000:00:15.1: setting latency timer to 64
[    0.354719] pci 0000:00:15.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.354779] pci 0000:00:15.2: setting latency timer to 64
[    0.354797] pci 0000:05:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.354860] pci 0000:05:00.0: setting latency timer to 64
[    0.354868] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.354872] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.354876] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.354881] pci_bus 0000:00: resource 7 [mem 0xc0000000-0xffffffff]
[    0.354885] pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
[    0.354889] pci_bus 0000:01: resource 1 [mem 0xd0100000-0xd02fffff]
[    0.354894] pci_bus 0000:01: resource 2 [mem 0xd0300000-0xd04fffff 64bit pref]
[    0.354899] pci_bus 0000:02: resource 4 [io  0x0000-0x0cf7]
[    0.354903] pci_bus 0000:02: resource 5 [io  0x0d00-0xffff]
[    0.354907] pci_bus 0000:02: resource 6 [mem 0x000a0000-0x000bffff]
[    0.354912] pci_bus 0000:02: resource 7 [mem 0xc0000000-0xffffffff]
[    0.354916] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
[    0.354920] pci_bus 0000:03: resource 1 [mem 0xfe000000-0xfe4fffff]
[    0.354925] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
[    0.354929] pci_bus 0000:04: resource 2 [mem 0xd0000000-0xd00fffff 64bit pref]
[    0.354934] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    0.354938] pci_bus 0000:05: resource 1 [mem 0xfe600000-0xfe7fffff]
[    0.354942] pci_bus 0000:06: resource 0 [io  0xc000-0xcfff]
[    0.354946] pci_bus 0000:06: resource 1 [mem 0xfe600000-0xfe7fffff]
[    0.354950] pci_bus 0000:06: resource 4 [io  0xc000-0xcfff]
[    0.354954] pci_bus 0000:06: resource 5 [mem 0xfe600000-0xfe7fffff]
[    0.355142] NET: Registered protocol family 2
[    0.355740] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.358819] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.364047] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.364684] TCP: Hash tables configured (established 524288 bind 65536)
[    0.364747] TCP reno registered
[    0.364851] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.365011] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.365439] NET: Registered protocol family 1
[    0.365526] pci 0000:00:01.0: Boot video device
[    1.424414] PCI: CLS 64 bytes, default 64
[    1.424532] Unpacking initramfs...
[    1.620360] Freeing initrd memory: 5516k freed
[    1.623544] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.623610] Placing 64MB software IO TLB between ffff8800a3c3f000 - ffff8800a7c3f000
[    1.623679] software IO TLB at phys 0xa3c3f000 - 0xa7c3f000
[    1.624499] perf: AMD IBS detected (0x000000ff)
[    1.625240] audit: initializing netlink socket (disabled)
[    1.625330] type=2000 audit(1336940089.620:1): initialized
[    1.691124] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.749539] VFS: Disk quotas dquot_6.5.2
[    1.749671] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.750114] msgmni has been set to 15209
[    1.751067] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.751344] io scheduler noop registered
[    1.751508] io scheduler cfq registered (default)
[    1.752488] ERST: Table is not found!
[    1.752547] GHES: HEST is not enabled!
[    1.752852] Serial: 8250/16550 driver, 16 ports, IRQ sharing disabled
[    1.773435] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.857699] 00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.873242] ahci 0000:00:11.0: version 3.0
[    1.873284] ahci 0000:00:11.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.873564] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 6 ports 6 Gbps 0x3f impl SATA mode
[    1.873637] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
[    1.875944] scsi0 : ahci
[    1.876559] scsi1 : ahci
[    1.877092] scsi2 : ahci
[    1.877604] scsi3 : ahci
[    1.878120] scsi4 : ahci
[    1.878582] scsi5 : ahci
[    1.878842] ata1: SATA max UDMA/133 abar m1024@0xfe84f000 port 0xfe84f100 irq 19
[    1.878915] ata2: SATA max UDMA/133 abar m1024@0xfe84f000 port 0xfe84f180 irq 19
[    1.878984] ata3: SATA max UDMA/133 abar m1024@0xfe84f000 port 0xfe84f200 irq 19
[    1.879054] ata4: SATA max UDMA/133 abar m1024@0xfe84f000 port 0xfe84f280 irq 19
[    1.879124] ata5: SATA max UDMA/133 abar m1024@0xfe84f000 port 0xfe84f300 irq 19
[    1.879193] ata6: SATA max UDMA/133 abar m1024@0xfe84f000 port 0xfe84f380 irq 19
[    1.882263] Fixed MDIO Bus: probed
[    1.882322] arcnet loaded.
[    1.882468] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    1.882527] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    1.883298] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.883900] mousedev: PS/2 mouse device common for all mice
[    1.884380] rtc_cmos 00:06: RTC can wake from S4
[    1.884737] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    1.884840] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.884925] cpuidle: using governor ladder
[    1.884981] cpuidle: using governor menu
[    1.885034] EFI Variables Facility v0.08 2004-May-17
[    1.885484] TCP hybla registered
[    1.885701] NET: Registered protocol family 10
[    1.886609] Registering the dns_resolver key type
[    1.887501] PM: Hibernation image not present or could not be loaded.
[    1.887543] registered taskstats version 1
[    1.917160]   Magic number: 12:260:245
[    1.917402] rtc_cmos 00:06: setting system clock to 2012-05-13 20:14:50 UTC (1336940090)
[    1.929425] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    2.208275] ata6: SATA link down (SStatus 0 SControl 300)
[    2.380255] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.386522] ata5.00: ATA-8: SAMSUNG HM640JJ, 2AK10001, max UDMA/133
[    2.386592] ata5.00: 1250263728 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.392945] ata5.00: configured for UDMA/133
[    2.492264] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.492371] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.492466] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.492546] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.497078] ata2.00: ATA-8: WDC WD20EARS-00MVWB0, 51.0AB51, max UDMA/133
[    2.497160] ata2.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.497446] ata3.00: ATA-8: WDC WD20EARS-00MVWB0, 51.0AB51, max UDMA/133
[    2.497516] ata3.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.502122] ata2.00: configured for UDMA/133
[    2.513113] ata4.00: ATA-8: WDC WD20EARS-00MVWB0, 51.0AB51, max UDMA/133
[    2.513193] ata4.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.517628] ata3.00: configured for UDMA/133
[    2.517732] ata4.00: configured for UDMA/133
[    2.527651] ata1.00: ATA-8: WDC WD20EARS-00MVWB0, 51.0AB51, max UDMA/133
[    2.527721] ata1.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.548478] ata1.00: configured for UDMA/133
[    2.549054] scsi 0:0:0:0: Direct-Access     ATA      WDC WD20EARS-00M 51.0 PQ: 0 ANSI: 5
[    2.549628] sd 0:0:0:0: [sda] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    2.549717] scsi 1:0:0:0: Direct-Access     ATA      WDC WD20EARS-00M 51.0 PQ: 0 ANSI: 5
[    2.549819] sd 0:0:0:0: [sda] Write Protect is off
[    2.549880] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.549930] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.550131] sd 1:0:0:0: [sdb] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    2.550268] scsi 2:0:0:0: Direct-Access     ATA      WDC WD20EARS-00M 51.0 PQ: 0 ANSI: 5
[    2.550336] sd 1:0:0:0: [sdb] Write Protect is off
[    2.550343] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.550392] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.550699] sd 2:0:0:0: [sdc] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    2.550953] sd 2:0:0:0: [sdc] Write Protect is off
[    2.550996] scsi 3:0:0:0: Direct-Access     ATA      WDC WD20EARS-00M 51.0 PQ: 0 ANSI: 5
[    2.551078] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    2.551307] sd 3:0:0:0: [sdd] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    2.551464] scsi 4:0:0:0: Direct-Access     ATA      SAMSUNG HM640JJ  2AK1 PQ: 0 ANSI: 5
[    2.551689] sd 3:0:0:0: [sdd] Write Protect is off
[    2.551751] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    2.551805] sd 4:0:0:0: [sde] 1250263728 512-byte logical blocks: (640 GB/596 GiB)
[    2.551815] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.552167] sd 4:0:0:0: [sde] Write Protect is off
[    2.552227] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    2.552250] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.552280] sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.563082]  sda: unknown partition table
[    2.564631] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.571670]  sdd: unknown partition table
[    2.572200]  sdc: unknown partition table
[    2.572435] sd 3:0:0:0: [sdd] Attached SCSI disk
[    2.573374] sd 2:0:0:0: [sdc] Attached SCSI disk
[    2.578968]  sdb: unknown partition table
[    2.580178]  sde: sde1 sde2 sde3
[    2.580245] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.582156] sd 4:0:0:0: [sde] Attached SCSI disk
[    2.585400] Freeing unused kernel memory: 820k freed
[    2.585878] Write protecting the kernel read-only data: 8192k
[    2.587476] Freeing unused kernel memory: 160k freed
[    2.590334] Freeing unused kernel memory: 356k freed
[    2.624142] Refined TSC clocksource calibration: 1648.038 MHz.
[    2.624217] Switching to clocksource tsc
[    2.659287] usbcore: registered new interface driver usbfs
[    2.659403] usbcore: registered new interface driver hub
[    2.659783] usbcore: registered new device driver usb
[    2.662249] usbcore: registered new interface driver usbhid
[    2.662316] usbhid: USB HID core driver
[    2.700719] udevd[97]: starting version 173
[    2.738533] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.738665] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.738761] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    2.738876] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    2.738957] ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    2.739065] QUIRK: Enable AMD PLL fix
[    2.739084] ehci_hcd 0000:00:12.2: debug port 1
[    2.739180] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe84d000
[    2.751648] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    2.751767] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.751829] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.751898] usb usb1: Product: EHCI Host Controller
[    2.751956] usb usb1: Manufacturer: Linux 3.2.7-jng4-default ehci_hcd
[    2.752087] usb usb1: SerialNumber: 0000:00:12.2
[    2.755052] hub 1-0:1.0: USB hub found
[    2.755128] hub 1-0:1.0: 5 ports detected
[    2.755372] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.755492] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    2.755571] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    2.755651] ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    2.755759] ehci_hcd 0000:00:13.2: debug port 1
[    2.755841] ehci_hcd 0000:00:13.2: irq 17, io mem 0xfe84b000
[    2.764178] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    2.764297] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    2.764359] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.764428] usb usb2: Product: EHCI Host Controller
[    2.764486] usb usb2: Manufacturer: Linux 3.2.7-jng4-default ehci_hcd
[    2.764546] usb usb2: SerialNumber: 0000:00:13.2
[    2.767664] hub 2-0:1.0: USB hub found
[    2.767740] hub 2-0:1.0: 5 ports detected
[    2.767979] ehci_hcd 0000:00:16.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.768123] ehci_hcd 0000:00:16.2: EHCI Host Controller
[    2.768198] ehci_hcd 0000:00:16.2: new USB bus registered, assigned bus number 3
[    2.768279] ehci_hcd 0000:00:16.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    2.768386] ehci_hcd 0000:00:16.2: debug port 1
[    2.768470] ehci_hcd 0000:00:16.2: irq 17, io mem 0xfe848000
[    2.780374] ehci_hcd 0000:00:16.2: USB 2.0 started, EHCI 1.00
[    2.780499] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    2.780562] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.780631] usb usb3: Product: EHCI Host Controller
[    2.780689] usb usb3: Manufacturer: Linux 3.2.7-jng4-default ehci_hcd
[    2.780749] usb usb3: SerialNumber: 0000:00:16.2
[    2.781330] hub 3-0:1.0: USB hub found
[    2.781398] hub 3-0:1.0: 4 ports detected
[    2.807228] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.807342] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.807443] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    2.807526] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 4
[    2.807653] ohci_hcd 0000:00:12.0: irq 18, io mem 0xfe84e000
[    2.816219] ACPI: acpi_idle registered with cpuidle
[    2.864116] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.864188] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.864258] usb usb4: Product: OHCI Host Controller
[    2.864316] usb usb4: Manufacturer: Linux 3.2.7-jng4-default ohci_hcd
[    2.864376] usb usb4: SerialNumber: 0000:00:12.0
[    2.864764] hub 4-0:1.0: USB hub found
[    2.864836] hub 4-0:1.0: 5 ports detected
[    2.865062] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.865183] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    2.865257] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    2.865360] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe84c000
[    2.924224] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.924295] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.927146] usb usb5: Product: OHCI Host Controller
[    2.927203] usb usb5: Manufacturer: Linux 3.2.7-jng4-default ohci_hcd
[    2.927261] usb usb5: SerialNumber: 0000:00:13.0
[    2.927790] hub 5-0:1.0: USB hub found
[    2.927858] hub 5-0:1.0: 5 ports detected
[    2.928109] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.928221] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    2.928293] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 6
[    2.928394] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe84a000
[    2.988294] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    2.988364] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.988432] usb usb6: Product: OHCI Host Controller
[    2.988490] usb usb6: Manufacturer: Linux 3.2.7-jng4-default ohci_hcd
[    2.988549] usb usb6: SerialNumber: 0000:00:14.5
[    2.989048] hub 6-0:1.0: USB hub found
[    2.989125] hub 6-0:1.0: 2 ports detected
[    2.989356] ohci_hcd 0000:00:16.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.989462] ohci_hcd 0000:00:16.0: OHCI Host Controller
[    2.989533] ohci_hcd 0000:00:16.0: new USB bus registered, assigned bus number 7
[    2.989694] ohci_hcd 0000:00:16.0: irq 18, io mem 0xfe849000
[    3.048285] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    3.048431] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.048500] usb usb7: Product: OHCI Host Controller
[    3.048558] usb usb7: Manufacturer: Linux 3.2.7-jng4-default ohci_hcd
[    3.048617] usb usb7: SerialNumber: 0000:00:16.0
[    3.049153] hub 7-0:1.0: USB hub found
[    3.049262] hub 7-0:1.0: 4 ports detected
[    3.321902] device-mapper: uevent: version 1.0.3
[    3.322136] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[   11.116901] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[   11.275047] EXT4-fs (dm-0): re-mounted. Opts: acl,user_xattr
[   12.096555] systemd[1]: systemd 37 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +SYSVINIT +LIBCRYPTSETUP; suse)
[   12.395615] systemd[1]: Set hostname to <nas.site>.
[   14.311389] systemd[1]: Cannot add dependency job for unit amavis.service, ignoring: Unit amavis.service failed to load: No such file or directory. See system logs and 'systemctl status amavis.service' for details.
[   14.311510] systemd[1]: Cannot add dependency job for unit mysql.service, ignoring: Unit mysql.service failed to load: No such file or directory. See system logs and 'systemctl status mysql.service' for details.
[   14.311613] systemd[1]: Cannot add dependency job for unit cyrus.service, ignoring: Unit cyrus.service failed to load: No such file or directory. See system logs and 'systemctl status cyrus.service' for details.
[   14.311715] systemd[1]: Cannot add dependency job for unit ldap.service, ignoring: Unit ldap.service failed to load: No such file or directory. See system logs and 'systemctl status ldap.service' for details.
[   14.311817] systemd[1]: Cannot add dependency job for unit openslp.service, ignoring: Unit openslp.service failed to load: No such file or directory. See system logs and 'systemctl status openslp.service' for details.
[   14.311919] systemd[1]: Cannot add dependency job for unit ypbind.service, ignoring: Unit ypbind.service failed to load: No such file or directory. See system logs and 'systemctl status ypbind.service' for details.
[   15.299563] udevd[396]: starting version 173
[   15.994523] EXT4-fs (dm-0): re-mounted. Opts: acl,user_xattr
[   16.734882] boot.localnet[406]: Using boot-specified hostname 'nas.site'
[   16.735157] boot.localnet[406]: Setting up hostname 'nas'..done
[   16.788432] boot.localnet[406]: Setting up loopback interface RTNETLINK answers: File exists
[   16.791374] boot.localnet[406]: ..done
[   18.267229] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[   18.267693] ACPI: Power Button [PWRB]
[   18.267899] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[   18.268132] ACPI: Power Button [PWRF]
[   18.303858] sata_mv 0000:03:00.0: version 1.28
[   18.303935] sata_mv 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   18.304388] sata_mv 0000:03:00.0: Gen-IIE 32 slots 4 ports SCSI mode IRQ via INTx
[   18.304464] sata_mv 0000:03:00.0: setting latency timer to 64
[   18.309400] scsi6 : sata_mv
[   18.312144] scsi7 : sata_mv
[   18.312704] scsi8 : sata_mv
[   18.316089] scsi9 : sata_mv
[   18.316319] ata7: SATA max UDMA/133 mmio m1048576@0xfe400000 port 0xfe422000 irq 16
[   18.316392] ata8: SATA max UDMA/133 mmio m1048576@0xfe400000 port 0xfe424000 irq 16
[   18.316463] ata9: SATA max UDMA/133 mmio m1048576@0xfe400000 port 0xfe426000 irq 16
[   18.316535] ata10: SATA max UDMA/133 mmio m1048576@0xfe400000 port 0xfe428000 irq 16
[   18.323280] sata_sil 0000:06:00.0: version 2.4
[   18.323356] sata_sil 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   18.323476] sata_sil 0000:06:00.0: Applying R_ERR on DMA activate FIS errata fix
[   18.325301] scsi10 : sata_sil
[   18.327409] scsi11 : sata_sil
[   18.328675] scsi12 : sata_sil
[   18.329090] scsi13 : sata_sil
[   18.329320] ata11: SATA max UDMA/100 mmio m1024@0xfe702000 tf 0xfe702080 irq 18
[   18.329393] ata12: SATA max UDMA/100 mmio m1024@0xfe702000 tf 0xfe7020c0 irq 18
[   18.329464] ata13: SATA max UDMA/100 mmio m1024@0xfe702000 tf 0xfe702280 irq 18
[   18.329534] ata14: SATA max UDMA/100 mmio m1024@0xfe702000 tf 0xfe7022c0 irq 18
[   18.329698] sata_sil 0000:06:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   18.329835] sata_sil 0000:06:01.0: Applying R_ERR on DMA activate FIS errata fix
[   18.333727] scsi14 : sata_sil
[   18.334075] scsi15 : sata_sil
[   18.334289] scsi16 : sata_sil
[   18.334535] scsi17 : sata_sil
[   18.334692] ata15: SATA max UDMA/100 mmio m1024@0xfe701000 tf 0xfe701080 irq 19
[   18.334762] ata16: SATA max UDMA/100 mmio m1024@0xfe701000 tf 0xfe7010c0 irq 19
[   18.334830] ata17: SATA max UDMA/100 mmio m1024@0xfe701000 tf 0xfe701280 irq 19
[   18.334898] ata18: SATA max UDMA/100 mmio m1024@0xfe701000 tf 0xfe7012c0 irq 19
[   18.350792] input: PC Speaker as /devices/platform/pcspkr/input/input3
[   18.489025] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   18.489192] sd 1:0:0:0: Attached scsi generic sg1 type 0
[   18.489349] sd 2:0:0:0: Attached scsi generic sg2 type 0
[   18.489492] sd 3:0:0:0: Attached scsi generic sg3 type 0
[   18.489633] sd 4:0:0:0: Attached scsi generic sg4 type 0
[   18.536919] wmi: Mapper loaded
[   18.648287] ata11: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   18.656284] ata15: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   18.657071] ata11.00: ATA-7: SAMSUNG HD753LJ, 1AA01117, max UDMA7
[   18.657140] ata11.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   18.664896] ata11.00: configured for UDMA/100
[   18.665191] ata15.00: ATA-7: SAMSUNG HD753LJ, 1AA01118, max UDMA7
[   18.665261] ata15.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   18.672854] ata15.00: configured for UDMA/100
[   18.792090] ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   18.808369] ata7.00: ATA-8: WDC WD20EARS-00MVWB0, 51.0AB51, max UDMA/133
[   18.808440] ata7.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   18.828200] ata7.00: configured for UDMA/133
[   18.828493] scsi 6:0:0:0: Direct-Access     ATA      WDC WD20EARS-00M 51.0 PQ: 0 ANSI: 5
[   18.828971] sd 6:0:0:0: Attached scsi generic sg5 type 0
[   18.829872] sd 6:0:0:0: [sdf] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   18.830547] sd 6:0:0:0: [sdf] Write Protect is off
[   18.830617] sd 6:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[   18.830933] sd 6:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   18.858448] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   19.224077]  sdf: unknown partition table
[   19.225155] sd 6:0:0:0: [sdf] Attached SCSI disk
[   19.308292] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   19.324391] ata8.00: ATA-8: WDC WD20EARS-00MVWB0, 51.0AB51, max UDMA/133
[   19.324462] ata8.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   19.340285] ata8.00: configured for UDMA/133
[   19.340579] scsi 7:0:0:0: Direct-Access     ATA      WDC WD20EARS-00M 51.0 PQ: 0 ANSI: 5
[   19.341004] sd 7:0:0:0: [sdg] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   19.341029] sd 7:0:0:0: Attached scsi generic sg6 type 0
[   19.341585] sd 7:0:0:0: [sdg] Write Protect is off
[   19.341648] sd 7:0:0:0: [sdg] Mode Sense: 00 3a 00 00
[   19.341699] sd 7:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   19.587466] systemd-cryptsetup[650]: Encountered unknown /etc/crypttab option 'initrd', ignoring.
[   19.591003] systemd-cryptsetup[650]: Volume nasroot already active.
[   19.687875] EXT4-fs (sde1): mounting ext2 file system using the ext4 subsystem
[   19.689588] EXT4-fs (sde1): warning: mounting unchecked fs, running e2fsck is recommended
[   19.690063] EXT4-fs (sde1): mounted filesystem without journal. Opts: acl,user_xattr
[   19.768312] Adding 131068k swap on /dev/sde2.  Priority:0 extents:1 across:131068k 
[   19.780450]  sdg: sdg1
[   19.781972] sd 7:0:0:0: [sdg] Attached SCSI disk
[   19.816138] ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   19.832212] ata9.00: ATA-8: WDC WD20EARS-00MVWB0, 51.0AB51, max UDMA/133
[   19.832283] ata9.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   19.833271] boot.lvm[660]: Waiting for udev to settle...
[   19.848386] ata9.00: configured for UDMA/133
[   19.848915] scsi 8:0:0:0: Direct-Access     ATA      WDC WD20EARS-00M 51.0 PQ: 0 ANSI: 5
[   19.849484] sd 8:0:0:0: Attached scsi generic sg7 type 0
[   19.849497] sd 8:0:0:0: [sdh] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   19.849609] sd 8:0:0:0: [sdh] Write Protect is off
[   19.849617] sd 8:0:0:0: [sdh] Mode Sense: 00 3a 00 00
[   19.849665] sd 8:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   20.262682]  sdh: unknown partition table
[   20.263998] sd 8:0:0:0: [sdh] Attached SCSI disk
[   20.324290] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   20.340408] ata10.00: ATA-8: WDC WD20EARS-00MVWB0, 51.0AB51, max UDMA/133
[   20.340478] ata10.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   20.349016] ata10.00: configured for UDMA/133
[   20.349563] scsi 9:0:0:0: Direct-Access     ATA      WDC WD20EARS-00M 51.0 PQ: 0 ANSI: 5
[   20.350037] sd 9:0:0:0: [sdi] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   20.350047] sd 9:0:0:0: Attached scsi generic sg8 type 0
[   20.350342] sd 9:0:0:0: [sdi] Write Protect is off
[   20.350369] scsi 10:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 PQ: 0 ANSI: 5
[   20.350469] sd 9:0:0:0: [sdi] Mode Sense: 00 3a 00 00
[   20.350521] sd 9:0:0:0: [sdi] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   20.350657] sd 10:0:0:0: Attached scsi generic sg9 type 0
[   20.350922] sd 10:0:0:0: [sdj] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[   20.351114] sd 10:0:0:0: [sdj] Write Protect is off
[   20.351178] sd 10:0:0:0: [sdj] Mode Sense: 00 3a 00 00
[   20.351228] sd 10:0:0:0: [sdj] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   20.364453]  sdj: sdj1
[   20.365967] sd 10:0:0:0: [sdj] Attached SCSI disk
[   20.668290] ata12: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   20.676909] ata12.00: ATA-7: SAMSUNG HD753LJ, 1AA01117, max UDMA7
[   20.676979] ata12.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   20.684912] ata12.00: configured for UDMA/100
[   20.685488] scsi 11:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 PQ: 0 ANSI: 5
[   20.685977] sd 11:0:0:0: [sdk] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[   20.685984] sd 11:0:0:0: Attached scsi generic sg10 type 0
[   20.686381] sd 11:0:0:0: [sdk] Write Protect is off
[   20.686444] sd 11:0:0:0: [sdk] Mode Sense: 00 3a 00 00
[   20.686557] sd 11:0:0:0: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   20.703469]  sdk: sdk1
[   20.705152] sd 11:0:0:0: [sdk] Attached SCSI disk
[   20.766630]  sdi: unknown partition table
[   20.767955] sd 9:0:0:0: [sdi] Attached SCSI disk
[   21.004298] ata13: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   21.012884] ata13.00: ATA-7: SAMSUNG HD753LJ, 1AA01113, max UDMA7
[   21.012953] ata13.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   21.020885] ata13.00: configured for UDMA/100
[   21.021420] scsi 12:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 PQ: 0 ANSI: 5
[   21.021956] sd 12:0:0:0: Attached scsi generic sg11 type 0
[   21.022061] sd 12:0:0:0: [sdl] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[   21.022314] sd 12:0:0:0: [sdl] Write Protect is off
[   21.022375] sd 12:0:0:0: [sdl] Mode Sense: 00 3a 00 00
[   21.022474] sd 12:0:0:0: [sdl] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   21.042374]  sdl:
[   21.043585] sd 12:0:0:0: [sdl] Attached SCSI disk
[   21.340291] ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   21.348903] ata14.00: ATA-7: SAMSUNG HD753LJ, 1AA01112, max UDMA7
[   21.348973] ata14.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   21.356897] ata14.00: configured for UDMA/100
[   21.357456] scsi 13:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 PQ: 0 ANSI: 5
[   21.357927] sd 13:0:0:0: [sdm] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[   21.357945] sd 13:0:0:0: Attached scsi generic sg12 type 0
[   21.358283] scsi 14:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 PQ: 0 ANSI: 5
[   21.358291] sd 13:0:0:0: [sdm] Write Protect is off
[   21.358297] sd 13:0:0:0: [sdm] Mode Sense: 00 3a 00 00
[   21.358347] sd 13:0:0:0: [sdm] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   21.358794] sd 14:0:0:0: [sdn] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[   21.358989] sd 14:0:0:0: [sdn] Write Protect is off
[   21.359050] sd 14:0:0:0: [sdn] Mode Sense: 00 3a 00 00
[   21.359104] sd 14:0:0:0: [sdn] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   21.359468] sd 14:0:0:0: Attached scsi generic sg13 type 0
[   21.375292]  sdm:
[   21.376630] sd 13:0:0:0: [sdm] Attached SCSI disk
[   21.376648]  sdn:
[   21.377225] sd 14:0:0:0: [sdn] Attached SCSI disk
[   21.676289] ata16: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   21.684910] ata16.00: ATA-7: SAMSUNG HD753LJ, 1AA01118, max UDMA7
[   21.684980] ata16.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   21.692888] ata16.00: configured for UDMA/100
[   21.693426] scsi 15:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 PQ: 0 ANSI: 5
[   21.693975] sd 15:0:0:0: [sdo] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[   21.694158] sd 15:0:0:0: [sdo] Write Protect is off
[   21.694218] sd 15:0:0:0: [sdo] Mode Sense: 00 3a 00 00
[   21.694269] sd 15:0:0:0: [sdo] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   21.694904] sd 15:0:0:0: Attached scsi generic sg14 type 0
[   21.705778]  sdo:
[   21.709098] sd 15:0:0:0: [sdo] Attached SCSI disk
[   22.012291] ata17: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   22.020869] ata17.00: ATA-7: SAMSUNG HD753LJ, 1AA01118, max UDMA7
[   22.020938] ata17.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   22.028877] ata17.00: configured for UDMA/100
[   22.029418] scsi 16:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 PQ: 0 ANSI: 5
[   22.029896] sd 16:0:0:0: [sdp] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[   22.029913] sd 16:0:0:0: Attached scsi generic sg15 type 0
[   22.030341] sd 16:0:0:0: [sdp] Write Protect is off
[   22.030411] sd 16:0:0:0: [sdp] Mode Sense: 00 3a 00 00
[   22.030465] sd 16:0:0:0: [sdp] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   22.049971]  sdp:
[   22.050519] sd 16:0:0:0: [sdp] Attached SCSI disk
[   22.348291] ata18: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   22.356899] ata18.00: ATA-7: SAMSUNG HD753LJ, 1AA01118, max UDMA7
[   22.356969] ata18.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   22.364885] ata18.00: configured for UDMA/100
[   22.365435] scsi 17:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 PQ: 0 ANSI: 5
[   22.365919] sd 17:0:0:0: [sdq] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[   22.365929] sd 17:0:0:0: Attached scsi generic sg16 type 0
[   22.366283] sd 17:0:0:0: [sdq] Write Protect is off
[   22.366345] sd 17:0:0:0: [sdq] Mode Sense: 00 3a 00 00
[   22.366399] sd 17:0:0:0: [sdq] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   22.402356]  sdq:
[   22.402907] sd 17:0:0:0: [sdq] Attached SCSI disk
[   22.405956] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[   22.406668] SP5100 TCO timer: SP5100 TCO WatchDog Timer Driver v0.01
[   22.406853] SP5100 TCO timer: mmio address 0xbafe00 already in use
[   22.413959] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[   22.414065] r8169 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   22.414178] r8169 0000:04:00.0: setting latency timer to 64
[   22.414258] r8169 0000:04:00.0: irq 40 for MSI/MSI-X
[   22.414980] Linux agpgart interface v0.103
[   22.415039] r8169 0000:04:00.0: eth0: RTL8168e/8111e at 0xffffc90011786000, f4:6d:04:d8:9d:4e, XID 0c200000 IRQ 40
[   22.415046] r8169 0000:04:00.0: eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[   22.417922] asus_wmi: ASUS WMI generic driver loaded
[   22.419063] asus_wmi: Initialization: 0x0
[   22.419230] asus_wmi: BIOS WMI version: 0.9
[   22.419453] asus_wmi: SFUN value: 0x0
[   22.421503] parport_pc 00:04: reported by Plug and Play ACPI
[   22.421656] parport0: PC-style at 0x378, irq 5 [PCSPP,EPP]
[   22.428611] [drm] Initialized drm 1.1.0 20060810
[   22.430625] firewire_ohci 0000:06:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   22.433576] input: Eee PC WMI hotkeys as /devices/platform/eeepc-wmi/input/input4
[   22.447222] snd_hda_intel 0000:00:01.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   22.447305] ALSA hda_intel.c:2549 Using LPIB position fix
[   22.447396] snd_hda_intel 0000:00:01.1: irq 41 for MSI/MSI-X
[   22.447432] snd_hda_intel 0000:00:01.1: setting latency timer to 64
[   22.467430] [drm] VGACON disable radeon kernel modesetting.
[   22.469091] pci 0000:00:01.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   22.469157] pci 0000:00:01.0: setting latency timer to 64
[   22.470115] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   22.470194] [drm] No driver support for vblank timestamp query.
[   22.470208] ALSA hda_intel.c:1573 Enable sync_write for stable communication
[   22.470260] [drm] Initialized radeon 1.33.0 20080528 for 0000:00:01.0 on minor 0
[   22.481903] HDMI status: Codec=0 Pin=3 Presence_Detect=0 ELD_Valid=0
[   22.482229] input: HD-Audio Generic HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.1/sound/card0/input5
[   22.482747] snd_hda_intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   22.482825] ALSA hda_intel.c:2549 Using LPIB position fix
[   22.492587] firewire_ohci: Added fw-ohci device 0000:06:02.0, OHCI v1.10, 4 IR + 8 IT contexts, quirks 0x11
[   22.506955] ALSA hda_intel.c:1573 Enable sync_write for stable communication
[   22.532335] hda_codec: ALC887-VD: BIOS auto-probing.
[   22.532415] ALSA patch_realtek.c:1273 SKU: Nid=0x1d sku_cfg=0x4004c601
[   22.532421] ALSA patch_realtek.c:1275 SKU: port_connectivity=0x1
[   22.532426] ALSA patch_realtek.c:1276 SKU: enable_pcbeep=0x0
[   22.532431] ALSA patch_realtek.c:1277 SKU: check_sum=0x00000004
[   22.532436] ALSA patch_realtek.c:1278 SKU: customization=0x000000c6
[   22.532441] ALSA patch_realtek.c:1279 SKU: external_amp=0x0
[   22.532445] ALSA patch_realtek.c:1280 SKU: platform_type=0x0
[   22.532450] ALSA patch_realtek.c:1281 SKU: swap=0x0
[   22.532454] ALSA patch_realtek.c:1282 SKU: override=0x1
[   22.532466] ALSA hda_codec.c:4951 autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:line
[   22.532472] ALSA hda_codec.c:4955    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   22.532477] ALSA hda_codec.c:4959    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[   22.532482] ALSA hda_codec.c:4960    mono: mono_out=0x0
[   22.532487] ALSA hda_codec.c:4963    dig-out=0x11/0x1e
[   22.532491] ALSA hda_codec.c:4964    inputs:
[   22.532497] ALSA hda_codec.c:4968  Rear Mic=0x18
[   22.532501] ALSA hda_codec.c:4968  Front Mic=0x19
[   22.532506] ALSA hda_codec.c:4968  Line=0x1a
[   22.532510] ALSA hda_codec.c:4970 
[   22.536350] ALSA patch_realtek.c:1336 realtek: No valid SSID, checking pincfg 0x4004c601 for NID 0x1d
[   22.536359] ALSA patch_realtek.c:1352 realtek: Enabling init ASM_ID=0xc601 CODEC_ID=10ec0887
[   22.597213] ppdev: user-space parallel port driver
[   22.605716] input: HDA ATI SB Headphone as /devices/pci0000:00/0000:00:14.2/sound/card1/input6
[   22.882578] ifup[835]: Service network not started and mode 'auto' -> skipping
[   22.933296] boot.lvm[660]: Scanning for LVM volume groups...
[   22.992631] firewire_core: created device fw0: GUID 001e8c00004324c1, S400
[   23.062308] boot.lvm[660]: No volume groups found
[   23.062380] boot.lvm[660]: No volume groups found
[   23.084850] boot.lvm[660]: Reading all physical volumes.  This may take a while...
[   23.085342] boot.lvm[660]: Activating LVM volume groups...
[   23.110600] boot.lvm[660]: No volume groups found
[   23.112735] boot.lvm[660]: ..done
[   23.517469] tk-crypto[844]: Opening crypto volumes
[   23.568978] powernow-k8: Found 1 AMD E-350 Processor (2 cpu cores) (version 2.20.00)
[   23.569133] powernow-k8:    0 : pstate 0 (1600 MHz)
[   23.569191] powernow-k8:    1 : pstate 1 (1280 MHz)
[   23.569249] powernow-k8:    2 : pstate 2 (800 MHz)
[   23.583646] cpufreq[853]: Loading CPUFreq modules..done
[   24.618848] EXT4-fs (dm-1): warning: checktime reached, running e2fsck is recommended
[   24.658249] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
[   25.944355] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
[   25.959105] r8169 0000:04:00.0: eth0: unable to load firmware patch rtl_nic/rtl8168e-2.fw (-2)
[   25.975749] r8169 0000:04:00.0: eth0: link down
[   25.975826] r8169 0000:04:00.0: eth0: link down
[   25.978809] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   26.789542] EXT4-fs (dm-3): warning: maximal mount count reached, running e2fsck is recommended
[   26.820092] EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts: (null)
[   27.826837] EXT4-fs (dm-4): warning: checktime reached, running e2fsck is recommended
[   27.839925] EXT4-fs (dm-4): mounted filesystem with ordered data mode. Opts: (null)
[   27.934080] r8169 0000:04:00.0: eth0: link up
[   27.935767] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   28.117084] NET: Registered protocol family 17
[   28.817126] EXT4-fs (dm-5): warning: maximal mount count reached, running e2fsck is recommended
[   28.826192] EXT4-fs (dm-5): mounted filesystem with ordered data mode. Opts: (null)
[   29.821439] EXT4-fs (dm-6): warning: checktime reached, running e2fsck is recommended
[   29.836900] EXT4-fs (dm-6): mounted filesystem with ordered data mode. Opts: (null)
[   38.016203] eth0: no IPv6 routers present
[  642.499888] r8169 0000:04:00.0: eth0: link down
[  642.499973] r8169 0000:04:00.0: eth0: link down
[  642.502639] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  644.514714] r8169 0000:04:00.0: eth0: link up
[  644.517975] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  655.112217] eth0: no IPv6 routers present
[ 1563.389204] fuse init (API version 7.17)
[ 2135.373087] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[ 2135.374736] SGI XFS Quota Management subsystem
[ 2135.377437] XFS (dm-10): Mounting Filesystem
[ 2135.608359] XFS (dm-10): Ending clean mount
[ 2365.648087]  sdj: unknown partition table
[ 2366.476379]  sdk: unknown partition table
[ 2963.238593] XFS (dm-8): Mounting Filesystem
[ 2963.455039] XFS (dm-8): Ending clean mount
[ 2968.052689] XFS (dm-9): Mounting Filesystem
[ 2968.301421] XFS (dm-9): Ending clean mount
[ 3088.876348] XFS (dm-11): Mounting Filesystem
[ 3089.119528] XFS (dm-11): Ending clean mount
[ 3158.265254] XFS (dm-12): Mounting Filesystem
[ 3158.428696] XFS (dm-12): Ending clean mount
[ 3365.384727] irq 19: nobody cared (try booting with the "irqpoll" option)
[ 3365.384768] Pid: 5148, comm: mount.ntfs Not tainted 3.2.7-jng4-default #1
[ 3365.384790] Call Trace:
[ 3365.384834]  [<ffffffff810039ce>] dump_trace+0x89/0x1ee
[ 3365.384867]  [<ffffffff813b4153>] dump_stack+0x69/0x6f
[ 3365.384910]  [<ffffffff81094a02>] __report_bad_irq+0x2c/0xb5
[ 3365.384951]  [<ffffffff81094c09>] note_interrupt+0xf4/0x16f
[ 3365.384993]  [<ffffffff81093013>] handle_irq_event_percpu+0x14a/0x192
[ 3365.385036]  [<ffffffff8109308f>] handle_irq_event+0x34/0x55
[ 3365.385076]  [<ffffffff8109533c>] handle_fasteoi_irq+0x7c/0x9e
[ 3365.385113]  [<ffffffff810037fd>] handle_irq+0x1d/0x21
[ 3365.385149]  [<ffffffff8100352d>] do_IRQ+0x42/0x98
[ 3365.385187]  [<ffffffff813c9b6e>] common_interrupt+0x6e/0x6e
[ 3365.385231]  [<ffffffff81120406>] set_bh_page+0x7/0x47
[ 3365.385269]  [<ffffffff811206ab>] alloc_page_buffers+0x60/0xbb
[ 3365.385308]  [<ffffffff8112071a>] create_empty_buffers+0x14/0x99
[ 3365.385349]  [<ffffffff81122a7e>] block_read_full_page+0x48/0x1ed
[ 3365.385390]  [<ffffffff810c0e9b>] read_pages+0xa0/0xce
[ 3365.385431]  [<ffffffff810c0fcb>] __do_page_cache_readahead+0x102/0x123
[ 3365.385472]  [<ffffffff810c1244>] ra_submit+0x19/0x1d
[ 3365.385510]  [<ffffffff810b942d>] do_generic_file_read.constprop.32+0xf4/0x3c6
[ 3365.385565]  [<ffffffff810ba027>] generic_file_aio_read+0x1ba/0x204
[ 3365.385608]  [<ffffffff810fd576>] do_sync_read+0xab/0xe3
[ 3365.385647]  [<ffffffff810fdc5c>] vfs_read+0x9f/0xe6
[ 3365.385684]  [<ffffffff810fddcc>] sys_pread64+0x53/0x6e
[ 3365.385722]  [<ffffffff813cf952>] system_call_fastpath+0x16/0x1b
[ 3365.385796]  [<00007fc542a30633>] 0x7fc542a30632
[ 3365.385822] handlers:
[ 3365.385849] [<ffffffff812c0d2c>] ahci_interrupt
[ 3365.385886] [<ffffffffa010591c>] sil_interrupt
[ 3365.385915] Disabling IRQ #19
[ 3847.850102] i2c /dev entries driver
[ 3866.466751] w83627ehf: Found NCT6776F chip at 0x290
[ 3866.467068] hwmon_vid: Unknown VRM version of your x86 CPU
[ 4148.236208] XFS (dm-13): Mounting Filesystem
[ 4151.836443] XFS (dm-13): Ending clean mount
[ 4176.452201] XFS (dm-14): Mounting Filesystem
[ 4179.953000] XFS (dm-14): Ending clean mount
[ 4207.864153] XFS (dm-15): Mounting Filesystem
[ 4211.064436] XFS (dm-15): Ending clean mount
[ 4234.564251] XFS (dm-16): Mounting Filesystem
[ 4238.068342] XFS (dm-16): Ending clean mount
[48968.064167] irq 16: nobody cared (try booting with the "irqpoll" option)
[48968.064199] Pid: 0, comm: swapper/1 Not tainted 3.2.7-jng4-default #1
[48968.064218] Call Trace:
[48968.064251]  [<ffffffff810039ce>] dump_trace+0x89/0x1ee
[48968.064276]  [<ffffffff813b4153>] dump_stack+0x69/0x6f
[48968.064300]  [<ffffffff81094a02>] __report_bad_irq+0x2c/0xb5
[48968.064324]  [<ffffffff81094c09>] note_interrupt+0xf4/0x16f
[48968.064348]  [<ffffffff81093013>] handle_irq_event_percpu+0x14a/0x192
[48968.064372]  [<ffffffff8109308f>] handle_irq_event+0x34/0x55
[48968.064395]  [<ffffffff8109533c>] handle_fasteoi_irq+0x7c/0x9e
[48968.064417]  [<ffffffff810037fd>] handle_irq+0x1d/0x21
[48968.064438]  [<ffffffff8100352d>] do_IRQ+0x42/0x98
[48968.064460]  [<ffffffff813c9b6e>] common_interrupt+0x6e/0x6e
[48968.064507]  [<ffffffffa00f997c>] arch_local_irq_enable+0x4/0x8 [processor]
[48968.064544]  [<ffffffffa00fa7dc>] acpi_idle_enter_simple+0xc6/0x102 [processor]
[48968.064584]  [<ffffffff812df4b8>] cpuidle_idle_call+0xd6/0x171
[48968.064609]  [<ffffffff81001205>] cpu_idle+0x56/0x9a
[48968.064628] handlers:
[48968.064646] [<ffffffffa0142e3c>] mv_interrupt
[48968.064666] [<ffffffffa01f7148>] azx_interrupt
[48968.064687] [<ffffffffa024bb45>] irq_handler
[48968.064704] Disabling IRQ #16
00:00.0 Host bridge: Advanced Micro Devices [AMD] Family 14h Processor Root Complex
00:01.0 VGA compatible controller: ATI Technologies Inc Wrestler [Radeon HD 6310]
00:01.1 Audio device: ATI Technologies Inc Wrestler HDMI Audio [Radeon HD 6250/6310]
00:04.0 PCI bridge: Advanced Micro Devices [AMD] Family 14h Processor Root Port
00:11.0 SATA controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode] (rev 40)
00:12.0 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
00:12.2 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB EHCI Controller
00:13.0 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
00:13.2 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB EHCI Controller
00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 42)
00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA) (rev 40)
00:14.3 ISA bridge: ATI Technologies Inc SB7x0/SB8x0/SB9x0 LPC host controller (rev 40)
00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge (rev 40)
00:14.5 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI2 Controller
00:15.0 PCI bridge: ATI Technologies Inc SB700/SB800/SB900 PCI to PCI bridge (PCIE port 0)
00:15.1 PCI bridge: ATI Technologies Inc SB700/SB800/SB900 PCI to PCI bridge (PCIE port 1)
00:15.2 PCI bridge: ATI Technologies Inc SB900 PCI to PCI bridge (PCIE port 2)
00:16.0 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
00:16.2 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB EHCI Controller
00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 0 (rev 43)
00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 1
00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 2
00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 3
00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 4
00:18.5 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 6
00:18.6 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 5
00:18.7 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 7
03:00.0 SCSI storage controller: Marvell Technology Group Ltd. 88SX7042 PCI-e 4-port SATA-II (rev 02)
04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 06)
05:00.0 PCI bridge: ASMedia Technology Inc. ASM108x PCIe to PCI Bridge Controller (rev 01)
06:00.0 RAID bus controller: Silicon Image, Inc. SiI 3114 [SATALink/SATARaid] Serial ATA Controller (rev 02)
06:01.0 RAID bus controller: Silicon Image, Inc. SiI 3114 [SATALink/SATARaid] Serial ATA Controller (rev 02)
06:02.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306/7/8 [Fire II(M)] IEEE 1394 OHCI Controller (rev c0)
           CPU0       CPU1       
  0:         46        227   IO-APIC-edge      timer
  1:          1        404   IO-APIC-edge      i8042
  5:          0          0   IO-APIC-edge      parport0
  8:          0          1   IO-APIC-edge      rtc0
  9:          0          0   IO-APIC-fasteoi   acpi
 16:       4200    4095808   IO-APIC-fasteoi   sata_mv, snd_hda_intel, firewire_ohci
 17:          0          0   IO-APIC-fasteoi   ehci_hcd:usb1, ehci_hcd:usb2, ehci_hcd:usb3
 18:         78      36910   IO-APIC-fasteoi   ohci_hcd:usb4, ohci_hcd:usb5, ohci_hcd:usb6, ohci_hcd:usb7, sata_sil
 19:        295     201993   IO-APIC-fasteoi   ahci, sata_sil
 40:      11733    4581036   PCI-MSI-edge      eth0
 41:          0         30   PCI-MSI-edge      snd_hda_intel
NMI:       2914       3055   Non-maskable interrupts
LOC:   10736422   11800673   Local timer interrupts
SPU:          0          0   Spurious interrupts
PMI:       2914       3055   Performance monitoring interrupts
IWI:          0          0   IRQ work interrupts
RES:   68010096    4713984   Rescheduling interrupts
CAL:    3246146       2450   Function call interrupts
TLB:       1519       1582   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
MCE:          0          0   Machine check exceptions
MCP:        229        229   Machine check polls
ERR:          0
MIS:          0
# dmidecode 2.11
SMBIOS 2.6 present.
60 structures occupying 2106 bytes.
Table at 0x000EAD90.

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: System manufacturer
	Product Name: System Product Name
	Version: System Version
	Serial Number: System Serial Number
	UUID: 1E007EC0-008C-4300-24C1-F46D04D89D4E
	Wake-up Type: Power Switch
	SKU Number: To be filled by O.E.M.
	Family: To be filled by O.E.M.

Handle 0x0002, DMI type 2, 15 bytes
Base Board Information
	Manufacturer: ASUSTeK Computer INC.
	Product Name: E35M1-M
	Version: Rev X.0x
	Serial Number: MT7014040901146
	Asset Tag: To be filled by O.E.M.
	Features:
		Board is a hosting board
		Board is replaceable
	Location In Chassis: To be filled by O.E.M.
	Chassis Handle: 0x0003
	Type: Motherboard
	Contained Object Handles: 0

Handle 0x0003, DMI type 3, 21 bytes
Chassis Information
	Manufacturer: Chassis Manufacture
	Type: Desktop
	Lock: Not Present
	Version: Chassis Version
	Serial Number: Chassis Serial Number
	Asset Tag: Asset-1234567890
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: None
	OEM Information: 0x00000000
	Height: Unspecified
	Number Of Power Cords: 1
	Contained Elements: 0

Handle 0x0004, DMI type 4, 42 bytes
Processor Information
	Socket Designation: CPU 1
	Type: Central Processor
	Family: E-Series
	Manufacturer: AMD E-350 Process
	ID: 10 0F 50 00 FF FB 8B 17
	Signature: Family 20, Model 1, Stepping 0
	Flags:
		FPU (Floating-point unit on-chip)
		VME (Virtual mode extension)
		DE (Debugging extension)
		PSE (Page size extension)
		TSC (Time stamp counter)
		MSR (Model specific registers)
		PAE (Physical address extension)
		MCE (Machine check exception)
		CX8 (CMPXCHG8 instruction supported)
		APIC (On-chip APIC hardware supported)
		SEP (Fast system call)
		MTRR (Memory type range registers)
		PGE (Page global enable)
		MCA (Machine check architecture)
		CMOV (Conditional move instruction supported)
		PAT (Page attribute table)
		PSE-36 (36-bit page size extension)
		CLFSH (CLFLUSH instruction supported)
		MMX (MMX technology supported)
		FXSR (FXSAVE and FXSTOR instructions supported)
		SSE (Streaming SIMD extensions)
		SSE2 (Streaming SIMD extensions 2)
		HTT (Multi-threading)
	Version: AMD E-350 Processor                            
	Voltage: 1.3 V
	External Clock: 100 MHz
	Max Speed: 1600 MHz
	Current Speed: 1600 MHz
	Status: Populated, Enabled
	Upgrade: None
	L1 Cache Handle: 0x0005
	L2 Cache Handle: 0x0006
	L3 Cache Handle: Not Provided
	Serial Number: To Be Filled By O.E.M.
	Asset Tag: To Be Filled By O.E.M.
	Part Number: To Be Filled By O.E.M.
	Core Count: 2
	Core Enabled: 2
	Characteristics:
		64-bit capable

Handle 0x0005, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L1-Cache
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 128 kB
	Maximum Size: 128 kB
	Supported SRAM Types:
		Unknown
	Installed SRAM Type: Unknown
	Speed: Unknown
	Error Correction Type: None
	System Type: Unified
	Associativity: 2-way Set-associative

Handle 0x0006, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L2-Cache
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Varies With Memory Address
	Location: Internal
	Installed Size: 1024 kB
	Maximum Size: 1024 kB
	Supported SRAM Types:
		Unknown
	Installed SRAM Type: Unknown
	Speed: Unknown
	Error Correction Type: None
	System Type: Data
	Associativity: 16-way Set-associative

Handle 0x0007, DMI type 126, 19 bytes
Inactive

Handle 0x0008, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: PS/2 Keyboard/Mouse
	Internal Connector Type: None
	External Reference Designator: PS/2 Keyboard/Mouse
	External Connector Type: PS/2
	Port Type: Keyboard Port

Handle 0x0009, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB56
	Internal Connector Type: None
	External Reference Designator: USB56
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x000A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: HDMI
	Internal Connector Type: None
	External Reference Designator: HDMI port
	External Connector Type: Other
	Port Type: Other

Handle 0x000B, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SPDIFO
	Internal Connector Type: None
	External Reference Designator: SPDIFO
	External Connector Type: Other
	Port Type: Other

Handle 0x000C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: VGA
	Internal Connector Type: None
	External Reference Designator: VGA port
	External Connector Type: Other
	Port Type: Other

Handle 0x000D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: DVI
	Internal Connector Type: None
	External Reference Designator: DVI port
	External Connector Type: Other
	Port Type: Other

Handle 0x000E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB34
	Internal Connector Type: None
	External Reference Designator: USB34
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x000F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: 1394
	Internal Connector Type: None
	External Reference Designator: 1394
	External Connector Type: IEEE 1394
	Port Type: Firewire (IEEE P1394)

Handle 0x0010, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: ESATA
	Internal Connector Type: None
	External Reference Designator: ESATA
	External Connector Type: SAS/SATA Plug Receptacle
	Port Type: SATA

Handle 0x0011, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: LAN
	Internal Connector Type: None
	External Reference Designator: LAN
	External Connector Type: RJ-45
	Port Type: Network Port

Handle 0x0012, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB12
	Internal Connector Type: None
	External Reference Designator: USB12
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0013, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Audio_Line_In
	Internal Connector Type: None
	External Reference Designator: Audio_Line_In
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0014, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Audio_Line_Out
	Internal Connector Type: None
	External Reference Designator: Audio_Line_Out
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0015, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Audio_Mic_In
	Internal Connector Type: None
	External Reference Designator: Audio_Mic_In
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0016, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA6G_1
	Internal Connector Type: SAS/SATA Plug Receptacle
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: SATA

Handle 0x0017, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA6G_2
	Internal Connector Type: SAS/SATA Plug Receptacle
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: SATA

Handle 0x0018, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA6G_3
	Internal Connector Type: SAS/SATA Plug Receptacle
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: SATA

Handle 0x0019, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA6G_4
	Internal Connector Type: SAS/SATA Plug Receptacle
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: SATA

Handle 0x001A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA6G_5
	Internal Connector Type: SAS/SATA Plug Receptacle
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: SATA

Handle 0x001B, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB78
	Internal Connector Type: Access Bus (USB)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: USB

Handle 0x001C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB910
	Internal Connector Type: Access Bus (USB)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: USB

Handle 0x001D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB1112
	Internal Connector Type: Access Bus (USB)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: USB

Handle 0x001E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB1314
	Internal Connector Type: Access Bus (USB)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: USB

Handle 0x001F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: AAFP
	Internal Connector Type: Mini Jack (headphones)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Audio Port

Handle 0x0020, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CPU_FAN
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0021, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CHA_FAN1
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0022, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: COM1
	Internal Connector Type: DB-9 male
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Serial Port 16550A Compatible

Handle 0x0023, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: LPT
	Internal Connector Type: DB-9 male
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Serial Port 16550A Compatible

Handle 0x0024, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: IE1394_1
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0025, DMI type 9, 17 bytes
System Slot Information
	Designation: PCIEX16
	Type: 32-bit PCI Express
	Current Usage: In Use
	Length: Short
	ID: 1
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported
	Bus Address: 0000:00:01.0

Handle 0x0026, DMI type 9, 17 bytes
System Slot Information
	Designation: PCIEX1_1
	Type: 32-bit PCI Express
	Current Usage: In Use
	Length: Short
	ID: 2
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported
	Bus Address: 0000:00:01.1

Handle 0x0027, DMI type 9, 17 bytes
System Slot Information
	Designation: PCI1
	Type: 32-bit PCI
	Current Usage: In Use
	Length: Short
	ID: 3
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported
	Bus Address: 0000:00:1c.6

Handle 0x0028, DMI type 9, 17 bytes
System Slot Information
	Designation: PCI2
	Type: 32-bit PCI
	Current Usage: In Use
	Length: Short
	ID: 4
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported
	Bus Address: 0000:00:1c.7

Handle 0x0029, DMI type 10, 6 bytes
On Board Device Information
	Type: Video
	Status: Enabled
	Description:    To Be Filled By O.E.M.

Handle 0x002A, DMI type 10, 6 bytes
On Board Device Information
	Type: Ethernet
	Status: Enabled
	Description: To Be Filled By O.E.M.

Handle 0x002B, DMI type 10, 6 bytes
On Board Device Information
	Type: Sound
	Status: Enabled
	Description:    To Be Filled By O.E.M.

Handle 0x002C, DMI type 10, 6 bytes
On Board Device Information
	Type: Other
	Status: Enabled
	Description:    Onboard 1394

Handle 0x002D, DMI type 11, 5 bytes
OEM Strings
	String 1: F46D04D89D4E

Handle 0x002E, DMI type 12, 5 bytes
System Configuration Options
	Option 1: To Be Filled By O.E.M.

Handle 0x002F, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 8 GB
	Error Information Handle: Not Provided
	Number Of Devices: 2

Handle 0x0030, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x001FFFFFFFF
	Range Size: 8 GB
	Physical Array Handle: 0x002F
	Partition Width: 255

Handle 0x0033, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x002F
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM_A1
	Bank Locator: A1_BANK0
	Type: DDR3
	Type Detail: Synchronous
	Speed: 1333 MHz
	Manufacturer: Undefined       
	Serial Number: 00000000  
	Asset Tag: A1_AssetTagNum0
	Part Number: F3-10666CL9-4GBNT 
	Rank: 2

Handle 0x0034, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000FFFFFFFF
	Range Size: 4 GB
	Physical Device Handle: 0x0033
	Memory Array Mapped Address Handle: 0x0030
	Partition Row Position: 1

Handle 0x0035, DMI type 32, 20 bytes
System Boot Information
	Status: No errors detected

Handle 0x0036, DMI type 41, 11 bytes
Onboard Device
	Reference Designation:  Onboard IGD
	Type: Video
	Status: Enabled
	Type Instance: 1
	Bus Address: 0000:00:02.0

Handle 0x0037, DMI type 41, 11 bytes
Onboard Device
	Reference Designation:  Onboard LAN
	Type: Ethernet
	Status: Enabled
	Type Instance: 1
	Bus Address: 0000:00:19.0

Handle 0x0038, DMI type 41, 11 bytes
Onboard Device
	Reference Designation:  Onboard 1394
	Type: Other
	Status: Enabled
	Type Instance: 1
	Bus Address: 0000:03:1c.2

Handle 0x0039, DMI type 139, 54 bytes
OEM-specific Type
	Header and Data:
		8B 36 39 00 00 1E 8C 00 00 43 24 C1 04 04 32 55
		F8 00 A2 02 A1 00 40 63 43 10 FE 81 03 DF 40 B2
		00 20 00 73 3C 10 08 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 01
	Strings:
		V1394GUID

Handle 0x0031, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x002F
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM_A2
	Bank Locator: A1_BANK1
	Type: DDR3
	Type Detail: Synchronous
	Speed: 1333 MHz
	Manufacturer: Kingston        
	Serial Number: 841A8382  
	Asset Tag: A1_AssetTagNum1
	Part Number: 9905458-026.A00LF 
	Rank: 2

Handle 0x0032, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00100000000
	Ending Address: 0x001FFFFFFFF
	Range Size: 4 GB
	Physical Device Handle: 0x0031
	Memory Array Mapped Address Handle: 0x0030
	Partition Row Position: 1

Handle 0x003A, DMI type 13, 22 bytes
BIOS Language Information
	Language Description Format: Abbreviated
	Installable Languages: 1
		eng
	Currently Installed Language: eng

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: American Megatrends Inc.
	Version: 0401
	Release Date: 02/16/2011
	Address: 0xF0000
	Runtime Size: 64 kB
	ROM Size: 4096 kB
	Characteristics:
		PCI is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		Boot from CD is supported
		Selectable boot is supported
		BIOS ROM is socketed
		EDD is supported
		5.25"/1.2 MB floppy services are supported (int 13h)
		3.5"/720 kB floppy services are supported (int 13h)
		3.5"/2.88 MB floppy services are supported (int 13h)
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		Printer services are supported (int 17h)
		ACPI is supported
		USB legacy is supported
		BIOS boot specification is supported
		Targeted content distribution is supported
	BIOS Revision: 4.6

Handle 0x003B, DMI type 127, 4 bytes
End Of Table

SMBIOS 2.6 present.
60 structures occupying 2106 bytes.
Table at 0x000EAD90.

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: System manufacturer
	Product Name: System Product Name
	Version: System Version
	Serial Number: System Serial Number
	UUID: 1E007EC0-008C-4300-24C1-F46D04D89D4E
	Wake-up Type: Power Switch
	SKU Number: To be filled by O.E.M.
	Family: To be filled by O.E.M.

Handle 0x0002, DMI type 2, 15 bytes
Base Board Information
	Manufacturer: ASUSTeK Computer INC.
	Product Name: E35M1-M
	Version: Rev X.0x
	Serial Number: MT7014040901146
	Asset Tag: To be filled by O.E.M.
	Features:
		Board is a hosting board
		Board is replaceable
	Location In Chassis: To be filled by O.E.M.
	Chassis Handle: 0x0003
	Type: Motherboard
	Contained Object Handles: 0

Handle 0x0003, DMI type 3, 21 bytes
Chassis Information
	Manufacturer: Chassis Manufacture
	Type: Desktop
	Lock: Not Present
	Version: Chassis Version
	Serial Number: Chassis Serial Number
	Asset Tag: Asset-1234567890
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: None
	OEM Information: 0x00000000
	Height: Unspecified
	Number Of Power Cords: 1
	Contained Elements: 0

Handle 0x0004, DMI type 4, 42 bytes
Processor Information
	Socket Designation: CPU 1
	Type: Central Processor
	Family: E-Series
	Manufacturer: AMD E-350 Process
	ID: 10 0F 50 00 FF FB 8B 17
	Signature: Family 20, Model 1, Stepping 0
	Flags:
		FPU (Floating-point unit on-chip)
		VME (Virtual mode extension)
		DE (Debugging extension)
		PSE (Page size extension)
		TSC (Time stamp counter)
		MSR (Model specific registers)
		PAE (Physical address extension)
		MCE (Machine check exception)
		CX8 (CMPXCHG8 instruction supported)
		APIC (On-chip APIC hardware supported)
		SEP (Fast system call)
		MTRR (Memory type range registers)
		PGE (Page global enable)
		MCA (Machine check architecture)
		CMOV (Conditional move instruction supported)
		PAT (Page attribute table)
		PSE-36 (36-bit page size extension)
		CLFSH (CLFLUSH instruction supported)
		MMX (MMX technology supported)
		FXSR (FXSAVE and FXSTOR instructions supported)
		SSE (Streaming SIMD extensions)
		SSE2 (Streaming SIMD extensions 2)
		HTT (Multi-threading)
	Version: AMD E-350 Processor                            
	Voltage: 1.3 V
	External Clock: 100 MHz
	Max Speed: 1600 MHz
	Current Speed: 1600 MHz
	Status: Populated, Enabled
	Upgrade: None
	L1 Cache Handle: 0x0005
	L2 Cache Handle: 0x0006
	L3 Cache Handle: Not Provided
	Serial Number: To Be Filled By O.E.M.
	Asset Tag: To Be Filled By O.E.M.
	Part Number: To Be Filled By O.E.M.
	Core Count: 2
	Core Enabled: 2
	Characteristics:
		64-bit capable

Handle 0x0005, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L1-Cache
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 128 kB
	Maximum Size: 128 kB
	Supported SRAM Types:
		Unknown
	Installed SRAM Type: Unknown
	Speed: Unknown
	Error Correction Type: None
	System Type: Unified
	Associativity: 2-way Set-associative

Handle 0x0006, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L2-Cache
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Varies With Memory Address
	Location: Internal
	Installed Size: 1024 kB
	Maximum Size: 1024 kB
	Supported SRAM Types:
		Unknown
	Installed SRAM Type: Unknown
	Speed: Unknown
	Error Correction Type: None
	System Type: Data
	Associativity: 16-way Set-associative

Handle 0x0007, DMI type 126, 19 bytes
Inactive

Handle 0x0008, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: PS/2 Keyboard/Mouse
	Internal Connector Type: None
	External Reference Designator: PS/2 Keyboard/Mouse
	External Connector Type: PS/2
	Port Type: Keyboard Port

Handle 0x0009, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB56
	Internal Connector Type: None
	External Reference Designator: USB56
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x000A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: HDMI
	Internal Connector Type: None
	External Reference Designator: HDMI port
	External Connector Type: Other
	Port Type: Other

Handle 0x000B, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SPDIFO
	Internal Connector Type: None
	External Reference Designator: SPDIFO
	External Connector Type: Other
	Port Type: Other

Handle 0x000C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: VGA
	Internal Connector Type: None
	External Reference Designator: VGA port
	External Connector Type: Other
	Port Type: Other

Handle 0x000D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: DVI
	Internal Connector Type: None
	External Reference Designator: DVI port
	External Connector Type: Other
	Port Type: Other

Handle 0x000E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB34
	Internal Connector Type: None
	External Reference Designator: USB34
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x000F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: 1394
	Internal Connector Type: None
	External Reference Designator: 1394
	External Connector Type: IEEE 1394
	Port Type: Firewire (IEEE P1394)

Handle 0x0010, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: ESATA
	Internal Connector Type: None
	External Reference Designator: ESATA
	External Connector Type: SAS/SATA Plug Receptacle
	Port Type: SATA

Handle 0x0011, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: LAN
	Internal Connector Type: None
	External Reference Designator: LAN
	External Connector Type: RJ-45
	Port Type: Network Port

Handle 0x0012, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB12
	Internal Connector Type: None
	External Reference Designator: USB12
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0013, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Audio_Line_In
	Internal Connector Type: None
	External Reference Designator: Audio_Line_In
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0014, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Audio_Line_Out
	Internal Connector Type: None
	External Reference Designator: Audio_Line_Out
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0015, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Audio_Mic_In
	Internal Connector Type: None
	External Reference Designator: Audio_Mic_In
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0016, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA6G_1
	Internal Connector Type: SAS/SATA Plug Receptacle
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: SATA

Handle 0x0017, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA6G_2
	Internal Connector Type: SAS/SATA Plug Receptacle
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: SATA

Handle 0x0018, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA6G_3
	Internal Connector Type: SAS/SATA Plug Receptacle
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: SATA

Handle 0x0019, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA6G_4
	Internal Connector Type: SAS/SATA Plug Receptacle
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: SATA

Handle 0x001A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA6G_5
	Internal Connector Type: SAS/SATA Plug Receptacle
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: SATA

Handle 0x001B, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB78
	Internal Connector Type: Access Bus (USB)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: USB

Handle 0x001C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB910
	Internal Connector Type: Access Bus (USB)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: USB

Handle 0x001D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB1112
	Internal Connector Type: Access Bus (USB)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: USB

Handle 0x001E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB1314
	Internal Connector Type: Access Bus (USB)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: USB

Handle 0x001F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: AAFP
	Internal Connector Type: Mini Jack (headphones)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Audio Port

Handle 0x0020, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CPU_FAN
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0021, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CHA_FAN1
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0022, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: COM1
	Internal Connector Type: DB-9 male
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Serial Port 16550A Compatible

Handle 0x0023, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: LPT
	Internal Connector Type: DB-9 male
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Serial Port 16550A Compatible

Handle 0x0024, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: IE1394_1
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0025, DMI type 9, 17 bytes
System Slot Information
	Designation: PCIEX16
	Type: 32-bit PCI Express
	Current Usage: In Use
	Length: Short
	ID: 1
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported
	Bus Address: 0000:00:01.0

Handle 0x0026, DMI type 9, 17 bytes
System Slot Information
	Designation: PCIEX1_1
	Type: 32-bit PCI Express
	Current Usage: In Use
	Length: Short
	ID: 2
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported
	Bus Address: 0000:00:01.1

Handle 0x0027, DMI type 9, 17 bytes
System Slot Information
	Designation: PCI1
	Type: 32-bit PCI
	Current Usage: In Use
	Length: Short
	ID: 3
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported
	Bus Address: 0000:00:1c.6

Handle 0x0028, DMI type 9, 17 bytes
System Slot Information
	Designation: PCI2
	Type: 32-bit PCI
	Current Usage: In Use
	Length: Short
	ID: 4
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported
	Bus Address: 0000:00:1c.7

Handle 0x0029, DMI type 10, 6 bytes
On Board Device Information
	Type: Video
	Status: Enabled
	Description:    To Be Filled By O.E.M.

Handle 0x002A, DMI type 10, 6 bytes
On Board Device Information
	Type: Ethernet
	Status: Enabled
	Description: To Be Filled By O.E.M.

Handle 0x002B, DMI type 10, 6 bytes
On Board Device Information
	Type: Sound
	Status: Enabled
	Description:    To Be Filled By O.E.M.

Handle 0x002C, DMI type 10, 6 bytes
On Board Device Information
	Type: Other
	Status: Enabled
	Description:    Onboard 1394

Handle 0x002D, DMI type 11, 5 bytes
OEM Strings
	String 1: F46D04D89D4E

Handle 0x002E, DMI type 12, 5 bytes
System Configuration Options
	Option 1: To Be Filled By O.E.M.

Handle 0x002F, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 8 GB
	Error Information Handle: Not Provided
	Number Of Devices: 2

Handle 0x0030, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x001FFFFFFFF
	Range Size: 8 GB
	Physical Array Handle: 0x002F
	Partition Width: 255

Handle 0x0033, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x002F
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM_A1
	Bank Locator: A1_BANK0
	Type: DDR3
	Type Detail: Synchronous
	Speed: 1333 MHz
	Manufacturer: Undefined       
	Serial Number: 00000000  
	Asset Tag: A1_AssetTagNum0
	Part Number: F3-10666CL9-4GBNT 
	Rank: 2

Handle 0x0034, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000FFFFFFFF
	Range Size: 4 GB
	Physical Device Handle: 0x0033
	Memory Array Mapped Address Handle: 0x0030
	Partition Row Position: 1

Handle 0x0035, DMI type 32, 20 bytes
System Boot Information
	Status: No errors detected

Handle 0x0036, DMI type 41, 11 bytes
Onboard Device
	Reference Designation:  Onboard IGD
	Type: Video
	Status: Enabled
	Type Instance: 1
	Bus Address: 0000:00:02.0

Handle 0x0037, DMI type 41, 11 bytes
Onboard Device
	Reference Designation:  Onboard LAN
	Type: Ethernet
	Status: Enabled
	Type Instance: 1
	Bus Address: 0000:00:19.0

Handle 0x0038, DMI type 41, 11 bytes
Onboard Device
	Reference Designation:  Onboard 1394
	Type: Other
	Status: Enabled
	Type Instance: 1
	Bus Address: 0000:03:1c.2

Handle 0x0039, DMI type 139, 54 bytes
OEM-specific Type
	Header and Data:
		8B 36 39 00 00 1E 8C 00 00 43 24 C1 04 04 32 55
		F8 00 A2 02 A1 00 40 63 43 10 FE 81 03 DF 40 B2
		00 20 00 73 3C 10 08 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 01
	Strings:
		V1394GUID

Handle 0x0031, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x002F
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM_A2
	Bank Locator: A1_BANK1
	Type: DDR3
	Type Detail: Synchronous
	Speed: 1333 MHz
	Manufacturer: Kingston        
	Serial Number: 841A8382  
	Asset Tag: A1_AssetTagNum1
	Part Number: 9905458-026.A00LF 
	Rank: 2

Handle 0x0032, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00100000000
	Ending Address: 0x001FFFFFFFF
	Range Size: 4 GB
	Physical Device Handle: 0x0031
	Memory Array Mapped Address Handle: 0x0030
	Partition Row Position: 1

Handle 0x003A, DMI type 13, 22 bytes
BIOS Language Information
	Language Description Format: Abbreviated
	Installable Languages: 1
		eng
	Currently Installed Language: eng

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: American Megatrends Inc.
	Version: 0401
	Release Date: 02/16/2011
	Address: 0xF0000
	Runtime Size: 64 kB
	ROM Size: 4096 kB
	Characteristics:
		PCI is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		Boot from CD is supported
		Selectable boot is supported
		BIOS ROM is socketed
		EDD is supported
		5.25"/1.2 MB floppy services are supported (int 13h)
		3.5"/720 kB floppy services are supported (int 13h)
		3.5"/2.88 MB floppy services are supported (int 13h)
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		Printer services are supported (int 17h)
		ACPI is supported
		USB legacy is supported
		BIOS boot specification is supported
		Targeted content distribution is supported
	BIOS Revision: 4.6

Handle 0x003B, DMI type 127, 4 bytes
End Of Table

