Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab0CRWWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 18:22:46 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:34164 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab0CRWWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 18:22:39 -0400
Message-ID: <4BA2A7A9.4080503@oracle.com>
Date: Thu, 18 Mar 2010 15:22:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: BUG: 2.6.34-rc1, RIP is (null)
Content-Type: multipart/mixed;
 boundary="------------030106080100030900030203"
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4BA2A7AD.0075:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030106080100030900030203
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

One of my automated tests failed to boot cleanly.
This is an 4-proc x86_64 server with 8 GB of RAM.
When I repeated the test, it booted and ran successfully.



BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<(null)>] (null)
PGD 0
Oops: 0010 [#1] SMP
last sysfs file: /sys/block/sdb/removable
CPU 3
Modules linked in: snd_seq_dummy tg3(+) libphy snd_seq_oss snd_seq_midi_event snd_seq ses enclosure snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore snd_page_alloc tpm_tis floppy(+) serio_raw tpm k8temp tpm_bios hwmon pcspkr dm_region_hash dm_log usb_storage lpfc scsi_transport_fc scsi_tgt shpchp cciss uhci_hcd ohci_hcd ehci_hcd

Pid: 2570, comm: udevd Not tainted 2.6.34-rc1 #1 /ProLiant BL685c G1
RIP: 0010:[<0000000000000000>]  [<(null)>] (null)
RSP: 0000:ffff880183b03e98  EFLAGS: 00010246
RAX: ffff88027d94bfd8 RBX: 00000000000000ea RCX: ffff88027d025d40
RDX: ffff880183b03eb0 RSI: dead000000200200 RDI: 0000000000000000
RBP: ffff880183b03ef0 R08: ffff88027d025d40 R09: 0000000000000632
R10: 0000000000000000 R11: 00000000ffffffff R12: ffffffffa0136900
R13: ffff88027f658000 R14: 0000000000000000 R15: 0000000000000100
FS:  00007fe01e9af710(0000) GS:ffff880183b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000027ea32000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevd (pid: 2570, threadinfo ffff88027d94a000, task ffff88027d025d40)
Stack:
 ffffffff81054e89 0000000000000052 0000000000000000 ffff880183b03eb0
<0> ffff880183b03eb0 ffffffff8101ea60 0000000000000282 0000000000000001
<0> 0000000000000141 0000000000000100 ffffffff81823088 ffff880183b03f40
Call Trace:
 <IRQ>
 [<ffffffff81054e89>] ? run_timer_softirq+0x16d/0x209
 [<ffffffff8101ea60>] ? apic_write+0x11/0x13
 [<ffffffff8104deb5>] __do_softirq+0xe1/0x1b7
 [<ffffffff81009a5c>] call_softirq+0x1c/0x30
 [<ffffffff8100b2b7>] do_softirq+0x46/0x9f
 [<ffffffff8104dfd0>] irq_exit+0x45/0x84
 [<ffffffff8101f442>] smp_apic_timer_interrupt+0x79/0x87
 [<ffffffff81009513>] apic_timer_interrupt+0x13/0x20
 <EOI>
Code:  Bad RIP value.
RIP  [<(null)>] (null)
 RSP <ffff880183b03e98>
CR2: 0000000000000000
---[ end trace 77b6d5c602bfc703 ]---



Full kernel log & config file are attached.

-- 
~Randy

--------------030106080100030900030203
Content-Type: text/plain;
 name="netcon-6816.log"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="netcon-6816.log"

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.34-rc1 (root@ca-ostest293.us.oracle.com) (gcc version 4.1.2 20080704 (Red Hat 4.1.2-46)) #1 SMP Mon Mar 8 14:01:59 PST 2010
Command line: root=LABEL=/ selinux=0 console=tty0 console=ttyS0,115200n8 reset_devices netconsole=56816@139.185.50.77/eth0,56816@139.185.50.76/00:18:FE:34:1C:3D nmi_watchdog=2 debug ignore_loglevel initcall_debug 3
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fe50000 (usable)
 BIOS-e820: 000000007fe50000 - 000000007fe58000 (ACPI data)
 BIOS-e820: 000000007fe58000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 000000027ffff000 (usable)
debug: ignoring loglevel setting.
NX (Execute Disable) protection: active
DMI 2.3 present.
e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x27ffff max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-FFFFF write-back
MTRR variable ranges enabled:
  0 base 0000000000 mask FF80000000 write-back
  1 disabled
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
TOM2: 0000000280000000 aka 10240M
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 0000000080000000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0x7fe50 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
found SMP MP-table at [ffff8800000f4f80] f4f80
init_memory_mapping: 0000000000000000-000000007fe50000
 0000000000 - 007fe00000 page 2M
 007fe00000 - 007fe50000 page 4k
kernel direct mapping tables up to 7fe50000 @ 8000-c000
init_memory_mapping: 0000000100000000-000000027ffff000
 0100000000 - 027fe00000 page 2M
 027fe00000 - 027ffff000 page 4k
kernel direct mapping tables up to 27ffff000 @ a000-16000
RAMDISK: 37d77000 - 37feff29
ACPI: RSDP 00000000000f4f00 00024 (v02 HP    )
ACPI: XSDT 000000007fe50780 0005C (v01 HP     A08      00000002   Ò? 0000162E)
ACPI: FACP 000000007fe50800 000F4 (v03 HP     A08      00000002   Ò? 0000162E)
ACPI: DSDT 000000007fe50900 03F75 (v01 HP         DSDT 00000001 INTL 20030228)
ACPI: FACS 000000007fe50100 00040
ACPI: SPCR 000000007fe50140 00050 (v01 HP     SPCRRBSU 00000001   Ò? 0000162E)
ACPI: MCFG 000000007fe501c0 0003C (v01 HP     ProLiant 00000001      00000000)
ACPI: HPET 000000007fe50200 00038 (v01 HP     A08      00000002   Ò? 0000162E)
ACPI: SPMI 000000007fe50240 00040 (v05 HP     ProLiant 00000001   Ò? 0000162E)
ACPI: APIC 000000007fe50280 000DE (v01 HP     00000083 00000002      00000000)
ACPI: SRAT 000000007fe50380 00110 (v01 AMD    HAMMER   00000001 AMD  00000001)
ACPI: Local APIC address 0xfee00000
SRAT: PXM 0 -> APIC 0x00 -> Node 0
SRAT: PXM 0 -> APIC 0x01 -> Node 0
SRAT: PXM 1 -> APIC 0x02 -> Node 1
SRAT: PXM 1 -> APIC 0x03 -> Node 1
SRAT: Node 0 PXM 0 0-a0000
SRAT: Node 0 PXM 0 100000-80000000
SRAT: Node 0 PXM 0 100000000-180000000
SRAT: Node 1 PXM 1 180000000-280000000
NUMA: Allocated memnodemap from 11000 - 16040
NUMA: Using 20 for the hash shift.
Initmem setup node 0 0000000000000000-0000000180000000
  NODE_DATA [0000000100000000 - 0000000100013fff]
Initmem setup node 1 0000000180000000-000000027ffff000
  NODE_DATA [0000000180000000 - 0000000180013fff]
 [ffffea0000000000-ffffea00053fffff] PMD -> [ffff880100200000-ffff8801039fffff] on node 0
 [ffffea0005400000-ffffea0008bfffff] PMD -> [ffff880180200000-ffff8801839fffff] on node 1
Zone PFN ranges:
  DMA      0x00000001 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x0027ffff
Movable zone start PFN for each node
early_node_map[4] active PFN ranges
    0: 0x00000001 -> 0x0000009f
    0: 0x00000100 -> 0x0007fe50
    0: 0x00100000 -> 0x00180000
    1: 0x00180000 -> 0x0027ffff
On node 0 totalpages: 1048046
  DMA zone: 56 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3942 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 505480 pages, LIFO batch:31
  Normal zone: 7168 pages used for memmap
  Normal zone: 517120 pages, LIFO batch:31
On node 1 totalpages: 1048575
  Normal zone: 14336 pages used for memmap
  Normal zone: 1034239 pages, LIFO batch:31
Detected use of extended apic ids on hypertransport bus
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x908
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xf7df0000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 17, address 0xf7df0000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfdef0000] gsi_base[38])
IOAPIC[1]: apic_id 9, version 17, address 0xfdef0000, GSI 38-61
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x10228201 base: 0xfed00000
SMP: Allowing 4 CPUs, 0 hotplug CPUs
early_res array is doubled to 64 at [7000 - 77ff]
nr_irqs_gsi: 62
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
PM: Registered nosave memory: 000000007fe50000 - 000000007fe58000
PM: Registered nosave memory: 000000007fe58000 - 0000000080000000
PM: Registered nosave memory: 0000000080000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 00000000fed00000
PM: Registered nosave memory: 00000000fed00000 - 00000000fee00000
PM: Registered nosave memory: 00000000fee00000 - 00000000fee10000
PM: Registered nosave memory: 00000000fee10000 - 00000000ffc00000
PM: Registered nosave memory: 00000000ffc00000 - 0000000100000000
Allocating PCI resources starting at 80000000 (gap: 80000000:7ec00000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:16 nr_cpumask_bits:16 nr_cpu_ids:4 nr_node_ids:2
PERCPU: Embedded 29 pages/cpu @ffff880001e00000 s90088 r8192 d20504 u1048576
pcpu-alloc: s90088 r8192 d20504 u1048576 alloc=1*2097152
pcpu-alloc: [0] 0 2 [1] 1 3 
early_res array is doubled to 128 at [16040 - 1703f]
Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 2060781
Policy zone: Normal
Kernel command line: root=LABEL=/ selinux=0 console=tty0 console=ttyS0,115200n8 reset_devices netconsole=56816@139.185.50.77/eth0,56816@139.185.50.76/00:18:FE:34:1C:3D nmi_watchdog=2 debug ignore_loglevel initcall_debug 3
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Node 0: aperture @ c000000 size 32 MB
Aperture pointing to e820 RAM. Ignoring.
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 20000000
PM: Registered nosave memory: 0000000020000000 - 0000000024000000
Subtract (63 early reservations)
  #1 [0001000000 - 0001c4fb58]   TEXT DATA BSS
  #2 [0037d77000 - 0037feff29]         RAMDISK
  #3 [0001c50000 - 0001c5010c]             BRK
  #4 [00000f4f90 - 0000100000]   BIOS reserved
  #5 [00000f4f80 - 00000f4f90]    MP-table mpf
  #6 [000009f400 - 00000f1bf8]   BIOS reserved
  #7 [00000f1e2c - 00000f4f80]   BIOS reserved
  #8 [00000f1bf8 - 00000f1e2c]    MP-table mpc
  #9 [0000001000 - 0000003000]      TRAMPOLINE
  #10 [0000003000 - 0000007000]     ACPI WAKEUP
  #11 [0000008000 - 000000a000]         PGTABLE
  #12 [000000a000 - 0000011000]         PGTABLE
  #13 [0000011000 - 0000016040]      MEMNODEMAP
  #14 [0100000000 - 0100014000]       NODE_DATA
  #15 [0180000000 - 0180014000]       NODE_DATA
  #16 [0001c50140 - 0001c51140]         BOOTMEM
  #17 [0001c4fb80 - 0001c4fe80]         BOOTMEM
  #18 [0180014000 - 0180014300]         BOOTMEM
  #19 [0100014000 - 0100015000]         BOOTMEM
  #20 [0100015000 - 0100016000]         BOOTMEM
  #21 [0100200000 - 0103a00000]        MEMMAP 0
  #22 [0180200000 - 0183a00000]        MEMMAP 1
  #23 [0001c4fe80 - 0001c50000]         BOOTMEM
  #24 [0001c51140 - 0001c69140]         BOOTMEM
  #25 [0001c69140 - 0001c75140]         BOOTMEM
  #26 [0180014300 - 018002c300]         BOOTMEM
  #27 [0001c76000 - 0001c77000]         BOOTMEM
  #28 [0001c75140 - 0001c75181]         BOOTMEM
  #29 [0001c751c0 - 0001c75246]         BOOTMEM
  #30 [0001c75280 - 0001c754e8]         BOOTMEM
  #31 [0001c75500 - 0001c75568]         BOOTMEM
  #32 [0001c75580 - 0001c755e8]         BOOTMEM
  #33 [0001c75600 - 0001c75668]         BOOTMEM
  #34 [0001c75680 - 0001c756e8]         BOOTMEM
  #35 [0001c75700 - 0001c75768]         BOOTMEM
  #36 [0001c75780 - 0001c757e8]         BOOTMEM
  #37 [0001c75800 - 0001c75868]         BOOTMEM
  #38 [0001c75880 - 0001c758e8]         BOOTMEM
  #39 [0001c75900 - 0001c75968]         BOOTMEM
  #40 [0001c75980 - 0001c759e8]         BOOTMEM
  #41 [0001c75a00 - 0001c75a20]         BOOTMEM
  #42 [0001c75a40 - 0001c75a60]         BOOTMEM
  #43 [0001c75a80 - 0001c75b49]         BOOTMEM
  #44 [0001c75b80 - 0001c75c49]         BOOTMEM
  #45 [0001e00000 - 0001e1d000]         BOOTMEM
  #46 [0001f00000 - 0001f1d000]         BOOTMEM
  #47 [0183a00000 - 0183a1d000]         BOOTMEM
  #48 [0183b00000 - 0183b1d000]         BOOTMEM
  #49 [0001c75c80 - 0001c75c90]         BOOTMEM
  #50 [0001c75cc0 - 0001c75cd0]         BOOTMEM
  #51 [0001c75d00 - 0001c75d10]         BOOTMEM
  #52 [0001c75d40 - 0001c75d60]         BOOTMEM
  #53 [0001c75d80 - 0001c75ec0]         BOOTMEM
  #54 [0001c75ec0 - 0001c75f20]         BOOTMEM
  #55 [0001c75f40 - 0001c75fa0]         BOOTMEM
  #56 [0001c77000 - 0001c7f000]         BOOTMEM
  #57 [0020000000 - 0024000000]         BOOTMEM
  #58 [0001c75fc0 - 0001c75fe0]         BOOTMEM
  #59 [0001f1d000 - 0005f1d000]         BOOTMEM
  #60 [0001c7f000 - 0001c9f000]         BOOTMEM
  #61 [0001c9f000 - 0001cdf000]         BOOTMEM
  #62 [0000017040 - 000001f040]         BOOTMEM
 7 - 8
 20 40 - 80 9f
 100 100 - 1000 1000
 1cdf 1d00 - 1e00 1e00
 1e1d 1e40 - 1f00 1f00
 5f1d 5f40 - 20000 20000
 24000 24000 - 37d40 37d77
 37ff0 38000 - 7fe40 7fe50
 100016 100040 - 100200 100200
 103a00 103a00 - 180000 180000
 18002d 180040 - 180200 180200
 183a1d 183a40 - 183b00 183b00
 183b1d 183b40 - 27ffc0 27ffff
Memory: 8124160k/10485756k available (3844k kernel code, 2099272k absent, 262324k reserved, 5289k data, 1292k init)
SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=2
Hierarchical RCU implementation.
NR_IRQS:768
Extended CMOS year: 2000
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2612.028 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 5224.05 BogoMIPS (lpj=2612028)
Security Framework initialized
SELinux:  Disabled at boot.
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys devices
tseg: 0000000000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 5 MCE banks
using C1E aware idle routine
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
ACPI: Core revision 20100121
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Dual-Core AMD Opteron(tm) Processor 8218 stepping 02
calling  migration_init+0x0/0x5a @ 1
initcall migration_init+0x0/0x5a returned 0 after 0 usecs
calling  spawn_ksoftirqd+0x0/0x5a @ 1
initcall spawn_ksoftirqd+0x0/0x5a returned 0 after 0 usecs
calling  init_call_single_data+0x0/0x82 @ 1
initcall init_call_single_data+0x0/0x82 returned 0 after 0 usecs
calling  spawn_softlockup_task+0x0/0x75 @ 1
initcall spawn_softlockup_task+0x0/0x75 returned 0 after 0 usecs
calling  relay_init+0x0/0x14 @ 1
initcall relay_init+0x0/0x14 returned 0 after 0 usecs
calling  tracer_alloc_buffers+0x0/0x1d6 @ 1
initcall tracer_alloc_buffers+0x0/0x1d6 returned 0 after 0 usecs
calling  init_trace_printk+0x0/0x12 @ 1
initcall init_trace_printk+0x0/0x12 returned 0 after 0 usecs
calling  mce_amd_init+0x0/0x2d @ 1
initcall mce_amd_init+0x0/0x2d returned 0 after 0 usecs
Booting Node   1, Processors  #1 Ok.
Booting Node   0, Processors  #2 Ok.
Booting Node   1, Processors  #3 Ok.
Brought up 4 CPUs
Total of 4 processors activated (20895.42 BogoMIPS).
Testing NMI watchdog ... OK.
calling  init_mmap_min_addr+0x0/0x26 @ 1
initcall init_mmap_min_addr+0x0/0x26 returned 0 after 0 usecs
calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 usecs
calling  net_ns_init+0x0/0x150 @ 1
initcall net_ns_init+0x0/0x150 returned 0 after 0 usecs
calling  e820_mark_nvs_memory+0x0/0x41 @ 1
initcall e820_mark_nvs_memory+0x0/0x41 returned 0 after 0 usecs
calling  cpufreq_tsc+0x0/0x28 @ 1
initcall cpufreq_tsc+0x0/0x28 returned 0 after 0 usecs
calling  pci_reboot_init+0x0/0x14 @ 1
initcall pci_reboot_init+0x0/0x14 returned 0 after 0 usecs
calling  init_lapic_sysfs+0x0/0x2d @ 1
initcall init_lapic_sysfs+0x0/0x2d returned 0 after 0 usecs
calling  init_smp_flush+0x0/0x21 @ 1
initcall init_smp_flush+0x0/0x21 returned 0 after 0 usecs
calling  alloc_frozen_cpus+0x0/0xa @ 1
initcall alloc_frozen_cpus+0x0/0xa returned 0 after 0 usecs
calling  sysctl_init+0x0/0x16 @ 1
initcall sysctl_init+0x0/0x16 returned 0 after 0 usecs
calling  ksysfs_init+0x0/0x94 @ 1
initcall ksysfs_init+0x0/0x94 returned 0 after 0 usecs
calling  async_init+0x0/0x61 @ 1
initcall async_init+0x0/0x61 returned 0 after 0 usecs
calling  init_jiffies_clocksource+0x0/0x12 @ 1
initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 usecs
calling  pm_init+0x0/0x34 @ 1
initcall pm_init+0x0/0x34 returned 0 after 0 usecs
calling  pm_disk_init+0x0/0x19 @ 1
initcall pm_disk_init+0x0/0x19 returned 0 after 0 usecs
calling  swsusp_header_init+0x0/0x2c @ 1
initcall swsusp_header_init+0x0/0x2c returned 0 after 0 usecs
calling  init_hw_breakpoint+0x0/0x12 @ 1
initcall init_hw_breakpoint+0x0/0x12 returned 0 after 0 usecs
calling  init_zero_pfn+0x0/0x35 @ 1
initcall init_zero_pfn+0x0/0x35 returned 0 after 0 usecs
calling  filelock_init+0x0/0x2e @ 1
initcall filelock_init+0x0/0x2e returned 0 after 0 usecs
calling  init_misc_binfmt+0x0/0x42 @ 1
initcall init_misc_binfmt+0x0/0x42 returned 0 after 0 usecs
calling  init_script_binfmt+0x0/0x14 @ 1
initcall init_script_binfmt+0x0/0x14 returned 0 after 0 usecs
calling  init_elf_binfmt+0x0/0x14 @ 1
initcall init_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
calling  init_compat_elf_binfmt+0x0/0x14 @ 1
initcall init_compat_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
calling  debugfs_init+0x0/0x5a @ 1
initcall debugfs_init+0x0/0x5a returned 0 after 0 usecs
calling  securityfs_init+0x0/0x51 @ 1
initcall securityfs_init+0x0/0x51 returned 0 after 0 usecs
calling  random32_init+0x0/0xd1 @ 1
initcall random32_init+0x0/0xd1 returned 0 after 0 usecs
calling  gnttab_init+0x0/0x169 @ 1
initcall gnttab_init+0x0/0x169 returned -19 after 0 usecs
calling  early_resume_init+0x0/0x19b @ 1
Time: 14:13:38  Date: 03/08/10
initcall early_resume_init+0x0/0x19b returned 0 after 976 usecs
calling  cpufreq_core_init+0x0/0x8c @ 1
initcall cpufreq_core_init+0x0/0x8c returned 0 after 0 usecs
calling  cpuidle_init+0x0/0x40 @ 1
initcall cpuidle_init+0x0/0x40 returned 0 after 0 usecs
calling  sock_init+0x0/0x5e @ 1
initcall sock_init+0x0/0x5e returned 0 after 0 usecs
calling  netpoll_init+0x0/0x31 @ 1
initcall netpoll_init+0x0/0x31 returned 0 after 0 usecs
calling  netlink_proto_init+0x0/0x14c @ 1
NET: Registered protocol family 16
initcall netlink_proto_init+0x0/0x14c returned 0 after 976 usecs
calling  bdi_class_init+0x0/0x41 @ 1
initcall bdi_class_init+0x0/0x41 returned 0 after 0 usecs
calling  kobject_uevent_init+0x0/0x54 @ 1
initcall kobject_uevent_init+0x0/0x54 returned 0 after 0 usecs
calling  pcibus_class_init+0x0/0x19 @ 1
initcall pcibus_class_init+0x0/0x19 returned 0 after 0 usecs
calling  pci_driver_init+0x0/0x12 @ 1
initcall pci_driver_init+0x0/0x12 returned 0 after 0 usecs
calling  backlight_class_init+0x0/0x5d @ 1
initcall backlight_class_init+0x0/0x5d returned 0 after 0 usecs
calling  xenbus_probe_init+0x0/0xcb @ 1
initcall xenbus_probe_init+0x0/0xcb returned -19 after 0 usecs
calling  tty_class_init+0x0/0x38 @ 1
initcall tty_class_init+0x0/0x38 returned 0 after 0 usecs
calling  vtconsole_class_init+0x0/0xc3 @ 1
initcall vtconsole_class_init+0x0/0xc3 returned 0 after 0 usecs
calling  register_node_type+0x0/0x12 @ 1
initcall register_node_type+0x0/0x12 returned 0 after 0 usecs
calling  i2c_init+0x0/0x6b @ 1
initcall i2c_init+0x0/0x6b returned 0 after 0 usecs
calling  amd_postcore_init+0x0/0x8bd @ 1
node 0 link 1: io port [1000, 3fff]
node 1 link 2: io port [4000, ffff]
TOM: 0000000080000000 aka 2048M
node 0 link 1: mmio [e8000000, fddfffff]
node 1 link 2: mmio [fde00000, fdffffff]
node 0 link 1: mmio [80000000, 83ffffff]
node 1 link 2: mmio [84000000, 8fffffff]
node 0 link 1: mmio [a0000, bffff]
TOM2: 0000000280000000 aka 10240M
bus: [00, 3f] on node 0 link 1
bus: 00 index 0 [io  0x0000-0x3fff]
bus: 00 index 1 [mem 0x90000000-0xfddfffff]
bus: 00 index 2 [mem 0x80000000-0x83ffffff]
bus: 00 index 3 [mem 0x000a0000-0x000bffff]
bus: 00 index 4 [mem 0xfe000000-0xffffffff]
bus: 00 index 5 [mem 0x280000000-0xfcffffffff]
bus: [40, ff] on node 1 link 2
bus: 40 index 0 [io  0x4000-0xffff]
bus: 40 index 1 [mem 0xfde00000-0xfdffffff]
bus: 40 index 2 [mem 0x84000000-0x8fffffff]
initcall amd_postcore_init+0x0/0x8bd returned 0 after 23437 usecs
calling  arch_kdebugfs_init+0x0/0x242 @ 1
initcall arch_kdebugfs_init+0x0/0x242 returned 0 after 0 usecs
calling  mtrr_if_init+0x0/0x63 @ 1
initcall mtrr_if_init+0x0/0x63 returned 0 after 0 usecs
calling  ffh_cstate_init+0x0/0x2a @ 1
initcall ffh_cstate_init+0x0/0x2a returned -1 after 0 usecs
initcall ffh_cstate_init+0x0/0x2a returned with error code -1 
calling  acpi_pci_init+0x0/0x5c @ 1
ACPI: bus type pci registered
initcall acpi_pci_init+0x0/0x5c returned 0 after 976 usecs
calling  setup_vcpu_hotplug_event+0x0/0x22 @ 1
initcall setup_vcpu_hotplug_event+0x0/0x22 returned -19 after 0 usecs
calling  dmi_id_init+0x0/0x31a @ 1
initcall dmi_id_init+0x0/0x31a returned 0 after 0 usecs
calling  dma_bus_init+0x0/0x3f @ 1
initcall dma_bus_init+0x0/0x3f returned 0 after 0 usecs
calling  dma_channel_table_init+0x0/0xbf @ 1
initcall dma_channel_table_init+0x0/0xbf returned 0 after 0 usecs
calling  pci_arch_init+0x0/0x69 @ 1
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
PCI: not using MMCONFIG
PCI: Using configuration type 1 for base access
PCI: HP ProLiant BL685c G1 detected, enabling pci=bfsort.
initcall pci_arch_init+0x0/0x69 returned 0 after 3906 usecs
calling  topology_init+0x0/0x86 @ 1
initcall topology_init+0x0/0x86 returned 0 after 0 usecs
calling  mtrr_init_finialize+0x0/0x3d @ 1
initcall mtrr_init_finialize+0x0/0x3d returned 0 after 0 usecs
calling  param_sysfs_init+0x0/0x216 @ 1
initcall param_sysfs_init+0x0/0x216 returned 0 after 4882 usecs
calling  pm_sysrq_init+0x0/0x19 @ 1
initcall pm_sysrq_init+0x0/0x19 returned 0 after 0 usecs
calling  audit_watch_init+0x0/0x2f @ 1
initcall audit_watch_init+0x0/0x2f returned 0 after 0 usecs
calling  init_slow_work+0x0/0x39 @ 1
initcall init_slow_work+0x0/0x39 returned 0 after 0 usecs
calling  default_bdi_init+0x0/0xb6 @ 1
initcall default_bdi_init+0x0/0xb6 returned 0 after 0 usecs
calling  init_bio+0x0/0xe2 @ 1
bio: create slab <bio-0> at 0
initcall init_bio+0x0/0xe2 returned 0 after 976 usecs
calling  fsnotify_init+0x0/0x12 @ 1
initcall fsnotify_init+0x0/0x12 returned 0 after 0 usecs
calling  fsnotify_notification_init+0x0/0x68 @ 1
initcall fsnotify_notification_init+0x0/0x68 returned 0 after 0 usecs
calling  cryptomgr_init+0x0/0x12 @ 1
initcall cryptomgr_init+0x0/0x12 returned 0 after 0 usecs
calling  blk_settings_init+0x0/0x2a @ 1
initcall blk_settings_init+0x0/0x2a returned 0 after 0 usecs
calling  blk_ioc_init+0x0/0x2a @ 1
initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
calling  blk_softirq_init+0x0/0x6e @ 1
initcall blk_softirq_init+0x0/0x6e returned 0 after 0 usecs
calling  blk_iopoll_setup+0x0/0x6e @ 1
initcall blk_iopoll_setup+0x0/0x6e returned 0 after 0 usecs
calling  genhd_device_init+0x0/0x66 @ 1
initcall genhd_device_init+0x0/0x66 returned 0 after 0 usecs
calling  pci_slot_init+0x0/0x45 @ 1
initcall pci_slot_init+0x0/0x45 returned 0 after 0 usecs
calling  fbmem_init+0x0/0x98 @ 1
initcall fbmem_init+0x0/0x98 returned 0 after 0 usecs
calling  acpi_init+0x0/0x2d8 @ 1
ACPI: EC: Look up EC in DSDT
ACPI: SSDT 000000007fe58000 004F0 (v02 HP     PNOWSSDT 00000002 HP   00000001)
ACPI: Interpreter enabled
ACPI: (supports S0 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in ACPI motherboard resources
initcall acpi_init+0x0/0x2d8 returned 0 after 41015 usecs
calling  dock_init+0x0/0xa5 @ 1
ACPI: No dock devices found.
initcall dock_init+0x0/0xa5 returned 0 after 976 usecs
calling  acpi_pci_root_init+0x0/0x2d @ 1
PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci_root PNP0A03:00: host bridge window [io  0x0000-0x03af] (ignored)
pci_root PNP0A03:00: host bridge window [io  0x03b0-0x03bb] (ignored)
pci_root PNP0A03:00: host bridge window [io  0x03c0-0x03df] (ignored)
pci_root PNP0A03:00: host bridge window [io  0x03e0-0x0fff] (ignored)
pci_root PNP0A03:00: host bridge window [io  0x1000-0x3fff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0xe8000000-0xfddfffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0x80000000-0x83ffffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
pci 0000:00:02.0: reg 10: [mem 0xf7de0000-0xf7de0fff]
pci 0000:00:02.0: supports D1 D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: reg 10: [mem 0xf7dd0000-0xf7dd00ff]
pci 0000:00:02.1: supports D1 D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.1: PME# disabled
pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0b.0: PME# disabled
pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0c.0: PME# disabled
pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0d.0: PME# disabled
pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0e.0: PME# disabled
PCI: peer root bus 00 res updated from pci conf
pci 0000:01:03.0: reg 10: [mem 0xe8000000-0xefffffff pref]
pci 0000:01:03.0: reg 14: [io  0x1000-0x10ff]
pci 0000:01:03.0: reg 18: [mem 0xf7ff0000-0xf7ffffff]
pci 0000:01:03.0: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:01:03.0: supports D1 D2
pci 0000:01:04.0: reg 10: [io  0x2800-0x28ff]
pci 0000:01:04.0: reg 14: [mem 0xf7fe0000-0xf7fe01ff]
pci 0000:01:04.0: PME# supported from D0 D3hot D3cold
pci 0000:01:04.0: PME# disabled
pci 0000:01:04.2: reg 10: [io  0x1400-0x14ff]
pci 0000:01:04.2: reg 14: [mem 0xf7fd0000-0xf7fd07ff]
pci 0000:01:04.2: reg 18: [mem 0xf7fc0000-0xf7fc3fff]
pci 0000:01:04.2: reg 1c: [mem 0xf7f00000-0xf7f7ffff]
pci 0000:01:04.2: reg 30: [mem 0x00000000-0x0000ffff pref]
pci 0000:01:04.2: PME# supported from D0 D3hot D3cold
pci 0000:01:04.2: PME# disabled
pci 0000:01:04.4: reg 20: [io  0x1800-0x181f]
pci 0000:01:04.4: PME# supported from D0 D3hot D3cold
pci 0000:01:04.4: PME# disabled
pci 0000:01:04.6: reg 10: [mem 0xf7ef0000-0xf7ef00ff]
pci 0000:01:04.6: PME# supported from D0 D3hot D3cold
pci 0000:01:04.6: PME# disabled
pci 0000:00:09.0: PCI bridge to [bus 01-01] (subtractive decode)
pci 0000:00:09.0:   bridge window [io  0x1000-0x2fff]
pci 0000:00:09.0:   bridge window [mem 0xf7e00000-0xf7ffffff]
pci 0000:00:09.0:   bridge window [mem 0xe8000000-0xefffffff pref]
pci 0000:00:09.0:   bridge window [io  0x0000-0x3fff] (subtractive decode)
pci 0000:00:09.0:   bridge window [mem 0x90000000-0xfddfffff] (subtractive decode)
pci 0000:00:09.0:   bridge window [mem 0x80000000-0x83ffffff] (subtractive decode)
pci 0000:00:09.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:09.0:   bridge window [mem 0xfe000000-0xffffffff] (subtractive decode)
pci 0000:00:09.0:   bridge window [mem 0x280000000-0xfcffffffff] (subtractive decode)
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:0b.0: PCI bridge to [bus 02-03]
pci 0000:00:0b.0:   bridge window [io  fffffffffffff000 - 0000] reg reading
pci 0000:00:0b.0:   bridge window [mem 0xf8000000-0xf9ffffff]
pci 0000:00:0b.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
pci 0000:03:00.0: reg 10: [mem 0xf8000000-0xf9ffffff 64bit]
pci 0000:03:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:03:00.0: PME# supported from D3hot D3cold
pci 0000:03:00.0: PME# disabled
pci 0000:02:00.0: PCI bridge to [bus 03-03]
pci 0000:02:00.0:   bridge window [io  fffffffffffff000 - 0000] reg reading
pci 0000:02:00.0:   bridge window [mem 0xf8000000-0xf9ffffff]
pci 0000:02:00.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
pci 0000:04:00.0: PME# disabled
pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:0c.0: PCI bridge to [bus 04-05]
pci 0000:00:0c.0:   bridge window [io  fffffffffffff000 - 0000] reg reading
pci 0000:00:0c.0:   bridge window [mem 0xfa000000-0xfbffffff]
pci 0000:00:0c.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
pci 0000:05:00.0: reg 10: [mem 0xfa000000-0xfbffffff 64bit]
pci 0000:05:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:05:00.0: PME# supported from D3hot D3cold
pci 0000:05:00.0: PME# disabled
pci 0000:04:00.0: PCI bridge to [bus 05-05]
pci 0000:04:00.0:   bridge window [io  fffffffffffff000 - 0000] reg reading
pci 0000:04:00.0:   bridge window [mem 0xfa000000-0xfbffffff]
pci 0000:04:00.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
pci 0000:06:00.0: PME# disabled
pci 0000:06:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:0d.0: PCI bridge to [bus 06-07]
pci 0000:00:0d.0:   bridge window [io  fffffffffffff000 - 0000] reg reading
pci 0000:00:0d.0:   bridge window [mem 0xfdc00000-0xfdcfffff]
pci 0000:00:0d.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
pci 0000:07:04.0: reg 10: [mem 0xfdcf0000-0xfdcfffff 64bit]
pci 0000:07:04.0: reg 18: [mem 0xfdce0000-0xfdceffff 64bit]
pci 0000:07:04.0: PME# supported from D3hot D3cold
pci 0000:07:04.0: PME# disabled
pci 0000:07:04.1: reg 10: [mem 0xfdcd0000-0xfdcdffff 64bit]
pci 0000:07:04.1: reg 18: [mem 0xfdcc0000-0xfdccffff 64bit]
pci 0000:07:04.1: PME# supported from D3hot D3cold
pci 0000:07:04.1: PME# disabled
pci 0000:06:00.0: PCI bridge to [bus 07-07]
pci 0000:06:00.0:   bridge window [io  fffffffffffff000 - 0000] reg reading
pci 0000:06:00.0:   bridge window [mem 0xfdc00000-0xfdcfffff]
pci 0000:06:00.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
pci 0000:08:00.0: reg 10: [mem 0xfddf0000-0xfddf0fff 64bit]
pci 0000:08:00.0: reg 18: [mem 0xfdde0000-0xfdde00ff 64bit]
pci 0000:08:00.0: reg 20: [io  0x3000-0x30ff]
pci 0000:08:00.0: reg 30: [mem 0x00000000-0x0003ffff pref]
pci 0000:08:00.1: reg 10: [mem 0xfddd0000-0xfddd0fff 64bit]
pci 0000:08:00.1: reg 18: [mem 0xfddc0000-0xfddc00ff 64bit]
pci 0000:08:00.1: reg 20: [io  0x3400-0x34ff]
pci 0000:08:00.1: reg 30: [mem 0x00000000-0x0003ffff pref]
pci 0000:08:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:0e.0: PCI bridge to [bus 08-0a]
pci 0000:00:0e.0:   bridge window [io  0x3000-0x3fff]
pci 0000:00:0e.0:   bridge window [mem 0xfdd00000-0xfddfffff]
pci 0000:00:0e.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IP2P._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE1.NB01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE2.NC1B._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE3.NC2B._PRT]
ACPI: PCI Root Bridge [PCI1] (0000:40)
pci_root PNP0A03:01: host bridge window [io  0x4000-0xffff] (ignored)
pci_root PNP0A03:01: host bridge window [mem 0xfde00000-0xfdffffff] (ignored)
pci_root PNP0A03:01: host bridge window [mem 0x84000000-0x8fffffff] (ignored)
pci 0000:40:01.0: reg 14: [mem 0xfdef0000-0xfdef0fff]
pci 0000:40:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:40:0c.0: PME# disabled
pci 0000:40:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:40:0d.0: PME# disabled
pci 0000:40:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:40:0e.0: PME# disabled
PCI: peer root bus 40 res updated from pci conf
pci 0000:41:00.0: PME# supported from D0 D3hot D3cold
pci 0000:41:00.0: PME# disabled
pci 0000:41:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:40:0c.0: PCI bridge to [bus 41-43]
pci 0000:40:0c.0:   bridge window [io  0x4000-0x4fff]
pci 0000:40:0c.0:   bridge window [mem 0xfdf00000-0xfdffffff]
pci 0000:40:0c.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
pci 0000:42:08.0: reg 10: [mem 0xfdf80000-0xfdffffff 64bit]
pci 0000:42:08.0: reg 18: [io  0x4000-0x40ff]
pci 0000:42:08.0: reg 1c: [mem 0xfdf70000-0xfdf77fff]
pci 0000:42:08.0: reg 30: [mem 0x00000000-0x00003fff pref]
pci 0000:42:08.0: supports D1
pci 0000:41:00.0: PCI bridge to [bus 42-43]
pci 0000:41:00.0:   bridge window [io  0x4000-0x4fff]
pci 0000:41:00.0:   bridge window [mem 0xfdf00000-0xfdffffff]
pci 0000:41:00.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
pci 0000:42:04.0: PCI bridge to [bus 43-43]
pci 0000:42:04.0:   bridge window [io  fffffffffffff000 - 0000] reg reading
pci 0000:42:04.0:   bridge window [mem 0xfff00000 - 0x000fffff] reg reading
pci 0000:42:04.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
pci 0000:40:0d.0: PCI bridge to [bus 44-46]
pci 0000:40:0d.0:   bridge window [io  fffffffffffff000 - 0000] reg reading
pci 0000:40:0d.0:   bridge window [mem 0xfff00000 - 0x000fffff] reg reading
pci 0000:40:0d.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
pci 0000:40:0e.0: PCI bridge to [bus 47-49]
pci 0000:40:0e.0:   bridge window [io  fffffffffffff000 - 0000] reg reading
pci 0000:40:0e.0:   bridge window [mem 0xfff00000 - 0x000fffff] reg reading
pci 0000:40:0e.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE2.SASB._PRT]
initcall acpi_pci_root_init+0x0/0x2d returned 0 after 177734 usecs
calling  acpi_pci_link_init+0x0/0x43 @ 1
ACPI: PCI Interrupt Link [LNKW] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [LNKX] (IRQs 17) *0, disabled.
ACPI: PCI Interrupt Link [LNKY] (IRQs 18) *0, disabled.
ACPI: PCI Interrupt Link [LNKZ] (IRQs 19) *0, disabled.
ACPI: PCI Interrupt Link [LNU0] (IRQs 22) *5
ACPI: PCI Interrupt Link [LNU2] (IRQs 23) *7
ACPI: PCI Interrupt Link [LNKA] (IRQs 54) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 55) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 56) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 57) *0, disabled.
initcall acpi_pci_link_init+0x0/0x43 returned 0 after 28320 usecs
calling  pnp_init+0x0/0x12 @ 1
initcall pnp_init+0x0/0x12 returned 0 after 0 usecs
calling  setup_shutdown_event+0x0/0x14 @ 1
initcall setup_shutdown_event+0x0/0x14 returned 0 after 0 usecs
calling  balloon_init+0x0/0x1b1 @ 1
initcall balloon_init+0x0/0x1b1 returned -19 after 0 usecs
calling  misc_init+0x0/0xb8 @ 1
initcall misc_init+0x0/0xb8 returned 0 after 0 usecs
calling  vga_arb_device_init+0x0/0x78 @ 1
vgaarb: device added: PCI:0000:01:03.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
initcall vga_arb_device_init+0x0/0x78 returned 0 after 2929 usecs
calling  cn_init+0x0/0x9e @ 1
initcall cn_init+0x0/0x9e returned 0 after 0 usecs
calling  init_scsi+0x0/0x91 @ 1
SCSI subsystem initialized
initcall init_scsi+0x0/0x91 returned 0 after 976 usecs
calling  ata_init+0x0/0x34e @ 1
libata version 3.00 loaded.
initcall ata_init+0x0/0x34e returned 0 after 976 usecs
calling  init_pcmcia_cs+0x0/0x25 @ 1
initcall init_pcmcia_cs+0x0/0x25 returned 0 after 0 usecs
calling  usb_init+0x0/0x175 @ 1
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
initcall usb_init+0x0/0x175 returned 0 after 2929 usecs
calling  serio_init+0x0/0x89 @ 1
initcall serio_init+0x0/0x89 returned 0 after 0 usecs
calling  input_init+0x0/0x132 @ 1
initcall input_init+0x0/0x132 returned 0 after 0 usecs
calling  rtc_init+0x0/0x71 @ 1
initcall rtc_init+0x0/0x71 returned 0 after 0 usecs
calling  power_supply_class_init+0x0/0x38 @ 1
initcall power_supply_class_init+0x0/0x38 returned 0 after 0 usecs
calling  thermal_init+0x0/0x40 @ 1
initcall thermal_init+0x0/0x40 returned 0 after 0 usecs
calling  md_init+0x0/0xd0 @ 1
initcall md_init+0x0/0xd0 returned 0 after 0 usecs
calling  leds_init+0x0/0x40 @ 1
initcall leds_init+0x0/0x40 returned 0 after 0 usecs
calling  pci_subsys_init+0x0/0xdb @ 1
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009f400 - 000000000009ffff 
reserve RAM buffer: 000000007fe50000 - 000000007fffffff 
reserve RAM buffer: 000000027ffff000 - 000000027fffffff initcall pci_subsys_init+0x0/0xdb returned 0 after 4882 usecs
calling  proto_init+0x0/0x12 @ 1
initcall proto_init+0x0/0x12 returned 0 after 0 usecs
calling  net_dev_init+0x0/0x177 @ 1
initcall net_dev_init+0x0/0x177 returned 0 after 0 usecs
calling  neigh_init+0x0/0x71 @ 1
initcall neigh_init+0x0/0x71 returned 0 after 0 usecs
calling  fib_rules_init+0x0/0xa6 @ 1
initcall fib_rules_init+0x0/0xa6 returned 0 after 0 usecs
calling  pktsched_init+0x0/0xdc @ 1
initcall pktsched_init+0x0/0xdc returned 0 after 0 usecs
calling  tc_filter_init+0x0/0x4c @ 1
initcall tc_filter_init+0x0/0x4c returned 0 after 0 usecs
calling  tc_action_init+0x0/0x4c @ 1
initcall tc_action_init+0x0/0x4c returned 0 after 0 usecs
calling  genl_init+0x0/0x8f @ 1
initcall genl_init+0x0/0x8f returned 0 after 0 usecs
calling  cipso_v4_init+0x0/0x67 @ 1
initcall cipso_v4_init+0x0/0x67 returned 0 after 0 usecs
calling  wireless_nlevent_init+0x0/0x12 @ 1
initcall wireless_nlevent_init+0x0/0x12 returned 0 after 0 usecs
calling  netlbl_init+0x0/0x83 @ 1
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
initcall netlbl_init+0x0/0x83 returned 0 after 3906 usecs
calling  sysctl_init+0x0/0x49 @ 1
initcall sysctl_init+0x0/0x49 returned 0 after 0 usecs
calling  print_ICs+0x0/0x506 @ 1
initcall print_ICs+0x0/0x506 returned 0 after 0 usecs
calling  hpet_late_init+0x0/0x1ed @ 1
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
hpet0: 3 comparators, 32-bit 25.000000 MHz counter
initcall hpet_late_init+0x0/0x1ed returned 0 after 9765 usecs
calling  clocksource_done_booting+0x0/0x36 @ 1
Switching to clocksource hpet
initcall clocksource_done_booting+0x0/0x36 returned 0 after 1085 usecs
calling  rb_init_debugfs+0x0/0x2f @ 1
initcall rb_init_debugfs+0x0/0x2f returned 0 after 36 usecs
calling  tracer_init_debugfs+0x0/0x362 @ 1
initcall tracer_init_debugfs+0x0/0x362 returned 0 after 78 usecs
calling  init_trace_printk_function_export+0x0/0x2f @ 1
initcall init_trace_printk_function_export+0x0/0x2f returned 0 after 2 usecs
calling  event_trace_init+0x0/0x1eb @ 1
initcall event_trace_init+0x0/0x1eb returned 0 after 1219 usecs
calling  init_kprobe_trace+0x0/0x78 @ 1
initcall init_kprobe_trace+0x0/0x78 returned 0 after 3 usecs
calling  init_pipe_fs+0x0/0x4c @ 1
initcall init_pipe_fs+0x0/0x4c returned 0 after 24 usecs
calling  eventpoll_init+0x0/0xc3 @ 1
initcall eventpoll_init+0x0/0xc3 returned 0 after 6 usecs
calling  anon_inode_init+0x0/0x123 @ 1
initcall anon_inode_init+0x0/0x123 returned 0 after 8 usecs
calling  blk_scsi_ioctl_init+0x0/0x289 @ 1
initcall blk_scsi_ioctl_init+0x0/0x289 returned 0 after 1 usecs
calling  acpi_event_init+0x0/0x80 @ 1
initcall acpi_event_init+0x0/0x80 returned 0 after 21 usecs
calling  pnpacpi_init+0x0/0x8c @ 1
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
initcall pnpacpi_init+0x0/0x8c returned 0 after 62524 usecs
calling  pnp_system_init+0x0/0x12 @ 1
system 00:01: [io  0x0408-0x040f] has been reserved
system 00:01: [io  0x04d0-0x04d1] has been reserved
system 00:01: [io  0x0700-0x073f] has been reserved
system 00:01: [io  0x0800-0x08fe] has been reserved
system 00:01: [io  0x0900-0x09fe] has been reserved
system 00:01: [io  0x09ff] has been reserved
system 00:01: [io  0x0a00-0x0afe] has been reserved
system 00:01: [io  0x0aff] has been reserved
system 00:01: [io  0x0b00-0x0bfe] has been reserved
system 00:01: [io  0x0bff] has been reserved
system 00:01: [io  0x0c80-0x0c83] has been reserved
system 00:01: [io  0x0cd4-0x0cd7] has been reserved
system 00:01: [io  0x0f50-0x0f58] has been reserved
system 00:01: [io  0x0ca0-0x0ca1] has been reserved
system 00:01: [io  0x0ca4-0x0ca5] has been reserved
system 00:01: [io  0x0cf9] could not be reserved
system 00:01: [io  0x03f8-0x03ff] has been reserved
system 00:01: [mem 0x80000000-0x8fffffff] could not be reserved
system 00:01: [mem 0xf7df0000-0xf7df0fff] could not be reserved
system 00:01: [mem 0xfdef0000-0xfdef0fff] could not be reserved
initcall pnp_system_init+0x0/0x12 returned 0 after 465887 usecs
calling  chr_dev_init+0x0/0xc7 @ 1
initcall chr_dev_init+0x0/0xc7 returned 0 after 533 usecs
calling  firmware_class_init+0x0/0x79 @ 1
initcall firmware_class_init+0x0/0x79 returned 0 after 55 usecs
calling  init_pcmcia_bus+0x0/0x65 @ 1
initcall init_pcmcia_bus+0x0/0x65 returned 0 after 59 usecs
calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
initcall cpufreq_gov_performance_init+0x0/0x12 returned 0 after 1 usecs
calling  cpufreq_gov_dbs_init+0x0/0xaf @ 1
initcall cpufreq_gov_dbs_init+0x0/0xaf returned 0 after 136 usecs
calling  init_acpi_pm_clocksource+0x0/0xef @ 1
initcall init_acpi_pm_clocksource+0x0/0xef returned 0 after 4426 usecs
calling  pcibios_assign_resources+0x0/0x76 @ 1
PCI: max bus depth: 3 pci_try_num: 4
pci 0000:00:0b.0: BAR 9: assigned [mem 0x90000000-0x900fffff pref]
pci 0000:00:0c.0: BAR 9: assigned [mem 0x90100000-0x901fffff pref]
pci 0000:00:0e.0: BAR 9: assigned [mem 0x90200000-0x902fffff pref]
pci 0000:01:03.0: BAR 6: assigned [mem 0xf7e00000-0xf7e1ffff pref]
pci 0000:01:04.2: BAR 6: assigned [mem 0xf7e20000-0xf7e2ffff pref]
pci 0000:00:09.0: PCI bridge to [bus 01-01]
pci 0000:00:09.0:   bridge window [io  0x1000-0x2fff]
pci 0000:00:09.0:   bridge window [mem 0xf7e00000-0xf7ffffff]
pci 0000:00:09.0:   bridge window [mem 0xe8000000-0xefffffff pref]
pci 0000:02:00.0: BAR 9: assigned [mem 0x90000000-0x900fffff pref]
pci 0000:03:00.0: BAR 6: assigned [mem 0x90000000-0x9001ffff pref]
pci 0000:02:00.0: PCI bridge to [bus 03-03]
pci 0000:02:00.0:   bridge window [io  disabled]
pci 0000:02:00.0:   bridge window [mem 0xf8000000-0xf9ffffff]
pci 0000:02:00.0:   bridge window [mem 0x90000000-0x900fffff pref]
pci 0000:00:0b.0: PCI bridge to [bus 02-03]
pci 0000:00:0b.0:   bridge window [io  disabled]
pci 0000:00:0b.0:   bridge window [mem 0xf8000000-0xf9ffffff]
pci 0000:00:0b.0:   bridge window [mem 0x90000000-0x900fffff pref]
pci 0000:04:00.0: BAR 9: assigned [mem 0x90100000-0x901fffff pref]
pci 0000:05:00.0: BAR 6: assigned [mem 0x90100000-0x9011ffff pref]
pci 0000:04:00.0: PCI bridge to [bus 05-05]
pci 0000:04:00.0:   bridge window [io  disabled]
pci 0000:04:00.0:   bridge window [mem 0xfa000000-0xfbffffff]
pci 0000:04:00.0:   bridge window [mem 0x90100000-0x901fffff pref]
pci 0000:00:0c.0: PCI bridge to [bus 04-05]
pci 0000:00:0c.0:   bridge window [io  disabled]
pci 0000:00:0c.0:   bridge window [mem 0xfa000000-0xfbffffff]
pci 0000:00:0c.0:   bridge window [mem 0x90100000-0x901fffff pref]
pci 0000:06:00.0: PCI bridge to [bus 07-07]
pci 0000:06:00.0:   bridge window [io  disabled]
pci 0000:06:00.0:   bridge window [mem 0xfdc00000-0xfdcfffff]
pci 0000:06:00.0:   bridge window [mem pref disabled]
pci 0000:00:0d.0: PCI bridge to [bus 06-07]
pci 0000:00:0d.0:   bridge window [io  disabled]
pci 0000:00:0d.0:   bridge window [mem 0xfdc00000-0xfdcfffff]
pci 0000:00:0d.0:   bridge window [mem pref disabled]
pci 0000:08:00.0: BAR 6: assigned [mem 0x90200000-0x9023ffff pref]
pci 0000:08:00.1: BAR 6: assigned [mem 0x90240000-0x9027ffff pref]
pci 0000:00:0e.0: PCI bridge to [bus 08-0a]
pci 0000:00:0e.0:   bridge window [io  0x3000-0x3fff]
pci 0000:00:0e.0:   bridge window [mem 0xfdd00000-0xfddfffff]
pci 0000:00:0e.0:   bridge window [mem 0x90200000-0x902fffff pref]
pci 0000:40:0c.0: BAR 9: assigned [mem 0x84000000-0x840fffff pref]
pci 0000:41:00.0: BAR 9: assigned [mem 0x84000000-0x840fffff pref]
pci 0000:42:08.0: BAR 6: assigned [mem 0x84000000-0x84003fff pref]
pci 0000:42:04.0: PCI bridge to [bus 43-43]
pci 0000:42:04.0:   bridge window [io  disabled]
pci 0000:42:04.0:   bridge window [mem disabled]
pci 0000:42:04.0:   bridge window [mem pref disabled]
pci 0000:41:00.0: PCI bridge to [bus 42-43]
pci 0000:41:00.0:   bridge window [io  0x4000-0x4fff]
pci 0000:41:00.0:   bridge window [mem 0xfdf00000-0xfdffffff]
pci 0000:41:00.0:   bridge window [mem 0x84000000-0x840fffff pref]
pci 0000:40:0c.0: PCI bridge to [bus 41-43]
pci 0000:40:0c.0:   bridge window [io  0x4000-0x4fff]
pci 0000:40:0c.0:   bridge window [mem 0xfdf00000-0xfdffffff]
pci 0000:40:0c.0:   bridge window [mem 0x84000000-0x840fffff pref]
pci 0000:40:0d.0: PCI bridge to [bus 44-46]
pci 0000:40:0d.0:   bridge window [io  disabled]
pci 0000:40:0d.0:   bridge window [mem disabled]
pci 0000:40:0d.0:   bridge window [mem pref disabled]
pci 0000:40:0e.0: PCI bridge to [bus 47-49]
pci 0000:40:0e.0:   bridge window [io  disabled]
pci 0000:40:0e.0:   bridge window [mem disabled]
pci 0000:40:0e.0:   bridge window [mem pref disabled]
pci 0000:00:09.0: setting latency timer to 64
pci 0000:00:0b.0: setting latency timer to 64
pci 0000:02:00.0: setting latency timer to 64
pci 0000:00:0c.0: setting latency timer to 64
pci 0000:04:00.0: setting latency timer to 64
pci 0000:00:0d.0: setting latency timer to 64
pci 0000:06:00.0: setting latency timer to 64
pci 0000:00:0e.0: setting latency timer to 64
pci 0000:40:0c.0: setting latency timer to 64
pci 0000:41:00.0: setting latency timer to 64
pci 0000:40:0d.0: setting latency timer to 64
pci 0000:40:0e.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0x3fff]
pci_bus 0000:00: resource 5 [mem 0x90000000-0xfddfffff]
pci_bus 0000:00: resource 6 [mem 0x80000000-0x83ffffff]
pci_bus 0000:00: resource 7 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 8 [mem 0xfe000000-0xffffffff]
pci_bus 0000:00: resource 9 [mem 0x280000000-0xfcffffffff]
pci_bus 0000:01: resource 0 [io  0x1000-0x2fff]
pci_bus 0000:01: resource 1 [mem 0xf7e00000-0xf7ffffff]
pci_bus 0000:01: resource 2 [mem 0xe8000000-0xefffffff pref]
pci_bus 0000:01: resource 4 [io  0x0000-0x3fff]
pci_bus 0000:01: resource 5 [mem 0x90000000-0xfddfffff]
pci_bus 0000:01: resource 6 [mem 0x80000000-0x83ffffff]
pci_bus 0000:01: resource 7 [mem 0x000a0000-0x000bffff]
pci_bus 0000:01: resource 8 [mem 0xfe000000-0xffffffff]
pci_bus 0000:01: resource 9 [mem 0x280000000-0xfcffffffff]
pci_bus 0000:02: resource 1 [mem 0xf8000000-0xf9ffffff]
pci_bus 0000:02: resource 2 [mem 0x90000000-0x900fffff pref]
pci_bus 0000:03: resource 1 [mem 0xf8000000-0xf9ffffff]
pci_bus 0000:03: resource 2 [mem 0x90000000-0x900fffff pref]
pci_bus 0000:04: resource 1 [mem 0xfa000000-0xfbffffff]
pci_bus 0000:04: resource 2 [mem 0x90100000-0x901fffff pref]
pci_bus 0000:05: resource 1 [mem 0xfa000000-0xfbffffff]
pci_bus 0000:05: resource 2 [mem 0x90100000-0x901fffff pref]
pci_bus 0000:06: resource 1 [mem 0xfdc00000-0xfdcfffff]
pci_bus 0000:07: resource 1 [mem 0xfdc00000-0xfdcfffff]
pci_bus 0000:08: resource 0 [io  0x3000-0x3fff]
pci_bus 0000:08: resource 1 [mem 0xfdd00000-0xfddfffff]
pci_bus 0000:08: resource 2 [mem 0x90200000-0x902fffff pref]
pci_bus 0000:40: resource 4 [io  0x4000-0xffff]
pci_bus 0000:40: resource 5 [mem 0xfde00000-0xfdffffff]
pci_bus 0000:40: resource 6 [mem 0x84000000-0x8fffffff]
pci_bus 0000:41: resource 0 [io  0x4000-0x4fff]
pci_bus 0000:41: resource 1 [mem 0xfdf00000-0xfdffffff]
pci_bus 0000:41: resource 2 [mem 0x84000000-0x840fffff pref]
pci_bus 0000:42: resource 0 [io  0x4000-0x4fff]
pci_bus 0000:42: resource 1 [mem 0xfdf00000-0xfdffffff]
pci_bus 0000:42: resource 2 [mem 0x84000000-0x840fffff pref]
initcall pcibios_assign_resources+0x0/0x76 returned 0 after 2559959 usecs
calling  sysctl_core_init+0x0/0x38 @ 1
initcall sysctl_core_init+0x0/0x38 returned 0 after 8 usecs
calling  inet_init+0x0/0x204 @ 1
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
UDP hash table entries: 4096 (order: 5, 131072 bytes)
UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
initcall inet_init+0x0/0x204 returned 0 after 180614 usecs
calling  af_unix_init+0x0/0x55 @ 1
NET: Registered protocol family 1
initcall af_unix_init+0x0/0x55 returned 0 after 17601 usecs
calling  pci_apply_final_quirks+0x0/0xef @ 1
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:0b.0: Found disabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:0c.0: Found enabled HT MSI Mapping
pci 0000:00:0d.0: Found enabled HT MSI Mapping
pci 0000:00:0e.0: Found enabled HT MSI Mapping
pci 0000:01:03.0: Boot video device
pci 0000:01:04.4: HCRESET not completed yet!
pci 0000:40:0c.0: Found enabled HT MSI Mapping
pci 0000:40:0d.0: Found enabled HT MSI Mapping
pci 0000:40:0e.0: Found enabled HT MSI Mapping
PCI: CLS 64 bytes, default 64
initcall pci_apply_final_quirks+0x0/0xef returned 0 after 254972 usecs
calling  populate_rootfs+0x0/0x237 @ 1
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 2531k freed
initcall populate_rootfs+0x0/0x237 returned 0 after 92457 usecs
calling  pci_iommu_init+0x0/0x31 @ 1
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 20000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
initcall pci_iommu_init+0x0/0x31 returned 0 after 71931 usecs
calling  calgary_fixup_tce_spaces+0x0/0xee @ 1
initcall calgary_fixup_tce_spaces+0x0/0xee returned -19 after 0 usecs
calling  i8259A_init_sysfs+0x0/0x22 @ 1
initcall i8259A_init_sysfs+0x0/0x22 returned 0 after 144 usecs
calling  vsyscall_init+0x0/0x6c @ 1
initcall vsyscall_init+0x0/0x6c returned 0 after 13 usecs
calling  sbf_init+0x0/0xd7 @ 1
initcall sbf_init+0x0/0xd7 returned 0 after 0 usecs
calling  i8237A_init_sysfs+0x0/0x22 @ 1
initcall i8237A_init_sysfs+0x0/0x22 returned 0 after 105 usecs
calling  add_rtc_cmos+0x0/0xa4 @ 1
platform rtc_cmos: registered platform RTC device (no PNP device found)
initcall add_rtc_cmos+0x0/0xa4 returned 0 after 11965 usecs
calling  cache_sysfs_init+0x0/0x59 @ 1
initcall cache_sysfs_init+0x0/0x59 returned 0 after 924 usecs
calling  mcheck_init_device+0x0/0xf2 @ 1
initcall mcheck_init_device+0x0/0xf2 returned 0 after 363 usecs
calling  threshold_init_device+0x0/0x44 @ 1
initcall threshold_init_device+0x0/0x44 returned 0 after 1 usecs
calling  thermal_throttle_init_device+0x0/0x89 @ 1
initcall thermal_throttle_init_device+0x0/0x89 returned 0 after 0 usecs
calling  msr_init+0x0/0x10b @ 1
initcall msr_init+0x0/0x10b returned 0 after 303 usecs
calling  cpuid_init+0x0/0x10b @ 1
initcall cpuid_init+0x0/0x10b returned 0 after 282 usecs
calling  ioapic_init_sysfs+0x0/0x99 @ 1
initcall ioapic_init_sysfs+0x0/0x99 returned 0 after 165 usecs
calling  add_pcspkr+0x0/0x28 @ 1
initcall add_pcspkr+0x0/0x28 returned 0 after 62 usecs
calling  audit_classes_init+0x0/0xaf @ 1
initcall audit_classes_init+0x0/0xaf returned 0 after 7 usecs
calling  init_vdso_vars+0x0/0x19d @ 1
initcall init_vdso_vars+0x0/0x19d returned 0 after 15 usecs
calling  ia32_binfmt_init+0x0/0x14 @ 1
initcall ia32_binfmt_init+0x0/0x14 returned 0 after 1 usecs
calling  sysenter_setup+0x0/0x2cc @ 1
initcall sysenter_setup+0x0/0x2cc returned 0 after 5 usecs
calling  init_sched_debug_procfs+0x0/0x29 @ 1
initcall init_sched_debug_procfs+0x0/0x29 returned 0 after 7 usecs
calling  proc_schedstat_init+0x0/0x1f @ 1
initcall proc_schedstat_init+0x0/0x1f returned 0 after 1 usecs
calling  proc_execdomains_init+0x0/0x22 @ 1
initcall proc_execdomains_init+0x0/0x22 returned 0 after 2 usecs
calling  ioresources_init+0x0/0x36 @ 1
initcall ioresources_init+0x0/0x36 returned 0 after 3 usecs
calling  uid_cache_init+0x0/0x6e @ 1
initcall uid_cache_init+0x0/0x6e returned 0 after 8 usecs
calling  init_posix_timers+0x0/0x1b5 @ 1
initcall init_posix_timers+0x0/0x1b5 returned 0 after 2 usecs
calling  init_posix_cpu_timers+0x0/0x101 @ 1
initcall init_posix_cpu_timers+0x0/0x101 returned 0 after 1 usecs
calling  nsproxy_cache_init+0x0/0x2d @ 1
initcall nsproxy_cache_init+0x0/0x2d returned 0 after 1 usecs
calling  create_proc_profile+0x0/0x236 @ 1
initcall create_proc_profile+0x0/0x236 returned 0 after 0 usecs
calling  timekeeping_init_device+0x0/0x22 @ 1
initcall timekeeping_init_device+0x0/0x22 returned 0 after 111 usecs
calling  init_clocksource_sysfs+0x0/0x50 @ 1
initcall init_clocksource_sysfs+0x0/0x50 returned 0 after 107 usecs
calling  init_timer_list_procfs+0x0/0x2c @ 1
initcall init_timer_list_procfs+0x0/0x2c returned 0 after 2 usecs
calling  init_tstats_procfs+0x0/0x2c @ 1
initcall init_tstats_procfs+0x0/0x2c returned 0 after 2 usecs
calling  futex_init+0x0/0x63 @ 1
initcall futex_init+0x0/0x63 returned 0 after 10 usecs
calling  proc_dma_init+0x0/0x22 @ 1
initcall proc_dma_init+0x0/0x22 returned 0 after 1 usecs
calling  proc_modules_init+0x0/0x22 @ 1
initcall proc_modules_init+0x0/0x22 returned 0 after 2 usecs
calling  kallsyms_init+0x0/0x25 @ 1
initcall kallsyms_init+0x0/0x25 returned 0 after 1 usecs
calling  snapshot_device_init+0x0/0x12 @ 1
initcall snapshot_device_init+0x0/0x12 returned 0 after 61 usecs
calling  crash_save_vmcoreinfo_init+0x0/0x46d @ 1
initcall crash_save_vmcoreinfo_init+0x0/0x46d returned 0 after 22 usecs
calling  crash_notes_memory_init+0x0/0x36 @ 1
initcall crash_notes_memory_init+0x0/0x36 returned 0 after 6 usecs
calling  pid_namespaces_init+0x0/0x2d @ 1
initcall pid_namespaces_init+0x0/0x2d returned 0 after 8 usecs
calling  ikconfig_init+0x0/0x39 @ 1
initcall ikconfig_init+0x0/0x39 returned 0 after 2 usecs
calling  audit_init+0x0/0x133 @ 1
audit: initializing netlink socket (disabled)
type=2000 audit(1268057623.500:1): initialized
initcall audit_init+0x0/0x133 returned 0 after 27144 usecs
calling  audit_tree_init+0x0/0x49 @ 1
initcall audit_tree_init+0x0/0x49 returned 0 after 2 usecs
calling  init_kprobes+0x0/0x182 @ 1
initcall init_kprobes+0x0/0x182 returned 0 after 16018 usecs
calling  hung_task_init+0x0/0x53 @ 1
initcall hung_task_init+0x0/0x53 returned 0 after 41 usecs
calling  utsname_sysctl_init+0x0/0x14 @ 1
initcall utsname_sysctl_init+0x0/0x14 returned 0 after 2 usecs
calling  init_tracepoints+0x0/0x12 @ 1
initcall init_tracepoints+0x0/0x12 returned 0 after 0 usecs
calling  init_lstats_procfs+0x0/0x25 @ 1
initcall init_lstats_procfs+0x0/0x25 returned 0 after 3 usecs
calling  init_events+0x0/0x5f @ 1
initcall init_events+0x0/0x5f returned 0 after 2 usecs
calling  init_sched_switch_trace+0x0/0x12 @ 1
initcall init_sched_switch_trace+0x0/0x12 returned 0 after 2 usecs
calling  init_stack_trace+0x0/0x12 @ 1
initcall init_stack_trace+0x0/0x12 returned 0 after 1 usecs
calling  init_irqsoff_tracer+0x0/0x14 @ 1
initcall init_irqsoff_tracer+0x0/0x14 returned 0 after 0 usecs
calling  init_wakeup_tracer+0x0/0x22 @ 1
initcall init_wakeup_tracer+0x0/0x22 returned 0 after 1 usecs
calling  init_blk_tracer+0x0/0x57 @ 1
initcall init_blk_tracer+0x0/0x57 returned 0 after 1 usecs
calling  perf_event_sysfs_init+0x0/0x19 @ 1
initcall perf_event_sysfs_init+0x0/0x19 returned 0 after 3 usecs
calling  init_per_zone_wmark_min+0x0/0x70 @ 1
initcall init_per_zone_wmark_min+0x0/0x70 returned 0 after 488 usecs
calling  kswapd_init+0x0/0x4d @ 1
initcall kswapd_init+0x0/0x4d returned 0 after 80 usecs
calling  setup_vmstat+0x0/0xae @ 1
initcall setup_vmstat+0x0/0xae returned 0 after 13 usecs
calling  mm_sysfs_init+0x0/0x29 @ 1
initcall mm_sysfs_init+0x0/0x29 returned 0 after 3 usecs
calling  proc_vmalloc_init+0x0/0x25 @ 1
initcall proc_vmalloc_init+0x0/0x25 returned 0 after 2 usecs
calling  procswaps_init+0x0/0x22 @ 1
initcall procswaps_init+0x0/0x22 returned 0 after 2 usecs
calling  hugetlb_init+0x0/0x329 @ 1
HugeTLB registered 2 MB page size, pre-allocated 0 pages
initcall hugetlb_init+0x0/0x329 returned 0 after 27375 usecs
calling  slab_proc_init+0x0/0x25 @ 1
initcall slab_proc_init+0x0/0x25 returned 0 after 2 usecs
calling  slab_sysfs_init+0x0/0xf0 @ 1
initcall slab_sysfs_init+0x0/0xf0 returned 0 after 3460 usecs
calling  fasync_init+0x0/0x2a @ 1
initcall fasync_init+0x0/0x2a returned 0 after 3 usecs
calling  proc_filesystems_init+0x0/0x22 @ 1
initcall proc_filesystems_init+0x0/0x22 returned 0 after 3 usecs
calling  dnotify_init+0x0/0x80 @ 1
initcall dnotify_init+0x0/0x80 returned 0 after 8 usecs
calling  inotify_setup+0x0/0x12 @ 1
initcall inotify_setup+0x0/0x12 returned 0 after 0 usecs
calling  inotify_user_setup+0x0/0x70 @ 1
initcall inotify_user_setup+0x0/0x70 returned 0 after 6 usecs
calling  aio_setup+0x0/0x9e @ 1
initcall aio_setup+0x0/0x9e returned 0 after 146 usecs
calling  proc_locks_init+0x0/0x22 @ 1
initcall proc_locks_init+0x0/0x22 returned 0 after 2 usecs
calling  init_sys32_ioctl+0x0/0x28 @ 1
initcall init_sys32_ioctl+0x0/0x28 returned 0 after 73 usecs
calling  init_mbcache+0x0/0x14 @ 1
initcall init_mbcache+0x0/0x14 returned 0 after 1 usecs
calling  dquot_init+0x0/0xe0 @ 1
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
initcall dquot_init+0x0/0xe0 returned 0 after 28692 usecs
calling  init_v2_quota_format+0x0/0x22 @ 1
initcall init_v2_quota_format+0x0/0x22 returned 0 after 1 usecs
calling  quota_init+0x0/0x26 @ 1
initcall quota_init+0x0/0x26 returned 0 after 7 usecs
calling  proc_cmdline_init+0x0/0x22 @ 1
initcall proc_cmdline_init+0x0/0x22 returned 0 after 3 usecs
calling  proc_cpuinfo_init+0x0/0x22 @ 1
initcall proc_cpuinfo_init+0x0/0x22 returned 0 after 2 usecs
calling  proc_devices_init+0x0/0x22 @ 1
initcall proc_devices_init+0x0/0x22 returned 0 after 1 usecs
calling  proc_interrupts_init+0x0/0x22 @ 1
initcall proc_interrupts_init+0x0/0x22 returned 0 after 1 usecs
calling  proc_loadavg_init+0x0/0x22 @ 1
initcall proc_loadavg_init+0x0/0x22 returned 0 after 2 usecs
calling  proc_meminfo_init+0x0/0x22 @ 1
initcall proc_meminfo_init+0x0/0x22 returned 0 after 2 usecs
calling  proc_stat_init+0x0/0x22 @ 1
initcall proc_stat_init+0x0/0x22 returned 0 after 1 usecs
calling  proc_uptime_init+0x0/0x22 @ 1
initcall proc_uptime_init+0x0/0x22 returned 0 after 2 usecs
calling  proc_version_init+0x0/0x22 @ 1
initcall proc_version_init+0x0/0x22 returned 0 after 3 usecs
calling  proc_softirqs_init+0x0/0x22 @ 1
initcall proc_softirqs_init+0x0/0x22 returned 0 after 3 usecs
calling  proc_kcore_init+0x0/0xa9 @ 1
initcall proc_kcore_init+0x0/0xa9 returned 0 after 10 usecs
calling  vmcore_init+0x0/0x8e2 @ 1
initcall vmcore_init+0x0/0x8e2 returned 0 after 0 usecs
calling  proc_kmsg_init+0x0/0x25 @ 1
initcall proc_kmsg_init+0x0/0x25 returned 0 after 2 usecs
calling  proc_page_init+0x0/0x3c @ 1
initcall proc_page_init+0x0/0x3c returned 0 after 3 usecs
calling  init_devpts_fs+0x0/0x4d @ 1
initcall init_devpts_fs+0x0/0x4d returned 0 after 17 usecs
calling  init_ext3_fs+0x0/0x6b @ 1
initcall init_ext3_fs+0x0/0x6b returned 0 after 149 usecs
calling  journal_init+0x0/0x99 @ 1
initcall journal_init+0x0/0x99 returned 0 after 354 usecs
calling  init_ramfs_fs+0x0/0x12 @ 1
initcall init_ramfs_fs+0x0/0x12 returned 0 after 5 usecs
calling  init_hugetlbfs_fs+0x0/0x98 @ 1
initcall init_hugetlbfs_fs+0x0/0x98 returned 0 after 120 usecs
calling  init_iso9660_fs+0x0/0x6c @ 1
initcall init_iso9660_fs+0x0/0x6c returned 0 after 89 usecs
calling  init_nls_cp437+0x0/0x12 @ 1
initcall init_nls_cp437+0x0/0x12 returned 0 after 1 usecs
calling  init_nls_ascii+0x0/0x12 @ 1
initcall init_nls_ascii+0x0/0x12 returned 0 after 0 usecs
calling  ipc_init+0x0/0x23 @ 1
msgmni has been set to 16001
initcall ipc_init+0x0/0x23 returned 0 after 14291 usecs
calling  ipc_sysctl_init+0x0/0x14 @ 1
initcall ipc_sysctl_init+0x0/0x14 returned 0 after 2 usecs
calling  init_mqueue_fs+0x0/0xb4 @ 1
initcall init_mqueue_fs+0x0/0xb4 returned 0 after 99 usecs
calling  key_proc_init+0x0/0x53 @ 1
initcall key_proc_init+0x0/0x53 returned 0 after 4 usecs
calling  selinux_nf_ip_init+0x0/0x60 @ 1
initcall selinux_nf_ip_init+0x0/0x60 returned 0 after 0 usecs
calling  init_sel_fs+0x0/0x69 @ 1
initcall init_sel_fs+0x0/0x69 returned 0 after 0 usecs
calling  selnl_init+0x0/0x4d @ 1
initcall selnl_init+0x0/0x4d returned 0 after 4 usecs
calling  sel_netif_init+0x0/0x66 @ 1
initcall sel_netif_init+0x0/0x66 returned 0 after 0 usecs
calling  sel_netnode_init+0x0/0x72 @ 1
initcall sel_netnode_init+0x0/0x72 returned 0 after 0 usecs
calling  sel_netport_init+0x0/0x72 @ 1
initcall sel_netport_init+0x0/0x72 returned 0 after 0 usecs
calling  aurule_init+0x0/0x37 @ 1
initcall aurule_init+0x0/0x37 returned 0 after 1 usecs
calling  crypto_wq_init+0x0/0x2e @ 1
initcall crypto_wq_init+0x0/0x2e returned 0 after 128 usecs
calling  crypto_algapi_init+0x0/0xd @ 1
initcall crypto_algapi_init+0x0/0xd returned 0 after 2 usecs
calling  skcipher_module_init+0x0/0x34 @ 1
initcall skcipher_module_init+0x0/0x34 returned 0 after 0 usecs
calling  chainiv_module_init+0x0/0x12 @ 1
initcall chainiv_module_init+0x0/0x12 returned 0 after 2 usecs
calling  eseqiv_module_init+0x0/0x12 @ 1
initcall eseqiv_module_init+0x0/0x12 returned 0 after 0 usecs
calling  hmac_module_init+0x0/0x12 @ 1
initcall hmac_module_init+0x0/0x12 returned 0 after 11 usecs
calling  md5_mod_init+0x0/0x12 @ 1
initcall md5_mod_init+0x0/0x12 returned 0 after 82 usecs
calling  sha1_generic_mod_init+0x0/0x12 @ 1
initcall sha1_generic_mod_init+0x0/0x12 returned 0 after 52 usecs
calling  krng_mod_init+0x0/0x12 @ 1
alg: No test for stdrng (krng)
initcall krng_mod_init+0x0/0x12 returned 0 after 2118 usecs
calling  proc_genhd_init+0x0/0x36 @ 1
initcall proc_genhd_init+0x0/0x36 returned 0 after 3 usecs
calling  bsg_init+0x0/0x12e @ 1
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
initcall bsg_init+0x0/0x12e returned 0 after 33601 usecs
calling  noop_init+0x0/0x14 @ 1
io scheduler noop registered
initcall noop_init+0x0/0x14 returned 0 after 2948 usecs
calling  deadline_init+0x0/0x14 @ 1
io scheduler deadline registered
initcall deadline_init+0x0/0x14 returned 0 after 15638 usecs
calling  cfq_init+0x0/0x94 @ 1
io scheduler cfq registered (default)
initcall cfq_init+0x0/0x94 returned 0 after 12038 usecs
calling  percpu_counter_startup+0x0/0x19 @ 1
initcall percpu_counter_startup+0x0/0x19 returned 0 after 1 usecs
calling  pci_proc_init+0x0/0x6a @ 1
initcall pci_proc_init+0x0/0x6a returned 0 after 108 usecs
calling  pcie_portdrv_init+0x0/0x58 @ 1
pcieport 0000:00:0b.0: setting latency timer to 64
pcieport 0000:00:0b.0: irq 62 for MSI/MSI-X
pcieport 0000:00:0c.0: setting latency timer to 64
pcieport 0000:00:0c.0: irq 63 for MSI/MSI-X
pcieport 0000:00:0d.0: setting latency timer to 64
pcieport 0000:00:0d.0: irq 64 for MSI/MSI-X
pcieport 0000:00:0e.0: setting latency timer to 64
pcieport 0000:00:0e.0: irq 65 for MSI/MSI-X
pcieport 0000:40:0c.0: setting latency timer to 64
pcieport 0000:40:0c.0: irq 66 for MSI/MSI-X
pcieport 0000:40:0d.0: setting latency timer to 64
pcieport 0000:40:0d.0: irq 67 for MSI/MSI-X
pcieport 0000:40:0e.0: setting latency timer to 64
pcieport 0000:40:0e.0: irq 68 for MSI/MSI-X
initcall pcie_portdrv_init+0x0/0x58 returned 0 after 254621 usecs
calling  aer_service_init+0x0/0x2b @ 1
aer 0000:00:0b.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:00:0c.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:00:0d.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:00:0e.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:40:0c.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:40:0d.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:40:0e.0:pcie02: AER service couldn't init device: no _OSC support
initcall aer_service_init+0x0/0x2b returned 0 after 226624 usecs
calling  ioapic_init+0x0/0x1b @ 1
initcall ioapic_init+0x0/0x1b returned 0 after 58 usecs
calling  pci_hotplug_init+0x0/0x1d @ 1
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
initcall pci_hotplug_init+0x0/0x1d returned 0 after 24360 usecs
calling  acpiphp_init+0x0/0x5f @ 1
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
initcall acpiphp_init+0x0/0x5f returned -19 after 28274 usecs
calling  fb_console_init+0x0/0x12a @ 1
initcall fb_console_init+0x0/0x12a returned 0 after 59 usecs
calling  genericbl_init+0x0/0x12 @ 1
initcall genericbl_init+0x0/0x12 returned 0 after 55 usecs
calling  xenfb_init+0x0/0x44 @ 1
initcall xenfb_init+0x0/0x44 returned -19 after 0 usecs
calling  vesafb_init+0x0/0x235 @ 1
initcall vesafb_init+0x0/0x235 returned 0 after 123 usecs
calling  efifb_init+0x0/0x1f2 @ 1
initcall efifb_init+0x0/0x1f2 returned -19 after 3 usecs
calling  acpi_reserve_resources+0x0/0xeb @ 1
initcall acpi_reserve_resources+0x0/0xeb returned 0 after 4 usecs
calling  irqrouter_init_sysfs+0x0/0x38 @ 1
initcall irqrouter_init_sysfs+0x0/0x38 returned 0 after 103 usecs
calling  acpi_button_init+0x0/0x56 @ 1
input: Power Button as /class/input/input0
ACPI: Power Button [PWRF]
initcall acpi_button_init+0x0/0x56 returned 0 after 34921 usecs
calling  acpi_fan_init+0x0/0x56 @ 1
initcall acpi_fan_init+0x0/0x56 returned 0 after 66 usecs
calling  acpi_processor_init+0x0/0x10a @ 1
initcall acpi_processor_init+0x0/0x10a returned 0 after 661 usecs
calling  acpi_container_init+0x0/0x4a @ 1
initcall acpi_container_init+0x0/0x4a returned 0 after 1065 usecs
calling  acpi_thermal_init+0x0/0x7b @ 1
initcall acpi_thermal_init+0x0/0x7b returned 0 after 70 usecs
calling  evtchn_init+0x0/0x61 @ 1
initcall evtchn_init+0x0/0x61 returned -19 after 0 usecs
calling  xenfs_init+0x0/0x2d @ 1
XENFS: not registering filesystem on non-xen platform
initcall xenfs_init+0x0/0x2d returned 0 after 27283 usecs
calling  hypervisor_subsys_init+0x0/0x25 @ 1
initcall hypervisor_subsys_init+0x0/0x25 returned -19 after 0 usecs
calling  hyper_sysfs_init+0x0/0xb3 @ 1
initcall hyper_sysfs_init+0x0/0xb3 returned -19 after 0 usecs
calling  rand_initialize+0x0/0x2c @ 1
initcall rand_initialize+0x0/0x2c returned 0 after 16 usecs
calling  tty_init+0x0/0xf5 @ 1
initcall tty_init+0x0/0xf5 returned 0 after 3751 usecs
calling  pty_init+0x0/0x284 @ 1
initcall pty_init+0x0/0x284 returned 0 after 71 usecs
calling  sysrq_init+0x0/0x25 @ 1
initcall sysrq_init+0x0/0x25 returned 0 after 15 usecs
calling  xen_init+0x0/0x78 @ 1
initcall xen_init+0x0/0x78 returned -19 after 0 usecs
calling  raw_init+0x0/0xe5 @ 1
initcall raw_init+0x0/0xe5 returned 0 after 103 usecs
calling  hpet_init+0x0/0x6a @ 1
initcall hpet_init+0x0/0x6a returned 0 after 241 usecs
calling  nvram_init+0x0/0x82 @ 1
Non-volatile memory driver v1.3
initcall nvram_init+0x0/0x82 returned 0 after 16570 usecs
calling  mod_init+0x0/0x4d @ 1
initcall mod_init+0x0/0x4d returned -19 after 0 usecs
calling  agp_init+0x0/0x26 @ 1
Linux agpgart interface v0.103
initcall agp_init+0x0/0x26 returned 0 after 15625 usecs
calling  agp_amd64_mod_init+0x0/0x22 @ 1
initcall agp_amd64_mod_init+0x0/0x22 returned -19 after 0 usecs
calling  agp_intel_init+0x0/0x29 @ 1
initcall agp_intel_init+0x0/0x29 returned 0 after 78 usecs
calling  agp_sis_init+0x0/0x29 @ 1
initcall agp_sis_init+0x0/0x29 returned 0 after 57 usecs
calling  agp_via_init+0x0/0x29 @ 1
initcall agp_via_init+0x0/0x29 returned 0 after 58 usecs
calling  drm_core_init+0x0/0x124 @ 1
[drm] Initialized drm 1.1.0 20060810
initcall drm_core_init+0x0/0x124 returned 0 after 18225 usecs
calling  cn_proc_init+0x0/0x3d @ 1
initcall cn_proc_init+0x0/0x3d returned 0 after 2 usecs
calling  serial8250_init+0x0/0x161 @ 1
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
async_waiting @ 1
async_continuing @ 1 after 0 usec
async_waiting @ 1
async_continuing @ 1 after 0 usec
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
async_waiting @ 1
async_continuing @ 1 after 0 usec
async_waiting @ 1
async_continuing @ 1 after 0 usec
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
initcall serial8250_init+0x0/0x161 returned 0 after 646274 usecs
calling  serial8250_pnp_init+0x0/0x12 @ 1
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
initcall serial8250_pnp_init+0x0/0x12 returned 0 after 20884 usecs
calling  serial8250_pci_init+0x0/0x1b @ 1
initcall serial8250_pci_init+0x0/0x1b returned 0 after 112 usecs
calling  init_kgdboc+0x0/0x16 @ 1
initcall init_kgdboc+0x0/0x16 returned 0 after 1 usecs
calling  topology_sysfs_init+0x0/0x4e @ 1
initcall topology_sysfs_init+0x0/0x4e returned 0 after 24 usecs
calling  brd_init+0x0/0x160 @ 1
brd: module loaded
initcall brd_init+0x0/0x160 returned 0 after 10805 usecs
calling  loop_init+0x0/0x189 @ 1
loop: module loaded
initcall loop_init+0x0/0x189 returned 0 after 10745 usecs
calling  init_kgdbts+0x0/0x16 @ 1
initcall init_kgdbts+0x0/0x16 returned 0 after 1 usecs
calling  mac_hid_init+0x0/0x22 @ 1
initcall mac_hid_init+0x0/0x22 returned 0 after 5 usecs
calling  scsi_dh_init+0x0/0x3f @ 1
initcall scsi_dh_init+0x0/0x3f returned 0 after 1 usecs
calling  init_sd+0x0/0x181 @ 1
initcall init_sd+0x0/0x181 returned 0 after 127 usecs
calling  init_sr+0x0/0x49 @ 1
initcall init_sr+0x0/0x49 returned 0 after 51 usecs
calling  init_sg+0x0/0x122 @ 1
initcall init_sg+0x0/0x122 returned 0 after 66 usecs
calling  ahci_init+0x0/0x1b @ 1
initcall ahci_init+0x0/0x1b returned 0 after 150 usecs
calling  bnx2_init+0x0/0x1b @ 1
bnx2: Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v2.0.8 (Feb 15, 2010)
ACPI: PCI Interrupt Link [LNKX] enabled at IRQ 17
bnx2 0000:03:00.0: PCI INT A -> Link[LNKX] -> GSI 17 (level, high) -> IRQ 17
bnx2 0000:03:00.0: firmware: using built-in firmware bnx2/bnx2-mips-06-5.0.0.j6.fw
bnx2 0000:03:00.0: firmware: using built-in firmware bnx2/bnx2-rv2p-06-5.0.0.j3.fw
bnx2 0000:03:00.0: eth0: Broadcom NetXtreme II BCM5708 1000Base-SX (B2) PCI-X 64-bit 133MHz found at mem f8000000, IRQ 17, node addr 00:18:fe:35:26:f6
ACPI: PCI Interrupt Link [LNKW] enabled at IRQ 16
bnx2 0000:05:00.0: PCI INT A -> Link[LNKW] -> GSI 16 (level, high) -> IRQ 16
bnx2 0000:05:00.0: firmware: using built-in firmware bnx2/bnx2-mips-06-5.0.0.j6.fw
bnx2 0000:05:00.0: firmware: using built-in firmware bnx2/bnx2-rv2p-06-5.0.0.j3.fw
bnx2 0000:05:00.0: eth1: Broadcom NetXtreme II BCM5708 1000Base-SX (B2) PCI-X 64-bit 133MHz found at mem fa000000, IRQ 16, node addr 00:18:fe:35:26:f4
initcall bnx2_init+0x0/0x1b returned 0 after 484064 usecs
calling  net_olddevs_init+0x0/0xa0 @ 1
initcall net_olddevs_init+0x0/0xa0 returned 0 after 5 usecs
calling  init_netconsole+0x0/0x1dd @ 1
netconsole: local port 56816
netconsole: local IP 139.185.50.77
netconsole: interface eth0
netconsole: remote port 56816
netconsole: remote IP 139.185.50.76
netconsole: remote ethernet address 00:18:fe:34:1c:3d
netconsole: device eth0 not up yet, forcing it
bnx2 0000:03:00.0: irq 69 for MSI/MSI-X
bnx2 0000:03:00.0: eth0: using MSI
bnx2 0000:03:00.0: eth0: NIC SerDes Link is Up, 1000 Mbps full duplex
netconsole: carrier detect appears untrustworthy, waiting 4 seconds
, receive & transmit flow control ON
bnx2 0000:03:00.0: eth0: NIC SerDes Link is Down
bnx2 0000:03:00.0: eth0: NIC SerDes Link is Up, 1000 Mbps full duplex, receive & transmit flow control ON
Clocksource tsc unstable (delta = 4398045021716 ns)
console [netcon0] enabled
netconsole: network logging started
initcall init_netconsole+0x0/0x1dd returned 0 after 34690244 usecs
calling  cdrom_init+0x0/0xd @ 1
initcall cdrom_init+0x0/0xd returned 0 after 16 usecs
calling  mon_init+0x0/0x103 @ 1
initcall mon_init+0x0/0x103 returned 0 after 164 usecs
calling  i8042_init+0x0/0x3f9 @ 1
PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
initcall i8042_init+0x0/0x3f9 returned 0 after 54763 usecs
calling  serport_init+0x0/0x34 @ 1
initcall serport_init+0x0/0x34 returned 0 after 1 usecs
calling  mousedev_init+0x0/0x61 @ 1
mice: PS/2 mouse device common for all mice
initcall mousedev_init+0x0/0x61 returned 0 after 21870 usecs
calling  evdev_init+0x0/0x12 @ 1
initcall evdev_init+0x0/0x12 returned 0 after 80 usecs
calling  atkbd_init+0x0/0x27 @ 1
initcall atkbd_init+0x0/0x27 returned 0 after 72 usecs
calling  psmouse_init+0x0/0x7a @ 1
initcall psmouse_init+0x0/0x7a returned 0 after 118 usecs
calling  xenkbd_init+0x0/0x44 @ 1
initcall xenkbd_init+0x0/0x44 returned -19 after 0 usecs
calling  cmos_init+0x0/0x6d @ 1
rtc_cmos rtc_cmos: RTC can wake from S4
rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
initcall cmos_init+0x0/0x6d returned 0 after 67169 usecs
calling  dm_init+0x0/0x49 @ 1
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
initcall dm_init+0x0/0x49 returned 0 after 36628 usecs
calling  cpufreq_gov_powersave_init+0x0/0x12 @ 1
initcall cpufreq_gov_powersave_init+0x0/0x12 returned 0 after 1 usecs
calling  cpufreq_gov_userspace_init+0x0/0x12 @ 1
initcall cpufreq_gov_userspace_init+0x0/0x12 returned 0 after 0 usecs
calling  cpufreq_gov_dbs_init+0x0/0x64 @ 1
initcall cpufreq_gov_dbs_init+0x0/0x64 returned 0 after 131 usecs
calling  init_ladder+0x0/0x12 @ 1
cpuidle: using governor ladder
initcall init_ladder+0x0/0x12 returned 0 after 14625 usecs
calling  init_menu+0x0/0x12 @ 1
cpuidle: using governor menu
initcall init_menu+0x0/0x12 returned 0 after 14685 usecs
calling  efivars_init+0x0/0x1f9 @ 1
initcall efivars_init+0x0/0x1f9 returned -19 after 0 usecs
calling  hid_init+0x0/0x66 @ 1
initcall hid_init+0x0/0x66 returned 0 after 146 usecs
calling  a4_init+0x0/0x1b @ 1
initcall a4_init+0x0/0x1b returned 0 after 58 usecs
calling  apple_init+0x0/0x38 @ 1
initcall apple_init+0x0/0x38 returned 0 after 62 usecs
calling  belkin_init+0x0/0x1b @ 1
initcall belkin_init+0x0/0x1b returned 0 after 58 usecs
calling  ch_init+0x0/0x1b @ 1
initcall ch_init+0x0/0x1b returned 0 after 59 usecs
calling  ch_init+0x0/0x1b @ 1
initcall ch_init+0x0/0x1b returned 0 after 56 usecs
calling  cp_init+0x0/0x1b @ 1
initcall cp_init+0x0/0x1b returned 0 after 58 usecs
calling  dr_init+0x0/0x1b @ 1
initcall dr_init+0x0/0x1b returned 0 after 59 usecs
calling  ez_init+0x0/0x1b @ 1
initcall ez_init+0x0/0x1b returned 0 after 60 usecs
calling  gyration_init+0x0/0x1b @ 1
initcall gyration_init+0x0/0x1b returned 0 after 58 usecs
calling  ks_init+0x0/0x1b @ 1
initcall ks_init+0x0/0x1b returned 0 after 58 usecs
calling  kye_init+0x0/0x1b @ 1
initcall kye_init+0x0/0x1b returned 0 after 57 usecs
calling  lg_init+0x0/0x1b @ 1
initcall lg_init+0x0/0x1b returned 0 after 56 usecs
calling  ms_init+0x0/0x1b @ 1
initcall ms_init+0x0/0x1b returned 0 after 57 usecs
calling  mr_init+0x0/0x1b @ 1
initcall mr_init+0x0/0x1b returned 0 after 60 usecs
calling  ntrig_init+0x0/0x1b @ 1
initcall ntrig_init+0x0/0x1b returned 0 after 59 usecs
calling  ortek_init+0x0/0x1b @ 1
initcall ortek_init+0x0/0x1b returned 0 after 57 usecs
calling  pl_init+0x0/0x1b @ 1
initcall pl_init+0x0/0x1b returned 0 after 57 usecs
calling  pl_init+0x0/0x1b @ 1
initcall pl_init+0x0/0x1b returned 0 after 58 usecs
calling  samsung_init+0x0/0x1b @ 1
initcall samsung_init+0x0/0x1b returned 0 after 61 usecs
calling  sjoy_init+0x0/0x1b @ 1
initcall sjoy_init+0x0/0x1b returned 0 after 59 usecs
calling  sony_init+0x0/0x1b @ 1
initcall sony_init+0x0/0x1b returned 0 after 58 usecs
calling  sp_init+0x0/0x1b @ 1
initcall sp_init+0x0/0x1b returned 0 after 57 usecs
calling  ga_init+0x0/0x1b @ 1
initcall ga_init+0x0/0x1b returned 0 after 57 usecs
calling  tm_init+0x0/0x1b @ 1
initcall tm_init+0x0/0x1b returned 0 after 61 usecs
calling  ts_init+0x0/0x1b @ 1
initcall ts_init+0x0/0x1b returned 0 after 58 usecs
calling  twinhan_init+0x0/0x1b @ 1
initcall twinhan_init+0x0/0x1b returned 0 after 58 usecs
calling  zp_init+0x0/0x1b @ 1
initcall zp_init+0x0/0x1b returned 0 after 59 usecs
calling  hid_init+0x0/0xc7 @ 1
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
initcall hid_init+0x0/0xc7 returned 0 after 52017 usecs
calling  flow_cache_init+0x0/0x187 @ 1
initcall flow_cache_init+0x0/0x187 returned 0 after 26 usecs
calling  llc_init+0x0/0x20 @ 1
initcall llc_init+0x0/0x20 returned 0 after 1 usecs
calling  snap_init+0x0/0x38 @ 1
initcall snap_init+0x0/0x38 returned 0 after 3 usecs
calling  rif_init+0x0/0x84 @ 1
initcall rif_init+0x0/0x84 returned 0 after 12 usecs
calling  blackhole_module_init+0x0/0x12 @ 1
initcall blackhole_module_init+0x0/0x12 returned 0 after 1 usecs
calling  nf_conntrack_standalone_init+0x0/0x12 @ 1
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
initcall nf_conntrack_standalone_init+0x0/0x12 returned 0 after 91693 usecs
calling  xt_init+0x0/0x129 @ 1
initcall xt_init+0x0/0x129 returned 0 after 2 usecs
calling  tcpudp_mt_init+0x0/0x17 @ 1
initcall tcpudp_mt_init+0x0/0x17 returned 0 after 1 usecs
calling  conntrack_mt_init+0x0/0x17 @ 1
initcall conntrack_mt_init+0x0/0x17 returned 0 after 0 usecs
calling  state_mt_init+0x0/0x17 @ 1
initcall state_mt_init+0x0/0x17 returned 0 after 1 usecs
calling  sysctl_ipv4_init+0x0/0x4e @ 1
initcall sysctl_ipv4_init+0x0/0x4e returned 0 after 7 usecs
calling  init_syncookies+0x0/0x19 @ 1
initcall init_syncookies+0x0/0x19 returned 0 after 24 usecs
calling  ipv4_netfilter_init+0x0/0x12 @ 1
initcall ipv4_netfilter_init+0x0/0x12 returned 0 after 1 usecs
calling  nf_conntrack_l3proto_ipv4_init+0x0/0x12d @ 1
initcall nf_conntrack_l3proto_ipv4_init+0x0/0x12d returned 0 after 10 usecs
calling  nf_defrag_init+0x0/0x17 @ 1
initcall nf_defrag_init+0x0/0x17 returned 0 after 0 usecs
calling  ip_tables_init+0x0/0xaf @ 1
ip_tables: (C) 2000-2006 Netfilter Core Team
initcall ip_tables_init+0x0/0xaf returned 0 after 22477 usecs
calling  iptable_filter_init+0x0/0x6f @ 1
initcall iptable_filter_init+0x0/0x6f returned 0 after 29 usecs
calling  reject_tg_init+0x0/0x12 @ 1
initcall reject_tg_init+0x0/0x12 returned 0 after 9 usecs
calling  cubictcp_register+0x0/0x6e @ 1
TCP cubic registered
initcall cubictcp_register+0x0/0x6e returned 0 after 8944 usecs
calling  xfrm_user_init+0x0/0x4d @ 1
Initializing XFRM netlink socket
initcall xfrm_user_init+0x0/0x4d returned 0 after 15758 usecs
calling  packet_init+0x0/0x47 @ 1
NET: Registered protocol family 17
initcall packet_init+0x0/0x47 returned 0 after 16741 usecs
calling  mcheck_debugfs_init+0x0/0x3b @ 1
initcall mcheck_debugfs_init+0x0/0x3b returned 0 after 15 usecs
calling  severities_debugfs_init+0x0/0x3b @ 1
initcall severities_debugfs_init+0x0/0x3b returned 0 after 2 usecs
calling  hpet_insert_resource+0x0/0x23 @ 1
initcall hpet_insert_resource+0x0/0x23 returned 0 after 1 usecs
calling  update_mp_table+0x0/0x470 @ 1
initcall update_mp_table+0x0/0x470 returned 0 after 0 usecs
calling  lapic_insert_resource+0x0/0x40 @ 1
initcall lapic_insert_resource+0x0/0x40 returned 0 after 1 usecs
calling  init_lapic_nmi_sysfs+0x0/0x39 @ 1
initcall init_lapic_nmi_sysfs+0x0/0x39 returned 0 after 113 usecs
calling  io_apic_bug_finalize+0x0/0x1b @ 1
initcall io_apic_bug_finalize+0x0/0x1b returned 0 after 0 usecs
calling  check_early_ioremap_leak+0x0/0x65 @ 1
initcall check_early_ioremap_leak+0x0/0x65 returned 0 after 0 usecs
calling  pat_memtype_list_init+0x0/0x32 @ 1
initcall pat_memtype_list_init+0x0/0x32 returned 0 after 3 usecs
calling  sched_init_debug+0x0/0x24 @ 1
initcall sched_init_debug+0x0/0x24 returned 0 after 2 usecs
calling  init_oops_id+0x0/0x31 @ 1
initcall init_oops_id+0x0/0x31 returned 0 after 2 usecs
calling  disable_boot_consoles+0x0/0x45 @ 1
initcall disable_boot_consoles+0x0/0x45 returned 0 after 0 usecs
calling  pm_qos_power_init+0x0/0x61 @ 1
initcall pm_qos_power_init+0x0/0x61 returned 0 after 194 usecs
calling  software_resume+0x0/0x1ec @ 1
PM: Resume from disk failed.
initcall software_resume+0x0/0x1ec returned -2 after 14667 usecs
initcall software_resume+0x0/0x1ec returned with error code -2 
calling  debugfs_kprobe_init+0x0/0x89 @ 1
initcall debugfs_kprobe_init+0x0/0x89 returned 0 after 26 usecs
calling  taskstats_init+0x0/0x95 @ 1
registered taskstats version 1
initcall taskstats_init+0x0/0x95 returned 0 after 15620 usecs
calling  clear_boot_tracer+0x0/0x2d @ 1
initcall clear_boot_tracer+0x0/0x2d returned 0 after 0 usecs
calling  max_swapfiles_check+0x0/0x8 @ 1
initcall max_swapfiles_check+0x0/0x8 returned 0 after 0 usecs
calling  random32_reseed+0x0/0x92 @ 1
initcall random32_reseed+0x0/0x92 returned 0 after 15 usecs
calling  pci_resource_alignment_sysfs_init+0x0/0x19 @ 1
initcall pci_resource_alignment_sysfs_init+0x0/0x19 returned 0 after 2 usecs
calling  pci_sysfs_init+0x0/0x4c @ 1
initcall pci_sysfs_init+0x0/0x4c returned 0 after 350 usecs
calling  boot_wait_for_devices+0x0/0x19 @ 1
initcall boot_wait_for_devices+0x0/0x19 returned 0 after 0 usecs
calling  seqgen_init+0x0/0xf @ 1
initcall seqgen_init+0x0/0xf returned 0 after 9 usecs
calling  late_resume_init+0x0/0xf4 @ 1
  Magic number: 2:234:232
initcall late_resume_init+0x0/0xf4 returned 0 after 13750 usecs
calling  scsi_complete_async_scans+0x0/0xf7 @ 1
initcall scsi_complete_async_scans+0x0/0xf7 returned 0 after 0 usecs
calling  memmap_init+0x0/0x3b @ 1
initcall memmap_init+0x0/0x3b returned 0 after 32 usecs
calling  pci_mmcfg_late_insert_resources+0x0/0x66 @ 1
initcall pci_mmcfg_late_insert_resources+0x0/0x66 returned 0 after 1 usecs
calling  tcp_congestion_default+0x0/0x12 @ 1
initcall tcp_congestion_default+0x0/0x12 returned 0 after 1 usecs
calling  initialize_hashrnd+0x0/0x19 @ 1
initcall initialize_hashrnd+0x0/0x19 returned 0 after 3 usecs
async_waiting @ 1
async_continuing @ 1 after 0 usec
Freeing unused kernel memory: 1292k freed
Write protecting the kernel read-only data: 8192k
Freeing unused kernel memory: 232k freed
Freeing unused kernel memory: 1920k freed
calling  ehci_hcd_init+0x0/0x76 [ehci_hcd] @ 743
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ACPI: PCI Interrupt Link [LNU2] enabled at IRQ 23
ehci_hcd 0000:00:02.1: PCI INT B -> Link[LNU2] -> GSI 23 (level, high) -> IRQ 23
ehci_hcd 0000:00:02.1: setting latency timer to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: debug port 1
ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
ehci_hcd 0000:00:02.1: irq 23, io mem 0xf7dd0000
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.34-rc1 ehci_hcd
usb usb1: SerialNumber: 0000:00:02.1
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
initcall ehci_hcd_init+0x0/0x76 [ehci_hcd] returned 0 after 386787 usecs
calling  ohci_hcd_mod_init+0x0/0x59 [ohci_hcd] @ 745
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LNU0] enabled at IRQ 22
ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNU0] -> GSI 22 (level, high) -> IRQ 22
ohci_hcd 0000:00:02.0: setting latency timer to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 22, io mem 0xf7de0000
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.34-rc1 ohci_hcd
usb usb2: SerialNumber: 0000:00:02.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
initcall ohci_hcd_mod_init+0x0/0x59 [ohci_hcd] returned 0 after 398511 usecs
calling  uhci_hcd_init+0x0/0xc6 [uhci_hcd] @ 747
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:01:04.4: PCI INT B -> Link[LNKX] -> GSI 17 (level, high) -> IRQ 17
uhci_hcd 0000:01:04.4: UHCI Host Controller
uhci_hcd 0000:01:04.4: new USB bus registered, assigned bus number 3
uhci_hcd 0000:01:04.4: port count misdetected? forcing to 2 ports
uhci_hcd 0000:01:04.4: HCRESET not completed yet!
uhci_hcd 0000:01:04.4: irq 17, io base 0x00001800
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.34-rc1 uhci_hcd
usb usb3: SerialNumber: 0000:01:04.4
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
initcall uhci_hcd_init+0x0/0xc6 [uhci_hcd] returned 0 after 329181 usecs
calling  cciss_init+0x0/0xa4 [cciss] @ 749
HP CISS Driver (v 3.6.20)
cciss: using PCI PM to reset controller
usb 3-1: new full speed USB device using uhci_hcd and address 2
usb 3-1: New USB device found, idVendor=03f0, idProduct=1027
usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-1: Product: Virtual Keyboard
usb 3-1: Manufacturer: HP
input: HP Virtual Keyboard as /class/input/input1
generic-usb 0003:03F0:1027.0001: input,hidraw0: USB HID v1.01 Keyboard [HP Virtual Keyboard] on usb-0000:01:04.4-1/input0
input: HP Virtual Keyboard as /class/input/input2
generic-usb 0003:03F0:1027.0002: input,hidraw1: USB HID v1.01 Mouse [HP Virtual Keyboard] on usb-0000:01:04.4-1/input1
usb 3-2: new full speed USB device using uhci_hcd and address 3
usb 3-2: New USB device found, idVendor=03f0, idProduct=1327
usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-2: Product: Virtual Hub
usb 3-2: Manufacturer: HP
hub 3-2:1.0: USB hub found
hub 3-2:1.0: 7 ports detected
cciss: controller message 03:00 succeeded
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 54
cciss 0000:42:08.0: PCI INT A -> Link[LNKA] -> GSI 54 (level, high) -> IRQ 54
cciss 0000:42:08.0: irq 70 for MSI/MSI-X
IRQ 70/cciss0: IRQF_DISABLED is not guaranteed on shared IRQs
cciss0: <0x3238> at PCI 0000:42:08.0 IRQ 70 using DAC
 cciss/c0d0: p1 p2 p3 p4 < p5 p6 p7 >
 cciss/c0d1: p1 p2
initcall cciss_init+0x0/0xa4 [cciss] returned 0 after 2181928 usecs
calling  shpcd_init+0x0/0x68 [shpchp] @ 752
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
initcall shpcd_init+0x0/0x68 [shpchp] returned 0 after 35425 usecs
calling  scsi_tgt_init+0x0/0x82 [scsi_tgt] @ 758
initcall scsi_tgt_init+0x0/0x82 [scsi_tgt] returned 0 after 211 usecs
calling  fc_transport_init+0x0/0x85 [scsi_transport_fc] @ 763
initcall fc_transport_init+0x0/0x85 [scsi_transport_fc] returned 0 after 29 usecs
calling  lpfc_init+0x0/0xd3 [lpfc] @ 764
Emulex LightPulse Fibre Channel SCSI driver 8.3.9
Copyright(c) 2004-2009 Emulex.  All rights reserved.
ACPI: PCI Interrupt Link [LNKY] enabled at IRQ 18
lpfc 0000:08:00.0: PCI INT A -> Link[LNKY] -> GSI 18 (level, high) -> IRQ 18
lpfc 0000:08:00.0: setting latency timer to 64
scsi0 :  on PCI bus 08 device 00 irq 18
lpfc 0000:08:00.0: irq 71 for MSI/MSI-X
ACPI: PCI Interrupt Link [LNKZ] enabled at IRQ 19
lpfc 0000:08:00.1: PCI INT B -> Link[LNKZ] -> GSI 19 (level, high) -> IRQ 19
lpfc 0000:08:00.1: setting latency timer to 64
scsi1 :  on PCI bus 08 device 01 irq 19
lpfc 0000:08:00.0: 0:1303 Link Up Event x1 received Data: x1 xf7 x10 x2 x0 x0 0
lpfc 0000:08:00.1: irq 72 for MSI/MSI-X
scsi 0:0:0:0: RAID              COMPAQ   MSA1000          5.20 PQ: 0 ANSI: 4
scsi 0:0:0:0: Attached scsi generic sg0 type 12
scsi 0:0:1:0: RAID              COMPAQ   MSA1000          5.20 PQ: 0 ANSI: 4
scsi 0:0:1:0: Attached scsi generic sg1 type 12
scsi 0:0:1:8: Direct-Access     COMPAQ   MSA1000 VOLUME   5.20 PQ: 0 ANSI: 4
sd 0:0:1:8: Attached scsi generic sg2 type 0
scsi 0:0:2:0: Enclosure         HP       MSA2212fc        J200 PQ: 0 ANSI: 5
scsi 0:0:2:0: Attached scsi generic sg3 type 13
sd 0:0:1:8: [sda] 2187605616 512-byte logical blocks: (1.12 TB/1.01 TiB)
sd 0:0:1:8: [sda] Write Protect is off
sd 0:0:1:8: [sda] Mode Sense: 83 00 00 08
sd 0:0:1:8: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1
sd 0:0:1:8: [sda] Attached SCSI disk
initcall lpfc_init+0x0/0xd3 [lpfc] returned 0 after 4315172 usecs
calling  usb_stor_init+0x0/0x4b [usb_storage] @ 802
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
initcall usb_stor_init+0x0/0x4b [usb_storage] returned 0 after 53681 usecs
lpfc 0000:08:00.1: 1:1303 Link Up Event x1 received Data: x1 xf7 x10 x2 x0 x0 0
scsi 1:0:0:0: RAID              COMPAQ   MSA1000          5.20 PQ: 0 ANSI: 4
scsi 1:0:0:0: Attached scsi generic sg4 type 12
scsi 1:0:1:0: RAID              COMPAQ   MSA1000          5.20 PQ: 0 ANSI: 4
scsi 1:0:1:0: Attached scsi generic sg5 type 12
scsi 1:0:1:8: Direct-Access     COMPAQ   MSA1000 VOLUME   5.20 PQ: 0 ANSI: 4
sd 1:0:1:8: Attached scsi generic sg6 type 0
sd 1:0:1:8: [sdb] 2187605616 512-byte logical blocks: (1.12 TB/1.01 TiB)
sd 1:0:1:8: [sdb] Write Protect is off
sd 1:0:1:8: [sdb] Mode Sense: 83 00 00 08
sd 1:0:1:8: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1
scsi 1:0:2:0: Enclosure         HP       MSA2212fc        J200 PQ: 0 ANSI: 5
scsi 1:0:2:0: Attached scsi generic sg7 type 13
sd 1:0:1:8: [sdb] Attached SCSI disk
calling  dm_dirty_log_init+0x0/0x59 [dm_log] @ 804
initcall dm_dirty_log_init+0x0/0x59 [dm_log] returned 0 after 1 usecs
EXT3-fs (cciss/c0d0p3): recovery required on readonly filesystem
EXT3-fs (cciss/c0d0p3): write access will be enabled during recovery
kjournald starting.  Commit interval 5 seconds
EXT3-fs (cciss/c0d0p3): recovery complete
EXT3-fs (cciss/c0d0p3): mounted filesystem with writeback data mode
calling  pcspkr_init+0x0/0x12 [pcspkr] @ 1078
calling  hwmon_init+0x0/0x112 [hwmon] @ 1115
input: PC Speaker as /class/input/input3
initcall hwmon_init+0x0/0x112 [hwmon] returned 0 after 40682 usecs
calling  k8temp_init+0x0/0x20 [k8temp] @ 1115
k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
k8temp 0000:00:19.3: Temperature readouts might be wrong - check erratum #141
initcall k8temp_init+0x0/0x20 [k8temp] returned 0 after 15343 usecs
calling  serio_raw_init+0x0/0x20 [serio_raw] @ 1321
initcall serio_raw_init+0x0/0x20 [serio_raw] returned 0 after 21 usecs
calling  floppy_module_init+0x0/0xd6d [floppy] @ 1330
calling  init_tis+0x0/0x92 [tpm_tis] @ 1152
Floppy drive(s): fd0 is 1.44M
calling  ipmi_init_msghandler_mod+0x0/0xd [ipmi_msghandler] @ 1449
initcall pcspkr_init+0x0/0x12 [pcspkr] returned 0 after 371629 usecs
calling  snd_mem_init+0x0/0x2c [snd_page_alloc] @ 1078
initcall init_tis+0x0/0x92 [tpm_tis] returned 0 after 163507 usecs
initcall snd_mem_init+0x0/0x2c [snd_page_alloc] returned 0 after 56654 usecs
ipmi message handler version 39.2
initcall ipmi_init_msghandler_mod+0x0/0xd [ipmi_msghandler] returned 0 after 178608 usecs
calling  init_soundcore+0x0/0x8b [soundcore] @ 1078
initcall init_soundcore+0x0/0x8b [soundcore] returned 0 after 16 usecs
calling  alsa_sound_init+0x0/0x8f [snd] @ 1078
initcall alsa_sound_init+0x0/0x8f [snd] returned 0 after 31 usecs
calling  alsa_timer_init+0x0/0x187 [snd_timer] @ 1078
initcall alsa_timer_init+0x0/0x187 [snd_timer] returned 0 after 55 usecs
calling  alsa_pcm_init+0x0/0x71 [snd_pcm] @ 1894
initcall alsa_pcm_init+0x0/0x71 [snd_pcm] returned 0 after 7 usecs
calling  alsa_mixer_oss_init+0x0/0x3a [snd_mixer_oss] @ 1918
initcall alsa_mixer_oss_init+0x0/0x3a [snd_mixer_oss] returned 0 after 0 usecs
calling  alsa_pcm_oss_init+0x0/0xa1 [snd_pcm_oss] @ 1918
initcall alsa_pcm_oss_init+0x0/0xa1 [snd_pcm_oss] returned 0 after 1 usecs
calling  alsa_seq_device_init+0x0/0x60 [snd_seq_device] @ 1967
initcall alsa_seq_device_init+0x0/0x60 [snd_seq_device] returned 0 after 5 usecs
calling  enclosure_init+0x0/0x19 [enclosure] @ 1966
initcall enclosure_init+0x0/0x19 [enclosure] returned 0 after 14 usecs
calling  ses_init+0x0/0x40 [ses] @ 1966
ses 0:0:2:0: Attached Enclosure device
ses 1:0:2:0: Attached Enclosure device
initcall ses_init+0x0/0x40 [ses] returned 0 after 60 usecs
calling  alsa_seq_init+0x0/0x57 [snd_seq] @ 1994
initcall alsa_seq_init+0x0/0x57 [snd_seq] returned 0 after 70 usecs
calling  alsa_seq_midi_event_init+0x0/0x8 [snd_seq_midi_event] @ 1994
initcall alsa_seq_midi_event_init+0x0/0x8 [snd_seq_midi_event] returned 0 after 0 usecs
calling  alsa_seq_oss_init+0x0/0x19e [snd_seq_oss] @ 1994
calling  phy_init+0x0/0x31 [libphy] @ 1985
initcall phy_init+0x0/0x31 [libphy] returned 0 after 909 usecs
calling  tg3_init+0x0/0x20 [tg3] @ 1986
tg3.c:v3.108 (February 17, 2010)
tg3 0000:07:04.0: PCI INT A -> Link[LNKZ] -> GSI 19 (level, high) -> IRQ 19
calling  alsa_seq_dummy_init+0x0/0xcd [snd_seq_dummy] @ 2058
initcall alsa_seq_dummy_init+0x0/0xcd [snd_seq_dummy] returned 0 after 10 usecs
initcall alsa_seq_oss_init+0x0/0x19e [snd_seq_oss] returned 0 after 279453 usecs
calling  pcsp_init+0x0/0x20 [snd_pcsp] @ 1078
Error: Driver 'pcspkr' is already registered, aborting...
initcall pcsp_init+0x0/0x20 [snd_pcsp] returned -16 after 3 usecs
initcall pcsp_init+0x0/0x20 [snd_pcsp] returned with error code -16 
initcall ipmi_init_msghandler_mod+0x0/0xd [ipmi_msghandler] returned with error code -16 
tg3 0000:07:04.0: eth2: Tigon3 [partno(011276-001) rev 9003] (PCIX:133MHz:64-bit) MAC address 00:18:fe:34:1c:2f
tg3 0000:07:04.0: eth2: attached PHY is 5714 (1000Base-SX Ethernet) (WireSpeed[0])
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<(null)>] (null)
PGD 0 
Oops: 0010 [#1] SMP 
last sysfs file: /sys/block/sdb/removable
CPU 3 
Modules linked in: snd_seq_dummy tg3(+) libphy snd_seq_oss snd_seq_midi_event snd_seq ses enclosure snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore snd_page_alloc tpm_tis floppy(+) serio_raw tpm k8temp tpm_bios hwmon pcspkr dm_region_hash dm_log usb_storage lpfc scsi_transport_fc scsi_tgt shpchp cciss uhci_hcd ohci_hcd ehci_hcd

Pid: 2570, comm: udevd Not tainted 2.6.34-rc1 #1 /ProLiant BL685c G1
RIP: 0010:[<0000000000000000>]  [<(null)>] (null)
RSP: 0000:ffff880183b03e98  EFLAGS: 00010246
RAX: ffff88027d94bfd8 RBX: 00000000000000ea RCX: ffff88027d025d40
RDX: ffff880183b03eb0 RSI: dead000000200200 RDI: 0000000000000000
RBP: ffff880183b03ef0 R08: ffff88027d025d40 R09: 0000000000000632
R10: 0000000000000000 R11: 00000000ffffffff R12: ffffffffa0136900
R13: ffff88027f658000 R14: 0000000000000000 R15: 0000000000000100
FS:  00007fe01e9af710(0000) GS:ffff880183b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000027ea32000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevd (pid: 2570, threadinfo ffff88027d94a000, task ffff88027d025d40)
Stack:
 ffffffff81054e89 0000000000000052 0000000000000000 ffff880183b03eb0
<0> ffff880183b03eb0 ffffffff8101ea60 0000000000000282 0000000000000001
<0> 0000000000000141 0000000000000100 ffffffff81823088 ffff880183b03f40
Call Trace:
 <IRQ> 
 [<ffffffff81054e89>] ? run_timer_softirq+0x16d/0x209
 [<ffffffff8101ea60>] ? apic_write+0x11/0x13
 [<ffffffff8104deb5>] __do_softirq+0xe1/0x1b7
 [<ffffffff81009a5c>] call_softirq+0x1c/0x30
 [<ffffffff8100b2b7>] do_softirq+0x46/0x9f
 [<ffffffff8104dfd0>] irq_exit+0x45/0x84
 [<ffffffff8101f442>] smp_apic_timer_interrupt+0x79/0x87
 [<ffffffff81009513>] apic_timer_interrupt+0x13/0x20
 <EOI> 
Code:  Bad RIP value.
RIP  [<(null)>] (null)
 RSP <ffff880183b03e98>
CR2: 0000000000000000
---[ end trace 77b6d5c602bfc703 ]---
Kernel panic - not syncing: Fatal exception in interrupt
Pid: 2570, comm: udevd Tainted: G      D    2.6.34-rc1 #1
Call Trace:
 <IRQ>  [<ffffffff8104815c>] panic+0x9e/0x123
 [<ffffffff81048427>] ? spin_unlock_irqrestore+0x9/0xb
 [<ffffffff81049880>] ? kmsg_dump+0x14e/0x176
 [<ffffffff813ba72f>] oops_end+0xb1/0xc1
 [<ffffffff8102c436>] no_context+0x1f5/0x204
 [<ffffffff8102c692>] __bad_area_nosemaphore+0x193/0x1b6
 [<ffffffff81319885>] ? consume_skb+0x28/0x2a
 [<ffffffff8102c72b>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff813bc713>] do_page_fault+0x14c/0x281
 [<ffffffff813b9b25>] page_fault+0x25/0x30
 [<ffffffff81054e89>] ? run_timer_softirq+0x16d/0x209
 [<ffffffff8101ea60>] ? apic_write+0x11/0x13
 [<ffffffff8104deb5>] __do_softirq+0xe1/0x1b7
 [<ffffffff81009a5c>] call_softirq+0x1c/0x30
 [<ffffffff8100b2b7>] do_softirq+0x46/0x9f
 [<ffffffff8104dfd0>] irq_exit+0x45/0x84
 [<ffffffff8101f442>] smp_apic_timer_interrupt+0x79/0x87
 [<ffffffff81009513>] apic_timer_interrupt+0x13/0x20
 <EOI> 
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<(null)>] (null)
PGD 0 
Oops: 0010 [#2] SMP 
last sysfs file: /sys/block/sdb/removable
CPU 3 
Modules linked in: snd_seq_dummy tg3(+) libphy snd_seq_oss snd_seq_midi_event snd_seq ses enclosure snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore snd_page_alloc tpm_tis floppy(+) serio_raw tpm k8temp tpm_bios hwmon pcspkr dm_region_hash dm_log usb_storage lpfc scsi_transport_fc scsi_tgt shpchp cciss uhci_hcd ohci_hcd ehci_hcd

Pid: 2570, comm: udevd Tainted: G      D    2.6.34-rc1 #1 /ProLiant BL685c G1
RIP: 0010:[<0000000000000000>]  [<(null)>] (null)
RSP: 0000:ffff880183b03b60  EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffffa01365e0
RDX: ffffffff81a88680 RSI: 0000000000000000 RDI: ffffffffa01365e0
RBP: ffff880183b03b98 R08: 0000000000000000 R09: 0000000000000000
R10: ffff880183b03928 R11: 0000000000000002 R12: 00000000ffffffff
R13: 0000000000000000 R14: ffffffff81a88680 R15: 0000000000000000
FS:  00007fe01e9af710(0000) GS:ffff880183b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000027ea32000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevd (pid: 2570, threadinfo ffff88027d94a000, task ffff88027d025d40)
Stack:
 ffffffff813bc87b ffff880183b03b88 ffffffff815825f6 0000000000000246
<0> 0000000000000009 ffff88027d025d40 0000000000000010 ffff880183b03ba8
<0> ffffffff813bc8b0 ffff880183b03bb8 ffffffff813bc8c1 ffff880183b03ca8
Call Trace:
 <IRQ> 
 [<ffffffff813bc87b>] ? notifier_call_chain+0x33/0x5b
 [<ffffffff813bc8b0>] __atomic_notifier_call_chain+0xd/0xf
 [<ffffffff813bc8c1>] atomic_notifier_call_chain+0xf/0x11
 [<ffffffff81048188>] panic+0xca/0x123
 [<ffffffff81048427>] ? spin_unlock_irqrestore+0x9/0xb
 [<ffffffff81049880>] ? kmsg_dump+0x14e/0x176
 [<ffffffff813ba72f>] oops_end+0xb1/0xc1
 [<ffffffff8102c436>] no_context+0x1f5/0x204
 [<ffffffff8102c692>] __bad_area_nosemaphore+0x193/0x1b6
 [<ffffffff81319885>] ? consume_skb+0x28/0x2a
 [<ffffffff8102c72b>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff813bc713>] do_page_fault+0x14c/0x281
 [<ffffffff813b9b25>] page_fault+0x25/0x30
 [<ffffffff81054e89>] ? run_timer_softirq+0x16d/0x209
 [<ffffffff8101ea60>] ? apic_write+0x11/0x13
 [<ffffffff8104deb5>] __do_softirq+0xe1/0x1b7
 [<ffffffff81009a5c>] call_softirq+0x1c/0x30
 [<ffffffff8100b2b7>] do_softirq+0x46/0x9f
 [<ffffffff8104dfd0>] irq_exit+0x45/0x84
 [<ffffffff8101f442>] smp_apic_timer_interrupt+0x79/0x87
 [<ffffffff81009513>] apic_timer_interrupt+0x13/0x20
 <EOI> 
Code:  Bad RIP value.
RIP  [<(null)>] (null)
 RSP <ffff880183b03b60>
CR2: 0000000000000000
---[ end trace 77b6d5c602bfc704 ]---
Kernel panic - not syncing: Fatal exception in interrupt
Pid: 2570, comm: udevd Tainted: G      D    2.6.34-rc1 #1
Call Trace:
 <IRQ>  [<ffffffff8104815c>] panic+0x9e/0x123
 [<ffffffff81048427>] ? spin_unlock_irqrestore+0x9/0xb
 [<ffffffff81049880>] ? kmsg_dump+0x14e/0x176
 [<ffffffff813ba72f>] oops_end+0xb1/0xc1
 [<ffffffff8102c436>] no_context+0x1f5/0x204
 [<ffffffff8102c692>] __bad_area_nosemaphore+0x193/0x1b6
 [<ffffffff8106cc75>] ? tick_program_event+0x25/0x27
 [<ffffffff8102c72b>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff813bc713>] do_page_fault+0x14c/0x281
 [<ffffffff813b9b25>] page_fault+0x25/0x30
 [<ffffffff813bc87b>] ? notifier_call_chain+0x33/0x5b
 [<ffffffff813bc8b0>] __atomic_notifier_call_chain+0xd/0xf
 [<ffffffff813bc8c1>] atomic_notifier_call_chain+0xf/0x11
 [<ffffffff81048188>] panic+0xca/0x123
 [<ffffffff81048427>] ? spin_unlock_irqrestore+0x9/0xb
 [<ffffffff81049880>] ? kmsg_dump+0x14e/0x176
 [<ffffffff813ba72f>] oops_end+0xb1/0xc1
 [<ffffffff8102c436>] no_context+0x1f5/0x204
 [<ffffffff8102c692>] __bad_area_nosemaphore+0x193/0x1b6
 [<ffffffff81319885>] ? consume_skb+0x28/0x2a
 [<ffffffff8102c72b>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff813bc713>] do_page_fault+0x14c/0x281
 [<ffffffff813b9b25>] page_fault+0x25/0x30
 [<ffffffff81054e89>] ? run_timer_softirq+0x16d/0x209
 [<ffffffff8101ea60>] ? apic_write+0x11/0x13
 [<ffffffff8104deb5>] __do_softirq+0xe1/0x1b7
 [<ffffffff81009a5c>] call_softirq+0x1c/0x30
 [<ffffffff8100b2b7>] do_softirq+0x46/0x9f
 [<ffffffff8104dfd0>] irq_exit+0x45/0x84
 [<ffffffff8101f442>] smp_apic_timer_interrupt+0x79/0x87
 [<ffffffff81009513>] apic_timer_interrupt+0x13/0x20
 <EOI> 
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<(null)>] (null)
PGD 0 
Oops: 0010 [#3] SMP 
last sysfs file: /sys/block/sdb/removable
CPU 3 
Modules linked in: snd_seq_dummy tg3(+) libphy snd_seq_oss snd_seq_midi_event snd_seq ses enclosure snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore snd_page_alloc tpm_tis floppy(+) serio_raw tpm k8temp tpm_bios hwmon pcspkr dm_region_hash dm_log usb_storage lpfc scsi_transport_fc scsi_tgt shpchp cciss uhci_hcd ohci_hcd ehci_hcd

Pid: 2570, comm: udevd Tainted: G      D    2.6.34-rc1 #1 /ProLiant BL685c G1
RIP: 0010:[<0000000000000000>]  [<(null)>] (null)
RSP: 0000:ffff880183b03830  EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffffa01365e0
RDX: ffffffff81a88680 RSI: 0000000000000000 RDI: ffffffffa01365e0
RBP: ffff880183b03868 R08: 0000000000000000 R09: 0000000000000000
R10: ffff880183b035f8 R11: 0000000000000002 R12: 00000000ffffffff
R13: 0000000000000000 R14: ffffffff81a88680 R15: 0000000000000000
FS:  00007fe01e9af710(0000) GS:ffff880183b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000027ea32000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevd (pid: 2570, threadinfo ffff88027d94a000, task ffff88027d025d40)
Stack:
 ffffffff813bc87b ffff880183b03858 ffffffff815825f6 0000000000000246
<0> 0000000000000009 ffff88027d025d40 0000000000000010 ffff880183b03878
<0> ffffffff813bc8b0 ffff880183b03888 ffffffff813bc8c1 ffff880183b03978
Call Trace:
 <IRQ> 
 [<ffffffff813bc87b>] ? notifier_call_chain+0x33/0x5b
 [<ffffffff813bc8b0>] __atomic_notifier_call_chain+0xd/0xf
 [<ffffffff813bc8c1>] atomic_notifier_call_chain+0xf/0x11
 [<ffffffff81048188>] panic+0xca/0x123
 [<ffffffff81048427>] ? spin_unlock_irqrestore+0x9/0xb
 [<ffffffff81049880>] ? kmsg_dump+0x14e/0x176
 [<ffffffff813ba72f>] oops_end+0xb1/0xc1
 [<ffffffff8102c436>] no_context+0x1f5/0x204
 [<ffffffff8102c692>] __bad_area_nosemaphore+0x193/0x1b6
 [<ffffffff8106cc75>] ? tick_program_event+0x25/0x27
 [<ffffffff8102c72b>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff813bc713>] do_page_fault+0x14c/0x281
 [<ffffffff813b9b25>] page_fault+0x25/0x30
 [<ffffffff813bc87b>] ? notifier_call_chain+0x33/0x5b
 [<ffffffff813bc8b0>] __atomic_notifier_call_chain+0xd/0xf
 [<ffffffff813bc8c1>] atomic_notifier_call_chain+0xf/0x11
 [<ffffffff81048188>] panic+0xca/0x123
 [<ffffffff81048427>] ? spin_unlock_irqrestore+0x9/0xb
 [<ffffffff81049880>] ? kmsg_dump+0x14e/0x176
 [<ffffffff813ba72f>] oops_end+0xb1/0xc1
 [<ffffffff8102c436>] no_context+0x1f5/0x204
 [<ffffffff8102c692>] __bad_area_nosemaphore+0x193/0x1b6
 [<ffffffff81319885>] ? consume_skb+0x28/0x2a
 [<ffffffff8102c72b>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff813bc713>] do_page_fault+0x14c/0x281
 [<ffffffff813b9b25>] page_fault+0x25/0x30
 [<ffffffff81054e89>] ? run_timer_softirq+0x16d/0x209
 [<ffffffff8101ea60>] ? apic_write+0x11/0x13
 [<ffffffff8104deb5>] __do_softirq+0xe1/0x1b7
 [<ffffffff81009a5c>] call_softirq+0x1c/0x30
 [<ffffffff8100b2b7>] do_softirq+0x46/0x9f
 [<ffffffff8104dfd0>] irq_exit+0x45/0x84
 [<ffffffff8101f442>] smp_apic_timer_interrupt+0x79/0x87
 [<ffffffff81009513>] apic_timer_interrupt+0x13/0x20
 <EOI> 
Code:  Bad RIP value.
RIP  [<(null)>] (null)
 RSP <ffff880183b03830>
CR2: 0000000000000000
---[ end trace 77b6d5c602bfc705 ]---
Kernel panic - not syncing: Fatal exception in interrupt
Pid: 2570, comm: udevd Tainted: G      D    2.6.34-rc1 #1
Call Trace:
 <IRQ>  [<ffffffff8104815c>] panic+0x9e/0x123
 [<ffffffff81048427>] ? spin_unlock_irqrestore+0x9/0xb
 [<ffffffff81049880>] ? kmsg_dump+0x14e/0x176
 [<ffffffff813ba72f>] oops_end+0xb1/0xc1
 [<ffffffff8102c436>] no_context+0x1f5/0x204
 [<ffffffff8102c692>] __bad_area_nosemaphore+0x193/0x1b6
 [<ffffffff8102c72b>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff813bc713>] do_page_fault+0x14c/0x281
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.34-rc1 (root@ca-ostest293.us.oracle.com) (gcc version 4.1.2 20080704 (Red Hat 4.1.2-46)) #1 SMP Mon Mar 8 14:01:59 PST 2010
Command line: root=LABEL=/ selinux=0 console=tty0 console=ttyS0,115200n8 reset_devices netconsole=56816@139.185.50.77/eth0,56816@139.185.50.76/00:18:FE:34:1C:3D nmi_watchdog=2 debug ignore_loglevel initcall_debug 3
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fe50000 (usable)
 BIOS-e820: 000000007fe50000 - 000000007fe58000 (ACPI data)
 BIOS-e820: 000000007fe58000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 000000027ffff000 (usable)
debug: ignoring loglevel setting.
NX (Execute Disable) protection: active
DMI 2.3 present.
e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x27ffff max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-FFFFF write-back
MTRR variable ranges enabled:
  0 base 0000000000 mask FF80000000 write-back
  1 disabled
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
TOM2: 0000000280000000 aka 10240M
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 0000000080000000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0x7fe50 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
found SMP MP-table at [ffff8800000f4f80] f4f80
init_memory_mapping: 0000000000000000-000000007fe50000
 0000000000 - 007fe00000 page 2M
 007fe00000 - 007fe50000 page 4k
kernel direct mapping tables up to 7fe50000 @ 8000-c000
init_memory_mapping: 0000000100000000-000000027ffff000
 0100000000 - 027fe00000 page 2M
 027fe00000 - 027ffff000 page 4k
kernel direct mapping tables up to 27ffff000 @ a000-16000
RAMDISK: 37d77000 - 37feff29
ACPI: RSDP 00000000000f4f00 00024 (v02 HP    )
ACPI: XSDT 000000007fe50780 0005C (v01 HP     A08      00000002   Ò? 0000162E)
ACPI: FACP 000000007fe50800 000F4 (v03 HP     A08      00000002   Ò? 0000162E)
ACPI: DSDT 000000007fe50900 03F75 (v01 HP         DSDT 00000001 INTL 20030228)
ACPI: FACS 000000007fe50100 00040
ACPI: SPCR 000000007fe50140 00050 (v01 HP     SPCRRBSU 00000001   Ò? 0000162E)
ACPI: MCFG 000000007fe501c0 0003C (v01 HP     ProLiant 00000001      00000000)
ACPI: HPET 000000007fe50200 00038 (v01 HP     A08      00000002   Ò? 0000162E)
ACPI: SPMI 000000007fe50240 00040 (v05 HP     ProLiant 00000001   Ò? 0000162E)
ACPI: APIC 000000007fe50280 000DE (v01 HP     00000083 00000002      00000000)
ACPI: SRAT 000000007fe50380 00110 (v01 AMD    HAMMER   00000001 AMD  00000001)
ACPI: Local APIC address 0xfee00000
SRAT: PXM 0 -> APIC 0x00 -> Node 0
SRAT: PXM 0 -> APIC 0x01 -> Node 0
SRAT: PXM 1 -> APIC 0x02 -> Node 1
SRAT: PXM 1 -> APIC 0x03 -> Node 1
SRAT: Node 0 PXM 0 0-a0000
SRAT: Node 0 PXM 0 100000-80000000
SRAT: Node 0 PXM 0 100000000-180000000
SRAT: Node 1 PXM 1 180000000-280000000
NUMA: Allocated memnodemap from 11000 - 16040
NUMA: Using 20 for the hash shift.
Initmem setup node 0 0000000000000000-0000000180000000
  NODE_DATA [0000000100000000 - 0000000100013fff]
Initmem setup node 1 0000000180000000-000000027ffff000
  NODE_DATA [0000000180000000 - 0000000180013fff]
 [ffffea0000000000-ffffea00053fffff] PMD -> [ffff880100200000-ffff8801039fffff] on node 0
 [ffffea0005400000-ffffea0008bfffff] PMD -> [ffff880180200000-ffff8801839fffff] on node 1
Zone PFN ranges:
  DMA      0x00000001 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x0027ffff
Movable zone start PFN for each node
early_node_map[4] active PFN ranges
    0: 0x00000001 -> 0x0000009f
    0: 0x00000100 -> 0x0007fe50
    0: 0x00100000 -> 0x00180000
    1: 0x00180000 -> 0x0027ffff
On node 0 totalpages: 1048046
  DMA zone: 56 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3942 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 505480 pages, LIFO batch:31
  Normal zone: 7168 pages used for memmap
  Normal zone: 517120 pages, LIFO batch:31
On node 1 totalpages: 1048575
  Normal zone: 14336 pages used for memmap
  Normal zone: 1034239 pages, LIFO batch:31
Detected use of extended apic ids on hypertransport bus
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x908
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xf7df0000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 17, address 0xf7df0000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfdef0000] gsi_base[38])
IOAPIC[1]: apic_id 9, version 17, address 0xfdef0000, GSI 38-61
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x10228201 base: 0xfed00000
SMP: Allowing 4 CPUs, 0 hotplug CPUs
early_res array is doubled to 64 at [7000 - 77ff]
nr_irqs_gsi: 62
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
PM: Registered nosave memory: 000000007fe50000 - 000000007fe58000
PM: Registered nosave memory: 000000007fe58000 - 0000000080000000
PM: Registered nosave memory: 0000000080000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 00000000fed00000
PM: Registered nosave memory: 00000000fed00000 - 00000000fee00000
PM: Registered nosave memory: 00000000fee00000 - 00000000fee10000
PM: Registered nosave memory: 00000000fee10000 - 00000000ffc00000
PM: Registered nosave memory: 00000000ffc00000 - 0000000100000000
Allocating PCI resources starting at 80000000 (gap: 80000000:7ec00000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:16 nr_cpumask_bits:16 nr_cpu_ids:4 nr_node_ids:2
PERCPU: Embedded 29 pages/cpu @ffff880001e00000 s90088 r8192 d20504 u1048576
pcpu-alloc: s90088 r8192 d20504 u1048576 alloc=1*2097152
pcpu-alloc: [0] 0 2 [1] 1 3 
early_res array is doubled to 128 at [16040 - 1703f]
Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 2060781
Policy zone: Normal
Kernel command line: root=LABEL=/ selinux=0 console=tty0 console=ttyS0,115200n8 reset_devices netconsole=56816@139.185.50.77/eth0,56816@139.185.50.76/00:18:FE:34:1C:3D nmi_watchdog=2 debug ignore_loglevel initcall_debug 3
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Node 0: aperture @ fa6c000000 size 32 MB
Aperture beyond 4GB. Ignoring.
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 20000000
PM: Registered nosave memory: 0000000020000000 - 0000000024000000
Subtract (63 early reservations)
  #1 [0001000000 - 0001c4fb58]   TEXT DATA BSS
  #2 [0037d77000 - 0037feff29]         RAMDISK
  #3 [0001c50000 - 0001c5010c]             BRK
  #4 [00000f4f90 - 0000100000]   BIOS reserved
  #5 [00000f4f80 - 00000f4f90]    MP-table mpf
  #6 [000009f400 - 00000f1bf8]   BIOS reserved
  #7 [00000f1e2c - 00000f4f80]   BIOS reserved
  #8 [00000f1bf8 - 00000f1e2c]    MP-table mpc
  #9 [0000001000 - 0000003000]      TRAMPOLINE
  #10 [0000003000 - 0000007000]     ACPI WAKEUP
  #11 [0000008000 - 000000a000]         PGTABLE
  #12 [000000a000 - 0000011000]         PGTABLE
  #13 [0000011000 - 0000016040]      MEMNODEMAP
  #14 [0100000000 - 0100014000]       NODE_DATA
  #15 [0180000000 - 0180014000]       NODE_DATA
  #16 [0001c50140 - 0001c51140]         BOOTMEM
  #17 [0001c4fb80 - 0001c4fe80]         BOOTMEM
  #18 [0180014000 - 0180014300]         BOOTMEM
  #19 [0100014000 - 0100015000]         BOOTMEM
  #20 [0100015000 - 0100016000]         BOOTMEM
  #21 [0100200000 - 0103a00000]        MEMMAP 0
  #22 [0180200000 - 0183a00000]        MEMMAP 1
  #23 [0001c4fe80 - 0001c50000]         BOOTMEM
  #24 [0001c51140 - 0001c69140]         BOOTMEM
  #25 [0001c69140 - 0001c75140]         BOOTMEM
  #26 [0180014300 - 018002c300]         BOOTMEM
  #27 [0001c76000 - 0001c77000]         BOOTMEM
  #28 [0001c75140 - 0001c75181]         BOOTMEM
  #29 [0001c751c0 - 0001c75246]         BOOTMEM
  #30 [0001c75280 - 0001c754e8]         BOOTMEM
  #31 [0001c75500 - 0001c75568]         BOOTMEM
  #32 [0001c75580 - 0001c755e8]         BOOTMEM
  #33 [0001c75600 - 0001c75668]         BOOTMEM
  #34 [0001c75680 - 0001c756e8]         BOOTMEM
  #35 [0001c75700 - 0001c75768]         BOOTMEM
  #36 [0001c75780 - 0001c757e8]         BOOTMEM
  #37 [0001c75800 - 0001c75868]         BOOTMEM
  #38 [0001c75880 - 0001c758e8]         BOOTMEM
  #39 [0001c75900 - 0001c75968]         BOOTMEM
  #40 [0001c75980 - 0001c759e8]         BOOTMEM
  #41 [0001c75a00 - 0001c75a20]         BOOTMEM
  #42 [0001c75a40 - 0001c75a60]         BOOTMEM
  #43 [0001c75a80 - 0001c75b49]         BOOTMEM
  #44 [0001c75b80 - 0001c75c49]         BOOTMEM
  #45 [0001e00000 - 0001e1d000]         BOOTMEM
  #46 [0001f00000 - 0001f1d000]         BOOTMEM
  #47 [0183a00000 - 0183a1d000]         BOOTMEM
  #48 [0183b00000 - 0183b1d000]         BOOTMEM
  #49 [0001c75c80 - 0001c75c90]         BOOTMEM
  #50 [0001c75cc0 - 0001c75cd0]         BOOTMEM
  #51 [0001c75d00 - 0001c75d10]         BOOTMEM
  #52 [0001c75d40 - 0001c75d60]         BOOTMEM
  #53 [0001c75d80 - 0001c75ec0]         BOOTMEM
  #54 [0001c75ec0 - 0001c75f20]         BOOTMEM
  #55 [0001c75f40 - 0001c75fa0]         BOOTMEM
  #56 [0001c77000 - 0001c7f000]         BOOTMEM
  #57 [0020000000 - 0024000000]         BOOTMEM
  #58 [0001c75fc0 - 0001c75fe0]         BOOTMEM
  #59 [0001f1d000 - 0005f1d000]         BOOTMEM
  #60 [0001c7f000 - 0001c9f000]         BOOTMEM
  #61 [0001c9f000 - 0001cdf000]         BOOTMEM
  #62 [0000017040 - 000001f040]         BOOTMEM
 7 - 8
 20 40 - 80 9f
 100 100 - 1000 1000
 1cdf 1d00 - 1e00 1e00
 1e1d 1e40 - 1f00 1f00
 5f1d 5f40 - 20000 20000
 24000 24000 - 37d40 37d77
 37ff0 38000 - 7fe40 7fe50
 100016 100040 - 100200 100200
 103a00 103a00 - 180000 180000
 18002d 180040 - 180200 180200
 183a1d 183a40 - 183b00 183b00
 183b1d 183b40 - 27ffc0 27ffff
Memory: 8124160k/10485756k available (3844k kernel code, 2099272k absent, 262324k reserved, 5289k data, 1292k init)
SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=2
Hierarchical RCU implementation.
NR_IRQS:768
Extended CMOS year: 2000
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2612.128 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 5224.25 BogoMIPS (lpj=2612128)
Security Framework initialized
SELinux:  Disabled at boot.
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys devices
tseg: 0000000000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 5 MCE banks
using C1E aware idle routine
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
ACPI: Core revision 20100121
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Dual-Core AMD Opteron(tm) Processor 8218 stepping 02
calling  migration_init+0x0/0x5a @ 1
initcall migration_init+0x0/0x5a returned 0 after 0 usecs
calling  spawn_ksoftirqd+0x0/0x5a @ 1
initcall spawn_ksoftirqd+0x0/0x5a returned 0 after 0 usecs
calling  init_call_single_data+0x0/0x82 @ 1
initcall init_call_single_data+0x0/0x82 returned 0 after 0 usecs
calling  spawn_softlockup_task+0x0/0x75 @ 1
initcall spawn_softlockup_task+0x0/0x75 returned 0 after 0 usecs
calling  relay_init+0x0/0x14 @ 1
initcall relay_init+0x0/0x14 returned 0 after 0 usecs
calling  tracer_alloc_buffers+0x0/0x1d6 @ 1
initcall tracer_alloc_buffers+0x0/0x1d6 returned 0 after 0 usecs
calling  init_trace_printk+0x0/0x12 @ 1
initcall init_trace_printk+0x0/0x12 returned 0 after 0 usecs
calling  mce_amd_init+0x0/0x2d @ 1
initcall mce_amd_init+0x0/0x2d returned 0 after 0 usecs
Booting Node   1, Processors  #1 Ok.
Booting Node   0, Processors  #2 Ok.
Booting Node   1, Processors  #3 Ok.
Brought up 4 CPUs
Total of 4 processors activated (20895.70 BogoMIPS).
Testing NMI watchdog ... OK.
calling  init_mmap_min_addr+0x0/0x26 @ 1
initcall init_mmap_min_addr+0x0/0x26 returned 0 after 0 usecs
calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 usecs
calling  net_ns_init+0x0/0x150 @ 1
initcall net_ns_init+0x0/0x150 returned 0 after 0 usecs
calling  e820_mark_nvs_memory+0x0/0x41 @ 1
initcall e820_mark_nvs_memory+0x0/0x41 returned 0 after 0 usecs
calling  cpufreq_tsc+0x0/0x28 @ 1
initcall cpufreq_tsc+0x0/0x28 returned 0 after 0 usecs
calling  pci_reboot_init+0x0/0x14 @ 1
initcall pci_reboot_init+0x0/0x14 returned 0 after 0 usecs
calling  init_lapic_sysfs+0x0/0x2d @ 1
initcall init_lapic_sysfs+0x0/0x2d returned 0 after 0 usecs
calling  init_smp_flush+0x0/0x21 @ 1
initcall init_smp_flush+0x0/0x21 returned 0 after 0 usecs
calling  alloc_frozen_cpus+0x0/0xa @ 1
initcall alloc_frozen_cpus+0x0/0xa returned 0 after 0 usecs
calling  sysctl_init+0x0/0x16 @ 1
initcall sysctl_init+0x0/0x16 returned 0 after 0 usecs
calling  ksysfs_init+0x0/0x94 @ 1
initcall ksysfs_init+0x0/0x94 returned 0 after 0 usecs
calling  async_init+0x0/0x61 @ 1
initcall async_init+0x0/0x61 returned 0 after 0 usecs
calling  init_jiffies_clocksource+0x0/0x12 @ 1
initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 usecs
calling  pm_init+0x0/0x34 @ 1
initcall pm_init+0x0/0x34 returned 0 after 0 usecs
calling  pm_disk_init+0x0/0x19 @ 1
initcall pm_disk_init+0x0/0x19 returned 0 after 0 usecs
calling  swsusp_header_init+0x0/0x2c @ 1
initcall swsusp_header_init+0x0/0x2c returned 0 after 0 usecs
calling  init_hw_breakpoint+0x0/0x12 @ 1
initcall init_hw_breakpoint+0x0/0x12 returned 0 after 0 usecs
calling  init_zero_pfn+0x0/0x35 @ 1
initcall init_zero_pfn+0x0/0x35 returned 0 after 0 usecs
calling  filelock_init+0x0/0x2e @ 1
initcall filelock_init+0x0/0x2e returned 0 after 0 usecs
calling  init_misc_binfmt+0x0/0x42 @ 1
initcall init_misc_binfmt+0x0/0x42 returned 0 after 0 usecs
calling  init_script_binfmt+0x0/0x14 @ 1
initcall init_script_binfmt+0x0/0x14 returned 0 after 0 usecs
calling  init_elf_binfmt+0x0/0x14 @ 1
initcall init_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
calling  init_compat_elf_binfmt+0x0/0x14 @ 1
initcall init_compat_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
calling  debugfs_init+0x0/0x5a @ 1
initcall debugfs_init+0x0/0x5a returned 0 after 0 usecs
calling  securityfs_init+0x0/0x51 @ 1
initcall securityfs_init+0x0/0x51 returned 0 after 0 usecs
calling  random32_init+0x0/0xd1 @ 1
initcall random32_init+0x0/0xd1 returned 0 after 0 usecs
calling  gnttab_init+0x0/0x169 @ 1
initcall gnttab_init+0x0/0x169 returned -19 after 0 usecs
calling  early_resume_init+0x0/0x19b @ 1
Time: 17:39:27  Date: 03/08/10
initcall early_resume_init+0x0/0x19b returned 0 after 1953 usecs
calling  cpufreq_core_init+0x0/0x8c @ 1
initcall cpufreq_core_init+0x0/0x8c returned 0 after 0 usecs
calling  cpuidle_init+0x0/0x40 @ 1
initcall cpuidle_init+0x0/0x40 returned 0 after 0 usecs
calling  sock_init+0x0/0x5e @ 1
initcall sock_init+0x0/0x5e returned 0 after 0 usecs
calling  netpoll_init+0x0/0x31 @ 1
initcall netpoll_init+0x0/0x31 returned 0 after 0 usecs
calling  netlink_proto_init+0x0/0x14c @ 1
NET: Registered protocol family 16
initcall netlink_proto_init+0x0/0x14c returned 0 after 976 usecs
calling  bdi_class_init+0x0/0x41 @ 1
initcall bdi_class_init+0x0/0x41 returned 0 after 0 usecs
calling  kobject_uevent_init+0x0/0x54 @ 1
initcall kobject_uevent_init+0x0/0x54 returned 0 after 0 usecs
calling  pcibus_class_init+0x0/0x19 @ 1
initcall pcibus_class_init+0x0/0x19 returned 0 after 0 usecs
calling  pci_driver_init+0x0/0x12 @ 1
initcall pci_driver_init+0x0/0x12 returned 0 after 0 usecs
calling  backlight_class_init+0x0/0x5d @ 1
initcall backlight_class_init+0x0/0x5d returned 0 after 0 usecs
calling  xenbus_probe_init+0x0/0xcb @ 1
initcall xenbus_probe_init+0x0/0xcb returned -19 after 0 usecs
calling  tty_class_init+0x0/0x38 @ 1
initcall tty_class_init+0x0/0x38 returned 0 after 0 usecs
calling  vtconsole_class_init+0x0/0xc3 @ 1
initcall vtconsole_class_init+0x0/0xc3 returned 0 after 0 usecs
calling  register_node_type+0x0/0x12 @ 1
initcall register_node_type+0x0/0x12 returned 0 after 0 usecs
calling  i2c_init+0x0/0x6b @ 1
initcall i2c_init+0x0/0x6b returned 0 after 0 usecs
calling  amd_postcore_init+0x0/0x8bd @ 1
node 0 link 1: io port [1000, 3fff]
node 1 link 2: io port [4000, ffff]
TOM: 0000000080000000 aka 2048M
node 0 link 1: mmio [e8000000, fddfffff]
node 1 link 2: mmio [fde00000, fdffffff]
node 0 link 1: mmio [80000000, 83ffffff]
node 1 link 2: mmio [84000000, 8fffffff]
node 0 link 1: mmio [a0000, bffff]
TOM2: 0000000280000000 aka 10240M
bus: [00, 3f] on node 0 link 1
bus: 00 index 0 [io  0x0000-0x3fff]
bus: 00 index 1 [mem 0x90000000-0xfddfffff]
bus: 00 index 2 [mem 0x80000000-0x83ffffff]
bus: 00 index 3 [mem 0x000a0000-0x000bffff]
bus: 00 index 4 [mem 0xfe000000-0xffffffff]
bus: 00 index 5 [mem 0x280000000-0xfcffffffff]
bus: [40, ff] on node 1 link 2
bus: 40 index 0 [io  0x4000-0xffff]
bus: 40 index 1 [mem 0xfde00000-0xfdffffff]
bus: 40 index 2 [mem 0x84000000-0x8fffffff]
initcall amd_postcore_init+0x0/0x8bd returned 0 after 22460 usecs
calling  arch_kdebugfs_init+0x0/0x242 @ 1
initcall arch_kdebugfs_init+0x0/0x242 returned 0 after 0 usecs
calling  mtrr_if_init+0x0/0x63 @ 1
initcall mtrr_if_init+0x0/0x63 returned 0 after 0 usecs
calling  ffh_cstate_init+0x0/0x2a @ 1
initcall ffh_cstate_init+0x0/0x2a returned -1 after 0 usecs
initcall ffh_cstate_init+0x0/0x2a returned with error code -1 
calling  acpi_pci_init+0x0/0x5c @ 1
ACPI: bus type pci registered
initcall acpi_pci_init+0x0/0x5c returned 0 after 976 usecs
calling  setup_vcpu_hotplug_event+0x0/0x22 @ 1
initcall setup_vcpu_hotplug_event+0x0/0x22 returned -19 after 0 usecs
calling  dmi_id_init+0x0/0x31a @ 1
initcall dmi_id_init+0x0/0x31a returned 0 after 0 usecs
calling  dma_bus_init+0x0/0x3f @ 1
initcall dma_bus_init+0x0/0x3f returned 0 after 0 usecs
calling  dma_channel_table_init+0x0/0xbf @ 1
initcall dma_channel_table_init+0x0/0xbf returned 0 after 0 usecs
calling  pci_arch_init+0x0/0x69 @ 1
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
PCI: not using MMCONFIG
PCI: Using configuration type 1 for base access
PCI: HP ProLiant BL685c G1 detected, enabling pci=bfsort.
initcall pci_arch_init+0x0/0x69 returned 0 after 3906 usecs
calling  topology_init+0x0/0x86 @ 1
initcall topology_init+0x0/0x86 returned 0 after 0 usecs
calling  mtrr_init_finialize+0x0/0x3d @ 1
initcall mtrr_init_finialize+0x0/0x3d returned 0 after 0 usecs
calling  param_sysfs_init+0x0/0x216 @ 1
initcall param_sysfs_init+0x0/0x216 returned 0 after 4882 usecs
calling  pm_sysrq_init+0x0/0x19 @ 1
initcall pm_sysrq_init+0x0/0x19 returned 0 after 0 usecs
calling  audit_watch_init+0x0/0x2f @ 1
initcall audit_watch_init+0x0/0x2f returned 0 after 0 usecs
calling  init_slow_work+0x0/0x39 @ 1
initcall init_slow_work+0x0/0x39 returned 0 after 0 usecs
calling  default_bdi_init+0x0/0xb6 @ 1
initcall default_bdi_init+0x0/0xb6 returned 0 after 0 usecs
calling  init_bio+0x0/0xe2 @ 1
bio: create slab <bio-0> at 0
initcall init_bio+0x0/0xe2 returned 0 after 976 usecs
calling  fsnotify_init+0x0/0x12 @ 1
initcall fsnotify_init+0x0/0x12 returned 0 after 0 usecs
calling  fsnotify_notification_init+0x0/0x68 @ 1
initcall fsnotify_notification_init+0x0/0x68 returned 0 after 0 usecs
calling  cryptomgr_init+0x0/0x12 @ 1
initcall cryptomgr_init+0x0/0x12 returned 0 after 0 usecs
calling  blk_settings_init+0x0/0x2a @ 1
initcall blk_settings_init+0x0/0x2a returned 0 after 0 usecs
calling  blk_ioc_init+0x0/0x2a @ 1
initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
calling  blk_softirq_init+0x0/0x6e @ 1
initcall blk_softirq_init+0x0/0x6e returned 0 after 0 usecs
calling  blk_iopoll_setup+0x0/0x6e @ 1
initcall blk_iopoll_setup+0x0/0x6e returned 0 after 0 usecs
calling  genhd_device_init+0x0/0x66 @ 1
initcall genhd_device_init+0x0/0x66 returned 0 after 0 usecs
calling  pci_slot_init+0x0/0x45 @ 1
initcall pci_slot_init+0x0/0x45 returned 0 after 0 usecs
calling  fbmem_init+0x0/0x98 @ 1
initcall fbmem_init+0x0/0x98 returned 0 after 0 usecs
calling  acpi_init+0x0/0x2d8 @ 1
ACPI: EC: Look up EC in DSDT
ACPI: SSDT 000000007fe58000 004F0 (v02 HP     PNOWSSDT 00000002 HP   00000001)
ACPI: Interpreter enabled
ACPI: (supports S0 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in ACPI motherboard resources
initcall acpi_init+0x0/0x2d8 returned 0 after 41015 usecs
calling  dock_init+0x0/0xa5 @ 1
ACPI: No dock devices found.
initcall dock_init+0x0/0xa5 returned 0 after 976 usecs
calling  acpi_pci_root_init+0x0/0x2d @ 1
PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci_root PNP0A03:00: host bridge window [io  0x0000-0x03af] (ignored)
pci_root PNP0A03:00: host bridge window [io  0x03b0-0x03bb] (ignored)
pci_root PNP0A03:00: host bridge window [io  0x03c0-0x03df] (ignored)
pci_root PNP0A03:00: host bridge window [io  0x03e0-0x0fff] (ignored)
pci_root PNP0A03:00: host bridge window [io  0x1000-0x3fff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0xe8000000-0xfddfffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0x80000000-0x83ffffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
pci 0000:00:02.0: reg 10: [mem 0xf7de0000-0xf7de0fff]
pci 0000:00:02.0: supports D1 D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: reg 10: [mem 0xf7dd0000-0xf7dd00ff]
pci 0000:00:02.1: supports D1 D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.1: PME# disabled
pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0b.0: PME# disabled
pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0c.0: PME# disabled
pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0d.0: PME# disabled
pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0e.0: PME# disabled
PCI: peer root bus 00 res updated from pci conf
pci 0000:01:03.0: reg 10: [mem 0xe8000000-0xefffffff pref]
pci 0000:01:03.0: reg 14: [io  0x1000-0x10ff]
pci 0000:01:03.0: reg 18: [mem 0xf7ff0000-0xf7ffffff]
pci 0000:01:03.0: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:01:03.0: supports D1 D2
pci 0000:01:04.0: reg 10: [io  0x2800-0x28ff]
pci 0000:01:04.0: reg 14: [mem 0xf7fe0000-0xf7fe01ff]
pci 0000:01:04.0: PME# supported from D0 D3hot D3cold
pci 0000:01:04.0: PME# disabled
pci 0000:01:04.2: reg 10: [io  0x1400-0x14ff]
pci 0000:01:04.2: reg 14: [mem 0xf7fd0000-0xf7fd07ff]
pci 0000:01:04.2: reg 18: [mem 0xf7fc0000-0xf7fc3fff]
pci 0000:01:04.2: reg 1c: [mem 0xf7f00000-0xf7f7ffff]
pci 0000:01:04.2: reg 30: [mem 0x00000000-0x0000ffff pref]
pci 0000:01:04.2: PME# supported from D0 D3hot D3cold
pci 0000:01:04.2: PME# disabled
pci 0000:01:04.4: reg 20: [io  0x1800-0x181f]
pci 0000:01:04.4: PME# supported from D0 D3hot D3cold
pci 0000:01:04.4: PME# disabled
pci 0000:01:04.6: reg 10: [mem 0xf7ef0000-0xf7ef00ff]
pci 0000:01:04.6: PME# supported from D0 D3hot D3cold
pci 0000:01:04.6: PME# disabled
pci 0000:00:09.0: PCI bridge to [bus 01-01] (subtractive decode)
pci 0000:00:09.0:   bridge window [io  0x1000-0x2fff]
pci 0000:00:09.0:   bridge window [mem 0xf7e00000-0xf7ffffff]
pci 0000:00:09.0:   bridge window [mem 0xe8000000-0xefffffff pref]
pci 0000:00:09.0:   bridge window [io  0x0000-0x3fff] (subtractive decode)
pci 0000:00:09.0:   bridge window [mem 0x90000000-0xfddfffff] (subtractive decode)
pci 0000:00:09.0:   bridge window [mem 0x80000000-0x83ffffff] (subtractive decode)
pci 0000:00:09.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:09.0:   bridge window [mem 0xfe000000-0xffffffff] (subtractive decode)
pci 0000:00:09.0:   bridge window [mem 0x280000000-0xfcffffffff] (subtractive decode)
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:0b.0: PCI bridge to [bus 02-03]
pci 0000:00:0b.0:   bridge window [io  fffffffffffff000 - 0000] reg reading
pci 0000:00:0b.0:   bridge window [mem 0xf8000000-0xf9ffffff]
pci 0000:00:0b.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
pci 0000:03:00.0: reg 10: [mem 0xf8000000-0xf9ffffff 64bit]
pci 0000:03:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:03:00.0: PME# supported from D3hot D3cold
pci 0000:03:00.0: PME# disabled
pci 0000:02:00.0: PCI bridge to [bus 03-03]
pci 0000:02:00.0:   bridge window [io  fffffffffffff000 - 0000] reg reading
pci 0000:02:00.0:   bridge window [mem 0xf8000000-0xf9ffffff]
pci 0000:02:00.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
pci 0000:04:00.0: PME# disabled
pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:0c.0: PCI bridge to [bus 04-05]
pci 0000:00:0c.0:   bridge window [io  fffffffffffff000 - 0000] reg reading
pci 0000:00:0c.0:   bridge window [mem 0xfa000000-0xfbffffff]
pci 0000:00:0c.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
pci 0000:05:00.0: reg 10: [mem 0xfa000000-0xfbffffff 64bit]
pci 0000:05:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:05:00.0: PME# supported from D3hot D3cold
pci 0000:05:00.0: PME# disabled
pci 0000:04:00.0: PCI bridge to [bus 05-05]
pci 0000:04:00.0:   bridge window [io  fffffffffffff000 - 0000] reg reading
pci 0000:04:00.0:   bridge window [mem 0xfa000000-0xfbffffff]
pci 0000:04:00.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
pci 0000:06:00.0: PME# disabled
pci 0000:06:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:0d.0: PCI bridge to [bus 06-07]
pci 0000:00:0d.0:   bridge window [io  fffffffffffff000 - 0000] reg reading
pci 0000:00:0d.0:   bridge window [mem 0xfdc00000-0xfdcfffff]
pci 0000:00:0d.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
pci 0000:07:04.0: reg 10: [mem 0xfdcf0000-0xfdcfffff 64bit]
pci 0000:07:04.0: reg 18: [mem 0xfdce0000-0xfdceffff 64bit]
pci 0000:07:04.0: PME# supported from D3hot D3cold
pci 0000:07:04.0: PME# disabled
pci 0000:07:04.1: reg 10: [mem 0xfdcd0000-0xfdcdffff 64bit]
pci 0000:07:04.1: reg 18: [mem 0xfdcc0000-0xfdccffff 64bit]
pci 0000:07:04.1: PME# supported from D3hot D3cold
pci 0000:07:04.1: PME# disabled
pci 0000:06:00.0: PCI bridge to [bus 07-07]
pci 0000:06:00.0:   bridge window [io  fffffffffffff000 - 0000] reg reading
pci 0000:06:00.0:   bridge window [mem 0xfdc00000-0xfdcfffff]
pci 0000:06:00.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
pci 0000:08:00.0: reg 10: [mem 0xfddf0000-0xfddf0fff 64bit]
pci 0000:08:00.0: reg 18: [mem 0xfdde0000-0xfdde00ff 64bit]
pci 0000:08:00.0: reg 20: [io  0x3000-0x30ff]
pci 0000:08:00.0: reg 30: [mem 0x00000000-0x0003ffff pref]
pci 0000:08:00.1: reg 10: [mem 0xfddd0000-0xfddd0fff 64bit]
pci 0000:08:00.1: reg 18: [mem 0xfddc0000-0xfddc00ff 64bit]
pci 0000:08:00.1: reg 20: [io  0x3400-0x34ff]
pci 0000:08:00.1: reg 30: [mem 0x00000000-0x0003ffff pref]
pci 0000:08:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:0e.0: PCI bridge to [bus 08-0a]
pci 0000:00:0e.0:   bridge window [io  0x3000-0x3fff]
pci 0000:00:0e.0:   bridge window [mem 0xfdd00000-0xfddfffff]
pci 0000:00:0e.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IP2P._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE1.NB01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE2.NC1B._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE3.NC2B._PRT]
ACPI: PCI Root Bridge [PCI1] (0000:40)
pci_root PNP0A03:01: host bridge window [io  0x4000-0xffff] (ignored)
pci_root PNP0A03:01: host bridge window [mem 0xfde00000-0xfdffffff] (ignored)
pci_root PNP0A03:01: host bridge window [mem 0x84000000-0x8fffffff] (ignored)
pci 0000:40:01.0: reg 14: [mem 0xfdef0000-0xfdef0fff]
pci 0000:40:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:40:0c.0: PME# disabled
pci 0000:40:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:40:0d.0: PME# disabled
pci 0000:40:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:40:0e.0: PME# disabled
PCI: peer root bus 40 res updated from pci conf
pci 0000:41:00.0: PME# supported from D0 D3hot D3cold
pci 0000:41:00.0: PME# disabled
pci 0000:41:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:40:0c.0: PCI bridge to [bus 41-43]
pci 0000:40:0c.0:   bridge window [io  0x4000-0x4fff]
pci 0000:40:0c.0:   bridge window [mem 0xfdf00000-0xfdffffff]
pci 0000:40:0c.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
pci 0000:42:08.0: reg 10: [mem 0xfdf80000-0xfdffffff 64bit]
pci 0000:42:08.0: reg 18: [io  0x4000-0x40ff]
pci 0000:42:08.0: reg 1c: [mem 0xfdf70000-0xfdf77fff]
pci 0000:42:08.0: reg 30: [mem 0x00000000-0x00003fff pref]
pci 0000:42:08.0: supports D1
pci 0000:41:00.0: PCI bridge to [bus 42-43]
pci 0000:41:00.0:   bridge window [io  0x4000-0x4fff]
pci 0000:41:00.0:   bridge window [mem 0xfdf00000-0xfdffffff]
pci 0000:41:00.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
pci 0000:42:04.0: PCI bridge to [bus 43-43]
pci 0000:42:04.0:   bridge window [io  fffffffffffff000 - 0000] reg reading
pci 0000:42:04.0:   bridge window [mem 0xfff00000 - 0x000fffff] reg reading
pci 0000:42:04.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
pci 0000:40:0d.0: PCI bridge to [bus 44-46]
pci 0000:40:0d.0:   bridge window [io  fffffffffffff000 - 0000] reg reading
pci 0000:40:0d.0:   bridge window [mem 0xfff00000 - 0x000fffff] reg reading
pci 0000:40:0d.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
pci 0000:40:0e.0: PCI bridge to [bus 47-49]
pci 0000:40:0e.0:   bridge window [io  fffffffffffff000 - 0000] reg reading
pci 0000:40:0e.0:   bridge window [mem 0xfff00000 - 0x000fffff] reg reading
pci 0000:40:0e.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE2.SASB._PRT]
initcall acpi_pci_root_init+0x0/0x2d returned 0 after 177734 usecs
calling  acpi_pci_link_init+0x0/0x43 @ 1
ACPI: PCI Interrupt Link [LNKW] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [LNKX] (IRQs 17) *0, disabled.
ACPI: PCI Interrupt Link [LNKY] (IRQs 18) *0, disabled.
ACPI: PCI Interrupt Link [LNKZ] (IRQs 19) *0, disabled.
ACPI: PCI Interrupt Link [LNU0] (IRQs 22) *5
ACPI: PCI Interrupt Link [LNU2] (IRQs 23) *7
ACPI: PCI Interrupt Link [LNKA] (IRQs 54) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 55) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 56) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 57) *0, disabled.
initcall acpi_pci_link_init+0x0/0x43 returned 0 after 27343 usecs
calling  pnp_init+0x0/0x12 @ 1
initcall pnp_init+0x0/0x12 returned 0 after 0 usecs
calling  setup_shutdown_event+0x0/0x14 @ 1
initcall setup_shutdown_event+0x0/0x14 returned 0 after 0 usecs
calling  balloon_init+0x0/0x1b1 @ 1
initcall balloon_init+0x0/0x1b1 returned -19 after 0 usecs
calling  misc_init+0x0/0xb8 @ 1
initcall misc_init+0x0/0xb8 returned 0 after 0 usecs
calling  vga_arb_device_init+0x0/0x78 @ 1
vgaarb: device added: PCI:0000:01:03.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
initcall vga_arb_device_init+0x0/0x78 returned 0 after 1953 usecs
calling  cn_init+0x0/0x9e @ 1
initcall cn_init+0x0/0x9e returned 0 after 0 usecs
calling  init_scsi+0x0/0x91 @ 1
SCSI subsystem initialized
initcall init_scsi+0x0/0x91 returned 0 after 976 usecs
calling  ata_init+0x0/0x34e @ 1
libata version 3.00 loaded.
initcall ata_init+0x0/0x34e returned 0 after 13671 usecs
calling  init_pcmcia_cs+0x0/0x25 @ 1
initcall init_pcmcia_cs+0x0/0x25 returned 0 after 0 usecs
calling  usb_init+0x0/0x175 @ 1
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
initcall usb_init+0x0/0x175 returned 0 after 50781 usecs
calling  serio_init+0x0/0x89 @ 1
initcall serio_init+0x0/0x89 returned 0 after 976 usecs
calling  input_init+0x0/0x132 @ 1
initcall input_init+0x0/0x132 returned 0 after 0 usecs
calling  rtc_init+0x0/0x71 @ 1
initcall rtc_init+0x0/0x71 returned 0 after 0 usecs
calling  power_supply_class_init+0x0/0x38 @ 1
initcall power_supply_class_init+0x0/0x38 returned 0 after 0 usecs
calling  thermal_init+0x0/0x40 @ 1
initcall thermal_init+0x0/0x40 returned 0 after 0 usecs
calling  md_init+0x0/0xd0 @ 1
initcall md_init+0x0/0xd0 returned 0 after 0 usecs
calling  leds_init+0x0/0x40 @ 1
initcall leds_init+0x0/0x40 returned 0 after 0 usecs
calling  pci_subsys_init+0x0/0xdb @ 1
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009f400 - 000000000009ffff 
reserve RAM buffer: 000000007fe50000 - 000000007fffffff 
reserve RAM buffer: 000000027ffff000 - 000000027fffffff initcall pci_subsys_init+0x0/0xdb returned 0 after 109375 usecs
calling  proto_init+0x0/0x12 @ 1
initcall proto_init+0x0/0x12 returned 0 after 0 usecs
calling  net_dev_init+0x0/0x177 @ 1
initcall net_dev_init+0x0/0x177 returned 0 after 0 usecs
calling  neigh_init+0x0/0x71 @ 1
initcall neigh_init+0x0/0x71 returned 0 after 0 usecs
calling  fib_rules_init+0x0/0xa6 @ 1
initcall fib_rules_init+0x0/0xa6 returned 0 after 0 usecs
calling  pktsched_init+0x0/0xdc @ 1
initcall pktsched_init+0x0/0xdc returned 0 after 0 usecs
calling  tc_filter_init+0x0/0x4c @ 1
initcall tc_filter_init+0x0/0x4c returned 0 after 0 usecs
calling  tc_action_init+0x0/0x4c @ 1
initcall tc_action_init+0x0/0x4c returned 0 after 0 usecs
calling  genl_init+0x0/0x8f @ 1
initcall genl_init+0x0/0x8f returned 0 after 0 usecs
calling  cipso_v4_init+0x0/0x67 @ 1
initcall cipso_v4_init+0x0/0x67 returned 0 after 0 usecs
calling  wireless_nlevent_init+0x0/0x12 @ 1
initcall wireless_nlevent_init+0x0/0x12 returned 0 after 0 usecs
calling  netlbl_init+0x0/0x83 @ 1
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
initcall netlbl_init+0x0/0x83 returned 0 after 51757 usecs
calling  sysctl_init+0x0/0x49 @ 1
initcall sysctl_init+0x0/0x49 returned 0 after 0 usecs
calling  print_ICs+0x0/0x506 @ 1
initcall print_ICs+0x0/0x506 returned 0 after 0 usecs
calling  hpet_late_init+0x0/0x1ed @ 1
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
hpet0: 3 comparators, 32-bit 25.000000 MHz counter
initcall hpet_late_init+0x0/0x1ed returned 0 after 52734 usecs
calling  clocksource_done_booting+0x0/0x36 @ 1
Switching to clocksource hpet
initcall clocksource_done_booting+0x0/0x36 returned 0 after 15707 usecs
calling  rb_init_debugfs+0x0/0x2f @ 1
initcall rb_init_debugfs+0x0/0x2f returned 0 after 4 usecs
calling  tracer_init_debugfs+0x0/0x362 @ 1
initcall tracer_init_debugfs+0x0/0x362 returned 0 after 82 usecs
calling  init_trace_printk_function_export+0x0/0x2f @ 1
initcall init_trace_printk_function_export+0x0/0x2f returned 0 after 2 usecs
calling  event_trace_init+0x0/0x1eb @ 1
initcall event_trace_init+0x0/0x1eb returned 0 after 1131 usecs
calling  init_kprobe_trace+0x0/0x78 @ 1
initcall init_kprobe_trace+0x0/0x78 returned 0 after 5 usecs
calling  init_pipe_fs+0x0/0x4c @ 1
initcall init_pipe_fs+0x0/0x4c returned 0 after 13 usecs
calling  eventpoll_init+0x0/0xc3 @ 1
initcall eventpoll_init+0x0/0xc3 returned 0 after 6 usecs
calling  anon_inode_init+0x0/0x123 @ 1
initcall anon_inode_init+0x0/0x123 returned 0 after 6 usecs
calling  blk_scsi_ioctl_init+0x0/0x289 @ 1
initcall blk_scsi_ioctl_init+0x0/0x289 returned 0 after 1 usecs
calling  acpi_event_init+0x0/0x80 @ 1
initcall acpi_event_init+0x0/0x80 returned 0 after 10 usecs
calling  pnpacpi_init+0x0/0x8c @ 1
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
initcall pnpacpi_init+0x0/0x8c returned 0 after 54667 usecs
calling  pnp_system_init+0x0/0x12 @ 1
system 00:01: [io  0x0408-0x040f] has been reserved
system 00:01: [io  0x04d0-0x04d1] has been reserved
system 00:01: [io  0x0700-0x073f] has been reserved
system 00:01: [io  0x0800-0x08fe] has been reserved
system 00:01: [io  0x0900-0x09fe] has been reserved
system 00:01: [io  0x09ff] has been reserved
system 00:01: [io  0x0a00-0x0afe] has been reserved
system 00:01: [io  0x0aff] has been reserved
system 00:01: [io  0x0b00-0x0bfe] has been reserved
system 00:01: [io  0x0bff] has been reserved
system 00:01: [io  0x0c80-0x0c83] has been reserved
system 00:01: [io  0x0cd4-0x0cd7] has been reserved
system 00:01: [io  0x0f50-0x0f58] has been reserved
system 00:01: [io  0x0ca0-0x0ca1] has been reserved
system 00:01: [io  0x0ca4-0x0ca5] has been reserved
system 00:01: [io  0x0cf9] could not be reserved
system 00:01: [io  0x03f8-0x03ff] has been reserved
system 00:01: [mem 0x80000000-0x8fffffff] could not be reserved
system 00:01: [mem 0xf7df0000-0xf7df0fff] could not be reserved
system 00:01: [mem 0xfdef0000-0xfdef0fff] could not be reserved
initcall pnp_system_init+0x0/0x12 returned 0 after 386706 usecs
calling  chr_dev_init+0x0/0xc7 @ 1
initcall chr_dev_init+0x0/0xc7 returned 0 after 527 usecs
calling  firmware_class_init+0x0/0x79 @ 1
initcall firmware_class_init+0x0/0x79 returned 0 after 48 usecs
calling  init_pcmcia_bus+0x0/0x65 @ 1
initcall init_pcmcia_bus+0x0/0x65 returned 0 after 61 usecs
calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
initcall cpufreq_gov_performance_init+0x0/0x12 returned 0 after 1 usecs
calling  cpufreq_gov_dbs_init+0x0/0xaf @ 1
initcall cpufreq_gov_dbs_init+0x0/0xaf returned 0 after 253 usecs
calling  init_acpi_pm_clocksource+0x0/0xef @ 1
initcall init_acpi_pm_clocksource+0x0/0xef returned 0 after 4425 usecs
calling  pcibios_assign_resources+0x0/0x76 @ 1
PCI: max bus depth: 3 pci_try_num: 4
pci 0000:00:0b.0: BAR 9: assigned [mem 0x90000000-0x900fffff pref]
pci 0000:00:0c.0: BAR 9: assigned [mem 0x90100000-0x901fffff pref]
pci 0000:00:0e.0: BAR 9: assigned [mem 0x90200000-0x902fffff pref]
pci 0000:01:03.0: BAR 6: assigned [mem 0xf7e00000-0xf7e1ffff pref]
pci 0000:01:04.2: BAR 6: assigned [mem 0xf7e20000-0xf7e2ffff pref]
pci 0000:00:09.0: PCI bridge to [bus 01-01]
pci 0000:00:09.0:   bridge window [io  0x1000-0x2fff]
pci 0000:00:09.0:   bridge window [mem 0xf7e00000-0xf7ffffff]
pci 0000:00:09.0:   bridge window [mem 0xe8000000-0xefffffff pref]
pci 0000:02:00.0: BAR 9: assigned [mem 0x90000000-0x900fffff pref]
pci 0000:03:00.0: BAR 6: assigned [mem 0x90000000-0x9001ffff pref]
pci 0000:02:00.0: PCI bridge to [bus 03-03]
pci 0000:02:00.0:   bridge window [io  disabled]
pci 0000:02:00.0:   bridge window [mem 0xf8000000-0xf9ffffff]
pci 0000:02:00.0:   bridge window [mem 0x90000000-0x900fffff pref]
pci 0000:00:0b.0: PCI bridge to [bus 02-03]
pci 0000:00:0b.0:   bridge window [io  disabled]
pci 0000:00:0b.0:   bridge window [mem 0xf8000000-0xf9ffffff]
pci 0000:00:0b.0:   bridge window [mem 0x90000000-0x900fffff pref]
pci 0000:04:00.0: BAR 9: assigned [mem 0x90100000-0x901fffff pref]
pci 0000:05:00.0: BAR 6: assigned [mem 0x90100000-0x9011ffff pref]
pci 0000:04:00.0: PCI bridge to [bus 05-05]
pci 0000:04:00.0:   bridge window [io  disabled]
pci 0000:04:00.0:   bridge window [mem 0xfa000000-0xfbffffff]
pci 0000:04:00.0:   bridge window [mem 0x90100000-0x901fffff pref]
pci 0000:00:0c.0: PCI bridge to [bus 04-05]
pci 0000:00:0c.0:   bridge window [io  disabled]
pci 0000:00:0c.0:   bridge window [mem 0xfa000000-0xfbffffff]
pci 0000:00:0c.0:   bridge window [mem 0x90100000-0x901fffff pref]
pci 0000:06:00.0: PCI bridge to [bus 07-07]
pci 0000:06:00.0:   bridge window [io  disabled]
pci 0000:06:00.0:   bridge window [mem 0xfdc00000-0xfdcfffff]
pci 0000:06:00.0:   bridge window [mem pref disabled]
pci 0000:00:0d.0: PCI bridge to [bus 06-07]
pci 0000:00:0d.0:   bridge window [io  disabled]
pci 0000:00:0d.0:   bridge window [mem 0xfdc00000-0xfdcfffff]
pci 0000:00:0d.0:   bridge window [mem pref disabled]
pci 0000:08:00.0: BAR 6: assigned [mem 0x90200000-0x9023ffff pref]
pci 0000:08:00.1: BAR 6: assigned [mem 0x90240000-0x9027ffff pref]
pci 0000:00:0e.0: PCI bridge to [bus 08-0a]
pci 0000:00:0e.0:   bridge window [io  0x3000-0x3fff]
pci 0000:00:0e.0:   bridge window [mem 0xfdd00000-0xfddfffff]
pci 0000:00:0e.0:   bridge window [mem 0x90200000-0x902fffff pref]
pci 0000:40:0c.0: BAR 9: assigned [mem 0x84000000-0x840fffff pref]
pci 0000:41:00.0: BAR 9: assigned [mem 0x84000000-0x840fffff pref]
pci 0000:42:08.0: BAR 6: assigned [mem 0x84000000-0x84003fff pref]
pci 0000:42:04.0: PCI bridge to [bus 43-43]
pci 0000:42:04.0:   bridge window [io  disabled]
pci 0000:42:04.0:   bridge window [mem disabled]
pci 0000:42:04.0:   bridge window [mem pref disabled]
pci 0000:41:00.0: PCI bridge to [bus 42-43]
pci 0000:41:00.0:   bridge window [io  0x4000-0x4fff]
pci 0000:41:00.0:   bridge window [mem 0xfdf00000-0xfdffffff]
pci 0000:41:00.0:   bridge window [mem 0x84000000-0x840fffff pref]
pci 0000:40:0c.0: PCI bridge to [bus 41-43]
pci 0000:40:0c.0:   bridge window [io  0x4000-0x4fff]
pci 0000:40:0c.0:   bridge window [mem 0xfdf00000-0xfdffffff]
pci 0000:40:0c.0:   bridge window [mem 0x84000000-0x840fffff pref]
pci 0000:40:0d.0: PCI bridge to [bus 44-46]
pci 0000:40:0d.0:   bridge window [io  disabled]
pci 0000:40:0d.0:   bridge window [mem disabled]
pci 0000:40:0d.0:   bridge window [mem pref disabled]
pci 0000:40:0e.0: PCI bridge to [bus 47-49]
pci 0000:40:0e.0:   bridge window [io  disabled]
pci 0000:40:0e.0:   bridge window [mem disabled]
pci 0000:40:0e.0:   bridge window [mem pref disabled]
pci 0000:00:09.0: setting latency timer to 64
pci 0000:00:0b.0: setting latency timer to 64
pci 0000:02:00.0: setting latency timer to 64
pci 0000:00:0c.0: setting latency timer to 64
pci 0000:04:00.0: setting latency timer to 64
pci 0000:00:0d.0: setting latency timer to 64
pci 0000:06:00.0: setting latency timer to 64
pci 0000:00:0e.0: setting latency timer to 64
pci 0000:40:0c.0: setting latency timer to 64
pci 0000:41:00.0: setting latency timer to 64
pci 0000:40:0d.0: setting latency timer to 64
pci 0000:40:0e.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0x3fff]
pci_bus 0000:00: resource 5 [mem 0x90000000-0xfddfffff]
pci_bus 0000:00: resource 6 [mem 0x80000000-0x83ffffff]
pci_bus 0000:00: resource 7 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 8 [mem 0xfe000000-0xffffffff]
pci_bus 0000:00: resource 9 [mem 0x280000000-0xfcffffffff]
pci_bus 0000:01: resource 0 [io  0x1000-0x2fff]
pci_bus 0000:01: resource 1 [mem 0xf7e00000-0xf7ffffff]
pci_bus 0000:01: resource 2 [mem 0xe8000000-0xefffffff pref]
pci_bus 0000:01: resource 4 [io  0x0000-0x3fff]
pci_bus 0000:01: resource 5 [mem 0x90000000-0xfddfffff]
pci_bus 0000:01: resource 6 [mem 0x80000000-0x83ffffff]
pci_bus 0000:01: resource 7 [mem 0x000a0000-0x000bffff]
pci_bus 0000:01: resource 8 [mem 0xfe000000-0xffffffff]
pci_bus 0000:01: resource 9 [mem 0x280000000-0xfcffffffff]
pci_bus 0000:02: resource 1 [mem 0xf8000000-0xf9ffffff]
pci_bus 0000:02: resource 2 [mem 0x90000000-0x900fffff pref]
pci_bus 0000:03: resource 1 [mem 0xf8000000-0xf9ffffff]
pci_bus 0000:03: resource 2 [mem 0x90000000-0x900fffff pref]
pci_bus 0000:04: resource 1 [mem 0xfa000000-0xfbffffff]
pci_bus 0000:04: resource 2 [mem 0x90100000-0x901fffff pref]
pci_bus 0000:05: resource 1 [mem 0xfa000000-0xfbffffff]
pci_bus 0000:05: resource 2 [mem 0x90100000-0x901fffff pref]
pci_bus 0000:06: resource 1 [mem 0xfdc00000-0xfdcfffff]
pci_bus 0000:07: resource 1 [mem 0xfdc00000-0xfdcfffff]
pci_bus 0000:08: resource 0 [io  0x3000-0x3fff]
pci_bus 0000:08: resource 1 [mem 0xfdd00000-0xfddfffff]
pci_bus 0000:08: resource 2 [mem 0x90200000-0x902fffff pref]
pci_bus 0000:40: resource 4 [io  0x4000-0xffff]
pci_bus 0000:40: resource 5 [mem 0xfde00000-0xfdffffff]
pci_bus 0000:40: resource 6 [mem 0x84000000-0x8fffffff]
pci_bus 0000:41: resource 0 [io  0x4000-0x4fff]
pci_bus 0000:41: resource 1 [mem 0xfdf00000-0xfdffffff]
pci_bus 0000:41: resource 2 [mem 0x84000000-0x840fffff pref]
pci_bus 0000:42: resource 0 [io  0x4000-0x4fff]
pci_bus 0000:42: resource 1 [mem 0xfdf00000-0xfdffffff]
pci_bus 0000:42: resource 2 [mem 0x84000000-0x840fffff pref]
initcall pcibios_assign_resources+0x0/0x76 returned 0 after 2256839 usecs
calling  sysctl_core_init+0x0/0x38 @ 1
initcall sysctl_core_init+0x0/0x38 returned 0 after 8 usecs
calling  inet_init+0x0/0x204 @ 1
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
UDP hash table entries: 4096 (order: 5, 131072 bytes)
UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
initcall inet_init+0x0/0x204 returned 0 after 148847 usecs
calling  af_unix_init+0x0/0x55 @ 1
NET: Registered protocol family 1
initcall af_unix_init+0x0/0x55 returned 0 after 17666 usecs
calling  pci_apply_final_quirks+0x0/0xef @ 1
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:0b.0: Found disabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:0c.0: Found enabled HT MSI Mapping
pci 0000:00:0d.0: Found enabled HT MSI Mapping
pci 0000:00:0e.0: Found enabled HT MSI Mapping
pci 0000:01:03.0: Boot video device
pci 0000:01:04.4: HCRESET not completed yet!
pci 0000:40:0c.0: Found enabled HT MSI Mapping
pci 0000:40:0d.0: Found enabled HT MSI Mapping
pci 0000:40:0e.0: Found enabled HT MSI Mapping
PCI: CLS 64 bytes, default 64
initcall pci_apply_final_quirks+0x0/0xef returned 0 after 238159 usecs
calling  populate_rootfs+0x0/0x237 @ 1
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 2531k freed
initcall populate_rootfs+0x0/0x237 returned 0 after 78742 usecs
calling  pci_iommu_init+0x0/0x31 @ 1
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 20000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
initcall pci_iommu_init+0x0/0x31 returned 0 after 72668 usecs
calling  calgary_fixup_tce_spaces+0x0/0xee @ 1
initcall calgary_fixup_tce_spaces+0x0/0xee returned -19 after 0 usecs
calling  i8259A_init_sysfs+0x0/0x22 @ 1
initcall i8259A_init_sysfs+0x0/0x22 returned 0 after 141 usecs
calling  vsyscall_init+0x0/0x6c @ 1
initcall vsyscall_init+0x0/0x6c returned 0 after 13 usecs
calling  sbf_init+0x0/0xd7 @ 1
initcall sbf_init+0x0/0xd7 returned 0 after 0 usecs
calling  i8237A_init_sysfs+0x0/0x22 @ 1
initcall i8237A_init_sysfs+0x0/0x22 returned 0 after 106 usecs
calling  add_rtc_cmos+0x0/0xa4 @ 1
platform rtc_cmos: registered platform RTC device (no PNP device found)
initcall add_rtc_cmos+0x0/0xa4 returned 0 after 24157 usecs
calling  cache_sysfs_init+0x0/0x59 @ 1
initcall cache_sysfs_init+0x0/0x59 returned 0 after 933 usecs
calling  mcheck_init_device+0x0/0xf2 @ 1
initcall mcheck_init_device+0x0/0xf2 returned 0 after 360 usecs
calling  threshold_init_device+0x0/0x44 @ 1
initcall threshold_init_device+0x0/0x44 returned 0 after 1 usecs
calling  thermal_throttle_init_device+0x0/0x89 @ 1
initcall thermal_throttle_init_device+0x0/0x89 returned 0 after 0 usecs
calling  msr_init+0x0/0x10b @ 1
initcall msr_init+0x0/0x10b returned 0 after 306 usecs
calling  cpuid_init+0x0/0x10b @ 1
initcall cpuid_init+0x0/0x10b returned 0 after 293 usecs
calling  ioapic_init_sysfs+0x0/0x99 @ 1
initcall ioapic_init_sysfs+0x0/0x99 returned 0 after 155 usecs
calling  add_pcspkr+0x0/0x28 @ 1
initcall add_pcspkr+0x0/0x28 returned 0 after 62 usecs
calling  audit_classes_init+0x0/0xaf @ 1
initcall audit_classes_init+0x0/0xaf returned 0 after 6 usecs
calling  init_vdso_vars+0x0/0x19d @ 1
initcall init_vdso_vars+0x0/0x19d returned 0 after 15 usecs
calling  ia32_binfmt_init+0x0/0x14 @ 1
initcall ia32_binfmt_init+0x0/0x14 returned 0 after 1 usecs
calling  sysenter_setup+0x0/0x2cc @ 1
initcall sysenter_setup+0x0/0x2cc returned 0 after 5 usecs
calling  init_sched_debug_procfs+0x0/0x29 @ 1
initcall init_sched_debug_procfs+0x0/0x29 returned 0 after 7 usecs
calling  proc_schedstat_init+0x0/0x1f @ 1
initcall proc_schedstat_init+0x0/0x1f returned 0 after 1 usecs
calling  proc_execdomains_init+0x0/0x22 @ 1
initcall proc_execdomains_init+0x0/0x22 returned 0 after 1 usecs
calling  ioresources_init+0x0/0x36 @ 1
initcall ioresources_init+0x0/0x36 returned 0 after 3 usecs
calling  uid_cache_init+0x0/0x6e @ 1
initcall uid_cache_init+0x0/0x6e returned 0 after 8 usecs
calling  init_posix_timers+0x0/0x1b5 @ 1
initcall init_posix_timers+0x0/0x1b5 returned 0 after 2 usecs
calling  init_posix_cpu_timers+0x0/0x101 @ 1
initcall init_posix_cpu_timers+0x0/0x101 returned 0 after 1 usecs
calling  nsproxy_cache_init+0x0/0x2d @ 1
initcall nsproxy_cache_init+0x0/0x2d returned 0 after 1 usecs
calling  create_proc_profile+0x0/0x236 @ 1
initcall create_proc_profile+0x0/0x236 returned 0 after 0 usecs
calling  timekeeping_init_device+0x0/0x22 @ 1
initcall timekeeping_init_device+0x0/0x22 returned 0 after 107 usecs
calling  init_clocksource_sysfs+0x0/0x50 @ 1
initcall init_clocksource_sysfs+0x0/0x50 returned 0 after 105 usecs
calling  init_timer_list_procfs+0x0/0x2c @ 1
initcall init_timer_list_procfs+0x0/0x2c returned 0 after 2 usecs
calling  init_tstats_procfs+0x0/0x2c @ 1
initcall init_tstats_procfs+0x0/0x2c returned 0 after 2 usecs
calling  futex_init+0x0/0x63 @ 1
initcall futex_init+0x0/0x63 returned 0 after 10 usecs
calling  proc_dma_init+0x0/0x22 @ 1
initcall proc_dma_init+0x0/0x22 returned 0 after 1 usecs
calling  proc_modules_init+0x0/0x22 @ 1
initcall proc_modules_init+0x0/0x22 returned 0 after 1 usecs
calling  kallsyms_init+0x0/0x25 @ 1
initcall kallsyms_init+0x0/0x25 returned 0 after 1 usecs
calling  snapshot_device_init+0x0/0x12 @ 1
initcall snapshot_device_init+0x0/0x12 returned 0 after 61 usecs
calling  crash_save_vmcoreinfo_init+0x0/0x46d @ 1
initcall crash_save_vmcoreinfo_init+0x0/0x46d returned 0 after 22 usecs
calling  crash_notes_memory_init+0x0/0x36 @ 1
initcall crash_notes_memory_init+0x0/0x36 returned 0 after 6 usecs
calling  pid_namespaces_init+0x0/0x2d @ 1
initcall pid_namespaces_init+0x0/0x2d returned 0 after 6 usecs
calling  ikconfig_init+0x0/0x39 @ 1
initcall ikconfig_init+0x0/0x39 returned 0 after 2 usecs
calling  audit_init+0x0/0x133 @ 1
audit: initializing netlink socket (disabled)
type=2000 audit(1268069973.149:1): initialized
initcall audit_init+0x0/0x133 returned 0 after 38868 usecs
calling  audit_tree_init+0x0/0x49 @ 1
initcall audit_tree_init+0x0/0x49 returned 0 after 2 usecs
calling  init_kprobes+0x0/0x182 @ 1
initcall init_kprobes+0x0/0x182 returned 0 after 16016 usecs
calling  hung_task_init+0x0/0x53 @ 1
initcall hung_task_init+0x0/0x53 returned 0 after 38 usecs
calling  utsname_sysctl_init+0x0/0x14 @ 1
initcall utsname_sysctl_init+0x0/0x14 returned 0 after 2 usecs
calling  init_tracepoints+0x0/0x12 @ 1
initcall init_tracepoints+0x0/0x12 returned 0 after 0 usecs
calling  init_lstats_procfs+0x0/0x25 @ 1
initcall init_lstats_procfs+0x0/0x25 returned 0 after 3 usecs
calling  init_events+0x0/0x5f @ 1
initcall init_events+0x0/0x5f returned 0 after 2 usecs
calling  init_sched_switch_trace+0x0/0x12 @ 1
initcall init_sched_switch_trace+0x0/0x12 returned 0 after 2 usecs
calling  init_stack_trace+0x0/0x12 @ 1
initcall init_stack_trace+0x0/0x12 returned 0 after 1 usecs
calling  init_irqsoff_tracer+0x0/0x14 @ 1
initcall init_irqsoff_tracer+0x0/0x14 returned 0 after 0 usecs
calling  init_wakeup_tracer+0x0/0x22 @ 1
initcall init_wakeup_tracer+0x0/0x22 returned 0 after 1 usecs
calling  init_blk_tracer+0x0/0x57 @ 1
initcall init_blk_tracer+0x0/0x57 returned 0 after 1 usecs
calling  perf_event_sysfs_init+0x0/0x19 @ 1
initcall perf_event_sysfs_init+0x0/0x19 returned 0 after 8 usecs
calling  init_per_zone_wmark_min+0x0/0x70 @ 1
initcall init_per_zone_wmark_min+0x0/0x70 returned 0 after 486 usecs
calling  kswapd_init+0x0/0x4d @ 1
initcall kswapd_init+0x0/0x4d returned 0 after 77 usecs
calling  setup_vmstat+0x0/0xae @ 1
initcall setup_vmstat+0x0/0xae returned 0 after 13 usecs
calling  mm_sysfs_init+0x0/0x29 @ 1
initcall mm_sysfs_init+0x0/0x29 returned 0 after 4 usecs
calling  proc_vmalloc_init+0x0/0x25 @ 1
initcall proc_vmalloc_init+0x0/0x25 returned 0 after 2 usecs
calling  procswaps_init+0x0/0x22 @ 1
initcall procswaps_init+0x0/0x22 returned 0 after 1 usecs
calling  hugetlb_init+0x0/0x329 @ 1
HugeTLB registered 2 MB page size, pre-allocated 0 pages
initcall hugetlb_init+0x0/0x329 returned 0 after 27417 usecs
calling  slab_proc_init+0x0/0x25 @ 1
initcall slab_proc_init+0x0/0x25 returned 0 after 2 usecs
calling  slab_sysfs_init+0x0/0xf0 @ 1
initcall slab_sysfs_init+0x0/0xf0 returned 0 after 3458 usecs
calling  fasync_init+0x0/0x2a @ 1
initcall fasync_init+0x0/0x2a returned 0 after 4 usecs
calling  proc_filesystems_init+0x0/0x22 @ 1
initcall proc_filesystems_init+0x0/0x22 returned 0 after 3 usecs
calling  dnotify_init+0x0/0x80 @ 1
initcall dnotify_init+0x0/0x80 returned 0 after 8 usecs
calling  inotify_setup+0x0/0x12 @ 1
initcall inotify_setup+0x0/0x12 returned 0 after 0 usecs
calling  inotify_user_setup+0x0/0x70 @ 1
initcall inotify_user_setup+0x0/0x70 returned 0 after 6 usecs
calling  aio_setup+0x0/0x9e @ 1
initcall aio_setup+0x0/0x9e returned 0 after 141 usecs
calling  proc_locks_init+0x0/0x22 @ 1
initcall proc_locks_init+0x0/0x22 returned 0 after 2 usecs
calling  init_sys32_ioctl+0x0/0x28 @ 1
initcall init_sys32_ioctl+0x0/0x28 returned 0 after 73 usecs
calling  init_mbcache+0x0/0x14 @ 1
initcall init_mbcache+0x0/0x14 returned 0 after 1 usecs
calling  dquot_init+0x0/0xe0 @ 1
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
initcall dquot_init+0x0/0xe0 returned 0 after 43189 usecs
calling  init_v2_quota_format+0x0/0x22 @ 1
initcall init_v2_quota_format+0x0/0x22 returned 0 after 1 usecs
calling  quota_init+0x0/0x26 @ 1
initcall quota_init+0x0/0x26 returned 0 after 29 usecs
calling  proc_cmdline_init+0x0/0x22 @ 1
initcall proc_cmdline_init+0x0/0x22 returned 0 after 13 usecs
calling  proc_cpuinfo_init+0x0/0x22 @ 1
initcall proc_cpuinfo_init+0x0/0x22 returned 0 after 2 usecs
calling  proc_devices_init+0x0/0x22 @ 1
initcall proc_devices_init+0x0/0x22 returned 0 after 1 usecs
calling  proc_interrupts_init+0x0/0x22 @ 1
initcall proc_interrupts_init+0x0/0x22 returned 0 after 1 usecs
calling  proc_loadavg_init+0x0/0x22 @ 1
initcall proc_loadavg_init+0x0/0x22 returned 0 after 1 usecs
calling  proc_meminfo_init+0x0/0x22 @ 1
initcall proc_meminfo_init+0x0/0x22 returned 0 after 1 usecs
calling  proc_stat_init+0x0/0x22 @ 1
initcall proc_stat_init+0x0/0x22 returned 0 after 1 usecs
calling  proc_uptime_init+0x0/0x22 @ 1
initcall proc_uptime_init+0x0/0x22 returned 0 after 1 usecs
calling  proc_version_init+0x0/0x22 @ 1
initcall proc_version_init+0x0/0x22 returned 0 after 2 usecs
calling  proc_softirqs_init+0x0/0x22 @ 1
initcall proc_softirqs_init+0x0/0x22 returned 0 after 1 usecs
calling  proc_kcore_init+0x0/0xa9 @ 1
initcall proc_kcore_init+0x0/0xa9 returned 0 after 8 usecs
calling  vmcore_init+0x0/0x8e2 @ 1
initcall vmcore_init+0x0/0x8e2 returned 0 after 0 usecs
calling  proc_kmsg_init+0x0/0x25 @ 1
initcall proc_kmsg_init+0x0/0x25 returned 0 after 2 usecs
calling  proc_page_init+0x0/0x3c @ 1
initcall proc_page_init+0x0/0x3c returned 0 after 3 usecs
calling  init_devpts_fs+0x0/0x4d @ 1
initcall init_devpts_fs+0x0/0x4d returned 0 after 18 usecs
calling  init_ext3_fs+0x0/0x6b @ 1
initcall init_ext3_fs+0x0/0x6b returned 0 after 158 usecs
calling  journal_init+0x0/0x99 @ 1
initcall journal_init+0x0/0x99 returned 0 after 297 usecs
calling  init_ramfs_fs+0x0/0x12 @ 1
initcall init_ramfs_fs+0x0/0x12 returned 0 after 1 usecs
calling  init_hugetlbfs_fs+0x0/0x98 @ 1
initcall init_hugetlbfs_fs+0x0/0x98 returned 0 after 92 usecs
calling  init_iso9660_fs+0x0/0x6c @ 1
initcall init_iso9660_fs+0x0/0x6c returned 0 after 95 usecs
calling  init_nls_cp437+0x0/0x12 @ 1
initcall init_nls_cp437+0x0/0x12 returned 0 after 1 usecs
calling  init_nls_ascii+0x0/0x12 @ 1
initcall init_nls_ascii+0x0/0x12 returned 0 after 0 usecs
calling  ipc_init+0x0/0x23 @ 1
msgmni has been set to 16001
initcall ipc_init+0x0/0x23 returned 0 after 14659 usecs
calling  ipc_sysctl_init+0x0/0x14 @ 1
initcall ipc_sysctl_init+0x0/0x14 returned 0 after 1 usecs
calling  init_mqueue_fs+0x0/0xb4 @ 1
initcall init_mqueue_fs+0x0/0xb4 returned 0 after 97 usecs
calling  key_proc_init+0x0/0x53 @ 1
initcall key_proc_init+0x0/0x53 returned 0 after 4 usecs
calling  selinux_nf_ip_init+0x0/0x60 @ 1
initcall selinux_nf_ip_init+0x0/0x60 returned 0 after 0 usecs
calling  init_sel_fs+0x0/0x69 @ 1
initcall init_sel_fs+0x0/0x69 returned 0 after 0 usecs
calling  selnl_init+0x0/0x4d @ 1
initcall selnl_init+0x0/0x4d returned 0 after 5 usecs
calling  sel_netif_init+0x0/0x66 @ 1
initcall sel_netif_init+0x0/0x66 returned 0 after 0 usecs
calling  sel_netnode_init+0x0/0x72 @ 1
initcall sel_netnode_init+0x0/0x72 returned 0 after 0 usecs
calling  sel_netport_init+0x0/0x72 @ 1
initcall sel_netport_init+0x0/0x72 returned 0 after 0 usecs
calling  aurule_init+0x0/0x37 @ 1
initcall aurule_init+0x0/0x37 returned 0 after 1 usecs
calling  crypto_wq_init+0x0/0x2e @ 1
initcall crypto_wq_init+0x0/0x2e returned 0 after 125 usecs
calling  crypto_algapi_init+0x0/0xd @ 1
initcall crypto_algapi_init+0x0/0xd returned 0 after 2 usecs
calling  skcipher_module_init+0x0/0x34 @ 1
initcall skcipher_module_init+0x0/0x34 returned 0 after 0 usecs
calling  chainiv_module_init+0x0/0x12 @ 1
initcall chainiv_module_init+0x0/0x12 returned 0 after 2 usecs
calling  eseqiv_module_init+0x0/0x12 @ 1
initcall eseqiv_module_init+0x0/0x12 returned 0 after 0 usecs
calling  hmac_module_init+0x0/0x12 @ 1
initcall hmac_module_init+0x0/0x12 returned 0 after 0 usecs
calling  md5_mod_init+0x0/0x12 @ 1
initcall md5_mod_init+0x0/0x12 returned 0 after 78 usecs
calling  sha1_generic_mod_init+0x0/0x12 @ 1
initcall sha1_generic_mod_init+0x0/0x12 returned 0 after 51 usecs
calling  krng_mod_init+0x0/0x12 @ 1
alg: No test for stdrng (krng)
initcall krng_mod_init+0x0/0x12 returned 0 after 14957 usecs
calling  proc_genhd_init+0x0/0x36 @ 1
initcall proc_genhd_init+0x0/0x36 returned 0 after 3 usecs
calling  bsg_init+0x0/0x12e @ 1
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
initcall bsg_init+0x0/0x12e returned 0 after 33237 usecs
calling  noop_init+0x0/0x14 @ 1
io scheduler noop registered
initcall noop_init+0x0/0x14 returned 0 after 13683 usecs
calling  deadline_init+0x0/0x14 @ 1
io scheduler deadline registered
initcall deadline_init+0x0/0x14 returned 0 after 15511 usecs
calling  cfq_init+0x0/0x94 @ 1
io scheduler cfq registered (default)
initcall cfq_init+0x0/0x94 returned 0 after 19511 usecs
calling  percpu_counter_startup+0x0/0x19 @ 1
initcall percpu_counter_startup+0x0/0x19 returned 0 after 2 usecs
calling  pci_proc_init+0x0/0x6a @ 1
initcall pci_proc_init+0x0/0x6a returned 0 after 97 usecs
calling  pcie_portdrv_init+0x0/0x58 @ 1
pcieport 0000:00:0b.0: setting latency timer to 64
pcieport 0000:00:0b.0: irq 62 for MSI/MSI-X
pcieport 0000:00:0c.0: setting latency timer to 64
pcieport 0000:00:0c.0: irq 63 for MSI/MSI-X
pcieport 0000:00:0d.0: setting latency timer to 64
pcieport 0000:00:0d.0: irq 64 for MSI/MSI-X
pcieport 0000:00:0e.0: setting latency timer to 64
pcieport 0000:00:0e.0: irq 65 for MSI/MSI-X
pcieport 0000:40:0c.0: setting latency timer to 64
pcieport 0000:40:0c.0: irq 66 for MSI/MSI-X
pcieport 0000:40:0d.0: setting latency timer to 64
pcieport 0000:40:0d.0: irq 67 for MSI/MSI-X
pcieport 0000:40:0e.0: setting latency timer to 64
pcieport 0000:40:0e.0: irq 68 for MSI/MSI-X
initcall pcie_portdrv_init+0x0/0x58 returned 0 after 308716 usecs
calling  aer_service_init+0x0/0x2b @ 1
aer 0000:00:0b.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:00:0c.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:00:0d.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:00:0e.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:40:0c.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:40:0d.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:40:0e.0:pcie02: AER service couldn't init device: no _OSC support
initcall aer_service_init+0x0/0x2b returned 0 after 259826 usecs
calling  ioapic_init+0x0/0x1b @ 1
initcall ioapic_init+0x0/0x1b returned 0 after 60 usecs
calling  pci_hotplug_init+0x0/0x1d @ 1
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
initcall pci_hotplug_init+0x0/0x1d returned 0 after 24101 usecs
calling  acpiphp_init+0x0/0x5f @ 1
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
initcall acpiphp_init+0x0/0x5f returned -19 after 29492 usecs
calling  fb_console_init+0x0/0x12a @ 1
initcall fb_console_init+0x0/0x12a returned 0 after 87 usecs
calling  genericbl_init+0x0/0x12 @ 1
initcall genericbl_init+0x0/0x12 returned 0 after 59 usecs
calling  xenfb_init+0x0/0x44 @ 1
initcall xenfb_init+0x0/0x44 returned -19 after 0 usecs
calling  vesafb_init+0x0/0x235 @ 1
initcall vesafb_init+0x0/0x235 returned 0 after 119 usecs
calling  efifb_init+0x0/0x1f2 @ 1
initcall efifb_init+0x0/0x1f2 returned -19 after 3 usecs
calling  acpi_reserve_resources+0x0/0xeb @ 1
initcall acpi_reserve_resources+0x0/0xeb returned 0 after 3 usecs
calling  irqrouter_init_sysfs+0x0/0x38 @ 1
initcall irqrouter_init_sysfs+0x0/0x38 returned 0 after 104 usecs
calling  acpi_button_init+0x0/0x56 @ 1
input: Power Button as /class/input/input0
ACPI: Power Button [PWRF]
initcall acpi_button_init+0x0/0x56 returned 0 after 35233 usecs
calling  acpi_fan_init+0x0/0x56 @ 1
initcall acpi_fan_init+0x0/0x56 returned 0 after 60 usecs
calling  acpi_processor_init+0x0/0x10a @ 1
initcall acpi_processor_init+0x0/0x10a returned 0 after 645 usecs
calling  acpi_container_init+0x0/0x4a @ 1
initcall acpi_container_init+0x0/0x4a returned 0 after 998 usecs
calling  acpi_thermal_init+0x0/0x7b @ 1
initcall acpi_thermal_init+0x0/0x7b returned 0 after 74 usecs
calling  evtchn_init+0x0/0x61 @ 1
initcall evtchn_init+0x0/0x61 returned -19 after 0 usecs
calling  xenfs_init+0x0/0x2d @ 1
XENFS: not registering filesystem on non-xen platform
initcall xenfs_init+0x0/0x2d returned 0 after 25967 usecs
calling  hypervisor_subsys_init+0x0/0x25 @ 1
initcall hypervisor_subsys_init+0x0/0x25 returned -19 after 0 usecs
calling  hyper_sysfs_init+0x0/0xb3 @ 1
initcall hyper_sysfs_init+0x0/0xb3 returned -19 after 0 usecs
calling  rand_initialize+0x0/0x2c @ 1
initcall rand_initialize+0x0/0x2c returned 0 after 15 usecs
calling  tty_init+0x0/0xf5 @ 1
initcall tty_init+0x0/0xf5 returned 0 after 4223 usecs
calling  pty_init+0x0/0x284 @ 1
initcall pty_init+0x0/0x284 returned 0 after 84 usecs
calling  sysrq_init+0x0/0x25 @ 1
initcall sysrq_init+0x0/0x25 returned 0 after 120 usecs
calling  xen_init+0x0/0x78 @ 1
initcall xen_init+0x0/0x78 returned -19 after 0 usecs
calling  raw_init+0x0/0xe5 @ 1
initcall raw_init+0x0/0xe5 returned 0 after 122 usecs
calling  hpet_init+0x0/0x6a @ 1
initcall hpet_init+0x0/0x6a returned 0 after 197 usecs
calling  nvram_init+0x0/0x82 @ 1
Non-volatile memory driver v1.3
initcall nvram_init+0x0/0x82 returned 0 after 16595 usecs
calling  mod_init+0x0/0x4d @ 1
initcall mod_init+0x0/0x4d returned -19 after 0 usecs
calling  agp_init+0x0/0x26 @ 1
Linux agpgart interface v0.103
initcall agp_init+0x0/0x26 returned 0 after 15216 usecs
calling  agp_amd64_mod_init+0x0/0x22 @ 1
initcall agp_amd64_mod_init+0x0/0x22 returned -19 after 0 usecs
calling  agp_intel_init+0x0/0x29 @ 1
initcall agp_intel_init+0x0/0x29 returned 0 after 78 usecs
calling  agp_sis_init+0x0/0x29 @ 1
initcall agp_sis_init+0x0/0x29 returned 0 after 65 usecs
calling  agp_via_init+0x0/0x29 @ 1
initcall agp_via_init+0x0/0x29 returned 0 after 66 usecs
calling  drm_core_init+0x0/0x124 @ 1
[drm] Initialized drm 1.1.0 20060810
initcall drm_core_init+0x0/0x124 returned 0 after 18582 usecs
calling  cn_proc_init+0x0/0x3d @ 1
initcall cn_proc_init+0x0/0x3d returned 0 after 2 usecs
calling  serial8250_init+0x0/0x161 @ 1
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
async_waiting @ 1
async_continuing @ 1 after 0 usec
async_waiting @ 1
async_continuing @ 1 after 0 usec
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
async_waiting @ 1
async_continuing @ 1 after 0 usec
async_waiting @ 1
async_continuing @ 1 after 0 usec
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
initcall serial8250_init+0x0/0x161 returned 0 after 643832 usecs
calling  serial8250_pnp_init+0x0/0x12 @ 1
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
initcall serial8250_pnp_init+0x0/0x12 returned 0 after 2698 usecs
calling  serial8250_pci_init+0x0/0x1b @ 1
initcall serial8250_pci_init+0x0/0x1b returned 0 after 117 usecs
calling  init_kgdboc+0x0/0x16 @ 1
initcall init_kgdboc+0x0/0x16 returned 0 after 0 usecs
calling  topology_sysfs_init+0x0/0x4e @ 1
initcall topology_sysfs_init+0x0/0x4e returned 0 after 17 usecs
calling  brd_init+0x0/0x160 @ 1
brd: module loaded
initcall brd_init+0x0/0x160 returned 0 after 11946 usecs
calling  loop_init+0x0/0x189 @ 1
loop: module loaded
initcall loop_init+0x0/0x189 returned 0 after 3523 usecs
calling  init_kgdbts+0x0/0x16 @ 1
initcall init_kgdbts+0x0/0x16 returned 0 after 1 usecs
calling  mac_hid_init+0x0/0x22 @ 1
initcall mac_hid_init+0x0/0x22 returned 0 after 3 usecs
calling  scsi_dh_init+0x0/0x3f @ 1
initcall scsi_dh_init+0x0/0x3f returned 0 after 1 usecs
calling  init_sd+0x0/0x181 @ 1
initcall init_sd+0x0/0x181 returned 0 after 126 usecs
calling  init_sr+0x0/0x49 @ 1
initcall init_sr+0x0/0x49 returned 0 after 56 usecs
calling  init_sg+0x0/0x122 @ 1
initcall init_sg+0x0/0x122 returned 0 after 68 usecs
calling  ahci_init+0x0/0x1b @ 1
initcall ahci_init+0x0/0x1b returned 0 after 111 usecs
calling  bnx2_init+0x0/0x1b @ 1
bnx2: Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v2.0.8 (Feb 15, 2010)
ACPI: PCI Interrupt Link [LNKX] enabled at IRQ 17
bnx2 0000:03:00.0: PCI INT A -> Link[LNKX] -> GSI 17 (level, high) -> IRQ 17
bnx2 0000:03:00.0: firmware: using built-in firmware bnx2/bnx2-mips-06-5.0.0.j6.fw
bnx2 0000:03:00.0: firmware: using built-in firmware bnx2/bnx2-rv2p-06-5.0.0.j3.fw
bnx2 0000:03:00.0: eth0: Broadcom NetXtreme II BCM5708 1000Base-SX (B2) PCI-X 64-bit 133MHz found at mem f8000000, IRQ 17, node addr 00:18:fe:35:26:f6
ACPI: PCI Interrupt Link [LNKW] enabled at IRQ 16
bnx2 0000:05:00.0: PCI INT A -> Link[LNKW] -> GSI 16 (level, high) -> IRQ 16
bnx2 0000:05:00.0: firmware: using built-in firmware bnx2/bnx2-mips-06-5.0.0.j6.fw
bnx2 0000:05:00.0: firmware: using built-in firmware bnx2/bnx2-rv2p-06-5.0.0.j3.fw
bnx2 0000:05:00.0: eth1: Broadcom NetXtreme II BCM5708 1000Base-SX (B2) PCI-X 64-bit 133MHz found at mem fa000000, IRQ 16, node addr 00:18:fe:35:26:f4
initcall bnx2_init+0x0/0x1b returned 0 after 434831 usecs
calling  net_olddevs_init+0x0/0xa0 @ 1
initcall net_olddevs_init+0x0/0xa0 returned 0 after 5 usecs
calling  init_netconsole+0x0/0x1dd @ 1
netconsole: local port 56816
netconsole: local IP 139.185.50.77
netconsole: interface eth0
netconsole: remote port 56816
netconsole: remote IP 139.185.50.76
netconsole: remote ethernet address 00:18:fe:34:1c:3d
netconsole: device eth0 not up yet, forcing it
bnx2 0000:03:00.0: irq 69 for MSI/MSI-X
bnx2 0000:03:00.0: eth0: using MSI
bnx2 0000:03:00.0: eth0: NIC SerDes Link is Up, 1000 Mbps full duplex
netconsole: carrier detect appears untrustworthy, waiting 4 seconds
, receive & transmit flow control ON
bnx2 0000:03:00.0: eth0: NIC SerDes Link is Down
bnx2 0000:03:00.0: eth0: NIC SerDes Link is Up, 1000 Mbps full duplex, receive & transmit flow control ON
Clocksource tsc unstable (delta = 4398045025043 ns)
console [netcon0] enabled
netconsole: network logging started
initcall init_netconsole+0x0/0x1dd returned 0 after 32370847 usecs
calling  cdrom_init+0x0/0xd @ 1
initcall cdrom_init+0x0/0xd returned 0 after 19 usecs
calling  mon_init+0x0/0x103 @ 1
initcall mon_init+0x0/0x103 returned 0 after 201 usecs
calling  i8042_init+0x0/0x3f9 @ 1
PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
initcall i8042_init+0x0/0x3f9 returned 0 after 58352 usecs
calling  serport_init+0x0/0x34 @ 1
initcall serport_init+0x0/0x34 returned 0 after 0 usecs
calling  mousedev_init+0x0/0x61 @ 1
mice: PS/2 mouse device common for all mice
initcall mousedev_init+0x0/0x61 returned 0 after 21491 usecs
calling  evdev_init+0x0/0x12 @ 1
initcall evdev_init+0x0/0x12 returned 0 after 72 usecs
calling  atkbd_init+0x0/0x27 @ 1
initcall atkbd_init+0x0/0x27 returned 0 after 67 usecs
calling  psmouse_init+0x0/0x7a @ 1
initcall psmouse_init+0x0/0x7a returned 0 after 117 usecs
calling  xenkbd_init+0x0/0x44 @ 1
initcall xenkbd_init+0x0/0x44 returned -19 after 0 usecs
calling  cmos_init+0x0/0x6d @ 1
rtc_cmos rtc_cmos: RTC can wake from S4
rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
initcall cmos_init+0x0/0x6d returned 0 after 77274 usecs
calling  dm_init+0x0/0x49 @ 1
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
initcall dm_init+0x0/0x49 returned 0 after 57655 usecs
calling  cpufreq_gov_powersave_init+0x0/0x12 @ 1
initcall cpufreq_gov_powersave_init+0x0/0x12 returned 0 after 1 usecs
calling  cpufreq_gov_userspace_init+0x0/0x12 @ 1
initcall cpufreq_gov_userspace_init+0x0/0x12 returned 0 after 0 usecs
calling  cpufreq_gov_dbs_init+0x0/0x64 @ 1
initcall cpufreq_gov_dbs_init+0x0/0x64 returned 0 after 124 usecs
calling  init_ladder+0x0/0x12 @ 1
cpuidle: using governor ladder
initcall init_ladder+0x0/0x12 returned 0 after 14217 usecs
calling  init_menu+0x0/0x12 @ 1
cpuidle: using governor menu
initcall init_menu+0x0/0x12 returned 0 after 13709 usecs
calling  efivars_init+0x0/0x1f9 @ 1
initcall efivars_init+0x0/0x1f9 returned -19 after 0 usecs
calling  hid_init+0x0/0x66 @ 1
initcall hid_init+0x0/0x66 returned 0 after 118 usecs
calling  a4_init+0x0/0x1b @ 1
initcall a4_init+0x0/0x1b returned 0 after 51 usecs
calling  apple_init+0x0/0x38 @ 1
initcall apple_init+0x0/0x38 returned 0 after 52 usecs
calling  belkin_init+0x0/0x1b @ 1
initcall belkin_init+0x0/0x1b returned 0 after 48 usecs
calling  ch_init+0x0/0x1b @ 1
initcall ch_init+0x0/0x1b returned 0 after 48 usecs
calling  ch_init+0x0/0x1b @ 1
initcall ch_init+0x0/0x1b returned 0 after 48 usecs
calling  cp_init+0x0/0x1b @ 1
initcall cp_init+0x0/0x1b returned 0 after 48 usecs
calling  dr_init+0x0/0x1b @ 1
initcall dr_init+0x0/0x1b returned 0 after 49 usecs
calling  ez_init+0x0/0x1b @ 1
initcall ez_init+0x0/0x1b returned 0 after 48 usecs
calling  gyration_init+0x0/0x1b @ 1
initcall gyration_init+0x0/0x1b returned 0 after 52 usecs
calling  ks_init+0x0/0x1b @ 1
initcall ks_init+0x0/0x1b returned 0 after 49 usecs
calling  kye_init+0x0/0x1b @ 1
initcall kye_init+0x0/0x1b returned 0 after 49 usecs
calling  lg_init+0x0/0x1b @ 1
initcall lg_init+0x0/0x1b returned 0 after 76 usecs
calling  ms_init+0x0/0x1b @ 1
initcall ms_init+0x0/0x1b returned 0 after 61 usecs
calling  mr_init+0x0/0x1b @ 1
initcall mr_init+0x0/0x1b returned 0 after 50 usecs
calling  ntrig_init+0x0/0x1b @ 1
initcall ntrig_init+0x0/0x1b returned 0 after 48 usecs
calling  ortek_init+0x0/0x1b @ 1
initcall ortek_init+0x0/0x1b returned 0 after 48 usecs
calling  pl_init+0x0/0x1b @ 1
initcall pl_init+0x0/0x1b returned 0 after 49 usecs
calling  pl_init+0x0/0x1b @ 1
initcall pl_init+0x0/0x1b returned 0 after 48 usecs
calling  samsung_init+0x0/0x1b @ 1
initcall samsung_init+0x0/0x1b returned 0 after 49 usecs
calling  sjoy_init+0x0/0x1b @ 1
initcall sjoy_init+0x0/0x1b returned 0 after 49 usecs
calling  sony_init+0x0/0x1b @ 1
initcall sony_init+0x0/0x1b returned 0 after 57 usecs
calling  sp_init+0x0/0x1b @ 1
initcall sp_init+0x0/0x1b returned 0 after 49 usecs
calling  ga_init+0x0/0x1b @ 1
initcall ga_init+0x0/0x1b returned 0 after 49 usecs
calling  tm_init+0x0/0x1b @ 1
initcall tm_init+0x0/0x1b returned 0 after 48 usecs
calling  ts_init+0x0/0x1b @ 1
initcall ts_init+0x0/0x1b returned 0 after 49 usecs
calling  twinhan_init+0x0/0x1b @ 1
initcall twinhan_init+0x0/0x1b returned 0 after 49 usecs
calling  zp_init+0x0/0x1b @ 1
initcall zp_init+0x0/0x1b returned 0 after 49 usecs
calling  hid_init+0x0/0xc7 @ 1
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
initcall hid_init+0x0/0xc7 returned 0 after 50503 usecs
calling  flow_cache_init+0x0/0x187 @ 1
initcall flow_cache_init+0x0/0x187 returned 0 after 25 usecs
calling  llc_init+0x0/0x20 @ 1
initcall llc_init+0x0/0x20 returned 0 after 1 usecs
calling  snap_init+0x0/0x38 @ 1
initcall snap_init+0x0/0x38 returned 0 after 2 usecs
calling  rif_init+0x0/0x84 @ 1
initcall rif_init+0x0/0x84 returned 0 after 13 usecs
calling  blackhole_module_init+0x0/0x12 @ 1
initcall blackhole_module_init+0x0/0x12 returned 0 after 1 usecs
calling  nf_conntrack_standalone_init+0x0/0x12 @ 1
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
initcall nf_conntrack_standalone_init+0x0/0x12 returned 0 after 94749 usecs
calling  xt_init+0x0/0x129 @ 1
initcall xt_init+0x0/0x129 returned 0 after 11 usecs
calling  tcpudp_mt_init+0x0/0x17 @ 1
initcall tcpudp_mt_init+0x0/0x17 returned 0 after 1 usecs
calling  conntrack_mt_init+0x0/0x17 @ 1
initcall conntrack_mt_init+0x0/0x17 returned 0 after 1 usecs
calling  state_mt_init+0x0/0x17 @ 1
initcall state_mt_init+0x0/0x17 returned 0 after 3 usecs
calling  sysctl_ipv4_init+0x0/0x4e @ 1
initcall sysctl_ipv4_init+0x0/0x4e returned 0 after 12 usecs
calling  init_syncookies+0x0/0x19 @ 1
initcall init_syncookies+0x0/0x19 returned 0 after 25 usecs
calling  ipv4_netfilter_init+0x0/0x12 @ 1
initcall ipv4_netfilter_init+0x0/0x12 returned 0 after 1 usecs
calling  nf_conntrack_l3proto_ipv4_init+0x0/0x12d @ 1
initcall nf_conntrack_l3proto_ipv4_init+0x0/0x12d returned 0 after 11 usecs
calling  nf_defrag_init+0x0/0x17 @ 1
initcall nf_defrag_init+0x0/0x17 returned 0 after 0 usecs
calling  ip_tables_init+0x0/0xaf @ 1
ip_tables: (C) 2000-2006 Netfilter Core Team
initcall ip_tables_init+0x0/0xaf returned 0 after 21691 usecs
calling  iptable_filter_init+0x0/0x6f @ 1
initcall iptable_filter_init+0x0/0x6f returned 0 after 16 usecs
calling  reject_tg_init+0x0/0x12 @ 1
initcall reject_tg_init+0x0/0x12 returned 0 after 0 usecs
calling  cubictcp_register+0x0/0x6e @ 1
TCP cubic registered
initcall cubictcp_register+0x0/0x6e returned 0 after 7141 usecs
calling  xfrm_user_init+0x0/0x4d @ 1
Initializing XFRM netlink socket
initcall xfrm_user_init+0x0/0x4d returned 0 after 15745 usecs
calling  packet_init+0x0/0x47 @ 1
NET: Registered protocol family 17
initcall packet_init+0x0/0x47 returned 0 after 16582 usecs
calling  mcheck_debugfs_init+0x0/0x3b @ 1
initcall mcheck_debugfs_init+0x0/0x3b returned 0 after 5 usecs
calling  severities_debugfs_init+0x0/0x3b @ 1
initcall severities_debugfs_init+0x0/0x3b returned 0 after 2 usecs
calling  hpet_insert_resource+0x0/0x23 @ 1
initcall hpet_insert_resource+0x0/0x23 returned 0 after 2 usecs
calling  update_mp_table+0x0/0x470 @ 1
initcall update_mp_table+0x0/0x470 returned 0 after 0 usecs
calling  lapic_insert_resource+0x0/0x40 @ 1
initcall lapic_insert_resource+0x0/0x40 returned 0 after 1 usecs
calling  init_lapic_nmi_sysfs+0x0/0x39 @ 1
initcall init_lapic_nmi_sysfs+0x0/0x39 returned 0 after 103 usecs
calling  io_apic_bug_finalize+0x0/0x1b @ 1
initcall io_apic_bug_finalize+0x0/0x1b returned 0 after 0 usecs
calling  check_early_ioremap_leak+0x0/0x65 @ 1
initcall check_early_ioremap_leak+0x0/0x65 returned 0 after 0 usecs
calling  pat_memtype_list_init+0x0/0x32 @ 1
initcall pat_memtype_list_init+0x0/0x32 returned 0 after 13 usecs
calling  sched_init_debug+0x0/0x24 @ 1
initcall sched_init_debug+0x0/0x24 returned 0 after 2 usecs
calling  init_oops_id+0x0/0x31 @ 1
initcall init_oops_id+0x0/0x31 returned 0 after 2 usecs
calling  disable_boot_consoles+0x0/0x45 @ 1
initcall disable_boot_consoles+0x0/0x45 returned 0 after 0 usecs
calling  pm_qos_power_init+0x0/0x61 @ 1
initcall pm_qos_power_init+0x0/0x61 returned 0 after 188 usecs
calling  software_resume+0x0/0x1ec @ 1
PM: Resume from disk failed.
initcall software_resume+0x0/0x1ec returned -2 after 4565 usecs
initcall software_resume+0x0/0x1ec returned with error code -2 
calling  debugfs_kprobe_init+0x0/0x89 @ 1
initcall debugfs_kprobe_init+0x0/0x89 returned 0 after 5 usecs
calling  taskstats_init+0x0/0x95 @ 1
registered taskstats version 1
initcall taskstats_init+0x0/0x95 returned 0 after 15643 usecs
calling  clear_boot_tracer+0x0/0x2d @ 1
initcall clear_boot_tracer+0x0/0x2d returned 0 after 0 usecs
calling  max_swapfiles_check+0x0/0x8 @ 1
initcall max_swapfiles_check+0x0/0x8 returned 0 after 0 usecs
calling  random32_reseed+0x0/0x92 @ 1
initcall random32_reseed+0x0/0x92 returned 0 after 15 usecs
calling  pci_resource_alignment_sysfs_init+0x0/0x19 @ 1
initcall pci_resource_alignment_sysfs_init+0x0/0x19 returned 0 after 2 usecs
calling  pci_sysfs_init+0x0/0x4c @ 1
initcall pci_sysfs_init+0x0/0x4c returned 0 after 355 usecs
calling  boot_wait_for_devices+0x0/0x19 @ 1
initcall boot_wait_for_devices+0x0/0x19 returned 0 after 0 usecs
calling  seqgen_init+0x0/0xf @ 1
initcall seqgen_init+0x0/0xf returned 0 after 9 usecs
calling  late_resume_init+0x0/0xf4 @ 1
  Magic number: 2:517:693
initcall late_resume_init+0x0/0xf4 returned 0 after 13006 usecs
calling  scsi_complete_async_scans+0x0/0xf7 @ 1
initcall scsi_complete_async_scans+0x0/0xf7 returned 0 after 0 usecs
calling  memmap_init+0x0/0x3b @ 1
initcall memmap_init+0x0/0x3b returned 0 after 36 usecs
calling  pci_mmcfg_late_insert_resources+0x0/0x66 @ 1
initcall pci_mmcfg_late_insert_resources+0x0/0x66 returned 0 after 1 usecs
calling  tcp_congestion_default+0x0/0x12 @ 1
initcall tcp_congestion_default+0x0/0x12 returned 0 after 1 usecs
calling  initialize_hashrnd+0x0/0x19 @ 1
initcall initialize_hashrnd+0x0/0x19 returned 0 after 3 usecs
async_waiting @ 1
async_continuing @ 1 after 0 usec
Freeing unused kernel memory: 1292k freed
Write protecting the kernel read-only data: 8192k
Freeing unused kernel memory: 232k freed
Freeing unused kernel memory: 1920k freed
calling  ehci_hcd_init+0x0/0x76 [ehci_hcd] @ 742
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ACPI: PCI Interrupt Link [LNU2] enabled at IRQ 23
ehci_hcd 0000:00:02.1: PCI INT B -> Link[LNU2] -> GSI 23 (level, high) -> IRQ 23
ehci_hcd 0000:00:02.1: setting latency timer to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: debug port 1
ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
ehci_hcd 0000:00:02.1: irq 23, io mem 0xf7dd0000
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.34-rc1 ehci_hcd
usb usb1: SerialNumber: 0000:00:02.1
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
initcall ehci_hcd_init+0x0/0x76 [ehci_hcd] returned 0 after 361402 usecs
calling  ohci_hcd_mod_init+0x0/0x59 [ohci_hcd] @ 744
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LNU0] enabled at IRQ 22
ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNU0] -> GSI 22 (level, high) -> IRQ 22
ohci_hcd 0000:00:02.0: setting latency timer to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 22, io mem 0xf7de0000
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.34-rc1 ohci_hcd
usb usb2: SerialNumber: 0000:00:02.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
initcall ohci_hcd_mod_init+0x0/0x59 [ohci_hcd] returned 0 after 323034 usecs
calling  uhci_hcd_init+0x0/0xc6 [uhci_hcd] @ 746
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:01:04.4: PCI INT B -> Link[LNKX] -> GSI 17 (level, high) -> IRQ 17
uhci_hcd 0000:01:04.4: UHCI Host Controller
uhci_hcd 0000:01:04.4: new USB bus registered, assigned bus number 3
uhci_hcd 0000:01:04.4: port count misdetected? forcing to 2 ports
uhci_hcd 0000:01:04.4: HCRESET not completed yet!
uhci_hcd 0000:01:04.4: irq 17, io base 0x00001800
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.34-rc1 uhci_hcd
usb usb3: SerialNumber: 0000:01:04.4
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
initcall uhci_hcd_init+0x0/0xc6 [uhci_hcd] returned 0 after 294058 usecs
calling  cciss_init+0x0/0xa4 [cciss] @ 748
HP CISS Driver (v 3.6.20)
cciss: using PCI PM to reset controller
usb 3-1: new full speed USB device using uhci_hcd and address 2
usb 3-1: New USB device found, idVendor=03f0, idProduct=1027
usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-1: Product: Virtual Keyboard
usb 3-1: Manufacturer: HP
input: HP Virtual Keyboard as /class/input/input1
generic-usb 0003:03F0:1027.0001: input,hidraw0: USB HID v1.01 Keyboard [HP Virtual Keyboard] on usb-0000:01:04.4-1/input0
input: HP Virtual Keyboard as /class/input/input2
generic-usb 0003:03F0:1027.0002: input,hidraw1: USB HID v1.01 Mouse [HP Virtual Keyboard] on usb-0000:01:04.4-1/input1
usb 3-2: new full speed USB device using uhci_hcd and address 3
hub 3-0:1.0: unable to enumerate USB device on port 2
usb 3-2: new full speed USB device using uhci_hcd and address 4
usb 3-2: New USB device found, idVendor=03f0, idProduct=1327
usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-2: Product: Virtual Hub
usb 3-2: Manufacturer: HP
hub 3-2:1.0: USB hub found
hub 3-2:1.0: 7 ports detected
cciss: controller message 03:00 succeeded
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 54
cciss 0000:42:08.0: PCI INT A -> Link[LNKA] -> GSI 54 (level, high) -> IRQ 54
cciss 0000:42:08.0: irq 70 for MSI/MSI-X
IRQ 70/cciss0: IRQF_DISABLED is not guaranteed on shared IRQs
cciss0: <0x3238> at PCI 0000:42:08.0 IRQ 70 using DAC
 cciss/c0d0: p1 p2 p3 p4 < p5 p6 p7 >
 cciss/c0d1: p1 p2
initcall cciss_init+0x0/0xa4 [cciss] returned 0 after 2187796 usecs
calling  shpcd_init+0x0/0x68 [shpchp] @ 775
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
initcall shpcd_init+0x0/0x68 [shpchp] returned 0 after 41468 usecs
calling  scsi_tgt_init+0x0/0x82 [scsi_tgt] @ 781
initcall scsi_tgt_init+0x0/0x82 [scsi_tgt] returned 0 after 202 usecs
calling  fc_transport_init+0x0/0x85 [scsi_transport_fc] @ 786
initcall fc_transport_init+0x0/0x85 [scsi_transport_fc] returned 0 after 30 usecs
calling  lpfc_init+0x0/0xd3 [lpfc] @ 787
Emulex LightPulse Fibre Channel SCSI driver 8.3.9
Copyright(c) 2004-2009 Emulex.  All rights reserved.
ACPI: PCI Interrupt Link [LNKY] enabled at IRQ 18
lpfc 0000:08:00.0: PCI INT A -> Link[LNKY] -> GSI 18 (level, high) -> IRQ 18
lpfc 0000:08:00.0: setting latency timer to 64
scsi0 :  on PCI bus 08 device 00 irq 18
lpfc 0000:08:00.0: irq 71 for MSI/MSI-X
ACPI: PCI Interrupt Link [LNKZ] enabled at IRQ 19
lpfc 0000:08:00.1: PCI INT B -> Link[LNKZ] -> GSI 19 (level, high) -> IRQ 19
lpfc 0000:08:00.1: setting latency timer to 64
scsi1 :  on PCI bus 08 device 01 irq 19
lpfc 0000:08:00.0: 0:1303 Link Up Event x1 received Data: x1 xf7 x10 x2 x0 x0 0
lpfc 0000:08:00.1: irq 72 for MSI/MSI-X
scsi 0:0:0:0: RAID              COMPAQ   MSA1000          5.20 PQ: 0 ANSI: 4
scsi 0:0:0:0: Attached scsi generic sg0 type 12
scsi 0:0:0:8: Direct-Access     COMPAQ   MSA1000 VOLUME   5.20 PQ: 0 ANSI: 4
sd 0:0:0:8: Attached scsi generic sg1 type 0
sd 0:0:0:8: [sda] 2187605616 512-byte logical blocks: (1.12 TB/1.01 TiB)
sd 0:0:0:8: [sda] Write Protect is off
sd 0:0:0:8: [sda] Mode Sense: 83 00 00 08
sd 0:0:0:8: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1
scsi 0:0:1:0: Enclosure         HP       MSA2212fc        J200 PQ: 0 ANSI: 5
sd 0:0:0:8: [sda] Attached SCSI disk
scsi 0:0:1:0: Attached scsi generic sg2 type 13
scsi 0:0:2:0: RAID              COMPAQ   MSA1000          5.20 PQ: 0 ANSI: 4
scsi 0:0:2:0: Attached scsi generic sg3 type 12
initcall lpfc_init+0x0/0xd3 [lpfc] returned 0 after 4307265 usecs
calling  usb_stor_init+0x0/0x4b [usb_storage] @ 801
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
initcall usb_stor_init+0x0/0x4b [usb_storage] returned 0 after 48122 usecs
lpfc 0000:08:00.1: 1:1303 Link Up Event x1 received Data: x1 xf7 x10 x2 x0 x0 0
scsi 1:0:0:0: RAID              COMPAQ   MSA1000          5.20 PQ: 0 ANSI: 4
scsi 1:0:0:0: Attached scsi generic sg4 type 12
scsi 1:0:0:8: Direct-Access     COMPAQ   MSA1000 VOLUME   5.20 PQ: 0 ANSI: 4
sd 1:0:0:8: Attached scsi generic sg5 type 0
sd 1:0:0:8: [sdb] 2187605616 512-byte logical blocks: (1.12 TB/1.01 TiB)
scsi 1:0:1:0: Enclosure         HP       MSA2212fc        J200 PQ: 0 ANSI: 5
scsi 1:0:1:0: Attached scsi generic sg6 type 13
scsi 1:0:2:0: RAID              COMPAQ   MSA1000          5.20 PQ: 0 ANSI: 4
scsi 1:0:2:0: Attached scsi generic sg7 type 12
sd 1:0:0:8: [sdb] Write Protect is off
sd 1:0:0:8: [sdb] Mode Sense: 83 00 00 08
sd 1:0:0:8: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1
sd 1:0:0:8: [sdb] Attached SCSI disk
calling  dm_dirty_log_init+0x0/0x59 [dm_log] @ 803
initcall dm_dirty_log_init+0x0/0x59 [dm_log] returned 0 after 1 usecs
kjournald starting.  Commit interval 5 seconds
EXT3-fs (cciss/c0d0p3): mounted filesystem with writeback data mode
calling  pcspkr_init+0x0/0x12 [pcspkr] @ 1052
input: PC Speaker as /class/input/input3
initcall pcspkr_init+0x0/0x12 [pcspkr] returned 0 after 85596 usecs
calling  hwmon_init+0x0/0x112 [hwmon] @ 1069
initcall hwmon_init+0x0/0x112 [hwmon] returned 0 after 399 usecs
calling  snd_mem_init+0x0/0x2c [snd_page_alloc] @ 1052
initcall snd_mem_init+0x0/0x2c [snd_page_alloc] returned 0 after 515 usecs
calling  k8temp_init+0x0/0x20 [k8temp] @ 1073
k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
calling  ipmi_init_msghandler_mod+0x0/0xd [ipmi_msghandler] @ 1463
ipmi message handler version 39.2
initcall ipmi_init_msghandler_mod+0x0/0xd [ipmi_msghandler] returned 0 after 56 usecs
calling  init_tis+0x0/0x92 [tpm_tis] @ 1121
initcall init_tis+0x0/0x92 [tpm_tis] returned 0 after 22 usecs
calling  init_ipmi_si+0x0/0x793 [ipmi_si] @ 1463
IPMI System Interface driver.
ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca2, slave address 0x20, irq 0
calling  serio_raw_init+0x0/0x20 [serio_raw] @ 1442
initcall serio_raw_init+0x0/0x20 [serio_raw] returned 0 after 22 usecs
ipmi: Found new BMC (man_id: 0x00000b,  prod_id: 0x0000, dev_id: 0x11)
IPMI kcs interface initialized
ipmi_si: Trying SPMI-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
ipmi_si: duplicate interface
calling  floppy_module_init+0x0/0xd6d [floppy] @ 1526
Floppy drive(s): fd0 is 1.44M
calling  init_ipmi_devintf+0x0/0x106 [ipmi_devintf] @ 1795
ipmi device interface
initcall init_ipmi_devintf+0x0/0x106 [ipmi_devintf] returned 0 after 73 usecs
calling  init_soundcore+0x0/0x8b [soundcore] @ 1052
initcall init_soundcore+0x0/0x8b [soundcore] returned 0 after 18 usecs
calling  alsa_sound_init+0x0/0x8f [snd] @ 1052
initcall alsa_sound_init+0x0/0x8f [snd] returned 0 after 31 usecs
calling  alsa_timer_init+0x0/0x187 [snd_timer] @ 1052
initcall alsa_timer_init+0x0/0x187 [snd_timer] returned 0 after 62 usecs
calling  alsa_pcm_init+0x0/0x71 [snd_pcm] @ 1893
initcall alsa_pcm_init+0x0/0x71 [snd_pcm] returned 0 after 7 usecs
calling  phy_init+0x0/0x31 [libphy] @ 1891
initcall phy_init+0x0/0x31 [libphy] returned 0 after 49 usecs
calling  enclosure_init+0x0/0x19 [enclosure] @ 1934
initcall enclosure_init+0x0/0x19 [enclosure] returned 0 after 14 usecs
calling  alsa_mixer_oss_init+0x0/0x3a [snd_mixer_oss] @ 1928
initcall alsa_mixer_oss_init+0x0/0x3a [snd_mixer_oss] returned 0 after 0 usecs
calling  alsa_pcm_oss_init+0x0/0xa1 [snd_pcm_oss] @ 1928
initcall alsa_pcm_oss_init+0x0/0xa1 [snd_pcm_oss] returned 0 after 1 usecs
calling  alsa_seq_device_init+0x0/0x60 [snd_seq_device] @ 2003
initcall alsa_seq_device_init+0x0/0x60 [snd_seq_device] returned 0 after 6 usecs
calling  alsa_seq_init+0x0/0x57 [snd_seq] @ 2009
initcall alsa_seq_init+0x0/0x57 [snd_seq] returned 0 after 499 usecs
calling  alsa_seq_midi_event_init+0x0/0x8 [snd_seq_midi_event] @ 2009
initcall alsa_seq_midi_event_init+0x0/0x8 [snd_seq_midi_event] returned 0 after 0 usecs
calling  alsa_seq_oss_init+0x0/0x19e [snd_seq_oss] @ 2009
calling  ses_init+0x0/0x40 [ses] @ 1934
ses 0:0:1:0: Attached Enclosure device
ses 1:0:1:0: Attached Enclosure device
initcall ses_init+0x0/0x40 [ses] returned 0 after 60 usecs
calling  alsa_seq_dummy_init+0x0/0xcd [snd_seq_dummy] @ 2073
initcall alsa_seq_dummy_init+0x0/0xcd [snd_seq_dummy] returned 0 after 12 usecs
calling  tg3_init+0x0/0x20 [tg3] @ 1990
initcall alsa_seq_oss_init+0x0/0x19e [snd_seq_oss] returned 0 after 143962 usecs
calling  pcsp_init+0x0/0x20 [snd_pcsp] @ 1052
Error: Driver 'pcspkr' is already registered, aborting...
initcall pcsp_init+0x0/0x20 [snd_pcsp] returned -16 after 4 usecs
initcall pcsp_init+0x0/0x20 [snd_pcsp] returned with error code -16 
ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
tg3.c:v3.108 (February 17, 2010)
tg3 0000:07:04.0: PCI INT A -> Link[LNKZ] -> GSI 19 (level, high) -> IRQ 19
ipmi_si: duplicate interface
k8temp 0000:00:19.3: Temperature readouts might be wrong - check erratum #141
tg3 0000:07:04.0: eth2: Tigon3 [partno(011276-001) rev 9003] (PCIX:133MHz:64-bit) MAC address 00:18:fe:34:1c:2f
tg3 0000:07:04.0: eth2: attached PHY is 5714 (1000Base-SX Ethernet) (WireSpeed[0])
tg3 0000:07:04.0: eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
tg3 0000:07:04.0: eth2: dma_rwctrl[76148000] dma_mask[40-bit]
tg3 0000:07:04.1: PCI INT B -> Link[LNKW] -> GSI 16 (level, high) -> IRQ 16
initcall k8temp_init+0x0/0x20 [k8temp] returned 0 after 1778901 usecs
tg3 0000:07:04.1: eth3: Tigon3 [partno(011276-001) rev 9003] (PCIX:133MHz:64-bit) MAC address 00:18:fe:34:1c:30
tg3 0000:07:04.1: eth3: attached PHY is 5714 (1000Base-SX Ethernet) (WireSpeed[0])
tg3 0000:07:04.1: eth3: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
tg3 0000:07:04.1: eth3: dma_rwctrl[76148000] dma_mask[40-bit]
initcall tg3_init+0x0/0x20 [tg3] returned 0 after 833093 usecs
ipmi_si: probe of 00:02 failed with error -16
ipmi_si 0000:01:04.6: PCI INT A -> Link[LNKW] -> GSI 16 (level, high) -> IRQ 16
ipmi_si: Trying PCI-specified kcs state machine at mem address 0xf7ef0000, slave address 0x0, irq 16
IRQ 16/ipmi_si: IRQF_DISABLED is not guaranteed on shared IRQs
  Using irq 16
ipmi: interfacing existing BMC (man_id: 0x00000b, prod_id: 0x0000, dev_id: 0x11)
IPMI kcs interface initialized
initcall init_ipmi_si+0x0/0x793 [ipmi_si] returned 0 after 2209269 usecs
floppy0: no floppy controllers found
initcall floppy_module_init+0x0/0xd6d [floppy] returned -19 after 2947700 usecs
calling  floppy_module_init+0x0/0xd6d [floppy] @ 3147
Floppy drive(s): fd0 is 1.44M
floppy0: no floppy controllers found
initcall floppy_module_init+0x0/0xd6d [floppy] returned -19 after 2959240 usecs
calling  parport_default_proc_register+0x0/0x1b [parport] @ 3155
initcall parport_default_proc_register+0x0/0x1b [parport] returned 0 after 9 usecs
calling  lp_init_module+0x0/0x274 [lp] @ 3158
calling  parport_pc_init+0x0/0x357 [parport_pc] @ 3161
initcall parport_pc_init+0x0/0x357 [parport_pc] returned 0 after 276 usecs
lp: driver loaded but no devices found
initcall lp_init_module+0x0/0x274 [lp] returned 0 after 44770 usecs
calling  acpi_ac_init+0x0/0x45 [ac] @ 3191
initcall acpi_ac_init+0x0/0x45 [ac] returned 0 after 59 usecs
calling  acpi_battery_init+0x0/0x16 [battery] @ 3197
initcall acpi_battery_init+0x0/0x16 [battery] returned 0 after 5 usecs
calling  acpi_pci_slot_init+0x0/0x20 [pci_slot] @ 3206
initcall acpi_pci_slot_init+0x0/0x20 [pci_slot] returned 0 after 354 usecs
calling  acpi_smb_hc_init+0x0/0x18 [sbshc] @ 3210
initcall acpi_smb_hc_init+0x0/0x18 [sbshc] returned 0 after 45 usecs
calling  acpi_sbs_init+0x0/0x4f [sbs] @ 3216
initcall acpi_sbs_init+0x0/0x4f [sbs] returned 0 after 47 usecs
calling  video_output_class_init+0x0/0x19 [output] @ 3219
initcall video_output_class_init+0x0/0x19 [output] returned 0 after 19 usecs
calling  acpi_video_init+0x0/0x70 [video] @ 3219
initcall acpi_video_init+0x0/0x70 [video] returned 0 after 96 usecs
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
calling  dm_multipath_init+0x0/0x127 [dm_multipath] @ 3238
device-mapper: multipath: version 1.1.1 loaded
initcall dm_multipath_init+0x0/0x127 [dm_multipath] returned 0 after 15937 usecs
calling  dm_mirror_init+0x0/0x79 [dm_mirror] @ 3250
initcall dm_mirror_init+0x0/0x79 [dm_mirror] returned 0 after 66 usecs
EXT3-fs (cciss/c0d0p3): using internal journal
kjournald starting.  Commit interval 5 seconds
EXT3-fs (cciss/c0d1p1): using internal journal
EXT3-fs (cciss/c0d1p1): mounted filesystem with writeback data mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs (cciss/c0d1p2): using internal journal
EXT3-fs (cciss/c0d1p2): mounted filesystem with writeback data mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs (cciss/c0d0p1): using internal journal
EXT3-fs (cciss/c0d0p1): mounted filesystem with writeback data mode
Adding 8008364k swap on /dev/cciss/c0d0p5.  Priority:-1 extents:1 across:8008364k 
warning: process `kudzu' used the deprecated sysctl system call with 1.23.
calling  powernowk8_init+0x0/0xa7 [powernow_k8] @ 3407
powernow-k8: Found 2 Dual-Core AMD Opteron(tm) Processor 8218 processors (4 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0x12 (2600 MHz), vid 0x8
powernow-k8:    1 : fid 0x10 (2400 MHz), vid 0xa
powernow-k8:    2 : fid 0xe (2200 MHz), vid 0xc
powernow-k8:    3 : fid 0xc (2000 MHz), vid 0xe
powernow-k8:    4 : fid 0xa (1800 MHz), vid 0x10
powernow-k8:    5 : fid 0x2 (1000 MHz), vid 0x12
powernow-k8:    0 : fid 0x12 (2600 MHz), vid 0x8
powernow-k8:    1 : fid 0x10 (2400 MHz), vid 0xa
powernow-k8:    2 : fid 0xe (2200 MHz), vid 0xc
powernow-k8:    3 : fid 0xc (2000 MHz), vid 0xe
powernow-k8:    4 : fid 0xa (1800 MHz), vid 0x10
powernow-k8:    5 : fid 0x2 (1000 MHz), vid 0x12
initcall powernowk8_init+0x0/0xa7 [powernow_k8] returned 0 after 255604 usecs
calling  inet6_init+0x0/0x2b2 [ipv6] @ 3432
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
initcall inet6_init+0x0/0x2b2 [ipv6] returned 0 after 14123 usecs
calling  ip6_tables_init+0x0/0xaf [ip6_tables] @ 3446
ip6_tables: (C) 2000-2006 Netfilter Core Team
initcall ip6_tables_init+0x0/0xaf [ip6_tables] returned 0 after 4382 usecs
calling  ip6table_filter_init+0x0/0x6f [ip6table_filter] @ 3455
initcall ip6table_filter_init+0x0/0x6f [ip6table_filter] returned 0 after 35 usecs
calling  reject_tg6_init+0x0/0x12 [ip6t_REJECT] @ 3458
initcall reject_tg6_init+0x0/0x12 [ip6t_REJECT] returned 0 after 2 usecs
calling  nf_conntrack_netbios_ns_init+0x0/0x1e [nf_conntrack_netbios_ns] @ 3492
initcall nf_conntrack_netbios_ns_init+0x0/0x1e [nf_conntrack_netbios_ns] returned 0 after 2 usecs
calling  init_sunrpc+0x0/0x5d [sunrpc] @ 4036
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
initcall init_sunrpc+0x0/0x5d [sunrpc] returned 0 after 26862 usecs
calling  init_nlm+0x0/0x22 [lockd] @ 4034
initcall init_nlm+0x0/0x22 [lockd] returned 0 after 14 usecs
warning: `dbus-daemon' uses 32-bit capabilities (legacy support in use)
calling  rfkill_init+0x0/0x7a [rfkill] @ 4116
initcall rfkill_init+0x0/0x7a [rfkill] returned 0 after 136 usecs
calling  bt_init+0x0/0x5d [bluetooth] @ 4116
Bluetooth: Core ver 2.15
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
initcall bt_init+0x0/0x5d [bluetooth] returned 0 after 37453 usecs
calling  l2cap_init+0x0/0xe4 [l2cap] @ 4138
Bluetooth: L2CAP ver 2.14
Bluetooth: L2CAP socket layer initialized
initcall l2cap_init+0x0/0xe4 [l2cap] returned 0 after 4435 usecs
calling  rfcomm_init+0x0/0xd5 [rfcomm] @ 4136
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
initcall rfcomm_init+0x0/0xd5 [rfcomm] returned 0 after 28358 usecs
calling  init_rpcsec_gss+0x0/0x4d [auth_rpcgss] @ 4165
initcall init_rpcsec_gss+0x0/0x4d [auth_rpcgss] returned 0 after 30 usecs
calling  init_nfs_fs+0x0/0x125 [nfs] @ 4165
initcall init_nfs_fs+0x0/0x125 [nfs] returned 0 after 572 usecs
svc: failed to register lockdv1 RPC service (errno 97).
eth0: no IPv6 routers present
calling  hidp_init+0x0/0x60 [hidp] @ 4281
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
initcall hidp_init+0x0/0x60 [hidp] returned 0 after 16003 usecs
calling  init_autofs4_fs+0x0/0x26 [autofs4] @ 4297
initcall init_autofs4_fs+0x0/0x26 [autofs4] returned 0 after 117 usecs
 rport-0:0-19: blocked FC remote port time out: removing rport
 rport-1:0-20: blocked FC remote port time out: removing rport

--------------030106080100030900030203
Content-Type: text/plain;
 name="kconfig-rip-null"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="kconfig-rip-null"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.34-rc1
# Mon Mar  8 13:46:40 2010
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_EARLY_RES=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_TREE_PREEMPT_RCU is not set
# CONFIG_TINY_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=64
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=20
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_CGROUP_MEM_RES_CTLR is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_LZO=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_PERF_COUNTERS is not set
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=m
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_OPTPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_SLOW_WORK=y
# CONFIG_SLOW_WORK_DEBUG is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_INTEGRITY is not set
# CONFIG_BLK_CGROUP is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_CFQ_GROUP_IOSCHED is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
CONFIG_INLINE_SPIN_UNLOCK=y
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
CONFIG_INLINE_READ_UNLOCK=y
# CONFIG_INLINE_READ_UNLOCK_BH is not set
CONFIG_INLINE_READ_UNLOCK_IRQ=y
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
CONFIG_INLINE_WRITE_UNLOCK=y
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
# CONFIG_SPARSE_IRQ is not set
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
CONFIG_XEN=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=32
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=7
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_AMD_IOMMU=y
# CONFIG_AMD_IOMMU_STATS is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_IOMMU_API=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=16
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_I8K=m
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_K8_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=9
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_EFI=y
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_PM_VERBOSE is not set
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION_NVS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
# CONFIG_PM_RUNTIME is not set
CONFIG_PM_OPS=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_POWER_METER is not set
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=m
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=m
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_POWERNOW_K8=m
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_DMAR is not set
# CONFIG_INTR_REMAP is not set
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=m
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_IOAPIC=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=m
CONFIG_I82092=m
CONFIG_PCCARD_NONSTATIC=m
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_FAKE=m
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=m

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=m
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CT_PROTO_DCCP=m
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
# CONFIG_NETFILTER_TPROXY is not set
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
# CONFIG_NETFILTER_XT_TARGET_CT is not set
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m
# CONFIG_NETFILTER_XT_MATCH_CLUSTER is not set
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
# CONFIG_NETFILTER_XT_MATCH_OSF is not set
CONFIG_IP_VS=m
# CONFIG_IP_VS_IPV6 is not set
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
# CONFIG_IP_VS_PROTO_SCTP is not set

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
# CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_DCCP=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_QUEUE=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m

#
# DECnet: Netfilter Configuration
#
# CONFIG_DECNET_NF_GRABULATOR is not set
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_ULOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_CCID3_RTO=100
CONFIG_IP_DCCP_TFRC_LIB=y

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_NET_DCCPPROBE=m
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
# CONFIG_RDS is not set
CONFIG_TIPC=m
# CONFIG_TIPC_ADVANCED is not set
# CONFIG_TIPC_DEBUG is not set
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_DECNET=m
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=m
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
CONFIG_IPDDP=m
CONFIG_IPDDP_ENCAP=y
CONFIG_IPDDP_DECAP=y
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
CONFIG_WAN_ROUTER=m
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
# CONFIG_NET_ACT_SKBEDIT is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set

#
# Network testing
#
CONFIG_NET_PKTGEN=m
# CONFIG_NET_TCPPROBE is not set
# CONFIG_NET_DROP_MONITOR is not set
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=m
CONFIG_AX25_DAMA_SLAVE=y
CONFIG_NETROM=m
CONFIG_ROSE=m

#
# AX.25 network device drivers
#
CONFIG_MKISS=m
CONFIG_6PACK=m
CONFIG_BPQETHER=m
CONFIG_BAYCOM_SER_FDX=m
CONFIG_BAYCOM_SER_HDX=m
CONFIG_BAYCOM_PAR=m
CONFIG_YAM=m
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRNET=m
CONFIG_IRCOMM=m
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=m

#
# Dongle support
#
CONFIG_DONGLE=y
CONFIG_ESI_DONGLE=m
CONFIG_ACTISYS_DONGLE=m
CONFIG_TEKRAM_DONGLE=m
CONFIG_TOIM3232_DONGLE=m
CONFIG_LITELINK_DONGLE=m
CONFIG_MA600_DONGLE=m
CONFIG_GIRBIL_DONGLE=m
CONFIG_MCP2120_DONGLE=m
CONFIG_OLD_BELKIN_DONGLE=m
CONFIG_ACT200L_DONGLE=m
CONFIG_KINGSUN_DONGLE=m
CONFIG_KSDAZZLE_DONGLE=m
CONFIG_KS959_DONGLE=m

#
# FIR device drivers
#
CONFIG_USB_IRDA=m
CONFIG_SIGMATEL_FIR=m
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=m
CONFIG_SMC_IRCC_FIR=m
CONFIG_ALI_FIR=m
CONFIG_VLSI_FIR=m
CONFIG_VIA_FIR=m
CONFIG_MCS_FIR=m
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_CMTP=m
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIDTL1=m
CONFIG_BT_HCIBT3C=m
CONFIG_BT_HCIBLUECARD=m
CONFIG_BT_HCIBTUART=m
CONFIG_BT_HCIVHCI=m
# CONFIG_BT_MRVL is not set
# CONFIG_BT_ATH3K is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=m
CONFIG_LIB80211_CRYPT_WEP=m
CONFIG_LIB80211_CRYPT_CCMP=m
CONFIG_LIB80211_CRYPT_TKIP=m
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_NET_9P=m
CONFIG_NET_9P_VIRTIO=m
# CONFIG_NET_9P_RDMA is not set
# CONFIG_NET_9P_DEBUG is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
CONFIG_SYS_HYPERVISOR=y
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=m
# CONFIG_MTD_DEBUG is not set
# CONFIG_MTD_TESTS is not set
CONFIG_MTD_CONCAT=m
CONFIG_MTD_PARTITIONS=y
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_CHAR=m
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
CONFIG_MTD_BLOCK_RO=m
CONFIG_FTL=m
CONFIG_NFTL=m
CONFIG_NFTL_RW=y
CONFIG_INFTL=m
CONFIG_RFD_FTL=m
CONFIG_SSFDC=m
CONFIG_MTD_OOPS=m

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_PHYSMAP is not set
CONFIG_MTD_SC520CDP=m
CONFIG_MTD_NETSC520=m
CONFIG_MTD_TS5500=m
# CONFIG_MTD_SBC_GXX is not set
# CONFIG_MTD_AMD76XROM is not set
# CONFIG_MTD_ICHXROM is not set
CONFIG_MTD_ESB2ROM=m
CONFIG_MTD_CK804XROM=m
CONFIG_MTD_SCB2_FLASH=m
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
CONFIG_MTD_PCI=m
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=m
# CONFIG_MTD_PMC551_BUGFIX is not set
# CONFIG_MTD_PMC551_DEBUG is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTD_BLOCK2MTD=m

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOC2000 is not set
# CONFIG_MTD_DOC2001 is not set
# CONFIG_MTD_DOC2001PLUS is not set
CONFIG_MTD_NAND=m
# CONFIG_MTD_NAND_VERIFY_WRITE is not set
CONFIG_MTD_NAND_ECC_SMC=y
# CONFIG_MTD_NAND_MUSEUM_IDS is not set
CONFIG_MTD_NAND_IDS=m
CONFIG_MTD_NAND_DISKONCHIP=m
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_NANDSIM=m
# CONFIG_MTD_NAND_PLATFORM is not set
CONFIG_MTD_ALAUDA=m
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set

#
# UBI - Unsorted block images
#
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_RESERVE=1
# CONFIG_MTD_UBI_GLUEBI is not set

#
# UBI debugging options
#
# CONFIG_MTD_UBI_DEBUG is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
CONFIG_PARPORT_PC_PCMCIA=m
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
CONFIG_PARIDE=m

#
# Parallel IDE high-level drivers
#
CONFIG_PARIDE_PD=m
CONFIG_PARIDE_PCD=m
CONFIG_PARIDE_PF=m
CONFIG_PARIDE_PT=m
CONFIG_PARIDE_PG=m

#
# Parallel IDE protocol modules
#
CONFIG_PARIDE_ATEN=m
CONFIG_PARIDE_BPCK=m
CONFIG_PARIDE_COMM=m
CONFIG_PARIDE_DSTR=m
CONFIG_PARIDE_FIT2=m
CONFIG_PARIDE_FIT3=m
CONFIG_PARIDE_EPAT=m
CONFIG_PARIDE_EPATC8=y
CONFIG_PARIDE_EPIA=m
CONFIG_PARIDE_FRIQ=m
CONFIG_PARIDE_FRPW=m
CONFIG_PARIDE_KBIC=m
CONFIG_PARIDE_KTTI=m
CONFIG_PARIDE_ON20=m
CONFIG_PARIDE_ON26=m
CONFIG_BLK_CPQ_DA=m
CONFIG_BLK_CPQ_CISS_DA=m
CONFIG_CISS_SCSI_TAPE=y
CONFIG_BLK_DEV_DAC960=m
CONFIG_BLK_DEV_UMEM=m
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=m
# CONFIG_BLK_DEV_DRBD is not set
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_SX8=m
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=m
CONFIG_XEN_BLKDEV_FRONTEND=m
CONFIG_VIRTIO_BLK=m
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_AD525X_DPOT is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_SGI_IOC4=m
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_CS5535_MFGPT is not set
# CONFIG_HP_ILO is not set
# CONFIG_ISL29003 is not set
# CONFIG_DS1682 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=m
# CONFIG_CB710_CORE is not set
# CONFIG_IWMC3200TOP is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BE2ISCSI is not set
CONFIG_BLK_DEV_3W_XXXX_RAID=m
# CONFIG_SCSI_HPSA is not set
CONFIG_SCSI_3W_9XXX=m
# CONFIG_SCSI_3W_SAS is not set
CONFIG_SCSI_ACARD=m
CONFIG_SCSI_AACRAID=m
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_CMDS_PER_DEVICE=4
CONFIG_AIC7XXX_RESET_DELAY_MS=15000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC7XXX_OLD=m
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=4
CONFIG_AIC79XX_RESET_DELAY_MS=15000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC94XX=m
# CONFIG_AIC94XX_DEBUG is not set
CONFIG_SCSI_MVSAS=m
CONFIG_SCSI_MVSAS_DEBUG=y
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
CONFIG_SCSI_ARCMSR=m
CONFIG_SCSI_ARCMSR_AER=y
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=m
CONFIG_MEGARAID_MAILBOX=m
CONFIG_MEGARAID_LEGACY=m
CONFIG_MEGARAID_SAS=m
# CONFIG_SCSI_MPT2SAS is not set
CONFIG_SCSI_HPTIOP=m
CONFIG_SCSI_BUSLOGIC=m
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
CONFIG_SCSI_GDTH=m
CONFIG_SCSI_IPS=m
CONFIG_SCSI_INITIO=m
CONFIG_SCSI_INIA100=m
CONFIG_SCSI_PPA=m
CONFIG_SCSI_IMM=m
# CONFIG_SCSI_IZIP_EPP16 is not set
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
CONFIG_SCSI_STEX=m
CONFIG_SCSI_SYM53C8XX_2=m
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
# CONFIG_SCSI_IPR is not set
CONFIG_SCSI_QLOGIC_1280=m
CONFIG_SCSI_QLA_FC=m
CONFIG_SCSI_QLA_ISCSI=m
CONFIG_SCSI_LPFC=m
# CONFIG_SCSI_LPFC_DEBUG_FS is not set
CONFIG_SCSI_DC395x=m
CONFIG_SCSI_DC390T=m
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
CONFIG_SCSI_SRP=m
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
# CONFIG_PCMCIA_FDOMAIN is not set
CONFIG_PCMCIA_QLOGIC=m
CONFIG_PCMCIA_SYM53C500=m
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=m
CONFIG_SCSI_DH_HP_SW=m
CONFIG_SCSI_DH_EMC=m
CONFIG_SCSI_DH_ALUA=m
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y
CONFIG_SATA_SVW=m
CONFIG_ATA_PIIX=m
CONFIG_SATA_MV=m
CONFIG_SATA_NV=m
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=m
CONFIG_SATA_PROMISE=m
CONFIG_SATA_SX4=m
CONFIG_SATA_SIL=m
CONFIG_SATA_SIS=m
CONFIG_SATA_ULI=m
CONFIG_SATA_VIA=m
CONFIG_SATA_VITESSE=m
CONFIG_SATA_INIC162X=m
CONFIG_PATA_ACPI=m
CONFIG_PATA_ALI=m
CONFIG_PATA_AMD=m
CONFIG_PATA_ARTOP=m
# CONFIG_PATA_ATP867X is not set
CONFIG_PATA_ATIIXP=m
CONFIG_PATA_CMD640_PCI=m
CONFIG_PATA_CMD64X=m
CONFIG_PATA_CS5520=m
CONFIG_PATA_CS5530=m
CONFIG_PATA_CYPRESS=m
CONFIG_PATA_EFAR=m
CONFIG_ATA_GENERIC=m
CONFIG_PATA_HPT366=m
CONFIG_PATA_HPT37X=m
CONFIG_PATA_HPT3X2N=m
CONFIG_PATA_HPT3X3=m
CONFIG_PATA_HPT3X3_DMA=y
CONFIG_PATA_IT821X=m
CONFIG_PATA_IT8213=m
CONFIG_PATA_JMICRON=m
# CONFIG_PATA_LEGACY is not set
CONFIG_PATA_TRIFLEX=m
CONFIG_PATA_MARVELL=m
CONFIG_PATA_MPIIX=m
CONFIG_PATA_OLDPIIX=m
CONFIG_PATA_NETCELL=m
CONFIG_PATA_NINJA32=m
CONFIG_PATA_NS87410=m
CONFIG_PATA_NS87415=m
CONFIG_PATA_OPTI=m
CONFIG_PATA_OPTIDMA=m
CONFIG_PATA_PCMCIA=m
CONFIG_PATA_PDC2027X=m
CONFIG_PATA_PDC_OLD=m
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
CONFIG_PATA_SERVERWORKS=m
CONFIG_PATA_SIL680=m
CONFIG_PATA_SIS=m
# CONFIG_PATA_TOSHIBA is not set
CONFIG_PATA_VIA=m
CONFIG_PATA_WINBOND=m
CONFIG_PATA_SCH=m
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
# CONFIG_MULTICORE_RAID456 is not set
CONFIG_MD_RAID6_PQ=m
# CONFIG_ASYNC_RAID6_TEST is not set
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
# CONFIG_DM_LOG_USERSPACE is not set
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
# CONFIG_DM_MULTIPATH_QL is not set
# CONFIG_DM_MULTIPATH_ST is not set
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
CONFIG_FUSION_FC=m
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=40
CONFIG_FUSION_CTL=m
CONFIG_FUSION_LAN=m
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#

#
# You can enable one or both FireWire driver stacks.
#

#
# The newer stack is recommended.
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_FIREWIRE_SBP2=m
# CONFIG_FIREWIRE_NET is not set
# CONFIG_IEEE1394 is not set
CONFIG_I2O=m
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
CONFIG_I2O_CONFIG=m
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=m
CONFIG_I2O_BLOCK=m
CONFIG_I2O_SCSI=m
CONFIG_I2O_PROC=m
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_IFB=m
CONFIG_DUMMY=m
CONFIG_BONDING=m
CONFIG_MACVLAN=m
# CONFIG_MACVTAP is not set
CONFIG_EQUALIZER=m
CONFIG_TUN=m
CONFIG_VETH=m
CONFIG_NET_SB1000=m
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=m
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
CONFIG_MDIO_BITBANG=m
CONFIG_NET_ETHERNET=y
CONFIG_MII=m
CONFIG_HAPPYMEAL=m
CONFIG_SUNGEM=m
CONFIG_CASSINI=m
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=m
CONFIG_TYPHOON=m
# CONFIG_ETHOC is not set
# CONFIG_DNET is not set
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
CONFIG_DE2104X_DSL=0
CONFIG_TULIP=m
# CONFIG_TULIP_MWI is not set
CONFIG_TULIP_MMIO=y
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=m
CONFIG_WINBOND_840=m
CONFIG_DM9102=m
CONFIG_ULI526X=m
CONFIG_PCMCIA_XIRCOM=m
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=m
CONFIG_AMD8111_ETH=m
CONFIG_ADAPTEC_STARFIRE=m
# CONFIG_KSZ884X_PCI is not set
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=m
CONFIG_FORCEDETH_NAPI=y
CONFIG_E100=m
CONFIG_FEALNX=m
CONFIG_NATSEMI=m
CONFIG_NE2K_PCI=m
CONFIG_8139CP=m
CONFIG_8139TOO=m
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R6040=m
CONFIG_SIS900=m
CONFIG_EPIC100=m
# CONFIG_SMSC9420 is not set
CONFIG_SUNDANCE=m
# CONFIG_SUNDANCE_MMIO is not set
CONFIG_TLAN=m
# CONFIG_KS8842 is not set
# CONFIG_KS8851_MLL is not set
CONFIG_VIA_RHINE=m
CONFIG_VIA_RHINE_MMIO=y
CONFIG_SC92031=m
CONFIG_NET_POCKET=y
CONFIG_ATP=m
CONFIG_DE600=m
CONFIG_DE620=m
CONFIG_ATL2=m
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=m
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_DL2K=m
CONFIG_E1000=m
CONFIG_E1000E=m
CONFIG_IP1000=m
CONFIG_IGB=m
CONFIG_IGB_DCA=y
# CONFIG_IGBVF is not set
CONFIG_NS83820=m
CONFIG_HAMACHI=m
CONFIG_YELLOWFIN=m
CONFIG_R8169=m
CONFIG_R8169_VLAN=y
CONFIG_SIS190=m
CONFIG_SKGE=m
# CONFIG_SKGE_DEBUG is not set
CONFIG_SKY2=m
# CONFIG_SKY2_DEBUG is not set
CONFIG_VIA_VELOCITY=m
CONFIG_TIGON3=m
CONFIG_BNX2=y
# CONFIG_CNIC is not set
CONFIG_QLA3XXX=m
CONFIG_ATL1=m
CONFIG_ATL1E=m
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
CONFIG_NETDEV_10000=y
CONFIG_MDIO=m
CONFIG_CHELSIO_T1=m
CONFIG_CHELSIO_T1_1G=y
CONFIG_CHELSIO_T3_DEPENDS=y
CONFIG_CHELSIO_T3=m
# CONFIG_ENIC is not set
CONFIG_IXGBE=m
CONFIG_IXGBE_DCA=y
# CONFIG_IXGBEVF is not set
CONFIG_IXGB=m
CONFIG_S2IO=m
# CONFIG_VXGE is not set
CONFIG_MYRI10GE=m
CONFIG_MYRI10GE_DCA=y
CONFIG_NETXEN_NIC=m
CONFIG_NIU=m
# CONFIG_MLX4_EN is not set
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
CONFIG_TEHUTI=m
CONFIG_BNX2X=m
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_SFC is not set
# CONFIG_BE2NET is not set
CONFIG_TR=y
CONFIG_IBMOL=m
CONFIG_3C359=m
# CONFIG_TMS380TR is not set
CONFIG_WLAN=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
CONFIG_AIRO=m
CONFIG_ATMEL=m
CONFIG_PCI_ATMEL=m
CONFIG_PCMCIA_ATMEL=m
# CONFIG_AT76C50X_USB is not set
CONFIG_AIRO_CS=m
CONFIG_PCMCIA_WL3501=m
CONFIG_PRISM54=m
CONFIG_USB_ZD1201=m
CONFIG_USB_NET_RNDIS_WLAN=m
CONFIG_RTL8180=m
CONFIG_RTL8187=m
CONFIG_RTL8187_LEDS=y
CONFIG_ADM8211=m
CONFIG_MAC80211_HWSIM=m
# CONFIG_MWL8K is not set
# CONFIG_ATH_COMMON is not set
CONFIG_B43=m
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
CONFIG_B43_PCMCIA=y
# CONFIG_B43_SDIO is not set
CONFIG_B43_PIO=y
CONFIG_B43_PHY_LP=y
CONFIG_B43_LEDS=y
CONFIG_B43_HWRNG=y
CONFIG_B43_DEBUG=y
# CONFIG_B43_FORCE_PIO is not set
CONFIG_B43LEGACY=m
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
CONFIG_B43LEGACY_HWRNG=y
CONFIG_B43LEGACY_DEBUG=y
CONFIG_B43LEGACY_DMA=y
CONFIG_B43LEGACY_PIO=y
CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
# CONFIG_B43LEGACY_DMA_MODE is not set
# CONFIG_B43LEGACY_PIO_MODE is not set
CONFIG_HOSTAP=m
CONFIG_HOSTAP_FIRMWARE=y
CONFIG_HOSTAP_FIRMWARE_NVRAM=y
CONFIG_HOSTAP_PLX=m
CONFIG_HOSTAP_PCI=m
CONFIG_HOSTAP_CS=m
CONFIG_IPW2100=m
CONFIG_IPW2100_MONITOR=y
# CONFIG_IPW2100_DEBUG is not set
CONFIG_IPW2200=m
CONFIG_IPW2200_MONITOR=y
CONFIG_IPW2200_RADIOTAP=y
CONFIG_IPW2200_PROMISCUOUS=y
CONFIG_IPW2200_QOS=y
# CONFIG_IPW2200_DEBUG is not set
CONFIG_LIBIPW=m
# CONFIG_LIBIPW_DEBUG is not set
# CONFIG_IWLWIFI is not set
# CONFIG_IWM is not set
CONFIG_LIBERTAS=m
CONFIG_LIBERTAS_USB=m
CONFIG_LIBERTAS_CS=m
CONFIG_LIBERTAS_SDIO=m
CONFIG_LIBERTAS_DEBUG=y
# CONFIG_LIBERTAS_MESH is not set
CONFIG_HERMES=m
CONFIG_HERMES_CACHE_FW_ON_INIT=y
CONFIG_PLX_HERMES=m
CONFIG_TMD_HERMES=m
CONFIG_NORTEL_HERMES=m
CONFIG_PCI_HERMES=m
CONFIG_PCMCIA_HERMES=m
CONFIG_PCMCIA_SPECTRUM=m
CONFIG_P54_COMMON=m
CONFIG_P54_USB=m
CONFIG_P54_PCI=m
CONFIG_P54_LEDS=y
CONFIG_RT2X00=m
CONFIG_RT2400PCI=m
CONFIG_RT2500PCI=m
CONFIG_RT61PCI=m
CONFIG_RT2800PCI_PCI=y
# CONFIG_RT2800PCI is not set
CONFIG_RT2500USB=m
CONFIG_RT73USB=m
# CONFIG_RT2800USB is not set
CONFIG_RT2X00_LIB_PCI=m
CONFIG_RT2X00_LIB_USB=m
CONFIG_RT2X00_LIB=m
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_LEDS=y
CONFIG_RT2X00_LIB_DEBUGFS=y
# CONFIG_RT2X00_DEBUG is not set
# CONFIG_WL12XX is not set
CONFIG_ZD1211RW=m
# CONFIG_ZD1211RW_DEBUG is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=m
# CONFIG_USB_NET_CDC_EEM is not set
CONFIG_USB_NET_DM9601=m
# CONFIG_USB_NET_SMSC95XX is not set
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=m
CONFIG_USB_HSO=m
# CONFIG_USB_NET_INT51X1 is not set
CONFIG_NET_PCMCIA=y
CONFIG_PCMCIA_3C589=m
CONFIG_PCMCIA_3C574=m
CONFIG_PCMCIA_FMVJ18X=m
CONFIG_PCMCIA_PCNET=m
CONFIG_PCMCIA_NMCLAN=m
CONFIG_PCMCIA_SMC91C92=m
CONFIG_PCMCIA_XIRC2PS=m
CONFIG_PCMCIA_AXNET=m
CONFIG_PCMCIA_IBMTR=m
# CONFIG_WAN is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
CONFIG_ATM_TCP=m
CONFIG_ATM_LANAI=m
CONFIG_ATM_ENI=m
# CONFIG_ATM_ENI_DEBUG is not set
# CONFIG_ATM_ENI_TUNE_BURST is not set
CONFIG_ATM_FIRESTREAM=m
# CONFIG_ATM_ZATM is not set
CONFIG_ATM_IDT77252=m
# CONFIG_ATM_IDT77252_DEBUG is not set
# CONFIG_ATM_IDT77252_RCV_ALL is not set
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=m
# CONFIG_ATM_AMBASSADOR_DEBUG is not set
CONFIG_ATM_HORIZON=m
# CONFIG_ATM_HORIZON_DEBUG is not set
# CONFIG_ATM_IA is not set
CONFIG_ATM_FORE200E=m
# CONFIG_ATM_FORE200E_USE_TASKLET is not set
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
CONFIG_ATM_HE=m
# CONFIG_ATM_HE_USE_SUNI is not set
# CONFIG_ATM_SOLOS is not set
CONFIG_XEN_NETDEV_FRONTEND=m
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
CONFIG_SKFP=m
# CONFIG_HIPPI is not set
CONFIG_PLIP=m
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
CONFIG_PPPOATM=m
CONFIG_PPPOL2TP=m
CONFIG_SLIP=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLHC=m
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VIRTIO_NET=m
# CONFIG_VMXNET3 is not set
CONFIG_ISDN=y
CONFIG_ISDN_I4L=m
CONFIG_ISDN_PPP=y
CONFIG_ISDN_PPP_VJ=y
CONFIG_ISDN_MPP=y
CONFIG_IPPP_FILTER=y
# CONFIG_ISDN_PPP_BSDCOMP is not set
CONFIG_ISDN_AUDIO=y
CONFIG_ISDN_TTY_FAX=y

#
# ISDN feature submodules
#
CONFIG_ISDN_DIVERSION=m

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=m

#
# D-channel protocol features
#
CONFIG_HISAX_EURO=y
CONFIG_DE_AOC=y
CONFIG_HISAX_NO_SENDCOMPLETE=y
CONFIG_HISAX_NO_LLC=y
CONFIG_HISAX_NO_KEYPAD=y
CONFIG_HISAX_1TR6=y
CONFIG_HISAX_NI1=y
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
CONFIG_HISAX_16_3=y
CONFIG_HISAX_TELESPCI=y
CONFIG_HISAX_S0BOX=y
CONFIG_HISAX_FRITZPCI=y
CONFIG_HISAX_AVM_A1_PCMCIA=y
CONFIG_HISAX_ELSA=y
CONFIG_HISAX_DIEHLDIVA=y
CONFIG_HISAX_SEDLBAUER=y
CONFIG_HISAX_NETJET=y
CONFIG_HISAX_NETJET_U=y
CONFIG_HISAX_NICCY=y
CONFIG_HISAX_BKM_A4T=y
CONFIG_HISAX_SCT_QUADRO=y
CONFIG_HISAX_GAZEL=y
CONFIG_HISAX_HFC_PCI=y
CONFIG_HISAX_W6692=y
CONFIG_HISAX_HFC_SX=y
CONFIG_HISAX_ENTERNOW_PCI=y
# CONFIG_HISAX_DEBUG is not set

#
# HiSax PCMCIA card service modules
#
CONFIG_HISAX_SEDLBAUER_CS=m
CONFIG_HISAX_ELSA_CS=m
CONFIG_HISAX_AVM_A1_CS=m
CONFIG_HISAX_TELES_CS=m

#
# HiSax sub driver modules
#
CONFIG_HISAX_ST5481=m
# CONFIG_HISAX_HFCUSB is not set
CONFIG_HISAX_HFC4S8S=m
CONFIG_HISAX_FRITZ_PCIPNP=m

#
# Active cards
#
CONFIG_ISDN_CAPI=m
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
# CONFIG_CAPI_TRACE is not set
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPI20=m
CONFIG_ISDN_CAPI_CAPIFS_BOOL=y
CONFIG_ISDN_CAPI_CAPIFS=m
CONFIG_ISDN_CAPI_CAPIDRV=m

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
CONFIG_ISDN_DRV_AVMB1_B1PCI=m
CONFIG_ISDN_DRV_AVMB1_B1PCIV4=y
CONFIG_ISDN_DRV_AVMB1_B1PCMCIA=m
CONFIG_ISDN_DRV_AVMB1_AVM_CS=m
CONFIG_ISDN_DRV_AVMB1_T1PCI=m
CONFIG_ISDN_DRV_AVMB1_C4=m
# CONFIG_CAPI_EICON is not set
CONFIG_ISDN_DRV_GIGASET=m
# CONFIG_GIGASET_CAPI is not set
CONFIG_GIGASET_I4L=y
# CONFIG_GIGASET_DUMMYLL is not set
CONFIG_GIGASET_BASE=m
CONFIG_GIGASET_M105=m
CONFIG_GIGASET_M101=m
# CONFIG_GIGASET_DEBUG is not set
CONFIG_HYSDN=m
CONFIG_HYSDN_CAPI=y
CONFIG_MISDN=m
CONFIG_MISDN_DSP=m
CONFIG_MISDN_L1OIP=m

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=m
CONFIG_MISDN_HFCMULTI=m
# CONFIG_MISDN_HFCUSB is not set
# CONFIG_MISDN_AVMFRITZ is not set
# CONFIG_MISDN_SPEEDFAX is not set
# CONFIG_MISDN_INFINEON is not set
# CONFIG_MISDN_W6692 is not set
# CONFIG_MISDN_NETJET is not set
CONFIG_ISDN_HDLC=m
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set
CONFIG_XEN_KBDDEV_FRONTEND=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_BCM5974=m
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=m
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=m
CONFIG_JOYSTICK_GRIP=m
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=m
CONFIG_JOYSTICK_SIDEWINDER=m
CONFIG_JOYSTICK_TMDC=m
CONFIG_JOYSTICK_IFORCE=m
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=m
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
CONFIG_JOYSTICK_ZHENHUA=m
CONFIG_JOYSTICK_DB9=m
CONFIG_JOYSTICK_GAMECON=m
CONFIG_JOYSTICK_TURBOGRAFX=m
CONFIG_JOYSTICK_JOYDUMP=m
CONFIG_JOYSTICK_XPAD=m
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
# CONFIG_JOYSTICK_WALKERA0701 is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=m
CONFIG_TABLET_USB_KBTAB=m
CONFIG_TABLET_USB_WACOM=m
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_EETI is not set
CONFIG_TOUCHSCREEN_FUJITSU=m
CONFIG_TOUCHSCREEN_GUNZE=m
CONFIG_TOUCHSCREEN_ELO=m
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
CONFIG_TOUCHSCREEN_MTOUCH=m
CONFIG_TOUCHSCREEN_INEXIO=m
CONFIG_TOUCHSCREEN_MK712=m
CONFIG_TOUCHSCREEN_PENMOUNT=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
CONFIG_TOUCHSCREEN_TOUCHWIN=m
# CONFIG_TOUCHSCREEN_WM97XX is not set
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC5UH=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_TOUCHIT213=m
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=m
CONFIG_INPUT_APANEL=m
CONFIG_INPUT_ATLAS_BTNS=m
CONFIG_INPUT_ATI_REMOTE=m
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=m
# CONFIG_INPUT_WINBOND_CIR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
CONFIG_GAMEPORT_EMU10K1=m
CONFIG_GAMEPORT_FM801=m

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_DEVKMEM is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_COMPUTONE is not set
CONFIG_ROCKETPORT=m
CONFIG_CYCLADES=m
# CONFIG_CYZ_INTR is not set
# CONFIG_DIGIEPCA is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_ISI is not set
CONFIG_SYNCLINK=m
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=m
CONFIG_N_HDLC=m
# CONFIG_RISCOM8 is not set
# CONFIG_SPECIALIX is not set
# CONFIG_STALDRV is not set
CONFIG_NOZOMI=m

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_CONSOLE_POLL=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_PRINTER=m
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_NVRAM=y
CONFIG_R3964=m
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
CONFIG_IPWIRELESS=m
CONFIG_MWAVE=m
# CONFIG_PC8736x_GPIO is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=8192
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=m
CONFIG_TCG_TIS=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_STUB=m

#
# Miscellaneous I2C Chip support
#
CONFIG_SENSORS_TSL2550=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=m
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=m
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=m
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=m
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_PCF8591=m
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_THMC50=m
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_HDAPS=m
# CONFIG_SENSORS_LIS3_I2C is not set
CONFIG_SENSORS_APPLESMC=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ATK0110 is not set
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_THERMAL=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
# CONFIG_MAX63XX_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=m
CONFIG_ITCO_WDT=m
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=m
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
CONFIG_W83627HF_WDT=m
CONFIG_W83697HF_WDT=m
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_BLOCKIO=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=m
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_SM501=m
# CONFIG_HTC_PASIC3 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_AB3100_CORE is not set
CONFIG_LPC_SCH=m
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_TTM=m
CONFIG_DRM_TDFX=m
CONFIG_DRM_R128=m
CONFIG_DRM_RADEON=m
# CONFIG_DRM_RADEON_KMS is not set
CONFIG_DRM_I810=m
CONFIG_DRM_I830=m
CONFIG_DRM_I915=m
# CONFIG_DRM_I915_KMS is not set
CONFIG_DRM_MGA=m
CONFIG_DRM_SIS=m
CONFIG_DRM_VIA=m
CONFIG_DRM_SAVAGE=m
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=m
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=m
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
CONFIG_FB_VGA16=m
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=m
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=m
# CONFIG_FB_RIVA_I2C is not set
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
# CONFIG_FB_LE80578 is not set
CONFIG_FB_MATROX=m
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=m
CONFIG_FB_MATROX_MAVEN=m
CONFIG_FB_RADEON=m
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=m
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=m
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=m
CONFIG_FB_SAVAGE=m
CONFIG_FB_SAVAGE_I2C=y
CONFIG_FB_SAVAGE_ACCEL=y
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=m
CONFIG_FB_KYRO=m
CONFIG_FB_3DFX=m
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=m
# CONFIG_FB_VT8623 is not set
CONFIG_FB_TRIDENT=m
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
CONFIG_FB_SM501=m
# CONFIG_FB_VIRTUAL is not set
CONFIG_XEN_FBDEV_FRONTEND=y
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_ILI9320 is not set
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_PROGEAR=m
CONFIG_BACKLIGHT_MBP_NVIDIA=m
# CONFIG_BACKLIGHT_SAHARA is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
# CONFIG_SND_HRTIMER is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
CONFIG_SND_PCM_XRUN_DEBUG=y
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
CONFIG_SND_OPL3_LIB_SEQ=m
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
CONFIG_SND_EMU10K1_SEQ=m
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
CONFIG_SND_MTS64=m
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
CONFIG_SND_PORTMAN2X4=m
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=5
CONFIG_SND_SB_COMMON=m
CONFIG_SND_SB16_DSP=m
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=m
CONFIG_SND_ALS300=m
CONFIG_SND_ALS4000=m
CONFIG_SND_ALI5451=m
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=m
CONFIG_SND_AU8830=m
# CONFIG_SND_AW2 is not set
CONFIG_SND_AZT3328=m
CONFIG_SND_BT87X=m
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=m
CONFIG_SND_OXYGEN_LIB=m
CONFIG_SND_OXYGEN=m
CONFIG_SND_CS4281=m
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CS5530=m
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
CONFIG_SND_DARLA20=m
CONFIG_SND_GINA20=m
CONFIG_SND_LAYLA20=m
CONFIG_SND_DARLA24=m
CONFIG_SND_GINA24=m
CONFIG_SND_LAYLA24=m
CONFIG_SND_MONA=m
CONFIG_SND_MIA=m
CONFIG_SND_ECHO3G=m
CONFIG_SND_INDIGO=m
CONFIG_SND_INDIGOIO=m
CONFIG_SND_INDIGODJ=m
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1X=m
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
CONFIG_SND_ES1938=m
CONFIG_SND_ES1968=m
CONFIG_SND_FM801=m
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_HWDEP=y
# CONFIG_SND_HDA_RECONFIG is not set
# CONFIG_SND_HDA_INPUT_BEEP is not set
# CONFIG_SND_HDA_INPUT_JACK is not set
# CONFIG_SND_HDA_PATCH_LOADER is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
CONFIG_SND_HDA_CODEC_NVHDMI=y
CONFIG_SND_HDA_CODEC_INTELHDMI=y
CONFIG_SND_HDA_ELD=y
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=5
CONFIG_SND_HDSP=m
CONFIG_SND_HDSPM=m
CONFIG_SND_HIFIER=m
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
CONFIG_SND_KORG1212=m
# CONFIG_SND_LX6464ES is not set
CONFIG_SND_MAESTRO3=m
CONFIG_SND_MIXART=m
CONFIG_SND_NM256=m
CONFIG_SND_PCXHR=m
CONFIG_SND_RIPTIDE=m
CONFIG_SND_RME32=m
CONFIG_SND_RME96=m
CONFIG_SND_RME9652=m
CONFIG_SND_SONICVIBES=m
CONFIG_SND_TRIDENT=m
CONFIG_SND_VIA82XX=m
CONFIG_SND_VIA82XX_MODEM=m
CONFIG_SND_VIRTUOSO=m
CONFIG_SND_VX222=m
CONFIG_SND_YMFPCI=m
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
# CONFIG_SND_USB_UA101 is not set
CONFIG_SND_USB_USX2Y=m
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
# CONFIG_SND_USB_US122L is not set
# CONFIG_SND_PCMCIA is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
# CONFIG_HID_3M_PCT is not set
CONFIG_HID_A4TECH=y
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_KYE=y
CONFIG_HID_GYRATION=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LOGITECH=y
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
# CONFIG_LOGIG940_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
# CONFIG_HID_MOSART is not set
CONFIG_HID_MONTEREY=y
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=y
# CONFIG_HID_QUANTA is not set
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
# CONFIG_HID_STANTUM is not set
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TOPSEED=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
# CONFIG_HID_WACOM is not set
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m
CONFIG_USB_U132_HCD=m
CONFIG_USB_SL811_HCD=m
# CONFIG_USB_SL811_CS is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=m
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
# CONFIG_USB_SERIAL_CP210X is not set
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_FUNSOFT=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
# CONFIG_USB_SERIAL_GARMIN is not set
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
# CONFIG_USB_SERIAL_KEYSPAN_MPR is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA28 is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA28X is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA28XA is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA28XB is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA19 is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA18X is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA19W is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA19QW is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA19QI is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA49W is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA49WLC is not set
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MOTOROLA=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
# CONFIG_USB_SERIAL_SIEMENS_MPI is not set
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
# CONFIG_USB_SERIAL_SYMBOL is not set
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_VIVOPAY_SERIAL is not set
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_LED=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=m
# CONFIG_USB_TEST is not set
CONFIG_USB_ISIGHTFW=m
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
# CONFIG_MMC_RICOH_MMC is not set
# CONFIG_MMC_SDHCI_PLTFM is not set
CONFIG_MMC_WBSD=m
CONFIG_MMC_TIFM_SD=m
CONFIG_MMC_SDRICOH_CS=m
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_CLEVO_MAIL=m
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
CONFIG_INFINIBAND_IPATH=m
CONFIG_INFINIBAND_AMSO1100=m
# CONFIG_INFINIBAND_AMSO1100_DEBUG is not set
CONFIG_INFINIBAND_CXGB3=m
# CONFIG_INFINIBAND_CXGB3_DEBUG is not set
CONFIG_MLX4_INFINIBAND=m
CONFIG_INFINIBAND_NES=m
# CONFIG_INFINIBAND_NES_DEBUG is not set
CONFIG_INFINIBAND_IPOIB=m
CONFIG_INFINIBAND_IPOIB_CM=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
CONFIG_INFINIBAND_IPOIB_DEBUG_DATA=y
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_ISER=m
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=y
CONFIG_EDAC_MM_EDAC=m
# CONFIG_EDAC_AMD64 is not set
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1374=m
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=m
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH=y
CONFIG_INTEL_IOATDMA=m
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
CONFIG_DCA=m
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=m
CONFIG_CFAG12864B_RATE=20
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV=m
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set

#
# TI VLYNQ
#

#
# Xen driver support
#
CONFIG_XEN_BALLOON=y
CONFIG_XEN_SCRUB_PAGES=y
CONFIG_XEN_DEV_EVTCHN=y
CONFIG_XENFS=y
CONFIG_XEN_COMPAT_XENFS=y
CONFIG_XEN_SYS_HYPERVISOR=y
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=m
CONFIG_ASUS_LAPTOP=m
# CONFIG_DELL_LAPTOP is not set
# CONFIG_DELL_WMI is not set
CONFIG_FUJITSU_LAPTOP=m
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
CONFIG_HP_WMI=m
CONFIG_MSI_LAPTOP=m
# CONFIG_PANASONIC_LAPTOP is not set
CONFIG_COMPAL_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
CONFIG_THINKPAD_ACPI=m
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
CONFIG_ACPI_WMI=m
# CONFIG_MSI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_TOPSTAR_LAPTOP is not set
CONFIG_ACPI_TOSHIBA=m
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=y
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=m
CONFIG_DMIID=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=m

#
# File systems
#
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=m
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=m
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=m
# CONFIG_GFS2_FS_LOCKING_DLM is not set
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
# CONFIG_OCFS2_FS_STATS is not set
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS_FS=m
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
# CONFIG_CUSE is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=m
CONFIG_ECRYPT_FS=m
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=m
CONFIG_BEFS_FS=m
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=m
CONFIG_EFS_FS=m
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
CONFIG_JFFS2_SUMMARY=y
CONFIG_JFFS2_FS_XATTR=y
CONFIG_JFFS2_FS_POSIX_ACL=y
CONFIG_JFFS2_FS_SECURITY=y
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
CONFIG_UBIFS_FS=m
CONFIG_UBIFS_FS_XATTR=y
# CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_UBIFS_FS_DEBUG is not set
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=m
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=m
CONFIG_MINIX_FS=m
CONFIG_OMFS_FS=m
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=m
CONFIG_ROMFS_FS=m
CONFIG_ROMFS_BACKED_BY_BLOCK=y
# CONFIG_ROMFS_BACKED_BY_MTD is not set
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
# CONFIG_NFS_V4_1 is not set
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_XPRT_RDMA=m
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_RPCSEC_GSS_SPKM3=m
# CONFIG_SMB_FS is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_DFS_UPCALL=y
CONFIG_CIFS_EXPERIMENTAL=y
CONFIG_NCP_FS=m
CONFIG_NCPFS_PACKET_SIGNING=y
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
CONFIG_NCPFS_NFS_NS=y
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
CONFIG_NCPFS_EXTRAS=y
CONFIG_CODA_FS=m
# CONFIG_AFS_FS is not set
CONFIG_9P_FS=m

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_FUNCTION_TRACER is not set
CONFIG_IRQSOFF_TRACER=y
CONFIG_SYSPROF_TRACER=y
CONFIG_SCHED_TRACER=y
# CONFIG_FTRACE_SYSCALLS is not set
# CONFIG_BOOT_TRACER is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_KSYM_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_KMEMTRACE is not set
# CONFIG_WORKQUEUE_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
CONFIG_KGDB_TESTS=y
# CONFIG_KGDB_TESTS_ON_BOOT is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
# CONFIG_SECURITY_PATH is not set
CONFIG_LSM_MMAP_MIN_ADDR=65536
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_IMA is not set
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_SMACK is not set
# CONFIG_DEFAULT_SECURITY_TOMOYO is not set
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="selinux"
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_X86_64=m
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_CRYPTO_DEV_HIFN_795X=m
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
CONFIG_KVM_AMD=m
# CONFIG_VHOST_NET is not set
CONFIG_VIRTIO=m
CONFIG_VIRTIO_RING=m
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_BALLOON=m
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=m
CONFIG_LZO_DECOMPRESS=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_NLATTR=y

--------------030106080100030900030203--
