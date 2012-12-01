Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab2LAJ5U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 04:57:20 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:53149 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab2LAJ5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 04:57:09 -0500
Date: Sat, 1 Dec 2012 11:57:03 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
cc: dri-devel@lists.freedesktop.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>
Subject: Re: WARNING: at drivers/gpu/drm/i915/intel_display.c:1009
 ironlake_crtc_disable+0xaf/0x8e0
In-Reply-To: <CAKMK7uFv+7JdgkwH7LZpHWiNnkr-dy=bKron8aRZHsCK1nHhJw@mail.gmail.com>
Message-ID: <alpine.SOC.1.00.1212011153001.3639@math.ut.ee>
References: <alpine.SOC.1.00.1211122120150.3649@math.ut.ee> <alpine.SOC.1.00.1211302247340.10301@math.ut.ee> <CAKMK7uFv+7JdgkwH7LZpHWiNnkr-dy=bKron8aRZHsCK1nHhJw@mail.gmail.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> I tried 3.7-rc5 on an ironlale PC and got the warning in subject. The
> >> computer last ran 3.6.0 without any warnings. Second reboot showed the
> >> same warning plus a couple of EDID warnings (also below).
> >
> > Still there with 3.7.0-rc7-00113-gcc19528 and 100% reproducible:
> 
> Hm, can you please boot with drm.debug=0xe added to your kernel
> cmdline and the attach the complete dmesg?

Here you are. This time the EDID warning is there too, seems to depend 
on timing.

[    0.000000] Linux version 3.7.0-rc7-00113-gcc19528 (mroos@prometheus) (gcc version 4.7.2 (Debian 4.7.2-4) ) #75 SMP Fri Nov 30 22:40:48 EET 2012
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.7.0-rc7-00113-gcc19528 root=/dev/sda1 ro drm.debug=0xe
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
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x05] enabled)
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
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.7.0-rc7-00113-gcc19528 root=/dev/sda1 ro drm.debug=0xe
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3842432k/4587520k available (4388k kernel code, 598804k absent, 146284k reserved, 4151k data, 492k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 3325.043 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 6650.08 BogoMIPS (lpj=13300172)
[    0.000062] pid_max: default: 32768 minimum: 301
[    0.000111] Mount-cache hash table entries: 256
[    0.000264] CPU: Physical Processor ID: 0
[    0.000291] CPU: Processor Core ID: 0
[    0.000320] mce: CPU supports 9 MCE banks
[    0.000353] CPU0: Thermal monitoring enabled (TM1)
[    0.000385] process: using mwait in idle threads
[    0.000416] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.000416] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.000416] tlb_flushall_shift: 6
[    0.000565] Freeing SMP alternatives: 20k freed
[    0.000599] ACPI: Core revision 20120913
[    0.004742] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.044337] smpboot: CPU0: Intel(R) Core(TM) i5 CPU         660  @ 3.33GHz (fam: 06, model: 25, stepping: 05)
[    0.151288] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
[    0.151369] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    0.151408] ... version:                3
[    0.151440] ... bit width:              48
[    0.151472] ... generic registers:      4
[    0.151505] ... value mask:             0000ffffffffffff
[    0.151540] ... max period:             000000007fffffff
[    0.151575] ... fixed-purpose events:   3
[    0.151607] ... event mask:             000000070000000f
[    0.165026] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.151766] smpboot: Booting Node   0, Processors  #1 #2 #3
[    0.191401] Brought up 4 CPUs
[    0.191455] smpboot: Total of 4 processors activated (26600.34 BogoMIPS)
[    0.193280] PM: Registering ACPI NVS region [mem 0xdb7ac440-0xdb7ae49f] (8288 bytes)
[    0.193348] reboot: BIOS series board detected. Selecting HP Compaq Laptop-method for reboots.
[    0.193451] NET: Registered protocol family 16
[    0.193555] ACPI: bus type pci registered
[    0.193624] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf4000000-0xf7ffffff] (base 0xf4000000)
[    0.193689] PCI: MMCONFIG at [mem 0xf4000000-0xf7ffffff] reserved in E820
[    0.196315] PCI: Using configuration type 1 for base access
[    0.196729] bio: create slab <bio-0> at 0
[    0.196796] ACPI: Added _OSI(Module Device)
[    0.196830] ACPI: Added _OSI(Processor Device)
[    0.196864] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.196898] ACPI: Added _OSI(Processor Aggregator Device)
[    0.197424] ACPI: EC: Look up EC in DSDT
[    0.242075] ACPI: SSDT 00000000db7dc771 003BA (v01 COMPAQ  CPU_TM2 00000001 MSFT 0100000E)
[    0.242308] ACPI: Dynamic OEM Table Load:
[    0.242349] ACPI: SSDT           (null) 003BA (v01 COMPAQ  CPU_TM2 00000001 MSFT 0100000E)
[    0.273972] ACPI: SSDT 00000000db7dc399 003D8 (v01 COMPAQ      CST 00000001 MSFT 0100000E)
[    0.274185] ACPI: Dynamic OEM Table Load:
[    0.274225] ACPI: SSDT           (null) 003D8 (v01 COMPAQ      CST 00000001 MSFT 0100000E)
[    0.321964] ACPI: Interpreter enabled
[    0.321998] ACPI: (supports S0 S3 S4 S5)
[    0.322055] ACPI: Using IOAPIC for interrupt routing
[    0.339634] ACPI: No dock devices found.
[    0.339669] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.339878] ACPI Error: [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS (20120913/dsfield-211)
[    0.339955] ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff880113432668), AE_ALREADY_EXISTS (20120913/psparse-536)
[    0.340043] ACPI: Marking method _OSC as Serialized because of AE_ALREADY_EXISTS error
[    0.340113] ACPI Warning: For \_SB_.PCI0._OSC: Parameter count mismatch - ASL declared 5, ACPI requires 4 (20120913/nspredef-359)
[    0.340192] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.340405] pci_root PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
[    0.340494] PCI host bridge to bus 0000:00
[    0.341019] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.341056] pci_bus 0000:00: root bus resource [mem 0xf8000000-0xfdffffff]
[    0.341095] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.341133] pci_bus 0000:00: root bus resource [io  0x1000-0x2fff]
[    0.341171] pci_bus 0000:00: root bus resource [io  0x3000-0x6fff]
[    0.341209] pci_bus 0000:00: root bus resource [io  0x7000-0xafff]
[    0.341246] pci_bus 0000:00: root bus resource [io  0xb000-0xffff]
[    0.341284] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.341324] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xf3ffffff]
[    0.341363] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
[    0.341408] pci 0000:00:00.0: [8086:0040] type 00 class 0x060000
[    0.341420] DMAR: Disabling batched IOTLB flush on Ironlake
[    0.341470] pci 0000:00:02.0: [8086:0042] type 00 class 0x030000
[    0.341478] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf03fffff 64bit]
[    0.341482] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.341485] pci 0000:00:02.0: reg 20: [io  0x1170-0x1177]
[    0.341527] pci 0000:00:16.0: [8086:3b64] type 00 class 0x078000
[    0.341552] pci 0000:00:16.0: reg 10: [mem 0xf0427100-0xf042710f 64bit]
[    0.341639] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.341660] pci 0000:00:16.3: [8086:3b67] type 00 class 0x070002
[    0.341673] pci 0000:00:16.3: reg 10: [io  0x1188-0x118f]
[    0.341680] pci 0000:00:16.3: reg 14: [mem 0xf0424000-0xf0424fff]
[    0.341766] pci 0000:00:19.0: [8086:10ef] type 00 class 0x020000
[    0.341779] pci 0000:00:19.0: reg 10: [mem 0xf0400000-0xf041ffff]
[    0.341785] pci 0000:00:19.0: reg 14: [mem 0xf0425000-0xf0425fff]
[    0.341791] pci 0000:00:19.0: reg 18: [io  0x1100-0x111f]
[    0.341840] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.341858] pci 0000:00:1a.0: [8086:3b3c] type 00 class 0x0c0320
[    0.341874] pci 0000:00:1a.0: reg 10: [mem 0xf0426800-0xf0426bff]
[    0.341947] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.341966] pci 0000:00:1b.0: [8086:3b56] type 00 class 0x040300
[    0.341977] pci 0000:00:1b.0: reg 10: [mem 0xf0420000-0xf0423fff 64bit]
[    0.342028] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.342044] pci 0000:00:1c.0: [8086:3b42] type 01 class 0x060400
[    0.342095] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.342114] pci 0000:00:1c.4: [8086:3b4a] type 01 class 0x060400
[    0.342165] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.342181] pci 0000:00:1c.6: [8086:3b4e] type 01 class 0x060400
[    0.342232] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    0.342253] pci 0000:00:1d.0: [8086:3b34] type 00 class 0x0c0320
[    0.342270] pci 0000:00:1d.0: reg 10: [mem 0xf0426c00-0xf0426fff]
[    0.342340] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.342356] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.342404] pci 0000:00:1f.0: [8086:3b0a] type 00 class 0x060100
[    0.342505] pci 0000:00:1f.2: [8086:3b22] type 00 class 0x010601
[    0.342519] pci 0000:00:1f.2: reg 10: [io  0x1190-0x1197]
[    0.342524] pci 0000:00:1f.2: reg 14: [io  0x11a8-0x11ab]
[    0.342530] pci 0000:00:1f.2: reg 18: [io  0x1198-0x119f]
[    0.342535] pci 0000:00:1f.2: reg 1c: [io  0x11ac-0x11af]
[    0.342541] pci 0000:00:1f.2: reg 20: [io  0x1120-0x113f]
[    0.342547] pci 0000:00:1f.2: reg 24: [mem 0xf0426000-0xf04267ff]
[    0.342580] pci 0000:00:1f.2: PME# supported from D3hot
[    0.342621] pci 0000:00:1c.0: PCI bridge to [bus 18]
[    0.342689] pci 0000:00:1c.4: PCI bridge to [bus 24]
[    0.342759] pci 0000:00:1c.6: PCI bridge to [bus 30]
[    0.342843] pci 0000:00:1e.0: PCI bridge to [bus 0d] (subtractive decode)
[    0.342888] pci 0000:00:1e.0:   bridge window [mem 0xf8000000-0xfdffffff] (subtractive decode)
[    0.342889] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.342890] pci 0000:00:1e.0:   bridge window [io  0x1000-0x2fff] (subtractive decode)
[    0.342891] pci 0000:00:1e.0:   bridge window [io  0x3000-0x6fff] (subtractive decode)
[    0.342892] pci 0000:00:1e.0:   bridge window [io  0x7000-0xafff] (subtractive decode)
[    0.342894] pci 0000:00:1e.0:   bridge window [io  0xb000-0xffff] (subtractive decode)
[    0.342895] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.342896] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xf3ffffff] (subtractive decode)
[    0.342897] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
[    0.342910] pci_bus 0000:00: on NUMA node 0
[    0.342912] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.343001] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCX1._PRT]
[    0.343026] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCX5._PRT]
[    0.343048] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCX7._PRT]
[    0.343070] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB_._PRT]
[    0.343150] ACPI Error: [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS (20120913/dsfield-211)
[    0.343227] ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff880113432668), AE_ALREADY_EXISTS (20120913/psparse-536)
[    0.343316] ACPI Warning: For \_SB_.PCI0._OSC: Parameter count mismatch - ASL declared 5, ACPI requires 4 (20120913/nspredef-359)
[    0.343394]  pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.343455]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.346571] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 14 15)
[    0.346678] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 14 15)
[    0.346787] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 14 15)
[    0.346892] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 14 15)
[    0.346996] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *10 11 14 15)
[    0.347101] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 *11 14 15)
[    0.347206] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 14 15)
[    0.347311] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
[    0.347453] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.347515] vgaarb: loaded
[    0.347544] vgaarb: bridge control possible 0000:00:02.0
[    0.347609] SCSI subsystem initialized
[    0.347641] ACPI: bus type scsi registered
[    0.347693] libata version 3.00 loaded.
[    0.347707] PCI: Using ACPI for IRQ routing
[    0.348842] PCI: Discovered peer bus 3f
[    0.348874] PCI: root bus 3f: using default resources
[    0.348875] PCI: Probing PCI hardware (bus 3f)
[    0.348888] PCI host bridge to bus 0000:3f
[    0.348922] pci_bus 0000:3f: root bus resource [io  0x0000-0xffff]
[    0.348960] pci_bus 0000:3f: root bus resource [mem 0x00000000-0xfffffffff]
[    0.349000] pci_bus 0000:3f: No busn resource found for root bus, will use [bus 3f-ff]
[    0.349064] pci 0000:3f:00.0: [8086:2c61] type 00 class 0x060000
[    0.349077] pci 0000:3f:00.1: [8086:2d01] type 00 class 0x060000
[    0.349090] pci 0000:3f:02.0: [8086:2d10] type 00 class 0x060000
[    0.349102] pci 0000:3f:02.1: [8086:2d11] type 00 class 0x060000
[    0.349113] pci 0000:3f:02.2: [8086:2d12] type 00 class 0x060000
[    0.349125] pci 0000:3f:02.3: [8086:2d13] type 00 class 0x060000
[    0.349143] pci_bus 0000:3f: busn_res: [bus 3f-ff] end is updated to 3f
[    0.349204] PCI: pci_cache_line_size set to 64 bytes
[    0.349237] e820: reserve RAM buffer [mem 0x0009f800-0x0009ffff]
[    0.349238] e820: reserve RAM buffer [mem 0xdb7ac440-0xdbffffff]
[    0.349300] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.349375] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.351414] Switching to clocksource hpet
[    0.351476] pnp: PnP ACPI init
[    0.351511] ACPI: bus type pnp registered
[    0.351642] pnp 00:00: [mem 0xf8000000-0xfdffffff window]
[    0.351643] pnp 00:00: [bus 00-ff]
[    0.351644] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.351646] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.351647] pnp 00:00: [io  0x1000-0x2fff window]
[    0.351648] pnp 00:00: [io  0x3000-0x6fff window]
[    0.351649] pnp 00:00: [io  0x7000-0xafff window]
[    0.351650] pnp 00:00: [io  0xb000-0xffff window]
[    0.351651] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.351653] pnp 00:00: [mem 0xe0000000-0xf3ffffff window]
[    0.351654] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.351668] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.351675] pnp 00:01: [io  0x00f0-0x00ff]
[    0.351681] pnp 00:01: [irq 13]
[    0.351691] pnp 00:01: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.351697] pnp 00:02: [io  0x0000-0x000f]
[    0.351698] pnp 00:02: [io  0x0080-0x008f]
[    0.351699] pnp 00:02: [io  0x00c0-0x00df]
[    0.351701] pnp 00:02: [dma 4]
[    0.351709] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.351713] pnp 00:03: [io  0x0070-0x0071]
[    0.351716] pnp 00:03: [irq 8]
[    0.351725] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.351730] pnp 00:04: [io  0x0061]
[    0.351738] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.351745] pnp 00:05: [irq 12]
[    0.351755] pnp 00:05: Plug and Play ACPI device, IDs PNP0f13 PNP0f0e (active)
[    0.351759] pnp 00:06: [io  0x0060]
[    0.351760] pnp 00:06: [io  0x0064]
[    0.351763] pnp 00:06: [irq 1]
[    0.351774] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.351921] pnp 00:07: [irq 7]
[    0.351923] pnp 00:07: [dma 3]
[    0.351924] pnp 00:07: [io  0x0378-0x037f]
[    0.351925] pnp 00:07: [io  0x0778-0x077d]
[    0.351960] pnp 00:07: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.352078] pnp 00:08: [irq 4]
[    0.352079] pnp 00:08: [io  0x03f8-0x03ff]
[    0.352114] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 PNP0500 (active)
[    0.352142] pnp 00:09: [mem 0xfec00000-0xfec00fff]
[    0.352152] pnp 00:09: Plug and Play ACPI device, IDs PNP0003 (active)
[    0.352157] pnp 00:0a: [io  0x004e-0x004f]
[    0.352158] pnp 00:0a: [io  0x0cb0-0x0cbb]
[    0.352159] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    0.352169] pnp 00:0a: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
[    0.352187] pnp 00:0b: [mem 0xfed00000-0xfed003ff]
[    0.352196] pnp 00:0b: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.352294] pnp 00:0c: [io  0x0010-0x001f]
[    0.352295] pnp 00:0c: [io  0x0050-0x0053]
[    0.352296] pnp 00:0c: [io  0x0072-0x0077]
[    0.352297] pnp 00:0c: [io  0x0090-0x009f]
[    0.352314] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.352325] pnp 00:0d: [io  0x04d0-0x04d1]
[    0.352341] system 00:0d: [io  0x04d0-0x04d1] has been reserved
[    0.352379] system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.352390] pnp 00:0e: [io  0x0400-0x041f]
[    0.352391] pnp 00:0e: [io  0x0420-0x043f]
[    0.352392] pnp 00:0e: [io  0x0440-0x045f]
[    0.352393] pnp 00:0e: [io  0x0460-0x047f]
[    0.352394] pnp 00:0e: [io  0x0480-0x048f]
[    0.352395] pnp 00:0e: [io  0xf800-0xf81f]
[    0.352396] pnp 00:0e: [io  0xf820-0xf83f]
[    0.352397] pnp 00:0e: [io  0xf840-0xf85f]
[    0.352398] pnp 00:0e: [io  0xf860-0xf87f]
[    0.352399] pnp 00:0e: [io  0xfa00-0xfa3f]
[    0.352401] pnp 00:0e: [io  0xfc00-0xfc7f]
[    0.352402] pnp 00:0e: [io  0xfc80-0xfcff]
[    0.352403] pnp 00:0e: [io  0xfe00-0xfe7f]
[    0.352404] pnp 00:0e: [io  0xfe80-0xfeff]
[    0.352421] system 00:0e: [io  0x0400-0x041f] has been reserved
[    0.352459] system 00:0e: [io  0x0420-0x043f] has been reserved
[    0.352496] system 00:0e: [io  0x0440-0x045f] has been reserved
[    0.352534] system 00:0e: [io  0x0460-0x047f] has been reserved
[    0.352571] system 00:0e: [io  0x0480-0x048f] has been reserved
[    0.352608] system 00:0e: [io  0xf800-0xf81f] has been reserved
[    0.352646] system 00:0e: [io  0xf820-0xf83f] has been reserved
[    0.352684] system 00:0e: [io  0xf840-0xf85f] has been reserved
[    0.352722] system 00:0e: [io  0xf860-0xf87f] has been reserved
[    0.352759] system 00:0e: [io  0xfa00-0xfa3f] has been reserved
[    0.352796] system 00:0e: [io  0xfc00-0xfc7f] has been reserved
[    0.352833] system 00:0e: [io  0xfc80-0xfcff] has been reserved
[    0.352871] system 00:0e: [io  0xfe00-0xfe7f] has been reserved
[    0.352908] system 00:0e: [io  0xfe80-0xfeff] has been reserved
[    0.352946] system 00:0e: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.353100] pnp 00:0f: [mem 0x00000000-0x0009ffff]
[    0.353102] pnp 00:0f: [mem 0x00100000-0xdfffffff]
[    0.353103] pnp 00:0f: [mem 0x000e4000-0x000fffff]
[    0.353104] pnp 00:0f: [mem 0xfec01000-0xfecfffff]
[    0.353105] pnp 00:0f: [mem 0xfed00400-0xfed3ffff]
[    0.353106] pnp 00:0f: [mem 0xfed45000-0xffffffff]
[    0.353107] pnp 00:0f: [mem 0xf4000000-0xf7ffffff]
[    0.353108] pnp 00:0f: [mem 0x000cfe00-0x000e3fff]
[    0.353130] system 00:0f: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.353170] system 00:0f: [mem 0x00100000-0xdfffffff] could not be reserved
[    0.353211] system 00:0f: [mem 0x000e4000-0x000fffff] could not be reserved
[    0.353251] system 00:0f: [mem 0xfec01000-0xfecfffff] has been reserved
[    0.353290] system 00:0f: [mem 0xfed00400-0xfed3ffff] has been reserved
[    0.353329] system 00:0f: [mem 0xfed45000-0xffffffff] has been reserved
[    0.353368] system 00:0f: [mem 0xf4000000-0xf7ffffff] has been reserved
[    0.353407] system 00:0f: [mem 0x000cfe00-0x000e3fff] has been reserved
[    0.353447] system 00:0f: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.353454] pnp: PnP ACPI: found 16 devices
[    0.353486] ACPI: ACPI bus type pnp unregistered
[    0.358488] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 18] add_size 1000
[    0.358490] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 18] add_size 200000
[    0.358492] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] to [bus 18] add_size 200000
[    0.358498] pci 0000:00:1c.4: bridge window [io  0x1000-0x0fff] to [bus 24] add_size 1000
[    0.358499] pci 0000:00:1c.4: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 24] add_size 200000
[    0.358501] pci 0000:00:1c.4: bridge window [mem 0x00100000-0x000fffff] to [bus 24] add_size 200000
[    0.358506] pci 0000:00:1c.6: bridge window [io  0x1000-0x0fff] to [bus 30] add_size 1000
[    0.358508] pci 0000:00:1c.6: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 30] add_size 200000
[    0.358509] pci 0000:00:1c.6: bridge window [mem 0x00100000-0x000fffff] to [bus 30] add_size 200000
[    0.358518] pci 0000:00:1c.0: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.358519] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.358521] pci 0000:00:1c.4: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.358522] pci 0000:00:1c.4: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.358523] pci 0000:00:1c.6: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.358525] pci 0000:00:1c.6: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.358526] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.358527] pci 0000:00:1c.4: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.358529] pci 0000:00:1c.6: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.358531] pci 0000:00:1c.0: BAR 14: assigned [mem 0xf8000000-0xf81fffff]
[    0.358572] pci 0000:00:1c.0: BAR 15: assigned [mem 0xf8200000-0xf83fffff 64bit pref]
[    0.358632] pci 0000:00:1c.4: BAR 14: assigned [mem 0xf8400000-0xf85fffff]
[    0.358672] pci 0000:00:1c.4: BAR 15: assigned [mem 0xf8600000-0xf87fffff 64bit pref]
[    0.358733] pci 0000:00:1c.6: BAR 14: assigned [mem 0xf8800000-0xf89fffff]
[    0.358772] pci 0000:00:1c.6: BAR 15: assigned [mem 0xf8a00000-0xf8bfffff 64bit pref]
[    0.358833] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[    0.358872] pci 0000:00:1c.4: BAR 13: assigned [io  0x3000-0x3fff]
[    0.358910] pci 0000:00:1c.6: BAR 13: assigned [io  0x4000-0x4fff]
[    0.358949] pci 0000:00:1c.0: PCI bridge to [bus 18]
[    0.358985] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.359025] pci 0000:00:1c.0:   bridge window [mem 0xf8000000-0xf81fffff]
[    0.359066] pci 0000:00:1c.0:   bridge window [mem 0xf8200000-0xf83fffff 64bit pref]
[    0.359129] pci 0000:00:1c.4: PCI bridge to [bus 24]
[    0.359164] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.359204] pci 0000:00:1c.4:   bridge window [mem 0xf8400000-0xf85fffff]
[    0.359244] pci 0000:00:1c.4:   bridge window [mem 0xf8600000-0xf87fffff 64bit pref]
[    0.359307] pci 0000:00:1c.6: PCI bridge to [bus 30]
[    0.359342] pci 0000:00:1c.6:   bridge window [io  0x4000-0x4fff]
[    0.359382] pci 0000:00:1c.6:   bridge window [mem 0xf8800000-0xf89fffff]
[    0.359423] pci 0000:00:1c.6:   bridge window [mem 0xf8a00000-0xf8bfffff 64bit pref]
[    0.359490] pci 0000:00:1e.0: PCI bridge to [bus 0d]
[    0.359549] pci 0000:00:1e.0: setting latency timer to 64
[    0.359551] pci_bus 0000:00: resource 4 [mem 0xf8000000-0xfdffffff]
[    0.359553] pci_bus 0000:00: resource 5 [io  0x0000-0x0cf7]
[    0.359554] pci_bus 0000:00: resource 6 [io  0x1000-0x2fff]
[    0.359555] pci_bus 0000:00: resource 7 [io  0x3000-0x6fff]
[    0.359556] pci_bus 0000:00: resource 8 [io  0x7000-0xafff]
[    0.359557] pci_bus 0000:00: resource 9 [io  0xb000-0xffff]
[    0.359558] pci_bus 0000:00: resource 10 [mem 0x000a0000-0x000bffff]
[    0.359559] pci_bus 0000:00: resource 11 [mem 0xe0000000-0xf3ffffff]
[    0.359561] pci_bus 0000:00: resource 12 [mem 0xfed40000-0xfed44fff]
[    0.359562] pci_bus 0000:18: resource 0 [io  0x2000-0x2fff]
[    0.359563] pci_bus 0000:18: resource 1 [mem 0xf8000000-0xf81fffff]
[    0.359564] pci_bus 0000:18: resource 2 [mem 0xf8200000-0xf83fffff 64bit pref]
[    0.359565] pci_bus 0000:24: resource 0 [io  0x3000-0x3fff]
[    0.359566] pci_bus 0000:24: resource 1 [mem 0xf8400000-0xf85fffff]
[    0.359568] pci_bus 0000:24: resource 2 [mem 0xf8600000-0xf87fffff 64bit pref]
[    0.359569] pci_bus 0000:30: resource 0 [io  0x4000-0x4fff]
[    0.359570] pci_bus 0000:30: resource 1 [mem 0xf8800000-0xf89fffff]
[    0.359571] pci_bus 0000:30: resource 2 [mem 0xf8a00000-0xf8bfffff 64bit pref]
[    0.359572] pci_bus 0000:0d: resource 4 [mem 0xf8000000-0xfdffffff]
[    0.359573] pci_bus 0000:0d: resource 5 [io  0x0000-0x0cf7]
[    0.359575] pci_bus 0000:0d: resource 6 [io  0x1000-0x2fff]
[    0.359576] pci_bus 0000:0d: resource 7 [io  0x3000-0x6fff]
[    0.359577] pci_bus 0000:0d: resource 8 [io  0x7000-0xafff]
[    0.359578] pci_bus 0000:0d: resource 9 [io  0xb000-0xffff]
[    0.359579] pci_bus 0000:0d: resource 10 [mem 0x000a0000-0x000bffff]
[    0.359580] pci_bus 0000:0d: resource 11 [mem 0xe0000000-0xf3ffffff]
[    0.359581] pci_bus 0000:0d: resource 12 [mem 0xfed40000-0xfed44fff]
[    0.359583] pci_bus 0000:3f: resource 4 [io  0x0000-0xffff]
[    0.359584] pci_bus 0000:3f: resource 5 [mem 0x00000000-0xfffffffff]
[    0.359601] NET: Registered protocol family 2
[    0.359717] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.360364] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.360584] TCP: Hash tables configured (established 262144 bind 65536)
[    0.360652] TCP: reno registered
[    0.360684] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.360731] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.360834] NET: Registered protocol family 1
[    0.360879] pci 0000:00:02.0: Boot video device
[    0.360953] PCI: CLS 64 bytes, default 64
[    0.360969] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.361008] software IO TLB [mem 0xd77aa000-0xdb7a9fff] (64MB) mapped at [ffff8800d77aa000-ffff8800db7a9fff]
[    0.361421] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.362182] VFS: Disk quotas dquot_6.5.2
[    0.362239] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.362442] msgmni has been set to 7504
[    0.362638] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.362698] io scheduler noop registered
[    0.362731] io scheduler deadline registered
[    0.362766] io scheduler cfq registered (default)
[    0.362925] intel_idle: MWAIT substates: 0x1120
[    0.362926] intel_idle: v0.4 model 0x25
[    0.362926] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.362989] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.363054] ACPI: Power Button [PBTN]
[    0.363106] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.363166] ACPI: Power Button [PWRF]
[    0.363221] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.383614] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.403917] 0000:00:16.3: ttyS1 at I/O 0x1188 (irq = 17) is a 16550A
[    0.404058] Linux agpgart interface v0.103
[    0.404116] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    0.404188] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    0.404893] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    0.405007] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    0.405079] [drm] Initialized drm 1.1.0 20060810
[    0.405223] [drm:i915_dump_device_info], i915 device info: gen=5, pciid=0x0042 flags=need_gfx_hws,has_hotplug,has_bsd_ring,
[    0.405230] i915 0000:00:02.0: setting latency timer to 64
[    0.417807] [drm:intel_detect_pch], Found Ibex Peak PCH
[    0.417854] [drm:intel_opregion_setup], graphic opregion physical addr: 0xdb7ac440
[    0.417859] [drm:intel_opregion_setup], SWSCI supported
[    0.417877] i915 0000:00:02.0: irq 40 for MSI/MSI-X
[    0.417882] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.417921] [drm] Driver supports precise vblank timestamp query.
[    0.417958] [drm:init_vbt_defaults], Set default to SSC at 100MHz
[    0.417960] [drm:intel_parse_bios], Using VBT from OpRegion: $VBT IRONLAKE-DESK  d
[    0.417962] [drm:parse_general_features], BDB_GENERAL_FEATURES int_tv_support 0 int_crt_support 1 lvds_use_ssc 0 lvds_ssc_freq 120 display_clock_mode 0
[    0.417963] [drm:parse_general_definitions], crt_ddc_bus_pin: 2
[    0.417966] [drm:parse_lfp_panel_data], Found panel mode in BIOS VBT tables:
[    0.417967] [drm:drm_mode_debug_printmodeline], Modeline 0:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x8 0xa
[    0.417969] [drm:parse_lfp_panel_data], VBT initial LVDS value 300
[    0.417971] [drm:parse_sdvo_panel_data], Found SDVO panel mode in BIOS VBT tables:
[    0.417972] [drm:drm_mode_debug_printmodeline], Modeline 0:"1600x1200" 0 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x8 0xa
[    0.417973] [drm:parse_sdvo_device_mapping], No SDVO device info is found in VBT
[    0.417979] [drm:intel_dsm_pci_probe], no _DSM method for intel device
[    0.417988] [drm:intel_modeset_init], 2 display pipes available.
[    0.417996] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    0.418376] [drm:intel_crt_init], pch crt adpa set to 0xf40000
[    0.418401] [drm:intel_dp_i2c_init], i2c_init DPDDC-C
[    0.419413] [drm:ironlake_init_pch_refclk], has_panel 0 has_lvds 0 has_pch_edp 0 has_cpu_edp 0 has_ck505 0
[    0.419416] [drm:ironlake_init_pch_refclk], Disabling SSC entirely
[    0.421277] [drm:init_status_page], render ring hws offset: 0x00001000
[    0.421614] [drm:init_status_page], bsd ring hws offset: 0x00025000
[    0.421943] [drm:intel_modeset_setup_hw_state], [CRTC:3] hw state readout: enabled
[    0.421944] [drm:intel_modeset_setup_hw_state], [CRTC:5] hw state readout: disabled
[    0.421946] [drm:intel_modeset_setup_hw_state], [ENCODER:8:DAC-8] hw state readout: disabled, pipe=0
[    0.421948] [drm:intel_modeset_setup_hw_state], [ENCODER:9:TMDS-9] hw state readout: disabled, pipe=0
[    0.421950] [drm:intel_dp_get_hw_state], No pipe for dp port 0xe4200 found
[    0.421952] [drm:intel_modeset_setup_hw_state], [ENCODER:14:TMDS-14] hw state readout: enabled, pipe=0
[    0.421954] [drm:intel_modeset_setup_hw_state], [CONNECTOR:7:VGA-1] hw state readout: disabled
[    0.421955] [drm:intel_modeset_setup_hw_state], [CONNECTOR:10:HDMI-A-1] hw state readout: disabled
[    0.421957] [drm:intel_dp_get_hw_state], No pipe for dp port 0xe4200 found
[    0.421958] [drm:intel_modeset_setup_hw_state], [CONNECTOR:13:DP-1] hw state readout: enabled
[    0.421962] [drm:intel_dp_get_hw_state], No pipe for dp port 0xe4200 found
[    0.421963] [drm:intel_connector_check_state], [CONNECTOR:13:DP-1]
[    0.421964] [drm:intel_dp_get_hw_state], No pipe for dp port 0xe4200 found
[    0.421966] [drm:intel_modeset_check_state], [ENCODER:8:DAC-8]
[    0.421967] [drm:intel_modeset_check_state], [ENCODER:9:TMDS-9]
[    0.421969] [drm:intel_modeset_check_state], [ENCODER:14:TMDS-14]
[    0.421971] [drm:intel_dp_get_hw_state], No pipe for dp port 0xe4200 found
[    0.421971] [drm:intel_modeset_check_state], [CRTC:3]
[    0.421973] [drm:intel_modeset_check_state], [CRTC:5]
[    0.421994] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:VGA-1]
[    0.421996] [drm:intel_ironlake_crt_detect_hotplug], trigger hotplug detect cycle: adpa=0xf40000
[    0.435205] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[    0.435206] [drm:intel_crt_detect], CRT not detected via hotplug
[    0.443181] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    0.443183] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    0.443185] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    0.443497] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    0.443498] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    0.443500] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:VGA-1] disconnected
[    0.443501] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:HDMI-A-1]
[    0.451158] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[    0.451160] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[    0.451161] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:HDMI-A-1] disconnected
[    0.451162] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:13:DP-1]
[    0.451467] [drm:intel_dp_detect], DPCD: 1106840100000100
[    0.452481] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[    0.479181] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[    0.480195] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[    0.498536] [drm:i915_hotplug_work_func], running encoder hotplug functions
[    0.507489] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[    0.507491] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 209
[    0.507552] Raw EDID:
[    0.507581]  	00 ff ff ff ff ff ff 00 22 f0 49 29 00 00 00 00
[    0.507618]  	15 15 01 04 a5 33 1d 78 26 01 f5 a2 57 52 9f 27
[    0.507654]  	0a 50 54 a1 08 00 81 c0 81 80 95 00 b3 00 d1 c0
[    0.507691]  	01 01 01 01 01 01 02 3a 80 18 71 38 2d 40 58 2c
[    0.507727]  	45 00 fe 1f 11 00 00 1e 00 00 00 fd 00 32 4c 18
[    0.507764]  	5e 11 00 0a 20 20 20 11 20 00 00 00 fc 00 48 50
[    0.507801]  	20 4c 41 32 33 30 36 0a 20 20 20 00 00 00 ff 00
[    0.507837]  	43 4e 43 31 32 31 31 32 50 42 0a 20 20 00 5a 00
[    0.530912] ------------[ cut here ]------------
[    0.530953] WARNING: at drivers/gpu/drm/i915/intel_dp.c:392 intel_dp_aux_ch+0xd4/0x380()
[    0.531014] Hardware name: HP Compaq 8100 Elite SFF PC
[    0.531049] dp_aux_ch not started status 0x4025003f
[    0.531084] Modules linked in:
[    0.531120] Pid: 6, comm: kworker/u:0 Not tainted 3.7.0-rc7-00113-gcc19528 #75
[    0.531180] Call Trace:
[    0.531214]  [<ffffffff81036899>] ? warn_slowpath_common+0x79/0xc0
[    0.531253]  [<ffffffff81036995>] ? warn_slowpath_fmt+0x45/0x50
[    0.531291]  [<ffffffff812c5d84>] ? intel_dp_aux_ch+0xd4/0x380
[    0.531330]  [<ffffffff812c60d8>] ? intel_dp_aux_native_read_retry+0xa8/0x130
[    0.531372]  [<ffffffff812c6657>] ? intel_dp_get_dpcd+0x17/0x60
[    0.531411]  [<ffffffff812c7589>] ? intel_dp_hot_plug+0x39/0x180
[    0.531450]  [<ffffffff8129a9de>] ? i915_hotplug_work_func+0x6e/0xa0
[    0.531490]  [<ffffffff8104cc40>] ? process_one_work+0x120/0x430
[    0.531528]  [<ffffffff8129a970>] ? i915_error_work_func+0x100/0x100
[    0.531569]  [<ffffffff8104ee4d>] ? worker_thread+0x15d/0x450
[    0.531606]  [<ffffffff8104ecf0>] ? busy_worker_rebind_fn+0x100/0x100
[    0.531647]  [<ffffffff81053953>] ? kthread+0xb3/0xc0
[    0.531684]  [<ffffffff810538a0>] ? kthread_create_on_node+0x110/0x110
[    0.531724]  [<ffffffff814455ac>] ? ret_from_fork+0x7c/0xb0
[    0.532258]  [<ffffffff810538a0>] ? kthread_create_on_node+0x110/0x110
[    0.532300] ---[ end trace 385ceeecb2e396ac ]---
[    0.534584] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[    0.534604] [drm:drm_edid_to_eld], ELD: no CEA Extension found
[    0.534617] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:13:DP-1] probed modes :
[    0.534618] [drm:drm_mode_debug_printmodeline], Modeline 16:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x48 0x5
[    0.534620] [drm:drm_mode_debug_printmodeline], Modeline 20:"1680x1050" 60 146250 1680 1784 1960 2240 1050 1053 1059 1089 0x40 0x6
[    0.534622] [drm:drm_mode_debug_printmodeline], Modeline 47:"1680x945" 60 131481 1680 1784 1960 2240 945 946 949 978 0x0 0x6
[    0.534624] [drm:drm_mode_debug_printmodeline], Modeline 42:"1400x1050" 75 156000 1400 1504 1648 1896 1050 1053 1057 1099 0x40 0x6
[    0.534625] [drm:drm_mode_debug_printmodeline], Modeline 41:"1400x1050" 60 121750 1400 1488 1632 1864 1050 1053 1057 1089 0x40 0x6
[    0.534627] [drm:drm_mode_debug_printmodeline], Modeline 46:"1600x900" 60 118963 1600 1696 1864 2128 900 901 904 932 0x0 0x6
[    0.534629] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[    0.534630] [drm:drm_mode_debug_printmodeline], Modeline 18:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[    0.534632] [drm:drm_mode_debug_printmodeline], Modeline 43:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[    0.534634] [drm:drm_mode_debug_printmodeline], Modeline 19:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[    0.534636] [drm:drm_mode_debug_printmodeline], Modeline 38:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[    0.534637] [drm:drm_mode_debug_printmodeline], Modeline 45:"1366x768" 60 85885 1366 1439 1583 1800 768 769 772 795 0x0 0x6
[    0.534639] [drm:drm_mode_debug_printmodeline], Modeline 40:"1360x768" 60 85500 1360 1424 1536 1792 768 771 777 795 0x40 0x5
[    0.534641] [drm:drm_mode_debug_printmodeline], Modeline 37:"1280x800" 75 106500 1280 1360 1488 1696 800 803 809 838 0x40 0x6
[    0.534643] [drm:drm_mode_debug_printmodeline], Modeline 36:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
[    0.534644] [drm:drm_mode_debug_printmodeline], Modeline 33:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[    0.534646] [drm:drm_mode_debug_printmodeline], Modeline 35:"1280x768" 75 102250 1280 1360 1488 1696 768 771 778 805 0x40 0x9
[    0.534648] [drm:drm_mode_debug_printmodeline], Modeline 34:"1280x768" 60 79500 1280 1344 1472 1664 768 771 778 798 0x40 0x6
[    0.534650] [drm:drm_mode_debug_printmodeline], Modeline 17:"1280x720" 60 74440 1280 1336 1472 1664 720 721 724 746 0x0 0x6
[    0.534651] [drm:drm_mode_debug_printmodeline], Modeline 32:"1024x768" 75 78750 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[    0.534653] [drm:drm_mode_debug_printmodeline], Modeline 31:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[    0.534655] [drm:drm_mode_debug_printmodeline], Modeline 24:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[    0.534656] [drm:drm_mode_debug_printmodeline], Modeline 44:"1024x576" 60 46970 1024 1064 1168 1312 576 577 580 597 0x0 0x6
[    0.534658] [drm:drm_mode_debug_printmodeline], Modeline 28:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[    0.534660] [drm:drm_mode_debug_printmodeline], Modeline 29:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[    0.534662] [drm:drm_mode_debug_printmodeline], Modeline 21:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[    0.534663] [drm:drm_mode_debug_printmodeline], Modeline 27:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[    0.534665] [drm:drm_mode_debug_printmodeline], Modeline 30:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[    0.534667] [drm:drm_mode_debug_printmodeline], Modeline 26:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[    0.534668] [drm:drm_mode_debug_printmodeline], Modeline 25:"640x480" 73 31500 640 664 704 832 480 489 492 520 0x40 0xa
[    0.534670] [drm:drm_mode_debug_printmodeline], Modeline 22:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[    0.534672] [drm:drm_mode_debug_printmodeline], Modeline 23:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[    0.534674] [drm:drm_setup_crtcs], 
[    0.534675] [drm:drm_enable_connectors], connector 7 enabled? no
[    0.534676] [drm:drm_enable_connectors], connector 10 enabled? no
[    0.534677] [drm:drm_enable_connectors], connector 13 enabled? yes
[    0.534678] [drm:drm_target_preferred], looking for cmdline mode on connector 13
[    0.534679] [drm:drm_target_preferred], looking for preferred mode on connector 13
[    0.534680] [drm:drm_target_preferred], found mode 1920x1080
[    0.534681] [drm:drm_setup_crtcs], picking CRTCs for 8192x8192 config
[    0.534682] [drm:drm_setup_crtcs], desired mode 1920x1080 set on crtc 3
[    0.539626] [drm:intel_dp_check_link_status], TMDS-14: channel EQ not ok, retraining
[    0.539839] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    0.540552] [drm:intel_dp_start_link_train], clock recovery OK
[    0.547271] [drm:intelfb_create], allocated 1920x1080 fb: 0x00047000, bo ffff880112a24c00
[    0.547311] fbcon: inteldrmfb (fb0) is primary device
[    0.547603] [drm:intel_dp_link_down], 
[    0.574979] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    0.575687] [drm:intel_dp_start_link_train], clock recovery OK
[    0.582720] [drm:intel_dp_link_down], 
[    0.606881] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    0.607589] [drm:intel_dp_start_link_train], clock recovery OK
[    0.614621] [drm:intel_dp_link_down], 
[    0.638784] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    0.639492] [drm:intel_dp_start_link_train], clock recovery OK
[    0.646524] [drm:intel_dp_link_down], 
[    0.670687] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    0.671395] [drm:intel_dp_start_link_train], clock recovery OK
[    0.678427] [drm:intel_dp_link_down], 
[    0.702589] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    0.703298] [drm:intel_dp_start_link_train], clock recovery OK
[    0.710330] [drm:intel_dp_link_down], 
[    0.734492] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    0.735200] [drm:intel_dp_start_link_train], clock recovery OK
[    0.735201] [drm:intel_dp_complete_link_train] *ERROR* failed to train DP, aborting
[    0.735202] [drm:intel_dp_link_down], 
[    0.762413] [drm:intel_crtc_set_config], [CRTC:3] [FB:49] #connectors=1 (x y) (0 0)
[    0.762414] [drm:intel_set_config_compute_mode_changes], crtc has no fb, full mode set
[    0.762415] [drm:intel_set_config_compute_mode_changes], modes are different, full mode set
[    0.762417] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    0.762419] [drm:drm_mode_debug_printmodeline], Modeline 48:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x48 0x5
[    0.762420] [drm:intel_modeset_stage_output_state], [CONNECTOR:13:DP-1] to [CRTC:3]
[    0.762421] [drm:intel_crtc_set_config], attempting to set mode from userspace
[    0.762422] [drm:drm_mode_debug_printmodeline], Modeline 48:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x48 0x5
[    0.762424] [drm:intel_set_mode], set mode pipe masks: modeset: 1, prepare: 1, disable: 0
[    0.762426] [drm:intel_dp_mode_fixup], DP link computation with max lane count 4 max bw 06 pixel clock 148500KHz
[    0.762427] [drm:intel_dp_mode_fixup], DP link bw 06 lane count 4 clock 162000 bpp 24
[    0.762427] [drm:intel_dp_mode_fixup], DP link bw required 356400 available 518400
[    0.762428] [drm:intel_modeset_adjusted_mode], [CRTC:3]
[    0.762632] [drm:intel_dp_link_down], 
[    0.893805] ------------[ cut here ]------------
[    0.893810] WARNING: at drivers/gpu/drm/i915/intel_display.c:1009 ironlake_crtc_disable+0xaf/0x8e0()
[    0.893811] Hardware name: HP Compaq 8100 Elite SFF PC
[    0.893811] pipe_off wait timed out
[    0.893812] Modules linked in:
[    0.893813] Pid: 1, comm: swapper/0 Tainted: G        W    3.7.0-rc7-00113-gcc19528 #75
[    0.893813] Call Trace:
[    0.893818]  [<ffffffff81036899>] ? warn_slowpath_common+0x79/0xc0
[    0.893819]  [<ffffffff81036995>] ? warn_slowpath_fmt+0x45/0x50
[    0.893820]  [<ffffffff812b5ceb>] ? intel_wait_for_pipe_off+0x5b/0x170
[    0.893821]  [<ffffffff812b669f>] ? ironlake_crtc_disable+0xaf/0x8e0
[    0.893823]  [<ffffffff81281294>] ? drm_ut_debug_printk+0x44/0x70
[    0.893825]  [<ffffffff812bd4c6>] ? intel_set_mode+0x306/0x920
[    0.893827]  [<ffffffff812be1d1>] ? intel_crtc_set_config+0x6f1/0x950
[    0.893830]  [<ffffffff81442f61>] ? __mutex_lock_slowpath+0xd1/0x140
[    0.893833]  [<ffffffff8127545f>] ? drm_fb_helper_set_par+0x6f/0xe0
[    0.893836]  [<ffffffff8120c7bf>] ? fbcon_init+0x55f/0x5f0
[    0.893838]  [<ffffffff8125af8c>] ? visual_init+0xac/0x110
[    0.893839]  [<ffffffff8125c7ec>] ? bind_con_driver+0x16c/0x340
[    0.893841]  [<ffffffff8125ca20>] ? take_over_console+0x60/0x70
[    0.893842]  [<ffffffff8120ab6b>] ? fbcon_takeover+0x5b/0xc0
[    0.893845]  [<ffffffff81059375>] ? notifier_call_chain+0x45/0x60
[    0.893846]  [<ffffffff81059555>] ? __blocking_notifier_call_chain+0x55/0x80
[    0.893847]  [<ffffffff8120415f>] ? register_framebuffer+0x1af/0x2e0
[    0.893849]  [<ffffffff812756c4>] ? drm_fb_helper_single_fb_probe+0x1f4/0x320
[    0.893850]  [<ffffffff81275999>] ? drm_fb_helper_initial_config+0x1a9/0x220
[    0.893853]  [<ffffffff810dd13d>] ? __kmalloc+0xed/0x130
[    0.893856]  [<ffffffff812d6ead>] ? intel_fbdev_init+0x7d/0xb0
[    0.893857]  [<ffffffff81298e55>] ? i915_driver_load+0xd95/0xf00
[    0.893859]  [<ffffffff81283fa5>] ? drm_get_pci_dev+0x185/0x2c0
[    0.893861]  [<ffffffff811f3d41>] ? pci_device_probe+0xd1/0x170
[    0.893862]  [<ffffffff812e9ed8>] ? driver_probe_device+0x68/0x220
[    0.893863]  [<ffffffff812ea123>] ? __driver_attach+0x93/0xa0
[    0.893864]  [<ffffffff812ea090>] ? driver_probe_device+0x220/0x220
[    0.893865]  [<ffffffff812e836d>] ? bus_for_each_dev+0x4d/0x80
[    0.893866]  [<ffffffff812e9648>] ? bus_add_driver+0x178/0x260
[    0.893867]  [<ffffffff812ea724>] ? driver_register+0x84/0x180
[    0.893869]  [<ffffffff8188c7c4>] ? drm_core_init+0x12f/0x12f
[    0.893871]  [<ffffffff810002e2>] ? do_one_initcall+0x122/0x170
[    0.893872]  [<ffffffff8142c6bc>] ? kernel_init+0x11c/0x2a0
[    0.893874]  [<ffffffff8186c54a>] ? do_early_param+0x83/0x83
[    0.893876]  [<ffffffff8105e761>] ? schedule_tail+0x21/0xb0
[    0.893877]  [<ffffffff8142c5a0>] ? rest_init+0x70/0x70
[    0.893878]  [<ffffffff814455ac>] ? ret_from_fork+0x7c/0xb0
[    0.893879]  [<ffffffff8142c5a0>] ? rest_init+0x70/0x70
[    0.893880] ---[ end trace 385ceeecb2e396ad ]---
[    0.949634] [drm:intel_disable_transcoder] *ERROR* failed to disable transcoder 0
[    0.949840] [drm:intel_choose_pipe_bpp_dither], clamping display bpc (was -1) to EDID reported max of 8
[    0.949841] [drm:intel_choose_pipe_bpp_dither], setting pipe bpc to 8 (max display bpc 8)
[    0.949842] [drm:ironlake_crtc_mode_set], Mode for pipe 0:
[    0.949844] [drm:drm_mode_debug_printmodeline], Modeline 48:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x48 0x5
[    0.949845] [drm:intel_get_pch_pll], CRTC:3 using pre-allocated PCH PLL c6014
[    0.949845] [drm:intel_get_pch_pll], using pll 0 for pipe 0
[    0.949846] [drm:intel_get_pch_pll], switching PLL c6014 off
[    1.005465] [drm:ironlake_wait_for_vblank], vblank wait timed out
[    1.005468] [drm:ironlake_update_plane], Writing base 00047000 00000000 0 0 7680
[    1.005470] [drm:ironlake_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[    1.005471] [drm:ironlake_check_srwm], watermark 1: display plane 91, fbc lines 3, cursor 6
[    1.005472] [drm:ironlake_check_srwm], watermark 2: display plane 202, fbc lines 4, cursor 10
[    1.005474] [drm:intel_set_mode], [ENCODER:14:TMDS-14] set [MODE:48:1920x1080]
[    1.005475] [drm:ironlake_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[    1.005477] [drm:ironlake_check_srwm], watermark 1: display plane 91, fbc lines 3, cursor 6
[    1.005478] [drm:ironlake_check_srwm], watermark 2: display plane 202, fbc lines 4, cursor 10
[    1.061295] [drm:ironlake_wait_for_vblank], vblank wait timed out
[    1.117125] [drm:ironlake_wait_for_vblank], vblank wait timed out
[    1.117428] [drm:ironlake_fdi_link_train], FDI_RX_IIR 0x700
[    1.117429] [drm:ironlake_fdi_link_train], FDI train 1 done.
[    1.117581] [drm:ironlake_fdi_link_train], FDI_RX_IIR 0x600
[    1.117582] [drm:ironlake_fdi_link_train], FDI train 2 done.
[    1.117582] [drm:ironlake_fdi_link_train], FDI train done
[    1.117583] [drm:intel_enable_pch_pll], enable PCH PLL c6014 (active 0, on? 0)for crtc 3
[    1.117584] [drm:intel_enable_pch_pll], enabling PCH PLL c6014
[    1.117826] [drm:intel_prepare_page_flip], preparing flip with no unpin work?
[    1.119191] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    1.119900] [drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[    1.120609] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.121318] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.122027] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.122735] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.123444] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.124153] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.124862] [drm:intel_dp_start_link_train], too many voltage retries, give up
[    1.126071] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    1.126780] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04400000
[    1.127489] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04400000
[    1.128198] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    1.128907] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    1.129616] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.130324] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.131033] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.131742] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.132451] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.133160] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.133869] [drm:intel_dp_start_link_train], too many voltage retries, give up
[    1.135078] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    1.135787] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04400000
[    1.136496] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04400000
[    1.137205] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    1.137913] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    1.138622] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.139331] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.140040] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.140749] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.141458] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.142166] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.142875] [drm:intel_dp_start_link_train], too many voltage retries, give up
[    1.144084] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    1.144793] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04400000
[    1.145502] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04400000
[    1.146211] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    1.146920] [drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[    1.147629] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.148338] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.149047] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.149755] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.150464] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.151173] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.151882] [drm:intel_dp_start_link_train], too many voltage retries, give up
[    1.153091] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    1.153800] [drm:intel_dp_start_link_train], clock recovery OK
[    1.176945] [drm:intel_dp_get_hw_state], No pipe for dp port 0xe4200 found
[    1.176946] [drm:intel_connector_check_state], [CONNECTOR:13:DP-1]
[    1.176947] [drm:intel_dp_get_hw_state], No pipe for dp port 0xe4200 found
[    1.176948] [drm:intel_modeset_check_state], [ENCODER:8:DAC-8]
[    1.176949] [drm:intel_modeset_check_state], [ENCODER:9:TMDS-9]
[    1.176951] [drm:intel_modeset_check_state], [ENCODER:14:TMDS-14]
[    1.176952] [drm:intel_dp_get_hw_state], No pipe for dp port 0xe4200 found
[    1.176952] [drm:intel_modeset_check_state], [CRTC:3]
[    1.176953] [drm:intel_modeset_check_state], [CRTC:5]
[    1.176954] [drm:intel_crtc_set_config], [CRTC:5] [NOFB]
[    1.176955] [drm:intel_modeset_stage_output_state], [CONNECTOR:13:DP-1] to [CRTC:3]
[    1.176974] [drm:intel_crtc_set_config], [CRTC:3] [FB:49] #connectors=1 (x y) (0 0)
[    1.176975] [drm:intel_modeset_stage_output_state], [CONNECTOR:13:DP-1] to [CRTC:3]
[    1.180798] [drm:intel_crtc_set_config], [CRTC:3] [FB:49] #connectors=1 (x y) (0 0)
[    1.180799] [drm:intel_modeset_stage_output_state], [CONNECTOR:13:DP-1] to [CRTC:3]
[    1.184608] Console: switching to colour frame buffer device 240x67
[    1.184610] [drm:intel_crtc_set_config], [CRTC:3] [FB:49] #connectors=1 (x y) (0 0)
[    1.184611] [drm:intel_modeset_stage_output_state], [CONNECTOR:13:DP-1] to [CRTC:3]
[    1.197348] fb0: inteldrmfb frame buffer device
[    1.198501] drm: registered panic notifier
[    1.199692] ACPI Exception: AE_NOT_FOUND, Evaluating _DOD (20120913/video-1149)
[    1.200878] ACPI: Video Device [GFX0] (multi-head: no  rom: yes  post: no)
[    1.202081] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input2
[    1.203280] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.204531] ahci 0000:00:1f.2: version 3.0
[    1.204571] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    1.204618] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x17 impl SATA mode
[    1.205838] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part sxs apst 
[    1.207062] ahci 0000:00:1f.2: setting latency timer to 64
[    1.207370] scsi0 : ahci
[    1.208646] scsi1 : ahci
[    1.209900] scsi2 : ahci
[    1.211148] scsi3 : ahci
[    1.212385] scsi4 : ahci
[    1.213622] scsi5 : ahci
[    1.214835] ata1: SATA max UDMA/133 abar m2048@0xf0426000 port 0xf0426100 irq 41
[    1.216056] ata2: SATA max UDMA/133 abar m2048@0xf0426000 port 0xf0426180 irq 41
[    1.217273] ata3: SATA max UDMA/133 abar m2048@0xf0426000 port 0xf0426200 irq 41
[    1.218482] ata4: DUMMY
[    1.219686] ata5: SATA max UDMA/133 abar m2048@0xf0426000 port 0xf0426300 irq 41
[    1.220915] ata6: DUMMY
[    1.222171] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
[    1.226175] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.227419] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.228704] mousedev: PS/2 mouse device common for all mice
[    1.229957] rtc_cmos 00:03: RTC can wake from S4
[    1.231255] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.232493] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.233760] cpuidle: using governor ladder
[    1.235032] cpuidle: using governor menu
[    1.236323] TCP: cubic registered
[    1.237610] NET: Registered protocol family 10
[    1.238933] mip6: Mobile IPv6
[    1.240158] NET: Registered protocol family 17
[    1.241414] Key type dns_resolver registered
[    1.242735] PM: Hibernation image not present or could not be loaded.
[    1.242741] registered taskstats version 1
[    1.244235] rtc_cmos 00:03: setting system clock to 2012-12-01 09:53:33 UTC (1354355613)
[    1.356467] tsc: Refined TSC clocksource calibration: 3325.374 MHz
[    1.357792] Switching to clocksource tsc
[    1.539914] ata3: SATA link down (SStatus 0 SControl 300)
[    1.541767] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.543070] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.544878] ata5: SATA link down (SStatus 0 SControl 300)
[    1.546255] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[    1.548043] ata2.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
[    1.549816] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.551578] ata2.00: ATAPI: hp       CDDVDW TS-H653T, H6D1, max UDMA/100
[    1.553445] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[    1.555184] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
[    1.557220] ata1.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
[    1.557434] ata1.00: ACPI cmd e3/00:00:00:00:00:a0 (IDLE) succeeded
[    1.557439] ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.558803] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.560111] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.561484] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[    1.563064] ata2.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
[    1.564895] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.566676] ata2.00: configured for UDMA/100
[    1.568701] ata1.00: ATA-8: Hitachi HDS721025CLA682, JP1OA41A, max UDMA/133
[    1.570626] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.572639] ata1.00: failed to get Identify Device Data, Emask 0x1
[    1.573769] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[    1.575116] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
[    1.576703] ata1.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
[    1.576912] ata1.00: ACPI cmd e3/00:00:00:00:00:a0 (IDLE) succeeded
[    1.576918] ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.578334] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.579697] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.582300] ata1.00: failed to get Identify Device Data, Emask 0x1
[    1.582306] ata1.00: configured for UDMA/133
[    1.583982] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HDS72102 JP1O PQ: 0 ANSI: 5
[    1.585531] ACPI: Invalid Power Resource to register!
[    1.585559] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    1.587077] scsi 1:0:0:0: CD-ROM            hp       CDDVDW TS-H653T  H6D1 PQ: 0 ANSI: 5
[    1.587095] sd 0:0:0:0: [sda] Write Protect is off
[    1.587097] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.587108] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.633167]  sda: sda1 sda2 < sda5 >
[    1.634776] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.708120] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    1.709553] VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
[    1.711450] Freeing unused kernel memory: 492k freed
[    1.712926] Write protecting the kernel read-only data: 8192k
[    1.717138] Freeing unused kernel memory: 1744k freed
[    1.719905] Freeing unused kernel memory: 688k freed
[    4.621594] microcode: CPU0 sig=0x20655, pf=0x2, revision=0x2
[    4.627766] ACPI: Invalid PBLK length [7]
[    4.629294] ACPI: Requesting acpi_cpufreq
[    4.630946] ACPI: Invalid PBLK length [7]
[    4.632483] ACPI: Invalid PBLK length [7]
[    4.633892] ACPI: Invalid PBLK length [7]
[    4.694191] microcode: CPU0 updated to revision 0x3, date = 2011-09-01
[    4.695625] microcode: CPU1 sig=0x20655, pf=0x2, revision=0x2
[    4.697544] microcode: CPU1 updated to revision 0x3, date = 2011-09-01
[    4.699355] microcode: CPU2 sig=0x20655, pf=0x2, revision=0x2
[    4.700873] microcode: CPU2 updated to revision 0x3, date = 2011-09-01
[    4.702263] microcode: CPU3 sig=0x20655, pf=0x2, revision=0x2
[    4.703770] microcode: CPU3 updated to revision 0x3, date = 2011-09-01
[    4.705174] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    4.901502] tpm_tis 00:0a: 1.2 TPM (device-id 0xB, rev-id 16)
[    5.031431] wmi: Mapper loaded
[    5.076068] mei 0000:00:16.0: setting latency timer to 64
[    5.076123] mei 0000:00:16.0: irq 42 for MSI/MSI-X
[    5.079129] e1000e: Intel(R) PRO/1000 Network Driver - 2.1.4-k
[    5.080608] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    5.082068] e1000e 0000:00:19.0: setting latency timer to 64
[    5.082108] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    5.083591] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[    5.106091] ACPI: bus type usb registered
[    5.107557] usbcore: registered new interface driver usbfs
[    5.109021] usbcore: registered new interface driver hub
[    5.110509] usbcore: registered new device driver usb
[    5.152890] tpm_tis 00:0a: TPM is disabled/deactivated (0x7)
[    5.154398] parport_pc 00:07: reported by Plug and Play ACPI
[    1.591444] ACPI: Invalid Power Resource to register!
[    5.155886] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
[    5.196183] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.274246] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 78:e3:b5:a0:e5:e4
[    5.275643] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    5.277129] e1000e 0000:00:19.0 eth0: MAC: 9, PHY: 9, PBA No: A002FF-0FF
[    5.278630] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    5.278634] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    5.280084] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    5.285385] ehci_hcd 0000:00:1a.0: debug port 2
[    5.286789] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    5.286808] ehci_hcd 0000:00:1a.0: irq 20, io mem 0xf0426800
[    5.296467] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    5.298013] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    5.299409] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.300860] usb usb1: Product: EHCI Host Controller
[    5.302266] usb usb1: Manufacturer: Linux 3.7.0-rc7-00113-gcc19528 ehci_hcd
[    5.303658] usb usb1: SerialNumber: 0000:00:1a.0
[    5.305183] hub 1-0:1.0: USB hub found
[    5.306572] hub 1-0:1.0: 3 ports detected
[    5.308074] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    5.308077] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    5.309518] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    5.314820] ehci_hcd 0000:00:1d.0: debug port 2
[    5.316217] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    5.316223] ehci_hcd 0000:00:1d.0: irq 20, io mem 0xf0426c00
[    5.321071] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
[    5.322526] cdrom: Uniform CD-ROM driver Revision: 3.20
[    5.323944] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    5.326339] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    5.328302] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    5.329817] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    5.331192] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.332597] usb usb2: Product: EHCI Host Controller
[    5.333917] usb usb2: Manufacturer: Linux 3.7.0-rc7-00113-gcc19528 ehci_hcd
[    5.335226] usb usb2: SerialNumber: 0000:00:1d.0
[    5.336662] hub 2-0:1.0: USB hub found
[    5.337954] hub 2-0:1.0: 3 ports detected
[    5.372805] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.374209] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    5.443426] iTCO_vendor_support: vendor-support=0
[    5.451660] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    5.453726] iTCO_wdt: Found a Q57 TCO device (Version=2, TCOBASE=0xf860)
[    5.455110] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    5.473811] gpio_ich: GPIO from 180 to 255 on gpio_ich
[    5.615504] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    5.747530] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
[    5.749501] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.751635] hub 1-1:1.0: USB hub found
[    5.753720] hub 1-1:1.0: 6 ports detected
[    5.866710] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    5.998744] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
[    6.000103] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    6.002038] hub 2-1:1.0: USB hub found
[    6.004430] hub 2-1:1.0: 8 ports detected
[    6.078117] usb 1-1.1: new high-speed USB device number 3 using ehci_hcd
[    6.110677] input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio1/input/input4
[    6.112435] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
[    6.170245] usb 1-1.1: New USB device found, idVendor=0424, idProduct=2512
[    6.172289] usb 1-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    6.174623] hub 1-1.1:1.0: USB hub found
[    6.176200] hub 1-1.1:1.0: 2 ports detected
[    6.204166] snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[    6.249760] usb 1-1.2: new low-speed USB device number 4 using ehci_hcd
[    6.371236] usb 1-1.2: New USB device found, idVendor=046d, idProduct=c30e
[    6.373293] usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.375285] usb 1-1.2: Product: HID compliant keyboard
[    6.377345] usb 1-1.2: Manufacturer: Logitech
[    6.568590] usbcore: registered new interface driver usbhid
[    6.571382] usbhid: USB HID core driver
[    6.607495] input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.0/input/input5
[    6.608901] hid-generic 0003:046D:C30E.0001: input,hidraw0: USB HID v1.10 Keyboard [Logitech HID compliant keyboard] on usb-0000:00:1a.0-1.2/input0
[    6.612874] input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.1/input/input6
[    6.614495] hid-generic 0003:046D:C30E.0002: input,hidraw1: USB HID v1.10 Device [Logitech HID compliant keyboard] on usb-0000:00:1a.0-1.2/input1
[    8.402016] input: HDA Intel MID HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[    8.405207] input: HDA Intel MID Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    8.408347] input: HDA Intel MID Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    8.411490] input: HDA Intel MID Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    8.414633] input: HDA Intel MID Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    9.437311] Adding 7532540k swap on /dev/sda5.  Priority:-1 extents:1 across:7532540k 
[    9.465423] EXT4-fs (sda1): re-mounted. Opts: (null)
[    9.670962] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[   10.060071] fuse init (API version 7.20)
[   10.094613] loop: module loaded
[   11.174549] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[   11.174554] [drm:intel_crt_detect], CRT not detected via hotplug
[   11.182507] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   11.182514] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   11.182517] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   11.182837] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   11.182839] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   11.182843] [drm:output_poll_execute], [CONNECTOR:7:VGA-1] status updated from 2 to 2
[   11.190469] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   11.190475] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   11.190478] [drm:output_poll_execute], [CONNECTOR:10:HDMI-A-1] status updated from 2 to 2
[   11.190787] [drm:intel_dp_detect], DPCD: 1106840100000100
[   11.191805] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   11.218398] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   11.218408] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[   14.041369] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[   14.141561] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[   14.141717] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   14.772885] [drm:intel_crtc_set_config], [CRTC:3] [FB:49] #connectors=1 (x y) (0 0)
[   14.772890] [drm:intel_modeset_stage_output_state], [CONNECTOR:13:DP-1] to [CRTC:3]
[   17.436611] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[   17.443395] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   19.381685] lp0: using parport0 (interrupt-driven).
[   22.213998] [drm:intel_crtc_set_config], [CRTC:3] [FB:49] #connectors=1 (x y) (0 0)
[   22.214003] [drm:intel_modeset_stage_output_state], [CONNECTOR:13:DP-1] to [CRTC:3]
[   22.255242] [drm:i915_driver_open], 
[   22.255264] [drm:intel_crtc_set_config], [CRTC:3] [FB:49] #connectors=1 (x y) (0 0)
[   22.255268] [drm:intel_modeset_stage_output_state], [CONNECTOR:13:DP-1] to [CRTC:3]
[   22.255269] [drm:intel_crtc_set_config], [CRTC:5] [NOFB]
[   22.255270] [drm:intel_modeset_stage_output_state], [CONNECTOR:13:DP-1] to [CRTC:3]
[   22.255285] [drm:i915_driver_open], 
[   22.330547] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[3] ENCODERS[3]
[   22.330555] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[3] ENCODERS[3]
[   22.330599] [drm:drm_mode_getconnector], [CONNECTOR:7:?]
[   22.330602] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:VGA-1]
[   22.330605] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[   22.330607] [drm:intel_crt_detect], CRT not detected via hotplug
[   22.336258] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   22.336264] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   22.336267] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   22.336587] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   22.336588] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   22.336592] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:VGA-1] disconnected
[   22.336597] [drm:drm_mode_getconnector], [CONNECTOR:7:?]
[   22.336599] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:VGA-1]
[   22.336602] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[   22.336603] [drm:intel_crt_detect], CRT not detected via hotplug
[   22.344234] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   22.344241] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   22.344244] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   22.344563] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   22.344564] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   22.344567] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:VGA-1] disconnected
[   22.344604] [drm:drm_mode_getconnector], [CONNECTOR:10:?]
[   22.344608] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:HDMI-A-1]
[   22.352238] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   22.352245] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   22.352249] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:HDMI-A-1] disconnected
[   22.352257] [drm:drm_mode_getconnector], [CONNECTOR:10:?]
[   22.352260] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:HDMI-A-1]
[   22.360183] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   22.360188] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   22.360191] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:HDMI-A-1] disconnected
[   22.360241] [drm:drm_mode_getconnector], [CONNECTOR:13:?]
[   22.360245] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:13:DP-1]
[   22.360556] [drm:intel_dp_detect], DPCD: 1106840100000100
[   22.361572] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   22.388340] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   22.389364] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   22.415996] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   22.416043] [drm:drm_edid_to_eld], ELD: no CEA Extension found
[   22.416085] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:13:DP-1] probed modes :
[   22.416088] [drm:drm_mode_debug_printmodeline], Modeline 16:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x48 0x5
[   22.416093] [drm:drm_mode_debug_printmodeline], Modeline 20:"1680x1050" 60 146250 1680 1784 1960 2240 1050 1053 1059 1089 0x40 0x6
[   22.416098] [drm:drm_mode_debug_printmodeline], Modeline 47:"1680x945" 60 131481 1680 1784 1960 2240 945 946 949 978 0x0 0x6
[   22.416103] [drm:drm_mode_debug_printmodeline], Modeline 42:"1400x1050" 75 156000 1400 1504 1648 1896 1050 1053 1057 1099 0x40 0x6
[   22.416108] [drm:drm_mode_debug_printmodeline], Modeline 41:"1400x1050" 60 121750 1400 1488 1632 1864 1050 1053 1057 1089 0x40 0x6
[   22.416113] [drm:drm_mode_debug_printmodeline], Modeline 46:"1600x900" 60 118963 1600 1696 1864 2128 900 901 904 932 0x0 0x6
[   22.416117] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   22.416122] [drm:drm_mode_debug_printmodeline], Modeline 18:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[   22.416127] [drm:drm_mode_debug_printmodeline], Modeline 43:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[   22.416132] [drm:drm_mode_debug_printmodeline], Modeline 19:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[   22.416136] [drm:drm_mode_debug_printmodeline], Modeline 38:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   22.416141] [drm:drm_mode_debug_printmodeline], Modeline 45:"1366x768" 60 85885 1366 1439 1583 1800 768 769 772 795 0x0 0x6
[   22.416146] [drm:drm_mode_debug_printmodeline], Modeline 40:"1360x768" 60 85500 1360 1424 1536 1792 768 771 777 795 0x40 0x5
[   22.416151] [drm:drm_mode_debug_printmodeline], Modeline 37:"1280x800" 75 106500 1280 1360 1488 1696 800 803 809 838 0x40 0x6
[   22.416156] [drm:drm_mode_debug_printmodeline], Modeline 36:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
[   22.416161] [drm:drm_mode_debug_printmodeline], Modeline 33:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   22.416165] [drm:drm_mode_debug_printmodeline], Modeline 35:"1280x768" 75 102250 1280 1360 1488 1696 768 771 778 805 0x40 0x9
[   22.416170] [drm:drm_mode_debug_printmodeline], Modeline 34:"1280x768" 60 79500 1280 1344 1472 1664 768 771 778 798 0x40 0x6
[   22.416175] [drm:drm_mode_debug_printmodeline], Modeline 17:"1280x720" 60 74440 1280 1336 1472 1664 720 721 724 746 0x0 0x6
[   22.416180] [drm:drm_mode_debug_printmodeline], Modeline 32:"1024x768" 75 78750 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   22.416185] [drm:drm_mode_debug_printmodeline], Modeline 31:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   22.416190] [drm:drm_mode_debug_printmodeline], Modeline 24:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   22.416195] [drm:drm_mode_debug_printmodeline], Modeline 44:"1024x576" 60 46970 1024 1064 1168 1312 576 577 580 597 0x0 0x6
[   22.416199] [drm:drm_mode_debug_printmodeline], Modeline 28:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   22.416204] [drm:drm_mode_debug_printmodeline], Modeline 29:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   22.416209] [drm:drm_mode_debug_printmodeline], Modeline 21:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   22.416213] [drm:drm_mode_debug_printmodeline], Modeline 27:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   22.416218] [drm:drm_mode_debug_printmodeline], Modeline 30:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[   22.416223] [drm:drm_mode_debug_printmodeline], Modeline 26:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   22.416228] [drm:drm_mode_debug_printmodeline], Modeline 25:"640x480" 73 31500 640 664 704 832 480 489 492 520 0x40 0xa
[   22.416232] [drm:drm_mode_debug_printmodeline], Modeline 22:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   22.416237] [drm:drm_mode_debug_printmodeline], Modeline 23:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   22.416252] [drm:drm_mode_getconnector], [CONNECTOR:13:?]
[   22.416319] [drm:drm_mode_getconnector], [CONNECTOR:7:?]
[   22.416323] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:VGA-1]
[   22.416327] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[   22.416330] [drm:intel_crt_detect], CRT not detected via hotplug
[   22.424008] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   22.424015] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   22.424018] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   22.424337] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   22.424338] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   22.424340] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:VGA-1] disconnected
[   22.424344] [drm:drm_mode_getconnector], [CONNECTOR:7:?]
[   22.424345] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:VGA-1]
[   22.424347] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[   22.424349] [drm:intel_crt_detect], CRT not detected via hotplug
[   22.431963] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   22.431968] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   22.431971] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   22.432288] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   22.432290] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   22.432291] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:VGA-1] disconnected
[   22.432336] [drm:drm_mode_getconnector], [CONNECTOR:10:?]
[   22.432338] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:HDMI-A-1]
[   22.439935] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   22.439940] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   22.439944] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:HDMI-A-1] disconnected
[   22.439950] [drm:drm_mode_getconnector], [CONNECTOR:10:?]
[   22.439954] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:HDMI-A-1]
[   22.447916] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   22.447923] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   22.447929] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:HDMI-A-1] disconnected
[   22.447976] [drm:drm_mode_getconnector], [CONNECTOR:13:?]
[   22.447980] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:13:DP-1]
[   22.448288] [drm:intel_dp_detect], DPCD: 1106840100000100
[   22.449301] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   22.476072] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   22.477096] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   22.503850] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   22.503941] [drm:drm_edid_to_eld], ELD: no CEA Extension found
[   22.503987] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:13:DP-1] probed modes :
[   22.503990] [drm:drm_mode_debug_printmodeline], Modeline 16:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x48 0x5
[   22.503996] [drm:drm_mode_debug_printmodeline], Modeline 20:"1680x1050" 60 146250 1680 1784 1960 2240 1050 1053 1059 1089 0x40 0x6
[   22.504001] [drm:drm_mode_debug_printmodeline], Modeline 47:"1680x945" 60 131481 1680 1784 1960 2240 945 946 949 978 0x0 0x6
[   22.504006] [drm:drm_mode_debug_printmodeline], Modeline 42:"1400x1050" 75 156000 1400 1504 1648 1896 1050 1053 1057 1099 0x40 0x6
[   22.504011] [drm:drm_mode_debug_printmodeline], Modeline 41:"1400x1050" 60 121750 1400 1488 1632 1864 1050 1053 1057 1089 0x40 0x6
[   22.504016] [drm:drm_mode_debug_printmodeline], Modeline 46:"1600x900" 60 118963 1600 1696 1864 2128 900 901 904 932 0x0 0x6
[   22.504021] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   22.504025] [drm:drm_mode_debug_printmodeline], Modeline 18:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[   22.504030] [drm:drm_mode_debug_printmodeline], Modeline 43:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[   22.504035] [drm:drm_mode_debug_printmodeline], Modeline 19:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[   22.504042] [drm:drm_mode_debug_printmodeline], Modeline 38:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   22.504044] [drm:drm_mode_debug_printmodeline], Modeline 45:"1366x768" 60 85885 1366 1439 1583 1800 768 769 772 795 0x0 0x6
[   22.504045] [drm:drm_mode_debug_printmodeline], Modeline 40:"1360x768" 60 85500 1360 1424 1536 1792 768 771 777 795 0x40 0x5
[   22.504047] [drm:drm_mode_debug_printmodeline], Modeline 37:"1280x800" 75 106500 1280 1360 1488 1696 800 803 809 838 0x40 0x6
[   22.504049] [drm:drm_mode_debug_printmodeline], Modeline 36:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
[   22.504050] [drm:drm_mode_debug_printmodeline], Modeline 33:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   22.504052] [drm:drm_mode_debug_printmodeline], Modeline 35:"1280x768" 75 102250 1280 1360 1488 1696 768 771 778 805 0x40 0x9
[   22.504054] [drm:drm_mode_debug_printmodeline], Modeline 34:"1280x768" 60 79500 1280 1344 1472 1664 768 771 778 798 0x40 0x6
[   22.504055] [drm:drm_mode_debug_printmodeline], Modeline 17:"1280x720" 60 74440 1280 1336 1472 1664 720 721 724 746 0x0 0x6
[   22.504057] [drm:drm_mode_debug_printmodeline], Modeline 32:"1024x768" 75 78750 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   22.504059] [drm:drm_mode_debug_printmodeline], Modeline 31:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   22.504060] [drm:drm_mode_debug_printmodeline], Modeline 24:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   22.504062] [drm:drm_mode_debug_printmodeline], Modeline 44:"1024x576" 60 46970 1024 1064 1168 1312 576 577 580 597 0x0 0x6
[   22.504064] [drm:drm_mode_debug_printmodeline], Modeline 28:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   22.504065] [drm:drm_mode_debug_printmodeline], Modeline 29:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   22.504067] [drm:drm_mode_debug_printmodeline], Modeline 21:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   22.504069] [drm:drm_mode_debug_printmodeline], Modeline 27:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   22.504070] [drm:drm_mode_debug_printmodeline], Modeline 30:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[   22.504072] [drm:drm_mode_debug_printmodeline], Modeline 26:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   22.504073] [drm:drm_mode_debug_printmodeline], Modeline 25:"640x480" 73 31500 640 664 704 832 480 489 492 520 0x40 0xa
[   22.504075] [drm:drm_mode_debug_printmodeline], Modeline 22:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   22.504077] [drm:drm_mode_debug_printmodeline], Modeline 23:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   22.504086] [drm:drm_mode_getconnector], [CONNECTOR:13:?]
[   22.637439] [drm:drm_mode_addfb], [FB:50]
[   22.637527] [drm:drm_mode_setcrtc], [CRTC:3]
[   22.637531] [drm:drm_mode_setcrtc], [CONNECTOR:13:DP-1]
[   22.637533] [drm:intel_crtc_set_config], [CRTC:3] [FB:50] #connectors=1 (x y) (0 0)
[   22.637538] [drm:intel_modeset_stage_output_state], [CONNECTOR:13:DP-1] to [CRTC:3]
[   22.649174] [drm:ironlake_update_plane], Writing base 00830000 00000000 0 0 7680
[   22.655092] [drm:intel_prepare_page_flip], preparing flip with no unpin work?
[   32.325164] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[   32.325172] [drm:intel_crt_detect], CRT not detected via hotplug
[   32.333135] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   32.333140] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   32.333143] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   32.333458] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   32.333460] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   32.333462] [drm:output_poll_execute], [CONNECTOR:7:VGA-1] status updated from 2 to 2
[   32.341105] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   32.341111] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   32.341115] [drm:output_poll_execute], [CONNECTOR:10:HDMI-A-1] status updated from 2 to 2
[   32.341423] [drm:intel_dp_detect], DPCD: 1106840100000100
[   32.342439] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   32.369257] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   32.369261] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1

-- 
Meelis Roos (mroos@linux.ee)
