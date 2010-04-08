Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174Ab0DHVkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 17:40:32 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:35773 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758650Ab0DHVk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 17:40:29 -0400
Date: Thu, 8 Apr 2010 14:40:29 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>, Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] x86: Reserve legacy VGA MMIO area for x86_64 as well
	as x86_32
Message-ID: <20100408214028.GQ29192@hexapodia.org>
References: <20100407210628.28364.96982.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100407210628.28364.96982.stgit@bob.kio>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 03:06:28PM -0600, Bjorn Helgaas wrote:
> 
> Currently, we only reserve the legacy VGA area [mem 0xa0000-0xbffff] on
> x86_32.  But this legacy area is also used on x86_64, so this patch
> reserves it there, too.
> 
> If we don't reserve it, we may mistakenly move a PCI device to that area,
> as we did here:
> 
>   pci_root PNP0A03:00: host bridge window [mem 0xff980800-0xff980bff]
>   pci_root PNP0A03:00: host bridge window [mem 0xff97c000-0xff97ffff]
>   pci 0000:00:1f.2: no compatible bridge window for [mem 0xff970000-0xff9707ff]
>   pci 0000:00:1f.2: BAR 5: assigned [mem 0x000a0000-0x000a07ff]
> 
> as reported by Andy Isaacson at http://lkml.org/lkml/2010/4/6/375
> 
> I think the fact that the BAR is not within a host bridge window is a
> BIOS defect, and it's now more visible because we have "pci=use_crs" as
> the default.  Using "pci=nocrs" is a workaround, because then we won't
> attempt to move the device.

This patch doesn't fix the T3400.

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.34-rc3-00300-g29dc2a0 (andy@farthing) (gcc version 4.3.3 (Debian 4.3.3-5) ) #6 SMP Thu Apr 8 14:22:20 PDT 2010
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.34-rc3-00300-g29dc2a0 root=UUID=a2359eda-9295-451c-924f-c181c6f49d0d ro console=tty0 console=ttyS0,115200
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
[    0.000000] RAMDISK: 37c8e000 - 37ff0000
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
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880001e00000 s81896 r8192 d20504 u262144
[    0.000000] pcpu-alloc: s81896 r8192 d20504 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1531006
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.34-rc3-00300-g29dc2a0 root=UUID=a2359eda-9295-451c-924f-c181c6f49d0d ro console=tty0 console=ttyS0,115200
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Subtract (62 early reservations)
[    0.000000]   #1 [0001000000 - 0001db1128]   TEXT DATA BSS
[    0.000000]   #2 [0037c8e000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [0001db2000 - 0001db21a8]             BRK
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
[    0.000000]   #14 [0001db21c0 - 0001db31c0]         BOOTMEM
[    0.000000]   #15 [0001db1140 - 0001db15c0]         BOOTMEM
[    0.000000]   #16 [0100005000 - 0100006000]         BOOTMEM
[    0.000000]   #17 [0100006000 - 0100007000]         BOOTMEM
[    0.000000]   #18 [0100200000 - 0105600000]        MEMMAP 0
[    0.000000]   #19 [0001db15c0 - 0001db1740]         BOOTMEM
[    0.000000]   #20 [0001db31c0 - 0001dcb1c0]         BOOTMEM
[    0.000000]   #21 [0001dcb1c0 - 0001de31c0]         BOOTMEM
[    0.000000]   #22 [0001de4000 - 0001de5000]         BOOTMEM
[    0.000000]   #23 [0001db1740 - 0001db1781]         BOOTMEM
[    0.000000]   #24 [0001db17c0 - 0001db1803]         BOOTMEM
[    0.000000]   #25 [0001db1840 - 0001db1b18]         BOOTMEM
[    0.000000]   #26 [0001db1b40 - 0001db1ba8]         BOOTMEM
[    0.000000]   #27 [0001db1bc0 - 0001db1c28]         BOOTMEM
[    0.000000]   #28 [0001db1c40 - 0001db1ca8]         BOOTMEM
[    0.000000]   #29 [0001db1cc0 - 0001db1d28]         BOOTMEM
[    0.000000]   #30 [0001db1d40 - 0001db1da8]         BOOTMEM
[    0.000000]   #31 [0001db1dc0 - 0001db1e28]         BOOTMEM
[    0.000000]   #32 [0001db1e40 - 0001db1ea8]         BOOTMEM
[    0.000000]   #33 [0001db1ec0 - 0001db1f28]         BOOTMEM
[    0.000000]   #34 [0001db1f40 - 0001db1fa8]         BOOTMEM
[    0.000000]   #35 [0001de31c0 - 0001de3228]         BOOTMEM
[    0.000000]   #36 [0001de3240 - 0001de32a8]         BOOTMEM
[    0.000000]   #37 [0001de32c0 - 0001de3328]         BOOTMEM
[    0.000000]   #38 [0001db1fc0 - 0001db1fe0]         BOOTMEM
[    0.000000]   #39 [0001de3340 - 0001de3360]         BOOTMEM
[    0.000000]   #40 [0001de3380 - 0001de3402]         BOOTMEM
[    0.000000]   #41 [0001de3440 - 0001de34c2]         BOOTMEM
[    0.000000]   #42 [0001e00000 - 0001e1b000]         BOOTMEM
[    0.000000]   #43 [0001e40000 - 0001e5b000]         BOOTMEM
[    0.000000]   #44 [0001e80000 - 0001e9b000]         BOOTMEM
[    0.000000]   #45 [0001ec0000 - 0001edb000]         BOOTMEM
[    0.000000]   #46 [0001f00000 - 0001f1b000]         BOOTMEM
[    0.000000]   #47 [0001f40000 - 0001f5b000]         BOOTMEM
[    0.000000]   #48 [0001f80000 - 0001f9b000]         BOOTMEM
[    0.000000]   #49 [0001fc0000 - 0001fdb000]         BOOTMEM
[    0.000000]   #50 [0001de3500 - 0001de3508]         BOOTMEM
[    0.000000]   #51 [0001de3540 - 0001de3548]         BOOTMEM
[    0.000000]   #52 [0001de3580 - 0001de35a0]         BOOTMEM
[    0.000000]   #53 [0001de35c0 - 0001de3600]         BOOTMEM
[    0.000000]   #54 [0001de3600 - 0001de3720]         BOOTMEM
[    0.000000]   #55 [0001de3740 - 0001de3788]         BOOTMEM
[    0.000000]   #56 [0001de37c0 - 0001de3808]         BOOTMEM
[    0.000000]   #57 [0001de5000 - 0001ded000]         BOOTMEM
[    0.000000]   #58 [0001fdb000 - 0005fdb000]         BOOTMEM
[    0.000000]   #59 [0001e1b000 - 0001e3b000]         BOOTMEM
[    0.000000]   #60 [0005fdb000 - 000601b000]         BOOTMEM
[    0.000000]   #61 [000000f000 - 0000017000]         BOOTMEM
[    0.000000] Memory: 6052848k/7274496k available (5342k kernel code, 1051016k absent, 170632k reserved, 6534k data, 612k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2394.110 MHz processor.
[    0.002005] Calibrating delay loop (skipped), value calculated using timer frequency.. 4788.22 BogoMIPS (lpj=2394110)
[    0.004021] Security Framework initialized
[    0.005005] SELinux:  Initializing.
[    0.007315] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.013568] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.017320] Mount-cache hash table entries: 256
[    0.018183] Initializing cgroup subsys ns
[    0.019007] Initializing cgroup subsys cpuacct
[    0.020005] Initializing cgroup subsys blkio
[    0.021033] CPU: Physical Processor ID: 0
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
[    0.201067] Setting APIC routing to flat
[    0.202471] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.213983] CPU0: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
[    0.216999] Booting Node   0, Processors  #1 #2 #3
[    0.433006] Brought up 4 CPUs
[    0.434002] Total of 4 processors activated (19151.52 BogoMIPS).
[    0.436089] khelper used greatest stack depth: 6008 bytes left
[    0.443352] Time: 21:27:42  Date: 04/08/10
[    0.444032] NET: Registered protocol family 16
[    0.445035] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.446007] ACPI: bus type pci registered
[    0.448045] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.449003] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.472120] PCI: Using configuration type 1 for base access
[    0.485021] bio: create slab <bio-0> at 0
[    0.517507] ACPI: BIOS _OSI(Linux) query ignored
[    0.564263] ACPI: Interpreter enabled
[    0.568002] ACPI: (supports S0 S1 S3 S4 S5)
[    0.572778] ACPI: Using IOAPIC for interrupt routing
[    0.762201] ACPI Warning: Incorrect checksum in table [TCPA] - 00, should be 87 (20100121/tbutils-314)
[    0.772002] ACPI: No dock devices found.
[    0.776002] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.795092] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.821199] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.828002] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.835002] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.842002] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000effff]
[    0.850001] pci_root PNP0A03:00: host bridge window [mem 0x000f0000-0x000fffff]
[    0.857002] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfebfffff]
[    0.865001] pci_root PNP0A03:00: host bridge window [mem 0xbff00000-0xdfffffff]
[    0.872002] pci_root PNP0A03:00: host bridge window [mem 0xff980800-0xff980bff]
[    0.880001] pci_root PNP0A03:00: host bridge window [mem 0xff97c000-0xff97ffff]
[    0.887001] pci_root PNP0A03:00: host bridge window [mem 0xfed20000-0xfed9ffff]
[    0.895868] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
[    0.904003] pci 0000:00:1f.0: quirk: [io  0x0880-0x08bf] claimed by ICH6 GPIO
[    0.911003] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0c00 (mask 007f)
[    0.919002] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 00e0 (mask 0007)
[    0.927257] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.933033] pci 0000:00:06.0: PCI bridge to [bus 02-02]
[    0.938047] pci 0000:00:1c.0: PCI bridge to [bus 03-03]
[    0.943194] pci 0000:00:1c.5: PCI bridge to [bus 04-04]
[    0.949145] pci 0000:00:1e.0: PCI bridge to [bus 05-05] (subtractive decode)
[    2.982594] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 15)
[    2.991196] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 15)
[    2.999778] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 9 10 11 12 15)
[    3.008382] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
[    3.018361] ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 6 7 9 10 11 12 15)
[    3.026772] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
[    3.036785] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 15)
[    3.045542] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    3.053196] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    3.062003] vgaarb: loaded
[    3.065075] SCSI subsystem initialized
[    3.069035] usbcore: registered new interface driver usbfs
[    3.075019] usbcore: registered new interface driver hub
[    3.080021] usbcore: registered new device driver usb
[    3.086033] Advanced Linux Sound Architecture Driver Version 1.0.22.1.
[    3.093002] PCI: Using ACPI for IRQ routing
[    3.097036] pci 0000:00:1f.2: no compatible bridge window for [mem 0xff970000-0xff9707ff]
[    3.105042] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    3.113047] cfg80211: Calling CRDA to update world regulatory domain
[    3.119015] NetLabel: Initializing
[    3.124001] NetLabel:  domain hash size = 128
[    3.128001] NetLabel:  protocols = UNLABELED CIPSOv4
[    3.133011] NetLabel:  unlabeled traffic allowed by default
[    3.139004] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    3.146004] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    3.151372] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    3.160021] Switching to clocksource tsc
[    3.173645] pnp: PnP ACPI init
[    3.176899] ACPI: bus type pnp registered
[    3.197841] pnp 00:01: disabling [io  0x0800-0x085f] because it overlaps 0000:00:1f.0 BAR 7 [io  0x0800-0x087f]
[    3.208245] pnp 00:01: disabling [io  0x0860-0x08ff] because it overlaps 0000:00:1f.0 BAR 7 [io  0x0800-0x087f]
[    3.282787] pnp: PnP ACPI: found 12 devices
[    3.287157] ACPI: ACPI bus type pnp unregistered
[    3.291958] system 00:01: [io  0x0c00-0x0c7f] has been reserved
[    3.303431] pci 0000:00:1c.0: BAR 9: assigned [mem 0xf0000000-0xf01fffff 64bit pref]
[    3.311489] pci 0000:00:1c.5: BAR 9: assigned [mem 0xf0200000-0xf03fffff 64bit pref]
[    3.319543] pci 0000:00:1c.0: BAR 7: assigned [io  0x1000-0x1fff]
[    3.325808] pci 0000:00:1c.5: BAR 7: assigned [io  0x2000-0x2fff]
[    3.332077] pci 0000:00:1f.2: BAR 5: assigned [mem 0x000c0000-0x000c07ff]
[    3.339037] pci 0000:00:1f.2: BAR 5: set to [mem 0x000c0000-0x000c07ff] (PCI address [0xc0000-0xc07ff]
[    3.348651] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    3.354050] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    3.360320] pci 0000:00:01.0:   bridge window [mem 0xfa000000-0xfdefffff]
[    3.367284] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    3.375350] pci 0000:00:06.0: PCI bridge to [bus 02-02]
[    3.380748] pci 0000:00:06.0:   bridge window [io  disabled]
[    3.386581] pci 0000:00:06.0:   bridge window [mem disabled]
[    3.392414] pci 0000:00:06.0:   bridge window [mem pref disabled]
[    3.398683] pci 0000:00:1c.0: PCI bridge to [bus 03-03]
[    3.404087] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    3.410356] pci 0000:00:1c.0:   bridge window [mem 0xf9f00000-0xf9ffffff]
[    3.417321] pci 0000:00:1c.0:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
[    3.425388] pci 0000:00:1c.5: PCI bridge to [bus 04-04]
[    3.430788] pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
[    3.437056] pci 0000:00:1c.5:   bridge window [mem 0xf9e00000-0xf9efffff]
[    3.444017] pci 0000:00:1c.5:   bridge window [mem 0xf0200000-0xf03fffff 64bit pref]
[    3.452079] pci 0000:00:1e.0: PCI bridge to [bus 05-05]
[    3.457479] pci 0000:00:1e.0:   bridge window [io  disabled]
[    3.463319] pci 0000:00:1e.0:   bridge window [mem 0xf9d00000-0xf9dfffff]
[    3.470282] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    3.476558] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.483435] pci 0000:00:06.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.490318] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.497209] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.504185] NET: Registered protocol family 2
[    3.508920] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    3.517903] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    3.530505] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    3.538017] TCP: Hash tables configured (established 524288 bind 65536)
[    3.544805] TCP reno registered
[    3.548147] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    3.554509] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    3.561434] NET: Registered protocol family 1
[    3.566201] RPC: Registered udp transport module.
[    3.571088] RPC: Registered tcp transport module.
[    3.575969] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    4.693019] pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
[    4.700455] Trying to unpack rootfs image as initramfs...
[    4.771225] Freeing initrd memory: 3464k freed
[    4.776924] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    4.783544] Placing 64MB software IO TLB between ffff880001fdb000 - ffff880005fdb000
[    4.791588] software IO TLB at phys 0x1fdb000 - 0x5fdb000
[    4.797392] Simple Boot Flag at 0x7a set to 0x1
[    4.803990] microcode: CPU0 sig=0x6fb, pf=0x10, revision=0xb3
[    4.809909] microcode: CPU1 sig=0x6fb, pf=0x10, revision=0xb3
[    4.815825] microcode: CPU2 sig=0x6fb, pf=0x10, revision=0xb3
[    4.821743] microcode: CPU3 sig=0x6fb, pf=0x10, revision=0xb3
[    4.831321] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    4.840768] audit: initializing netlink socket (disabled)
[    4.846360] type=2000 audit(1270762064.846:1): initialized
[    4.870704] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.881160] VFS: Disk quotas dquot_6.5.2
[    4.885349] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    4.893253] msgmni has been set to 11828
[    4.898070] alg: No test for stdrng (krng)
[    4.902481] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    4.910199] io scheduler noop registered
[    4.914292] io scheduler deadline registered
[    4.918881] io scheduler cfq registered (default)
[    4.924851] pcieport 0000:00:01.0: Requesting control of PCIe PME from ACPI BIOS
[    4.932557] pcieport 0000:00:01.0: Failed to receive control of PCIe PME service: no _OSC support
[    4.941725] pcie_pme: probe of 0000:00:01.0:pcie01 failed with error -13
[    4.948593] pcieport 0000:00:06.0: Requesting control of PCIe PME from ACPI BIOS
[    4.956298] pcieport 0000:00:06.0: Failed to receive control of PCIe PME service: no _OSC support
[    4.965467] pcie_pme: probe of 0000:00:06.0:pcie01 failed with error -13
[    4.972334] pcieport 0000:00:1c.0: Requesting control of PCIe PME from ACPI BIOS
[    4.980034] pcieport 0000:00:1c.0: Failed to receive control of PCIe PME service: no _OSC support
[    4.989212] pcie_pme: probe of 0000:00:1c.0:pcie01 failed with error -13
[    4.996086] pcieport 0000:00:1c.5: Requesting control of PCIe PME from ACPI BIOS
[    5.003781] pcieport 0000:00:1c.5: Failed to receive control of PCIe PME service: no _OSC support
[    5.012950] pcie_pme: probe of 0000:00:1c.5:pcie01 failed with error -13
[    5.019925] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    5.026064] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    5.034718] ACPI: Power Button [VBTN]
[    5.038646] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    5.046350] ACPI: Power Button [PWRF]
[    5.220953] Non-volatile memory driver v1.3
[    5.225312] Linux agpgart interface v0.103
[    5.229767] [drm] Initialized drm 1.1.0 20060810
[    5.234556] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
[    5.242348] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
ÿ[    5.493338] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    5.500096] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    5.508624] brd: module loaded
[    5.513142] loop: module loaded
[    5.516579] Loading iSCSI transport class v2.0-870.
[    5.522209] ahci 0000:00:1f.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
[    5.584017] ------------[ cut here ]------------
[    5.588813] WARNING: at drivers/ata/ahci.c:795 ahci_enable_ahci+0x52/0x5b()
[    5.595938] Hardware name: Precision WorkStation T3400  
[    5.601417] Modules linked in:
[    5.604699] Pid: 1, comm: swapper Not tainted 2.6.34-rc3-00300-g29dc2a0 #6
[    5.611737] Call Trace:
[    5.614358]  [<ffffffff812ec086>] ? ahci_enable_ahci+0x52/0x5b
[    5.620359]  [<ffffffff810390b2>] warn_slowpath_common+0x77/0xa4
[    5.626532]  [<ffffffff810390ee>] warn_slowpath_null+0xf/0x11
[    5.632444]  [<ffffffff812ec086>] ahci_enable_ahci+0x52/0x5b
[    5.638269]  [<ffffffff812ed972>] ahci_init_one+0x370/0x1145
[    5.644108]  [<ffffffff811d8a0a>] ? ida_get_new_above+0xfd/0x1b4
[    5.650281]  [<ffffffff811d8815>] ? idr_get_empty_slot+0x169/0x261
[    5.656626]  [<ffffffff811d8a0a>] ? ida_get_new_above+0xfd/0x1b4
[    5.662800]  [<ffffffff8112f894>] ? sysfs_find_dirent+0x1c/0x31
[    5.668885]  [<ffffffff8112fc2a>] ? sysfs_add_one+0x1c/0xe7
[    5.674624]  [<ffffffff811d95ca>] ? kobject_get+0x1a/0x22
[    5.680200]  [<ffffffff811ee6d3>] local_pci_probe+0x12/0x16
[    5.685940]  [<ffffffff811ef5a6>] pci_device_probe+0xc6/0xf0
[    5.691766]  [<ffffffff812b10a0>] ? driver_sysfs_add+0x4c/0x72
[    5.697766]  [<ffffffff812b11ec>] driver_probe_device+0xad/0x15f
[    5.703939]  [<ffffffff812b12f6>] __driver_attach+0x58/0x7b
[    5.709678]  [<ffffffff812b129e>] ? __driver_attach+0x0/0x7b
[    5.715504]  [<ffffffff812b0a51>] bus_for_each_dev+0x4e/0x84
[    5.721329]  [<ffffffff812b1052>] driver_attach+0x1c/0x1e
[    5.726895]  [<ffffffff812b03a7>] bus_add_driver+0xb8/0x20e
[    5.732633]  [<ffffffff812b15ea>] driver_register+0xb3/0x121
[    5.738461]  [<ffffffff81bdc461>] ? ahci_init+0x0/0x1b
[    5.743767]  [<ffffffff811ef7f8>] __pci_register_driver+0x51/0xbc
[    5.750030]  [<ffffffff81bdc461>] ? ahci_init+0x0/0x1b
[    5.755336]  [<ffffffff81bdc47a>] ahci_init+0x19/0x1b
[    5.760557]  [<ffffffff810001f0>] do_one_initcall+0x5a/0x14a
[    5.766384]  [<ffffffff81baf69d>] kernel_init+0x154/0x1de
[    5.771952]  [<ffffffff810037b4>] kernel_thread_helper+0x4/0x10
[    5.778038]  [<ffffffff81baf549>] ? kernel_init+0x0/0x1de
[    5.783605]  [<ffffffff810037b0>] ? kernel_thread_helper+0x0/0x10
[    5.789866] ---[ end trace 941a3246270f5a35 ]---
[    5.794758] ahci: SSS flag set, parallel bus scan disabled
[    5.855017] ------------[ cut here ]------------
[    5.859809] WARNING: at drivers/ata/ahci.c:795 ahci_enable_ahci+0x52/0x5b()
[    5.866931] Hardware name: Precision WorkStation T3400  
[    5.872410] Modules linked in:
[    5.875692] Pid: 1, comm: swapper Tainted: G        W  2.6.34-rc3-00300-g29dc2a0 #6
[    5.883646] Call Trace:
[    5.886268]  [<ffffffff812ec086>] ? ahci_enable_ahci+0x52/0x5b
[    5.892269]  [<ffffffff810390b2>] warn_slowpath_common+0x77/0xa4
[    5.898441]  [<ffffffff810390ee>] warn_slowpath_null+0xf/0x11
[    5.904352]  [<ffffffff812ec086>] ahci_enable_ahci+0x52/0x5b
[    5.910177]  [<ffffffff812ec0bb>] ahci_reset_controller+0x2c/0x14a
[    5.916523]  [<ffffffff812ee2b6>] ahci_init_one+0xcb4/0x1145
[    5.922349]  [<ffffffff811d8a0a>] ? ida_get_new_above+0xfd/0x1b4
[    5.928521]  [<ffffffff811d8815>] ? idr_get_empty_slot+0x169/0x261
[    5.934867]  [<ffffffff811d8a0a>] ? ida_get_new_above+0xfd/0x1b4
[    5.941039]  [<ffffffff8112f894>] ? sysfs_find_dirent+0x1c/0x31
[    5.947124]  [<ffffffff8112fc2a>] ? sysfs_add_one+0x1c/0xe7
[    5.952864]  [<ffffffff811d95ca>] ? kobject_get+0x1a/0x22
[    5.958429]  [<ffffffff811ee6d3>] local_pci_probe+0x12/0x16
[    5.964167]  [<ffffffff811ef5a6>] pci_device_probe+0xc6/0xf0
[    5.969993]  [<ffffffff812b10a0>] ? driver_sysfs_add+0x4c/0x72
[    5.975991]  [<ffffffff812b11ec>] driver_probe_device+0xad/0x15f
[    5.982162]  [<ffffffff812b12f6>] __driver_attach+0x58/0x7b
[    5.987900]  [<ffffffff812b129e>] ? __driver_attach+0x0/0x7b
[    5.993725]  [<ffffffff812b0a51>] bus_for_each_dev+0x4e/0x84
[    5.999551]  [<ffffffff812b1052>] driver_attach+0x1c/0x1e
[    6.005118]  [<ffffffff812b03a7>] bus_add_driver+0xb8/0x20e
[    6.010857]  [<ffffffff812b15ea>] driver_register+0xb3/0x121
[    6.016684]  [<ffffffff81bdc461>] ? ahci_init+0x0/0x1b
[    6.021988]  [<ffffffff811ef7f8>] __pci_register_driver+0x51/0xbc
[    6.028247]  [<ffffffff81bdc461>] ? ahci_init+0x0/0x1b
[    6.033553]  [<ffffffff81bdc47a>] ahci_init+0x19/0x1b
[    6.038774]  [<ffffffff810001f0>] do_one_initcall+0x5a/0x14a
[    6.044600]  [<ffffffff81baf69d>] kernel_init+0x154/0x1de
[    6.050166]  [<ffffffff810037b4>] kernel_thread_helper+0x4/0x10
[    6.056252]  [<ffffffff81baf549>] ? kernel_init+0x0/0x1de
[    6.061816]  [<ffffffff810037b0>] ? kernel_thread_helper+0x0/0x10
[    6.068074] ---[ end trace 941a3246270f5a36 ]---
[    7.073018] ahci 0000:00:1f.2: controller reset failed (0x3034374b)
[    7.079480] ahci 0000:00:1f.2: PCI INT C disabled
[    7.084358] ahci: probe of 0000:00:1f.2 failed with error -5

-andy
