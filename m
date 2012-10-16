Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab2JPQf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 12:35:29 -0400
Received: from fep13.mx.upcmail.net ([62.179.121.33]:61021 "EHLO
	fep13.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab2JPQfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 12:35:22 -0400
X-SourceIP: 178.83.228.246
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <507D8CC1.5070204@odi.ch>
Date: Tue, 16 Oct 2012 18:35:13 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [BUG] 3.7-rc1: nouveau: NULL pointer dereference at nouveau_channel_new
Content-Type: multipart/mixed;
 boundary="------------010403040801030602060608"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010403040801030602060608
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This is a regression towards 3.6. Occurs when starting X.

I had already reported this before -rc1, but nobody listened.


--------------010403040801030602060608
Content-Type: text/plain; charset=UTF-8;
 name="messages"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="messages"

Oct 16 18:27:04 localhost kernel: Initializing cgroup subsys cpu
Oct 16 18:27:04 localhost kernel: Linux version 3.7.0-rc1 (root@ortwin-hp) (gcc version 4.5.4 (Gentoo 4.5.4 p1.0, pie-0.4.7) ) #1 SMP PREEMPT Tue Oct 16 18:24:16 CEST 2012
Oct 16 18:27:04 localhost kernel: Command line: root=/dev/sda1 rootfstype=ext4 nouveau.noaccel=1
Oct 16 18:27:04 localhost kernel: e820: BIOS-provided physical RAM map:
Oct 16 18:27:04 localhost kernel: BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
Oct 16 18:27:04 localhost kernel: BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
Oct 16 18:27:04 localhost kernel: BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
Oct 16 18:27:04 localhost kernel: BIOS-e820: [mem 0x0000000000100000-0x00000000befc1fff] usable
Oct 16 18:27:04 localhost kernel: BIOS-e820: [mem 0x00000000befc2000-0x00000000bf6c1fff] reserved
Oct 16 18:27:04 localhost kernel: BIOS-e820: [mem 0x00000000bf6c2000-0x00000000bf7c1fff] ACPI NVS
Oct 16 18:27:04 localhost kernel: BIOS-e820: [mem 0x00000000bf7c2000-0x00000000bf7fefff] ACPI data
Oct 16 18:27:04 localhost kernel: BIOS-e820: [mem 0x00000000bf7ff000-0x00000000bf7fffff] usable
Oct 16 18:27:04 localhost kernel: BIOS-e820: [mem 0x00000000bf800000-0x00000000bfffffff] reserved
Oct 16 18:27:04 localhost kernel: BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
Oct 16 18:27:04 localhost kernel: BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
Oct 16 18:27:04 localhost kernel: BIOS-e820: [mem 0x00000000fed10000-0x00000000fed13fff] reserved
Oct 16 18:27:04 localhost kernel: BIOS-e820: [mem 0x00000000fed19000-0x00000000fed19fff] reserved
Oct 16 18:27:04 localhost kernel: BIOS-e820: [mem 0x00000000fed1b000-0x00000000fed1ffff] reserved
Oct 16 18:27:04 localhost kernel: BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
Oct 16 18:27:04 localhost kernel: BIOS-e820: [mem 0x00000000ffd00000-0x00000000ffffffff] reserved
Oct 16 18:27:04 localhost kernel: BIOS-e820: [mem 0x0000000100000000-0x00000001fbffffff] usable
Oct 16 18:27:04 localhost kernel: BIOS-e820: [mem 0x00000001fc000000-0x00000001ffffffff] reserved
Oct 16 18:27:04 localhost kernel: BIOS-e820: [mem 0x0000000200000000-0x000000023bffffff] usable
Oct 16 18:27:04 localhost kernel: NX (Execute Disable) protection: active
Oct 16 18:27:04 localhost kernel: DMI 2.6 present.
Oct 16 18:27:04 localhost kernel: DMI: Hewlett-Packard HP EliteBook 8540w/1521, BIOS 68CVD Ver. F.0E 11/25/2010
Oct 16 18:27:04 localhost kernel: e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
Oct 16 18:27:04 localhost kernel: e820: remove [mem 0x000a0000-0x000fffff] usable
Oct 16 18:27:04 localhost kernel: No AGP bridge found
Oct 16 18:27:04 localhost kernel: e820: last_pfn = 0x23c000 max_arch_pfn = 0x400000000
Oct 16 18:27:04 localhost kernel: MTRR default type: uncachable
Oct 16 18:27:04 localhost kernel: MTRR fixed ranges enabled:
Oct 16 18:27:04 localhost kernel: 00000-9FFFF write-back
Oct 16 18:27:04 localhost kernel: A0000-BFFFF uncachable
Oct 16 18:27:04 localhost kernel: C0000-FFFFF write-protect
Oct 16 18:27:04 localhost kernel: MTRR variable ranges enabled:
Oct 16 18:27:04 localhost kernel: 0 base 0FFC00000 mask FFFC00000 write-protect
Oct 16 18:27:04 localhost kernel: 1 base 000000000 mask F80000000 write-back
Oct 16 18:27:04 localhost kernel: 2 base 080000000 mask FC0000000 write-back
Oct 16 18:27:04 localhost kernel: 3 base 100000000 mask F00000000 write-back
Oct 16 18:27:04 localhost kernel: 4 base 200000000 mask FC0000000 write-back
Oct 16 18:27:04 localhost kernel: 5 base 23C000000 mask FFC000000 uncachable
Oct 16 18:27:04 localhost kernel: 6 disabled
Oct 16 18:27:04 localhost kernel: 7 disabled
Oct 16 18:27:04 localhost kernel: x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Oct 16 18:27:04 localhost kernel: e820: last_pfn = 0xbf800 max_arch_pfn = 0x400000000
Oct 16 18:27:04 localhost kernel: initial memory mapped: [mem 0x00000000-0x1fffffff]
Oct 16 18:27:04 localhost kernel: Base memory trampoline at [ffff880000099000] 99000 size 24576
Oct 16 18:27:04 localhost kernel: init_memory_mapping: [mem 0x00000000-0xbf7fffff]
Oct 16 18:27:04 localhost kernel: [mem 0x00000000-0xbf7fffff] page 2M
Oct 16 18:27:04 localhost kernel: kernel direct mapping tables up to 0xbf7fffff @ [mem 0x1fa00000-0x1fffffff]
Oct 16 18:27:04 localhost kernel: init_memory_mapping: [mem 0x100000000-0x23bffffff]
Oct 16 18:27:04 localhost kernel: [mem 0x100000000-0x23bffffff] page 2M
Oct 16 18:27:04 localhost kernel: kernel direct mapping tables up to 0x23bffffff @ [mem 0xbefb8000-0xbefc1fff]
Oct 16 18:27:04 localhost kernel: ACPI: RSDP 00000000000fddc0 00024 (v02 HPQOEM)
Oct 16 18:27:04 localhost kernel: ACPI: XSDT 00000000bf7fe120 00094 (v01 HPQOEM SLIC-MPC 0000000F      01000013)
Oct 16 18:27:04 localhost kernel: ACPI: FACP 00000000bf7fc000 000F4 (v03 HPQOEM 1521     0000000F HP   00000001)
Oct 16 18:27:04 localhost kernel: ACPI: DSDT 00000000bf7da000 1C77F (v02 HPQOEM 1521     00000001 INTL 20060912)
Oct 16 18:27:04 localhost kernel: ACPI: FACS 00000000bf760000 00040
Oct 16 18:27:04 localhost kernel: ACPI: HPET 00000000bf7fb000 00038 (v01 HPQOEM 1521     00000001 HP   00000001)
Oct 16 18:27:04 localhost kernel: ACPI: APIC 00000000bf7fa000 000BC (v01 HPQOEM 1521     00000001 HP   00000001)
Oct 16 18:27:04 localhost kernel: ACPI: MCFG 00000000bf7f9000 0003C (v01 HPQOEM 1521     00000001 HP   00000001)
Oct 16 18:27:04 localhost kernel: ACPI: TCPA 00000000bf7f7000 00032 (v02 HPQOEM 1521     00000000 HP   00000001)
Oct 16 18:27:04 localhost kernel: ACPI: SSDT 00000000bf7d7000 00135 (v01 HPQOEM SataAhci 00001000 INTL 20060912)
Oct 16 18:27:04 localhost kernel: ACPI: SSDT 00000000bf7d6000 00314 (v01 HPQOEM PtidDevc 00001000 INTL 20060912)
Oct 16 18:27:04 localhost kernel: ACPI: SLIC 00000000bf7d5000 00176 (v01 HPQOEM SLIC-MPC 00000001 HP   00000001)
Oct 16 18:27:04 localhost kernel: ACPI: SSDT 00000000bf7d1000 02576 (v01 HPQOEM NVIDIAGF 00000001 INTL 20060912)
Oct 16 18:27:04 localhost kernel: ACPI: DMAR 00000000bf7d0000 00080 (v01 INTEL  CP_DALE  00000001 INTL 00000001)
Oct 16 18:27:04 localhost kernel: ACPI: SSDT 00000000bf7cf000 00A10 (v01  PmRef    CpuPm 00003000 INTL 20060912)
Oct 16 18:27:04 localhost kernel: ACPI: SSDT 00000000bf7ce000 00288 (v01  PmRef  Cpu0Tst 00003000 INTL 20060912)
Oct 16 18:27:04 localhost kernel: ACPI: SSDT 00000000bf7cd000 00225 (v01  PmRef    ApTst 00003000 INTL 20060912)
Oct 16 18:27:04 localhost kernel: ACPI: ASF! 00000000bf7f8000 000A0 (v32 HPQOEM 1521     00000001 HP   00000001)
Oct 16 18:27:04 localhost kernel: ACPI: Local APIC address 0xfee00000
Oct 16 18:27:04 localhost kernel: No NUMA configuration found
Oct 16 18:27:04 localhost kernel: Faking a node at [mem 0x0000000000000000-0x000000023bffffff]
Oct 16 18:27:04 localhost kernel: Initmem setup node 0 [mem 0x00000000-0x23bffffff]
Oct 16 18:27:04 localhost kernel: NODE_DATA [mem 0x23bffc000-0x23bffffff]
Oct 16 18:27:04 localhost kernel: [ffffea0000000000-ffffea0008ffffff] PMD -> [ffff880233600000-ffff88023b5fffff] on node 0
Oct 16 18:27:04 localhost kernel: Zone ranges:
Oct 16 18:27:04 localhost kernel: DMA      [mem 0x00010000-0x00ffffff]
Oct 16 18:27:04 localhost kernel: DMA32    [mem 0x01000000-0xffffffff]
Oct 16 18:27:04 localhost kernel: Normal   [mem 0x100000000-0x23bffffff]
Oct 16 18:27:04 localhost kernel: Movable zone start for each node
Oct 16 18:27:04 localhost kernel: Early memory node ranges
Oct 16 18:27:04 localhost kernel: node   0: [mem 0x00010000-0x0009efff]
Oct 16 18:27:04 localhost kernel: node   0: [mem 0x00100000-0xbefc1fff]
Oct 16 18:27:04 localhost kernel: node   0: [mem 0xbf7ff000-0xbf7fffff]
Oct 16 18:27:04 localhost kernel: node   0: [mem 0x100000000-0x1fbffffff]
Oct 16 18:27:04 localhost kernel: node   0: [mem 0x200000000-0x23bffffff]
Oct 16 18:27:04 localhost kernel: On node 0 totalpages: 2060114
Oct 16 18:27:04 localhost kernel: DMA zone: 64 pages used for memmap
Oct 16 18:27:04 localhost kernel: DMA zone: 6 pages reserved
Oct 16 18:27:04 localhost kernel: DMA zone: 3913 pages, LIFO batch:0
Oct 16 18:27:04 localhost kernel: DMA32 zone: 16320 pages used for memmap
Oct 16 18:27:04 localhost kernel: DMA32 zone: 761859 pages, LIFO batch:31
Oct 16 18:27:04 localhost kernel: Normal zone: 20224 pages used for memmap
Oct 16 18:27:04 localhost kernel: Normal zone: 1257728 pages, LIFO batch:31
Oct 16 18:27:04 localhost kernel: ACPI: PM-Timer IO Port: 0x408
Oct 16 18:27:04 localhost kernel: ACPI: Local APIC address 0xfee00000
Oct 16 18:27:04 localhost kernel: ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Oct 16 18:27:04 localhost kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Oct 16 18:27:04 localhost kernel: ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
Oct 16 18:27:04 localhost kernel: ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
Oct 16 18:27:04 localhost kernel: ACPI: LAPIC (acpi_id[0x04] lapic_id[0x00] disabled)
Oct 16 18:27:04 localhost kernel: ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
Oct 16 18:27:04 localhost kernel: ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
Oct 16 18:27:04 localhost kernel: ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
Oct 16 18:27:04 localhost kernel: ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
Oct 16 18:27:04 localhost kernel: ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
Oct 16 18:27:04 localhost kernel: ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
Oct 16 18:27:04 localhost kernel: ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
Oct 16 18:27:04 localhost kernel: ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
Oct 16 18:27:04 localhost kernel: ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
Oct 16 18:27:04 localhost kernel: ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
Oct 16 18:27:04 localhost kernel: ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
Oct 16 18:27:04 localhost kernel: ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
Oct 16 18:27:04 localhost kernel: IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
Oct 16 18:27:04 localhost kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Oct 16 18:27:04 localhost kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Oct 16 18:27:04 localhost kernel: ACPI: IRQ0 used by override.
Oct 16 18:27:04 localhost kernel: ACPI: IRQ2 used by override.
Oct 16 18:27:04 localhost kernel: ACPI: IRQ9 used by override.
Oct 16 18:27:04 localhost kernel: Using ACPI (MADT) for SMP configuration information
Oct 16 18:27:04 localhost kernel: ACPI: HPET id: 0x8086a201 base: 0xfed00000
Oct 16 18:27:04 localhost kernel: smpboot: Allowing 8 CPUs, 4 hotplug CPUs
Oct 16 18:27:04 localhost kernel: nr_irqs_gsi: 40
Oct 16 18:27:04 localhost kernel: e820: [mem 0xc0000000-0xdfffffff] available for PCI devices
Oct 16 18:27:04 localhost kernel: setup_percpu: NR_CPUS:16 nr_cpumask_bits:16 nr_cpu_ids:8 nr_node_ids:1
Oct 16 18:27:04 localhost kernel: PERCPU: Embedded 27 pages/cpu @ffff88023bc00000 s78848 r8192 d23552 u262144
Oct 16 18:27:04 localhost kernel: pcpu-alloc: s78848 r8192 d23552 u262144 alloc=1*2097152
Oct 16 18:27:04 localhost kernel: pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
Oct 16 18:27:04 localhost kernel: Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2023500
Oct 16 18:27:04 localhost kernel: Policy zone: Normal
Oct 16 18:27:04 localhost kernel: Kernel command line: root=/dev/sda1 rootfstype=ext4 nouveau.noaccel=1
Oct 16 18:27:04 localhost kernel: PID hash table entries: 4096 (order: 3, 32768 bytes)
Oct 16 18:27:04 localhost kernel: __ex_table already sorted, skipping sort
Oct 16 18:27:04 localhost kernel: Checking aperture...
Oct 16 18:27:04 localhost kernel: No AGP bridge found
Oct 16 18:27:04 localhost kernel: Memory: 8028484k/9371648k available (8620k kernel code, 1131192k absent, 211972k reserved, 3433k data, 836k init)
Oct 16 18:27:04 localhost kernel: SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
Oct 16 18:27:04 localhost kernel: Preemptible hierarchical RCU implementation.
Oct 16 18:27:04 localhost kernel: 	Dump stacks of tasks blocking RCU-preempt GP.
Oct 16 18:27:04 localhost kernel: 	RCU restricting CPUs from NR_CPUS=16 to nr_cpu_ids=8.
Oct 16 18:27:04 localhost kernel: NR_IRQS:4352 nr_irqs:744 16
Oct 16 18:27:04 localhost kernel: Extended CMOS year: 2000
Oct 16 18:27:04 localhost kernel: Console: colour VGA+ 80x25
Oct 16 18:27:04 localhost kernel: console [tty0] enabled
Oct 16 18:27:04 localhost kernel: hpet clockevent registered
Oct 16 18:27:04 localhost kernel: tsc: Fast TSC calibration failed
Oct 16 18:27:04 localhost kernel: tsc: PIT calibration matches HPET. 1 loops
Oct 16 18:27:04 localhost kernel: tsc: Detected 2660.542 MHz processor
Oct 16 18:27:04 localhost kernel: Calibrating delay loop (skipped), value calculated using timer frequency.. 5321.08 BogoMIPS (lpj=10642168)
Oct 16 18:27:04 localhost kernel: pid_max: default: 32768 minimum: 301
Oct 16 18:27:04 localhost kernel: Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Oct 16 18:27:04 localhost kernel: Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Oct 16 18:27:04 localhost kernel: Mount-cache hash table entries: 256
Oct 16 18:27:04 localhost kernel: CPU: Physical Processor ID: 0
Oct 16 18:27:04 localhost kernel: CPU: Processor Core ID: 0
Oct 16 18:27:04 localhost kernel: mce: CPU supports 9 MCE banks
Oct 16 18:27:04 localhost kernel: CPU0: Thermal monitoring enabled (TM1)
Oct 16 18:27:04 localhost kernel: process: using mwait in idle threads
Oct 16 18:27:04 localhost kernel: Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
Oct 16 18:27:04 localhost kernel: Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
Oct 16 18:27:04 localhost kernel: tlb_flushall_shift: 6
Oct 16 18:27:04 localhost kernel: Freeing SMP alternatives: 28k freed
Oct 16 18:27:04 localhost kernel: ACPI: Core revision 20120913
Oct 16 18:27:04 localhost kernel: ftrace: allocating 30316 entries in 119 pages
Oct 16 18:27:04 localhost kernel: ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Oct 16 18:27:04 localhost kernel: smpboot: CPU0: Intel(R) Core(TM) i7 CPU       M 620  @ 2.67GHz (fam: 06, model: 25, stepping: 05)
Oct 16 18:27:04 localhost kernel: Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
Oct 16 18:27:04 localhost kernel: perf_event_intel: CPUID marked event: 'bus cycles' unavailable
Oct 16 18:27:04 localhost kernel: ... version:                3
Oct 16 18:27:04 localhost kernel: ... bit width:              48
Oct 16 18:27:04 localhost kernel: ... generic registers:      4
Oct 16 18:27:04 localhost kernel: ... value mask:             0000ffffffffffff
Oct 16 18:27:04 localhost kernel: ... max period:             000000007fffffff
Oct 16 18:27:04 localhost kernel: ... fixed-purpose events:   3
Oct 16 18:27:04 localhost kernel: ... event mask:             000000070000000f
Oct 16 18:27:04 localhost kernel: smpboot: Booting Node   0, Processors  #1 #2 #3
Oct 16 18:27:04 localhost kernel: Brought up 4 CPUs
Oct 16 18:27:04 localhost kernel: smpboot: Total of 4 processors activated (21284.33 BogoMIPS)
Oct 16 18:27:04 localhost kernel: devtmpfs: initialized
Oct 16 18:27:04 localhost kernel: PM: Registering ACPI NVS region [mem 0xbf6c2000-0xbf7c1fff] (1048576 bytes)
Oct 16 18:27:04 localhost kernel: NET: Registered protocol family 16
Oct 16 18:27:04 localhost kernel: ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
Oct 16 18:27:04 localhost kernel: ACPI: bus type pci registered
Oct 16 18:27:04 localhost kernel: dca service started, version 1.12.1
Oct 16 18:27:04 localhost kernel: PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
Oct 16 18:27:04 localhost kernel: PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
Oct 16 18:27:04 localhost kernel: PCI: Using configuration type 1 for base access
Oct 16 18:27:04 localhost kernel: bio: create slab <bio-0> at 0
Oct 16 18:27:04 localhost kernel: ACPI: Added _OSI(Module Device)
Oct 16 18:27:04 localhost kernel: ACPI: Added _OSI(Processor Device)
Oct 16 18:27:04 localhost kernel: ACPI: Added _OSI(3.0 _SCP Extensions)
Oct 16 18:27:04 localhost kernel: ACPI: Added _OSI(Processor Aggregator Device)
Oct 16 18:27:04 localhost kernel: ACPI: EC: Look up EC in DSDT
Oct 16 18:27:04 localhost kernel: [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
Oct 16 18:27:04 localhost kernel: ACPI: SSDT 00000000bf6bba18 0047D (v01  PmRef  Cpu0Ist 00003000 INTL 20060912)
Oct 16 18:27:04 localhost kernel: ACPI: Dynamic OEM Table Load:
Oct 16 18:27:04 localhost kernel: ACPI: SSDT           (null) 0047D (v01  PmRef  Cpu0Ist 00003000 INTL 20060912)
Oct 16 18:27:04 localhost kernel: ACPI: SSDT 00000000bf6b9018 008AA (v01  PmRef  Cpu0Cst 00003001 INTL 20060912)
Oct 16 18:27:04 localhost kernel: ACPI: Dynamic OEM Table Load:
Oct 16 18:27:04 localhost kernel: ACPI: SSDT           (null) 008AA (v01  PmRef  Cpu0Cst 00003001 INTL 20060912)
Oct 16 18:27:04 localhost kernel: ACPI: SSDT 00000000bf6baa98 00303 (v01  PmRef    ApIst 00003000 INTL 20060912)
Oct 16 18:27:04 localhost kernel: ACPI: Dynamic OEM Table Load:
Oct 16 18:27:04 localhost kernel: ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20060912)
Oct 16 18:27:04 localhost kernel: ACPI: SSDT 00000000bf6b8d98 00119 (v01  PmRef    ApCst 00003000 INTL 20060912)
Oct 16 18:27:04 localhost kernel: ACPI: Dynamic OEM Table Load:
Oct 16 18:27:04 localhost kernel: ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20060912)
Oct 16 18:27:04 localhost kernel: ACPI: Interpreter enabled
Oct 16 18:27:04 localhost kernel: ACPI: (supports S0 S3 S5)
Oct 16 18:27:04 localhost kernel: ACPI: Using IOAPIC for interrupt routing
Oct 16 18:27:04 localhost kernel: ACPI: Power Resource [APPR] (off)
Oct 16 18:27:04 localhost kernel: ACPI: Power Resource [COMP] (on)
Oct 16 18:27:04 localhost kernel: ACPI: Power Resource [LPP] (on)
Oct 16 18:27:04 localhost kernel: ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
Oct 16 18:27:04 localhost kernel: ACPI: No dock devices found.
Oct 16 18:27:04 localhost kernel: PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
Oct 16 18:27:04 localhost kernel: ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
Oct 16 18:27:04 localhost kernel: PCI host bridge to bus 0000:00
Oct 16 18:27:04 localhost kernel: pci_bus 0000:00: root bus resource [bus 00-fe]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:00: root bus resource [mem 0xc0000000-0xdfffffff]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfedfffff]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:00: root bus resource [mem 0xfee01000-0xffffffff]
Oct 16 18:27:04 localhost kernel: pci 0000:00:00.0: [8086:0044] type 00 class 0x060000
Oct 16 18:27:04 localhost kernel: DMAR: BIOS has allocated no shadow GTT; disabling IOMMU for graphics
Oct 16 18:27:04 localhost kernel: pci 0000:00:01.0: [8086:0045] type 01 class 0x060400
Oct 16 18:27:04 localhost kernel: pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
Oct 16 18:27:04 localhost kernel: pci 0000:00:16.0: [8086:3b64] type 00 class 0x078000
Oct 16 18:27:04 localhost kernel: pci 0000:00:16.0: reg 10: [mem 0xd7524000-0xd752400f 64bit]
Oct 16 18:27:04 localhost kernel: pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
Oct 16 18:27:04 localhost kernel: pci 0000:00:16.3: [8086:3b67] type 00 class 0x070002
Oct 16 18:27:04 localhost kernel: pci 0000:00:16.3: reg 10: [io  0x6050-0x6057]
Oct 16 18:27:04 localhost kernel: pci 0000:00:16.3: reg 14: [mem 0xd752b000-0xd752bfff]
Oct 16 18:27:04 localhost kernel: pci 0000:00:19.0: [8086:10ea] type 00 class 0x020000
Oct 16 18:27:04 localhost kernel: pci 0000:00:19.0: reg 10: [mem 0xd7500000-0xd751ffff]
Oct 16 18:27:04 localhost kernel: pci 0000:00:19.0: reg 14: [mem 0xd752a000-0xd752afff]
Oct 16 18:27:04 localhost kernel: pci 0000:00:19.0: reg 18: [io  0x6020-0x603f]
Oct 16 18:27:04 localhost kernel: pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
Oct 16 18:27:04 localhost kernel: pci 0000:00:1a.0: [8086:3b3c] type 00 class 0x0c0320
Oct 16 18:27:04 localhost kernel: pci 0000:00:1a.0: reg 10: [mem 0xd7529000-0xd75293ff]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
Oct 16 18:27:04 localhost kernel: pci 0000:00:1b.0: [8086:3b56] type 00 class 0x040300
Oct 16 18:27:04 localhost kernel: pci 0000:00:1b.0: reg 10: [mem 0xd7520000-0xd7523fff 64bit]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
Oct 16 18:27:04 localhost kernel: pci 0000:00:1c.0: [8086:3b42] type 01 class 0x060400
Oct 16 18:27:04 localhost kernel: pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
Oct 16 18:27:04 localhost kernel: pci 0000:00:1c.1: [8086:3b44] type 01 class 0x060400
Oct 16 18:27:04 localhost kernel: pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
Oct 16 18:27:04 localhost kernel: pci 0000:00:1c.3: [8086:3b48] type 01 class 0x060400
Oct 16 18:27:04 localhost kernel: pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
Oct 16 18:27:04 localhost kernel: pci 0000:00:1c.7: [8086:3b50] type 01 class 0x060400
Oct 16 18:27:04 localhost kernel: pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
Oct 16 18:27:04 localhost kernel: pci 0000:00:1d.0: [8086:3b34] type 00 class 0x0c0320
Oct 16 18:27:04 localhost kernel: pci 0000:00:1d.0: reg 10: [mem 0xd7528000-0xd75283ff]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
Oct 16 18:27:04 localhost kernel: pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
Oct 16 18:27:04 localhost kernel: pci 0000:00:1f.0: [8086:3b07] type 00 class 0x060100
Oct 16 18:27:04 localhost kernel: pci 0000:00:1f.2: [8086:3b2f] type 00 class 0x010601
Oct 16 18:27:04 localhost kernel: pci 0000:00:1f.2: reg 10: [io  0x6048-0x604f]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1f.2: reg 14: [io  0x605c-0x605f]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1f.2: reg 18: [io  0x6040-0x6047]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1f.2: reg 1c: [io  0x6058-0x605b]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1f.2: reg 20: [io  0x6000-0x601f]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1f.2: reg 24: [mem 0xd7527000-0xd75277ff]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1f.2: PME# supported from D3hot
Oct 16 18:27:04 localhost kernel: pci 0000:00:1f.6: [8086:3b32] type 00 class 0x118000
Oct 16 18:27:04 localhost kernel: pci 0000:00:1f.6: reg 10: [mem 0xd7526000-0xd7526fff 64bit]
Oct 16 18:27:04 localhost kernel: pci 0000:01:00.0: [10de:0cbc] type 00 class 0x030000
Oct 16 18:27:04 localhost kernel: pci 0000:01:00.0: reg 10: [mem 0xd2000000-0xd2ffffff]
Oct 16 18:27:04 localhost kernel: pci 0000:01:00.0: reg 14: [mem 0xc0000000-0xcfffffff 64bit pref]
Oct 16 18:27:04 localhost kernel: pci 0000:01:00.0: reg 1c: [mem 0xd0000000-0xd1ffffff 64bit pref]
Oct 16 18:27:04 localhost kernel: pci 0000:01:00.0: reg 24: [io  0x5000-0x507f]
Oct 16 18:27:04 localhost kernel: pci 0000:01:00.0: reg 30: [mem 0xfff80000-0xffffffff pref]
Oct 16 18:27:04 localhost kernel: pci 0000:01:00.1: [10de:0be4] type 00 class 0x040300
Oct 16 18:27:04 localhost kernel: pci 0000:01:00.1: reg 10: [mem 0xd3000000-0xd3003fff]
Oct 16 18:27:04 localhost kernel: pci 0000:00:01.0: PCI bridge to [bus 01]
Oct 16 18:27:04 localhost kernel: pci 0000:00:01.0:   bridge window [io  0x5000-0x5fff]
Oct 16 18:27:04 localhost kernel: pci 0000:00:01.0:   bridge window [mem 0xd2000000-0xd30fffff]
Oct 16 18:27:04 localhost kernel: pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xd1ffffff 64bit pref]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1c.0: PCI bridge to [bus 02]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1c.0:   bridge window [mem 0xd7400000-0xd74fffff]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1c.1: PCI bridge to [bus 03-43]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1c.1:   bridge window [io  0x3000-0x4fff]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1c.1:   bridge window [mem 0xd3400000-0xd73fffff]
Oct 16 18:27:04 localhost kernel: pci 0000:44:00.0: [8086:4238] type 00 class 0x028000
Oct 16 18:27:04 localhost kernel: pci 0000:44:00.0: reg 10: [mem 0xd3300000-0xd3301fff 64bit]
Oct 16 18:27:04 localhost kernel: pci 0000:44:00.0: PME# supported from D0 D3hot D3cold
Oct 16 18:27:04 localhost kernel: pci 0000:00:1c.3: PCI bridge to [bus 44]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1c.3:   bridge window [mem 0xd3300000-0xd33fffff]
Oct 16 18:27:04 localhost kernel: pci 0000:45:00.0: [1033:0194] type 00 class 0x0c0330
Oct 16 18:27:04 localhost kernel: pci 0000:45:00.0: reg 10: [mem 0xd3200000-0xd3201fff 64bit]
Oct 16 18:27:04 localhost kernel: pci 0000:45:00.0: PME# supported from D0 D3hot
Oct 16 18:27:04 localhost kernel: pci 0000:00:1c.7: PCI bridge to [bus 45]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1c.7:   bridge window [mem 0xd3200000-0xd32fffff]
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.0: [1180:0832] type 00 class 0x0c0010
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.0: proprietary Ricoh MMC controller disabled (via firewire function)
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.0: MMC cards are now supported by standard SDHCI controller
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.0: reg 10: [mem 0xd3101000-0xd31017ff]
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.0: supports D1 D2
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.0: PME# supported from D0 D1 D2 D3hot D3cold
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.1: [1180:0822] type 00 class 0x080500
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.1: reg 10: [mem 0xd3105000-0xd31050ff]
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.1: supports D1 D2
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.1: PME# supported from D0 D1 D2 D3hot D3cold
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.2: [1180:0592] type 00 class 0x088000
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.2: reg 10: [mem 0xd3103000-0xd31030ff]
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.2: supports D1 D2
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.2: PME# supported from D0 D1 D2 D3hot D3cold
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.3: [1180:0852] type 00 class 0x088000
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.3: reg 10: [mem 0xd3102000-0xd31020ff]
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.3: supports D1 D2
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.3: PME# supported from D0 D1 D2 D3hot D3cold
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.4: [1180:0476] type 02 class 0x060700
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.4: reg 10: [mem 0xd3100000-0xd3100fff]
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.4: supports D1 D2
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.4: PME# supported from D0 D1 D2 D3hot D3cold
Oct 16 18:27:04 localhost kernel: pci 0000:00:1e.0: PCI bridge to [bus 46-47] (subtractive decode)
Oct 16 18:27:04 localhost kernel: pci 0000:00:1e.0:   bridge window [io  0x2000-0x2fff]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1e.0:   bridge window [mem 0xd3100000-0xd31fffff]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
Oct 16 18:27:04 localhost kernel: pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
Oct 16 18:27:04 localhost kernel: pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
Oct 16 18:27:04 localhost kernel: pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xdfffffff] (subtractive decode)
Oct 16 18:27:04 localhost kernel: pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfedfffff] (subtractive decode)
Oct 16 18:27:04 localhost kernel: pci 0000:00:1e.0:   bridge window [mem 0xfee01000-0xffffffff] (subtractive decode)
Oct 16 18:27:04 localhost kernel: pci_bus 0000:47: busn_res: can not insert [bus 47-ff] under [bus 46-47] (conflicts with (null) [bus 46-47])
Oct 16 18:27:04 localhost kernel: pci_bus 0000:47: busn_res: [bus 47-ff] end is updated to 4a
Oct 16 18:27:04 localhost kernel: pci_bus 0000:47: busn_res: can not insert [bus 47-4a] under [bus 46-47] (conflicts with (null) [bus 46-47])
Oct 16 18:27:04 localhost kernel: pci_bus 0000:47: [bus 47-4a] partially hidden behind transparent bridge 0000:46 [bus 46-47]
Oct 16 18:27:04 localhost kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Oct 16 18:27:04 localhost kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
Oct 16 18:27:04 localhost kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
Oct 16 18:27:04 localhost kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
Oct 16 18:27:04 localhost kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
Oct 16 18:27:04 localhost kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
Oct 16 18:27:04 localhost kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP08._PRT]
Oct 16 18:27:04 localhost kernel: pci0000:00: Requesting ACPI _OSC control (0x1d)
Oct 16 18:27:04 localhost kernel: pci0000:00: ACPI _OSC control (0x1d) granted
Oct 16 18:27:04 localhost kernel: ACPI: PCI Root Bridge [CPBG] (domain 0000 [bus ff])
Oct 16 18:27:04 localhost kernel: PCI host bridge to bus 0000:ff
Oct 16 18:27:04 localhost kernel: pci_bus 0000:ff: root bus resource [bus ff]
Oct 16 18:27:04 localhost kernel: pci 0000:ff:00.0: [8086:2c62] type 00 class 0x060000
Oct 16 18:27:04 localhost kernel: pci 0000:ff:00.1: [8086:2d01] type 00 class 0x060000
Oct 16 18:27:04 localhost kernel: pci 0000:ff:02.0: [8086:2d10] type 00 class 0x060000
Oct 16 18:27:04 localhost kernel: pci 0000:ff:02.1: [8086:2d11] type 00 class 0x060000
Oct 16 18:27:04 localhost kernel: pci 0000:ff:02.2: [8086:2d12] type 00 class 0x060000
Oct 16 18:27:04 localhost kernel: pci 0000:ff:02.3: [8086:2d13] type 00 class 0x060000
Oct 16 18:27:04 localhost kernel: pci0000:ff: ACPI _OSC support notification failed, disabling PCIe ASPM
Oct 16 18:27:04 localhost kernel: pci0000:ff: Unable to request _OSC control (_OSC support mask: 0x08)
Oct 16 18:27:04 localhost kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 *10 12 14 15)
Oct 16 18:27:04 localhost kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 *5 6 7 11 12 14 15)
Oct 16 18:27:04 localhost kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
Oct 16 18:27:04 localhost kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
Oct 16 18:27:04 localhost kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 *10 12 14 15)
Oct 16 18:27:04 localhost kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
Oct 16 18:27:04 localhost kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
Oct 16 18:27:04 localhost kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
Oct 16 18:27:04 localhost kernel: vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
Oct 16 18:27:04 localhost kernel: vgaarb: loaded
Oct 16 18:27:04 localhost kernel: vgaarb: bridge control possible 0000:01:00.0
Oct 16 18:27:04 localhost kernel: SCSI subsystem initialized
Oct 16 18:27:04 localhost kernel: ACPI: bus type scsi registered
Oct 16 18:27:04 localhost kernel: libata version 3.00 loaded.
Oct 16 18:27:04 localhost kernel: ACPI: bus type usb registered
Oct 16 18:27:04 localhost kernel: usbcore: registered new interface driver usbfs
Oct 16 18:27:04 localhost kernel: usbcore: registered new interface driver hub
Oct 16 18:27:04 localhost kernel: usbcore: registered new device driver usb
Oct 16 18:27:04 localhost kernel: Linux video capture interface: v2.00
Oct 16 18:27:04 localhost kernel: wmi: Mapper loaded
Oct 16 18:27:04 localhost kernel: Advanced Linux Sound Architecture Driver Initialized.
Oct 16 18:27:04 localhost kernel: PCI: Using ACPI for IRQ routing
Oct 16 18:27:04 localhost kernel: PCI: pci_cache_line_size set to 64 bytes
Oct 16 18:27:04 localhost kernel: e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
Oct 16 18:27:04 localhost kernel: e820: reserve RAM buffer [mem 0xbefc2000-0xbfffffff]
Oct 16 18:27:04 localhost kernel: e820: reserve RAM buffer [mem 0xbf800000-0xbfffffff]
Oct 16 18:27:04 localhost kernel: Bluetooth: Core ver 2.16
Oct 16 18:27:04 localhost kernel: NET: Registered protocol family 31
Oct 16 18:27:04 localhost kernel: Bluetooth: HCI device and connection manager initialized
Oct 16 18:27:04 localhost kernel: Bluetooth: HCI socket layer initialized
Oct 16 18:27:04 localhost kernel: Bluetooth: L2CAP socket layer initialized
Oct 16 18:27:04 localhost kernel: Bluetooth: SCO socket layer initialized
Oct 16 18:27:04 localhost kernel: cfg80211: Calling CRDA to update world regulatory domain
Oct 16 18:27:04 localhost kernel: hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
Oct 16 18:27:04 localhost kernel: hpet0: 8 comparators, 64-bit 14.318180 MHz counter
Oct 16 18:27:04 localhost kernel: Switching to clocksource hpet
Oct 16 18:27:04 localhost kernel: pnp: PnP ACPI init
Oct 16 18:27:04 localhost kernel: ACPI: bus type pnp registered
Oct 16 18:27:04 localhost kernel: pnp 00:00: [bus 00-fe]
Oct 16 18:27:04 localhost kernel: pnp 00:00: [io  0x0000-0x0cf7 window]
Oct 16 18:27:04 localhost kernel: pnp 00:00: [io  0x0cf8-0x0cff]
Oct 16 18:27:04 localhost kernel: pnp 00:00: [io  0x0d00-0xffff window]
Oct 16 18:27:04 localhost kernel: pnp 00:00: [mem 0x000a0000-0x000bffff window]
Oct 16 18:27:04 localhost kernel: pnp 00:00: [mem 0x000c0000-0x000c3fff window]
Oct 16 18:27:04 localhost kernel: pnp 00:00: [mem 0x000c4000-0x000c7fff window]
Oct 16 18:27:04 localhost kernel: pnp 00:00: [mem 0x000c8000-0x000cbfff window]
Oct 16 18:27:04 localhost kernel: pnp 00:00: [mem 0x000cc000-0x000cffff window]
Oct 16 18:27:04 localhost kernel: pnp 00:00: [mem 0x000d0000-0x000d3fff window]
Oct 16 18:27:04 localhost kernel: pnp 00:00: [mem 0x000d4000-0x000d7fff window]
Oct 16 18:27:04 localhost kernel: pnp 00:00: [mem 0x000d8000-0x000dbfff window]
Oct 16 18:27:04 localhost kernel: pnp 00:00: [mem 0x000dc000-0x000dffff window]
Oct 16 18:27:04 localhost kernel: pnp 00:00: [mem 0x000e0000-0x000e3fff window]
Oct 16 18:27:04 localhost kernel: pnp 00:00: [mem 0x000e4000-0x000e7fff window]
Oct 16 18:27:04 localhost kernel: pnp 00:00: [mem 0x000e8000-0x000ebfff window]
Oct 16 18:27:04 localhost kernel: pnp 00:00: [mem 0x000ec000-0x000effff window]
Oct 16 18:27:04 localhost kernel: pnp 00:00: [mem 0x000f0000-0x000fffff window]
Oct 16 18:27:04 localhost kernel: pnp 00:00: [mem 0xc0000000-0xdfffffff window]
Oct 16 18:27:04 localhost kernel: pnp 00:00: [mem 0xf0000000-0xfedfffff window]
Oct 16 18:27:04 localhost kernel: pnp 00:00: [mem 0xfee01000-0xffffffff window]
Oct 16 18:27:04 localhost kernel: pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
Oct 16 18:27:04 localhost kernel: pnp 00:01: [mem 0xfed1c000-0xfed1ffff]
Oct 16 18:27:04 localhost kernel: pnp 00:01: [mem 0xfed10000-0xfed13fff]
Oct 16 18:27:04 localhost kernel: pnp 00:01: [mem 0xfed1b000-0xfed1bfff]
Oct 16 18:27:04 localhost kernel: pnp 00:01: [mem 0xfed19000-0xfed19fff]
Oct 16 18:27:04 localhost kernel: pnp 00:01: [mem 0xd7600000-0xd7600fff]
Oct 16 18:27:04 localhost kernel: pnp 00:01: [mem 0xe0000000-0xefffffff]
Oct 16 18:27:04 localhost kernel: pnp 00:01: [mem 0xfed20000-0xfed3ffff]
Oct 16 18:27:04 localhost kernel: pnp 00:01: [mem 0xfed90000-0xfed93fff]
Oct 16 18:27:04 localhost kernel: pnp 00:01: [mem 0xfed45000-0xfed8ffff]
Oct 16 18:27:04 localhost kernel: pnp 00:01: [mem 0xfec00000-0xfec00fff]
Oct 16 18:27:04 localhost kernel: system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
Oct 16 18:27:04 localhost kernel: system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
Oct 16 18:27:04 localhost kernel: system 00:01: [mem 0xfed1b000-0xfed1bfff] has been reserved
Oct 16 18:27:04 localhost kernel: system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
Oct 16 18:27:04 localhost kernel: system 00:01: [mem 0xd7600000-0xd7600fff] has been reserved
Oct 16 18:27:04 localhost kernel: system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
Oct 16 18:27:04 localhost kernel: system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
Oct 16 18:27:04 localhost kernel: system 00:01: [mem 0xfed90000-0xfed93fff] has been reserved
Oct 16 18:27:04 localhost kernel: system 00:01: [mem 0xfed45000-0xfed8ffff] has been reserved
Oct 16 18:27:04 localhost kernel: system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
Oct 16 18:27:04 localhost kernel: system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
Oct 16 18:27:04 localhost kernel: pnp 00:02: [io  0x0000-0x001f]
Oct 16 18:27:04 localhost kernel: pnp 00:02: [io  0x0081-0x0091]
Oct 16 18:27:04 localhost kernel: pnp 00:02: [io  0x0093-0x009f]
Oct 16 18:27:04 localhost kernel: pnp 00:02: [io  0x00c0-0x00df]
Oct 16 18:27:04 localhost kernel: pnp 00:02: [dma 4]
Oct 16 18:27:04 localhost kernel: pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
Oct 16 18:27:04 localhost kernel: pnp 00:03: [mem 0xff000000-0xffffffff]
Oct 16 18:27:04 localhost kernel: pnp 00:03: Plug and Play ACPI device, IDs INT0800 (active)
Oct 16 18:27:04 localhost kernel: pnp 00:04: [io  0xfe00-0xfe0f]
Oct 16 18:27:04 localhost kernel: pnp 00:04: [io  0xfe80-0xfe8f]
Oct 16 18:27:04 localhost kernel: pnp 00:04: [mem 0xfed40000-0xfed44fff]
Oct 16 18:27:04 localhost kernel: pnp 00:04: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
Oct 16 18:27:04 localhost kernel: pnp 00:05: [mem 0xfed00000-0xfed003ff]
Oct 16 18:27:04 localhost kernel: pnp 00:05: Plug and Play ACPI device, IDs PNP0103 (active)
Oct 16 18:27:04 localhost kernel: pnp 00:06: [io  0x00f0]
Oct 16 18:27:04 localhost kernel: pnp 00:06: [irq 13]
Oct 16 18:27:04 localhost kernel: pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
Oct 16 18:27:04 localhost kernel: pnp 00:07: [io  0x002e-0x002f]
Oct 16 18:27:04 localhost kernel: pnp 00:07: [io  0x004e-0x004f]
Oct 16 18:27:04 localhost kernel: pnp 00:07: [io  0x0061]
Oct 16 18:27:04 localhost kernel: pnp 00:07: [io  0x0063]
Oct 16 18:27:04 localhost kernel: pnp 00:07: [io  0x0065]
Oct 16 18:27:04 localhost kernel: pnp 00:07: [io  0x0067]
Oct 16 18:27:04 localhost kernel: pnp 00:07: [io  0x0070]
Oct 16 18:27:04 localhost kernel: pnp 00:07: [io  0x0080]
Oct 16 18:27:04 localhost kernel: pnp 00:07: [io  0x0092]
Oct 16 18:27:04 localhost kernel: pnp 00:07: [io  0x00b2-0x00b3]
Oct 16 18:27:04 localhost kernel: pnp 00:07: [io  0x0200-0x027f]
Oct 16 18:27:04 localhost kernel: pnp 00:07: [io  0x1000-0x100f]
Oct 16 18:27:04 localhost kernel: pnp 00:07: [io  0xffff]
Oct 16 18:27:04 localhost kernel: pnp 00:07: [io  0xffff]
Oct 16 18:27:04 localhost kernel: pnp 00:07: [io  0x0400-0x047f]
Oct 16 18:27:04 localhost kernel: pnp 00:07: [io  0x0500-0x057f]
Oct 16 18:27:04 localhost kernel: pnp 00:07: [io  0xef80-0xef9f]
Oct 16 18:27:04 localhost kernel: system 00:07: [io  0x0200-0x027f] has been reserved
Oct 16 18:27:04 localhost kernel: system 00:07: [io  0x1000-0x100f] has been reserved
Oct 16 18:27:04 localhost kernel: system 00:07: [io  0xffff] has been reserved
Oct 16 18:27:04 localhost kernel: system 00:07: [io  0xffff] has been reserved
Oct 16 18:27:04 localhost kernel: system 00:07: [io  0x0400-0x047f] has been reserved
Oct 16 18:27:04 localhost kernel: system 00:07: [io  0x0500-0x057f] has been reserved
Oct 16 18:27:04 localhost kernel: system 00:07: [io  0xef80-0xef9f] has been reserved
Oct 16 18:27:04 localhost kernel: system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
Oct 16 18:27:04 localhost kernel: pnp 00:08: [io  0x0070-0x0077]
Oct 16 18:27:04 localhost kernel: pnp 00:08: [irq 8]
Oct 16 18:27:04 localhost kernel: pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
Oct 16 18:27:04 localhost kernel: pnp 00:09: [io  0x03f8-0x03ff]
Oct 16 18:27:04 localhost kernel: pnp 00:09: [irq 4]
Oct 16 18:27:04 localhost kernel: pnp 00:09: Plug and Play ACPI device, IDs PNP0501 PNP0500 (active)
Oct 16 18:27:04 localhost kernel: pnp 00:0a: [io  0x0378-0x037f]
Oct 16 18:27:04 localhost kernel: pnp 00:0a: [io  0x0778-0x077a]
Oct 16 18:27:04 localhost kernel: pnp 00:0a: [irq 5]
Oct 16 18:27:04 localhost kernel: pnp 00:0a: [dma 0 disabled]
Oct 16 18:27:04 localhost kernel: pnp 00:0a: Plug and Play ACPI device, IDs PNP0401 (active)
Oct 16 18:27:04 localhost kernel: pnp 00:0b: [io  0x0060]
Oct 16 18:27:04 localhost kernel: pnp 00:0b: [io  0x0064]
Oct 16 18:27:04 localhost kernel: pnp 00:0b: [irq 1]
Oct 16 18:27:04 localhost kernel: pnp 00:0b: Plug and Play ACPI device, IDs PNP0303 (active)
Oct 16 18:27:04 localhost kernel: pnp 00:0c: [irq 12]
Oct 16 18:27:04 localhost kernel: pnp 00:0c: Plug and Play ACPI device, IDs SYN0166 SYN0100 SYN0002 PNP0f13 (active)
Oct 16 18:27:04 localhost kernel: pnp 00:0d: [irq 23]
Oct 16 18:27:04 localhost kernel: pnp 00:0d: Plug and Play ACPI device, IDs HPQ0004 (active)
Oct 16 18:27:04 localhost kernel: pnp 00:0e: [bus ff]
Oct 16 18:27:04 localhost kernel: pnp 00:0e: Plug and Play ACPI device, IDs PNP0a03 (active)
Oct 16 18:27:04 localhost kernel: pnp: PnP ACPI: found 15 devices
Oct 16 18:27:04 localhost kernel: ACPI: ACPI bus type pnp unregistered
Oct 16 18:27:04 localhost kernel: pci 0000:01:00.0: no compatible bridge window for [mem 0xfff80000-0xffffffff pref]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03-43] add_size 200000
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.4: res[9]=[mem 0x04000000-0x03ffffff pref] get_res_add_size add_size 4000000
Oct 16 18:27:04 localhost kernel: pci 0000:00:1e.0: bridge window [mem 0x04000000-0x03ffffff pref] to [bus 46-47] add_size 4000000
Oct 16 18:27:04 localhost kernel: pci 0000:00:1e.0: res[9]=[mem 0x04000000-0x03ffffff pref] get_res_add_size add_size 4000000
Oct 16 18:27:04 localhost kernel: pci 0000:00:1c.1: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
Oct 16 18:27:04 localhost kernel: pci 0000:00:1e.0: BAR 9: assigned [mem 0xd8000000-0xdbffffff pref]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1c.1: BAR 9: assigned [mem 0xd7700000-0xd78fffff 64bit pref]
Oct 16 18:27:04 localhost kernel: pci 0000:01:00.0: BAR 6: assigned [mem 0xd3080000-0xd30fffff pref]
Oct 16 18:27:04 localhost kernel: pci 0000:00:01.0: PCI bridge to [bus 01]
Oct 16 18:27:04 localhost kernel: pci 0000:00:01.0:   bridge window [io  0x5000-0x5fff]
Oct 16 18:27:04 localhost kernel: pci 0000:00:01.0:   bridge window [mem 0xd2000000-0xd30fffff]
Oct 16 18:27:04 localhost kernel: pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xd1ffffff 64bit pref]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1c.0: PCI bridge to [bus 02]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1c.0:   bridge window [mem 0xd7400000-0xd74fffff]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1c.1: PCI bridge to [bus 03-43]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1c.1:   bridge window [io  0x3000-0x4fff]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1c.1:   bridge window [mem 0xd3400000-0xd73fffff]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1c.1:   bridge window [mem 0xd7700000-0xd78fffff 64bit pref]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1c.3: PCI bridge to [bus 44]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1c.3:   bridge window [mem 0xd3300000-0xd33fffff]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1c.7: PCI bridge to [bus 45]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1c.7:   bridge window [mem 0xd3200000-0xd32fffff]
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.4: res[9]=[mem 0x04000000-0x03ffffff pref] get_res_add_size add_size 4000000
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.4: res[10]=[mem 0x04000000-0x03ffffff] get_res_add_size add_size 4000000
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.4: res[7]=[io  0x0100-0x00ff] get_res_add_size add_size 100
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.4: res[8]=[io  0x0100-0x00ff] get_res_add_size add_size 100
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.4: BAR 9: assigned [mem 0xd8000000-0xdbffffff pref]
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.4: BAR 10: assigned [mem 0xdc000000-0xdfffffff]
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.4: BAR 7: assigned [io  0x2000-0x20ff]
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.4: BAR 8: assigned [io  0x2400-0x24ff]
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.4: CardBus bridge to [bus 47-4a]
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.4:   bridge window [io  0x2000-0x20ff]
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.4:   bridge window [io  0x2400-0x24ff]
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.4:   bridge window [mem 0xd8000000-0xdbffffff pref]
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.4:   bridge window [mem 0xdc000000-0xdfffffff]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1e.0: PCI bridge to [bus 46-47]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1e.0:   bridge window [io  0x2000-0x2fff]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1e.0:   bridge window [mem 0xd3100000-0xd31fffff]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1e.0:   bridge window [mem 0xd8000000-0xdbffffff pref]
Oct 16 18:27:04 localhost kernel: pci 0000:00:1e.0: setting latency timer to 64
Oct 16 18:27:04 localhost kernel: pci 0000:46:06.4: setting latency timer to 64
Oct 16 18:27:04 localhost kernel: pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:00: resource 7 [mem 0xc0000000-0xdfffffff]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:00: resource 8 [mem 0xf0000000-0xfedfffff]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:00: resource 9 [mem 0xfee01000-0xffffffff]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:01: resource 0 [io  0x5000-0x5fff]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:01: resource 1 [mem 0xd2000000-0xd30fffff]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:01: resource 2 [mem 0xc0000000-0xd1ffffff 64bit pref]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:02: resource 1 [mem 0xd7400000-0xd74fffff]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:03: resource 0 [io  0x3000-0x4fff]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:03: resource 1 [mem 0xd3400000-0xd73fffff]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:03: resource 2 [mem 0xd7700000-0xd78fffff 64bit pref]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:44: resource 1 [mem 0xd3300000-0xd33fffff]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:45: resource 1 [mem 0xd3200000-0xd32fffff]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:46: resource 0 [io  0x2000-0x2fff]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:46: resource 1 [mem 0xd3100000-0xd31fffff]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:46: resource 2 [mem 0xd8000000-0xdbffffff pref]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:46: resource 4 [io  0x0000-0x0cf7]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:46: resource 5 [io  0x0d00-0xffff]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:46: resource 6 [mem 0x000a0000-0x000bffff]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:46: resource 7 [mem 0xc0000000-0xdfffffff]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:46: resource 8 [mem 0xf0000000-0xfedfffff]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:46: resource 9 [mem 0xfee01000-0xffffffff]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:47: resource 0 [io  0x2000-0x20ff]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:47: resource 1 [io  0x2400-0x24ff]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:47: resource 2 [mem 0xd8000000-0xdbffffff pref]
Oct 16 18:27:04 localhost kernel: pci_bus 0000:47: resource 3 [mem 0xdc000000-0xdfffffff]
Oct 16 18:27:04 localhost kernel: NET: Registered protocol family 2
Oct 16 18:27:04 localhost kernel: TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
Oct 16 18:27:04 localhost kernel: TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Oct 16 18:27:04 localhost kernel: TCP: Hash tables configured (established 524288 bind 65536)
Oct 16 18:27:04 localhost kernel: TCP: reno registered
Oct 16 18:27:04 localhost kernel: UDP hash table entries: 4096 (order: 5, 131072 bytes)
Oct 16 18:27:04 localhost kernel: UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
Oct 16 18:27:04 localhost kernel: NET: Registered protocol family 1
Oct 16 18:27:04 localhost kernel: RPC: Registered named UNIX socket transport module.
Oct 16 18:27:04 localhost kernel: RPC: Registered udp transport module.
Oct 16 18:27:04 localhost kernel: RPC: Registered tcp transport module.
Oct 16 18:27:04 localhost kernel: RPC: Registered tcp NFSv4.1 backchannel transport module.
Oct 16 18:27:04 localhost kernel: pci 0000:01:00.0: Boot video device
Oct 16 18:27:04 localhost kernel: PCI: CLS 64 bytes, default 64
Oct 16 18:27:04 localhost kernel: dmar: Host address width 36
Oct 16 18:27:04 localhost kernel: dmar: DRHD base: 0x000000fed90000 flags: 0x0
Oct 16 18:27:04 localhost kernel: dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c9008020e30272 ecap 1000
Oct 16 18:27:04 localhost kernel: dmar: DRHD base: 0x000000fed93000 flags: 0x1
Oct 16 18:27:04 localhost kernel: dmar: IOMMU 1: reg_base_addr fed93000 ver 1:0 cap c9008020630272 ecap 1000
Oct 16 18:27:04 localhost kernel: dmar: RMRR base: 0x00000000000000 end: 0x00000000000fff
Oct 16 18:27:04 localhost kernel: DMAR: No ATSR found
Oct 16 18:27:04 localhost kernel: IOMMU 0 0xfed90000: using Register based invalidation
Oct 16 18:27:04 localhost kernel: IOMMU 1 0xfed93000: using Register based invalidation
Oct 16 18:27:04 localhost kernel: IOMMU: Setting RMRR:
Oct 16 18:27:04 localhost kernel: IOMMU: Setting identity map for device 0000:00:1d.0 [0x0 - 0xfff]
Oct 16 18:27:04 localhost kernel: IOMMU: Setting identity map for device 0000:00:1a.0 [0x0 - 0xfff]
Oct 16 18:27:04 localhost kernel: IOMMU: Prepare 0-16MiB unity mapping for LPC
Oct 16 18:27:04 localhost kernel: IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
Oct 16 18:27:04 localhost kernel: PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
Oct 16 18:27:04 localhost kernel: kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
Oct 16 18:27:04 localhost kernel: microcode: CPU0 sig=0x20655, pf=0x10, revision=0x2
Oct 16 18:27:04 localhost kernel: microcode: CPU1 sig=0x20655, pf=0x10, revision=0x2
Oct 16 18:27:04 localhost kernel: microcode: CPU2 sig=0x20655, pf=0x10, revision=0x2
Oct 16 18:27:04 localhost kernel: microcode: CPU3 sig=0x20655, pf=0x10, revision=0x2
Oct 16 18:27:04 localhost kernel: microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Oct 16 18:27:04 localhost kernel: audit: initializing netlink socket (disabled)
Oct 16 18:27:04 localhost kernel: type=2000 audit(1350404813.840:1): initialized
Oct 16 18:27:04 localhost kernel: HugeTLB registered 2 MB page size, pre-allocated 0 pages
Oct 16 18:27:04 localhost kernel: NFS: Registering the id_resolver key type
Oct 16 18:27:04 localhost kernel: Key type id_resolver registered
Oct 16 18:27:04 localhost kernel: Key type id_legacy registered
Oct 16 18:27:04 localhost kernel: Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Oct 16 18:27:04 localhost kernel: msgmni has been set to 15809
Oct 16 18:27:04 localhost kernel: Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
Oct 16 18:27:04 localhost kernel: io scheduler noop registered
Oct 16 18:27:04 localhost kernel: io scheduler deadline registered (default)
Oct 16 18:27:04 localhost kernel: io scheduler cfq registered
Oct 16 18:27:04 localhost kernel: pcieport 0000:00:01.0: irq 42 for MSI/MSI-X
Oct 16 18:27:04 localhost kernel: pcieport 0000:00:1c.0: irq 43 for MSI/MSI-X
Oct 16 18:27:04 localhost kernel: pcieport 0000:00:1c.1: irq 44 for MSI/MSI-X
Oct 16 18:27:04 localhost kernel: pcieport 0000:00:1c.3: irq 45 for MSI/MSI-X
Oct 16 18:27:04 localhost kernel: pcieport 0000:00:1c.7: irq 46 for MSI/MSI-X
Oct 16 18:27:04 localhost kernel: pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
Oct 16 18:27:04 localhost kernel: pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
Oct 16 18:27:04 localhost kernel: pci 0000:01:00.1: Signaling PME through PCIe PME interrupt
Oct 16 18:27:04 localhost kernel: pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
Oct 16 18:27:04 localhost kernel: pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
Oct 16 18:27:04 localhost kernel: pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
Oct 16 18:27:04 localhost kernel: pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
Oct 16 18:27:04 localhost kernel: pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
Oct 16 18:27:04 localhost kernel: pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
Oct 16 18:27:04 localhost kernel: pci 0000:44:00.0: Signaling PME through PCIe PME interrupt
Oct 16 18:27:04 localhost kernel: pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
Oct 16 18:27:04 localhost kernel: pcieport 0000:00:1c.7: Signaling PME through PCIe PME interrupt
Oct 16 18:27:04 localhost kernel: pci 0000:45:00.0: Signaling PME through PCIe PME interrupt
Oct 16 18:27:04 localhost kernel: pcie_pme 0000:00:1c.7:pcie01: service driver pcie_pme loaded
Oct 16 18:27:04 localhost kernel: pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Oct 16 18:27:04 localhost kernel: pciehp 0000:00:1c.1:pcie04: HPC vendor_id 8086 device_id 3b44 ss_vid 103c ss_did 1521
Oct 16 18:27:04 localhost kernel: pciehp 0000:00:1c.1:pcie04: service driver pciehp loaded
Oct 16 18:27:04 localhost kernel: pciehp: PCI Express Hot Plug Controller Driver version: 0.4
Oct 16 18:27:04 localhost kernel: acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
Oct 16 18:27:04 localhost kernel: acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
Oct 16 18:27:04 localhost kernel: intel_idle: MWAIT substates: 0x1120
Oct 16 18:27:04 localhost kernel: intel_idle: v0.4 model 0x25
Oct 16 18:27:04 localhost kernel: intel_idle: lapic_timer_reliable_states 0xffffffff
Oct 16 18:27:04 localhost kernel: ACPI: AC Adapter [AC] (on-line)
Oct 16 18:27:04 localhost kernel: input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
Oct 16 18:27:04 localhost kernel: ACPI: Sleep Button [SLPB]
Oct 16 18:27:04 localhost kernel: input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
Oct 16 18:27:04 localhost kernel: ACPI: Lid Switch [LID]
Oct 16 18:27:04 localhost kernel: input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
Oct 16 18:27:04 localhost kernel: ACPI: Power Button [PWRF]
Oct 16 18:27:04 localhost kernel: acpi device:04: registered as cooling_device0
Oct 16 18:27:04 localhost kernel: ACPI: Can't attach device
Oct 16 18:27:04 localhost kernel: video: probe of LNXVIDEO:00 failed with error -2
Oct 16 18:27:04 localhost kernel: ACPI: Requesting acpi_cpufreq
Oct 16 18:27:04 localhost kernel: thermal LNXTHERM:00: registered as thermal_zone0
Oct 16 18:27:04 localhost kernel: ACPI: Thermal Zone [EXTZ] (59 C)
Oct 16 18:27:04 localhost kernel: thermal LNXTHERM:01: registered as thermal_zone1
Oct 16 18:27:04 localhost kernel: ACPI: Thermal Zone [EX2Z] (0 C)
Oct 16 18:27:04 localhost kernel: thermal LNXTHERM:02: registered as thermal_zone2
Oct 16 18:27:04 localhost kernel: ACPI: Thermal Zone [PWMZ] (53 C)
Oct 16 18:27:04 localhost kernel: thermal LNXTHERM:03: registered as thermal_zone3
Oct 16 18:27:04 localhost kernel: ACPI: Thermal Zone [LOCZ] (52 C)
Oct 16 18:27:04 localhost kernel: thermal LNXTHERM:04: registered as thermal_zone4
Oct 16 18:27:04 localhost kernel: ACPI: Thermal Zone [GFXZ] (0 C)
Oct 16 18:27:04 localhost kernel: thermal LNXTHERM:05: registered as thermal_zone5
Oct 16 18:27:04 localhost kernel: ACPI: Thermal Zone [BATZ] (37 C)
Oct 16 18:27:04 localhost kernel: thermal LNXTHERM:06: registered as thermal_zone6
Oct 16 18:27:04 localhost kernel: ACPI: Thermal Zone [EGXZ] (72 C)
Oct 16 18:27:04 localhost kernel: thermal LNXTHERM:07: registered as thermal_zone7
Oct 16 18:27:04 localhost kernel: ACPI: Thermal Zone [CPUZ] (59 C)
Oct 16 18:27:04 localhost kernel: thermal LNXTHERM:08: registered as thermal_zone8
Oct 16 18:27:04 localhost kernel: ACPI: Thermal Zone [MCHZ] (64 C)
Oct 16 18:27:04 localhost kernel: thermal LNXTHERM:09: registered as thermal_zone9
Oct 16 18:27:04 localhost kernel: ACPI: Thermal Zone [PCHZ] (77 C)
Oct 16 18:27:04 localhost kernel: ioatdma: Intel(R) QuickData Technology Driver 4.00
Oct 16 18:27:04 localhost kernel: Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Oct 16 18:27:04 localhost kernel: 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Oct 16 18:27:04 localhost kernel: 0000:00:16.3: ttyS1 at I/O 0x6050 (irq = 17) is a 16550A
Oct 16 18:27:04 localhost kernel: Non-volatile memory driver v1.3
Oct 16 18:27:04 localhost kernel: Linux agpgart interface v0.103
Oct 16 18:27:04 localhost kernel: Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
Oct 16 18:27:04 localhost kernel: Hangcheck: Using getrawmonotonic().
Oct 16 18:27:04 localhost kernel: [drm] Initialized drm 1.1.0 20060810
Oct 16 18:27:04 localhost kernel: MXM: GUID detected in BIOS
Oct 16 18:27:04 localhost kernel: nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x0a3e00a2
Oct 16 18:27:04 localhost kernel: nouveau  [  DEVICE][0000:01:00.0] Chipset: GT215 (NVA3)
Oct 16 18:27:04 localhost kernel: nouveau  [  DEVICE][0000:01:00.0] Family : NV50
Oct 16 18:27:04 localhost kernel: nouveau  [   VBIOS][0000:01:00.0] checking PRAMIN for image...
Oct 16 18:27:04 localhost kernel: ACPI: Battery Slot [BAT0] (battery present)
Oct 16 18:27:04 localhost kernel: ACPI: Battery Slot [BAT1] (battery absent)
Oct 16 18:27:04 localhost kernel: nouveau  [   VBIOS][0000:01:00.0] ... appears to be valid
Oct 16 18:27:04 localhost kernel: nouveau  [   VBIOS][0000:01:00.0] using image from PRAMIN
Oct 16 18:27:04 localhost kernel: nouveau  [   VBIOS][0000:01:00.0] BIT signature found
Oct 16 18:27:04 localhost kernel: nouveau  [   VBIOS][0000:01:00.0] version 70.15.43.00
Oct 16 18:27:04 localhost kernel: nouveau  [     MXM][0000:01:00.0] BIOS version 3.0
Oct 16 18:27:04 localhost kernel: nouveau  [     MXM][0000:01:00.0] MXMS Version 3.0
Oct 16 18:27:04 localhost kernel: nouveau  [     PFB][0000:01:00.0] RAM type: GDDR5
Oct 16 18:27:04 localhost kernel: nouveau  [     PFB][0000:01:00.0] RAM size: 1024 MiB
Oct 16 18:27:04 localhost kernel: tsc: Refined TSC clocksource calibration: 2660.458 MHz
Oct 16 18:27:04 localhost kernel: Switching to clocksource tsc
Oct 16 18:27:04 localhost kernel: [TTM] Zone  kernel: Available graphics memory: 4047232 kiB
Oct 16 18:27:04 localhost kernel: [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
Oct 16 18:27:04 localhost kernel: [TTM] Initializing pool allocator
Oct 16 18:27:04 localhost kernel: [TTM] Initializing DMA pool allocator
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] VRAM: 1024 MiB
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] GART: 512 MiB
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] BIT BIOS found
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] Bios version 70.15.43.00
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] TMDS table version 2.0
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] DCB version 4.0
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] DCB outp 00: 01000313 00010034
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] DCB outp 03: 080153d6 0f220020
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] DCB outp 04: 08015392 00020020
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] DCB outp 05: 080143c6 0f220010
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] DCB outp 06: 08014382 00020010
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] DCB outp 08: 040383b6 0f230014
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] DCB outp 10: 020273a6 0f220010
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] DCB outp 11: 02027362 00020010
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] DCB outp 13: 02049300 00000000
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] DCB conn 00: 00000040
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] DCB conn 01: 00001161
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] DCB conn 02: 00001231
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] DCB conn 03: 01000331
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] DCB conn 04: 01000446
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] DCB conn 05: 02000546
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] DCB conn 06: 00010631
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] DCB conn 07: 00010746
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] DCB conn 08: 00020847
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] DCB conn 09: 00000900
Oct 16 18:27:04 localhost kernel: [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
Oct 16 18:27:04 localhost kernel: [drm] No driver support for vblank timestamp query.
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] ACPI backlight interface available, not registering our own
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] 3 available performance level(s)
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] 0: core 135MHz shader 270MHz memory 135MHz voltage 800mV
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] 1: core 405MHz shader 810MHz memory 324MHz voltage 850mV
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] 3: core 561MHz shader 1125MHz memory 1099MHz voltage 1000mV
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] c: core 405MHz shader 810MHz memory 324MHz voltage 1000mV
Oct 16 18:27:04 localhost kernel: nouveau  [     DRM] allocated 1680x1050 fb: 0xd0000, bo ffff880231243800
Oct 16 18:27:04 localhost kernel: fbcon: nouveaufb (fb0) is primary device
Oct 16 18:27:04 localhost kernel: Console: switching to colour frame buffer device 210x65
Oct 16 18:27:04 localhost kernel: fb0: nouveaufb frame buffer device
Oct 16 18:27:04 localhost kernel: drm: registered panic notifier
Oct 16 18:27:04 localhost kernel: [drm] Initialized nouveau 1.1.0 20120801 for 0000:01:00.0 on minor 0
Oct 16 18:27:04 localhost kernel: brd: module loaded
Oct 16 18:27:04 localhost kernel: loop: module loaded
Oct 16 18:27:04 localhost kernel: ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \PMIO 1 (20120913/utaddress-251)
Oct 16 18:27:04 localhost kernel: ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
Oct 16 18:27:04 localhost kernel: ACPI Warning: 0x0000000000000540-0x000000000000054f SystemIO conflicts with Region \GPIO 1 (20120913/utaddress-251)
Oct 16 18:27:04 localhost kernel: ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
Oct 16 18:27:04 localhost kernel: ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \GPIO 1 (20120913/utaddress-251)
Oct 16 18:27:04 localhost kernel: ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
Oct 16 18:27:04 localhost kernel: ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \GPIO 1 (20120913/utaddress-251)
Oct 16 18:27:04 localhost kernel: ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
Oct 16 18:27:04 localhost kernel: lpc_ich: Resource conflict(s) found affecting gpio_ich
Oct 16 18:27:04 localhost kernel: ahci 0000:00:1f.2: version 3.0
Oct 16 18:27:04 localhost kernel: ahci 0000:00:1f.2: irq 47 for MSI/MSI-X
Oct 16 18:27:04 localhost kernel: ahci: SSS flag set, parallel bus scan disabled
Oct 16 18:27:04 localhost kernel: ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x37 impl SATA mode
Oct 16 18:27:04 localhost kernel: ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ems sxs apst 
Oct 16 18:27:04 localhost kernel: ahci 0000:00:1f.2: setting latency timer to 64
Oct 16 18:27:04 localhost kernel: scsi0 : ahci
Oct 16 18:27:04 localhost kernel: scsi1 : ahci
Oct 16 18:27:04 localhost kernel: scsi2 : ahci
Oct 16 18:27:04 localhost kernel: scsi3 : ahci
Oct 16 18:27:04 localhost kernel: scsi4 : ahci
Oct 16 18:27:04 localhost kernel: scsi5 : ahci
Oct 16 18:27:04 localhost kernel: ata1: SATA max UDMA/133 abar m2048@0xd7527000 port 0xd7527100 irq 47
Oct 16 18:27:04 localhost kernel: ata2: SATA max UDMA/133 abar m2048@0xd7527000 port 0xd7527180 irq 47
Oct 16 18:27:04 localhost kernel: ata3: SATA max UDMA/133 abar m2048@0xd7527000 port 0xd7527200 irq 47
Oct 16 18:27:04 localhost kernel: ata4: DUMMY
Oct 16 18:27:04 localhost kernel: ata5: SATA max UDMA/133 abar m2048@0xd7527000 port 0xd7527300 irq 47
Oct 16 18:27:04 localhost kernel: ata6: SATA max UDMA/133 abar m2048@0xd7527000 port 0xd7527380 irq 47
Oct 16 18:27:04 localhost kernel: r852 0000:46:06.3: setting latency timer to 64
Oct 16 18:27:04 localhost kernel: r852: driver loaded successfully
Oct 16 18:27:04 localhost kernel: tun: Universal TUN/TAP device driver, 1.6
Oct 16 18:27:04 localhost kernel: tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Oct 16 18:27:04 localhost kernel: e1000e: Intel(R) PRO/1000 Network Driver - 2.1.4-k
Oct 16 18:27:04 localhost kernel: e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
Oct 16 18:27:04 localhost kernel: e1000e 0000:00:19.0: setting latency timer to 64
Oct 16 18:27:04 localhost kernel: e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
Oct 16 18:27:04 localhost kernel: e1000e 0000:00:19.0: irq 48 for MSI/MSI-X
Oct 16 18:27:04 localhost kernel: e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 68:b5:99:f2:f0:3d
Oct 16 18:27:04 localhost kernel: e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
Oct 16 18:27:04 localhost kernel: e1000e 0000:00:19.0 eth0: MAC: 9, PHY: 10, PBA No: 2052FF-0FF
Oct 16 18:27:04 localhost kernel: Intel(R) Wireless WiFi driver for Linux, in-tree:
Oct 16 18:27:04 localhost kernel: Copyright(c) 2003-2012 Intel Corporation
Oct 16 18:27:04 localhost kernel: iwlwifi 0000:44:00.0: pci_resource_len = 0x00002000
Oct 16 18:27:04 localhost kernel: iwlwifi 0000:44:00.0: pci_resource_base = ffffc900115f0000
Oct 16 18:27:04 localhost kernel: iwlwifi 0000:44:00.0: HW Revision ID = 0x35
Oct 16 18:27:04 localhost kernel: iwlwifi 0000:44:00.0: irq 49 for MSI/MSI-X
Oct 16 18:27:04 localhost kernel: iwldvm: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
Oct 16 18:27:04 localhost kernel: iwldvm: Copyright(c) 2003-2012 Intel Corporation
Oct 16 18:27:04 localhost kernel: usbcore: registered new interface driver asix
Oct 16 18:27:04 localhost kernel: yenta_cardbus 0000:46:06.4: CardBus bridge found [103c:1521]
Oct 16 18:27:04 localhost kernel: ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Oct 16 18:27:04 localhost kernel: ata1.00: unexpected _GTF length (8)
Oct 16 18:27:04 localhost kernel: ata1.00: ATA-8: ST93205620AS, SD28, max UDMA/133
Oct 16 18:27:04 localhost kernel: ata1.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
Oct 16 18:27:04 localhost kernel: ata1.00: failed to get Identify Device Data, Emask 0x1
Oct 16 18:27:04 localhost kernel: ata1.00: unexpected _GTF length (8)
Oct 16 18:27:04 localhost kernel: ata1.00: failed to get Identify Device Data, Emask 0x1
Oct 16 18:27:04 localhost kernel: ata1.00: configured for UDMA/133
Oct 16 18:27:04 localhost kernel: scsi 0:0:0:0: Direct-Access     ATA      ST93205620AS     SD28 PQ: 0 ANSI: 5
Oct 16 18:27:04 localhost kernel: sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
Oct 16 18:27:04 localhost kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
Oct 16 18:27:04 localhost kernel: sd 0:0:0:0: [sda] Write Protect is off
Oct 16 18:27:04 localhost kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Oct 16 18:27:04 localhost kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct 16 18:27:04 localhost kernel: sda: sda1
Oct 16 18:27:04 localhost kernel: sd 0:0:0:0: [sda] Attached SCSI disk
Oct 16 18:27:04 localhost kernel: ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Oct 16 18:27:04 localhost kernel: ata2.00: unexpected _GTF length (8)
Oct 16 18:27:04 localhost kernel: ata2.00: ATAPI: hp BD-ROM BC-5501H, 2.90, max UDMA/100
Oct 16 18:27:04 localhost kernel: ata2.00: unexpected _GTF length (8)
Oct 16 18:27:04 localhost kernel: ata2.00: configured for UDMA/100
Oct 16 18:27:04 localhost kernel: scsi 1:0:0:0: CD-ROM            hp       BD ROM BC-5501H  2.90 PQ: 0 ANSI: 5
Oct 16 18:27:04 localhost kernel: sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Oct 16 18:27:04 localhost kernel: cdrom: Uniform CD-ROM driver Revision: 3.20
Oct 16 18:27:04 localhost kernel: sr 1:0:0:0: Attached scsi CD-ROM sr0
Oct 16 18:27:04 localhost kernel: sr 1:0:0:0: Attached scsi generic sg1 type 5
Oct 16 18:27:04 localhost kernel: ACPI: Invalid Power Resource to register!
Oct 16 18:27:04 localhost kernel: ACPI: Invalid Power Resource to register!<6>ata3: SATA link down (SStatus 0 SControl 300)
Oct 16 18:27:04 localhost kernel: ata5: SATA link down (SStatus 0 SControl 300)
Oct 16 18:27:04 localhost kernel: ata6: SATA link down (SStatus 0 SControl 300)
Oct 16 18:27:04 localhost kernel: yenta_cardbus 0000:46:06.4: ISA IRQ mask 0x0cb8, PCI irq 22
Oct 16 18:27:04 localhost kernel: yenta_cardbus 0000:46:06.4: Socket status: 30000810
Oct 16 18:27:04 localhost kernel: pci_bus 0000:46: Raising subordinate bus# of parent bus (#46) from #47 to #4a
Oct 16 18:27:04 localhost kernel: yenta_cardbus 0000:46:06.4: pcmcia: parent PCI bridge window: [io  0x2000-0x2fff]
Oct 16 18:27:04 localhost kernel: yenta_cardbus 0000:46:06.4: pcmcia: parent PCI bridge window: [mem 0xd3100000-0xd31fffff]
Oct 16 18:27:04 localhost kernel: pcmcia_socket pcmcia_socket0: cs: memory probe 0xd3100000-0xd31fffff:
Oct 16 18:27:04 localhost kernel: excluding 0xd3100000-0xd310ffff
Oct 16 18:27:04 localhost kernel: yenta_cardbus 0000:46:06.4: pcmcia: parent PCI bridge window: [mem 0xd8000000-0xdbffffff pref]
Oct 16 18:27:04 localhost kernel: pcmcia_socket pcmcia_socket0: cs: memory probe 0xd8000000-0xdbffffff:
Oct 16 18:27:04 localhost kernel: excluding 0xd8000000-0xdbffffff
Oct 16 18:27:04 localhost kernel: ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Oct 16 18:27:04 localhost kernel: ehci_hcd 0000:00:1a.0: setting latency timer to 64
Oct 16 18:27:04 localhost kernel: ehci_hcd 0000:00:1a.0: EHCI Host Controller
Oct 16 18:27:04 localhost kernel: ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
Oct 16 18:27:04 localhost kernel: ehci_hcd 0000:00:1a.0: debug port 2
Oct 16 18:27:04 localhost kernel: ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
Oct 16 18:27:04 localhost kernel: ehci_hcd 0000:00:1a.0: irq 16, io mem 0xd7529000
Oct 16 18:27:04 localhost kernel: ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
Oct 16 18:27:04 localhost kernel: usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
Oct 16 18:27:04 localhost kernel: usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct 16 18:27:04 localhost kernel: usb usb1: Product: EHCI Host Controller
Oct 16 18:27:04 localhost kernel: usb usb1: Manufacturer: Linux 3.7.0-rc1 ehci_hcd
Oct 16 18:27:04 localhost kernel: usb usb1: SerialNumber: 0000:00:1a.0
Oct 16 18:27:04 localhost kernel: hub 1-0:1.0: USB hub found
Oct 16 18:27:04 localhost kernel: hub 1-0:1.0: 3 ports detected
Oct 16 18:27:04 localhost kernel: ehci_hcd 0000:00:1d.0: setting latency timer to 64
Oct 16 18:27:04 localhost kernel: ehci_hcd 0000:00:1d.0: EHCI Host Controller
Oct 16 18:27:04 localhost kernel: ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
Oct 16 18:27:04 localhost kernel: ehci_hcd 0000:00:1d.0: debug port 2
Oct 16 18:27:04 localhost kernel: ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
Oct 16 18:27:04 localhost kernel: ehci_hcd 0000:00:1d.0: irq 20, io mem 0xd7528000
Oct 16 18:27:04 localhost kernel: ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
Oct 16 18:27:04 localhost kernel: usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
Oct 16 18:27:04 localhost kernel: usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct 16 18:27:04 localhost kernel: usb usb2: Product: EHCI Host Controller
Oct 16 18:27:04 localhost kernel: usb usb2: Manufacturer: Linux 3.7.0-rc1 ehci_hcd
Oct 16 18:27:04 localhost kernel: usb usb2: SerialNumber: 0000:00:1d.0
Oct 16 18:27:04 localhost kernel: hub 2-0:1.0: USB hub found
Oct 16 18:27:04 localhost kernel: hub 2-0:1.0: 3 ports detected
Oct 16 18:27:04 localhost kernel: xhci_hcd 0000:45:00.0: xHCI Host Controller
Oct 16 18:27:04 localhost kernel: xhci_hcd 0000:45:00.0: new USB bus registered, assigned bus number 3
Oct 16 18:27:04 localhost kernel: xhci_hcd 0000:45:00.0: irq 19, io mem 0xd3200000
Oct 16 18:27:04 localhost kernel: xhci_hcd 0000:45:00.0: irq 50 for MSI/MSI-X
Oct 16 18:27:04 localhost kernel: xhci_hcd 0000:45:00.0: irq 51 for MSI/MSI-X
Oct 16 18:27:04 localhost kernel: xhci_hcd 0000:45:00.0: irq 52 for MSI/MSI-X
Oct 16 18:27:04 localhost kernel: xhci_hcd 0000:45:00.0: irq 53 for MSI/MSI-X
Oct 16 18:27:04 localhost kernel: xhci_hcd 0000:45:00.0: irq 54 for MSI/MSI-X
Oct 16 18:27:04 localhost kernel: usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
Oct 16 18:27:04 localhost kernel: usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct 16 18:27:04 localhost kernel: usb usb3: Product: xHCI Host Controller
Oct 16 18:27:04 localhost kernel: usb usb3: Manufacturer: Linux 3.7.0-rc1 xhci_hcd
Oct 16 18:27:04 localhost kernel: usb usb3: SerialNumber: 0000:45:00.0
Oct 16 18:27:04 localhost kernel: xHCI xhci_add_endpoint called for root hub
Oct 16 18:27:04 localhost kernel: xHCI xhci_check_bandwidth called for root hub
Oct 16 18:27:04 localhost kernel: hub 3-0:1.0: USB hub found
Oct 16 18:27:04 localhost kernel: hub 3-0:1.0: 2 ports detected
Oct 16 18:27:04 localhost kernel: xhci_hcd 0000:45:00.0: xHCI Host Controller
Oct 16 18:27:04 localhost kernel: xhci_hcd 0000:45:00.0: new USB bus registered, assigned bus number 4
Oct 16 18:27:04 localhost kernel: usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
Oct 16 18:27:04 localhost kernel: usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct 16 18:27:04 localhost kernel: usb usb4: Product: xHCI Host Controller
Oct 16 18:27:04 localhost kernel: usb usb4: Manufacturer: Linux 3.7.0-rc1 xhci_hcd
Oct 16 18:27:04 localhost kernel: usb usb4: SerialNumber: 0000:45:00.0
Oct 16 18:27:04 localhost kernel: xHCI xhci_add_endpoint called for root hub
Oct 16 18:27:04 localhost kernel: xHCI xhci_check_bandwidth called for root hub
Oct 16 18:27:04 localhost kernel: hub 4-0:1.0: USB hub found
Oct 16 18:27:04 localhost kernel: hub 4-0:1.0: 2 ports detected
Oct 16 18:27:04 localhost kernel: Initializing USB Mass Storage driver...
Oct 16 18:27:04 localhost kernel: usbcore: registered new interface driver usb-storage
Oct 16 18:27:04 localhost kernel: USB Mass Storage support registered.
Oct 16 18:27:04 localhost kernel: usbcore: registered new interface driver usbserial
Oct 16 18:27:04 localhost kernel: usbcore: registered new interface driver usbserial_generic
Oct 16 18:27:04 localhost kernel: usbserial: USB Serial support registered for generic
Oct 16 18:27:04 localhost kernel: i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
Oct 16 18:27:04 localhost kernel: i8042: Detected active multiplexing controller, rev 1.1
Oct 16 18:27:04 localhost kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Oct 16 18:27:04 localhost kernel: serio: i8042 AUX0 port at 0x60,0x64 irq 12
Oct 16 18:27:04 localhost kernel: serio: i8042 AUX1 port at 0x60,0x64 irq 12
Oct 16 18:27:04 localhost kernel: serio: i8042 AUX2 port at 0x60,0x64 irq 12
Oct 16 18:27:04 localhost kernel: serio: i8042 AUX3 port at 0x60,0x64 irq 12
Oct 16 18:27:04 localhost kernel: mousedev: PS/2 mouse device common for all mice
Oct 16 18:27:04 localhost kernel: usbcore: registered new interface driver synaptics_usb
Oct 16 18:27:04 localhost kernel: rtc_cmos 00:08: RTC can wake from S4
Oct 16 18:27:04 localhost kernel: rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
Oct 16 18:27:04 localhost kernel: rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
Oct 16 18:27:04 localhost kernel: i2c /dev entries driver
Oct 16 18:27:04 localhost kernel: usbcore: registered new interface driver uvcvideo
Oct 16 18:27:04 localhost kernel: USB Video Class driver (1.1.1)
Oct 16 18:27:04 localhost kernel: iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
Oct 16 18:27:04 localhost kernel: iTCO_wdt: Found a QM57 TCO device (Version=2, TCOBASE=0x0460)
Oct 16 18:27:04 localhost kernel: iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
Oct 16 18:27:04 localhost kernel: iTCO_vendor_support: vendor-support=0
Oct 16 18:27:04 localhost kernel: usbcore: registered new interface driver btusb
Oct 16 18:27:04 localhost kernel: usbcore: registered new interface driver ath3k
Oct 16 18:27:04 localhost kernel: EDAC MC: Ver: 3.0.0
Oct 16 18:27:04 localhost kernel: cpuidle: using governor ladder
Oct 16 18:27:04 localhost kernel: cpuidle: using governor menu
Oct 16 18:27:04 localhost kernel: sdhci: Secure Digital Host Controller Interface driver
Oct 16 18:27:04 localhost kernel: sdhci: Copyright(c) Pierre Ossman
Oct 16 18:27:04 localhost kernel: sdhci-pci 0000:46:06.1: SDHCI controller found [1180:0822] (rev 25)
Oct 16 18:27:04 localhost kernel: input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
Oct 16 18:27:04 localhost kernel: sdhci-pci 0000:46:06.1: Will use DMA mode even though HW doesn't fully claim to support it.
Oct 16 18:27:04 localhost kernel: sdhci-pci 0000:46:06.1: setting latency timer to 64
Oct 16 18:27:04 localhost kernel: sdhci-pci 0000:46:06.1: Will use DMA mode even though HW doesn't fully claim to support it.
Oct 16 18:27:04 localhost kernel: Registered led device: mmc0::
Oct 16 18:27:04 localhost kernel: mmc0: SDHCI controller on PCI [0000:46:06.1] using DMA
Oct 16 18:27:04 localhost kernel: usbcore: registered new interface driver ushc
Oct 16 18:27:04 localhost kernel: r592 0000:46:06.2: setting latency timer to 64
Oct 16 18:27:04 localhost kernel: r592: driver successfully loaded
Oct 16 18:27:04 localhost kernel: EFI Variables Facility v0.08 2004-May-17
Oct 16 18:27:04 localhost kernel: usbcore: registered new interface driver usbhid
Oct 16 18:27:04 localhost kernel: usbhid: USB HID core driver
Oct 16 18:27:04 localhost kernel: hp_accel: hardware type NC854xx found
Oct 16 18:27:04 localhost kernel: lis3lv02d: 8 bits sensor found
Oct 16 18:27:04 localhost kernel: sdhci-pci 0000:46:06.1: Will use DMA mode even though HW doesn't fully claim to support it.
Oct 16 18:27:04 localhost kernel: input: ST LIS3LV02DL Accelerometer as /devices/platform/lis3lv02d/input/input4
Oct 16 18:27:04 localhost kernel: Registered led device: hp::hddprotect
Oct 16 18:27:04 localhost kernel: sdhci-pci 0000:46:06.1: Will use DMA mode even though HW doesn't fully claim to support it.
Oct 16 18:27:04 localhost kernel: usb 1-1: new high-speed USB device number 2 using ehci_hcd
Oct 16 18:27:04 localhost kernel: sdhci-pci 0000:46:06.1: Will use DMA mode even though HW doesn't fully claim to support it.
Oct 16 18:27:04 localhost kernel: sdhci-pci 0000:46:06.1: Will use DMA mode even though HW doesn't fully claim to support it.
Oct 16 18:27:04 localhost kernel: usb 1-1: New USB device found, idVendor=8087, idProduct=0020
Oct 16 18:27:04 localhost kernel: input: HP WMI hotkeys as /devices/virtual/input/input5
Oct 16 18:27:04 localhost kernel: usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Oct 16 18:27:04 localhost kernel: hub 1-1:1.0: USB hub found
Oct 16 18:27:04 localhost kernel: hub 1-1:1.0: 6 ports detected
Oct 16 18:27:04 localhost kernel: pcmcia_socket pcmcia_socket0: pccard: PCMCIA card inserted into slot 0
Oct 16 18:27:04 localhost kernel: pcmcia_socket pcmcia_socket0: cs: memory probe 0xd3110000-0xd31fffff:
Oct 16 18:27:04 localhost kernel: excluding 0xd31fe000-0xd320bfff
Oct 16 18:27:04 localhost kernel: pcmcia 0.0: pcmcia: registering new device pcmcia0.0 (IRQ: 22)
Oct 16 18:27:04 localhost kernel: usb 2-1: new high-speed USB device number 2 using ehci_hcd
Oct 16 18:27:04 localhost kernel: usb 2-1: New USB device found, idVendor=8087, idProduct=0020
Oct 16 18:27:04 localhost kernel: usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Oct 16 18:27:04 localhost kernel: hub 2-1:1.0: USB hub found
Oct 16 18:27:04 localhost kernel: hub 2-1:1.0: 8 ports detected
Oct 16 18:27:04 localhost kernel: input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input6
Oct 16 18:27:04 localhost kernel: usb 1-1.1: new full-speed USB device number 3 using ehci_hcd
Oct 16 18:27:04 localhost kernel: usb 1-1.1: New USB device found, idVendor=03f0, idProduct=231d
Oct 16 18:27:04 localhost kernel: usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Oct 16 18:27:04 localhost kernel: usb 1-1.1: Product: HP Integrated Module
Oct 16 18:27:04 localhost kernel: usb 1-1.1: Manufacturer: Broadcom Corp
Oct 16 18:27:04 localhost kernel: snd_hda_intel 0000:00:1b.0: irq 55 for MSI/MSI-X
Oct 16 18:27:04 localhost kernel: hda-codec: No codec parser is available
Oct 16 18:27:04 localhost kernel: input: HDA Intel MID Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
Oct 16 18:27:04 localhost kernel: input: HDA Intel MID Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
Oct 16 18:27:04 localhost kernel: input: HDA Intel MID Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
Oct 16 18:27:04 localhost kernel: input: HDA Intel MID Dock Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
Oct 16 18:27:04 localhost kernel: hda_intel: Disabling MSI
Oct 16 18:27:04 localhost kernel: usb 1-1.3: new full-speed USB device number 4 using ehci_hcd
Oct 16 18:27:04 localhost kernel: usb 1-1.3: New USB device found, idVendor=138a, idProduct=0007
Oct 16 18:27:04 localhost kernel: usb 1-1.3: New USB device strings: Mfr=0, Product=0, SerialNumber=1
Oct 16 18:27:04 localhost kernel: usb 1-1.3: SerialNumber: 0030b05b7486
Oct 16 18:27:04 localhost kernel: usb 1-1.4: new high-speed USB device number 5 using ehci_hcd
Oct 16 18:27:04 localhost kernel: usb 1-1.4: New USB device found, idVendor=0424, idProduct=2514
Oct 16 18:27:04 localhost kernel: usb 1-1.4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Oct 16 18:27:04 localhost kernel: hub 1-1.4:1.0: USB hub found
Oct 16 18:27:04 localhost kernel: hub 1-1.4:1.0: 4 ports detected
Oct 16 18:27:04 localhost kernel: usb 1-1.5: new high-speed USB device number 6 using ehci_hcd
Oct 16 18:27:04 localhost kernel: psmouse serio4: synaptics: Touchpad model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd44773/0xa40000/0xa0000, board id: 3655, fw id: 651432
Oct 16 18:27:04 localhost kernel: input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input11
Oct 16 18:27:04 localhost kernel: usb 1-1.5: New USB device found, idVendor=04f2, idProduct=b15e
Oct 16 18:27:04 localhost kernel: usb 1-1.5: New USB device strings: Mfr=2, Product=1, SerialNumber=0
Oct 16 18:27:04 localhost kernel: usb 1-1.5: Product: HP Webcam [2 MP Macro]
Oct 16 18:27:04 localhost kernel: usb 1-1.5: Manufacturer: Chicony Electronics Co., Ltd.
Oct 16 18:27:04 localhost kernel: uvcvideo: Found UVC 1.00 device HP Webcam [2 MP Macro] (04f2:b15e)
Oct 16 18:27:04 localhost kernel: hda-codec: No codec parser is available
Oct 16 18:27:04 localhost kernel: hda-codec: No codec parser is available
Oct 16 18:27:04 localhost kernel: input: HP Webcam [2 MP Macro] as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5:1.0/input/input12
Oct 16 18:27:04 localhost kernel: hda-codec: No codec parser is available
Oct 16 18:27:04 localhost kernel: hda-codec: No codec parser is available
Oct 16 18:27:04 localhost kernel: u32 classifier
Oct 16 18:27:04 localhost kernel: Netfilter messages via NETLINK v0.30.
Oct 16 18:27:04 localhost kernel: nfnl_acct: registering with nfnetlink.
Oct 16 18:27:04 localhost kernel: nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
Oct 16 18:27:04 localhost kernel: ctnetlink v0.93: registering with nfnetlink.
Oct 16 18:27:04 localhost kernel: ip_tables: (C) 2000-2006 Netfilter Core Team
Oct 16 18:27:04 localhost kernel: TCP: cubic registered
Oct 16 18:27:04 localhost kernel: Initializing XFRM netlink socket
Oct 16 18:27:04 localhost kernel: NET: Registered protocol family 10
Oct 16 18:27:04 localhost kernel: ip6_tables: (C) 2000-2006 Netfilter Core Team
Oct 16 18:27:04 localhost kernel: NET: Registered protocol family 17
Oct 16 18:27:04 localhost kernel: NET: Registered protocol family 15
Oct 16 18:27:04 localhost kernel: Bridge firewalling registered
Oct 16 18:27:04 localhost kernel: Bluetooth: RFCOMM socket layer initialized
Oct 16 18:27:04 localhost kernel: Bluetooth: RFCOMM ver 1.11
Oct 16 18:27:04 localhost kernel: Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Oct 16 18:27:04 localhost kernel: Bluetooth: HIDP socket layer initialized
Oct 16 18:27:04 localhost kernel: 8021q: 802.1Q VLAN Support v1.8
Oct 16 18:27:04 localhost kernel: Key type dns_resolver registered
Oct 16 18:27:04 localhost kernel: registered taskstats version 1
Oct 16 18:27:04 localhost kernel: rtc_cmos 00:08: setting system clock to 2012-10-16 16:27:00 UTC (1350404820)
Oct 16 18:27:04 localhost kernel: ALSA device list:
Oct 16 18:27:04 localhost kernel: #0: HDA Intel MID at 0xd7520000 irq 55
Oct 16 18:27:04 localhost kernel: #1: HDA NVidia at 0xd3000000 irq 17
Oct 16 18:27:04 localhost kernel: usb 1-1.4.3: new low-speed USB device number 7 using ehci_hcd
Oct 16 18:27:04 localhost kernel: EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
Oct 16 18:27:04 localhost kernel: VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
Oct 16 18:27:04 localhost kernel: devtmpfs: mounted
Oct 16 18:27:04 localhost kernel: Freeing unused kernel memory: 836k freed
Oct 16 18:27:04 localhost kernel: usb 1-1.4.3: New USB device found, idVendor=046d, idProduct=c30e
Oct 16 18:27:04 localhost kernel: usb 1-1.4.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Oct 16 18:27:04 localhost kernel: usb 1-1.4.3: Product: HID compliant keyboard
Oct 16 18:27:04 localhost kernel: usb 1-1.4.3: Manufacturer: Logitech
Oct 16 18:27:04 localhost kernel: input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4.3/1-1.4.3:1.0/input/input13
Oct 16 18:27:04 localhost kernel: hid-generic 0003:046D:C30E.0001: input,hidraw0: USB HID v1.10 Keyboard [Logitech HID compliant keyboard] on usb-0000:00:1a.0-1.4.3/input0
Oct 16 18:27:04 localhost kernel: input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4.3/1-1.4.3:1.1/input/input14
Oct 16 18:27:04 localhost kernel: hid-generic 0003:046D:C30E.0002: input,hidraw1: USB HID v1.10 Device [Logitech HID compliant keyboard] on usb-0000:00:1a.0-1.4.3/input1
Oct 16 18:27:04 localhost kernel: usb 1-1.4.4: new low-speed USB device number 8 using ehci_hcd
Oct 16 18:27:04 localhost kernel: usb 1-1.4.4: New USB device found, idVendor=046d, idProduct=c03f
Oct 16 18:27:04 localhost kernel: usb 1-1.4.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Oct 16 18:27:04 localhost kernel: usb 1-1.4.4: Product: USB-PS/2 Optical Mouse
Oct 16 18:27:04 localhost kernel: usb 1-1.4.4: Manufacturer: Logitech
Oct 16 18:27:04 localhost kernel: input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4.4/1-1.4.4:1.0/input/input15
Oct 16 18:27:04 localhost kernel: hid-generic 0003:046D:C03F.0003: input,hidraw2: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1a.0-1.4.4/input0
Oct 16 18:27:04 localhost udevd[1455]: starting version 171
Oct 16 18:27:04 localhost kernel: iwlwifi 0000:44:00.0: loaded firmware version 9.221.4.1 build 25532
Oct 16 18:27:04 localhost kernel: iwlwifi 0000:44:00.0: CONFIG_IWLWIFI_DEBUG disabled
Oct 16 18:27:04 localhost kernel: iwlwifi 0000:44:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
Oct 16 18:27:04 localhost kernel: iwlwifi 0000:44:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
Oct 16 18:27:04 localhost kernel: iwlwifi 0000:44:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
Oct 16 18:27:04 localhost kernel: iwlwifi 0000:44:00.0: CONFIG_IWLWIFI_P2P disabled
Oct 16 18:27:04 localhost kernel: iwlwifi 0000:44:00.0: Detected Intel(R) Centrino(R) Ultimate-N 6300 AGN, REV=0x74
Oct 16 18:27:04 localhost kernel: iwlwifi 0000:44:00.0: L1 Disabled; Enabling L0S
Oct 16 18:27:04 localhost kernel: iwlwifi 0000:44:00.0: RF_KILL bit toggled to disable radio.
Oct 16 18:27:04 localhost kernel: iwlwifi 0000:44:00.0: device EEPROM VER=0x436, CALIB=0x6
Oct 16 18:27:04 localhost kernel: iwlwifi 0000:44:00.0: Device SKU: 0x1F0
Oct 16 18:27:04 localhost kernel: iwlwifi 0000:44:00.0: Valid Tx ant: 0x7, Valid Rx ant: 0x7
Oct 16 18:27:04 localhost kernel: Registered led device: phy0-led
Oct 16 18:27:04 localhost kernel: ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
Oct 16 18:27:04 localhost kernel: microcode: CPU0 updated to revision 0x3, date = 2011-09-01
Oct 16 18:27:04 localhost kernel: microcode: CPU1 updated to revision 0x3, date = 2011-09-01
Oct 16 18:27:04 localhost kernel: microcode: CPU2 updated to revision 0x3, date = 2011-09-01
Oct 16 18:27:04 localhost kernel: microcode: CPU3 updated to revision 0x3, date = 2011-09-01
Oct 16 18:27:04 localhost kernel: EXT4-fs (sda1): re-mounted. Opts: (null)
Oct 16 18:27:06 localhost kernel: e1000e 0000:00:19.0: irq 48 for MSI/MSI-X
Oct 16 18:27:06 localhost kernel: e1000e 0000:00:19.0: irq 48 for MSI/MSI-X
Oct 16 18:27:06 localhost kernel: IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
Oct 16 18:27:08 localhost kernel: tty_init_dev: 35 callbacks suppressed
Oct 16 18:27:09 localhost kernel: e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx
Oct 16 18:27:09 localhost kernel: IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
Oct 16 18:27:09 localhost kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
Oct 16 18:27:09 localhost kernel: IP: [<ffffffff814429ee>] nouveau_channel_new+0x41e/0x670
Oct 16 18:27:09 localhost kernel: PGD 2300ab067 PUD 22d278067 PMD 0 
Oct 16 18:27:09 localhost kernel: Oops: 0000 [#1] PREEMPT SMP 
Oct 16 18:27:09 localhost kernel: Modules linked in:
Oct 16 18:27:09 localhost kernel: CPU 1 
Oct 16 18:27:09 localhost kernel: Pid: 2513, comm: X Not tainted 3.7.0-rc1 #1 Hewlett-Packard HP EliteBook 8540w/1521
Oct 16 18:27:09 localhost kernel: RIP: 0010:[<ffffffff814429ee>]  [<ffffffff814429ee>] nouveau_channel_new+0x41e/0x670
Oct 16 18:27:09 localhost kernel: RSP: 0018:ffff88022d301c68  EFLAGS: 00010202
Oct 16 18:27:09 localhost kernel: RAX: 0000000000000000 RBX: ffff880231ff9600 RCX: 0000000000000088
Oct 16 18:27:09 localhost kernel: RDX: ffffc9001484c08c RSI: ffffc9001484c08c RDI: ffff880231ff9600
Oct 16 18:27:09 localhost kernel: RBP: ffff88022d301ce8 R08: 000000000000ffff R09: 0000000000000000
Oct 16 18:27:09 localhost kernel: R10: 0000000000000010 R11: 000000000000000f R12: 0000000000000000
Oct 16 18:27:09 localhost kernel: R13: ffff880231f27400 R14: ffff88023009c300 R15: ffff88023009c300
Oct 16 18:27:09 localhost kernel: FS:  00007f9e14040880(0000) GS:ffff88023bc40000(0000) knlGS:0000000000000000
Oct 16 18:27:09 localhost kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Oct 16 18:27:09 localhost kernel: CR2: 0000000000000018 CR3: 0000000230b2f000 CR4: 00000000000007e0
Oct 16 18:27:09 localhost kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Oct 16 18:27:09 localhost kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct 16 18:27:09 localhost kernel: Process X (pid: 2513, threadinfo ffff88022d300000, task ffff880231e91b80)
Oct 16 18:27:09 localhost kernel: Stack:
Oct 16 18:27:09 localhost kernel: ffff88022d301cb0 ffff88023009c300 ffff88023009c3a8 ffff880231d1cc00
Oct 16 18:27:09 localhost kernel: d8000001d8000002 ffff88022d301c98 0000200000000000 0000000000000000
Oct 16 18:27:09 localhost kernel: 000000ffffffffff ffff88023220baa0 ffffffffffffffff ffff88022f5d6b00
Oct 16 18:27:09 localhost kernel: Call Trace:
Oct 16 18:27:09 localhost kernel: [<ffffffff8144ae7c>] nouveau_abi16_ioctl_channel_alloc+0x15c/0x360
Oct 16 18:27:09 localhost kernel: [<ffffffff813ab2e0>] drm_ioctl+0x2a0/0x4f0
Oct 16 18:27:09 localhost kernel: [<ffffffff8144ad20>] ? nouveau_abi16_ioctl_setparam+0x10/0x10
Oct 16 18:27:09 localhost kernel: [<ffffffff81076be4>] ? __do_page_fault+0x1c4/0x490
Oct 16 18:27:09 localhost kernel: [<ffffffff811995a7>] do_vfs_ioctl+0x97/0x4f0
Oct 16 18:27:09 localhost kernel: [<ffffffff81199a57>] sys_ioctl+0x57/0x90
Oct 16 18:27:09 localhost kernel: [<ffffffff81865e02>] system_call_fastpath+0x16/0x1b
Oct 16 18:27:09 localhost kernel: Code: e2 02 48 89 df e8 d3 02 00 00 8b 83 80 00 00 00 89 83 84 00 00 00 0f 1f 80 00 00 00 00 48 8b 43 08 48 89 df 48 8b 80 f8 06 00 00 <ff> 50 18 41 89 c4 85 c0 0f 84 65 fd ff ff 0f 1f 40 00 4c 89 ff 
Oct 16 18:27:09 localhost kernel: RIP  [<ffffffff814429ee>] nouveau_channel_new+0x41e/0x670
Oct 16 18:27:09 localhost kernel: RSP <ffff88022d301c68>
Oct 16 18:27:09 localhost kernel: CR2: 0000000000000018
Oct 16 18:27:09 localhost kernel: ---[ end trace 8a50aa30bad8067b ]---
Oct 16 18:27:09 localhost kernel: [drm:drm_release] *ERROR* Device busy: 1
Oct 16 18:27:09 localhost kdm[2492]: X server died during startup
Oct 16 18:27:09 localhost kdm[2492]: X server for display :0 cannot be started, session disabled

--------------010403040801030602060608--
