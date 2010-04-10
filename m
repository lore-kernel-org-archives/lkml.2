Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab0DJAAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 20:00:36 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:44925 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab0DJAAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 20:00:31 -0400
Date: Fri, 9 Apr 2010 17:00:30 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: guenter.roeck@ericsson.com, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] x86: Reserve legacy VGA MMIO area for x86_64 as well
	as x86_32
Message-ID: <20100410000030.GE11130@hexapodia.org>
References: <201004091004.39857.bjorn.helgaas@hp.com> <4BBF5987.3010100@zytor.com> <4BBF626A.3060800@oracle.com> <4BBF70BC.3080809@zytor.com> <1270839357.1477.758.camel@groeck-laptop> <4BBF863B.1060806@oracle.com> <20100409222103.GA11130@hexapodia.org> <4BBFA9BF.60608@oracle.com> <20100409223532.GC11130@hexapodia.org> <4BBFB1D8.6090802@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BBFB1D8.6090802@oracle.com>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 04:01:44PM -0700, Yinghai wrote:
> Please check
> 
> Subject: [PATCH] x86: reserve [0xa0000, 0x100000] in e820
> 
> Update e820 at first, and later put them resource tree.
> 
> -V2: reserved that early, no PCI BAR can use it, force them to get new one

Still no go.

[    0.000000] Linux version 2.6.34-rc3-00411-g9e969ac (andy@farthing) (gcc version 4.3.3 (Debian 4.3.3-5) ) #11 SMP Fri Apr 9 16:27:51 PDT 2010
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.34-rc3-00411-g9e969ac root=UUID=a2359eda-9295-451c-924f-c181c6f49d0d ro console=tty0 console=ttyS0,115200
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
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
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
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.34-rc3-00411-g9e969ac root=UUID=a2359eda-9295-451c-924f-c181c6f49d0d ro console=tty0 console=ttyS0,115200
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Subtract (62 early reservations)
[    0.000000]   #1 [0001000000 - 0001db1168]   TEXT DATA BSS
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
[    0.000000]   #15 [0001db1180 - 0001db1600]         BOOTMEM
[    0.000000]   #16 [0100005000 - 0100006000]         BOOTMEM
[    0.000000]   #17 [0100006000 - 0100007000]         BOOTMEM
[    0.000000]   #18 [0100200000 - 0105600000]        MEMMAP 0
[    0.000000]   #19 [0001db1600 - 0001db1780]         BOOTMEM
[    0.000000]   #20 [0001db31c0 - 0001dcb1c0]         BOOTMEM
[    0.000000]   #21 [0001dcb1c0 - 0001de31c0]         BOOTMEM
[    0.000000]   #22 [0001de4000 - 0001de5000]         BOOTMEM
[    0.000000]   #23 [0001db1780 - 0001db17c1]         BOOTMEM
[    0.000000]   #24 [0001db1800 - 0001db1843]         BOOTMEM
[    0.000000]   #25 [0001db1880 - 0001db1b58]         BOOTMEM
[    0.000000]   #26 [0001db1b80 - 0001db1be8]         BOOTMEM
[    0.000000]   #27 [0001db1c00 - 0001db1c68]         BOOTMEM
[    0.000000]   #28 [0001db1c80 - 0001db1ce8]         BOOTMEM
[    0.000000]   #29 [0001db1d00 - 0001db1d68]         BOOTMEM
[    0.000000]   #30 [0001db1d80 - 0001db1de8]         BOOTMEM
[    0.000000]   #31 [0001db1e00 - 0001db1e68]         BOOTMEM
[    0.000000]   #32 [0001db1e80 - 0001db1ee8]         BOOTMEM
[    0.000000]   #33 [0001db1f00 - 0001db1f68]         BOOTMEM
[    0.000000]   #34 [0001db1f80 - 0001db1fe8]         BOOTMEM
[    0.000000]   #35 [0001de31c0 - 0001de3228]         BOOTMEM
[    0.000000]   #36 [0001de3240 - 0001de32a8]         BOOTMEM
[    0.000000]   #37 [0001de32c0 - 0001de3328]         BOOTMEM
[    0.000000]   #38 [0001de3340 - 0001de3360]         BOOTMEM
[    0.000000]   #39 [0001de3380 - 0001de33a0]         BOOTMEM
[    0.000000]   #40 [0001de33c0 - 0001de3442]         BOOTMEM
[    0.000000]   #41 [0001de3480 - 0001de3502]         BOOTMEM
[    0.000000]   #42 [0001e00000 - 0001e1b000]         BOOTMEM
[    0.000000]   #43 [0001e40000 - 0001e5b000]         BOOTMEM
[    0.000000]   #44 [0001e80000 - 0001e9b000]         BOOTMEM
[    0.000000]   #45 [0001ec0000 - 0001edb000]         BOOTMEM
[    0.000000]   #46 [0001f00000 - 0001f1b000]         BOOTMEM
[    0.000000]   #47 [0001f40000 - 0001f5b000]         BOOTMEM
[    0.000000]   #48 [0001f80000 - 0001f9b000]         BOOTMEM
[    0.000000]   #49 [0001fc0000 - 0001fdb000]         BOOTMEM
[    0.000000]   #50 [0001de3540 - 0001de3548]         BOOTMEM
[    0.000000]   #51 [0001de3580 - 0001de3588]         BOOTMEM
[    0.000000]   #52 [0001de35c0 - 0001de35e0]         BOOTMEM
[    0.000000]   #53 [0001de3600 - 0001de3640]         BOOTMEM
[    0.000000]   #54 [0001de3640 - 0001de3760]         BOOTMEM
[    0.000000]   #55 [0001de3780 - 0001de37c8]         BOOTMEM
[    0.000000]   #56 [0001de3800 - 0001de3848]         BOOTMEM
[    0.000000]   #57 [0001de5000 - 0001ded000]         BOOTMEM
[    0.000000]   #58 [0001fdb000 - 0005fdb000]         BOOTMEM
[    0.000000]   #59 [0001e1b000 - 0001e3b000]         BOOTMEM
[    0.000000]   #60 [0005fdb000 - 000601b000]         BOOTMEM
[    0.000000]   #61 [000000f000 - 0000017000]         BOOTMEM
[    0.000000] Memory: 6052848k/7274496k available (5380k kernel code, 1051016k absent, 170632k reserved, 6497k data, 612k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2394.304 MHz processor.
[    0.002006] Calibrating delay loop (skipped), value calculated using timer frequency.. 4788.60 BogoMIPS (lpj=2394304)
[    0.004021] Security Framework initialized
[    0.005004] SELinux:  Initializing.
[    0.007326] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.013587] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.017337] Mount-cache hash table entries: 256
[    0.018184] Initializing cgroup subsys ns
[    0.019007] Initializing cgroup subsys cpuacct
[    0.020005] Initializing cgroup subsys blkio
[    0.021032] CPU: Physical Processor ID: 0
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
[    0.034040] ACPI: Core revision 20100121
[    0.201068] Setting APIC routing to flat
[    0.202470] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.213197] CPU0: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
[    0.216999] Booting Node   0, Processors  #1 #2 #3
[    0.433006] Brought up 4 CPUs
[    0.434002] Total of 4 processors activated (19151.91 BogoMIPS).
[    0.437075] khelper used greatest stack depth: 6008 bytes left
[    0.444149] Time: 23:55:01  Date: 04/09/10
[    0.445044] NET: Registered protocol family 16
[    0.446035] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.447007] ACPI: bus type pci registered
[    0.448043] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.449002] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.470983] PCI: Using configuration type 1 for base access
[    0.483039] bio: create slab <bio-0> at 0
[    0.516503] ACPI: BIOS _OSI(Linux) query ignored
[    0.563293] ACPI: Interpreter enabled
[    0.568002] ACPI: (supports S0 S1 S3 S4 S5)
[    0.572003] ACPI: Using IOAPIC for interrupt routing
[    0.766034] ACPI Warning: Incorrect checksum in table [TCPA] - 00, should be 87 (20100121/tbutils-314)
[    0.775104] ACPI: No dock devices found.
[    0.779003] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.799048] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.825300] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.832002] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.838002] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.846002] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000effff]
[    0.853001] pci_root PNP0A03:00: host bridge window [mem 0x000f0000-0x000fffff]
[    0.861002] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfebfffff]
[    0.868001] pci_root PNP0A03:00: host bridge window [mem 0xbff00000-0xdfffffff]
[    0.876002] pci_root PNP0A03:00: host bridge window [mem 0xff980800-0xff980bff]
[    0.883001] pci_root PNP0A03:00: host bridge window [mem 0xff97c000-0xff97ffff]
[    0.891001] pci_root PNP0A03:00: host bridge window [mem 0xfed20000-0xfed9ffff]
[    0.899016] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
[    0.907003] pci 0000:00:1f.0: quirk: [io  0x0880-0x08bf] claimed by ICH6 GPIO
[    0.914003] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0c00 (mask 007f)
[    0.922002] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 00e0 (mask 0007)
[    0.930258] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.935023] pci 0000:00:06.0: PCI bridge to [bus 02-02]
[    0.941051] pci 0000:00:1c.0: PCI bridge to [bus 03-03]
[    0.946090] pci 0000:00:1c.5: PCI bridge to [bus 04-04]
[    0.951161] pci 0000:00:1e.0: PCI bridge to [bus 05-05] (subtractive decode)
[    2.995364] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 15)
[    3.004002] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 15)
[    3.011620] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 9 10 11 12 15)
[    3.020237] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
[    3.030230] ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 6 7 9 10 11 12 15)
[    3.038785] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
[    3.048791] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 15)
[    3.056474] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    3.065209] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    3.073003] vgaarb: loaded
[    3.076075] SCSI subsystem initialized
[    3.081011] usbcore: registered new interface driver usbfs
[    3.086018] usbcore: registered new interface driver hub
[    3.092022] usbcore: registered new device driver usb
[    3.097025] Advanced Linux Sound Architecture Driver Version 1.0.22.1.
[    3.104002] PCI: Using ACPI for IRQ routing
[    3.108037] pci 0000:00:1f.2: no compatible bridge window for [mem 0xff970000-0xff9707ff]
[    3.116042] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    3.124045] cfg80211: Calling CRDA to update world regulatory domain
[    3.130016] NetLabel: Initializing
[    3.134001] NetLabel:  domain hash size = 128
[    3.138001] NetLabel:  protocols = UNLABELED CIPSOv4
[    3.143010] NetLabel:  unlabeled traffic allowed by default
[    3.149004] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    3.156005] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    3.161692] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    3.170024] Switching to clocksource tsc
[    3.183742] pnp: PnP ACPI init
[    3.186998] ACPI: bus type pnp registered
[    3.208023] pnp 00:01: disabling [io  0x0800-0x085f] because it overlaps 0000:00:1f.0 BAR 7 [io  0x0800-0x087f]
[    3.218418] pnp 00:01: disabling [io  0x0860-0x08ff] because it overlaps 0000:00:1f.0 BAR 7 [io  0x0800-0x087f]
[    3.293516] pnp: PnP ACPI: found 12 devices
[    3.297879] ACPI: ACPI bus type pnp unregistered
[    3.302680] system 00:01: [io  0x0c00-0x0c7f] has been reserved
[    3.314171] pci 0000:00:1c.0: BAR 9: assigned [mem 0xf0000000-0xf01fffff 64bit pref]
[    3.322237] pci 0000:00:1c.5: BAR 9: assigned [mem 0xf0200000-0xf03fffff 64bit pref]
[    3.330300] pci 0000:00:1c.0: BAR 7: assigned [io  0x1000-0x1fff]
[    3.336565] pci 0000:00:1c.5: BAR 7: assigned [io  0x2000-0x2fff]
[    3.342830] pci 0000:00:1f.2: BAR 5: assigned [mem 0x000a0000-0x000a07ff]
[    3.349790] pci 0000:00:1f.2: BAR 5: set to [mem 0x000a0000-0x000a07ff] (PCI address [0xa0000-0xa07ff]
[    3.360179] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    3.365578] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    3.371844] pci 0000:00:01.0:   bridge window [mem 0xfa000000-0xfdefffff]
[    3.378803] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    3.386857] pci 0000:00:06.0: PCI bridge to [bus 02-02]
[    3.392260] pci 0000:00:06.0:   bridge window [io  disabled]
[    3.398102] pci 0000:00:06.0:   bridge window [mem disabled]
[    3.403935] pci 0000:00:06.0:   bridge window [mem pref disabled]
[    3.410211] pci 0000:00:1c.0: PCI bridge to [bus 03-03]
[    3.415610] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    3.421878] pci 0000:00:1c.0:   bridge window [mem 0xf9f00000-0xf9ffffff]
[    3.428837] pci 0000:00:1c.0:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
[    3.436894] pci 0000:00:1c.5: PCI bridge to [bus 04-04]
[    3.442295] pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
[    3.448561] pci 0000:00:1c.5:   bridge window [mem 0xf9e00000-0xf9efffff]
[    3.455520] pci 0000:00:1c.5:   bridge window [mem 0xf0200000-0xf03fffff 64bit pref]
[    3.463576] pci 0000:00:1e.0: PCI bridge to [bus 05-05]
[    3.468973] pci 0000:00:1e.0:   bridge window [io  disabled]
[    3.474808] pci 0000:00:1e.0:   bridge window [mem 0xf9d00000-0xf9dfffff]
[    3.481767] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    3.488049] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.494927] pci 0000:00:06.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.501806] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.508690] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.515661] NET: Registered protocol family 2
[    3.520411] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    3.529416] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    3.542003] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    3.549527] TCP: Hash tables configured (established 524288 bind 65536)
[    3.556315] TCP reno registered
[    3.559648] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    3.566012] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    3.572927] NET: Registered protocol family 1
[    3.577700] RPC: Registered udp transport module.
[    3.582583] RPC: Registered tcp transport module.
[    3.587463] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    4.706018] pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
[    4.713415] Trying to unpack rootfs image as initramfs...
[    4.783612] Freeing initrd memory: 3464k freed
[    4.789242] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    4.795854] Placing 64MB software IO TLB between ffff880001fdb000 - ffff880005fdb000
[    4.803893] software IO TLB at phys 0x1fdb000 - 0x5fdb000
[    4.809719] Simple Boot Flag at 0x7a set to 0x1
[    4.816694] microcode: CPU0 sig=0x6fb, pf=0x10, revision=0xb3
[    4.822621] microcode: CPU1 sig=0x6fb, pf=0x10, revision=0xb3
[    4.828542] microcode: CPU2 sig=0x6fb, pf=0x10, revision=0xb3
[    4.834458] microcode: CPU3 sig=0x6fb, pf=0x10, revision=0xb3
[    4.844024] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    4.853529] audit: initializing netlink socket (disabled)
[    4.859111] type=2000 audit(1270857303.859:1): initialized
[    4.884577] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.895294] VFS: Disk quotas dquot_6.5.2
[    4.899502] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    4.907401] msgmni has been set to 11828
[    4.912353] alg: No test for stdrng (krng)
[    4.916786] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    4.924497] io scheduler noop registered
[    4.928589] io scheduler deadline registered
[    4.933201] io scheduler cfq registered (default)
[    4.939255] pcieport 0000:00:01.0: Requesting control of PCIe PME from ACPI BIOS
[    4.946965] pcieport 0000:00:01.0: Failed to receive control of PCIe PME service: no _OSC support
[    4.956133] pcie_pme: probe of 0000:00:01.0:pcie01 failed with error -13
[    4.962999] pcieport 0000:00:06.0: Requesting control of PCIe PME from ACPI BIOS
[    4.970695] pcieport 0000:00:06.0: Failed to receive control of PCIe PME service: no _OSC support
[    4.979864] pcie_pme: probe of 0000:00:06.0:pcie01 failed with error -13
[    4.986729] pcieport 0000:00:1c.0: Requesting control of PCIe PME from ACPI BIOS
[    4.994444] pcieport 0000:00:1c.0: Failed to receive control of PCIe PME service: no _OSC support
[    5.003611] pcie_pme: probe of 0000:00:1c.0:pcie01 failed with error -13
[    5.010477] pcieport 0000:00:1c.5: Requesting control of PCIe PME from ACPI BIOS
[    5.018178] pcieport 0000:00:1c.5: Failed to receive control of PCIe PME service: no _OSC support
[    5.027365] pcie_pme: probe of 0000:00:1c.5:pcie01 failed with error -13
[    5.034367] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    5.040571] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    5.049245] ACPI: Power Button [VBTN]
[    5.053187] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    5.060888] ACPI: Power Button [PWRF]
[    5.165045] Non-volatile memory driver v1.3
[    5.169408] Linux agpgart interface v0.103
[    5.173908] [drm] Initialized drm 1.1.0 20060810
[    5.178694] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
[    5.186481] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
ÿ[    5.437337] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    5.444151] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    5.452860] brd: module loaded
[    5.457468] loop: module loaded
[    5.460916] Loading iSCSI transport class v2.0-870.
[    5.466610] ahci 0000:00:1f.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
[    5.473570] ahci 0000:00:1f.2: BAR 5: can't reserve [mem 0x000a0000-0x000a07ff]
[    5.481192] ahci: probe of 0000:00:1f.2 failed with error -16
[    5.487175] Intel(R) PRO/1000 Network Driver - version 7.3.21-k5-NAPI
[    5.493788] Copyright (c) 1999-2006 Intel Corporation.
[    5.499168] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    5.505433] e100: Copyright(c) 1999-2006 Intel Corporation
[    5.511176] tg3.c:v3.108 (February 17, 2010)
[    5.515625] tg3 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    5.532518] tg3 0000:04:00.0: eth0: Tigon3 [partno(BCM95754) rev b002] (PCI Express) MAC address 00:1e:c9:3c:35:1e
[    5.543169] tg3 0000:04:00.0: eth0: attached PHY is 5787 (10/100/1000Base-T Ethernet) (WireSpeed[1])
[    5.552595] tg3 0000:04:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    5.560811] tg3 0000:04:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    5.567831] sky2: driver version 1.27
[    5.571882] console [netcon0] enabled
[    5.575722] netconsole: network logging started
[    5.580654] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.587371] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    5.594681] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    5.600181] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    5.607915] ehci_hcd 0000:00:1a.7: debug port 1
[    5.616516] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfdffbc00
[    5.632068] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    5.638012] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    5.644964] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.652485] usb usb1: Product: EHCI Host Controller
[    5.657529] usb usb1: Manufacturer: Linux 2.6.34-rc3-00411-g9e969ac ehci_hcd
[    5.664740] usb usb1: SerialNumber: 0000:00:1a.7
[    5.669727] hub 1-0:1.0: USB hub found
[    5.673649] hub 1-0:1.0: 6 ports detected
[    5.677901] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    5.685220] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    5.690700] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    5.698438] ehci_hcd 0000:00:1d.7: debug port 1
[    5.707052] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xff980800
[    5.722067] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    5.728011] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    5.734962] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.742483] usb usb2: Product: EHCI Host Controller
[    5.747528] usb usb2: Manufacturer: Linux 2.6.34-rc3-00411-g9e969ac ehci_hcd
[    5.754740] usb usb2: SerialNumber: 0000:00:1d.7
[    5.759711] hub 2-0:1.0: USB hub found
[    5.763633] hub 2-0:1.0: 6 ports detected
[    5.767938] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.774376] uhci_hcd: USB Universal Host Controller Interface driver
[    5.781044] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.788348] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    5.793830] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    5.801534] uhci_hcd 0000:00:1a.0: detected 2 ports
[    5.806607] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000ff20
[    5.812551] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    5.819503] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.827025] usb usb3: Product: UHCI Host Controller
[    5.832071] usb usb3: Manufacturer: Linux 2.6.34-rc3-00411-g9e969ac uhci_hcd
[    5.839292] usb usb3: SerialNumber: 0000:00:1a.0
[    5.844261] hub 3-0:1.0: USB hub found
[    5.848193] hub 3-0:1.0: 2 ports detected
[    5.852434] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    5.859738] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    5.865247] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    5.872968] uhci_hcd 0000:00:1a.1: detected 2 ports
[    5.878042] uhci_hcd 0000:00:1a.1: irq 17, io base 0x0000ff00
[    5.883986] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    5.890938] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.898471] usb usb4: Product: UHCI Host Controller
[    5.903515] usb usb4: Manufacturer: Linux 2.6.34-rc3-00411-g9e969ac uhci_hcd
[    5.910726] usb usb4: SerialNumber: 0000:00:1a.1
[    5.915693] hub 4-0:1.0: USB hub found
[    5.919614] hub 4-0:1.0: 2 ports detected
[    5.923858] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    5.931173] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    5.936651] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    5.944366] uhci_hcd 0000:00:1a.2: detected 2 ports
[    5.949430] uhci_hcd 0000:00:1a.2: irq 22, io base 0x0000ecc0
[    5.955411] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    5.962365] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.969886] usb usb5: Product: UHCI Host Controller
[    5.974932] usb usb5: Manufacturer: Linux 2.6.34-rc3-00411-g9e969ac uhci_hcd
[    5.982155] usb usb5: SerialNumber: 0000:00:1a.2
[    5.987186] hub 5-0:1.0: USB hub found
[    5.991113] hub 5-0:1.0: 2 ports detected
[    5.995372] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    6.002678] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    6.008165] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    6.015879] uhci_hcd 0000:00:1d.0: detected 2 ports
[    6.020949] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000ff80
[    6.026896] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    6.033849] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.041381] usb usb6: Product: UHCI Host Controller
[    6.046427] usb usb6: Manufacturer: Linux 2.6.34-rc3-00411-g9e969ac uhci_hcd
[    6.053638] usb usb6: SerialNumber: 0000:00:1d.0
[    6.058611] hub 6-0:1.0: USB hub found
[    6.062536] hub 6-0:1.0: 2 ports detected
[    6.066786] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    6.074092] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    6.079575] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    6.087292] uhci_hcd 0000:00:1d.1: detected 2 ports
[    6.092364] uhci_hcd 0000:00:1d.1: irq 17, io base 0x0000ff60
[    6.098343] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    6.105304] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.112825] usb usb7: Product: UHCI Host Controller
[    6.117870] usb usb7: Manufacturer: Linux 2.6.34-rc3-00411-g9e969ac uhci_hcd
[    6.125081] usb usb7: SerialNumber: 0000:00:1d.1
[    6.130066] hub 7-0:1.0: USB hub found
[    6.133992] hub 7-0:1.0: 2 ports detected
[    6.138258] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.145562] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    6.151042] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    6.158749] uhci_hcd 0000:00:1d.2: detected 2 ports
[    6.167443] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000ff40
[    6.173392] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    6.180345] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.187866] usb usb8: Product: UHCI Host Controller
[    6.192911] usb usb8: Manufacturer: Linux 2.6.34-rc3-00411-g9e969ac uhci_hcd
[    6.200122] usb usb8: SerialNumber: 0000:00:1d.2
[    6.205127] hub 8-0:1.0: USB hub found
[    6.209053] hub 8-0:1.0: 2 ports detected
[    6.213446] usbcore: registered new interface driver usblp
[    6.219101] Initializing USB Mass Storage driver...
[    6.224250] usbcore: registered new interface driver usb-storage
[    6.230434] USB Mass Storage support registered.
[    6.235321] usbcore: registered new interface driver libusual
[    6.241427] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    6.251889] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.257032] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.262436] mice: PS/2 mouse device common for all mice
[    6.268205] rtc_cmos 00:05: RTC can wake from S4
[    6.273095] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    6.279387] rtc0: alarms up to one day, 242 bytes nvram, hpet irqs
[    6.285824] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 20 (level, low) -> IRQ 20
[    6.294015] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
[    6.302969] cpuidle: using governor ladder
[    6.307257] cpuidle: using governor menu
[    6.310682] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    6.320292] No iBFT detected.
[    6.325425] usbcore: registered new interface driver hiddev
[    6.331256] usbcore: registered new interface driver usbhid
[    6.337009] usbhid: USB HID core driver
modprobe: FATAL: Could not load /lib/modules/2.6.34-rc3-00411-g9e969ac/modules.dep: No such file or directory

[    6.355139] modprobe used greatest stack depth: 5840 bytes left
[    6.361316] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.443231] usb 7-2: new low speed USB device using uhci_hcd and address 2
[    6.507523] logips2pp: Detected unknown logitech mouse model 89
[    6.597287] usb 7-2: New USB device found, idVendor=0430, idProduct=0005
[    6.604170] usb 7-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    6.628613] input: HID 0430:0005 as /devices/pci0000:00/0000:00:1d.1/usb7/7-2/7-2:1.0/input/input3
[    6.638022] generic-usb 0003:0430:0005.0001: input,hidraw0: USB HID v1.00 Keyboard [HID 0430:0005] on usb-0000:00:1d.1-2/input0
[    6.739042] ALSA device list:
[    6.742193]   #0: HDA Intel at 0xfdffc000 irq 28
[    6.747032] Netfilter messages via NETLINK v0.30.
[    6.751919] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    6.758391] ctnetlink v0.93: registering with nfnetlink.
[    6.764296] ip_tables: (C) 2000-2006 Netfilter Core Team
[    6.769808] TCP cubic registered
[    6.773208] Initializing XFRM netlink socket
[    6.778110] NET: Registered protocol family 10
[    6.783441] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    6.789052] IPv6 over IPv4 tunneling driver
[    6.793928] NET: Registered protocol family 17
[    6.798843] registered taskstats version 1
[    6.803368]   Magic number: 6:993:958
[    6.807243] mem oldmem: hash matches
[    6.811163] Freeing unused kernel memory: 612k freed
[    6.816449] Write protecting the kernel read-only data: 10240k
[    6.822639] Freeing unused kernel memory: 744k freed
[    6.828085] Freeing unused kernel memory: 1588k freed

-andy
