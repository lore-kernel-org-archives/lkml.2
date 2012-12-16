Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab2LPNZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 08:25:29 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:42529 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab2LPNZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 08:25:26 -0500
Date: Sun, 16 Dec 2012 14:25:21 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86/uapi for 3.8
Message-ID: <20121216132521.GA251@x4>
References: <201212122211.qBCMBRxl027895@terminus.zytor.com>
 <23916.1355356085@warthog.procyon.org.uk>
 <CA+55aFwBh3SY-K_dqdjpqyiBE+_PzbjMc=Qnt-QU9LNaK325TA@mail.gmail.com>
 <21507.1355528749@warthog.procyon.org.uk>
 <CA+55aFw34Nwi_aNjN-jm4SHkvT5659_aNVVmvARTCg5=9K0cZg@mail.gmail.com>
 <CA+55aFytC4xktWHAfQ96cdbt5nu+qbYytUGky8wWAkxZE=J0kw@mail.gmail.com>
 <CA+55aFyd5O_GyB_+BgHVYNLW-DV8xMQ9LOgPU34AtCqVvzfDaQ@mail.gmail.com>
 <20121215163323.GA229@x4>
 <20121215163535.GB229@x4>
 <1355661820.2903.25.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <1355661820.2903.25.camel@mfleming-mobl1.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2012.12.16 at 12:43 +0000, Matt Fleming wrote:
> On Sat, 2012-12-15 at 17:35 +0100, Markus Trippelsdorf wrote:
> > On 2012.12.15 at 17:33 +0100, Markus Trippelsdorf wrote:
> > > On 2012.12.14 at 17:47 -0800, Linus Torvalds wrote:
> > > > On Fri, Dec 14, 2012 at 5:41 PM, Linus Torvalds
> > > > <torvalds@linux-foundation.org> wrote:
> > > > > I was wrong. It's not the x86 UAPI split, it's the DT pull. More people added.
> > > > 
> > > > Looking at the merge (just in case it could have done something odd),
> > > > I'm starting to worry that this is some nasty heisenbug, and my
> > > > bisection is not trustworthy at all. Because the DT pull sure as heck
> > > > doesn't look like a likely candidate for anything either.
> > > > 
> > > > Ho humm. Anybody else see anything strange?
> > > 
> > > Yes. I'm seeing a BUG early during boot on my machine (RIP=NULL):
> > >  
> > >  BUG: unable to handle kernel NULL pointer dereference at           (null)
> > > 
> > > This is caused by:
> > > 
> > > commit 53b87cf088e2ea68d7c59619d0214cc15bb76133
> > > Author: Matt Fleming <matt.fleming@intel.com>
> > > Date:   Fri Sep 7 18:23:51 2012 +0100
> > > 
> > >     x86, mm: Include the entire kernel memory map in trampoline_pgd
> > >     
> > >     There are various pieces of code in arch/x86 that require a page table
> > >     with an identity mapping. Make trampoline_pgd a proper kernel page
> > >     table, it currently only includes the kernel text and module space
> > >     mapping.
> > >     
> > >     One new feature of trampoline_pgd is that it now has mappings for the
> > >     physical I/O device addresses, which are inserted at ioremap()
> > >     time. Some broken implementations of EFI firmware require these
> > >     mappings to always be around.
> > >     
> > >     Acked-by: Jan Beulich <jbeulich@suse.com>
> > >     Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> > > 
> > 
> > Adding Matt to CC.
> 
> Markus, could you please send me your full dmesg, or if possible the
> dmesgs from both a working and non-working kernel.
> 
> After looking at your memory map layout, nothing immediately jumps out.
> 
> Could you try this revised patch and see if things work better? It's the
> only thing I noticed that looked wrong with the original patch (apart
> from the >512G ram bug that Yinghai pointed out).

Matt, your patch fixes the problem for me. Thanks.

-- 
Markus

--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

Linux version 3.7.0-08451-g2b83188-dirty (markus@x4) (gcc version 4.8.0 20121214 (experimental) (GCC) ) #143 SMP Sat Dec 15 22:34:34 CET 2012
Command line: root=PARTUUID=1E3384D0-CAE6-41BB-8CD6-4F640164EFD7 init=/sbin/minit fbcon=rotate:3 drm_kms_helper.poll=0 quiet
KERNEL supported cpus:
  AMD AuthenticAMD
e820: BIOS-provided physical RAM map:
BIOS-e820: [mem 0x0000000000000100-0x000000000009fbff] usable
BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
BIOS-e820: [mem 0x00000000000e6000-0x00000000000fffff] reserved
BIOS-e820: [mem 0x0000000000100000-0x00000000dfe8ffff] usable
BIOS-e820: [mem 0x00000000dfe90000-0x00000000dfea7fff] ACPI data
BIOS-e820: [mem 0x00000000dfea8000-0x00000000dfecffff] ACPI NVS
BIOS-e820: [mem 0x00000000dfed0000-0x00000000dfefffff] reserved
BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] reserved
BIOS-e820: [mem 0x0000000100000000-0x000000021fffffff] usable
NX (Execute Disable) protection: active
DMI present.
DMI: System manufacturer System Product Name/M4A78T-E, BIOS 3503    04/13/2011
e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
e820: remove [mem 0x000a0000-0x000fffff] usable
e820: last_pfn = 0x220000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-EFFFF uncachable
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000000 mask FFFF80000000 write-back
  1 base 000080000000 mask FFFFC0000000 write-back
  2 base 0000C0000000 mask FFFFE0000000 write-back
  3 base 0000F0000000 mask FFFFF8000000 write-combining
  4 disabled
  5 disabled
  6 disabled
  7 disabled
TOM2: 0000000220000000 aka 8704M
x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
e820: last_pfn = 0xdfe90 max_arch_pfn = 0x400000000
initial memory mapped: [mem 0x00000000-0x1fffffff]
Base memory trampoline at [ffff880000099000] 99000 size 24576
Using GB pages for direct mapping
init_memory_mapping: [mem 0x00000000-0xdfe8ffff]
 [mem 0x00000000-0xbfffffff] page 1G
 [mem 0xc0000000-0xdfdfffff] page 2M
 [mem 0xdfe00000-0xdfe8ffff] page 4k
kernel direct mapping tables up to 0xdfe8ffff @ [mem 0x1fffd000-0x1fffffff]
init_memory_mapping: [mem 0x100000000-0x21fffffff]
 [mem 0x100000000-0x1ffffffff] page 1G
 [mem 0x200000000-0x21fffffff] page 2M
kernel direct mapping tables up to 0x21fffffff @ [mem 0xdfe8e000-0xdfe8ffff]
ACPI: RSDP 00000000000fb880 00024 (v02 ACPIAM)
ACPI: XSDT 00000000dfe90100 0005C (v01 041311 XSDT1656 20110413 MSFT 00000097)
ACPI: FACP 00000000dfe90290 000F4 (v03 041311 FACP1656 20110413 MSFT 00000097)
ACPI BIOS Bug: Warning: Optional FADT field Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1 (20121018/tbfadt-598)
ACPI: DSDT 00000000dfe90450 0E6FE (v01  A1152 A1152000 00000000 INTL 20060113)
ACPI: FACS 00000000dfea8000 00040
ACPI: APIC 00000000dfe90390 0007C (v01 041311 APIC1656 20110413 MSFT 00000097)
ACPI: MCFG 00000000dfe90410 0003C (v01 041311 OEMMCFG  20110413 MSFT 00000097)
ACPI: OEMB 00000000dfea8040 00072 (v01 041311 OEMB1656 20110413 MSFT 00000097)
ACPI: SRAT 00000000dfe9f450 000E8 (v01 AMD    FAM_F_10 00000002 AMD  00000001)
ACPI: HPET 00000000dfe9f540 00038 (v01 041311 OEMHPET  20110413 MSFT 00000097)
ACPI: SSDT 00000000dfe9f580 0088C (v01 A M I  POWERNOW 00000001 AMD  00000001)
ACPI: Local APIC address 0xfee00000
 [ffffea0000000000-ffffea00087fffff] PMD -> [ffff880217600000-ffff88021f5fffff] on node 0
Zone ranges:
  DMA      [mem 0x00010000-0x00ffffff]
  DMA32    [mem 0x01000000-0xffffffff]
  Normal   [mem 0x100000000-0x21fffffff]
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x00010000-0x0009efff]
  node   0: [mem 0x00100000-0xdfe8ffff]
  node   0: [mem 0x100000000-0x21fffffff]
On node 0 totalpages: 2096671
  DMA zone: 64 pages used for memmap
  DMA zone: 6 pages reserved
  DMA zone: 3913 pages, LIFO batch:0
  DMA32 zone: 14267 pages used for memmap
  DMA32 zone: 898773 pages, LIFO batch:31
  Normal zone: 18432 pages used for memmap
  Normal zone: 1161216 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8300 base: 0xfed00000
smpboot: Allowing 4 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
e820: [mem 0xdff00000-0xffefffff] available for PCI devices
setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Embedded 23 pages/cpu @ffff88021fc00000 s73280 r0 d20928 u524288
pcpu-alloc: s73280 r0 d20928 u524288 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2063902
Kernel command line: root=PARTUUID=1E3384D0-CAE6-41BB-8CD6-4F640164EFD7 init=/sbin/minit fbcon=rotate:3 drm_kms_helper.poll=0 quiet
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
__ex_table already sorted, skipping sort
Memory: 8167052k/8912896k available (4895k kernel code, 526212k absent, 219632k reserved, 3705k data, 444k init)
SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Hierarchical RCU implementation.
NR_IRQS:4352 nr_irqs:712 16
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
hpet clockevent registered
tsc: Fast TSC calibration using PIT
tsc: Detected 3211.074 MHz processor
Calibrating delay loop (skipped), value calculated using timer frequency.. 6424.73 BogoMIPS (lpj=10703580)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 256
tseg: 0000000000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
LVT offset 0 assigned for vector 0xf9
process: using AMD E400 aware idle routine
Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64
tlb_flushall_shift: 4
Freeing SMP alternatives: 16k freed
ACPI: Core revision 20121018
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
smpboot: CPU0: AMD Phenom(tm) II X4 955 Processor (fam: 10, model: 04, stepping: 02)
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
MCE: In-kernel MCE decoding enabled.
process: System has AMD C1E enabled
process: Switch to broadcast mode on CPU1
process: Switch to broadcast mode on CPU2
smpboot: Booting Node   0, Processors  #1 #2 #3 OK
Brought up 4 CPUs
smpboot: Total of 4 processors activated (25698.95 BogoMIPS)
process: Switch to broadcast mode on CPU3
process: Switch to broadcast mode on CPU0
devtmpfs: initialized
NET: Registered protocol family 16
node 0 link 0: io port [1000, ffffff]
TOM: 00000000e0000000 aka 3584M
Fam 10h mmconf [mem 0xe0000000-0xefffffff]
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [e0000000, efffffff] ==> none
node 0 link 0: mmio [f0000000, fbcfffff]
node 0 link 0: mmio [fbd00000, fbefffff]
node 0 link 0: mmio [fbf00000, ffefffff]
TOM2: 0000000220000000 aka 8704M
bus: [bus 00-07] on node 0 link 0
bus: 00 [io  0x0000-0xffff]
bus: 00 [mem 0x000a0000-0x000bffff]
bus: 00 [mem 0xf0000000-0xffffffff]
bus: 00 [mem 0x220000000-0xfcffffffff]
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
PCI: Using configuration type 1 for extended access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: EC: Look up EC in DSDT
ACPI: Executed 3 blocks of module-level executable AML code
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
pci_root PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
pci_root PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [bus 00-ff]
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
pci_bus 0000:00: root bus resource [mem 0xdff00000-0xdfffffff]
pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfebfffff]
pci 0000:00:00.0: [1022:9600] type 00 class 0x060000
pci 0000:00:01.0: [1022:9602] type 01 class 0x060400
pci 0000:00:06.0: [1022:9606] type 01 class 0x060400
pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
pci 0000:00:11.0: [1002:4391] type 00 class 0x010601
pci 0000:00:11.0: reg 10: [io  0xc000-0xc007]
pci 0000:00:11.0: reg 14: [io  0xb000-0xb003]
pci 0000:00:11.0: reg 18: [io  0xa000-0xa007]
pci 0000:00:11.0: reg 1c: [io  0x9000-0x9003]
pci 0000:00:11.0: reg 20: [io  0x8000-0x800f]
pci 0000:00:11.0: reg 24: [mem 0xfbcffc00-0xfbcfffff]
pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
pci 0000:00:12.0: reg 10: [mem 0xfbcfd000-0xfbcfdfff]
pci 0000:00:12.1: [1002:4398] type 00 class 0x0c0310
pci 0000:00:12.1: reg 10: [mem 0xfbcfe000-0xfbcfefff]
pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
pci 0000:00:12.2: reg 10: [mem 0xfbcff800-0xfbcff8ff]
pci 0000:00:12.2: supports D1 D2
pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
pci 0000:00:13.0: reg 10: [mem 0xfbcfb000-0xfbcfbfff]
pci 0000:00:13.1: [1002:4398] type 00 class 0x0c0310
pci 0000:00:13.1: reg 10: [mem 0xfbcfc000-0xfbcfcfff]
pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
pci 0000:00:13.2: reg 10: [mem 0xfbcff400-0xfbcff4ff]
pci 0000:00:13.2: supports D1 D2
pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
pci 0000:00:14.1: [1002:439c] type 00 class 0x01018a
pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
pci 0000:00:14.1: reg 20: [io  0xff00-0xff0f]
pci 0000:00:14.2: [1002:4383] type 00 class 0x040300
pci 0000:00:14.2: reg 10: [mem 0xfbcf4000-0xfbcf7fff 64bit]
pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
pci 0000:00:14.5: [1002:4399] type 00 class 0x0c0310
pci 0000:00:14.5: reg 10: [mem 0xfbcfa000-0xfbcfafff]
pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
pci 0000:01:05.0: [1002:9614] type 00 class 0x030000
pci 0000:01:05.0: reg 10: [mem 0xf0000000-0xf7ffffff pref]
pci 0000:01:05.0: reg 14: [io  0xd000-0xd0ff]
pci 0000:01:05.0: reg 18: [mem 0xfbee0000-0xfbeeffff]
pci 0000:01:05.0: reg 24: [mem 0xfbd00000-0xfbdfffff]
pci 0000:01:05.0: supports D1 D2
pci 0000:01:05.1: [1002:960f] type 00 class 0x040300
pci 0000:01:05.1: reg 10: [mem 0xfbefc000-0xfbefffff]
pci 0000:01:05.1: supports D1 D2
pci 0000:00:01.0: PCI bridge to [bus 01]
pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
pci 0000:00:01.0:   bridge window [mem 0xfbd00000-0xfbefffff]
pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
pci 0000:02:00.0: [1969:1026] type 00 class 0x020000
pci 0000:02:00.0: reg 10: [mem 0xfbfc0000-0xfbffffff 64bit]
pci 0000:02:00.0: reg 18: [io  0xec00-0xec7f]
pci 0000:02:00.0: PME# supported from D3hot D3cold
pci 0000:00:06.0: PCI bridge to [bus 02]
pci 0000:00:06.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:06.0:   bridge window [mem 0xfbf00000-0xfbffffff]
pci 0000:00:14.4: PCI bridge to [bus 03] (subtractive decode)
pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0xdff00000-0xdfffffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
pci_bus 0000:00: on NUMA node 0
ACPI: Invalid Power Resource to register!
ACPI: Invalid Power Resource to register!
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: Invalid Power Resource to register!
ACPI: Invalid Power Resource to register!
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE6._PRT]
ACPI: Invalid Power Resource to register!
ACPI: Invalid Power Resource to register!
ACPI: Invalid Power Resource to register!
ACPI: Invalid Power Resource to register!
ACPI: Invalid Power Resource to register!
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
ACPI: Invalid Power Resource to register!
ACPI: Invalid Power Resource to register!
ACPI: Invalid Power Resource to register!
ACPI: Invalid Power Resource to register!
ACPI: Invalid Power Resource to register!
ACPI: Invalid Power Resource to register!
ACPI: Invalid Power Resource to register!
ACPI: Invalid Power Resource to register!
ACPI _OSC control for PCIe not granted, disabling ASPM
ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14 15) *0, disabled.
SCSI subsystem initialized
libata version 3.00 loaded.
ACPI: bus type usb registered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Advanced Linux Sound Architecture Driver Initialized.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
e820: reserve RAM buffer [mem 0xdfe90000-0xdfffffff]
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 32-bit 14.318180 MHz counter
Switching to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type pnp registered
system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:01: [dma 4]
pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:05: Plug and Play ACPI device, IDs PNP0103 (active)
system 00:06: [mem 0xfec00000-0xfec00fff] could not be reserved
system 00:06: [mem 0xfee00000-0xfee00fff] has been reserved
system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
system 00:07: [io  0x04d0-0x04d1] has been reserved
system 00:07: [io  0x040b] has been reserved
system 00:07: [io  0x04d6] has been reserved
system 00:07: [io  0x0c00-0x0c01] has been reserved
system 00:07: [io  0x0c14] has been reserved
system 00:07: [io  0x0c50-0x0c51] has been reserved
system 00:07: [io  0x0c52] has been reserved
system 00:07: [io  0x0c6c] has been reserved
system 00:07: [io  0x0c6f] has been reserved
system 00:07: [io  0x0cd0-0x0cd1] has been reserved
system 00:07: [io  0x0cd2-0x0cd3] has been reserved
system 00:07: [io  0x0cd4-0x0cd5] has been reserved
system 00:07: [io  0x0cd6-0x0cd7] has been reserved
system 00:07: [io  0x0cd8-0x0cdf] has been reserved
system 00:07: [io  0x0b00-0x0b3f] has been reserved
system 00:07: [io  0x0800-0x089f] has been reserved
system 00:07: [io  0x0b00-0x0b0f] has been reserved
system 00:07: [io  0x0b20-0x0b3f] has been reserved
system 00:07: [io  0x0900-0x090f] has been reserved
system 00:07: [io  0x0910-0x091f] has been reserved
system 00:07: [io  0xfe00-0xfefe] has been reserved
system 00:07: [mem 0xdff00000-0xdfffffff] has been reserved
system 00:07: [mem 0xffb80000-0xffbfffff] has been reserved
system 00:07: [mem 0xfec10000-0xfec1001f] has been reserved
system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
system 00:08: [io  0x0230-0x023f] has been reserved
system 00:08: [io  0x0290-0x029f] has been reserved
system 00:08: [io  0x0f40-0x0f4f] has been reserved
system 00:08: [io  0x0a30-0x0a3f] has been reserved
system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
system 00:09: [mem 0xe0000000-0xefffffff] has been reserved
system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
system 00:0a: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:0a: [mem 0x000c0000-0x000cffff] could not be reserved
system 00:0a: [mem 0x000e0000-0x000fffff] could not be reserved
system 00:0a: [mem 0x00100000-0xdfefffff] could not be reserved
system 00:0a: [mem 0xfec00000-0xffffffff] could not be reserved
system 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
pci 0000:00:01.0: PCI bridge to [bus 01]
pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
pci 0000:00:01.0:   bridge window [mem 0xfbd00000-0xfbefffff]
pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
pci 0000:00:06.0: PCI bridge to [bus 02]
pci 0000:00:06.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:06.0:   bridge window [mem 0xfbf00000-0xfbffffff]
pci 0000:00:14.4: PCI bridge to [bus 03]
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
pci_bus 0000:00: resource 8 [mem 0xdff00000-0xdfffffff]
pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfebfffff]
pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
pci_bus 0000:01: resource 1 [mem 0xfbd00000-0xfbefffff]
pci_bus 0000:01: resource 2 [mem 0xf0000000-0xf7ffffff 64bit pref]
pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
pci_bus 0000:02: resource 1 [mem 0xfbf00000-0xfbffffff]
pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:03: resource 7 [mem 0x000d0000-0x000dffff]
pci_bus 0000:03: resource 8 [mem 0xdff00000-0xdfffffff]
pci_bus 0000:03: resource 9 [mem 0xf0000000-0xfebfffff]
NET: Registered protocol family 2
TCP established hash table entries: 65536 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 65536 bind 65536)
TCP: reno registered
UDP hash table entries: 4096 (order: 5, 131072 bytes)
UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
NET: Registered protocol family 1
pci 0000:00:01.0: MSI quirk detected; subordinate MSI disabled
pci 0000:01:05.0: Boot video device
PCI: CLS 64 bytes, default 64
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
software IO TLB [mem 0xdbe8e000-0xdfe8dfff] (64MB) mapped at [ffff8800dbe8e000-ffff8800dfe8dfff]
kvm: Nested Virtualization enabled
kvm: Nested Paging enabled
LVT offset 1 assigned for vector 0x400
IBS: LVT offset 1 assigned
perf: AMD IBS detected (0x0000001f)
microcode: CPU0: patch_level=0x010000db
microcode: CPU1: patch_level=0x010000db
microcode: CPU2: patch_level=0x010000db
microcode: CPU3: patch_level=0x010000db
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
9p: Installing v9fs 9p2000 file system support
msgmni has been set to 15951
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered (default)
ACPI: processor limited to max C-state 1
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[drm] Initialized drm 1.1.0 20060810
[drm] radeon defaulting to kernel modesetting.
[drm] radeon kernel modesetting enabled.
[drm] initializing kernel modesetting (RS780 0x1002:0x9614 0x1043:0x834D).
[drm] register mmio base: 0xFBEE0000
[drm] register mmio size: 65536
ATOM BIOS: 113
radeon 0000:01:05.0: VRAM: 128M 0x00000000C0000000 - 0x00000000C7FFFFFF (128M used)
radeon 0000:01:05.0: GTT: 512M 0x00000000A0000000 - 0x00000000BFFFFFFF
[drm] Detected VRAM RAM=128M, BAR=128M
[drm] RAM width 32bits DDR
[TTM] Zone  kernel: Available graphics memory: 4083534 kiB
[TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[TTM] Initializing pool allocator
[TTM] Initializing DMA pool allocator
[drm] radeon: 128M of VRAM memory ready
[drm] radeon: 512M of GTT memory ready.
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
[drm] radeon: irq initialized.
[drm] GART: num cpu pages 131072, num gpu pages 131072
[drm] Loading RS780 Microcode
[drm] PCIE GART of 512M enabled (table at 0x00000000C0040000).
radeon 0000:01:05.0: WB enabled
radeon 0000:01:05.0: fence driver on ring 0 use gpu addr 0x00000000a0000c00 and cpu addr 0xffff8802163d8c00
radeon 0000:01:05.0: setting latency timer to 64
[drm] ring test on 0 succeeded in 0 usecs
[drm] ib test on ring 0 succeeded in 0 usecs
[drm] Radeon Display Connectors
[drm] Connector 0:
[drm]   VGA-1
[drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[drm]   Encoders:
[drm]     CRT1: INTERNAL_KLDSCP_DAC1
[drm] Connector 1:
[drm]   DVI-D-1
[drm]   HPD3
[drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[drm]   Encoders:
[drm]     DFP3: INTERNAL_KLDSCP_LVTMA
[drm] radeon: power management initialized
[drm] fb mappable at 0xF0142000
[drm] vram apper at 0xF0000000
[drm] size 7299072
[drm] fb depth is 24
[drm]    pitch is 6912
fbcon: radeondrmfb (fb0) is primary device
Console: switching to colour frame buffer device 131x105
fb0: radeondrmfb frame buffer device
drm: registered panic notifier
[drm] Initialized radeon 2.24.0 20080528 for 0000:01:05.0 on minor 0
loop: module loaded
ahci 0000:00:11.0: version 3.0
ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffd00 irq 22
ata2: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffd80 irq 22
ata3: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffe00 irq 22
ata4: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffe80 irq 22
ata5: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcfff00 irq 22
ata6: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcfff80 irq 22
scsi6 : pata_atiixp
scsi7 : pata_atiixp
ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci-pci: EHCI PCI platform driver
ehci-pci 0000:00:12.2: EHCI Host Controller
ehci-pci 0000:00:12.2: new USB bus registered, assigned bus number 1
QUIRK: Enable AMD PLL fix
ehci-pci 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
ehci-pci 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
ehci-pci 0000:00:12.2: debug port 1
ehci-pci 0000:00:12.2: irq 17, io mem 0xfbcff800
ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ehci-pci 0000:00:13.2: EHCI Host Controller
ehci-pci 0000:00:13.2: new USB bus registered, assigned bus number 2
ehci-pci 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
ehci-pci 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
ehci-pci 0000:00:13.2: debug port 1
ehci-pci 0000:00:13.2: irq 19, io mem 0xfbcff400
ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:12.0: OHCI Host Controller
ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:12.0: irq 16, io mem 0xfbcfd000
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 3 ports detected
ohci_hcd 0000:00:12.1: OHCI Host Controller
ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:12.1: irq 16, io mem 0xfbcfe000
ata7.00: ATAPI: HL-DT-STDVD-RAM GH22NP20, 1.03, max UDMA/66
ata7.00: configured for UDMA/66
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 3 ports detected
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
ohci_hcd 0000:00:13.0: irq 18, io mem 0xfbcfb000
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 3 ports detected
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
ohci_hcd 0000:00:13.1: irq 18, io mem 0xfbcfc000
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 3 ports detected
ohci_hcd 0000:00:14.5: OHCI Host Controller
ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
ohci_hcd 0000:00:14.5: irq 18, io mem 0xfbcfa000
ata5: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1: SATA link down (SStatus 0 SControl 300)
ata3.00: ATA-8: OCZ VERTEX-TURBO, 1.7, max UDMA/133
ata3.00: 62533296 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
ata2.00: ATA-8: ST1500DL003-9VT16L, CC32, max UDMA/133
ata2.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata3.00: failed to get Identify Device Data, Emask 0x1
ata2.00: failed to get Identify Device Data, Emask 0x1
ata2.00: failed to get Identify Device Data, Emask 0x1
ata2.00: configured for UDMA/133
scsi 1:0:0:0: Direct-Access     ATA      ST1500DL003-9VT1 CC32 PQ: 0 ANSI: 5
ata3.00: failed to get Identify Device Data, Emask 0x1
ata3.00: configured for UDMA/133
sd 1:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:0:0: [sda] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
scsi 2:0:0:0: Direct-Access     ATA      OCZ VERTEX-TURBO 1.7  PQ: 0 ANSI: 5
sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdb] 62533296 512-byte logical blocks: (32.0 GB/29.8 GiB)
sd 2:0:0:0: Attached scsi generic sg1 type 0
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
scsi 6:0:0:0: CD-ROM            HL-DT-ST DVD-RAM GH22NP20 1.03 PQ: 0 ANSI: 5
 sdb: sdb1 sdb2
sd 2:0:0:0: [sdb] Attached SCSI disk
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 6:0:0:0: Attached scsi CD-ROM sr0
sr 6:0:0:0: Attached scsi generic sg2 type 5
 sda: unknown partition table
sd 1:0:0:0: [sda] Attached SCSI disk
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
i8042: PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
rtc_cmos 00:02: RTC can wake from S4
rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
i2c /dev entries driver
EDAC MC: Ver: 3.0.0
AMD64 EDAC driver v3.4.0
EDAC amd64: DRAM ECC enabled.
EDAC amd64: F10h detected (node 0).
EDAC MC: DCT0 chip selects:
EDAC amd64: MC: 0:  1024MB 1:  1024MB
EDAC amd64: MC: 2:  1024MB 3:  1024MB
EDAC amd64: MC: 4:     0MB 5:     0MB
EDAC amd64: MC: 6:     0MB 7:     0MB
EDAC MC: DCT1 chip selects:
EDAC amd64: MC: 0:  1024MB 1:  1024MB
EDAC amd64: MC: 2:  1024MB 3:  1024MB
EDAC amd64: MC: 4:     0MB 5:     0MB
EDAC amd64: MC: 6:     0MB 7:     0MB
EDAC amd64: using x4 syndromes.
EDAC amd64: MCT channel count: 2
EDAC amd64: CS0: Unbuffered DDR3 RAM
EDAC amd64: CS1: Unbuffered DDR3 RAM
EDAC amd64: CS2: Unbuffered DDR3 RAM
EDAC amd64: CS3: Unbuffered DDR3 RAM
EDAC MC0: Giving out device to 'amd64_edac' 'F10h': DEV 0000:00:18.2
EDAC PCI0: Giving out device to module 'amd64_edac' controller 'EDAC PCI controller': DEV '0000:00:18.2' (POLLED)
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
usb 1-1: new high-speed USB device number 2 using ehci-pci
snd_hda_intel 0000:01:05.1: setting latency timer to 64
hda-codec: No codec parser is available
usbcore: registered new interface driver snd-usb-audio
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ctnetlink v0.93: registering with nfnetlink.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP: cubic registered
NET: Registered protocol family 17
9pnet: Installing 9P2000 support
registered taskstats version 1
rtc_cmos 00:02: setting system clock to 2012-12-16 13:22:38 UTC (1355664158)
acpi-cpufreq: overriding BIOS provided _PSD data
ALSA device list:
  #0: HDA ATI SB at 0xfbcf4000 irq 16
  #1: HDA ATI HDMI at 0xfbefc000 irq 19
EXT4-fs (sdb2): mounted filesystem with ordered data mode. Opts: (null)
VFS: Mounted root (ext4 filesystem) readonly on device 8:18.
devtmpfs: mounted
Freeing unused kernel memory: 444k freed
Write protecting the kernel read-only data: 8192k
Freeing unused kernel memory: 1244k freed
Freeing unused kernel memory: 216k freed
usblp 1-1:1.0: usblp0: USB Bidirectional printer dev 2 if 0 alt 0 proto 2 vid 0x06BC pid 0x01C9
EXT4-fs (sdb2): re-mounted. Opts: (null)
EXT4-fs (sda): mounted filesystem with ordered data mode. Opts: (null)
ATL1E 0000:02:00.0: irq 40 for MSI/MSI-X
tsc: Refined TSC clocksource calibration: 3210.827 MHz
Switching to clocksource tsc
usb 4-2: new full-speed USB device number 2 using ohci_hcd
logitech-djreceiver 0003:046D:C52B.0003: hiddev0,hidraw0: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.1-2/input2
input: Logitech Unifying Device. Wireless PID:101b as /devices/pci0000:00/0000:00:12.1/usb4/4-2/4-2:1.2/0003:046D:C52B.0003/input/input0
logitech-djdevice 0003:046D:C52B.0004: input,hidraw1: USB HID v1.11 Mouse [Logitech Unifying Device. Wireless PID:101b] on usb-0000:00:12.1-2:1
usb 4-3: new low-speed USB device number 3 using ohci_hcd
input: HID 046a:0011 as /devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.0/input/input1
hid-generic 0003:046A:0011.0005: input,hidraw2: USB HID v1.10 Keyboard [HID 046a:0011] on usb-0000:00:12.1-3/input0
ATL1E 0000:02:00.0 eth0: NIC Link is Up <100 Mbps Full Duplex>
Adding 4194300k swap on /var/cache/swapfile.img.  Priority:-1 extents:9 across:629080060k 

--YiEDa0DAkWCtVeE4--
