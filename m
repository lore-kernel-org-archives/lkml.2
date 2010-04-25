Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab0DYPQj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 11:16:39 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:50574 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab0DYPQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 11:16:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=oO0a/z0zzn7gYhBWMoYk6fTQHTAktTpaZFJfdNrBXTjtHl6NB7gGZPOhDGKpv6byqI
         VsQ7fd17x/3O2hGBe6AjHhntOThvynBlPLCCr5kAP/Ngr8Uec94aBOu5NwBAHlxiSM0c
         cSxleuEqt7CIAOPqoxLn2jmPwlcETGNjY2H1E=
MIME-Version: 1.0
From: Richard Genoud <richard.genoud@gmail.com>
Date: Sun, 25 Apr 2010 17:16:20 +0200
Message-ID: <o2l80b317761004250816q17a14763g812d9fbe32d42f80@mail.gmail.com>
Subject: [bug ?] device reported invalid CHS sector 0 / NCQ disabled due to 
	excessive errors
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

I've bought a new motherboard (asus P7P55D) and I'm seeing annoying
errors about NCQ.
To reproduce the problem, I compile a kernel with -j4.
At some point, the compilation freezes, it seems that nothing is
written to the hdds for something like 1 or 2 minutes.
Then, all starts again and I can see in the logs a lot of "device
reported invalid CHS sector 0".
Sometimes, after that, NCQ is disabled.

It happens on disks on my RAID 1 array (sda/sdb, ext4 formatted), but
not on my third disk (sdc, ext3 formatted)

kernel is from ubuntu (with the commit
8da854cb02156c90028233ae1e85ce46a1d3f82c (hpet erratum for intel P55))
I tried with 2.6.34-rc5, and the problem is still there.

Does this ring a bell ? (maybe it's not kernel related, and it's a
problem with my HDDs...)

Apr 21 19:18:31 desktop kernel: [    0.000000] Initializing cgroup subsys cpuset
Apr 21 19:18:31 desktop kernel: [    0.000000] Initializing cgroup subsys cpu
Apr 21 19:18:31 desktop kernel: [    0.000000] Linux version
2.6.31.9-hpet (richard@desktop) (gcc version 4.4.1 (Ubuntu
4.4.1-4ubuntu9) ) #1 SMP Tue Apr 13 18:59:03 CEST 2010 (Ubuntu
2.6.31-20.58-generic)
Apr 21 19:18:31 desktop kernel: [    0.000000] Command line:
BOOT_IMAGE=/vmlinuz-2.6.31.9-hpet root=/dev/md1 ro splash
Apr 21 19:18:31 desktop kernel: [    0.000000] KERNEL supported cpus:
Apr 21 19:18:31 desktop kernel: [    0.000000]   Intel GenuineIntel
Apr 21 19:18:31 desktop kernel: [    0.000000]   AMD AuthenticAMD
Apr 21 19:18:31 desktop kernel: [    0.000000]   Centaur CentaurHauls
Apr 21 19:18:31 desktop kernel: [    0.000000] BIOS-provided physical RAM map:
Apr 21 19:18:31 desktop kernel: [    0.000000]  BIOS-e820:
0000000000000000 - 000000000009e800 (usable)
Apr 21 19:18:31 desktop kernel: [    0.000000]  BIOS-e820:
000000000009e800 - 00000000000a0000 (reserved)
Apr 21 19:18:31 desktop kernel: [    0.000000]  BIOS-e820:
00000000000e4000 - 0000000000100000 (reserved)
Apr 21 19:18:31 desktop kernel: [    0.000000]  BIOS-e820:
0000000000100000 - 00000000bf770000 (usable)
Apr 21 19:18:31 desktop kernel: [    0.000000]  BIOS-e820:
00000000bf770000 - 00000000bf788000 (ACPI data)
Apr 21 19:18:31 desktop kernel: [    0.000000]  BIOS-e820:
00000000bf788000 - 00000000bf7dc000 (ACPI NVS)
Apr 21 19:18:31 desktop kernel: [    0.000000]  BIOS-e820:
00000000bf7dc000 - 00000000c0000000 (reserved)
Apr 21 19:18:31 desktop kernel: [    0.000000]  BIOS-e820:
00000000fee00000 - 00000000fee01000 (reserved)
Apr 21 19:18:31 desktop kernel: [    0.000000]  BIOS-e820:
00000000ffe00000 - 0000000100000000 (reserved)
Apr 21 19:18:31 desktop kernel: [    0.000000]  BIOS-e820:
0000000100000000 - 0000000140000000 (usable)
Apr 21 19:18:31 desktop kernel: [    0.000000] DMI 2.6 present.
Apr 21 19:18:31 desktop kernel: [    0.000000] AMI BIOS detected: BIOS
may corrupt low RAM, working around it.
Apr 21 19:18:31 desktop kernel: [    0.000000] last_pfn = 0x140000
max_arch_pfn = 0x400000000
Apr 21 19:18:31 desktop kernel: [    0.000000] x86 PAT enabled: cpu 0,
old 0x7040600070406, new 0x7010600070106
Apr 21 19:18:31 desktop kernel: [    0.000000] last_pfn = 0xbf770
max_arch_pfn = 0x400000000
Apr 21 19:18:31 desktop kernel: [    0.000000] Scanning 0 areas for
low memory corruption
Apr 21 19:18:31 desktop kernel: [    0.000000] modified physical RAM map:
Apr 21 19:18:31 desktop kernel: [    0.000000]  modified:
0000000000000000 - 0000000000010000 (reserved)
Apr 21 19:18:31 desktop kernel: [    0.000000]  modified:
0000000000010000 - 000000000009e800 (usable)
Apr 21 19:18:31 desktop kernel: [    0.000000]  modified:
000000000009e800 - 00000000000a0000 (reserved)
Apr 21 19:18:31 desktop kernel: [    0.000000]  modified:
00000000000e4000 - 0000000000100000 (reserved)
Apr 21 19:18:31 desktop kernel: [    0.000000]  modified:
0000000000100000 - 00000000bf770000 (usable)
Apr 21 19:18:31 desktop kernel: [    0.000000]  modified:
00000000bf770000 - 00000000bf788000 (ACPI data)
Apr 21 19:18:31 desktop kernel: [    0.000000]  modified:
00000000bf788000 - 00000000bf7dc000 (ACPI NVS)
Apr 21 19:18:31 desktop kernel: [    0.000000]  modified:
00000000bf7dc000 - 00000000c0000000 (reserved)
Apr 21 19:18:31 desktop kernel: [    0.000000]  modified:
00000000fee00000 - 00000000fee01000 (reserved)
Apr 21 19:18:31 desktop kernel: [    0.000000]  modified:
00000000ffe00000 - 0000000100000000 (reserved)
Apr 21 19:18:31 desktop kernel: [    0.000000]  modified:
0000000100000000 - 0000000140000000 (usable)
Apr 21 19:18:31 desktop kernel: [    0.000000] init_memory_mapping:
0000000000000000-00000000bf770000
Apr 21 19:18:31 desktop kernel: [    0.000000] NX (Execute Disable)
protection: active
Apr 21 19:18:31 desktop kernel: [    0.000000] init_memory_mapping:
0000000100000000-0000000140000000
Apr 21 19:18:31 desktop kernel: [    0.000000] NX (Execute Disable)
protection: active
Apr 21 19:18:31 desktop kernel: [    0.000000] RAMDISK: 33f4a000 - 37fef38e
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: RSDP
00000000000fb970 00024 (v02 ACPIAM)
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: XSDT
00000000bf770100 0006C (v01 022310 XSDT1106 20100223 MSFT 00000097)
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: FACP
00000000bf770290 000F4 (v03 022310 FACP1106 20100223 MSFT 00000097)
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: DSDT
00000000bf7704a0 0EE9D (v01  A1326 A1326001 00000001 INTL 20060113)
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: FACS 00000000bf788000 00040
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: APIC
00000000bf770390 000CC (v01 022310 APIC1106 20100223 MSFT 00000097)
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: MCFG
00000000bf770460 0003C (v01 022310 OEMMCFG  20100223 MSFT 00000097)
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: OEMB
00000000bf788040 00072 (v01 022310 OEMB1106 20100223 MSFT 00000097)
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: HPET
00000000bf77f7a0 00038 (v01 022310 OEMHPET  20100223 MSFT 00000097)
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: DMAR
00000000bf7880c0 00090 (v01    AMI  OEMDMAR 00000001 MSFT 00000097)
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: ASPT
00000000bf77fa40 00034 (v06 022310 PerfTune 20100223 MSFT 00000097)
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: OSFR
00000000bf77fa80 000B0 (v01 022310 OEMOSFR  20100223 MSFT 00000097)
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: SSDT
00000000bf78ac00 00363 (v01 DpgPmm    CpuPm 00000012 INTL 20060113)
Apr 21 19:18:31 desktop kernel: [    0.000000] No NUMA configuration found
Apr 21 19:18:31 desktop kernel: [    0.000000] Faking a node at
0000000000000000-0000000140000000
Apr 21 19:18:31 desktop kernel: [    0.000000] Bootmem setup node 0
0000000000000000-0000000140000000
Apr 21 19:18:31 desktop kernel: [    0.000000]   NODE_DATA
[0000000000014000 - 0000000000017fff]
Apr 21 19:18:31 desktop kernel: [    0.000000]   bootmap
[0000000000018000 -  000000000003ffff] pages 28
Apr 21 19:18:31 desktop kernel: [    0.000000] (8 early reservations)
==> bootmem [0000000000 - 0140000000]
Apr 21 19:18:31 desktop kernel: [    0.000000]   #0 [0000000000 -
0000001000]   BIOS data page ==> [0000000000 - 0000001000]
Apr 21 19:18:31 desktop kernel: [    0.000000]   #1 [0000006000 -
0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
Apr 21 19:18:31 desktop kernel: [    0.000000]   #2 [0001000000 -
00019c720c]    TEXT DATA BSS ==> [0001000000 - 00019c720c]
Apr 21 19:18:31 desktop kernel: [    0.000000]   #3 [0033f4a000 -
0037fef38e]          RAMDISK ==> [0033f4a000 - 0037fef38e]
Apr 21 19:18:31 desktop kernel: [    0.000000]   #4 [000009e800 -
0000100000]    BIOS reserved ==> [000009e800 - 0000100000]
Apr 21 19:18:31 desktop kernel: [    0.000000]   #5 [00019c8000 -
00019c82bc]              BRK ==> [00019c8000 - 00019c82bc]
Apr 21 19:18:31 desktop kernel: [    0.000000]   #6 [0000010000 -
0000013000]          PGTABLE ==> [0000010000 - 0000013000]
Apr 21 19:18:31 desktop kernel: [    0.000000]   #7 [0000013000 -
0000014000]          PGTABLE ==> [0000013000 - 0000014000]
Apr 21 19:18:31 desktop kernel: [    0.000000] found SMP MP-table at
[ffff8800000ff780] ff780
Apr 21 19:18:31 desktop kernel: [    0.000000] Zone PFN ranges:
Apr 21 19:18:31 desktop kernel: [    0.000000]   DMA      0x00000010
-> 0x00001000
Apr 21 19:18:31 desktop kernel: [    0.000000]   DMA32    0x00001000
-> 0x00100000
Apr 21 19:18:31 desktop kernel: [    0.000000]   Normal   0x00100000
-> 0x00140000
Apr 21 19:18:31 desktop kernel: [    0.000000] Movable zone start PFN
for each node
Apr 21 19:18:31 desktop kernel: [    0.000000] early_node_map[3]
active PFN ranges
Apr 21 19:18:31 desktop kernel: [    0.000000]     0: 0x00000010 -> 0x0000009e
Apr 21 19:18:31 desktop kernel: [    0.000000]     0: 0x00000100 -> 0x000bf770
Apr 21 19:18:31 desktop kernel: [    0.000000]     0: 0x00100000 -> 0x00140000
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x808
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x01] lapic_id[0x00] enabled)
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x02] lapic_id[0x02] enabled)
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x03] lapic_id[0x04] enabled)
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x04] lapic_id[0x06] enabled)
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x05] lapic_id[0x01] enabled)
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x06] lapic_id[0x03] enabled)
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x07] lapic_id[0x05] enabled)
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x08] lapic_id[0x07] enabled)
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x09] lapic_id[0x88] disabled)
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x0a] lapic_id[0x89] disabled)
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x0b] lapic_id[0x8a] disabled)
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x0c] lapic_id[0x8b] disabled)
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x0d] lapic_id[0x8c] disabled)
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x0e] lapic_id[0x8d] disabled)
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x0f] lapic_id[0x8e] disabled)
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x10] lapic_id[0x8f] disabled)
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: IOAPIC (id[0x08]
address[0xfec00000] gsi_base[0])
Apr 21 19:18:31 desktop kernel: [    0.000000] IOAPIC[0]: apic_id 8,
version 32, address 0xfec00000, GSI 0-23
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: INT_SRC_OVR (bus
0 bus_irq 0 global_irq 2 dfl dfl)
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: INT_SRC_OVR (bus
0 bus_irq 9 global_irq 9 high level)
Apr 21 19:18:31 desktop kernel: [    0.000000] Using ACPI (MADT) for
SMP configuration information
Apr 21 19:18:31 desktop kernel: [    0.000000] ACPI: HPET id:
0x8086a701 base: 0xfed00000
Apr 21 19:18:31 desktop kernel: [    0.000000] 16 Processors exceeds
NR_CPUS limit of 8
Apr 21 19:18:31 desktop kernel: [    0.000000] SMP: Allowing 8 CPUs, 0
hotplug CPUs
Apr 21 19:18:31 desktop kernel: [    0.000000] PM: Registered nosave
memory: 000000000009e000 - 000000000009f000
Apr 21 19:18:31 desktop kernel: [    0.000000] PM: Registered nosave
memory: 000000000009f000 - 00000000000a0000
Apr 21 19:18:31 desktop kernel: [    0.000000] PM: Registered nosave
memory: 00000000000a0000 - 00000000000e4000
Apr 21 19:18:31 desktop kernel: [    0.000000] PM: Registered nosave
memory: 00000000000e4000 - 0000000000100000
Apr 21 19:18:31 desktop kernel: [    0.000000] PM: Registered nosave
memory: 00000000bf770000 - 00000000bf788000
Apr 21 19:18:31 desktop kernel: [    0.000000] PM: Registered nosave
memory: 00000000bf788000 - 00000000bf7dc000
Apr 21 19:18:31 desktop kernel: [    0.000000] PM: Registered nosave
memory: 00000000bf7dc000 - 00000000c0000000
Apr 21 19:18:31 desktop kernel: [    0.000000] PM: Registered nosave
memory: 00000000c0000000 - 00000000fee00000
Apr 21 19:18:31 desktop kernel: [    0.000000] PM: Registered nosave
memory: 00000000fee00000 - 00000000fee01000
Apr 21 19:18:31 desktop kernel: [    0.000000] PM: Registered nosave
memory: 00000000fee01000 - 00000000ffe00000
Apr 21 19:18:31 desktop kernel: [    0.000000] PM: Registered nosave
memory: 00000000ffe00000 - 0000000100000000
Apr 21 19:18:31 desktop kernel: [    0.000000] Allocating PCI
resources starting at c0000000 (gap: c0000000:3ee00000)
Apr 21 19:18:31 desktop kernel: [    0.000000] NR_CPUS:8
nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
Apr 21 19:18:31 desktop kernel: [    0.000000] PERCPU: Embedded 30
pages at ffff880028022000, static data 90720 bytes
Apr 21 19:18:31 desktop kernel: [    0.000000] Built 1 zonelists in
Node order, mobility grouping on.  Total pages: 1028246
Apr 21 19:18:31 desktop kernel: [    0.000000] Policy zone: Normal
Apr 21 19:18:31 desktop kernel: [    0.000000] Kernel command line:
BOOT_IMAGE=/vmlinuz-2.6.31.9-hpet root=/dev/md1 ro splash
Apr 21 19:18:31 desktop kernel: [    0.000000] PID hash table entries:
4096 (order: 12, 32768 bytes)
Apr 21 19:18:31 desktop kernel: [    0.000000] Initializing CPU#0
Apr 21 19:18:31 desktop kernel: [    0.000000] Checking aperture...
Apr 21 19:18:31 desktop kernel: [    0.000000] No AGP bridge found
Apr 21 19:18:31 desktop kernel: [    0.000000] PCI-DMA: Using software
bounce buffering for IO (SWIOTLB)
Apr 21 19:18:31 desktop kernel: [    0.000000] Placing 64MB software
IO TLB between ffff880020000000 - ffff880024000000
Apr 21 19:18:31 desktop kernel: [    0.000000] software IO TLB at phys
0x20000000 - 0x24000000
Apr 21 19:18:31 desktop kernel: [    0.000000] Memory:
3984372k/5242880k available (5262k kernel code, 1057800k absent,
200708k reserved, 2952k data, 664k init)
Apr 21 19:18:31 desktop kernel: [    0.000000] SLUB: Genslabs=14,
HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
Apr 21 19:18:31 desktop kernel: [    0.000000] NR_IRQS:4352 nr_irqs:472
Apr 21 19:18:31 desktop kernel: [    0.000000] Extended CMOS year: 2000
Apr 21 19:18:31 desktop kernel: [    0.000000] Fast TSC calibration using PIT
Apr 21 19:18:31 desktop kernel: [    0.000000] Detected 2808.887 MHz processor.
Apr 21 19:18:31 desktop kernel: [    0.001080] Console: colour VGA+ 80x25
Apr 21 19:18:31 desktop kernel: [    0.001082] console [tty0] enabled
Apr 21 19:18:31 desktop kernel: [    0.013793] allocated 41943040
bytes of page_cgroup
Apr 21 19:18:31 desktop kernel: [    0.013842] please try
'cgroup_disable=memory' option if you don't want memory cgroups
Apr 21 19:18:31 desktop kernel: [    0.014040] HPET: 8 timers in
total, 5 timers will be used for per-cpu timer
Apr 21 19:18:31 desktop kernel: [    0.014092] Calibrating delay loop
(skipped), value calculated using timer frequency.. 5617.77 BogoMIPS
(lpj=28088870)
Apr 21 19:18:31 desktop kernel: [    0.014195] Security Framework initialized
Apr 21 19:18:31 desktop kernel: [    0.014251] AppArmor: AppArmor initialized
Apr 21 19:18:31 desktop kernel: [    0.014511] Dentry cache hash table
entries: 524288 (order: 10, 4194304 bytes)
Apr 21 19:18:31 desktop kernel: [    0.015287] Inode-cache hash table
entries: 262144 (order: 9, 2097152 bytes)
Apr 21 19:18:31 desktop kernel: [    0.015638] Mount-cache hash table
entries: 256
Apr 21 19:18:31 desktop kernel: [    0.015756] Initializing cgroup subsys ns
Apr 21 19:18:31 desktop kernel: [    0.015802] Initializing cgroup
subsys cpuacct
Apr 21 19:18:31 desktop kernel: [    0.015848] Initializing cgroup subsys memory
Apr 21 19:18:31 desktop kernel: [    0.015895] Initializing cgroup
subsys freezer
Apr 21 19:18:31 desktop kernel: [    0.015940] Initializing cgroup
subsys net_cls
Apr 21 19:18:31 desktop kernel: [    0.015991] CPU: Physical Processor ID: 0
Apr 21 19:18:31 desktop kernel: [    0.016035] CPU: Processor Core ID: 0
Apr 21 19:18:31 desktop kernel: [    0.016080] CPU: L1 I cache: 32K,
L1 D cache: 32K
Apr 21 19:18:31 desktop kernel: [    0.016152] CPU: L2 cache: 256K
Apr 21 19:18:31 desktop kernel: [    0.016194] CPU: L3 cache: 8192K
Apr 21 19:18:31 desktop kernel: [    0.016238] CPU 0/0x0 -> Node 0
Apr 21 19:18:31 desktop kernel: [    0.016282] mce: CPU supports 9 MCE banks
Apr 21 19:18:31 desktop kernel: [    0.016332] CPU0: Thermal
monitoring enabled (TM1)
Apr 21 19:18:31 desktop kernel: [    0.016379] CPU 0 MCA banks CMCI:2
CMCI:3 CMCI:5 CMCI:6 CMCI:8
Apr 21 19:18:31 desktop kernel: [    0.016587] using mwait in idle threads.
Apr 21 19:18:31 desktop kernel: [    0.016631] Performance Counters:
Nehalem/Corei7 events, Intel PMU driver.
Apr 21 19:18:31 desktop kernel: [    0.016734] ... version:                 3
Apr 21 19:18:31 desktop kernel: [    0.016778] ... bit width:               48
Apr 21 19:18:31 desktop kernel: [    0.016822] ... generic counters:        4
Apr 21 19:18:31 desktop kernel: [    0.016867] ... value mask:
     0000ffffffffffff
Apr 21 19:18:31 desktop kernel: [    0.016913] ... max period:
     000000007fffffff
Apr 21 19:18:31 desktop kernel: [    0.016959] ... fixed-purpose counters:  3
Apr 21 19:18:31 desktop kernel: [    0.017003] ... counter mask:
     000000070000000f
Apr 21 19:18:31 desktop kernel: [    0.018571] ACPI: Core revision 20090521
Apr 21 19:18:31 desktop kernel: [    0.114128] Setting APIC routing to flat
Apr 21 19:18:31 desktop kernel: [    0.114490] ..TIMER: vector=0x30
apic1=0 pin1=2 apic2=-1 pin2=-1
Apr 21 19:18:31 desktop kernel: [    0.214390] CPU0: Intel(R) Core(TM)
i7 CPU         860  @ 2.80GHz stepping 05
Apr 21 19:18:31 desktop kernel: [    0.333588] Booting processor 1
APIC 0x2 ip 0x6000
Apr 21 19:18:31 desktop kernel: [    0.344101] Initializing CPU#1
Apr 21 19:18:31 desktop kernel: [    0.493252] Calibrating delay using
timer specific routine.. 5617.35 BogoMIPS (lpj=28086763)
Apr 21 19:18:31 desktop kernel: [    0.493257] CPU: Physical Processor ID: 0
Apr 21 19:18:31 desktop kernel: [    0.493258] CPU: Processor Core ID: 1
Apr 21 19:18:31 desktop kernel: [    0.493260] CPU: L1 I cache: 32K,
L1 D cache: 32K
Apr 21 19:18:31 desktop kernel: [    0.493261] CPU: L2 cache: 256K
Apr 21 19:18:31 desktop kernel: [    0.493262] CPU: L3 cache: 8192K
Apr 21 19:18:31 desktop kernel: [    0.493263] CPU 1/0x2 -> Node 0
Apr 21 19:18:31 desktop kernel: [    0.493265] mce: CPU supports 9 MCE banks
Apr 21 19:18:31 desktop kernel: [    0.493272] CPU1: Thermal
monitoring enabled (TM1)
Apr 21 19:18:31 desktop kernel: [    0.493275] CPU 1 MCA banks CMCI:2
CMCI:3 CMCI:5 SHD:6 SHD:8
Apr 21 19:18:31 desktop kernel: [    0.493855] x86 PAT enabled: cpu 1,
old 0x7040600070406, new 0x7010600070106
Apr 21 19:18:31 desktop kernel: [    0.494460] CPU1: Intel(R) Core(TM)
i7 CPU         860  @ 2.80GHz stepping 05
Apr 21 19:18:31 desktop kernel: [    0.495105] Skipping
synchronization checks as TSC is reliable.
Apr 21 19:18:31 desktop kernel: [    0.495209] Booting processor 2
APIC 0x4 ip 0x6000
Apr 21 19:18:31 desktop kernel: [    0.505569] Initializing CPU#2
Apr 21 19:18:31 desktop kernel: [    0.652994] Calibrating delay using
timer specific routine.. 5617.35 BogoMIPS (lpj=28086766)
Apr 21 19:18:31 desktop kernel: [    0.652999] CPU: Physical Processor ID: 0
Apr 21 19:18:31 desktop kernel: [    0.653000] CPU: Processor Core ID: 2
Apr 21 19:18:31 desktop kernel: [    0.653002] CPU: L1 I cache: 32K,
L1 D cache: 32K
Apr 21 19:18:31 desktop kernel: [    0.653003] CPU: L2 cache: 256K
Apr 21 19:18:31 desktop kernel: [    0.653004] CPU: L3 cache: 8192K
Apr 21 19:18:31 desktop kernel: [    0.653006] CPU 2/0x4 -> Node 0
Apr 21 19:18:31 desktop kernel: [    0.653008] mce: CPU supports 9 MCE banks
Apr 21 19:18:31 desktop kernel: [    0.653015] CPU2: Thermal
monitoring enabled (TM1)
Apr 21 19:18:31 desktop kernel: [    0.653018] CPU 2 MCA banks CMCI:2
CMCI:3 CMCI:5 SHD:6 SHD:8
Apr 21 19:18:31 desktop kernel: [    0.653593] x86 PAT enabled: cpu 2,
old 0x7040600070406, new 0x7010600070106
Apr 21 19:18:31 desktop kernel: [    0.654180] CPU2: Intel(R) Core(TM)
i7 CPU         860  @ 2.80GHz stepping 05
Apr 21 19:18:31 desktop kernel: [    0.654825] Skipping
synchronization checks as TSC is reliable.
Apr 21 19:18:31 desktop kernel: [    0.654930] Booting processor 3
APIC 0x6 ip 0x6000
Apr 21 19:18:31 desktop kernel: [    0.665291] Initializing CPU#3
Apr 21 19:18:31 desktop kernel: [    0.812736] Calibrating delay using
timer specific routine.. 5617.35 BogoMIPS (lpj=28086773)
Apr 21 19:18:31 desktop kernel: [    0.812742] CPU: Physical Processor ID: 0
Apr 21 19:18:31 desktop kernel: [    0.812743] CPU: Processor Core ID: 3
Apr 21 19:18:31 desktop kernel: [    0.812745] CPU: L1 I cache: 32K,
L1 D cache: 32K
Apr 21 19:18:31 desktop kernel: [    0.812746] CPU: L2 cache: 256K
Apr 21 19:18:31 desktop kernel: [    0.812747] CPU: L3 cache: 8192K
Apr 21 19:18:31 desktop kernel: [    0.812748] CPU 3/0x6 -> Node 0
Apr 21 19:18:31 desktop kernel: [    0.812750] mce: CPU supports 9 MCE banks
Apr 21 19:18:31 desktop kernel: [    0.812757] CPU3: Thermal
monitoring enabled (TM1)
Apr 21 19:18:31 desktop kernel: [    0.812760] CPU 3 MCA banks CMCI:2
CMCI:3 CMCI:5 SHD:6 SHD:8
Apr 21 19:18:31 desktop kernel: [    0.813340] x86 PAT enabled: cpu 3,
old 0x7040600070406, new 0x7010600070106
Apr 21 19:18:31 desktop kernel: [    0.813902] CPU3: Intel(R) Core(TM)
i7 CPU         860  @ 2.80GHz stepping 05
Apr 21 19:18:31 desktop kernel: [    0.814547] Skipping
synchronization checks as TSC is reliable.
Apr 21 19:18:31 desktop kernel: [    0.814657] Booting processor 4
APIC 0x1 ip 0x6000
Apr 21 19:18:31 desktop kernel: [    0.825018] Initializing CPU#4
Apr 21 19:18:31 desktop kernel: [    0.972479] Calibrating delay using
timer specific routine.. 5617.34 BogoMIPS (lpj=28086749)
Apr 21 19:18:31 desktop kernel: [    0.972485] CPU: Physical Processor ID: 0
Apr 21 19:18:31 desktop kernel: [    0.972486] CPU: Processor Core ID: 0
Apr 21 19:18:31 desktop kernel: [    0.972489] CPU: L1 I cache: 32K,
L1 D cache: 32K
Apr 21 19:18:31 desktop kernel: [    0.972490] CPU: L2 cache: 256K
Apr 21 19:18:31 desktop kernel: [    0.972491] CPU: L3 cache: 8192K
Apr 21 19:18:31 desktop kernel: [    0.972493] CPU 4/0x1 -> Node 0
Apr 21 19:18:31 desktop kernel: [    0.972495] mce: CPU supports 9 MCE banks
Apr 21 19:18:31 desktop kernel: [    0.972504] CPU4: Thermal
monitoring enabled (TM1)
Apr 21 19:18:31 desktop kernel: [    0.972506] CPU 4 MCA banks SHD:2
SHD:3 SHD:5 SHD:6 SHD:8
Apr 21 19:18:31 desktop kernel: [    0.973223] x86 PAT enabled: cpu 4,
old 0x7040600070406, new 0x7010600070106
Apr 21 19:18:31 desktop kernel: [    0.973976] CPU4: Intel(R) Core(TM)
i7 CPU         860  @ 2.80GHz stepping 05
Apr 21 19:18:31 desktop kernel: [    0.974621] Skipping
synchronization checks as TSC is reliable.
Apr 21 19:18:31 desktop kernel: [    0.974727] Booting processor 5
APIC 0x3 ip 0x6000
Apr 21 19:18:31 desktop kernel: [    0.984987] Initializing CPU#5
Apr 21 19:18:31 desktop kernel: [    1.132221] Calibrating delay using
timer specific routine.. 5617.34 BogoMIPS (lpj=28086728)
Apr 21 19:18:31 desktop kernel: [    1.132227] CPU: Physical Processor ID: 0
Apr 21 19:18:31 desktop kernel: [    1.132227] CPU: Processor Core ID: 1
Apr 21 19:18:31 desktop kernel: [    1.132229] CPU: L1 I cache: 32K,
L1 D cache: 32K
Apr 21 19:18:31 desktop kernel: [    1.132230] CPU: L2 cache: 256K
Apr 21 19:18:31 desktop kernel: [    1.132231] CPU: L3 cache: 8192K
Apr 21 19:18:31 desktop kernel: [    1.132233] CPU 5/0x3 -> Node 0
Apr 21 19:18:31 desktop kernel: [    1.132235] mce: CPU supports 9 MCE banks
Apr 21 19:18:31 desktop kernel: [    1.132242] CPU5: Thermal
monitoring enabled (TM1)
Apr 21 19:18:31 desktop kernel: [    1.132244] CPU 5 MCA banks SHD:2
SHD:3 SHD:5 SHD:6 SHD:8
Apr 21 19:18:31 desktop kernel: [    1.132987] x86 PAT enabled: cpu 5,
old 0x7040600070406, new 0x7010600070106
Apr 21 19:18:31 desktop kernel: [    1.133799] CPU5: Intel(R) Core(TM)
i7 CPU         860  @ 2.80GHz stepping 05
Apr 21 19:18:31 desktop kernel: [    1.134443] Skipping
synchronization checks as TSC is reliable.
Apr 21 19:18:31 desktop kernel: [    1.134549] Booting processor 6
APIC 0x5 ip 0x6000
Apr 21 19:18:31 desktop kernel: [    1.144909] Initializing CPU#6
Apr 21 19:18:31 desktop kernel: [    1.291964] Calibrating delay using
timer specific routine.. 5617.35 BogoMIPS (lpj=28086762)
Apr 21 19:18:31 desktop kernel: [    1.291969] CPU: Physical Processor ID: 0
Apr 21 19:18:31 desktop kernel: [    1.291970] CPU: Processor Core ID: 2
Apr 21 19:18:31 desktop kernel: [    1.291972] CPU: L1 I cache: 32K,
L1 D cache: 32K
Apr 21 19:18:31 desktop kernel: [    1.291973] CPU: L2 cache: 256K
Apr 21 19:18:31 desktop kernel: [    1.291974] CPU: L3 cache: 8192K
Apr 21 19:18:31 desktop kernel: [    1.291975] CPU 6/0x5 -> Node 0
Apr 21 19:18:31 desktop kernel: [    1.291977] mce: CPU supports 9 MCE banks
Apr 21 19:18:31 desktop kernel: [    1.291984] CPU6: Thermal
monitoring enabled (TM1)
Apr 21 19:18:31 desktop kernel: [    1.291987] CPU 6 MCA banks SHD:2
SHD:3 SHD:5 SHD:6 SHD:8
Apr 21 19:18:31 desktop kernel: [    1.292724] x86 PAT enabled: cpu 6,
old 0x7040600070406, new 0x7010600070106
Apr 21 19:18:31 desktop kernel: [    1.293521] CPU6: Intel(R) Core(TM)
i7 CPU         860  @ 2.80GHz stepping 05
Apr 21 19:18:31 desktop kernel: [    1.294166] Skipping
synchronization checks as TSC is reliable.
Apr 21 19:18:31 desktop kernel: [    1.294273] Booting processor 7
APIC 0x7 ip 0x6000
Apr 21 19:18:31 desktop kernel: [    1.304633] Initializing CPU#7
Apr 21 19:18:31 desktop kernel: [    1.451706] Calibrating delay using
timer specific routine.. 5617.34 BogoMIPS (lpj=28086732)
Apr 21 19:18:31 desktop kernel: [    1.451711] CPU: Physical Processor ID: 0
Apr 21 19:18:31 desktop kernel: [    1.451712] CPU: Processor Core ID: 3
Apr 21 19:18:31 desktop kernel: [    1.451714] CPU: L1 I cache: 32K,
L1 D cache: 32K
Apr 21 19:18:31 desktop kernel: [    1.451715] CPU: L2 cache: 256K
Apr 21 19:18:31 desktop kernel: [    1.451716] CPU: L3 cache: 8192K
Apr 21 19:18:31 desktop kernel: [    1.451718] CPU 7/0x7 -> Node 0
Apr 21 19:18:31 desktop kernel: [    1.451719] mce: CPU supports 9 MCE banks
Apr 21 19:18:31 desktop kernel: [    1.451727] CPU7: Thermal
monitoring enabled (TM1)
Apr 21 19:18:31 desktop kernel: [    1.451729] CPU 7 MCA banks SHD:2
SHD:3 SHD:5 SHD:6 SHD:8
Apr 21 19:18:31 desktop kernel: [    1.452471] x86 PAT enabled: cpu 7,
old 0x7040600070406, new 0x7010600070106
Apr 21 19:18:31 desktop kernel: [    1.453244] CPU7: Intel(R) Core(TM)
i7 CPU         860  @ 2.80GHz stepping 05
Apr 21 19:18:31 desktop kernel: [    1.453889] Skipping
synchronization checks as TSC is reliable.
Apr 21 19:18:31 desktop kernel: [    1.453944] Brought up 8 CPUs
Apr 21 19:18:31 desktop kernel: [    1.453987] Total of 8 processors
activated (44939.22 BogoMIPS).
Apr 21 19:18:31 desktop kernel: [    1.454449] Booting paravirtualized
kernel on bare hardware
Apr 21 19:18:31 desktop kernel: [    1.454619] regulator: core version 0.5
Apr 21 19:18:31 desktop kernel: [    1.454684] Time: 17:18:03  Date: 04/21/10
Apr 21 19:18:31 desktop kernel: [    1.454756] NET: Registered
protocol family 16
Apr 21 19:18:31 desktop kernel: [    1.454875] ACPI: bus type pci registered
Apr 21 19:18:31 desktop kernel: [    1.454964] PCI: MCFG configuration
0: base e0000000 segment 0 buses 0 - 255
Apr 21 19:18:31 desktop kernel: [    1.455014] PCI: Not using MMCONFIG.
Apr 21 19:18:31 desktop kernel: [    1.455057] PCI: Using
configuration type 1 for base access
Apr 21 19:18:31 desktop kernel: [    1.455651] bio: create slab <bio-0> at 0
Apr 21 19:18:31 desktop kernel: [    1.469366] ACPI: Interpreter enabled
Apr 21 19:18:31 desktop kernel: [    1.469412] ACPI: (supports S0 S1 S3 S4 S5)
Apr 21 19:18:31 desktop kernel: [    1.469601] ACPI: Using IOAPIC for
interrupt routing
Apr 21 19:18:31 desktop kernel: [    1.469687] PCI: MCFG configuration
0: base e0000000 segment 0 buses 0 - 255
Apr 21 19:18:31 desktop kernel: [    1.472416] PCI: MCFG area at
e0000000 reserved in ACPI motherboard resources
Apr 21 19:18:31 desktop kernel: [    1.476992] PCI: Using MMCONFIG at
e0000000 - efffffff
Apr 21 19:18:31 desktop kernel: [    1.484489] ACPI: EC: GPE = 0x18,
I/O: command/status = 0x66, data = 0x62
Apr 21 19:18:31 desktop kernel: [    1.484538] ACPI: EC: driver
started in poll mode
Apr 21 19:18:31 desktop kernel: [    1.484649] ACPI Warning: Incorrect
checksum in table [OEMB] - 0F, should be 0E 20090521 tbutils-246
Apr 21 19:18:31 desktop kernel: [    1.484899] ACPI: No dock devices found.
Apr 21 19:18:31 desktop kernel: [    1.485197] ACPI: PCI Root Bridge
[PCI0] (0000:00)
Apr 21 19:18:31 desktop kernel: [    1.485333] pci 0000:00:03.0: PME#
supported from D0 D3hot D3cold
Apr 21 19:18:31 desktop kernel: [    1.485382] pci 0000:00:03.0: PME# disabled
Apr 21 19:18:31 desktop kernel: [    1.485710] pci 0000:00:1a.0: PME#
supported from D0 D3hot D3cold
Apr 21 19:18:31 desktop kernel: [    1.485759] pci 0000:00:1a.0: PME# disabled
Apr 21 19:18:31 desktop kernel: [    1.485872] pci 0000:00:1b.0: PME#
supported from D0 D3hot D3cold
Apr 21 19:18:31 desktop kernel: [    1.485921] pci 0000:00:1b.0: PME# disabled
Apr 21 19:18:31 desktop kernel: [    1.486013] pci 0000:00:1c.0: PME#
supported from D0 D3hot D3cold
Apr 21 19:18:31 desktop kernel: [    1.486062] pci 0000:00:1c.0: PME# disabled
Apr 21 19:18:31 desktop kernel: [    1.486157] pci 0000:00:1c.4: PME#
supported from D0 D3hot D3cold
Apr 21 19:18:31 desktop kernel: [    1.486206] pci 0000:00:1c.4: PME# disabled
Apr 21 19:18:31 desktop kernel: [    1.486299] pci 0000:00:1c.5: PME#
supported from D0 D3hot D3cold
Apr 21 19:18:31 desktop kernel: [    1.486348] pci 0000:00:1c.5: PME# disabled
Apr 21 19:18:31 desktop kernel: [    1.486441] pci 0000:00:1c.6: PME#
supported from D0 D3hot D3cold
Apr 21 19:18:31 desktop kernel: [    1.486490] pci 0000:00:1c.6: PME# disabled
Apr 21 19:18:31 desktop kernel: [    1.486584] pci 0000:00:1c.7: PME#
supported from D0 D3hot D3cold
Apr 21 19:18:31 desktop kernel: [    1.486633] pci 0000:00:1c.7: PME# disabled
Apr 21 19:18:31 desktop kernel: [    1.486768] pci 0000:00:1d.0: PME#
supported from D0 D3hot D3cold
Apr 21 19:18:31 desktop kernel: [    1.486817] pci 0000:00:1d.0: PME# disabled
Apr 21 19:18:31 desktop kernel: [    1.487066] pci 0000:00:1f.2: PME#
supported from D3hot
Apr 21 19:18:31 desktop kernel: [    1.487114] pci 0000:00:1f.2: PME# disabled
Apr 21 19:18:31 desktop kernel: [    1.487588] pci 0000:03:00.0: PME#
supported from D3hot
Apr 21 19:18:31 desktop kernel: [    1.487637] pci 0000:03:00.0: PME# disabled
Apr 21 19:18:31 desktop kernel: [    1.487965] pci 0000:02:00.0: PME#
supported from D0 D1 D2 D3hot D3cold
Apr 21 19:18:31 desktop kernel: [    1.488016] pci 0000:02:00.0: PME# disabled
Apr 21 19:18:31 desktop kernel: [    1.488199] pci 0000:07:04.0: PME#
supported from D2 D3hot D3cold
Apr 21 19:18:31 desktop kernel: [    1.488248] pci 0000:07:04.0: PME# disabled
Apr 21 19:18:31 desktop kernel: [    1.488328] pci 0000:00:1e.0:
transparent bridge
Apr 21 19:18:31 desktop kernel: [    1.506619] ACPI: PCI Interrupt
Link [LNKA] (IRQs 3 4 6 7 *10 11 12 14 15)
Apr 21 19:18:31 desktop kernel: [    1.507058] ACPI: PCI Interrupt
Link [LNKB] (IRQs *5)
Apr 21 19:18:31 desktop kernel: [    1.507282] ACPI: PCI Interrupt
Link [LNKC] (IRQs 3 4 6 7 10 11 12 14 *15)
Apr 21 19:18:31 desktop kernel: [    1.507719] ACPI: PCI Interrupt
Link [LNKD] (IRQs 3 4 6 7 10 *11 12 14 15)
Apr 21 19:18:31 desktop kernel: [    1.508156] ACPI: PCI Interrupt
Link [LNKE] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
Apr 21 19:18:31 desktop kernel: [    1.508658] ACPI: PCI Interrupt
Link [LNKF] (IRQs 3 4 6 7 10 11 12 *14 15)
Apr 21 19:18:31 desktop kernel: [    1.509095] ACPI: PCI Interrupt
Link [LNKG] (IRQs *3 4 6 7 10 11 12 14 15)
Apr 21 19:18:31 desktop kernel: [    1.509532] ACPI: PCI Interrupt
Link [LNKH] (IRQs 3 4 6 *7 10 11 12 14 15)
Apr 21 19:18:31 desktop kernel: [    1.509982] SCSI subsystem initialized
Apr 21 19:18:31 desktop kernel: [    1.510144] usbcore: registered new
interface driver usbfs
Apr 21 19:18:31 desktop kernel: [    1.510197] usbcore: registered new
interface driver hub
Apr 21 19:18:31 desktop kernel: [    1.510259] usbcore: registered new
device driver usb
Apr 21 19:18:31 desktop kernel: [    1.510373] ACPI: WMI: Mapper loaded
Apr 21 19:18:31 desktop kernel: [    1.510417] PCI: Using ACPI for IRQ routing
Apr 21 19:18:31 desktop kernel: [    1.531593] Bluetooth: Core ver 2.15
Apr 21 19:18:31 desktop kernel: [    1.531663] NET: Registered
protocol family 31
Apr 21 19:18:31 desktop kernel: [    1.531707] Bluetooth: HCI device
and connection manager initialized
Apr 21 19:18:31 desktop kernel: [    1.532389] Bluetooth: HCI socket
layer initialized
Apr 21 19:18:31 desktop kernel: [    1.532434] NetLabel: Initializing
Apr 21 19:18:31 desktop kernel: [    1.532477] NetLabel:  domain hash size = 128
Apr 21 19:18:31 desktop kernel: [    1.532522] NetLabel:  protocols =
UNLABELED CIPSOv4
Apr 21 19:18:31 desktop kernel: [    1.532575] NetLabel:  unlabeled
traffic allowed by default
Apr 21 19:18:31 desktop kernel: [    1.532655] hpet0: at MMIO
0xfed00000, IRQs 2, 8, 24, 25, 26, 27, 28, 0
Apr 21 19:18:31 desktop kernel: [    1.532942] hpet0: 8 comparators,
64-bit 14.318180 MHz counter
Apr 21 19:18:31 desktop kernel: [    1.601529] pnp: PnP ACPI init
Apr 21 19:18:31 desktop kernel: [    1.601587] ACPI: bus type pnp registered
Apr 21 19:18:31 desktop kernel: [    1.604090] pnp: PnP ACPI: found 16 devices
Apr 21 19:18:31 desktop kernel: [    1.604136] ACPI: ACPI bus type pnp
unregistered
Apr 21 19:18:31 desktop kernel: [    1.604187] system 00:01: iomem
range 0xfc000000-0xfcffffff has been reserved
Apr 21 19:18:31 desktop kernel: [    1.604237] system 00:01: iomem
range 0xfd000000-0xfdffffff has been reserved
Apr 21 19:18:31 desktop kernel: [    1.604287] system 00:01: iomem
range 0xfe000000-0xfebfffff has been reserved
Apr 21 19:18:31 desktop kernel: [    1.604336] system 00:01: iomem
range 0xfed14000-0xfed19fff has been reserved
Apr 21 19:18:31 desktop kernel: [    1.604388] system 00:06: ioport
range 0x290-0x29f has been reserved
Apr 21 19:18:31 desktop kernel: [    1.604438] system 00:07: ioport
range 0x4d0-0x4d1 has been reserved
Apr 21 19:18:31 desktop kernel: [    1.604486] system 00:07: ioport
range 0x800-0x87f has been reserved
Apr 21 19:18:31 desktop kernel: [    1.604535] system 00:07: ioport
range 0x500-0x57f has been reserved
Apr 21 19:18:31 desktop kernel: [    1.604583] system 00:07: ioport
range 0x600-0x607 has been reserved
Apr 21 19:18:31 desktop kernel: [    1.604631] system 00:07: iomem
range 0xfed1c000-0xfed1ffff has been reserved
Apr 21 19:18:31 desktop kernel: [    1.604681] system 00:07: iomem
range 0xfed20000-0xfed3ffff has been reserved
Apr 21 19:18:31 desktop kernel: [    1.604731] system 00:07: iomem
range 0xfed40000-0xfed8ffff has been reserved
Apr 21 19:18:31 desktop kernel: [    1.604782] system 00:0a: iomem
range 0xffc00000-0xffdfffff has been reserved
Apr 21 19:18:31 desktop kernel: [    1.604833] system 00:0c: iomem
range 0xfec00000-0xfec00fff could not be reserved
Apr 21 19:18:31 desktop kernel: [    1.604894] system 00:0c: iomem
range 0xfee00000-0xfee00fff has been reserved
Apr 21 19:18:31 desktop kernel: [    1.604946] system 00:0e: iomem
range 0xe0000000-0xefffffff has been reserved
Apr 21 19:18:31 desktop kernel: [    1.604997] system 00:0f: iomem
range 0x0-0x9ffff could not be reserved
Apr 21 19:18:31 desktop kernel: [    1.605046] system 00:0f: iomem
range 0xc0000-0xcffff has been reserved
Apr 21 19:18:31 desktop kernel: [    1.605095] system 00:0f: iomem
range 0xe0000-0xfffff could not be reserved
Apr 21 19:18:31 desktop kernel: [    1.605144] system 00:0f: iomem
range 0x100000-0xbfffffff could not be reserved
Apr 21 19:18:31 desktop kernel: [    1.605205] system 00:0f: iomem
range 0xfed90000-0xffffffff could not be reserved
Apr 21 19:18:31 desktop kernel: [    1.609857] AppArmor: AppArmor
Filesystem Enabled
Apr 21 19:18:31 desktop kernel: [    1.609948] pci 0000:00:03.0: PCI
bridge, secondary bus 0000:01
Apr 21 19:18:31 desktop kernel: [    1.609996] pci 0000:00:03.0:   IO
window: 0xb000-0xbfff
Apr 21 19:18:31 desktop kernel: [    1.610045] pci 0000:00:03.0:   MEM
window: 0xfbb00000-0xfbbfffff
Apr 21 19:18:31 desktop kernel: [    1.610093] pci 0000:00:03.0:
PREFETCH window: 0x000000d0000000-0x000000dfffffff
Apr 21 19:18:31 desktop kernel: [    1.610157] pci 0000:00:1c.0: PCI
bridge, secondary bus 0000:06
Apr 21 19:18:31 desktop kernel: [    1.610204] pci 0000:00:1c.0:   IO
window: disabled
Apr 21 19:18:31 desktop kernel: [    1.610251] pci 0000:00:1c.0:   MEM
window: disabled
Apr 21 19:18:31 desktop kernel: [    1.610299] pci 0000:00:1c.0:
PREFETCH window: disabled
Apr 21 19:18:31 desktop kernel: [    1.610347] pci 0000:00:1c.4: PCI
bridge, secondary bus 0000:05
Apr 21 19:18:31 desktop kernel: [    1.610394] pci 0000:00:1c.4:   IO
window: disabled
Apr 21 19:18:31 desktop kernel: [    1.610442] pci 0000:00:1c.4:   MEM
window: disabled
Apr 21 19:18:31 desktop kernel: [    1.610489] pci 0000:00:1c.4:
PREFETCH window: disabled
Apr 21 19:18:31 desktop kernel: [    1.610537] pci 0000:00:1c.5: PCI
bridge, secondary bus 0000:04
Apr 21 19:18:31 desktop kernel: [    1.610584] pci 0000:00:1c.5:   IO
window: disabled
Apr 21 19:18:31 desktop kernel: [    1.610631] pci 0000:00:1c.5:   MEM
window: disabled
Apr 21 19:18:31 desktop kernel: [    1.610678] pci 0000:00:1c.5:
PREFETCH window: disabled
Apr 21 19:18:31 desktop kernel: [    1.610727] pci 0000:00:1c.6: PCI
bridge, secondary bus 0000:03
Apr 21 19:18:31 desktop kernel: [    1.610775] pci 0000:00:1c.6:   IO
window: 0xd000-0xdfff
Apr 21 19:18:31 desktop kernel: [    1.610823] pci 0000:00:1c.6:   MEM
window: 0xfbd00000-0xfbdfffff
Apr 21 19:18:31 desktop kernel: [    1.610872] pci 0000:00:1c.6:
PREFETCH window: disabled
Apr 21 19:18:31 desktop kernel: [    1.610920] pci 0000:00:1c.7: PCI
bridge, secondary bus 0000:02
Apr 21 19:18:31 desktop kernel: [    1.610968] pci 0000:00:1c.7:   IO
window: 0xc000-0xcfff
Apr 21 19:18:31 desktop kernel: [    1.611017] pci 0000:00:1c.7:   MEM
window: 0xfbc00000-0xfbcfffff
Apr 21 19:18:31 desktop kernel: [    1.611066] pci 0000:00:1c.7:
PREFETCH window: 0x000000faf00000-0x000000faffffff
Apr 21 19:18:31 desktop kernel: [    1.611130] pci 0000:00:1e.0: PCI
bridge, secondary bus 0000:07
Apr 21 19:18:31 desktop kernel: [    1.611178] pci 0000:00:1e.0:   IO
window: 0xe000-0xefff
Apr 21 19:18:31 desktop kernel: [    1.611227] pci 0000:00:1e.0:   MEM
window: 0xfbe00000-0xfbefffff
Apr 21 19:18:31 desktop kernel: [    1.611276] pci 0000:00:1e.0:
PREFETCH window: disabled
Apr 21 19:18:31 desktop kernel: [    1.611333] pci 0000:00:03.0: PCI
INT A -> GSI 16 (level, low) -> IRQ 16
Apr 21 19:18:31 desktop kernel: [    1.611392] pci 0000:00:1c.0: PCI
INT A -> GSI 17 (level, low) -> IRQ 17
Apr 21 19:18:31 desktop kernel: [    1.611447] pci 0000:00:1c.4: PCI
INT A -> GSI 17 (level, low) -> IRQ 17
Apr 21 19:18:31 desktop kernel: [    1.611508] pci 0000:00:1c.5: PCI
INT B -> GSI 16 (level, low) -> IRQ 16
Apr 21 19:18:31 desktop kernel: [    1.611567] pci 0000:00:1c.6: PCI
INT C -> GSI 18 (level, low) -> IRQ 18
Apr 21 19:18:31 desktop kernel: [    1.611625] pci 0000:00:1c.7: PCI
INT D -> GSI 19 (level, low) -> IRQ 19
Apr 21 19:18:31 desktop kernel: [    1.611724] NET: Registered protocol family 2
Apr 21 19:18:31 desktop kernel: [    1.611878] IP route cache hash
table entries: 131072 (order: 8, 1048576 bytes)
Apr 21 19:18:31 desktop kernel: [    1.612584] TCP established hash
table entries: 524288 (order: 11, 8388608 bytes)
Apr 21 19:18:31 desktop kernel: [    1.614821] TCP bind hash table
entries: 65536 (order: 8, 1048576 bytes)
Apr 21 19:18:31 desktop kernel: [    1.615134] TCP: Hash tables
configured (established 524288 bind 65536)
Apr 21 19:18:31 desktop kernel: [    1.615183] TCP reno registered
Apr 21 19:18:31 desktop kernel: [    1.615292] NET: Registered protocol family 1
Apr 21 19:18:31 desktop kernel: [    1.615374] Trying to unpack rootfs
image as initramfs...
Apr 21 19:18:31 desktop kernel: [    2.632907] Freeing initrd memory:
66196k freed
Apr 21 19:18:31 desktop kernel: [    2.641710] Scanning for low memory
corruption every 60 seconds
Apr 21 19:18:31 desktop kernel: [    2.641837] audit: initializing
netlink socket (disabled)
Apr 21 19:18:31 desktop kernel: [    2.641892] type=2000
audit(1271870283.430:1): initialized
Apr 21 19:18:31 desktop kernel: [    2.649205] HugeTLB registered 2 MB
page size, pre-allocated 0 pages
Apr 21 19:18:31 desktop kernel: [    2.650204] VFS: Disk quotas dquot_6.5.2
Apr 21 19:18:31 desktop kernel: [    2.650284] Dquot-cache hash table
entries: 512 (order 0, 4096 bytes)
Apr 21 19:18:31 desktop kernel: [    2.650719] fuse init (API version 7.12)
Apr 21 19:18:31 desktop kernel: [    2.650814] msgmni has been set to 7911
Apr 21 19:18:31 desktop kernel: [    2.651025] alg: No test for stdrng (krng)
Apr 21 19:18:31 desktop kernel: [    2.651075] io scheduler noop registered
Apr 21 19:18:31 desktop kernel: [    2.651120] io scheduler
anticipatory registered
Apr 21 19:18:31 desktop kernel: [    2.651165] io scheduler deadline registered
Apr 21 19:18:31 desktop kernel: [    2.651237] io scheduler cfq
registered (default)
Apr 21 19:18:31 desktop kernel: [    2.690624] pci_hotplug: PCI Hot
Plug PCI Core version: 0.5
Apr 21 19:18:31 desktop kernel: [    2.690782] pciehp: PCI Express Hot
Plug Controller Driver version: 0.4
Apr 21 19:18:31 desktop kernel: [    2.690897] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
Apr 21 19:18:31 desktop kernel: [    2.690959] ACPI: Power Button [PWRF]
Apr 21 19:18:31 desktop kernel: [    2.691036] input: Power Button as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
Apr 21 19:18:31 desktop kernel: [    2.691099] ACPI: Power Button [PWRB]
Apr 21 19:18:31 desktop kernel: [    2.692286] ACPI: SSDT
00000000bf788150 0244C (v01 DpgPmm  P001Ist 00000011 INTL 20060113)
Apr 21 19:18:31 desktop kernel: [    2.692828] ACPI: SSDT
00000000bf78a5a0 00659 (v01  PmRef  P001Cst 00003001 INTL 20060113)
Apr 21 19:18:31 desktop kernel: [    2.693451] ACPI: CPU0 (power
states: C1[C1] C2[C2] C3[C3])
Apr 21 19:18:31 desktop kernel: [    2.693616] processor LNXCPU:00:
registered as cooling_device0
Apr 21 19:18:31 desktop kernel: [    2.693961] ACPI: CPU1 (power
states: C1[C1] C2[C2] C3[C3])
Apr 21 19:18:31 desktop kernel: [    2.694122] processor LNXCPU:01:
registered as cooling_device1
Apr 21 19:18:31 desktop kernel: [    2.694465] ACPI: CPU2 (power
states: C1[C1] C2[C2] C3[C3])
Apr 21 19:18:31 desktop kernel: [    2.694626] processor LNXCPU:02:
registered as cooling_device2
Apr 21 19:18:31 desktop kernel: [    2.694973] ACPI: CPU3 (power
states: C1[C1] C2[C2] C3[C3])
Apr 21 19:18:31 desktop kernel: [    2.695134] processor LNXCPU:03:
registered as cooling_device3
Apr 21 19:18:31 desktop kernel: [    2.695486] ACPI: CPU4 (power
states: C1[C1] C2[C2] C3[C3])
Apr 21 19:18:31 desktop kernel: [    2.695647] processor LNXCPU:04:
registered as cooling_device4
Apr 21 19:18:31 desktop kernel: [    2.695994] ACPI: CPU5 (power
states: C1[C1] C2[C2] C3[C3])
Apr 21 19:18:31 desktop kernel: [    2.696155] processor LNXCPU:05:
registered as cooling_device5
Apr 21 19:18:31 desktop kernel: [    2.696493] ACPI: CPU6 (power
states: C1[C1] C2[C2] C3[C3])
Apr 21 19:18:31 desktop kernel: [    2.696654] processor LNXCPU:06:
registered as cooling_device6
Apr 21 19:18:31 desktop kernel: [    2.696994] ACPI: CPU7 (power
states: C1[C1] C2[C2] C3[C3])
Apr 21 19:18:31 desktop kernel: [    2.697156] processor LNXCPU:07:
registered as cooling_device7
Apr 21 19:18:31 desktop kernel: [    2.700088] Linux agpgart interface v0.103
Apr 21 19:18:31 desktop kernel: [    2.700137] Serial: 8250/16550
driver, 4 ports, IRQ sharing enabled
Apr 21 19:18:31 desktop kernel: [    2.700272] serial8250: ttyS0 at
I/O 0x3f8 (irq = 4) is a 16550A
Apr 21 19:18:31 desktop kernel: [    2.700562] 00:0b: ttyS0 at I/O
0x3f8 (irq = 4) is a 16550A
Apr 21 19:18:31 desktop kernel: [    2.701189] brd: module loaded
Apr 21 19:18:31 desktop kernel: [    2.701488] loop: module loaded
Apr 21 19:18:31 desktop kernel: [    2.701573] input: Macintosh mouse
button emulation as /devices/virtual/input/input2
Apr 21 19:18:31 desktop kernel: [    2.701699] ahci 0000:00:1f.2: PCI
INT D -> GSI 21 (level, low) -> IRQ 21
Apr 21 19:18:31 desktop kernel: [    2.701797] ahci: SSS flag set,
parallel bus scan disabled
Apr 21 19:18:31 desktop kernel: [    2.719851] ahci 0000:00:1f.2: AHCI
0001.0300 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
Apr 21 19:18:31 desktop kernel: [    2.719921] ahci 0000:00:1f.2:
flags: 64bit ncq sntf stag pm led clo pmp pio slum part ems
Apr 21 19:18:31 desktop kernel: [    2.819710] scsi0 : ahci
Apr 21 19:18:31 desktop kernel: [    2.819805] scsi1 : ahci
Apr 21 19:18:31 desktop kernel: [    2.819875] scsi2 : ahci
Apr 21 19:18:31 desktop kernel: [    2.819948] scsi3 : ahci
Apr 21 19:18:31 desktop kernel: [    2.820022] scsi4 : ahci
Apr 21 19:18:31 desktop kernel: [    2.820091] scsi5 : ahci
Apr 21 19:18:31 desktop kernel: [    2.820213] ata1: SATA max UDMA/133
abar m2048@0xfbaf7000 port 0xfbaf7100 irq 35
Apr 21 19:18:31 desktop kernel: [    2.820275] ata2: SATA max UDMA/133
abar m2048@0xfbaf7000 port 0xfbaf7180 irq 35
Apr 21 19:18:31 desktop kernel: [    2.820336] ata3: SATA max UDMA/133
abar m2048@0xfbaf7000 port 0xfbaf7200 irq 35
Apr 21 19:18:31 desktop kernel: [    2.820398] ata4: SATA max UDMA/133
abar m2048@0xfbaf7000 port 0xfbaf7280 irq 35
Apr 21 19:18:31 desktop kernel: [    2.820459] ata5: SATA max UDMA/133
abar m2048@0xfbaf7000 port 0xfbaf7300 irq 35
Apr 21 19:18:31 desktop kernel: [    2.820521] ata6: SATA max UDMA/133
abar m2048@0xfbaf7000 port 0xfbaf7380 irq 35
Apr 21 19:18:31 desktop kernel: [    2.820616] ahci 0000:03:00.0: PCI
INT A -> GSI 18 (level, low) -> IRQ 18
Apr 21 19:18:31 desktop kernel: [    2.839657] ahci 0000:03:00.0: AHCI
0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
Apr 21 19:18:31 desktop kernel: [    2.839727] ahci 0000:03:00.0:
flags: 64bit ncq led clo pmp pio
Apr 21 19:18:31 desktop kernel: [    2.839860] scsi6 : ahci
Apr 21 19:18:31 desktop kernel: [    2.839931] scsi7 : ahci
Apr 21 19:18:31 desktop kernel: [    2.840015] ata7: SATA max UDMA/133
abar m8192@0xfbdfa000 port 0xfbdfa100 irq 18
Apr 21 19:18:31 desktop kernel: [    2.840078] ata8: SATA max UDMA/133
abar m8192@0xfbdfa000 port 0xfbdfa180 irq 18
Apr 21 19:18:31 desktop kernel: [    2.840358] pata_jmicron
0000:03:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Apr 21 19:18:31 desktop kernel: [    2.840474] scsi8 : pata_jmicron
Apr 21 19:18:31 desktop kernel: [    2.840547] scsi9 : pata_jmicron
Apr 21 19:18:31 desktop kernel: [    2.840989] ata9: PATA max UDMA/100
cmd 0xdc00 ctl 0xd880 bmdma 0xd400 irq 19
Apr 21 19:18:31 desktop kernel: [    2.841039] ata10: PATA max
UDMA/100 cmd 0xd800 ctl 0xd480 bmdma 0xd408 irq 19
Apr 21 19:18:31 desktop kernel: [    2.841388] Fixed MDIO Bus: probed
Apr 21 19:18:31 desktop kernel: [    2.841449] PPP generic driver version 2.4.2
Apr 21 19:18:31 desktop kernel: [    2.841538] ehci_hcd: USB 2.0
'Enhanced' Host Controller (EHCI) Driver
Apr 21 19:18:31 desktop kernel: [    2.841608] ehci_hcd 0000:00:1a.0:
PCI INT A -> GSI 16 (level, low) -> IRQ 16
Apr 21 19:18:31 desktop kernel: [    2.841668] ehci_hcd 0000:00:1a.0:
EHCI Host Controller
Apr 21 19:18:31 desktop kernel: [    2.841731] ehci_hcd 0000:00:1a.0:
new USB bus registered, assigned bus number 1
Apr 21 19:18:31 desktop kernel: [    2.846315] ehci_hcd 0000:00:1a.0:
debug port 2
Apr 21 19:18:31 desktop kernel: [    2.846372] ehci_hcd 0000:00:1a.0:
irq 16, io mem 0xfbafe000
Apr 21 19:18:31 desktop kernel: [    2.869583] ehci_hcd 0000:00:1a.0:
USB 2.0 started, EHCI 1.00
Apr 21 19:18:31 desktop kernel: [    2.869681] usb usb1: configuration
#1 chosen from 1 choice
Apr 21 19:18:31 desktop kernel: [    2.869744] hub 1-0:1.0: USB hub found
Apr 21 19:18:31 desktop kernel: [    2.869791] hub 1-0:1.0: 2 ports detected
Apr 21 19:18:31 desktop kernel: [    2.869885] ehci_hcd 0000:00:1d.0:
PCI INT A -> GSI 23 (level, low) -> IRQ 23
Apr 21 19:18:31 desktop kernel: [    2.869943] ehci_hcd 0000:00:1d.0:
EHCI Host Controller
Apr 21 19:18:31 desktop kernel: [    2.870006] ehci_hcd 0000:00:1d.0:
new USB bus registered, assigned bus number 2
Apr 21 19:18:31 desktop kernel: [    2.873951] ehci_hcd 0000:00:1d.0:
debug port 2
Apr 21 19:18:31 desktop kernel: [    2.874008] ehci_hcd 0000:00:1d.0:
irq 23, io mem 0xfbafd000
Apr 21 19:18:31 desktop kernel: [    2.889553] ehci_hcd 0000:00:1d.0:
USB 2.0 started, EHCI 1.00
Apr 21 19:18:31 desktop kernel: [    2.889648] usb usb2: configuration
#1 chosen from 1 choice
Apr 21 19:18:31 desktop kernel: [    2.889710] hub 2-0:1.0: USB hub found
Apr 21 19:18:31 desktop kernel: [    2.889756] hub 2-0:1.0: 2 ports detected
Apr 21 19:18:31 desktop kernel: [    2.889833] ohci_hcd: USB 1.1
'Open' Host Controller (OHCI) Driver
Apr 21 19:18:31 desktop kernel: [    2.889888] uhci_hcd: USB Universal
Host Controller Interface driver
Apr 21 19:18:31 desktop kernel: [    2.889990] PNP: PS/2 Controller
[PNP0303:PS2K] at 0x60,0x64 irq 1
Apr 21 19:18:31 desktop kernel: [    2.890038] PNP: PS/2 appears to
have AUX port disabled, if this is incorrect please boot with
i8042.nopnp
Apr 21 19:18:31 desktop kernel: [    2.890460] serio: i8042 KBD port
at 0x60,0x64 irq 1
Apr 21 19:18:31 desktop kernel: [    2.890540] mice: PS/2 mouse device
common for all mice
Apr 21 19:18:31 desktop kernel: [    2.890634] rtc_cmos 00:03: RTC can
wake from S4
Apr 21 19:18:31 desktop kernel: [    2.890696] rtc_cmos 00:03: rtc
core: registered rtc_cmos as rtc0
Apr 21 19:18:31 desktop kernel: [    2.890765] rtc0: alarms up to one
month, y3k, 114 bytes nvram, hpet irqs
Apr 21 19:18:31 desktop kernel: [    2.890892] device-mapper: uevent:
version 1.0.3
Apr 21 19:18:31 desktop kernel: [    2.890984] device-mapper: ioctl:
4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
Apr 21 19:18:31 desktop kernel: [    2.891126] device-mapper:
multipath: version 1.1.0 loaded
Apr 21 19:18:31 desktop kernel: [    2.891173] device-mapper:
multipath round-robin: version 1.0.0 loaded
Apr 21 19:18:31 desktop kernel: [    2.891540] cpuidle: using governor ladder
Apr 21 19:18:31 desktop kernel: [    2.891819] cpuidle: using governor menu
Apr 21 19:18:31 desktop kernel: [    2.892132] TCP cubic registered
Apr 21 19:18:31 desktop kernel: [    2.892259] NET: Registered
protocol family 10
Apr 21 19:18:31 desktop kernel: [    2.892600] lo: Disabled Privacy Extensions
Apr 21 19:18:31 desktop kernel: [    2.892834] NET: Registered
protocol family 17
Apr 21 19:18:31 desktop kernel: [    2.892888] Bluetooth: L2CAP ver 2.13
Apr 21 19:18:31 desktop kernel: [    2.892932] Bluetooth: L2CAP socket
layer initialized
Apr 21 19:18:31 desktop kernel: [    2.892978] Bluetooth: SCO (Voice
Link) ver 0.6
Apr 21 19:18:31 desktop kernel: [    2.893022] Bluetooth: SCO socket
layer initialized
Apr 21 19:18:31 desktop kernel: [    2.893080] Bluetooth: RFCOMM TTY
layer initialized
Apr 21 19:18:31 desktop kernel: [    2.893126] Bluetooth: RFCOMM
socket layer initialized
Apr 21 19:18:31 desktop kernel: [    2.893171] Bluetooth: RFCOMM ver 1.11
Apr 21 19:18:31 desktop kernel: [    2.895980] registered taskstats version 1
Apr 21 19:18:31 desktop kernel: [    2.896095]   Magic number: 6:639:340
Apr 21 19:18:31 desktop kernel: [    2.896252] rtc_cmos 00:03: setting
system clock to 2010-04-21 17:18:04 UTC (1271870284)
Apr 21 19:18:31 desktop kernel: [    2.896322] BIOS EDD facility v0.16
2004-Jun-25, 0 devices found
Apr 21 19:18:31 desktop kernel: [    2.896368] EDD information not available.
Apr 21 19:18:31 desktop kernel: [    2.909547] input: AT Translated
Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
Apr 21 19:18:31 desktop kernel: [    3.020283] ata9.00: ATAPI: PLEXTOR
DVDR   PX-740A, 1.02, max UDMA/33
Apr 21 19:18:31 desktop kernel: [    3.063958] ata9.00: configured for UDMA/33
Apr 21 19:18:31 desktop kernel: [    3.189267] ata8: SATA link down
(SStatus 0 SControl 300)
Apr 21 19:18:31 desktop kernel: [    3.189358] ata7: SATA link down
(SStatus 0 SControl 300)
Apr 21 19:18:31 desktop kernel: [    3.199243] usb 1-1: new high speed
USB device using ehci_hcd and address 2
Apr 21 19:18:31 desktop kernel: [    3.349010] ata1: SATA link up 3.0
Gbps (SStatus 123 SControl 300)
Apr 21 19:18:31 desktop kernel: [    3.353852] usb 1-1: configuration
#1 chosen from 1 choice
Apr 21 19:18:31 desktop kernel: [    3.354043] hub 1-1:1.0: USB hub found
Apr 21 19:18:31 desktop kernel: [    3.354271] hub 1-1:1.0: 6 ports detected
Apr 21 19:18:31 desktop kernel: [    3.371235] ata1.00: ATA-7:
HDS728080PLA380, PF2OA60A, max UDMA/133
Apr 21 19:18:31 desktop kernel: [    3.371296] ata1.00: 160836480
sectors, multi 0: LBA48 NCQ (depth 31/32)
Apr 21 19:18:31 desktop kernel: [    3.372468] ata1.00: configured for UDMA/133
Apr 21 19:18:31 desktop kernel: [    3.389071] scsi 0:0:0:0:
Direct-Access     ATA      HDS728080PLA380  PF2O PQ: 0 ANSI: 5
Apr 21 19:18:31 desktop kernel: [    3.389304] sd 0:0:0:0: Attached
scsi generic sg0 type 0
Apr 21 19:18:31 desktop kernel: [    3.389393] sd 0:0:0:0: [sda]
160836480 512-byte logical blocks: (82.3 GB/76.6 GiB)
Apr 21 19:18:31 desktop kernel: [    3.389479] sd 0:0:0:0: [sda] Write
Protect is off
Apr 21 19:18:31 desktop kernel: [    3.389538] sd 0:0:0:0: [sda] Write
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Apr 21 19:18:31 desktop kernel: [    3.389659]  sda: sda1 sda2 sda3 sda4
Apr 21 19:18:31 desktop kernel: [    3.412658] sd 0:0:0:0: [sda]
Attached SCSI disk
Apr 21 19:18:31 desktop kernel: [    3.468787] usb 2-1: new high speed
USB device using ehci_hcd and address 2
Apr 21 19:18:31 desktop kernel: [    3.622379] usb 2-1: configuration
#1 chosen from 1 choice
Apr 21 19:18:31 desktop kernel: [    3.622636] hub 2-1:1.0: USB hub found
Apr 21 19:18:31 desktop kernel: [    3.622841] hub 2-1:1.0: 8 ports detected
Apr 21 19:18:31 desktop kernel: [    3.698607] usb 1-1.3: new high
speed USB device using ehci_hcd and address 3
Apr 21 19:18:31 desktop kernel: [    3.811394] usb 1-1.3:
configuration #1 chosen from 1 choice
Apr 21 19:18:31 desktop kernel: [    3.898277] usb 2-1.3: new low
speed USB device using ehci_hcd and address 3
Apr 21 19:18:31 desktop kernel: [    4.014208] usb 2-1.3:
configuration #1 chosen from 1 choice
Apr 21 19:18:31 desktop kernel: [    4.087997] usb 2-1.4: new high
speed USB device using ehci_hcd and address 4
Apr 21 19:18:31 desktop kernel: [    4.277194] usb 2-1.4:
configuration #1 chosen from 1 choice
Apr 21 19:18:31 desktop kernel: [    4.317548] ata2: SATA link up 3.0
Gbps (SStatus 123 SControl 300)
Apr 21 19:18:31 desktop kernel: [    4.342124] ata2.00: ATA-7:
HDS728080PLA380, PF2OA60A, max UDMA/133
Apr 21 19:18:31 desktop kernel: [    4.342184] ata2.00: 160836480
sectors, multi 0: LBA48 NCQ (depth 31/32)
Apr 21 19:18:31 desktop kernel: [    4.343336] ata2.00: configured for UDMA/133
Apr 21 19:18:31 desktop kernel: [    4.357590] scsi 1:0:0:0:
Direct-Access     ATA      HDS728080PLA380  PF2O PQ: 0 ANSI: 5
Apr 21 19:18:31 desktop kernel: [    4.357758] usb 2-1.6: new low
speed USB device using ehci_hcd and address 5
Apr 21 19:18:31 desktop kernel: [    4.357894] sd 1:0:0:0: Attached
scsi generic sg1 type 0
Apr 21 19:18:31 desktop kernel: [    4.357905] sd 1:0:0:0: [sdb]
160836480 512-byte logical blocks: (82.3 GB/76.6 GiB)
Apr 21 19:18:31 desktop kernel: [    4.357933] sd 1:0:0:0: [sdb] Write
Protect is off
Apr 21 19:18:31 desktop kernel: [    4.357945] sd 1:0:0:0: [sdb] Write
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Apr 21 19:18:31 desktop kernel: [    4.358003]  sdb: sdb1 sdb2 sdb3 sdb4
Apr 21 19:18:31 desktop kernel: [    4.383499] sd 1:0:0:0: [sdb]
Attached SCSI disk
Apr 21 19:18:31 desktop kernel: [    4.476257] usb 2-1.6:
configuration #1 chosen from 1 choice
Apr 21 19:18:31 desktop kernel: [    5.286041] ata3: SATA link up 3.0
Gbps (SStatus 123 SControl 300)
Apr 21 19:18:31 desktop kernel: [    5.302788] ata3.00: ATA-8: Hitachi
HDP725050GLA360, GM4OA5CA, max UDMA/133
Apr 21 19:18:31 desktop kernel: [    5.302850] ata3.00: 976773168
sectors, multi 0: LBA48 NCQ (depth 31/32)
Apr 21 19:18:31 desktop kernel: [    5.304002] ata3.00: configured for UDMA/133
Apr 21 19:18:31 desktop kernel: [    5.316117] scsi 2:0:0:0:
Direct-Access     ATA      Hitachi HDP72505 GM4O PQ: 0 ANSI: 5
Apr 21 19:18:31 desktop kernel: [    5.316349] sd 2:0:0:0: Attached
scsi generic sg2 type 0
Apr 21 19:18:31 desktop kernel: [    5.316356] sd 2:0:0:0: [sdc]
976773168 512-byte logical blocks: (500 GB/465 GiB)
Apr 21 19:18:31 desktop kernel: [    5.316384] sd 2:0:0:0: [sdc] Write
Protect is off
Apr 21 19:18:31 desktop kernel: [    5.316395] sd 2:0:0:0: [sdc] Write
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Apr 21 19:18:31 desktop kernel: [    5.316446]  sdc: sdc1
Apr 21 19:18:31 desktop kernel: [    5.344051] sd 2:0:0:0: [sdc]
Attached SCSI disk
Apr 21 19:18:31 desktop kernel: [    5.665466] ata4: SATA link down
(SStatus 0 SControl 300)
Apr 21 19:18:31 desktop kernel: [    6.034900] ata5: SATA link down
(SStatus 0 SControl 300)
Apr 21 19:18:31 desktop kernel: [    6.408079] ata6: SATA link down
(SStatus 0 SControl 300)
Apr 21 19:18:31 desktop kernel: [    6.430436] scsi 8:0:0:0: CD-ROM
        PLEXTOR  DVDR   PX-740A   1.02 PQ: 0 ANSI: 5
Apr 21 19:18:31 desktop kernel: [    6.439126] sr0: scsi3-mmc drive:
48x/48x writer cd/rw xa/form2 cdda tray
Apr 21 19:18:31 desktop kernel: [    6.439187] Uniform CD-ROM driver
Revision: 3.20
Apr 21 19:18:31 desktop kernel: [    6.439297] sr 8:0:0:0: Attached
scsi generic sg3 type 5
Apr 21 19:18:31 desktop kernel: [    6.605885] Freeing unused kernel
memory: 664k freed
Apr 21 19:18:31 desktop kernel: [    6.606010] Write protecting the
kernel read-only data: 7476k
Apr 21 19:18:31 desktop kernel: [    6.684002] [drm] Initialized drm
1.1.0 20060810
Apr 21 19:18:31 desktop kernel: [    6.692720] usbcore: registered new
interface driver hiddev
Apr 21 19:18:31 desktop kernel: [    6.696524] input: Logitech
USB-PS/2 Optical Mouse as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0/input/input4
Apr 21 19:18:31 desktop kernel: [    6.696643] generic-usb
0003:046D:C01E.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech
USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1.3/input0
Apr 21 19:18:31 desktop kernel: [    6.700016] input: PS/2+USB Mouse
as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6:1.0/input/input5
Apr 21 19:18:31 desktop kernel: [    6.700117] generic-usb
0003:1267:0210.0002: input,hidraw1: USB HID v1.00 Mouse [PS/2+USB
Mouse] on usb-0000:00:1d.0-1.6/input0
Apr 21 19:18:31 desktop kernel: [    6.700258] usbcore: registered new
interface driver usbhid
Apr 21 19:18:31 desktop kernel: [    6.700311] usbhid: v2.6:USB HID core driver
Apr 21 19:18:31 desktop kernel: [    6.703703] [drm] radeon default to
kernel modesetting DISABLED.
Apr 21 19:18:31 desktop kernel: [    6.704301] pci 0000:01:00.0: PCI
INT A -> GSI 16 (level, low) -> IRQ 16
Apr 21 19:18:31 desktop kernel: [    6.704615] [drm] Initialized
radeon 1.31.0 20080528 for 0000:01:00.0 on minor 0
Apr 21 19:18:31 desktop kernel: [    6.716789] Initializing USB Mass
Storage driver...
Apr 21 19:18:31 desktop kernel: [    6.718017] scsi10 : SCSI emulation
for USB Mass Storage devices
Apr 21 19:18:31 desktop kernel: [    6.718184] usbcore: registered new
interface driver usb-storage
Apr 21 19:18:31 desktop kernel: [    6.718232] USB Mass Storage
support registered.
Apr 21 19:18:31 desktop kernel: [    6.719665] ohci1394 0000:07:04.0:
PCI INT A -> GSI 19 (level, low) -> IRQ 19
Apr 21 19:18:31 desktop kernel: [    6.721568] r8169 Gigabit Ethernet
driver 2.3LK-NAPI loaded
Apr 21 19:18:31 desktop kernel: [    6.721630] r8169 0000:02:00.0: PCI
INT A -> GSI 19 (level, low) -> IRQ 19
Apr 21 19:18:31 desktop kernel: [    6.722122] eth0: RTL8168d/8111d at
0xffffc9000066c000, e0:cb:4e:1b:b7:84, XID 283000c0 IRQ 36
Apr 21 19:18:31 desktop kernel: [    6.785735] ohci1394: fw-host0:
OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[fbeff000-fbeff7ff]  Max
Packet=[2048]  IR/IT contexts=[4/8]
Apr 21 19:18:31 desktop kernel: [    6.812169] md: bind<sdb2>
Apr 21 19:18:31 desktop kernel: [    6.813321] md: bind<sdb1>
Apr 21 19:18:31 desktop kernel: [    6.813639] md: bind<sdb3>
Apr 21 19:18:31 desktop kernel: [    6.814194] md: bind<sdb4>
Apr 21 19:18:31 desktop kernel: [    6.828018] md: bind<sda3>
Apr 21 19:18:31 desktop kernel: [    6.830228] md: raid1 personality
registered for level 1
Apr 21 19:18:31 desktop kernel: [    6.830561] raid1: raid set md2
active with 2 out of 2 mirrors
Apr 21 19:18:31 desktop kernel: [    6.830647] md2: detected capacity
change from 0 to 66599976960
Apr 21 19:18:31 desktop kernel: [    6.831164] md: bind<sda1>
Apr 21 19:18:31 desktop kernel: [    6.831544]  md2:
Apr 21 19:18:31 desktop kernel: [    6.832584] raid1: raid set md0
active with 2 out of 2 mirrors
Apr 21 19:18:31 desktop kernel: [    6.832684] md0: detected capacity
change from 0 to 197263360
Apr 21 19:18:31 desktop kernel: [    6.832968]  unknown partition table
Apr 21 19:18:31 desktop kernel: [    6.833180] md: bind<sda2>
Apr 21 19:18:31 desktop kernel: [    6.833409]  md0:
Apr 21 19:18:31 desktop kernel: [    6.834442] raid1: raid set md1
active with 2 out of 2 mirrors
Apr 21 19:18:31 desktop kernel: [    6.834539] md1: detected capacity
change from 0 to 15002828800
Apr 21 19:18:31 desktop kernel: [    6.835200]  md1: unknown partition table
Apr 21 19:18:31 desktop kernel: [    6.846374] md: bind<sda4>
Apr 21 19:18:31 desktop kernel: [    6.849137] md: raid0 personality
registered for level 0
Apr 21 19:18:31 desktop kernel: [    6.849518] raid0: looking at sda4
Apr 21 19:18:31 desktop kernel: [    6.849565] raid0:   comparing sda4(1060096)
Apr 21 19:18:31 desktop kernel: [    6.849598]  with sda4(1060096)
Apr 21 19:18:31 desktop kernel: [    6.849676] raid0:   END
Apr 21 19:18:31 desktop kernel: [    6.849716] raid0:   ==> UNIQUE
Apr 21 19:18:31 desktop kernel: [    6.849758] raid0: 1 zones
Apr 21 19:18:31 desktop kernel: [    6.849799] raid0: looking at sdb4
Apr 21 19:18:31 desktop kernel: [    6.849841] raid0:   comparing sdb4(1060096)
Apr 21 19:18:31 desktop kernel: [    6.849874]  with sda4(1060096)
Apr 21 19:18:31 desktop kernel: [    6.850585] raid0:   EQUAL
Apr 21 19:18:31 desktop kernel: [    6.850625] raid0: FINAL 1 zones
Apr 21 19:18:31 desktop kernel: [    6.850668] raid0: done.
Apr 21 19:18:31 desktop kernel: [    6.850709] raid0 : md_size is
2120192 sectors.
Apr 21 19:18:31 desktop kernel: [    6.850752] ******* md3
configuration *********
Apr 21 19:18:31 desktop kernel: [    6.850796] zone0=[sda4/sdb4/]
Apr 21 19:18:31 desktop kernel: [    6.850916]         zone offset=0kb
device offset=0kb size=1060096kb
Apr 21 19:18:31 desktop kernel: [    6.850963]
**********************************
Apr 21 19:18:31 desktop kernel: [    6.850963]
Apr 21 19:18:31 desktop kernel: [    6.851048] md3: detected capacity
change from 0 to 1085538304
Apr 21 19:18:31 desktop kernel: [    6.851839]  md3: unknown partition table
Apr 21 19:18:31 desktop kernel: [    6.858080]  unknown partition table
Apr 21 19:18:31 desktop kernel: [    8.088628] md: linear personality
registered for level -1
Apr 21 19:18:31 desktop kernel: [    8.089989] md: multipath
personality registered for level -4
Apr 21 19:18:31 desktop kernel: [    8.092717] xor: automatically
using best checksumming function: generic_sse
Apr 21 19:18:31 desktop kernel: [    8.142793]    generic_sse: 13814.000 MB/sec
Apr 21 19:18:31 desktop kernel: [    8.142795] xor: using function:
generic_sse (13814.000 MB/sec)
Apr 21 19:18:31 desktop kernel: [    8.143438] async_tx: api initialized (async)
Apr 21 19:18:31 desktop kernel: [    8.312559] raid6: int64x1   3025 MB/s
Apr 21 19:18:31 desktop kernel: [    8.482286] raid6: int64x2   3589 MB/s
Apr 21 19:18:31 desktop kernel: [    8.652040] raid6: int64x4   2640 MB/s
Apr 21 19:18:31 desktop kernel: [    8.821781] raid6: int64x8   2641 MB/s
Apr 21 19:18:31 desktop kernel: [    8.991516] raid6: sse2x1    8378 MB/s
Apr 21 19:18:31 desktop kernel: [    9.161239] raid6: sse2x2    9828 MB/s
Apr 21 19:18:31 desktop kernel: [    9.330993] raid6: sse2x4   11034 MB/s
Apr 21 19:18:31 desktop kernel: [    9.330994] raid6: using algorithm
sse2x4 (11034 MB/s)
Apr 21 19:18:31 desktop kernel: [    9.333026] md: raid6 personality
registered for level 6
Apr 21 19:18:31 desktop kernel: [    9.333028] md: raid5 personality
registered for level 5
Apr 21 19:18:31 desktop kernel: [    9.333029] md: raid4 personality
registered for level 4
Apr 21 19:18:31 desktop kernel: [    9.337301] md: raid10 personality
registered for level 10
Apr 21 19:18:31 desktop kernel: [    9.376625] PM: Starting manual
resume from disk
Apr 21 19:18:31 desktop kernel: [    9.404145] EXT4-fs (md1): barriers enabled
Apr 21 19:18:31 desktop kernel: [    9.414858] kjournald2 starting:
pid 539, dev md1:8, commit interval 5 seconds
Apr 21 19:18:31 desktop kernel: [    9.415853] EXT4-fs (md1): delayed
allocation enabled
Apr 21 19:18:31 desktop kernel: [    9.415859] EXT4-fs: file extents enabled
Apr 21 19:18:31 desktop kernel: [    9.416300] EXT4-fs: mballoc enabled
Apr 21 19:18:31 desktop kernel: [    9.416306] EXT4-fs (md1): mounted
filesystem with ordered data mode
Apr 21 19:18:31 desktop kernel: [    9.994491] type=1505
audit(1271870291.603:2): operation="profile_load" pid=573
name=/usr/share/gdm/guest-session/Xsession
Apr 21 19:18:31 desktop kernel: [   10.008459] type=1505
audit(1271870291.613:3): operation="profile_load" pid=574
name=/sbin/dhclient3
Apr 21 19:18:31 desktop kernel: [   10.008796] type=1505
audit(1271870291.613:4): operation="profile_load" pid=574
name=/usr/lib/NetworkManager/nm-dhcp-client.action
Apr 21 19:18:31 desktop kernel: [   10.008969] type=1505
audit(1271870291.613:5): operation="profile_load" pid=574
name=/usr/lib/connman/scripts/dhclient-script
Apr 21 19:18:31 desktop kernel: [   10.035936] type=1505
audit(1271870291.645:6): operation="profile_load" pid=575
name=/usr/bin/evince
Apr 21 19:18:31 desktop kernel: [   10.040996] type=1505
audit(1271870291.655:7): operation="profile_load" pid=575
name=/usr/bin/evince-previewer
Apr 21 19:18:31 desktop kernel: [   10.044072] type=1505
audit(1271870291.655:8): operation="profile_load" pid=575
name=/usr/bin/evince-thumbnailer
Apr 21 19:18:31 desktop kernel: [   10.073342] type=1505
audit(1271870291.685:9): operation="profile_load" pid=577
name=/usr/lib/cups/backend/cups-pdf
Apr 21 19:18:31 desktop kernel: [   10.073722] type=1505
audit(1271870291.685:10): operation="profile_load" pid=577
name=/usr/sbin/cupsd
Apr 21 19:18:31 desktop kernel: [   10.095556] type=1505
audit(1271870291.705:11): operation="profile_load" pid=578
name=/usr/sbin/mysqld-akonadi
Apr 21 19:18:31 desktop kernel: [   11.707601] scsi 10:0:0:0:
Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
Apr 21 19:18:31 desktop kernel: [   11.708479] scsi 10:0:0:1:
Direct-Access     Generic  USB CF Reader    1.01 PQ: 0 ANSI: 0
Apr 21 19:18:31 desktop kernel: [   11.709231] scsi 10:0:0:2:
Direct-Access     Generic  USB SM Reader    1.02 PQ: 0 ANSI: 0
Apr 21 19:18:31 desktop kernel: [   11.709927] scsi 10:0:0:3:
Direct-Access     Generic  USB MS Reader    1.03 PQ: 0 ANSI: 0
Apr 21 19:18:31 desktop kernel: [   11.710983] sd 10:0:0:0: Attached
scsi generic sg4 type 0
Apr 21 19:18:31 desktop kernel: [   11.711031] sd 10:0:0:1: Attached
scsi generic sg5 type 0
Apr 21 19:18:31 desktop kernel: [   11.711076] sd 10:0:0:2: Attached
scsi generic sg6 type 0
Apr 21 19:18:31 desktop kernel: [   11.711122] sd 10:0:0:3: Attached
scsi generic sg7 type 0
Apr 21 19:18:31 desktop kernel: [   11.714816] sd 10:0:0:0: [sdd]
Attached SCSI removable disk
Apr 21 19:18:31 desktop kernel: [   11.715600] sd 10:0:0:1: [sde]
Attached SCSI removable disk
Apr 21 19:18:31 desktop kernel: [   11.716435] sd 10:0:0:2: [sdf]
Attached SCSI removable disk
Apr 21 19:18:31 desktop kernel: [   11.717192] sd 10:0:0:3: [sdg]
Attached SCSI removable disk
Apr 21 19:18:31 desktop kernel: [   27.297807] udev: starting version 147
Apr 21 19:18:31 desktop kernel: [   27.326571] lp: driver loaded but
no devices found
Apr 21 19:18:31 desktop kernel: [   27.339325] Linux video capture
interface: v2.00
Apr 21 19:18:31 desktop kernel: [   27.341781] uvcvideo: Found UVC
1.00 device ViewSonic 1.3M, USB2.0 Webcam (04f2:b021)
Apr 21 19:18:31 desktop kernel: [   27.345358] input: ViewSonic 1.3M,
USB2.0 Webcam as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/2-1.4:1.0/input/input6
Apr 21 19:18:31 desktop kernel: [   27.345398] usbcore: registered new
interface driver uvcvideo
Apr 21 19:18:31 desktop kernel: [   27.345400] USB Video Class driver (v0.1.0)
Apr 21 19:18:31 desktop kernel: [   27.349542] ip_tables: (C)
2000-2006 Netfilter Core Team
Apr 21 19:18:31 desktop kernel: [   28.183402] HDA Intel 0000:00:1b.0:
PCI INT A -> GSI 22 (level, low) -> IRQ 22
Apr 21 19:18:31 desktop kernel: [   28.353795] HDA Intel 0000:01:00.1:
PCI INT B -> GSI 17 (level, low) -> IRQ 17
Apr 21 19:18:31 desktop kernel: [   28.394243] Adding 1060088k swap on
/dev/md3.  Priority:-1 extents:1 across:1060088k
Apr 21 19:18:31 desktop kernel: [   28.851388] EXT4-fs (md1): internal
journal on md1:8
Apr 21 19:18:31 desktop kernel: [   29.314706] EXT4-fs (md0): barriers enabled
Apr 21 19:18:31 desktop kernel: [   29.315093] kjournald2 starting:
pid 1042, dev md0:8, commit interval 5 seconds
Apr 21 19:18:31 desktop kernel: [   29.368410] EXT4-fs (md0): internal
journal on md0:8
Apr 21 19:18:31 desktop kernel: [   29.368412] EXT4-fs (md0): delayed
allocation enabled
Apr 21 19:18:31 desktop kernel: [   29.368414] EXT4-fs: file extents enabled
Apr 21 19:18:31 desktop kernel: [   29.368463] EXT4-fs: mballoc enabled
Apr 21 19:18:31 desktop kernel: [   29.368475] EXT4-fs (md0): mounted
filesystem with ordered data mode
Apr 21 19:18:31 desktop kernel: [   30.031738] EXT4-fs (md2): barriers enabled
Apr 21 19:18:31 desktop kernel: [   30.032134] kjournald2 starting:
pid 1057, dev md2:8, commit interval 5 seconds
Apr 21 19:18:31 desktop kernel: [   30.086399] EXT4-fs (md2): internal
journal on md2:8
Apr 21 19:18:31 desktop kernel: [   30.086406] EXT4-fs (md2): delayed
allocation enabled
Apr 21 19:18:31 desktop kernel: [   30.086410] EXT4-fs: file extents enabled
Apr 21 19:18:31 desktop kernel: [   30.086899] EXT4-fs: mballoc enabled
Apr 21 19:18:31 desktop kernel: [   30.086907] EXT4-fs (md2): mounted
filesystem with ordered data mode
Apr 21 19:18:31 desktop kernel: [   30.201827] __ratelimit: 3
callbacks suppressed
Apr 21 19:18:31 desktop kernel: [   30.201829] type=1505
audit(1271870311.845:13): operation="profile_replace" pid=1223
name=/usr/share/gdm/guest-session/Xsession
Apr 21 19:18:31 desktop kernel: [   30.202938] type=1505
audit(1271870311.845:14): operation="profile_replace" pid=1224
name=/sbin/dhclient3
Apr 21 19:18:31 desktop kernel: [   30.203311] type=1505
audit(1271870311.845:15): operation="profile_replace" pid=1224
name=/usr/lib/NetworkManager/nm-dhcp-client.action
Apr 21 19:18:31 desktop kernel: [   30.203516] type=1505
audit(1271870311.845:16): operation="profile_replace" pid=1224
name=/usr/lib/connman/scripts/dhclient-script
Apr 21 19:18:31 desktop kernel: [   30.205161] type=1505
audit(1271870311.845:17): operation="profile_replace" pid=1225
name=/usr/bin/evince
Apr 21 19:18:31 desktop kernel: [   30.210791] type=1505
audit(1271870311.855:18): operation="profile_replace" pid=1225
name=/usr/bin/evince-previewer
Apr 21 19:18:31 desktop kernel: [   30.210859] r8169: eth0: link up
Apr 21 19:18:31 desktop kernel: [   30.210862] r8169: eth0: link up
Apr 21 19:18:31 desktop kernel: [   30.214341] type=1505
audit(1271870311.855:19): operation="profile_replace" pid=1225
name=/usr/bin/evince-thumbnailer
Apr 21 19:18:31 desktop kernel: [   30.219719] type=1505
audit(1271870311.855:20): operation="profile_replace" pid=1230
name=/usr/lib/cups/backend/cups-pdf
Apr 21 19:18:31 desktop kernel: [   30.220106] type=1505
audit(1271870311.855:21): operation="profile_replace" pid=1230
name=/usr/sbin/cupsd
Apr 21 19:18:31 desktop kernel: [   30.221264] type=1505
audit(1271870311.865:22): operation="profile_replace" pid=1231
name=/usr/sbin/mysqld-akonadi
Apr 21 19:18:32 desktop kernel: [   31.112748] usplash:474 freeing
invalid memtype ffffffffd0000000-ffffffffd1000000
Apr 21 19:18:32 desktop kernel: [   31.341107] mtrr: type mismatch for
d0000000,10000000 old: write-back new: write-combining
Apr 21 19:18:32 desktop kernel: [   31.341138] mtrr: type mismatch for
d0000000,10000000 old: write-back new: write-combining
Apr 21 19:18:33 desktop kernel: [   31.586968] mtrr: type mismatch for
d0000000,10000000 old: write-back new: write-combining
Apr 21 19:18:33 desktop kernel: [   31.586999] mtrr: type mismatch for
d0000000,10000000 old: write-back new: write-combining
Apr 21 19:18:33 desktop kernel: [   31.587019] mtrr: type mismatch for
d0000000,10000000 old: write-back new: write-combining
Apr 21 19:18:33 desktop kernel: [   31.601552] [drm] Setting GART
location based on new memory map
Apr 21 19:18:33 desktop kernel: [   31.616705] [drm] Loading RV710 PFP Microcode
Apr 21 19:18:33 desktop kernel: [   31.616812] [drm] Loading RV710 CP Microcode
Apr 21 19:18:33 desktop kernel: [   31.632000] [drm] Resetting GPU
Apr 21 19:18:33 desktop kernel: [   31.632057] [drm] writeback test
succeeded in 1 usecs
Apr 21 19:18:36 desktop kernel: [   33.506213] hda-intel: IRQ timing
workaround is activated for card #1. Suggest a bigger bdl_pos_adj.
Apr 21 19:18:40 desktop kernel: [   36.896578] RPC: Registered udp
transport module.
Apr 21 19:18:40 desktop kernel: [   36.896583] RPC: Registered tcp
transport module.
Apr 21 19:18:40 desktop kernel: [   37.373708] VBoxDrv: dbg -
g_abExecMemory=ffffffffa03d2480
Apr 21 19:18:40 desktop kernel: [   37.373965] vboxdrv: fAsync=0
offMin=0x1f8 offMax=0x4e00
Apr 21 19:18:40 desktop kernel: [   37.374082] vboxdrv: TSC mode is
'synchronous', kernel timer mode is 'normal'.
Apr 21 19:18:40 desktop kernel: [   37.622694] ppdev: user-space
parallel port driver
Apr 21 19:18:54 desktop kernel: [   51.266280] svc: failed to register
lockdv1 RPC service (errno 97).
Apr 21 19:20:03 desktop kernel: [  119.920702] ata2: hard resetting link
Apr 21 19:20:03 desktop kernel: [  120.449693] ata2: SATA link up 3.0
Gbps (SStatus 123 SControl 300)
Apr 21 19:20:03 desktop kernel: [  120.451774] ata2.00: configured for UDMA/133
Apr 21 19:20:03 desktop kernel: [  120.451782] ata2.00: device
reported invalid CHS sector 0
Apr 21 19:20:03 desktop kernel: [  120.451786] ata2.00: device
reported invalid CHS sector 0
Apr 21 19:20:03 desktop kernel: [  120.451790] ata2.00: device
reported invalid CHS sector 0
Apr 21 19:20:03 desktop kernel: [  120.451801] ata2: EH complete
Apr 21 19:20:34 desktop kernel: [  150.873301] ata2: hard resetting link
Apr 21 19:20:34 desktop kernel: [  151.402315] ata2: SATA link up 3.0
Gbps (SStatus 123 SControl 300)
Apr 21 19:20:34 desktop kernel: [  151.404410] ata2.00: configured for UDMA/133
Apr 21 19:20:34 desktop kernel: [  151.404417] ata2.00: device
reported invalid CHS sector 0
Apr 21 19:20:34 desktop kernel: [  151.404421] ata2.00: device
reported invalid CHS sector 0
Apr 21 19:20:34 desktop kernel: [  151.404430] ata2: EH complete
Apr 21 19:20:42 desktop pulseaudio[2352]: ratelimit.c: 4 events suppressed
Apr 21 19:21:05 desktop kernel: [  181.825926] ata2: hard resetting link
Apr 21 19:21:05 desktop kernel: [  182.354938] ata2: SATA link up 3.0
Gbps (SStatus 123 SControl 300)
Apr 21 19:21:05 desktop kernel: [  182.357025] ata2.00: configured for UDMA/133
Apr 21 19:21:05 desktop kernel: [  182.357033] ata2.00: device
reported invalid CHS sector 0
Apr 21 19:21:05 desktop kernel: [  182.357042] ata2: EH complete
Apr 21 19:24:03 desktop kernel: [  359.583671] ata2.00: NCQ disabled
due to excessive errors
Apr 21 19:24:03 desktop kernel: [  359.583916] ata2: hard resetting link
Apr 21 19:24:03 desktop kernel: [  360.112918] ata2: SATA link up 3.0
Gbps (SStatus 123 SControl 300)
Apr 21 19:24:03 desktop kernel: [  360.115236] ata2.00: configured for UDMA/133
Apr 21 19:24:03 desktop kernel: [  360.115245] ata2.00: device
reported invalid CHS sector 0
Apr 21 19:24:03 desktop kernel: [  360.115250] ata2.00: device
reported invalid CHS sector 0
Apr 21 19:24:03 desktop kernel: [  360.115253] ata2.00: device
reported invalid CHS sector 0
Apr 21 19:24:03 desktop kernel: [  360.115257] ata2.00: device
reported invalid CHS sector 0
Apr 21 19:24:03 desktop kernel: [  360.115260] ata2.00: device
reported invalid CHS sector 0
Apr 21 19:24:03 desktop kernel: [  360.115263] ata2.00: device
reported invalid CHS sector 0
Apr 21 19:24:03 desktop kernel: [  360.115267] ata2.00: device
reported invalid CHS sector 0
Apr 21 19:24:03 desktop kernel: [  360.115270] ata2.00: device
reported invalid CHS sector 0
Apr 21 19:24:03 desktop kernel: [  360.115273] ata2.00: device
reported invalid CHS sector 0
Apr 21 19:24:03 desktop kernel: [  360.115277] ata2.00: device
reported invalid CHS sector 0
Apr 21 19:24:03 desktop kernel: [  360.115280] ata2.00: device
reported invalid CHS sector 0
Apr 21 19:24:03 desktop kernel: [  360.115299] ata2.00: device
reported invalid CHS sector 0
Apr 21 19:24:03 desktop kernel: [  360.115302] ata2.00: device
reported invalid CHS sector 0
Apr 21 19:24:03 desktop kernel: [  360.115306] ata2.00: device
reported invalid CHS sector 0
Apr 21 19:24:03 desktop kernel: [  360.115309] ata2.00: device
reported invalid CHS sector 0
Apr 21 19:24:03 desktop kernel: [  360.115312] ata2.00: device
reported invalid CHS sector 0
Apr 21 19:24:03 desktop kernel: [  360.115332] ata2: EH complete
