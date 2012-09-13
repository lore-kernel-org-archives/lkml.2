Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680Ab2IMSWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 14:22:40 -0400
Received: from zuse.cryp.to ([217.19.183.102]:47157 "EHLO zuse.cryp.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab2IMSWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 14:22:16 -0400
X-Greylist: delayed 611 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Sep 2012 14:22:14 EDT
From: Peter Simons <simons@cryp.to>
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: ACPI 0x0000000000000b00-0x0000000000000b07 SystemIO conflicts with Region \_SB_.PCI0.SBRG.ASOC.SMRG 1 (20120320/utaddress-251)
Date: Thu, 13 Sep 2012 20:11:56 +0200
Message-ID: <87zk4t7pxv.fsf@write-only.cryp.to>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi guys,

I've recently updated my machine to Linux kernel 3.5. Ever since then, I
experience frequent kernel panics in the I/O system. The output from
dmesg shows the following warning, which earlier version of the kernel
did not show:

  ACPI 0x0000000000000b00-0x0000000000000b07 SystemIO conflicts with Region \_SB_.PCI0.SBRG.ASOC.SMRG 1 (20120320/utaddress-251)

I've asked Google for help how it might be possible to remedy that
issue, but I couldn't find anything, so I'm reporting this problem here,
hoping some guru can give me a hint.

Attached to this e-mail are:

 - the output from dmesg,
 - the output from acpidump,
 - the contents of my /proc/cpuinfo file, and
 - the output from lspci -vvv.

I'd very much appreciate any help! Please let me know if there is some
information missing.

Take care,
Peter



--=-=-=
Content-Type: text/plain
Content-Disposition: inline; filename=dmesg.txt
Content-Description: output from dmesg

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 3.5.3 (nixbld@) (gcc version 4.6.3 (GCC) ) #1 SMP Thu Aug 30 17:24:10 UTC 2012
Command line: BOOT_IMAGE=/kernels/6ckan8kpshzs2x1mpngnvxz6a5j0mr82-linux-3.5.3-bzImage systemConfig=/nix/store/kpp99j9dx1gbvpps9vp509qwrvvimq9k-nixos-0.1pre-git init=/nix/store/kpp99j9dx1gbvpps9vp509qwrvvimq9k-nixos-0.1pre-git/init printk.time=0 cgroup_disable=memory
e820: BIOS-provided physical RAM map:
BIOS-e820: [mem 0x0000000000000000-0x000000000009ebff] usable
BIOS-e820: [mem 0x000000000009ec00-0x000000000009ffff] reserved
BIOS-e820: [mem 0x00000000000e2000-0x00000000000fffff] reserved
BIOS-e820: [mem 0x0000000000100000-0x00000000cff6ffff] usable
BIOS-e820: [mem 0x00000000cff70000-0x00000000cff87fff] ACPI data
BIOS-e820: [mem 0x00000000cff88000-0x00000000cffcffff] ACPI NVS
BIOS-e820: [mem 0x00000000cffd0000-0x00000000cfffffff] reserved
BIOS-e820: [mem 0x00000000ffa00000-0x00000000ffffffff] reserved
BIOS-e820: [mem 0x0000000100000000-0x000000041fffffff] usable
NX (Execute Disable) protection: active
DMI present.
DMI: System manufacturer System Product Name/M4A88TD-M/USB3, BIOS 0902    12/10/2010
e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
e820: remove [mem 0x000a0000-0x000fffff] usable
No AGP bridge found
e820: last_pfn = 0x420000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-EFFFF uncachable
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000000 mask FFFF80000000 write-back
  1 base 000080000000 mask FFFFC0000000 write-back
  2 base 0000C0000000 mask FFFFF0000000 write-back
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
TOM2: 0000000430000000 aka 17152M
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820: update [mem 0xd0000000-0xffffffff] usable ==> reserved
e820: last_pfn = 0xcff70 max_arch_pfn = 0x400000000
found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at [ffff8800000ff780]
initial memory mapped: [mem 0x00000000-0x1fffffff]
Base memory trampoline at [ffff880000098000] 98000 size 24576
Using GB pages for direct mapping
init_memory_mapping: [mem 0x00000000-0xcff6ffff]
 [mem 0x00000000-0xbfffffff] page 1G
 [mem 0xc0000000-0xcfdfffff] page 2M
 [mem 0xcfe00000-0xcff6ffff] page 4k
kernel direct mapping tables up to 0xcff6ffff @ [mem 0x1f9fd000-0x1fffffff]
init_memory_mapping: [mem 0x100000000-0x41fffffff]
 [mem 0x100000000-0x3ffffffff] page 1G
 [mem 0x400000000-0x41fffffff] page 2M
kernel direct mapping tables up to 0x41fffffff @ [mem 0xcff6e000-0xcff6ffff]
RAMDISK: [mem 0x37506000-0x37a7afff]
ACPI: RSDP 00000000000fb570 00024 (v02 ACPIAM)
ACPI: XSDT 00000000cff70100 0005C (v01 121010 XSDT1437 20101210 MSFT 00000097)
ACPI: FACP 00000000cff70290 000F4 (v03 121010 FACP1437 20101210 MSFT 00000097)
ACPI: DSDT 00000000cff70450 0EE8F (v01  A1642 A1642001 00000001 INTL 20060113)
ACPI: FACS 00000000cff88000 00040
ACPI: APIC 00000000cff70390 0007C (v01 121010 APIC1437 20101210 MSFT 00000097)
ACPI: MCFG 00000000cff70410 0003C (v01 121010 OEMMCFG  20101210 MSFT 00000097)
ACPI: OEMB 00000000cff88040 00072 (v01 121010 OEMB1437 20101210 MSFT 00000097)
ACPI: SRAT 00000000cff7f8a0 000C8 (v01 AMD    FAM_F_10 00000002 AMD  00000001)
ACPI: HPET 00000000cff7f970 00038 (v01 121010 OEMHPET  20101210 MSFT 00000097)
ACPI: SSDT 00000000cff7f9b0 00458 (v01 A M I  POWERNOW 00000001 AMD  00000001)
ACPI: Local APIC address 0xfee00000
SRAT: PXM 0 -> APIC 0x00 -> Node 0
SRAT: PXM 0 -> APIC 0x01 -> Node 0
SRAT: Node 0 PXM 0 [mem 0x00000000-0x0009ffff]
SRAT: Node 0 PXM 0 [mem 0x00100000-0xcfffffff]
SRAT: Node 0 PXM 0 [mem 0x100000000-0x42fffffff]
NUMA: Node 0 [mem 0x00000000-0x0009ffff] + [mem 0x00100000-0xcfffffff] -> [mem 0x00000000-0xcfffffff]
NUMA: Node 0 [mem 0x00000000-0xcfffffff] + [mem 0x100000000-0x41fffffff] -> [mem 0x00000000-0x41fffffff]
Initmem setup node 0 [mem 0x00000000-0x41fffffff]
  NODE_DATA [mem 0x41fffc000-0x41fffffff]
 [ffffea0000000000-ffffea00107fffff] PMD -> [ffff88040fa00000-ffff88041f5fffff] on node 0
Zone ranges:
  DMA      [mem 0x00010000-0x00ffffff]
  DMA32    [mem 0x01000000-0xffffffff]
  Normal   [mem 0x100000000-0x41fffffff]
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x00010000-0x0009dfff]
  node   0: [mem 0x00100000-0xcff6ffff]
  node   0: [mem 0x100000000-0x41fffffff]
On node 0 totalpages: 4128510
  DMA zone: 64 pages used for memmap
  DMA zone: 6 pages reserved
  DMA zone: 3912 pages, LIFO batch:0
  DMA32 zone: 16320 pages used for memmap
  DMA32 zone: 831408 pages, LIFO batch:31
  Normal zone: 51200 pages used for memmap
  Normal zone: 3225600 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8300 base: 0xfed00000
SMP: Allowing 6 CPUs, 4 hotplug CPUs
nr_irqs_gsi: 40
PM: Registered nosave memory: 000000000009e000 - 000000000009f000
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e2000
PM: Registered nosave memory: 00000000000e2000 - 0000000000100000
PM: Registered nosave memory: 00000000cff70000 - 00000000cff88000
PM: Registered nosave memory: 00000000cff88000 - 00000000cffd0000
PM: Registered nosave memory: 00000000cffd0000 - 00000000d0000000
PM: Registered nosave memory: 00000000d0000000 - 00000000ffa00000
PM: Registered nosave memory: 00000000ffa00000 - 0000000100000000
e820: [mem 0xd0000000-0xff9fffff] available for PCI devices
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:6 nr_node_ids:1
PERCPU: Embedded 27 pages/cpu @ffff88041fc00000 s81152 r8192 d21248 u262144
pcpu-alloc: s81152 r8192 d21248 u262144 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3 4 5 - - 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4060920
Policy zone: Normal
Kernel command line: BOOT_IMAGE=/kernels/6ckan8kpshzs2x1mpngnvxz6a5j0mr82-linux-3.5.3-bzImage systemConfig=/nix/store/kpp99j9dx1gbvpps9vp509qwrvvimq9k-nixos-0.1pre-git init=/nix/store/kpp99j9dx1gbvpps9vp509qwrvvimq9k-nixos-0.1pre-git/init printk.time=0 cgroup_disable=memory
Disabling memory control group subsystem
PID hash table entries: 4096 (order: 3, 32768 bytes)
__ex_table already sorted, skipping sort
Checking aperture...
No AGP bridge found
Node 0: aperture @ fdb2000000 size 32 MB
Aperture beyond 4GB. Ignoring.
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ c4000000
PM: Registered nosave memory: 00000000c4000000 - 00000000c8000000
Memory: 16109492k/17301504k available (3965k kernel code, 787464k absent, 404548k reserved, 2778k data, 716k init)
SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=6, Nodes=1
Hierarchical RCU implementation.
NR_IRQS:4352 nr_irqs:728 16
Extended CMOS year: 2000
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [tty0] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 3013.448 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 6026.89 BogoMIPS (lpj=3013448)
pid_max: default: 32768 minimum: 301
Security Framework initialized
SELinux:  Disabled at boot.
Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys blkio
tseg: 0000000000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
LVT offset 0 assigned for vector 0xf9
using AMD E400 aware idle routine
ACPI: Core revision 20120320
ftrace: allocating 16003 entries in 63 pages
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: AMD Athlon(tm) II X2 250 Processor stepping 03
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
Booting Node   0, Processors  #1
Brought up 2 CPUs
System has AMD C1E enabled
Switch to broadcast mode on CPU1
Total of 2 processors activated (12053.79 BogoMIPS).
Switch to broadcast mode on CPU0
devtmpfs: initialized
PM: Registering ACPI NVS region [mem 0xcff88000-0xcffcffff] (294912 bytes)
dummy: 
NET: Registered protocol family 16
node 0 link 0: io port [1000, ffffff]
TOM: 00000000d0000000 aka 3328M
Fam 10h mmconf [mem 0xe0000000-0xefffffff]
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [d0000000, efffffff] ==> [d0000000, dfffffff]
node 0 link 0: mmio [f0000000, fe7fffff]
node 0 link 0: mmio [fe800000, fe9fffff]
node 0 link 0: mmio [fea00000, ffdfffff]
TOM2: 0000000430000000 aka 17152M
bus: [00, 07] on node 0 link 0
bus: 00 [io  0x0000-0xffff]
bus: 00 [mem 0x000a0000-0x000bffff]
bus: 00 [mem 0xd0000000-0xdfffffff]
bus: 00 [mem 0xf0000000-0xffffffff]
bus: 00 [mem 0x430000000-0xfcffffffff]
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: not using MMCONFIG
PCI: Using configuration type 1 for base access
PCI: Using configuration type 1 for extended access
mtrr: your CPUs had inconsistent variable MTRR settings
mtrr: probably your BIOS does not setup all CPUs.
mtrr: corrected configuration.
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: EC: Look up EC in DSDT
ACPI: Executed 3 blocks of module-level executable AML code
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
ACPI: EC: GPE = 0xa, I/O: command/status = 0x66, data = 0x62
ACPI: No dock devices found.
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff]
pci_root PNP0A03:00: host bridge window [mem 0xd0000000-0xdfffffff]
pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfebfffff]
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
pci_bus 0000:00: root bus resource [mem 0xd0000000-0xdfffffff]
pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfebfffff]
pci 0000:00:00.0: [1022:9601] type 00 class 0x060000
pci 0000:00:01.0: [1043:9602] type 01 class 0x060400
pci 0000:00:07.0: [1022:9607] type 01 class 0x060400
pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
pci 0000:00:09.0: [1022:9608] type 01 class 0x060400
pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
pci 0000:00:0a.0: [1022:9609] type 01 class 0x060400
pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
pci 0000:00:11.0: [1002:4390] type 00 class 0x01018f
pci 0000:00:11.0: reg 10: [io  0xb000-0xb007]
pci 0000:00:11.0: reg 14: [io  0xa000-0xa003]
pci 0000:00:11.0: reg 18: [io  0x9000-0x9007]
pci 0000:00:11.0: reg 1c: [io  0x8000-0x8003]
pci 0000:00:11.0: reg 20: [io  0x7000-0x700f]
pci 0000:00:11.0: reg 24: [mem 0xfe7ffc00-0xfe7fffff]
pci 0000:00:11.0: set SATA to AHCI mode
pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
pci 0000:00:12.0: reg 10: [mem 0xfe7fe000-0xfe7fefff]
pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
pci 0000:00:12.2: reg 10: [mem 0xfe7ff800-0xfe7ff8ff]
pci 0000:00:12.2: supports D1 D2
pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
pci 0000:00:13.0: reg 10: [mem 0xfe7fd000-0xfe7fdfff]
pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
pci 0000:00:13.2: reg 10: [mem 0xfe7ff400-0xfe7ff4ff]
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
pci 0000:00:14.2: reg 10: [mem 0xfe7f8000-0xfe7fbfff 64bit]
pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
pci 0000:00:14.5: [1002:4399] type 00 class 0x0c0310
pci 0000:00:14.5: reg 10: [mem 0xfe7fc000-0xfe7fcfff]
pci 0000:00:16.0: [1002:4397] type 00 class 0x0c0310
pci 0000:00:16.0: reg 10: [mem 0xfe7f7000-0xfe7f7fff]
pci 0000:00:16.2: [1002:4396] type 00 class 0x0c0320
pci 0000:00:16.2: reg 10: [mem 0xfe7ff000-0xfe7ff0ff]
pci 0000:00:16.2: supports D1 D2
pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
pci 0000:01:05.0: [1002:9715] type 00 class 0x030000
pci 0000:01:05.0: reg 10: [mem 0xd0000000-0xdfffffff pref]
pci 0000:01:05.0: reg 14: [io  0xc000-0xc0ff]
pci 0000:01:05.0: reg 18: [mem 0xfe9f0000-0xfe9fffff]
pci 0000:01:05.0: reg 24: [mem 0xfe800000-0xfe8fffff]
pci 0000:01:05.0: supports D1 D2
pci 0000:01:05.1: [1002:970f] type 00 class 0x040300
pci 0000:01:05.1: reg 10: [mem 0xfe9e8000-0xfe9ebfff]
pci 0000:01:05.1: supports D1 D2
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0xc000-0xcfff]
pci 0000:00:01.0:   bridge window [mem 0xfe800000-0xfe9fffff]
pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:02:00.0: [1033:0194] type 00 class 0x0c0330
pci 0000:02:00.0: reg 10: [mem 0xfeafe000-0xfeafffff 64bit]
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:07.0: PCI bridge to [bus 02-02]
pci 0000:00:07.0:   bridge window [mem 0xfea00000-0xfeafffff]
pci 0000:03:00.0: [1106:0415] type 00 class 0x010185
pci 0000:03:00.0: reg 10: [io  0xdc00-0xdc07]
pci 0000:03:00.0: reg 14: [io  0xd880-0xd883]
pci 0000:03:00.0: reg 18: [io  0xd800-0xd807]
pci 0000:03:00.0: reg 1c: [io  0xd480-0xd483]
pci 0000:03:00.0: reg 20: [io  0xd400-0xd40f]
pci 0000:03:00.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
pci 0000:03:00.0: supports D1 D2
pci 0000:03:00.0: PME# supported from D1 D2 D3hot
pci 0000:00:09.0: PCI bridge to [bus 03-03]
pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
pci 0000:00:09.0:   bridge window [mem 0xfeb00000-0xfebfffff]
pci 0000:04:00.0: [10ec:8168] type 00 class 0x020000
pci 0000:04:00.0: reg 10: [io  0xe800-0xe8ff]
pci 0000:04:00.0: reg 18: [mem 0xfdfff000-0xfdffffff 64bit pref]
pci 0000:04:00.0: reg 20: [mem 0xfdff8000-0xfdffbfff 64bit pref]
pci 0000:04:00.0: supports D1 D2
pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0a.0: PCI bridge to [bus 04-04]
pci 0000:00:0a.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:0a.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
pci 0000:00:14.4: PCI bridge to [bus 05-05] (subtractive decode)
pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0xd0000000-0xdfffffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE9._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
 pci0000:00: Requesting ACPI _OSC control (0x1d)
 pci0000:00: ACPI _OSC control (0x1d) granted
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *9 10 11 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 9 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 14 15) *0
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 14 15) *0
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 14 15) *0
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 14 15) *0
vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:01:05.0
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
e820: reserve RAM buffer [mem 0x0009ec00-0x0009ffff]
e820: reserve RAM buffer [mem 0xcff70000-0xcfffffff]
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 32-bit 14.318180 MHz counter
Switching to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [bus 00-ff]
pnp 00:00: [io  0x0cf8-0x0cff]
pnp 00:00: [io  0x0000-0x0cf7 window]
pnp 00:00: [io  0x0d00-0xffff window]
pnp 00:00: [mem 0x000a0000-0x000bffff window]
pnp 00:00: [mem 0x000d0000-0x000dffff window]
pnp 00:00: [mem 0xd0000000-0xdfffffff window]
pnp 00:00: [mem 0xf0000000-0xfebfffff window]
pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
pnp 00:01: [mem 0x00000000-0xffffffffffffffff disabled]
pnp 00:01: [mem 0x00000000-0xffffffffffffffff disabled]
system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:02: [dma 4]
pnp 00:02: [io  0x0000-0x000f]
pnp 00:02: [io  0x0081-0x0083]
pnp 00:02: [io  0x0087]
pnp 00:02: [io  0x0089-0x008b]
pnp 00:02: [io  0x008f]
pnp 00:02: [io  0x00c0-0x00df]
pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:03: [io  0x0070-0x0071]
pnp 00:03: [irq 8]
pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:04: [io  0x0061]
pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:05: [io  0x00f0-0x00ff]
pnp 00:05: [irq 13]
pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:06: [io  0x0378-0x037f]
pnp 00:06: [irq 7]
pnp 00:06: [dma 0 disabled]
pnp 00:06: Plug and Play ACPI device, IDs PNP0400 (active)
pnp 00:07: [mem 0xfed00000-0xfed003ff]
pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:08: [io  0x0060]
pnp 00:08: [io  0x0064]
pnp 00:08: [irq 1]
pnp 00:08: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
pnp 00:09: [io  0x03f8-0x03ff]
pnp 00:09: [irq 4]
pnp 00:09: [dma 0 disabled]
pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:0a: [mem 0xfec00000-0xfec00fff]
pnp 00:0a: [mem 0xfee00000-0xfee00fff]
system 00:0a: [mem 0xfec00000-0xfec00fff] could not be reserved
system 00:0a: [mem 0xfee00000-0xfee00fff] has been reserved
system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0b: [io  0x0010-0x001f]
pnp 00:0b: [io  0x0022-0x003f]
pnp 00:0b: [io  0x0062-0x0063]
pnp 00:0b: [io  0x0065-0x006f]
pnp 00:0b: [io  0x0072-0x007f]
pnp 00:0b: [io  0x0080]
pnp 00:0b: [io  0x0084-0x0086]
pnp 00:0b: [io  0x0088]
pnp 00:0b: [io  0x008c-0x008e]
pnp 00:0b: [io  0x0090-0x009f]
pnp 00:0b: [io  0x00a2-0x00bf]
pnp 00:0b: [io  0x00b1]
pnp 00:0b: [io  0x00e0-0x00ef]
pnp 00:0b: [io  0x04d0-0x04d1]
pnp 00:0b: [io  0x040b]
pnp 00:0b: [io  0x04d6]
pnp 00:0b: [io  0x0c00-0x0c01]
pnp 00:0b: [io  0x0c14]
pnp 00:0b: [io  0x0c50-0x0c51]
pnp 00:0b: [io  0x0c52]
pnp 00:0b: [io  0x0c6c]
pnp 00:0b: [io  0x0c6f]
pnp 00:0b: [io  0x0cd0-0x0cd1]
pnp 00:0b: [io  0x0cd2-0x0cd3]
pnp 00:0b: [io  0x0cd4-0x0cd5]
pnp 00:0b: [io  0x0cd6-0x0cd7]
pnp 00:0b: [io  0x0cd8-0x0cdf]
pnp 00:0b: [io  0x0b00-0x0b3f]
pnp 00:0b: [io  0x0800-0x089f]
pnp 00:0b: [io  0x0000-0xffffffffffffffff disabled]
pnp 00:0b: [io  0x0b00-0x0b1f]
pnp 00:0b: [io  0x0b20-0x0b3f]
pnp 00:0b: [io  0x0900-0x090f]
pnp 00:0b: [io  0x0910-0x091f]
pnp 00:0b: [io  0xfe00-0xfefe]
pnp 00:0b: [io  0x0060-0x005f disabled]
pnp 00:0b: [io  0x0064-0x0063 disabled]
pnp 00:0b: [mem 0x00000000-0xffffffffffffffff disabled]
pnp 00:0b: [mem 0xffb80000-0xffbfffff]
pnp 00:0b: [mem 0xfec10000-0xfec1001f]
pnp 00:0b: [mem 0xfed40000-0xfed44fff]
pnp 00:0b: [mem 0xfed80000-0xfed80fff]
pnp 00:0b: [mem 0x00000000-0xffffffffffffffff disabled]
system 00:0b: [io  0x04d0-0x04d1] has been reserved
system 00:0b: [io  0x040b] has been reserved
system 00:0b: [io  0x04d6] has been reserved
system 00:0b: [io  0x0c00-0x0c01] has been reserved
system 00:0b: [io  0x0c14] has been reserved
system 00:0b: [io  0x0c50-0x0c51] has been reserved
system 00:0b: [io  0x0c52] has been reserved
system 00:0b: [io  0x0c6c] has been reserved
system 00:0b: [io  0x0c6f] has been reserved
system 00:0b: [io  0x0cd0-0x0cd1] has been reserved
system 00:0b: [io  0x0cd2-0x0cd3] has been reserved
system 00:0b: [io  0x0cd4-0x0cd5] has been reserved
system 00:0b: [io  0x0cd6-0x0cd7] has been reserved
system 00:0b: [io  0x0cd8-0x0cdf] has been reserved
system 00:0b: [io  0x0b00-0x0b3f] has been reserved
system 00:0b: [io  0x0800-0x089f] has been reserved
system 00:0b: [io  0x0b00-0x0b1f] has been reserved
system 00:0b: [io  0x0b20-0x0b3f] has been reserved
system 00:0b: [io  0x0900-0x090f] has been reserved
system 00:0b: [io  0x0910-0x091f] has been reserved
system 00:0b: [io  0xfe00-0xfefe] has been reserved
system 00:0b: [mem 0xffb80000-0xffbfffff] has been reserved
system 00:0b: [mem 0xfec10000-0xfec1001f] has been reserved
system 00:0b: [mem 0xfed40000-0xfed44fff] has been reserved
system 00:0b: [mem 0xfed80000-0xfed80fff] has been reserved
system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0c: [io  0x0000-0xffffffffffffffff disabled]
pnp 00:0c: [io  0x0230-0x023f]
pnp 00:0c: [io  0x0290-0x029f]
pnp 00:0c: [io  0x0300-0x030f]
pnp 00:0c: [io  0x0a30-0x0a3f]
system 00:0c: [io  0x0230-0x023f] has been reserved
system 00:0c: [io  0x0290-0x029f] has been reserved
system 00:0c: [io  0x0300-0x030f] has been reserved
system 00:0c: [io  0x0a30-0x0a3f] has been reserved
system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0d: [mem 0xe0000000-0xefffffff]
system 00:0d: [mem 0xe0000000-0xefffffff] has been reserved
system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0e: [mem 0x00000000-0x0009ffff]
pnp 00:0e: [mem 0x000c0000-0x000cffff]
pnp 00:0e: [mem 0x000e0000-0x000fffff]
pnp 00:0e: [mem 0x00100000-0xcfffffff]
pnp 00:0e: [mem 0xfec00000-0xffffffff]
system 00:0e: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:0e: [mem 0x000c0000-0x000cffff] could not be reserved
system 00:0e: [mem 0x000e0000-0x000fffff] could not be reserved
system 00:0e: [mem 0x00100000-0xcfffffff] could not be reserved
system 00:0e: [mem 0xfec00000-0xffffffff] could not be reserved
system 00:0e: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0xc000-0xcfff]
pci 0000:00:01.0:   bridge window [mem 0xfe800000-0xfe9fffff]
pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:00:07.0: PCI bridge to [bus 02-02]
pci 0000:00:07.0:   bridge window [mem 0xfea00000-0xfeafffff]
pci 0000:00:09.0: PCI bridge to [bus 03-03]
pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
pci 0000:00:09.0:   bridge window [mem 0xfeb00000-0xfebfffff]
pci 0000:00:0a.0: PCI bridge to [bus 04-04]
pci 0000:00:0a.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:0a.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
pci 0000:00:14.4: PCI bridge to [bus 05-05]
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
pci_bus 0000:00: resource 8 [mem 0xd0000000-0xdfffffff]
pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfebfffff]
pci_bus 0000:01: resource 0 [io  0xc000-0xcfff]
pci_bus 0000:01: resource 1 [mem 0xfe800000-0xfe9fffff]
pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
pci_bus 0000:02: resource 1 [mem 0xfea00000-0xfeafffff]
pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
pci_bus 0000:03: resource 1 [mem 0xfeb00000-0xfebfffff]
pci_bus 0000:04: resource 0 [io  0xe000-0xefff]
pci_bus 0000:04: resource 2 [mem 0xfdf00000-0xfdffffff 64bit pref]
pci_bus 0000:05: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:05: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:05: resource 7 [mem 0x000d0000-0x000dffff]
pci_bus 0000:05: resource 8 [mem 0xd0000000-0xdfffffff]
pci_bus 0000:05: resource 9 [mem 0xf0000000-0xfebfffff]
NET: Registered protocol family 2
IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP: reno registered
UDP hash table entries: 8192 (order: 6, 262144 bytes)
UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
pci 0000:00:01.0: MSI quirk detected; subordinate MSI disabled
pci 0000:01:05.0: Boot video device
PCI: CLS 64 bytes, default 64
Unpacking initramfs...
Freeing initrd memory: 5588k freed
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ c4000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
LVT offset 1 assigned for vector 0x400
IBS: LVT offset 1 assigned
perf: AMD IBS detected (0x0000001f)
audit: initializing netlink socket (disabled)
type=2000 audit(1347557403.346:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 31603
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler cfq registered (default)
pcieport 0000:00:07.0: irq 40 for MSI/MSI-X
pcieport 0000:00:09.0: irq 41 for MSI/MSI-X
pcieport 0000:00:0a.0: irq 42 for MSI/MSI-X
pcieport 0000:00:07.0: Signaling PME through PCIe PME interrupt
pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:07.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:09.0: Signaling PME through PCIe PME interrupt
pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:09.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:0a.0: Signaling PME through PCIe PME interrupt
pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:0a.0:pcie01: service driver pcie_pme loaded
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
mousedev: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
Key type dns_resolver registered
PM: Hibernation image not present or could not be loaded.
registered taskstats version 1
Freeing unused kernel memory: 716k freed
Write protecting the kernel read-only data: 6144k
Freeing unused kernel memory: 120k freed
Freeing unused kernel memory: 776k freed
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
SCSI subsystem initialized
libata version 3.00 loaded.
ahci 0000:00:11.0: version 3.0
ahci 0000:00:11.0: AHCI 0001.0200 32 slots 4 ports 6 Gbps 0xf impl SATA mode
ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7ffd00 irq 19
ata2: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7ffd80 irq 19
ata3: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7ffe00 irq 19
ata4: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7ffe80 irq 19
ata2: SATA link down (SStatus 0 SControl 300)
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
ata1.00: ATA-8: WDC WD5000AAKX-001CA0, 15.01H15, max UDMA/133
ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      WDC WD5000AAKX-0 15.0 PQ: 0 ANSI: 5
ACPI: bus type usb registered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:12.2: EHCI Host Controller
ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
QUIRK: Enable AMD PLL fix
ehci_hcd 0000:00:12.2: debug port 1
ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe7ff800
ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 3.5.3 ehci_hcd
usb usb1: SerialNumber: 0000:00:12.2
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 5 ports detected
ehci_hcd 0000:00:13.2: EHCI Host Controller
ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
ehci_hcd 0000:00:13.2: debug port 1
ehci_hcd 0000:00:13.2: irq 17, io mem 0xfe7ff400
ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 3.5.3 ehci_hcd
usb usb2: SerialNumber: 0000:00:13.2
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 5 ports detected
ehci_hcd 0000:00:16.2: EHCI Host Controller
ehci_hcd 0000:00:16.2: new USB bus registered, assigned bus number 3
ehci_hcd 0000:00:16.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
ehci_hcd 0000:00:16.2: debug port 1
ehci_hcd 0000:00:16.2: irq 17, io mem 0xfe7ff000
ehci_hcd 0000:00:16.2: USB 2.0 started, EHCI 1.00
usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: EHCI Host Controller
usb usb3: Manufacturer: Linux 3.5.3 ehci_hcd
usb usb3: SerialNumber: 0000:00:16.2
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 4 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:12.0: OHCI Host Controller
ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:12.0: irq 18, io mem 0xfe7fe000
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: OHCI Host Controller
usb usb4: Manufacturer: Linux 3.5.3 ohci_hcd
usb usb4: SerialNumber: 0000:00:12.0
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 5 ports detected
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe7fd000
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: OHCI Host Controller
usb usb5: Manufacturer: Linux 3.5.3 ohci_hcd
usb usb5: SerialNumber: 0000:00:13.0
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 5 ports detected
ohci_hcd 0000:00:14.5: OHCI Host Controller
ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 6
ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe7fc000
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: OHCI Host Controller
usb usb6: Manufacturer: Linux 3.5.3 ohci_hcd
usb usb6: SerialNumber: 0000:00:14.5
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
ohci_hcd 0000:00:16.0: OHCI Host Controller
ohci_hcd 0000:00:16.0: new USB bus registered, assigned bus number 7
ohci_hcd 0000:00:16.0: irq 18, io mem 0xfe7f7000
Refined TSC clocksource calibration: 3013.430 MHz.
Switching to clocksource tsc
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: OHCI Host Controller
usb usb7: Manufacturer: Linux 3.5.3 ohci_hcd
usb usb7: SerialNumber: 0000:00:16.0
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 4 ports detected
pata_atiixp 0000:00:14.1: setting latency timer to 64
scsi4 : pata_atiixp
scsi5 : pata_atiixp
ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
xhci_hcd 0000:02:00.0: xHCI Host Controller
xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 8
xhci_hcd 0000:02:00.0: irq 19, io mem 0xfeafe000
xhci_hcd 0000:02:00.0: irq 43 for MSI/MSI-X
xhci_hcd 0000:02:00.0: irq 44 for MSI/MSI-X
xhci_hcd 0000:02:00.0: irq 45 for MSI/MSI-X
usb usb8: New USB device found, idVendor=1d6b, idProduct=0002
usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb8: Product: xHCI Host Controller
usb usb8: Manufacturer: Linux 3.5.3 xhci_hcd
usb usb8: SerialNumber: 0000:02:00.0
xHCI xhci_add_endpoint called for root hub
xHCI xhci_check_bandwidth called for root hub
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
xhci_hcd 0000:02:00.0: xHCI Host Controller
xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 9
usb usb9: New USB device found, idVendor=1d6b, idProduct=0003
usb usb9: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb9: Product: xHCI Host Controller
usb usb9: Manufacturer: Linux 3.5.3 xhci_hcd
usb usb9: SerialNumber: 0000:02:00.0
xHCI xhci_add_endpoint called for root hub
xHCI xhci_check_bandwidth called for root hub
hub 9-0:1.0: USB hub found
hub 9-0:1.0: 2 ports detected
pata_via 0000:03:00.0: version 0.3.4
scsi6 : pata_via
scsi7 : pata_via
ata7: PATA max UDMA/133 cmd 0xdc00 ctl 0xd880 bmdma 0xd400 irq 17
ata8: PATA max UDMA/133 cmd 0xd800 ctl 0xd480 bmdma 0xd408 irq 17
usb 4-5: new low-speed USB device number 2 using ohci_hcd
usbcore: registered new interface driver libusual
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb 4-5: New USB device found, idVendor=046d, idProduct=c00b
usb 4-5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 4-5: Product: USB Mouse
usb 4-5: Manufacturer: Logitech
device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
NET: Registered protocol family 1
sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
PM: Hibernation mode set to 'shutdown'
kjournald starting.  Commit interval 5 seconds
EXT3-fs (dm-0): using internal journal
EXT3-fs (dm-0): mounted filesystem with writeback data mode
udevd[1504]: starting version 173
kvm: Nested Virtualization enabled
kvm: Nested Paging enabled
loop: module loaded
microcode: CPU0: patch_level=0x010000b6
microcode: CPU0: new patch_level=0x010000c8
microcode: CPU1: patch_level=0x010000b6
microcode: CPU1: new patch_level=0x010000c8
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button [PWRF]
ACPI Warning: 0x0000000000000b00-0x0000000000000b07 SystemIO conflicts with Region \_SB_.PCI0.SBRG.ASOC.SMRG 1 (20120320/utaddress-251)
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:04:00.0: irq 46 for MSI/MSI-X
r8169 0000:04:00.0: eth0: RTL8168e/8111e at 0xffffc900129fe000, 20:cf:30:f1:72:94, XID 0c200000 IRQ 46
r8169 0000:04:00.0: eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
wmi: Mapper loaded
sp5100_tco: SP5100 TCO WatchDog Timer Driver v0.01
sp5100_tco: mmio address 0xb8fe00 already in use
rtc_cmos 00:03: RTC can wake from S4
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
MCE: In-kernel MCE decoding enabled.
EDAC MC: Ver: 2.1.0
AMD64 EDAC driver v3.4.0
EDAC amd64: DRAM ECC disabled.
EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
 Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
 (Note that use of the override may cause unknown side effects.)
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
sd 0:0:0:0: Attached scsi generic sg0 type 0
parport_pc 00:06: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
ACPI: processor limited to max C-state 1
ppdev: user-space parallel port driver
powernow-k8: Found 1 AMD Athlon(tm) II X2 250 Processor (2 cpu cores) (version 2.20.00)
powernow-k8:    0 : pstate 0 (3000 MHz)
powernow-k8:    1 : pstate 1 (2300 MHz)
powernow-k8:    2 : pstate 2 (1800 MHz)
powernow-k8:    3 : pstate 3 (800 MHz)
input: Logitech USB Mouse as /devices/pci0000:00/0000:00:12.0/usb4/4-5/4-5:1.0/input/input3
hid-generic 0003:046D:C00B.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB Mouse] on usb-0000:00:12.0-5/input0
Linux agpgart interface v0.103
Adding 20971516k swap on /dev/sda2.  Priority:-1 extents:1 across:20971516k 
[drm] Initialized drm 1.1.0 20060810
snd_hda_intel 0000:01:05.1: setting latency timer to 64
[drm] radeon defaulting to kernel modesetting.
[drm] radeon kernel modesetting enabled.
[drm] initializing kernel modesetting (RS880 0x1002:0x9715 0x1043:0x843E).
[drm] register mmio base: 0xFE9F0000
[drm] register mmio size: 65536
ATOM BIOS: 113
radeon 0000:01:05.0: VRAM: 256M 0x00000000C0000000 - 0x00000000CFFFFFFF (256M used)
radeon 0000:01:05.0: GTT: 512M 0x00000000A0000000 - 0x00000000BFFFFFFF
[drm] Detected VRAM RAM=256M, BAR=256M
[drm] RAM width 32bits DDR
[TTM] Zone  kernel: Available graphics memory: 8091322 kiB
[TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[TTM] Initializing pool allocator
[TTM] Initializing DMA pool allocator
[drm] radeon: 256M of VRAM memory ready
[drm] radeon: 512M of GTT memory ready.
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
[drm] radeon: irq initialized.
[drm] GART: num cpu pages 131072, num gpu pages 131072
[drm] Loading RS780 Microcode
[drm] PCIE GART of 512M enabled (table at 0x00000000C0040000).
radeon 0000:01:05.0: WB enabled
radeon 0000:01:05.0: fence driver on ring 0 use gpu addr 0x00000000a0000c00 and cpu addr 0xffff880406536c00
radeon 0000:01:05.0: setting latency timer to 64
[drm] ring test on 0 succeeded in 1 usecs
[drm] ib test on ring 0 succeeded in 0 usecs
[drm] Radeon Display Connectors
[drm] Connector 0:
[drm]   VGA-1
[drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[drm]   Encoders:
[drm]     CRT1: INTERNAL_KLDSCP_DAC1
[drm] Connector 1:
[drm]   DVI-D-1
[drm]   HPD1
[drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[drm]   Encoders:
[drm]     DFP3: INTERNAL_KLDSCP_LVTMA
[drm] radeon: power management initialized
[drm] fb mappable at 0xD0142000
[drm] vram apper at 0xD0000000
[drm] size 8294400
[drm] fb depth is 24
[drm]    pitch is 7680
fbcon: radeondrmfb (fb0) is primary device
Console: switching to colour frame buffer device 240x67
fb0: radeondrmfb frame buffer device
drm: registered panic notifier
[drm] Initialized radeon 2.18.0 20080528 for 0000:01:05.0 on minor 0
r8169 0000:04:00.0: eth0: link down
r8169 0000:04:00.0: eth0: link down
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda1): using internal journal
EXT3-fs (sda1): mounted filesystem with writeback data mode
NET: Registered protocol family 10
IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
Bridge firewalling registered
device eth0 entered promiscuous mode
r8169 0000:04:00.0: eth0: link up
IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
br0: port 1(eth0) entered forwarding state
br0: port 1(eth0) entered forwarding state
NET: Registered protocol family 17

--=-=-=
Content-Type: text/plain
Content-Disposition: inline; filename=acpidump.txt
Content-Description: output from acpidump

DSDT @ 0xcff70450
  0000: 44 53 44 54 8f ee 00 00 01 a0 41 31 36 34 32 00  DSDT......A1642.
  0010: 41 31 36 34 32 30 30 31 01 00 00 00 49 4e 54 4c  A1642001....INTL
  0020: 13 01 06 20 08 4f 53 54 59 ff 5b 80 41 43 4d 53  ... .OSTY.[.ACMS
  0030: 01 0a 72 0a 10 5b 81 18 41 43 4d 53 01 49 43 4d  ..r..[..ACMS.ICM
  0040: 53 08 44 43 4d 53 08 00 40 06 50 38 30 5f 08 5b  S.DCMS..@.P80_.[
  0050: 86 15 49 43 4d 53 44 43 4d 53 01 00 08 00 18 00  ..ICMSDCMS......
  0060: 20 42 53 5f 41 20 5b 80 43 46 47 53 00 42 53 5f   BS_A [.CFGS.BS_
  0070: 41 0b 00 01 5b 81 40 07 43 46 47 53 00 00 40 06  A...[.@.CFGS..@.
  0080: 50 43 49 45 20 00 48 37 00 05 47 47 4e 32 01 00  PCIE .H7..GGN2..
  0090: 3a 47 45 43 45 01 49 52 5f 45 01 00 4e 05 00 05  :GECE.IR_E..N...
  00a0: 4f 53 43 46 01 00 42 05 50 52 53 30 01 44 45 54  OSCF..B.PRS0.DET
  00b0: 30 01 00 1e 50 52 53 31 01 44 45 54 31 01 00 1e  0...PRS1.DET1...
  00c0: 50 52 53 32 01 44 45 54 32 01 00 1e 50 52 53 33  PRS2.DET2...PRS3
  00d0: 01 44 45 54 33 01 00 3e 00 06 41 42 50 53 01 00  .DET3..>..ABPS..
  00e0: 03 47 50 50 53 01 5b 80 43 4d 50 54 01 0b 50 0c  .GPPS.[.CMPT..P.
  00f0: 0a 03 5b 81 3a 43 4d 50 54 01 43 4d 49 44 08 00  ..[.:CMPT.CMID..
  0100: 06 47 50 43 54 02 47 50 30 49 01 47 50 31 49 01  .GPCT.GP0I.GP1I.
  0110: 47 50 32 49 01 47 50 33 49 01 47 50 34 49 01 47  GP2I.GP3I.GP4I.G
  0120: 50 35 49 01 47 50 36 49 01 47 50 37 49 01 5b 80  P5I.GP6I.GP7I.[.
  0130: 50 43 46 47 00 50 43 49 45 0c 00 00 00 02 5b 81  PCFG.PCIE.....[.
  0140: 49 0b 50 43 46 47 00 00 c0 3c 00 01 00 10 50 4d  I.PCFG...<....PM
  0150: 53 41 01 00 8f fe 3f 00 10 50 4d 53 42 01 00 8f  SA....?..PMSB...
  0160: fe ff 00 10 50 4d 53 43 01 00 cf c7 ff 01 53 54  ....PMSC......ST
  0170: 43 4c 10 00 40 78 52 4d 42 41 20 00 80 82 bf 53  CL..@xRMBA ....S
  0180: 4d 49 45 01 53 4d 4d 45 01 00 1e 52 56 49 44 08  MIE.SMME...RVID.
  0190: 00 48 05 53 4d 42 31 20 00 40 35 00 02 47 33 31  .H.SMB1 .@5..G31
  01a0: 4f 01 00 45 2f 00 06 41 43 49 52 01 00 81 91 1f  O..E/..ACIR.....
  01b0: 50 43 4d 44 02 00 8e 3a 20 50 4d 53 30 01 00 4f  PCMD...: PMS0..O
  01c0: 06 54 4c 53 30 04 00 8c f8 07 50 4d 53 31 01 00  .TLS0.....PMS1..
  01d0: 4f 06 54 4c 53 31 04 00 8c f8 07 50 4d 53 32 01  O.TLS1.....PMS2.
  01e0: 00 4f 06 54 4c 53 32 04 00 8c f8 07 50 4d 53 33  .O.TLS2.....PMS3
  01f0: 01 00 4f 06 54 4c 53 33 04 5b 80 52 4d 45 4d 00  ..O.TLS3.[.RMEM.
  0200: 52 4d 42 41 0b 00 02 5b 81 0d 52 4d 45 4d 00 00  RMBA...[..RMEM..
  0210: 20 52 4d 4c 4e 20 5b 80 50 4d 49 4f 01 0b d6 0c   RMLN [.PMIO....
  0220: 0a 02 5b 81 10 50 4d 49 4f 01 49 4e 50 4d 08 44  ..[..PMIO.INPM.D
  0230: 41 50 4d 08 5b 86 1a 49 4e 50 4d 44 41 50 4d 01  APM.[..INPMDAPM.
  0240: 00 40 12 4d 4d 53 4f 20 00 40 1c 50 31 45 42 10  .@.MMSO .@.P1EB.
  0250: 5b 80 45 52 4d 4d 00 4d 4d 53 4f 0b 00 10 5b 81  [.ERMM.MMSO...[.
  0260: 4d 0a 45 52 4d 4d 00 00 40 99 00 07 47 50 35 31  M.ERMM..@...GP51
  0270: 01 00 18 00 07 47 50 35 35 01 00 18 00 07 47 50  .....GP55.....GP
  0280: 35 39 01 00 10 47 50 36 32 08 00 08 00 07 47 50  59...GP62.....GP
  0290: 36 34 01 00 40 15 00 07 47 45 31 31 01 00 07 47  64..@...GE11...G
  02a0: 45 31 32 01 00 10 00 07 42 41 54 53 01 00 40 1f  E12.....BATS..@.
  02b0: 00 06 47 31 37 33 01 00 49 6c 00 01 43 4c 50 53  ..G173..Il..CLPS
  02c0: 01 00 46 08 00 07 47 31 35 41 01 00 40 0b 00 02  ..F...G15A..@...
  02d0: 53 4c 50 53 02 00 44 63 45 50 4e 4d 01 44 50 50  SLPS..DcEPNM.DPP
  02e0: 46 01 00 4e 21 00 06 50 57 44 45 01 00 11 00 05  F..N!..PWDE.....
  02f0: 41 4c 4c 53 01 00 4a 18 50 48 59 44 01 00 01 00  ALLS..J.PHYD....
  0300: 01 55 53 35 52 01 00 2c 47 45 43 44 01 5b 80 41  .US5R..,GECD.[.A
  0310: 42 49 4f 01 0b d8 0c 0a 08 5b 81 10 41 42 49 4f  BIO......[..ABIO
  0320: 03 49 4e 41 42 20 44 41 41 42 20 14 11 52 44 41  .INAB DAAB ..RDA
  0330: 42 01 70 68 49 4e 41 42 a4 44 41 41 42 14 12 57  B.phINAB.DAAB..W
  0340: 54 41 42 02 70 68 49 4e 41 42 70 69 44 41 41 42  TAB.phINABpiDAAB
  0350: 14 18 52 57 41 42 03 7b 52 44 41 42 68 69 60 7d  ..RWAB.{RDABhi`}
  0360: 60 6a 61 57 54 41 42 68 61 14 1a 43 41 42 52 03  `jaWTABha..CABR.
  0370: 79 68 0a 05 60 72 60 69 61 79 61 0a 18 62 72 62  yh..`r`iaya..brb
  0380: 6a 63 a4 63 14 45 14 47 48 50 53 02 a0 4a 06 93  jc.c.E.GHPS..J..
  0390: 68 00 a0 2f 93 69 00 52 57 41 42 43 41 42 52 0a  h../.i.RWABCABR.
  03a0: 06 00 0a c0 0c ff ef ff ff 00 52 57 41 42 43 41  ..........RWABCA
  03b0: 42 52 01 00 0a 65 0c fe fe ff ff 00 70 01 44 45  BR...e......p.DE
  03c0: 54 30 a0 30 93 69 0a 02 52 57 41 42 43 41 42 52  T0.0.i..RWABCABR
  03d0: 0a 06 00 0a c0 0c ff bf ff ff 00 52 57 41 42 43  ...........RWABC
  03e0: 41 42 52 01 00 0a 65 0c fb fb ff ff 00 70 01 44  ABR...e......p.D
  03f0: 45 54 32 5b 21 0a c8 a0 42 07 93 68 01 a0 33 93  ET2[!...B..h..3.
  0400: 69 00 52 57 41 42 43 41 42 52 0a 06 00 0a c0 0c  i.RWABCABR......
  0410: ff ef ff ff 0b 00 10 52 57 41 42 43 41 42 52 01  .......RWABCABR.
  0420: 00 0a 65 0c fe fe ff ff 0b 01 01 70 00 44 45 54  ..e........p.DET
  0430: 30 a0 34 93 69 0a 02 52 57 41 42 43 41 42 52 0a  0.4.i..RWABCABR.
  0440: 06 00 0a c0 0c ff bf ff ff 0b 00 40 52 57 41 42  ...........@RWAB
  0450: 43 41 42 52 01 00 0a 65 0c fb fb ff ff 0b 04 04  CABR...e........
  0460: 70 00 44 45 54 32 5b 21 0a c8 a0 4f 05 47 47 4e  p.DET2[!...O.GGN
  0470: 32 a0 48 05 93 68 00 47 45 4e 32 70 52 44 41 42  2.H..h.GEN2pRDAB
  0480: 43 41 42 52 0a 03 0a 02 0a a5 60 7b 60 0a ff 60  CABR......`{`..`
  0490: 70 0b f4 01 61 a2 29 90 94 61 00 92 93 60 0a 10  p...a.)..a...`..
  04a0: 70 52 44 41 42 43 41 42 52 0a 03 0a 02 0a a5 60  pRDABCABR......`
  04b0: 7b 60 0a ff 60 76 61 5b 21 0a c8 5b 21 0a c8 a0  {`..`va[!..[!...
  04c0: 0a 92 93 60 0a 10 47 45 4e 31 14 4e 06 47 45 4e  ...`..GEN1.N.GEN
  04d0: 32 00 70 0a 02 54 4c 53 32 52 57 41 42 43 41 42  2.p..TLS2RWABCAB
  04e0: 52 0a 03 0a 02 0a a4 0c fe ff ff ff 01 52 57 41  R............RWA
  04f0: 42 43 41 42 52 0a 03 0a 02 0a a2 0c ff df ff ff  BCABR...........
  0500: 0b 00 20 52 57 41 42 43 41 42 52 0a 03 0a 02 0a  .. RWABCABR.....
  0510: c0 0c ff 7f ff ff 0b 00 80 52 57 41 42 43 41 42  .........RWABCAB
  0520: 52 0a 03 0a 02 0a a4 0c ff ff ff df 0c 00 00 00  R...............
  0530: 20 5b 21 0a c8 5b 21 0a c8 14 3e 47 45 4e 31 00   [!..[!...>GEN1.
  0540: 70 01 54 4c 53 32 52 57 41 42 43 41 42 52 0a 03  p.TLS2RWABCABR..
  0550: 0a 02 0a a4 0c fe ff ff ff 00 52 57 41 42 43 41  ..........RWABCA
  0560: 42 52 0a 03 0a 02 0a a2 0c ff df ff ff 0b 00 20  BR............. 
  0570: 5b 21 0a c8 5b 21 0a c8 5b 80 50 31 45 30 01 50  [!..[!..[.P1E0.P
  0580: 31 45 42 0a 04 5b 81 19 50 31 45 30 01 00 0e 50  1EB..[..P1E0...P
  0590: 45 57 53 01 57 53 54 41 01 00 0e 50 45 57 44 01  EWS.WSTA...PEWD.
  05a0: 14 20 53 50 54 53 01 70 01 50 43 4d 44 70 68 50  . SPTS.p.PCMDphP
  05b0: 38 30 5f 43 50 4d 53 43 50 4d 53 70 01 50 45 57  80_CPMSCPMSp.PEW
  05c0: 53 14 14 53 57 41 4b 01 43 50 4d 53 43 50 4d 53  S..SWAK.CPMSCPMS
  05d0: 70 01 50 45 57 53 14 06 54 52 4d 44 01 14 38 43  p.PEWS..TRMD..8C
  05e0: 50 4d 53 00 a0 31 93 45 50 4e 4d 00 70 01 50 4d  PMS..1.EPNM.p.PM
  05f0: 53 41 70 01 50 4d 53 42 70 01 50 4d 53 43 70 01  SAp.PMSBp.PMSCp.
  0600: 50 4d 53 30 70 01 50 4d 53 31 70 01 50 4d 53 32  PMS0p.PMS1p.PMS2
  0610: 70 01 50 4d 53 33 10 05 5f 47 50 45 14 06 4e 50  p.PMS3.._GPE..NP
  0620: 54 53 01 14 06 4e 57 41 4b 01 08 44 50 38 30 0a  TS...NWAK..DP80.
  0630: 80 08 44 50 39 30 0a 90 08 53 50 49 4f 0a 2e 08  ..DP90...SPIO...
  0640: 49 4f 50 42 0b 30 02 08 49 4f 50 4c 0a 10 08 49  IOPB.0..IOPL...I
  0650: 4f 45 4c 0a 10 08 49 4f 47 42 0b 00 03 08 49 4f  OEL...IOGB....IO
  0660: 47 4c 0a 10 08 49 4f 53 42 0b 30 0a 08 49 4f 53  GL...IOSB.0..IOS
  0670: 4c 0a 10 08 41 54 53 57 0a e5 08 41 50 49 43 01  L...ATSW...APIC.
  0680: 08 50 4d 42 53 0b 00 08 08 50 4d 4c 4e 0a a0 08  .PMBS....PMLN...
  0690: 47 50 42 53 00 08 47 50 4c 4e 00 08 53 4d 42 30  GPBS..GPLN..SMB0
  06a0: 0b 00 0b 08 53 4d 42 42 0b 20 0b 08 53 4d 42 4d  ....SMBB. ..SMBM
  06b0: 0a 20 08 53 4d 42 4c 0a 20 08 41 4f 44 53 0a f5  . .SMBL. .AODS..
  06c0: 08 53 4d 49 50 0a b0 08 41 43 53 53 01 08 53 42  .SMIP...ACSS..SB
  06d0: 41 31 0b 00 0b 08 53 42 41 32 0b 20 0b 08 53 49  A1....SBA2. ..SI
  06e0: 4f 50 0a 2e 08 47 49 4f 42 0b 00 03 08 54 31 4f  OP...GIOB....T1O
  06f0: 46 00 08 54 32 4f 46 00 08 54 33 4f 46 00 08 43  F..T2OF..T3OF..C
  0700: 51 53 54 0a 3c 08 50 43 49 42 0c 00 00 00 e0 08  QST.<.PCIB......
  0710: 50 43 49 4c 0c 00 00 00 10 08 50 45 48 50 01 08  PCIL......PEHP..
  0720: 53 48 50 43 00 08 50 45 50 4d 01 08 50 45 45 52  SHPC..PEPM..PEER
  0730: 01 08 50 45 43 53 01 08 53 4d 49 54 0a b0 08 43  ..PECS..SMIT...C
  0740: 4d 52 51 0a e0 08 43 4d 45 52 0a e1 08 43 4d 4f  MRQ...CMER...CMO
  0750: 52 0a e4 08 53 4d 42 53 0b 20 0b 08 53 4d 49 4f  R...SMBS. ..SMIO
  0760: 0a b0 08 49 4f 45 42 0b 90 02 08 41 54 49 45 0c  ...IOEB....ATIE.
  0770: 00 00 00 e0 08 49 4f 31 42 0b 00 03 08 53 42 52  .....IO1B....SBR
  0780: 56 0b d0 0c 5b 80 42 49 4f 53 00 0c 64 80 f8 cf  V...[.BIOS..d...
  0790: 0a ff 5b 81 4b 0a 42 49 4f 53 01 53 53 31 5f 01  ..[.K.BIOS.SS1_.
  07a0: 53 53 32 5f 01 53 53 33 5f 01 53 53 34 5f 01 00  SS2_.SS3_.SS4_..
  07b0: 04 49 4f 53 54 10 54 4f 50 4d 20 52 4f 4d 53 20  .IOST.TOPM ROMS 
  07c0: 4d 47 31 42 20 4d 47 31 4c 20 4d 47 32 42 20 4d  MG1B MG1L MG2B M
  07d0: 47 32 4c 20 00 08 44 4d 41 58 08 48 50 54 41 20  G2L ..DMAX.HPTA 
  07e0: 43 50 42 30 20 43 50 42 31 20 43 50 42 32 20 43  CPB0 CPB1 CPB2 C
  07f0: 50 42 33 20 41 53 53 42 08 41 4f 54 42 08 41 41  PB3 ASSB.AOTB.AA
  0800: 58 42 20 53 4d 49 46 08 44 54 53 45 08 44 54 53  XB SMIF.DTSE.DTS
  0810: 31 08 44 54 53 32 08 4d 50 45 4e 08 54 50 4d 46  1.DTS2.MPEN.TPMF
  0820: 08 4d 47 33 42 20 4d 47 33 4c 20 4d 48 31 42 20  .MG3B MG3L MH1B 
  0830: 4d 48 31 4c 20 53 46 4c 47 08 4f 53 54 50 08 14  MH1L SFLG.OSTP..
  0840: 0f 52 52 49 4f 04 70 0d 52 52 49 4f 00 5b 31 14  .RRIO.p.RRIO.[1.
  0850: 0f 52 44 4d 41 03 70 0d 72 44 4d 41 00 5b 31 08  .RDMA.p.rDMA.[1.
  0860: 50 49 43 4d 00 14 1f 5f 50 49 43 01 a0 09 68 70  PICM..._PIC...hp
  0870: 0a aa 44 42 47 38 a1 08 70 0a ac 44 42 47 38 70  ..DBG8..p..DBG8p
  0880: 68 50 49 43 4d 08 4f 53 56 52 ff 14 43 0a 4f 53  hPICM.OSVR..C.OS
  0890: 46 4c 00 a0 0d 92 93 4f 53 56 52 ff a4 4f 53 56  FL.....OSVR..OSV
  08a0: 52 08 54 54 54 30 00 70 4f 53 59 53 54 54 54 30  R.TTT0.pOSYSTTT0
  08b0: a0 0e 93 54 54 54 30 01 70 0a 03 4f 53 56 52 a1  ...TTT0.p..OSVR.
  08c0: 4a 06 a0 0e 93 54 54 54 30 0a 10 70 01 4f 53 56  J....TTT0..p.OSV
  08d0: 52 a1 48 05 a0 0f 93 54 54 54 30 0a 11 70 0a 02  R.H....TTT0..p..
  08e0: 4f 53 56 52 a1 45 04 a0 0f 93 54 54 54 30 0a 12  OSVR.E....TTT0..
  08f0: 70 0a 04 4f 53 56 52 a1 32 a0 0e 93 54 54 54 30  p..OSVR.2...TTT0
  0900: 0a 13 70 00 4f 53 56 52 a1 21 a0 0e 93 54 54 54  ..p.OSVR.!...TTT
  0910: 30 0a 14 70 00 4f 53 56 52 a1 10 a0 0e 93 54 54  0..p.OSVR.....TT
  0920: 54 30 0a 15 70 00 4f 53 56 52 a4 4f 53 56 52 14  T0..p.OSVR.OSVR.
  0930: 4e 04 4d 43 54 48 02 a0 08 95 87 68 87 69 a4 00  N.MCTH.....h.i..
  0940: 72 87 68 01 60 08 42 55 46 30 11 02 60 08 42 55  r.h.`.BUF0..`.BU
  0950: 46 31 11 02 60 70 68 42 55 46 30 70 69 42 55 46  F1..`phBUF0piBUF
  0960: 31 a2 1a 60 76 60 a0 15 92 93 83 88 42 55 46 30  1..`v`......BUF0
  0970: 60 00 83 88 42 55 46 31 60 00 a4 00 a4 01 08 50  `...BUF1`......P
  0980: 52 57 50 12 04 02 00 00 14 4b 07 47 50 52 57 02  RWP......K.GPRW.
  0990: 70 68 88 50 52 57 50 00 00 70 79 53 53 31 5f 01  ph.PRWP..pySS1_.
  09a0: 00 60 7d 60 79 53 53 32 5f 0a 02 00 60 7d 60 79  .`}`ySS2_...`}`y
  09b0: 53 53 33 5f 0a 03 00 60 7d 60 79 53 53 34 5f 0a  SS3_...`}`ySS4_.
  09c0: 04 00 60 a0 11 7b 79 01 69 00 60 00 70 69 88 50  ..`..{y.i.`.pi.P
  09d0: 52 57 50 01 00 a1 29 7a 60 01 60 a0 18 91 93 4f  RWP...)z`.`....O
  09e0: 53 46 4c 01 93 4f 53 46 4c 0a 02 81 60 88 50 52  SFL..OSFL...`.PR
  09f0: 57 50 01 00 a1 0a 82 60 88 50 52 57 50 01 00 a4  WP.....`.PRWP...
  0a00: 50 52 57 50 08 57 41 4b 50 12 04 02 00 00 5b 80  PRWP.WAKP.....[.
  0a10: 44 45 42 30 01 44 50 38 30 01 5b 81 0b 44 45 42  DEB0.DP80.[..DEB
  0a20: 30 01 44 42 47 38 08 5b 80 44 45 42 31 01 44 50  0.DBG8.[.DEB1.DP
  0a30: 39 30 0a 02 5b 81 0b 44 45 42 31 02 44 42 47 39  90..[..DEB1.DBG9
  0a40: 10 14 4f 12 4f 53 59 53 00 70 0a 10 60 a0 41 0c  ..O.OSYS.p..`.A.
  0a50: 5b 12 5f 4f 53 49 61 a0 17 5f 4f 53 49 0d 57 69  [._OSIa.._OSI.Wi
  0a60: 6e 64 6f 77 73 20 32 30 30 30 00 70 0a 12 60 a0  ndows 2000.p..`.
  0a70: 17 5f 4f 53 49 0d 57 69 6e 64 6f 77 73 20 32 30  ._OSI.Windows 20
  0a80: 30 31 00 70 0a 13 60 a0 1b 5f 4f 53 49 0d 57 69  01.p..`.._OSI.Wi
  0a90: 6e 64 6f 77 73 20 32 30 30 31 20 53 50 31 00 70  ndows 2001 SP1.p
  0aa0: 0a 13 60 a0 1b 5f 4f 53 49 0d 57 69 6e 64 6f 77  ..`.._OSI.Window
  0ab0: 73 20 32 30 30 31 20 53 50 32 00 70 0a 13 60 a0  s 2001 SP2.p..`.
  0ac0: 19 5f 4f 53 49 0d 57 69 6e 64 6f 77 73 20 32 30  ._OSI.Windows 20
  0ad0: 30 31 2e 31 00 70 0a 14 60 a0 1d 5f 4f 53 49 0d  01.1.p..`.._OSI.
  0ae0: 57 69 6e 64 6f 77 73 20 32 30 30 31 2e 31 20 53  Windows 2001.1 S
  0af0: 50 31 00 70 0a 14 60 a0 17 5f 4f 53 49 0d 57 69  P1.p..`.._OSI.Wi
  0b00: 6e 64 6f 77 73 20 32 30 30 36 00 70 0a 15 60 a1  ndows 2006.p..`.
  0b10: 4f 05 a0 23 4d 43 54 48 5f 4f 53 5f 0d 4d 69 63  O..#MCTH_OS_.Mic
  0b20: 72 6f 73 6f 66 74 20 57 69 6e 64 6f 77 73 20 4e  rosoft Windows N
  0b30: 54 00 70 0a 12 60 a1 38 a0 36 4d 43 54 48 5f 4f  T.p..`.8.6MCTH_O
  0b40: 53 5f 0d 4d 69 63 72 6f 73 6f 66 74 20 57 69 6e  S_.Microsoft Win
  0b50: 64 6f 77 73 4d 45 3a 20 4d 69 6c 6c 65 6e 6e 69  dowsME: Millenni
  0b60: 75 6d 20 45 64 69 74 69 6f 6e 00 70 0a 11 60 a4  um Edition.p..`.
  0b70: 60 10 4a 08 5f 50 52 5f 5b 83 0b 50 30 30 31 01  `.J._PR_[..P001.
  0b80: 10 08 00 00 06 5b 83 0b 50 30 30 32 02 00 00 00  .....[..P002....
  0b90: 00 00 5b 83 0b 50 30 30 33 03 00 00 00 00 00 5b  ..[..P003......[
  0ba0: 83 0b 50 30 30 34 04 00 00 00 00 00 5b 83 0b 50  ..P004......[..P
  0bb0: 30 30 35 05 00 00 00 00 00 5b 83 0b 50 30 30 36  005......[..P006
  0bc0: 06 00 00 00 00 00 06 50 30 30 31 43 50 55 31 06  .......P001CPU1.
  0bd0: 50 30 30 32 43 50 55 32 06 50 30 30 33 43 50 55  P002CPU2.P003CPU
  0be0: 33 06 50 30 30 34 43 50 55 34 06 50 30 30 35 43  3.P004CPU4.P005C
  0bf0: 50 55 35 06 50 30 30 36 43 50 55 36 10 86 65 04  PU5.P006CPU6..e.
  0c00: 5f 53 42 5f 08 50 52 30 30 12 45 23 27 12 0d 04  _SB_.PR00.E#'...
  0c10: 0c ff ff 02 00 00 4c 4e 4b 43 00 12 0d 04 0c ff  ......LNKC......
  0c20: ff 02 00 01 4c 4e 4b 44 00 12 0e 04 0c ff ff 02  ....LNKD........
  0c30: 00 0a 02 4c 4e 4b 41 00 12 0e 04 0c ff ff 02 00  ...LNKA.........
  0c40: 0a 03 4c 4e 4b 42 00 12 0d 04 0c ff ff 03 00 00  ..LNKB..........
  0c50: 4c 4e 4b 44 00 12 0d 04 0c ff ff 03 00 01 4c 4e  LNKD..........LN
  0c60: 4b 41 00 12 0e 04 0c ff ff 03 00 0a 02 4c 4e 4b  KA...........LNK
  0c70: 42 00 12 0e 04 0c ff ff 03 00 0a 03 4c 4e 4b 43  B...........LNKC
  0c80: 00 12 0d 04 0c ff ff 05 00 00 4c 4e 4b 42 00 12  ..........LNKB..
  0c90: 0d 04 0c ff ff 05 00 01 4c 4e 4b 43 00 12 0e 04  ........LNKC....
  0ca0: 0c ff ff 05 00 0a 02 4c 4e 4b 44 00 12 0e 04 0c  .......LNKD.....
  0cb0: ff ff 05 00 0a 03 4c 4e 4b 41 00 12 0d 04 0c ff  ......LNKA......
  0cc0: ff 06 00 00 4c 4e 4b 43 00 12 0d 04 0c ff ff 06  ....LNKC........
  0cd0: 00 01 4c 4e 4b 44 00 12 0e 04 0c ff ff 06 00 0a  ..LNKD..........
  0ce0: 02 4c 4e 4b 41 00 12 0e 04 0c ff ff 06 00 0a 03  .LNKA...........
  0cf0: 4c 4e 4b 42 00 12 0d 04 0c ff ff 07 00 00 4c 4e  LNKB..........LN
  0d00: 4b 44 00 12 0d 04 0c ff ff 07 00 01 4c 4e 4b 41  KD..........LNKA
  0d10: 00 12 0e 04 0c ff ff 07 00 0a 02 4c 4e 4b 42 00  ...........LNKB.
  0d20: 12 0e 04 0c ff ff 07 00 0a 03 4c 4e 4b 43 00 12  ..........LNKC..
  0d30: 0d 04 0c ff ff 09 00 00 4c 4e 4b 42 00 12 0d 04  ........LNKB....
  0d40: 0c ff ff 09 00 01 4c 4e 4b 43 00 12 0e 04 0c ff  ......LNKC......
  0d50: ff 09 00 0a 02 4c 4e 4b 44 00 12 0e 04 0c ff ff  .....LNKD.......
  0d60: 09 00 0a 03 4c 4e 4b 41 00 12 0d 04 0c ff ff 0a  ....LNKA........
  0d70: 00 00 4c 4e 4b 43 00 12 0d 04 0c ff ff 0a 00 01  ..LNKC..........
  0d80: 4c 4e 4b 44 00 12 0e 04 0c ff ff 0a 00 0a 02 4c  LNKD...........L
  0d90: 4e 4b 41 00 12 0e 04 0c ff ff 0a 00 0a 03 4c 4e  NKA...........LN
  0da0: 4b 42 00 12 0d 04 0c ff ff 14 00 00 4c 4e 4b 41  KB..........LNKA
  0db0: 00 12 0d 04 0c ff ff 14 00 01 4c 4e 4b 42 00 12  ..........LNKB..
  0dc0: 0e 04 0c ff ff 14 00 0a 02 4c 4e 4b 43 00 12 0d  .........LNKC...
  0dd0: 04 0c ff ff 12 00 00 4c 4e 4b 43 00 12 0d 04 0c  .......LNKC.....
  0de0: ff ff 12 00 01 4c 4e 4b 42 00 12 0d 04 0c ff ff  .....LNKB.......
  0df0: 13 00 00 4c 4e 4b 43 00 12 0d 04 0c ff ff 13 00  ...LNKC.........
  0e00: 01 4c 4e 4b 42 00 12 0d 04 0c ff ff 16 00 00 4c  .LNKB..........L
  0e10: 4e 4b 43 00 12 0d 04 0c ff ff 16 00 01 4c 4e 4b  NKC..........LNK
  0e20: 42 00 12 0d 04 0c ff ff 11 00 00 4c 4e 4b 44 00  B..........LNKD.
  0e30: 12 0e 04 0c ff ff 14 00 0a 03 4c 4e 4b 44 00 08  ..........LNKD..
  0e40: 41 52 30 30 12 47 1e 27 12 0b 04 0c ff ff 02 00  AR00.G.'........
  0e50: 00 00 0a 12 12 0b 04 0c ff ff 02 00 01 00 0a 13  ................
  0e60: 12 0c 04 0c ff ff 02 00 0a 02 00 0a 10 12 0c 04  ................
  0e70: 0c ff ff 02 00 0a 03 00 0a 11 12 0b 04 0c ff ff  ................
  0e80: 03 00 00 00 0a 13 12 0b 04 0c ff ff 03 00 01 00  ................
  0e90: 0a 10 12 0c 04 0c ff ff 03 00 0a 02 00 0a 11 12  ................
  0ea0: 0c 04 0c ff ff 03 00 0a 03 00 0a 12 12 0b 04 0c  ................
  0eb0: ff ff 05 00 00 00 0a 11 12 0b 04 0c ff ff 05 00  ................
  0ec0: 01 00 0a 12 12 0c 04 0c ff ff 05 00 0a 02 00 0a  ................
  0ed0: 13 12 0c 04 0c ff ff 05 00 0a 03 00 0a 10 12 0b  ................
  0ee0: 04 0c ff ff 06 00 00 00 0a 12 12 0b 04 0c ff ff  ................
  0ef0: 06 00 01 00 0a 13 12 0c 04 0c ff ff 06 00 0a 02  ................
  0f00: 00 0a 10 12 0c 04 0c ff ff 06 00 0a 03 00 0a 11  ................
  0f10: 12 0b 04 0c ff ff 07 00 00 00 0a 13 12 0b 04 0c  ................
  0f20: ff ff 07 00 01 00 0a 10 12 0c 04 0c ff ff 07 00  ................
  0f30: 0a 02 00 0a 11 12 0c 04 0c ff ff 07 00 0a 03 00  ................
  0f40: 0a 12 12 0b 04 0c ff ff 09 00 00 00 0a 11 12 0b  ................
  0f50: 04 0c ff ff 09 00 01 00 0a 12 12 0c 04 0c ff ff  ................
  0f60: 09 00 0a 02 00 0a 13 12 0c 04 0c ff ff 09 00 0a  ................
  0f70: 03 00 0a 10 12 0b 04 0c ff ff 0a 00 00 00 0a 12  ................
  0f80: 12 0b 04 0c ff ff 0a 00 01 00 0a 13 12 0c 04 0c  ................
  0f90: ff ff 0a 00 0a 02 00 0a 10 12 0c 04 0c ff ff 0a  ................
  0fa0: 00 0a 03 00 0a 11 12 0b 04 0c ff ff 14 00 00 00  ................
  0fb0: 0a 10 12 0b 04 0c ff ff 14 00 01 00 0a 11 12 0b  ................
  0fc0: 04 0c ff ff 12 00 00 00 0a 12 12 0b 04 0c ff ff  ................
  0fd0: 12 00 01 00 0a 11 12 0b 04 0c ff ff 13 00 00 00  ................
  0fe0: 0a 12 12 0b 04 0c ff ff 13 00 01 00 0a 11 12 0b  ................
  0ff0: 04 0c ff ff 16 00 00 00 0a 12 12 0b 04 0c ff ff  ................
  1000: 16 00 01 00 0a 11 12 0c 04 0c ff ff 14 00 0a 02  ................
  1010: 00 0a 12 12 0b 04 0c ff ff 11 00 00 00 0a 13 12  ................
  1020: 0c 04 0c ff ff 14 00 0a 03 00 0a 13 08 50 52 30  .............PR0
  1030: 31 12 3c 04 12 0d 04 0c ff ff 05 00 00 4c 4e 4b  1.<..........LNK
  1040: 43 00 12 0d 04 0c ff ff 05 00 01 4c 4e 4b 44 00  C..........LNKD.
  1050: 12 0e 04 0c ff ff 05 00 0a 02 4c 4e 4b 41 00 12  ..........LNKA..
  1060: 0e 04 0c ff ff 05 00 0a 03 4c 4e 4b 42 00 08 41  .........LNKB..A
  1070: 52 30 31 12 34 04 12 0b 04 0c ff ff 05 00 00 00  R01.4...........
  1080: 0a 12 12 0b 04 0c ff ff 05 00 01 00 0a 13 12 0c  ................
  1090: 04 0c ff ff 05 00 0a 02 00 0a 10 12 0c 04 0c ff  ................
  10a0: ff 05 00 0a 03 00 0a 11 08 50 52 30 32 12 34 04  .........PR02.4.
  10b0: 12 0b 04 0b ff ff 00 4c 4e 4b 43 00 12 0b 04 0b  .......LNKC.....
  10c0: ff ff 01 4c 4e 4b 44 00 12 0c 04 0b ff ff 0a 02  ...LNKD.........
  10d0: 4c 4e 4b 41 00 12 0c 04 0b ff ff 0a 03 4c 4e 4b  LNKA.........LNK
  10e0: 42 00 08 41 52 30 32 12 2c 04 12 09 04 0b ff ff  B..AR02.,.......
  10f0: 00 00 0a 12 12 09 04 0b ff ff 01 00 0a 13 12 0a  ................
  1100: 04 0b ff ff 0a 02 00 0a 10 12 0a 04 0b ff ff 0a  ................
  1110: 03 00 0a 11 08 50 52 30 33 12 34 04 12 0b 04 0b  .....PR03.4.....
  1120: ff ff 00 4c 4e 4b 44 00 12 0b 04 0b ff ff 01 4c  ...LNKD........L
  1130: 4e 4b 41 00 12 0c 04 0b ff ff 0a 02 4c 4e 4b 42  NKA.........LNKB
  1140: 00 12 0c 04 0b ff ff 0a 03 4c 4e 4b 43 00 08 41  .........LNKC..A
  1150: 52 30 33 12 2c 04 12 09 04 0b ff ff 00 00 0a 13  R03.,...........
  1160: 12 09 04 0b ff ff 01 00 0a 10 12 0a 04 0b ff ff  ................
  1170: 0a 02 00 0a 11 12 0a 04 0b ff ff 0a 03 00 0a 12  ................
  1180: 08 50 52 30 35 12 34 04 12 0b 04 0b ff ff 00 4c  .PR05.4........L
  1190: 4e 4b 42 00 12 0b 04 0b ff ff 01 4c 4e 4b 43 00  NKB........LNKC.
  11a0: 12 0c 04 0b ff ff 0a 02 4c 4e 4b 44 00 12 0c 04  ........LNKD....
  11b0: 0b ff ff 0a 03 4c 4e 4b 41 00 08 41 52 30 35 12  .....LNKA..AR05.
  11c0: 2c 04 12 09 04 0b ff ff 00 00 0a 11 12 09 04 0b  ,...............
  11d0: ff ff 01 00 0a 12 12 0a 04 0b ff ff 0a 02 00 0a  ................
  11e0: 13 12 0a 04 0b ff ff 0a 03 00 0a 10 08 50 52 30  .............PR0
  11f0: 36 12 34 04 12 0b 04 0b ff ff 00 4c 4e 4b 43 00  6.4........LNKC.
  1200: 12 0b 04 0b ff ff 01 4c 4e 4b 44 00 12 0c 04 0b  .......LNKD.....
  1210: ff ff 0a 02 4c 4e 4b 41 00 12 0c 04 0b ff ff 0a  ....LNKA........
  1220: 03 4c 4e 4b 42 00 08 41 52 30 36 12 2c 04 12 09  .LNKB..AR06.,...
  1230: 04 0b ff ff 00 00 0a 12 12 09 04 0b ff ff 01 00  ................
  1240: 0a 13 12 0a 04 0b ff ff 0a 02 00 0a 10 12 0a 04  ................
  1250: 0b ff ff 0a 03 00 0a 11 08 50 52 30 37 12 34 04  .........PR07.4.
  1260: 12 0b 04 0b ff ff 00 4c 4e 4b 44 00 12 0b 04 0b  .......LNKD.....
  1270: ff ff 01 4c 4e 4b 41 00 12 0c 04 0b ff ff 0a 02  ...LNKA.........
  1280: 4c 4e 4b 42 00 12 0c 04 0b ff ff 0a 03 4c 4e 4b  LNKB.........LNK
  1290: 43 00 08 41 52 30 37 12 2c 04 12 09 04 0b ff ff  C..AR07.,.......
  12a0: 00 00 0a 13 12 09 04 0b ff ff 01 00 0a 10 12 0a  ................
  12b0: 04 0b ff ff 0a 02 00 0a 11 12 0a 04 0b ff ff 0a  ................
  12c0: 03 00 0a 12 08 50 52 30 39 12 34 04 12 0b 04 0b  .....PR09.4.....
  12d0: ff ff 00 4c 4e 4b 42 00 12 0b 04 0b ff ff 01 4c  ...LNKB........L
  12e0: 4e 4b 43 00 12 0c 04 0b ff ff 0a 02 4c 4e 4b 44  NKC.........LNKD
  12f0: 00 12 0c 04 0b ff ff 0a 03 4c 4e 4b 41 00 08 41  .........LNKA..A
  1300: 52 30 39 12 2c 04 12 09 04 0b ff ff 00 00 0a 11  R09.,...........
  1310: 12 09 04 0b ff ff 01 00 0a 12 12 0a 04 0b ff ff  ................
  1320: 0a 02 00 0a 13 12 0a 04 0b ff ff 0a 03 00 0a 10  ................
  1330: 08 50 52 31 41 12 34 04 12 0b 04 0b ff ff 00 4c  .PR1A.4........L
  1340: 4e 4b 43 00 12 0b 04 0b ff ff 01 4c 4e 4b 44 00  NKC........LNKD.
  1350: 12 0c 04 0b ff ff 0a 02 4c 4e 4b 41 00 12 0c 04  ........LNKA....
  1360: 0b ff ff 0a 03 4c 4e 4b 42 00 08 41 52 31 41 12  .....LNKB..AR1A.
  1370: 2c 04 12 09 04 0b ff ff 00 00 0a 12 12 09 04 0b  ,...............
  1380: ff ff 01 00 0a 13 12 0a 04 0b ff ff 0a 02 00 0a  ................
  1390: 10 12 0a 04 0b ff ff 0a 03 00 0a 11 08 50 52 30  .............PR0
  13a0: 43 12 3c 04 12 0d 04 0c ff ff 05 00 00 4c 4e 4b  C.<..........LNK
  13b0: 45 00 12 0d 04 0c ff ff 05 00 01 4c 4e 4b 46 00  E..........LNKF.
  13c0: 12 0e 04 0c ff ff 05 00 0a 02 4c 4e 4b 47 00 12  ..........LNKG..
  13d0: 0e 04 0c ff ff 05 00 0a 03 4c 4e 4b 48 00 08 41  .........LNKH..A
  13e0: 52 30 43 12 34 04 12 0b 04 0c ff ff 05 00 00 00  R0C.4...........
  13f0: 0a 14 12 0b 04 0c ff ff 05 00 01 00 0a 15 12 0c  ................
  1400: 04 0c ff ff 05 00 0a 02 00 0a 16 12 0c 04 0c ff  ................
  1410: ff 05 00 0a 03 00 0a 17 08 50 52 53 41 11 09 0a  .........PRSA...
  1420: 06 23 f8 ce 18 79 00 06 50 52 53 41 50 52 53 42  .#...y..PRSAPRSB
  1430: 06 50 52 53 41 50 52 53 43 08 50 52 53 44 11 09  .PRSAPRSC.PRSD..
  1440: 0a 06 23 78 ce 18 79 00 06 50 52 53 41 50 52 53  ..#x..y..PRSAPRS
  1450: 45 06 50 52 53 41 50 52 53 46 06 50 52 53 41 50  E.PRSAPRSF.PRSAP
  1460: 52 53 47 06 50 52 53 41 50 52 53 48 5b 82 82 bc  RSG.PRSAPRSH[...
  1470: 03 50 43 49 30 08 5f 48 49 44 0c 41 d0 0a 03 08  .PCI0._HID.A....
  1480: 5f 41 44 52 0c 00 00 18 00 14 09 5e 42 4e 30 30  _ADR.......^BN00
  1490: 00 a4 00 14 0b 5f 42 42 4e 00 a4 42 4e 30 30 08  ....._BBN..BN00.
  14a0: 5f 55 49 44 00 14 16 5f 50 52 54 00 a0 0a 50 49  _UID..._PRT...PI
  14b0: 43 4d a4 41 52 30 30 a4 50 52 30 30 14 06 4e 50  CM.AR00.PR00..NP
  14c0: 54 53 01 14 06 4e 57 41 4b 01 5b 82 45 13 52 53  TS...NWAK.[.E.RS
  14d0: 37 38 08 5f 41 44 52 00 5b 80 4e 42 32 5f 02 00  78._ADR.[.NB2_..
  14e0: 0b 00 01 5b 81 2d 4e 42 32 5f 00 00 40 30 4d 49  ...[.-NB2_..@0MI
  14f0: 5f 5f 20 4d 44 5f 5f 20 00 40 16 48 49 5f 5f 20  __ MD__ .@.HI__ 
  1500: 48 44 5f 5f 20 00 40 26 4d 43 49 5f 20 4d 43 44  HD__ .@&MCI_ MCD
  1510: 5f 20 5b 82 4d 0e 42 52 4f 44 08 5f 48 49 44 0c  _ [.M.BROD._HID.
  1520: 41 d0 0c 02 08 5f 55 49 44 0a 14 08 43 52 53 5f  A...._UID...CRS_
  1530: 11 1d 0a 1a 86 09 00 00 00 00 00 00 00 00 00 00  ................
  1540: 86 09 00 00 00 00 00 00 00 00 00 00 79 00 14 42  ............y..B
  1550: 0b 5f 43 52 53 00 8a 43 52 53 5f 0a 04 42 41 53  ._CRS..CRS_..BAS
  1560: 31 8a 43 52 53 5f 0a 08 4c 45 4e 31 8a 43 52 53  1.CRS_..LEN1.CRS
  1570: 5f 0a 10 42 41 53 32 8a 43 52 53 5f 0a 14 4c 45  _..BAS2.CRS_..LE
  1580: 4e 32 70 0a 3c 4d 49 5f 5f 70 4d 44 5f 5f 60 a0  N2p.<MI__pMD__`.
  1590: 2a 7b 60 0a 40 00 70 0a 3a 4d 49 5f 5f 7b 4d 44  *{`.@.p.:MI__{MD
  15a0: 5f 5f 0c 00 ff ff ff 42 41 53 31 79 7b 4d 44 5f  __.....BAS1y{MD_
  15b0: 5f 0a ff 00 0a 17 4c 45 4e 31 70 0a 11 4d 43 49  _.....LEN1p..MCI
  15c0: 5f 70 4d 43 44 5f 61 70 0a 12 4d 43 49 5f 70 4d  _pMCD_ap..MCI_pM
  15d0: 43 44 5f 62 70 0a f0 4d 43 49 5f 70 4d 43 44 5f  CD_bp..MCI_pMCD_
  15e0: 63 a0 1a 93 62 00 a0 15 92 93 63 00 70 61 42 41  c...b.....c.paBA
  15f0: 53 32 70 79 63 0a 14 00 4c 45 4e 32 a4 43 52 53  S2pyc...LEN2.CRS
  1600: 5f 5b 82 4c 1c 50 30 50 31 08 5f 41 44 52 0c 00  _[.L.P0P1._ADR..
  1610: 00 01 00 14 16 5f 50 52 54 00 a0 0a 50 49 43 4d  ....._PRT...PICM
  1620: a4 41 52 30 31 a4 50 52 30 31 5b 82 43 1a 49 47  .AR01.PR01[.C.IG
  1630: 46 58 08 5f 41 44 52 0c 00 00 05 00 14 09 5f 53  FX._ADR......._S
  1640: 54 41 00 a4 0a 0f 5b 80 47 50 58 58 00 0c 95 ef  TA....[.GPXX....
  1650: 0e 00 0b 00 01 5b 81 11 47 50 58 58 00 47 50 43  .....[..GPXX.GPC
  1660: 4d 08 47 50 44 54 48 7f 08 41 54 49 42 11 03 0a  M.GPDTH..ATIB...
  1670: ff 5b 80 53 4d 30 30 01 0a b0 01 5b 81 0b 53 4d  .[.SM00....[..SM
  1680: 30 30 01 53 4d 43 4d 08 14 4b 07 41 54 49 46 0a  00.SMCM..K.ATIF.
  1690: 08 53 55 50 46 00 7d 53 55 50 46 0b 00 20 53 55  .SUPF.}SUPF.. SU
  16a0: 50 46 a0 0b 93 68 0a 0e a4 41 46 30 45 69 a0 0d  PF...h...AF0Ei..
  16b0: 93 68 00 a4 41 46 30 30 53 55 50 46 8b 41 54 49  .h..AF00SUPF.ATI
  16c0: 42 00 53 53 5a 45 8b 41 54 49 42 0a 02 56 45 52  B.SSZE.ATIB..VER
  16d0: 4e 8a 41 54 49 42 0a 04 4e 4d 53 4b 8a 41 54 49  N.ATIB..NMSK.ATI
  16e0: 42 0a 08 53 46 55 4e 70 00 53 53 5a 45 70 00 56  B..SFUNp.SSZEp.V
  16f0: 45 52 4e 70 00 4e 4d 53 4b 70 00 53 46 55 4e a4  ERNp.NMSKp.SFUN.
  1700: 41 54 49 42 14 40 05 41 46 30 30 09 8b 41 54 49  ATIB.@.AF00..ATI
  1710: 42 00 53 53 5a 45 8b 41 54 49 42 0a 02 56 45 52  B.SSZE.ATIB..VER
  1720: 4e 8a 41 54 49 42 0a 04 4e 4d 53 4b 8a 41 54 49  N.ATIB..NMSK.ATI
  1730: 42 0a 08 53 46 55 4e 70 0a 0c 53 53 5a 45 70 01  B..SFUNp..SSZEp.
  1740: 56 45 52 4e 70 00 4e 4d 53 4b 70 68 53 46 55 4e  VERNp.NMSKphSFUN
  1750: a4 41 54 49 42 14 49 07 41 46 30 45 01 5b 80 5e  .ATIB.I.AF0E.[.^
  1760: 47 46 30 30 02 00 0a 40 5b 81 0e 47 46 30 30 00  GF00...@[..GF00.
  1770: 00 40 0c 4d 4d 41 52 20 5b 80 47 46 30 32 00 4d  .@.MMAR [.GF02.M
  1780: 4d 41 52 0b 00 70 5b 81 17 47 46 30 32 03 00 80  MAR..p[..GF02...
  1790: 40 30 44 31 4d 45 01 00 4f 0d 44 31 56 42 01 70  @0D1ME..O.D1VB.p
  17a0: 68 47 50 44 54 70 0a 0e 47 50 43 4d a0 19 93 44  hGPDTp..GPCM...D
  17b0: 31 4d 45 01 a2 08 92 93 44 31 56 42 00 a2 08 92  1ME.....D1VB....
  17c0: 93 44 31 56 42 01 70 0a e5 53 4d 43 4d a4 00 5b  .D1VB.p..SMCM..[
  17d0: 82 36 50 43 45 32 08 5f 41 44 52 0c 00 00 02 00  .6PCE2._ADR.....
  17e0: 14 0f 5f 50 52 57 00 a4 47 50 52 57 0a 18 0a 04  .._PRW..GPRW....
  17f0: 14 16 5f 50 52 54 00 a0 0a 50 49 43 4d a4 41 52  .._PRT...PICM.AR
  1800: 30 32 a4 50 52 30 32 5b 82 36 50 43 45 33 08 5f  02.PR02[.6PCE3._
  1810: 41 44 52 0c 00 00 03 00 14 0f 5f 50 52 57 00 a4  ADR......._PRW..
  1820: 47 50 52 57 0a 18 0a 04 14 16 5f 50 52 54 00 a0  GPRW......_PRT..
  1830: 0a 50 49 43 4d a4 41 52 30 33 a4 50 52 30 33 5b  .PICM.AR03.PR03[
  1840: 82 36 50 43 45 35 08 5f 41 44 52 0c 00 00 05 00  .6PCE5._ADR.....
  1850: 14 0f 5f 50 52 57 00 a4 47 50 52 57 0a 18 0a 04  .._PRW..GPRW....
  1860: 14 16 5f 50 52 54 00 a0 0a 50 49 43 4d a4 41 52  .._PRT...PICM.AR
  1870: 30 35 a4 50 52 30 35 5b 82 36 50 43 45 36 08 5f  05.PR05[.6PCE6._
  1880: 41 44 52 0c 00 00 06 00 14 0f 5f 50 52 57 00 a4  ADR......._PRW..
  1890: 47 50 52 57 0a 18 0a 04 14 16 5f 50 52 54 00 a0  GPRW......_PRT..
  18a0: 0a 50 49 43 4d a4 41 52 30 36 a4 50 52 30 36 5b  .PICM.AR06.PR06[
  18b0: 82 36 50 43 45 37 08 5f 41 44 52 0c 00 00 07 00  .6PCE7._ADR.....
  18c0: 14 0f 5f 50 52 57 00 a4 47 50 52 57 0a 18 0a 04  .._PRW..GPRW....
  18d0: 14 16 5f 50 52 54 00 a0 0a 50 49 43 4d a4 41 52  .._PRT...PICM.AR
  18e0: 30 37 a4 50 52 30 37 5b 82 42 3a 50 43 45 39 08  07.PR07[.B:PCE9.
  18f0: 5f 41 44 52 0c 00 00 09 00 14 0f 5f 50 52 57 00  _ADR......._PRW.
  1900: a4 47 50 52 57 0a 18 0a 04 14 16 5f 50 52 54 00  .GPRW......_PRT.
  1910: a0 0a 50 49 43 4d a4 41 52 30 39 a4 50 52 30 39  ..PICM.AR09.PR09
  1920: 5b 82 49 36 56 54 30 30 08 5f 41 44 52 00 08 52  [.I6VT00._ADR..R
  1930: 45 46 4c 01 08 4d 53 54 4d 0a 08 08 53 53 54 4d  EFL..MSTM...SSTM
  1940: 0a 08 14 32 5f 53 54 41 00 a0 0c 92 93 56 49 44  ...2_STA.....VID
  1950: 5f 0b 06 11 a4 00 a1 1e a0 0c 92 93 44 49 44 5f  _...........DID_
  1960: 0b 15 04 a4 00 a0 0a 93 43 4d 44 52 00 a4 0a 0d  ........CMDR....
  1970: a1 04 a4 0a 0f 14 12 5f 52 45 47 02 a0 0b 93 68  ......._REG....h
  1980: 0a 02 70 69 52 45 46 4c 08 4d 41 54 58 11 03 0a  ..piREFL.MATX...
  1990: 14 8a 4d 41 54 58 00 50 49 4f 4d 8a 4d 41 54 58  ..MATX.PIOM.MATX
  19a0: 0a 04 44 4d 41 4d 8a 4d 41 54 58 0a 08 50 49 4f  ..DMAM.MATX..PIO
  19b0: 53 8a 4d 41 54 58 0a 0c 44 4d 41 53 8a 4d 41 54  S.MATX..DMAS.MAT
  19c0: 58 0a 10 43 48 46 4c 5b 80 45 32 50 52 02 00 0a  X..CHFL[.E2PR...
  19d0: 10 5b 81 15 45 32 50 52 01 56 49 44 5f 10 44 49  .[..E2PR.VID_.DI
  19e0: 44 5f 10 43 4d 44 52 03 5b 82 4c 06 43 48 4e 30  D_.CMDR.[.L.CHN0
  19f0: 08 5f 41 44 52 00 08 5f 53 54 41 0a 0f 14 0b 5f  ._ADR.._STA...._
  1a00: 47 54 4d 00 a4 47 54 4d 5f 14 10 5f 53 54 4d 03  GTM..GTM_.._STM.
  1a10: 70 68 4d 41 54 58 53 54 4d 5f 5b 82 1c 44 52 56  phMATXSTM_[..DRV
  1a20: 30 08 5f 41 44 52 00 14 10 5f 47 54 46 00 a4 47  0._ADR..._GTF..G
  1a30: 54 46 5f 00 4d 53 54 4d 5b 82 1c 44 52 56 31 08  TF_.MSTM[..DRV1.
  1a40: 5f 41 44 52 01 14 10 5f 47 54 46 00 a4 47 54 46  _ADR..._GTF..GTF
  1a50: 5f 01 53 53 54 4d 5b 82 11 43 48 4e 31 08 5f 41  _.SSTM[..CHN1._A
  1a60: 44 52 01 08 5f 53 54 41 00 14 3e 47 54 46 5f 0a  DR.._STA..>GTF_.
  1a70: 70 11 0a 0a 07 03 00 00 00 00 a0 ef 60 8c 60 01  p...........`.`.
  1a80: 4d 4f 44 45 8c 60 0a 05 43 48 53 4c 7b 68 0a 03  MODE.`..CHSL{h..
  1a90: 61 a0 0e 93 7b 61 01 00 01 70 0a b0 43 48 53 4c  a...{a...p..CHSL
  1aa0: 70 69 4d 4f 44 45 a4 60 14 2e 47 54 4d 5f 08 70  piMODE.`..GTM_.p
  1ab0: 0a 78 50 49 4f 4d 70 0a 78 50 49 4f 53 70 0a 0f  .xPIOMp.xPIOSp..
  1ac0: 44 4d 41 4d 70 0a 0f 44 4d 41 53 70 0a 15 43 48  DMAMp..DMASp..CH
  1ad0: 46 4c a4 4d 41 54 58 14 43 1b 53 54 4d 5f 08 a0  FL.MATX.C.STM_..
  1ae0: 05 52 45 46 4c a1 06 a4 4d 41 54 58 a0 49 07 7b  .REFL...MATX.I.{
  1af0: 43 48 46 4c 01 00 a0 0f 93 44 4d 41 4d 0a 78 70  CHFL.....DMAM.xp
  1b00: 0a 40 4d 53 54 4d a0 0f 93 44 4d 41 4d 0a 50 70  .@MSTM...DMAM.Pp
  1b10: 0a 41 4d 53 54 4d a0 0f 93 44 4d 41 4d 0a 3c 70  .AMSTM...DMAM.<p
  1b20: 0a 42 4d 53 54 4d a0 0f 93 44 4d 41 4d 0a 2d 70  .BMSTM...DMAM.-p
  1b30: 0a 43 4d 53 54 4d a0 0f 93 44 4d 41 4d 0a 1e 70  .CMSTM...DMAM..p
  1b40: 0a 44 4d 53 54 4d a0 0f 93 44 4d 41 4d 0a 14 70  .DMSTM...DMAM..p
  1b50: 0a 45 4d 53 54 4d a0 0f 93 44 4d 41 4d 0a 0f 70  .EMSTM...DMAM..p
  1b60: 0a 46 4d 53 54 4d a1 44 05 a0 10 93 50 49 4f 4d  .FMSTM.D....PIOM
  1b70: 0b 58 02 70 0a 08 4d 53 54 4d a0 10 93 50 49 4f  .X.p..MSTM...PIO
  1b80: 4d 0b 7f 01 70 0a 09 4d 53 54 4d a0 0f 93 50 49  M...p..MSTM...PI
  1b90: 4f 4d 0a f0 70 0a 0a 4d 53 54 4d a0 0f 93 50 49  OM..p..MSTM...PI
  1ba0: 4f 4d 0a b4 70 0a 0b 4d 53 54 4d a0 0f 93 50 49  OM..p..MSTM...PI
  1bb0: 4f 4d 0a 78 70 0a 0c 4d 53 54 4d a0 4a 07 7b 43  OM.xp..MSTM.J.{C
  1bc0: 48 46 4c 0a 04 00 a0 0f 93 44 4d 41 53 0a 78 70  HFL......DMAS.xp
  1bd0: 0a 40 53 53 54 4d a0 0f 93 44 4d 41 53 0a 50 70  .@SSTM...DMAS.Pp
  1be0: 0a 41 53 53 54 4d a0 0f 93 44 4d 41 53 0a 3c 70  .ASSTM...DMAS.<p
  1bf0: 0a 42 53 53 54 4d a0 0f 93 44 4d 41 53 0a 2d 70  .BSSTM...DMAS.-p
  1c00: 0a 43 53 53 54 4d a0 0f 93 44 4d 41 53 0a 1e 70  .CSSTM...DMAS..p
  1c10: 0a 44 53 53 54 4d a0 0f 93 44 4d 41 53 0a 14 70  .DSSTM...DMAS..p
  1c20: 0a 45 53 53 54 4d a0 0f 93 44 4d 41 53 0a 0f 70  .ESSTM...DMAS..p
  1c30: 0a 46 53 53 54 4d a1 44 05 a0 10 93 50 49 4f 53  .FSSTM.D....PIOS
  1c40: 0b 58 02 70 0a 08 53 53 54 4d a0 10 93 50 49 4f  .X.p..SSTM...PIO
  1c50: 53 0b 7f 01 70 0a 09 53 53 54 4d a0 0f 93 50 49  S...p..SSTM...PI
  1c60: 4f 53 0a f0 70 0a 0a 53 53 54 4d a0 0f 93 50 49  OS..p..SSTM...PI
  1c70: 4f 53 0a b4 70 0a 0b 53 53 54 4d a0 0f 93 50 49  OS..p..SSTM...PI
  1c80: 4f 53 0a 78 70 0a 0c 53 53 54 4d 5b 82 44 05 50  OS.xp..SSTM[.D.P
  1c90: 43 45 41 08 5f 41 44 52 0c 00 00 0a 00 14 0f 5f  CEA._ADR......._
  1ca0: 50 52 57 00 a4 47 50 52 57 0a 18 0a 04 14 16 5f  PRW..GPRW......_
  1cb0: 50 52 54 00 a0 0a 50 49 43 4d a4 41 52 31 41 a4  PRT...PICM.AR1A.
  1cc0: 50 52 31 41 5b 82 1b 52 4c 41 4e 08 5f 41 44 52  PR1A[..RLAN._ADR
  1cd0: 00 14 0f 5f 50 52 57 00 a4 47 50 52 57 0a 18 0a  ..._PRW..GPRW...
  1ce0: 04 5b 82 4e b8 49 44 45 43 08 5f 41 44 52 0c 01  .[.N.IDEC._ADR..
  1cf0: 00 14 00 08 55 44 4d 54 12 11 08 0a 78 0a 5a 0a  ....UDMT....x.Z.
  1d00: 3c 0a 2d 0a 1e 0a 14 0a 0f 00 08 50 49 4f 54 12  <.-........PIOT.
  1d10: 10 06 0b 58 02 0b 86 01 0b 0e 01 0a b4 0a 78 00  ...X..........x.
  1d20: 08 50 49 54 52 12 0e 06 0a 99 0a 47 0a 34 0a 22  .PITR......G.4."
  1d30: 0a 20 0a 99 08 4d 44 4d 54 12 0a 04 0b e0 01 0a  . ...MDMT.......
  1d40: 96 0a 78 00 08 4d 44 54 52 12 0a 04 0a 77 0a 21  ..x..MDTR....w.!
  1d50: 0a 20 0a ff 08 46 5a 54 46 11 0a 0a 07 00 00 00  . ...FZTF.......
  1d60: 00 00 00 f5 5b 80 49 44 45 5f 02 0a 40 0a 20 5b  ....[.IDE_..@. [
  1d70: 81 48 04 49 44 45 5f 00 50 50 49 54 10 53 50 49  .H.IDE_.PPIT.SPI
  1d80: 54 10 50 4d 44 54 10 53 4d 44 54 10 50 50 49 43  T.PMDT.SMDT.PPIC
  1d90: 08 53 50 49 43 08 50 50 49 4d 08 53 50 49 4d 08  .SPIC.PPIM.SPIM.
  1da0: 00 40 04 50 55 44 43 02 53 55 44 43 02 00 0c 50  .@.PUDC.SUDC...P
  1db0: 55 44 4d 08 53 55 44 4d 08 14 23 47 45 54 54 01  UDM.SUDM..#GETT.
  1dc0: 70 7b 68 0a 0f 00 60 70 7a 68 0a 04 00 61 a4 77  p{h...`pzh...a.w
  1dd0: 0a 1e 72 72 60 01 00 72 61 01 00 00 00 14 46 13  ..rr`..ra.....F.
  1de0: 47 54 4d 5f 01 8c 68 00 50 49 54 31 8c 68 01 50  GTM_..h.PIT1.h.P
  1df0: 49 54 30 8c 68 0a 02 4d 44 54 31 8c 68 0a 03 4d  IT0.h..MDT1.h..M
  1e00: 44 54 30 8c 68 0a 04 50 49 43 58 8c 68 0a 05 55  DT0.h..PICX.h..U
  1e10: 44 43 58 8c 68 0a 06 55 44 4d 58 08 42 55 46 5f  DCX.h..UDMX.BUF_
  1e20: 11 17 0a 14 ff ff ff ff ff ff ff ff ff ff ff ff  ................
  1e30: ff ff ff ff 00 00 00 00 8a 42 55 46 5f 00 50 49  .........BUF_.PI
  1e40: 4f 30 8a 42 55 46 5f 0a 04 44 4d 41 30 8a 42 55  O0.BUF_..DMA0.BU
  1e50: 46 5f 0a 08 50 49 4f 31 8a 42 55 46 5f 0a 0c 44  F_..PIO1.BUF_..D
  1e60: 4d 41 31 8a 42 55 46 5f 0a 10 46 4c 41 47 a0 0d  MA1.BUF_..FLAG..
  1e70: 7b 50 49 43 58 01 00 a4 42 55 46 5f 70 47 45 54  {PICX...BUF_pGET
  1e80: 54 50 49 54 30 50 49 4f 30 70 47 45 54 54 50 49  TPIT0PIO0pGETTPI
  1e90: 54 31 50 49 4f 31 a0 26 7b 55 44 43 58 01 00 7d  T1PIO1.&{UDCX..}
  1ea0: 46 4c 41 47 01 46 4c 41 47 70 83 88 55 44 4d 54  FLAG.FLAGp..UDMT
  1eb0: 7b 55 44 4d 58 0a 0f 00 00 44 4d 41 30 a1 0e 70  {UDMX....DMA0..p
  1ec0: 47 45 54 54 4d 44 54 30 44 4d 41 30 a0 28 7b 55  GETTMDT0DMA0.({U
  1ed0: 44 43 58 0a 02 00 7d 46 4c 41 47 0a 04 46 4c 41  DCX...}FLAG..FLA
  1ee0: 47 70 83 88 55 44 4d 54 7a 55 44 4d 58 0a 04 00  Gp..UDMTzUDMX...
  1ef0: 00 44 4d 41 31 a1 0e 70 47 45 54 54 4d 44 54 31  .DMA1..pGETTMDT1
  1f00: 44 4d 41 31 7d 46 4c 41 47 0a 1a 46 4c 41 47 a4  DMA1}FLAG..FLAG.
  1f10: 42 55 46 5f 14 47 19 53 54 4d 5f 03 8a 68 00 50  BUF_.G.STM_..h.P
  1f20: 49 4f 30 8a 68 0a 04 44 4d 41 30 8a 68 0a 08 50  IO0.h..DMA0.h..P
  1f30: 49 4f 31 8a 68 0a 0c 44 4d 41 31 8a 68 0a 10 46  IO1.h..DMA1.h..F
  1f40: 4c 41 47 08 42 55 46 5f 11 0a 0a 07 00 00 ff ff  LAG.BUF_........
  1f50: 00 00 00 8c 42 55 46 5f 00 50 49 54 31 8c 42 55  ....BUF_.PIT1.BU
  1f60: 46 5f 01 50 49 54 30 8c 42 55 46 5f 0a 02 4d 44  F_.PIT0.BUF_..MD
  1f70: 54 31 8c 42 55 46 5f 0a 03 4d 44 54 30 8c 42 55  T1.BUF_..MDT0.BU
  1f80: 46 5f 0a 04 50 49 4d 58 8c 42 55 46 5f 0a 05 55  F_..PIMX.BUF_..U
  1f90: 44 43 58 8c 42 55 46 5f 0a 06 55 44 4d 58 70 89  DCX.BUF_..UDMXp.
  1fa0: 50 49 4f 54 02 50 49 4f 30 00 00 00 60 78 60 0a  PIOT.PIO0...`x`.
  1fb0: 05 60 00 70 89 50 49 4f 54 02 50 49 4f 31 00 00  .`.p.PIOT.PIO1..
  1fc0: 00 61 78 61 0a 05 61 00 70 7d 79 61 0a 04 00 60  .axa..a.p}ya...`
  1fd0: 00 50 49 4d 58 70 83 88 50 49 54 52 60 00 50 49  .PIMXp..PITR`.PI
  1fe0: 54 30 70 83 88 50 49 54 52 61 00 50 49 54 31 a0  T0p..PITRa.PIT1.
  1ff0: 31 7b 46 4c 41 47 01 00 70 89 55 44 4d 54 02 44  1{FLAG..p.UDMT.D
  2000: 4d 41 30 00 00 00 60 78 60 0a 07 60 00 7d 55 44  MA0...`x`..`.}UD
  2010: 4d 58 60 55 44 4d 58 7d 55 44 43 58 01 55 44 43  MX`UDMX}UDCX.UDC
  2020: 58 a1 26 a0 24 92 93 44 4d 41 30 ff 70 89 4d 44  X.&.$..DMA0.p.MD
  2030: 4d 54 02 44 4d 41 30 00 00 00 60 70 83 88 4d 44  MT.DMA0...`p..MD
  2040: 54 52 60 00 4d 44 54 30 a0 37 7b 46 4c 41 47 0a  TR`.MDT0.7{FLAG.
  2050: 04 00 70 89 55 44 4d 54 02 44 4d 41 31 00 00 00  ..p.UDMT.DMA1...
  2060: 60 78 60 0a 07 60 00 7d 55 44 4d 58 79 60 0a 04  `x`..`.}UDMXy`..
  2070: 00 55 44 4d 58 7d 55 44 43 58 0a 02 55 44 43 58  .UDMX}UDCX..UDCX
  2080: a1 26 a0 24 92 93 44 4d 41 31 ff 70 89 4d 44 4d  .&.$..DMA1.p.MDM
  2090: 54 02 44 4d 41 31 00 00 00 60 70 83 88 4d 44 54  T.DMA1...`p..MDT
  20a0: 52 60 00 4d 44 54 31 a4 42 55 46 5f 14 46 11 47  R`.MDT1.BUF_.F.G
  20b0: 54 46 5f 02 8c 69 00 4d 44 54 31 8c 69 01 4d 44  TF_..i.MDT1.i.MD
  20c0: 54 30 8c 69 0a 02 50 49 4d 58 8c 69 0a 03 55 44  T0.i..PIMX.i..UD
  20d0: 43 58 8c 69 0a 04 55 44 4d 58 a0 26 93 68 0a a0  CX.i..UDMX.&.h..
  20e0: 70 7b 50 49 4d 58 0a 0f 00 60 70 4d 44 54 30 61  p{PIMX...`pMDT0a
  20f0: 7b 55 44 43 58 01 62 70 7b 55 44 4d 58 0a 0f 00  {UDCX.bp{UDMX...
  2100: 63 a1 23 70 7a 50 49 4d 58 0a 04 00 60 70 4d 44  c.#pzPIMX...`pMD
  2110: 54 31 61 7b 55 44 43 58 0a 02 62 70 7a 55 44 4d  T1a{UDCX..bpzUDM
  2120: 58 0a 04 00 63 08 42 55 46 5f 11 18 0a 15 03 00  X...c.BUF_......
  2130: 00 00 00 ff ef 03 00 00 00 00 ff ef 00 00 00 00  ................
  2140: 00 00 f5 8c 42 55 46 5f 01 50 4d 4f 44 8c 42 55  ....BUF_.PMOD.BU
  2150: 46 5f 0a 08 44 4d 4f 44 8c 42 55 46 5f 0a 05 43  F_..DMOD.BUF_..C
  2160: 4d 44 41 8c 42 55 46 5f 0a 0c 43 4d 44 42 8c 42  MDA.BUF_..CMDB.B
  2170: 55 46 5f 0a 13 43 4d 44 43 70 68 43 4d 44 41 70  UF_..CMDCphCMDAp
  2180: 68 43 4d 44 42 70 68 43 4d 44 43 7d 60 0a 08 50  hCMDBphCMDC}`..P
  2190: 4d 4f 44 a0 0a 62 7d 63 0a 40 44 4d 4f 44 a1 1f  MOD..b}c.@DMOD..
  21a0: 70 89 4d 44 4d 54 02 47 45 54 54 61 00 00 00 64  p.MDMT.GETTa...d
  21b0: a0 0d 95 64 0a 03 7d 0a 20 64 44 4d 4f 44 a4 42  ...d..}. dDMOD.B
  21c0: 55 46 5f 5b 82 45 35 50 52 49 44 08 5f 41 44 52  UF_[.E5PRID._ADR
  21d0: 00 14 42 0d 5f 47 54 4d 00 08 42 55 46 5f 11 0a  ..B._GTM..BUF_..
  21e0: 0a 07 00 00 ff ff 00 00 00 8b 42 55 46 5f 00 56  ..........BUF_.V
  21f0: 50 49 54 8b 42 55 46 5f 0a 02 56 4d 44 54 8c 42  PIT.BUF_..VMDT.B
  2200: 55 46 5f 0a 04 56 50 49 43 8c 42 55 46 5f 0a 05  UF_..VPIC.BUF_..
  2210: 56 55 44 43 8c 42 55 46 5f 0a 06 56 55 44 4d a0  VUDC.BUF_..VUDM.
  2220: 4c 04 91 92 95 5e 5e 5e 2e 53 4d 42 53 52 45 56  L....^^^.SMBSREV
  2230: 5f 0a 3a 5e 5e 5e 2e 53 4d 42 53 53 4f 50 54 70  _.:^^^.SMBSSOPTp
  2240: 50 50 49 54 56 50 49 54 70 50 4d 44 54 56 4d 44  PPITVPITpPMDTVMD
  2250: 54 70 50 50 49 43 56 50 49 43 70 50 55 44 43 56  TpPPICVPICpPUDCV
  2260: 55 44 43 70 50 55 44 4d 56 55 44 4d a1 2e 70 53  UDCpPUDMVUDM..pS
  2270: 50 49 54 56 50 49 54 70 53 4d 44 54 56 4d 44 54  PITVPITpSMDTVMDT
  2280: 70 53 50 49 43 56 50 49 43 70 53 55 44 43 56 55  pSPICVPICpSUDCVU
  2290: 44 43 70 53 55 44 4d 56 55 44 4d a4 47 54 4d 5f  DCpSUDMVUDM.GTM_
  22a0: 42 55 46 5f 14 45 0d 5f 53 54 4d 03 08 42 55 46  BUF_.E._STM..BUF
  22b0: 5f 11 0a 0a 07 00 00 00 00 00 00 00 8b 42 55 46  _............BUF
  22c0: 5f 00 56 50 49 54 8b 42 55 46 5f 0a 02 56 4d 44  _.VPIT.BUF_..VMD
  22d0: 54 8c 42 55 46 5f 0a 04 56 50 49 4d 8c 42 55 46  T.BUF_..VPIM.BUF
  22e0: 5f 0a 05 56 55 44 43 8c 42 55 46 5f 0a 06 56 55  _..VUDC.BUF_..VU
  22f0: 44 4d 70 53 54 4d 5f 68 69 6a 42 55 46 5f a0 4c  DMpSTM_hijBUF_.L
  2300: 04 91 92 95 5e 5e 5e 2e 53 4d 42 53 52 45 56 5f  ....^^^.SMBSREV_
  2310: 0a 3a 5e 5e 5e 2e 53 4d 42 53 53 4f 50 54 70 56  .:^^^.SMBSSOPTpV
  2320: 50 49 54 50 50 49 54 70 56 4d 44 54 50 4d 44 54  PITPPITpVMDTPMDT
  2330: 70 56 50 49 4d 50 50 49 4d 70 56 55 44 43 50 55  pVPIMPPIMpVUDCPU
  2340: 44 43 70 56 55 44 4d 50 55 44 4d a1 2e 70 56 50  DCpVUDMPUDM..pVP
  2350: 49 54 53 50 49 54 70 56 4d 44 54 53 4d 44 54 70  ITSPITpVMDTSMDTp
  2360: 56 50 49 4d 53 50 49 4d 70 56 55 44 43 53 55 44  VPIMSPIMpVUDCSUD
  2370: 43 70 56 55 44 4d 53 55 44 4d 5b 82 4e 0c 50 5f  CpVUDMSUDM[.N.P_
  2380: 44 30 08 5f 41 44 52 00 14 41 0c 5f 47 54 46 00  D0._ADR..A._GTF.
  2390: 08 42 55 46 5f 11 08 0a 05 00 00 00 00 00 8b 42  .BUF_..........B
  23a0: 55 46 5f 00 56 4d 44 54 8c 42 55 46 5f 0a 02 56  UF_.VMDT.BUF_..V
  23b0: 50 49 4d 8c 42 55 46 5f 0a 03 56 55 44 43 8c 42  PIM.BUF_..VUDC.B
  23c0: 55 46 5f 0a 04 56 55 44 4d a0 45 04 91 92 95 5e  UF_..VUDM.E....^
  23d0: 5e 5e 5e 2e 53 4d 42 53 52 45 56 5f 0a 3a 5e 5e  ^^^.SMBSREV_.:^^
  23e0: 5e 5e 2e 53 4d 42 53 53 4f 50 54 70 50 4d 44 54  ^^.SMBSSOPTpPMDT
  23f0: 56 4d 44 54 70 50 50 49 4d 56 50 49 4d 70 50 55  VMDTpPPIMVPIMpPU
  2400: 44 43 56 55 44 43 70 50 55 44 4d 56 55 44 4d a1  DCVUDCpPUDMVUDM.
  2410: 25 70 53 4d 44 54 56 4d 44 54 70 53 50 49 4d 56  %pSMDTVMDTpSPIMV
  2420: 50 49 4d 70 53 55 44 43 56 55 44 43 70 53 55 44  PIMpSUDCVUDCpSUD
  2430: 4d 56 55 44 4d 70 11 0a 0a 07 03 46 00 00 00 a0  MVUDMp.....F....
  2440: ef 60 a4 73 60 46 5a 54 46 00 5b 82 4e 0c 50 5f  .`.s`FZTF.[.N.P_
  2450: 44 31 08 5f 41 44 52 01 14 41 0c 5f 47 54 46 00  D1._ADR..A._GTF.
  2460: 08 42 55 46 5f 11 08 0a 05 00 00 00 00 00 8b 42  .BUF_..........B
  2470: 55 46 5f 00 56 4d 44 54 8c 42 55 46 5f 0a 02 56  UF_.VMDT.BUF_..V
  2480: 50 49 4d 8c 42 55 46 5f 0a 03 56 55 44 43 8c 42  PIM.BUF_..VUDC.B
  2490: 55 46 5f 0a 04 56 55 44 4d a0 45 04 91 92 95 5e  UF_..VUDM.E....^
  24a0: 5e 5e 5e 2e 53 4d 42 53 52 45 56 5f 0a 3a 5e 5e  ^^^.SMBSREV_.:^^
  24b0: 5e 5e 2e 53 4d 42 53 53 4f 50 54 70 50 4d 44 54  ^^.SMBSSOPTpPMDT
  24c0: 56 4d 44 54 70 50 50 49 4d 56 50 49 4d 70 50 55  VMDTpPPIMVPIMpPU
  24d0: 44 43 56 55 44 43 70 50 55 44 4d 56 55 44 4d a1  DCVUDCpPUDMVUDM.
  24e0: 25 70 53 4d 44 54 56 4d 44 54 70 53 50 49 4d 56  %pSMDTVMDTpSPIMV
  24f0: 50 49 4d 70 53 55 44 43 56 55 44 43 70 53 55 44  PIMpSUDCVUDCpSUD
  2500: 4d 56 55 44 4d 70 11 0a 0a 07 03 46 00 00 00 a0  MVUDMp.....F....
  2510: ef 60 a4 73 60 46 5a 54 46 00 5b 82 45 35 53 45  .`.s`FZTF.[.E5SE
  2520: 43 44 08 5f 41 44 52 01 14 42 0d 5f 47 54 4d 00  CD._ADR..B._GTM.
  2530: 08 42 55 46 5f 11 0a 0a 07 00 00 ff ff 00 00 00  .BUF_...........
  2540: 8b 42 55 46 5f 00 56 50 49 54 8b 42 55 46 5f 0a  .BUF_.VPIT.BUF_.
  2550: 02 56 4d 44 54 8c 42 55 46 5f 0a 04 56 50 49 43  .VMDT.BUF_..VPIC
  2560: 8c 42 55 46 5f 0a 05 56 55 44 43 8c 42 55 46 5f  .BUF_..VUDC.BUF_
  2570: 0a 06 56 55 44 4d a0 4c 04 91 92 95 5e 5e 5e 2e  ..VUDM.L....^^^.
  2580: 53 4d 42 53 52 45 56 5f 0a 3a 5e 5e 5e 2e 53 4d  SMBSREV_.:^^^.SM
  2590: 42 53 53 4f 50 54 70 53 50 49 54 56 50 49 54 70  BSSOPTpSPITVPITp
  25a0: 53 4d 44 54 56 4d 44 54 70 53 50 49 43 56 50 49  SMDTVMDTpSPICVPI
  25b0: 43 70 53 55 44 43 56 55 44 43 70 53 55 44 4d 56  CpSUDCVUDCpSUDMV
  25c0: 55 44 4d a1 2e 70 50 50 49 54 56 50 49 54 70 50  UDM..pPPITVPITpP
  25d0: 4d 44 54 56 4d 44 54 70 50 50 49 43 56 50 49 43  MDTVMDTpPPICVPIC
  25e0: 70 50 55 44 43 56 55 44 43 70 50 55 44 4d 56 55  pPUDCVUDCpPUDMVU
  25f0: 44 4d a4 47 54 4d 5f 42 55 46 5f 14 45 0d 5f 53  DM.GTM_BUF_.E._S
  2600: 54 4d 03 08 42 55 46 5f 11 0a 0a 07 00 00 00 00  TM..BUF_........
  2610: 00 00 00 8b 42 55 46 5f 00 56 50 49 54 8b 42 55  ....BUF_.VPIT.BU
  2620: 46 5f 0a 02 56 4d 44 54 8c 42 55 46 5f 0a 04 56  F_..VMDT.BUF_..V
  2630: 50 49 4d 8c 42 55 46 5f 0a 05 56 55 44 43 8c 42  PIM.BUF_..VUDC.B
  2640: 55 46 5f 0a 06 56 55 44 4d 70 53 54 4d 5f 68 69  UF_..VUDMpSTM_hi
  2650: 6a 42 55 46 5f a0 4c 04 91 92 95 5e 5e 5e 2e 53  jBUF_.L....^^^.S
  2660: 4d 42 53 52 45 56 5f 0a 3a 5e 5e 5e 2e 53 4d 42  MBSREV_.:^^^.SMB
  2670: 53 53 4f 50 54 70 56 50 49 54 53 50 49 54 70 56  SSOPTpVPITSPITpV
  2680: 4d 44 54 53 4d 44 54 70 56 50 49 4d 53 50 49 4d  MDTSMDTpVPIMSPIM
  2690: 70 56 55 44 43 53 55 44 43 70 56 55 44 4d 53 55  pVUDCSUDCpVUDMSU
  26a0: 44 4d a1 2e 70 56 50 49 54 50 50 49 54 70 56 4d  DM..pVPITPPITpVM
  26b0: 44 54 50 4d 44 54 70 56 50 49 4d 50 50 49 4d 70  DTPMDTpVPIMPPIMp
  26c0: 56 55 44 43 50 55 44 43 70 56 55 44 4d 50 55 44  VUDCPUDCpVUDMPUD
  26d0: 4d 5b 82 4e 0c 53 5f 44 30 08 5f 41 44 52 00 14  M[.N.S_D0._ADR..
  26e0: 41 0c 5f 47 54 46 00 08 42 55 46 5f 11 08 0a 05  A._GTF..BUF_....
  26f0: 00 00 00 00 00 8b 42 55 46 5f 00 56 4d 44 54 8c  ......BUF_.VMDT.
  2700: 42 55 46 5f 0a 02 56 50 49 4d 8c 42 55 46 5f 0a  BUF_..VPIM.BUF_.
  2710: 03 56 55 44 43 8c 42 55 46 5f 0a 04 56 55 44 4d  .VUDC.BUF_..VUDM
  2720: a0 45 04 91 92 95 5e 5e 5e 5e 2e 53 4d 42 53 52  .E....^^^^.SMBSR
  2730: 45 56 5f 0a 3a 5e 5e 5e 5e 2e 53 4d 42 53 53 4f  EV_.:^^^^.SMBSSO
  2740: 50 54 70 53 4d 44 54 56 4d 44 54 70 53 50 49 4d  PTpSMDTVMDTpSPIM
  2750: 56 50 49 4d 70 53 55 44 43 56 55 44 43 70 53 55  VPIMpSUDCVUDCpSU
  2760: 44 4d 56 55 44 4d a1 25 70 50 4d 44 54 56 4d 44  DMVUDM.%pPMDTVMD
  2770: 54 70 50 50 49 4d 56 50 49 4d 70 50 55 44 43 56  TpPPIMVPIMpPUDCV
  2780: 55 44 43 70 50 55 44 4d 56 55 44 4d 70 11 0a 0a  UDCpPUDMVUDMp...
  2790: 07 03 46 00 00 00 a0 ef 60 a4 73 60 46 5a 54 46  ..F.....`.s`FZTF
  27a0: 00 5b 82 4e 0c 53 5f 44 31 08 5f 41 44 52 01 14  .[.N.S_D1._ADR..
  27b0: 41 0c 5f 47 54 46 00 08 42 55 46 5f 11 08 0a 05  A._GTF..BUF_....
  27c0: 00 00 00 00 00 8b 42 55 46 5f 00 56 4d 44 54 8c  ......BUF_.VMDT.
  27d0: 42 55 46 5f 0a 02 56 50 49 4d 8c 42 55 46 5f 0a  BUF_..VPIM.BUF_.
  27e0: 03 56 55 44 43 8c 42 55 46 5f 0a 04 56 55 44 4d  .VUDC.BUF_..VUDM
  27f0: a0 45 04 91 92 95 5e 5e 5e 5e 2e 53 4d 42 53 52  .E....^^^^.SMBSR
  2800: 45 56 5f 0a 3a 5e 5e 5e 5e 2e 53 4d 42 53 53 4f  EV_.:^^^^.SMBSSO
  2810: 50 54 70 53 4d 44 54 56 4d 44 54 70 53 50 49 4d  PTpSMDTVMDTpSPIM
  2820: 56 50 49 4d 70 53 55 44 43 56 55 44 43 70 53 55  VPIMpSUDCVUDCpSU
  2830: 44 4d 56 55 44 4d a1 25 70 50 4d 44 54 56 4d 44  DMVUDM.%pPMDTVMD
  2840: 54 70 50 50 49 4d 56 50 49 4d 70 50 55 44 43 56  TpPPIMVPIMpPUDCV
  2850: 55 44 43 70 50 55 44 4d 56 55 44 4d 70 11 0a 0a  UDCpPUDMVUDMp...
  2860: 07 03 46 00 00 00 a0 ef 60 a4 73 60 46 5a 54 46  ..F.....`.s`FZTF
  2870: 00 5b 82 45 04 53 42 41 5a 08 5f 41 44 52 0c 02  .[.E.SBAZ._ADR..
  2880: 00 14 00 5b 80 50 43 49 5f 02 00 0b 00 01 5b 81  ...[.PCI_.....[.
  2890: 18 50 43 49 5f 00 00 40 21 44 4e 53 50 01 44 4e  .PCI_..@!DNSP.DN
  28a0: 53 4f 01 45 4e 53 52 01 14 0f 5f 50 52 57 00 a4  SO.ENSR..._PRW..
  28b0: 47 50 52 57 0a 1b 0a 04 5b 82 36 50 30 50 43 08  GPRW....[.6P0PC.
  28c0: 5f 41 44 52 0c 04 00 14 00 14 0f 5f 50 52 57 00  _ADR......._PRW.
  28d0: a4 47 50 52 57 0a 04 0a 04 14 16 5f 50 52 54 00  .GPRW......_PRT.
  28e0: a0 0a 50 49 43 4d a4 41 52 30 43 a4 50 52 30 43  ..PICM.AR0C.PR0C
  28f0: 5b 82 1f 47 45 43 5f 08 5f 41 44 52 0c 06 00 14  [..GEC_._ADR....
  2900: 00 14 0f 5f 50 52 57 00 a4 47 50 52 57 0a 13 0a  ..._PRW..GPRW...
  2910: 04 5b 82 1f 55 48 43 31 08 5f 41 44 52 0c 00 00  .[..UHC1._ADR...
  2920: 12 00 14 0f 5f 50 52 57 00 a4 47 50 52 57 0a 0b  ...._PRW..GPRW..
  2930: 0a 04 5b 82 1f 55 48 43 32 08 5f 41 44 52 0c 02  ..[..UHC2._ADR..
  2940: 00 12 00 14 0f 5f 50 52 57 00 a4 47 50 52 57 0a  ....._PRW..GPRW.
  2950: 0b 0a 04 5b 82 1f 55 53 42 33 08 5f 41 44 52 0c  ...[..USB3._ADR.
  2960: 00 00 13 00 14 0f 5f 50 52 57 00 a4 47 50 52 57  ......_PRW..GPRW
  2970: 0a 0b 0a 04 5b 82 1f 55 48 43 34 08 5f 41 44 52  ....[..UHC4._ADR
  2980: 0c 02 00 13 00 14 0f 5f 50 52 57 00 a4 47 50 52  ......._PRW..GPR
  2990: 57 0a 0b 0a 04 5b 82 1f 55 53 42 35 08 5f 41 44  W....[..USB5._AD
  29a0: 52 0c 00 00 16 00 14 0f 5f 50 52 57 00 a4 47 50  R......._PRW..GP
  29b0: 52 57 0a 0b 0a 04 5b 82 1f 55 48 43 36 08 5f 41  RW....[..UHC6._A
  29c0: 44 52 0c 02 00 16 00 14 0f 5f 50 52 57 00 a4 47  DR......._PRW..G
  29d0: 50 52 57 0a 0b 0a 04 5b 82 1f 55 48 43 37 08 5f  PRW....[..UHC7._
  29e0: 41 44 52 0c 05 00 14 00 14 0f 5f 50 52 57 00 a4  ADR......._PRW..
  29f0: 47 50 52 57 0a 0b 0a 04 5b 82 4e 4c 53 41 54 41  GPRW....[.NLSATA
  2a00: 08 5f 41 44 52 0c 00 00 11 00 a0 4d 4b 93 53 54  ._ADR......MK.ST
  2a10: 43 4c 0b 01 01 14 06 5f 49 4e 49 00 5b 80 53 41  CL....._INI.[.SA
  2a20: 43 53 02 00 0a 40 5b 81 0e 53 41 43 53 00 00 40  CS...@[..SACS..@
  2a30: 12 53 54 42 35 20 08 53 50 54 4d 11 17 0a 14 78  .STB5 .SPTM....x
  2a40: 00 00 00 0f 00 00 00 78 00 00 00 0f 00 00 00 1f  .......x........
  2a50: 00 00 00 5b 82 4a 23 50 52 49 44 08 5f 41 44 52  ...[.J#PRID._ADR
  2a60: 00 14 0b 5f 47 54 4d 00 a4 53 50 54 4d 14 06 5f  ..._GTM..SPTM.._
  2a70: 53 54 4d 03 08 50 52 49 53 00 14 4e 09 5f 50 53  STM..PRIS..N._PS
  2a80: 30 00 5b 80 42 41 52 5f 00 53 54 42 35 0b 00 04  0.[.BAR_.STB5...
  2a90: 5b 81 3b 42 41 52 5f 00 00 40 90 00 07 50 4d 42  [.;BAR_..@...PMB
  2aa0: 59 01 00 38 50 4d 53 30 04 00 04 50 4d 53 31 04  Y..8PMS0...PMS1.
  2ab0: 00 44 7b 00 07 50 53 42 59 01 00 38 50 53 53 30  .D{..PSBY..8PSS0
  2ac0: 04 00 04 50 53 53 31 04 00 44 3b 00 07 a0 45 04  ...PSS1..D;...E.
  2ad0: 91 93 4f 53 54 59 0a 06 93 4f 53 54 59 0a 04 a0  ..OSTY...OSTY...
  2ae0: 19 50 4d 53 31 70 0a 32 60 a2 0f 90 93 50 4d 42  .PMS1p.2`....PMB
  2af0: 59 01 60 5b 22 0a fa 76 60 a0 19 50 53 53 31 70  Y.`["..v`..PSS1p
  2b00: 0a 32 60 a2 0f 90 93 50 53 42 59 01 60 5b 22 0a  .2`....PSBY.`[".
  2b10: fa 76 60 70 00 50 52 49 53 14 0d 5f 50 53 33 00  .v`p.PRIS.._PS3.
  2b20: 70 0a 03 50 52 49 53 14 0b 5f 50 53 43 00 a4 50  p..PRIS.._PSC..P
  2b30: 52 49 53 5b 82 4b 0a 50 5f 44 30 08 5f 41 44 52  RIS[.K.P_D0._ADR
  2b40: 00 14 3c 5f 53 54 41 00 5b 80 42 41 52 5f 00 53  ..<_STA.[.BAR_.S
  2b50: 54 42 35 0b 00 04 5b 81 15 42 41 52 5f 00 00 40  TB5...[..BAR_..@
  2b60: 94 50 4d 53 30 04 00 04 50 4d 53 31 04 a0 0c 80  .PMS0...PMS1....
  2b70: 93 50 4d 53 31 00 00 a4 0a 0f a1 03 a4 00 08 53  .PMS1..........S
  2b80: 31 32 50 00 14 41 04 5f 50 53 30 00 5b 80 42 41  12P..A._PS0.[.BA
  2b90: 52 5f 00 53 54 42 35 0b 00 04 5b 81 10 42 41 52  R_.STB5...[..BAR
  2ba0: 5f 00 00 40 90 00 07 50 4d 42 59 01 70 0a 32 60  _..@...PMBY.p.2`
  2bb0: a2 0f 90 93 50 4d 42 59 01 60 5b 22 0a fa 76 60  ....PMBY.`["..v`
  2bc0: 70 00 53 31 32 50 14 0d 5f 50 53 33 00 70 0a 03  p.S12P.._PS3.p..
  2bd0: 53 31 32 50 14 0b 5f 50 53 43 00 a4 53 31 32 50  S12P.._PSC..S12P
  2be0: 5b 82 4d 0a 50 5f 44 31 08 5f 41 44 52 01 14 3d  [.M.P_D1._ADR..=
  2bf0: 5f 53 54 41 00 5b 80 42 41 52 5f 00 53 54 42 35  _STA.[.BAR_.STB5
  2c00: 0b 00 04 5b 81 16 42 41 52 5f 00 00 80 14 01 50  ...[..BAR_.....P
  2c10: 53 53 30 04 00 04 50 53 53 31 04 a0 0c 80 93 50  SS0...PSS1.....P
  2c20: 53 53 31 00 00 a4 0a 0f a1 03 a4 00 08 53 31 32  SS1..........S12
  2c30: 50 00 14 42 04 5f 50 53 30 00 5b 80 42 41 52 5f  P..B._PS0.[.BAR_
  2c40: 00 53 54 42 35 0b 00 04 5b 81 11 42 41 52 5f 00  .STB5...[..BAR_.
  2c50: 00 80 10 01 00 07 50 53 42 59 01 70 0a 32 60 a2  ......PSBY.p.2`.
  2c60: 0f 90 93 50 53 42 59 01 60 5b 22 0a fa 76 60 70  ...PSBY.`["..v`p
  2c70: 00 53 31 32 50 14 0d 5f 50 53 33 00 70 0a 03 53  .S12P.._PS3.p..S
  2c80: 31 32 50 14 0b 5f 50 53 43 00 a4 53 31 32 50 5b  12P.._PSC..S12P[
  2c90: 82 47 23 53 45 43 44 08 5f 41 44 52 01 14 0b 5f  .G#SECD._ADR..._
  2ca0: 47 54 4d 00 a4 53 50 54 4d 14 06 5f 53 54 4d 03  GTM..SPTM.._STM.
  2cb0: 08 53 45 43 53 00 14 4b 09 5f 50 53 30 00 5b 80  .SECS..K._PS0.[.
  2cc0: 42 41 52 5f 00 53 54 42 35 0b 00 04 5b 81 38 42  BAR_.STB5...[.8B
  2cd0: 41 52 5f 00 00 40 d0 00 07 53 4d 42 59 01 00 38  AR_..@...SMBY..8
  2ce0: 53 4d 53 30 04 00 04 53 4d 53 31 04 00 44 7b 00  SMS0...SMS1..D{.
  2cf0: 07 53 53 42 59 01 00 38 53 53 53 30 04 00 04 53  .SSBY..8SSS0...S
  2d00: 53 53 31 04 00 14 a0 45 04 91 93 4f 53 54 59 0a  SS1....E...OSTY.
  2d10: 06 93 4f 53 54 59 0a 04 a0 19 53 4d 53 31 70 0a  ..OSTY....SMS1p.
  2d20: 32 60 a2 0f 90 93 53 4d 42 59 01 60 5b 22 0a fa  2`....SMBY.`["..
  2d30: 76 60 a0 19 53 53 53 31 70 0a 32 60 a2 0f 90 93  v`..SSS1p.2`....
  2d40: 53 53 42 59 01 60 5b 22 0a fa 76 60 70 00 53 45  SSBY.`["..v`p.SE
  2d50: 43 53 14 0d 5f 50 53 33 00 70 0a 03 53 45 43 53  CS.._PS3.p..SECS
  2d60: 14 0b 5f 50 53 43 00 a4 53 45 43 53 5b 82 4b 0a  .._PSC..SECS[.K.
  2d70: 53 5f 44 30 08 5f 41 44 52 00 14 3c 5f 53 54 41  S_D0._ADR..<_STA
  2d80: 00 5b 80 42 41 52 5f 00 53 54 42 35 0b 00 04 5b  .[.BAR_.STB5...[
  2d90: 81 15 42 41 52 5f 00 00 40 d4 53 4d 53 30 04 00  ..BAR_..@.SMS0..
  2da0: 04 53 4d 53 31 04 a0 0c 80 93 53 4d 53 31 00 00  .SMS1.....SMS1..
  2db0: a4 0a 0f a1 03 a4 00 08 53 31 32 50 00 14 41 04  ........S12P..A.
  2dc0: 5f 50 53 30 00 5b 80 42 41 52 5f 00 53 54 42 35  _PS0.[.BAR_.STB5
  2dd0: 0b 00 10 5b 81 10 42 41 52 5f 00 00 40 d0 00 07  ...[..BAR_..@...
  2de0: 53 4d 42 59 01 70 0a 32 60 a2 0f 90 93 53 4d 42  SMBY.p.2`....SMB
  2df0: 59 01 60 5b 22 0a fa 76 60 70 00 53 31 32 50 14  Y.`["..v`p.S12P.
  2e00: 0d 5f 50 53 33 00 70 0a 03 53 31 32 50 14 0b 5f  ._PS3.p..S12P.._
  2e10: 50 53 43 00 a4 53 31 32 50 5b 82 4d 0a 53 5f 44  PSC..S12P[.M.S_D
  2e20: 31 08 5f 41 44 52 01 14 3d 5f 53 54 41 00 5b 80  1._ADR..=_STA.[.
  2e30: 42 41 52 5f 00 53 54 42 35 0b 00 04 5b 81 16 42  BAR_.STB5...[..B
  2e40: 41 52 5f 00 00 80 54 01 53 53 53 30 04 00 04 53  AR_...T.SSS0...S
  2e50: 53 53 31 04 a0 0c 80 93 53 53 53 31 00 00 a4 0a  SS1.....SSS1....
  2e60: 0f a1 03 a4 00 08 53 31 32 50 00 14 42 04 5f 50  ......S12P..B._P
  2e70: 53 30 00 5b 80 42 41 52 5f 00 53 54 42 35 0b 00  S0.[.BAR_.STB5..
  2e80: 04 5b 81 11 42 41 52 5f 00 00 80 50 01 00 07 53  .[..BAR_...P...S
  2e90: 53 42 59 01 70 0a 32 60 a2 0f 90 93 53 53 42 59  SBY.p.2`....SSBY
  2ea0: 01 60 5b 22 0a fa 76 60 70 00 53 31 32 50 14 0d  .`["..v`p.S12P..
  2eb0: 5f 50 53 33 00 70 0a 03 53 31 32 50 14 0b 5f 50  _PS3.p..S12P.._P
  2ec0: 53 43 00 a4 53 31 32 50 5b 82 4b 05 53 4d 42 53  SC..S12P[.K.SMBS
  2ed0: 08 5f 41 44 52 0c 00 00 14 00 5b 80 53 4d 42 53  ._ADR.....[.SMBS
  2ee0: 02 00 0b 00 01 5b 81 22 53 4d 42 53 00 00 40 04  .....[."SMBS..@.
  2ef0: 52 45 56 5f 08 00 48 2c 49 31 46 5f 01 49 31 32  REV_..H,I1F_.I12
  2f00: 46 01 00 02 4d 54 33 41 01 5b 80 57 49 44 45 02  F...MT3A.[.WIDE.
  2f10: 0a ad 01 5b 81 10 57 49 44 45 00 44 55 4d 31 04  ...[..WIDE.DUM1.
  2f20: 53 4f 50 54 01 5b 82 89 10 02 53 42 52 47 08 5f  SOPT.[....SBRG._
  2f30: 41 44 52 0c 03 00 14 00 5b 82 2b 50 49 43 5f 08  ADR.....[.+PIC_.
  2f40: 5f 48 49 44 0b 41 d0 08 5f 43 52 53 11 18 0a 15  _HID.A.._CRS....
  2f50: 47 01 20 00 20 00 00 02 47 01 a0 00 a0 00 00 02  G. . ...G.......
  2f60: 22 04 00 79 00 5b 82 4e 04 44 4d 41 44 08 5f 48  "..y.[.N.DMAD._H
  2f70: 49 44 0c 41 d0 02 00 08 5f 43 52 53 11 38 0a 35  ID.A...._CRS.8.5
  2f80: 2a 10 04 47 01 00 00 00 00 00 10 47 01 81 00 81  *..G.......G....
  2f90: 00 00 03 47 01 87 00 87 00 00 01 47 01 89 00 89  ...G.......G....
  2fa0: 00 00 03 47 01 8f 00 8f 00 00 01 47 01 c0 00 c0  ...G.......G....
  2fb0: 00 00 20 79 00 5b 82 25 54 4d 52 5f 08 5f 48 49  .. y.[.%TMR_._HI
  2fc0: 44 0c 41 d0 01 00 08 5f 43 52 53 11 10 0a 0d 47  D.A...._CRS....G
  2fd0: 01 40 00 40 00 00 04 22 01 00 79 00 5b 82 25 52  .@.@..."..y.[.%R
  2fe0: 54 43 30 08 5f 48 49 44 0c 41 d0 0b 00 08 5f 43  TC0._HID.A...._C
  2ff0: 52 53 11 10 0a 0d 47 01 70 00 70 00 00 02 22 00  RS....G.p.p...".
  3000: 01 79 00 5b 82 22 53 50 4b 52 08 5f 48 49 44 0c  .y.[."SPKR._HID.
  3010: 41 d0 08 00 08 5f 43 52 53 11 0d 0a 0a 47 01 61  A...._CRS....G.a
  3020: 00 61 00 00 01 79 00 5b 82 25 43 4f 50 52 08 5f  .a...y.[.%COPR._
  3030: 48 49 44 0c 41 d0 0c 04 08 5f 43 52 53 11 10 0a  HID.A...._CRS...
  3040: 0d 47 01 f0 00 f0 00 00 10 22 00 20 79 00 5b 82  .G.......". y.[.
  3050: 46 62 45 43 30 5f 08 5f 48 49 44 0c 41 d0 0c 09  FbEC0_._HID.A...
  3060: 08 5f 43 52 53 11 15 0a 12 47 01 62 00 62 00 00  ._CRS....G.b.b..
  3070: 01 47 01 66 00 66 00 00 01 79 00 8b 5f 43 52 53  .G.f.f...y.._CRS
  3080: 0a 02 44 50 52 54 8b 5f 43 52 53 0a 0a 43 50 52  ..DPRT._CRS..CPR
  3090: 54 08 5f 47 50 45 0a 0a 08 52 45 47 43 00 14 12  T._GPE...REGC...
  30a0: 5f 52 45 47 02 a0 0b 93 68 0a 03 70 69 52 45 47  _REG....h..piREG
  30b0: 43 14 23 45 43 41 56 00 a0 17 93 52 45 47 43 ff  C.#ECAV....REGC.
  30c0: a0 0b 92 95 5f 52 45 56 0a 02 a4 01 a1 03 a4 00  ...._REV........
  30d0: a4 52 45 47 43 5b 01 4d 55 45 43 00 5b 80 44 4c  .REGC[.MUEC.[.DL
  30e0: 59 50 01 0a e1 01 5b 81 0b 44 4c 59 50 01 44 45  YP....[..DLYP.DE
  30f0: 4c 59 08 5b 80 45 43 4f 52 03 00 0a ff 5b 81 4f  LY.[.ECOR....[.O
  3100: 0c 45 43 4f 52 11 53 42 30 30 08 53 42 30 31 08  .ECOR.SB00.SB01.
  3110: 53 42 30 32 08 53 42 30 33 08 53 42 30 34 08 53  SB02.SB03.SB04.S
  3120: 42 30 35 08 53 42 30 36 08 53 42 30 37 08 53 42  B05.SB06.SB07.SB
  3130: 30 38 08 53 42 30 39 08 53 42 31 30 08 53 42 31  08.SB09.SB10.SB1
  3140: 31 08 53 42 31 32 08 53 42 31 33 08 53 42 31 34  1.SB12.SB13.SB14
  3150: 08 53 42 31 35 08 53 42 31 36 08 53 42 31 37 08  .SB15.SB16.SB17.
  3160: 53 42 31 38 08 53 42 31 39 08 53 42 32 30 08 53  SB18.SB19.SB20.S
  3170: 42 32 31 08 53 42 32 32 08 53 42 32 33 08 53 42  B21.SB22.SB23.SB
  3180: 32 34 08 53 42 32 35 08 53 42 32 36 08 53 42 32  24.SB25.SB26.SB2
  3190: 37 08 53 42 32 38 08 53 42 32 39 08 53 42 33 30  7.SB28.SB29.SB30
  31a0: 08 53 42 33 31 08 53 42 33 32 08 53 42 33 33 08  .SB31.SB32.SB33.
  31b0: 53 42 33 34 08 53 42 33 35 08 53 42 33 36 08 53  SB34.SB35.SB36.S
  31c0: 42 33 37 08 53 42 33 38 08 53 42 34 30 08 5b 81  B37.SB38.SB40.[.
  31d0: 0d 45 43 4f 52 11 00 20 53 42 57 30 10 5b 81 41  .ECOR.. SBW0.[.A
  31e0: 04 45 43 4f 52 11 00 48 14 44 41 30 53 08 44 41  .ECOR..H.DA0S.DA
  31f0: 31 53 08 44 41 32 53 08 44 41 33 53 08 44 41 30  1S.DA2S.DA3S.DA0
  3200: 43 08 44 41 31 43 08 44 41 32 43 08 44 41 33 43  C.DA1C.DA2C.DA3C
  3210: 08 4f 56 47 43 08 56 54 54 43 08 4f 56 47 53 08  .OVGC.VTTC.OVGS.
  3220: 5b 81 46 04 45 43 4f 52 11 00 48 1c 41 44 30 30  [.F.ECOR..H.AD00
  3230: 08 41 44 30 31 08 41 44 30 32 08 41 44 30 33 08  .AD01.AD02.AD03.
  3240: 41 44 30 34 08 41 44 30 35 08 41 44 30 36 08 41  AD04.AD05.AD06.A
  3250: 44 30 37 08 41 44 30 38 08 41 44 30 39 08 41 44  D07.AD08.AD09.AD
  3260: 31 30 08 41 44 31 31 08 5b 81 42 0d 45 43 4f 52  10.AD11.[.B.ECOR
  3270: 11 00 48 4d 45 4c 30 4d 08 45 4c 30 4e 08 45 4c  ..HMEL0M.EL0N.EL
  3280: 30 50 08 45 4c 30 43 08 45 4c 30 44 08 45 4c 30  0P.EL0C.EL0D.EL0
  3290: 58 08 45 4c 30 4c 08 45 4c 30 53 08 45 55 54 30  X.EL0L.EL0S.EUT0
  32a0: 08 45 4c 54 30 08 45 4c 31 4d 08 45 4c 31 4e 08  .ELT0.EL1M.EL1N.
  32b0: 45 4c 31 50 08 45 4c 31 43 08 45 4c 31 44 08 45  EL1P.EL1C.EL1D.E
  32c0: 4c 31 58 08 45 4c 31 4c 08 45 4c 31 53 08 45 55  L1X.EL1L.EL1S.EU
  32d0: 54 31 08 45 4c 54 31 08 45 4c 32 4d 08 45 4c 32  T1.ELT1.EL2M.EL2
  32e0: 4e 08 45 4c 32 50 08 45 4c 32 43 08 45 4c 32 44  N.EL2P.EL2C.EL2D
  32f0: 08 45 4c 32 58 08 45 4c 32 4c 08 45 4c 32 53 08  .EL2X.EL2L.EL2S.
  3300: 45 55 54 32 08 45 4c 54 32 08 45 4c 33 4d 08 45  EUT2.ELT2.EL3M.E
  3310: 4c 33 4e 08 45 4c 33 50 08 45 4c 33 43 08 45 4c  L3N.EL3P.EL3C.EL
  3320: 33 44 08 45 4c 33 58 08 45 4c 33 4c 08 45 4c 33  3D.EL3X.EL3L.EL3
  3330: 53 08 45 55 54 33 08 45 4c 54 33 08 5b 81 4d 05  S.EUT3.ELT3.[.M.
  3340: 45 43 4f 52 11 00 40 68 00 08 00 06 46 57 55 50  ECOR..@h....FWUP
  3350: 01 46 57 46 41 01 53 43 49 45 01 53 4d 49 45 01  .FWFA.SCIE.SMIE.
  3360: 53 43 52 45 01 45 50 55 45 01 48 57 4d 45 01 43  SCRE.EPUE.HWME.C
  3370: 52 54 43 01 52 43 45 4e 01 50 54 4d 45 01 00 02  RTC.RCEN.PTME...
  3380: 45 50 55 52 01 00 03 54 55 42 4f 01 52 45 50 55  EPUR...TUBO.REPU
  3390: 01 46 47 41 4d 01 46 47 4e 45 01 5b 81 20 45 43  .FGAM.FGNE.[. EC
  33a0: 4f 52 11 00 48 62 45 42 49 44 08 00 40 05 46 47  OR..HbEBID..@.FG
  33b0: 50 30 08 46 47 50 31 08 46 47 50 32 08 5b 81 33  P0.FGP1.FGP2.[.3
  33c0: 45 43 4f 52 11 00 48 48 45 50 55 4d 08 52 43 4c  ECOR..HHEPUM.RCL
  33d0: 45 08 00 08 46 41 53 4e 08 43 52 43 45 08 48 4d  E...FASN.CRCE.HM
  33e0: 49 52 08 48 4d 44 52 08 48 4d 52 57 08 48 4d 42  IR.HMDR.HMRW.HMB
  33f0: 4b 08 5b 81 27 45 43 4f 52 11 00 48 3e 45 43 57  K.[.'ECOR..H>ECW
  3400: 54 08 00 08 00 08 45 43 41 54 08 00 08 00 08 00  T.....ECAT......
  3410: 08 54 56 4d 30 08 54 56 4d 32 08 5b 81 1d 45 43  .TVM0.TVM2.[..EC
  3420: 4f 52 11 00 40 7a 45 43 46 34 08 45 43 46 35 08  OR..@zECF4.ECF5.
  3430: 45 43 46 36 08 45 43 46 37 08 5b 80 49 4f 5f 5f  ECF6.ECF7.[.IO__
  3440: 01 44 50 52 54 0a 05 5b 81 12 49 4f 5f 5f 11 45  .DPRT..[..IO__.E
  3450: 43 44 41 08 00 18 45 43 4d 44 08 5b 81 30 49 4f  CDA...ECMD.[.0IO
  3460: 5f 5f 11 00 20 4f 42 46 53 01 49 42 46 53 01 49  __.. OBFS.IBFS.I
  3470: 47 4e 30 01 43 4d 44 53 01 42 52 53 54 01 53 43  GN0.CMDS.BRST.SC
  3480: 49 53 01 53 4d 49 53 01 49 47 4e 31 01 14 0d 5f  IS.SMIS.IGN1..._
  3490: 51 38 30 00 86 41 53 4f 43 0a 0b 14 0d 5f 51 38  Q80..ASOC...._Q8
  34a0: 31 00 86 41 53 4f 43 0a 0d 14 0d 5f 51 38 32 00  1..ASOC...._Q82.
  34b0: 86 41 53 4f 43 0a 0c 14 0d 5f 51 38 33 00 86 41  .ASOC...._Q83..A
  34c0: 53 4f 43 0a 0c 14 1b 5f 51 38 34 00 70 0a 03 5e  SOC...._Q84.p..^
  34d0: 5e 2e 41 53 4f 43 43 41 4d 4c 86 41 53 4f 43 0a  ^.ASOCCAML.ASOC.
  34e0: 05 14 1a 5f 51 38 35 00 70 01 5e 5e 2e 41 53 4f  ..._Q85.p.^^.ASO
  34f0: 43 43 41 4d 4c 86 41 53 4f 43 0a 05 14 0d 5f 51  CCAML.ASOC...._Q
  3500: 38 36 00 86 41 53 4f 43 0a 86 14 0d 5f 51 38 37  86..ASOC...._Q87
  3510: 00 86 41 53 4f 43 0a 87 14 0d 5f 51 39 30 00 86  ..ASOC...._Q90..
  3520: 41 53 4f 43 0a 90 14 0d 5f 51 39 31 00 86 41 53  ASOC...._Q91..AS
  3530: 4f 43 0a 91 14 0d 5f 51 39 32 00 86 41 53 4f 43  OC...._Q92..ASOC
  3540: 0a 92 14 0d 5f 51 39 33 00 86 41 53 4f 43 0a 93  ...._Q93..ASOC..
  3550: 14 0d 5f 51 39 34 00 86 41 53 4f 43 0a 94 14 0d  .._Q94..ASOC....
  3560: 5f 51 39 35 00 86 41 53 4f 43 0a 95 14 0d 5f 51  _Q95..ASOC...._Q
  3570: 39 36 00 86 41 53 4f 43 0a 96 14 4a 07 45 43 42  96..ASOC...J.ECB
  3580: 52 02 a0 42 07 45 43 41 56 a0 4b 06 92 5b 23 4d  R..B.ECAV.K..[#M
  3590: 55 45 43 ff ff 70 00 53 42 30 31 70 68 53 42 30  UEC..p.SB01phSB0
  35a0: 32 70 69 53 42 30 33 70 0a 07 53 42 30 30 70 0b  2piSB03p..SB00p.
  35b0: e8 03 60 a2 36 60 76 60 70 53 42 30 31 61 a0 2b  ..`.6`v`pSB01a.+
  35c0: 93 7b 61 0a 80 00 0a 80 7b 61 0a 1a 62 a0 16 91  .{a.....{a..b...
  35d0: 93 62 0a 1a 93 62 0a 18 5b 27 4d 55 45 43 45 43  .b...b..['MUECEC
  35e0: 42 52 68 69 a0 05 93 62 00 a5 5b 27 4d 55 45 43  BRhi...b..['MUEC
  35f0: a4 53 42 30 34 14 49 07 45 43 42 57 03 a0 41 07  .SB04.I.ECBW..A.
  3600: 45 43 41 56 a0 4a 06 92 5b 23 4d 55 45 43 ff ff  ECAV.J..[#MUEC..
  3610: 70 00 53 42 30 31 70 68 53 42 30 32 70 69 53 42  p.SB01phSB02piSB
  3620: 30 33 70 6a 53 42 30 34 70 0a 06 53 42 30 30 70  03pjSB04p..SB00p
  3630: 0b e8 03 60 a2 32 60 76 60 70 53 42 30 31 61 a0  ...`.2`v`pSB01a.
  3640: 27 93 7b 61 0a 80 00 0a 80 7b 61 0a 1a 62 a0 12  '.{a.....{a..b..
  3650: 91 93 62 0a 1a 93 62 0a 18 5b 27 4d 55 45 43 a4  ..b...b..['MUEC.
  3660: 00 a0 05 93 62 00 a5 5b 27 4d 55 45 43 a4 01 14  ....b..['MUEC...
  3670: 06 52 46 45 43 01 5b 82 4a 17 4c 50 54 45 14 1c  .RFEC.[.J.LPTE..
  3680: 5f 48 49 44 00 a0 0d 4c 50 54 4d 0a 02 a4 0c 41  _HID...LPTM....A
  3690: d0 04 01 a1 07 a4 0c 41 d0 04 00 14 0d 5f 53 54  .......A....._ST
  36a0: 41 00 a4 44 53 54 41 0a 02 14 0d 5f 44 49 53 00  A..DSTA...._DIS.
  36b0: 44 43 4e 54 0a 02 00 14 4e 06 5f 43 52 53 00 44  DCNT....N._CRS.D
  36c0: 43 52 53 0a 02 01 a0 48 05 4c 50 54 4d 0a 02 70  CRS....H.LPTM..p
  36d0: 49 52 51 4d 49 52 51 45 70 44 4d 41 4d 44 4d 41  IRQMIRQEpDMAMDMA
  36e0: 45 70 49 4f 31 31 49 4f 32 31 70 49 4f 31 32 49  EpIO11IO21pIO12I
  36f0: 4f 32 32 70 4c 45 4e 31 4c 45 4e 32 72 49 4f 32  O22pLEN1LEN2rIO2
  3700: 31 0b 00 04 49 4f 33 31 70 49 4f 33 31 49 4f 33  1...IO31pIO31IO3
  3710: 32 70 4c 45 4e 32 4c 45 4e 33 a4 43 52 53 32 a1  2pLEN2LEN3.CRS2.
  3720: 06 a4 43 52 53 31 14 0d 5f 53 52 53 01 44 53 52  ..CRS1.._SRS.DSR
  3730: 53 68 0a 02 14 1a 5f 50 52 53 00 a0 0c 4c 50 54  Sh...._PRS...LPT
  3740: 4d 0a 02 a4 45 50 50 52 a1 06 a4 4c 50 50 52 08  M...EPPR...LPPR.
  3750: 4c 50 50 52 11 33 0a 30 30 47 01 78 03 78 03 01  LPPR.3.00G.x.x..
  3760: 08 22 f8 1c 2a 00 00 30 47 01 78 02 78 02 01 08  ."..*..0G.x.x...
  3770: 22 f8 1c 2a 00 00 30 47 01 bc 03 bc 03 01 04 22  "..*..0G......."
  3780: f8 1c 2a 00 00 38 79 00 08 45 50 50 52 11 44 06  ..*..8y..EPPR.D.
  3790: 0a 60 31 00 47 01 78 03 78 03 01 08 47 01 78 07  .`1.G.x.x...G.x.
  37a0: 78 07 01 08 22 80 00 2a 08 00 30 47 01 78 03 78  x..."..*..0G.x.x
  37b0: 03 01 08 47 01 78 07 78 07 01 08 22 f8 1c 2a 0f  ...G.x.x..."..*.
  37c0: 00 30 47 01 78 02 78 02 01 08 47 01 78 06 78 06  .0G.x.x...G.x.x.
  37d0: 01 08 22 f8 1c 2a 0f 00 30 47 01 bc 03 bc 03 01  .."..*..0G......
  37e0: 04 47 01 bc 07 bc 07 01 04 22 f8 1c 2a 0f 00 38  .G......."..*..8
  37f0: 79 00 10 46 22 5c 00 5b 80 52 41 4d 57 00 0c 00  y..F"\.[.RAMW...
  3800: 00 ff cf 0c 00 00 01 00 5b 81 1a 52 41 4d 57 01  ........[..RAMW.
  3810: 50 41 52 30 20 50 41 52 31 20 50 41 52 32 20 50  PAR0 PAR1 PAR2 P
  3820: 49 4e 58 20 5b 80 49 4f 42 32 01 0a b0 0a 02 5b  INX [.IOB2.....[
  3830: 81 10 49 4f 42 32 01 53 4d 49 43 08 53 4d 49 53  ..IOB2.SMIC.SMIS
  3840: 08 14 0f 49 53 4d 49 09 70 68 53 4d 49 43 5b 22  ...ISMI.phSMIC["
  3850: 01 14 21 47 4e 56 53 09 70 0c 00 00 00 80 50 49  ..!GNVS.p.....PI
  3860: 4e 58 70 68 50 41 52 30 49 53 4d 49 0a 70 a4 50  NXphPAR0ISMI.p.P
  3870: 41 52 31 14 22 53 4e 56 53 0a 70 0c 01 00 00 80  AR1."SNVS.p.....
  3880: 50 49 4e 58 70 68 50 41 52 30 70 69 50 41 52 31  PINXphPAR0piPAR1
  3890: 49 53 4d 49 0a 70 08 41 52 42 46 11 03 0a 10 8a  ISMI.p.ARBF.....
  38a0: 41 52 42 46 00 52 45 41 58 8a 41 52 42 46 0a 04  ARBF.REAX.ARBF..
  38b0: 52 45 42 58 8a 41 52 42 46 0a 08 52 45 43 58 8a  REBX.ARBF..RECX.
  38c0: 41 52 42 46 0a 0c 52 45 44 58 14 41 05 53 4d 53  ARBF..REDX.A.SMS
  38d0: 52 09 8a 68 00 41 45 41 58 8a 68 0a 04 41 45 42  R..h.AEAX.h..AEB
  38e0: 58 8a 68 0a 08 41 45 43 58 8a 68 0a 0c 41 45 44  X.h..AECX.h..AED
  38f0: 58 70 0c 03 00 00 80 50 49 4e 58 70 41 45 43 58  Xp.....PINXpAECX
  3900: 50 41 52 30 70 41 45 41 58 50 41 52 31 70 41 45  PAR0pAEAXPAR1pAE
  3910: 44 58 50 41 52 32 49 53 4d 49 0a 70 14 39 47 4d  DXPAR2ISMI.p.9GM
  3920: 53 52 09 70 0c 02 00 00 80 50 49 4e 58 70 68 50  SR.p.....PINXphP
  3930: 41 52 30 49 53 4d 49 0a 70 70 68 52 45 43 58 70  AR0ISMI.pphRECXp
  3940: 50 41 52 31 52 45 41 58 70 50 41 52 32 52 45 44  PAR1REAXpPAR2RED
  3950: 58 a4 41 52 42 46 14 33 50 52 49 44 09 70 0c 04  X.ARBF.3PRID.p..
  3960: 00 00 80 50 49 4e 58 70 68 50 41 52 30 49 53 4d  ...PINXphPAR0ISM
  3970: 49 0a 70 70 50 41 52 31 52 45 41 58 70 50 41 52  I.ppPAR1REAXpPAR
  3980: 32 52 45 44 58 a4 41 52 42 46 14 21 47 45 43 52  2REDX.ARBF.!GECR
  3990: 09 70 0c 05 00 00 80 50 49 4e 58 70 68 50 41 52  .p.....PINXphPAR
  39a0: 30 49 53 4d 49 0a 70 a4 50 41 52 31 14 22 53 41  0ISMI.p.PAR1."SA
  39b0: 47 50 0a 70 0c 07 00 00 80 50 49 4e 58 70 68 50  GP.p.....PINXphP
  39c0: 41 52 30 70 69 50 41 52 31 49 53 4d 49 0a 70 14  AR0piPAR1ISMI.p.
  39d0: 21 47 41 47 50 09 70 0c 08 00 00 80 50 49 4e 58  !GAGP.p.....PINX
  39e0: 70 68 50 41 52 30 49 53 4d 49 0a 70 a4 50 41 52  phPAR0ISMI.p.PAR
  39f0: 31 14 27 47 54 42 46 0a 70 0c 09 00 00 80 50 49  1.'GTBF.p.....PI
  3a00: 4e 58 70 68 50 41 52 30 70 69 50 41 52 31 49 53  NXphPAR0piPAR1IS
  3a10: 4d 49 0a 70 a4 50 41 52 31 10 40 47 5c 2f 03 5f  MI.p.PAR1.@G\/._
  3a20: 53 42 5f 50 43 49 30 53 42 52 47 5b 82 4d 45 41  SB_PCI0SBRG[.MEA
  3a30: 53 4f 43 08 5f 48 49 44 0d 41 54 4b 30 31 31 30  SOC._HID.ATK0110
  3a40: 00 08 5f 55 49 44 0c 10 01 01 01 14 09 5f 53 54  .._UID......._ST
  3a50: 41 00 a4 0a 0f 14 12 5f 49 4e 49 00 47 33 55 50  A......_INI.G3UP
  3a60: 47 36 55 50 43 55 50 49 14 19 43 55 50 49 00 70  G6UPCUPI..CUPI.p
  3a70: 47 41 47 50 0d 43 50 55 4e 00 88 47 33 44 53 0a  GAGP.CPUN..G3DS.
  3a80: 06 00 08 4d 42 49 46 12 27 08 0a 03 0d 4d 34 41  ...MBIF.'....M4A
  3a90: 38 38 54 44 2d 4d 2d 55 53 42 33 00 0c 03 02 01  88TD-M-USB3.....
  3aa0: 04 0c 00 01 00 03 0c 01 00 01 e0 0a 02 00 00 08  ................
  3ab0: 41 53 42 46 11 04 0b 00 02 8a 41 53 42 46 00 41  ASBF......ASBF.A
  3ac0: 53 42 30 8a 41 53 42 46 0a 04 41 53 42 31 8a 41  SB0.ASBF..ASB1.A
  3ad0: 53 42 46 0a 08 41 53 42 32 8a 41 53 42 46 0a 0c  SBF..ASB2.ASBF..
  3ae0: 41 53 42 33 8a 41 53 42 46 0a 10 41 53 42 34 8a  ASB3.ASBF..ASB4.
  3af0: 41 53 42 46 0a 14 41 53 42 35 8a 41 53 42 46 0a  ASBF..ASB5.ASBF.
  3b00: 18 41 53 42 36 14 48 0c 47 47 52 50 09 08 54 54  .ASB6.H.GGRP..TT
  3b10: 54 30 00 70 68 54 54 54 30 a0 0c 93 54 54 54 30  T0.phTTT0...TTT0
  3b20: 00 a4 47 52 50 30 a1 47 0a a0 0d 93 54 54 54 30  ..GRP0.G....TTT0
  3b30: 0a 03 a4 47 52 50 33 a1 46 09 a0 0d 93 54 54 54  ...GRP3.F....TTT
  3b40: 30 0a 04 a4 47 52 50 34 a1 45 08 a0 0d 93 54 54  0...GRP4.E....TT
  3b50: 54 30 0a 05 a4 47 52 50 35 a1 44 07 a0 0d 93 54  T0...GRP5.D....T
  3b60: 54 54 30 0a 06 a4 47 52 50 36 a1 43 06 a0 0a 93  TT0...GRP6.C....
  3b70: 54 54 54 30 0a 08 a4 00 a1 45 05 a0 0d 93 54 54  TTT0.....E....TT
  3b80: 54 30 0a 09 a4 47 52 50 39 a1 44 04 a0 0d 93 54  T0...GRP9.D....T
  3b90: 54 54 30 0a 0b a4 47 52 50 42 a1 33 a0 0d 93 54  TT0...GRPB.3...T
  3ba0: 54 54 30 0a 0e a4 47 52 50 45 a1 23 a0 0d 93 54  TT0...GRPE.#...T
  3bb0: 54 54 30 0a 0f a4 47 52 50 46 a1 13 a0 0d 93 54  TT0...GRPF.....T
  3bc0: 54 54 30 0a 11 a4 47 52 31 31 a1 03 a4 00 14 44  TT0...GR11.....D
  3bd0: 14 47 49 54 4d 09 8a 68 00 50 52 4d 30 8c 68 0a  .GITM..h.PRM0.h.
  3be0: 03 47 50 49 44 70 01 41 53 42 30 08 54 54 54 30  .GPIDp.ASB0.TTT0
  3bf0: 00 70 47 50 49 44 54 54 54 30 a0 0f 93 54 54 54  .pGPIDTTT0...TTT
  3c00: 30 00 47 49 54 30 50 52 4d 30 a1 43 10 a0 10 93  0.GIT0PRM0.C....
  3c10: 54 54 54 30 0a 03 47 49 54 33 50 52 4d 30 a1 4f  TTT0..GIT3PRM0.O
  3c20: 0e a0 10 93 54 54 54 30 0a 04 47 49 54 34 50 52  ....TTT0..GIT4PR
  3c30: 4d 30 a1 4b 0d a0 1c 93 54 54 54 30 0a 05 8a 68  M0.K....TTT0...h
  3c40: 0a 04 50 52 4d 31 47 49 54 35 50 52 4d 30 50 52  ..PRM1GIT5PRM0PR
  3c50: 4d 31 a1 4b 0b a0 10 93 54 54 54 30 0a 06 47 49  M1.K....TTT0..GI
  3c60: 54 36 50 52 4d 30 a1 47 0a a0 10 93 54 54 54 30  T6PRM0.G....TTT0
  3c70: 0a 08 47 49 54 38 50 52 4d 30 a1 43 09 a0 10 93  ..GIT8PRM0.C....
  3c80: 54 54 54 30 0a 09 47 49 54 39 50 52 4d 30 a1 4f  TTT0..GIT9PRM0.O
  3c90: 07 a0 10 93 54 54 54 30 0a 0b 47 49 54 42 50 52  ....TTT0..GITBPR
  3ca0: 4d 30 a1 4b 06 a0 10 93 54 54 54 30 0a 0e 47 49  M0.K....TTT0..GI
  3cb0: 54 45 50 52 4d 30 a1 47 05 a0 10 93 54 54 54 30  TEPRM0.G....TTT0
  3cc0: 0a 0f 47 49 54 46 50 52 4d 30 a1 43 04 a0 38 93  ..GITFPRM0.C..8.
  3cd0: 54 54 54 30 0a 11 8a 68 0a 04 50 52 31 31 a0 19  TTT0...h..PR11..
  3ce0: 93 7b 50 52 4d 30 0b ff ff 00 0a 09 47 54 31 31  .{PRM0......GT11
  3cf0: 50 52 4d 30 50 52 31 31 a1 0d 70 00 60 47 54 31  PRM0PR11..p.`GT1
  3d00: 31 50 52 4d 30 60 a1 07 70 00 41 53 42 30 a4 41  1PRM0`..p.ASB0.A
  3d10: 53 42 46 14 46 17 53 49 54 4d 09 8a 68 00 50 52  SBF.F.SITM..h.PR
  3d20: 4d 30 8a 68 0a 04 50 52 4d 31 8a 68 0a 08 50 52  M0.h..PRM1.h..PR
  3d30: 4d 32 8c 68 0a 03 47 50 49 44 70 01 41 53 42 30  M2.h..GPIDp.ASB0
  3d40: 08 54 54 54 30 00 70 47 50 49 44 54 54 54 30 a0  .TTT0.pGPIDTTT0.
  3d50: 17 93 54 54 54 30 00 53 49 54 30 50 52 4d 30 50  ..TTT0.SIT0PRM0P
  3d60: 52 4d 31 50 52 4d 32 a1 4d 11 a0 18 93 54 54 54  RM1PRM2.M....TTT
  3d70: 30 0a 03 53 49 54 33 50 52 4d 30 50 52 4d 31 50  0..SIT3PRM0PRM1P
  3d80: 52 4d 32 a1 41 10 a0 18 93 54 54 54 30 0a 04 53  RM2.A....TTT0..S
  3d90: 49 54 34 50 52 4d 30 50 52 4d 31 50 52 4d 32 a1  IT4PRM0PRM1PRM2.
  3da0: 45 0e a0 18 93 54 54 54 30 0a 05 53 49 54 35 50  E....TTT0..SIT5P
  3db0: 52 4d 30 50 52 4d 31 50 52 4d 32 a1 49 0c a0 18  RM0PRM1PRM2.I...
  3dc0: 93 54 54 54 30 0a 06 53 49 54 36 50 52 4d 30 50  .TTT0..SIT6PRM0P
  3dd0: 52 4d 31 50 52 4d 32 a1 4d 0a a0 18 93 54 54 54  RM1PRM2.M....TTT
  3de0: 30 0a 08 53 49 54 38 50 52 4d 30 50 52 4d 31 50  0..SIT8PRM0PRM1P
  3df0: 52 4d 32 a1 41 09 a0 18 93 54 54 54 30 0a 09 53  RM2.A....TTT0..S
  3e00: 49 54 39 50 52 4d 30 50 52 4d 31 50 52 4d 32 a1  IT9PRM0PRM1PRM2.
  3e10: 45 07 a0 18 93 54 54 54 30 0a 0b 53 49 54 42 50  E....TTT0..SITBP
  3e20: 52 4d 30 50 52 4d 31 50 52 4d 32 a1 49 05 a0 18  RM0PRM1PRM2.I...
  3e30: 93 54 54 54 30 0a 0e 53 49 54 45 50 52 4d 30 50  .TTT0..SITEPRM0P
  3e40: 52 4d 31 50 52 4d 32 a1 3d a0 18 93 54 54 54 30  RM1PRM2.=...TTT0
  3e50: 0a 0f 53 49 54 46 50 52 4d 30 50 52 4d 31 50 52  ..SITFPRM0PRM1PR
  3e60: 4d 32 a1 22 a0 18 93 54 54 54 30 0a 11 53 54 31  M2."...TTT0..ST1
  3e70: 31 50 52 4d 30 50 52 4d 31 50 52 4d 32 a1 07 70  1PRM0PRM1PRM2..p
  3e80: 00 41 53 42 30 a4 41 53 42 46 5b 82 42 05 48 50  .ASB0.ASBF[.B.HP
  3e90: 45 54 08 5f 48 49 44 0c 41 d0 01 03 08 43 52 53  ET._HID.A....CRS
  3ea0: 5f 11 11 0a 0e 86 09 00 00 00 00 d0 fe 00 04 00  _...............
  3eb0: 00 79 00 14 09 5f 53 54 41 00 a4 0a 0f 14 20 5f  .y..._STA..... _
  3ec0: 43 52 53 00 8a 43 52 53 5f 0a 04 48 50 54 5f 70  CRS..CRS_..HPT_p
  3ed0: 0c 00 00 d0 fe 48 50 54 5f a4 43 52 53 5f 5b 82  .....HPT_.CRS_[.
  3ee0: 43 06 5e 50 43 49 45 08 5f 48 49 44 0c 41 d0 0c  C.^PCIE._HID.A..
  3ef0: 02 08 5f 55 49 44 0a 11 08 43 52 53 5f 11 11 0a  .._UID...CRS_...
  3f00: 0e 86 09 00 00 00 00 00 e0 00 00 00 10 79 00 14  .............y..
  3f10: 33 5f 43 52 53 00 8a 43 52 53 5f 0a 04 42 41 53  3_CRS..CRS_..BAS
  3f20: 31 8a 43 52 53 5f 0a 08 4c 45 4e 31 70 50 43 49  1.CRS_..LEN1pPCI
  3f30: 42 42 41 53 31 70 50 43 49 4c 4c 45 4e 31 a4 43  BBAS1pPCILLEN1.C
  3f40: 52 53 5f 5b 82 49 07 50 53 32 4d 08 5f 48 49 44  RS_[.I.PS2M._HID
  3f50: 0c 41 d0 0f 03 08 5f 43 49 44 0c 41 d0 0f 13 14  .A...._CID.A....
  3f60: 19 5f 53 54 41 00 79 01 0a 0c 60 a0 0b 7b 49 4f  ._STA.y...`..{IO
  3f70: 53 54 60 00 a4 0a 0f a4 00 08 4d 32 52 30 11 08  ST`.......M2R0..
  3f80: 0a 05 22 00 10 79 00 08 4d 32 52 31 11 10 0a 0d  .."..y..M2R1....
  3f90: 4b 60 00 01 4b 64 00 01 22 00 10 79 00 14 20 5f  K`..Kd.."..y.. _
  3fa0: 43 52 53 00 79 01 0a 0a 60 a0 0d 7b 49 4f 53 54  CRS.y...`..{IOST
  3fb0: 60 00 a4 4d 32 52 30 a1 06 a4 4d 32 52 31 14 14  `..M2R0...M2R1..
  3fc0: 2e 50 53 32 4d 5f 50 52 57 00 a4 47 50 52 57 0a  .PS2M_PRW..GPRW.
  3fd0: 03 0a 04 5b 82 42 05 50 53 32 4b 08 5f 48 49 44  ...[.B.PS2K._HID
  3fe0: 0c 41 d0 03 03 08 5f 43 49 44 0c 41 d0 03 0b 14  .A...._CID.A....
  3ff0: 19 5f 53 54 41 00 79 01 0a 0a 60 a0 0b 7b 49 4f  ._STA.y...`..{IO
  4000: 53 54 60 00 a4 0a 0f a4 00 08 5f 43 52 53 11 18  ST`......._CRS..
  4010: 0a 15 47 01 60 00 60 00 00 01 47 01 64 00 64 00  ..G.`.`...G.d.d.
  4020: 00 01 22 02 00 79 00 14 14 2e 50 53 32 4b 5f 50  .."..y....PS2K_P
  4030: 52 57 00 a4 47 50 52 57 0a 03 0a 04 5b 82 4f 0e  RW..GPRW....[.O.
  4040: 55 41 52 31 08 5f 55 49 44 01 14 0c 5f 48 49 44  UAR1._UID..._HID
  4050: 00 a4 55 48 49 44 00 14 0c 5f 53 54 41 00 a4 44  ..UHID..._STA..D
  4060: 53 54 41 00 14 0c 5f 44 49 53 00 44 43 4e 54 00  STA..._DIS.DCNT.
  4070: 00 14 0d 5f 43 52 53 00 a4 44 43 52 53 00 01 14  ..._CRS..DCRS...
  4080: 0c 5f 53 52 53 01 44 53 52 53 68 00 14 0b 5f 50  ._SRS.DSRSh..._P
  4090: 52 53 00 a4 43 4d 50 52 08 43 4d 50 52 11 4f 08  RS..CMPR.CMPR.O.
  40a0: 0a 8b 31 00 47 01 f8 03 f8 03 01 08 22 10 00 2a  ..1.G......."..*
  40b0: 00 00 30 47 01 f8 03 f8 03 01 08 22 f8 1c 2a 00  ..0G......."..*.
  40c0: 00 30 47 01 f8 02 f8 02 01 08 22 f8 1c 2a 00 00  .0G......."..*..
  40d0: 30 47 01 e8 03 e8 03 01 08 22 f8 1c 2a 00 00 30  0G......."..*..0
  40e0: 47 01 e8 02 e8 02 01 08 22 f8 1c 2a 00 00 30 47  G......."..*..0G
  40f0: 01 f8 03 f8 03 01 08 22 f8 1c 2a 0f 00 30 47 01  ......."..*..0G.
  4100: f8 02 f8 02 01 08 22 f8 1c 2a 0f 00 30 47 01 e8  ......"..*..0G..
  4110: 03 e8 03 01 08 22 f8 1c 2a 0f 00 30 47 01 e8 02  ....."..*..0G...
  4120: e8 02 01 08 22 f8 1c 2a 0f 00 38 79 00 14 14 2e  ...."..*..8y....
  4130: 55 41 52 31 5f 50 52 57 00 a4 47 50 52 57 0a 16  UAR1_PRW..GPRW..
  4140: 0a 04 5b 82 4e 12 4f 4d 53 43 08 5f 48 49 44 0c  ..[.N.OMSC._HID.
  4150: 41 d0 0c 02 08 5f 55 49 44 00 08 43 52 53 5f 11  A...._UID..CRS_.
  4160: 1d 0a 1a 86 09 00 00 00 00 00 00 00 00 00 00 86  ................
  4170: 09 00 00 00 00 00 00 00 00 00 00 79 00 08 43 52  ...........y..CR
  4180: 53 31 11 25 0a 22 4b 60 00 01 4b 64 00 01 86 09  S1.%."K`..Kd....
  4190: 00 00 00 00 00 00 00 00 00 00 86 09 00 00 00 00  ................
  41a0: 00 00 00 00 00 00 79 00 14 49 0c 5f 43 52 53 00  ......y..I._CRS.
  41b0: a0 46 0a 41 50 49 43 8a 43 52 53 5f 0a 08 4d 4c  .F.APIC.CRS_..ML
  41c0: 30 31 8a 43 52 53 5f 0a 04 4d 42 30 31 8a 43 52  01.CRS_..MB01.CR
  41d0: 53 5f 0a 14 4d 4c 30 32 8a 43 52 53 5f 0a 10 4d  S_..ML02.CRS_..M
  41e0: 42 30 32 70 0c 00 00 c0 fe 4d 42 30 31 70 0b 00  B02p.....MB01p..
  41f0: 10 4d 4c 30 31 70 0c 00 00 e0 fe 4d 42 30 32 70  .ML01p.....MB02p
  4200: 0b 00 10 4d 4c 30 32 8a 43 52 53 31 0a 10 4d 4c  ...ML02.CRS1..ML
  4210: 30 33 8a 43 52 53 31 0a 0c 4d 42 30 33 8a 43 52  03.CRS1..MB03.CR
  4220: 53 31 0a 1c 4d 4c 30 34 8a 43 52 53 31 0a 18 4d  S1..ML04.CRS1..M
  4230: 42 30 34 70 0c 00 00 c0 fe 4d 42 30 33 70 0b 00  B04p.....MB03p..
  4240: 10 4d 4c 30 33 70 0c 00 00 e0 fe 4d 42 30 34 70  .ML03p.....MB04p
  4250: 0b 00 10 4d 4c 30 34 79 0a 05 0a 0a 60 a0 0d 7b  ...ML04y....`..{
  4260: 49 4f 53 54 60 00 a4 43 52 53 5f a1 06 a4 43 52  IOST`..CRS_...CR
  4270: 53 31 5b 82 43 14 5e 5e 52 4d 45 4d 08 5f 48 49  S1[.C.^^RMEM._HI
  4280: 44 0c 41 d0 0c 01 08 5f 55 49 44 01 08 43 52 53  D.A...._UID..CRS
  4290: 5f 11 42 04 0a 3e 86 09 00 01 00 00 00 00 00 00  _.B..>..........
  42a0: 0a 00 86 09 00 00 00 00 00 00 00 00 00 00 86 09  ................
  42b0: 00 00 00 00 0e 00 00 00 02 00 86 09 00 01 00 00  ................
  42c0: 10 00 00 00 00 00 86 09 00 00 00 00 00 00 00 00  ................
  42d0: 00 00 79 00 14 42 0e 5f 43 52 53 00 8a 43 52 53  ..y..B._CRS..CRS
  42e0: 5f 0a 10 42 41 53 31 8a 43 52 53 5f 0a 14 4c 45  _..BAS1.CRS_..LE
  42f0: 4e 31 8a 43 52 53 5f 0a 1c 42 41 53 32 8a 43 52  N1.CRS_..BAS2.CR
  4300: 53 5f 0a 20 4c 45 4e 32 8a 43 52 53 5f 0a 2c 4c  S_. LEN2.CRS_.,L
  4310: 45 4e 33 8a 43 52 53 5f 0a 34 42 41 53 34 8a 43  EN3.CRS_.4BAS4.C
  4320: 52 53 5f 0a 38 4c 45 4e 34 a0 05 4f 53 46 4c a1  RS_.8LEN4..OSFL.
  4330: 41 06 a0 28 4d 47 31 42 a0 22 94 4d 47 31 42 0c  A..(MG1B.".MG1B.
  4340: 00 00 0c 00 70 0c 00 00 0c 00 42 41 53 31 74 4d  ....p.....BAS1tM
  4350: 47 31 42 42 41 53 31 4c 45 4e 31 a1 15 70 0c 00  G1BBAS1LEN1..p..
  4360: 00 0c 00 42 41 53 31 70 0c 00 00 02 00 4c 45 4e  ...BAS1p.....LEN
  4370: 31 a0 1f 72 4d 47 31 42 4d 47 31 4c 60 70 60 42  1..rMG1BMG1L`p`B
  4380: 41 53 32 74 0c 00 00 10 00 42 41 53 32 4c 45 4e  AS2t.....BAS2LEN
  4390: 32 74 4d 47 32 42 0c 00 00 10 00 4c 45 4e 33 70  2tMG2B.....LEN3p
  43a0: 4d 48 31 42 42 41 53 34 74 00 42 41 53 34 4c 45  MH1BBAS4t.BAS4LE
  43b0: 4e 34 a4 43 52 53 5f 5b 82 45 32 52 4d 53 43 08  N4.CRS_[.E2RMSC.
  43c0: 5f 48 49 44 0c 41 d0 0c 02 08 5f 55 49 44 0a 10  _HID.A...._UID..
  43d0: 08 43 52 53 5f 11 47 17 0b 72 01 47 01 10 00 10  .CRS_.G..r.G....
  43e0: 00 00 10 47 01 22 00 22 00 00 1e 47 01 62 00 62  ...G."."...G.b.b
  43f0: 00 00 02 47 01 65 00 65 00 00 0b 47 01 72 00 72  ...G.e.e...G.r.r
  4400: 00 00 0e 47 01 80 00 80 00 00 01 47 01 84 00 84  ...G.......G....
  4410: 00 00 03 47 01 88 00 88 00 00 01 47 01 8c 00 8c  ...G.......G....
  4420: 00 00 03 47 01 90 00 90 00 00 10 47 01 a2 00 a2  ...G.......G....
  4430: 00 00 1e 47 01 b1 00 b1 00 00 01 47 01 e0 00 e0  ...G.......G....
  4440: 00 00 10 47 01 d0 04 d0 04 00 02 47 01 0b 04 0b  ...G.......G....
  4450: 04 00 01 47 01 d6 04 d6 04 00 01 47 01 00 0c 00  ...G.......G....
  4460: 0c 00 02 47 01 14 0c 14 0c 00 01 47 01 50 0c 50  ...G.......G.P.P
  4470: 0c 00 02 47 01 52 0c 52 0c 00 01 47 01 6c 0c 6c  ...G.R.R...G.l.l
  4480: 0c 00 01 47 01 6f 0c 6f 0c 00 01 47 01 d0 0c d0  ...G.o.o...G....
  4490: 0c 00 02 47 01 d2 0c d2 0c 00 02 47 01 d4 0c d4  ...G.......G....
  44a0: 0c 00 02 47 01 d6 0c d6 0c 00 02 47 01 d8 0c d8  ...G.......G....
  44b0: 0c 00 08 47 01 00 0b 00 0b 00 40 47 01 00 00 00  ...G......@G....
  44c0: 00 00 00 47 01 00 00 00 00 00 00 47 01 00 00 00  ...G.......G....
  44d0: 00 00 00 47 01 00 00 00 00 00 00 47 01 00 09 00  ...G.......G....
  44e0: 09 00 10 47 01 10 09 10 09 00 10 47 01 00 fe 00  ...G.......G....
  44f0: fe 00 ff 47 01 60 00 60 00 00 00 47 01 64 00 64  ...G.`.`...G.d.d
  4500: 00 00 00 86 09 00 00 00 00 00 00 00 00 00 00 86  ................
  4510: 09 00 00 00 00 b8 ff 00 00 08 00 86 09 00 00 00  ................
  4520: 00 c1 fe 20 00 00 00 86 09 00 00 00 00 d4 fe 00  ... ............
  4530: 50 00 00 86 09 00 00 00 00 d8 fe 00 10 00 00 86  P...............
  4540: 09 00 01 00 00 00 00 00 00 00 00 79 00 14 40 19  ...........y..@.
  4550: 5f 43 52 53 00 8b 43 52 53 5f 0a e2 47 50 30 30  _CRS..CRS_..GP00
  4560: 8b 43 52 53 5f 0a e4 47 50 30 31 8c 43 52 53 5f  .CRS_..GP01.CRS_
  4570: 0a e7 47 50 30 4c 70 50 4d 42 53 47 50 30 30 70  ..GP0LpPMBSGP00p
  4580: 50 4d 42 53 47 50 30 31 70 50 4d 4c 4e 47 50 30  PMBSGP01pPMLNGP0
  4590: 4c a0 4e 07 53 4d 42 42 8b 43 52 53 5f 0a fa 47  L.N.SMBB.CRS_..G
  45a0: 50 31 30 8b 43 52 53 5f 0a fc 47 50 31 31 8c 43  P10.CRS_..GP11.C
  45b0: 52 53 5f 0a ff 47 50 31 4c 70 53 4d 42 42 47 50  RS_..GP1LpSMBBGP
  45c0: 31 30 70 53 4d 42 42 47 50 31 31 70 53 4d 42 4c  10pSMBBGP11pSMBL
  45d0: 47 50 31 4c 8b 43 52 53 5f 0a f2 47 50 42 30 8b  GP1L.CRS_..GPB0.
  45e0: 43 52 53 5f 0a f4 47 50 42 31 8c 43 52 53 5f 0a  CRS_..GPB1.CRS_.
  45f0: f7 47 50 42 4c 70 53 4d 42 30 47 50 42 30 70 53  .GPBLpSMB0GPB0pS
  4600: 4d 42 30 47 50 42 31 70 53 4d 42 4d 47 50 42 4c  MB0GPB1pSMBMGPBL
  4610: a0 42 04 47 50 42 53 8b 43 52 53 5f 0a ea 47 50  .B.GPBS.CRS_..GP
  4620: 32 30 8b 43 52 53 5f 0a ec 47 50 32 31 8c 43 52  20.CRS_..GP21.CR
  4630: 53 5f 0a ef 47 50 32 4c 70 47 50 42 53 47 50 32  S_..GP2LpGPBSGP2
  4640: 30 70 47 50 42 53 47 50 32 31 70 47 50 4c 4e 47  0pGPBSGP21pGPLNG
  4650: 50 32 4c 79 01 0a 0a 60 79 01 0a 0c 61 7d 7b 49  P2Ly...`y...a}{I
  4660: 4f 53 54 60 00 7b 49 4f 53 54 61 00 60 8c 43 52  OST`.{IOSTa.`.CR
  4670: 53 5f 0b 1f 01 4b 42 4c 30 8c 43 52 53 5f 0b 27  S_...KBL0.CRS_.'
  4680: 01 4b 42 4c 31 a0 10 93 60 00 70 01 4b 42 4c 30  .KBL1...`.p.KBL0
  4690: 70 01 4b 42 4c 31 a0 42 04 5c 2e 41 4f 44 5f 52  p.KBL1.B.\.AOD_R
  46a0: 41 4d 53 8a 43 52 53 5f 0b 2c 01 52 41 44 42 8a  AMS.CRS_.,.RADB.
  46b0: 43 52 53 5f 0b 30 01 52 41 44 4c 70 5c 2e 41 4f  CRS_.0.RADLp\.AO
  46c0: 44 5f 52 41 4d 42 52 41 44 42 70 5c 2e 41 4f 44  D_RAMBRADBp\.AOD
  46d0: 5f 52 41 4d 53 52 41 44 4c a4 43 52 53 5f 5b 82  _RAMSRADL.CRS_[.
  46e0: 46 1b 53 49 4f 52 08 5f 48 49 44 0c 41 d0 0c 02  F.SIOR._HID.A...
  46f0: 14 0b 5f 55 49 44 00 a4 53 50 49 4f 08 43 52 53  .._UID..SPIO.CRS
  4700: 5f 11 2d 0a 2a 47 01 00 00 00 00 00 00 47 01 00  _.-.*G.......G..
  4710: 00 00 00 00 00 47 01 00 00 00 00 00 00 47 01 00  .....G.......G..
  4720: 00 00 00 00 00 47 01 00 00 00 00 00 00 79 00 14  .....G.......y..
  4730: 46 16 5f 43 52 53 00 a0 4d 04 90 92 93 53 50 49  F._CRS..M....SPI
  4740: 4f 0b f0 03 94 53 50 49 4f 0a f0 8b 43 52 53 5f  O....SPIO...CRS_
  4750: 0a 02 47 50 31 30 8b 43 52 53 5f 0a 04 47 50 31  ..GP10.CRS_..GP1
  4760: 31 8c 43 52 53 5f 0a 07 47 50 4c 31 70 53 50 49  1.CRS_..GPL1pSPI
  4770: 4f 47 50 31 30 70 53 50 49 4f 47 50 31 31 70 0a  OGP10pSPIOGP11p.
  4780: 02 47 50 4c 31 a0 42 04 49 4f 50 42 8b 43 52 53  .GPL1.B.IOPB.CRS
  4790: 5f 0a 0a 47 50 32 30 8b 43 52 53 5f 0a 0c 47 50  _..GP20.CRS_..GP
  47a0: 32 31 8c 43 52 53 5f 0a 0f 47 50 4c 32 70 49 4f  21.CRS_..GPL2pIO
  47b0: 50 42 47 50 32 30 70 49 4f 50 42 47 50 32 31 70  PBGP20pIOPBGP21p
  47c0: 49 4f 50 4c 47 50 4c 32 a0 42 04 49 4f 45 42 8b  IOPLGPL2.B.IOEB.
  47d0: 43 52 53 5f 0a 12 47 50 33 30 8b 43 52 53 5f 0a  CRS_..GP30.CRS_.
  47e0: 14 47 50 33 31 8c 43 52 53 5f 0a 17 47 50 4c 33  .GP31.CRS_..GPL3
  47f0: 70 49 4f 45 42 47 50 33 30 70 49 4f 45 42 47 50  pIOEBGP30pIOEBGP
  4800: 33 31 70 49 4f 45 4c 47 50 4c 33 a0 42 04 49 4f  31pIOELGPL3.B.IO
  4810: 47 42 8b 43 52 53 5f 0a 1a 47 50 34 30 8b 43 52  GB.CRS_..GP40.CR
  4820: 53 5f 0a 1c 47 50 34 31 8c 43 52 53 5f 0a 1f 47  S_..GP41.CRS_..G
  4830: 50 4c 34 70 49 4f 47 42 47 50 34 30 70 49 4f 47  PL4pIOGBGP40pIOG
  4840: 42 47 50 34 31 70 49 4f 47 4c 47 50 4c 34 a0 42  BGP41pIOGLGPL4.B
  4850: 04 49 4f 53 42 8b 43 52 53 5f 0a 22 47 50 35 30  .IOSB.CRS_."GP50
  4860: 8b 43 52 53 5f 0a 24 47 50 35 31 8c 43 52 53 5f  .CRS_.$GP51.CRS_
  4870: 0a 27 47 50 4c 35 70 49 4f 53 42 47 50 35 30 70  .'GPL5pIOSBGP50p
  4880: 49 4f 53 42 47 50 35 31 70 49 4f 53 4c 47 50 4c  IOSBGP51pIOSLGPL
  4890: 35 a4 43 52 53 5f 08 44 43 41 54 12 2c 16 01 0a  5.CRS_.DCAT.,...
  48a0: 02 0a 03 00 0a ff 0a ff 0a ff 0a ff 0a ff 0a ff  ................
  48b0: 0a 05 0a 04 0a ff 0a ff 0a ff 0a ff 0a 0a 0a ff  ................
  48c0: 0a ff 0a ff 0a ff 0a ff 08 49 4b 45 59 12 16 02  .........IKEY...
  48d0: 12 09 04 0a 87 01 0a 55 0a 55 12 09 04 0a 87 01  .......U.U......
  48e0: 0a 55 0a aa 08 4b 42 46 47 01 08 4d 53 46 47 01  .U...KBFG..MSFG.
  48f0: 08 55 52 31 46 01 14 45 04 45 4e 46 47 01 70 00  .UR1F..E.ENFG.p.
  4900: 61 a0 0b 93 53 50 49 4f 0a 2e 70 00 61 a0 0b 93  a...SPIO..p.a...
  4910: 53 50 49 4f 0a 4e 70 01 61 70 00 60 a2 19 92 93  SPIO.Np.ap.`....
  4920: 60 0a 04 70 83 88 83 88 49 4b 45 59 61 00 60 00  `..p....IKEYa.`.
  4930: 49 4e 44 58 75 60 70 68 4c 44 4e 5f 14 14 45 58  INDXu`phLDN_..EX
  4940: 46 47 00 70 0a 02 49 4e 44 58 70 0a 02 44 41 54  FG.p..INDXp..DAT
  4950: 41 14 1d 4c 50 54 4d 01 45 4e 46 47 43 47 4c 44  A..LPTM.ENFGCGLD
  4960: 68 7b 4f 50 54 30 0a 02 60 45 58 46 47 a4 60 14  h{OPT0..`EXFG.`.
  4970: 2a 55 48 49 44 01 45 4e 46 47 43 47 4c 44 68 7b  *UHID.ENFGCGLDh{
  4980: 4f 50 54 30 0a 70 60 45 58 46 47 a0 08 60 a4 0c  OPT0.p`EXFG..`..
  4990: 41 d0 05 10 a4 0c 41 d0 05 01 14 19 4f 52 46 30  A.....A.....ORF0
  49a0: 02 45 4e 46 47 68 7d 4f 50 54 30 69 4f 50 54 30  .ENFGh}OPT0iOPT0
  49b0: 45 58 46 47 14 19 4f 52 46 31 02 45 4e 46 47 68  EXFG..ORF1.ENFGh
  49c0: 7d 4f 50 54 31 69 4f 50 54 31 45 58 46 47 14 19  }OPT1iOPT1EXFG..
  49d0: 4f 52 46 32 02 45 4e 46 47 68 7d 4f 50 54 32 69  ORF2.ENFGh}OPT2i
  49e0: 4f 50 54 32 45 58 46 47 14 19 41 4e 46 30 02 45  OPT2EXFG..ANF0.E
  49f0: 4e 46 47 68 7b 4f 50 54 30 69 4f 50 54 30 45 58  NFGh{OPT0iOPT0EX
  4a00: 46 47 14 19 41 4e 46 32 02 45 4e 46 47 68 7b 4f  FG..ANF2.ENFGh{O
  4a10: 50 54 32 69 4f 50 54 32 45 58 46 47 14 19 41 4e  PT2iOPT2EXFG..AN
  4a20: 46 34 02 45 4e 46 47 68 7b 4f 50 54 34 69 4f 50  F4.ENFGh{OPT4iOP
  4a30: 54 34 45 58 46 47 14 15 53 54 46 30 02 45 4e 46  T4EXFG..STF0.ENF
  4a40: 47 68 70 69 4f 50 54 30 45 58 46 47 14 15 53 54  GhpiOPT0EXFG..ST
  4a50: 46 31 02 45 4e 46 47 68 70 69 4f 50 54 31 45 58  F1.ENFGhpiOPT1EX
  4a60: 46 47 14 41 0c 53 49 4f 53 01 70 0d 53 49 4f 53  FG.A.SIOS.p.SIOS
  4a70: 00 5b 31 70 01 47 50 32 30 a0 4a 0a 95 68 0a 05  .[1p.GP20.J..h..
  4a80: 45 4e 46 47 0a 04 70 01 41 43 54 52 45 58 46 47  ENFG..p.ACTREXFG
  4a90: 41 4e 46 34 0a 04 0a fc a0 15 4b 42 46 47 4f 52  ANF4......KBFGOR
  4aa0: 46 31 0a 04 0a 08 4f 52 46 30 0a 04 0a 08 a1 09  F1....ORF0......
  4ab0: 41 4e 46 30 0a 04 0a f7 a0 15 4d 53 46 47 4f 52  ANF0......MSFGOR
  4ac0: 46 31 0a 04 0a 10 4f 52 46 30 0a 04 0a 10 a1 09  F1....ORF0......
  4ad0: 41 4e 46 30 0a 04 0a ef 4f 52 46 31 0a 04 0a ff  ANF0....ORF1....
  4ae0: 41 4e 46 32 0a 04 0a b0 45 4e 46 47 0a 07 a0 26  ANF2....ENFG...&
  4af0: 95 68 0a 04 7d 4f 50 46 38 0a 10 4f 50 46 38 7b  .h..}OPF8..OPF8{
  4b00: 4f 50 46 39 0a f0 4f 50 46 39 7d 4f 50 46 39 0a  OPF9..OPF9}OPF9.
  4b10: 02 4f 50 46 39 7b 4f 50 32 39 0a ef 4f 50 32 39  .OPF9{OP29..OP29
  4b20: 45 58 46 47 14 47 06 53 49 4f 57 01 70 01 47 50  EXFG.G.SIOW.p.GP
  4b30: 32 30 70 0d 53 49 4f 57 00 5b 31 45 4e 46 47 0a  20p.SIOW.[1ENFG.
  4b40: 07 7d 4f 50 43 31 01 4f 50 43 31 45 4e 46 47 0a  .}OPC1.OPC1ENFG.
  4b50: 05 7d 41 43 54 52 01 41 43 54 52 45 4e 46 47 0a  .}ACTR.ACTRENFG.
  4b60: 06 7d 41 43 54 52 01 41 43 54 52 45 4e 46 47 0a  .}ACTR.ACTRENFG.
  4b70: 04 53 54 46 30 0a 04 00 53 54 46 31 0a 04 0a ff  .STF0...STF1....
  4b80: 41 4e 46 32 0a 04 0a 40 45 58 46 47 14 0f 53 49  ANF2...@EXFG..SI
  4b90: 4f 48 00 70 0d 53 49 4f 48 00 5b 31 5b 80 49 4f  OH.p.SIOH.[1[.IO
  4ba0: 49 44 01 53 50 49 4f 0a 02 5b 81 10 49 4f 49 44  ID.SPIO..[..IOID
  4bb0: 01 49 4e 44 58 08 44 41 54 41 08 5b 86 40 0e 49  .INDX.DATA.[.@.I
  4bc0: 4e 44 58 44 41 54 41 01 00 38 4c 44 4e 5f 08 00  NDXDATA..8LDN_..
  4bd0: 48 0e 4f 50 32 35 08 4f 50 32 36 08 4f 50 32 37  H.OP25.OP26.OP27
  4be0: 08 4f 50 32 38 08 4f 50 32 39 08 00 30 41 43 54  .OP28.OP29..0ACT
  4bf0: 52 08 00 48 17 49 4f 41 48 08 49 4f 41 4c 08 49  R..H.IOAH.IOAL.I
  4c00: 4f 48 32 08 49 4f 4c 32 08 00 40 06 49 4e 54 52  OH2.IOL2..@.INTR
  4c10: 08 00 18 44 4d 43 48 08 00 48 25 4f 50 43 30 08  ...DMCH..H%OPC0.
  4c20: 4f 50 43 31 08 4f 50 43 32 08 4f 50 43 33 08 4f  OPC1.OPC2.OPC3.O
  4c30: 50 43 34 08 4f 50 43 35 08 4f 50 43 36 08 4f 50  PC4.OPC5.OPC6.OP
  4c40: 43 37 08 4f 50 43 38 08 4f 50 43 39 08 4f 50 43  C7.OPC8.OPC9.OPC
  4c50: 41 08 4f 50 43 42 08 4f 50 43 43 08 4f 50 43 44  A.OPCB.OPCC.OPCD
  4c60: 08 4f 50 43 45 08 4f 50 43 46 08 00 40 10 4f 50  .OPCE.OPCF..@.OP
  4c70: 54 30 08 4f 50 54 31 08 4f 50 54 32 08 4f 50 54  T0.OPT1.OPT2.OPT
  4c80: 33 08 4f 50 54 34 08 00 18 4f 50 46 38 08 4f 50  3.OPT4...OPF8.OP
  4c90: 46 39 08 4f 50 46 41 08 4f 50 46 42 08 14 1c 2e  F9.OPFA.OPFB....
  4ca0: 50 53 32 4b 5f 50 53 57 01 a0 08 68 70 01 4b 42  PS2K_PSW...hp.KB
  4cb0: 46 47 a1 07 70 00 4b 42 46 47 14 1c 2e 50 53 32  FG..p.KBFG...PS2
  4cc0: 4d 5f 50 53 57 01 a0 08 68 70 01 4d 53 46 47 a1  M_PSW...hp.MSFG.
  4cd0: 07 70 00 4d 53 46 47 14 0f 43 47 4c 44 01 a4 83  .p.MSFG..CGLD...
  4ce0: 88 44 43 41 54 68 00 14 4e 04 44 53 54 41 01 45  .DCATh..N.DSTA.E
  4cf0: 4e 46 47 43 47 4c 44 68 70 41 43 54 52 60 45 58  NFGCGLDhpACTR`EX
  4d00: 46 47 a0 07 93 60 0a ff a4 00 7b 60 01 60 7d 49  FG...`....{`.`}I
  4d10: 4f 53 54 79 60 68 00 49 4f 53 54 a0 05 60 a4 0a  OSTy`h.IOST..`..
  4d20: 0f a1 14 a0 0e 7b 79 01 68 00 49 4f 53 54 00 a4  .....{y.h.IOST..
  4d30: 0a 0d a1 03 a4 00 14 4f 04 44 43 4e 54 02 45 4e  .......O.DCNT.EN
  4d40: 46 47 43 47 4c 44 68 79 49 4f 41 48 0a 08 61 7d  FGCGLDhyIOAH..a}
  4d50: 49 4f 41 4c 61 61 a0 1c 90 95 44 4d 43 48 0a 04  IOALaa....DMCH..
  4d60: 92 93 7b 44 4d 43 48 0a 03 61 00 52 44 4d 41 68  ..{DMCH..a.RDMAh
  4d70: 69 75 61 70 69 41 43 54 52 52 52 49 4f 68 69 61  iuapiACTRRRIOhia
  4d80: 0a 08 45 58 46 47 08 43 52 53 31 11 13 0a 10 47  ..EXFG.CRS1....G
  4d90: 01 00 00 00 00 01 00 22 00 00 2a 00 00 79 00 8b  ......."..*..y..
  4da0: 43 52 53 31 0a 09 49 52 51 4d 8c 43 52 53 31 0a  CRS1..IRQM.CRS1.
  4db0: 0c 44 4d 41 4d 8b 43 52 53 31 0a 02 49 4f 31 31  .DMAM.CRS1..IO11
  4dc0: 8b 43 52 53 31 0a 04 49 4f 31 32 8c 43 52 53 31  .CRS1..IO12.CRS1
  4dd0: 0a 07 4c 45 4e 31 08 43 52 53 32 11 1b 0a 18 47  ..LEN1.CRS2....G
  4de0: 01 00 00 00 00 01 00 47 01 00 00 00 00 01 00 22  .......G......."
  4df0: 40 00 2a 04 00 79 00 8b 43 52 53 32 0a 11 49 52  @.*..y..CRS2..IR
  4e00: 51 45 8c 43 52 53 32 0a 14 44 4d 41 45 8b 43 52  QE.CRS2..DMAE.CR
  4e10: 53 32 0a 02 49 4f 32 31 8b 43 52 53 32 0a 04 49  S2..IO21.CRS2..I
  4e20: 4f 32 32 8c 43 52 53 32 0a 07 4c 45 4e 32 8b 43  O22.CRS2..LEN2.C
  4e30: 52 53 32 0a 0a 49 4f 33 31 8b 43 52 53 32 0a 0c  RS2..IO31.CRS2..
  4e40: 49 4f 33 32 8c 43 52 53 32 0a 0f 4c 45 4e 33 14  IO32.CRS2..LEN3.
  4e50: 46 08 44 43 52 53 02 45 4e 46 47 43 47 4c 44 68  F.DCRS.ENFGCGLDh
  4e60: 79 49 4f 41 48 0a 08 49 4f 31 31 7d 49 4f 41 4c  yIOAH..IO11}IOAL
  4e70: 49 4f 31 31 49 4f 31 31 70 49 4f 31 31 49 4f 31  IO11IO11pIO11IO1
  4e80: 32 74 82 49 4f 31 31 00 01 60 79 01 60 4c 45 4e  2t.IO11..`y.`LEN
  4e90: 31 a0 0f 49 4e 54 52 79 01 49 4e 54 52 49 52 51  1..INTRy.INTRIRQ
  4ea0: 4d a1 07 70 00 49 52 51 4d a0 12 91 94 44 4d 43  M..p.IRQM....DMC
  4eb0: 48 0a 03 93 69 00 70 00 44 4d 41 4d a1 10 7b 44  H...i.p.DMAM..{D
  4ec0: 4d 43 48 0a 03 61 79 01 61 44 4d 41 4d 45 58 46  MCH..ay.aDMAMEXF
  4ed0: 47 a4 43 52 53 31 14 43 0a 44 53 52 53 02 8b 68  G.CRS1.C.DSRS..h
  4ee0: 0a 09 49 52 51 4d 8c 68 0a 0c 44 4d 41 4d 8b 68  ..IRQM.h..DMAM.h
  4ef0: 0a 02 49 4f 31 31 45 4e 46 47 43 47 4c 44 69 79  ..IO11ENFGCGLDiy
  4f00: 49 4f 41 48 0a 08 61 7d 49 4f 41 4c 61 61 52 52  IOAH..a}IOALaaRR
  4f10: 49 4f 69 00 61 0a 08 52 52 49 4f 69 01 49 4f 31  IOi.a..RRIOi.IO1
  4f20: 31 0a 08 7b 49 4f 31 31 0a ff 49 4f 41 4c 7a 49  1..{IO11..IOALzI
  4f30: 4f 31 31 0a 08 49 4f 41 48 a0 12 49 52 51 4d 82  O11..IOAH..IRQM.
  4f40: 49 52 51 4d 60 74 60 01 49 4e 54 52 a1 07 70 00  IRQM`t`.INTR..p.
  4f50: 49 4e 54 52 a0 12 44 4d 41 4d 82 44 4d 41 4d 60  INTR..DMAM.DMAM`
  4f60: 74 60 01 44 4d 43 48 a1 08 70 0a 04 44 4d 43 48  t`.DMCH..p..DMCH
  4f70: 45 58 46 47 44 43 4e 54 69 01 5b 80 47 50 49 4f  EXFGDCNTi.[.GPIO
  4f80: 01 49 4f 47 42 0a 04 5b 81 47 0a 47 50 49 4f 01  .IOGB..[.G.GPIO.
  4f90: 47 50 31 30 01 47 50 31 31 01 47 50 31 32 01 47  GP10.GP11.GP12.G
  4fa0: 50 31 33 01 47 4f 31 34 01 47 4f 31 35 01 47 4f  P13.GO14.GO15.GO
  4fb0: 31 36 01 47 4f 31 37 01 47 50 32 30 01 47 50 32  16.GO17.GP20.GP2
  4fc0: 31 01 47 50 32 32 01 47 50 32 33 01 47 4f 32 34  1.GP22.GP23.GO24
  4fd0: 01 47 4f 32 35 01 47 4f 32 36 01 47 4f 32 37 01  .GO25.GO26.GO27.
  4fe0: 47 50 33 30 01 47 50 33 31 01 47 50 33 32 01 47  GP30.GP31.GP32.G
  4ff0: 50 33 33 01 47 4f 33 34 01 47 4f 33 35 01 47 4f  P33.GO34.GO35.GO
  5000: 33 36 01 47 4f 33 37 01 47 50 34 30 01 47 50 34  36.GO37.GP40.GP4
  5010: 31 01 47 50 34 32 01 47 50 34 33 01 47 4f 34 34  1.GP42.GP43.GO44
  5020: 01 47 4f 34 35 01 47 4f 34 36 01 47 4f 34 37 01  .GO45.GO46.GO47.
  5030: 10 43 20 5c 5f 47 50 45 14 48 0a 5f 4c 31 38 00  .C \_GPE.H._L18.
  5040: 86 5c 2f 03 5f 53 42 5f 50 43 49 30 50 43 45 32  .\/._SB_PCI0PCE2
  5050: 0a 02 86 5c 2f 03 5f 53 42 5f 50 43 49 30 50 43  ...\/._SB_PCI0PC
  5060: 45 33 0a 02 86 5c 2f 03 5f 53 42 5f 50 43 49 30  E3...\/._SB_PCI0
  5070: 50 43 45 35 0a 02 86 5c 2f 03 5f 53 42 5f 50 43  PCE5...\/._SB_PC
  5080: 49 30 50 43 45 36 0a 02 86 5c 2f 03 5f 53 42 5f  I0PCE6...\/._SB_
  5090: 50 43 49 30 50 43 45 37 0a 02 86 5c 2f 03 5f 53  PCI0PCE7...\/._S
  50a0: 42 5f 50 43 49 30 50 43 45 39 0a 02 86 5c 2f 03  B_PCI0PCE9...\/.
  50b0: 5f 53 42 5f 50 43 49 30 50 43 45 41 0a 02 86 5c  _SB_PCI0PCEA...\
  50c0: 2f 04 5f 53 42 5f 50 43 49 30 50 43 45 41 52 4c  /._SB_PCI0PCEARL
  50d0: 41 4e 0a 02 86 5c 2e 5f 53 42 5f 50 57 52 42 0a  AN...\._SB_PWRB.
  50e0: 02 14 25 5f 4c 31 42 00 86 5c 2f 03 5f 53 42 5f  ..%_L1B..\/._SB_
  50f0: 50 43 49 30 53 42 41 5a 0a 02 86 5c 2e 5f 53 42  PCI0SBAZ...\._SB
  5100: 5f 50 57 52 42 0a 02 14 25 5f 4c 30 34 00 86 5c  _PWRB...%_L04..\
  5110: 2f 03 5f 53 42 5f 50 43 49 30 50 30 50 43 0a 02  /._SB_PCI0P0PC..
  5120: 86 5c 2e 5f 53 42 5f 50 57 52 42 0a 02 14 25 5f  .\._SB_PWRB...%_
  5130: 4c 31 33 00 86 5c 2f 03 5f 53 42 5f 50 43 49 30  L13..\/._SB_PCI0
  5140: 47 45 43 5f 0a 02 86 5c 2e 5f 53 42 5f 50 57 52  GEC_...\._SB_PWR
  5150: 42 0a 02 14 42 09 5f 4c 30 42 00 86 5c 2f 03 5f  B...B._L0B..\/._
  5160: 53 42 5f 50 43 49 30 55 48 43 31 0a 02 86 5c 2f  SB_PCI0UHC1...\/
  5170: 03 5f 53 42 5f 50 43 49 30 55 48 43 32 0a 02 86  ._SB_PCI0UHC2...
  5180: 5c 2f 03 5f 53 42 5f 50 43 49 30 55 53 42 33 0a  \/._SB_PCI0USB3.
  5190: 02 86 5c 2f 03 5f 53 42 5f 50 43 49 30 55 48 43  ..\/._SB_PCI0UHC
  51a0: 34 0a 02 86 5c 2f 03 5f 53 42 5f 50 43 49 30 55  4...\/._SB_PCI0U
  51b0: 53 42 35 0a 02 86 5c 2f 03 5f 53 42 5f 50 43 49  SB5...\/._SB_PCI
  51c0: 30 55 48 43 36 0a 02 86 5c 2f 03 5f 53 42 5f 50  0UHC6...\/._SB_P
  51d0: 43 49 30 55 48 43 37 0a 02 86 5c 2e 5f 53 42 5f  CI0UHC7...\._SB_
  51e0: 50 57 52 42 0a 02 14 26 5f 4c 30 33 00 5c 2f 04  PWRB...&_L03.\/.
  51f0: 5f 53 42 5f 50 43 49 30 53 42 52 47 53 49 4f 48  _SB_PCI0SBRGSIOH
  5200: 86 5c 2e 5f 53 42 5f 50 57 52 42 0a 02 14 26 5f  .\._SB_PWRB...&_
  5210: 4c 31 36 00 5c 2f 04 5f 53 42 5f 50 43 49 30 53  L16.\/._SB_PCI0S
  5220: 42 52 47 53 49 4f 48 86 5c 2e 5f 53 42 5f 50 57  BRGSIOH.\._SB_PW
  5230: 52 42 0a 02 5b 82 1d 50 57 52 42 08 5f 48 49 44  RB..[..PWRB._HID
  5240: 0c 41 d0 0c 0c 08 5f 55 49 44 0a aa 08 5f 53 54  .A...._UID..._ST
  5250: 41 0a 0b 10 4a 2b 2f 04 5f 53 42 5f 50 43 49 30  A...J+/._SB_PCI0
  5260: 53 42 52 47 41 53 4f 43 08 47 30 54 30 12 1d 07  SBRGASOC.G0T0...
  5270: 0c 00 00 06 00 0d 41 50 20 76 65 72 73 69 6f 6e  ......AP version
  5280: 00 0c 00 00 00 40 00 00 01 0a 02 08 47 30 54 33  .....@......G0T3
  5290: 12 1b 07 0c 03 00 02 00 0d 43 6e 51 20 46 6c 61  .........CnQ Fla
  52a0: 67 00 0c 00 00 00 40 00 00 01 0a 02 08 47 30 54  g.....@......G0T
  52b0: 37 12 22 07 0c 07 00 07 00 0d 50 20 53 74 61 74  7.".......P Stat
  52c0: 65 20 43 6f 6e 74 72 6f 6c 00 0c 00 00 00 40 00  e Control.....@.
  52d0: 00 01 0a 02 08 47 30 54 34 12 20 07 0c 04 00 07  .....G0T4. .....
  52e0: 00 0d 4e 65 77 20 43 50 55 20 49 6e 73 74 61 6c  ..New CPU Instal
  52f0: 6c 65 64 00 01 00 00 01 0a 02 08 47 30 54 38 12  led........G0T8.
  5300: 21 07 0c 08 00 06 00 0d 49 74 65 6d 20 63 61 70  !.......Item cap
  5310: 61 62 69 6c 69 74 79 00 0c 00 00 00 40 00 00 00  ability.....@...
  5320: 00 08 47 30 54 39 12 1e 07 0c 09 00 06 00 0d 49  ..G0T9.........I
  5330: 74 65 6d 20 63 6f 6e 74 72 6f 6c 00 0c 00 00 00  tem control.....
  5340: 40 00 00 00 00 08 47 30 54 41 12 19 07 0c 0a 00  @.....G0TA......
  5350: 06 00 0d 47 50 55 20 63 6f 6e 74 72 6f 6c 00 00  ...GPU control..
  5360: 00 00 00 00 08 47 30 47 56 12 25 07 0c 6f 00 06  .....G0GV.%..o..
  5370: 00 0d 47 50 55 20 42 6f 6f 73 74 65 72 20 56 65  ..GPU Booster Ve
  5380: 72 73 69 6f 6e 00 0c 00 00 00 40 00 00 00 00 08  rsion.....@.....
  5390: 47 52 50 30 12 22 08 47 30 54 30 47 30 54 33 47  GRP0.".G0T0G0T3G
  53a0: 30 54 37 47 30 54 34 47 30 54 38 47 30 54 39 47  0T7G0T4G0T8G0T9G
  53b0: 30 54 41 47 30 47 56 14 4e 0b 47 49 54 30 01 08  0TAG0GV.N.GIT0..
  53c0: 54 54 54 30 00 70 7b 68 0b ff ff 00 54 54 54 30  TTT0.p{h....TTT0
  53d0: a0 07 93 54 54 54 30 00 a1 4d 09 a0 14 93 54 54  ...TTT0..M....TT
  53e0: 54 30 0a 03 70 47 4e 56 53 0b f3 16 41 53 42 31  T0..pGNVS...ASB1
  53f0: a1 45 08 a0 14 93 54 54 54 30 0a 04 70 47 4e 56  .E....TTT0..pGNV
  5400: 53 0b c1 17 41 53 42 31 a1 4d 06 a0 21 93 54 54  S...ASB1.M..!.TT
  5410: 54 30 0a 08 70 00 60 7d 60 0a 02 60 a0 0a 49 55  T0..p.`}`..`..IU
  5420: 43 50 7d 60 0a 10 60 70 60 41 53 42 31 a1 48 04  CP}`..`p`ASB1.H.
  5430: a0 16 93 54 54 54 30 0a 09 70 00 60 7d 60 0a 02  ...TTT0..p.`}`..
  5440: 60 70 60 41 53 42 31 a1 2e a0 0f 93 54 54 54 30  `p`ASB1.....TTT0
  5450: 0a 0a 70 0a 02 41 53 42 31 a1 1c a0 12 93 54 54  ..p..ASB1.....TT
  5460: 54 30 0a 6f 70 0c 00 00 00 20 41 53 42 31 a1 07  T0.op.... ASB1..
  5470: 70 00 41 53 42 30 14 47 09 53 49 54 30 03 a0 46  p.ASB0.G.SIT0..F
  5480: 08 7b 6a 0b ff ff 00 08 54 54 54 30 00 70 7b 68  .{j.....TTT0.p{h
  5490: 0b ff ff 00 54 54 54 30 a0 07 93 54 54 54 30 00  ....TTT0...TTT0.
  54a0: a1 44 06 a0 07 93 54 54 54 30 01 a1 49 05 a0 08  .D....TTT0..I...
  54b0: 93 54 54 54 30 0a 03 a1 4d 04 a0 10 93 54 54 54  .TTT0...M....TTT
  54c0: 30 0a 07 53 4e 56 53 0b f3 16 69 a1 39 a0 17 93  0..SNVS...i.9...
  54d0: 54 54 54 30 0a 04 53 4e 56 53 0b c1 17 69 70 0a  TTT0..SNVS...ip.
  54e0: 03 41 53 42 30 a1 1f a0 15 93 54 54 54 30 0a 09  .ASB0.....TTT0..
  54f0: 54 4d 43 4d 7a 7b 69 0a 10 00 0a 04 00 a1 07 70  TMCMz{i........p
  5500: 00 41 53 42 30 a1 08 70 0a 03 41 53 42 30 10 87  .ASB0..p..ASB0..
  5510: df 01 2f 04 5f 53 42 5f 50 43 49 30 53 42 52 47  ../._SB_PCI0SBRG
  5520: 41 53 4f 43 08 47 33 43 30 12 21 07 0c 11 00 01  ASOC.G3C0.!.....
  5530: 03 0d 43 50 55 20 46 72 65 71 75 65 6e 63 79 00  ..CPU Frequency.
  5540: 00 0a 64 0b 20 4e 0a 64 0b c3 01 08 47 33 43 31  ..d. N.d....G3C1
  5550: 12 1f 07 0c 12 00 02 03 0d 43 50 55 20 56 6f 6c  .........CPU Vol
  5560: 74 61 67 65 00 00 00 0c 40 1f 00 ff 0a 7d 0a 4a  tage....@....}.J
  5570: 08 47 33 43 32 12 1e 07 0c 13 00 06 03 0d 43 50  .G3C2.........CP
  5580: 55 20 52 61 74 69 6f 00 00 0a 10 0c 28 00 00 ff  U Ratio.....(...
  5590: 0a 05 0a 2b 08 47 33 43 33 12 20 07 0c 15 00 02  ...+.G3C3. .....
  55a0: 03 0d 43 50 55 2f 4e 42 20 56 6f 6c 74 61 67 65  ..CPU/NB Voltage
  55b0: 00 00 00 0b b0 04 0a 0a 0a 13 08 47 33 53 46 12  ...........G3SF.
  55c0: 2a 07 0c 17 00 01 03 0d 43 50 55 20 53 61 66 65  *.......CPU Safe
  55d0: 62 6f 6f 74 20 46 72 65 71 75 65 6e 63 79 00 0c  boot Frequency..
  55e0: 00 00 00 40 00 00 01 0b 00 01 08 47 33 44 31 12  ...@.......G3D1.
  55f0: 4d 04 0a 0c 31 00 08 03 0d 44 52 41 4d 20 46 72  M...1....DRAM Fr
  5600: 65 71 75 65 6e 63 79 00 0c 00 00 00 40 00 0a 05  equency.....@...
  5610: 0d 41 75 74 6f 00 0d 38 30 30 20 4d 48 7a 00 0d  .Auto..800 MHz..
  5620: 31 30 36 36 20 4d 48 7a 00 0d 31 33 33 33 20 4d  1066 MHz..1333 M
  5630: 48 7a 00 0d 31 36 30 30 20 4d 48 7a 00 08 47 33  Hz..1600 MHz..G3
  5640: 44 32 12 21 07 0c 32 00 02 03 0d 44 52 41 4d 20  D2.!..2....DRAM 
  5650: 56 6f 6c 74 61 67 65 00 00 00 0c c0 d4 01 fe 0b  Voltage.........
  5660: dc 05 0a 54 08 47 33 35 33 12 21 07 0c 53 00 02  ...T.G353.!..S..
  5670: 03 0d 56 44 44 41 20 56 6f 6c 74 61 67 65 00 00  ..VDDA Voltage..
  5680: 00 0c 90 d0 03 fe 0b 10 27 0a 04 08 47 33 35 34  ........'...G354
  5690: 12 1f 07 0c 54 00 02 03 0d 48 54 20 56 6f 6c 74  ....T....HT Volt
  56a0: 61 67 65 00 00 00 0c c0 d4 01 fe 0b e8 03 0a 15  age.............
  56b0: 08 47 33 45 46 12 29 07 0c 60 00 01 03 0d 47 50  .G3EF.)..`....GP
  56c0: 55 20 45 6e 67 69 6e 65 20 43 6c 6f 63 6b 00 0c  U Engine Clock..
  56d0: 00 00 00 20 0b 2c 01 0b 20 4e 0a 64 0b 09 07 08  ... .,.. N.d....
  56e0: 47 33 36 31 12 20 07 0c 61 00 02 03 0d 47 50 55  G361. ..a....GPU
  56f0: 20 56 6f 6c 74 61 67 65 00 00 00 0c b0 ad 01 fe   Voltage........
  5700: 0b e8 03 0a 40 08 47 33 53 50 12 1e 06 0c 63 00  ....@.G3SP....c.
  5710: 01 03 0d 47 50 55 20 73 77 69 74 63 68 20 50 73  ...GPU switch Ps
  5720: 74 61 74 65 00 00 00 00 00 08 47 33 53 51 12 2b  tate......G3SQ.+
  5730: 07 0c 65 00 01 03 0d 47 50 55 20 53 69 64 65 50  ..e....GPU SideP
  5740: 6f 72 74 20 43 6c 6f 63 6b 00 0c 00 00 00 40 00  ort Clock.....@.
  5750: 0c b4 08 02 00 0a 64 0b 9c 02 08 47 33 53 52 12  ......d....G3SR.
  5760: 17 06 0c 67 00 01 03 0d 47 50 55 20 50 73 74 61  ...g....GPU Psta
  5770: 74 65 00 00 00 00 00 08 47 33 35 36 12 1c 07 0c  te......G356....
  5780: 56 00 02 03 0d 53 42 20 56 6f 6c 74 61 67 65 00  V....SB Voltage.
  5790: 00 00 0b 4c 04 0a 64 0a 04 08 47 33 35 37 12 1f  ...L..d...G357..
  57a0: 07 0c 57 00 02 03 0d 4e 42 31 2e 38 20 56 6f 6c  ..W....NB1.8 Vol
  57b0: 74 61 67 65 00 00 00 0b 08 07 0a 64 0a 02 08 47  tage.......d...G
  57c0: 33 44 53 12 1f 07 0c f0 00 06 03 0d 44 65 76 69  3DS.........Devi
  57d0: 63 65 20 53 65 6c 65 63 74 00 0c 00 00 00 40 00  ce Select.....@.
  57e0: 00 00 00 08 47 52 50 33 12 47 04 11 47 33 43 30  ....GRP3.G..G3C0
  57f0: 47 33 43 31 47 33 43 32 47 33 43 33 47 33 53 46  G3C1G3C2G3C3G3SF
  5800: 47 33 44 31 47 33 44 32 47 33 35 33 47 33 35 34  G3D1G3D2G353G354
  5810: 47 33 36 31 47 33 45 46 47 33 53 50 47 33 53 51  G361G3EFG3SPG3SQ
  5820: 47 33 53 52 47 33 35 36 47 33 35 37 47 33 44 53  G3SRG356G357G3DS
  5830: 08 47 4f 44 53 00 08 54 47 52 54 00 08 54 47 52  .GODS..TGRT..TGR
  5840: 32 00 08 43 4f 43 53 00 08 43 44 52 41 00 08 43  2..COCS..CDRA..C
  5850: 56 49 44 00 08 58 4d 50 56 00 08 56 44 44 51 00  VID..XMPV..VDDQ.
  5860: 08 56 44 43 41 00 08 43 4c 4b 42 11 27 0a 24 00  .VDCA..CLKB.'.$.
  5870: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  5880: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  5890: 00 00 00 8c 43 4c 4b 42 0a 05 43 42 30 35 8c 43  ....CLKB..CB05.C
  58a0: 4c 4b 42 0a 09 43 42 30 39 8c 43 4c 4b 42 0a 0a  LKB..CB09.CLKB..
  58b0: 43 42 31 30 8c 43 4c 4b 42 0a 0c 43 42 31 32 8c  CB10.CLKB..CB12.
  58c0: 43 4c 4b 42 0a 10 43 42 31 36 8c 43 4c 4b 42 0a  CLKB..CB16.CLKB.
  58d0: 11 43 42 31 37 8c 43 4c 4b 42 0a 14 43 42 32 30  .CB17.CLKB..CB20
  58e0: 8c 43 4c 4b 42 0a 1a 43 42 32 36 8c 43 4c 4b 42  .CLKB..CB26.CLKB
  58f0: 0a 1b 43 42 32 37 8c 43 4c 4b 42 0a 1c 43 42 32  ..CB27.CLKB..CB2
  5900: 38 08 54 50 42 46 11 0d 0a 0a 00 00 00 00 00 00  8.TPBF..........
  5910: 00 00 00 00 14 40 0a 47 33 55 50 00 77 0a 64 0a  .....@.G3UP.w.d.
  5920: 64 88 47 33 43 30 0a 04 00 70 47 41 47 50 0b 13  d.G3C0...pGAGP..
  5930: 03 60 70 60 54 47 52 54 70 47 41 47 50 0b ff 03  .`p`TGRTpGAGP...
  5940: 60 70 60 54 47 52 32 70 47 45 43 52 0a 33 43 4f  `p`TGR2pGECR.3CO
  5950: 43 53 74 47 44 43 52 0a 08 88 47 33 43 32 0a 03  CStGDCR...G3C2..
  5960: 00 43 50 55 4e 52 4d 49 4e 52 49 4e 54 52 4e 55  .CPUNRMINRINTRNU
  5970: 4d 43 31 55 50 43 33 55 50 44 32 55 50 47 43 44  MC1UPC3UPD2UPGCD
  5980: 52 70 47 41 47 50 0b 12 03 43 56 49 44 55 47 50  RpGAGP...CVIDUGP
  5990: 53 70 47 4e 42 56 60 70 60 88 54 50 42 46 0a 04  SpGNBV`p`.TPBF..
  59a0: 00 70 60 47 50 53 30 70 60 49 47 50 53 49 4e 47  .p`GPS0p`IGPSING
  59b0: 50 53 43 4c 4c 5b 80 50 43 41 41 00 41 54 49 45  PSCLL[.PCAA.ATIE
  59c0: 0c 00 00 00 02 5b 81 19 50 43 41 41 00 00 80 00  .....[..PCAA....
  59d0: 40 47 50 55 45 20 00 c8 42 c0 05 48 54 46 51 04  @GPUE ..B..HTFQ.
  59e0: 14 4c 04 55 47 50 53 00 a0 34 93 47 50 55 45 0c  .L.UGPS..4.GPUE.
  59f0: 43 10 02 96 a0 18 93 47 4e 56 53 0b 2d 17 00 70  C......GNVS.-..p
  5a00: 0c 00 00 00 20 88 47 33 45 46 0a 02 00 a1 0f 70  .... .G3EF.....p
  5a10: 0c 00 00 00 40 88 47 33 45 46 0a 02 00 a1 0f 70  ....@.G3EF.....p
  5a20: 0c 00 00 00 40 88 47 33 45 46 0a 02 00 14 47 04  ....@.G3EF....G.
  5a30: 52 44 41 54 01 a0 16 91 93 68 0a 03 93 68 0a 04  RDAT.....h...h..
  5a40: 70 47 41 47 50 0b 12 03 43 56 49 44 a0 28 93 68  pGAGP...CVID.(.h
  5a50: 0a 03 a0 22 91 47 4e 56 53 0b 81 17 92 7b 43 4f  ...".GNVS....{CO
  5a60: 43 53 0a 20 00 a0 0f 47 4e 56 53 0b e8 92 53 53  CS. ...GNVS...SS
  5a70: 47 50 0a 72 00 14 1c 43 50 55 4e 00 70 47 41 47  GP.r...CPUN.pGAG
  5a80: 50 0d 43 50 55 4e 00 60 70 60 88 47 33 44 53 0a  P.CPUN.`p`.G3DS.
  5a90: 06 00 14 19 52 4d 49 4e 00 70 47 41 47 50 0d 52  ....RMIN.pGAGP.R
  5aa0: 4d 49 4e 00 88 47 33 43 32 0a 04 00 14 19 52 49  MIN..G3C2.....RI
  5ab0: 4e 54 00 70 47 41 47 50 0d 52 49 4e 54 00 88 47  NT.pGAGP.RINT..G
  5ac0: 33 43 32 0a 05 00 14 19 52 4e 55 4d 00 70 47 41  3C2.....RNUM.pGA
  5ad0: 47 50 0d 52 4e 55 4d 00 88 47 33 43 32 0a 06 00  GP.RNUM..G3C2...
  5ae0: 14 4d 04 43 31 55 50 00 70 47 41 47 50 0d 43 31  .M.C1UP.pGAGP.C1
  5af0: 4d 49 00 88 47 33 43 31 0a 04 00 70 47 41 47 50  MI..G3C1...pGAGP
  5b00: 0d 43 31 49 4e 00 88 47 33 43 31 0a 05 00 70 47  .C1IN..G3C1...pG
  5b10: 41 47 50 0d 43 31 4e 55 00 88 47 33 43 31 0a 06  AGP.C1NU..G3C1..
  5b20: 00 70 47 44 56 44 88 47 33 43 31 0a 03 00 14 0c  .pGDVD.G3C1.....
  5b30: 47 44 56 44 00 70 0a 60 60 a4 60 14 4d 04 43 33  GDVD.p.``.`.M.C3
  5b40: 55 50 00 70 47 41 47 50 0d 43 33 4d 49 00 88 47  UP.pGAGP.C3MI..G
  5b50: 33 43 33 0a 04 00 70 47 41 47 50 0d 43 33 49 4e  3C3...pGAGP.C3IN
  5b60: 00 88 47 33 43 33 0a 05 00 70 47 41 47 50 0d 43  ..G3C3...pGAGP.C
  5b70: 33 4e 55 00 88 47 33 43 33 0a 06 00 70 47 44 4e  3NU..G3C3...pGDN
  5b80: 44 88 47 33 43 33 0a 03 00 14 0c 47 44 4e 44 00  D.G3C3.....GDND.
  5b90: 70 0a 60 60 a4 60 14 40 06 44 32 55 50 00 a0 15  p.``.`.@.D2UP...
  5ba0: 92 7b 43 4f 43 53 0a 40 00 70 0a 54 88 47 33 44  .{COCS.@.p.T.G3D
  5bb0: 32 0a 06 00 70 52 32 59 54 0a 6a 0a 03 60 70 60  2...pR2YT.j..`p`
  5bc0: 61 a0 15 7b 60 0a 40 00 7b 61 0a 3f 60 77 60 0a  a..{`.@.{a.?`w`.
  5bd0: 05 60 74 0a 14 60 60 a1 0b 7b 61 0a 3f 60 72 60  .`t..``..{a.?`r`
  5be0: 0a 14 60 70 60 88 47 33 44 32 0a 03 00 70 60 88  ..`p`.G3D2...p`.
  5bf0: 54 50 42 46 0a 02 00 14 4a 07 47 43 44 52 00 a0  TPBF....J.GCDR..
  5c00: 15 47 4e 56 53 0b 26 26 70 74 47 4e 56 53 0b a0  .GNVS.&&ptGNVS..
  5c10: 35 0a 02 00 60 a1 46 05 08 54 54 54 30 00 70 7b  5...`.F..TTT0.p{
  5c20: 47 4e 56 53 0b b0 47 0a 0f 00 54 54 54 30 a0 0b  GNVS..G...TTT0..
  5c30: 93 54 54 54 30 0a 05 70 01 60 a1 31 a0 0c 93 54  .TTT0..p.`.1...T
  5c40: 54 54 30 0a 0f 70 0a 02 60 a1 22 a0 0c 93 54 54  TT0..p..`."...TT
  5c50: 54 30 0a 0c 70 0a 03 60 a1 13 a0 0c 93 54 54 54  T0..p..`.....TTT
  5c60: 30 0a 0a 70 0a 04 60 a1 04 70 00 60 70 60 43 44  0..p..`..p.`p`CD
  5c70: 52 41 14 4a 18 47 49 54 33 01 08 54 54 54 30 00  RA.J.GIT3..TTT0.
  5c80: 70 7b 68 0b ff ff 00 54 54 54 30 a0 13 93 54 54  p{h....TTT0...TT
  5c90: 54 30 0a 11 70 45 46 53 42 00 00 41 53 42 31 a1  T0..pEFSB..ASB1.
  5ca0: 4d 15 a0 14 93 54 54 54 30 0a 12 70 47 41 47 50  M....TTT0..pGAGP
  5cb0: 0b 12 03 41 53 42 31 a1 45 14 a0 44 05 93 54 54  ...ASB1.E..D..TT
  5cc0: 54 30 0a 13 a0 4a 04 92 93 47 4f 44 53 0a ff a0  T0...J...GODS...
  5cd0: 1e 92 95 47 4f 44 53 0a 04 70 47 41 47 50 0b ff  ...GODS..pGAGP..
  5ce0: 03 61 79 74 47 4f 44 53 0a 04 00 0a 03 65 a1 12  .aytGODS.....e..
  5cf0: 70 47 41 47 50 0b 13 03 61 79 47 4f 44 53 0a 03  pGAGP...ayGODS..
  5d00: 65 7a 61 65 60 70 7b 60 0a ff 00 41 53 42 31 a1  ezae`p{`...ASB1.
  5d10: 4d 0e a0 14 93 54 54 54 30 0a 15 70 47 41 47 50  M....TTT0..pGAGP
  5d20: 0b 15 03 41 53 42 31 a1 45 0d a0 14 93 54 54 54  ...ASB1.E....TTT
  5d30: 30 0a 17 70 47 4e 56 53 0b 20 83 41 53 42 31 a1  0..pGNVS. .ASB1.
  5d40: 4d 0b a0 11 93 54 54 54 30 0a 31 70 43 44 52 41  M....TTT0.1pCDRA
  5d50: 41 53 42 31 a1 48 0a a0 1e 93 54 54 54 30 0a 32  ASB1.H....TTT0.2
  5d60: 70 47 44 52 56 41 53 42 31 70 41 53 42 31 88 54  pGDRVASB1pASB1.T
  5d70: 50 42 46 0a 02 00 a1 46 08 a0 11 93 54 54 54 30  PBF....F....TTT0
  5d80: 0a 53 70 47 43 56 56 41 53 42 31 a1 41 07 a0 1e  .SpGCVVASB1.A...
  5d90: 93 54 54 54 30 0a 54 70 47 48 54 56 41 53 42 31  .TTT0.TpGHTVASB1
  5da0: 70 41 53 42 31 88 54 50 42 46 0a 03 00 a1 4f 04  pASB1.TPBF....O.
  5db0: a0 11 93 54 54 54 30 0a 61 70 47 50 53 30 41 53  ...TTT0.apGPS0AS
  5dc0: 42 31 a1 3a a0 11 93 54 54 54 30 0a 56 70 47 53  B1.:...TTT0.VpGS
  5dd0: 42 56 41 53 42 31 a1 26 a0 11 93 54 54 54 30 0a  BVASB1.&...TTT0.
  5de0: 57 70 47 4e 31 38 41 53 42 31 a1 12 a0 08 93 54  WpGN18ASB1.....T
  5df0: 54 54 30 0a f0 a1 07 70 00 41 53 42 30 08 47 50  TT0....p.ASB0.GP
  5e00: 53 30 00 08 47 50 53 31 0a 41 14 40 44 53 49 54  S0..GPS1.A.@DSIT
  5e10: 33 03 08 54 54 54 30 00 70 7b 68 0b ff ff 00 54  3..TTT0.p{h....T
  5e20: 54 54 30 a0 3a 93 54 54 54 30 0a 11 a0 0c 7b 6a  TT0.:.TTT0....{j
  5e30: 0a 02 00 45 46 53 42 01 69 a0 24 7b 6a 01 00 53  ...EFSB.i.${j..S
  5e40: 4e 56 53 0b b8 a2 72 69 0a 64 00 a0 12 93 47 4e  NVS...ri.d....GN
  5e50: 56 53 0b 5c 45 01 53 4e 56 53 0b 5c 45 00 a1 4c  VS.\E.SNVS.\E..L
  5e60: 3e a0 41 07 93 54 54 54 30 0a 12 a0 14 7b 6a 0a  >.A..TTT0....{j.
  5e70: 02 00 70 69 43 56 49 44 53 41 47 50 0b 12 03 69  ..piCVIDSAGP...i
  5e80: a0 42 05 7b 6a 01 00 a0 1b 91 47 4e 56 53 0b 81  .B.{j.....GNVS..
  5e90: 17 92 7b 43 4f 43 53 0a 20 00 53 4e 56 53 0b e8  ..{COCS. .SNVS..
  5ea0: 92 75 69 a1 2f a0 14 94 69 0a 60 53 4e 56 53 0b  .ui./...i.`SNVS.
  5eb0: 50 83 74 69 0a 60 00 70 00 60 a1 10 53 4e 56 53  P.ti.`.p.`..SNVS
  5ec0: 0b 50 83 74 0a 60 69 00 70 01 60 53 4e 56 53 0b  .P.t.`i.p.`SNVS.
  5ed0: 82 17 60 a1 47 37 a0 49 0a 93 54 54 54 30 0a 13  ..`.G7.I..TTT0..
  5ee0: a0 40 09 7b 6a 0a 02 00 a0 4a 06 92 93 47 4f 44  .@.{j....J...GOD
  5ef0: 53 0a ff a0 35 92 95 47 4f 44 53 0a 04 79 74 47  S...5..GODS..ytG
  5f00: 4f 44 53 0a 04 00 0a 03 65 79 69 65 60 79 0a ff  ODS.....eyie`y..
  5f10: 65 61 80 61 61 7b 54 47 52 32 61 54 47 52 32 7d  ea.aa{TGR2aTGR2}
  5f20: 54 47 52 32 60 54 47 52 32 a1 29 79 47 4f 44 53  TGR2`TGR2.)yGODS
  5f30: 0a 03 65 79 69 65 60 79 0a ff 65 61 80 61 61 7b  ..eyie`y..ea.aa{
  5f40: 54 47 52 54 61 54 47 52 54 7d 54 47 52 54 60 54  TGRTaTGRT}TGRT`T
  5f50: 47 52 54 a1 1d 70 54 47 52 54 60 53 41 47 50 0b  GRT..pTGRT`SAGP.
  5f60: 13 03 60 70 54 47 52 32 60 53 41 47 50 0b ff 03  ..`pTGR2`SAGP...
  5f70: 60 a0 0e 7b 6a 01 00 53 4e 56 53 0b c0 63 75 69  `..{j..SNVS..cui
  5f80: a1 4a 2c a0 4b 06 93 54 54 54 30 0a 15 a0 0e 7b  .J,.K..TTT0....{
  5f90: 6a 0a 02 00 53 41 47 50 0b 15 03 69 a0 42 05 7b  j...SAGP...i.B.{
  5fa0: 6a 01 00 a0 1b 91 47 4e 56 53 0b 81 17 92 7b 43  j.....GNVS....{C
  5fb0: 4f 43 53 0a 20 00 53 4e 56 53 0b 08 93 75 69 a1  OCS. .SNVS...ui.
  5fc0: 2f a0 14 94 69 0a 60 53 4e 56 53 0b 58 83 74 69  /...i.`SNVS.X.ti
  5fd0: 0a 60 00 70 00 60 a1 10 53 4e 56 53 0b 58 83 74  .`.p.`..SNVS.X.t
  5fe0: 0a 60 69 00 70 01 60 53 4e 56 53 0b 83 17 60 a1  .`i.p.`SNVS...`.
  5ff0: 4b 25 a0 43 04 93 54 54 54 30 0a 17 53 4e 56 53  K%.C..TTT0..SNVS
  6000: 0b 20 83 69 a0 31 93 69 0a ff a0 2b 92 5b 23 5e  . .i.1.i...+.[#^
  6010: 5e 2e 45 43 30 5f 4d 55 45 43 ff ff 70 00 5e 5e  ^.EC0_MUEC..p.^^
  6020: 2e 45 43 30 5f 45 43 41 54 5b 27 5e 5e 2e 45 43  .EC0_ECAT['^^.EC
  6030: 30 5f 4d 55 45 43 a1 44 21 a0 4a 05 93 54 54 54  0_MUEC.D!.J..TTT
  6040: 30 0a 31 a0 40 05 7b 6a 01 00 a0 23 69 53 4e 56  0.1.@.{j...#iSNV
  6050: 53 0b 26 26 0a 02 53 4e 56 53 0b a0 35 72 69 0a  S.&&..SNVS..5ri.
  6060: 02 00 53 4e 56 53 0b 18 36 72 69 0a 03 00 a1 1a  ..SNVS..6ri.....
  6070: 53 4e 56 53 0b 26 26 00 53 4e 56 53 0b a0 35 0a  SNVS.&&.SNVS..5.
  6080: 03 53 4e 56 53 0b 18 36 00 7d 41 53 42 30 0a 02  .SNVS..6.}ASB0..
  6090: 41 53 42 30 a1 46 1b a0 38 93 54 54 54 30 0a 32  ASB0.F..8.TTT0.2
  60a0: a0 0b 7b 6a 0a 02 00 53 44 52 56 69 a0 23 7b 6a  ..{j...SDRVi.#{j
  60b0: 01 00 a0 0b 92 95 69 0a 14 74 69 0a 0f 60 a1 09  ......i..ti..`..
  60c0: 78 69 0a 05 61 60 75 60 53 4e 56 53 0b 60 83 60  xi..a`u`SNVS.`.`
  60d0: a1 4a 17 a0 23 93 54 54 54 30 0a 53 a0 0b 7b 6a  .J..#.TTT0.S..{j
  60e0: 0a 02 00 53 43 56 56 69 a0 0e 7b 6a 01 00 53 4e  ...SCVVi..{j..SN
  60f0: 56 53 0b 80 73 75 69 a1 43 15 a0 23 93 54 54 54  VS..sui.C..#.TTT
  6100: 30 0a 54 a0 0b 7b 6a 0a 02 00 53 48 54 56 69 a0  0.T..{j...SHTVi.
  6110: 0e 7b 6a 01 00 53 4e 56 53 0b 68 83 75 69 a1 4c  .{j..SNVS.h.ui.L
  6120: 12 a0 40 06 93 54 54 54 30 0a 61 a0 47 04 7b 6a  ..@..TTT0.a.G.{j
  6130: 0a 02 00 a0 39 92 5b 23 5e 5e 2e 45 43 30 5f 4d  ....9.[#^^.EC0_M
  6140: 55 45 43 ff ff 70 7b 5e 5e 2e 45 43 30 5f 46 47  UEC..p{^^.EC0_FG
  6150: 41 4d 0a fe 00 5e 5e 2e 45 43 30 5f 46 47 41 4d  AM...^^.EC0_FGAM
  6160: 5b 27 5e 5e 2e 45 43 30 5f 4d 55 45 43 70 69 47  ['^^.EC0_MUECpiG
  6170: 50 53 30 a0 0e 7b 6a 01 00 53 4e 56 53 0b 70 83  PS0..{j..SNVS.p.
  6180: 75 69 a1 48 0c a0 2a 93 54 54 54 30 0a 63 70 01  ui.H..*.TTT0.cp.
  6190: 47 46 4c 41 44 47 50 4e a0 0d 7b 69 01 00 53 4e  GFLADGPN..{i..SN
  61a0: 42 56 47 50 53 31 a1 09 53 4e 42 56 47 50 53 30  BVGPS1..SNBVGPS0
  61b0: a1 4a 09 a0 31 93 54 54 54 30 0a 67 70 69 60 a0  .J..1.TTT0.gpi`.
  61c0: 15 7b 69 0b 00 10 00 7b 60 0c ff ff fe ff 00 70  .{i....{`......p
  61d0: 60 47 50 53 31 a1 0f 7b 60 0c ff ff fe ff 00 70  `GPS1..{`......p
  61e0: 60 47 50 53 30 a1 45 06 a0 23 93 54 54 54 30 0a  `GPS0.E..#.TTT0.
  61f0: 56 a0 0b 7b 6a 0a 02 00 53 53 42 56 69 a0 0e 7b  V..{j...SSBVi..{
  6200: 6a 01 00 53 4e 56 53 0b 60 36 75 69 a1 3e a0 23  j..SNVS.`6ui.>.#
  6210: 93 54 54 54 30 0a 57 a0 0b 7b 6a 0a 02 00 53 4e  .TTT0.W..{j...SN
  6220: 31 38 69 a0 0e 7b 6a 01 00 53 4e 56 53 0b 63 36  18i..{j..SNVS.c6
  6230: 75 69 a1 18 a0 0e 93 54 54 54 30 0a f0 70 69 47  ui.....TTT0..piG
  6240: 4f 44 53 a1 07 70 00 41 53 42 30 14 1b 45 46 53  ODS..p.ASB0..EFS
  6250: 42 0a 70 00 60 a0 07 68 44 43 4d 4e 69 a1 07 70  B.p.`..hDCMNi..p
  6260: 47 43 4d 4e 60 a4 60 14 49 05 47 43 4d 4e 00 52  GCMN`.`.I.GCMN.R
  6270: 53 4d 42 0a d2 00 0a 1f 70 43 42 31 36 60 70 43  SMB.....pCB16`pC
  6280: 42 31 37 61 70 43 42 32 30 62 7a 62 0a 07 62 79  B17apCB20bzb..by
  6290: 61 0a 03 61 7d 61 62 61 7b 60 0a c0 62 7a 62 0a  a..a}aba{`..bzb.
  62a0: 05 62 7d 61 62 61 7b 60 0a 3f 60 77 60 0a 02 60  .b}aba{`.?`w`..`
  62b0: 77 61 0a 32 61 78 61 60 00 64 74 64 0a 64 60 a4  wa.2axa`.dtd.d`.
  62c0: 60 14 46 11 44 43 4d 4e 01 52 53 4d 42 0a d2 00  `.F.DCMN.RSMB...
  62d0: 0a 1f a0 35 7b 43 42 31 32 0a 80 00 7b 43 42 31  ...5{CB12...{CB1
  62e0: 36 0a 3f 60 7d 7d 7a 7b 43 42 31 36 0a c0 00 0a  6.?`}}z{CB16....
  62f0: 05 00 79 43 42 31 37 0a 03 00 00 7a 7b 43 42 32  ..yCB17....z{CB2
  6300: 30 0a 80 00 0a 07 00 61 a1 09 70 0a 0a 60 70 0a  0......a..p..`p.
  6310: 50 61 50 52 4d 4e 72 68 0a 64 00 7d 43 42 30 35  PaPRMNrh.d.}CB05
  6320: 0a 10 43 42 30 35 57 53 4d 42 0a d2 00 0a 06 78  ..CB05WSMB.....x
  6330: 77 7b 54 41 52 4d 0a 3f 00 61 00 60 00 62 7d 7b  w{TARM.?.a.`.b}{
  6340: 54 41 52 4d 0a 3f 00 7b 79 7b 62 0a 06 00 0a 05  TARM.?.{y{b.....
  6350: 00 0a ff 00 43 42 31 36 70 7b 7a 62 0a 03 00 0a  ....CB16p{zb....
  6360: ff 00 43 42 31 37 7d 7b 43 42 32 30 0a 7f 00 7b  ..CB17}{CB20...{
  6370: 79 7b 62 01 00 0a 07 00 0a ff 00 43 42 32 30 70  y{b........CB20p
  6380: 7d 43 42 31 32 0a 80 00 43 42 31 32 57 53 4d 42  }CB12...CB12WSMB
  6390: 0a d2 00 0a 15 7b 43 42 30 35 0c ef ff ff ff 43  .....{CB05.....C
  63a0: 42 30 35 57 53 4d 42 0a d2 00 0a 06 70 54 41 52  B05WSMB.....pTAR
  63b0: 4d 43 42 31 36 70 54 41 52 4e 43 42 31 37 7d 7b  MCB16pTARNCB17}{
  63c0: 43 42 32 30 0a 7f 00 54 41 52 44 43 42 32 30 57  CB20...TARDCB20W
  63d0: 53 4d 42 0a d2 00 0a 15 08 54 41 52 4d 00 08 54  SMB......TARM..T
  63e0: 41 52 4e 00 08 54 41 52 44 00 14 4f 05 50 52 4d  ARN..TARD..O.PRM
  63f0: 4e 01 70 0a 0a 60 a2 43 05 92 94 60 0a 19 78 77  N.p..`.C...`..xw
  6400: 68 79 60 01 00 00 0a 32 62 61 a0 3d 92 62 a0 39  hy`....2ba.=.b.9
  6410: 95 7a 61 0a 03 00 0b 00 01 7d 60 7b 79 7b 61 0a  .za......}`{y{a.
  6420: 06 00 0a 05 00 0a ff 00 54 41 52 4d 7b 7a 61 0a  ........TARM{za.
  6430: 03 00 0a ff 54 41 52 4e 7b 79 7b 61 01 00 0a 07  ....TARN{y{a....
  6440: 00 0a ff 54 41 52 44 a5 75 60 14 1b 45 50 43 49  ...TARD.u`..EPCI
  6450: 0a 70 00 60 a0 07 68 44 50 4d 4e 69 a1 07 70 47  .p.`..hDPMNi..pG
  6460: 50 4d 4e 60 a4 60 14 45 08 47 50 4d 4e 00 52 53  PMN`.`.E.GPMN.RS
  6470: 4d 42 0a d2 00 0a 1f 7b 43 42 32 38 0a 80 60 7a  MB.....{CB28..`z
  6480: 60 0a 07 60 7b 43 42 32 36 0a c0 61 7a 61 0a 05  `..`{CB26..aza..
  6490: 61 7b 43 42 32 37 0a ff 62 79 62 0a 03 62 72 60  a{CB27..byb..br`
  64a0: 61 60 72 60 62 60 7b 43 42 32 36 0a 3f 61 77 0b  a`r`b`{CB26.?aw.
  64b0: ee 37 60 62 78 62 61 00 63 78 63 0b e8 03 00 64  .7`bxba.cxc....d
  64c0: 77 64 0b e8 03 64 74 63 64 65 a0 0c 94 65 0b f4  wd...dtcde...e..
  64d0: 01 72 64 0b e8 03 64 78 64 0b e8 03 00 64 78 64  .rd...dxd....dxd
  64e0: 47 44 49 56 43 42 32 38 00 64 a4 64 14 40 08 44  GDIVCB28.d.d.@.D
  64f0: 50 4d 4e 01 52 53 4d 42 0a d2 00 0a 1f 77 68 0b  PMN.RSMB.....wh.
  6500: e8 03 60 77 60 47 44 49 56 43 42 32 38 60 43 43  ..`w`GDIVCB28`CC
  6510: 4d 4e 60 0b ee 37 70 7d 79 7b 56 43 4f 4e 01 00  MN`..7p}y{VCON..
  6520: 0a 07 00 43 42 32 38 00 60 70 60 43 42 32 38 70  ...CB28.`p`CB28p
  6530: 7b 56 43 4f 4d 0a 3f 00 43 42 32 36 70 7d 79 7a  {VCOM.?.CB26p}yz
  6540: 7b 56 43 4f 4e 0a 06 00 01 00 0a 06 00 43 42 32  {VCON........CB2
  6550: 36 00 60 70 60 43 42 32 36 7a 56 43 4f 4e 0a 03  6.`p`CB26zVCON..
  6560: 43 42 32 37 57 53 4d 42 0a d2 00 0a 1d 08 56 43  CB27WSMB......VC
  6570: 4f 4d 00 08 56 43 4f 4e 00 14 17 41 42 53 5f 02  OM..VCON...ABS_.
  6580: a0 09 95 68 69 a4 74 69 68 00 a1 06 a4 74 68 69  ...hi.tih....thi
  6590: 00 08 44 49 56 44 11 13 0a 10 02 03 05 09 04 06  ..DIVD..........
  65a0: 0a 12 08 0c 14 24 10 18 28 48 14 13 47 44 49 56  .....$..(H..GDIV
  65b0: 01 a4 83 88 44 49 56 44 7b 68 0a 0f 00 00 14 46  ....DIVD{h.....F
  65c0: 09 43 43 4d 4e 02 70 69 60 70 41 42 53 5f 68 69  .CCMN.pi`pABS_hi
  65d0: 61 70 0a 13 62 a2 4f 07 95 62 0a 19 72 78 77 68  ap..b.O..b..rxwh
  65e0: 62 00 69 00 00 0a 02 63 a0 0b 94 63 0b 00 08 70  b.i....c...c...p
  65f0: 0b 00 08 63 a0 22 94 78 77 68 62 00 69 00 00 0a  ...c.".xwhb.i...
  6600: 02 74 78 77 68 62 00 69 00 00 0a 02 64 a0 09 95  .txwhb.i....d...
  6610: 64 0a 02 70 0a 02 64 a1 05 70 0a 02 64 a2 35 92  d..p..d..p..d.5.
  6620: 94 64 63 70 78 77 69 64 00 62 00 00 60 70 41 42  .dcpxwid.b..`pAB
  6630: 53 5f 68 60 65 a0 1b 95 65 61 70 64 56 43 4f 4e  S_h`e...eapdVCON
  6640: 70 62 56 43 4f 4d 70 65 61 a0 07 95 65 0b 2c 01  pbVCOMpea...e.,.
  6650: a5 75 64 75 62 5b 80 53 49 4f 47 01 49 4f 31 42  .udub[.SIOG.IO1B
  6660: 0a 08 5b 81 2e 53 49 4f 47 01 47 50 31 58 08 47  ..[..SIOG.GP1X.G
  6670: 50 32 58 08 47 50 33 58 08 47 50 34 58 08 47 50  P2X.GP3X.GP4X.GP
  6680: 35 58 08 47 50 36 58 08 47 50 37 58 08 47 50 38  5X.GP6X.GP7X.GP8
  6690: 58 08 14 49 26 53 53 47 50 02 45 4e 46 47 0a 07  X..I&SSGP.ENFG..
  66a0: 78 68 0a 10 60 61 79 01 60 60 08 54 54 54 30 00  xh..`ay.``.TTT0.
  66b0: 70 61 54 54 54 30 a0 43 04 93 54 54 54 30 01 7d  paTTT0.C..TTT0.}
  66c0: 4f 50 43 30 60 4f 50 43 30 a0 18 69 7b 4f 50 43  OPC0`OPC0..i{OPC
  66d0: 38 80 60 00 4f 50 43 38 7d 47 50 31 58 60 47 50  8.`.OPC8}GP1X`GP
  66e0: 31 58 a1 17 7d 4f 50 43 38 60 4f 50 43 38 7b 47  1X..}OPC8`OPC8{G
  66f0: 50 31 58 80 60 00 47 50 31 58 a1 4d 1f a0 44 04  P1X.`.GP1X.M..D.
  6700: 93 54 54 54 30 0a 02 7d 4f 50 43 31 60 4f 50 43  .TTT0..}OPC1`OPC
  6710: 31 a0 18 69 7b 4f 50 43 39 80 60 00 4f 50 43 39  1..i{OPC9.`.OPC9
  6720: 7d 47 50 32 58 60 47 50 32 58 a1 17 7d 4f 50 43  }GP2X`GP2X..}OPC
  6730: 39 60 4f 50 43 39 7b 47 50 32 58 80 60 00 47 50  9`OPC9{GP2X.`.GP
  6740: 32 58 a1 45 1b a0 44 04 93 54 54 54 30 0a 03 7d  2X.E..D..TTT0..}
  6750: 4f 50 43 32 60 4f 50 43 32 a0 18 69 7b 4f 50 43  OPC2`OPC2..i{OPC
  6760: 41 80 60 00 4f 50 43 41 7d 47 50 33 58 60 47 50  A.`.OPCA}GP3X`GP
  6770: 33 58 a1 17 7d 4f 50 43 41 60 4f 50 43 41 7b 47  3X..}OPCA`OPCA{G
  6780: 50 33 58 80 60 00 47 50 33 58 a1 4d 16 a0 44 04  P3X.`.GP3X.M..D.
  6790: 93 54 54 54 30 0a 04 7d 4f 50 43 33 60 4f 50 43  .TTT0..}OPC3`OPC
  67a0: 33 a0 18 69 7b 4f 50 43 42 80 60 00 4f 50 43 42  3..i{OPCB.`.OPCB
  67b0: 7d 47 50 34 58 60 47 50 34 58 a1 17 7d 4f 50 43  }GP4X`GP4X..}OPC
  67c0: 42 60 4f 50 43 42 7b 47 50 34 58 80 60 00 47 50  B`OPCB{GP4X.`.GP
  67d0: 34 58 a1 45 12 a0 44 04 93 54 54 54 30 0a 05 7d  4X.E..D..TTT0..}
  67e0: 4f 50 43 34 60 4f 50 43 34 a0 18 69 7b 4f 50 43  OPC4`OPC4..i{OPC
  67f0: 43 80 60 00 4f 50 43 43 7d 47 50 35 58 60 47 50  C.`.OPCC}GP5X`GP
  6800: 35 58 a1 17 7d 4f 50 43 43 60 4f 50 43 43 7b 47  5X..}OPCC`OPCC{G
  6810: 50 35 58 80 60 00 47 50 35 58 a1 4d 0d a0 44 04  P5X.`.GP5X.M..D.
  6820: 93 54 54 54 30 0a 06 7d 4f 50 43 35 60 4f 50 43  .TTT0..}OPC5`OPC
  6830: 35 a0 18 69 7b 4f 50 43 44 80 60 00 4f 50 43 44  5..i{OPCD.`.OPCD
  6840: 7d 47 50 36 58 60 47 50 36 58 a1 17 7d 4f 50 43  }GP6X`GP6X..}OPC
  6850: 44 60 4f 50 43 44 7b 47 50 36 58 80 60 00 47 50  D`OPCD{GP6X.`.GP
  6860: 36 58 a1 45 09 a0 44 04 93 54 54 54 30 0a 07 7d  6X.E..D..TTT0..}
  6870: 4f 50 43 36 60 4f 50 43 36 a0 18 69 7b 4f 50 43  OPC6`OPC6..i{OPC
  6880: 45 80 60 00 4f 50 43 45 7d 47 50 37 58 60 47 50  E.`.OPCE}GP7X`GP
  6890: 37 58 a1 17 7d 4f 50 43 45 60 4f 50 43 45 7b 47  7X..}OPCE`OPCE{G
  68a0: 50 37 58 80 60 00 47 50 37 58 a1 4d 04 a0 44 04  P7X.`.GP7X.M..D.
  68b0: 93 54 54 54 30 0a 08 7d 4f 50 43 37 60 4f 50 43  .TTT0..}OPC7`OPC
  68c0: 37 a0 18 69 7b 4f 50 43 46 80 60 00 4f 50 43 46  7..i{OPCF.`.OPCF
  68d0: 7d 47 50 38 58 60 47 50 38 58 a1 17 7d 4f 50 43  }GP8X`GP8X..}OPC
  68e0: 46 60 4f 50 43 46 7b 47 50 38 58 80 60 00 47 50  F`OPCF{GP8X.`.GP
  68f0: 38 58 a1 05 70 0a ff 60 45 58 46 47 14 4a 0b 47  8X..p..`EXFG.J.G
  6900: 53 47 50 01 45 4e 46 47 0a 07 78 68 0a 10 60 61  SGP.ENFG..xh..`a
  6910: 08 54 54 54 30 00 70 61 54 54 54 30 a0 0d 93 54  .TTT0.paTTT0...T
  6920: 54 54 30 01 70 4f 50 43 38 62 a1 40 08 a0 0e 93  TT0.pOPC8b.@....
  6930: 54 54 54 30 0a 02 70 4f 50 43 39 62 a1 4e 06 a0  TTT0..pOPC9b.N..
  6940: 0e 93 54 54 54 30 0a 03 70 4f 50 43 41 62 a1 4c  ..TTT0..pOPCAb.L
  6950: 05 a0 0e 93 54 54 54 30 0a 04 70 4f 50 43 42 62  ....TTT0..pOPCBb
  6960: a1 4a 04 a0 0e 93 54 54 54 30 0a 05 70 4f 50 43  .J....TTT0..pOPC
  6970: 43 62 a1 38 a0 0e 93 54 54 54 30 0a 06 70 4f 50  Cb.8...TTT0..pOP
  6980: 43 44 62 a1 27 a0 0e 93 54 54 54 30 0a 07 70 4f  CDb.'...TTT0..pO
  6990: 50 43 45 62 a1 16 a0 0e 93 54 54 54 30 0a 08 70  PCEb.....TTT0..p
  69a0: 4f 50 43 46 62 a1 05 70 0a ff 62 45 58 46 47 a4  OPCFb..p..bEXFG.
  69b0: 7b 7a 62 60 00 01 00 08 45 43 54 42 12 1e 04 12  {zb`....ECTB....
  69c0: 06 02 0a 40 0a 80 12 06 02 0a 60 0a 81 12 06 02  ...@......`.....
  69d0: 0a b0 0a 82 12 06 02 0a 40 0a 83 14 46 0c 53 45  ........@...F.SE
  69e0: 43 56 02 70 01 60 a0 08 7b 69 01 00 70 00 60 7a  CV.p.`..{i..p.`z
  69f0: 69 01 61 72 61 83 88 83 88 45 43 54 42 68 00 00  i.ara....ECTBh..
  6a00: 00 61 53 53 47 50 83 88 83 88 45 43 54 42 68 00  .aSSGP....ECTBh.
  6a10: 01 00 60 a0 4e 08 92 5b 23 5e 5e 2e 45 43 30 5f  ..`.N..[#^^.EC0_
  6a20: 4d 55 45 43 ff ff 08 54 54 54 30 00 70 68 54 54  MUEC...TTT0.phTT
  6a30: 54 30 a0 14 93 54 54 54 30 00 70 61 5e 5e 2e 45  T0...TTT0.pa^^.E
  6a40: 43 30 5f 44 41 30 43 a1 4d 04 a0 14 93 54 54 54  C0_DA0C.M....TTT
  6a50: 30 01 70 61 5e 5e 2e 45 43 30 5f 44 41 31 43 a1  0.pa^^.EC0_DA1C.
  6a60: 35 a0 15 93 54 54 54 30 0a 02 70 61 5e 5e 2e 45  5...TTT0..pa^^.E
  6a70: 43 30 5f 44 41 32 43 a1 1d a0 15 93 54 54 54 30  C0_DA2C.....TTT0
  6a80: 0a 03 70 61 5e 5e 2e 45 43 30 5f 44 41 33 43 a1  ..pa^^.EC0_DA3C.
  6a90: 05 70 0a ff 61 5b 27 5e 5e 2e 45 43 30 5f 4d 55  .p..a['^^.EC0_MU
  6aa0: 45 43 14 4f 0b 47 45 43 56 01 a0 4e 08 92 5b 23  EC.O.GECV..N..[#
  6ab0: 5e 5e 2e 45 43 30 5f 4d 55 45 43 ff ff 08 54 54  ^^.EC0_MUEC...TT
  6ac0: 54 30 00 70 68 54 54 54 30 a0 14 93 54 54 54 30  T0.phTTT0...TTT0
  6ad0: 00 70 5e 5e 2e 45 43 30 5f 44 41 30 53 60 a1 4d  .p^^.EC0_DA0S`.M
  6ae0: 04 a0 14 93 54 54 54 30 01 70 5e 5e 2e 45 43 30  ....TTT0.p^^.EC0
  6af0: 5f 44 41 31 53 60 a1 35 a0 15 93 54 54 54 30 0a  _DA1S`.5...TTT0.
  6b00: 02 70 5e 5e 2e 45 43 30 5f 44 41 32 53 60 a1 1d  .p^^.EC0_DA2S`..
  6b10: a0 15 93 54 54 54 30 0a 03 70 5e 5e 2e 45 43 30  ...TTT0..p^^.EC0
  6b20: 5f 44 41 33 53 60 a1 05 70 0a ff 60 5b 27 5e 5e  _DA3S`..p..`['^^
  6b30: 2e 45 43 30 5f 4d 55 45 43 74 60 83 88 83 88 45  .EC0_MUECt`....E
  6b40: 43 54 42 68 00 00 00 60 79 60 01 60 a0 13 47 53  CTBh...`y`.`..GS
  6b50: 47 50 83 88 83 88 45 43 54 42 68 00 01 00 75 60  GP....ECTBh...u`
  6b60: a4 60 14 44 04 53 44 52 56 01 a0 3a 80 93 68 83  .`.D.SDRV..:..h.
  6b70: 88 54 50 42 46 0a 02 00 00 70 68 88 54 50 42 46  .TPBF....ph.TPBF
  6b80: 0a 02 00 a0 0b 92 95 68 0a 14 74 68 0a 14 60 a1  .......h..th..`.
  6b90: 0c 78 68 0a 05 61 60 74 0a 44 60 60 57 32 59 54  .xh..a`t.D``W2YT
  6ba0: 0a 6a 0a 03 60 a4 01 14 33 47 44 52 56 00 70 52  .j..`...3GDRV.pR
  6bb0: 32 59 54 0a 6a 0a 03 60 70 60 61 a0 11 7b 60 0a  2YT.j..`p`a..{`.
  6bc0: 40 00 70 83 88 54 50 42 46 0a 02 00 60 a1 0b 7b  @.p..TPBF...`..{
  6bd0: 61 0a 3f 60 72 60 0a 14 60 a4 60 14 20 53 48 54  a.?`r`..`.`. SHT
  6be0: 56 01 a0 17 80 93 68 83 88 54 50 42 46 0a 03 00  V.....h..TPBF...
  6bf0: 00 57 32 59 54 0a 6a 0a 02 68 a4 01 14 12 47 48  .W2YT.j..h....GH
  6c00: 54 56 00 70 52 32 59 54 0a 6a 0a 02 60 a4 60 14  TV.pR2YT.j..`.`.
  6c10: 2d 53 4e 42 56 01 a0 24 80 93 68 83 88 54 50 42  -SNBV..$..h..TPB
  6c20: 46 0a 04 00 00 57 32 59 54 0a 6a 01 68 70 68 88  F....W2YT.j.hph.
  6c30: 54 50 42 46 0a 04 00 5b 22 0a 64 a4 01 14 11 47  TPBF...[".d....G
  6c40: 4e 42 56 00 70 52 32 59 54 0a 6a 01 60 a4 60 08  NBV.pR2YT.j.`.`.
  6c50: 54 53 42 56 12 0f 02 12 05 02 0a 22 01 12 06 02  TSBV......."....
  6c60: 0a 21 0a 02 14 4f 04 53 53 42 56 01 a0 09 94 68  .!...O.SSBV....h
  6c70: 0a 03 72 68 01 68 70 01 60 a0 08 7b 68 01 00 70  ..rh.hp.`..{h..p
  6c80: 00 60 53 53 47 50 83 88 83 88 54 53 42 56 00 00  .`SSGP....TSBV..
  6c90: 00 00 60 7a 68 01 61 70 01 60 a0 08 7b 61 01 00  ..`zh.ap.`..{a..
  6ca0: 70 00 60 53 53 47 50 83 88 83 88 54 53 42 56 01  p.`SSGP....TSBV.
  6cb0: 00 00 00 60 14 4e 04 47 53 42 56 00 70 00 60 a0  ...`.N.GSBV.p.`.
  6cc0: 20 47 53 47 50 83 88 83 88 54 53 42 56 00 00 00   GSGP....TSBV...
  6cd0: 00 72 83 88 83 88 54 53 42 56 00 00 01 00 60 60  .r....TSBV....``
  6ce0: a0 20 47 53 47 50 83 88 83 88 54 53 42 56 01 00  . GSGP....TSBV..
  6cf0: 00 00 72 83 88 83 88 54 53 42 56 01 00 01 00 60  ..r....TSBV....`
  6d00: 60 a4 60 08 54 4e 31 38 12 08 01 12 05 02 0a 17  `.`.TN18........
  6d10: 01 14 2d 53 4e 31 38 01 a0 09 94 68 0a 03 72 68  ..-SN18....h..rh
  6d20: 01 68 70 01 60 a0 08 7b 68 01 00 70 00 60 53 53  .hp.`..{h..p.`SS
  6d30: 47 50 83 88 83 88 54 4e 31 38 00 00 00 00 60 14  GP....TN18....`.
  6d40: 2c 47 4e 31 38 00 70 00 60 a0 20 47 53 47 50 83  ,GN18.p.`. GSGP.
  6d50: 88 83 88 54 4e 31 38 00 00 00 00 72 83 88 83 88  ...TN18....r....
  6d60: 54 4e 31 38 00 00 01 00 60 60 a4 60 08 47 43 56  TN18....``.`.GCV
  6d70: 54 12 0f 02 12 05 02 0a 30 01 12 06 02 0a 27 0a  T.......0.....'.
  6d80: 02 14 45 04 53 43 56 56 01 70 01 60 a0 08 7b 68  ..E.SCVV.p.`..{h
  6d90: 01 00 70 00 60 53 53 47 50 83 88 83 88 47 43 56  ..p.`SSGP....GCV
  6da0: 54 00 00 00 00 60 7a 68 01 61 70 01 60 a0 08 7b  T....`zh.ap.`..{
  6db0: 61 01 00 70 00 60 53 53 47 50 83 88 83 88 47 43  a..p.`SSGP....GC
  6dc0: 56 54 01 00 00 00 60 14 4e 04 47 43 56 56 00 70  VT....`.N.GCVV.p
  6dd0: 00 60 a0 20 47 53 47 50 83 88 83 88 47 43 56 54  .`. GSGP....GCVT
  6de0: 00 00 00 00 72 83 88 83 88 47 43 56 54 00 00 01  ....r....GCVT...
  6df0: 00 60 60 a0 20 47 53 47 50 83 88 83 88 47 43 56  .``. GSGP....GCV
  6e00: 54 01 00 00 00 72 83 88 83 88 47 43 56 54 01 00  T....r....GCVT..
  6e10: 01 00 60 60 a4 60 14 14 57 42 59 54 03 7b 68 0a  ..``.`..WBYT.{h.
  6e20: fe 68 41 53 43 4d 68 69 6a 0a 08 14 14 57 32 59  .hASCMhij....W2Y
  6e30: 54 03 7b 68 0a fe 68 41 32 43 4d 68 69 6a 0a 08  T.{h..hA2CMhij..
  6e40: 14 18 52 42 59 54 02 7d 68 01 68 a4 7b 41 53 43  ..RBYT.}h.h.{ASC
  6e50: 4d 68 69 00 0a 08 0a ff 00 14 18 52 32 59 54 02  Mhi........R2YT.
  6e60: 7d 68 01 68 a4 7b 41 32 43 4d 68 69 00 0a 08 0a  }h.h.{A2CMhi....
  6e70: ff 00 5b 80 53 4d 52 47 01 53 4d 42 30 0a 30 5b  ..[.SMRG.SMB0.0[
  6e80: 81 45 05 53 4d 52 47 01 48 53 54 53 08 53 53 54  .E.SMRG.HSTS.SST
  6e90: 53 08 48 53 54 43 08 48 43 4d 44 08 48 41 44 52  S.HSTC.HCMD.HADR
  6ea0: 08 48 44 54 30 08 48 44 54 31 08 42 4c 4b 44 08  .HDT0.HDT1.BLKD.
  6eb0: 00 40 0c 48 32 54 53 08 53 32 54 53 08 48 32 54  .@.H2TS.S2TS.H2T
  6ec0: 43 08 48 32 4d 44 08 48 32 44 52 08 48 32 54 30  C.H2MD.H2DR.H2T0
  6ed0: 08 48 32 54 31 08 14 47 0b 41 53 43 4d 0c 70 0a  .H2T1..G.ASCM.p.
  6ee0: 05 60 a2 49 0a 76 60 70 0a 1e 48 53 54 53 5b 21  .`.I.v`p..HSTS[!
  6ef0: 0a 0a a2 15 90 7b 48 53 54 53 01 00 01 70 0a 1e  .....{HSTS...p..
  6f00: 48 53 54 53 5b 21 0a 0a 70 69 48 43 4d 44 5b 21  HSTS[!..piHCMD[!
  6f10: 0a 0a 70 68 48 41 44 52 5b 21 0a 0a 7b 68 01 62  ..phHADR[!..{h.b
  6f20: 70 6b 48 53 54 43 5b 21 0a 0a 70 6a 48 44 54 30  pkHSTC[!..pjHDT0
  6f30: 5b 21 0a 0a 70 0a 1e 48 53 54 53 5b 21 0a 0a a2  [!..p..HSTS[!...
  6f40: 15 90 7b 48 53 54 53 01 00 01 70 0a 1e 48 53 54  ..{HSTS...p..HST
  6f50: 53 5b 21 0a 0a 7d 48 53 54 43 0a 40 48 53 54 43  S[!..}HSTC.@HSTC
  6f60: 5b 21 0a 0a 70 0b ff ff 61 a2 0e 93 7b 48 53 54  [!..p...a...{HST
  6f70: 53 01 00 01 5b 21 0a 14 a0 0b 7b 48 53 54 53 0a  S...[!....{HSTS.
  6f80: 1c 00 a4 ff a0 07 62 a4 48 44 54 30 a4 ff 14 4b  ......b.HDT0...K
  6f90: 0b 41 32 43 4d 0c 70 0a 05 60 a2 4d 0a 76 60 70  .A2CM.p..`.M.v`p
  6fa0: 0b ff ff 61 a2 0f 90 7b 48 32 54 53 01 00 76 61  ...a...{H2TS..va
  6fb0: 5b 21 0a 0a 70 0a 1e 48 32 54 53 5b 21 0a 0a 70  [!..p..H2TS[!..p
  6fc0: 69 48 32 4d 44 5b 21 0a 0a 70 68 48 32 44 52 5b  iH2MD[!..phH2DR[
  6fd0: 21 0a 0a 70 6b 48 32 54 43 5b 21 0a 0a 70 6a 48  !..pkH2TC[!..pjH
  6fe0: 32 54 30 5b 21 0a 0a 7d 48 32 54 43 0a 40 48 32  2T0[!..}H2TC.@H2
  6ff0: 54 43 5b 21 0a 0a 70 0b ff ff 61 a2 18 76 61 a0  TC[!..p...a..va.
  7000: 0f 93 7b 48 32 54 53 0a 7f 00 00 5b 21 0a 0a a1  ..{H2TS....[!...
  7010: 04 70 01 61 70 0b ff ff 61 a2 17 76 61 a0 0e 90  .p.ap...a..va...
  7020: 7b 48 32 54 53 01 00 01 5b 21 0a 0a a1 04 70 01  {H2TS...[!....p.
  7030: 61 a0 0a 7b 68 01 00 a4 48 32 54 30 a0 0b 90 48  a..{h...H2T0...H
  7040: 32 54 53 0a 02 70 01 60 a4 ff 14 4b 11 56 44 4c  2TS..p.`...K.VDL
  7050: 43 09 a0 4c 09 93 47 4e 56 53 0b c8 44 0a 05 a0  C..L..GNVS..D...
  7060: 45 04 93 68 01 5e 5e 2e 45 43 30 5f 45 43 42 57  E..h.^^.EC0_ECBW
  7070: 0a 40 0a 0a 00 5e 5e 2e 45 43 30 5f 45 43 42 57  .@...^^.EC0_ECBW
  7080: 0a 40 0a 0b 00 5e 5e 2e 45 43 30 5f 45 43 42 57  .@...^^.EC0_ECBW
  7090: 0a 40 0a 0c 00 5e 5e 2e 45 43 30 5f 45 43 42 57  .@...^^.EC0_ECBW
  70a0: 0a 40 0a 0d 00 a1 46 04 5e 5e 2e 45 43 30 5f 45  .@....F.^^.EC0_E
  70b0: 43 42 57 0a 40 0a 0a 0a 06 5e 5e 2e 45 43 30 5f  CBW.@....^^.EC0_
  70c0: 45 43 42 57 0a 40 0a 0b 0a 06 5e 5e 2e 45 43 30  ECBW.@....^^.EC0
  70d0: 5f 45 43 42 57 0a 40 0a 0c 0a 06 5e 5e 2e 45 43  _ECBW.@....^^.EC
  70e0: 30 5f 45 43 42 57 0a 40 0a 0d 0a 06 70 01 60 a1  0_ECBW.@....p.`.
  70f0: 45 04 5e 5e 2e 45 43 30 5f 45 43 42 57 0a 40 0a  E.^^.EC0_ECBW.@.
  7100: 0a 00 5e 5e 2e 45 43 30 5f 45 43 42 57 0a 40 0a  ..^^.EC0_ECBW.@.
  7110: 0b 00 5e 5e 2e 45 43 30 5f 45 43 42 57 0a 40 0a  ..^^.EC0_ECBW.@.
  7120: 0c 00 5e 5e 2e 45 43 30 5f 45 43 42 57 0a 40 0a  ..^^.EC0_ECBW.@.
  7130: 0d 00 70 68 60 79 60 0a 04 60 70 5e 5e 2e 45 43  ..ph`y`..`p^^.EC
  7140: 30 5f 45 43 42 52 0a 40 0a 19 61 7b 61 0c ef ff  0_ECBR.@..a{a...
  7150: ff ff 61 5e 5e 2e 45 43 30 5f 45 43 42 57 0a 40  ..a^^.EC0_ECBW.@
  7160: 0a 19 7d 61 60 00 14 47 05 56 4e 4c 43 09 5e 5e  ..}a`..G.VNLC.^^
  7170: 2e 45 43 30 5f 45 43 42 57 0a 40 0a 14 00 5e 5e  .EC0_ECBW.@...^^
  7180: 2e 45 43 30 5f 45 43 42 57 0a 40 0a 15 00 79 68  .EC0_ECBW.@...yh
  7190: 01 60 70 5e 5e 2e 45 43 30 5f 45 43 42 52 0a 40  .`p^^.EC0_ECBR.@
  71a0: 0a 19 61 7b 61 0c fd ff ff ff 61 5e 5e 2e 45 43  ..a{a.....a^^.EC
  71b0: 30 5f 45 43 42 57 0a 40 0a 19 7d 61 60 00 14 11  0_ECBW.@..}a`...
  71c0: 52 53 4d 42 03 7d 68 01 68 52 57 53 4d 68 69 6a  RSMB.}h.hRWSMhij
  71d0: 14 12 57 53 4d 42 03 7b 68 0a fe 68 52 57 53 4d  ..WSMB.{h..hRWSM
  71e0: 68 69 6a 14 42 12 52 57 53 4d 03 70 0a 1e 48 53  hij.B.RWSM.p..HS
  71f0: 54 53 5b 21 0a 0a 70 00 60 a2 26 7b 48 53 54 53  TS[!..p.`.&{HSTS
  7200: 01 00 70 0a 1e 48 53 54 53 5b 21 0a 0a 75 60 a0  ..p..HSTS[!..u`.
  7210: 10 93 60 0a ff 7d 48 53 54 43 0a 02 48 53 54 43  ..`..}HSTC..HSTC
  7220: 70 00 60 a2 26 7b 53 53 54 53 01 00 70 0a 1e 53  p.`.&{SSTS..p..S
  7230: 53 54 53 5b 21 0a 0a 75 60 a0 10 93 60 0a ff 7d  STS[!..u`...`..}
  7240: 53 53 54 53 0a 02 48 53 54 43 70 69 48 43 4d 44  SSTS..HSTCpiHCMD
  7250: 5b 21 0a 0a 70 68 48 41 44 52 5b 21 0a 0a 70 0a  [!..phHADR[!..p.
  7260: 14 48 53 54 43 5b 21 0a 0a 70 48 53 54 43 61 5b  .HSTC[!..pHSTCa[
  7270: 21 0a 0a 70 6a 48 44 54 30 5b 21 0a 0a a0 21 92  !..pjHDT0[!...!.
  7280: 7b 68 01 00 70 6a 61 70 00 62 a2 14 92 95 61 62  {h..pjap.b....ab
  7290: 70 83 88 43 4c 4b 42 62 00 42 4c 4b 44 75 62 70  p..CLKBb.BLKDubp
  72a0: 0a 1e 48 53 54 53 5b 21 0a 0a a2 13 7b 48 53 54  ..HSTS[!....{HST
  72b0: 53 01 00 70 0a 1e 48 53 54 53 5b 21 0a 0a 7d 48  S..p..HSTS[!..}H
  72c0: 53 54 43 0a 40 48 53 54 43 5b 21 0a 0a a2 0c 7b  STC.@HSTC[!....{
  72d0: 48 53 54 53 01 00 5b 21 0a 14 a0 0b 7b 48 53 54  HSTS..[!....{HST
  72e0: 53 0a 1c 00 a4 ff a0 1f 7b 68 01 00 70 6a 61 70  S.......{h..pjap
  72f0: 00 62 a2 13 92 95 61 62 70 42 4c 4b 44 88 43 4c  .b....abpBLKD.CL
  7300: 4b 42 62 00 75 62 10 4a 14 2f 04 5f 53 42 5f 50  KBb.ub.J./._SB_P
  7310: 43 49 30 53 42 52 47 41 53 4f 43 08 47 34 54 30  CI0SBRGASOC.G4T0
  7320: 12 20 04 0c 10 00 07 04 0d 43 50 55 20 51 2d 46  . .......CPU Q-F
  7330: 41 4e 20 43 6f 6e 74 72 6f 6c 00 0c 00 00 00 80  AN Control......
  7340: 00 08 47 34 54 31 12 44 04 09 0c 11 00 08 04 0d  ..G4T1.D........
  7350: 43 50 55 20 51 2d 46 41 4e 20 50 72 6f 66 69 6c  CPU Q-FAN Profil
  7360: 65 00 0c 01 00 10 00 00 0a 04 0d 54 75 72 62 6f  e..........Turbo
  7370: 00 0d 53 74 61 6e 64 61 72 64 00 0d 53 69 6c 65  ..Standard..Sile
  7380: 6e 74 00 0d 4d 61 6e 75 61 6c 00 08 47 52 50 34  nt..Manual..GRP4
  7390: 12 0a 02 47 34 54 30 47 34 54 31 14 4c 04 47 49  ...G4T0G4T1.L.GI
  73a0: 54 34 01 08 54 54 54 30 00 70 7b 68 0b ff ff 00  T4..TTT0.p{h....
  73b0: 54 54 54 30 a0 14 93 54 54 54 30 0a 10 70 47 4e  TTT0...TTT0..pGN
  73c0: 56 53 0b 70 17 41 53 42 31 a1 1e a0 14 93 54 54  VS.p.ASB1.....TT
  73d0: 54 30 0a 11 70 47 4e 56 53 0b a8 26 41 53 42 31  T0..pGNVS..&ASB1
  73e0: a1 07 70 00 41 53 42 30 14 48 06 53 49 54 34 03  ..p.ASB0.H.SIT4.
  73f0: 08 54 54 54 30 00 70 7b 68 0b ff ff 00 54 54 54  .TTT0.p{h....TTT
  7400: 30 a0 22 93 54 54 54 30 0a 10 a0 19 92 93 47 4e  0.".TTT0......GN
  7410: 56 53 0b 70 17 69 a0 0d 7b 6a 01 00 53 4e 56 53  VS.p.i..{j..SNVS
  7420: 0b 70 17 69 a1 2c a0 22 93 54 54 54 30 0a 11 a0  .p.i.,.".TTT0...
  7430: 19 92 93 47 4e 56 53 0b a8 26 69 a0 0d 7b 6a 01  ...GNVS..&i..{j.
  7440: 00 53 4e 56 53 0b a8 26 69 a1 07 70 00 41 53 42  .SNVS..&i..p.ASB
  7450: 30 10 8d 12 01 2f 04 5f 53 42 5f 50 43 49 30 53  0..../._SB_PCI0S
  7460: 42 52 47 41 53 4f 43 08 47 35 54 30 12 1e 07 0c  BRGASOC.G5T0....
  7470: 00 00 08 05 0d 41 49 20 50 72 6f 66 69 6c 65 00  .....AI Profile.
  7480: 00 00 0a 02 0d 41 75 74 6f 00 00 08 47 35 54 32  .....Auto...G5T2
  7490: 12 3c 08 0c 02 00 08 05 0d 41 49 20 50 72 6f 66  .<.......AI Prof
  74a0: 69 6c 65 20 4b 65 79 00 00 00 0a 03 0d 50 65 72  ile Key......Per
  74b0: 66 6f 72 6d 61 6e 63 65 00 0d 53 75 70 65 72 69  formance..Superi
  74c0: 6f 72 00 0d 55 6c 74 69 6d 61 74 65 00 08 47 35  or..Ultimate..G5
  74d0: 54 33 12 1d 07 0c 03 00 08 05 0d 41 75 74 6f 20  T3.........Auto 
  74e0: 54 75 6e 65 00 00 00 0a 03 0d 41 75 74 6f 00 00  Tune......Auto..
  74f0: 08 47 35 54 34 12 1b 07 0c 04 00 08 05 0d 45 5a  .G5T4.........EZ
  7500: 20 54 75 6e 65 00 00 00 0a 03 0d 41 75 74 6f 00   Tune......Auto.
  7510: 00 08 47 35 54 35 12 1d 07 0c 05 00 08 05 0d 46  ..G5T5.........F
  7520: 61 73 74 20 54 75 6e 65 00 00 00 0a 03 0d 41 75  ast Tune......Au
  7530: 74 6f 00 00 08 47 35 54 36 12 23 07 0c 06 00 08  to...G5T6.#.....
  7540: 05 0d 41 4d 44 20 54 75 72 62 6f 20 52 61 74 69  ..AMD Turbo Rati
  7550: 6f 00 00 00 0a 03 0d 41 75 74 6f 00 00 08 47 35  o......Auto...G5
  7560: 47 30 12 26 07 0c 60 00 08 05 0d 47 50 55 20 42  G0.&..`....GPU B
  7570: 6f 6f 73 74 65 72 20 46 75 6e 63 74 69 6f 6e 00  ooster Function.
  7580: 0c 00 00 00 40 00 00 00 00 08 47 35 47 31 12 1b  ....@.....G5G1..
  7590: 07 0c 61 00 08 05 0d 47 50 55 20 50 53 20 43 4f  ..a....GPU PS CO
  75a0: 55 4e 54 00 00 00 00 00 0a 02 08 47 52 50 35 12  UNT........GRP5.
  75b0: 22 08 47 35 54 30 47 35 54 32 47 35 54 33 47 35  ".G5T0G5T2G5T3G5
  75c0: 54 34 47 35 54 35 47 35 54 36 47 35 47 30 47 35  T4G5T5G5T6G5G0G5
  75d0: 47 31 08 4e 42 43 52 00 08 44 52 41 4f 00 08 4f  G1.NBCR..DRAO..O
  75e0: 42 49 44 00 08 41 54 46 47 00 14 47 0d 47 49 54  BID..ATFG..G.GIT
  75f0: 35 02 08 54 54 54 30 00 70 7b 68 0b ff ff 00 54  5..TTT0.p{h....T
  7600: 54 54 30 a0 0d 93 54 54 54 30 00 70 01 41 53 42  TT0...TTT0.p.ASB
  7610: 31 a1 40 0b a0 19 93 54 54 54 30 0a 02 55 44 42  1.@....TTT0..UDB
  7620: 46 69 4d 56 42 46 69 70 0a 05 41 53 42 31 a1 43  FiMVBFip..ASB1.C
  7630: 09 a0 14 93 54 54 54 30 0a 03 41 54 55 4e 69 70  ....TTT0..ATUNip
  7640: 0a 05 41 53 42 31 a1 4b 07 a0 14 93 54 54 54 30  ..ASB1.K....TTT0
  7650: 0a 04 45 53 59 54 69 70 0a 05 41 53 42 31 a1 43  ..ESYTip..ASB1.C
  7660: 06 a0 13 93 54 54 54 30 0a 05 43 52 42 42 70 0a  ....TTT0..CRBBp.
  7670: 05 41 53 42 31 a1 4c 04 a0 13 93 54 54 54 30 0a  .ASB1.L....TTT0.
  7680: 06 54 55 52 52 70 0a 05 41 53 42 31 a1 35 a0 14  .TURRp..ASB1.5..
  7690: 93 54 54 54 30 0a 60 55 47 50 42 69 70 0a 05 41  .TTT0.`UGPBip..A
  76a0: 53 42 31 a1 1e a0 14 93 54 54 54 30 0a 61 55 44  SB1.....TTT0.aUD
  76b0: 42 32 69 70 0a 05 41 53 42 31 a1 07 70 00 41 53  B2ip..ASB1..p.AS
  76c0: 42 30 14 2d 53 49 54 35 03 08 54 54 54 30 00 70  B0.-SIT5..TTT0.p
  76d0: 7b 68 0b ff ff 00 54 54 54 30 a0 0d 93 54 54 54  {h....TTT0...TTT
  76e0: 30 00 70 00 41 53 42 30 a1 07 70 00 41 53 42 30  0.p.ASB0..p.ASB0
  76f0: 08 46 41 53 54 12 12 06 0c 11 00 01 03 0a 6e 0c  .FAST.........n.
  7700: 31 00 08 03 0a 02 ff ff 14 45 1c 43 52 42 42 00  1........E.CRBB.
  7710: 53 4e 56 53 0b 3c 45 0a 08 53 4e 56 53 0b 4c 45  SNVS.<E..SNVS.LE
  7720: 0a 05 53 4e 56 53 0b 50 45 0a 05 53 4e 56 53 0b  ..SNVS.PE..SNVS.
  7730: 78 54 0a 0a 70 47 44 4d 46 60 a0 12 92 95 60 0b  xT..pGDMF`....`.
  7740: 40 06 70 0a 03 88 46 41 53 54 0a 03 00 a1 36 a0  @.p...FAST....6.
  7750: 34 95 60 0b 34 05 70 01 88 46 41 53 54 0a 03 00  4.`.4.p..FAST...
  7760: 53 4e 56 53 0b 3c 45 0a 05 53 4e 56 53 0b 4c 45  SNVS.<E..SNVS.LE
  7770: 0a 02 53 4e 56 53 0b 50 45 0a 02 53 4e 56 53 0b  ..SNVS.PE..SNVS.
  7780: 78 54 0a 04 70 0a 08 4f 42 49 44 70 00 60 70 74  xT..p..OBIDp.`pt
  7790: 83 88 41 54 46 42 46 43 50 55 00 0a 64 00 88 46  ..ATFBFCPU..d..F
  77a0: 41 53 54 01 00 a2 4b 08 92 93 83 88 46 41 53 54  AST...K.....FAST
  77b0: 60 00 ff 53 54 42 46 83 88 46 41 53 54 60 00 4f  `..STBF..FAST`.O
  77c0: 42 49 44 72 4f 42 49 44 0a 04 4f 42 49 44 53 54  BIDrOBID..OBIDST
  77d0: 42 46 83 88 46 41 53 54 72 60 01 00 00 4f 42 49  BF..FASTr`...OBI
  77e0: 44 72 4f 42 49 44 0a 04 4f 42 49 44 a0 1f 93 83  DrOBID..OBID....
  77f0: 88 46 41 53 54 60 00 0c 13 00 06 03 70 83 88 46  .FAST`......p..F
  7800: 41 53 54 72 60 01 00 00 4e 42 43 52 a0 1f 93 83  ASTr`...NBCR....
  7810: 88 46 41 53 54 60 00 0c 31 00 08 03 70 83 88 46  .FAST`..1...p..F
  7820: 41 53 54 72 60 01 00 00 44 52 41 4f 72 60 0a 02  ASTr`...DRAOr`..
  7830: 60 53 54 42 46 ff 4f 42 49 44 70 47 41 47 50 0d  `STBF.OBIDpGAGP.
  7840: 47 44 4e 49 00 60 53 4e 56 53 0b a8 54 74 60 0a  GDNI.`SNVS..Tt`.
  7850: 04 00 53 4e 56 53 0b f0 53 74 60 0a 04 00 a0 2c  ..SNVS..St`....,
  7860: 47 58 4d 50 a0 11 92 95 58 4d 50 56 0a 14 74 58  GXMP....XMPV..tX
  7870: 4d 50 56 0a 0f 60 a1 0c 78 58 4d 50 56 0a 05 61  MPV..`..xXMPV..a
  7880: 60 75 60 53 4e 56 53 0b 60 83 60 a1 09 53 4e 56  `u`SNVS.`.`..SNV
  7890: 53 0b 60 83 00 53 4e 56 53 0b 81 17 00 53 4e 56  S.`..SNVS....SNV
  78a0: 53 0b 82 17 00 53 4e 56 53 0b 50 83 00 53 4e 56  S....SNVS.P..SNV
  78b0: 53 0b 83 17 00 53 4e 56 53 0b 58 83 00 53 4e 56  S....SNVS.X..SNV
  78c0: 53 0b 28 83 0a 64 53 4e 56 53 0b 31 13 01 14 47  S.(..dSNVS.1...G
  78d0: 07 41 54 55 4e 01 70 01 41 54 46 47 70 0a 08 4f  .ATUN.p.ATFGp..O
  78e0: 42 49 44 a0 1c 92 4e 42 43 52 78 79 68 01 00 72  BID...NBCRxyh..r
  78f0: 7b 47 41 47 50 0b 13 03 0a ff 00 0a 08 00 63 60  {GAGP.........c`
  7900: a1 10 78 79 68 01 00 72 4e 42 43 52 0a 08 00 63  ..xyh..rNBCR...c
  7910: 60 56 44 4c 43 01 56 4e 4c 43 01 53 43 4c 4c 46  `VDLC.VNLC.SCLLF
  7920: 41 56 44 0c 12 00 02 03 68 46 41 4e 42 0c 15 00  AVD.....hFANB...
  7930: 02 03 60 46 44 52 42 0c 32 00 02 03 60 53 54 42  ..`FDRB.2...`STB
  7940: 46 ff 4f 42 49 44 14 48 13 46 41 56 44 02 70 46  F.OBID.H.FAVD.pF
  7950: 43 50 55 60 70 47 4f 43 50 69 61 70 47 44 56 44  CPU`pGOCPiapGDVD
  7960: 62 a0 1f 90 95 60 0a 03 92 95 61 0b 58 02 a0 0c  b....`....a.X...
  7970: 92 95 61 0b 20 03 72 62 0a 10 62 a1 05 72 62 01  ..a. .rb..b..rb.
  7980: 62 a1 45 0d a0 24 90 90 94 60 0a 02 95 60 0a 06  b.E..$...`...`..
  7990: 92 95 61 0b e8 03 a0 0c 92 95 61 0b dc 05 72 62  ..a.......a...rb
  79a0: 0a 18 62 a1 05 72 62 01 62 a1 4d 0a a0 1f 90 93  ..b..rb.b.M.....
  79b0: 60 0a 06 92 95 61 0b d0 07 a0 0c 92 95 61 0b c4  `....a.......a..
  79c0: 09 72 62 0a 10 62 a1 05 72 62 01 62 a1 4a 08 a0  .rb..b..rb.b.J..
  79d0: 1f 90 93 60 0a 07 92 95 61 0b b8 0b a0 0c 92 95  ...`....a.......
  79e0: 61 0b ac 0d 72 62 0a 10 62 a1 05 72 62 01 62 a1  a...rb..b..rb.b.
  79f0: 47 06 a0 1f 90 93 60 0a 08 92 95 61 0b 58 02 a0  G.....`....a.X..
  7a00: 0c 92 95 61 0b 20 03 72 62 0a 10 62 a1 05 72 62  ...a. .rb..b..rb
  7a10: 01 62 a1 44 04 a0 1f 90 93 60 0a 09 92 95 61 0b  .b.D.....`....a.
  7a20: 58 02 a0 0c 92 95 61 0b 20 03 72 62 0a 10 62 a1  X.....a. .rb..b.
  7a30: 05 72 62 01 62 a1 21 a0 1f 90 93 60 0a 0a 92 95  .rb.b.!....`....
  7a40: 61 0b bc 02 a0 0c 92 95 61 0b 84 03 72 62 0a 10  a.......a...rb..
  7a50: 62 a1 05 72 62 01 62 53 54 42 46 68 4f 42 49 44  b..rb.bSTBFhOBID
  7a60: 72 4f 42 49 44 0a 04 4f 42 49 44 53 54 42 46 62  rOBID..OBIDSTBFb
  7a70: 4f 42 49 44 72 4f 42 49 44 0a 04 4f 42 49 44 14  OBIDrOBID..OBID.
  7a80: 2b 47 4f 43 50 01 70 77 47 44 43 52 0a 64 00 60  +GOCP.pwGDCR.d.`
  7a90: a0 13 94 68 60 74 68 60 61 77 61 0b 10 27 61 78  ...h`th`awa..'ax
  7aa0: 61 60 00 62 a1 04 70 00 62 a4 62 08 41 4e 42 54  a`.b..p.b.b.ANBT
  7ab0: 12 1f 0c 0b 34 08 00 0b 97 08 0a 60 0b 5f 09 0a  ....4......`._..
  7ac0: 80 0b 8b 0a 0a a0 0b 0d 0b 0a c0 0b 40 1f 0a d0  ............@...
  7ad0: 14 48 09 46 41 4e 42 02 70 43 56 4e 42 69 62 70  .H.FANB.pCVNBibp
  7ae0: 00 60 70 87 41 4e 42 54 61 a2 4f 07 95 60 61 a0  .`p.ANBTa.O..`a.
  7af0: 44 07 92 94 62 83 88 41 4e 42 54 60 00 70 83 88  D...b..ANBT`.p..
  7b00: 41 4e 42 54 72 60 01 00 00 63 a0 28 63 79 74 0a  ANBTr`...c.(cyt.
  7b10: 38 47 4e 56 53 0b e8 73 00 0a 02 64 a0 0e 94 63  8GNVS..s...d...c
  7b20: 64 72 47 44 4e 44 74 63 64 00 64 a1 07 70 47 44  drGDNDtcd.d..pGD
  7b30: 4e 44 64 a1 07 70 47 44 4e 44 64 53 54 42 46 68  NDd..pGDNDdSTBFh
  7b40: 4f 42 49 44 72 4f 42 49 44 0a 04 4f 42 49 44 53  OBIDrOBID..OBIDS
  7b50: 54 42 46 64 4f 42 49 44 72 4f 42 49 44 0a 04 4f  TBFdOBIDrOBID..O
  7b60: 42 49 44 a5 72 60 0a 02 60 08 41 44 52 54 12 39  BID.r`..`.ADRT.9
  7b70: 16 0b 97 04 0a 14 0b 28 05 0a 17 0b 82 05 0a 17  .......(........
  7b80: 0b b4 05 0a 1e 0b f0 05 0a 21 0b 2c 06 0a 24 0b  .........!.,..$.
  7b90: 9a 06 0a 28 0b c2 06 0a 2b 0b e0 06 0a 2e 0b 07  ...(....+.......
  7ba0: 07 0a 32 0b 40 1f 0a 35 14 44 0b 46 44 52 42 02  ..2.@..5.D.FDRB.
  7bb0: a0 30 47 58 4d 50 53 54 42 46 68 4f 42 49 44 72  .0GXMPSTBFhOBIDr
  7bc0: 4f 42 49 44 0a 04 4f 42 49 44 53 54 42 46 58 4d  OBID..OBIDSTBFXM
  7bd0: 50 56 4f 42 49 44 72 4f 42 49 44 0a 04 4f 42 49  PVOBIDrOBID..OBI
  7be0: 44 a1 4b 07 a0 13 44 52 41 4f 70 43 44 46 45 74  D.K...DRAOpCDFEt
  7bf0: 44 52 41 4f 01 00 69 62 a1 0f 70 43 44 46 45 74  DRAO..ib..pCDFEt
  7c00: 43 44 52 41 01 00 69 62 70 00 60 70 87 41 44 52  CDRA..ibp.`p.ADR
  7c10: 54 61 a2 4a 04 95 60 61 a0 3f 92 94 62 83 88 41  Ta.J..`a.?..b..A
  7c20: 44 52 54 60 00 53 54 42 46 68 4f 42 49 44 72 4f  DRT`.STBFhOBIDrO
  7c30: 42 49 44 0a 04 4f 42 49 44 53 54 42 46 83 88 41  BID..OBIDSTBF..A
  7c40: 44 52 54 72 60 01 00 00 4f 42 49 44 72 4f 42 49  DRTr`...OBIDrOBI
  7c50: 44 0a 04 4f 42 49 44 a5 72 60 0a 02 60 14 4d 05  D..OBID.r`..`.M.
  7c60: 45 53 59 54 01 70 0a 08 4f 42 49 44 78 79 68 01  ESYT.p..OBIDxyh.
  7c70: 00 72 7b 47 41 47 50 0b 13 03 0a ff 00 0a 08 00  .r{GAGP.........
  7c80: 63 60 46 41 56 44 0c 12 00 02 03 68 46 41 4e 42  c`FAVD.....hFANB
  7c90: 0c 15 00 02 03 60 70 44 52 41 4f 61 70 00 44 52  .....`pDRAOap.DR
  7ca0: 41 4f 46 44 52 42 0c 32 00 02 03 60 70 61 44 52  AOFDRB.2...`paDR
  7cb0: 41 4f 53 54 42 46 ff 4f 42 49 44 08 42 55 46 31  AOSTBF.OBID.BUF1
  7cc0: 12 08 02 0c 11 00 01 03 ff 14 49 05 55 44 42 46  ..........I.UDBF
  7cd0: 01 08 54 54 54 30 00 70 7b 68 0b ff ff 00 54 54  ..TTT0.p{h....TT
  7ce0: 54 30 a0 13 93 54 54 54 30 00 74 0a ca 0a 64 88  T0...TTT0.t...d.
  7cf0: 42 55 46 31 01 00 a1 2c a0 13 93 54 54 54 30 01  BUF1...,...TTT0.
  7d00: 74 0a ce 0a 64 88 42 55 46 31 01 00 a1 16 a0 14  t...d.BUF1......
  7d10: 93 54 54 54 30 0a 02 74 0a d2 0a 64 88 42 55 46  .TTT0..t...d.BUF
  7d20: 31 01 00 14 4c 05 4d 56 42 46 01 70 00 60 70 0a  1...L.MVBF.p.`p.
  7d30: 08 62 70 87 42 55 46 31 63 a2 46 04 92 93 60 63  .bp.BUF1c.F...`c
  7d40: 72 60 01 61 a0 30 92 93 83 88 42 55 46 31 61 00  r`.a.0....BUF1a.
  7d50: ff 53 54 42 46 83 88 42 55 46 31 60 00 62 72 62  .STBF..BUF1`.brb
  7d60: 0a 04 62 53 54 42 46 83 88 42 55 46 31 61 00 62  ..bSTBF..BUF1a.b
  7d70: 72 62 0a 04 62 53 54 42 46 ff 62 72 60 0a 02 60  rb..bSTBF.br`..`
  7d80: 14 2b 53 54 42 46 02 70 68 60 70 69 61 70 00 62  .+STBF.ph`piap.b
  7d90: a2 1b 92 93 62 0a 20 70 7a 60 62 00 88 41 53 42  ....b. pz`b..ASB
  7da0: 46 61 00 72 62 0a 08 62 72 61 01 61 08 49 47 50  Fa.rb..bra.a.IGP
  7db0: 53 00 14 4e 08 55 44 42 32 01 08 54 54 54 30 00  S..N.UDB2..TTT0.
  7dc0: 70 7b 68 0b ff ff 00 54 54 54 30 a0 38 93 54 54  p{h....TTT0.8.TT
  7dd0: 54 30 00 70 0c 60 00 01 03 41 53 42 32 74 47 47  T0.p.`...ASB2tGG
  7de0: 46 51 0a c8 60 70 60 41 53 42 33 70 0c 67 00 01  FQ..`p`ASB3p.g..
  7df0: 03 41 53 42 34 70 49 47 50 53 41 53 42 35 70 ff  .ASB4pIGPSASB5p.
  7e00: 41 53 42 36 a1 3c a0 3a 93 54 54 54 30 01 70 0c  ASB6.<.:.TTT0.p.
  7e10: 60 00 01 03 41 53 42 32 70 0b 68 01 41 53 42 33  `...ASB2p.h.ASB3
  7e20: 70 0c 67 00 01 03 41 53 42 34 7d 47 47 48 50 0c  p.g...ASB4}GGHP.
  7e30: 00 00 01 00 60 70 60 41 53 42 35 70 ff 41 53 42  ....`p`ASB5p.ASB
  7e40: 36 08 54 42 52 54 12 43 19 e7 0a 04 00 0a 22 01  6.TBRT.C......".
  7e50: 0a 03 0a 03 0a 02 0a 02 0a 02 01 0a ff 0a 04 01  ................
  7e60: 0a 22 01 0a 03 0a 03 0a 03 01 0a 02 01 0a ff 0a  ."..............
  7e70: 04 00 0a 20 0a 02 0a 04 0a 04 0a 03 01 0a 03 01  ... ............
  7e80: 0a ff 0a 04 01 0a 20 0a 04 0a 05 0a 06 0a 05 0a  ...... .........
  7e90: 04 0a 05 0a 04 0a ff 0a 04 0a 02 0a 1e 0a 02 00  ................
  7ea0: 00 00 00 00 0a 02 0a ff 0a 03 00 0a 1e 0a 03 0a  ................
  7eb0: 05 0a 05 0a 05 00 0a 05 00 0a ff 0a 03 00 0a 1c  ................
  7ec0: 0a 03 0a 05 0a 04 0a 04 00 0a 04 00 0a ff 0a 02  ................
  7ed0: 01 0a 20 0a 04 0a 05 0a 05 00 00 00 00 0a ff 0a  .. .............
  7ee0: 02 00 0a 1f 0a 02 0a 04 0a 04 00 00 00 00 0a ff  ................
  7ef0: 0a 06 0a 02 0a 1a 0a 02 00 00 00 00 00 0a 02 0a  ................
  7f00: ff 0a 06 0a 02 0a 1c 0a 02 00 00 00 00 00 0a 02  ................
  7f10: 0a ff 0a 06 0a 02 0a 20 0a 02 00 00 00 00 00 0a  ....... ........
  7f20: 02 0a ff 0a ff 0a ff 0a ff 0a 0f 0a 0f 0a 0f 0a  ................
  7f30: 0f 0a 0f 0a 0f 0a 0f 0a ff 0a 04 00 0a 1e 0a 03  ................
  7f40: 0a 05 0a 05 0a 03 0a 03 0a 04 0a 03 0a ff 0a 04  ................
  7f50: 00 0a 1c 0a 03 0a 03 0a 04 0a 04 0a 03 0a 03 0a  ................
  7f60: 03 0a ff 0a 03 01 0a 20 0a 02 0a 04 0a 04 0a 03  ....... ........
  7f70: 00 0a 03 00 0a ff 0a 04 01 0a 20 0a 02 0a 04 0a  .......... .....
  7f80: 04 0a 03 0a 02 0a 03 0a 02 0a ff 0a 03 00 0a 1f  ................
  7f90: 0a 02 0a 03 0a 04 0a 02 00 0a 02 00 0a ff 0a 04  ................
  7fa0: 00 0a 1f 0a 02 0a 03 0a 04 0a 02 0a 03 0a 02 0a  ................
  7fb0: 02 0a ff 0a 06 0a 02 0a 1e 0a 02 00 00 00 00 00  ................
  7fc0: 0a 02 0a ff 0a ff 0a ff 0a ff 0a 0f 0a 0f 0a 0f  ................
  7fd0: 0a 0f 0a 0f 0a 0f 0a 0f 0a ff 08 54 42 54 54 12  ...........TBTT.
  7fe0: 13 0b 00 00 00 01 0a 02 0a 02 0a 02 0a 02 0a 02  ................
  7ff0: 01 0a ff 14 41 14 54 55 52 52 00 70 0a 08 4f 42  ....A.TURR.p..OB
  8000: 49 44 a0 49 12 49 55 43 50 70 47 41 47 50 0d 43  ID.I.IUCPpGAGP.C
  8010: 50 55 4e 00 60 70 47 4e 56 53 0b c9 23 61 70 47  PUN.`pGNVS..#apG
  8020: 44 43 52 62 70 00 65 a2 0f 92 93 83 88 54 42 52  DCRbp.e......TBR
  8030: 54 65 00 0a ff 75 65 75 65 70 00 63 a0 1e 47 4e  Te...ueuep.c..GN
  8040: 56 53 0b 88 17 a2 11 92 93 83 88 54 42 52 54 63  VS.........TBRTc
  8050: 00 0a ff 72 63 65 63 72 63 65 63 a2 48 08 92 93  ...rcecrcec.H...
  8060: 83 88 54 42 52 54 63 00 0a ff a0 45 07 93 83 88  ..TBRTc....E....
  8070: 54 42 52 54 63 00 60 70 83 88 54 42 52 54 72 63  TBRTc.`p..TBRTrc
  8080: 01 00 00 64 a0 4b 05 91 93 64 0a ff 93 64 61 70  ...d.K...d...dap
  8090: 83 88 54 42 52 54 72 63 0a 02 00 00 64 a0 42 04  ..TBRTrc....d.B.
  80a0: 91 93 64 0a ff 93 64 62 70 0a 03 64 a2 32 95 64  ..d...dbp..d.2.d
  80b0: 74 65 01 00 53 54 42 46 72 83 88 47 33 43 32 0a  te..STBFr..G3C2.
  80c0: 03 00 83 88 54 42 52 54 72 63 64 00 00 00 4f 42  ....TBRTrcd...OB
  80d0: 49 44 72 4f 42 49 44 0a 04 4f 42 49 44 75 64 a5  IDrOBID..OBIDud.
  80e0: 72 63 65 63 a0 47 04 93 83 88 54 42 52 54 63 00  rcec.G....TBRTc.
  80f0: 0a ff 70 0a 03 64 70 00 63 a2 32 95 64 74 65 01  ..p..dp.c.2.dte.
  8100: 00 53 54 42 46 72 83 88 47 33 43 32 0a 03 00 83  .STBFr..G3C2....
  8110: 88 54 42 54 54 72 63 64 00 00 00 4f 42 49 44 72  .TBTTrcd...OBIDr
  8120: 4f 42 49 44 0a 04 4f 42 49 44 75 64 53 54 42 46  OBID..OBIDudSTBF
  8130: ff 4f 42 49 44 08 4c 4c 46 47 00 14 15 53 43 4c  .OBID.LLFG...SCL
  8140: 4c 00 70 47 41 47 50 0d 47 4c 4c 53 00 4c 4c 46  L.pGAGP.GLLS.LLF
  8150: 47 14 0e 52 43 4c 4c 00 56 44 4c 43 4c 4c 46 47  G..RCLL.VDLCLLFG
  8160: 14 13 54 4d 43 4d 01 a0 06 68 54 4d 54 43 a1 05  ..TMCM...hTMTC..
  8170: 52 43 4c 4c 14 4e 06 54 4d 54 43 00 5e 5e 2e 45  RCLL.N.TMTC.^^.E
  8180: 43 30 5f 45 43 42 57 0a 40 0a 0a 0a 10 5e 5e 2e  C0_ECBW.@....^^.
  8190: 45 43 30 5f 45 43 42 57 0a 40 0a 0b 00 5e 5e 2e  EC0_ECBW.@...^^.
  81a0: 45 43 30 5f 45 43 42 57 0a 40 0a 0c 00 5e 5e 2e  EC0_ECBW.@...^^.
  81b0: 45 43 30 5f 45 43 42 57 0a 40 0a 0d 00 70 5e 5e  EC0_ECBW.@...p^^
  81c0: 2e 45 43 30 5f 45 43 42 52 0a 40 0a 19 60 7d 60  .EC0_ECBR.@..`}`
  81d0: 0a 10 60 5e 5e 2e 45 43 30 5f 45 43 42 57 0a 40  ..`^^.EC0_ECBW.@
  81e0: 0a 19 60 08 44 46 54 42 12 0e 04 0b 20 03 0b 2a  ..`.DFTB.... ..*
  81f0: 04 0b 35 05 0b 40 06 14 22 43 44 46 45 02 77 69  ..5..@.."CDFE.wi
  8200: 83 88 44 46 54 42 68 00 60 78 60 0a c8 61 60 a0  ..DFTBh.`x`..a`.
  8210: 08 92 95 61 0a 64 75 60 a4 60 14 15 43 56 4e 42  ...a.du`.`..CVNB
  8220: 01 77 47 41 47 50 0d 47 56 4e 49 00 68 60 a4 60  .wGAGP.GVNI.h`.`
  8230: 14 46 0b 47 58 4d 50 00 a0 08 58 4d 50 56 70 01  .F.GXMP...XMPVp.
  8240: 63 a1 43 0a 70 00 60 70 0a 03 61 70 00 63 a2 46  c.C.p.`p..ap.c.F
  8250: 09 92 94 60 61 72 0a a0 77 0a 02 60 00 62 a0 42  ...`ar..w..`.b.B
  8260: 08 92 93 52 42 59 54 62 00 0a ff a0 44 07 90 93  ...RBYTb....D...
  8270: 52 42 59 54 62 0a b0 0a 0c 93 52 42 59 54 62 0a  RBYTb.....RBYTb.
  8280: b1 0a 4a a0 4c 05 52 42 59 54 62 0a ba 70 01 63  ..J.L.RBYTb..p.c
  8290: 70 52 42 59 54 62 0a b9 60 72 77 7a 60 0a 05 00  pRBYTb..`rwz`...
  82a0: 0c a0 86 01 00 00 77 7b 60 0a 1f 00 0b 88 13 00  ......w{`.......
  82b0: 58 4d 50 56 74 58 4d 50 56 7b 83 88 47 33 44 32  XMPVtXMPV{..G3D2
  82c0: 0a 04 00 0c ff ff 0f 00 00 58 4d 50 56 78 58 4d  .........XMPVxXM
  82d0: 50 56 83 88 47 33 44 32 0a 05 00 65 58 4d 50 56  PV..G3D2...eXMPV
  82e0: a5 72 60 01 60 a4 63 14 41 0d 47 44 4d 46 00 70  .r`.`.c.A.GDMF.p
  82f0: 00 60 70 0a 03 61 70 00 63 a2 4d 0b 92 94 60 61  .`p..ap.c.M...`a
  8300: 72 0a a0 77 0a 02 60 00 62 a0 49 0a 92 93 52 42  r..w..`.b.I...RB
  8310: 59 54 62 00 0a ff a0 3f 90 93 52 42 59 54 62 0a  YTb....?..RBYTb.
  8320: b0 0a 0c 93 52 42 59 54 62 0a b1 0a 4a a0 28 52  ....RBYTb...J.(R
  8330: 42 59 54 62 0a ba 77 52 42 59 54 62 0a b5 0b d0  BYTb..wRBYTb....
  8340: 07 63 78 63 77 52 42 59 54 62 0a ba 52 42 59 54  .cxcwRBYTb..RBYT
  8350: 62 0a b4 00 00 63 77 52 42 59 54 62 0a 0b 0b d0  b....cwRBYTb....
  8360: 07 64 78 64 77 52 42 59 54 62 0a 0c 52 42 59 54  .dxdwRBYTb..RBYT
  8370: 62 0a 0a 00 00 64 a0 07 95 63 64 70 64 63 70 47  b....d...cdpdcpG
  8380: 4e 56 53 0b c8 44 64 a0 2a 91 91 93 64 01 94 64  NVS..Dd.*...d..d
  8390: 0a 03 93 64 0a 08 a0 0c 92 95 63 0b 40 06 70 0b  ...d......c.@.p.
  83a0: 35 05 63 a1 0e a0 0c 92 95 63 0b 34 05 70 0b 2a  5.c......c.4.p.*
  83b0: 04 63 a5 72 60 01 60 a4 63 14 0e 46 43 50 55 00  .c.r`.`.c..FCPU.
  83c0: a4 47 4e 56 53 0b c8 44 14 24 47 43 43 52 00 a0  .GNVS..D.$GCCR..
  83d0: 13 47 4e 56 53 0b c0 63 72 47 4e 56 53 0b c0 63  .GNVS..crGNVS..c
  83e0: 0a 07 60 a1 07 70 47 44 43 52 60 a4 60 14 26 47  ..`..pGDCR`.`.&G
  83f0: 44 43 52 00 72 47 4e 56 53 0b f9 63 0a 10 60 a0  DCR.rGNVS..c..`.
  8400: 12 47 4e 56 53 0b cd 34 7a 60 47 4e 56 53 0b cd  .GNVS..4z`GNVS..
  8410: 34 60 a4 60 14 2c 49 55 43 50 00 47 4d 53 52 0c  4`.`.,IUCP.GMSR.
  8420: 71 00 01 c0 70 52 45 44 58 60 7a 60 0a 11 60 7b  q...pREDX`z`..`{
  8430: 60 0a 3f 60 a0 05 60 70 00 60 a1 04 70 01 60 a4  `.?`..`p.`..p.`.
  8440: 60 08 47 45 4d 52 12 4a 07 08 12 0e 04 0c 61 00  `.GEMR.J......a.
  8450: 02 03 0a c8 0b 30 02 0a 0a 12 0f 04 0c 61 00 02  .....0.......a..
  8460: 03 0b 31 02 0b bc 02 0a 0f 12 0f 04 0c 61 00 02  ..1..........a..
  8470: 03 0b bd 02 0b ee 02 0a 14 12 0f 04 0c 61 00 02  .............a..
  8480: 03 0b ef 02 0b 0c 03 0a 19 12 0f 04 0c 61 00 02  .............a..
  8490: 03 0b 0d 03 0b 2a 03 0a 1e 12 0f 04 0c 61 00 02  .....*.......a..
  84a0: 03 0b 2b 03 0b 48 03 0a 23 12 0f 04 0c 61 00 02  ..+..H..#....a..
  84b0: 03 0b 49 03 0b d0 07 0a 28 12 07 04 0a ff 00 00  ..I.....(.......
  84c0: 00 08 47 50 4d 52 12 18 02 12 0c 04 0c 66 00 02  ..GPMR.......f..
  84d0: 03 00 0b d0 07 00 12 08 04 0a ff 00 00 0a 1d 08  ................
  84e0: 47 42 46 51 00 14 49 09 55 47 50 42 01 70 68 47  GBFQ..I.UGPB.phG
  84f0: 42 46 51 70 00 60 70 83 88 83 88 47 45 4d 52 60  BFQp.`p....GEMR`
  8500: 00 00 00 61 a2 43 07 92 93 61 0a ff 70 83 88 83  ...a.C...a..p...
  8510: 88 47 45 4d 52 60 00 01 00 62 a0 4d 04 92 95 47  .GEMR`...b.M...G
  8520: 42 46 51 62 70 83 88 83 88 47 45 4d 52 60 00 0a  BFQbp....GEMR`..
  8530: 02 00 62 a0 34 92 94 47 42 46 51 62 70 83 88 83  ..b.4..GBFQbp...
  8540: 88 47 45 4d 52 60 00 00 00 62 53 54 42 46 62 0a  .GEMR`...bSTBFb.
  8550: 08 70 83 88 83 88 47 45 4d 52 60 00 0a 03 00 62  .p....GEMR`....b
  8560: 53 54 42 46 62 0a 0c a5 75 60 70 83 88 83 88 47  STBFb...u`p....G
  8570: 45 4d 52 60 00 00 00 61 53 54 42 46 ff 0a 10 10  EMR`...aSTBF....
  8580: 49 44 2f 04 5f 53 42 5f 50 43 49 30 53 42 52 47  ID/._SB_PCI0SBRG
  8590: 41 53 4f 43 08 47 36 31 31 12 24 07 0c 11 00 02  ASOC.G611.$.....
  85a0: 06 0d 56 63 6f 72 65 20 56 6f 6c 74 61 67 65 00  ..Vcore Voltage.
  85b0: 0c 00 00 00 20 00 0b 20 03 0b 20 03 0a 02 08 47  .... .. .. ....G
  85c0: 36 36 33 12 24 07 0c 63 00 02 06 0d 2b 33 2e 33  663.$..c....+3.3
  85d0: 56 20 56 6f 6c 74 61 67 65 00 0c 00 00 00 20 00  V Voltage..... .
  85e0: 0b 9a 0b 0b 94 02 0a 02 08 47 36 36 32 12 22 07  .........G662.".
  85f0: 0c 62 00 02 06 0d 2b 35 56 20 56 6f 6c 74 61 67  .b....+5V Voltag
  8600: 65 00 0c 00 00 00 20 00 0b 94 11 0b e8 03 0a 02  e..... .........
  8610: 08 47 36 36 31 12 23 07 0c 61 00 02 06 0d 2b 31  .G661.#..a....+1
  8620: 32 56 20 56 6f 6c 74 61 67 65 00 0c 00 00 00 20  2V Voltage..... 
  8630: 00 0b d8 27 0b 10 0e 0a 02 08 47 36 31 32 12 26  ...'......G612.&
  8640: 07 0c 12 00 03 06 0d 43 50 55 20 54 65 6d 70 65  .......CPU Tempe
  8650: 72 61 74 75 72 65 00 0c 00 00 00 20 00 0b 58 02  rature..... ..X.
  8660: 0b 5e 01 0a 02 08 47 36 31 34 12 25 07 0c 14 00  .^....G614.%....
  8670: 03 06 0d 4d 42 20 54 65 6d 70 65 72 61 74 75 72  ...MB Temperatur
  8680: 65 00 0c 00 00 00 20 00 0b c2 01 0b 2c 01 0a 02  e..... .....,...
  8690: 08 47 36 31 33 12 24 07 0c 13 00 04 06 0d 43 50  .G613.$.......CP
  86a0: 55 20 46 61 6e 20 53 70 65 65 64 00 0c 00 00 00  U Fan Speed.....
  86b0: 20 00 0b 58 02 0b c8 19 0a 02 08 47 36 37 33 12   ..X.......G673.
  86c0: 28 07 0c 73 00 04 06 0d 43 68 61 73 73 69 73 20  (..s....Chassis 
  86d0: 46 61 6e 20 53 70 65 65 64 00 0c 00 00 00 20 00  Fan Speed..... .
  86e0: 0b 58 02 0b c8 19 0a 02 08 47 52 50 36 12 22 08  .X.......GRP6.".
  86f0: 47 36 31 31 47 36 36 33 47 36 36 32 47 36 36 31  G611G663G662G661
  8700: 47 36 31 32 47 36 31 34 47 36 31 33 47 36 37 33  G612G614G613G673
  8710: 14 1c 47 36 55 50 00 a0 15 93 7a 83 88 4d 42 49  ..G6UP....z..MBI
  8720: 46 0a 02 00 0a 18 00 0a 04 53 46 53 54 14 49 16  F........SFST.I.
  8730: 53 46 53 54 00 a0 43 0a 92 93 47 4e 56 53 0b 70  SFST..C...GNVS.p
  8740: 17 00 08 54 54 54 30 00 70 47 4e 56 53 0b 6b 36  ...TTT0.pGNVS.k6
  8750: 54 54 54 30 a0 13 93 54 54 54 30 00 70 0b f4 01  TTT0...TTT0.p...
  8760: 88 47 36 31 33 0a 03 00 a1 40 07 a0 13 93 54 54  .G613....@....TT
  8770: 54 30 01 70 0b 90 01 88 47 36 31 33 0a 03 00 a1  T0.p....G613....
  8780: 49 05 a0 14 93 54 54 54 30 0a 02 70 0b 2c 01 88  I....TTT0..p.,..
  8790: 47 36 31 33 0a 03 00 a1 41 04 a0 13 93 54 54 54  G613....A....TTT
  87a0: 30 0a 03 70 0a c8 88 47 36 31 33 0a 03 00 a1 2a  0..p...G613....*
  87b0: a0 13 93 54 54 54 30 0a 04 70 0a 64 88 47 36 31  ...TTT0..p.d.G61
  87c0: 33 0a 03 00 a1 14 a0 12 93 54 54 54 30 0a 05 70  3........TTT0..p
  87d0: 00 88 47 36 31 33 0a 03 00 a1 0c 70 0a c8 88 47  ..G613.....p...G
  87e0: 36 31 33 0a 03 00 a0 43 0a 92 93 47 4e 56 53 0b  613....C...GNVS.
  87f0: 70 17 00 08 54 54 54 31 00 70 47 4e 56 53 0b 70  p...TTT1.pGNVS.p
  8800: 36 54 54 54 31 a0 13 93 54 54 54 31 00 70 0b f4  6TTT1...TTT1.p..
  8810: 01 88 47 36 37 33 0a 03 00 a1 40 07 a0 13 93 54  ..G673....@....T
  8820: 54 54 31 01 70 0b 90 01 88 47 36 37 33 0a 03 00  TT1.p....G673...
  8830: a1 49 05 a0 14 93 54 54 54 31 0a 02 70 0b 2c 01  .I....TTT1..p.,.
  8840: 88 47 36 37 33 0a 03 00 a1 41 04 a0 13 93 54 54  .G673....A....TT
  8850: 54 31 0a 03 70 0a c8 88 47 36 37 33 0a 03 00 a1  T1..p...G673....
  8860: 2a a0 13 93 54 54 54 31 0a 04 70 0a 64 88 47 36  *...TTT1..p.d.G6
  8870: 37 33 0a 03 00 a1 14 a0 12 93 54 54 54 31 0a 05  73........TTT1..
  8880: 70 00 88 47 36 37 33 0a 03 00 a1 0c 70 0a c8 88  p..G673.....p...
  8890: 47 36 37 33 0a 03 00 14 4a 12 47 49 54 36 01 08  G673....J.GIT6..
  88a0: 54 54 54 30 00 70 7b 68 0b ff ff 00 54 54 54 30  TTT0.p{h....TTT0
  88b0: a0 18 93 54 54 54 30 0a 11 70 5e 5e 2e 53 49 4f  ...TTT0..p^^.SIO
  88c0: 52 48 57 56 32 41 53 42 31 a1 48 0f a0 18 93 54  RHWV2ASB1.H....T
  88d0: 54 54 30 0a 63 70 5e 5e 2e 53 49 4f 52 48 57 56  TT0.cp^^.SIORHWV
  88e0: 33 41 53 42 31 a1 4c 0d a0 2f 93 54 54 54 30 0a  3ASB1.L../.TTT0.
  88f0: 62 70 5e 5e 2e 53 49 4f 52 48 57 56 31 41 53 42  bp^^.SIORHWV1ASB
  8900: 31 77 41 53 42 31 0a af 41 53 42 31 78 41 53 42  1wASB1..ASB1xASB
  8910: 31 0a 64 00 41 53 42 31 a1 49 0a a0 30 93 54 54  1.d.ASB1.I..0.TT
  8920: 54 30 0a 61 70 5e 5e 2e 53 49 4f 52 48 57 56 30  T0.ap^^.SIORHWV0
  8930: 41 53 42 31 77 41 53 42 31 0b a0 01 41 53 42 31  ASB1wASB1...ASB1
  8940: 78 41 53 42 31 0a 64 00 41 53 42 31 a1 45 07 a0  xASB1.d.ASB1.E..
  8950: 18 93 54 54 54 30 0a 12 70 5e 5e 2e 53 49 4f 52  ..TTT0..p^^.SIOR
  8960: 48 57 54 31 41 53 42 31 a1 49 05 a0 18 93 54 54  HWT1ASB1.I....TT
  8970: 54 30 0a 14 70 5e 5e 2e 53 49 4f 52 48 57 54 32  T0..p^^.SIORHWT2
  8980: 41 53 42 31 a1 3d a0 18 93 54 54 54 30 0a 13 70  ASB1.=...TTT0..p
  8990: 5e 5e 2e 53 49 4f 52 48 57 46 31 41 53 42 31 a1  ^^.SIORHWF1ASB1.
  89a0: 22 a0 18 93 54 54 54 30 0a 73 70 5e 5e 2e 53 49  "...TTT0.sp^^.SI
  89b0: 4f 52 48 57 46 32 41 53 42 31 a1 07 70 00 41 53  ORHWF2ASB1..p.AS
  89c0: 42 30 14 06 53 49 54 36 03 10 43 06 5c 00 5b 80  B0..SIT6..C.\.[.
  89d0: 53 44 48 4d 01 0b d0 0c 0a 02 5b 81 10 53 44 48  SDHM......[..SDH
  89e0: 4d 01 53 44 56 31 08 53 44 56 32 08 5b 86 3f 53  M.SDV1.SDV2.[.?S
  89f0: 44 56 31 53 44 56 32 01 00 40 58 56 45 56 54 08  DV1SDV2..@XVEVT.
  8a00: 00 08 41 43 30 33 08 41 43 34 37 08 00 08 56 52  ..AC03.AC47...VR
  8a10: 30 33 08 00 48 05 56 49 56 32 08 56 49 32 4c 08  03..H.VIV2.VI2L.
  8a20: 56 49 32 48 08 00 40 11 48 4d 41 52 08 10 46 0d  VI2H..@.HMAR..F.
  8a30: 5f 47 50 45 08 48 49 48 4c 0a b3 08 4c 4f 57 4c  _GPE.HIHL...LOWL
  8a40: 0a 4c 08 54 50 4e 42 00 14 4b 0b 5f 4c 30 44 00  .L.TPNB..K._L0D.
  8a50: a0 4a 04 92 95 56 49 56 32 56 49 32 4c 70 0a ff  .J...VIV2VI2Lp..
  8a60: 56 49 32 4c 70 48 49 48 4c 56 49 32 48 5c 2f 05  VI2LpHIHLVI2H\/.
  8a70: 5f 53 42 5f 50 43 49 30 53 42 52 47 41 53 4f 43  _SB_PCI0SBRGASOC
  8a80: 53 4e 42 56 5c 2f 05 5f 53 42 5f 50 43 49 30 53  SNBV\/._SB_PCI0S
  8a90: 42 52 47 41 53 4f 43 47 50 53 30 a1 4c 04 a0 49  BRGASOCGPS0.L..I
  8aa0: 04 92 94 56 49 56 32 56 49 32 48 70 00 56 49 32  ...VIV2VI2Hp.VI2
  8ab0: 48 70 4c 4f 57 4c 56 49 32 4c 5c 2f 05 5f 53 42  HpLOWLVI2L\/._SB
  8ac0: 5f 50 43 49 30 53 42 52 47 41 53 4f 43 53 4e 42  _PCI0SBRGASOCSNB
  8ad0: 56 5c 2f 05 5f 53 42 5f 50 43 49 30 53 42 52 47  V\/._SB_PCI0SBRG
  8ae0: 41 53 4f 43 47 50 53 31 5b 22 0b 2c 01 5c 2f 05  ASOCGPS1[".,.\/.
  8af0: 5f 53 42 5f 50 43 49 30 53 42 52 47 41 53 4f 43  _SB_PCI0SBRGASOC
  8b00: 43 47 50 53 10 4f 1f 2f 04 5f 53 42 5f 50 43 49  CGPS.O./._SB_PCI
  8b10: 30 53 42 52 47 41 53 4f 43 14 06 47 49 54 38 01  0SBRGASOC..GIT8.
  8b20: 14 06 53 49 54 38 03 14 13 43 47 50 52 00 70 0a  ..SIT8...CGPR.p.
  8b30: ff 56 49 32 4c 70 00 56 49 32 48 14 20 53 47 50  .VI2Lp.VI2H. SGP
  8b40: 52 00 70 83 88 47 54 48 44 00 00 56 49 32 4c 70  R.p..GTHD..VI2Lp
  8b50: 83 88 47 54 48 44 01 00 56 49 32 48 14 0d 43 47  ..GTHD..VI2H..CG
  8b60: 50 53 00 70 0a ff 56 45 56 54 14 11 44 47 50 4e  PS.p..VEVT..DGPN
  8b70: 00 7b 41 43 30 33 0a cf 41 43 30 33 14 11 45 47  .{AC03..AC03..EG
  8b80: 50 4e 00 7d 41 43 30 33 0a 30 41 43 30 33 14 34  PN.}AC03.0AC03.4
  8b90: 47 4e 49 54 00 43 47 50 52 70 00 41 43 30 33 70  GNIT.CGPRp.AC03p
  8ba0: 00 41 43 34 37 55 47 4e 50 7d 48 4d 41 52 0a 02  .AC47UGNP}HMAR..
  8bb0: 48 4d 41 52 7d 56 52 30 33 0a 20 56 52 30 33 45  HMAR}VR03. VR03E
  8bc0: 47 50 4e 14 18 55 47 4e 50 00 a0 11 92 93 83 88  GPN..UGNP.......
  8bd0: 47 54 48 44 00 00 0a ff 53 47 50 52 14 06 53 57  GTHD....SGPR..SW
  8be0: 50 50 00 14 06 53 57 50 51 00 08 47 54 48 44 11  PP...SWPQ..GTHD.
  8bf0: 05 0a 02 4c b3 08 47 46 4c 41 00 14 45 04 49 4e  ...L..GFLA..E.IN
  8c00: 47 50 00 a0 0c 47 4e 56 53 0b 86 17 44 47 50 4e  GP...GNVS...DGPN
  8c10: a1 30 a0 0c 47 4e 56 53 0b 87 17 44 47 50 4e a1  .0..GNVS...DGPN.
  8c20: 21 a0 0c 7b 47 46 4c 41 01 00 44 47 50 4e a1 12  !..{GFLA..DGPN..
  8c30: 70 47 47 48 50 47 50 53 31 47 4e 49 54 43 47 50  pGGHPGPS1GNITCGP
  8c40: 53 14 42 05 47 47 48 50 00 74 48 54 46 51 01 61  S.B.GGHP.tHTFQ.a
  8c50: 77 61 47 4e 56 53 0b b8 a2 61 a0 0b 92 94 61 0b  waGNVS...a....a.
  8c60: fc 08 70 0a 41 60 a1 2b a0 21 92 94 61 0b 28 0a  ..p.A`.+.!..a.(.
  8c70: 70 47 47 46 51 62 a0 0b 92 94 62 0b 58 02 70 0a  pGGFQb....b.X.p.
  8c80: 41 60 a1 07 70 49 47 50 53 60 a1 07 70 49 47 50  A`..pIGPS`..pIGP
  8c90: 53 60 a4 60 14 4f 06 47 47 46 51 00 a0 11 47 4e  S`.`.O.GGFQ...GN
  8ca0: 56 53 0b 86 17 70 47 4e 56 53 0b d8 b2 60 a1 43  VS...pGNVS...`.C
  8cb0: 05 70 47 4e 56 53 0b be 26 61 08 54 54 54 30 00  .pGNVS..&a.TTT0.
  8cc0: 70 7b 61 0a ff 00 54 54 54 30 a0 0c 93 54 54 54  p{a...TTT0...TTT
  8cd0: 30 01 70 0b 20 03 60 a1 2a a0 0d 93 54 54 54 30  0.p. .`.*...TTT0
  8ce0: 0a 02 70 0b 84 03 60 a1 1a a0 11 93 54 54 54 30  ..p...`.....TTT0
  8cf0: 0a 03 70 47 4e 56 53 0b d8 b2 60 a1 06 70 0b bc  ..pGNVS...`..p..
  8d00: 02 60 a4 60 10 44 15 2f 04 5f 53 42 5f 50 43 49  .`.`.D./._SB_PCI
  8d10: 30 53 42 52 47 41 53 4f 43 08 47 39 54 30 12 4e  0SBRGASOC.G9T0.N
  8d20: 04 0c 0c 00 00 08 09 0d 41 49 20 4f 76 65 72 63  ........AI Overc
  8d30: 6c 6f 63 6b 69 6e 67 00 00 01 0a 07 0d 4d 61 6e  locking......Man
  8d40: 75 61 6c 00 0d 41 75 74 6f 00 0d 53 74 61 6e 64  ual..Auto..Stand
  8d50: 61 72 64 00 0d 50 72 6f 66 69 6c 65 00 00 00 0d  ard..Profile....
  8d60: 43 50 55 20 4c 65 76 65 6c 20 55 70 00 08 47 52  CPU Level Up..GR
  8d70: 50 39 12 06 01 47 39 54 30 14 43 05 47 49 54 39  P9...G9T0.C.GIT9
  8d80: 01 08 54 54 54 30 00 70 7b 68 0b ff ff 00 54 54  ..TTT0.p{h....TT
  8d90: 54 30 a0 32 93 54 54 54 30 00 a0 1e 93 47 4e 56  T0.2.TTT0....GNV
  8da0: 53 0b a8 57 00 a0 13 93 47 4e 56 53 0b 5c 45 0a  S..W....GNVS.\E.
  8db0: 06 53 4e 56 53 0b 5c 45 01 70 47 4e 56 53 0b 5c  .SNVS.\E.pGNVS.\
  8dc0: 45 41 53 42 31 a1 07 70 00 41 53 42 30 14 4b 08  EASB1..p.ASB0.K.
  8dd0: 53 49 54 39 03 08 54 54 54 30 00 70 7b 68 0b ff  SIT9..TTT0.p{h..
  8de0: ff 00 54 54 54 30 a0 4a 06 93 54 54 54 30 00 a0  ..TTT0.J..TTT0..
  8df0: 41 06 92 93 47 4e 56 53 0b 5c 45 69 a0 49 04 7b  A...GNVS.\Ei.I.{
  8e00: 6a 01 00 a0 18 93 69 0a 06 a0 12 93 47 4e 56 53  j.....i.....GNVS
  8e10: 0b a4 26 00 70 00 41 53 42 30 a4 00 a0 13 93 47  ..&.p.ASB0.....G
  8e20: 4e 56 53 0b 5c 45 0a 06 53 4e 56 53 0b a4 26 00  NVS.\E..SNVS..&.
  8e30: a0 0d 93 69 01 53 4e 56 53 0b b8 a2 0a c8 53 4e  ...i.SNVS.....SN
  8e40: 56 53 0b 5c 45 69 7d 41 53 42 30 0a 02 41 53 42  VS.\Ei}ASB0..ASB
  8e50: 30 a1 07 70 00 41 53 42 30 10 4f 4f 2f 04 5f 53  0..p.ASB0.OO/._S
  8e60: 42 5f 50 43 49 30 53 42 52 47 41 53 4f 43 08 47  B_PCI0SBRGASOC.G
  8e70: 42 54 30 12 22 07 0c 01 00 06 0b 0d 53 79 73 74  BT0.".......Syst
  8e80: 65 6d 20 50 65 72 66 6f 72 6d 61 6e 63 65 00 00  em Performance..
  8e90: 00 0a 03 01 0a 04 08 47 42 54 31 12 28 07 0c 02  .......GBT1.(...
  8ea0: 00 06 0b 0d 53 79 73 74 65 6d 20 50 65 72 66 6f  ....System Perfo
  8eb0: 72 6d 61 6e 63 65 20 43 6f 6e 74 72 6f 6c 00 00  rmance Control..
  8ec0: 00 00 00 00 08 47 42 54 32 12 19 07 0c 03 00 06  .....GBT2.......
  8ed0: 0b 0d 53 79 73 74 65 6d 20 47 55 49 00 0a 04 00  ..System GUI....
  8ee0: 00 00 00 08 47 42 54 35 12 1a 07 0c 10 00 06 0b  ....GBT5........
  8ef0: 0d 4c 65 76 65 6c 20 53 77 69 74 63 68 00 00 00  .Level Switch...
  8f00: 00 00 00 08 47 42 54 39 12 26 07 0c 23 00 06 0b  ....GBT9.&..#...
  8f10: 0d 41 49 20 47 65 61 72 20 43 50 55 20 76 6f 6c  .AI Gear CPU vol
  8f20: 74 61 67 65 00 00 00 00 0c 8f fd 0f 00 0a 64 08  tage..........d.
  8f30: 47 42 54 41 12 20 07 0c 24 00 06 0b 0d 53 65 74  GBTA. ..$....Set
  8f40: 20 54 75 72 62 6f 20 50 72 6f 66 69 6c 65 00 00   Turbo Profile..
  8f50: 00 00 01 0a 02 08 47 42 54 42 12 25 07 0c 25 00  ......GBTB.%..%.
  8f60: 06 0b 0d 43 50 55 20 56 6f 6c 74 61 67 65 20 44  ...CPU Voltage D
  8f70: 6f 77 6e 67 72 61 64 65 00 00 00 00 0a 02 0a c8  owngrade........
  8f80: 08 47 42 54 43 12 19 07 0c 80 00 06 0b 0d 45 50  .GBTC.........EP
  8f90: 55 20 76 65 72 73 69 6f 6e 00 00 00 00 00 00 08  U version.......
  8fa0: 47 52 50 42 12 22 08 47 42 54 30 47 42 54 31 47  GRPB.".GBT0GBT1G
  8fb0: 42 54 32 47 42 54 35 47 42 54 39 47 42 54 41 47  BT2GBT5GBT9GBTAG
  8fc0: 42 54 42 47 42 54 43 14 4e 0a 47 49 54 42 01 08  BTBGBTC.N.GITB..
  8fd0: 54 54 54 30 00 70 7b 68 0b ff ff 00 54 54 54 30  TTT0.p{h....TTT0
  8fe0: a0 1a 93 54 54 54 30 01 70 7b 83 88 47 42 54 30  ...TTT0.p{..GBT0
  8ff0: 0a 02 00 0b ff ff 00 41 53 42 31 a1 4a 07 a0 16  .......ASB1.J...
  9000: 93 54 54 54 30 0a 02 70 83 88 47 42 54 31 0a 02  .TTT0..p..GBT1..
  9010: 00 41 53 42 31 a1 40 06 a0 16 93 54 54 54 30 0a  .ASB1.@....TTT0.
  9020: 03 70 83 88 47 42 54 32 0a 02 00 41 53 42 31 a1  .p..GBT2...ASB1.
  9030: 46 04 a0 13 93 54 54 54 30 0a 23 70 47 44 45 46  F....TTT0.#pGDEF
  9040: 0a 02 41 53 42 31 a1 2f a0 13 93 54 54 54 30 0a  ..ASB1./...TTT0.
  9050: 25 45 50 55 42 70 0a 05 41 53 42 31 a1 19 a0 0f  %EPUBp..ASB1....
  9060: 93 54 54 54 30 0a 80 70 0a 02 41 53 42 31 a1 07  .TTT0..p..ASB1..
  9070: 70 00 41 53 42 30 14 40 0e 53 49 54 42 03 08 54  p.ASB0.@.SITB..T
  9080: 54 54 30 00 70 7b 68 0b ff ff 00 54 54 54 30 a0  TT0.p{h....TTT0.
  9090: 26 93 54 54 54 30 01 a0 1e 93 7b 6a 0b ff ff 00  &.TTT0....{j....
  90a0: 01 7b 69 0b ff ff 60 70 60 88 47 42 54 30 0a 02  .{i...`p`.GBT0..
  90b0: 00 53 49 43 4c 60 a1 40 0a a0 45 05 93 54 54 54  .SICL`.@..E..TTT
  90c0: 30 0a 02 7b 69 0a ff 60 a0 2b 92 5b 23 5e 5e 2e  0..{i..`.+.[#^^.
  90d0: 45 43 30 5f 4d 55 45 43 ff ff 70 60 5e 5e 2e 45  EC0_MUEC..p`^^.E
  90e0: 43 30 5f 45 50 55 52 5b 27 5e 5e 2e 45 43 30 5f  C0_EPUR['^^.EC0_
  90f0: 4d 55 45 43 a0 12 93 53 54 43 47 60 01 70 60 88  MUEC...STCG`.p`.
  9100: 47 42 54 31 0a 02 00 a1 07 70 00 41 53 42 30 a1  GBT1.....p.ASB0.
  9110: 47 04 a0 14 93 54 54 54 30 0a 10 70 7b 69 0a ff  G....TTT0..p{i..
  9120: 00 60 41 47 4c 53 60 a1 2f a0 14 93 54 54 54 30  .`AGLS`./...TTT0
  9130: 0a 23 70 7b 69 0a ff 00 60 41 47 43 56 60 a1 18  .#p{i...`AGCV`..
  9140: a0 0e 93 54 54 54 30 0a 24 53 54 50 46 69 6a a1  ...TTT0.$STPFij.
  9150: 07 70 00 41 53 42 30 08 54 55 52 50 12 42 05 24  .p.ASB0.TURP.B.$
  9160: 0b b8 a2 0a d2 0b 60 83 00 0b 26 26 0a 02 0b a0  ......`...&&....
  9170: 35 0a 04 0b 18 36 0a 05 0b 3c 45 0a 08 0b 4c 45  5....6...<E...LE
  9180: 0a 05 0b 50 45 0a 05 0b 78 54 0a 0a 0b 28 83 0a  ...PE...xT...(..
  9190: 64 0b 5c 45 00 0b 81 17 00 0b 82 17 00 0b 50 83  d.\E..........P.
  91a0: 00 0b 83 17 00 0b 58 83 00 0b 31 13 01 ff ff 08  ......X...1.....
  91b0: 41 54 46 42 12 19 0b 0a d8 0a f0 0a d8 0a e8 0a  ATFB............
  91c0: f0 0a f0 0a fa 0b 04 01 0a e8 0a d8 0a da 14 47  ...............G
  91d0: 0f 53 54 50 46 02 a0 4f 0e 93 68 0c 53 55 53 41  .STPF..O..h.SUSA
  91e0: a0 45 0e 7b 69 01 00 70 83 88 41 54 46 42 46 43  .E.{i..p..ATFBFC
  91f0: 50 55 00 88 54 55 52 50 01 00 a0 2e 47 58 4d 50  PU..TURP....GXMP
  9200: a0 11 92 95 58 4d 50 56 0a 14 74 58 4d 50 56 0a  ....XMPV..tXMPV.
  9210: 0f 60 a1 0c 78 58 4d 50 56 0a 05 61 60 75 60 70  .`..xXMPV..a`u`p
  9220: 60 88 54 55 52 50 0a 03 00 70 47 44 4d 46 60 a0  `.TURP...pGDMF`.
  9230: 1d 92 95 60 0b 40 06 70 0a 05 88 54 55 52 50 0a  ...`.@.p...TURP.
  9240: 07 00 70 0a 06 88 54 55 52 50 0a 09 00 a1 4c 04  ..p...TURP....L.
  9250: a0 49 04 95 60 0b 34 05 70 0a 03 88 54 55 52 50  .I..`.4.p...TURP
  9260: 0a 07 00 70 0a 04 88 54 55 52 50 0a 09 00 70 0a  ...p...TURP...p.
  9270: 05 88 54 55 52 50 0a 0b 00 70 0a 02 88 54 55 52  ..TURP...p...TUR
  9280: 50 0a 0d 00 70 0a 02 88 54 55 52 50 0a 0f 00 70  P...p...TURP...p
  9290: 0a 04 88 54 55 52 50 0a 11 00 70 00 60 a2 28 92  ...TURP...p.`.(.
  92a0: 93 83 88 54 55 52 50 60 00 ff 53 4e 56 53 83 88  ...TURP`..SNVS..
  92b0: 54 55 52 50 60 00 83 88 54 55 52 50 72 60 01 00  TURP`...TURPr`..
  92c0: 00 72 60 0a 02 60 08 45 50 55 54 12 42 04 21 0a  .r`..`.EPUT.B.!.
  92d0: 0a 0a 0b 0a 02 0a 0a 0a 0c 0a 02 0a 0a 0a 0c 0a  ................
  92e0: 02 0a 0a 0a 0e 0a 02 0a 0a 0a 0e 0a 02 00 00 00  ................
  92f0: 0a 0a 0a 0e 0a 02 0a 0a 0a 0e 0a 02 0a 0a 0a 0c  ................
  9300: 0a 02 0a 0a 0a 0e 0a 02 0a 0a 0a 0e 0a 02 14 4a  ...............J
  9310: 04 45 50 55 42 00 70 0a 08 4f 42 49 44 70 00 60  .EPUB.p..OBIDp.`
  9320: 70 77 46 43 50 55 0a 03 00 61 a2 25 95 60 0a 03  pwFCPU...a.%.`..
  9330: 53 54 42 46 83 88 45 50 55 54 72 61 60 00 00 4f  STBF..EPUTra`..O
  9340: 42 49 44 72 4f 42 49 44 0a 04 4f 42 49 44 75 60  BIDrOBID..OBIDu`
  9350: 53 54 42 46 ff 4f 42 49 44 10 48 4d 2f 04 5f 53  STBF.OBID.HM/._S
  9360: 42 5f 50 43 49 30 53 42 52 47 41 53 4f 43 08 47  B_PCI0SBRGASOC.G
  9370: 45 54 31 12 17 07 0c 01 00 06 0e 0d 4f 43 20 53  ET1.........OC S
  9380: 74 61 74 75 73 00 00 00 00 00 00 08 47 52 50 45  tatus.......GRPE
  9390: 12 06 01 47 45 54 31 14 30 47 49 54 45 01 08 54  ...GET1.0GITE..T
  93a0: 54 54 30 00 70 7b 68 0b ff ff 00 54 54 54 30 a0  TT0.p{h....TTT0.
  93b0: 10 93 54 54 54 30 01 70 43 41 4d 4c 41 53 42 31  ..TTT0.pCAMLASB1
  93c0: a1 07 70 00 41 53 42 30 14 0c 53 49 54 45 03 70  ..p.ASB0..SITE.p
  93d0: 00 41 53 42 30 08 44 46 53 42 11 0b 0a 08 00 00  .ASB0.DFSB......
  93e0: 0a 0a 01 00 01 01 08 4f 4c 54 42 11 1b 0a 18 00  .......OLTB.....
  93f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01  ................
  9400: 00 00 00 00 00 01 00 08 41 49 47 43 00 08 50 49  ........AIGC..PI
  9410: 43 4c 01 08 4c 56 49 43 00 08 43 41 4d 4c 00 14  CL..LVIC..CAML..
  9420: 08 52 50 53 53 00 a4 00 14 40 0e 47 44 45 46 01  .RPSS....@.GDEF.
  9430: 08 54 54 54 30 00 70 7b 68 0a ff 00 54 54 54 30  .TTT0.p{h...TTT0
  9440: a0 33 93 54 54 54 30 00 a0 15 93 47 4e 56 53 0b  .3.TTT0....GNVS.
  9450: 5c 45 00 77 0a 04 47 4e 56 53 0b 5c 45 60 a1 06  \E.w..GNVS.\E`..
  9460: 77 0a 04 01 60 a4 83 88 44 46 53 42 72 4c 56 49  w...`...DFSBrLVI
  9470: 43 60 00 00 a1 44 09 a0 11 93 54 54 54 30 01 a4  C`...D....TTT0..
  9480: 47 56 4f 54 01 4c 56 49 43 a1 4f 07 a0 13 93 54  GVOT.LVIC.O....T
  9490: 54 54 30 0a 02 a4 47 56 4f 54 0a 02 4c 56 49 43  TT0...GVOT..LVIC
  94a0: a1 48 06 a0 13 93 54 54 54 30 0a 03 a4 47 56 4f  .H....TTT0...GVO
  94b0: 54 0a 03 4c 56 49 43 a1 41 05 a0 13 93 54 54 54  T..LVIC.A....TTT
  94c0: 30 0a 04 a4 47 56 4f 54 0a 04 4c 56 49 43 a1 3a  0...GVOT..LVIC.:
  94d0: a0 34 93 54 54 54 30 0a 05 a0 15 93 47 4e 56 53  .4.TTT0.....GNVS
  94e0: 0b 5c 45 00 77 0a 04 47 4e 56 53 0b 5c 45 60 a1  .\E.w..GNVS.\E`.
  94f0: 06 77 0a 04 01 60 a4 83 88 44 46 53 42 72 4c 56  .w...`...DFSBrLV
  9500: 49 43 60 00 00 a1 03 a4 00 14 0e 41 47 4c 53 01  IC`........AGLS.
  9510: 70 68 4c 56 49 43 a4 01 14 13 41 47 43 56 01 53  phLVIC....AGCV.S
  9520: 56 4f 54 0a 02 4c 56 49 43 68 a4 01 14 19 53 56  VOT..LVICh....SV
  9530: 4f 54 03 72 68 77 69 0a 06 00 60 70 6a 88 4f 4c  OT.rhwi...`pj.OL
  9540: 54 42 60 00 a4 01 14 1a 47 56 4f 54 02 72 68 77  TB`.....GVOT.rhw
  9550: 69 0a 06 00 60 70 83 88 4f 4c 54 42 60 00 61 a4  i...`p..OLTB`.a.
  9560: 61 14 2e 53 54 43 47 01 08 54 54 54 30 00 70 7b  a..STCG..TTT0.p{
  9570: 68 0a ff 00 54 54 54 30 a0 07 93 54 54 54 30 00  h...TTT0...TTT0.
  9580: a1 0d a0 07 93 54 54 54 30 01 a1 03 a4 00 a4 01  .....TTT0.......
  9590: 14 4a 07 53 49 43 4c 01 a0 11 7b 68 0b 00 80 00  .J.SICL...{h....
  95a0: 70 01 41 49 47 43 49 54 41 54 a1 4e 05 70 00 41  p.AIGCITAT.N.p.A
  95b0: 49 47 43 08 54 54 54 30 00 70 7b 68 0a ff 00 54  IGC.TTT0.p{h...T
  95c0: 54 54 30 a0 12 93 54 54 54 30 00 53 50 49 43 01  TT0...TTT0.SPIC.
  95d0: 70 01 50 49 43 4c a1 32 a0 14 93 54 54 54 30 01  p.PICL.2...TTT0.
  95e0: 53 50 49 43 0a 02 70 0a 02 50 49 43 4c a1 1b a0  SPIC..p..PICL...
  95f0: 15 93 54 54 54 30 0a 02 53 50 49 43 0a 03 70 0a  ..TTT0..SPIC..p.
  9600: 03 50 49 43 4c a1 03 a4 00 a4 01 14 4d 08 49 54  .PICL.......M.IT
  9610: 41 54 00 a0 45 08 92 5b 23 5e 5e 2e 45 43 30 5f  AT..E..[#^^.EC0_
  9620: 4d 55 45 43 ff ff 45 50 55 46 83 88 4f 4c 54 42  MUEC..EPUF..OLTB
  9630: 0a 14 00 70 56 49 44 54 83 88 4f 4c 54 42 0a 08  ...pVIDT..OLTB..
  9640: 00 5e 5e 2e 45 43 30 5f 45 4c 31 43 70 01 5e 5e  .^^.EC0_EL1Cp.^^
  9650: 2e 45 43 30 5f 45 4c 31 53 70 56 49 44 54 83 88  .EC0_EL1SpVIDT..
  9660: 4f 4c 54 42 0a 14 00 5e 5e 2e 45 43 30 5f 45 4c  OLTB...^^.EC0_EL
  9670: 33 43 70 00 5e 5e 2e 45 43 30 5f 45 4c 33 53 70  3Cp.^^.EC0_EL3Sp
  9680: 01 5e 5e 2e 45 43 30 5f 45 50 55 45 5b 27 5e 5e  .^^.EC0_EPUE['^^
  9690: 2e 45 43 30 5f 4d 55 45 43 14 4f 0b 53 50 49 43  .EC0_MUEC.O.SPIC
  96a0: 01 72 77 68 0a 06 00 0a 02 60 a0 4e 0a 92 5b 23  .rwh.....`.N..[#
  96b0: 5e 5e 2e 45 43 30 5f 4d 55 45 43 ff ff 70 00 5e  ^^.EC0_MUEC..p.^
  96c0: 5e 2e 45 43 30 5f 45 50 55 45 45 50 55 46 83 88  ^.EC0_EPUEEPUF..
  96d0: 4f 4c 54 42 60 00 08 54 54 54 30 00 70 68 54 54  OLTB`..TTT0.phTT
  96e0: 54 30 a0 2c 93 54 54 54 30 01 70 56 49 44 54 83  T0.,.TTT0.pVIDT.
  96f0: 88 4f 4c 54 42 60 00 5e 5e 2e 45 43 30 5f 45 4c  .OLTB`.^^.EC0_EL
  9700: 31 43 70 01 5e 5e 2e 45 43 30 5f 45 4c 31 53 a1  1Cp.^^.EC0_EL1S.
  9710: 2f a0 2d 93 54 54 54 30 0a 03 70 56 49 44 54 83  /.-.TTT0..pVIDT.
  9720: 88 4f 4c 54 42 60 00 5e 5e 2e 45 43 30 5f 45 4c  .OLTB`.^^.EC0_EL
  9730: 33 43 70 00 5e 5e 2e 45 43 30 5f 45 4c 33 53 70  3Cp.^^.EC0_EL3Sp
  9740: 68 5e 5e 2e 45 43 30 5f 45 50 55 4d 5b 27 5e 5e  h^^.EC0_EPUM['^^
  9750: 2e 45 43 30 5f 4d 55 45 43 14 4e 04 56 49 44 54  .EC0_MUEC.N.VIDT
  9760: 01 a0 20 95 43 56 49 44 47 44 56 44 74 47 44 56  .. .CVIDGDVDtGDV
  9770: 44 43 56 49 44 60 7d 7a 60 01 00 0a 80 60 72 60  DCVID`}z`....`r`
  9780: 68 60 a1 23 74 43 56 49 44 47 44 56 44 60 7a 60  h`.#tCVIDGDVD`z`
  9790: 01 60 a0 0d 94 68 60 74 68 60 60 7d 60 0a 80 60  .`...h`th``}`..`
  97a0: a1 05 74 60 68 60 a4 60 14 3c 45 50 55 46 01 a0  ..t`h`.`.<EPUF..
  97b0: 23 92 95 43 56 49 44 79 68 01 00 74 43 56 49 44  #..CVIDyh..tCVID
  97c0: 79 68 01 00 60 70 00 61 a0 0a 95 60 47 44 56 44  yh..`p.a...`GDVD
  97d0: 70 01 61 a1 04 70 01 61 70 61 5e 5e 2e 45 43 30  p.a..p.apa^^.EC0
  97e0: 5f 52 45 50 55 14 0d 52 42 45 43 02 a4 52 53 42  _REPU..RBEC..RSB
  97f0: 44 68 69 14 14 57 42 45 43 03 57 53 42 44 68 69  Dhi..WBEC.WSBDhi
  9800: 6a a4 52 53 42 44 68 69 14 14 52 53 42 44 02 a4  j.RSBDhi..RSBD..
  9810: 5e 5e 2e 45 43 30 5f 45 43 42 52 68 69 14 14 57  ^^.EC0_ECBRhi..W
  9820: 53 42 44 03 5e 5e 2e 45 43 30 5f 45 43 42 57 68  SBD.^^.EC0_ECBWh
  9830: 69 6a 10 4c 42 2f 04 5f 53 42 5f 50 43 49 30 53  ij.LB/._SB_PCI0S
  9840: 42 52 47 41 53 4f 43 08 47 46 30 31 12 43 05 09  BRGASOC.GF01.C..
  9850: 0c 00 00 08 0f 0d 43 50 55 20 4c 65 76 65 6c 20  ......CPU Level 
  9860: 55 70 00 00 00 0a 04 0d 4f 72 69 67 69 6e 61 6c  Up......Original
  9870: 00 0d 50 68 65 6e 6f 6d 20 49 49 20 37 32 30 00  ..Phenom II 720.
  9880: 0d 50 68 65 6e 6f 6d 20 49 49 20 33 2e 30 47 00  .Phenom II 3.0G.
  9890: 0d 50 68 65 6e 6f 6d 20 49 49 20 33 2e 32 47 00  .Phenom II 3.2G.
  98a0: 08 47 46 30 32 12 44 05 09 0c 00 00 08 0f 0d 43  .GF02.D........C
  98b0: 50 55 20 4c 65 76 65 6c 20 55 70 00 00 00 0a 04  PU Level Up.....
  98c0: 0d 4f 72 69 67 69 6e 61 6c 00 0d 50 68 65 6e 6f  .Original..Pheno
  98d0: 6d 20 49 49 20 33 2e 30 47 00 0d 50 68 65 6e 6f  m II 3.0G..Pheno
  98e0: 6d 20 49 49 20 33 2e 32 47 00 0d 50 68 65 6e 6f  m II 3.2G..Pheno
  98f0: 6d 20 49 49 20 33 2e 34 47 00 08 47 46 30 33 12  m II 3.4G..GF03.
  9900: 41 05 09 0c 00 00 08 0f 0d 43 50 55 20 4c 65 76  A........CPU Lev
  9910: 65 6c 20 55 70 00 00 00 0a 04 0d 4f 72 69 67 69  el Up......Origi
  9920: 6e 61 6c 00 0d 50 68 65 6e 6f 6d 20 49 49 20 39  nal..Phenom II 9
  9930: 31 30 00 0d 50 68 65 6e 6f 6d 20 49 49 20 39 32  10..Phenom II 92
  9940: 35 00 0d 50 68 65 6e 6f 6d 20 49 49 20 39 34 35  5..Phenom II 945
  9950: 00 08 47 46 30 34 12 41 05 09 0c 00 00 08 0f 0d  ..GF04.A........
  9960: 43 50 55 20 4c 65 76 65 6c 20 55 70 00 00 00 0a  CPU Level Up....
  9970: 04 0d 4f 72 69 67 69 6e 61 6c 00 0d 50 68 65 6e  ..Original..Phen
  9980: 6f 6d 20 49 49 20 39 32 35 00 0d 50 68 65 6e 6f  om II 925..Pheno
  9990: 6d 20 49 49 20 39 34 35 00 0d 50 68 65 6e 6f 6d  m II 945..Phenom
  99a0: 20 49 49 20 39 35 35 00 08 47 46 30 35 12 41 05   II 955..GF05.A.
  99b0: 09 0c 00 00 08 0f 0d 43 50 55 20 4c 65 76 65 6c  .......CPU Level
  99c0: 20 55 70 00 00 00 0a 04 0d 4f 72 69 67 69 6e 61   Up......Origina
  99d0: 6c 00 0d 50 68 65 6e 6f 6d 20 49 49 20 39 32 35  l..Phenom II 925
  99e0: 00 0d 50 68 65 6e 6f 6d 20 49 49 20 39 34 35 00  ..Phenom II 945.
  99f0: 0d 50 68 65 6e 6f 6d 20 49 49 20 39 35 35 00 08  .Phenom II 955..
  9a00: 47 46 30 36 12 42 05 09 0c 00 00 08 0f 0d 43 50  GF06.B........CP
  9a10: 55 20 4c 65 76 65 6c 20 55 70 00 00 00 0a 04 0d  U Level Up......
  9a20: 4f 72 69 67 69 6e 61 6c 00 0d 50 68 65 6e 6f 6d  Original..Phenom
  9a30: 20 49 49 20 39 34 35 00 0d 50 68 65 6e 6f 6d 20   II 945..Phenom 
  9a40: 49 49 20 39 35 35 00 0d 50 68 65 6e 6f 6d 20 49  II 955..Phenom I
  9a50: 49 20 33 2e 34 47 00 08 47 46 30 37 12 43 05 09  I 3.4G..GF07.C..
  9a60: 0c 00 00 08 0f 0d 43 50 55 20 4c 65 76 65 6c 20  ......CPU Level 
  9a70: 55 70 00 00 00 0a 04 0d 4f 72 69 67 69 6e 61 6c  Up......Original
  9a80: 00 0d 50 68 65 6e 6f 6d 20 49 49 20 39 35 35 00  ..Phenom II 955.
  9a90: 0d 50 68 65 6e 6f 6d 20 49 49 20 33 2e 34 47 00  .Phenom II 3.4G.
  9aa0: 0d 50 68 65 6e 6f 6d 20 49 49 20 33 2e 36 47 00  .Phenom II 3.6G.
  9ab0: 08 47 46 30 38 12 44 05 09 0c 00 00 08 0f 0d 43  .GF08.D........C
  9ac0: 50 55 20 4c 65 76 65 6c 20 55 70 00 00 00 0a 04  PU Level Up.....
  9ad0: 0d 4f 72 69 67 69 6e 61 6c 00 0d 50 68 65 6e 6f  .Original..Pheno
  9ae0: 6d 20 49 49 20 33 2e 34 47 00 0d 50 68 65 6e 6f  m II 3.4G..Pheno
  9af0: 6d 20 49 49 20 33 2e 36 47 00 0d 50 68 65 6e 6f  m II 3.6G..Pheno
  9b00: 6d 20 49 49 20 33 2e 38 47 00 14 49 0b 47 52 50  m II 3.8G..I.GRP
  9b10: 46 00 70 47 4e 56 53 0b a8 57 60 08 54 54 54 30  F.pGNVS..W`.TTT0
  9b20: 00 70 60 54 54 54 30 a0 0f 93 54 54 54 30 01 a4  .p`TTT0...TTT0..
  9b30: 12 06 01 47 46 30 31 a1 48 08 a0 10 93 54 54 54  ...GF01.H....TTT
  9b40: 30 0a 02 a4 12 06 01 47 46 30 32 a1 44 07 a0 10  0......GF02.D...
  9b50: 93 54 54 54 30 0a 03 a4 12 06 01 47 46 30 33 a1  .TTT0......GF03.
  9b60: 40 06 a0 10 93 54 54 54 30 0a 04 a4 12 06 01 47  @....TTT0......G
  9b70: 46 30 34 a1 4c 04 a0 10 93 54 54 54 30 0a 05 a4  F04.L....TTT0...
  9b80: 12 06 01 47 46 30 35 a1 38 a0 10 93 54 54 54 30  ...GF05.8...TTT0
  9b90: 0a 06 a4 12 06 01 47 46 30 36 a1 25 a0 10 93 54  ......GF06.%...T
  9ba0: 54 54 30 0a 07 a4 12 06 01 47 46 30 37 a1 12 a0  TT0......GF07...
  9bb0: 10 93 54 54 54 30 0a 08 a4 12 06 01 47 46 30 38  ..TTT0......GF08
  9bc0: a4 12 02 00 14 33 47 49 54 46 01 08 54 54 54 30  .....3GITF..TTT0
  9bd0: 00 70 7b 68 0b ff ff 00 54 54 54 30 a0 13 93 54  .p{h....TTT0...T
  9be0: 54 54 30 00 70 47 4e 56 53 0b a4 26 41 53 42 31  TT0.pGNVS..&ASB1
  9bf0: a1 07 70 00 41 53 42 30 14 46 06 53 49 54 46 03  ..p.ASB0.F.SITF.
  9c00: 08 54 54 54 30 00 70 7b 68 0b ff ff 00 54 54 54  .TTT0.p{h....TTT
  9c10: 30 a0 4b 04 93 54 54 54 30 00 70 00 41 53 42 30  0.K..TTT0.p.ASB0
  9c20: a0 0f 93 6a 00 7d 41 53 42 30 0a 03 41 53 42 30  ...j.}ASB0..ASB0
  9c30: a0 2c 7b 6a 01 00 70 69 50 41 52 30 49 53 4d 49  .,{j..piPAR0ISMI
  9c40: 0a ac 70 7b 50 41 52 30 0b ff ff 00 60 a0 0f 93  ..p{PAR0....`...
  9c50: 60 01 7d 41 53 42 30 0a 03 41 53 42 30 a1 01 10  `.}ASB0..ASB0...
  9c60: 48 60 5f 53 42 5f 5b 80 50 49 52 51 01 0b 00 0c  H`_SB_[.PIRQ....
  9c70: 0a 02 5b 81 10 50 49 52 51 01 50 49 44 58 08 50  ..[..PIRQ.PIDX.P
  9c80: 44 41 54 08 5b 86 43 09 50 49 44 58 50 44 41 54  DAT.[.C.PIDXPDAT
  9c90: 01 50 49 52 41 08 50 49 52 42 08 50 49 52 43 08  .PIRA.PIRB.PIRC.
  9ca0: 50 49 52 44 08 50 49 52 45 08 50 49 52 46 08 50  PIRD.PIRE.PIRF.P
  9cb0: 49 52 47 08 50 49 52 48 08 00 40 04 50 49 52 53  IRG.PIRH..@.PIRS
  9cc0: 08 00 10 48 44 41 44 08 00 08 47 45 43 5f 08 00  ...HDAD...GEC_..
  9cd0: 40 0d 55 53 42 31 08 55 53 42 32 08 55 53 42 33  @.USB1.USB2.USB3
  9ce0: 08 55 53 42 34 08 55 53 42 35 08 55 53 42 36 08  .USB4.USB5.USB6.
  9cf0: 55 53 42 37 08 00 48 04 49 44 45 5f 08 53 41 54  USB7..H.IDE_.SAT
  9d00: 41 08 00 40 07 47 50 50 30 08 47 50 50 31 08 47  A..@.GPP0.GPP1.G
  9d10: 50 50 32 08 47 50 50 33 08 5b 80 4b 42 44 44 01  PP2.GPP3.[.KBDD.
  9d20: 0a 64 01 5b 81 0b 4b 42 44 44 01 50 44 36 34 08  .d.[..KBDD.PD64.
  9d30: 14 41 04 49 52 51 43 00 49 4e 54 41 0a 1f 49 4e  .A.IRQC.INTA..IN
  9d40: 54 42 0a 1f 49 4e 54 43 0a 1f 49 4e 54 44 0a 1f  TB..INTC..INTD..
  9d50: 70 50 44 36 34 61 70 0a 1f 50 49 52 45 70 0a 1f  pPD64ap..PIREp..
  9d60: 50 49 52 46 70 0a 1f 50 49 52 47 70 0a 1f 50 49  PIRFp..PIRGp..PI
  9d70: 52 48 14 24 49 4e 54 41 01 70 68 50 49 52 41 70  RH.$INTA.phPIRAp
  9d80: 68 48 44 41 44 70 68 47 45 43 5f 70 68 47 50 50  hHDADphGEC_phGPP
  9d90: 30 70 68 47 50 50 30 14 2a 49 4e 54 42 01 70 68  0phGPP0.*INTB.ph
  9da0: 50 49 52 42 70 68 55 53 42 32 70 68 55 53 42 34  PIRBphUSB2phUSB4
  9db0: 70 68 55 53 42 36 70 68 47 50 50 31 70 68 49 44  phUSB6phGPP1phID
  9dc0: 45 5f 14 2a 49 4e 54 43 01 70 68 50 49 52 43 70  E_.*INTC.phPIRCp
  9dd0: 68 55 53 42 31 70 68 55 53 42 33 70 68 55 53 42  hUSB1phUSB3phUSB
  9de0: 35 70 68 55 53 42 37 70 68 47 50 50 32 14 18 49  5phUSB7phGPP2..I
  9df0: 4e 54 44 01 70 68 50 49 52 44 70 68 53 41 54 41  NTD.phPIRDphSATA
  9e00: 70 68 47 50 50 33 08 42 55 46 41 11 09 0a 06 23  phGPP3.BUFA....#
  9e10: 00 80 18 79 00 08 49 50 52 41 11 09 0a 06 23 20  ...y..IPRA....# 
  9e20: 0c 18 79 00 08 49 50 52 42 11 09 0a 06 23 20 0c  ..y..IPRB....# .
  9e30: 18 79 00 08 49 50 52 43 11 09 0a 06 23 20 0c 18  .y..IPRC....# ..
  9e40: 79 00 08 49 50 52 44 11 09 0a 06 23 20 0c 18 79  y..IPRD....# ..y
  9e50: 00 5b 82 4f 07 4c 4e 4b 41 08 5f 48 49 44 0c 41  .[.O.LNKA._HID.A
  9e60: d0 0c 0f 08 5f 55 49 44 01 14 14 5f 53 54 41 00  ...._UID..._STA.
  9e70: a0 08 50 49 52 41 a4 0a 0b a1 04 a4 0a 09 14 0b  ..PIRA..........
  9e80: 5f 50 52 53 00 a4 50 52 53 41 14 0c 5f 44 49 53  _PRS..PRSA.._DIS
  9e90: 00 49 4e 54 41 0a 1f 14 1f 5f 43 52 53 00 8b 42  .INTA...._CRS..B
  9ea0: 55 46 41 01 49 52 51 58 79 01 50 49 52 41 49 52  UFA.IRQXy.PIRAIR
  9eb0: 51 58 a4 42 55 46 41 14 1a 5f 53 52 53 01 8b 68  QX.BUFA.._SRS..h
  9ec0: 01 49 52 41 5f 82 49 52 41 5f 60 76 60 49 4e 54  .IRA_.IRA_`v`INT
  9ed0: 41 60 5b 82 40 08 4c 4e 4b 42 08 5f 48 49 44 0c  A`[.@.LNKB._HID.
  9ee0: 41 d0 0c 0f 08 5f 55 49 44 0a 02 14 14 5f 53 54  A...._UID...._ST
  9ef0: 41 00 a0 08 50 49 52 42 a4 0a 0b a1 04 a4 0a 09  A...PIRB........
  9f00: 14 0b 5f 50 52 53 00 a4 50 52 53 42 14 0c 5f 44  .._PRS..PRSB.._D
  9f10: 49 53 00 49 4e 54 42 0a 1f 14 1f 5f 43 52 53 00  IS.INTB...._CRS.
  9f20: 8b 42 55 46 41 01 49 52 51 58 79 01 50 49 52 42  .BUFA.IRQXy.PIRB
  9f30: 49 52 51 58 a4 42 55 46 41 14 1a 5f 53 52 53 01  IRQX.BUFA.._SRS.
  9f40: 8b 68 01 49 52 41 5f 82 49 52 41 5f 60 76 60 49  .h.IRA_.IRA_`v`I
  9f50: 4e 54 42 60 5b 82 40 08 4c 4e 4b 43 08 5f 48 49  NTB`[.@.LNKC._HI
  9f60: 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a 03 14 14 5f  D.A...._UID...._
  9f70: 53 54 41 00 a0 08 50 49 52 43 a4 0a 0b a1 04 a4  STA...PIRC......
  9f80: 0a 09 14 0b 5f 50 52 53 00 a4 50 52 53 43 14 0c  ...._PRS..PRSC..
  9f90: 5f 44 49 53 00 49 4e 54 43 0a 1f 14 1f 5f 43 52  _DIS.INTC...._CR
  9fa0: 53 00 8b 42 55 46 41 01 49 52 51 58 79 01 50 49  S..BUFA.IRQXy.PI
  9fb0: 52 43 49 52 51 58 a4 42 55 46 41 14 1a 5f 53 52  RCIRQX.BUFA.._SR
  9fc0: 53 01 8b 68 01 49 52 41 5f 82 49 52 41 5f 60 76  S..h.IRA_.IRA_`v
  9fd0: 60 49 4e 54 43 60 5b 82 40 08 4c 4e 4b 44 08 5f  `INTC`[.@.LNKD._
  9fe0: 48 49 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a 04 14  HID.A...._UID...
  9ff0: 14 5f 53 54 41 00 a0 08 50 49 52 44 a4 0a 0b a1  ._STA...PIRD....
  a000: 04 a4 0a 09 14 0b 5f 50 52 53 00 a4 50 52 53 44  ......_PRS..PRSD
  a010: 14 0c 5f 44 49 53 00 49 4e 54 44 0a 1f 14 1f 5f  .._DIS.INTD...._
  a020: 43 52 53 00 8b 42 55 46 41 01 49 52 51 58 79 01  CRS..BUFA.IRQXy.
  a030: 50 49 52 44 49 52 51 58 a4 42 55 46 41 14 1a 5f  PIRDIRQX.BUFA.._
  a040: 53 52 53 01 8b 68 01 49 52 41 5f 82 49 52 41 5f  SRS..h.IRA_.IRA_
  a050: 60 76 60 49 4e 54 44 60 5b 82 42 08 4c 4e 4b 45  `v`INTD`[.B.LNKE
  a060: 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a  ._HID.A...._UID.
  a070: 05 14 14 5f 53 54 41 00 a0 08 50 49 52 45 a4 0a  ..._STA...PIRE..
  a080: 0b a1 04 a4 0a 09 14 0b 5f 50 52 53 00 a4 50 52  ........_PRS..PR
  a090: 53 45 14 0d 5f 44 49 53 00 70 0a 1f 50 49 52 45  SE.._DIS.p..PIRE
  a0a0: 14 1f 5f 43 52 53 00 8b 42 55 46 41 01 49 52 51  .._CRS..BUFA.IRQ
  a0b0: 58 79 01 50 49 52 45 49 52 51 58 a4 42 55 46 41  Xy.PIREIRQX.BUFA
  a0c0: 14 1b 5f 53 52 53 01 8b 68 01 49 52 41 5f 82 50  .._SRS..h.IRA_.P
  a0d0: 49 52 45 60 76 60 70 60 50 49 52 45 5b 82 42 08  IRE`v`p`PIRE[.B.
  a0e0: 4c 4e 4b 46 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f  LNKF._HID.A...._
  a0f0: 55 49 44 0a 02 14 14 5f 53 54 41 00 a0 08 50 49  UID...._STA...PI
  a100: 52 46 a4 0a 0b a1 04 a4 0a 09 14 0b 5f 50 52 53  RF.........._PRS
  a110: 00 a4 50 52 53 46 14 0d 5f 44 49 53 00 70 0a 1f  ..PRSF.._DIS.p..
  a120: 50 49 52 46 14 1f 5f 43 52 53 00 8b 42 55 46 41  PIRF.._CRS..BUFA
  a130: 01 49 52 51 58 79 01 50 49 52 46 49 52 51 58 a4  .IRQXy.PIRFIRQX.
  a140: 42 55 46 41 14 1b 5f 53 52 53 01 8b 68 01 49 52  BUFA.._SRS..h.IR
  a150: 41 5f 82 49 52 41 5f 60 76 60 70 60 50 49 52 46  A_.IRA_`v`p`PIRF
  a160: 5b 82 42 08 4c 4e 4b 47 08 5f 48 49 44 0c 41 d0  [.B.LNKG._HID.A.
  a170: 0c 0f 08 5f 55 49 44 0a 03 14 14 5f 53 54 41 00  ..._UID...._STA.
  a180: a0 08 50 49 52 47 a4 0a 0b a1 04 a4 0a 09 14 0b  ..PIRG..........
  a190: 5f 50 52 53 00 a4 50 52 53 47 14 0d 5f 44 49 53  _PRS..PRSG.._DIS
  a1a0: 00 70 0a 1f 50 49 52 47 14 1f 5f 43 52 53 00 8b  .p..PIRG.._CRS..
  a1b0: 42 55 46 41 01 49 52 51 58 79 01 50 49 52 47 49  BUFA.IRQXy.PIRGI
  a1c0: 52 51 58 a4 42 55 46 41 14 1b 5f 53 52 53 01 8b  RQX.BUFA.._SRS..
  a1d0: 68 01 49 52 41 5f 82 49 52 41 5f 60 76 60 70 60  h.IRA_.IRA_`v`p`
  a1e0: 50 49 52 47 5b 82 42 08 4c 4e 4b 48 08 5f 48 49  PIRG[.B.LNKH._HI
  a1f0: 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a 04 14 14 5f  D.A...._UID...._
  a200: 53 54 41 00 a0 08 50 49 52 48 a4 0a 0b a1 04 a4  STA...PIRH......
  a210: 0a 09 14 0b 5f 50 52 53 00 a4 50 52 53 48 14 0d  ...._PRS..PRSH..
  a220: 5f 44 49 53 00 70 0a 1f 50 49 52 48 14 1f 5f 43  _DIS.p..PIRH.._C
  a230: 52 53 00 8b 42 55 46 41 01 49 52 51 58 79 01 50  RS..BUFA.IRQXy.P
  a240: 49 52 48 49 52 51 58 a4 42 55 46 41 14 1b 5f 53  IRHIRQX.BUFA.._S
  a250: 52 53 01 8b 68 01 49 52 41 5f 82 49 52 41 5f 60  RS..h.IRA_.IRA_`
  a260: 76 60 70 60 50 49 52 48 10 49 25 5f 53 42 5f 08  v`p`PIRH.I%_SB_.
  a270: 58 43 50 44 00 08 58 4e 50 54 01 08 58 43 41 50  XCPD..XNPT..XCAP
  a280: 0a 02 08 58 44 43 50 0a 04 08 58 44 43 54 0a 08  ...XDCP...XDCT..
  a290: 08 58 44 53 54 0a 0a 08 58 4c 43 50 0a 0c 08 58  .XDST...XLCP...X
  a2a0: 4c 43 54 0a 10 08 58 4c 53 54 0a 12 08 58 53 43  LCT...XLST...XSC
  a2b0: 50 0a 14 08 58 53 43 54 0a 18 08 58 53 53 54 0a  P...XSCT...XSST.
  a2c0: 1a 08 58 52 43 54 0a 1c 5b 01 4d 55 54 45 00 14  ..XRCT..[.MUTE..
  a2d0: 36 52 42 50 45 01 5b 23 4d 55 54 45 e8 03 72 68  6RBPE.[#MUTE..rh
  a2e0: 50 43 49 42 60 5b 80 50 43 46 47 00 60 01 5b 81  PCIB`[.PCFG.`.[.
  a2f0: 0b 50 43 46 47 01 58 43 46 47 08 5b 27 4d 55 54  .PCFG.XCFG.['MUT
  a300: 45 a4 58 43 46 47 14 3f 52 57 50 45 01 5b 23 4d  E.XCFG.?RWPE.[#M
  a310: 55 54 45 e8 03 7b 68 0c fe ff ff ff 68 72 68 50  UTE..{h.....hrhP
  a320: 43 49 42 60 5b 80 50 43 46 47 00 60 0a 02 5b 81  CIB`[.PCFG.`..[.
  a330: 0b 50 43 46 47 02 58 43 46 47 10 5b 27 4d 55 54  .PCFG.XCFG.['MUT
  a340: 45 a4 58 43 46 47 14 3f 52 44 50 45 01 5b 23 4d  E.XCFG.?RDPE.[#M
  a350: 55 54 45 e8 03 7b 68 0c fc ff ff ff 68 72 68 50  UTE..{h.....hrhP
  a360: 43 49 42 60 5b 80 50 43 46 47 00 60 0a 04 5b 81  CIB`[.PCFG.`..[.
  a370: 0b 50 43 46 47 03 58 43 46 47 20 5b 27 4d 55 54  .PCFG.XCFG ['MUT
  a380: 45 a4 58 43 46 47 14 37 57 42 50 45 02 5b 23 4d  E.XCFG.7WBPE.[#M
  a390: 55 54 45 ff 0f 72 68 50 43 49 42 60 5b 80 50 43  UTE..rhPCIB`[.PC
  a3a0: 46 47 00 60 01 5b 81 0b 50 43 46 47 01 58 43 46  FG.`.[..PCFG.XCF
  a3b0: 47 08 70 69 58 43 46 47 5b 27 4d 55 54 45 14 41  G.piXCFG['MUTE.A
  a3c0: 04 57 57 50 45 02 5b 23 4d 55 54 45 e8 03 7b 68  .WWPE.[#MUTE..{h
  a3d0: 0c fe ff ff ff 68 72 68 50 43 49 42 60 5b 80 50  .....hrhPCIB`[.P
  a3e0: 43 46 47 00 60 0a 02 5b 81 0b 50 43 46 47 02 58  CFG.`..[..PCFG.X
  a3f0: 43 46 47 10 70 69 58 43 46 47 5b 27 4d 55 54 45  CFG.piXCFG['MUTE
  a400: 14 41 04 57 44 50 45 02 5b 23 4d 55 54 45 e8 03  .A.WDPE.[#MUTE..
  a410: 7b 68 0c fc ff ff ff 68 72 68 50 43 49 42 60 5b  {h.....hrhPCIB`[
  a420: 80 50 43 46 47 00 60 0a 04 5b 81 0b 50 43 46 47  .PCFG.`..[..PCFG
  a430: 03 58 43 46 47 20 70 69 58 43 46 47 5b 27 4d 55  .XCFG piXCFG['MU
  a440: 54 45 14 49 04 52 57 44 50 03 5b 23 4d 55 54 45  TE.I.RWDP.[#MUTE
  a450: e8 03 7b 68 0c fc ff ff ff 68 72 68 50 43 49 42  ..{h.....hrhPCIB
  a460: 60 5b 80 50 43 46 47 00 60 0a 04 5b 81 0b 50 43  `[.PCFG.`..[..PC
  a470: 46 47 03 58 43 46 47 20 7b 58 43 46 47 6a 61 7d  FG.XCFG {XCFGja}
  a480: 61 69 58 43 46 47 5b 27 4d 55 54 45 14 35 52 50  aiXCFG['MUTE.5RP
  a490: 4d 45 01 72 68 0a 84 60 70 52 44 50 45 60 61 a0  ME.rh..`pRDPE`a.
  a4a0: 06 93 61 ff a4 00 a1 1b a0 17 90 61 0c 00 00 01  ..a........a....
  a4b0: 00 57 44 50 45 60 7b 61 0c 00 00 01 00 00 a4 01  .WDPE`{a........
  a4c0: a4 00 14 06 53 42 59 54 02 14 06 57 42 59 54 03  ....SBYT...WBYT.
  a4d0: 14 06 57 57 52 44 03 14 0b 52 53 42 54 02 70 00  ..WWRD...RSBT.p.
  a4e0: 60 a4 60 14 0b 52 42 59 54 02 70 00 60 a4 60 14  `.`..RBYT.p.`.`.
  a4f0: 0b 52 57 52 44 02 70 00 60 a4 60 14 06 57 42 4c  .RWRD.p.`.`..WBL
  a500: 4b 04 14 0b 52 42 4c 4b 03 70 00 60 a4 60 10 46  K...RBLK.p.`.`.F
  a510: 1c 2f 04 5f 53 42 5f 50 43 49 30 53 42 52 47 41  ./._SB_PCI0SBRGA
  a520: 53 4f 43 08 45 43 53 4d 12 21 07 0c 04 00 06 11  SOC.ECSM.!......
  a530: 0d 45 6d 62 65 64 64 65 64 20 43 6f 6e 74 72 6f  .Embedded Contro
  a540: 6c 6c 65 72 00 01 00 00 01 01 08 47 50 31 31 12  ller.......GP11.
  a550: 1e 07 0c 07 00 06 11 0d 57 61 74 63 68 64 6f 67  ........Watchdog
  a560: 20 54 69 6d 65 72 00 01 00 00 01 0b d1 07 08 47   Timer.........G
  a570: 52 31 31 12 0a 02 47 50 31 31 45 43 53 4d 14 42  R11...GP11ECSM.B
  a580: 08 47 54 31 31 02 08 54 54 54 30 00 70 7b 68 0b  .GT11..TTT0.p{h.
  a590: ff ff 00 54 54 54 30 a0 37 93 54 54 54 30 0a 04  ...TTT0.7.TTT0..
  a5a0: a0 2e 92 5b 23 5e 5e 2e 45 43 30 5f 4d 55 45 43  ...[#^^.EC0_MUEC
  a5b0: ff ff 70 5e 5e 2e 45 43 30 5f 48 57 4d 45 41 53  ..p^^.EC0_HWMEAS
  a5c0: 42 31 5b 27 5e 5e 2e 45 43 30 5f 4d 55 45 43 a1  B1['^^.EC0_MUEC.
  a5d0: 31 a0 27 93 54 54 54 30 0a 07 52 53 4d 42 0a d2  1.'.TTT0..RSMB..
  a5e0: 00 0a 1f 7b 43 42 31 30 0a e0 60 7a 60 0a 05 60  ...{CB10..`z`..`
  a5f0: 77 60 0b 88 04 41 53 42 31 a1 07 70 00 41 53 42  w`...ASB1..p.ASB
  a600: 30 14 43 0d 53 54 31 31 03 08 54 54 54 30 00 70  0.C.ST11..TTT0.p
  a610: 7b 68 0b ff ff 00 54 54 54 30 a0 0e 93 54 54 54  {h....TTT0...TTT
  a620: 30 0a 04 70 01 41 53 42 30 a1 4b 0a a0 40 0a 93  0..p.ASB0.K..@..
  a630: 54 54 54 30 0a 07 a0 21 93 69 00 52 53 4d 42 0a  TTT0...!.i.RSMB.
  a640: d2 00 0a 1f 7b 43 42 30 39 0a 3f 43 42 30 39 57  ....{CB09.?CB09W
  a650: 53 4d 42 0a d2 00 0a 0a a0 4e 06 92 93 69 00 78  SMB......N...i.x
  a660: 69 0b 88 04 61 60 a0 0b 92 95 61 0b 44 02 72 60  i...a`....a.D.r`
  a670: 01 60 a0 07 93 60 00 70 01 60 a0 09 94 60 0a 07  .`...`.p.`...`..
  a680: 70 0a 07 60 52 53 4d 42 0a d2 00 0a 1f 7b 43 42  p..`RSMB.....{CB
  a690: 30 39 0a 3f 43 42 30 39 57 53 4d 42 0a d2 00 0a  09.?CB09WSMB....
  a6a0: 0a 52 53 4d 42 0a d2 00 0a 1f 70 0a 88 43 42 30  .RSMB.....p..CB0
  a6b0: 39 79 60 0a 05 60 7d 60 0a 0f 43 42 31 30 57 53  9y`..`}`..CB10WS
  a6c0: 4d 42 0a d2 00 0a 0b 70 01 41 53 42 30 a1 07 70  MB.....p.ASB0..p
  a6d0: 00 41 53 42 30 14 06 4e 42 32 53 01 14 06 4e 42  .ASB0..NB2S...NB
  a6e0: 32 57 01 10 41 4d 2f 04 5f 53 42 5f 50 43 49 30  2W..AM/._SB_PCI0
  a6f0: 53 42 52 47 53 49 4f 52 14 3a 48 53 46 30 00 70  SBRGSIOR.:HSF0.p
  a700: 53 42 46 30 60 a0 2b 92 93 7b 60 0b ff ff 00 0b  SBF0`.+..{`.....
  a710: ff ff a0 1e 92 93 7b 60 0b ff ff 00 00 70 0a 3c  ......{`.....p.<
  a720: 60 77 60 0b 60 2c 60 78 60 53 42 46 30 00 60 a4  `w`.`,`x`SBF0.`.
  a730: 60 a4 00 14 0f 48 57 56 30 00 a4 77 56 49 56 30  `....HWV0..wVIV0
  a740: 0a 0c 00 14 0f 48 57 56 31 00 a4 77 56 49 56 31  .....HWV1..wVIV1
  a750: 0a 0c 00 14 0f 48 57 56 32 00 a4 77 56 49 56 32  .....HWV2..wVIV2
  a760: 0a 0c 00 14 0f 48 57 56 33 00 a4 77 56 49 56 33  .....HWV3..wVIV3
  a770: 0a 18 00 14 0f 48 57 56 34 00 a4 77 56 49 56 34  .....HWV4..wVIV4
  a780: 0a 0c 00 14 0f 48 57 56 35 00 a4 77 56 49 56 35  .....HWV5..wVIV5
  a790: 0a 0c 00 14 0f 48 57 56 36 00 a4 77 56 49 56 36  .....HWV6..wVIV6
  a7a0: 0a 0c 00 14 0f 48 57 56 37 00 a4 77 56 49 56 37  .....HWV7..wVIV7
  a7b0: 0a 0c 00 14 25 48 57 54 31 00 70 54 50 49 31 60  ....%HWT1.pTPI1`
  a7c0: a0 0b 94 60 0a 80 74 0b 00 01 60 60 72 60 54 31  ...`..t...``r`T1
  a7d0: 4f 46 60 a4 77 60 0a 0a 00 14 25 48 57 54 32 00  OF`.w`....%HWT2.
  a7e0: 70 54 50 49 32 60 a0 0b 94 60 0a 80 74 0b 00 01  pTPI2`...`..t...
  a7f0: 60 60 72 60 54 32 4f 46 60 a4 77 60 0a 0a 00 14  ``r`T2OF`.w`....
  a800: 25 48 57 54 33 00 70 54 50 49 33 60 a0 0b 94 60  %HWT3.pTPI3`...`
  a810: 0a 80 74 0b 00 01 60 60 72 60 54 33 4f 46 60 a4  ..t...``r`T3OF`.
  a820: 77 60 0a 0a 00 14 4a 09 48 57 46 31 00 a0 1b 93  w`....J.HWF1....
  a830: 45 54 44 31 01 7d 79 45 46 4e 31 0a 08 00 46 54  ETD1.}yEFN1...FT
  a840: 43 31 60 a4 43 46 31 36 60 70 46 54 43 31 60 70  C1`.CF16`pFTC1`p
  a850: 01 62 a2 4c 05 90 91 92 94 60 46 48 4d 54 92 95  .b.L.....`FHMT..
  a860: 60 46 4c 4d 54 93 62 01 a0 20 92 94 60 46 48 4d  `FLMT.b.. ..`FHM
  a870: 54 70 46 54 44 31 61 a0 0c 94 61 00 76 61 70 61  TpFTD1a...a.vapa
  a880: 46 54 44 31 a1 04 70 00 62 a1 1a 70 46 54 44 31  FTD1..p.b..pFTD1
  a890: 61 a0 0d 95 61 0a 07 75 61 70 61 46 54 44 31 a1  a...a..uapaFTD1.
  a8a0: 04 70 00 62 5b 22 0b 2c 01 70 46 54 43 31 60 a4  .p.b[".,.pFTC1`.
  a8b0: 43 46 30 38 60 83 88 44 54 42 31 46 54 44 31 00  CF08`..DTB1FTD1.
  a8c0: 14 4a 09 48 57 46 32 00 a0 1b 93 45 54 44 32 01  .J.HWF2....ETD2.
  a8d0: 7d 79 45 46 4e 32 0a 08 00 46 54 43 32 60 a4 43  }yEFN2...FTC2`.C
  a8e0: 46 31 36 60 70 46 54 43 32 60 70 01 62 a2 4c 05  F16`pFTC2`p.b.L.
  a8f0: 90 91 92 94 60 46 48 4d 54 92 95 60 46 4c 4d 54  ....`FHMT..`FLMT
  a900: 93 62 01 a0 20 92 94 60 46 48 4d 54 70 46 54 44  .b.. ..`FHMTpFTD
  a910: 32 61 a0 0c 94 61 00 76 61 70 61 46 54 44 32 a1  2a...a.vapaFTD2.
  a920: 04 70 00 62 a1 1a 70 46 54 44 32 61 a0 0d 95 61  .p.b..pFTD2a...a
  a930: 0a 07 75 61 70 61 46 54 44 32 a1 04 70 00 62 5b  ..uapaFTD2..p.b[
  a940: 22 0b 2c 01 70 46 54 43 32 60 a4 43 46 30 38 60  ".,.pFTC2`.CF08`
  a950: 83 88 44 54 42 31 46 54 44 32 00 14 4a 08 48 57  ..DTB1FTD2..J.HW
  a960: 46 33 00 a0 1b 93 45 54 44 33 01 7d 79 45 46 4e  F3....ETD3.}yEFN
  a970: 33 0a 08 00 46 54 43 33 60 a4 43 46 31 36 60 70  3...FTC3`.CF16`p
  a980: 46 54 43 33 60 a0 26 92 94 60 46 48 4d 33 70 46  FTC3`.&..`FHM3pF
  a990: 54 44 33 61 a0 17 94 61 00 76 61 70 61 46 54 44  TD3a...a.vapaFTD
  a9a0: 33 5b 22 0b 2c 01 70 46 54 43 33 60 a1 28 a0 26  3[".,.pFTC3`.(.&
  a9b0: 92 95 60 46 4c 4d 54 70 46 54 44 33 61 a0 17 95  ..`FLMTpFTD3a...
  a9c0: 61 01 75 61 70 61 46 54 44 33 5b 22 0b 2c 01 70  a.uapaFTD3[".,.p
  a9d0: 46 54 43 33 60 a4 43 46 30 38 60 83 88 44 54 42  FTC3`.CF08`..DTB
  a9e0: 31 46 54 44 33 00 14 1a 48 57 46 34 00 7d 79 45  1FTD3...HWF4.}yE
  a9f0: 46 4e 34 0a 08 00 46 54 43 34 60 a4 43 46 31 36  FN4...FTC4`.CF16
  aa00: 60 14 1a 48 57 46 35 00 7d 79 45 46 4e 35 0a 08  `..HWF5.}yEFN5..
  aa10: 00 46 54 43 35 60 a4 43 46 31 36 60 14 1f 43 46  .FTC5`.CF16`..CF
  aa20: 30 38 02 a0 0b 91 93 68 00 93 68 0a ff a4 00 78  08.....h..h....x
  aa30: 46 54 46 52 77 68 69 00 00 60 a4 60 14 21 43 46  FTFRwhi..`.`.!CF
  aa40: 31 36 01 a0 0c 91 93 68 00 93 68 0b ff ff a4 00  16.....h..h.....
  aa50: 78 46 54 46 52 77 68 0a 02 00 00 60 a4 60 08 46  xFTFRwh....`.`.F
  aa60: 54 46 52 0c 70 99 14 00 08 46 48 4d 54 0a 78 08  TFR.p....FHMT.x.
  aa70: 46 48 4d 33 0a 3c 08 46 4c 4d 54 0a fe 08 44 54  FHM3.<.FLMT...DT
  aa80: 42 31 12 11 08 01 0a 02 0a 04 0a 08 0a 10 0a 20  B1............. 
  aa90: 0a 40 0a 80 08 44 54 42 32 12 06 02 0a 02 0a 08  .@...DTB2.......
  aaa0: 5b 80 45 43 52 45 01 49 4f 45 42 0a 20 5b 81 12  [.ECRE.IOEB. [..
  aab0: 45 43 52 45 01 00 28 48 49 44 58 08 48 44 41 54  ECRE..(HIDX.HDAT
  aac0: 08 5b 86 43 0a 48 49 44 58 48 44 41 54 01 00 48  .[.C.HIDXHDAT..H
  aad0: 05 46 54 44 31 03 46 54 44 32 03 46 54 44 33 01  .FTD1.FTD2.FTD3.
  aae0: 00 01 45 54 44 31 01 45 54 44 32 01 45 54 44 33  ..ETD1.ETD2.ETD3
  aaf0: 01 00 05 46 54 43 31 08 46 54 43 32 08 46 54 43  ...FTC1.FTC2.FTC
  ab00: 33 08 00 40 04 45 46 4e 31 08 45 46 4e 32 08 45  3..@.EFN1.EFN2.E
  ab10: 46 4e 33 08 00 28 56 49 56 30 08 56 49 56 31 08  FN3..(VIV0.VIV1.
  ab20: 56 49 56 32 08 56 49 56 33 08 56 49 56 34 08 56  VIV2.VIV3.VIV4.V
  ab30: 49 56 35 08 56 49 56 36 08 56 49 56 37 08 00 08  IV5.VIV6.VIV7...
  ab40: 54 50 49 31 08 54 50 49 32 08 54 50 49 33 08 00  TPI1.TPI2.TPI3..
  ab50: 40 2a 46 54 43 34 08 45 46 4e 34 08 46 54 43 35  @*FTC4.EFN4.FTC5
  ab60: 08 45 46 4e 35 08 5b 80 53 42 48 4d 01 53 42 52  .EFN5.[.SBHM.SBR
  ab70: 56 0a 02 5b 81 10 53 42 48 4d 01 53 42 56 58 08  V..[..SBHM.SBVX.
  ab80: 53 42 56 54 08 5b 86 2e 53 42 56 58 53 42 56 54  SBVT.[..SBVXSBVT
  ab90: 01 00 48 34 53 42 46 30 10 00 18 53 42 46 31 10  ..H4SBF0...SBF1.
  aba0: 00 18 53 42 46 32 10 00 18 53 42 46 33 10 00 18  ..SBF2...SBF3...
  abb0: 53 42 46 34 10 10 22 5c 00 5b 81 1d 52 41 4d 57  SBF4.."\.[..RAMW
  abc0: 01 00 40 10 43 50 55 51 08 43 50 56 4c 10 43 50  ..@.CPUQ.CPVL.CP
  abd0: 56 48 10 43 50 56 43 01 10 43 50 2f 04 5f 53 42  VH.CPVC..CP/._SB
  abe0: 5f 50 43 49 30 53 42 52 47 41 53 4f 43 08 43 4f  _PCI0SBRGASOC.CO
  abf0: 52 56 12 1d 05 0c 00 00 02 06 0d 56 63 6f 72 65  RV.........Vcore
  ac00: 20 56 6f 6c 74 61 67 65 00 0b 52 03 0b 40 06 01   Voltage..R..@..
  ac10: 08 56 33 56 56 12 1d 05 0c 01 00 02 06 0d 20 2b  .V3VV......... +
  ac20: 33 2e 33 20 56 6f 6c 74 61 67 65 00 0b 9a 0b 0b  3.3 Voltage.....
  ac30: 2e 0e 01 08 56 35 56 56 12 1b 05 0c 02 00 02 06  ....V5VV........
  ac40: 0d 20 2b 35 20 56 6f 6c 74 61 67 65 00 0b 94 11  . +5 Voltage....
  ac50: 0b 7c 15 01 08 56 56 31 32 12 1c 05 0c 03 00 02  .|...VV12.......
  ac60: 06 0d 20 2b 31 32 20 56 6f 6c 74 61 67 65 00 0b  .. +12 Voltage..
  ac70: d8 27 0b e8 35 01 08 56 50 41 52 12 22 04 12 05  .'..5..VPAR."...
  ac80: 03 00 01 00 12 08 03 0a f9 0b e8 03 00 12 07 03  ................
  ac90: 0a 4b 0a 64 00 12 08 03 0b 3c 01 0a 64 00 08 56  .K.d.....<..d..V
  aca0: 42 55 46 12 14 05 0a 04 43 4f 52 56 56 33 56 56  BUF.....CORVV3VV
  acb0: 56 35 56 56 56 56 31 32 14 4d 04 56 47 45 54 01  V5VVVV12.M.VGET.
  acc0: a0 10 93 68 00 a4 5e 5e 2e 53 49 4f 52 48 57 56  ...h..^^.SIORHWV
  acd0: 32 a0 10 93 68 01 a4 5e 5e 2e 53 49 4f 52 48 57  2...h..^^.SIORHW
  ace0: 56 35 a0 11 93 68 0a 02 a4 5e 5e 2e 53 49 4f 52  V5...h...^^.SIOR
  acf0: 48 57 56 31 a0 11 93 68 0a 03 a4 5e 5e 2e 53 49  HWV1...h...^^.SI
  ad00: 4f 52 48 57 56 30 08 43 50 55 54 12 23 05 0c 00  ORHWV0.CPUT.#...
  ad10: 00 03 06 0d 43 50 55 20 54 65 6d 70 65 72 61 74  ....CPU Temperat
  ad20: 75 72 65 00 0b 58 02 0b b6 03 0c 01 00 01 00 08  ure..X..........
  ad30: 4d 42 54 50 12 22 05 0c 01 00 03 06 0d 4d 42 20  MBTP.".......MB 
  ad40: 54 65 6d 70 65 72 61 74 75 72 65 00 0b c2 01 0b  Temperature.....
  ad50: ee 02 0c 01 00 01 00 08 54 42 55 46 12 0c 03 0a  ........TBUF....
  ad60: 02 43 50 55 54 4d 42 54 50 14 28 54 47 45 54 01  .CPUTMBTP.(TGET.
  ad70: a0 10 93 68 00 a4 5e 5e 2e 53 49 4f 52 48 57 54  ...h..^^.SIORHWT
  ad80: 31 a0 10 93 68 01 a4 5e 5e 2e 53 49 4f 52 48 57  1...h..^^.SIORHW
  ad90: 54 32 08 43 50 55 46 12 21 05 0c 00 00 04 06 0d  T2.CPUF.!.......
  ada0: 43 50 55 20 46 41 4e 20 53 70 65 65 64 00 0b 58  CPU FAN Speed..X
  adb0: 02 0b 20 1c 0c 01 00 01 00 08 43 48 41 46 12 25  .. .......CHAF.%
  adc0: 05 0c 01 00 04 06 0d 43 48 41 53 53 49 53 20 46  .......CHASSIS F
  add0: 41 4e 20 53 70 65 65 64 00 0b 58 02 0b 20 1c 0c  AN Speed..X.. ..
  ade0: 01 00 01 00 08 46 42 55 46 12 0c 03 0a 02 43 50  .....FBUF.....CP
  adf0: 55 46 43 48 41 46 14 28 46 47 45 54 01 a0 10 93  UFCHAF.(FGET....
  ae00: 68 00 a4 5e 5e 2e 53 49 4f 52 48 57 46 31 a0 10  h..^^.SIORHWF1..
  ae10: 93 68 01 a4 5e 5e 2e 53 49 4f 52 48 57 46 32 08  .h..^^.SIORHWF2.
  ae20: 51 43 46 4e 12 23 06 0c 03 00 06 04 0d 43 50 55  QCFN.#.......CPU
  ae30: 20 51 2d 46 61 6e 20 43 6f 6e 74 72 6f 6c 00 00   Q-Fan Control..
  ae40: 01 0a 02 0c 00 00 01 00 08 51 42 55 46 12 07 02  .........QBUF...
  ae50: 01 51 43 46 4e 14 0b 56 53 49 46 00 a4 56 42 55  .QCFN..VSIF..VBU
  ae60: 46 14 41 05 52 56 4c 54 01 7b 68 0b ff ff 60 70  F.A.RVLT.{h...`p
  ae70: 56 47 45 54 60 61 70 83 88 83 88 56 50 41 52 60  VGET`ap....VPAR`
  ae80: 00 00 00 62 70 83 88 83 88 56 50 41 52 60 00 01  ...bp....VPAR`..
  ae90: 00 63 70 83 88 83 88 56 50 41 52 60 00 0a 02 00  .cp....VPAR`....
  aea0: 64 77 61 72 62 63 00 65 78 65 63 00 65 72 65 64  dwarbc.exec.ered
  aeb0: 65 a4 65 14 41 07 53 56 4c 54 01 7b 83 88 68 00  e.e.A.SVLT.{..h.
  aec0: 00 0b ff ff 60 70 83 88 56 42 55 46 00 00 61 a0  ....`p..VBUF..a.
  aed0: 07 92 95 60 61 a4 00 75 60 70 83 88 68 01 00 88  ...`a..u`p..h...
  aee0: 83 88 56 42 55 46 60 00 01 00 70 83 88 68 0a 02  ..VBUF`...p..h..
  aef0: 00 88 83 88 56 42 55 46 60 00 0a 02 00 70 83 88  ....VBUF`....p..
  af00: 68 0a 03 00 88 83 88 56 42 55 46 60 00 0a 03 00  h......VBUF`....
  af10: 70 83 88 68 0a 04 00 88 83 88 56 42 55 46 60 00  p..h......VBUF`.
  af20: 0a 04 00 a4 01 14 0b 54 53 49 46 00 a4 54 42 55  .......TSIF..TBU
  af30: 46 14 15 52 54 4d 50 01 7b 68 0b ff ff 60 70 54  F..RTMP.{h...`pT
  af40: 47 45 54 60 61 a4 61 14 43 07 53 54 4d 50 01 70  GET`a.a.C.STMP.p
  af50: 7b 83 88 68 00 00 0b ff ff 00 60 70 83 88 54 42  {..h......`p..TB
  af60: 55 46 00 00 61 a0 07 92 95 60 61 a4 00 75 60 70  UF..a....`a..u`p
  af70: 83 88 68 01 00 88 83 88 54 42 55 46 60 00 01 00  ..h.....TBUF`...
  af80: 70 83 88 68 0a 02 00 88 83 88 54 42 55 46 60 00  p..h......TBUF`.
  af90: 0a 02 00 70 83 88 68 0a 03 00 88 83 88 54 42 55  ...p..h......TBU
  afa0: 46 60 00 0a 03 00 70 83 88 68 0a 04 00 88 83 88  F`....p..h......
  afb0: 54 42 55 46 60 00 0a 04 00 a4 01 14 0b 46 53 49  TBUF`........FSI
  afc0: 46 00 a4 46 42 55 46 14 15 52 46 41 4e 01 7b 68  F..FBUF..RFAN.{h
  afd0: 0b ff ff 60 70 46 47 45 54 60 61 a4 61 14 41 07  ...`pFGET`a.a.A.
  afe0: 53 46 41 4e 01 7b 83 88 68 00 00 0b ff ff 60 70  SFAN.{..h.....`p
  aff0: 83 88 46 42 55 46 00 00 61 a0 07 92 95 60 61 a4  ..FBUF..a....`a.
  b000: 00 75 60 70 83 88 68 01 00 88 83 88 46 42 55 46  .u`p..h.....FBUF
  b010: 60 00 01 00 70 83 88 68 0a 02 00 88 83 88 46 42  `...p..h......FB
  b020: 55 46 60 00 0a 02 00 70 83 88 68 0a 03 00 88 83  UF`....p..h.....
  b030: 88 46 42 55 46 60 00 0a 03 00 70 83 88 68 0a 04  .FBUF`....p..h..
  b040: 00 88 83 88 46 42 55 46 60 00 0a 04 00 a4 01 14  ....FBUF`.......
  b050: 4a 04 51 46 49 46 00 a0 21 93 43 50 55 51 00 7b  J.QFIF..!.CPUQ.{
  b060: 83 88 51 43 46 4e 0a 05 00 0c ff ff fd ff 60 70  ..QCFN........`p
  b070: 60 88 51 43 46 4e 0a 05 00 a1 1b 7d 83 88 51 43  `.QCFN.....}..QC
  b080: 46 4e 0a 05 00 0c 00 00 02 00 60 70 60 88 51 43  FN........`p`.QC
  b090: 46 4e 0a 05 00 a4 51 42 55 46 14 27 47 43 51 56  FN....QBUF.'GCQV
  b0a0: 01 a0 09 93 68 00 a4 43 50 56 4c a0 09 93 68 01  ....h..CPVL...h.
  b0b0: a4 43 50 56 48 a0 0a 93 68 0a 02 a4 43 50 56 43  .CPVH...h...CPVC
  b0c0: a4 00 14 19 51 46 53 54 01 a0 10 93 68 83 88 51  ....QFST....h..Q
  b0d0: 43 46 4e 00 00 a4 43 51 53 54 a4 00 10 22 2f 03  CFN...CQST..."/.
  b0e0: 5f 53 42 5f 50 43 49 30 53 42 52 47 14 12 53 49  _SB_PCI0SBRG..SI
  b0f0: 41 53 01 a0 0b 93 68 0a 03 70 01 47 31 37 33 10  AS....h..p.G173.
  b100: 45 19 5f 53 42 5f 10 4e 18 50 43 49 30 08 43 52  E._SB_.N.PCI0.CR
  b110: 53 5f 11 46 0a 0a a2 88 0d 00 02 0c 00 00 00 00  S_.F............
  b120: 00 ff 00 00 00 00 01 47 01 f8 0c f8 0c 01 08 88  .......G........
  b130: 0d 00 01 0c 03 00 00 00 00 f7 0c 00 00 f8 0c 88  ................
  b140: 0d 00 01 0c 03 00 00 00 0d ff ff 00 00 00 f3 87  ................
  b150: 17 00 00 0c 03 00 00 00 00 00 00 0a 00 ff ff 0b  ................
  b160: 00 00 00 00 00 00 00 02 00 87 17 00 00 0c 03 00  ................
  b170: 00 00 00 00 00 0c 00 ff ff 0d 00 00 00 00 00 00  ................
  b180: 00 02 00 87 17 00 00 0c 03 00 00 00 00 00 00 00  ................
  b190: 00 00 00 00 00 00 00 00 00 00 00 00 00 87 17 00  ................
  b1a0: 00 0c 03 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  b1b0: 00 00 00 00 00 00 00 79 00 8a 43 52 53 5f 0a 5c  .......y..CRS_.\
  b1c0: 4d 49 4e 35 8a 43 52 53 5f 0a 60 4d 41 58 35 8a  MIN5.CRS_.`MAX5.
  b1d0: 43 52 53 5f 0a 68 4c 45 4e 35 8a 43 52 53 5f 0a  CRS_.hLEN5.CRS_.
  b1e0: 76 4d 49 4e 36 8a 43 52 53 5f 0a 7a 4d 41 58 36  vMIN6.CRS_.zMAX6
  b1f0: 8a 43 52 53 5f 0a 82 4c 45 4e 36 8a 43 52 53 5f  .CRS_..LEN6.CRS_
  b200: 0a 90 4d 49 4e 37 8a 43 52 53 5f 0a 94 4d 41 58  ..MIN7.CRS_..MAX
  b210: 37 8a 43 52 53 5f 0a 9c 4c 45 4e 37 14 48 07 5f  7.CRS_..LEN7.H._
  b220: 43 52 53 00 70 4d 47 31 4c 60 a0 1f 60 70 4d 47  CRS.pMG1L`..`pMG
  b230: 31 42 4d 49 4e 35 70 4d 47 31 4c 4c 45 4e 35 72  1BMIN5pMG1LLEN5r
  b240: 4d 49 4e 35 76 60 4d 41 58 35 70 4d 47 32 42 4d  MIN5v`MAX5pMG2BM
  b250: 49 4e 36 70 4d 47 32 4c 4c 45 4e 36 70 4d 47 32  IN6pMG2LLEN6pMG2
  b260: 4c 60 72 4d 49 4e 36 76 60 4d 41 58 36 70 4d 47  L`rMIN6v`MAX6pMG
  b270: 33 42 4d 49 4e 37 70 4d 47 33 4c 4c 45 4e 37 70  3BMIN7pMG3LLEN7p
  b280: 4d 47 33 4c 60 72 4d 49 4e 37 76 60 4d 41 58 37  MG3L`rMIN7v`MAX7
  b290: a4 43 52 53 5f 08 57 4f 54 42 00 08 57 53 53 42  .CRS_.WOTB..WSSB
  b2a0: 00 08 57 41 58 42 00 14 40 07 5f 50 54 53 01 70  ..WAXB..@._PTS.p
  b2b0: 68 44 42 47 38 50 54 53 5f 68 70 00 88 57 41 4b  hDBG8PTS_hp..WAK
  b2c0: 50 00 00 70 00 88 57 41 4b 50 01 00 a0 12 90 93  P..p..WAKP......
  b2d0: 68 0a 04 93 4f 53 46 4c 0a 02 5b 22 0b b8 0b 70  h...OSFL..["...p
  b2e0: 41 53 53 42 57 53 53 42 70 41 4f 54 42 57 4f 54  ASSBWSSBpAOTBWOT
  b2f0: 42 70 41 41 58 42 57 41 58 42 70 68 41 53 53 42  BpAAXBWAXBphASSB
  b300: 70 4f 53 46 4c 41 4f 54 42 70 4f 53 59 53 4f 53  pOSFLAOTBpOSYSOS
  b310: 54 50 70 00 41 41 58 42 14 4d 06 5f 57 41 4b 01  TPp.AAXB.M._WAK.
  b320: 79 68 0a 04 44 42 47 38 57 41 4b 5f 68 a0 05 49  yh..DBG8WAK_h..I
  b330: 4f 57 4b a1 0e 86 5c 2e 5f 53 42 5f 50 57 52 42  OWK...\._SB_PWRB
  b340: 0a 02 a0 20 41 53 53 42 70 57 53 53 42 41 53 53  ... ASSBpWSSBASS
  b350: 42 70 57 4f 54 42 41 4f 54 42 70 57 41 58 42 41  BpWOTBAOTBpWAXBA
  b360: 41 58 42 a0 12 83 88 57 41 4b 50 00 00 70 00 88  AXB....WAKP..p..
  b370: 57 41 4b 50 01 00 a1 0a 70 68 88 57 41 4b 50 01  WAKP....ph.WAKP.
  b380: 00 a4 57 41 4b 50 5b 80 49 4f 52 4b 01 0a b1 01  ..WAKP[.IORK....
  b390: 5b 81 0b 49 4f 52 4b 01 49 4f 57 4b 08 a0 41 10  [..IORK.IOWK..A.
  b3a0: 4f 53 43 46 10 4a 0f 2e 5f 53 42 5f 50 43 49 30  OSCF.J.._SB_PCI0
  b3b0: 14 4e 0e 5f 4f 53 43 04 08 53 55 50 50 00 08 43  .N._OSC..SUPP..C
  b3c0: 54 52 4c 00 a0 4b 0c 93 68 11 13 0a 10 5b 4d db  TRL..K..h....[M.
  b3d0: 33 f7 1f 1c 40 96 57 74 41 c0 3d d7 66 8a 6b 00  3...@.WtA.=.f.k.
  b3e0: 43 44 57 31 8a 6b 0a 04 43 44 57 32 8a 6b 0a 08  CDW1.k..CDW2.k..
  b3f0: 43 44 57 33 70 43 44 57 32 53 55 50 50 70 43 44  CDW3pCDW2SUPPpCD
  b400: 57 33 43 54 52 4c a0 15 92 93 7b 53 55 50 50 0a  W3CTRL....{SUPP.
  b410: 16 00 0a 16 7b 43 54 52 4c 0a 1e 00 7b 43 54 52  ....{CTRL...{CTR
  b420: 4c 0a 1d 43 54 52 4c a0 35 80 7b 43 44 57 31 01  L..CTRL.5.{CDW1.
  b430: 00 00 a0 08 7b 43 54 52 4c 01 00 a0 0f 7b 43 54  ....{CTRL....{CT
  b440: 52 4c 0a 04 00 70 01 45 50 4e 4d a1 07 70 00 45  RL...p.EPNM..p.E
  b450: 50 4e 4d a0 09 7b 43 54 52 4c 0a 10 00 a0 10 92  PNM..{CTRL......
  b460: 93 69 01 7d 43 44 57 31 0a 08 43 44 57 31 a0 16  .i.}CDW1..CDW1..
  b470: 92 93 43 44 57 33 43 54 52 4c 7d 43 44 57 31 0a  ..CDW3CTRL}CDW1.
  b480: 10 43 44 57 31 70 43 54 52 4c 43 44 57 33 a4 6b  .CDW1pCTRLCDW3.k
  b490: a1 0e 7d 43 44 57 31 0a 04 43 44 57 31 a4 6b 10  ..}CDW1..CDW1.k.
  b4a0: 1b 2e 5f 53 42 5f 50 43 49 30 14 10 5f 49 4e 49  .._SB_PCI0.._INI
  b4b0: 00 a0 09 92 94 52 56 49 44 0a 13 10 82 dc 02 5c  .....RVID......\
  b4c0: 00 5b 80 49 4f 4f 52 01 53 49 4f 50 0a 02 5b 81  .[.IOOR.SIOP..[.
  b4d0: 10 49 4f 4f 52 01 49 4f 49 44 08 49 4f 44 54 08  .IOOR.IOID.IODT.
  b4e0: 5b 80 47 42 4f 52 01 47 49 4f 42 0a 08 5b 81 49  [.GBOR.GIOB..[.I
  b4f0: 05 47 42 4f 52 01 00 30 47 50 37 30 01 47 50 37  .GBOR..0GP70.GP7
  b500: 31 01 47 50 37 32 01 47 50 37 33 01 47 50 37 34  1.GP72.GP73.GP74
  b510: 01 47 50 37 35 01 47 50 37 36 01 47 50 37 37 01  .GP75.GP76.GP77.
  b520: 47 50 38 30 01 47 50 38 31 01 47 50 38 32 01 47  GP80.GP81.GP82.G
  b530: 50 38 33 01 47 50 38 34 01 47 50 38 35 01 47 50  P83.GP84.GP85.GP
  b540: 38 36 01 47 50 38 37 01 14 11 52 53 49 4f 01 70  86.GP87...RSIO.p
  b550: 68 49 4f 49 44 a4 49 4f 44 54 14 12 57 53 49 4f  hIOID.IODT..WSIO
  b560: 02 70 68 49 4f 49 44 70 69 49 4f 44 54 14 16 52  .phIOIDpiIODT..R
  b570: 57 49 4f 03 57 53 49 4f 68 7d 7b 52 53 49 4f 68  WIO.WSIOh}{RSIOh
  b580: 69 00 6a 00 08 49 50 53 57 12 16 02 12 09 04 0a  i.j..IPSW.......
  b590: 87 01 0a 55 0a 55 12 09 04 0a 87 01 0a 55 0a aa  ...U.U.......U..
  b5a0: 14 46 04 53 4c 44 4e 01 70 00 61 a0 0b 93 53 49  .F.SLDN.p.a...SI
  b5b0: 4f 50 0a 2e 70 00 61 a0 0b 93 53 49 4f 50 0a 4e  OP..p.a...SIOP.N
  b5c0: 70 01 61 70 00 60 a2 19 92 93 60 0a 04 70 83 88  p.ap.`....`..p..
  b5d0: 83 88 49 50 53 57 61 00 60 00 49 4f 49 44 75 60  ..IPSWa.`.IOIDu`
  b5e0: 57 53 49 4f 0a 07 68 14 11 41 50 54 53 01 5c 2e  WSIO..h..APTS.\.
  b5f0: 41 4f 44 5f 41 50 54 53 68 14 11 41 57 41 4b 01  AOD_APTSh..AWAK.
  b600: 5c 2e 41 4f 44 5f 41 57 41 4b 68 5b 82 81 c7 02  \.AOD_AWAKh[....
  b610: 41 4f 44 5f 08 44 42 47 5f 00 08 47 44 42 47 01  AOD_.DBG_..GDBG.
  b620: 08 43 44 42 47 00 08 56 44 42 47 00 08 52 44 42  .CDBG..VDBG..RDB
  b630: 47 00 08 4f 42 49 44 12 40 09 1c 0a 09 0c 00 00  G..OBID.@.......
  b640: 01 01 0c 00 00 02 01 0c 00 00 01 02 0c 00 00 02  ................
  b650: 02 0c 00 00 03 02 0c 00 00 04 02 0c 00 00 05 02  ................
  b660: 00 00 01 01 01 01 01 01 00 00 0a ff 0d 43 50 55  .............CPU
  b670: 20 43 6c 6f 63 6b 00 0d 50 43 49 45 20 43 6c 6f   Clock..PCIE Clo
  b680: 63 6b 00 0d 44 52 41 4d 20 56 6f 6c 74 61 67 65  ck..DRAM Voltage
  b690: 00 0d 56 44 44 41 20 56 6f 6c 74 61 67 65 00 0d  ..VDDA Voltage..
  b6a0: 48 54 20 56 6f 6c 74 61 67 65 00 0d 47 50 55 20  HT Voltage..GPU 
  b6b0: 56 6f 6c 74 61 67 65 00 0d 53 42 20 56 6f 6c 74  Voltage..SB Volt
  b6c0: 61 67 65 00 0d 00 0d 00 08 4f 42 49 54 12 44 0a  age......OBIT.D.
  b6d0: 31 0c 00 00 01 01 0c a0 86 01 00 0c c0 27 09 00  1............'..
  b6e0: 00 0b e8 03 00 0c 00 00 02 01 0c a0 86 01 00 0c  ................
  b6f0: 40 0d 03 00 00 0b e8 03 00 0c 00 00 01 02 0c c0  @...............
  b700: d4 01 00 0c 14 bb 03 00 00 0b dc 05 00 0c 00 00  ................
  b710: 02 02 0c 90 d0 03 00 0c c0 45 04 00 00 0b 10 27  .........E.....'
  b720: 00 0c 00 00 03 02 0c c0 d4 01 00 0c e0 22 02 00  ............."..
  b730: 00 0b e8 03 00 0c 00 00 04 02 0c b0 ad 01 00 0c  ................
  b740: c8 a3 02 00 00 0b 10 27 00 0c 00 00 05 02 0c b0  .......'........
  b750: ad 01 00 0c e0 22 02 00 00 0b 10 27 00 0c 00 00  .....".....'....
  b760: 06 02 0c f0 49 02 00 0c 20 bf 02 00 00 0b 10 27  ....I... ......'
  b770: 00 00 08 4f 42 44 54 12 03 01 00 14 0a 42 4d 30  ...OBDT......BM0
  b780: 31 00 50 57 4d 49 14 06 58 49 4e 49 00 14 06 45  1.PWMI..XINI...E
  b790: 4d 30 31 00 14 06 42 4d 30 35 01 14 06 45 4d 30  M01...BM05...EM0
  b7a0: 35 01 14 06 48 4d 30 36 00 14 06 48 4d 30 37 01  5...HM06...HM07.
  b7b0: 14 06 44 49 53 43 00 14 06 43 4e 43 54 00 08 50  ..DISC...CNCT..P
  b7c0: 57 4d 54 11 34 0a 31 01 01 01 00 ff 30 01 63 02  WMT.4.1.....0.c.
  b7d0: 02 01 00 05 00 01 05 03 03 01 00 15 00 01 15 04  ................
  b7e0: 04 01 00 29 00 01 29 05 05 01 00 05 00 01 05 07  ...)..).........
  b7f0: 07 01 00 ff 00 01 63 ff 14 4f 0c 50 57 4d 49 00  ......c..O.PWMI.
  b800: 70 83 88 5c 2f 05 5f 53 42 5f 50 43 49 30 53 42  p..\/._SB_PCI0SB
  b810: 52 47 41 53 4f 43 47 33 44 32 0a 03 00 60 70 60  RGASOCG3D2...`p`
  b820: 88 50 57 4d 54 0a 05 00 70 83 88 5c 2f 05 5f 53  .PWMT...p..\/._S
  b830: 42 5f 50 43 49 30 53 42 52 47 41 53 4f 43 47 33  B_PCI0SBRGASOCG3
  b840: 35 33 0a 03 00 60 70 60 88 50 57 4d 54 0a 0d 00  53...`p`.PWMT...
  b850: 70 83 88 5c 2f 05 5f 53 42 5f 50 43 49 30 53 42  p..\/._SB_PCI0SB
  b860: 52 47 41 53 4f 43 47 33 35 34 0a 03 00 60 70 60  RGASOCG354...`p`
  b870: 88 50 57 4d 54 0a 15 00 70 83 88 5c 2f 05 5f 53  .PWMT...p..\/._S
  b880: 42 5f 50 43 49 30 53 42 52 47 41 53 4f 43 47 33  B_PCI0SBRGASOCG3
  b890: 36 31 0a 03 00 60 70 60 88 50 57 4d 54 0a 1d 00  61...`p`.PWMT...
  b8a0: 70 83 88 5c 2f 05 5f 53 42 5f 50 43 49 30 53 42  p..\/._SB_PCI0SB
  b8b0: 52 47 41 53 4f 43 47 33 35 36 0a 03 00 60 70 60  RGASOCG356...`p`
  b8c0: 88 50 57 4d 54 0a 25 00 14 4f 14 56 54 52 5f 01  .PWMT.%..O.VTR_.
  b8d0: 70 00 60 70 68 61 a0 3c 93 50 57 4d 58 01 70 72  p.`pha.<.PWMX.pr
  b8e0: 78 74 61 0c c0 d4 01 00 00 0b dc 05 00 00 50 4d  xta...........PM
  b8f0: 49 4e 00 60 5c 2f 05 5f 53 42 5f 50 43 49 30 53  IN.`\/._SB_PCI0S
  b900: 42 52 47 41 53 4f 43 53 49 54 33 0c 32 00 02 03  BRGASOCSIT3.2...
  b910: 60 0a 02 a1 42 10 a0 3d 93 50 57 4d 58 0a 02 70  `...B..=.PWMX..p
  b920: 72 78 74 61 0c 90 d0 03 00 00 0b 10 27 00 00 50  rxta........'..P
  b930: 4d 49 4e 00 60 5c 2f 05 5f 53 42 5f 50 43 49 30  MIN.`\/._SB_PCI0
  b940: 53 42 52 47 41 53 4f 43 53 49 54 33 0c 53 00 02  SBRGASOCSIT3.S..
  b950: 03 60 0a 02 a1 41 0c a0 3d 93 50 57 4d 58 0a 03  .`...A..=.PWMX..
  b960: 70 72 78 74 61 0c c0 d4 01 00 00 0b e8 03 00 00  prxta...........
  b970: 50 4d 49 4e 00 60 5c 2f 05 5f 53 42 5f 50 43 49  PMIN.`\/._SB_PCI
  b980: 30 53 42 52 47 41 53 4f 43 53 49 54 33 0c 54 00  0SBRGASOCSIT3.T.
  b990: 02 03 60 0a 02 a1 40 08 a0 3d 93 50 57 4d 58 0a  ..`...@..=.PWMX.
  b9a0: 04 70 72 78 74 61 0c b0 ad 01 00 00 0b e8 03 00  .prxta..........
  b9b0: 00 50 4d 49 4e 00 60 5c 2f 05 5f 53 42 5f 50 43  .PMIN.`\/._SB_PC
  b9c0: 49 30 53 42 52 47 41 53 4f 43 53 49 54 33 0c 61  I0SBRGASOCSIT3.a
  b9d0: 00 02 03 60 0a 02 a1 3f a0 3d 93 50 57 4d 58 0a  ...`...?.=.PWMX.
  b9e0: 05 70 72 78 74 61 0c b0 ad 01 00 00 0b 10 27 00  .prxta........'.
  b9f0: 00 50 4d 49 4e 00 60 5c 2f 05 5f 53 42 5f 50 43  .PMIN.`\/._SB_PC
  ba00: 49 30 53 42 52 47 41 53 4f 43 53 49 54 33 0c 56  I0SBRGASOCSIT3.V
  ba10: 00 02 03 60 0a 02 a4 60 14 40 1c 52 54 56 5f 01  ...`...`.@.RTV_.
  ba20: 70 68 60 70 00 61 a0 42 05 93 50 57 4d 58 01 5c  ph`p.a.B..PWMX.\
  ba30: 2f 05 5f 53 42 5f 50 43 49 30 53 42 52 47 41 53  /._SB_PCI0SBRGAS
  ba40: 4f 43 47 49 54 33 0c 32 00 02 03 70 5c 2f 05 5f  OCGIT3.2...p\/._
  ba50: 53 42 5f 50 43 49 30 53 42 52 47 41 53 4f 43 41  SB_PCI0SBRGASOCA
  ba60: 53 42 31 60 70 72 0c c0 d4 01 00 77 74 60 50 4d  SB1`pr.....wt`PM
  ba70: 49 4e 00 0b dc 05 00 00 61 a1 4d 15 a0 43 05 93  IN......a.M..C..
  ba80: 50 57 4d 58 0a 02 5c 2f 05 5f 53 42 5f 50 43 49  PWMX..\/._SB_PCI
  ba90: 30 53 42 52 47 41 53 4f 43 47 49 54 33 0c 53 00  0SBRGASOCGIT3.S.
  baa0: 02 03 70 5c 2f 05 5f 53 42 5f 50 43 49 30 53 42  ..p\/._SB_PCI0SB
  bab0: 52 47 41 53 4f 43 41 53 42 31 60 70 72 0c 90 d0  RGASOCASB1`pr...
  bac0: 03 00 77 74 60 50 4d 49 4e 00 0b 10 27 00 00 61  ..wt`PMIN...'..a
  bad0: a1 46 10 a0 43 05 93 50 57 4d 58 0a 03 5c 2f 05  .F..C..PWMX..\/.
  bae0: 5f 53 42 5f 50 43 49 30 53 42 52 47 41 53 4f 43  _SB_PCI0SBRGASOC
  baf0: 47 49 54 33 0c 54 00 02 03 70 5c 2f 05 5f 53 42  GIT3.T...p\/._SB
  bb00: 5f 50 43 49 30 53 42 52 47 41 53 4f 43 41 53 42  _PCI0SBRGASOCASB
  bb10: 31 60 70 72 0c c0 d4 01 00 77 74 60 50 4d 49 4e  1`pr.....wt`PMIN
  bb20: 00 0b e8 03 00 00 61 a1 4f 0a a0 43 05 93 50 57  ......a.O..C..PW
  bb30: 4d 58 0a 04 5c 2f 05 5f 53 42 5f 50 43 49 30 53  MX..\/._SB_PCI0S
  bb40: 42 52 47 41 53 4f 43 47 49 54 33 0c 61 00 02 03  BRGASOCGIT3.a...
  bb50: 70 5c 2f 05 5f 53 42 5f 50 43 49 30 53 42 52 47  p\/._SB_PCI0SBRG
  bb60: 41 53 4f 43 41 53 42 31 60 70 72 0c b0 ad 01 00  ASOCASB1`pr.....
  bb70: 77 74 60 50 4d 49 4e 00 0b e8 03 00 00 61 a1 48  wt`PMIN......a.H
  bb80: 05 a0 43 05 93 50 57 4d 58 0a 05 5c 2f 05 5f 53  ..C..PWMX..\/._S
  bb90: 42 5f 50 43 49 30 53 42 52 47 41 53 4f 43 47 49  B_PCI0SBRGASOCGI
  bba0: 54 33 0c 56 00 02 03 70 5c 2f 05 5f 53 42 5f 50  T3.V...p\/._SB_P
  bbb0: 43 49 30 53 42 52 47 41 53 4f 43 41 53 42 31 60  CI0SBRGASOCASB1`
  bbc0: 70 72 0c b0 ad 01 00 77 74 60 50 4d 49 4e 00 0b  pr.....wt`PMIN..
  bbd0: 10 27 00 00 61 a1 01 a4 61 08 51 4c 53 54 12 43  .'..a...a.QLST.C
  bbe0: 32 08 0a 07 12 3c 05 0b 26 26 0d 4d 65 6d 6f 72  2....<..&&.Memor
  bbf0: 79 20 43 6c 6f 63 6b 20 4d 6f 64 65 00 00 0a 03  y Clock Mode....
  bc00: 12 20 03 11 08 0a 05 41 75 74 6f 00 11 09 0a 06  . .....Auto.....
  bc10: 4c 69 6d 69 74 00 11 0a 0a 07 4d 61 6e 75 61 6c  Limit.....Manual
  bc20: 00 12 47 06 06 0b a0 35 0d 4d 65 6d 63 6c 6f 63  ..G....5.Memcloc
  bc30: 6b 20 56 61 6c 75 65 00 01 11 08 0a 05 02 00 01  k Value.........
  bc40: 03 00 0a 08 12 44 04 08 11 07 0a 04 72 76 64 00  .....D......rvd.
  bc50: 11 07 0a 04 72 76 64 00 11 07 0a 04 72 76 64 00  ....rvd.....rvd.
  bc60: 11 07 0a 04 34 30 30 00 11 07 0a 04 35 33 33 00  ....400.....533.
  bc70: 11 07 0a 04 36 36 37 00 11 07 0a 04 38 30 30 00  ....667.....800.
  bc80: 11 08 0a 05 41 75 74 6f 00 12 3f 05 0b 2e 26 0d  ....Auto..?...&.
  bc90: 44 52 41 4d 20 54 69 6d 69 6e 67 20 4d 6f 64 65  DRAM Timing Mode
  bca0: 00 00 0a 04 12 24 04 11 08 0a 05 41 75 74 6f 00  .....$.....Auto.
  bcb0: 11 07 0a 04 72 76 64 00 11 07 0a 04 72 76 64 00  ....rvd.....rvd.
  bcc0: 11 08 0a 05 42 6f 74 68 00 12 4d 0c 07 0b 3c 45  ....Both..M...<E
  bcd0: 0d 44 43 54 30 20 43 41 53 20 4c 61 74 65 6e 63  .DCT0 CAS Latenc
  bce0: 79 20 28 43 4c 29 00 0a 02 11 08 0a 05 02 00 03  y (CL)..........
  bcf0: 03 00 11 08 0a 05 02 02 03 03 00 0a 10 12 49 09  ..............I.
  bd00: 10 11 08 0a 05 41 75 74 6f 00 11 07 0a 04 72 76  .....Auto.....rv
  bd10: 64 00 11 07 0a 04 72 76 64 00 11 09 0a 06 34 20  d.....rvd.....4 
  bd20: 43 4c 4b 00 11 09 0a 06 35 20 43 4c 4b 00 11 09  CLK.....5 CLK...
  bd30: 0a 06 36 20 43 4c 4b 00 11 09 0a 06 37 20 43 4c  ..6 CLK.....7 CL
  bd40: 4b 00 11 09 0a 06 38 20 43 4c 4b 00 11 09 0a 06  K.....8 CLK.....
  bd50: 39 20 43 4c 4b 00 11 0a 0a 07 31 30 20 43 4c 4b  9 CLK.....10 CLK
  bd60: 00 11 0a 0a 07 31 31 20 43 4c 4b 00 11 0a 0a 07  .....11 CLK.....
  bd70: 31 32 20 43 4c 4b 00 11 07 0a 04 72 76 64 00 11  12 CLK.....rvd..
  bd80: 07 0a 04 72 76 64 00 11 07 0a 04 72 76 64 00 11  ...rvd.....rvd..
  bd90: 07 0a 04 72 76 64 00 12 2f 05 0b 5c 45 0d 4e 42  ...rvd../..\E.NB
  bda0: 20 46 49 44 20 43 6f 6e 74 72 6f 6c 00 00 0a 02   FID Control....
  bdb0: 12 16 02 11 0a 0a 07 4d 61 6e 75 61 6c 00 11 08  .......Manual...
  bdc0: 0a 05 41 75 74 6f 00 12 40 10 06 0b f0 53 0d 4e  ..Auto..@....S.N
  bdd0: 42 46 49 44 20 49 44 00 01 11 08 0a 05 02 01 06  BFID ID.........
  bde0: 03 00 0a 21 12 43 0e 21 11 05 0a 02 33 00 11 05  ...!.C.!....3...
  bdf0: 0a 02 34 00 11 05 0a 02 35 00 11 05 0a 02 36 00  ..4.....5.....6.
  be00: 11 05 0a 02 37 00 11 05 0a 02 38 00 11 05 0a 02  ....7.....8.....
  be10: 39 00 11 06 0a 03 31 30 00 11 06 0a 03 31 31 00  9.....10.....11.
  be20: 11 06 0a 03 31 32 00 11 06 0a 03 31 33 00 11 06  ....12.....13...
  be30: 0a 03 31 34 00 11 06 0a 03 31 35 00 11 06 0a 03  ..14.....15.....
  be40: 31 36 00 11 06 0a 03 31 37 00 11 06 0a 03 31 38  16.....17.....18
  be50: 00 11 06 0a 03 31 39 00 11 06 0a 03 32 30 00 11  .....19.....20..
  be60: 06 0a 03 32 31 00 11 06 0a 03 32 32 00 11 06 0a  ...21.....22....
  be70: 03 32 33 00 11 06 0a 03 32 34 00 11 06 0a 03 32  .23.....24.....2
  be80: 35 00 11 06 0a 03 32 36 00 11 06 0a 03 32 37 00  5.....26.....27.
  be90: 11 06 0a 03 32 38 00 11 06 0a 03 32 39 00 11 06  ....28.....29...
  bea0: 0a 03 33 30 00 11 06 0a 03 33 31 00 11 06 0a 03  ..30.....31.....
  beb0: 33 32 00 11 06 0a 03 33 33 00 11 06 0a 03 33 34  32.....33.....34
  bec0: 00 11 06 0a 03 33 35 00 12 39 05 0b 8f 17 0d 44  .....35..9.....D
  bed0: 44 52 33 20 4d 65 6d 6f 72 79 20 50 72 6f 66 69  DR3 Memory Profi
  bee0: 6c 65 00 00 0a 02 12 1b 02 11 0c 0a 09 44 69 73  le...........Dis
  bef0: 61 62 6c 65 64 00 11 0b 0a 08 45 6e 61 62 6c 65  abled.....Enable
  bf00: 64 00 5b 80 41 4f 44 54 00 0c 99 f2 0e 00 0b 00  d.[.AODT........
  bf10: 01 5b 81 2e 41 4f 44 54 00 41 53 43 44 10 41 53  .[..AODT.ASCD.AS
  bf20: 54 53 20 00 10 41 53 42 46 40 3c 47 46 58 4f 01  TS ..ASBF@<GFXO.
  bf30: 47 4d 4f 44 02 00 1d 52 41 4d 42 20 52 41 4d 53  GMOD...RAMB RAMS
  bf40: 20 08 49 44 30 31 00 08 49 44 30 32 00 14 1f 53   .ID01..ID02...S
  bf50: 4f 49 44 01 7a 68 0a 18 49 44 30 31 7a 7b 68 0c  OID.zh..ID01z{h.
  bf60: 00 00 ff 00 00 0a 10 49 44 30 32 a4 00 14 40 0b  .......ID02...@.
  bf70: 57 52 4f 57 04 08 49 46 50 4b 12 08 06 00 00 00  WROW..IFPK......
  bf80: 00 00 00 8a 68 00 42 55 46 30 8a 68 0a 04 42 55  ....h.BUF0.h..BU
  bf90: 46 31 8a 68 0a 08 42 55 46 32 8a 68 0a 0c 42 55  F1.h..BUF2.h..BU
  bfa0: 46 33 8a 68 0a 10 42 55 46 34 8a 68 0a 14 42 55  F3.h..BUF4.h..BU
  bfb0: 46 35 70 42 55 46 30 88 49 46 50 4b 00 00 70 42  F5pBUF0.IFPK..pB
  bfc0: 55 46 31 88 49 46 50 4b 01 00 70 42 55 46 32 88  UF1.IFPK..pBUF2.
  bfd0: 49 46 50 4b 0a 02 00 70 42 55 46 33 88 49 46 50  IFPK...pBUF3.IFP
  bfe0: 4b 0a 03 00 70 42 55 46 34 88 49 46 50 4b 0a 04  K...pBUF4.IFPK..
  bff0: 00 70 42 55 46 35 88 49 46 50 4b 0a 05 00 70 6b  .pBUF5.IFPK...pk
  c000: 60 70 00 61 a2 19 60 70 83 88 49 46 50 4b 61 00  `p.a..`p..IFPKa.
  c010: 88 69 72 77 6a 6b 00 61 00 00 75 61 76 60 14 46  .irwjk.a..uav`.F
  c020: 0b 47 52 4f 57 04 08 49 46 50 4b 12 08 06 00 00  .GROW..IFPK.....
  c030: 00 00 00 00 70 6b 60 70 00 61 a2 19 60 70 83 88  ....pk`p.a..`p..
  c040: 68 72 77 6a 6b 00 61 00 00 88 49 46 50 4b 61 00  hrwjk.a...IFPKa.
  c050: 75 61 76 60 8a 69 00 42 55 46 30 8a 69 0a 04 42  uav`.i.BUF0.i..B
  c060: 55 46 31 8a 69 0a 08 42 55 46 32 8a 69 0a 0c 42  UF1.i..BUF2.i..B
  c070: 55 46 33 8a 69 0a 10 42 55 46 34 8a 69 0a 14 42  UF3.i..BUF4.i..B
  c080: 55 46 35 70 83 88 49 46 50 4b 00 00 42 55 46 30  UF5p..IFPK..BUF0
  c090: 70 83 88 49 46 50 4b 01 00 42 55 46 31 70 83 88  p..IFPK..BUF1p..
  c0a0: 49 46 50 4b 0a 02 00 42 55 46 32 70 83 88 49 46  IFPK...BUF2p..IF
  c0b0: 50 4b 0a 03 00 42 55 46 33 70 83 88 49 46 50 4b  PK...BUF3p..IFPK
  c0c0: 0a 04 00 42 55 46 34 70 83 88 49 46 50 4b 0a 05  ...BUF4p..IFPK..
  c0d0: 00 42 55 46 35 14 47 0c 43 50 54 42 02 08 4c 4f  .BUF5.G.CPTB..LO
  c0e0: 49 44 00 8a 69 00 42 55 46 30 8a 69 0a 04 42 55  ID..i.BUF0.i..BU
  c0f0: 46 31 8a 69 0a 08 42 55 46 32 8a 69 0a 0c 42 55  F1.i..BUF2.i..BU
  c100: 46 33 8a 69 0a 10 42 55 46 34 70 00 60 70 83 88  F3.i..BUF4p.`p..
  c110: 4f 42 49 54 60 00 4c 4f 49 44 a2 45 07 4c 4f 49  OBIT`.LOID.E.LOI
  c120: 44 a0 4c 05 93 4c 4f 49 44 68 70 83 88 4f 42 49  D.L..LOIDhp..OBI
  c130: 54 72 60 00 00 00 42 55 46 30 70 83 88 4f 42 49  Tr`...BUF0p..OBI
  c140: 54 72 60 01 00 00 42 55 46 31 70 83 88 4f 42 49  Tr`...BUF1p..OBI
  c150: 54 72 60 0a 02 00 00 42 55 46 32 70 83 88 4f 42  Tr`....BUF2p..OB
  c160: 49 54 72 60 0a 03 00 00 42 55 46 33 70 83 88 4f  ITr`....BUF3p..O
  c170: 42 49 54 72 60 0a 04 00 00 42 55 46 34 a5 72 60  BITr`....BUF4.r`
  c180: 0a 06 60 70 83 88 4f 42 49 54 60 00 4c 4f 49 44  ..`p..OBIT`.LOID
  c190: a0 0a 93 4c 4f 49 44 00 a4 0a ff a4 00 14 4d 0d  ...LOID.......M.
  c1a0: 43 42 54 50 01 08 4c 4f 49 44 00 8a 68 00 42 55  CBTP..LOID..h.BU
  c1b0: 46 30 8a 68 0a 04 42 55 46 31 8a 68 0a 08 42 55  F0.h..BUF1.h..BU
  c1c0: 46 32 8a 68 0a 0c 42 55 46 33 8a 68 0a 10 42 55  F2.h..BUF3.h..BU
  c1d0: 46 34 8a 68 0a 14 42 55 46 35 70 00 60 70 83 88  F4.h..BUF5p.`p..
  c1e0: 4f 42 49 54 60 00 4c 4f 49 44 a2 43 08 4c 4f 49  OBIT`.LOID.C.LOI
  c1f0: 44 a0 4a 06 93 4c 4f 49 44 42 55 46 30 70 42 55  D.J..LOIDBUF0pBU
  c200: 46 30 88 4f 42 49 54 72 60 00 00 00 70 42 55 46  F0.OBITr`...pBUF
  c210: 31 88 4f 42 49 54 72 60 01 00 00 70 42 55 46 32  1.OBITr`...pBUF2
  c220: 88 4f 42 49 54 72 60 0a 02 00 00 70 42 55 46 33  .OBITr`....pBUF3
  c230: 88 4f 42 49 54 72 60 0a 03 00 00 70 42 55 46 34  .OBITr`....pBUF4
  c240: 88 4f 42 49 54 72 60 0a 04 00 00 70 42 55 46 35  .OBITr`....pBUF5
  c250: 88 4f 42 49 54 72 60 0a 05 00 00 a5 72 60 0a 06  .OBITr`.....r`..
  c260: 60 70 83 88 4f 42 49 54 60 00 4c 4f 49 44 a0 0a  `p..OBIT`.LOID..
  c270: 93 4c 4f 49 44 00 a4 0a ff a4 00 14 17 41 42 53  .LOID........ABS
  c280: 5f 02 a0 09 95 68 69 a4 74 69 68 00 a1 06 a4 74  _....hi.tih....t
  c290: 68 69 00 08 44 47 30 31 01 08 44 47 30 32 0a 02  hi..DG01..DG02..
  c2a0: 08 44 47 30 33 0a 03 08 44 47 30 34 0a 04 14 48  .DG03...DG04...H
  c2b0: 09 41 44 42 47 02 a0 40 09 44 42 47 5f a0 1b 93  .ADBG..@.DBG_...
  c2c0: 69 44 47 30 31 a0 13 47 44 42 47 70 0d 5b 47 45  iDG01..GDBGp.[GE
  c2d0: 4e 5d 00 5b 31 70 68 5b 31 a1 4d 06 a0 1b 93 69  N].[1ph[1.M....i
  c2e0: 44 47 30 32 a0 13 43 44 42 47 70 0d 5b 43 4c 4b  DG02..CDBGp.[CLK
  c2f0: 5d 00 5b 31 70 68 5b 31 a1 4e 04 a0 1b 93 69 44  ].[1ph[1.N....iD
  c300: 47 30 33 a0 13 56 44 42 47 70 0d 5b 56 4f 4c 5d  G03..VDBGp.[VOL]
  c310: 00 5b 31 70 68 5b 31 a1 2f a0 1c 93 69 44 47 30  .[1ph[1./...iDG0
  c320: 34 a0 14 52 44 42 47 70 0d 5b 52 43 4d 44 5d 00  4..RDBGp.[RCMD].
  c330: 5b 31 70 68 5b 31 a1 10 70 0d 5b 4e 55 4c 4c 5d  [1ph[1..p.[NULL]
  c340: 00 5b 31 70 68 5b 31 5b 80 53 4d 49 58 01 53 4d  .[1ph[1[.SMIX.SM
  c350: 49 50 01 5b 81 0b 53 4d 49 58 01 53 4d 49 43 08  IP.[..SMIX.SMIC.
  c360: 08 45 58 42 46 11 03 0a 78 14 4e 07 47 43 4d 53  .EXBF...x.N.GCMS
  c370: 01 08 54 45 4d 50 11 03 0a 06 8a 54 45 4d 50 00  ..TEMP.....TEMP.
  c380: 54 4d 50 31 8b 54 45 4d 50 0a 04 54 4d 50 32 70  TMP1.TEMP..TMP2p
  c390: 01 41 53 43 44 8b 45 58 42 46 00 43 4d 53 49 8b  .ASCD.EXBF.CMSI.
  c3a0: 45 58 42 46 0a 02 43 4d 53 44 70 00 45 58 42 46  EXBF..CMSDp.EXBF
  c3b0: 70 68 43 4d 53 49 70 45 58 42 46 41 53 42 46 70  phCMSIpEXBFASBFp
  c3c0: 41 4f 44 53 53 4d 49 43 70 41 53 42 46 45 58 42  AODSSMICpASBFEXB
  c3d0: 46 70 41 53 54 53 54 4d 50 31 70 43 4d 53 44 54  FpASTSTMP1pCMSDT
  c3e0: 4d 50 32 a4 54 45 4d 50 14 45 05 53 43 4d 53 02  MP2.TEMP.E.SCMS.
  c3f0: 70 0a 02 41 53 43 44 8b 45 58 42 46 00 43 4d 53  p..ASCD.EXBF.CMS
  c400: 49 8b 45 58 42 46 0a 02 43 4d 53 44 70 00 45 58  I.EXBF..CMSDp.EX
  c410: 42 46 70 68 43 4d 53 49 70 69 43 4d 53 44 70 45  BFphCMSIpiCMSDpE
  c420: 58 42 46 41 53 42 46 70 41 4f 44 53 53 4d 49 43  XBFASBFpAODSSMIC
  c430: 70 41 53 42 46 45 58 42 46 a4 41 53 54 53 14 1b  pASBFEXBF.ASTS..
  c440: 47 45 54 43 01 70 00 47 56 42 32 70 43 43 4c 4b  GETC.p.GVB2pCCLK
  c450: 68 47 56 42 31 a4 47 56 42 46 14 45 07 53 45 54  hGVB1.GVBF.E.SET
  c460: 43 02 a0 30 93 68 01 78 69 0b e8 03 00 60 a0 24  C..0.h.xi....`.$
  c470: 92 95 60 0a 64 74 60 0a 64 60 5c 2f 05 5f 53 42  ..`.dt`.d`\/._SB
  c480: 5f 50 43 49 30 53 42 52 47 41 53 4f 43 45 46 53  _PCI0SBRGASOCEFS
  c490: 42 01 60 a1 3a a0 30 93 68 0a 02 78 69 0b e8 03  B.`.:.0.h..xi...
  c4a0: 00 60 a0 23 92 95 60 0a 64 74 60 00 60 5c 2f 05  .`.#..`.dt`.`\/.
  c4b0: 5f 53 42 5f 50 43 49 30 53 42 52 47 41 53 4f 43  _SB_PCI0SBRGASOC
  c4c0: 45 50 43 49 01 60 a1 07 a0 05 93 68 0a 03 a4 00  EPCI.`.....h....
  c4d0: 14 08 43 49 4e 49 00 a4 00 14 43 07 43 43 4c 4b  ..CINI....C.CCLK
  c4e0: 01 a0 2c 93 68 01 70 5c 2f 05 5f 53 42 5f 50 43  ..,.h.p\/._SB_PC
  c4f0: 49 30 53 42 52 47 41 53 4f 43 45 46 53 42 00 00  I0SBRGASOCEFSB..
  c500: 61 72 61 0a 64 61 77 61 0b e8 03 61 a4 61 a1 36  ara.dawa...a.a.6
  c510: a0 2c 93 68 0a 02 70 5c 2f 05 5f 53 42 5f 50 43  .,.h..p\/._SB_PC
  c520: 49 30 53 42 52 47 41 53 4f 43 45 50 43 49 00 00  I0SBRGASOCEPCI..
  c530: 61 72 61 00 61 77 61 0b e8 03 61 a4 61 a1 07 a0  ara.awa...a.a...
  c540: 05 93 68 0a 03 70 01 47 56 42 32 a4 00 08 50 57  ..h..p.GVB2...PW
  c550: 49 46 11 0b 0a 08 00 00 00 00 00 00 00 00 8c 50  IF.............P
  c560: 57 49 46 01 50 57 4d 58 8c 50 57 49 46 0a 02 50  WIF.PWMX.PWIF..P
  c570: 57 45 4e 8c 50 57 49 46 0a 03 50 4d 49 4e 8c 50  WEN.PWIF..PMIN.P
  c580: 57 49 46 0a 04 50 4d 41 58 8c 50 57 49 46 0a 05  WIF..PMAX.PWIF..
  c590: 50 44 46 54 8c 50 57 49 46 0a 06 50 53 54 50 8c  PDFT.PWIF..PSTP.
  c5a0: 50 57 49 46 0a 07 50 4e 4d 44 08 50 58 49 46 11  PWIF..PNMD.PXIF.
  c5b0: 07 0a 04 00 00 00 00 8c 50 58 49 46 00 50 58 48  ........PXIF.PXH
  c5c0: 49 8c 50 58 49 46 01 50 58 4e 4d 8c 50 58 49 46  I.PXIF.PXNM.PXIF
  c5d0: 0a 02 50 58 45 4e 8c 50 58 49 46 0a 03 50 58 49  ..PXEN.PXIF..PXI
  c5e0: 4f 14 49 0c 56 49 4e 49 00 08 4c 44 46 54 00 70  O.I.VINI..LDFT.p
  c5f0: 83 88 4f 42 49 44 00 00 60 70 01 61 a2 4b 04 60  ..OBID..`p.a.K.`
  c600: 53 4f 49 44 83 88 4f 42 49 44 61 00 a0 37 93 49  SOID..OBIDa..7.I
  c610: 44 30 31 0a 02 a0 2e 93 47 50 49 46 49 44 30 32  D01.....GPIFID02
  c620: 00 a0 22 93 50 57 45 4e 01 50 57 4d 52 50 57 4d  ..".PWEN.PWMRPWM
  c630: 58 a0 12 92 90 50 58 45 4e 50 58 49 4f 70 01 4c  X....PXENPXIOp.L
  c640: 44 46 54 a5 76 60 75 61 a0 4e 05 93 4c 44 46 54  DFT.v`ua.N..LDFT
  c650: 01 44 49 53 43 70 83 88 4f 42 49 44 00 00 60 70  .DISCp..OBID..`p
  c660: 01 61 a2 44 04 60 53 4f 49 44 83 88 4f 42 49 44  .a.D.`SOID..OBID
  c670: 61 00 a0 30 93 49 44 30 31 0a 02 a0 27 93 47 50  a..0.ID01...'.GP
  c680: 49 46 49 44 30 32 00 a0 1b 93 50 57 45 4e 01 46  IFID02....PWEN.F
  c690: 50 44 56 50 57 4d 58 50 57 4d 57 50 57 4d 58 50  PDVPWMXPWMWPWMXP
  c6a0: 44 46 54 76 60 75 61 43 4e 43 54 14 2f 53 45 54  DFTv`uaCNCT./SET
  c6b0: 56 02 a0 28 93 47 50 49 46 68 00 70 56 54 52 5f  V..(.GPIFh.pVTR_
  c6c0: 69 60 57 54 56 52 60 50 57 4d 58 50 4d 41 58 50  i`WTVR`PWMXPMAXP
  c6d0: 4d 49 4e 50 44 46 54 50 53 54 50 14 41 04 47 45  MINPDFTPSTP.A.GE
  c6e0: 54 56 01 a0 25 93 47 50 49 46 68 00 70 50 57 4d  TV..%.GPIFh.pPWM
  c6f0: 52 50 57 4d 58 60 70 52 54 56 5f 60 61 70 00 47  RPWMX`pRTV_`ap.G
  c700: 56 42 32 70 61 47 56 42 31 a1 0e 70 00 47 56 42  VB2paGVB1..p.GVB
  c710: 31 70 0a 04 47 56 42 32 a4 47 56 42 46 14 45 06  1p..GVB2.GVBF.E.
  c720: 47 50 49 46 01 50 57 4d 49 70 00 61 70 00 60 a2  GPIF.PWMIp.ap.`.
  c730: 48 04 01 a0 11 93 83 88 50 57 4d 54 61 00 0a ff  H.......PWMTa...
  c740: 70 0a ff 60 a5 a0 2d 93 83 88 50 57 4d 54 61 00  p..`..-...PWMTa.
  c750: 68 70 0a 08 62 70 00 63 a2 19 62 70 83 88 50 57  hp..bp.c..bp..PW
  c760: 4d 54 72 61 63 00 00 88 50 57 49 46 63 00 75 63  MTrac...PWIFc.uc
  c770: 76 62 a5 72 61 0a 08 61 a0 08 93 60 0a ff a4 0a  vb.ra..a...`....
  c780: ff a4 00 14 37 57 54 56 52 06 08 50 54 47 54 00  ....7WTVR..PTGT.
  c790: a0 0e 91 94 68 6a 95 68 6b 70 6c 50 54 47 54 a1  ....hj.hkplPTGT.
  c7a0: 07 70 68 50 54 47 54 70 50 57 4d 52 69 60 52 4d  .phPTGTpPWMRi`RM
  c7b0: 50 56 50 54 47 54 60 6d 69 a4 00 14 37 50 57 4d  PVPTGT`mi...7PWM
  c7c0: 52 01 a0 04 93 68 01 a1 29 a0 05 93 68 0a 02 a1  R....h..)...h...
  c7d0: 21 a0 05 93 68 0a 03 a1 19 a0 05 93 68 0a 04 a1  !...h.......h...
  c7e0: 11 a0 05 93 68 0a 05 a1 09 a0 05 93 68 0a 06 a1  ....h.......h...
  c7f0: 01 a4 00 14 38 50 57 4d 57 02 70 69 61 a0 04 93  ....8PWMW.pia...
  c800: 68 01 a1 27 a0 05 93 68 0a 02 a1 1f a0 05 93 68  h..'...h.......h
  c810: 0a 03 a1 17 a0 05 93 68 0a 04 a1 0f a0 05 93 68  .......h.......h
  c820: 0a 05 a1 07 a0 05 93 68 0a 06 a4 00 14 39 46 50  .......h.....9FP
  c830: 44 56 01 70 50 4e 4d 44 62 a0 04 93 68 01 a1 27  DV.pPNMDb...h..'
  c840: a0 05 93 68 0a 02 a1 1f a0 05 93 68 0a 03 a1 17  ...h.......h....
  c850: a0 05 93 68 0a 04 a1 0f a0 05 93 68 0a 05 a1 07  ...h.......h....
  c860: a0 05 93 68 0a 06 14 47 04 52 4d 50 56 04 70 68  ...h...G.RMPV.ph
  c870: 60 70 69 61 a2 29 01 a0 0a 95 41 42 53 5f 60 61  `pia.)....ABS_`a
  c880: 6a a5 a0 08 94 60 61 72 61 6a 61 a0 08 95 60 61  j....`araja...`a
  c890: 74 61 6a 61 50 57 4d 57 6b 61 5b 22 0a 64 a0 0b  tajaPWMWka[".d..
  c8a0: 92 93 60 61 50 57 4d 57 6b 60 5b 22 0a 02 08 47  ..`aPWMWk`["...G
  c8b0: 46 30 31 00 08 54 53 42 46 11 23 0a 20 00 00 00  F01..TSBF.#. ...
  c8c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  c8d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 08 47 56  ..............GV
  c8e0: 42 46 11 08 0a 05 00 00 00 00 00 8a 47 56 42 46  BF..........GVBF
  c8f0: 00 47 56 42 31 8c 47 56 42 46 0a 04 47 56 42 32  .GVB1.GVBF..GVB2
  c900: 14 29 41 4d 30 31 00 a0 20 92 47 46 30 31 42 4d  .)AM01.. .GF01BM
  c910: 30 31 43 49 4e 49 56 49 4e 49 58 49 4e 49 45 4d  01CINIVINIXINIEM
  c920: 30 31 70 01 47 46 30 31 a4 00 14 0b 41 4d 30 32  01p.GF01....AM02
  c930: 00 a4 4f 42 49 44 14 49 04 41 4d 30 33 01 53 4f  ..OBID.I.AM03.SO
  c940: 49 44 68 a0 0f 93 49 44 30 31 01 47 45 54 43 49  IDh...ID01.GETCI
  c950: 44 30 32 a1 27 a0 10 93 49 44 30 31 0a 02 47 45  D02.'...ID01..GE
  c960: 54 56 49 44 30 32 a1 14 70 00 47 56 42 31 70 0a  TVID02..p.GVB1p.
  c970: 04 47 56 42 32 70 47 56 42 46 60 a4 47 56 42 46  .GVB2pGVBF`.GVBF
  c980: 14 3d 41 4d 30 34 02 53 4f 49 44 68 a0 12 93 49  .=AM04.SOIDh...I
  c990: 44 30 31 01 70 53 45 54 43 49 44 30 32 69 60 a1  D01.pSETCID02i`.
  c9a0: 1c a0 14 93 49 44 30 31 0a 02 53 45 54 56 49 44  ....ID01..SETVID
  c9b0: 30 32 69 70 00 60 a1 05 70 0a 04 60 a4 60 14 4a  02ip.`..p..`.`.J
  c9c0: 07 41 4d 30 35 01 08 49 4e 46 4f 11 17 0a 14 00  .AM05..INFO.....
  c9d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  c9e0: 00 00 00 8a 49 4e 46 4f 00 49 46 49 44 8a 49 4e  ....INFO.IFID.IN
  c9f0: 46 4f 0a 04 49 46 4d 49 8a 49 4e 46 4f 0a 08 49  FO..IFMI.INFO..I
  ca00: 46 4d 58 8a 49 4e 46 4f 0a 0c 49 46 53 50 5b 13  FMX.INFO..IFSP[.
  ca10: 49 4e 46 4f 0a 80 0a 03 49 46 53 54 53 4f 49 44  INFO....IFSTSOID
  ca20: 68 42 4d 30 35 68 43 50 54 42 68 49 4e 46 4f 45  hBM05hCPTBhINFOE
  ca30: 4d 30 35 68 a4 49 4e 46 4f 14 0c 41 4d 30 36 00  M05h.INFO..AM06.
  ca40: 48 4d 30 36 a4 00 14 0d 41 4d 30 37 01 48 4d 30  HM06....AM07.HM0
  ca50: 37 68 a4 00 14 45 0b 41 4d 30 38 01 08 4c 4f 44  7h...E.AM08..LOD
  ca60: 54 12 36 34 00 00 00 00 00 00 00 00 00 00 00 00  T.64............
  ca70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  ca80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  ca90: 00 00 00 00 00 00 00 00 70 00 60 a2 36 01 a0 0f  ........p.`.6...
  caa0: 93 83 88 4f 42 44 54 60 00 68 70 00 64 a5 a0 10  ...OBDT`.hp.d...
  cab0: 93 83 88 4f 42 44 54 60 00 00 70 0a 04 64 a5 72  ...OBDT`..p..d.r
  cac0: 60 83 88 4f 42 44 54 72 60 01 00 00 60 72 60 0a  `..OBDTr`...`r`.
  cad0: 02 60 a0 02 64 a1 2f 70 83 88 4f 42 44 54 72 60  .`..d./p..OBDTr`
  cae0: 01 00 00 61 72 61 0a 02 61 70 00 62 a2 18 61 70  ...ara..ap.b..ap
  caf0: 83 88 4f 42 44 54 60 00 88 4c 4f 44 54 62 00 76  ..OBDT`..LODTb.v
  cb00: 61 75 60 75 62 a4 4c 4f 44 54 08 4f 42 53 56 12  au`ub.LODT.OBSV.
  cb10: 0b 09 00 00 00 00 00 00 00 00 00 14 4b 07 41 50  ............K.AP
  cb20: 54 53 01 a0 43 07 90 47 46 30 31 91 93 68 0a 04  TS..C..GF01..h..
  cb30: 93 68 0a 03 70 83 88 4f 42 49 44 00 00 60 70 01  .h..p..OBID..`p.
  cb40: 61 70 00 62 a2 42 05 60 53 4f 49 44 83 88 4f 42  ap.b.B.`SOID..OB
  cb50: 49 44 61 00 a0 15 93 49 44 30 31 01 47 45 54 43  IDa....ID01.GETC
  cb60: 49 44 30 32 70 47 56 42 31 63 a1 1d a0 16 93 49  ID02pGVB1c.....I
  cb70: 44 30 31 0a 02 47 45 54 56 49 44 30 32 70 47 56  D01..GETVID02pGV
  cb80: 42 31 63 a1 04 70 00 63 70 63 88 4f 42 53 56 62  B1c..p.cpc.OBSVb
  cb90: 00 76 60 75 61 75 62 14 4f 06 41 57 41 4b 01 a0  .v`uaub.O.AWAK..
  cba0: 47 06 90 47 46 30 31 91 93 68 0a 04 93 68 0a 03  G..GF01..h...h..
  cbb0: 70 83 88 4f 42 49 44 00 00 60 70 01 61 70 00 62  p..OBID..`p.ap.b
  cbc0: a2 46 04 60 70 83 88 4f 42 53 56 62 00 63 53 4f  .F.`p..OBSVb.cSO
  cbd0: 49 44 83 88 4f 42 49 44 61 00 a0 10 93 49 44 30  ID..OBIDa....ID0
  cbe0: 31 01 53 45 54 43 49 44 30 32 63 a1 15 a0 11 93  1.SETCID02c.....
  cbf0: 49 44 30 31 0a 02 53 45 54 56 49 44 30 32 63 a1  ID01..SETVID02c.
  cc00: 01 76 60 75 61 75 62 14 0b 41 4d 30 39 00 a4 43  .v`uaub..AM09..C
  cc10: 4d 44 56 14 4b 0f 41 4d 31 30 01 8a 68 00 41 43  MDV.K.AM10..h.AC
  cc20: 4d 44 5b 13 4f 42 55 46 00 77 87 4f 42 55 46 0a  MD[.OBUF.w.OBUF.
  cc30: 08 00 54 45 4d 50 70 00 54 45 4d 50 8a 4f 42 55  ..TEMPp.TEMP.OBU
  cc40: 46 00 43 4d 44 53 a0 0f 93 41 43 4d 44 0c 01 00  F.CMDS...ACMD...
  cc50: 03 00 52 33 30 31 a1 43 0b a0 10 93 41 43 4d 44  ..R301.C....ACMD
  cc60: 0c 02 00 03 00 52 33 30 32 68 a1 4f 09 a0 10 93  .....R302h.O....
  cc70: 41 43 4d 44 0c 03 00 03 00 52 33 30 33 68 a1 4b  ACMD.....R303h.K
  cc80: 08 a0 10 93 41 43 4d 44 0c 04 00 03 00 52 33 30  ....ACMD.....R30
  cc90: 34 68 a1 47 07 a0 10 93 41 43 4d 44 0c 01 00 04  4h.G....ACMD....
  cca0: 00 52 34 30 31 68 a1 43 06 a0 10 93 41 43 4d 44  .R401h.C....ACMD
  ccb0: 0c 02 00 04 00 52 34 30 32 68 a1 4f 04 a0 10 93  .....R402h.O....
  ccc0: 41 43 4d 44 0c 03 00 04 00 52 34 30 33 68 a1 3b  ACMD.....R403h.;
  ccd0: a0 15 93 41 43 4d 44 0c 04 00 04 00 70 0c 00 00  ...ACMD.....p...
  cce0: 01 00 43 4d 44 53 a1 23 a0 15 93 41 43 4d 44 0c  ..CMDS.#...ACMD.
  ccf0: 01 00 05 00 70 0c 00 00 01 00 43 4d 44 53 a1 0b  ....p.....CMDS..
  cd00: 70 0c 00 00 01 00 43 4d 44 53 a4 4f 42 55 46 08  p.....CMDS.OBUF.
  cd10: 43 4d 44 4c 11 03 0a 54 14 45 13 41 4d 31 31 00  CMDL...T.E.AM11.
  cd20: 08 54 45 4d 50 00 8a 43 4d 44 4c 00 43 4d 44 43  .TEMP..CMDL.CMDC
  cd30: 72 54 45 4d 50 0a 04 54 45 4d 50 8a 43 4d 44 4c  rTEMP..TEMP.CMDL
  cd40: 54 45 4d 50 43 4d 44 31 72 54 45 4d 50 0a 04 54  TEMPCMD1rTEMP..T
  cd50: 45 4d 50 70 0c 01 00 03 00 43 4d 44 31 8a 43 4d  EMPp.....CMD1.CM
  cd60: 44 4c 54 45 4d 50 43 4d 44 32 72 54 45 4d 50 0a  DLTEMPCMD2rTEMP.
  cd70: 04 54 45 4d 50 70 0c 02 00 03 00 43 4d 44 32 8a  .TEMPp.....CMD2.
  cd80: 43 4d 44 4c 54 45 4d 50 43 4d 44 33 72 54 45 4d  CMDLTEMPCMD3rTEM
  cd90: 50 0a 04 54 45 4d 50 70 0c 03 00 03 00 43 4d 44  P..TEMPp.....CMD
  cda0: 33 8a 43 4d 44 4c 54 45 4d 50 43 4d 44 34 72 54  3.CMDLTEMPCMD4rT
  cdb0: 45 4d 50 0a 04 54 45 4d 50 70 0c 04 00 03 00 43  EMP..TEMPp.....C
  cdc0: 4d 44 34 8a 43 4d 44 4c 54 45 4d 50 43 4d 44 35  MD4.CMDLTEMPCMD5
  cdd0: 72 54 45 4d 50 0a 04 54 45 4d 50 70 0c 01 00 04  rTEMP..TEMPp....
  cde0: 00 43 4d 44 35 8a 43 4d 44 4c 54 45 4d 50 43 4d  .CMD5.CMDLTEMPCM
  cdf0: 44 36 72 54 45 4d 50 0a 04 54 45 4d 50 70 0c 02  D6rTEMP..TEMPp..
  ce00: 00 04 00 43 4d 44 36 8a 43 4d 44 4c 54 45 4d 50  ...CMD6.CMDLTEMP
  ce10: 43 4d 44 37 72 54 45 4d 50 0a 04 54 45 4d 50 70  CMD7rTEMP..TEMPp
  ce20: 0c 03 00 04 00 43 4d 44 37 74 54 45 4d 50 0a 04  .....CMD7tTEMP..
  ce30: 54 45 4d 50 78 54 45 4d 50 0a 04 00 54 45 4d 50  TEMPxTEMP...TEMP
  ce40: 70 54 45 4d 50 43 4d 44 43 a4 43 4d 44 4c 08 43  pTEMPCMDC.CMDL.C
  ce50: 4d 44 56 01 08 4f 42 55 46 11 04 0b 00 04 14 33  MDV..OBUF......3
  ce60: 52 33 30 31 00 70 83 88 51 4c 53 54 00 00 60 8a  R301.p..QLST..`.
  ce70: 4f 42 55 46 00 54 4d 50 31 8b 4f 42 55 46 0a 04  OBUF.TMP1.OBUF..
  ce80: 54 4d 50 32 70 60 54 4d 50 32 70 00 54 4d 50 31  TMP2p`TMP2p.TMP1
  ce90: a4 00 14 49 1d 52 33 30 32 01 08 43 49 44 58 00  ...I.R302..CIDX.
  cea0: 8b 68 0a 04 49 49 44 58 70 01 43 49 44 58 70 83  .h..IIDXp.CIDXp.
  ceb0: 88 83 88 51 4c 53 54 49 49 44 58 00 43 49 44 58  ...QLSTIIDX.CIDX
  cec0: 00 60 75 43 49 44 58 70 0a 20 61 5b 13 4f 42 55  .`uCIDXp. a[.OBU
  ced0: 46 61 0b 00 01 54 4d 50 31 70 60 54 4d 50 31 72  Fa...TMP1p`TMP1r
  cee0: 61 0b 00 01 61 70 83 88 83 88 51 4c 53 54 49 49  a...ap....QLSTII
  cef0: 44 58 00 43 49 44 58 00 60 75 43 49 44 58 5b 13  DX.CIDX.`uCIDX[.
  cf00: 4f 42 55 46 61 0a 08 54 4d 50 32 70 60 54 4d 50  OBUFa..TMP2p`TMP
  cf10: 32 72 61 0a 08 61 70 60 62 78 61 0a 08 00 65 a2  2ra..ap`bxa...e.
  cf20: 4b 05 94 62 00 70 83 88 83 88 51 4c 53 54 49 49  K..b.p....QLSTII
  cf30: 44 58 00 43 49 44 58 00 60 70 60 44 47 30 34 70  DX.CIDX.`p`DG04p
  cf40: 0a 05 64 70 00 66 a2 28 94 64 00 a0 12 95 66 87  ..dp.f.(.d....f.
  cf50: 60 70 83 88 60 66 00 88 4f 42 55 46 65 00 a1 0a  `p..`f..OBUFe...
  cf60: 70 00 88 4f 42 55 46 65 00 75 66 75 65 76 64 72  p..OBUFe.ufuevdr
  cf70: 61 0a 28 61 76 62 75 43 49 44 58 70 0b 70 03 61  a.(avbuCIDXp.p.a
  cf80: 70 83 88 83 88 51 4c 53 54 49 49 44 58 00 43 49  p....QLSTIIDX.CI
  cf90: 44 58 00 60 75 43 49 44 58 5b 13 4f 42 55 46 61  DX.`uCIDX[.OBUFa
  cfa0: 0a 10 54 4d 50 33 70 60 54 4d 50 33 72 61 0a 10  ..TMP3p`TMP3ra..
  cfb0: 61 70 83 88 83 88 51 4c 53 54 49 49 44 58 00 43  ap....QLSTIIDX.C
  cfc0: 49 44 58 00 66 a0 43 04 93 8e 66 0a 04 70 87 66  IDX.f.C...f..p.f
  cfd0: 62 78 61 0a 08 00 65 70 00 63 a2 2e 94 62 00 70  bxa...ep.c...b.p
  cfe0: 83 88 66 63 00 60 70 87 60 64 70 00 67 a2 17 94  ..fc.`p.`dp.g...
  cff0: 64 00 70 83 88 60 67 00 88 4f 42 55 46 65 00 75  d.p..`g..OBUFe.u
  d000: 67 75 65 76 64 76 62 75 63 a1 40 05 70 60 62 78  guevdvbuc.@.p`bx
  d010: 61 0a 08 00 65 a2 44 04 94 62 00 70 83 88 83 88  a...e.D..b.p....
  d020: 51 4c 53 54 49 49 44 58 00 43 49 44 58 00 60 70  QLSTIIDX.CIDX.`p
  d030: 87 60 64 70 00 66 a2 17 94 64 00 70 83 88 60 66  .`dp.f...d.p..`f
  d040: 00 88 4f 42 55 46 65 00 75 66 75 65 76 64 72 61  ..OBUFe.ufuevdra
  d050: 0a 80 00 76 62 75 43 49 44 58 8a 4f 42 55 46 00  ...vbuCIDX.OBUF.
  d060: 54 4d 50 34 70 00 54 4d 50 34 a4 00 14 4f 05 52  TMP4p.TMP4...O.R
  d070: 33 30 33 01 8b 68 0a 04 49 49 54 4d 8a 4f 42 55  303..h..IITM.OBU
  d080: 46 00 54 4d 50 31 8b 4f 42 55 46 0a 04 54 4d 50  F.TMP1.OBUF..TMP
  d090: 32 70 83 88 83 88 51 4c 53 54 49 49 54 4d 00 00  2p....QLSTIITM..
  d0a0: 00 60 70 47 43 4d 53 60 61 8a 61 00 54 4d 50 33  .`pGCMS`a.a.TMP3
  d0b0: 8b 61 0a 04 54 4d 50 34 70 54 4d 50 33 54 4d 50  .a..TMP4pTMP3TMP
  d0c0: 31 70 54 4d 50 34 54 4d 50 32 a4 00 14 42 04 52  1pTMP4TMP2...B.R
  d0d0: 33 30 34 01 8b 68 0a 04 49 49 54 4d 8b 68 0a 06  304..h..IITM.h..
  d0e0: 43 4d 53 44 8a 4f 42 55 46 00 54 4d 50 31 70 83  CMSD.OBUF.TMP1p.
  d0f0: 88 83 88 51 4c 53 54 49 49 54 4d 00 00 00 60 70  ...QLSTIITM...`p
  d100: 53 43 4d 53 60 43 4d 53 44 54 4d 50 31 a4 00 08  SCMS`CMSDTMP1...
  d110: 56 45 4e 44 11 08 0a 05 41 53 55 53 00 14 20 52  VEND....ASUS.. R
  d120: 34 30 31 01 5b 13 4f 42 55 46 0a 20 0b 00 02 54  401.[.OBUF. ...T
  d130: 4d 50 32 70 56 45 4e 44 54 4d 50 32 a4 00 14 36  MP2pVENDTMP2...6
  d140: 52 34 30 32 01 5b 13 4f 42 55 46 0a 20 0a 08 54  R402.[.OBUF. ..T
  d150: 4d 50 31 5b 13 4f 42 55 46 0a 28 0a 08 54 4d 50  MP1[.OBUF.(..TMP
  d160: 32 70 47 4d 4f 44 54 4d 50 31 70 47 46 58 4f 54  2pGMODTMP1pGFXOT
  d170: 4d 50 32 a4 00 08 54 43 49 50 12 46 2c 04 12 46  MP2...TCIP.F,..F
  d180: 0a 0a 00 0a 04 12 15 04 00 0a 02 0a 0a 11 0d 0a  ................
  d190: 0a 43 50 55 20 56 43 4f 52 45 00 12 11 04 00 0a  .CPU VCORE......
  d1a0: 03 0a 0f 11 09 0a 06 2b 33 2e 33 56 00 12 0e 04  .......+3.3V....
  d1b0: 00 01 0a 0e 11 07 0a 04 2b 35 56 00 12 0f 04 00  ........+5V.....
  d1c0: 00 0a 20 11 08 0a 05 2b 31 32 56 00 12 10 04 00  .. ....+12V.....
  d1d0: 0a 04 0a 2a 11 08 0a 05 2b 31 32 56 00 12 17 04  ...*....+12V....
  d1e0: 00 0a 05 0a 0a 11 0f 0a 0c 56 49 4e 5f 35 5f 46  .........VIN_5_F
  d1f0: 41 4b 45 44 00 12 17 04 00 0a 06 0a 0a 11 0f 0a  AKED............
  d200: 0c 56 49 4e 5f 36 5f 46 41 4b 45 44 00 12 17 04  .VIN_6_FAKED....
  d210: 00 0a 07 0a 0a 11 0f 0a 0c 56 49 4e 5f 37 5f 46  .........VIN_7_F
  d220: 41 4b 45 44 00 12 42 0b 0a 01 0a 02 12 19 04 00  AKED..B.........
  d230: 00 00 11 13 0a 10 43 50 55 20 54 45 4d 50 45 52  ......CPU TEMPER
  d240: 41 54 55 52 45 00 12 1a 04 00 01 0a ff 11 13 0a  ATURE...........
  d250: 10 4d 42 20 54 45 52 4d 50 45 52 41 54 55 52 45  .MB TERMPERATURE
  d260: 00 12 17 04 00 0a 02 0a ff 11 0f 0a 0c 41 53 55  .............ASU
  d270: 53 5f 54 4d 50 49 4e 32 00 12 12 04 00 0a 03 0a  S_TMPIN2........
  d280: ff 11 0a 0a 07 54 4d 50 49 4e 33 00 12 12 04 00  .....TMPIN3.....
  d290: 0a 04 0a ff 11 0a 0a 07 54 4d 50 49 4e 34 00 12  ........TMPIN4..
  d2a0: 12 04 00 0a 05 0a ff 11 0a 0a 07 54 4d 50 49 4e  ...........TMPIN
  d2b0: 35 00 12 12 04 00 0a 06 0a ff 11 0a 0a 07 54 4d  5.............TM
  d2c0: 50 49 4e 36 00 12 12 04 00 0a 07 0a ff 11 0a 0a  PIN6............
  d2d0: 07 54 4d 50 49 4e 37 00 12 44 0c 0a 0a 02 0a 03  .TMPIN7..D......
  d2e0: 12 12 04 00 00 0a ff 11 0b 0a 08 43 50 55 20 46  ...........CPU F
  d2f0: 41 4e 00 12 16 04 00 01 0a ff 11 0f 0a 0c 43 48  AN............CH
  d300: 41 53 53 49 53 20 46 41 4e 00 12 15 04 00 0a 02  ASSIS FAN.......
  d310: 0a ff 11 0d 0a 0a 50 4f 57 45 52 20 46 41 4e 00  ......POWER FAN.
  d320: 12 18 04 00 0a 03 0a ff 11 10 0a 0d 46 41 4e 49  ............FANI
  d330: 4e 33 5f 46 41 4b 45 44 00 12 18 04 00 0a 04 0a  N3_FAKED........
  d340: ff 11 10 0a 0d 46 41 4e 49 4e 34 5f 46 41 4b 45  .....FANIN4_FAKE
  d350: 44 00 12 18 04 00 0a 05 0a ff 11 10 0a 0d 46 41  D.............FA
  d360: 4e 49 4e 35 5f 46 41 4b 45 44 00 12 18 04 00 0a  NIN5_FAKED......
  d370: 06 0a ff 11 10 0a 0d 46 41 4e 49 4e 36 5f 46 41  .......FANIN6_FA
  d380: 4b 45 44 00 12 18 04 00 0a 07 0a ff 11 10 0a 0d  KED.............
  d390: 46 41 4e 49 4e 37 5f 46 41 4b 45 44 00 12 43 0a  FANIN7_FAKED..C.
  d3a0: 0a 0a 03 00 12 12 04 00 00 0a ff 11 0b 0a 08 46  ...............F
  d3b0: 41 4e 43 54 4c 30 00 12 12 04 00 01 0a ff 11 0b  ANCTL0..........
  d3c0: 0a 08 46 41 4e 43 54 4c 31 00 12 13 04 00 0a 02  ..FANCTL1.......
  d3d0: 0a ff 11 0b 0a 08 46 41 4e 43 54 4c 32 00 12 12  ......FANCTL2...
  d3e0: 04 00 01 0a ff 11 0b 0a 08 46 41 4e 43 54 4c 33  .........FANCTL3
  d3f0: 00 12 13 04 00 0a 04 0a ff 11 0b 0a 08 46 41 4e  .............FAN
  d400: 43 54 4c 34 00 12 13 04 00 0a 05 0a ff 11 0b 0a  CTL4............
  d410: 08 46 41 4e 43 54 4c 35 00 12 13 04 00 0a 06 0a  .FANCTL5........
  d420: ff 11 0b 0a 08 46 41 4e 43 54 4c 36 00 12 13 04  .....FANCTL6....
  d430: 00 0a 07 0a ff 11 0b 0a 08 46 41 4e 43 54 4c 37  .........FANCTL7
  d440: 00 14 4c 13 52 34 30 33 01 08 54 49 4e 58 00 8c  ..L.R403..TINX..
  d450: 68 0a 04 54 43 4f 54 8c 4f 42 55 46 0a 04 43 4e  h..TCOT.OBUF..CN
  d460: 54 43 70 83 88 54 43 49 50 54 43 4f 54 00 60 70  TCp..TCIPTCOT.`p
  d470: 83 88 60 01 00 61 70 61 43 4e 54 43 70 0d 43 4e  ..`..apaCNTCp.CN
  d480: 54 43 00 5b 31 70 43 4e 54 43 5b 31 70 0d 4c 6f  TC.[1pCNTC[1p.Lo
  d490: 63 61 6c 31 00 5b 31 70 61 5b 31 70 0a 05 62 70  cal1.[1pa[1p..bp
  d4a0: 0a 02 54 49 4e 58 a2 45 0d 61 70 0d 4c 6f 63 61  ..TINX.E.ap.Loca
  d4b0: 6c 32 00 5b 31 70 62 5b 31 70 83 88 60 54 49 4e  l2.[1pb[1p..`TIN
  d4c0: 58 00 67 70 0d 4c 6f 63 61 6c 37 00 5b 31 70 67  X.gp.Local7.[1pg
  d4d0: 5b 31 70 83 88 67 00 00 88 4f 42 55 46 62 00 75  [1p..g...OBUFb.u
  d4e0: 62 70 83 88 67 01 00 88 4f 42 55 46 62 00 75 62  bp..g...OBUFb.ub
  d4f0: 70 83 88 67 0a 02 00 88 4f 42 55 46 62 00 75 62  p..g....OBUFb.ub
  d500: 70 83 88 67 0a 03 00 64 70 0d 4c 6f 63 61 6c 34  p..g...dp.Local4
  d510: 00 5b 31 70 64 5b 31 70 87 64 63 a0 09 94 63 0a  .[1pd[1p.dc...c.
  d520: 20 70 0a 1f 63 74 0a 20 63 66 70 0d 4c 6f 63 61   p..ct. cfp.Loca
  d530: 6c 33 00 5b 31 70 63 5b 31 70 00 65 a2 15 63 70  l3.[1pc[1p.e..cp
  d540: 83 88 64 65 00 88 4f 42 55 46 62 00 75 62 75 65  ..de..OBUFb.ubue
  d550: 76 63 70 0d 4c 6f 63 61 6c 36 00 5b 31 70 66 5b  vcp.Local6.[1pf[
  d560: 31 70 0d 4f 42 55 46 00 5b 31 70 4f 42 55 46 5b  1p.OBUF.[1pOBUF[
  d570: 31 72 62 66 62 76 61 75 54 49 4e 58 a4 00 14 21  1rbfbvauTINX...!
  d580: 52 34 30 34 01 8a 4f 42 55 46 0a 04 56 44 49 4f  R404..OBUF..VDIO
  d590: 47 45 54 56 01 70 47 56 42 31 56 44 49 4f a4 00  GETV.pGVB1VDIO..
  d5a0: 08 57 51 42 41 11 40 bc 0b bb 0b 46 4f 4d 42 01  .WQBA.@....FOMB.
  d5b0: 00 00 00 ab 0b 00 00 20 4a 00 00 44 53 00 01 1a  ....... J..DS...
  d5c0: 7d da 54 28 5b a4 00 01 06 18 42 10 15 10 22 21  }.T([.....B..."!
  d5d0: 04 12 01 a1 c8 2c 0c 86 10 38 2e 84 1c 40 48 1c  .....,...8...@H.
  d5e0: 14 4a 08 84 fa 13 c8 af 00 84 0e 05 c8 14 60 50  .J............`P
  d5f0: 80 53 04 11 f4 2a c0 a6 00 93 02 2c 0a d0 2e c0  .S...*.....,....
  d600: b2 00 dd 02 a4 c3 92 ad 08 1c 21 06 1c a5 13 5b  ..........!....[
  d610: b8 61 83 17 8a a2 19 44 49 50 b9 00 df 08 02 2f  .a.....DIP...../
  d620: 57 80 e4 09 48 b3 00 c3 02 ac 0b 90 3d 04 2a 75  W...H.......=.*u
  d630: 08 28 39 43 40 0d a0 d5 09 08 bf d2 29 21 09 c2  .(9C@.......)!..
  d640: 19 ab 78 7c cd a2 e9 39 c9 39 86 1c 8f 0b 3d 08  ..x|...9.9....=.
  d650: 1e 47 03 08 93 3f 64 05 80 41 49 18 0b 75 31 6a  .G...?d..AI..u1j
  d660: d4 48 d9 80 0c 51 da a8 d1 03 3a bf 23 39 bb a3  .H...Q....:.#9..
  d670: 3b 92 04 46 3d a6 63 2c 6c 46 42 8d d1 1c 14 09  ;..F=.c,lFB.....
  d680: 37 68 b4 44 58 8d 2b f6 99 59 f8 b0 84 71 04 07  7h.DX.+..Y...q..
  d690: 76 b0 16 0d 23 b4 82 e0 34 88 a3 88 12 86 e1 19  v...#...4.......
  d6a0: 33 d0 51 32 a4 30 41 4f 20 c8 c9 33 2c 43 9c 01  3.Q2.0AO ..3,C..
  d6b0: c7 8a 11 2a 24 66 20 c1 ff ff 27 d0 35 86 3c 03  ...*$f ...'.5.<.
  d6c0: 91 7b c0 09 04 89 1e 25 b8 71 8d ca c6 74 36 b8  .{.....%.q...t6.
  d6d0: 81 99 20 ce e1 61 64 40 68 02 f1 63 87 4f 60 f7  .. ..ad@h..c.O`.
  d6e0: c7 01 29 44 d0 85 e0 4c 6b 14 60 ed ec 20 5b 10  ..)D...Lk.`.. [.
  d6f0: 3a 0b c4 6a 0c 45 10 11 82 46 31 5e 84 50 21 a2  :..j.E...F1^.P!.
  d700: 44 3d e7 20 b5 09 50 06 22 b4 60 46 60 f6 07 41  D=. ..P.".`F`..A
  d710: 24 58 80 f8 23 b0 84 13 81 8c 8c 86 1e 16 7c 12  $X..#.........|.
  d720: 60 07 04 cf e7 d4 4c e0 c0 10 e2 95 00 51 47 0b  `.....L......QG.
  d730: 4a 60 29 47 03 62 7b 60 ba 07 1c e1 b9 fb 72 70  J`)G.b{`......rp
  d740: 6a fe 69 78 9a 0f 09 98 21 7a ac 07 11 f0 10 d9  j.ix....!z......
  d750: 29 c1 80 78 ef d7 02 32 82 97 04 03 7a 12 0f 08  )..x...2....z...
  d760: 60 39 68 1c f8 09 55 7c 07 a0 47 02 36 a3 f8 26  `9h...U|..G.6..&
  d770: 28 eb f8 80 9e 73 b4 67 87 97 85 66 af 18 84 e0  (....s.g...f....
  d780: 35 c0 37 05 9f 46 2c 69 75 72 b2 2a 8f 98 82 7b  5.7..F,iur.*...{
  d790: 08 5c 04 9c 86 ee f1 82 43 c1 78 e9 ff 7f bc e0  .\......C.x.....
  d7a0: 3e 0f 1c 2f 58 4e 09 55 5d 36 34 87 f3 6d 1e 9f  >../XN.U]64..m..
  d7b0: 1c 2d 3c 61 36 96 a3 62 c7 10 36 3a 3e 0a 0f f8  .-<a6..b..6:>...
  d7c0: b5 a1 58 10 99 80 d0 91 e1 c0 c1 e2 ec 00 21 02  ..X...........!.
  d7d0: 0b 1b 39 7a c4 1e d4 3b 8c 31 1e 08 8c 7a 48 07  ..9z...;.1...zH.
  d7e0: 0f 3e 40 0f 1e 70 fa ff 27 b0 a0 21 4b c4 e0 d1  .>@..p..'..!K...
  d7f0: a7 08 0f e7 dd 87 1f 44 12 38 3c 84 06 0f 9e b3  .......D.8<.....
  d800: 8f 07 0f 7e 79 83 07 d1 14 8e 0d 77 b0 f1 c0 c1  ...~y......w....
  d810: 3d 5c fc 90 70 67 2d 78 3e 27 4f 06 f0 12 84 3b  =\..pg-x>'O....;
  d820: 6c 01 97 11 70 99 ab a4 87 2a 0b 83 41 9d ab c0  l...p....*..A...
  d830: fb ff 3f 57 01 f6 2f 53 ef 53 3e 57 81 3b da 79  ..?W../S.S>W.;.y
  d840: 40 e7 16 72 9a 41 1f 0a 7c 06 78 92 01 db a1 0a  @..r.A..|.x.....
  d850: 38 9c 64 c0 73 2b 7b 92 61 ff ff 93 0c 38 0f 62  8.d.s+{.a....8.b
  d860: 3e c9 80 ef e8 85 3b 81 c0 f3 38 24 21 1f 42 f0  >.....;...8$!.B.
  d870: 43 3a a6 67 10 60 28 e4 65 e0 03 08 8d 7e 06 01  C:.g.`(.e....~..
  d880: b4 ff ff cf 20 c0 e5 ac f0 0c 02 76 f1 af 3a 9d  .... ......v..:.
  d890: 07 1c 1c 42 4e 8e 8a a8 e1 58 eb 41 80 8c e7 45  ...BN....X.A...E
  d8a0: c0 41 4f 8a 40 f7 ac 81 3b 1f c0 3d 12 f2 73 07  .AO.@...;..=..s.
  d8b0: f8 a2 43 e8 98 89 3f 51 79 88 3e 1b 98 c0 a3 05  ..C...?Qy.>.....
  d8c0: d7 39 11 5c ff ff d1 c2 3b 69 e0 46 0b f7 00 fc  .9.\....;i.F....
  d8d0: 58 80 39 62 82 eb d0 02 a6 eb 02 e6 d2 82 3f b4  X.9b..........?.
  d8e0: 00 1f a1 27 16 94 b4 43 0b a0 f9 ff 7f 68 01 6e  ...'...C.....h.n
  d8f0: 73 7d 68 01 7b b8 73 18 95 73 0e 83 76 68 f6 39  s}h.{.s..s..vh.9
  d900: 0c b8 1e 26 f0 87 4a b8 b3 88 1f 27 da 5b 80 cf  ...&..J....'.[..
  d910: a7 c0 ed b0 86 3b 82 c0 bb 14 9c 96 a7 f6 d4 7f  .....;..........
  d920: 70 8d 5f 41 c8 3d c6 77 10 f6 ff 3f 88 01 37 19  p._A.=.w...?..7.
  d930: 07 31 54 f0 43 08 40 a1 cb c2 43 08 d8 a5 1f c4  .1T.C.@...C.....
  d940: 68 ec 83 18 ea ff 7f 82 c7 9f c3 00 a7 67 38 b8  h............g8.
  d950: 51 8f 61 80 a2 b3 28 70 82 78 0e 63 ff ff 73 18  Q.a...(p.x.c..s.
  d960: f0 14 fc 12 f0 81 85 4a 84 41 9d 59 00 de 1c 90  .......J.A.Y....
  d970: 9f 59 c0 1e f2 ad a1 1f 81 ff ff 67 16 c0 f5 99  .Y.........g....
  d980: dc 63 c5 1d 22 d8 48 42 be 0a bc 15 98 c0 91 0f  .c..".HB........
  d990: 2d 40 f7 6c 82 1b 2d dc e3 c8 39 9e d0 bb f9 eb  -@.l..-...9.....
  d9a0: 03 3b 4d b0 21 83 57 de 21 10 f5 ff 1f b2 0f 24  .;M.!.W.!......$
  d9b0: 9e c2 cb 0c 66 26 31 0e 24 c2 b1 78 78 e4 28 08  ....f&1.$..xx.(.
  d9c0: aa 33 3f 19 35 e8 67 f7 84 0f 9e e9 be e1 83 e1  .3?.5.g.........
  d9d0: 30 08 73 ce 1e 3f f8 8e 3d b8 73 10 bc eb 8a 91  0.s..?..=.s.....
  d9e0: 4f e8 25 00 73 6b c1 9e 05 81 93 ac 83 20 4a c8  O.%.sk....... J.
  d9f0: 59 10 54 ff ff 83 10 c0 04 6f f7 20 5d 83 7c 1b  Y.T......o. ].|.
  da00: 78 1a 78 f8 89 f2 20 e4 8b c4 0b 41 84 28 c7 7b  x.x... ....A.(.{
  da10: 02 11 9e 86 3c e1 30 e1 4e 36 ca 4b 43 18 43 c7  ....<.0.N6.KC.C.
  da20: 0a 14 39 7e 08 1f 85 7c 10 62 51 ce b7 f4 fc 61  ..9~...|.bQ....a
  da30: 23 67 11 d4 49 c0 87 0e 0f ea 09 01 13 1a 42 47  #g..I.........BG
  da40: 5c e0 7a da c0 fd ff 8f 42 e0 38 80 c0 7b 47 f8  \.z.....B.8..{G.
  da50: b4 0e 2e 08 9f 3f e0 fb 44 16 ee 5b c0 0b 0d ee  .....?..D..[....
  da60: ec 01 7c e4 1e 6b 51 02 61 50 67 0f c0 f9 ff ff  ..|..kQ.aPg.....
  da70: ec 01 d6 81 3e 7a 1c e8 31 06 89 11 c4 77 0e 1f  ....>z..1....w..
  da80: 7c e2 bc 11 3c 7b f8 c8 71 5c 3e 80 f8 ec e1 2b  |...<{..q\>....+
  da90: 88 f1 c2 c4 7c 38 f2 35 21 5e e4 b0 61 22 fb ec  ....|8.5!^..a"..
  daa0: c1 22 1e 6b a9 94 83 19 fa 4c e0 5b c2 99 bd 71  .".k.....L.[...q
  dab0: 44 38 ae 93 3b 9f 38 1e d2 49 fb 6c 06 be e3 07  D8..;.8..I.l....
  dac0: 70 38 9b 81 67 74 70 0f 53 e0 93 75 36 43 0f cb  p8..gtp.S..u6C..
  dad0: e7 82 57 07 0f 82 9d cb c0 75 b8 83 f3 ff 3f 97  ..W......u....?.
  dae0: 01 af 73 c7 91 b1 53 05 47 3c a8 33 79 77 39 6b  ..s...S.G<.3yw9k
  daf0: 1f 3c 02 9d e7 29 fb 1c 03 73 84 1e 3b f8 0e 26  .<...)...s..;..&
  db00: f8 83 0c 1c 98 13 38 ba 40 a7 10 e7 14 9e 63 80  ......8.@.....c.
  db10: 91 1c 4b 20 2c c0 b1 40 a2 96 49 61 7c 32 f0 39  ..K ,..@..Ia|2.9
  db20: 06 ae 24 38 d4 f8 3c b2 97 bc e3 3c 91 37 04 8f  ..$8..<....<.7..
  db30: ff 81 06 c6 c0 3d ad 93 f2 4d ee b1 c4 67 43 7e  .....=...M...gC~
  db40: 5c 60 68 fc 74 03 86 ff ff e9 06 ce 9d c1 47 0d  \`h.t.........G.
  db50: b0 5c 6d 30 58 a1 62 34 7a d7 23 a0 c7 d7 d7 45  .\m0X.b4z.#....E
  db60: 9a 42 45 0c f1 42 60 97 c7 71 e4 59 17 5c d8 cf  .BE..B`..q.Y.\..
  db70: ba 60 0f 75 4e a2 91 46 83 3a c8 f0 03 c1 63 90  .`.uN..F.:....c.
  db80: 4f 1e 06 39 d1 d3 7a 5c 78 1a f0 b8 d9 35 c1 1f  O..9..z\x....5..
  db90: 04 1f 0f f0 97 a0 80 27 fa f0 01 eb 10 82 3f 61  .......'......?a
  dba0: c0 1f 8f 8f 01 3e d1 fa 48 45 06 81 3a bc f1 91  .....>..HE..:...
  dbb0: 9e d6 db 80 0f 09 87 c5 0e 1e 3e a3 80 63 3c f0  ..........>..c<.
  dbc0: 6f 9f 4f 07 ff ff 08 af 0c 9e af 0f 66 60 b9 75  o.O.........f`.u
  dbd0: f8 d0 10 ea a9 c3 33 78 bf f0 09 04 98 04 36 34  ......3x......64
  dbe0: 48 26 73 9d b2 71 da a1 c3 b4 c8 03 82 8e 06 3e  H&s..q.........>
  dbf0: d2 f8 80 cb 0f 49 86 b0 30 0a 9d 7c 3c 1a 0f 8f  .....I..0..|<...
  dc00: c0 51 10 8f dc 21 21 64 e4 10 80 3e 2c 30 88 87  .Q...!!d...>,0..
  dc10: 2e 13 f8 d8 e0 f3 1a 9c e3 91 27 e3 69 78 dc b8  ..........'.ix..
  dc20: 53 07 dc 71 e0 0f 3a f8 53 20 3f 27 91 f3 1f a8  S..q..:.S ?'....
  dc30: 04 9e 0b 40 01 e4 ab 80 95 1e 07 e8 14 42 84 89  ...@.........B..
  dc40: 66 78 4c f0 d3 17 1d 8f 87 e5 ff ff 20 f9 f1 85  fxL......... ...
  dc50: 61 3f 9d f8 d4 76 8c ef 05 8f 5f 18 58 0f 9b c3  a?...v...._.X...
  dc60: 1a 2d ec d1 3e 3e f8 ea e1 89 f9 16 e7 43 07 58  .-..>>.......C.X
  dc70: 0e 52 c0 e3 fc c3 e6 f0 02 f1 1c e6 83 07 3b f1  .R............;.
  dc80: b1 53 1f d7 75 8e 43 9c 21 f8 20 1c 67 91 f2 38  .S..u.C.!. .g..8
  dc90: 53 72 95 7c e0 a8 1a 45 f0 be 15 b0 08 c7 08 94  Sr.|...E........
  dca0: 78 0a 49 3f 46 a0 c4 c2 51 10 1f 23 7c 90 b0 8d  x.I?F...Q..#|...
  dcb0: 63 04 6a 8c 3e 0c f2 a3 00 3f 45 c0 3f f1 e0 c6  c.j.>....?E.?...
  dcc0: 0a 77 70 6c 85 2f 3d 87 76 76 0f 09 51 de 5f 8d  .wpl./=.vv..Q._.
  dcd0: 18 21 60 d8 68 1e 23 ee d8 ce 2e 45 9e 53 ac 47  .!`.h.#....E.S.G
  dce0: 25 7e a4 80 f7 ff 27 f0 31 0f 77 a4 80 33 93 f3  %~....'.1.w..3..
  dcf0: c0 a8 1b 8b e0 8d f6 92 8d 3d 58 00 8f 13 a3 0f  .........=X.....
  dd00: 16 e0 3a 13 f8 60 01 5c cf 07 3e 1d 80 f5 f2 c3  ..:..`.\..>.....
  dd10: ef 07 30 4e 18 30 ce 07 98 1b 86 c3 2c 59 27 0c  ..0N.0......,Y'.
  dd20: 7e 5c 73 a4 d5 6a 20 ec 12 86 23 18 04 4c 27 0b  ~\s..j ...#..L'.
  dd30: 8f da 11 28 24 ed 80 81 12 73 c0 a0 20 06 74 52  ...($....s.. .tR
  dd40: 08 9d 45 fd ff 3f 60 f0 83 9d 4f 0d ec 72 eb eb  ..E..?`...O..r..
  dd50: 85 e7 e9 29 73 3c 1f 43 0c eb 8b 09 78 6e 14 ec  ...)s<.C....xn..
  dd60: 34 8b b9 b8 b1 b3 1d 3b 15 18 e5 70 df c0 ac e6  4......;...p....
  dd70: aa 80 9a 11 86 c0 e3 f5 81 11 4c fa 2e 14 20 47  ..........L... G
  dd80: e7 32 47 8f 3a 47 f9 24 c5 47 ef a3 b9 4f 2b 70  .2G.:G.$.G...O+p
  dd90: cf 52 3e 42 01 df 81 f9 52 80 3b a0 80 e1 fa 80  .R>B....R.;.....
  dda0: fd ff c3 bc a2 e0 cf 28 c0 24 f0 59 0a 74 90 3e  .......(.$.Y.t.>
  ddb0: a3 00 d7 a1 e2 ce 28 e0 38 10 1e 3d 3f 47 b1 38  ......(.8..=?G.8
  ddc0: c7 12 74 a8 97 83 6e 9b ec 58 82 8d 72 2c 41 85  ..t...n..X..r,A.
  ddd0: a0 d0 09 ca 27 09 7e c6 e3 20 06 74 f6 93 04 5a  ....'.~.. .t...Z
  dde0: c5 49 02 19 f6 5c 02 84 fe ff e7 12 f0 9e 13 9f  .I...\..........
  ddf0: 26 c0 35 6b fc 69 02 7f 3e 01 16 47 46 c0 d9 41  &.5k.i..>..GF..A
  de00: 90 1f 19 81 ef b9 84 ff ff cf 25 e0 19 b6 cf 25  ..........%....%
  de10: 80 93 9b 34 3f 97 c0 1d ba e3 9c be 10 57 58 df  ...4?........WX.
  de20: 33 e2 27 18 e3 58 82 0a 70 f8 02 b4 ff ff 4f 23  3.'..X..p.....O#
  de30: e0 3f 17 7b f4 fc 40 e2 43 06 19 3d 8d 7c f8 82  .?.{..@.C..=.|..
  de40: 1e f1 30 02 b4 07 fa f0 05 c6 db 03 3f 6e 02 af  ..0.........?n..
  de50: d8 87 12 d0 c1 f2 43 09 f8 ff ff 87 12 f0 8c 1e  ......C.........
  de60: 77 f6 02 c7 55 c2 83 37 e0 31 3d 16 18 90 9d 4b  w...U..7.1=....K
  de70: 98 ec 73 09 fa 3c 62 ab b7 63 72 52 c7 08 3f 97  ..s..<b..crR..?.
  de80: a0 24 9f 4b 00 da 1c ba c0 f1 ff 3f 74 01 3c b8  .$.K.......?t.<.
  de90: 06 fa 40 02 ae 7b 82 0f 24 c0 f5 28 00 9e 23 08  ..@..{..$..(..#.
  dea0: fe c8 ec 03 3f ee a4 ef 53 75 5c e3 1f f1 11 fc  ....?...Su\.....
  deb0: ff 1b 3f 7d 91 7b 81 8f 25 3a f0 a3 04 53 48 ee  ..?}.{..%:...SH.
  dec0: 01 02 25 10 8e 82 f8 00 e1 f0 e7 24 e8 57 4b 7e  ..%........$.WK~
  ded0: 7e c0 5f 47 d8 28 d9 71 1e 37 4a b8 60 af 0f 86  ~._G.(.q.7J.`...
  dee0: b8 c3 13 e1 67 5b cc 31 1f ee 51 e1 51 09 5c b3  ....g[.1..Q.Q.\.
  def0: 86 75 58 02 3c 78 38 4c 00 ad ff ff 61 09 fc b3  .uX.<x8L....a...
  df00: e7 83 38 11 0f 1f 03 74 2c 6f 07 ec d8 ab c3 12  ..8....t,o......
  df10: 6a 0c 3e fa fa e8 c4 20 1f 0f 31 c7 16 76 c2 07  j.>.... ..1..v..
  df20: f8 f6 ff 3f e1 03 d6 ce 24 be 3f 60 af 2d f8 a3  ...?....$.?`.-..
  df30: 09 f0 06 f7 d1 04 70 f5 ff 3f 9a e0 84 9e 9d 50  ......p..?.....P
  df40: 67 03 1f 98 6c 14 95 40 bf 69 bc 9f 07 31 f4 49  g...l..@.i...1.I
  df50: f0 53 13 06 c2 47 13 9f 24 7c 9c e0 52 e0 28 88  .S...G..$|..R.(.
  df60: 8f 13 8e 79 36 41 9f 0a 7c 3f 38 09 6c a8 f3 04  ...y6A..|?8.l...
  df70: 50 19 07 fe e8 04 57 d8 c9 04 64 27 72 60 6e e2  P.....W...d'r`n.
  df80: 1c 01 94 fe ff 27 72 e0 70 5a e5 a7 01 7c a0 a3  .....'r.pZ...|..
  df90: 2a 3a d6 93 41 23 7e 07 08 77 ea e7 f9 40 c0 8e  *:..A#~..w...@..
  dfa0: e5 3e 2c f1 f3 92 4f 11 3e 41 70 49 27 08 0a 62  .>,...O.>ApI'..b
  dfb0: 40 e7 3d 5d 7a 10 f4 7c c3 8f c5 be b6 1c c5 23  @.=]z..|.......#
  dfc0: 51 82 f9 0e 01 f4 b6 04 4f de 6d 09 44 18 77 72  Q.......O.m.D.wr
  dfd0: 16 0c e1 28 7d 80 80 31 c0 c7 84 62 df 37 f4 be  ...(}..1...b.7..
  dfe0: 04 f3 8a 09 ae f3 12 30 9e 89 ff ff 3e cf 21 e4  .......0....>.!.
  dff0: 02 c0 4f e5 60 39 36 80 67 1c ec 0a 80 3f 32 c1  ..O.`96.g....?2.
  e000: 3e 35 e2 8e 4c 60 98 08 3b e7 1c 08 f6 60 02 bc  >5..L`..;....`..
  e010: 55 1c 4c 00 2d c3 0d 72 3e 8f e4 c6 79 c3 f3 89  U.L.-..r>...y...
  e020: 84 9d c4 d9 ff ff 60 c2 25 41 48 fe 61 09 89 8d  ......`.%AH.a...
  e030: 9d fe 39 bc b9 32 82 62 8f 4b a8 c3 84 45 9e 26  ..9..2.b.K...E.&
  e040: 50 a7 69 9f 90 c9 69 82 46 3e 4d a0 87 e6 89 9d  P.i...i.F>M.....
  e050: 06 6e dc a7 c1 6f 87 fc c0 04 7c 0f 0f f8 d3 04  .n...o....|.....
  e060: ec f3 0d 1b 74 c8 77 87 17 59 1f 26 80 f9 c8 7d  ....t.w..Y.&...}
  e070: 98 00 ff ff ff d0 04 5c 15 da f4 a9 d1 a8 55 83  .......\......U.
  e080: 32 35 ca 34 a8 d5 a7 52 63 c6 a4 9d 54 bd 54 8d  25.4...Rc...T.T.
  e090: d5 91 9e 0b 02 71 d4 05 0b c4 d1 9f 40 02 b1 b8  .....q......@...
  e0a0: 57 88 40 2c f5 05 21 10 cb d4 01 c2 82 bc ef 05  W.@,..!.........
  e0b0: e2 60 52 06 40 ad 80 b0 78 cb 12 88 23 9a 39 01  .`R.@...x...#.9.
  e0c0: 50 37 20 4c a0 1e 10 26 dc 10 08 8b a3 08 84 09  P7 L...&........
  e0d0: b6 04 c2 e2 82 50 c1 9e 8e fd 4c 3e 88 80 1c da  .....P....L>....
  e0e0: 14 10 93 a0 0a 88 25 78 0c 08 c8 71 40 04 e4 50  ......%x...q@..P
  e0f0: b6 80 58 44 10 01 59 cf 1b 4e 40 16 07 22 20 8b  ..XD..Y..N@.." .
  e100: 36 06 c4 22 80 08 c8 c9 5e 70 81 48 4c 10 01 39  6.."....^p.HL..9
  e110: ec 8a 05 e4 e8 20 02 b2 4e 6f 40 4c 34 88 80 2c  ..... ..No@L4..,
  e120: fe b1 21 20 47 01 11 90 03 3e 28 02 91 b8 20 02  ..! G....>(... .
  e130: b2 46 7b 40 4c 30 88 80 2c fb 07 25 20 87 00 d1  .F{@L0..,..% ...
  e140: 00 c9 eb 40 03 24 bf 89 40 44 e2 ab 22 10 d1 0b  ...@.$..@D.."...
  e150: 22 20 ff ff a5 ff 38 04 e4 20 20 02 26 1a 81 e9  " ....8..  .&...
  e160: 0b 21 10 f9 ff 03 08 5f 48 49 44 0c 41 d0 0c 14  .!....._HID.A...
  e170: 08 5f 55 49 44 00 08 5f 57 44 47 11 2b 0a 28 6a  ._UID.._WDG.+.(j
  e180: 0f bc ab a1 8e d1 11 00 a0 c9 06 29 10 00 00 41  ...........)...A
  e190: 41 01 02 21 12 90 05 66 d5 d1 11 b2 f0 00 a0 c9  A..!...f........
  e1a0: 06 29 10 42 41 01 00 14 46 0d 57 4d 41 41 03 a0  .).BA...F.WMAA..
  e1b0: 4e 0c 93 68 00 a0 18 91 91 92 93 69 01 92 93 69  N..h.......i...i
  e1c0: 0a 02 92 93 69 0a 06 8a 6a 00 57 49 49 44 a0 09  ....i...j.WIID..
  e1d0: 93 69 01 a4 41 4d 30 31 a1 45 0a a0 0a 93 69 0a  .i..AM01.E....i.
  e1e0: 02 a4 41 4d 30 32 a1 47 09 a0 0e 93 69 0a 03 a4  ..AM02.G....i...
  e1f0: 41 4d 30 33 57 49 49 44 a1 45 08 a0 1a 93 69 0a  AM03WIID.E....i.
  e200: 04 8a 6a 0a 04 49 56 41 4c a4 41 4d 30 34 57 49  ..j..IVAL.AM04WI
  e210: 49 44 49 56 41 4c a1 47 06 a0 0e 93 69 0a 05 a4  IDIVAL.G....i...
  e220: 41 4d 30 35 57 49 49 44 a1 45 05 a0 0a 93 69 0a  AM05WIID.E....i.
  e230: 06 a4 41 4d 30 36 a1 47 04 a0 0a 93 69 0a 07 41  ..AM06.G....i..A
  e240: 4d 30 37 6a a1 39 a0 0d 93 69 0a 08 41 4d 30 38  M07j.9...i..AM08
  e250: 57 49 49 44 a1 29 a0 0a 93 69 0a 09 a4 41 4d 30  WIID.)...i...AM0
  e260: 39 a1 1c a0 0b 93 69 0a 0a a4 41 4d 31 30 6a a1  9.....i...AM10j.
  e270: 0e a0 0a 93 69 0a 0b a4 41 4d 31 31 a1 01 08 51  ....i...AM11...Q
  e280: 4c 53 54 12 43 32 08 0a 07 12 3c 05 0b 26 26 0d  LST.C2....<..&&.
  e290: 4d 65 6d 6f 72 79 20 43 6c 6f 63 6b 20 4d 6f 64  Memory Clock Mod
  e2a0: 65 00 00 0a 03 12 20 03 11 08 0a 05 41 75 74 6f  e..... .....Auto
  e2b0: 00 11 09 0a 06 4c 69 6d 69 74 00 11 0a 0a 07 4d  .....Limit.....M
  e2c0: 61 6e 75 61 6c 00 12 47 06 06 0b a0 35 0d 4d 65  anual..G....5.Me
  e2d0: 6d 63 6c 6f 63 6b 20 56 61 6c 75 65 00 01 11 08  mclock Value....
  e2e0: 0a 05 02 00 01 03 00 0a 08 12 44 04 08 11 07 0a  ..........D.....
  e2f0: 04 72 76 64 00 11 07 0a 04 72 76 64 00 11 07 0a  .rvd.....rvd....
  e300: 04 72 76 64 00 11 07 0a 04 34 30 30 00 11 07 0a  .rvd.....400....
  e310: 04 35 33 33 00 11 07 0a 04 36 36 37 00 11 07 0a  .533.....667....
  e320: 04 38 30 30 00 11 08 0a 05 41 75 74 6f 00 12 3f  .800.....Auto..?
  e330: 05 0b 2e 26 0d 44 52 41 4d 20 54 69 6d 69 6e 67  ...&.DRAM Timing
  e340: 20 4d 6f 64 65 00 00 0a 04 12 24 04 11 08 0a 05   Mode.....$.....
  e350: 41 75 74 6f 00 11 07 0a 04 72 76 64 00 11 07 0a  Auto.....rvd....
  e360: 04 72 76 64 00 11 08 0a 05 42 6f 74 68 00 12 4d  .rvd.....Both..M
  e370: 0c 07 0b 3c 45 0d 44 43 54 30 20 43 41 53 20 4c  ...<E.DCT0 CAS L
  e380: 61 74 65 6e 63 79 20 28 43 4c 29 00 0a 02 11 08  atency (CL).....
  e390: 0a 05 02 00 03 03 00 11 08 0a 05 02 02 03 03 00  ................
  e3a0: 0a 10 12 49 09 10 11 08 0a 05 41 75 74 6f 00 11  ...I......Auto..
  e3b0: 07 0a 04 72 76 64 00 11 07 0a 04 72 76 64 00 11  ...rvd.....rvd..
  e3c0: 09 0a 06 34 20 43 4c 4b 00 11 09 0a 06 35 20 43  ...4 CLK.....5 C
  e3d0: 4c 4b 00 11 09 0a 06 36 20 43 4c 4b 00 11 09 0a  LK.....6 CLK....
  e3e0: 06 37 20 43 4c 4b 00 11 09 0a 06 38 20 43 4c 4b  .7 CLK.....8 CLK
  e3f0: 00 11 09 0a 06 39 20 43 4c 4b 00 11 0a 0a 07 31  .....9 CLK.....1
  e400: 30 20 43 4c 4b 00 11 0a 0a 07 31 31 20 43 4c 4b  0 CLK.....11 CLK
  e410: 00 11 0a 0a 07 31 32 20 43 4c 4b 00 11 07 0a 04  .....12 CLK.....
  e420: 72 76 64 00 11 07 0a 04 72 76 64 00 11 07 0a 04  rvd.....rvd.....
  e430: 72 76 64 00 11 07 0a 04 72 76 64 00 12 2f 05 0b  rvd.....rvd../..
  e440: 5c 45 0d 4e 42 20 46 49 44 20 43 6f 6e 74 72 6f  \E.NB FID Contro
  e450: 6c 00 00 0a 02 12 16 02 11 0a 0a 07 4d 61 6e 75  l...........Manu
  e460: 61 6c 00 11 08 0a 05 41 75 74 6f 00 12 40 10 06  al.....Auto..@..
  e470: 0b f0 53 0d 4e 42 46 49 44 20 49 44 00 01 11 08  ..S.NBFID ID....
  e480: 0a 05 02 01 06 03 00 0a 21 12 43 0e 21 11 05 0a  ........!.C.!...
  e490: 02 33 00 11 05 0a 02 34 00 11 05 0a 02 35 00 11  .3.....4.....5..
  e4a0: 05 0a 02 36 00 11 05 0a 02 37 00 11 05 0a 02 38  ...6.....7.....8
  e4b0: 00 11 05 0a 02 39 00 11 06 0a 03 31 30 00 11 06  .....9.....10...
  e4c0: 0a 03 31 31 00 11 06 0a 03 31 32 00 11 06 0a 03  ..11.....12.....
  e4d0: 31 33 00 11 06 0a 03 31 34 00 11 06 0a 03 31 35  13.....14.....15
  e4e0: 00 11 06 0a 03 31 36 00 11 06 0a 03 31 37 00 11  .....16.....17..
  e4f0: 06 0a 03 31 38 00 11 06 0a 03 31 39 00 11 06 0a  ...18.....19....
  e500: 03 32 30 00 11 06 0a 03 32 31 00 11 06 0a 03 32  .20.....21.....2
  e510: 32 00 11 06 0a 03 32 33 00 11 06 0a 03 32 34 00  2.....23.....24.
  e520: 11 06 0a 03 32 35 00 11 06 0a 03 32 36 00 11 06  ....25.....26...
  e530: 0a 03 32 37 00 11 06 0a 03 32 38 00 11 06 0a 03  ..27.....28.....
  e540: 32 39 00 11 06 0a 03 33 30 00 11 06 0a 03 33 31  29.....30.....31
  e550: 00 11 06 0a 03 33 32 00 11 06 0a 03 33 33 00 11  .....32.....33..
  e560: 06 0a 03 33 34 00 11 06 0a 03 33 35 00 12 39 05  ...34.....35..9.
  e570: 0b 8f 17 0d 44 44 52 33 20 4d 65 6d 6f 72 79 20  ....DDR3 Memory 
  e580: 50 72 6f 66 69 6c 65 00 00 0a 02 12 1b 02 11 0c  Profile.........
  e590: 0a 09 44 69 73 61 62 6c 65 64 00 11 0b 0a 08 45  ..Disabled.....E
  e5a0: 6e 61 62 6c 65 64 00 10 25 2e 5f 53 42 5f 50 43  nabled..%._SB_PC
  e5b0: 49 30 5b 80 54 56 49 44 00 0c 00 0f d4 fe 0a 02  I0[.TVID........
  e5c0: 5b 81 0b 54 56 49 44 02 56 49 44 54 10 5b 82 46  [..TVID.VIDT.[.F
  e5d0: 07 2f 04 5f 53 42 5f 50 43 49 30 53 42 52 47 54  ./._SB_PCI0SBRGT
  e5e0: 50 4d 5f 08 5f 48 49 44 0c 24 d8 01 02 08 5f 43  PM_._HID.$...._C
  e5f0: 49 44 0c 41 d0 0c 31 08 5f 55 49 44 01 08 5f 43  ID.A..1._UID.._C
  e600: 52 53 11 21 0a 1e 47 01 4e 00 4e 00 01 02 47 01  RS.!..G.N.N...G.
  e610: 00 47 00 47 01 0c 86 09 00 01 00 00 d4 fe 00 50  .G.G...........P
  e620: 00 00 79 00 14 20 5f 53 54 41 00 a0 15 54 50 4d  ..y.. _STA...TPM
  e630: 46 a0 0d 92 93 56 49 44 54 0b 86 80 a4 0a 0f a4  F....VIDT.......
  e640: 00 a1 03 a4 00 5b 82 44 06 2f 03 5f 53 42 5f 50  .....[.D./._SB_P
  e650: 43 49 30 49 54 50 4d 08 5f 48 49 44 0d 49 4e 54  CI0ITPM._HID.INT
  e660: 43 30 31 30 32 00 08 5f 43 49 44 0c 41 d0 0c 31  C0102.._CID.A..1
  e670: 08 5f 55 49 44 01 08 5f 43 52 53 11 11 0a 0e 86  ._UID.._CRS.....
  e680: 09 00 01 00 00 d4 fe 00 50 00 00 79 00 14 1d 5f  ........P..y..._
  e690: 53 54 41 00 a0 14 54 50 4d 46 a0 0c 93 56 49 44  STA...TPMF...VID
  e6a0: 54 0b 86 80 a4 0a 0f a4 00 a4 00 10 47 38 2f 04  T...........G8/.
  e6b0: 5f 53 42 5f 50 43 49 30 53 42 52 47 54 50 4d 5f  _SB_PCI0SBRGTPM_
  e6c0: 08 54 41 41 58 00 5b 80 4d 49 50 54 01 53 4d 49  .TAAX.[.MIPT.SMI
  e6d0: 54 01 5b 81 0b 4d 49 50 54 01 50 53 4d 49 08 08  T.[..MIPT.PSMI..
  e6e0: 50 50 49 31 12 04 02 00 00 08 50 50 49 32 12 05  PPI1......PPI2..
  e6f0: 03 00 00 00 08 4d 42 55 46 11 03 0a 04 8c 4d 42  .....MBUF.....MB
  e700: 55 46 00 42 55 46 30 8c 4d 42 55 46 01 42 55 46  UF.BUF0.MBUF.BUF
  e710: 31 8c 4d 42 55 46 0a 02 42 55 46 32 8c 4d 42 55  1.MBUF..BUF2.MBU
  e720: 46 0a 03 42 55 46 33 14 4b 30 5f 44 53 4d 04 a0  F..BUF3.K0_DSM..
  e730: 4e 26 93 68 11 13 0a 10 a6 fa dd 3d 1b 36 b4 4e  N&.h.......=.6.N
  e740: a4 24 8d 10 08 9d 16 53 08 54 54 54 30 00 70 99  .$.....S.TTT0.p.
  e750: 6a 00 54 54 54 30 a0 0c 93 54 54 54 30 00 a4 11  j.TTT0...TTT0...
  e760: 03 01 7f a1 4a 23 a0 0d 93 54 54 54 30 01 a4 0d  ....J#...TTT0...
  e770: 31 2e 30 00 a1 49 22 a0 44 05 93 54 54 54 30 0a  1.0..I".D..TTT0.
  e780: 02 70 41 41 58 42 54 41 41 58 70 43 4d 52 51 42  .pAAXBTAAXpCMRQB
  e790: 55 46 30 70 0a f0 42 55 46 31 70 99 83 88 6b 00  UF0p..BUF1p...k.
  e7a0: 00 00 42 55 46 32 70 01 42 55 46 33 70 4d 42 55  ..BUF2p.BUF3pMBU
  e7b0: 46 41 41 58 42 70 0a fb 50 53 4d 49 5b 22 0b e8  FAAXBp..PSMI["..
  e7c0: 03 70 54 41 41 58 41 41 58 42 a4 00 a1 41 1d a0  .pTAAXAAXB...A..
  e7d0: 42 07 93 54 54 54 30 0a 03 70 41 41 58 42 54 41  B..TTT0..pAAXBTA
  e7e0: 41 58 70 43 4d 52 51 42 55 46 30 70 0a 0f 42 55  AXpCMRQBUF0p..BU
  e7f0: 46 31 70 00 42 55 46 32 70 00 42 55 46 33 70 4d  F1p.BUF2p.BUF3pM
  e800: 42 55 46 41 41 58 42 70 0a fb 50 53 4d 49 5b 22  BUFAAXBp..PSMI["
  e810: 0b e8 03 70 41 41 58 42 4d 42 55 46 70 42 55 46  ...pAAXBMBUFpBUF
  e820: 32 63 70 00 88 50 50 49 31 00 00 70 63 88 50 50  2cp..PPI1..pc.PP
  e830: 49 31 01 00 70 54 41 41 58 41 41 58 42 a4 50 50  I1..pTAAXAAXB.PP
  e840: 49 31 a1 4b 15 a0 0b 93 54 54 54 30 0a 04 a4 0a  I1.K....TTT0....
  e850: 02 a1 4c 14 a0 4a 13 93 54 54 54 30 0a 05 70 41  ..L..J..TTT0..pA
  e860: 41 58 42 54 41 41 58 70 43 4d 52 51 42 55 46 30  AXBTAAXpCMRQBUF0
  e870: 70 0a f0 42 55 46 31 70 00 42 55 46 32 70 00 42  p..BUF1p.BUF2p.B
  e880: 55 46 33 70 4d 42 55 46 41 41 58 42 70 0a fb 50  UF3pMBUFAAXBp..P
  e890: 53 4d 49 5b 22 0b e8 03 70 41 41 58 42 4d 42 55  SMI["...pAAXBMBU
  e8a0: 46 7a 42 55 46 32 0a 04 63 70 43 4d 45 52 42 55  FzBUF2..cpCMERBU
  e8b0: 46 30 70 0a ff 42 55 46 31 70 00 42 55 46 32 70  F0p..BUF1p.BUF2p
  e8c0: 00 42 55 46 33 70 4d 42 55 46 41 41 58 42 70 0a  .BUF3pMBUFAAXBp.
  e8d0: fb 50 53 4d 49 5b 22 0b e8 03 70 41 41 58 42 4d  .PSMI["...pAAXBM
  e8e0: 42 55 46 70 42 55 46 32 66 72 43 4d 45 52 01 64  BUFpBUF2frCMER.d
  e8f0: 70 64 42 55 46 30 70 0a ff 42 55 46 31 70 00 42  pdBUF0p..BUF1p.B
  e900: 55 46 32 70 00 42 55 46 33 70 4d 42 55 46 41 41  UF2p.BUF3pMBUFAA
  e910: 58 42 70 0a fb 50 53 4d 49 5b 22 0b e8 03 70 41  XBp..PSMI["...pA
  e920: 41 58 42 4d 42 55 46 70 42 55 46 32 67 77 67 0b  AXBMBUFpBUF2gwg.
  e930: 00 01 62 72 62 66 62 70 00 88 50 50 49 32 00 00  ..brbfbp..PPI2..
  e940: 70 63 88 50 50 49 32 01 00 a0 14 93 62 0b f0 ff  pc.PPI2.....b...
  e950: 70 0c f0 ff ff ff 88 50 50 49 32 0a 02 00 a1 22  p......PPI2...."
  e960: a0 14 93 62 0b f1 ff 70 0c f1 ff ff ff 88 50 50  ...b...p......PP
  e970: 49 32 0a 02 00 a1 0b 70 62 88 50 50 49 32 0a 02  I2.....pb.PPI2..
  e980: 00 70 54 41 41 58 41 41 58 42 a4 50 50 49 32 a1  .pTAAXAAXB.PPI2.
  e990: 0e a0 0a 93 54 54 54 30 0a 06 a4 00 a1 01 a1 4f  ....TTT0.......O
  e9a0: 08 a0 4c 08 93 68 11 13 0a 10 ed 54 60 37 13 cc  ..L..h.....T`7..
  e9b0: 75 46 90 1c 47 56 d7 f2 d4 5d 08 54 54 54 31 00  uF..GV...].TTT1.
  e9c0: 70 99 6a 00 54 54 54 31 a0 0c 93 54 54 54 31 00  p.j.TTT1...TTT1.
  e9d0: a4 11 03 01 03 a1 48 05 a0 43 05 93 54 54 54 31  ......H..C..TTT1
  e9e0: 01 70 41 41 58 42 54 41 41 58 70 43 4d 4f 52 42  .pAAXBTAAXpCMORB
  e9f0: 55 46 30 70 0a fe 42 55 46 31 70 99 83 88 6b 00  UF0p..BUF1p...k.
  ea00: 00 00 42 55 46 32 70 01 42 55 46 33 70 4d 42 55  ..BUF2p.BUF3pMBU
  ea10: 46 41 41 58 42 70 0a fb 50 53 4d 49 5b 22 0b b8  FAAXBp..PSMI["..
  ea20: 0b 70 54 41 41 58 41 41 58 42 a4 00 a1 01 a4 11  .pTAAXAAXB......
  ea30: 03 01 00 10 43 38 2f 03 5f 53 42 5f 50 43 49 30  ....C8/._SB_PCI0
  ea40: 49 54 50 4d 08 54 41 41 58 00 5b 80 4d 49 50 54  ITPM.TAAX.[.MIPT
  ea50: 01 53 4d 49 54 01 5b 81 0b 4d 49 50 54 01 50 53  .SMIT.[..MIPT.PS
  ea60: 4d 49 08 08 50 50 49 31 12 04 02 00 00 08 50 50  MI..PPI1......PP
  ea70: 49 32 12 05 03 00 00 00 08 4d 42 55 46 11 03 0a  I2.......MBUF...
  ea80: 04 8c 4d 42 55 46 00 42 55 46 30 8c 4d 42 55 46  ..MBUF.BUF0.MBUF
  ea90: 01 42 55 46 31 8c 4d 42 55 46 0a 02 42 55 46 32  .BUF1.MBUF..BUF2
  eaa0: 8c 4d 42 55 46 0a 03 42 55 46 33 14 4b 30 5f 44  .MBUF..BUF3.K0_D
  eab0: 53 4d 04 a0 4e 26 93 68 11 13 0a 10 a6 fa dd 3d  SM..N&.h.......=
  eac0: 1b 36 b4 4e a4 24 8d 10 08 9d 16 53 08 54 54 54  .6.N.$.....S.TTT
  ead0: 30 00 70 99 6a 00 54 54 54 30 a0 0c 93 54 54 54  0.p.j.TTT0...TTT
  eae0: 30 00 a4 11 03 01 7f a1 4a 23 a0 0d 93 54 54 54  0.......J#...TTT
  eaf0: 30 01 a4 0d 31 2e 30 00 a1 49 22 a0 44 05 93 54  0...1.0..I".D..T
  eb00: 54 54 30 0a 02 70 41 41 58 42 54 41 41 58 70 43  TT0..pAAXBTAAXpC
  eb10: 4d 52 51 42 55 46 30 70 0a f0 42 55 46 31 70 99  MRQBUF0p..BUF1p.
  eb20: 83 88 6b 00 00 00 42 55 46 32 70 01 42 55 46 33  ..k...BUF2p.BUF3
  eb30: 70 4d 42 55 46 41 41 58 42 70 0a fb 50 53 4d 49  pMBUFAAXBp..PSMI
  eb40: 5b 22 0b e8 03 70 54 41 41 58 41 41 58 42 a4 00  ["...pTAAXAAXB..
  eb50: a1 41 1d a0 42 07 93 54 54 54 30 0a 03 70 41 41  .A..B..TTT0..pAA
  eb60: 58 42 54 41 41 58 70 43 4d 52 51 42 55 46 30 70  XBTAAXpCMRQBUF0p
  eb70: 0a 0f 42 55 46 31 70 00 42 55 46 32 70 00 42 55  ..BUF1p.BUF2p.BU
  eb80: 46 33 70 4d 42 55 46 41 41 58 42 70 0a fb 50 53  F3pMBUFAAXBp..PS
  eb90: 4d 49 5b 22 0b e8 03 70 41 41 58 42 4d 42 55 46  MI["...pAAXBMBUF
  eba0: 70 42 55 46 32 63 70 00 88 50 50 49 31 00 00 70  pBUF2cp..PPI1..p
  ebb0: 63 88 50 50 49 31 01 00 70 54 41 41 58 41 41 58  c.PPI1..pTAAXAAX
  ebc0: 42 a4 50 50 49 31 a1 4b 15 a0 0b 93 54 54 54 30  B.PPI1.K....TTT0
  ebd0: 0a 04 a4 0a 02 a1 4c 14 a0 4a 13 93 54 54 54 30  ......L..J..TTT0
  ebe0: 0a 05 70 41 41 58 42 54 41 41 58 70 43 4d 52 51  ..pAAXBTAAXpCMRQ
  ebf0: 42 55 46 30 70 0a f0 42 55 46 31 70 00 42 55 46  BUF0p..BUF1p.BUF
  ec00: 32 70 00 42 55 46 33 70 4d 42 55 46 41 41 58 42  2p.BUF3pMBUFAAXB
  ec10: 70 0a fb 50 53 4d 49 5b 22 0b e8 03 70 41 41 58  p..PSMI["...pAAX
  ec20: 42 4d 42 55 46 7a 42 55 46 32 0a 04 63 70 43 4d  BMBUFzBUF2..cpCM
  ec30: 45 52 42 55 46 30 70 0a ff 42 55 46 31 70 00 42  ERBUF0p..BUF1p.B
  ec40: 55 46 32 70 00 42 55 46 33 70 4d 42 55 46 41 41  UF2p.BUF3pMBUFAA
  ec50: 58 42 70 0a fb 50 53 4d 49 5b 22 0b e8 03 70 41  XBp..PSMI["...pA
  ec60: 41 58 42 4d 42 55 46 70 42 55 46 32 66 72 43 4d  AXBMBUFpBUF2frCM
  ec70: 45 52 01 64 70 64 42 55 46 30 70 0a ff 42 55 46  ER.dpdBUF0p..BUF
  ec80: 31 70 00 42 55 46 32 70 00 42 55 46 33 70 4d 42  1p.BUF2p.BUF3pMB
  ec90: 55 46 41 41 58 42 70 0a fb 50 53 4d 49 5b 22 0b  UFAAXBp..PSMI[".
  eca0: e8 03 70 41 41 58 42 4d 42 55 46 70 42 55 46 32  ..pAAXBMBUFpBUF2
  ecb0: 67 77 67 0b 00 01 62 72 62 66 62 70 00 88 50 50  gwg...brbfbp..PP
  ecc0: 49 32 00 00 70 63 88 50 50 49 32 01 00 a0 14 93  I2..pc.PPI2.....
  ecd0: 62 0b f0 ff 70 0c f0 ff ff ff 88 50 50 49 32 0a  b...p......PPI2.
  ece0: 02 00 a1 22 a0 14 93 62 0b f1 ff 70 0c f1 ff ff  ..."...b...p....
  ecf0: ff 88 50 50 49 32 0a 02 00 a1 0b 70 62 88 50 50  ..PPI2.....pb.PP
  ed00: 49 32 0a 02 00 70 54 41 41 58 41 41 58 42 a4 50  I2...pTAAXAAXB.P
  ed10: 50 49 32 a1 0e a0 0a 93 54 54 54 30 0a 06 a4 00  PI2.....TTT0....
  ed20: a1 01 a1 4f 08 a0 4c 08 93 68 11 13 0a 10 ed 54  ...O..L..h.....T
  ed30: 60 37 13 cc 75 46 90 1c 47 56 d7 f2 d4 5d 08 54  `7..uF..GV...].T
  ed40: 54 54 31 00 70 99 6a 00 54 54 54 31 a0 0c 93 54  TT1.p.j.TTT1...T
  ed50: 54 54 31 00 a4 11 03 01 03 a1 48 05 a0 43 05 93  TT1.......H..C..
  ed60: 54 54 54 31 01 70 41 41 58 42 54 41 41 58 70 43  TTT1.pAAXBTAAXpC
  ed70: 4d 4f 52 42 55 46 30 70 0a fe 42 55 46 31 70 99  MORBUF0p..BUF1p.
  ed80: 83 88 6b 00 00 00 42 55 46 32 70 01 42 55 46 33  ..k...BUF2p.BUF3
  ed90: 70 4d 42 55 46 41 41 58 42 70 0a fb 50 53 4d 49  pMBUFAAXBp..PSMI
  eda0: 5b 22 0b b8 0b 70 54 41 41 58 41 41 58 42 a4 00  ["...pTAAXAAXB..
  edb0: a1 01 a4 11 03 01 00 08 5f 53 30 5f 12 06 04 00  ........_S0_....
  edc0: 00 00 00 a0 11 53 53 31 5f 08 5f 53 31 5f 12 06  .....SS1_._S1_..
  edd0: 04 01 00 00 00 a0 12 53 53 33 5f 08 5f 53 33 5f  .......SS3_._S3_
  ede0: 12 07 04 0a 03 00 00 00 a0 12 53 53 34 5f 08 5f  ..........SS4_._
  edf0: 53 34 5f 12 07 04 0a 04 00 00 00 08 5f 53 35 5f  S4_........._S5_
  ee00: 12 07 04 0a 05 00 00 00 14 36 50 54 53 5f 01 a0  .........6PTS_..
  ee10: 2f 68 5c 2f 04 5f 53 42 5f 50 43 49 30 53 42 52  /h\/._SB_PCI0SBR
  ee20: 47 53 49 4f 53 68 53 50 54 53 68 5c 2f 04 5f 53  GSIOShSPTSh\/._S
  ee30: 42 5f 50 43 49 30 53 42 52 47 53 49 41 53 68 14  B_PCI0SBRGSIASh.
  ee40: 4f 04 57 41 4b 5f 01 5c 2f 04 5f 53 42 5f 50 43  O.WAK_.\/._SB_PC
  ee50: 49 30 53 42 52 47 53 49 4f 57 68 53 57 41 4b 68  I0SBRGSIOWhSWAKh
  ee60: 5c 2f 05 5f 53 42 5f 50 43 49 30 53 42 52 47 41  \/._SB_PCI0SBRGA
  ee70: 53 4f 43 52 44 41 54 68 5c 2f 05 5f 53 42 5f 50  SOCRDATh\/._SB_P
  ee80: 43 49 30 53 42 52 47 41 53 4f 43 49 4e 47 50     CI0SBRGASOCINGP

FACS @ 0xcff88000
  0000: 46 41 43 53 40 00 00 00 00 00 00 00 00 00 00 00  FACS@...........
  0010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0020: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

FACP @ 0xcff70290
  0000: 46 41 43 50 f4 00 00 00 03 b0 31 32 31 30 31 30  FACP......121010
  0010: 46 41 43 50 31 34 33 37 10 12 10 20 4d 53 46 54  FACP1437... MSFT
  0020: 97 00 00 00 00 80 f8 cf 50 04 f7 cf 01 01 09 00  ........P.......
  0030: b0 00 00 00 e1 1e 00 e2 00 08 00 00 00 00 00 00  ................
  0040: 04 08 00 00 00 00 00 00 ff 08 00 00 08 08 00 00  ................
  0050: 20 08 00 00 00 00 00 00 04 02 01 04 08 00 00 e3   ...............
  0060: 65 00 e9 03 00 04 10 00 01 03 0d 00 32 03 00 00  e...........2...
  0070: a5 01 00 00 01 08 00 00 f9 0c 00 00 00 00 00 00  ................
  0080: 06 00 00 00 00 80 f8 cf 00 00 00 00 50 04 f7 cf  ............P...
  0090: 00 00 00 00 01 20 00 00 00 08 00 00 00 00 00 00  ..... ..........
  00a0: 01 20 00 00 00 00 00 00 00 00 00 00 01 10 00 00  . ..............
  00b0: 04 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00d0: 01 20 00 00 08 08 00 00 00 00 00 00 01 20 00 00  . ........... ..
  00e0: 20 08 00 00 00 00 00 00 01 20 00 00 00 00 00 00   ........ ......
  00f0: 00 00 00 00                                      ....

APIC @ 0xcff70390
  0000: 41 50 49 43 7c 00 00 00 01 f5 31 32 31 30 31 30  APIC|.....121010
  0010: 41 50 49 43 31 34 33 37 10 12 10 20 4d 53 46 54  APIC1437... MSFT
  0020: 97 00 00 00 00 00 e0 fe 01 00 00 00 00 08 01 00  ................
  0030: 01 00 00 00 00 08 02 01 01 00 00 00 00 08 03 82  ................
  0040: 00 00 00 00 00 08 04 83 00 00 00 00 00 08 05 84  ................
  0050: 00 00 00 00 00 08 06 85 00 00 00 00 01 0c 02 00  ................
  0060: 00 00 c0 fe 00 00 00 00 02 0a 00 00 02 00 00 00  ................
  0070: 00 00 02 0a 00 09 09 00 00 00 0f 00              ............

MCFG @ 0xcff70410
  0000: 4d 43 46 47 3c 00 00 00 01 61 31 32 31 30 31 30  MCFG<....a121010
  0010: 4f 45 4d 4d 43 46 47 20 10 12 10 20 4d 53 46 54  OEMMCFG ... MSFT
  0020: 97 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0  ................
  0030: 00 00 00 00 00 00 00 ff 00 00 00 00              ............

Wrong checksum for OEMB
OEMB @ 0xcff88040
  0000: 4f 45 4d 42 72 00 00 00 01 b8 31 32 31 30 31 30  OEMBr.....121010
  0010: 4f 45 4d 42 31 34 33 37 10 12 10 20 4d 53 46 54  OEMB1437... MSFT
  0020: 97 00 00 00 0d 05 04 00 00 00 d0 00 00 e0 ff 00  ................
  0030: 00 0d 00 00 00 01 00 00 00 00 d0 00 00 00 10 00  ................
  0040: 87 d0 e9 0e 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0060: 00 00 00 00 f0 00 00 c0 0e 00 00 c0 fe 00 00 00  ................
  0070: 00 00                                            ..

SRAT @ 0xcff7f8a0
  0000: 53 52 41 54 c8 00 00 00 01 eb 41 4d 44 20 20 20  SRAT......AMD   
  0010: 46 41 4d 5f 46 5f 31 30 02 00 00 00 41 4d 44 20  FAM_F_10....AMD 
  0020: 01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
  0030: 00 10 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
  0040: 00 10 00 01 01 00 00 00 00 00 00 00 00 00 00 00  ................
  0050: 01 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00  .(..............
  0060: 00 00 0a 00 00 00 00 00 01 00 00 00 01 00 00 00  ................
  0070: 00 00 00 00 00 00 00 00 01 28 00 00 00 00 00 00  .........(......
  0080: 00 00 10 00 00 00 00 00 00 00 f0 cf 00 00 00 00  ................
  0090: 01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
  00a0: 01 28 00 00 00 00 00 00 00 00 00 00 01 00 00 00  .(..............
  00b0: 00 00 00 30 03 00 00 00 01 00 00 00 01 00 00 00  ...0............
  00c0: 00 00 00 00 00 00 00 00                          ........

HPET @ 0xcff7f970
  0000: 48 50 45 54 38 00 00 00 01 ad 31 32 31 30 31 30  HPET8.....121010
  0010: 4f 45 4d 48 50 45 54 20 10 12 10 20 4d 53 46 54  OEMHPET ... MSFT
  0020: 97 00 00 00 00 83 00 00 00 08 00 00 00 00 d0 fe  ................
  0030: 00 00 00 00 02 14 00 00                          ........

SSDT @ 0xcff7f9b0
  0000: 53 53 44 54 58 04 00 00 01 6e 41 20 4d 20 49 20  SSDTX....nA M I 
  0010: 50 4f 57 45 52 4e 4f 57 01 00 00 00 41 4d 44 20  POWERNOW....AMD 
  0020: 01 00 00 00 10 49 21 5c 2e 5f 50 52 5f 50 30 30  .....I!\._PR_P00
  0030: 31 08 5f 50 43 54 12 2c 02 11 14 0a 11 82 0c 00  1._PCT.,........
  0040: 7f 40 00 00 62 00 01 c0 00 00 00 00 79 00 11 14  .@..b.......y...
  0050: 0a 11 82 0c 00 7f 40 00 00 00 00 00 00 00 00 00  ......@.........
  0060: 00 79 00 08 5f 50 53 53 12 47 08 04 12 20 06 0c  .y.._PSS.G... ..
  0070: b8 0b 00 00 0c f4 79 00 00 0c 04 00 00 00 0c 04  ......y.........
  0080: 00 00 00 0c 00 00 00 00 0c 00 00 00 00 12 20 06  .............. .
  0090: 0c fc 08 00 00 0c d6 56 00 00 0c 04 00 00 00 0c  .......V........
  00a0: 04 00 00 00 0c 01 00 00 00 0c 01 00 00 00 12 20  ............... 
  00b0: 06 0c 08 07 00 00 0c 20 49 00 00 0c 04 00 00 00  ....... I.......
  00c0: 0c 04 00 00 00 0c 02 00 00 00 0c 02 00 00 00 12  ................
  00d0: 20 06 0c 20 03 00 00 0c 5a 1e 00 00 0c 04 00 00   .. ....Z.......
  00e0: 00 0c 04 00 00 00 0c 03 00 00 00 0c 03 00 00 00  ................
  00f0: 08 58 50 53 53 12 43 12 04 12 47 04 08 0c b8 0b  .XPSS.C...G.....
  0100: 00 00 0c f4 79 00 00 0c 04 00 00 00 0c 04 00 00  ....y...........
  0110: 00 11 0b 0a 08 00 00 00 00 00 00 00 00 11 0b 0a  ................
  0120: 08 00 00 00 00 00 00 00 00 11 0b 0a 08 00 00 00  ................
  0130: 00 00 00 00 00 11 0b 0a 08 00 00 00 00 00 00 00  ................
  0140: 00 12 47 04 08 0c fc 08 00 00 0c d6 56 00 00 0c  ..G.........V...
  0150: 04 00 00 00 0c 04 00 00 00 11 0b 0a 08 01 00 00  ................
  0160: 00 00 00 00 00 11 0b 0a 08 00 00 00 00 00 00 00  ................
  0170: 00 11 0b 0a 08 00 00 00 00 00 00 00 00 11 0b 0a  ................
  0180: 08 00 00 00 00 00 00 00 00 12 47 04 08 0c 08 07  ..........G.....
  0190: 00 00 0c 20 49 00 00 0c 04 00 00 00 0c 04 00 00  ... I...........
  01a0: 00 11 0b 0a 08 02 00 00 00 00 00 00 00 11 0b 0a  ................
  01b0: 08 00 00 00 00 00 00 00 00 11 0b 0a 08 00 00 00  ................
  01c0: 00 00 00 00 00 11 0b 0a 08 00 00 00 00 00 00 00  ................
  01d0: 00 12 47 04 08 0c 20 03 00 00 0c 5a 1e 00 00 0c  ..G... ....Z....
  01e0: 04 00 00 00 0c 04 00 00 00 11 0b 0a 08 03 00 00  ................
  01f0: 00 00 00 00 00 11 0b 0a 08 00 00 00 00 00 00 00  ................
  0200: 00 11 0b 0a 08 00 00 00 00 00 00 00 00 11 0b 0a  ................
  0210: 08 00 00 00 00 00 00 00 00 08 5f 50 53 44 12 18  .........._PSD..
  0220: 01 12 15 05 0a 05 0a 00 0c 00 00 00 00 0c fc 00  ................
  0230: 00 00 0c 02 00 00 00 08 5f 50 50 43 0a 00 10 49  ........_PPC...I
  0240: 21 5c 2e 5f 50 52 5f 50 30 30 32 08 5f 50 43 54  !\._PR_P002._PCT
  0250: 12 2c 02 11 14 0a 11 82 0c 00 7f 40 00 00 62 00  .,.........@..b.
  0260: 01 c0 00 00 00 00 79 00 11 14 0a 11 82 0c 00 7f  ......y.........
  0270: 40 00 00 00 00 00 00 00 00 00 00 79 00 08 5f 50  @..........y.._P
  0280: 53 53 12 47 08 04 12 20 06 0c b8 0b 00 00 0c f4  SS.G... ........
  0290: 79 00 00 0c 04 00 00 00 0c 04 00 00 00 0c 00 00  y...............
  02a0: 00 00 0c 00 00 00 00 12 20 06 0c fc 08 00 00 0c  ........ .......
  02b0: d6 56 00 00 0c 04 00 00 00 0c 04 00 00 00 0c 01  .V..............
  02c0: 00 00 00 0c 01 00 00 00 12 20 06 0c 08 07 00 00  ......... ......
  02d0: 0c 20 49 00 00 0c 04 00 00 00 0c 04 00 00 00 0c  . I.............
  02e0: 02 00 00 00 0c 02 00 00 00 12 20 06 0c 20 03 00  .......... .. ..
  02f0: 00 0c 5a 1e 00 00 0c 04 00 00 00 0c 04 00 00 00  ..Z.............
  0300: 0c 03 00 00 00 0c 03 00 00 00 08 58 50 53 53 12  ...........XPSS.
  0310: 43 12 04 12 47 04 08 0c b8 0b 00 00 0c f4 79 00  C...G.........y.
  0320: 00 0c 04 00 00 00 0c 04 00 00 00 11 0b 0a 08 00  ................
  0330: 00 00 00 00 00 00 00 11 0b 0a 08 00 00 00 00 00  ................
  0340: 00 00 00 11 0b 0a 08 00 00 00 00 00 00 00 00 11  ................
  0350: 0b 0a 08 00 00 00 00 00 00 00 00 12 47 04 08 0c  ............G...
  0360: fc 08 00 00 0c d6 56 00 00 0c 04 00 00 00 0c 04  ......V.........
  0370: 00 00 00 11 0b 0a 08 01 00 00 00 00 00 00 00 11  ................
  0380: 0b 0a 08 00 00 00 00 00 00 00 00 11 0b 0a 08 00  ................
  0390: 00 00 00 00 00 00 00 11 0b 0a 08 00 00 00 00 00  ................
  03a0: 00 00 00 12 47 04 08 0c 08 07 00 00 0c 20 49 00  ....G........ I.
  03b0: 00 0c 04 00 00 00 0c 04 00 00 00 11 0b 0a 08 02  ................
  03c0: 00 00 00 00 00 00 00 11 0b 0a 08 00 00 00 00 00  ................
  03d0: 00 00 00 11 0b 0a 08 00 00 00 00 00 00 00 00 11  ................
  03e0: 0b 0a 08 00 00 00 00 00 00 00 00 12 47 04 08 0c  ............G...
  03f0: 20 03 00 00 0c 5a 1e 00 00 0c 04 00 00 00 0c 04   ....Z..........
  0400: 00 00 00 11 0b 0a 08 03 00 00 00 00 00 00 00 11  ................
  0410: 0b 0a 08 00 00 00 00 00 00 00 00 11 0b 0a 08 00  ................
  0420: 00 00 00 00 00 00 00 11 0b 0a 08 00 00 00 00 00  ................
  0430: 00 00 00 08 5f 50 53 44 12 18 01 12 15 05 0a 05  ...._PSD........
  0440: 0a 00 0c 00 00 00 00 0c fc 00 00 00 0c 02 00 00  ................
  0450: 00 08 5f 50 50 43 0a 00                          .._PPC..

XSDT @ 0xcff70100
  0000: 58 53 44 54 5c 00 00 00 01 f8 31 32 31 30 31 30  XSDT\.....121010
  0010: 58 53 44 54 31 34 33 37 10 12 10 20 4d 53 46 54  XSDT1437... MSFT
  0020: 97 00 00 00 90 02 f7 cf 00 00 00 00 90 03 f7 cf  ................
  0030: 00 00 00 00 10 04 f7 cf 00 00 00 00 40 80 f8 cf  ............@...
  0040: 00 00 00 00 a0 f8 f7 cf 00 00 00 00 70 f9 f7 cf  ............p...
  0050: 00 00 00 00 b0 f9 f7 cf 00 00 00 00              ............

FACP @ 0xcff70200
  0000: 46 41 43 50 84 00 00 00 03 83 31 32 31 30 31 30  FACP......121010
  0010: 46 41 43 50 31 34 33 37 10 12 10 20 4d 53 46 54  FACP1437... MSFT
  0020: 97 00 00 00 00 80 f8 cf 50 04 f7 cf 01 01 09 00  ........P.......
  0030: b0 00 00 00 e1 1e 00 e2 00 08 00 00 00 00 00 00  ................
  0040: 04 08 00 00 00 00 00 00 ff 08 00 00 08 08 00 00  ................
  0050: 20 08 00 00 00 00 00 00 04 02 01 04 08 00 00 e3   ...............
  0060: 65 00 e9 03 00 04 10 00 01 03 0d 00 32 03 00 00  e...........2...
  0070: a5 01 00 00 01 08 00 00 f9 0c 00 00 00 00 00 00  ................
  0080: 06 00 00 00                                      ....

Wrong checksum for OEMB!
RSDT @ 0xcff70000
  0000: 52 53 44 54 40 00 00 00 01 b0 31 32 31 30 31 30  RSDT@.....121010
  0010: 52 53 44 54 31 34 33 37 10 12 10 20 4d 53 46 54  RSDT1437... MSFT
  0020: 97 00 00 00 00 02 f7 cf 90 03 f7 cf 10 04 f7 cf  ................
  0030: 40 80 f8 cf a0 f8 f7 cf 70 f9 f7 cf b0 f9 f7 cf  @.......p.......

RSD PTR @ 0xfb570
  0000: 52 53 44 20 50 54 52 20 6e 41 43 50 49 41 4d 02  RSD PTR nACPIAM.
  0010: 00 00 f7 cf 24 00 00 00 00 01 f7 cf 00 00 00 00  ....$...........
  0020: 15 00 00 00                                      ....


--=-=-=
Content-Type: text/plain
Content-Disposition: inline; filename=cpuinfo.txt
Content-Description: /proc/cpuinfo

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 16
model		: 6
model name	: AMD Athlon(tm) II X2 250 Processor
stepping	: 3
microcode	: 0x10000c8
cpu MHz		: 3000.000
cache size	: 1024 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt hw_pstate npt lbrv svm_lock nrip_save
bogomips	: 6026.89
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor	: 1
vendor_id	: AuthenticAMD
cpu family	: 16
model		: 6
model name	: AMD Athlon(tm) II X2 250 Processor
stepping	: 3
microcode	: 0x10000c8
cpu MHz		: 3000.000
cache size	: 1024 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt hw_pstate npt lbrv svm_lock nrip_save
bogomips	: 6026.89
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate


--=-=-=
Content-Type: text/plain
Content-Disposition: inline; filename=lspci.txt
Content-Description: output from lspci -vvv

00:00.0 Host bridge: Advanced Micro Devices [AMD] RS780 Host Bridge Alternate
	Subsystem: ASUSTeK Computer Inc. Device 843e
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [c4] HyperTransport: Slave or Primary Interface
		Command: BaseUnitID=0 UnitCnt=12 MastHost- DefDir- DUL-
		Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
		Revision ID: 3.00
		Link Frequency 0: [b]
		Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 0: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
		Link Frequency 1: 200MHz
		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Error Handling: PFlE- OFlE- PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
		Prefetchable memory behind bridge Upper: 00-00
		Bus Number: 00
	Capabilities: [54] HyperTransport: UnitID Clumping
	Capabilities: [40] HyperTransport: Retry Mode
	Capabilities: [9c] HyperTransport: #1a
	Capabilities: [f8] HyperTransport: #1c

00:01.0 PCI bridge: ASUSTeK Computer Inc. RS880 PCI to PCI bridge (int gfx) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: fe800000-fe9fffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
	Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [44] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [b0] Subsystem: ASUSTeK Computer Inc. Device 843e

00:07.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 3) (prog-if 00 [Normal decode])
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fea00000-feafffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #7, PowerLimit 25.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis- ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -3.5dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4151
	Capabilities: [b0] Subsystem: ASUSTeK Computer Inc. Device 843e
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Capabilities: [110 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Kernel driver in use: pcieport

00:09.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 4) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: feb00000-febfffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #9, PowerLimit 25.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis- ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -3.5dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4159
	Capabilities: [b0] Subsystem: ASUSTeK Computer Inc. Device 843e
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Capabilities: [110 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Kernel driver in use: pcieport

00:0a.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 5) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fdf00000-00000000fdffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #10, PowerLimit 25.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis- ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -3.5dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4161
	Capabilities: [b0] Subsystem: ASUSTeK Computer Inc. Device 843e
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Capabilities: [110 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Kernel driver in use: pcieport

00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA Controller [IDE mode] (rev 40) (prog-if 01 [AHCI 1.0])
	Subsystem: ASUSTeK Computer Inc. Device 8443
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: I/O ports at b000 [size=8]
	Region 1: I/O ports at a000 [size=4]
	Region 2: I/O ports at 9000 [size=8]
	Region 3: I/O ports at 8000 [size=4]
	Region 4: I/O ports at 7000 [size=16]
	Region 5: Memory at fe7ffc00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [70] SATA HBA v1.0 InCfgSpace
	Capabilities: [a4] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ahci

00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller (prog-if 10 [OHCI])
	Subsystem: ASUSTeK Computer Inc. Device 8443
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at fe7fe000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. Device 8443
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at fe7ff800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci_hcd

00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller (prog-if 10 [OHCI])
	Subsystem: ASUSTeK Computer Inc. Device 8443
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at fe7fd000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. Device 8443
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at fe7ff400 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci_hcd

00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 42)
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller (rev 40) (prog-if 8a [Master SecP PriP])
	Subsystem: ASUSTeK Computer Inc. Device 8443
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Interrupt: pin B routed to IRQ 17
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at ff00 [size=16]
	Kernel driver in use: pata_atiixp

00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA) (rev 40)
	Subsystem: ASUSTeK Computer Inc. Device 841b
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fe7f8000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: snd_hda_intel

00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller (rev 40)
	Subsystem: ASUSTeK Computer Inc. Device 8443
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge (rev 40) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=64
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: fff00000-000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2 Controller (prog-if 10 [OHCI])
	Subsystem: ASUSTeK Computer Inc. Device 8443
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at fe7fc000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:16.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller (prog-if 10 [OHCI])
	Subsystem: ASUSTeK Computer Inc. Device 8443
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at fe7f7000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:16.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. Device 8443
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at fe7ff000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci_hcd

00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor HyperTransport Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b-
		Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
		Revision ID: 3.00
		Link Frequency: [b]
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- UCnfE-

00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Address Map
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor DRAM Controller
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Miscellaneous Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [f0] Secure device <?>
	Kernel driver in use: k10temp

00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Link Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

01:05.0 VGA compatible controller: ATI Technologies Inc RS880 [Radeon HD 4250] (prog-if 00 [VGA controller])
	Subsystem: ASUSTeK Computer Inc. Device 843e
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at d0000000 (32-bit, prefetchable) [size=256M]
	Region 1: I/O ports at c000 [size=256]
	Region 2: Memory at fe9f0000 (32-bit, non-prefetchable) [size=64K]
	Region 5: Memory at fe800000 (32-bit, non-prefetchable) [size=1M]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Kernel driver in use: radeon

01:05.1 Audio device: ATI Technologies Inc RS880 Audio Device [Radeon HD 4200]
	Subsystem: ASUSTeK Computer Inc. Device 843e
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 19
	Region 0: Memory at fe9e8000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Kernel driver in use: snd_hda_intel

02:00.0 USB Controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 03) (prog-if 30)
	Subsystem: ASUSTeK Computer Inc. Device 8413
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at feafe000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [70] MSI: Enable- Count=1/8 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [90] MSI-X: Enable+ Count=8 Masked-
		Vector table: BAR=0 offset=00001000
		PBA: BAR=0 offset=00001080
	Capabilities: [a0] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 unlimited
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140 v1] Device Serial Number ff-ff-ff-ff-ff-ff-ff-ff
	Capabilities: [150 v1] #18
	Kernel driver in use: xhci_hcd

03:00.0 IDE interface: VIA Technologies, Inc. PATA IDE Host Controller (prog-if 85 [Master SecO PriO])
	Subsystem: ASUSTeK Computer Inc. Device 838f
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: I/O ports at dc00 [size=8]
	Region 1: I/O ports at d880 [size=4]
	Region 2: I/O ports at d800 [size=8]
	Region 3: I/O ports at d480 [size=4]
	Region 4: I/O ports at d400 [size=16]
	Expansion ROM at febe0000 [disabled] [size=64K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [70] MSI: Enable- Count=1/1 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [90] Express (v1) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <64us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [130 v1] Device Serial Number 00-40-63-ff-ff-63-40-00
	Kernel driver in use: pata_via

04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 06)
	Subsystem: ASUSTeK Computer Inc. Device 8432
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 46
	Region 0: I/O ports at e800 [size=256]
	Region 2: Memory at fdfff000 (64-bit, prefetchable) [size=4K]
	Region 4: Memory at fdff8000 (64-bit, prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4181
	Capabilities: [70] Express (v2) Endpoint, MSI 01
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 4096 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
		Vector table: BAR=4 offset=00000000
		PBA: BAR=4 offset=00000800
	Capabilities: [d0] Vital Product Data
		Unknown small resource type 00, will not decode more.
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [140 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 01-00-00-00-68-4c-e0-00
	Kernel driver in use: r8169


--=-=-=--
