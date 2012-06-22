Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761497Ab2FVHOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 03:14:17 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:1668 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761458Ab2FVHOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 03:14:11 -0400
X-IronPort-AV: E=Sophos;i="4.77,456,1336341600"; 
   d="txt'?scan'208";a="163982422"
Message-ID: <4FE41B3E.7080609@gmail.com>
Date: Fri, 22 Jun 2012 09:14:06 +0200
From: Brice Goglin <brice.goglin@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, Ulrich Drepper <drepper@gmail.com>,
        jbarnes@virtuousgeek.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lenb@kernel.org, x86@kernel.org, linux-pci@vger.kernel.org
Subject: Re: SNB PCI root information
References: <CAOPLpQfUm-2ENkbnYfXEn1nf9FHnaRk3aqQTSTBWb-CsfCUCFA@mail.gmail.com> <CAE9FiQU=Uvj_OFYQLdddf8j59vE7D0aE9cdNZv7P8_Rn7=MmUQ@mail.gmail.com> <CAErSpo57H_ZD_-Z8z9vD3c50My4Rejtc9gXXrxGxDtQomYmrSA@mail.gmail.com> <CAOPLpQeJTfB2UNy3O9FgRCyZb=LyMqd0SOsz7qDM0Ur_sfeNhg@mail.gmail.com> <CAE9FiQVzKr+nyBh=8-v+HEDF=7JqN2CqdTNx1=LHTq=c_OyZvg@mail.gmail.com> <CAErSpo40SDii6PTNisAnsn6SoB7SzPUGztWAg9vaZZv+ByQsPw@mail.gmail.com> <CAE9FiQVDnS9n28GQrKVVTU7GiMtJZLFN1T9vmOm5oSysvMEVhQ@mail.gmail.com> <CAErSpo4x8+M6hGAqJR2rjGEGk2AnnZfJkmaJrJedzhnKiRf2qw@mail.gmail.com> <CAOPLpQchY4gMYaw-Ew5uujD9JCu==VLjQ7Z_OjrT6akTgX4+iA@mail.gmail.com> <CAErSpo6JWKoFcbsLnyzPGXLKssobfudjcYMvYzfEpYZ-bzCHPg@mail.gmail.com> <CAE9FiQWOUZhUQYc66ceG5EMWQ0uO7L3odh0+XwRsLV2Bza2ZpQ@mail.gmail.com> <4FE22B28.9020402@gmail.com> <CAE9FiQUkGCQ0Y=n3i=bq388T8N-vrHP2LtMTFGwry2nA+uppwA@mail.gmail.com> <4FE2B788.3070505@gmail.com> <CAE9FiQWBB0JVCLWa40k9qYJXGrv_z=RgspgQW4x2di0uCUFXmA@mail.gmail.com>
In-Reply-To: <CAE9FiQWBB0JVCLWa40k9qYJXGrv_z=RgspgQW4x2di0uCUFXmA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------000408070705080401080106"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000408070705080401080106
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Le 21/06/2012 21:24, Yinghai Lu a écrit :
> On Wed, Jun 20, 2012 at 10:56 PM, Brice Goglin <brice.goglin@gmail.com> wrote:
>>> I suspected that could be other problem. intel system before
>>> sandbridge does not have IIO.
>>> they will have ioh instead, and one ioh would connect to two cpu sockets.
>>> but _PXM for root bus in dsdt only can return one value. Aka it is
>>> acpi spec limitation.
>> The machines I am talking about have two IOHs (one connected to each
>> socket). I only have an old 2.6.27 boot log at hand, I'll ask my admins
>> for more. Do you want the 2.6.27 dmesg anyway?
>>
> log from 2.6.27 should be good enough for this.
>
> BIOS _PXM return 0 for both pci root buses?
>

Here's dmesg.
I can't say for sure whether _PXM returns 0 since I don't know how to
read all this :) But Linux puts the first socket cpumap in
/sys/bus/pci/devices/*/local_cpus (and that's wrong according to the
motherboard manual and according to the performance we see).

Brice


--------------000408070705080401080106
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="dmesg.txt"

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.27.39-0.3-perfctr (geeko@buildhost) (gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 SMP 2009-11-23 12:57:38 +0100
Command line: root=/dev/system/root resume=/dev/disk/by-id/ata-MM0500EANCR_9SP25ERG-part2 splash=silent crashkernel= maxcpus=12
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 0000000000097c00 (usable)
 BIOS-e820: 0000000000097c00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000a762f000 (usable)
 BIOS-e820: 00000000a762f000 - 00000000a763c000 (ACPI data)
 BIOS-e820: 00000000a763c000 - 00000000a763d000 (usable)
 BIOS-e820: 00000000a763d000 - 00000000ac000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000957fff000 (usable)
DMI 2.7 present.
last_pfn = 0x957fff max_arch_pfn = 0x100000000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
last_pfn = 0xa763d max_arch_pfn = 0x100000000
init_memory_mapping
Using GB pages for direct mapping
 0000000000 - 0080000000 page 1G
 0080000000 - 00a7600000 page 2M
 00a7600000 - 00a763d000 page 4k
kernel direct mapping tables up to a763d000 @ 8000-b000
last_map_addr: a763d000 end: a763d000
init_memory_mapping
Using GB pages for direct mapping
 0100000000 - 0940000000 page 1G
 0940000000 - 0957e00000 page 2M
 0957e00000 - 0957fff000 page 4k
kernel direct mapping tables up to 957fff000 @ a000-d000
last_map_addr: 957fff000 end: 957fff000
RAMDISK: 379b7000 - 37fef773
ACPI: RSDP 000F4F00, 0024 (r2 HP    )
ACPI: XSDT A76305C0, 00BC (r1 HP     ProLiant        2   Ò     162E)
ACPI: FACP A76306C0, 00F4 (r3 HP     ProLiant        2   Ò     162E)
ACPI: DSDT A76307C0, 28B3 (r1 HP         DSDT        1 INTL 20030228)
ACPI: FACS A762F100, 0040
ACPI: SPCR A762F140, 0050 (r1 HP     SPCRRBSU        1   Ò     162E)
ACPI: MCFG A762F1C0, 003C (r1 HP     ProLiant        1             0)
ACPI: HPET A762F200, 0038 (r1 HP     ProLiant        2   Ò     162E)
ACPI: FFFF A762F240, 0064 (r2 HP     ProLiant        2   Ò     162E)
ACPI: SPMI A762F2C0, 0040 (r5 HP     ProLiant        1   Ò     162E)
ACPI: ERST A762F300, 01D0 (r1 HP     ProLiant        1   Ò     162E)
ACPI: APIC A762F500, 016A (r1 HP     ProLiant        2             0)
ACPI: SRAT A762F680, 0570 (r1 HP     Proliant        1   Ò     162E)
ACPI: FFFF A762FC00, 0176 (r1 HP     ProLiant        1   Ò     162E)
ACPI: BERT A762FD80, 0030 (r1 HP     ProLiant        1   Ò     162E)
ACPI: HEST A762FDC0, 00BC (r1 HP     ProLiant        1   Ò     162E)
ACPI: DMAR A762FE80, 0238 (r1 HP     ProLiant        1   Ò     162E)
ACPI: SSDT A7633080, 0125 (r3 HP      CRSPCI0        2   HP        1)
ACPI: SSDT A76331C0, 0086 (r3 HP      CRSPCI1        2   HP        1)
ACPI: SSDT A7633280, 0211 (r3 HP      riser1b        2 INTL 20061109)
ACPI: SSDT A76334C0, 0212 (r3 HP      riser2a        2 INTL 20061109)
ACPI: SSDT A7633700, 03BB (r1 HP          pcc        1 INTL 20090625)
ACPI: SSDT A7633AC0, 4104 (r1  INTEL PPM RCM         1 INTL 20061109)
ACPI: Local APIC address 0xfee00000
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 0 -> APIC 2 -> Node 0
SRAT: PXM 0 -> APIC 3 -> Node 0
SRAT: PXM 0 -> APIC 4 -> Node 0
SRAT: PXM 0 -> APIC 5 -> Node 0
SRAT: PXM 0 -> APIC 16 -> Node 0
SRAT: PXM 0 -> APIC 17 -> Node 0
SRAT: PXM 0 -> APIC 18 -> Node 0
SRAT: PXM 0 -> APIC 19 -> Node 0
SRAT: PXM 0 -> APIC 20 -> Node 0
SRAT: PXM 0 -> APIC 21 -> Node 0
SRAT: PXM 1 -> APIC 32 -> Node 1
SRAT: PXM 1 -> APIC 33 -> Node 1
SRAT: PXM 1 -> APIC 34 -> Node 1
SRAT: PXM 1 -> APIC 35 -> Node 1
SRAT: PXM 1 -> APIC 36 -> Node 1
SRAT: PXM 1 -> APIC 37 -> Node 1
SRAT: PXM 1 -> APIC 48 -> Node 1
SRAT: PXM 1 -> APIC 49 -> Node 1
SRAT: PXM 1 -> APIC 50 -> Node 1
SRAT: PXM 1 -> APIC 51 -> Node 1
SRAT: PXM 1 -> APIC 52 -> Node 1
SRAT: PXM 1 -> APIC 53 -> Node 1
SRAT: Node 0 PXM 0 0-a8000000
SRAT: Node 0 PXM 0 100000000-4d8000000
SRAT: Node 1 PXM 1 4d8000000-958000000
NUMA: Allocated memnodemap from c000 - c280
NUMA: Using 27 for the hash shift.
Bootmem setup node 0 0000000000000000-00000004d8000000
  NODE_DATA [000000000000c280 - 000000000002427f]
  bootmap [0000000000100000 -  000000000019afff] pages 9b
(8 early reservations) ==> bootmem [0000000000 - 04d8000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 0000c569b8]    TEXT DATA BSS ==> [0000200000 - 0000c569b8]
  #3 [00379b7000 - 0037fef773]          RAMDISK ==> [00379b7000 - 0037fef773]
  #4 [0000097c00 - 0000100000]    BIOS reserved ==> [0000097c00 - 0000100000]
  #5 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
  #6 [000000a000 - 000000c000]          PGTABLE ==> [000000a000 - 000000c000]
  #7 [000000c000 - 000000c280]       MEMNODEMAP ==> [000000c000 - 000000c280]
Bootmem setup node 1 00000004d8000000-0000000957fff000
  NODE_DATA [00000004d8000000 - 00000004d8017fff]
  bootmap [00000004d8018000 -  00000004d80a7fff] pages 90
(8 early reservations) ==> bootmem [04d8000000 - 0957fff000]
  #0 [0000000000 - 0000001000]   BIOS data page
  #1 [0000006000 - 0000008000]       TRAMPOLINE
  #2 [0000200000 - 0000c569b8]    TEXT DATA BSS
  #3 [00379b7000 - 0037fef773]          RAMDISK
  #4 [0000097c00 - 0000100000]    BIOS reserved
  #5 [0000008000 - 000000a000]          PGTABLE
  #6 [000000a000 - 000000c000]          PGTABLE
  #7 [000000c000 - 000000c280]       MEMNODEMAP
found SMP MP-table at [ffff8800000f4f80] 000f4f80
crashkernel: memory value expected
 [ffffe20000000000-ffffe20010bfffff] PMD -> [ffff880028200000-ffff8800377fffff] on node 0
 [ffffe20010c00000-ffffe200135fffff] PMD -> [ffff880038000000-ffff88003a9fffff] on node 0
 [ffffe20013600000-ffffe200255fffff] PMD -> [ffff8804d8200000-ffff8804ea1fffff] on node 1
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00957fff
Movable zone start PFN for each node
early_node_map[5] active PFN ranges
    0: 0x00000000 -> 0x00000097
    0: 0x00000100 -> 0x000a762f
    0: 0x000a763c -> 0x000a763d
    0: 0x00100000 -> 0x004d8000
    1: 0x004d8000 -> 0x00957fff
On node 0 totalpages: 4715975
  DMA zone: 1168 pages, LIFO batch:0
  DMA32 zone: 665200 pages, LIFO batch:31
  Normal zone: 3967488 pages, LIFO batch:31
On node 1 totalpages: 4718591
  Normal zone: 4644863 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x908
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x10] lapic_id[0x20] enabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x10] enabled)
ACPI: LAPIC (acpi_id[0x18] lapic_id[0x30] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x14] lapic_id[0x24] enabled)
ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x14] enabled)
ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x34] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x12] lapic_id[0x22] enabled)
ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x12] enabled)
ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x32] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] disabled)
ACPI: LAPIC (acpi_id[0x16] lapic_id[0x26] disabled)
ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x16] disabled)
ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x36] disabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x11] lapic_id[0x21] enabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x11] enabled)
ACPI: LAPIC (acpi_id[0x19] lapic_id[0x31] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x15] lapic_id[0x25] enabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x15] enabled)
ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x35] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x13] lapic_id[0x23] enabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x13] enabled)
ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x33] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] disabled)
ACPI: LAPIC (acpi_id[0x17] lapic_id[0x27] disabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x17] disabled)
ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x37] disabled)
ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 0, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x00] address[0xfec80000] gsi_base[24])
IOAPIC[1]: apic_id 0, version 0, address 0xfec80000, GSI 24-47
ACPI: IOAPIC (id[0x0a] address[0xfec82000] gsi_base[48])
IOAPIC[2]: apic_id 10, version 0, address 0xfec82000, GSI 48-71
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 32 CPUs, 8 hotplug CPUs
PM: Registered nosave memory: 0000000000097000 - 0000000000098000
PM: Registered nosave memory: 0000000000098000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
PM: Registered nosave memory: 00000000a762f000 - 00000000a763c000
PM: Registered nosave memory: 00000000a763d000 - 00000000ac000000
PM: Registered nosave memory: 00000000ac000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 00000000fee10000
PM: Registered nosave memory: 00000000fee10000 - 00000000ff800000
PM: Registered nosave memory: 00000000ff800000 - 0000000100000000
Allocating PCI resources starting at b0000000 (gap: ac000000:52c00000)
PERCPU: Allocating 60960 bytes of per cpu data
NR_CPUS: 512, nr_cpu_ids: 32, nr_node_ids 2
Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 9278719
Policy zone: Normal
Kernel command line: root=/dev/system/root resume=/dev/disk/by-id/ata-MM0500EANCR_9SP25ERG-part2 splash=silent crashkernel= maxcpus=12
bootsplash: silent mode.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC: PIT calibration confirmed by PMTIMER.
TSC: using PIT calibration value
Detected 2666.739 MHz processor.
Marking TSC unstable due to TSCs unsynchronized
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
No AGP bridge found
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing software IO TLB between 0x20000000 - 0x24000000
Memory: 37062812k/39190524k available (2687k kernel code, 675452k reserved, 3164k data, 792k init)
CPA: page pool initialized 1 of 1 pages preallocated
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer frequency.. 5333.47 BogoMIPS (lpj=10666956)
kdb version 4.4 by Keith Owens, Scott Lurndal. Copyright SGI, All Rights Reserved
Security Framework initialized
AppArmor: AppArmor initialized
Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes)
Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 12288K
CPU 0/0 -> Node 0
CPU0: Thermal monitoring enabled (TM1)
using mwait in idle threads.
ACPI: Core revision 20080609
ACPI: Checking initramfs for custom DSDT
Parsing all Control Methods:
Table [DSDT](id 0001) - 374 Objects with 49 Devices 82 Methods 15 Regions
Parsing all Control Methods:
Table [SSDT](id 0002) - 2 Objects with 0 Devices 0 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0003) - 2 Objects with 0 Devices 0 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0004) - 50 Objects with 16 Devices 16 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0005) - 50 Objects with 16 Devices 16 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0006) - 33 Objects with 0 Devices 0 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0007) - 192 Objects with 0 Devices 72 Methods 0 Regions
 tbxface-0596 [00] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
Setting APIC routing to physical flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(R) CPU           X5650  @ 2.67GHz stepping 02
Using local APIC timer interrupts.
APIC timer calibration result 8333556
Detected 8.333 MHz APIC timer.
Booting processor 1/32 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5333.59 BogoMIPS (lpj=10667191)
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 12288K
CPU 1/20 -> Node 1
CPU1: Thermal monitoring enabled (TM1)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Xeon(R) CPU           X5650  @ 2.67GHz stepping 02
Booting processor 2/16 ip 6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 5333.53 BogoMIPS (lpj=10667065)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 8
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 12288K
CPU 2/10 -> Node 0
CPU2: Thermal monitoring enabled (TM1)
x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
CPU2: Intel(R) Xeon(R) CPU           X5650  @ 2.67GHz stepping 02
Booting processor 3/48 ip 6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 5333.60 BogoMIPS (lpj=10667212)
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 8
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 12288K
CPU 3/30 -> Node 1
CPU3: Thermal monitoring enabled (TM1)
x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
CPU3: Intel(R) Xeon(R) CPU           X5650  @ 2.67GHz stepping 02
Booting processor 4/4 ip 6000
Initializing CPU#4
Calibrating delay using timer specific routine.. 5333.61 BogoMIPS (lpj=10667236)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 12288K
CPU 4/4 -> Node 0
CPU4: Thermal monitoring enabled (TM1)
x86 PAT enabled: cpu 4, old 0x7040600070406, new 0x7010600070106
CPU4: Intel(R) Xeon(R) CPU           X5650  @ 2.67GHz stepping 02
Booting processor 5/36 ip 6000
Initializing CPU#5
Calibrating delay using timer specific routine.. 5333.54 BogoMIPS (lpj=10667090)
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 2
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 12288K
CPU 5/24 -> Node 1
CPU5: Thermal monitoring enabled (TM1)
x86 PAT enabled: cpu 5, old 0x7040600070406, new 0x7010600070106
CPU5: Intel(R) Xeon(R) CPU           X5650  @ 2.67GHz stepping 02
Booting processor 6/20 ip 6000
Initializing CPU#6
Calibrating delay using timer specific routine.. 5333.57 BogoMIPS (lpj=10667140)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 10
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 12288K
CPU 6/14 -> Node 0
CPU6: Thermal monitoring enabled (TM1)
x86 PAT enabled: cpu 6, old 0x7040600070406, new 0x7010600070106
CPU6: Intel(R) Xeon(R) CPU           X5650  @ 2.67GHz stepping 02
Booting processor 7/52 ip 6000
Initializing CPU#7
Calibrating delay using timer specific routine.. 5333.53 BogoMIPS (lpj=10667068)
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 10
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 12288K
CPU 7/34 -> Node 1
CPU7: Thermal monitoring enabled (TM1)
x86 PAT enabled: cpu 7, old 0x7040600070406, new 0x7010600070106
CPU7: Intel(R) Xeon(R) CPU           X5650  @ 2.67GHz stepping 02
Booting processor 8/2 ip 6000
Initializing CPU#8
Calibrating delay using timer specific routine.. 5333.54 BogoMIPS (lpj=10667084)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 12288K
CPU 8/2 -> Node 0
CPU8: Thermal monitoring enabled (TM1)
x86 PAT enabled: cpu 8, old 0x7040600070406, new 0x7010600070106
CPU8: Intel(R) Xeon(R) CPU           X5650  @ 2.67GHz stepping 02
Booting processor 9/34 ip 6000
Initializing CPU#9
Calibrating delay using timer specific routine.. 5333.54 BogoMIPS (lpj=10667095)
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 12288K
CPU 9/22 -> Node 1
CPU9: Thermal monitoring enabled (TM1)
x86 PAT enabled: cpu 9, old 0x7040600070406, new 0x7010600070106
CPU9: Intel(R) Xeon(R) CPU           X5650  @ 2.67GHz stepping 02
Booting processor 10/18 ip 6000
Initializing CPU#10
Calibrating delay using timer specific routine.. 5333.53 BogoMIPS (lpj=10667065)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 9
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 12288K
CPU 10/12 -> Node 0
CPU10: Thermal monitoring enabled (TM1)
x86 PAT enabled: cpu 10, old 0x7040600070406, new 0x7010600070106
CPU10: Intel(R) Xeon(R) CPU           X5650  @ 2.67GHz stepping 02
Booting processor 11/50 ip 6000
Initializing CPU#11
Calibrating delay using timer specific routine.. 5333.51 BogoMIPS (lpj=10667025)
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 9
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 12288K
CPU 11/32 -> Node 1
CPU11: Thermal monitoring enabled (TM1)
x86 PAT enabled: cpu 11, old 0x7040600070406, new 0x7010600070106
CPU11: Intel(R) Xeon(R) CPU           X5650  @ 2.67GHz stepping 02
Brought up 12 CPUs
Total of 12 processors activated (64002.61 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0,2,4,6,8,10 level MC
  groups: 0 2 4 6 8 10
  domain 1: span 0-11 level NODE
   groups: 0,2,4,6,8,10 1,3,5,7,9,11
CPU1 attaching sched-domain:
 domain 0: span 1,3,5,7,9,11 level MC
  groups: 1 3 5 7 9 11
  domain 1: span 0-11 level NODE
   groups: 1,3,5,7,9,11 0,2,4,6,8,10
CPU2 attaching sched-domain:
 domain 0: span 0,2,4,6,8,10 level MC
  groups: 2 4 6 8 10 0
  domain 1: span 0-11 level NODE
   groups: 0,2,4,6,8,10 1,3,5,7,9,11
CPU3 attaching sched-domain:
 domain 0: span 1,3,5,7,9,11 level MC
  groups: 3 5 7 9 11 1
  domain 1: span 0-11 level NODE
   groups: 1,3,5,7,9,11 0,2,4,6,8,10
CPU4 attaching sched-domain:
 domain 0: span 0,2,4,6,8,10 level MC
  groups: 4 6 8 10 0 2
  domain 1: span 0-11 level NODE
   groups: 0,2,4,6,8,10 1,3,5,7,9,11
CPU5 attaching sched-domain:
 domain 0: span 1,3,5,7,9,11 level MC
  groups: 5 7 9 11 1 3
  domain 1: span 0-11 level NODE
   groups: 1,3,5,7,9,11 0,2,4,6,8,10
CPU6 attaching sched-domain:
 domain 0: span 0,2,4,6,8,10 level MC
  groups: 6 8 10 0 2 4
  domain 1: span 0-11 level NODE
   groups: 0,2,4,6,8,10 1,3,5,7,9,11
CPU7 attaching sched-domain:
 domain 0: span 1,3,5,7,9,11 level MC
  groups: 7 9 11 1 3 5
  domain 1: span 0-11 level NODE
   groups: 1,3,5,7,9,11 0,2,4,6,8,10
CPU8 attaching sched-domain:
 domain 0: span 0,2,4,6,8,10 level MC
  groups: 8 10 0 2 4 6
  domain 1: span 0-11 level NODE
   groups: 0,2,4,6,8,10 1,3,5,7,9,11
CPU9 attaching sched-domain:
 domain 0: span 1,3,5,7,9,11 level MC
  groups: 9 11 1 3 5 7
  domain 1: span 0-11 level NODE
   groups: 1,3,5,7,9,11 0,2,4,6,8,10
CPU10 attaching sched-domain:
 domain 0: span 0,2,4,6,8,10 level MC
  groups: 10 0 2 4 6 8
  domain 1: span 0-11 level NODE
   groups: 0,2,4,6,8,10 1,3,5,7,9,11
CPU11 attaching sched-domain:
 domain 0: span 1,3,5,7,9,11 level MC
  groups: 11 1 3 5 7 9
  domain 1: span 0-11 level NODE
   groups: 1,3,5,7,9,11 0,2,4,6,8,10
net_namespace: 1936 bytes
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MCFG configuration 0: base a8000000 segment 0 buses 0 - 63
PCI: MCFG area at a8000000 reserved in E820
PCI: Using MMCONFIG at a8000000 - abffffff
PCI: Using configuration type 1 for base access
evgpeblk-0957 [00] ev_create_gpe_block   : GPE 00 to 3F [_GPE] 8 regs on int 0x9
ACPI: EC: Look up EC in DSDT
Completing Region/Field/Buffer/Package initialization:.............................................................................................................
Initialized 12/15 Regions 23/23 Fields 34/34 Buffers 40/40 Packages (712 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:
Executed 0 _INI methods requiring 0 _STA executions (examined 116 objects)
evgpeblk-1054 [00] ev_initialize_gpe_bloc: Found 1 Wake, Enabled 0 Runtime GPEs in this block
ACPI: Interpreter enabled
ACPI: (supports S0 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:00.0: PME# disabled
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
pci 0000:00:04.0: PME# disabled
pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
pci 0000:00:05.0: PME# disabled
pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
pci 0000:00:06.0: PME# disabled
pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
pci 0000:00:07.0: PME# disabled
pci 0000:00:08.0: PME# supported from D0 D3hot D3cold
pci 0000:00:08.0: PME# disabled
pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
pci 0000:00:09.0: PME# disabled
pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
pci 0000:00:0a.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
PCI: 0000:00:1d.0 reg 20 io port: [1000, 101f]
PCI: 0000:00:1d.1 reg 20 io port: [1020, 103f]
PCI: 0000:00:1d.2 reg 20 io port: [1040, 105f]
PCI: 0000:00:1d.3 reg 20 io port: [1060, 107f]
PCI: 0000:00:1d.7 reg 10 32bit mmio: [cf8f0000, cf8f03ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
PCI: 0000:00:1f.2 reg 10 io port: [1080, 1087]
PCI: 0000:00:1f.2 reg 14 io port: [1088, 108b]
PCI: 0000:00:1f.2 reg 18 io port: [1090, 1097]
PCI: 0000:00:1f.2 reg 1c io port: [1098, 109b]
PCI: 0000:00:1f.2 reg 20 io port: [10a0, 10af]
PCI: 0000:00:1f.2 reg 24 io port: [10b0, 10bf]
PCI: 0000:00:1f.5 reg 10 io port: [10c0, 10c7]
PCI: 0000:00:1f.5 reg 14 io port: [10c8, 10cb]
PCI: 0000:00:1f.5 reg 18 io port: [10d0, 10d7]
PCI: 0000:00:1f.5 reg 1c io port: [10d8, 10db]
PCI: 0000:00:1f.5 reg 20 io port: [10e0, 10ef]
PCI: 0000:00:1f.5 reg 24 io port: [10f0, 10ff]
PCI: 0000:04:00.0 reg 10 32bit mmio: [cfde0000, cfdfffff]
PCI: 0000:04:00.0 reg 14 32bit mmio: [cfdc0000, cfddffff]
PCI: 0000:04:00.0 reg 18 io port: [4000, 401f]
PCI: 0000:04:00.0 reg 1c 32bit mmio: [cfdb0000, cfdb3fff]
PCI: 0000:04:00.0 reg 30 32bit mmio: [0, 1ffff]
pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
pci 0000:04:00.0: PME# disabled
PCI: 0000:04:00.1 reg 10 32bit mmio: [cfd80000, cfd9ffff]
PCI: 0000:04:00.1 reg 14 32bit mmio: [cfd60000, cfd7ffff]
PCI: 0000:04:00.1 reg 18 io port: [4020, 403f]
PCI: 0000:04:00.1 reg 1c 32bit mmio: [cfd50000, cfd53fff]
PCI: 0000:04:00.1 reg 30 32bit mmio: [0, 1ffff]
pci 0000:04:00.1: PME# supported from D0 D3hot D3cold
pci 0000:04:00.1: PME# disabled
PCI: bridge 0000:00:01.0 io port: [4000, 4fff]
PCI: bridge 0000:00:01.0 32bit mmio: [cfd00000, cfdfffff]
PCI: 0000:05:00.0 reg 10 64bit mmio: [cfe00000, cfefffff]
PCI: 0000:05:00.0 reg 18 64bit mmio: [bb800000, bbffffff]
PCI: 0000:05:00.0 reg 30 32bit mmio: [0, fffff]
PCI: bridge 0000:00:05.0 32bit mmio: [cfe00000, cfefffff]
PCI: bridge 0000:00:05.0 64bit mmio pref: [bb800000, bbffffff]
PCI: 0000:06:00.0 reg 10 32bit mmio: [d0000000, d1ffffff]
PCI: 0000:06:00.0 reg 14 64bit mmio: [c0000000, c7ffffff]
PCI: 0000:06:00.0 reg 1c 64bit mmio: [bc000000, bfffffff]
PCI: 0000:06:00.0 reg 24 io port: [5000, 507f]
PCI: 0000:06:00.0 reg 30 32bit mmio: [0, 7ffff]
PCI: 0000:06:00.1 reg 10 32bit mmio: [cfff0000, cfff3fff]
PCI: bridge 0000:00:07.0 io port: [5000, 5fff]
PCI: bridge 0000:00:07.0 32bit mmio: [cff00000, d1ffffff]
PCI: bridge 0000:00:07.0 64bit mmio pref: [bc000000, c7ffffff]
PCI: 0000:02:00.0 reg 10 io port: [3000, 30ff]
PCI: 0000:02:00.0 reg 14 32bit mmio: [cfcf0000, cfcf01ff]
PCI: 0000:02:00.0 reg 18 io port: [3400, 34ff]
PCI: 0000:02:00.2 reg 10 io port: [3800, 38ff]
PCI: 0000:02:00.2 reg 14 32bit mmio: [cfce0000, cfce00ff]
PCI: 0000:02:00.2 reg 18 32bit mmio: [cfb00000, cfbfffff]
PCI: 0000:02:00.2 reg 1c 32bit mmio: [cfa80000, cfafffff]
PCI: 0000:02:00.2 reg 20 32bit mmio: [cfa70000, cfa77fff]
PCI: 0000:02:00.2 reg 24 32bit mmio: [cfa60000, cfa67fff]
PCI: 0000:02:00.2 reg 30 32bit mmio: [0, ffff]
pci 0000:02:00.2: PME# supported from D0 D3hot D3cold
pci 0000:02:00.2: PME# disabled
PCI: 0000:02:00.4 reg 20 io port: [3c00, 3c1f]
PCI: bridge 0000:00:1c.4 io port: [3000, 3fff]
PCI: bridge 0000:00:1c.4 32bit mmio: [cfa00000, cfcfffff]
PCI: 0000:01:03.0 reg 10 32bit mmio: [b0000000, b7ffffff]
PCI: 0000:01:03.0 reg 14 io port: [2000, 20ff]
PCI: 0000:01:03.0 reg 18 32bit mmio: [cf9f0000, cf9fffff]
PCI: 0000:01:03.0 reg 30 32bit mmio: [0, 1ffff]
pci 0000:01:03.0: supports D1
pci 0000:01:03.0: supports D2
pci 0000:00:1e.0: transparent bridge
PCI: bridge 0000:00:1e.0 io port: [2000, 2fff]
PCI: bridge 0000:00:1e.0 32bit mmio: [cf900000, cf9fffff]
PCI: bridge 0000:00:1e.0 64bit mmio pref: [b0000000, b7ffffff]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IP2P._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IPT1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IPT5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT03._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT04._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT05._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT06._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT07._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT08._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT09._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT0A._PRT]
ACPI: PCI Root Bridge [PCI1] (0000:10)
pci 0000:10:01.0: PME# supported from D0 D3hot D3cold
pci 0000:10:01.0: PME# disabled
pci 0000:10:02.0: PME# supported from D0 D3hot D3cold
pci 0000:10:02.0: PME# disabled
pci 0000:10:03.0: PME# supported from D0 D3hot D3cold
pci 0000:10:03.0: PME# disabled
pci 0000:10:04.0: PME# supported from D0 D3hot D3cold
pci 0000:10:04.0: PME# disabled
pci 0000:10:05.0: PME# supported from D0 D3hot D3cold
pci 0000:10:05.0: PME# disabled
pci 0000:10:06.0: PME# supported from D0 D3hot D3cold
pci 0000:10:06.0: PME# disabled
pci 0000:10:07.0: PME# supported from D0 D3hot D3cold
pci 0000:10:07.0: PME# disabled
pci 0000:10:08.0: PME# supported from D0 D3hot D3cold
pci 0000:10:08.0: PME# disabled
pci 0000:10:09.0: PME# supported from D0 D3hot D3cold
pci 0000:10:09.0: PME# disabled
pci 0000:10:0a.0: PME# supported from D0 D3hot D3cold
pci 0000:10:0a.0: PME# disabled
PCI: 0000:14:00.0 reg 10 32bit mmio: [fa000000, fbffffff]
PCI: 0000:14:00.0 reg 14 64bit mmio: [e8000000, efffffff]
PCI: 0000:14:00.0 reg 1c 64bit mmio: [e4000000, e7ffffff]
PCI: 0000:14:00.0 reg 24 io port: [7000, 707f]
PCI: 0000:14:00.0 reg 30 32bit mmio: [0, 7ffff]
PCI: 0000:14:00.1 reg 10 32bit mmio: [f9ff0000, f9ff3fff]
PCI: bridge 0000:10:03.0 io port: [7000, 7fff]
PCI: bridge 0000:10:03.0 32bit mmio: [f9f00000, fbffffff]
PCI: bridge 0000:10:03.0 64bit mmio pref: [e4000000, efffffff]
PCI: 0000:11:00.0 reg 10 32bit mmio: [f6000000, f7ffffff]
PCI: 0000:11:00.0 reg 14 64bit mmio: [d8000000, dfffffff]
PCI: 0000:11:00.0 reg 1c 64bit mmio: [d4000000, d7ffffff]
PCI: 0000:11:00.0 reg 24 io port: [6000, 607f]
PCI: 0000:11:00.0 reg 30 32bit mmio: [0, 7ffff]
PCI: 0000:11:00.1 reg 10 32bit mmio: [f5ff0000, f5ff3fff]
PCI: bridge 0000:10:07.0 io port: [6000, 6fff]
PCI: bridge 0000:10:07.0 32bit mmio: [f5f00000, f7ffffff]
PCI: bridge 0000:10:07.0 64bit mmio pref: [d4000000, dfffffff]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.PT01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.PT02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.PT03._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.PT04._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.PT05._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.PT06._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.PT07._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.PT08._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.PT09._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.PT0A._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 7 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *7 10 11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 5 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs *5 7 10 11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 5 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 5 7 *10 11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 5 *7 10 11)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
PCI: Using ACPI for IRQ routing
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 64-bit timers, 14318180 Hz
AppArmor: AppArmor Filesystem Enabled
ACPI: RTC can wake from S4
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 10
Switched to high resolution mode on CPU 2
Switched to high resolution mode on CPU 5
Switched to high resolution mode on CPU 9
Switched to high resolution mode on CPU 11
Switched to high resolution mode on CPU 6
Switched to high resolution mode on CPU 8
Switched to high resolution mode on CPU 4
Switched to high resolution mode on CPU 7
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 3
system 00:01: ioport range 0x408-0x40f has been reserved
system 00:01: ioport range 0x4d0-0x4d1 has been reserved
system 00:01: ioport range 0x700-0x71f has been reserved
system 00:01: ioport range 0x880-0x8ff has been reserved
system 00:01: ioport range 0x900-0x97f has been reserved
system 00:01: ioport range 0xcd4-0xcd7 has been reserved
system 00:01: ioport range 0xcd0-0xcd3 has been reserved
system 00:01: ioport range 0xf50-0xf58 has been reserved
system 00:01: ioport range 0xca0-0xca1 has been reserved
system 00:01: ioport range 0xca4-0xca5 has been reserved
system 00:01: ioport range 0x2f8-0x2ff has been reserved
system 00:01: iomem range 0xa8000000-0xabffffff could not be reserved
system 00:01: iomem range 0xfe000000-0xfebfffff has been reserved
system 00:01: iomem range 0xafffe000-0xafffffff has been reserved
system 00:0c: iomem range 0xd3ffe000-0xd3ffffff has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:04
pci 0000:00:01.0:   IO window: 0x4000-0x4fff
pci 0000:00:01.0:   MEM window: 0xcfd00000-0xcfdfffff
pci 0000:00:01.0:   PREFETCH window: 0x000000b8000000-0x000000b80fffff
pci 0000:00:02.0: PCI bridge, secondary bus 0000:0a
pci 0000:00:02.0:   IO window: disabled
pci 0000:00:02.0:   MEM window: disabled
pci 0000:00:02.0:   PREFETCH window: disabled
pci 0000:00:03.0: PCI bridge, secondary bus 0000:09
pci 0000:00:03.0:   IO window: disabled
pci 0000:00:03.0:   MEM window: disabled
pci 0000:00:03.0:   PREFETCH window: disabled
pci 0000:00:04.0: PCI bridge, secondary bus 0000:0b
pci 0000:00:04.0:   IO window: disabled
pci 0000:00:04.0:   MEM window: disabled
pci 0000:00:04.0:   PREFETCH window: disabled
pci 0000:05:00.0: BAR 6: can't allocate mem resource [0xbc000000-0xbbffffff]
pci 0000:00:05.0: PCI bridge, secondary bus 0000:05
pci 0000:00:05.0:   IO window: disabled
pci 0000:00:05.0:   MEM window: 0xcfe00000-0xcfefffff
pci 0000:00:05.0:   PREFETCH window: 0x000000bb800000-0x000000bbffffff
pci 0000:00:06.0: PCI bridge, secondary bus 0000:0c
pci 0000:00:06.0:   IO window: disabled
pci 0000:00:06.0:   MEM window: disabled
pci 0000:00:06.0:   PREFETCH window: disabled
pci 0000:00:07.0: PCI bridge, secondary bus 0000:06
pci 0000:00:07.0:   IO window: 0x5000-0x5fff
pci 0000:00:07.0:   MEM window: 0xcff00000-0xd1ffffff
pci 0000:00:07.0:   PREFETCH window: 0x000000bc000000-0x000000c7ffffff
pci 0000:00:08.0: PCI bridge, secondary bus 0000:0d
pci 0000:00:08.0:   IO window: disabled
pci 0000:00:08.0:   MEM window: disabled
pci 0000:00:08.0:   PREFETCH window: disabled
pci 0000:00:09.0: PCI bridge, secondary bus 0000:0e
pci 0000:00:09.0:   IO window: disabled
pci 0000:00:09.0:   MEM window: disabled
pci 0000:00:09.0:   PREFETCH window: disabled
pci 0000:00:0a.0: PCI bridge, secondary bus 0000:0f
pci 0000:00:0a.0:   IO window: disabled
pci 0000:00:0a.0:   MEM window: disabled
pci 0000:00:0a.0:   PREFETCH window: disabled
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: disabled
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.4: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.4:   IO window: 0x3000-0x3fff
pci 0000:00:1c.4:   MEM window: 0xcfa00000-0xcfcfffff
pci 0000:00:1c.4:   PREFETCH window: 0x000000b8100000-0x000000b81fffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:01
pci 0000:00:1e.0:   IO window: 0x2000-0x2fff
pci 0000:00:1e.0:   MEM window: 0xcf900000-0xcf9fffff
pci 0000:00:1e.0:   PREFETCH window: 0x000000b0000000-0x000000b7ffffff
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:02.0: setting latency timer to 64
pci 0000:00:03.0: setting latency timer to 64
pci 0000:00:04.0: setting latency timer to 64
pci 0000:00:05.0: setting latency timer to 64
pci 0000:00:06.0: setting latency timer to 64
pci 0000:00:07.0: setting latency timer to 64
pci 0000:00:08.0: setting latency timer to 64
pci 0000:00:09.0: setting latency timer to 64
pci 0000:00:0a.0: setting latency timer to 64
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci 0000:10:01.0: PCI bridge, secondary bus 0000:18
pci 0000:10:01.0:   IO window: disabled
pci 0000:10:01.0:   MEM window: disabled
pci 0000:10:01.0:   PREFETCH window: disabled
pci 0000:10:02.0: PCI bridge, secondary bus 0000:19
pci 0000:10:02.0:   IO window: disabled
pci 0000:10:02.0:   MEM window: disabled
pci 0000:10:02.0:   PREFETCH window: disabled
pci 0000:10:03.0: PCI bridge, secondary bus 0000:14
pci 0000:10:03.0:   IO window: 0x7000-0x7fff
pci 0000:10:03.0:   MEM window: 0xf9f00000-0xfbffffff
pci 0000:10:03.0:   PREFETCH window: 0x000000e4000000-0x000000efffffff
pci 0000:10:04.0: PCI bridge, secondary bus 0000:1a
pci 0000:10:04.0:   IO window: disabled
pci 0000:10:04.0:   MEM window: disabled
pci 0000:10:04.0:   PREFETCH window: disabled
pci 0000:10:05.0: PCI bridge, secondary bus 0000:1b
pci 0000:10:05.0:   IO window: disabled
pci 0000:10:05.0:   MEM window: disabled
pci 0000:10:05.0:   PREFETCH window: disabled
pci 0000:10:06.0: PCI bridge, secondary bus 0000:1c
pci 0000:10:06.0:   IO window: disabled
pci 0000:10:06.0:   MEM window: disabled
pci 0000:10:06.0:   PREFETCH window: disabled
pci 0000:10:07.0: PCI bridge, secondary bus 0000:11
pci 0000:10:07.0:   IO window: 0x6000-0x6fff
pci 0000:10:07.0:   MEM window: 0xf5f00000-0xf7ffffff
pci 0000:10:07.0:   PREFETCH window: 0x000000d4000000-0x000000dfffffff
pci 0000:10:08.0: PCI bridge, secondary bus 0000:1d
pci 0000:10:08.0:   IO window: disabled
pci 0000:10:08.0:   MEM window: disabled
pci 0000:10:08.0:   PREFETCH window: disabled
pci 0000:10:09.0: PCI bridge, secondary bus 0000:1e
pci 0000:10:09.0:   IO window: disabled
pci 0000:10:09.0:   MEM window: disabled
pci 0000:10:09.0:   PREFETCH window: disabled
pci 0000:10:0a.0: PCI bridge, secondary bus 0000:1f
pci 0000:10:0a.0:   IO window: disabled
pci 0000:10:0a.0:   MEM window: disabled
pci 0000:10:0a.0:   PREFETCH window: disabled
pci 0000:10:01.0: setting latency timer to 64
pci 0000:10:02.0: setting latency timer to 64
pci 0000:10:03.0: setting latency timer to 64
pci 0000:10:04.0: setting latency timer to 64
pci 0000:10:05.0: setting latency timer to 64
pci 0000:10:06.0: setting latency timer to 64
pci 0000:10:07.0: setting latency timer to 64
pci 0000:10:08.0: setting latency timer to 64
pci 0000:10:09.0: setting latency timer to 64
pci 0000:10:0a.0: setting latency timer to 64
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffffffffffff]
bus: 04 index 0 io port: [4000, 4fff]
bus: 04 index 1 mmio: [cfd00000, cfdfffff]
bus: 04 index 2 mmio: [b8000000, b80fffff]
bus: 04 index 3 mmio: [0, 0]
bus: 0a index 0 mmio: [0, 0]
bus: 0a index 1 mmio: [0, 0]
bus: 0a index 2 mmio: [0, 0]
bus: 0a index 3 mmio: [0, 0]
bus: 09 index 0 mmio: [0, 0]
bus: 09 index 1 mmio: [0, 0]
bus: 09 index 2 mmio: [0, 0]
bus: 09 index 3 mmio: [0, 0]
bus: 0b index 0 mmio: [0, 0]
bus: 0b index 1 mmio: [0, 0]
bus: 0b index 2 mmio: [0, 0]
bus: 0b index 3 mmio: [0, 0]
bus: 05 index 0 mmio: [0, 0]
bus: 05 index 1 mmio: [cfe00000, cfefffff]
bus: 05 index 2 mmio: [bb800000, bbffffff]
bus: 05 index 3 mmio: [0, 0]
bus: 0c index 0 mmio: [0, 0]
bus: 0c index 1 mmio: [0, 0]
bus: 0c index 2 mmio: [0, 0]
bus: 0c index 3 mmio: [0, 0]
bus: 06 index 0 io port: [5000, 5fff]
bus: 06 index 1 mmio: [cff00000, d1ffffff]
bus: 06 index 2 mmio: [bc000000, c7ffffff]
bus: 06 index 3 mmio: [0, 0]
bus: 0d index 0 mmio: [0, 0]
bus: 0d index 1 mmio: [0, 0]
bus: 0d index 2 mmio: [0, 0]
bus: 0d index 3 mmio: [0, 0]
bus: 0e index 0 mmio: [0, 0]
bus: 0e index 1 mmio: [0, 0]
bus: 0e index 2 mmio: [0, 0]
bus: 0e index 3 mmio: [0, 0]
bus: 0f index 0 mmio: [0, 0]
bus: 0f index 1 mmio: [0, 0]
bus: 0f index 2 mmio: [0, 0]
bus: 0f index 3 mmio: [0, 0]
bus: 03 index 0 mmio: [0, 0]
bus: 03 index 1 mmio: [0, 0]
bus: 03 index 2 mmio: [0, 0]
bus: 03 index 3 mmio: [0, 0]
bus: 02 index 0 io port: [3000, 3fff]
bus: 02 index 1 mmio: [cfa00000, cfcfffff]
bus: 02 index 2 mmio: [b8100000, b81fffff]
bus: 02 index 3 mmio: [0, 0]
bus: 01 index 0 io port: [2000, 2fff]
bus: 01 index 1 mmio: [cf900000, cf9fffff]
bus: 01 index 2 mmio: [b0000000, b7ffffff]
bus: 01 index 3 io port: [0, ffff]
bus: 01 index 4 mmio: [0, ffffffffffffffff]
bus: 10 index 0 io port: [0, ffff]
bus: 10 index 1 mmio: [0, ffffffffffffffff]
bus: 18 index 0 mmio: [0, 0]
bus: 18 index 1 mmio: [0, 0]
bus: 18 index 2 mmio: [0, 0]
bus: 18 index 3 mmio: [0, 0]
bus: 19 index 0 mmio: [0, 0]
bus: 19 index 1 mmio: [0, 0]
bus: 19 index 2 mmio: [0, 0]
bus: 19 index 3 mmio: [0, 0]
bus: 14 index 0 io port: [7000, 7fff]
bus: 14 index 1 mmio: [f9f00000, fbffffff]
bus: 14 index 2 mmio: [e4000000, efffffff]
bus: 14 index 3 mmio: [0, 0]
bus: 1a index 0 mmio: [0, 0]
bus: 1a index 1 mmio: [0, 0]
bus: 1a index 2 mmio: [0, 0]
bus: 1a index 3 mmio: [0, 0]
bus: 1b index 0 mmio: [0, 0]
bus: 1b index 1 mmio: [0, 0]
bus: 1b index 2 mmio: [0, 0]
bus: 1b index 3 mmio: [0, 0]
bus: 1c index 0 mmio: [0, 0]
bus: 1c index 1 mmio: [0, 0]
bus: 1c index 2 mmio: [0, 0]
bus: 1c index 3 mmio: [0, 0]
bus: 11 index 0 io port: [6000, 6fff]
bus: 11 index 1 mmio: [f5f00000, f7ffffff]
bus: 11 index 2 mmio: [d4000000, dfffffff]
bus: 11 index 3 mmio: [0, 0]
bus: 1d index 0 mmio: [0, 0]
bus: 1d index 1 mmio: [0, 0]
bus: 1d index 2 mmio: [0, 0]
bus: 1d index 3 mmio: [0, 0]
bus: 1e index 0 mmio: [0, 0]
bus: 1e index 1 mmio: [0, 0]
bus: 1e index 2 mmio: [0, 0]
bus: 1e index 3 mmio: [0, 0]
bus: 1f index 0 mmio: [0, 0]
bus: 1f index 1 mmio: [0, 0]
bus: 1f index 2 mmio: [0, 0]
bus: 1f index 3 mmio: [0, 0]
NET: Registered protocol family 2
IP route cache hash table entries: 2097152 (order: 12, 16777216 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Unpacking initramfs... done
Freeing initrd memory: 6369k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1338282724.792:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 18100
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:01:03.0: Boot video device
pcieport-driver 0000:00:01.0: setting latency timer to 64
pcieport-driver 0000:00:01.0: found MSI capability
pci_express 0000:00:01.0:pcie00: allocate port service
pci_express 0000:00:01.0:pcie01: allocate port service
pcieport-driver 0000:00:02.0: setting latency timer to 64
pcieport-driver 0000:00:02.0: found MSI capability
pci_express 0000:00:02.0:pcie00: allocate port service
pci_express 0000:00:02.0:pcie01: allocate port service
pcieport-driver 0000:00:03.0: setting latency timer to 64
pcieport-driver 0000:00:03.0: found MSI capability
pci_express 0000:00:03.0:pcie00: allocate port service
pci_express 0000:00:03.0:pcie01: allocate port service
pcieport-driver 0000:00:04.0: setting latency timer to 64
pcieport-driver 0000:00:04.0: found MSI capability
pci_express 0000:00:04.0:pcie00: allocate port service
pci_express 0000:00:04.0:pcie01: allocate port service
pcieport-driver 0000:00:05.0: setting latency timer to 64
pcieport-driver 0000:00:05.0: found MSI capability
pci_express 0000:00:05.0:pcie00: allocate port service
pci_express 0000:00:05.0:pcie01: allocate port service
pcieport-driver 0000:00:06.0: setting latency timer to 64
pcieport-driver 0000:00:06.0: found MSI capability
pci_express 0000:00:06.0:pcie00: allocate port service
pci_express 0000:00:06.0:pcie01: allocate port service
pcieport-driver 0000:00:07.0: setting latency timer to 64
pcieport-driver 0000:00:07.0: found MSI capability
pci_express 0000:00:07.0:pcie00: allocate port service
pci_express 0000:00:07.0:pcie01: allocate port service
pcieport-driver 0000:00:08.0: setting latency timer to 64
pcieport-driver 0000:00:08.0: found MSI capability
pci_express 0000:00:08.0:pcie00: allocate port service
pci_express 0000:00:08.0:pcie01: allocate port service
pcieport-driver 0000:00:09.0: setting latency timer to 64
pcieport-driver 0000:00:09.0: found MSI capability
pci_express 0000:00:09.0:pcie00: allocate port service
pci_express 0000:00:09.0:pcie01: allocate port service
pcieport-driver 0000:00:0a.0: setting latency timer to 64
pcieport-driver 0000:00:0a.0: found MSI capability
pci_express 0000:00:0a.0:pcie00: allocate port service
pci_express 0000:00:0a.0:pcie01: allocate port service
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie03: allocate port service
pcieport-driver 0000:00:1c.4: setting latency timer to 64
pcieport-driver 0000:00:1c.4: found MSI capability
pci_express 0000:00:1c.4:pcie00: allocate port service
pci_express 0000:00:1c.4:pcie03: allocate port service
pcieport-driver 0000:10:01.0: setting latency timer to 64
pcieport-driver 0000:10:01.0: found MSI capability
pci_express 0000:10:01.0:pcie00: allocate port service
pci_express 0000:10:01.0:pcie01: allocate port service
pcieport-driver 0000:10:02.0: setting latency timer to 64
pcieport-driver 0000:10:02.0: found MSI capability
pci_express 0000:10:02.0:pcie00: allocate port service
pci_express 0000:10:02.0:pcie01: allocate port service
pcieport-driver 0000:10:03.0: setting latency timer to 64
pcieport-driver 0000:10:03.0: found MSI capability
pci_express 0000:10:03.0:pcie00: allocate port service
pci_express 0000:10:03.0:pcie01: allocate port service
pcieport-driver 0000:10:04.0: setting latency timer to 64
pcieport-driver 0000:10:04.0: found MSI capability
pci_express 0000:10:04.0:pcie00: allocate port service
pci_express 0000:10:04.0:pcie01: allocate port service
pcieport-driver 0000:10:05.0: setting latency timer to 64
pcieport-driver 0000:10:05.0: found MSI capability
pci_express 0000:10:05.0:pcie00: allocate port service
pci_express 0000:10:05.0:pcie01: allocate port service
pcieport-driver 0000:10:06.0: setting latency timer to 64
pcieport-driver 0000:10:06.0: found MSI capability
pci_express 0000:10:06.0:pcie00: allocate port service
pci_express 0000:10:06.0:pcie01: allocate port service
pcieport-driver 0000:10:07.0: setting latency timer to 64
pcieport-driver 0000:10:07.0: found MSI capability
pci_express 0000:10:07.0:pcie00: allocate port service
pci_express 0000:10:07.0:pcie01: allocate port service
pcieport-driver 0000:10:08.0: setting latency timer to 64
pcieport-driver 0000:10:08.0: found MSI capability
pci_express 0000:10:08.0:pcie00: allocate port service
pci_express 0000:10:08.0:pcie01: allocate port service
pcieport-driver 0000:10:09.0: setting latency timer to 64
pcieport-driver 0000:10:09.0: found MSI capability
pci_express 0000:10:09.0:pcie00: allocate port service
pci_express 0000:10:09.0:pcie01: allocate port service
pcieport-driver 0000:10:0a.0: setting latency timer to 64
pcieport-driver 0000:10:0a.0: found MSI capability
pci_express 0000:10:0a.0:pcie00: allocate port service
pci_express 0000:10:0a.0:pcie01: allocate port service
aer 0000:00:01.0:pcie01: AER service couldn't init device: no _OSC support
aer 0000:00:02.0:pcie01: AER service couldn't init device: no _OSC support
aer 0000:00:03.0:pcie01: AER service couldn't init device: no _OSC support
aer 0000:00:04.0:pcie01: AER service couldn't init device: no _OSC support
aer 0000:00:05.0:pcie01: AER service couldn't init device: no _OSC support
aer 0000:00:06.0:pcie01: AER service couldn't init device: no _OSC support
aer 0000:00:07.0:pcie01: AER service couldn't init device: no _OSC support
aer 0000:00:08.0:pcie01: AER service couldn't init device: no _OSC support
aer 0000:00:09.0:pcie01: AER service couldn't init device: no _OSC support
aer 0000:00:0a.0:pcie01: AER service couldn't init device: no _OSC support
aer 0000:10:01.0:pcie01: AER service couldn't init device: no _OSC support
aer 0000:10:02.0:pcie01: AER service couldn't init device: no _OSC support
aer 0000:10:03.0:pcie01: AER service couldn't init device: no _OSC support
aer 0000:10:04.0:pcie01: AER service couldn't init device: no _OSC support
aer 0000:10:05.0:pcie01: AER service couldn't init device: no _OSC support
aer 0000:10:06.0:pcie01: AER service couldn't init device: no _OSC support
aer 0000:10:07.0:pcie01: AER service couldn't init device: no _OSC support
aer 0000:10:08.0:pcie01: AER service couldn't init device: no _OSC support
aer 0000:10:09.0:pcie01: AER service couldn't init device: no _OSC support
aer 0000:10:0a.0:pcie01: AER service couldn't init device: no _OSC support
hpet_resources: 0xfed00000 is busy
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
Serial: 8250/16550 driver8 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
Please email the following PERFCTR INIT lines to mikpe@it.uu.se
To remove this message, rebuild the driver with CONFIG_PERFCTR_INIT_TESTS=n
PERFCTR INIT: vendor 0, family 6, model 44, stepping 2, clock 2666739 kHz
PERFCTR INIT: NITER == 64
PERFCTR INIT: loop overhead is 448 cycles
PERFCTR INIT: rdtsc cost is 42.3 cycles (3160 total)
PERFCTR INIT: rdpmc cost is 53.4 cycles (3866 total)
PERFCTR INIT: rdmsr (counter) cost is 176.9 cycles (11774 total)
PERFCTR INIT: rdmsr (evntsel) cost is 145.1 cycles (9740 total)
PERFCTR INIT: wrmsr (counter) cost is 266.0 cycles (17472 total)
PERFCTR INIT: wrmsr (evntsel) cost is 248.9 cycles (16380 total)
PERFCTR INIT: read cr4 cost is 16.9 cycles (1534 total)
PERFCTR INIT: write cr4 cost is 226.7 cycles (14960 total)
PERFCTR INIT: write LVTPC cost is 51.3 cycles (3734 total)
PERFCTR INIT: sync_core cost is 300.8 cycles (19700 total)
PERFCTR INIT: read fixed_ctr0 cost is 51.7 cycles (3760 total)
PERFCTR INIT: wrmsr fixed_ctr_ctrl cost is 263.0 cycles (17286 total)
perfctr: driver 2.6.41 DEBUG, cpu type Intel Westmere at 2666739 kHz
TCP cubic registered
registered taskstats version 1
Freeing unused kernel memory: 792k freed
Write protecting the kernel read-only data: 4920k
ACPI: No dock devices found.
SCSI subsystem initialized
libata version 3.00 loaded.
ata_piix 0000:00:1f.2: version 2.12
ata_piix 0000:00:1f.2: PCI INT B -> GSI 20 (level, low) -> IRQ 20
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0x1080 ctl 0x1088 bmdma 0x10a0 irq 20
ata2: SATA max UDMA/133 cmd 0x1090 ctl 0x1098 bmdma 0x10a8 irq 20
ata1.00: SATA link down (SStatus 0 SControl 300)
ata1.01: SATA link down (SStatus 0 SControl 300)
ata2.00: SATA link down (SStatus 0 SControl 300)
ata2.01: SATA link down (SStatus 0 SControl 300)
ata_piix 0000:00:1f.5: PCI INT B -> GSI 20 (level, low) -> IRQ 20
ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
ata_piix 0000:00:1f.5: setting latency timer to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0x10c0 ctl 0x10c8 bmdma 0x10e0 irq 20
ata4: SATA max UDMA/133 cmd 0x10d0 ctl 0x10d8 bmdma 0x10e8 irq 20
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-8: MM0500EANCR, HPG3, max UDMA/133
ata3.00: 976773168 sectors, multi 8: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/133
ata4: SATA link down (SStatus 0 SControl 300)
scsi 2:0:0:0: Direct-Access     ATA      MM0500EANCR      HPG3 PQ: 0 ANSI: 5
Uniform Multi-Platform E-IDE driver
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-3 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C3] C3[C3])
processor ACPI_CPU:00: registered as cooling_device0
tick-broadcast: ignoring broadcast for offline CPU #12
ACPI: CPU12 (power states: C1[C1] C2[C3] C3[C3])
processor ACPI_CPU:01: registered as cooling_device1
ACPI: CPU8 (power states: C1[C1] C2[C3] C3[C3])
processor ACPI_CPU:02: registered as cooling_device2
tick-broadcast: ignoring broadcast for offline CPU #20
ACPI: CPU20 (power states: C1[C1] C2[C3] C3[C3])
processor ACPI_CPU:03: registered as cooling_device3
ACPI: CPU4 (power states: C1[C1] C2[C3] C3[C3])
processor ACPI_CPU:04: registered as cooling_device4
tick-broadcast: ignoring broadcast for offline CPU #16
ACPI: CPU16 (power states: C1[C1] C2[C3] C3[C3])
processor ACPI_CPU:05: registered as cooling_device5
ACPI: CPU2 (power states: C1[C1] C2[C3] C3[C3])
processor ACPI_CPU:08: registered as cooling_device6
tick-broadcast: ignoring broadcast for offline CPU #14
ACPI: CPU14 (power states: C1[C1] C2[C3] C3[C3])
processor ACPI_CPU:09: registered as cooling_device7
ACPI: CPU10 (power states: C1[C1] C2[C3] C3[C3])
processor ACPI_CPU:0a: registered as cooling_device8
tick-broadcast: ignoring broadcast for offline CPU #22
ACPI: CPU22 (power states: C1[C1] C2[C3] C3[C3])
processor ACPI_CPU:0b: registered as cooling_device9
ACPI: CPU6 (power states: C1[C1] C2[C3] C3[C3])
processor ACPI_CPU:0c: registered as cooling_device10
tick-broadcast: ignoring broadcast for offline CPU #18
ACPI: CPU18 (power states: C1[C1] C2[C3] C3[C3])
processor ACPI_CPU:0d: registered as cooling_device11
ACPI: CPU1 (power states: C1[C1] C2[C3] C3[C3])
processor ACPI_CPU:10: registered as cooling_device12
tick-broadcast: ignoring broadcast for offline CPU #13
ACPI: CPU13 (power states: C1[C1] C2[C3] C3[C3])
processor ACPI_CPU:11: registered as cooling_device13
ACPI: CPU9 (power states: C1[C1] C2[C3] C3[C3])
processor ACPI_CPU:12: registered as cooling_device14
tick-broadcast: ignoring broadcast for offline CPU #21
ACPI: CPU21 (power states: C1[C1] C2[C3] C3[C3])
processor ACPI_CPU:13: registered as cooling_device15
ACPI: CPU5 (power states: C1[C1] C2[C3] C3[C3])
processor ACPI_CPU:14: registered as cooling_device16
tick-broadcast: ignoring broadcast for offline CPU #17
ACPI: CPU17 (power states: C1[C1] C2[C3] C3[C3])
processor ACPI_CPU:15: registered as cooling_device17
ACPI: CPU3 (power states: C1[C1] C2[C3] C3[C3])
processor ACPI_CPU:18: registered as cooling_device18
tick-broadcast: ignoring broadcast for offline CPU #15
ACPI: CPU15 (power states: C1[C1] C2[C3] C3[C3])
processor ACPI_CPU:19: registered as cooling_device19
ACPI: CPU11 (power states: C1[C1] C2[C3] C3[C3])
processor ACPI_CPU:1a: registered as cooling_device20
tick-broadcast: ignoring broadcast for offline CPU #23
ACPI: CPU23 (power states: C1[C1] C2[C3] C3[C3])
processor ACPI_CPU:1b: registered as cooling_device21
ACPI: CPU7 (power states: C1[C1] C2[C3] C3[C3])
processor ACPI_CPU:1c: registered as cooling_device22
tick-broadcast: ignoring broadcast for offline CPU #19
ACPI: CPU19 (power states: C1[C1] C2[C3] C3[C3])
processor ACPI_CPU:1d: registered as cooling_device23
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THM0] (8 C)
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
udevd version 128 started
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
sd 2:0:0:0: [sda] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sda] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sda:<6>ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
 sda1<6>ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
 sda2 sda3
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xcf8f0000
sd 2:0:0:0: [sda] Attached SCSI disk
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.27.39-0.3-perfctr ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00001000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.27.39-0.3-perfctr uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 23, io base 0x00001020
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.27.39-0.3-perfctr uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 22, io base 0x00001040
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.27.39-0.3-perfctr uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 23, io base 0x00001060
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.27.39-0.3-perfctr uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
vendor=8086 device=3a48
uhci_hcd 0000:02:00.4: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:02:00.4: setting latency timer to 64
uhci_hcd 0000:02:00.4: UHCI Host Controller
uhci_hcd 0000:02:00.4: new USB bus registered, assigned bus number 6
uhci_hcd 0000:02:00.4: port count misdetected? forcing to 2 ports
uhci_hcd 0000:02:00.4: irq 17, io base 0x00003c00
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.27.39-0.3-perfctr uhci_hcd
usb usb6: SerialNumber: 0000:02:00.4
md: linear personality registered for level -1
usb 6-1: new full speed USB device using uhci_hcd and address 2
usb 6-1: configuration #1 chosen from 1 choice
usb 6-1: New USB device found, idVendor=03f0, idProduct=7029
usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 6-1: Product: Virtual Keyboard 
usb 6-1: Manufacturer: HP 
usbcore: registered new interface driver hiddev
input: HP  Virtual Keyboard  as /devices/pci0000:00/0000:00:1c.4/0000:02:00.4/usb6/6-1/6-1:1.0/input/input0
input,hidraw0: USB HID v1.01 Keyboard [HP  Virtual Keyboard ] on usb-0000:02:00.4-1
input: HP  Virtual Keyboard  as /devices/pci0000:00/0000:00:1c.4/0000:02:00.4/usb6/6-1/6-1:1.1/input/input1
input,hidraw1: USB HID v1.01 Mouse [HP  Virtual Keyboard ] on usb-0000:02:00.4-1
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
PM: Starting manual resume from disk
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
udevd version 128 started
sd 2:0:0:0: Attached scsi generic sg0 type 0
vendor=8086 device=3a48
hpwdt 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
hpwdt: New timer passed in is 30 seconds.
hp Watchdog Timer Driver: 1.01, timer margin: 30 seconds (nowayout=0), allow kernel dump: OFF (default = 0/OFF).
Intel(R) Gigabit Ethernet Network Driver - version 1.2.45-k2
Copyright (c) 2008 Intel Corporation.
vendor=8086 device=3408
igb 0000:04:00.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
igb 0000:04:00.0: setting latency timer to 64
input: PC Speaker as /devices/platform/pcspkr/input/input2
igb 0000:04:00.0: Intel(R) Gigabit Ethernet Network Connection
igb 0000:04:00.0: eth0: (PCIe:2.5Gb/s:Width x4) 78:e7:d1:24:a7:c8
igb 0000:04:00.0: eth0: PBA No: ffffff-0ff
igb 0000:04:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
vendor=8086 device=3408
igb 0000:04:00.1: PCI INT B -> GSI 40 (level, low) -> IRQ 40
igb 0000:04:00.1: setting latency timer to 64
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
rtc_cmos 00:0a: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k, hpet irqs
ACPI: Power Button (FF) [PWRF]
igb 0000:04:00.1: Intel(R) Gigabit Ethernet Network Connection
igb 0000:04:00.1: eth1: (PCIe:2.5Gb/s:Width x4) 78:e7:d1:24:a7:c9
igb 0000:04:00.1: eth1: PBA No: ffffff-0ff
igb 0000:04:00.1: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
vendor=8086 device=3a48
hpilo 0000:02:00.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
hpilo 0000:02:00.2: setting latency timer to 64
nvidia: module license 'NVIDIA' taints kernel.
vendor=8086 device=340e
nvidia 0000:06:00.0: PCI INT A -> GSI 30 (level, low) -> IRQ 30
nvidia 0000:06:00.0: setting latency timer to 64
vendor=8086 device=340a
nvidia 0000:14:00.0: PCI INT A -> GSI 48 (level, low) -> IRQ 48
nvidia 0000:14:00.0: setting latency timer to 64
vendor=8086 device=340e
nvidia 0000:11:00.0: PCI INT A -> GSI 54 (level, low) -> IRQ 54
nvidia 0000:11:00.0: setting latency timer to 64
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  295.41  Fri Apr  6 23:18:58 PDT 2012
Adding 24579440k swap on /dev/sda2.  Priority:-1 extents:1 across:24579440k
loop: module loaded
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
fuse init (API version 7.9)
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
firmware: requesting intel-ucode/06-2c-02
firmware: requesting intel-ucode/06-2c-02
firmware: requesting intel-ucode/06-2c-02
firmware: requesting intel-ucode/06-2c-02
firmware: requesting intel-ucode/06-2c-02
firmware: requesting intel-ucode/06-2c-02
firmware: requesting intel-ucode/06-2c-02
firmware: requesting intel-ucode/06-2c-02
firmware: requesting intel-ucode/06-2c-02
firmware: requesting intel-ucode/06-2c-02
firmware: requesting intel-ucode/06-2c-02
firmware: requesting intel-ucode/06-2c-02
CE: hpet increasing min_delta_ns to 15000 nsec
mlx4_core: Mellanox ConnectX core driver v1.0-ofed1.5.2 (August 4, 2010)
mlx4_core: Initializing 0000:05:00.0
vendor=8086 device=340c
mlx4_core 0000:05:00.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
mlx4_core 0000:05:00.0: setting latency timer to 64
mlx4_en: Mellanox ConnectX HCA Ethernet driver v1.5.2 (July 2010)
mlx4_en 0000:05:00.0: Using 5 tx rings for port:2
mlx4_en 0000:05:00.0: Defaulting to 16 rx rings for port:2
mlx4_en 0000:05:00.0: Activating port:2
mlx4_en: 0000:05:00.0: Port 2: Using 5 TX rings
mlx4_en: 0000:05:00.0: Port 2: Using 16 RX rings
mlx4_ib: Mellanox ConnectX InfiniBand driver v1.0-ofed1.5.2 (August 4, 2010)
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): ib0: link is not ready
ib0: enabling connected mode will cause multicast packet drops
ib0: mtu > 2044 will cause multicast packet drops.
ib0: mtu > 2044 will cause multicast packet drops.
igb 0000:04:00.0: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
ADDRCONF(NETDEV_UP): eth0: link is not ready
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
ipmi message handler version 39.2
IPMI System Interface driver.
ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca2, slave address 0x20, irq 0
ipmi: Found new BMC (man_id: 0x00000b,  prod_id: 0x2020, dev_id: 0x13)
IPMI kcs interface initialized
ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
ipmi_si: duplicate interface
ipmi device interface
PAX: PMU arbitration service v1.0.1 has been started.
eth0: no IPv6 routers present
sep3_4: PMU collection driver v3.4.2 has been loaded.
sep3_4: IDT vector 0x40 will be used for handling PMU interrupts.
ADDRCONF(NETDEV_CHANGE): ib0: link becomes ready
Lustre: OBD class driver, http://www.lustre.org/
Lustre:     Lustre Version: 1.8.5
Lustre:     Build Version: 1.8.5-20101117043234-PRISTINE-2.6.27.39-0.3-perfctr
Lustre: Listener bound to ib0:10.149.2.1:987:mlx4_0
Lustre: Register global MR array, MR size: 0xffffffffffffffff, array size: 1
Lustre: Added LNI 10.149.2.1@o2ib [8/64/0/180]
Lustre: Lustre Client File System; http://www.lustre.org/
Lustre: MGC10.149.245.1@o2ib: Reactivating import
Lustre: Client lustre-client has started
ib0: no IPv6 routers present
CE: hpet increasing min_delta_ns to 22500 nsec
simple[10305]: segfault at 108 ip 000000000048bdb6 sp 00007fffd40f8080 error 6 in simple[400000+1aa000]
simple[3774]: segfault at 98 ip 00007ffff73dde7b sp 00007fffd5ef8050 error 4 in libstarpu-1.0.so.1.0.0[7ffff73c5000+76000]
simple[3804]: segfault at 98 ip 00007ffff73dde7b sp 00007fffd62f8050 error 4 in libstarpu-1.0.so.1.0.0[7ffff73c5000+76000]
simple[28916]: segfault at 4b2d54 ip 00000000004848ee sp 00007fffffffc040 error 7 in simple[400000+19e000]
imme3_g[7508]: segfault at 0 ip 000000000040a2e8 sp 00007fffffffc540 error 4 in imme3[400000+59000]
LustreError: 11-0: an error occurred while communicating with 10.149.245.3@o2ib. The obd_ping operation failed with -107
Lustre: lustre-OST0000-osc-ffff880951d67000: Connection to service lustre-OST0000 via nid 10.149.245.3@o2ib was lost; in progress operations using this service will wait for recovery to complete.
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 2s
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 3s
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 4s
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 5s
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 6s
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 7s
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 8s
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 9s
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 11s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 1 previous similar message
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 13s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 1 previous similar message
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 17s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 3 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 23s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 5 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 25s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 8 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 17s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 17 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 25s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 10 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 10s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 14 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 24s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 13 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 25s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 9 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 19s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 17 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 25s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 10 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 13s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 16 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 25s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 12 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 5s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 11 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 22s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 16 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 25s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 9 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 17s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 17 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 25s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 10 previous similar messages
Lustre: lustre-OST0000-osc-ffff880951d67000: Connection restored to service lustre-OST0000 using nid 10.149.245.3@o2ib.
cg_DEBUG_GPU_GP[14954]: segfault at 28 ip 00007fffe961b58a sp 00007fffffffc5a0 error 4 in libpthread-2.9.so[7fffe9613000+16000]
cg_DEBUG_GPU_GP[15010]: segfault at 28 ip 00007fffe961b58a sp 00007fffffffc590 error 4 in libpthread-2.9.so[7fffe9613000+16000]
LustreError: 11-0: an error occurred while communicating with 10.149.245.3@o2ib. The obd_ping operation failed with -107
Lustre: lustre-OST0000-osc-ffff880951d67000: Connection to service lustre-OST0000 via nid 10.149.245.3@o2ib was lost; in progress operations using this service will wait for recovery to complete.
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 2s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 6 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 6s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 3 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 12s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 5 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 20s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 7 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 25s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 10 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 18s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 17 previous similar messages
LustreError: 11-0: an error occurred while communicating with 10.149.245.4@o2ib. The obd_ping operation failed with -107
Lustre: lustre-OST0001-osc-ffff880951d67000: Connection to service lustre-OST0001 via nid 10.149.245.4@o2ib was lost; in progress operations using this service will wait for recovery to complete.
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664427122 sent from lustre-OST0001-osc-ffff880951d67000 to NID 10.149.245.3@o2ib 6s ago has timed out (6s prior to deadline).
  req@ffff8804c048ec00 x1403283664427122/t0 o8->lustre-OST0001_UUID@10.149.245.3@o2ib:28/4 lens 368/584 e 0 to 1 dl 1338967988 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5789:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664427111 sent from lustre-OST0004-osc-ffff880951d67000 to NID 10.149.245.3@o2ib 17s ago has timed out (17s prior to deadline).
  req@ffff8803ae4b7000 x1403283664427111/t0 o400->lustre-OST0004_UUID@10.149.245.3@o2ib:28/4 lens 192/384 e 0 to 1 dl 1338967992 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: lustre-OST0004-osc-ffff880951d67000: Connection to service lustre-OST0004 via nid 10.149.245.3@o2ib was lost; in progress operations using this service will wait for recovery to complete.
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664427124 sent from lustre-OST0004-osc-ffff880951d67000 to NID 10.149.245.3@o2ib 6s ago has timed out (6s prior to deadline).
  req@ffff8804bfc29000 x1403283664427124/t0 o8->lustre-OST0004_UUID@10.149.245.3@o2ib:28/4 lens 368/584 e 0 to 1 dl 1338967998 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 2 previous similar messages
LustreError: 11-0: an error occurred while communicating with 10.149.245.4@o2ib. The obd_ping operation failed with -107
Lustre: lustre-OST0005-osc-ffff880951d67000: Connection to service lustre-OST0005 via nid 10.149.245.4@o2ib was lost; in progress operations using this service will wait for recovery to complete.
Lustre: Skipped 2 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664427127 sent from lustre-OST0001-osc-ffff880951d67000 to NID 10.149.245.3@o2ib 7s ago has timed out (7s prior to deadline).
  req@ffff8804c0982800 x1403283664427127/t0 o8->lustre-OST0001_UUID@10.149.245.3@o2ib:28/4 lens 368/584 e 0 to 1 dl 1338968004 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 2 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664427144 sent from lustre-OST0004-osc-ffff880951d67000 to NID 10.149.245.3@o2ib 7s ago has timed out (7s prior to deadline).
  req@ffff8802fac83c00 x1403283664427144/t0 o8->lustre-OST0004_UUID@10.149.245.3@o2ib:28/4 lens 368/584 e 0 to 1 dl 1338968013 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664427151 sent from lustre-OST0004-osc-ffff880951d67000 to NID 10.149.245.4@o2ib 7s ago has timed out (7s prior to deadline).
  req@ffff8803747ed000 x1403283664427151/t0 o8->lustre-OST0004_UUID@10.149.245.4@o2ib:28/4 lens 368/584 e 0 to 1 dl 1338968021 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 4 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664427156 sent from lustre-OST0004-osc-ffff880951d67000 to NID 10.149.245.3@o2ib 8s ago has timed out (8s prior to deadline).
  req@ffff8804c046b800 x1403283664427156/t0 o8->lustre-OST0004_UUID@10.149.245.3@o2ib:28/4 lens 368/584 e 0 to 1 dl 1338968030 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 7 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664427177 sent from lustre-OST0005-osc-ffff880951d67000 to NID 10.149.245.3@o2ib 8s ago has timed out (8s prior to deadline).
  req@ffff8804bfd89c00 x1403283664427177/t0 o8->lustre-OST0005_UUID@10.149.245.3@o2ib:28/4 lens 368/584 e 0 to 1 dl 1338968047 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 10 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664427206 sent from lustre-OST0004-osc-ffff880951d67000 to NID 10.149.245.4@o2ib 10s ago has timed out (10s prior to deadline).
  req@ffff8804bfd89c00 x1403283664427206/t0 o8->lustre-OST0004_UUID@10.149.245.4@o2ib:28/4 lens 368/584 e 0 to 1 dl 1338968081 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 20 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664427265 sent from lustre-OST0005-osc-ffff880951d67000 to NID 10.149.245.4@o2ib 13s ago has timed out (13s prior to deadline).
  req@ffff8802fac83c00 x1403283664427265/t0 o8->lustre-OST0005_UUID@10.149.245.4@o2ib:28/4 lens 368/584 e 0 to 1 dl 1338968153 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 34 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0001-osc-ffff880951d67000: tried all connections, increasing latency to 12s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 70 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664427352 sent from lustre-OST0000-osc-ffff880951d67000 to NID 10.149.245.3@o2ib 30s ago has timed out (30s prior to deadline).
  req@ffff8804c048e000 x1403283664427352/t0 o8->lustre-OST0000_UUID@10.149.245.3@o2ib:28/4 lens 368/584 e 0 to 1 dl 1338968286 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 53 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664427527 sent from lustre-OST0004-osc-ffff880951d67000 to NID 10.149.245.4@o2ib 23s ago has timed out (23s prior to deadline).
  req@ffff8802888c7400 x1403283664427527/t0 o8->lustre-OST0004_UUID@10.149.245.4@o2ib:28/4 lens 368/584 e 0 to 1 dl 1338968549 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 80 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0001-osc-ffff880951d67000: tried all connections, increasing latency to 25s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 87 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664427812 sent from lustre-OST0004-osc-ffff880951d67000 to NID 10.149.245.4@o2ib 30s ago has timed out (30s prior to deadline).
  req@ffff880439381c00 x1403283664427812/t0 o8->lustre-OST0004_UUID@10.149.245.4@o2ib:28/4 lens 368/584 e 0 to 1 dl 1338969065 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 124 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0001-osc-ffff880951d67000: tried all connections, increasing latency to 25s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 69 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664428142 sent from lustre-OST0001-osc-ffff880951d67000 to NID 10.149.245.3@o2ib 30s ago has timed out (30s prior to deadline).
  req@ffff8804c09a5400 x1403283664428142/t0 o8->lustre-OST0001_UUID@10.149.245.3@o2ib:28/4 lens 368/584 e 0 to 1 dl 1338969668 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 137 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0001-osc-ffff880951d67000: tried all connections, increasing latency to 25s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 69 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664428468 sent from lustre-OST0000-osc-ffff880951d67000 to NID 10.149.245.3@o2ib 30s ago has timed out (30s prior to deadline).
  req@ffff8804bfd08000 x1403283664428468/t0 o8->lustre-OST0000_UUID@10.149.245.3@o2ib:28/4 lens 368/584 e 0 to 1 dl 1338970270 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 133 previous similar messages
LustreError: 11-0: an error occurred while communicating with 10.149.245.3@o2ib. The ost_connect operation failed with -16
LustreError: Skipped 1 previous similar message
LustreError: 11-0: an error occurred while communicating with 10.149.245.3@o2ib. The ost_connect operation failed with -16
LustreError: 11-0: an error occurred while communicating with 10.149.245.3@o2ib. The ost_connect operation failed with -16
LustreError: 11-0: an error occurred while communicating with 10.149.245.3@o2ib. The ost_connect operation failed with -16
LustreError: 11-0: an error occurred while communicating with 10.149.245.3@o2ib. The ost_connect operation failed with -16
LustreError: 11-0: an error occurred while communicating with 10.149.245.3@o2ib. The ost_connect operation failed with -16
LustreError: 11-0: an error occurred while communicating with 10.149.245.3@o2ib. The ost_connect operation failed with -16
LustreError: Skipped 1 previous similar message
LustreError: 11-0: an error occurred while communicating with 10.149.245.3@o2ib. The ost_connect operation failed with -16
LustreError: Skipped 1 previous similar message
Lustre: lustre-OST0005-osc-ffff880951d67000: Connection restored to service lustre-OST0005 using nid 10.149.245.4@o2ib.
Lustre: lustre-OST0001-osc-ffff880951d67000: Connection restored to service lustre-OST0001 using nid 10.149.245.4@o2ib.
Lustre: lustre-OST0009-osc-ffff880951d67000: Connection restored to service lustre-OST0009 using nid 10.149.245.4@o2ib.
LustreError: 11-0: an error occurred while communicating with 10.149.245.3@o2ib. The ost_connect operation failed with -16
LustreError: Skipped 4 previous similar messages
LustreError: 11-0: an error occurred while communicating with 10.149.245.3@o2ib. The ost_connect operation failed with -16
LustreError: Skipped 8 previous similar messages
LustreError: 167-0: This client was evicted by lustre-OST0000; in progress operations using this service will fail.
Lustre: lustre-OST0000-osc-ffff880951d67000: Connection restored to service lustre-OST0000 using nid 10.149.245.3@o2ib.
Lustre: lustre-OST0004-osc-ffff880951d67000: Connection restored to service lustre-OST0004 using nid 10.149.245.3@o2ib.
Lustre: lustre-OST000b-osc-ffff880951d67000: Connection restored to service lustre-OST000b using nid 10.149.245.3@o2ib.
Lustre: lustre-OST000c-osc-ffff880951d67000: Connection restored to service lustre-OST000c using nid 10.149.245.3@o2ib.
LustreError: 11-0: an error occurred while communicating with 10.149.245.3@o2ib. The obd_ping operation failed with -107
LustreError: Skipped 9 previous similar messages
Lustre: lustre-OST0000-osc-ffff880951d67000: Connection to service lustre-OST0000 via nid 10.149.245.3@o2ib was lost; in progress operations using this service will wait for recovery to complete.
Lustre: Skipped 1 previous similar message
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 2s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 64 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 6s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 3 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 12s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 5 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 20s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 7 previous similar messages
LustreError: 11-0: an error occurred while communicating with 10.149.245.3@o2ib. The ost_connect operation failed with -16
LustreError: 11-0: an error occurred while communicating with 10.149.245.3@o2ib. The ost_connect operation failed with -16
LustreError: 11-0: an error occurred while communicating with 10.149.245.3@o2ib. The ost_connect operation failed with -16
LustreError: 11-0: an error occurred while communicating with 10.149.245.3@o2ib. The ost_connect operation failed with -16
LustreError: 11-0: an error occurred while communicating with 10.149.245.3@o2ib. The ost_connect operation failed with -16
LustreError: 11-0: an error occurred while communicating with 10.149.245.3@o2ib. The ost_connect operation failed with -16
LustreError: Skipped 1 previous similar message
Lustre: lustre-OST0004-osc-ffff880951d67000: Connection to service lustre-OST0004 via nid 10.149.245.3@o2ib was lost; in progress operations using this service will wait for recovery to complete.
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664430056 sent from lustre-OST0004-osc-ffff880951d67000 to NID 10.149.245.3@o2ib 7s ago has timed out (7s prior to deadline).
  req@ffff8804bf59c000 x1403283664430056/t0 o8->lustre-OST0004_UUID@10.149.245.3@o2ib:28/4 lens 368/584 e 0 to 1 dl 1338972846 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 63 previous similar messages
LustreError: 11-0: an error occurred while communicating with 10.149.245.4@o2ib. The obd_ping operation failed with -107
LustreError: Skipped 2 previous similar messages
Lustre: lustre-OST0009-osc-ffff880951d67000: Connection to service lustre-OST0009 via nid 10.149.245.4@o2ib was lost; in progress operations using this service will wait for recovery to complete.
Lustre: lustre-OST000b-osc-ffff880951d67000: Connection to service lustre-OST000b via nid 10.149.245.3@o2ib was lost; in progress operations using this service will wait for recovery to complete.
Lustre: lustre-OST0001-osc-ffff880951d67000: Connection to service lustre-OST0001 via nid 10.149.245.4@o2ib was lost; in progress operations using this service will wait for recovery to complete.
Lustre: Skipped 1 previous similar message
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664430103 sent from lustre-OST0000-osc-ffff880951d67000 to NID 10.149.245.3@o2ib 28s ago has timed out (28s prior to deadline).
  req@ffff8804d1c7c800 x1403283664430103/t0 o8->lustre-OST0000_UUID@10.149.245.3@o2ib:28/4 lens 368/584 e 0 to 1 dl 1338972922 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 38 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664430233 sent from lustre-OST0000-osc-ffff880951d67000 to NID 10.149.245.4@o2ib 30s ago has timed out (30s prior to deadline).
  req@ffff8804d24a8000 x1403283664430233/t0 o8->lustre-OST0000_UUID@10.149.245.4@o2ib:28/4 lens 368/584 e 0 to 1 dl 1338973073 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 74 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0009-osc-ffff880951d67000: tried all connections, increasing latency to 12s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 65 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664430446 sent from lustre-OST000b-osc-ffff880951d67000 to NID 10.149.245.4@o2ib 22s ago has timed out (22s prior to deadline).
  req@ffff880239485400 x1403283664430446/t0 o8->lustre-OST000b_UUID@10.149.245.4@o2ib:28/4 lens 368/584 e 0 to 1 dl 1338973376 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 94 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0005-osc-ffff880951d67000: tried all connections, increasing latency to 24s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 85 previous similar messages
LustreError: 11-0: an error occurred while communicating with 10.149.245.3@o2ib. The ost_connect operation failed with -16
Lustre: lustre-OST0001-osc-ffff880951d67000: Connection restored to service lustre-OST0001 using nid 10.149.245.4@o2ib.
LustreError: 11-0: an error occurred while communicating with 10.149.245.3@o2ib. The ost_connect operation failed with -16
LustreError: Skipped 2 previous similar messages
Lustre: lustre-OST000b-osc-ffff880951d67000: Connection restored to service lustre-OST000b using nid 10.149.245.3@o2ib.
Lustre: Skipped 2 previous similar messages
Lustre: lustre-OST000c-osc-ffff880951d67000: Connection restored to service lustre-OST000c using nid 10.149.245.3@o2ib.
Lustre: lustre-OST0004-osc-ffff880951d67000: Connection restored to service lustre-OST0004 using nid 10.149.245.3@o2ib.
LustreError: 11-0: an error occurred while communicating with 10.149.245.3@o2ib. The ost_connect operation failed with -16
LustreError: Skipped 4 previous similar messages
LustreError: 11-0: an error occurred while communicating with 10.149.245.3@o2ib. The ost_connect operation failed with -16
LustreError: Skipped 8 previous similar messages
LustreError: 11-0: an error occurred while communicating with 10.149.245.3@o2ib. The ost_connect operation failed with -16
LustreError: Skipped 16 previous similar messages
LustreError: 11-0: an error occurred while communicating with 10.149.245.3@o2ib. The ost_connect operation failed with -16
LustreError: Skipped 32 previous similar messages
LustreError: 167-0: This client was evicted by lustre-OST0000; in progress operations using this service will fail.
Lustre: lustre-OST0000-osc-ffff880951d67000: Connection restored to service lustre-OST0000 using nid 10.149.245.3@o2ib.
LustreError: 11-0: an error occurred while communicating with 10.149.245.3@o2ib. The obd_ping operation failed with -107
LustreError: Skipped 17 previous similar messages
Lustre: lustre-OST0000-osc-ffff880951d67000: Connection to service lustre-OST0000 via nid 10.149.245.3@o2ib was lost; in progress operations using this service will wait for recovery to complete.
Lustre: Skipped 1 previous similar message
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 2s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 27 previous similar messages
Lustre: lustre-OST0003-osc-ffff880951d67000: Connection to service lustre-OST0003 via nid 10.149.245.6@o2ib was lost; in progress operations using this service will wait for recovery to complete.
Lustre: Skipped 2 previous similar messages
Lustre: lustre-OST0004-osc-ffff880951d67000: Connection to service lustre-OST0004 via nid 10.149.245.3@o2ib was lost; in progress operations using this service will wait for recovery to complete.
LustreError: 11-0: an error occurred while communicating with 10.149.245.6@o2ib. The obd_ping operation failed with -107
LustreError: Skipped 7 previous similar messages
Lustre: lustre-OST0008-osc-ffff880951d67000: Connection to service lustre-OST0008 via nid 10.149.245.6@o2ib was lost; in progress operations using this service will wait for recovery to complete.
Lustre: Skipped 3 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664433502 sent from lustre-OST0006-osc-ffff880951d67000 to NID 10.149.245.6@o2ib 8s ago has timed out (8s prior to deadline).
  req@ffff8803747ed400 x1403283664433502/t0 o8->lustre-OST0006_UUID@10.149.245.6@o2ib:28/4 lens 368/584 e 0 to 1 dl 1338978263 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 138 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 6s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 23 previous similar messages
Lustre: lustre-OST000b-osc-ffff880951d67000: Connection to service lustre-OST000b via nid 10.149.245.3@o2ib was lost; in progress operations using this service will wait for recovery to complete.
Lustre: lustre-OST0009-osc-ffff880951d67000: Connection to service lustre-OST0009 via nid 10.149.245.4@o2ib was lost; in progress operations using this service will wait for recovery to complete.
LustreError: 166-1: MGC10.149.245.1@o2ib: Connection to service MGS via nid 10.149.245.1@o2ib was lost; in progress operations using this service will fail.
Lustre: lustre-MDT0000-mdc-ffff880951d67000: Connection to service lustre-MDT0000 via nid 10.149.245.1@o2ib was lost; in progress operations using this service will wait for recovery to complete.
Lustre: Skipped 1 previous similar message
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664433589 sent from lustre-OST0003-osc-ffff880951d67000 to NID 10.149.245.5@o2ib 12s ago has timed out (12s prior to deadline).
  req@ffff8804c048e000 x1403283664433589/t0 o8->lustre-OST0003_UUID@10.149.245.5@o2ib:28/4 lens 368/584 e 0 to 1 dl 1338978339 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 79 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0008-osc-ffff880951d67000: tried all connections, increasing latency to 9s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 82 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664433774 sent from MGC10.149.245.1@o2ib to NID 10.149.245.1@o2ib 6s ago has timed out (6s prior to deadline).
  req@ffff8804c046b400 x1403283664433774/t0 o250->MGS@10.149.245.1@o2ib:26/25 lens 368/584 e 0 to 1 dl 1338978491 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 171 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 19s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 113 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664434031 sent from MGC10.149.245.1@o2ib to NID 10.149.245.1@o2ib 6s ago has timed out (6s prior to deadline).
  req@ffff8804bfca7000 x1403283664434031/t0 o250->MGS@10.149.245.1@o2ib:26/25 lens 368/584 e 0 to 1 dl 1338978799 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 247 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0003-osc-ffff880951d67000: tried all connections, increasing latency to 25s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 154 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664434409 sent from MGC10.149.245.1@o2ib to NID 10.149.245.1@o2ib 6s ago has timed out (6s prior to deadline).
  req@ffff8804d1c7c400 x1403283664434409/t0 o250->MGS@10.149.245.1@o2ib:26/25 lens 368/584 e 0 to 1 dl 1338979401 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 380 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0008-osc-ffff880951d67000: tried all connections, increasing latency to 25s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 136 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664434767 sent from MGC10.149.245.1@o2ib to NID 10.149.245.1@o2ib 6s ago has timed out (6s prior to deadline).
  req@ffff8804cd9c9c00 x1403283664434767/t0 o250->MGS@10.149.245.1@o2ib:26/25 lens 368/584 e 0 to 1 dl 1338980003 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 356 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 25s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 136 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664435110 sent from lustre-OST0009-osc-ffff880951d67000 to NID 10.149.245.3@o2ib 30s ago has timed out (30s prior to deadline).
  req@ffff8804bf4cd000 x1403283664435110/t0 o8->lustre-OST0009_UUID@10.149.245.3@o2ib:28/4 lens 368/584 e 0 to 1 dl 1338980605 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 358 previous similar messages
LustreError: 5788:0:(o2iblnd_cb.c:2894:kiblnd_check_txs()) Timed out tx: tx_queue, 9 seconds
LustreError: 5788:0:(o2iblnd_cb.c:2956:kiblnd_check_conns()) Timed out RDMA with 10.149.245.3@o2ib (71)
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0004-osc-ffff880951d67000: tried all connections, increasing latency to 25s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 133 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664435482 sent from MGC10.149.245.1@o2ib to NID 10.149.245.1@o2ib 6s ago has timed out (6s prior to deadline).
  req@ffff8804bfc29800 x1403283664435482/t0 o250->MGS@10.149.245.1@o2ib:26/25 lens 368/584 e 0 to 1 dl 1338981207 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 363 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST000b-osc-ffff880951d67000: tried all connections, increasing latency to 25s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 138 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664435826 sent from lustre-OST0006-osc-ffff880951d67000 to NID 10.149.245.6@o2ib 30s ago has timed out (30s prior to deadline).
  req@ffff8804d252cc00 x1403283664435826/t0 o8->lustre-OST0006_UUID@10.149.245.6@o2ib:28/4 lens 368/584 e 0 to 1 dl 1338981809 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 354 previous similar messages
Lustre: lustre-OST0002-osc-ffff880951d67000: Connection restored to service lustre-OST0002 using nid 10.149.245.5@o2ib.
Lustre: lustre-OST0007-osc-ffff880951d67000: Connection restored to service lustre-OST0007 using nid 10.149.245.5@o2ib.
Lustre: lustre-OST000a-osc-ffff880951d67000: Connection restored to service lustre-OST000a using nid 10.149.245.5@o2ib.
Lustre: lustre-OST0003-osc-ffff880951d67000: Connection restored to service lustre-OST0003 using nid 10.149.245.6@o2ib.
Lustre: lustre-OST0008-osc-ffff880951d67000: Connection restored to service lustre-OST0008 using nid 10.149.245.6@o2ib.
Lustre: Skipped 1 previous similar message
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST000b-osc-ffff880951d67000: tried all connections, increasing latency to 25s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 121 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664436195 sent from lustre-OST0000-osc-ffff880951d67000 to NID 10.149.245.3@o2ib 0s ago has failed due to network error (30s prior to deadline).
  req@ffff8804c24ef000 x1403283664436195/t0 o8->lustre-OST0000_UUID@10.149.245.3@o2ib:28/4 lens 368/584 e 0 to 1 dl 1338982441 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 282 previous similar messages
Lustre: 5790:0:(import.c:855:ptlrpc_connect_interpret()) MGS@10.149.245.1@o2ib changed server handle from 0x1648ce82be886073 to 0x6c263b0a145941e2
Lustre: MGC10.149.245.1@o2ib: Reactivating import
Lustre: MGC10.149.245.1@o2ib: Connection restored to service MGS using nid 10.149.245.1@o2ib.
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST000b-osc-ffff880951d67000: tried all connections, increasing latency to 25s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 71 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664436520 sent from lustre-OST000c-osc-ffff880951d67000 to NID 10.149.245.3@o2ib 30s ago has timed out (30s prior to deadline).
  req@ffff8804d2d78c00 x1403283664436520/t0 o8->lustre-OST000c_UUID@10.149.245.3@o2ib:28/4 lens 368/584 e 0 to 1 dl 1338983017 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 143 previous similar messages
Lustre: lustre-OST000b-osc-ffff880951d67000: Connection restored to service lustre-OST000b using nid 10.149.245.3@o2ib.
Lustre: Skipped 1 previous similar message
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 19s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 23 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 25s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 10 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 14s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 16 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 25s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 11 previous similar messages
Lustre: lustre-OST0000-osc-ffff880951d67000: Connection restored to service lustre-OST0000 using nid 10.149.245.3@o2ib.
Lustre: Skipped 5 previous similar messages
simple[12099]: segfault at 10 ip 00007fffee054687 sp 00007fffd610bf98 error 6 in libpthread-2.9.so[7fffee049000+16000]
CE: hpet increasing min_delta_ns to 33750 nsec
nrpe invoked oom-killer: gfp_mask=0x1200d2, order=0, oomkilladj=0
Pid: 26456, comm: nrpe Tainted: P          2.6.27.39-0.3-perfctr #1

Call Trace:
 [<ffffffff8020d9d9>] show_trace_log_lvl+0x41/0x58
 [<ffffffff8049741f>] dump_stack+0x69/0x6f
 [<ffffffff80284f66>] oom_kill_process+0x5c/0x210
 [<ffffffff802855d8>] out_of_memory+0x1cd/0x203
 [<ffffffff80288ba7>] __alloc_pages_internal+0x33a/0x442
 [<ffffffff80291cfa>] do_wp_page+0x2d8/0x5e0
 [<ffffffff80293bbf>] handle_mm_fault+0x30c/0x35c
 [<ffffffff8049b710>] do_page_fault+0x302/0x6f5
 [<ffffffff80499599>] error_exit+0x0/0x51
 [<00007ffff7ded3ee>] 0x7ffff7ded3ee

Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
CPU    4: hi:    0, btch:   1 usd:   0
CPU    5: hi:    0, btch:   1 usd:   0
CPU    6: hi:    0, btch:   1 usd:   0
CPU    7: hi:    0, btch:   1 usd:   0
CPU    8: hi:    0, btch:   1 usd:   0
CPU    9: hi:    0, btch:   1 usd:   0
CPU   10: hi:    0, btch:   1 usd:   0
CPU   11: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  56
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd: 183
CPU    3: hi:  186, btch:  31 usd:   0
CPU    4: hi:  186, btch:  31 usd:  52
CPU    5: hi:  186, btch:  31 usd:   0
CPU    6: hi:  186, btch:  31 usd:  14
CPU    7: hi:  186, btch:  31 usd:   0
CPU    8: hi:  186, btch:  31 usd: 157
CPU    9: hi:  186, btch:  31 usd:   0
CPU   10: hi:  186, btch:  31 usd: 119
CPU   11: hi:  186, btch:  31 usd:   0
Node 0 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  38
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd: 182
CPU    3: hi:  186, btch:  31 usd:   0
CPU    4: hi:  186, btch:  31 usd: 165
CPU    5: hi:  186, btch:  31 usd:   0
CPU    6: hi:  186, btch:  31 usd:  85
CPU    7: hi:  186, btch:  31 usd:   0
CPU    8: hi:  186, btch:  31 usd: 183
CPU    9: hi:  186, btch:  31 usd:   0
CPU   10: hi:  186, btch:  31 usd: 177
CPU   11: hi:  186, btch:  31 usd:   0
Node 1 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  97
CPU    1: hi:  186, btch:  31 usd: 185
CPU    2: hi:  186, btch:  31 usd:  76
CPU    3: hi:  186, btch:  31 usd: 170
CPU    4: hi:  186, btch:  31 usd:   9
CPU    5: hi:  186, btch:  31 usd: 112
CPU    6: hi:  186, btch:  31 usd: 157
CPU    7: hi:  186, btch:  31 usd: 147
CPU    8: hi:  186, btch:  31 usd:  72
CPU    9: hi:  186, btch:  31 usd: 135
CPU   10: hi:  186, btch:  31 usd:  41
CPU   11: hi:  186, btch:  31 usd: 178
Active:4481536 inactive:4602835 dirty:0 writeback:0 unstable:0
 free:22835 slab:19644 mapped:12164 pagetables:35985 bounce:0
Node 0 DMA free:6024kB min:0kB low:0kB high:0kB active:0kB inactive:0kB present:4672kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2598 18096 18096
Node 0 DMA32 free:63564kB min:1744kB low:2180kB high:2616kB active:1166752kB inactive:1119604kB present:2660800kB pages_scanned:4021784 all_unreclaimable? yes
lowmem_reserve[]: 0 0 15498 15498
Node 0 Normal free:9824kB min:10416kB low:13020kB high:15624kB active:7860580kB inactive:7832100kB present:15869952kB pages_scanned:24209938 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
Node 1 Normal free:11928kB min:12196kB low:15244kB high:18292kB active:8898812kB inactive:9459636kB present:18579452kB pages_scanned:65621772 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 6*4kB 4*8kB 3*16kB 3*32kB 3*64kB 2*128kB 1*256kB 2*512kB 2*1024kB 1*2048kB 0*4096kB = 6024kB
Node 0 DMA32: 85*4kB 57*8kB 65*16kB 31*32kB 15*64kB 9*128kB 3*256kB 7*512kB 3*1024kB 3*2048kB 11*4096kB = 63564kB
Node 0 Normal: 26*4kB 1*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 2*4096kB = 9824kB
Node 1 Normal: 186*4kB 2*8kB 2*16kB 2*32kB 3*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 1*2048kB 2*4096kB = 11928kB
5306 total pagecache pages
3811 pages in swap cache
Swap cache stats: add 62244301, delete 62240490, find 17396914/20253024
Free swap  = 0kB
Total swap = 24579440kB
9437183 pages RAM
180942 pages reserved
16657 pages shared
9212935 pages non-shared
Out of memory: kill process 24820 (launch_tests.sh) score 252625355 or a child
Killed process 26001 (simple)
simple invoked oom-killer: gfp_mask=0x1200d2, order=0, oomkilladj=0
Pid: 26070, comm: simple Tainted: P          2.6.27.39-0.3-perfctr #1

Call Trace:
 [<ffffffff8020d9d9>] show_trace_log_lvl+0x41/0x58
 [<ffffffff8049741f>] dump_stack+0x69/0x6f
 [<ffffffff80284f66>] oom_kill_process+0x5c/0x210
 [<ffffffff802855d8>] out_of_memory+0x1cd/0x203
 [<ffffffff80288ba7>] __alloc_pages_internal+0x33a/0x442
 [<ffffffff8029d7ae>] read_swap_cache_async+0x58/0xcb
 [<ffffffff8029d878>] swapin_readahead+0x57/0x98
 [<ffffffff802920b3>] do_swap_page+0xb1/0x38c
 [<ffffffff80293b5f>] handle_mm_fault+0x2ac/0x35c
 [<ffffffff8049b710>] do_page_fault+0x302/0x6f5
 [<ffffffff80499599>] error_exit+0x0/0x51
 [<ffffffff8035f46c>] __get_user_8+0x1c/0x23
 [<ffffffff8025b116>] exit_robust_list+0x2d/0x110
 [<ffffffff802408be>] do_exit+0x1c7/0x325
 [<ffffffff80240a83>] do_group_exit+0x67/0x94
 [<ffffffff80249654>] get_signal_to_deliver+0x2f4/0x314
 [<ffffffff8020b8fb>] do_signal+0x62/0x171
 [<ffffffff8020ba2c>] do_notify_resume+0x22/0x43
 [<ffffffff8020c2d7>] ptregscall_common+0x67/0xb0
 [<ffffffff8020bff2>] sysret_signal+0x1a/0x25
 [<00007fffee053d59>] 0x7fffee053d59

Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
CPU    4: hi:    0, btch:   1 usd:   0
CPU    5: hi:    0, btch:   1 usd:   0
CPU    6: hi:    0, btch:   1 usd:   0
CPU    7: hi:    0, btch:   1 usd:   0
CPU    8: hi:    0, btch:   1 usd:   0
CPU    9: hi:    0, btch:   1 usd:   0
CPU   10: hi:    0, btch:   1 usd:   0
CPU   11: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  56
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd: 183
CPU    3: hi:  186, btch:  31 usd:   0
CPU    4: hi:  186, btch:  31 usd:  52
CPU    5: hi:  186, btch:  31 usd:   0
CPU    6: hi:  186, btch:  31 usd:  14
CPU    7: hi:  186, btch:  31 usd:   0
CPU    8: hi:  186, btch:  31 usd: 157
CPU    9: hi:  186, btch:  31 usd:   0
CPU   10: hi:  186, btch:  31 usd: 119
CPU   11: hi:  186, btch:  31 usd:   0
Node 0 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  38
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd: 182
CPU    3: hi:  186, btch:  31 usd:   0
CPU    4: hi:  186, btch:  31 usd: 165
CPU    5: hi:  186, btch:  31 usd:   0
CPU    6: hi:  186, btch:  31 usd:  85
CPU    7: hi:  186, btch:  31 usd:   0
CPU    8: hi:  186, btch:  31 usd: 183
CPU    9: hi:  186, btch:  31 usd:   0
CPU   10: hi:  186, btch:  31 usd: 177
CPU   11: hi:  186, btch:  31 usd:   0
Node 1 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  97
CPU    1: hi:  186, btch:  31 usd: 185
CPU    2: hi:  186, btch:  31 usd:  76
CPU    3: hi:  186, btch:  31 usd: 170
CPU    4: hi:  186, btch:  31 usd:   9
CPU    5: hi:  186, btch:  31 usd: 112
CPU    6: hi:  186, btch:  31 usd: 157
CPU    7: hi:  186, btch:  31 usd: 147
CPU    8: hi:  186, btch:  31 usd:  72
CPU    9: hi:  186, btch:  31 usd: 135
CPU   10: hi:  186, btch:  31 usd:  41
CPU   11: hi:  186, btch:  31 usd: 178
Active:4490206 inactive:4594330 dirty:0 writeback:0 unstable:0
 free:22835 slab:19644 mapped:12164 pagetables:35985 bounce:0
Node 0 DMA free:6024kB min:0kB low:0kB high:0kB active:0kB inactive:0kB present:4672kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2598 18096 18096
Node 0 DMA32 free:63564kB min:1744kB low:2180kB high:2616kB active:1172956kB inactive:1113652kB present:2660800kB pages_scanned:4032200 all_unreclaimable? yes
lowmem_reserve[]: 0 0 15498 15498
Node 0 Normal free:9824kB min:10416kB low:13020kB high:15624kB active:7862524kB inactive:7830176kB present:15869952kB pages_scanned:24269458 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
Node 1 Normal free:11928kB min:12196kB low:15244kB high:18292kB active:8925344kB inactive:9433492kB present:18579452kB pages_scanned:66350071 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 6*4kB 4*8kB 3*16kB 3*32kB 3*64kB 2*128kB 1*256kB 2*512kB 2*1024kB 1*2048kB 0*4096kB = 6024kB
Node 0 DMA32: 85*4kB 57*8kB 65*16kB 31*32kB 15*64kB 9*128kB 3*256kB 7*512kB 3*1024kB 3*2048kB 11*4096kB = 63564kB
Node 0 Normal: 26*4kB 1*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 2*4096kB = 9824kB
Node 1 Normal: 186*4kB 2*8kB 2*16kB 2*32kB 3*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 1*2048kB 2*4096kB = 11928kB
5306 total pagecache pages
3811 pages in swap cache
Swap cache stats: add 62244301, delete 62240490, find 17396914/20253026
Free swap  = 0kB
Total swap = 24579440kB
9437183 pages RAM
180942 pages reserved
16642 pages shared
9212949 pages non-shared
irqbalance invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0
Pid: 4747, comm: irqbalance Tainted: P          2.6.27.39-0.3-perfctr #1

Call Trace:
 [<ffffffff8020d9d9>] show_trace_log_lvl+0x41/0x58
 [<ffffffff8049741f>] dump_stack+0x69/0x6f
 [<ffffffff80284f66>] oom_kill_process+0x5c/0x210
 [<ffffffff802855d8>] out_of_memory+0x1cd/0x203
 [<ffffffff80288ba7>] __alloc_pages_internal+0x33a/0x442
 [<ffffffff8028a6c8>] __do_page_cache_readahead+0x9b/0x1a4
 [<ffffffff80283343>] filemap_fault+0x162/0x324
 [<ffffffff8029167c>] __do_fault+0x54/0x3fa
 [<ffffffff80293b3b>] handle_mm_fault+0x288/0x35c
 [<ffffffff8049b710>] do_page_fault+0x302/0x6f5
 [<ffffffff80499599>] error_exit+0x0/0x51
 [<00007ffff7b6d730>] 0x7ffff7b6d730

Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
CPU    4: hi:    0, btch:   1 usd:   0
CPU    5: hi:    0, btch:   1 usd:   0
CPU    6: hi:    0, btch:   1 usd:   0
CPU    7: hi:    0, btch:   1 usd:   0
CPU    8: hi:    0, btch:   1 usd:   0
CPU    9: hi:    0, btch:   1 usd:   0
CPU   10: hi:    0, btch:   1 usd:   0
CPU   11: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  56
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd: 183
CPU    3: hi:  186, btch:  31 usd:   0
CPU    4: hi:  186, btch:  31 usd:  52
CPU    5: hi:  186, btch:  31 usd:   0
CPU    6: hi:  186, btch:  31 usd:  17
CPU    7: hi:  186, btch:  31 usd:   0
CPU    8: hi:  186, btch:  31 usd: 157
CPU    9: hi:  186, btch:  31 usd:   0
CPU   10: hi:  186, btch:  31 usd: 119
CPU   11: hi:  186, btch:  31 usd:   0
Node 0 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  67
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd: 182
CPU    3: hi:  186, btch:  31 usd:   0
CPU    4: hi:  186, btch:  31 usd: 180
CPU    5: hi:  186, btch:  31 usd:   0
CPU    6: hi:  186, btch:  31 usd:  84
CPU    7: hi:  186, btch:  31 usd:   0
CPU    8: hi:  186, btch:  31 usd: 158
CPU    9: hi:  186, btch:  31 usd:   0
CPU   10: hi:  186, btch:  31 usd: 177
CPU   11: hi:  186, btch:  31 usd:   0
Node 1 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  66
CPU    1: hi:  186, btch:  31 usd: 185
CPU    2: hi:  186, btch:  31 usd:  76
CPU    3: hi:  186, btch:  31 usd: 171
CPU    4: hi:  186, btch:  31 usd:  12
CPU    5: hi:  186, btch:  31 usd: 122
CPU    6: hi:  186, btch:  31 usd: 158
CPU    7: hi:  186, btch:  31 usd: 144
CPU    8: hi:  186, btch:  31 usd:  72
CPU    9: hi:  186, btch:  31 usd: 136
CPU   10: hi:  186, btch:  31 usd:  41
CPU   11: hi:  186, btch:  31 usd: 182
Active:4597916 inactive:4486330 dirty:0 writeback:0 unstable:0
 free:22855 slab:19639 mapped:12151 pagetables:35985 bounce:0
Node 0 DMA free:6024kB min:0kB low:0kB high:0kB active:0kB inactive:0kB present:4672kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2598 18096 18096
Node 0 DMA32 free:63564kB min:1744kB low:2180kB high:2616kB active:1174816kB inactive:1111540kB present:2660800kB pages_scanned:4035728 all_unreclaimable? yes
lowmem_reserve[]: 0 0 15498 15498
Node 0 Normal free:9732kB min:10416kB low:13020kB high:15624kB active:7850160kB inactive:7842492kB present:15869952kB pages_scanned:25548821 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
Node 1 Normal free:12100kB min:12196kB low:15244kB high:18292kB active:9366688kB inactive:8991288kB present:18579452kB pages_scanned:54833323 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 6*4kB 4*8kB 3*16kB 3*32kB 3*64kB 2*128kB 1*256kB 2*512kB 2*1024kB 1*2048kB 0*4096kB = 6024kB
Node 0 DMA32: 85*4kB 57*8kB 65*16kB 31*32kB 15*64kB 9*128kB 3*256kB 7*512kB 3*1024kB 3*2048kB 11*4096kB = 63564kB
Node 0 Normal: 3*4kB 1*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 2*4096kB = 9732kB
Node 1 Normal: 217*4kB 4*8kB 2*16kB 3*32kB 3*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 1*2048kB 2*4096kB = 12100kB
5293 total pagecache pages
3811 pages in swap cache
Swap cache stats: add 62244310, delete 62240499, find 17396914/20253026
Free swap  = 0kB
Total swap = 24579440kB
9437183 pages RAM
180942 pages reserved
16708 pages shared
9212858 pages non-shared
Out of memory: kill process 24820 (launch_tests.sh) score 151576715 or a child
Killed process 26002 (tee)
sshd invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0
Pid: 5447, comm: sshd Tainted: P          2.6.27.39-0.3-perfctr #1

Call Trace:
 [<ffffffff8020d9d9>] show_trace_log_lvl+0x41/0x58
 [<ffffffff8049741f>] dump_stack+0x69/0x6f
 [<ffffffff80284f66>] oom_kill_process+0x5c/0x210
 [<ffffffff802855d8>] out_of_memory+0x1cd/0x203
 [<ffffffff80288ba7>] __alloc_pages_internal+0x33a/0x442
 [<ffffffff8028a6c8>] __do_page_cache_readahead+0x9b/0x1a4
 [<ffffffff80283343>] filemap_fault+0x162/0x324
 [<ffffffff8029167c>] __do_fault+0x54/0x3fa
 [<ffffffff80293b3b>] handle_mm_fault+0x288/0x35c
 [<ffffffff8049b710>] do_page_fault+0x302/0x6f5
 [<ffffffff80499599>] error_exit+0x0/0x51
 [<00007ffff7f9cd91>] 0x7ffff7f9cd91

Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
CPU    4: hi:    0, btch:   1 usd:   0
CPU    5: hi:    0, btch:   1 usd:   0
CPU    6: hi:    0, btch:   1 usd:   0
CPU    7: hi:    0, btch:   1 usd:   0
CPU    8: hi:    0, btch:   1 usd:   0
CPU    9: hi:    0, btch:   1 usd:   0
CPU   10: hi:    0, btch:   1 usd:   0
CPU   11: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  56
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd: 155
CPU    3: hi:  186, btch:  31 usd:   0
CPU    4: hi:  186, btch:  31 usd:  52
CPU    5: hi:  186, btch:  31 usd:   0
CPU    6: hi:  186, btch:  31 usd:  17
CPU    7: hi:  186, btch:  31 usd:   0
CPU    8: hi:  186, btch:  31 usd: 157
CPU    9: hi:  186, btch:  31 usd:   0
CPU   10: hi:  186, btch:  31 usd: 119
CPU   11: hi:  186, btch:  31 usd:   0
Node 0 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  65
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd: 185
CPU    3: hi:  186, btch:  31 usd:   0
CPU    4: hi:  186, btch:  31 usd: 171
CPU    5: hi:  186, btch:  31 usd:   0
CPU    6: hi:  186, btch:  31 usd:  80
CPU    7: hi:  186, btch:  31 usd:   0
CPU    8: hi:  186, btch:  31 usd: 158
CPU    9: hi:  186, btch:  31 usd:   0
CPU   10: hi:  186, btch:  31 usd: 177
CPU   11: hi:  186, btch:  31 usd:   0
Node 1 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  69
CPU    1: hi:  186, btch:  31 usd: 185
CPU    2: hi:  186, btch:  31 usd:  69
CPU    3: hi:  186, btch:  31 usd: 168
CPU    4: hi:  186, btch:  31 usd:  15
CPU    5: hi:  186, btch:  31 usd: 142
CPU    6: hi:  186, btch:  31 usd: 161
CPU    7: hi:  186, btch:  31 usd: 149
CPU    8: hi:  186, btch:  31 usd:  72
CPU    9: hi:  186, btch:  31 usd: 140
CPU   10: hi:  186, btch:  31 usd:  43
CPU   11: hi:  186, btch:  31 usd: 183
Active:4385229 inactive:4699051 dirty:0 writeback:0 unstable:0
 free:22901 slab:19644 mapped:12151 pagetables:35979 bounce:0
Node 0 DMA free:6024kB min:0kB low:0kB high:0kB active:0kB inactive:0kB present:4672kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2598 18096 18096
Node 0 DMA32 free:63688kB min:1744kB low:2180kB high:2616kB active:1144484kB inactive:1141872kB present:2660800kB pages_scanned:4663076 all_unreclaimable? yes
lowmem_reserve[]: 0 0 15498 15498
Node 0 Normal free:9792kB min:10416kB low:13020kB high:15624kB active:7845660kB inactive:7846992kB present:15869952kB pages_scanned:30105282 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
Node 1 Normal free:12100kB min:12196kB low:15244kB high:18292kB active:8550772kB inactive:9807340kB present:18579452kB pages_scanned:54491019 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 6*4kB 4*8kB 3*16kB 3*32kB 3*64kB 2*128kB 1*256kB 2*512kB 2*1024kB 1*2048kB 0*4096kB = 6024kB
Node 0 DMA32: 90*4kB 70*8kB 65*16kB 31*32kB 15*64kB 9*128kB 3*256kB 7*512kB 3*1024kB 3*2048kB 11*4096kB = 63688kB
Node 0 Normal: 14*4kB 3*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 2*4096kB = 9792kB
Node 1 Normal: 229*4kB 2*8kB 2*16kB 2*32kB 3*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 1*2048kB 2*4096kB = 12100kB
5293 total pagecache pages
3811 pages in swap cache
Swap cache stats: add 62244338, delete 62240527, find 17396914/20253027
Free swap  = 0kB
Total swap = 24579440kB
9437183 pages RAM
180942 pages reserved
16587 pages shared
9212828 pages non-shared
Out of memory: kill process 24820 (launch_tests.sh) score 134734640 or a child
Killed process 26051 (simple)
launch_tests.sh invoked oom-killer: gfp_mask=0x1200d2, order=0, oomkilladj=0
Pid: 24820, comm: launch_tests.sh Tainted: P          2.6.27.39-0.3-perfctr #1

Call Trace:
 [<ffffffff8020d9d9>] show_trace_log_lvl+0x41/0x58
 [<ffffffff8049741f>] dump_stack+0x69/0x6f
 [<ffffffff80284f66>] oom_kill_process+0x5c/0x210
 [<ffffffff802855d8>] out_of_memory+0x1cd/0x203
 [<ffffffff80288ba7>] __alloc_pages_internal+0x33a/0x442
 [<ffffffff8029d7ae>] read_swap_cache_async+0x58/0xcb
 [<ffffffff8029d878>] swapin_readahead+0x57/0x98
 [<ffffffff802920b3>] do_swap_page+0xb1/0x38c
 [<ffffffff80293b5f>] handle_mm_fault+0x2ac/0x35c
 [<ffffffff8049b710>] do_page_fault+0x302/0x6f5
 [<ffffffff80499599>] error_exit+0x0/0x51
 [<ffffffff8035f6dd>] __put_user_4+0x1d/0x30
 [<ffffffff8023fa8e>] wait_task_zombie+0x38f/0x4d0
 [<ffffffff8023fe66>] do_wait+0x137/0x386
 [<ffffffff80240142>] sys_wait4+0x8d/0xa4
 [<ffffffff8020bf6b>] system_call_fastpath+0x16/0x1b
 [<00007ffff763a5d5>] 0x7ffff763a5d5

Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
CPU    4: hi:    0, btch:   1 usd:   0
CPU    5: hi:    0, btch:   1 usd:   0
CPU    6: hi:    0, btch:   1 usd:   0
CPU    7: hi:    0, btch:   1 usd:   0
CPU    8: hi:    0, btch:   1 usd:   0
CPU    9: hi:    0, btch:   1 usd:   0
CPU   10: hi:    0, btch:   1 usd:   0
CPU   11: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  56
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd: 155
CPU    3: hi:  186, btch:  31 usd:   0
CPU    4: hi:  186, btch:  31 usd:  52
CPU    5: hi:  186, btch:  31 usd:   0
CPU    6: hi:  186, btch:  31 usd:  17
CPU    7: hi:  186, btch:  31 usd:   0
CPU    8: hi:  186, btch:  31 usd: 157
CPU    9: hi:  186, btch:  31 usd:   0
CPU   10: hi:  186, btch:  31 usd: 119
CPU   11: hi:  186, btch:  31 usd:   0
Node 0 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  45
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd: 185
CPU    3: hi:  186, btch:  31 usd:   0
CPU    4: hi:  186, btch:  31 usd: 171
CPU    5: hi:  186, btch:  31 usd:   0
CPU    6: hi:  186, btch:  31 usd:  80
CPU    7: hi:  186, btch:  31 usd:   0
CPU    8: hi:  186, btch:  31 usd: 158
CPU    9: hi:  186, btch:  31 usd:   0
CPU   10: hi:  186, btch:  31 usd: 177
CPU   11: hi:  186, btch:  31 usd:   0
Node 1 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  69
CPU    1: hi:  186, btch:  31 usd:  20
CPU    2: hi:  186, btch:  31 usd:  69
CPU    3: hi:  186, btch:  31 usd: 168
CPU    4: hi:  186, btch:  31 usd:  15
CPU    5: hi:  186, btch:  31 usd: 142
CPU    6: hi:  186, btch:  31 usd: 161
CPU    7: hi:  186, btch:  31 usd: 149
CPU    8: hi:  186, btch:  31 usd:  72
CPU    9: hi:  186, btch:  31 usd: 140
CPU   10: hi:  186, btch:  31 usd:  43
CPU   11: hi:  186, btch:  31 usd: 183
Active:4243936 inactive:4841137 dirty:0 writeback:0 unstable:0
 free:22828 slab:19647 mapped:12151 pagetables:35979 bounce:0
Node 0 DMA free:6024kB min:0kB low:0kB high:0kB active:0kB inactive:0kB present:4672kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2598 18096 18096
Node 0 DMA32 free:63688kB min:1744kB low:2180kB high:2616kB active:1223440kB inactive:1063408kB present:2660800kB pages_scanned:4808136 all_unreclaimable? yes
lowmem_reserve[]: 0 0 15498 15498
Node 0 Normal free:9792kB min:10416kB low:13020kB high:15624kB active:7848168kB inactive:7844484kB present:15869952kB pages_scanned:30929208 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
Node 1 Normal free:11808kB min:12196kB low:15244kB high:18292kB active:7904136kB inactive:10456656kB present:18579452kB pages_scanned:66421584 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 6*4kB 4*8kB 3*16kB 3*32kB 3*64kB 2*128kB 1*256kB 2*512kB 2*1024kB 1*2048kB 0*4096kB = 6024kB
Node 0 DMA32: 90*4kB 70*8kB 65*16kB 31*32kB 15*64kB 9*128kB 3*256kB 7*512kB 3*1024kB 3*2048kB 11*4096kB = 63688kB
Node 0 Normal: 14*4kB 3*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 2*4096kB = 9792kB
Node 1 Normal: 136*4kB 0*8kB 2*16kB 2*32kB 3*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 1*2048kB 2*4096kB = 11712kB
5511 total pagecache pages
3811 pages in swap cache
Swap cache stats: add 62244338, delete 62240527, find 17396914/20253027
Free swap  = 0kB
Total swap = 24579440kB
9437183 pages RAM
180942 pages reserved
16158 pages shared
9213543 pages non-shared
Out of memory: kill process 24820 (launch_tests.sh) score 117893200 or a child
Killed process 26052 (simple)
simple invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0
Pid: 26056, comm: simple Tainted: P          2.6.27.39-0.3-perfctr #1

Call Trace:
 [<ffffffff8020d9d9>] show_trace_log_lvl+0x41/0x58
 [<ffffffff8049741f>] dump_stack+0x69/0x6f
 [<ffffffff80284f66>] oom_kill_process+0x5c/0x210
 [<ffffffff802855d8>] out_of_memory+0x1cd/0x203
 [<ffffffff80288ba7>] __alloc_pages_internal+0x33a/0x442
 [<ffffffff8028a6c8>] __do_page_cache_readahead+0x9b/0x1a4
 [<ffffffff80283343>] filemap_fault+0x162/0x324
 [<ffffffff8029167c>] __do_fault+0x54/0x3fa
 [<ffffffff80293b3b>] handle_mm_fault+0x288/0x35c
 [<ffffffff8049b710>] do_page_fault+0x302/0x6f5
 [<ffffffff80499599>] error_exit+0x0/0x51
 [<00007ffff73ffa79>] 0x7ffff73ffa79

Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
CPU    4: hi:    0, btch:   1 usd:   0
CPU    5: hi:    0, btch:   1 usd:   0
CPU    6: hi:    0, btch:   1 usd:   0
CPU    7: hi:    0, btch:   1 usd:   0
CPU    8: hi:    0, btch:   1 usd:   0
CPU    9: hi:    0, btch:   1 usd:   0
CPU   10: hi:    0, btch:   1 usd:   0
CPU   11: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  56
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd: 155
CPU    3: hi:  186, btch:  31 usd:   0
CPU    4: hi:  186, btch:  31 usd:  52
CPU    5: hi:  186, btch:  31 usd:   0
CPU    6: hi:  186, btch:  31 usd:  17
CPU    7: hi:  186, btch:  31 usd:   0
CPU    8: hi:  186, btch:  31 usd: 157
CPU    9: hi:  186, btch:  31 usd:   0
CPU   10: hi:  186, btch:  31 usd: 119
CPU   11: hi:  186, btch:  31 usd:   0
Node 0 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd: 157
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd: 185
CPU    3: hi:  186, btch:  31 usd:   0
CPU    4: hi:  186, btch:  31 usd: 171
CPU    5: hi:  186, btch:  31 usd:   0
CPU    6: hi:  186, btch:  31 usd:  80
CPU    7: hi:  186, btch:  31 usd:   0
CPU    8: hi:  186, btch:  31 usd: 158
CPU    9: hi:  186, btch:  31 usd:   0
CPU   10: hi:  186, btch:  31 usd: 177
CPU   11: hi:  186, btch:  31 usd:   0
Node 1 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd: 139
CPU    1: hi:  186, btch:  31 usd:  20
CPU    2: hi:  186, btch:  31 usd:  69
CPU    3: hi:  186, btch:  31 usd: 168
CPU    4: hi:  186, btch:  31 usd:  15
CPU    5: hi:  186, btch:  31 usd: 142
CPU    6: hi:  186, btch:  31 usd: 161
CPU    7: hi:  186, btch:  31 usd: 149
CPU    8: hi:  186, btch:  31 usd:  72
CPU    9: hi:  186, btch:  31 usd: 140
CPU   10: hi:  186, btch:  31 usd:  43
CPU   11: hi:  186, btch:  31 usd: 183
Active:4200838 inactive:4884479 dirty:0 writeback:0 unstable:0
 free:22828 slab:19647 mapped:12151 pagetables:35979 bounce:0
Node 0 DMA free:6024kB min:0kB low:0kB high:0kB active:0kB inactive:0kB present:4672kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2598 18096 18096
Node 0 DMA32 free:63688kB min:1744kB low:2180kB high:2616kB active:1225656kB inactive:1061228kB present:2660800kB pages_scanned:4811559 all_unreclaimable? yes
lowmem_reserve[]: 0 0 15498 15498
Node 0 Normal free:9792kB min:10416kB low:13020kB high:15624kB active:7848172kB inactive:7844480kB present:15869952kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 1 Normal free:11808kB min:12196kB low:15244kB high:18292kB active:7729524kB inactive:10632208kB present:18579452kB pages_scanned:66976454 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 6*4kB 4*8kB 3*16kB 3*32kB 3*64kB 2*128kB 1*256kB 2*512kB 2*1024kB 1*2048kB 0*4096kB = 6024kB
Node 0 DMA32: 90*4kB 70*8kB 65*16kB 31*32kB 15*64kB 9*128kB 3*256kB 7*512kB 3*1024kB 3*2048kB 11*4096kB = 63688kB
Node 0 Normal: 28*4kB 0*8kB 1*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 2*4096kB = 9792kB
Node 1 Normal: 136*4kB 0*8kB 2*16kB 2*32kB 3*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 1*2048kB 2*4096kB = 11712kB
5511 total pagecache pages
3811 pages in swap cache
Swap cache stats: add 62244338, delete 62240527, find 17396914/20253027
Free swap  = 0kB
Total swap = 24579440kB
9437183 pages RAM
180942 pages reserved
16156 pages shared
9213356 pages non-shared
Out of memory: kill process 24820 (launch_tests.sh) score 101051760 or a child
Killed process 26054 (simple)
Lustre: 5789:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664448619 sent from lustre-MDT0000-mdc-ffff880951d67000 to NID 10.149.245.1@o2ib 17s ago has timed out (17s prior to deadline).
  req@ffff88045a0fd800 x1403283664448619/t0 o400->lustre-MDT0000_UUID@10.149.245.1@o2ib:12/10 lens 192/384 e 0 to 1 dl 1339003017 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5789:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 3 previous similar messages
Lustre: lustre-MDT0000-mdc-ffff880951d67000: Connection to service lustre-MDT0000 via nid 10.149.245.1@o2ib was lost; in progress operations using this service will wait for recovery to complete.
Lustre: Skipped 1 previous similar message
Lustre: lustre-MDT0000-mdc-ffff880951d67000: Connection restored to service lustre-MDT0000 using nid 10.149.245.1@o2ib.
nrpe invoked oom-killer: gfp_mask=0x84d0, order=0, oomkilladj=0
Pid: 26457, comm: nrpe Tainted: P          2.6.27.39-0.3-perfctr #1

Call Trace:
 [<ffffffff8020d9d9>] show_trace_log_lvl+0x41/0x58
 [<ffffffff8049741f>] dump_stack+0x69/0x6f
 [<ffffffff80284f66>] oom_kill_process+0x5c/0x210
 [<ffffffff802855d8>] out_of_memory+0x1cd/0x203
 [<ffffffff80288ba7>] __alloc_pages_internal+0x33a/0x442
 [<ffffffff80228ad0>] pte_alloc_one+0xd/0x31
 [<ffffffff8029383e>] __pte_alloc+0x12/0x87
 [<ffffffff802939e7>] handle_mm_fault+0x134/0x35c
 [<ffffffff8049b710>] do_page_fault+0x302/0x6f5
 [<ffffffff80499599>] error_exit+0x0/0x51
 [<00000000004050bd>] 0x4050bd

Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
CPU    4: hi:    0, btch:   1 usd:   0
CPU    5: hi:    0, btch:   1 usd:   0
CPU    6: hi:    0, btch:   1 usd:   0
CPU    7: hi:    0, btch:   1 usd:   0
CPU    8: hi:    0, btch:   1 usd:   0
CPU    9: hi:    0, btch:   1 usd:   0
CPU   10: hi:    0, btch:   1 usd:   0
CPU   11: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  57
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd: 155
CPU    3: hi:  186, btch:  31 usd:   0
CPU    4: hi:  186, btch:  31 usd:  52
CPU    5: hi:  186, btch:  31 usd:   0
CPU    6: hi:  186, btch:  31 usd:  17
CPU    7: hi:  186, btch:  31 usd:   0
CPU    8: hi:  186, btch:  31 usd: 159
CPU    9: hi:  186, btch:  31 usd:   0
CPU   10: hi:  186, btch:  31 usd: 119
CPU   11: hi:  186, btch:  31 usd:   0
Node 0 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd: 156
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd: 174
CPU    3: hi:  186, btch:  31 usd:   0
CPU    4: hi:  186, btch:  31 usd: 186
CPU    5: hi:  186, btch:  31 usd:   0
CPU    6: hi:  186, btch:  31 usd:  56
CPU    7: hi:  186, btch:  31 usd:   0
CPU    8: hi:  186, btch:  31 usd: 157
CPU    9: hi:  186, btch:  31 usd:   0
CPU   10: hi:  186, btch:  31 usd: 177
CPU   11: hi:  186, btch:  31 usd:   0
Node 1 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  71
CPU    1: hi:  186, btch:  31 usd: 119
CPU    2: hi:  186, btch:  31 usd:  53
CPU    3: hi:  186, btch:  31 usd: 120
CPU    4: hi:  186, btch:  31 usd:  69
CPU    5: hi:  186, btch:  31 usd: 111
CPU    6: hi:  186, btch:  31 usd: 164
CPU    7: hi:  186, btch:  31 usd: 171
CPU    8: hi:  186, btch:  31 usd:  60
CPU    9: hi:  186, btch:  31 usd: 137
CPU   10: hi:  186, btch:  31 usd:  78
CPU   11: hi:  186, btch:  31 usd: 174
Active:4347998 inactive:4736942 dirty:0 writeback:0 unstable:0
 free:22548 slab:19847 mapped:12158 pagetables:36040 bounce:0
Node 0 DMA free:6024kB min:0kB low:0kB high:0kB active:0kB inactive:0kB present:4672kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2598 18096 18096
Node 0 DMA32 free:63688kB min:1744kB low:2180kB high:2616kB active:1238084kB inactive:1048536kB present:2660800kB pages_scanned:5023155 all_unreclaimable? yes
lowmem_reserve[]: 0 0 15498 15498
Node 0 Normal free:8564kB min:10416kB low:13020kB high:15624kB active:7849332kB inactive:7844084kB present:15869952kB pages_scanned:25012928 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
Node 1 Normal free:11916kB min:12196kB low:15244kB high:18292kB active:8304576kB inactive:10055460kB present:18579452kB pages_scanned:61387098 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 6*4kB 4*8kB 3*16kB 3*32kB 3*64kB 2*128kB 1*256kB 2*512kB 2*1024kB 1*2048kB 0*4096kB = 6024kB
Node 0 DMA32: 90*4kB 70*8kB 65*16kB 31*32kB 15*64kB 9*128kB 3*256kB 7*512kB 3*1024kB 3*2048kB 11*4096kB = 63688kB
Node 0 Normal: 0*4kB 1*8kB 1*16kB 1*32kB 1*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 2*4096kB = 8440kB
Node 1 Normal: 197*4kB 1*8kB 1*16kB 1*32kB 3*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 1*2048kB 2*4096kB = 11916kB
5555 total pagecache pages
3812 pages in swap cache
Swap cache stats: add 62244743, delete 62240931, find 17397033/20253191
Free swap  = 0kB
Total swap = 24579440kB
9437183 pages RAM
180942 pages reserved
16628 pages shared
9213262 pages non-shared
Out of memory: kill process 24820 (launch_tests.sh) score 84210320 or a child
Killed process 26055 (simple)
Lustre: 5789:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664448653 sent from MGC10.149.245.1@o2ib to NID 10.149.245.1@o2ib 111s ago has timed out (17s prior to deadline).
  req@ffff8804bfd08000 x1403283664448653/t0 o400->MGS@10.149.245.1@o2ib:26/25 lens 192/384 e 0 to 1 dl 1339003042 ref 1 fl Rpc:N/0/0 rc 0/0
LustreError: 166-1: MGC10.149.245.1@o2ib: Connection to service MGS via nid 10.149.245.1@o2ib was lost; in progress operations using this service will fail.
Lustre: MGC10.149.245.1@o2ib: Reactivating import
Lustre: MGC10.149.245.1@o2ib: Connection restored to service MGS using nid 10.149.245.1@o2ib.
Lustre: 5789:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664449435 sent from lustre-OST0002-osc-ffff880951d67000 to NID 10.149.245.5@o2ib 17s ago has timed out (17s prior to deadline).
  req@ffff8804c24ef000 x1403283664449435/t0 o400->lustre-OST0002_UUID@10.149.245.5@o2ib:28/4 lens 192/384 e 0 to 1 dl 1339004317 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: lustre-OST0002-osc-ffff880951d67000: Connection to service lustre-OST0002 via nid 10.149.245.5@o2ib was lost; in progress operations using this service will wait for recovery to complete.
Lustre: lustre-OST0002-osc-ffff880951d67000: Connection restored to service lustre-OST0002 using nid 10.149.245.5@o2ib.
automount invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0
Pid: 4646, comm: automount Tainted: P          2.6.27.39-0.3-perfctr #1

Call Trace:
 [<ffffffff8020d9d9>] show_trace_log_lvl+0x41/0x58
 [<ffffffff8049741f>] dump_stack+0x69/0x6f
 [<ffffffff80284f66>] oom_kill_process+0x5c/0x210
 [<ffffffff802855d8>] out_of_memory+0x1cd/0x203
 [<ffffffff80288ba7>] __alloc_pages_internal+0x33a/0x442
 [<ffffffff8028a6c8>] __do_page_cache_readahead+0x9b/0x1a4
 [<ffffffff80283343>] filemap_fault+0x162/0x324
 [<ffffffff8029167c>] __do_fault+0x54/0x3fa
 [<ffffffff80293b3b>] handle_mm_fault+0x288/0x35c
 [<ffffffff8049b710>] do_page_fault+0x302/0x6f5
 [<ffffffff80499599>] error_exit+0x0/0x51
 [<00007ffff7fe1ec6>] 0x7ffff7fe1ec6

Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
CPU    4: hi:    0, btch:   1 usd:   0
CPU    5: hi:    0, btch:   1 usd:   0
CPU    6: hi:    0, btch:   1 usd:   0
CPU    7: hi:    0, btch:   1 usd:   0
CPU    8: hi:    0, btch:   1 usd:   0
CPU    9: hi:    0, btch:   1 usd:   0
CPU   10: hi:    0, btch:   1 usd:   0
CPU   11: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:   0
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd:   0
CPU    3: hi:  186, btch:  31 usd:   0
CPU    4: hi:  186, btch:  31 usd:  43
CPU    5: hi:  186, btch:  31 usd:   0
CPU    6: hi:  186, btch:  31 usd:   0
CPU    7: hi:  186, btch:  31 usd:   0
CPU    8: hi:  186, btch:  31 usd:   0
CPU    9: hi:  186, btch:  31 usd:   0
CPU   10: hi:  186, btch:  31 usd:  18
CPU   11: hi:  186, btch:  31 usd:   0
Node 0 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  79
CPU    1: hi:  186, btch:  31 usd:  21
CPU    2: hi:  186, btch:  31 usd:  68
CPU    3: hi:  186, btch:  31 usd:  39
CPU    4: hi:  186, btch:  31 usd: 159
CPU    5: hi:  186, btch:  31 usd:   0
CPU    6: hi:  186, btch:  31 usd: 119
CPU    7: hi:  186, btch:  31 usd:   2
CPU    8: hi:  186, btch:  31 usd:  66
CPU    9: hi:  186, btch:  31 usd:  89
CPU   10: hi:  186, btch:  31 usd: 163
CPU   11: hi:  186, btch:  31 usd: 134
Node 1 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  33
CPU    1: hi:  186, btch:  31 usd: 143
CPU    2: hi:  186, btch:  31 usd:  11
CPU    3: hi:  186, btch:  31 usd:  81
CPU    4: hi:  186, btch:  31 usd:   9
CPU    5: hi:  186, btch:  31 usd: 168
CPU    6: hi:  186, btch:  31 usd:   0
CPU    7: hi:  186, btch:  31 usd: 181
CPU    8: hi:  186, btch:  31 usd:   0
CPU    9: hi:  186, btch:  31 usd: 166
CPU   10: hi:  186, btch:  31 usd:   0
CPU   11: hi:  186, btch:  31 usd: 108
Active:1675521 inactive:1705798 dirty:0 writeback:0 unstable:0
 free:22959 slab:5748707 mapped:4980 pagetables:19683 bounce:0
Node 0 DMA free:6024kB min:0kB low:0kB high:0kB active:0kB inactive:0kB present:4672kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2598 18096 18096
Node 0 DMA32 free:63720kB min:1744kB low:2180kB high:2616kB active:2508kB inactive:2660kB present:2660800kB pages_scanned:8460 all_unreclaimable? yes
lowmem_reserve[]: 0 0 15498 15498
Node 0 Normal free:10044kB min:10416kB low:13020kB high:15624kB active:4520468kB inactive:4613736kB present:15869952kB pages_scanned:19959795 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
Node 1 Normal free:12048kB min:12196kB low:15244kB high:18292kB active:2179108kB inactive:2206796kB present:18579452kB pages_scanned:6764152 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 6*4kB 4*8kB 3*16kB 3*32kB 3*64kB 2*128kB 1*256kB 2*512kB 2*1024kB 1*2048kB 0*4096kB = 6024kB
Node 0 DMA32: 200*4kB 77*8kB 20*16kB 13*32kB 12*64kB 11*128kB 10*256kB 5*512kB 1*1024kB 22*2048kB 2*4096kB = 63720kB
Node 0 Normal: 151*4kB 0*8kB 0*16kB 1*32kB 1*64kB 1*128kB 0*256kB 0*512kB 1*1024kB 0*2048kB 2*4096kB = 10044kB
Node 1 Normal: 96*4kB 38*8kB 14*16kB 4*32kB 0*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 2*4096kB = 12048kB
2824 total pagecache pages
1279 pages in swap cache
Swap cache stats: add 68916178, delete 68914899, find 17404351/20270746
Free swap  = 0kB
Total swap = 24579440kB
9437183 pages RAM
173756 pages reserved
13600 pages shared
9223843 pages non-shared
Out of memory: kill process 24820 (launch_tests.sh) score 177533878 or a child
Killed process 26585 (simple)
hald invoked oom-killer: gfp_mask=0x1200d2, order=0, oomkilladj=0
Pid: 3132, comm: hald Tainted: P          2.6.27.39-0.3-perfctr #1

Call Trace:
 [<ffffffff8020d9d9>] show_trace_log_lvl+0x41/0x58
 [<ffffffff8049741f>] dump_stack+0x69/0x6f
 [<ffffffff80284f66>] oom_kill_process+0x5c/0x210
 [<ffffffff802855d8>] out_of_memory+0x1cd/0x203
 [<ffffffff80288ba7>] __alloc_pages_internal+0x33a/0x442
 [<ffffffff8029d7ae>] read_swap_cache_async+0x58/0xcb
 [<ffffffff8029d878>] swapin_readahead+0x57/0x98
 [<ffffffff802920b3>] do_swap_page+0xb1/0x38c
 [<ffffffff80293b5f>] handle_mm_fault+0x2ac/0x35c
 [<ffffffff8049b710>] do_page_fault+0x302/0x6f5
 [<ffffffff80499599>] error_exit+0x0/0x51
 [<00007ffff76e1a00>] 0x7ffff76e1a00

Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
CPU    4: hi:    0, btch:   1 usd:   0
CPU    5: hi:    0, btch:   1 usd:   0
CPU    6: hi:    0, btch:   1 usd:   0
CPU    7: hi:    0, btch:   1 usd:   0
CPU    8: hi:    0, btch:   1 usd:   0
CPU    9: hi:    0, btch:   1 usd:   0
CPU   10: hi:    0, btch:   1 usd:   0
CPU   11: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  37
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd:  33
CPU    3: hi:  186, btch:  31 usd:   0
CPU    4: hi:  186, btch:  31 usd:   0
CPU    5: hi:  186, btch:  31 usd:   0
CPU    6: hi:  186, btch:  31 usd:   3
CPU    7: hi:  186, btch:  31 usd:   0
CPU    8: hi:  186, btch:  31 usd:   0
CPU    9: hi:  186, btch:  31 usd:   0
CPU   10: hi:  186, btch:  31 usd:  18
CPU   11: hi:  186, btch:  31 usd:   0
Node 0 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd: 149
CPU    1: hi:  186, btch:  31 usd:  16
CPU    2: hi:  186, btch:  31 usd: 170
CPU    3: hi:  186, btch:  31 usd:  14
CPU    4: hi:  186, btch:  31 usd:  51
CPU    5: hi:  186, btch:  31 usd:  19
CPU    6: hi:  186, btch:  31 usd: 161
CPU    7: hi:  186, btch:  31 usd:  62
CPU    8: hi:  186, btch:  31 usd:  30
CPU    9: hi:  186, btch:  31 usd:  73
CPU   10: hi:  186, btch:  31 usd: 150
CPU   11: hi:  186, btch:  31 usd:   0
Node 1 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  95
CPU    1: hi:  186, btch:  31 usd: 184
CPU    2: hi:  186, btch:  31 usd:  44
CPU    3: hi:  186, btch:  31 usd: 169
CPU    4: hi:  186, btch:  31 usd:  75
CPU    5: hi:  186, btch:  31 usd: 181
CPU    6: hi:  186, btch:  31 usd:   7
CPU    7: hi:  186, btch:  31 usd: 185
CPU    8: hi:  186, btch:  31 usd:  60
CPU    9: hi:  186, btch:  31 usd: 142
CPU   10: hi:  186, btch:  31 usd: 110
CPU   11: hi:  186, btch:  31 usd:  95
Active:2070850 inactive:1307839 dirty:0 writeback:0 unstable:0
 free:22979 slab:5745814 mapped:8567 pagetables:19683 bounce:0
Node 0 DMA free:6024kB min:0kB low:0kB high:0kB active:0kB inactive:0kB present:4672kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2598 18096 18096
Node 0 DMA32 free:63504kB min:1744kB low:2180kB high:2616kB active:2396kB inactive:2744kB present:2660800kB pages_scanned:12165 all_unreclaimable? yes
lowmem_reserve[]: 0 0 15498 15498
Node 0 Normal free:10388kB min:10416kB low:13020kB high:15624kB active:5737028kB inactive:3396992kB present:15869952kB pages_scanned:1901628 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 1 Normal free:12000kB min:12196kB low:15244kB high:18292kB active:2543976kB inactive:1831620kB present:18579452kB pages_scanned:6468280 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 6*4kB 4*8kB 3*16kB 3*32kB 3*64kB 2*128kB 1*256kB 2*512kB 2*1024kB 1*2048kB 0*4096kB = 6024kB
Node 0 DMA32: 4*4kB 18*8kB 21*16kB 25*32kB 14*64kB 11*128kB 6*256kB 8*512kB 1*1024kB 22*2048kB 2*4096kB = 63504kB
Node 0 Normal: 74*4kB 39*8kB 12*16kB 2*32kB 1*64kB 0*128kB 3*256kB 1*512kB 0*1024kB 0*2048kB 2*4096kB = 10400kB
Node 1 Normal: 42*4kB 7*8kB 16*16kB 8*32kB 2*64kB 1*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 2*4096kB = 12000kB
4052 total pagecache pages
2558 pages in swap cache
Swap cache stats: add 75153153, delete 75150595, find 17408416/20283615
Free swap  = 0kB
Total swap = 24579440kB
9437183 pages RAM
177349 pages reserved
14885 pages shared
9218213 pages non-shared
Out of memory: kill process 24820 (launch_tests.sh) score 215660282 or a child
Killed process 26849 (simple)
Lustre: 5789:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664450187 sent from lustre-OST0002-osc-ffff880951d67000 to NID 10.149.245.5@o2ib 17s ago has timed out (17s prior to deadline).
  req@ffff8804c046b800 x1403283664450187/t0 o400->lustre-OST0002_UUID@10.149.245.5@o2ib:28/4 lens 192/384 e 0 to 1 dl 1339005567 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: lustre-OST0002-osc-ffff880951d67000: Connection to service lustre-OST0002 via nid 10.149.245.5@o2ib was lost; in progress operations using this service will wait for recovery to complete.
Lustre: lustre-OST0002-osc-ffff880951d67000: Connection restored to service lustre-OST0002 using nid 10.149.245.5@o2ib.
Lustre: 5789:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664450247 sent from lustre-OST0004-osc-ffff880951d67000 to NID 10.149.245.3@o2ib 17s ago has timed out (17s prior to deadline).
  req@ffff8804d00e6c00 x1403283664450247/t0 o400->lustre-OST0004_UUID@10.149.245.3@o2ib:28/4 lens 192/384 e 0 to 1 dl 1339005717 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: lustre-OST0004-osc-ffff880951d67000: Connection to service lustre-OST0004 via nid 10.149.245.3@o2ib was lost; in progress operations using this service will wait for recovery to complete.
Lustre: lustre-OST0004-osc-ffff880951d67000: Connection restored to service lustre-OST0004 using nid 10.149.245.3@o2ib.
ntpd invoked oom-killer: gfp_mask=0x1200d2, order=0, oomkilladj=0
Pid: 5363, comm: ntpd Tainted: P          2.6.27.39-0.3-perfctr #1

Call Trace:
 [<ffffffff8020d9d9>] show_trace_log_lvl+0x41/0x58
 [<ffffffff8049741f>] dump_stack+0x69/0x6f
 [<ffffffff80284f66>] oom_kill_process+0x5c/0x210
 [<ffffffff802855d8>] out_of_memory+0x1cd/0x203
 [<ffffffff80288ba7>] __alloc_pages_internal+0x33a/0x442
 [<ffffffff8029d7ae>] read_swap_cache_async+0x58/0xcb
 [<ffffffff8029d878>] swapin_readahead+0x57/0x98
 [<ffffffff802920b3>] do_swap_page+0xb1/0x38c
 [<ffffffff80293b5f>] handle_mm_fault+0x2ac/0x35c
 [<ffffffff8049b710>] do_page_fault+0x302/0x6f5
 [<ffffffff80499599>] error_exit+0x0/0x51
 [<00007ffff72f368e>] 0x7ffff72f368e

Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
CPU    4: hi:    0, btch:   1 usd:   0
CPU    5: hi:    0, btch:   1 usd:   0
CPU    6: hi:    0, btch:   1 usd:   0
CPU    7: hi:    0, btch:   1 usd:   0
CPU    8: hi:    0, btch:   1 usd:   0
CPU    9: hi:    0, btch:   1 usd:   0
CPU   10: hi:    0, btch:   1 usd:   0
CPU   11: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:   0
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd:   0
CPU    3: hi:  186, btch:  31 usd:   0
CPU    4: hi:  186, btch:  31 usd:   0
CPU    5: hi:  186, btch:  31 usd:   0
CPU    6: hi:  186, btch:  31 usd:  30
CPU    7: hi:  186, btch:  31 usd:   0
CPU    8: hi:  186, btch:  31 usd:   0
CPU    9: hi:  186, btch:  31 usd:   0
CPU   10: hi:  186, btch:  31 usd:  57
CPU   11: hi:  186, btch:  31 usd:   0
Node 0 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  77
CPU    1: hi:  186, btch:  31 usd:  34
CPU    2: hi:  186, btch:  31 usd:  44
CPU    3: hi:  186, btch:  31 usd:  14
CPU    4: hi:  186, btch:  31 usd: 158
CPU    5: hi:  186, btch:  31 usd:  30
CPU    6: hi:  186, btch:  31 usd: 100
CPU    7: hi:  186, btch:  31 usd:  46
CPU    8: hi:  186, btch:  31 usd: 178
CPU    9: hi:  186, btch:  31 usd: 166
CPU   10: hi:  186, btch:  31 usd: 170
CPU   11: hi:  186, btch:  31 usd:  17
Node 1 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:   5
CPU    1: hi:  186, btch:  31 usd: 164
CPU    2: hi:  186, btch:  31 usd:   0
CPU    3: hi:  186, btch:  31 usd: 126
CPU    4: hi:  186, btch:  31 usd:   6
CPU    5: hi:  186, btch:  31 usd:  58
CPU    6: hi:  186, btch:  31 usd:   2
CPU    7: hi:  186, btch:  31 usd:  67
CPU    8: hi:  186, btch:  31 usd:  23
CPU    9: hi:  186, btch:  31 usd:  92
CPU   10: hi:  186, btch:  31 usd:   0
CPU   11: hi:  186, btch:  31 usd: 185
Active:2155284 inactive:1224150 dirty:0 writeback:0 unstable:0
 free:22944 slab:5742513 mapped:12164 pagetables:19711 bounce:0
Node 0 DMA free:6024kB min:0kB low:0kB high:0kB active:0kB inactive:0kB present:4672kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2598 18096 18096
Node 0 DMA32 free:63584kB min:1744kB low:2180kB high:2616kB active:6596kB inactive:6000kB present:2660800kB pages_scanned:21902 all_unreclaimable? yes
lowmem_reserve[]: 0 0 15498 15498
Node 0 Normal free:10276kB min:10416kB low:13020kB high:15624kB active:6412080kB inactive:2697740kB present:15869952kB pages_scanned:25489599 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
Node 1 Normal free:11892kB min:12196kB low:15244kB high:18292kB active:2202460kB inactive:2192860kB present:18579452kB pages_scanned:8985005 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 6*4kB 4*8kB 3*16kB 3*32kB 3*64kB 2*128kB 1*256kB 2*512kB 2*1024kB 1*2048kB 0*4096kB = 6024kB
Node 0 DMA32: 206*4kB 85*8kB 30*16kB 21*32kB 18*64kB 9*128kB 9*256kB 6*512kB 4*1024kB 20*2048kB 2*4096kB = 63584kB
Node 0 Normal: 191*4kB 15*8kB 5*16kB 1*32kB 1*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 0*2048kB 2*4096kB = 10276kB
Node 1 Normal: 33*4kB 16*8kB 9*16kB 9*32kB 1*64kB 1*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 2*4096kB = 11892kB
5344 total pagecache pages
3839 pages in swap cache
Swap cache stats: add 81491479, delete 81487640, find 17414662/20300038
Free swap  = 0kB
Total swap = 24579440kB
9437183 pages RAM
180942 pages reserved
16171 pages shared
9214046 pages non-shared
Out of memory: kill process 24820 (launch_tests.sh) score 253806496 or a child
Killed process 27093 (simple)
Lustre: 5789:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664450985 sent from lustre-OST0005-osc-ffff880951d67000 to NID 10.149.245.4@o2ib 17s ago has timed out (17s prior to deadline).
  req@ffff8804c09a5400 x1403283664450985/t0 o400->lustre-OST0005_UUID@10.149.245.4@o2ib:28/4 lens 192/384 e 0 to 1 dl 1339006942 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: lustre-OST0005-osc-ffff880951d67000: Connection to service lustre-OST0005 via nid 10.149.245.4@o2ib was lost; in progress operations using this service will wait for recovery to complete.
Lustre: lustre-OST0006-osc-ffff880951d67000: Connection restored to service lustre-OST0006 using nid 10.149.245.6@o2ib.
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664450993 sent from lustre-OST0005-osc-ffff880951d67000 to NID 10.149.245.4@o2ib 6s ago has timed out (6s prior to deadline).
  req@ffff8804cd9c9400 x1403283664450993/t0 o8->lustre-OST0005_UUID@10.149.245.4@o2ib:28/4 lens 368/584 e 0 to 1 dl 1339006948 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 3 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0005-osc-ffff880951d67000: tried all connections, increasing latency to 2s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 4 previous similar messages
Lustre: lustre-OST0005-osc-ffff880951d67000: Connection restored to service lustre-OST0005 using nid 10.149.245.4@o2ib.
Lustre: Skipped 1 previous similar message
Lustre: 5789:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664451022 sent from lustre-OST0002-osc-ffff880951d67000 to NID 10.149.245.5@o2ib 17s ago has timed out (17s prior to deadline).
  req@ffff88010d5b2c00 x1403283664451022/t0 o400->lustre-OST0002_UUID@10.149.245.5@o2ib:28/4 lens 192/384 e 0 to 1 dl 1339006992 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5789:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 1 previous similar message
Lustre: lustre-OST0002-osc-ffff880951d67000: Connection to service lustre-OST0002 via nid 10.149.245.5@o2ib was lost; in progress operations using this service will wait for recovery to complete.
Lustre: Skipped 3 previous similar messages
Lustre: lustre-OST0002-osc-ffff880951d67000: Connection restored to service lustre-OST0002 using nid 10.149.245.5@o2ib.
Lustre: Skipped 1 previous similar message
simple invoked oom-killer: gfp_mask=0x1200d2, order=0, oomkilladj=0
Pid: 27211, comm: simple Tainted: P          2.6.27.39-0.3-perfctr #1

Call Trace:
 [<ffffffff8020d9d9>] show_trace_log_lvl+0x41/0x58
 [<ffffffff8049741f>] dump_stack+0x69/0x6f
 [<ffffffff80284f66>] oom_kill_process+0x5c/0x210
 [<ffffffff802855d8>] out_of_memory+0x1cd/0x203
 [<ffffffff80288ba7>] __alloc_pages_internal+0x33a/0x442
 [<ffffffff8029d7ae>] read_swap_cache_async+0x58/0xcb
 [<ffffffff8029d878>] swapin_readahead+0x57/0x98
 [<ffffffff802920b3>] do_swap_page+0xb1/0x38c
 [<ffffffff80293b5f>] handle_mm_fault+0x2ac/0x35c
 [<ffffffff8049b710>] do_page_fault+0x302/0x6f5
 [<ffffffff80499599>] error_exit+0x0/0x51
 [<ffffffff8035f46c>] __get_user_8+0x1c/0x23
 [<ffffffff8025b116>] exit_robust_list+0x2d/0x110
 [<ffffffff802408be>] do_exit+0x1c7/0x325
 [<ffffffff80240a83>] do_group_exit+0x67/0x94
 [<ffffffff80249654>] get_signal_to_deliver+0x2f4/0x314
 [<ffffffff8020b8fb>] do_signal+0x62/0x171
 [<ffffffff8020ba2c>] do_notify_resume+0x22/0x43
 [<ffffffff8020c2d7>] ptregscall_common+0x67/0xb0
 [<ffffffff8020bff2>] sysret_signal+0x1a/0x25
 [<00007fffee0532c6>] 0x7fffee0532c6

Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
CPU    4: hi:    0, btch:   1 usd:   0
CPU    5: hi:    0, btch:   1 usd:   0
CPU    6: hi:    0, btch:   1 usd:   0
CPU    7: hi:    0, btch:   1 usd:   0
CPU    8: hi:    0, btch:   1 usd:   0
CPU    9: hi:    0, btch:   1 usd:   0
CPU   10: hi:    0, btch:   1 usd:   0
CPU   11: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:   6
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd:   0
CPU    3: hi:  186, btch:  31 usd:   0
CPU    4: hi:  186, btch:  31 usd:  27
CPU    5: hi:  186, btch:  31 usd:   0
CPU    6: hi:  186, btch:  31 usd:  36
CPU    7: hi:  186, btch:  31 usd:   0
CPU    8: hi:  186, btch:  31 usd:   3
CPU    9: hi:  186, btch:  31 usd:   0
CPU   10: hi:  186, btch:  31 usd:  63
CPU   11: hi:  186, btch:  31 usd:   0
Node 0 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd: 127
CPU    1: hi:  186, btch:  31 usd:  57
CPU    2: hi:  186, btch:  31 usd:  54
CPU    3: hi:  186, btch:  31 usd:  30
CPU    4: hi:  186, btch:  31 usd: 160
CPU    5: hi:  186, btch:  31 usd:   0
CPU    6: hi:  186, btch:  31 usd: 112
CPU    7: hi:  186, btch:  31 usd:  57
CPU    8: hi:  186, btch:  31 usd:  56
CPU    9: hi:  186, btch:  31 usd: 167
CPU   10: hi:  186, btch:  31 usd: 180
CPU   11: hi:  186, btch:  31 usd:  78
Node 1 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:   0
CPU    1: hi:  186, btch:  31 usd: 155
CPU    2: hi:  186, btch:  31 usd:   0
CPU    3: hi:  186, btch:  31 usd: 154
CPU    4: hi:  186, btch:  31 usd:   0
CPU    5: hi:  186, btch:  31 usd: 180
CPU    6: hi:  186, btch:  31 usd:   0
CPU    7: hi:  186, btch:  31 usd: 181
CPU    8: hi:  186, btch:  31 usd:   0
CPU    9: hi:  186, btch:  31 usd: 130
CPU   10: hi:  186, btch:  31 usd:   0
CPU   11: hi:  186, btch:  31 usd:  92
Active:565787 inactive:2813476 dirty:0 writeback:0 unstable:0
 free:22958 slab:5742419 mapped:12151 pagetables:19711 bounce:0
Node 0 DMA free:6024kB min:0kB low:0kB high:0kB active:0kB inactive:0kB present:4672kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2598 18096 18096
Node 0 DMA32 free:63584kB min:1744kB low:2180kB high:2616kB active:6600kB inactive:5996kB present:2660800kB pages_scanned:24206 all_unreclaimable? yes
lowmem_reserve[]: 0 0 15498 15498
Node 0 Normal free:10080kB min:10416kB low:13020kB high:15624kB active:13416kB inactive:9094788kB present:15869952kB pages_scanned:33684162 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
Node 1 Normal free:12144kB min:12196kB low:15244kB high:18292kB active:2243520kB inactive:2153120kB present:18579452kB pages_scanned:8392714 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 6*4kB 4*8kB 3*16kB 3*32kB 3*64kB 2*128kB 1*256kB 2*512kB 2*1024kB 1*2048kB 0*4096kB = 6024kB
Node 0 DMA32: 206*4kB 85*8kB 30*16kB 21*32kB 18*64kB 9*128kB 9*256kB 6*512kB 4*1024kB 20*2048kB 2*4096kB = 63584kB
Node 0 Normal: 94*4kB 19*8kB 5*16kB 4*32kB 2*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 0*2048kB 2*4096kB = 10080kB
Node 1 Normal: 54*4kB 31*8kB 12*16kB 9*32kB 1*64kB 1*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 2*4096kB = 12144kB
5310 total pagecache pages
3826 pages in swap cache
Swap cache stats: add 81491802, delete 81487976, find 17414682/20300093
Free swap  = 0kB
Total swap = 24579440kB
9437183 pages RAM
180942 pages reserved
15990 pages shared
9214098 pages non-shared
master invoked oom-killer: gfp_mask=0x1200d2, order=0, oomkilladj=0
Pid: 5610, comm: master Tainted: P          2.6.27.39-0.3-perfctr #1

Call Trace:
 [<ffffffff8020d9d9>] show_trace_log_lvl+0x41/0x58
 [<ffffffff8049741f>] dump_stack+0x69/0x6f
 [<ffffffff80284f66>] oom_kill_process+0x5c/0x210
 [<ffffffff802855d8>] out_of_memory+0x1cd/0x203
 [<ffffffff80288ba7>] __alloc_pages_internal+0x33a/0x442
 [<ffffffff8029d7ae>] read_swap_cache_async+0x58/0xcb
 [<ffffffff8029d878>] swapin_readahead+0x57/0x98
 [<ffffffff802920b3>] do_swap_page+0xb1/0x38c
 [<ffffffff80293b5f>] handle_mm_fault+0x2ac/0x35c
 [<ffffffff8049b710>] do_page_fault+0x302/0x6f5
 [<ffffffff80499599>] error_exit+0x0/0x51
 [<00007ffff61176bb>] 0x7ffff61176bb

Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
CPU    4: hi:    0, btch:   1 usd:   0
CPU    5: hi:    0, btch:   1 usd:   0
CPU    6: hi:    0, btch:   1 usd:   0
CPU    7: hi:    0, btch:   1 usd:   0
CPU    8: hi:    0, btch:   1 usd:   0
CPU    9: hi:    0, btch:   1 usd:   0
CPU   10: hi:    0, btch:   1 usd:   0
CPU   11: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:   6
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd:   0
CPU    3: hi:  186, btch:  31 usd:   0
CPU    4: hi:  186, btch:  31 usd:  27
CPU    5: hi:  186, btch:  31 usd:   0
CPU    6: hi:  186, btch:  31 usd:  36
CPU    7: hi:  186, btch:  31 usd:   0
CPU    8: hi:  186, btch:  31 usd:   3
CPU    9: hi:  186, btch:  31 usd:   0
CPU   10: hi:  186, btch:  31 usd:  63
CPU   11: hi:  186, btch:  31 usd:   0
Node 0 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd: 127
CPU    1: hi:  186, btch:  31 usd:  57
CPU    2: hi:  186, btch:  31 usd:  54
CPU    3: hi:  186, btch:  31 usd:  31
CPU    4: hi:  186, btch:  31 usd: 160
CPU    5: hi:  186, btch:  31 usd:   0
CPU    6: hi:  186, btch:  31 usd: 104
CPU    7: hi:  186, btch:  31 usd:  57
CPU    8: hi:  186, btch:  31 usd:  56
CPU    9: hi:  186, btch:  31 usd: 167
CPU   10: hi:  186, btch:  31 usd: 180
CPU   11: hi:  186, btch:  31 usd:  78
Node 1 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:   0
CPU    1: hi:  186, btch:  31 usd: 155
CPU    2: hi:  186, btch:  31 usd:   0
CPU    3: hi:  186, btch:  31 usd: 154
CPU    4: hi:  186, btch:  31 usd:   0
CPU    5: hi:  186, btch:  31 usd: 180
CPU    6: hi:  186, btch:  31 usd:   0
CPU    7: hi:  186, btch:  31 usd: 181
CPU    8: hi:  186, btch:  31 usd:   0
CPU    9: hi:  186, btch:  31 usd: 130
CPU   10: hi:  186, btch:  31 usd:   0
CPU   11: hi:  186, btch:  31 usd:  92
Active:565943 inactive:2813170 dirty:0 writeback:0 unstable:0
 free:22958 slab:5742419 mapped:12151 pagetables:19711 bounce:0
Node 0 DMA free:6024kB min:0kB low:0kB high:0kB active:0kB inactive:0kB present:4672kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2598 18096 18096
Node 0 DMA32 free:63584kB min:1744kB low:2180kB high:2616kB active:6600kB inactive:5996kB present:2660800kB pages_scanned:24206 all_unreclaimable? yes
lowmem_reserve[]: 0 0 15498 15498
Node 0 Normal free:10080kB min:10416kB low:13020kB high:15624kB active:12780kB inactive:9095424kB present:15869952kB pages_scanned:34093762 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
Node 1 Normal free:12144kB min:12196kB low:15244kB high:18292kB active:2244392kB inactive:2151260kB present:18579452kB pages_scanned:8396872 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 6*4kB 4*8kB 3*16kB 3*32kB 3*64kB 2*128kB 1*256kB 2*512kB 2*1024kB 1*2048kB 0*4096kB = 6024kB
Node 0 DMA32: 206*4kB 85*8kB 30*16kB 21*32kB 18*64kB 9*128kB 9*256kB 6*512kB 4*1024kB 20*2048kB 2*4096kB = 63584kB
Node 0 Normal: 94*4kB 19*8kB 5*16kB 4*32kB 2*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 0*2048kB 2*4096kB = 10080kB
Node 1 Normal: 54*4kB 31*8kB 12*16kB 9*32kB 1*64kB 1*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 2*4096kB = 12144kB
5310 total pagecache pages
3833 pages in swap cache
Swap cache stats: add 81491811, delete 81487978, find 17414682/20300093
Free swap  = 0kB
Total swap = 24579440kB
9437183 pages RAM
180942 pages reserved
15980 pages shared
9214142 pages non-shared
Out of memory: kill process 24820 (launch_tests.sh) score 25384030 or a child
Killed process 27094 (tee)
gmond invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0
Pid: 4662, comm: gmond Tainted: P          2.6.27.39-0.3-perfctr #1

Call Trace:
 [<ffffffff8020d9d9>] show_trace_log_lvl+0x41/0x58
 [<ffffffff8049741f>] dump_stack+0x69/0x6f
 [<ffffffff80284f66>] oom_kill_process+0x5c/0x210
 [<ffffffff802855d8>] out_of_memory+0x1cd/0x203
 [<ffffffff80288ba7>] __alloc_pages_internal+0x33a/0x442
 [<ffffffff8028a6c8>] __do_page_cache_readahead+0x9b/0x1a4
 [<ffffffff80283343>] filemap_fault+0x162/0x324
 [<ffffffff8029167c>] __do_fault+0x54/0x3fa
 [<ffffffff80293b3b>] handle_mm_fault+0x288/0x35c
 [<ffffffff8049b710>] do_page_fault+0x302/0x6f5
 [<ffffffff80499599>] error_exit+0x0/0x51
 [<00007ffff6d22038>] 0x7ffff6d22038

Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
CPU    4: hi:    0, btch:   1 usd:   0
CPU    5: hi:    0, btch:   1 usd:   0
CPU    6: hi:    0, btch:   1 usd:   0
CPU    7: hi:    0, btch:   1 usd:   0
CPU    8: hi:    0, btch:   1 usd:   0
CPU    9: hi:    0, btch:   1 usd:   0
CPU   10: hi:    0, btch:   1 usd:   0
CPU   11: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:   6
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd:   0
CPU    3: hi:  186, btch:  31 usd:   0
CPU    4: hi:  186, btch:  31 usd:  27
CPU    5: hi:  186, btch:  31 usd:   0
CPU    6: hi:  186, btch:  31 usd:  36
CPU    7: hi:  186, btch:  31 usd:   0
CPU    8: hi:  186, btch:  31 usd:   3
CPU    9: hi:  186, btch:  31 usd:   0
CPU   10: hi:  186, btch:  31 usd:  63
CPU   11: hi:  186, btch:  31 usd:   0
Node 0 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd: 127
CPU    1: hi:  186, btch:  31 usd:  57
CPU    2: hi:  186, btch:  31 usd:  64
CPU    3: hi:  186, btch:  31 usd:  31
CPU    4: hi:  186, btch:  31 usd: 160
CPU    5: hi:  186, btch:  31 usd:   0
CPU    6: hi:  186, btch:  31 usd: 104
CPU    7: hi:  186, btch:  31 usd:  57
CPU    8: hi:  186, btch:  31 usd:  56
CPU    9: hi:  186, btch:  31 usd: 167
CPU   10: hi:  186, btch:  31 usd: 185
CPU   11: hi:  186, btch:  31 usd:  78
Node 1 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:   0
CPU    1: hi:  186, btch:  31 usd: 155
CPU    2: hi:  186, btch:  31 usd:   1
CPU    3: hi:  186, btch:  31 usd: 153
CPU    4: hi:  186, btch:  31 usd:   0
CPU    5: hi:  186, btch:  31 usd: 180
CPU    6: hi:  186, btch:  31 usd:   0
CPU    7: hi:  186, btch:  31 usd: 183
CPU    8: hi:  186, btch:  31 usd:   0
CPU    9: hi:  186, btch:  31 usd: 130
CPU   10: hi:  186, btch:  31 usd:   1
CPU   11: hi:  186, btch:  31 usd:  92
Active:566593 inactive:2812657 dirty:0 writeback:0 unstable:0
 free:22958 slab:5742419 mapped:12151 pagetables:19711 bounce:0
Node 0 DMA free:6024kB min:0kB low:0kB high:0kB active:0kB inactive:0kB present:4672kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2598 18096 18096
Node 0 DMA32 free:63584kB min:1744kB low:2180kB high:2616kB active:6600kB inactive:5996kB present:2660800kB pages_scanned:24270 all_unreclaimable? yes
lowmem_reserve[]: 0 0 15498 15498
Node 0 Normal free:10080kB min:10416kB low:13020kB high:15624kB active:13636kB inactive:9094660kB present:15869952kB pages_scanned:34566146 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
Node 1 Normal free:12144kB min:12196kB low:15244kB high:18292kB active:2246136kB inactive:2149972kB present:18579452kB pages_scanned:8403127 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 6*4kB 4*8kB 3*16kB 3*32kB 3*64kB 2*128kB 1*256kB 2*512kB 2*1024kB 1*2048kB 0*4096kB = 6024kB
Node 0 DMA32: 206*4kB 85*8kB 30*16kB 21*32kB 18*64kB 9*128kB 9*256kB 6*512kB 4*1024kB 20*2048kB 2*4096kB = 63584kB
Node 0 Normal: 94*4kB 19*8kB 5*16kB 4*32kB 2*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 0*2048kB 2*4096kB = 10080kB
Node 1 Normal: 54*4kB 31*8kB 12*16kB 9*32kB 1*64kB 1*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 2*4096kB = 12144kB
5310 total pagecache pages
3848 pages in swap cache
Swap cache stats: add 81491839, delete 81487991, find 17414682/20300094
Free swap  = 0kB
Total swap = 24579440kB
9437183 pages RAM
180942 pages reserved
15900 pages shared
9214127 pages non-shared
Out of memory: kill process 24820 (launch_tests.sh) score 25383395 or a child
Killed process 27197 (simple)
Lustre: 5789:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664451039 sent from lustre-OST0000-osc-ffff880951d67000 to NID 10.149.245.3@o2ib 17s ago has timed out (17s prior to deadline).
  req@ffff88016acf4000 x1403283664451039/t0 o400->lustre-OST0000_UUID@10.149.245.3@o2ib:28/4 lens 192/384 e 0 to 1 dl 1339007017 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5789:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 1 previous similar message
Lustre: lustre-OST0000-osc-ffff880951d67000: Connection to service lustre-OST0000 via nid 10.149.245.3@o2ib was lost; in progress operations using this service will wait for recovery to complete.
Lustre: Skipped 1 previous similar message
Lustre: lustre-OST0000-osc-ffff880951d67000: Connection restored to service lustre-OST0000 using nid 10.149.245.3@o2ib.
Lustre: Skipped 1 previous similar message
automount invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0
Pid: 4646, comm: automount Tainted: P          2.6.27.39-0.3-perfctr #1

Call Trace:
 [<ffffffff8020d9d9>] show_trace_log_lvl+0x41/0x58
 [<ffffffff8049741f>] dump_stack+0x69/0x6f
 [<ffffffff80284f66>] oom_kill_process+0x5c/0x210
 [<ffffffff802855d8>] out_of_memory+0x1cd/0x203
 [<ffffffff80288ba7>] __alloc_pages_internal+0x33a/0x442
 [<ffffffff8028a6c8>] __do_page_cache_readahead+0x9b/0x1a4
 [<ffffffff80283343>] filemap_fault+0x162/0x324
 [<ffffffff8029167c>] __do_fault+0x54/0x3fa
 [<ffffffff80293b3b>] handle_mm_fault+0x288/0x35c
 [<ffffffff8049b710>] do_page_fault+0x302/0x6f5
 [<ffffffff80499599>] error_exit+0x0/0x51
 [<00007ffff7b99ea0>] 0x7ffff7b99ea0

Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
CPU    4: hi:    0, btch:   1 usd:   0
CPU    5: hi:    0, btch:   1 usd:   0
CPU    6: hi:    0, btch:   1 usd:   0
CPU    7: hi:    0, btch:   1 usd:   0
CPU    8: hi:    0, btch:   1 usd:   0
CPU    9: hi:    0, btch:   1 usd:   0
CPU   10: hi:    0, btch:   1 usd:   0
CPU   11: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  12
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd:   3
CPU    3: hi:  186, btch:  31 usd:   0
CPU    4: hi:  186, btch:  31 usd:  27
CPU    5: hi:  186, btch:  31 usd:   0
CPU    6: hi:  186, btch:  31 usd:  36
CPU    7: hi:  186, btch:  31 usd:   0
CPU    8: hi:  186, btch:  31 usd:   3
CPU    9: hi:  186, btch:  31 usd:   0
CPU   10: hi:  186, btch:  31 usd:  66
CPU   11: hi:  186, btch:  31 usd:   0
Node 0 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  81
CPU    1: hi:  186, btch:  31 usd:  58
CPU    2: hi:  186, btch:  31 usd:  66
CPU    3: hi:  186, btch:  31 usd:  31
CPU    4: hi:  186, btch:  31 usd: 152
CPU    5: hi:  186, btch:  31 usd:   0
CPU    6: hi:  186, btch:  31 usd: 112
CPU    7: hi:  186, btch:  31 usd:  58
CPU    8: hi:  186, btch:  31 usd:  56
CPU    9: hi:  186, btch:  31 usd: 168
CPU   10: hi:  186, btch:  31 usd: 157
CPU   11: hi:  186, btch:  31 usd:  83
Node 1 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:   0
CPU    1: hi:  186, btch:  31 usd: 155
CPU    2: hi:  186, btch:  31 usd:   0
CPU    3: hi:  186, btch:  31 usd: 173
CPU    4: hi:  186, btch:  31 usd:   0
CPU    5: hi:  186, btch:  31 usd: 180
CPU    6: hi:  186, btch:  31 usd:   0
CPU    7: hi:  186, btch:  31 usd: 183
CPU    8: hi:  186, btch:  31 usd:   0
CPU    9: hi:  186, btch:  31 usd: 143
CPU   10: hi:  186, btch:  31 usd:   0
CPU   11: hi:  186, btch:  31 usd:  90
Active:578841 inactive:2800548 dirty:0 writeback:0 unstable:0
 free:22995 slab:5742388 mapped:12144 pagetables:19705 bounce:0
Node 0 DMA free:6024kB min:0kB low:0kB high:0kB active:0kB inactive:0kB present:4672kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2598 18096 18096
Node 0 DMA32 free:63584kB min:1744kB low:2180kB high:2616kB active:6608kB inactive:5988kB present:2660800kB pages_scanned:30158 all_unreclaimable? yes
lowmem_reserve[]: 0 0 15498 15498
Node 0 Normal free:10220kB min:10416kB low:13020kB high:15624kB active:9468kB inactive:9099356kB present:15869952kB pages_scanned:42245697 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
Node 1 Normal free:12152kB min:12196kB low:15244kB high:18292kB active:2299288kB inactive:2096848kB present:18579452kB pages_scanned:11282823 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 6*4kB 4*8kB 3*16kB 3*32kB 3*64kB 2*128kB 1*256kB 2*512kB 2*1024kB 1*2048kB 0*4096kB = 6024kB
Node 0 DMA32: 206*4kB 85*8kB 30*16kB 21*32kB 18*64kB 9*128kB 9*256kB 6*512kB 4*1024kB 20*2048kB 2*4096kB = 63584kB
Node 0 Normal: 123*4kB 21*8kB 5*16kB 4*32kB 2*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 0*2048kB 2*4096kB = 10212kB
Node 1 Normal: 56*4kB 31*8kB 12*16kB 9*32kB 1*64kB 1*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 2*4096kB = 12152kB
5303 total pagecache pages
3826 pages in swap cache
Swap cache stats: add 81491839, delete 81488013, find 17414682/20300094
Free swap  = 0kB
Total swap = 24579440kB
9437183 pages RAM
180942 pages reserved
15611 pages shared
9214193 pages non-shared
Out of memory: kill process 24820 (launch_tests.sh) score 12693258 or a child
Killed process 27202 (simple)
LustreError: 11-0: an error occurred while communicating with 10.149.245.3@o2ib. The obd_ping operation failed with -107
LustreError: Skipped 1 previous similar message
Lustre: lustre-OST0000-osc-ffff880951d67000: Connection to service lustre-OST0000 via nid 10.149.245.3@o2ib was lost; in progress operations using this service will wait for recovery to complete.
Lustre: Skipped 1 previous similar message
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 2s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 1 previous similar message
Lustre: lustre-OST0000-osc-ffff880951d67000: Connection restored to service lustre-OST0000 using nid 10.149.245.3@o2ib.
Lustre: Skipped 1 previous similar message
LustreError: 11-0: an error occurred while communicating with 10.149.245.3@o2ib. The obd_ping operation failed with -107
Lustre: lustre-OST0000-osc-ffff880951d67000: Connection to service lustre-OST0000 via nid 10.149.245.3@o2ib was lost; in progress operations using this service will wait for recovery to complete.
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 2s
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 3s
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 4s
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 5s
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 6s
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 7s
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 9s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 1 previous similar message
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 12s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 2 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 16s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 3 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 23s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 6 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 25s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 9 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 19s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 18 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 25s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 10 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 14s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 16 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 25s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 11 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 5s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 11 previous similar messages
Lustre: 5789:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664482192 sent from lustre-OST0004-osc-ffff880951d67000 to NID 10.149.245.3@o2ib 17s ago has timed out (17s prior to deadline).
  req@ffff8804bfc29400 x1403283664482192/t0 o400->lustre-OST0004_UUID@10.149.245.3@o2ib:28/4 lens 192/384 e 0 to 1 dl 1339058742 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5789:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 1 previous similar message
Lustre: lustre-OST0004-osc-ffff880951d67000: Connection to service lustre-OST0004 via nid 10.149.245.3@o2ib was lost; in progress operations using this service will wait for recovery to complete.
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664482202 sent from lustre-OST0004-osc-ffff880951d67000 to NID 10.149.245.3@o2ib 6s ago has timed out (6s prior to deadline).
  req@ffff8804d0176800 x1403283664482202/t0 o8->lustre-OST0004_UUID@10.149.245.3@o2ib:28/4 lens 368/584 e 0 to 1 dl 1339058748 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 2 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664482220 sent from lustre-OST0004-osc-ffff880951d67000 to NID 10.149.245.3@o2ib 7s ago has timed out (7s prior to deadline).
  req@ffff8803747ed400 x1403283664482220/t0 o8->lustre-OST0004_UUID@10.149.245.3@o2ib:28/4 lens 368/584 e 0 to 1 dl 1339058763 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 3 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664482227 sent from lustre-OST0004-osc-ffff880951d67000 to NID 10.149.245.3@o2ib 8s ago has timed out (8s prior to deadline).
  req@ffff8804c0487800 x1403283664482227/t0 o8->lustre-OST0004_UUID@10.149.245.3@o2ib:28/4 lens 368/584 e 0 to 1 dl 1339058780 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 2 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664482226 sent from lustre-OST0000-osc-ffff880951d67000 to NID 10.149.245.3@o2ib 22s ago has timed out (22s prior to deadline).
  req@ffff8804c0487c00 x1403283664482226/t0 o8->lustre-OST0000_UUID@10.149.245.3@o2ib:28/4 lens 368/584 e 0 to 1 dl 1339058794 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 2 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664482262 sent from lustre-OST0004-osc-ffff880951d67000 to NID 10.149.245.3@o2ib 10s ago has timed out (10s prior to deadline).
  req@ffff880222c33400 x1403283664482262/t0 o8->lustre-OST0004_UUID@10.149.245.3@o2ib:28/4 lens 368/584 e 0 to 1 dl 1339058820 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 3 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664482265 sent from lustre-OST0000-osc-ffff880951d67000 to NID 10.149.245.3@o2ib 23s ago has timed out (23s prior to deadline).
  req@ffff8804bf5d3800 x1403283664482265/t0 o8->lustre-OST0000_UUID@10.149.245.3@o2ib:28/4 lens 368/584 e 0 to 1 dl 1339058841 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 2 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664482301 sent from lustre-OST0000-osc-ffff880951d67000 to NID 10.149.245.3@o2ib 24s ago has timed out (24s prior to deadline).
  req@ffff8802bec7fc00 x1403283664482301/t0 o8->lustre-OST0000_UUID@10.149.245.3@o2ib:28/4 lens 368/584 e 0 to 1 dl 1339058890 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 6 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664482371 sent from lustre-OST0004-osc-ffff880951d67000 to NID 10.149.245.3@o2ib 16s ago has timed out (16s prior to deadline).
  req@ffff8804bf4cd800 x1403283664482371/t0 o8->lustre-OST0004_UUID@10.149.245.3@o2ib:28/4 lens 368/584 e 0 to 1 dl 1339058988 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 10 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0004-osc-ffff880951d67000: tried all connections, increasing latency to 12s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 46 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664482470 sent from lustre-OST0004-osc-ffff880951d67000 to NID 10.149.245.3@o2ib 20s ago has timed out (20s prior to deadline).
  req@ffff8804bf4cd400 x1403283664482470/t0 o8->lustre-OST0004_UUID@10.149.245.3@o2ib:28/4 lens 368/584 e 0 to 1 dl 1339059140 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 14 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664482669 sent from lustre-OST0000-osc-ffff880951d67000 to NID 10.149.245.3@o2ib 0s ago has failed due to network error (30s prior to deadline).
  req@ffff8804c25ab800 x1403283664482669/t0 o8->lustre-OST0000_UUID@10.149.245.3@o2ib:28/4 lens 368/584 e 0 to 1 dl 1339059474 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 25 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 25s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 48 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664483034 sent from lustre-OST0000-osc-ffff880951d67000 to NID 10.149.245.3@o2ib 0s ago has failed due to network error (15s prior to deadline).
  req@ffff8804d24a8000 x1403283664483034/t0 o8->lustre-OST0000_UUID@10.149.245.3@o2ib:28/4 lens 368/584 e 0 to 1 dl 1339060077 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 44 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 15s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 58 previous similar messages
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) @@@ Request x1403283664483434 sent from lustre-OST0004-osc-ffff880951d67000 to NID 10.149.245.3@o2ib 24s ago has timed out (24s prior to deadline).
  req@ffff8804d2157c00 x1403283664483434/t0 o8->lustre-OST0004_UUID@10.149.245.3@o2ib:28/4 lens 368/584 e 0 to 1 dl 1339060694 ref 1 fl Rpc:N/0/0 rc 0/0
Lustre: 5790:0:(client.c:1476:ptlrpc_expire_one_request()) Skipped 67 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 25s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 56 previous similar messages
Lustre: lustre-OST0004-osc-ffff880951d67000: Connection restored to service lustre-OST0004 using nid 10.149.245.3@o2ib.
Lustre: lustre-OST000b-osc-ffff880951d67000: Connection restored to service lustre-OST000b using nid 10.149.245.3@o2ib.
Lustre: lustre-OST000c-osc-ffff880951d67000: Connection restored to service lustre-OST000c using nid 10.149.245.3@o2ib.
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 9s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 25 previous similar messages
Lustre: 5791:0:(import.c:517:import_select_connection()) lustre-OST0000-osc-ffff880951d67000: tried all connections, increasing latency to 23s
Lustre: 5791:0:(import.c:517:import_select_connection()) Skipped 13 previous similar messages
LustreError: 167-0: This client was evicted by lustre-OST0000; in progress operations using this service will fail.
Lustre: lustre-OST0000-osc-ffff880951d67000: Connection restored to service lustre-OST0000 using nid 10.149.245.3@o2ib.
LustreError: 11-0: an error occurred while communicating with 10.149.245.3@o2ib. The obd_ping operation failed with -107
Lustre: lustre-OST0000-osc-ffff880951d67000: Connection to service lustre-OST0000 via nid 10.149.245.3@o2ib was lost; in progress operations using this service will wait for recovery to complete.
Lustre: Skipped 2 previous similar messages
Lustre: lustre-OST0000-osc-ffff880951d67000: Connection restored to service lustre-OST0000 using nid 10.149.245.3@o2ib.
mult_ctx_hierar[24071]: segfault at 0 ip 00007ffff78b6f9b sp 00007fffdab2bf80 error 4 in libsched_ctx_hypervisor.so.0.0.0[7ffff78b2000+e000]
mult_ctx_hierar[26649]: segfault at 0 ip 00007ffff78b6f9b sp 00007fffe2b2bf80 error 4 in libsched_ctx_hypervisor.so.0.0.0[7ffff78b2000+e000]
mult_ctx_hierar[31051]: segfault at 0 ip 00007ffff78b608b sp 00007fffe232afa0 error 4 in libsched_ctx_hypervisor.so.0.0.0[7ffff78b2000+e000]
mult_ctx_hierar[12501]: segfault at 7ffff7b07168 ip 00007ffff7b24022 sp 00007fffe5b31fb8 error 7 in libstarpu-1.0.so.1.0.0[7ffff7ac8000+a8000]
mult_ctx_hierar[3041]: segfault at 7fffb51dd240 ip 00007fffb51dd240 sp 00007fffdeffcfe8 error 15<6>mult_ctx_hierar[3044]: segfault at 7fffb51dd240 ip 00007fffb51dd240 sp 00007fffdd7f9fe8 error 15

mult_ctx_hierar[15710]: segfault at 7fffcd1350a0 ip 00007fffcd1350a0 sp 00007fffdbb2dfe8 error 15
mult_ctx_hierar[4041]: segfault at a2 ip 00007fffeba7458a sp 00007fffe232adb0 error 4 in libpthread-2.9.so[7fffeba6c000+16000]
mult_ctx_hierar[7411]: segfault at 0 ip 00007ffff7b00c56 sp 00007fffe1b29e30 error 4 in libstarpu-1.0.so.1.0.0[7ffff7ac8000+a8000]
mult_ctx_hierar[20712]: segfault at 7fffd5141a60 ip 00007fffd5141a60 sp 00007fffe2b2bfe8 error 15
mult_ctx_hierar[20713]: segfault at 7fffd5141a60 ip 00007fffd5141a60 sp 00007fffe232afe8 error 15
mult_ctx_hierar[20704]: segfault at 7fffd5141a60 ip 00007fffd5141a60 sp 00007fffe6332fe8 error 15
mult_ctx_hierar[20711]: segfault at 7fffd5141a60 ip 00007fffd5141a60 sp 00007fffe332cfe8 error 15
mult_ctx_hierar[20710]: segfault at 7fffd5141a60 ip 00007fffd5141a60 sp 00007fffe3b2dfe8 error 15
mult_ctx_hierar[20709]: segfault at 7fffd5141a60 ip 00007fffd5141a60 sp 00007fffdbb2dfe8 error 15
mult_ctx_hierar[26615] general protection ip:7ffff78b60bc sp:7fffdeffcfa0 error:0 in libsched_ctx_hypervisor.so.0.0.0[7ffff78b2000+e000]
mult_ctx_hierar[2856]: segfault at 0 ip 00007ffff78b6f9b sp 00007fffe6b33f80 error 4 in libsched_ctx_hypervisor.so.0.0.0[7ffff78b2000+e000]
mult_ctx_hierar[2937] general protection ip:7ffff78b60bc sp:7fffe332cfa0 error:0 in libsched_ctx_hypervisor.so.0.0.0[7ffff78b2000+e000]
mult_ctx_hierar[14951]: segfault at 25 ip 00007ffff7b10a8f sp 00007fffe332cfe0 error 6 in libstarpu-1.0.so.1.0.0[7ffff7ac8000+a8000]
mult_ctx_hierar[14980]: segfault at 25 ip 00007ffff7b10a8f sp 00007fffe2b2bfe0 error 6 in libstarpu-1.0.so.1.0.0[7ffff7ac8000+a8000]
mult_ctx_hierar[14983]: segfault at 2d ip 00007fffeb57150c sp 00007fffe1328f30 error 4 in libc-2.9.so[7fffeb4fb000+14f000]
mult_ctx_hierar[23607]: segfault at 9c ip 00007ffff7aeb829 sp 00007fffe4d45fd0 error 4 in libstarpu-1.0.so.1.0.0[7ffff7ac8000+a8000]
mult_ctx_hierar[26892]: segfault at 9c ip 00007ffff7aeb829 sp 00007fffe6548fd0 error 4 in libstarpu-1.0.so.1.0.0[7ffff7ac8000+a8000]
mult_ctx_hierar[12777] general protection ip:7ffff78b70bc sp:7fffe3b2efa0 error:0 in libsched_ctx_hypervisor.so.0.0.0[7ffff78b3000+e000]
mult_ctx_hierar[23479]: segfault at 7ffff7ac9044 ip 00007ffff78b62ff sp 00007fff6bd060d0 error 7 in libsched_ctx_hypervisor.so.0.0.0[7ffff78b3000+e000]
time_dpotrf_til[8384]: segfault at 1 ip 00007fffec2a2d67 sp 00007fffea761f58 error 6 in libc-2.9.so[7fffec223000+14f000]
time_dpotrf_til[8406]: segfault at 1 ip 00007fffec2a2d67 sp 00007fffe9f60f58 error 6 in libc-2.9.so[7fffec223000+14f000]
time_dpotrf_til[13354]: segfault at 1 ip 00007fffec2a2d67 sp 00007fffeaf62f58 error 6 in libc-2.9.so[7fffec223000+14f000]
time_dpotrf_til[13387]: segfault at 1 ip 00007fffec2a2d67 sp 00007fffeaf62f58 error 6 in libc-2.9.so[7fffec223000+14f000]
time_dpotrf_til[13401]: segfault at 1 ip 00007fffec2a2d67 sp 00007fffeaf62f58 error 6 in libc-2.9.so[7fffec223000+14f000]
time_dpotrf_til[14356]: segfault at 1 ip 00007fffec2a2d67 sp 00007fffeaf62f58 error 6 in libc-2.9.so[7fffec223000+14f000]
mult_ctx_hierar[18086]: segfault at 4 ip 00007ffff78ba2bf sp 00007fffe432fe80 error 4 in libsched_ctx_hypervisor.so.0.0.0[7ffff78b3000+f000]
mult_ctx_hierar[22018]: segfault at b63 ip 00007ffff7b0935f sp 00007fffe5331fb0 error 4 in libstarpu-1.0.so.1.0.0[7ffff7ac9000+a7000]
mult_ctx_hierar[23008]: segfault at 0 ip 00007ffff7b01c31 sp 00007fffffffcc70 error 6 in libstarpu-1.0.so.1.0.0[7ffff7ac9000+a7000]
mult[13366]: segfault at 10 ip 00007ffff7afe1af sp 00007fffffffccc0 error 4 in libstarpu-1.0.so.1.0.0[7ffff7ac9000+9c000]
mult[16660]: segfault at 10 ip 00007ffff7afe1af sp 00007fffffffccc0 error 4 in libstarpu-1.0.so.1.0.0[7ffff7ac9000+9c000]
mult[4345]: segfault at 18 ip 00007ffff7afc7b9 sp 00007fffe5444ff0 error 4 in libstarpu-1.0.so.1.0.0[7ffff7ac8000+9c000]
mult[7168]: segfault at 18 ip 00007ffff7afc7b9 sp 00007fffdfffeff0 error 4 in libstarpu-1.0.so.1.0.0[7ffff7ac8000+9c000]
mult[7366]: segfault at 18 ip 00007ffff7afc7b9 sp 00007fffe4c43ff0 error 4 in libstarpu-1.0.so.1.0.0[7ffff7ac8000+9c000]
mult[2309]: segfault at 18 ip 00007ffff7afc819 sp 00007fffe4d45ff0 error 4 in libstarpu-1.0.so.1.0.0[7ffff7ac8000+9c000]
mult[5304]: segfault at ffffffffe000bae8 ip 00007ffff7afd1a7 sp 00007fffdfffefd0 error 4 in libstarpu-1.0.so.1.0.0[7ffff7ac8000+9c000]
mult[26546]: segfault at ffffffffd8001b48 ip 00007ffff7afc8f9 sp 00007fffe3542ff0 error 4 in libstarpu-1.0.so.1.0.0[7ffff7ac8000+9d000]
mult[26579]: segfault at ffffffffd4027778 ip 00007ffff7afc8f9 sp 00007fffe153eff0 error 4 in libstarpu-1.0.so.1.0.0[7ffff7ac8000+9d000]
mult[29364]: segfault at ffffffffd0014708 ip 00007ffff7afc8c9 sp 00007fffdbd43ff0 error 4 in libstarpu-1.0.so.1.0.0[7ffff7ac8000+9c000]
mult[5229]: segfault at ffffffffd0001848 ip 00007ffff7afc8c9 sp 00007fffe5d47ff0 error 4 in libstarpu-1.0.so.1.0.0[7ffff7ac8000+9c000]
mult[8082]: segfault at ffffffffd4076b08 ip 00007ffff7afc8c9 sp 00007fffe6548ff0 error 4 in libstarpu-1.0.so.1.0.0[7ffff7ac8000+9c000]
mult[10816]: segfault at ffffffffdc02b558 ip 00007ffff7afc8c9 sp 00007fffe4d45ff0 error 4 in libstarpu-1.0.so.1.0.0[7ffff7ac8000+9c000]
mult[13590]: segfault at ffffffffcc0066b8 ip 00007ffff7afc8b9 sp 00007fffe4544ff0 error 4 in libstarpu-1.0.so.1.0.0[7ffff7ac8000+9c000]
mult[13615]: segfault at ffffffffdc080008 ip 00007ffff7afc8b9 sp 00007fffe6548ff0 error 4 in libstarpu-1.0.so.1.0.0[7ffff7ac8000+9c000]
mult[16477]: segfault at ffffffffd401e068 ip 00007ffff7afc909 sp 00007fffe4544ff0 error 4 in libstarpu-1.0.so.1.0.0[7ffff7ac8000+9c000]
mult[22054]: segfault at ffffffffd4059eb8 ip 00007ffff7afc959 sp 00007fffe6548ff0 error 4 in libstarpu-1.0.so.1.0.0[7ffff7ac8000+9d000]
mult[24999]: segfault at ffffffffd4028848 ip 00007ffff7afc959 sp 00007fffe6548ff0 error 4 in libstarpu-1.0.so.1.0.0[7ffff7ac8000+9d000]
mult[12259]: segfault at ffffffffd4001788 ip 00007ffff7afc84f sp 00007fffe3543030 error 4 in libstarpu-1.0.so.1.0.0[7ffff7ac8000+9d000]
mult[17893]: segfault at ffffffffd408e2e8 ip 00007ffff7afc84f sp 00007fffe3543030 error 4 in libstarpu-1.0.so.1.0.0[7ffff7ac8000+9d000]
mult[26007]: segfault at ffffffffd4003388 ip 00007ffff7afc84f sp 00007fffe2d42030 error 4 in libstarpu-1.0.so.1.0.0[7ffff7ac8000+9d000]
NVRM: Xid (0000:06:00): 13, 0001 00000000 000090c0 00001b0c 00000000 00000000
NVRM: Xid (0000:06:00): 13, 0001 00000000 000090c0 00001b0c 00000000 00000000
libstarpufft-1.[16798]: segfault at 1 ip 0000000000000001 sp 00007fffffffe5a8 error 14
libstarpumpi-1.[16806]: segfault at 1 ip 0000000000000001 sp 00007fffffffe5b8 error 14
libstarpumpi-1.[16808]: segfault at 1 ip 0000000000000001 sp 00007fffffffe5b8 error 14
libstarpumpi-1.[16809]: segfault at 1 ip 0000000000000001 sp 00007fffffffe5a8 error 14
libstarpu-1.0.s[16810]: segfault at 1 ip 0000000000000001 sp 00007fffffffe5c8 error 14
libstarpufft-1.[16811]: segfault at 1 ip 0000000000000001 sp 00007fffffffe5b8 error 14
libstarpu-1.0.s[16812]: segfault at 1 ip 0000000000000001 sp 00007fffffffe5b8 error 14
libstarpu-1.0.s[16813]: segfault at 1 ip 0000000000000001 sp 00007fffffffe5b8 error 14
libstarpufft-1.[16814]: segfault at 1 ip 0000000000000001 sp 00007fffffffe5b8 error 14
NVRM: Xid (0000:06:00): 13, 0001 00000000 000090c0 00001b0c 00000000 00000000
NVRM: Xid (0000:11:00): 13, 0001 00000000 000090c0 00001b0c 00000000 00000000
NVRM: Xid (0000:06:00): 13, 0001 00000000 000090c0 00001b0c 00000000 00000000
libstarpufft-1.[30620]: segfault at 1 ip 0000000000000001 sp 00007fffffffe5a8 error 14
libstarpumpi-1.[30628]: segfault at 1 ip 0000000000000001 sp 00007fffffffe5b8 error 14
libstarpumpi-1.[30630]: segfault at 1 ip 0000000000000001 sp 00007fffffffe5b8 error 14
libstarpumpi-1.[30631]: segfault at 1 ip 0000000000000001 sp 00007fffffffe5a8 error 14
libstarpu-1.0.s[30632]: segfault at 1 ip 0000000000000001 sp 00007fffffffe5c8 error 14
libstarpufft-1.[30633]: segfault at 1 ip 0000000000000001 sp 00007fffffffe5b8 error 14
libstarpu-1.0.s[30634]: segfault at 1 ip 0000000000000001 sp 00007fffffffe5b8 error 14
libstarpu-1.0.s[30635]: segfault at 1 ip 0000000000000001 sp 00007fffffffe5b8 error 14
libstarpufft-1.[30636]: segfault at 1 ip 0000000000000001 sp 00007fffffffe5b8 error 14
mult_ctx_hierar[13809]: segfault at 1d5 ip 00007fffebc8e660 sp 00007fffe6447f58 error 6 in libpthread-2.9.so[7fffebc83000+16000]
mult_ctx_hierar[457]: segfault at 0 ip 00007ffff7b056a1 sp 00007fffffffcbb0 error 6 in libstarpu-1.0.so.1.0.0[7ffff7acc000+a6000]
mult_ctx_hierar[13559]: segfault at 7bc62 ip 00007ffff7ae8e0f sp 00007fffe5b2ff58 error 4 in libstarpu-1.0.so.1.0.0[7ffff7ac9000+a7000]
mult_ctx_hierar[22144]: segfault at 7bc64 ip 00007ffff7ae8e0f sp 00007fffe4b2df58 error 4 in libstarpu-1.0.so.1.0.0[7ffff7ac9000+a7000]
cg_PERF_GPU_CPU[1847]: segfault at 10 ip 00007fffe961e660 sp 00007fffffffc608 error 6 in libpthread-2.9.so[7fffe9613000+16000]

--------------000408070705080401080106--
