Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab0CXJGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 05:06:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105Ab0CXJGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 05:06:37 -0400
Date: Wed, 24 Mar 2010 10:04:39 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Airlie <airlied@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>
Subject: Re: Can not boot with CONFIG_NO_BOOTMEM=y on i686
Message-ID: <20100324090438.GA7512@dhcp-lab-161.englab.brq.redhat.com>
References: <20100319131208.GA3911@dhcp-lab-161.englab.brq.redhat.com> <86802c441003201126j407eaf89j91cf91ae69454f30@mail.gmail.com> <20100323113551.GA3862@dhcp-lab-161.englab.brq.redhat.com> <4BA98FA8.1040600@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA98FA8.1040600@kernel.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 09:06:00PM -0700, Yinghai Lu wrote:
> On 03/23/2010 04:35 AM, Stanislaw Gruszka wrote:
> > On Sat, Mar 20, 2010 at 11:26:06AM -0700, Yinghai Lu wrote:
> >>> After update to 2.6.34-rc1, I was experimented by strange oopses during
> >>> boot, what looked like memory corruption. Bisection shows that first bad
> >>> commit is 59be5a8e8ce765cf739ec7f07176219972de7481 ("x86: Make 32bit
> >>> support NO_BOOTMEM"). When I disable CONFIG_NO_BOOTMEM I'm able to start
> >>> system. Not sure what info is need to track down this issue, so please
> >>> let me know.
> >>
> >> can you check patch
> >>
> >> https://patchwork.kernel.org/patch/87081/
> > 
> > Patch helps somehow. Instead of many random oopses, now I have one and
> > the same oops, here is photo:
> > http://people.redhat.com/sgruszka/20100322_001.jpg
> 
> how does e820 look like?

dmesg below, I hope everything you asked for is here:

Linux version 2.6.34-rc1 (stasiu@yellow) (gcc version 4.4.2 20091222 (Red Hat 4.4.2-20) (GCC) ) #26 SMP Tue Mar 23 11:31:22 CET 2010
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 0000000000096400 (usable)
 BIOS-e820: 0000000000096400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cffc2840 (usable)
 BIOS-e820: 00000000cffc2840 - 00000000d0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
DMI 2.5 present.
e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
last_pfn = 0xcffc2 max_arch_pfn = 0x100000
MTRR default type: write-back
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-E7FFF write-protect
  E8000-EFFFF write-back
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 0130000000 mask 3FF0000000 uncachable
  1 base 00D0000000 mask 3FF0000000 uncachable
  2 base 00E0000000 mask 3FE0000000 uncachable
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
initial memory mapped : 0 - 01000000
found SMP MP-table at [c00fe700] fe700
init_memory_mapping: 0000000000000000-00000000373fe000
 0000000000 - 0000400000 page 4k
 0000400000 - 0037000000 page 2M
 0037000000 - 00373fe000 page 4k
kernel direct mapping tables up to 373fe000 @ 7000-d000
RAMDISK: 373b8000 - 37fef224
Allocated new RAMDISK: 00b2f000 - 01766224
Move RAMDISK from 00000000373b8000 - 0000000037fef223 to 00b2f000 - 01766223
Reserving 256MB of memory at 32MB for crashkernel (System RAM: 3327MB)
ACPI: RSDP 000e9810 00024 (v02 HPQOEM)
ACPI: XSDT cffc52ec 0005C (v01 HPQOEM SLIC-WKS 20081015      00000000)
ACPI: FACP cffc5494 000F4 (v03 HPQOEM SEABURG  00000001      00000000)
ACPI Error: 32/64X address mismatch in Gpe0Block: 0000F828/000000000001F030, using 32 (20100121/tbfadt-427)
ACPI: DSDT cffc5a7a 026A4 (v01 HPQOEM     DSDT 00000001 MSFT 0100000E)
ACPI: FACS cffc5200 00040
ACPI: SSDT cffc811e 06DC0 (v01 HPQOEM  PROJECT 00000001 MSFT 0100000E)
ACPI: APIC cffc5588 000D4 (v01 HPQOEM SEABURG  00000001      00000000)
ACPI: ASF! cffc565c 0006A (v32 HPQOEM SEABURG  00000001      00000000)
ACPI: MCFG cffc585e 0003C (v01 HPQOEM SEABURG  00000001      00000000)
ACPI: HPET cffc5a10 00038 (v01 HPQOEM SEABURG  00000001      00000000)
ACPI: TCPA cffc5a48 00032 (v01 HPQOEM SEABURG  00000001      00000000)
ACPI: Local APIC address 0xfee00000
2443MB HIGHMEM available.
883MB LOWMEM available.
  mapped low ram: 0 - 373fe000
  low ram: 0 - 373fe000
  node 0 low ram: 00000000 - 373fe000
  node 0 bootmap 0000a000 - 00010e80
(14/32 early reservations) ==> bootmem [0000000000 - 00373fe000]
  #0 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #1 [0000400000 - 0000b29430]    TEXT DATA BSS ==> [0000400000 - 0000b29430]
  #2 [0000b2a000 - 0000b2e114]              BRK ==> [0000b2a000 - 0000b2e114]
  #3 [00000fe710 - 0000100000]    BIOS reserved ==> [00000fe710 - 0000100000]
  #4 [00000fe700 - 00000fe710]     MP-table mpf ==> [00000fe700 - 00000fe710]
  #5 [0000096400 - 00000efc20]    BIOS reserved ==> [0000096400 - 00000efc20]
  #6 [00000effc4 - 00000fe700]    BIOS reserved ==> [00000effc4 - 00000fe700]
  #7 [00000efc20 - 00000effc4]     MP-table mpc ==> [00000efc20 - 00000effc4]
  #8 [0000002000 - 0000003000]       TRAMPOLINE ==> [0000002000 - 0000003000]
  #9 [0000003000 - 0000007000]      ACPI WAKEUP ==> [0000003000 - 0000007000]
  #10 [0000007000 - 000000a000]          PGTABLE ==> [0000007000 - 000000a000]
  #11 [0000b2f000 - 0001766224]      NEW RAMDISK ==> [0000b2f000 - 0001766224]
  #12 [0002000000 - 0012000000]     CRASH KERNEL ==> [0002000000 - 0012000000]
  #13 [000000a000 - 0000011000]          BOOTMAP ==> [000000a000 - 0000011000]
Zone PFN ranges:
  DMA      0x00000001 -> 0x00001000
  Normal   0x00001000 -> 0x000373fe
  HighMem  0x000373fe -> 0x000cffc2
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000001 -> 0x00000096
    0: 0x00000100 -> 0x000cffc2
On node 0 totalpages: 851799
free_area_init_node: node 0, pgdat c09aa640, node_mem_map d2000020
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3957 pages, LIFO batch:0
  Normal zone: 1736 pages used for memmap
  Normal zone: 220470 pages, LIFO batch:31
  HighMem zone: 4888 pages used for memmap
  HighMem zone: 620716 pages, LIFO batch:31
Using APIC driver default
ACPI: PM-Timer IO Port: 0xf808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x08] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x09] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x0a] disabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x0b] disabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x02] address[0xfec89000] gsi_base[24])
IOAPIC[1]: apic_id 2, version 32, address 0xfec89000, GSI 24-47
ACPI: IOAPIC (id[0x03] address[0xfec88000] gsi_base[48])
IOAPIC[2]: apic_id 3, version 32, address 0xfec88000, GSI 48-71
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 8 CPUs, 4 hotplug CPUs
nr_irqs_gsi: 72
PM: Registered nosave memory: 0000000000096000 - 0000000000097000
PM: Registered nosave memory: 0000000000097000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e8000
PM: Registered nosave memory: 00000000000e8000 - 0000000000100000
Allocating PCI resources starting at d0000000 (gap: d0000000:10000000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:8 nr_node_ids:1
PERCPU: Embedded 14 pages/cpu @d3c00000 s34132 r0 d23212 u524288
pcpu-alloc: s34132 r0 d23212 u524288 alloc=1*4194304
pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 845143
Kernel command line: ro root=UUID=ab03f13d-37dd-425b-90cf-52da063dccfe rhgb crashkernel=256M SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 KEYTABLE=us
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
allocated 17038100 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
Initializing HighMem for node 0 (000373fe:000cffc2)
Memory: 3080568k/3407624k available (3605k kernel code, 326628k reserved, 2322k data, 548k init, 2502416k highmem)
virtual kernel memory layout:
    fixmap  : 0xffad5000 - 0xfffff000   (5288 kB)
    pkmap   : 0xff400000 - 0xff800000   (4096 kB)
    vmalloc : 0xf7bfe000 - 0xff3fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf73fe000   ( 883 MB)
      .init : 0xc09ca000 - 0xc0a53000   ( 548 kB)
      .data : 0xc0785442 - 0xc09c9d78   (2322 kB)
      .text : 0xc0400000 - 0xc0785442   (3605 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Hierarchical RCU implementation.
NR_IRQS:1280
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 3166.958 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 6333.91 BogoMIPS (lpj=3166958)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Mount-cache hash table entries: 512
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
Performance Events: Core2 events, Intel PMU driver.
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
Checking 'hlt' instruction... OK.
ACPI: Core revision 20100121
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 20224 entries in 40 pages
Enabling APIC mode:  Flat.  Using 3 I/O APICs
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(R) CPU           X5460  @ 3.16GHz stepping 0a
Booting Node   0, Processors  #1
Initializing CPU#1
 #2
Initializing CPU#2
 #3
Initializing CPU#3
Brought up 4 CPUs
Total of 4 processors activated (25333.84 BogoMIPS).
devtmpfs: initialized
regulator: core version 0.5
Time:  9:59:08  Date: 03/24/10
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: SSDT cffd0d0a 008C4 (v01 HPQOEM  CPU_TM2 00000001 MSFT 0100000E)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI Error (dsfield-0143): [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f6c53db0), AE_ALREADY_EXISTS
ACPI: Marking method _OSC as Serialized because of AE_ALREADY_EXISTS error
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0xd0000000-0xdfffffff]
pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfebfffff]
pci_root PNP0A08:00: host bridge window [mem 0xfed00000-0xfed003ff]
pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff]
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:00.0: PME# disabled
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
pci 0000:00:05.0: PME# disabled
pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
pci 0000:00:09.0: PME# disabled
pci 0000:00:1b.0: reg 10: [mem 0xf3600000-0xf3603fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1d.0: reg 20: [io  0x3000-0x301f]
pci 0000:00:1d.1: reg 20: [io  0x3020-0x303f]
pci 0000:00:1d.2: reg 20: [io  0x3040-0x305f]
pci 0000:00:1d.3: reg 20: [io  0x3060-0x307f]
pci 0000:00:1d.7: reg 10: [mem 0xf3604000-0xf36043ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.1: reg 10: [io  0x30d0-0x30d7]
pci 0000:00:1f.1: reg 14: [io  0x30f0-0x30f3]
pci 0000:00:1f.1: reg 18: [io  0x30d8-0x30df]
pci 0000:00:1f.1: reg 1c: [io  0x30f4-0x30f7]
pci 0000:00:1f.1: reg 20: [io  0x30c0-0x30cf]
pci 0000:00:1f.2: reg 10: [io  0x30e0-0x30e7]
pci 0000:00:1f.2: reg 14: [io  0x30f8-0x30fb]
pci 0000:00:1f.2: reg 18: [io  0x30e8-0x30ef]
pci 0000:00:1f.2: reg 1c: [io  0x30fc-0x30ff]
pci 0000:00:1f.2: reg 20: [io  0x3080-0x309f]
pci 0000:00:1f.2: reg 24: [mem 0xf3604400-0xf36047ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:01.0: PCI bridge to [bus 80-80]
pci 0000:00:01.0:   bridge window [io  f000 - 0000] reg reading
pci 0000:00:01.0:   bridge window [mem 0xfff00000 - 0x000fffff] reg reading
pci 0000:00:01.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
pci 0000:a0:00.0: reg 10: [mem 0xf3700000-0xf3701fff 64bit]
pci 0000:a0:00.0: PME# supported from D0 D3hot D3cold
pci 0000:a0:00.0: PME# disabled
pci 0000:00:03.0: PCI bridge to [bus a0-a0]
pci 0000:00:03.0:   bridge window [io  f000 - 0000] reg reading
pci 0000:00:03.0:   bridge window [mem 0xf3700000-0xf37fffff]
pci 0000:00:03.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
pci 0000:60:00.0: reg 10: [mem 0xf2000000-0xf2ffffff]
pci 0000:60:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:60:00.0: reg 1c: [mem 0xf0000000-0xf1ffffff 64bit]
pci 0000:60:00.0: reg 24: [io  0x1000-0x107f]
pci 0000:60:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:00:05.0: PCI bridge to [bus 60-60]
pci 0000:00:05.0:   bridge window [io  0x1000-0x1fff]
pci 0000:00:05.0:   bridge window [mem 0xf0000000-0xf2ffffff]
pci 0000:00:05.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:10:00.0: PME# supported from D0 D3hot D3cold
pci 0000:10:00.0: PME# disabled
pci 0000:10:00.3: PME# supported from D0 D3hot D3cold
pci 0000:10:00.3: PME# disabled
pci 0000:10:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:09.0: PCI bridge to [bus 10-40]
pci 0000:00:09.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:09.0:   bridge window [mem 0xf3000000-0xf32fffff]
pci 0000:00:09.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
pci 0000:1e:00.0: PME# supported from D0 D3hot D3cold
pci 0000:1e:00.0: PME# disabled
pci 0000:1e:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:1e:01.0: PME# supported from D0 D3hot D3cold
pci 0000:1e:01.0: PME# disabled
pci 0000:1e:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:10:00.0: PCI bridge to [bus 1e-40]
pci 0000:10:00.0:   bridge window [io  f000 - 0000] reg reading
pci 0000:10:00.0:   bridge window [mem 0xf3000000-0xf30fffff]
pci 0000:10:00.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
pci 0000:20:00.0: reg 10: [mem 0xf3000000-0xf300ffff 64bit]
pci 0000:20:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
pci 0000:20:00.0: PME# supported from D3hot D3cold
pci 0000:20:00.0: PME# disabled
pci 0000:20:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:1e:00.0: PCI bridge to [bus 20-20]
pci 0000:1e:00.0:   bridge window [io  f000 - 0000] reg reading
pci 0000:1e:00.0:   bridge window [mem 0xf3000000-0xf30fffff]
pci 0000:1e:00.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
pci 0000:1e:01.0: PCI bridge to [bus 40-40]
pci 0000:1e:01.0:   bridge window [io  f000 - 0000] reg reading
pci 0000:1e:01.0:   bridge window [mem 0xfff00000 - 0x000fffff] reg reading
pci 0000:1e:01.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
pci 0000:11:06.0: reg 10: [io  0x2000-0x20ff]
pci 0000:11:06.0: reg 14: [mem 0xf3110000-0xf3113fff 64bit]
pci 0000:11:06.0: reg 1c: [mem 0xf3100000-0xf310ffff 64bit]
pci 0000:11:06.0: reg 30: [mem 0x00000000-0x001fffff pref]
pci 0000:11:06.0: supports D1 D2
pci 0000:10:00.3: PCI bridge to [bus 11-11]
pci 0000:10:00.3:   bridge window [io  0x2000-0x2fff]
pci 0000:10:00.3:   bridge window [mem 0xf3100000-0xf31fffff]
pci 0000:10:00.3:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
pci 0000:0e:00.0: reg 10: [mem 0xf3400000-0xf340ffff 64bit]
pci 0000:0e:00.0: PME# supported from D3hot D3cold
pci 0000:0e:00.0: PME# disabled
pci 0000:00:1c.0: PCI bridge to [bus 0e-0e]
pci 0000:00:1c.0:   bridge window [io  f000 - 0000] reg reading
pci 0000:00:1c.0:   bridge window [mem 0xf3400000-0xf34fffff]
pci 0000:00:1c.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
pci 0000:0f:00.0: reg 10: [mem 0xf3300000-0xf330ffff 64bit]
pci 0000:0f:00.0: PME# supported from D3hot D3cold
pci 0000:0f:00.0: PME# disabled
pci 0000:00:1c.1: PCI bridge to [bus 0f-0f]
pci 0000:00:1c.1:   bridge window [io  f000 - 0000] reg reading
pci 0000:00:1c.1:   bridge window [mem 0xf3300000-0xf33fffff]
pci 0000:00:1c.1:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
pci 0000:01:05.0: reg 10: [mem 0xf3504000-0xf35047ff]
pci 0000:01:05.0: reg 14: [mem 0xf3500000-0xf3503fff]
pci 0000:01:05.0: supports D1 D2
pci 0000:01:05.0: PME# supported from D0 D1 D2 D3hot
pci 0000:01:05.0: PME# disabled
pci 0000:00:1e.0: PCI bridge to [bus 01-01] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  f000 - 0000] reg reading
pci 0000:00:1e.0:   bridge window [mem 0xf3500000-0xf35fffff]
pci 0000:00:1e.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xdfffffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xfed00000-0xfed003ff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MCH1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MCH3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MCH5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MCH9.MUPP._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MCH9.MUPP.PTE1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MCH9.MUPP.PTE2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MCH9.PCIX._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCX1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCX2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB_._PRT]
ACPI Error (dsfield-0143): [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f6c53db0), AE_ALREADY_EXISTS
ACPI: PCI Interrupt Link [LNKA] (IRQs *3 4 5 6 7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
vgaarb: device added: PCI:0000:60:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 0000000000096400 - 000000000009ffff 
reserve RAM buffer: 00000000cffc2840 - 00000000cfffffff 
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:10: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:11:06.0 BAR 6 [mem 0x00000000-0x001fffff pref]
pnp 00:10: disabling [mem 0x000c0000-0x000e7fff] because it overlaps 0000:11:06.0 BAR 6 [mem 0x00000000-0x001fffff pref]
pnp 00:10: disabling [mem 0x000e8000-0x000effff] because it overlaps 0000:11:06.0 BAR 6 [mem 0x00000000-0x001fffff pref]
pnp 00:10: disabling [mem 0x000f0000-0x000fffff] because it overlaps 0000:11:06.0 BAR 6 [mem 0x00000000-0x001fffff pref]
pnp 00:10: disabling [mem 0x00100000-0xcfffffff] because it overlaps 0000:11:06.0 BAR 6 [mem 0x00000000-0x001fffff pref]
pnp: PnP ACPI: found 18 devices
ACPI: ACPI bus type pnp unregistered
system 00:0d: [io  0x04d0-0x04d1] has been reserved
system 00:0e: [io  0x0400-0x041f] has been reserved
system 00:0e: [io  0x0420-0x043f] has been reserved
system 00:0e: [io  0x0440-0x045f] has been reserved
system 00:0e: [io  0x0460-0x047f] has been reserved
system 00:0e: [io  0x0480-0x048f] has been reserved
system 00:0e: [io  0x0490-0x049f] has been reserved
system 00:0e: [io  0xf800-0xf81f] has been reserved
system 00:0e: [io  0xf820-0xf83f] has been reserved
system 00:0e: [io  0xf840-0xf85f] has been reserved
system 00:0e: [io  0xf860-0xf87f] has been reserved
system 00:0e: [io  0xfa00-0xfa3f] has been reserved
system 00:0e: [io  0xfc00-0xfc7f] has been reserved
system 00:0e: [io  0xfc80-0xfcff] has been reserved
system 00:0e: [io  0xfe00-0xfe7f] has been reserved
system 00:0e: [io  0xfe80-0xfeff] has been reserved
system 00:0f: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:0f: [mem 0xffe00000-0xffffffff] has been reserved
system 00:0f: [mem 0xfee00000-0xfeefffff] has been reserved
system 00:0f: [mem 0xfe700000-0xfe7003ff] has been reserved
system 00:0f: [mem 0xfe600000-0xfe6fffff] has been reserved
system 00:0f: [mem 0xfe000000-0xfe01ffff] has been reserved
system 00:10: [mem 0xfeda0000-0xfedbffff] has been reserved
system 00:11: [mem 0xe0000000-0xefffffff] has been reserved
PCI: max bus depth: 3 pci_try_num: 4
pci 0000:00:09.0: BAR 15: assigned [mem 0xf3800000-0xf3afffff pref]
pci 0000:00:01.0: PCI bridge to [bus 80-80]
pci 0000:00:01.0:   bridge window [io  disabled]
pci 0000:00:01.0:   bridge window [mem disabled]
pci 0000:00:01.0:   bridge window [mem pref disabled]
pci 0000:00:03.0: PCI bridge to [bus a0-a0]
pci 0000:00:03.0:   bridge window [io  disabled]
pci 0000:00:03.0:   bridge window [mem 0xf3700000-0xf37fffff]
pci 0000:00:03.0:   bridge window [mem pref disabled]
pci 0000:60:00.0: BAR 6: can't assign mem pref (size 0x20000)
pci 0000:00:05.0: PCI bridge to [bus 60-60]
pci 0000:00:05.0:   bridge window [io  0x1000-0x1fff]
pci 0000:00:05.0:   bridge window [mem 0xf0000000-0xf2ffffff]
pci 0000:00:05.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:10:00.3: BAR 15: assigned [mem 0xf3800000-0xf39fffff pref]
pci 0000:10:00.0: BAR 15: assigned [mem 0xf3a00000-0xf3afffff pref]
pci 0000:1e:00.0: BAR 15: assigned [mem 0xf3a00000-0xf3afffff pref]
pci 0000:20:00.0: BAR 6: assigned [mem 0xf3a00000-0xf3a0ffff pref]
pci 0000:1e:00.0: PCI bridge to [bus 20-20]
pci 0000:1e:00.0:   bridge window [io  disabled]
pci 0000:1e:00.0:   bridge window [mem 0xf3000000-0xf30fffff]
pci 0000:1e:00.0:   bridge window [mem 0xf3a00000-0xf3afffff pref]
pci 0000:1e:01.0: PCI bridge to [bus 40-40]
pci 0000:1e:01.0:   bridge window [io  disabled]
pci 0000:1e:01.0:   bridge window [mem disabled]
pci 0000:1e:01.0:   bridge window [mem pref disabled]
pci 0000:10:00.0: PCI bridge to [bus 1e-40]
pci 0000:10:00.0:   bridge window [io  disabled]
pci 0000:10:00.0:   bridge window [mem 0xf3000000-0xf30fffff]
pci 0000:10:00.0:   bridge window [mem 0xf3a00000-0xf3afffff pref]
pci 0000:11:06.0: BAR 6: assigned [mem 0xf3800000-0xf39fffff pref]
pci 0000:10:00.3: PCI bridge to [bus 11-11]
pci 0000:10:00.3:   bridge window [io  0x2000-0x2fff]
pci 0000:10:00.3:   bridge window [mem 0xf3100000-0xf31fffff]
pci 0000:10:00.3:   bridge window [mem 0xf3800000-0xf39fffff pref]
pci 0000:00:09.0: PCI bridge to [bus 10-40]
pci 0000:00:09.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:09.0:   bridge window [mem 0xf3000000-0xf32fffff]
pci 0000:00:09.0:   bridge window [mem 0xf3800000-0xf3afffff pref]
pci 0000:00:1c.0: PCI bridge to [bus 0e-0e]
pci 0000:00:1c.0:   bridge window [io  disabled]
pci 0000:00:1c.0:   bridge window [mem 0xf3400000-0xf34fffff]
pci 0000:00:1c.0:   bridge window [mem pref disabled]
pci 0000:00:1c.1: PCI bridge to [bus 0f-0f]
pci 0000:00:1c.1:   bridge window [io  disabled]
pci 0000:00:1c.1:   bridge window [mem 0xf3300000-0xf33fffff]
pci 0000:00:1c.1:   bridge window [mem pref disabled]
pci 0000:00:1e.0: PCI bridge to [bus 01-01]
pci 0000:00:1e.0:   bridge window [io  disabled]
pci 0000:00:1e.0:   bridge window [mem 0xf3500000-0xf35fffff]
pci 0000:00:1e.0:   bridge window [mem pref disabled]
pci 0000:00:01.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:03.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
pci 0000:00:03.0: setting latency timer to 64
pci 0000:00:05.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
pci 0000:00:05.0: setting latency timer to 64
pci 0000:00:09.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
pci 0000:00:09.0: setting latency timer to 64
pci 0000:10:00.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
pci 0000:10:00.0: setting latency timer to 64
pci 0000:1e:00.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
pci 0000:1e:00.0: setting latency timer to 64
pci 0000:1e:01.0: PCI INT A -> GSI 46 (level, low) -> IRQ 46
pci 0000:1e:01.0: setting latency timer to 64
pci 0000:10:00.3: setting latency timer to 64
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 5 [mem 0xd0000000-0xdfffffff]
pci_bus 0000:00: resource 6 [mem 0xf0000000-0xfebfffff]
pci_bus 0000:00: resource 7 [mem 0xfed00000-0xfed003ff]
pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
pci_bus 0000:00: resource 9 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 10 [io  0x0d00-0xffff]
pci_bus 0000:a0: resource 1 [mem 0xf3700000-0xf37fffff]
pci_bus 0000:60: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:60: resource 1 [mem 0xf0000000-0xf2ffffff]
pci_bus 0000:60: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
pci_bus 0000:10: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:10: resource 1 [mem 0xf3000000-0xf32fffff]
pci_bus 0000:10: resource 2 [mem 0xf3800000-0xf3afffff pref]
pci_bus 0000:1e: resource 1 [mem 0xf3000000-0xf30fffff]
pci_bus 0000:1e: resource 2 [mem 0xf3a00000-0xf3afffff pref]
pci_bus 0000:20: resource 1 [mem 0xf3000000-0xf30fffff]
pci_bus 0000:20: resource 2 [mem 0xf3a00000-0xf3afffff pref]
pci_bus 0000:11: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:11: resource 1 [mem 0xf3100000-0xf31fffff]
pci_bus 0000:11: resource 2 [mem 0xf3800000-0xf39fffff pref]
pci_bus 0000:0e: resource 1 [mem 0xf3400000-0xf34fffff]
pci_bus 0000:0f: resource 1 [mem 0xf3300000-0xf33fffff]
pci_bus 0000:01: resource 1 [mem 0xf3500000-0xf35fffff]
pci_bus 0000:01: resource 4 [mem 0x000a0000-0x000bffff]
pci_bus 0000:01: resource 5 [mem 0xd0000000-0xdfffffff]
pci_bus 0000:01: resource 6 [mem 0xf0000000-0xfebfffff]
pci_bus 0000:01: resource 7 [mem 0xfed00000-0xfed003ff]
pci_bus 0000:01: resource 8 [mem 0xfed40000-0xfed44fff]
pci_bus 0000:01: resource 9 [io  0x0000-0x0cf7]
pci_bus 0000:01: resource 10 [io  0x0d00-0xffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
UDP hash table entries: 512 (order: 2, 16384 bytes)
UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
NET: Registered protocol family 1
pci 0000:00:1f.0: rerouting interrupts for [8086:2670]
pci 0000:60:00.0: Boot video device
PCI: CLS 64 bytes, default 64
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 12508k freed
apm: BIOS not found.
audit: initializing netlink socket (disabled)
type=2000 audit(1269424748.839:1): initialized
highmem bounce pool size: 64 pages
HugeTLB registered 4 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 1153
SELinux:  Registering netfilter hooks
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:01.0: setting latency timer to 64
pcieport 0000:00:01.0: irq 72 for MSI/MSI-X
pcieport 0000:00:03.0: setting latency timer to 64
pcieport 0000:00:03.0: irq 73 for MSI/MSI-X
pcieport 0000:00:05.0: setting latency timer to 64
pcieport 0000:00:05.0: irq 74 for MSI/MSI-X
pcieport 0000:00:09.0: setting latency timer to 64
pcieport 0000:00:09.0: irq 75 for MSI/MSI-X
pcieport 0000:00:1c.0: setting latency timer to 64
pcieport 0000:00:1c.0: irq 76 for MSI/MSI-X
pcieport 0000:00:1c.1: setting latency timer to 64
pcieport 0000:00:1c.1: irq 77 for MSI/MSI-X
pcieport 0000:10:00.0: setting latency timer to 64
pcieport 0000:1e:00.0: setting latency timer to 64
pcieport 0000:1e:00.0: irq 78 for MSI/MSI-X
pcieport 0000:1e:01.0: setting latency timer to 64
pcieport 0000:1e:01.0: irq 79 for MSI/MSI-X
ACPI Error (dsfield-0143): [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f6c53db0), AE_ALREADY_EXISTS
aer 0000:00:01.0:pcie02: AER service couldn't init device: _OSC failed
ACPI Error (dsfield-0143): [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f6c53db0), AE_ALREADY_EXISTS
aer 0000:00:03.0:pcie02: AER service couldn't init device: _OSC failed
ACPI Error (dsfield-0143): [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f6c53db0), AE_ALREADY_EXISTS
aer 0000:00:05.0:pcie02: AER service couldn't init device: _OSC failed
ACPI Error (dsfield-0143): [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f6c53db0), AE_ALREADY_EXISTS
aer 0000:00:09.0:pcie02: AER service couldn't init device: _OSC failed
pcieport 0000:00:01.0: Requesting control of PCIe PME from ACPI BIOS
ACPI Error (dsfield-0143): [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f6c53db0), AE_ALREADY_EXISTS
pcieport 0000:00:01.0: Failed to receive control of PCIe PME service: ACPI _OSC failed
pcie_pme: probe of 0000:00:01.0:pcie01 failed with error -13
pcieport 0000:00:03.0: Requesting control of PCIe PME from ACPI BIOS
ACPI Error (dsfield-0143): [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f6c53db0), AE_ALREADY_EXISTS
pcieport 0000:00:03.0: Failed to receive control of PCIe PME service: ACPI _OSC failed
pcie_pme: probe of 0000:00:03.0:pcie01 failed with error -13
pcieport 0000:00:05.0: Requesting control of PCIe PME from ACPI BIOS
ACPI Error (dsfield-0143): [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f6c53db0), AE_ALREADY_EXISTS
pcieport 0000:00:05.0: Failed to receive control of PCIe PME service: ACPI _OSC failed
pcie_pme: probe of 0000:00:05.0:pcie01 failed with error -13
pcieport 0000:00:09.0: Requesting control of PCIe PME from ACPI BIOS
ACPI Error (dsfield-0143): [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f6c53db0), AE_ALREADY_EXISTS
pcieport 0000:00:09.0: Failed to receive control of PCIe PME service: ACPI _OSC failed
pcie_pme: probe of 0000:00:09.0:pcie01 failed with error -13
pcieport 0000:00:1c.0: Requesting control of PCIe PME from ACPI BIOS
ACPI Error (dsfield-0143): [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f6c53db0), AE_ALREADY_EXISTS
pcieport 0000:00:1c.0: Failed to receive control of PCIe PME service: ACPI _OSC failed
pcie_pme: probe of 0000:00:1c.0:pcie01 failed with error -13
pcieport 0000:00:1c.1: Requesting control of PCIe PME from ACPI BIOS
ACPI Error (dsfield-0143): [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f6c53db0), AE_ALREADY_EXISTS
pcieport 0000:00:1c.1: Failed to receive control of PCIe PME service: ACPI _OSC failed
pcie_pme: probe of 0000:00:1c.1:pcie01 failed with error -13
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
pci-stub: invalid id string ""
input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
ACPI: Power Button [PBTN]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
brd: module loaded
loop: module loaded
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl RAID mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led slum part 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 19
ata2: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 19
ata3: SATA max UDMA/133 irq_stat 0x00000040, connection status changed irq 19
ata4: SATA max UDMA/133 abar m1024@0xf3604400 port 0xf3604680 irq 19
ata5: SATA max UDMA/133 abar m1024@0xf3604400 port 0xf3604700 irq 19
ata6: SATA max UDMA/133 abar m1024@0xf3604400 port 0xf3604780 irq 19
ata_piix 0000:00:1f.1: version 2.13
ata_piix 0000:00:1f.1: PCI INT A -> GSI 17 (level, low) -> IRQ 17
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi6 : ata_piix
scsi7 : ata_piix
ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x30c0 irq 14
ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x30c8 irq 15
Fixed MDIO Bus: probed
ata8: port disabled. ignoring.
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.7: irq 16, io mem 0xf3604000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.34-rc1 ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 16, io base 0x00003000
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.34-rc1 uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00003020
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.34-rc1 uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00003040
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.34-rc1 uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 22, io base 0x00003060
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.34-rc1 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
rtc_cmos 00:05: RTC can wake from S4
rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
Using IPI No-Shortcut mode
PM: Resume from disk failed.
registered taskstats version 1
No TPM chip found, activating TPM-bypass!
  Magic number: 2:181:981
rtc_cmos 00:05: setting system clock to 2010-03-24 09:59:09 UTC (1269424749)
Initalizing network drop monitor service
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
ata4: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
usb 4-1: new low speed USB device using uhci_hcd and address 2
usb 4-1: New USB device found, idVendor=03f0, idProduct=2c24
usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 4-1: Product: HP USB Laser Mouse
usb 4-1: Manufacturer: HP
input: HP HP USB Laser Mouse as /devices/pci0000:00/0000:00:1d.2/usb4/4-1/4-1:1.0/input/input3
generic-usb 0003:03F0:2C24.0001: input,hidraw0: USB HID v1.10 Mouse [HP HP USB Laser Mouse] on usb-0000:00:1d.2-1/input0
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: ST3250410AS, 3.AHC, max UDMA/100
ata3.00: ATAPI: ATAPI   DVD A  DH16A6L, ZH37, max UDMA/100
ata1.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata2.00: ATA-7: ST3250410AS, 3.AHC, max UDMA/100
ata3.00: configured for UDMA/100
ata2.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/100
ata2.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      ST3250410AS      3.AH PQ: 0 ANSI: 5
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda:
scsi 1:0:0:0: Direct-Access     ATA      ST3250410AS      3.AH PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 488397168 512-byte logical blocks: (250 GB/232 GiB)
sd 1:0:0:0: Attached scsi generic sg1 type 0
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb:
scsi 2:0:0:0: CD-ROM            ATAPI    DVD A  DH16A6L   ZH37 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 48x/12x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 2:0:0:0: Attached scsi CD-ROM sr0
sr 2:0:0:0: Attached scsi generic sg2 type 5
 sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
 sdb1 sdb2 sdb3 sdb4
sd 1:0:0:0: [sdb] Attached SCSI disk
Freeing unused kernel memory: 548k freed
Write protecting the kernel text: 3608k
Write protecting the kernel read-only data: 1780k
dracut: dracut-003-1.fc12
udev: starting version 145
[drm] Initialized drm 1.1.0 20060810
nouveau 0000:60:00.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
nouveau 0000:60:00.0: setting latency timer to 64
[drm] nouveau 0000:60:00.0: Detected an NV50 generation card (0x086f00a2)
[drm] nouveau 0000:60:00.0: Attempting to load BIOS image from PRAMIN
[drm] nouveau 0000:60:00.0: ... appears to be valid
[drm] nouveau 0000:60:00.0: BIT BIOS found
[drm] nouveau 0000:60:00.0: Bios version 60.86.63.00
[drm] nouveau 0000:60:00.0: TMDS table revision 2.0 not currently supported
[drm] nouveau 0000:60:00.0: Found Display Configuration Block version 4.0
[drm] nouveau 0000:60:00.0: Raw DCB entry 0: 02011300 00000028
[drm] nouveau 0000:60:00.0: Raw DCB entry 1: 01011302 00000010
[drm] nouveau 0000:60:00.0: Raw DCB entry 2: 01000310 00000028
[drm] nouveau 0000:60:00.0: Raw DCB entry 3: 02000312 00000010
[drm] nouveau 0000:60:00.0: Raw DCB entry 4: 0000000e 00000000
[drm] nouveau 0000:60:00.0: DCB connector table: VHER 0x40 5 14 2
[drm] nouveau 0000:60:00.0:   0: 0x00002030: type 0x30 idx 0 tag 0x08
[drm] nouveau 0000:60:00.0:   1: 0x00001130: type 0x30 idx 1 tag 0x07
[drm] nouveau 0000:60:00.0: Parsing VBIOS init table 0 at offset 0xBD9C
[drm] nouveau 0000:60:00.0: Parsing VBIOS init table 1 at offset 0xC106
[drm] nouveau 0000:60:00.0: Parsing VBIOS init table 2 at offset 0xCD47
[drm] nouveau 0000:60:00.0: Parsing VBIOS init table 3 at offset 0xCE39
[drm] nouveau 0000:60:00.0: Parsing VBIOS init table 4 at offset 0xD033
[drm] nouveau 0000:60:00.0: Parsing VBIOS init table at offset 0xD098
[drm] nouveau 0000:60:00.0: 0xD098: Condition still not met after 20ms, skipping following opcodes
[drm] nouveau 0000:60:00.0: 0xAFEE: parsing output script 0
[drm] nouveau 0000:60:00.0: 0xAFEE: parsing output script 0
[TTM] Zone  kernel: Available graphics memory: 295606 kiB.
[TTM] Zone highmem: Available graphics memory: 1546814 kiB.
[drm] nouveau 0000:60:00.0: 256 MiB VRAM
[drm] nouveau 0000:60:00.0: 512 MiB GART (aperture)
[drm] nouveau 0000:60:00.0: Allocating FIFO number 1
[drm] nouveau 0000:60:00.0: nouveau_channel_alloc: initialised FIFO 1
[drm] nouveau 0000:60:00.0: Detected a DAC output
[drm] nouveau 0000:60:00.0: Detected a TMDS output
[drm] nouveau 0000:60:00.0: Detected a DAC output
[drm] nouveau 0000:60:00.0: Detected a TMDS output
[drm] nouveau 0000:60:00.0: Detected a DVI-I connector
[drm] nouveau 0000:60:00.0: Detected a DVI-I connector
[drm] nouveau 0000:60:00.0: allocated 1680x1050 fb: 0x40250000, bo f5cc2800
fbcon: nouveaufb (fb0) is primary device
[drm] nouveau 0000:60:00.0: 0xAFF2: parsing output script 1
[drm] nouveau 0000:60:00.0: 0xA8C7: parsing clock script 0
Console: switching to colour frame buffer device 210x65
fb0: nouveaufb frame buffer device
registered panic notifier
[drm] Initialized nouveau 0.0.16 20090420 for 0000:60:00.0 on minor 0
dracut: Starting plymouth daemon
Fusion MPT base driver 3.04.14
Copyright (c) 1999-2008 LSI Corporation
firewire_ohci 0000:01:05.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Fusion MPT SAS Host driver 3.04.14
mptsas 0000:11:06.0: PCI INT A -> GSI 62 (level, low) -> IRQ 62
mptbase: ioc0: Initiating bringup
FDC 0 is a post-1991 82077
device-mapper: multipath: version 1.1.1 loaded
firewire_ohci: Added fw-ohci device 0000:01:05.0, OHCI v1.10, 4 IR + 8 IT contexts, quirks 0x2
ioc0: LSISAS1068 B1: Capabilities={Initiator}
firewire_core: created device fw0: GUID 0060b000002a1d25, S400
scsi8 : ioc0: LSISAS1068 B1, FwRev=01160100h, Ports=1, MaxQ=286, IRQ=62
EXT4-fs (sdb4): mounted filesystem with ordered data mode
dracut: Mounted root filesystem /dev/sdb4
dracut: Switching root
udev: starting version 145
input: PC Speaker as /devices/platform/pcspkr/input/input4
ACPI: WMI: Mapper loaded
intel_rng: Firmware space is locked read-only. If you can't or
intel_rng: don't want to disable this in firmware setup, and if
intel_rng: you are certain that your system has a functional
intel_rng: RNG, try using the 'no_fwh_detect' option.
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
iTCO_wdt: Found a 631xESB/632xESB TCO device (Version=2, TCOBASE=0xf860)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
input: HP WMI hotkeys as /devices/virtual/input/input5
cfg80211: Calling CRDA to update world regulatory domain
EDAC MC: Ver: 2.1.0 Mar 22 2010
cfg80211: World regulatory domain updated:
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
    (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
    (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
tg3.c:v3.108 (February 17, 2010)
tg3 0000:20:00.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
tg3 0000:20:00.0: setting latency timer to 64
tg3 0000:20:00.0: eth0: Tigon3 [partno(BCM95751A519FLP) rev 4201] (PCI Express) MAC address 00:10:18:48:20:43
tg3 0000:20:00.0: eth0: attached PHY is 5750 (10/100/1000Base-T Ethernet) (WireSpeed[1])
tg3 0000:20:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
tg3 0000:20:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
tg3 0000:0e:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
tg3 0000:0e:00.0: setting latency timer to 64
EDAC MC0: Giving out device to 'i5400_edac.c' 'I5400': DEV 0000:00:10.0
EDAC PCI0: Giving out device to module 'i5400_edac' controller 'EDAC PCI controller': DEV '0000:00:10.0' (POLLED)
tg3 0000:0e:00.0: eth1: Tigon3 [partno(BCM95755) rev a002] (PCI Express) MAC address 00:23:7d:53:64:71
tg3 0000:0e:00.0: eth1: attached PHY is 5755 (10/100/1000Base-T Ethernet) (WireSpeed[1])
tg3 0000:0e:00.0: eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
tg3 0000:0e:00.0: eth1: dma_rwctrl[76180000] dma_mask[64-bit]
tg3 0000:0f:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
tg3 0000:0f:00.0: setting latency timer to 64
tg3 0000:0f:00.0: eth2: Tigon3 [partno(BCM95755) rev a002] (PCI Express) MAC address 00:23:7d:53:64:70
tg3 0000:0f:00.0: eth2: attached PHY is 5755 (10/100/1000Base-T Ethernet) (WireSpeed[1])
tg3 0000:0f:00.0: eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
tg3 0000:0f:00.0: eth2: dma_rwctrl[76180000] dma_mask[64-bit]
iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
iwlagn: Copyright(c) 2003-2010 Intel Corporation
iwlagn 0000:a0:00.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
iwlagn 0000:a0:00.0: setting latency timer to 64
iwlagn 0000:a0:00.0: Detected Intel Wireless WiFi Link 4965AGN REV=0x4
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
HDA Intel 0000:00:1b.0: irq 80 for MSI/MSI-X
HDA Intel 0000:00:1b.0: setting latency timer to 64
iwlagn 0000:a0:00.0: Tunable channels: 13 802.11bg, 19 802.11a channels
iwlagn 0000:a0:00.0: irq 81 for MSI/MSI-X
iwlagn 0000:a0:00.0: firmware: requesting iwlwifi-4965-2.ucode
input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input6
iwlagn 0000:a0:00.0: loaded firmware version 228.61.2.24
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
    (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
    (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2301 mBm)
    (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 3000 mBm)
phy0: Selected rate control algorithm 'iwl-agn-rs'
udev: renamed network interface wlan0 to wlan2
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda1): using internal journal
EXT3-fs (sda1): mounted filesystem with ordered data mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs (dm-0): using internal journal
EXT3-fs (dm-0): mounted filesystem with ordered data mode
Adding 6094844k swap on /dev/mapper/VolGroup00-LogVol01.  Priority:-1 extents:1 across:6094844k 
Adding 16008768k swap on /dev/sdb3.  Priority:-2 extents:1 across:16008768k 
microcode: CPU0 sig=0x1067a, pf=0x40, revision=0xa07
platform microcode: firmware: requesting intel-ucode/06-17-0a
microcode: CPU1 sig=0x1067a, pf=0x40, revision=0xa07
platform microcode: firmware: requesting intel-ucode/06-17-0a
microcode: CPU2 sig=0x1067a, pf=0x40, revision=0xa07
platform microcode: firmware: requesting intel-ucode/06-17-0a
microcode: CPU3 sig=0x1067a, pf=0x40, revision=0xa07
platform microcode: firmware: requesting intel-ucode/06-17-0a
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
microcode: Microcode Update Driver: v2.00 removed.
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
ADDRCONF(NETDEV_UP): wlan2: link is not ready
tg3 0000:20:00.0: irq 82 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
tg3 0000:0e:00.0: irq 83 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth1: link is not ready
tg3 0000:0f:00.0: irq 84 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth2: link is not ready
tg3 0000:20:00.0: eth0: Link is up at 1000 Mbps, full duplex
tg3 0000:20:00.0: eth0: Flow control is off for TX and off for RX
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
