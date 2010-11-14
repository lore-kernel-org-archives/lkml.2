Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab0KNRJj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 12:09:39 -0500
Received: from tomasu.net ([64.85.170.234]:33334 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986Ab0KNRJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 12:09:36 -0500
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: linux-kernel@vger.kernel.org
Subject: kernel lockups with 2.6.36
Date: Sun, 14 Nov 2010 10:09:15 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.5.2; x86_64; svn-1188918; 2010-10-21)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011141009.15691.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today I experienced something odd, several kernel threads locked up in several
different subsystems. It caused X to lock up, and not draw anything, access to
nfs died, and trying to unmount, remount readonly, or do much other than ssh
and copy files with scp (which may or may not have been in cache, might have
been) locked up.

I'm using a vanila 2.6.36.

It looks to me like fscache/cachefiles may have started the problem, but I can't
be sure, and I'm not entirely sure why that would cause i915 to lock up as well.
I've disabled cachefiles for now, thinking that might make it go away.
(its locked up twice today)

here's the entire dmesg:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.36 (moose@lisa) (gcc version 4.4.5 (Debian 4.4.5-2) ) #20 SMP PREEMPT Sat Oct 23 15:33:50 MDT 2010
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.36 root=UUID=8506746e-6a35-4afc-a0d9-a146feaa7a3e ro quiet
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
[    0.000000]  BIOS-e820: 000000000009e800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e3000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bddb0000 (usable)
[    0.000000]  BIOS-e820: 00000000bddb0000 - 00000000bddbe400 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bddbe400 - 00000000bddf0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bddf0000 - 00000000bde00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.5 present.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x140000 max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xbddb0 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] init_memory_mapping: 0000000000000000-00000000bddb0000
[    0.000000] init_memory_mapping: 0000000100000000-0000000140000000
[    0.000000] RAMDISK: 363e7000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f92b0 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000bddb0100 00084 (v01 LENOVO TP-6A    00000560 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bddb0290 000F4 (v03 LENOVO TP-6A    00000560 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bddb0680 0BF45 (v01  LENOV TP-6A    00000180 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bddbe400 00040
[    0.000000] ACPI: APIC 00000000bddb0390 0005C (v01 LENOVO TP-6A    00000560 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bddb0430 0003C (v01 LENOVO TP-6A    00000560 MSFT 00000097)
[    0.000000] ACPI: SLIC 00000000bddb0470 00176 (v01 LENOVO TP-6A    00000560 MSFT 00000097)
[    0.000000] ACPI: ECDT 00000000bddb0620 00054 (v01 LENOVO TP-6A    00000560 MSFT 00000097)
[    0.000000] ACPI: DBGP 00000000bddb03f0 00034 (v01 LENOVO TP-6A    00000560 MSFT 00000097)
[    0.000000] ACPI: BOOT 00000000bddb05f0 00028 (v01 LENOVO TP-6A    00000560 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bddbe440 00071 (v01 LENOVO TP-6A    00000560 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000bddbc5d0 00038 (v01 LENOVO TP-6A    00000560 MSFT 00000097)
[    0.000000] ACPI: GSCI 00000000bddbe4c0 02024 (v01 LENOVO TP-6A    00000560 MSFT 00000097)
[    0.000000] ACPI: ATKG 00000000bddc06f0 08024 (v01 LENOVO TP-6A    00000560 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bddc9240 004E6 (v01  PmRef TP-6A    00000180 INTL 20051117)
[    0.000000] (13/32 early reservations) ==> bootmem [0000000000 - 0140000000]
[    0.000000]   #0 [0001000000 - 000175ad30]    TEXT DATA BSS ==> [0001000000 - 000175ad30]
[    0.000000]   #1 [00363e7000 - 0037ff0000]          RAMDISK ==> [00363e7000 - 0037ff0000]
[    0.000000]   #2 [000175b000 - 000175b204]              BRK ==> [000175b000 - 000175b204]
[    0.000000]   #3 [00000ff790 - 0000100000]    BIOS reserved ==> [00000ff790 - 0000100000]
[    0.000000]   #4 [00000ff780 - 00000ff790]     MP-table mpf ==> [00000ff780 - 00000ff790]
[    0.000000]   #5 [000009e800 - 00000e90e0]    BIOS reserved ==> [000009e800 - 00000e90e0]
[    0.000000]   #6 [00000e92ac - 00000ff780]    BIOS reserved ==> [00000e92ac - 00000ff780]
[    0.000000]   #7 [00000e90e0 - 00000e92ac]     MP-table mpc ==> [00000e90e0 - 00000e92ac]
[    0.000000]   #8 [0000001000 - 0000003000]       TRAMPOLINE ==> [0000001000 - 0000003000]
[    0.000000]   #9 [0000003000 - 0000007000]      ACPI WAKEUP ==> [0000003000 - 0000007000]
[    0.000000]   #10 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]
[    0.000000]   #11 [000000b000 - 000000c000]          PGTABLE ==> [000000b000 - 000000c000]
[    0.000000]   #12 [000000c000 - 0000034000]          BOOTMAP ==> [000000c000 - 0000034000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00140000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bddb0
[    0.000000]     0: 0x00100000 -> 0x00140000
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e3000
[    0.000000] PM: Registered nosave memory: 00000000000e3000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bddb0000 - 00000000bddbe000
[    0.000000] PM: Registered nosave memory: 00000000bddbe000 - 00000000bddbf000
[    0.000000] PM: Registered nosave memory: 00000000bddbf000 - 00000000bddf0000
[    0.000000] PM: Registered nosave memory: 00000000bddf0000 - 00000000bde00000
[    0.000000] PM: Registered nosave memory: 00000000bde00000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffb00000
[    0.000000] PM: Registered nosave memory: 00000000ffb00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at bde00000 (gap: bde00000:41000000)
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880001800000 s79488 r8192 d22912 u1048576
[    0.000000] pcpu-alloc: s79488 r8192 d22912 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1021627
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.36 root=UUID=8506746e-6a35-4afc-a0d9-a146feaa7a3e ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3992472k/5242880k available (3653k kernel code, 1084108k absent, 166300k reserved, 2806k data, 424k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:512
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2527.016 MHz processor.
[    0.001005] Calibrating delay loop (skipped), value calculated using timer frequency.. 5054.03 BogoMIPS (lpj=2527016)
[    0.001008] pid_max: default: 32768 minimum: 301
[    0.001028] Mount-cache hash table entries: 256
[    0.001141] Initializing cgroup subsys ns
[    0.001144] Initializing cgroup subsys cpuacct
[    0.001147] Initializing cgroup subsys devices
[    0.001149] Initializing cgroup subsys freezer
[    0.001150] Initializing cgroup subsys net_cls
[    0.001152] Initializing cgroup subsys blkio
[    0.001181] CPU: Physical Processor ID: 0
[    0.001183] CPU: Processor Core ID: 0
[    0.001185] mce: CPU supports 6 MCE banks
[    0.001191] CPU0: Thermal monitoring enabled (TM2)
[    0.001194] using mwait in idle threads.
[    0.001195] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.001202] ... version:                2
[    0.001203] ... bit width:              40
[    0.001204] ... generic registers:      2
[    0.001206] ... value mask:             000000ffffffffff
[    0.001207] ... max period:             000000007fffffff
[    0.001208] ... fixed-purpose events:   3
[    0.001209] ... event mask:             0000000700000003
[    0.001247] ACPI: Core revision 20100702
[    0.013053] Setting APIC routing to flat
[    0.013360] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.023409] CPU0: Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz stepping 0a
[    0.025109] NMI watchdog enabled, takes one hw-pmu counter.
[    0.028019] Booting Node   0, Processors  #1 Ok.
[    0.100026] NMI watchdog enabled, takes one hw-pmu counter.
[    0.101006] Brought up 2 CPUs
[    0.101008] Total of 2 processors activated (10107.76 BogoMIPS).
[    0.101850] devtmpfs: initialized
[    0.104805] regulator: core version 0.5
[    0.104805] NET: Registered protocol family 16
[    0.105017] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.105019] ACPI: bus type pci registered
[    0.105073] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.105075] PCI: not using MMCONFIG
[    0.105077] PCI: Using configuration type 1 for base access
[    0.105300] bio: create slab <bio-0> at 0
[    0.107604] ACPI: EC: EC description table is found, configuring boot EC
[    0.116836] ACPI: Executed 1 blocks of module-level executable AML code
[    0.120103] ACPI Warning: Incorrect checksum in table [SSDT] - 0x28, should be 0xB7 (20100702/tbutils-314)
[    0.123747] ACPI Warning: Incorrect checksum in table [ATKG] - 0x67, should be 0x83 (20100702/tbutils-314)
[    0.123752] ACPI: SSDT 00000000bddc87f0 00244 (v01  PmRef TP-6A    00000180 INTL 20051117)
[    0.124283] ACPI: Dynamic OEM Table Load:
[    0.124286] ACPI: SSDT (null) 00244 (v01  PmRef TP-6A    00000180 INTL 20051117)
[    0.124581] ACPI: SSDT 00000000bddc8ad0 00765 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.125101] ACPI: Dynamic OEM Table Load:
[    0.125104] ACPI: SSDT (null) 00765 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.125388] ACPI Warning: Incorrect checksum in table [SSDT] - 0x37, should be 0xC7 (20100702/tbutils-314)
[    0.125394] ACPI: SSDT 00000000bddc8720 000C8 (v01  PmRef TP-6A    00000180 INTL 20051117)
[    0.125916] ACPI: Dynamic OEM Table Load:
[    0.125919] ACPI: SSDT (null) 000C8 (v01  PmRef TP-6A    00000180 INTL 20051117)
[    0.126034] ACPI: SSDT 00000000bddc8a40 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20051117)
[    0.126551] ACPI: Dynamic OEM Table Load:
[    0.126553] ACPI: SSDT (null) 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20051117)
[    0.126748] ACPI: Interpreter enabled
[    0.126750] ACPI: (supports S0 S3 S4 S5)
[    0.126769] ACPI: Using IOAPIC for interrupt routing
[    0.126802] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.128305] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.174618] ACPI: EC: GPE = 0x1b, I/O: command/status = 0x66, data = 0x62
[    0.174680] ACPI Warning: Incorrect checksum in table [SSDT] - 0x28, should be 0xB7 (20100702/tbutils-314)
[    0.174906] ACPI: No dock devices found.
[    0.174909] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.175223] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.175438] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.175440] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.175443] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.175445] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
[    0.175447] pci_root PNP0A08:00: host bridge window [mem 0xbde00000-0xffffffff]
[    0.175474] DMAR: Forcing write-buffer flush capability
[    0.175476] DMAR: Disabling IOMMU for graphics on this chipset
[    0.177379] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.177617] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.177619] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.177682] pci 0000:00:1c.2: PCI bridge to [bus 03-0b]
[    0.177927] pci 0000:00:1c.3: PCI bridge to [bus 0c-0c]
[    0.177992] pci 0000:0d:00.0: proprietary Ricoh MMC controller disabled (via firewire function)
[    0.177994] pci 0000:0d:00.0: MMC cards are now supported by standard SDHCI controller
[    0.178554] pci 0000:00:1e.0: PCI bridge to [bus 0d-0d] (subtractive decode)
[    0.187937] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12)
[    0.187988] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 10 12)
[    0.188040] ACPI: PCI Interrupt Link [LNKC] (IRQs *6)
[    0.188087] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 7 10 12)
[    0.188134] ACPI: PCI Interrupt Link [LNKE] (IRQs 6) *0, disabled.
[    0.188181] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 *7 10 12)
[    0.188229] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 *4 5 6 7 10 12)
[    0.188278] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 12)
[    0.188304] HEST: Table is not found!
[    0.188341] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.188354] vgaarb: loaded
[    0.188366] PCI: Using ACPI for IRQ routing
[    0.188366] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.188366] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.188366] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.192015] Switching to clocksource tsc
[    0.192927] pnp: PnP ACPI init
[    0.192936] ACPI: bus type pnp registered
[    0.193880] pnp 00:0c: disabling [mem 0xfd3fac00-0xfd43abff] because it overlaps 0000:00:02.0 BAR 0 [mem 0xfd400000-0xfd7fffff 64bit]
[    0.193886] pnp 00:0c: disabling [mem 0xfd3fac00-0xfd43abff disabled] because it overlaps 0000:00:02.1 BAR 0 [mem 0xfd300000-0xfd3fffff 64bit]
[    0.193896] pnp 00:0c: disabling [mem 0xfd8fac00-0xfd93abff] because it overlaps 0000:00:1c.1 BAR 14 [mem 0xfd900000-0xfd9fffff]
[    0.193901] pnp 00:0c: disabling [mem 0xfdefac00-0xfdf3abff] because it overlaps 0000:00:1c.2 BAR 14 [mem 0xfda00000-0xfe9fffff]
[    0.193904] pnp 00:0c: disabling [mem 0xfe0fac00-0xfe13abff] because it overlaps 0000:00:1c.2 BAR 14 [mem 0xfda00000-0xfe9fffff]
[    0.193911] pnp 00:0c: disabling [mem 0xfe1fac00-0xfe23abff] because it overlaps 0000:00:1c.2 BAR 14 [mem 0xfda00000-0xfe9fffff]
[    0.193914] pnp 00:0c: disabling [mem 0xfdbfac00-0xfdc3abff] because it overlaps 0000:00:1c.2 BAR 14 [mem 0xfda00000-0xfe9fffff]
[    0.194537] pnp: PnP ACPI: found 15 devices
[    0.194539] ACPI: ACPI bus type pnp unregistered
[    0.194546] system 00:01: [mem 0xfed10000-0xfed19fff] has been reserved
[    0.194553] system 00:08: [io  0x04d0-0x04d1] has been reserved
[    0.194556] system 00:08: [io  0x0800-0x087f] has been reserved
[    0.194558] system 00:08: [io  0x0400-0x041f] has been reserved
[    0.194560] system 00:08: [io  0x0480-0x04bf] has been reserved
[    0.194563] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.194565] system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.194568] system 00:08: [mem 0xfed45000-0xfed89fff] has been reserved
[    0.194570] system 00:08: [mem 0xfed90000-0xfed90fff] has been reserved
[    0.194573] system 00:08: [mem 0xfed91000-0xfed91fff] has been reserved
[    0.194575] system 00:08: [mem 0xfed92000-0xfed92fff] has been reserved
[    0.194578] system 00:08: [mem 0xfed93000-0xfed93fff] has been reserved
[    0.194580] system 00:08: [mem 0xffb00000-0xffbfffff] has been reserved
[    0.194583] system 00:08: [mem 0xfff00000-0xffffffff] has been reserved
[    0.194587] system 00:0a: [mem 0xffa00000-0xffbfffff] could not be reserved
[    0.194590] system 00:0a: [mem 0xffe00000-0xffffffff] could not be reserved
[    0.194594] system 00:0b: [mem 0xffc00000-0xffdfffff] has been reserved
[    0.194599] system 00:0c: [io  0x0250-0x0253] has been reserved
[    0.194601] system 00:0c: [io  0x0256-0x025f] has been reserved
[    0.194603] system 00:0c: [io  0x0702-0x0703] has been reserved
[    0.194606] system 00:0c: [io  0x04c0-0x04cf] has been reserved
[    0.194608] system 00:0c: [io  0x04d2-0x04df] has been reserved
[    0.194610] system 00:0c: [io  0x04e0-0x04ef] has been reserved
[    0.194612] system 00:0c: [io  0x04f0-0x04ff] has been reserved
[    0.194615] system 00:0c: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.194617] system 00:0c: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.194620] system 00:0c: [mem 0xf9efc000-0xf9efefff] has been reserved
[    0.194623] system 00:0c: [mem 0xf7ffec00-0xf7ffec03] has been reserved
[    0.194627] system 00:0d: [mem 0xe0000000-0xefffffff] has been reserved
[    0.194631] system 00:0e: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.194634] system 00:0e: [mem 0x000c0000-0x000cffff] has been reserved
[    0.194636] system 00:0e: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.194639] system 00:0e: [mem 0x00100000-0xbddfffff] could not be reserved
[    0.200496] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.200498] pci 0000:00:1c.0:   bridge window [io  disabled]
[    0.200503] pci 0000:00:1c.0:   bridge window [mem disabled]
[    0.200507] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    0.200514] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.200515] pci 0000:00:1c.1:   bridge window [io  disabled]
[    0.200521] pci 0000:00:1c.1:   bridge window [mem 0xfd900000-0xfd9fffff]
[    0.200525] pci 0000:00:1c.1:   bridge window [mem pref disabled]
[    0.200531] pci 0000:00:1c.2: PCI bridge to [bus 03-0b]
[    0.200534] pci 0000:00:1c.2:   bridge window [io  0x6000-0xdfff]
[    0.200539] pci 0000:00:1c.2:   bridge window [mem 0xfda00000-0xfe9fffff]
[    0.200543] pci 0000:00:1c.2:   bridge window [mem 0xfc700000-0xfcefffff 64bit pref]
[    0.200550] pci 0000:00:1c.3: PCI bridge to [bus 0c-0c]
[    0.200553] pci 0000:00:1c.3:   bridge window [io  0xe000-0xefff]
[    0.200558] pci 0000:00:1c.3:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.200562] pci 0000:00:1c.3:   bridge window [mem 0xfcf00000-0xfcffffff 64bit pref]
[    0.200569] pci 0000:00:1e.0: PCI bridge to [bus 0d-0d]
[    0.200571] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.200576] pci 0000:00:1e.0:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.200580] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.200599] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.200616] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.200632] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.200648] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.200717] NET: Registered protocol family 2
[    0.200758] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.201082] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.202425] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.202877] TCP: Hash tables configured (established 262144 bind 65536)
[    0.202880] TCP reno registered
[    0.202883] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.202915] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.203024] NET: Registered protocol family 1
[    0.203275] Unpacking initramfs...
[    0.774648] Freeing initrd memory: 28708k freed
[    0.785910] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.785915] Placing 64MB software IO TLB between ffff880005c02000 - ffff880009c02000
[    0.785917] software IO TLB at phys 0x5c02000 - 0x9c02000
[    0.785978] Simple Boot Flag at 0x51 set to 0x1
[    0.786270] audit: initializing netlink socket (disabled)
[    0.786284] type=2000 audit(1289729205.784:1): initialized
[    0.796934] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.798028] VFS: Disk quotas dquot_6.5.2
[    0.798078] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.798152] msgmni has been set to 7853
[    0.798313] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.798316] io scheduler noop registered
[    0.798318] io scheduler deadline registered
[    0.798342] io scheduler cfq registered (default)
[    0.798783] pcieport 0000:00:1c.0: ACPI _OSC control granted for 0x1d
[    0.798924] pcieport 0000:00:1c.1: ACPI _OSC control granted for 0x1d
[    0.799049] pcieport 0000:00:1c.2: ACPI _OSC control granted for 0x1d
[    0.799189] pcieport 0000:00:1c.3: ACPI _OSC control granted for 0x1d
[    0.799346] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    0.799368] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
[    0.799370] pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
[    0.799391] pcieport 0000:00:1c.2: Signaling PME through PCIe PME interrupt
[    0.799414] pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
[    0.799416] pci 0000:0c:00.0: Signaling PME through PCIe PME interrupt
[    0.799503] ERST: Table is not found!
[    0.799684] Linux agpgart interface v0.103
[    0.799756] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[    0.802031] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    0.822937] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.822964] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.823369] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    0.826634] i8042.c: Detected active multiplexing controller, rev 1.1.
[    0.828175] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.828183] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    0.828186] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    0.828188] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    0.828191] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    0.828252] mice: PS/2 mouse device common for all mice
[    0.828286] rtc_cmos 00:03: RTC can wake from S4
[    0.828321] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.828348] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.828359] cpuidle: using governor ladder
[    0.828360] cpuidle: using governor menu
[    0.828569] TCP cubic registered
[    0.828654] NET: Registered protocol family 10
[    0.828966] lo: Disabled Privacy Extensions
[    0.829154] Mobile IPv6
[    0.829157] NET: Registered protocol family 17
[    0.829160] Registering the dns_resolver key type
[    0.829245] registered taskstats version 1
[    0.829601] rtc_cmos 00:03: setting system clock to 2010-11-14 10:06:46 UTC (1289729206)
[    0.829627] Initalizing network drop monitor service
[    0.829661] Freeing unused kernel memory: 424k freed
[    0.829745] Write protecting the kernel read-only data: 6144k
[    0.829844] Freeing unused kernel memory: 424k freed
[    0.829981] Freeing unused kernel memory: 560k freed
[    0.870619] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.920126] udev: starting version 161
[    0.920146] udevd (55): /proc/55/oom_adj is deprecated, please use /proc/55/oom_score_adj instead.
[    1.037975] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.038000] r8169 0000:0c:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.038601] r8169 0000:0c:00.0: eth0: RTL8168c/8111c at 0xffffc90010378000, 00:26:18:13:5c:63, XID 1c4000c0 IRQ 44
[    1.050637] thermal LNXTHERM:01: registered as thermal_zone0
[    1.050645] ACPI: Thermal Zone [THRM] (49 C)
[    1.056410] cfg80211: Calling CRDA to update world regulatory domain
[    1.069669] usbcore: registered new interface driver usbfs
[    1.069773] usbcore: registered new interface driver hub
[    1.069884] usbcore: registered new device driver usb
[    1.072211] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.072240] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.072323] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.072340] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    1.072369] ehci_hcd 0000:00:1a.7: debug port 1
[    1.076349] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfd8fbc00
[    1.088346] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.088368] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.088370] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.088372] usb usb1: Product: EHCI Host Controller
[    1.088374] usb usb1: Manufacturer: Linux 2.6.36 ehci_hcd
[    1.088376] usb usb1: SerialNumber: 0000:00:1a.7
[    1.088476] hub 1-0:1.0: USB hub found
[    1.088480] hub 1-0:1.0: 6 ports detected
[    1.088573] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.088646] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.088653] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    1.088680] ehci_hcd 0000:00:1d.7: debug port 1
[    1.092594] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfd8fb800
[    1.097817] SCSI subsystem initialized
[    1.115474] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.115507] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.115509] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.115512] usb usb2: Product: EHCI Host Controller
[    1.115513] usb usb2: Manufacturer: Linux 2.6.36 ehci_hcd
[    1.115515] usb usb2: SerialNumber: 0000:00:1d.7
[    1.115663] hub 2-0:1.0: USB hub found
[    1.115668] hub 2-0:1.0: 6 ports detected
[    1.119612] uhci_hcd: USB Universal Host Controller Interface driver
[    1.119680] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.119694] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.119706] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    1.119749] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00005880
[    1.119790] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.119793] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.119795] usb usb3: Product: UHCI Host Controller
[    1.119796] usb usb3: Manufacturer: Linux 2.6.36 uhci_hcd
[    1.119798] usb usb3: SerialNumber: 0000:00:1a.0
[    1.119906] hub 3-0:1.0: USB hub found
[    1.119910] hub 3-0:1.0: 2 ports detected
[    1.120007] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.120017] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.120023] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    1.120058] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00005800
[    1.120097] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.120099] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.120101] usb usb4: Product: UHCI Host Controller
[    1.120103] usb usb4: Manufacturer: Linux 2.6.36 uhci_hcd
[    1.120105] usb usb4: SerialNumber: 0000:00:1a.1
[    1.120182] hub 4-0:1.0: USB hub found
[    1.120186] hub 4-0:1.0: 2 ports detected
[    1.120246] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    1.120255] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    1.120262] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    1.120293] uhci_hcd 0000:00:1a.2: irq 19, io base 0x00005480
[    1.120325] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.120327] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.120329] usb usb5: Product: UHCI Host Controller
[    1.120331] usb usb5: Manufacturer: Linux 2.6.36 uhci_hcd
[    1.120332] usb usb5: SerialNumber: 0000:00:1a.2
[    1.120405] hub 5-0:1.0: USB hub found
[    1.120409] hub 5-0:1.0: 2 ports detected
[    1.120469] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.120477] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.120484] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    1.120507] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00005400
[    1.120539] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.120542] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.120543] usb usb6: Product: UHCI Host Controller
[    1.120545] usb usb6: Manufacturer: Linux 2.6.36 uhci_hcd
[    1.120547] usb usb6: SerialNumber: 0000:00:1d.0
[    1.120618] hub 6-0:1.0: USB hub found
[    1.120622] hub 6-0:1.0: 2 ports detected
[    1.120679] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.120688] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.120694] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    1.120721] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00005080
[    1.120751] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    1.120753] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.120755] usb usb7: Product: UHCI Host Controller
[    1.120757] usb usb7: Manufacturer: Linux 2.6.36 uhci_hcd
[    1.120758] usb usb7: SerialNumber: 0000:00:1d.1
[    1.120832] hub 7-0:1.0: USB hub found
[    1.120835] hub 7-0:1.0: 2 ports detected
[    1.120889] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.120899] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.120906] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    1.120929] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00005000
[    1.120960] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    1.120963] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.120965] usb usb8: Product: UHCI Host Controller
[    1.120966] usb usb8: Manufacturer: Linux 2.6.36 uhci_hcd
[    1.120968] usb usb8: SerialNumber: 0000:00:1d.2
[    1.121046] hub 8-0:1.0: USB hub found
[    1.121050] hub 8-0:1.0: 2 ports detected
[    1.121650] sdhci: Secure Digital Host Controller Interface driver
[    1.121652] sdhci: Copyright(c) Pierre Ossman
[    1.124824] sdhci-pci 0000:0d:00.1: SDHCI controller found [1180:0822] (rev 22)
[    1.124839] sdhci-pci 0000:0d:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.130007] sdhci-pci 0000:0d:00.1: Will use DMA mode even though HW doesn't fully claim to support it.
[    1.130027] mmc0: no vmmc regulator found
[    1.131427] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.132154] mmc0: SDHCI controller on PCI [0000:0d:00.1] using DMA
[    1.135578] ahci: SSS flag set, parallel bus scan disabled
[    1.135606] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x33 impl SATA mode
[    1.135609] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc ems sxs 
[    1.141103] scsi0 : ahci
[    1.141244] scsi1 : ahci
[    1.141295] scsi2 : ahci
[    1.141348] scsi3 : ahci
[    1.141401] scsi4 : ahci
[    1.141456] scsi5 : ahci
[    1.141752] ata1: SATA max UDMA/133 abar m2048@0xfd8fb000 port 0xfd8fb100 irq 45
[    1.141755] ata2: SATA max UDMA/133 abar m2048@0xfd8fb000 port 0xfd8fb180 irq 45
[    1.141757] ata3: DUMMY
[    1.141758] ata4: DUMMY
[    1.141761] ata5: SATA max UDMA/133 abar m2048@0xfd8fb000 port 0xfd8fb300 irq 45
[    1.141764] ata6: SATA max UDMA/133 abar m2048@0xfd8fb000 port 0xfd8fb380 irq 45
[    1.145348] ath5k 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.145478] ath5k 0000:02:00.0: registered as 'phy0'
[    1.446018] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.446976] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.447042] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.499214] ata1.00: ATA-8: WDC WD1600BEVS-08VAT2, 14.01A14, max UDMA/133
[    1.499217] ata1.00: 312581808 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    1.500591] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.500673] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.501922] ata1.00: configured for UDMA/133
[    1.512103] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600BEVS-0 14.0 PQ: 0 ANSI: 5
[    1.572013] usb 7-1: new low speed USB device using uhci_hcd and address 2
[    1.647522] ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
[    1.725750] usb 7-1: New USB device found, idVendor=046d, idProduct=c001
[    1.725753] usb 7-1: New USB device strings: Mfr=1, Product=0, SerialNumber=0
[    1.725755] usb 7-1: Manufacturer: Logitech
[    2.235021] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.239690] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.243363] ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-T50N, RE05, max UDMA/133
[    2.249249] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.252931] ata2.00: configured for UDMA/133
[    2.381093] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-T50N  RE05 PQ: 0 ANSI: 5
[    2.686013] ata5: SATA link down (SStatus 0 SControl 300)
[    3.002013] ata6: SATA link down (SStatus 0 SControl 300)
[    3.018560] usbcore: registered new interface driver hiddev
[    3.023550] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    3.023596] sd 0:0:0:0: [sda] Write Protect is off
[    3.023619] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.032968] input: Logitech as /devices/pci0000:00/0000:00:1d.1/usb7/7-1/7-1:1.0/input/input1
[    3.033035] generic-usb 0003:046D:C001.0001: input,hidraw0: USB HID v1.00 Mouse [Logitech] on usb-0000:00:1d.1-1/input0
[    3.033047] usbcore: registered new interface driver usbhid
[    3.033049] usbhid: USB HID core driver
[    3.080772]  sda: sda1 sda2 sda3 sda4
[    3.081007] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.350262] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    3.350265] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.354079] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.354108] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    3.776976] [drm] Initialized drm 1.1.0 20060810
[    3.793439] PM: Starting manual resume from disk
[    3.866474] EXT3-fs: barriers not enabled
[    3.884778] kjournald starting.  Commit interval 5 seconds
[    3.884799] EXT3-fs (sda3): mounted filesystem with ordered data mode
[    5.926149] udev[456]: starting version 164
[    6.358296] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    6.358310] ACPI: Sleep Button [SLPB]
[    6.358354] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input3
[    6.360731] ACPI: Lid Switch [LID]
[    6.360773] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[    6.360776] ACPI: Power Button [PWRF]
[    6.489214] ACPI: Battery Slot [BAT0] (battery present)
[    6.953966] ACPI: AC Adapter [AC0] (on-line)
[    7.071798] asus_laptop: Asus Laptop Support version 0.42
[    7.076119] asus_laptop: BSTS called, 0xbf47 returned
[    7.076133] asus_laptop:   BOXSTER model detected
[    7.076372] asus_laptop: Backlight controlled by ACPI video driver
[    7.076445] input: Asus Laptop extra buttons as /devices/platform/asus_laptop/input/input5
[    7.082708] input: PC Speaker as /devices/platform/pcspkr/input/input6
[    7.117019] Marking TSC unstable due to TSC halts in idle
[    7.117603] Switching to clocksource hpet
[    7.384121] Synaptics Touchpad, model: 1, fw: 7.0, id: 0x1c0b1, caps: 0xd04791/0xb00000/0x20000
[    7.384128] serio: Synaptics pass-through port at isa0060/serio4/input0
[    7.425391] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input7
[    7.816578] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.866530] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[    7.866533] [drm] MTRR allocation failed.  Graphics performance may suffer.
[    7.866611] [drm] set up 31M of stolen space
[    7.986634] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    8.489742] fbcon: inteldrmfb (fb0) is primary device
[    8.654211] Console: switching to colour frame buffer device 106x30
[    8.655211] fb0: inteldrmfb frame buffer device
[    8.655212] drm: registered panic notifier
[    8.679974] ACPI Warning: _BQC returned an invalid level (20100702/video-634)
[    8.680509] acpi device:1c: registered as cooling_device2
[    8.680600] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input8
[    8.680817] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[    8.680993] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    8.716554] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    8.820915] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input9
[    8.863561] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    8.863617] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    8.863669] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[    8.863718] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[   10.843226] Adding 3903788k swap on /dev/sda2.  Priority:-1 extents:1 across:3903788k 
[   11.138366] EXT3-fs (sda3): using internal journal
[   11.325278] loop: module loaded
[   11.421270] Linux video capture interface: v2.00
[   11.455604] usbcore: registered new interface driver uvcvideo
[   11.455606] USB Video Class driver (v0.1.0)
[   12.191344] EXT3-fs: barriers not enabled
[   12.191580] kjournald starting.  Commit interval 5 seconds
[   12.191844] EXT3-fs (sda4): using internal journal
[   12.191848] EXT3-fs (sda4): mounted filesystem with ordered data mode
[   13.026546] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   13.263279] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio4/serio5/input/input14
[   14.693599] fuse init (API version 7.15)
[   15.505216] FS-Cache: Loaded
[   15.797827] CacheFiles: Loaded
[   16.315811] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input15
[   18.276659] FS-Cache: Cache "mycache" added (type cachefiles)
[   18.276662] CacheFiles: File cache on sda3 registered
[   43.851770] VBoxDrv: dbg - g_abExecMemory=ffffffffa0559480
[   43.851784] vboxdrv: fAsync=0 offMin=0x1a2 offMax=0x13a1
[   43.852243] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
[   48.351096] CPUFREQ: Per core ondemand sysfs interface is deprecated - ignore_nice_load
[   48.890417] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   50.139411] WARNING! power/level is deprecated; use power/control instead
[   54.353825] r8169 0000:0c:00.0: eth0: link up
[   54.353846] r8169 0000:0c:00.0: eth0: link up
[   56.897289] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   57.041110] r8169 0000:0c:00.0: eth0: link up
[   57.103826] r8169 0000:0c:00.0: eth0: link up
[  103.337557] RPC: Registered udp transport module.
[  103.337560] RPC: Registered tcp transport module.
[  103.337561] RPC: Registered tcp NFSv4.1 backchannel transport module.
[  104.651510] FS-Cache: Netfs 'nfs' registered for caching
ratelimit.c: 249 events suppressed
[  185.852993] lo: Disabled Privacy Extensions
[  878.511140] perl uses obsolete (PF_INET,SOCK_PACKET)
[  882.782298] device eth0 entered promiscuous mode
[  900.199578] device eth0 left promiscuous mode
[  930.380339] lo: Disabled Privacy Extensions
[ 1320.796144] umount.nfs    D ffff880037a5f230     0  3639   3638 0x00000000
[ 1320.796150]  ffff880037a5ef90 0000000000000082 ffff88009b803aa0 0000000000000000
[ 1320.796157]  ffff880037a58000 0000000000012ac0 ffff880037a5f238 ffff8800a4181fd8
[ 1320.796162]  ffff8800a4181fd8 ffff880037a5f230 ffff8800a4180010 ffff880037a5ef90
[ 1320.796167] Call Trace:
[ 1320.796178]  [<ffffffff81037cc9>] ? get_parent_ip+0x9/0x20
[ 1320.796194]  [<ffffffffa03a08d5>] ? __fscache_wait_on_page_write+0x65/0xa0 [fscache]
[ 1320.796199]  [<ffffffff810679f0>] ? autoremove_wake_function+0x0/0x30
[ 1320.796220]  [<ffffffffa078d82d>] ? __nfs_fscache_invalidate_page+0x2d/0x90 [nfs]
[ 1320.796225]  [<ffffffff810dc54a>] ? truncate_inode_page+0x9a/0xb0
[ 1320.796230]  [<ffffffff810dc7e0>] ? truncate_inode_pages_range+0x130/0x3d0
[ 1320.796234]  [<ffffffff810e950b>] ? __mod_zone_page_state+0x2b/0xa0
[ 1320.796246]  [<ffffffffa0763792>] ? nfs4_evict_inode+0x12/0x30 [nfs]
[ 1320.796251]  [<ffffffff8112eb2a>] ? evict+0x1a/0xa0
[ 1320.796254]  [<ffffffff8112ec07>] ? dispose_list+0x57/0x110
[ 1320.796258]  [<ffffffff8112eddb>] ? invalidate_inodes+0x11b/0x160
[ 1320.796264]  [<ffffffff8111a101>] ? generic_shutdown_super+0x41/0xe0
[ 1320.796268]  [<ffffffff8111a1f9>] ? kill_anon_super+0x9/0x50
[ 1320.796279]  [<ffffffffa0767841>] ? nfs4_kill_super+0x31/0xa0 [nfs]
[ 1320.796284]  [<ffffffff8111a8b3>] ? deactivate_locked_super+0x43/0x70
[ 1320.796288]  [<ffffffff811336d8>] ? sys_umount+0x88/0x3c0
[ 1320.796294]  [<ffffffff81002feb>] ? system_call_fastpath+0x16/0x1b
[ 1440.796063] umount.nfs    D ffff880037a5f230     0  3639   3638 0x00000000
[ 1440.796067]  ffff880037a5ef90 0000000000000082 ffff88009b803aa0 0000000000000000
[ 1440.796071]  ffff880037a58000 0000000000012ac0 ffff880037a5f238 ffff8800a4181fd8
[ 1440.796074]  ffff8800a4181fd8 ffff880037a5f230 ffff8800a4180010 ffff880037a5ef90
[ 1440.796078] Call Trace:
[ 1440.796087]  [<ffffffff81037cc9>] ? get_parent_ip+0x9/0x20
[ 1440.796098]  [<ffffffffa03a08d5>] ? __fscache_wait_on_page_write+0x65/0xa0 [fscache]
[ 1440.796102]  [<ffffffff810679f0>] ? autoremove_wake_function+0x0/0x30
[ 1440.796118]  [<ffffffffa078d82d>] ? __nfs_fscache_invalidate_page+0x2d/0x90 [nfs]
[ 1440.796122]  [<ffffffff810dc54a>] ? truncate_inode_page+0x9a/0xb0
[ 1440.796125]  [<ffffffff810dc7e0>] ? truncate_inode_pages_range+0x130/0x3d0
[ 1440.796128]  [<ffffffff810e950b>] ? __mod_zone_page_state+0x2b/0xa0
[ 1440.796136]  [<ffffffffa0763792>] ? nfs4_evict_inode+0x12/0x30 [nfs]
[ 1440.796139]  [<ffffffff8112eb2a>] ? evict+0x1a/0xa0
[ 1440.796141]  [<ffffffff8112ec07>] ? dispose_list+0x57/0x110
[ 1440.796144]  [<ffffffff8112eddb>] ? invalidate_inodes+0x11b/0x160
[ 1440.796148]  [<ffffffff8111a101>] ? generic_shutdown_super+0x41/0xe0
[ 1440.796150]  [<ffffffff8111a1f9>] ? kill_anon_super+0x9/0x50
[ 1440.796157]  [<ffffffffa0767841>] ? nfs4_kill_super+0x31/0xa0 [nfs]
[ 1440.796160]  [<ffffffff8111a8b3>] ? deactivate_locked_super+0x43/0x70
[ 1440.796164]  [<ffffffff811336d8>] ? sys_umount+0x88/0x3c0
[ 1440.796168]  [<ffffffff81002feb>] ? system_call_fastpath+0x16/0x1b
[ 1560.796133] umount.nfs    D ffff880037a5f230     0  3639   3638 0x00000000
[ 1560.796145]  ffff880037a5ef90 0000000000000082 ffff88009b803aa0 0000000000000000
[ 1560.796156]  ffff880037a58000 0000000000012ac0 ffff880037a5f238 ffff8800a4181fd8
[ 1560.796166]  ffff8800a4181fd8 ffff880037a5f230 ffff8800a4180010 ffff880037a5ef90
[ 1560.796176] Call Trace:
[ 1560.796195]  [<ffffffff81037cc9>] ? get_parent_ip+0x9/0x20
[ 1560.796219]  [<ffffffffa03a08d5>] ? __fscache_wait_on_page_write+0x65/0xa0 [fscache]
[ 1560.796230]  [<ffffffff810679f0>] ? autoremove_wake_function+0x0/0x30
[ 1560.796264]  [<ffffffffa078d82d>] ? __nfs_fscache_invalidate_page+0x2d/0x90 [nfs]
[ 1560.796275]  [<ffffffff810dc54a>] ? truncate_inode_page+0x9a/0xb0
[ 1560.796283]  [<ffffffff810dc7e0>] ? truncate_inode_pages_range+0x130/0x3d0
[ 1560.796292]  [<ffffffff810e950b>] ? __mod_zone_page_state+0x2b/0xa0
[ 1560.796315]  [<ffffffffa0763792>] ? nfs4_evict_inode+0x12/0x30 [nfs]
[ 1560.796324]  [<ffffffff8112eb2a>] ? evict+0x1a/0xa0
[ 1560.796331]  [<ffffffff8112ec07>] ? dispose_list+0x57/0x110
[ 1560.796338]  [<ffffffff8112eddb>] ? invalidate_inodes+0x11b/0x160
[ 1560.796349]  [<ffffffff8111a101>] ? generic_shutdown_super+0x41/0xe0
[ 1560.796357]  [<ffffffff8111a1f9>] ? kill_anon_super+0x9/0x50
[ 1560.796379]  [<ffffffffa0767841>] ? nfs4_kill_super+0x31/0xa0 [nfs]
[ 1560.796389]  [<ffffffff8111a8b3>] ? deactivate_locked_super+0x43/0x70
[ 1560.796398]  [<ffffffff811336d8>] ? sys_umount+0x88/0x3c0
[ 1560.796408]  [<ffffffff81002feb>] ? system_call_fastpath+0x16/0x1b
shutting down for system reboot
[ 1680.796153] kswapd0       D ffff88013fce3db0     0    28      2 0x00000000
[ 1680.796165]  ffff88013fce3b10 0000000000000046 0000000000000000 0000000000000000
[ 1680.796176]  ffff88013fc6c830 0000000000012ac0 ffff88013fce3db8 ffff880139417fd8
[ 1680.796186]  ffff880139417fd8 ffff88013fce3db0 ffff880139416010 ffff88013fce3b10
[ 1680.796196] Call Trace:
[ 1680.796214]  [<ffffffff81387fdd>] ? rwsem_down_failed_common+0xbd/0x160
[ 1680.796225]  [<ffffffff811cc914>] ? call_rwsem_down_read_failed+0x14/0x30
[ 1680.796233]  [<ffffffff8138762e>] ? down_read+0xe/0x10
[ 1680.796242]  [<ffffffff8112f174>] ? shrink_icache_memory+0x94/0x2e0
[ 1680.796254]  [<ffffffff810df7a4>] ? shrink_slab+0x114/0x170
[ 1680.796262]  [<ffffffff810e0d38>] ? balance_pgdat+0x2e8/0x540
[ 1680.796271]  [<ffffffff810e10bf>] ? kswapd+0x12f/0x3b0
[ 1680.796281]  [<ffffffff810679f0>] ? autoremove_wake_function+0x0/0x30
[ 1680.796289]  [<ffffffff810e0f90>] ? kswapd+0x0/0x3b0
[ 1680.796296]  [<ffffffff810e0f90>] ? kswapd+0x0/0x3b0
[ 1680.796303]  [<ffffffff81067476>] ? kthread+0x96/0xa0
[ 1680.796313]  [<ffffffff81003d94>] ? kernel_thread_helper+0x4/0x10
[ 1680.796321]  [<ffffffff810673e0>] ? kthread+0x0/0xa0
[ 1680.796328]  [<ffffffff81003d90>] ? kernel_thread_helper+0x0/0x10
[ 1680.796353] Xorg          D ffff880138c2d160     0  1495   1478 0x00400004
[ 1680.796363]  ffff880138c2cec0 0000000000000086 0000000000000000 0000000000000000
[ 1680.796373]  ffffffff8160d020 0000000000012ac0 ffff880138c2d168 ffff8801399c1fd8
[ 1680.796383]  ffff8801399c1fd8 ffff880138c2d160 ffff8801399c0010 ffff880138c2cec0
[ 1680.796393] Call Trace:
[ 1680.796401]  [<ffffffff81387fdd>] ? rwsem_down_failed_common+0xbd/0x160
[ 1680.796411]  [<ffffffff811cc914>] ? call_rwsem_down_read_failed+0x14/0x30
[ 1680.796418]  [<ffffffff8138762e>] ? down_read+0xe/0x10
[ 1680.796425]  [<ffffffff8112f174>] ? shrink_icache_memory+0x94/0x2e0
[ 1680.796434]  [<ffffffff810df7a4>] ? shrink_slab+0x114/0x170
[ 1680.796443]  [<ffffffff810e1534>] ? do_try_to_free_pages+0x1f4/0x440
[ 1680.796452]  [<ffffffff810e18c5>] ? try_to_free_pages+0xa5/0x180
[ 1680.796460]  [<ffffffff810e211e>] ? kunmap_atomic_notypecheck+0xe/0x30
[ 1680.796471]  [<ffffffff810d8862>] ? __alloc_pages_nodemask+0x412/0x870
[ 1680.796482]  [<ffffffff810e5ae0>] ? shmem_readpage+0x0/0x40
[ 1680.796490]  [<ffffffff810d222e>] ? do_read_cache_page+0x4e/0x180
[ 1680.796500]  [<ffffffff810fb5e5>] ? map_vm_area+0x25/0x40
[ 1680.796509]  [<ffffffff810d2376>] ? read_cache_page_gfp+0x16/0x30
[ 1680.796551]  [<ffffffffa04adf31>] ? i915_gem_object_get_pages+0xe1/0x220 [i915]
[ 1680.796577]  [<ffffffffa04ae73d>] ? i915_gem_object_bind_to_gtt+0x10d/0x3b0 [i915]
[ 1680.796605]  [<ffffffffa04b001a>] ? i915_gem_object_pin+0x18a/0x1c0 [i915]
[ 1680.796631]  [<ffffffffa04b290b>] ? i915_gem_do_execbuffer+0x64b/0x12c0 [i915]
[ 1680.796643]  [<ffffffff810fb5e5>] ? map_vm_area+0x25/0x40
[ 1680.796652]  [<ffffffff810fd5b5>] ? __vmalloc_area_node+0xd5/0x140
[ 1680.796678]  [<ffffffffa04b3bef>] ? i915_gem_execbuffer2+0xaf/0x1f0 [i915]
[ 1680.796713]  [<ffffffffa01de2d1>] ? drm_ioctl+0x401/0x490 [drm]
[ 1680.796739]  [<ffffffffa04b3b40>] ? i915_gem_execbuffer2+0x0/0x1f0 [i915]
[ 1680.796751]  [<ffffffff81127edf>] ? do_vfs_ioctl+0x9f/0x550
[ 1680.796760]  [<ffffffff811283d9>] ? sys_ioctl+0x49/0x80
[ 1680.796768]  [<ffffffff8111850e>] ? sys_read+0x4e/0x90
[ 1680.796778]  [<ffffffff81002feb>] ? system_call_fastpath+0x16/0x1b
[ 1680.796818] kworker/u:0   D ffff88010ebb78c0     0  3575      2 0x00000000
[ 1680.796828]  ffff88010ebb7620 0000000000000046 0000000000000000 ffff880000000000
[ 1680.796838]  ffff88013fc6c830 0000000000012ac0 ffff88010ebb78c8 ffff8800a4059fd8
[ 1680.796848]  ffff8800a4059fd8 ffff88010ebb78c0 ffff8800a4058010 ffff88010ebb7620
[ 1680.796857] Call Trace:
[ 1680.796867]  [<ffffffff8103ed62>] ? cpuacct_charge+0x62/0x90
[ 1680.796877]  [<ffffffff81386fba>] ? __mutex_lock_slowpath+0x11a/0x1d0
[ 1680.796907]  [<ffffffffa04bd870>] ? intel_idle_update+0x0/0x2d0 [i915]
[ 1680.796917]  [<ffffffff81386b4a>] ? mutex_lock+0x1a/0x40
[ 1680.796944]  [<ffffffffa04bd8ee>] ? intel_idle_update+0x7e/0x2d0 [i915]
[ 1680.796973]  [<ffffffffa04bd870>] ? intel_idle_update+0x0/0x2d0 [i915]
[ 1680.796983]  [<ffffffff81060c8b>] ? process_one_work+0x11b/0x490
[ 1680.796992]  [<ffffffff810631c2>] ? worker_thread+0x172/0x400
[ 1680.797001]  [<ffffffff81063050>] ? worker_thread+0x0/0x400
[ 1680.797028]  [<ffffffff81063050>] ? worker_thread+0x0/0x400
[ 1680.797035]  [<ffffffff81067476>] ? kthread+0x96/0xa0
[ 1680.797043]  [<ffffffff81003d94>] ? kernel_thread_helper+0x4/0x10
[ 1680.797056]  [<ffffffff810673e0>] ? kthread+0x0/0xa0
[ 1680.797067]  [<ffffffff81003d90>] ? kernel_thread_helper+0x0/0x10
[ 1680.797093] umount.nfs    D ffff880037a5f230     0  3639   3638 0x00000000
[ 1680.797107]  ffff880037a5ef90 0000000000000082 ffff88009b803aa0 0000000000000000
[ 1680.797124]  ffff880037a58000 0000000000012ac0 ffff880037a5f238 ffff8800a4181fd8
[ 1680.797140]  ffff8800a4181fd8 ffff880037a5f230 ffff8800a4180010 ffff880037a5ef90
[ 1680.797157] Call Trace:
[ 1680.797173]  [<ffffffff81037cc9>] ? get_parent_ip+0x9/0x20
[ 1680.797195]  [<ffffffffa03a08d5>] ? __fscache_wait_on_page_write+0x65/0xa0 [fscache]
[ 1680.797207]  [<ffffffff810679f0>] ? autoremove_wake_function+0x0/0x30
[ 1680.797245]  [<ffffffffa078d82d>] ? __nfs_fscache_invalidate_page+0x2d/0x90 [nfs]
[ 1680.797257]  [<ffffffff810dc54a>] ? truncate_inode_page+0x9a/0xb0
[ 1680.797269]  [<ffffffff810dc7e0>] ? truncate_inode_pages_range+0x130/0x3d0
[ 1680.797281]  [<ffffffff810e950b>] ? __mod_zone_page_state+0x2b/0xa0
[ 1680.797312]  [<ffffffffa0763792>] ? nfs4_evict_inode+0x12/0x30 [nfs]
[ 1680.797322]  [<ffffffff8112eb2a>] ? evict+0x1a/0xa0
[ 1680.797332]  [<ffffffff8112ec07>] ? dispose_list+0x57/0x110
[ 1680.797343]  [<ffffffff8112eddb>] ? invalidate_inodes+0x11b/0x160
[ 1680.797358]  [<ffffffff8111a101>] ? generic_shutdown_super+0x41/0xe0
[ 1680.797369]  [<ffffffff8111a1f9>] ? kill_anon_super+0x9/0x50
[ 1680.797394]  [<ffffffffa0767841>] ? nfs4_kill_super+0x31/0xa0 [nfs]
[ 1680.797406]  [<ffffffff8111a8b3>] ? deactivate_locked_super+0x43/0x70
[ 1680.797418]  [<ffffffff811336d8>] ? sys_umount+0x88/0x3c0
[ 1680.797433]  [<ffffffff81002feb>] ? system_call_fastpath+0x16/0x1b
shutting down for system halt
[ 1800.797129] kswapd0       D ffff88013fce3db0     0    28      2 0x00000000
[ 1800.797141]  ffff88013fce3b10 0000000000000046 0000000000000000 0000000000000000
[ 1800.797152]  ffff88013fc6c830 0000000000012ac0 ffff88013fce3db8 ffff880139417fd8
[ 1800.797162]  ffff880139417fd8 ffff88013fce3db0 ffff880139416010 ffff88013fce3b10
[ 1800.797172] Call Trace:
[ 1800.797190]  [<ffffffff81387fdd>] ? rwsem_down_failed_common+0xbd/0x160
[ 1800.797201]  [<ffffffff811cc914>] ? call_rwsem_down_read_failed+0x14/0x30
[ 1800.797209]  [<ffffffff8138762e>] ? down_read+0xe/0x10
[ 1800.797218]  [<ffffffff8112f174>] ? shrink_icache_memory+0x94/0x2e0
[ 1800.797229]  [<ffffffff810df7a4>] ? shrink_slab+0x114/0x170
[ 1800.797238]  [<ffffffff810e0d38>] ? balance_pgdat+0x2e8/0x540
[ 1800.797247]  [<ffffffff810e10bf>] ? kswapd+0x12f/0x3b0
[ 1800.797257]  [<ffffffff810679f0>] ? autoremove_wake_function+0x0/0x30
[ 1800.797265]  [<ffffffff810e0f90>] ? kswapd+0x0/0x3b0
[ 1800.797272]  [<ffffffff810e0f90>] ? kswapd+0x0/0x3b0
[ 1800.797279]  [<ffffffff81067476>] ? kthread+0x96/0xa0
[ 1800.797289]  [<ffffffff81003d94>] ? kernel_thread_helper+0x4/0x10
[ 1800.797297]  [<ffffffff810673e0>] ? kthread+0x0/0xa0
[ 1800.797304]  [<ffffffff81003d90>] ? kernel_thread_helper+0x0/0x10
[ 1800.797328] Xorg          D ffff880138c2d160     0  1495   1478 0x00400004
[ 1800.797338]  ffff880138c2cec0 0000000000000086 0000000000000000 0000000000000000
[ 1800.797348]  ffffffff8160d020 0000000000012ac0 ffff880138c2d168 ffff8801399c1fd8
[ 1800.797358]  ffff8801399c1fd8 ffff880138c2d160 ffff8801399c0010 ffff880138c2cec0
[ 1800.797368] Call Trace:
[ 1800.797376]  [<ffffffff81387fdd>] ? rwsem_down_failed_common+0xbd/0x160
[ 1800.797386]  [<ffffffff811cc914>] ? call_rwsem_down_read_failed+0x14/0x30
[ 1800.797393]  [<ffffffff8138762e>] ? down_read+0xe/0x10
[ 1800.797401]  [<ffffffff8112f174>] ? shrink_icache_memory+0x94/0x2e0
[ 1800.797410]  [<ffffffff810df7a4>] ? shrink_slab+0x114/0x170
[ 1800.797418]  [<ffffffff810e1534>] ? do_try_to_free_pages+0x1f4/0x440
[ 1800.797427]  [<ffffffff810e18c5>] ? try_to_free_pages+0xa5/0x180
[ 1800.797436]  [<ffffffff810e211e>] ? kunmap_atomic_notypecheck+0xe/0x30
[ 1800.797447]  [<ffffffff810d8862>] ? __alloc_pages_nodemask+0x412/0x870
[ 1800.797457]  [<ffffffff810e5ae0>] ? shmem_readpage+0x0/0x40
[ 1800.797466]  [<ffffffff810d222e>] ? do_read_cache_page+0x4e/0x180
[ 1800.797476]  [<ffffffff810fb5e5>] ? map_vm_area+0x25/0x40
[ 1800.797484]  [<ffffffff810d2376>] ? read_cache_page_gfp+0x16/0x30
[ 1800.797526]  [<ffffffffa04adf31>] ? i915_gem_object_get_pages+0xe1/0x220 [i915]
[ 1800.797552]  [<ffffffffa04ae73d>] ? i915_gem_object_bind_to_gtt+0x10d/0x3b0 [i915]
[ 1800.797580]  [<ffffffffa04b001a>] ? i915_gem_object_pin+0x18a/0x1c0 [i915]
[ 1800.797606]  [<ffffffffa04b290b>] ? i915_gem_do_execbuffer+0x64b/0x12c0 [i915]
[ 1800.797618]  [<ffffffff810fb5e5>] ? map_vm_area+0x25/0x40
[ 1800.797627]  [<ffffffff810fd5b5>] ? __vmalloc_area_node+0xd5/0x140
[ 1800.797654]  [<ffffffffa04b3bef>] ? i915_gem_execbuffer2+0xaf/0x1f0 [i915]
[ 1800.797690]  [<ffffffffa01de2d1>] ? drm_ioctl+0x401/0x490 [drm]
[ 1800.797716]  [<ffffffffa04b3b40>] ? i915_gem_execbuffer2+0x0/0x1f0 [i915]
[ 1800.797727]  [<ffffffff81127edf>] ? do_vfs_ioctl+0x9f/0x550
[ 1800.797736]  [<ffffffff811283d9>] ? sys_ioctl+0x49/0x80
[ 1800.797745]  [<ffffffff8111850e>] ? sys_read+0x4e/0x90
[ 1800.797754]  [<ffffffff81002feb>] ? system_call_fastpath+0x16/0x1b
[ 1800.797778] kwin          D ffff880136185e80     0  3065   3062 0x00000004
[ 1800.797787]  ffff880136185be0 0000000000000046 0000000000000000 0000000000000000
[ 1800.797797]  ffff88013fc6c830 0000000000012ac0 ffff880136185e88 ffff880137a6ffd8
[ 1800.797808]  ffff880137a6ffd8 ffff880136185e80 ffff880137a6e010 ffff880136185be0
[ 1800.797817] Call Trace:
[ 1800.797825]  [<ffffffff810dbd28>] ? release_pages+0x1c8/0x220
[ 1800.797836]  [<ffffffff81386fba>] ? __mutex_lock_slowpath+0x11a/0x1d0
[ 1800.797847]  [<ffffffff81037cc9>] ? get_parent_ip+0x9/0x20
[ 1800.797855]  [<ffffffff81386b4a>] ? mutex_lock+0x1a/0x40
[ 1800.797881]  [<ffffffffa01df7d5>] ? drm_gem_vm_close+0x25/0x60 [drm]
[ 1800.797890]  [<ffffffff810f3ab4>] ? remove_vma+0x24/0x70
[ 1800.797898]  [<ffffffff810f5298>] ? exit_mmap+0x148/0x1c0
[ 1800.797907]  [<ffffffff81044117>] ? mmput+0x37/0x100
[ 1800.797915]  [<ffffffff81048d7b>] ? exit_mm+0xfb/0x130
[ 1800.797923]  [<ffffffff8138bcc7>] ? sub_preempt_count+0x87/0xb0
[ 1800.797931]  [<ffffffff81049aec>] ? do_exit+0x14c/0x810
[ 1800.797939]  [<ffffffff81037cc9>] ? get_parent_ip+0x9/0x20
[ 1800.797947]  [<ffffffff8138bcc7>] ? sub_preempt_count+0x87/0xb0
[ 1800.797955]  [<ffffffff81134cc1>] ? mnt_drop_write+0x31/0x50
[ 1800.797962]  [<ffffffff8104a200>] ? do_group_exit+0x50/0xc0
[ 1800.797971]  [<ffffffff8105bc63>] ? get_signal_to_deliver+0x2b3/0x4c0
[ 1800.797981]  [<ffffffff8100238a>] ? do_signal+0x8a/0x800
[ 1800.797989]  [<ffffffff810f012b>] ? handle_mm_fault+0x5eb/0xcb0
[ 1800.797998]  [<ffffffff81002b65>] ? do_notify_resume+0x65/0x90
[ 1800.798026]  [<ffffffff811184b2>] ? sys_write+0x82/0x90
[ 1800.798034]  [<ffffffff81003288>] ? int_signal+0x12/0x17

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
