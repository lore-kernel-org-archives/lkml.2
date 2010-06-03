Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933487Ab0FCJSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 05:18:48 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45893 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932737Ab0FCJSn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 05:18:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=awoq9Pc702NOYYrb9hL0eDlKEUzCWe8sMqCRfxiTf+wu11FjkFNGcZCxBSUiKRMpim
         iPoDbUK4jkjk+7rw/1JtVIAUD/dEbBNfw4ukGX1ocxYR5gy+ZtRLsuNcpdQN3ftXLrI0
         FfD/P6SuDaSyXrskl1yIr7NuLm9rkJhUTJW+A=
MIME-Version: 1.0
In-Reply-To: <AANLkTilSNOgD1HrvYBMEsza5-IIeBS1U7AHChO1vJKuf@mail.gmail.com>
References: <AANLkTikWak8i-Kaj-e-EUFWE66tfMmp2UPhGJCKkK1zK@mail.gmail.com>
	<20100603075402.GA11093@oksana.dev.rtsoft.ru>
	<AANLkTil6k_4YwdvLai_VUlVjgz030ctu7djVGHu0qgd2@mail.gmail.com>
	<20100603084104.GA17431@oksana.dev.rtsoft.ru>
	<AANLkTilSNOgD1HrvYBMEsza5-IIeBS1U7AHChO1vJKuf@mail.gmail.com>
Date: Thu, 3 Jun 2010 17:18:40 +0800
Message-ID: <AANLkTima_jbwafiHQsncQzdX04ZcjO_8QIpq5UOohi3x@mail.gmail.com>
Subject: Re: 2.6.25-rc1 ahci regression
From: Luming Yu <luming.yu@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 3, 2010 at 4:56 PM, Luming Yu <luming.yu@gmail.com> wrote:
>>
>> So, I wonder, have you actually bisected the thing correctly?
>
> That is possible,
>
> But git-bisecting just takes too much times even in any modern
> hardware with reasonable configurations
>
> I  git-archive --format=tar  365cfa1ed5a36f9bcb9f64c9f0f52155af2e9fef
> tree and  then reverted the patch gotten from "git show
> 365cfa1ed5a36f9bcb9f64c9f0f52155af2e9fef"
>
> then it boots,  otherwise not boot.
>

Linux version 2.6.32-25.el6.x86_64
(mockbuild@x86-006.build.bos.redhat.com) (gcc version 4.4.4 20100503
(Red Hat 4.4.4-2) (GCC) ) #1 SMP Mon May 10 17:30:22 EDT 2010
Command line: ro root=/dev/mapper/vg_intels3ea209-lv_root
rd_LVM_LV=vg_intels3ea209/lv_root rd_LVM_LV=vg_intels3ea209/lv_swap
rd_NO_LUKS rd_NO_MD rd_NO_DM LANG=en_US.UTF-8
SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us
console=ttyS0,115200n81 console=tty0 console=ttyS0,115200n81
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
 BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bf349000 (usable)
 BIOS-e820: 00000000bf349000 - 00000000bf3ca000 (ACPI NVS)
 BIOS-e820: 00000000bf3ca000 - 00000000bf3cb000 (ACPI data)
 BIOS-e820: 00000000bf3cb000 - 00000000bf3dc000 (reserved)
 BIOS-e820: 00000000bf3dc000 - 00000000bf3dd000 (ACPI NVS)
 BIOS-e820: 00000000bf3dd000 - 00000000bf3ee000 (reserved)
 BIOS-e820: 00000000bf3ee000 - 00000000bf3f1000 (ACPI NVS)
 BIOS-e820: 00000000bf3f1000 - 00000000bf44f000 (reserved)
 BIOS-e820: 00000000bf44f000 - 00000000bf45a000 (ACPI data)
 BIOS-e820: 00000000bf45a000 - 00000000bf465000 (ACPI NVS)
 BIOS-e820: 00000000bf465000 - 00000000bf483000 (reserved)
 BIOS-e820: 00000000bf483000 - 00000000bf686000 (ACPI NVS)
 BIOS-e820: 00000000bf686000 - 00000000bf800000 (usable)
 BIOS-e820: 00000000c0000000 - 00000000d0000000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 00000004c0000000 (usable)
DMI 2.4 present.
AMI BIOS detected: BIOS may corrupt low RAM, working around it.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
last_pfn = 0x4c0000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CFFFF write-protect
  D0000-E7FFF uncachable
  E8000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 0000000000 mask FC00000000 write-back
  1 base 0400000000 mask FF80000000 write-back
  2 base 0480000000 mask FFC0000000 write-back
  3 base 00C0000000 mask FFC0000000 uncachable
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
original variable MTRRs
reg 0, base: 0GB, range: 16GB, type WB
reg 1, base: 16GB, range: 2GB, type WB
reg 2, base: 18GB, range: 1GB, type WB
reg 3, base: 3GB, range: 1GB, type UC
total RAM covered: 18432M
Found optimal setting for mtrr clean up
 gran_size: 64K 	chunk_size: 64K 	num_reg: 6  	lose cover RAM: 0G
New variable MTRRs
reg 0, base: 0GB, range: 2GB, type WB
reg 1, base: 2GB, range: 1GB, type WB
reg 2, base: 4GB, range: 4GB, type WB
reg 3, base: 8GB, range: 8GB, type WB
reg 4, base: 16GB, range: 2GB, type WB
reg 5, base: 18GB, range: 1GB, type WB
e820 update range: 00000000c0000000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0xbf800 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
init_memory_mapping: 0000000000000000-00000000bf800000
 0000000000 - 00bf800000 page 2M
kernel direct mapping tables up to bf800000 @ 10000-14000
init_memory_mapping: 0000000100000000-00000004c0000000
 0100000000 - 04c0000000 page 2M
kernel direct mapping tables up to 4c0000000 @ 12000-26000
RAMDISK: 3735e000 - 37fef6ba
ACPI: RSDP 00000000000f03f0 00024 (v02 ALASKA)
ACPI: XSDT 00000000bf458e18 00084 (v01 ALASKA    A M I 06222004 MSFT 00010013)
ACPI: FACP 00000000bf457d98 000F4 (v04 ALASKA    A M I 06222004 MSFT 00010013)
ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables!
(20090903/tbfadt-369)
ACPI Warning: 32/64X FACS address mismatch in FADT -
BF461F40/00000000BF462E40, using 32 (20090903/tbfadt-486)
ACPI: DSDT 00000000bf450018 06E8F (v01 ALASKA    A M I 00000001 INTL 20051117)
ACPI: FACS 00000000bf461f40 00040
ACPI: APIC 00000000bf457c18 000E4 (v02 ALASKA    A M I 06222004 MSFT 00010013)
ACPI: MCFG 00000000bf459f18 0003C (v01 A M I  OEMMCFG  06222004 MSFT 00000097)
ACPI: SRAT 00000000bf44fc18 003B0 (v01 A M I  AMI SRAT 00000000 AMI. 00000000)
ACPI: SLIT 00000000bf459e98 00030 (v01 A M I  AMI SLIT 00000000 AMI. 00000000)
ACPI: HPET 00000000bf459e18 00038 (v01 A M I  ICH7HPET 06222004 AMI. 00000003)
ACPI: SPMI 00000000bf459d98 00040 (v05 A M I   OEMSPMI 00000000 AMI. 00000000)
ACPI: EINJ 00000000bf457a98 00130 (v01    AMI AMI EINJ 00000000      00000000)
ACPI: ERST 00000000bf3cac98 00210 (v01  AMIER AMI ERST 00000000      00000000)
ACPI: HEST 00000000bf3caf18 000A8 (v01    AMI AMI HEST 00000000      00000000)
ACPI: BERT 00000000bf459d18 00030 (v01    AMI AMI BERT 00000000      00000000)
ACPI: DMAR 00000000bf458d18 000C0 (v01 A M I   OEMDMAR 00000001 INTL 00000001)
ACPI: Local APIC address 0xfee00000
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 2 -> Node 0
SRAT: PXM 0 -> APIC 4 -> Node 0
SRAT: PXM 0 -> APIC 6 -> Node 0
SRAT: PXM 1 -> APIC 16 -> Node 1
SRAT: PXM 1 -> APIC 18 -> Node 1
SRAT: PXM 1 -> APIC 20 -> Node 1
SRAT: PXM 1 -> APIC 22 -> Node 1
SRAT: Node 0 PXM 0 0-c0000000
SRAT: Node 0 PXM 0 100000000-280000000
SRAT: Node 1 PXM 1 280000000-4c0000000
NUMA: Using 31 for the hash shift.
Bootmem setup node 0 0000000000000000-0000000280000000
  NODE_DATA [0000000000021040 - 000000000005503f]
  bootmap [0000000000100000 -  000000000014ffff] pages 50
(9 early reservations) ==> bootmem [0000000000 - 0280000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0001000000 - 0001c2cf18]    TEXT DATA BSS ==> [0001000000 - 0001c2cf18]
  #3 [003735e000 - 0037fef6ba]          RAMDISK ==> [003735e000 - 0037fef6ba]
  #4 [000009d800 - 0000100000]    BIOS reserved ==> [000009d800 - 0000100000]
  #5 [0001c2d000 - 0001c2d21c]              BRK ==> [0001c2d000 - 0001c2d21c]
  #6 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
  #7 [0000012000 - 0000021000]          PGTABLE ==> [0000012000 - 0000021000]
  #8 [0000021000 - 0000021030]        ACPI SLIT ==> [0000021000 - 0000021030]
Bootmem setup node 1 0000000280000000-00000004c0000000
  NODE_DATA [0000000280000000 - 0000000280033fff]
  bootmap [0000000280034000 -  000000028007bfff] pages 48
(9 early reservations) ==> bootmem [0280000000 - 04c0000000]
  #0 [0000000000 - 0000001000]   BIOS data page
  #1 [0000006000 - 0000008000]       TRAMPOLINE
  #2 [0001000000 - 0001c2cf18]    TEXT DATA BSS
  #3 [003735e000 - 0037fef6ba]          RAMDISK
  #4 [000009d800 - 0000100000]    BIOS reserved
  #5 [0001c2d000 - 0001c2d21c]              BRK
  #6 [0000010000 - 0000012000]          PGTABLE
  #7 [0000012000 - 0000021000]          PGTABLE
  #8 [0000021000 - 0000021030]        ACPI SLIT
found SMP MP-table at [ffff8800000fdf30] fdf30
 [ffffea0000000000-ffffea0008bfffff] PMD ->
[ffff880028600000-ffff8800303fffff] on node 0
 [ffffea0008c00000-ffffea00109fffff] PMD ->
[ffff880280200000-ffff880287ffffff] on node 1
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x004c0000
Movable zone start PFN for each node
early_node_map[5] active PFN ranges
    0: 0x00000010 -> 0x0000009d
    0: 0x00000100 -> 0x000bf349
    0: 0x000bf686 -> 0x000bf800
    0: 0x00100000 -> 0x00280000
    1: 0x00280000 -> 0x004c0000
On node 0 totalpages: 2356304
  DMA zone: 56 pages used for memmap
  DMA zone: 118 pages reserved
  DMA zone: 3807 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 765179 pages, LIFO batch:31
  Normal zone: 21504 pages used for memmap
  Normal zone: 1551360 pages, LIFO batch:31
On node 1 totalpages: 2359296
  Normal zone: 32256 pages used for memmap
  Normal zone: 2327040 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x10] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x12] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x14] enabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x16] enabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x08] disabled)
ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x09] disabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0a] disabled)
ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0b] disabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0c] disabled)
ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0d] disabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0e] disabled)
ACPI: LAPIC (acpi_id[0x10] lapic_id[0x0f] disabled)
ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x02] address[0xfec01000] gsi_base[24])
IOAPIC[1]: apic_id 2, version 32, address 0xfec01000, GSI 24-47
ACPI: IOAPIC (id[0x03] address[0xfec02000] gsi_base[48])
IOAPIC[2]: apic_id 3, version 32, address 0xfec02000, GSI 48-71
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a301 base: 0xfed00000
SMP: Allowing 16 CPUs, 8 hotplug CPUs
nr_irqs_gsi: 72
PM: Registered nosave memory: 000000000009d000 - 000000000009e000
PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
PM: Registered nosave memory: 00000000bf349000 - 00000000bf3ca000
PM: Registered nosave memory: 00000000bf3ca000 - 00000000bf3cb000
PM: Registered nosave memory: 00000000bf3cb000 - 00000000bf3dc000
PM: Registered nosave memory: 00000000bf3dc000 - 00000000bf3dd000
PM: Registered nosave memory: 00000000bf3dd000 - 00000000bf3ee000
PM: Registered nosave memory: 00000000bf3ee000 - 00000000bf3f1000
PM: Registered nosave memory: 00000000bf3f1000 - 00000000bf44f000
PM: Registered nosave memory: 00000000bf44f000 - 00000000bf45a000
PM: Registered nosave memory: 00000000bf45a000 - 00000000bf465000
PM: Registered nosave memory: 00000000bf465000 - 00000000bf483000
PM: Registered nosave memory: 00000000bf483000 - 00000000bf686000
PM: Registered nosave memory: 00000000bf800000 - 00000000c0000000
PM: Registered nosave memory: 00000000c0000000 - 00000000d0000000
PM: Registered nosave memory: 00000000d0000000 - 00000000fed1c000
PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
PM: Registered nosave memory: 00000000fed20000 - 00000000ff000000
PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
Allocating PCI resources starting at d0000000 (gap: d0000000:2ed1c000)
Booting paravirtualized kernel on bare hardware
NR_CPUS:4096 nr_cpumask_bits:16 nr_cpu_ids:16 nr_node_ids:2
PERCPU: Embedded 30 pages/cpu @ffff880028200000 s93016 r8192 d21672 u262144
pcpu-alloc: s93016 r8192 d21672 u262144 alloc=1*2097152
pcpu-alloc: [0] 00 01 02 03 08 10 12 14 [1] 04 05 06 07 09 11 13 15
Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 4647386
Policy zone: Normal
Kernel command line: ro root=/dev/mapper/vg_intels3ea209-lv_root
rd_LVM_LV=vg_intels3ea209/lv_root rd_LVM_LV=vg_intels3ea209/lv_swap
rd_NO_LUKS rd_NO_MD rd_NO_DM LANG=en_US.UTF-8
SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us
console=ttyS0,115200n81 console=tty0 console=ttyS0,115200n81
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
software IO TLB at phys 0x20000000 - 0x24000000
Memory: 18510156k/19922944k available (4936k kernel code, 1060544k
absent, 352244k reserved, 3939k data, 1140k init)
Hierarchical RCU implementation.
NR_IRQS:33024 nr_irqs:1352
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
allocated 188743680 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
hpet clockevent registered
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
Fast TSC calibration using PIT
Detected 2800.188 MHz processor.
Calibrating delay loop (skipped), value calculated using timer
frequency.. 5600.37 BogoMIPS (lpj=2800188)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 9 MCE banks
CPU0: Thermal monitoring enabled (TM1)
using mwait in idle threads.
Performance Events: Nehalem/Corei7 events, Intel PMU driver.
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
ACPI: Core revision 20090903
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 20296 entries in 80 pages
DMAR: Host address width 40
DMAR: DRHD base: 0x000000fe710000 flags: 0x1
IOMMU fe710000: ver 1:0 cap c90780106f0462 ecap f0207e
DMAR: RMRR base: 0x000000bf3f1000 end: 0x000000bf404fff
DMAR: ATSR flags: 0x0
IOAPIC id 0 under DRHD base 0xfe710000
Not all IO-APIC's listed under remapping hardware
Not enable interrupt remapping
Setting APIC routing to physical flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(R) CPU           X5560  @ 2.80GHz stepping 05
Booting Node   0, Processors  #1 #2 #3 Ok.
Booting Node   1, Processors  #4 #5 #6 #7
Brought up 8 CPUs
Total of 8 processors activated (44794.53 BogoMIPS).
Testing NMI watchdog ... OK.
sizeof(vma)=192 bytes
sizeof(page)=56 bytes
sizeof(inode)=592 bytes
sizeof(dentry)=192 bytes
sizeof(ext3inode)=800 bytes
sizeof(buffer_head)=104 bytes
sizeof(skbuff)=232 bytes
sizeof(task_struct)=2608 bytes
devtmpfs: initialized
regulator: core version 0.5
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base c0000000 segment 0 buses 0 - 255
PCI: MCFG area at c0000000 reserved in E820
PCI: Using MMCONFIG at c0000000 - cfffffff
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Executed 1 blocks of module-level executable AML code
ACPI: BIOS _OSI(Linux) query ignored
ACPI: Interpreter enabled
ACPI: (supports S0 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
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
pci 0000:00:13.0: reg 10 32bit mmio: [0xfbf03000-0xfbf03fff]
pci 0000:00:13.0: PME# supported from D0 D3hot D3cold
pci 0000:00:13.0: PME# disabled
pci 0000:00:16.0: reg 10 64bit mmio: [0xfffff1c000-0xfffff1ffff]
pci 0000:00:16.1: reg 10 64bit mmio: [0xfffff18000-0xfffff1bfff]
pci 0000:00:16.2: reg 10 64bit mmio: [0xfffff14000-0xfffff17fff]
pci 0000:00:16.3: reg 10 64bit mmio: [0xfffff10000-0xfffff13fff]
pci 0000:00:16.4: reg 10 64bit mmio: [0xfffff0c000-0xfffff0ffff]
pci 0000:00:16.5: reg 10 64bit mmio: [0xfffff08000-0xfffff0bfff]
pci 0000:00:16.6: reg 10 64bit mmio: [0xfffff04000-0xfffff07fff]
pci 0000:00:16.7: reg 10 64bit mmio: [0xfffff00000-0xfffff03fff]
pci 0000:00:1a.0: reg 20 io port: [0xf0c0-0xf0df]
pci 0000:00:1a.2: reg 20 io port: [0xf0a0-0xf0bf]
pci 0000:00:1a.7: reg 10 32bit mmio: [0xfbf02000-0xfbf023ff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0xf080-0xf09f]
pci 0000:00:1d.1: reg 20 io port: [0xf060-0xf07f]
pci 0000:00:1d.2: reg 20 io port: [0xf040-0xf05f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xfbf01000-0xfbf013ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0600 (mask 00ff)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca0 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0290 (mask 001f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0ca0 (mask 000f)
pci 0000:00:1f.2: reg 10 io port: [0xf110-0xf117]
pci 0000:00:1f.2: reg 14 io port: [0xf100-0xf103]
pci 0000:00:1f.2: reg 18 io port: [0xf0f0-0xf0f7]
pci 0000:00:1f.2: reg 1c io port: [0xf0e0-0xf0e3]
pci 0000:00:1f.2: reg 20 io port: [0xf020-0xf03f]
pci 0000:00:1f.2: reg 24 32bit mmio: [0xfbf00000-0xfbf007ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 10 64bit mmio: [0xfffff20000-0xfffff200ff]
pci 0000:00:1f.3: reg 20 io port: [0xf000-0xf01f]
pci 0000:01:00.0: reg 10 32bit mmio: [0xfbba0000-0xfbbbffff]
pci 0000:01:00.0: reg 14 32bit mmio: [0xfbb80000-0xfbb9ffff]
pci 0000:01:00.0: reg 18 io port: [0xe020-0xe03f]
pci 0000:01:00.0: reg 1c 32bit mmio: [0xfbc44000-0xfbc47fff]
pci 0000:01:00.0: reg 30 32bit mmio pref: [0xfbb60000-0xfbb7ffff]
pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
pci 0000:01:00.0: PME# disabled
pci 0000:01:00.0: reg 184 64bit mmio: [0xfbc20000-0xfbc23fff]
pci 0000:01:00.0: reg 190 64bit mmio: [0xfbc00000-0xfbc03fff]
pci 0000:01:00.1: reg 10 32bit mmio: [0xfbb40000-0xfbb5ffff]
pci 0000:01:00.1: reg 14 32bit mmio: [0xfbb20000-0xfbb3ffff]
pci 0000:01:00.1: reg 18 io port: [0xe000-0xe01f]
pci 0000:01:00.1: reg 1c 32bit mmio: [0xfbc40000-0xfbc43fff]
pci 0000:01:00.1: reg 30 32bit mmio pref: [0xfbb00000-0xfbb1ffff]
pci 0000:01:00.1: PME# supported from D0 D3hot D3cold
pci 0000:01:00.1: PME# disabled
pci 0000:01:00.1: reg 184 64bit mmio: [0xfbbe0000-0xfbbe3fff]
pci 0000:01:00.1: reg 190 64bit mmio: [0xfbbc0000-0xfbbc3fff]
pci 0000:00:01.0: bridge io port: [0xe000-0xefff]
pci 0000:00:01.0: bridge 32bit mmio: [0xfbb00000-0xfbcfffff]
pci 0000:0a:00.0: PXH quirk detected; SHPC device MSI disabled
pci 0000:0a:00.0: PME# supported from D0 D3hot D3cold
pci 0000:0a:00.0: PME# disabled
pci 0000:0a:00.2: PXH quirk detected; SHPC device MSI disabled
pci 0000:0a:00.2: PME# supported from D0 D3hot D3cold
pci 0000:0a:00.2: PME# disabled
pci 0000:0a:00.0: disabling ASPM on pre-1.1 PCIe device.  You can
enable it with 'pcie_aspm=force'
pci 0000:0f:00.0: reg 10 io port: [0xd040-0xd047]
pci 0000:0f:00.0: reg 14 io port: [0xd030-0xd033]
pci 0000:0f:00.0: reg 18 io port: [0xd020-0xd027]
pci 0000:0f:00.0: reg 1c io port: [0xd010-0xd013]
pci 0000:0f:00.0: reg 20 io port: [0xd000-0xd00f]
pci 0000:0f:00.0: reg 30 32bit mmio pref: [0xfbe00000-0xfbe0ffff]
pci 0000:0f:00.0: disabling ASPM on pre-1.1 PCIe device.  You can
enable it with 'pcie_aspm=force'
pci 0000:00:1c.4: bridge io port: [0xd000-0xdfff]
pci 0000:00:1c.4: bridge 32bit mmio: [0xfbe00000-0xfbefffff]
pci 0000:10:01.0: reg 10 32bit mmio pref: [0xf0000000-0xf7ffffff]
pci 0000:10:01.0: reg 14 io port: [0xc000-0xc0ff]
pci 0000:10:01.0: reg 18 32bit mmio: [0xfbd20000-0xfbd2ffff]
pci 0000:10:01.0: reg 30 32bit mmio pref: [0xfbd00000-0xfbd1ffff]
pci 0000:10:01.0: supports D1 D2
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge io port: [0xc000-0xcfff]
pci 0000:00:1e.0: bridge 32bit mmio: [0xfbd00000-0xfbdfffff]
pci 0000:00:1e.0: bridge 64bit mmio pref: [0xf0000000-0xf7ffffff]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE9._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE9.PXHB._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE9.PXHA._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *10 11 12 14 15)
vgaarb: device added: PCI:0000:10:01.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: old code would have set cacheline size to 32 bytes, but clflush_size = 64
PCI: pci_cache_line_size set to 64 bytes
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: iomem range 0xfc000000-0xfcffffff has been reserved
system 00:01: iomem range 0xfd000000-0xfdffffff has been reserved
system 00:01: iomem range 0xfe000000-0xfe9fffff has been reserved
system 00:01: iomem range 0xfea00000-0xfea0001f has been reserved
system 00:01: iomem range 0xfeb00000-0xfebfffff has been reserved
system 00:01: iomem range 0xfed00400-0xfed3ffff could not be reserved
system 00:01: iomem range 0xfed45000-0xfedfffff has been reserved
system 00:02: ioport range 0x290-0x29f has been reserved
system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
system 00:0d: ioport range 0x400-0x47f has been reserved
system 00:0d: ioport range 0x1180-0x119f has been reserved
system 00:0d: ioport range 0x500-0x57f could not be reserved
system 00:0d: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:0d: iomem range 0xfec00000-0xfecfffff could not be reserved
system 00:0d: iomem range 0xff000000-0xffffffff has been reserved
pci 0000:10:01.0: BAR 6: address space collision on of device
[0xfbd00000-0xfbd1ffff]
pci 0000:01:00.0: reg 184 64bit mmio: [0xfbc20000-0xfbc23fff]
pci 0000:01:00.0: reg 190 64bit mmio: [0xfbc00000-0xfbc03fff]
pci 0000:01:00.0: reg 184 64bit mmio: [0xfbc20000-0xfbc23fff]
pci 0000:01:00.1: reg 184 64bit mmio: [0xfbbe0000-0xfbbe3fff]
pci 0000:01:00.0: reg 184 64bit mmio: [0xfbc20000-0xfbc23fff]
pci 0000:01:00.0: reg 190 64bit mmio: [0xfbc00000-0xfbc03fff]
pci 0000:01:00.1: reg 190 64bit mmio: [0xfbbc0000-0xfbbc3fff]
pci 0000:01:00.0: reg 184 64bit mmio: [0xfbc20000-0xfbc23fff]
pci 0000:01:00.0: reg 190 64bit mmio: [0xfbc00000-0xfbc03fff]
pci 0000:01:00.1: reg 184 64bit mmio: [0xfbbe0000-0xfbbe3fff]
pci 0000:01:00.0: reg 184 64bit mmio: [0xfbc20000-0xfbc23fff]
pci 0000:01:00.0: reg 184 64bit mmio: [0xfbc20000-0xfbc23fff]
pci 0000:01:00.0: reg 190 64bit mmio: [0xfbc00000-0xfbc03fff]
pci 0000:01:00.0: reg 190 64bit mmio: [0xfbc00000-0xfbc03fff]
pci 0000:01:00.1: reg 184 64bit mmio: [0xfbbe0000-0xfbbe3fff]
pci 0000:01:00.1: reg 184 64bit mmio: [0xfbbe0000-0xfbbe3fff]
pci 0000:01:00.1: reg 190 64bit mmio: [0xfbbc0000-0xfbbc3fff]
pci 0000:01:00.1: reg 190 64bit mmio: [0xfbbc0000-0xfbbc3fff]
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   bridge window [0xe000-0xefff]
pci 0000:00:01.0:   bridge window [0xfbb00000-0xfbcfffff]
pci 0000:00:01.0:   bridge window [mem pref disabled]
pci 0000:00:02.0: PCI bridge, secondary bus 0000:03
pci 0000:00:02.0:   bridge window [io  disabled]
pci 0000:00:02.0:   bridge window [mem disabled]
pci 0000:00:02.0:   bridge window [mem pref disabled]
pci 0000:00:03.0: PCI bridge, secondary bus 0000:04
pci 0000:00:03.0:   bridge window [io  disabled]
pci 0000:00:03.0:   bridge window [mem disabled]
pci 0000:00:03.0:   bridge window [mem pref disabled]
pci 0000:00:04.0: PCI bridge, secondary bus 0000:05
pci 0000:00:04.0:   bridge window [io  disabled]
pci 0000:00:04.0:   bridge window [mem disabled]
pci 0000:00:04.0:   bridge window [mem pref disabled]
pci 0000:00:05.0: PCI bridge, secondary bus 0000:06
pci 0000:00:05.0:   bridge window [io  disabled]
pci 0000:00:05.0:   bridge window [mem disabled]
pci 0000:00:05.0:   bridge window [mem pref disabled]
pci 0000:00:06.0: PCI bridge, secondary bus 0000:07
pci 0000:00:06.0:   bridge window [io  disabled]
pci 0000:00:06.0:   bridge window [mem disabled]
pci 0000:00:06.0:   bridge window [mem pref disabled]
pci 0000:00:07.0: PCI bridge, secondary bus 0000:08
pci 0000:00:07.0:   bridge window [io  disabled]
pci 0000:00:07.0:   bridge window [mem disabled]
pci 0000:00:07.0:   bridge window [mem pref disabled]
pci 0000:00:08.0: PCI bridge, secondary bus 0000:09
pci 0000:00:08.0:   bridge window [io  disabled]
pci 0000:00:08.0:   bridge window [mem disabled]
pci 0000:00:08.0:   bridge window [mem pref disabled]
pci 0000:0a:00.0: PCI bridge, secondary bus 0000:0b
pci 0000:0a:00.0:   bridge window [io  disabled]
pci 0000:0a:00.0:   bridge window [mem disabled]
pci 0000:0a:00.0:   bridge window [mem pref disabled]
pci 0000:0a:00.2: PCI bridge, secondary bus 0000:0c
pci 0000:0a:00.2:   bridge window [io  disabled]
pci 0000:0a:00.2:   bridge window [mem disabled]
pci 0000:0a:00.2:   bridge window [mem pref disabled]
pci 0000:00:09.0: PCI bridge, secondary bus 0000:0a
pci 0000:00:09.0:   bridge window [io  disabled]
pci 0000:00:09.0:   bridge window [mem disabled]
pci 0000:00:09.0:   bridge window [mem pref disabled]
pci 0000:00:0a.0: PCI bridge, secondary bus 0000:0d
pci 0000:00:0a.0:   bridge window [io  disabled]
pci 0000:00:0a.0:   bridge window [mem disabled]
pci 0000:00:0a.0:   bridge window [mem pref disabled]
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:0e
pci 0000:00:1c.0:   bridge window [0x2000-0x2fff]
pci 0000:00:1c.0:   bridge window [0xd0000000-0xd01fffff]
pci 0000:00:1c.0:   bridge window [0xd0200000-0xd03fffff]
pci 0000:00:1c.4: PCI bridge, secondary bus 0000:0f
pci 0000:00:1c.4:   bridge window [0xd000-0xdfff]
pci 0000:00:1c.4:   bridge window [0xfbe00000-0xfbefffff]
pci 0000:00:1c.4:   bridge window [0xd0400000-0xd05fffff]
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:10
pci 0000:00:1e.0:   bridge window [0xc000-0xcfff]
pci 0000:00:1e.0:   bridge window [0xfbd00000-0xfbdfffff]
pci 0000:00:1e.0:   bridge window [0xf0000000-0xf7ffffff]
  alloc irq_desc for 16 on node -1
  alloc kstat_irqs on node -1
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:02.0: setting latency timer to 64
pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:03.0: setting latency timer to 64
pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:04.0: setting latency timer to 64
pci 0000:00:05.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:05.0: setting latency timer to 64
pci 0000:00:06.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:06.0: setting latency timer to 64
pci 0000:00:07.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:07.0: setting latency timer to 64
pci 0000:00:08.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:08.0: setting latency timer to 64
pci 0000:00:09.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:09.0: setting latency timer to 64
pci 0000:0a:00.0: setting latency timer to 64
pci 0000:0a:00.2: setting latency timer to 64
pci 0000:00:0a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:0a.0: setting latency timer to 64
pci 0000:00:1c.0: enabling device (0000 -> 0003)
  alloc irq_desc for 17 on node -1
  alloc kstat_irqs on node -1
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:01: resource 0 io:  [0xe000-0xefff]
pci_bus 0000:01: resource 1 mem: [0xfbb00000-0xfbcfffff]
pci_bus 0000:0e: resource 0 io:  [0x2000-0x2fff]
pci_bus 0000:0e: resource 1 mem: [0xd0000000-0xd01fffff]
pci_bus 0000:0e: resource 2 pref mem [0xd0200000-0xd03fffff]
pci_bus 0000:0f: resource 0 io:  [0xd000-0xdfff]
pci_bus 0000:0f: resource 1 mem: [0xfbe00000-0xfbefffff]
pci_bus 0000:0f: resource 2 pref mem [0xd0400000-0xd05fffff]
pci_bus 0000:10: resource 0 io:  [0xc000-0xcfff]
pci_bus 0000:10: resource 1 mem: [0xfbd00000-0xfbdfffff]
pci_bus 0000:10: resource 2 pref mem [0xf0000000-0xf7ffffff]
pci_bus 0000:10: resource 3 io:  [0x00-0xffff]
pci_bus 0000:10: resource 4 mem: [0x000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
NET: Registered protocol family 1
pci 0000:00:1a.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
pci 0000:0a:00.0: rerouting interrupts for [8086:0329]
pci 0000:0a:00.2: rerouting interrupts for [8086:032a]
pci 0000:10:01.0: Boot video device
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 12869k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1275538776.785:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 32768
SELinux:  Registering netfilter hooks
alg: No test for stdrng (krng)
ksign: Installing public key data
Loading keyring
- Added public key F2A59B2E15E2141D
- User ID: Red Hat, Inc. (Kernel Module GPG key)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
  alloc irq_desc for 72 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:01.0: irq 72 for MSI/MSI-X
pcieport 0000:00:01.0: setting latency timer to 64
  alloc irq_desc for 73 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:02.0: irq 73 for MSI/MSI-X
pcieport 0000:00:02.0: setting latency timer to 64
  alloc irq_desc for 74 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:03.0: irq 74 for MSI/MSI-X
pcieport 0000:00:03.0: setting latency timer to 64
  alloc irq_desc for 75 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:04.0: irq 75 for MSI/MSI-X
pcieport 0000:00:04.0: setting latency timer to 64
  alloc irq_desc for 76 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:05.0: irq 76 for MSI/MSI-X
pcieport 0000:00:05.0: setting latency timer to 64
  alloc irq_desc for 77 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:06.0: irq 77 for MSI/MSI-X
pcieport 0000:00:06.0: setting latency timer to 64
  alloc irq_desc for 78 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:07.0: irq 78 for MSI/MSI-X
pcieport 0000:00:07.0: setting latency timer to 64
  alloc irq_desc for 79 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:08.0: irq 79 for MSI/MSI-X
pcieport 0000:00:08.0: setting latency timer to 64
  alloc irq_desc for 80 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:09.0: irq 80 for MSI/MSI-X
pcieport 0000:00:09.0: setting latency timer to 64
  alloc irq_desc for 81 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:0a.0: irq 81 for MSI/MSI-X
pcieport 0000:00:0a.0: setting latency timer to 64
  alloc irq_desc for 82 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:1c.0: irq 82 for MSI/MSI-X
pcieport 0000:00:1c.0: setting latency timer to 64
  alloc irq_desc for 83 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:1c.4: irq 83 for MSI/MSI-X
pcieport 0000:00:1c.4: setting latency timer to 64
aer 0000:00:01.0:pcie02: service driver aer loaded
aer 0000:00:02.0:pcie02: service driver aer loaded
aer 0000:00:03.0:pcie02: service driver aer loaded
aer 0000:00:04.0:pcie02: service driver aer loaded
aer 0000:00:05.0:pcie02: service driver aer loaded
aer 0000:00:06.0:pcie02: service driver aer loaded
aer 0000:00:07.0:pcie02: service driver aer loaded
aer 0000:00:08.0:pcie02: service driver aer loaded
aer 0000:00:09.0:pcie02: service driver aer loaded
aer 0000:00:0a.0:pcie02: service driver aer loaded
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp 0000:00:1c.0:pcie04: HPC vendor_id 8086 device_id 3a40 ss_vid 0 ss_did 0
pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
pciehp 0000:00:1c.4:pcie04: HPC vendor_id 8086 device_id 3a48 ss_vid 0 ss_did 0
pciehp 0000:00:1c.4:pcie04: service driver pciehp loaded
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
pci-stub: invalid id string ""
input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button [PWRF]
ACPI: SSDT 00000000bf45b018 01054 (v01    AMI      IST 00000001 MSFT 03000001)
Monitor-Mwait will be used to enter C-3 state
Monitor-Mwait will be used to enter C-3 state
processor LNXCPU:00: registered as cooling_device0
processor LNXCPU:01: registered as cooling_device1
processor LNXCPU:02: registered as cooling_device2
processor LNXCPU:03: registered as cooling_device3
processor LNXCPU:04: registered as cooling_device4
processor LNXCPU:05: registered as cooling_device5
processor LNXCPU:06: registered as cooling_device6
processor LNXCPU:07: registered as cooling_device7
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
crash memory driver: version 1.0
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
brd: module loaded
loop: module loaded
input: Macintosh mouse button emulation as /devices/virtual/input/input3
Fixed MDIO Bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
  alloc irq_desc for 18 on node -1
  alloc kstat_irqs on node -1
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfbf02000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.32-25.el6.x86_64 ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
  alloc irq_desc for 23 on node -1
  alloc kstat_irqs on node -1
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfbf01000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.32-25.el6.x86_64 ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000f0c0
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.32-25.el6.x86_64 uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
  alloc irq_desc for 19 on node -1
  alloc kstat_irqs on node -1
uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1a.2: setting latency timer to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000f0a0
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.32-25.el6.x86_64 uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.2
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000f080
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.32-25.el6.x86_64 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.0
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000f060
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.32-25.el6.x86_64 uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.1
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
usb 1-5: new high speed USB device using ehci_hcd and address 2
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000f040
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.32-25.el6.x86_64 uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.2
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
rtc_cmos 00:08: RTC can wake from S4
rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
No TPM chip found, activating TPM-bypass!
usb 1-5: New USB device found, idVendor=14dd, idProduct=0002
usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-5: Product: Multidevice
usb 1-5: Manufacturer: Peppercon AG
usb 1-5: SerialNumber: 0163a4019e487fc814E72156DB3AC4FA
usb 1-5: configuration #1 chosen from 1 choice
input: Peppercon AG Multidevice as
/devices/pci0000:00/0000:00:1a.7/usb1/1-5/1-5:1.1/input/input4
rtc_cmos 00:08: setting system clock to 2010-06-03 04:19:40 UTC (1275538780)
generic-usb 0003:14DD:0002.0001: input,hidraw0: USB HID v1.01 Mouse
[Peppercon AG Multidevice] on usb-0000:00:1a.7-5/input1
Initalizing network drop monitor service
input: Peppercon AG Multidevice as
/devices/pci0000:00/0000:00:1a.7/usb1/1-5/1-5:1.2/input/input5
Freeing unused kernel memory: 1140k freed
Write protecting the kernel read-only data: 7196k
generic-usb 0003:14DD:0002.0002: input,hidraw1: USB HID v1.01 Keyboard
[Peppercon AG Multidevice] on usb-0000:00:1a.7-5/input2
dracut: dracut-004-19.el6
dracut: rd_NO_LUKS: removing cryptoluks activation
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
udev: starting version 147
[drm] Initialized drm 1.1.0 20060810
[drm] radeon defaulting to kernel modesetting.
[drm] radeon kernel modesetting enabled.
radeon 0000:10:01.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[drm] initializing kernel modesetting (RV100 0x1002:0x515E).
[drm] register mmio base: 0xFBD20000
[drm] register mmio size: 65536
radeon 0000:10:01.0: VRAM: 64M 0xF0000000 - 0xF3FFFFFF (32M used)
radeon 0000:10:01.0: GTT: 512M 0xD0000000 - 0xEFFFFFFF
[drm] radeon: irq initialized.
[drm] Detected VRAM RAM=64M, BAR=128M
[drm] RAM width 16bits DDR
[TTM] Zone  kernel: Available graphics memory: 9262084 kiB.
[TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[drm] radeon: 32M of VRAM memory ready
[drm] radeon: 512M of GTT memory ready.
[drm] GART: num cpu pages 131072, num gpu pages 131072
[drm] Loading R100 Microcode
platform radeon_cp.0: firmware: requesting radeon/R100_cp.bin
[drm] radeon: ring at 0x00000000D0000000
[drm] ring test succeeded in 1 usecs
[drm] radeon: ib pool ready.
[drm] ib test succeeded in 0 usecs
[drm] No TV DAC info found in BIOS
[drm] No valid Ext TMDS info found in BIOS
[drm] Radeon Display Connectors
[drm] Connector 0:
[drm]   VGA
[drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[drm]   Encoders:
[drm]     CRT1: INTERNAL_DAC1
[drm] Connector 1:
[drm]   DVI-I
[drm]   HPD2
[drm]   DDC: 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c
[drm]   Encoders:
[drm]     CRT2: INTERNAL_DAC2
[drm]     DFP2: INTERNAL_DVO1
[drm] fb mappable at 0xF0040000
[drm] vram apper at 0xF0000000
[drm] size 786432
[drm] fb depth is 8
[drm]    pitch is 1024
fbcon: radeondrmfb (fb0) is primary device
Console: switching to colour frame buffer device 128x48
fb0: radeondrmfb frame buffer device
registered panic notifier
[drm] Initialized radeon 2.1.0 20080528 for 0000:10:01.0 on minor 0
dracut: Starting plymouth daemon
dracut: rd_NO_DM: removing DM RAID activation
dracut: rd_NO_MD: removing MD RAID activation
pata_jmicron 0000:0f:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Initializing USB Mass Storage driver...
scsi0 : SCSI emulation for USB Mass Storage devices
  alloc irq_desc for 84 on node -1
  alloc kstat_irqs on node -1
pata_jmicron 0000:0f:00.0: setting latency timer to 64
ahci 0000:00:1f.2: irq 84 for MSI/MSI-X
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
scsi1 : pata_jmicron
ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slum part ccc ems sxs
ahci 0000:00:1f.2: setting latency timer to 64
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usb-storage
scsi2 : pata_jmicron
ata1: PATA max UDMA/100 cmd 0xd040 ctl 0xd030 bmdma 0xd000 irq 16
ata2: PATA max UDMA/100 cmd 0xd020 ctl 0xd010 bmdma 0xd008 irq 16
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
scsi6 : ahci
scsi7 : ahci
scsi8 : ahci
ata3: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 84
ata4: SATA max UDMA/133 abar m2048@0xfbf00000 port 0xfbf00180 irq 84
ata5: SATA max UDMA/133 abar m2048@0xfbf00000 port 0xfbf00200 irq 84
ata6: SATA max UDMA/133 abar m2048@0xfbf00000 port 0xfbf00280 irq 84
ata7: SATA max UDMA/133 abar m2048@0xfbf00000 port 0xfbf00300 irq 84
ata8: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 84
USB Mass Storage support registered.
ata4: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
ata7: SATA link down (SStatus 0 SControl 300)
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATA-6: ST3500320NS, SN04, max UDMA/133
ata3.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata3.00: configured for UDMA/133
scsi 3:0:0:0: Direct-Access     ATA      ST3500320NS      SN04 PQ: 0 ANSI: 5
ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata8.00: ATAPI: SlimtypeDVD A  DS8A1P, CX17, max UDMA/33
ata8.00: applying bridge limits
ata8.00: configured for UDMA/33
scsi 8:0:0:0: CD-ROM            Slimtype DVD A  DS8A1P    CX17 PQ: 0 ANSI: 5
sd 3:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 3:0:0:0: [sda] Write Protect is off
sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2
sd 3:0:0:0: [sda] Attached SCSI disk
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 8:0:0:0: Attached scsi CD-ROM sr0
dracut: Scanning devices sda2  for LVM logical volumes
vg_intels3ea209/lv_root vg_intels3ea209/lv_swap
dracut: inactive '/dev/vg_intels3ea209/lv_root' [50.00 GiB] inherit
dracut: inactive '/dev/vg_intels3ea209/lv_home' [395.60 GiB] inherit
dracut: inactive '/dev/vg_intels3ea209/lv_swap' [19.67 GiB] inherit
EXT4-fs (dm-0): INFO: recovery required on readonly filesystem
EXT4-fs (dm-0): write access will be enabled during recovery
EXT4-fs (dm-0): recovery complete
EXT4-fs (dm-0): mounted filesystem with ordered data mode
dracut: Mounted root filesystem /dev/mapper/vg_intels3ea209-lv_root
dracut: Loading SELinux policy
type=1404 audit(1275538784.696:2): enforcing=1 old_enforcing=0
auid=4294967295 ses=4294967295
SELinux: 2048 avtab hash slots, 196492 rules.
SELinux: 2048 avtab hash slots, 196492 rules.
SELinux:  9 users, 13 roles, 3237 types, 157 bools, 1 sens, 1024 cats
SELinux:  77 classes, 196492 rules
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev dm-0, type ext4), uses xattr
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
type=1403 audit(1275538785.029:3): policy loaded auid=4294967295 ses=4294967295
dracut: Switching root
usb-storage: device scan complete
scsi 0:0:0:0: CD-ROM            PepperC  Virtual Disc 1   0.01 PQ: 0 ANSI: 3
sr1: scsi-1 drive
sr 0:0:0:0: Attached scsi CD-ROM sr1
udev: starting version 147
sd 3:0:0:0: Attached scsi generic sg0 type 0
sr 8:0:0:0: Attached scsi generic sg1 type 5
sr 0:0:0:0: Attached scsi generic sg2 type 5
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
dca service started, version 1.12.1
Intel(R) Gigabit Ethernet Network Driver - version 2.1.0-k2
Copyright (c) 2007-2009 Intel Corporation.
igb 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
igb 0000:01:00.0: setting latency timer to 64
  alloc irq_desc for 85 on node -1
  alloc kstat_irqs on node -1
igb 0000:01:00.0: irq 85 for MSI/MSI-X
  alloc irq_desc for 86 on node -1
  alloc kstat_irqs on node -1
igb 0000:01:00.0: irq 86 for MSI/MSI-X
  alloc irq_desc for 87 on node -1
  alloc kstat_irqs on node -1
igb 0000:01:00.0: irq 87 for MSI/MSI-X
  alloc irq_desc for 88 on node -1
  alloc kstat_irqs on node -1
igb 0000:01:00.0: irq 88 for MSI/MSI-X
  alloc irq_desc for 89 on node -1
  alloc kstat_irqs on node -1
igb 0000:01:00.0: irq 89 for MSI/MSI-X
  alloc irq_desc for 90 on node -1
  alloc kstat_irqs on node -1
igb 0000:01:00.0: irq 90 for MSI/MSI-X
  alloc irq_desc for 91 on node -1
  alloc kstat_irqs on node -1
igb 0000:01:00.0: irq 91 for MSI/MSI-X
  alloc irq_desc for 92 on node -1
  alloc kstat_irqs on node -1
igb 0000:01:00.0: irq 92 for MSI/MSI-X
  alloc irq_desc for 93 on node -1
  alloc kstat_irqs on node -1
igb 0000:01:00.0: irq 93 for MSI/MSI-X
igb 0000:01:00.0: 0 vfs allocated
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
iTCO_wdt: Found a ICH10R TCO device (Version=2, TCOBASE=0x0460)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x4) 00:30:48:c6:d7:84
igb 0000:01:00.0: eth0: PBA No: 0010ff-0ff
igb 0000:01:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
igb 0000:01:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
igb 0000:01:00.1: setting latency timer to 64
  alloc irq_desc for 94 on node -1
  alloc kstat_irqs on node -1
igb 0000:01:00.1: irq 94 for MSI/MSI-X
  alloc irq_desc for 95 on node -1
  alloc kstat_irqs on node -1
igb 0000:01:00.1: irq 95 for MSI/MSI-X
  alloc irq_desc for 96 on node -1
  alloc kstat_irqs on node -1
igb 0000:01:00.1: irq 96 for MSI/MSI-X
  alloc irq_desc for 97 on node -1
  alloc kstat_irqs on node -1
igb 0000:01:00.1: irq 97 for MSI/MSI-X
  alloc irq_desc for 98 on node -1
  alloc kstat_irqs on node -1
igb 0000:01:00.1: irq 98 for MSI/MSI-X
  alloc irq_desc for 99 on node -1
  alloc kstat_irqs on node -1
igb 0000:01:00.1: irq 99 for MSI/MSI-X
  alloc irq_desc for 100 on node -1
  alloc kstat_irqs on node -1
igb 0000:01:00.1: irq 100 for MSI/MSI-X
  alloc irq_desc for 101 on node -1
  alloc kstat_irqs on node -1
igb 0000:01:00.1: irq 101 for MSI/MSI-X
  alloc irq_desc for 102 on node -1
  alloc kstat_irqs on node -1
igb 0000:01:00.1: irq 102 for MSI/MSI-X
igb 0000:01:00.1: 0 vfs allocated
igb 0000:01:00.1: Intel(R) Gigabit Ethernet Network Connection
igb 0000:01:00.1: eth1: (PCIe:2.5Gb/s:Width x4) 00:30:48:c6:d7:85
igb 0000:01:00.1: eth1: PBA No: 0010ff-0ff
igb 0000:01:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
ioatdma: Intel(R) QuickData Technology Driver 4.00
ioatdma 0000:00:16.0: can't derive routing for PCI INT A
ioatdma 0000:00:16.0: PCI INT A: no GSI
ioatdma 0000:00:16.0: setting latency timer to 64
  alloc irq_desc for 103 on node -1
  alloc kstat_irqs on node -1
ioatdma 0000:00:16.0: irq 103 for MSI/MSI-X
igb 0000:01:00.0: DCA enabled
igb 0000:01:00.1: DCA enabled
ioatdma 0000:00:16.1: can't derive routing for PCI INT B
ioatdma 0000:00:16.1: PCI INT B: no GSI
ioatdma 0000:00:16.1: setting latency timer to 64
  alloc irq_desc for 104 on node -1
  alloc kstat_irqs on node -1
ioatdma 0000:00:16.1: irq 104 for MSI/MSI-X
ioatdma 0000:00:16.2: can't derive routing for PCI INT C
ioatdma 0000:00:16.2: PCI INT C: no GSI
ioatdma 0000:00:16.2: setting latency timer to 64
  alloc irq_desc for 105 on node -1
  alloc kstat_irqs on node -1
ioatdma 0000:00:16.2: irq 105 for MSI/MSI-X
ioatdma 0000:00:16.3: can't derive routing for PCI INT D
ioatdma 0000:00:16.3: PCI INT D: no GSI
ioatdma 0000:00:16.3: setting latency timer to 64
  alloc irq_desc for 106 on node -1
  alloc kstat_irqs on node -1
ioatdma 0000:00:16.3: irq 106 for MSI/MSI-X
ioatdma 0000:00:16.4: can't derive routing for PCI INT A
ioatdma 0000:00:16.4: PCI INT A: no GSI
ioatdma 0000:00:16.4: setting latency timer to 64
  alloc irq_desc for 107 on node -1
  alloc kstat_irqs on node -1
ioatdma 0000:00:16.4: irq 107 for MSI/MSI-X
ioatdma 0000:00:16.5: can't derive routing for PCI INT B
ioatdma 0000:00:16.5: PCI INT B: no GSI
ioatdma 0000:00:16.5: setting latency timer to 64
  alloc irq_desc for 108 on node -1
  alloc kstat_irqs on node -1
ioatdma 0000:00:16.5: irq 108 for MSI/MSI-X
ioatdma 0000:00:16.6: can't derive routing for PCI INT C
ioatdma 0000:00:16.6: PCI INT C: no GSI
ioatdma 0000:00:16.6: setting latency timer to 64
  alloc irq_desc for 109 on node -1
  alloc kstat_irqs on node -1
ioatdma 0000:00:16.6: irq 109 for MSI/MSI-X
ioatdma 0000:00:16.7: can't derive routing for PCI INT D
ioatdma 0000:00:16.7: PCI INT D: no GSI
ioatdma 0000:00:16.7: setting latency timer to 64
  alloc irq_desc for 110 on node -1
  alloc kstat_irqs on node -1
ioatdma 0000:00:16.7: irq 110 for MSI/MSI-X
CE: hpet increasing min_delta_ns to 15000 nsec
EXT4-fs (sda1): mounted filesystem with ordered data mode
SELinux: initialized (dev sda1, type ext4), uses xattr
EXT4-fs (dm-2): mounted filesystem with ordered data mode
SELinux: initialized (dev dm-2, type ext4), uses xattr
Adding 20627448k swap on /dev/mapper/vg_intels3ea209-lv_swap.
Priority:-1 extents:1 across:20627448k
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
microcode: CPU0 sig=0x106a5, pf=0x1, revision=0x9
platform microcode: firmware: requesting intel-ucode/06-1a-05
microcode: CPU1 sig=0x106a5, pf=0x1, revision=0x9
platform microcode: firmware: requesting intel-ucode/06-1a-05
microcode: CPU2 sig=0x106a5, pf=0x1, revision=0x9
platform microcode: firmware: requesting intel-ucode/06-1a-05
microcode: CPU3 sig=0x106a5, pf=0x1, revision=0x9
platform microcode: firmware: requesting intel-ucode/06-1a-05
microcode: CPU4 sig=0x106a5, pf=0x1, revision=0x9
platform microcode: firmware: requesting intel-ucode/06-1a-05
microcode: CPU5 sig=0x106a5, pf=0x1, revision=0x9
platform microcode: firmware: requesting intel-ucode/06-1a-05
microcode: CPU6 sig=0x106a5, pf=0x1, revision=0x9
platform microcode: firmware: requesting intel-ucode/06-1a-05
microcode: CPU7 sig=0x106a5, pf=0x1, revision=0x9
platform microcode: firmware: requesting intel-ucode/06-1a-05
Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
microcode: CPU0 updated to revision 0x11, date = 2009-04-14
microcode: CPU1 updated to revision 0x11, date = 2009-04-14
microcode: CPU2 updated to revision 0x11, date = 2009-04-14
microcode: CPU3 updated to revision 0x11, date = 2009-04-14
microcode: CPU4 updated to revision 0x11, date = 2009-04-14
microcode: CPU5 updated to revision 0x11, date = 2009-04-14
microcode: CPU6 updated to revision 0x11, date = 2009-04-14
microcode: CPU7 updated to revision 0x11, date = 2009-04-14
Microcode Update Driver: v2.00 removed.
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
igb: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
eth0: no IPv6 routers present
eth1: no IPv6 routers present
