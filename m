Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098Ab2APWqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 17:46:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36978 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547Ab2APWqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 17:46:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: Re: [Regression] Commit "tpm: Introduce function to poll for result of self test" breaks suspend
Date: Mon, 16 Jan 2012 23:50:01 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
References: <201201160022.07176.rjw@sisk.pl> <201201162305.15662.rjw@sisk.pl> <4F14A7F8.8000004@linux.vnet.ibm.com>
In-Reply-To: <4F14A7F8.8000004@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_amKFPSCt6Pob2iN"
Message-Id: <201201162350.02165.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_amKFPSCt6Pob2iN
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

On Monday, January 16, 2012, Stefan Berger wrote:
> On 01/16/2012 05:05 PM, Rafael J. Wysocki wrote:
> > On Monday, January 16, 2012, Stefan Berger wrote:
> >> On 01/16/2012 03:42 PM, Rafael J. Wysocki wrote:
> > Well, so the problem with that is that it requires Windows to be installed
> > to change the settings (i.e. the machine has no BIOS setup as we know it).
> > So, practically, I really can't do that.
> >
> Are there any other tpm related outputs in 'dmesg' from during the boot?

Yes, there are.  Below is the result of grepping tpm in dmesg output (the
entire dmesg log from that box is attached).

[    5.066807] tpm_tis 00:0a: 1.2 TPM (device-id 0xB, rev-id 16)
[    7.167236] tpm_tis 00:0a: Adjusting TPM timeout parameters.
[    7.893190] tpm_tis 00:0a: A TPM error (7) occurred attempting to read a pcr value
[    7.897202] tpm_tis 00:0a: TPM self test failed
[    7.907599] tpm_inf_pnp 00:0a: Found TPM with ID IFX0102
[    7.909745] tpm_inf_pnp 00:0a: TPM found: config base 0x4e, data base 0x680, chip version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635 TT 1.2)
[   96.386200] tpm_inf_pnp 00:0a: saving TPM state
[   96.407630] tpm_inf_pnp 00:0a: Timeout while clearing FIFO
[   96.407634] tpm_inf_pnp 00:0a: error while saving TPM state

Thanks,
Rafael

--Boundary-00=_amKFPSCt6Pob2iN
Content-Type: text/x-log;
  charset="UTF-8";
  name="tosh.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="tosh.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.2.0+ (rafael@chimera) (gcc version 4.5.0 20100604 [gcc-4_5-branch revision 160292] (SUSE Linux) ) #584 SMP PREEMPT Mon Jan 16 20:39:20 CET 2012
[    0.000000] Command line: root=/dev/disk/by-id/ata-INTEL_SSDSA2M080G2GN_CVPO9456006H080BGN-part5 edd=off resume=/dev/disk/by-id/ata-INTEL_SSDSA2M080G2GN_CVPO9456006H080BGN-part2
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 00000000000eee00 (reserved)
[    0.000000]  BIOS-e820: 00000000000eee00 - 00000000000ef000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000000ef000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f750000 (usable)
[    0.000000]  BIOS-e820: 000000007f750000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec18000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec20000 - 00000000fec28000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000fedc0000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffa00000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffd00000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: TOSHIBA PORTEGE R500/Portable PC, BIOS Version 1.60 03/04/2008
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x7f750 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-E7FFF write-protect
[    0.000000]   E8000-EFFFF write-back
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FEDA0000 mask FFFFE0000 write-back
[    0.000000]   1 base 07F800000 mask FFF800000 uncachable
[    0.000000]   2 base 0FFE00000 mask FFFE00000 write-protect
[    0.000000]   3 base 000000000 mask F80000000 write-back
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-000000007f750000
[    0.000000]  0000000000 - 007f600000 page 2M
[    0.000000]  007f600000 - 007f750000 page 4k
[    0.000000] kernel direct mapping tables up to 7f750000 @ 1fffc000-20000000
[    0.000000] RAMDISK: 37458000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f0210 00014 (v00 TOSHIB)
[    0.000000] ACPI: RSDT 000000007f750000 0004C (v01 TOSHIB A0058    20070822 TASM 04010000)
[    0.000000] ACPI: FACP 000000007f750078 00084 (v02 TOSHIB A0058    20070822 TASM 04010000)
[    0.000000] ACPI: DSDT 000000007f7500fc 05CA1 (v02 TOSHIB A0058    20070822 MSFT 0100000E)
[    0.000000] ACPI: FACS 00000000000eee00 00040
[    0.000000] ACPI: SSDT 000000007f755d9d 00306 (v02 TOSHIB A0058    20060907 MSFT 0100000E)
[    0.000000] ACPI: BOOT 000000007f750050 00028 (v01 TOSHIB A0058    20070822 TASM 04010000)
[    0.000000] ACPI: APIC 000000007f756955 00068 (v01 TOSHIB A0058    20070822 TASM 04010000)
[    0.000000] ACPI: MCFG 000000007f7569bd 0003C (v01 TOSHIB A0058    20070822 TASM 04010000)
[    0.000000] ACPI: HPET 000000007f756a2d 00038 (v01 TOSHIB A0058    20070822 TASM 04010000)
[    0.000000] ACPI: TCPA 000000007f756a65 00032 (v02 TOSHIB A0058    20070822 TASM 04010000)
[    0.000000] ACPI: SLIC 000000007f756a97 00176 (v01 TOSHIB A0058    20070822 TASM 04010000)
[    0.000000] ACPI: SSDT 000000007f756c0d 0016C (v02 TOSHIB A0058    20070309 MSFT 0100000E)
[    0.000000] ACPI: SSDT 000000007f7576bf 00081 (v02 TOSHIB A0058    20060907 MSFT 0100000E)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff88007ce00000-ffff88007e9fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007f750
[    0.000000] On node 0 totalpages: 521951
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3922 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7082 pages used for memmap
[    0.000000]   DMA32 zone: 510886 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xd808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
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
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 00000000000ee000
[    0.000000] PM: Registered nosave memory: 00000000000ee000 - 00000000000ef000
[    0.000000] PM: Registered nosave memory: 00000000000ef000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:7ec00000)
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88007f400000 s80192 r8192 d22208 u1048576
[    0.000000] pcpu-alloc: s80192 r8192 d22208 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 514808
[    0.000000] Kernel command line: root=/dev/disk/by-id/ata-INTEL_SSDSA2M080G2GN_CVPO9456006H080BGN-part5 edd=off resume=/dev/disk/by-id/ata-INTEL_SSDSA2M080G2GN_CVPO9456006H080BGN-part2
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 2020904k/2088256k available (6312k kernel code, 452k absent, 66900k reserved, 6628k data, 620k init)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU lockdep checking is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] kmemleak: Kernel memory leak detector disabled
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] allocated 8388608 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] kmemleak: Early log buffer exceeded (577), please increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1329.846 MHz processor.
[    0.001006] Calibrating delay loop (skipped), value calculated using timer frequency.. 2659.69 BogoMIPS (lpj=1329846)
[    0.001233] pid_max: default: 32768 minimum: 301
[    0.002216] Security Framework initialized
[    0.002383] AppArmor: AppArmor initialized
[    0.002555] Mount-cache hash table entries: 256
[    0.004690] Initializing cgroup subsys cpuacct
[    0.004802] Initializing cgroup subsys memory
[    0.005019] Initializing cgroup subsys devices
[    0.005134] Initializing cgroup subsys freezer
[    0.005244] Initializing cgroup subsys blkio
[    0.005372] Initializing cgroup subsys perf_event
[    0.005615] CPU: Physical Processor ID: 0
[    0.005723] CPU: Processor Core ID: 0
[    0.005830] mce: CPU supports 6 MCE banks
[    0.005946] CPU0: Thermal monitoring handled by SMI
[    0.005955] using mwait in idle threads.
[    0.006214] ACPI: Core revision 20110623
[    0.020765] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.030894] CPU0: Intel(R) Core(TM)2 Duo CPU     U7700  @ 1.33GHz stepping 0d
[    0.031997] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.031997] PEBS disabled due to CPU errata.
[    0.031997] ... version:                2
[    0.031997] ... bit width:              40
[    0.031997] ... generic registers:      2
[    0.031997] ... value mask:             000000ffffffffff
[    0.031997] ... max period:             000000007fffffff
[    0.031997] ... fixed-purpose events:   3
[    0.032003] ... event mask:             0000000700000003
[    0.040661] NMI watchdog enabled, takes one hw-pmu counter.
[    0.046064] lockdep: fixing up alternatives.
[    0.048311] Booting Node   0, Processors  #1 Ok.
[    0.048472] smpboot cpu 1: start_ip = 9a000
[    0.001999] CPU1: Thermal monitoring handled by SMI
[    0.060286] NMI watchdog enabled, takes one hw-pmu counter.
[    0.063010] Brought up 2 CPUs
[    0.063117] Total of 2 processors activated (5319.38 BogoMIPS).
[    0.066610] devtmpfs: initialized
[    0.067099] PM: Registering ACPI NVS region at eee00 (512 bytes)
[    0.068382] RTC time: 21:12:31, date: 01/16/12
[    0.068944] NET: Registered protocol family 16
[    0.070430] ACPI: bus type pci registered
[    0.070827] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.071000] PCI: not using MMCONFIG
[    0.071106] PCI: Using configuration type 1 for base access
[    0.076311] bio: create slab <bio-0> at 0
[    0.077019] ACPI: Added _OSI(Module Device)
[    0.077132] ACPI: Added _OSI(Processor Device)
[    0.077243] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.077353] ACPI: Added _OSI(Processor Aggregator Device)
[    0.084970] ACPI: EC: Look up EC in DSDT
[    0.093208] ACPI: Actual Package length (12) is larger than NumElements field (3), truncated
[    0.093423] 
[    0.099138] ACPI: SSDT 000000007f7563e5 000F3 (v02 TOSHIB A0058    20060907 MSFT 0100000E)
[    0.101454] ACPI: Dynamic OEM Table Load:
[    0.101661] ACPI: SSDT           (null) 000F3 (v02 TOSHIB A0058    20060907 MSFT 0100000E)
[    0.102098] ACPI: SSDT 000000007f75654e 0034E (v02 TOSHIB A0058    20060907 MSFT 0100000E)
[    0.104389] ACPI: Dynamic OEM Table Load:
[    0.104690] ACPI: SSDT           (null) 0034E (v02 TOSHIB A0058    20060907 MSFT 0100000E)
[    0.105151] ACPI: SSDT 000000007f7564d8 00076 (v02 TOSHIB A0058    20060907 MSFT 0100000E)
[    0.107445] ACPI: Dynamic OEM Table Load:
[    0.107650] ACPI: SSDT           (null) 00076 (v02 TOSHIB A0058    20060907 MSFT 0100000E)
[    0.108017] ACPI: SSDT 000000007f75689c 00079 (v02 TOSHIB A0058    20060907 MSFT 0100000E)
[    0.110318] ACPI: Dynamic OEM Table Load:
[    0.110994] ACPI: SSDT           (null) 00079 (v02 TOSHIB A0058    20060907 MSFT 0100000E)
[    0.112634] ACPI: Interpreter enabled
[    0.112743] ACPI: (supports S0 S3 S4 S5)
[    0.113149] ACPI: Using IOAPIC for interrupt routing
[    0.113312] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.115700] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in ACPI motherboard resources
[    0.163126] ACPI: ACPI Dock Station Driver: 1 docks/bays found
[    0.163241] HEST: Table not found.
[    0.163349] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.163730] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.164132] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.164249] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.164363] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.164526] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
[    0.164689] pci_root PNP0A08:00: host bridge window [mem 0x80000000-0xefffffff]
[    0.164851] pci_root PNP0A08:00: host bridge window [mem 0xf4000000-0xfebfffff]
[    0.164989] pci_root PNP0A08:00: host bridge window [mem 0xfec18000-0xfec1ffff]
[    0.165154] pci_root PNP0A08:00: host bridge window [mem 0xfec28000-0xfecfffff]
[    0.165317] pci_root PNP0A08:00: host bridge window [mem 0xfed00400-0xfed13fff]
[    0.165479] pci_root PNP0A08:00: host bridge window [mem 0xfed1a000-0xfed1bfff]
[    0.165642] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff]
[    0.165804] pci_root PNP0A08:00: host bridge window [mem 0xfed90000-0xfed9ffff]
[    0.165988] pci_root PNP0A08:00: host bridge window [mem 0xfedc0000-0xfedfffff]
[    0.166150] pci_root PNP0A08:00: host bridge window [mem 0xfee01000-0xff9fffff]
[    0.166313] pci_root PNP0A08:00: host bridge window [mem 0xffc00000-0xffcfffff]
[    0.166925] PCI host bridge to bus 0000:00
[    0.166989] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.167103] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.167216] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.167331] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
[    0.167446] pci_bus 0000:00: root bus resource [mem 0x80000000-0xefffffff]
[    0.167560] pci_bus 0000:00: root bus resource [mem 0xf4000000-0xfebfffff]
[    0.167675] pci_bus 0000:00: root bus resource [mem 0xfec18000-0xfec1ffff]
[    0.167788] pci_bus 0000:00: root bus resource [mem 0xfec28000-0xfecfffff]
[    0.167903] pci_bus 0000:00: root bus resource [mem 0xfed00400-0xfed13fff]
[    0.167988] pci_bus 0000:00: root bus resource [mem 0xfed1a000-0xfed1bfff]
[    0.168102] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
[    0.168217] pci_bus 0000:00: root bus resource [mem 0xfed90000-0xfed9ffff]
[    0.168332] pci_bus 0000:00: root bus resource [mem 0xfedc0000-0xfedfffff]
[    0.168447] pci_bus 0000:00: root bus resource [mem 0xfee01000-0xff9fffff]
[    0.168562] pci_bus 0000:00: root bus resource [mem 0xffc00000-0xffcfffff]
[    0.168749] pci 0000:00:00.0: [8086:27a0] type 0 class 0x000600
[    0.169061] pci 0000:00:02.0: [8086:27a2] type 0 class 0x000300
[    0.169093] pci 0000:00:02.0: reg 10: [mem 0xffc80000-0xffcfffff]
[    0.169110] pci 0000:00:02.0: reg 14: [io  0xcff8-0xcfff]
[    0.169127] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff pref]
[    0.169143] pci 0000:00:02.0: reg 1c: [mem 0xffc40000-0xffc7ffff]
[    0.169271] pci 0000:00:02.1: [8086:27a6] type 0 class 0x000380
[    0.169297] pci 0000:00:02.1: reg 10: [mem 0x00000000-0x0007ffff]
[    0.169578] pci 0000:00:1b.0: [8086:27d8] type 0 class 0x000403
[    0.169620] pci 0000:00:1b.0: reg 10: [mem 0x00000000-0x00003fff 64bit]
[    0.169816] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.169949] pci 0000:00:1c.0: [8086:27d0] type 1 class 0x000604
[    0.170168] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.170240] pci 0000:00:1c.2: [8086:27d4] type 1 class 0x000604
[    0.170443] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.170517] pci 0000:00:1d.0: [8086:27c8] type 0 class 0x000c03
[    0.170622] pci 0000:00:1d.0: reg 20: [io  0xafe0-0xafff]
[    0.170710] pci 0000:00:1d.1: [8086:27c9] type 0 class 0x000c03
[    0.170815] pci 0000:00:1d.1: reg 20: [io  0xaf80-0xaf9f]
[    0.170902] pci 0000:00:1d.2: [8086:27ca] type 0 class 0x000c03
[    0.171015] pci 0000:00:1d.2: reg 20: [io  0xaf60-0xaf7f]
[    0.171103] pci 0000:00:1d.3: [8086:27cb] type 0 class 0x000c03
[    0.171209] pci 0000:00:1d.3: reg 20: [io  0xaf40-0xaf5f]
[    0.171318] pci 0000:00:1d.7: [8086:27cc] type 0 class 0x000c03
[    0.171363] pci 0000:00:1d.7: reg 10: [mem 0xffc3fc00-0xffc3ffff]
[    0.171562] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.171617] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.171800] pci 0000:00:1f.0: [8086:27b9] type 0 class 0x000601
[    0.171974] pci 0000:00:1f.0: quirk: [io  0xd800-0xd87f] claimed by ICH6 ACPI/GPIO/TCO
[    0.171995] pci 0000:00:1f.0: quirk: [io  0xeec0-0xeeff] claimed by ICH6 GPIO
[    0.172113] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
[    0.172283] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 01e0 (mask 000f)
[    0.172554] pci 0000:00:1f.2: [8086:27c5] type 0 class 0x000106
[    0.172598] pci 0000:00:1f.2: reg 10: [io  0xaf38-0xaf3f]
[    0.172621] pci 0000:00:1f.2: reg 14: [io  0xaf34-0xaf37]
[    0.172643] pci 0000:00:1f.2: reg 18: [io  0xaf28-0xaf2f]
[    0.172666] pci 0000:00:1f.2: reg 1c: [io  0xaf24-0xaf27]
[    0.172688] pci 0000:00:1f.2: reg 20: [io  0xaf10-0xaf1f]
[    0.172711] pci 0000:00:1f.2: reg 24: [mem 0xffc3f800-0xffc3fbff]
[    0.172818] pci 0000:00:1f.2: PME# supported from D3hot
[    0.173190] pci 0000:01:00.0: [8086:109a] type 0 class 0x000200
[    0.173234] pci 0000:01:00.0: reg 10: [mem 0xff9e0000-0xff9fffff]
[    0.173293] pci 0000:01:00.0: reg 18: [io  0xbfe0-0xbfff]
[    0.173551] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.173607] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.173933] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.173993] pci 0000:00:1c.0:   bridge window [io  0xb000-0xbfff]
[    0.174003] pci 0000:00:1c.0:   bridge window [mem 0xff900000-0xff9fffff]
[    0.174270] pci 0000:02:00.0: [8086:4229] type 0 class 0x000280
[    0.174401] pci 0000:02:00.0: reg 10: [mem 0xff8fe000-0xff8fffff 64bit]
[    0.175157] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.175400] pci 0000:00:1c.2: PCI bridge to [bus 02-02]
[    0.175523] pci 0000:00:1c.2:   bridge window [mem 0xff800000-0xff8fffff]
[    0.175663] pci 0000:03:0b.0: [104c:8039] type 2 class 0x000607
[    0.175703] pci 0000:03:0b.0: reg 10: [mem 0x00000000-0x00000fff]
[    0.175771] pci 0000:03:0b.0: supports D1 D2
[    0.175775] pci 0000:03:0b.0: PME# supported from D0 D1 D2 D3hot
[    0.175826] pci 0000:03:0b.1: [104c:803a] type 0 class 0x000c00
[    0.175866] pci 0000:03:0b.1: reg 10: [mem 0x00000000-0x000007ff]
[    0.175889] pci 0000:03:0b.1: reg 14: [mem 0x00000000-0x00003fff]
[    0.176057] pci 0000:03:0b.1: supports D1 D2
[    0.176062] pci 0000:03:0b.1: PME# supported from D0 D1 D2 D3hot
[    0.176115] pci 0000:03:0b.3: [104c:803c] type 0 class 0x000805
[    0.176155] pci 0000:03:0b.3: reg 10: [mem 0x00000000-0x000000ff]
[    0.176330] pci 0000:03:0b.3: supports D1 D2
[    0.176335] pci 0000:03:0b.3: PME# supported from D0 D1 D2 D3hot
[    0.176436] pci 0000:00:1e.0: PCI bridge to [bus 03-04] (subtractive decode)
[    0.176573] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.176579] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.176584] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.176590] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.176596] pci 0000:00:1e.0:   bridge window [mem 0x80000000-0xefffffff] (subtractive decode)
[    0.176601] pci 0000:00:1e.0:   bridge window [mem 0xf4000000-0xfebfffff] (subtractive decode)
[    0.176607] pci 0000:00:1e.0:   bridge window [mem 0xfec18000-0xfec1ffff] (subtractive decode)
[    0.176613] pci 0000:00:1e.0:   bridge window [mem 0xfec28000-0xfecfffff] (subtractive decode)
[    0.176618] pci 0000:00:1e.0:   bridge window [mem 0xfed00400-0xfed13fff] (subtractive decode)
[    0.176624] pci 0000:00:1e.0:   bridge window [mem 0xfed1a000-0xfed1bfff] (subtractive decode)
[    0.176629] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
[    0.176635] pci 0000:00:1e.0:   bridge window [mem 0xfed90000-0xfed9ffff] (subtractive decode)
[    0.176641] pci 0000:00:1e.0:   bridge window [mem 0xfedc0000-0xfedfffff] (subtractive decode)
[    0.176646] pci 0000:00:1e.0:   bridge window [mem 0xfee01000-0xff9fffff] (subtractive decode)
[    0.176652] pci 0000:00:1e.0:   bridge window [mem 0xffc00000-0xffcfffff] (subtractive decode)
[    0.176737] pci_bus 0000:04: [bus 04-07] partially hidden behind transparent bridge 0000:03 [bus 03-04]
[    0.176942] pci_bus 0000:00: on NUMA node 0
[    0.176951] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.177385] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.177826] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[    0.178026] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MPEX._PRT]
[    0.178206]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.178327]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    0.178498] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.193804] ACPI: PCI Interrupt Link [LNKA] (IRQs *10)
[    0.194333] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *11)
[    0.195095] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *11)
[    0.195842] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *11)
[    0.196569] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *11)
[    0.197323] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *11)
[    0.198108] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *11)
[    0.198856] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11)
[    0.200235] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.200389] vgaarb: loaded
[    0.200493] vgaarb: bridge control possible 0000:00:02.0
[    0.201063] SCSI subsystem initialized
[    0.202036] libata version 3.00 loaded.
[    0.202231] usbcore: registered new interface driver usbfs
[    0.202396] usbcore: registered new interface driver hub
[    0.202521] usbcore: registered new device driver usb
[    0.203042] wmi: Mapper loaded
[    0.203147] PCI: Using ACPI for IRQ routing
[    0.207169] PCI: pci_cache_line_size set to 64 bytes
[    0.207455] reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
[    0.207462] reserve RAM buffer: 000000007f750000 - 000000007fffffff 
[    0.208361] NetLabel: Initializing
[    0.208466] NetLabel:  domain hash size = 128
[    0.208574] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.208790] NetLabel:  unlabeled traffic allowed by default
[    0.208909] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.208988] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.209294] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.214044] Switching to clocksource hpet
[    0.239031] AppArmor: AppArmor Filesystem Enabled
[    0.239224] pnp: PnP ACPI init
[    0.239419] ACPI: bus type pnp registered
[    0.241161] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    0.241168] pnp 00:00: [mem 0x000e0000-0x000fffff]
[    0.241173] pnp 00:00: [mem 0x00100000-0x7f74ffff]
[    0.241177] pnp 00:00: [mem 0x7f750000-0x7f75ffff]
[    0.241182] pnp 00:00: [mem 0x7f760000-0x7f7fffff]
[    0.241187] pnp 00:00: [mem 0x7f800000-0x7fffffff]
[    0.241191] pnp 00:00: [mem 0xfec00000-0xfec17fff]
[    0.241196] pnp 00:00: [mem 0xfec20000-0xfec27fff]
[    0.241201] pnp 00:00: [mem 0xfed14000-0xfed19fff]
[    0.241205] pnp 00:00: [mem 0xfed1c000-0xfed1ffff]
[    0.241210] pnp 00:00: [mem 0xfed20000-0xfed3ffff]
[    0.241214] pnp 00:00: [mem 0xfed45000-0xfed8ffff]
[    0.241219] pnp 00:00: [mem 0xfeda0000-0xfedbffff]
[    0.241223] pnp 00:00: [mem 0xfee00000-0xfee00fff]
[    0.241228] pnp 00:00: [mem 0xffa00000-0xffbfffff]
[    0.241232] pnp 00:00: [mem 0xffd00000-0xffffffff]
[    0.241491] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.241612] system 00:00: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.241729] system 00:00: [mem 0x00100000-0x7f74ffff] could not be reserved
[    0.241846] system 00:00: [mem 0x7f750000-0x7f75ffff] has been reserved
[    0.241961] system 00:00: [mem 0x7f760000-0x7f7fffff] has been reserved
[    0.242095] system 00:00: [mem 0x7f800000-0x7fffffff] has been reserved
[    0.242212] system 00:00: [mem 0xfec00000-0xfec17fff] could not be reserved
[    0.242328] system 00:00: [mem 0xfec20000-0xfec27fff] has been reserved
[    0.242443] system 00:00: [mem 0xfed14000-0xfed19fff] has been reserved
[    0.242559] system 00:00: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.242673] system 00:00: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.242791] system 00:00: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.242906] system 00:00: [mem 0xfeda0000-0xfedbffff] has been reserved
[    0.243044] system 00:00: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.243159] system 00:00: [mem 0xffa00000-0xffbfffff] has been reserved
[    0.243274] system 00:00: [mem 0xffd00000-0xffffffff] has been reserved
[    0.243446] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.244565] pnp 00:01: [mem 0xf0000000-0xf3ffffff]
[    0.244758] system 00:01: [mem 0xf0000000-0xf3ffffff] has been reserved
[    0.244880] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.245120] pnp 00:02: [bus 00-ff]
[    0.245130] pnp 00:02: [io  0x0cf8-0x0cff]
[    0.245135] pnp 00:02: [io  0x0000-0x0cf7 window]
[    0.245140] pnp 00:02: [io  0x0d00-0xffff window]
[    0.245145] pnp 00:02: [mem 0x000a0000-0x000bffff window]
[    0.245150] pnp 00:02: [mem 0x000d0000-0x000dffff window]
[    0.245155] pnp 00:02: [mem 0x80000000-0xefffffff window]
[    0.245160] pnp 00:02: [mem 0xf4000000-0xfebfffff window]
[    0.245165] pnp 00:02: [mem 0xfec18000-0xfec1ffff window]
[    0.245170] pnp 00:02: [mem 0xfec28000-0xfecfffff window]
[    0.245175] pnp 00:02: [mem 0xfed00400-0xfed13fff window]
[    0.245180] pnp 00:02: [mem 0xfed1a000-0xfed1bfff window]
[    0.245185] pnp 00:02: [mem 0xfed40000-0xfed44fff window]
[    0.245190] pnp 00:02: [mem 0xfed90000-0xfed9ffff window]
[    0.245195] pnp 00:02: [mem 0xfedc0000-0xfedfffff window]
[    0.245200] pnp 00:02: [mem 0xfee01000-0xff9fffff window]
[    0.245205] pnp 00:02: [mem 0xffc00000-0xffcfffff window]
[    0.245438] pnp 00:02: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.245819] pnp 00:03: [io  0x0000-0x000f]
[    0.245825] pnp 00:03: [io  0x0081-0x0083]
[    0.245829] pnp 00:03: [io  0x0087]
[    0.245833] pnp 00:03: [io  0x0089-0x008b]
[    0.245838] pnp 00:03: [io  0x008f]
[    0.245842] pnp 00:03: [io  0x00c0-0x00df]
[    0.245847] pnp 00:03: [dma 4]
[    0.245979] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.246071] pnp 00:04: [io  0x0061]
[    0.246202] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.246241] pnp 00:05: [io  0x00f0-0x00ff]
[    0.246265] pnp 00:05: [irq 13]
[    0.246401] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.246486] pnp 00:06: [io  0x0060]
[    0.246490] pnp 00:06: [io  0x0064]
[    0.246506] pnp 00:06: [irq 1]
[    0.246675] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.246768] pnp 00:07: [irq 12]
[    0.246907] pnp 00:07: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.246949] pnp 00:08: [io  0x0070-0x0071]
[    0.246964] pnp 00:08: [irq 8]
[    0.247123] pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.248099] pnp 00:09: [io  0x0080]
[    0.248104] pnp 00:09: [io  0x0084-0x0086]
[    0.248109] pnp 00:09: [io  0x0088]
[    0.248113] pnp 00:09: [io  0x008c-0x008e]
[    0.248117] pnp 00:09: [io  0x002e-0x002f]
[    0.248122] pnp 00:09: [io  0x0062]
[    0.248126] pnp 00:09: [io  0x0066]
[    0.248130] pnp 00:09: [io  0x01e0-0x01ef]
[    0.248135] pnp 00:09: [io  0x0480-0x048f]
[    0.248139] pnp 00:09: [io  0xe000-0xe07f]
[    0.248144] pnp 00:09: [io  0xe080-0xe0ff]
[    0.248148] pnp 00:09: [io  0xe400-0xe47f]
[    0.248152] pnp 00:09: [io  0xe480-0xe4ff]
[    0.248157] pnp 00:09: [io  0xe800-0xe87f]
[    0.248161] pnp 00:09: [io  0xe880-0xe8ff]
[    0.248165] pnp 00:09: [io  0xec00-0xec7f]
[    0.248170] pnp 00:09: [io  0xec80-0xecff]
[    0.248174] pnp 00:09: [io  0xd800-0xd87f]
[    0.248179] pnp 00:09: [io  0xd880-0xd89f]
[    0.248183] pnp 00:09: [io  0xeeb0-0xeebf]
[    0.248187] pnp 00:09: [io  0xeec0-0xeeff]
[    0.248192] pnp 00:09: [io  0x0690-0x06ff]
[    0.248196] pnp 00:09: [io  0x0010-0x001f]
[    0.248200] pnp 00:09: [io  0x0024-0x0025]
[    0.248205] pnp 00:09: [io  0x0028-0x0029]
[    0.248209] pnp 00:09: [io  0x002c-0x002d]
[    0.248213] pnp 00:09: [io  0x0030-0x0031]
[    0.248221] pnp 00:09: [io  0x0034-0x0035]
[    0.248226] pnp 00:09: [io  0x0038-0x0039]
[    0.248230] pnp 00:09: [io  0x003c-0x003d]
[    0.248234] pnp 00:09: [io  0x0050-0x0053]
[    0.248239] pnp 00:09: [io  0x0063]
[    0.248243] pnp 00:09: [io  0x0065]
[    0.248248] pnp 00:09: [io  0x0072-0x0077]
[    0.248252] pnp 00:09: [io  0x0090-0x009f]
[    0.248256] pnp 00:09: [io  0x00a4-0x00a5]
[    0.248261] pnp 00:09: [io  0x00a8-0x00a9]
[    0.248265] pnp 00:09: [io  0x00ac-0x00ad]
[    0.248269] pnp 00:09: [io  0x00b0-0x00b5]
[    0.248273] pnp 00:09: [io  0x00b8-0x00b9]
[    0.248278] pnp 00:09: [io  0x00bc-0x00bd]
[    0.248282] pnp 00:09: [io  0x04d0-0x04d1]
[    0.248561] system 00:09: [io  0x01e0-0x01ef] has been reserved
[    0.248677] system 00:09: [io  0x0480-0x048f] has been reserved
[    0.248791] system 00:09: [io  0xe000-0xe07f] has been reserved
[    0.248904] system 00:09: [io  0xe080-0xe0ff] has been reserved
[    0.249041] system 00:09: [io  0xe400-0xe47f] has been reserved
[    0.249155] system 00:09: [io  0xe480-0xe4ff] has been reserved
[    0.249268] system 00:09: [io  0xe800-0xe87f] has been reserved
[    0.249384] system 00:09: [io  0xe880-0xe8ff] has been reserved
[    0.249497] system 00:09: [io  0xec00-0xec7f] has been reserved
[    0.249610] system 00:09: [io  0xec80-0xecff] has been reserved
[    0.249723] system 00:09: [io  0xd800-0xd87f] has been reserved
[    0.249838] system 00:09: [io  0xd880-0xd89f] has been reserved
[    0.249951] system 00:09: [io  0xeeb0-0xeebf] has been reserved
[    0.250080] system 00:09: [io  0xeec0-0xeeff] has been reserved
[    0.250194] system 00:09: [io  0x0690-0x06ff] has been reserved
[    0.250313] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.250431] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.251676] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    0.251682] pnp 00:0a: [io  0x004e-0x004f]
[    0.251687] pnp 00:0a: [io  0x0680-0x068f]
[    0.251838] pnp 00:0a: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
[    0.251904] pnp 00:0b: [mem 0xfed00000-0xfed003ff]
[    0.252081] pnp 00:0b: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.252874] pnp: PnP ACPI: found 12 devices
[    0.252985] ACPI: ACPI bus type pnp unregistered
[    0.267540] PCI: max bus depth: 2 pci_try_num: 3
[    0.267624] pci 0000:00:1e.0: BAR 8: assigned [mem 0x80000000-0x81ffffff]
[    0.267751] pci 0000:00:02.1: BAR 0: assigned [mem 0x82000000-0x8207ffff]
[    0.267879] pci 0000:00:1b.0: BAR 0: assigned [mem 0x82080000-0x82083fff 64bit]
[    0.268079] pci 0000:00:1e.0: BAR 8: assigned [mem 0x84000000-0x89ffffff]
[    0.268204] pci 0000:00:1e.0: BAR 9: assigned [mem 0x8c000000-0x8fffffff pref]
[    0.268375] pci 0000:00:1e.0: BAR 7: assigned [io  0x1000-0x1fff]
[    0.268495] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.268612] pci 0000:00:1c.0:   bridge window [io  0xb000-0xbfff]
[    0.268737] pci 0000:00:1c.0:   bridge window [mem 0xff900000-0xff9fffff]
[    0.268873] pci 0000:00:1c.2: PCI bridge to [bus 02-02]
[    0.268994] pci 0000:00:1c.2:   bridge window [mem 0xff800000-0xff8fffff]
[    0.269149] pci 0000:03:0b.0: BAR 0: assigned [mem 0x84000000-0x84000fff]
[    0.269271] pci 0000:03:0b.1: BAR 1: assigned [mem 0x84004000-0x84007fff]
[    0.269392] pci 0000:03:0b.1: BAR 0: assigned [mem 0x84001000-0x840017ff]
[    0.269513] pci 0000:03:0b.3: BAR 0: assigned [mem 0x84001800-0x840018ff]
[    0.269637] pci 0000:03:0b.0: BAR 10: assigned [mem 0x90000000-0x93ffffff]
[    0.269753] pci 0000:03:0b.0: BAR 9: assigned [mem 0x8c000000-0x8fffffff pref]
[    0.269917] pci 0000:03:0b.0: BAR 8: assigned [io  0x1000-0x10ff]
[    0.270046] pci 0000:03:0b.0: BAR 7: assigned [io  0x1400-0x14ff]
[    0.270162] pci 0000:03:0b.0: CardBus bridge to [bus 04-07]
[    0.270277] pci 0000:03:0b.0:   bridge window [io  0x1400-0x14ff]
[    0.270399] pci 0000:03:0b.0:   bridge window [io  0x1000-0x10ff]
[    0.270521] pci 0000:03:0b.0:   bridge window [mem 0x8c000000-0x8fffffff pref]
[    0.270693] pci 0000:03:0b.0:   bridge window [mem 0x90000000-0x93ffffff]
[    0.270818] pci 0000:00:1e.0: PCI bridge to [bus 03-04]
[    0.270934] pci 0000:00:1e.0:   bridge window [io  0x1000-0x1fff]
[    0.271073] pci 0000:00:1e.0:   bridge window [mem 0x84000000-0x89ffffff]
[    0.271197] pci 0000:00:1e.0:   bridge window [mem 0x8c000000-0x8fffffff pref]
[    0.271446] pci 0000:00:1e.0: setting latency timer to 64
[    0.271463] pci 0000:03:0b.0: enabling device (0000 -> 0003)
[    0.271605] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.271610] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.271615] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.271620] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.271625] pci_bus 0000:00: resource 8 [mem 0x80000000-0xefffffff]
[    0.271630] pci_bus 0000:00: resource 9 [mem 0xf4000000-0xfebfffff]
[    0.271635] pci_bus 0000:00: resource 10 [mem 0xfec18000-0xfec1ffff]
[    0.271640] pci_bus 0000:00: resource 11 [mem 0xfec28000-0xfecfffff]
[    0.271645] pci_bus 0000:00: resource 12 [mem 0xfed00400-0xfed13fff]
[    0.271649] pci_bus 0000:00: resource 13 [mem 0xfed1a000-0xfed1bfff]
[    0.271654] pci_bus 0000:00: resource 14 [mem 0xfed40000-0xfed44fff]
[    0.271659] pci_bus 0000:00: resource 15 [mem 0xfed90000-0xfed9ffff]
[    0.271664] pci_bus 0000:00: resource 16 [mem 0xfedc0000-0xfedfffff]
[    0.271669] pci_bus 0000:00: resource 17 [mem 0xfee01000-0xff9fffff]
[    0.271674] pci_bus 0000:00: resource 18 [mem 0xffc00000-0xffcfffff]
[    0.271679] pci_bus 0000:01: resource 0 [io  0xb000-0xbfff]
[    0.271684] pci_bus 0000:01: resource 1 [mem 0xff900000-0xff9fffff]
[    0.271689] pci_bus 0000:02: resource 1 [mem 0xff800000-0xff8fffff]
[    0.271695] pci_bus 0000:03: resource 0 [io  0x1000-0x1fff]
[    0.271700] pci_bus 0000:03: resource 1 [mem 0x84000000-0x89ffffff]
[    0.271705] pci_bus 0000:03: resource 2 [mem 0x8c000000-0x8fffffff pref]
[    0.271710] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    0.271714] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    0.271719] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    0.271724] pci_bus 0000:03: resource 7 [mem 0x000d0000-0x000dffff]
[    0.271729] pci_bus 0000:03: resource 8 [mem 0x80000000-0xefffffff]
[    0.271734] pci_bus 0000:03: resource 9 [mem 0xf4000000-0xfebfffff]
[    0.271738] pci_bus 0000:03: resource 10 [mem 0xfec18000-0xfec1ffff]
[    0.271743] pci_bus 0000:03: resource 11 [mem 0xfec28000-0xfecfffff]
[    0.271748] pci_bus 0000:03: resource 12 [mem 0xfed00400-0xfed13fff]
[    0.271753] pci_bus 0000:03: resource 13 [mem 0xfed1a000-0xfed1bfff]
[    0.271758] pci_bus 0000:03: resource 14 [mem 0xfed40000-0xfed44fff]
[    0.271762] pci_bus 0000:03: resource 15 [mem 0xfed90000-0xfed9ffff]
[    0.271767] pci_bus 0000:03: resource 16 [mem 0xfedc0000-0xfedfffff]
[    0.271772] pci_bus 0000:03: resource 17 [mem 0xfee01000-0xff9fffff]
[    0.271777] pci_bus 0000:03: resource 18 [mem 0xffc00000-0xffcfffff]
[    0.271782] pci_bus 0000:04: resource 0 [io  0x1400-0x14ff]
[    0.271787] pci_bus 0000:04: resource 1 [io  0x1000-0x10ff]
[    0.271791] pci_bus 0000:04: resource 2 [mem 0x8c000000-0x8fffffff pref]
[    0.271796] pci_bus 0000:04: resource 3 [mem 0x90000000-0x93ffffff]
[    0.272076] NET: Registered protocol family 2
[    0.272614] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.274427] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.277966] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
[    0.286885] TCP: Hash tables configured (established 262144 bind 65536)
[    0.288110] TCP reno registered
[    0.288241] UDP hash table entries: 1024 (order: 5, 163840 bytes)
[    0.288661] UDP-Lite hash table entries: 1024 (order: 5, 163840 bytes)
[    0.289447] NET: Registered protocol family 1
[    0.289607] pci 0000:00:02.0: Boot video device
[    0.289898] PCI: CLS 32 bytes, default 64
[    0.290313] Unpacking initramfs...
[    0.700556] Freeing initrd memory: 11872k freed
[    0.709832] Simple Boot Flag value 0xb read from CMOS RAM was invalid
[    0.709956] Simple Boot Flag at 0x7c set to 0x1
[    0.712383] audit: initializing netlink socket (disabled)
[    0.712594] type=2000 audit(1326748351.711:1): initialized
[    0.713777] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.715148] VFS: Disk quotas dquot_6.5.2
[    0.715421] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.717021] msgmni has been set to 3970
[    0.718465] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.718807] io scheduler noop registered
[    0.718917] io scheduler deadline registered
[    0.719108] io scheduler cfq registered (default)
[    0.720022] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.720427] pcieport 0000:00:1c.2: irq 41 for MSI/MSI-X
[    0.721749] intel_idle: MWAIT substates: 0x22220
[    0.721754] intel_idle: does not run on family 6 model 15
[    0.722213] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    0.722571] ACPI: Lid Switch [LID]
[    0.722885] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.723159] ACPI: Power Button [PWRB]
[    0.723445] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.723615] ACPI: Power Button [PWRF]
[    0.726993] acpi device:09: registered as cooling_device0
[    0.727632] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input3
[    0.727808] ACPI: Video Device [VGA] (multi-head: yes  rom: yes  post: no)
[    0.728041] ERST: Table is not found!
[    0.728148] GHES: HEST is not enabled!
[    0.728475] Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
[    0.738442] Non-volatile memory driver v1.3
[    0.738553] Linux agpgart interface v0.103
[    0.738855] agpgart-intel 0000:00:00.0: Intel 945GM Chipset
[    0.739252] agpgart-intel 0000:00:00.0: detected gtt size: 262144K total, 262144K mappable
[    0.740306] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
[    0.740834] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    0.741103] [drm] Initialized drm 1.1.0 20060810
[    0.741265] i915 0000:00:02.0: power state changed by ACPI to D0
[    0.741388] i915 0000:00:02.0: power state changed by ACPI to D0
[    0.741563] i915 0000:00:02.0: setting latency timer to 64
[    0.869529] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.869648] [drm] Driver supports precise vblank timestamp query.
[    0.870374] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    0.899022] fixme: max PWM is zero.
[    1.100419] [drm] initialized overlay support
[    1.140251] fbcon: inteldrmfb (fb0) is primary device
[    1.712118] Refined TSC clocksource calibration: 1329.999 MHz.
[    1.712157] Switching to clocksource tsc
[    2.158096] Console: switching to colour frame buffer device 160x50
[    2.162375] fb0: inteldrmfb frame buffer device
[    2.162379] drm: registered panic notifier
[    2.162518] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    2.162848] ahci 0000:00:1f.2: version 3.0
[    2.163015] ahci 0000:00:1f.2: irq 42 for MSI/MSI-X
[    2.163191] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x1 impl SATA mode
[    2.163271] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
[    2.163338] ahci 0000:00:1f.2: setting latency timer to 64
[    2.166054] scsi0 : ahci
[    2.166801] scsi1 : ahci
[    2.167142] scsi2 : ahci
[    2.167472] scsi3 : ahci
[    2.168423] ata1: SATA max UDMA/133 abar m1024@0xffc3f800 port 0xffc3f900 irq 42
[    2.168493] ata2: DUMMY
[    2.168520] ata3: DUMMY
[    2.168546] ata4: DUMMY
[    2.169189] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.169361] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.169370] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.170427] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    2.170585] ehci_hcd 0000:00:1d.7: using broken periodic workaround
[    2.170662] ehci_hcd 0000:00:1d.7: debug port 1
[    2.176208] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    2.176272] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xffc3fc00
[    2.183045] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.185053] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.186694] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.188325] usb usb1: Product: EHCI Host Controller
[    2.189950] usb usb1: Manufacturer: Linux 3.2.0+ ehci_hcd
[    2.191555] usb usb1: SerialNumber: 0000:00:1d.7
[    2.194292] hub 1-0:1.0: USB hub found
[    2.195954] hub 1-0:1.0: 8 ports detected
[    2.198423] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.199994] uhci_hcd: USB Universal Host Controller Interface driver
[    2.201600] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.201609] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.203137] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.204728] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000afe0
[    2.206429] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    2.207985] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.209511] usb usb2: Product: UHCI Host Controller
[    2.211013] usb usb2: Manufacturer: Linux 3.2.0+ uhci_hcd
[    2.212524] usb usb2: SerialNumber: 0000:00:1d.0
[    2.214496] hub 2-0:1.0: USB hub found
[    2.216029] hub 2-0:1.0: 2 ports detected
[    2.217920] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.217928] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.219441] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    2.221064] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000af80
[    2.222690] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.224212] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.225718] usb usb3: Product: UHCI Host Controller
[    2.227205] usb usb3: Manufacturer: Linux 3.2.0+ uhci_hcd
[    2.228698] usb usb3: SerialNumber: 0000:00:1d.1
[    2.230679] hub 3-0:1.0: USB hub found
[    2.232143] hub 3-0:1.0: 2 ports detected
[    2.233931] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.233939] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.235405] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    2.236941] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000af60
[    2.238529] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.240059] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.241549] usb usb4: Product: UHCI Host Controller
[    2.243011] usb usb4: Manufacturer: Linux 3.2.0+ uhci_hcd
[    2.244499] usb usb4: SerialNumber: 0000:00:1d.2
[    2.246454] hub 4-0:1.0: USB hub found
[    2.247959] hub 4-0:1.0: 2 ports detected
[    2.249800] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    2.249808] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    2.251316] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    2.252851] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000af40
[    2.254462] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.255983] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.257505] usb usb5: Product: UHCI Host Controller
[    2.259013] usb usb5: Manufacturer: Linux 3.2.0+ uhci_hcd
[    2.260522] usb usb5: SerialNumber: 0000:00:1d.3
[    2.262488] hub 5-0:1.0: USB hub found
[    2.263994] hub 5-0:1.0: 2 ports detected
[    2.265856] Initializing USB Mass Storage driver...
[    2.267421] usbcore: registered new interface driver usb-storage
[    2.268931] USB Mass Storage support registered.
[    2.270469] usbcore: registered new interface driver ums-alauda
[    2.272030] usbcore: registered new interface driver ums-cypress
[    2.273555] usbcore: registered new interface driver ums-datafab
[    2.275059] usbcore: registered new interface driver ums-freecom
[    2.276539] usbcore: registered new interface driver ums-isd200
[    2.277984] usbcore: registered new interface driver ums-jumpshot
[    2.279412] usbcore: registered new interface driver ums-karma
[    2.280822] usbcore: registered new interface driver ums-onetouch
[    2.282203] usbcore: registered new interface driver ums-sddr09
[    2.283572] usbcore: registered new interface driver ums-sddr55
[    2.284917] usbcore: registered new interface driver ums-usbat
[    2.286360] i8042: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    2.292647] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.294664] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.296428] mousedev: PS/2 mouse device common for all mice
[    2.299760] rtc_cmos 00:08: RTC can wake from S4
[    2.302032] rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
[    2.303414] rtc0: alarms up to one year, 114 bytes nvram, hpet irqs
[    2.304885] cpuidle: using governor ladder
[    2.306223] cpuidle: using governor menu
[    2.307527] EFI Variables Facility v0.08 2004-May-17
[    2.309520] usbcore: registered new interface driver usbhid
[    2.310953] usbhid: USB HID core driver
[    2.313993] TCP cubic registered
[    2.315700] NET: Registered protocol family 10
[    2.315933] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    2.321489] lib80211: common routines for IEEE802.11 drivers
[    2.322888] lib80211_crypt: registered algorithm 'NULL'
[    2.322893] Registering the dns_resolver key type
[    2.324498] libceph: loaded (mon/osd proto 15/24, osdmap 5/6 5/6)
[    2.326373] PM: Checking hibernation image partition /dev/disk/by-id/ata-INTEL_SSDSA2M080G2GN_CVPO9456006H080BGN-part2
[    2.475048] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.477091] ata1.00: unexpected _GTF length (8)
[    2.478535] ata1.00: ATA-7: INTEL SSDSA2M080G2GN, 2CV102HA, max UDMA/133
[    2.479946] ata1.00: 156301488 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    2.481692] ata1.00: unexpected _GTF length (8)
[    2.483229] ata1.00: configured for UDMA/133
[    2.485930] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2M080 2CV1 PQ: 0 ANSI: 5
[    2.488875] sd 0:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
[    2.490650] sd 0:0:0:0: [sda] Write Protect is off
[    2.492102] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.492185] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.496982]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    2.501146] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.704114] usb 1-4: new high-speed USB device number 4 using ehci_hcd
[    2.819712] usb 1-4: New USB device found, idVendor=0930, idProduct=0c05
[    2.821243] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.822761] usb 1-4: Product: Optical Drive Controller
[    2.824263] usb 1-4: Manufacturer: TOSHIBA
[    2.826825] scsi4 : usb-storage 1-4:1.0
[    3.086033] usb 2-2: new full-speed USB device number 2 using uhci_hcd
[    3.132873] input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input5
[    3.159819] input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio1/input/input6
[    3.166349] PM: Hibernation image not present or could not be loaded.
[    3.166374] registered taskstats version 1
[    3.169139]   Magic number: 12:566:247
[    3.170989] rtc_cmos 00:08: setting system clock to 2012-01-16 21:12:34 UTC (1326748354)
[    3.175717] Freeing unused kernel memory: 620k freed
[    3.177796] Write protecting the kernel read-only data: 12288k
[    3.190417] Freeing unused kernel memory: 1860k freed
[    3.201092] Freeing unused kernel memory: 1380k freed
[    3.240401] usb 2-2: New USB device found, idVendor=0930, idProduct=1302
[    3.242289] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=2
[    3.244117] usb 2-2: Product: Novatel Wireless HSDPA Modem
[    3.245945] usb 2-2: Manufacturer: Novatel Wireless
[    3.247785] usb 2-2: SerialNumber: Novatel Wireless HSDPA Modem
[    3.320271] udevd[84]: starting version 173
[    3.444627] Marking TSC unstable due to TSC halts in idle
[    3.464096] ACPI: acpi_idle registered with cpuidle
[    3.467054] usb 3-1: new full-speed USB device number 2 using uhci_hcd
[    3.469041] Switching to clocksource hpet
[    3.490882] thermal LNXTHERM:00: registered as thermal_zone0
[    3.496071] ACPI: Thermal Zone [THRM] (50 C)
[    3.620662] usb 3-1: New USB device found, idVendor=08ff, idProduct=1600
[    3.622694] usb 3-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    3.624612] usb 3-1: Product: Fingerprint Sensor
[    3.830960] scsi 4:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-844S  1.10 PQ: 0 ANSI: 0
[    3.837075] usb 5-1: new low-speed USB device number 2 using uhci_hcd
[    3.979708] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
[    3.979719] PM: Basic memory bitmaps created
[    3.995201] PM: Basic memory bitmaps freed
[    3.995218] video LNXVIDEO:00: Restoring backlight state
[    4.003433] usb 5-1: New USB device found, idVendor=047d, idProduct=101f
[    4.005503] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.007536] usb 5-1: Product: Kensington PocketMouse Pro
[    4.013208] usb 5-1: Manufacturer: Kensington
[    4.032454] PM: Starting manual resume from disk
[    4.034489] PM: Hibernation image partition 8:2 present
[    4.034493] PM: Looking for hibernation image.
[    4.035338] PM: Image not found (code -22)
[    4.035342] PM: Hibernation image not present or could not be loaded.
[    4.039944] input: Kensington Kensington PocketMouse Pro as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.0/input/input7
[    4.046646] generic-usb 0003:047D:101F.0001: input,hidraw0: USB HID v1.10 Mouse [Kensington Kensington PocketMouse Pro] on usb-0000:00:1d.3-1/input0
[    4.127607] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[    4.160814] EXT4-fs (sda5): re-mounted. Opts: acl,user_xattr
[    4.714436] udevd[371]: starting version 173
[    4.924568] ACPI: AC Adapter [ADP1] (on-line)
[    4.948475] ACPI: Battery Slot [BAT1] (battery present)
[    4.984472] toshiba_bluetooth: Detected Toshiba ACPI Bluetooth device - installing RFKill handler
[    5.034054] toshiba_bluetooth: Re-enabling Toshiba Bluetooth
[    5.066807] tpm_tis 00:0a: 1.2 TPM (device-id 0xB, rev-id 16)
[    5.072288] toshiba_acpi: Toshiba Laptop ACPI Extras version 0.19
[    5.075232] input: Toshiba input device as /devices/virtual/input/input8
[    5.103893] Registered led device: toshiba::illumination
[    5.201229] intel_rng: FWH not detected
[    5.232367] leds_ss4200: no LED devices found
[    5.244931] input: PC Speaker as /devices/platform/pcspkr/input/input9
[    5.251937] e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
[    5.283624] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    5.306627] e1000e 0000:01:00.0: Disabling ASPM L0s L1
[    5.320806] yenta_cardbus 0000:03:0b.0: CardBus bridge found [1179:0001]
[    5.324994] e1000e 0000:01:00.0: irq 43 for MSI/MSI-X
[    5.336783] yenta_cardbus 0000:03:0b.0: Enabling burst memory read transactions
[    5.355493] yenta_cardbus 0000:03:0b.0: Using CSCINT to route CSC interrupts to PCI
[    5.375184] yenta_cardbus 0000:03:0b.0: Routing CardBus interrupts to PCI
[    5.377730] cfg80211: Calling CRDA to update world regulatory domain
[    5.386040] sdhci: Secure Digital Host Controller Interface driver
[    5.391262] sdhci: Copyright(c) Pierre Ossman
[    5.394100] yenta_cardbus 0000:03:0b.0: TI: mfunc 0x01aa1022, devctl 0x64
[    5.419658] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.436801] scsi 4:0:0:0: Attached scsi generic sg1 type 5
[    5.441254] e1000e 0000:01:00.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:1c:7e:af:dd:ac
[    5.443862] WARNING! power/level is deprecated; use power/control instead
[    5.471955] e1000e 0000:01:00.0: eth0: Intel(R) PRO/1000 Network Connection
[    5.474296] e1000e 0000:01:00.0: eth0: MAC: 2, PHY: 2, PBA No: FFFFFF-0FF
[    5.514606] snd_hda_intel 0000:00:1b.0: power state changed by ACPI to D0
[    5.517217] snd_hda_intel 0000:00:1b.0: power state changed by ACPI to D0
[    5.519343] snd_hda_intel 0000:00:1b.0: enabling device (0000 -> 0002)
[    5.534545] snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[    5.594386] usbcore: registered new interface driver usbserial
[    5.597238] USB Serial support registered for generic
[    5.599536] hda_codec: ALC262: SKU not ready 0x598301f0
[    5.602445] ALSA hda_codec.c:4923 autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:speaker
[    5.602453] ALSA hda_codec.c:4927    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    5.602459] ALSA hda_codec.c:4931    hp_outs=1 (0x15/0x0/0x0/0x0/0x0)
[    5.602463] ALSA hda_codec.c:4932    mono: mono_out=0x0
[    5.602468] ALSA hda_codec.c:4936    inputs:
[    5.602472] ALSA hda_codec.c:4940  Mic=0x18
[    5.602477] ALSA hda_codec.c:4940  Internal Mic=0x19
[    5.602481] ALSA hda_codec.c:4942 
[    5.605094] ALSA patch_realtek.c:1299 realtek: No valid SSID, checking pincfg 0x598301f0 for NID 0x1d
[    5.605100] ALSA patch_realtek.c:1382 realtek: Enable default setup for auto mode as fallback
[    5.635186] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    5.636120] yenta_cardbus 0000:03:0b.0: ISA IRQ mask 0x0cf8, PCI irq 21
[    5.636126] yenta_cardbus 0000:03:0b.0: Socket status: 30000006
[    5.636133] pci_bus 0000:03: Raising subordinate bus# of parent bus (#03) from #04 to #07
[    5.636502] yenta_cardbus 0000:03:0b.0: pcmcia: parent PCI bridge window: [io  0x1000-0x1fff]
[    5.636508] yenta_cardbus 0000:03:0b.0: pcmcia: parent PCI bridge window: [mem 0x84000000-0x89ffffff]
[    5.636514] pcmcia_socket pcmcia_socket0: cs: memory probe 0x84000000-0x89ffffff: excluding 0x84000000-0x845fffff
[    5.636611] yenta_cardbus 0000:03:0b.0: pcmcia: parent PCI bridge window: [mem 0x8c000000-0x8fffffff pref]
[    5.636616] pcmcia_socket pcmcia_socket0: cs: memory probe 0x8c000000-0x8fffffff: excluding 0x8c000000-0x8fffffff
[    5.660139] usb 5-2: new full-speed USB device number 3 using uhci_hcd
[    5.665323] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    5.675440] firewire_ohci 0000:03:0b.1: enabling device (0000 -> 0002)
[    5.733523] firewire_ohci: Added fw-ohci device 0000:03:0b.1, OHCI v1.10, 4 IR + 8 IT contexts, quirks 0x2
[    5.735789] sdhci-pci 0000:03:0b.3: SDHCI controller found [104c:803c] (rev 0)
[    5.738332] sdhci-pci 0000:03:0b.3: enabling device (0000 -> 0002)
[    5.743198] Registered led device: mmc0::
[    5.746262] mmc0: SDHCI controller on PCI [0000:03:0b.3] using DMA
[    5.827459] usb 5-2: New USB device found, idVendor=0930, idProduct=0508
[    5.829760] usb 5-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.837126] usbcore: registered new interface driver usbserial_generic
[    5.841067] usbserial: USB Serial Driver core
[    5.844601] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0c0000-0x0fffff: excluding 0xc0000-0xcffff 0xe0000-0xfffff
[    5.859167] cfg80211: World regulatory domain updated:
[    5.861601] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    5.890193] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    5.893951] USB Serial support registered for GSM modem (1-port)
[    5.895776] pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0xa0ffffff: clean.
[    5.896138] pcmcia_socket pcmcia_socket0: cs: memory probe 0x60000000-0x60ffffff: excluding 0x60000000-0x60ffffff
[    5.901048] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    5.905164] option 2-2:1.0: GSM modem (1-port) converter detected
[    5.914253] usb 2-2: GSM modem (1-port) converter now attached to ttyUSB0
[    5.918090] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    5.925557] option 2-2:1.1: GSM modem (1-port) converter detected
[    5.932080] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    5.934525] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    5.948263] usb 2-2: GSM modem (1-port) converter now attached to ttyUSB1
[    5.950588] option 2-2:1.2: GSM modem (1-port) converter detected
[    5.981957] usb 2-2: GSM modem (1-port) converter now attached to ttyUSB2
[    6.009179] option 2-2:1.3: GSM modem (1-port) converter detected
[    6.025904] usb 2-2: GSM modem (1-port) converter now attached to ttyUSB3
[    6.032937] usbcore: registered new interface driver option
[    6.036862] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    6.038307] option: v0.7.2:USB Driver for GSM modems
[    6.078366] cdrom: Uniform CD-ROM driver Revision: 3.20
[    6.118893] Bluetooth: Core ver 2.16
[    6.121706] sr 4:0:0:0: Attached scsi CD-ROM sr0
[    6.149726] NET: Registered protocol family 31
[    6.164738] Bluetooth: HCI device and connection manager initialized
[    6.174640] iwl4965: Intel(R) Wireless WiFi 4965 driver for Linux, in-tree:
[    6.181713] Bluetooth: HCI socket layer initialized
[    6.189922] Bluetooth: L2CAP socket layer initialized
[    6.193058] iwl4965: Copyright(c) 2003-2011 Intel Corporation
[    6.196644] Bluetooth: SCO socket layer initialized
[    6.201242] iwl4965 0000:02:00.0: Detected Intel(R) Wireless WiFi Link 4965AGN, REV=0x4
[    6.214896] usbcore: registered new interface driver btusb
[    6.236374] firewire_core: created device fw0: GUID 0000390000be012e, S400
[    6.308127] iwl4965 0000:02:00.0: device EEPROM VER=0x36, CALIB=0x5
[    6.310298] iwl4965 0000:02:00.0: Tunable channels: 13 802.11bg, 19 802.11a channels
[    6.312884] iwl4965 0000:02:00.0: irq 45 for MSI/MSI-X
[    6.329703] iwl4965 0000:02:00.0: loaded firmware version 228.61.2.24
[    6.332276] Registered led device: phy0-led
[    6.345275] ieee80211 phy0: Selected rate control algorithm 'iwl-4965-rs'
[    7.167236] tpm_tis 00:0a: Adjusting TPM timeout parameters.
[    7.893190] tpm_tis 00:0a: A TPM error (7) occurred attempting to read a pcr value
[    7.897202] tpm_tis 00:0a: TPM self test failed
[    7.907599] tpm_inf_pnp 00:0a: Found TPM with ID IFX0102
[    7.909745] tpm_inf_pnp 00:0a: TPM found: config base 0x4e, data base 0x680, chip version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635 TT 1.2)
[    7.975701] Adding 2104508k swap on /dev/sda2.  Priority:-1 extents:1 across:2104508k SS
[    8.174156] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[    8.848970] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    8.904490] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    8.923283] ip_tables: (C) 2000-2006 Netfilter Core Team
[    9.457123] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    9.457143] EDD information not available.
[    9.955520] microcode: CPU0 sig=0x6fd, pf=0x20, revision=0xa3
[    9.966524] microcode: CPU1 sig=0x6fd, pf=0x20, revision=0xa3
[    9.975181] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   10.057010] microcode: CPU0 updated to revision 0xa4, date = 2010-10-02
[   10.059012] microcode: CPU1 updated to revision 0xa4, date = 2010-10-02
[   10.356530] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   10.356537] Bluetooth: BNEP filters: protocol multicast
[   10.511604] e1000e 0000:01:00.0: irq 43 for MSI/MSI-X
[   10.565214] e1000e 0000:01:00.0: irq 43 for MSI/MSI-X
[   10.566674] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   10.627619] Bluetooth: RFCOMM TTY layer initialized
[   10.627643] Bluetooth: RFCOMM socket layer initialized
[   10.627647] Bluetooth: RFCOMM ver 1.11
[   10.889856] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   11.022308] NET: Registered protocol family 17
[   16.697162] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   16.697923] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   32.736405] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[   32.736415] ata1.00: failed command: SMART
[   32.736425] ata1.00: cmd b0/d5:01:06:4f:c2/00:00:00:00:00/00 tag 0 pio 512 in
[   32.736427]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[   32.736433] ata1.00: status: { DRDY }
[   32.736443] ata1: hard resetting link
[   33.041184] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   33.041570] ata1.00: unexpected _GTF length (8)
[   33.042516] ata1.00: unexpected _GTF length (8)
[   33.042594] ata1.00: configured for UDMA/133
[   33.042656] ata1: EH complete
[   38.321049] martian source 255.255.255.255 from 192.168.100.254, on dev eth0
[   38.321059] ll header: ff:ff:ff:ff:ff:ff:00:1d:7e:aa:87:ee:08:00
[   39.337522] e1000e 0000:01:00.0: eth0: changing MTU from 1500 to 1492
[   42.156310] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   49.233211] EXT4-fs (sda5): re-mounted. Opts: acl,user_xattr,commit=0
[   49.242086] EXT4-fs (sda3): re-mounted. Opts: acl,user_xattr,commit=0
[   74.550477] wlan0: authenticate with 00:1d:7e:aa:87:ee (try 1)
[   74.552857] wlan0: authenticated
[   74.573378] wlan0: associate with 00:1d:7e:aa:87:ee (try 1)
[   74.576898] wlan0: RX AssocResp from 00:1d:7e:aa:87:ee (capab=0x411 status=0 aid=3)
[   74.576905] wlan0: associated
[   74.576992] wlan0: moving STA 00:1d:7e:aa:87:ee to state 1
[   74.576997] wlan0: moving STA 00:1d:7e:aa:87:ee to state 2
[   74.611249] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   75.389061] wlan0: moving STA 00:1d:7e:aa:87:ee to state 3
[   75.766578] martian source 255.255.255.255 from 192.168.100.254, on dev wlan0
[   75.766585] ll header: ff:ff:ff:ff:ff:ff:00:1d:7e:aa:87:ee:08:00
[   85.042179] wlan0: no IPv6 routers present
[   94.525695] wlan0: deauthenticating from 00:1d:7e:aa:87:ee by local choice (reason=3)
[   94.540452] wlan0: moving STA 00:1d:7e:aa:87:ee to state 2
[   94.540459] wlan0: moving STA 00:1d:7e:aa:87:ee to state 1
[   94.540464] wlan0: moving STA 00:1d:7e:aa:87:ee to state 0
[   94.550611] cfg80211: Calling CRDA to update world regulatory domain
[   94.567460] cfg80211: World regulatory domain updated:
[   94.567467] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   94.567473] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   94.567479] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   94.567485] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   94.567490] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   94.567495] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   95.343089] EXT4-fs (sda5): re-mounted. Opts: acl,user_xattr,commit=0
[   95.352220] EXT4-fs (sda3): re-mounted. Opts: acl,user_xattr,commit=0
[   95.550980] pcmcia_socket pcmcia_socket0: pccard: card ejected from slot 0
[   95.971467] PM: Syncing filesystems ... done.
[   95.986074] PM: Preparing system for mem sleep
[   96.078333] Freezing user space processes ... (elapsed 0.01 seconds) done.
[   96.091791] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[   96.103556] PM: Entering mem sleep
[   96.103606] Suspending console(s) (use no_console_suspend to debug)
[   96.107159] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   96.107548] sd 0:0:0:0: [sda] Stopping disk
[   96.108436] option: option_instat_callback: error -2
[   96.386200] tpm_inf_pnp 00:0a: saving TPM state
[   96.407630] tpm_inf_pnp 00:0a: Timeout while clearing FIFO
[   96.407634] tpm_inf_pnp 00:0a: error while saving TPM state
[   96.407646] legacy_suspend(): pnp_bus_suspend+0x0/0xa0 returns -5
[   96.407656] PM: Device 00:0a failed to suspend: error -5
[   96.407662] PM: Some devices failed to suspend
[   96.714083] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   96.714466] ata1.00: unexpected _GTF length (8)
[   96.714921] ata1.00: unexpected _GTF length (8)
[   96.715000] ata1.00: configured for UDMA/133
[   96.726694] sd 0:0:0:0: [sda] Starting disk
[   96.879523] PM: resume of devices complete after 471.853 msecs
[   96.881652] PM: Finishing wakeup.
[   96.881657] Restarting tasks ... done.
[   96.893143] video LNXVIDEO:00: Restoring backlight state
[   98.099876] EXT4-fs (sda5): re-mounted. Opts: acl,user_xattr,commit=0
[   98.108619] EXT4-fs (sda3): re-mounted. Opts: acl,user_xattr,commit=0
[   98.328116] e1000e 0000:01:00.0: irq 43 for MSI/MSI-X
[   98.379299] e1000e 0000:01:00.0: irq 43 for MSI/MSI-X
[   98.380319] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   98.664909] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  101.033115] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[  101.033843] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  101.193398] martian source 255.255.255.255 from 192.168.100.254, on dev eth0
[  101.193430] ll header: ff:ff:ff:ff:ff:ff:00:1d:7e:aa:87:ee:08:00

--Boundary-00=_amKFPSCt6Pob2iN--
