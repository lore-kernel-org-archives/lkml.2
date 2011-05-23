Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab1EWGe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 02:34:56 -0400
Received: from ns2.q-leap.de ([88.79.172.217]:35886 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934Ab1EWGex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 02:34:53 -0400
Message-ID: <4DD9FFFD.6020000@q-leap.de>
Date: Mon, 23 May 2011 08:34:37 +0200
From: Peter Kruse <pk@q-leap.de>
Organization: Q-Leap Networks GmbH
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: David Rientjes <rientjes@google.com>, eric.dumazet@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: I have a blaze of 353 page allocation failures, all alike
References: <4D53FE43.8030106@q-leap.com>    <alpine.DEB.2.00.1102141046170.26158@router.home>    <4D5A2EDB.8060603@q-leap.com>    <alpine.DEB.2.00.1102151040560.10511@router.home>    <4D5BC16A.2090205@q-leap.com>    <alpine.DEB.2.00.1102160956250.27814@router.home> <4D5BF56F.1000504@q-leap.com>    <alpine.DEB.2.00.1102161010330.27814@router.home>    <4D5CCEED.3010501@q-leap.com>    <alpine.DEB.2.00.1102171102520.11140@router.home> <272bf0cc51439a2ab31ee2f06317dd9f.squirrel@www.q-leap.de> <4D6648B5.1090306@q-leap.com> <4DA4692D.7080207@q-leap.de> <alpine.DEB.2.00.1104121306581.14692@router.home> <alpine.DEB.2.00.1104121830030.14956@chino.kir.corp.google.com> <4DA54D2A.3050206@q-leap.de> <alpine.DEB.2.00.1104131116330.19493@router.home> <4DD50584.4010408@q-leap.de> <alpine.DEB.2.00.1105191059400.9313@router.home>
In-Reply-To: <alpine.DEB.2.00.1105191059400.9313@router.home>
X-Enigmail-Version: 1.1.1
Content-Type: multipart/mixed;
 boundary="------------080606050008070102060403"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080606050008070102060403
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Christoph,

On 05/19/2011 06:00 PM, Christoph Lameter wrote:
> 
> We need the complete system log starting from bootup.
> 
> This looks like it has something to do with mutexes and pipes.

ah yes, I was told that there was a program running that sent
a large file to a pipe.
Attaching dmesg from the boot after the server was reset
and the kern.log from the boot before.

Best regards,

  Peter

--------------080606050008070102060403
Content-Type: text/plain;
 name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg"

[    0.000000] Linux version 2.6.32.29-ql-server-20 (root@ql-dev) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #1 SMP Wed Feb 23 14:20:09 CET 2011
[    0.000000] Command line: auto BOOT_IMAGE=linux ro root=100 root=/dev/mapper/vgroot-root elevator=cfq
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000097c00 (usable)
[    0.000000]  BIOS-e820: 0000000000097c00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf780000 (usable)
[    0.000000]  BIOS-e820: 00000000bf78e000 - 00000000bf790000 type 9
[    0.000000]  BIOS-e820: 00000000bf790000 - 00000000bf79e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf79e000 - 00000000bf7d0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf7d0000 - 00000000bf7e0000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf7ec000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000c40000000 (usable)
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xc40000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D7FFF write-protect
[    0.000000]   D8000-DFFFF uncachable
[    0.000000]   E0000-E3FFF write-protect
[    0.000000]   E4000-EBFFF write-through
[    0.000000]   EC000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask F800000000 write-back
[    0.000000]   1 base 0800000000 mask FC00000000 write-back
[    0.000000]   2 base 0C00000000 mask FFC0000000 write-back
[    0.000000]   3 base 00C0000000 mask FFC0000000 uncachable
[    0.000000]   4 base 00BF800000 mask FFFF800000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] e820 update range: 00000000bf800000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbf780 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bf780000
[    0.000000]  0000000000 - 00bf600000 page 2M
[    0.000000]  00bf600000 - 00bf780000 page 4k
[    0.000000] kernel direct mapping tables up to bf780000 @ 10000-15000
[    0.000000] init_memory_mapping: 0000000100000000-0000000c40000000
[    0.000000]  0100000000 - 0c40000000 page 2M
[    0.000000] kernel direct mapping tables up to c40000000 @ 13000-45000
[    0.000000] RAMDISK: 03c83000 - 040feff0
[    0.000000] ACPI: RSDP 00000000000f9c40 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000bf790100 0007C (v01 100709 XSDT1044 20091007 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bf790290 000F4 (v04 100709 FACP1044 20091007 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bf7904c0 0597A (v02  1F280 1F280000 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bf79e000 00040
[    0.000000] ACPI: APIC 00000000bf790390 000EA (v02 100709 APIC1044 20091007 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bf790480 0003C (v01 100709 OEMMCFG  20091007 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bf79e040 0007A (v01 100709 OEMB1044 20091007 MSFT 00000097)
[    0.000000] ACPI: SRAT 00000000bf79a4c0 00150 (v02 100709 OEMSRAT  00000001 INTL 00000001)
[    0.000000] ACPI: DMAR 00000000bf79e0c0 00128 (v01    AMI  OEMDMAR 00000001 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bf79f800 00363 (v01 DpgPmm    CpuPm 00000012 INTL 20051117)
[    0.000000] ACPI: EINJ 00000000bf79a610 00130 (v01  AMIER AMI_EINJ 20091007 MSFT 00000097)
[    0.000000] ACPI: BERT 00000000bf79a7a0 00030 (v01  AMIER AMI_BERT 20091007 MSFT 00000097)
[    0.000000] ACPI: ERST 00000000bf79a7d0 001B0 (v01  AMIER AMI_ERST 20091007 MSFT 00000097)
[    0.000000] ACPI: HEST 00000000bf79a980 000A8 (v01  AMIER ABC_HEST 20091007 MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 2 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 4 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 6 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 16 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 18 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 22 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 0-a0000
[    0.000000] SRAT: Node 0 PXM 0 100000-c0000000
[    0.000000] SRAT: Node 0 PXM 0 100000000-640000000
[    0.000000] SRAT: Node 1 PXM 1 640000000-c40000000
[    0.000000] NUMA: Allocated memnodemap from 40000 - 58840
[    0.000000] NUMA: Using 20 for the hash shift.
[    0.000000] Bootmem setup node 0 0000000000000000-0000000640000000
[    0.000000]   NODE_DATA [0000000000058840 - 000000000005d83f]
[    0.000000]   bootmap [0000000000100000 -  00000000001c7fff] pages c8
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 0640000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 0001899604]    TEXT DATA BSS ==> [0001000000 - 0001899604]
[    0.000000]   #3 [0003c83000 - 00040feff0]          RAMDISK ==> [0003c83000 - 00040feff0]
[    0.000000]   #4 [0000097c00 - 0000100000]    BIOS reserved ==> [0000097c00 - 0000100000]
[    0.000000]   #5 [000189a000 - 000189a1b8]              BRK ==> [000189a000 - 000189a1b8]
[    0.000000]   #6 [0000010000 - 0000013000]          PGTABLE ==> [0000010000 - 0000013000]
[    0.000000]   #7 [0000013000 - 0000040000]          PGTABLE ==> [0000013000 - 0000040000]
[    0.000000]   #8 [0000040000 - 0000058840]       MEMNODEMAP ==> [0000040000 - 0000058840]
[    0.000000] Bootmem setup node 1 0000000640000000-0000000c40000000
[    0.000000]   NODE_DATA [0000000640000000 - 0000000640004fff]
[    0.000000]   bootmap [0000000640005000 -  00000006400c4fff] pages c0
[    0.000000] (9 early reservations) ==> bootmem [0640000000 - 0c40000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE
[    0.000000]   #2 [0001000000 - 0001899604]    TEXT DATA BSS
[    0.000000]   #3 [0003c83000 - 00040feff0]          RAMDISK
[    0.000000]   #4 [0000097c00 - 0000100000]    BIOS reserved
[    0.000000]   #5 [000189a000 - 000189a1b8]              BRK
[    0.000000]   #6 [0000010000 - 0000013000]          PGTABLE
[    0.000000]   #7 [0000013000 - 0000040000]          PGTABLE
[    0.000000]   #8 [0000040000 - 0000058840]       MEMNODEMAP
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000]  [ffffea0000000000-ffffea0015dfffff] PMD -> [ffff880028600000-ffff88003d5fffff] on node 0
[    0.000000]  [ffffea0015e00000-ffffea002adfffff] PMD -> [ffff880640200000-ffff8806551fffff] on node 1
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00c40000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000097
[    0.000000]     0: 0x00000100 -> 0x000bf780
[    0.000000]     0: 0x00100000 -> 0x00640000
[    0.000000]     1: 0x00640000 -> 0x00c40000
[    0.000000] On node 0 totalpages: 6289159
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 179 pages reserved
[    0.000000]   DMA zone: 3740 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 765880 pages, LIFO batch:31
[    0.000000]   Normal zone: 75264 pages used for memmap
[    0.000000]   Normal zone: 5429760 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 6291456
[    0.000000]   Normal zone: 86016 pages used for memmap
[    0.000000]   Normal zone: 6205440 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x88] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x89] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x8a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x8b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x8c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x8d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x8e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x8f] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec80000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 3, version 32, address 0xfec80000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x05] address[0xfec80400] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 5, version 32, address 0xfec80400, GSI 48-71
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 16 CPUs, 8 hotplug CPUs
[    0.000000] nr_irqs_gsi: 72
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
[    0.000000] NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:16 nr_node_ids:2
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff880028200000 s73240 r8192 d20968 u262144
[    0.000000] pcpu-alloc: s73240 r8192 d20968 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 08 10 12 14 [1] 04 05 06 07 09 11 13 15 
[    0.000000] Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 12404820
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: auto BOOT_IMAGE=linux ro root=100 root=/dev/mapper/vgroot-root elevator=cfq
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.000000] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
[    0.000000] software IO TLB at phys 0x20000000 - 0x24000000
[    0.000000] Memory: 49552644k/51380224k available (3972k kernel code, 1057764k absent, 769816k reserved, 2393k data, 516k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 2000.312 MHz processor.
[    0.000007] Calibrating delay loop (skipped), value calculated using timer frequency.. 4000.62 BogoMIPS (lpj=8001248)
[    0.005108] Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes)
[    0.022008] Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.029345] Mount-cache hash table entries: 256
[    0.029571] CPU: Physical Processor ID: 0
[    0.029643] CPU: Processor Core ID: 0
[    0.029715] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.029836] CPU: L2 cache: 256K
[    0.029905] CPU: L3 cache: 4096K
[    0.029977] CPU 0/0x0 -> Node 0
[    0.030048] mce: CPU supports 9 MCE banks
[    0.030129] CPU0: Thermal monitoring enabled (TM1)
[    0.030204] CPU 0 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 SHD:8
[    0.030567] using mwait in idle threads.
[    0.030638] Performance Events: Nehalem/Corei7 events, Intel PMU driver.
[    0.030813] ... version:                3
[    0.030884] ... bit width:              48
[    0.030956] ... generic registers:      4
[    0.031027] ... value mask:             0000ffffffffffff
[    0.031102] ... max period:             000000007fffffff
[    0.031176] ... fixed-purpose events:   3
[    0.031248] ... event mask:             000000070000000f
[    0.031340] ACPI: Core revision 20090903
[    0.041731] Setting APIC routing to physical flat
[    0.042353] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.088786] CPU0: Intel(R) Xeon(R) CPU           E5504  @ 2.00GHz stepping 05
[    0.196236] Booting processor 1 APIC 0x2 ip 0x6000
[    0.206615] Initializing CPU#1
[    0.283940] CPU: Physical Processor ID: 0
[    0.283942] CPU: Processor Core ID: 1
[    0.283944] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.283946] CPU: L2 cache: 256K
[    0.283947] CPU: L3 cache: 4096K
[    0.283949] CPU 1/0x2 -> Node 0
[    0.283962] CPU1: Thermal monitoring enabled (TM1)
[    0.283965] CPU 1 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.283988] CPU1: Intel(R) Xeon(R) CPU           E5504  @ 2.00GHz stepping 05
[    0.284796] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.305062] Booting processor 2 APIC 0x4 ip 0x6000
[    0.315316] Initializing CPU#2
[    0.395727] CPU: Physical Processor ID: 0
[    0.395728] CPU: Processor Core ID: 2
[    0.395731] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.395733] CPU: L2 cache: 256K
[    0.395734] CPU: L3 cache: 4096K
[    0.395736] CPU 2/0x4 -> Node 0
[    0.395749] CPU2: Thermal monitoring enabled (TM1)
[    0.395752] CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.395784] CPU2: Intel(R) Xeon(R) CPU           E5504  @ 2.00GHz stepping 05
[    0.396592] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.416859] Booting processor 3 APIC 0x6 ip 0x6000
[    0.427114] Initializing CPU#3
[    0.507514] CPU: Physical Processor ID: 0
[    0.507515] CPU: Processor Core ID: 3
[    0.507518] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.507519] CPU: L2 cache: 256K
[    0.507521] CPU: L3 cache: 4096K
[    0.507523] CPU 3/0x6 -> Node 0
[    0.507536] CPU3: Thermal monitoring enabled (TM1)
[    0.507539] CPU 3 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.507581] CPU3: Intel(R) Xeon(R) CPU           E5504  @ 2.00GHz stepping 05
[    0.508390] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.528717] Booting processor 4 APIC 0x10 ip 0x6000
[    0.538971] Initializing CPU#4
[    0.619301] CPU: Physical Processor ID: 1
[    0.619302] CPU: Processor Core ID: 0
[    0.619304] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.619306] CPU: L2 cache: 256K
[    0.619307] CPU: L3 cache: 4096K
[    0.619310] CPU 4/0x10 -> Node 1
[    0.619322] CPU4: Thermal monitoring enabled (TM1)
[    0.619326] CPU 4 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 SHD:8
[    0.619339] CPU4: Intel(R) Xeon(R) CPU           E5504  @ 2.00GHz stepping 05
[    0.620147] checking TSC synchronization [CPU#0 -> CPU#4]: passed.
[    0.640437] Booting processor 5 APIC 0x12 ip 0x6000
[    0.650693] Initializing CPU#5
[    0.731089] CPU: Physical Processor ID: 1
[    0.731091] CPU: Processor Core ID: 1
[    0.731093] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.731095] CPU: L2 cache: 256K
[    0.731097] CPU: L3 cache: 4096K
[    0.731099] CPU 5/0x12 -> Node 1
[    0.731114] CPU5: Thermal monitoring enabled (TM1)
[    0.731117] CPU 5 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.731211] CPU5: Intel(R) Xeon(R) CPU           E5504  @ 2.00GHz stepping 05
[    0.732020] checking TSC synchronization [CPU#0 -> CPU#5]: passed.
[    0.752332] Booting processor 6 APIC 0x14 ip 0x6000
[    0.762589] Initializing CPU#6
[    0.842876] CPU: Physical Processor ID: 1
[    0.842877] CPU: Processor Core ID: 2
[    0.842880] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.842882] CPU: L2 cache: 256K
[    0.842883] CPU: L3 cache: 4096K
[    0.842886] CPU 6/0x14 -> Node 1
[    0.842900] CPU6: Thermal monitoring enabled (TM1)
[    0.842904] CPU 6 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.842954] CPU6: Intel(R) Xeon(R) CPU           E5504  @ 2.00GHz stepping 05
[    0.843762] checking TSC synchronization [CPU#0 -> CPU#6]: passed.
[    0.864070] Booting processor 7 APIC 0x16 ip 0x6000
[    0.874326] Initializing CPU#7
[    0.954663] CPU: Physical Processor ID: 1
[    0.954664] CPU: Processor Core ID: 3
[    0.954667] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.954669] CPU: L2 cache: 256K
[    0.954670] CPU: L3 cache: 4096K
[    0.954673] CPU 7/0x16 -> Node 1
[    0.954688] CPU7: Thermal monitoring enabled (TM1)
[    0.954691] CPU 7 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.954721] CPU7: Intel(R) Xeon(R) CPU           E5504  @ 2.00GHz stepping 05
[    0.955529] checking TSC synchronization [CPU#0 -> CPU#7]: passed.
[    0.975706] Brought up 8 CPUs
[    0.975777] Total of 8 processors activated (32002.46 BogoMIPS).
[    0.978606] xor: automatically using best checksumming function: generic_sse
[    0.998582]    generic_sse:  7445.000 MB/sec
[    0.998655] xor: using function: generic_sse (7445.000 MB/sec)
[    0.998805] NET: Registered protocol family 16
[    0.998970] ACPI: bus type pci registered
[    0.999085] PCI: Using configuration type 1 for base access
[    1.000173] bio: create slab <bio-0> at 0
[    1.001130] ACPI: EC: Look up EC in DSDT
[    1.003890] ACPI Warning for \_SB_._OSC: Return type mismatch - found Integer, expected Buffer (20090903/nspredef-1006)
[    1.004092] \_SB_:_OSC evaluation returned wrong type
[    1.004094] _OSC request data:1 6 
[    1.004603] ACPI: Executed 1 blocks of module-level executable AML code
[    1.012316] ACPI: Interpreter enabled
[    1.012389] ACPI: (supports S0 S1 S5)
[    1.012619] ACPI: Using IOAPIC for interrupt routing
[    1.023502] ACPI Warning: Incorrect checksum in table [OEMB] - 0A, should be FF (20090903/tbutils-314)
[    1.024009] ACPI: No dock devices found.
[    1.024258] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    1.024417] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    1.024496] pci 0000:00:00.0: PME# disabled
[    1.024630] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.024708] pci 0000:00:01.0: PME# disabled
[    1.024844] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    1.024922] pci 0000:00:03.0: PME# disabled
[    1.025058] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    1.025136] pci 0000:00:05.0: PME# disabled
[    1.025272] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    1.025350] pci 0000:00:07.0: PME# disabled
[    1.025485] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    1.025563] pci 0000:00:09.0: PME# disabled
[    1.025999] pci 0000:00:16.0: reg 10 64bit mmio: [0xfb8d8000-0xfb8dbfff]
[    1.026063] pci 0000:00:16.1: reg 10 64bit mmio: [0xfb8dc000-0xfb8dffff]
[    1.026126] pci 0000:00:16.2: reg 10 64bit mmio: [0xfb8e0000-0xfb8e3fff]
[    1.026190] pci 0000:00:16.3: reg 10 64bit mmio: [0xfb8e4000-0xfb8e7fff]
[    1.026253] pci 0000:00:16.4: reg 10 64bit mmio: [0xfb8e8000-0xfb8ebfff]
[    1.026316] pci 0000:00:16.5: reg 10 64bit mmio: [0xfb8ec000-0xfb8effff]
[    1.026380] pci 0000:00:16.6: reg 10 64bit mmio: [0xfb8f0000-0xfb8f3fff]
[    1.026443] pci 0000:00:16.7: reg 10 64bit mmio: [0xfb8f4000-0xfb8f7fff]
[    1.026528] pci 0000:00:1a.0: reg 20 io port: [0x9400-0x941f]
[    1.026601] pci 0000:00:1a.1: reg 20 io port: [0x9480-0x949f]
[    1.026669] pci 0000:00:1a.2: reg 20 io port: [0x9800-0x981f]
[    1.026743] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfb8fa000-0xfb8fa3ff]
[    1.026797] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    1.026876] pci 0000:00:1a.7: PME# disabled
[    1.027008] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.027086] pci 0000:00:1c.0: PME# disabled
[    1.027222] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    1.027300] pci 0000:00:1c.4: PME# disabled
[    1.027424] pci 0000:00:1d.0: reg 20 io port: [0x9880-0x989f]
[    1.027493] pci 0000:00:1d.1: reg 20 io port: [0x9c00-0x9c1f]
[    1.027562] pci 0000:00:1d.2: reg 20 io port: [0xa000-0xa01f]
[    1.027634] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfb8fc000-0xfb8fc3ff]
[    1.027688] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.027766] pci 0000:00:1d.7: PME# disabled
[    1.027965] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    1.027969] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    1.028066] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    1.028146] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0a00 (mask 00ff)
[    1.028244] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0290 (mask 001f)
[    1.028341] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0ca0 (mask 000f)
[    1.028486] pci 0000:00:1f.2: reg 10 io port: [0xbc00-0xbc07]
[    1.028491] pci 0000:00:1f.2: reg 14 io port: [0xb880-0xb883]
[    1.028497] pci 0000:00:1f.2: reg 18 io port: [0xb800-0xb807]
[    1.028502] pci 0000:00:1f.2: reg 1c io port: [0xb480-0xb483]
[    1.028508] pci 0000:00:1f.2: reg 20 io port: [0xb400-0xb40f]
[    1.028513] pci 0000:00:1f.2: reg 24 io port: [0xb080-0xb08f]
[    1.028559] pci 0000:00:1f.3: reg 10 64bit mmio: [0xfb8fe000-0xfb8fe0ff]
[    1.028572] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
[    1.028616] pci 0000:00:1f.5: reg 10 io port: [0xac00-0xac07]
[    1.028622] pci 0000:00:1f.5: reg 14 io port: [0xa880-0xa883]
[    1.028627] pci 0000:00:1f.5: reg 18 io port: [0xa800-0xa807]
[    1.028632] pci 0000:00:1f.5: reg 1c io port: [0xa480-0xa483]
[    1.028638] pci 0000:00:1f.5: reg 20 io port: [0xa400-0xa40f]
[    1.028643] pci 0000:00:1f.5: reg 24 io port: [0xa080-0xa08f]
[    1.028711] pci 0000:0a:00.0: reg 10 32bit mmio: [0xfbe60000-0xfbe7ffff]
[    1.028717] pci 0000:0a:00.0: reg 14 32bit mmio: [0xfbe40000-0xfbe5ffff]
[    1.028724] pci 0000:0a:00.0: reg 18 io port: [0xe880-0xe89f]
[    1.028730] pci 0000:0a:00.0: reg 1c 32bit mmio: [0xfbe1c000-0xfbe1ffff]
[    1.028745] pci 0000:0a:00.0: reg 30 32bit mmio pref: [0xfbe20000-0xfbe3ffff]
[    1.028774] pci 0000:0a:00.0: PME# supported from D0 D3hot D3cold
[    1.028853] pci 0000:0a:00.0: PME# disabled
[    1.028968] pci 0000:0a:00.1: reg 10 32bit mmio: [0xfbee0000-0xfbefffff]
[    1.028975] pci 0000:0a:00.1: reg 14 32bit mmio: [0xfbec0000-0xfbedffff]
[    1.028981] pci 0000:0a:00.1: reg 18 io port: [0xec00-0xec1f]
[    1.028988] pci 0000:0a:00.1: reg 1c 32bit mmio: [0xfbe9c000-0xfbe9ffff]
[    1.029002] pci 0000:0a:00.1: reg 30 32bit mmio pref: [0xfbea0000-0xfbebffff]
[    1.029032] pci 0000:0a:00.1: PME# supported from D0 D3hot D3cold
[    1.029110] pci 0000:0a:00.1: PME# disabled
[    1.029217] pci 0000:00:01.0: bridge io port: [0xe000-0xefff]
[    1.029220] pci 0000:00:01.0: bridge 32bit mmio: [0xfbe00000-0xfbefffff]
[    1.029259] pci 0000:09:00.0: reg 10 64bit mmio: [0xfbc00000-0xfbdfffff]
[    1.029281] pci 0000:09:00.0: reg 30 32bit mmio pref: [0xfbb80000-0xfbbfffff]
[    1.029305] pci 0000:09:00.0: supports D1
[    1.029335] pci 0000:00:03.0: bridge 32bit mmio: [0xfbb00000-0xfbdfffff]
[    1.029423] pci 0000:04:00.0: PXH quirk detected; SHPC device MSI disabled
[    1.029532] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    1.029610] pci 0000:04:00.0: PME# disabled
[    1.029715] pci 0000:04:00.2: PXH quirk detected; SHPC device MSI disabled
[    1.029823] pci 0000:04:00.2: PME# supported from D0 D3hot D3cold
[    1.029901] pci 0000:04:00.2: PME# disabled
[    1.030190] pci 0000:02:00.0: reg 10 io port: [0xd400-0xd407]
[    1.030199] pci 0000:02:00.0: reg 14 io port: [0xdc00-0xdc03]
[    1.030208] pci 0000:02:00.0: reg 18 io port: [0xd880-0xd887]
[    1.030217] pci 0000:02:00.0: reg 1c io port: [0xd800-0xd803]
[    1.030225] pci 0000:02:00.0: reg 20 io port: [0xd480-0xd48f]
[    1.030241] pci 0000:02:00.0: reg 30 32bit mmio pref: [0xfbaf0000-0xfbafffff]
[    1.030322] pci 0000:00:1c.4: bridge io port: [0xd000-0xdfff]
[    1.030326] pci 0000:00:1c.4: bridge 32bit mmio: [0xfba00000-0xfbafffff]
[    1.030366] pci 0000:01:01.0: reg 10 32bit mmio pref: [0xf0000000-0xf7ffffff]
[    1.030373] pci 0000:01:01.0: reg 14 io port: [0xc000-0xc0ff]
[    1.030380] pci 0000:01:01.0: reg 18 32bit mmio: [0xfb9d0000-0xfb9dffff]
[    1.030402] pci 0000:01:01.0: reg 30 32bit mmio pref: [0xfb9e0000-0xfb9fffff]
[    1.030421] pci 0000:01:01.0: supports D1 D2
[    1.030464] pci 0000:00:1e.0: transparent bridge
[    1.030542] pci 0000:00:1e.0: bridge io port: [0xc000-0xcfff]
[    1.030546] pci 0000:00:1e.0: bridge 32bit mmio: [0xfb900000-0xfb9fffff]
[    1.030552] pci 0000:00:1e.0: bridge 64bit mmio pref: [0xf0000000-0xf7ffffff]
[    1.030585] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.030880] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    1.030998] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1._PRT]
[    1.031064] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE3._PRT]
[    1.031131] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE5._PRT]
[    1.031196] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE7._PRT]
[    1.031261] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE9._PRT]
[    1.031330] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE9.PXHA._PRT]
[    1.031421] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE9.PXHB._PRT]
[    1.031487] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    1.031564] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
[    1.073169] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    1.073933] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    1.074699] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    1.075459] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    1.076220] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    1.077093] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 *14 15)
[    1.077853] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    1.078729] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    1.079477] vgaarb: device added: PCI:0000:01:01.0,decodes=io+mem,owns=io+mem,locks=none
[    1.079574] vgaarb: loaded
[    1.079791] SCSI subsystem initialized
[    1.080018] libata version 3.00 loaded.
[    1.146316] raid6: int64x1   2163 MB/s
[    1.214186] raid6: int64x2   2503 MB/s
[    1.282068] raid6: int64x4   1786 MB/s
[    1.349931] raid6: int64x8   1579 MB/s
[    1.417806] raid6: sse2x1    4875 MB/s
[    1.485666] raid6: sse2x2    5617 MB/s
[    1.553538] raid6: sse2x4    6703 MB/s
[    1.553609] raid6: using algorithm sse2x4 (6703 MB/s)
[    1.553689] PCI: Using ACPI for IRQ routing
[    1.554096] hpet clockevent registered
[    1.554100] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    1.566661] Switching to clocksource tsc
[    1.567068] pnp: PnP ACPI init
[    1.567159] ACPI: bus type pnp registered
[    1.572285] pnp: PnP ACPI: found 16 devices
[    1.572359] ACPI: ACPI bus type pnp unregistered
[    1.572442] system 00:01: iomem range 0xfbf00000-0xfbffffff has been reserved
[    1.572521] system 00:01: iomem range 0xfc000000-0xfcffffff has been reserved
[    1.572601] system 00:01: iomem range 0xfd000000-0xfdffffff has been reserved
[    1.572681] system 00:01: iomem range 0xfe000000-0xfebfffff has been reserved
[    1.572760] system 00:01: iomem range 0xfec8a000-0xfec8afff has been reserved
[    1.572840] system 00:01: iomem range 0xfed10000-0xfed10fff has been reserved
[    1.572925] system 00:09: ioport range 0x4d0-0x4d1 has been reserved
[    1.579739] system 00:09: ioport range 0x800-0x87f has been reserved
[    1.579818] system 00:09: ioport range 0x500-0x57f could not be reserved
[    1.579897] system 00:09: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    1.579977] system 00:09: iomem range 0xfed20000-0xfed3ffff has been reserved
[    1.580056] system 00:09: iomem range 0xfed40000-0xfed8ffff has been reserved
[    1.580139] system 00:0a: iomem range 0xfec00000-0xfec00fff could not be reserved
[    1.580235] system 00:0a: iomem range 0xfee00000-0xfee00fff has been reserved
[    1.580318] system 00:0d: ioport range 0xa00-0xa0f has been reserved
[    1.580399] system 00:0e: iomem range 0xe0000000-0xefffffff has been reserved
[    1.580481] system 00:0f: iomem range 0x0-0x9ffff could not be reserved
[    1.580560] system 00:0f: iomem range 0xc0000-0xcffff has been reserved
[    1.580638] system 00:0f: iomem range 0xe0000-0xfffff could not be reserved
[    1.580718] system 00:0f: iomem range 0x100000-0xbf8fffff could not be reserved
[    1.580813] system 00:0f: iomem range 0xfed90000-0xffffffff could not be reserved
[    1.585552] pci 0000:01:01.0: BAR 6: address space collision on of device [0xfb9e0000-0xfb9fffff]
[    1.585719] pci 0000:00:01.0: PCI bridge, secondary bus 0000:0a
[    1.585795] pci 0000:00:01.0:   IO window: 0xe000-0xefff
[    1.585872] pci 0000:00:01.0:   MEM window: 0xfbe00000-0xfbefffff
[    1.585950] pci 0000:00:01.0:   PREFETCH window: disabled
[    1.586028] pci 0000:00:03.0: PCI bridge, secondary bus 0000:09
[    1.586104] pci 0000:00:03.0:   IO window: disabled
[    1.586180] pci 0000:00:03.0:   MEM window: 0xfbb00000-0xfbdfffff
[    1.586258] pci 0000:00:03.0:   PREFETCH window: disabled
[    1.586336] pci 0000:00:05.0: PCI bridge, secondary bus 0000:08
[    1.586411] pci 0000:00:05.0:   IO window: disabled
[    1.586487] pci 0000:00:05.0:   MEM window: disabled
[    1.586562] pci 0000:00:05.0:   PREFETCH window: disabled
[    1.586642] pci 0000:00:07.0: PCI bridge, secondary bus 0000:07
[    1.586718] pci 0000:00:07.0:   IO window: disabled
[    1.586794] pci 0000:00:07.0:   MEM window: disabled
[    1.586869] pci 0000:00:07.0:   PREFETCH window: disabled
[    1.586947] pci 0000:04:00.0: PCI bridge, secondary bus 0000:06
[    1.587023] pci 0000:04:00.0:   IO window: disabled
[    1.587099] pci 0000:04:00.0:   MEM window: disabled
[    1.587174] pci 0000:04:00.0:   PREFETCH window: disabled
[    1.587252] pci 0000:04:00.2: PCI bridge, secondary bus 0000:05
[    1.587328] pci 0000:04:00.2:   IO window: disabled
[    1.587403] pci 0000:04:00.2:   MEM window: disabled
[    1.587479] pci 0000:04:00.2:   PREFETCH window: disabled
[    1.587557] pci 0000:00:09.0: PCI bridge, secondary bus 0000:04
[    1.587632] pci 0000:00:09.0:   IO window: disabled
[    1.587708] pci 0000:00:09.0:   MEM window: disabled
[    1.587783] pci 0000:00:09.0:   PREFETCH window: disabled
[    1.587861] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:03
[    1.587938] pci 0000:00:1c.0:   IO window: 0x1000-0x1fff
[    1.588016] pci 0000:00:1c.0:   MEM window: 0xc0000000-0xc01fffff
[    1.588094] pci 0000:00:1c.0:   PREFETCH window: 0x000000c0200000-0x000000c03fffff
[    1.588193] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:02
[    1.588270] pci 0000:00:1c.4:   IO window: 0xd000-0xdfff
[    1.588348] pci 0000:00:1c.4:   MEM window: 0xfba00000-0xfbafffff
[    1.588426] pci 0000:00:1c.4:   PREFETCH window: 0x000000c0400000-0x000000c05fffff
[    1.588526] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:01
[    1.588604] pci 0000:00:1e.0:   IO window: 0xc000-0xcfff
[    1.588681] pci 0000:00:1e.0:   MEM window: 0xfb900000-0xfb9fffff
[    1.588759] pci 0000:00:1e.0:   PREFETCH window: 0x000000f0000000-0x000000f7ffffff
[    1.588867] pci 0000:00:01.0: setting latency timer to 64
[    1.588874] pci 0000:00:03.0: setting latency timer to 64
[    1.588882] pci 0000:00:05.0: setting latency timer to 64
[    1.588890] pci 0000:00:07.0: setting latency timer to 64
[    1.588897] pci 0000:00:09.0: setting latency timer to 64
[    1.588905] pci 0000:04:00.0: setting latency timer to 64
[    1.588912] pci 0000:04:00.2: setting latency timer to 64
[    1.588919] pci 0000:00:1c.0: enabling device (0104 -> 0107)
[    1.589004] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.589084] pci 0000:00:1c.0: setting latency timer to 64
[    1.589091] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.589171] pci 0000:00:1c.4: setting latency timer to 64
[    1.589177] pci 0000:00:1e.0: setting latency timer to 64
[    1.589181] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    1.589184] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    1.589186] pci_bus 0000:0a: resource 0 io:  [0xe000-0xefff]
[    1.589188] pci_bus 0000:0a: resource 1 mem: [0xfbe00000-0xfbefffff]
[    1.589191] pci_bus 0000:09: resource 1 mem: [0xfbb00000-0xfbdfffff]
[    1.589194] pci_bus 0000:03: resource 0 io:  [0x1000-0x1fff]
[    1.589196] pci_bus 0000:03: resource 1 mem: [0xc0000000-0xc01fffff]
[    1.589199] pci_bus 0000:03: resource 2 pref mem [0xc0200000-0xc03fffff]
[    1.589201] pci_bus 0000:02: resource 0 io:  [0xd000-0xdfff]
[    1.589203] pci_bus 0000:02: resource 1 mem: [0xfba00000-0xfbafffff]
[    1.589205] pci_bus 0000:02: resource 2 pref mem [0xc0400000-0xc05fffff]
[    1.589208] pci_bus 0000:01: resource 0 io:  [0xc000-0xcfff]
[    1.589210] pci_bus 0000:01: resource 1 mem: [0xfb900000-0xfb9fffff]
[    1.589212] pci_bus 0000:01: resource 2 pref mem [0xf0000000-0xf7ffffff]
[    1.589214] pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
[    1.589216] pci_bus 0000:01: resource 4 mem: [0x000000-0xffffffffffffffff]
[    1.589280] NET: Registered protocol family 2
[    1.589751] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    1.591358] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.593348] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.593647] TCP: Hash tables configured (established 524288 bind 65536)
[    1.593725] TCP reno registered
[    1.594006] NET: Registered protocol family 1
[    1.594323] RPC: Registered udp transport module.
[    1.594396] RPC: Registered tcp transport module.
[    1.594470] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.594757] pci 0000:01:01.0: Boot video device
[    1.594816] Trying to unpack rootfs image as initramfs...
[    1.715417] Freeing initrd memory: 4591k freed
[    1.719582] VFS: Disk quotas dquot_6.5.2
[    1.719678] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.720206] msgmni has been set to 32768
[    1.720590] alg: No test for stdrng (krng)
[    1.720694] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    1.720790] io scheduler noop registered
[    1.720862] io scheduler anticipatory registered
[    1.720935] io scheduler deadline registered
[    1.721029] io scheduler cfq registered (default)
[    1.721295] pcieport 0000:00:01.0: irq 72 for MSI/MSI-X
[    1.721303] pcieport 0000:00:01.0: setting latency timer to 64
[    1.721405] pcieport 0000:00:03.0: irq 73 for MSI/MSI-X
[    1.721411] pcieport 0000:00:03.0: setting latency timer to 64
[    1.721511] pcieport 0000:00:05.0: irq 74 for MSI/MSI-X
[    1.721518] pcieport 0000:00:05.0: setting latency timer to 64
[    1.721617] pcieport 0000:00:07.0: irq 75 for MSI/MSI-X
[    1.721624] pcieport 0000:00:07.0: setting latency timer to 64
[    1.721722] pcieport 0000:00:09.0: irq 76 for MSI/MSI-X
[    1.721729] pcieport 0000:00:09.0: setting latency timer to 64
[    1.721827] pcieport 0000:00:1c.0: irq 77 for MSI/MSI-X
[    1.721835] pcieport 0000:00:1c.0: setting latency timer to 64
[    1.721944] pcieport 0000:00:1c.4: irq 78 for MSI/MSI-X
[    1.721952] pcieport 0000:00:1c.4: setting latency timer to 64
[    1.738711] Real Time Clock Driver v1.12b
[    1.738889] Linux agpgart interface v0.103
[    1.738962] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.739132] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.739328] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.739771] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.740047] 00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.740378] Floppy drive(s): fd0 is 1.44M
[    1.758132] FDC 0 is a post-1991 82077
[    1.760145] brd: module loaded
[    1.760670] loop: module loaded
[    1.760740] HP CISS Driver (v 3.6.20)
[    1.760984] Adaptec aacraid driver 1.1-5[2461]-ms
[    1.761091] aacraid 0000:09:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.761172] aacraid 0000:09:00.0: setting latency timer to 64
[    1.826573] IRQ 16/aacraid: IRQF_DISABLED is not guaranteed on shared IRQs
[    2.033946] AAC0: kernel 5.2-0[17899] Apr 14 2010
[    2.034025] AAC0: monitor 5.2-0[17899]
[    2.034096] AAC0: bios 5.2-0[17899]
[    2.034168] AAC0: serial 9D511144775
[    2.034238] AAC0: Non-DASD support enabled.
[    2.034310] AAC0: 64bit support enabled.
[    2.034382] AAC0: 64 Bit DAC enabled
[    2.047360] scsi0 : aacraid
[    2.047643] scsi 0:0:0:0: Direct-Access     Adaptec  Vol1             V1.0 PQ: 0 ANSI: 2
[    2.048018] scsi 0:0:1:0: Direct-Access     Adaptec  Raid6            V1.0 PQ: 0 ANSI: 2
[    2.059436] scsi 0:1:8:0: Direct-Access              ST3250310NS      SN06 PQ: 1 ANSI: 5
[    2.059816] scsi 0:1:9:0: Direct-Access              ST3250310NS      SN06 PQ: 1 ANSI: 5
[    2.060179] scsi 0:1:10:0: Direct-Access     Hitachi  HUA722020ALA330  JKAO PQ: 1 ANSI: 5
[    2.060547] scsi 0:1:11:0: Direct-Access     Hitachi  HUA722020ALA330  JKAO PQ: 1 ANSI: 5
[    2.060920] scsi 0:1:12:0: Direct-Access     Hitachi  HUA722020ALA330  JKAO PQ: 1 ANSI: 5
[    2.061285] scsi 0:1:13:0: Direct-Access     Hitachi  HUA722020ALA330  JKAO PQ: 1 ANSI: 5
[    2.061646] scsi 0:1:14:0: Direct-Access     Hitachi  HUA722020ALA330  JKAO PQ: 1 ANSI: 5
[    2.062017] scsi 0:1:15:0: Direct-Access     Hitachi  HUA722020ALA330  JKAO PQ: 1 ANSI: 5
[    2.062383] scsi 0:1:16:0: Direct-Access     Hitachi  HUA722020ALA330  JKAO PQ: 1 ANSI: 5
[    2.062745] scsi 0:1:17:0: Direct-Access     Hitachi  HUA722020ALA330  JKAO PQ: 1 ANSI: 5
[    2.063116] scsi 0:1:18:0: Direct-Access     Hitachi  HUA722020ALA330  JKAO PQ: 1 ANSI: 5
[    2.063481] scsi 0:1:19:0: Direct-Access     Hitachi  HUA722020ALA330  JKAO PQ: 1 ANSI: 5
[    2.063847] scsi 0:1:20:0: Direct-Access     Hitachi  HUA722020ALA330  JKAO PQ: 1 ANSI: 5
[    2.064218] scsi 0:1:21:0: Direct-Access     Hitachi  HUA722020ALA330  JKAO PQ: 1 ANSI: 5
[    2.064591] scsi 0:1:22:0: Direct-Access     Hitachi  HUA722020ALA330  JKAO PQ: 1 ANSI: 5
[    2.064959] scsi 0:1:23:0: Direct-Access     Hitachi  HUA722020ALA330  JKAO PQ: 1 ANSI: 5
[    2.065329] scsi 0:1:24:0: Direct-Access     Hitachi  HUA722020ALA330  JKAO PQ: 1 ANSI: 5
[    2.065702] scsi 0:1:25:0: Direct-Access     Hitachi  HUA722020ALA330  JKAO PQ: 1 ANSI: 5
[    2.066071] scsi 0:1:26:0: Direct-Access     Hitachi  HUA722020ALA330  JKAO PQ: 1 ANSI: 5
[    2.066437] scsi 0:1:27:0: Direct-Access     Hitachi  HUA722020ALA330  JKAO PQ: 1 ANSI: 5
[    2.066807] scsi 0:1:28:0: Direct-Access     Hitachi  HUA722020ALA330  JKAO PQ: 1 ANSI: 5
[    2.067183] scsi 0:1:29:0: Direct-Access     Hitachi  HUA722020ALA330  JKAO PQ: 1 ANSI: 5
[    2.067556] scsi 0:1:30:0: Direct-Access     Hitachi  HUA722020ALA330  JKAO PQ: 1 ANSI: 5
[    2.067933] scsi 0:1:31:0: Direct-Access     Hitachi  HUA722020ALA330  JKAO PQ: 1 ANSI: 5
[    2.098990] scsi 0:3:0:0: Enclosure         LSILOGIC SASX36 A.1       7015 PQ: 0 ANSI: 3
[    2.115181] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    2.115312] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    2.115404] megasas: 00.00.04.01 Thu July 24 11:41:51 PST 2008
[    2.115499] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    2.115589] 3ware Storage Controller device driver for Linux v1.26.02.002.
[    2.115678] 3ware 9000 Storage Controller device driver for Linux v2.26.02.012.
[    2.115788] st: Version 20081215, fixed bufsize 32768, s/g segs 256
[    2.116054] sd 0:0:1:0: [sdb] Very big device. Trying to use READ CAPACITY(16).
[    2.116058] sd 0:0:0:0: [sda] 488017920 512-byte logical blocks: (249 GB/232 GiB)
[    2.116075] ata_piix 0000:00:1f.2: version 2.13
[    2.116078] sd 0:0:0:0: [sda] Write Protect is off
[    2.116080] sd 0:0:0:0: [sda] Mode Sense: 06 00 10 00
[    2.116092] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.116096] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    2.116108] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
[    2.116137] ata_piix 0000:00:1f.2: setting latency timer to 64
[    2.116194] scsi1 : ata_piix
[    2.116252] scsi2 : ata_piix
[    2.118008] ata1: SATA max UDMA/133 cmd 0xbc00 ctl 0xb880 bmdma 0xb400 irq 19
[    2.118016] ata2: SATA max UDMA/133 cmd 0xb800 ctl 0xb480 bmdma 0xb408 irq 19
[    2.118040] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.118045] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    2.118091] ata_piix 0000:00:1f.5: setting latency timer to 64
[    2.118130] scsi3 : ata_piix
[    2.118187] scsi4 : ata_piix
[    2.119846] ata3: SATA max UDMA/133 cmd 0xac00 ctl 0xa880 bmdma 0xa400 irq 19
[    2.119851] ata4: SATA max UDMA/133 cmd 0xa800 ctl 0xa480 bmdma 0xa408 irq 19
[    2.119965] Fusion MPT base driver 3.04.12
[    2.119966] Copyright (c) 1999-2008 LSI Corporation
[    2.119973] Fusion MPT SPI Host driver 3.04.12
[    2.119987] Fusion MPT SAS Host driver 3.04.12
[    2.120052] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    2.121561]  sda:
[    2.122348] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.122353] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.122437] mice: PS/2 mouse device common for all mice
[    2.122469]  sda1 sda2
[    2.124892] sd 0:0:1:0: [sdb] 74113331200 512-byte logical blocks: (37.9 TB/34.5 TiB)
[    2.124895] md: raid0 personality registered for level 0
[    2.124897] md: raid1 personality registered for level 1
[    2.124900] md: raid10 personality registered for level 10
[    2.124901] md: raid6 personality registered for level 6
[    2.124903] md: raid5 personality registered for level 5
[    2.124904] md: raid4 personality registered for level 4
[    2.124906] md: multipath personality registered for level -4
[    2.124990] sd 0:0:0:0: [sda] Attached SCSI removable disk
[    2.125594] sd 0:0:1:0: [sdb] Write Protect is off
[    2.125673] sd 0:0:1:0: [sdb] Mode Sense: 06 00 10 00
[    2.125697] sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
[    2.125857] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[    2.126030] EDAC MC: Ver: 2.1.0 Feb 23 2011
[    2.126257] cpuidle: using governor ladder
[    2.126443] TCP cubic registered
[    2.126532] NET: Registered protocol family 17
[    2.127508] sd 0:0:1:0: [sdb] Very big device. Trying to use READ CAPACITY(16).
[    2.127649]  sdb: unknown partition table
[    2.127898] sd 0:0:1:0: [sdb] Very big device. Trying to use READ CAPACITY(16).
[    2.128038] sd 0:0:1:0: [sdb] Attached SCSI removable disk
[    2.140476] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    2.393896] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input1
[    2.449980] ata4: SATA link down (SStatus 0 SControl 300)
[    2.460683] ata3: SATA link down (SStatus 0 SControl 300)
[    2.765421] ata2.00: SATA link down (SStatus 0 SControl 300)
[    2.765510] ata2.01: SATA link down (SStatus 0 SControl 300)
[    2.776151] ata1.00: SATA link down (SStatus 0 SControl 300)
[    2.776239] ata1.01: SATA link down (SStatus 0 SControl 300)
[    2.776365] Freeing unused kernel memory: 516k freed
[    2.776556] Write protecting the kernel read-only data: 5440k
[    3.127359] Intel(R) Gigabit Ethernet Network Driver - version 1.3.16-k2
[    3.127457] Copyright (c) 2007-2009 Intel Corporation.
[    3.127573] igb 0000:0a:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.127661] igb 0000:0a:00.0: setting latency timer to 64
[    3.127925] igb 0000:0a:00.0: irq 79 for MSI/MSI-X
[    3.127928] igb 0000:0a:00.0: irq 80 for MSI/MSI-X
[    3.127931] igb 0000:0a:00.0: irq 81 for MSI/MSI-X
[    3.127934] igb 0000:0a:00.0: irq 82 for MSI/MSI-X
[    3.127937] igb 0000:0a:00.0: irq 83 for MSI/MSI-X
[    3.127940] igb 0000:0a:00.0: irq 84 for MSI/MSI-X
[    3.127943] igb 0000:0a:00.0: irq 85 for MSI/MSI-X
[    3.127946] igb 0000:0a:00.0: irq 86 for MSI/MSI-X
[    3.127948] igb 0000:0a:00.0: irq 87 for MSI/MSI-X
[    3.318644] igb 0000:0a:00.0: Intel(R) Gigabit Ethernet Network Connection
[    3.318729] igb 0000:0a:00.0: eth0: (PCIe:2.5Gb/s:Width x4) 00:30:48:cf:ff:84
[    3.318883] igb 0000:0a:00.0: eth0: PBA No: 0010ff-0ff
[    3.318958] igb 0000:0a:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[    3.319081] igb 0000:0a:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.319170] igb 0000:0a:00.1: setting latency timer to 64
[    3.319431] igb 0000:0a:00.1: irq 88 for MSI/MSI-X
[    3.319434] igb 0000:0a:00.1: irq 89 for MSI/MSI-X
[    3.319437] igb 0000:0a:00.1: irq 90 for MSI/MSI-X
[    3.319439] igb 0000:0a:00.1: irq 91 for MSI/MSI-X
[    3.319442] igb 0000:0a:00.1: irq 92 for MSI/MSI-X
[    3.319444] igb 0000:0a:00.1: irq 93 for MSI/MSI-X
[    3.319447] igb 0000:0a:00.1: irq 94 for MSI/MSI-X
[    3.319449] igb 0000:0a:00.1: irq 95 for MSI/MSI-X
[    3.319452] igb 0000:0a:00.1: irq 96 for MSI/MSI-X
[    3.482177] usbcore: registered new interface driver usbfs
[    3.482289] usbcore: registered new interface driver hub
[    3.482389] usbcore: registered new device driver usb
[    3.484054] uhci_hcd: USB Universal Host Controller Interface driver
[    3.484192] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.484276] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    3.484284] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    3.484378] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    3.484497] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00009400
[    3.484701] usb usb1: configuration #1 chosen from 1 choice
[    3.484798] hub 1-0:1.0: USB hub found
[    3.484874] hub 1-0:1.0: 2 ports detected
[    3.485013] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    3.485097] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    3.485099] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    3.485179] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[    3.485303] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00009480
[    3.485453] usb usb2: configuration #1 chosen from 1 choice
[    3.485549] hub 2-0:1.0: USB hub found
[    3.485623] hub 2-0:1.0: 2 ports detected
[    3.485752] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    3.485834] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    3.485837] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    3.485916] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 3
[    3.486032] uhci_hcd 0000:00:1a.2: irq 19, io base 0x00009800
[    3.486126] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.486182] usb usb3: configuration #1 chosen from 1 choice
[    3.486205] hub 3-0:1.0: USB hub found
[    3.486210] hub 3-0:1.0: 2 ports detected
[    3.486267] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.486273] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.486276] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.486282] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    3.486317] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00009880
[    3.486395] usb usb4: configuration #1 chosen from 1 choice
[    3.486417] hub 4-0:1.0: USB hub found
[    3.486422] hub 4-0:1.0: 2 ports detected
[    3.486477] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    3.486482] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    3.486485] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.486493] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
[    3.486523] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00009c00
[    3.486596] usb usb5: configuration #1 chosen from 1 choice
[    3.486619] hub 5-0:1.0: USB hub found
[    3.486623] hub 5-0:1.0: 2 ports detected
[    3.486684] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.486690] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    3.486693] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.486699] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
[    3.486727] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000a000
[    3.486805] usb usb6: configuration #1 chosen from 1 choice
[    3.486827] hub 6-0:1.0: USB hub found
[    3.486832] hub 6-0:1.0: 2 ports detected
[    3.488036] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    3.488168] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.488281] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    3.488284] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    3.488370] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 7
[    3.488505] ehci_hcd 0000:00:1a.7: debug port 1
[    3.492452] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    3.492461] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfb8fa000
[    3.511843] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    3.512054] usb usb7: configuration #1 chosen from 1 choice
[    3.512158] hub 7-0:1.0: USB hub found
[    3.512235] hub 7-0:1.0: 6 ports detected
[    3.512386] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.512480] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    3.512483] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    3.512563] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 8
[    3.512688] ehci_hcd 0000:00:1d.7: debug port 1
[    3.514455] igb 0000:0a:00.1: Intel(R) Gigabit Ethernet Network Connection
[    3.514541] igb 0000:0a:00.1: eth1: (PCIe:2.5Gb/s:Width x4) 00:30:48:cf:ff:85
[    3.514701] igb 0000:0a:00.1: eth1: PBA No: 0010ff-0ff
[    3.514781] igb 0000:0a:00.1: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[    3.516637] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    3.516645] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfb8fc000
[    3.535820] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    3.535983] usb usb8: configuration #1 chosen from 1 choice
[    3.536082] hub 8-0:1.0: USB hub found
[    3.536159] hub 8-0:1.0: 6 ports detected
[    3.824714] usb 7-5: new high speed USB device using ehci_hcd and address 2
[    3.958182] usb 7-5: configuration #1 chosen from 1 choice
[    4.322693] usb 4-2: new low speed USB device using uhci_hcd and address 2
[    4.493529] usb 4-2: configuration #1 chosen from 1 choice
[    5.231673] input: Peppercon AG Multidevice as /devices/pci0000:00/0000:00:1a.7/usb7/7-5/7-5:1.0/input/input2
[    5.231858] generic-usb 0003:14DD:0002.0001: input: USB HID v1.01 Mouse [Peppercon AG Multidevice] on usb-0000:00:1a.7-5/input0
[    5.233134] input: Peppercon AG Multidevice as /devices/pci0000:00/0000:00:1a.7/usb7/7-5/7-5:1.1/input/input3
[    5.233267] generic-usb 0003:14DD:0002.0002: input: USB HID v1.01 Keyboard [Peppercon AG Multidevice] on usb-0000:00:1a.7-5/input1
[    5.233387] usbcore: registered new interface driver usbhid
[    5.233463] usbhid: v2.6:USB HID core driver
[    5.531513] EXT3-fs: INFO: recovery required on readonly filesystem.
[    5.531591] EXT3-fs: write access will be enabled during recovery.
[    5.906543] kjournald starting.  Commit interval 5 seconds
[    5.906553] EXT3-fs: dm-0: orphan cleanup on readonly fs
[    5.911646] ext3_orphan_cleanup: deleting unreferenced inode 36809
[    5.923295] EXT3-fs: dm-0: 1 orphan inode deleted
[    5.923375] EXT3-fs: recovery complete.
[    5.930764] EXT3-fs: mounted filesystem with ordered data mode.
[    6.720152] udevd version 125 started
[    7.003153] ACPI: SSDT 00000000bf79e1f0 00FAC (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
[    7.004045] ACPI: SSDT 00000000bf79f1a0 00659 (v01  PmRef  P001Cst 00003001 INTL 20051117)
[    7.007022] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input4
[    7.007126] ACPI: Power Button [PWRB]
[    7.007209] Monitor-Mwait will be used to enter C-3 state
[    7.007441] Monitor-Mwait will be used to enter C-3 state
[    7.007541] processor LNXCPU:00: registered as cooling_device0
[    7.007677] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
[    7.007774] ACPI: Power Button [PWRF]
[    7.012236] processor LNXCPU:01: registered as cooling_device1
[    7.013692] processor LNXCPU:02: registered as cooling_device2
[    7.015148] processor LNXCPU:03: registered as cooling_device3
[    7.016777] processor LNXCPU:04: registered as cooling_device4
[    7.033370] processor LNXCPU:05: registered as cooling_device5
[    7.035002] processor LNXCPU:06: registered as cooling_device6
[    7.045118] processor LNXCPU:07: registered as cooling_device7
[    7.932691] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   10.151054] Adding 41943032k swap on /dev/mapper/vgroot-swap.  Priority:-1 extents:1 across:41943032k 
[   10.162387] EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
[   10.162626] EXT3 FS on dm-0, internal journal
[   25.605369] fuse init (API version 7.13)
[   25.787164] EXT2-fs warning: mounting unchecked fs, running e2fsck is recommended
[   25.824638] kjournald starting.  Commit interval 5 seconds
[   25.824935] EXT3 FS on dm-2, internal journal
[   25.825065] EXT3-fs: mounted filesystem with ordered data mode.
[   25.826775] kjournald starting.  Commit interval 5 seconds
[   25.826941] EXT3 FS on dm-3, internal journal
[   25.827117] EXT3-fs: mounted filesystem with ordered data mode.
[   25.828785] kjournald starting.  Commit interval 5 seconds
[   25.828894] EXT3 FS on dm-4, internal journal
[   25.828897] EXT3-fs: mounted filesystem with ordered data mode.
[   25.854908] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[   25.860131] SGI XFS Quota Management subsystem
[   25.878264] XFS mounting filesystem dm-6
[   26.014187] Starting XFS recovery on filesystem: dm-6 (logdev: internal)
[   26.168204] Ending XFS recovery on filesystem: dm-6 (logdev: internal)
[   26.185153] XFS mounting filesystem dm-5
[   26.338834] Starting XFS recovery on filesystem: dm-5 (logdev: internal)
[   26.606237] Ending XFS recovery on filesystem: dm-5 (logdev: internal)
[   26.607341] Filesystem "dm-8": Disabling barriers, not supported with external log device
[   26.630941] XFS mounting filesystem dm-8
[   26.787638] Starting XFS recovery on filesystem: dm-8 (logdev: /dev/vgroot/raid6-intern-log)
[   27.425554] Ending XFS recovery on filesystem: dm-8 (logdev: /dev/vgroot/raid6-intern-log)
[   29.169529] igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[   29.254818] ip_tables: (C) 2000-2006 Netfilter Core Team
[   29.266829] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   29.267790] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[   29.267885] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
[   29.267981] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   39.988554] igb: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[   50.330508] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).

--------------080606050008070102060403
Content-Type: application/x-gzip;
 name="kern.log.1.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="kern.log.1.gz"

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
--------------080606050008070102060403--
