Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab2KLTaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 14:30:07 -0500
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:52622 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882Ab2KLT37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 14:29:59 -0500
Date: Mon, 12 Nov 2012 21:29:54 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
cc: dri-devel@lists.freedesktop.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>
Subject: WARNING: at drivers/gpu/drm/i915/intel_display.c:1009
 ironlake_crtc_disable+0xaf/0x8e0
Message-ID: <alpine.SOC.1.00.1211122120150.3649@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried 3.7-rc5 on an ironlale PC and got the warning in subject. The 
computer last ran 3.6.0 without any warnings. Second reboot showed the 
same warning plus a couple of EDID warnings (also below).


[    0.000000] Linux version 3.7.0-rc5 (mroos@prometheus) (gcc version 4.7.2 (Debian 4.7.2-4) ) #70 SMP Mon Nov 12 18:20:25 EET 2012
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.7.0-rc5 root=/dev/sda1 ro
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e8000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000db7ac43f] usable
[    0.000000] BIOS-e820: [mem 0x00000000db7ac440-0x00000000db7ae49f] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000db7ae4a0-0x00000000dfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f4000000-0x00000000f7ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fe000000-0x00000000fed3ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed45000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x0000000117ffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: Hewlett-Packard HP Compaq 8100 Elite SFF PC/304Ah, BIOS 786H1 v01.13 07/14/2011
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x118000 max_arch_pfn = 0x400000000
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
[    0.000000] e820: update [mem 0xdb800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xdb7ac max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000f9bf0-0x000f9bff] mapped at [ffff8800000f9bf0]
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0xdb7abfff]
[    0.000000]  [mem 0x00000000-0xdb5fffff] page 2M
[    0.000000]  [mem 0xdb600000-0xdb7abfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xdb7abfff @ [mem 0x1fffa000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x117ffffff]
[    0.000000]  [mem 0x100000000-0x117ffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x117ffffff @ [mem 0xdb7aa000-0xdb7abfff]
[    0.000000] ACPI: RSDP 00000000000e5210 00014 (v00 COMPAQ)
[    0.000000] ACPI: RSDT 00000000db7d0540 00040 (v01 HPQOEM SLIC-BPC 20110714      00000000)
[    0.000000] ACPI: FACP 00000000db7d05e8 00074 (v01 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI BIOS Bug: Warning: Optional FADT field Pm2ControlBlock has zero address or length: 0x0000000000000050/0x0 (20120913/tbfadt-598)
[    0.000000] ACPI BIOS Bug: Warning: Invalid length for FADT/Pm2ControlBlock: 0, using default 8 (20120913/tbfadt-648)
[    0.000000] ACPI: DSDT 00000000db7d0a4f 0A69E (v01 COMPAQ DSDT_PRJ 00000001 MSFT 0100000E)
[    0.000000] ACPI: FACS 00000000db7d0500 00040
[    0.000000] ACPI: APIC 00000000db7d065c 000BC (v01 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI: ASF! 00000000db7d0718 00063 (v32 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI: MCFG 00000000db7d077b 0003C (v01 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI: TCPA 00000000db7d07b7 00032 (v01 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI: SLIC 00000000db7d07e9 00176 (v01 HPQOEM SLIC-BPC 00000001      00000000)
[    0.000000] ACPI: HPET 00000000db7d095f 00038 (v01 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880113800000-ffff8801175fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x117ffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xdb7abfff]
[    0.000000]   node   0: [mem 0x100000000-0x117ffffff]
[    0.000000] On node 0 totalpages: 997179
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3913 pages, LIFO batch:0
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
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
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
[    0.000000] e820: [mem 0xe0000000-0xf3ffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880117c00000 s74048 r8192 d24256 u262144
[    0.000000] pcpu-alloc: s74048 r8192 d24256 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 979253
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.7.0-rc5 root=/dev/sda1 ro
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3842432k/4587520k available (4385k kernel code, 598804k absent, 146284k reserved, 4154k data, 492k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 3325.358 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 6650.71 BogoMIPS (lpj=13301432)
[    0.000062] pid_max: default: 32768 minimum: 301
[    0.000111] Mount-cache hash table entries: 256
[    0.000264] CPU: Physical Processor ID: 0
[    0.000291] CPU: Processor Core ID: 0
[    0.000319] mce: CPU supports 9 MCE banks
[    0.000353] CPU0: Thermal monitoring enabled (TM1)
[    0.000385] process: using mwait in idle threads
[    0.000415] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.000415] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.000415] tlb_flushall_shift: 6
[    0.000565] Freeing SMP alternatives: 20k freed
[    0.000599] ACPI: Core revision 20120913
[    0.004737] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.044336] smpboot: CPU0: Intel(R) Core(TM) i5 CPU         660  @ 3.33GHz (fam: 06, model: 25, stepping: 05)
[    0.151286] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
[    0.151366] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    0.151406] ... version:                3
[    0.151438] ... bit width:              48
[    0.151470] ... generic registers:      4
[    0.151502] ... value mask:             0000ffffffffffff
[    0.151538] ... max period:             000000007fffffff
[    0.151573] ... fixed-purpose events:   3
[    0.151605] ... event mask:             000000070000000f
[    0.165018] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.151762] smpboot: Booting Node   0, Processors  #1 #2 #3
[    0.191397] Brought up 4 CPUs
[    0.191452] smpboot: Total of 4 processors activated (26602.86 BogoMIPS)
[    0.193278] PM: Registering ACPI NVS region [mem 0xdb7ac440-0xdb7ae49f] (8288 bytes)
[    0.193345] reboot: BIOS series board detected. Selecting HP Compaq Laptop-method for reboots.
[    0.193447] NET: Registered protocol family 16
[    0.193550] ACPI: bus type pci registered
[    0.193620] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf4000000-0xf7ffffff] (base 0xf4000000)
[    0.193684] PCI: MMCONFIG at [mem 0xf4000000-0xf7ffffff] reserved in E820
[    0.196308] PCI: Using configuration type 1 for base access
[    0.196724] bio: create slab <bio-0> at 0
[    0.196791] ACPI: Added _OSI(Module Device)
[    0.196825] ACPI: Added _OSI(Processor Device)
[    0.196858] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.196892] ACPI: Added _OSI(Processor Aggregator Device)
[    0.197445] ACPI: EC: Look up EC in DSDT
[    0.238080] ACPI: SSDT 00000000db7dc771 003BA (v01 COMPAQ  CPU_TM2 00000001 MSFT 0100000E)
[    0.238307] ACPI: Dynamic OEM Table Load:
[    0.238348] ACPI: SSDT           (null) 003BA (v01 COMPAQ  CPU_TM2 00000001 MSFT 0100000E)
[    0.269977] ACPI: SSDT 00000000db7dc399 003D8 (v01 COMPAQ      CST 00000001 MSFT 0100000E)
[    0.270190] ACPI: Dynamic OEM Table Load:
[    0.270231] ACPI: SSDT           (null) 003D8 (v01 COMPAQ      CST 00000001 MSFT 0100000E)
[    0.317970] ACPI: Interpreter enabled
[    0.318004] ACPI: (supports S0 S3 S4 S5)
[    0.318061] ACPI: Using IOAPIC for interrupt routing
[    0.335638] ACPI: No dock devices found.
[    0.335672] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.335880] ACPI Error: [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS (20120913/dsfield-211)
[    0.335957] ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff880113442668), AE_ALREADY_EXISTS (20120913/psparse-536)
[    0.336046] ACPI: Marking method _OSC as Serialized because of AE_ALREADY_EXISTS error
[    0.336116] ACPI Warning: For \_SB_.PCI0._OSC: Parameter count mismatch - ASL declared 5, ACPI requires 4 (20120913/nspredef-359)
[    0.336194] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.336406] pci_root PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
[    0.336496] PCI host bridge to bus 0000:00
[    0.337022] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.337058] pci_bus 0000:00: root bus resource [mem 0xf8000000-0xfdffffff]
[    0.337098] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.337135] pci_bus 0000:00: root bus resource [io  0x1000-0x2fff]
[    0.337174] pci_bus 0000:00: root bus resource [io  0x3000-0x6fff]
[    0.337211] pci_bus 0000:00: root bus resource [io  0x7000-0xafff]
[    0.337249] pci_bus 0000:00: root bus resource [io  0xb000-0xffff]
[    0.337287] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.337327] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xf3ffffff]
[    0.337367] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
[    0.337411] pci 0000:00:00.0: [8086:0040] type 00 class 0x060000
[    0.337424] DMAR: Disabling batched IOTLB flush on Ironlake
[    0.337473] pci 0000:00:02.0: [8086:0042] type 00 class 0x030000
[    0.337481] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf03fffff 64bit]
[    0.337485] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.337489] pci 0000:00:02.0: reg 20: [io  0x1170-0x1177]
[    0.337531] pci 0000:00:16.0: [8086:3b64] type 00 class 0x078000
[    0.337556] pci 0000:00:16.0: reg 10: [mem 0xf0427100-0xf042710f 64bit]
[    0.337643] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.337663] pci 0000:00:16.3: [8086:3b67] type 00 class 0x070002
[    0.337677] pci 0000:00:16.3: reg 10: [io  0x1188-0x118f]
[    0.337683] pci 0000:00:16.3: reg 14: [mem 0xf0424000-0xf0424fff]
[    0.337768] pci 0000:00:19.0: [8086:10ef] type 00 class 0x020000
[    0.337781] pci 0000:00:19.0: reg 10: [mem 0xf0400000-0xf041ffff]
[    0.337787] pci 0000:00:19.0: reg 14: [mem 0xf0425000-0xf0425fff]
[    0.337793] pci 0000:00:19.0: reg 18: [io  0x1100-0x111f]
[    0.337840] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.337859] pci 0000:00:1a.0: [8086:3b3c] type 00 class 0x0c0320
[    0.337875] pci 0000:00:1a.0: reg 10: [mem 0xf0426800-0xf0426bff]
[    0.337947] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.337966] pci 0000:00:1b.0: [8086:3b56] type 00 class 0x040300
[    0.337978] pci 0000:00:1b.0: reg 10: [mem 0xf0420000-0xf0423fff 64bit]
[    0.338030] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.338046] pci 0000:00:1c.0: [8086:3b42] type 01 class 0x060400
[    0.338098] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.338116] pci 0000:00:1c.4: [8086:3b4a] type 01 class 0x060400
[    0.338168] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.338184] pci 0000:00:1c.6: [8086:3b4e] type 01 class 0x060400
[    0.338236] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    0.338256] pci 0000:00:1d.0: [8086:3b34] type 00 class 0x0c0320
[    0.338272] pci 0000:00:1d.0: reg 10: [mem 0xf0426c00-0xf0426fff]
[    0.338343] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.338358] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.338405] pci 0000:00:1f.0: [8086:3b0a] type 00 class 0x060100
[    0.338507] pci 0000:00:1f.2: [8086:3b22] type 00 class 0x010601
[    0.338521] pci 0000:00:1f.2: reg 10: [io  0x1190-0x1197]
[    0.338526] pci 0000:00:1f.2: reg 14: [io  0x11a8-0x11ab]
[    0.338533] pci 0000:00:1f.2: reg 18: [io  0x1198-0x119f]
[    0.338539] pci 0000:00:1f.2: reg 1c: [io  0x11ac-0x11af]
[    0.338544] pci 0000:00:1f.2: reg 20: [io  0x1120-0x113f]
[    0.338550] pci 0000:00:1f.2: reg 24: [mem 0xf0426000-0xf04267ff]
[    0.338584] pci 0000:00:1f.2: PME# supported from D3hot
[    0.338625] pci 0000:00:1c.0: PCI bridge to [bus 18]
[    0.338693] pci 0000:00:1c.4: PCI bridge to [bus 24]
[    0.338763] pci 0000:00:1c.6: PCI bridge to [bus 30]
[    0.338847] pci 0000:00:1e.0: PCI bridge to [bus 0d] (subtractive decode)
[    0.338891] pci 0000:00:1e.0:   bridge window [mem 0xf8000000-0xfdffffff] (subtractive decode)
[    0.338892] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.338894] pci 0000:00:1e.0:   bridge window [io  0x1000-0x2fff] (subtractive decode)
[    0.338895] pci 0000:00:1e.0:   bridge window [io  0x3000-0x6fff] (subtractive decode)
[    0.338896] pci 0000:00:1e.0:   bridge window [io  0x7000-0xafff] (subtractive decode)
[    0.338897] pci 0000:00:1e.0:   bridge window [io  0xb000-0xffff] (subtractive decode)
[    0.338898] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.338899] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xf3ffffff] (subtractive decode)
[    0.338901] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
[    0.338913] pci_bus 0000:00: on NUMA node 0
[    0.338916] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.339003] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCX1._PRT]
[    0.339028] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCX5._PRT]
[    0.339050] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCX7._PRT]
[    0.339072] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB_._PRT]
[    0.339151] ACPI Error: [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS (20120913/dsfield-211)
[    0.339227] ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff880113442668), AE_ALREADY_EXISTS (20120913/psparse-536)
[    0.339316] ACPI Warning: For \_SB_.PCI0._OSC: Parameter count mismatch - ASL declared 5, ACPI requires 4 (20120913/nspredef-359)
[    0.339395]  pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.339455]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.342593] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 14 15)
[    0.342703] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 14 15)
[    0.342809] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 14 15)
[    0.342914] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 14 15)
[    0.343018] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *10 11 14 15)
[    0.343123] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 *11 14 15)
[    0.343228] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 14 15)
[    0.343332] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
[    0.343476] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.343538] vgaarb: loaded
[    0.343567] vgaarb: bridge control possible 0000:00:02.0
[    0.343631] SCSI subsystem initialized
[    0.343663] ACPI: bus type scsi registered
[    0.343714] libata version 3.00 loaded.
[    0.343729] PCI: Using ACPI for IRQ routing
[    0.344864] PCI: Discovered peer bus 3f
[    0.344896] PCI: root bus 3f: using default resources
[    0.344897] PCI: Probing PCI hardware (bus 3f)
[    0.344910] PCI host bridge to bus 0000:3f
[    0.344944] pci_bus 0000:3f: root bus resource [io  0x0000-0xffff]
[    0.344982] pci_bus 0000:3f: root bus resource [mem 0x00000000-0xfffffffff]
[    0.345021] pci_bus 0000:3f: No busn resource found for root bus, will use [bus 3f-ff]
[    0.345085] pci 0000:3f:00.0: [8086:2c61] type 00 class 0x060000
[    0.345098] pci 0000:3f:00.1: [8086:2d01] type 00 class 0x060000
[    0.345111] pci 0000:3f:02.0: [8086:2d10] type 00 class 0x060000
[    0.345123] pci 0000:3f:02.1: [8086:2d11] type 00 class 0x060000
[    0.345135] pci 0000:3f:02.2: [8086:2d12] type 00 class 0x060000
[    0.345147] pci 0000:3f:02.3: [8086:2d13] type 00 class 0x060000
[    0.345165] pci_bus 0000:3f: busn_res: [bus 3f-ff] end is updated to 3f
[    0.345227] PCI: pci_cache_line_size set to 64 bytes
[    0.345259] e820: reserve RAM buffer [mem 0x0009f800-0x0009ffff]
[    0.345260] e820: reserve RAM buffer [mem 0xdb7ac440-0xdbffffff]
[    0.345321] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.345396] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.347436] Switching to clocksource hpet
[    0.347499] pnp: PnP ACPI init
[    0.347534] ACPI: bus type pnp registered
[    0.347665] pnp 00:00: [mem 0xf8000000-0xfdffffff window]
[    0.347667] pnp 00:00: [bus 00-ff]
[    0.347668] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.347669] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.347670] pnp 00:00: [io  0x1000-0x2fff window]
[    0.347672] pnp 00:00: [io  0x3000-0x6fff window]
[    0.347673] pnp 00:00: [io  0x7000-0xafff window]
[    0.347674] pnp 00:00: [io  0xb000-0xffff window]
[    0.347675] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.347676] pnp 00:00: [mem 0xe0000000-0xf3ffffff window]
[    0.347677] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.347691] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.347698] pnp 00:01: [io  0x00f0-0x00ff]
[    0.347704] pnp 00:01: [irq 13]
[    0.347714] pnp 00:01: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.347720] pnp 00:02: [io  0x0000-0x000f]
[    0.347721] pnp 00:02: [io  0x0080-0x008f]
[    0.347722] pnp 00:02: [io  0x00c0-0x00df]
[    0.347723] pnp 00:02: [dma 4]
[    0.347732] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.347736] pnp 00:03: [io  0x0070-0x0071]
[    0.347739] pnp 00:03: [irq 8]
[    0.347748] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.347753] pnp 00:04: [io  0x0061]
[    0.347761] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.347768] pnp 00:05: [irq 12]
[    0.347778] pnp 00:05: Plug and Play ACPI device, IDs PNP0f13 PNP0f0e (active)
[    0.347782] pnp 00:06: [io  0x0060]
[    0.347783] pnp 00:06: [io  0x0064]
[    0.347787] pnp 00:06: [irq 1]
[    0.347796] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.347943] pnp 00:07: [irq 7]
[    0.347944] pnp 00:07: [dma 3]
[    0.347945] pnp 00:07: [io  0x0378-0x037f]
[    0.347946] pnp 00:07: [io  0x0778-0x077d]
[    0.347981] pnp 00:07: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.348100] pnp 00:08: [irq 4]
[    0.348101] pnp 00:08: [io  0x03f8-0x03ff]
[    0.348136] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 PNP0500 (active)
[    0.348164] pnp 00:09: [mem 0xfec00000-0xfec00fff]
[    0.348174] pnp 00:09: Plug and Play ACPI device, IDs PNP0003 (active)
[    0.348179] pnp 00:0a: [io  0x004e-0x004f]
[    0.348180] pnp 00:0a: [io  0x0cb0-0x0cbb]
[    0.348181] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    0.348191] pnp 00:0a: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
[    0.348209] pnp 00:0b: [mem 0xfed00000-0xfed003ff]
[    0.348218] pnp 00:0b: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.348316] pnp 00:0c: [io  0x0010-0x001f]
[    0.348317] pnp 00:0c: [io  0x0050-0x0053]
[    0.348318] pnp 00:0c: [io  0x0072-0x0077]
[    0.348319] pnp 00:0c: [io  0x0090-0x009f]
[    0.348337] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.348347] pnp 00:0d: [io  0x04d0-0x04d1]
[    0.348363] system 00:0d: [io  0x04d0-0x04d1] has been reserved
[    0.348401] system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.348410] pnp 00:0e: [io  0x0400-0x041f]
[    0.348412] pnp 00:0e: [io  0x0420-0x043f]
[    0.348413] pnp 00:0e: [io  0x0440-0x045f]
[    0.348414] pnp 00:0e: [io  0x0460-0x047f]
[    0.348415] pnp 00:0e: [io  0x0480-0x048f]
[    0.348416] pnp 00:0e: [io  0xf800-0xf81f]
[    0.348417] pnp 00:0e: [io  0xf820-0xf83f]
[    0.348418] pnp 00:0e: [io  0xf840-0xf85f]
[    0.348419] pnp 00:0e: [io  0xf860-0xf87f]
[    0.348420] pnp 00:0e: [io  0xfa00-0xfa3f]
[    0.348421] pnp 00:0e: [io  0xfc00-0xfc7f]
[    0.348422] pnp 00:0e: [io  0xfc80-0xfcff]
[    0.348423] pnp 00:0e: [io  0xfe00-0xfe7f]
[    0.348424] pnp 00:0e: [io  0xfe80-0xfeff]
[    0.348441] system 00:0e: [io  0x0400-0x041f] has been reserved
[    0.348479] system 00:0e: [io  0x0420-0x043f] has been reserved
[    0.348516] system 00:0e: [io  0x0440-0x045f] has been reserved
[    0.348554] system 00:0e: [io  0x0460-0x047f] has been reserved
[    0.348591] system 00:0e: [io  0x0480-0x048f] has been reserved
[    0.348629] system 00:0e: [io  0xf800-0xf81f] has been reserved
[    0.348666] system 00:0e: [io  0xf820-0xf83f] has been reserved
[    0.348703] system 00:0e: [io  0xf840-0xf85f] has been reserved
[    0.348740] system 00:0e: [io  0xf860-0xf87f] has been reserved
[    0.348778] system 00:0e: [io  0xfa00-0xfa3f] has been reserved
[    0.348815] system 00:0e: [io  0xfc00-0xfc7f] has been reserved
[    0.348852] system 00:0e: [io  0xfc80-0xfcff] has been reserved
[    0.348889] system 00:0e: [io  0xfe00-0xfe7f] has been reserved
[    0.348927] system 00:0e: [io  0xfe80-0xfeff] has been reserved
[    0.348965] system 00:0e: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.349118] pnp 00:0f: [mem 0x00000000-0x0009ffff]
[    0.349119] pnp 00:0f: [mem 0x00100000-0xdfffffff]
[    0.349120] pnp 00:0f: [mem 0x000e4000-0x000fffff]
[    0.349121] pnp 00:0f: [mem 0xfec01000-0xfecfffff]
[    0.349122] pnp 00:0f: [mem 0xfed00400-0xfed3ffff]
[    0.349123] pnp 00:0f: [mem 0xfed45000-0xffffffff]
[    0.349124] pnp 00:0f: [mem 0xf4000000-0xf7ffffff]
[    0.349126] pnp 00:0f: [mem 0x000cfe00-0x000e3fff]
[    0.349148] system 00:0f: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.349189] system 00:0f: [mem 0x00100000-0xdfffffff] could not be reserved
[    0.349229] system 00:0f: [mem 0x000e4000-0x000fffff] could not be reserved
[    0.349269] system 00:0f: [mem 0xfec01000-0xfecfffff] has been reserved
[    0.349308] system 00:0f: [mem 0xfed00400-0xfed3ffff] has been reserved
[    0.349348] system 00:0f: [mem 0xfed45000-0xffffffff] has been reserved
[    0.349387] system 00:0f: [mem 0xf4000000-0xf7ffffff] has been reserved
[    0.349426] system 00:0f: [mem 0x000cfe00-0x000e3fff] has been reserved
[    0.349465] system 00:0f: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.349472] pnp: PnP ACPI: found 16 devices
[    0.349505] ACPI: ACPI bus type pnp unregistered
[    0.354506] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 18] add_size 1000
[    0.354509] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 18] add_size 200000
[    0.354511] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] to [bus 18] add_size 200000
[    0.354516] pci 0000:00:1c.4: bridge window [io  0x1000-0x0fff] to [bus 24] add_size 1000
[    0.354518] pci 0000:00:1c.4: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 24] add_size 200000
[    0.354519] pci 0000:00:1c.4: bridge window [mem 0x00100000-0x000fffff] to [bus 24] add_size 200000
[    0.354525] pci 0000:00:1c.6: bridge window [io  0x1000-0x0fff] to [bus 30] add_size 1000
[    0.354526] pci 0000:00:1c.6: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 30] add_size 200000
[    0.354528] pci 0000:00:1c.6: bridge window [mem 0x00100000-0x000fffff] to [bus 30] add_size 200000
[    0.354537] pci 0000:00:1c.0: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.354538] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.354540] pci 0000:00:1c.4: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.354541] pci 0000:00:1c.4: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.354542] pci 0000:00:1c.6: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.354544] pci 0000:00:1c.6: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.354545] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.354546] pci 0000:00:1c.4: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.354548] pci 0000:00:1c.6: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.354550] pci 0000:00:1c.0: BAR 14: assigned [mem 0xf8000000-0xf81fffff]
[    0.354591] pci 0000:00:1c.0: BAR 15: assigned [mem 0xf8200000-0xf83fffff 64bit pref]
[    0.354651] pci 0000:00:1c.4: BAR 14: assigned [mem 0xf8400000-0xf85fffff]
[    0.354691] pci 0000:00:1c.4: BAR 15: assigned [mem 0xf8600000-0xf87fffff 64bit pref]
[    0.354752] pci 0000:00:1c.6: BAR 14: assigned [mem 0xf8800000-0xf89fffff]
[    0.354792] pci 0000:00:1c.6: BAR 15: assigned [mem 0xf8a00000-0xf8bfffff 64bit pref]
[    0.354853] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[    0.354891] pci 0000:00:1c.4: BAR 13: assigned [io  0x3000-0x3fff]
[    0.354929] pci 0000:00:1c.6: BAR 13: assigned [io  0x4000-0x4fff]
[    0.354968] pci 0000:00:1c.0: PCI bridge to [bus 18]
[    0.355004] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.355044] pci 0000:00:1c.0:   bridge window [mem 0xf8000000-0xf81fffff]
[    0.355084] pci 0000:00:1c.0:   bridge window [mem 0xf8200000-0xf83fffff 64bit pref]
[    0.355147] pci 0000:00:1c.4: PCI bridge to [bus 24]
[    0.355183] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.355222] pci 0000:00:1c.4:   bridge window [mem 0xf8400000-0xf85fffff]
[    0.355263] pci 0000:00:1c.4:   bridge window [mem 0xf8600000-0xf87fffff 64bit pref]
[    0.355326] pci 0000:00:1c.6: PCI bridge to [bus 30]
[    0.355361] pci 0000:00:1c.6:   bridge window [io  0x4000-0x4fff]
[    0.355401] pci 0000:00:1c.6:   bridge window [mem 0xf8800000-0xf89fffff]
[    0.355442] pci 0000:00:1c.6:   bridge window [mem 0xf8a00000-0xf8bfffff 64bit pref]
[    0.355509] pci 0000:00:1e.0: PCI bridge to [bus 0d]
[    0.355568] pci 0000:00:1e.0: setting latency timer to 64
[    0.355571] pci_bus 0000:00: resource 4 [mem 0xf8000000-0xfdffffff]
[    0.355572] pci_bus 0000:00: resource 5 [io  0x0000-0x0cf7]
[    0.355573] pci_bus 0000:00: resource 6 [io  0x1000-0x2fff]
[    0.355574] pci_bus 0000:00: resource 7 [io  0x3000-0x6fff]
[    0.355575] pci_bus 0000:00: resource 8 [io  0x7000-0xafff]
[    0.355576] pci_bus 0000:00: resource 9 [io  0xb000-0xffff]
[    0.355577] pci_bus 0000:00: resource 10 [mem 0x000a0000-0x000bffff]
[    0.355579] pci_bus 0000:00: resource 11 [mem 0xe0000000-0xf3ffffff]
[    0.355580] pci_bus 0000:00: resource 12 [mem 0xfed40000-0xfed44fff]
[    0.355581] pci_bus 0000:18: resource 0 [io  0x2000-0x2fff]
[    0.355582] pci_bus 0000:18: resource 1 [mem 0xf8000000-0xf81fffff]
[    0.355583] pci_bus 0000:18: resource 2 [mem 0xf8200000-0xf83fffff 64bit pref]
[    0.355585] pci_bus 0000:24: resource 0 [io  0x3000-0x3fff]
[    0.355586] pci_bus 0000:24: resource 1 [mem 0xf8400000-0xf85fffff]
[    0.355587] pci_bus 0000:24: resource 2 [mem 0xf8600000-0xf87fffff 64bit pref]
[    0.355588] pci_bus 0000:30: resource 0 [io  0x4000-0x4fff]
[    0.355589] pci_bus 0000:30: resource 1 [mem 0xf8800000-0xf89fffff]
[    0.355590] pci_bus 0000:30: resource 2 [mem 0xf8a00000-0xf8bfffff 64bit pref]
[    0.355592] pci_bus 0000:0d: resource 4 [mem 0xf8000000-0xfdffffff]
[    0.355593] pci_bus 0000:0d: resource 5 [io  0x0000-0x0cf7]
[    0.355594] pci_bus 0000:0d: resource 6 [io  0x1000-0x2fff]
[    0.355595] pci_bus 0000:0d: resource 7 [io  0x3000-0x6fff]
[    0.355596] pci_bus 0000:0d: resource 8 [io  0x7000-0xafff]
[    0.355597] pci_bus 0000:0d: resource 9 [io  0xb000-0xffff]
[    0.355598] pci_bus 0000:0d: resource 10 [mem 0x000a0000-0x000bffff]
[    0.355600] pci_bus 0000:0d: resource 11 [mem 0xe0000000-0xf3ffffff]
[    0.355601] pci_bus 0000:0d: resource 12 [mem 0xfed40000-0xfed44fff]
[    0.355602] pci_bus 0000:3f: resource 4 [io  0x0000-0xffff]
[    0.355603] pci_bus 0000:3f: resource 5 [mem 0x00000000-0xfffffffff]
[    0.355620] NET: Registered protocol family 2
[    0.355740] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.356443] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.356680] TCP: Hash tables configured (established 262144 bind 65536)
[    0.356747] TCP: reno registered
[    0.356779] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.356830] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.356935] NET: Registered protocol family 1
[    0.356980] pci 0000:00:02.0: Boot video device
[    0.357055] PCI: CLS 64 bytes, default 64
[    0.357071] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.357111] software IO TLB [mem 0xd77aa000-0xdb7a9fff] (64MB) mapped at [ffff8800d77aa000-ffff8800db7a9fff]
[    0.357528] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.358288] VFS: Disk quotas dquot_6.5.2
[    0.358345] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.358550] msgmni has been set to 7504
[    0.358737] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.358798] io scheduler noop registered
[    0.358831] io scheduler deadline registered
[    0.358865] io scheduler cfq registered (default)
[    0.359022] intel_idle: MWAIT substates: 0x1120
[    0.359023] intel_idle: v0.4 model 0x25
[    0.359023] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.359083] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.359147] ACPI: Power Button [PBTN]
[    0.359201] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.359260] ACPI: Power Button [PWRF]
[    0.359315] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.379703] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.400007] 0000:00:16.3: ttyS1 at I/O 0x1188 (irq = 17) is a 16550A
[    0.400148] Linux agpgart interface v0.103
[    0.400209] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    0.400283] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    0.400986] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    0.401097] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    0.401171] [drm] Initialized drm 1.1.0 20060810
[    0.401318] i915 0000:00:02.0: setting latency timer to 64
[    0.413907] i915 0000:00:02.0: irq 40 for MSI/MSI-X
[    0.413912] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.413951] [drm] Driver supports precise vblank timestamp query.
[    0.414013] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    0.515445] fbcon: inteldrmfb (fb0) is primary device
[    0.646568] ------------[ cut here ]------------
[    0.646573] WARNING: at drivers/gpu/drm/i915/intel_display.c:1009 ironlake_crtc_disable+0xaf/0x8e0()
[    0.646574] Hardware name: HP Compaq 8100 Elite SFF PC
[    0.646574] pipe_off wait timed out
[    0.646575] Modules linked in:
[    0.646576] Pid: 1, comm: swapper/0 Not tainted 3.7.0-rc5 #70
[    0.646577] Call Trace:
[    0.646582]  [<ffffffff81036899>] ? warn_slowpath_common+0x79/0xc0
[    0.646583]  [<ffffffff81036995>] ? warn_slowpath_fmt+0x45/0x50
[    0.646585]  [<ffffffff812b57cb>] ? intel_wait_for_pipe_off+0x5b/0x170
[    0.646586]  [<ffffffff812b617f>] ? ironlake_crtc_disable+0xaf/0x8e0
[    0.646588]  [<ffffffff812c5499>] ? intel_dp_mode_fixup+0x249/0x270
[    0.646589]  [<ffffffff812bce86>] ? intel_set_mode+0x306/0x920
[    0.646591]  [<ffffffff812bdb91>] ? intel_crtc_set_config+0x6f1/0x950
[    0.646594]  [<ffffffff81274f3f>] ? drm_fb_helper_set_par+0x6f/0xe0
[    0.646598]  [<ffffffff8120c29f>] ? fbcon_init+0x55f/0x5f0
[    0.646600]  [<ffffffff8125aa6c>] ? visual_init+0xac/0x110
[    0.646601]  [<ffffffff8125c2cc>] ? bind_con_driver+0x16c/0x340
[    0.646602]  [<ffffffff8125c500>] ? take_over_console+0x60/0x70
[    0.646604]  [<ffffffff8120a64b>] ? fbcon_takeover+0x5b/0xc0
[    0.646607]  [<ffffffff81059375>] ? notifier_call_chain+0x45/0x60
[    0.646608]  [<ffffffff81059555>] ? __blocking_notifier_call_chain+0x55/0x80
[    0.646609]  [<ffffffff81203c3f>] ? register_framebuffer+0x1af/0x2e0
[    0.646611]  [<ffffffff812751a4>] ? drm_fb_helper_single_fb_probe+0x1f4/0x320
[    0.646612]  [<ffffffff81275479>] ? drm_fb_helper_initial_config+0x1a9/0x220
[    0.646615]  [<ffffffff810dd04d>] ? __kmalloc+0xed/0x130
[    0.646617]  [<ffffffff812d684d>] ? intel_fbdev_init+0x7d/0xb0
[    0.646619]  [<ffffffff81298935>] ? i915_driver_load+0xd95/0xf00
[    0.646622]  [<ffffffff81283a85>] ? drm_get_pci_dev+0x185/0x2c0
[    0.646623]  [<ffffffff811f3821>] ? pci_device_probe+0xd1/0x170
[    0.646625]  [<ffffffff812e9878>] ? driver_probe_device+0x68/0x220
[    0.646626]  [<ffffffff812e9ac3>] ? __driver_attach+0x93/0xa0
[    0.646627]  [<ffffffff812e9a30>] ? driver_probe_device+0x220/0x220
[    0.646629]  [<ffffffff812e7d0d>] ? bus_for_each_dev+0x4d/0x80
[    0.646630]  [<ffffffff812e8fe8>] ? bus_add_driver+0x178/0x260
[    0.646631]  [<ffffffff812ea0c4>] ? driver_register+0x84/0x180
[    0.646634]  [<ffffffff8188c7a7>] ? drm_core_init+0x12f/0x12f
[    0.646636]  [<ffffffff810002e2>] ? do_one_initcall+0x122/0x170
[    0.646638]  [<ffffffff8142ba5c>] ? kernel_init+0x11c/0x2a0
[    0.646641]  [<ffffffff8186c54a>] ? do_early_param+0x83/0x83
[    0.646643]  [<ffffffff8105e761>] ? schedule_tail+0x21/0xb0
[    0.646644]  [<ffffffff8142b940>] ? rest_init+0x70/0x70
[    0.646645]  [<ffffffff814448ac>] ? ret_from_fork+0x7c/0xb0
[    0.646646]  [<ffffffff8142b940>] ? rest_init+0x70/0x70
[    0.646651] ---[ end trace ad57c7783ee30339 ]---
[    0.702399] [drm:intel_disable_transcoder] *ERROR* failed to disable transcoder 0
[    0.937367] Console: switching to colour frame buffer device 240x67
[    0.948050] fb0: inteldrmfb frame buffer device
[    0.949269] drm: registered panic notifier
[    0.950530] ACPI Exception: AE_NOT_FOUND, Evaluating _DOD (20120913/video-1149)
[    0.951757] ACPI: Video Device [GFX0] (multi-head: no  rom: yes  post: no)
[    0.953010] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input2
[    0.954262] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    0.955546] ahci 0000:00:1f.2: version 3.0
[    0.955588] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    0.955636] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x17 impl SATA mode
[    0.956866] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part sxs apst 
[    0.958091] ahci 0000:00:1f.2: setting latency timer to 64
[    0.958409] scsi0 : ahci
[    0.959677] scsi1 : ahci
[    0.960917] scsi2 : ahci
[    0.962143] scsi3 : ahci
[    0.963351] scsi4 : ahci
[    0.964546] scsi5 : ahci
[    0.965719] ata1: SATA max UDMA/133 abar m2048@0xf0426000 port 0xf0426100 irq 41
[    0.966897] ata2: SATA max UDMA/133 abar m2048@0xf0426000 port 0xf0426180 irq 41
[    0.968063] ata3: SATA max UDMA/133 abar m2048@0xf0426000 port 0xf0426200 irq 41
[    0.969212] ata4: DUMMY
[    0.970370] ata5: SATA max UDMA/133 abar m2048@0xf0426000 port 0xf0426300 irq 41
[    0.971552] ata6: DUMMY
[    0.972775] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
[    0.976745] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.977952] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.979189] mousedev: PS/2 mouse device common for all mice
[    0.980406] rtc_cmos 00:03: RTC can wake from S4
[    0.981688] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.982896] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.984126] cpuidle: using governor ladder
[    0.985359] cpuidle: using governor menu
[    0.986614] TCP: cubic registered
[    0.987853] NET: Registered protocol family 10
[    0.989145] mip6: Mobile IPv6
[    0.990341] NET: Registered protocol family 17
[    0.991550] Key type dns_resolver registered
[    0.992842] PM: Hibernation image not present or could not be loaded.
[    0.992848] registered taskstats version 1
[    0.994314] rtc_cmos 00:03: setting system clock to 2012-11-12 18:46:20 UTC (1352745980)
[    1.288695] ata3: SATA link down (SStatus 0 SControl 300)
[    1.290496] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.291755] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.293545] ata5: SATA link down (SStatus 0 SControl 300)
[    1.294879] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[    1.296138] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
[    1.297457] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[    1.298701] ata2.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
[    1.299943] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.301182] ata2.00: ATAPI: hp       CDDVDW TS-H653T, H6D1, max UDMA/100
[    1.302432] ata1.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
[    1.302655] ata1.00: ACPI cmd e3/00:00:00:00:00:a0 (IDLE) succeeded
[    1.302661] ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.303982] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.305247] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.307540] ata1.00: ATA-8: Hitachi HDS721025CLA682, JP1OA41A, max UDMA/133
[    1.308996] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.310827] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[    1.312123] ata2.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
[    1.313417] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.314708] ata2.00: configured for UDMA/100
[    1.316076] ata1.00: failed to get Identify Device Data, Emask 0x1
[    1.317204] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[    1.318527] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
[    1.320053] ata1.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
[    1.320269] ata1.00: ACPI cmd e3/00:00:00:00:00:a0 (IDLE) succeeded
[    1.320274] ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.321710] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.323057] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.325585] ata1.00: failed to get Identify Device Data, Emask 0x1
[    1.325591] ata1.00: configured for UDMA/133
[    1.327208] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HDS72102 JP1O PQ: 0 ANSI: 5
[    1.328792] ACPI: Invalid Power Resource to register!
[    1.328823] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    1.330273] sd 0:0:0:0: [sda] Write Protect is off
[    1.330308] scsi 1:0:0:0: CD-ROM            hp       CDDVDW TS-H653T  H6D1 PQ: 0 ANSI: 5
[    1.333114] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.333127] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.352502] tsc: Refined TSC clocksource calibration: 3325.374 MHz
[    1.353959] Switching to clocksource tsc
[    1.378599]  sda: sda1 sda2 < sda5 >
[    1.380167] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.528194] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    1.529612] VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
[    1.531495] Freeing unused kernel memory: 492k freed
[    1.532988] Write protecting the kernel read-only data: 8192k
[    1.537179] Freeing unused kernel memory: 1748k freed
[    1.539892] Freeing unused kernel memory: 688k freed
[    4.139209] ACPI: Invalid PBLK length [7]
[    4.140768] ACPI: Requesting acpi_cpufreq
[    4.142356] ACPI: Invalid PBLK length [7]
[    4.143784] ACPI: Invalid PBLK length [7]
[    4.145232] ACPI: Invalid PBLK length [7]
[    4.213175] microcode: CPU0 sig=0x20655, pf=0x2, revision=0x2
[    4.281869] microcode: CPU0 updated to revision 0x3, date = 2011-09-01
[    4.283260] microcode: CPU1 sig=0x20655, pf=0x2, revision=0x2
[    4.284782] microcode: CPU1 updated to revision 0x3, date = 2011-09-01
[    4.286156] microcode: CPU2 sig=0x20655, pf=0x2, revision=0x2
[    4.288113] microcode: CPU2 updated to revision 0x3, date = 2011-09-01
[    4.289851] microcode: CPU3 sig=0x20655, pf=0x2, revision=0x2
[    4.291340] microcode: CPU3 updated to revision 0x3, date = 2011-09-01
[    4.292774] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    4.409720] mei 0000:00:16.0: setting latency timer to 64
[    4.409777] mei 0000:00:16.0: irq 42 for MSI/MSI-X
[    4.416630] e1000e: Intel(R) PRO/1000 Network Driver - 2.1.4-k
[    4.417978] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    4.419675] e1000e 0000:00:19.0: setting latency timer to 64
[    4.419719] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    4.421705] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[    4.481786] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    4.497651] tpm_tis 00:0a: 1.2 TPM (device-id 0xB, rev-id 16)
[    4.551176] wmi: Mapper loaded
[    4.568329] ACPI: bus type usb registered
[    4.569761] usbcore: registered new interface driver usbfs
[    4.571193] usbcore: registered new interface driver hub
[    4.572615] usbcore: registered new device driver usb
[    4.612050] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 78:e3:b5:a0:e5:e4
[    4.613439] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    4.614912] e1000e 0000:00:19.0 eth0: MAC: 9, PHY: 9, PBA No: A002FF-0FF
[    4.738867] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.740283] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
[    4.740318] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.740320] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    4.740324] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    4.744210] ehci_hcd 0000:00:1a.0: debug port 2
[    4.744216] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    4.744241] ehci_hcd 0000:00:1a.0: irq 20, io mem 0xf0426800
[    4.747763] cdrom: Uniform CD-ROM driver Revision: 3.20
[    4.749486] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    4.750098] tpm_tis 00:0a: TPM is disabled/deactivated (0x7)
[    4.751559] parport_pc 00:07: reported by Plug and Play ACPI
[    4.753111] gpio_ich: GPIO from 180 to 255 on gpio_ich
[    1.330379] ACPI: Invalid Power Resource to register!
[    4.753133] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
[    4.754061] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    4.754086] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    4.754087] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.754088] usb usb1: Product: EHCI Host Controller
[    4.754089] usb usb1: Manufacturer: Linux 3.7.0-rc5 ehci_hcd
[    4.754090] usb usb1: SerialNumber: 0000:00:1a.0
[    4.754156] hub 1-0:1.0: USB hub found
[    4.754159] hub 1-0:1.0: 3 ports detected
[    4.754280] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.754281] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    4.754285] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    4.758174] ehci_hcd 0000:00:1d.0: debug port 2
[    4.758178] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    4.758182] ehci_hcd 0000:00:1d.0: irq 20, io mem 0xf0426c00
[    4.770048] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    4.770071] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    4.770072] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.770074] usb usb2: Product: EHCI Host Controller
[    4.770075] usb usb2: Manufacturer: Linux 3.7.0-rc5 ehci_hcd
[    4.770076] usb usb2: SerialNumber: 0000:00:1d.0
[    4.770136] hub 2-0:1.0: USB hub found
[    4.770140] hub 2-0:1.0: 3 ports detected
[    4.786391] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.787633] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    4.848246] iTCO_vendor_support: vendor-support=0
[    4.957949] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    4.960690] iTCO_wdt: Found a Q57 TCO device (Version=2, TCOBASE=0xf860)
[    4.963462] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    5.065214] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    5.197222] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
[    5.198503] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.199867] hub 1-1:1.0: USB hub found
[    5.201301] hub 1-1:1.0: 6 ports detected
[    5.295371] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
[    5.312411] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    5.321151] snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[    5.444428] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
[    5.445722] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.447163] hub 2-1:1.0: USB hub found
[    5.449894] hub 2-1:1.0: 8 ports detected
[    5.487022] input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio1/input/input4
[    5.523854] usb 1-1.1: new high-speed USB device number 3 using ehci_hcd
[    5.615947] usb 1-1.1: New USB device found, idVendor=0424, idProduct=2512
[    5.618716] usb 1-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.621858] hub 1-1.1:1.0: USB hub found
[    5.624751] hub 1-1.1:1.0: 2 ports detected
[    5.699406] usb 1-1.2: new low-speed USB device number 4 using ehci_hcd
[    5.820288] usb 1-1.2: New USB device found, idVendor=046d, idProduct=c30e
[    5.823047] usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.825680] usb 1-1.2: Product: HID compliant keyboard
[    5.828320] usb 1-1.2: Manufacturer: Logitech
[    6.067161] usbcore: registered new interface driver usbhid
[    6.069833] usbhid: USB HID core driver
[    6.082958] input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.0/input/input5
[    6.084346] hid-generic 0003:046D:C30E.0001: input,hidraw0: USB HID v1.10 Keyboard [Logitech HID compliant keyboard] on usb-0000:00:1a.0-1.2/input0
[    6.088606] input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.1/input/input6
[    6.091721] hid-generic 0003:046D:C30E.0002: input,hidraw1: USB HID v1.10 Device [Logitech HID compliant keyboard] on usb-0000:00:1a.0-1.2/input1
[    7.424809] input: HDA Intel MID HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[    7.427918] input: HDA Intel MID Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    7.430992] input: HDA Intel MID Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    7.434070] input: HDA Intel MID Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    7.435447] input: HDA Intel MID Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    9.532163] Adding 7532540k swap on /dev/sda5.  Priority:-1 extents:1 across:7532540k 
[    9.559939] EXT4-fs (sda1): re-mounted. Opts: (null)
[    9.773619] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[   10.214511] fuse init (API version 7.20)
[   10.243899] loop: module loaded
[   14.526314] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[   14.628097] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[   14.628220] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   16.108997] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: None
[   16.112283] e1000e 0000:00:19.0 eth0: 10/100 speed: disabling TSO
[   16.119439] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   20.614348] lp0: using parport0 (interrupt-driven).




[    0.000000] Linux version 3.7.0-rc5 (mroos@prometheus) (gcc version 4.7.2 (Debian 4.7.2-4) ) #70 SMP Mon Nov 12 18:20:25 EET 2012
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.7.0-rc5 root=/dev/sda1 ro
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e8000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000db7ac43f] usable
[    0.000000] BIOS-e820: [mem 0x00000000db7ac440-0x00000000db7ae49f] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000db7ae4a0-0x00000000dfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f4000000-0x00000000f7ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fe000000-0x00000000fed3ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed45000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x0000000117ffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: Hewlett-Packard HP Compaq 8100 Elite SFF PC/304Ah, BIOS 786H1 v01.13 07/14/2011
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x118000 max_arch_pfn = 0x400000000
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
[    0.000000] e820: update [mem 0xdb800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xdb7ac max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000f9bf0-0x000f9bff] mapped at [ffff8800000f9bf0]
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0xdb7abfff]
[    0.000000]  [mem 0x00000000-0xdb5fffff] page 2M
[    0.000000]  [mem 0xdb600000-0xdb7abfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xdb7abfff @ [mem 0x1fffa000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x117ffffff]
[    0.000000]  [mem 0x100000000-0x117ffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x117ffffff @ [mem 0xdb7aa000-0xdb7abfff]
[    0.000000] ACPI: RSDP 00000000000e5210 00014 (v00 COMPAQ)
[    0.000000] ACPI: RSDT 00000000db7d0540 00040 (v01 HPQOEM SLIC-BPC 20110714      00000000)
[    0.000000] ACPI: FACP 00000000db7d05e8 00074 (v01 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI BIOS Bug: Warning: Optional FADT field Pm2ControlBlock has zero address or length: 0x0000000000000050/0x0 (20120913/tbfadt-598)
[    0.000000] ACPI BIOS Bug: Warning: Invalid length for FADT/Pm2ControlBlock: 0, using default 8 (20120913/tbfadt-648)
[    0.000000] ACPI: DSDT 00000000db7d0a4f 0A69E (v01 COMPAQ DSDT_PRJ 00000001 MSFT 0100000E)
[    0.000000] ACPI: FACS 00000000db7d0500 00040
[    0.000000] ACPI: APIC 00000000db7d065c 000BC (v01 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI: ASF! 00000000db7d0718 00063 (v32 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI: MCFG 00000000db7d077b 0003C (v01 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI: TCPA 00000000db7d07b7 00032 (v01 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI: SLIC 00000000db7d07e9 00176 (v01 HPQOEM SLIC-BPC 00000001      00000000)
[    0.000000] ACPI: HPET 00000000db7d095f 00038 (v01 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880113800000-ffff8801175fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x117ffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xdb7abfff]
[    0.000000]   node   0: [mem 0x100000000-0x117ffffff]
[    0.000000] On node 0 totalpages: 997179
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3913 pages, LIFO batch:0
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
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
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
[    0.000000] e820: [mem 0xe0000000-0xf3ffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880117c00000 s74048 r8192 d24256 u262144
[    0.000000] pcpu-alloc: s74048 r8192 d24256 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 979253
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.7.0-rc5 root=/dev/sda1 ro
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3842432k/4587520k available (4385k kernel code, 598804k absent, 146284k reserved, 4154k data, 492k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 3325.058 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 6650.11 BogoMIPS (lpj=13300232)
[    0.000062] pid_max: default: 32768 minimum: 301
[    0.000111] Mount-cache hash table entries: 256
[    0.000264] CPU: Physical Processor ID: 0
[    0.000291] CPU: Processor Core ID: 0
[    0.000319] mce: CPU supports 9 MCE banks
[    0.000352] CPU0: Thermal monitoring enabled (TM1)
[    0.000385] process: using mwait in idle threads
[    0.000414] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.000414] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.000414] tlb_flushall_shift: 6
[    0.000565] Freeing SMP alternatives: 20k freed
[    0.000599] ACPI: Core revision 20120913
[    0.004736] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.044332] smpboot: CPU0: Intel(R) Core(TM) i5 CPU         660  @ 3.33GHz (fam: 06, model: 25, stepping: 05)
[    0.151074] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
[    0.151155] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    0.151195] ... version:                3
[    0.151227] ... bit width:              48
[    0.151259] ... generic registers:      4
[    0.151291] ... value mask:             0000ffffffffffff
[    0.151327] ... max period:             000000007fffffff
[    0.151362] ... fixed-purpose events:   3
[    0.151394] ... event mask:             000000070000000f
[    0.164811] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.151552] smpboot: Booting Node   0, Processors  #1 #2 #3
[    0.191186] Brought up 4 CPUs
[    0.191240] smpboot: Total of 4 processors activated (26600.46 BogoMIPS)
[    0.193070] PM: Registering ACPI NVS region [mem 0xdb7ac440-0xdb7ae49f] (8288 bytes)
[    0.193137] reboot: BIOS series board detected. Selecting HP Compaq Laptop-method for reboots.
[    0.193239] NET: Registered protocol family 16
[    0.193341] ACPI: bus type pci registered
[    0.193411] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf4000000-0xf7ffffff] (base 0xf4000000)
[    0.193476] PCI: MMCONFIG at [mem 0xf4000000-0xf7ffffff] reserved in E820
[    0.196099] PCI: Using configuration type 1 for base access
[    0.196514] bio: create slab <bio-0> at 0
[    0.196582] ACPI: Added _OSI(Module Device)
[    0.196615] ACPI: Added _OSI(Processor Device)
[    0.196648] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.196683] ACPI: Added _OSI(Processor Aggregator Device)
[    0.197237] ACPI: EC: Look up EC in DSDT
[    0.237871] ACPI: SSDT 00000000db7dc771 003BA (v01 COMPAQ  CPU_TM2 00000001 MSFT 0100000E)
[    0.238098] ACPI: Dynamic OEM Table Load:
[    0.238139] ACPI: SSDT           (null) 003BA (v01 COMPAQ  CPU_TM2 00000001 MSFT 0100000E)
[    0.269769] ACPI: SSDT 00000000db7dc399 003D8 (v01 COMPAQ      CST 00000001 MSFT 0100000E)
[    0.269982] ACPI: Dynamic OEM Table Load:
[    0.270022] ACPI: SSDT           (null) 003D8 (v01 COMPAQ      CST 00000001 MSFT 0100000E)
[    0.317762] ACPI: Interpreter enabled
[    0.317795] ACPI: (supports S0 S3 S4 S5)
[    0.317852] ACPI: Using IOAPIC for interrupt routing
[    0.335430] ACPI: No dock devices found.
[    0.335464] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.335673] ACPI Error: [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS (20120913/dsfield-211)
[    0.335750] ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff880113442668), AE_ALREADY_EXISTS (20120913/psparse-536)
[    0.335838] ACPI: Marking method _OSC as Serialized because of AE_ALREADY_EXISTS error
[    0.335908] ACPI Warning: For \_SB_.PCI0._OSC: Parameter count mismatch - ASL declared 5, ACPI requires 4 (20120913/nspredef-359)
[    0.335987] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.336198] pci_root PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
[    0.336288] PCI host bridge to bus 0000:00
[    0.336813] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.336849] pci_bus 0000:00: root bus resource [mem 0xf8000000-0xfdffffff]
[    0.336888] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.336926] pci_bus 0000:00: root bus resource [io  0x1000-0x2fff]
[    0.336964] pci_bus 0000:00: root bus resource [io  0x3000-0x6fff]
[    0.337002] pci_bus 0000:00: root bus resource [io  0x7000-0xafff]
[    0.337040] pci_bus 0000:00: root bus resource [io  0xb000-0xffff]
[    0.337077] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.337117] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xf3ffffff]
[    0.337156] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
[    0.337201] pci 0000:00:00.0: [8086:0040] type 00 class 0x060000
[    0.337214] DMAR: Disabling batched IOTLB flush on Ironlake
[    0.337263] pci 0000:00:02.0: [8086:0042] type 00 class 0x030000
[    0.337271] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf03fffff 64bit]
[    0.337275] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.337278] pci 0000:00:02.0: reg 20: [io  0x1170-0x1177]
[    0.337320] pci 0000:00:16.0: [8086:3b64] type 00 class 0x078000
[    0.337345] pci 0000:00:16.0: reg 10: [mem 0xf0427100-0xf042710f 64bit]
[    0.337432] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.337453] pci 0000:00:16.3: [8086:3b67] type 00 class 0x070002
[    0.337467] pci 0000:00:16.3: reg 10: [io  0x1188-0x118f]
[    0.337474] pci 0000:00:16.3: reg 14: [mem 0xf0424000-0xf0424fff]
[    0.337559] pci 0000:00:19.0: [8086:10ef] type 00 class 0x020000
[    0.337573] pci 0000:00:19.0: reg 10: [mem 0xf0400000-0xf041ffff]
[    0.337579] pci 0000:00:19.0: reg 14: [mem 0xf0425000-0xf0425fff]
[    0.337585] pci 0000:00:19.0: reg 18: [io  0x1100-0x111f]
[    0.337634] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.337652] pci 0000:00:1a.0: [8086:3b3c] type 00 class 0x0c0320
[    0.337669] pci 0000:00:1a.0: reg 10: [mem 0xf0426800-0xf0426bff]
[    0.337742] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.337762] pci 0000:00:1b.0: [8086:3b56] type 00 class 0x040300
[    0.337773] pci 0000:00:1b.0: reg 10: [mem 0xf0420000-0xf0423fff 64bit]
[    0.337825] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.337842] pci 0000:00:1c.0: [8086:3b42] type 01 class 0x060400
[    0.337894] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.337913] pci 0000:00:1c.4: [8086:3b4a] type 01 class 0x060400
[    0.337964] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.337981] pci 0000:00:1c.6: [8086:3b4e] type 01 class 0x060400
[    0.338032] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    0.338053] pci 0000:00:1d.0: [8086:3b34] type 00 class 0x0c0320
[    0.338069] pci 0000:00:1d.0: reg 10: [mem 0xf0426c00-0xf0426fff]
[    0.338140] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.338156] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.338203] pci 0000:00:1f.0: [8086:3b0a] type 00 class 0x060100
[    0.338306] pci 0000:00:1f.2: [8086:3b22] type 00 class 0x010601
[    0.338320] pci 0000:00:1f.2: reg 10: [io  0x1190-0x1197]
[    0.338325] pci 0000:00:1f.2: reg 14: [io  0x11a8-0x11ab]
[    0.338331] pci 0000:00:1f.2: reg 18: [io  0x1198-0x119f]
[    0.338337] pci 0000:00:1f.2: reg 1c: [io  0x11ac-0x11af]
[    0.338342] pci 0000:00:1f.2: reg 20: [io  0x1120-0x113f]
[    0.338349] pci 0000:00:1f.2: reg 24: [mem 0xf0426000-0xf04267ff]
[    0.338383] pci 0000:00:1f.2: PME# supported from D3hot
[    0.338423] pci 0000:00:1c.0: PCI bridge to [bus 18]
[    0.338492] pci 0000:00:1c.4: PCI bridge to [bus 24]
[    0.338562] pci 0000:00:1c.6: PCI bridge to [bus 30]
[    0.338647] pci 0000:00:1e.0: PCI bridge to [bus 0d] (subtractive decode)
[    0.338691] pci 0000:00:1e.0:   bridge window [mem 0xf8000000-0xfdffffff] (subtractive decode)
[    0.338692] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.338694] pci 0000:00:1e.0:   bridge window [io  0x1000-0x2fff] (subtractive decode)
[    0.338695] pci 0000:00:1e.0:   bridge window [io  0x3000-0x6fff] (subtractive decode)
[    0.338696] pci 0000:00:1e.0:   bridge window [io  0x7000-0xafff] (subtractive decode)
[    0.338697] pci 0000:00:1e.0:   bridge window [io  0xb000-0xffff] (subtractive decode)
[    0.338698] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.338699] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xf3ffffff] (subtractive decode)
[    0.338700] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
[    0.338713] pci_bus 0000:00: on NUMA node 0
[    0.338716] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.338803] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCX1._PRT]
[    0.338828] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCX5._PRT]
[    0.338850] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCX7._PRT]
[    0.338872] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB_._PRT]
[    0.338951] ACPI Error: [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS (20120913/dsfield-211)
[    0.339027] ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff880113442668), AE_ALREADY_EXISTS (20120913/psparse-536)
[    0.339117] ACPI Warning: For \_SB_.PCI0._OSC: Parameter count mismatch - ASL declared 5, ACPI requires 4 (20120913/nspredef-359)
[    0.339195]  pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.339255]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.342389] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 14 15)
[    0.342499] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 14 15)
[    0.342604] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 14 15)
[    0.342709] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 14 15)
[    0.342813] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *10 11 14 15)
[    0.342918] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 *11 14 15)
[    0.343023] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 14 15)
[    0.343127] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
[    0.343270] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.343333] vgaarb: loaded
[    0.343361] vgaarb: bridge control possible 0000:00:02.0
[    0.343426] SCSI subsystem initialized
[    0.343458] ACPI: bus type scsi registered
[    0.343509] libata version 3.00 loaded.
[    0.343523] PCI: Using ACPI for IRQ routing
[    0.344659] PCI: Discovered peer bus 3f
[    0.344691] PCI: root bus 3f: using default resources
[    0.344692] PCI: Probing PCI hardware (bus 3f)
[    0.344705] PCI host bridge to bus 0000:3f
[    0.344739] pci_bus 0000:3f: root bus resource [io  0x0000-0xffff]
[    0.344777] pci_bus 0000:3f: root bus resource [mem 0x00000000-0xfffffffff]
[    0.344817] pci_bus 0000:3f: No busn resource found for root bus, will use [bus 3f-ff]
[    0.344880] pci 0000:3f:00.0: [8086:2c61] type 00 class 0x060000
[    0.344893] pci 0000:3f:00.1: [8086:2d01] type 00 class 0x060000
[    0.344907] pci 0000:3f:02.0: [8086:2d10] type 00 class 0x060000
[    0.344918] pci 0000:3f:02.1: [8086:2d11] type 00 class 0x060000
[    0.344930] pci 0000:3f:02.2: [8086:2d12] type 00 class 0x060000
[    0.344942] pci 0000:3f:02.3: [8086:2d13] type 00 class 0x060000
[    0.344960] pci_bus 0000:3f: busn_res: [bus 3f-ff] end is updated to 3f
[    0.345022] PCI: pci_cache_line_size set to 64 bytes
[    0.345055] e820: reserve RAM buffer [mem 0x0009f800-0x0009ffff]
[    0.345056] e820: reserve RAM buffer [mem 0xdb7ac440-0xdbffffff]
[    0.345118] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.345193] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.347232] Switching to clocksource hpet
[    0.347295] pnp: PnP ACPI init
[    0.347330] ACPI: bus type pnp registered
[    0.347461] pnp 00:00: [mem 0xf8000000-0xfdffffff window]
[    0.347462] pnp 00:00: [bus 00-ff]
[    0.347464] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.347465] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.347466] pnp 00:00: [io  0x1000-0x2fff window]
[    0.347467] pnp 00:00: [io  0x3000-0x6fff window]
[    0.347468] pnp 00:00: [io  0x7000-0xafff window]
[    0.347469] pnp 00:00: [io  0xb000-0xffff window]
[    0.347470] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.347471] pnp 00:00: [mem 0xe0000000-0xf3ffffff window]
[    0.347473] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.347487] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.347493] pnp 00:01: [io  0x00f0-0x00ff]
[    0.347499] pnp 00:01: [irq 13]
[    0.347509] pnp 00:01: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.347516] pnp 00:02: [io  0x0000-0x000f]
[    0.347517] pnp 00:02: [io  0x0080-0x008f]
[    0.347518] pnp 00:02: [io  0x00c0-0x00df]
[    0.347519] pnp 00:02: [dma 4]
[    0.347527] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.347531] pnp 00:03: [io  0x0070-0x0071]
[    0.347535] pnp 00:03: [irq 8]
[    0.347544] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.347548] pnp 00:04: [io  0x0061]
[    0.347556] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.347564] pnp 00:05: [irq 12]
[    0.347573] pnp 00:05: Plug and Play ACPI device, IDs PNP0f13 PNP0f0e (active)
[    0.347578] pnp 00:06: [io  0x0060]
[    0.347579] pnp 00:06: [io  0x0064]
[    0.347582] pnp 00:06: [irq 1]
[    0.347591] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.347739] pnp 00:07: [irq 7]
[    0.347740] pnp 00:07: [dma 3]
[    0.347741] pnp 00:07: [io  0x0378-0x037f]
[    0.347742] pnp 00:07: [io  0x0778-0x077d]
[    0.347778] pnp 00:07: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.347896] pnp 00:08: [irq 4]
[    0.347897] pnp 00:08: [io  0x03f8-0x03ff]
[    0.347931] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 PNP0500 (active)
[    0.347961] pnp 00:09: [mem 0xfec00000-0xfec00fff]
[    0.347971] pnp 00:09: Plug and Play ACPI device, IDs PNP0003 (active)
[    0.347976] pnp 00:0a: [io  0x004e-0x004f]
[    0.347977] pnp 00:0a: [io  0x0cb0-0x0cbb]
[    0.347978] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    0.347987] pnp 00:0a: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
[    0.348006] pnp 00:0b: [mem 0xfed00000-0xfed003ff]
[    0.348015] pnp 00:0b: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.348113] pnp 00:0c: [io  0x0010-0x001f]
[    0.348114] pnp 00:0c: [io  0x0050-0x0053]
[    0.348115] pnp 00:0c: [io  0x0072-0x0077]
[    0.348116] pnp 00:0c: [io  0x0090-0x009f]
[    0.348133] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.348144] pnp 00:0d: [io  0x04d0-0x04d1]
[    0.348160] system 00:0d: [io  0x04d0-0x04d1] has been reserved
[    0.348198] system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.348207] pnp 00:0e: [io  0x0400-0x041f]
[    0.348208] pnp 00:0e: [io  0x0420-0x043f]
[    0.348209] pnp 00:0e: [io  0x0440-0x045f]
[    0.348210] pnp 00:0e: [io  0x0460-0x047f]
[    0.348211] pnp 00:0e: [io  0x0480-0x048f]
[    0.348212] pnp 00:0e: [io  0xf800-0xf81f]
[    0.348213] pnp 00:0e: [io  0xf820-0xf83f]
[    0.348214] pnp 00:0e: [io  0xf840-0xf85f]
[    0.348215] pnp 00:0e: [io  0xf860-0xf87f]
[    0.348216] pnp 00:0e: [io  0xfa00-0xfa3f]
[    0.348217] pnp 00:0e: [io  0xfc00-0xfc7f]
[    0.348218] pnp 00:0e: [io  0xfc80-0xfcff]
[    0.348220] pnp 00:0e: [io  0xfe00-0xfe7f]
[    0.348221] pnp 00:0e: [io  0xfe80-0xfeff]
[    0.348238] system 00:0e: [io  0x0400-0x041f] has been reserved
[    0.348275] system 00:0e: [io  0x0420-0x043f] has been reserved
[    0.348312] system 00:0e: [io  0x0440-0x045f] has been reserved
[    0.348350] system 00:0e: [io  0x0460-0x047f] has been reserved
[    0.348387] system 00:0e: [io  0x0480-0x048f] has been reserved
[    0.348424] system 00:0e: [io  0xf800-0xf81f] has been reserved
[    0.348462] system 00:0e: [io  0xf820-0xf83f] has been reserved
[    0.348499] system 00:0e: [io  0xf840-0xf85f] has been reserved
[    0.348536] system 00:0e: [io  0xf860-0xf87f] has been reserved
[    0.348574] system 00:0e: [io  0xfa00-0xfa3f] has been reserved
[    0.348611] system 00:0e: [io  0xfc00-0xfc7f] has been reserved
[    0.348649] system 00:0e: [io  0xfc80-0xfcff] has been reserved
[    0.348686] system 00:0e: [io  0xfe00-0xfe7f] has been reserved
[    0.348723] system 00:0e: [io  0xfe80-0xfeff] has been reserved
[    0.348761] system 00:0e: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.348914] pnp 00:0f: [mem 0x00000000-0x0009ffff]
[    0.348915] pnp 00:0f: [mem 0x00100000-0xdfffffff]
[    0.348916] pnp 00:0f: [mem 0x000e4000-0x000fffff]
[    0.348917] pnp 00:0f: [mem 0xfec01000-0xfecfffff]
[    0.348918] pnp 00:0f: [mem 0xfed00400-0xfed3ffff]
[    0.348919] pnp 00:0f: [mem 0xfed45000-0xffffffff]
[    0.348920] pnp 00:0f: [mem 0xf4000000-0xf7ffffff]
[    0.348922] pnp 00:0f: [mem 0x000cfe00-0x000e3fff]
[    0.348943] system 00:0f: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.348985] system 00:0f: [mem 0x00100000-0xdfffffff] could not be reserved
[    0.349024] system 00:0f: [mem 0x000e4000-0x000fffff] could not be reserved
[    0.349064] system 00:0f: [mem 0xfec01000-0xfecfffff] has been reserved
[    0.349103] system 00:0f: [mem 0xfed00400-0xfed3ffff] has been reserved
[    0.349142] system 00:0f: [mem 0xfed45000-0xffffffff] has been reserved
[    0.349181] system 00:0f: [mem 0xf4000000-0xf7ffffff] has been reserved
[    0.349220] system 00:0f: [mem 0x000cfe00-0x000e3fff] has been reserved
[    0.349260] system 00:0f: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.349267] pnp: PnP ACPI: found 16 devices
[    0.349299] ACPI: ACPI bus type pnp unregistered
[    0.354300] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 18] add_size 1000
[    0.354303] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 18] add_size 200000
[    0.354305] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] to [bus 18] add_size 200000
[    0.354310] pci 0000:00:1c.4: bridge window [io  0x1000-0x0fff] to [bus 24] add_size 1000
[    0.354312] pci 0000:00:1c.4: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 24] add_size 200000
[    0.354313] pci 0000:00:1c.4: bridge window [mem 0x00100000-0x000fffff] to [bus 24] add_size 200000
[    0.354319] pci 0000:00:1c.6: bridge window [io  0x1000-0x0fff] to [bus 30] add_size 1000
[    0.354320] pci 0000:00:1c.6: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 30] add_size 200000
[    0.354322] pci 0000:00:1c.6: bridge window [mem 0x00100000-0x000fffff] to [bus 30] add_size 200000
[    0.354331] pci 0000:00:1c.0: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.354333] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.354334] pci 0000:00:1c.4: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.354335] pci 0000:00:1c.4: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.354337] pci 0000:00:1c.6: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.354338] pci 0000:00:1c.6: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.354339] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.354341] pci 0000:00:1c.4: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.354342] pci 0000:00:1c.6: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.354344] pci 0000:00:1c.0: BAR 14: assigned [mem 0xf8000000-0xf81fffff]
[    0.354385] pci 0000:00:1c.0: BAR 15: assigned [mem 0xf8200000-0xf83fffff 64bit pref]
[    0.354446] pci 0000:00:1c.4: BAR 14: assigned [mem 0xf8400000-0xf85fffff]
[    0.354486] pci 0000:00:1c.4: BAR 15: assigned [mem 0xf8600000-0xf87fffff 64bit pref]
[    0.354546] pci 0000:00:1c.6: BAR 14: assigned [mem 0xf8800000-0xf89fffff]
[    0.354586] pci 0000:00:1c.6: BAR 15: assigned [mem 0xf8a00000-0xf8bfffff 64bit pref]
[    0.354648] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[    0.354686] pci 0000:00:1c.4: BAR 13: assigned [io  0x3000-0x3fff]
[    0.354725] pci 0000:00:1c.6: BAR 13: assigned [io  0x4000-0x4fff]
[    0.354764] pci 0000:00:1c.0: PCI bridge to [bus 18]
[    0.354799] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.354839] pci 0000:00:1c.0:   bridge window [mem 0xf8000000-0xf81fffff]
[    0.354880] pci 0000:00:1c.0:   bridge window [mem 0xf8200000-0xf83fffff 64bit pref]
[    0.354943] pci 0000:00:1c.4: PCI bridge to [bus 24]
[    0.354978] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.355018] pci 0000:00:1c.4:   bridge window [mem 0xf8400000-0xf85fffff]
[    0.355058] pci 0000:00:1c.4:   bridge window [mem 0xf8600000-0xf87fffff 64bit pref]
[    0.355121] pci 0000:00:1c.6: PCI bridge to [bus 30]
[    0.355157] pci 0000:00:1c.6:   bridge window [io  0x4000-0x4fff]
[    0.355196] pci 0000:00:1c.6:   bridge window [mem 0xf8800000-0xf89fffff]
[    0.355237] pci 0000:00:1c.6:   bridge window [mem 0xf8a00000-0xf8bfffff 64bit pref]
[    0.355304] pci 0000:00:1e.0: PCI bridge to [bus 0d]
[    0.355363] pci 0000:00:1e.0: setting latency timer to 64
[    0.355366] pci_bus 0000:00: resource 4 [mem 0xf8000000-0xfdffffff]
[    0.355367] pci_bus 0000:00: resource 5 [io  0x0000-0x0cf7]
[    0.355368] pci_bus 0000:00: resource 6 [io  0x1000-0x2fff]
[    0.355369] pci_bus 0000:00: resource 7 [io  0x3000-0x6fff]
[    0.355370] pci_bus 0000:00: resource 8 [io  0x7000-0xafff]
[    0.355371] pci_bus 0000:00: resource 9 [io  0xb000-0xffff]
[    0.355373] pci_bus 0000:00: resource 10 [mem 0x000a0000-0x000bffff]
[    0.355374] pci_bus 0000:00: resource 11 [mem 0xe0000000-0xf3ffffff]
[    0.355375] pci_bus 0000:00: resource 12 [mem 0xfed40000-0xfed44fff]
[    0.355376] pci_bus 0000:18: resource 0 [io  0x2000-0x2fff]
[    0.355377] pci_bus 0000:18: resource 1 [mem 0xf8000000-0xf81fffff]
[    0.355378] pci_bus 0000:18: resource 2 [mem 0xf8200000-0xf83fffff 64bit pref]
[    0.355380] pci_bus 0000:24: resource 0 [io  0x3000-0x3fff]
[    0.355381] pci_bus 0000:24: resource 1 [mem 0xf8400000-0xf85fffff]
[    0.355382] pci_bus 0000:24: resource 2 [mem 0xf8600000-0xf87fffff 64bit pref]
[    0.355383] pci_bus 0000:30: resource 0 [io  0x4000-0x4fff]
[    0.355384] pci_bus 0000:30: resource 1 [mem 0xf8800000-0xf89fffff]
[    0.355385] pci_bus 0000:30: resource 2 [mem 0xf8a00000-0xf8bfffff 64bit pref]
[    0.355387] pci_bus 0000:0d: resource 4 [mem 0xf8000000-0xfdffffff]
[    0.355388] pci_bus 0000:0d: resource 5 [io  0x0000-0x0cf7]
[    0.355389] pci_bus 0000:0d: resource 6 [io  0x1000-0x2fff]
[    0.355390] pci_bus 0000:0d: resource 7 [io  0x3000-0x6fff]
[    0.355391] pci_bus 0000:0d: resource 8 [io  0x7000-0xafff]
[    0.355392] pci_bus 0000:0d: resource 9 [io  0xb000-0xffff]
[    0.355393] pci_bus 0000:0d: resource 10 [mem 0x000a0000-0x000bffff]
[    0.355395] pci_bus 0000:0d: resource 11 [mem 0xe0000000-0xf3ffffff]
[    0.355396] pci_bus 0000:0d: resource 12 [mem 0xfed40000-0xfed44fff]
[    0.355397] pci_bus 0000:3f: resource 4 [io  0x0000-0xffff]
[    0.355398] pci_bus 0000:3f: resource 5 [mem 0x00000000-0xfffffffff]
[    0.355415] NET: Registered protocol family 2
[    0.355534] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.356236] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.356473] TCP: Hash tables configured (established 262144 bind 65536)
[    0.356541] TCP: reno registered
[    0.356573] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.356623] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.356729] NET: Registered protocol family 1
[    0.356773] pci 0000:00:02.0: Boot video device
[    0.356848] PCI: CLS 64 bytes, default 64
[    0.356863] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.356903] software IO TLB [mem 0xd77aa000-0xdb7a9fff] (64MB) mapped at [ffff8800d77aa000-ffff8800db7a9fff]
[    0.357322] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.358082] VFS: Disk quotas dquot_6.5.2
[    0.358139] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.358343] msgmni has been set to 7504
[    0.358530] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.358591] io scheduler noop registered
[    0.358623] io scheduler deadline registered
[    0.358658] io scheduler cfq registered (default)
[    0.358814] intel_idle: MWAIT substates: 0x1120
[    0.358815] intel_idle: v0.4 model 0x25
[    0.358816] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.358877] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.358940] ACPI: Power Button [PBTN]
[    0.358993] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.359053] ACPI: Power Button [PWRF]
[    0.359107] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.379497] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.399797] 0000:00:16.3: ttyS1 at I/O 0x1188 (irq = 17) is a 16550A
[    0.399935] Linux agpgart interface v0.103
[    0.399998] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    0.400071] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    0.400775] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    0.400886] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    0.400960] [drm] Initialized drm 1.1.0 20060810
[    0.401108] i915 0000:00:02.0: setting latency timer to 64
[    0.413696] i915 0000:00:02.0: irq 40 for MSI/MSI-X
[    0.413701] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.413740] [drm] Driver supports precise vblank timestamp query.
[    0.413802] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    0.503304] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 17
[    0.503366] Raw EDID:
[    0.503395]  	00 ff ff ff ff ff ff 00 22 f0 49 29 00 00 00 00
[    0.503431]  	15 15 01 04 a5 33 1d 78 26 01 f5 a2 57 52 9f 27
[    0.503468]  	0a 50 54 a1 08 00 81 c0 81 80 95 00 b3 00 d1 c0
[    0.503504]  	01 01 01 01 01 01 02 3a 80 18 71 38 2d 40 58 2c
[    0.503540]  	45 00 fe 1f 11 00 00 1e 00 00 00 fd 00 32 4c 18
[    0.503577]  	5e 11 00 0a 20 20 20 20 20 20 00 00 00 fc 00 48
[    0.503614]  	50 20 4c 41 32 33 30 36 0a 20 20 20 00 11 ff 00
[    0.503651]  	43 4e 43 31 32 31 31 32 50 42 0a 20 20 00 5a 00
[    0.530984] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 15
[    0.531046] Raw EDID:
[    0.531074]  	00 ff ff ff ff ff ff 00 22 f0 49 29 00 00 00 00
[    0.531111]  	15 15 01 04 a5 33 1d 78 26 01 f5 a2 57 52 9f 27
[    0.531147]  	0a 50 54 a1 08 00 81 c0 81 80 95 00 b3 00 d1 c0
[    0.531183]  	01 01 01 11 01 02 3a 80 18 71 38 2d 40 58 2c 45
[    0.531220]  	00 fe 1f 11 00 00 1e 00 00 00 fd 00 32 4c 18 5e
[    0.531257]  	11 00 0a 20 20 20 20 20 20 00 00 00 fc 00 48 50
[    0.531293]  	20 4c 41 32 33 30 36 0a 20 20 20 00 00 00 ff 00
[    0.531330]  	43 4e 43 31 32 31 31 32 50 42 0a 20 20 00 5a 00
[    0.585843] fbcon: inteldrmfb (fb0) is primary device
[    0.735007] [drm:intel_dp_complete_link_train] *ERROR* failed to train DP, aborting
[    0.893611] ------------[ cut here ]------------
[    0.893615] WARNING: at drivers/gpu/drm/i915/intel_display.c:1009 ironlake_crtc_disable+0xaf/0x8e0()
[    0.893616] Hardware name: HP Compaq 8100 Elite SFF PC
[    0.893616] pipe_off wait timed out
[    0.893617] Modules linked in:
[    0.893618] Pid: 1, comm: swapper/0 Not tainted 3.7.0-rc5 #70
[    0.893619] Call Trace:
[    0.893623]  [<ffffffff81036899>] ? warn_slowpath_common+0x79/0xc0
[    0.893624]  [<ffffffff81036995>] ? warn_slowpath_fmt+0x45/0x50
[    0.893626]  [<ffffffff812b57cb>] ? intel_wait_for_pipe_off+0x5b/0x170
[    0.893627]  [<ffffffff812b617f>] ? ironlake_crtc_disable+0xaf/0x8e0
[    0.893629]  [<ffffffff812c5499>] ? intel_dp_mode_fixup+0x249/0x270
[    0.893630]  [<ffffffff812bce86>] ? intel_set_mode+0x306/0x920
[    0.893632]  [<ffffffff812bdb91>] ? intel_crtc_set_config+0x6f1/0x950
[    0.893635]  [<ffffffff81442241>] ? __mutex_lock_slowpath+0xd1/0x140
[    0.893639]  [<ffffffff81274f3f>] ? drm_fb_helper_set_par+0x6f/0xe0
[    0.893642]  [<ffffffff8120c29f>] ? fbcon_init+0x55f/0x5f0
[    0.893644]  [<ffffffff8125aa6c>] ? visual_init+0xac/0x110
[    0.893645]  [<ffffffff8125c2cc>] ? bind_con_driver+0x16c/0x340
[    0.893647]  [<ffffffff8125c500>] ? take_over_console+0x60/0x70
[    0.893648]  [<ffffffff8120a64b>] ? fbcon_takeover+0x5b/0xc0
[    0.893651]  [<ffffffff81059375>] ? notifier_call_chain+0x45/0x60
[    0.893652]  [<ffffffff81059555>] ? __blocking_notifier_call_chain+0x55/0x80
[    0.893653]  [<ffffffff81203c3f>] ? register_framebuffer+0x1af/0x2e0
[    0.893655]  [<ffffffff812751a4>] ? drm_fb_helper_single_fb_probe+0x1f4/0x320
[    0.893656]  [<ffffffff81275479>] ? drm_fb_helper_initial_config+0x1a9/0x220
[    0.893659]  [<ffffffff810dd04d>] ? __kmalloc+0xed/0x130
[    0.893661]  [<ffffffff812d684d>] ? intel_fbdev_init+0x7d/0xb0
[    0.893663]  [<ffffffff81298935>] ? i915_driver_load+0xd95/0xf00
[    0.893666]  [<ffffffff81283a85>] ? drm_get_pci_dev+0x185/0x2c0
[    0.893667]  [<ffffffff811f3821>] ? pci_device_probe+0xd1/0x170
[    0.893669]  [<ffffffff812e9878>] ? driver_probe_device+0x68/0x220
[    0.893670]  [<ffffffff812e9ac3>] ? __driver_attach+0x93/0xa0
[    0.893671]  [<ffffffff812e9a30>] ? driver_probe_device+0x220/0x220
[    0.893673]  [<ffffffff812e7d0d>] ? bus_for_each_dev+0x4d/0x80
[    0.893674]  [<ffffffff812e8fe8>] ? bus_add_driver+0x178/0x260
[    0.893675]  [<ffffffff812ea0c4>] ? driver_register+0x84/0x180
[    0.893678]  [<ffffffff8188c7a7>] ? drm_core_init+0x12f/0x12f
[    0.893680]  [<ffffffff810002e2>] ? do_one_initcall+0x122/0x170
[    0.893682]  [<ffffffff8142ba5c>] ? kernel_init+0x11c/0x2a0
[    0.893684]  [<ffffffff8186c54a>] ? do_early_param+0x83/0x83
[    0.893686]  [<ffffffff8105e761>] ? schedule_tail+0x21/0xb0
[    0.893686]  [<ffffffff8142b940>] ? rest_init+0x70/0x70
[    0.893688]  [<ffffffff814448ac>] ? ret_from_fork+0x7c/0xb0
[    0.893689]  [<ffffffff8142b940>] ? rest_init+0x70/0x70
[    0.893693] ---[ end trace dee2e32e6b8520d3 ]---
[    0.949441] [drm:intel_disable_transcoder] *ERROR* failed to disable transcoder 0
[    1.184415] Console: switching to colour frame buffer device 240x67
[    1.199099] fb0: inteldrmfb frame buffer device
[    1.200483] drm: registered panic notifier
[    1.201895] ACPI Exception: AE_NOT_FOUND, Evaluating _DOD (20120913/video-1149)
[    1.203270] ACPI: Video Device [GFX0] (multi-head: no  rom: yes  post: no)
[    1.204648] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input2
[    1.206015] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.207421] ahci 0000:00:1f.2: version 3.0
[    1.207462] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    1.207509] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x17 impl SATA mode
[    1.208875] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part sxs apst 
[    1.210243] ahci 0000:00:1f.2: setting latency timer to 64
[    1.210555] scsi0 : ahci
[    1.211952] scsi1 : ahci
[    1.213316] scsi2 : ahci
[    1.214647] scsi3 : ahci
[    1.215948] scsi4 : ahci
[    1.217224] scsi5 : ahci
[    1.218451] ata1: SATA max UDMA/133 abar m2048@0xf0426000 port 0xf0426100 irq 41
[    1.219665] ata2: SATA max UDMA/133 abar m2048@0xf0426000 port 0xf0426180 irq 41
[    1.220864] ata3: SATA max UDMA/133 abar m2048@0xf0426000 port 0xf0426200 irq 41
[    1.222041] ata4: DUMMY
[    1.223217] ata5: SATA max UDMA/133 abar m2048@0xf0426000 port 0xf0426300 irq 41
[    1.224412] ata6: DUMMY
[    1.225659] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
[    1.229396] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.230614] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.231877] mousedev: PS/2 mouse device common for all mice
[    1.233116] rtc_cmos 00:03: RTC can wake from S4
[    1.234400] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.235620] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.236869] cpuidle: using governor ladder
[    1.238124] cpuidle: using governor menu
[    1.239398] TCP: cubic registered
[    1.240672] NET: Registered protocol family 10
[    1.241980] mip6: Mobile IPv6
[    1.243187] NET: Registered protocol family 17
[    1.244413] Key type dns_resolver registered
[    1.245732] PM: Hibernation image not present or could not be loaded.
[    1.245739] registered taskstats version 1
[    1.247242] rtc_cmos 00:03: setting system clock to 2012-11-12 19:25:53 UTC (1352748353)
[    1.352279] tsc: Refined TSC clocksource calibration: 3325.374 MHz
[    1.353591] Switching to clocksource tsc
[    1.543709] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.545562] ata3: SATA link down (SStatus 0 SControl 300)
[    1.547106] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[    1.548403] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
[    1.549699] ata5: SATA link down (SStatus 0 SControl 300)
[    1.551005] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.552363] ata1.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
[    1.552562] ata1.00: ACPI cmd e3/00:00:00:00:00:a0 (IDLE) succeeded
[    1.552569] ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.553951] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.555278] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.556672] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[    1.558257] ata2.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
[    1.560110] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.561910] ata2.00: ATAPI: hp       CDDVDW TS-H653T, H6D1, max UDMA/100
[    1.563965] ata1.00: ATA-8: Hitachi HDS721025CLA682, JP1OA41A, max UDMA/133
[    1.565894] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.567888] ata1.00: failed to get Identify Device Data, Emask 0x1
[    1.569013] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[    1.570586] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
[    1.572492] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[    1.573839] ata2.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
[    1.575177] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.576516] ata2.00: configured for UDMA/100
[    1.577853] ata1.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
[    1.578048] ata1.00: ACPI cmd e3/00:00:00:00:00:a0 (IDLE) succeeded
[    1.578055] ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.579511] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.580904] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.583461] ata1.00: failed to get Identify Device Data, Emask 0x1
[    1.583467] ata1.00: configured for UDMA/133
[    1.585167] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HDS72102 JP1O PQ: 0 ANSI: 5
[    1.586728] ACPI: Invalid Power Resource to register!
[    1.586782] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    1.588324] sd 0:0:0:0: [sda] Write Protect is off
[    1.588625] scsi 1:0:0:0: CD-ROM            hp       CDDVDW TS-H653T  H6D1 PQ: 0 ANSI: 5
[    1.591175] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.591187] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.636557]  sda: sda1 sda2 < sda5 >
[    1.638153] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.752690] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    1.754138] VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
[    1.756068] Freeing unused kernel memory: 492k freed
[    1.757555] Write protecting the kernel read-only data: 8192k
[    1.761768] Freeing unused kernel memory: 1748k freed
[    1.764548] Freeing unused kernel memory: 688k freed
[    4.397122] ACPI: Invalid PBLK length [7]
[    4.398638] ACPI: Requesting acpi_cpufreq
[    4.400259] ACPI: Invalid PBLK length [7]
[    4.401708] ACPI: Invalid PBLK length [7]
[    4.403196] ACPI: Invalid PBLK length [7]
[    4.512678] microcode: CPU0 sig=0x20655, pf=0x2, revision=0x2
[    4.583332] e1000e: Intel(R) PRO/1000 Network Driver - 2.1.4-k
[    4.584728] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    4.586151] e1000e 0000:00:19.0: setting latency timer to 64
[    4.586193] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    4.587668] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[    4.647552] microcode: CPU0 updated to revision 0x3, date = 2011-09-01
[    4.649353] microcode: CPU1 sig=0x20655, pf=0x2, revision=0x2
[    4.651281] microcode: CPU1 updated to revision 0x3, date = 2011-09-01
[    4.653088] microcode: CPU2 sig=0x20655, pf=0x2, revision=0x2
[    4.654646] microcode: CPU2 updated to revision 0x3, date = 2011-09-01
[    4.656074] microcode: CPU3 sig=0x20655, pf=0x2, revision=0x2
[    4.657622] microcode: CPU3 updated to revision 0x3, date = 2011-09-01
[    4.659065] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    4.715596] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    4.726013] wmi: Mapper loaded
[    4.735019] parport_pc 00:07: reported by Plug and Play ACPI
[    1.588752] ACPI: Invalid Power Resource to register!
[    4.736514] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
[    4.782458] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 78:e3:b5:a0:e5:e4
[    4.783839] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    4.785272] e1000e 0000:00:19.0 eth0: MAC: 9, PHY: 9, PBA No: A002FF-0FF
[    4.786690] mei 0000:00:16.0: setting latency timer to 64
[    4.786734] mei 0000:00:16.0: irq 43 for MSI/MSI-X
[    4.804492] gpio_ich: GPIO from 180 to 255 on gpio_ich
[    4.833861] tpm_tis 00:0a: 1.2 TPM (device-id 0xB, rev-id 16)
[    4.856997] iTCO_vendor_support: vendor-support=0
[    4.866955] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    4.869116] iTCO_wdt: Found a Q57 TCO device (Version=2, TCOBASE=0xf860)
[    4.871242] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    4.917771] ACPI: bus type usb registered
[    4.919140] usbcore: registered new interface driver usbfs
[    4.920514] usbcore: registered new interface driver hub
[    4.921983] usbcore: registered new device driver usb
[    4.971948] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.973621] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.973626] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    4.976492] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    4.983276] ehci_hcd 0000:00:1a.0: debug port 2
[    4.986115] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    4.986216] ehci_hcd 0000:00:1a.0: irq 20, io mem 0xf0426800
[    4.997185] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    4.999240] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    5.001372] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.003446] usb usb1: Product: EHCI Host Controller
[    5.005557] usb usb1: Manufacturer: Linux 3.7.0-rc5 ehci_hcd
[    5.007635] usb usb1: SerialNumber: 0000:00:1a.0
[    5.009834] hub 1-0:1.0: USB hub found
[    5.011235] hub 1-0:1.0: 3 ports detected
[    5.012738] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    5.012740] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    5.014143] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    5.019419] ehci_hcd 0000:00:1d.0: debug port 2
[    5.020848] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    5.020857] ehci_hcd 0000:00:1d.0: irq 20, io mem 0xf0426c00
[    5.030762] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
[    5.032147] cdrom: Uniform CD-ROM driver Revision: 3.20
[    5.033498] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    5.033636] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    5.034833] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    5.036196] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.037636] usb usb2: Product: EHCI Host Controller
[    5.039195] usb usb2: Manufacturer: Linux 3.7.0-rc5 ehci_hcd
[    5.040751] usb usb2: SerialNumber: 0000:00:1d.0
[    5.042375] hub 2-0:1.0: USB hub found
[    5.043648] hub 2-0:1.0: 3 ports detected
[    5.084925] tpm_tis 00:0a: TPM is disabled/deactivated (0x7)
[    5.185048] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.186362] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    5.320186] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    5.328880] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
[    5.452402] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
[    5.454376] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.456529] hub 1-1:1.0: USB hub found
[    5.458208] hub 1-1:1.0: 6 ports detected
[    5.510155] input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio1/input/input4
[    5.571008] snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[    5.571413] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    5.703342] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
[    5.704626] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.706068] hub 2-1:1.0: USB hub found
[    5.707474] hub 2-1:1.0: 8 ports detected
[    5.778892] usb 1-1.1: new high-speed USB device number 3 using ehci_hcd
[    5.870981] usb 1-1.1: New USB device found, idVendor=0424, idProduct=2512
[    5.873831] usb 1-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.876863] hub 1-1.1:1.0: USB hub found
[    5.880531] hub 1-1.1:1.0: 2 ports detected
[    5.954494] usb 1-1.2: new low-speed USB device number 4 using ehci_hcd
[    6.075265] usb 1-1.2: New USB device found, idVendor=046d, idProduct=c30e
[    6.076703] usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.078051] usb 1-1.2: Product: HID compliant keyboard
[    6.079314] usb 1-1.2: Manufacturer: Logitech
[    6.392908] usbcore: registered new interface driver usbhid
[    6.395341] usbhid: USB HID core driver
[    6.407429] input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.0/input/input5
[    6.408786] hid-generic 0003:046D:C30E.0001: input,hidraw0: USB HID v1.10 Keyboard [Logitech HID compliant keyboard] on usb-0000:00:1a.0-1.2/input0
[    6.413203] input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.1/input/input6
[    6.414607] hid-generic 0003:046D:C30E.0002: input,hidraw1: USB HID v1.10 Device [Logitech HID compliant keyboard] on usb-0000:00:1a.0-1.2/input1
[    6.690917] input: HDA Intel MID HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[    6.694022] input: HDA Intel MID Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    6.697137] input: HDA Intel MID Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    6.700257] input: HDA Intel MID Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    6.703315] input: HDA Intel MID Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    7.753385] Adding 7532540k swap on /dev/sda5.  Priority:-1 extents:1 across:7532540k 
[    7.781064] EXT4-fs (sda1): re-mounted. Opts: (null)
[    7.996172] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[    8.429058] fuse init (API version 7.20)
[    8.457251] loop: module loaded
[   12.646029] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[   12.749589] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[   12.749705] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   14.222562] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: None
[   14.225828] e1000e 0000:00:19.0 eth0: 10/100 speed: disabling TSO
[   14.233041] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   18.380159] lp0: using parport0 (interrupt-driven).



-- 
Meelis Roos (mroos@linux.ee)
