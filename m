Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418Ab1DMTzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 15:55:09 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53326 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758349Ab1DMTzG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 15:55:06 -0400
MIME-Version: 1.0
From: Joost Pjotr Vermeer <jp@df5ea.net>
Date: Wed, 13 Apr 2011 21:54:45 +0200
Message-ID: <BANLkTikq34nGQU=1U4uvrSu_mRPf-UjLRg@mail.gmail.com>
Subject: backlight control broken on Sony VGN-P21Z with staging/gma500
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: jp@df5ea.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tried the new gma500 driver from staging on my Sony VGN-P21Z. It
seems to work very nice.

But backlight control does not work. It has worked with a previous
version of the staging/gma500 driver. I can solve it by removing the
call to acpi_video_register() from psb_driver_load() in psb_drv.c.

Can I try anything to find a more specific cause for this?

   — Joost

--------- dmesg
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.39-rc3psb23 (jp@violet) (gcc version
4.4.5 (Debian 4.4.5-8) ) #1 SMP Tue Apr 12 19:26:35 CEST 2011
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f64d000 (usable)
[    0.000000]  BIOS-e820: 000000007f64d000 - 000000007f64e000 (reserved)
[    0.000000]  BIOS-e820: 000000007f64e000 - 000000007f656000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007f656000 - 000000007f69f000 (reserved)
[    0.000000]  BIOS-e820: 000000007f69f000 - 000000007f6a2000 (usable)
[    0.000000]  BIOS-e820: 000000007f6a2000 - 000000007f6df000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007f6df000 - 000000007f6ef000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007f6ef000 - 000000007f6f0000 (usable)
[    0.000000]  BIOS-e820: 000000007f6f0000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed40000 - 00000000fed4c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection cannot be
enabled: non-PAE kernel!
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Sony Corporation VGN-P21Z_W/VAIO, BIOS R2071U3 09/29/2009
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000
(usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x7f6f0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-DFFFF uncachable
[    0.000000]   E0000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 disabled
[    0.000000]   1 base 000000000 mask 080000000 write-back
[    0.000000]   2 base 07F800000 mask 0FF800000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 base 07F6F0000 mask 0FFFF0000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 000000007f6f0000 - 000000007f700000
(usable) ==> (reserved)
[    0.000000] initial memory mapped : 0 - 01800000
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 17fb000-1800000
[    0.000000] RAMDISK: 37527000 - 37ff0000
[    0.000000] Allocated new RAMDISK: 36a5e000 - 37526ddd
[    0.000000] Move RAMDISK from 0000000037527000 - 0000000037fefddc
to 36a5e000 - 37526ddc
[    0.000000] ACPI: RSDP 000fe020 00024 (v02   Sony)
[    0.000000] ACPI: XSDT 7f6ee120 00064 (v01   Sony     VAIO 20090929
     01000013)
[    0.000000] ACPI: FACP 7f6ed000 000F4 (v03   Sony     VAIO 20090929
MSFT 01000013)
[    0.000000] ACPI Warning: Invalid length for Pm1aControlBlock: 32,
using default 16 (20110316/tbfadt-610)
[    0.000000] ACPI: DSDT 7f6e2000 05728 (v01   Sony     VAIO 20090929
MSFT 01000013)
[    0.000000] ACPI: FACS 7f6a6000 00040
[    0.000000] ACPI: HPET 7f6ec000 00038 (v01   Sony     VAIO 20090929
MSFT 01000013)
[    0.000000] ACPI: APIC 7f6eb000 00068 (v01   Sony     VAIO 20090929
MSFT 01000013)
[    0.000000] ACPI: MCFG 7f6ea000 0003C (v01   Sony     VAIO 20090929
MSFT 01000013)
[    0.000000] ACPI: SLIC 7f6e9000 00176 (v01   Sony     VAIO 20090929
MSFT 01000013)
[    0.000000] ACPI: ASF! 7f6e8000 000A5 (v32   Sony     VAIO 20090929
MSFT 01000013)
[    0.000000] ACPI: BOOT 7f6e1000 00028 (v01   Sony     VAIO 20090929
MSFT 01000013)
[    0.000000] ACPI: SSDT 7f6df000 004CE (v02   Sony     VAIO 20090929
INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1150MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0007f6f0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007f64d
[    0.000000]     0: 0x0007f69f -> 0x0007f6a2
[    0.000000]     0: 0x0007f6ef -> 0x0007f6f0
[    0.000000] On node 0 totalpages: 521696
[    0.000000] free_area_init_node: node 0, pgdat c13c0140,
node_mem_map f5a6e200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2302 pages used for memmap
[    0.000000]   HighMem zone: 292181 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap:
80000000:60000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32
nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @f5400000 s27200 r0 d21952 u2097152
[    0.000000] pcpu-alloc: s27200 r0 d21952 u2097152 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 517618
[    0.000000] Kernel command line:
BOOT_IMAGE=/vmlinuz-2.6.39-rc3psb23 root=/dev/mapper/violet-root ro
quiet
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000377fe:0007f6f0)
[    0.000000] Memory: 2053608k/2087872k available (2613k kernel code,
33176k reserved, 1252k data, 404k init, 1177932k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd36000 - 0xfffff000   (2852 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc13c7000 - 0xc142c000   ( 404 kB)
[    0.000000]       .data : 0xc128d5b8 - 0xc13c6780   (1252 kB)
[    0.000000]       .text : 0xc1000000 - 0xc128d5b8   (2613 kB)
[    0.000000] Checking if this processor honours the WP bit even in
supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0,
CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] NR_IRQS:1280
[    0.000000] CPU 0 irqstacks, hard=f500e000 soft=f5020000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1333.209 MHz processor.
[    0.004010] Calibrating delay loop (skipped), value calculated
using timer frequency.. 2666.41 BogoMIPS (lpj=5332836)
[    0.004030] pid_max: default: 32768 minimum: 301
[    0.004408] Security Framework initialized
[    0.004422] SELinux:  Disabled at boot.
[    0.004549] Mount-cache hash table entries: 512
[    0.005769] Initializing cgroup subsys ns
[    0.005783] ns_cgroup deprecated: consider using the
'clone_children' flag without the ns_cgroup.
[    0.005795] Initializing cgroup subsys cpuacct
[    0.005903] Initializing cgroup subsys devices
[    0.005914] Initializing cgroup subsys freezer
[    0.005923] Initializing cgroup subsys net_cls
[    0.006079] CPU: Physical Processor ID: 0
[    0.006088] CPU: Processor Core ID: 0
[    0.006098] mce: CPU supports 5 MCE banks
[    0.006127] CPU0: Thermal monitoring enabled (TM2)
[    0.006140] using mwait in idle threads.
[    0.012569] ACPI: Core revision 20110316
[    0.028155] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.028506] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.068479] CPU0: Intel(R) Atom(TM) CPU Z520   @ 1.33GHz stepping 02
[    0.072003] Performance Events: PEBS fmt0+, Atom events, Intel PMU driver.
[    0.072003] ... version:                3
[    0.072003] ... bit width:              40
[    0.072003] ... generic registers:      2
[    0.072003] ... value mask:             000000ffffffffff
[    0.072003] ... max period:             000000007fffffff
[    0.072003] ... fixed-purpose events:   3
[    0.072003] ... event mask:             0000000700000003
[    0.072003] CPU 1 irqstacks, hard=f508a000 soft=f508c000
[    0.072003] Booting Node   0, Processors  #1 Ok.
[    0.072003] smpboot cpu 1: start_ip = 9b000
[    0.008000] Initializing CPU#1
[    0.160040] Brought up 2 CPUs
[    0.160051] Total of 2 processors activated (5332.93 BogoMIPS).
[    0.160608] devtmpfs: initialized
[    0.160762] PM: Registering ACPI NVS region at 7f64e000 (32768 bytes)
[    0.160762] PM: Registering ACPI NVS region at 7f6a2000 (249856 bytes)
[    0.160762] print_constraints: dummy:
[    0.160762] NET: Registered protocol family 16
[    0.160970] ACPI FADT declares the system doesn't support PCIe
ASPM, so disable it
[    0.160978] ACPI: bus type pci registered
[    0.161318] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.161329] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.161335] PCI: Using MMCONFIG for extended config space
[    0.161340] PCI: Using configuration type 1 for base access
[    0.164169] bio: create slab <bio-0> at 0
[    0.166894] ACPI: EC: Look up EC in DSDT
[    0.170057] ACPI: Executed 1 blocks of module-level executable AML code
[    0.187547] ACPI: SSDT 7f658c90 001F7 (v02   Sony     VAIO 20090929
INTL 20051117)
[    0.188262] ACPI: Dynamic OEM Table Load:
[    0.188272] ACPI: SSDT   (null) 001F7 (v02   Sony     VAIO 20090929
INTL 20051117)
[    0.188708] ACPI: SSDT 7f657690 0061C (v02   Sony     VAIO 20090929
INTL 20051117)
[    0.189354] ACPI: Dynamic OEM Table Load:
[    0.189363] ACPI: SSDT   (null) 0061C (v02   Sony     VAIO 20090929
INTL 20051117)
[    0.212752] ACPI: SSDT 7f658f10 000D0 (v02   Sony     VAIO 20090929
INTL 20051117)
[    0.213424] ACPI: Dynamic OEM Table Load:
[    0.213433] ACPI: SSDT   (null) 000D0 (v02   Sony     VAIO 20090929
INTL 20051117)
[    0.213698] ACPI: SSDT 7f656f10 00083 (v02   Sony     VAIO 20090929
INTL 20051117)
[    0.214346] ACPI: Dynamic OEM Table Load:
[    0.214355] ACPI: SSDT   (null) 00083 (v02   Sony     VAIO 20090929
INTL 20051117)
[    0.236663] ACPI: Interpreter enabled
[    0.236677] ACPI: (supports S0 S3 S4 S5)
[    0.236734] ACPI: Using IOAPIC for interrupt routing
[    0.246139] ACPI: EC: GPE = 0xd, I/O: command/status = 0x66, data = 0x62
[    0.246471] ACPI: No dock devices found.
[    0.246482] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    0.246993] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.247876] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.247887] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.247895] pci_root PNP0A08:00: host bridge window [mem
0x000a0000-0x000bffff]
[    0.247904] pci_root PNP0A08:00: host bridge window [mem
0x7f800000-0x7fffffff]
[    0.247912] pci_root PNP0A08:00: host bridge window [mem
0x000c0000-0x000dffff]
[    0.247921] pci_root PNP0A08:00: host bridge window [mem
0x000e0000-0x000effff]
[    0.247931] pci_root PNP0A08:00: host bridge window [mem
0x000f0000-0x000fffff]
[    0.247942] pci_root PNP0A08:00: host bridge window [mem
0x80000000-0xfebfffff]
[    0.247978] pci 0000:00:00.0: [8086:8100] type 0 class 0x000600
[    0.248083] pci 0000:00:02.0: [8086:8108] type 0 class 0x000300
[    0.248114] pci 0000:00:02.0: reg 10: [mem 0x94200000-0x9427ffff]
[    0.248130] pci 0000:00:02.0: reg 14: [io  0x6070-0x6077]
[    0.248147] pci 0000:00:02.0: reg 18: [mem 0x80000000-0x8fffffff]
[    0.248163] pci 0000:00:02.0: reg 1c: [mem 0x94280000-0x942bffff]
[    0.248287] pci 0000:00:1b.0: [8086:811b] type 0 class 0x000403
[    0.248313] pci 0000:00:1b.0: reg 10: [mem 0x942c0000-0x942c3fff 64bit]
[    0.248386] pci 0000:00:1b.0: PME# supported from D0 D3hot
[    0.248396] pci 0000:00:1b.0: PME# disabled
[    0.248429] pci 0000:00:1c.0: [8086:8110] type 1 class 0x000604
[    0.248502] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.248512] pci 0000:00:1c.0: PME# disabled
[    0.248546] pci 0000:00:1c.1: [8086:8112] type 1 class 0x000604
[    0.248618] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.248627] pci 0000:00:1c.1: PME# disabled
[    0.248666] pci 0000:00:1d.0: [8086:8114] type 0 class 0x000c03
[    0.248714] pci 0000:00:1d.0: reg 20: [io  0x6040-0x605f]
[    0.248760] pci 0000:00:1d.1: [8086:8115] type 0 class 0x000c03
[    0.248813] pci 0000:00:1d.1: reg 20: [io  0x6020-0x603f]
[    0.248860] pci 0000:00:1d.2: [8086:8116] type 0 class 0x000c03
[    0.248912] pci 0000:00:1d.2: reg 20: [io  0x6000-0x601f]
[    0.248975] pci 0000:00:1d.7: [8086:8117] type 0 class 0x000c03
[    0.249010] pci 0000:00:1d.7: reg 10: [mem 0x00000000-0x000003ff]
[    0.249124] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.249135] pci 0000:00:1d.7: PME# disabled
[    0.249167] pci 0000:00:1f.0: [8086:8119] type 0 class 0x000601
[    0.249264] pci 0000:00:1f.1: [8086:811a] type 0 class 0x000101
[    0.249318] pci 0000:00:1f.1: reg 20: [io  0x6060-0x606f]
[    0.249439] pci 0000:01:00.0: [11ab:4380] type 0 class 0x000200
[    0.249474] pci 0000:01:00.0: reg 10: [mem 0x93100000-0x93103fff 64bit]
[    0.249494] pci 0000:01:00.0: reg 18: [io  0x4000-0x40ff]
[    0.249551] pci 0000:01:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    0.249605] pci 0000:01:00.0: supports D1 D2
[    0.249611] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.249621] pci 0000:01:00.0: PME# disabled
[    0.249663] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.249672] pci 0000:00:1c.0:   bridge window [io  0x4000-0x5fff]
[    0.249682] pci 0000:00:1c.0:   bridge window [mem 0x93100000-0x941fffff]
[    0.249693] pci 0000:00:1c.0:   bridge window [mem
0x90000000-0x90ffffff pref]
[    0.249770] pci 0000:02:00.0: [168c:002a] type 0 class 0x000280
[    0.249804] pci 0000:02:00.0: reg 10: [mem 0x92000000-0x9200ffff 64bit]
[    0.249914] pci 0000:02:00.0: supports D1
[    0.249921] pci 0000:02:00.0: PME# supported from D0 D1 D3hot
[    0.249931] pci 0000:02:00.0: PME# disabled
[    0.249975] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.249985] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.249995] pci 0000:00:1c.1:   bridge window [mem 0x92000000-0x930fffff]
[    0.250005] pci 0000:00:1c.1:   bridge window [mem
0x91000000-0x91ffffff pref]
[    0.250025] pci_bus 0000:00: on NUMA node 0
[    0.250035] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.250347] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.250487] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.250682]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.250689] Unable to assume _OSC PCIe control. Disabling ASPM
[    0.256574] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 *7 9 10 11 12)
[    0.256739] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 7 9 10 11 12)
[    0.256900] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
[    0.257060] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 *10 11 12)
[    0.257221] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 *11 12)
[    0.257381] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 *11 12)
[    0.257542] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 10 *11 12)
[    0.257702] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
[    0.257935] vgaarb: device added:
PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.257952] vgaarb: loaded
[    0.258081] PCI: Using ACPI for IRQ routing
[    0.258089] PCI: pci_cache_line_size set to 64 bytes
[    0.258183] reserve RAM buffer: 000000000009fc00 - 000000000009ffff
[    0.258191] reserve RAM buffer: 000000007f64d000 - 000000007fffffff
[    0.258200] reserve RAM buffer: 000000007f6a2000 - 000000007fffffff
[    0.258208] reserve RAM buffer: 000000007f6f0000 - 000000007fffffff
[    0.258539] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.258551] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.258564] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.264085] Switching to clocksource hpet
[    0.267017] pnp: PnP ACPI init
[    0.267059] ACPI: bus type pnp registered
[    0.267787] Switched to NOHz mode on CPU #0
[    0.267854] Switched to NOHz mode on CPU #1
[    0.267969] pnp 00:00: [bus 00-ff]
[    0.267979] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.267986] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.267994] pnp 00:00: [io  0x0d00-0xffff window]
[    0.268002] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.268025] pnp 00:00: [mem 0x7f800000-0x7fffffff window]
[    0.268033] pnp 00:00: [mem 0x000c0000-0x000dffff window]
[    0.268041] pnp 00:00: [mem 0x000e0000-0x000effff window]
[    0.268048] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.268056] pnp 00:00: [mem 0x80000000-0xfebfffff window]
[    0.268198] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08
PNP0a03 (active)
[    0.268443] pnp 00:01: [mem 0xe0000000-0xefffffff]
[    0.268451] pnp 00:01: [mem 0xfed10000-0xfed13fff]
[    0.268459] pnp 00:01: [mem 0x40000000-0x7fffffff]
[    0.268466] pnp 00:01: [mem 0xfec00000-0xfec00fff]
[    0.268473] pnp 00:01: [mem 0xfed40000-0xfed4bfff]
[    0.268480] pnp 00:01: [mem 0xfee00000-0xfee00fff]
[    0.268487] pnp 00:01: [mem 0xffc00000-0xffc3ffff]
[    0.268603] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.268613] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.268622] system 00:01: [mem 0x40000000-0x7fffffff] could not be reserved
[    0.268631] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.268640] system 00:01: [mem 0xfed40000-0xfed4bfff] has been reserved
[    0.268649] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.268658] system 00:01: [mem 0xffc00000-0xffc3ffff] has been reserved
[    0.268668] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.269250] pnp 00:02: Plug and Play ACPI device, IDs SNY6001 (disabled)
[    0.269283] pnp 00:03: [mem 0xff000000-0xffffffff]
[    0.269365] pnp 00:03: Plug and Play ACPI device, IDs INT0800 (active)
[    0.269465] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.269582] system 00:04: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.269593] system 00:04: Plug and Play ACPI device, IDs PNP0103
PNP0c01 (active)
[    0.269633] pnp 00:05: [io  0x0070-0x0077]
[    0.269657] pnp 00:05: [irq 8]
[    0.269743] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.269783] pnp 00:06: [io  0x002e-0x002f]
[    0.269790] pnp 00:06: [io  0x004e-0x004f]
[    0.269797] pnp 00:06: [io  0x0061]
[    0.269803] pnp 00:06: [io  0x0063]
[    0.269809] pnp 00:06: [io  0x0065]
[    0.269815] pnp 00:06: [io  0x0067]
[    0.269822] pnp 00:06: [io  0x0080-0x0083]
[    0.269828] pnp 00:06: [io  0x0092]
[    0.269834] pnp 00:06: [io  0x00b2-0x00b3]
[    0.269841] pnp 00:06: [io  0x2000]
[    0.269847] pnp 00:06: [io  0x2004]
[    0.269854] pnp 00:06: [io  0x0820-0x0823]
[    0.269861] pnp 00:06: [io  0x0000]
[    0.269867] pnp 00:06: [io  0x0084-0x008f]
[    0.269874] pnp 00:06: [io  0x0374-0x0375]
[    0.269880] pnp 00:06: [io  0x0377]
[    0.269887] pnp 00:06: [io  0x03f4-0x03f5]
[    0.269893] pnp 00:06: [io  0x03f7]
[    0.269900] pnp 00:06: [io  0x0400-0x040f]
[    0.269907] pnp 00:06: [io  0x0410-0x041f]
[    0.269913] pnp 00:06: [io  0x0600-0x063f]
[    0.269920] pnp 00:06: [io  0x0500-0x055f]
[    0.269927] pnp 00:06: [io  0x1040-0x107f]
[    0.270088] system 00:06: [io  0x2000] has been reserved
[    0.270097] system 00:06: [io  0x2004] has been reserved
[    0.270107] system 00:06: [io  0x0820-0x0823] has been reserved
[    0.270116] system 00:06: [io  0x0374-0x0375] has been reserved
[    0.270124] system 00:06: [io  0x0377] has been reserved
[    0.270133] system 00:06: [io  0x03f4-0x03f5] has been reserved
[    0.270141] system 00:06: [io  0x03f7] has been reserved
[    0.270149] system 00:06: [io  0x0400-0x040f] has been reserved
[    0.270158] system 00:06: [io  0x0410-0x041f] has been reserved
[    0.270167] system 00:06: [io  0x0600-0x063f] has been reserved
[    0.270176] system 00:06: [io  0x0500-0x055f] has been reserved
[    0.270184] system 00:06: [io  0x1040-0x107f] has been reserved
[    0.270194] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.270232] pnp 00:07: [io  0x0060]
[    0.270239] pnp 00:07: [io  0x0064]
[    0.270252] pnp 00:07: [irq 1]
[    0.270340] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.270376] pnp 00:08: [irq 12]
[    0.270465] pnp 00:08: Plug and Play ACPI device, IDs SNY9010
PNP0f13 (active)
[    0.270512] pnp: PnP ACPI: found 9 devices
[    0.270517] ACPI: ACPI bus type pnp unregistered
[    0.270525] PnPBIOS: Disabled by ACPI PNP
[    0.309903] pci 0000:01:00.0: no compatible bridge window for [mem
0xfffe0000-0xffffffff pref]
[    0.309944] pci 0000:00:1d.7: BAR 0: assigned [mem 0x942c4000-0x942c43ff]
[    0.309960] pci 0000:00:1d.7: BAR 0: set to [mem
0x942c4000-0x942c43ff] (PCI address [0x942c4000-0x942c43ff])
[    0.309972] pci 0000:01:00.0: BAR 6: assigned [mem
0x90000000-0x9001ffff pref]
[    0.309980] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.309989] pci 0000:00:1c.0:   bridge window [io  0x4000-0x5fff]
[    0.310000] pci 0000:00:1c.0:   bridge window [mem 0x93100000-0x941fffff]
[    0.310011] pci 0000:00:1c.0:   bridge window [mem
0x90000000-0x90ffffff pref]
[    0.310024] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.310032] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.310044] pci 0000:00:1c.1:   bridge window [mem 0x92000000-0x930fffff]
[    0.310054] pci 0000:00:1c.1:   bridge window [mem
0x91000000-0x91ffffff pref]
[    0.310092] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.310103] pci 0000:00:1c.0: setting latency timer to 64
[    0.310122] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.310132] pci 0000:00:1c.1: setting latency timer to 64
[    0.310142] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.310150] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.310158] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.310166] pci_bus 0000:00: resource 7 [mem 0x7f800000-0x7fffffff]
[    0.310174] pci_bus 0000:00: resource 8 [mem 0x000c0000-0x000dffff]
[    0.310182] pci_bus 0000:00: resource 9 [mem 0x000e0000-0x000effff]
[    0.310190] pci_bus 0000:00: resource 10 [mem 0x000f0000-0x000fffff]
[    0.310198] pci_bus 0000:00: resource 11 [mem 0x80000000-0xfebfffff]
[    0.310206] pci_bus 0000:01: resource 0 [io  0x4000-0x5fff]
[    0.310214] pci_bus 0000:01: resource 1 [mem 0x93100000-0x941fffff]
[    0.310222] pci_bus 0000:01: resource 2 [mem 0x90000000-0x90ffffff pref]
[    0.310230] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
[    0.310238] pci_bus 0000:02: resource 1 [mem 0x92000000-0x930fffff]
[    0.310246] pci_bus 0000:02: resource 2 [mem 0x91000000-0x91ffffff pref]
[    0.310416] NET: Registered protocol family 2
[    0.310637] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.311387] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[    0.312675] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.313343] TCP: Hash tables configured (established 131072 bind 65536)
[    0.313351] TCP reno registered
[    0.313363] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.313391] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.313950] NET: Registered protocol family 1
[    0.314000] pci 0000:00:02.0: Boot video device
[    0.314099] PCI: CLS 0 bytes, default 64
[    0.314234] Unpacking initramfs...
[    1.026867] Freeing initrd memory: 11044k freed
[    1.042345] Simple Boot Flag at 0x44 set to 0x1
[    1.043292] audit: initializing netlink socket (disabled)
[    1.043324] type=2000 audit(1302723310.036:1): initialized
[    1.071387] highmem bounce pool size: 64 pages
[    1.071402] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.076692] VFS: Disk quotas dquot_6.5.2
[    1.077021] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.077370] msgmni has been set to 1731
[    1.078011] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 253)
[    1.078019] io scheduler noop registered
[    1.078025] io scheduler deadline registered
[    1.078063] io scheduler cfq registered (default)
[    1.078601] isapnp: Scanning for PnP cards...
[    1.432923] isapnp: No Plug & Play device found
[    1.433092] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.676835] Linux agpgart interface v0.103
[    1.677371] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M]
at 0x60,0x64 irq 1,12
[    1.680452] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.680474] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.680791] mousedev: PS/2 mouse device common for all mice
[    1.680904] rtc_cmos 00:05: RTC can wake from S4
[    1.695032] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input0
[    1.708266] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    1.708315] rtc0: alarms up to one day, 242 bytes nvram, hpet irqs
[    1.708369] cpuidle: using governor ladder
[    1.708375] cpuidle: using governor menu
[    1.709083] TCP cubic registered
[    1.709529] NET: Registered protocol family 10
[    1.711306] Mobile IPv6
[    1.711314] NET: Registered protocol family 17
[    1.711326] Registering the dns_resolver key type
[    1.711377] Using IPI No-Shortcut mode
[    1.711616] PM: Hibernation image not present or could not be loaded.
[    1.711643] registered taskstats version 1
[    1.712158] rtc_cmos 00:05: setting system clock to 2011-04-13
19:35:11 UTC (1302723311)
[    1.712309] Initializing network drop monitor service
[    1.712527] Freeing unused kernel memory: 404k freed
[    1.712878] Write protecting the kernel text: 2616k
[    1.712925] Write protecting the kernel read-only data: 896k
[    1.874155] udev[46]: starting version 164
[    2.040129] Refined TSC clocksource calibration: 1333.284 MHz.
[    2.040143] Switching to clocksource tsc
[    2.138432] sky2: driver version 1.28
[    2.138517] sky2 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.138544] sky2 0000:01:00.0: setting latency timer to 64
[    2.138615] sky2 0000:01:00.0: Yukon-2 UL 2 chip revision 0
[    2.138836] sky2 0000:01:00.0: irq 40 for MSI/MSI-X
[    2.160004] thermal LNXTHERM:00: registered as thermal_zone0
[    2.160036] ACPI: Thermal Zone [ATF0] (50 C)
[    2.160094] sky2 0000:01:00.0: eth0: addr 00:1d:ba:bb:5e:df
[    2.223637] usbcore: registered new interface driver usbfs
[    2.224270] usbcore: registered new interface driver hub
[    2.224416] usbcore: registered new device driver usb
[    2.255580] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.255646] ehci_hcd 0000:00:1d.7: enabling device (0000 -> 0002)
[    2.255681] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 20 (level, low) -> IRQ 20
[    2.255740] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.255752] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.255883] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 1
[    2.280111] ehci_hcd 0000:00:1d.7: debug port 1
[    2.284025] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    2.284079] ehci_hcd 0000:00:1d.7: irq 20, io mem 0x942c4000
[    2.296027] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.296131] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.296143] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.296153] usb usb1: Product: EHCI Host Controller
[    2.296163] usb usb1: Manufacturer: Linux 2.6.39-rc3psb23 ehci_hcd
[    2.296172] usb usb1: SerialNumber: 0000:00:1d.7
[    2.296942] hub 1-0:1.0: USB hub found
[    2.296963] hub 1-0:1.0: 8 ports detected
[    2.316090] SCSI subsystem initialized
[    2.361566] uhci_hcd: USB Universal Host Controller Interface driver
[    2.361704] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    2.361729] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.361741] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.361775] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 2
[    2.384109] uhci_hcd 0000:00:1d.0: irq 21, io base 0x00006040
[    2.384254] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    2.384267] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.384278] usb usb2: Product: UHCI Host Controller
[    2.384287] usb usb2: Manufacturer: Linux 2.6.39-rc3psb23 uhci_hcd
[    2.384296] usb usb2: SerialNumber: 0000:00:1d.0
[    2.384767] hub 2-0:1.0: USB hub found
[    2.384786] hub 2-0:1.0: 2 ports detected
[    2.384997] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
[    2.385023] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.385034] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.385065] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 3
[    2.427881] libata version 3.00 loaded.
[    2.440142] uhci_hcd 0000:00:1d.1: irq 22, io base 0x00006020
[    2.440305] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.440320] usb usb3: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.440342] usb usb3: Product: UHCI Host Controller
[    2.440349] usb usb3: Manufacturer: Linux 2.6.39-rc3psb23 uhci_hcd
[    2.440356] usb usb3: SerialNumber: 0000:00:1d.1
[    2.440728] hub 3-0:1.0: USB hub found
[    2.440748] hub 3-0:1.0: 2 ports detected
[    2.440962] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 23 (level, low) -> IRQ 23
[    2.440981] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.440989] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.441015] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 4
[    2.456127] uhci_hcd 0000:00:1d.2: irq 23, io base 0x00006000
[    2.456279] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.456293] usb usb4: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.456305] usb usb4: Product: UHCI Host Controller
[    2.456316] usb usb4: Manufacturer: Linux 2.6.39-rc3psb23 uhci_hcd
[    2.456327] usb usb4: SerialNumber: 0000:00:1d.2
[    2.456700] hub 4-0:1.0: USB hub found
[    2.456721] hub 4-0:1.0: 2 ports detected
[    2.456918] pata_sch 0000:00:1f.1: version 0.2
[    2.457015] pata_sch 0000:00:1f.1: setting latency timer to 64
[    2.458491] scsi0 : pata_sch
[    2.458878] scsi1 : pata_sch
[    2.459969] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x6060 irq 14
[    2.459982] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x6068 irq 15
[    2.608141] usb 1-3: new high speed USB device number 2 using ehci_hcd
[    2.673357] ata1.00: ATA-7: TOSHIBA MK8025GAL, BD102A, max UDMA/100
[    2.673374] ata1.00: 156301488 sectors, multi 16: LBA48
[    2.673394] ata1.00: limited to UDMA/33 due to 40-wire cable
[    2.688611] ata1.00: configured for UDMA/33
[    2.689104] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA
MK8025GA BD10 PQ: 0 ANSI: 5
[    2.751534] usb 1-3: New USB device found, idVendor=0af0, idProduct=7601
[    2.751551] usb 1-3: New USB device strings: Mfr=2, Product=1, SerialNumber=0
[    2.751564] usb 1-3: Product: Globetrotter HSUPA Modem
[    2.751575] usb 1-3: Manufacturer: Option N.V.
[    2.884588] sd 0:0:0:0: [sda] 156301488 512-byte logical blocks:
(80.0 GB/74.5 GiB)
[    2.884858] sd 0:0:0:0: [sda] Write Protect is off
[    2.884871] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.884985] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    2.910018]  sda: sda1 sda2 < sda5 >
[    2.911072] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.980097] usb 1-8: new high speed USB device number 4 using ehci_hcd
[    3.117055] usb 1-8: New USB device found, idVendor=05ca, idProduct=18b2
[    3.117072] usb 1-8: New USB device strings: Mfr=1, Product=0, SerialNumber=0
[    3.117085] usb 1-8: Manufacturer: Ricoh co. Ltd.
[    3.336535] Btrfs loaded
[    3.356163] usb 3-2: new full speed USB device number 2 using uhci_hcd
[    3.378090] device-mapper: uevent: version 1.0.3
[    3.379278] device-mapper: ioctl: 4.20.0-ioctl (2011-02-02)
initialised: dm-devel@redhat.com
[    3.531244] usb 3-2: New USB device found, idVendor=044e, idProduct=3017
[    3.531262] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.531275] usb 3-2: Product: BCM2046 Bluetooth Device
[    3.531285] usb 3-2: Manufacturer: Broadcom Corp
[    3.531295] usb 3-2: SerialNumber: 00243374CCCA
[   14.601095] device fsid 1549aee9546462b4-866da6213b35dbb7 devid 1
transid 15479 /dev/dm-2
[   14.729732] PM: Starting manual resume from disk
[   14.729742] PM: Hibernation image partition 254:1 present
[   14.729747] PM: Looking for hibernation image.
[   14.753104] PM: Image not found (code -22)
[   14.753110] PM: Hibernation image not present or could not be loaded.
[   14.760762] device fsid 1549aee9546462b4-866da6213b35dbb7 devid 1
transid 15479 /dev/mapper/violet-root
[   20.594468] udev[340]: starting version 164
[   21.473910] ACPI: AC Adapter [AC] (off-line)
[   21.577164] ACPI: Battery Slot [BAT0] (battery present)
[   21.577833] input: Lid Switch as
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[   21.578665] ACPI: Lid Switch [LID0]
[   21.578923] input: Power Button as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[   21.578942] ACPI: Power Button [PWRB]
[   21.616170] ACPI: acpi_idle registered with cpuidle
[   21.625882] Monitor-Mwait will be used to enter C-1 state
[   21.626497] Monitor-Mwait will be used to enter C-2 state
[   21.626592] Monitor-Mwait will be used to enter C-3 state
[   21.626609] Marking TSC unstable due to TSC halts in idle
[   21.630243] Switching to clocksource hpet
[   22.417826] input: PC Speaker as /devices/platform/pcspkr/input/input3
[   22.500196] cfg80211: Calling CRDA to update world regulatory domain
[   22.656287] Bluetooth: Core ver 2.16
[   22.656360] NET: Registered protocol family 31
[   22.656367] Bluetooth: HCI device and connection manager initialized
[   22.656376] Bluetooth: HCI socket layer initialized
[   22.817842] hso: drivers/net/usb/hso.c: Option Wireless
[   22.836303] sony-laptop: Sony Programmable IO Control Driver v0.6.
[   22.836336] sony-laptop: detected Type2 model
[   22.836740] input: Sony Vaio Keys as
/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:17/SNY6001:00/input/input4
[   22.837094] input: Sony Vaio Jogdial as /devices/virtual/input/input5
[   22.846945] sony-laptop: device allocated minor is 58
[   22.850915] usbcore: registered new interface driver hso
[   22.852525] sony-laptop: Sony Notebook Control Driver v0.6.
[   22.930880] sony-laptop: brightness ignored, must be controlled by
ACPI video driver
[   23.558209] input: PS/2 Generic Mouse as
/devices/platform/i8042/serio1/input/input6
[   23.886099] [drm] Initialized drm 1.1.0 20060810
[   23.963205] Bluetooth: Generic Bluetooth USB driver ver 0.6
[   23.966287] usbcore: registered new interface driver btusb
[   24.372948] Linux video capture interface: v2.00
[   24.466834] uvcvideo: Found UVC 1.00 device <unnamed> (05ca:18b2)
[   24.468721] input: UVC Camera (05ca:18b2) as
/devices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8:1.0/input/input7
[   24.469007] usbcore: registered new interface driver uvcvideo
[   24.469017] USB Video Class driver (v1.0.0)
[   24.856067] ath9k 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   24.856094] ath9k 0000:02:00.0: setting latency timer to 64
[   24.980169] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[   24.980191] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[   24.980221] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 19 (level,
low) -> IRQ 19
[   24.980337] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   25.221808] hda_codec: ALC262: SKU not ready 0x411111f0
[   25.221885] hda_codec: ALC262: BIOS auto-probing.
[   25.222832] input: HDA Digital PCBeep as
/devices/pci0000:00/0000:00:1b.0/input/input8
[   25.226486] input: HDA Intel MID Headphone as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   25.295570] ath: EEPROM regdomain: 0x65
[   25.295581] ath: EEPROM indicates we should expect a direct regpair map
[   25.295593] ath: Country alpha2 being used: 00
[   25.295600] ath: Regpair used: 0x65
[   25.357624] psb_gfx: module is from the staging directory, the
quality is unknown, you have been warned.
[   25.405051] pvrsrvkm 0000:00:02.0: irq 41 for MSI/MSI-X
[   25.405091] pvrsrvkm 0000:00:02.0: setting latency timer to 64
[   25.405865] [TTM] Zone  kernel: Available graphics memory: 443562 kiB.
[   25.405873] [TTM] Zone highmem: Available graphics memory: 1032528 kiB.
[   25.405879] [TTM] Initializing pool allocator.
[   25.407209] GMMADR(region 0) start: 0x80000000 (256M).
[   25.407218] GTTADR(region 3) start: 0x94280000 (can map 256M RAM),
and actual RAM base 0x7ffc0000.
[   25.407223] Stole memory information
[   25.407228]       base in RAM: 0x7f800000
[   25.407233]       size: 7932K, calculated by (GTT RAM base) -
(Stolen base), seems wrong
[   25.407240]       the correct size should be: 8M(dvmt mode=3)
[   25.411529] Set up 1983 stolen pages starting at 0x0007f800, GTT offset 0K
[   25.413278] Set up 0 CI stolen pages starting at 0x00000000, GTT
offset 131072K
[   25.422308] [drm] PSB GTT mem manager ready, tt_start 1983, tt_size
30785 pages
[   25.422452] [drm] SGX core id = 0x01130000
[   25.422461] [drm] SGX core rev major = 0x01, minor = 0x02
[   25.422469] [drm] SGX core rev maintenance = 0x01, designer = 0x00
[   25.442311] acpi device:04: registered as cooling_device2
[   25.443191] input: Video Bus as
/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input10
[   25.443540] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   25.444440] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   25.444452] [drm] No driver support for vblank timestamp query.
[   25.452282] ieee80211 phy0: Selected rate control algorithm
'ath9k_rate_control'
[   25.454691] Registered led device: ath9k-phy0
[   25.454716] ieee80211 phy0: Atheros AR9280 Rev:2 mem=0xf8ea0000, irq=17
[   25.713840] allocated 1600x768 fb
[   26.196265] Console: switching to colour frame buffer device 200x48
[   26.213085] fb0: psbfb frame buffer device
[   26.213091] drm: registered panic notifier
[   26.213127] ------------[ cut here ]------------
[   26.213145] WARNING: at drivers/video/backlight/backlight.c:314
backlight_device_register+0xd0/0x137()
[   26.213154] Hardware name: VGN-P21Z_W
[   26.213159] psb-bl: invalid backlight type
[   26.213165] Modules linked in: arc4 psb_gfx(C+) ecb
snd_hda_codec_realtek ttm snd_hda_intel drm_kms_helper ath9k
snd_hda_codec mac80211 uvcvideo videodev ath9k_common btusb snd_hwdep
drm snd_pcm ath9k_hw ath snd_seq snd_timer snd_seq_device snd i2c_isch
sony_laptop hso psmouse bluetooth soundcore lpc_sch i2c_algo_bit
cfg80211 serio_raw mfd_core pcspkr i2c_core snd_page_alloc rfkill
evdev tpm_tis tpm tpm_bios processor button battery ac video
sha256_generic aes_i586 aes_generic cbc dm_crypt dm_mod btrfs
zlib_deflate crc32c libcrc32c sd_mod crc_t10dif ata_generic pata_sch
libata uhci_hcd scsi_mod ehci_hcd usbcore thermal sky2 thermal_sys
[last unloaded: scsi_wait_scan]
[   26.213331] Pid: 367, comm: modprobe Tainted: G         C  2.6.39-rc3psb23 #1
[   26.213339] Call Trace:
[   26.213355]  [<c102f084>] ? warn_slowpath_common+0x6a/0x7b
[   26.213367]  [<c116e0a5>] ? backlight_device_register+0xd0/0x137
[   26.213379]  [<c102f0fb>] ? warn_slowpath_fmt+0x28/0x2c
[   26.213391]  [<c116e0a5>] ? backlight_device_register+0xd0/0x137
[   26.213430]  [<f8fda07a>] ? psb_backlight_init+0x31/0x140 [psb_gfx]
[   26.213465]  [<f8fdbf11>] ? psb_driver_load+0x79b/0x7d8 [psb_gfx]
[   26.213499]  [<f8cf1748>] ? drm_get_pci_dev+0x12f/0x20b [drm]
[   26.213513]  [<c114ffa0>] ? local_pci_probe+0x34/0x74
[   26.213525]  [<c115097e>] ? pci_device_probe+0x41/0x63
[   26.213539]  [<c11c149d>] ? driver_probe_device+0x8c/0x110
[   26.213551]  [<c11c1561>] ? __driver_attach+0x40/0x5b
[   26.213562]  [<c11c0cf9>] ? bus_for_each_dev+0x37/0x5f
[   26.213574]  [<c11c1353>] ? driver_attach+0x11/0x13
[   26.213585]  [<c11c1521>] ? driver_probe_device+0x110/0x110
[   26.213597]  [<c11c1074>] ? bus_add_driver+0x87/0x1bb
[   26.213615]  [<c113bac8>] ? kset_find_obj_hinted+0x43/0x7d
[   26.213645]  [<f8ff0000>] ? 0xf8feffff
[   26.213660]  [<c11c19a0>] ? driver_register+0x7a/0xd9
[   26.213697]  [<f8cf1847>] ? drm_pci_init+0x23/0xbf [drm]
[   26.213721]  [<f8ff0000>] ? 0xf8feffff
[   26.213736]  [<c1150b49>] ? __pci_register_driver+0x33/0x89
[   26.213759]  [<f8ff0000>] ? 0xf8feffff
[   26.213774]  [<c1001150>] ? do_one_initcall+0x68/0x10f
[   26.213792]  [<c1058631>] ? sys_init_module+0xca5/0xe34
[   26.213848]  [<c128c5df>] ? sysenter_do_call+0x12/0x28
[   26.213857] ---[ end trace 3d4fcfe20042011f ]---
[   26.214031] [drm] Initialized pvrsrvkm 8.1.0 2009-03-10 for
0000:00:02.0 on minor 0
[   31.364782] loop: module loaded
[   31.652710] Adding 3203068k swap on /dev/mapper/violet-swap_1.
Priority:-1 extents:1 across:3203068k
[   33.695103] IPv4 FIB: Using LC-trie version 0.409
[   34.617094] fuse init (API version 7.16)
[   37.123503] input: ACPI Virtual Keyboard Device as
/devices/virtual/input/input11
[   39.137344] sky2 0000:01:00.0: eth0: enabling interface
[   39.138527] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   39.189014] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   40.836587] apm: BIOS not found.
[   45.516879] lp: driver loaded but no devices found
[   45.538165] ppdev: user-space parallel port driver
[   77.847463] wlan0: authenticate with 00:25:9c:24:2c:0e (try 1)
[   77.864125] wlan0: authenticated
[   77.864200] wlan0: associate with 00:25:9c:24:2c:0e (try 1)
[   77.869050] wlan0: RX AssocResp from 00:25:9c:24:2c:0e (capab=0x411
status=0 aid=2)
[   77.869063] wlan0: associated
[   77.869831] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready

-------- Xorg.log
X.Org X Server 1.7.7
Release Date: 2010-05-04
X Protocol Version 11, Revision 0
Build Operating System: Linux 2.6.32.29-dsa-ia32 i686 Debian
Current Operating System: Linux violet 2.6.39-rc3psb23 #1 SMP Tue Apr
12 19:26:35 CEST 2011 i686
Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.39-rc3psb23
root=/dev/mapper/violet-root ro quiet
Build Date: 19 February 2011  02:37:36PM
xorg-server 2:1.7.7-13 (Cyril Brulebois <kibi@debian.org>)
Current version of pixman: 0.16.4
	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
(==) Log file: "/var/log/Xorg.0.log", Time: Wed Apr 13 21:35:54 2011
(==) Using system config directory "/usr/share/X11/xorg.conf.d"
(==) No Layout section.  Using the first Screen section.
(==) No screen section available. Using defaults.
(**) |-->Screen "Default Screen Section" (0)
(**) |   |-->Monitor "<default monitor>"
(==) No monitor specified for screen "Default Screen Section".
	Using a default monitor configuration.
(==) Automatically adding devices
(==) Automatically enabling devices
(WW) The directory "/usr/share/fonts/X11/cyrillic" does not exist.
	Entry deleted from font path.
(==) FontPath set to:
	/usr/share/fonts/X11/misc,
	/usr/share/fonts/X11/100dpi/:unscaled,
	/usr/share/fonts/X11/75dpi/:unscaled,
	/usr/share/fonts/X11/Type1,
	/usr/share/fonts/X11/100dpi,
	/usr/share/fonts/X11/75dpi,
	/var/lib/defoma/x-ttcidfont-conf.d/dirs/TrueType,
	built-ins
(==) ModulePath set to "/usr/lib/xorg/modules"
(II) The server relies on udev to provide the list of input devices.
	If no devices become available, reconfigure udev or disable AutoAddDevices.
(II) Loader magic: 0x81ecca0
(II) Module ABI versions:
	X.Org ANSI C Emulation: 0.4
	X.Org Video Driver: 6.0
	X.Org XInput driver : 7.0
	X.Org Server Extension : 2.0
(++) using VT number 7

(--) PCI:*(0:0:2:0) 8086:8108:104d:9039 Intel Corporation System
Controller Hub (SCH Poulsbo) Graphics Controller rev 6, Mem @
0x94200000/524288, 0x80000000/268435456, 0x94280000/262144, I/O @
0x00006070/8
(II) Open ACPI successful (/var/run/acpid.socket)
(II) LoadModule: "extmod"
(II) Loading /usr/lib/xorg/modules/extensions/libextmod.so
(II) Module extmod: vendor="X.Org Foundation"
	compiled for 1.7.7, module version = 1.0.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension SELinux
(II) Loading extension MIT-SCREEN-SAVER
(II) Loading extension XFree86-VidModeExtension
(II) Loading extension XFree86-DGA
(II) Loading extension DPMS
(II) Loading extension XVideo
(II) Loading extension XVideo-MotionCompensation
(II) Loading extension X-Resource
(II) LoadModule: "dbe"
(II) Loading /usr/lib/xorg/modules/extensions/libdbe.so
(II) Module dbe: vendor="X.Org Foundation"
	compiled for 1.7.7, module version = 1.0.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension DOUBLE-BUFFER
(II) LoadModule: "glx"
(II) Loading /usr/lib/xorg/modules/extensions/libglx.so
(II) Module glx: vendor="X.Org Foundation"
	compiled for 1.7.7, module version = 1.0.0
	ABI class: X.Org Server Extension, version 2.0
(==) AIGLX enabled
(II) Loading extension GLX
(II) LoadModule: "record"
(II) Loading /usr/lib/xorg/modules/extensions/librecord.so
(II) Module record: vendor="X.Org Foundation"
	compiled for 1.7.7, module version = 1.13.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension RECORD
(II) LoadModule: "dri"
(II) Loading /usr/lib/xorg/modules/extensions/libdri.so
(II) Module dri: vendor="X.Org Foundation"
	compiled for 1.7.7, module version = 1.0.0
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension XFree86-DRI
(II) LoadModule: "dri2"
(II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
(II) Module dri2: vendor="X.Org Foundation"
	compiled for 1.7.7, module version = 1.1.0
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension DRI2
(==) Matched vesa as autoconfigured driver 0
(==) Matched fbdev as autoconfigured driver 1
(==) Assigned the driver to the xf86ConfigLayout
(II) LoadModule: "vesa"
(II) Loading /usr/lib/xorg/modules/drivers/vesa_drv.so
(II) Module vesa: vendor="X.Org Foundation"
	compiled for 1.7.7, module version = 2.3.0
	Module class: X.Org Video Driver
	ABI class: X.Org Video Driver, version 6.0
(II) LoadModule: "fbdev"
(II) Loading /usr/lib/xorg/modules/drivers/fbdev_drv.so
(II) Module fbdev: vendor="X.Org Foundation"
	compiled for 1.7.6.901, module version = 0.4.2
	ABI class: X.Org Video Driver, version 6.0
(II) VESA: driver for VESA chipsets: vesa
(II) FBDEV: driver for framebuffer: fbdev
(II) Primary Device is: PCI 00@00:02:0
(EE) VESA: Kernel modesetting driver in use, refusing to load
(WW) Falling back to old probe method for vesa
(II) Loading sub module "fbdevhw"
(II) LoadModule: "fbdevhw"
(II) Loading /usr/lib/xorg/modules/linux/libfbdevhw.so
(II) Module fbdevhw: vendor="X.Org Foundation"
	compiled for 1.7.7, module version = 0.0.2
	ABI class: X.Org Video Driver, version 6.0
(**) FBDEV(0): claimed PCI slot 0@0:2:0
(II) FBDEV(0): using default device
(II) FBDEV(0): Creating default Display subsection in Screen section
	"Default Screen Section" for depth/fbbpp 24/32
(==) FBDEV(0): Depth 24, (==) framebuffer bpp 32
(==) FBDEV(0): RGB weight 888
(==) FBDEV(0): Default visual is TrueColor
(==) FBDEV(0): Using gamma correction (1.0, 1.0, 1.0)
(II) FBDEV(0): hardware: psbfb (video memory: 4800kB)
(II) FBDEV(0): checking modes against framebuffer device...
(II) FBDEV(0): checking modes against monitor...
(--) FBDEV(0): Virtual size is 1600x768 (pitch 1600)
(**) FBDEV(0):  Built-in mode "current"
(==) FBDEV(0): DPI set to (96, 96)
(II) Loading sub module "fb"
(II) LoadModule: "fb"
(II) Loading /usr/lib/xorg/modules/libfb.so
(II) Module fb: vendor="X.Org Foundation"
	compiled for 1.7.7, module version = 1.0.0
	ABI class: X.Org ANSI C Emulation, version 0.4
(**) FBDEV(0): using shadow framebuffer
(II) Loading sub module "shadow"
(II) LoadModule: "shadow"
(II) Loading /usr/lib/xorg/modules/libshadow.so
(II) Module shadow: vendor="X.Org Foundation"
	compiled for 1.7.7, module version = 1.1.0
	ABI class: X.Org ANSI C Emulation, version 0.4
(==) Depth 24 pixmap format is 32 bpp
(==) FBDEV(0): Backing store disabled
(==) FBDEV(0): DPMS enabled
(==) RandR enabled
(II) Initializing built-in extension Generic Event Extension
(II) Initializing built-in extension SHAPE
(II) Initializing built-in extension MIT-SHM
(II) Initializing built-in extension XInputExtension
(II) Initializing built-in extension XTEST
(II) Initializing built-in extension BIG-REQUESTS
(II) Initializing built-in extension SYNC
(II) Initializing built-in extension XKEYBOARD
(II) Initializing built-in extension XC-MISC
(II) Initializing built-in extension SECURITY
(II) Initializing built-in extension XINERAMA
(II) Initializing built-in extension XFIXES
(II) Initializing built-in extension RENDER
(II) Initializing built-in extension RANDR
(II) Initializing built-in extension COMPOSITE
(II) Initializing built-in extension DAMAGE
SELinux: Disabled on system, not enabling in X server
(II) AIGLX: Screen 0 is not DRI2 capable
(II) AIGLX: Screen 0 is not DRI capable
(II) AIGLX: Loaded and initialized /usr/lib/dri/swrast_dri.so
(II) GLX: Initialized DRISWRAST GL provider for screen 0
(II) config/udev: Adding input device Video Bus (/dev/input/event10)
(**) Video Bus: Applying InputClass "evdev keyboard catchall"
(II) LoadModule: "evdev"
(II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
(II) Module evdev: vendor="X.Org Foundation"
	compiled for 1.7.6.901, module version = 2.3.2
	Module class: X.Org XInput Driver
	ABI class: X.Org XInput driver, version 7.0
(**) Video Bus: always reports core events
(**) Video Bus: Device: "/dev/input/event10"
(II) Video Bus: Found keys
(II) Video Bus: Configuring as keyboard
(II) XINPUT: Adding extended input device "Video Bus" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "us"
(II) config/udev: Adding input device Sony Vaio Keys (/dev/input/event4)
(**) Sony Vaio Keys: Applying InputClass "evdev keyboard catchall"
(**) Sony Vaio Keys: always reports core events
(**) Sony Vaio Keys: Device: "/dev/input/event4"
(II) Sony Vaio Keys: Found keys
(II) Sony Vaio Keys: Configuring as keyboard
(II) XINPUT: Adding extended input device "Sony Vaio Keys" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "us"
(II) config/udev: Adding input device Power Button (/dev/input/event2)
(**) Power Button: Applying InputClass "evdev keyboard catchall"
(**) Power Button: always reports core events
(**) Power Button: Device: "/dev/input/event2"
(II) Power Button: Found keys
(II) Power Button: Configuring as keyboard
(II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "us"
(II) config/udev: Adding input device Lid Switch (/dev/input/event1)
(II) No input driver/identifier specified (ignoring)
(II) config/udev: Adding input device HDA Digital PCBeep (/dev/input/event8)
(II) No input driver/identifier specified (ignoring)
(II) config/udev: Adding input device HDA Intel MID Headphone
(/dev/input/event9)
(II) No input driver/identifier specified (ignoring)
(II) config/udev: Adding input device UVC Camera (05ca:18b2) (/dev/input/event7)
(**) UVC Camera (05ca:18b2): Applying InputClass "evdev keyboard catchall"
(**) UVC Camera (05ca:18b2): always reports core events
(**) UVC Camera (05ca:18b2): Device: "/dev/input/event7"
(II) UVC Camera (05ca:18b2): Found keys
(II) UVC Camera (05ca:18b2): Configuring as keyboard
(II) XINPUT: Adding extended input device "UVC Camera (05ca:18b2)"
(type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "us"
(II) config/udev: Adding input device AT Translated Set 2 keyboard
(/dev/input/event0)
(**) AT Translated Set 2 keyboard: Applying InputClass "evdev keyboard catchall"
(**) AT Translated Set 2 keyboard: always reports core events
(**) AT Translated Set 2 keyboard: Device: "/dev/input/event0"
(II) AT Translated Set 2 keyboard: Found keys
(II) AT Translated Set 2 keyboard: Configuring as keyboard
(II) XINPUT: Adding extended input device "AT Translated Set 2
keyboard" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "us"
(II) config/udev: Adding input device PS/2 Generic Mouse (/dev/input/event6)
(**) PS/2 Generic Mouse: Applying InputClass "evdev pointer catchall"
(**) PS/2 Generic Mouse: always reports core events
(**) PS/2 Generic Mouse: Device: "/dev/input/event6"
(II) PS/2 Generic Mouse: Found 3 mouse buttons
(II) PS/2 Generic Mouse: Found relative axes
(II) PS/2 Generic Mouse: Found x and y relative axes
(II) PS/2 Generic Mouse: Configuring as mouse
(**) PS/2 Generic Mouse: YAxisMapping: buttons 4 and 5
(**) PS/2 Generic Mouse: EmulateWheelButton: 4, EmulateWheelInertia:
10, EmulateWheelTimeout: 200
(II) XINPUT: Adding extended input device "PS/2 Generic Mouse" (type: MOUSE)
(II) PS/2 Generic Mouse: initialized for relative axes.
(II) config/udev: Adding input device PS/2 Generic Mouse (/dev/input/mouse1)
(II) No input driver/identifier specified (ignoring)
(II) config/udev: Adding input device PC Speaker (/dev/input/event3)
(II) No input driver/identifier specified (ignoring)
(II) config/udev: Adding input device ACPI Virtual Keyboard Device
(/dev/input/event11)
(**) ACPI Virtual Keyboard Device: Applying InputClass "evdev keyboard catchall"
(**) ACPI Virtual Keyboard Device: always reports core events
(**) ACPI Virtual Keyboard Device: Device: "/dev/input/event11"
(II) ACPI Virtual Keyboard Device: Found keys
(II) ACPI Virtual Keyboard Device: Configuring as keyboard
(II) XINPUT: Adding extended input device "ACPI Virtual Keyboard
Device" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "us"
(II) config/udev: Adding input device Sony Vaio Jogdial (/dev/input/event5)
(II) No input driver/identifier specified (ignoring)
(II) config/udev: Adding input device Sony Vaio Jogdial (/dev/input/mouse0)
(II) No input driver/identifier specified (ignoring)
