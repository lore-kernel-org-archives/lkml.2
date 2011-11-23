Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337Ab1KWH26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 02:28:58 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:52687 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975Ab1KWH2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 02:28:55 -0500
Date: Wed, 23 Nov 2011 09:28:52 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Keith Packard <keithp@keithp.com>
cc: David Woodhouse <dwmw2@infradead.org>, dri-devel@lists.freedesktop.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: Bisected regression: hang on i915 between 3.1.0-rc9 and 3.1.0
In-Reply-To: <86vcqcf3da.fsf@sumi.keithp.com>
Message-ID: <alpine.SOC.1.00.1111230911390.12655@math.ut.ee>
References: <alpine.SOC.1.00.1111221207090.6490@math.ut.ee> <alpine.SOC.1.00.1111221306410.8925@math.ut.ee> <86vcqcf3da.fsf@sumi.keithp.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > 3.0 worked fine, 3.1-rc9 worked fine, I think -rc10 too. 3.1 release 
> > > hangs in random places while using X.

Also found out that 3.1-rc10 was already bad, will redo the bisect but 
it takes days sinc I'm not at the machine most of the time.

> Do you have VT-d enabled in the BIOS?

Yes, VT-x and VT-d are both enabled from BIOS setup.

Also, bootup dmesg from 3.2-rc2+git from when it failed silently:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.2.0-rc2-00369-gbbbc479 (mroos@prometheus) (gcc version 4.6.2 (Debian 4.6.2-4) ) #14 SMP Tue Nov 22 12:41:30 EET 2011
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.2.0-rc2-00369-gbbbc479 root=/dev/sda1 ro
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000db7ac440 (usable)
[    0.000000]  BIOS-e820: 00000000db7ac440 - 00000000db7ae4a0 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000db7ae4a0 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f4000000 - 00000000f8000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fe000000 - 00000000fed40000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed45000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000118000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: Hewlett-Packard HP Compaq 8100 Elite SFF PC/304Ah, BIOS 786H1 v01.05 06/09/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x118000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-E3FFF write-protect
[    0.000000]   E4000-EFFFF write-back
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 0DB800000 mask FFF800000 uncachable
[    0.000000]   2 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   3 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000db800000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xdb7ac max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f9bf0] f9bf0
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000db7ac000
[    0.000000]  0000000000 - 00db600000 page 2M
[    0.000000]  00db600000 - 00db7ac000 page 4k
[    0.000000] kernel direct mapping tables up to db7ac000 @ 1fffa000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-0000000118000000
[    0.000000]  0100000000 - 0118000000 page 2M
[    0.000000] kernel direct mapping tables up to 118000000 @ db7a6000-db7ac000
[    0.000000] ACPI: RSDP 00000000000e5210 00014 (v00 COMPAQ)
[    0.000000] ACPI: RSDT 00000000db7d0540 00044 (v01 HPQOEM SLIC-BPC 20100609      00000000)
[    0.000000] ACPI: FACP 00000000db7d05e8 00074 (v01 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI Warning: Optional field Pm2ControlBlock has zero address or length: 0x0000000000000050/0x0 (20110623/tbfadt-560)
[    0.000000] ACPI Warning: Invalid length for Pm2ControlBlock: 0, using default 8 (20110623/tbfadt-610)
[    0.000000] ACPI: DSDT 00000000db7d0a4f 0A69E (v01 COMPAQ DSDT_PRJ 00000001 MSFT 0100000E)
[    0.000000] ACPI: FACS 00000000db7d0500 00040
[    0.000000] ACPI: APIC 00000000db7d065c 000BC (v01 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI: ASF! 00000000db7d0718 00063 (v32 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI: MCFG 00000000db7d077b 0003C (v01 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI: TCPA 00000000db7d07b7 00032 (v01 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI: SLIC 00000000db7d07e9 00176 (v01 HPQOEM SLIC-BPC 00000001      00000000)
[    0.000000] ACPI: HPET 00000000db7d095f 00038 (v01 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI: DMAR 00000000db7d0997 000B8 (v01 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880113800000-ffff8801175fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00118000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000db7ac
[    0.000000]     0: 0x00100000 -> 0x00118000
[    0.000000] On node 0 totalpages: 997179
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3914 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 878572 pages, LIFO batch:31
[    0.000000]   Normal zone: 1536 pages used for memmap
[    0.000000]   Normal zone: 96768 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xf808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e8000
[    0.000000] PM: Registered nosave memory: 00000000000e8000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000db7ac000 - 00000000db7ad000
[    0.000000] PM: Registered nosave memory: 00000000db7ad000 - 00000000db7ae000
[    0.000000] PM: Registered nosave memory: 00000000db7ae000 - 00000000db7af000
[    0.000000] PM: Registered nosave memory: 00000000db7af000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f4000000
[    0.000000] PM: Registered nosave memory: 00000000f4000000 - 00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fe000000
[    0.000000] PM: Registered nosave memory: 00000000fe000000 - 00000000fed40000
[    0.000000] PM: Registered nosave memory: 00000000fed40000 - 00000000fed45000
[    0.000000] PM: Registered nosave memory: 00000000fed45000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at e0000000 (gap: e0000000:14000000)
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff880117c00000 s71040 r8192 d23168 u262144
[    0.000000] pcpu-alloc: s71040 r8192 d23168 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 979254
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.2.0-rc2-00369-gbbbc479 root=/dev/sda1 ro
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3844572k/4587520k available (3022k kernel code, 598804k absent, 144144k reserved, 3459k data, 440k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 32505856 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 3325.426 MHz processor.
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 6650.85 BogoMIPS (lpj=13301704)
[    0.000063] pid_max: default: 32768 minimum: 301
[    0.000122] Mount-cache hash table entries: 256
[    0.000238] Initializing cgroup subsys cpuacct
[    0.000269] Initializing cgroup subsys memory
[    0.000302] Initializing cgroup subsys devices
[    0.000330] Initializing cgroup subsys freezer
[    0.000358] Initializing cgroup subsys net_cls
[    0.000386] Initializing cgroup subsys blkio
[    0.000434] CPU: Physical Processor ID: 0
[    0.000460] CPU: Processor Core ID: 0
[    0.000489] mce: CPU supports 9 MCE banks
[    0.000522] CPU0: Thermal monitoring enabled (TM1)
[    0.000555] using mwait in idle threads.
[    0.000614] ACPI: Core revision 20110623
[    0.004653] DMAR: Host address width 36
[    0.004686] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.004727] IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c9008020e30272 ecap 1000
[    0.004786] DMAR: DRHD base: 0x000000fed91000 flags: 0x0
[    0.004824] IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c0000020230272 ecap 1000
[    0.004883] DMAR: DRHD base: 0x000000fed93000 flags: 0x1
[    0.004920] IOMMU 2: reg_base_addr fed93000 ver 1:0 cap c9008020630272 ecap 1000
[    0.004980] DMAR: RMRR base: 0x000000db7de000 end: 0x000000db7e7fff
[    0.005018] DMAR: RMRR base: 0x000000ddc00000 end: 0x000000dfffffff
[    0.005575] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.045174] CPU0: Intel(R) Core(TM) i5 CPU         660  @ 3.33GHz stepping 05
[    0.149160] Performance Events: PEBS fmt1+, Westmere events, Intel PMU driver.
[    0.149235] ... version:                3
[    0.149267] ... bit width:              48
[    0.149300] ... generic registers:      4
[    0.149333] ... value mask:             0000ffffffffffff
[    0.149369] ... max period:             000000007fffffff
[    0.149405] ... fixed-purpose events:   3
[    0.149437] ... event mask:             000000070000000f
[    0.149627] NMI watchdog enabled, takes one hw-pmu counter.
[    0.149714] Booting Node   0, Processors  #1
[    0.149733] smpboot cpu 1: start_ip = 9a000
[    0.256980] NMI watchdog enabled, takes one hw-pmu counter.
[    0.257083]  #2
[    0.257092] smpboot cpu 2: start_ip = 9a000
[    0.364619] NMI watchdog enabled, takes one hw-pmu counter.
[    0.364720]  #3
[    0.364728] smpboot cpu 3: start_ip = 9a000
[    0.472243] NMI watchdog enabled, takes one hw-pmu counter.
[    0.472306] Brought up 4 CPUs
[    0.472337] Total of 4 processors activated (26602.75 BogoMIPS).
[    0.473671] PM: Registering ACPI NVS region at db7ac440 (8288 bytes)
[    0.473757] NET: Registered protocol family 16
[    0.473847] ACPI: bus type pci registered
[    0.473922] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf4000000-0xf7ffffff] (base 0xf4000000)
[    0.473987] PCI: MMCONFIG at [mem 0xf4000000-0xf7ffffff] reserved in E820
[    0.477183] PCI: Using configuration type 1 for base access
[    0.477568] bio: create slab <bio-0> at 0
[    0.477647] ACPI: Added _OSI(Module Device)
[    0.477680] ACPI: Added _OSI(Processor Device)
[    0.477714] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.477748] ACPI: Added _OSI(Processor Aggregator Device)
[    0.478302] ACPI: EC: Look up EC in DSDT
[    0.524039] ACPI: SSDT 00000000db7dc771 003BA (v01 COMPAQ  CPU_TM2 00000001 MSFT 0100000E)
[    0.524283] ACPI: Dynamic OEM Table Load:
[    0.524324] ACPI: SSDT           (null) 003BA (v01 COMPAQ  CPU_TM2 00000001 MSFT 0100000E)
[    0.547961] ACPI: SSDT 00000000db7dc399 003D8 (v01 COMPAQ      CST 00000001 MSFT 0100000E)
[    0.548178] ACPI: Dynamic OEM Table Load:
[    0.548219] ACPI: SSDT           (null) 003D8 (v01 COMPAQ      CST 00000001 MSFT 0100000E)
[    0.584016] ACPI: Interpreter enabled
[    0.586040] ACPI: (supports S0 S3 S4 S5)
[    0.586099] ACPI: Using IOAPIC for interrupt routing
[    0.598065] ACPI: No dock devices found.
[    0.598100] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.607882] ACPI Error: [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS (20110623/dsfield-143)
[    0.607960] ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff880113431668), AE_ALREADY_EXISTS (20110623/psparse-536)
[    0.608050] ACPI: Marking method _OSC as Serialized because of AE_ALREADY_EXISTS error
[    0.608120] ACPI Warning: For \_SB_.PCI0._OSC: Parameter count mismatch - ASL declared 5, ACPI requires 4 (20110623/nspredef-359)
[    0.608200] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.608466] pci_root PNP0A08:00: host bridge window [mem 0xf8000000-0xfdffffff]
[    0.608527] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.608566] pci_root PNP0A08:00: host bridge window [io  0x1000-0x2fff]
[    0.608605] pci_root PNP0A08:00: host bridge window [io  0x3000-0x6fff]
[    0.608644] pci_root PNP0A08:00: host bridge window [io  0x7000-0xafff]
[    0.608683] pci_root PNP0A08:00: host bridge window [io  0xb000-0xffff]
[    0.608722] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.608782] pci_root PNP0A08:00: host bridge window [mem 0xe0000000-0xf3ffffff]
[    0.608841] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff]
[    0.608908] pci 0000:00:00.0: [8086:0040] type 0 class 0x000600
[    0.608921] DMAR: Disabling batched IOTLB flush on Ironlake
[    0.608968] pci 0000:00:02.0: [8086:0042] type 0 class 0x000300
[    0.608976] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf03fffff 64bit]
[    0.608980] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.608984] pci 0000:00:02.0: reg 20: [io  0x1170-0x1177]
[    0.609024] pci 0000:00:16.0: [8086:3b64] type 0 class 0x000780
[    0.609049] pci 0000:00:16.0: reg 10: [mem 0xf042a000-0xf042a00f 64bit]
[    0.609120] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.609124] pci 0000:00:16.0: PME# disabled
[    0.609141] pci 0000:00:16.3: [8086:3b67] type 0 class 0x000700
[    0.609155] pci 0000:00:16.3: reg 10: [io  0x1188-0x118f]
[    0.609162] pci 0000:00:16.3: reg 14: [mem 0xf0424000-0xf0424fff]
[    0.609234] pci 0000:00:19.0: [8086:10ef] type 0 class 0x000200
[    0.609247] pci 0000:00:19.0: reg 10: [mem 0xf0400000-0xf041ffff]
[    0.609254] pci 0000:00:19.0: reg 14: [mem 0xf0425000-0xf0425fff]
[    0.609260] pci 0000:00:19.0: reg 18: [io  0x1100-0x111f]
[    0.609297] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.609300] pci 0000:00:19.0: PME# disabled
[    0.609317] pci 0000:00:1a.0: [8086:3b3c] type 0 class 0x000c03
[    0.609334] pci 0000:00:1a.0: reg 10: [mem 0xf0427000-0xf04273ff]
[    0.609392] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.609395] pci 0000:00:1a.0: PME# disabled
[    0.609413] pci 0000:00:1b.0: [8086:3b56] type 0 class 0x000403
[    0.609425] pci 0000:00:1b.0: reg 10: [mem 0xf0420000-0xf0423fff 64bit]
[    0.609467] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.609469] pci 0000:00:1b.0: PME# disabled
[    0.609485] pci 0000:00:1c.0: [8086:3b42] type 1 class 0x000604
[    0.609526] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.609529] pci 0000:00:1c.0: PME# disabled
[    0.609547] pci 0000:00:1c.4: [8086:3b4a] type 1 class 0x000604
[    0.609587] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.609590] pci 0000:00:1c.4: PME# disabled
[    0.609606] pci 0000:00:1c.6: [8086:3b4e] type 1 class 0x000604
[    0.609646] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    0.609649] pci 0000:00:1c.6: PME# disabled
[    0.609670] pci 0000:00:1d.0: [8086:3b34] type 0 class 0x000c03
[    0.609686] pci 0000:00:1d.0: reg 10: [mem 0xf0428000-0xf04283ff]
[    0.609743] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.609746] pci 0000:00:1d.0: PME# disabled
[    0.609761] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    0.609802] pci 0000:00:1f.0: [8086:3b0a] type 0 class 0x000601
[    0.609894] pci 0000:00:1f.2: [8086:3b22] type 0 class 0x000106
[    0.609908] pci 0000:00:1f.2: reg 10: [io  0x1190-0x1197]
[    0.609914] pci 0000:00:1f.2: reg 14: [io  0x11a8-0x11ab]
[    0.609919] pci 0000:00:1f.2: reg 18: [io  0x1198-0x119f]
[    0.609925] pci 0000:00:1f.2: reg 1c: [io  0x11ac-0x11af]
[    0.609931] pci 0000:00:1f.2: reg 20: [io  0x1120-0x113f]
[    0.609937] pci 0000:00:1f.2: reg 24: [mem 0xf0426000-0xf04267ff]
[    0.609961] pci 0000:00:1f.2: PME# supported from D3hot
[    0.609963] pci 0000:00:1f.2: PME# disabled
[    0.610003] pci 0000:00:1c.0: PCI bridge to [bus 18-18]
[    0.610073] pci 0000:00:1c.4: PCI bridge to [bus 24-24]
[    0.610141] pci 0000:00:1c.6: PCI bridge to [bus 30-30]
[    0.610227] pci 0000:00:1e.0: PCI bridge to [bus 0d-0d] (subtractive decode)
[    0.610273] pci 0000:00:1e.0:   bridge window [mem 0xf8000000-0xfdffffff] (subtractive decode)
[    0.610275] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.610276] pci 0000:00:1e.0:   bridge window [io  0x1000-0x2fff] (subtractive decode)
[    0.610278] pci 0000:00:1e.0:   bridge window [io  0x3000-0x6fff] (subtractive decode)
[    0.610279] pci 0000:00:1e.0:   bridge window [io  0x7000-0xafff] (subtractive decode)
[    0.610281] pci 0000:00:1e.0:   bridge window [io  0xb000-0xffff] (subtractive decode)
[    0.610282] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.610284] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xf3ffffff] (subtractive decode)
[    0.610286] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
[    0.610299] pci_bus 0000:00: on NUMA node 0
[    0.610301] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.610415] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCX1._PRT]
[    0.610444] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCX5._PRT]
[    0.610472] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCX7._PRT]
[    0.610501] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB_._PRT]
[    0.610601] ACPI Error: [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS (20110623/dsfield-143)
[    0.610678] ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff880113431668), AE_ALREADY_EXISTS (20110623/psparse-536)
[    0.610768] ACPI Warning: For \_SB_.PCI0._OSC: Parameter count mismatch - ASL declared 5, ACPI requires 4 (20110623/nspredef-359)
[    0.610847]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.610914] ACPI Error: [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS (20110623/dsfield-143)
[    0.610990] ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff880113431668), AE_ALREADY_EXISTS (20110623/psparse-536)
[    0.611080] ACPI Warning: For \_SB_.PCI0._OSC: Parameter count mismatch - ASL declared 5, ACPI requires 4 (20110623/nspredef-359)
[    0.611159]  pci0000:00: ACPI _OSC request failed (AE_ALREADY_EXISTS), returned control mask: 0x1d
[    0.611222] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.614971] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 14 15)
[    0.615081] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 14 15)
[    0.615191] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 14 15)
[    0.615301] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 14 15)
[    0.615409] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *10 11 14 15)
[    0.615517] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 *11 14 15)
[    0.615626] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 14 15)
[    0.615738] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
[    0.615890] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.615954] vgaarb: loaded
[    0.615983] vgaarb: bridge control possible 0000:00:02.0
[    0.616054] SCSI subsystem initialized
[    0.616112] libata version 3.00 loaded.
[    0.616130] PCI: Using ACPI for IRQ routing
[    0.617266] PCI: Discovered peer bus 3f
[    0.617318] pci 0000:3f:00.0: [8086:2c61] type 0 class 0x000600
[    0.617331] pci 0000:3f:00.1: [8086:2d01] type 0 class 0x000600
[    0.617345] pci 0000:3f:02.0: [8086:2d10] type 0 class 0x000600
[    0.617356] pci 0000:3f:02.1: [8086:2d11] type 0 class 0x000600
[    0.617368] pci 0000:3f:02.2: [8086:2d12] type 0 class 0x000600
[    0.617379] pci 0000:3f:02.3: [8086:2d13] type 0 class 0x000600
[    0.617488] PCI: pci_cache_line_size set to 64 bytes
[    0.617525] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
[    0.617527] reserve RAM buffer: 00000000db7ac440 - 00000000dbffffff 
[    0.617592] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.617667] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.619707] Switching to clocksource hpet
[    0.619768] pnp: PnP ACPI init
[    0.619802] ACPI: bus type pnp registered
[    0.619953] pnp 00:00: [mem 0xf8000000-0xfdffffff window]
[    0.619955] pnp 00:00: [bus 00-ff]
[    0.619957] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.619958] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.619959] pnp 00:00: [io  0x1000-0x2fff window]
[    0.619960] pnp 00:00: [io  0x3000-0x6fff window]
[    0.619962] pnp 00:00: [io  0x7000-0xafff window]
[    0.619963] pnp 00:00: [io  0xb000-0xffff window]
[    0.619964] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.619966] pnp 00:00: [mem 0xe0000000-0xf3ffffff window]
[    0.619968] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.619995] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.620003] pnp 00:01: [io  0x00f0-0x00ff]
[    0.620009] pnp 00:01: [irq 13]
[    0.620024] pnp 00:01: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.620031] pnp 00:02: [io  0x0000-0x000f]
[    0.620032] pnp 00:02: [io  0x0080-0x008f]
[    0.620033] pnp 00:02: [io  0x00c0-0x00df]
[    0.620034] pnp 00:02: [dma 4]
[    0.620048] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.620053] pnp 00:03: [io  0x0070-0x0071]
[    0.620056] pnp 00:03: [irq 8]
[    0.620070] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.620075] pnp 00:04: [io  0x0061]
[    0.620089] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.620096] pnp 00:05: [irq 12]
[    0.620112] pnp 00:05: Plug and Play ACPI device, IDs PNP0f13 PNP0f0e (active)
[    0.620117] pnp 00:06: [io  0x0060]
[    0.620119] pnp 00:06: [io  0x0064]
[    0.620122] pnp 00:06: [irq 1]
[    0.620136] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.620299] pnp 00:07: [irq 7]
[    0.620300] pnp 00:07: [dma 3]
[    0.620301] pnp 00:07: [io  0x0378-0x037f]
[    0.620302] pnp 00:07: [io  0x0778-0x077d]
[    0.620348] pnp 00:07: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.620478] pnp 00:08: [irq 4]
[    0.620479] pnp 00:08: [io  0x03f8-0x03ff]
[    0.620522] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 PNP0500 (active)
[    0.620555] pnp 00:09: [mem 0xfec00000-0xfec00fff]
[    0.620570] pnp 00:09: Plug and Play ACPI device, IDs PNP0003 (active)
[    0.620576] pnp 00:0a: [io  0x004e-0x004f]
[    0.620577] pnp 00:0a: [io  0x0cb0-0x0cbb]
[    0.620578] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    0.620594] pnp 00:0a: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
[    0.620614] pnp 00:0b: [mem 0xfed00000-0xfed003ff]
[    0.620631] pnp 00:0b: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.620744] pnp 00:0c: [io  0x0010-0x001f]
[    0.620745] pnp 00:0c: [io  0x0050-0x0053]
[    0.620746] pnp 00:0c: [io  0x0072-0x0077]
[    0.620747] pnp 00:0c: [io  0x0090-0x009f]
[    0.620778] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.620790] pnp 00:0d: [io  0x04d0-0x04d1]
[    0.620819] system 00:0d: [io  0x04d0-0x04d1] has been reserved
[    0.620857] system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.620866] pnp 00:0e: [io  0x0400-0x041f]
[    0.620868] pnp 00:0e: [io  0x0420-0x043f]
[    0.620869] pnp 00:0e: [io  0x0440-0x045f]
[    0.620870] pnp 00:0e: [io  0x0460-0x047f]
[    0.620871] pnp 00:0e: [io  0x0480-0x048f]
[    0.620872] pnp 00:0e: [io  0xf800-0xf81f]
[    0.620873] pnp 00:0e: [io  0xf820-0xf83f]
[    0.620874] pnp 00:0e: [io  0xf840-0xf85f]
[    0.620875] pnp 00:0e: [io  0xf860-0xf87f]
[    0.620876] pnp 00:0e: [io  0xfa00-0xfa3f]
[    0.620877] pnp 00:0e: [io  0xfc00-0xfc7f]
[    0.620879] pnp 00:0e: [io  0xfc80-0xfcff]
[    0.620880] pnp 00:0e: [io  0xfe00-0xfe7f]
[    0.620881] pnp 00:0e: [io  0xfe80-0xfeff]
[    0.620913] system 00:0e: [io  0x0400-0x041f] has been reserved
[    0.620951] system 00:0e: [io  0x0420-0x043f] has been reserved
[    0.620988] system 00:0e: [io  0x0440-0x045f] has been reserved
[    0.621025] system 00:0e: [io  0x0460-0x047f] has been reserved
[    0.621063] system 00:0e: [io  0x0480-0x048f] has been reserved
[    0.621101] system 00:0e: [io  0xf800-0xf81f] has been reserved
[    0.621138] system 00:0e: [io  0xf820-0xf83f] has been reserved
[    0.621176] system 00:0e: [io  0xf840-0xf85f] has been reserved
[    0.621215] system 00:0e: [io  0xf860-0xf87f] has been reserved
[    0.621254] system 00:0e: [io  0xfa00-0xfa3f] has been reserved
[    0.621292] system 00:0e: [io  0xfc00-0xfc7f] has been reserved
[    0.621329] system 00:0e: [io  0xfc80-0xfcff] has been reserved
[    0.621367] system 00:0e: [io  0xfe00-0xfe7f] has been reserved
[    0.621404] system 00:0e: [io  0xfe80-0xfeff] has been reserved
[    0.621443] system 00:0e: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.627718] pnp 00:0f: [mem 0x00000000-0x0009ffff]
[    0.627720] pnp 00:0f: [mem 0x00100000-0xdfffffff]
[    0.627721] pnp 00:0f: [mem 0x000e4000-0x000fffff]
[    0.627722] pnp 00:0f: [mem 0xfec01000-0xfecfffff]
[    0.627724] pnp 00:0f: [mem 0xfed00400-0xfed3ffff]
[    0.627725] pnp 00:0f: [mem 0xfed45000-0xffffffff]
[    0.627726] pnp 00:0f: [mem 0xf4000000-0xf7ffffff]
[    0.627727] pnp 00:0f: [mem 0x000cec00-0x000e3fff]
[    0.627768] system 00:0f: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.627809] system 00:0f: [mem 0x00100000-0xdfffffff] could not be reserved
[    0.627850] system 00:0f: [mem 0x000e4000-0x000fffff] could not be reserved
[    0.627890] system 00:0f: [mem 0xfec01000-0xfecfffff] has been reserved
[    0.627929] system 00:0f: [mem 0xfed00400-0xfed3ffff] has been reserved
[    0.627969] system 00:0f: [mem 0xfed45000-0xffffffff] has been reserved
[    0.628008] system 00:0f: [mem 0xf4000000-0xf7ffffff] has been reserved
[    0.628047] system 00:0f: [mem 0x000cec00-0x000e3fff] has been reserved
[    0.628087] system 00:0f: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.628094] pnp: PnP ACPI: found 16 devices
[    0.628127] ACPI: ACPI bus type pnp unregistered
[    0.633369] PCI: max bus depth: 1 pci_try_num: 2
[    0.633392] pci 0000:00:1c.6: BAR 14: assigned [mem 0xf8000000-0xf81fffff]
[    0.633433] pci 0000:00:1c.6: BAR 15: assigned [mem 0xf8200000-0xf83fffff 64bit pref]
[    0.633495] pci 0000:00:1c.6: BAR 13: assigned [io  0x2000-0x2fff]
[    0.633533] pci 0000:00:1c.4: BAR 14: assigned [mem 0xf8400000-0xf85fffff]
[    0.633574] pci 0000:00:1c.4: BAR 15: assigned [mem 0xf8600000-0xf87fffff 64bit pref]
[    0.633635] pci 0000:00:1c.4: BAR 13: assigned [io  0x3000-0x3fff]
[    0.633673] pci 0000:00:1c.0: BAR 14: assigned [mem 0xf8800000-0xf89fffff]
[    0.633713] pci 0000:00:1c.0: BAR 15: assigned [mem 0xf8a00000-0xf8bfffff 64bit pref]
[    0.633774] pci 0000:00:1c.0: BAR 13: assigned [io  0x4000-0x4fff]
[    0.633813] pci 0000:00:1c.0: PCI bridge to [bus 18-18]
[    0.633849] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
[    0.633889] pci 0000:00:1c.0:   bridge window [mem 0xf8800000-0xf89fffff]
[    0.633930] pci 0000:00:1c.0:   bridge window [mem 0xf8a00000-0xf8bfffff 64bit pref]
[    0.633993] pci 0000:00:1c.4: PCI bridge to [bus 24-24]
[    0.634029] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.634069] pci 0000:00:1c.4:   bridge window [mem 0xf8400000-0xf85fffff]
[    0.634110] pci 0000:00:1c.4:   bridge window [mem 0xf8600000-0xf87fffff 64bit pref]
[    0.634173] pci 0000:00:1c.6: PCI bridge to [bus 30-30]
[    0.634209] pci 0000:00:1c.6:   bridge window [io  0x2000-0x2fff]
[    0.634248] pci 0000:00:1c.6:   bridge window [mem 0xf8000000-0xf81fffff]
[    0.634289] pci 0000:00:1c.6:   bridge window [mem 0xf8200000-0xf83fffff 64bit pref]
[    0.634352] pci 0000:00:1e.0: PCI bridge to [bus 0d-0d]
[    0.634402] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.634442] pci 0000:00:1c.0: setting latency timer to 64
[    0.634447] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.634487] pci 0000:00:1c.4: setting latency timer to 64
[    0.634493] pci 0000:00:1c.6: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    0.634534] pci 0000:00:1c.6: setting latency timer to 64
[    0.634538] pci 0000:00:1e.0: setting latency timer to 64
[    0.634540] pci_bus 0000:00: resource 4 [mem 0xf8000000-0xfdffffff]
[    0.634542] pci_bus 0000:00: resource 5 [io  0x0000-0x0cf7]
[    0.634543] pci_bus 0000:00: resource 6 [io  0x1000-0x2fff]
[    0.634545] pci_bus 0000:00: resource 7 [io  0x3000-0x6fff]
[    0.634546] pci_bus 0000:00: resource 8 [io  0x7000-0xafff]
[    0.634547] pci_bus 0000:00: resource 9 [io  0xb000-0xffff]
[    0.634548] pci_bus 0000:00: resource 10 [mem 0x000a0000-0x000bffff]
[    0.634550] pci_bus 0000:00: resource 11 [mem 0xe0000000-0xf3ffffff]
[    0.634551] pci_bus 0000:00: resource 12 [mem 0xfed40000-0xfed44fff]
[    0.634553] pci_bus 0000:18: resource 0 [io  0x4000-0x4fff]
[    0.634554] pci_bus 0000:18: resource 1 [mem 0xf8800000-0xf89fffff]
[    0.634555] pci_bus 0000:18: resource 2 [mem 0xf8a00000-0xf8bfffff 64bit pref]
[    0.634557] pci_bus 0000:24: resource 0 [io  0x3000-0x3fff]
[    0.634558] pci_bus 0000:24: resource 1 [mem 0xf8400000-0xf85fffff]
[    0.634559] pci_bus 0000:24: resource 2 [mem 0xf8600000-0xf87fffff 64bit pref]
[    0.634561] pci_bus 0000:30: resource 0 [io  0x2000-0x2fff]
[    0.634562] pci_bus 0000:30: resource 1 [mem 0xf8000000-0xf81fffff]
[    0.634564] pci_bus 0000:30: resource 2 [mem 0xf8200000-0xf83fffff 64bit pref]
[    0.634565] pci_bus 0000:0d: resource 4 [mem 0xf8000000-0xfdffffff]
[    0.634566] pci_bus 0000:0d: resource 5 [io  0x0000-0x0cf7]
[    0.634568] pci_bus 0000:0d: resource 6 [io  0x1000-0x2fff]
[    0.634569] pci_bus 0000:0d: resource 7 [io  0x3000-0x6fff]
[    0.634570] pci_bus 0000:0d: resource 8 [io  0x7000-0xafff]
[    0.634571] pci_bus 0000:0d: resource 9 [io  0xb000-0xffff]
[    0.634573] pci_bus 0000:0d: resource 10 [mem 0x000a0000-0x000bffff]
[    0.634574] pci_bus 0000:0d: resource 11 [mem 0xe0000000-0xf3ffffff]
[    0.634575] pci_bus 0000:0d: resource 12 [mem 0xfed40000-0xfed44fff]
[    0.634577] pci_bus 0000:3f: resource 0 [io  0x0000-0xffff]
[    0.634578] pci_bus 0000:3f: resource 1 [mem 0x00000000-0xfffffffff]
[    0.634595] NET: Registered protocol family 2
[    0.634652] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.634854] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.635610] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.635851] TCP: Hash tables configured (established 262144 bind 65536)
[    0.635890] TCP reno registered
[    0.635922] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.635971] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.636079] NET: Registered protocol family 1
[    0.636123] pci 0000:00:02.0: Boot video device
[    0.636185] PCI: CLS 64 bytes, default 64
[    0.636212] DMAR: No ATSR found
[    0.636294] IOMMU 1 0xfed91000: using Register based invalidation
[    0.636332] IOMMU 0 0xfed90000: using Register based invalidation
[    0.636369] IOMMU 2 0xfed93000: using Register based invalidation
[    0.636407] IOMMU: Setting RMRR:
[    0.636453] IOMMU: Setting identity map for device 0000:00:02.0 [0xddc00000 - 0xdfffffff]
[    0.636957] IOMMU: Setting identity map for device 0000:00:1d.0 [0xdb7de000 - 0xdb7e7fff]
[    0.637063] IOMMU: Setting identity map for device 0000:00:1a.0 [0xdb7de000 - 0xdb7e7fff]
[    0.637149] IOMMU: Prepare 0-16MiB unity mapping for LPC
[    0.637198] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
[    0.645129] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
[    0.653723] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.668146] VFS: Disk quotas dquot_6.5.2
[    0.668210] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.668473] msgmni has been set to 7637
[    0.668607] alg: No test for stdrng (krng)
[    0.668675] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.668752] io scheduler noop registered
[    0.668785] io scheduler deadline registered
[    0.668838] io scheduler cfq registered (default)
[    0.669068] intel_idle: MWAIT substates: 0x1120
[    0.669070] intel_idle: v0.4 model 0x25
[    0.669070] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.669119] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.689464] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.879376] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.879509] serial 0000:00:16.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.899703] 0000:00:16.3: ttyS1 at I/O 0x1188 (irq = 17) is a 16550A
[    0.899896] Linux agpgart interface v0.103
[    0.899960] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    0.900043] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    0.900687] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    0.900825] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    0.900928] ahci 0000:00:1f.2: version 3.0
[    0.900945] ahci 0000:00:1f.2: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[    0.901012] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    0.901059] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x17 impl SATA mode
[    0.901122] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part sxs apst 
[    0.901184] ahci 0000:00:1f.2: setting latency timer to 64
[    0.901615] scsi0 : ahci
[    0.901694] scsi1 : ahci
[    0.901763] scsi2 : ahci
[    0.903832] scsi3 : ahci
[    0.903903] scsi4 : ahci
[    0.903975] scsi5 : ahci
[    0.904094] ata1: SATA max UDMA/133 abar m2048@0xf0426000 port 0xf0426100 irq 43
[    0.904155] ata2: SATA max UDMA/133 abar m2048@0xf0426000 port 0xf0426180 irq 43
[    0.904215] ata3: SATA max UDMA/133 abar m2048@0xf0426000 port 0xf0426200 irq 43
[    0.904275] ata4: DUMMY
[    0.904304] ata5: SATA max UDMA/133 abar m2048@0xf0426000 port 0xf0426300 irq 43
[    0.904363] ata6: DUMMY
[    0.904457] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
[    0.907282] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.907321] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.907413] mousedev: PS/2 mouse device common for all mice
[    0.907478] rtc_cmos 00:03: RTC can wake from S4
[    0.907586] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.907644] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.907755] cpuidle: using governor ladder
[    0.907891] cpuidle: using governor menu
[    0.907978] TCP cubic registered
[    0.908077] NET: Registered protocol family 10
[    0.908206] Mobile IPv6
[    0.908236] NET: Registered protocol family 17
[    0.908271] Registering the dns_resolver key type
[    0.908357] PM: Hibernation image not present or could not be loaded.
[    0.908361] registered taskstats version 1
[    0.915458] rtc_cmos 00:03: setting system clock to 2011-11-22 10:49:29 UTC (1321958969)
[    1.221968] ata3: SATA link down (SStatus 0 SControl 300)
[    1.222032] ata5: SATA link down (SStatus 0 SControl 300)
[    1.222091] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.222157] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.223117] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[    1.223178] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
[    1.223411] ata1.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
[    1.223598] ata1.00: ACPI cmd e3/00:00:00:00:00:a0 (IDLE) succeeded
[    1.223604] ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.223672] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.223738] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.224383] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[    1.224449] ata2.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
[    1.224507] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.224568] ata2.00: ATAPI: hp       CDDVDW TS-H653T, H6D1, max UDMA/100
[    1.224782] ata1.00: ATA-8: Hitachi HDS721025CLA682, JP1OA41A, max UDMA/133
[    1.224830] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.225869] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[    1.225948] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
[    1.226210] ata1.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
[    1.226405] ata1.00: ACPI cmd e3/00:00:00:00:00:a0 (IDLE) succeeded
[    1.226412] ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.226482] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.226549] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.227143] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[    1.227210] ata2.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
[    1.227270] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.227327] ata2.00: configured for UDMA/100
[    1.227520] ata1.00: configured for UDMA/133
[    1.227934] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HDS72102 JP1O PQ: 0 ANSI: 5
[    1.228129] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    1.228289] sd 0:0:0:0: [sda] Write Protect is off
[    1.228330] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.228392] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.228700] scsi 1:0:0:0: CD-ROM            hp       CDDVDW TS-H653T  H6D1 PQ: 0 ANSI: 5
[    1.272823]  sda: sda1 sda2 < sda5 >
[    1.273439] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.351240] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    1.351307] VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
[    1.352039] Freeing unused kernel memory: 440k freed
[    1.352118] Write protecting the kernel read-only data: 6144k
[    1.354753] Freeing unused kernel memory: 1056k freed
[    1.357014] Freeing unused kernel memory: 892k freed
[    1.640660] Refined TSC clocksource calibration: 3325.374 MHz.
[    1.640707] Switching to clocksource tsc
[    3.996217] e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
[    3.996275] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    3.996343] e1000e 0000:00:19.0: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    3.996389] e1000e 0000:00:19.0: setting latency timer to 64
[    3.996453] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    4.013154] parport_pc 00:07: reported by Plug and Play ACPI
[    4.013245] parport0: PC-style at 0x378 (0x778), irq 7
[    4.013509] wmi: Mapper loaded
[    4.014063] , dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
[    4.033372] iTCO_vendor_support: vendor-support=0
[    4.033846] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
[    4.033961] iTCO_wdt: Found a Q57 TCO device (Version=2, TCOBASE=0xf860)
[    4.034041] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    4.094891] usbcore: registered new interface driver usbfs
[    4.094933] usbcore: registered new interface driver hub
[    4.094999] usbcore: registered new device driver usb
[    4.099531] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.119338] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    4.119403] ACPI: Power Button [PBTN]
[    4.119466] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    4.119527] ACPI: Power Button [PWRF]
[    4.120881] input: PC Speaker as /devices/platform/pcspkr/input/input2
[    4.148616] tpm_tis 00:0a: 1.2 TPM (device-id 0xB, rev-id 16)
[    4.153910] ACPI: Invalid PBLK length [7]
[    4.153977] ACPI: Invalid PBLK length [7]
[    4.154033] ACPI: Invalid PBLK length [7]
[    4.154090] ACPI: Invalid PBLK length [7]
[    4.185533] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 78:e3:b5:a0:e5:e4
[    4.185597] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    4.185670] e1000e 0000:00:19.0: eth0: MAC: 9, PHY: 9, PBA No: A002FF-0FF
[    4.185767] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.185827] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.185830] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    4.185868] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    4.185963] ehci_hcd 0000:00:1a.0: debug port 2
[    4.189954] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    4.189974] ehci_hcd 0000:00:1a.0: irq 20, io mem 0xf0427000
[    4.204852] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    4.204928] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    4.204973] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.205042] usb usb1: Product: EHCI Host Controller
[    4.205077] usb usb1: Manufacturer: Linux 3.2.0-rc2-00369-gbbbc479 ehci_hcd
[    4.205116] usb usb1: SerialNumber: 0000:00:1a.0
[    4.205210] hub 1-0:1.0: USB hub found
[    4.205245] hub 1-0:1.0: 3 ports detected
[    4.205324] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.205407] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.205409] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    4.205448] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    4.205538] ehci_hcd 0000:00:1d.0: debug port 2
[    4.209439] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    4.209443] ehci_hcd 0000:00:1d.0: irq 20, io mem 0xf0428000
[    4.224789] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    4.224930] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    4.224976] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.225035] usb usb2: Product: EHCI Host Controller
[    4.225070] usb usb2: Manufacturer: Linux 3.2.0-rc2-00369-gbbbc479 ehci_hcd
[    4.225110] usb usb2: SerialNumber: 0000:00:1d.0
[    4.225192] hub 2-0:1.0: USB hub found
[    4.225226] hub 2-0:1.0: 3 ports detected
[    4.289530] [drm] Initialized drm 1.1.0 20060810
[    4.302310] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.302353] i915 0000:00:02.0: setting latency timer to 64
[    4.319638] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
[    4.319700] [drm] MTRR allocation failed.  Graphics performance may suffer.
[    4.320069] i915 0000:00:02.0: irq 45 for MSI/MSI-X
[    4.320073] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    4.320112] [drm] Driver supports precise vblank timestamp query.
[    4.320169] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    4.486330] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
[    4.486395] cdrom: Uniform CD-ROM driver Revision: 3.20
[    4.486500] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    4.515867] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    4.596545] input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio1/input/input3
[    4.612473] fbcon: inteldrmfb (fb0) is primary device
[    4.648121] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
[    4.648125] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.648343] hub 1-1:1.0: USB hub found
[    4.648456] hub 1-1:1.0: 6 ports detected
[    4.759251] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    4.846370] Console: switching to colour frame buffer device 240x67
[    4.851937] fb0: inteldrmfb frame buffer device
[    4.851938] drm: registered panic notifier
[    4.852032] ACPI Exception: AE_NOT_FOUND, Evaluating _DOD (20110623/video-1147)
[    4.852111] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input4
[    4.852167] ACPI: Video Device [GFX0] (multi-head: no  rom: yes  post: no)
[    4.852234] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    4.852317] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    4.852417] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[    4.852435] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[    4.891090] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
[    4.891132] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.891376] hub 2-1:1.0: USB hub found
[    4.891438] hub 2-1:1.0: 8 ports detected
[    4.966814] usb 1-1.1: new high-speed USB device number 3 using ehci_hcd
[    5.031057] HDMI status: Codec=3 Pin=5 Presence_Detect=0 ELD_Valid=0
[    5.031267] input: HDA Intel HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input5
[    5.031425] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[    5.058758] usb 1-1.1: New USB device found, idVendor=0424, idProduct=2512
[    5.058847] usb 1-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.059124] hub 1-1.1:1.0: USB hub found
[    5.059327] hub 1-1.1:1.0: 2 ports detected
[    5.130178] usb 1-1.2: new low-speed USB device number 4 using ehci_hcd
[    5.247305] usb 1-1.2: New USB device found, idVendor=046d, idProduct=c30e
[    5.247378] usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.247427] usb 1-1.2: Product: HID compliant keyboard
[    5.247452] usb 1-1.2: Manufacturer: Logitech
[    5.681885] input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.0/input/input7
[    5.682015] generic-usb 0003:046D:C30E.0001: input,hidraw0: USB HID v1.10 Keyboard [Logitech HID compliant keyboard] on usb-0000:00:1a.0-1.2/input0
[    5.702668] input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.1/input/input8
[    5.702793] generic-usb 0003:046D:C30E.0002: input,hidraw1: USB HID v1.10 Device [Logitech HID compliant keyboard] on usb-0000:00:1a.0-1.2/input1
[    5.702863] usbcore: registered new interface driver usbhid
[    5.702900] usbhid: USB HID core driver
[    6.751230] Adding 7532540k swap on /dev/sda5.  Priority:-1 extents:1 across:7532540k 
[    6.754497] EXT4-fs (sda1): re-mounted. Opts: (null)
[    6.904826] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[    7.018654] loop: module loaded
[    8.762454] fuse init (API version 7.17)
[    9.066340] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    9.125913] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    9.126289] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    9.670661] microcode: CPU0 sig=0x20655, pf=0x2, revision=0x2
[    9.751924] microcode: CPU1 sig=0x20655, pf=0x2, revision=0x2
[    9.755430] microcode: CPU2 sig=0x20655, pf=0x2, revision=0x2
[    9.758865] microcode: CPU3 sig=0x20655, pf=0x2, revision=0x2
[    9.761764] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   10.582948] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: None
[   10.584633] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   10.586628] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   17.331458] lp0: using parport0 (interrupt-driven).
[   39.431271] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=0
[  293.184449] tun: Universal TUN/TAP device driver, 1.6
[  293.184452] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>

-- 
Meelis Roos (mroos@linux.ee)
