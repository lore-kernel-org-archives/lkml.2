Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab0GFMWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 08:22:31 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57978 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893Ab0GFMW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 08:22:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer;
        b=E1SOOt+jL+rYghIUjKbPCa2QkObuiyENSsPuWJW7mVEKW7HDmjafXVjpi4Yiv6mtR1
         kSRTewJMHd/FK6AHjT15TQo0ExJxO3GTpwdzicYBavrAF0EU1r/OId1Zj54qSqBj6Fya
         yX1T46v9Av6Vyg3mYNgL979z1LDkTSCZRsD2g=
Subject: 2.6.35-rc4 Graphics performance issue and freeing invalid memtype
 messages on boot.
From: Andrew Hendry <andrew.hendry@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-TYaiAgokQeFjzmqs6juD"
Date: Tue, 06 Jul 2010 22:22:17 +1000
Message-ID: <1278418937.1949.22.camel@jaunty>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TYaiAgokQeFjzmqs6juD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit


Some extra messages when booting with -rc4. Didn't get them in -rc3.
[    1.387013] swapper:1 freeing invalid memtype bf788000-bf789000
[    1.387409] swapper:1 freeing invalid memtype bf789000-bf78a000
[    5.999675] modprobe:548 freeing invalid memtype d0000000-d0040000
[    6.068347] modprobe:548 freeing invalid memtype d0140000-d0150000
[    6.068647] modprobe:548 freeing invalid memtype d0150000-d0160000
[    6.069661] modprobe:548 freeing invalid memtype d0170000-d01f0000
[    6.085969] modprobe:548 freeing invalid memtype d01f0000-d0200000
[    6.087673] modprobe:548 freeing invalid memtype d0210000-d0220000
[    6.087900] modprobe:548 freeing invalid memtype d0220000-d0230000
[    6.088092] modprobe:548 freeing invalid memtype d0230000-d0240000
[    6.088317] modprobe:548 freeing invalid memtype d0240000-d0250000

Not sure if its related, but also have a noticeable performance issue with graphics under rc4.
Dragging and resizing windows, screen updates, and jumpy cursor are all slow.
Playing a full screen video under vlc gets only 1-2 frames per second, but plays fine under rc3.
Tested a kernel compile, it was roughly the same.
Userspace is ubunutu 10.04 64bit. 

Any hints? Otherwise will start a bisect tomorrow night.

Config attached, lspci, rc3 and rc4 boot messages below:

--- RC4 ---
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.35-rc4 (ahendry@jaunty) (gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5) ) #8 SMP PREEMPT Tue Jul 6 20:49:58 EST 2010
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.35-rc4 root=UUID=6b63a9f9-effe-44e3-a29d-95e3d202659a ro libata.force=noncq ramdisk_size=2000000
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009c800 (usable)
[    0.000000]  BIOS-e820: 000000000009c800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf770000 (usable)
[    0.000000]  BIOS-e820: 00000000bf770000 - 00000000bf788000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf788000 - 00000000bf7dc000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf7dc000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000240000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x240000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-DFFFF uncachable
[    0.000000]   E0000-E7FFF write-through
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 200000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000c0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbf770 max_arch_pfn = 0x400000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009c800 (usable)
[    0.000000]  modified: 000000000009c800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000bf770000 (usable)
[    0.000000]  modified: 00000000bf770000 - 00000000bf788000 (ACPI data)
[    0.000000]  modified: 00000000bf788000 - 00000000bf7dc000 (ACPI NVS)
[    0.000000]  modified: 00000000bf7dc000 - 00000000c0000000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000240000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] init_memory_mapping: 0000000000000000-00000000bf770000
[    0.000000]  0000000000 - 00bf600000 page 2M
[    0.000000]  00bf600000 - 00bf770000 page 4k
[    0.000000] kernel direct mapping tables up to bf770000 @ 16000-1b000
[    0.000000] init_memory_mapping: 0000000100000000-0000000240000000
[    0.000000]  0100000000 - 0240000000 page 2M
[    0.000000] kernel direct mapping tables up to 240000000 @ 19000-23000
[    0.000000] RAMDISK: 372e7000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000fbb00 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000bf770100 00064 (v01 032510 XSDT2140 20100325 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bf770290 000F4 (v03 032510 FACP2140 20100325 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bf7704a0 0EDBE (v01  A1513 A1513003 00000003 INTL 20060113)
[    0.000000] ACPI: FACS 00000000bf788000 00040
[    0.000000] ACPI: APIC 00000000bf770390 000CC (v01 032510 APIC2140 20100325 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bf770460 0003C (v01 032510 OEMMCFG  20100325 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bf788040 00072 (v01 032510 OEMB2140 20100325 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000bf77f7a0 00038 (v01 032510 OEMHPET  20100325 MSFT 00000097)
[    0.000000] ACPI: ASPT 00000000bf77fa40 00034 (v06 032510 PerfTune 20100325 MSFT 00000097)
[    0.000000] ACPI: OSFR 00000000bf77fa80 000B0 (v01 032510 OEMOSFR  20100325 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bf78a960 00363 (v01 DpgPmm    CpuPm 00000012 INTL 20060113)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000240000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000240000000
[    0.000000]   NODE_DATA [0000000100000000 - 0000000100004fff]
[    0.000000]  [ffffea0000000000-ffffea0007dfffff] PMD -> [ffff880100200000-ffff8801071fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00240000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009c
[    0.000000]     0: 0x00000100 -> 0x000bf770
[    0.000000]     0: 0x00100000 -> 0x00240000
[    0.000000] On node 0 totalpages: 2094844
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3924 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 765864 pages, LIFO batch:31
[    0.000000]   Normal zone: 17920 pages used for memmap
[    0.000000]   Normal zone: 1292800 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x88] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x89] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x8a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x8b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x8c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x8d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x8e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x8f] disabled)
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] SMP: Allowing 16 CPUs, 8 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [1e000 - 1e7ff]
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:3ee00000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:16 nr_cpumask_bits:16 nr_cpu_ids:16 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880001e00000 s91072 r8192 d23616 u131072
[    0.000000] early_res array is doubled to 128 at [1e800 - 1f7ff]
[    0.000000] pcpu-alloc: s91072 r8192 d23616 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2062588
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.35-rc4 root=UUID=6b63a9f9-effe-44e3-a29d-95e3d202659a ro libata.force=noncq ramdisk_size=2000000
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Subtract (66 early reservations)
[    0.000000]   #1 [0001000000 - 0001c8fe14]   TEXT DATA BSS
[    0.000000]   #2 [00372e7000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [0001c90000 - 0001c902c4]             BRK
[    0.000000]   #4 [00000ff790 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000ff780 - 00000ff790]    MP-table mpf
[    0.000000]   #6 [000009c800 - 00000f1310]   BIOS reserved
[    0.000000]   #7 [00000f14fc - 00000ff780]   BIOS reserved
[    0.000000]   #8 [00000f1310 - 00000f14fc]    MP-table mpc
[    0.000000]   #9 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #10 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #11 [0000016000 - 0000019000]         PGTABLE
[    0.000000]   #12 [0000019000 - 000001e000]         PGTABLE
[    0.000000]   #13 [0100000000 - 0100005000]       NODE_DATA
[    0.000000]   #14 [0001c90300 - 0001c91300]         BOOTMEM
[    0.000000]   #15 [0002091300 - 0002091900]         BOOTMEM
[    0.000000]   #16 [0100005000 - 0100006000]         BOOTMEM
[    0.000000]   #17 [0100006000 - 0100007000]         BOOTMEM
[    0.000000]   #18 [0100200000 - 0107200000]        MEMMAP 0
[    0.000000]   #19 [0001c8fe40 - 0001c8ffc0]         BOOTMEM
[    0.000000]   #20 [0001c91300 - 0001ca9300]         BOOTMEM
[    0.000000]   #21 [0001ca9300 - 0001cc1300]         BOOTMEM
[    0.000000]   #22 [0001cc2000 - 0001cc3000]         BOOTMEM
[    0.000000]   #23 [0001cc1300 - 0001cc1341]         BOOTMEM
[    0.000000]   #24 [0001cc1380 - 0001cc13c3]         BOOTMEM
[    0.000000]   #25 [0001cc1400 - 0001cc1668]         BOOTMEM
[    0.000000]   #26 [0001cc1680 - 0001cc16e8]         BOOTMEM
[    0.000000]   #27 [0001cc1700 - 0001cc1768]         BOOTMEM
[    0.000000]   #28 [0001cc1780 - 0001cc17e8]         BOOTMEM
[    0.000000]   #29 [0001cc1800 - 0001cc1868]         BOOTMEM
[    0.000000]   #30 [0001cc1880 - 0001cc18e8]         BOOTMEM
[    0.000000]   #31 [0001cc1900 - 0001cc1968]         BOOTMEM
[    0.000000]   #32 [0001cc1980 - 0001cc19e8]         BOOTMEM
[    0.000000]   #33 [0001cc1a00 - 0001cc1a68]         BOOTMEM
[    0.000000]   #34 [0001cc1a80 - 0001cc1ae8]         BOOTMEM
[    0.000000]   #35 [0001cc1b00 - 0001cc1b68]         BOOTMEM
[    0.000000]   #36 [0001cc1b80 - 0001cc1bfe]         BOOTMEM
[    0.000000]   #37 [0001cc1c00 - 0001cc1c7e]         BOOTMEM
[    0.000000]   #38 [0001e00000 - 0001e1e000]         BOOTMEM
[    0.000000]   #39 [0001e20000 - 0001e3e000]         BOOTMEM
[    0.000000]   #40 [0001e40000 - 0001e5e000]         BOOTMEM
[    0.000000]   #41 [0001e60000 - 0001e7e000]         BOOTMEM
[    0.000000]   #42 [0001e80000 - 0001e9e000]         BOOTMEM
[    0.000000]   #43 [0001ea0000 - 0001ebe000]         BOOTMEM
[    0.000000]   #44 [0001ec0000 - 0001ede000]         BOOTMEM
[    0.000000]   #45 [0001ee0000 - 0001efe000]         BOOTMEM
[    0.000000]   #46 [0001f00000 - 0001f1e000]         BOOTMEM
[    0.000000]   #47 [0001f20000 - 0001f3e000]         BOOTMEM
[    0.000000]   #48 [0001f40000 - 0001f5e000]         BOOTMEM
[    0.000000]   #49 [0001f60000 - 0001f7e000]         BOOTMEM
[    0.000000]   #50 [0001f80000 - 0001f9e000]         BOOTMEM
[    0.000000]   #51 [0001fa0000 - 0001fbe000]         BOOTMEM
[    0.000000]   #52 [0001fc0000 - 0001fde000]         BOOTMEM
[    0.000000]   #53 [0001fe0000 - 0001ffe000]         BOOTMEM
[    0.000000]   #54 [0001c8ffc0 - 0001c8ffc8]         BOOTMEM
[    0.000000]   #55 [0001cc1c80 - 0001cc1c88]         BOOTMEM
[    0.000000]   #56 [0001cc1cc0 - 0001cc1d00]         BOOTMEM
[    0.000000]   #57 [0001cc1d00 - 0001cc1d80]         BOOTMEM
[    0.000000]   #58 [0001cc1d80 - 0001cc1e90]         BOOTMEM
[    0.000000]   #59 [0001cc1ec0 - 0001cc1f08]         BOOTMEM
[    0.000000]   #60 [0001cc1f40 - 0001cc1f88]         BOOTMEM
[    0.000000]   #61 [0001cc3000 - 0001ccb000]         BOOTMEM
[    0.000000]   #62 [0002092000 - 0006092000]         BOOTMEM
[    0.000000]   #63 [0001ccb000 - 0001ceb000]         BOOTMEM
[    0.000000]   #64 [0001ceb000 - 0001d2b000]         BOOTMEM
[    0.000000]   #65 [000001f800 - 0000027800]         BOOTMEM
[    0.000000] Memory: 8170276k/9437184k available (5290k kernel code, 1057808k absent, 209100k reserved, 5635k data, 864k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:808
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 83886080 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.001000] Detected 2808.611 MHz processor.
[    0.000004] Calibrating delay loop (skipped), value calculated using timer frequency.. 5617.22 BogoMIPS (lpj=2808611)
[    0.000120] pid_max: default: 32768 minimum: 301
[    0.000310] Security Framework initialized
[    0.001455] Smack:  Initializing.
[    0.002184] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.003883] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.004615] Mount-cache hash table entries: 256
[    0.005557] Initializing cgroup subsys ns
[    0.005619] Initializing cgroup subsys cpuacct
[    0.005681] Initializing cgroup subsys memory
[    0.005815] Initializing cgroup subsys devices
[    0.005879] Initializing cgroup subsys freezer
[    0.005939] Initializing cgroup subsys net_cls
[    0.006079] CPU: Physical Processor ID: 0
[    0.006135] CPU: Processor Core ID: 0
[    0.006192] mce: CPU supports 9 MCE banks
[    0.006259] CPU0: Thermal monitoring enabled (TM1)
[    0.006320] using mwait in idle threads.
[    0.006375] Performance Events: PEBS fmt1+, Nehalem events, Intel PMU driver.
[    0.006549] ... version:                3
[    0.006604] ... bit width:              48
[    0.006659] ... generic registers:      4
[    0.006714] ... value mask:             0000ffffffffffff
[    0.006771] ... max period:             000000007fffffff
[    0.006829] ... fixed-purpose events:   3
[    0.006883] ... event mask:             000000070000000f
[    0.007650] ACPI: Core revision 20100428
[    0.239344] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.239406] ftrace: allocating 19705 entries in 78 pages
[    0.245535] Setting APIC routing to physical flat
[    0.245975] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.256019] CPU0: Intel(R) Core(TM) i7 CPU         860  @ 2.80GHz stepping 05
[    0.364039] Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7
[    1.011981] Brought up 8 CPUs
[    1.012084] Total of 8 processors activated (44933.51 BogoMIPS).
[    1.016118] devtmpfs: initialized
[    1.017762] regulator: core version 0.5
[    1.017870] Time: 21:35:28  Date: 07/06/10
[    1.018185] NET: Registered protocol family 16
[    1.019301] ACPI: bus type pci registered
[    1.019737] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    1.019816] PCI: not using MMCONFIG
[    1.019875] PCI: Using configuration type 1 for base access
[    1.028706] bio: create slab <bio-0> at 0
[    1.032137] ACPI: EC: Look up EC in DSDT
[    1.036471] ACPI: Executed 1 blocks of module-level executable AML code
[    1.387013] swapper:1 freeing invalid memtype bf788000-bf789000
[    1.387409] swapper:1 freeing invalid memtype bf789000-bf78a000
[    1.387745] ACPI: SSDT 00000000bf7880c0 0223C (v01 DpgPmm  P001Ist 00000011 INTL 20060113)
[    1.396389] ACPI: Dynamic OEM Table Load:
[    1.396513] ACPI: SSDT (null) 0223C (v01 DpgPmm  P001Ist 00000011 INTL 20060113)
[    1.398312] ACPI: SSDT 00000000bf78a300 00659 (v01  PmRef  P001Cst 00003001 INTL 20060113)
[    1.401699] ACPI: Dynamic OEM Table Load:
[    1.401822] ACPI: SSDT (null) 00659 (v01  PmRef  P001Cst 00003001 INTL 20060113)
[    1.404008] ACPI: Interpreter enabled
[    1.404064] ACPI: (supports S0 S1 S3 S5)
[    1.404502] ACPI: Using IOAPIC for interrupt routing
[    1.404809] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    1.427771] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    1.611731] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
[    1.613624] ACPI: No dock devices found.
[    1.613680] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.619027] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.622572] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.622640] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.622706] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.622790] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
[    1.622872] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xdfffffff]
[    1.622953] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfed8ffff]
[    1.623140] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    1.623143] pci 0000:00:03.0: PME# disabled
[    1.623488] pci 0000:00:1a.0: reg 10: [mem 0xf7ffe000-0xf7ffe3ff]
[    1.623537] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    1.623541] pci 0000:00:1a.0: PME# disabled
[    1.623584] pci 0000:00:1b.0: reg 10: [mem 0xf7ff8000-0xf7ffbfff 64bit]
[    1.623627] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.623630] pci 0000:00:1b.0: PME# disabled
[    1.623708] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.623711] pci 0000:00:1c.0: PME# disabled
[    1.623804] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    1.623807] pci 0000:00:1c.5: PME# disabled
[    1.623890] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    1.623894] pci 0000:00:1c.6: PME# disabled
[    1.623975] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    1.623978] pci 0000:00:1c.7: PME# disabled
[    1.624031] pci 0000:00:1d.0: reg 10: [mem 0xf7ffd000-0xf7ffd3ff]
[    1.624081] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    1.624084] pci 0000:00:1d.0: PME# disabled
[    1.624279] pci 0000:00:1f.2: reg 10: [io  0xa880-0xa887]
[    1.624284] pci 0000:00:1f.2: reg 14: [io  0xa800-0xa803]
[    1.624288] pci 0000:00:1f.2: reg 18: [io  0xa480-0xa487]
[    1.624293] pci 0000:00:1f.2: reg 1c: [io  0xa400-0xa403]
[    1.624298] pci 0000:00:1f.2: reg 20: [io  0xa080-0xa09f]
[    1.624303] pci 0000:00:1f.2: reg 24: [mem 0xf7ff7000-0xf7ff77ff]
[    1.624331] pci 0000:00:1f.2: PME# supported from D3hot
[    1.624334] pci 0000:00:1f.2: PME# disabled
[    1.624374] pci 0000:00:1f.3: reg 10: [mem 0xf7ffc000-0xf7ffc0ff 64bit]
[    1.624385] pci 0000:00:1f.3: reg 20: [io  0xffe0-0xffff]
[    1.624478] pci 0000:01:00.0: reg 10: [mem 0xfa000000-0xfaffffff]
[    1.624486] pci 0000:01:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.624493] pci 0000:01:00.0: reg 1c: [mem 0xf8000000-0xf9ffffff 64bit]
[    1.624498] pci 0000:01:00.0: reg 24: [io  0xbc00-0xbc7f]
[    1.624503] pci 0000:01:00.0: reg 30: [mem 0xfb980000-0xfb9fffff pref]
[    1.624541] pci 0000:00:03.0: PCI bridge to [bus 01-01]
[    1.624600] pci 0000:00:03.0:   bridge window [io  0xb000-0xbfff]
[    1.624603] pci 0000:00:03.0:   bridge window [mem 0xf8000000-0xfb9fffff]
[    1.624607] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.624698] pci 0000:05:00.0: reg 10: [mem 0xfbbe0000-0xfbbfffff]
[    1.624759] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    1.624763] pci 0000:05:00.0: PME# disabled
[    1.624800] pci 0000:00:1c.0: PCI bridge to [bus 05-0a]
[    1.624861] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    1.624864] pci 0000:00:1c.0:   bridge window [mem 0xfbb00000-0xfbdfffff]
[    1.624869] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.625047] pci 0000:06:01.0: PME# supported from D0 D3hot D3cold
[    1.625051] pci 0000:06:01.0: PME# disabled
[    1.625176] pci 0000:06:05.0: PME# supported from D0 D3hot D3cold
[    1.625180] pci 0000:06:05.0: PME# disabled
[    1.625303] pci 0000:06:07.0: PME# supported from D0 D3hot D3cold
[    1.625306] pci 0000:06:07.0: PME# disabled
[    1.625429] pci 0000:06:09.0: PME# supported from D0 D3hot D3cold
[    1.625433] pci 0000:06:09.0: PME# disabled
[    1.625478] pci 0000:05:00.0: PCI bridge to [bus 06-0a]
[    1.625540] pci 0000:05:00.0:   bridge window [io  0xd000-0xdfff]
[    1.625544] pci 0000:05:00.0:   bridge window [mem 0xfbc00000-0xfbdfffff]
[    1.625551] pci 0000:05:00.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.625688] pci 0000:07:00.0: reg 10: [mem 0xfbcfe000-0xfbcfffff 64bit]
[    1.625789] pci 0000:07:00.0: PME# supported from D0 D3hot D3cold
[    1.625794] pci 0000:07:00.0: PME# disabled
[    1.625823] pci 0000:06:01.0: PCI bridge to [bus 07-07]
[    1.625886] pci 0000:06:01.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.625890] pci 0000:06:01.0:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    1.625896] pci 0000:06:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.626024] pci 0000:08:00.0: reg 10: [io  0xdc00-0xdc07]
[    1.626032] pci 0000:08:00.0: reg 14: [io  0xd880-0xd883]
[    1.626039] pci 0000:08:00.0: reg 18: [io  0xd800-0xd807]
[    1.626047] pci 0000:08:00.0: reg 1c: [io  0xd480-0xd483]
[    1.626054] pci 0000:08:00.0: reg 20: [io  0xd400-0xd40f]
[    1.626062] pci 0000:08:00.0: reg 24: [mem 0xfbdff800-0xfbdfffff]
[    1.626070] pci 0000:08:00.0: reg 30: [mem 0xfbde0000-0xfbdeffff pref]
[    1.626114] pci 0000:08:00.0: PME# supported from D3hot
[    1.626119] pci 0000:08:00.0: PME# disabled
[    1.626135] pci 0000:06:05.0: PCI bridge to [bus 08-08]
[    1.626197] pci 0000:06:05.0:   bridge window [io  0xd000-0xdfff]
[    1.626202] pci 0000:06:05.0:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    1.626208] pci 0000:06:05.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.626285] pci 0000:06:07.0: PCI bridge to [bus 09-09]
[    1.626347] pci 0000:06:07.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.626352] pci 0000:06:07.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.626358] pci 0000:06:07.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.626435] pci 0000:06:09.0: PCI bridge to [bus 0a-0a]
[    1.626497] pci 0000:06:09.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.626501] pci 0000:06:09.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.626508] pci 0000:06:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.626588] pci 0000:00:1c.5: PCI bridge to [bus 04-04]
[    1.626647] pci 0000:00:1c.5:   bridge window [io  0xf000-0x0000] (disabled)
[    1.626650] pci 0000:00:1c.5:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.626655] pci 0000:00:1c.5:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.626804] pci 0000:03:00.0: reg 24: [mem 0xfbafe000-0xfbafffff]
[    1.626851] pci 0000:03:00.0: PME# supported from D3hot
[    1.626856] pci 0000:03:00.0: PME# disabled
[    1.626917] pci 0000:03:00.1: reg 10: [io  0xcc00-0xcc07]
[    1.626926] pci 0000:03:00.1: reg 14: [io  0xc880-0xc883]
[    1.626934] pci 0000:03:00.1: reg 18: [io  0xc800-0xc807]
[    1.626942] pci 0000:03:00.1: reg 1c: [io  0xc480-0xc483]
[    1.626950] pci 0000:03:00.1: reg 20: [io  0xc400-0xc40f]
[    1.627007] pci 0000:00:1c.6: PCI bridge to [bus 03-03]
[    1.627066] pci 0000:00:1c.6:   bridge window [io  0xc000-0xcfff]
[    1.627069] pci 0000:00:1c.6:   bridge window [mem 0xfba00000-0xfbafffff]
[    1.627074] pci 0000:00:1c.6:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.627127] pci 0000:00:1c.7: PCI bridge to [bus 02-02]
[    1.627186] pci 0000:00:1c.7:   bridge window [io  0xf000-0x0000] (disabled)
[    1.627190] pci 0000:00:1c.7:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.627195] pci 0000:00:1c.7:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.627269] pci 0000:0b:02.0: reg 10: [io  0xe800-0xe8ff]
[    1.627275] pci 0000:0b:02.0: reg 14: [mem 0xfbeffc00-0xfbeffcff]
[    1.627299] pci 0000:0b:02.0: reg 30: [mem 0xfbec0000-0xfbedffff pref]
[    1.627316] pci 0000:0b:02.0: supports D1 D2
[    1.627317] pci 0000:0b:02.0: PME# supported from D1 D2 D3hot D3cold
[    1.627321] pci 0000:0b:02.0: PME# disabled
[    1.627360] pci 0000:00:1e.0: PCI bridge to [bus 0b-0b] (subtractive decode)
[    1.627422] pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
[    1.627425] pci 0000:00:1e.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    1.627430] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.627441] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    1.627451] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    1.627461] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.627471] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    1.627481] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xdfffffff] (subtractive decode)
[    1.627491] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfed8ffff] (subtractive decode)
[    1.627531] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.635610] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR1E._PRT]
[    1.638553] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
[    1.639831] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR20._PRT]
[    1.641712] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR26._PRT]
[    1.643034] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR27._PRT]
[    2.042605] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12 14 15)
[    2.043780] ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
[    2.044680] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 11 12 14 *15)
[    2.045864] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 *11 12 14 15)
[    2.047044] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
[    2.048319] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12 *14 15)
[    2.049510] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 6 7 10 11 12 14 15)
[    2.050739] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 *7 10 11 12 14 15)
[    2.051919] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    2.052044] vgaarb: loaded
[    2.053343] SCSI subsystem initialized
[    2.053782] libata version 3.00 loaded.
[    2.054258] usbcore: registered new interface driver usbfs
[    2.054432] usbcore: registered new interface driver hub
[    2.054590] usbcore: registered new device driver usb
[    2.055685] ACPI: WMI: Mapper loaded
[    2.055740] PCI: Using ACPI for IRQ routing
[    2.055795] PCI: pci_cache_line_size set to 64 bytes
[    2.056173] reserve RAM buffer: 000000000009c800 - 000000000009ffff 
[    2.056180] reserve RAM buffer: 00000000bf770000 - 00000000bfffffff 
[    2.056929] NetLabel: Initializing
[    2.056984] NetLabel:  domain hash size = 128
[    2.057039] NetLabel:  protocols = UNLABELED CIPSOv4
[    2.057184] NetLabel:  unlabeled traffic allowed by default
[    2.057446]   alloc irq_desc for 40 on node 0
[    2.057452]   alloc kstat_irqs on node 0
[    2.057464]   alloc irq_desc for 41 on node 0
[    2.057469]   alloc kstat_irqs on node 0
[    2.057480]   alloc irq_desc for 42 on node 0
[    2.057485]   alloc kstat_irqs on node 0
[    2.057495]   alloc irq_desc for 43 on node 0
[    2.057500]   alloc kstat_irqs on node 0
[    2.057512]   alloc irq_desc for 44 on node 0
[    2.057518]   alloc kstat_irqs on node 0
[    2.057523] HPET: 8 timers in total, 5 timers will be used for per-cpu timer
[    2.057594] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 40, 41, 42, 43, 44, 0
[    2.057958] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    2.061157] hpet: hpet2 irq 40 for MSI
[    2.062232] hpet: hpet3 irq 41 for MSI
[    2.063356] hpet: hpet4 irq 42 for MSI
[    2.064348] hpet: hpet5 irq 43 for MSI
[    2.065279] hpet: hpet6 irq 44 for MSI
[    2.067476] Switching to clocksource tsc
[    2.099997] pnp: PnP ACPI init
[    2.100109] ACPI: bus type pnp registered
[    2.127466] pnp: PnP ACPI: found 14 devices
[    2.127522] ACPI: ACPI bus type pnp unregistered
[    2.127637] system 00:01: [mem 0xfc000000-0xfcffffff] has been reserved
[    2.127708] system 00:01: [mem 0xfd000000-0xfdffffff] has been reserved
[    2.127778] system 00:01: [mem 0xfe000000-0xfebfffff] has been reserved
[    2.127848] system 00:01: [mem 0xfed14000-0xfed19fff] has been reserved
[    2.127942] system 00:06: [io  0x0290-0x029f] has been reserved
[    2.128035] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    2.128104] system 00:07: [io  0x0800-0x087f] has been reserved
[    2.128173] system 00:07: [io  0x0500-0x057f] has been reserved
[    2.128242] system 00:07: [io  0x0600-0x0607] has been reserved
[    2.128311] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    2.128381] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[    2.128468] system 00:07: [mem 0xfed40000-0xfed8ffff] has been reserved
[    2.128566] system 00:0a: [mem 0xffc00000-0xffdfffff] has been reserved
[    2.128666] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be reserved
[    2.128738] system 00:0b: [mem 0xfee00000-0xfee00fff] has been reserved
[    2.128835] system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
[    2.129018] system 00:0d: [mem 0x00000000-0x0009ffff] could not be reserved
[    2.129091] system 00:0d: [mem 0x000c0000-0x000cffff] has been reserved
[    2.129164] system 00:0d: [mem 0x000e0000-0x000fffff] could not be reserved
[    2.129238] system 00:0d: [mem 0x00100000-0xbfffffff] could not be reserved
[    2.129312] system 00:0d: [mem 0xfed90000-0xffffffff] could not be reserved
[    2.135805] pci 0000:00:1c.7: BAR 14: assigned [mem 0xc0000000-0xc01fffff]
[    2.135868] pci 0000:00:1c.7: BAR 15: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
[    2.135945] pci 0000:00:1c.7: BAR 13: assigned [io  0x1000-0x1fff]
[    2.136005] pci 0000:00:03.0: PCI bridge to [bus 01-01]
[    2.136063] pci 0000:00:03.0:   bridge window [io  0xb000-0xbfff]
[    2.136124] pci 0000:00:03.0:   bridge window [mem 0xf8000000-0xfb9fffff]
[    2.136186] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    2.136264] pci 0000:06:01.0: PCI bridge to [bus 07-07]
[    2.136321] pci 0000:06:01.0:   bridge window [io  disabled]
[    2.136383] pci 0000:06:01.0:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    2.136449] pci 0000:06:01.0:   bridge window [mem pref disabled]
[    2.136514] pci 0000:06:05.0: PCI bridge to [bus 08-08]
[    2.136572] pci 0000:06:05.0:   bridge window [io  0xd000-0xdfff]
[    2.136635] pci 0000:06:05.0:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    2.136697] pci 0000:06:05.0:   bridge window [mem pref disabled]
[    2.136761] pci 0000:06:07.0: PCI bridge to [bus 09-09]
[    2.136818] pci 0000:06:07.0:   bridge window [io  disabled]
[    2.136879] pci 0000:06:07.0:   bridge window [mem disabled]
[    2.136939] pci 0000:06:07.0:   bridge window [mem pref disabled]
[    2.137003] pci 0000:06:09.0: PCI bridge to [bus 0a-0a]
[    2.137060] pci 0000:06:09.0:   bridge window [io  disabled]
[    2.137121] pci 0000:06:09.0:   bridge window [mem disabled]
[    2.137182] pci 0000:06:09.0:   bridge window [mem pref disabled]
[    2.137245] pci 0000:05:00.0: PCI bridge to [bus 06-0a]
[    2.137304] pci 0000:05:00.0:   bridge window [io  0xd000-0xdfff]
[    2.137366] pci 0000:05:00.0:   bridge window [mem 0xfbc00000-0xfbdfffff]
[    2.137428] pci 0000:05:00.0:   bridge window [mem pref disabled]
[    2.137496] pci 0000:00:1c.0: PCI bridge to [bus 05-0a]
[    2.137554] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    2.137615] pci 0000:00:1c.0:   bridge window [mem 0xfbb00000-0xfbdfffff]
[    2.137677] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    2.137739] pci 0000:00:1c.5: PCI bridge to [bus 04-04]
[    2.137796] pci 0000:00:1c.5:   bridge window [io  disabled]
[    2.137856] pci 0000:00:1c.5:   bridge window [mem disabled]
[    2.137916] pci 0000:00:1c.5:   bridge window [mem pref disabled]
[    2.137978] pci 0000:00:1c.6: PCI bridge to [bus 03-03]
[    2.138036] pci 0000:00:1c.6:   bridge window [io  0xc000-0xcfff]
[    2.138097] pci 0000:00:1c.6:   bridge window [mem 0xfba00000-0xfbafffff]
[    2.139233] pci 0000:00:1c.6:   bridge window [mem pref disabled]
[    2.139295] pci 0000:00:1c.7: PCI bridge to [bus 02-02]
[    2.139353] pci 0000:00:1c.7:   bridge window [io  0x1000-0x1fff]
[    2.139414] pci 0000:00:1c.7:   bridge window [mem 0xc0000000-0xc01fffff]
[    2.139479] pci 0000:00:1c.7:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
[    2.139558] pci 0000:00:1e.0: PCI bridge to [bus 0b-0b]
[    2.139616] pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
[    2.139677] pci 0000:00:1e.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    2.139739] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    2.139813]   alloc irq_desc for 16 on node -1
[    2.139821]   alloc kstat_irqs on node -1
[    2.139837] pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.139899] pci 0000:00:03.0: setting latency timer to 64
[    2.139912]   alloc irq_desc for 17 on node -1
[    2.139919]   alloc kstat_irqs on node -1
[    2.139935] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.139996] pci 0000:00:1c.0: setting latency timer to 64
[    2.140004] pci 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.140067] pci 0000:05:00.0: setting latency timer to 64
[    2.140076] pci 0000:06:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.140138] pci 0000:06:01.0: setting latency timer to 64
[    2.140147] pci 0000:06:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.140209] pci 0000:06:05.0: setting latency timer to 64
[    2.140224]   alloc irq_desc for 19 on node -1
[    2.140232]   alloc kstat_irqs on node -1
[    2.140247] pci 0000:06:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.140310] pci 0000:06:07.0: setting latency timer to 64
[    2.140318] pci 0000:06:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.140381] pci 0000:06:09.0: setting latency timer to 64
[    2.140388] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    2.140453] pci 0000:00:1c.5: setting latency timer to 64
[    2.140466]   alloc irq_desc for 18 on node -1
[    2.140476]   alloc kstat_irqs on node -1
[    2.140491] pci 0000:00:1c.6: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.140553] pci 0000:00:1c.6: setting latency timer to 64
[    2.140559] pci 0000:00:1c.7: enabling device (0104 -> 0107)
[    2.140619] pci 0000:00:1c.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    2.140680] pci 0000:00:1c.7: setting latency timer to 64
[    2.140686] pci 0000:00:1e.0: setting latency timer to 64
[    2.140689] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.140690] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.140692] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.140694] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    2.140695] pci_bus 0000:00: resource 8 [mem 0xc0000000-0xdfffffff]
[    2.140697] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfed8ffff]
[    2.140699] pci_bus 0000:01: resource 0 [io  0xb000-0xbfff]
[    2.140700] pci_bus 0000:01: resource 1 [mem 0xf8000000-0xfb9fffff]
[    2.140702] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    2.140704] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]
[    2.140706] pci_bus 0000:05: resource 1 [mem 0xfbb00000-0xfbdfffff]
[    2.140707] pci_bus 0000:06: resource 0 [io  0xd000-0xdfff]
[    2.140709] pci_bus 0000:06: resource 1 [mem 0xfbc00000-0xfbdfffff]
[    2.140711] pci_bus 0000:07: resource 1 [mem 0xfbc00000-0xfbcfffff]
[    2.140712] pci_bus 0000:08: resource 0 [io  0xd000-0xdfff]
[    2.140714] pci_bus 0000:08: resource 1 [mem 0xfbd00000-0xfbdfffff]
[    2.140716] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
[    2.140717] pci_bus 0000:03: resource 1 [mem 0xfba00000-0xfbafffff]
[    2.140719] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    2.140721] pci_bus 0000:02: resource 1 [mem 0xc0000000-0xc01fffff]
[    2.140722] pci_bus 0000:02: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
[    2.140724] pci_bus 0000:0b: resource 0 [io  0xe000-0xefff]
[    2.140726] pci_bus 0000:0b: resource 1 [mem 0xfbe00000-0xfbefffff]
[    2.140727] pci_bus 0000:0b: resource 4 [io  0x0000-0x0cf7]
[    2.140729] pci_bus 0000:0b: resource 5 [io  0x0d00-0xffff]
[    2.140730] pci_bus 0000:0b: resource 6 [mem 0x000a0000-0x000bffff]
[    2.140732] pci_bus 0000:0b: resource 7 [mem 0x000d0000-0x000dffff]
[    2.140734] pci_bus 0000:0b: resource 8 [mem 0xc0000000-0xdfffffff]
[    2.140735] pci_bus 0000:0b: resource 9 [mem 0xf0000000-0xfed8ffff]
[    2.140824] NET: Registered protocol family 2
[    2.141146] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    2.142530] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    2.144876] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    2.145201] TCP: Hash tables configured (established 524288 bind 65536)
[    2.145262] TCP reno registered
[    2.145350] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    2.145495] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    2.146369] NET: Registered protocol family 1
[    2.146672] pci 0000:01:00.0: Boot video device
[    2.146788] PCI: CLS 32 bytes, default 64
[    2.147038] Trying to unpack rootfs image as initramfs...
[    2.385122] Freeing initrd memory: 13348k freed
[    2.386915] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.386979] Placing 64MB software IO TLB between ffff880002092000 - ffff880006092000
[    2.387054] software IO TLB at phys 0x2092000 - 0x6092000
[    2.392538] Scanning for low memory corruption every 60 seconds
[    2.392999] audit: initializing netlink socket (disabled)
[    2.393111] type=2000 audit(1278452129.944:1): initialized
[    2.399800] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.412662] VFS: Disk quotas dquot_6.5.2
[    2.412964] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.417599] fuse init (API version 7.14)
[    2.418378] msgmni has been set to 15983
[    2.419463] alg: No test for stdrng (krng)
[    2.419821] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    2.419897] io scheduler noop registered
[    2.419952] io scheduler deadline registered
[    2.420239] io scheduler cfq registered (default)
[    2.421037] pcieport 0000:00:03.0: setting latency timer to 64
[    2.421073]   alloc irq_desc for 45 on node -1
[    2.421082]   alloc kstat_irqs on node -1
[    2.421113] pcieport 0000:00:03.0: irq 45 for MSI/MSI-X
[    2.421489] pcieport 0000:00:1c.0: setting latency timer to 64
[    2.421531]   alloc irq_desc for 46 on node -1
[    2.421540]   alloc kstat_irqs on node -1
[    2.421554] pcieport 0000:00:1c.0: irq 46 for MSI/MSI-X
[    2.421775] pcieport 0000:00:1c.5: setting latency timer to 64
[    2.421817]   alloc irq_desc for 47 on node -1
[    2.421826]   alloc kstat_irqs on node -1
[    2.421839] pcieport 0000:00:1c.5: irq 47 for MSI/MSI-X
[    2.422062] pcieport 0000:00:1c.6: setting latency timer to 64
[    2.422110]   alloc irq_desc for 48 on node -1
[    2.422122]   alloc kstat_irqs on node -1
[    2.422135] pcieport 0000:00:1c.6: irq 48 for MSI/MSI-X
[    2.422359] pcieport 0000:00:1c.7: setting latency timer to 64
[    2.422401]   alloc irq_desc for 49 on node -1
[    2.422410]   alloc kstat_irqs on node -1
[    2.422423] pcieport 0000:00:1c.7: irq 49 for MSI/MSI-X
[    2.422810] pcieport 0000:05:00.0: setting latency timer to 64
[    2.422866]   alloc irq_desc for 50 on node -1
[    2.422875]   alloc kstat_irqs on node -1
[    2.422891] pcieport 0000:05:00.0: irq 50 for MSI/MSI-X
[    2.423296] pcieport 0000:06:01.0: setting latency timer to 64
[    2.423352]   alloc irq_desc for 51 on node -1
[    2.423361]   alloc kstat_irqs on node -1
[    2.423379] pcieport 0000:06:01.0: irq 51 for MSI/MSI-X
[    2.423778] pcieport 0000:06:05.0: setting latency timer to 64
[    2.423834]   alloc irq_desc for 52 on node -1
[    2.423843]   alloc kstat_irqs on node -1
[    2.423859] pcieport 0000:06:05.0: irq 52 for MSI/MSI-X
[    2.424267] pcieport 0000:06:07.0: setting latency timer to 64
[    2.424323]   alloc irq_desc for 53 on node -1
[    2.424332]   alloc kstat_irqs on node -1
[    2.424348] pcieport 0000:06:07.0: irq 53 for MSI/MSI-X
[    2.424749] pcieport 0000:06:09.0: setting latency timer to 64
[    2.424805]   alloc irq_desc for 54 on node -1
[    2.424814]   alloc kstat_irqs on node -1
[    2.424830] pcieport 0000:06:09.0: irq 54 for MSI/MSI-X
[    2.425317] Firmware did not grant requested _OSC control
[    2.425319] aer 0000:00:03.0:pcie02: AER service couldn't init device: no _OSC support
[    2.425448] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.425580] Firmware did not grant requested _OSC control
[    2.425735] Firmware did not grant requested _OSC control
[    2.425785] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.426698] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    2.426776] ACPI: Power Button [PWRB]
[    2.427277] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.427353] ACPI: Power Button [PWRF]
[    2.431175] ACPI: acpi_idle registered with cpuidle
[    2.434055] Monitor-Mwait will be used to enter C-1 state
[    2.434111] Monitor-Mwait will be used to enter C-2 state
[    2.434160] Monitor-Mwait will be used to enter C-3 state
[    2.512624] Linux agpgart interface v0.103
[    2.512762] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.525333] brd: module loaded
[    2.530689] loop: module loaded
[    2.532072] pata_acpi 0000:03:00.1: enabling device (0000 -> 0001)
[    2.532137] pata_acpi 0000:03:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.532316] pata_acpi 0000:03:00.1: setting latency timer to 64
[    2.532337] pata_acpi 0000:03:00.1: PCI INT B disabled
[    2.535261] Fixed MDIO Bus: probed
[    2.535575] tun: Universal TUN/TAP device driver, 1.6
[    2.535632] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    2.536262] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.536381] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.536492] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    2.536495] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    2.537014] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    2.537181] ehci_hcd 0000:00:1a.0: debug port 2
[    2.541119] ehci_hcd 0000:00:1a.0: cache line size of 32 is not supported
[    2.541243] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf7ffe000
[    2.550929] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    2.552193] hub 1-0:1.0: USB hub found
[    2.552313] hub 1-0:1.0: 2 ports detected
[    2.553090]   alloc irq_desc for 23 on node -1
[    2.553099]   alloc kstat_irqs on node -1
[    2.553118] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.553217] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.553220] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    2.553678] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.553832] ehci_hcd 0000:00:1d.0: debug port 2
[    2.557756] ehci_hcd 0000:00:1d.0: cache line size of 32 is not supported
[    2.557866] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf7ffd000
[    2.567896] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    2.569092] hub 2-0:1.0: USB hub found
[    2.569212] hub 2-0:1.0: 2 ports detected
[    2.570050] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.570181] uhci_hcd: USB Universal Host Controller Interface driver
[    2.570786] PNP: No PS/2 controller found. Probing ports directly.
[    2.574049] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.574123] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.574603] mice: PS/2 mouse device common for all mice
[    2.575129] rtc_cmos 00:03: RTC can wake from S4
[    2.575561] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    2.575669] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    2.576275] device-mapper: uevent: version 1.0.3
[    2.576650] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
[    2.577137] device-mapper: multipath: version 1.1.1 loaded
[    2.577200] device-mapper: multipath round-robin: version 1.0.0 loaded
[    2.580868] cpuidle: using governor ladder
[    2.584691] cpuidle: using governor menu
[    2.585026] TCP cubic registered
[    2.585986] NET: Registered protocol family 10
[    2.587662] lo: Disabled Privacy Extensions
[    2.588010] NET: Registered protocol family 17
[    2.683464] kmemleak: Kernel memory leak detector initialized
[    2.683466] kmemleak: Automatic memory scanning thread started
[    2.684667]   Magic number: 2:713:600
[    2.685080] rtc_cmos 00:03: setting system clock to 2010-07-06 21:35:29 UTC (1278452129)
[    2.685157] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.685215] EDD information not available.
[    2.685870] Freeing unused kernel memory: 864k freed
[    2.686032] Write protecting the kernel read-only data: 10240k
[    2.686968] Freeing unused kernel memory: 832k freed
[    2.687683] Freeing unused kernel memory: 1968k freed
[    2.747460] udev: starting version 151
[    2.855363] usb 1-1: new high speed USB device using ehci_hcd and address 2
[    2.869720] pata_jmicron 0000:03:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.869952] pata_jmicron 0000:03:00.1: setting latency timer to 64
[    2.870325] scsi0 : pata_jmicron
[    2.871324] scsi1 : pata_jmicron
[    2.879906] ahci 0000:00:1f.2: version 3.0
[    2.879931]   alloc irq_desc for 21 on node -1
[    2.879942]   alloc kstat_irqs on node -1
[    2.879964] ahci 0000:00:1f.2: PCI INT D -> GSI 21 (level, low) -> IRQ 21
[    2.880161]   alloc irq_desc for 55 on node -1
[    2.880170]   alloc kstat_irqs on node -1
[    2.880184] ahci 0000:00:1f.2: irq 55 for MSI/MSI-X
[    2.880266] ahci: SSS flag set, parallel bus scan disabled
[    2.882864] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    2.882958] r8169 0000:0b:02.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.883122] r8169 0000:0b:02.0: (unregistered net_device): no PCI Express capability
[    2.884475] r8169 0000:0b:02.0: eth0: RTL8169sb/8110sb at 0xffffc9001181cc00, 00:27:19:b2:0e:4b, XID 10000000 IRQ 17
[    2.888241] ata1: PATA max UDMA/100 cmd 0xcc00 ctl 0xc880 bmdma 0xc400 irq 19
[    2.888309] ata2: PATA max UDMA/100 cmd 0xc800 ctl 0xc480 bmdma 0xc408 irq 19
[    2.891419] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    2.891498] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part ems sxs apst 
[    2.891580] ahci 0000:00:1f.2: setting latency timer to 64
[    2.904931] scsi2 : ahci
[    2.905800] scsi3 : ahci
[    2.906646] scsi4 : ahci
[    2.907488] scsi5 : ahci
[    2.908307] scsi6 : ahci
[    2.909139] scsi7 : ahci
[    2.914475] ata3: SATA max UDMA/133 abar m2048@0xf7ff7000 port 0xf7ff7100 irq 55
[    2.914551] ata4: SATA max UDMA/133 abar m2048@0xf7ff7000 port 0xf7ff7180 irq 55
[    2.914627] ata5: SATA max UDMA/133 abar m2048@0xf7ff7000 port 0xf7ff7200 irq 55
[    2.914702] ata6: SATA max UDMA/133 abar m2048@0xf7ff7000 port 0xf7ff7280 irq 55
[    2.914777] ata7: SATA max UDMA/133 abar m2048@0xf7ff7000 port 0xf7ff7300 irq 55
[    2.914852] ata8: SATA max UDMA/133 abar m2048@0xf7ff7000 port 0xf7ff7380 irq 55
[    2.915036] ahci 0000:08:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.915300]   alloc irq_desc for 56 on node -1
[    2.915309]   alloc kstat_irqs on node -1
[    2.915350] ahci 0000:08:00.0: irq 56 for MSI/MSI-X
[    2.915496] ahci 0000:08:00.0: AHCI 0001.0000 32 slots 2 ports 6 Gbps 0x3 impl SATA mode
[    2.915574] ahci 0000:08:00.0: flags: 64bit ncq sntf led only pmp fbs pio slum part sxs 
[    2.915653] ahci 0000:08:00.0: setting latency timer to 64
[    2.915673] ahci 0000:08:00.0: The port is not capable of FBS
[    2.915776] ahci 0000:08:00.0: The port is not capable of FBS
[    2.916075] scsi8 : ahci
[    2.916878] scsi9 : ahci
[    2.917585] ata9: SATA max UDMA/133 abar m2048@0xfbdff800 port 0xfbdff900 irq 56
[    2.917661] ata10: SATA max UDMA/133 abar m2048@0xfbdff800 port 0xfbdff980 irq 56
[    2.918968] ahci 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.930259] ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[    2.930447] ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
[    2.930512] ahci 0000:03:00.0: setting latency timer to 64
[    2.931016] scsi10 : ahci
[    2.931882] scsi11 : ahci
[    2.933996] ata11: SATA max UDMA/133 abar m8192@0xfbafe000 port 0xfbafe100 irq 18
[    2.934073] ata12: SATA max UDMA/133 abar m8192@0xfbafe000 port 0xfbafe180 irq 18
[    2.972068] hub 1-1:1.0: USB hub found
[    2.972389] hub 1-1:1.0: 6 ports detected
[    3.075048] usb 2-1: new high speed USB device using ehci_hcd and address 2
[    3.204405] hub 2-1:1.0: USB hub found
[    3.204552] hub 2-1:1.0: 8 ports detected
[    3.219815] ata3: SATA link down (SStatus 0 SControl 300)
[    3.225819] ata10: SATA link down (SStatus 0 SControl 370)
[    3.239848] ata12: SATA link down (SStatus 0 SControl 300)
[    3.239861] ata11: SATA link down (SStatus 0 SControl 300)
[    3.376562] ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 370)
[    3.376918] ata9.00: FORCE: horkage modified (noncq)
[    3.377030] ata9.00: ATA-7: INTEL SSDSA2M080G2GC, 2CV102HD, max UDMA/133
[    3.377104] ata9.00: 156301488 sectors, multi 1: LBA48 NCQ (not used)
[    3.377636] ata9.00: configured for UDMA/133
[    3.480588] usb 2-1.3: new full speed USB device using ehci_hcd and address 3
[    3.537265] ata4: SATA link down (SStatus 0 SControl 300)
[    3.592811] usbcore: registered new interface driver hiddev
[    3.595647] input: Logitech USB Gaming Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0/input/input2
[    3.596802] generic-usb 0003:046D:C049.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Gaming Mouse] on usb-0000:00:1d.0-1.3/input0
[    3.600643] generic-usb 0003:046D:C049.0002: hiddev96,hidraw1: USB HID v1.11 Device [Logitech USB Gaming Mouse] on usb-0000:00:1d.0-1.3/input1
[    3.600860] usbcore: registered new interface driver usbhid
[    3.600923] usbhid: USB HID core driver
[    3.635347] usb 2-1.5: new low speed USB device using ehci_hcd and address 4
[    3.737171] input: Logitech Logitech USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5/2-1.5:1.0/input/input3
[    3.738363] generic-usb 0003:046D:C30F.0003: input,hidraw2: USB HID v1.10 Keyboard [Logitech Logitech USB Keyboard] on usb-0000:00:1d.0-1.5/input0
[    3.748931] input: Logitech Logitech USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5/2-1.5:1.1/input/input4
[    3.750192] generic-usb 0003:046D:C30F.0004: input,hidraw3: USB HID v1.10 Device [Logitech Logitech USB Keyboard] on usb-0000:00:1d.0-1.5/input1
[    3.813099] usb 2-1.6: new high speed USB device using ehci_hcd and address 5
[    3.899546] hub 2-1.6:1.0: USB hub found
[    3.899848] hub 2-1.6:1.0: 3 ports detected
[    4.005497] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.005993] ata5.00: FORCE: horkage modified (noncq)
[    4.006065] ata5.00: ATAPI: ATAPI   iHAS120   6, 7L0E, max UDMA/100
[    4.007276] ata5.00: configured for UDMA/100
[    4.020183] scsi 4:0:0:0: CD-ROM            ATAPI    iHAS120   6      7L0E PQ: 0 ANSI: 5
[    4.026667] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    4.026750] Uniform CD-ROM driver Revision: 3.20
[    4.029053] sr 4:0:0:0: Attached scsi CD-ROM sr0
[    4.029870] sr 4:0:0:0: Attached scsi generic sg0 type 5
[    4.174469] usb 2-1.6.1: new high speed USB device using ehci_hcd and address 6
[    4.261021] hub 2-1.6.1:1.0: USB hub found
[    4.261286] hub 2-1.6.1:1.0: 3 ports detected
[    4.334988] ata6: SATA link down (SStatus 0 SControl 300)
[    4.535814] usb 2-1.6.1.1: new high speed USB device using ehci_hcd and address 7
[    4.650455] ata7: SATA link down (SStatus 0 SControl 300)
[    4.965888] ata8: SATA link down (SStatus 0 SControl 300)
[    4.977607] scsi 8:0:0:0: Direct-Access     ATA      INTEL SSDSA2M080 2CV1 PQ: 0 ANSI: 5
[    4.978814] sd 8:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
[    4.979391] sd 8:0:0:0: Attached scsi generic sg1 type 0
[    4.979571] sd 8:0:0:0: [sda] Write Protect is off
[    4.979633] sd 8:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.979949] sd 8:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.981505]  sda: sda1 sda2 sda3 < sda5 sda6 >
[    4.987364] sd 8:0:0:0: [sda] Attached SCSI disk
[    5.052727] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
[    5.296235] Adding 1986556k swap on /dev/sda6.  Priority:-1 extents:1 across:1986556k SSD
[    5.311612] EXT4-fs (sda5): re-mounted. Opts: errors=remount-ro
[    5.356893] udev: starting version 151
[    5.501727] [drm] Initialized drm 1.1.0 20060810
[    5.515402] ATK0110 ATK0110:00: EC enabled
[    5.703197] nouveau 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.703203] nouveau 0000:01:00.0: setting latency timer to 64
[    5.709329] [drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x0a0300b1)
[    5.714921] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from ACPI
[    5.714924] [drm] nouveau 0000:01:00.0: ... BIOS signature not found
[    5.714926] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
[    5.788982] [drm] nouveau 0000:01:00.0: ... appears to be valid
[    5.788986] [drm] nouveau 0000:01:00.0: BIT BIOS found
[    5.788989] [drm] nouveau 0000:01:00.0: Bios version 62.00.59.00
[    5.788991] [drm] nouveau 0000:01:00.0: TMDS table revision 2.0 not currently supported
[    5.788994] [drm] nouveau 0000:01:00.0: Found Display Configuration Block version 4.0
[    5.788997] [drm] nouveau 0000:01:00.0: Raw DCB entry 0: 04000320 00000028
[    5.789000] [drm] nouveau 0000:01:00.0: Raw DCB entry 1: 01000322 00020030
[    5.789002] [drm] nouveau 0000:01:00.0: Raw DCB entry 2: 02011310 00000028
[    5.789004] [drm] nouveau 0000:01:00.0: Raw DCB entry 3: 02011312 00020030
[    5.789006] [drm] nouveau 0000:01:00.0: Raw DCB entry 4: 010223f1 00c1c023
[    5.789009] [drm] nouveau 0000:01:00.0: DCB connector table: VHER 0x40 5 16 4
[    5.789011] [drm] nouveau 0000:01:00.0:   0: 0x00001030: type 0x30 idx 0 tag 0x07
[    5.789014] [drm] nouveau 0000:01:00.0:   1: 0x00002130: type 0x30 idx 1 tag 0x08
[    5.789016] [drm] nouveau 0000:01:00.0:   2: 0x00000210: type 0x10 idx 2 tag 0xff
[    5.789019] [drm] nouveau 0000:01:00.0:   3: 0x00000211: type 0x11 idx 3 tag 0xff
[    5.789021] [drm] nouveau 0000:01:00.0:   4: 0x00000213: type 0x13 idx 4 tag 0xff
[    5.789024] [drm] nouveau 0000:01:00.0:   5: 0x00000360: type 0x60 idx 5 tag 0xff
[    5.789032] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xD113
[    5.808604]   alloc irq_desc for 22 on node -1
[    5.808614]   alloc kstat_irqs on node -1
[    5.808639] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    5.808747]   alloc irq_desc for 57 on node -1
[    5.808756]   alloc kstat_irqs on node -1
[    5.808771] HDA Intel 0000:00:1b.0: irq 57 for MSI/MSI-X
[    5.808897] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    5.821206] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xD53E
[    5.825571] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xE9DB
[    5.825579] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xEAB8
[    5.827533] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xEB8A
[    5.827536] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xEBEF
[    5.849833] [drm] nouveau 0000:01:00.0: 0xEBEF: Condition still not met after 20ms, skipping following opcodes
[    5.849842] [drm] nouveau 0000:01:00.0: 0xC0A4: parsing output script 0
[    5.849847] [drm] nouveau 0000:01:00.0: 0xC0A4: parsing output script 0
[    5.849850] [drm] nouveau 0000:01:00.0: 0xA642: parsing output script 0
[    5.849860] [drm] nouveau 0000:01:00.0: Detected 896MiB VRAM
[    5.852999] r8169 0000:0b:02.0: eth0: link down
[    5.853784] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    5.963154] r8169 0000:0b:02.0: eth0: link up
[    5.963726] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    5.999209] [TTM] Zone  kernel: Available graphics memory: 4093644 kiB.
[    5.999211] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[    5.999213] [TTM] Initializing pool allocator.
[    5.999675] modprobe:548 freeing invalid memtype d0000000-d0040000
[    6.068037] [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
[    6.068071] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[    6.068347] modprobe:548 freeing invalid memtype d0140000-d0150000
[    6.068647] modprobe:548 freeing invalid memtype d0150000-d0160000
[    6.068890] [drm] nouveau 0000:01:00.0: Allocating FIFO number 1
[    6.069661] modprobe:548 freeing invalid memtype d0170000-d01f0000
[    6.085378] [drm] nouveau 0000:01:00.0: nouveau_channel_alloc: initialised FIFO 1
[    6.085969] modprobe:548 freeing invalid memtype d01f0000-d0200000
[    6.087673] modprobe:548 freeing invalid memtype d0210000-d0220000
[    6.087900] modprobe:548 freeing invalid memtype d0220000-d0230000
[    6.088092] modprobe:548 freeing invalid memtype d0230000-d0240000
[    6.088317] modprobe:548 freeing invalid memtype d0240000-d0250000
[    6.088448] [drm] nouveau 0000:01:00.0: Detected a DAC output
[    6.088467] [drm] nouveau 0000:01:00.0: Detected a TMDS output
[    6.088483] [drm] nouveau 0000:01:00.0: Detected a DAC output
[    6.088498] [drm] nouveau 0000:01:00.0: Detected a TMDS output
[    6.088510] [drm] nouveau 0000:01:00.0: DCB encoder 1 unknown
[    6.088512] [drm] nouveau 0000:01:00.0: Detected a DVI-I connector
[    6.089005] [drm] nouveau 0000:01:00.0: Detected a DVI-I connector
[    6.089561] [drm] nouveau 0000:01:00.0: Detected a TV connector
[    6.089579] [drm] nouveau 0000:01:00.0:   no encoders, ignoring
[    6.089587] [drm] nouveau 0000:01:00.0: Detected a HDMI connector
[    6.089618] [drm] nouveau 0000:01:00.0:   no encoders, ignoring
[    6.269539] [drm] nouveau 0000:01:00.0: allocated 2560x1600 fb: 0x40250000, bo ffff88023131fc00
[    6.270242] fb0: nouveaufb frame buffer device
[    6.270244] drm: registered panic notifier
[    6.270247] Slow work thread pool: Starting up
[    6.270463] Slow work thread pool: Ready
[    6.270480] [drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on minor 0
[    6.295084] [drm] nouveau 0000:01:00.0: 0xC0A8: parsing output script 1
[    6.295094] [drm] nouveau 0000:01:00.0: 0xC0A9: parsing output script 2
[    6.295114] [drm] nouveau 0000:01:00.0: 0xC066: parsing clock script 0
[    6.295429] [drm] nouveau 0000:01:00.0: 0xB913: parsing clock script 1
[    6.299516] Console: switching to colour frame buffer device 320x100



--- RC3 ---
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.35-rc3 (ahendry@jaunty) (gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5) ) #6 SMP PREEMPT Tue Jun 22 09:53:25 EST 2010
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.35-rc3 root=UUID=6b63a9f9-effe-44e3-a29d-95e3d202659a ro libata.force=noncq ramdisk_size=2000000
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009c800 (usable)
[    0.000000]  BIOS-e820: 000000000009c800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf770000 (usable)
[    0.000000]  BIOS-e820: 00000000bf770000 - 00000000bf788000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf788000 - 00000000bf7dc000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf7dc000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000240000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x240000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-DFFFF uncachable
[    0.000000]   E0000-E7FFF write-through
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 200000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000c0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbf770 max_arch_pfn = 0x400000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009c800 (usable)
[    0.000000]  modified: 000000000009c800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000bf770000 (usable)
[    0.000000]  modified: 00000000bf770000 - 00000000bf788000 (ACPI data)
[    0.000000]  modified: 00000000bf788000 - 00000000bf7dc000 (ACPI NVS)
[    0.000000]  modified: 00000000bf7dc000 - 00000000c0000000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000240000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] init_memory_mapping: 0000000000000000-00000000bf770000
[    0.000000]  0000000000 - 00bf600000 page 2M
[    0.000000]  00bf600000 - 00bf770000 page 4k
[    0.000000] kernel direct mapping tables up to bf770000 @ 16000-1b000
[    0.000000] init_memory_mapping: 0000000100000000-0000000240000000
[    0.000000]  0100000000 - 0240000000 page 2M
[    0.000000] kernel direct mapping tables up to 240000000 @ 19000-23000
[    0.000000] RAMDISK: 372e7000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000fbb00 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000bf770100 00064 (v01 032510 XSDT2140 20100325 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bf770290 000F4 (v03 032510 FACP2140 20100325 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bf7704a0 0EDBE (v01  A1513 A1513003 00000003 INTL 20060113)
[    0.000000] ACPI: FACS 00000000bf788000 00040
[    0.000000] ACPI: APIC 00000000bf770390 000CC (v01 032510 APIC2140 20100325 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bf770460 0003C (v01 032510 OEMMCFG  20100325 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bf788040 00072 (v01 032510 OEMB2140 20100325 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000bf77f7a0 00038 (v01 032510 OEMHPET  20100325 MSFT 00000097)
[    0.000000] ACPI: ASPT 00000000bf77fa40 00034 (v06 032510 PerfTune 20100325 MSFT 00000097)
[    0.000000] ACPI: OSFR 00000000bf77fa80 000B0 (v01 032510 OEMOSFR  20100325 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bf78a960 00363 (v01 DpgPmm    CpuPm 00000012 INTL 20060113)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000240000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000240000000
[    0.000000]   NODE_DATA [0000000100000000 - 0000000100004fff]
[    0.000000]  [ffffea0000000000-ffffea0007dfffff] PMD -> [ffff880100200000-ffff8801071fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00240000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009c
[    0.000000]     0: 0x00000100 -> 0x000bf770
[    0.000000]     0: 0x00100000 -> 0x00240000
[    0.000000] On node 0 totalpages: 2094844
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3924 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 765864 pages, LIFO batch:31
[    0.000000]   Normal zone: 17920 pages used for memmap
[    0.000000]   Normal zone: 1292800 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x88] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x89] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x8a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x8b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x8c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x8d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x8e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x8f] disabled)
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] SMP: Allowing 16 CPUs, 8 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [1e000 - 1e7ff]
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:3ee00000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:16 nr_cpumask_bits:16 nr_cpu_ids:16 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880001e00000 s91072 r8192 d23616 u131072
[    0.000000] early_res array is doubled to 128 at [1e800 - 1f7ff]
[    0.000000] pcpu-alloc: s91072 r8192 d23616 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2062588
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.35-rc3 root=UUID=6b63a9f9-effe-44e3-a29d-95e3d202659a ro libata.force=noncq ramdisk_size=2000000
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Subtract (66 early reservations)
[    0.000000]   #1 [0001000000 - 0001c8fe14]   TEXT DATA BSS
[    0.000000]   #2 [00372e7000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [0001c90000 - 0001c902c4]             BRK
[    0.000000]   #4 [00000ff790 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000ff780 - 00000ff790]    MP-table mpf
[    0.000000]   #6 [000009c800 - 00000f1310]   BIOS reserved
[    0.000000]   #7 [00000f14fc - 00000ff780]   BIOS reserved
[    0.000000]   #8 [00000f1310 - 00000f14fc]    MP-table mpc
[    0.000000]   #9 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #10 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #11 [0000016000 - 0000019000]         PGTABLE
[    0.000000]   #12 [0000019000 - 000001e000]         PGTABLE
[    0.000000]   #13 [0100000000 - 0100005000]       NODE_DATA
[    0.000000]   #14 [0001c90300 - 0001c91300]         BOOTMEM
[    0.000000]   #15 [0002091300 - 0002091900]         BOOTMEM
[    0.000000]   #16 [0100005000 - 0100006000]         BOOTMEM
[    0.000000]   #17 [0100006000 - 0100007000]         BOOTMEM
[    0.000000]   #18 [0100200000 - 0107200000]        MEMMAP 0
[    0.000000]   #19 [0001c8fe40 - 0001c8ffc0]         BOOTMEM
[    0.000000]   #20 [0001c91300 - 0001ca9300]         BOOTMEM
[    0.000000]   #21 [0001ca9300 - 0001cc1300]         BOOTMEM
[    0.000000]   #22 [0001cc2000 - 0001cc3000]         BOOTMEM
[    0.000000]   #23 [0001cc1300 - 0001cc1341]         BOOTMEM
[    0.000000]   #24 [0001cc1380 - 0001cc13c3]         BOOTMEM
[    0.000000]   #25 [0001cc1400 - 0001cc1668]         BOOTMEM
[    0.000000]   #26 [0001cc1680 - 0001cc16e8]         BOOTMEM
[    0.000000]   #27 [0001cc1700 - 0001cc1768]         BOOTMEM
[    0.000000]   #28 [0001cc1780 - 0001cc17e8]         BOOTMEM
[    0.000000]   #29 [0001cc1800 - 0001cc1868]         BOOTMEM
[    0.000000]   #30 [0001cc1880 - 0001cc18e8]         BOOTMEM
[    0.000000]   #31 [0001cc1900 - 0001cc1968]         BOOTMEM
[    0.000000]   #32 [0001cc1980 - 0001cc19e8]         BOOTMEM
[    0.000000]   #33 [0001cc1a00 - 0001cc1a68]         BOOTMEM
[    0.000000]   #34 [0001cc1a80 - 0001cc1ae8]         BOOTMEM
[    0.000000]   #35 [0001cc1b00 - 0001cc1b68]         BOOTMEM
[    0.000000]   #36 [0001cc1b80 - 0001cc1bfe]         BOOTMEM
[    0.000000]   #37 [0001cc1c00 - 0001cc1c7e]         BOOTMEM
[    0.000000]   #38 [0001e00000 - 0001e1e000]         BOOTMEM
[    0.000000]   #39 [0001e20000 - 0001e3e000]         BOOTMEM
[    0.000000]   #40 [0001e40000 - 0001e5e000]         BOOTMEM
[    0.000000]   #41 [0001e60000 - 0001e7e000]         BOOTMEM
[    0.000000]   #42 [0001e80000 - 0001e9e000]         BOOTMEM
[    0.000000]   #43 [0001ea0000 - 0001ebe000]         BOOTMEM
[    0.000000]   #44 [0001ec0000 - 0001ede000]         BOOTMEM
[    0.000000]   #45 [0001ee0000 - 0001efe000]         BOOTMEM
[    0.000000]   #46 [0001f00000 - 0001f1e000]         BOOTMEM
[    0.000000]   #47 [0001f20000 - 0001f3e000]         BOOTMEM
[    0.000000]   #48 [0001f40000 - 0001f5e000]         BOOTMEM
[    0.000000]   #49 [0001f60000 - 0001f7e000]         BOOTMEM
[    0.000000]   #50 [0001f80000 - 0001f9e000]         BOOTMEM
[    0.000000]   #51 [0001fa0000 - 0001fbe000]         BOOTMEM
[    0.000000]   #52 [0001fc0000 - 0001fde000]         BOOTMEM
[    0.000000]   #53 [0001fe0000 - 0001ffe000]         BOOTMEM
[    0.000000]   #54 [0001c8ffc0 - 0001c8ffc8]         BOOTMEM
[    0.000000]   #55 [0001cc1c80 - 0001cc1c88]         BOOTMEM
[    0.000000]   #56 [0001cc1cc0 - 0001cc1d00]         BOOTMEM
[    0.000000]   #57 [0001cc1d00 - 0001cc1d80]         BOOTMEM
[    0.000000]   #58 [0001cc1d80 - 0001cc1e90]         BOOTMEM
[    0.000000]   #59 [0001cc1ec0 - 0001cc1f08]         BOOTMEM
[    0.000000]   #60 [0001cc1f40 - 0001cc1f88]         BOOTMEM
[    0.000000]   #61 [0001cc3000 - 0001ccb000]         BOOTMEM
[    0.000000]   #62 [0002092000 - 0006092000]         BOOTMEM
[    0.000000]   #63 [0001ccb000 - 0001ceb000]         BOOTMEM
[    0.000000]   #64 [0001ceb000 - 0001d2b000]         BOOTMEM
[    0.000000]   #65 [000001f800 - 0000027800]         BOOTMEM
[    0.000000] Memory: 8170276k/9437184k available (5288k kernel code, 1057808k absent, 209100k reserved, 5636k data, 864k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:808
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 83886080 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.001000] Detected 2808.675 MHz processor.
[    0.000004] Calibrating delay loop (skipped), value calculated using timer frequency.. 5617.35 BogoMIPS (lpj=2808675)
[    0.000120] pid_max: default: 32768 minimum: 301
[    0.000310] Security Framework initialized
[    0.001602] Smack:  Initializing.
[    0.002376] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.004070] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.004806] Mount-cache hash table entries: 256
[    0.005749] Initializing cgroup subsys ns
[    0.005810] Initializing cgroup subsys cpuacct
[    0.005872] Initializing cgroup subsys memory
[    0.006006] Initializing cgroup subsys devices
[    0.006070] Initializing cgroup subsys freezer
[    0.006130] Initializing cgroup subsys net_cls
[    0.006271] CPU: Physical Processor ID: 0
[    0.006326] CPU: Processor Core ID: 0
[    0.006384] mce: CPU supports 9 MCE banks
[    0.006450] CPU0: Thermal monitoring enabled (TM1)
[    0.006520] using mwait in idle threads.
[    0.006575] Performance Events: PEBS fmt1+, Nehalem events, Intel PMU driver.
[    0.006741] ... version:                3
[    0.006795] ... bit width:              48
[    0.006850] ... generic registers:      4
[    0.006906] ... value mask:             0000ffffffffffff
[    0.006963] ... max period:             000000007fffffff
[    0.007020] ... fixed-purpose events:   3
[    0.007075] ... event mask:             000000070000000f
[    0.007841] ACPI: Core revision 20100428
[    0.238993] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.239054] ftrace: allocating 19694 entries in 78 pages
[    0.245186] Setting APIC routing to physical flat
[    0.245626] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.255997] CPU0: Intel(R) Core(TM) i7 CPU         860  @ 2.80GHz stepping 05
[    0.363042] Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7
[    1.010985] Brought up 8 CPUs
[    1.011088] Total of 8 processors activated (44933.64 BogoMIPS).
[    1.015124] devtmpfs: initialized
[    1.016774] regulator: core version 0.5
[    1.016882] Time: 21:37:21  Date: 07/06/10
[    1.017197] NET: Registered protocol family 16
[    1.018317] ACPI: bus type pci registered
[    1.018754] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    1.018836] PCI: not using MMCONFIG
[    1.018892] PCI: Using configuration type 1 for base access
[    1.027730] bio: create slab <bio-0> at 0
[    1.031216] ACPI: EC: Look up EC in DSDT
[    1.035596] ACPI: Executed 1 blocks of module-level executable AML code
[    1.387938] ACPI: SSDT 00000000bf7880c0 0223C (v01 DpgPmm  P001Ist 00000011 INTL 20060113)
[    1.396627] ACPI: Dynamic OEM Table Load:
[    1.396751] ACPI: SSDT (null) 0223C (v01 DpgPmm  P001Ist 00000011 INTL 20060113)
[    1.398559] ACPI: SSDT 00000000bf78a300 00659 (v01  PmRef  P001Cst 00003001 INTL 20060113)
[    1.401976] ACPI: Dynamic OEM Table Load:
[    1.402100] ACPI: SSDT (null) 00659 (v01  PmRef  P001Cst 00003001 INTL 20060113)
[    1.404318] ACPI: Interpreter enabled
[    1.404374] ACPI: (supports S0 S1 S3 S5)
[    1.404811] ACPI: Using IOAPIC for interrupt routing
[    1.405119] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    1.428230] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    1.612048] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
[    1.613948] ACPI: No dock devices found.
[    1.614005] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.619325] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.622844] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.622927] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.622995] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.623077] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
[    1.623159] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xdfffffff]
[    1.623241] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfed8ffff]
[    1.623433] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    1.623435] pci 0000:00:03.0: PME# disabled
[    1.623797] pci 0000:00:1a.0: reg 10: [mem 0xf7ffe000-0xf7ffe3ff]
[    1.623858] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    1.623862] pci 0000:00:1a.0: PME# disabled
[    1.623907] pci 0000:00:1b.0: reg 10: [mem 0xf7ff8000-0xf7ffbfff 64bit]
[    1.623953] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.623956] pci 0000:00:1b.0: PME# disabled
[    1.624036] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.624039] pci 0000:00:1c.0: PME# disabled
[    1.624122] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    1.624125] pci 0000:00:1c.5: PME# disabled
[    1.624205] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    1.624208] pci 0000:00:1c.6: PME# disabled
[    1.624289] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    1.624292] pci 0000:00:1c.7: PME# disabled
[    1.624344] pci 0000:00:1d.0: reg 10: [mem 0xf7ffd000-0xf7ffd3ff]
[    1.624394] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    1.624397] pci 0000:00:1d.0: PME# disabled
[    1.624593] pci 0000:00:1f.2: reg 10: [io  0xa880-0xa887]
[    1.624598] pci 0000:00:1f.2: reg 14: [io  0xa800-0xa803]
[    1.624602] pci 0000:00:1f.2: reg 18: [io  0xa480-0xa487]
[    1.624607] pci 0000:00:1f.2: reg 1c: [io  0xa400-0xa403]
[    1.624612] pci 0000:00:1f.2: reg 20: [io  0xa080-0xa09f]
[    1.624616] pci 0000:00:1f.2: reg 24: [mem 0xf7ff7000-0xf7ff77ff]
[    1.624644] pci 0000:00:1f.2: PME# supported from D3hot
[    1.624647] pci 0000:00:1f.2: PME# disabled
[    1.624686] pci 0000:00:1f.3: reg 10: [mem 0xf7ffc000-0xf7ffc0ff 64bit]
[    1.624698] pci 0000:00:1f.3: reg 20: [io  0xffe0-0xffff]
[    1.624790] pci 0000:01:00.0: reg 10: [mem 0xfa000000-0xfaffffff]
[    1.624797] pci 0000:01:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.624805] pci 0000:01:00.0: reg 1c: [mem 0xf8000000-0xf9ffffff 64bit]
[    1.624809] pci 0000:01:00.0: reg 24: [io  0xbc00-0xbc7f]
[    1.624814] pci 0000:01:00.0: reg 30: [mem 0xfb980000-0xfb9fffff pref]
[    1.624852] pci 0000:00:03.0: PCI bridge to [bus 01-01]
[    1.624912] pci 0000:00:03.0:   bridge window [io  0xb000-0xbfff]
[    1.624915] pci 0000:00:03.0:   bridge window [mem 0xf8000000-0xfb9fffff]
[    1.624919] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.625011] pci 0000:05:00.0: reg 10: [mem 0xfbbe0000-0xfbbfffff]
[    1.625072] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    1.625075] pci 0000:05:00.0: PME# disabled
[    1.625102] pci 0000:00:1c.0: PCI bridge to [bus 05-0a]
[    1.625161] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    1.625164] pci 0000:00:1c.0:   bridge window [mem 0xfbb00000-0xfbdfffff]
[    1.625169] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.625346] pci 0000:06:01.0: PME# supported from D0 D3hot D3cold
[    1.625350] pci 0000:06:01.0: PME# disabled
[    1.625476] pci 0000:06:05.0: PME# supported from D0 D3hot D3cold
[    1.625480] pci 0000:06:05.0: PME# disabled
[    1.625603] pci 0000:06:07.0: PME# supported from D0 D3hot D3cold
[    1.625606] pci 0000:06:07.0: PME# disabled
[    1.625731] pci 0000:06:09.0: PME# supported from D0 D3hot D3cold
[    1.625735] pci 0000:06:09.0: PME# disabled
[    1.625780] pci 0000:05:00.0: PCI bridge to [bus 06-0a]
[    1.625844] pci 0000:05:00.0:   bridge window [io  0xd000-0xdfff]
[    1.625848] pci 0000:05:00.0:   bridge window [mem 0xfbc00000-0xfbdfffff]
[    1.625855] pci 0000:05:00.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.625994] pci 0000:07:00.0: reg 10: [mem 0xfbcfe000-0xfbcfffff 64bit]
[    1.626083] pci 0000:07:00.0: PME# supported from D0 D3hot D3cold
[    1.626088] pci 0000:07:00.0: PME# disabled
[    1.626116] pci 0000:06:01.0: PCI bridge to [bus 07-07]
[    1.626178] pci 0000:06:01.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.626182] pci 0000:06:01.0:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    1.626189] pci 0000:06:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.626314] pci 0000:08:00.0: reg 10: [io  0xdc00-0xdc07]
[    1.626322] pci 0000:08:00.0: reg 14: [io  0xd880-0xd883]
[    1.626329] pci 0000:08:00.0: reg 18: [io  0xd800-0xd807]
[    1.626337] pci 0000:08:00.0: reg 1c: [io  0xd480-0xd483]
[    1.626344] pci 0000:08:00.0: reg 20: [io  0xd400-0xd40f]
[    1.626352] pci 0000:08:00.0: reg 24: [mem 0xfbdff800-0xfbdfffff]
[    1.626359] pci 0000:08:00.0: reg 30: [mem 0xfbde0000-0xfbdeffff pref]
[    1.626404] pci 0000:08:00.0: PME# supported from D3hot
[    1.626408] pci 0000:08:00.0: PME# disabled
[    1.626424] pci 0000:06:05.0: PCI bridge to [bus 08-08]
[    1.626487] pci 0000:06:05.0:   bridge window [io  0xd000-0xdfff]
[    1.626491] pci 0000:06:05.0:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    1.626497] pci 0000:06:05.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.626574] pci 0000:06:07.0: PCI bridge to [bus 09-09]
[    1.626637] pci 0000:06:07.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.626641] pci 0000:06:07.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.626647] pci 0000:06:07.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.626725] pci 0000:06:09.0: PCI bridge to [bus 0a-0a]
[    1.626787] pci 0000:06:09.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.626791] pci 0000:06:09.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.626798] pci 0000:06:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.626879] pci 0000:00:1c.5: PCI bridge to [bus 04-04]
[    1.626939] pci 0000:00:1c.5:   bridge window [io  0xf000-0x0000] (disabled)
[    1.626942] pci 0000:00:1c.5:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.626947] pci 0000:00:1c.5:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.627086] pci 0000:03:00.0: reg 24: [mem 0xfbafe000-0xfbafffff]
[    1.627131] pci 0000:03:00.0: PME# supported from D3hot
[    1.627136] pci 0000:03:00.0: PME# disabled
[    1.627197] pci 0000:03:00.1: reg 10: [io  0xcc00-0xcc07]
[    1.627205] pci 0000:03:00.1: reg 14: [io  0xc880-0xc883]
[    1.627213] pci 0000:03:00.1: reg 18: [io  0xc800-0xc807]
[    1.627221] pci 0000:03:00.1: reg 1c: [io  0xc480-0xc483]
[    1.627229] pci 0000:03:00.1: reg 20: [io  0xc400-0xc40f]
[    1.627286] pci 0000:00:1c.6: PCI bridge to [bus 03-03]
[    1.627345] pci 0000:00:1c.6:   bridge window [io  0xc000-0xcfff]
[    1.627348] pci 0000:00:1c.6:   bridge window [mem 0xfba00000-0xfbafffff]
[    1.627353] pci 0000:00:1c.6:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.627406] pci 0000:00:1c.7: PCI bridge to [bus 02-02]
[    1.627465] pci 0000:00:1c.7:   bridge window [io  0xf000-0x0000] (disabled)
[    1.627468] pci 0000:00:1c.7:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.627473] pci 0000:00:1c.7:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.627548] pci 0000:0b:02.0: reg 10: [io  0xe800-0xe8ff]
[    1.627554] pci 0000:0b:02.0: reg 14: [mem 0xfbeffc00-0xfbeffcff]
[    1.627577] pci 0000:0b:02.0: reg 30: [mem 0xfbec0000-0xfbedffff pref]
[    1.627595] pci 0000:0b:02.0: supports D1 D2
[    1.627596] pci 0000:0b:02.0: PME# supported from D1 D2 D3hot D3cold
[    1.627600] pci 0000:0b:02.0: PME# disabled
[    1.627639] pci 0000:00:1e.0: PCI bridge to [bus 0b-0b] (subtractive decode)
[    1.627701] pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
[    1.627704] pci 0000:00:1e.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    1.627709] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.627719] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    1.627730] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    1.627740] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.627749] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    1.627759] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xdfffffff] (subtractive decode)
[    1.627770] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfed8ffff] (subtractive decode)
[    1.627810] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.636142] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR1E._PRT]
[    1.638955] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
[    1.640215] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR20._PRT]
[    1.642241] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR26._PRT]
[    1.643577] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR27._PRT]
[    2.045761] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12 14 15)
[    2.046953] ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
[    2.047856] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 11 12 14 *15)
[    2.049033] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 *11 12 14 15)
[    2.050228] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
[    2.051542] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12 *14 15)
[    2.052725] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 6 7 10 11 12 14 15)
[    2.053920] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 *7 10 11 12 14 15)
[    2.055144] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    2.055271] vgaarb: loaded
[    2.056424] SCSI subsystem initialized
[    2.056866] libata version 3.00 loaded.
[    2.057356] usbcore: registered new interface driver usbfs
[    2.057530] usbcore: registered new interface driver hub
[    2.057689] usbcore: registered new device driver usb
[    2.058796] ACPI: WMI: Mapper loaded
[    2.058851] PCI: Using ACPI for IRQ routing
[    2.058906] PCI: pci_cache_line_size set to 64 bytes
[    2.059302] reserve RAM buffer: 000000000009c800 - 000000000009ffff 
[    2.059309] reserve RAM buffer: 00000000bf770000 - 00000000bfffffff 
[    2.060067] NetLabel: Initializing
[    2.060121] NetLabel:  domain hash size = 128
[    2.060186] NetLabel:  protocols = UNLABELED CIPSOv4
[    2.060328] NetLabel:  unlabeled traffic allowed by default
[    2.060591]   alloc irq_desc for 40 on node 0
[    2.060596]   alloc kstat_irqs on node 0
[    2.060609]   alloc irq_desc for 41 on node 0
[    2.060614]   alloc kstat_irqs on node 0
[    2.060625]   alloc irq_desc for 42 on node 0
[    2.060630]   alloc kstat_irqs on node 0
[    2.060640]   alloc irq_desc for 43 on node 0
[    2.060645]   alloc kstat_irqs on node 0
[    2.060656]   alloc irq_desc for 44 on node 0
[    2.060661]   alloc kstat_irqs on node 0
[    2.060667] HPET: 8 timers in total, 5 timers will be used for per-cpu timer
[    2.060737] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 40, 41, 42, 43, 44, 0
[    2.061101] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    2.064152] hpet: hpet2 irq 40 for MSI
[    2.065228] hpet: hpet3 irq 41 for MSI
[    2.066327] hpet: hpet4 irq 42 for MSI
[    2.067344] hpet: hpet5 irq 43 for MSI
[    2.068247] hpet: hpet6 irq 44 for MSI
[    2.071414] Switching to clocksource tsc
[    2.103974] pnp: PnP ACPI init
[    2.104089] ACPI: bus type pnp registered
[    2.131544] pnp: PnP ACPI: found 14 devices
[    2.131600] ACPI: ACPI bus type pnp unregistered
[    2.131713] system 00:01: [mem 0xfc000000-0xfcffffff] has been reserved
[    2.131783] system 00:01: [mem 0xfd000000-0xfdffffff] has been reserved
[    2.131855] system 00:01: [mem 0xfe000000-0xfebfffff] has been reserved
[    2.131926] system 00:01: [mem 0xfed14000-0xfed19fff] has been reserved
[    2.132020] system 00:06: [io  0x0290-0x029f] has been reserved
[    2.132112] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    2.132181] system 00:07: [io  0x0800-0x087f] has been reserved
[    2.132250] system 00:07: [io  0x0500-0x057f] has been reserved
[    2.132319] system 00:07: [io  0x0600-0x0607] has been reserved
[    2.132388] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    2.132458] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[    2.132546] system 00:07: [mem 0xfed40000-0xfed8ffff] has been reserved
[    2.132648] system 00:0a: [mem 0xffc00000-0xffdfffff] has been reserved
[    2.132747] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be reserved
[    2.132820] system 00:0b: [mem 0xfee00000-0xfee00fff] has been reserved
[    2.132917] system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
[    2.133100] system 00:0d: [mem 0x00000000-0x0009ffff] could not be reserved
[    2.133173] system 00:0d: [mem 0x000c0000-0x000cffff] has been reserved
[    2.133247] system 00:0d: [mem 0x000e0000-0x000fffff] could not be reserved
[    2.133321] system 00:0d: [mem 0x00100000-0xbfffffff] could not be reserved
[    2.133395] system 00:0d: [mem 0xfed90000-0xffffffff] could not be reserved
[    2.139890] pci 0000:00:1c.7: BAR 14: assigned [mem 0xc0000000-0xc01fffff]
[    2.139954] pci 0000:00:1c.7: BAR 15: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
[    2.140031] pci 0000:00:1c.7: BAR 13: assigned [io  0x1000-0x1fff]
[    2.140092] pci 0000:00:03.0: PCI bridge to [bus 01-01]
[    2.140150] pci 0000:00:03.0:   bridge window [io  0xb000-0xbfff]
[    2.140210] pci 0000:00:03.0:   bridge window [mem 0xf8000000-0xfb9fffff]
[    2.140272] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    2.140350] pci 0000:06:01.0: PCI bridge to [bus 07-07]
[    2.140407] pci 0000:06:01.0:   bridge window [io  disabled]
[    2.140473] pci 0000:06:01.0:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    2.140536] pci 0000:06:01.0:   bridge window [mem pref disabled]
[    2.140600] pci 0000:06:05.0: PCI bridge to [bus 08-08]
[    2.140658] pci 0000:06:05.0:   bridge window [io  0xd000-0xdfff]
[    2.140721] pci 0000:06:05.0:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    2.140783] pci 0000:06:05.0:   bridge window [mem pref disabled]
[    2.140847] pci 0000:06:07.0: PCI bridge to [bus 09-09]
[    2.140903] pci 0000:06:07.0:   bridge window [io  disabled]
[    2.140965] pci 0000:06:07.0:   bridge window [mem disabled]
[    2.141025] pci 0000:06:07.0:   bridge window [mem pref disabled]
[    2.141089] pci 0000:06:09.0: PCI bridge to [bus 0a-0a]
[    2.141146] pci 0000:06:09.0:   bridge window [io  disabled]
[    2.141207] pci 0000:06:09.0:   bridge window [mem disabled]
[    2.141267] pci 0000:06:09.0:   bridge window [mem pref disabled]
[    2.141331] pci 0000:05:00.0: PCI bridge to [bus 06-0a]
[    2.141389] pci 0000:05:00.0:   bridge window [io  0xd000-0xdfff]
[    2.141452] pci 0000:05:00.0:   bridge window [mem 0xfbc00000-0xfbdfffff]
[    2.141517] pci 0000:05:00.0:   bridge window [mem pref disabled]
[    2.141581] pci 0000:00:1c.0: PCI bridge to [bus 05-0a]
[    2.141639] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    2.141701] pci 0000:00:1c.0:   bridge window [mem 0xfbb00000-0xfbdfffff]
[    2.141762] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    2.141824] pci 0000:00:1c.5: PCI bridge to [bus 04-04]
[    2.141881] pci 0000:00:1c.5:   bridge window [io  disabled]
[    2.141941] pci 0000:00:1c.5:   bridge window [mem disabled]
[    2.142001] pci 0000:00:1c.5:   bridge window [mem pref disabled]
[    2.142063] pci 0000:00:1c.6: PCI bridge to [bus 03-03]
[    2.142121] pci 0000:00:1c.6:   bridge window [io  0xc000-0xcfff]
[    2.142182] pci 0000:00:1c.6:   bridge window [mem 0xfba00000-0xfbafffff]
[    2.142244] pci 0000:00:1c.6:   bridge window [mem pref disabled]
[    2.142306] pci 0000:00:1c.7: PCI bridge to [bus 02-02]
[    2.143438] pci 0000:00:1c.7:   bridge window [io  0x1000-0x1fff]
[    2.143503] pci 0000:00:1c.7:   bridge window [mem 0xc0000000-0xc01fffff]
[    2.143565] pci 0000:00:1c.7:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
[    2.143643] pci 0000:00:1e.0: PCI bridge to [bus 0b-0b]
[    2.143702] pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
[    2.143763] pci 0000:00:1e.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    2.143825] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    2.143899]   alloc irq_desc for 16 on node -1
[    2.143907]   alloc kstat_irqs on node -1
[    2.143923] pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.143985] pci 0000:00:03.0: setting latency timer to 64
[    2.143997]   alloc irq_desc for 17 on node -1
[    2.144005]   alloc kstat_irqs on node -1
[    2.144020] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.144082] pci 0000:00:1c.0: setting latency timer to 64
[    2.144090] pci 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.144152] pci 0000:05:00.0: setting latency timer to 64
[    2.144161] pci 0000:06:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.144224] pci 0000:06:01.0: setting latency timer to 64
[    2.144232] pci 0000:06:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.144294] pci 0000:06:05.0: setting latency timer to 64
[    2.144309]   alloc irq_desc for 19 on node -1
[    2.144317]   alloc kstat_irqs on node -1
[    2.144333] pci 0000:06:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.144395] pci 0000:06:07.0: setting latency timer to 64
[    2.144404] pci 0000:06:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.144470] pci 0000:06:09.0: setting latency timer to 64
[    2.144477] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    2.144539] pci 0000:00:1c.5: setting latency timer to 64
[    2.144552]   alloc irq_desc for 18 on node -1
[    2.144560]   alloc kstat_irqs on node -1
[    2.144575] pci 0000:00:1c.6: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.144636] pci 0000:00:1c.6: setting latency timer to 64
[    2.144643] pci 0000:00:1c.7: enabling device (0104 -> 0107)
[    2.144702] pci 0000:00:1c.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    2.144764] pci 0000:00:1c.7: setting latency timer to 64
[    2.144769] pci 0000:00:1e.0: setting latency timer to 64
[    2.144772] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.144773] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.144775] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.144777] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    2.144778] pci_bus 0000:00: resource 8 [mem 0xc0000000-0xdfffffff]
[    2.144780] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfed8ffff]
[    2.144782] pci_bus 0000:01: resource 0 [io  0xb000-0xbfff]
[    2.144783] pci_bus 0000:01: resource 1 [mem 0xf8000000-0xfb9fffff]
[    2.144785] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    2.144787] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]
[    2.144788] pci_bus 0000:05: resource 1 [mem 0xfbb00000-0xfbdfffff]
[    2.144790] pci_bus 0000:06: resource 0 [io  0xd000-0xdfff]
[    2.144792] pci_bus 0000:06: resource 1 [mem 0xfbc00000-0xfbdfffff]
[    2.144793] pci_bus 0000:07: resource 1 [mem 0xfbc00000-0xfbcfffff]
[    2.144795] pci_bus 0000:08: resource 0 [io  0xd000-0xdfff]
[    2.144796] pci_bus 0000:08: resource 1 [mem 0xfbd00000-0xfbdfffff]
[    2.144798] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
[    2.144800] pci_bus 0000:03: resource 1 [mem 0xfba00000-0xfbafffff]
[    2.144801] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    2.144803] pci_bus 0000:02: resource 1 [mem 0xc0000000-0xc01fffff]
[    2.144805] pci_bus 0000:02: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
[    2.144806] pci_bus 0000:0b: resource 0 [io  0xe000-0xefff]
[    2.144808] pci_bus 0000:0b: resource 1 [mem 0xfbe00000-0xfbefffff]
[    2.144810] pci_bus 0000:0b: resource 4 [io  0x0000-0x0cf7]
[    2.144811] pci_bus 0000:0b: resource 5 [io  0x0d00-0xffff]
[    2.144813] pci_bus 0000:0b: resource 6 [mem 0x000a0000-0x000bffff]
[    2.144815] pci_bus 0000:0b: resource 7 [mem 0x000d0000-0x000dffff]
[    2.144816] pci_bus 0000:0b: resource 8 [mem 0xc0000000-0xdfffffff]
[    2.144818] pci_bus 0000:0b: resource 9 [mem 0xf0000000-0xfed8ffff]
[    2.144909] NET: Registered protocol family 2
[    2.145231] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    2.146614] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    2.148964] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    2.149289] TCP: Hash tables configured (established 524288 bind 65536)
[    2.149350] TCP reno registered
[    2.149439] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    2.149585] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    2.150464] NET: Registered protocol family 1
[    2.150762] pci 0000:01:00.0: Boot video device
[    2.150877] PCI: CLS 32 bytes, default 64
[    2.151135] Trying to unpack rootfs image as initramfs...
[    2.389261] Freeing initrd memory: 13348k freed
[    2.391051] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.391114] Placing 64MB software IO TLB between ffff880002092000 - ffff880006092000
[    2.391194] software IO TLB at phys 0x2092000 - 0x6092000
[    2.396695] Scanning for low memory corruption every 60 seconds
[    2.397163] audit: initializing netlink socket (disabled)
[    2.397279] type=2000 audit(1278452242.210:1): initialized
[    2.403884] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.416712] VFS: Disk quotas dquot_6.5.2
[    2.417014] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.421592] fuse init (API version 7.14)
[    2.422409] msgmni has been set to 15983
[    2.423526] alg: No test for stdrng (krng)
[    2.423885] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    2.423961] io scheduler noop registered
[    2.424016] io scheduler deadline registered
[    2.424300] io scheduler cfq registered (default)
[    2.425111] pcieport 0000:00:03.0: setting latency timer to 64
[    2.425151]   alloc irq_desc for 45 on node -1
[    2.425161]   alloc kstat_irqs on node -1
[    2.425175] pcieport 0000:00:03.0: irq 45 for MSI/MSI-X
[    2.425514] pcieport 0000:00:1c.0: setting latency timer to 64
[    2.425554]   alloc irq_desc for 46 on node -1
[    2.425564]   alloc kstat_irqs on node -1
[    2.425576] pcieport 0000:00:1c.0: irq 46 for MSI/MSI-X
[    2.425777] pcieport 0000:00:1c.5: setting latency timer to 64
[    2.425819]   alloc irq_desc for 47 on node -1
[    2.425827]   alloc kstat_irqs on node -1
[    2.425839] pcieport 0000:00:1c.5: irq 47 for MSI/MSI-X
[    2.426039] pcieport 0000:00:1c.6: setting latency timer to 64
[    2.426080]   alloc irq_desc for 48 on node -1
[    2.426089]   alloc kstat_irqs on node -1
[    2.426101] pcieport 0000:00:1c.6: irq 48 for MSI/MSI-X
[    2.426338] pcieport 0000:00:1c.7: setting latency timer to 64
[    2.426380]   alloc irq_desc for 49 on node -1
[    2.426389]   alloc kstat_irqs on node -1
[    2.426403] pcieport 0000:00:1c.7: irq 49 for MSI/MSI-X
[    2.426793] pcieport 0000:05:00.0: setting latency timer to 64
[    2.426849]   alloc irq_desc for 50 on node -1
[    2.426858]   alloc kstat_irqs on node -1
[    2.426874] pcieport 0000:05:00.0: irq 50 for MSI/MSI-X
[    2.427282] pcieport 0000:06:01.0: setting latency timer to 64
[    2.427338]   alloc irq_desc for 51 on node -1
[    2.427347]   alloc kstat_irqs on node -1
[    2.427363] pcieport 0000:06:01.0: irq 51 for MSI/MSI-X
[    2.427766] pcieport 0000:06:05.0: setting latency timer to 64
[    2.427822]   alloc irq_desc for 52 on node -1
[    2.427831]   alloc kstat_irqs on node -1
[    2.427847] pcieport 0000:06:05.0: irq 52 for MSI/MSI-X
[    2.428256] pcieport 0000:06:07.0: setting latency timer to 64
[    2.428311]   alloc irq_desc for 53 on node -1
[    2.428321]   alloc kstat_irqs on node -1
[    2.428337] pcieport 0000:06:07.0: irq 53 for MSI/MSI-X
[    2.428740] pcieport 0000:06:09.0: setting latency timer to 64
[    2.428795]   alloc irq_desc for 54 on node -1
[    2.428804]   alloc kstat_irqs on node -1
[    2.428820] pcieport 0000:06:09.0: irq 54 for MSI/MSI-X
[    2.429309] Firmware did not grant requested _OSC control
[    2.429311] aer 0000:00:03.0:pcie02: AER service couldn't init device: no _OSC support
[    2.429410] pcieport 0000:00:03.0: Requesting control of PCIe PME from ACPI BIOS
[    2.429495] Firmware did not grant requested _OSC control
[    2.429496] pcieport 0000:00:03.0: Failed to receive control of PCIe PME service: no _OSC support
[    2.429579] pcie_pme: probe of 0000:00:03.0:pcie01 failed with error -13
[    2.429664] pcieport 0000:00:1c.0: Requesting control of PCIe PME from ACPI BIOS
[    2.429748] Firmware did not grant requested _OSC control
[    2.429749] pcieport 0000:00:1c.0: Failed to receive control of PCIe PME service: no _OSC support
[    2.429831] pcie_pme: probe of 0000:00:1c.0:pcie01 failed with error -13
[    2.429916] pcieport 0000:00:1c.5: Requesting control of PCIe PME from ACPI BIOS
[    2.430000] Firmware did not grant requested _OSC control
[    2.430001] pcieport 0000:00:1c.5: Failed to receive control of PCIe PME service: no _OSC support
[    2.430083] pcie_pme: probe of 0000:00:1c.5:pcie01 failed with error -13
[    2.430172] pcieport 0000:00:1c.6: Requesting control of PCIe PME from ACPI BIOS
[    2.430256] Firmware did not grant requested _OSC control
[    2.430258] pcieport 0000:00:1c.6: Failed to receive control of PCIe PME service: no _OSC support
[    2.430340] pcie_pme: probe of 0000:00:1c.6:pcie01 failed with error -13
[    2.430425] pcieport 0000:00:1c.7: Requesting control of PCIe PME from ACPI BIOS
[    2.430508] Firmware did not grant requested _OSC control
[    2.430510] pcieport 0000:00:1c.7: Failed to receive control of PCIe PME service: no _OSC support
[    2.430592] pcie_pme: probe of 0000:00:1c.7:pcie01 failed with error -13
[    2.430777] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.430909] Firmware did not grant requested _OSC control
[    2.431065] Firmware did not grant requested _OSC control
[    2.431116] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.432030] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    2.432109] ACPI: Power Button [PWRB]
[    2.432611] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.432687] ACPI: Power Button [PWRF]
[    2.436529] ACPI: acpi_idle registered with cpuidle
[    2.439411] Monitor-Mwait will be used to enter C-1 state
[    2.439461] Monitor-Mwait will be used to enter C-2 state
[    2.439510] Monitor-Mwait will be used to enter C-3 state
[    2.518245] Linux agpgart interface v0.103
[    2.518383] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.530603] brd: module loaded
[    2.535979] loop: module loaded
[    2.537362] pata_acpi 0000:03:00.1: enabling device (0000 -> 0001)
[    2.537427] pata_acpi 0000:03:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.537605] pata_acpi 0000:03:00.1: setting latency timer to 64
[    2.537626] pata_acpi 0000:03:00.1: PCI INT B disabled
[    2.540569] Fixed MDIO Bus: probed
[    2.540883] tun: Universal TUN/TAP device driver, 1.6
[    2.540940] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    2.541569] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.541688] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.541797] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    2.541800] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    2.542316] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    2.542481] ehci_hcd 0000:00:1a.0: debug port 2
[    2.546409] ehci_hcd 0000:00:1a.0: cache line size of 32 is not supported
[    2.546534] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf7ffe000
[    2.555936] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    2.557198] hub 1-0:1.0: USB hub found
[    2.557318] hub 1-0:1.0: 2 ports detected
[    2.558102]   alloc irq_desc for 23 on node -1
[    2.558111]   alloc kstat_irqs on node -1
[    2.558130] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.558230] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.558232] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    2.558689] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.558844] ehci_hcd 0000:00:1d.0: debug port 2
[    2.562771] ehci_hcd 0000:00:1d.0: cache line size of 32 is not supported
[    2.562880] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf7ffd000
[    2.572903] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    2.574101] hub 2-0:1.0: USB hub found
[    2.574221] hub 2-0:1.0: 2 ports detected
[    2.575062] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.575193] uhci_hcd: USB Universal Host Controller Interface driver
[    2.575799] PNP: No PS/2 controller found. Probing ports directly.
[    2.578476] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.578549] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.579084] mice: PS/2 mouse device common for all mice
[    2.579657] rtc_cmos 00:03: RTC can wake from S4
[    2.580142] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    2.580253] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    2.580919] device-mapper: uevent: version 1.0.3
[    2.581291] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
[    2.581770] device-mapper: multipath: version 1.1.1 loaded
[    2.581834] device-mapper: multipath round-robin: version 1.0.0 loaded
[    2.585470] cpuidle: using governor ladder
[    2.589569] cpuidle: using governor menu
[    2.589916] TCP cubic registered
[    2.590948] NET: Registered protocol family 10
[    2.592622] lo: Disabled Privacy Extensions
[    2.592971] NET: Registered protocol family 17
[    2.687552] kmemleak: Kernel memory leak detector initialized
[    2.687554] kmemleak: Automatic memory scanning thread started
[    2.688737]   Magic number: 2:266:651
[    2.688821] processor LNXCPU:04: hash matches
[    2.689165] rtc_cmos 00:03: setting system clock to 2010-07-06 21:37:23 UTC (1278452243)
[    2.689242] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.689300] EDD information not available.
[    2.689854] Freeing unused kernel memory: 864k freed
[    2.690014] Write protecting the kernel read-only data: 10240k
[    2.691268] Freeing unused kernel memory: 836k freed
[    2.692124] Freeing unused kernel memory: 1968k freed
[    2.753270] udev: starting version 151
[    2.858361] usb 1-1: new high speed USB device using ehci_hcd and address 2
[    2.878704] pata_jmicron 0000:03:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.878904] pata_jmicron 0000:03:00.1: setting latency timer to 64
[    2.879281] scsi0 : pata_jmicron
[    2.880312] scsi1 : pata_jmicron
[    2.889717] ahci 0000:00:1f.2: version 3.0
[    2.889748]   alloc irq_desc for 21 on node -1
[    2.889761]   alloc kstat_irqs on node -1
[    2.889792] ahci 0000:00:1f.2: PCI INT D -> GSI 21 (level, low) -> IRQ 21
[    2.890059]   alloc irq_desc for 55 on node -1
[    2.890073]   alloc kstat_irqs on node -1
[    2.890095] ahci 0000:00:1f.2: irq 55 for MSI/MSI-X
[    2.890219] ahci: SSS flag set, parallel bus scan disabled
[    2.895181] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    2.895276] r8169 0000:0b:02.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.895469] r8169 0000:0b:02.0: (unregistered net_device): no PCI Express capability
[    2.897385] r8169 0000:0b:02.0: eth0: RTL8169sb/8110sb at 0xffffc9001181cc00, 00:27:19:b2:0e:4b, XID 10000000 IRQ 17
[    2.900439] ata1: PATA max UDMA/100 cmd 0xcc00 ctl 0xc880 bmdma 0xc400 irq 19
[    2.900501] ata2: PATA max UDMA/100 cmd 0xc800 ctl 0xc480 bmdma 0xc408 irq 19
[    2.901314] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    2.901481] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part ems sxs apst 
[    2.901561] ahci 0000:00:1f.2: setting latency timer to 64
[    2.911864] scsi2 : ahci
[    2.912856] scsi3 : ahci
[    2.913722] scsi4 : ahci
[    2.914649] scsi5 : ahci
[    2.915651] scsi6 : ahci
[    2.916640] scsi7 : ahci
[    2.921811] ata3: SATA max UDMA/133 abar m2048@0xf7ff7000 port 0xf7ff7100 irq 55
[    2.923009] ata4: SATA max UDMA/133 abar m2048@0xf7ff7000 port 0xf7ff7180 irq 55
[    2.923084] ata5: SATA max UDMA/133 abar m2048@0xf7ff7000 port 0xf7ff7200 irq 55
[    2.923161] ata6: SATA max UDMA/133 abar m2048@0xf7ff7000 port 0xf7ff7280 irq 55
[    2.923264] ata7: SATA max UDMA/133 abar m2048@0xf7ff7000 port 0xf7ff7300 irq 55
[    2.923409] ata8: SATA max UDMA/133 abar m2048@0xf7ff7000 port 0xf7ff7380 irq 55
[    2.923590] ahci 0000:08:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.924070]   alloc irq_desc for 56 on node -1
[    2.924079]   alloc kstat_irqs on node -1
[    2.924096] ahci 0000:08:00.0: irq 56 for MSI/MSI-X
[    2.924204] ahci 0000:08:00.0: AHCI 0001.0000 32 slots 2 ports 6 Gbps 0x3 impl SATA mode
[    2.924365] ahci 0000:08:00.0: flags: 64bit ncq sntf led only pmp fbs pio slum part sxs 
[    2.924445] ahci 0000:08:00.0: setting latency timer to 64
[    2.924465] ahci 0000:08:00.0: The port is not capable of FBS
[    2.924567] ahci 0000:08:00.0: The port is not capable of FBS
[    2.924916] scsi8 : ahci
[    2.925778] scsi9 : ahci
[    2.926489] ata9: SATA max UDMA/133 abar m2048@0xfbdff800 port 0xfbdff900 irq 56
[    2.926566] ata10: SATA max UDMA/133 abar m2048@0xfbdff800 port 0xfbdff980 irq 56
[    2.926714] ahci 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.937385] ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[    2.937469] ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
[    2.937533] ahci 0000:03:00.0: setting latency timer to 64
[    2.938017] scsi10 : ahci
[    2.938996] scsi11 : ahci
[    2.941134] ata11: SATA max UDMA/133 abar m8192@0xfbafe000 port 0xfbafe100 irq 18
[    2.941216] ata12: SATA max UDMA/133 abar m8192@0xfbafe000 port 0xfbafe180 irq 18
[    2.976183] hub 1-1:1.0: USB hub found
[    2.976392] hub 1-1:1.0: 6 ports detected
[    3.080003] usb 2-1: new high speed USB device using ehci_hcd and address 2
[    3.195557] hub 2-1:1.0: USB hub found
[    3.195742] hub 2-1:1.0: 8 ports detected
[    3.227987] ata3: SATA link down (SStatus 0 SControl 300)
[    3.230852] ata10: SATA link down (SStatus 0 SControl 370)
[    3.244903] ata11: SATA link down (SStatus 0 SControl 300)
[    3.245902] ata12: SATA link down (SStatus 0 SControl 300)
[    3.383588] ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 370)
[    3.383925] ata9.00: FORCE: horkage modified (noncq)
[    3.384039] ata9.00: ATA-7: INTEL SSDSA2M080G2GC, 2CV102HD, max UDMA/133
[    3.384111] ata9.00: 156301488 sectors, multi 1: LBA48 NCQ (not used)
[    3.384564] ata9.00: configured for UDMA/133
[    3.474508] usb 2-1.3: new full speed USB device using ehci_hcd and address 3
[    3.543230] ata4: SATA link down (SStatus 0 SControl 300)
[    3.583809] usbcore: registered new interface driver hiddev
[    3.586494] input: Logitech USB Gaming Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0/input/input2
[    3.587844] generic-usb 0003:046D:C049.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Gaming Mouse] on usb-0000:00:1d.0-1.3/input0
[    3.591770] generic-usb 0003:046D:C049.0002: hiddev96,hidraw1: USB HID v1.11 Device [Logitech USB Gaming Mouse] on usb-0000:00:1d.0-1.3/input1
[    3.591947] usbcore: registered new interface driver usbhid
[    3.592010] usbhid: USB HID core driver
[    3.638391] usb 2-1.5: new low speed USB device using ehci_hcd and address 4
[    3.741328] input: Logitech Logitech USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5/2-1.5:1.0/input/input3
[    3.742505] generic-usb 0003:046D:C30F.0003: input,hidraw2: USB HID v1.10 Keyboard [Logitech Logitech USB Keyboard] on usb-0000:00:1d.0-1.5/input0
[    3.752753] input: Logitech Logitech USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5/2-1.5:1.1/input/input4
[    3.753936] generic-usb 0003:046D:C30F.0004: input,hidraw3: USB HID v1.10 Device [Logitech Logitech USB Keyboard] on usb-0000:00:1d.0-1.5/input1
[    3.826979] usb 2-1.6: new high speed USB device using ehci_hcd and address 5
[    3.914438] hub 2-1.6:1.0: USB hub found
[    3.914750] hub 2-1.6:1.0: 3 ports detected
[    4.011479] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.011825] ata5.00: FORCE: horkage modified (noncq)
[    4.011900] ata5.00: ATAPI: ATAPI   iHAS120   6, 7L0E, max UDMA/100
[    4.012967] ata5.00: configured for UDMA/100
[    4.026085] scsi 4:0:0:0: CD-ROM            ATAPI    iHAS120   6      7L0E PQ: 0 ANSI: 5
[    4.032552] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    4.032630] Uniform CD-ROM driver Revision: 3.20
[    4.033989] sr 4:0:0:0: Attached scsi CD-ROM sr0
[    4.034632] sr 4:0:0:0: Attached scsi generic sg0 type 5
[    4.190429] usb 2-1.6.1: new high speed USB device using ehci_hcd and address 6
[    4.279003] hub 2-1.6.1:1.0: USB hub found
[    4.279307] hub 2-1.6.1:1.0: 3 ports detected
[    4.339948] ata6: SATA link down (SStatus 0 SControl 300)
[    4.554836] usb 2-1.6.1.1: new high speed USB device using ehci_hcd and address 7
[    4.655444] ata7: SATA link down (SStatus 0 SControl 300)
[    4.971144] ata8: SATA link down (SStatus 0 SControl 300)
[    4.982574] scsi 8:0:0:0: Direct-Access     ATA      INTEL SSDSA2M080 2CV1 PQ: 0 ANSI: 5
[    4.983822] sd 8:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
[    4.984247] sd 8:0:0:0: Attached scsi generic sg1 type 0
[    4.984522] sd 8:0:0:0: [sda] Write Protect is off
[    4.984584] sd 8:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.984923] sd 8:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.986509]  sda: sda1 sda2 sda3 < sda5 sda6 >
[    4.991388] sd 8:0:0:0: [sda] Attached SCSI disk
[    5.054755] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
[    5.290561] Adding 1986556k swap on /dev/sda6.  Priority:-1 extents:1 across:1986556k SSD
[    5.386863] udev: starting version 151
[    5.541974] ATK0110 ATK0110:00: EC enabled
[    5.550346] [drm] Initialized drm 1.1.0 20060810
[    5.849238] nouveau 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.849243] nouveau 0000:01:00.0: setting latency timer to 64
[    5.849948]   alloc irq_desc for 22 on node -1
[    5.849959]   alloc kstat_irqs on node -1
[    5.849979] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    5.850107]   alloc irq_desc for 57 on node -1
[    5.850116]   alloc kstat_irqs on node -1
[    5.850131] HDA Intel 0000:00:1b.0: irq 57 for MSI/MSI-X
[    5.850259] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    5.855784] [drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x0a0300b1)
[    5.861009] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from ACPI
[    5.861012] [drm] nouveau 0000:01:00.0: ... BIOS signature not found
[    5.861014] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
[    5.951522] [drm] nouveau 0000:01:00.0: ... appears to be valid
[    5.951526] [drm] nouveau 0000:01:00.0: BIT BIOS found
[    5.951528] [drm] nouveau 0000:01:00.0: Bios version 62.00.59.00
[    5.951531] [drm] nouveau 0000:01:00.0: TMDS table revision 2.0 not currently supported
[    5.951533] [drm] nouveau 0000:01:00.0: Found Display Configuration Block version 4.0
[    5.951536] [drm] nouveau 0000:01:00.0: Raw DCB entry 0: 04000320 00000028
[    5.951538] [drm] nouveau 0000:01:00.0: Raw DCB entry 1: 01000322 00020030
[    5.951541] [drm] nouveau 0000:01:00.0: Raw DCB entry 2: 02011310 00000028
[    5.951543] [drm] nouveau 0000:01:00.0: Raw DCB entry 3: 02011312 00020030
[    5.951545] [drm] nouveau 0000:01:00.0: Raw DCB entry 4: 010223f1 00c1c023
[    5.951548] [drm] nouveau 0000:01:00.0: DCB connector table: VHER 0x40 5 16 4
[    5.951551] [drm] nouveau 0000:01:00.0:   0: 0x00001030: type 0x30 idx 0 tag 0x07
[    5.951554] [drm] nouveau 0000:01:00.0:   1: 0x00002130: type 0x30 idx 1 tag 0x08
[    5.951556] [drm] nouveau 0000:01:00.0:   2: 0x00000210: type 0x10 idx 2 tag 0xff
[    5.951559] [drm] nouveau 0000:01:00.0:   3: 0x00000211: type 0x11 idx 3 tag 0xff
[    5.951561] [drm] nouveau 0000:01:00.0:   4: 0x00000213: type 0x13 idx 4 tag 0xff
[    5.951564] [drm] nouveau 0000:01:00.0:   5: 0x00000360: type 0x60 idx 5 tag 0xff
[    5.951571] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xD113
[    5.985103] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xD53E
[    5.989407] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xE9DB
[    5.989414] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xEAB8
[    5.991393] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xEB8A
[    5.991395] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xEBEF
[    6.012335] [drm] nouveau 0000:01:00.0: 0xEBEF: Condition still not met after 20ms, skipping following opcodes
[    6.012342] [drm] nouveau 0000:01:00.0: 0xC0A4: parsing output script 0
[    6.012345] [drm] nouveau 0000:01:00.0: 0xC0A4: parsing output script 0
[    6.012347] [drm] nouveau 0000:01:00.0: 0xA642: parsing output script 0
[    6.012356] [drm] nouveau 0000:01:00.0: Detected 896MiB VRAM
[    6.159703] [TTM] Zone  kernel: Available graphics memory: 4093646 kiB.
[    6.159705] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[    6.159707] [TTM] Initializing pool allocator.
[    6.228304] [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
[    6.228331] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[    6.229318] [drm] nouveau 0000:01:00.0: Allocating FIFO number 1
[    6.245907] [drm] nouveau 0000:01:00.0: nouveau_channel_alloc: initialised FIFO 1
[    6.249298] [drm] nouveau 0000:01:00.0: Detected a DAC output
[    6.249309] [drm] nouveau 0000:01:00.0: Detected a TMDS output
[    6.249318] [drm] nouveau 0000:01:00.0: Detected a DAC output
[    6.249327] [drm] nouveau 0000:01:00.0: Detected a TMDS output
[    6.249337] [drm] nouveau 0000:01:00.0: DCB encoder 1 unknown
[    6.249338] [drm] nouveau 0000:01:00.0: Detected a DVI-I connector
[    6.249917] [drm] nouveau 0000:01:00.0: Detected a DVI-I connector
[    6.250342] [drm] nouveau 0000:01:00.0: Detected a TV connector
[    6.250357] [drm] nouveau 0000:01:00.0:   no encoders, ignoring
[    6.250362] [drm] nouveau 0000:01:00.0: Detected a HDMI connector
[    6.250381] [drm] nouveau 0000:01:00.0:   no encoders, ignoring
[    6.436005] [drm] nouveau 0000:01:00.0: allocated 2560x1600 fb: 0x40250000, bo ffff8802326e3800
[    6.436642] fb0: nouveaufb frame buffer device
[    6.436644] drm: registered panic notifier
[    6.436647] Slow work thread pool: Starting up
[    6.436873] Slow work thread pool: Ready
[    6.436889] [drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on minor 0
[    6.482309] [drm] nouveau 0000:01:00.0: 0xC0A8: parsing output script 1
[    6.482318] [drm] nouveau 0000:01:00.0: 0xC0A9: parsing output script 2
[    6.482335] [drm] nouveau 0000:01:00.0: 0xC066: parsing clock script 0
[    6.482638] [drm] nouveau 0000:01:00.0: 0xB913: parsing clock script 1
[    6.487104] Console: switching to colour frame buffer device 320x100
[   25.191004] hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.

-- lspci --
00:00.0 Host bridge: Intel Corporation Core Processor DMI (rev 11)
	Subsystem: ASUSTeK Computer Inc. Device 8383
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [40] #00 [0000]

00:03.0 PCI bridge: Intel Corporation Core Processor PCI Express Root Port 1 (rev 11)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000b000-0000bfff
	Memory behind bridge: f8000000-fb9fffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: ASUSTeK Computer Inc. Device 8383
	Capabilities: [60] Message Signalled Interrupts: Mask+ 64bit- Queue=0/1 Enable+
		Address: fee00000  Data: 40a1
		Masking: 00000003  Pending: 00000000
	Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <512ns, L1 <4us
			ClockPM- Suprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot #  1, PowerLimit 75.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd Off, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [150] Access Controls <?>
	Capabilities: [160] Vendor Specific Information <?>
	Kernel driver in use: pcieport

00:08.0 System peripheral: Intel Corporation Core Processor System Management Registers (rev 11)
	Subsystem: Device 0043:0083
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM L0s, Latency L0 unlimited, L1 unlimited
			ClockPM- Suprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Vendor Specific Information <?>

00:08.1 System peripheral: Intel Corporation Core Processor Semaphore and Scratchpad Registers (rev 11)
	Subsystem: Device 0043:0083
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM L0s, Latency L0 unlimited, L1 unlimited
			ClockPM- Suprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Vendor Specific Information <?>

00:08.2 System peripheral: Intel Corporation Core Processor System Control and Status Registers (rev 11)
	Subsystem: Device 0043:0083
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM L0s, Latency L0 unlimited, L1 unlimited
			ClockPM- Suprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Vendor Specific Information <?>

00:08.3 System peripheral: Intel Corporation Core Processor Miscellaneous Registers (rev 11)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:10.0 System peripheral: Intel Corporation Core Processor QPI Link (rev 11)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:10.1 System peripheral: Intel Corporation Core Processor QPI Routing and Protocol Registers (rev 11)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:1a.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 05) (prog-if 20)
	Subsystem: ASUSTeK Computer Inc. Device 8383
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f7ffe000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCIe advanced features <?>
	Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset High Definition Audio (rev 05)
	Subsystem: ASUSTeK Computer Inc. Device 83d0
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 57
	Region 0: Memory at f7ff8000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee00000  Data: 408a
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [130] Root Complex Link <?>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 1 (rev 05)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=05, subordinate=0a, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fbb00000-fbdfffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <1us, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee00000  Data: 40a9
	Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 8383
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport

00:1c.5 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 6 (rev 05)
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #6, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee00000  Data: 40b1
	Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 8383
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport

00:1c.6 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 7 (rev 05)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: fba00000-fbafffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #7, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee00000  Data: 40b9
	Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 8383
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport

00:1c.7 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 8 (rev 05)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: c0000000-c01fffff
	Prefetchable memory behind bridge: 00000000c0200000-00000000c03fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #8, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
			Slot # 87, PowerLimit 25.000000; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee00000  Data: 40c1
	Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 8383
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport

00:1d.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 05) (prog-if 20)
	Subsystem: ASUSTeK Computer Inc. Device 8383
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at f7ffd000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCIe advanced features <?>
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev a5) (prog-if 01)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=0b, subordinate=0b, sec-latency=32
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fbe00000-fbefffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: ASUSTeK Computer Inc. Device 8383

00:1f.0 ISA bridge: Intel Corporation 5 Series Chipset LPC Interface Controller (rev 05)
	Subsystem: ASUSTeK Computer Inc. Device 8383
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information <?>

00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series Chipset 6 port SATA AHCI Controller (rev 05) (prog-if 01)
	Subsystem: ASUSTeK Computer Inc. Device 8383
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 55
	Region 0: I/O ports at a880 [size=8]
	Region 1: I/O ports at a800 [size=4]
	Region 2: I/O ports at a480 [size=8]
	Region 3: I/O ports at a400 [size=4]
	Region 4: I/O ports at a080 [size=32]
	Region 5: Memory at f7ff7000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee04000  Data: 406a
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a8] SATA HBA <?>
	Capabilities: [b0] PCIe advanced features <?>
	Kernel driver in use: ahci
	Kernel modules: ahci

00:1f.3 SMBus: Intel Corporation 5 Series/3400 Series Chipset SMBus Controller (rev 05)
	Subsystem: ASUSTeK Computer Inc. Device 8383
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 15
	Region 0: Memory at f7ffc000 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at ffe0 [size=32]

01:00.0 VGA compatible controller: nVidia Corporation GT200b [GeForce GTX 275] (rev a1)
	Subsystem: CardExpert Technology Device 0401
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 3: Memory at f8000000 (64-bit, non-prefetchable) [size=32M]
	Region 5: I/O ports at bc00 [size=128]
	Expansion ROM at fb980000 [disabled] [size=512K]
	Capabilities: [60] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <1us, L1 <4us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <1us, L1 <1us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [128] Power Budgeting <?>
	Capabilities: [600] Vendor Specific Information <?>
	Kernel driver in use: nouveau
	Kernel modules: nouveau, nvidiafb

03:00.0 SATA controller: JMicron Technology Corp. JMB362/JMB363 Serial ATA Controller (rev 03) (prog-if 01)
	Subsystem: ASUSTeK Computer Inc. Device 824f
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 18
	Region 5: Memory at fbafe000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: [68] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Express (v1) Legacy Endpoint, MSI 01
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 unlimited, L1 unlimited
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Kernel driver in use: ahci
	Kernel modules: ahci

03:00.1 IDE interface: JMicron Technology Corp. JMB362/JMB363 Serial ATA Controller (rev 03) (prog-if 85 [Master SecO PriO])
	Subsystem: ASUSTeK Computer Inc. Device 824f
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 0: I/O ports at cc00 [size=8]
	Region 1: I/O ports at c880 [size=4]
	Region 2: I/O ports at c800 [size=8]
	Region 3: I/O ports at c480 [size=4]
	Region 4: I/O ports at c400 [size=16]
	Capabilities: [68] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pata_jmicron
	Kernel modules: pata_jmicron

05:00.0 PCI bridge: PLX Technology, Inc. Device 8608 (rev ba)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Region 0: Memory at fbbe0000 (32-bit, non-prefetchable) [size=128K]
	Bus: primary=05, secondary=06, subordinate=0a, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fbc00000-fbdfffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [48] Message Signalled Interrupts: Mask+ 64bit+ Queue=0/2 Enable+
		Address: 00000000fee00000  Data: 40c9
		Masking: 00000001  Pending: 00000000
	Capabilities: [68] Express (v2) Upstream Port, MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-SlotPowerLimit 0.000000W
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x4, ASPM L0s L1, Latency L0 <2us, L1 <4us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [a4] Subsystem: PLX Technology, Inc. Device 8608
	Capabilities: [100] Device Serial Number 00-0e-df-b5-10-01-86-ba
	Capabilities: [fb4] Advanced Error Reporting <?>
	Capabilities: [138] Power Budgeting <?>
	Capabilities: [148] Virtual Channel <?>
	Capabilities: [448] Vendor Specific Information <?>
	Capabilities: [950] Vendor Specific Information <?>
	Kernel driver in use: pcieport

06:01.0 PCI bridge: PLX Technology, Inc. Device 8608 (rev ba)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=06, secondary=07, subordinate=07, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fbc00000-fbcfffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [48] Message Signalled Interrupts: Mask+ 64bit+ Queue=0/2 Enable+
		Address: 00000000fee00000  Data: 40d1
		Masking: 00000001  Pending: 00000000
	Capabilities: [68] Express (v2) Downstream Port (Slot+), MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <2us
			ClockPM- Suprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x1, TrErr- Train- SlotClk- DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot # 71, PowerLimit 25.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd Off, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
	Capabilities: [a4] Subsystem: PLX Technology, Inc. Device 8608
	Capabilities: [100] Device Serial Number 00-0e-df-b5-10-01-86-ba
	Capabilities: [fb4] Advanced Error Reporting <?>
	Capabilities: [148] Virtual Channel <?>
	Capabilities: [520] Access Controls <?>
	Capabilities: [950] Vendor Specific Information <?>
	Kernel driver in use: pcieport

06:05.0 PCI bridge: PLX Technology, Inc. Device 8608 (rev ba)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=06, secondary=08, subordinate=08, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fbd00000-fbdfffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [48] Message Signalled Interrupts: Mask+ 64bit+ Queue=0/2 Enable+
		Address: 00000000fee00000  Data: 40d9
		Masking: 00000001  Pending: 00000000
	Capabilities: [68] Express (v2) Downstream Port (Slot+), MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #5, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <2us
			ClockPM- Suprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x1, TrErr- Train- SlotClk- DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot # 75, PowerLimit 25.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd Off, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
	Capabilities: [a4] Subsystem: PLX Technology, Inc. Device 8608
	Capabilities: [100] Device Serial Number 00-0e-df-b5-10-01-86-ba
	Capabilities: [fb4] Advanced Error Reporting <?>
	Capabilities: [148] Virtual Channel <?>
	Capabilities: [520] Access Controls <?>
	Capabilities: [950] Vendor Specific Information <?>
	Kernel driver in use: pcieport

06:07.0 PCI bridge: PLX Technology, Inc. Device 8608 (rev ba)
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=06, secondary=09, subordinate=09, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [48] Message Signalled Interrupts: Mask+ 64bit+ Queue=0/2 Enable+
		Address: 00000000fee00000  Data: 40e1
		Masking: 00000001  Pending: 00000000
	Capabilities: [68] Express (v2) Downstream Port (Slot+), MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #7, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <2us, L1 <4us
			ClockPM- Suprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot # 77, PowerLimit 25.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd Off, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
	Capabilities: [a4] Subsystem: PLX Technology, Inc. Device 8608
	Capabilities: [100] Device Serial Number 00-0e-df-b5-10-01-86-ba
	Capabilities: [fb4] Advanced Error Reporting <?>
	Capabilities: [148] Virtual Channel <?>
	Capabilities: [520] Access Controls <?>
	Capabilities: [950] Vendor Specific Information <?>
	Kernel driver in use: pcieport

06:09.0 PCI bridge: PLX Technology, Inc. Device 8608 (rev ba)
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=06, secondary=0a, subordinate=0a, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [48] Message Signalled Interrupts: Mask+ 64bit+ Queue=0/2 Enable+
		Address: 00000000fee00000  Data: 40e9
		Masking: 00000001  Pending: 00000000
	Capabilities: [68] Express (v2) Downstream Port (Slot+), MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #9, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <2us, L1 <4us
			ClockPM- Suprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot # 79, PowerLimit 25.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd Off, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
	Capabilities: [a4] Subsystem: PLX Technology, Inc. Device 8608
	Capabilities: [100] Device Serial Number 00-0e-df-b5-10-01-86-ba
	Capabilities: [fb4] Advanced Error Reporting <?>
	Capabilities: [148] Virtual Channel <?>
	Capabilities: [520] Access Controls <?>
	Capabilities: [950] Vendor Specific Information <?>
	Kernel driver in use: pcieport

07:00.0 USB Controller: NEC Corporation Device 0194 (rev 03) (prog-if 30)
	Subsystem: ASUSTeK Computer Inc. Device 8413
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at fbcfe000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [70] Message Signalled Interrupts: Mask- 64bit+ Queue=0/3 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [90] MSI-X: Enable- Mask- TabSize=8
		Vector table: BAR=0 offset=00001000
		PBA: BAR=0 offset=00001080
	Capabilities: [a0] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 unlimited
			ClockPM+ Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [140] Device Serial Number ff-ff-ff-ff-ff-ff-ff-ff
	Capabilities: [150] #18

08:00.0 SATA controller: Device 1b4b:9123 (rev 10) (prog-if 01)
	Subsystem: ASUSTeK Computer Inc. Device 8400
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 56
	Region 0: I/O ports at dc00 [size=8]
	Region 1: I/O ports at d880 [size=4]
	Region 2: I/O ports at d800 [size=8]
	Region 3: I/O ports at d480 [size=4]
	Region 4: I/O ports at d400 [size=16]
	Region 5: Memory at fbdff800 (32-bit, non-prefetchable) [size=2K]
	Expansion ROM at fbde0000 [disabled] [size=64K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee03000  Data: 4092
	Capabilities: [70] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s <1us, L1 <8us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <64us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting <?>
	Kernel driver in use: ahci
	Kernel modules: ahci

0b:02.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169 Gigabit Ethernet (rev 10)
	Subsystem: Realtek Semiconductor Co., Ltd. RTL-8169 Gigabit Ethernet
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (8000ns min, 16000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: I/O ports at e800 [size=256]
	Region 1: Memory at fbeffc00 (32-bit, non-prefetchable) [size=256]
	Expansion ROM at fbec0000 [disabled] [size=128K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: r8169
	Kernel modules: r8169



--=-TYaiAgokQeFjzmqs6juD
Content-Type: application/x-gzip; name="config.gz"
Content-Disposition: attachment; filename="config.gz"
Content-Transfer-Encoding: base64

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


--=-TYaiAgokQeFjzmqs6juD--

