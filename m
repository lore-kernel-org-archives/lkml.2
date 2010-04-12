Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab0DLUC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 16:02:28 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:59811 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab0DLUCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 16:02:24 -0400
Date: Mon, 12 Apr 2010 13:02:24 -0700
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
Message-ID: <20100412200224.GO11130@hexapodia.org>
References: <20100409223532.GC11130@hexapodia.org> <4BBFB1D8.6090802@oracle.com> <20100410000030.GE11130@hexapodia.org> <4BBFD019.9040405@oracle.com> <20100410014308.GG11130@hexapodia.org> <4BBFD8EF.6020108@oracle.com> <20100410015711.GH11130@hexapodia.org> <4BBFE66C.2040603@oracle.com> <20100412185416.GA19959@hexapodia.org> <4BC375D9.4040503@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC375D9.4040503@oracle.com>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 12:34:49PM -0700, Yinghai wrote:
> [PATCH] x86,pci, acpi: Inherent BUSY flag when setup_resource for root bus
> 
> So make pci root resource from _CRS honor the range We reserve in e820 below 1M
> then  will not assign them to unsigned pci BAR
> 
> -v2: let pci_bus_alloc_resource() honor IORESOURCE_BUSY
>      driver can not use those range, so skip it
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/pci/acpi.c |    4 ++++
>  drivers/pci/bus.c   |    4 ++++
>  2 files changed, 8 insertions(+)

Success:


[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.34-rc3-00412-gbb33c1c (andy@farthing) (gcc version 4.3.3 (Debian 4.3.3-5) ) #14 SMP Mon Apr 12 12:52:26 PDT 2010
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.34-rc3-00412-gbb33c1c root=UUID=a2359eda-9295-451c-924f-c181c6f49d0d ro
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
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x1bc000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask 000000000 write-back
[    0.000000]   1 base 0BFF00000 mask FFFF00000 uncachable
[    0.000000]   2 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000bff00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbfe01 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000fe710] fe710
[    0.000000] init_memory_mapping: 0000000000000000-00000000bfe01000
[    0.000000]  0000000000 - 00bfe00000 page 2M
[    0.000000]  00bfe00000 - 00bfe01000 page 4k
[    0.000000] kernel direct mapping tables up to bfe01000 @ 8000-d000
[    0.000000] init_memory_mapping: 0000000100000000-00000001bc000000
[    0.000000]  0100000000 - 01bc000000 page 2M
[    0.000000] kernel direct mapping tables up to 1bc000000 @ b000-13000
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
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-00000001bc000000
[    0.000000] Initmem setup node 0 0000000000000000-00000001bc000000
[    0.000000]   NODE_DATA [0000000100000000 - 0000000100004fff]
[    0.000000]  [ffffea0000000000-ffffea00061fffff] PMD -> [ffff880100200000-ffff8801055fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x001bc000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bfe01
[    0.000000]     0: 0x00100000 -> 0x001bc000
[    0.000000] On node 0 totalpages: 1555870
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3941 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 767545 pages, LIFO batch:31
[    0.000000]   Normal zone: 10528 pages used for memmap
[    0.000000]   Normal zone: 759520 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
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
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] early_res array is doubled to 64 at [7000 - 77ff]
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
[    0.000000] early_res array is doubled to 128 at [e000 - efff]
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1531006
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.34-rc3-00412-gbb33c1c root=UUID=a2359eda-9295-451c-924f-c181c6f49d0d ro
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
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
[    0.000000]   #40 [0001de33c0 - 0001de3420]         BOOTMEM
[    0.000000]   #41 [0001de3440 - 0001de34a0]         BOOTMEM
[    0.000000]   #42 [0001e00000 - 0001e1b000]         BOOTMEM
[    0.000000]   #43 [0001e40000 - 0001e5b000]         BOOTMEM
[    0.000000]   #44 [0001e80000 - 0001e9b000]         BOOTMEM
[    0.000000]   #45 [0001ec0000 - 0001edb000]         BOOTMEM
[    0.000000]   #46 [0001f00000 - 0001f1b000]         BOOTMEM
[    0.000000]   #47 [0001f40000 - 0001f5b000]         BOOTMEM
[    0.000000]   #48 [0001f80000 - 0001f9b000]         BOOTMEM
[    0.000000]   #49 [0001fc0000 - 0001fdb000]         BOOTMEM
[    0.000000]   #50 [0001de34c0 - 0001de34c8]         BOOTMEM
[    0.000000]   #51 [0001de3500 - 0001de3508]         BOOTMEM
[    0.000000]   #52 [0001de3540 - 0001de3560]         BOOTMEM
[    0.000000]   #53 [0001de3580 - 0001de35c0]         BOOTMEM
[    0.000000]   #54 [0001de35c0 - 0001de36e0]         BOOTMEM
[    0.000000]   #55 [0001de3700 - 0001de3748]         BOOTMEM
[    0.000000]   #56 [0001de3780 - 0001de37c8]         BOOTMEM
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
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2393.738 MHz processor.
[    0.001006] Calibrating delay loop (skipped), value calculated using timer frequency.. 4787.47 BogoMIPS (lpj=2393738)
[    0.002022] Security Framework initialized
[    0.002217] SELinux:  Initializing.
[    0.002416] SELinux:  Starting in permissive mode
[    0.003158] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.008145] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.010765] Mount-cache hash table entries: 256
[    0.011152] Initializing cgroup subsys ns
[    0.011348] Initializing cgroup subsys cpuacct
[    0.011545] Initializing cgroup subsys blkio
[    0.011767] CPU: Physical Processor ID: 0
[    0.012004] CPU: Processor Core ID: 0
[    0.012197] using mwait in idle threads.
[    0.013002] Performance Events: Core2 events, Intel PMU driver.
[    0.013291] ... version:                2
[    0.013483] ... bit width:              40
[    0.013675] ... generic registers:      2
[    0.013867] ... value mask:             000000ffffffffff
[    0.014002] ... max period:             000000007fffffff
[    0.014195] ... fixed-purpose events:   3
[    0.014387] ... event mask:             0000000700000003
[    0.014619] ACPI: Core revision 20100121
[    0.181067] Setting APIC routing to flat
[    0.181729] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.192154] CPU0: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
[    0.192999] Booting Node   0, Processors  #1 #2 #3
[    0.408006] Brought up 4 CPUs
[    0.408403] Total of 4 processors activated (19150.78 BogoMIPS).
[    0.409106] khelper used greatest stack depth: 6008 bytes left
[    0.410564] Time: 19:55:10  Date: 04/12/10
[    0.410789] NET: Registered protocol family 16
[    0.411036] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.411364] ACPI: bus type pci registered
[    0.412042] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.412361] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.434110] PCI: Using configuration type 1 for base access
[    0.446023] bio: create slab <bio-0> at 0
[    0.447363] ACPI: EC: Look up EC in DSDT
[    0.475505] ACPI: BIOS _OSI(Linux) query ignored
[    0.502249] ACPI: Interpreter enabled
[    0.502443] ACPI: (supports S0 S1 S3 S4 S5)
[    0.502895] ACPI: Using IOAPIC for interrupt routing
[    0.628105] ACPI Warning: Incorrect checksum in table [TCPA] - 00, should be 87 (20100121/tbutils-314)
[    0.628632] ACPI: No dock devices found.
[    0.628844] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.637381] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.654879] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.655002] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.655217] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.655557] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000effff]
[    0.655895] pci_root PNP0A03:00: host bridge window [mem 0x000f0000-0x000fffff]
[    0.656002] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfebfffff]
[    0.656341] pci_root PNP0A03:00: host bridge window [mem 0xbff00000-0xdfffffff]
[    0.657001] pci_root PNP0A03:00: host bridge window [mem 0xff980800-0xff980bff]
[    0.657359] pci_root PNP0A03:00: host bridge window [mem 0xff97c000-0xff97ffff]
[    0.657699] pci_root PNP0A03:00: host bridge window [mem 0xfed20000-0xfed9ffff]
[    0.658067] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.658069] pci 0000:00:01.0: PME# disabled
[    0.658108] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.658111] pci 0000:00:06.0: PME# disabled
[    0.658172] pci 0000:00:1a.0: reg 20: [io  0xff20-0xff3f]
[    0.658254] pci 0000:00:1a.1: reg 20: [io  0xff00-0xff1f]
[    0.658333] pci 0000:00:1a.2: reg 20: [io  0xecc0-0xecdf]
[    0.658393] pci 0000:00:1a.7: reg 10: [mem 0xfdffbc00-0xfdffbfff]
[    0.658445] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.658449] pci 0000:00:1a.7: PME# disabled
[    0.658480] pci 0000:00:1b.0: reg 10: [mem 0xfdffc000-0xfdffffff 64bit]
[    0.658519] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.658522] pci 0000:00:1b.0: PME# disabled
[    0.658581] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.658585] pci 0000:00:1c.0: PME# disabled
[    0.658649] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.658652] pci 0000:00:1c.5: PME# disabled
[    0.658707] pci 0000:00:1d.0: reg 20: [io  0xff80-0xff9f]
[    0.658786] pci 0000:00:1d.1: reg 20: [io  0xff60-0xff7f]
[    0.658865] pci 0000:00:1d.2: reg 20: [io  0xff40-0xff5f]
[    0.658932] pci 0000:00:1d.7: reg 10: [mem 0xff980800-0xff980bff]
[    0.659046] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.659050] pci 0000:00:1d.7: PME# disabled
[    0.659158] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
[    0.659518] pci 0000:00:1f.0: quirk: [io  0x0880-0x08bf] claimed by ICH6 GPIO
[    0.659716] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0c00 (mask 007f)
[    0.660002] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 00e0 (mask 0007)
[    0.660412] pci 0000:00:1f.2: reg 10: [io  0xfe00-0xfe07]
[    0.660418] pci 0000:00:1f.2: reg 14: [io  0xfe10-0xfe13]
[    0.660423] pci 0000:00:1f.2: reg 18: [io  0xfe20-0xfe27]
[    0.660428] pci 0000:00:1f.2: reg 1c: [io  0xfe30-0xfe33]
[    0.660433] pci 0000:00:1f.2: reg 20: [io  0xfec0-0xfedf]
[    0.660439] pci 0000:00:1f.2: reg 24: [mem 0xff970000-0xff9707ff]
[    0.660469] pci 0000:00:1f.2: PME# supported from D3hot
[    0.660472] pci 0000:00:1f.2: PME# disabled
[    0.660498] pci 0000:00:1f.3: reg 10: [mem 0xfdffbb00-0xfdffbbff 64bit]
[    0.660510] pci 0000:00:1f.3: reg 20: [io  0xece0-0xecff]
[    0.660566] pci 0000:01:00.0: reg 10: [mem 0xfc000000-0xfcffffff]
[    0.660575] pci 0000:01:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.660583] pci 0000:01:00.0: reg 1c: [mem 0xfa000000-0xfbffffff 64bit]
[    0.660588] pci 0000:01:00.0: reg 24: [io  0xdc80-0xdcff]
[    0.660593] pci 0000:01:00.0: reg 30: [mem 0xfde00000-0xfde1ffff pref]
[    0.660621] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.660816] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.660819] pci 0000:00:01.0:   bridge window [mem 0xfa000000-0xfdefffff]
[    0.660823] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.660848] pci 0000:00:06.0: PCI bridge to [bus 02-02]
[    0.661002] pci 0000:00:06.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.661005] pci 0000:00:06.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.661009] pci 0000:00:06.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.661047] pci 0000:00:1c.0: PCI bridge to [bus 03-03]
[    0.661254] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.661258] pci 0000:00:1c.0:   bridge window [mem 0xf9f00000-0xf9ffffff]
[    0.661263] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.661349] pci 0000:04:00.0: reg 10: [mem 0xf9ef0000-0xf9efffff 64bit]
[    0.661424] pci 0000:04:00.0: PME# supported from D3hot D3cold
[    0.661429] pci 0000:04:00.0: PME# disabled
[    0.661443] pci 0000:00:1c.5: PCI bridge to [bus 04-04]
[    0.661639] pci 0000:00:1c.5:   bridge window [io  0xf000-0x0000] (disabled)
[    0.661643] pci 0000:00:1c.5:   bridge window [mem 0xf9e00000-0xf9efffff]
[    0.661648] pci 0000:00:1c.5:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.661694] pci 0000:05:04.0: reg 10: [mem 0xf9dff000-0xf9dfffff]
[    0.661738] pci 0000:05:04.0: supports D1 D2
[    0.661739] pci 0000:05:04.0: PME# supported from D0 D1 D2 D3hot
[    0.661743] pci 0000:05:04.0: PME# disabled
[    0.661782] pci 0000:00:1e.0: PCI bridge to [bus 05-05] (subtractive decode)
[    0.662003] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.662007] pci 0000:00:1e.0:   bridge window [mem 0xf9d00000-0xf9dfffff]
[    0.662012] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.662015] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.662017] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.662019] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.662022] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000effff] (subtractive decode)
[    0.662024] pci 0000:00:1e.0:   bridge window [mem 0x000f0000-0x000fffff] (subtractive decode)
[    0.662027] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
[    0.662029] pci 0000:00:1e.0:   bridge window [mem 0xbff00000-0xdfffffff] (subtractive decode)
[    0.662031] pci 0000:00:1e.0:   bridge window [mem 0xff980800-0xff980bff] (subtractive decode)
[    0.662034] pci 0000:00:1e.0:   bridge window [mem 0xff97c000-0xff97ffff] (subtractive decode)
[    0.662036] pci 0000:00:1e.0:   bridge window [mem 0xfed20000-0xfed9ffff] (subtractive decode)
[    0.662056] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.662568] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI4._PRT]
[    0.663071] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2._PRT]
[    0.663477] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.663837] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI6._PRT]
[    1.970610] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 15)
[    1.972277] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 15)
[    1.973780] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 9 10 11 12 15)
[    1.975382] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
[    1.977173] ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 6 7 9 10 11 12 15)
[    1.978710] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
[    1.980526] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 15)
[    1.982085] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    1.983047] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    1.983365] vgaarb: loaded
[    1.984008] SCSI subsystem initialized
[    1.984240] libata version 3.00 loaded.
[    1.984240] usbcore: registered new interface driver usbfs
[    1.984240] usbcore: registered new interface driver hub
[    1.985025] usbcore: registered new device driver usb
[    1.985219] Advanced Linux Sound Architecture Driver Version 1.0.22.1.
[    1.986002] PCI: Using ACPI for IRQ routing
[    1.986216] PCI: pci_cache_line_size set to 64 bytes
[    1.986251] pci 0000:00:1f.2: no compatible bridge window for [mem 0xff970000-0xff9707ff]
[    1.986632] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    1.986828] reserve RAM buffer: 000000000009ec00 - 000000000009ffff 
[    1.986831] reserve RAM buffer: 00000000bfe01c00 - 00000000bfffffff 
[    1.987056] cfg80211: Calling CRDA to update world regulatory domain
[    1.987220] NetLabel: Initializing
[    1.987220] NetLabel:  domain hash size = 128
[    1.987401] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.988011] NetLabel:  unlabeled traffic allowed by default
[    1.988228] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    1.988426] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    1.988849] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    1.993022] Switching to clocksource tsc
[    2.002646] pnp: PnP ACPI init
[    2.002859] ACPI: bus type pnp registered
[    2.019932] pnp 00:01: disabling [io  0x0800-0x085f] because it overlaps 0000:00:1f.0 BAR 7 [io  0x0800-0x087f]
[    2.020289] pnp 00:01: disabling [io  0x0860-0x08ff] because it overlaps 0000:00:1f.0 BAR 7 [io  0x0800-0x087f]
[    2.085362] pnp: PnP ACPI: found 12 devices
[    2.085564] ACPI: ACPI bus type pnp unregistered
[    2.085774] system 00:01: [io  0x0c00-0x0c7f] has been reserved
[    2.091330] PCI: max bus depth: 1 pci_try_num: 2
[    2.091368] pci 0000:00:1c.0: BAR 9: assigned [mem 0xf0000000-0xf01fffff 64bit pref]
[    2.091709] pci 0000:00:1c.5: BAR 9: assigned [mem 0xf0200000-0xf03fffff 64bit pref]
[    2.092053] pci 0000:00:1c.0: BAR 7: assigned [io  0x1000-0x1fff]
[    2.092259] pci 0000:00:1c.5: BAR 7: assigned [io  0x2000-0x2fff]
[    2.092454] pci 0000:00:1f.2: BAR 5: assigned [mem 0xf0400000-0xf04007ff]
[    2.092652] pci 0000:00:1f.2: BAR 5: set to [mem 0xf0400000-0xf04007ff] (PCI address [0xf0400000-0xf04007ff]
[    2.092994] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    2.093202] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    2.093399] pci 0000:00:01.0:   bridge window [mem 0xfa000000-0xfdefffff]
[    2.093595] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    2.093936] pci 0000:00:06.0: PCI bridge to [bus 02-02]
[    2.094144] pci 0000:00:06.0:   bridge window [io  disabled]
[    2.094339] pci 0000:00:06.0:   bridge window [mem disabled]
[    2.094534] pci 0000:00:06.0:   bridge window [mem pref disabled]
[    2.094731] pci 0000:00:1c.0: PCI bridge to [bus 03-03]
[    2.094926] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    2.095136] pci 0000:00:1c.0:   bridge window [mem 0xf9f00000-0xf9ffffff]
[    2.095334] pci 0000:00:1c.0:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
[    2.095676] pci 0000:00:1c.5: PCI bridge to [bus 04-04]
[    2.095871] pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
[    2.096078] pci 0000:00:1c.5:   bridge window [mem 0xf9e00000-0xf9efffff]
[    2.096280] pci 0000:00:1c.5:   bridge window [mem 0xf0200000-0xf03fffff 64bit pref]
[    2.096623] pci 0000:00:1e.0: PCI bridge to [bus 05-05]
[    2.096817] pci 0000:00:1e.0:   bridge window [io  disabled]
[    2.097018] pci 0000:00:1e.0:   bridge window [mem 0xf9d00000-0xf9dfffff]
[    2.097224] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    2.097431] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.097628] pci 0000:00:01.0: setting latency timer to 64
[    2.097633] pci 0000:00:06.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.097830] pci 0000:00:06.0: setting latency timer to 64
[    2.097837] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.098036] pci 0000:00:1c.0: setting latency timer to 64
[    2.098045] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.098251] pci 0000:00:1c.5: setting latency timer to 64
[    2.098257] pci 0000:00:1e.0: setting latency timer to 64
[    2.098261] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.098263] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.098265] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.098266] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000effff]
[    2.098268] pci_bus 0000:00: resource 8 [mem 0x000f0000-0x000fffff]
[    2.098270] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfebfffff]
[    2.098272] pci_bus 0000:00: resource 10 [mem 0xbff00000-0xdfffffff]
[    2.098274] pci_bus 0000:00: resource 11 [mem 0xff980800-0xff980bff]
[    2.098276] pci_bus 0000:00: resource 12 [mem 0xff97c000-0xff97ffff]
[    2.098278] pci_bus 0000:00: resource 13 [mem 0xfed20000-0xfed9ffff]
[    2.098281] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    2.098282] pci_bus 0000:01: resource 1 [mem 0xfa000000-0xfdefffff]
[    2.098285] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    2.098287] pci_bus 0000:03: resource 0 [io  0x1000-0x1fff]
[    2.098289] pci_bus 0000:03: resource 1 [mem 0xf9f00000-0xf9ffffff]
[    2.098291] pci_bus 0000:03: resource 2 [mem 0xf0000000-0xf01fffff 64bit pref]
[    2.098293] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
[    2.098295] pci_bus 0000:04: resource 1 [mem 0xf9e00000-0xf9efffff]
[    2.098297] pci_bus 0000:04: resource 2 [mem 0xf0200000-0xf03fffff 64bit pref]
[    2.098299] pci_bus 0000:05: resource 1 [mem 0xf9d00000-0xf9dfffff]
[    2.098301] pci_bus 0000:05: resource 4 [io  0x0000-0x0cf7]
[    2.098303] pci_bus 0000:05: resource 5 [io  0x0d00-0xffff]
[    2.098305] pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff]
[    2.098306] pci_bus 0000:05: resource 7 [mem 0x000c0000-0x000effff]
[    2.098308] pci_bus 0000:05: resource 8 [mem 0x000f0000-0x000fffff]
[    2.098310] pci_bus 0000:05: resource 9 [mem 0xf0000000-0xfebfffff]
[    2.098312] pci_bus 0000:05: resource 10 [mem 0xbff00000-0xdfffffff]
[    2.098314] pci_bus 0000:05: resource 11 [mem 0xff980800-0xff980bff]
[    2.098316] pci_bus 0000:05: resource 12 [mem 0xff97c000-0xff97ffff]
[    2.098318] pci_bus 0000:05: resource 13 [mem 0xfed20000-0xfed9ffff]
[    2.098345] NET: Registered protocol family 2
[    2.098745] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    2.100439] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    2.105559] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    2.106402] TCP: Hash tables configured (established 524288 bind 65536)
[    2.106599] TCP reno registered
[    2.106804] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    2.107100] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    2.107521] NET: Registered protocol family 1
[    2.107935] RPC: Registered udp transport module.
[    2.108144] RPC: Registered tcp transport module.
[    2.108337] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.108553] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x0f10
[    2.108555] pci 0000:00:1a.0: Performing full reset
[    2.108573] pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x0010
[    2.108575] pci 0000:00:1a.1: Performing full reset
[    2.108591] pci 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x2000
[    2.108593] pci 0000:00:1a.2: Performing full reset
[    2.108625] pci 0000:00:1a.7: EHCI: BIOS handoff
[    2.119042] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x001b
[    2.119045] pci 0000:00:1d.0: Performing full reset
[    2.119064] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0010
[    2.119067] pci 0000:00:1d.1: Performing full reset
[    2.119085] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0010
[    2.119088] pci 0000:00:1d.2: Performing full reset
[    2.119119] pci 0000:00:1d.7: EHCI: BIOS handoff
[    3.219020] pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
[    3.219352] pci 0000:01:00.0: Boot video device
[    3.219360] PCI: CLS 64 bytes, default 64
[    3.219422] Trying to unpack rootfs image as initramfs...
[    3.284926] Freeing initrd memory: 3464k freed
[    3.286232] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    3.286425] Placing 64MB software IO TLB between ffff880001fdb000 - ffff880005fdb000
[    3.286752] software IO TLB at phys 0x1fdb000 - 0x5fdb000
[    3.287188] Simple Boot Flag at 0x7a set to 0x1
[    3.289306] microcode: CPU0 sig=0x6fb, pf=0x10, revision=0xb3
[    3.289519] microcode: CPU1 sig=0x6fb, pf=0x10, revision=0xb3
[    3.289724] microcode: CPU2 sig=0x6fb, pf=0x10, revision=0xb3
[    3.289921] microcode: CPU3 sig=0x6fb, pf=0x10, revision=0xb3
[    3.290182] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    3.290886] audit: initializing netlink socket (disabled)
[    3.291103] type=2000 audit(1271102113.290:1): initialized
[    3.311115] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.315270] VFS: Disk quotas dquot_6.5.2
[    3.315550] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.317026] msgmni has been set to 11828
[    3.317367] SELinux:  Registering netfilter hooks
[    3.317972] alg: No test for stdrng (krng)
[    3.318320] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    3.322290] io scheduler noop registered
[    3.322475] io scheduler deadline registered
[    3.322819] io scheduler cfq registered (default)
[    3.323160] pcieport 0000:00:01.0: setting latency timer to 64
[    3.323186] pcieport 0000:00:01.0: irq 24 for MSI/MSI-X
[    3.323337] pcieport 0000:00:06.0: setting latency timer to 64
[    3.323365] pcieport 0000:00:06.0: irq 25 for MSI/MSI-X
[    3.323508] pcieport 0000:00:1c.0: setting latency timer to 64
[    3.323545] pcieport 0000:00:1c.0: irq 26 for MSI/MSI-X
[    3.323783] pcieport 0000:00:1c.5: setting latency timer to 64
[    3.323826] pcieport 0000:00:1c.5: irq 27 for MSI/MSI-X
[    3.324152] pcieport 0000:00:01.0: Requesting control of PCIe PME from ACPI BIOS
[    3.324494] pcieport 0000:00:01.0: Failed to receive control of PCIe PME service: no _OSC support
[    3.324823] pcie_pme: probe of 0000:00:01.0:pcie01 failed with error -13
[    3.325019] pcieport 0000:00:06.0: Requesting control of PCIe PME from ACPI BIOS
[    3.325357] pcieport 0000:00:06.0: Failed to receive control of PCIe PME service: no _OSC support
[    3.325685] pcie_pme: probe of 0000:00:06.0:pcie01 failed with error -13
[    3.325876] pcieport 0000:00:1c.0: Requesting control of PCIe PME from ACPI BIOS
[    3.326218] pcieport 0000:00:1c.0: Failed to receive control of PCIe PME service: no _OSC support
[    3.326546] pcie_pme: probe of 0000:00:1c.0:pcie01 failed with error -13
[    3.326737] pcieport 0000:00:1c.5: Requesting control of PCIe PME from ACPI BIOS
[    3.327074] pcieport 0000:00:1c.5: Failed to receive control of PCIe PME service: no _OSC support
[    3.327406] pcie_pme: probe of 0000:00:1c.5:pcie01 failed with error -13
[    3.327707] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.328322] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    3.328667] ACPI: Power Button [VBTN]
[    3.328948] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    3.329312] ACPI: Power Button [PWRF]
[    3.483371] Non-volatile memory driver v1.3
[    3.483564] Linux agpgart interface v0.103
[    3.483957] [drm] Initialized drm 1.1.0 20060810
[    3.484157] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
[    3.484485] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.729356] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.730139] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.733187] brd: module loaded
[    3.734670] loop: module loaded
[    3.734985] Loading iSCSI transport class v2.0-870.
[    3.735755] ahci 0000:00:1f.2: version 3.0
[    3.735774] ahci 0000:00:1f.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
[    3.736017] ahci 0000:00:1f.2: irq 28 for MSI/MSI-X
[    3.736090] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    3.736433] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc ems 
[    3.736762] ahci 0000:00:1f.2: setting latency timer to 64
[    3.746211] scsi0 : ahci
[    3.746597] scsi1 : ahci
[    3.746942] scsi2 : ahci
[    3.747303] scsi3 : ahci
[    3.747666] scsi4 : ahci
[    3.748020] scsi5 : ahci
[    3.748356] ata1: SATA max UDMA/133 abar m2048@0xf0400000 port 0xf0400100 irq 28
[    3.748692] ata2: SATA max UDMA/133 abar m2048@0xf0400000 port 0xf0400180 irq 28
[    3.749024] ata3: SATA max UDMA/133 abar m2048@0xf0400000 port 0xf0400200 irq 28
[    3.749361] ata4: SATA max UDMA/133 abar m2048@0xf0400000 port 0xf0400280 irq 28
[    3.749688] ata5: SATA max UDMA/133 abar m2048@0xf0400000 port 0xf0400300 irq 28
[    3.750019] ata6: SATA max UDMA/133 abar m2048@0xf0400000 port 0xf0400380 irq 28
[    3.750493] Intel(R) PRO/1000 Network Driver - version 7.3.21-k5-NAPI
[    3.750694] Copyright (c) 1999-2006 Intel Corporation.
[    3.750965] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    3.751178] e100: Copyright(c) 1999-2006 Intel Corporation
[    3.751453] tg3.c:v3.108 (February 17, 2010)
[    3.751659] tg3 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    3.751853] tg3 0000:04:00.0: setting latency timer to 64
[    3.759592] tg3 0000:04:00.0: eth0: Tigon3 [partno(BCM95754) rev b002] (PCI Express) MAC address 00:1e:c9:3c:35:1e
[    3.759922] tg3 0000:04:00.0: eth0: attached PHY is 5787 (10/100/1000Base-T Ethernet) (WireSpeed[1])
[    3.760277] tg3 0000:04:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    3.760606] tg3 0000:04:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    3.760848] sky2: driver version 1.27
[    3.761222] console [netcon0] enabled
[    3.761419] netconsole: network logging started
[    3.761832] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.762033] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    3.762053] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    3.762274] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    3.762277] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    3.762479] drivers/usb/core/inode.c: creating file 'devices'
[    3.762482] drivers/usb/core/inode.c: creating file '001'
[    3.762553] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    3.762893] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    3.762897] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
[    3.762919] ehci_hcd 0000:00:1a.7: debug port 1
[    3.763112] ehci_hcd 0000:00:1a.7: reset command 000002 (park)=0 ithresh=0 period=1024 Reset HALT
[    3.766987] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    3.766989] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    3.767003] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfdffbc00
[    3.767203] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    3.771078] ehci_hcd 0000:00:1a.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    3.777069] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    3.777294] usb usb1: default language 0x0409
[    3.777300] usb usb1: udev 1, busnum 1, minor = 0
[    3.777302] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.777491] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.777817] usb usb1: Product: EHCI Host Controller
[    3.778004] usb usb1: Manufacturer: Linux 2.6.34-rc3-00412-gbb33c1c ehci_hcd
[    3.778203] usb usb1: SerialNumber: 0000:00:1a.7
[    3.778485] usb usb1: usb_probe_device
[    3.778489] usb usb1: configuration #1 chosen from 1 choice
[    3.778498] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    3.778563] hub 1-0:1.0: usb_probe_interface
[    3.778565] hub 1-0:1.0: usb_probe_interface - got id
[    3.778572] hub 1-0:1.0: USB hub found
[    3.778765] hub 1-0:1.0: 6 ports detected
[    3.778951] hub 1-0:1.0: standalone hub
[    3.778953] hub 1-0:1.0: no power switching (usb 1.0)
[    3.778954] hub 1-0:1.0: individual port over-current protection
[    3.778956] hub 1-0:1.0: power on to power good time: 20ms
[    3.778960] hub 1-0:1.0: local power source is good
[    3.778962] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    3.778986] drivers/usb/core/inode.c: creating file '001'
[    3.779026] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.779238] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    3.779241] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    3.779432] drivers/usb/core/inode.c: creating file '002'
[    3.779502] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    3.779841] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    3.779845] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
[    3.779863] ehci_hcd 0000:00:1d.7: debug port 1
[    3.780051] ehci_hcd 0000:00:1d.7: reset command 010002 (park)=0 ithresh=1 period=1024 Reset HALT
[    3.783927] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    3.783929] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    3.783939] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xff980800
[    3.784132] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    3.788014] ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    3.793058] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    3.793290] usb usb2: default language 0x0409
[    3.793296] usb usb2: udev 1, busnum 2, minor = 128
[    3.793297] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    3.793486] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.793812] usb usb2: Product: EHCI Host Controller
[    3.793998] usb usb2: Manufacturer: Linux 2.6.34-rc3-00412-gbb33c1c ehci_hcd
[    3.794192] usb usb2: SerialNumber: 0000:00:1d.7
[    3.794471] usb usb2: usb_probe_device
[    3.794475] usb usb2: configuration #1 chosen from 1 choice
[    3.794484] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    3.794548] hub 2-0:1.0: usb_probe_interface
[    3.794550] hub 2-0:1.0: usb_probe_interface - got id
[    3.794552] hub 2-0:1.0: USB hub found
[    3.794748] hub 2-0:1.0: 6 ports detected
[    3.794934] hub 2-0:1.0: standalone hub
[    3.794935] hub 2-0:1.0: no power switching (usb 1.0)
[    3.794937] hub 2-0:1.0: individual port over-current protection
[    3.794939] hub 2-0:1.0: power on to power good time: 20ms
[    3.794942] hub 2-0:1.0: local power source is good
[    3.794944] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    3.794968] drivers/usb/core/inode.c: creating file '001'
[    3.795058] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.795262] ohci_hcd: block sizes: ed 80 td 96
[    3.795323] uhci_hcd: USB Universal Host Controller Interface driver
[    3.795634] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.795834] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    3.795836] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    3.796028] drivers/usb/core/inode.c: creating file '003'
[    3.796108] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    3.796457] uhci_hcd 0000:00:1a.0: detected 2 ports
[    3.796646] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    3.796648] uhci_hcd 0000:00:1a.0: Performing full reset
[    3.796660] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    3.796670] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000ff20
[    3.796882] usb usb3: default language 0x0409
[    3.796888] usb usb3: udev 1, busnum 3, minor = 256
[    3.796890] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    3.797084] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.797419] usb usb3: Product: UHCI Host Controller
[    3.797606] usb usb3: Manufacturer: Linux 2.6.34-rc3-00412-gbb33c1c uhci_hcd
[    3.797795] usb usb3: SerialNumber: 0000:00:1a.0
[    3.798070] usb usb3: usb_probe_device
[    3.798074] usb usb3: configuration #1 chosen from 1 choice
[    3.798082] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    3.798145] hub 3-0:1.0: usb_probe_interface
[    3.798147] hub 3-0:1.0: usb_probe_interface - got id
[    3.798149] hub 3-0:1.0: USB hub found
[    3.798357] hub 3-0:1.0: 2 ports detected
[    3.798543] hub 3-0:1.0: standalone hub
[    3.798544] hub 3-0:1.0: no power switching (usb 1.0)
[    3.798546] hub 3-0:1.0: individual port over-current protection
[    3.798547] hub 3-0:1.0: power on to power good time: 2ms
[    3.798551] hub 3-0:1.0: local power source is good
[    3.798553] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    3.798565] drivers/usb/core/inode.c: creating file '001'
[    3.798590] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    3.798606] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.798798] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    3.798801] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    3.798991] drivers/usb/core/inode.c: creating file '004'
[    3.799073] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    3.799420] uhci_hcd 0000:00:1a.1: detected 2 ports
[    3.799609] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    3.799611] uhci_hcd 0000:00:1a.1: Performing full reset
[    3.799623] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[    3.799633] uhci_hcd 0000:00:1a.1: irq 17, io base 0x0000ff00
[    3.799846] usb usb4: default language 0x0409
[    3.799852] usb usb4: udev 1, busnum 4, minor = 384
[    3.799854] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    3.800043] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.800385] usb usb4: Product: UHCI Host Controller
[    3.800572] usb usb4: Manufacturer: Linux 2.6.34-rc3-00412-gbb33c1c uhci_hcd
[    3.800761] usb usb4: SerialNumber: 0000:00:1a.1
[    3.801031] usb usb4: usb_probe_device
[    3.801035] usb usb4: configuration #1 chosen from 1 choice
[    3.801043] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    3.801117] hub 4-0:1.0: usb_probe_interface
[    3.801119] hub 4-0:1.0: usb_probe_interface - got id
[    3.801120] hub 4-0:1.0: USB hub found
[    3.801323] hub 4-0:1.0: 2 ports detected
[    3.801509] hub 4-0:1.0: standalone hub
[    3.801510] hub 4-0:1.0: no power switching (usb 1.0)
[    3.801512] hub 4-0:1.0: individual port over-current protection
[    3.801513] hub 4-0:1.0: power on to power good time: 2ms
[    3.801517] hub 4-0:1.0: local power source is good
[    3.801518] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    3.801531] drivers/usb/core/inode.c: creating file '001'
[    3.801554] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
[    3.801571] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    3.801762] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    3.801765] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    3.801955] drivers/usb/core/inode.c: creating file '005'
[    3.802028] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    3.802382] uhci_hcd 0000:00:1a.2: detected 2 ports
[    3.802570] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    3.802572] uhci_hcd 0000:00:1a.2: Performing full reset
[    3.802584] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    3.802589] uhci_hcd 0000:00:1a.2: irq 22, io base 0x0000ecc0
[    3.802800] usb usb5: default language 0x0409
[    3.802806] usb usb5: udev 1, busnum 5, minor = 512
[    3.802808] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    3.802997] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.803336] usb usb5: Product: UHCI Host Controller
[    3.803523] usb usb5: Manufacturer: Linux 2.6.34-rc3-00412-gbb33c1c uhci_hcd
[    3.803712] usb usb5: SerialNumber: 0000:00:1a.2
[    3.803984] usb usb5: usb_probe_device
[    3.803987] usb usb5: configuration #1 chosen from 1 choice
[    3.803995] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    3.804074] hub 5-0:1.0: usb_probe_interface
[    3.804076] hub 5-0:1.0: usb_probe_interface - got id
[    3.804078] hub 5-0:1.0: USB hub found
[    3.804279] hub 5-0:1.0: 2 ports detected
[    3.804465] hub 5-0:1.0: standalone hub
[    3.804466] hub 5-0:1.0: no power switching (usb 1.0)
[    3.804468] hub 5-0:1.0: individual port over-current protection
[    3.804470] hub 5-0:1.0: power on to power good time: 2ms
[    3.804473] hub 5-0:1.0: local power source is good
[    3.804475] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    3.804488] drivers/usb/core/inode.c: creating file '001'
[    3.804511] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.2
[    3.804528] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.804719] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.804722] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.804913] drivers/usb/core/inode.c: creating file '006'
[    3.804986] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    3.805340] uhci_hcd 0000:00:1d.0: detected 2 ports
[    3.805529] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    3.805531] uhci_hcd 0000:00:1d.0: Performing full reset
[    3.805543] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    3.805547] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000ff80
[    3.805758] usb usb6: default language 0x0409
[    3.805764] usb usb6: udev 1, busnum 6, minor = 640
[    3.805766] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    3.805956] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.806297] usb usb6: Product: UHCI Host Controller
[    3.806485] usb usb6: Manufacturer: Linux 2.6.34-rc3-00412-gbb33c1c uhci_hcd
[    3.806674] usb usb6: SerialNumber: 0000:00:1d.0
[    3.806941] usb usb6: usb_probe_device
[    3.806944] usb usb6: configuration #1 chosen from 1 choice
[    3.806952] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    3.807019] hub 6-0:1.0: usb_probe_interface
[    3.807021] hub 6-0:1.0: usb_probe_interface - got id
[    3.807023] hub 6-0:1.0: USB hub found
[    3.807233] hub 6-0:1.0: 2 ports detected
[    3.807419] hub 6-0:1.0: standalone hub
[    3.807420] hub 6-0:1.0: no power switching (usb 1.0)
[    3.807422] hub 6-0:1.0: individual port over-current protection
[    3.807423] hub 6-0:1.0: power on to power good time: 2ms
[    3.807427] hub 6-0:1.0: local power source is good
[    3.807428] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    3.807441] drivers/usb/core/inode.c: creating file '001'
[    3.807467] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    3.807480] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.807672] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    3.807674] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.807865] drivers/usb/core/inode.c: creating file '007'
[    3.807937] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    3.808291] uhci_hcd 0000:00:1d.1: detected 2 ports
[    3.808480] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    3.808482] uhci_hcd 0000:00:1d.1: Performing full reset
[    3.808494] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    3.808498] uhci_hcd 0000:00:1d.1: irq 17, io base 0x0000ff60
[    3.808717] usb usb7: default language 0x0409
[    3.808722] usb usb7: udev 1, busnum 7, minor = 768
[    3.808724] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    3.808913] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.809254] usb usb7: Product: UHCI Host Controller
[    3.813046] usb usb7: Manufacturer: Linux 2.6.34-rc3-00412-gbb33c1c uhci_hcd
[    3.813247] usb usb7: SerialNumber: 0000:00:1d.1
[    3.813514] usb usb7: usb_probe_device
[    3.813517] usb usb7: configuration #1 chosen from 1 choice
[    3.813526] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    3.813591] hub 7-0:1.0: usb_probe_interface
[    3.813593] hub 7-0:1.0: usb_probe_interface - got id
[    3.813595] hub 7-0:1.0: USB hub found
[    3.813792] hub 7-0:1.0: 2 ports detected
[    3.813978] hub 7-0:1.0: standalone hub
[    3.813980] hub 7-0:1.0: no power switching (usb 1.0)
[    3.813981] hub 7-0:1.0: individual port over-current protection
[    3.813983] hub 7-0:1.0: power on to power good time: 2ms
[    3.813986] hub 7-0:1.0: local power source is good
[    3.813988] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    3.814001] drivers/usb/core/inode.c: creating file '001'
[    3.814027] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    3.814041] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.814247] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    3.814250] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.814439] drivers/usb/core/inode.c: creating file '008'
[    3.814510] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    3.814851] uhci_hcd 0000:00:1d.2: detected 2 ports
[    3.815039] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    3.815041] uhci_hcd 0000:00:1d.2: Performing full reset
[    3.815053] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    3.815064] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000ff40
[    3.815292] usb usb8: default language 0x0409
[    3.815298] usb usb8: udev 1, busnum 8, minor = 896
[    3.815300] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    3.815489] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.815815] usb usb8: Product: UHCI Host Controller
[    3.816002] usb usb8: Manufacturer: Linux 2.6.34-rc3-00412-gbb33c1c uhci_hcd
[    3.816195] usb usb8: SerialNumber: 0000:00:1d.2
[    3.816473] usb usb8: usb_probe_device
[    3.816476] usb usb8: configuration #1 chosen from 1 choice
[    3.816484] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    3.816549] hub 8-0:1.0: usb_probe_interface
[    3.816551] hub 8-0:1.0: usb_probe_interface - got id
[    3.816553] hub 8-0:1.0: USB hub found
[    3.816750] hub 8-0:1.0: 2 ports detected
[    3.816936] hub 8-0:1.0: standalone hub
[    3.816938] hub 8-0:1.0: no power switching (usb 1.0)
[    3.816939] hub 8-0:1.0: individual port over-current protection
[    3.816941] hub 8-0:1.0: power on to power good time: 2ms
[    3.816944] hub 8-0:1.0: local power source is good
[    3.816946] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    3.816961] drivers/usb/core/inode.c: creating file '001'
[    3.816987] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    3.817121] usbcore: registered new interface driver usblp
[    3.817327] Initializing USB Mass Storage driver...
[    3.817590] usbcore: registered new interface driver usb-storage
[    3.817787] USB Mass Storage support registered.
[    3.818052] usbcore: registered new interface driver libusual
[    3.818395] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    3.821564] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.821755] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.822115] mice: PS/2 mouse device common for all mice
[    3.822682] rtc_cmos 00:05: RTC can wake from S4
[    3.822966] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    3.823177] rtc0: alarms up to one day, 242 bytes nvram, hpet irqs
[    3.823473] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 20 (level, low) -> IRQ 20
[    3.824374] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
[    3.824931] cpuidle: using governor ladder
[    3.825130] cpuidle: using governor menu
[    3.825338] No iBFT detected.
[    3.827535] usbcore: registered new interface driver hiddev
[    3.827815] usbcore: registered new interface driver usbhid
[    3.828009] usbhid: USB HID core driver
[    3.830315] modprobe used greatest stack depth: 5840 bytes left
[    3.830571] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.830938] HDA Intel 0000:00:1b.0: irq 29 for MSI/MSI-X
[    3.830959] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    3.860776] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    3.878107] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0000
[    3.894092] ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001403 POWER sig=k CSC CONNECT
[    3.894097] hub 2-0:1.0: port 4: status 0501 change 0001
[    3.898098] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    3.901036] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    3.904095] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    3.907045] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    3.913037] uhci_hcd 0000:00:1d.1: port 2 portsc 008a,00
[    3.916096] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    3.994088] hub 2-0:1.0: state 7 ports 6 chg 0010 evt 0000
[    3.994099] hub 2-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
[    3.994109] ehci_hcd 0000:00:1d.7: port 4 low speed --> companion
[    4.041176] logips2pp: Detected unknown logitech mouse model 89
[    4.045023] ehci_hcd 0000:00:1d.7: GetStatus port 4 status 003002 POWER OWNER sig=se0 CSC
[    4.045043] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0010
[    4.045053] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    4.045062] uhci_hcd 0000:00:1d.1: port 2 portsc 01a3,00
[    4.045069] hub 7-0:1.0: port 2, status 0301, change 0001, 1.5 Mb/s
[    4.055052] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.055056] ata5: SATA link down (SStatus 4 SControl 300)
[    4.055060] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.055099] ata6: SATA link down (SStatus 4 SControl 300)
[    4.055106] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.055110] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.055270] ata2.00: ATAPI: PLDS DVD+/-RW DH-16A6S, YD11, max UDMA/100
[    4.056074] ata2.00: configured for UDMA/100
[    4.082025] ata4.00: ATA-8: ST3750528AS, CC34, max UDMA/133
[    4.082230] ata4.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    4.082240] ata3.00: ATA-8: ST3750528AS, CC34, max UDMA/133
[    4.082242] ata3.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    4.106733] ata1.00: ATA-7: ST3750640AS, 3.ADG, max UDMA/133
[    4.106930] ata1.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    4.121693] ata3.00: configured for UDMA/133
[    4.122187] ata4.00: configured for UDMA/133
[    4.149069] hub 7-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x301
[    4.165063] ata1.00: configured for UDMA/133
[    4.176140] scsi 0:0:0:0: Direct-Access     ATA      ST3750640AS      3.AD PQ: 0 ANSI: 5
[    4.176897] sd 0:0:0:0: [sda] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[    4.176914] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.177500] sd 0:0:0:0: [sda] Write Protect is off
[    4.177687] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.177706] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.177986] scsi 1:0:0:0: CD-ROM            PLDS     DVD+-RW DH-16A6S YD11 PQ: 0 ANSI: 5
[    4.178517]  sda:sr0: scsi3-mmc drive: 48x/12x writer dvd-ram cd/rw xa/form2 cdda tray
[    4.183564] Uniform CD-ROM driver Revision: 3.20
[    4.183947] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    4.184101] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    4.184479] scsi 2:0:0:0: Direct-Access     ATA      ST3750528AS      CC34 PQ: 0 ANSI: 5
[    4.185091] sd 2:0:0:0: [sdb] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[    4.185232] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    4.185361] scsi 3:0:0:0: Direct-Access     ATA      ST3750528AS      CC34 PQ: 0 ANSI: 5
[    4.185528] sd 3:0:0:0: [sdc] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[    4.185574] sd 3:0:0:0: [sdc] Write Protect is off
[    4.185576] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    4.185584] sd 3:0:0:0: Attached scsi generic sg3 type 0
[    4.185596] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.185701]  sdc:
[    4.187165] sd 2:0:0:0: [sdb] Write Protect is off
[    4.187538] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    4.187556] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.187993]  sdb: sdc1
[    4.191213] sd 3:0:0:0: [sdc] Attached SCSI disk
[    4.200958] ALSA device list:
[    4.201155]   #0: HDA Intel at 0xfdffc000 irq 29
[    4.201400] Netfilter messages via NETLINK v0.30.
[    4.201600] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    4.201971] ctnetlink v0.93: registering with nfnetlink.
[    4.202586] ip_tables: (C) 2000-2006 Netfilter Core Team
[    4.202805] TCP cubic registered
[    4.202991] Initializing XFRM netlink socket
[    4.203571] NET: Registered protocol family 10
[    4.204488] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    4.204722] IPv6 over IPv4 tunneling driver
[    4.204971]  sdb1
[    4.205654] NET: Registered protocol family 17
[    4.206158] PM: Resume from disk failed.
[    4.206189] registered taskstats version 1
[    4.206287] sd 2:0:0:0: [sdb] Attached SCSI disk
[    4.206827]   Magic number: 6:794:950
[    4.207052] tty tty7: hash matches
[    4.213014]  sda1 sda2 < sda5 sda6 sda7 sda8
[    4.251211] usb 7-2: new low speed USB device using uhci_hcd and address 2
[    4.254326]  sda9 sda10 >
[    4.276744] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.276966] Freeing unused kernel memory: 612k freed
[    4.277319] Write protecting the kernel read-only data: 10240k
[    4.277696] Freeing unused kernel memory: 744k freed
[    4.278185] Freeing unused kernel memory: 1588k freed
[    4.289466] all_generic_ide used greatest stack depth: 5808 bytes left
[    4.294376] all_generic_ide used greatest stack depth: 5776 bytes left
[    4.351062] ata_id used greatest stack depth: 5720 bytes left
[    4.373079] scsi_id used greatest stack depth: 5472 bytes left
[    4.383981] scsi_id used greatest stack depth: 4864 bytes left
[    4.392792] usb 7-2: skipped 1 descriptor after interface
[    4.392798] usb 7-2: udev 2, busnum 7, minor = 769
[    4.392801] usb 7-2: New USB device found, idVendor=0430, idProduct=0005
[    4.393000] usb 7-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.393278] usb 7-2: usb_probe_device
[    4.393281] usb 7-2: configuration #1 chosen from 1 choice
[    4.395794] usb 7-2: adding 7-2:1.0 (config #1, interface 0)
[    4.395864] usbhid 7-2:1.0: usb_probe_interface
[    4.395868] usbhid 7-2:1.0: usb_probe_interface - got id
[    4.410084] input: HID 0430:0005 as /devices/pci0000:00/0000:00:1d.1/usb7/7-2/7-2:1.0/input/input3
[    4.410432] uhci_hcd 0000:00:1d.1: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[    4.410477] generic-usb 0003:0430:0005.0001: input,hidraw0: USB HID v1.00 Keyboard [HID 0430:0005] on usb-0000:00:1d.1-2/input0
[    4.410836] drivers/usb/core/inode.c: creating file '002'
[    4.519346] input: ImExPS/2 Logitech Explorer Mouse as /devices/platform/i8042/serio1/input/input4
[    4.745312] PM: Starting manual resume from disk
[    4.745501] PM: Resume from partition 8:7
[    4.745502] PM: Checking hibernation image.
[    4.745679] PM: Error -22 checking image file
[    4.745681] PM: Resume from disk failed.
[    4.749967] PM: Marking nosave pages: 000000000009e000 - 0000000000100000
[    4.749972] PM: Marking nosave pages: 00000000bfe01000 - 0000000100000000
[    4.751421] PM: Basic memory bitmaps created
[    4.794834] PM: Basic memory bitmaps freed
[    4.806426] kjournald starting.  Commit interval 5 seconds
[    4.806436] EXT3-fs (sda1): mounted filesystem with writeback data mode
[    4.954047] usb usb3: suspend_rh (auto-stop)
[    4.954069] usb usb4: suspend_rh (auto-stop)
[    4.954088] usb usb5: suspend_rh (auto-stop)
[    4.954107] usb usb6: suspend_rh (auto-stop)
[    4.954126] usb usb8: suspend_rh (auto-stop)
[    5.206025] async/1 used greatest stack depth: 4744 bytes left
[    5.951081] mknod used greatest stack depth: 4648 bytes left
[    6.076515] udev: starting version 151
[    6.365513] blkid used greatest stack depth: 4544 bytes left
[    6.636221] nouveau 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.636420] nouveau 0000:01:00.0: setting latency timer to 64
[    6.639612] [drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x086f00a2)
[    6.643881] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
[    6.694618] [drm] nouveau 0000:01:00.0: ... appears to be valid
[    6.694810] [drm] nouveau 0000:01:00.0: BIT BIOS found
[    6.694997] [drm] nouveau 0000:01:00.0: Bios version 60.86.5d.00
[    6.695214] [drm] nouveau 0000:01:00.0: TMDS table revision 2.0 not currently supported
[    6.695218] hub 1-0:1.0: hub_suspend
[    6.695226] usb usb1: bus auto-suspend
[    6.695228] ehci_hcd 0000:00:1a.7: suspend root hub
[    6.695260] hub 3-0:1.0: hub_suspend
[    6.695263] usb usb3: bus auto-suspend
[    6.695265] usb usb3: suspend_rh
[    6.695284] hub 4-0:1.0: hub_suspend
[    6.695286] usb usb4: bus auto-suspend
[    6.695288] usb usb4: suspend_rh
[    6.695305] hub 5-0:1.0: hub_suspend
[    6.695308] usb usb5: bus auto-suspend
[    6.695309] usb usb5: suspend_rh
[    6.695326] hub 6-0:1.0: hub_suspend
[    6.695329] usb usb6: bus auto-suspend
[    6.695330] usb usb6: suspend_rh
[    6.695348] hub 8-0:1.0: hub_suspend
[    6.695351] usb usb8: bus auto-suspend
[    6.695352] usb usb8: suspend_rh
[    6.695590] [drm] nouveau 0000:01:00.0: Found Display Configuration Block version 4.0
[    6.695918] [drm] nouveau 0000:01:00.0: Raw DCB entry 0: 02011300 00000028
[    6.696118] [drm] nouveau 0000:01:00.0: Raw DCB entry 1: 01011302 00000010
[    6.699914] [drm] nouveau 0000:01:00.0: Raw DCB entry 2: 01000310 00000028
[    6.700113] [drm] nouveau 0000:01:00.0: Raw DCB entry 3: 02000312 00000010
[    6.700305] [drm] nouveau 0000:01:00.0: Raw DCB entry 4: 0000000e 00000000
[    6.700495] [drm] nouveau 0000:01:00.0: DCB connector table: VHER 0x40 5 14 2
[    6.700684] [drm] nouveau 0000:01:00.0:   0: 0x00002030: type 0x30 idx 0 tag 0x08
[    6.701016] [drm] nouveau 0000:01:00.0:   1: 0x00001130: type 0x30 idx 1 tag 0x07
[    6.701358] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xC2B6
[    6.705022] hub 2-0:1.0: hub_suspend
[    6.705025] usb usb2: bus auto-suspend
[    6.705027] ehci_hcd 0000:00:1d.7: suspend root hub
[    6.727311] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xC620
[    6.746050] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xD261
[    6.746397] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xD353
[    6.748089] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xD54D
[    6.748436] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xD5B2
[    6.769071] [drm] nouveau 0000:01:00.0: 0xD5B2: Condition still not met after 20ms, skipping following opcodes
[    6.769420] [drm] nouveau 0000:01:00.0: 0xB514: parsing output script 0
[    6.769614] [drm] nouveau 0000:01:00.0: 0xB514: parsing output script 0
[    6.844341] [TTM] Zone  kernel: Available graphics memory: 3029628 kiB.
[    6.844532] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[    6.844729] [drm] nouveau 0000:01:00.0: 256 MiB VRAM
[    6.861342] [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
[    6.861535] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[    6.862046] [drm] nouveau 0000:01:00.0: Allocating FIFO number 1
[    6.865828] [drm] nouveau 0000:01:00.0: nouveau_channel_alloc: initialised FIFO 1
[    6.866774] [drm] nouveau 0000:01:00.0: Detected a DAC output
[    6.866967] [drm] nouveau 0000:01:00.0: Detected a TMDS output
[    6.867169] [drm] nouveau 0000:01:00.0: Detected a DAC output
[    6.867357] [drm] nouveau 0000:01:00.0: Detected a TMDS output
[    6.867545] [drm] nouveau 0000:01:00.0: Detected a DVI-I connector
[    6.867779] [drm] nouveau 0000:01:00.0: Detected a DVI-I connector
[    7.097623] [drm] nouveau 0000:01:00.0: allocated 1600x1200 fb: 0x40250000, bo ffff8801b9371e00
[    7.103869] Console: switching to colour frame buffer device 200x75
[    7.103883] [drm] nouveau 0000:01:00.0: 0x1083: parsing clock script 0
[    7.106514] fb0: nouveaufb frame buffer device
[    7.106525] registered panic notifier
[    7.106537] [drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on minor 0
[    7.106690] modprobe used greatest stack depth: 4048 bytes left
[    7.121175] [drm] nouveau 0000:01:00.0: 0x1083: parsing clock script 0
[    7.461211] Adding 2048252k swap on /dev/sda7.  Priority:-1 extents:1 across:2048252k 
[    7.714863] EXT3-fs (sda1): using internal journal
[    9.953867] kjournald starting.  Commit interval 5 seconds
[    9.954106] EXT3-fs (sda5): using internal journal
[    9.954124] EXT3-fs (sda5): mounted filesystem with writeback data mode
[    9.983353] kjournald starting.  Commit interval 5 seconds
[    9.983519] EXT3-fs (sda6): using internal journal
[    9.983535] EXT3-fs (sda6): mounted filesystem with writeback data mode
[    9.998176] kjournald starting.  Commit interval 5 seconds
[    9.998385] EXT3-fs (sda8): using internal journal
[    9.998402] EXT3-fs (sda8): mounted filesystem with writeback data mode
[   10.031466] kjournald starting.  Commit interval 5 seconds
[   10.031751] EXT3-fs (sda9): using internal journal
[   10.031769] EXT3-fs (sda9): mounted filesystem with writeback data mode
[   10.076221] kjournald starting.  Commit interval 5 seconds
[   10.076407] EXT3-fs (sda10): using internal journal
[   10.076423] EXT3-fs (sda10): mounted filesystem with writeback data mode
[   10.083429] kjournald starting.  Commit interval 5 seconds
[   10.083737] EXT3-fs (sdb1): using internal journal
[   10.083753] EXT3-fs (sdb1): mounted filesystem with writeback data mode
[   10.090731] kjournald starting.  Commit interval 5 seconds
[   10.091047] EXT3-fs (sdc1): using internal journal
[   10.091064] EXT3-fs (sdc1): mounted filesystem with writeback data mode
[   11.521705] tg3 0000:04:00.0: irq 30 for MSI/MSI-X
[   11.565243] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   11.937870] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   14.692137] tg3 0000:04:00.0: eth0: Link is up at 1000 Mbps, full duplex
[   14.692152] tg3 0000:04:00.0: eth0: Flow control is on for TX and on for RX
[   14.693142] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   24.852059] eth0: no IPv6 routers present
[   28.398733] svc: failed to register lockdv1 RPC service (errno 97).
[   29.606110] mount.nfs used greatest stack depth: 3144 bytes left

-andy
