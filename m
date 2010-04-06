Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab0DFWyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 18:54:32 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:46924 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493Ab0DFWy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 18:54:26 -0400
Date: Tue, 6 Apr 2010 15:54:25 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: linux-kernel@vger.kernel.org
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Matthew Wilcox <willy@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>
Subject: [2.6.34-rc1 REGRESSION] ahci 0000:00:1f.2: controller reset failed
	(0xffffffff)
Message-ID: <20100406225425.GA8292@hexapodia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This Dell Precision WorkStation T3400 doesn't boot 2.6.34-rc1 (tried
522dba71).  2.6.33 was fine, and it's been running various stable
kernels for the last 18 months.  Unfortunately I can't reasonably bisect
as I need this machine to be usable, but I can test specific patches or
options.  (three or four reboots is fine, 15 is not.)

full dmesg from failing boot and a successful boot at
http://web.hexapodia.org/~adi/tmp/20100406-pci-ahci-reset-fail/

I suspect it's due to:

[    3.094038] pci 0000:00:1f.2: no compatible bridge window for [mem 0xff970000-0xff9707ff]
[    3.103001] pci 0000:00:1f.2: can't reserve [mem 0xff970000-0xff9707ff]

so I've CCed a few recent committers to setup-res.c.

dmesg up to point of failure:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.34-rc1-00005-g522dba7 (andy@farthing) (gcc version 4.3.3 (Debian 4.3.3-5) ) #4 SMP Tue Apr 6 12:20:02 PDT 2010
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.34-rc1-00005-g522dba7 root=UUID=a2359eda-9295-451c-924f-c181c6f49d0d ro console=tty1 console=ttyS0,115200
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bfe01c00 (usable)
[    0.000000]  BIOS-e820: 00000000bfe01c00 - 00000000bfe53c00 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfe53c00 - 00000000bfe55c00 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfe55c00 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000feda0000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 00000001bc000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.5 present.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x1bc000 max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xbfe01 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000fe710] fe710
[    0.000000] init_memory_mapping: 0000000000000000-00000000bfe01000
[    0.000000] init_memory_mapping: 0000000100000000-00000001bc000000
[    0.000000] RAMDISK: 37c8e000 - 37fef049
[    0.000000] ACPI: RSDP 00000000000febf0 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000000fcea4 0006C (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: FACP 00000000000fcfcc 000F4 (v03 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: DSDT 00000000fff5aafd 03794 (v01   DELL    dt_ex 00001000 INTL 20050624)
[    0.000000] ACPI: FACS 00000000bfe01c00 00040
[    0.000000] ACPI: SSDT 00000000fff5e291 00099 (v01   DELL    st_ex 00001000 INTL 20050624)
[    0.000000] ACPI: APIC 00000000000fd0c0 00092 (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: BOOT 00000000000fd152 00028 (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: ASF! 00000000000fd17a 00096 (v32 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: MCFG 00000000000fd210 0003E (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: HPET 00000000000fd24e 00038 (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: TCPA 00000000000fd4aa 00032 (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: SLIC 00000000000fd286 00176 (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-00000001bc000000
[    0.000000] Initmem setup node 0 0000000000000000-00000001bc000000
[    0.000000]   NODE_DATA [0000000100000000 - 0000000100004fff]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x001bc000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bfe01
[    0.000000]     0: 0x00100000 -> 0x001bc000
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bfe01000 - 00000000bfe02000
[    0.000000] PM: Registered nosave memory: 00000000bfe02000 - 00000000bfe53000
[    0.000000] PM: Registered nosave memory: 00000000bfe53000 - 00000000bfe54000
[    0.000000] PM: Registered nosave memory: 00000000bfe54000 - 00000000bfe55000
[    0.000000] PM: Registered nosave memory: 00000000bfe55000 - 00000000bfe56000
[    0.000000] PM: Registered nosave memory: 00000000bfe56000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000feda0000
[    0.000000] PM: Registered nosave memory: 00000000feda0000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fef00000
[    0.000000] PM: Registered nosave memory: 00000000fef00000 - 00000000ffb00000
[    0.000000] PM: Registered nosave memory: 00000000ffb00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880001e00000 s81704 r8192 d20696 u262144
[    0.000000] pcpu-alloc: s81704 r8192 d20696 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1531006
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.34-rc1-00005-g522dba7 root=UUID=a2359eda-9295-451c-924f-c181c6f49d0d ro console=tty1 console=ttyS0,115200
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Subtract (62 early reservations)
[    0.000000]   #1 [0001000000 - 0001dafd28]   TEXT DATA BSS
[    0.000000]   #2 [0037c8e000 - 0037fef049]         RAMDISK
[    0.000000]   #3 [0001db0000 - 0001db01a8]             BRK
[    0.000000]   #4 [00000fe720 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000fe710 - 00000fe720]    MP-table mpf
[    0.000000]   #6 [000009ec00 - 00000f0000]   BIOS reserved
[    0.000000]   #7 [00000f0304 - 00000fe710]   BIOS reserved
[    0.000000]   #8 [00000f0000 - 00000f0304]    MP-table mpc
[    0.000000]   #9 [0000001000 - 0000003000]      TRAMPOLINE
[    0.000000]   #10 [0000003000 - 0000007000]     ACPI WAKEUP
[    0.000000]   #11 [0000008000 - 000000b000]         PGTABLE
[    0.000000]   #12 [000000b000 - 000000e000]         PGTABLE
[    0.000000]   #13 [0100000000 - 0100005000]       NODE_DATA
[    0.000000]   #14 [0001db01c0 - 0001db11c0]         BOOTMEM
[    0.000000]   #15 [00021b11c0 - 00021b1640]         BOOTMEM
[    0.000000]   #16 [0100005000 - 0100006000]         BOOTMEM
[    0.000000]   #17 [0100006000 - 0100007000]         BOOTMEM
[    0.000000]   #18 [0100200000 - 0105600000]        MEMMAP 0
[    0.000000]   #19 [0001dafd40 - 0001dafec0]         BOOTMEM
[    0.000000]   #20 [0001db11c0 - 0001dc91c0]         BOOTMEM
[    0.000000]   #21 [0001dc91c0 - 0001de11c0]         BOOTMEM
[    0.000000]   #22 [0001de2000 - 0001de3000]         BOOTMEM
[    0.000000]   #23 [0001dafec0 - 0001daff01]         BOOTMEM
[    0.000000]   #24 [0001daff40 - 0001daff83]         BOOTMEM
[    0.000000]   #25 [0001de11c0 - 0001de1498]         BOOTMEM
[    0.000000]   #26 [0001de14c0 - 0001de1528]         BOOTMEM
[    0.000000]   #27 [0001de1540 - 0001de15a8]         BOOTMEM
[    0.000000]   #28 [0001de15c0 - 0001de1628]         BOOTMEM
[    0.000000]   #29 [0001de1640 - 0001de16a8]         BOOTMEM
[    0.000000]   #30 [0001de16c0 - 0001de1728]         BOOTMEM
[    0.000000]   #31 [0001de1740 - 0001de17a8]         BOOTMEM
[    0.000000]   #32 [0001de17c0 - 0001de1828]         BOOTMEM
[    0.000000]   #33 [0001de1840 - 0001de18a8]         BOOTMEM
[    0.000000]   #34 [0001de18c0 - 0001de1928]         BOOTMEM
[    0.000000]   #35 [0001de1940 - 0001de19a8]         BOOTMEM
[    0.000000]   #36 [0001de19c0 - 0001de1a28]         BOOTMEM
[    0.000000]   #37 [0001de1a40 - 0001de1aa8]         BOOTMEM
[    0.000000]   #38 [0001daffc0 - 0001daffe0]         BOOTMEM
[    0.000000]   #39 [0001de1ac0 - 0001de1ae0]         BOOTMEM
[    0.000000]   #40 [0001de1b00 - 0001de1b82]         BOOTMEM
[    0.000000]   #41 [0001de1bc0 - 0001de1c42]         BOOTMEM
[    0.000000]   #42 [0001e00000 - 0001e1b000]         BOOTMEM
[    0.000000]   #43 [0001e40000 - 0001e5b000]         BOOTMEM
[    0.000000]   #44 [0001e80000 - 0001e9b000]         BOOTMEM
[    0.000000]   #45 [0001ec0000 - 0001edb000]         BOOTMEM
[    0.000000]   #46 [0001f00000 - 0001f1b000]         BOOTMEM
[    0.000000]   #47 [0001f40000 - 0001f5b000]         BOOTMEM
[    0.000000]   #48 [0001f80000 - 0001f9b000]         BOOTMEM
[    0.000000]   #49 [0001fc0000 - 0001fdb000]         BOOTMEM
[    0.000000]   #50 [0001de1c80 - 0001de1c88]         BOOTMEM
[    0.000000]   #51 [0001de1cc0 - 0001de1cc8]         BOOTMEM
[    0.000000]   #52 [0001de1d00 - 0001de1d20]         BOOTMEM
[    0.000000]   #53 [0001de1d40 - 0001de1d80]         BOOTMEM
[    0.000000]   #54 [0001de1d80 - 0001de1ea0]         BOOTMEM
[    0.000000]   #55 [0001de1ec0 - 0001de1f08]         BOOTMEM
[    0.000000]   #56 [0001de1f40 - 0001de1f88]         BOOTMEM
[    0.000000]   #57 [0001de3000 - 0001deb000]         BOOTMEM
[    0.000000]   #58 [00021b2000 - 00061b2000]         BOOTMEM
[    0.000000]   #59 [0001e1b000 - 0001e3b000]         BOOTMEM
[    0.000000]   #60 [0001fdb000 - 000201b000]         BOOTMEM
[    0.000000]   #61 [000000f000 - 0000017000]         BOOTMEM
[    0.000000] Memory: 6052852k/7274496k available (5329k kernel code, 1051016k absent, 170628k reserved, 6546k data, 612k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty1] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2393.797 MHz processor.
[    0.002005] Calibrating delay loop (skipped), value calculated using timer frequency.. 4787.59 BogoMIPS (lpj=2393797)
[    0.004021] Security Framework initialized
[    0.005005] SELinux:  Initializing.
[    0.007338] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.013628] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.017413] Mount-cache hash table entries: 256
[    0.018185] Initializing cgroup subsys ns
[    0.019007] Initializing cgroup subsys cpuacct
[    0.020006] Initializing cgroup subsys blkio
[    0.021031] CPU: Physical Processor ID: 0
[    0.022002] CPU: Processor Core ID: 0
[    0.023003] using mwait in idle threads.
[    0.024002] Performance Events: Core2 events, Intel PMU driver.
[    0.027003] ... version:                2
[    0.028002] ... bit width:              40
[    0.029002] ... generic registers:      2
[    0.030002] ... value mask:             000000ffffffffff
[    0.031002] ... max period:             000000007fffffff
[    0.032002] ... fixed-purpose events:   3
[    0.033002] ... event mask:             0000000700000003
[    0.034039] ACPI: Core revision 20100121
[    0.201068] Setting APIC routing to flat
[    0.202470] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.213995] CPU0: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
[    0.216999] Booting Node   0, Processors  #1 #2 #3
[    0.433006] Brought up 4 CPUs
[    0.434002] Total of 4 processors activated (19150.90 BogoMIPS).
[    0.436105] khelper used greatest stack depth: 5976 bytes left
[    0.443364] Time: 19:28:47  Date: 04/06/10
[    0.444034] NET: Registered protocol family 16
[    0.445040] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.446008] ACPI: bus type pci registered
[    0.447041] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.448002] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.470238] PCI: Using configuration type 1 for base access
[    0.483041] bio: create slab <bio-0> at 0
[    0.515520] ACPI: BIOS _OSI(Linux) query ignored
[    0.562237] ACPI: Interpreter enabled
[    0.566003] ACPI: (supports S0 S1 S3 S4 S5)
[    0.570003] ACPI: Using IOAPIC for interrupt routing
[    0.763201] ACPI Warning: Incorrect checksum in table [TCPA] - 00, should be 87 (20100121/tbutils-314)
[    0.773064] ACPI: No dock devices found.
[    0.777002] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.796381] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.822373] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.829002] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.836002] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.843002] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000effff]
[    0.851002] pci_root PNP0A03:00: host bridge window [mem 0x000f0000-0x000fffff]
[    0.858002] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfebfffff]
[    0.866001] pci_root PNP0A03:00: host bridge window [mem 0xbff00000-0xdfffffff]
[    0.873002] pci_root PNP0A03:00: host bridge window [mem 0xff980800-0xff980bff]
[    0.880001] pci_root PNP0A03:00: host bridge window [mem 0xff97c000-0xff97ffff]
[    0.888001] pci_root PNP0A03:00: host bridge window [mem 0xfed20000-0xfed9ffff]
[    0.896396] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
[    0.905003] pci 0000:00:1f.0: quirk: [io  0x0880-0x08bf] claimed by ICH6 GPIO
[    0.912003] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0c00 (mask 007f)
[    0.919002] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 00e0 (mask 0007)
[    0.927258] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.933033] pci 0000:00:06.0: PCI bridge to [bus 02-02]
[    0.938047] pci 0000:00:1c.0: PCI bridge to [bus 03-03]
[    0.943193] pci 0000:00:1c.5: PCI bridge to [bus 04-04]
[    0.949107] pci 0000:00:1e.0: PCI bridge to [bus 05-05] (subtractive decode)
[    2.980627] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 15)
[    2.989442] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 15)
[    2.998052] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 9 10 11 12 15)
[    3.005658] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
[    3.015669] ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 6 7 9 10 11 12 15)
[    3.024274] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
[    3.034278] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 15)
[    3.042772] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    3.051037] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    3.060003] vgaarb: loaded
[    3.063026] SCSI subsystem initialized
[    3.067030] usbcore: registered new interface driver usbfs
[    3.073017] usbcore: registered new interface driver hub
[    3.078021] usbcore: registered new device driver usb
[    3.083029] Advanced Linux Sound Architecture Driver Version 1.0.22.1.
[    3.090002] PCI: Using ACPI for IRQ routing
[    3.094038] pci 0000:00:1f.2: no compatible bridge window for [mem 0xff970000-0xff9707ff]
[    3.103001] pci 0000:00:1f.2: can't reserve [mem 0xff970000-0xff9707ff]
[    3.109043] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    3.117046] cfg80211: Calling CRDA to update world regulatory domain
[    3.123017] NetLabel: Initializing
[    3.127001] NetLabel:  domain hash size = 128
[    3.131001] NetLabel:  protocols = UNLABELED CIPSOv4
[    3.136011] NetLabel:  unlabeled traffic allowed by default
[    3.142004] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    3.149004] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    3.154688] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    3.163041] Switching to clocksource tsc
[    3.176654] pnp: PnP ACPI init
[    3.179907] ACPI: bus type pnp registered
[    3.200843] pnp 00:01: disabling [io  0x0800-0x085f] because it overlaps 0000:00:1f.0 BAR 7 [io  0x0800-0x087f]
[    3.211250] pnp 00:01: disabling [io  0x0860-0x08ff] because it overlaps 0000:00:1f.0 BAR 7 [io  0x0800-0x087f]
[    3.285911] pnp: PnP ACPI: found 12 devices
[    3.290274] ACPI: ACPI bus type pnp unregistered
[    3.295087] system 00:01: [io  0x0c00-0x0c7f] has been reserved
[    3.306598] pci 0000:00:1c.0: BAR 9: assigned [mem 0xf0000000-0xf01fffff 64bit pref]
[    3.314656] pci 0000:00:1c.5: BAR 9: assigned [mem 0xf0200000-0xf03fffff 64bit pref]
[    3.322712] pci 0000:00:1c.0: BAR 7: assigned [io  0x1000-0x1fff]
[    3.328979] pci 0000:00:1c.5: BAR 7: assigned [io  0x2000-0x2fff]
[    3.335251] pci 0000:00:1f.2: BAR 5: assigned [mem 0x000a0000-0x000a07ff]
[    3.342221] pci 0000:00:1f.2: BAR 5: set to [mem 0x000a0000-0x000a07ff] (PCI address [0xa0000-0xa07ff]
[    3.351838] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    3.357243] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    3.363513] pci 0000:00:01.0:   bridge window [mem 0xfa000000-0xfdefffff]
[    3.370475] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    3.378533] pci 0000:00:06.0: PCI bridge to [bus 02-02]
[    3.383934] pci 0000:00:06.0:   bridge window [io  disabled]
[    3.389768] pci 0000:00:06.0:   bridge window [mem disabled]
[    3.395602] pci 0000:00:06.0:   bridge window [mem pref disabled]
[    3.401870] pci 0000:00:1c.0: PCI bridge to [bus 03-03]
[    3.407272] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    3.413545] pci 0000:00:1c.0:   bridge window [mem 0xf9f00000-0xf9ffffff]
[    3.420507] pci 0000:00:1c.0:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
[    3.428565] pci 0000:00:1c.5: PCI bridge to [bus 04-04]
[    3.433967] pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
[    3.440243] pci 0000:00:1c.5:   bridge window [mem 0xf9e00000-0xf9efffff]
[    3.447216] pci 0000:00:1c.5:   bridge window [mem 0xf0200000-0xf03fffff 64bit pref]
[    3.455284] pci 0000:00:1e.0: PCI bridge to [bus 05-05]
[    3.460684] pci 0000:00:1e.0:   bridge window [io  disabled]
[    3.466521] pci 0000:00:1e.0:   bridge window [mem 0xf9d00000-0xf9dfffff]
[    3.473482] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    3.479761] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.486642] pci 0000:00:06.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.493522] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.500405] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.507380] NET: Registered protocol family 2
[    3.512119] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    3.521096] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    3.533682] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    3.541205] TCP: Hash tables configured (established 524288 bind 65536)
[    3.547992] TCP reno registered
[    3.551328] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    3.557692] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    3.564605] NET: Registered protocol family 1
[    3.569393] RPC: Registered udp transport module.
[    3.574277] RPC: Registered tcp transport module.
[    3.579169] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    4.697020] pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
[    4.704420] Trying to unpack rootfs image as initramfs...
[    4.775041] Freeing initd memory: 3460k .780660] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    4.787274] Placing 64MB software IO TLB between ffff8800021b2000 - ffff8800061b2000
[    4.795318] software IO TLB at phys 0x21b2000 - 0x61b2000
[    4.801172] Simple Boot Flag at 0x7a set to 0x1
[    4.808171] microcode: CPU0 sig=0x6fb, pf=0x10, revision=0xb3
[    4.814092] microcode: CPU1 sig=0x6fb, pf=0x10, revision=0xb3
[    4.820019] microcode: CPU2 sig=0x6fb, pf=0x10, revision=0xb3
[    4.829512] microcode: CPU3 sig=0x6fb, pf=0x10, revision=0xb3
[    4.835510] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    4.845020] audit: initializing netlink socket (disabled)
[    4.850601] type=2000 audit(1270582130.850:1): initialized
[    4.876011] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.886784] VFS: Disk quotas dquot_6.5.2
[    4.890993] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    4.898953] msgmni has been set to 11828
[    4.903830] alg: No test for stdrng (krng)
[    4.908268] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    4.915973] io scheduler noop registered
[    4.920067] io scheduler deadline registered
[    4.924679] io scheduler cfq registered (default)
[    4.930754] pcieport 0000:00:01.0: Requesting control of PCIe PME from ACPI BIOS
[    4.938482] pcieport 0000:00:01.0: Failed to receive control of PCIe PME service: no _OSC support
[    4.947653] pcie_pme: probe of 0000:00:01.0:pcie01 failed with error -13
[    4.954521] pcieport 0000:00:06.0: Requesting control of PCIe PME from ACPI BIOS
[    4.962240] pcieport 0000:00:06.0: Failed to receive control of PCIe PME service: no _OSC support
[    4.971428] pcie_pme: probe of 0000:00:06.0:pcie01 failed with error -13
[    4.978315] pcieport 0000:00:1c.0: Requesting control of PCIe PME from ACPI BIOS
[    4.986013] pcieport 0000:00:1c.0: Failed to receive control of PCIe PME service: no _OSC support
[    4.995193] pcie_pme: probe of 0000:00:1c.0:pcie01 failed with error -13
[    5.002062] pcieport 0000:00:1c.5: Requesting control of PCIe PME from ACPI BIOS
[    5.009764] pcieport 0000:00:1c.5: Failed to receive control of PCIe PME service: no _OSC support
[    5.018932] pcie_pme: probe of 0000:00:1c.5:pcie01 failed with error -13
[    5.025919] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    5.032111] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    5.040772] ACPI: Power Button [VBTN]
[    5.044713] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    5.052435] ACPI: Power Button [PWRF]
[    5.155976] Non-volatile memory driver v1.3
[    5.160343] Linux agpgart interface v0.103
[    5.164843] [drm] Initialized drm 1.1.0 20060810
[    5.169632] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
[    5.177426] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    5.428358] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    5.435172] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    5.443890] brd: module loaded
[    5.448507] loop: module loaded
[    5.451955] Loading iSCSI transport class v2.0-870.
[    5.457687] ahci 0000:00:1f.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
[    5.464777] ahci: SSS flag set, parallel bus scan disabled
[    6.472019] ahci 0000:00:1f.2: controller reset failed (0xffffffff)
[    6.478474] ahci 0000:00:1f.2: PCI INT C disabled
[    6.483349] ahci: probe of 0000:00:1f.2 failed with error -5

-andy
