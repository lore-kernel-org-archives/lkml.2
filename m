Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab2BCFnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 00:43:41 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:40390 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab2BCFnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 00:43:35 -0500
Date: Fri, 3 Feb 2012 14:43:19 +0900
From: Norbert Preining <preining@logic.at>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, jeff@garzik.org,
        Tejun Heo <tj@kernel.org>,
        "stern@rowland.harvard.edu >> Alan Stern" <stern@rowland.harvard.edu>,
        linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression 3.2 -> 3.3-rc1 10 sec hang at boot and resume,
	COMRESET failed
Message-ID: <20120203054319.GA25510@gamma.logic.tuwien.ac.at>
References: <20120202051258.GA15550@gamma.logic.tuwien.ac.at> <4F2A4B7E.2090503@linux.vnet.ibm.com> <1328231716.15079.15.camel@minggr> <1328242884.15079.22.camel@minggr> <20120203052452.GC24563@gamma.logic.tuwien.ac.at> <1328247269.15079.26.camel@minggr>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <1328247269.15079.26.camel@minggr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fr, 03 Feb 2012, Lin Ming wrote:
> > I didn't try to revert that commit on top of HEAD.
> 
> Please revert that commit to test.
> That helps us to make sure we find the exact bad commit.

Confirmed. Reverted 7faa33da9b7 on top of 6c073a7ee250 made
the boot delay go away. dmesg from this boot attached.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
PELUTHO (n.) A South American ball game. The balls are whacked against
a brick wall with a stout wooden bat until the prisoner confesses.
			--- Douglas Adams, The Meaning of Liff

--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-3.3-rc2-revert"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.3.0-rc2+ (norbert@mithrandir) (gcc version 4.6.2 (Debian 4.6.2-12) ) #32 SMP PREEMPT Fri Feb 3 14:36:13 JST 2012
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.3.0-rc2+ root=/dev/sda3 ro rootfstype=ext4 "acpi_osi=!Windows 2006" nmi_watchdog=0
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000ba108000 (usable)
[    0.000000]  BIOS-e820: 00000000ba108000 - 00000000ba10b000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000ba10b000 - 00000000bba6b000 (usable)
[    0.000000]  BIOS-e820: 00000000bba6b000 - 00000000bbabf000 (reserved)
[    0.000000]  BIOS-e820: 00000000bbabf000 - 00000000bbb73000 (usable)
[    0.000000]  BIOS-e820: 00000000bbb73000 - 00000000bbbbf000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bbbbf000 - 00000000bbbe9000 (usable)
[    0.000000]  BIOS-e820: 00000000bbbe9000 - 00000000bbbff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bbbff000 - 00000000bbc00000 (usable)
[    0.000000]  BIOS-e820: 00000000bbc00000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe80000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Sony Corporation VGN-Z11VN_B/VAIO, BIOS R2168M3 03/23/2009
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x140000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0BC000000 mask FFC000000 uncachable
[    0.000000]   3 base 0BBC00000 mask FFFC00000 uncachable
[    0.000000]   4 base 100000000 mask FC0000000 write-back
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000bbc00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbbc00 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000bbc00000
[    0.000000]  0000000000 - 00bbc00000 page 2M
[    0.000000] kernel direct mapping tables up to bbc00000 @ 1fffc000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-0000000140000000
[    0.000000]  0100000000 - 0140000000 page 2M
[    0.000000] kernel direct mapping tables up to 140000000 @ bbbe3000-bbbe9000
[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02   Sony)
[    0.000000] ACPI: XSDT 00000000bbbfe120 0006C (v01   Sony     VAIO 20090323      01000013)
[    0.000000] ACPI: FACP 00000000bbbfd000 000F4 (v04   Sony     VAIO 20090323 MSFT 01000013)
[    0.000000] ACPI: DSDT 00000000bbbec000 0B012 (v01   Sony     VAIO 20090323 MSFT 01000013)
[    0.000000] ACPI: FACS 00000000bbb92000 00040
[    0.000000] ACPI: HPET 00000000bbbfc000 00038 (v01   Sony     VAIO 20090323 MSFT 01000013)
[    0.000000] ACPI: APIC 00000000bbbfb000 0006C (v01   Sony     VAIO 20090323 MSFT 01000013)
[    0.000000] ACPI: MCFG 00000000bbbfa000 0003C (v01   Sony     VAIO 20090323 MSFT 01000013)
[    0.000000] ACPI: SLIC 00000000bbbf9000 00176 (v01   Sony     VAIO 20090323 MSFT 01000013)
[    0.000000] ACPI: ASF! 00000000bbbf8000 000A5 (v32   Sony     VAIO 20090323 MSFT 01000013)
[    0.000000] ACPI: BOOT 00000000bbbeb000 00028 (v01   Sony     VAIO 20090323 MSFT 01000013)
[    0.000000] ACPI: DBGP 00000000bbbea000 00034 (v01   Sony     VAIO 20090323 MSFT 01000013)
[    0.000000] ACPI: SSDT 00000000bbbe9000 00655 (v01   Sony     VAIO 20090323 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff88013b600000-ffff88013edfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00140000
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000ba108
[    0.000000]     0: 0x000ba10b -> 0x000bba6b
[    0.000000]     0: 0x000bbabf -> 0x000bbb73
[    0.000000]     0: 0x000bbbbf -> 0x000bbbe9
[    0.000000]     0: 0x000bbbff -> 0x000bbc00
[    0.000000]     0: 0x00100000 -> 0x00140000
[    0.000000] On node 0 totalpages: 1030870
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3922 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 750463 pages, LIFO batch:31
[    0.000000]   Normal zone: 3584 pages used for memmap
[    0.000000]   Normal zone: 258560 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x00] disabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000ba108000 - 00000000ba10b000
[    0.000000] PM: Registered nosave memory: 00000000bba6b000 - 00000000bbabf000
[    0.000000] PM: Registered nosave memory: 00000000bbb73000 - 00000000bbbbf000
[    0.000000] PM: Registered nosave memory: 00000000bbbe9000 - 00000000bbbff000
[    0.000000] PM: Registered nosave memory: 00000000bbc00000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
[    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffe80000
[    0.000000] PM: Registered nosave memory: 00000000ffe80000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:38000000)
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88013fc00000 s76288 r8192 d22016 u524288
[    0.000000] pcpu-alloc: s76288 r8192 d22016 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1012945
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.3.0-rc2+ root=/dev/sda3 ro rootfstype=ext4 "acpi_osi=!Windows 2006" nmi_watchdog=0
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 3983528k/5242880k available (4467k kernel code, 1119400k absent, 139952k reserved, 4157k data, 492k init)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2527.124 MHz processor.
[    0.004004] Calibrating delay loop (skipped), value calculated using timer frequency.. 5054.24 BogoMIPS (lpj=10108496)
[    0.004110] pid_max: default: 32768 minimum: 301
[    0.004210] Mount-cache hash table entries: 256
[    0.004383] Initializing cgroup subsys debug
[    0.004461] CPU: Physical Processor ID: 0
[    0.004511] CPU: Processor Core ID: 0
[    0.004562] mce: CPU supports 6 MCE banks
[    0.004617] CPU0: Thermal monitoring handled by SMI
[    0.004621] using mwait in idle threads.
[    0.004704] ACPI: Core revision 20120111
[    0.016445] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.057082] CPU0: Intel(R) Core(TM)2 Duo CPU     P9500  @ 2.53GHz stepping 06
[    0.060003] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.060003] ... version:                2
[    0.060003] ... bit width:              40
[    0.060003] ... generic registers:      2
[    0.060003] ... value mask:             000000ffffffffff
[    0.060003] ... max period:             000000007fffffff
[    0.060003] ... fixed-purpose events:   3
[    0.060003] ... event mask:             0000000700000003
[    0.084020] Booting Node   0, Processors  #1
[    0.084096] smpboot cpu 1: start_ip = 9a000
[    0.008000] CPU1: Thermal monitoring handled by SMI
[    0.096024] Brought up 2 CPUs
[    0.096076] Total of 2 processors activated (10108.49 BogoMIPS).
[    0.100195] PM: Registering ACPI NVS region at ba108000 (12288 bytes)
[    0.100254] PM: Registering ACPI NVS region at bbb73000 (311296 bytes)
[    0.100434] NET: Registered protocol family 16
[    0.100506] ACPI: bus type pci registered
[    0.100506] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.100506] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.112011] PCI: Using configuration type 1 for base access
[    0.120039] bio: create slab <bio-0> at 0
[    0.120118] ACPI: Added _OSI(Module Device)
[    0.120118] ACPI: Added _OSI(Processor Device)
[    0.120124] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.120176] ACPI: Added _OSI(Processor Aggregator Device)
[    0.120229] ACPI: Deleted _OSI(Windows 2006)
[    0.120229] ACPI: EC: Look up EC in DSDT
[    0.121913] ACPI: Executed 1 blocks of module-level executable AML code
[    0.123484] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.136518] ACPI: SSDT 00000000bba6ec18 00265 (v01   Sony     VAIO 20090323 INTL 20051117)
[    0.137087] ACPI: Dynamic OEM Table Load:
[    0.137208] ACPI: SSDT           (null) 00265 (v01   Sony     VAIO 20090323 INTL 20051117)
[    0.137505] ACPI: SSDT 00000000bba6c618 005B8 (v01   Sony     VAIO 20090323 INTL 20051117)
[    0.138057] ACPI: Dynamic OEM Table Load:
[    0.138179] ACPI: SSDT           (null) 005B8 (v01   Sony     VAIO 20090323 INTL 20051117)
[    0.160305] ACPI: SSDT 00000000bba6de18 001CF (v01   Sony     VAIO 20090323 INTL 20051117)
[    0.160892] ACPI: Dynamic OEM Table Load:
[    0.161013] ACPI: SSDT           (null) 001CF (v01   Sony     VAIO 20090323 INTL 20051117)
[    0.172142] ACPI: SSDT 00000000bba6ef18 0008D (v01   Sony     VAIO 20090323 INTL 20051117)
[    0.176185] ACPI: Dynamic OEM Table Load:
[    0.176307] ACPI: SSDT           (null) 0008D (v01   Sony     VAIO 20090323 INTL 20051117)
[    0.392061] ACPI: Interpreter enabled
[    0.392116] ACPI: (supports S0 S3 S4 S5)
[    0.392333] ACPI: Using IOAPIC for interrupt routing
[    0.396525] ACPI: Power Resource [MGPR] (on)
[    0.396525] ACPI: Power Resource [DGPR] (on)
[    0.404325] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.404910] ACPI: ACPI Dock Station Driver: 1 docks/bays found
[    0.404966] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.405399] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.408626] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.408682] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.408736] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.408803] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfebfffff]
[    0.408869] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff]
[    0.408973] PCI host bridge to bus 0000:00
[    0.408973] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.408973] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.408973] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.408973] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfebfffff]
[    0.408973] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
[    0.408973] pci 0000:00:00.0: [8086:2a40] type 0 class 0x000600
[    0.408973] DMAR: Forcing write-buffer flush capability
[    0.408973] DMAR: Disabling IOMMU for graphics on this chipset
[    0.408973] pci 0000:00:02.0: [8086:2a42] type 0 class 0x000300
[    0.408973] pci 0000:00:02.0: reg 10: [mem 0xd4400000-0xd47fffff 64bit]
[    0.408973] pci 0000:00:02.0: reg 18: [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.408973] pci 0000:00:02.0: reg 20: [io  0x7130-0x7137]
[    0.408973] pci 0000:00:02.1: [8086:2a43] type 0 class 0x000380
[    0.408973] pci 0000:00:02.1: reg 10: [mem 0xd7800000-0xd78fffff 64bit]
[    0.408973] pci 0000:00:19.0: [8086:10f5] type 0 class 0x000200
[    0.408973] pci 0000:00:19.0: reg 10: [mem 0xdaa00000-0xdaa1ffff]
[    0.408973] pci 0000:00:19.0: reg 14: [mem 0xdaa24000-0xdaa24fff]
[    0.408973] pci 0000:00:19.0: reg 18: [io  0x7100-0x711f]
[    0.408973] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.408973] pci 0000:00:1a.0: [8086:2937] type 0 class 0x000c03
[    0.408973] pci 0000:00:1a.0: reg 20: [io  0x70e0-0x70ff]
[    0.408973] pci 0000:00:1a.1: [8086:2938] type 0 class 0x000c03
[    0.408973] pci 0000:00:1a.1: reg 20: [io  0x70c0-0x70df]
[    0.409021] pci 0000:00:1a.2: [8086:2939] type 0 class 0x000c03
[    0.409083] pci 0000:00:1a.2: reg 20: [io  0x70a0-0x70bf]
[    0.409162] pci 0000:00:1a.7: [8086:293c] type 0 class 0x000c03
[    0.413904] pci 0000:00:1a.7: reg 10: [mem 0xdaa25c00-0xdaa25fff]
[    0.436089] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.436118] pci 0000:00:1b.0: [8086:293e] type 0 class 0x000403
[    0.436135] pci 0000:00:1b.0: reg 10: [mem 0xdaa20000-0xdaa23fff 64bit]
[    0.436210] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.436233] pci 0000:00:1c.0: [8086:2940] type 1 class 0x000604
[    0.436310] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.436333] pci 0000:00:1c.1: [8086:2942] type 1 class 0x000604
[    0.436409] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.436434] pci 0000:00:1c.3: [8086:2946] type 1 class 0x000604
[    0.436510] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.436540] pci 0000:00:1d.0: [8086:2934] type 0 class 0x000c03
[    0.436602] pci 0000:00:1d.0: reg 20: [io  0x7080-0x709f]
[    0.436675] pci 0000:00:1d.1: [8086:2935] type 0 class 0x000c03
[    0.436737] pci 0000:00:1d.1: reg 20: [io  0x7060-0x707f]
[    0.436809] pci 0000:00:1d.2: [8086:2936] type 0 class 0x000c03
[    0.436870] pci 0000:00:1d.2: reg 20: [io  0x7040-0x705f]
[    0.436947] pci 0000:00:1d.7: [8086:293a] type 0 class 0x000c03
[    0.441920] pci 0000:00:1d.7: reg 10: [mem 0xdaa25800-0xdaa25bff]
[    0.464075] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.464098] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.464167] pci 0000:00:1f.0: [8086:2917] type 0 class 0x000601
[    0.464295] pci 0000:00:1f.2: [8086:2929] type 0 class 0x000106
[    0.464315] pci 0000:00:1f.2: reg 10: [io  0x7128-0x712f]
[    0.464324] pci 0000:00:1f.2: reg 14: [io  0x713c-0x713f]
[    0.464333] pci 0000:00:1f.2: reg 18: [io  0x7120-0x7127]
[    0.464342] pci 0000:00:1f.2: reg 1c: [io  0x7138-0x713b]
[    0.464350] pci 0000:00:1f.2: reg 20: [io  0x7020-0x703f]
[    0.464359] pci 0000:00:1f.2: reg 24: [mem 0xdaa25000-0xdaa257ff]
[    0.464409] pci 0000:00:1f.2: PME# supported from D3hot
[    0.464429] pci 0000:00:1f.3: [8086:2930] type 0 class 0x000c05
[    0.464446] pci 0000:00:1f.3: reg 10: [mem 0xdaa26000-0xdaa260ff 64bit]
[    0.464470] pci 0000:00:1f.3: reg 20: [io  0x7000-0x701f]
[    0.464540] pci 0000:00:1c.0: PCI bridge to [bus 02-05]
[    0.464596] pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
[    0.464600] pci 0000:00:1c.0:   bridge window [mem 0xd9a00000-0xda9fffff]
[    0.464606] pci 0000:00:1c.0:   bridge window [mem 0xd4800000-0xd57fffff 64bit pref]
[    0.464702] pci 0000:06:00.0: [8086:4232] type 0 class 0x000280
[    0.464740] pci 0000:06:00.0: reg 10: [mem 0xd8900000-0xd8901fff 64bit]
[    0.464914] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    0.472069] pci 0000:00:1c.1: PCI bridge to [bus 06-06]
[    0.472124] pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
[    0.472129] pci 0000:00:1c.1:   bridge window [mem 0xd8900000-0xd99fffff]
[    0.472135] pci 0000:00:1c.1:   bridge window [mem 0xd5800000-0xd67fffff 64bit pref]
[    0.472177] pci 0000:00:1c.3: PCI bridge to [bus 08-08]
[    0.472232] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.472236] pci 0000:00:1c.3:   bridge window [mem 0xd7900000-0xd88fffff]
[    0.472242] pci 0000:00:1c.3:   bridge window [mem 0xd6800000-0xd77fffff 64bit pref]
[    0.472283] pci 0000:0b:04.0: [1180:0476] type 2 class 0x000607
[    0.472303] pci 0000:0b:04.0: reg 10: [mem 0xd4000000-0xd4000fff]
[    0.472334] pci 0000:0b:04.0: supports D1 D2
[    0.472336] pci 0000:0b:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.472358] pci 0000:0b:04.1: [1180:0832] type 0 class 0x000c00
[    0.472378] pci 0000:0b:04.1: reg 10: [mem 0xd4001000-0xd40017ff]
[    0.472466] pci 0000:0b:04.1: PME# supported from D0 D3hot D3cold
[    0.472489] pci 0000:0b:04.2: [1180:0822] type 0 class 0x000805
[    0.472508] pci 0000:0b:04.2: reg 10: [mem 0xd4001900-0xd40019ff]
[    0.472595] pci 0000:0b:04.2: supports D1 D2
[    0.472597] pci 0000:0b:04.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.472620] pci 0000:0b:04.4: [1180:0592] type 0 class 0x000880
[    0.472639] pci 0000:0b:04.4: reg 10: [mem 0xd4001800-0xd40018ff]
[    0.472728] pci 0000:0b:04.4: supports D1 D2
[    0.472730] pci 0000:0b:04.4: PME# supported from D0 D1 D2 D3hot D3cold
[    0.472784] pci 0000:00:1e.0: PCI bridge to [bus 0b-0c] (subtractive decode)
[    0.472842] pci 0000:00:1e.0:   bridge window [io  0x3000-0x3fff]
[    0.472846] pci 0000:00:1e.0:   bridge window [mem 0xd2000000-0xd40fffff]
[    0.472852] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd1ffffff 64bit pref]
[    0.472855] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.472857] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.472860] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.472862] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
[    0.472865] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
[    0.472905] pci_bus 0000:0c: [bus 0c-0f] partially hidden behind transparent bridge 0000:0b [bus 0b-0c]
[    0.472992] pci_bus 0000:00: on NUMA node 0
[    0.472995] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.473173] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
[    0.473257] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.473321] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    0.473360] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.473462]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.473569]  pci0000:00: ACPI _OSC request failed (AE_SUPPORT), returned control mask: 0x00
[    0.473636] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.480393] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 *10 11 12)
[    0.480551] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
[    0.481007] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 *10 11 12)
[    0.481460] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 *10 11 12)
[    0.481916] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 *10 11 12)
[    0.482370] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 *10 11 12)
[    0.484410] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 *10 11 12)
[    0.484864] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 *10 11 12)
[    0.485299] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.485299] vgaarb: loaded
[    0.485299] vgaarb: bridge control possible 0000:00:02.0
[    0.485299] SCSI subsystem initialized
[    0.485299] libata version 3.00 loaded.
[    0.485299] usbcore: registered new interface driver usbfs
[    0.485299] usbcore: registered new interface driver hub
[    0.485299] usbcore: registered new device driver usb
[    0.485299] wmi: Mapper loaded
[    0.485299] PCI: Using ACPI for IRQ routing
[    0.485566] PCI: pci_cache_line_size set to 64 bytes
[    0.485708] reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
[    0.485711] reserve RAM buffer: 00000000ba108000 - 00000000bbffffff 
[    0.485715] reserve RAM buffer: 00000000bba6b000 - 00000000bbffffff 
[    0.485718] reserve RAM buffer: 00000000bbb73000 - 00000000bbffffff 
[    0.485721] reserve RAM buffer: 00000000bbbe9000 - 00000000bbffffff 
[    0.485724] reserve RAM buffer: 00000000bbc00000 - 00000000bbffffff 
[    0.488087] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.488117] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.488344] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.496048] Switching to clocksource hpet
[    0.499007] pnp: PnP ACPI init
[    0.499070] ACPI: bus type pnp registered
[    0.499868] pnp 00:00: [bus 00-ff]
[    0.499871] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.499873] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.499875] pnp 00:00: [io  0x0d00-0xffff window]
[    0.499877] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.499879] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.499881] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.499884] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.499886] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.499888] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.499890] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.499892] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.499894] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.499896] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.499899] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.499901] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.499903] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.499905] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.499907] pnp 00:00: [mem 0xc0000000-0xfebfffff window]
[    0.499909] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.499995] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.500451] pnp 00:01: [io  0x002e-0x002f]
[    0.500454] pnp 00:01: [io  0x004e-0x004f]
[    0.500456] pnp 00:01: [io  0x164e-0x164f]
[    0.500458] pnp 00:01: [io  0x0061]
[    0.500460] pnp 00:01: [io  0x0070]
[    0.500461] pnp 00:01: [io  0x0080]
[    0.500463] pnp 00:01: [io  0x0092]
[    0.500466] pnp 00:01: [io  0x00b2-0x00b3]
[    0.500468] pnp 00:01: [io  0x0063]
[    0.500470] pnp 00:01: [io  0x0065]
[    0.500471] pnp 00:01: [io  0x0067]
[    0.500473] pnp 00:01: [io  0x0600-0x060f]
[    0.500475] pnp 00:01: [io  0x0610]
[    0.500477] pnp 00:01: [io  0x0800-0x080f]
[    0.500479] pnp 00:01: [io  0x0810-0x0817]
[    0.500481] pnp 00:01: [io  0x0820-0x0823]
[    0.500482] pnp 00:01: [io  0x0400-0x047f]
[    0.500484] pnp 00:01: [io  0x0500-0x053f]
[    0.500486] pnp 00:01: [io  0x2000]
[    0.500488] pnp 00:01: [io  0x2004]
[    0.500490] pnp 00:01: [mem 0xf8000000-0xfbffffff]
[    0.500492] pnp 00:01: [mem 0xfed1c000-0xfed1ffff]
[    0.500494] pnp 00:01: [mem 0xfed10000-0xfed13fff]
[    0.500496] pnp 00:01: [mem 0xfed18000-0xfed18fff]
[    0.500498] pnp 00:01: [mem 0xfed19000-0xfed19fff]
[    0.500500] pnp 00:01: [mem 0xfec00000-0xfec00fff]
[    0.500502] pnp 00:01: [mem 0xfed20000-0xfed3ffff]
[    0.500504] pnp 00:01: [mem 0xfed45000-0xfed8ffff]
[    0.500506] pnp 00:01: [mem 0xfee00000-0xfee00fff]
[    0.500619] system 00:01: [io  0x164e-0x164f] has been reserved
[    0.500674] system 00:01: [io  0x0600-0x060f] has been reserved
[    0.500729] system 00:01: [io  0x0610] has been reserved
[    0.500782] system 00:01: [io  0x0800-0x080f] has been reserved
[    0.500836] system 00:01: [io  0x0810-0x0817] has been reserved
[    0.500890] system 00:01: [io  0x0820-0x0823] has been reserved
[    0.500944] system 00:01: [io  0x0400-0x047f] has been reserved
[    0.500999] system 00:01: [io  0x0500-0x053f] has been reserved
[    0.501053] system 00:01: [io  0x2000] has been reserved
[    0.501106] system 00:01: [io  0x2004] has been reserved
[    0.501161] system 00:01: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.501216] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.501271] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.501327] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.501382] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.501438] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.501494] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.501549] system 00:01: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.501604] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.501660] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.501671] pnp 00:02: [io  0x0000-0x001f]
[    0.501673] pnp 00:02: [io  0x0081-0x0091]
[    0.501675] pnp 00:02: [io  0x0093-0x009f]
[    0.501677] pnp 00:02: [io  0x00c0-0x00df]
[    0.501679] pnp 00:02: [dma 4]
[    0.501738] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.501757] pnp 00:03: [io  0x0070-0x0077]
[    0.501765] pnp 00:03: [irq 8]
[    0.501824] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.501890] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.501950] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.501962] pnp 00:05: [io  0x00f0]
[    0.501968] pnp 00:05: [irq 13]
[    0.502027] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.502039] pnp 00:06: [mem 0xff800000-0xffffffff]
[    0.502098] pnp 00:06: Plug and Play ACPI device, IDs INT0800 (active)
[    0.502119] pnp 00:07: [io  0x0060]
[    0.502121] pnp 00:07: [io  0x0064]
[    0.502126] pnp 00:07: [irq 1]
[    0.502185] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.502206] pnp 00:08: [irq 12]
[    0.502267] pnp 00:08: Plug and Play ACPI device, IDs SNY9001 PNP0f13 (active)
[    0.502372] pnp 00:09: Plug and Play ACPI device, IDs SNY6001 (disabled)
[    0.502397] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    0.502457] pnp 00:0a: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
[    0.502548] pnp: PnP ACPI: found 11 devices
[    0.502599] ACPI: ACPI bus type pnp unregistered
[    0.510532] PCI: max bus depth: 2 pci_try_num: 3
[    0.510568] pci 0000:00:1c.0: PCI bridge to [bus 02-05]
[    0.510622] pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
[    0.510680] pci 0000:00:1c.0:   bridge window [mem 0xd9a00000-0xda9fffff]
[    0.510737] pci 0000:00:1c.0:   bridge window [mem 0xd4800000-0xd57fffff 64bit pref]
[    0.510807] pci 0000:00:1c.1: PCI bridge to [bus 06-06]
[    0.510861] pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
[    0.510918] pci 0000:00:1c.1:   bridge window [mem 0xd8900000-0xd99fffff]
[    0.510975] pci 0000:00:1c.1:   bridge window [mem 0xd5800000-0xd67fffff 64bit pref]
[    0.511045] pci 0000:00:1c.3: PCI bridge to [bus 08-08]
[    0.511098] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.511156] pci 0000:00:1c.3:   bridge window [mem 0xd7900000-0xd88fffff]
[    0.511213] pci 0000:00:1c.3:   bridge window [mem 0xd6800000-0xd77fffff 64bit pref]
[    0.511287] pci 0000:0b:04.0: BAR 10: assigned [mem 0xdc000000-0xdfffffff]
[    0.511344] pci 0000:0b:04.0: BAR 9: assigned [mem 0xe0000000-0xe3ffffff pref]
[    0.511410] pci 0000:0b:04.0: BAR 8: assigned [io  0x3000-0x30ff]
[    0.511464] pci 0000:0b:04.0: BAR 7: assigned [io  0x3400-0x34ff]
[    0.511518] pci 0000:0b:04.0: CardBus bridge to [bus 0c-0f]
[    0.511571] pci 0000:0b:04.0:   bridge window [io  0x3400-0x34ff]
[    0.511627] pci 0000:0b:04.0:   bridge window [io  0x3000-0x30ff]
[    0.511684] pci 0000:0b:04.0:   bridge window [mem 0xe0000000-0xe3ffffff pref]
[    0.511752] pci 0000:0b:04.0:   bridge window [mem 0xdc000000-0xdfffffff]
[    0.511810] pci 0000:00:1e.0: PCI bridge to [bus 0b-0c]
[    0.511864] pci 0000:00:1e.0:   bridge window [io  0x3000-0x3fff]
[    0.511921] pci 0000:00:1e.0:   bridge window [mem 0xd2000000-0xd40fffff]
[    0.511978] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd1ffffff 64bit pref]
[    0.512063] pci 0000:00:1c.0: enabling device (0000 -> 0003)
[    0.512136] pci 0000:00:1c.3: enabling device (0000 -> 0003)
[    0.512199] pci 0000:00:1e.0: setting latency timer to 64
[    0.512214] pci 0000:0b:04.0: setting latency timer to 64
[    0.512218] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.512220] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.512222] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.512225] pci_bus 0000:00: resource 7 [mem 0xc0000000-0xfebfffff]
[    0.512227] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
[    0.512229] pci_bus 0000:02: resource 0 [io  0x6000-0x6fff]
[    0.512231] pci_bus 0000:02: resource 1 [mem 0xd9a00000-0xda9fffff]
[    0.512234] pci_bus 0000:02: resource 2 [mem 0xd4800000-0xd57fffff 64bit pref]
[    0.512236] pci_bus 0000:06: resource 0 [io  0x5000-0x5fff]
[    0.512238] pci_bus 0000:06: resource 1 [mem 0xd8900000-0xd99fffff]
[    0.512241] pci_bus 0000:06: resource 2 [mem 0xd5800000-0xd67fffff 64bit pref]
[    0.512243] pci_bus 0000:08: resource 0 [io  0x4000-0x4fff]
[    0.512245] pci_bus 0000:08: resource 1 [mem 0xd7900000-0xd88fffff]
[    0.512247] pci_bus 0000:08: resource 2 [mem 0xd6800000-0xd77fffff 64bit pref]
[    0.512250] pci_bus 0000:0b: resource 0 [io  0x3000-0x3fff]
[    0.512252] pci_bus 0000:0b: resource 1 [mem 0xd2000000-0xd40fffff]
[    0.512254] pci_bus 0000:0b: resource 2 [mem 0xd0000000-0xd1ffffff 64bit pref]
[    0.512257] pci_bus 0000:0b: resource 4 [io  0x0000-0x0cf7]
[    0.512259] pci_bus 0000:0b: resource 5 [io  0x0d00-0xffff]
[    0.512261] pci_bus 0000:0b: resource 6 [mem 0x000a0000-0x000bffff]
[    0.512263] pci_bus 0000:0b: resource 7 [mem 0xc0000000-0xfebfffff]
[    0.512265] pci_bus 0000:0b: resource 8 [mem 0xfed40000-0xfed44fff]
[    0.512268] pci_bus 0000:0c: resource 0 [io  0x3400-0x34ff]
[    0.512270] pci_bus 0000:0c: resource 1 [io  0x3000-0x30ff]
[    0.512272] pci_bus 0000:0c: resource 2 [mem 0xe0000000-0xe3ffffff pref]
[    0.512274] pci_bus 0000:0c: resource 3 [mem 0xdc000000-0xdfffffff]
[    0.512326] NET: Registered protocol family 2
[    0.512443] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.512955] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.514571] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.515056] TCP: Hash tables configured (established 262144 bind 65536)
[    0.515110] TCP reno registered
[    0.515161] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.515245] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.515409] NET: Registered protocol family 1
[    0.515481] pci 0000:00:02.0: Boot video device
[    0.548066] PCI: CLS 64 bytes, default 64
[    0.548118] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.548175] Placing 64MB software IO TLB between ffff8800b6108000 - ffff8800ba108000
[    0.548243] software IO TLB at phys 0xb6108000 - 0xba108000
[    0.548304] Simple Boot Flag value 0x5 read from CMOS RAM was invalid
[    0.548360] Simple Boot Flag at 0x44 set to 0x1
[    0.549068] microcode: CPU0 sig=0x10676, pf=0x80, revision=0x60c
[    0.549130] microcode: CPU1 sig=0x10676, pf=0x80, revision=0x60c
[    0.549232] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.549563] audit: initializing netlink socket (disabled)
[    0.549629] type=2000 audit(1328279861.544:1): initialized
[    0.550617] NTFS driver 2.1.30 [Flags: R/O].
[    0.550705] msgmni has been set to 7780
[    0.550948] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.551016] io scheduler noop registered
[    0.551068] io scheduler deadline registered
[    0.551134] io scheduler cfq registered (default)
[    0.551337] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.551479] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    0.551623] pcieport 0000:00:1c.3: irq 42 for MSI/MSI-X
[    0.552110] intel_idle: MWAIT substates: 0x3122220
[    0.552112] intel_idle: does not run on family 6 model 23
[    0.553236] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.553584] ACPI: AC Adapter [AC] (on-line)
[    0.554333] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.554405] ACPI: Power Button [PWRB]
[    0.554532] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    0.554833] ACPI: Lid Switch [LID0]
[    0.555135] Monitor-Mwait will be used to enter C-1 state
[    0.555159] Monitor-Mwait will be used to enter C-2 state
[    0.555166] Marking TSC unstable due to TSC halts in idle
[    0.555226] ACPI: acpi_idle registered with cpuidle
[    0.558858] thermal LNXTHERM:00: registered as thermal_zone0
[    0.558913] ACPI: Thermal Zone [ATF0] (68 C)
[    0.563041] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.563117] ACPI: Battery Slot [BAT0] (battery present)
[    0.563301] Non-volatile memory driver v1.3
[    0.563463] Linux agpgart interface v0.103
[    0.563667] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[    0.563829] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    0.565912] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
[    0.566120] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    0.566349] tpm_tis 00:0a: 1.2 TPM (device-id 0xB, rev-id 16)
[    1.236070] tpm_tis 00:0a: Adjusting TPM timeout parameters.
[    2.028038] tpm_tis 00:0a: A TPM error (7) occurred attempting to read a pcr value
[    2.028152] tpm_tis 00:0a: TPM is disabled/deactivated (0x7)
[    2.028298] [drm] Initialized drm 1.1.0 20060810
[    2.028371] i915 0000:00:02.0: power state changed by ACPI to D0
[    2.028428] i915 0000:00:02.0: power state changed by ACPI to D0
[    2.028489] i915 0000:00:02.0: setting latency timer to 64
[    2.080257] i915 0000:00:02.0: irq 43 for MSI/MSI-X
[    2.080268] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    2.080326] [drm] Driver supports precise vblank timestamp query.
[    2.080447] [drm:intel_dsm_pci_probe] *ERROR* failed to get supported _DSM functions
[    2.080534] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    2.685814] fbcon: inteldrmfb (fb0) is primary device
[    2.687365] [drm] Changing LVDS panel from (+hsync, +vsync) to (-hsync, -vsync)
[    3.261579] Console: switching to colour frame buffer device 200x56
[    3.266060] fb0: inteldrmfb frame buffer device
[    3.266062] drm: registered panic notifier
[    3.301559] acpi device:01: registered as cooling_device2
[    3.301725] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input2
[    3.301781] ACPI: Video Device [OVGA] (multi-head: yes  rom: no  post: no)
[    3.301898] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    3.304036] brd: module loaded
[    3.304257] ahci 0000:00:1f.2: version 3.0
[    3.304312] ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
[    3.304352] ahci: SSS flag set, parallel bus scan disabled
[    3.304417] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x33 impl SATA mode
[    3.304465] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc ems 
[    3.304516] ahci 0000:00:1f.2: setting latency timer to 64
[    3.329076] scsi0 : ahci
[    3.329242] scsi1 : ahci
[    3.329391] scsi2 : ahci
[    3.329533] scsi3 : ahci
[    3.329672] scsi4 : ahci
[    3.329810] scsi5 : ahci
[    3.330271] ata1: SATA max UDMA/133 abar m2048@0xdaa25000 port 0xdaa25100 irq 44
[    3.330317] ata2: SATA max UDMA/133 abar m2048@0xdaa25000 port 0xdaa25180 irq 44
[    3.330360] ata3: DUMMY
[    3.330376] ata4: DUMMY
[    3.330394] ata5: SATA max UDMA/133 abar m2048@0xdaa25000 port 0xdaa25300 irq 44
[    3.330438] ata6: SATA max UDMA/133 abar m2048@0xdaa25000 port 0xdaa25380 irq 44
[    3.330619] e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
[    3.330655] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    3.330713] e1000e 0000:00:19.0: setting latency timer to 64
[    3.330817] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[    3.520123] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:1a:80:d7:59:37
[    3.521428] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    3.522719] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: FFFFFF-0FF
[    3.524056] igbvf: Intel(R) Gigabit Virtual Function Network Driver - version 2.0.1-k
[    3.525351] igbvf: Copyright (c) 2009 - 2011 Intel Corporation.
[    3.526706] yenta_cardbus 0000:0b:04.0: CardBus bridge found [104d:9025]
[    3.648023] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.650341] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    3.651802] ata1.00: ATA-8: WDC WD10JPVT-00A1YT0, 01.01A01, max UDMA/133
[    3.653113] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    3.655471] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    3.656958] ata1.00: configured for UDMA/133
[    3.658391] scsi 0:0:0:0: Direct-Access     ATA      WDC WD10JPVT-00A 01.0 PQ: 0 ANSI: 5
[    3.659976] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.661403] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    3.662826] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.662857] sd 0:0:0:0: [sda] Write Protect is off
[    3.662859] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.662879] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.669285]  sda: sda1 sda2 sda3 sda4
[    3.671054] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.984022] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.987700] ata2.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    3.989109] ata2.00: ATAPI: MATSHITADVD-RAM UJ862AS, 1.21, max UDMA/33
[    3.993158] ata2.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    3.994625] ata2.00: configured for UDMA/33
[    3.999962] scsi 1:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ862AS  1.21 PQ: 0 ANSI: 5
[    4.003415] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    4.004909] cdrom: Uniform CD-ROM driver Revision: 3.20
[    4.006524] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    4.006621] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    4.328021] ata5: SATA link down (SStatus 0 SControl 300)
[    4.648020] ata6: SATA link down (SStatus 0 SControl 300)
[    4.776804] yenta_cardbus 0000:0b:04.0: ISA IRQ mask 0x00b8, PCI irq 20
[    4.778248] yenta_cardbus 0000:0b:04.0: Socket status: 30000006

--mYCpIKhGyMATD0i+--
