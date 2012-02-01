Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab2BAOYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 09:24:34 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50605 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750Ab2BAOYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 09:24:30 -0500
MIME-Version: 1.0
From: Manuel Lauss <manuel.lauss@googlemail.com>
Date: Wed, 1 Feb 2012 15:23:49 +0100
Message-ID: <CAOLZvyE=z=Y5wD-Vyp1ZbWV1-kqW8EmZkrHOcMBPZmBQ67E+Ow@mail.gmail.com>
Subject: [WARN] offlining CPUs yields warning at arch/x86/kernel/smp.c:120
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

When offlining/onlining CPUs the following warning is spat out repeatedly.
System is a 4-core+HT SandyBridge laptop.  Full dmesg below.

CPU 7 is now offline
CPU 6 is now offline
CPU 5 is now offline
------------[ cut here ]------------
WARNING: at /mnt/data/.src/linux.git/arch/x86/kernel/smp.c:120
update_process_times+0x65/0x80()
Hardware name: Precision M6600
Modules linked in:
Pid: 17, comm: migration/2 Not tainted 3.3.0-rc1-00473-g6bc2b95 #1
Call Trace:
 <IRQ>  [<ffffffff8104e5eb>] ? warn_slowpath_common+0x7b/0xc0
 [<ffffffff8108a000>] ? tick_nohz_handler+0xd0/0xd0
 [<ffffffff8105af45>] ? update_process_times+0x65/0x80
 [<ffffffff8108a05b>] ? tick_sched_timer+0x5b/0xb0
 [<ffffffff8106dc0e>] ? __run_hrtimer.isra.33+0x4e/0xe0
 [<ffffffff8106e3e0>] ? hrtimer_interrupt+0xe0/0x210
 [<ffffffff810a09e0>] ? queue_stop_cpus_work+0xf0/0xf0
 [<ffffffff8101c513>] ? smp_apic_timer_interrupt+0x63/0xa0
 [<ffffffff818acbcb>] ? apic_timer_interrupt+0x6b/0x70
 <EOI>  [<ffffffff810a0a6a>] ? stop_machine_cpu_stop+0x8a/0xb0
 [<ffffffff810a06f4>] ? cpu_stopper_thread+0xc4/0x190
 [<ffffffff81073e6e>] ? try_to_wake_up+0x1de/0x290
 [<ffffffff8107153f>] ? __wake_up_common+0x4f/0x80
 [<ffffffff810a0630>] ? cpu_stop_signal_done+0x30/0x30
 [<ffffffff81069ec5>] ? kthread+0x85/0x90
 [<ffffffff818ad294>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81069e40>] ? kthread_freezable_should_stop+0x60/0x60
 [<ffffffff818ad290>] ? gs_change+0xb/0xb
---[ end trace 431db5dbf525be16 ]---
CPU 4 is now offline

[and so on].

Please take a look.

Thanks!
        Manuel Lauss


Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 3.3.0-rc1-00473-g6bc2b95 (mano@dargo) (gcc version 4.6.2
(Gentoo 4.6.2 p1.3) ) #1 SMP PREEMPT Mon Jan 30 21:53:34 CET 2012
Command line: noirqdebug root=/dev/sda4 rootfstype=ext4
snd_hda_intel.enable_msi=1 intel_iommu=off quiet init=/bin/bash
KERNEL supported cpus:
  Intel GenuineIntel
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009a800 (usable)
 BIOS-e820: 000000000009a800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cee28000 (usable)
 BIOS-e820: 00000000cee28000 - 00000000cee6c000 (reserved)
 BIOS-e820: 00000000cee6c000 - 00000000cf1b7000 (usable)
 BIOS-e820: 00000000cf1b7000 - 00000000cf1e7000 (reserved)
 BIOS-e820: 00000000cf1e7000 - 00000000cf3e7000 (ACPI NVS)
 BIOS-e820: 00000000cf3e7000 - 00000000cf3ff000 (ACPI data)
 BIOS-e820: 00000000cf3ff000 - 00000000cf400000 (usable)
 BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
 BIOS-e820: 00000000ffc00000 - 00000000ffc20000 (reserved)
 BIOS-e820: 0000000100000000 - 000000022e000000 (usable)
NX (Execute Disable) protection: active
DMI 2.6 present.
DMI: Dell Inc. Precision M6600/04YY4M, BIOS A06 10/02/2011
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
last_pfn = 0x22e000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask F80000000 write-back
  1 base 080000000 mask FC0000000 write-back
  2 base 0C0000000 mask FF0000000 write-back
  3 base 0CF400000 mask FFFC00000 uncachable
  4 base 100000000 mask F00000000 write-back
  5 base 200000000 mask FE0000000 write-back
  6 base 220000000 mask FF0000000 write-back
  7 base 22E000000 mask FFE000000 uncachable
  8 disabled
  9 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
original variable MTRRs
reg 0, base: 0GB, range: 2GB, type WB
reg 1, base: 2GB, range: 1GB, type WB
reg 2, base: 3GB, range: 256MB, type WB
reg 3, base: 3316MB, range: 4MB, type UC
reg 4, base: 4GB, range: 4GB, type WB
reg 5, base: 8GB, range: 512MB, type WB
reg 6, base: 8704MB, range: 256MB, type WB
reg 7, base: 8928MB, range: 32MB, type UC
total RAM covered: 8156M
Found optimal setting for mtrr clean up
 gran_size: 64K 	chunk_size: 64M 	num_reg: 8  	lose cover RAM: 0G
New variable MTRRs
reg 0, base: 0GB, range: 2GB, type WB
reg 1, base: 2GB, range: 1GB, type WB
reg 2, base: 3GB, range: 256MB, type WB
reg 3, base: 3316MB, range: 4MB, type UC
reg 4, base: 4GB, range: 4GB, type WB
reg 5, base: 8GB, range: 512MB, type WB
reg 6, base: 8704MB, range: 256MB, type WB
reg 7, base: 8928MB, range: 32MB, type UC
e820 update range: 00000000cf400000 - 00000000cf800000 (usable) ==> (reserved)
e820 update range: 00000000d0000000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0xcf400 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
Base memory trampoline at [ffff880000095000] 95000 size 20480
init_memory_mapping: 0000000000000000-00000000cf400000
 0000000000 - 00cf400000 page 2M
kernel direct mapping tables up to cf400000 @ 1fffb000-20000000
init_memory_mapping: 0000000100000000-000000022e000000
 0100000000 - 022e000000 page 2M
kernel direct mapping tables up to 22e000000 @ cf1ad000-cf1b7000
ACPI: RSDP 00000000000fe300 00024 (v02 DELL  )
ACPI: XSDT 00000000cf3fde18 00084 (v01 DELL    CBX3    06222004 MSFT 00010013)
ACPI: FACP 00000000cf377d98 000F4 (v04 DELL    CBX3    06222004 MSFT 00010013)
ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables!
(20120111/tbfadt-382)
ACPI Warning: 32/64X FACS address mismatch in FADT -
0xCF3D4E40/0x00000000CF3D4D40, using 32 (20120111/tbfadt-502)
ACPI: DSDT 00000000cf344018 08A1A (v02 INT430 SYSFexxx 00001001 INTL 20090903)
ACPI: FACS 00000000cf3d4e40 00040
ACPI: APIC 00000000cf3fcf18 000CC (v02 DELL    CBX3    06222004 MSFT 00010013)
ACPI: TCPA 00000000cf3d5d18 00032 (v02                 00000000      00000000)
ACPI: SSDT 00000000cf378a98 002F9 (v01 DELLTP      TPM 00003000 INTL 20090903)
ACPI: MCFG 00000000cf3d5c98 0003C (v01 DELL   SNDYBRDG 06222004 MSFT 00000097)
ACPI: HPET 00000000cf3d5c18 00038 (v01 A M I   PCHHPET 06222004 AMI. 00000003)
ACPI: BOOT 00000000cf3d5b98 00028 (v01 DELL   CBX3     06222004 AMI  00010013)
ACPI: SSDT 00000000cf35b818 007C2 (v01  PmRef  Cpu0Ist 00003000 INTL 20090903)
ACPI: SSDT 00000000cf35a018 00996 (v01  PmRef    CpuPm 00003000 INTL 20090903)
ACPI: DMAR 00000000cf3d4a18 000B0 (v01 INTEL      SNB  00000001 INTL 00000001)
ACPI: SLIC 00000000cf364c18 00176 (v03 DELL    CBX3    06222004 MSFT 00010013)
ACPI: SSDT 00000000cf362018 018C3 (v01 NvdRef  NvdTabl 00001000 INTL 20090903)
ACPI: Local APIC address 0xfee00000
 [ffffea0000000000-ffffea0008bfffff] PMD ->
[ffff880225600000-ffff88022d5fffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x0022e000
Movable zone start PFN for each node
Early memory PFN ranges
    0: 0x00000010 -> 0x0000009a
    0: 0x00000100 -> 0x000cee28
    0: 0x000cee6c -> 0x000cf1b7
    0: 0x000cf3ff -> 0x000cf400
    0: 0x00100000 -> 0x0022e000
On node 0 totalpages: 2085118
  DMA zone: 64 pages used for memmap
  DMA zone: 5 pages reserved
  DMA zone: 3909 pages, LIFO batch:0
  DMA32 zone: 16320 pages used for memmap
  DMA32 zone: 827828 pages, LIFO batch:31
  Normal zone: 19328 pages used for memmap
  Normal zone: 1217664 pages, LIFO batch:31
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x08] disabled)
ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x09] disabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0a] disabled)
ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0b] disabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0c] disabled)
ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0d] disabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0e] disabled)
ACPI: LAPIC (acpi_id[0x10] lapic_id[0x0f] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a701 base: 0xfed00000
16 Processors exceeds NR_CPUS limit of 8
SMP: Allowing 8 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
Allocating PCI resources starting at cf400000 (gap: cf400000:2f91c000)
setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
PERCPU: Embedded 25 pages/cpu @ffff88022dc00000 s72448 r8192 d21760 u262144
pcpu-alloc: s72448 r8192 d21760 u262144 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3 4 5 6 7
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2049401
Kernel command line: noirqdebug root=/dev/sda4 rootfstype=ext4
snd_hda_intel.enable_msi=1 intel_iommu=off quiet init=/bin/bash
IRQ lockup detection disabled
Intel-IOMMU: disabled
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
Memory: 8114100k/9142272k available (8895k kernel code, 801800k
absent, 226372k reserved, 5954k data, 484k init)
SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
Preemptible hierarchical RCU implementation.
	CONFIG_RCU_FANOUT set to non-default value of 2
	RCU dyntick-idle grace-period acceleration is enabled.
NR_IRQS:4352 nr_irqs:744 16
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
allocated 33554432 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2294.838 MHz processor.
Calibrating delay loop (skipped), value calculated using timer
frequency.. 4589.67 BogoMIPS (lpj=2294838)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 256
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
Initializing cgroup subsys perf_event
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
mce: CPU supports 9 MCE banks
CPU0: Thermal monitoring enabled (TM1)
using mwait in idle threads.
ACPI: Core revision 20120111
DMAR: Host address width 36
DMAR: DRHD base: 0x000000fed91000 flags: 0x1
IOMMU 0: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
DMAR: RMRR base: 0x000000cf1c6000 end: 0x000000cf1d5fff
IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 0
HPET id 0 under DRHD base 0xfed91000
HPET id 0 under DRHD base 0xfed91000
HPET id 0 under DRHD base 0xfed91000
HPET id 0 under DRHD base 0xfed91000
HPET id 0 under DRHD base 0xfed91000
HPET id 0 under DRHD base 0xfed91000
HPET id 0 under DRHD base 0xfed91000
HPET id 0 under DRHD base 0xfed91000
Enabled IRQ remapping in x2apic mode
Enabling x2apic
Enabled x2apic
Switched APIC routing to cluster x2apic.
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM) i7-2820QM CPU @ 2.30GHz stepping 07
Performance Events: PEBS fmt1+, SandyBridge events, Intel PMU driver.
PEBS disabled due to CPU errata.
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
Booting Node   0, Processors  #1
smpboot cpu 1: start_ip = 95000
 #2
smpboot cpu 2: start_ip = 95000
 #3
smpboot cpu 3: start_ip = 95000
 #4
smpboot cpu 4: start_ip = 95000
 #5
smpboot cpu 5: start_ip = 95000
 #6
smpboot cpu 6: start_ip = 95000
 #7 Ok.
smpboot cpu 7: start_ip = 95000
Brought up 8 CPUs
Total of 8 processors activated (36717.40 BogoMIPS).
PM: Registering ACPI NVS region at cf1e7000 (2097152 bytes)
xor: automatically using best checksumming function: generic_sse
   generic_sse: 10200.000 MB/sec
xor: using function: generic_sse (10200.000 MB/sec)
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
dca service started, version 1.12.1
PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem
0xf8000000-0xfbffffff] (base 0xf8000000)
PCI: not using MMCONFIG
PCI: Using configuration type 1 for base access
dmi type 0xB1 record - unknown flag
bio: create slab <bio-0> at 0
raid6: int64x1   2234 MB/s
raid6: int64x2   2687 MB/s
raid6: int64x4   2351 MB/s
raid6: int64x8   1945 MB/s
raid6: sse2x1    6187 MB/s
raid6: sse2x2    7660 MB/s
raid6: sse2x4    8683 MB/s
raid6: using algorithm sse2x4 (8683 MB/s)
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: EC: Look up EC in DSDT
[Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
ACPI: SSDT 00000000cf1d7798 00727 (v01  PmRef  Cpu0Cst 00003001 INTL 20090903)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00727 (v01  PmRef  Cpu0Cst 00003001 INTL 20090903)
ACPI: SSDT 00000000cf1d8a98 00303 (v01  PmRef    ApIst 00003000 INTL 20090903)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20090903)
ACPI: SSDT 00000000cf1d6d98 00119 (v01  PmRef    ApCst 00003000 INTL 20090903)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20090903)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem
0xf8000000-0xfbffffff] (base 0xf8000000)
ACPI Error: Invalid/unsupported resource descriptor: Type 0x00
(20120111/utresrc-650)
PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in ACPI
motherboard resources
ACPI: EC: GPE = 0x10, I/O: command/status = 0x934, data = 0x930
ACPI: No dock devices found.
PCI: Using host bridge windows from ACPI; if necessary, use
"pci=nocrs" and report a bug
\_SB_.PCI0:_OSC invalid UUID
_OSC request data:1 8 1f
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0xd0000000-0xfeafffff]
pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff]
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: root bus resource [mem 0xd0000000-0xfeafffff]
pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
pci 0000:00:00.0: [8086:0104] type 0 class 0x000600
pci 0000:00:01.0: [8086:0101] type 1 class 0x000604
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:16.0: [8086:1c3a] type 0 class 0x000780
pci 0000:00:16.0: reg 10: [mem 0xe1eb0000-0xe1eb000f 64bit]
pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
pci 0000:00:16.3: [8086:1c3d] type 0 class 0x000700
pci 0000:00:16.3: reg 10: [io  0x80a0-0x80a7]
pci 0000:00:16.3: reg 14: [mem 0xe1e90000-0xe1e90fff]
pci 0000:00:19.0: [8086:1502] type 0 class 0x000200
pci 0000:00:19.0: reg 10: [mem 0xe1e00000-0xe1e1ffff]
pci 0000:00:19.0: reg 14: [mem 0xe1e80000-0xe1e80fff]
pci 0000:00:19.0: reg 18: [io  0x8040-0x805f]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.0: [8086:1c2d] type 0 class 0x000c03
pci 0000:00:1a.0: reg 10: [mem 0xe1e70000-0xe1e703ff]
pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: [8086:1c20] type 0 class 0x000403
pci 0000:00:1b.0: reg 10: [mem 0xe1e60000-0xe1e63fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: [8086:1c10] type 1 class 0x000604
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: [8086:1c12] type 1 class 0x000604
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: [8086:1c14] type 1 class 0x000604
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: [8086:1c16] type 1 class 0x000604
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.7: [8086:1c1e] type 1 class 0x000604
pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.0: [8086:1c26] type 0 class 0x000c03
pci 0000:00:1d.0: reg 10: [mem 0xe1e50000-0xe1e503ff]
pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1f.0: [8086:1c4f] type 0 class 0x000601
pci 0000:00:1f.2: [8086:1c03] type 0 class 0x000106
pci 0000:00:1f.2: reg 10: [io  0x8090-0x8097]
pci 0000:00:1f.2: reg 14: [io  0x8080-0x8083]
pci 0000:00:1f.2: reg 18: [io  0x8070-0x8077]
pci 0000:00:1f.2: reg 1c: [io  0x8060-0x8063]
pci 0000:00:1f.2: reg 20: [io  0x8020-0x803f]
pci 0000:00:1f.2: reg 24: [mem 0xe1e40000-0xe1e407ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.3: [8086:1c22] type 0 class 0x000c05
pci 0000:00:1f.3: reg 10: [mem 0xe1e30000-0xe1e300ff 64bit]
pci 0000:00:1f.3: reg 20: [io  0x8000-0x801f]
pci 0000:01:00.0: [10de:0e3b] type 0 class 0x000300
pci 0000:01:00.0: reg 10: [mem 0xde000000-0xdfffffff]
pci 0000:01:00.0: reg 14: [mem 0xd0000000-0xd7ffffff 64bit pref]
pci 0000:01:00.0: reg 1c: [mem 0xd8000000-0xdbffffff 64bit pref]
pci 0000:01:00.0: reg 24: [io  0x7000-0x707f]
pci 0000:01:00.0: reg 30: [mem 0xe0000000-0xe007ffff pref]
pci 0000:01:00.1: [10de:0beb] type 0 class 0x000403
pci 0000:01:00.1: reg 10: [mem 0xe0080000-0xe0083fff]
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0x7000-0x7fff]
pci 0000:00:01.0:   bridge window [mem 0xde000000-0xe00fffff]
pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdbffffff 64bit pref]
pci 0000:00:1c.0: PCI bridge to [bus 02-02]
pci 0000:03:00.0: [8086:422b] type 0 class 0x000280
pci 0000:03:00.0: reg 10: [mem 0xe1d00000-0xe1d01fff 64bit]
pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PCI bridge to [bus 03-03]
pci 0000:00:1c.1:   bridge window [mem 0xe1d00000-0xe1dfffff]
pci 0000:00:1c.2: PCI bridge to [bus 04-09]
pci 0000:00:1c.2:   bridge window [io  0x6000-0x6fff]
pci 0000:00:1c.2:   bridge window [mem 0xe1200000-0xe1bfffff]
pci 0000:00:1c.2:   bridge window [mem 0xdd200000-0xddbfffff 64bit pref]
pci 0000:0a:00.0: [1033:0194] type 0 class 0x000c03
pci 0000:0a:00.0: reg 10: [mem 0xe1c00000-0xe1c01fff 64bit]
pci 0000:0a:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PCI bridge to [bus 0a-0a]
pci 0000:00:1c.3:   bridge window [mem 0xe1c00000-0xe1cfffff]
pci 0000:0b:00.0: [1217:11f7] type 0 class 0x000c00
pci 0000:0b:00.0: reg 10: [mem 0xe0130000-0xe0130fff]
pci 0000:0b:00.0: supports D1 D2
pci 0000:0b:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:0b:00.1: [1217:8320] type 0 class 0x000805
pci 0000:0b:00.1: reg 10: [mem 0xe0120000-0xe01201ff]
pci 0000:0b:00.1: supports D1 D2
pci 0000:0b:00.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:0b:00.2: [1217:8330] type 0 class 0x000180
pci 0000:0b:00.2: reg 10: [mem 0xe0110000-0xe01103ff]
pci 0000:0b:00.2: reg 18: [mem 0xe0100000-0xe01003ff]
pci 0000:0b:00.2: supports D1 D2
pci 0000:0b:00.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:1c.7: PCI bridge to [bus 0b-12]
pci 0000:00:1c.7:   bridge window [io  0x2000-0x5fff]
pci 0000:00:1c.7:   bridge window [mem 0xe0100000-0xe11fffff]
pci 0000:00:1c.7:   bridge window [mem 0xdc100000-0xdd1fffff 64bit pref]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP08._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG0._PRT]
\_SB_.PCI0:_OSC invalid UUID
_OSC request data:1 1f 1f
 pci0000:00: Requesting ACPI _OSC control (0x1d)
\_SB_.PCI0:_OSC invalid UUID
_OSC request data:1 0 1d
 pci0000:00: ACPI _OSC request failed (AE_ERROR), returned control mask: 0x1d
ACPI _OSC control for PCIe not granted, disabling ASPM
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 *5 6 7 10 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 *3 4 5 6 7 10 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:01:00.0
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
wmi: Mapper loaded
Advanced Linux Sound Architecture Driver Version 1.0.24.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009a800 - 000000000009ffff
reserve RAM buffer: 00000000cee28000 - 00000000cfffffff
reserve RAM buffer: 00000000cf1b7000 - 00000000cfffffff
reserve RAM buffer: 00000000cf400000 - 00000000cfffffff
reserve RAM buffer: 000000022e000000 - 000000022fffffff
Bluetooth: Core ver 2.16
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO socket layer initialized
cfg80211: Calling CRDA to update world regulatory domain
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
hpet0: 8 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource hpet
FS-Cache: Loaded
CacheFiles: Loaded
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [bus 00-3e]
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
pnp 00:00: [mem 0xd0000000-0xfeafffff window]
pnp 00:00: [mem 0xfed40000-0xfed44fff window]
pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:01: [io  0x0000-0x001f]
pnp 00:01: [io  0x0081-0x0091]
pnp 00:01: [io  0x0093-0x009f]
pnp 00:01: [io  0x00c0-0x00df]
pnp 00:01: [dma 4]
pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:02: [mem 0xff000000-0xffffffff]
pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
pnp 00:03: [mem 0xfed00000-0xfed003ff]
system 00:03: [mem 0xfed00000-0xfed003ff] has been reserved
system 00:03: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
pnp 00:04: [io  0x00f0]
pnp 00:04: [irq 13]
pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:05: [io  0x002e-0x002f]
pnp 00:05: [io  0x004e-0x004f]
pnp 00:05: [io  0x0061]
pnp 00:05: [io  0x0063]
pnp 00:05: [io  0x0065]
pnp 00:05: [io  0x0067]
pnp 00:05: [io  0x0070]
pnp 00:05: [io  0x0080]
pnp 00:05: [io  0x0092]
pnp 00:05: [io  0x00b2-0x00b3]
pnp 00:05: [io  0x0680-0x069f]
pnp 00:05: [io  0x1000-0x100f]
pnp 00:05: [io  0xffff]
pnp 00:05: [io  0xffff]
pnp 00:05: [io  0x0400-0x047f]
pnp 00:05: [io  0x0500-0x057f]
pnp 00:05: [io  0x164e-0x164f]
system 00:05: [io  0x0680-0x069f] has been reserved
system 00:05: [io  0x1000-0x100f] has been reserved
system 00:05: [io  0xffff] has been reserved
system 00:05: [io  0xffff] has been reserved
system 00:05: [io  0x0400-0x047f] has been reserved
system 00:05: [io  0x0500-0x057f] has been reserved
system 00:05: [io  0x164e-0x164f] has been reserved
system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:06: [io  0x0070-0x0077]
pnp 00:06: [irq 8]
pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:07: [io  0x0060]
pnp 00:07: [io  0x0064]
pnp 00:07: [irq 1]
pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:08: Plug and Play ACPI device, IDs PNP0401 (disabled)
pnp 00:09: [irq 12]
pnp 00:09: Plug and Play ACPI device, IDs DLL04a4 PNP0f13 (active)
pnp 00:0a: [mem 0xfed40000-0xfed44fff]
pnp 00:0a: Plug and Play ACPI device, IDs BCM0102 PNP0c31 (active)
pnp 00:0b: [mem 0xfed1c000-0xfed1ffff]
pnp 00:0b: [mem 0xfed10000-0xfed17fff]
pnp 00:0b: [mem 0xfed18000-0xfed18fff]
pnp 00:0b: [mem 0xfed19000-0xfed19fff]
pnp 00:0b: [mem 0xf8000000-0xfbffffff]
pnp 00:0b: [mem 0xfed20000-0xfed3ffff]
pnp 00:0b: [mem 0xfed90000-0xfed93fff]
pnp 00:0b: [mem 0xfed45000-0xfed8ffff]
pnp 00:0b: [mem 0xff000000-0xffffffff]
pnp 00:0b: [mem 0xfee00000-0xfeefffff]
pnp 00:0b: [mem 0x00000000-0xffffffffffffffff disabled]
pnp 00:0b: [mem 0x00000000-0xffffffffffffffff disabled]
system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:0b: [mem 0xfed10000-0xfed17fff] has been reserved
system 00:0b: [mem 0xfed18000-0xfed18fff] has been reserved
system 00:0b: [mem 0xfed19000-0xfed19fff] has been reserved
system 00:0b: [mem 0xf8000000-0xfbffffff] has been reserved
system 00:0b: [mem 0xfed20000-0xfed3ffff] has been reserved
system 00:0b: [mem 0xfed90000-0xfed93fff] has been reserved
system 00:0b: [mem 0xfed45000-0xfed8ffff] has been reserved
system 00:0b: [mem 0xff000000-0xffffffff] could not be reserved
system 00:0b: [mem 0xfee00000-0xfeefffff] has been reserved
system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0c: [irq 23]
pnp 00:0c: Plug and Play ACPI device, IDs SMO8800 (active)
ACPI Error: Invalid/unsupported resource descriptor: Type 0x00
(20120111/utresrc-650)
pnp 00:0d: can't evaluate _CRS: 12311
system 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
PCI: max bus depth: 1 pci_try_num: 2
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0x7000-0x7fff]
pci 0000:00:01.0:   bridge window [mem 0xde000000-0xe00fffff]
pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdbffffff 64bit pref]
pci 0000:00:1c.0: PCI bridge to [bus 02-02]
pci 0000:00:1c.1: PCI bridge to [bus 03-03]
pci 0000:00:1c.1:   bridge window [mem 0xe1d00000-0xe1dfffff]
pci 0000:00:1c.2: PCI bridge to [bus 04-09]
pci 0000:00:1c.2:   bridge window [io  0x6000-0x6fff]
pci 0000:00:1c.2:   bridge window [mem 0xe1200000-0xe1bfffff]
pci 0000:00:1c.2:   bridge window [mem 0xdd200000-0xddbfffff 64bit pref]
pci 0000:00:1c.3: PCI bridge to [bus 0a-0a]
pci 0000:00:1c.3:   bridge window [mem 0xe1c00000-0xe1cfffff]
pci 0000:00:1c.7: PCI bridge to [bus 0b-12]
pci 0000:00:1c.7:   bridge window [io  0x2000-0x5fff]
pci 0000:00:1c.7:   bridge window [mem 0xe0100000-0xe11fffff]
pci 0000:00:1c.7:   bridge window [mem 0xdc100000-0xdd1fffff 64bit pref]
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0xd0000000-0xfeafffff]
pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
pci_bus 0000:01: resource 0 [io  0x7000-0x7fff]
pci_bus 0000:01: resource 1 [mem 0xde000000-0xe00fffff]
pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdbffffff 64bit pref]
pci_bus 0000:03: resource 1 [mem 0xe1d00000-0xe1dfffff]
pci_bus 0000:04: resource 0 [io  0x6000-0x6fff]
pci_bus 0000:04: resource 1 [mem 0xe1200000-0xe1bfffff]
pci_bus 0000:04: resource 2 [mem 0xdd200000-0xddbfffff 64bit pref]
pci_bus 0000:0a: resource 1 [mem 0xe1c00000-0xe1cfffff]
pci_bus 0000:0b: resource 0 [io  0x2000-0x5fff]
pci_bus 0000:0b: resource 1 [mem 0xe0100000-0xe11fffff]
pci_bus 0000:0b: resource 2 [mem 0xdc100000-0xdd1fffff 64bit pref]
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
UDP hash table entries: 4096 (order: 5, 131072 bytes)
UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
NET: Registered protocol family 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
pci 0000:01:00.0: Boot video device
PCI: CLS 64 bytes, default 64
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff8800cae28000 - ffff8800cee28000
software IO TLB at phys 0xcae28000 - 0xcee28000
Simple Boot Flag at 0xf3 set to 0x1
Machine check injector initialized
microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x1b
microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x1b
microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x1b
microcode: CPU3 sig=0x206a7, pf=0x10, revision=0x1b
microcode: CPU4 sig=0x206a7, pf=0x10, revision=0x1b
microcode: CPU5 sig=0x206a7, pf=0x10, revision=0x1b
microcode: CPU6 sig=0x206a7, pf=0x10, revision=0x1b
microcode: CPU7 sig=0x206a7, pf=0x10, revision=0x1b
microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
sha1_ssse3: Using AVX optimized SHA-1 implementation
audit: initializing netlink socket (disabled)
type=2000 audit(1328109251.424:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
Registering the id_resolver key type
FS-Cache: Netfs 'nfs' registered for caching
nfs4filelayout_init: NFSv4 File Layout Driver Registering...
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
FS-Cache: Netfs 'cifs' registered for caching
NTFS driver 2.1.30 [Flags: R/W DEBUG].
fuse init (API version 7.18)
SGI XFS with ACLs, security attributes, large block/inode numbers, no
debug enabled
NILFS version 2 loaded
Btrfs loaded
msgmni has been set to 15847
NET: Registered protocol family 38
async_tx: api initialized (async)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:01.0: irq 41 for MSI/MSI-X
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
intel_idle: MWAIT substates: 0x21120
intel_idle: v0.4 model 0x2A
intel_idle: lapic_timer_reliable_states 0xffffffff
ACPI: AC Adapter [AC] (on-line)
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
ACPI: Lid Switch [LID]
input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
ACPI: Power Button [PBTN]
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
ACPI: Sleep Button [SBTN]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
ACPI: Power Button [PWRF]
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [THM] (25 C)
ioatdma: Intel(R) QuickData Technology Driver 4.00
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
tpm_tis 00:0a: 1.2 TPM (device-id 0x2001, rev-id 32)
ACPI: Battery Slot [BAT0] (battery present)
Refined TSC clocksource calibration: 2294.786 MHz.
Switching to clocksource tsc
loop: module loaded
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: irq 42 for MSI/MSI-X
ahci: SSS flag set, parallel bus scan disabled
ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3b impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part
ems sxs apst
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m2048@0xe1e40000 port 0xe1e40100 irq 42
ata2: SATA max UDMA/133 abar m2048@0xe1e40000 port 0xe1e40180 irq 42
ata3: DUMMY
ata4: SATA max UDMA/133 abar m2048@0xe1e40000 port 0xe1e40280 irq 42
ata5: SATA max UDMA/133 abar m2048@0xe1e40000 port 0xe1e40300 irq 42
ata6: SATA max UDMA/133 abar m2048@0xe1e40000 port 0xe1e40380 irq 42
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) d0:67:e5:38:10:d2
e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
e1000e 0000:00:19.0: eth0: MAC: 10, PHY: 11, PBA No: 1041FF-0FF
PPP generic driver version 2.4.2
PPP BSD Compression module registered
PPP Deflate Compression module registered
PPP MPPE Compression module registered
NET: Registered protocol family 24
PPTP driver version 0.8.5
firewire_ohci: Added fw-ohci device 0000:0b:00.0, OHCI v1.10, 8 IR + 8
IT contexts, quirks 0x10
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.0: setting latency timer to 64
ehci_hcd 0000:00:1a.0: EHCI Host Controller
ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.0: debug port 2
ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
ehci_hcd 0000:00:1a.0: irq 16, io mem 0xe1e70000
ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
ehci_hcd 0000:00:1d.0: setting latency timer to 64
ehci_hcd 0000:00:1d.0: EHCI Host Controller
ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.0: debug port 2
ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.0: irq 17, io mem 0xe1e50000
ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
xhci_hcd 0000:0a:00.0: xHCI Host Controller
xhci_hcd 0000:0a:00.0: new USB bus registered, assigned bus number 3
xhci_hcd 0000:0a:00.0: irq 19, io mem 0xe1c00000
xhci_hcd 0000:0a:00.0: irq 44 for MSI/MSI-X
xhci_hcd 0000:0a:00.0: irq 45 for MSI/MSI-X
xhci_hcd 0000:0a:00.0: irq 46 for MSI/MSI-X
xhci_hcd 0000:0a:00.0: irq 47 for MSI/MSI-X
xhci_hcd 0000:0a:00.0: irq 48 for MSI/MSI-X
xhci_hcd 0000:0a:00.0: irq 49 for MSI/MSI-X
xhci_hcd 0000:0a:00.0: irq 50 for MSI/MSI-X
xhci_hcd 0000:0a:00.0: irq 51 for MSI/MSI-X
xHCI xhci_add_endpoint called for root hub
xHCI xhci_check_bandwidth called for root hub
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
xhci_hcd 0000:0a:00.0: xHCI Host Controller
xhci_hcd 0000:0a:00.0: new USB bus registered, assigned bus number 4
xHCI xhci_add_endpoint called for root hub
xHCI xhci_check_bandwidth called for root hub
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usbcore: registered new interface driver cdc_acm
cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
usbcore: registered new interface driver cdc_wdm
i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
i8042: Warning: Keylock active
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
rtc_cmos 00:06: RTC can wake from S4
rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
i2c /dev entries driver
ACPI Warning: 0x0000000000008000-0x000000000000801f SystemIO conflicts
with Region \_SB_.PCI0.SBUS.SMBI 1 (20120111/utaddress-251)
ACPI: If an ACPI driver is available for this device, you should use
it instead of the native driver
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: multipath personality registered for level -4
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.3.0 loaded
device-mapper: multipath round-robin: version 1.0.0 loaded
device-mapper: multipath queue-length: version 0.1.0 loaded
device-mapper: multipath service-time: version 0.2.0 loaded
device-mapper: dm-log-userspace: version 1.1.0 loaded
usbcore: registered new interface driver bcm203x
usbcore: registered new interface driver btusb
usbcore: registered new interface driver ath3k
cpuidle: using governor ladder
cpuidle: using governor menu
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci-pci 0000:0b:00.1: SDHCI controller found [1217:8320] (rev 5)
sdhci-pci 0000:0b:00.1: Invalid iomem size. You may experience problems.
input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input4
Registered led device: mmc0::
mmc0: SDHCI controller on PCI [0000:0b:00.1] using DMA
EFI Variables Facility v0.08 2004-May-17
dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
input: Dell WMI hotkeys as /devices/virtual/input/input5
snd_hda_intel 0000:00:1b.0: irq 52 for MSI/MSI-X
input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input6
input: HDA Intel PCH Dock Mic as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input7
input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
input: HDA Intel PCH Headphone as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input9
input: HDA Intel PCH Dock Line-Out as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input10
snd_hda_intel 0000:01:00.1: irq 53 for MSI/MSI-X
ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device
(Stat=0x51 Err=0x04)
ata1.00: ATA-8: LITEONIT LAT-256M2S, PND9, max UDMA/133
ata1.00: 500118192 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device
(Stat=0x51 Err=0x04)
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      LITEONIT LAT-256 PND9 PQ: 0 ANSI: 5
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
usb 1-1: new high-speed USB device number 2 using ehci_hcd
HDMI status: Codec=0 Pin=5 Presence_Detect=0 ELD_Valid=0
HDMI status: Codec=1 Pin=5 Presence_Detect=0 ELD_Valid=0
HDMI status: Codec=2 Pin=5 Presence_Detect=0 ELD_Valid=0
HDMI status: Codec=3 Pin=5 Presence_Detect=0 ELD_Valid=0
input: HDA NVidia HDMI/DP,pcm=9 as
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input11
input: HDA NVidia HDMI/DP,pcm=8 as
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input12
input: HDA NVidia HDMI/DP,pcm=7 as
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input13
input: HDA NVidia HDMI/DP,pcm=3 as
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input14
ALSA device list:
  #0: HDA Intel PCH at 0xe1e60000 irq 52
  #1: HDA NVidia at 0xe0080000 irq 53
NET: Registered protocol family 26
GACT probability on
Mirror/redirect action on
Simple TC action Loaded
netem: version 1.3
u32 classifier
    Performance counters on
    input device check on
    Actions configured
Netfilter messages via NETLINK v0.30.
nfnl_acct: registering with nfnetlink.
IPv4 over IPv4 tunneling driver
GRE over IPv4 demultiplexor driver
GRE over IPv4 tunneling driver
TCP vegas registered
TCP veno registered
TCP yeah registered
Initializing XFRM netlink socket
NET: Registered protocol family 10
Mobile IPv6
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
NET: Registered protocol family 15
Bridge firewalling registered
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
NET: Registered protocol family 33
RxRPC: Registered security type 2 'rxkad'
L2TP core driver, V2.0
PPPoL2TP kernel driver, V2.0
L2TP IP encapsulation support (L2TPv3)
L2TP netlink interface
L2TP ethernet pseudowire support (L2TPv3)
8021q: 802.1Q VLAN Support v1.8
lib80211: common routines for IEEE802.11 drivers
lib80211_crypt: registered algorithm 'NULL'
Registering the dns_resolver key type
registered taskstats version 1
rtc_cmos 00:06: setting system clock to 2012-02-01 15:14:14 UTC (1328109254)
BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
hub 1-1:1.0: USB hub found
hub 1-1:1.0: 6 ports detected
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ATA-8: WDC WD5000BPKT-75PK4T0, 01.01A01, max UDMA/133
ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata2.00: configured for UDMA/133
firewire_net: firewire0: IPv4 over FireWire on device 04ee4ac1484fc000
firewire_core: created device fw0: GUID 04ee4ac1484fc000, S400
scsi 1:0:0:0: Direct-Access     ATA      WDC WD5000BPKT-7 01.0 PQ: 0 ANSI: 5
sd 1:0:0:0: Attached scsi generic sg1 type 0
sd 1:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 1:0:0:0: [sdb] 4096-byte physical blocks
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
usb 2-1: new high-speed USB device number 2 using ehci_hcd
 sdb: sdb1 sdb2 sdb3
sd 1:0:0:0: [sdb] Attached SCSI disk
hub 2-1:1.0: USB hub found
hub 2-1:1.0: 8 ports detected
usb 1-1.4: new full-speed USB device number 3 using ehci_hcd
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: ATAPI: MATSHITA BD-RE UJ242, 1.11, max UDMA/100
ata4.00: configured for UDMA/100
scsi 3:0:0:0: CD-ROM            MATSHITA BD-RE UJ242      1.11 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 62x/62x writer dvd-ram cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 3:0:0:0: Attached scsi CD-ROM sr0
sr 3:0:0:0: Attached scsi generic sg2 type 5
usb 1-1.5: new high-speed USB device number 4 using ehci_hcd
usb 2-1.6: new high-speed USB device number 3 using ehci_hcd
ata5: SATA link down (SStatus 0 SControl 300)
input: DualPoint Stick as /devices/platform/i8042/serio1/input/input15
input: AlpsPS/2 ALPS DualPoint TouchPad as
/devices/platform/i8042/serio1/input/input16
cdc_acm 2-1.6:1.1: ttyACM0: USB ACM device
cdc_acm 2-1.6:1.3: ttyACM1: USB ACM device
cdc_wdm 2-1.6:1.5: cdc-wdm-176: USB WDM device
cdc_wdm 2-1.6:1.8: cdc-wdm-175: USB WDM device
cdc_acm 2-1.6:1.9: ttyACM2: USB ACM device
usb 2-1.8: new full-speed USB device number 4 using ehci_hcd
usb 2-1.8: config 0 descriptor??
ata6: SATA link down (SStatus 0 SControl 300)
md: Skipping autodetection of RAID arrays. (raid=autodetect will force)
EXT4-fs (sda4): mounted filesystem with ordered data mode. Opts: (null)
VFS: Mounted root (ext4 filesystem) readonly on device 8:4.
Freeing unused kernel memory: 484k freed
Write protecting the kernel read-only data: 14336k
Freeing unused kernel memory: 1324k freed
Freeing unused kernel memory: 1056k freed
EXT4-fs (sda4): re-mounted. Opts: discard
CPU 7 is now offline
CPU 6 is now offline
CPU 5 is now offline
------------[ cut here ]------------
WARNING: at /mnt/data/.src/linux.git/arch/x86/kernel/smp.c:120
update_process_times+0x65/0x80()
Hardware name: Precision M6600
Modules linked in:
Pid: 17, comm: migration/2 Not tainted 3.3.0-rc1-00473-g6bc2b95 #1
Call Trace:
 <IRQ>  [<ffffffff8104e5eb>] ? warn_slowpath_common+0x7b/0xc0
 [<ffffffff8108a000>] ? tick_nohz_handler+0xd0/0xd0
 [<ffffffff8105af45>] ? update_process_times+0x65/0x80
 [<ffffffff8108a05b>] ? tick_sched_timer+0x5b/0xb0
 [<ffffffff8106dc0e>] ? __run_hrtimer.isra.33+0x4e/0xe0
 [<ffffffff8106e3e0>] ? hrtimer_interrupt+0xe0/0x210
 [<ffffffff810a09e0>] ? queue_stop_cpus_work+0xf0/0xf0
 [<ffffffff8101c513>] ? smp_apic_timer_interrupt+0x63/0xa0
 [<ffffffff818acbcb>] ? apic_timer_interrupt+0x6b/0x70
 <EOI>  [<ffffffff810a0a6a>] ? stop_machine_cpu_stop+0x8a/0xb0
 [<ffffffff810a06f4>] ? cpu_stopper_thread+0xc4/0x190
 [<ffffffff81073e6e>] ? try_to_wake_up+0x1de/0x290
 [<ffffffff8107153f>] ? __wake_up_common+0x4f/0x80
 [<ffffffff810a0630>] ? cpu_stop_signal_done+0x30/0x30
 [<ffffffff81069ec5>] ? kthread+0x85/0x90
 [<ffffffff818ad294>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81069e40>] ? kthread_freezable_should_stop+0x60/0x60
 [<ffffffff818ad290>] ? gs_change+0xb/0xb
---[ end trace 431db5dbf525be16 ]---
CPU 4 is now offline
------------[ cut here ]------------
WARNING: at /mnt/data/.src/linux.git/arch/x86/kernel/smp.c:120
update_process_times+0x65/0x80()
Hardware name: Precision M6600
Modules linked in:
Pid: 6, comm: migration/0 Tainted: G        W    3.3.0-rc1-00473-g6bc2b95 #1
Call Trace:
 <IRQ>  [<ffffffff8104e5eb>] ? warn_slowpath_common+0x7b/0xc0
 [<ffffffff8108a000>] ? tick_nohz_handler+0xd0/0xd0
 [<ffffffff8105af45>] ? update_process_times+0x65/0x80
 [<ffffffff8108a05b>] ? tick_sched_timer+0x5b/0xb0
 [<ffffffff8106dc0e>] ? __run_hrtimer.isra.33+0x4e/0xe0
 [<ffffffff8106e3e0>] ? hrtimer_interrupt+0xe0/0x210
 [<ffffffff810a09e0>] ? queue_stop_cpus_work+0xf0/0xf0
 [<ffffffff8101c513>] ? smp_apic_timer_interrupt+0x63/0xa0
 [<ffffffff818acbcb>] ? apic_timer_interrupt+0x6b/0x70
 <EOI>  [<ffffffff810a0a6a>] ? stop_machine_cpu_stop+0x8a/0xb0
 [<ffffffff810a06f4>] ? cpu_stopper_thread+0xc4/0x190
 [<ffffffff81073e6e>] ? try_to_wake_up+0x1de/0x290
 [<ffffffff8107153f>] ? __wake_up_common+0x4f/0x80
 [<ffffffff810a0630>] ? cpu_stop_signal_done+0x30/0x30
 [<ffffffff81069ec5>] ? kthread+0x85/0x90
 [<ffffffff818ad294>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81069e40>] ? kthread_freezable_should_stop+0x60/0x60
 [<ffffffff818ad290>] ? gs_change+0xb/0xb
---[ end trace 431db5dbf525be17 ]---
CPU 3 is now offline
------------[ cut here ]------------
WARNING: at /mnt/data/.src/linux.git/arch/x86/kernel/smp.c:120
update_process_times+0x65/0x80()
Hardware name: Precision M6600
Modules linked in:
Pid: 6, comm: migration/0 Tainted: G        W    3.3.0-rc1-00473-g6bc2b95 #1
Call Trace:
 <IRQ>  [<ffffffff8104e5eb>] ? warn_slowpath_common+0x7b/0xc0
 [<ffffffff8108a000>] ? tick_nohz_handler+0xd0/0xd0
 [<ffffffff8105af45>] ? update_process_times+0x65/0x80
 [<ffffffff8108a05b>] ? tick_sched_timer+0x5b/0xb0
 [<ffffffff8106dc0e>] ? __run_hrtimer.isra.33+0x4e/0xe0
 [<ffffffff8106e3e0>] ? hrtimer_interrupt+0xe0/0x210
 [<ffffffff810a09e0>] ? queue_stop_cpus_work+0xf0/0xf0
 [<ffffffff8101c513>] ? smp_apic_timer_interrupt+0x63/0xa0
 [<ffffffff818acbcb>] ? apic_timer_interrupt+0x6b/0x70
 <EOI>  [<ffffffff810a0a6a>] ? stop_machine_cpu_stop+0x8a/0xb0
 [<ffffffff810a06f4>] ? cpu_stopper_thread+0xc4/0x190
 [<ffffffff81073e6e>] ? try_to_wake_up+0x1de/0x290
 [<ffffffff8107153f>] ? __wake_up_common+0x4f/0x80
 [<ffffffff810a0630>] ? cpu_stop_signal_done+0x30/0x30
 [<ffffffff81069ec5>] ? kthread+0x85/0x90
 [<ffffffff818ad294>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81069e40>] ? kthread_freezable_should_stop+0x60/0x60
 [<ffffffff818ad290>] ? gs_change+0xb/0xb
---[ end trace 431db5dbf525be18 ]---
CPU 2 is now offline
CPU 1 is now offline
SMP alternatives: switching to UP code
SMP alternatives: switching to SMP code
Booting Node 0 Processor 1 APIC 0x2
smpboot cpu 1: start_ip = 95000
Calibrating delay loop (skipped) already calibrated this CPU
Booting Node 0 Processor 2 APIC 0x4
smpboot cpu 2: start_ip = 95000
Calibrating delay loop (skipped) already calibrated this CPU
Booting Node 0 Processor 3 APIC 0x6
smpboot cpu 3: start_ip = 95000
Calibrating delay loop (skipped) already calibrated this CPU
Booting Node 0 Processor 4 APIC 0x1
smpboot cpu 4: start_ip = 95000
Calibrating delay loop (skipped) already calibrated this CPU
Booting Node 0 Processor 5 APIC 0x3
smpboot cpu 5: start_ip = 95000
------------[ cut here ]------------
WARNING: at /mnt/data/.src/linux.git/arch/x86/kernel/smp.c:120
update_process_times+0x65/0x80()
Hardware name: Precision M6600
Modules linked in:
Pid: 288, comm: migration/4 Tainted: G        W    3.3.0-rc1-00473-g6bc2b95 #1
Call Trace:
 <IRQ>  [<ffffffff8104e5eb>] ? warn_slowpath_common+0x7b/0xc0
 [<ffffffff8108a000>] ? tick_nohz_handler+0xd0/0xd0
 [<ffffffff8105af45>] ? update_process_times+0x65/0x80
 [<ffffffff8108a05b>] ? tick_sched_timer+0x5b/0xb0
 [<ffffffff8106dc0e>] ? __run_hrtimer.isra.33+0x4e/0xe0
 [<ffffffff8106e3e0>] ? hrtimer_interrupt+0xe0/0x210
 [<ffffffff810a09e0>] ? queue_stop_cpus_work+0xf0/0xf0
 [<ffffffff8101c513>] ? smp_apic_timer_interrupt+0x63/0xa0
 [<ffffffff818acbcb>] ? apic_timer_interrupt+0x6b/0x70
 <EOI>  [<ffffffff810a0a6a>] ? stop_machine_cpu_stop+0x8a/0xb0
 [<ffffffff810a06f4>] ? cpu_stopper_thread+0xc4/0x190
 [<ffffffff81073e6e>] ? try_to_wake_up+0x1de/0x290
 [<ffffffff8107153f>] ? __wake_up_common+0x4f/0x80
 [<ffffffff810a0630>] ? cpu_stop_signal_done+0x30/0x30
 [<ffffffff81069ec5>] ? kthread+0x85/0x90
 [<ffffffff818ad294>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81069e40>] ? kthread_freezable_should_stop+0x60/0x60
 [<ffffffff818ad290>] ? gs_change+0xb/0xb
---[ end trace 431db5dbf525be19 ]---
Calibrating delay loop (skipped) already calibrated this CPU
Booting Node 0 Processor 6 APIC 0x5
smpboot cpu 6: start_ip = 95000
------------[ cut here ]------------
WARNING: at /mnt/data/.src/linux.git/arch/x86/kernel/smp.c:120
update_process_times+0x65/0x80()
Hardware name: Precision M6600
Modules linked in:
Pid: 288, comm: migration/4 Tainted: G        W    3.3.0-rc1-00473-g6bc2b95 #1
Call Trace:
 <IRQ>  [<ffffffff8104e5eb>] ? warn_slowpath_common+0x7b/0xc0
 [<ffffffff8108a000>] ? tick_nohz_handler+0xd0/0xd0
 [<ffffffff8105af45>] ? update_process_times+0x65/0x80
 [<ffffffff8108a05b>] ? tick_sched_timer+0x5b/0xb0
 [<ffffffff8106dc0e>] ? __run_hrtimer.isra.33+0x4e/0xe0
 [<ffffffff8106e3e0>] ? hrtimer_interrupt+0xe0/0x210
 [<ffffffff810a09e0>] ? queue_stop_cpus_work+0xf0/0xf0
 [<ffffffff8101c513>] ? smp_apic_timer_interrupt+0x63/0xa0
 [<ffffffff818acbcb>] ? apic_timer_interrupt+0x6b/0x70
 <EOI>  [<ffffffff810a0a6a>] ? stop_machine_cpu_stop+0x8a/0xb0
 [<ffffffff810a06f4>] ? cpu_stopper_thread+0xc4/0x190
 [<ffffffff81073e6e>] ? try_to_wake_up+0x1de/0x290
 [<ffffffff8107153f>] ? __wake_up_common+0x4f/0x80
 [<ffffffff810a0630>] ? cpu_stop_signal_done+0x30/0x30
 [<ffffffff81069ec5>] ? kthread+0x85/0x90
 [<ffffffff818ad294>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81069e40>] ? kthread_freezable_should_stop+0x60/0x60
 [<ffffffff818ad290>] ? gs_change+0xb/0xb
---[ end trace 431db5dbf525be1a ]---
Calibrating delay loop (skipped) already calibrated this CPU
Booting Node 0 Processor 7 APIC 0x7
smpboot cpu 7: start_ip = 95000
------------[ cut here ]------------
WARNING: at /mnt/data/.src/linux.git/arch/x86/kernel/smp.c:120
update_process_times+0x65/0x80()
Hardware name: Precision M6600
Modules linked in:
Pid: 293, comm: migration/5 Tainted: G        W    3.3.0-rc1-00473-g6bc2b95 #1
Call Trace:
 <IRQ>  [<ffffffff8104e5eb>] ? warn_slowpath_common+0x7b/0xc0
 [<ffffffff8108a000>] ? tick_nohz_handler+0xd0/0xd0
 [<ffffffff8105af45>] ? update_process_times+0x65/0x80
 [<ffffffff8108a05b>] ? tick_sched_timer+0x5b/0xb0
 [<ffffffff8106dc0e>] ? __run_hrtimer.isra.33+0x4e/0xe0
 [<ffffffff8106e3e0>] ? hrtimer_interrupt+0xe0/0x210
 [<ffffffff810a09e0>] ? queue_stop_cpus_work+0xf0/0xf0
 [<ffffffff8101c513>] ? smp_apic_timer_interrupt+0x63/0xa0
 [<ffffffff818acbcb>] ? apic_timer_interrupt+0x6b/0x70
 <EOI>  [<ffffffff810a0a6a>] ? stop_machine_cpu_stop+0x8a/0xb0
 [<ffffffff810a06f4>] ? cpu_stopper_thread+0xc4/0x190
 [<ffffffff81073e6e>] ? try_to_wake_up+0x1de/0x290
 [<ffffffff8107153f>] ? __wake_up_common+0x4f/0x80
 [<ffffffff810a0630>] ? cpu_stop_signal_done+0x30/0x30
 [<ffffffff81069ec5>] ? kthread+0x85/0x90
 [<ffffffff818ad294>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81069e40>] ? kthread_freezable_should_stop+0x60/0x60
 [<ffffffff818ad290>] ? gs_change+0xb/0xb
---[ end trace 431db5dbf525be1b ]---
Calibrating delay loop (skipped) already calibrated this CPU
