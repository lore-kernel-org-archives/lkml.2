Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab1J0V1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 17:27:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48335 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1J0V1T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 17:27:19 -0400
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: if nolapic not used then system reboots after loading first module (possibly first irq using module)
Date: Thu, 27 Oct 2011 23:27:14 +0200
User-Agent: KMail/1.13.7 (Linux/3.1.0-final-dirty; KDE/4.7.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201110272327.14891.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

I have a system that uses supermicro X8SIL-F mainboard
(with latest bios), 8GB RAM, Intel Xeon X3430 and
SuperTrak EX16350 raid controller.

So far I was using 2.6.28 kernel on this machine. It works
fine. With 3.0.8 there is unfortunately a problem. System
boots but as soon as first (irq using?) module is loaded in initrd
machine restarts back to bios.

I was trying various options and found out that acpi=off
'or nolapic fix the issue (but I see 1 core instead of 4 then).
acpi=ht doesn't fix it.

Going to bisect between 35 and 36 if no one has a clue
what's going on.

I've tested:
2.6.35 - works fine
2.6.36.2 - reboots
2.6.37.6 - reboots
2.6.38.8 - reboots
3.0.8 - reboots the same way .38 does


example log:

Loading pld37.6................ ...................................................
BIOS data check successful
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.37.6-2 (builder@ymir-builder) (gcc version 4.5.2 20110212 (release) (PLD-Linux) ) #1 SMP Thu Apr 7 21:27:39 CEST 2011
[    0.000000] Command line: BOOT_IMAGE=pld37.6 ro root=812 console=tty0 console=ttyS2,38400n81 panic=60 selinux=0
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d400 (usable)
[    0.000000]  BIOS-e820: 000000000009d400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf790000 (usable)
[    0.000000]  BIOS-e820: 00000000bf79e000 - 00000000bf7a0000 type 9
[    0.000000]  BIOS-e820: 00000000bf7a0000 - 00000000bf7ae000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf7ae000 - 00000000bf7d0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf7d0000 - 00000000bf7e0000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf7ed000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed40000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000240000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x240000 max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xbf790 max_arch_pfn = 0x400000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bf790000
[    0.000000] init_memory_mapping: 0000000100000000-0000000240000000
[    0.000000] RAMDISK: 00e2e000 - 00f00000
[    0.000000] ACPI: RSDP 00000000000fa280 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000bf7a0100 00084 (v01 SMCI            20100527 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bf7a0290 000F4 (v04 052710 FACP1450 20100527 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bf7a05f0 06C7B (v02  10605 10605000 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bf7ae000 00040
[    0.000000] ACPI: APIC 00000000bf7a0390 00092 (v02 052710 APIC1450 20100527 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bf7a0430 0003C (v01 052710 OEMMCFG  20100527 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bf7ae040 00073 (v01 052710 OEMB1450 20100527 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000bf7aa5f0 00038 (v01 052710 OEMHPET  20100527 MSFT 00000097)
[    0.000000] ACPI: GSCI 00000000bf7ae0c0 02024 (v01 052710 GMCHSCI  20100527 MSFT 00000097)
[    0.000000] ACPI: DMAR 00000000bf7b00f0 00090 (v01    AMI  OEMDMAR 00000001 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bf7b1580 00363 (v01 DpgPmm    CpuPm 00000012 INTL 20051117)
[    0.000000] ACPI: EINJ 00000000bf7aa630 00130 (v01  AMIER AMI_EINJ 20100527 MSFT 00000097)
[    0.000000] ACPI: BERT 00000000bf7aa7c0 00030 (v01  AMIER AMI_BERT 20100527 MSFT 00000097)
[    0.000000] ACPI: ERST 00000000bf7aa7f0 001B0 (v01  AMIER AMI_ERST 20100527 MSFT 00000097)
[    0.000000] ACPI: HEST 00000000bf7aa9a0 000A8 (v01  AMIER ABC_HEST 20100527 MSFT 00000097)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000240000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000240000000
[    0.000000]   NODE_DATA [000000023fffb000 - 000000023fffffff]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00240000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000bf790
[    0.000000]     0: 0x00100000 -> 0x00240000
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x86] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x87] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x07] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 7, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 20 low level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bf790000 - 00000000bf79e000
[    0.000000] PM: Registered nosave memory: 00000000bf79e000 - 00000000bf7a0000
[    0.000000] PM: Registered nosave memory: 00000000bf7a0000 - 00000000bf7ae000
[    0.000000] PM: Registered nosave memory: 00000000bf7ae000 - 00000000bf7d0000
[    0.000000] PM: Registered nosave memory: 00000000bf7d0000 - 00000000bf7e0000
[    0.000000] PM: Registered nosave memory: 00000000bf7e0000 - 00000000bf7ed000
[    0.000000] PM: Registered nosave memory: 00000000bf7ed000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fed40000
[    0.000000] PM: Registered nosave memory: 00000000fed40000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 23 pages/cpu @ffff8800bf400000 s62080 r8192 d23936 u262144
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2062405
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=pld37.6 ro root=812 console=tty0 console=ttyS2,38400n81 panic=60 selinux=0
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 8188016k/9437184k available (4480k kernel code, 1057676k absent, 191492k reserved, 2668k data, 496k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000]  RCU-based detection of stalled CPUs is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS2] enabled
[    0.000000] allocated 83886080 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Fast TSC calibration using PIT
[    0.003333] Detected 2399.840 MHz processor.
[    0.000005] Calibrating delay loop (skipped), value calculated using timer frequency.. 4801.66 BogoMIPS (lpj=7999466)
[    0.031875] pid_max: default: 32768 minimum: 501
[    0.045762] Security Framework initialized
[    0.058073] AppArmor: AppArmor disabled by boot time parameter
[    0.076234] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.099884] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.122052] Mount-cache hash table entries: 256
[    0.135765] Initializing cgroup subsys cpuacct
[    0.149114] Initializing cgroup subsys memory
[    0.162197] Initializing cgroup subsys devices
[    0.175536] Initializing cgroup subsys freezer
[    0.188879] Initializing cgroup subsys net_cls
[    0.202221] Initializing cgroup subsys blkio
[    0.215066] CPU: Physical Processor ID: 0
[    0.227116] CPU: Processor Core ID: 0
[    0.238124] mce: CPU supports 9 MCE banks
[    0.250175] CPU0: Thermal monitoring enabled (TM1)
276334] Performance Events: PEBS fmt1+, Nehalem events, Intel PMU driver.
[    0.297954] ... version:                3
[    0.310027] ... bit width:              48
[    0.322332] ... generic registers:      4
[    0.334378] ... value mask:             0000ffffffffffff
[    0.350318] ... max period:             000000007fffffff
[    0.366259] ... fixed-purpose events:   3
[    0.378300] ... event mask:             000000070000000f
[    0.394420] ACPI: Core revision 20101013
[    0.436231] Setting APIC routing to flat
[    0.448353] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.499300] CPU0: Intel(R) Xeon(R) CPU           X3430  @ 2.40GHz stepping 05
[    0.626287] NMI watchdog enabled, takes one hw-pmu counter.
[    0.643089] Booting Node   0, Processors  #1
[    0.769037] NMI watchdog enabled, takes one hw-pmu counter.
[    0.786417]  #2
[    0.905450] NMI watchdog enabled, takes one hw-pmu counter.
[    0.922833]  #3
[    1.041864] NMI watchdog enabled, takes one hw-pmu counter.
[    1.059206] Brought up 4 CPUs
[    1.068132] Total of 4 processors activated (19206.81 BogoMIPS).
[    1.087335] devtmpfs: initialized
[    1.099353] regulator: core version 0.5
[    1.110933] regulator: dummy: 
[    1.120135] NET: Registered protocol family 16
[    1.133716] ACPI: bus type pci registered
[    1.145862] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    1.173758] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    1.225563] PCI: Using configuration type 1 for base access
[    1.243686] bio: create slab <bio-0> at 0
[    1.257791] ACPI: Executed 1 blocks of module-level executable AML code
[    1.281799] ACPI: SSDT 00000000bf7b0180 00F20 (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
[    1.306987] ACPI: Dynamic OEM Table Load:
[    1.319174] ACPI: SSDT            (nil) 00F20 (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
[    1.344269] ACPI: SSDT 00000000bf7b10a0 004D5 (v01  PmRef  P001Cst 00003001 INTL 20051117)
[    1.369401] ACPI: Dynamic OEM Table Load:
[    1.381582] ACPI: SSDT            (nil) 004D5 (v01  PmRef  P001Cst 00003001 INTL 20051117)
[    1.406782] ACPI: Interpreter enabled
[    1.417777] ACPI: (supports S0 S1 S4 S5)
[    1.429866] ACPI: Using IOAPIC for interrupt routing
[    1.446312] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-723)
[    1.468748] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-723)
[    1.491128] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-723)
[    1.516878] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-723)
[    1.539441] ACPI: No dock devices found.
[    1.551233] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.578850] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.597622] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.617460] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.637290] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.659214] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
[    1.681123] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xdfffffff]
[    1.703032] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfed8ffff]
[    1.726175] pci 0000:00:03.0: PCI bridge to [bus 01-01]
[    1.742023] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    1.771991] pci 0000:00:05.0: PCI bridge to [bus 02-04]
[    1.787842] pci 0000:02:00.0: PCI bridge to [bus 03-03]
[    1.803594] pci 0000:02:00.2: PCI bridge to [bus 04-04]
[    1.819313] pci 0000:00:1c.0: PCI bridge to [bus 05-05]
[    1.840630] pci 0000:00:1c.4: PCI bridge to [bus 06-06]
[    1.856742] pci 0000:00:1c.5: PCI bridge to [bus 07-07]
[    1.872582] pci 0000:00:1e.0: PCI bridge to [bus 08-08] (subtractive decode)
[    1.903365] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12 14 15)
[    1.924871] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 6 7 10 *11 12 14 15)
[    1.946363] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 *10 11 12 14 15)
[    1.967853] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12 *14 15)
[    1.989349] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
[    2.014400] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 *7 10 11 12 14 15)
[    2.035893] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
[    2.060918] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 7 10 11 12 14 *15)
[    2.082471] HEST: HEST table parsing is initialized.
[    2.097453] vgaarb: device added: PCI:0000:08:03.0,decodes=io+mem,owns=io+mem,locks=none
[    2.121704] vgaarb: loaded
[    2.130160] PCI: Using ACPI for IRQ routing
[    2.142972] NetLabel: Initializing
[    2.153194] NetLabel:  domain hash size = 128
[    2.166277] NetLabel:  protocols = UNLABELED CIPSOv4
[    2.181189] NetLabel:  unlabeled traffic allowed by default
[    2.197915] HPET: 8 timers in total, 5 timers will be used for per-cpu timer
[    2.219039] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 40, 41, 42, 43, 44, 0
[    2.239553] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    2.266639] Switching to clocksource tsc
[    2.279408] pnp: PnP ACPI init
[    2.288617] ACPI: bus type pnp registered
[    2.303530] pnp: PnP ACPI: found 16 devices
[    2.316094] ACPI: ACPI bus type pnp unregistered
[    2.329963] system 00:01: [mem 0xfc000000-0xfcffffff] has been reserved
[    2.349791] system 00:01: [mem 0xfd000000-0xfdffffff] has been reserved
[    2.369622] system 00:01: [mem 0xfe000000-0xfebfffff] has been reserved
[    2.389454] system 00:01: [mem 0xfed14000-0xfed19fff] has been reserved
[    2.409291] system 00:09: [io  0x164e-0x164f] has been reserved
[    2.427045] system 00:0a: [io  0x0a00-0x0a0f] has been reserved
[    2.444799] system 00:0a: [io  0x0a10-0x0a1f] has been reserved
[    2.462557] system 00:0b: [io  0x0ca2-0x0ca3] has been reserved
[    2.480310] system 00:0b: [io  0x0cf8-0x0cff] could not be reserved
[    2.499105] system 00:0b: [io  0x04d0-0x04d1] has been reserved
[    2.516860] system 00:0b: [io  0x0800-0x087f] has been reserved
[    2.534618] system 00:0b: [io  0x0500-0x057f] has been reserved
[    2.552373] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    2.572206] system 00:0b: [mem 0xfed20000-0xfed3ffff] has been reserved
[    2.592039] system 00:0b: [mem 0xfed40000-0xfed8ffff] has been reserved
[    2.611875] system 00:0d: [mem 0xfec00000-0xfec00fff] could not be reserved
[    2.632744] system 00:0d: [mem 0xfee00000-0xfee00fff] has been reserved
[    2.652584] system 00:0e: [mem 0xe0000000-0xefffffff] has been reserved
[    2.672411] system 00:0f: [mem 0x000c0000-0x000cffff] has been reserved
[    2.692243] system 00:0f: [mem 0x000e0000-0x000fffff] could not be reserved
[    2.713114] system 00:0f: [mem 0xfed90000-0xffffffff] could not be reserved
[    2.741788] pci 0000:00:1c.0: BAR 14: assigned [mem 0xc0000000-0xc01fffff]
[    2.762412] pci 0000:00:1c.0: BAR 15: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
[    2.785892] pci 0000:00:1c.4: BAR 15: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
[    2.809386] pci 0000:00:1c.5: BAR 15: assigned [mem 0xc0600000-0xc07fffff 64bit pref]
[    2.832878] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[    2.851422] pci 0000:00:03.0: PCI bridge to [bus 01-01]
[    2.867099] pci 0000:00:03.0:   bridge window [io  disabled]
[    2.884077] pci 0000:00:03.0:   bridge window [mem disabled]
[    2.901056] pci 0000:00:03.0:   bridge window [mem pref disabled]
[    2.919333] pci 0000:02:00.0: PCI bridge to [bus 03-03]
[    2.935007] pci 0000:02:00.0:   bridge window [io  disabled]
[    2.951988] pci 0000:02:00.0:   bridge window [mem 0xfb400000-0xfb4fffff]
[    2.972342] pci 0000:02:00.0:   bridge window [mem 0xf9f00000-0xf9ffffff 64bit pref]
[    2.995564] pci 0000:02:00.2: PCI bridge to [bus 04-04]
[    3.011248] pci 0000:02:00.2:   bridge window [io  disabled]
[    3.028236] pci 0000:02:00.2:   bridge window [mem disabled]
[    3.045206] pci 0000:02:00.2:   bridge window [mem pref disabled]
[    3.063484] pci 0000:00:05.0: PCI bridge to [bus 02-04]
[    3.079158] pci 0000:00:05.0:   bridge window [io  disabled]
[    3.096140] pci 0000:00:05.0:   bridge window [mem 0xfb400000-0xfb4fffff]
[    3.116492] pci 0000:00:05.0:   bridge window [mem 0xf9f00000-0xf9ffffff 64bit pref]
[    3.139714] pci 0000:00:1c.0: PCI bridge to [bus 05-05]
[    3.155402] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    3.173680] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff]
[    3.194032] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
[    3.217255] pci 0000:00:1c.4: PCI bridge to [bus 06-06]
[    3.232941] pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
[    3.251219] pci 0000:00:1c.4:   bridge window [mem 0xfb500000-0xfb5fffff]
[    3.271571] pci 0000:00:1c.4:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
[    3.294796] pci 0000:00:1c.5: PCI bridge to [bus 07-07]
[    3.310480] pci 0000:00:1c.5:   bridge window [io  0xe000-0xefff]
[    3.328760] pci 0000:00:1c.5:   bridge window [mem 0xfb600000-0xfb6fffff]
[    3.349112] pci 0000:00:1c.5:   bridge window [mem 0xc0600000-0xc07fffff 64bit pref]
[    3.372335] pci 0000:00:1e.0: PCI bridge to [bus 08-08]
[    3.388018] pci 0000:00:1e.0:   bridge window [io  disabled]
[    3.405000] pci 0000:00:1e.0:   bridge window [mem 0xfb700000-0xfbffffff]
[    3.425357] pci 0000:00:1e.0:   bridge window [mem 0xfa000000-0xfaffffff 64bit pref]
[    3.448584] pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.468684] pci 0000:00:05.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.488784] pci 0000:00:1c.0: enabling device (0104 -> 0107)
[    3.505774] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    3.525872] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    3.545963] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    3.566127] NET: Registered protocol family 2
[    3.579387] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    3.602165] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    3.627180] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    3.647587] TCP: Hash tables configured (established 524288 bind 65536)
[    3.667420] TCP reno registered
[    3.676874] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    3.695209] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    3.714897] NET: Registered protocol family 1
[    3.728052] pci 0000:02:00.0: rerouting interrupts for [8086:0370]
[    3.746596] pci 0000:02:00.2: rerouting interrupts for [8086:0372]
[    3.765251] Trying to unpack rootfs image as initramfs...
[    3.782052] rootfs image is not initramfs (no cpio magic); looks like an initrd
[    3.804379] Freeing initrd memory: 840k freed
[    3.817554] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    3.836853] Placing 64MB software IO TLB between ffff8800bb400000 - ffff8800bf400000
[    3.860077] software IO TLB at phys 0xbb400000 - 0xbf400000
[    3.877820] audit: initializing netlink socket (disabled)
[    3.894023] type=2000 audit(1319757700.289:1): initialized
[    3.929433] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.949038] CE: hpet3 increased min_delta_ns to 7500 nsec
[    3.962817] VFS: Disk quotas dquot_6.5.2
[    3.962871] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.962950] ROMFS MTD (C) 2007 Red Hat, Inc.
[    3.962993] msgmni has been set to 15993
[    3.963217] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    3.963232] io scheduler noop registered
[    3.963233] io scheduler deadline registered
[    3.963303] io scheduler cfq registered (default)
[    3.963851] pcieport 0000:00:03.0: ACPI _OSC control granted for 0x1c
[    3.964344] pcieport 0000:00:05.0: ACPI _OSC control granted for 0x1c
[    3.964830] pcieport 0000:00:1c.0: ACPI _OSC control granted for 0x1c
[    3.965339] pcieport 0000:00:1c.4: ACPI _OSC control granted for 0x1c
[    3.965852] pcieport 0000:00:1c.5: ACPI _OSC control granted for 0x1c
[    3.966091] pcieport 0000:00:03.0: Signaling PME through PCIe PME interrupt
[    3.966100] pcieport 0000:00:05.0: Signaling PME through PCIe PME interrupt
[    3.966102] pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
[    3.966103] pci 0000:03:0e.0: Signaling PME through PCIe PME interrupt
[    3.966105] pci 0000:02:00.2: Signaling PME through PCIe PME interrupt
[    3.966124] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    3.966145] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
[    3.966146] pci 0000:06:00.0: Signaling PME through PCIe PME interrupt
[    3.966166] pcieport 0000:00:1c.5: Signaling PME through PCIe PME interrupt
[    3.966168] pci 0000:07:00.0: Signaling PME through PCIe PME interrupt
[    4.380647] CE: hpet3 increased min_delta_ns to 11250 nsec
[    4.380650] hrtimer: interrupt took 2817 ns
[    4.409883] APEI: Can not request iomem region <00000000bf7c591a-00000000bf7c591c> for GARs.
[    4.460664] Linux agpgart interface v0.103
[    4.473050] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.764512] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    5.123920] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
�[    5.466699] serial8250: ttyS2 at I/O 0x3e8 (irq = 5) is a 16550A
[    5.623733] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    5.706844] 00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    5.786713] 00:08: ttyS2 at I/O 0x3e8 (irq = 5) is a 16550A
[    5.847772] brd: module loaded
[    5.857026] Fixed MDIO Bus: probed
[    5.867387] PNP: No PS/2 controller found. Probing ports directly.
[    5.888483] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.903439] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.918750] mice: PS/2 mouse device common for all mice
[    5.934484] rtc_cmos 00:03: RTC can wake from S4
[    5.972520] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    5.990819] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    6.011633] cpuidle: using governor ladder
[    6.024796] cpuidle: using governor menu
[    6.036884] TCP cubic registered
[    6.047949] NET: Registered protocol family 10
[    6.062304] lo: Disabled Privacy Extensions
[    6.074915] Mobile IPv6
[    6.082369] NET: Registered protocol family 17
[    6.097184] Registering the dns_resolver key type
[    6.112025] TuxOnIce: Ignoring late initcall, as requested.
[    6.128789] registered taskstats version 1
[    6.141635] rtc_cmos 00:03: setting system clock to 2011-10-27 23:21:45 UTC (1319757705)
[    6.165931] Initalizing network drop monitor service
[    6.181062] RAMDISK: gzip image found at block 0
[    6.213139] VFS: Mounted root (romfs filesystem) readonly on device 1:0.
[    6.251170] usbcore: registered new interface driver usbfs
[    6.268298] usbcore: registered new interface driver hub
[    6.284795] usbcore: registered new device driver usb
[    6.302695] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.322342] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    6.343957] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    6.359711] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1

and here machine reboots to bios (ehci-hcd is loaded from initrd; if for example stex driver
was loaded in initrd and ehci* was not then it still rebooted)

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
