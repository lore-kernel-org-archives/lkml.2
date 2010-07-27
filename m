Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab0G0MGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 08:06:00 -0400
Received: from centrinvest.ru ([94.25.115.130]:52561 "EHLO centrinvest.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949Ab0G0MF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 08:05:57 -0400
From: "Andrey Panin" <pazke@centrinvest.ru>
Date: Tue, 27 Jul 2010 16:05:52 +0400
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>
Subject: Re: Problem with e1000e, 802.1Q VLAN's and IPMI
Message-ID: <20100727120552.GA31741@centrinvest.ru>
Mail-Followup-To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"e1000-devel@lists.sourceforge.net" <e1000-devel@lists.sourceforge.net>,
	"Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
	"Allan, Bruce W" <bruce.w.allan@intel.com>,
	"Duyck, Alexander H" <alexander.h.duyck@intel.com>,
	"Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
	"Ronciak, John" <john.ronciak@intel.com>
References: <20100726073920.GD30155@centrinvest.ru>
 <alpine.WNT.2.00.1007260936160.4488@jbrandeb-desk1.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <alpine.WNT.2.00.1007260936160.4488@jbrandeb-desk1.amr.corp.intel.com>
X-Uname: Linux 2.6.26-1-amd64 x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Anti-Virus: kav4lms: continue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 207, 07 26, 2010 at 09:45:06AM -0700, Brandeburg, Jesse wrote:
> 
> On Mon, 26 Jul 2010, Andrey Panin wrote:
> > I have a problem using IPMI on Super Micro X7SBL motherboard (AOC-IPMI20-E BMC).
> > BMC shares ethernet port with onboard e1000e. It works when IPMI traffic is 
> > untagged (CrcStripping=0 module option used), but if I try to use 802.1Q vlan
> > for IPMI traffic BMC stops responding right after "ifup eth0". 
> 
> We've heard of this issue (or similar) before.  I believe for the other 
> guys they had to run IPMI traffic untagged, if your main network is 
> running untagged.  The problem in this case is that the tags are being 
> stripped in hardware even for the SMBUS packets, at which point the BMC 
> that is stupid and doesn't understand offloading hardware gets confused 
> that the traffic it is receiving doesn't have a vlan tag.

I suspected something like that. Unfortunately Super Micro isn't interested
in fixing their BMC, at least latest firmware doesn't fix the issue.

> > I tested 2.6.26 (debian stable kernel) and 2.6.35-rc6.
> > Looks like there is some problem with 802.1Q tags stripping/inserting.
> 
> Thanks for testing the latest kernel.
> 
> > There was no such problem with e1000 driver from 2.6.18.
> 
> Hm, that is an interesting statement.  The major changes to the driver 
> include stripping tags all the time when not in promisc mode, and there 
> have been some fixes and attempts to fix the ipmi issues some 
> (particularly supermicro) BMCs have.  I'm quite surprised it worked for 
> you at all (there have been quite a few issues in this area)

After some sleep I'm not so sure that it was really working :(
I'll retest it more thoroughly this evening.

> > Unfortunately I can't provide additional info right now, but I can provide
> > it slightly later and I'm ready to test patches.
> 
> I can send you a patch to disable vlan stripping in hardware which will 
> probably get you working, but I don't think it is production worthy.

This solution looks too drastic to me, taking into account that this box will
be used as broadband access server. I'll better change my network to keep IPMI
traffic untagged.

Best regards.

--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

Linux version 2.6.35-rc6 (root@ppp) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #1 SMP Sat Jul 24 12:46:31 MSD 2010
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
 BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fe70000 (usable)
 BIOS-e820: 000000007fe70000 - 000000007fe7d000 (ACPI data)
 BIOS-e820: 000000007fe7d000 - 000000007fe80000 (ACPI NVS)
 BIOS-e820: 000000007fe80000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
DMI present.
Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
last_pfn = 0x7fe70 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-C7FFF write-protect
  C8000-DFFFF uncachable
  E0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask F80000000 write-back
  1 disabled
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Warning only 895MB will be used.
Use a HIGHMEM enabled kernel.
initial memory mapped : 0 - 01800000
init_memory_mapping: 0000000000000000-0000000037f15000
 0000000000 - 0000400000 page 4k
 0000400000 - 0037c00000 page 2M
 0037c00000 - 0037f15000 page 4k
kernel direct mapping tables up to 37f15000 @ 11000-16000
RAMDISK: 37e28000 - 37ff0000
Allocated new RAMDISK: 00100000 - 002c70d0
Move RAMDISK from 0000000037e28000 - 0000000037fef0cf to 00100000 - 002c70cf
ACPI: RSDP 000f6540 00024 (v02 PTLTD )
ACPI: XSDT 7fe72306 000D4 (v01 PTLTD  ? XSDT   06040000  LTP 00000000)
ACPI: FACP 7fe7c309 000F4 (v03 INTEL           06040000 PTL  00000002)
ACPI: DSDT 7fe75b0b 0678A (v01  INTEL BEARLAKE 06040000 MSFT 03000001)
ACPI: FACS 7fe7ffc0 00040
ACPI: _MAR 7fe7c3fd 0012F (v01 Intel  OEMDMAR  06040000 LOHR 00000001)
ACPI: TCPA 7fe7c52c 00032 (v01 Intel           06040000 PTL  0000005A)
ACPI: MCFG 7fe7c55e 0003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
ACPI: HPET 7fe7c59a 00038 (v01 PTLTD  HPETTBL  06040000  LTP 00000001)
ACPI: APIC 7fe7c5d2 00068 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
ACPI: BOOT 7fe7c63a 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
ACPI: SPCR 7fe7c662 00050 (v01 PTLTD  $UCRTBL$ 06040000 PTL  00000001)
ACPI: ERST 7fe7c6b2 00590 (v01 SMCI   ERSTTBL  06040000 SMCI 00000001)
ACPI: HEST 7fe7cc42 000A8 (v01 SMCI   HESTTBL  06040000 SMCI 00000001)
ACPI: BERT 7fe7ccea 00030 (v01 SMCI   BERTTBL  06040000 SMCI 00000001)
ACPI: EINJ 7fe7cd1a 00170 (v01 SMCI   EINJTBL  06040000 SMCI 00000001)
ACPI: SLIC 7fe7ce8a 00176 (v01 OEMID_ OEMTABLE 06040000  LTP 00000000)
ACPI: SSDT 7fe73c4d 0025F (v01  PmRef  Cpu0Tst 00003000 INTL 20050228)
ACPI: SSDT 7fe73ba7 000A6 (v01  PmRef  Cpu7Tst 00003000 INTL 20050228)
ACPI: SSDT 7fe73b01 000A6 (v01  PmRef  Cpu6Tst 00003000 INTL 20050228)
ACPI: SSDT 7fe73a5b 000A6 (v01  PmRef  Cpu5Tst 00003000 INTL 20050228)
ACPI: SSDT 7fe739b5 000A6 (v01  PmRef  Cpu4Tst 00003000 INTL 20050228)
ACPI: SSDT 7fe7390f 000A6 (v01  PmRef  Cpu3Tst 00003000 INTL 20050228)
ACPI: SSDT 7fe73869 000A6 (v01  PmRef  Cpu2Tst 00003000 INTL 20050228)
ACPI: SSDT 7fe737c3 000A6 (v01  PmRef  Cpu1Tst 00003000 INTL 20050228)
ACPI: SSDT 7fe723da 013E9 (v01  PmRef    CpuPm 00003000 INTL 20050228)
ACPI: Local APIC address 0xfee00000
895MB LOWMEM available.
  mapped low ram: 0 - 37f15000
  low ram: 0 - 37f15000
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x00037f15
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009c
    0: 0x00000100 -> 0x00037f15
On node 0 totalpages: 229025
free_area_init_node: node 0, pgdat c12aea80, node_mem_map c134c380
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3948 pages, LIFO batch:0
  Normal zone: 1759 pages used for memmap
  Normal zone: 223286 pages, LIFO batch:31
Using APIC driver default
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0xffffffff base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
Allocating PCI resources starting at 80000000 (gap: 80000000:60000000)
setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
early_res array is doubled to 64 at [12000 - 127ff]
PERCPU: Embedded 12 pages/cpu @c1c00000 s27904 r0 d21248 u2097152
pcpu-alloc: s27904 r0 d21248 u2097152 alloc=1*4194304
pcpu-alloc: [0] 0 1 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 227234
Kernel command line: root=/dev/sda1 ro quiet console=ttyS1,115200
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
Subtract (41 early reservations)
  #1 [0000001000 - 0000002000]   EX TRAMPOLINE
  #2 [0001000000 - 0001345894]   TEXT DATA BSS
  #3 [000009cc00 - 0000100000]   BIOS reserved
  #4 [0001346000 - 000134c170]             BRK
  #5 [0000010000 - 0000011000]      TRAMPOLINE
  #6 [0000011000 - 0000012000]         PGTABLE
  #7 [0000100000 - 00002c8000]     NEW RAMDISK
  #8 [000134c180 - 0001a4c180]         BOOTMEM
  #9 [00013458c0 - 00013458c4]         BOOTMEM
  #10 [0001345900 - 00013459c0]         BOOTMEM
  #11 [00013459c0 - 0001345a14]         BOOTMEM
  #12 [0001a4c180 - 0001a4f180]         BOOTMEM
  #13 [0001345a40 - 0001345a65]         BOOTMEM
  #14 [0001345a80 - 0001345aa7]         BOOTMEM
  #15 [0001345ac0 - 0001345c10]         BOOTMEM
  #16 [0001345c40 - 0001345c80]         BOOTMEM
  #17 [0001345c80 - 0001345cc0]         BOOTMEM
  #18 [0001345cc0 - 0001345d00]         BOOTMEM
  #19 [0001345d00 - 0001345d40]         BOOTMEM
  #20 [0001345d40 - 0001345d80]         BOOTMEM
  #21 [0001345d80 - 0001345dc0]         BOOTMEM
  #22 [0001345dc0 - 0001345e00]         BOOTMEM
  #23 [0001345e00 - 0001345e40]         BOOTMEM
  #24 [0001345e40 - 0001345e80]         BOOTMEM
  #25 [0001345e80 - 0001345ec0]         BOOTMEM
  #26 [0001345ec0 - 0001345f00]         BOOTMEM
  #27 [0001345f00 - 0001345f2d]         BOOTMEM
  #28 [0001345f40 - 0001345f6d]         BOOTMEM
  #29 [0001c00000 - 0001c0c000]         BOOTMEM
  #30 [0001e00000 - 0001e0c000]         BOOTMEM
  #31 [0001345f80 - 0001345f84]         BOOTMEM
  #32 [0001345fc0 - 0001345fc4]         BOOTMEM
  #33 [0001a51180 - 0001a51188]         BOOTMEM
  #34 [0001a511c0 - 0001a511c8]         BOOTMEM
  #35 [0001a51200 - 0001a512a8]         BOOTMEM
  #36 [0001a512c0 - 0001a51328]         BOOTMEM
  #37 [0001a51340 - 0001a55340]         BOOTMEM
  #38 [0001a55340 - 0001ad5340]         BOOTMEM
  #39 [0001ad5340 - 0001b15340]         BOOTMEM
  #40 [0001a4f180 - 0001a4f3c0]         BOOTMEM
Memory: 902824k/916564k available (1874k kernel code, 13276k reserved, 887k data, 312k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff17000 - 0xfffff000   ( 928 kB)
    vmalloc : 0xf8715000 - 0xfff15000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf7f15000   ( 895 MB)
      .init : 0xc12b3000 - 0xc1301000   ( 312 kB)
      .data : 0xc11d4882 - 0xc12b2708   ( 887 kB)
      .text : 0xc1000000 - 0xc11d4882   (1874 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Hierarchical RCU implementation.
	RCU-based detection of stalled CPUs is disabled.
	Verbose stalled-CPUs detection is disabled.
NR_IRQS:512
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [ttyS1] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2593.699 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 5187.39 BogoMIPS (lpj=10374796)
pid_max: default: 32768 minimum: 301
Security Framework initialized
Mount-cache hash table entries: 512
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
CPU0: Thermal monitoring handled by SMI
using mwait in idle threads.
Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
ACPI: Core revision 20100428
Enabling APIC mode:  Flat.  Using 1 I/O APICs
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel Pentium(R) Dual-Core  CPU      E5300  @ 2.60GHz stepping 0a
Booting Node   0, Processors  #1 Ok.
Initializing CPU#1
CPU1: Thermal monitoring handled by SMI
Brought up 2 CPUs
Total of 2 processors activated (10374.33 BogoMIPS).
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-10] at [mem 0xe0000000-0xe10fffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xe10fffff] reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
\_SB_:_OSC evaluation returned wrong type
_OSC request data:1 6 
ACPI: SSDT 7fe73eac 00261 (v01  PmRef  Cpu0Ist 00003000 INTL 20050228)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT (null) 00261 (v01  PmRef  Cpu0Ist 00003000 INTL 20050228)
ACPI: SSDT 7fe7410d 001F2 (v01  PmRef  Cpu1Ist 00003000 INTL 20050228)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT (null) 001F2 (v01  PmRef  Cpu1Ist 00003000 INTL 20050228)
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
\_SB_.PCI0:_OSC evaluation returned wrong type
_OSC request data:1 8 1f 
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3f])
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A03:00: host bridge window [mem 0x000cc000-0x000cffff]
pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000d3fff]
pci_root PNP0A03:00: host bridge window [mem 0x000d4000-0x000d7fff]
pci_root PNP0A03:00: host bridge window [mem 0x000d8000-0x000dbfff]
pci_root PNP0A03:00: host bridge window [mem 0x000dc000-0x000dffff]
pci_root PNP0A03:00: host bridge window [mem 0x80000000-0xdfffffff]
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xfdff]
pci_root PNP0A03:00: host bridge window [mem 0xfed40000-0xfed44fff]
pci 0000:00:1a.0: reg 20: [io  0x1820-0x183f]
pci 0000:00:1a.1: reg 20: [io  0x1840-0x185f]
pci 0000:00:1a.2: reg 20: [io  0x1860-0x187f]
pci 0000:00:1a.7: reg 10: [mem 0xdc000000-0xdc0003ff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.5: PME# disabled
pci 0000:00:1d.0: reg 20: [io  0x1880-0x189f]
pci 0000:00:1d.1: reg 20: [io  0x18a0-0x18bf]
pci 0000:00:1d.2: reg 20: [io  0x18c0-0x18df]
pci 0000:00:1d.7: reg 10: [mem 0xdc000400-0xdc0007ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0290 (mask 0097)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca0 (mask 00af)
pci 0000:00:1f.2: reg 10: [io  0x1c50-0x1c57]
pci 0000:00:1f.2: reg 14: [io  0x1c44-0x1c47]
pci 0000:00:1f.2: reg 18: [io  0x1c48-0x1c4f]
pci 0000:00:1f.2: reg 1c: [io  0x1c40-0x1c43]
pci 0000:00:1f.2: reg 20: [io  0x18e0-0x18ff]
pci 0000:00:1f.2: reg 24: [mem 0xdc000800-0xdc000fff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 10: [mem 0xdc001000-0xdc0010ff 64bit]
pci 0000:00:1f.3: reg 20: [io  0x1100-0x111f]
pci 0000:00:1f.6: reg 10: [mem 0xdc002000-0xdc002fff 64bit]
pci 0000:00:1c.0: PCI bridge to [bus 05-05]
pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:0d:00.0: reg 10: [mem 0xdc100000-0xdc11ffff]
pci 0000:0d:00.0: reg 18: [io  0x2000-0x201f]
pci 0000:0d:00.0: PME# supported from D0 D3hot D3cold
pci 0000:0d:00.0: PME# disabled
pci 0000:00:1c.4: PCI bridge to [bus 0d-0d]
pci 0000:00:1c.4:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.4:   bridge window [mem 0xdc100000-0xdc1fffff]
pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:0f:00.0: reg 10: [mem 0xdc200000-0xdc21ffff]
pci 0000:0f:00.0: reg 18: [io  0x3000-0x301f]
pci 0000:0f:00.0: PME# supported from D0 D3hot D3cold
pci 0000:0f:00.0: PME# disabled
pci 0000:00:1c.5: PCI bridge to [bus 0f-0f]
pci 0000:00:1c.5:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.5:   bridge window [mem 0xdc200000-0xdc2fffff]
pci 0000:00:1c.5:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:11:04.0: reg 10: [mem 0xde000000-0xdfffffff pref]
pci 0000:11:04.0: reg 14: [mem 0xdc300000-0xdc33ffff]
pci 0000:11:04.0: reg 18: [io  0x4000-0x407f]
pci 0000:11:04.0: supports D1 D2
pci 0000:00:1e.0: PCI bridge to [bus 11-11] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x4000-0x4fff]
pci 0000:00:1e.0:   bridge window [mem 0xdc300000-0xdc3fffff]
pci 0000:00:1e.0:   bridge window [mem 0xde000000-0xdfffffff 64bit pref]
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000cc000-0x000cffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x80000000-0xdfffffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xfdff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP6._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
\_SB_.PCI0:_OSC evaluation returned wrong type
_OSC request data:1 19 1f 
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15)
vgaarb: device added: PCI:0000:11:04.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009cc00 - 000000000009ffff 
reserve RAM buffer: 000000007fe70000 - 000000007fffffff 
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
system 00:01: [io  0x0295-0x0296] has been reserved
system 00:01: [io  0x0800-0x080f] has been reserved
system 00:01: [io  0x1000-0x107f] has been reserved
system 00:01: [io  0x1180-0x11bf] has been reserved
system 00:01: [io  0x04d0-0x04d1] has been reserved
system 00:01: [io  0xfe00] has been reserved
system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
system 00:01: [mem 0xfef00000-0xfeffffff] has been reserved
pci 0000:00:1c.0: BAR 8: assigned [mem 0x80000000-0x801fffff]
pci 0000:00:1c.0: BAR 9: assigned [mem 0x80200000-0x803fffff 64bit pref]
pci 0000:00:1c.4: BAR 9: assigned [mem 0x80400000-0x805fffff 64bit pref]
pci 0000:00:1c.5: BAR 9: assigned [mem 0x80600000-0x807fffff 64bit pref]
pci 0000:00:1c.0: BAR 7: assigned [io  0x5000-0x5fff]
pci 0000:00:1c.0: PCI bridge to [bus 05-05]
pci 0000:00:1c.0:   bridge window [io  0x5000-0x5fff]
pci 0000:00:1c.0:   bridge window [mem 0x80000000-0x801fffff]
pci 0000:00:1c.0:   bridge window [mem 0x80200000-0x803fffff 64bit pref]
pci 0000:00:1c.4: PCI bridge to [bus 0d-0d]
pci 0000:00:1c.4:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.4:   bridge window [mem 0xdc100000-0xdc1fffff]
pci 0000:00:1c.4:   bridge window [mem 0x80400000-0x805fffff 64bit pref]
pci 0000:00:1c.5: PCI bridge to [bus 0f-0f]
pci 0000:00:1c.5:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.5:   bridge window [mem 0xdc200000-0xdc2fffff]
pci 0000:00:1c.5:   bridge window [mem 0x80600000-0x807fffff 64bit pref]
pci 0000:00:1e.0: PCI bridge to [bus 11-11]
pci 0000:00:1e.0:   bridge window [io  0x4000-0x4fff]
pci 0000:00:1e.0:   bridge window [mem 0xdc300000-0xdc3fffff]
pci 0000:00:1e.0:   bridge window [mem 0xde000000-0xdfffffff 64bit pref]
pci 0000:00:1c.0: enabling device (0040 -> 0043)
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.5: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 6 [mem 0x000cc000-0x000cffff]
pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
pci_bus 0000:00: resource 11 [mem 0x80000000-0xdfffffff]
pci_bus 0000:00: resource 12 [io  0x0d00-0xfdff]
pci_bus 0000:00: resource 13 [mem 0xfed40000-0xfed44fff]
pci_bus 0000:05: resource 0 [io  0x5000-0x5fff]
pci_bus 0000:05: resource 1 [mem 0x80000000-0x801fffff]
pci_bus 0000:05: resource 2 [mem 0x80200000-0x803fffff 64bit pref]
pci_bus 0000:0d: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:0d: resource 1 [mem 0xdc100000-0xdc1fffff]
pci_bus 0000:0d: resource 2 [mem 0x80400000-0x805fffff 64bit pref]
pci_bus 0000:0f: resource 0 [io  0x3000-0x3fff]
pci_bus 0000:0f: resource 1 [mem 0xdc200000-0xdc2fffff]
pci_bus 0000:0f: resource 2 [mem 0x80600000-0x807fffff 64bit pref]
pci_bus 0000:11: resource 0 [io  0x4000-0x4fff]
pci_bus 0000:11: resource 1 [mem 0xdc300000-0xdc3fffff]
pci_bus 0000:11: resource 2 [mem 0xde000000-0xdfffffff 64bit pref]
pci_bus 0000:11: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:11: resource 5 [mem 0x000a0000-0x000bffff]
pci_bus 0000:11: resource 6 [mem 0x000cc000-0x000cffff]
pci_bus 0000:11: resource 7 [mem 0x000d0000-0x000d3fff]
pci_bus 0000:11: resource 8 [mem 0x000d4000-0x000d7fff]
pci_bus 0000:11: resource 9 [mem 0x000d8000-0x000dbfff]
pci_bus 0000:11: resource 10 [mem 0x000dc000-0x000dffff]
pci_bus 0000:11: resource 11 [mem 0x80000000-0xdfffffff]
pci_bus 0000:11: resource 12 [io  0x0d00-0xfdff]
pci_bus 0000:11: resource 13 [mem 0xfed40000-0xfed44fff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
UDP hash table entries: 512 (order: 2, 16384 bytes)
UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
NET: Registered protocol family 1
pci 0000:11:04.0: Boot video device
PCI: CLS 32 bytes, default 64
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 1824k freed
Simple Boot Flag at 0x36 set to 0x1
HugeTLB registered 4 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 1766
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:1c.0: setting latency timer to 64
pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
pcieport 0000:00:1c.4: setting latency timer to 64
pcieport 0000:00:1c.4: irq 41 for MSI/MSI-X
pcieport 0000:00:1c.5: setting latency timer to 64
pcieport 0000:00:1c.5: irq 42 for MSI/MSI-X
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0b: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
brd: module loaded
PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
rtc_cmos 00:05: RTC can wake from S4
rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
cpuidle: using governor ladder
No iBFT detected.
TCP cubic registered
NET: Registered protocol family 17
Using IPI No-Shortcut mode
rtc_cmos 00:05: setting system clock to 2010-07-26 17:23:55 UTC (1280165035)
Freeing unused kernel memory: 312k freed
SCSI subsystem initialized
libata version 3.00 loaded.
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pmp pio slum part ccc ems sxs 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m2048@0xdc000800 port 0xdc000900 irq 43
ata2: SATA max UDMA/133 abar m2048@0xdc000800 port 0xdc000980 irq 43
ata3: SATA max UDMA/133 abar m2048@0xdc000800 port 0xdc000a00 irq 43
ata4: SATA max UDMA/133 abar m2048@0xdc000800 port 0xdc000a80 irq 43
ata5: SATA max UDMA/133 abar m2048@0xdc000800 port 0xdc000b00 irq 43
ata6: SATA max UDMA/133 abar m2048@0xdc000800 port 0xdc000b80 irq 43
ata4: SATA link down (SStatus 0 SControl 300)
ata2: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
ata3: SATA link down (SStatus 0 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-8: WDC WD2502ABYS-02B7A0, 02.03B03, max UDMA/133
ata1.00: 490350672 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      WDC WD2502ABYS-0 02.0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 490350672 512-byte logical blocks: (251 GB/233 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 < sda5 >
sd 0:0:0:0: [sda] Attached SCSI disk
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda1): mounted filesystem with writeback data mode
udevd version 125 started
e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k4
e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
e1000e 0000:0d:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
e1000e 0000:0d:00.0: setting latency timer to 64
e1000e 0000:0d:00.0: (unregistered net_device): CRC Stripping Disabled
e1000e 0000:0d:00.0: irq 44 for MSI/MSI-X
e1000e 0000:0d:00.0: Disabling ASPM L0s 
ACPI: acpi_idle registered with cpuidle
input: PC Speaker as /class/input/input0
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
i801_smbus 0000:00:1f.3: enabling device (0001 -> 0003)
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1a.0: irq 16, io base 0x00001820
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: UHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.35-rc6 uhci_hcd
usb usb1: SerialNumber: 0000:00:1a.0
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1a.1: irq 17, io base 0x00001840
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.35-rc6 uhci_hcd
usb usb2: SerialNumber: 0000:00:1a.1
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1a.2: setting latency timer to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.2: irq 18, io base 0x00001860
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.35-rc6 uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.2
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001880
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.35-rc6 uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.0
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.1: irq 22, io base 0x000018a0
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.35-rc6 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.1
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018c0
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.35-rc6 uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.2
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
e1000e 0000:0d:00.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:30:48:fd:0f:8c
e1000e 0000:0d:00.0: eth0: Intel(R) PRO/1000 Network Connection
e1000e 0000:0d:00.0: eth0: MAC: 2, PHY: 2, PBA No: 0100ff-0ff
e1000e 0000:0f:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
e1000e 0000:0f:00.0: setting latency timer to 64
e1000e 0000:0f:00.0: (unregistered net_device): CRC Stripping Disabled
e1000e 0000:0f:00.0: irq 45 for MSI/MSI-X
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 7
ehci_hcd 0000:00:1a.7: debug port 1
e1000e 0000:0f:00.0: Disabling ASPM L0s 
ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xdc000000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: EHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.35-rc6 ehci_hcd
usb usb7: SerialNumber: 0000:00:1a.7
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 6 ports detected
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 8
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xdc000400
input: Power Button as /class/input/input1
ACPI: Power Button [PWRB]
input: Power Button as /class/input/input2
ACPI: Power Button [PWRF]
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb8: New USB device found, idVendor=1d6b, idProduct=0002
usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb8: Product: EHCI Host Controller
usb usb8: Manufacturer: Linux 2.6.35-rc6 ehci_hcd
usb usb8: SerialNumber: 0000:00:1d.7
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 6 ports detected
e1000e 0000:0f:00.0: eth1: (PCI Express:2.5GB/s:Width x1) 00:30:48:fd:0f:8d
e1000e 0000:0f:00.0: eth1: Intel(R) PRO/1000 Network Connection
e1000e 0000:0f:00.0: eth1: MAC: 2, PHY: 2, PBA No: ffffff-0ff
usbcore: registered new interface driver usbserial
USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
usbserial: USB Serial Driver core
USB Serial support registered for GSM modem (1-port)
usbcore: registered new interface driver option
option: v0.7.2:USB Driver for GSM modems
usb 4-2: new full speed USB device using uhci_hcd and address 2
usb 4-2: New USB device found, idVendor=058f, idProduct=9254
usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 4-2: Product: Generic USB Hub
usb 4-2: Manufacturer: ALCOR
hub 4-2:1.0: USB hub found
hub 4-2:1.0: 4 ports detected
usb 4-2.2: new low speed USB device using uhci_hcd and address 3
usb 4-2.2: New USB device found, idVendor=0461, idProduct=4d09
usb 4-2.2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usbcore: registered new interface driver hiddev
input: HID 0461:4d09 as /class/input/input3
generic-usb 0003:0461:4D09.0001: input,hidraw0: USB HID v1.00 Mouse [HID 0461:4d09] on usb-0000:00:1d.0-2.2/input0
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
usb 4-2.3: new low speed USB device using uhci_hcd and address 4
Adding 2650688k swap on /dev/sda5.  Priority:-1 extents:1 across:2650688k 
usb 4-2.3: New USB device found, idVendor=047b, idProduct=0002
usb 4-2.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 4-2.3: Product: USB Keyboard and Mouse
usb 4-2.3: Manufacturer: SILITEK
input: SILITEK USB Keyboard and Mouse as /class/input/input4
generic-usb 0003:047B:0002.0002: input,hidraw1: USB HID v1.00 Keyboard [SILITEK USB Keyboard and Mouse] on usb-0000:00:1d.0-2.3/input0
input: SILITEK USB Keyboard and Mouse as /class/input/input5
generic-usb 0003:047B:0002.0003: input,hidraw2: USB HID v1.00 Mouse [SILITEK USB Keyboard and Mouse] on usb-0000:00:1d.0-2.3/input1
EXT3-fs (sda1): using internal journal
ipmi message handler version 39.2
IPMI System Interface driver.
ipmi_si: probing via SMBIOS
ipmi_si: Adding SMBIOS-specified kcs state machine
ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca8, slave address 0x20, irq 0
ipmi_si ipmi_si.0: Found new BMC (man_id: 0x0015d9, prod_id: 0x1134, dev_id: 0x20)
ipmi_si ipmi_si.0: IPMI kcs interface initialized
IPMI Watchdog: driver initialized
ipmi device interface
e1000e 0000:0d:00.0: irq 44 for MSI/MSI-X
e1000e 0000:0d:00.0: irq 44 for MSI/MSI-X
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth0: link is not ready
e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
e1000e 0000:0d:00.0: eth0: 10/100 speed: disabling TSO
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
eth0: no IPv6 routers present

--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=pci

00:00.0 Host bridge: Intel Corporation 3200/3210 Chipset DRAM Controller (rev 01)
00: 86 80 f0 29 46 01 90 20 01 00 00 06 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 d9 15 80 d8
30: 00 00 00 00 e0 00 00 00 00 00 00 00 00 00 00 00
40: 01 90 d1 fe 00 00 00 00 01 40 d1 fe 00 00 00 00
50: 00 00 02 00 01 00 00 00 00 00 00 00 00 00 00 00
60: 01 00 00 e0 00 00 00 00 01 80 d1 fe 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 10 11 01 00 00 11 11 00 ff 03 00 00 00 1a 39 00
a0: 20 00 00 08 00 00 00 80 00 00 00 80 00 00 f0 7f
b0: 00 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 49 00 00 00 00 00 00 6e
e0: 09 00 0c 91 64 e4 fc c2 43 44 0b 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 90 0f 01 00 00 00 00 00

00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 02)
00: 86 80 37 29 05 00 90 02 02 00 03 0c 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 21 18 00 00 00 00 00 00 00 00 00 00 d9 15 80 d8
30: 00 00 00 00 50 00 00 00 00 00 00 00 05 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 2f 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 02 00 00 00 00 00

00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 02)
00: 86 80 38 29 05 00 90 02 02 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 41 18 00 00 00 00 00 00 00 00 00 00 d9 15 80 d8
30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 02 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 2f 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 02 00 00 00 00 00

00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 02)
00: 86 80 39 29 05 00 90 02 02 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 61 18 00 00 00 00 00 00 00 00 00 00 d9 15 80 d8
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 03 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 2f 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 02 00 00 00 00 00

00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 02)
00: 86 80 3c 29 46 01 90 02 02 20 03 0c 00 00 00 00
10: 00 00 00 dc 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 d9 15 80 d8
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 03 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 58 c2 c9 00 00 00 00 0a 98 a0 20 00 00 00 00
60: 20 20 ff 00 00 00 00 00 01 00 00 01 00 00 08 80
70: 00 00 df 0f 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 13 00 06 03 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 aa ff 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 86 85 40 00 86 0f 02 00 0a 13 02 20

00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 02)
00: 86 80 40 29 47 04 10 00 02 00 04 06 08 00 81 00
10: 00 00 00 00 00 00 00 00 00 05 05 00 50 50 00 00
20: 00 80 10 80 21 80 31 80 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 05 01 40 00
40: 10 80 41 01 00 80 00 00 04 00 10 00 41 2c 11 01
50: 50 00 01 10 60 00 00 00 00 00 00 00 04 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 05 90 01 00 0c 30 e0 fe 49 41 00 00 00 00 00 00
90: 0d a0 00 00 d9 15 80 d8 00 00 00 00 00 00 00 00
a0: 01 00 02 c8 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 80 00 11 08 00 00 00 00
e0: 00 00 c7 00 06 07 08 00 30 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 02 00 00 00 00 00

00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 5 (rev 02)
00: 86 80 48 29 47 04 10 00 02 00 04 06 08 00 81 00
10: 00 00 00 00 00 00 00 00 00 0d 0d 00 20 20 00 00
20: 10 dc 10 dc 41 80 51 80 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 05 01 04 00
40: 10 80 41 01 00 80 00 00 04 00 10 00 11 2c 11 05
50: 40 00 11 30 60 05 28 00 00 00 48 01 04 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 05 90 01 00 0c 30 e0 fe 51 41 00 00 00 00 00 00
90: 0d a0 00 00 d9 15 80 d8 00 00 00 00 00 00 00 00
a0: 01 00 02 c8 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 80 00 11 08 00 00 00 00
e0: 00 00 c7 00 06 07 08 00 30 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 02 00 00 00 00 00

00:1c.5 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 6 (rev 02)
00: 86 80 4a 29 47 04 10 00 02 00 04 06 08 00 81 00
10: 00 00 00 00 00 00 00 00 00 0f 0f 00 30 30 00 00
20: 20 dc 20 dc 61 80 71 80 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 02 04 00
40: 10 80 41 01 00 80 00 00 04 00 10 00 11 2c 11 06
50: 40 00 11 30 60 05 30 00 00 00 48 01 04 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 05 90 01 00 0c 30 e0 fe 59 41 00 00 00 00 00 00
90: 0d a0 00 00 d9 15 80 d8 00 00 00 00 00 00 00 00
a0: 01 00 02 c8 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 80 00 11 08 00 00 00 00
e0: 00 00 c7 00 06 07 08 00 30 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 02 00 00 00 00 00

00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 02)
00: 86 80 34 29 05 00 90 02 02 00 03 0c 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 81 18 00 00 00 00 00 00 00 00 00 00 d9 15 80 d8
30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 2f 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 02 00 00 00 00 00

00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 02)
00: 86 80 35 29 05 00 90 02 02 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: a1 18 00 00 00 00 00 00 00 00 00 00 d9 15 80 d8
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 02 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 2f 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 02 00 00 00 00 00

00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 02)
00: 86 80 36 29 05 00 90 02 02 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: c1 18 00 00 00 00 00 00 00 00 00 00 d9 15 80 d8
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 03 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 2f 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 02 00 00 00 00 00

00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 02)
00: 86 80 3a 29 46 01 90 02 02 20 03 0c 00 00 00 00
10: 00 04 00 dc 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 d9 15 80 d8
30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 58 c2 c9 00 00 00 00 0a 98 a0 20 00 00 00 00
60: 20 20 ff 00 00 00 00 00 01 00 00 01 00 00 08 80
70: 00 00 df 0f 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 13 00 06 03 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 aa ff 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 86 85 40 00 86 0f 02 00 0a 13 02 20

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92)
00: 86 80 4e 24 47 01 10 00 92 01 04 06 00 00 01 00
10: 00 00 00 00 00 00 00 00 00 11 11 20 40 40 80 22
20: 30 dc 30 dc 01 de f1 df 00 00 00 00 00 00 00 00
30: 00 00 00 00 50 00 00 00 00 00 00 00 ff 00 0c 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 12 00 00
50: 0d 00 00 00 d9 15 80 d8 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 02 00 00 00 00 00

00:1f.0 ISA bridge: Intel Corporation 82801IR (ICH9R) LPC Interface Controller (rev 02)
00: 86 80 16 29 07 00 10 02 02 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 d9 15 80 d8
30: 00 00 00 00 e0 00 00 00 00 00 00 00 00 00 00 00
40: 01 10 00 00 80 00 00 00 81 11 00 00 10 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 85 8a 8b 80 d0 00 00 00 80 80 8b 8a f8 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 10 00 0f 3f 91 02 94 00 a1 0c ac 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 20 02 00 00 08 00 00 00 13 00 00 00 00 03 00 40
b0: 00 00 f0 00 00 00 00 00 01 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 33 22 11 00 67 45 00 00 cf ff 00 00 00 00 00 00
e0: 09 00 0c 10 00 00 c4 02 64 00 00 00 00 00 00 00
f0: 01 c0 d1 fe 00 00 00 00 86 0f 02 00 00 00 00 00

00:1f.2 SATA controller: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 6 port SATA AHCI Controller (rev 02)
00: 86 80 22 29 47 04 b0 02 02 01 06 01 00 00 00 00
10: 51 1c 00 00 45 1c 00 00 49 1c 00 00 41 1c 00 00
20: e1 18 00 00 00 08 00 dc 00 00 00 00 d9 15 80 d8
30: 00 00 00 00 80 00 00 00 00 00 00 00 0a 02 00 00
40: 00 80 77 f3 f0 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 01 a8 03 40 08 00 00 00 00 00 00 00 00 00 00 00
80: 05 70 09 00 0c 30 e0 fe 61 41 00 00 00 00 00 00
90: 60 00 3f 81 93 01 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 12 b0 10 00 48 00 00 00
b0: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 05 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 02 00 00 00 00 00

00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 02)
00: 86 80 30 29 03 00 80 02 02 00 05 0c 00 00 00 00
10: 04 10 00 dc 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 11 00 00 00 00 00 00 00 00 00 00 d9 15 80 d8
30: 00 00 00 00 00 00 00 00 00 00 00 00 0a 02 00 00
40: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 03 04 04 00 00 00 08 08 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 02 00 00 00 00 00

00:1f.6 Signal processing controller: Intel Corporation 82801I (ICH9 Family) Thermal Subsystem (rev 02)
00: 86 80 32 29 02 00 10 00 02 00 80 11 00 00 00 00
10: 04 20 00 dc 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 d9 15 00 00
30: 00 00 00 00 50 00 00 00 00 00 00 00 05 01 00 00
40: 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 00 23 00 08 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 02 00 00 00 00 00

0d:00.0 Ethernet controller: Intel Corporation 82573E Gigabit Ethernet Controller (Copper) (rev 03)
00: 86 80 8c 10 47 05 10 00 03 00 00 02 10 00 00 00
10: 00 00 10 dc 00 00 00 00 01 20 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 d9 15 8c 10
30: 00 00 00 00 c8 00 00 00 00 00 00 00 05 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 01 d0 22 c8 00 20 00 0f
d0: 05 e0 81 00 0c 30 e0 fe 00 00 00 00 99 41 00 00
e0: 10 00 01 00 c1 0c 00 00 1f 28 1a 00 11 10 03 00
f0: 40 00 11 10 00 00 00 00 00 00 00 00 00 00 00 00

0f:00.0 Ethernet controller: Intel Corporation 82573L Gigabit Ethernet Controller
00: 86 80 9a 10 47 05 10 00 00 00 00 02 10 00 00 00
10: 00 00 20 dc 00 00 00 00 01 30 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 d9 15 9a 10
30: 00 00 00 00 c8 00 00 00 00 00 00 00 0a 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 01 d0 22 c8 00 20 00 0f
d0: 05 e0 81 00 0c 30 e0 fe 00 00 00 00 89 41 00 00
e0: 10 00 01 00 c1 0c 00 00 1f 28 1a 00 11 10 07 00
f0: 40 00 11 10 00 00 00 00 00 00 00 00 00 00 00 00

11:04.0 VGA compatible controller: XGI Technology Inc. (eXtreme Graphics Innovation) Device 0021
00: ca 18 21 00 03 00 30 02 00 00 00 03 00 00 00 80
10: 08 00 00 de 00 00 30 dc 01 40 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 d9 15 80 d8
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 00 00 00
40: 01 00 02 06 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmi

# dmidecode 2.9
SMBIOS 2.5 present.
39 structures occupying 1615 bytes.
Table at 0x7FEDF000.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: Phoenix Technologies LTD
	Version: 1.2a      
	Release Date: 12/19/2008
	Address: 0xE38F0
	Runtime Size: 116496 bytes
	ROM Size: 2048 kB
	Characteristics:
		ISA is supported
		PCI is supported
		PNP is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		ESCD support is available
		Boot from CD is supported
		Selectable boot is supported
		BIOS ROM is socketed
		EDD is supported
		5.25"/1.2 MB floppy services are supported (int 13h)
		3.5"/720 KB floppy services are supported (int 13h)
		3.5"/2.88 MB floppy services are supported (int 13h)
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		Printer services are supported (int 17h)
		CGA/mono video services are supported (int 10h)
		USB legacy is supported
		Smart battery is supported
		BIOS boot specification is supported
		Targeted content distribution is supported

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: DEPO Computers
	Product Name: X7SBL
	Version: 0123456789
	Serial Number: DEPO Computers
	UUID: 53D1A494-D663-A0E7-890B-003048FD0F8C
	Wake-up Type: Power Switch
	SKU Number: Not Specified
	Family: Not Specified

Handle 0x0002, DMI type 2, 8 bytes
Base Board Information
	Manufacturer: Supermicro
	Product Name: X7SBL
	Version: PCB Version
	Serial Number: 0123456789

Handle 0x0003, DMI type 3, 17 bytes
Chassis Information
	Manufacturer: Supermicro
	Type: Other
	Lock: Not Present
	Version: 0123456789
	Serial Number: 0123456789
	Asset Tag:  
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: None
	OEM Information: 0x00001234

Handle 0x0004, DMI type 4, 35 bytes
Processor Information
	Socket Designation: CPU 1
	Type: Central Processor
	Family: <OUT OF SPEC>
	Manufacturer: Intel
	ID: 7A 06 01 00 FF FB EB BF
	Version: 00000000000000000000000000000000
	Voltage: 1.8 V
	External Clock: Unknown
	Max Speed: 3300 MHz
	Current Speed: 2600 MHz
	Status: Populated, Enabled
	Upgrade: Socket LGA775
	L1 Cache Handle: 0x0005
	L2 Cache Handle: 0x0006
	L3 Cache Handle: Not Provided
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified

Handle 0x0005, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L1 Cache
	Configuration: Enabled, Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 16 KB
	Maximum Size: 16 KB
	Supported SRAM Types:
		Burst
		Pipeline Burst
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Unknown
	System Type: Unknown
	Associativity: Unknown

Handle 0x0006, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L2 Cache
	Configuration: Enabled, Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 2048 KB
	Maximum Size: 512 KB
	Supported SRAM Types:
		Burst
		Pipeline Burst
		Asynchronous
	Installed SRAM Type: Burst
	Speed: Unknown
	Error Correction Type: Unknown
	System Type: Unknown
	Associativity: Unknown

Handle 0x0007, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L3 Cache
	Configuration: Enabled, Socketed, Level 3
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 2048 KB
	Maximum Size: 512 KB
	Supported SRAM Types:
		Burst
		Pipeline Burst
		Asynchronous
	Installed SRAM Type: Burst
	Speed: Unknown
	Error Correction Type: Unknown
	System Type: Unknown
	Associativity: Unknown

Handle 0x0008, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J2A1
	Internal Connector Type: 9 Pin Dual Inline (pin 10 cut)
	External Reference Designator: COM 1
	External Connector Type: DB-9 male
	Port Type: Serial Port 16550A Compatible

Handle 0x0009, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J3A1
	Internal Connector Type: 25 Pin Dual Inline (pin 26 cut)
	External Reference Designator: Parallel
	External Connector Type: DB-25 female
	Port Type: Parallel Port ECP/EPP

Handle 0x000A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J1A1
	Internal Connector Type: None
	External Reference Designator: Keyboard
	External Connector Type: Circular DIN-8 male
	Port Type: Keyboard Port

Handle 0x000B, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J1A1
	Internal Connector Type: None
	External Reference Designator: PS/2 Mouse
	External Connector Type: Circular DIN-8 male
	Port Type: Keyboard Port

Handle 0x000C, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI Slot #1 - J5B1
	Type: 32-bit PCI
	Current Usage: Available
	Length: Long
	ID: 1
	Characteristics:
		5.0 V is provided
		3.3 V is provided

Handle 0x000D, DMI type 9, 13 bytes
System Slot Information
	Designation: PCIe Slot #1 - J7C1
	Type: 32-bit PCI Express
	Current Usage: Unknown
	Length: Long
	ID: 0
	Characteristics:
		5.0 V is provided
		3.3 V is provided

Handle 0x000E, DMI type 10, 6 bytes
On Board Device Information
	Type: Sound
	Status: Disabled
	Description: ADI1886

Handle 0x000F, DMI type 11, 5 bytes
OEM Strings
	String 1: This is the Intel 965
	String 2: Customer Reference Board

Handle 0x0010, DMI type 12, 5 bytes
System Configuration Options
	Option 1: Jumper settings can be described here.

Handle 0x0011, DMI type 15, 29 bytes
System Event Log
	Area Length: 112 bytes
	Header Start Offset: 0x0000
	Header Length: 16 bytes
	Data Start Offset: 0x0010
	Access Method: General-purpose non-volatile data functions
	Access Address: 0x0000
	Status: Valid, Not Full
	Change Token: 0x00000010
	Header Format: Type 1
	Supported Log Type Descriptors: 3
	Descriptor 1: POST error
	Data Format 1: POST results bitmap
	Descriptor 2: Single-bit ECC memory error
	Data Format 2: Multiple-event
	Descriptor 3: Multi-bit ECC memory error
	Data Format 3: Multiple-event

Handle 0x0012, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 8 GB
	Error Information Handle: Not Provided
	Number Of Devices: 4

Handle 0x0013, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0012
	Error Information Handle: No Error
	Total Width: 40968 bits
	Data Width: 41024 bits
	Size: 1024 MB
	Form Factor: DIMM
	Set: 1
	Locator: J6G1
	Bank Locator: DIMM 0
	Type: DDR2
	Type Detail: Synchronous
	Speed: 800 MHz (1.2 ns)
	Manufacturer: Hyundai Electronics                             
	Serial Number: 3F42892C
	Asset Tag: 41411005
	Part Number: 48594D503131325536344350382D53362020

Handle 0x0014, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0012
	Error Information Handle: No Error
	Total Width: Unknown
	Data Width: Unknown
	Size: No Module Installed
	Form Factor: DIMM
	Set: 1
	Locator: J6G2
	Bank Locator: DIMM 1
	Type: DDR2
	Type Detail: Synchronous
	Speed: 800 MHz (1.2 ns)
	Manufacturer: 48spaces                                        
	Serial Number: 01234567
	Asset Tag: 01234567
	Part Number: 012345678901234567890123456789012345

Handle 0x0015, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0012
	Error Information Handle: No Error
	Total Width: 41992 bits
	Data Width: 42048 bits
	Size: 1024 MB
	Form Factor: DIMM
	Set: 1
	Locator: J6H1
	Bank Locator: DIMM 2
	Type: DDR2
	Type Detail: Synchronous
	Speed: 800 MHz (1.2 ns)
	Manufacturer: Hyundai Electronics                             
	Serial Number: 0F7036B0
	Asset Tag: 00001004
	Part Number: 48594D503131325536344350382D53362020

Handle 0x0016, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0012
	Error Information Handle: No Error
	Total Width: Unknown
	Data Width: Unknown
	Size: No Module Installed
	Form Factor: DIMM
	Set: 1
	Locator: J6H2
	Bank Locator: DIMM 3
	Type: DDR2
	Type Detail: Synchronous
	Speed: 800 MHz (1.2 ns)
	Manufacturer: 48spaces                                        
	Serial Number: 01234567
	Asset Tag: 01234567
	Part Number: 012345678901234567890123456789012345

Handle 0x0017, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0007FFFFFFF
	Range Size: 2 GB
	Physical Array Handle: 0x0012
	Partition Width: 0

Handle 0x0018, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0003FFFFFFF
	Range Size: 1 GB
	Physical Device Handle: 0x0013
	Memory Array Mapped Address Handle: 0x0017
	Partition Row Position: Unknown
	Interleave Position: Unknown
	Interleaved Data Depth: Unknown

Handle 0x0019, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x0003FFFFC00
	Ending Address: 0x0003FFFFFFF
	Range Size: 1 kB
	Physical Device Handle: 0x0014
	Memory Array Mapped Address Handle: 0x0017
	Partition Row Position: Unknown
	Interleave Position: Unknown
	Interleaved Data Depth: Unknown

Handle 0x001A, DMI type 23, 13 bytes
System Reset
	Status: Enabled
	Watchdog Timer: Present
	Boot Option: Do Not Reboot
	Boot Option On Limit: Do Not Reboot
	Reset Count: Unknown
	Reset Limit: Unknown
	Timer Interval: Unknown
	Timeout: Unknown

Handle 0x001B, DMI type 24, 5 bytes
Hardware Security
	Power-On Password Status: Disabled
	Keyboard Password Status: Unknown
	Administrator Password Status: Disabled
	Front Panel Reset Status: Unknown

Handle 0x001C, DMI type 25, 9 bytes
	System Power Controls
	Next Scheduled Power-on: 12-31 23:59:59

Handle 0x001D, DMI type 26, 20 bytes
Voltage Probe
	Description: Voltage Probe
	Location: Processor
	Status: OK
	Maximum Value: Unknown
	Minimum Value: Unknown
	Resolution: Unknown
	Tolerance: Unknown
	Accuracy: Unknown
	OEM-specific Information: 0x00000000

Handle 0x001E, DMI type 27, 12 bytes
Cooling Device
	Temperature Probe Handle: 0x001F
	Type: Fan
	Status: OK
	OEM-specific Information: 0x00000000

Handle 0x001F, DMI type 28, 20 bytes
Temperature Probe
	Description: Temperature Probe
	Location: Processor
	Status: OK
	Maximum Value: Unknown
	Minimum Value Unknown
	Resolution: Unknown
	Tolerance: Unknown
	Accuracy: Unknown
	OEM-specific Information: 0x00000000

Handle 0x0020, DMI type 29, 20 bytes
Electrical Current Probe
	Description: Electrical Current Probe
	Location: Processor
	Status: OK
	Maximum Value: Unknown
	Minimum Value: Unknown
	Resolution: Unknown
	Tolerance: Unknown
	Accuracy: Unknown
	OEM-specific Information: 0x00000000

Handle 0x0021, DMI type 30, 6 bytes
Out-of-band Remote Access
	Manufacturer Name: Intel
	Inbound Connection: Enabled
	Outbound Connection: Disabled

Handle 0x0022, DMI type 32, 20 bytes
System Boot Information
	Status: <OUT OF SPEC>

Handle 0x0023, DMI type 38, 18 bytes
IPMI Device Information
	Interface Type: KCS (Keyboard Control Style)
	Specification Version: 2.0
	I2C Slave Address: 0x10
	NV Storage Device: Not Present
	Base Address: 0x0000000000000CA8 (I/O)
	Register Spacing: 32-bit Boundaries

Handle 0x0024, DMI type 126, 4 bytes
Inactive

Handle 0x0025, DMI type 127, 4 bytes
End Of Table

Handle 0x0026, DMI type 127, 4 bytes
End Of Table


--k+w/mQv8wyuph6w0--
