Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149Ab1CXS1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:27:54 -0400
Received: from the.earth.li ([46.43.34.31]:40069 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756967Ab1CXS1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:27:52 -0400
Date: Thu, 24 Mar 2011 11:27:51 -0700
From: Jonathan McDowell <noodles@earth.li>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Re-add quirk for ServerWorks bridge secondary buses
Message-ID: <20110324182751.GC4835@earth.li>
References: <20110324043652.GA4835@earth.li>
 <AANLkTikiZ_JYUcobRF6T_=DMXCc=Em8f1U_eD_rQRSRu@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <AANLkTikiZ_JYUcobRF6T_=DMXCc=Em8f1U_eD_rQRSRu@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 23, 2011 at 10:50:20PM -0700, Bjorn Helgaas wrote:
> On Wed, Mar 23, 2011 at 9:36 PM, Jonathan McDowell <noodles@earth.li> wrote:
> > I have a board with a ServerWorks CIOB-X2 bridge on it (2 in fact) that
> > is not having the secondary buses off it correctly discovered with
> > 2.6.38.
> 
> Is this a regression?  If so, what is the newest kernel that still
> worked? 

No, it's not strictly a regression; it's never worked without a patch
similar to this under 2.6. I'm trying to get us moved to a more recent
2.6 and working out what the minimal set patches are necessary against
mainline for that to work.

> Can you include a dmesg log?

Sure, attached.

> I assume that since you don't have a standard BIOS, you don't have
> ACPI?

Nope. Nor DMI. As previously mentioned there is a custom ASIC, but it's
hidden behind these bridges.

J.

-- 
                                            xmpp:noodles@earth.li
"A real revolution begins at learning. If you're not angry, you're
not paying attention." -- Tim McGrath

--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="2.6.38-dmesg"

Linux version 2.6.38-3pardata-dirty (noodles@thukpa) (gcc version 4.5.2 (Debian 4.5.2-4) ) #8 SMP Thu Mar 24 11:12:35 PDT 2011
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000a0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000080000000 (usable)
Notice: NX (Execute Disable) protection missing in CPU!
DMI not present or invalid.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
last_pfn = 0x80000 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges disabled:
  00000-FFFFF uncachable
MTRR variable ranges enabled:
  0 base 000000000 mask F80000000 write-back
  1 base 0FFC00000 mask FFFF80000 write-combining
  2 base 0FFE00000 mask FFFE00000 write-protect
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
found SMP MP-table at [400f2da0] f2da0
initial memory mapped : 0 - 01c00000
init_memory_mapping: 0000000000000000-0000000080000000
 0000000000 - 0000400000 page 4k
 0000400000 - 0080000000 page 2M
kernel direct mapping tables up to 80000000 @ 1bfc000-1c00000
0MB HIGHMEM available.
2048MB LOWMEM available.
  mapped low ram: 0 - 80000000
  low ram: 0 - 80000000
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x00080000
  HighMem  empty
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x000000a0
    0: 0x00000100 -> 0x00080000
On node 0 totalpages: 524176
free_area_init_node: node 0, pgdat 413d0f00, node_mem_map befff200
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3952 pages, LIFO batch:0
  Normal zone: 4064 pages used for memmap
  Normal zone: 516128 pages, LIFO batch:31
Using APIC driver default
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
MPTABLE: OEM ID: 3PAR    
MPTABLE: Product ID: S800X       
MPTABLE: APIC at: 0xFEE00000
Processor #0 (Bootup-CPU)
Processor #1
Processor #6
Processor #7
IOAPIC[0]: apic_id 8, version 17, address 0xfec00000, GSI 0-15
IOAPIC[1]: apic_id 9, version 17, address 0xfec01000, GSI 16-31
IOAPIC[2]: apic_id 10, version 17, address 0xfec02000, GSI 32-47
IOAPIC[3]: apic_id 11, version 17, address 0xfec03000, GSI 48-63
Processors: 4
SMP: Allowing 4 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 80
Allocating PCI resources starting at 80000000 (gap: 80000000:80000000)
setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Embedded 12 pages/cpu @be800000 s26368 r0 d22784 u1048576
pcpu-alloc: s26368 r0 d22784 u1048576 alloc=1*4194304
pcpu-alloc: [0] 0 1 2 3 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 520080
Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.38 root=/dev/sda3 console=ttyS0,57600 panic=30 ro
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 262144 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 131072 (order: 7, 524288 bytes)
Initializing CPU#0
Initializing HighMem for node 0 (00000000:00000000)
Memory: 2073844k/2097152k available (2689k kernel code, 22860k reserved, 1248k data, 296k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff18000 - 0xfffff000   ( 924 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xc0800000 - 0xff7fe000   (1007 MB)
    lowmem  : 0x40000000 - 0xc0000000   (2048 MB)
      .init : 0x413d9000 - 0x41423000   ( 296 kB)
      .data : 0x412a0594 - 0x413d8600   (1248 kB)
      .text : 0x41000000 - 0x412a0594   (2689 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Hierarchical RCU implementation.
NR_IRQS:2304 nr_irqs:1024 16
CPU 0 irqstacks, hard=be408000 soft=be40a000
console [ttyS0] enabled
Fast TSC calibration using PIT
Detected 2395.593 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 4791.18 BogoMIPS (lpj=9582372)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 4 MCE banks
CPU0: Thermal monitoring enabled (TM1)
Freeing SMP alternatives: 16k freed
Enabling APIC mode:  Flat.  Using 4 I/O APICs
..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
..MP-BIOS bug: 8254 timer not connected to IO-APIC
...trying to set up timer (IRQ0) through the 8259A ...
..... (found apic 0 pin 0) ...
....... works.
CPU0: Intel(R) Xeon(TM) CPU 2.40GHz stepping 09
Performance Events: Netburst events, Netburst P4/Xeon PMU driver.
... version:                0
... bit width:              40
... generic registers:      18
... value mask:             000000ffffffffff
... max period:             0000007fffffffff
... fixed-purpose events:   0
... event mask:             000000000003ffff
CPU 1 irqstacks, hard=be46e000 soft=be470000
Booting Node   0, Processors  #1
Initializing CPU#1
CPU1: Thermal monitoring handled by SMI
CPU 2 irqstacks, hard=be47c000 soft=be47e000
 #2
Initializing CPU#2
CPU 3 irqstacks, hard=be48a000 soft=be48c000
 #3 Ok.
Initializing CPU#3
CPU3: Thermal monitoring handled by SMI
Brought up 4 CPUs
Total of 4 processors activated (19164.23 BogoMIPS).
NET: Registered protocol family 16
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
pci 0000:00:00.0: [1166:0014] type 0 class 0x000600
pci 0000:00:00.1: [1166:0014] type 0 class 0x000600
pci 0000:00:00.2: [1166:0014] type 0 class 0x000600
pci 0000:00:01.0: [8086:1209] type 0 class 0x000200
pci 0000:00:01.0: reg 10: [mem 0xe0000000-0xe0000fff]
pci 0000:00:01.0: reg 14: [io  0x1000-0x103f]
pci 0000:00:01.0: reg 18: [mem 0xe0020000-0xe003ffff]
pci 0000:00:01.0: supports D1 D2
pci 0000:00:01.0: PME# supported from D0 D1 D2 D3hot
pci 0000:00:01.0: PME# disabled
pci 0000:00:02.0: [13a8:0158] type 0 class 0x000700
pci 0000:00:02.0: reg 10: [mem 0xe0040000-0xe0040fff]
pci 0000:00:03.0: [8086:1209] type 0 class 0x000200
pci 0000:00:03.0: reg 10: [mem 0xe0041000-0xe0041fff]
pci 0000:00:03.0: reg 14: [io  0x1040-0x107f]
pci 0000:00:03.0: reg 18: [mem 0xe0060000-0xe007ffff]
pci 0000:00:03.0: supports D1 D2
pci 0000:00:03.0: PME# supported from D0 D1 D2 D3hot
pci 0000:00:03.0: PME# disabled
pci 0000:00:0f.0: [1166:0201] type 0 class 0x000601
pci 0000:00:0f.1: [1166:0212] type 0 class 0x000101
pci 0000:00:0f.1: reg 10: [io  0x1080-0x1087]
pci 0000:00:0f.1: reg 14: [io  0x1088-0x108b]
pci 0000:00:0f.1: reg 18: [io  0x1090-0x1097]
pci 0000:00:0f.1: reg 1c: [io  0x1098-0x109b]
pci 0000:00:0f.1: reg 20: [io  0x10a0-0x10af]
pci 0000:00:0f.3: [1166:0225] type 0 class 0x000601
pci 0000:00:11.0: [1166:0101] type 0 class 0x000600
pci 0000:00:11.0: ServerWorks host bridge: last bus 05
pci 0000:00:11.2: [1166:0101] type 0 class 0x000600
pci 0000:00:11.2: ServerWorks host bridge: last bus 09
PCI: Discovered peer bus 01
pci 0000:01:01.0: [1590:0001] type 0 class 0x00ff00
pci 0000:01:01.0: reg 10: [mem 0xe0100000-0xe01003ff]
pci 0000:01:01.0: reg 14: [mem 0xc0000000-0xdfffffff pref]
pci 0000:01:01.0: reg 18: can't handle 64-bit BAR
pci 0000:01:02.0: [8086:b154] type 1 class 0x000604
pci 0000:01:03.0: [8086:b154] type 1 class 0x000604
pci 0000:01:02.0: PCI bridge to [bus 02-02]
pci 0000:01:02.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:01:02.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:01:02.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:03:01.0: [1011:0026] type 1 class 0x000604
pci 0000:03:02.0: [1011:0026] type 1 class 0x000604
pci 0000:01:03.0: PCI bridge to [bus 03-05]
pci 0000:01:03.0:   bridge window [io  0x2000-0x3fff]
pci 0000:01:03.0:   bridge window [mem 0xe0200000-0xe03fffff]
pci 0000:01:03.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:04:04.0: [1077:2300] type 0 class 0x000c04
pci 0000:04:04.0: reg 10: [io  0x2000-0x20ff]
pci 0000:04:04.0: reg 14: [mem 0xe0200000-0xe0200fff]
pci 0000:04:04.0: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:04:05.0: [1077:2300] type 0 class 0x000c04
pci 0000:04:05.0: reg 10: [io  0x2100-0x21ff]
pci 0000:04:05.0: reg 14: [mem 0xe0201000-0xe0201fff]
pci 0000:04:05.0: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:03:01.0: PCI bridge to [bus 04-04]
pci 0000:03:01.0:   bridge window [io  0x2000-0x2fff]
pci 0000:03:01.0:   bridge window [mem 0xe0200000-0xe02fffff]
pci 0000:03:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:05:04.0: [1077:2300] type 0 class 0x000c04
pci 0000:05:04.0: reg 10: [io  0x3000-0x30ff]
pci 0000:05:04.0: reg 14: [mem 0xe0300000-0xe0300fff]
pci 0000:05:04.0: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:05:05.0: [1077:2300] type 0 class 0x000c04
pci 0000:05:05.0: reg 10: [io  0x3100-0x31ff]
pci 0000:05:05.0: reg 14: [mem 0xe0301000-0xe0301fff]
pci 0000:05:05.0: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:03:02.0: PCI bridge to [bus 05-05]
pci 0000:03:02.0:   bridge window [io  0x3000-0x3fff]
pci 0000:03:02.0:   bridge window [mem 0xe0300000-0xe03fffff]
pci 0000:03:02.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
PCI: Discovered peer bus 06
pci 0000:06:01.0: [1590:0001] type 0 class 0x00ff00
pci 0000:06:01.0: reg 10: [mem 0xe0400000-0xe04003ff]
pci 0000:06:01.0: reg 14: [mem 0xc0000000-0xdfffffff pref]
pci 0000:06:01.0: reg 18: can't handle 64-bit BAR
pci 0000:06:02.0: [8086:b154] type 1 class 0x000604
pci 0000:06:03.0: [8086:b154] type 1 class 0x000604
pci 0000:07:01.0: [8086:b154] type 1 class 0x000604
pci 0000:06:02.0: PCI bridge to [bus 07-08]
pci 0000:06:02.0:   bridge window [io  0x4000-0x4fff]
pci 0000:06:02.0:   bridge window [mem 0xe0500000-0xe05fffff]
pci 0000:06:02.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:08:04.0: [1000:0622] type 0 class 0x000c04
pci 0000:08:04.0: reg 10: [io  0x4000-0x40ff]
pci 0000:08:04.0: reg 14: [mem 0xe0500000-0xe050ffff 64bit]
pci 0000:08:04.0: reg 1c: [mem 0xe0510000-0xe051ffff 64bit]
pci 0000:08:04.0: reg 30: [mem 0x00000000-0x000fffff pref]
pci 0000:08:04.1: [1000:0622] type 0 class 0x000c04
pci 0000:08:04.1: reg 10: [io  0x4100-0x41ff]
pci 0000:08:04.1: reg 14: [mem 0xe0520000-0xe052ffff 64bit]
pci 0000:08:04.1: reg 1c: [mem 0xe0530000-0xe053ffff 64bit]
pci 0000:08:04.1: reg 30: [mem 0x00000000-0x000fffff pref]
pci 0000:08:06.0: [1000:0622] type 0 class 0x000c04
pci 0000:08:06.0: reg 10: [io  0x4200-0x42ff]
pci 0000:08:06.0: reg 14: [mem 0xe0540000-0xe054ffff 64bit]
pci 0000:08:06.0: reg 1c: [mem 0xe0550000-0xe055ffff 64bit]
pci 0000:08:06.0: reg 30: [mem 0x00000000-0x000fffff pref]
pci 0000:08:06.1: [1000:0622] type 0 class 0x000c04
pci 0000:08:06.1: reg 10: [io  0x4300-0x43ff]
pci 0000:08:06.1: reg 14: [mem 0xe0560000-0xe056ffff 64bit]
pci 0000:08:06.1: reg 1c: [mem 0xe0570000-0xe057ffff 64bit]
pci 0000:08:06.1: reg 30: [mem 0x00000000-0x000fffff pref]
pci 0000:07:01.0: PCI bridge to [bus 08-08]
pci 0000:07:01.0:   bridge window [io  0x4000-0x4fff]
pci 0000:07:01.0:   bridge window [mem 0xe0500000-0xe05fffff]
pci 0000:07:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:06:03.0: PCI bridge to [bus 09-09]
pci 0000:06:03.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:06:03.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:06:03.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
PCI: pci_cache_line_size set to 64 bytes
pci 0000:06:01.0: address space collision: [mem 0xc0000000-0xdfffffff pref] conflicts with 0000:01:01.0 [mem 0xc0000000-0xdfffffff pref]
pci 0000:01:03.0: BAR 9: assigned [mem 0x80000000-0x801fffff pref]
pci 0000:01:02.0: PCI bridge to [bus 02-02]
pci 0000:01:02.0:   bridge window [io  disabled]
pci 0000:01:02.0:   bridge window [mem disabled]
pci 0000:01:02.0:   bridge window [mem pref disabled]
pci 0000:03:01.0: BAR 9: assigned [mem 0x80000000-0x800fffff pref]
pci 0000:03:02.0: BAR 9: assigned [mem 0x80100000-0x801fffff pref]
pci 0000:04:04.0: BAR 6: assigned [mem 0x80000000-0x8001ffff pref]
pci 0000:04:05.0: BAR 6: assigned [mem 0x80020000-0x8003ffff pref]
pci 0000:03:01.0: PCI bridge to [bus 04-04]
pci 0000:03:01.0:   bridge window [io  0x2000-0x2fff]
pci 0000:03:01.0:   bridge window [mem 0xe0200000-0xe02fffff]
pci 0000:03:01.0:   bridge window [mem 0x80000000-0x800fffff pref]
pci 0000:05:04.0: BAR 6: assigned [mem 0x80100000-0x8011ffff pref]
pci 0000:05:05.0: BAR 6: assigned [mem 0x80120000-0x8013ffff pref]
pci 0000:03:02.0: PCI bridge to [bus 05-05]
pci 0000:03:02.0:   bridge window [io  0x3000-0x3fff]
pci 0000:03:02.0:   bridge window [mem 0xe0300000-0xe03fffff]
pci 0000:03:02.0:   bridge window [mem 0x80100000-0x801fffff pref]
pci 0000:01:03.0: PCI bridge to [bus 03-05]
pci 0000:01:03.0:   bridge window [io  0x2000-0x3fff]
pci 0000:01:03.0:   bridge window [mem 0xe0200000-0xe03fffff]
pci 0000:01:03.0:   bridge window [mem 0x80000000-0x801fffff pref]
pci 0000:06:01.0: BAR 1: assigned [mem 0xa0000000-0xbfffffff pref]
pci 0000:06:01.0: BAR 1: set to [mem 0xa0000000-0xbfffffff pref] (PCI address [0xa0000000-0xbfffffff])
pci 0000:06:02.0: BAR 9: assigned [mem 0x80200000-0x805fffff pref]
pci 0000:07:01.0: BAR 9: assigned [mem 0x80200000-0x805fffff pref]
pci 0000:08:04.0: BAR 6: assigned [mem 0x80200000-0x802fffff pref]
pci 0000:08:04.1: BAR 6: assigned [mem 0x80300000-0x803fffff pref]
pci 0000:08:06.0: BAR 6: assigned [mem 0x80400000-0x804fffff pref]
pci 0000:08:06.1: BAR 6: assigned [mem 0x80500000-0x805fffff pref]
pci 0000:07:01.0: PCI bridge to [bus 08-08]
pci 0000:07:01.0:   bridge window [io  0x4000-0x4fff]
pci 0000:07:01.0:   bridge window [mem 0xe0500000-0xe05fffff]
pci 0000:07:01.0:   bridge window [mem 0x80200000-0x805fffff pref]
pci 0000:06:02.0: PCI bridge to [bus 07-08]
pci 0000:06:02.0:   bridge window [io  0x4000-0x4fff]
pci 0000:06:02.0:   bridge window [mem 0xe0500000-0xe05fffff]
pci 0000:06:02.0:   bridge window [mem 0x80200000-0x805fffff pref]
pci 0000:06:03.0: PCI bridge to [bus 09-09]
pci 0000:06:03.0:   bridge window [io  disabled]
pci 0000:06:03.0:   bridge window [mem disabled]
pci 0000:06:03.0:   bridge window [mem pref disabled]
pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
pci_bus 0000:01: resource 0 [io  0x0000-0xffff]
pci_bus 0000:01: resource 1 [mem 0x00000000-0xffffffff]
pci_bus 0000:03: resource 0 [io  0x2000-0x3fff]
pci_bus 0000:03: resource 1 [mem 0xe0200000-0xe03fffff]
pci_bus 0000:03: resource 2 [mem 0x80000000-0x801fffff pref]
pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:04: resource 1 [mem 0xe0200000-0xe02fffff]
pci_bus 0000:04: resource 2 [mem 0x80000000-0x800fffff pref]
pci_bus 0000:05: resource 0 [io  0x3000-0x3fff]
pci_bus 0000:05: resource 1 [mem 0xe0300000-0xe03fffff]
pci_bus 0000:05: resource 2 [mem 0x80100000-0x801fffff pref]
pci_bus 0000:06: resource 0 [io  0x0000-0xffff]
pci_bus 0000:06: resource 1 [mem 0x00000000-0xffffffff]
pci_bus 0000:07: resource 0 [io  0x4000-0x4fff]
pci_bus 0000:07: resource 1 [mem 0xe0500000-0xe05fffff]
pci_bus 0000:07: resource 2 [mem 0x80200000-0x805fffff pref]
pci_bus 0000:08: resource 0 [io  0x4000-0x4fff]
pci_bus 0000:08: resource 1 [mem 0xe0500000-0xe05fffff]
pci_bus 0000:08: resource 2 [mem 0x80200000-0x805fffff pref]
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 6, 262144 bytes)
TCP established hash table entries: 262144 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
UDP hash table entries: 1024 (order: 3, 32768 bytes)
UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
NET: Registered protocol family 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
pci 0000:00:01.0: Firmware left e100 interrupts enabled; disabling
PCI: CLS mismatch (64 != 32), using 64 bytes
pci 0000:00:03.0: Firmware left e100 interrupts enabled; disabling
platform rtc_cmos: registered platform RTC device (no PNP device found)
microcode: CPU0 sig=0xf29, pf=0x2, revision=0x2d
microcode: CPU1 sig=0xf29, pf=0x2, revision=0x2d
microcode: CPU2 sig=0xf29, pf=0x2, revision=0x2d
microcode: CPU3 sig=0xf29, pf=0x2, revision=0x2d
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
msgmni has been set to 4050
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
Serial: 8250/16550 driver, 12 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a NS16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
serial 0000:00:02.0: PCI->APIC IRQ transform: INT A -> IRQ 19
0000:00:02.0: ttyS4 at MMIO 0xe0040000 (irq = 19) is a XScale
0000:00:02.0: ttyS5 at MMIO 0xe0040200 (irq = 19) is a XScale
0000:00:02.0: ttyS6 at MMIO 0xe0040400 (irq = 19) is a XScale
0000:00:02.0: ttyS7 at MMIO 0xe0040600 (irq = 19) is a XScale
0000:00:02.0: ttyS8 at MMIO 0xe0040800 (irq = 19) is a XScale
0000:00:02.0: ttyS9 at MMIO 0xe0040a00 (irq = 19) is a XScale
0000:00:02.0: ttyS10 at MMIO 0xe0040c00 (irq = 19) is a XScale
0000:00:02.0: ttyS11 at MMIO 0xe0040e00 (irq = 19) is a U6_16550A
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
brd: module loaded
scsi0 : pata_serverworks
scsi1 : pata_serverworks
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x10a0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x10a8 irq 15
e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
e1000: Copyright (c) 1999-2006 Intel Corporation.
e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
e100 0000:00:01.0: PCI->APIC IRQ transform: INT A -> IRQ 18
e100 0000:00:01.0: PME# disabled
e100 0000:00:01.0: eth0: addr 0xe0000000, irq 18, MAC addr 00:02:ac:25:0c:8b
e100 0000:00:03.0: PCI->APIC IRQ transform: INT A -> IRQ 44
ata1.00: ATA-7: HDS728080PLAT20, PF2OA2AA, max UDMA/133
ata1.00: 160836480 sectors, multi 0: LBA48 
ata1.00: limited to UDMA/33 due to 40-wire cable
e100 0000:00:03.0: PME# disabled
e100 0000:00:03.0: eth1: addr 0xe0041000, irq 44, MAC addr 00:02:ac:2d:0c:8b
rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one day, 114 bytes nvram
ata1.00: configured for UDMA/33
piix4_smbus 0000:00:0f.0: SMBus Host Controller at 0x580, revision 0
scsi 0:0:0:0: Direct-Access     ATA      HDS728080PLAT20  PF2O PQ: 0 ANSI: 5
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] 160836480 512-byte logical blocks: (82.3 GB/76.6 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
cpuidle: using governor ladder
cpuidle: using governor menu
oprofile: using NMI interrupt.
ip_tables: (C) 2000-2006 Netfilter Core Team
arp_tables: (C) 2002 David S. Miller
TCP cubic registered
NET: Registered protocol family 10
sd 0:0:0:0: [sda] Attached SCSI disk
ip6_tables: (C) 2000-2006 Netfilter Core Team
NET: Registered protocol family 17
Using IPI Shortcut mode
rtc_cmos rtc_cmos: setting system clock to 2011-03-24 18:18:53 UTC (1300990733)
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda3): mounted filesystem with ordered data mode
VFS: Mounted root (ext3 filesystem) readonly on device 8:3.
Freeing unused kernel memory: 296k freed
Write protecting the kernel text: 2692k
Write protecting the kernel read-only data: 1080k

--ZPt4rx8FFjLCG7dd--
