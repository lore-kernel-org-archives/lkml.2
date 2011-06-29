Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab1F2U7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 16:59:41 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:37076 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab1F2U7i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 16:59:38 -0400
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 3.0rc3-rc5: usb stops working after resume from suspend to ram
Date: Wed, 29 Jun 2011 22:59:31 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc5-00063-g0d72c6f; KDE/4.6.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.1106291557080.2064-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106291557080.2064-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106292259.32063.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 of June 2011, Alan Stern wrote:
> On Wed, 29 Jun 2011, Arkadiusz Miskiewicz wrote:
> > Hi,
> > 
> > Something broke between rc3 and rc5. Thinkpad t400, logitech usb mouse.
> > After resume from ram usb device no longer works. Somewhere around rc3 it
> > was working fine.
> 
> Obviously you can try bisection to find the problem.  But if you don't
> want to go through that, you could post the dmesg from a kernel that
> has CONFIG_USB_DEBUG enabled.

CONFIG_USB_DEBUG will be faster but I'll bisect if no one figures out what's 
wrong.

Note that I tried to unplug & plugin usb mouse after all this dmesg but 
nothing new appeared in dmesg - kernel didn't notice that I did that.

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.0.0-rc5-00063-g0d72c6f (arekm@ixion-pld) (gcc 
version 4.6.1 20110627 (release) (PLD-Linux) ) #7 SMP PREEMPT Wed Jun 29 
22:51:36 CEST 2011
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.0.0 
root=/dev/mapper/lrootfs ro resume=/dev/sda2 panic=60 reboot=acpi
[    0.000000] Disabled fast string operations
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bd4a1000 (usable)
[    0.000000]  BIOS-e820: 00000000bd4a1000 - 00000000bd4a7000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd4a7000 - 00000000bd5b7000 (usable)
[    0.000000]  BIOS-e820: 00000000bd5b7000 - 00000000bd60f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd60f000 - 00000000bd6c6000 (usable)
[    0.000000]  BIOS-e820: 00000000bd6c6000 - 00000000bd6d1000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd6d1000 - 00000000bd6d4000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd6d4000 - 00000000bd6d8000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd6d8000 - 00000000bd6dc000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd6dc000 - 00000000bd6df000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd6df000 - 00000000bd706000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd706000 - 00000000bd708000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd708000 - 00000000bd90f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd90f000 - 00000000bd99f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd99f000 - 00000000bd9ff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd9ff000 - 00000000bda00000 (usable)
[    0.000000]  BIOS-e820: 00000000bdc00000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: LENOVO 2764CTO/2764CTO, BIOS 7UET91WW (3.21 ) 12/06/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) 
==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x13c000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 13C000000 mask FFC000000 uncachable
[    0.000000]   1 base 0BE000000 mask FFE000000 uncachable
[    0.000000]   2 base 000000000 mask F80000000 write-back
[    0.000000]   3 base 080000000 mask FC0000000 write-back
[    0.000000]   4 base 100000000 mask FC0000000 write-back
[    0.000000]   5 base 0BDE00000 mask FFFE00000 uncachable
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106
[    0.000000] e820 update range: 00000000bde00000 - 0000000100000000 (usable) 
==> (reserved)
[    0.000000] last_pfn = 0xbda00 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f6480] f6480
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000bda00000
[    0.000000]  0000000000 - 00bda00000 page 2M
[    0.000000] kernel direct mapping tables up to bda00000 @ bd6c2000-bd6c6000
[    0.000000] init_memory_mapping: 0000000100000000-000000013c000000
[    0.000000]  0100000000 - 013c000000 page 2M
[    0.000000] kernel direct mapping tables up to 13c000000 @ 
13bffa000-13c000000
[    0.000000] RAMDISK: 37eb0000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f6440 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000bd949b5a 0009C (v01 LENOVO TP-7U    00003210  
LTP 00000000)
[    0.000000] ACPI: FACP 00000000bd949d00 000F4 (v03 LENOVO TP-7U    00003210 
LNVO 00000001)
[    0.000000] ACPI: DSDT 00000000bd94a10e 0FAE1 (v01 LENOVO TP-7U    00003210 
MSFT 03000000)
[    0.000000] ACPI: FACS 00000000bd98e000 00040
[    0.000000] ACPI: SSDT 00000000bd949eb4 0025A (v01 LENOVO TP-7U    00003210 
MSFT 03000000)
[    0.000000] ACPI: ECDT 00000000bd959bef 00052 (v01 LENOVO TP-7U    00003210 
LNVO 00000001)
[    0.000000] ACPI: APIC 00000000bd959c41 00078 (v01 LENOVO TP-7U    00003210 
LNVO 00000001)
[    0.000000] ACPI: MCFG 00000000bd959cb9 0003C (v01 LENOVO TP-7U    00003210 
LNVO 00000001)
[    0.000000] ACPI: HPET 00000000bd959cf5 00038 (v01 LENOVO TP-7U    00003210 
LNVO 00000001)
[    0.000000] ACPI: SLIC 00000000bd959dc2 00176 (v01 LENOVO TP-7U    00003210  
LTP 00000000)
[    0.000000] ACPI: BOOT 00000000bd959f38 00028 (v01 LENOVO TP-7U    00003210  
LTP 00000001)
[    0.000000] ACPI: ASF! 00000000bd959f60 000A0 (v16 LENOVO TP-7U    00003210 
PTL  00000001)
[    0.000000] ACPI: SSDT 00000000bd98d1fa 00568 (v01 LENOVO TP-7U    00003210 
INTL 20050513)
[    0.000000] ACPI: TCPA 00000000bd707000 00032 (v00                 00000000      
00000000)
[    0.000000] ACPI: DMAR 00000000bd706000 00120 (v01               ? 00000001      
00000000)
[    0.000000] ACPI: SSDT 00000000bd6d3000 00655 (v01  PmRef    CpuPm 00003000 
INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd6d2000 00274 (v01  PmRef  Cpu0Tst 00003000 
INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd6d1000 00242 (v01  PmRef    ApTst 00003000 
INTL 20050624)
[    0.000000] ACPI: DMI detected: Lenovo ThinkPad T400
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000013c000000
[    0.000000] Initmem setup node 0 0000000000000000-000000013c000000
[    0.000000]   NODE_DATA [000000013bffb000 - 000000013bffffff]
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880137600000-
ffff88013adfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0013c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[6] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bd4a1
[    0.000000]     0: 0x000bd4a7 -> 0x000bd5b7
[    0.000000]     0: 0x000bd60f -> 0x000bd6c6
[    0.000000]     0: 0x000bd9ff -> 0x000bda00
[    0.000000]     0: 0x00100000 -> 0x0013c000
[    0.000000] On node 0 totalpages: 1021431
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3921 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 757409 pages, LIFO batch:31
[    0.000000]   Normal zone: 3360 pages used for memmap
[    0.000000]   Normal zone: 242400 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] 4 Processors exceeds NR_CPUS limit of 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 
000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 
0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bd4a1000 - 
00000000bd4a7000
[    0.000000] PM: Registered nosave memory: 00000000bd5b7000 - 
00000000bd60f000
[    0.000000] PM: Registered nosave memory: 00000000bd6c6000 - 
00000000bd6d1000
[    0.000000] PM: Registered nosave memory: 00000000bd6d1000 - 
00000000bd6d4000
[    0.000000] PM: Registered nosave memory: 00000000bd6d4000 - 
00000000bd6d8000
[    0.000000] PM: Registered nosave memory: 00000000bd6d8000 - 
00000000bd6dc000
[    0.000000] PM: Registered nosave memory: 00000000bd6dc000 - 
00000000bd6df000
[    0.000000] PM: Registered nosave memory: 00000000bd6df000 - 
00000000bd706000
[    0.000000] PM: Registered nosave memory: 00000000bd706000 - 
00000000bd708000
[    0.000000] PM: Registered nosave memory: 00000000bd708000 - 
00000000bd90f000
[    0.000000] PM: Registered nosave memory: 00000000bd90f000 - 
00000000bd99f000
[    0.000000] PM: Registered nosave memory: 00000000bd99f000 - 
00000000bd9ff000
[    0.000000] PM: Registered nosave memory: 00000000bda00000 - 
00000000bdc00000
[    0.000000] PM: Registered nosave memory: 00000000bdc00000 - 
00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 
00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 
00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 
00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 
00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 
00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 
00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 
00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 
00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 
00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 
00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 
00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 
00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 
00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 
00000000ff800000
[    0.000000] PM: Registered nosave memory: 00000000ff800000 - 
0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: 
c0000000:20000000)
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 
nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88013bc00000 s69760 r8192 
d24448 u1048576
[    0.000000] pcpu-alloc: s69760 r8192 d24448 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total 
pages: 1003730
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.0.0 
root=/dev/mapper/lrootfs ro resume=/dev/sda2 panic=60 reboot=acpi
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3950216k/5177344k available (4134k kernel code, 
1091620k absent, 135508k reserved, 4577k data, 568k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, 
Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:320
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 33554432 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want 
memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2527.349 MHz processor.
[    0.004004] Calibrating delay loop (skipped), value calculated using timer 
frequency.. 5054.69 BogoMIPS (lpj=10109396)
[    0.004118] pid_max: default: 32768 minimum: 301
[    0.004202] Security Framework initialized
[    0.008117] Dentry cache hash table entries: 524288 (order: 10, 4194304 
bytes)
[    0.010257] Inode-cache hash table entries: 262144 (order: 9, 2097152 
bytes)
[    0.011269] Mount-cache hash table entries: 256
[    0.011491] Initializing cgroup subsys cpuacct
[    0.011553] Initializing cgroup subsys memory
[    0.011616] Initializing cgroup subsys devices
[    0.011672] Initializing cgroup subsys freezer
[    0.011727] Initializing cgroup subsys perf_event
[    0.011811] Disabled fast string operations
[    0.011868] CPU: Physical Processor ID: 0
[    0.011922] CPU: Processor Core ID: 0
[    0.011976] mce: CPU supports 6 MCE banks
[    0.012015] CPU0: Thermal monitoring enabled (TM2)
[    0.012073] using mwait in idle threads.
[    0.012146] ACPI: Core revision 20110413
[    0.020415] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.062716] CPU0: Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz stepping 
06
[    0.068003] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.068003] ... version:                2
[    0.068003] ... bit width:              40
[    0.068003] ... generic registers:      2
[    0.068003] ... value mask:             000000ffffffffff
[    0.068003] ... max period:             000000007fffffff
[    0.068003] ... fixed-purpose events:   3
[    0.068003] ... event mask:             0000000700000003
[    0.092019] Booting Node   0, Processors  #1 Ok.
[    0.092117] smpboot cpu 1: start_ip = 99000
[    0.008000] Disabled fast string operations
[    0.184027] Brought up 2 CPUs
[    0.184139] Total of 2 processors activated (10108.65 BogoMIPS).
[    0.185759] devtmpfs: initialized
[    0.185759] PM: Registering ACPI NVS region at bd6c6000 (45056 bytes)
[    0.185759] PM: Registering ACPI NVS region at bd6d8000 (16384 bytes)
[    0.185759] PM: Registering ACPI NVS region at bd6df000 (159744 bytes)
[    0.185759] PM: Registering ACPI NVS region at bd90f000 (589824 bytes)
[    0.185759] print_constraints: dummy: 
[    0.185759] NET: Registered protocol family 16
[    0.185759] ACPI FADT declares the system doesn't support PCIe ASPM, so 
disable it
[    0.185759] ACPI: bus type pci registered
[    0.185759] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 
0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.185759] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in E820
[    0.197214] PCI: Using configuration type 1 for base access
[    0.197299] bio: create slab <bio-0> at 0
[    0.197299] ACPI: Added _OSI(Linux)
[    0.201700] ACPI: EC: EC description table is found, configuring boot EC
[    0.207994] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query honored via DMI
[    0.225327] ACPI: SSDT 00000000bd6d6c20 002C8 (v01  PmRef  Cpu0Ist 00003000 
INTL 20050624)
[    0.225880] ACPI: Dynamic OEM Table Load:
[    0.226017] ACPI: SSDT           (null) 002C8 (v01  PmRef  Cpu0Ist 00003000 
INTL 20050624)
[    0.226305] ACPI: SSDT 00000000bd6d4020 0087A (v01  PmRef  Cpu0Cst 00003001 
INTL 20050624)
[    0.226887] ACPI: Dynamic OEM Table Load:
[    0.227023] ACPI: SSDT           (null) 0087A (v01  PmRef  Cpu0Cst 00003001 
INTL 20050624)
[    0.252260] ACPI: SSDT 00000000bd6d5ca0 001CF (v01  PmRef    ApIst 00003000 
INTL 20050624)
[    0.252827] ACPI: Dynamic OEM Table Load:
[    0.252963] ACPI: SSDT           (null) 001CF (v01  PmRef    ApIst 00003000 
INTL 20050624)
[    0.264066] ACPI: SSDT 00000000bd6d5f20 0008D (v01  PmRef    ApCst 00003000 
INTL 20050624)
[    0.264616] ACPI: Dynamic OEM Table Load:
[    0.264753] ACPI: SSDT           (null) 0008D (v01  PmRef    ApCst 00003000 
INTL 20050624)
[    0.284148] ACPI: Interpreter enabled
[    0.284205] ACPI: (supports S0 S3 S4 S5)
[    0.284436] ACPI: Using IOAPIC for interrupt routing
[    0.296091] ACPI: Power Resource [PUBS] (on)
[    0.304158] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.308346] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.308386] HEST: Table not found.
[    0.308442] PCI: Using host bridge windows from ACPI; if necessary, use 
"pci=nocrs" and report a bug
[    0.308735] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.308827] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.308827] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.308827] pci_root PNP0A08:00: host bridge window [mem 
0x000a0000-0x000bffff]
[    0.308827] pci_root PNP0A08:00: host bridge window [mem 
0x000d0000-0x000d3fff]
[    0.308827] pci_root PNP0A08:00: host bridge window [mem 
0x000d4000-0x000d7fff]
[    0.308827] pci_root PNP0A08:00: host bridge window [mem 
0x000d8000-0x000dbfff]
[    0.308827] pci_root PNP0A08:00: host bridge window [mem 
0xc0000000-0xfebfffff]
[    0.308827] pci 0000:00:00.0: [8086:2a40] type 0 class 0x000600
[    0.308827] pci 0000:00:02.0: [8086:2a42] type 0 class 0x000300
[    0.308827] pci 0000:00:02.0: reg 10: [mem 0xf4400000-0xf47fffff 64bit]
[    0.308827] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit 
pref]
[    0.308827] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.308827] pci 0000:00:02.1: [8086:2a43] type 0 class 0x000380
[    0.308827] pci 0000:00:02.1: reg 10: [mem 0xf4200000-0xf42fffff 64bit]
[    0.308827] pci 0000:00:03.0: [8086:2a44] type 0 class 0x000780
[    0.308827] pci 0000:00:03.0: reg 10: [mem 0xfc226800-0xfc22680f 64bit]
[    0.308827] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.308827] pci 0000:00:03.0: PME# disabled
[    0.308827] pci 0000:00:19.0: [8086:10f5] type 0 class 0x000200
[    0.308827] pci 0000:00:19.0: reg 10: [mem 0xfc000000-0xfc01ffff]
[    0.308832] pci 0000:00:19.0: reg 14: [mem 0xfc025000-0xfc025fff]
[    0.308843] pci 0000:00:19.0: reg 18: [io  0x1840-0x185f]
[    0.308910] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.308914] pci 0000:00:19.0: PME# disabled
[    0.308938] pci 0000:00:1a.0: [8086:2937] type 0 class 0x000c03
[    0.308993] pci 0000:00:1a.0: reg 20: [io  0x1860-0x187f]
[    0.309049] pci 0000:00:1a.1: [8086:2938] type 0 class 0x000c03
[    0.309103] pci 0000:00:1a.1: reg 20: [io  0x1880-0x189f]
[    0.309160] pci 0000:00:1a.2: [8086:2939] type 0 class 0x000c03
[    0.309215] pci 0000:00:1a.2: reg 20: [io  0x18a0-0x18bf]
[    0.309282] pci 0000:00:1a.7: [8086:293c] type 0 class 0x000c03
[    0.309306] pci 0000:00:1a.7: reg 10: [mem 0xfc226c00-0xfc226fff]
[    0.309393] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.309398] pci 0000:00:1a.7: PME# disabled
[    0.309428] pci 0000:00:1b.0: [8086:293e] type 0 class 0x000403
[    0.309448] pci 0000:00:1b.0: reg 10: [mem 0xfc020000-0xfc023fff 64bit]
[    0.309523] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.309528] pci 0000:00:1b.0: PME# disabled
[    0.309556] pci 0000:00:1c.0: [8086:2940] type 1 class 0x000604
[    0.309634] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.309638] pci 0000:00:1c.0: PME# disabled
[    0.309667] pci 0000:00:1c.1: [8086:2942] type 1 class 0x000604
[    0.309745] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.309749] pci 0000:00:1c.1: PME# disabled
[    0.309779] pci 0000:00:1c.3: [8086:2946] type 1 class 0x000604
[    0.309857] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.309861] pci 0000:00:1c.3: PME# disabled
[    0.309890] pci 0000:00:1c.4: [8086:2948] type 1 class 0x000604
[    0.309968] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.309973] pci 0000:00:1c.4: PME# disabled
[    0.310006] pci 0000:00:1d.0: [8086:2934] type 0 class 0x000c03
[    0.310061] pci 0000:00:1d.0: reg 20: [io  0x18c0-0x18df]
[    0.310117] pci 0000:00:1d.1: [8086:2935] type 0 class 0x000c03
[    0.310172] pci 0000:00:1d.1: reg 20: [io  0x18e0-0x18ff]
[    0.310229] pci 0000:00:1d.2: [8086:2936] type 0 class 0x000c03
[    0.312073] pci 0000:00:1d.2: reg 20: [io  0x1c00-0x1c1f]
[    0.312142] pci 0000:00:1d.7: [8086:293a] type 0 class 0x000c03
[    0.312166] pci 0000:00:1d.7: reg 10: [mem 0xfc227000-0xfc2273ff]
[    0.312253] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.312259] pci 0000:00:1d.7: PME# disabled
[    0.312285] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.312364] pci 0000:00:1f.0: [8086:2917] type 0 class 0x000601
[    0.312515] pci 0000:00:1f.2: [8086:2929] type 0 class 0x000106
[    0.312542] pci 0000:00:1f.2: reg 10: [io  0x1c48-0x1c4f]
[    0.312553] pci 0000:00:1f.2: reg 14: [io  0x183c-0x183f]
[    0.312564] pci 0000:00:1f.2: reg 18: [io  0x1c40-0x1c47]
[    0.312575] pci 0000:00:1f.2: reg 1c: [io  0x1838-0x183b]
[    0.312585] pci 0000:00:1f.2: reg 20: [io  0x1c20-0x1c3f]
[    0.312596] pci 0000:00:1f.2: reg 24: [mem 0xfc226000-0xfc2267ff]
[    0.312645] pci 0000:00:1f.2: PME# supported from D3hot
[    0.312649] pci 0000:00:1f.2: PME# disabled
[    0.312672] pci 0000:00:1f.3: [8086:2930] type 0 class 0x000c05
[    0.312693] pci 0000:00:1f.3: reg 10: [mem 0xfc227400-0xfc2274ff 64bit]
[    0.312722] pci 0000:00:1f.3: reg 20: [io  0x1c60-0x1c7f]
[    0.312811] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.312872] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] 
(disabled)
[    0.312876] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] 
(disabled)
[    0.312884] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff 
pref] (disabled)
[    0.313001] pci 0000:03:00.0: [8086:423b] type 0 class 0x000280
[    0.313044] pci 0000:03:00.0: reg 10: [mem 0xf4300000-0xf4301fff 64bit]
[    0.313206] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.313217] pci 0000:03:00.0: PME# disabled
[    0.313280] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.313341] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] 
(disabled)
[    0.313345] pci 0000:00:1c.1:   bridge window [mem 0xf4300000-0xf43fffff]
[    0.313352] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff 
pref] (disabled)
[    0.313408] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.313469] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.313473] pci 0000:00:1c.3:   bridge window [mem 0xf8000000-0xf9ffffff]
[    0.313480] pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf40fffff 
64bit pref]
[    0.313536] pci 0000:00:1c.4: PCI bridge to [bus 0d-14]
[    0.313596] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.313601] pci 0000:00:1c.4:   bridge window [mem 0xfa000000-0xfbffffff]
[    0.313608] pci 0000:00:1c.4:   bridge window [mem 0xf4100000-0xf41fffff 
64bit pref]
[    0.313653] pci 0000:15:00.0: [1180:0476] type 2 class 0x000607
[    0.313677] pci 0000:15:00.0: proprietary Ricoh MMC controller disabled 
(via cardbus function)
[    0.313748] pci 0000:15:00.0: MMC cards are now supported by standard SDHCI 
controller
[    0.313835] pci 0000:15:00.0: reg 10: [mem 0xf4800000-0xf4800fff]
[    0.313862] pci 0000:15:00.0: supports D1 D2
[    0.313864] pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.313870] pci 0000:15:00.0: PME# disabled
[    0.313894] pci 0000:15:00.1: [1180:0832] type 0 class 0x000c00
[    0.313919] pci 0000:15:00.1: reg 10: [mem 0xf4801000-0xf48017ff]
[    0.314019] pci 0000:15:00.1: supports D1 D2
[    0.314021] pci 0000:15:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.314026] pci 0000:15:00.1: PME# disabled
[    0.314051] pci 0000:15:00.2: [1180:0822] type 0 class 0x000805
[    0.314075] pci 0000:15:00.2: reg 10: [mem 0xf4801800-0xf48018ff]
[    0.314175] pci 0000:15:00.2: supports D1 D2
[    0.314177] pci 0000:15:00.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.314182] pci 0000:15:00.2: PME# disabled
[    0.314210] pci 0000:15:00.4: [1180:0592] type 0 class 0x000880
[    0.314235] pci 0000:15:00.4: reg 10: [mem 0xf4802000-0xf48020ff]
[    0.314334] pci 0000:15:00.4: supports D1 D2
[    0.314336] pci 0000:15:00.4: PME# supported from D0 D1 D2 D3hot D3cold
[    0.314341] pci 0000:15:00.4: PME# disabled
[    0.314366] pci 0000:15:00.5: [1180:0852] type 0 class 0x000880
[    0.314391] pci 0000:15:00.5: reg 10: [mem 0xf4802400-0xf48024ff]
[    0.314490] pci 0000:15:00.5: supports D1 D2
[    0.314492] pci 0000:15:00.5: PME# supported from D0 D1 D2 D3hot D3cold
[    0.314497] pci 0000:15:00.5: PME# disabled
[    0.314568] pci 0000:00:1e.0: PCI bridge to [bus 15-18] (subtractive 
decode)
[    0.314631] pci 0000:00:1e.0:   bridge window [io  0x4000-0x7fff]
[    0.314636] pci 0000:00:1e.0:   bridge window [mem 0xf4800000-0xf7ffffff]
[    0.314643] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf3ffffff 
64bit pref]
[    0.314645] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] 
(subtractive decode)
[    0.314648] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] 
(subtractive decode)
[    0.314650] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] 
(subtractive decode)
[    0.314652] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] 
(subtractive decode)
[    0.314655] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] 
(subtractive decode)
[    0.314657] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] 
(subtractive decode)
[    0.314659] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] 
(subtractive decode)
[    0.314740] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.314850] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.314881] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.314912] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.314944] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.314975] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.315230]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.315636]  pci0000:00: ACPI _OSC control (0x1d) granted
[    0.320095] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.320602] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.321119] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.321636] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.322154] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.322671] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.323193] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.324372] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.324863] vgaarb: device added: 
PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.324863] vgaarb: loaded
[    0.324863] vgaarb: bridge control possible 0000:00:02.0
[    0.324863] PCI: Using ACPI for IRQ routing
[    0.326357] PCI: pci_cache_line_size set to 64 bytes
[    0.326474] reserve RAM buffer: 000000000009ec00 - 000000000009ffff 
[    0.326476] reserve RAM buffer: 00000000bd4a1000 - 00000000bfffffff 
[    0.326480] reserve RAM buffer: 00000000bd5b7000 - 00000000bfffffff 
[    0.326484] reserve RAM buffer: 00000000bd6c6000 - 00000000bfffffff 
[    0.326488] reserve RAM buffer: 00000000bda00000 - 00000000bfffffff 
[    0.328033] NetLabel: Initializing
[    0.328088] NetLabel:  domain hash size = 128
[    0.328144] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.328210] NetLabel:  unlabeled traffic allowed by default
[    0.328273] HPET: 4 timers in total, 0 timers will be used for per-cpu 
timer
[    0.328337] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.328595] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.336086] Switching to clocksource hpet
[    0.337506] pnp: PnP ACPI init
[    0.337515] ACPI: bus type pnp registered
[    0.357722] Switched to NOHz mode on CPU #1
[    0.357723] Switched to NOHz mode on CPU #0
[    0.357821] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    0.357823] pnp 00:00: [mem 0x000c0000-0x000c3fff]
[    0.357824] pnp 00:00: [mem 0x000c4000-0x000c7fff]
[    0.357826] pnp 00:00: [mem 0x000c8000-0x000cbfff]
[    0.357827] pnp 00:00: [mem 0x000cc000-0x000cffff]
[    0.357829] pnp 00:00: [mem 0x000d0000-0x000cffff disabled]
[    0.357831] pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
[    0.357832] pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
[    0.357834] pnp 00:00: [mem 0x000dc000-0x000dffff]
[    0.357836] pnp 00:00: [mem 0x000e0000-0x000e3fff]
[    0.357838] pnp 00:00: [mem 0x000e4000-0x000e7fff]
[    0.357840] pnp 00:00: [mem 0x000e8000-0x000ebfff]
[    0.357842] pnp 00:00: [mem 0x000ec000-0x000effff]
[    0.357844] pnp 00:00: [mem 0x000f0000-0x000fffff]
[    0.357846] pnp 00:00: [mem 0x00100000-0xbfffffff]
[    0.357848] pnp 00:00: [mem 0xfec00000-0xfed3ffff]
[    0.357849] pnp 00:00: [mem 0xfed4c000-0xffffffff]
[    0.357934] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.357995] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.358056] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.358116] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.358176] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.358237] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
[    0.358297] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.358358] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.358418] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.358479] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.358539] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.358600] system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
[    0.358660] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.358721] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.358782] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.358800] pnp 00:01: [bus 00-ff]
[    0.358802] pnp 00:01: [io  0x0cf8-0x0cff]
[    0.358804] pnp 00:01: [io  0x0000-0x0cf7 window]
[    0.358806] pnp 00:01: [io  0x0d00-0xffff window]
[    0.358808] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    0.358810] pnp 00:01: [mem 0x000c0000-0x000c3fff window]
[    0.358812] pnp 00:01: [mem 0x000c4000-0x000c7fff window]
[    0.358814] pnp 00:01: [mem 0x000c8000-0x000cbfff window]
[    0.358816] pnp 00:01: [mem 0x000cc000-0x000cffff window]
[    0.358818] pnp 00:01: [mem 0x000d0000-0x000d3fff window]
[    0.358820] pnp 00:01: [mem 0x000d4000-0x000d7fff window]
[    0.358822] pnp 00:01: [mem 0x000d8000-0x000dbfff window]
[    0.358824] pnp 00:01: [mem 0x000dc000-0x000dffff window]
[    0.358826] pnp 00:01: [mem 0x000e0000-0x000e3fff window]
[    0.358828] pnp 00:01: [mem 0x000e4000-0x000e7fff window]
[    0.358830] pnp 00:01: [mem 0x000e8000-0x000ebfff window]
[    0.358833] pnp 00:01: [mem 0x000ec000-0x000effff window]
[    0.358835] pnp 00:01: [mem 0xc0000000-0xfebfffff window]
[    0.358837] pnp 00:01: [mem 0xfed40000-0xfed4bfff window]
[    0.358909] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 
(active)
[    0.378800] pnp 00:02: [io  0x0010-0x001f]
[    0.378802] pnp 00:02: [io  0x0090-0x009f]
[    0.378804] pnp 00:02: [io  0x0024-0x0025]
[    0.378805] pnp 00:02: [io  0x0028-0x0029]
[    0.378807] pnp 00:02: [io  0x002c-0x002d]
[    0.378809] pnp 00:02: [io  0x0030-0x0031]
[    0.378810] pnp 00:02: [io  0x0034-0x0035]
[    0.378812] pnp 00:02: [io  0x0038-0x0039]
[    0.378813] pnp 00:02: [io  0x003c-0x003d]
[    0.378815] pnp 00:02: [io  0x00a4-0x00a5]
[    0.378816] pnp 00:02: [io  0x00a8-0x00a9]
[    0.378818] pnp 00:02: [io  0x00ac-0x00ad]
[    0.378820] pnp 00:02: [io  0x00b0-0x00b5]
[    0.378821] pnp 00:02: [io  0x00b8-0x00b9]
[    0.378823] pnp 00:02: [io  0x00bc-0x00bd]
[    0.378824] pnp 00:02: [io  0x0050-0x0053]
[    0.378826] pnp 00:02: [io  0x0072-0x0077]
[    0.378827] pnp 00:02: [io  0x002e-0x002f]
[    0.378829] pnp 00:02: [io  0x1000-0x107f]
[    0.378831] pnp 00:02: [io  0x1180-0x11ff]
[    0.378832] pnp 00:02: [io  0x0800-0x080f]
[    0.378834] pnp 00:02: [io  0x15e0-0x15ef]
[    0.378835] pnp 00:02: [io  0x1600-0x167f]
[    0.378837] pnp 00:02: [io  0x1680-0x169f]
[    0.378839] pnp 00:02: [mem 0xe0000000-0xefffffff]
[    0.378841] pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
[    0.378842] pnp 00:02: [mem 0xfed10000-0xfed13fff]
[    0.378844] pnp 00:02: [mem 0xfed18000-0xfed18fff]
[    0.378846] pnp 00:02: [mem 0xfed19000-0xfed19fff]
[    0.378848] pnp 00:02: [mem 0xfed45000-0xfed4bfff]
[    0.378944] system 00:02: [io  0x1000-0x107f] has been reserved
[    0.379004] system 00:02: [io  0x1180-0x11ff] has been reserved
[    0.379065] system 00:02: [io  0x0800-0x080f] has been reserved
[    0.379124] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    0.379183] system 00:02: [io  0x1600-0x167f] has been reserved
[    0.379242] system 00:02: [io  0x1680-0x169f] has been reserved
[    0.379302] system 00:02: [mem 0xe0000000-0xefffffff] has been reserved
[    0.379362] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.379422] system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.379483] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.379543] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.379603] system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.379663] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.379699] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.379751] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.379761] pnp 00:04: [io  0x0000-0x000f]
[    0.379763] pnp 00:04: [io  0x0080-0x008f]
[    0.379765] pnp 00:04: [io  0x00c0-0x00df]
[    0.379766] pnp 00:04: [dma 4]
[    0.379817] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.379826] pnp 00:05: [io  0x0061]
[    0.379876] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.379885] pnp 00:06: [io  0x00f0]
[    0.379892] pnp 00:06: [irq 13]
[    0.379942] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.379951] pnp 00:07: [io  0x0070-0x0071]
[    0.379959] pnp 00:07: [irq 8]
[    0.380031] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.380041] pnp 00:08: [io  0x0060]
[    0.380042] pnp 00:08: [io  0x0064]
[    0.380047] pnp 00:08: [irq 1]
[    0.380098] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.380110] pnp 00:09: [irq 12]
[    0.380162] pnp 00:09: Plug and Play ACPI device, IDs IBM0057 PNP0f13 
(active)
[    0.400086] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    0.400157] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c31 (active)
[    0.400645] pnp: PnP ACPI: found 11 devices
[    0.400701] ACPI: ACPI bus type pnp unregistered
[    0.409092] PCI: max bus depth: 2 pci_try_num: 3
[    0.409145] pci 0000:00:1c.1: BAR 15: assigned [mem 0xc0000000-0xc01fffff 
64bit pref]
[    0.409218] pci 0000:00:1c.1: BAR 13: assigned [io  0x8000-0x8fff]
[    0.409279] pci 0000:00:1c.0: BAR 14: assigned [mem 0xc0200000-0xc03fffff]
[    0.409341] pci 0000:00:1c.0: BAR 15: assigned [mem 0xc0400000-0xc05fffff 
64bit pref]
[    0.409413] pci 0000:00:1c.0: BAR 13: assigned [io  0x9000-0x9fff]
[    0.409473] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.409532] pci 0000:00:1c.0:   bridge window [io  0x9000-0x9fff]
[    0.409595] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff]
[    0.409658] pci 0000:00:1c.0:   bridge window [mem 0xc0400000-0xc05fffff 
64bit pref]
[    0.409734] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.409793] pci 0000:00:1c.1:   bridge window [io  0x8000-0x8fff]
[    0.409855] pci 0000:00:1c.1:   bridge window [mem 0xf4300000-0xf43fffff]
[    0.409918] pci 0000:00:1c.1:   bridge window [mem 0xc0000000-0xc01fffff 
64bit pref]
[    0.409994] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.410053] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.410115] pci 0000:00:1c.3:   bridge window [mem 0xf8000000-0xf9ffffff]
[    0.410178] pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf40fffff 
64bit pref]
[    0.410254] pci 0000:00:1c.4: PCI bridge to [bus 0d-14]
[    0.410313] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.410376] pci 0000:00:1c.4:   bridge window [mem 0xfa000000-0xfbffffff]
[    0.410438] pci 0000:00:1c.4:   bridge window [mem 0xf4100000-0xf41fffff 
64bit pref]
[    0.410515] pci 0000:15:00.0: BAR 15: assigned [mem 0xf0000000-0xf3ffffff 
pref]
[    0.410588] pci 0000:15:00.0: BAR 16: assigned [mem 0xc4000000-0xc7ffffff]
[    0.410648] pci 0000:15:00.0: BAR 13: assigned [io  0x4000-0x40ff]
[    0.410708] pci 0000:15:00.0: BAR 14: assigned [io  0x4400-0x44ff]
[    0.410767] pci 0000:15:00.0: CardBus bridge to [bus 16-17]
[    0.410825] pci 0000:15:00.0:   bridge window [io  0x4000-0x40ff]
[    0.410887] pci 0000:15:00.0:   bridge window [io  0x4400-0x44ff]
[    0.410950] pci 0000:15:00.0:   bridge window [mem 0xf0000000-0xf3ffffff 
pref]
[    0.411023] pci 0000:15:00.0:   bridge window [mem 0xc4000000-0xc7ffffff]
[    0.411086] pci 0000:00:1e.0: PCI bridge to [bus 15-18]
[    0.411145] pci 0000:00:1e.0:   bridge window [io  0x4000-0x7fff]
[    0.411208] pci 0000:00:1e.0:   bridge window [mem 0xf4800000-0xf7ffffff]
[    0.411271] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf3ffffff 
64bit pref]
[    0.411355] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.413233] pci 0000:00:1c.0: setting latency timer to 64
[    0.413242] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.413305] pci 0000:00:1c.1: setting latency timer to 64
[    0.413313] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.413375] pci 0000:00:1c.3: setting latency timer to 64
[    0.413382] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.413444] pci 0000:00:1c.4: setting latency timer to 64
[    0.413452] pci 0000:00:1e.0: setting latency timer to 64
[    0.413461] pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.413525] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.413527] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.413529] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.413532] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.413534] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.413536] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.413538] pci_bus 0000:00: resource 10 [mem 0xc0000000-0xfebfffff]
[    0.413540] pci_bus 0000:02: resource 0 [io  0x9000-0x9fff]
[    0.413542] pci_bus 0000:02: resource 1 [mem 0xc0200000-0xc03fffff]
[    0.413544] pci_bus 0000:02: resource 2 [mem 0xc0400000-0xc05fffff 64bit 
pref]
[    0.413547] pci_bus 0000:03: resource 0 [io  0x8000-0x8fff]
[    0.413549] pci_bus 0000:03: resource 1 [mem 0xf4300000-0xf43fffff]
[    0.413551] pci_bus 0000:03: resource 2 [mem 0xc0000000-0xc01fffff 64bit 
pref]
[    0.413553] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    0.413555] pci_bus 0000:05: resource 1 [mem 0xf8000000-0xf9ffffff]
[    0.413557] pci_bus 0000:05: resource 2 [mem 0xf4000000-0xf40fffff 64bit 
pref]
[    0.413560] pci_bus 0000:0d: resource 0 [io  0x3000-0x3fff]
[    0.413562] pci_bus 0000:0d: resource 1 [mem 0xfa000000-0xfbffffff]
[    0.413564] pci_bus 0000:0d: resource 2 [mem 0xf4100000-0xf41fffff 64bit 
pref]
[    0.413566] pci_bus 0000:15: resource 0 [io  0x4000-0x7fff]
[    0.413568] pci_bus 0000:15: resource 1 [mem 0xf4800000-0xf7ffffff]
[    0.413570] pci_bus 0000:15: resource 2 [mem 0xf0000000-0xf3ffffff 64bit 
pref]
[    0.413572] pci_bus 0000:15: resource 4 [io  0x0000-0x0cf7]
[    0.413574] pci_bus 0000:15: resource 5 [io  0x0d00-0xffff]
[    0.413576] pci_bus 0000:15: resource 6 [mem 0x000a0000-0x000bffff]
[    0.413579] pci_bus 0000:15: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.413581] pci_bus 0000:15: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.413583] pci_bus 0000:15: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.413585] pci_bus 0000:15: resource 10 [mem 0xc0000000-0xfebfffff]
[    0.413587] pci_bus 0000:16: resource 0 [io  0x4000-0x40ff]
[    0.413589] pci_bus 0000:16: resource 1 [io  0x4400-0x44ff]
[    0.413591] pci_bus 0000:16: resource 2 [mem 0xf0000000-0xf3ffffff pref]
[    0.413593] pci_bus 0000:16: resource 3 [mem 0xc4000000-0xc7ffffff]
[    0.413627] NET: Registered protocol family 2
[    0.413805] IP route cache hash table entries: 131072 (order: 8, 1048576 
bytes)
[    0.415073] TCP established hash table entries: 524288 (order: 11, 8388608 
bytes)
[    0.418309] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.418833] TCP: Hash tables configured (established 524288 bind 65536)
[    0.418893] TCP reno registered
[    0.418955] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.419049] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.419266] NET: Registered protocol family 1
[    0.419340] pci 0000:00:02.0: Boot video device
[    0.419355] pci 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    0.419357] pci 0000:00:1a.0: Performing full reset
[    0.419377] pci 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    0.419379] pci 0000:00:1a.1: Performing full reset
[    0.419398] pci 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    0.419400] pci 0000:00:1a.2: Performing full reset
[    0.419464] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    0.419466] pci 0000:00:1d.0: Performing full reset
[    0.419485] pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    0.419487] pci 0000:00:1d.1: Performing full reset
[    0.419507] pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    0.419508] pci 0000:00:1d.2: Performing full reset
[    0.419578] PCI: CLS 64 bytes, default 64
[    0.419630] Trying to unpack rootfs image as initramfs...
[    0.421827] rootfs image is not initramfs (no cpio magic); looks like an 
initrd
[    0.423209] Freeing initrd memory: 1280k freed
[    0.423485] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.423545] Placing 64MB software IO TLB between ffff8800b94a1000 - 
ffff8800bd4a1000
[    0.423616] software IO TLB at phys 0xb94a1000 - 0xbd4a1000
[    0.423688] Simple Boot Flag at 0x35 set to 0x1
[    0.424657] audit: initializing netlink socket (disabled)
[    0.424724] type=2000 audit(1309380898.420:1): initialized
[    0.435638] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.458418] VFS: Disk quotas dquot_6.5.2
[    0.458570] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.458737] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.458853] msgmni has been set to 7717
[    0.459249] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 
253)
[    0.459321] io scheduler noop registered
[    0.459377] io scheduler deadline registered (default)
[    0.459575] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.459626] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.459822] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.459870] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    0.460109] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.460157] pcieport 0000:00:1c.3: irq 42 for MSI/MSI-X
[    0.460349] pcieport 0000:00:1c.4: setting latency timer to 64
[    0.460397] pcieport 0000:00:1c.4: irq 43 for MSI/MSI-X
[    0.460666] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    0.460730] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    0.460750] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
[    0.460811] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    0.460873] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
[    0.460893] pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
[    0.460956] pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
[    0.460976] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
[    0.461038] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
[    0.461162] intel_idle: MWAIT substates: 0x3122220
[    0.461164] intel_idle: does not run on family 6 model 23
[    0.461246] input: Lid Switch as 
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    0.461495] ACPI: Lid Switch [LID]
[    0.461622] input: Sleep Button as 
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    0.461696] ACPI: Sleep Button [SLPB]
[    0.461839] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.461910] ACPI: Power Button [PWRF]
[    0.462010] ERST: Table is not found!
[    0.492976] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.592429] Linux agpgart interface v0.103
[    0.592635] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[    0.592819] agpgart-intel 0000:00:00.0: detected gtt size: 524288K total, 
262144K mappable
[    0.594593] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    0.594859] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.595032] [drm] Initialized drm 1.1.0 20060810
[    0.595133] [drm] radeon defaulting to userspace modesetting.
[    0.596266] i915 0000:00:02.0: power state changed by ACPI to D0
[    0.596327] i915 0000:00:02.0: power state changed by ACPI to D0
[    0.596390] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.596452] i915 0000:00:02.0: setting latency timer to 64
[    0.654698] i915 0000:00:02.0: irq 44 for MSI/MSI-X
[    0.654703] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.654765] [drm] Driver supports precise vblank timestamp query.
[    0.654867] vgaarb: device changed decodes: 
PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.010422] fbcon: inteldrmfb (fb0) is primary device
[    1.060795] Console: switching to colour frame buffer device 180x56
[    1.064470] fb0: inteldrmfb frame buffer device
[    1.064494] drm: registered panic notifier
[    1.165732] acpi device:02: registered as cooling_device0
[    1.165881] input: Video Bus as 
/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input3
[    1.165932] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    1.166037] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 
0
[    1.168150] brd: module loaded
[    1.168280] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 
0x60,0x64 irq 1,12
[    1.177442] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.177496] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.177725] mousedev: PS/2 mouse device common for all mice
[    1.177820] rtc_cmos 00:07: RTC can wake from S4
[    1.177982] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    1.178042] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.178120] cpuidle: using governor ladder
[    1.178144] cpuidle: using governor menu
[    1.178379] TCP cubic registered
[    1.178400] NET: Registered protocol family 17
[    1.182844] input: AT Translated Set 2 keyboard as 
/devices/platform/i8042/serio0/input/input4
[    1.189106] registered taskstats version 1
[    1.199162] rtc_cmos 00:07: setting system clock to 2011-06-29 20:55:00 UTC 
(1309380900)
[    1.199366] RAMDISK: lzo image found at block 0
[    1.214960] VFS: Mounted root (romfs filesystem) readonly on device 1:0.
[    1.220628] device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised: 
dm-devel@redhat.com
[    1.223237] Intel AES-NI instructions are not detected.
[    1.236585] SCSI subsystem initialized
[    1.240970] libata version 3.00 loaded.
[    1.242087] ahci 0000:00:1f.2: version 3.0
[    1.242103] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    1.243578] ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
[    1.243619] ahci: SSS flag set, parallel bus scan disabled
[    1.245070] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 
impl SATA mode
[    1.246519] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio 
slum part ccc sxs 
[    1.247960] ahci 0000:00:1f.2: setting latency timer to 64
[    1.248790] scsi0 : ahci
[    1.250343] scsi1 : ahci
[    1.251858] scsi2 : ahci
[    1.253378] scsi3 : ahci
[    1.255065] ata1: SATA max UDMA/133 abar m2048@0xfc226000 port 0xfc226100 
irq 45
[    1.256477] ata2: SATA max UDMA/133 abar m2048@0xfc226000 port 0xfc226180 
irq 45
[    1.257835] ata3: DUMMY
[    1.259178] ata4: DUMMY
[    1.420017] Refined TSC clocksource calibration: 2526.999 MHz.
[    1.421384] Switching to clocksource tsc
[    1.580018] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.592090] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.592093] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) 
filtered out
[    1.593474] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[    1.601143] ata1.00: ATA-8: OCZ-VERTEX2, 1.32, max UDMA/133
[    1.602510] ata1.00: 468862128 sectors, multi 16: LBA48 NCQ (depth 31/32), 
AA
[    1.611142] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.611145] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) 
filtered out
[    1.612532] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[    1.621144] ata1.00: configured for UDMA/133
[    1.622624] scsi 0:0:0:0: Direct-Access     ATA      OCZ-VERTEX2      1.32 
PQ: 0 ANSI: 5
[    1.944016] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.947876] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    1.948966] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    1.948970] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[    1.951435] ata2.00: ATAPI: Optiarc  DVD RW AD-7910S, 1.D0, max UDMA/100
[    1.955830] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    1.956911] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    1.956914] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[    1.959377] ata2.00: configured for UDMA/100
[    1.963094] scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7910S  1.D0 
PQ: 0 ANSI: 5
[    1.965748] sd 0:0:0:0: [sda] 468862128 512-byte logical blocks: (240 
GB/223 GiB)
[    1.967669] sd 0:0:0:0: [sda] Write Protect is off
[    1.969094] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.969113] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    1.971224]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 >
[    1.973151] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.993735] SGI XFS with ACLs, security attributes, large block/inode 
numbers, no debug enabled
[    1.995833] SGI XFS Quota Management subsystem
[    6.460357] XFS (dm-0): Mounting Filesystem
[    6.512395] XFS (dm-0): Ending clean mount
[    6.513899] VFS: Mounted root (xfs filesystem) readonly on device 254:0.
[    6.515390] Trying to move old root to /initrd ... okay
[    6.517489] devtmpfs: mounted
[    6.519899] Freeing unused kernel memory: 568k freed
[    6.521553] Write protecting the kernel read-only data: 8192k
[    6.529276] Freeing unused kernel memory: 1988k freed
[    6.532266] Freeing unused kernel memory: 280k freed
[    6.849859] usbcore: registered new interface driver usbfs
[    6.849907] usbcore: registered new interface driver hub
[    6.855001] usbcore: registered new device driver usb
[    6.855060] e1000e: Intel(R) PRO/1000 Network Driver - 1.3.10-k2
[    6.855062] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    6.855093] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    6.855107] e1000e 0000:00:19.0: setting latency timer to 64
[    6.855245] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[    6.857658] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.857661] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    6.861648] iTCO_vendor_support: vendor-support=0
[    6.866049] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[    6.866153] iTCO_wdt: Found a ICH9M-E TCO device (Version=2, 
TCOBASE=0x1060)
[    6.866307] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    6.875510] ACPI: acpi_idle registered with cpuidle
[    6.880382] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    6.904369] Monitor-Mwait will be used to enter C-1 state
[    6.905914] Monitor-Mwait will be used to enter C-2 state
[    6.907374] Monitor-Mwait will be used to enter C-3 state
[    6.907442] Marking TSC unstable due to TSC halts in idle
[    6.908281] Switching to clocksource hpet
[    6.919126] cfg80211: Calling CRDA to update world regulatory domain
[    6.923014] yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:20c6]
[    6.927809] thermal LNXTHERM:00: registered as thermal_zone0
[    6.927812] ACPI: Thermal Zone [THM0] (50 C)
[    6.941581] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-
tree:d
[    6.941584] iwlagn: Copyright(c) 2003-2011 Intel Corporation
[    6.941947] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    6.941957] iwlagn 0000:03:00.0: setting latency timer to 64
[    6.941988] iwlagn 0000:03:00.0: Detected Intel(R) WiMAX/WiFi Link 5350 
AGN, REV=0x24
[    6.944413] wmi: Mapper loaded
[    6.945243] thermal LNXTHERM:01: registered as thermal_zone1
[    6.945245] ACPI: Thermal Zone [THM1] (47 C)
[    6.962046] Non-volatile memory driver v1.3
[    6.973815] ACPI: Battery Slot [BAT0] (battery present)
[    6.974378] ACPI: AC Adapter [AC] (on-line)
[    6.979003] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    7.003532] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 
cdda tray
[    7.003536] cdrom: Uniform CD-ROM driver Revision: 3.20
[    7.003651] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    7.027002] iwlagn 0000:03:00.0: device EEPROM VER=0x21e, CALIB=0x4
[    7.027005] iwlagn 0000:03:00.0: Device SKU: 0Xb
[    7.027007] iwlagn 0000:03:00.0: Valid Tx ant: 0X7, Valid Rx ant: 0X7
[    7.027019] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a 
channels
[    7.027526] iwlagn 0000:03:00.0: irq 47 for MSI/MSI-X
[    7.027759] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[    7.027761] thinkpad_acpi: http://ibm-acpi.sf.net/
[    7.027762] thinkpad_acpi: ThinkPad BIOS 7UET91WW (3.21 ), EC 7VHT16WW-1.06
[    7.027764] thinkpad_acpi: Lenovo ThinkPad T400, model 2764CTO
[    7.048369] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[    7.048572] thinkpad_acpi: radio switch found; radios are enabled
[    7.048874] yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0cb8, PCI irq 16
[    7.048878] yenta_cardbus 0000:15:00.0: Socket status: 30000006
[    7.048884] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: 
[io  0x4000-0x7fff]
[    7.048887] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: 
[mem 0xf4800000-0xf7ffffff]
[    7.048890] pcmcia_socket pcmcia_socket0: cs: memory probe 
0xf4800000-0xf7ffffff: excluding 0xf4800000-0xf4b7ffff
[    7.048905] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: 
[mem 0xf0000000-0xf3ffffff 64bit pref]
[    7.048907] pcmcia_socket pcmcia_socket0: cs: memory probe 
0xf0000000-0xf3ffffff: excluding 0xf0000000-0xf3ffffff
[    7.052372] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is 
unblocked
[    7.059421] thinkpad_acpi: rfkill switch tpacpi_wwan_sw: radio is unblocked
[    7.060067] sdhci: Secure Digital Host Controller Interface driver
[    7.060069] sdhci: Copyright(c) Pierre Ossman
[    7.061099] firewire_ohci 0000:15:00.1: PCI INT B -> GSI 17 (level, low) -> 
IRQ 17
[    7.062885] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    7.063800] Registered led device: tpacpi::thinklight
[    7.063836] Registered led device: tpacpi::power
[    7.063851] Registered led device: tpacpi::standby
[    7.063867] Registered led device: tpacpi::thinkvantage
[    7.067144] thinkpad_acpi: Standard ACPI backlight interface available, not 
loading native one
[    7.067223] thinkpad_acpi: Console audio control enabled, mode: override 
(read/write)
[    7.069428] input: ThinkPad Extra Buttons as 
/devices/platform/thinkpad_acpi/input/input6
[    7.072163] tpm_tis 00:0a: 1.2 TPM (device-id 0x1020, rev-id 6)
[    7.072166] tpm_tis 00:0a: Intel iTPM workaround enabled
[    7.074678] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 
00:21:86:a2:19:06
[    7.074681] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    7.074703] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1008FF-0FF
[    7.074723] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    7.074727] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    7.074735] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 
23
[    7.074756] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    7.074760] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    7.074775] drivers/usb/core/inode.c: creating file 'devices'
[    7.074778] drivers/usb/core/inode.c: creating file '001'
[    7.074781] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus 
number 1
[    7.074792] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 
pcc=2 ordered !ppc ports=6
[    7.074797] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 
1024 64 bit addr hw prefetch
[    7.074825] ehci_hcd 0000:00:1a.7: debug port 1
[    7.074830] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 
period=1024 Reset HALT
[    7.078704] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    7.078706] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    7.078725] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xfc226c00
[    7.078729] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 
period=1024 Reset HALT
[    7.082608] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 
period=1024 RUN
[    7.092053] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    7.092098] usb usb1: default language 0x0409
[    7.092104] usb usb1: udev 1, busnum 1, minor = 0
[    7.092106] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    7.092108] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    7.092110] usb usb1: Product: EHCI Host Controller
[    7.092112] usb usb1: Manufacturer: Linux 3.0.0-rc5-00063-g0d72c6f ehci_hcd
[    7.092114] usb usb1: SerialNumber: 0000:00:1a.7
[    7.092218] usb usb1: usb_probe_device
[    7.092220] usb usb1: configuration #1 chosen from 1 choice
[    7.092228] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    7.092250] hub 1-0:1.0: usb_probe_interface
[    7.092251] hub 1-0:1.0: usb_probe_interface - got id
[    7.092254] hub 1-0:1.0: USB hub found
[    7.092258] hub 1-0:1.0: 6 ports detected
[    7.092259] hub 1-0:1.0: standalone hub
[    7.092261] hub 1-0:1.0: no power switching (usb 1.0)
[    7.092263] hub 1-0:1.0: individual port over-current protection
[    7.092265] hub 1-0:1.0: power on to power good time: 20ms
[    7.092268] hub 1-0:1.0: local power source is good
[    7.092270] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    7.092319] drivers/usb/core/inode.c: creating file '001'
[    7.092369] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    7.092374] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    7.092386] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 
19
[    7.092412] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    7.092416] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    7.092421] drivers/usb/core/inode.c: creating file '002'
[    7.092424] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus 
number 2
[    7.092433] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 
pcc=2 ordered !ppc ports=6
[    7.092438] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 
1024 64 bit addr hw prefetch
[    7.092688] ehci_hcd 0000:00:1d.7: debug port 1
[    7.092692] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 
period=1024 Reset HALT
[    7.096858] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    7.096860] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    7.096877] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xfc227000
[    7.096882] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 
period=1024 Reset HALT
[    7.100766] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 
period=1024 RUN
[    7.112019] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    7.112039] usb usb2: default language 0x0409
[    7.112045] usb usb2: udev 1, busnum 2, minor = 128
[    7.112047] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    7.112049] usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    7.112051] usb usb2: Product: EHCI Host Controller
[    7.112053] usb usb2: Manufacturer: Linux 3.0.0-rc5-00063-g0d72c6f ehci_hcd
[    7.112055] usb usb2: SerialNumber: 0000:00:1d.7
[    7.112136] usb usb2: usb_probe_device
[    7.112138] usb usb2: configuration #1 chosen from 1 choice
[    7.112145] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    7.112171] hub 2-0:1.0: usb_probe_interface
[    7.112172] hub 2-0:1.0: usb_probe_interface - got id
[    7.112176] hub 2-0:1.0: USB hub found
[    7.112180] hub 2-0:1.0: 6 ports detected
[    7.112182] hub 2-0:1.0: standalone hub
[    7.112183] hub 2-0:1.0: no power switching (usb 1.0)
[    7.112185] hub 2-0:1.0: individual port over-current protection
[    7.112187] hub 2-0:1.0: power on to power good time: 20ms
[    7.112190] hub 2-0:1.0: local power source is good
[    7.112192] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    7.112241] drivers/usb/core/inode.c: creating file '001'
[    7.112423] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) -> 
IRQ 23
[    7.112597] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 
17
[    7.112651] HDA Intel 0000:00:1b.0: irq 48 for MSI/MSI-X
[    7.112679] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    7.124311] firewire_ohci: Added fw-ohci device 0000:15:00.1, OHCI v1.10, 4 
IR + 4 IT contexts, quirks 0x1
[    7.124499] sdhci-pci 0000:15:00.2: SDHCI controller found [1180:0822] (rev 
21)
[    7.124514] sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[    7.125533] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW 
doesn't fully claim to support it.
[    7.125552] mmc0: no vmmc regulator found
[    7.126580] Registered led device: mmc0::
[    7.127621] mmc0: SDHCI controller on PCI [0000:15:00.2] using DMA
[    7.139381] Monitor-Mwait will be used to enter C-3 state
[    7.189149] ALSA sound/pci/hda/hda_codec.c:3771 hda_codec: model 'laptop' 
is selected
[    7.189214] input: HDA Digital PCBeep as 
/devices/pci0000:00/0000:00:1b.0/input/input7
[    7.192042] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001803 0  ACK 
POWER sig=j CSC CONNECT
[    7.192059] hub 1-0:1.0: port 1: status 0501 change 0001
[    7.192073] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 001803 0  ACK 
POWER sig=j CSC CONNECT
[    7.192076] hub 1-0:1.0: port 4: status 0501 change 0001
[    7.192086] ehci_hcd 0000:00:1a.7: GetStatus port:6 status 001803 0  ACK 
POWER sig=j CSC CONNECT
[    7.192089] hub 1-0:1.0: port 6: status 0501 change 0001
[    7.202828] input: HDA Intel Mic as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    7.202949] input: HDA Intel Mic as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    7.203012] input: HDA Intel Headphone as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    7.212034] ehci_hcd 0000:00:1d.7: GetStatus port:4 status 001803 0  ACK 
POWER sig=j CSC CONNECT
[    7.212039] hub 2-0:1.0: port 4: status 0501 change 0001
[    7.212504] uhci_hcd: USB Universal Host Controller Interface driver
[    7.212557] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    7.212560] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    7.212568] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 
20
[    7.212576] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    7.212580] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    7.212587] drivers/usb/core/inode.c: creating file '003'
[    7.212592] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus 
number 3
[    7.212603] uhci_hcd 0000:00:1a.0: detected 2 ports
[    7.212608] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    7.212610] uhci_hcd 0000:00:1a.0: Performing full reset
[    7.212624] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    7.212646] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    7.212684] usb usb3: default language 0x0409
[    7.212690] usb usb3: udev 1, busnum 3, minor = 256
[    7.212692] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    7.212694] usb usb3: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    7.212696] usb usb3: Product: UHCI Host Controller
[    7.212698] usb usb3: Manufacturer: Linux 3.0.0-rc5-00063-g0d72c6f uhci_hcd
[    7.212700] usb usb3: SerialNumber: 0000:00:1a.0
[    7.212822] usb usb3: usb_probe_device
[    7.212824] usb usb3: configuration #1 chosen from 1 choice
[    7.212831] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    7.212853] hub 3-0:1.0: usb_probe_interface
[    7.212855] hub 3-0:1.0: usb_probe_interface - got id
[    7.212857] hub 3-0:1.0: USB hub found
[    7.212861] hub 3-0:1.0: 2 ports detected
[    7.212863] hub 3-0:1.0: standalone hub
[    7.212864] hub 3-0:1.0: no power switching (usb 1.0)
[    7.212866] hub 3-0:1.0: individual port over-current protection
[    7.212868] hub 3-0:1.0: power on to power good time: 2ms
[    7.212871] hub 3-0:1.0: local power source is good
[    7.212873] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    7.212911] drivers/usb/core/inode.c: creating file '001'
[    7.212942] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    7.212968] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 
21
[    7.212974] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    7.212977] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    7.212982] drivers/usb/core/inode.c: creating file '004'
[    7.212985] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus 
number 4
[    7.212994] uhci_hcd 0000:00:1a.1: detected 2 ports
[    7.212998] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    7.213000] uhci_hcd 0000:00:1a.1: Performing full reset
[    7.213028] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    7.213066] usb usb4: default language 0x0409
[    7.213071] usb usb4: udev 1, busnum 4, minor = 384
[    7.213073] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    7.213075] usb usb4: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    7.213077] usb usb4: Product: UHCI Host Controller
[    7.213079] usb usb4: Manufacturer: Linux 3.0.0-rc5-00063-g0d72c6f uhci_hcd
[    7.213080] usb usb4: SerialNumber: 0000:00:1a.1
[    7.213143] usb usb4: usb_probe_device
[    7.213145] usb usb4: configuration #1 chosen from 1 choice
[    7.213151] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    7.250039] hub 4-0:1.0: usb_probe_interface
[    7.250042] hub 4-0:1.0: usb_probe_interface - got id
[    7.250045] hub 4-0:1.0: USB hub found
[    7.250052] hub 4-0:1.0: 2 ports detected
[    7.250054] hub 4-0:1.0: standalone hub
[    7.250055] hub 4-0:1.0: no power switching (usb 1.0)
[    7.250057] hub 4-0:1.0: individual port over-current protection
[    7.250059] hub 4-0:1.0: power on to power good time: 2ms
[    7.250062] hub 4-0:1.0: local power source is good
[    7.250064] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    7.250110] drivers/usb/core/inode.c: creating file '001'
[    7.250147] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
[    7.250177] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    7.250179] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    7.250192] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 
22
[    7.250201] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    7.250205] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    7.250212] drivers/usb/core/inode.c: creating file '005'
[    7.250217] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus 
number 5
[    7.250228] uhci_hcd 0000:00:1a.2: detected 2 ports
[    7.250233] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    7.250235] uhci_hcd 0000:00:1a.2: Performing full reset
[    7.250250] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    7.250271] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[    7.250310] usb usb5: default language 0x0409
[    7.250316] usb usb5: udev 1, busnum 5, minor = 512
[    7.250318] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    7.250320] usb usb5: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    7.250323] usb usb5: Product: UHCI Host Controller
[    7.250324] usb usb5: Manufacturer: Linux 3.0.0-rc5-00063-g0d72c6f uhci_hcd
[    7.250326] usb usb5: SerialNumber: 0000:00:1a.2
[    7.250452] usb usb5: usb_probe_device
[    7.250455] usb usb5: configuration #1 chosen from 1 choice
[    7.250462] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    7.250482] hub 5-0:1.0: usb_probe_interface
[    7.250483] hub 5-0:1.0: usb_probe_interface - got id
[    7.250485] hub 5-0:1.0: USB hub found
[    7.250489] hub 5-0:1.0: 2 ports detected
[    7.250491] hub 5-0:1.0: standalone hub
[    7.250492] hub 5-0:1.0: no power switching (usb 1.0)
[    7.250494] hub 5-0:1.0: individual port over-current protection
[    7.250495] hub 5-0:1.0: power on to power good time: 2ms
[    7.250499] hub 5-0:1.0: local power source is good
[    7.250501] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    7.250544] drivers/usb/core/inode.c: creating file '001'
[    7.250574] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.2
[    7.250594] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    7.250596] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    7.250601] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 
16
[    7.250608] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    7.250611] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    7.250616] drivers/usb/core/inode.c: creating file '006'
[    7.250620] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus 
number 6
[    7.250629] uhci_hcd 0000:00:1d.0: detected 2 ports
[    7.250633] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    7.250635] uhci_hcd 0000:00:1d.0: Performing full reset
[    7.250650] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    7.250655] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[    7.250689] usb usb6: default language 0x0409
[    7.250695] usb usb6: udev 1, busnum 6, minor = 640
[    7.250697] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    7.250699] usb usb6: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    7.250701] usb usb6: Product: UHCI Host Controller
[    7.250702] usb usb6: Manufacturer: Linux 3.0.0-rc5-00063-g0d72c6f uhci_hcd
[    7.250704] usb usb6: SerialNumber: 0000:00:1d.0
[    7.250767] usb usb6: usb_probe_device
[    7.250770] usb usb6: configuration #1 chosen from 1 choice
[    7.250775] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    7.250794] hub 6-0:1.0: usb_probe_interface
[    7.250796] hub 6-0:1.0: usb_probe_interface - got id
[    7.250798] hub 6-0:1.0: USB hub found
[    7.250802] hub 6-0:1.0: 2 ports detected
[    7.250803] hub 6-0:1.0: standalone hub
[    7.250805] hub 6-0:1.0: no power switching (usb 1.0)
[    7.250806] hub 6-0:1.0: individual port over-current protection
[    7.250808] hub 6-0:1.0: power on to power good time: 2ms
[    7.255547] hub 6-0:1.0: local power source is good
[    7.255550] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    7.255599] drivers/usb/core/inode.c: creating file '001'
[    7.255640] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    7.255663] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 
17
[    7.255672] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    7.255675] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    7.255680] drivers/usb/core/inode.c: creating file '007'
[    7.255687] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus 
number 7
[    7.255696] uhci_hcd 0000:00:1d.1: detected 2 ports
[    7.255700] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    7.255702] uhci_hcd 0000:00:1d.1: Performing full reset
[    7.255721] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[    7.255757] usb usb7: default language 0x0409
[    7.255762] usb usb7: udev 1, busnum 7, minor = 768
[    7.255764] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    7.255767] usb usb7: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    7.255769] usb usb7: Product: UHCI Host Controller
[    7.255770] usb usb7: Manufacturer: Linux 3.0.0-rc5-00063-g0d72c6f uhci_hcd
[    7.255772] usb usb7: SerialNumber: 0000:00:1d.1
[    7.263268] usb usb7: usb_probe_device
[    7.263272] usb usb7: configuration #1 chosen from 1 choice
[    7.263283] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    7.263420] hub 7-0:1.0: usb_probe_interface
[    7.263422] hub 7-0:1.0: usb_probe_interface - got id
[    7.263425] hub 7-0:1.0: USB hub found
[    7.263430] hub 7-0:1.0: 2 ports detected
[    7.263431] hub 7-0:1.0: standalone hub
[    7.263432] hub 7-0:1.0: no power switching (usb 1.0)
[    7.263434] hub 7-0:1.0: individual port over-current protection
[    7.263436] hub 7-0:1.0: power on to power good time: 2ms
[    7.263439] hub 7-0:1.0: local power source is good
[    7.263440] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    7.263500] drivers/usb/core/inode.c: creating file '001'
[    7.263544] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    7.263570] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[    7.263579] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    7.263582] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    7.263587] drivers/usb/core/inode.c: creating file '008'
[    7.263682] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus 
number 8
[    7.263691] uhci_hcd 0000:00:1d.2: detected 2 ports
[    7.263696] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    7.263698] uhci_hcd 0000:00:1d.2: Performing full reset
[    7.263722] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[    7.263761] usb usb8: default language 0x0409
[    7.263767] usb usb8: udev 1, busnum 8, minor = 896
[    7.263769] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    7.263771] usb usb8: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    7.263772] usb usb8: Product: UHCI Host Controller
[    7.263774] usb usb8: Manufacturer: Linux 3.0.0-rc5-00063-g0d72c6f uhci_hcd
[    7.263775] usb usb8: SerialNumber: 0000:00:1d.2
[    7.264388] usb usb8: usb_probe_device
[    7.264390] usb usb8: configuration #1 chosen from 1 choice
[    7.264396] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    7.264442] hub 8-0:1.0: usb_probe_interface
[    7.264444] hub 8-0:1.0: usb_probe_interface - got id
[    7.264446] hub 8-0:1.0: USB hub found
[    7.264449] hub 8-0:1.0: 2 ports detected
[    7.264451] hub 8-0:1.0: standalone hub
[    7.264452] hub 8-0:1.0: no power switching (usb 1.0)
[    7.264453] hub 8-0:1.0: individual port over-current protection
[    7.264455] hub 8-0:1.0: power on to power good time: 2ms
[    7.264458] hub 8-0:1.0: local power source is good
[    7.264459] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    7.264525] drivers/usb/core/inode.c: creating file '001'
[    7.264977] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    7.302029] hub 1-0:1.0: state 7 ports 6 chg 0052 evt 0000
[    7.302039] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    7.313470] uhci_hcd 0000:00:1a.0: port 1 portsc 0082,00
[    7.317291] iwlagn 0000:03:00.0: loaded firmware version 8.83.5.1 build 
33692
[    7.317667] Registered led device: phy0-led
[    7.331286] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[    7.348148] uhci_hcd 0000:00:1a.1: port 2 portsc 0082,00
[    7.348170] uhci_hcd 0000:00:1a.2: port 2 portsc 0082,00
[    7.352374] udevd[1440]: renamed network interface wlan0 to eth1
[    7.356262] ehci_hcd 0000:00:1a.7: port 1 full speed --> companion
[    7.356648] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 003801 0  ACK 
POWER OWNER sig=j CONNECT
[    7.356674] hub 1-0:1.0: port 1 not reset yet, waiting 50ms
[    7.367725] uhci_hcd 0000:00:1d.1: port 2 portsc 0082,00
[    7.416098] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 003002 0  ACK 
POWER OWNER sig=se0 CSC
[    7.416131] hub 1-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
[    7.472263] ehci_hcd 0000:00:1a.7: port 4 full speed --> companion
[    7.472268] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 003801 0  ACK 
POWER OWNER sig=j CONNECT
[    7.472272] hub 1-0:1.0: port 4 not reset yet, waiting 50ms
[    7.528056] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 003002 0  ACK 
POWER OWNER sig=se0 CSC
[    7.528078] hub 1-0:1.0: port 6, status 0501, change 0000, 480 Mb/s
[    7.584259] ehci_hcd 0000:00:1a.7: port 6 high speed
[    7.584263] ehci_hcd 0000:00:1a.7: GetStatus port:6 status 001005 0  ACK 
POWER sig=se0 PE CONNECT
[    7.624176] firewire_core: created device fw0: GUID 00061b032a347baa, S400
[    7.640056] usb 1-6: new high speed USB device number 4 using ehci_hcd
[    7.696260] ehci_hcd 0000:00:1a.7: port 6 high speed
[    7.696264] ehci_hcd 0000:00:1a.7: GetStatus port:6 status 001005 0  ACK 
POWER sig=se0 PE CONNECT
[    7.750156] Synaptics Touchpad, model: 1, fw: 7.0, id: 0x1c0b1, caps: 
0xd04791/0xb00000/0x20000
[    7.750161] serio: Synaptics pass-through port at isa0060/serio1/input0
[    7.779796] usb 1-6: skipped 1 descriptor after configuration
[    7.779799] usb 1-6: skipped 5 descriptors after interface
[    7.779802] usb 1-6: skipped 1 descriptor after endpoint
[    7.779804] usb 1-6: skipped 9 descriptors after interface
[    7.780168] usb 1-6: default language 0x0409
[    7.784041] usb 1-6: udev 4, busnum 1, minor = 3
[    7.784043] usb 1-6: New USB device found, idVendor=17ef, idProduct=1004
[    7.784045] usb 1-6: New USB device strings: Mfr=2, Product=1, 
SerialNumber=3
[    7.784047] usb 1-6: Product: Integrated Camera
[    7.784049] usb 1-6: Manufacturer: Chicony Electronics Co., Ltd.
[    7.784051] usb 1-6: SerialNumber: SN0001
[    7.784123] usb 1-6: usb_probe_device
[    7.784126] usb 1-6: configuration #1 chosen from 1 choice
[    7.784419] usb 1-6: adding 1-6:1.0 (config #1, interface 0)
[    7.785691] usb 1-6: adding 1-6:1.1 (config #1, interface 1)
[    7.785740] drivers/usb/core/inode.c: creating file '004'
[    7.785758] hub 2-0:1.0: state 7 ports 6 chg 0010 evt 0000
[    7.785765] hub 2-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
[    7.789822] Linux media interface: v0.10
[    7.794152] Linux video capture interface: v2.00
[    7.794856] input: SynPS/2 Synaptics TouchPad as 
/devices/platform/i8042/serio1/input/input11
[    7.797003] uvcvideo 1-6:1.0: usb_probe_interface
[    7.797006] uvcvideo 1-6:1.0: usb_probe_interface - got id
[    7.797028] uvcvideo: Found UVC 1.00 device Integrated Camera (17ef:1004)
[    7.833766] input: Integrated Camera as 
/devices/pci0000:00/0000:00:1a.7/usb1/1-6/1-6:1.0/input/input12
[    7.833831] usbcore: registered new interface driver uvcvideo
[    7.833833] USB Video Class driver (v1.1.0)
[    7.835196] usb 1-6: link qh4-0001/ffff880133fd5f00 start 1 [1/0 us]
[    7.835235] usb 1-6: unlink qh4-0001/ffff880133fd5f00 start 1 [1/0 us]
[    7.840293] ehci_hcd 0000:00:1d.7: port 4 high speed
[    7.840297] ehci_hcd 0000:00:1d.7: GetStatus port:4 status 001005 0  ACK 
POWER sig=se0 PE CONNECT
[    7.896068] usb 2-4: new high speed USB device number 2 using ehci_hcd
[    7.956293] ehci_hcd 0000:00:1d.7: port 4 high speed
[    7.956297] ehci_hcd 0000:00:1d.7: GetStatus port:4 status 001005 0  ACK 
POWER sig=se0 PE CONNECT
[    8.093838] usb 2-4: skipped 3 descriptors after interface
[    8.093842] usb 2-4: skipped 4 descriptors after interface
[    8.093845] usb 2-4: skipped 4 descriptors after interface
[    8.093847] usb 2-4: skipped 2 descriptors after interface
[    8.093850] usb 2-4: skipped 2 descriptors after interface
[    8.093852] usb 2-4: skipped 5 descriptors after interface
[    8.093855] usb 2-4: skipped 4 descriptors after interface
[    8.102586] usb 2-4: skipped 3 descriptors after interface
[    8.102588] usb 2-4: skipped 4 descriptors after interface
[    8.102590] usb 2-4: skipped 4 descriptors after interface
[    8.102593] usb 2-4: skipped 2 descriptors after interface
[    8.102595] usb 2-4: skipped 2 descriptors after interface
[    8.102598] usb 2-4: skipped 5 descriptors after interface
[    8.102701] usb 2-4: default language 0x0409
[    8.106833] usb 2-4: udev 2, busnum 2, minor = 129
[    8.106836] usb 2-4: New USB device found, idVendor=0bdb, idProduct=1900
[    8.106838] usb 2-4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[    8.106840] usb 2-4: Product: Ericsson F3507g Mobile Broadband Minicard 
Composite Device
[    8.106842] usb 2-4: Manufacturer: Ericsson
[    8.106844] usb 2-4: SerialNumber: 3541430228088360
[    8.106968] usb 2-4: usb_probe_device
[    8.106971] usb 2-4: configuration #1 chosen from 2 choices
[    8.109696] usb 2-4: adding 2-4:1.0 (config #1, interface 0)
[    8.109943] usb 2-4: adding 2-4:1.1 (config #1, interface 1)
[    8.129231] usb 2-4: adding 2-4:1.2 (config #1, interface 2)
[    8.131618] usb 2-4: adding 2-4:1.3 (config #1, interface 3)
[    8.133737] usb 2-4: adding 2-4:1.4 (config #1, interface 4)
[    8.135730] usb 2-4: adding 2-4:1.5 (config #1, interface 5)
[    8.137730] usb 2-4: adding 2-4:1.6 (config #1, interface 6)
[    8.139720] usb 2-4: adding 2-4:1.7 (config #1, interface 7)
[    8.141726] usb 2-4: adding 2-4:1.8 (config #1, interface 8)
[    8.143719] usb 2-4: adding 2-4:1.9 (config #1, interface 9)
[    8.145727] usb 2-4: adding 2-4:1.10 (config #1, interface 10)
[    8.147645] drivers/usb/core/inode.c: creating file '002'
[    8.147669] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    8.147675] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0010
[    8.147682] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    8.147686] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    8.147694] uhci_hcd 0000:00:1a.0: port 1 portsc 0093,00
[    8.147700] hub 3-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[    8.153997] cdc_wdm 2-4:1.5: usb_probe_interface
[    8.154001] cdc_wdm 2-4:1.5: usb_probe_interface - got id
[    8.154026] cdc_wdm 2-4:1.5: looking for a minor, starting at 0
[    8.154113] cdc_wdm 2-4:1.5: cdc-wdm-176: USB WDM device
[    8.154119] cdc_wdm 2-4:1.6: usb_probe_interface
[    8.154121] cdc_wdm 2-4:1.6: usb_probe_interface - got id
[    8.154125] cdc_wdm 2-4:1.6: looking for a minor, starting at 0
[    8.154161] cdc_wdm 2-4:1.6: cdc-wdm-175: USB WDM device
[    8.154176] usbcore: registered new interface driver cdc_wdm
[    8.156474] cdc_acm 2-4:1.1: usb_probe_interface
[    8.156477] cdc_acm 2-4:1.1: usb_probe_interface - got id
[    8.156594] cdc_acm 2-4:1.1: ttyACM0: USB ACM device
[    8.158130] cdc_acm 2-4:1.3: usb_probe_interface
[    8.158134] cdc_acm 2-4:1.3: usb_probe_interface - got id
[    8.158261] cdc_acm 2-4:1.3: ttyACM1: USB ACM device
[    8.158883] cdc_acm 2-4:1.9: usb_probe_interface
[    8.158886] cdc_acm 2-4:1.9: usb_probe_interface - got id
[    8.159005] cdc_acm 2-4:1.9: ttyACM2: USB ACM device
[    8.159365] usbcore: registered new interface driver cdc_acm
[    8.159367] cdc_acm: USB Abstract Control Model driver for USB modems and 
ISDN adapters
[    8.161865] cdc_ether 2-4:1.7: usb_probe_interface
[    8.161867] cdc_ether 2-4:1.7: usb_probe_interface - got id
[    8.165545] cdc_ether 2-4:1.7: wwan0: register 'cdc_ether' at 
usb-0000:00:1d.7-4, Mobile Broadband Network Device, 02:80:37:ec:02:00
[    8.165566] usbcore: registered new interface driver cdc_ether
[    8.166482] usbcore: registered new interface driver zaurus
[    8.272078] hub 3-0:1.0: debounce: port 1: total 100ms stable 100ms status 
0x101
[    8.336041] usb usb6: suspend_rh (auto-stop)
[    8.336068] usb usb8: suspend_rh (auto-stop)
[    8.384038] usb 3-1: new full speed USB device number 2 using uhci_hcd
[    8.516035] usb 3-1: ep0 maxpacket = 8
[    8.548712] usb 3-1: skipped 1 descriptor after interface
[    8.548715] usb 3-1: skipped 1 descriptor after interface
[    8.548717] usb 3-1: skipped 1 descriptor after interface
[    8.552689] usb 3-1: default language 0x0409
[    8.567688] usb 3-1: udev 2, busnum 3, minor = 257
[    8.567690] usb 3-1: New USB device found, idVendor=046d, idProduct=c52b
[    8.567693] usb 3-1: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[    8.567694] usb 3-1: Product: USB Receiver
[    8.567696] usb 3-1: Manufacturer: Logitech
[    8.567803] usb 3-1: usb_probe_device
[    8.567807] usb 3-1: configuration #1 chosen from 1 choice
[    8.572711] usb 3-1: adding 3-1:1.0 (config #1, interface 0)
[    8.572749] usb 3-1: adding 3-1:1.1 (config #1, interface 1)
[    8.572779] usb 3-1: adding 3-1:1.2 (config #1, interface 2)
[    8.572835] drivers/usb/core/inode.c: creating file '002'
[    8.572863] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    8.572872] uhci_hcd 0000:00:1a.1: port 2 portsc 0093,00
[    8.572879] hub 4-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[    8.580963] usbhid 3-1:1.0: usb_probe_interface
[    8.580966] usbhid 3-1:1.0: usb_probe_interface - got id
[    8.582908] input: Logitech USB Receiver as 
/devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.0/input/input13
[    8.582918] uhci_hcd 0000:00:1a.0: reserve dev 2 ep81-INT, period 8, phase 
4, 17 us
[    8.583044] generic-usb 0003:046D:C52B.0001: input,hidraw0: USB HID v1.11 
Keyboard [Logitech USB Receiver] on usb-0000:00:1a.0-1/input0
[    8.583051] usbhid 3-1:1.1: usb_probe_interface
[    8.583053] usbhid 3-1:1.1: usb_probe_interface - got id
[    8.584053] usb usb7: suspend_rh (auto-stop)
[    8.584059] usb usb5: suspend_rh (auto-stop)
[    8.586065] input: Logitech USB Receiver as 
/devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.1/input/input14
[    8.586070] uhci_hcd 0000:00:1a.0: reserve dev 2 ep82-INT, period 2, phase 
1, 17 us
[    8.586154] usbhid 3-1:1.1: looking for a minor, starting at 0
[    8.586235] generic-usb 0003:046D:C52B.0002: input,hiddev0,hidraw1: USB HID 
v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1a.0-1/input1
[    8.586242] usbhid 3-1:1.2: usb_probe_interface
[    8.586244] usbhid 3-1:1.2: usb_probe_interface - got id
[    8.591717] usbhid 3-1:1.2: looking for a minor, starting at 0
[    8.591791] generic-usb 0003:046D:C52B.0003: hiddev0,hidraw2: USB HID v1.11 
Device [Logitech USB Receiver] on usb-0000:00:1a.0-1/input2
[    8.591804] usbcore: registered new interface driver usbhid
[    8.591806] usbhid: USB HID core driver
[    8.704084] hub 4-0:1.0: debounce: port 2: total 100ms stable 100ms status 
0x101
[    8.817563] usb 4-2: new full speed USB device number 2 using uhci_hcd
[    8.972095] usb 4-2: skipped 1 descriptor after interface
[    8.975095] usb 4-2: default language 0x0409
[    8.986091] usb 4-2: udev 2, busnum 4, minor = 385
[    8.986093] usb 4-2: New USB device found, idVendor=0a5c, idProduct=2145
[    8.986095] usb 4-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[    8.986097] usb 4-2: Product: ThinkPad Bluetooth with Enhanced Data Rate II
[    8.986099] usb 4-2: Manufacturer: Lenovo Computer Corp
[    8.986206] usb 4-2: usb_probe_device
[    8.986210] usb 4-2: configuration #1 chosen from 1 choice
[    8.988097] usb 4-2: adding 4-2:1.0 (config #1, interface 0)
[    8.988149] usb 4-2: adding 4-2:1.1 (config #1, interface 1)
[    8.988188] usb 4-2: adding 4-2:1.2 (config #1, interface 2)
[    8.988227] usb 4-2: adding 4-2:1.3 (config #1, interface 3)
[    8.988294] drivers/usb/core/inode.c: creating file '002'
[    8.988315] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    8.988321] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    8.988325] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    9.000297] Bluetooth: Core ver 2.16
[    9.002074] NET: Registered protocol family 31
[    9.002076] Bluetooth: HCI device and connection manager initialized
[    9.002078] Bluetooth: HCI socket layer initialized
[    9.002080] Bluetooth: L2CAP socket layer initialized
[    9.003463] Bluetooth: SCO socket layer initialized
[    9.005897] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    9.005930] btusb 4-2:1.0: usb_probe_interface
[    9.005933] btusb 4-2:1.0: usb_probe_interface - got id
[    9.006103] btusb 4-2:1.2: usb_probe_interface
[    9.006105] btusb 4-2:1.2: usb_probe_interface - got id
[    9.006113] btusb 4-2:1.3: usb_probe_interface
[    9.006115] btusb 4-2:1.3: usb_probe_interface - got id
[    9.006127] uhci_hcd 0000:00:1a.1: reserve dev 2 ep81-INT, period 1, phase 
0, 23 us
[    9.006132] usbcore: registered new interface driver btusb
[    9.832049] usb 1-6: usb auto-suspend
[   10.031403] NET: Registered protocol family 10
[   10.178541] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[   10.232152] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[   10.233455] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   10.808105] hub 6-0:1.0: hub_suspend
[   10.808123] usb usb6: bus auto-suspend
[   10.808129] usb usb6: suspend_rh
[   10.808157] hub 8-0:1.0: hub_suspend
[   10.808166] usb usb8: bus auto-suspend
[   10.808171] usb usb8: suspend_rh
[   10.988082] hub 5-0:1.0: hub_suspend
[   10.988095] usb usb5: bus auto-suspend
[   10.988101] usb usb5: suspend_rh
[   10.988126] hub 7-0:1.0: hub_suspend
[   10.988135] usb usb7: bus auto-suspend
[   10.988140] usb usb7: suspend_rh
[   11.089108] uhci_hcd 0000:00:1a.1: release dev 2 ep81-INT, period 1, phase 
0, 23 us
[   11.848039] hub 1-0:1.0: hub_suspend
[   11.848055] usb usb1: bus auto-suspend
[   11.848061] ehci_hcd 0000:00:1a.7: suspend root hub
[   13.513923] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   13.753421] input: TPPS/2 IBM TrackPoint as 
/devices/platform/i8042/serio1/serio2/input/input15
[   14.334018] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   17.537999] eth1: authenticate with 00:27:19:d8:98:f2 (try 1)
[   17.541158] eth1: authenticated
[   17.558218] eth1: associate with 00:27:19:d8:98:f2 (try 1)
[   17.564325] eth1: RX AssocResp from 00:27:19:d8:98:f2 (capab=0x431 status=0 
aid=2)
[   17.564333] eth1: associated
[   17.582166] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   24.484769] ------------[ cut here ]------------
[   24.484777] WARNING: at kernel/printk.c:322 do_syslog+0x89/0x438()
[   24.484779] Hardware name: 2764CTO
[   24.484780] Attempt to access syslog with CAP_SYS_ADMIN but no CAP_SYSLOG 
(deprecated).
[   24.484782] Modules linked in: sch_sfq ipv6 ext2 mbcache md_mod 
acpi_cpufreq mperf btusb bluetooth crc16 usbhid hid zaurus cdc_ether usbnet 
mii cdc_acm cdc_wdm uvcvideo joydev videodev v4l2_compat_ioctl32 media arc4 
uhci_hcd snd_hda_codec_conexant sdhci_pci pcmcia firewire_ohci sdhci mmc_core 
firewire_core tpm_tis sg thinkpad_acpi sr_mod tpm crc_itu_t tpm_bios nvram 
cdrom ac battery iwlagn wmi psmouse serio_raw mac80211 evdev thermal 
yenta_socket pcmcia_rsrc pcmcia_core cfg80211 rfkill snd_hda_intel 
snd_hda_codec snd_hwdep snd_pcm pcspkr i2c_i801 processor snd_timer snd 
soundcore iTCO_wdt snd_page_alloc iTCO_vendor_support ehci_hcd e1000e usbcore 
xfs sd_mod crc_t10dif ahci libahci libata scsi_mod cbc cryptd aes_x86_64 
aes_generic dm_crypt dm_mod [last unloaded: scsi_wait_scan]
[   24.484840] Pid: 2705, comm: syslog-ng Not tainted 3.0.0-rc5-00063-g0d72c6f 
#7
[   24.484842] Call Trace:
[   24.484845]  [<ffffffff8103aa14>] warn_slowpath_common+0x7e/0x96
[   24.484848]  [<ffffffff8103aac0>] warn_slowpath_fmt+0x41/0x43
[   24.484851]  [<ffffffff81043da1>] ? ns_capable+0x35/0x4a
[   24.484854]  [<ffffffff8103b060>] do_syslog+0x89/0x438
[   24.484857]  [<ffffffff81103d9c>] ? _d_rehash+0x44/0x46
[   24.484860]  [<ffffffff81103dc4>] ? d_rehash+0x26/0x2b
[   24.484863]  [<ffffffff81143c6f>] kmsg_open+0x17/0x19
[   24.484866]  [<ffffffff8113afe4>] proc_reg_open+0xab/0x148
[   24.484869]  [<ffffffff81143c58>] ? kmsg_release+0x18/0x18
[   24.484871]  [<ffffffff81143c40>] ? seq_open_net+0x76/0x76
[   24.484874]  [<ffffffff8113af39>] ? proc_alloc_inode+0x9c/0x9c
[   24.484878]  [<ffffffff810f1372>] __dentry_open+0x1fb/0x312
[   24.484881]  [<ffffffff810fc9c3>] ? do_lookup+0x240/0x298
[   24.484883]  [<ffffffff810f2337>] nameidata_to_filp+0x5b/0x62
[   24.484886]  [<ffffffff810fe2d2>] do_last+0x5c4/0x725
[   24.484889]  [<ffffffff810fefa7>] path_openat+0xc3/0x368
[   24.484892]  [<ffffffff8108b7e3>] ? call_rcu+0x10/0x12
[   24.484894]  [<ffffffff810fc077>] ? putname+0x2d/0x36
[   24.484897]  [<ffffffff810ff27f>] do_filp_open+0x33/0x81
[   24.484900]  [<ffffffff811091ac>] ? alloc_fd+0x104/0x116
[   24.484903]  [<ffffffff810f243d>] do_sys_open+0xff/0x191
[   24.484906]  [<ffffffff810f24ea>] sys_open+0x1b/0x1d
[   24.484910]  [<ffffffff81405d3b>] system_call_fastpath+0x16/0x1b
[   24.484912] ---[ end trace fb9b2637d8efb238 ]---
[   24.514624] auditd (2717): /proc/2717/oom_adj is deprecated, please use 
/proc/2717/oom_score_adj instead.
[   24.934853] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   24.934856] Bluetooth: BNEP filters: protocol multicast
[   24.959369] Bluetooth: RFCOMM TTY layer initialized
[   24.959373] Bluetooth: RFCOMM socket layer initialized
[   24.959375] Bluetooth: RFCOMM ver 1.11
[   25.713397] uhci_hcd 0000:00:1a.1: reserve dev 2 ep81-INT, period 1, phase 
0, 23 us
[   26.484040] iwlagn 0000:03:00.0: iwlagn_tx_agg_start on ra = 
00:27:19:d8:98:f2 tid = 0
[   27.952073] eth1: no IPv6 routers present
[   35.782932] ata1.00: configured for UDMA/133
[   35.782935] ata1: EH complete
[   70.473024] PM: Syncing filesystems ... done.
[   71.182076] Freezing user space processes ... (elapsed 0.01 seconds) done.
[   71.196114] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) 
done.
[   71.212235] Suspending console(s) (use no_console_suspend to debug)
[   71.214368] usb 2-4: usb suspend
[   71.215664] uhci_hcd 0000:00:1a.0: release dev 2 ep82-INT, period 2, phase 
1, 17 us
[   71.216051] uhci_hcd 0000:00:1a.1: release dev 2 ep81-INT, period 1, phase 
0, 23 us
[   71.216636] uhci_hcd 0000:00:1a.0: release dev 2 ep81-INT, period 8, phase 
4, 17 us
[   71.218043] usb 4-2: usb suspend
[   71.218651] usb 3-1: usb suspend
[   71.373252] hub 4-0:1.0: hub_suspend
[   71.373263] usb usb4: bus suspend
[   71.373268] usb usb4: suspend_rh
[   71.373305] hub 3-0:1.0: hub_suspend
[   71.373313] usb usb3: bus suspend
[   71.373317] usb usb3: suspend_rh
[   71.373350] hub 2-0:1.0: hub_suspend
[   71.373357] usb usb2: bus suspend
[   71.373363] ehci_hcd 0000:00:1d.7: suspend root hub
[   71.373721] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   71.373793] sd 0:0:0:0: [sda] Stopping disk
[   71.457255] ACPI handle has no context!
[   71.457272] sdhci-pci 0000:15:00.2: PCI INT C disabled
[   71.457284] ACPI handle has no context!
[   71.457393] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[   71.457405] uhci_hcd 0000:00:1d.2: uhci_pci_suspend
[   71.457424] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[   71.457432] uhci_hcd 0000:00:1d.1: uhci_pci_suspend
[   71.457449] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[   71.457457] uhci_hcd 0000:00:1d.0: uhci_pci_suspend
[   71.457473] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[   71.457576] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[   71.457584] HDA Intel 0000:00:1b.0: PCI INT B disabled
[   71.457592] uhci_hcd 0000:00:1a.2: uhci_pci_suspend
[   71.457610] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[   71.457618] uhci_hcd 0000:00:1a.1: uhci_pci_suspend
[   71.457635] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[   71.457642] uhci_hcd 0000:00:1a.0: uhci_pci_suspend
[   71.457659] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[   71.464090] ACPI handle has no context!
[   71.472082] i915 0000:00:02.0: power state changed by ACPI to D3
[   71.552504] e1000e 0000:00:19.0: PCI INT A disabled
[   71.552518] e1000e 0000:00:19.0: PME# enabled
[   71.552535] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[   71.568091] PM: suspend of devices complete after 354.027 msecs
[   71.584201] ehci_hcd 0000:00:1d.7: wakeup: 0
[   71.600054] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[   71.600063] ehci_hcd 0000:00:1d.7: --> PCI D3hot
[   71.600111] uhci_hcd 0000:00:1d.2: wakeup: 0
[   71.600118] uhci_hcd 0000:00:1d.2: --> PCI D0
[   71.600165] uhci_hcd 0000:00:1d.1: wakeup: 0
[   71.600172] uhci_hcd 0000:00:1d.1: --> PCI D0
[   71.600218] uhci_hcd 0000:00:1d.0: wakeup: 0
[   71.600236] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[   71.600241] uhci_hcd 0000:00:1d.0: --> PCI D3hot
[   71.600300] ehci_hcd 0000:00:1a.7: wakeup: 0
[   71.616050] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[   71.616059] ehci_hcd 0000:00:1a.7: --> PCI D3hot
[   71.616106] uhci_hcd 0000:00:1a.2: wakeup: 0
[   71.616123] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D3
[   71.616129] uhci_hcd 0000:00:1a.2: --> PCI D3hot
[   71.616176] uhci_hcd 0000:00:1a.1: wakeup: 0
[   71.616182] uhci_hcd 0000:00:1a.1: --> PCI D0
[   71.616229] uhci_hcd 0000:00:1a.0: wakeup: 0
[   71.636057] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[   71.636063] uhci_hcd 0000:00:1a.0: --> PCI D3hot
[   71.636195] PM: late suspend of devices complete after 68.095 msecs
[   71.638253] ACPI: Preparing to enter system sleep state S3
[   71.796094] PM: Saving platform NVS memory
[   71.806249] Disabling non-boot CPUs ...
[   71.806696] Broke affinity for irq 9
[   71.806708] Broke affinity for irq 12
[   71.806727] Broke affinity for irq 17
[   71.967421] CPU 1 is now offline
[   71.968148] Extended CMOS year: 2000
[   71.968148] ACPI: Low-level resume complete
[   71.968148] PM: Restoring platform NVS memory
[   71.968148] Extended CMOS year: 2000
[   71.968148] Enabling non-boot CPUs ...
[   71.976326] Booting Node 0 Processor 1 APIC 0x1
[   71.976328] smpboot cpu 1: start_ip = 99000
[   71.807837] Disabled fast string operations
[   72.068121] Switched to NOHz mode on CPU #1
[   72.100754] CPU1 is up
[   72.102589] ACPI: Waking up from system sleep state S3
[   72.672227] i915 0000:00:02.0: restoring config space at offset 0x1 (was 
0x900007, writing 0x900407)
[   72.672285] pci 0000:00:02.1: restoring config space at offset 0x1 (was 
0x900000, writing 0x900007)
[   72.672312] pci 0000:00:03.0: restoring config space at offset 0xf (was 
0x100, writing 0x10b)
[   72.672338] pci 0000:00:03.0: restoring config space at offset 0x1 (was 
0x100006, writing 0x180006)
[   72.692056] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[   72.692066] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[   72.692113] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 
(was 0x2900005, writing 0x2900001)
[   72.692137] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[   72.692144] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[   72.692194] uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 
(was 0x2900005, writing 0x2900001)
[   72.692219] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[   72.692226] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[   72.692273] uhci_hcd 0000:00:1a.2: restoring config space at offset 0x1 
(was 0x2900005, writing 0x2900001)
[   72.692294] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[   72.692301] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[   72.692360] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 
(was 0x2900106, writing 0x2900102)
[   72.692392] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[   72.692402] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[   72.692466] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 
(was 0x100106, writing 0x100102)
[   72.692530] pcieport 0000:00:1c.0: restoring config space at offset 0x9 
(was 0x1fff1, writing 0xc051c041)
[   72.692542] pcieport 0000:00:1c.0: restoring config space at offset 0x8 
(was 0xfff0, writing 0xc030c020)
[   72.692553] pcieport 0000:00:1c.0: restoring config space at offset 0x7 
(was 0xf0, writing 0x9090)
[   72.692575] pcieport 0000:00:1c.0: restoring config space at offset 0x1 
(was 0x100107, writing 0x100507)
[   72.692667] pcieport 0000:00:1c.1: restoring config space at offset 0x9 
(was 0x1fff1, writing 0xc011c001)
[   72.692681] pcieport 0000:00:1c.1: restoring config space at offset 0x7 
(was 0x200000f0, writing 0x8080)
[   72.692703] pcieport 0000:00:1c.1: restoring config space at offset 0x1 
(was 0x100107, writing 0x100507)
[   72.692810] pcieport 0000:00:1c.3: restoring config space at offset 0x1 
(was 0x100107, writing 0x100507)
[   72.692917] pcieport 0000:00:1c.4: restoring config space at offset 0x1 
(was 0x100107, writing 0x100507)
[   72.692977] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   72.692984] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   72.693030] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 
(was 0x2900005, writing 0x2900001)
[   72.693052] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   72.693059] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   72.693108] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 
(was 0x2900005, writing 0x2900001)
[   72.693171] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 
(was 0x2900005, writing 0x2900001)
[   72.693244] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 
(was 0x2900106, writing 0x2900102)
[   72.693276] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[   72.693286] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[   72.693467] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 
0x2b00007, writing 0x2b00407)
[   72.708059] firewire_ohci 0000:15:00.1: BAR 0: set to [mem 
0xf4801000-0xf48017ff] (PCI address [0xf4801000-0xf48017ff])
[   72.708113] firewire_ohci 0000:15:00.1: restoring config space at offset 
0x3 (was 0x800000, writing 0x802010)
[   72.708128] firewire_ohci 0000:15:00.1: restoring config space at offset 
0x1 (was 0x2100000, writing 0x2100106)
[   72.724055] sdhci-pci 0000:15:00.2: BAR 0: set to [mem 
0xf4801800-0xf48018ff] (PCI address [0xf4801800-0xf48018ff])
[   72.724108] sdhci-pci 0000:15:00.2: restoring config space at offset 0x3 
(was 0x800000, writing 0x802010)
[   72.724123] sdhci-pci 0000:15:00.2: restoring config space at offset 0x1 
(was 0x2100000, writing 0x2100106)
[   72.725120] PM: early resume of devices complete after 53.043 msecs
[   72.725317] i915 0000:00:02.0: power state changed by ACPI to D0
[   72.725329] i915 0000:00:02.0: power state changed by ACPI to D0
[   72.725385] i915 0000:00:02.0: setting latency timer to 64
[   72.725689] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[   72.725700] e1000e 0000:00:19.0: PME# disabled
[   72.725820] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[   72.727986] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[   72.727994] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[   72.728035] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 
20
[   72.728048] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[   72.728057] uhci_hcd 0000:00:1a.0: uhci_pci_resume
[   72.728065] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x2f00
[   72.728071] uhci_hcd 0000:00:1a.0: Performing full reset
[   72.728103] usb usb3: root hub lost power or was reset
[   72.728129] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 
21
[   72.728141] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[   72.728149] uhci_hcd 0000:00:1a.1: uhci_pci_resume
[   72.728156] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x2000
[   72.728162] uhci_hcd 0000:00:1a.1: Performing full reset
[   72.728192] usb usb4: root hub lost power or was reset
[   72.728211] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[   72.728218] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[   72.728228] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 
22
[   72.728240] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[   72.728248] uhci_hcd 0000:00:1a.2: uhci_pci_resume
[   72.728255] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x2000
[   72.728260] uhci_hcd 0000:00:1a.2: Performing full reset
[   72.728290] usb usb5: root hub lost power or was reset
[   72.728312] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[   72.728322] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[   72.728335] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 
23
[   72.728347] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[   72.728437] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 
17
[   72.728454] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   72.728518] HDA Intel 0000:00:1b.0: irq 48 for MSI/MSI-X
[   72.728621] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   72.728628] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   72.728639] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 
16
[   72.728651] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   72.728659] uhci_hcd 0000:00:1d.0: uhci_pci_resume
[   72.728666] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x2f00
[   72.728672] uhci_hcd 0000:00:1d.0: Performing full reset
[   72.728702] usb usb6: root hub lost power or was reset
[   72.728724] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 
17
[   72.728736] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   72.728743] uhci_hcd 0000:00:1d.1: uhci_pci_resume
[   72.728751] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x2000
[   72.728756] uhci_hcd 0000:00:1d.1: Performing full reset
[   72.728786] usb usb7: root hub lost power or was reset
[   72.728807] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[   72.728820] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   72.728827] uhci_hcd 0000:00:1d.2: uhci_pci_resume
[   72.728835] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x2000
[   72.728840] uhci_hcd 0000:00:1d.2: Performing full reset
[   72.728870] usb usb8: root hub lost power or was reset
[   72.728891] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[   72.728901] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[   72.728914] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 
19
[   72.728926] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   72.729008] pci 0000:00:1e.0: setting latency timer to 64
[   72.729036] ahci 0000:00:1f.2: setting latency timer to 64
[   72.729151] sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[   72.729159] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW 
doesn't fully claim to support it.
[   72.730227] sd 0:0:0:0: [sda] Starting disk
[   72.730330] usb usb1: usb resume
[   72.730338] ehci_hcd 0000:00:1a.7: resume root hub
[   72.730466] usb usb2: usb resume
[   72.730472] ehci_hcd 0000:00:1d.7: resume root hub
[   72.730580] usb usb3: usb resume
[   72.730582] usb usb3: wakeup_rh
[   72.730663] usb usb4: usb resume
[   72.730664] usb usb4: wakeup_rh
[   72.730742] usb usb5: usb resume
[   72.730743] usb usb5: wakeup_rh
[   72.730825] usb usb6: usb resume
[   72.730826] usb usb6: wakeup_rh
[   72.730895] usb usb7: usb resume
[   72.730896] usb usb7: wakeup_rh
[   72.730976] usb usb8: usb resume
[   72.730978] usb usb8: wakeup_rh
[   72.744069] hub 3-0:1.0: hub_reset_resume
[   72.744077] hub 3-0:1.0: trying to enable port power on non-switchable hub
[   72.744097] hub 4-0:1.0: hub_reset_resume
[   72.744103] hub 4-0:1.0: trying to enable port power on non-switchable hub
[   72.744115] hub 5-0:1.0: hub_reset_resume
[   72.744120] hub 5-0:1.0: trying to enable port power on non-switchable hub
[   72.744133] hub 6-0:1.0: hub_reset_resume
[   72.744138] hub 6-0:1.0: trying to enable port power on non-switchable hub
[   72.744150] hub 7-0:1.0: hub_reset_resume
[   72.744155] hub 7-0:1.0: trying to enable port power on non-switchable hub
[   72.744168] hub 8-0:1.0: hub_reset_resume
[   72.744174] hub 8-0:1.0: trying to enable port power on non-switchable hub
[   72.744877] legacy_resume(): pnp_bus_resume+0x0/0x67 returns -19
[   72.744879] PM: Device 00:0a failed to resume: error -19
[   72.756043] hub 2-0:1.0: hub_resume
[   72.756057] ehci_hcd 0000:00:1d.7: GetStatus port:4 status 001002 0  ACK 
POWER sig=se0 CSC
[   72.756060] hub 2-0:1.0: port 4: status 0100 change 0001
[   72.784150] firewire_core: skipped bus generations, destroying all nodes
[   72.826917] Extended CMOS year: 2000
[   72.848107] uhci_hcd 0000:00:1a.0: port 1 portsc 008a,00
[   72.848117] hub 3-0:1.0: port 1: status 0100 change 0003
[   72.848160] uhci_hcd 0000:00:1a.1: port 2 portsc 008a,00
[   72.848167] hub 4-0:1.0: port 2: status 0100 change 0003
[   72.860143] hub 2-0:1.0: port 4 status 0000.0100 after resume, -19
[   72.860149] usb 2-4: can't resume, status -19
[   72.860154] hub 2-0:1.0: logical disconnect on port 4
[   72.860314] ehci_hcd 0000:00:1a.7: port 4 full speed --> companion
[   72.860327] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 003801 0  ACK 
POWER OWNER sig=j CONNECT
[   72.860567] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001800 0  ACK 
POWER sig=j
[   72.860575] ehci_hcd 0000:00:1a.7: failed handover port 1: 1800
[   72.876091] hub 1-0:1.0: hub_resume
[   72.876106] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001803 0  ACK 
POWER sig=j CSC CONNECT
[   72.876116] hub 1-0:1.0: port 1: status 0501 change 0001
[   72.876142] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 003002 0  ACK 
POWER OWNER sig=se0 CSC
[   72.876165] ehci_hcd 0000:00:1a.7: GetStatus port:6 status 001803 0  ACK 
POWER sig=j CSC CONNECT
[   72.876173] hub 1-0:1.0: port 6: status 0501 change 0001
[   72.980142] usb 1-6: finish reset-resume
[   72.980176] hub 3-0:1.0: port 1 status 0000.0100 after resume, -19
[   72.980186] uhci_hcd 0000:00:1a.1: port 2 portsc 0093,00
[   72.980193] usb 3-1: can't resume, status -19
[   72.980198] hub 3-0:1.0: logical disconnect on port 1
[   72.980205] usb 4-2: finish reset-resume
[   73.036277] ehci_hcd 0000:00:1a.7: port 6 high speed
[   73.036289] ehci_hcd 0000:00:1a.7: GetStatus port:6 status 001005 0  ACK 
POWER sig=se0 PE CONNECT
[   73.048114] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   73.051002] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[   73.052064] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[   73.052074] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[   73.052106] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   73.056601] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[   73.057679] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[   73.057688] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[   73.058699] ata2.00: configured for UDMA/100
[   73.092084] usb 1-6: reset high speed USB device number 4 using ehci_hcd
[   73.148333] ehci_hcd 0000:00:1a.7: port 6 high speed
[   73.148346] ehci_hcd 0000:00:1a.7: GetStatus port:6 status 001005 0  ACK 
POWER sig=se0 PE CONNECT
[   73.284116] firewire_core: rediscovered device fw0
[   73.336109] usb 4-2: reset full speed USB device number 2 using uhci_hcd
[   73.365888] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[   73.365898] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) 
filtered out
[   73.365907] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[   73.487102] btusb 4-2:1.0: no reset_resume for driver btusb?
[   73.487110] btusb 4-2:1.1: no reset_resume for driver btusb?
[   73.487116] btusb 4-2:1.0: forced unbind
[   73.506115] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[   73.506124] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) 
filtered out
[   73.506133] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[   73.566128] ata1.00: configured for UDMA/133
[   73.614324] thinkpad_acpi: restoring fan level to 0x07
[   73.807331] PM: resume of devices complete after 1082.079 msecs
[   73.807378] btusb 4-2:1.0: usb_probe_interface
[   73.807384] btusb 4-2:1.0: usb_probe_interface - got id
[   73.808033] usb usb6: suspend_rh (auto-stop)
[   73.808067] usb usb8: suspend_rh (auto-stop)
[   73.808098] usb usb5: suspend_rh (auto-stop)
[   73.808128] usb usb7: suspend_rh (auto-stop)
[   73.808645] Restarting tasks ... 
[   73.809723] uhci_hcd 0000:00:1a.1: reserve dev 2 ep81-INT, period 1, phase 
0, 23 us
[   73.809794] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   73.809810] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   73.809820] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   73.809830] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   73.809840] hub 2-0:1.0: state 7 ports 6 chg 0010 evt 0000
[   73.809856] hub 2-0:1.0: port 4, status 0100, change 0000, 12 Mb/s
[   73.809863] usb 2-4: USB disconnect, device number 2
[   73.809868] usb 2-4: unregistering device
[   73.809874] usb 2-4: unregistering interface 2-4:1.0
[   73.809956] usb 2-4: unregistering interface 2-4:1.1
[   73.810598] usb 2-4: unregistering interface 2-4:1.2
[   73.810692] usb 2-4: unregistering interface 2-4:1.3
[   73.811085] usb 2-4: unregistering interface 2-4:1.4
[   73.811180] usb 2-4: unregistering interface 2-4:1.5
[   73.811231] drivers/usb/core/file.c: removing 0 minor
[   73.811364] usb 2-4: unregistering interface 2-4:1.6
[   73.811412] drivers/usb/core/file.c: removing 1 minor
[   73.811538] usb 2-4: unregistering interface 2-4:1.7
[   73.811594] cdc_ether 2-4:1.7: wwan0: unregister 'cdc_ether' 
usb-0000:00:1d.7-4, Mobile Broadband Network Device
[   73.823457] done.
[   73.823470] video LNXVIDEO:00: Restoring backlight state
[   74.056070] usb usb3: suspend_rh (auto-stop)
[   75.808106] hub 5-0:1.0: hub_suspend
[   75.808119] usb usb5: bus auto-suspend
[   75.808122] usb usb5: suspend_rh
[   75.808415] hub 6-0:1.0: hub_suspend
[   75.808420] usb usb6: bus auto-suspend
[   75.808423] usb usb6: suspend_rh
[   75.808442] hub 7-0:1.0: hub_suspend
[   75.808446] usb usb7: bus auto-suspend
[   75.808448] usb usb7: suspend_rh
[   75.808466] hub 8-0:1.0: hub_suspend
[   75.808471] usb usb8: bus auto-suspend
[   75.808473] usb usb8: suspend_rh


> 
> Alan Stern


-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
