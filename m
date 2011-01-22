Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab1AVMpv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 07:45:51 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:56109 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab1AVMpr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 07:45:47 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 22 Jan 2011 13:45:13 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Henrik Rydberg <rydberg@euromail.se>, lm-sensors@lm-sensors.org
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.38-rc1/-2: applesmc lockdep warning
Message-ID: <20110122134513.1e1d512a@stein>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

since 2.6.38-rc1, the following shows up in dmesg.  Full dmesg is included
below the signature.  This is a Macmini1,1 i.e. a first-generation
Intel-based mini.  I haven't experienced any actual problem during usage
but haven't used it a lot under 2.6.38-rc yet.

applesmc: key=137 fan=1 temp=7 acc=0 lux=0 kbd=0
applesmc: init_smcreg() took 50 ms
BUG: key f4891a1c not in .data!
------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2701 lockdep_init_map+0xd8/0x442()
Hardware name: Macmini1,1
Modules linked in: snd_hda_codec_idt snd_hda_intel snd_hda_codec applesmc(+) input_polldev snd_pcm rtc snd_timer i2c_i801 sg sr_mod cdrom snd sky2 snd_page_alloc
Pid: 763, comm: modprobe Not tainted 2.6.38-rc2 #2
Call Trace:
 [<c1029b5b>] ? warn_slowpath_common+0x60/0x75
 [<c1029b7f>] ? warn_slowpath_null+0xf/0x13
 [<c104a15a>] ? lockdep_init_map+0xd8/0x442
 [<c10cbea1>] ? sysfs_new_dirent+0x73/0xdb
 [<c10cb829>] ? sysfs_add_file_mode+0x4c/0x88
 [<c10cb873>] ? sysfs_add_file+0xe/0x13
 [<c10cb905>] ? sysfs_create_file+0x20/0x22
 [<f8116eb9>] ? applesmc_create_nodes+0xac/0xf1 [applesmc]
 [<f812b0b2>] ? applesmc_init+0xb2/0x1000 [applesmc]
 [<c100115e>] ? do_one_initcall+0x71/0x113
 [<f812b000>] ? applesmc_init+0x0/0x1000 [applesmc]
 [<c1053d13>] ? sys_init_module+0xb3/0x1e2
 [<c1002910>] ? sysenter_do_call+0x12/0x31
---[ end trace f4dc91d2a456dccb ]---
BUG: key f42962fc not in .data!
BUG: key f4296394 not in .data!
BUG: key f42b7dac not in .data!
BUG: key f42b7d14 not in .data!
BUG: key f42b7c7c not in .data!
BUG: key f42b7be4 not in .data!
BUG: key f42b7b4c not in .data!
BUG: key f42b7ab4 not in .data!
BUG: key f42b7a1c not in .data!
BUG: key f4296f74 not in .data!
BUG: key f4296edc not in .data!
BUG: key f4296e44 not in .data!
BUG: key f4296dac not in .data!
BUG: key f411adfc not in .data!
BUG: key f411ae3c not in .data!
BUG: key f411ae7c not in .data!
BUG: key f411aebc not in .data!
BUG: key f411aefc not in .data!
BUG: key f411af3c not in .data!
BUG: key f411af7c not in .data!
BUG: key f4100dfc not in .data!
BUG: key f4100e3c not in .data!
BUG: key f4100e7c not in .data!
BUG: key f4100ebc not in .data!
BUG: key f4100efc not in .data!
BUG: key f4100f3c not in .data!
BUG: key f4100f7c not in .data!

Any ideas where this may come from?
-- 
Stefan Richter
-=====-==-== ---= =-==-
http://arcgraph.de/sr/


Linux version 2.6.38-rc2 (stefan@mini) (gcc version 4.3.4 (Gentoo 4.3.4 p1.0, pie-10.1.5) ) #2 SMP PREEMPT Sat Jan 22 13:15:45 CET 2011
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000ede00 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007e0d5000 (usable)
 BIOS-e820: 000000007e0d5000 - 000000007e2d6000 (ACPI NVS)
 BIOS-e820: 000000007e2d6000 - 000000007eebf000 (ACPI data)
 BIOS-e820: 000000007eebf000 - 000000007eeef000 (ACPI NVS)
 BIOS-e820: 000000007eeef000 - 000000007ef00000 (ACPI data)
 BIOS-e820: 000000007ef00000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
DMI 2.4 present.
DMI: Mac-F4208EC8/Macmini1,1, BIOS     MM11.88Z.0055.B08.0610121326 10/12/06
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
last_pfn = 0x7e0d5 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CFFFF write-protect
  D0000-DFFFF uncachable
  E0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 0FFE00000 mask FFFE00000 write-protect
  1 base 000000000 mask F80000000 write-back
  2 base 07F000000 mask FFF000000 uncachable
  3 base 07EF00000 mask FFFF00000 uncachable
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
initial memory mapped : 0 - 01c00000
init_memory_mapping: 0000000000000000-00000000377fe000
 0000000000 - 00377fe000 page 4k
kernel direct mapping tables up to 377fe000 @ 1b1f000-1c00000
ACPI: RSDP 000fe020 00024 (v02 APPLE )
ACPI: XSDT 7eefd120 00074 (v01 APPLE   Apple00 00000055      01000013)
ACPI: FACP 7eefb000 000F4 (v03 APPLE   Apple00 00000055 Loki 0000005F)
ACPI: DSDT 7eef1000 0389A (v01 APPLE   Macmini 00010001 INTL 20050309)
ACPI: FACS 7eec1000 00040
ACPI: HPET 7eefa000 00038 (v01 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: APIC 7eef9000 00068 (v01 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: MCFG 7eef8000 0003C (v01 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: ASF! 7eef7000 0009C (v32 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: SBST 7eef6000 00030 (v01 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: ECDT 7eef5000 00053 (v01 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: SSDT 7eebd000 0064F (v01 APPLE   SataPri 00001000 INTL 20050309)
ACPI: SSDT 7eebc000 0069C (v01 APPLE   SataSec 00001000 INTL 20050309)
ACPI: SSDT 7eef0000 004DC (v01 APPLE     CpuPm 00003000 INTL 20050309)
ACPI: Local APIC address 0xfee00000
1128MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 0 - 377fe000
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x0007e0d5
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0007e0d5
On node 0 totalpages: 516196
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3951 pages, LIFO batch:0
  Normal zone: 1744 pages used for memmap
  Normal zone: 221486 pages, LIFO batch:31
  HighMem zone: 2258 pages used for memmap
  HighMem zone: 286725 pages, LIFO batch:31
Using APIC driver default
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000ee000
PM: Registered nosave memory: 00000000000ee000 - 0000000000100000
Allocating PCI resources starting at 80000000 (gap: 80000000:60000000)
setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 12 pages/cpu @f6000000 s25216 r0 d23936 u2097152
pcpu-alloc: s25216 r0 d23936 u2097152 alloc=1*4194304
pcpu-alloc: [0] 0 1 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 512162
Kernel command line: root=/dev/sda3
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Initializing CPU#0
Initializing HighMem for node 0 (000377fe:0007e0d5)
Memory: 2037440k/2065236k available (2497k kernel code, 27344k reserved, 1394k data, 336k init, 1155932k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff8f000 - 0xfffff000   ( 448 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc13cd000 - 0xc1421000   ( 336 kB)
      .data : 0xc127066a - 0xc13ccf80   (1394 kB)
      .text : 0xc1000000 - 0xc127066a   (2497 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Preemptable hierarchical RCU implementation.
	RCU-based detection of stalled CPUs is disabled.
	Verbose stalled-CPUs detection is disabled.
NR_IRQS:320
CPU 0 irqstacks, hard=f5c0a000 soft=f5c0c000
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
 memory used by lock dependency info: 3551 kB
 per task-struct memory footprint: 1152 bytes
ODEBUG: 5 of 5 active objects replaced
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2333.309 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 4666.61 BogoMIPS (lpj=2333309)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
ACPI: Core revision 20110112
Enabling APIC mode:  Flat.  Using 1 I/O APICs
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 CPU         T7600  @ 2.33GHz stepping 06
Performance Events: PEBS fmt0-, Core2 events, Intel PMU driver.
PEBS disabled due to CPU errata.
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
lockdep: fixing up alternatives.
CPU 1 irqstacks, hard=f5d42000 soft=f5d44000
Booting Node   0, Processors  #1 Ok.
Initializing CPU#1
Brought up 2 CPUs
Total of 2 processors activated (9333.03 BogoMIPS).
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: EC description table is found, configuring boot EC
[Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
ACPI: SSDT 7eebac90 0022A (v01 APPLE   Cpu0Ist 00003000 INTL 20050309)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 0022A (v01 APPLE   Cpu0Ist 00003000 INTL 20050309)
ACPI: SSDT 7eeb9e10 001BA (v01 APPLE   Cpu0Cst 00003001 INTL 20050309)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 001BA (v01 APPLE   Cpu0Cst 00003001 INTL 20050309)
ACPI: SSDT 7eebaf10 00087 (v01 APPLE   Cpu1Ist 00003000 INTL 20050309)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 00087 (v01 APPLE   Cpu1Ist 00003000 INTL 20050309)
ACPI: SSDT 7eeb8f10 00085 (v01 APPLE   Cpu1Cst 00003000 INTL 20050309)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 00085 (v01 APPLE   Cpu1Cst 00003000 INTL 20050309)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: No dock devices found.
PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x80000000-0xfebfffff] (ignored)
pci 0000:00:00.0: [8086:27a0] type 0 class 0x000600
pci 0000:00:02.0: [8086:27a2] type 0 class 0x000300
pci 0000:00:02.0: reg 10: [mem 0x90380000-0x903fffff]
pci 0000:00:02.0: reg 14: [io  0x20f0-0x20f7]
pci 0000:00:02.0: reg 18: [mem 0x80000000-0x8fffffff pref]
pci 0000:00:02.0: reg 1c: [mem 0x90400000-0x9043ffff]
pci 0000:00:07.0: [8086:27a3] type 0 class 0x001101
pci 0000:00:07.0: reg 10: [mem 0x90444000-0x90444fff]
pci 0000:00:1b.0: [8086:27d8] type 0 class 0x000403
pci 0000:00:1b.0: reg 10: [mem 0x90440000-0x90443fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: [8086:27d0] type 1 class 0x000604
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: [8086:27d2] type 1 class 0x000604
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1d.0: [8086:27c8] type 0 class 0x000c03
pci 0000:00:1d.0: reg 20: [io  0x20a0-0x20bf]
pci 0000:00:1d.1: [8086:27c9] type 0 class 0x000c03
pci 0000:00:1d.1: reg 20: [io  0x2080-0x209f]
pci 0000:00:1d.2: [8086:27ca] type 0 class 0x000c03
pci 0000:00:1d.2: reg 20: [io  0x2060-0x207f]
pci 0000:00:1d.3: [8086:27cb] type 0 class 0x000c03
pci 0000:00:1d.3: reg 20: [io  0x2040-0x205f]
pci 0000:00:1d.7: [8086:27cc] type 0 class 0x000c03
pci 0000:00:1d.7: reg 10: [mem 0x90445400-0x904457ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
pci 0000:00:1f.0: [8086:27b9] type 0 class 0x000601
pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 1640 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 4700 (mask 0003)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0300 (mask 001f)
pci 0000:00:1f.1: [8086:27df] type 0 class 0x000101
pci 0000:00:1f.1: reg 10: [io  0x20e8-0x20ef]
pci 0000:00:1f.1: reg 14: [io  0x2104-0x2107]
pci 0000:00:1f.1: reg 18: [io  0x20e0-0x20e7]
pci 0000:00:1f.1: reg 1c: [io  0x2100-0x2103]
pci 0000:00:1f.1: reg 20: [io  0x20c0-0x20cf]
pci 0000:00:1f.2: [8086:27c4] type 0 class 0x000101
pci 0000:00:1f.2: reg 10: [io  0x20d8-0x20df]
pci 0000:00:1f.2: reg 14: [io  0x20fc-0x20ff]
pci 0000:00:1f.2: reg 18: [io  0x20d0-0x20d7]
pci 0000:00:1f.2: reg 1c: [io  0x20f8-0x20fb]
pci 0000:00:1f.2: reg 20: [io  0x2020-0x202f]
pci 0000:00:1f.2: reg 24: [mem 0x90445000-0x904453ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: [8086:27da] type 0 class 0x000c05
pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
pci 0000:01:00.0: [11ab:4362] type 0 class 0x000200
pci 0000:01:00.0: reg 10: [mem 0x90200000-0x90203fff 64bit]
pci 0000:01:00.0: reg 18: [io  0x1000-0x10ff]
pci 0000:01:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
pci 0000:01:00.0: supports D1 D2
pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:01:00.0: PME# disabled
pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:1c.0: PCI bridge to [bus 01-01]
pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
pci 0000:00:1c.0:   bridge window [mem 0x90200000-0x902fffff]
pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:02:00.0: [168c:001c] type 0 class 0x000200
pci 0000:02:00.0: reg 10: [mem 0x90100000-0x9010ffff 64bit]
pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:1c.1: PCI bridge to [bus 02-02]
pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1c.1:   bridge window [mem 0x90100000-0x901fffff]
pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:03:03.0: [11c1:5811] type 0 class 0x000c00
pci 0000:03:03.0: reg 10: [mem 0x90000000-0x90000fff]
pci 0000:03:03.0: supports D1 D2
pci 0000:03:03.0: PME# supported from D0 D1 D2 D3hot
pci 0000:03:03.0: PME# disabled
pci 0000:00:1e.0: PCI bridge to [bus 03-03] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1e.0:   bridge window [mem 0x90000000-0x900fffff]
pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffff] (subtractive decode)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
reserve RAM buffer: 000000007e0d5000 - 000000007fffffff 
Switching to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [bus 00-ff]
pnp 00:00: [io  0x0000-0x0cf7 window]
pnp 00:00: [io  0x0cf8-0x0cff]
pnp 00:00: [io  0x0d00-0xffff window]
pnp 00:00: [mem 0x000a0000-0x000bffff window]
pnp 00:00: [mem 0x000c0000-0x000c3fff window]
pnp 00:00: [mem 0x000c4000-0x000c7fff window]
pnp 00:00: [mem 0x000c8000-0x000cbfff window]
pnp 00:00: [mem 0x000cc000-0x000cffff window]
pnp 00:00: [mem 0x000d0000-0x000d3fff window]
pnp 00:00: [mem 0x000d4000-0x000d7fff window]
pnp 00:00: [mem 0x000d8000-0x000dbfff window]
pnp 00:00: [mem 0x000dc000-0x000dffff window]
pnp 00:00: [mem 0x000e0000-0x000e3fff window]
pnp 00:00: [mem 0x000e4000-0x000e7fff window]
pnp 00:00: [mem 0x000e8000-0x000ebfff window]
pnp 00:00: [mem 0x000ec000-0x000effff window]
pnp 00:00: [mem 0x000f0000-0x000fffff window]
pnp 00:00: [mem 0x80000000-0xfebfffff window]
pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:01: [mem 0xe0000000-0xefffffff]
pnp 00:01: [mem 0xfed14000-0xfed17fff]
pnp 00:01: [mem 0xfed18000-0xfed18fff]
pnp 00:01: [mem 0xfed19000-0xfed19fff]
pnp 00:01: [mem 0xfed1c000-0xfed1ffff]
pnp 00:01: [mem 0xfed20000-0xfed8ffff]
system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:01: [mem 0xfed20000-0xfed8ffff] has been reserved
system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:02: [io  0x0300-0x031f]
pnp 00:02: [irq 6]
pnp 00:02: Plug and Play ACPI device, IDs APP0001 (active)
pnp 00:03: [io  0x004e-0x004f]
pnp 00:03: [io  0x4700-0x470b]
pnp 00:03: Plug and Play ACPI device, IDs IFX0101 (active)
pnp 00:04: [io  0x0000-0x001f]
pnp 00:04: [io  0x0081-0x0091]
pnp 00:04: [io  0x0093-0x009f]
pnp 00:04: [io  0x00c0-0x00df]
pnp 00:04: [dma 4]
pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:05: [mem 0xff000000-0xffffffff]
pnp 00:05: Plug and Play ACPI device, IDs INT0800 (active)
pnp 00:06: [irq 0 disabled]
pnp 00:06: [irq 8]
pnp 00:06: [mem 0xfed00000-0xfed003ff]
system 00:06: [mem 0xfed00000-0xfed003ff] has been reserved
system 00:06: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
pnp 00:07: [io  0x00f0]
pnp 00:07: [irq 13]
pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:08: [io  0x002e-0x002f]
pnp 00:08: [io  0x004e-0x004f]
pnp 00:08: [io  0x0061]
pnp 00:08: [io  0x0063]
pnp 00:08: [io  0x0065]
pnp 00:08: [io  0x0067]
pnp 00:08: [io  0x0070]
pnp 00:08: [io  0x0080]
pnp 00:08: [io  0x0092]
pnp 00:08: [io  0x00b2-0x00b3]
pnp 00:08: [io  0x0680-0x06ef]
pnp 00:08: [io  0x0800-0x080f]
pnp 00:08: [io  0x0810-0x0817]
pnp 00:08: [io  0x0400-0x047f]
pnp 00:08: [io  0x0500-0x053f]
pnp 00:08: [io  0x1640-0x164f]
pnp 00:08: disabling [io  0x1640-0x164f] because it overlaps 0000:00:1c.0 BAR 7 [io  0x1000-0x1fff]
system 00:08: [io  0x0680-0x06ef] has been reserved
system 00:08: [io  0x0800-0x080f] has been reserved
system 00:08: [io  0x0810-0x0817] has been reserved
system 00:08: [io  0x0400-0x047f] has been reserved
system 00:08: [io  0x0500-0x053f] has been reserved
system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:09: [io  0x0070-0x0077]
pnp 00:09: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
pci 0000:01:00.0: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]
pci 0000:00:1c.0: BAR 9: assigned [mem 0x90500000-0x906fffff pref]
pci 0000:00:1c.1: BAR 9: assigned [mem 0x90700000-0x908fffff 64bit pref]
pci 0000:00:1c.1: BAR 7: assigned [io  0x3000-0x3fff]
pci 0000:01:00.0: BAR 6: assigned [mem 0x90500000-0x9051ffff pref]
pci 0000:00:1c.0: PCI bridge to [bus 01-01]
pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
pci 0000:00:1c.0:   bridge window [mem 0x90200000-0x902fffff]
pci 0000:00:1c.0:   bridge window [mem 0x90500000-0x906fffff pref]
pci 0000:00:1c.1: PCI bridge to [bus 02-02]
pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.1:   bridge window [mem 0x90100000-0x901fffff]
pci 0000:00:1c.1:   bridge window [mem 0x90700000-0x908fffff 64bit pref]
pci 0000:00:1e.0: PCI bridge to [bus 03-03]
pci 0000:00:1e.0:   bridge window [io  disabled]
pci 0000:00:1e.0:   bridge window [mem 0x90000000-0x900fffff]
pci 0000:00:1e.0:   bridge window [mem pref disabled]
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1e.0: power state changed by ACPI to D0
pci 0000:00:1e.0: power state changed by ACPI to D0
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:01: resource 1 [mem 0x90200000-0x902fffff]
pci_bus 0000:01: resource 2 [mem 0x90500000-0x906fffff pref]
pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
pci_bus 0000:02: resource 1 [mem 0x90100000-0x901fffff]
pci_bus 0000:02: resource 2 [mem 0x90700000-0x908fffff 64bit pref]
pci_bus 0000:03: resource 1 [mem 0x90000000-0x900fffff]
pci_bus 0000:03: resource 4 [io  0x0000-0xffff]
pci_bus 0000:03: resource 5 [mem 0x00000000-0xffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
UDP hash table entries: 512 (order: 3, 40960 bytes)
UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
NET: Registered protocol family 1
pci 0000:00:02.0: Boot video device
PCI: CLS mismatch (256 != 64), using 64 bytes
DMA-API: preallocated 32768 debug entries
DMA-API: debugging enabled by kernel config
highmem bounce pool size: 64 pages
msgmni has been set to 1721
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:1c.0: setting latency timer to 64
pcieport 0000:00:1c.1: setting latency timer to 64
intel_idle: MWAIT substates: 0x22220
intel_idle: does not run on family 6 model 15
input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
ACPI: acpi_idle registered with cpuidle
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Marking TSC unstable due to TSC halts in idle
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 945GM Chipset
agpgart-intel 0000:00:00.0: detected gtt size: 262144K total, 262144K mappable
agpgart-intel 0000:00:00.0: detected 16384K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x80000000
[drm] Initialized drm 1.1.0 20060810
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[drm] initialized overlay support
Console: switching to colour frame buffer device 210x65
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
loop: module loaded
ata_piix 0000:00:1f.1: version 2.13
ata_piix 0000:00:1f.1: power state changed by ACPI to D0
ata_piix 0000:00:1f.1: power state changed by ACPI to D0
ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x20c0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x20c8 irq 15
ata_piix 0000:00:1f.2: enabling device (0005 -> 0007)
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
ata_piix 0000:00:1f.2: setting latency timer to 64
ata1.00: ATAPI: MATSHITACD-RW  CW-8124, DACH, max UDMA/33
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0x20d8 ctl 0x20fc bmdma 0x2020 irq 19
ata4: SATA max UDMA/133 cmd 0x20d0 ctl 0x20f8 bmdma 0x2028 irq 19
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 21 (level, low) -> IRQ 21
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ata1.00: configured for UDMA/33
ehci_hcd 0000:00:1d.7: using broken periodic workaround
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.7: irq 21, io mem 0x90445400
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
scsi 0:0:0:0: CD-ROM            MATSHITA CD-RW  CW-8124   DACH PQ: 0 ANSI: 5
uhci_hcd 0000:00:1d.0: irq 21, io base 0x000020a0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002080
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002060
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 16, io base 0x00002040
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
i8042: PNP: No PS/2 controller found. Probing ports directly.
i8042: No controller found
mousedev: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
TCP cubic registered
NET: Registered protocol family 17
Using IPI No-Shortcut mode
ata3.01: ATA-7: STT_FTM28GX25H, 1571, max UDMA/133
ata3.01: 250069680 sectors, multi 1: LBA48 NCQ (depth 0/32)
ata3.01: configured for UDMA/133
scsi 2:0:1:0: Direct-Access     ATA      STT_FTM28GX25H   1571 PQ: 0 ANSI: 5
sd 2:0:1:0: [sda] 250069680 512-byte logical blocks: (128 GB/119 GiB)
sd 2:0:1:0: [sda] Write Protect is off
sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 2:0:1:0: [sda] Attached SCSI disk
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda3): mounted filesystem with writeback data mode
VFS: Mounted root (ext3 filesystem) readonly on device 8:3.
debug: unmapping init memory c13cd000..c1421000
Write protecting the kernel text: 2500k
Write protecting the kernel read-only data: 1152k
udev: starting version 151
udevd (678): /proc/678/oom_adj is deprecated, please use /proc/678/oom_score_adj instead.
usb 3-1: new full speed USB device using uhci_hcd and address 2
sky2: driver version 1.28
sky2 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
sky2 0000:01:00.0: setting latency timer to 64
sky2 0000:01:00.0: Yukon-2 EC chip revision 2
sky2 0000:01:00.0: eth0: addr 00:16:cb:a7:02:56
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ACPI: resource 0000:00:1f.3 [io  0xefa0-0xefbf] conflicts with ACPI region SMBI [io 0xefa0-0xefaf]
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
sr 0:0:0:0: Attached scsi generic sg0 type 5
sd 2:0:1:0: Attached scsi generic sg1 type 0
sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 0:0:0:0: Attached scsi CD-ROM sr0
Real Time Clock Driver v1.12b
input: Logitech USB Gaming Mouse as /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/input/input2
generic-usb 0003:046D:C042.0001: input: USB HID v1.11 Mouse [Logitech USB Gaming Mouse] on usb-0000:00:1d.1-1/input0
generic-usb 0003:046D:C042.0002: claimed by neither input, hiddev nor hidraw
applesmc: F0Mn: read arg fail
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: setting latency timer to 64
hda_codec: STAC922x, Apple subsys_id=106b0800
applesmc: key=137 fan=1 temp=7 acc=0 lux=0 kbd=0
applesmc: init_smcreg() took 50 ms
BUG: key f4891a1c not in .data!
------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2701 lockdep_init_map+0xd8/0x442()
Hardware name: Macmini1,1
Modules linked in: snd_hda_codec_idt snd_hda_intel snd_hda_codec applesmc(+) input_polldev snd_pcm rtc snd_timer i2c_i801 sg sr_mod cdrom snd sky2 snd_page_alloc
Pid: 763, comm: modprobe Not tainted 2.6.38-rc2 #2
Call Trace:
 [<c1029b5b>] ? warn_slowpath_common+0x60/0x75
 [<c1029b7f>] ? warn_slowpath_null+0xf/0x13
 [<c104a15a>] ? lockdep_init_map+0xd8/0x442
 [<c10cbea1>] ? sysfs_new_dirent+0x73/0xdb
 [<c10cb829>] ? sysfs_add_file_mode+0x4c/0x88
 [<c10cb873>] ? sysfs_add_file+0xe/0x13
 [<c10cb905>] ? sysfs_create_file+0x20/0x22
 [<f8116eb9>] ? applesmc_create_nodes+0xac/0xf1 [applesmc]
 [<f812b0b2>] ? applesmc_init+0xb2/0x1000 [applesmc]
 [<c100115e>] ? do_one_initcall+0x71/0x113
 [<f812b000>] ? applesmc_init+0x0/0x1000 [applesmc]
 [<c1053d13>] ? sys_init_module+0xb3/0x1e2
 [<c1002910>] ? sysenter_do_call+0x12/0x31
---[ end trace f4dc91d2a456dccb ]---
BUG: key f42962fc not in .data!
BUG: key f4296394 not in .data!
BUG: key f42b7dac not in .data!
BUG: key f42b7d14 not in .data!
BUG: key f42b7c7c not in .data!
BUG: key f42b7be4 not in .data!
BUG: key f42b7b4c not in .data!
BUG: key f42b7ab4 not in .data!
BUG: key f42b7a1c not in .data!
BUG: key f4296f74 not in .data!
BUG: key f4296edc not in .data!
BUG: key f4296e44 not in .data!
BUG: key f4296dac not in .data!
BUG: key f411adfc not in .data!
BUG: key f411ae3c not in .data!
BUG: key f411ae7c not in .data!
BUG: key f411aebc not in .data!
BUG: key f411aefc not in .data!
BUG: key f411af3c not in .data!
usb 4-1: new low speed USB device using uhci_hcd and address 2
BUG: key f411af7c not in .data!
BUG: key f4100dfc not in .data!
BUG: key f4100e3c not in .data!
BUG: key f4100e7c not in .data!
BUG: key f4100ebc not in .data!
BUG: key f4100efc not in .data!
BUG: key f4100f3c not in .data!
BUG: key f4100f7c not in .data!
input: USB keyboard as /devices/pci0000:00/0000:00:1d.2/usb4/4-1/4-1:1.0/input/input3
generic-usb 0003:0DC6:3412.0003: input: USB HID v1.00 Keyboard [USB keyboard] on usb-0000:00:1d.2-1/input0
input: USB keyboard as /devices/pci0000:00/0000:00:1d.2/usb4/4-1/4-1:1.1/input/input4
generic-usb 0003:0DC6:3412.0004: input: USB HID v1.00 Mouse [USB keyboard] on usb-0000:00:1d.2-1/input1
usb 5-1: new full speed USB device using uhci_hcd and address 2
EXT3-fs (sda3): using internal journal
input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.0/input/input5
generic-usb 0003:05AC:1000.0005: input: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1/input0
input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.1/input/input6
generic-usb 0003:05AC:1000.0006: input: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1/input1
ata3.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata3.01: BMDMA stat 0x5
ata3.01: failed command: DATA SET MANAGEMENT
ata3.01: cmd 06/01:01:00:00:00/00:00:00:00:00/b0 tag 0 dma 512 out
         res 51/04:01:00:00:00/04:00:00:00:00/b0 Emask 0x1 (device error)
ata3.01: status: { DRDY ERR }
ata3.01: error: { ABRT }
ata3.01: device reported invalid CHS sector 0
sd 2:0:1:0: [sda]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 2:0:1:0: [sda]  Sense Key : Aborted Command [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
        00 00 00 00 
sd 2:0:1:0: [sda]  Add. Sense: No additional sense information
sd 2:0:1:0: [sda] CDB: Write same(16): 93 08 00 00 00 00 0e 8b c2 90 00 3f ff c0 00 00
end_request: I/O error, dev sda, sector 244040336
Adding 2883580k swap on /dev/sda4.  Priority:-1 extents:1 across:2883580k SS
usb 5-2: new full speed USB device using uhci_hcd and address 3
generic-usb 0003:05AC:8240.0007: claimed by neither input, hiddev nor hidraw
usb 5-1: usbfs: USBDEVFS_CONTROL failed cmd hid2hci rqt 64 rq 0 len 0 ret -84
usb 5-1: USB disconnect, address 2
usb 5-1: new full speed USB device using uhci_hcd and address 4
sky2 0000:01:00.0: eth0: enabling interface
sky2 0000:01:00.0: eth0: Link is up at 100 Mbps, full duplex, flow control both
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.

