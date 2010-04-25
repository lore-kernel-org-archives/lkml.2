Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab0DYQ6I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 12:58:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49475 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab0DYQ6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 12:58:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=aIKY5FV0JJQTsh67dCPr8nYi31yzukhI42BMQpITbWL9346Uw3HWVbVzOMWX5TK+cm
         +WBEzwPuSbBdraoIRKUSPdtww7cURvKBUrCFlKHDKWz8Ps1rQsPS/D5TZH+MKSq9JyWo
         SSkZeCgmOEqaJpHMbiYFuLaxKsLsPRmneMIJA=
MIME-Version: 1.0
In-Reply-To: <4BD4721D.2090202@gmail.com>
References: <o2l80b317761004250816q17a14763g812d9fbe32d42f80@mail.gmail.com> 
	<4BD4721D.2090202@gmail.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Sun, 25 Apr 2010 18:57:45 +0200
Message-ID: <r2x80b317761004250957l66922ba3x3a52b16e800ddf26@mail.gmail.com>
Subject: Re: [bug ?] device reported invalid CHS sector 0 / NCQ disabled due 
	to excessive errors
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/4/25 Robert Hancock <hancockrwd@gmail.com>:
> Usually this sort of thing is some kind of hardware problem - either a
> firmware bug in the drive, or else a SATA link communication problem like a
> bad cable, or the drives not getting clean power under load.
I'll try other sata cables, but I'm afraid, like you said, that it's a
firmware bug...

> The log is missing the detail messages indicating what actually happened -
> can you post the output from dmesg instead?
you're right, there's more informations in there :

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.31.9-hpet (richard@desktop) (gcc
version 4.4.1 (Ubuntu 4.4.1-4ubuntu9) ) #1 SMP Tue Apr 13 18:59:03
CEST 2010 (Ubuntu 2.6.31-20.58-generic)
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.31.9-hpet
root=/dev/md1 ro splash enable_mtrr_cleanup
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
[    0.000000]  BIOS-e820: 000000000009e800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf770000 (usable)
[    0.000000]  BIOS-e820: 00000000bf770000 - 00000000bf788000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf788000 - 00000000bf7dc000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf7dc000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] DMI 2.6 present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000
(usable) ==> (reserved)
[    0.000000] last_pfn = 0x140000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-E7FFF write-through
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F00000000 write-back
[    0.000000]   1 base 100000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 4GB, type WB
[    0.000000] reg 1, base: 4GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3GB, range: 1GB, type UC
[    0.000000] total RAM coverred: 4096M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 64K 	num_reg: 3  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 4GB, range: 1GB, type WB
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000c0000000 - 0000000100000000
(usable) ==> (reserved)
[    0.000000] last_pfn = 0xbf770 max_arch_pfn = 0x400000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009e800 (usable)
[    0.000000]  modified: 000000000009e800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000bf770000 (usable)
[    0.000000]  modified: 00000000bf770000 - 00000000bf788000 (ACPI data)
[    0.000000]  modified: 00000000bf788000 - 00000000bf7dc000 (ACPI NVS)
[    0.000000]  modified: 00000000bf7dc000 - 00000000c0000000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bf770000
[    0.000000] NX (Execute Disable) protection: active
[    0.000000]  0000000000 - 00bf600000 page 2M
[    0.000000]  00bf600000 - 00bf770000 page 4k
[    0.000000] kernel direct mapping tables up to bf770000 @ 10000-15000
[    0.000000] init_memory_mapping: 0000000100000000-0000000140000000
[    0.000000] NX (Execute Disable) protection: active
[    0.000000]  0100000000 - 0140000000 page 2M
[    0.000000] kernel direct mapping tables up to 140000000 @ 13000-19000
[    0.000000] RAMDISK: 33f4a000 - 37fef38e
[    0.000000] ACPI: RSDP 00000000000fb970 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000bf770100 0006C (v01 022310 XSDT1106
20100223 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bf770290 000F4 (v03 022310 FACP1106
20100223 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bf7704a0 0EE9D (v01  A1326 A1326001
00000001 INTL 20060113)
[    0.000000] ACPI: FACS 00000000bf788000 00040
[    0.000000] ACPI: APIC 00000000bf770390 000CC (v01 022310 APIC1106
20100223 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bf770460 0003C (v01 022310 OEMMCFG
20100223 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bf788040 00072 (v01 022310 OEMB1106
20100223 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000bf77f7a0 00038 (v01 022310 OEMHPET
20100223 MSFT 00000097)
[    0.000000] ACPI: DMAR 00000000bf7880c0 00090 (v01    AMI  OEMDMAR
00000001 MSFT 00000097)
[    0.000000] ACPI: ASPT 00000000bf77fa40 00034 (v06 022310 PerfTune
20100223 MSFT 00000097)
[    0.000000] ACPI: OSFR 00000000bf77fa80 000B0 (v01 022310 OEMOSFR
20100223 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bf78ac00 00363 (v01 DpgPmm    CpuPm
00000012 INTL 20060113)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000140000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000140000000
[    0.000000]   NODE_DATA [0000000000014000 - 0000000000017fff]
[    0.000000]   bootmap [0000000000018000 -  000000000003ffff] pages 28
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0140000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
[0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==>
[0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 00019c720c]    TEXT DATA BSS ==>
[0001000000 - 00019c720c]
[    0.000000]   #3 [0033f4a000 - 0037fef38e]          RAMDISK ==>
[0033f4a000 - 0037fef38e]
[    0.000000]   #4 [000009e800 - 0000100000]    BIOS reserved ==>
[000009e800 - 0000100000]
[    0.000000]   #5 [00019c8000 - 00019c82bc]              BRK ==>
[00019c8000 - 00019c82bc]
[    0.000000]   #6 [0000010000 - 0000013000]          PGTABLE ==>
[0000010000 - 0000013000]
[    0.000000]   #7 [0000013000 - 0000014000]          PGTABLE ==>
[0000013000 - 0000014000]
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD ->
[ffff880028600000-ffff88002bdfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00140000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bf770
[    0.000000]     0: 0x00100000 -> 0x00140000
[    0.000000] On node 0 totalpages: 1046270
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 104 pages reserved
[    0.000000]   DMA zone: 3822 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 765864 pages, LIFO batch:31
[    0.000000]   Normal zone: 3584 pages used for memmap
[    0.000000]   Normal zone: 258560 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x88] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x89] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x8a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x8b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x8c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x8d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x8e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x8f] disabled)
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] 16 Processors exceeds NR_CPUS limit of 8
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bf770000 - 00000000bf788000
[    0.000000] PM: Registered nosave memory: 00000000bf788000 - 00000000bf7dc000
[    0.000000] PM: Registered nosave memory: 00000000bf7dc000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffe00000
[    0.000000] PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap:
c0000000:3ee00000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages at ffff880028022000, static
data 90720 bytes
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.
Total pages: 1028246
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.31.9-hpet
root=/dev/md1 ro splash enable_mtrr_cleanup
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.000000] Placing 64MB software IO TLB between ffff880020000000 -
ffff880024000000
[    0.000000] software IO TLB at phys 0x20000000 - 0x24000000
[    0.000000] Memory: 3984372k/5242880k available (5262k kernel code,
1057800k absent, 200708k reserved, 2952k data, 664k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0,
CPUs=8, Nodes=1
[    0.000000] NR_IRQS:4352 nr_irqs:472
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2808.454 MHz processor.
[    0.001084] Console: colour VGA+ 80x25
[    0.001086] console [tty0] enabled
[    0.013995] allocated 41943040 bytes of page_cgroup
[    0.014043] please try 'cgroup_disable=memory' option if you don't
want memory cgroups
[    0.014215] hpet clockevent registered
[    0.014221]   alloc irq_desc for 24 on node 0
[    0.014223]   alloc kstat_irqs on node 0
[    0.014228]   alloc irq_desc for 25 on node 0
[    0.014229]   alloc kstat_irqs on node 0
[    0.014231]   alloc irq_desc for 26 on node 0
[    0.014232]   alloc kstat_irqs on node 0
[    0.014235]   alloc irq_desc for 27 on node 0
[    0.014236]   alloc kstat_irqs on node 0
[    0.014238]   alloc irq_desc for 28 on node 0
[    0.014239]   alloc kstat_irqs on node 0
[    0.014241] HPET: 8 timers in total, 5 timers will be used for per-cpu timer
[    0.014293] Calibrating delay loop (skipped), value calculated
using timer frequency.. 5616.90 BogoMIPS (lpj=28084540)
[    0.014397] Security Framework initialized
[    0.014452] AppArmor: AppArmor initialized
[    0.014714] Dentry cache hash table entries: 524288 (order: 10,
4194304 bytes)
[    0.015490] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.015841] Mount-cache hash table entries: 256
[    0.015957] Initializing cgroup subsys ns
[    0.016003] Initializing cgroup subsys cpuacct
[    0.016049] Initializing cgroup subsys memory
[    0.016096] Initializing cgroup subsys freezer
[    0.016141] Initializing cgroup subsys net_cls
[    0.016193] CPU: Physical Processor ID: 0
[    0.016237] CPU: Processor Core ID: 0
[    0.016283] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.016354] CPU: L2 cache: 256K
[    0.016397] CPU: L3 cache: 8192K
[    0.016440] CPU 0/0x0 -> Node 0
[    0.016484] mce: CPU supports 9 MCE banks
[    0.016535] CPU0: Thermal monitoring enabled (TM1)
[    0.016582] CPU 0 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 CMCI:8
[    0.016791] using mwait in idle threads.
[    0.016835] Performance Counters: Nehalem/Corei7 events, Intel PMU driver.
[    0.016938] ... version:                 3
[    0.016982] ... bit width:               48
[    0.017027] ... generic counters:        4
[    0.017071] ... value mask:              0000ffffffffffff
[    0.017117] ... max period:              000000007fffffff
[    0.017163] ... fixed-purpose counters:  3
[    0.017208] ... counter mask:            000000070000000f
[    0.019404] ACPI: Core revision 20090521
[    0.115249] Setting APIC routing to flat
[    0.115610] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.215496] CPU0: Intel(R) Core(TM) i7 CPU         860  @ 2.80GHz stepping 05
[    0.333790] Booting processor 1 APIC 0x2 ip 0x6000
[    0.344295] Initializing CPU#1
[    0.493453] Calibrating delay using timer specific routine..
5617.34 BogoMIPS (lpj=28086749)
[    0.493458] CPU: Physical Processor ID: 0
[    0.493459] CPU: Processor Core ID: 1
[    0.493461] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.493462] CPU: L2 cache: 256K
[    0.493463] CPU: L3 cache: 8192K
[    0.493464] CPU 1/0x2 -> Node 0
[    0.493467] mce: CPU supports 9 MCE banks
[    0.493474] CPU1: Thermal monitoring enabled (TM1)
[    0.493476] CPU 1 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.494069] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.494683] CPU1: Intel(R) Core(TM) i7 CPU         860  @ 2.80GHz stepping 05
[    0.495330] Skipping synchronization checks as TSC is reliable.
[    0.495434] Booting processor 2 APIC 0x4 ip 0x6000
[    0.505793] Initializing CPU#2
[    0.653195] Calibrating delay using timer specific routine..
5617.35 BogoMIPS (lpj=28086779)
[    0.653201] CPU: Physical Processor ID: 0
[    0.653202] CPU: Processor Core ID: 2
[    0.653203] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.653205] CPU: L2 cache: 256K
[    0.653205] CPU: L3 cache: 8192K
[    0.653207] CPU 2/0x4 -> Node 0
[    0.653209] mce: CPU supports 9 MCE banks
[    0.653216] CPU2: Thermal monitoring enabled (TM1)
[    0.653219] CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.653806] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.654378] CPU2: Intel(R) Core(TM) i7 CPU         860  @ 2.80GHz stepping 05
[    0.655025] Skipping synchronization checks as TSC is reliable.
[    0.655130] Booting processor 3 APIC 0x6 ip 0x6000
[    0.665489] Initializing CPU#3
[    0.812937] Calibrating delay using timer specific routine..
5617.35 BogoMIPS (lpj=28086772)
[    0.812943] CPU: Physical Processor ID: 0
[    0.812944] CPU: Processor Core ID: 3
[    0.812946] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.812947] CPU: L2 cache: 256K
[    0.812948] CPU: L3 cache: 8192K
[    0.812949] CPU 3/0x6 -> Node 0
[    0.812951] mce: CPU supports 9 MCE banks
[    0.812958] CPU3: Thermal monitoring enabled (TM1)
[    0.812961] CPU 3 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.813552] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.814175] CPU3: Intel(R) Core(TM) i7 CPU         860  @ 2.80GHz stepping 05
[    0.814822] Skipping synchronization checks as TSC is reliable.
[    0.814932] Booting processor 4 APIC 0x1 ip 0x6000
[    0.825292] Initializing CPU#4
[    0.972680] Calibrating delay using timer specific routine..
5617.35 BogoMIPS (lpj=28086756)
[    0.972687] CPU: Physical Processor ID: 0
[    0.972688] CPU: Processor Core ID: 0
[    0.972690] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.972691] CPU: L2 cache: 256K
[    0.972692] CPU: L3 cache: 8192K
[    0.972694] CPU 4/0x1 -> Node 0
[    0.972697] mce: CPU supports 9 MCE banks
[    0.972705] CPU4: Thermal monitoring enabled (TM1)
[    0.972707] CPU 4 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    0.973425] x86 PAT enabled: cpu 4, old 0x7040600070406, new 0x7010600070106
[    0.974173] CPU4: Intel(R) Core(TM) i7 CPU         860  @ 2.80GHz stepping 05
[    0.974819] Skipping synchronization checks as TSC is reliable.
[    0.974926] Booting processor 5 APIC 0x3 ip 0x6000
[    0.985185] Initializing CPU#5
[    1.132422] Calibrating delay using timer specific routine..
5617.35 BogoMIPS (lpj=28086767)
[    1.132428] CPU: Physical Processor ID: 0
[    1.132429] CPU: Processor Core ID: 1
[    1.132430] CPU: L1 I cache: 32K, L1 D cache: 32K
[    1.132432] CPU: L2 cache: 256K
[    1.132432] CPU: L3 cache: 8192K
[    1.132434] CPU 5/0x3 -> Node 0
[    1.132436] mce: CPU supports 9 MCE banks
[    1.132443] CPU5: Thermal monitoring enabled (TM1)
[    1.132445] CPU 5 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    1.133187] x86 PAT enabled: cpu 5, old 0x7040600070406, new 0x7010600070106
[    1.133975] CPU5: Intel(R) Core(TM) i7 CPU         860  @ 2.80GHz stepping 05
[    1.134621] Skipping synchronization checks as TSC is reliable.
[    1.134726] Booting processor 6 APIC 0x5 ip 0x6000
[    1.145085] Initializing CPU#6
[    1.292165] Calibrating delay using timer specific routine..
5617.35 BogoMIPS (lpj=28086752)
[    1.292170] CPU: Physical Processor ID: 0
[    1.292171] CPU: Processor Core ID: 2
[    1.292173] CPU: L1 I cache: 32K, L1 D cache: 32K
[    1.292174] CPU: L2 cache: 256K
[    1.292175] CPU: L3 cache: 8192K
[    1.292176] CPU 6/0x5 -> Node 0
[    1.292178] mce: CPU supports 9 MCE banks
[    1.292185] CPU6: Thermal monitoring enabled (TM1)
[    1.292188] CPU 6 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    1.292926] x86 PAT enabled: cpu 6, old 0x7040600070406, new 0x7010600070106
[    1.293771] CPU6: Intel(R) Core(TM) i7 CPU         860  @ 2.80GHz stepping 05
[    1.294418] Skipping synchronization checks as TSC is reliable.
[    1.294525] Booting processor 7 APIC 0x7 ip 0x6000
[    1.304883] Initializing CPU#7
[    1.451907] Calibrating delay using timer specific routine..
5617.35 BogoMIPS (lpj=28086763)
[    1.451913] CPU: Physical Processor ID: 0
[    1.451913] CPU: Processor Core ID: 3
[    1.451915] CPU: L1 I cache: 32K, L1 D cache: 32K
[    1.451916] CPU: L2 cache: 256K
[    1.451917] CPU: L3 cache: 8192K
[    1.451919] CPU 7/0x7 -> Node 0
[    1.451920] mce: CPU supports 9 MCE banks
[    1.451928] CPU7: Thermal monitoring enabled (TM1)
[    1.451930] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    1.452675] x86 PAT enabled: cpu 7, old 0x7040600070406, new 0x7010600070106
[    1.453470] CPU7: Intel(R) Core(TM) i7 CPU         860  @ 2.80GHz stepping 05
[    1.454116] Skipping synchronization checks as TSC is reliable.
[    1.454175] Brought up 8 CPUs
[    1.454218] Total of 8 processors activated (44938.37 BogoMIPS).
[    1.454316] CPU0 attaching sched-domain:
[    1.454318]  domain 0: span 0,4 level SIBLING
[    1.454319]   groups: 0 4
[    1.454322]   domain 1: span 0-7 level MC
[    1.454323]    groups: 0,4 1,5 2,6 3,7
[    1.454327] CPU1 attaching sched-domain:
[    1.454329]  domain 0: span 1,5 level SIBLING
[    1.454330]   groups: 1 5
[    1.454332]   domain 1: span 0-7 level MC
[    1.454333]    groups: 1,5 2,6 3,7 0,4
[    1.454337] CPU2 attaching sched-domain:
[    1.454338]  domain 0: span 2,6 level SIBLING
[    1.454340]   groups: 2 6
[    1.454342]   domain 1: span 0-7 level MC
[    1.454343]    groups: 2,6 3,7 0,4 1,5
[    1.454346] CPU3 attaching sched-domain:
[    1.454348]  domain 0: span 3,7 level SIBLING
[    1.454349]   groups: 3 7
[    1.454351]   domain 1: span 0-7 level MC
[    1.454352]    groups: 3,7 0,4 1,5 2,6
[    1.454356] CPU4 attaching sched-domain:
[    1.454357]  domain 0: span 0,4 level SIBLING
[    1.454358]   groups: 4 0
[    1.454360]   domain 1: span 0-7 level MC
[    1.454362]    groups: 0,4 1,5 2,6 3,7
[    1.454365] CPU5 attaching sched-domain:
[    1.454366]  domain 0: span 1,5 level SIBLING
[    1.454367]   groups: 5 1
[    1.454369]   domain 1: span 0-7 level MC
[    1.454371]    groups: 1,5 2,6 3,7 0,4
[    1.454374] CPU6 attaching sched-domain:
[    1.454375]  domain 0: span 2,6 level SIBLING
[    1.454377]   groups: 6 2
[    1.454379]   domain 1: span 0-7 level MC
[    1.454380]    groups: 2,6 3,7 0,4 1,5
[    1.454383] CPU7 attaching sched-domain:
[    1.454385]  domain 0: span 3,7 level SIBLING
[    1.454386]   groups: 7 3
[    1.454388]   domain 1: span 0-7 level MC
[    1.454389]    groups: 3,7 0,4 1,5 2,6
[    1.454678] Booting paravirtualized kernel on bare hardware
[    1.454848] regulator: core version 0.5
[    1.454914] Time: 10:10:23  Date: 04/25/10
[    1.454986] NET: Registered protocol family 16
[    1.455105] ACPI: bus type pci registered
[    1.455195] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    1.455244] PCI: Not using MMCONFIG.
[    1.455288] PCI: Using configuration type 1 for base access
[    1.455882] bio: create slab <bio-0> at 0
[    1.456715] ACPI: EC: Look up EC in DSDT
[    1.469580] ACPI: Interpreter enabled
[    1.469625] ACPI: (supports S0 S1 S3 S4 S5)
[    1.469815] ACPI: Using IOAPIC for interrupt routing
[    1.469901] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    1.472632] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    1.477189] PCI: Using MMCONFIG at e0000000 - efffffff
[    1.484686] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
[    1.484735] ACPI: EC: driver started in poll mode
[    1.484847] ACPI Warning: Incorrect checksum in table [OEMB] - 0F,
should be 0E 20090521 tbutils-246
[    1.485096] ACPI: No dock devices found.
[    1.485395] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    1.485530] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    1.485580] pci 0000:00:03.0: PME# disabled
[    1.485860] pci 0000:00:1a.0: reg 10 32bit mmio: [0xfbafe000-0xfbafe3ff]
[    1.485908] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    1.485957] pci 0000:00:1a.0: PME# disabled
[    1.486035] pci 0000:00:1b.0: reg 10 64bit mmio: [0xfbaf8000-0xfbafbfff]
[    1.486070] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.486120] pci 0000:00:1b.0: PME# disabled
[    1.486212] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.486261] pci 0000:00:1c.0: PME# disabled
[    1.486356] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    1.486405] pci 0000:00:1c.4: PME# disabled
[    1.486498] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    1.486548] pci 0000:00:1c.5: PME# disabled
[    1.486640] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    1.486689] pci 0000:00:1c.6: PME# disabled
[    1.486784] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    1.486833] pci 0000:00:1c.7: PME# disabled
[    1.486920] pci 0000:00:1d.0: reg 10 32bit mmio: [0xfbafd000-0xfbafd3ff]
[    1.486968] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    1.487018] pci 0000:00:1d.0: PME# disabled
[    1.487217] pci 0000:00:1f.2: reg 10 io port: [0xa880-0xa887]
[    1.487222] pci 0000:00:1f.2: reg 14 io port: [0xa800-0xa803]
[    1.487227] pci 0000:00:1f.2: reg 18 io port: [0xa480-0xa487]
[    1.487231] pci 0000:00:1f.2: reg 1c io port: [0xa400-0xa403]
[    1.487236] pci 0000:00:1f.2: reg 20 io port: [0xa080-0xa09f]
[    1.487240] pci 0000:00:1f.2: reg 24 32bit mmio: [0xfbaf7000-0xfbaf77ff]
[    1.487267] pci 0000:00:1f.2: PME# supported from D3hot
[    1.487314] pci 0000:00:1f.2: PME# disabled
[    1.487381] pci 0000:00:1f.3: reg 10 64bit mmio: [0xfbafc000-0xfbafc0ff]
[    1.487392] pci 0000:00:1f.3: reg 20 io port: [0xffe0-0xffff]
[    1.487432] pci 0000:01:00.0: reg 10 64bit mmio: [0xd0000000-0xdfffffff]
[    1.487440] pci 0000:01:00.0: reg 18 64bit mmio: [0xfbbe0000-0xfbbeffff]
[    1.487444] pci 0000:01:00.0: reg 20 io port: [0xb000-0xb0ff]
[    1.487451] pci 0000:01:00.0: reg 30 32bit mmio: [0xfbbc0000-0xfbbdffff]
[    1.487467] pci 0000:01:00.0: supports D1 D2
[    1.487495] pci 0000:01:00.1: reg 10 64bit mmio: [0xfbbfc000-0xfbbfffff]
[    1.487525] pci 0000:01:00.1: supports D1 D2
[    1.487553] pci 0000:00:03.0: bridge io port: [0xb000-0xbfff]
[    1.487556] pci 0000:00:03.0: bridge 32bit mmio: [0xfbb00000-0xfbbfffff]
[    1.487560] pci 0000:00:03.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    1.487753] pci 0000:03:00.0: reg 24 32bit mmio: [0xfbdfa000-0xfbdfbfff]
[    1.487788] pci 0000:03:00.0: PME# supported from D3hot
[    1.487838] pci 0000:03:00.0: PME# disabled
[    1.487930] pci 0000:03:00.1: reg 10 io port: [0xdc00-0xdc07]
[    1.487938] pci 0000:03:00.1: reg 14 io port: [0xd880-0xd883]
[    1.487946] pci 0000:03:00.1: reg 18 io port: [0xd800-0xd807]
[    1.487953] pci 0000:03:00.1: reg 1c io port: [0xd480-0xd483]
[    1.487961] pci 0000:03:00.1: reg 20 io port: [0xd400-0xd40f]
[    1.488043] pci 0000:00:1c.6: bridge io port: [0xd000-0xdfff]
[    1.488046] pci 0000:00:1c.6: bridge 32bit mmio: [0xfbd00000-0xfbdfffff]
[    1.488091] pci 0000:02:00.0: reg 10 io port: [0xc800-0xc8ff]
[    1.488109] pci 0000:02:00.0: reg 18 64bit mmio: [0xfafff000-0xfaffffff]
[    1.488121] pci 0000:02:00.0: reg 20 64bit mmio: [0xfaff8000-0xfaffbfff]
[    1.488128] pci 0000:02:00.0: reg 30 32bit mmio: [0xfbcf0000-0xfbcfffff]
[    1.488164] pci 0000:02:00.0: supports D1 D2
[    1.488166] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.488217] pci 0000:02:00.0: PME# disabled
[    1.488312] pci 0000:00:1c.7: bridge io port: [0xc000-0xcfff]
[    1.488315] pci 0000:00:1c.7: bridge 32bit mmio: [0xfbc00000-0xfbcfffff]
[    1.488319] pci 0000:00:1c.7: bridge 64bit mmio pref: [0xfaf00000-0xfaffffff]
[    1.488354] pci 0000:07:04.0: reg 10 32bit mmio: [0xfbeff000-0xfbeff7ff]
[    1.488360] pci 0000:07:04.0: reg 14 io port: [0xec00-0xec7f]
[    1.488398] pci 0000:07:04.0: supports D2
[    1.488400] pci 0000:07:04.0: PME# supported from D2 D3hot D3cold
[    1.488449] pci 0000:07:04.0: PME# disabled
[    1.488529] pci 0000:00:1e.0: transparent bridge
[    1.488576] pci 0000:00:1e.0: bridge io port: [0xe000-0xefff]
[    1.488579] pci 0000:00:1e.0: bridge 32bit mmio: [0xfbe00000-0xfbefffff]
[    1.488608] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.488747] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR1E._PRT]
[    1.488850] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
[    1.488903] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR20._PRT]
[    1.488948] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR24._PRT]
[    1.488994] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR25._PRT]
[    1.489039] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR26._PRT]
[    1.489094] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR27._PRT]
[    1.506815] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12 14 15)
[    1.507256] ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
[    1.507479] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 11 12 14 *15)
[    1.507918] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 *11 12 14 15)
[    1.508357] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12
14 15) *0, disabled.
[    1.508860] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12 *14 15)
[    1.509298] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 6 7 10 11 12 14 15)
[    1.509736] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 *7 10 11 12 14 15)
[    1.510187] SCSI subsystem initialized
[    1.510310] libata version 3.00 loaded.
[    1.510350] usbcore: registered new interface driver usbfs
[    1.510402] usbcore: registered new interface driver hub
[    1.510465] usbcore: registered new device driver usb
[    1.510579] ACPI: WMI: Mapper loaded
[    1.511259] PCI: Using ACPI for IRQ routing
[    1.531794] Bluetooth: Core ver 2.15
[    1.531867] NET: Registered protocol family 31
[    1.531912] Bluetooth: HCI device and connection manager initialized
[    1.531960] Bluetooth: HCI socket layer initialized
[    1.532006] NetLabel: Initializing
[    1.532049] NetLabel:  domain hash size = 128
[    1.532093] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.532146] NetLabel:  unlabeled traffic allowed by default
[    1.532227] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 25, 26, 27, 28, 0
[    1.532515] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.541788] hpet: hpet2 irq 24 for MSI
[    1.542949] hpet: hpet3 irq 25 for MSI
[    1.552923] hpet: hpet4 irq 26 for MSI
[    1.562916] hpet: hpet5 irq 27 for MSI
[    1.563214] hpet: hpet6 irq 28 for MSI
[    1.581758] Switched to high resolution mode on CPU 0
[    1.582898] Switched to high resolution mode on CPU 2
[    1.582905] Switched to high resolution mode on CPU 3
[    1.582911] Switched to high resolution mode on CPU 1
[    1.583203] Switched to high resolution mode on CPU 4
[    1.583240] Switched to high resolution mode on CPU 6
[    1.583248] Switched to high resolution mode on CPU 5
[    1.583251] Switched to high resolution mode on CPU 7
[    1.601729] pnp: PnP ACPI init
[    1.601790] ACPI: bus type pnp registered
[    1.604294] pnp: PnP ACPI: found 16 devices
[    1.604340] ACPI: ACPI bus type pnp unregistered
[    1.604391] system 00:01: iomem range 0xfc000000-0xfcffffff has been reserved
[    1.604441] system 00:01: iomem range 0xfd000000-0xfdffffff has been reserved
[    1.604491] system 00:01: iomem range 0xfe000000-0xfebfffff has been reserved
[    1.604540] system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
[    1.604592] system 00:06: ioport range 0x290-0x29f has been reserved
[    1.604643] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
[    1.604691] system 00:07: ioport range 0x800-0x87f has been reserved
[    1.604739] system 00:07: ioport range 0x500-0x57f has been reserved
[    1.604788] system 00:07: ioport range 0x600-0x607 has been reserved
[    1.604837] system 00:07: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    1.604886] system 00:07: iomem range 0xfed20000-0xfed3ffff has been reserved
[    1.604936] system 00:07: iomem range 0xfed40000-0xfed8ffff has been reserved
[    1.604987] system 00:0a: iomem range 0xffc00000-0xffdfffff has been reserved
[    1.605039] system 00:0c: iomem range 0xfec00000-0xfec00fff could
not be reserved
[    1.605100] system 00:0c: iomem range 0xfee00000-0xfee00fff has been reserved
[    1.605152] system 00:0e: iomem range 0xe0000000-0xefffffff has been reserved
[    1.605204] system 00:0f: iomem range 0x0-0x9ffff could not be reserved
[    1.605252] system 00:0f: iomem range 0xc0000-0xcffff has been reserved
[    1.605301] system 00:0f: iomem range 0xe0000-0xfffff could not be reserved
[    1.605351] system 00:0f: iomem range 0x100000-0xbfffffff could not
be reserved
[    1.605412] system 00:0f: iomem range 0xfed90000-0xffffffff could
not be reserved
[    1.610063] AppArmor: AppArmor Filesystem Enabled
[    1.610154] pci 0000:00:03.0: PCI bridge, secondary bus 0000:01
[    1.610202] pci 0000:00:03.0:   IO window: 0xb000-0xbfff
[    1.610251] pci 0000:00:03.0:   MEM window: 0xfbb00000-0xfbbfffff
[    1.610300] pci 0000:00:03.0:   PREFETCH window:
0x000000d0000000-0x000000dfffffff
[    1.610363] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:06
[    1.610410] pci 0000:00:1c.0:   IO window: disabled
[    1.610458] pci 0000:00:1c.0:   MEM window: disabled
[    1.610505] pci 0000:00:1c.0:   PREFETCH window: disabled
[    1.610553] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:05
[    1.610600] pci 0000:00:1c.4:   IO window: disabled
[    1.610648] pci 0000:00:1c.4:   MEM window: disabled
[    1.610695] pci 0000:00:1c.4:   PREFETCH window: disabled
[    1.610744] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:04
[    1.610791] pci 0000:00:1c.5:   IO window: disabled
[    1.610838] pci 0000:00:1c.5:   MEM window: disabled
[    1.610886] pci 0000:00:1c.5:   PREFETCH window: disabled
[    1.610934] pci 0000:00:1c.6: PCI bridge, secondary bus 0000:03
[    1.610982] pci 0000:00:1c.6:   IO window: 0xd000-0xdfff
[    1.611031] pci 0000:00:1c.6:   MEM window: 0xfbd00000-0xfbdfffff
[    1.611080] pci 0000:00:1c.6:   PREFETCH window: disabled
[    1.611128] pci 0000:00:1c.7: PCI bridge, secondary bus 0000:02
[    1.611176] pci 0000:00:1c.7:   IO window: 0xc000-0xcfff
[    1.611225] pci 0000:00:1c.7:   MEM window: 0xfbc00000-0xfbcfffff
[    1.611274] pci 0000:00:1c.7:   PREFETCH window:
0x000000faf00000-0x000000faffffff
[    1.611339] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:07
[    1.611387] pci 0000:00:1e.0:   IO window: 0xe000-0xefff
[    1.611436] pci 0000:00:1e.0:   MEM window: 0xfbe00000-0xfbefffff
[    1.611485] pci 0000:00:1e.0:   PREFETCH window: disabled
[    1.611537]   alloc irq_desc for 16 on node 0
[    1.611538]   alloc kstat_irqs on node 0
[    1.611542] pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.611592] pci 0000:00:03.0: setting latency timer to 64
[    1.611597]   alloc irq_desc for 17 on node 0
[    1.611598]   alloc kstat_irqs on node 0
[    1.611601] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.611651] pci 0000:00:1c.0: setting latency timer to 64
[    1.611656] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.611712] pci 0000:00:1c.4: setting latency timer to 64
[    1.611717] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    1.611767] pci 0000:00:1c.5: setting latency timer to 64
[    1.611772]   alloc irq_desc for 18 on node 0
[    1.611773]   alloc kstat_irqs on node 0
[    1.611776] pci 0000:00:1c.6: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.611826] pci 0000:00:1c.6: setting latency timer to 64
[    1.611831]   alloc irq_desc for 19 on node 0
[    1.611832]   alloc kstat_irqs on node 0
[    1.611834] pci 0000:00:1c.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    1.611885] pci 0000:00:1c.7: setting latency timer to 64
[    1.611889] pci 0000:00:1e.0: setting latency timer to 64
[    1.611892] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    1.611894] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    1.611895] pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
[    1.611897] pci_bus 0000:01: resource 1 mem: [0xfbb00000-0xfbbfffff]
[    1.611899] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xdfffffff]
[    1.611900] pci_bus 0000:03: resource 0 io:  [0xd000-0xdfff]
[    1.611902] pci_bus 0000:03: resource 1 mem: [0xfbd00000-0xfbdfffff]
[    1.611904] pci_bus 0000:02: resource 0 io:  [0xc000-0xcfff]
[    1.611905] pci_bus 0000:02: resource 1 mem: [0xfbc00000-0xfbcfffff]
[    1.611907] pci_bus 0000:02: resource 2 pref mem [0xfaf00000-0xfaffffff]
[    1.611908] pci_bus 0000:07: resource 0 io:  [0xe000-0xefff]
[    1.611910] pci_bus 0000:07: resource 1 mem: [0xfbe00000-0xfbefffff]
[    1.611911] pci_bus 0000:07: resource 3 io:  [0x00-0xffff]
[    1.611913] pci_bus 0000:07: resource 4 mem: [0x000000-0xffffffffffffffff]
[    1.611933] NET: Registered protocol family 2
[    1.612087] IP route cache hash table entries: 131072 (order: 8,
1048576 bytes)
[    1.612793] TCP established hash table entries: 524288 (order: 11,
8388608 bytes)
[    1.615031] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.615345] TCP: Hash tables configured (established 524288 bind 65536)
[    1.615394] TCP reno registered
[    1.615502] NET: Registered protocol family 1
[    1.615584] Trying to unpack rootfs image as initramfs...
[    2.633306] Freeing initrd memory: 66196k freed
[    2.642103] Scanning for low memory corruption every 60 seconds
[    2.642230] audit: initializing netlink socket (disabled)
[    2.642286] type=2000 audit(1272190224.430:1): initialized
[    2.649418] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.650419] VFS: Disk quotas dquot_6.5.2
[    2.650499] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.650934] fuse init (API version 7.12)
[    2.651029] msgmni has been set to 7911
[    2.651240] alg: No test for stdrng (krng)
[    2.651291] io scheduler noop registered
[    2.651336] io scheduler anticipatory registered
[    2.651381] io scheduler deadline registered
[    2.651453] io scheduler cfq registered (default)
[    2.689907] pci 0000:01:00.0: Boot video device
[    2.690029]   alloc irq_desc for 29 on node 0
[    2.690031]   alloc kstat_irqs on node 0
[    2.690037] pcieport-driver 0000:00:03.0: irq 29 for MSI/MSI-X
[    2.690042] pcieport-driver 0000:00:03.0: setting latency timer to 64
[    2.690134]   alloc irq_desc for 30 on node 0
[    2.690135]   alloc kstat_irqs on node 0
[    2.690141] pcieport-driver 0000:00:1c.0: irq 30 for MSI/MSI-X
[    2.690147] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    2.690244]   alloc irq_desc for 31 on node 0
[    2.690245]   alloc kstat_irqs on node 0
[    2.690250] pcieport-driver 0000:00:1c.4: irq 31 for MSI/MSI-X
[    2.690256] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[    2.690350]   alloc irq_desc for 32 on node 0
[    2.690352]   alloc kstat_irqs on node 0
[    2.690357] pcieport-driver 0000:00:1c.5: irq 32 for MSI/MSI-X
[    2.690363] pcieport-driver 0000:00:1c.5: setting latency timer to 64
[    2.690458]   alloc irq_desc for 33 on node 0
[    2.690460]   alloc kstat_irqs on node 0
[    2.690465] pcieport-driver 0000:00:1c.6: irq 33 for MSI/MSI-X
[    2.690471] pcieport-driver 0000:00:1c.6: setting latency timer to 64
[    2.690568]   alloc irq_desc for 34 on node 0
[    2.690569]   alloc kstat_irqs on node 0
[    2.690575] pcieport-driver 0000:00:1c.7: irq 34 for MSI/MSI-X
[    2.690581] pcieport-driver 0000:00:1c.7: setting latency timer to 64
[    2.690645] Firmware did not grant requested _OSC control
[    2.690647] aer 0000:00:03.0:pcie02: AER service couldn't init
device: no _OSC support
[    2.690653] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.690709] Firmware did not grant requested _OSC control
[    2.690720] Firmware did not grant requested _OSC control
[    2.690730] Firmware did not grant requested _OSC control
[    2.690739] Firmware did not grant requested _OSC control
[    2.690748] Firmware did not grant requested _OSC control
[    2.690766] Firmware did not grant requested _OSC control
[    2.690775] Firmware did not grant requested _OSC control
[    2.690784] Firmware did not grant requested _OSC control
[    2.690793] Firmware did not grant requested _OSC control
[    2.690802] Firmware did not grant requested _OSC control
[    2.690811] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.690927] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    2.690989] ACPI: Power Button [PWRF]
[    2.691067] input: Power Button as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    2.691130] ACPI: Power Button [PWRB]
[    2.692315] ACPI: SSDT 00000000bf788150 0244C (v01 DpgPmm  P001Ist
00000011 INTL 20060113)
[    2.692857] ACPI: SSDT 00000000bf78a5a0 00659 (v01  PmRef  P001Cst
00003001 INTL 20060113)
[    2.693443] Monitor-Mwait will be used to enter C-1 state
[    2.693457] Monitor-Mwait will be used to enter C-2 state
[    2.693469] Monitor-Mwait will be used to enter C-3 state
[    2.693483] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    2.693648] processor LNXCPU:00: registered as cooling_device0
[    2.693995] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    2.694157] processor LNXCPU:01: registered as cooling_device1
[    2.694512] ACPI: CPU2 (power states: C1[C1] C2[C2] C3[C3])
[    2.694673] processor LNXCPU:02: registered as cooling_device2
[    2.695018] ACPI: CPU3 (power states: C1[C1] C2[C2] C3[C3])
[    2.695180] processor LNXCPU:03: registered as cooling_device3
[    2.695530] ACPI: CPU4 (power states: C1[C1] C2[C2] C3[C3])
[    2.695692] processor LNXCPU:04: registered as cooling_device4
[    2.696044] ACPI: CPU5 (power states: C1[C1] C2[C2] C3[C3])
[    2.696206] processor LNXCPU:05: registered as cooling_device5
[    2.696547] ACPI: CPU6 (power states: C1[C1] C2[C2] C3[C3])
[    2.696709] processor LNXCPU:06: registered as cooling_device6
[    2.697050] ACPI: CPU7 (power states: C1[C1] C2[C2] C3[C3])
[    2.697212] processor LNXCPU:07: registered as cooling_device7
[    2.700147] Linux agpgart interface v0.103
[    2.700196] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.700331] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.700621] 00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.701247] brd: module loaded
[    2.701545] loop: module loaded
[    2.701630] input: Macintosh mouse button emulation as
/devices/virtual/input/input2
[    2.701742] ahci 0000:00:1f.2: version 3.0
[    2.701751]   alloc irq_desc for 21 on node 0
[    2.701752]   alloc kstat_irqs on node 0
[    2.701756] ahci 0000:00:1f.2: PCI INT D -> GSI 21 (level, low) -> IRQ 21
[    2.701826]   alloc irq_desc for 35 on node 0
[    2.701827]   alloc kstat_irqs on node 0
[    2.701833] ahci 0000:00:1f.2: irq 35 for MSI/MSI-X
[    2.701855] ahci: SSS flag set, parallel bus scan disabled
[    2.719878] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3
Gbps 0x3f impl SATA mode
[    2.719947] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led
clo pmp pio slum part ems
[    2.720011] ahci 0000:00:1f.2: setting latency timer to 64
[    2.819723] scsi0 : ahci
[    2.819817] scsi1 : ahci
[    2.819888] scsi2 : ahci
[    2.819960] scsi3 : ahci
[    2.820034] scsi4 : ahci
[    2.820104] scsi5 : ahci
[    2.820226] ata1: SATA max UDMA/133 abar m2048@0xfbaf7000 port
0xfbaf7100 irq 35
[    2.820288] ata2: SATA max UDMA/133 abar m2048@0xfbaf7000 port
0xfbaf7180 irq 35
[    2.820349] ata3: SATA max UDMA/133 abar m2048@0xfbaf7000 port
0xfbaf7200 irq 35
[    2.820411] ata4: SATA max UDMA/133 abar m2048@0xfbaf7000 port
0xfbaf7280 irq 35
[    2.820472] ata5: SATA max UDMA/133 abar m2048@0xfbaf7000 port
0xfbaf7300 irq 35
[    2.820534] ata6: SATA max UDMA/133 abar m2048@0xfbaf7000 port
0xfbaf7380 irq 35
[    2.820630] ahci 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.839665] ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3
Gbps 0x3 impl SATA mode
[    2.839736] ahci 0000:03:00.0: flags: 64bit ncq led clo pmp pio
[    2.839787] ahci 0000:03:00.0: setting latency timer to 64
[    2.839869] scsi6 : ahci
[    2.839939] scsi7 : ahci
[    2.840024] ata7: SATA max UDMA/133 abar m8192@0xfbdfa000 port
0xfbdfa100 irq 18
[    2.840086] ata8: SATA max UDMA/133 abar m8192@0xfbdfa000 port
0xfbdfa180 irq 18
[    2.840366] pata_jmicron 0000:03:00.1: PCI INT B -> GSI 19 (level,
low) -> IRQ 19
[    2.840443] pata_jmicron 0000:03:00.1: setting latency timer to 64
[    2.840482] scsi8 : pata_jmicron
[    2.840556] scsi9 : pata_jmicron
[    2.840999] ata9: PATA max UDMA/100 cmd 0xdc00 ctl 0xd880 bmdma 0xd400 irq 19
[    2.841049] ata10: PATA max UDMA/100 cmd 0xd800 ctl 0xd480 bmdma
0xd408 irq 19
[    2.841399] Fixed MDIO Bus: probed
[    2.841461] PPP generic driver version 2.4.2
[    2.841550] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.842257] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.842314] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    2.842317] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    2.842380] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned
bus number 1
[    2.846324] ehci_hcd 0000:00:1a.0: debug port 2
[    2.846372] ehci_hcd 0000:00:1a.0: cache line size of 32 is not supported
[    2.846381] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xfbafe000
[    2.869587] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    2.869688] usb usb1: configuration #1 chosen from 1 choice
[    2.869752] hub 1-0:1.0: USB hub found
[    2.869799] hub 1-0:1.0: 2 ports detected
[    2.869886]   alloc irq_desc for 23 on node 0
[    2.869888]   alloc kstat_irqs on node 0
[    2.869892] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.869948] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.869951] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    2.870014] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 2
[    2.873959] ehci_hcd 0000:00:1d.0: debug port 2
[    2.874008] ehci_hcd 0000:00:1d.0: cache line size of 32 is not supported
[    2.874017] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xfbafd000
[    2.889554] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    2.889646] usb usb2: configuration #1 chosen from 1 choice
[    2.889706] hub 2-0:1.0: USB hub found
[    2.889752] hub 2-0:1.0: 2 ports detected
[    2.889830] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.889885] uhci_hcd: USB Universal Host Controller Interface driver
[    2.889988] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    2.890036] PNP: PS/2 appears to have AUX port disabled, if this is
incorrect please boot with i8042.nopnp
[    2.890558] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.890642] mice: PS/2 mouse device common for all mice
[    2.890734] rtc_cmos 00:03: RTC can wake from S4
[    2.890795] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    2.890864] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    2.890989] device-mapper: uevent: version 1.0.3
[    2.891077] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01)
initialised: dm-devel@redhat.com
[    2.891221] device-mapper: multipath: version 1.1.0 loaded
[    2.891268] device-mapper: multipath round-robin: version 1.0.0 loaded
[    2.891629] cpuidle: using governor ladder
[    2.891902] cpuidle: using governor menu
[    2.892213] TCP cubic registered
[    2.892336] NET: Registered protocol family 10
[    2.892676] lo: Disabled Privacy Extensions
[    2.892910] NET: Registered protocol family 17
[    2.892963] Bluetooth: L2CAP ver 2.13
[    2.893007] Bluetooth: L2CAP socket layer initialized
[    2.893053] Bluetooth: SCO (Voice Link) ver 0.6
[    2.893098] Bluetooth: SCO socket layer initialized
[    2.893155] Bluetooth: RFCOMM TTY layer initialized
[    2.893201] Bluetooth: RFCOMM socket layer initialized
[    2.893247] Bluetooth: RFCOMM ver 1.11
[    2.895830] PM: Resume from disk failed.
[    2.895835] registered taskstats version 1
[    2.895954]   Magic number: 6:541:174
[    2.896012] acpi device:37: hash matches
[    2.896063] acpi device:0a: hash matches
[    2.896205] rtc_cmos 00:03: setting system clock to 2010-04-25
10:10:25 UTC (1272190225)
[    2.896275] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.896321] EDD information not available.
[    2.910176] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input3
[    2.999819] ata9.01: NODEV after polling detection
[    3.020272] ata9.00: ATAPI: PLEXTOR DVDR   PX-740A, 1.02, max UDMA/33
[    3.063942] ata9.00: configured for UDMA/33
[    3.189223] ata7: SATA link down (SStatus 0 SControl 300)
[    3.189314] ata8: SATA link down (SStatus 0 SControl 300)
[    3.199196] usb 1-1: new high speed USB device using ehci_hcd and address 2
[    3.348939] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.353763] usb 1-1: configuration #1 chosen from 1 choice
[    3.354099] hub 1-1:1.0: USB hub found
[    3.354271] hub 1-1:1.0: 6 ports detected
[    3.366808] ata1.00: ATA-7: HDS728080PLA380, PF2OA60A, max UDMA/133
[    3.366869] ata1.00: 160836480 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    3.368030] ata1.00: configured for UDMA/133
[    3.391488] scsi 0:0:0:0: Direct-Access     ATA
HDS728080PLA380  PF2O PQ: 0 ANSI: 5
[    3.391719] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.391791] sd 0:0:0:0: [sda] 160836480 512-byte logical blocks:
(82.3 GB/76.6 GiB)
[    3.391872] sd 0:0:0:0: [sda] Write Protect is off
[    3.391918] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.391932] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    3.392049]  sda: sda1 sda2 sda3 sda4
[    3.416551] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.468697] usb 2-1: new high speed USB device using ehci_hcd and address 2
[    3.622267] usb 2-1: configuration #1 chosen from 1 choice
[    3.622527] hub 2-1:1.0: USB hub found
[    3.622725] hub 2-1:1.0: 8 ports detected
[    3.698488] usb 1-1.3: new high speed USB device using ehci_hcd and address 3
[    3.811025] usb 1-1.3: configuration #1 chosen from 1 choice
[    3.898186] usb 2-1.3: new low speed USB device using ehci_hcd and address 3
[    4.013452] usb 2-1.3: configuration #1 chosen from 1 choice
[    4.087907] usb 2-1.4: new high speed USB device using ehci_hcd and address 4
[    4.275954] usb 2-1.4: configuration #1 chosen from 1 choice
[    4.317329] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.338405] ata2.00: ATA-7: HDS728080PLA380, PF2OA60A, max UDMA/133
[    4.338466] ata2.00: 160836480 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    4.339643] ata2.00: configured for UDMA/133
[    4.357432] scsi 1:0:0:0: Direct-Access     ATA
HDS728080PLA380  PF2O PQ: 0 ANSI: 5
[    4.357638] usb 2-1.6: new low speed USB device using ehci_hcd and address 5
[    4.357640] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    4.357661] sd 1:0:0:0: [sdb] 160836480 512-byte logical blocks:
(82.3 GB/76.6 GiB)
[    4.357690] sd 1:0:0:0: [sdb] Write Protect is off
[    4.357691] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    4.357702] sd 1:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    4.357770]  sdb: sdb1 sdb2 sdb3 sdb4
[    4.379765] sd 1:0:0:0: [sdb] Attached SCSI disk
[    4.475732] usb 2-1.6: configuration #1 chosen from 1 choice
[    5.285674] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.305917] ata3.00: ATA-8: Hitachi HDP725050GLA360, GM4OA5CA, max UDMA/133
[    5.305979] ata3.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    5.307132] ata3.00: configured for UDMA/133
[    5.325721] scsi 2:0:0:0: Direct-Access     ATA      Hitachi
HDP72505 GM4O PQ: 0 ANSI: 5
[    5.325955] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    5.325964] sd 2:0:0:0: [sdc] 976773168 512-byte logical blocks:
(500 GB/465 GiB)
[    5.325992] sd 2:0:0:0: [sdc] Write Protect is off
[    5.325993] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    5.326003] sd 2:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    5.326054]  sdc: sdc1
[    5.355506] sd 2:0:0:0: [sdc] Attached SCSI disk
[    5.675046] ata4: SATA link down (SStatus 0 SControl 300)
[    6.044399] ata5: SATA link down (SStatus 0 SControl 300)
[    6.413775] ata6: SATA link down (SStatus 0 SControl 300)
[    6.436201] scsi 8:0:0:0: CD-ROM            PLEXTOR  DVDR   PX-740A
  1.02 PQ: 0 ANSI: 5
[    6.444707] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[    6.444757] Uniform CD-ROM driver Revision: 3.20
[    6.444839] sr 8:0:0:0: Attached scsi CD-ROM sr0
[    6.444858] sr 8:0:0:0: Attached scsi generic sg3 type 5
[    6.615290] Freeing unused kernel memory: 664k freed
[    6.615414] Write protecting the kernel read-only data: 7476k
[    6.691457] [drm] Initialized drm 1.1.0 20060810
[    6.698176] Initializing USB Mass Storage driver...
[    6.698329] scsi10 : SCSI emulation for USB Mass Storage devices
[    6.698445] usb-storage: device found at 3
[    6.698447] usb-storage: waiting for device to settle before scanning
[    6.698467] usbcore: registered new interface driver usb-storage
[    6.698515] USB Mass Storage support registered.
[    6.701141] usbcore: registered new interface driver hiddev
[    6.704958] input: Logitech USB-PS/2 Optical Mouse as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0/input/input4
[    6.705151] generic-usb 0003:046D:C01E.0001: input,hidraw0: USB HID
v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on
usb-0000:00:1d.0-1.3/input0
[    6.708744] input: PS/2+USB Mouse as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6:1.0/input/input5
[    6.708912] generic-usb 0003:1267:0210.0002: input,hidraw1: USB HID
v1.00 Mouse [PS/2+USB Mouse] on usb-0000:00:1d.0-1.6/input0
[    6.708987] usbcore: registered new interface driver usbhid
[    6.709034] usbhid: v2.6:USB HID core driver
[    6.711805] [drm] radeon default to kernel modesetting DISABLED.
[    6.712260] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.712322] pci 0000:01:00.0: setting latency timer to 64
[    6.712492] [drm] Initialized radeon 1.31.0 20080528 for
0000:01:00.0 on minor 0
[    6.722249] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    6.722315] r8169 0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    6.722435] r8169 0000:02:00.0: setting latency timer to 64
[    6.722478]   alloc irq_desc for 36 on node 0
[    6.722480]   alloc kstat_irqs on node 0
[    6.722491] r8169 0000:02:00.0: irq 36 for MSI/MSI-X
[    6.723282] eth0: RTL8168d/8111d at 0xffffc90000668000,
e0:cb:4e:1b:b7:84, XID 283000c0 IRQ 36
[    6.727197] ohci1394 0000:07:04.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    6.795119] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]
MMIO=[fbeff000-fbeff7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    6.813895] md: bind<sdb2>
[    6.815124] md: bind<sdb1>
[    6.818032] md: bind<sdb3>
[    6.818474] md: bind<sdb4>
[    6.829803] md: bind<sda2>
[    6.833570] md: raid1 personality registered for level 1
[    6.833934] raid1: raid set md1 active with 2 out of 2 mirrors
[    6.834024] md1: detected capacity change from 0 to 15002828800
[    6.834904] md: bind<sda3>
[    6.835312]  md1:
[    6.836359] md: bind<sda4>
[    6.836531] raid1: raid set md2 active with 2 out of 2 mirrors
[    6.836587] md2: detected capacity change from 0 to 66599976960
[    6.837262]  md2:
[    6.838253] md: raid0 personality registered for level 0
[    6.838459] raid0: looking at sda4
[    6.838506] raid0:   comparing sda4(1060096)
[    6.838539]  with sda4(1060096)
[    6.838618] raid0:   END
[    6.838659] raid0:   ==> UNIQUE
[    6.838701] raid0: 1 zones
[    6.838743] raid0: looking at sdb4
[    6.839419] raid0:   comparing sdb4(1060096)
[    6.839452]  with sda4(1060096)
[    6.839531] raid0:   EQUAL
[    6.839572] raid0: FINAL 1 zones
[    6.839615] raid0: done.
[    6.839656] raid0 : md_size is 2120192 sectors.
[    6.839701] ******* md3 configuration *********
[    6.839745] zone0=[sda4/sdb4/]
[    6.839865]         zone offset=0kb device offset=0kb size=1060096kb
[    6.839912] **********************************
[    6.839913]
[    6.839999] md3: detected capacity change from 0 to 1085538304
[    6.840325]  unknown partition table
[    6.840780]  md3:
[    6.842026] md: bind<sda1>
[    6.842169]  unknown partition table
[    6.842266]  unknown partition table
[    6.878193] raid1: raid set md0 active with 2 out of 2 mirrors
[    6.878278] md0: detected capacity change from 0 to 197263360
[    6.879129]  md0: unknown partition table
[    8.102238] md: linear personality registered for level -1
[    8.103766] md: multipath personality registered for level -4
[    8.107046] xor: automatically using best checksumming function: generic_sse
[    8.153227]    generic_sse: 15841.600 MB/sec
[    8.153228] xor: using function: generic_sse (15841.600 MB/sec)
[    8.160148] async_tx: api initialized (async)
[    8.160936] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[001e8c0000c1f807]
[    8.332917] raid6: int64x1   3005 MB/s
[    8.502650] raid6: int64x2   3595 MB/s
[    8.672364] raid6: int64x4   2641 MB/s
[    8.842089] raid6: int64x8   2657 MB/s
[    9.011773] raid6: sse2x1    8390 MB/s
[    9.181500] raid6: sse2x2    9892 MB/s
[    9.351212] raid6: sse2x4   11141 MB/s
[    9.351213] raid6: using algorithm sse2x4 (11141 MB/s)
[    9.353591] md: raid6 personality registered for level 6
[    9.353593] md: raid5 personality registered for level 5
[    9.353594] md: raid4 personality registered for level 4
[    9.357723] md: raid10 personality registered for level 10
[    9.397848] PM: Starting manual resume from disk
[    9.397850] PM: Resume from partition 9:3
[    9.397851] PM: Checking hibernation image.
[    9.397971] PM: Resume from disk failed.
[    9.425343] EXT4-fs (md1): barriers enabled
[    9.435384] kjournald2 starting: pid 552, dev md1:8, commit
interval 5 seconds
[    9.436592] EXT4-fs (md1): delayed allocation enabled
[    9.436598] EXT4-fs: file extents enabled
[    9.437006] EXT4-fs: mballoc enabled
[    9.437012] EXT4-fs (md1): mounted filesystem with ordered data mode
[    9.998048] type=1505 audit(1272190232.613:2):
operation="profile_load" pid=586
name=/usr/share/gdm/guest-session/Xsession
[   10.012342] type=1505 audit(1272190232.625:3):
operation="profile_load" pid=587 name=/sbin/dhclient3
[   10.012687] type=1505 audit(1272190232.625:4):
operation="profile_load" pid=587
name=/usr/lib/NetworkManager/nm-dhcp-client.action
[   10.012861] type=1505 audit(1272190232.625:5):
operation="profile_load" pid=587
name=/usr/lib/connman/scripts/dhclient-script
[   10.040097] type=1505 audit(1272190232.653:6):
operation="profile_load" pid=588 name=/usr/bin/evince
[   10.045203] type=1505 audit(1272190232.653:7):
operation="profile_load" pid=588 name=/usr/bin/evince-previewer
[   10.048200] type=1505 audit(1272190232.663:8):
operation="profile_load" pid=588 name=/usr/bin/evince-thumbnailer
[   10.077246] type=1505 audit(1272190232.683:9):
operation="profile_load" pid=590 name=/usr/lib/cups/backend/cups-pdf
[   10.077627] type=1505 audit(1272190232.693:10):
operation="profile_load" pid=590 name=/usr/sbin/cupsd
[   10.099442] type=1505 audit(1272190232.713:11):
operation="profile_load" pid=591 name=/usr/sbin/mysqld-akonadi
[   11.685433] usb-storage: device scan complete
[   11.686232] scsi 10:0:0:0: Direct-Access     Generic  USB SD Reader
   1.00 PQ: 0 ANSI: 0
[   11.686970] scsi 10:0:0:1: Direct-Access     Generic  USB CF Reader
   1.01 PQ: 0 ANSI: 0
[   11.687839] scsi 10:0:0:2: Direct-Access     Generic  USB SM Reader
   1.02 PQ: 0 ANSI: 0
[   11.688691] scsi 10:0:0:3: Direct-Access     Generic  USB MS Reader
   1.03 PQ: 0 ANSI: 0
[   11.689426] sd 10:0:0:0: Attached scsi generic sg4 type 0
[   11.689472] sd 10:0:0:1: Attached scsi generic sg5 type 0
[   11.689534] sd 10:0:0:2: Attached scsi generic sg6 type 0
[   11.689581] sd 10:0:0:3: Attached scsi generic sg7 type 0
[   11.693110] sd 10:0:0:0: [sdd] Attached SCSI removable disk
[   11.693856] sd 10:0:0:1: [sde] Attached SCSI removable disk
[   11.694609] sd 10:0:0:2: [sdf] Attached SCSI removable disk
[   11.695444] sd 10:0:0:3: [sdg] Attached SCSI removable disk
[   28.708824] udev: starting version 147
[   28.749712] lp: driver loaded but no devices found
[   28.753665] Linux video capture interface: v2.00
[   28.756607] uvcvideo: Found UVC 1.00 device ViewSonic 1.3M, USB2.0
Webcam (04f2:b021)
[   28.760134] input: ViewSonic 1.3M, USB2.0 Webcam as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/2-1.4:1.0/input/input6
[   28.760173] usbcore: registered new interface driver uvcvideo
[   28.760176] USB Video Class driver (v0.1.0)
[   28.761554] ip_tables: (C) 2000-2006 Netfilter Core Team
[   28.842274]   alloc irq_desc for 22 on node 0
[   28.842277]   alloc kstat_irqs on node 0
[   28.842283] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level,
low) -> IRQ 22
[   28.842397] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   29.009593] HDA Intel 0000:01:00.1: PCI INT B -> GSI 17 (level,
low) -> IRQ 17
[   29.009623] HDA Intel 0000:01:00.1: setting latency timer to 64
[   29.022083] Adding 1060088k swap on /dev/md3.  Priority:-1
extents:1 across:1060088k
[   29.492939] EXT4-fs (md1): internal journal on md1:8
[   29.879302] EXT4-fs (md0): barriers enabled
[   29.879608] kjournald2 starting: pid 1214, dev md0:8, commit
interval 5 seconds
[   29.895604] EXT4-fs (md0): internal journal on md0:8
[   29.895610] EXT4-fs (md0): delayed allocation enabled
[   29.895615] EXT4-fs: file extents enabled
[   29.895652] EXT4-fs: mballoc enabled
[   29.895669] EXT4-fs (md0): mounted filesystem with ordered data mode
[   30.575506] EXT4-fs (md2): barriers enabled
[   30.575930] kjournald2 starting: pid 1227, dev md2:8, commit
interval 5 seconds
[   30.625268] EXT4-fs (md2): internal journal on md2:8
[   30.625275] EXT4-fs (md2): delayed allocation enabled
[   30.625279] EXT4-fs: file extents enabled
[   30.625439] EXT4-fs: mballoc enabled
[   30.625447] EXT4-fs (md2): mounted filesystem with ordered data mode
[   30.686188] r8169: eth0: link up
[   30.686192] r8169: eth0: link up
[   30.864001] __ratelimit: 3 callbacks suppressed
[   30.864003] type=1505 audit(1272190253.513:13):
operation="profile_replace" pid=1396
name=/usr/share/gdm/guest-session/Xsession
[   30.864982] type=1505 audit(1272190253.513:14):
operation="profile_replace" pid=1397 name=/sbin/dhclient3
[   30.865297] type=1505 audit(1272190253.513:15):
operation="profile_replace" pid=1397
name=/usr/lib/NetworkManager/nm-dhcp-client.action
[   30.865471] type=1505 audit(1272190253.513:16):
operation="profile_replace" pid=1397
name=/usr/lib/connman/scripts/dhclient-script
[   30.867225] type=1505 audit(1272190253.513:17):
operation="profile_replace" pid=1398 name=/usr/bin/evince
[   30.872265] type=1505 audit(1272190253.513:18):
operation="profile_replace" pid=1398 name=/usr/bin/evince-previewer
[   30.875315] type=1505 audit(1272190253.523:19):
operation="profile_replace" pid=1398 name=/usr/bin/evince-thumbnailer
[   30.880076] type=1505 audit(1272190253.523:20):
operation="profile_replace" pid=1400
name=/usr/lib/cups/backend/cups-pdf
[   30.880463] type=1505 audit(1272190253.523:21):
operation="profile_replace" pid=1400 name=/usr/sbin/cupsd
[   30.881725] type=1505 audit(1272190253.523:22):
operation="profile_replace" pid=1401 name=/usr/sbin/mysqld-akonadi
[   31.641911] usplash:487 freeing invalid memtype
ffffffffd0000000-ffffffffd1000000
[   32.176982] [drm] Setting GART location based on new memory map
[   32.192133] [drm] Loading RV710 PFP Microcode
[   32.192243] [drm] Loading RV710 CP Microcode
[   32.207430] [drm] Resetting GPU
[   32.207487] [drm] writeback test succeeded in 1 usecs
[   34.472120] CPU0 attaching NULL sched-domain.
[   34.472123] CPU1 attaching NULL sched-domain.
[   34.472124] CPU2 attaching NULL sched-domain.
[   34.472125] CPU3 attaching NULL sched-domain.
[   34.472126] CPU4 attaching NULL sched-domain.
[   34.472127] CPU5 attaching NULL sched-domain.
[   34.472128] CPU6 attaching NULL sched-domain.
[   34.472129] CPU7 attaching NULL sched-domain.
[   34.515577] CPU0 attaching sched-domain:
[   34.515579]  domain 0: span 0,4 level SIBLING
[   34.515581]   groups: 0 4
[   34.515583]   domain 1: span 0-7 level MC
[   34.515584]    groups: 0,4 1,5 2,6 3,7
[   34.515587] CPU1 attaching sched-domain:
[   34.515588]  domain 0: span 1,5 level SIBLING
[   34.515589]   groups: 1 5
[   34.515591]   domain 1: span 0-7 level MC
[   34.515592]    groups: 1,5 2,6 3,7 0,4
[   34.515595] CPU2 attaching sched-domain:
[   34.515596]  domain 0: span 2,6 level SIBLING
[   34.515597]   groups: 2 6
[   34.515598]   domain 1: span 0-7 level MC
[   34.515600]    groups: 2,6 3,7 0,4 1,5
[   34.515602] CPU3 attaching sched-domain:
[   34.515603]  domain 0: span 3,7 level SIBLING
[   34.515604]   groups: 3 7
[   34.515606]   domain 1: span 0-7 level MC
[   34.515607]    groups: 3,7 0,4 1,5 2,6
[   34.515610] CPU4 attaching sched-domain:
[   34.515610]  domain 0: span 0,4 level SIBLING
[   34.515612]   groups: 4 0
[   34.515613]   domain 1: span 0-7 level MC
[   34.515614]    groups: 0,4 1,5 2,6 3,7
[   34.515617] CPU5 attaching sched-domain:
[   34.515618]  domain 0: span 1,5 level SIBLING
[   34.515619]   groups: 5 1
[   34.515621]   domain 1: span 0-7 level MC
[   34.515622]    groups: 1,5 2,6 3,7 0,4
[   34.515624] CPU6 attaching sched-domain:
[   34.515625]  domain 0: span 2,6 level SIBLING
[   34.515626]   groups: 6 2
[   34.515628]   domain 1: span 0-7 level MC
[   34.515629]    groups: 2,6 3,7 0,4 1,5
[   34.515632] CPU7 attaching sched-domain:
[   34.515633]  domain 0: span 3,7 level SIBLING
[   34.515634]   groups: 7 3
[   34.515635]   domain 1: span 0-7 level MC
[   34.515636]    groups: 3,7 0,4 1,5 2,6
[   36.519789] RPC: Registered udp transport module.
[   36.519791] RPC: Registered tcp transport module.
[   37.683260] hda-intel: IRQ timing workaround is activated for card
#1. Suggest a bigger bdl_pos_adj.
[   39.014135] vboxdrv: Trying to deactivate the NMI watchdog permanently...
[   39.014137] vboxdrv: Successfully done.
[   39.014138] vboxdrv: Found 8 processor cores.
[   39.014177] VBoxDrv: dbg - g_abExecMemory=ffffffffa03d5480
[   39.015260] vboxdrv: fAsync=0 offMin=0x1f8 offMax=0x2007c
[   39.015287] vboxdrv: TSC mode is 'synchronous', kernel timer mode
is 'normal'.
[   39.015289] vboxdrv: Successfully loaded version 3.1.6 (interface
0x00100001).
[   39.273845] ppdev: user-space parallel port driver
[   41.031381] eth0: no IPv6 routers present
[   50.581816] svc: failed to register lockdv1 RPC service (errno 97).
[ 1336.673597] [drm] Resetting GPU
[ 1336.776337] mtrr: MTRR 3 not used
[ 1337.149537] [drm] Setting GART location based on new memory map
[ 1337.164890] [drm] Loading RV710 PFP Microcode
[ 1337.165018] [drm] Loading RV710 CP Microcode
[ 1337.180244] [drm] Resetting GPU
[ 1337.180303] [drm] writeback test succeeded in 1 usecs
[ 9229.608823] [drm] Resetting GPU
[ 9229.683872] mtrr: MTRR 3 not used
[ 9230.074634] [drm] Setting GART location based on new memory map
[ 9230.089988] [drm] Loading RV710 PFP Microcode
[ 9230.090116] [drm] Loading RV710 CP Microcode
[ 9230.105343] [drm] Resetting GPU
[ 9230.105403] [drm] writeback test succeeded in 1 usecs
[10786.234493] kjournald starting.  Commit interval 5 seconds
[10786.234555] EXT3-fs warning: maximal mount count reached, running
e2fsck is recommended
[10786.234929] EXT3 FS on sdc1, internal journal
[10786.234936] EXT3-fs: mounted filesystem with writeback data mode.
[11186.941269] kjournald starting.  Commit interval 5 seconds
[11186.941284] EXT3-fs warning: maximal mount count reached, running
e2fsck is recommended
[11186.941675] EXT3 FS on sdc1, internal journal
[11186.941683] EXT3-fs: mounted filesystem with writeback data mode.
[16840.450530] ata1.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action 0x6 frozen
[16840.450535] ata1.00: cmd 61/b8:00:20:d5:8b/02:00:05:00:00/40 tag 0
ncq 356352 out
[16840.450536]          res 40/00:00:00:4f:c2/00:01:00:00:00/00 Emask
0x4 (timeout)
[16840.450538] ata1.00: status: { DRDY }
[16840.450541] ata1.00: cmd 61/80:08:99:bd:86/01:00:09:00:00/40 tag 1
ncq 196608 out
[16840.450542]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[16840.450543] ata1.00: status: { DRDY }
[16840.450546] ata1: hard resetting link
[16840.978820] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[16840.981055] ata1.00: configured for UDMA/133
[16840.981064] ata1.00: device reported invalid CHS sector 0
[16840.981069] ata1.00: device reported invalid CHS sector 0
[16840.981078] ata1: EH complete
[17655.017000] ata1.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0
action 0x6 frozen
[17655.017013] ata1.00: cmd 61/00:00:38:01:d0/04:00:06:00:00/40 tag 0
ncq 524288 out
[17655.017016]          res 40/00:00:00:4f:c2/00:01:00:00:00/00 Emask
0x4 (timeout)
[17655.017020] ata1.00: status: { DRDY }
[17655.017029] ata1.00: cmd 61/00:08:38:05:d0/04:00:06:00:00/40 tag 1
ncq 524288 out
[17655.017031]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17655.017035] ata1.00: status: { DRDY }
[17655.017043] ata1.00: cmd 61/00:10:38:09:d0/04:00:06:00:00/40 tag 2
ncq 524288 out
[17655.017045]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17655.017049] ata1.00: status: { DRDY }
[17655.017057] ata1.00: cmd 61/c8:18:38:0d:d0/00:00:06:00:00/40 tag 3
ncq 102400 out
[17655.017059]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17655.017063] ata1.00: status: { DRDY }
[17655.017071] ata1.00: cmd 61/08:20:b0:83:49/00:00:09:00:00/40 tag 4
ncq 4096 out
[17655.017073]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17655.017077] ata1.00: status: { DRDY }
[17655.017085] ata1.00: cmd 61/08:28:f8:7e:17/00:00:03:00:00/40 tag 5
ncq 4096 out
[17655.017087]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17655.017091] ata1.00: status: { DRDY }
[17655.017099] ata1.00: cmd 61/00:30:00:0e:d0/04:00:06:00:00/40 tag 6
ncq 524288 out
[17655.017101]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17655.017105] ata1.00: status: { DRDY }
[17655.017113] ata1.00: cmd 61/00:38:00:12:d0/04:00:06:00:00/40 tag 7
ncq 524288 out
[17655.017115]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17655.017119] ata1.00: status: { DRDY }
[17655.017127] ata1.00: cmd 61/00:40:00:16:d0/04:00:06:00:00/40 tag 8
ncq 524288 out
[17655.017129]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17655.017133] ata1.00: status: { DRDY }
[17655.017141] ata1.00: cmd 61/08:48:00:1a:d0/00:00:06:00:00/40 tag 9
ncq 4096 out
[17655.017143]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17655.017147] ata1.00: status: { DRDY }
[17655.017156] ata1.00: cmd 60/08:50:50:01:c5/00:00:06:00:00/40 tag 10
ncq 4096 in
[17655.017158]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17655.017162] ata1.00: status: { DRDY }
[17655.017170] ata1.00: cmd 60/08:58:00:3f:bc/00:00:06:00:00/40 tag 11
ncq 4096 in
[17655.017172]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17655.017176] ata1.00: status: { DRDY }
[17655.017184] ata1.00: cmd 61/10:60:a8:e5:bb/00:00:06:00:00/40 tag 12
ncq 8192 out
[17655.017186]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17655.017190] ata1.00: status: { DRDY }
[17655.017198] ata1.00: cmd 61/10:68:68:e6:bb/00:00:06:00:00/40 tag 13
ncq 8192 out
[17655.017199]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17655.017204] ata1.00: status: { DRDY }
[17655.017211] ata1.00: cmd 61/08:70:a8:e8:bb/00:00:06:00:00/40 tag 14
ncq 4096 out
[17655.017213]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17655.017217] ata1.00: status: { DRDY }
[17655.017225] ata1.00: cmd 61/08:78:60:fc:bb/00:00:06:00:00/40 tag 15
ncq 4096 out
[17655.017227]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17655.017231] ata1.00: status: { DRDY }
[17655.017239] ata1.00: cmd 61/08:80:20:fd:bb/00:00:06:00:00/40 tag 16
ncq 4096 out
[17655.017241]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17655.017245] ata1.00: status: { DRDY }
[17655.017253] ata1.00: cmd 61/00:88:d0:66:c9/04:00:06:00:00/40 tag 17
ncq 524288 out
[17655.017255]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17655.017259] ata1.00: status: { DRDY }
[17655.017267] ata1.00: cmd 61/00:90:d0:6a:c9/04:00:06:00:00/40 tag 18
ncq 524288 out
[17655.017269]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17655.017273] ata1.00: status: { DRDY }
[17655.017281] ata1.00: cmd 61/00:98:d0:6e:c9/04:00:06:00:00/40 tag 19
ncq 524288 out
[17655.017283]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17655.017287] ata1.00: status: { DRDY }
[17655.017295] ata1.00: cmd 61/00:a0:d0:72:c9/04:00:06:00:00/40 tag 20
ncq 524288 out
[17655.017297]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17655.017301] ata1.00: status: { DRDY }
[17655.017309] ata1.00: cmd 61/00:a8:d0:76:c9/04:00:06:00:00/40 tag 21
ncq 524288 out
[17655.017311]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17655.017315] ata1.00: status: { DRDY }
[17655.017323] ata1.00: cmd 61/00:b0:d0:7a:c9/04:00:06:00:00/40 tag 22
ncq 524288 out
[17655.017325]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17655.017329] ata1.00: status: { DRDY }
[17655.017337] ata1.00: cmd 61/60:b8:d0:7e:c9/02:00:06:00:00/40 tag 23
ncq 311296 out
[17655.017339]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17655.017343] ata1.00: status: { DRDY }
[17655.017351] ata1.00: cmd 61/00:c0:38:01:ca/04:00:06:00:00/40 tag 24
ncq 524288 out
[17655.017353]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17655.017357] ata1.00: status: { DRDY }
[17655.017365] ata1.00: cmd 61/00:c8:38:05:ca/04:00:06:00:00/40 tag 25
ncq 524288 out
[17655.017367]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17655.017371] ata1.00: status: { DRDY }
[17655.017379] ata1.00: cmd 61/48:d0:38:09:ca/01:00:06:00:00/40 tag 26
ncq 167936 out
[17655.017381]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17655.017385] ata1.00: status: { DRDY }
[17655.017393] ata1.00: cmd 61/00:d8:08:1a:d0/04:00:06:00:00/40 tag 27
ncq 524288 out
[17655.017395]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17655.017399] ata1.00: status: { DRDY }
[17655.017407] ata1.00: cmd 61/00:e0:08:1e:d0/04:00:06:00:00/40 tag 28
ncq 524288 out
[17655.017409]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17655.017413] ata1.00: status: { DRDY }
[17655.017421] ata1.00: cmd 61/00:e8:08:22:d0/04:00:06:00:00/40 tag 29
ncq 524288 out
[17655.017423]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17655.017427] ata1.00: status: { DRDY }
[17655.017435] ata1.00: cmd 61/00:f0:08:26:d0/04:00:06:00:00/40 tag 30
ncq 524288 out
[17655.017437]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17655.017441] ata1.00: status: { DRDY }
[17655.017447] ata1: hard resetting link
[17655.545918] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[17655.548193] ata1.00: configured for UDMA/133
[17655.548204] ata1.00: device reported invalid CHS sector 0
[17655.548211] ata1.00: device reported invalid CHS sector 0
[17655.548399] ata1.00: device reported invalid CHS sector 0
[17655.548425] ata1.00: device reported invalid CHS sector 0
[17655.548429] ata1.00: device reported invalid CHS sector 0
[17655.548432] ata1.00: device reported invalid CHS sector 0
[17655.548438] ata1.00: device reported invalid CHS sector 0
[17655.548445] ata1.00: device reported invalid CHS sector 0
[17655.548450] ata1.00: device reported invalid CHS sector 0
[17655.548453] ata1.00: device reported invalid CHS sector 0
[17655.548456] ata1.00: device reported invalid CHS sector 0
[17655.548459] ata1.00: device reported invalid CHS sector 0
[17655.548462] ata1.00: device reported invalid CHS sector 0
[17655.548466] ata1.00: device reported invalid CHS sector 0
[17655.548469] ata1.00: device reported invalid CHS sector 0
[17655.548472] ata1.00: device reported invalid CHS sector 0
[17655.548475] ata1.00: device reported invalid CHS sector 0
[17655.548482] ata1.00: device reported invalid CHS sector 0
[17655.548488] ata1.00: device reported invalid CHS sector 0
[17655.548494] ata1.00: device reported invalid CHS sector 0
[17655.548501] ata1.00: device reported invalid CHS sector 0
[17655.548507] ata1.00: device reported invalid CHS sector 0
[17655.548514] ata1.00: device reported invalid CHS sector 0
[17655.548519] ata1.00: device reported invalid CHS sector 0
[17655.548526] ata1.00: device reported invalid CHS sector 0
[17655.548532] ata1.00: device reported invalid CHS sector 0
[17655.548537] ata1.00: device reported invalid CHS sector 0
[17655.548542] ata1.00: device reported invalid CHS sector 0
[17655.548548] ata1.00: device reported invalid CHS sector 0
[17655.548555] ata1.00: device reported invalid CHS sector 0
[17655.548561] ata1.00: device reported invalid CHS sector 0
[17655.548596] ata1: EH complete
[17686.024647] ata1.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0
action 0x6 frozen
[17686.024660] ata1.00: cmd 61/00:00:08:26:d0/04:00:06:00:00/40 tag 0
ncq 524288 out
[17686.024662]          res 40/00:00:00:4f:c2/00:01:00:00:00/00 Emask
0x4 (timeout)
[17686.024667] ata1.00: status: { DRDY }
[17686.024675] ata1.00: cmd 61/00:08:08:22:d0/04:00:06:00:00/40 tag 1
ncq 524288 out
[17686.024677]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17686.024682] ata1.00: status: { DRDY }
[17686.024690] ata1.00: cmd 61/00:10:08:1e:d0/04:00:06:00:00/40 tag 2
ncq 524288 out
[17686.024692]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17686.024696] ata1.00: status: { DRDY }
[17686.024704] ata1.00: cmd 61/00:18:08:1a:d0/04:00:06:00:00/40 tag 3
ncq 524288 out
[17686.024706]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17686.024710] ata1.00: status: { DRDY }
[17686.024718] ata1.00: cmd 61/48:20:38:09:ca/01:00:06:00:00/40 tag 4
ncq 167936 out
[17686.024720]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17686.024724] ata1.00: status: { DRDY }
[17686.024732] ata1.00: cmd 61/00:28:38:05:ca/04:00:06:00:00/40 tag 5
ncq 524288 out
[17686.024734]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17686.024738] ata1.00: status: { DRDY }
[17686.024746] ata1.00: cmd 61/00:30:38:01:ca/04:00:06:00:00/40 tag 6
ncq 524288 out
[17686.024748]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17686.024752] ata1.00: status: { DRDY }
[17686.024760] ata1.00: cmd 61/60:38:d0:7e:c9/02:00:06:00:00/40 tag 7
ncq 311296 out
[17686.024762]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17686.024766] ata1.00: status: { DRDY }
[17686.024774] ata1.00: cmd 61/00:40:d0:7a:c9/04:00:06:00:00/40 tag 8
ncq 524288 out
[17686.024776]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17686.024780] ata1.00: status: { DRDY }
[17686.024788] ata1.00: cmd 61/00:48:d0:76:c9/04:00:06:00:00/40 tag 9
ncq 524288 out
[17686.024790]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17686.024794] ata1.00: status: { DRDY }
[17686.024802] ata1.00: cmd 61/00:50:d0:72:c9/04:00:06:00:00/40 tag 10
ncq 524288 out
[17686.024804]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17686.024808] ata1.00: status: { DRDY }
[17686.024816] ata1.00: cmd 61/00:58:d0:6e:c9/04:00:06:00:00/40 tag 11
ncq 524288 out
[17686.024818]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17686.024822] ata1.00: status: { DRDY }
[17686.024830] ata1.00: cmd 61/00:60:d0:6a:c9/04:00:06:00:00/40 tag 12
ncq 524288 out
[17686.024832]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17686.024836] ata1.00: status: { DRDY }
[17686.024844] ata1.00: cmd 61/00:68:d0:66:c9/04:00:06:00:00/40 tag 13
ncq 524288 out
[17686.024846]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17686.024850] ata1.00: status: { DRDY }
[17686.024858] ata1.00: cmd 61/08:70:20:fd:bb/00:00:06:00:00/40 tag 14
ncq 4096 out
[17686.024860]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17686.024864] ata1.00: status: { DRDY }
[17686.024872] ata1.00: cmd 61/08:78:60:fc:bb/00:00:06:00:00/40 tag 15
ncq 4096 out
[17686.024874]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17686.024878] ata1.00: status: { DRDY }
[17686.024885] ata1.00: cmd 61/08:80:a8:e8:bb/00:00:06:00:00/40 tag 16
ncq 4096 out
[17686.024887]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17686.024891] ata1.00: status: { DRDY }
[17686.024899] ata1.00: cmd 61/10:88:68:e6:bb/00:00:06:00:00/40 tag 17
ncq 8192 out
[17686.024901]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17686.024905] ata1.00: status: { DRDY }
[17686.024913] ata1.00: cmd 61/10:90:a8:e5:bb/00:00:06:00:00/40 tag 18
ncq 8192 out
[17686.024915]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17686.024919] ata1.00: status: { DRDY }
[17686.024927] ata1.00: cmd 60/08:98:00:3f:bc/00:00:06:00:00/40 tag 19
ncq 4096 in
[17686.024929]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17686.024933] ata1.00: status: { DRDY }
[17686.024941] ata1.00: cmd 60/08:a0:50:01:c5/00:00:06:00:00/40 tag 20
ncq 4096 in
[17686.024943]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17686.024947] ata1.00: status: { DRDY }
[17686.024955] ata1.00: cmd 61/08:a8:00:1a:d0/00:00:06:00:00/40 tag 21
ncq 4096 out
[17686.024957]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17686.024961] ata1.00: status: { DRDY }
[17686.024969] ata1.00: cmd 61/00:b0:00:16:d0/04:00:06:00:00/40 tag 22
ncq 524288 out
[17686.024971]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17686.024975] ata1.00: status: { DRDY }
[17686.024983] ata1.00: cmd 61/00:b8:00:12:d0/04:00:06:00:00/40 tag 23
ncq 524288 out
[17686.024985]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17686.024989] ata1.00: status: { DRDY }
[17686.024997] ata1.00: cmd 61/00:c0:00:0e:d0/04:00:06:00:00/40 tag 24
ncq 524288 out
[17686.024999]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17686.025003] ata1.00: status: { DRDY }
[17686.025011] ata1.00: cmd 61/08:c8:f8:7e:17/00:00:03:00:00/40 tag 25
ncq 4096 out
[17686.025013]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17686.025017] ata1.00: status: { DRDY }
[17686.025025] ata1.00: cmd 61/08:d0:b0:83:49/00:00:09:00:00/40 tag 26
ncq 4096 out
[17686.025027]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17686.025031] ata1.00: status: { DRDY }
[17686.025039] ata1.00: cmd 61/c8:d8:38:0d:d0/00:00:06:00:00/40 tag 27
ncq 102400 out
[17686.025041]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17686.025045] ata1.00: status: { DRDY }
[17686.025053] ata1.00: cmd 61/00:e0:38:09:d0/04:00:06:00:00/40 tag 28
ncq 524288 out
[17686.025055]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17686.025059] ata1.00: status: { DRDY }
[17686.025066] ata1.00: cmd 61/00:e8:38:05:d0/04:00:06:00:00/40 tag 29
ncq 524288 out
[17686.025068]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17686.025073] ata1.00: status: { DRDY }
[17686.025080] ata1.00: cmd 61/00:f0:38:01:d0/04:00:06:00:00/40 tag 30
ncq 524288 out
[17686.025082]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17686.025086] ata1.00: status: { DRDY }
[17686.025091] ata1: hard resetting link
[17686.553697] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[17686.555939] ata1.00: configured for UDMA/133
[17686.555949] ata1.00: device reported invalid CHS sector 0
[17686.555957] ata1.00: device reported invalid CHS sector 0
[17686.555964] ata1.00: device reported invalid CHS sector 0
[17686.555969] ata1.00: device reported invalid CHS sector 0
[17686.555973] ata1.00: device reported invalid CHS sector 0
[17686.555980] ata1.00: device reported invalid CHS sector 0
[17686.555987] ata1.00: device reported invalid CHS sector 0
[17686.555992] ata1.00: device reported invalid CHS sector 0
[17686.555999] ata1.00: device reported invalid CHS sector 0
[17686.556005] ata1.00: device reported invalid CHS sector 0
[17686.556028] ata1.00: device reported invalid CHS sector 0
[17686.556034] ata1.00: device reported invalid CHS sector 0
[17686.556041] ata1.00: device reported invalid CHS sector 0
[17686.556048] ata1.00: device reported invalid CHS sector 0
[17686.556051] ata1.00: device reported invalid CHS sector 0
[17686.556054] ata1.00: device reported invalid CHS sector 0
[17686.556057] ata1.00: device reported invalid CHS sector 0
[17686.556060] ata1.00: device reported invalid CHS sector 0
[17686.556063] ata1.00: device reported invalid CHS sector 0
[17686.556066] ata1.00: device reported invalid CHS sector 0
[17686.556069] ata1.00: device reported invalid CHS sector 0
[17686.556073] ata1.00: device reported invalid CHS sector 0
[17686.556078] ata1.00: device reported invalid CHS sector 0
[17686.556084] ata1.00: device reported invalid CHS sector 0
[17686.556090] ata1.00: device reported invalid CHS sector 0
[17686.556093] ata1.00: device reported invalid CHS sector 0
[17686.556097] ata1.00: device reported invalid CHS sector 0
[17686.556101] ata1.00: device reported invalid CHS sector 0
[17686.556107] ata1.00: device reported invalid CHS sector 0
[17686.556114] ata1.00: device reported invalid CHS sector 0
[17686.556120] ata1.00: device reported invalid CHS sector 0
[17686.556154] ata1: EH complete
[17716.972998] ata1.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0
action 0x6 frozen
[17716.973011] ata1.00: cmd 61/00:00:38:01:d0/04:00:06:00:00/40 tag 0
ncq 524288 out
[17716.973014]          res 40/00:00:00:4f:c2/00:01:00:00:00/00 Emask
0x4 (timeout)
[17716.973018] ata1.00: status: { DRDY }
[17716.973027] ata1.00: cmd 61/00:08:38:05:d0/04:00:06:00:00/40 tag 1
ncq 524288 out
[17716.973029]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17716.973033] ata1.00: status: { DRDY }
[17716.973041] ata1.00: cmd 61/00:10:38:09:d0/04:00:06:00:00/40 tag 2
ncq 524288 out
[17716.973043]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17716.973047] ata1.00: status: { DRDY }
[17716.973055] ata1.00: cmd 61/c8:18:38:0d:d0/00:00:06:00:00/40 tag 3
ncq 102400 out
[17716.973057]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17716.973061] ata1.00: status: { DRDY }
[17716.973069] ata1.00: cmd 61/08:20:b0:83:49/00:00:09:00:00/40 tag 4
ncq 4096 out
[17716.973071]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17716.973075] ata1.00: status: { DRDY }
[17716.973083] ata1.00: cmd 61/08:28:f8:7e:17/00:00:03:00:00/40 tag 5
ncq 4096 out
[17716.973085]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17716.973089] ata1.00: status: { DRDY }
[17716.973097] ata1.00: cmd 61/00:30:00:0e:d0/04:00:06:00:00/40 tag 6
ncq 524288 out
[17716.973099]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17716.973103] ata1.00: status: { DRDY }
[17716.973111] ata1.00: cmd 61/00:38:00:12:d0/04:00:06:00:00/40 tag 7
ncq 524288 out
[17716.973113]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17716.973117] ata1.00: status: { DRDY }
[17716.973125] ata1.00: cmd 61/00:40:00:16:d0/04:00:06:00:00/40 tag 8
ncq 524288 out
[17716.973127]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17716.973131] ata1.00: status: { DRDY }
[17716.973139] ata1.00: cmd 61/08:48:00:1a:d0/00:00:06:00:00/40 tag 9
ncq 4096 out
[17716.973141]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17716.973145] ata1.00: status: { DRDY }
[17716.973153] ata1.00: cmd 60/08:50:50:01:c5/00:00:06:00:00/40 tag 10
ncq 4096 in
[17716.973155]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17716.973159] ata1.00: status: { DRDY }
[17716.973167] ata1.00: cmd 60/08:58:00:3f:bc/00:00:06:00:00/40 tag 11
ncq 4096 in
[17716.973169]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17716.973173] ata1.00: status: { DRDY }
[17716.973181] ata1.00: cmd 61/10:60:a8:e5:bb/00:00:06:00:00/40 tag 12
ncq 8192 out
[17716.973183]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17716.973187] ata1.00: status: { DRDY }
[17716.973195] ata1.00: cmd 61/10:68:68:e6:bb/00:00:06:00:00/40 tag 13
ncq 8192 out
[17716.973197]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17716.973201] ata1.00: status: { DRDY }
[17716.973209] ata1.00: cmd 61/08:70:a8:e8:bb/00:00:06:00:00/40 tag 14
ncq 4096 out
[17716.973211]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17716.973215] ata1.00: status: { DRDY }
[17716.973223] ata1.00: cmd 61/08:78:60:fc:bb/00:00:06:00:00/40 tag 15
ncq 4096 out
[17716.973225]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17716.973229] ata1.00: status: { DRDY }
[17716.973237] ata1.00: cmd 61/08:80:20:fd:bb/00:00:06:00:00/40 tag 16
ncq 4096 out
[17716.973239]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17716.973243] ata1.00: status: { DRDY }
[17716.973251] ata1.00: cmd 61/00:88:d0:66:c9/04:00:06:00:00/40 tag 17
ncq 524288 out
[17716.973253]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17716.973257] ata1.00: status: { DRDY }
[17716.973265] ata1.00: cmd 61/00:90:d0:6a:c9/04:00:06:00:00/40 tag 18
ncq 524288 out
[17716.973267]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17716.973271] ata1.00: status: { DRDY }
[17716.973279] ata1.00: cmd 61/00:98:d0:6e:c9/04:00:06:00:00/40 tag 19
ncq 524288 out
[17716.973281]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17716.973285] ata1.00: status: { DRDY }
[17716.973293] ata1.00: cmd 61/00:a0:d0:72:c9/04:00:06:00:00/40 tag 20
ncq 524288 out
[17716.973295]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17716.973299] ata1.00: status: { DRDY }
[17716.973307] ata1.00: cmd 61/00:a8:d0:76:c9/04:00:06:00:00/40 tag 21
ncq 524288 out
[17716.973309]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17716.973313] ata1.00: status: { DRDY }
[17716.973321] ata1.00: cmd 61/00:b0:d0:7a:c9/04:00:06:00:00/40 tag 22
ncq 524288 out
[17716.973323]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17716.973327] ata1.00: status: { DRDY }
[17716.973335] ata1.00: cmd 61/60:b8:d0:7e:c9/02:00:06:00:00/40 tag 23
ncq 311296 out
[17716.973337]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17716.973341] ata1.00: status: { DRDY }
[17716.973349] ata1.00: cmd 61/00:c0:38:01:ca/04:00:06:00:00/40 tag 24
ncq 524288 out
[17716.973351]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17716.973355] ata1.00: status: { DRDY }
[17716.973363] ata1.00: cmd 61/00:c8:38:05:ca/04:00:06:00:00/40 tag 25
ncq 524288 out
[17716.973365]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17716.973369] ata1.00: status: { DRDY }
[17716.973377] ata1.00: cmd 61/48:d0:38:09:ca/01:00:06:00:00/40 tag 26
ncq 167936 out
[17716.973379]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17716.973383] ata1.00: status: { DRDY }
[17716.973391] ata1.00: cmd 61/00:d8:08:1a:d0/04:00:06:00:00/40 tag 27
ncq 524288 out
[17716.973393]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17716.973397] ata1.00: status: { DRDY }
[17716.973405] ata1.00: cmd 61/00:e0:08:1e:d0/04:00:06:00:00/40 tag 28
ncq 524288 out
[17716.973407]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17716.973411] ata1.00: status: { DRDY }
[17716.973419] ata1.00: cmd 61/00:e8:08:22:d0/04:00:06:00:00/40 tag 29
ncq 524288 out
[17716.973421]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17716.973425] ata1.00: status: { DRDY }
[17716.973433] ata1.00: cmd 61/00:f0:08:26:d0/04:00:06:00:00/40 tag 30
ncq 524288 out
[17716.973435]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17716.973439] ata1.00: status: { DRDY }
[17716.973444] ata1: hard resetting link
[17717.491499] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[17717.493700] ata1.00: configured for UDMA/133
[17717.493710] ata1.00: device reported invalid CHS sector 0
[17717.493718] ata1.00: device reported invalid CHS sector 0
[17717.493725] ata1.00: device reported invalid CHS sector 0
[17717.493729] ata1.00: device reported invalid CHS sector 0
[17717.493732] ata1.00: device reported invalid CHS sector 0
[17717.493735] ata1.00: device reported invalid CHS sector 0
[17717.493742] ata1.00: device reported invalid CHS sector 0
[17717.493748] ata1.00: device reported invalid CHS sector 0
[17717.493753] ata1.00: device reported invalid CHS sector 0
[17717.493756] ata1.00: device reported invalid CHS sector 0
[17717.493759] ata1.00: device reported invalid CHS sector 0
[17717.493762] ata1.00: device reported invalid CHS sector 0
[17717.493766] ata1.00: device reported invalid CHS sector 0
[17717.493769] ata1.00: device reported invalid CHS sector 0
[17717.493772] ata1.00: device reported invalid CHS sector 0
[17717.493775] ata1.00: device reported invalid CHS sector 0
[17717.493778] ata1.00: device reported invalid CHS sector 0
[17717.493785] ata1.00: device reported invalid CHS sector 0
[17717.493791] ata1.00: device reported invalid CHS sector 0
[17717.493798] ata1.00: device reported invalid CHS sector 0
[17717.493805] ata1.00: device reported invalid CHS sector 0
[17717.493811] ata1.00: device reported invalid CHS sector 0
[17717.493818] ata1.00: device reported invalid CHS sector 0
[17717.493822] ata1.00: device reported invalid CHS sector 0
[17717.493830] ata1.00: device reported invalid CHS sector 0
[17717.493836] ata1.00: device reported invalid CHS sector 0
[17717.493840] ata1.00: device reported invalid CHS sector 0
[17717.493845] ata1.00: device reported invalid CHS sector 0
[17717.493852] ata1.00: device reported invalid CHS sector 0
[17717.493859] ata1.00: device reported invalid CHS sector 0
[17717.493883] ata1.00: device reported invalid CHS sector 0
[17717.493917] ata1: EH complete
[17747.920969] ata1.00: NCQ disabled due to excessive errors
[17747.920976] ata1.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0
action 0x6 frozen
[17747.920988] ata1.00: cmd 61/00:00:08:26:d0/04:00:06:00:00/40 tag 0
ncq 524288 out
[17747.920990]          res 40/00:00:00:4f:c2/00:01:00:00:00/00 Emask
0x4 (timeout)
[17747.920995] ata1.00: status: { DRDY }
[17747.921003] ata1.00: cmd 61/00:08:08:22:d0/04:00:06:00:00/40 tag 1
ncq 524288 out
[17747.921005]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17747.921009] ata1.00: status: { DRDY }
[17747.921017] ata1.00: cmd 61/00:10:08:1e:d0/04:00:06:00:00/40 tag 2
ncq 524288 out
[17747.921019]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17747.921023] ata1.00: status: { DRDY }
[17747.921031] ata1.00: cmd 61/00:18:08:1a:d0/04:00:06:00:00/40 tag 3
ncq 524288 out
[17747.921033]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17747.921037] ata1.00: status: { DRDY }
[17747.921045] ata1.00: cmd 61/48:20:38:09:ca/01:00:06:00:00/40 tag 4
ncq 167936 out
[17747.921047]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17747.921051] ata1.00: status: { DRDY }
[17747.921059] ata1.00: cmd 61/00:28:38:05:ca/04:00:06:00:00/40 tag 5
ncq 524288 out
[17747.921061]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17747.921065] ata1.00: status: { DRDY }
[17747.921073] ata1.00: cmd 61/00:30:38:01:ca/04:00:06:00:00/40 tag 6
ncq 524288 out
[17747.921075]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17747.921079] ata1.00: status: { DRDY }
[17747.921087] ata1.00: cmd 61/60:38:d0:7e:c9/02:00:06:00:00/40 tag 7
ncq 311296 out
[17747.921089]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17747.921093] ata1.00: status: { DRDY }
[17747.921100] ata1.00: cmd 61/00:40:d0:7a:c9/04:00:06:00:00/40 tag 8
ncq 524288 out
[17747.921102]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17747.921106] ata1.00: status: { DRDY }
[17747.921114] ata1.00: cmd 61/00:48:d0:76:c9/04:00:06:00:00/40 tag 9
ncq 524288 out
[17747.921116]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17747.921120] ata1.00: status: { DRDY }
[17747.921128] ata1.00: cmd 61/00:50:d0:72:c9/04:00:06:00:00/40 tag 10
ncq 524288 out
[17747.921130]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17747.921134] ata1.00: status: { DRDY }
[17747.921142] ata1.00: cmd 61/00:58:d0:6e:c9/04:00:06:00:00/40 tag 11
ncq 524288 out
[17747.921144]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17747.921148] ata1.00: status: { DRDY }
[17747.921156] ata1.00: cmd 61/00:60:d0:6a:c9/04:00:06:00:00/40 tag 12
ncq 524288 out
[17747.921158]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17747.921162] ata1.00: status: { DRDY }
[17747.921170] ata1.00: cmd 61/00:68:d0:66:c9/04:00:06:00:00/40 tag 13
ncq 524288 out
[17747.921172]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17747.921176] ata1.00: status: { DRDY }
[17747.921184] ata1.00: cmd 61/08:70:20:fd:bb/00:00:06:00:00/40 tag 14
ncq 4096 out
[17747.921186]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17747.921190] ata1.00: status: { DRDY }
[17747.921198] ata1.00: cmd 61/08:78:60:fc:bb/00:00:06:00:00/40 tag 15
ncq 4096 out
[17747.921200]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17747.921204] ata1.00: status: { DRDY }
[17747.921212] ata1.00: cmd 61/08:80:a8:e8:bb/00:00:06:00:00/40 tag 16
ncq 4096 out
[17747.921214]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17747.921218] ata1.00: status: { DRDY }
[17747.921226] ata1.00: cmd 61/10:88:68:e6:bb/00:00:06:00:00/40 tag 17
ncq 8192 out
[17747.921228]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17747.921232] ata1.00: status: { DRDY }
[17747.921240] ata1.00: cmd 61/10:90:a8:e5:bb/00:00:06:00:00/40 tag 18
ncq 8192 out
[17747.921242]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17747.921246] ata1.00: status: { DRDY }
[17747.921254] ata1.00: cmd 60/08:98:00:3f:bc/00:00:06:00:00/40 tag 19
ncq 4096 in
[17747.921256]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17747.921260] ata1.00: status: { DRDY }
[17747.921267] ata1.00: cmd 60/08:a0:50:01:c5/00:00:06:00:00/40 tag 20
ncq 4096 in
[17747.921269]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17747.921273] ata1.00: status: { DRDY }
[17747.921281] ata1.00: cmd 61/08:a8:00:1a:d0/00:00:06:00:00/40 tag 21
ncq 4096 out
[17747.921283]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17747.921287] ata1.00: status: { DRDY }
[17747.921295] ata1.00: cmd 61/00:b0:00:16:d0/04:00:06:00:00/40 tag 22
ncq 524288 out
[17747.921297]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17747.921301] ata1.00: status: { DRDY }
[17747.921309] ata1.00: cmd 61/00:b8:00:12:d0/04:00:06:00:00/40 tag 23
ncq 524288 out
[17747.921311]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17747.921315] ata1.00: status: { DRDY }
[17747.921323] ata1.00: cmd 61/00:c0:00:0e:d0/04:00:06:00:00/40 tag 24
ncq 524288 out
[17747.921325]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17747.921329] ata1.00: status: { DRDY }
[17747.921337] ata1.00: cmd 61/08:c8:f8:7e:17/00:00:03:00:00/40 tag 25
ncq 4096 out
[17747.921339]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17747.921343] ata1.00: status: { DRDY }
[17747.921351] ata1.00: cmd 61/08:d0:b0:83:49/00:00:09:00:00/40 tag 26
ncq 4096 out
[17747.921353]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17747.921357] ata1.00: status: { DRDY }
[17747.921364] ata1.00: cmd 61/c8:d8:38:0d:d0/00:00:06:00:00/40 tag 27
ncq 102400 out
[17747.921366]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17747.921370] ata1.00: status: { DRDY }
[17747.921378] ata1.00: cmd 61/00:e0:38:09:d0/04:00:06:00:00/40 tag 28
ncq 524288 out
[17747.921380]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17747.921384] ata1.00: status: { DRDY }
[17747.921392] ata1.00: cmd 61/00:e8:38:05:d0/04:00:06:00:00/40 tag 29
ncq 524288 out
[17747.921394]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17747.921398] ata1.00: status: { DRDY }
[17747.921406] ata1.00: cmd 61/00:f0:38:01:d0/04:00:06:00:00/40 tag 30
ncq 524288 out
[17747.921408]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[17747.921412] ata1.00: status: { DRDY }
[17747.921417] ata1: hard resetting link
[17748.449291] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[17748.451363] ata1.00: configured for UDMA/133
[17748.451373] ata1.00: device reported invalid CHS sector 0
[17748.451381] ata1.00: device reported invalid CHS sector 0
[17748.451387] ata1.00: device reported invalid CHS sector 0
[17748.451393] ata1.00: device reported invalid CHS sector 0
[17748.451397] ata1.00: device reported invalid CHS sector 0
[17748.451404] ata1.00: device reported invalid CHS sector 0
[17748.451410] ata1.00: device reported invalid CHS sector 0
[17748.451415] ata1.00: device reported invalid CHS sector 0
[17748.451422] ata1.00: device reported invalid CHS sector 0
[17748.451429] ata1.00: device reported invalid CHS sector 0
[17748.451435] ata1.00: device reported invalid CHS sector 0
[17748.451442] ata1.00: device reported invalid CHS sector 0
[17748.451448] ata1.00: device reported invalid CHS sector 0
[17748.451455] ata1.00: device reported invalid CHS sector 0
[17748.451458] ata1.00: device reported invalid CHS sector 0
[17748.451461] ata1.00: device reported invalid CHS sector 0
[17748.451464] ata1.00: device reported invalid CHS sector 0
[17748.451467] ata1.00: device reported invalid CHS sector 0
[17748.451470] ata1.00: device reported invalid CHS sector 0
[17748.451473] ata1.00: device reported invalid CHS sector 0
[17748.451477] ata1.00: device reported invalid CHS sector 0
[17748.451480] ata1.00: device reported invalid CHS sector 0
[17748.451485] ata1.00: device reported invalid CHS sector 0
[17748.451491] ata1.00: device reported invalid CHS sector 0
[17748.451497] ata1.00: device reported invalid CHS sector 0
[17748.451500] ata1.00: device reported invalid CHS sector 0
[17748.451503] ata1.00: device reported invalid CHS sector 0
[17748.451507] ata1.00: device reported invalid CHS sector 0
[17748.451514] ata1.00: device reported invalid CHS sector 0
[17748.451520] ata1.00: device reported invalid CHS sector 0
[17748.451527] ata1.00: device reported invalid CHS sector 0
[17748.451560] ata1: EH complete
[18883.279801] CE: hpet increasing min_delta_ns to 15000 nsec
