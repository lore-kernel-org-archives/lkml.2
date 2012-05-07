Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab2EGWo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 18:44:26 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:50024 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756814Ab2EGWoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 18:44:21 -0400
MIME-Version: 1.0
Date: Mon, 7 May 2012 15:44:19 -0700
Message-ID: <CADdexAKen1fcZ4Vkbwm=UVKdLai0i_-VCG1jqMDQ5YoytNg95Q@mail.gmail.com>
Subject: [BUG] sync hangs on ext3 filesystem with usb mount on top of dm-crypt
 on top of RAID-1 array
From: Zurk Tech <zurktech@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a RAID-1 array with 2 x 2TB WD caviar greens. I put a luks
crypto layer on the array and created an ext3 filesystem on top of
that. then i added a mount point and mounted a 3TB usb disk on it. i
have sync hanging and when i try to unmount the usb disk i get a :
kernel BUG at /build/buildd-linux-2.6_2.6.32-41squeeze2-amd64-NDo8b7/linux-2.6-2.6.32/debian/build/source_amd64_none/fs/dcache.c:670
Machine is a bog standard debian squeeze with all latest stable updates.
I do the following when it starts up :
mdadm --assemble --scan
g15stats -d
modprobe dm-crypt
cryptsetup -v luksOpen /dev/md0 md0
e2fsck -y /dev/mapper/md0
mount -t ext3 /dev/mapper/md0 /san
mount -t ext3 -o ro /dev/sdd1 /san/usb
Thanks
-Z-


Full dmesg :

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.32-5-amd64 (Debian 2.6.32-41squeeze2)
(dannf@debian.org) (gcc version 4.3.5 (Debian 4.3.5-4) ) #1 SMP Thu
Mar 22 17:26:33 UTC 2012
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.32-5-amd64
root=UUID=8ed65923-038f-4a8c-a34b-00554beeaeb8 ro quiet
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cfe80000 (usable)
[    0.000000]  BIOS-e820: 00000000cfe80000 - 00000000cfe98000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cfe98000 - 00000000cfec0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfec0000 - 00000000cff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000220000000 (usable)
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000
(usable) ==> (reserved)
[    0.000000] last_pfn = 0x220000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000230000000 aka 8960M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000d0000000 - 0000000100000000
(usable) ==> (reserved)
[    0.000000] last_pfn = 0xcfe80 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000cfe80000
[    0.000000]  0000000000 - 00c0000000 page 1G
[    0.000000]  00c0000000 - 00cfe00000 page 2M
[    0.000000]  00cfe00000 - 00cfe80000 page 4k
[    0.000000] kernel direct mapping tables up to cfe80000 @ 10000-13000
[    0.000000] init_memory_mapping: 0000000100000000-0000000220000000
[    0.000000]  0100000000 - 0200000000 page 1G
[    0.000000]  0200000000 - 0220000000 page 2M
[    0.000000] kernel direct mapping tables up to 220000000 @ 12000-14000
[    0.000000] RAMDISK: 3762e000 - 37fefdc7
[    0.000000] ACPI: RSDP 00000000000fb490 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000cfe80100 00054 (v01 081511 XSDT0945
20110815 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000cfe80290 000F4 (v03 081511 FACP0945
20110815 MSFT 00000097)
[    0.000000] ACPI Warning: Optional field Pm2ControlBlock has zero
address or length: 0000000000000000/1 (20090903/tbfadt-557)
[    0.000000] ACPI: DSDT 00000000cfe80460 0D6D6 (v01  A1860 A1860001
00000001 INTL 20060113)
[    0.000000] ACPI: FACS 00000000cfe98000 00040
[    0.000000] ACPI: APIC 00000000cfe80390 0008C (v01 081511 APIC0945
20110815 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000cfe80420 0003C (v01 081511 OEMMCFG
20110815 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000cfe98040 00072 (v01 081511 OEMB0945
20110815 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000cfe8f460 00038 (v01 081511 OEMHPET
20110815 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000cfe8f4a0 008BC (v01 A M I  POWERNOW
00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000220000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000220000000
[    0.000000]   NODE_DATA [0000000000013000 - 000000000001afff]
[    0.000000]   bootmap [000000000001b000 -  000000000005efff] pages 44
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0220000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
[0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==>
[0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 00016d95c4]    TEXT DATA BSS ==>
[0001000000 - 00016d95c4]
[    0.000000]   #3 [003762e000 - 0037fefdc7]          RAMDISK ==>
[003762e000 - 0037fefdc7]
[    0.000000]   #4 [000009f000 - 0000100000]    BIOS reserved ==>
[000009f000 - 0000100000]
[    0.000000]   #5 [00016da000 - 00016da33c]              BRK ==>
[00016da000 - 00016da33c]
[    0.000000]   #6 [0000010000 - 0000012000]          PGTABLE ==>
[0000010000 - 0000012000]
[    0.000000]   #7 [0000012000 - 0000013000]          PGTABLE ==>
[0000012000 - 0000013000]
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000]  [ffffea0000000000-ffffea00077fffff] PMD ->
[ffff880001800000-ffff8800085fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00220000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000cfe80
[    0.000000]     0: 0x00100000 -> 0x00220000
[    0.000000] On node 0 totalpages: 2031119
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 103 pages reserved
[    0.000000]   DMA zone: 3824 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833208 pages, LIFO batch:31
[    0.000000]   Normal zone: 16128 pages used for memmap
[    0.000000]   Normal zone: 1163520 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x86] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x87] disabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cfe80000 - 00000000cfe98000
[    0.000000] PM: Registered nosave memory: 00000000cfe98000 - 00000000cfec0000
[    0.000000] PM: Registered nosave memory: 00000000cfec0000 - 00000000cff00000
[    0.000000] PM: Registered nosave memory: 00000000cff00000 - 00000000ffe00000
[    0.000000] PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at cff00000 (gap:
cff00000:2ff00000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880008800000 s90328
r8192 d24360 u262144
[    0.000000] pcpu-alloc: s90328 r8192 d24360 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 2000552
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-2.6.32-5-amd64
root=UUID=8ed65923-038f-4a8c-a34b-00554beeaeb8 ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 0 size 32 MB
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000024000000
[    0.000000] Memory: 7927908k/8912896k available (3083k kernel code,
788420k absent, 196568k reserved, 2048k data, 592k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0,
CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:472
[    0.000000] Extended CMOS year: 2000
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 3215.065 MHz processor.
[    0.008004] Calibrating delay loop (skipped), value calculated
using timer frequency.. 6430.12 BogoMIPS (lpj=12860240)
[    0.008017] Security Framework initialized
[    0.008020] SELinux:  Disabled at boot.
[    0.008417] Dentry cache hash table entries: 1048576 (order: 11,
8388608 bytes)
[    0.012514] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.013505] Mount-cache hash table entries: 256
[    0.013599] Initializing cgroup subsys ns
[    0.013601] Initializing cgroup subsys cpuacct
[    0.013604] Initializing cgroup subsys devices
[    0.013606] Initializing cgroup subsys freezer
[    0.013607] Initializing cgroup subsys net_cls
[    0.013622] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.013623] CPU: L2 Cache: 512K (64 bytes/line)
[    0.013625] CPU 0/0x0 -> Node 0
[    0.013627] tseg: 0000000000
[    0.013636] CPU: Physical Processor ID: 0
[    0.013637] CPU: Processor Core ID: 0
[    0.013638] mce: CPU supports 6 MCE banks
[    0.013645] using C1E aware idle routine
[    0.013646] Performance Events: AMD PMU driver.
[    0.013649] ... version:                0
[    0.013650] ... bit width:              48
[    0.013651] ... generic registers:      4
[    0.013652] ... value mask:             0000ffffffffffff
[    0.013653] ... max period:             00007fffffffffff
[    0.013654] ... fixed-purpose events:   0
[    0.013655] ... event mask:             000000000000000f
[    0.014162] ACPI: Core revision 20090903
[    0.024055] Setting APIC routing to flat
[    0.024346] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.066045] CPU0: AMD Phenom(tm) II X4 B55 Processor stepping 03
[    0.068001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.012000] Initializing CPU#1
[    0.012000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.012000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.012000] CPU 1/0x1 -> Node 0
[    0.012000] CPU: Physical Processor ID: 0
[    0.012000] CPU: Processor Core ID: 1
[    0.152087] CPU1: AMD Phenom(tm) II X4 B55 Processor stepping 03
[    0.152092] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.156015] System has AMD C1E enabled
[    0.156023] Switch to broadcast mode on CPU1
[    0.156046] Booting processor 2 APIC 0x2 ip 0x6000
[    0.012000] Initializing CPU#2
[    0.012000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.012000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.012000] CPU 2/0x2 -> Node 0
[    0.012000] CPU: Physical Processor ID: 0
[    0.012000] CPU: Processor Core ID: 2
[    0.244020] CPU2: AMD Phenom(tm) II X4 B55 Processor stepping 03
[    0.244025] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.248016] Switch to broadcast mode on CPU2
[    0.248047] Booting processor 3 APIC 0x3 ip 0x6000
[    0.012000] Initializing CPU#3
[    0.012000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.012000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.012000] CPU 3/0x3 -> Node 0
[    0.012000] CPU: Physical Processor ID: 0
[    0.012000] CPU: Processor Core ID: 3
[    0.336057] CPU3: AMD Phenom(tm) II X4 B55 Processor stepping 03
[    0.336061] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.340021] Brought up 4 CPUs
[    0.340022] Total of 4 processors activated (25716.67 BogoMIPS).
[    0.340020] Switch to broadcast mode on CPU3
[    0.342273] CPU0 attaching sched-domain:
[    0.342277]  domain 0: span 0-3 level MC
[    0.342278]   groups: group ffff88000880fbf0 cpus 0 group
ffff88000884fbf0 cpus 1 group ffff88000888fbf0 cpus 2 group
ffff8800088cfbf0 cpus 3
[    0.342286] CPU1 attaching sched-domain:
[    0.342287]  domain 0: span 0-3 level MC
[    0.342288]   groups: group ffff88000884fbf0 cpus 1 group
ffff88000888fbf0 cpus 2 group ffff8800088cfbf0 cpus 3 group
ffff88000880fbf0 cpus 0
[    0.342293] CPU2 attaching sched-domain:
[    0.342294]  domain 0: span 0-3 level MC
[    0.342295]   groups: group ffff88000888fbf0 cpus 2 group
ffff8800088cfbf0 cpus 3 group ffff88000880fbf0 cpus 0 group
ffff88000884fbf0 cpus 1
[    0.342300] CPU3 attaching sched-domain:
[    0.342301]  domain 0: span 0-3 level MC
[    0.342302]   groups: group ffff8800088cfbf0 cpus 3 group
ffff88000880fbf0 cpus 0 group ffff88000884fbf0 cpus 1 group
ffff88000888fbf0 cpus 2
[    0.342373] Switch to broadcast mode on CPU0
[    0.342373] devtmpfs: initialized
[    0.344650] regulator: core version 0.5
[    0.344650] NET: Registered protocol family 16
[    0.344650] node 0 link 0: io port [1000, ffffff]
[    0.344650] TOM: 00000000d0000000 aka 3328M
[    0.344650] Fam 10h mmconf [e0000000, efffffff]
[    0.344650] node 0 link 0: mmio [a0000, bffff]
[    0.344650] node 0 link 0: mmio [d0000000, efffffff] ==> [d0000000, dfffffff]
[    0.344650] node 0 link 0: mmio [f0000000, fe9fffff]
[    0.344650] node 0 link 0: mmio [fea00000, febfffff]
[    0.344650] node 0 link 0: mmio [fec00000, ffdfffff]
[    0.344650] TOM2: 0000000230000000 aka 8960M
[    0.344650] bus: [00,1f] on node 0 link 0
[    0.344650] bus: 00 index 0 io port: [0, ffff]
[    0.344650] bus: 00 index 1 mmio: [a0000, bffff]
[    0.344650] bus: 00 index 2 mmio: [d0000000, dfffffff]
[    0.344650] bus: 00 index 3 mmio: [f0000000, ffffffff]
[    0.344650] bus: 00 index 4 mmio: [230000000, fcffffffff]
[    0.344650] ACPI: bus type pci registered
[    0.344650] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.344650] PCI: Not using MMCONFIG.
[    0.344650] PCI: Using configuration type 1 for base access
[    0.344650] PCI: Using configuration type 1 for extended access
[    0.344650] bio: create slab <bio-0> at 0
[    0.344650] ACPI: EC: Look up EC in DSDT
[    0.346287] ACPI Error (psargs-0359): [ECEN] Namespace lookup
failure, AE_NOT_FOUND
[    0.346291] ACPI Error (psparse-0537): Method parse/execution
failed [\] (Node ffffffff816bc9d0), AE_NOT_FOUND
[    0.346364] ACPI Error (dswload-0781): [PRID] Namespace lookup
failure, AE_ALREADY_EXISTS
[    0.346367] ACPI Exception: AE_ALREADY_EXISTS, During name
lookup/catalog (20090903/psloop-230)
[    0.346370] ACPI Error (psparse-0537): Method parse/execution
failed [\] (Node ffffffff816bc9d0), AE_ALREADY_EXISTS
[    0.346373] ACPI: Marking method \___ as Serialized because of
AE_ALREADY_EXISTS error
[    0.346432] ACPI: Executed 3 blocks of module-level executable AML code
[    0.390329] ACPI: Interpreter enabled
[    0.390331] ACPI: (supports S0 S1 S3 S4 S5)
[    0.390349] ACPI: Using IOAPIC for interrupt routing
[    0.390394] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.394438] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.398968] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.404723] ACPI Warning: Incorrect checksum in table [OEMB] - D6,
should be D1 (20090903/tbutils-314)
[    0.404794] ACPI: No dock devices found.
[    0.404912] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.405005] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.405008] pci 0000:00:04.0: PME# disabled
[    0.405057] pci 0000:00:11.0: reg 10 io port: [0xc000-0xc007]
[    0.405063] pci 0000:00:11.0: reg 14 io port: [0xb000-0xb003]
[    0.405069] pci 0000:00:11.0: reg 18 io port: [0xa000-0xa007]
[    0.405075] pci 0000:00:11.0: reg 1c io port: [0x9000-0x9003]
[    0.405080] pci 0000:00:11.0: reg 20 io port: [0x8000-0x800f]
[    0.405086] pci 0000:00:11.0: reg 24 32bit mmio: [0xfe9ffc00-0xfe9fffff]
[    0.405102] pci 0000:00:11.0: set SATA to AHCI mode
[    0.405141] pci 0000:00:12.0: reg 10 32bit mmio: [0xfe9fe000-0xfe9fefff]
[    0.405189] pci 0000:00:12.1: reg 10 32bit mmio: [0xfe9fd000-0xfe9fdfff]
[    0.405252] pci 0000:00:12.2: reg 10 32bit mmio: [0xfe9ff800-0xfe9ff8ff]
[    0.405298] pci 0000:00:12.2: supports D1 D2
[    0.405299] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.405303] pci 0000:00:12.2: PME# disabled
[    0.405330] pci 0000:00:13.0: reg 10 32bit mmio: [0xfe9fc000-0xfe9fcfff]
[    0.405378] pci 0000:00:13.1: reg 10 32bit mmio: [0xfe9fb000-0xfe9fbfff]
[    0.405442] pci 0000:00:13.2: reg 10 32bit mmio: [0xfe9ff400-0xfe9ff4ff]
[    0.405488] pci 0000:00:13.2: supports D1 D2
[    0.405489] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.405493] pci 0000:00:13.2: PME# disabled
[    0.405594] pci 0000:00:14.1: reg 10 io port: [0x00-0x07]
[    0.405600] pci 0000:00:14.1: reg 14 io port: [0x00-0x03]
[    0.405606] pci 0000:00:14.1: reg 18 io port: [0x00-0x07]
[    0.405611] pci 0000:00:14.1: reg 1c io port: [0x00-0x03]
[    0.405617] pci 0000:00:14.1: reg 20 io port: [0xff00-0xff0f]
[    0.405674] pci 0000:00:14.2: reg 10 64bit mmio: [0xfe9f4000-0xfe9f7fff]
[    0.405712] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.405715] pci 0000:00:14.2: PME# disabled
[    0.405807] pci 0000:00:14.5: reg 10 32bit mmio: [0xfe9fa000-0xfe9fafff]
[    0.405914] pci 0000:01:05.0: reg 10 32bit mmio pref: [0xd0000000-0xdfffffff]
[    0.405917] pci 0000:01:05.0: reg 14 io port: [0xd000-0xd0ff]
[    0.405920] pci 0000:01:05.0: reg 18 32bit mmio: [0xfebe0000-0xfebeffff]
[    0.405925] pci 0000:01:05.0: reg 24 32bit mmio: [0xfea00000-0xfeafffff]
[    0.405935] pci 0000:01:05.0: supports D1 D2
[    0.405971] pci 0000:00:01.0: bridge io port: [0xd000-0xdfff]
[    0.405973] pci 0000:00:01.0: bridge 32bit mmio: [0xfea00000-0xfebfffff]
[    0.405976] pci 0000:00:01.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.406010] pci 0000:02:00.0: reg 10 io port: [0xe800-0xe8ff]
[    0.406023] pci 0000:02:00.0: reg 18 64bit mmio pref: [0xfdfff000-0xfdffffff]
[    0.406032] pci 0000:02:00.0: reg 20 64bit mmio pref: [0xfdff8000-0xfdffbfff]
[    0.406062] pci 0000:02:00.0: supports D1 D2
[    0.406063] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.406067] pci 0000:02:00.0: PME# disabled
[    0.412085] pci 0000:00:04.0: bridge io port: [0xe000-0xefff]
[    0.412090] pci 0000:00:04.0: bridge 64bit mmio pref: [0xfdf00000-0xfdffffff]
[    0.412142] pci 0000:00:14.4: transparent bridge
[    0.412162] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.412329] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.412375] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE4._PRT]
[    0.412445] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.415702] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 *10 12 14 15)
[    0.415784] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 *10 11 12 14 15)
[    0.415866] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 *11 12 14 15)
[    0.415945] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 10 *11 12 14 15)
[    0.416080] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14
15) *0, disabled.
[    0.416161] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 12 14
15) *0, disabled.
[    0.416241] ACPI: PCI Interrupt Link [LNKG] (IRQs *11)
[    0.416319] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14
15) *0, disabled.
[    0.416385] vgaarb: device added:
PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    0.416387] vgaarb: loaded
[    0.416397] PCI: Using ACPI for IRQ routing
[    0.416397] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.416397] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.418154] Switching to clocksource tsc
[    0.418164] pnp: PnP ACPI init
[    0.418164] ACPI: bus type pnp registered
[    0.420106] pnp: PnP ACPI: found 14 devices
[    0.420107] ACPI: ACPI bus type pnp unregistered
[    0.420116] system 00:09: iomem range 0xfec00000-0xfec00fff could
not be reserved
[    0.420118] system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.420122] system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
[    0.420124] system 00:0a: ioport range 0x40b-0x40b has been reserved
[    0.420125] system 00:0a: ioport range 0x4d6-0x4d6 has been reserved
[    0.420127] system 00:0a: ioport range 0xc00-0xc01 has been reserved
[    0.420129] system 00:0a: ioport range 0xc14-0xc14 has been reserved
[    0.420130] system 00:0a: ioport range 0xc50-0xc51 has been reserved
[    0.420132] system 00:0a: ioport range 0xc52-0xc52 has been reserved
[    0.420133] system 00:0a: ioport range 0xc6c-0xc6c has been reserved
[    0.420135] system 00:0a: ioport range 0xc6f-0xc6f has been reserved
[    0.420137] system 00:0a: ioport range 0xcd0-0xcd1 has been reserved
[    0.420138] system 00:0a: ioport range 0xcd2-0xcd3 has been reserved
[    0.420140] system 00:0a: ioport range 0xcd4-0xcd5 has been reserved
[    0.420142] system 00:0a: ioport range 0xcd6-0xcd7 has been reserved
[    0.420144] system 00:0a: ioport range 0xcd8-0xcdf has been reserved
[    0.420145] system 00:0a: ioport range 0xb00-0xb3f has been reserved
[    0.420147] system 00:0a: ioport range 0x800-0x89f has been reserved
[    0.420149] system 00:0a: ioport range 0xb00-0xb0f has been reserved
[    0.420150] system 00:0a: ioport range 0xb20-0xb3f has been reserved
[    0.420152] system 00:0a: ioport range 0x900-0x90f has been reserved
[    0.420154] system 00:0a: ioport range 0x910-0x91f has been reserved
[    0.420156] system 00:0a: ioport range 0xfe00-0xfefe has been reserved
[    0.420158] system 00:0a: iomem range 0xcff00000-0xcfffffff could
not be reserved
[    0.420160] system 00:0a: iomem range 0xffb80000-0xffbfffff has been reserved
[    0.420162] system 00:0a: iomem range 0xfec10000-0xfec1001f has been reserved
[    0.420163] system 00:0a: iomem range 0xfed40000-0xfed44fff has been reserved
[    0.420166] system 00:0b: ioport range 0x230-0x23f has been reserved
[    0.420168] system 00:0b: ioport range 0x290-0x29f has been reserved
[    0.420169] system 00:0b: ioport range 0x300-0x30f has been reserved
[    0.420171] system 00:0b: ioport range 0xa30-0xa3f has been reserved
[    0.420174] system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
[    0.420177] system 00:0d: iomem range 0x0-0x9ffff could not be reserved
[    0.420179] system 00:0d: iomem range 0xc0000-0xcffff could not be reserved
[    0.420180] system 00:0d: iomem range 0xe0000-0xfffff could not be reserved
[    0.420182] system 00:0d: iomem range 0x100000-0xcfefffff could not
be reserved
[    0.420184] system 00:0d: iomem range 0xfec00000-0xffffffff could
not be reserved
[    0.424856] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.424858] pci 0000:00:01.0:   IO window: 0xd000-0xdfff
[    0.424861] pci 0000:00:01.0:   MEM window: 0xfea00000-0xfebfffff
[    0.424863] pci 0000:00:01.0:   PREFETCH window:
0x000000d0000000-0x000000dfffffff
[    0.424866] pci 0000:00:04.0: PCI bridge, secondary bus 0000:02
[    0.424868] pci 0000:00:04.0:   IO window: 0xe000-0xefff
[    0.424870] pci 0000:00:04.0:   MEM window: disabled
[    0.424872] pci 0000:00:04.0:   PREFETCH window:
0x000000fdf00000-0x000000fdffffff
[    0.424874] pci 0000:00:14.4: PCI bridge, secondary bus 0000:03
[    0.424875] pci 0000:00:14.4:   IO window: disabled
[    0.424879] pci 0000:00:14.4:   MEM window: disabled
[    0.424882] pci 0000:00:14.4:   PREFETCH window: disabled
[    0.424893]   alloc irq_desc for 16 on node 0
[    0.424894]   alloc kstat_irqs on node 0
[    0.424898] pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.424900] pci 0000:00:04.0: setting latency timer to 64
[    0.424906] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.424908] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.424910] pci_bus 0000:01: resource 0 io:  [0xd000-0xdfff]
[    0.424911] pci_bus 0000:01: resource 1 mem: [0xfea00000-0xfebfffff]
[    0.424913] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xdfffffff]
[    0.424914] pci_bus 0000:02: resource 0 io:  [0xe000-0xefff]
[    0.424916] pci_bus 0000:02: resource 2 pref mem [0xfdf00000-0xfdffffff]
[    0.424918] pci_bus 0000:03: resource 3 io:  [0x00-0xffff]
[    0.424919] pci_bus 0000:03: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.424936] NET: Registered protocol family 2
[    0.425081] IP route cache hash table entries: 262144 (order: 9,
2097152 bytes)
[    0.425935] TCP established hash table entries: 524288 (order: 11,
8388608 bytes)
[    0.427934] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.428188] TCP: Hash tables configured (established 524288 bind 65536)
[    0.428190] TCP reno registered
[    0.428266] NET: Registered protocol family 1
[    0.557359] pci 0000:01:05.0: Boot video device
[    0.557396] Unpacking initramfs...
[    0.699399] Freeing initrd memory: 9991k freed
[    0.702382] PCI-DMA: Disabling AGP.
[    0.702462] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.702463] PCI-DMA: using GART IOMMU.
[    0.702465] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.704267] audit: initializing netlink socket (disabled)
[    0.704280] type=2000 audit(1335314770.701:1): initialized
[    0.706521] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.707344] VFS: Disk quotas dquot_6.5.2
[    0.707373] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.707420] msgmni has been set to 15503
[    0.707593] alg: No test for stdrng (krng)
[    0.707621] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 253)
[    0.707623] io scheduler noop registered
[    0.707624] io scheduler anticipatory registered
[    0.707625] io scheduler deadline registered
[    0.707657] io scheduler cfq registered (default)
[    0.707770]   alloc irq_desc for 24 on node 0
[    0.707771]   alloc kstat_irqs on node 0
[    0.707777] pcieport 0000:00:04.0: irq 24 for MSI/MSI-X
[    0.707781] pcieport 0000:00:04.0: setting latency timer to 64
[    0.708605] Linux agpgart interface v0.103
[    0.708628] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.708721] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.708934] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.709025] input: Macintosh mouse button emulation as
/devices/virtual/input/input0
[    0.709059] PNP: No PS/2 controller found. Probing ports directly.
[    0.709417] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.709424] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.709505] mice: PS/2 mouse device common for all mice
[    0.709536] rtc_cmos 00:03: RTC can wake from S4
[    0.709559] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.709580] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.709588] cpuidle: using governor ladder
[    0.709590] cpuidle: using governor menu
[    0.709593] No iBFT detected.
[    0.709777] TCP cubic registered
[    0.709838] NET: Registered protocol family 10
[    0.710289] Mobile IPv6
[    0.710291] NET: Registered protocol family 17
[    0.710337] PM: Resume from disk failed.
[    0.710343] registered taskstats version 1
[    0.710595] rtc_cmos 00:03: setting system clock to 2012-04-25
00:46:10 UTC (1335314770)
[    0.710621] Initalizing network drop monitor service
[    0.710640] Freeing unused kernel memory: 592k freed
[    0.710741] Write protecting the kernel read-only data: 4244k
[    0.765266] udev[104]: starting version 164
[    0.798231] usbcore: registered new interface driver usbfs
[    0.798262] usbcore: registered new interface driver hub
[    0.798358] usbcore: registered new device driver usb
[    0.800128] SCSI subsystem initialized
[    0.801125] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.801166]   alloc irq_desc for 17 on node 0
[    0.801167]   alloc kstat_irqs on node 0
[    0.801173] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.801200] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    0.801215] ehci_hcd 0000:00:12.2: new USB bus registered, assigned
bus number 1
[    0.801328] ehci_hcd 0000:00:12.2: debug port 1
[    0.801347] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe9ff800
[    0.811057] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.811083] r8169 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.811134] r8169 0000:02:00.0: setting latency timer to 64
[    0.811139] r8169 0000:02:00.0: (unregistered net_device): unknown
MAC, using family default
[    0.811181]   alloc irq_desc for 25 on node 0
[    0.811182]   alloc kstat_irqs on node 0
[    0.811191] r8169 0000:02:00.0: irq 25 for MSI/MSI-X
[    0.811568] r8169 0000:02:00.0: eth0: RTL8168b/8111b at
0xffffc90000c64000, f4:6d:04:dd:e7:c9, XID 0c900800 IRQ 25
[    0.811710] libata version 3.00 loaded.
[    0.813278] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    0.813294] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.813296] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    0.813298] usb usb1: Product: EHCI Host Controller
[    0.813299] usb usb1: Manufacturer: Linux 2.6.32-5-amd64 ehci_hcd
[    0.813300] usb usb1: SerialNumber: 0000:00:12.2
[    0.813355] usb usb1: configuration #1 chosen from 1 choice
[    0.813372] hub 1-0:1.0: USB hub found
[    0.813377] hub 1-0:1.0: 6 ports detected
[    0.813492] ahci 0000:00:11.0: version 3.0
[    0.813502]   alloc irq_desc for 22 on node 0
[    0.813503]   alloc kstat_irqs on node 0
[    0.813507] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.813599] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 4 ports 3
Gbps 0xf impl SATA mode
[    0.813602] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led
clo pmp pio slum part ccc
[    0.813797] scsi0 : ahci
[    0.813856] scsi1 : ahci
[    0.813894] scsi2 : ahci
[    0.813929] scsi3 : ahci
[    0.813955] ata1: SATA max UDMA/133 abar m1024@0xfe9ffc00 port
0xfe9ffd00 irq 22
[    0.813958] ata2: SATA max UDMA/133 abar m1024@0xfe9ffc00 port
0xfe9ffd80 irq 22
[    0.813961] ata3: SATA max UDMA/133 abar m1024@0xfe9ffc00 port
0xfe9ffe00 irq 22
[    0.813963] ata4: SATA max UDMA/133 abar m1024@0xfe9ffc00 port
0xfe9ffe80 irq 22
[    0.814029]   alloc irq_desc for 19 on node 0
[    0.814030]   alloc kstat_irqs on node 0
[    0.814033] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.814049] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    0.814058] ehci_hcd 0000:00:13.2: new USB bus registered, assigned
bus number 2
[    0.814083] ehci_hcd 0000:00:13.2: debug port 1
[    0.814097] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe9ff400
[    0.825295] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    0.825308] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.825309] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    0.825311] usb usb2: Product: EHCI Host Controller
[    0.825312] usb usb2: Manufacturer: Linux 2.6.32-5-amd64 ehci_hcd
[    0.825313] usb usb2: SerialNumber: 0000:00:13.2
[    0.825355] usb usb2: configuration #1 chosen from 1 choice
[    0.825370] hub 2-0:1.0: USB hub found
[    0.825375] hub 2-0:1.0: 6 ports detected
[    0.825449] pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level,
low) -> IRQ 16
[    0.825466] pata_atiixp 0000:00:14.1: setting latency timer to 64
[    0.825525] scsi4 : pata_atiixp
[    0.825569] scsi5 : pata_atiixp
[    0.826494] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
[    0.826496] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
[    0.898223] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.898306] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.898323] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    0.898331] ohci_hcd 0000:00:12.0: new USB bus registered, assigned
bus number 3
[    0.898352] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe9fe000
[    0.957248] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.957251] usb usb3: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    0.957252] usb usb3: Product: OHCI Host Controller
[    0.957253] usb usb3: Manufacturer: Linux 2.6.32-5-amd64 ohci_hcd
[    0.957254] usb usb3: SerialNumber: 0000:00:12.0
[    0.957298] usb usb3: configuration #1 chosen from 1 choice
[    0.957315] hub 3-0:1.0: USB hub found
[    0.957322] hub 3-0:1.0: 3 ports detected
[    0.957392] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.957402] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    0.957409] ohci_hcd 0000:00:12.1: new USB bus registered, assigned
bus number 4
[    0.957422] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe9fd000
[    1.021238] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.021241] usb usb4: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.021242] usb usb4: Product: OHCI Host Controller
[    1.021243] usb usb4: Manufacturer: Linux 2.6.32-5-amd64 ohci_hcd
[    1.021244] usb usb4: SerialNumber: 0000:00:12.1
[    1.021286] usb usb4: configuration #1 chosen from 1 choice
[    1.021302] hub 4-0:1.0: USB hub found
[    1.021309] hub 4-0:1.0: 3 ports detected
[    1.021378]   alloc irq_desc for 18 on node 0
[    1.021379]   alloc kstat_irqs on node 0
[    1.021383] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.021394] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    1.021400] ohci_hcd 0000:00:13.0: new USB bus registered, assigned
bus number 5
[    1.021419] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe9fc000
[    1.064045] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.064047] usb usb5: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.064049] usb usb5: Product: OHCI Host Controller
[    1.064050] usb usb5: Manufacturer: Linux 2.6.32-5-amd64 ohci_hcd
[    1.064051] usb usb5: SerialNumber: 0000:00:13.0
[    1.064096] usb usb5: configuration #1 chosen from 1 choice
[    1.064114] hub 5-0:1.0: USB hub found
[    1.064120] hub 5-0:1.0: 3 ports detected
[    1.064210] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.064220] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    1.064226] ohci_hcd 0000:00:13.1: new USB bus registered, assigned
bus number 6
[    1.064240] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe9fb000
[    1.124035] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.124037] usb usb6: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.124038] usb usb6: Product: OHCI Host Controller
[    1.124040] usb usb6: Manufacturer: Linux 2.6.32-5-amd64 ohci_hcd
[    1.124041] usb usb6: SerialNumber: 0000:00:13.1
[    1.124087] usb usb6: configuration #1 chosen from 1 choice
[    1.124102] hub 6-0:1.0: USB hub found
[    1.124109] hub 6-0:1.0: 3 ports detected
[    1.124196] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.124207] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    1.124213] ohci_hcd 0000:00:14.5: new USB bus registered, assigned
bus number 7
[    1.124228] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe9fa000
[    1.184036] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    1.184038] usb usb7: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.184040] usb usb7: Product: OHCI Host Controller
[    1.184041] usb usb7: Manufacturer: Linux 2.6.32-5-amd64 ohci_hcd
[    1.184042] usb usb7: SerialNumber: 0000:00:14.5
[    1.184088] usb usb7: configuration #1 chosen from 1 choice
[    1.184104] hub 7-0:1.0: USB hub found
[    1.184111] hub 7-0:1.0: 2 ports detected
[    1.228275] usb 1-2: new high speed USB device using ehci_hcd and address 3
[    1.256056] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.256530] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.256920] ata1.00: ATA-5: Emphase SFM20I-8G, rs1.a000, max UDMA/33
[    1.256923] ata1.00: 15727824 sectors, multi 0: LBA
[    1.256929] ata1.00: applying bridge limits
[    1.257375] ata1.00: configured for UDMA/33
[    1.260283] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.260952] ata3.00: ATAPI: TSSTcorpDVD-ROM TS-H353B, D200, max UDMA/33
[    1.262162] ata3.00: configured for UDMA/33
[    1.262250] ata4.00: ATA-8: WDC WD20EADS-00R6B0, 01.00A01, max UDMA/133
[    1.262252] ata4.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[    1.268056] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.268292] ata4.00: configured for UDMA/133
[    1.272870] scsi 0:0:0:0: Direct-Access     ATA      Emphase
SFM20I-8 rs1. PQ: 0 ANSI: 5
[    1.273149] ata2.00: ATA-8: WDC WD20EADS-00R6B0, 01.00A01, max UDMA/133
[    1.273151] ata2.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[    1.278267] ata2.00: configured for UDMA/133
[    1.292125] scsi 1:0:0:0: Direct-Access     ATA      WDC
WD20EADS-00R 01.0 PQ: 0 ANSI: 5
[    1.293356] scsi 2:0:0:0: CD-ROM            TSSTcorp DVD-ROM
TS-H353B D200 PQ: 0 ANSI: 5
[    1.293509] scsi 3:0:0:0: Direct-Access     ATA      WDC
WD20EADS-00R 01.0 PQ: 0 ANSI: 5
[    1.462552] sd 0:0:0:0: [sda] 15727824 512-byte logical blocks:
(8.05 GB/7.49 GiB)
[    1.462600] sd 1:0:0:0: [sdb] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    1.462607] sd 3:0:0:0: [sdc] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    1.462636] sd 0:0:0:0: [sda] Write Protect is off
[    1.462638] sd 1:0:0:0: [sdb] Write Protect is off
[    1.462640] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.462642] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.462643] sd 3:0:0:0: [sdc] Write Protect is off
[    1.462645] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.462654] sd 1:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.462658] sd 0:0:0:0: [sda] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[    1.462658] sd 3:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.462799]  sdb:
[    1.462816]  sdc:
[    1.462946]  sda: sda1
[    1.464291] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.482652]  unknown partition table
[    1.482845] sd 3:0:0:0: [sdc] Attached SCSI disk
[    1.491858]  unknown partition table
[    1.492053] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.495072] sr0: scsi3-mmc drive: 62x/62x cd/rw xa/form2 cdda tray
[    1.495074] Uniform CD-ROM driver Revision: 3.20
[    1.495134] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    1.497283] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.497304] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    1.497325] sr 2:0:0:0: Attached scsi generic sg2 type 5
[    1.497342] sd 3:0:0:0: Attached scsi generic sg3 type 0
[    1.926452] usb 1-2: New USB device found, idVendor=1058, idProduct=1130
[    1.926455] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.926456] usb 1-2: Product: My Book 1130
[    1.926458] usb 1-2: Manufacturer: Western Digital
[    1.926459] usb 1-2: SerialNumber: 574341575A30323630353336
[    1.926516] usb 1-2: configuration #1 chosen from 1 choice
[    2.188764] usb 3-1: new full speed USB device using ohci_hcd and address 2
[    2.341818] udev[439]: starting version 164
[    2.355987] usb 3-1: New USB device found, idVendor=046d, idProduct=c223
[    2.355989] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.355991] usb 3-1: Product: Logitech G15 Keyboard
[    2.355993] usb 3-1: Manufacturer: Logitech
[    2.356054] usb 3-1: configuration #1 chosen from 1 choice
[    2.358020] hub 3-1:1.0: USB hub found
[    2.359960] hub 3-1:1.0: 4 ports detected
[    2.595973] processor LNXCPU:00: registered as cooling_device0
[    2.596191] processor LNXCPU:01: registered as cooling_device1
[    2.596384] processor LNXCPU:02: registered as cooling_device2
[    2.596574] processor LNXCPU:03: registered as cooling_device3
[    2.597487] ACPI: WMI: Mapper loaded
[    2.604182] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.608040] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    2.623215] input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    2.623220] ACPI: Power Button [PWRB]
[    2.623257] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    2.623259] ACPI: Power Button [PWRF]
[    2.648893] usb 3-1.1: new low speed USB device using ohci_hcd and address 3
[    2.701828] EDAC MC: Ver: 2.1.0 Mar 22 2012
[    2.704423] EDAC amd64_edac:  Ver: 3.2.0 Mar 22 2012
[    2.704477] EDAC amd64: This node reports that Memory ECC is
currently disabled, set F3x44[22] (0000:00:18.3).
[    2.704483] EDAC amd64: ECC disabled in the BIOS or no ECC
capability, module will not load.
[    2.704484]  Either enable ECC checking or force module loading by
setting 'ecc_enable_override'.
[    2.704485]  (Note that use of the override may cause unknown side effects.)
[    2.704497] amd64_edac: probe of 0000:00:18.2 failed with error -22
[    2.751781] parport_pc 00:06: reported by Plug and Play ACPI
[    2.751831] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    2.761903] usb 3-1.1: New USB device found, idVendor=046d, idProduct=c221
[    2.761905] usb 3-1.1: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[    2.761907] usb 3-1.1: Product: Logitech Gaming Keyboard
[    2.761908] usb 3-1.1: Manufacturer: Logitech
[    2.761968] usb 3-1.1: configuration #1 chosen from 1 choice
[    2.781276] ACPI: I/O resource piix4_smbus [0xb00-0xb07] conflicts
with ACPI region SOR1 [0xb00-0xb0f]
[    2.781312] ACPI: If an ACPI driver is available for this device,
you should use it instead of the native driver
[    2.837853] usb 3-1.4: new full speed USB device using ohci_hcd and address 4
[    2.848578] usbcore: registered new interface driver hiddev
[    2.852989] input: Logitech Logitech Gaming Keyboard as
/devices/pci0000:00/0000:00:12.0/usb3/3-1/3-1.1/3-1.1:1.0/input/input3
[    2.853033] generic-usb 0003:046D:C221.0001: input,hidraw0: USB HID
v1.10 Keyboard [Logitech Logitech Gaming Keyboard] on
usb-0000:00:12.0-1.1/input0
[    2.863918] input: Logitech Logitech Gaming Keyboard as
/devices/pci0000:00/0000:00:12.0/usb3/3-1/3-1.1/3-1.1:1.1/input/input4
[    2.863982] generic-usb 0003:046D:C221.0002: input,hiddev0,hidraw1:
USB HID v1.10 Device [Logitech Logitech Gaming Keyboard] on
usb-0000:00:12.0-1.1/input1
[    2.864005] usbcore: registered new interface driver usbhid
[    2.864006] usbhid: v2.6:USB HID core driver
[    2.887008] Initializing USB Mass Storage driver...
[    2.887106] scsi6 : SCSI emulation for USB Mass Storage devices
[    2.887168] usb-storage: device found at 3
[    2.887169] usb-storage: waiting for device to settle before scanning
[    2.887183] usbcore: registered new interface driver usb-storage
[    2.887184] USB Mass Storage support registered.
[    2.902394] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    2.925404] [drm] Initialized drm 1.1.0 20060810
[    2.953821] usb 3-1.4: New USB device found, idVendor=046d, idProduct=c222
[    2.953823] usb 3-1.4: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[    2.953825] usb 3-1.4: Product: G15 Keyboard
[    2.953826] usb 3-1.4: Manufacturer: G15 Keyboard
[    2.953877] usb 3-1.4: configuration #1 chosen from 1 choice
[    2.963919] input: G15 Keyboard G15 Keyboard as
/devices/pci0000:00/0000:00:12.0/usb3/3-1/3-1.4/3-1.4:1.0/input/input6
[    2.963987] generic-usb 0003:046D:C222.0003: input,hiddev1,hidraw2:
USB HID v1.11 Keypad [G15 Keyboard G15 Keyboard] on
usb-0000:00:12.0-1.4/input0
[    3.104648] [drm] radeon kernel modesetting enabled.
[    3.104727] radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.104731] radeon 0000:01:05.0: setting latency timer to 64
[    3.105965] [drm] radeon: Initializing kernel modesetting.
[    3.106097] [drm] register mmio base: 0xFEBE0000
[    3.106098] [drm] register mmio size: 65536
[    3.110102] ATOM BIOS: B27722_RS780C
[    3.110111] [drm] Clocks initialized !
[    3.112240] [drm] Detected VRAM RAM=256M, BAR=256M
[    3.112243] [drm] RAM width 32bits DDR
[    3.112339] [TTM] Zone  kernel: Available graphics memory: 3969246 kiB.
[    3.112340] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[    3.112353] [drm] radeon: 256M of VRAM memory ready
[    3.112354] [drm] radeon: 512M of GTT memory ready.
[    3.112383] [drm] radeon: irq initialized.
[    3.112385] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    3.112749] [drm] Loading RS780 Microcode
[    3.112751] platform radeon_cp.0: firmware: requesting radeon/RS780_pfp.bin
[    3.127109] r600_cp: Failed to load firmware "radeon/RS780_pfp.bin"
[    3.127148] [drm:r600_startup] *ERROR* Failed to load firmware!
[    3.127179] radeon 0000:01:05.0: disabling GPU acceleration
[    3.127224] radeon 0000:01:05.0: ffff88021c15d000 unpin not necessary
[    3.127225] radeon 0000:01:05.0: ffff88021c15d000 unpin not necessary
[    3.127236] [drm] Enabling audio support
[    3.127322] [drm] Radeon Display Connectors
[    3.127323] [drm] Connector 0:
[    3.127324] [drm]   VGA
[    3.127326] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48
0x7e4c 0x7e4c
[    3.127327] [drm]   Encoders:
[    3.127328] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    3.127329] [drm] Connector 1:
[    3.127330] [drm]   DVI-D
[    3.127330] [drm]   HPD1
[    3.127332] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58
0x7e5c 0x7e5c
[    3.127333] [drm]   Encoders:
[    3.127334] [drm]     DFP3: INTERNAL_KLDSCP_LVTMA
[    3.336029] No connectors reported connected with modes
[    3.336035] [drm] Initialized radeon 2.0.0 20080528 for
0000:01:05.0 on minor 0
[    3.421143] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level,
low) -> IRQ 16
[    3.514316] hda_codec: ALC887: BIOS auto-probing.
[    3.515792] input: HDA Digital PCBeep as
/devices/pci0000:00/0000:00:14.2/input/input7
[    3.592560] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.594206] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.595851] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.597476] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.599079] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.600725] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.602370] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.603995] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.605641] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.607265] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.608953] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.610577] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.612201] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.613847] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.615471] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.617138] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.618762] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.620407] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.622032] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.623657] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.625324] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.626948] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.628572] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.630197] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.631821] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.633468] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.635092] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.636737] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.638382] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.640007] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.641674] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.643298] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.644945] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.646568] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.648192] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    3.649880] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    6.808225] loop: module loaded
[    6.835716] device-mapper: uevent: version 1.0.3
[    6.835816] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01)
initialised: dm-devel@redhat.com
[    7.340598] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.342042] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.343491] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.344925] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.346353] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.347784] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.349239] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.350682] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.352131] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.353615] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.355086] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.356543] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.357940] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.359356] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.360794] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.362209] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.363626] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.365064] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.366500] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.367916] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.369675] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.371112] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.372571] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.373989] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.375425] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.376881] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.378302] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.379739] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.381169] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.382609] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.384043] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.385482] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.386912] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.388349] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.389766] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.391182] hda_codec: num_steps = 0 for NID=0xc (ctl = Front
Playback Volume)
[    7.430120] fuse init (API version 7.13)
[    7.683619] input: ACPI Virtual Keyboard Device as
/devices/virtual/input/input8
[    7.739824] RPC: Registered udp transport module.
[    7.739825] RPC: Registered tcp transport module.
[    7.739827] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    7.851263] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    7.884961] usb-storage: device scan complete
[    7.885676] scsi 6:0:0:0: Direct-Access     WD       My Book 1130
  1012 PQ: 0 ANSI: 6
[    7.886424] scsi 6:0:0:1: Enclosure         WD       SES Device
  1012 PQ: 0 ANSI: 6
[    7.886717] sd 6:0:0:0: Attached scsi generic sg4 type 0
[    7.886790] scsi 6:0:0:1: Attached scsi generic sg5 type 13
[    7.888163] sd 6:0:0:0: [sdd] 732558336 4096-byte logical blocks:
(3.00 TB/2.72 TiB)
[    7.888659] sd 6:0:0:0: [sdd] Write Protect is off
[    7.888660] sd 6:0:0:0: [sdd] Mode Sense: 47 00 10 08
[    7.888662] sd 6:0:0:0: [sdd] Assuming drive cache: write through
[    7.889283] sd 6:0:0:0: [sdd] 732558336 4096-byte logical blocks:
(3.00 TB/2.72 TiB)
[    7.889791] sd 6:0:0:0: [sdd] Assuming drive cache: write through
[    7.889824]  sdd:
[    7.906146] svc: failed to register lockdv1 RPC service (errno 97).
[    7.906762] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state
recovery directory
[    7.909397] NFSD: starting 90-second grace period
[    8.587441]  sdd1
[    8.588161] sd 6:0:0:0: [sdd] 732558336 4096-byte logical blocks:
(3.00 TB/2.72 TiB)
[    8.588659] sd 6:0:0:0: [sdd] Assuming drive cache: write through
[    8.588693] sd 6:0:0:0: [sdd] Attached SCSI disk
[    8.728989] ses 6:0:0:1: Attached Enclosure device
[    9.621640] r8169 0000:02:00.0: eth0: link down
[    9.621645] r8169 0000:02:00.0: eth0: link down
[    9.622368] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   10.161156] Bluetooth: Core ver 2.15
[   10.161287] NET: Registered protocol family 31
[   10.161289] Bluetooth: HCI device and connection manager initialized
[   10.161292] Bluetooth: HCI socket layer initialized
[   10.224474] Bluetooth: L2CAP ver 2.14
[   10.224475] Bluetooth: L2CAP socket layer initialized
[   10.236876] Bluetooth: RFCOMM TTY layer initialized
[   10.236879] Bluetooth: RFCOMM socket layer initialized
[   10.236880] Bluetooth: RFCOMM ver 1.11
[   10.252313] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   10.252314] Bluetooth: BNEP filters: protocol multicast
[   10.270957] Bridge firewalling registered
[   10.382822] Bluetooth: SCO (Voice Link) ver 0.6
[   10.382824] Bluetooth: SCO socket layer initialized
[   10.891341] lp0: using parport0 (interrupt-driven).
[   11.025363] ppdev: user-space parallel port driver
[   12.940803] input: G15 Extra Keys as /devices/virtual/input/input9
[   13.395330] r8169 0000:02:00.0: eth0: link up
[   13.396150] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   15.725980] powernow-k8: Found 1 AMD Phenom(tm) II X4 B55 Processor
processors (4 cpu cores) (version 2.20.00)
[   15.726048] powernow-k8:    0 : pstate 0 (3200 MHz)
[   15.726049] powernow-k8:    1 : pstate 1 (2500 MHz)
[   15.726050] powernow-k8:    2 : pstate 2 (2100 MHz)
[   15.726051] powernow-k8:    3 : pstate 3 (800 MHz)
[   21.638342] CPUFREQ: Per core ondemand sysfs interface is
deprecated - ignore_nice_load
[   21.912598] r8169 0000:02:00.0: eth0: link down
[   25.660461] r8169 0000:02:00.0: eth0: link up
[   34.807494] CPU0 attaching NULL sched-domain.
[   34.807505] CPU1 attaching NULL sched-domain.
[   34.807511] CPU2 attaching NULL sched-domain.
[   34.807517] CPU3 attaching NULL sched-domain.
[   34.872249] CPU0 attaching sched-domain:
[   34.872263]  domain 0: span 0-3 level MC
[   34.872270]   groups: group ffff88000880fbf0 cpus 0 group
ffff88000884fbf0 cpus 1 group ffff88000888fbf0 cpus 2 group
ffff8800088cfbf0 cpus 3
[   34.872294] CPU1 attaching sched-domain:
[   34.872299]  domain 0: span 0-3 level MC
[   34.872304]   groups: group ffff88000884fbf0 cpus 1 group
ffff88000888fbf0 cpus 2 group ffff8800088cfbf0 cpus 3 group
ffff88000880fbf0 cpus 0
[   34.872323] CPU2 attaching sched-domain:
[   34.872328]  domain 0: span 0-3 level MC
[   34.872332]   groups: group ffff88000888fbf0 cpus 2 group
ffff8800088cfbf0 cpus 3 group ffff88000880fbf0 cpus 0 group
ffff88000884fbf0 cpus 1
[   34.872351] CPU3 attaching sched-domain:
[   34.872355]  domain 0: span 0-3 level MC
[   34.872360]   groups: group ffff8800088cfbf0 cpus 3 group
ffff88000880fbf0 cpus 0 group ffff88000884fbf0 cpus 1 group
ffff88000888fbf0 cpus 2
[   37.231566] mdadm: sending ioctl 1261 to a partition!
[   37.231574] mdadm: sending ioctl 1261 to a partition!
[   37.232091] mdadm: sending ioctl 1261 to a partition!
[   37.232096] mdadm: sending ioctl 1261 to a partition!
[   37.232578] mdadm: sending ioctl 1261 to a partition!
[   37.232583] mdadm: sending ioctl 1261 to a partition!
[   37.233091] mdadm: sending ioctl 1261 to a partition!
[   37.233097] mdadm: sending ioctl 1261 to a partition!
[   37.233583] mdadm: sending ioctl 800c0910 to a partition!
[   37.233588] mdadm: sending ioctl 800c0910 to a partition!
[   38.062359] md: md0 stopped.
[   38.063632] md: bind<sdc>
[   38.063789] md: bind<sdb>
[   38.074208] md: raid1 personality registered for level 1
[   38.074612] raid1: raid set md0 active with 2 out of 2 mirrors
[   38.074665] md0: detected capacity change from 0 to 2000398778368
[   38.077792]  md0: unknown partition table
[   49.357989] padlock: VIA PadLock not detected.
[   49.420294] padlock: VIA PadLock Hash Engine not detected.
[   55.128706] kjournald starting.  Commit interval 5 seconds
[   55.180124] EXT3 FS on dm-0, internal journal
[   55.180137] EXT3-fs: mounted filesystem with ordered data mode.
[   61.737998] kjournald starting.  Commit interval 5 seconds
[   61.738015] EXT3-fs: mounted filesystem with ordered data mode.
[623283.373963] kjournald starting.  Commit interval 5 seconds
[623283.376238] EXT3 FS on sdd1, internal journal
[623283.376250] EXT3-fs: mounted filesystem with ordered data mode.
[636653.212508] kjournald starting.  Commit interval 5 seconds
[636653.212523] EXT3-fs: mounted filesystem with ordered data mode.
[662795.327099] kjournald starting.  Commit interval 5 seconds
[662795.329246] EXT3 FS on sdd1, internal journal
[662795.329259] EXT3-fs: mounted filesystem with ordered data mode.
[665813.984389] kjournald starting.  Commit interval 5 seconds
[665813.984410] EXT3-fs: mounted filesystem with ordered data mode.
[976250.653278] md: data-check of RAID array md0
[976250.653285] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[976250.653291] md: using maximum available idle IO bandwidth (but not
more than 200000 KB/sec) for data-check.
[976250.653303] md: using 128k window, over a total of 1953514432 blocks.
[1003328.591959] md: md0: data-check done.
[1103040.744157] INFO: task kjournald:3384 blocked for more than 120 seconds.
[1103040.744179] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1103040.744197] kjournald     D 0000000000000000     0  3384      2 0x00000000
[1103040.744208]  ffffffff814891f0 0000000000000046 0000000000000000
ffff88021ba4ec50
[1103040.744218]  ffff88021e387040 0000000000000000 000000000000f9e0
ffff88021d207fd8
[1103040.744226]  0000000000015780 0000000000015780 ffff88021c248000
ffff88021c2482f8
[1103040.744234] Call Trace:
[1103040.744250]  [<ffffffff81099fe2>] ? delayacct_end+0x74/0x7f
[1103040.744283]  [<ffffffff8110e50e>] ? sync_buffer+0x0/0x40
[1103040.744297]  [<ffffffff812fba0a>] ? io_schedule+0x73/0xb7
[1103040.744309]  [<ffffffff8110e549>] ? sync_buffer+0x3b/0x40
[1103040.744321]  [<ffffffff812fbf17>] ? __wait_on_bit+0x41/0x70
[1103040.744331]  [<ffffffff8110e50e>] ? sync_buffer+0x0/0x40
[1103040.744343]  [<ffffffff812fbfb1>] ? out_of_line_wait_on_bit+0x6b/0x77
[1103040.744355]  [<ffffffff81065058>] ? wake_bit_function+0x0/0x23
[1103040.744373]  [<ffffffffa04ef1d1>] ?
journal_commit_transaction+0x508/0xe2f [jbd]
[1103040.744386]  [<ffffffff8106502a>] ? autoremove_wake_function+0x0/0x2e
[1103040.744400]  [<ffffffff8105a96c>] ? lock_timer_base+0x26/0x4b
[1103040.744415]  [<ffffffffa04f2128>] ? kjournald+0xdf/0x226 [jbd]
[1103040.744426]  [<ffffffff8106502a>] ? autoremove_wake_function+0x0/0x2e
[1103040.744440]  [<ffffffffa04f2049>] ? kjournald+0x0/0x226 [jbd]
[1103040.744451]  [<ffffffff81064d5d>] ? kthread+0x79/0x81
[1103040.744463]  [<ffffffff81011baa>] ? child_rip+0xa/0x20
[1103040.744473]  [<ffffffff81064ce4>] ? kthread+0x0/0x81
[1103040.744483]  [<ffffffff81011ba0>] ? child_rip+0x0/0x20
[1103160.744150] INFO: task kjournald:3384 blocked for more than 120 seconds.
[1103160.744169] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1103160.744188] kjournald     D 0000000000000000     0  3384      2 0x00000000
[1103160.744199]  ffffffff814891f0 0000000000000046 0000000000000000
ffff88021ba4ec50
[1103160.744209]  ffff88021e387040 0000000000000000 000000000000f9e0
ffff88021d207fd8
[1103160.744217]  0000000000015780 0000000000015780 ffff88021c248000
ffff88021c2482f8
[1103160.744226] Call Trace:
[1103160.744241]  [<ffffffff81099fe2>] ? delayacct_end+0x74/0x7f
[1103160.744252]  [<ffffffff8110e50e>] ? sync_buffer+0x0/0x40
[1103160.744279]  [<ffffffff812fba0a>] ? io_schedule+0x73/0xb7
[1103160.744292]  [<ffffffff8110e549>] ? sync_buffer+0x3b/0x40
[1103160.744303]  [<ffffffff812fbf17>] ? __wait_on_bit+0x41/0x70
[1103160.744315]  [<ffffffff8110e50e>] ? sync_buffer+0x0/0x40
[1103160.744326]  [<ffffffff812fbfb1>] ? out_of_line_wait_on_bit+0x6b/0x77
[1103160.744338]  [<ffffffff81065058>] ? wake_bit_function+0x0/0x23
[1103160.744356]  [<ffffffffa04ef1d1>] ?
journal_commit_transaction+0x508/0xe2f [jbd]
[1103160.744368]  [<ffffffff8106502a>] ? autoremove_wake_function+0x0/0x2e
[1103160.744382]  [<ffffffff8105a96c>] ? lock_timer_base+0x26/0x4b
[1103160.744397]  [<ffffffffa04f2128>] ? kjournald+0xdf/0x226 [jbd]
[1103160.744408]  [<ffffffff8106502a>] ? autoremove_wake_function+0x0/0x2e
[1103160.744422]  [<ffffffffa04f2049>] ? kjournald+0x0/0x226 [jbd]
[1103160.744432]  [<ffffffff81064d5d>] ? kthread+0x79/0x81
[1103160.744445]  [<ffffffff81011baa>] ? child_rip+0xa/0x20
[1103160.744455]  [<ffffffff81064ce4>] ? kthread+0x0/0x81
[1103160.744465]  [<ffffffff81011ba0>] ? child_rip+0x0/0x20
[1103160.744488] INFO: task sync:14802 blocked for more than 120 seconds.
[1103160.744504] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1103160.744523] sync          D 0000000000000000     0 14802  14763 0x00000000
[1103160.744538]  ffff88021f06f100 0000000000000086 0000000000000000
0000000000000000
[1103160.744557]  0000000000000000 ffff8801b04d3e18 000000000000f9e0
ffff8801b04d3fd8
[1103160.744576]  0000000000015780 0000000000015780 ffff88021d6db880
ffff88021d6dbb78
[1103160.744595] Call Trace:
[1103160.744611]  [<ffffffffa04f1e20>] ? log_wait_commit+0xbf/0x112 [jbd]
[1103160.744622]  [<ffffffff8106502a>] ? autoremove_wake_function+0x0/0x2e
[1103160.744640]  [<ffffffffa050b60e>] ? ext3_sync_fs+0x42/0x4b [ext3]
[1103160.744653]  [<ffffffff8112f185>] ? sync_quota_sb+0x45/0xf6
[1103160.744664]  [<ffffffff8110c251>] ? __sync_filesystem+0x43/0x70
[1103160.744676]  [<ffffffff8110c318>] ? sync_filesystems+0x9a/0xe3
[1103160.744686]  [<ffffffff8110c3a6>] ? sys_sync+0x1c/0x2e
[1103160.744697]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b
[1103280.744128] INFO: task kjournald:3384 blocked for more than 120 seconds.
[1103280.744147] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1103280.744166] kjournald     D 0000000000000000     0  3384      2 0x00000000
[1103280.744176]  ffffffff814891f0 0000000000000046 0000000000000000
ffff88021ba4ec50
[1103280.744186]  ffff88021e387040 0000000000000000 000000000000f9e0
ffff88021d207fd8
[1103280.744195]  0000000000015780 0000000000015780 ffff88021c248000
ffff88021c2482f8
[1103280.744203] Call Trace:
[1103280.744217]  [<ffffffff81099fe2>] ? delayacct_end+0x74/0x7f
[1103280.744228]  [<ffffffff8110e50e>] ? sync_buffer+0x0/0x40
[1103280.744238]  [<ffffffff812fba0a>] ? io_schedule+0x73/0xb7
[1103280.744245]  [<ffffffff8110e549>] ? sync_buffer+0x3b/0x40
[1103280.744253]  [<ffffffff812fbf17>] ? __wait_on_bit+0x41/0x70
[1103280.744278]  [<ffffffff8110e50e>] ? sync_buffer+0x0/0x40
[1103280.744288]  [<ffffffff812fbfb1>] ? out_of_line_wait_on_bit+0x6b/0x77
[1103280.744300]  [<ffffffff81065058>] ? wake_bit_function+0x0/0x23
[1103280.744319]  [<ffffffffa04ef1d1>] ?
journal_commit_transaction+0x508/0xe2f [jbd]
[1103280.744331]  [<ffffffff8106502a>] ? autoremove_wake_function+0x0/0x2e
[1103280.744345]  [<ffffffff8105a96c>] ? lock_timer_base+0x26/0x4b
[1103280.744360]  [<ffffffffa04f2128>] ? kjournald+0xdf/0x226 [jbd]
[1103280.744371]  [<ffffffff8106502a>] ? autoremove_wake_function+0x0/0x2e
[1103280.744385]  [<ffffffffa04f2049>] ? kjournald+0x0/0x226 [jbd]
[1103280.744396]  [<ffffffff81064d5d>] ? kthread+0x79/0x81
[1103280.744408]  [<ffffffff81011baa>] ? child_rip+0xa/0x20
[1103280.744418]  [<ffffffff81064ce4>] ? kthread+0x0/0x81
[1103280.744429]  [<ffffffff81011ba0>] ? child_rip+0x0/0x20
[1103280.744450] INFO: task sync:14802 blocked for more than 120 seconds.
[1103280.744465] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1103280.744485] sync          D 0000000000000000     0 14802  14763 0x00000000
[1103280.744499]  ffff88021f06f100 0000000000000086 0000000000000000
0000000000000000
[1103280.744518]  0000000000000000 ffff8801b04d3e18 000000000000f9e0
ffff8801b04d3fd8
[1103280.744538]  0000000000015780 0000000000015780 ffff88021d6db880
ffff88021d6dbb78
[1103280.744557] Call Trace:
[1103280.744572]  [<ffffffffa04f1e20>] ? log_wait_commit+0xbf/0x112 [jbd]
[1103280.744583]  [<ffffffff8106502a>] ? autoremove_wake_function+0x0/0x2e
[1103280.744602]  [<ffffffffa050b60e>] ? ext3_sync_fs+0x42/0x4b [ext3]
[1103280.744615]  [<ffffffff8112f185>] ? sync_quota_sb+0x45/0xf6
[1103280.744627]  [<ffffffff8110c251>] ? __sync_filesystem+0x43/0x70
[1103280.744638]  [<ffffffff8110c318>] ? sync_filesystems+0x9a/0xe3
[1103280.744648]  [<ffffffff8110c3a6>] ? sys_sync+0x1c/0x2e
[1103280.744659]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b
[1103400.744131] INFO: task kjournald:3384 blocked for more than 120 seconds.
[1103400.744150] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1103400.744168] kjournald     D 0000000000000000     0  3384      2 0x00000000
[1103400.744179]  ffffffff814891f0 0000000000000046 0000000000000000
ffff88021ba4ec50
[1103400.744188]  ffff88021e387040 0000000000000000 000000000000f9e0
ffff88021d207fd8
[1103400.744196]  0000000000015780 0000000000015780 ffff88021c248000
ffff88021c2482f8
[1103400.744204] Call Trace:
[1103400.744218]  [<ffffffff81099fe2>] ? delayacct_end+0x74/0x7f
[1103400.744228]  [<ffffffff8110e50e>] ? sync_buffer+0x0/0x40
[1103400.744237]  [<ffffffff812fba0a>] ? io_schedule+0x73/0xb7
[1103400.744245]  [<ffffffff8110e549>] ? sync_buffer+0x3b/0x40
[1103400.744252]  [<ffffffff812fbf17>] ? __wait_on_bit+0x41/0x70
[1103400.744277]  [<ffffffff8110e50e>] ? sync_buffer+0x0/0x40
[1103400.744284]  [<ffffffff812fbfb1>] ? out_of_line_wait_on_bit+0x6b/0x77
[1103400.744297]  [<ffffffff81065058>] ? wake_bit_function+0x0/0x23
[1103400.744315]  [<ffffffffa04ef1d1>] ?
journal_commit_transaction+0x508/0xe2f [jbd]
[1103400.744326]  [<ffffffff8106502a>] ? autoremove_wake_function+0x0/0x2e
[1103400.744339]  [<ffffffff8105a96c>] ? lock_timer_base+0x26/0x4b
[1103400.744355]  [<ffffffffa04f2128>] ? kjournald+0xdf/0x226 [jbd]
[1103400.744366]  [<ffffffff8106502a>] ? autoremove_wake_function+0x0/0x2e
[1103400.744380]  [<ffffffffa04f2049>] ? kjournald+0x0/0x226 [jbd]
[1103400.744391]  [<ffffffff81064d5d>] ? kthread+0x79/0x81
[1103400.744404]  [<ffffffff81011baa>] ? child_rip+0xa/0x20
[1103400.744414]  [<ffffffff81064ce4>] ? kthread+0x0/0x81
[1103400.744424]  [<ffffffff81011ba0>] ? child_rip+0x0/0x20
[1103400.744447] INFO: task sync:14802 blocked for more than 120 seconds.
[1103400.744461] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1103400.744481] sync          D 0000000000000000     0 14802  14763 0x00000000
[1103400.744495]  ffff88021f06f100 0000000000000086 0000000000000000
0000000000000000
[1103400.744514]  0000000000000000 ffff8801b04d3e18 000000000000f9e0
ffff8801b04d3fd8
[1103400.744532]  0000000000015780 0000000000015780 ffff88021d6db880
ffff88021d6dbb78
[1103400.744550] Call Trace:
[1103400.744564]  [<ffffffffa04f1e20>] ? log_wait_commit+0xbf/0x112 [jbd]
[1103400.744576]  [<ffffffff8106502a>] ? autoremove_wake_function+0x0/0x2e
[1103400.744594]  [<ffffffffa050b60e>] ? ext3_sync_fs+0x42/0x4b [ext3]
[1103400.744608]  [<ffffffff8112f185>] ? sync_quota_sb+0x45/0xf6
[1103400.744620]  [<ffffffff8110c251>] ? __sync_filesystem+0x43/0x70
[1103400.744631]  [<ffffffff8110c318>] ? sync_filesystems+0x9a/0xe3
[1103400.744642]  [<ffffffff8110c3a6>] ? sys_sync+0x1c/0x2e
[1103400.744652]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b
[1103520.744138] INFO: task kjournald:3384 blocked for more than 120 seconds.
[1103520.744157] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1103520.744175] kjournald     D 0000000000000000     0  3384      2 0x00000000
[1103520.744185]  ffffffff814891f0 0000000000000046 0000000000000000
ffff88021ba4ec50
[1103520.744194]  ffff88021e387040 0000000000000000 000000000000f9e0
ffff88021d207fd8
[1103520.744203]  0000000000015780 0000000000015780 ffff88021c248000
ffff88021c2482f8
[1103520.744211] Call Trace:
[1103520.744225]  [<ffffffff81099fe2>] ? delayacct_end+0x74/0x7f
[1103520.744235]  [<ffffffff8110e50e>] ? sync_buffer+0x0/0x40
[1103520.744244]  [<ffffffff812fba0a>] ? io_schedule+0x73/0xb7
[1103520.744252]  [<ffffffff8110e549>] ? sync_buffer+0x3b/0x40
[1103520.744276]  [<ffffffff812fbf17>] ? __wait_on_bit+0x41/0x70
[1103520.744283]  [<ffffffff8110e50e>] ? sync_buffer+0x0/0x40
[1103520.744296]  [<ffffffff812fbfb1>] ? out_of_line_wait_on_bit+0x6b/0x77
[1103520.744308]  [<ffffffff81065058>] ? wake_bit_function+0x0/0x23
[1103520.744326]  [<ffffffffa04ef1d1>] ?
journal_commit_transaction+0x508/0xe2f [jbd]
[1103520.744338]  [<ffffffff8106502a>] ? autoremove_wake_function+0x0/0x2e
[1103520.744351]  [<ffffffff8105a96c>] ? lock_timer_base+0x26/0x4b
[1103520.744366]  [<ffffffffa04f2128>] ? kjournald+0xdf/0x226 [jbd]
[1103520.744377]  [<ffffffff8106502a>] ? autoremove_wake_function+0x0/0x2e
[1103520.744391]  [<ffffffffa04f2049>] ? kjournald+0x0/0x226 [jbd]
[1103520.744402]  [<ffffffff81064d5d>] ? kthread+0x79/0x81
[1103520.744413]  [<ffffffff81011baa>] ? child_rip+0xa/0x20
[1103520.744424]  [<ffffffff81064ce4>] ? kthread+0x0/0x81
[1103520.744434]  [<ffffffff81011ba0>] ? child_rip+0x0/0x20
[1103520.744457] INFO: task sync:14802 blocked for more than 120 seconds.
[1103520.744472] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1103520.744491] sync          D 0000000000000000     0 14802  14763 0x00000000
[1103520.744506]  ffff88021f06f100 0000000000000086 0000000000000000
0000000000000000
[1103520.744524]  0000000000000000 ffff8801b04d3e18 000000000000f9e0
ffff8801b04d3fd8
[1103520.744543]  0000000000015780 0000000000015780 ffff88021d6db880
ffff88021d6dbb78
[1103520.744561] Call Trace:
[1103520.744577]  [<ffffffffa04f1e20>] ? log_wait_commit+0xbf/0x112 [jbd]
[1103520.744588]  [<ffffffff8106502a>] ? autoremove_wake_function+0x0/0x2e
[1103520.744607]  [<ffffffffa050b60e>] ? ext3_sync_fs+0x42/0x4b [ext3]
[1103520.744619]  [<ffffffff8112f185>] ? sync_quota_sb+0x45/0xf6
[1103520.744631]  [<ffffffff8110c251>] ? __sync_filesystem+0x43/0x70
[1103520.744641]  [<ffffffff8110c318>] ? sync_filesystems+0x9a/0xe3
[1103520.744652]  [<ffffffff8110c3a6>] ? sys_sync+0x1c/0x2e
[1103520.744663]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b
[1103640.744134] INFO: task kjournald:3384 blocked for more than 120 seconds.
[1103640.744153] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1103640.744171] kjournald     D 0000000000000000     0  3384      2 0x00000000
[1103640.744181]  ffffffff814891f0 0000000000000046 0000000000000000
ffff88021ba4ec50
[1103640.744191]  ffff88021e387040 0000000000000000 000000000000f9e0
ffff88021d207fd8
[1103640.744199]  0000000000015780 0000000000015780 ffff88021c248000
ffff88021c2482f8
[1103640.744207] Call Trace:
[1103640.744221]  [<ffffffff81099fe2>] ? delayacct_end+0x74/0x7f
[1103640.744232]  [<ffffffff8110e50e>] ? sync_buffer+0x0/0x40
[1103640.744240]  [<ffffffff812fba0a>] ? io_schedule+0x73/0xb7
[1103640.744248]  [<ffffffff8110e549>] ? sync_buffer+0x3b/0x40
[1103640.744273]  [<ffffffff812fbf17>] ? __wait_on_bit+0x41/0x70
[1103640.744281]  [<ffffffff8110e50e>] ? sync_buffer+0x0/0x40
[1103640.744293]  [<ffffffff812fbfb1>] ? out_of_line_wait_on_bit+0x6b/0x77
[1103640.744305]  [<ffffffff81065058>] ? wake_bit_function+0x0/0x23
[1103640.744322]  [<ffffffffa04ef1d1>] ?
journal_commit_transaction+0x508/0xe2f [jbd]
[1103640.744334]  [<ffffffff8106502a>] ? autoremove_wake_function+0x0/0x2e
[1103640.744348]  [<ffffffff8105a96c>] ? lock_timer_base+0x26/0x4b
[1103640.744363]  [<ffffffffa04f2128>] ? kjournald+0xdf/0x226 [jbd]
[1103640.744374]  [<ffffffff8106502a>] ? autoremove_wake_function+0x0/0x2e
[1103640.744388]  [<ffffffffa04f2049>] ? kjournald+0x0/0x226 [jbd]
[1103640.744398]  [<ffffffff81064d5d>] ? kthread+0x79/0x81
[1103640.744410]  [<ffffffff81011baa>] ? child_rip+0xa/0x20
[1103640.744421]  [<ffffffff81064ce4>] ? kthread+0x0/0x81
[1103640.744432]  [<ffffffff81011ba0>] ? child_rip+0x0/0x20
[1114785.933297] BUG: Dentry ffff880012a49780{i=14363f2,n=Tekniske
Manualer} still in use (536870912) [unmount of ext3 sdd1]
[1114785.933357] ------------[ cut here ]------------
[1114785.933371] kernel BUG at
/build/buildd-linux-2.6_2.6.32-41squeeze2-amd64-NDo8b7/linux-2.6-2.6.32/debian/build/source_amd64_none/fs/dcache.c:670!
[1114785.933395] invalid opcode: 0000 [#1] SMP
[1114785.933410] last sysfs file:
/sys/devices/virtual/block/md0/md/metadata_version
[1114785.935020] CPU 3
[1114785.935030] Modules linked in: ext3 jbd sha256_generic aes_x86_64
aes_generic cbc raid1 md_mod powernow_k8 cpufreq_conservative
cpufreq_userspace cpufreq_stats cpufreq_powersave ppdev lp sco bridge
stp bnep rfcomm l2cap crc16 bluetooth rfkill ses enclosure nfsd lockd
nfs_acl auth_rpcgss sunrpc exportfs binfmt_misc fuse dm_crypt dm_mod
loop snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep
snd_pcm snd_seq snd_timer snd_seq_device radeon uinput ttm
drm_kms_helper snd soundcore drm pcspkr i2c_algo_bit usb_storage
usbhid hid evdev i2c_piix4 i2c_core asus_atk0110 parport_pc parport
k10temp edac_core edac_mce_amd button psmouse shpchp pci_hotplug
snd_page_alloc wmi processor serio_raw ext2 mbcache sg sr_mod cdrom
sd_mod crc_t10dif ata_generic ohci_hcd pata_atiixp ahci libata r8169
mii ehci_hcd scsi_mod usbcore nls_base thermal thermal_sys [last
unloaded: scsi_wait_scan]
[1114785.935323] Pid: 15746, comm: umount Not tainted 2.6.32-5-amd64
#1 System Product Name
[1114785.935341] RIP: 0010:[<ffffffff810fe56c>]  [<ffffffff810fe56c>]
shrink_dcache_for_umount_subtree+0x195/0x26d
[1114785.935374] RSP: 0018:ffff88012c427e68  EFLAGS: 00010296
[1114785.935387] RAX: 0000000000000083 RBX: ffff880012b4b310 RCX:
00000000000015af
[1114785.935403] RDX: 0000000000000000 RSI: 0000000000000092 RDI:
0000000000000246
[1114785.935420] RBP: ffff880012a49780 R08: 00000000000133ac R09:
000000000000000a
[1114785.935436] R10: 0000000000000000 R11: 0000000100000000 R12:
000000000000002f
[1114785.935452] R13: ffff880012a497e0 R14: 0000000000000000 R15:
0000000000000000
[1114785.935470] FS:  00007f648532e740(0000) GS:ffff8800088c0000(0000)
knlGS:0000000000000000
[1114785.935488] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1114785.935500] CR2: 00007f64849ebdf1 CR3: 000000021ba8b000 CR4:
00000000000006e0
[1114785.935517] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[1114785.935533] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[1114785.935551] Process umount (pid: 15746, threadinfo
ffff88012c426000, task ffff88021c03b170)
[1114785.935568] Stack:
[1114785.935576]  ffff880039f50270 ffff880039f50000 ffffffffa0513800
0000000000000001
[1114785.935595] <0> ffff88021c2f5a00 ffffffff810fe673
ffff880039f50000 ffffffff810f0e32
[1114785.935619] <0> 0000000000000000 ffff88021eed9040
ffffffffa0517780 ffffffff810f0f35
[1114785.935647] Call Trace:
[1114785.935663]  [<ffffffff810fe673>] ? shrink_dcache_for_umount+0x2f/0x3d
[1114785.935680]  [<ffffffff810f0e32>] ? generic_shutdown_super+0x19/0xfa
[1114785.935697]  [<ffffffff810f0f35>] ? kill_block_super+0x22/0x3a
[1114785.935713]  [<ffffffff810f1605>] ? deactivate_super+0x60/0x77
[1114785.935729]  [<ffffffff81103f78>] ? sys_umount+0x2dc/0x30b
[1114785.935746]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b
[1114785.935759] Code: 8b 08 48 8b 45 10 48 85 c0 74 04 48 8b 50 40 48
8d 86 70 02 00 00 48 c7 c7 66 58 3c 81 48 89 ee 48 89 04 24 31 c0 e8
78 c9 1f 00 <0f> 0b eb fe 48 8b 5d 28 48 39 dd 75 04 31 db eb 03 f0 ff
0b 48
[1114785.935890] RIP  [<ffffffff810fe56c>]
shrink_dcache_for_umount_subtree+0x195/0x26d
[1114785.935913]  RSP <ffff88012c427e68>
[1114785.936166] ---[ end trace 1179c91d83ddbfb3 ]---

cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 16
model           : 4
model name      : AMD Phenom(tm) II X4 B55 Processor
stepping        : 3
cpu MHz         : 800.000
cache size      : 512 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 4
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good
nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit
wdt nodeid_msr
bogomips        : 6430.12
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 16
model           : 4
model name      : AMD Phenom(tm) II X4 B55 Processor
stepping        : 3
cpu MHz         : 800.000
cache size      : 512 KB
physical id     : 0
siblings        : 4
core id         : 1
cpu cores       : 4
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good
nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit
wdt nodeid_msr
bogomips        : 6428.81
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor       : 2
vendor_id       : AuthenticAMD
cpu family      : 16
model           : 4
model name      : AMD Phenom(tm) II X4 B55 Processor
stepping        : 3
cpu MHz         : 800.000
cache size      : 512 KB
physical id     : 0
siblings        : 4
core id         : 2
cpu cores       : 4
apicid          : 2
initial apicid  : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good
nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit
wdt nodeid_msr
bogomips        : 6428.89
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor       : 3
vendor_id       : AuthenticAMD
cpu family      : 16
model           : 4
model name      : AMD Phenom(tm) II X4 B55 Processor
stepping        : 3
cpu MHz         : 800.000
cache size      : 512 KB
physical id     : 0
siblings        : 4
core id         : 3
cpu cores       : 4
apicid          : 3
initial apicid  : 3
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good
nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit
wdt nodeid_msr
bogomips        : 6428.84
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

cat /proc/modules
ext3 106806 2 - Live 0xffffffffa0500000
jbd 37365 1 ext3, Live 0xffffffffa04ed000
sha256_generic 8692 2 - Live 0xffffffffa04df000
aes_x86_64 7340 2 - Live 0xffffffffa04d1000
aes_generic 25714 1 aes_x86_64, Live 0xffffffffa04c5000
cbc 2539 1 - Live 0xffffffffa04bf000
raid1 18431 1 - Live 0xffffffffa04b4000
md_mod 73936 2 raid1, Live 0xffffffffa0497000
powernow_k8 10978 1 - Live 0xffffffffa048f000
cpufreq_conservative 5162 0 - Live 0xffffffffa0488000
cpufreq_userspace 1992 0 - Live 0xffffffffa0482000
cpufreq_stats 2740 0 - Live 0xffffffffa047c000
cpufreq_powersave 902 0 - Live 0xffffffffa0345000
ppdev 5030 0 - Live 0xffffffffa027f000
lp 7462 0 - Live 0xffffffffa021f000
sco 7225 2 - Live 0xffffffffa01fb000
bridge 39678 0 - Live 0xffffffffa0466000
stp 1440 1 bridge, Live 0xffffffffa01b4000
bnep 9443 2 - Live 0xffffffffa01ea000
rfcomm 29645 0 - Live 0xffffffffa045c000
l2cap 24752 4 bnep,rfcomm, Live 0xffffffffa0290000
crc16 1319 1 l2cap, Live 0xffffffffa0198000
bluetooth 41843 6 sco,bnep,rfcomm,l2cap, Live 0xffffffffa044f000
rfkill 13060 2 bluetooth, Live 0xffffffffa018f000
ses 5144 0 - Live 0xffffffffa016d000
enclosure 5519 1 ses, Live 0xffffffffa0141000
nfsd 254974 11 - Live 0xffffffffa0401000
lockd 57651 1 nfsd, Live 0xffffffffa03f0000
nfs_acl 2031 1 nfsd, Live 0xffffffffa0126000
auth_rpcgss 33524 1 nfsd, Live 0xffffffffa033a000
sunrpc 161717 10 nfsd,lockd,nfs_acl,auth_rpcgss, Live 0xffffffffa03b2000
exportfs 3186 1 nfsd, Live 0xffffffffa0116000
binfmt_misc 6447 1 - Live 0xffffffffa010d000
fuse 50972 1 - Live 0xffffffffa03a3000
dm_crypt 10680 1 - Live 0xffffffffa00fa000
dm_mod 53994 3 dm_crypt, Live 0xffffffffa0393000
loop 11799 0 - Live 0xffffffffa0087000
snd_hda_codec_realtek 235698 1 - Live 0xffffffffa0357000
snd_hda_intel 20051 0 - Live 0xffffffffa00d2000
snd_hda_codec 54244 2 snd_hda_codec_realtek,snd_hda_intel, Live
0xffffffffa0347000
snd_hwdep 5380 1 snd_hda_codec, Live 0xffffffffa0044000
snd_pcm 60487 2 snd_hda_intel,snd_hda_codec, Live 0xffffffffa0247000
snd_seq 42913 0 - Live 0xffffffffa0182000
snd_timer 15598 2 snd_pcm,snd_seq, Live 0xffffffffa0077000
snd_seq_device 4493 1 snd_seq, Live 0xffffffffa000e000
radeon 575020 0 - Live 0xffffffffa029f000
uinput 6376 1 - Live 0xffffffffa0298000
ttm 40226 1 radeon, Live 0xffffffffa0284000
drm_kms_helper 20369 1 radeon, Live 0xffffffffa0278000
snd 46542 8 snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_seq,snd_timer,snd_seq_device,
Live 0xffffffffa0261000
soundcore 4598 1 snd, Live 0xffffffffa0259000
drm 142416 3 radeon,ttm,drm_kms_helper, Live 0xffffffffa0222000
pcspkr 1699 0 - Live 0xffffffffa021c000
i2c_algo_bit 4209 1 radeon, Live 0xffffffffa0215000
usb_storage 40233 1 - Live 0xffffffffa0200000
usbhid 33324 0 - Live 0xffffffffa01f0000
hid 63273 1 usbhid, Live 0xffffffffa01d8000
evdev 7352 10 - Live 0xffffffffa01d1000
i2c_piix4 8328 0 - Live 0xffffffffa01c9000
i2c_core 15835 5 radeon,drm_kms_helper,drm,i2c_algo_bit,i2c_piix4,
Live 0xffffffffa01bd000
asus_atk0110 7686 0 - Live 0xffffffffa01b6000
parport_pc 18855 1 - Live 0xffffffffa01aa000
parport 27954 3 ppdev,lp,parport_pc, Live 0xffffffffa019b000
k10temp 2715 0 - Live 0xffffffffa0195000
edac_core 29261 0 - Live 0xffffffffa0178000
edac_mce_amd 6449 0 - Live 0xffffffffa0171000
button 4650 0 - Live 0xffffffffa0169000
psmouse 49937 0 - Live 0xffffffffa0154000
shpchp 26248 0 - Live 0xffffffffa0146000
pci_hotplug 21587 1 shpchp, Live 0xffffffffa0139000
snd_page_alloc 6265 2 snd_hda_intel,snd_pcm, Live 0xffffffffa0131000
wmi 4323 0 - Live 0xffffffffa0129000
processor 29951 1 powernow_k8, Live 0xffffffffa0119000
serio_raw 3752 0 - Live 0xffffffffa0113000
ext2 52937 1 - Live 0xffffffffa00fe000
mbcache 5050 2 ext3,ext2, Live 0xffffffffa00f6000
sg 24085 0 - Live 0xffffffffa00e8000
sr_mod 12602 0 - Live 0xffffffffa00e2000
cdrom 29351 1 sr_mod, Live 0xffffffffa00d8000
sd_mod 29953 6 - Live 0xffffffffa00b4000
crc_t10dif 1276 1 sd_mod, Live 0xffffffffa0047000
ata_generic 3239 0 - Live 0xffffffffa0041000
ohci_hcd 19375 0 - Live 0xffffffffa003a000
pata_atiixp 3505 0 - Live 0xffffffffa0005000
ahci 32886 3 - Live 0xffffffffa00c7000
libata 133824 3 ata_generic,pata_atiixp,ahci, Live 0xffffffffa0091000
r8169 36872 0 - Live 0xffffffffa006b000
mii 3210 1 r8169, Live 0xffffffffa008b000
ehci_hcd 32145 0 - Live 0xffffffffa007d000
scsi_mod 126789 6 ses,usb_storage,sg,sr_mod,sd_mod,libata, Live
0xffffffffa004a000
usbcore 123186 5 usb_storage,usbhid,ohci_hcd,ehci_hcd, Live 0xffffffffa0019000
nls_base 6377 1 usbcore, Live 0xffffffffa0012000
thermal 11674 0 - Live 0xffffffffa0009000
thermal_sys 11942 2 processor,thermal, Live 0xffffffffa0000000

cat /proc/ioports
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0071 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:14.1
  0170-0177 : pata_atiixp
01f0-01f7 : 0000:00:14.1
  01f0-01f7 : pata_atiixp
0230-023f : pnp 00:0b
0290-029f : pnp 00:0b
0300-030f : pnp 00:0b
0376-0376 : 0000:00:14.1
  0376-0376 : pata_atiixp
0378-037a : parport0
03c0-03df : vga+
03f6-03f6 : 0000:00:14.1
  03f6-03f6 : pata_atiixp
03f8-03ff : serial
040b-040b : pnp 00:0a
04d0-04d1 : pnp 00:0a
04d6-04d6 : pnp 00:0a
0800-089f : pnp 00:0a
  0800-0803 : ACPI PM1a_EVT_BLK
  0804-0805 : ACPI PM1a_CNT_BLK
  0808-080b : ACPI PM_TMR
  0810-0815 : ACPI CPU throttle
  0820-0827 : ACPI GPE0_BLK
0900-090f : pnp 00:0a
0910-091f : pnp 00:0a
0a30-0a3f : pnp 00:0b
0b00-0b3f : pnp 00:0a
  0b00-0b0f : pnp 00:0a
  0b20-0b3f : pnp 00:0a
0c00-0c01 : pnp 00:0a
0c14-0c14 : pnp 00:0a
0c50-0c51 : pnp 00:0a
0c52-0c52 : pnp 00:0a
0c6c-0c6c : pnp 00:0a
0c6f-0c6f : pnp 00:0a
0cd0-0cd1 : pnp 00:0a
0cd2-0cd3 : pnp 00:0a
0cd4-0cd5 : pnp 00:0a
0cd6-0cd7 : pnp 00:0a
0cd8-0cdf : pnp 00:0a
0cf8-0cff : PCI conf1
8000-800f : 0000:00:11.0
  8000-800f : ahci
9000-9003 : 0000:00:11.0
  9000-9003 : ahci
a000-a007 : 0000:00:11.0
  a000-a007 : ahci
b000-b003 : 0000:00:11.0
  b000-b003 : ahci
c000-c007 : 0000:00:11.0
  c000-c007 : ahci
d000-dfff : PCI Bus 0000:01
  d000-d0ff : 0000:01:05.0
e000-efff : PCI Bus 0000:02
  e800-e8ff : 0000:02:00.0
    e800-e8ff : r8169
fe00-fefe : pnp 00:0a
ff00-ff0f : 0000:00:14.1
  ff00-ff0f : pata_atiixp

cat /proc/iomem
00000000-0000ffff : reserved
00010000-0009efff : System RAM
0009f000-0009ffff : reserved
000c0000-000ce9ff : Video ROM
000e4000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-cfe7ffff : System RAM
  01000000-01302da4 : Kernel code
  01302da5-0150310f : Kernel data
  015a2000-016d95c3 : Kernel bss
  20000000-23ffffff : GART
cfe80000-cfe97fff : ACPI Tables
cfe98000-cfebffff : ACPI Non-volatile Storage
cfec0000-cfefffff : reserved
cff00000-cfffffff : RAM buffer
d0000000-dfffffff : PCI Bus 0000:01
  d0000000-dfffffff : 0000:01:05.0
e0000000-efffffff : PCI MMCONFIG 0 [00-ff]
  e0000000-efffffff : pnp 00:0c
fdf00000-fdffffff : PCI Bus 0000:02
  fdff8000-fdffbfff : 0000:02:00.0
    fdff8000-fdffbfff : r8169
  fdfff000-fdffffff : 0000:02:00.0
    fdfff000-fdffffff : r8169
fe9f4000-fe9f7fff : 0000:00:14.2
  fe9f4000-fe9f7fff : ICH HD audio
fe9fa000-fe9fafff : 0000:00:14.5
  fe9fa000-fe9fafff : ohci_hcd
fe9fb000-fe9fbfff : 0000:00:13.1
  fe9fb000-fe9fbfff : ohci_hcd
fe9fc000-fe9fcfff : 0000:00:13.0
  fe9fc000-fe9fcfff : ohci_hcd
fe9fd000-fe9fdfff : 0000:00:12.1
  fe9fd000-fe9fdfff : ohci_hcd
fe9fe000-fe9fefff : 0000:00:12.0
  fe9fe000-fe9fefff : ohci_hcd
fe9ff400-fe9ff4ff : 0000:00:13.2
  fe9ff400-fe9ff4ff : ehci_hcd
fe9ff800-fe9ff8ff : 0000:00:12.2
  fe9ff800-fe9ff8ff : ehci_hcd
fe9ffc00-fe9fffff : 0000:00:11.0
  fe9ffc00-fe9fffff : ahci
fea00000-febfffff : PCI Bus 0000:01
  fea00000-feafffff : 0000:01:05.0
  febe0000-febeffff : 0000:01:05.0
fec00000-fec00fff : IOAPIC 0
fec10000-fec1001f : pnp 00:0a
fed00000-fed003ff : HPET 2
fed40000-fed44fff : pnp 00:0a
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : pnp 00:09
ffb80000-ffbfffff : pnp 00:0a
ffe00000-ffffffff : reserved
100000000-21fffffff : System RAM

lspci -vvv
00:00.0 Host bridge: Advanced Micro Devices [AMD] RS780 Host Bridge
        Subsystem: ASUSTeK Computer Inc. Device 8388
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [c4] HyperTransport: Slave or Primary Interface
                Command: BaseUnitID=0 UnitCnt=12 MastHost- DefDir- DUL-
                Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC-
TXO- <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
                Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut-
LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
                Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+
TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
                Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut-
LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
                Revision ID: 3.00
                Link Frequency 0: [b]
                Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
                Link Frequency Capability 0: 200MHz+ 300MHz- 400MHz+
500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
                Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
                Link Frequency 1: 200MHz
                Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
                Link Frequency Capability 1: 200MHz- 300MHz- 400MHz-
500MHz- 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
                Error Handling: PFlE- OFlE- PFE- OFE- EOCFE- RFE-
CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
                Prefetchable memory behind bridge Upper: 00-00
                Bus Number: 00
        Capabilities: [54] HyperTransport: UnitID Clumping
        Capabilities: [40] HyperTransport: Retry Mode
        Capabilities: [9c] HyperTransport: #1a
        Capabilities: [f8] HyperTransport: #1c

00:01.0 PCI bridge: ASUSTeK Computer Inc. RS880 PCI to PCI bridge (int
gfx) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
        I/O behind bridge: 0000d000-0000dfff
        Memory behind bridge: fea00000-febfffff
        Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
        Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [44] HyperTransport: MSI Mapping Enable+ Fixed+
        Capabilities: [b0] Subsystem: ASUSTeK Computer Inc. Device 8388

00:04.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI
bridge (PCIE port 0) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: 0000e000-0000efff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fdf00000-00000000fdffffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag+ RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr- TransPend-
                LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s L1,
Latency L0 <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep+ BwNot+
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
HotPlug- Surprise-
                        Slot #4, PowerLimit 25.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown,
Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet+ Interlock-
                        Changed: MRL- PresDet+ LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis- ARIFwd-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
SpeedDis-, Selectable De-emphasis: -3.5dB
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -3.5dB
        Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0f00c  Data: 4151
        Capabilities: [b0] Subsystem: ASUSTeK Computer Inc. Device 8388
        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
        Capabilities: [100 v1] Vendor Specific Information: ID=0001
Rev=1 Len=010 <?>
        Capabilities: [110 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
        Kernel driver in use: pcieport

00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA
Controller [IDE mode] (prog-if 01 [AHCI 1.0])
        Subsystem: ASUSTeK Computer Inc. M4A785TD Motherboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 22
        Region 0: I/O ports at c000 [size=8]
        Region 1: I/O ports at b000 [size=4]
        Region 2: I/O ports at a000 [size=8]
        Region 3: I/O ports at 9000 [size=4]
        Region 4: I/O ports at 8000 [size=16]
        Region 5: Memory at fe9ffc00 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [60] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [70] SATA HBA v1.0 InCfgSpace
        Kernel driver in use: ahci

00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0
Controller (prog-if 10 [OHCI])
        Subsystem: ASUSTeK Computer Inc. Device 8389
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fe9fe000 (32-bit, non-prefetchable) [size=4K]
        Kernel driver in use: ohci_hcd

00:12.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1
Controller (prog-if 10 [OHCI])
        Subsystem: ASUSTeK Computer Inc. Device 8389
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fe9fd000 (32-bit, non-prefetchable) [size=4K]
        Kernel driver in use: ohci_hcd

00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI
Controller (prog-if 20 [EHCI])
        Subsystem: ASUSTeK Computer Inc. Device 8389
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 17
        Region 0: Memory at fe9ff800 (32-bit, non-prefetchable) [size=256]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
                Bridge: PM- B3+
        Capabilities: [e4] Debug port: BAR=1 offset=00e0
        Kernel driver in use: ehci_hcd

00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0
Controller (prog-if 10 [OHCI])
        Subsystem: ASUSTeK Computer Inc. Device 8389
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at fe9fc000 (32-bit, non-prefetchable) [size=4K]
        Kernel driver in use: ohci_hcd

00:13.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1
Controller (prog-if 10 [OHCI])
        Subsystem: ASUSTeK Computer Inc. Device 8389
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at fe9fb000 (32-bit, non-prefetchable) [size=4K]
        Kernel driver in use: ohci_hcd

00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI
Controller (prog-if 20 [EHCI])
        Subsystem: ASUSTeK Computer Inc. Device 8389
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 19
        Region 0: Memory at fe9ff400 (32-bit, non-prefetchable) [size=256]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
                Bridge: PM- B3+
        Capabilities: [e4] Debug port: BAR=1 offset=00e0
        Kernel driver in use: ehci_hcd

00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3c)
        Subsystem: ASUSTeK Computer Inc. M4A785TD Motherboard
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort+ <MAbort- >SERR- <PERR- INTx-
        Capabilities: [b0] HyperTransport: MSI Mapping Enable- Fixed+

00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller
(prog-if 8a [Master SecP PriP])
        Subsystem: ASUSTeK Computer Inc. Device 8389
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64
        Interrupt: pin A routed to IRQ 16
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]
        Region 4: I/O ports at ff00 [size=16]
        Capabilities: [70] MSI: Enable- Count=1/2 Maskable- 64bit-
                Address: 00000000  Data: 0000
        Kernel driver in use: pata_atiixp

00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA)
        Subsystem: ASUSTeK Computer Inc. Device 8445
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin ? routed to IRQ 16
        Region 0: Memory at fe9f4000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: HDA Intel

00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller
        Subsystem: ASUSTeK Computer Inc. Device 8389
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0

00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge
(prog-if 01 [Subtractive decode])
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=64
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: fff00000-000fffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2
Controller (prog-if 10 [OHCI])
        Subsystem: ASUSTeK Computer Inc. Device 8389
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin C routed to IRQ 18
        Region 0: Memory at fe9fa000 (32-bit, non-prefetchable) [size=4K]
        Kernel driver in use: ohci_hcd

00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor
HyperTransport Configuration
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Capabilities: [80] HyperTransport: Host or Secondary Interface
                Command: WarmRst+ DblEnd- DevNum=0 ChainSide-
HostHide+ Slave- <EOCErr- DUL-
                Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO-
<CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b-
                Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut-
LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
                Revision ID: 3.00
                Link Frequency: [b]
                Link Error: <Prot- <Ovfl- <EOC- CTLTm-
                Link Frequency Capability: 200MHz+ 300MHz- 400MHz+
500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
                Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT-
64bA+ UIDRD- ExtRS- UCnfE-

00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor
Address Map
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor
DRAM Controller
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor
Miscellaneous Control
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Capabilities: [f0] Secure device <?>
        Kernel driver in use: k10temp

00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor
Link Control
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

01:05.0 VGA compatible controller: ATI Technologies Inc 760G [Radeon
3000] (prog-if 00 [VGA controller])
        Subsystem: ASUSTeK Computer Inc. Device 8388
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at d0000000 (32-bit, prefetchable) [size=256M]
        Region 1: I/O ports at d000 [size=256]
        Region 2: Memory at febe0000 (32-bit, non-prefetchable) [size=64K]
        Region 5: Memory at fea00000 (32-bit, non-prefetchable) [size=1M]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Kernel driver in use: radeon

02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 06)
        Subsystem: ASUSTeK Computer Inc. Device 8432
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 25
        Region 0: I/O ports at e800 [size=256]
        Region 2: Memory at fdfff000 (64-bit, prefetchable) [size=4K]
        Region 4: Memory at fdff8000 (64-bit, prefetchable) [size=16K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee0f00c  Data: 4161
        Capabilities: [70] Express (v2) Endpoint, MSI 01
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<512ns, L1 <64us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+
AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 unlimited, L1 <64us
                        ClockPM+ Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB
        Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
                Vector table: BAR=4 offset=00000000
                PBA: BAR=4 offset=00000800
        Capabilities: [d0] Vital Product Data
                No end tag found
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [140 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
        Capabilities: [160 v1] Device Serial Number 00-00-00-00-00-00-00-00
        Kernel driver in use: r8169
