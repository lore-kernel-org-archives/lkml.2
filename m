Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab1JHQAd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 12:00:33 -0400
Received: from post.russia.ru ([87.242.118.101]:60104 "EHLO post.russia.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab1JHQAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 12:00:31 -0400
Message-ID: <4E907364.2040504@russia.ru>
Date: Sat, 08 Oct 2011 22:59:32 +0700
From: =?UTF-8?B?0JLQsNC70LXRgNC40Lk=?= <paramonov@russia.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110907 Thunderbird/6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, neilb@suse.de, linux-raid@vger.kernel.org,
        axboe@kernel.dk, duaneg@dghda.com,
        Alexander Beregalov <a.beregalov@gmail.com>
Subject: BUG: spinlock lockup while performing FS operations and detected
 stalls on CPUs / tasks.
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-SpamTest-Envelope-From: paramonov@russia.ru
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 25585 [Oct 08 2011]
X-SpamTest-Info: {received from trusted sender <paramonov@russia.ru>: common white list}
X-SpamTest-Method: white email list
X-SpamTest-Rate: 0
X-SpamTest-Status: Trusted
X-SpamTest-Status-Extended: trusted
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is another user with similar problem Sushant Sinha 
(sushant354@gmail.com)

https://bugs.gentoo.org/show_bug.cgi?id=385047

We found some keys.

1. We have the same chipset driver. He has GA-MA790GP, I have a 
GA-870-UD3, both Gigabyte on AMD.

2. Really noticed that copying a large directory from a large 
(/dev/md127p2 - 1,4Tb) to a small partition (/dev/md127p1 - 50Gb) is 
successful. From small to small too well. But if I copy to large 
partition - hangs. Yesterday wanted to do a backup, created a partition 
XFS on 1TB too hung up. Regardless of the file system.

This is a keys!

Thanks.

We have an attachments. Him log:
---
Oct  8 17:42:26 freehit syslog-ng[2189]: syslog-ng starting up; 
version='3.2.4'
Oct  8 17:42:26 freehit kernel: [    0.000000] Initializing cgroup 
subsys cpuset
Oct  8 17:42:26 freehit kernel: [    0.000000] Initializing cgroup 
subsys cpu
Oct  8 17:42:26 freehit kernel: [    0.000000] Linux version 
3.0.4-gentoo-r2 (root@freehit) (gcc version 4.5.3 (Gentoo 4.5.3-r1 p1.0, 
pie-0.4.5) ) #2 SMP Sat Oct 8 12:23:31 IST 2011
Oct  8 17:42:26 freehit kernel: [    0.000000] Command line: 
root=/dev/sda3 loglevel=9
Oct  8 17:42:26 freehit kernel: [    0.000000] BIOS-provided physical 
RAM map:
Oct  8 17:42:26 freehit kernel: [    0.000000]  BIOS-e820: 
0000000000000000 - 000000000009f800 (usable)
Oct  8 17:42:26 freehit kernel: [    0.000000]  BIOS-e820: 
000000000009f800 - 00000000000a0000 (reserved)
Oct  8 17:42:26 freehit kernel: [    0.000000]  BIOS-e820: 
00000000000f0000 - 0000000000100000 (reserved)
Oct  8 17:42:26 freehit kernel: [    0.000000]  BIOS-e820: 
0000000000100000 - 00000000afee0000 (usable)
Oct  8 17:42:26 freehit kernel: [    0.000000]  BIOS-e820: 
00000000afee0000 - 00000000afee3000 (ACPI NVS)
Oct  8 17:42:26 freehit kernel: [    0.000000]  BIOS-e820: 
00000000afee3000 - 00000000afef0000 (ACPI data)
Oct  8 17:42:26 freehit kernel: [    0.000000]  BIOS-e820: 
00000000afef0000 - 00000000aff00000 (reserved)
Oct  8 17:42:26 freehit kernel: [    0.000000]  BIOS-e820: 
00000000e0000000 - 00000000f0000000 (reserved)
Oct  8 17:42:26 freehit kernel: [    0.000000]  BIOS-e820: 
00000000fec00000 - 0000000100000000 (reserved)
Oct  8 17:42:26 freehit kernel: [    0.000000]  BIOS-e820: 
0000000100000000 - 00000001b0000000 (usable)
Oct  8 17:42:26 freehit kernel: [    0.000000] NX (Execute Disable) 
protection: active
Oct  8 17:42:26 freehit kernel: [    0.000000] DMI 2.4 present.
Oct  8 17:42:26 freehit kernel: [    0.000000] DMI: Gigabyte Technology 
Co., Ltd. GA-MA790GP-DS4H/GA-MA790GP-DS4H, BIOS F3 01/13/2009
Oct  8 17:42:26 freehit kernel: [    0.000000] e820 update range: 
0000000000000000 - 0000000000010000 (usable) ==> (reserved)
Oct  8 17:42:26 freehit kernel: [    0.000000] e820 remove range: 
00000000000a0000 - 0000000000100000 (usable)
Oct  8 17:42:26 freehit kernel: [    0.000000] No AGP bridge found
Oct  8 17:42:26 freehit kernel: [    0.000000] last_pfn = 0x1b0000 
max_arch_pfn = 0x400000000
Oct  8 17:42:26 freehit kernel: [    0.000000] MTRR default type: uncachable
Oct  8 17:42:26 freehit kernel: [    0.000000] MTRR fixed ranges enabled:
Oct  8 17:42:26 freehit kernel: [    0.000000]   00000-9FFFF write-back
Oct  8 17:42:26 freehit kernel: [    0.000000]   A0000-BFFFF uncachable
Oct  8 17:42:26 freehit kernel: [    0.000000]   C0000-C7FFF write-protect
Oct  8 17:42:26 freehit kernel: [    0.000000]   C8000-FFFFF uncachable
Oct  8 17:42:26 freehit kernel: [    0.000000] MTRR variable ranges enabled:
Oct  8 17:42:26 freehit kernel: [    0.000000]   0 base 000000000000 
mask FFFF80000000 write-back
Oct  8 17:42:26 freehit kernel: [    0.000000]   1 base 000080000000 
mask FFFFE0000000 write-back
Oct  8 17:42:26 freehit kernel: [    0.000000]   2 base 0000A0000000 
mask FFFFF0000000 write-back
Oct  8 17:42:26 freehit kernel: [    0.000000]   3 base 0000AFF00000 
mask FFFFFFF00000 uncachable
Oct  8 17:42:26 freehit kernel: [    0.000000]   4 base 000100000000 
mask FFFF80000000 write-back
Oct  8 17:42:26 freehit kernel: [    0.000000]   5 base 000180000000 
mask FFFFE0000000 write-back
Oct  8 17:42:26 freehit kernel: [    0.000000]   6 base 0001A0000000 
mask FFFFF0000000 write-back
Oct  8 17:42:26 freehit kernel: [    0.000000]   7 disabled
Oct  8 17:42:26 freehit kernel: [    0.000000] TOM2: 00000001b0000000 
aka 6912M
Oct  8 17:42:26 freehit kernel: [    0.000000] x86 PAT enabled: cpu 0, 
old 0x7040600070406, new 0x7010600070106
Oct  8 17:42:26 freehit kernel: [    0.000000] e820 update range: 
00000000aff00000 - 0000000100000000 (usable) ==> (reserved)
Oct  8 17:42:26 freehit kernel: [    0.000000] last_pfn = 0xafee0 
max_arch_pfn = 0x400000000
Oct  8 17:42:26 freehit kernel: [    0.000000] found SMP MP-table at 
[ffff8800000f59c0] f59c0
Oct  8 17:42:26 freehit kernel: [    0.000000] initial memory mapped : 0 
- 20000000
Oct  8 17:42:26 freehit kernel: [    0.000000] Base memory trampoline at 
[ffff88000009a000] 9a000 size 20480
Oct  8 17:42:26 freehit kernel: [    0.000000] Using GB pages for direct 
mapping
Oct  8 17:42:26 freehit kernel: [    0.000000] init_memory_mapping: 
0000000000000000-00000000afee0000
Oct  8 17:42:26 freehit kernel: [    0.000000]  0000000000 - 0080000000 
page 1G
Oct  8 17:42:26 freehit kernel: [    0.000000]  0080000000 - 00afe00000 
page 2M
Oct  8 17:42:26 freehit kernel: [    0.000000]  00afe00000 - 00afee0000 
page 4k
Oct  8 17:42:26 freehit kernel: [    0.000000] kernel direct mapping 
tables up to afee0000 @ afedd000-afee0000
Oct  8 17:42:26 freehit kernel: [    0.000000] init_memory_mapping: 
0000000100000000-00000001b0000000
Oct  8 17:42:26 freehit kernel: [    0.000000]  0100000000 - 0180000000 
page 1G
Oct  8 17:42:26 freehit kernel: [    0.000000]  0180000000 - 01b0000000 
page 2M
Oct  8 17:42:26 freehit kernel: [    0.000000] kernel direct mapping 
tables up to 1b0000000 @ 1afffe000-1b0000000
Oct  8 17:42:26 freehit kernel: [    0.000000] ACPI: RSDP 
00000000000f7360 00014 (v00 GBT   )
Oct  8 17:42:26 freehit kernel: [    0.000000] ACPI: RSDT 
00000000afee3000 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
Oct  8 17:42:26 freehit kernel: [    0.000000] ACPI: FACP 
00000000afee3040 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
Oct  8 17:42:26 freehit kernel: [    0.000000] ACPI: DSDT 
00000000afee30c0 072C9 (v01 GBT    GBTUACPI 00001000 MSFT 03000000)
Oct  8 17:42:26 freehit kernel: [    0.000000] ACPI: FACS 
00000000afee0000 00040
Oct  8 17:42:26 freehit kernel: [    0.000000] ACPI: SSDT 
00000000afeea480 0088C (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
Oct  8 17:42:26 freehit kernel: [    0.000000] ACPI: HPET 
00000000afeead40 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
Oct  8 17:42:26 freehit kernel: [    0.000000] ACPI: MCFG 
00000000afeead80 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
Oct  8 17:42:26 freehit kernel: [    0.000000] ACPI: APIC 
00000000afeea3c0 00084 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
Oct  8 17:42:26 freehit kernel: [    0.000000] ACPI: Local APIC address 
0xfee00000
Oct  8 17:42:26 freehit kernel: [    0.000000] No NUMA configuration found
Oct  8 17:42:26 freehit kernel: [    0.000000] Faking a node at 
0000000000000000-00000001b0000000
Oct  8 17:42:26 freehit kernel: [    0.000000] Initmem setup node 0 
0000000000000000-00000001b0000000
Oct  8 17:42:26 freehit kernel: [    0.000000]   NODE_DATA 
[00000001afff9000 - 00000001afffdfff]
Oct  8 17:42:26 freehit kernel: [    0.000000] 
[ffffea0000000000-ffffea0005ffffff] PMD -> 
[ffff8801a9e00000-ffff8801aedfffff] on node 0
Oct  8 17:42:26 freehit kernel: [    0.000000] Zone PFN ranges:
Oct  8 17:42:26 freehit kernel: [    0.000000]   DMA      0x00000010 -> 
0x00001000
Oct  8 17:42:26 freehit kernel: [    0.000000]   DMA32    0x00001000 -> 
0x00100000
Oct  8 17:42:26 freehit kernel: [    0.000000]   Normal   0x00100000 -> 
0x001b0000
Oct  8 17:42:26 freehit kernel: [    0.000000] Movable zone start PFN 
for each node
Oct  8 17:42:26 freehit kernel: [    0.000000] early_node_map[3] active 
PFN ranges
Oct  8 17:42:26 freehit kernel: [    0.000000]     0: 0x00000010 -> 
0x0000009f
Oct  8 17:42:26 freehit kernel: [    0.000000]     0: 0x00000100 -> 
0x000afee0
Oct  8 17:42:26 freehit kernel: [    0.000000]     0: 0x00100000 -> 
0x001b0000
Oct  8 17:42:26 freehit kernel: [    0.000000] On node 0 totalpages: 1441391
Oct  8 17:42:26 freehit kernel: [    0.000000]   DMA zone: 56 pages used 
for memmap
Oct  8 17:42:26 freehit kernel: [    0.000000]   DMA zone: 5 pages reserved
Oct  8 17:42:26 freehit kernel: [    0.000000]   DMA zone: 3922 pages, 
LIFO batch:0
Oct  8 17:42:26 freehit kernel: [    0.000000]   DMA32 zone: 14280 pages 
used for memmap
Oct  8 17:42:26 freehit kernel: [    0.000000]   DMA32 zone: 702232 
pages, LIFO batch:31
Oct  8 17:42:26 freehit kernel: [    0.000000]   Normal zone: 9856 pages 
used for memmap
Oct  8 17:42:26 freehit kernel: [    0.000000]   Normal zone: 711040 
pages, LIFO batch:31
Oct  8 17:42:26 freehit kernel: [    0.000000] ACPI: PM-Timer IO Port: 
0x4008
Oct  8 17:42:26 freehit kernel: [    0.000000] ACPI: Local APIC address 
0xfee00000
Oct  8 17:42:26 freehit kernel: [    0.000000] ACPI: LAPIC 
(acpi_id[0x00] lapic_id[0x00] enabled)
Oct  8 17:42:26 freehit kernel: [    0.000000] ACPI: LAPIC 
(acpi_id[0x01] lapic_id[0x01] enabled)
Oct  8 17:42:26 freehit kernel: [    0.000000] ACPI: LAPIC 
(acpi_id[0x02] lapic_id[0x02] enabled)
Oct  8 17:42:26 freehit kernel: [    0.000000] ACPI: LAPIC 
(acpi_id[0x03] lapic_id[0x03] enabled)
Oct  8 17:42:26 freehit kernel: [    0.000000] ACPI: LAPIC_NMI 
(acpi_id[0x00] dfl dfl lint[0x1])
Oct  8 17:42:26 freehit kernel: [    0.000000] ACPI: LAPIC_NMI 
(acpi_id[0x01] dfl dfl lint[0x1])
Oct  8 17:42:26 freehit kernel: [    0.000000] ACPI: LAPIC_NMI 
(acpi_id[0x02] dfl dfl lint[0x1])
Oct  8 17:42:26 freehit kernel: [    0.000000] ACPI: LAPIC_NMI 
(acpi_id[0x03] dfl dfl lint[0x1])
Oct  8 17:42:26 freehit kernel: [    0.000000] ACPI: IOAPIC (id[0x02] 
address[0xfec00000] gsi_base[0])
Oct  8 17:42:26 freehit kernel: [    0.000000] IOAPIC[0]: apic_id 2, 
version 33, address 0xfec00000, GSI 0-23
Oct  8 17:42:26 freehit kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 
bus_irq 0 global_irq 2 dfl dfl)
Oct  8 17:42:26 freehit kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 
bus_irq 9 global_irq 9 low level)
Oct  8 17:42:26 freehit kernel: [    0.000000] ACPI: IRQ0 used by override.
Oct  8 17:42:26 freehit kernel: [    0.000000] ACPI: IRQ2 used by override.
Oct  8 17:42:26 freehit kernel: [    0.000000] ACPI: IRQ9 used by override.
Oct  8 17:42:26 freehit kernel: [    0.000000] Using ACPI (MADT) for SMP 
configuration information
Oct  8 17:42:26 freehit kernel: [    0.000000] ACPI: HPET id: 0x10b9a201 
base: 0xfed00000
Oct  8 17:42:26 freehit kernel: [    0.000000] SMP: Allowing 4 CPUs, 0 
hotplug CPUs
Oct  8 17:42:26 freehit kernel: [    0.000000] nr_irqs_gsi: 40
Oct  8 17:42:26 freehit kernel: [    0.000000] PM: Registered nosave 
memory: 000000000009f000 - 00000000000a0000
Oct  8 17:42:26 freehit kernel: [    0.000000] PM: Registered nosave 
memory: 00000000000a0000 - 00000000000f0000
Oct  8 17:42:26 freehit kernel: [    0.000000] PM: Registered nosave 
memory: 00000000000f0000 - 0000000000100000
Oct  8 17:42:26 freehit kernel: [    0.000000] PM: Registered nosave 
memory: 00000000afee0000 - 00000000afee3000
Oct  8 17:42:26 freehit kernel: [    0.000000] PM: Registered nosave 
memory: 00000000afee3000 - 00000000afef0000
Oct  8 17:42:26 freehit kernel: [    0.000000] PM: Registered nosave 
memory: 00000000afef0000 - 00000000aff00000
Oct  8 17:42:26 freehit kernel: [    0.000000] PM: Registered nosave 
memory: 00000000aff00000 - 00000000e0000000
Oct  8 17:42:26 freehit kernel: [    0.000000] PM: Registered nosave 
memory: 00000000e0000000 - 00000000f0000000
Oct  8 17:42:26 freehit kernel: [    0.000000] PM: Registered nosave 
memory: 00000000f0000000 - 00000000fec00000
Oct  8 17:42:26 freehit kernel: [    0.000000] PM: Registered nosave 
memory: 00000000fec00000 - 0000000100000000
Oct  8 17:42:26 freehit kernel: [    0.000000] Allocating PCI resources 
starting at aff00000 (gap: aff00000:30100000)
Oct  8 17:42:26 freehit kernel: [    0.000000] setup_percpu: NR_CPUS:64 
nr_cpumask_bits:64 nr_cpu_ids:4 nr_node_ids:1
Oct  8 17:42:26 freehit kernel: [    0.000000] PERCPU: Embedded 25 
pages/cpu @ffff8801afc00000 s72768 r8192 d21440 u524288
Oct  8 17:42:26 freehit kernel: [    0.000000] pcpu-alloc: s72768 r8192 
d21440 u524288 alloc=1*2097152
Oct  8 17:42:26 freehit kernel: [    0.000000] pcpu-alloc: [0] 0 1 2 3
Oct  8 17:42:26 freehit kernel: [    0.000000] Built 1 zonelists in Zone 
order, mobility grouping on.  Total pages: 1417194
Oct  8 17:42:26 freehit kernel: [    0.000000] Policy zone: Normal
Oct  8 17:42:26 freehit kernel: [    0.000000] Kernel command line: 
root=/dev/sda3 loglevel=9
Oct  8 17:42:26 freehit kernel: [    0.000000] PID hash table entries: 
4096 (order: 3, 32768 bytes)
Oct  8 17:42:26 freehit kernel: [    0.000000] Checking aperture...
Oct  8 17:42:26 freehit kernel: [    0.000000] No AGP bridge found
Oct  8 17:42:26 freehit kernel: [    0.000000] Node 0: aperture @ 
a4000000 size 32 MB
Oct  8 17:42:26 freehit kernel: [    0.000000] Aperture pointing to e820 
RAM. Ignoring.
Oct  8 17:42:26 freehit kernel: [    0.000000] Your BIOS doesn't leave a 
aperture memory hole
Oct  8 17:42:26 freehit kernel: [    0.000000] Please enable the IOMMU 
option in the BIOS setup
Oct  8 17:42:26 freehit kernel: [    0.000000] This costs you 64 MB of RAM
Oct  8 17:42:26 freehit kernel: [    0.000000] Mapping aperture over 
65536 KB of RAM @ a4000000
Oct  8 17:42:26 freehit kernel: [    0.000000] PM: Registered nosave 
memory: 00000000a4000000 - 00000000a8000000
Oct  8 17:42:26 freehit kernel: [    0.000000] Memory: 5526028k/7077888k 
available (8207k kernel code, 1312324k absent, 239536k reserved, 6845k 
data, 660k init)
Oct  8 17:42:26 freehit kernel: [    0.000000] SLUB: Genslabs=15, 
HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Oct  8 17:42:26 freehit kernel: [    0.000000] Hierarchical RCU 
implementation.
Oct  8 17:42:26 freehit kernel: [    0.000000] NR_IRQS:4352 nr_irqs:712 16
Oct  8 17:42:26 freehit kernel: [    0.000000] Console: colour VGA+ 80x25
Oct  8 17:42:26 freehit kernel: [    0.000000] console [tty0] enabled
Oct  8 17:42:26 freehit kernel: [    0.000000] Lock dependency 
validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
Oct  8 17:42:26 freehit kernel: [    0.000000] ... 
MAX_LOCKDEP_SUBCLASSES:  8
Oct  8 17:42:26 freehit kernel: [    0.000000] ... MAX_LOCK_DEPTH: 
     48
Oct  8 17:42:26 freehit kernel: [    0.000000] ... MAX_LOCKDEP_KEYS: 
     8191
Oct  8 17:42:26 freehit kernel: [    0.000000] ... CLASSHASH_SIZE: 
     4096
Oct  8 17:42:26 freehit kernel: [    0.000000] ... MAX_LOCKDEP_ENTRIES: 
     16384
Oct  8 17:42:26 freehit kernel: [    0.000000] ... MAX_LOCKDEP_CHAINS: 
     32768
Oct  8 17:42:26 freehit kernel: [    0.000000] ... CHAINHASH_SIZE: 
     16384
Oct  8 17:42:26 freehit kernel: [    0.000000]  memory used by lock 
dependency info: 5855 kB
Oct  8 17:42:26 freehit kernel: [    0.000000]  per task-struct memory 
footprint: 1920 bytes
Oct  8 17:42:26 freehit kernel: [    0.000000] hpet clockevent registered
Oct  8 17:42:26 freehit kernel: [    0.000000] Fast TSC calibration 
using PIT
Oct  8 17:42:26 freehit kernel: [    0.000000] Detected 3006.453 MHz 
processor.
Oct  8 17:42:26 freehit kernel: [    0.002003] Calibrating delay loop 
(skipped), value calculated using timer frequency.. 6012.90 BogoMIPS 
(lpj=3006453)
Oct  8 17:42:26 freehit kernel: [    0.002089] pid_max: default: 32768 
minimum: 301
Oct  8 17:42:26 freehit kernel: [    0.002174] Security Framework 
initialized
Oct  8 17:42:26 freehit kernel: [    0.002220] SELinux:  Initializing.
Oct  8 17:42:26 freehit kernel: [    0.002289] SELinux:  Starting in 
permissive mode
Oct  8 17:42:26 freehit kernel: [    0.003057] Dentry cache hash table 
entries: 1048576 (order: 11, 8388608 bytes)
Oct  8 17:42:26 freehit kernel: [    0.006864] Inode-cache hash table 
entries: 524288 (order: 10, 4194304 bytes)
Oct  8 17:42:26 freehit kernel: [    0.008666] Mount-cache hash table 
entries: 256
Oct  8 17:42:26 freehit kernel: [    0.009412] Initializing cgroup 
subsys cpuacct
Oct  8 17:42:26 freehit kernel: [    0.009459] Initializing cgroup 
subsys freezer
Oct  8 17:42:26 freehit kernel: [    0.009541] tseg: 00aff00000
Oct  8 17:42:26 freehit kernel: [    0.009583] CPU: Physical Processor ID: 0
Oct  8 17:42:26 freehit kernel: [    0.009625] CPU: Processor Core ID: 0
Oct  8 17:42:26 freehit kernel: [    0.009667] mce: CPU supports 6 MCE banks
Oct  8 17:42:26 freehit kernel: [    0.009717] using AMD E400 aware idle 
routine
Oct  8 17:42:26 freehit kernel: [    0.009819] ACPI: Core revision 20110413
Oct  8 17:42:26 freehit kernel: [    0.014633] ..TIMER: vector=0x30 
apic1=0 pin1=2 apic2=-1 pin2=-1
Oct  8 17:42:26 freehit kernel: [    0.024691] CPU0: AMD Phenom(tm) II 
X4 940 Processor stepping 02
Oct  8 17:42:26 freehit kernel: [    0.025998] Performance Events: AMD 
PMU driver.
Oct  8 17:42:26 freehit kernel: [    0.025998] ... version:                0
Oct  8 17:42:26 freehit kernel: [    0.025998] ... bit width: 
    48
Oct  8 17:42:26 freehit kernel: [    0.025998] ... generic registers:      4
Oct  8 17:42:26 freehit kernel: [    0.025998] ... value mask: 
    0000ffffffffffff
Oct  8 17:42:26 freehit kernel: [    0.025998] ... max period: 
    00007fffffffffff
Oct  8 17:42:26 freehit kernel: [    0.025998] ... fixed-purpose events:   0
Oct  8 17:42:26 freehit kernel: [    0.025998] ... event mask: 
    000000000000000f
Oct  8 17:42:26 freehit kernel: [    0.025998] MCE: In-kernel MCE 
decoding enabled.
Oct  8 17:42:26 freehit kernel: [    0.025998] lockdep: fixing up 
alternatives.
Oct  8 17:42:26 freehit kernel: [    0.025998] Booting Node   0, 
Processors  #1
Oct  8 17:42:26 freehit kernel: [    0.026029] smpboot cpu 1: start_ip = 
9a000
Oct  8 17:42:26 freehit kernel: [    0.098111] lockdep: fixing up 
alternatives.
Oct  8 17:42:26 freehit kernel: [    0.098173]  #2
Oct  8 17:42:26 freehit kernel: [    0.098201] smpboot cpu 2: start_ip = 
9a000
Oct  8 17:42:26 freehit kernel: [    0.170068] lockdep: fixing up 
alternatives.
Oct  8 17:42:26 freehit kernel: [    0.170127]  #3 Ok.
Oct  8 17:42:26 freehit kernel: [    0.170168] smpboot cpu 3: start_ip = 
9a000
Oct  8 17:42:26 freehit kernel: [    0.241979] Brought up 4 CPUs
Oct  8 17:42:26 freehit kernel: [    0.242021] Total of 4 processors 
activated (24051.20 BogoMIPS).
Oct  8 17:42:26 freehit kernel: [    0.244196] kworker/u:0 used greatest 
stack depth: 4808 bytes left
Oct  8 17:42:26 freehit kernel: [    0.244293] PM: Registering ACPI NVS 
region at afee0000 (12288 bytes)
Oct  8 17:42:26 freehit kernel: [    0.245015] Time: 12:11:16  Date: 
10/08/11
Oct  8 17:42:26 freehit kernel: [    0.245217] NET: Registered protocol 
family 16
Oct  8 17:42:26 freehit kernel: [    0.246002] node 0 link 0: io port 
[c000, ffff]
Oct  8 17:42:26 freehit kernel: [    0.246037] TOM: 00000000d0000000 aka 
3328M
Oct  8 17:42:26 freehit kernel: [    0.246079] Fam 10h mmconf [e0000000, 
e00fffff]
Oct  8 17:42:26 freehit kernel: [    0.246122] node 0 link 0: mmio 
[a0000, bffff]
Oct  8 17:42:26 freehit kernel: [    0.246192] node 0 link 0: mmio 
[d0000000, dfffffff]
Oct  8 17:42:26 freehit kernel: [    0.246262] node 0 link 0: mmio 
[f0000000, fe02ffff]
Oct  8 17:42:26 freehit kernel: [    0.246332] node 0 link 0: mmio 
[e0000000, e03fffff] ==> [e0100000, e03fffff]
Oct  8 17:42:26 freehit kernel: [    0.246430] TOM2: 00000001b0000000 
aka 6912M
Oct  8 17:42:26 freehit kernel: [    0.246474] bus: [00, 03] on node 0 
link 0
Oct  8 17:42:26 freehit kernel: [    0.246517] bus: 00 index 0 [io 
0x0000-0xffff]
Oct  8 17:42:26 freehit kernel: [    0.246560] bus: 00 index 1 [mem 
0x000a0000-0x000bffff]
Oct  8 17:42:26 freehit kernel: [    0.246603] bus: 00 index 2 [mem 
0xd0000000-0xdfffffff]
Oct  8 17:42:26 freehit kernel: [    0.246645] bus: 00 index 3 [mem 
0xe0400000-0xffffffff]
Oct  8 17:42:26 freehit kernel: [    0.246689] bus: 00 index 4 [mem 
0xe0100000-0xe03fffff]
Oct  8 17:42:26 freehit kernel: [    0.246732] bus: 00 index 5 [mem 
0x1b0000000-0xfcffffffff]
Oct  8 17:42:26 freehit kernel: [    0.246783] Extended Config Space 
enabled on 1 nodes
Oct  8 17:42:26 freehit kernel: [    0.247055] ACPI: bus type pci registered
Oct  8 17:42:26 freehit kernel: [    0.247107] PCI: MMCONFIG for domain 
0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
Oct  8 17:42:26 freehit kernel: [    0.247107] PCI: MMCONFIG at [mem 
0xe0000000-0xefffffff] reserved in E820
Oct  8 17:42:26 freehit kernel: [    0.285149] PCI: Using configuration 
type 1 for base access
Oct  8 17:42:26 freehit kernel: [    0.299183] bio: create slab <bio-0> at 0
Oct  8 17:42:26 freehit kernel: [    0.302210] ACPI: EC: Look up EC in DSDT
Oct  8 17:42:26 freehit kernel: [    0.309313] ACPI: Interpreter enabled
Oct  8 17:42:26 freehit kernel: [    0.309364] ACPI: (supports S0 S3 S4 S5)
Oct  8 17:42:26 freehit kernel: [    0.309569] ACPI: Using IOAPIC for 
interrupt routing
Oct  8 17:42:26 freehit kernel: [    0.343157] ACPI: No dock devices found.
Oct  8 17:42:26 freehit kernel: [    0.343202] PCI: Using host bridge 
windows from ACPI; if necessary, use "pci=nocrs" and report a bug
Oct  8 17:42:26 freehit kernel: [    0.343358] ACPI: PCI Root Bridge 
[PCI0] (domain 0000 [bus 00-ff])
Oct  8 17:42:26 freehit kernel: [    0.343971] pci_root PNP0A03:00: host 
bridge window [io  0x0000-0x0cf7]
Oct  8 17:42:26 freehit kernel: [    0.344016] pci_root PNP0A03:00: host 
bridge window [io  0x0d00-0xffff]
Oct  8 17:42:26 freehit kernel: [    0.344059] pci_root PNP0A03:00: host 
bridge window [mem 0x000a0000-0x000bffff]
Oct  8 17:42:26 freehit kernel: [    0.344116] pci_root PNP0A03:00: host 
bridge window [mem 0x000c0000-0x000dffff]
Oct  8 17:42:26 freehit kernel: [    0.344173] pci_root PNP0A03:00: host 
bridge window [mem 0xd0000000-0xfebfffff]
Oct  8 17:42:26 freehit kernel: [    0.344267] pci 0000:00:00.0: 
[1022:9600] type 0 class 0x000600
Oct  8 17:42:26 freehit kernel: [    0.344326] pci 0000:00:00.0: reg 1c: 
[mem 0xe0000000-0xffffffff 64bit]
Oct  8 17:42:26 freehit kernel: [    0.344445] pci 0000:00:01.0: 
[1022:9602] type 1 class 0x000604
Oct  8 17:42:26 freehit kernel: [    0.344544] pci 0000:00:0a.0: 
[1022:9609] type 1 class 0x000604
Oct  8 17:42:26 freehit kernel: [    0.344623] pci 0000:00:0a.0: PME# 
supported from D0 D3hot D3cold
Oct  8 17:42:26 freehit kernel: [    0.344668] pci 0000:00:0a.0: PME# 
disabled
Oct  8 17:42:26 freehit kernel: [    0.344742] pci 0000:00:11.0: 
[1002:4390] type 0 class 0x000101
Oct  8 17:42:26 freehit kernel: [    0.344806] pci 0000:00:11.0: reg 10: 
[io  0xff00-0xff07]
Oct  8 17:42:26 freehit kernel: [    0.344860] pci 0000:00:11.0: reg 14: 
[io  0xfe00-0xfe03]
Oct  8 17:42:26 freehit kernel: [    0.344912] pci 0000:00:11.0: reg 18: 
[io  0xfd00-0xfd07]
Oct  8 17:42:26 freehit kernel: [    0.344968] pci 0000:00:11.0: reg 1c: 
[io  0xfc00-0xfc03]
Oct  8 17:42:26 freehit kernel: [    0.345021] pci 0000:00:11.0: reg 20: 
[io  0xfb00-0xfb0f]
Oct  8 17:42:26 freehit kernel: [    0.345073] pci 0000:00:11.0: reg 24: 
[mem 0xfe02f000-0xfe02f3ff]
Oct  8 17:42:26 freehit kernel: [    0.345139] pci 0000:00:11.0: set 
SATA to AHCI mode
Oct  8 17:42:26 freehit kernel: [    0.345219] pci 0000:00:12.0: 
[1002:4397] type 0 class 0x000c03
Oct  8 17:42:26 freehit kernel: [    0.345276] pci 0000:00:12.0: reg 10: 
[mem 0xfe02e000-0xfe02efff]
Oct  8 17:42:26 freehit kernel: [    0.345394] pci 0000:00:12.1: 
[1002:4398] type 0 class 0x000c03
Oct  8 17:42:26 freehit kernel: [    0.345451] pci 0000:00:12.1: reg 10: 
[mem 0xfe02d000-0xfe02dfff]
Oct  8 17:42:26 freehit kernel: [    0.345575] pci 0000:00:12.2: 
[1002:4396] type 0 class 0x000c03
Oct  8 17:42:26 freehit kernel: [    0.345638] pci 0000:00:12.2: reg 10: 
[mem 0xfe02c000-0xfe02c0ff]
Oct  8 17:42:26 freehit kernel: [    0.345763] pci 0000:00:12.2: 
supports D1 D2
Oct  8 17:42:26 freehit kernel: [    0.345806] pci 0000:00:12.2: PME# 
supported from D0 D1 D2 D3hot
Oct  8 17:42:26 freehit kernel: [    0.345852] pci 0000:00:12.2: PME# 
disabled
Oct  8 17:42:26 freehit kernel: [    0.345918] pci 0000:00:13.0: 
[1002:4397] type 0 class 0x000c03
Oct  8 17:42:26 freehit kernel: [    0.345972] pci 0000:00:13.0: reg 10: 
[mem 0xfe02b000-0xfe02bfff]
Oct  8 17:42:26 freehit kernel: [    0.346090] pci 0000:00:13.1: 
[1002:4398] type 0 class 0x000c03
Oct  8 17:42:26 freehit kernel: [    0.346147] pci 0000:00:13.1: reg 10: 
[mem 0xfe02a000-0xfe02afff]
Oct  8 17:42:26 freehit kernel: [    0.346272] pci 0000:00:13.2: 
[1002:4396] type 0 class 0x000c03
Oct  8 17:42:26 freehit kernel: [    0.346336] pci 0000:00:13.2: reg 10: 
[mem 0xfe029000-0xfe0290ff]
Oct  8 17:42:26 freehit kernel: [    0.346461] pci 0000:00:13.2: 
supports D1 D2
Oct  8 17:42:26 freehit kernel: [    0.346503] pci 0000:00:13.2: PME# 
supported from D0 D1 D2 D3hot
Oct  8 17:42:26 freehit kernel: [    0.346549] pci 0000:00:13.2: PME# 
disabled
Oct  8 17:42:26 freehit kernel: [    0.346618] pci 0000:00:14.0: 
[1002:4385] type 0 class 0x000c05
Oct  8 17:42:26 freehit kernel: [    0.346769] pci 0000:00:14.1: 
[1002:439c] type 0 class 0x000101
Oct  8 17:42:26 freehit kernel: [    0.346830] pci 0000:00:14.1: reg 10: 
[io  0x0000-0x0007]
Oct  8 17:42:26 freehit kernel: [    0.346882] pci 0000:00:14.1: reg 14: 
[io  0x0000-0x0003]
Oct  8 17:42:26 freehit kernel: [    0.346935] pci 0000:00:14.1: reg 18: 
[io  0x0000-0x0007]
Oct  8 17:42:26 freehit kernel: [    0.346971] pci 0000:00:14.1: reg 1c: 
[io  0x0000-0x0003]
Oct  8 17:42:26 freehit kernel: [    0.347023] pci 0000:00:14.1: reg 20: 
[io  0xfa00-0xfa0f]
Oct  8 17:42:26 freehit kernel: [    0.347123] pci 0000:00:14.2: 
[1002:4383] type 0 class 0x000403
Oct  8 17:42:26 freehit kernel: [    0.347190] pci 0000:00:14.2: reg 10: 
[mem 0xfe024000-0xfe027fff 64bit]
Oct  8 17:42:26 freehit kernel: [    0.347301] pci 0000:00:14.2: PME# 
supported from D0 D3hot D3cold
Oct  8 17:42:26 freehit kernel: [    0.347346] pci 0000:00:14.2: PME# 
disabled
Oct  8 17:42:26 freehit kernel: [    0.347401] pci 0000:00:14.3: 
[1002:439d] type 0 class 0x000601
Oct  8 17:42:26 freehit kernel: [    0.347532] pci 0000:00:14.4: 
[1002:4384] type 1 class 0x000604
Oct  8 17:42:26 freehit kernel: [    0.347621] pci 0000:00:14.5: 
[1002:4399] type 0 class 0x000c03
Oct  8 17:42:26 freehit kernel: [    0.347679] pci 0000:00:14.5: reg 10: 
[mem 0xfe028000-0xfe028fff]
Oct  8 17:42:26 freehit kernel: [    0.347801] pci 0000:00:18.0: 
[1022:1200] type 0 class 0x000600
Oct  8 17:42:26 freehit kernel: [    0.347871] pci 0000:00:18.1: 
[1022:1201] type 0 class 0x000600
Oct  8 17:42:26 freehit kernel: [    0.347971] pci 0000:00:18.2: 
[1022:1202] type 0 class 0x000600
Oct  8 17:42:26 freehit kernel: [    0.348036] pci 0000:00:18.3: 
[1022:1203] type 0 class 0x000600
Oct  8 17:42:26 freehit kernel: [    0.348105] pci 0000:00:18.4: 
[1022:1204] type 0 class 0x000600
Oct  8 17:42:26 freehit kernel: [    0.348210] pci 0000:01:05.0: 
[1002:9614] type 0 class 0x000300
Oct  8 17:42:26 freehit kernel: [    0.348263] pci 0000:01:05.0: reg 10: 
[mem 0xd0000000-0xdfffffff pref]
Oct  8 17:42:26 freehit kernel: [    0.348311] pci 0000:01:05.0: reg 14: 
[io  0xee00-0xeeff]
Oct  8 17:42:26 freehit kernel: [    0.348358] pci 0000:01:05.0: reg 18: 
[mem 0xfdfe0000-0xfdfeffff]
Oct  8 17:42:26 freehit kernel: [    0.348413] pci 0000:01:05.0: reg 24: 
[mem 0xfde00000-0xfdefffff]
Oct  8 17:42:26 freehit kernel: [    0.348472] pci 0000:01:05.0: 
supports D1 D2
Oct  8 17:42:26 freehit kernel: [    0.348526] pci 0000:01:05.1: 
[1002:960f] type 0 class 0x000403
Oct  8 17:42:26 freehit kernel: [    0.348578] pci 0000:01:05.1: reg 10: 
[mem 0xfdffc000-0xfdffffff]
Oct  8 17:42:26 freehit kernel: [    0.348657] pci 0000:01:05.1: 
supports D1 D2
Oct  8 17:42:26 freehit kernel: [    0.348746] pci 0000:00:01.0: PCI 
bridge to [bus 01-01]
Oct  8 17:42:26 freehit kernel: [    0.348791] pci 0000:00:01.0: 
bridge window [io  0xe000-0xefff]
Oct  8 17:42:26 freehit kernel: [    0.348836] pci 0000:00:01.0: 
bridge window [mem 0xfde00000-0xfdffffff]
Oct  8 17:42:26 freehit kernel: [    0.348882] pci 0000:00:01.0: 
bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
Oct  8 17:42:26 freehit kernel: [    0.348989] pci 0000:02:00.0: 
[10ec:8168] type 0 class 0x000200
Oct  8 17:42:26 freehit kernel: [    0.349044] pci 0000:02:00.0: reg 10: 
[io  0xde00-0xdeff]
Oct  8 17:42:26 freehit kernel: [    0.349109] pci 0000:02:00.0: reg 18: 
[mem 0xfdaff000-0xfdafffff 64bit pref]
Oct  8 17:42:26 freehit kernel: [    0.349167] pci 0000:02:00.0: reg 20: 
[mem 0xfdae0000-0xfdaeffff 64bit pref]
Oct  8 17:42:26 freehit kernel: [    0.349219] pci 0000:02:00.0: reg 30: 
[mem 0x00000000-0x0000ffff pref]
Oct  8 17:42:26 freehit kernel: [    0.349295] pci 0000:02:00.0: 
supports D1 D2
Oct  8 17:42:26 freehit kernel: [    0.349337] pci 0000:02:00.0: PME# 
supported from D0 D1 D2 D3hot D3cold
Oct  8 17:42:26 freehit kernel: [    0.349383] pci 0000:02:00.0: PME# 
disabled
Oct  8 17:42:26 freehit kernel: [    0.351020] pci 0000:00:0a.0: PCI 
bridge to [bus 02-02]
Oct  8 17:42:26 freehit kernel: [    0.351070] pci 0000:00:0a.0: 
bridge window [io  0xd000-0xdfff]
Oct  8 17:42:26 freehit kernel: [    0.351116] pci 0000:00:0a.0: 
bridge window [mem 0xfdd00000-0xfddfffff]
Oct  8 17:42:26 freehit kernel: [    0.351164] pci 0000:00:0a.0: 
bridge window [mem 0xfda00000-0xfdafffff 64bit pref]
Oct  8 17:42:26 freehit kernel: [    0.351280] pci 0000:03:0e.0: 
[104c:8024] type 0 class 0x000c00
Oct  8 17:42:26 freehit kernel: [    0.351349] pci 0000:03:0e.0: reg 10: 
[mem 0xfdcff000-0xfdcff7ff]
Oct  8 17:42:26 freehit kernel: [    0.351405] pci 0000:03:0e.0: reg 14: 
[mem 0xfdcf8000-0xfdcfbfff]
Oct  8 17:42:26 freehit kernel: [    0.351540] pci 0000:03:0e.0: 
supports D1 D2
Oct  8 17:42:26 freehit kernel: [    0.351584] pci 0000:03:0e.0: PME# 
supported from D0 D1 D2 D3hot
Oct  8 17:42:26 freehit kernel: [    0.351655] pci 0000:03:0e.0: PME# 
disabled
Oct  8 17:42:26 freehit kernel: [    0.351737] pci 0000:00:14.4: PCI 
bridge to [bus 03-03] (subtractive decode)
Oct  8 17:42:26 freehit kernel: [    0.351784] pci 0000:00:14.4: 
bridge window [io  0xc000-0xcfff]
Oct  8 17:42:26 freehit kernel: [    0.351830] pci 0000:00:14.4: 
bridge window [mem 0xfdc00000-0xfdcfffff]
Oct  8 17:42:26 freehit kernel: [    0.351876] pci 0000:00:14.4: 
bridge window [mem 0xfdb00000-0xfdbfffff pref]
Oct  8 17:42:26 freehit kernel: [    0.351934] pci 0000:00:14.4: 
bridge window [io  0x0000-0x0cf7] (subtractive decode)
Oct  8 17:42:26 freehit kernel: [    0.351959] pci 0000:00:14.4: 
bridge window [io  0x0d00-0xffff] (subtractive decode)
Oct  8 17:42:26 freehit kernel: [    0.352017] pci 0000:00:14.4: 
bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
Oct  8 17:42:26 freehit kernel: [    0.352076] pci 0000:00:14.4: 
bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
Oct  8 17:42:26 freehit kernel: [    0.352133] pci 0000:00:14.4: 
bridge window [mem 0xd0000000-0xfebfffff] (subtractive decode)
Oct  8 17:42:26 freehit kernel: [    0.352205] ACPI: PCI Interrupt 
Routing Table [\_SB_.PCI0._PRT]
Oct  8 17:42:26 freehit kernel: [    0.352673] ACPI: PCI Interrupt 
Routing Table [\_SB_.PCI0.P2P_._PRT]
Oct  8 17:42:26 freehit kernel: [    0.352827] ACPI: PCI Interrupt 
Routing Table [\_SB_.PCI0.PCEA._PRT]
Oct  8 17:42:26 freehit kernel: [    0.352976] ACPI: PCI Interrupt 
Routing Table [\_SB_.PCI0.AGP_._PRT]
Oct  8 17:42:26 freehit kernel: [    0.353064]  pci0000:00: Requesting 
ACPI _OSC control (0x1d)
Oct  8 17:42:26 freehit kernel: [    0.353109]  pci0000:00: ACPI _OSC 
request failed (AE_NOT_FOUND), returned control mask: 0x1d
Oct  8 17:42:26 freehit kernel: [    0.353166] ACPI _OSC control for 
PCIe not granted, disabling ASPM
Oct  8 17:42:26 freehit kernel: [    0.373029] ACPI: PCI Interrupt Link 
[LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Oct  8 17:42:26 freehit kernel: [    0.374003] ACPI: PCI Interrupt Link 
[LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Oct  8 17:42:26 freehit kernel: [    0.374402] ACPI: PCI Interrupt Link 
[LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Oct  8 17:42:26 freehit kernel: [    0.374800] ACPI: PCI Interrupt Link 
[LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Oct  8 17:42:26 freehit kernel: [    0.375187] ACPI: PCI Interrupt Link 
[LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Oct  8 17:42:26 freehit kernel: [    0.376007] ACPI: PCI Interrupt Link 
[LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Oct  8 17:42:26 freehit kernel: [    0.376405] ACPI: PCI Interrupt Link 
[LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Oct  8 17:42:26 freehit kernel: [    0.376802] ACPI: PCI Interrupt Link 
[LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Oct  8 17:42:26 freehit kernel: [    0.377179] vgaarb: device added: 
PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
Oct  8 17:42:26 freehit kernel: [    0.377179] vgaarb: loaded
Oct  8 17:42:26 freehit kernel: [    0.377179] vgaarb: bridge control 
possible 0000:01:05.0
Oct  8 17:42:26 freehit kernel: [    0.377226] SCSI subsystem initialized
Oct  8 17:42:26 freehit kernel: [    0.377981] libata version 3.00 loaded.
Oct  8 17:42:26 freehit kernel: [    0.378021] usbcore: registered new 
interface driver usbfs
Oct  8 17:42:26 freehit kernel: [    0.378021] usbcore: registered new 
interface driver hub
Oct  8 17:42:26 freehit kernel: [    0.378021] usbcore: registered new 
device driver usb
Oct  8 17:42:26 freehit kernel: [    0.379005] Advanced Linux Sound 
Architecture Driver Version 1.0.24.
Oct  8 17:42:26 freehit kernel: [    0.379044] PCI: Using ACPI for IRQ 
routing
Oct  8 17:42:26 freehit kernel: [    0.388894] PCI: pci_cache_line_size 
set to 64 bytes
Oct  8 17:42:26 freehit kernel: [    0.388945] pci 0000:00:00.0: no 
compatible bridge window for [mem 0xe0000000-0xffffffff 64bit]
Oct  8 17:42:26 freehit kernel: [    0.389053] reserve RAM buffer: 
000000000009f800 - 000000000009ffff
Oct  8 17:42:26 freehit kernel: [    0.389085] reserve RAM buffer: 
00000000afee0000 - 00000000afffffff
Oct  8 17:42:26 freehit kernel: [    0.389176] cfg80211: Calling CRDA to 
update world regulatory domain
Oct  8 17:42:26 freehit kernel: [    0.390162] NetLabel: Initializing
Oct  8 17:42:26 freehit kernel: [    0.390204] NetLabel:  domain hash 
size = 128
Oct  8 17:42:26 freehit kernel: [    0.390246] NetLabel:  protocols = 
UNLABELED CIPSOv4
Oct  8 17:42:26 freehit kernel: [    0.390322] NetLabel:  unlabeled 
traffic allowed by default
Oct  8 17:42:26 freehit kernel: [    0.390374] hpet0: at MMIO 
0xfed00000, IRQs 2, 8, 0, 0
Oct  8 17:42:26 freehit kernel: [    0.390374] hpet0: 4 comparators, 
32-bit 14.318180 MHz counter
Oct  8 17:42:26 freehit kernel: [    0.392014] Switching to clocksource hpet
Oct  8 17:42:26 freehit kernel: [    0.392817] Switched to NOHz mode on 
CPU #0
Oct  8 17:42:26 freehit kernel: [    0.392860] Switched to NOHz mode on 
CPU #3
Oct  8 17:42:26 freehit kernel: [    0.392923] Switched to NOHz mode on 
CPU #2
Oct  8 17:42:26 freehit kernel: [    0.392953] Switched to NOHz mode on 
CPU #1
Oct  8 17:42:26 freehit kernel: [    0.405326] pnp: PnP ACPI init
Oct  8 17:42:26 freehit kernel: [    0.405387] ACPI: bus type pnp registered
Oct  8 17:42:26 freehit kernel: [    0.405507] pnp 00:00: [bus 00-ff]
Oct  8 17:42:26 freehit kernel: [    0.405550] pnp 00:00: [io 
0x0cf8-0x0cff]
Oct  8 17:42:26 freehit kernel: [    0.405593] pnp 00:00: [io 
0x0000-0x0cf7 window]
Oct  8 17:42:26 freehit kernel: [    0.405637] pnp 00:00: [io 
0x0d00-0xffff window]
Oct  8 17:42:26 freehit kernel: [    0.405680] pnp 00:00: [mem 
0x000a0000-0x000bffff window]
Oct  8 17:42:26 freehit kernel: [    0.405723] pnp 00:00: [mem 
0x000c0000-0x000dffff window]
Oct  8 17:42:26 freehit kernel: [    0.405767] pnp 00:00: [mem 
0xd0000000-0xfebfffff window]
Oct  8 17:42:26 freehit kernel: [    0.405993] pnp 00:00: Plug and Play 
ACPI device, IDs PNP0a03 (active)
Oct  8 17:42:26 freehit kernel: [    0.406073] pnp 00:01: [io 
0x0010-0x001f]
Oct  8 17:42:26 freehit kernel: [    0.406116] pnp 00:01: [io 
0x0022-0x003f]
Oct  8 17:42:26 freehit kernel: [    0.406159] pnp 00:01: [io 
0x0044-0x005f]
Oct  8 17:42:26 freehit kernel: [    0.406201] pnp 00:01: [io 
0x0062-0x0063]
Oct  8 17:42:26 freehit kernel: [    0.406243] pnp 00:01: [io 
0x0065-0x006f]
Oct  8 17:42:26 freehit kernel: [    0.406287] pnp 00:01: [io 
0x0074-0x007f]
Oct  8 17:42:26 freehit kernel: [    0.406329] pnp 00:01: [io 
0x0091-0x0093]
Oct  8 17:42:26 freehit kernel: [    0.406372] pnp 00:01: [io 
0x00a2-0x00bf]
Oct  8 17:42:26 freehit kernel: [    0.406414] pnp 00:01: [io 
0x00e0-0x00ef]
Oct  8 17:42:26 freehit kernel: [    0.406456] pnp 00:01: [io 
0x04d0-0x04d1]
Oct  8 17:42:26 freehit kernel: [    0.406498] pnp 00:01: [io 
0x0220-0x0225]
Oct  8 17:42:26 freehit kernel: [    0.406540] pnp 00:01: [io 
0x0290-0x0294]
Oct  8 17:42:26 freehit kernel: [    0.406776] system 00:01: [io 
0x04d0-0x04d1] has been reserved
Oct  8 17:42:26 freehit kernel: [    0.406821] system 00:01: [io 
0x0220-0x0225] has been reserved
Oct  8 17:42:26 freehit kernel: [    0.406865] system 00:01: [io 
0x0290-0x0294] has been reserved
Oct  8 17:42:26 freehit kernel: [    0.406910] system 00:01: Plug and 
Play ACPI device, IDs PNP0c02 (active)
Oct  8 17:42:26 freehit kernel: [    0.477110] pnp 00:02: [io 
0x4100-0x411f]
Oct  8 17:42:26 freehit kernel: [    0.477154] pnp 00:02: [io 
0x0228-0x022f]
Oct  8 17:42:26 freehit kernel: [    0.477197] pnp 00:02: [io  0x040b]
Oct  8 17:42:26 freehit kernel: [    0.477240] pnp 00:02: [io  0x04d6]
Oct  8 17:42:26 freehit kernel: [    0.477282] pnp 00:02: [io 
0x0c00-0x0c01]
Oct  8 17:42:26 freehit kernel: [    0.477324] pnp 00:02: [io  0x0c14]
Oct  8 17:42:26 freehit kernel: [    0.477366] pnp 00:02: [io 
0x0c50-0x0c52]
Oct  8 17:42:26 freehit kernel: [    0.477408] pnp 00:02: [io 
0x0c6c-0x0c6d]
Oct  8 17:42:26 freehit kernel: [    0.477450] pnp 00:02: [io  0x0c6f]
Oct  8 17:42:26 freehit kernel: [    0.477491] pnp 00:02: [io 
0x0cd0-0x0cd1]
Oct  8 17:42:26 freehit kernel: [    0.477534] pnp 00:02: [io 
0x0cd2-0x0cd3]
Oct  8 17:42:26 freehit kernel: [    0.477576] pnp 00:02: [io 
0x0cd4-0x0cdf]
Oct  8 17:42:26 freehit kernel: [    0.477618] pnp 00:02: [io 
0x4000-0x40fe]
Oct  8 17:42:26 freehit kernel: [    0.477661] pnp 00:02: [io 
0x4210-0x4217]
Oct  8 17:42:26 freehit kernel: [    0.477702] pnp 00:02: [io 
0x0b00-0x0b0f]
Oct  8 17:42:26 freehit kernel: [    0.477744] pnp 00:02: [io 
0x0b10-0x0b1f]
Oct  8 17:42:26 freehit kernel: [    0.477786] pnp 00:02: [io 
0x0b20-0x0b3f]
Oct  8 17:42:26 freehit kernel: [    0.477830] pnp 00:02: [mem 
0x00000000-0x00000fff window]
Oct  8 17:42:26 freehit kernel: [    0.477872] pnp 00:02: [mem 
0xfee00400-0xfee00fff window]
Oct  8 17:42:26 freehit kernel: [    0.477920] pnp 00:02: disabling [mem 
0x00000000-0x00000fff window] because it overlaps 0000:00:00.0 BAR 3 
[mem 0x00000000-0x1fffffff 64bit]
Oct  8 17:42:26 freehit kernel: [    0.478026] pnp 00:02: disabling [mem 
0x00000000-0x00000fff window disabled] because it overlaps 0000:02:00.0 
BAR 6 [mem 0x00000000-0x0000ffff pref]
Oct  8 17:42:26 freehit kernel: [    0.478260] system 00:02: [io 
0x4100-0x411f] has been reserved
Oct  8 17:42:26 freehit kernel: [    0.478306] system 00:02: [io 
0x0228-0x022f] has been reserved
Oct  8 17:42:26 freehit kernel: [    0.478350] system 00:02: [io 
0x040b] has been reserved
Oct  8 17:42:26 freehit kernel: [    0.478393] system 00:02: [io 
0x04d6] has been reserved
Oct  8 17:42:26 freehit kernel: [    0.478437] system 00:02: [io 
0x0c00-0x0c01] has been reserved
Oct  8 17:42:26 freehit kernel: [    0.478481] system 00:02: [io 
0x0c14] has been reserved
Oct  8 17:42:26 freehit kernel: [    0.478525] system 00:02: [io 
0x0c50-0x0c52] has been reserved
Oct  8 17:42:26 freehit kernel: [    0.478568] system 00:02: [io 
0x0c6c-0x0c6d] has been reserved
Oct  8 17:42:26 freehit kernel: [    0.478612] system 00:02: [io 
0x0c6f] has been reserved
Oct  8 17:42:26 freehit kernel: [    0.478656] system 00:02: [io 
0x0cd0-0x0cd1] has been reserved
Oct  8 17:42:26 freehit kernel: [    0.478699] system 00:02: [io 
0x0cd2-0x0cd3] has been reserved
Oct  8 17:42:26 freehit kernel: [    0.478744] system 00:02: [io 
0x0cd4-0x0cdf] has been reserved
Oct  8 17:42:26 freehit kernel: [    0.478788] system 00:02: [io 
0x4000-0x40fe] has been reserved
Oct  8 17:42:26 freehit kernel: [    0.478832] system 00:02: [io 
0x4210-0x4217] has been reserved
Oct  8 17:42:26 freehit kernel: [    0.478875] system 00:02: [io 
0x0b00-0x0b0f] has been reserved
Oct  8 17:42:26 freehit kernel: [    0.478919] system 00:02: [io 
0x0b10-0x0b1f] has been reserved
Oct  8 17:42:26 freehit kernel: [    0.478964] system 00:02: [io 
0x0b20-0x0b3f] has been reserved
Oct  8 17:42:26 freehit kernel: [    0.479023] system 00:02: [mem 
0xfee00400-0xfee00fff window] has been reserved
Oct  8 17:42:26 freehit kernel: [    0.479085] system 00:02: Plug and 
Play ACPI device, IDs PNP0c02 (active)
Oct  8 17:42:26 freehit kernel: [    0.479238] pnp 00:03: [dma 4]
Oct  8 17:42:26 freehit kernel: [    0.479280] pnp 00:03: [io 
0x0000-0x000f]
Oct  8 17:42:26 freehit kernel: [    0.479323] pnp 00:03: [io 
0x0080-0x0090]
Oct  8 17:42:26 freehit kernel: [    0.479365] pnp 00:03: [io 
0x0094-0x009f]
Oct  8 17:42:26 freehit kernel: [    0.479407] pnp 00:03: [io 
0x00c0-0x00df]
Oct  8 17:42:26 freehit kernel: [    0.479611] pnp 00:03: Plug and Play 
ACPI device, IDs PNP0200 (active)
Oct  8 17:42:26 freehit kernel: [    0.479700] pnp 00:04: [irq 0 disabled]
Oct  8 17:42:26 freehit kernel: [    0.479757] pnp 00:04: [irq 8]
Oct  8 17:42:26 freehit kernel: [    0.479800] pnp 00:04: [mem 
0xfed00000-0xfed003ff]
Oct  8 17:42:26 freehit kernel: [    0.479935] pnp 00:04: Plug and Play 
ACPI device, IDs PNP0103 (active)
Oct  8 17:42:26 freehit kernel: [    0.480019] pnp 00:05: [io 
0x0070-0x0073]
Oct  8 17:42:26 freehit kernel: [    0.480156] pnp 00:05: Plug and Play 
ACPI device, IDs PNP0b00 (active)
Oct  8 17:42:26 freehit kernel: [    0.480207] pnp 00:06: [io  0x0061]
Oct  8 17:42:26 freehit kernel: [    0.480341] pnp 00:06: Plug and Play 
ACPI device, IDs PNP0800 (active)
Oct  8 17:42:26 freehit kernel: [    0.480392] pnp 00:07: [io 
0x00f0-0x00ff]
Oct  8 17:42:26 freehit kernel: [    0.480442] pnp 00:07: [irq 13]
Oct  8 17:42:26 freehit kernel: [    0.480577] pnp 00:07: Plug and Play 
ACPI device, IDs PNP0c04 (active)
Oct  8 17:42:26 freehit kernel: [    0.480774] pnp 00:08: [io 
0x03f0-0x03f5]
Oct  8 17:42:26 freehit kernel: [    0.480816] pnp 00:08: [io  0x03f7]
Oct  8 17:42:26 freehit kernel: [    0.480866] pnp 00:08: [irq 6]
Oct  8 17:42:26 freehit kernel: [    0.480907] pnp 00:08: [dma 2]
Oct  8 17:42:26 freehit kernel: [    0.481121] pnp 00:08: Plug and Play 
ACPI device, IDs PNP0700 (active)
Oct  8 17:42:26 freehit kernel: [    0.481318] pnp 00:09: [io 
0x03f8-0x03ff]
Oct  8 17:42:26 freehit kernel: [    0.481367] pnp 00:09: [irq 4]
Oct  8 17:42:26 freehit kernel: [    0.481527] pnp 00:09: Plug and Play 
ACPI device, IDs PNP0501 (active)
Oct  8 17:42:26 freehit kernel: [    0.481737] pnp 00:0a: [io 
0x0378-0x037f]
Oct  8 17:42:26 freehit kernel: [    0.481788] pnp 00:0a: [irq 7]
Oct  8 17:42:26 freehit kernel: [    0.481947] pnp 00:0a: Plug and Play 
ACPI device, IDs PNP0400 (active)
Oct  8 17:42:26 freehit kernel: [    0.482094] pnp 00:0b: [io  0x0060]
Oct  8 17:42:26 freehit kernel: [    0.482136] pnp 00:0b: [io  0x0064]
Oct  8 17:42:26 freehit kernel: [    0.482186] pnp 00:0b: [irq 1]
Oct  8 17:42:26 freehit kernel: [    0.482340] pnp 00:0b: Plug and Play 
ACPI device, IDs PNP0303 (active)
Oct  8 17:42:26 freehit kernel: [    0.482415] pnp 00:0c: [mem 
0xe0000000-0xefffffff]
Oct  8 17:42:26 freehit kernel: [    0.482593] system 00:0c: [mem 
0xe0000000-0xefffffff] has been reserved
Oct  8 17:42:26 freehit kernel: [    0.482640] system 00:0c: Plug and 
Play ACPI device, IDs PNP0c02 (active)
Oct  8 17:42:26 freehit kernel: [    0.482815] pnp 00:0d: [mem 
0x000cea00-0x000cffff]
Oct  8 17:42:26 freehit kernel: [    0.482860] pnp 00:0d: [mem 
0x000f0000-0x000f7fff]
Oct  8 17:42:26 freehit kernel: [    0.482903] pnp 00:0d: [mem 
0x000f8000-0x000fbfff]
Oct  8 17:42:26 freehit kernel: [    0.482947] pnp 00:0d: [mem 
0x000fc000-0x000fffff]
Oct  8 17:42:26 freehit kernel: [    0.482991] pnp 00:0d: [mem 
0xafee0000-0xafefffff]
Oct  8 17:42:26 freehit kernel: [    0.483053] pnp 00:0d: [mem 
0xffff0000-0xffffffff]
Oct  8 17:42:26 freehit kernel: [    0.483098] pnp 00:0d: [mem 
0x00000000-0x0009ffff]
Oct  8 17:42:26 freehit kernel: [    0.483142] pnp 00:0d: [mem 
0x00100000-0xafedffff]
Oct  8 17:42:26 freehit kernel: [    0.483185] pnp 00:0d: [mem 
0xafff0000-0xcffeffff]
Oct  8 17:42:26 freehit kernel: [    0.483229] pnp 00:0d: [mem 
0xfec00000-0xfec00fff]
Oct  8 17:42:26 freehit kernel: [    0.483272] pnp 00:0d: [mem 
0xfee00000-0xfee00fff]
Oct  8 17:42:26 freehit kernel: [    0.483318] pnp 00:0d: [mem 
0xfff80000-0xfffeffff]
Oct  8 17:42:26 freehit kernel: [    0.483363] pnp 00:0d: disabling [mem 
0x000cea00-0x000cffff] because it overlaps 0000:00:00.0 BAR 3 [mem 
0x00000000-0x1fffffff 64bit]
Oct  8 17:42:26 freehit kernel: [    0.483424] pnp 00:0d: disabling [mem 
0x000f0000-0x000f7fff] because it overlaps 0000:00:00.0 BAR 3 [mem 
0x00000000-0x1fffffff 64bit]
Oct  8 17:42:26 freehit kernel: [    0.483485] pnp 00:0d: disabling [mem 
0x000f8000-0x000fbfff] because it overlaps 0000:00:00.0 BAR 3 [mem 
0x00000000-0x1fffffff 64bit]
Oct  8 17:42:26 freehit kernel: [    0.483545] pnp 00:0d: disabling [mem 
0x000fc000-0x000fffff] because it overlaps 0000:00:00.0 BAR 3 [mem 
0x00000000-0x1fffffff 64bit]
Oct  8 17:42:26 freehit kernel: [    0.483605] pnp 00:0d: disabling [mem 
0x00000000-0x0009ffff] because it overlaps 0000:00:00.0 BAR 3 [mem 
0x00000000-0x1fffffff 64bit]
Oct  8 17:42:26 freehit kernel: [    0.483665] pnp 00:0d: disabling [mem 
0x00100000-0xafedffff] because it overlaps 0000:00:00.0 BAR 3 [mem 
0x00000000-0x1fffffff 64bit]
Oct  8 17:42:26 freehit kernel: [    0.483930] system 00:0d: [mem 
0xafee0000-0xafefffff] could not be reserved
Oct  8 17:42:26 freehit kernel: [    0.483976] system 00:0d: [mem 
0xffff0000-0xffffffff] has been reserved
Oct  8 17:42:26 freehit kernel: [    0.484040] system 00:0d: [mem 
0xafff0000-0xcffeffff] could not be reserved
Oct  8 17:42:26 freehit kernel: [    0.484085] system 00:0d: [mem 
0xfec00000-0xfec00fff] could not be reserved
Oct  8 17:42:26 freehit kernel: [    0.484129] system 00:0d: [mem 
0xfee00000-0xfee00fff] could not be reserved
Oct  8 17:42:26 freehit kernel: [    0.484174] system 00:0d: [mem 
0xfff80000-0xfffeffff] has been reserved
Oct  8 17:42:26 freehit kernel: [    0.484220] system 00:0d: Plug and 
Play ACPI device, IDs PNP0c01 (active)
Oct  8 17:42:26 freehit kernel: [    0.484285] pnp: PnP ACPI: found 14 
devices
Oct  8 17:42:26 freehit kernel: [    0.484328] ACPI: ACPI bus type pnp 
unregistered
Oct  8 17:42:26 freehit kernel: [    0.489163] PCI: max bus depth: 1 
pci_try_num: 2
Oct  8 17:42:26 freehit kernel: [    0.489222] pci 0000:00:01.0: PCI 
bridge to [bus 01-01]
Oct  8 17:42:26 freehit kernel: [    0.489266] pci 0000:00:01.0: 
bridge window [io  0xe000-0xefff]
Oct  8 17:42:26 freehit kernel: [    0.489311] pci 0000:00:01.0: 
bridge window [mem 0xfde00000-0xfdffffff]
Oct  8 17:42:26 freehit kernel: [    0.489356] pci 0000:00:01.0: 
bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
Oct  8 17:42:26 freehit kernel: [    0.489419] pci 0000:02:00.0: BAR 6: 
assigned [mem 0xfda00000-0xfda0ffff pref]
Oct  8 17:42:26 freehit kernel: [    0.489477] pci 0000:00:0a.0: PCI 
bridge to [bus 02-02]
Oct  8 17:42:26 freehit kernel: [    0.489909] pci 0000:00:0a.0: 
bridge window [io  0xd000-0xdfff]
Oct  8 17:42:26 freehit kernel: [    0.489954] pci 0000:00:0a.0: 
bridge window [mem 0xfdd00000-0xfddfffff]
Oct  8 17:42:26 freehit kernel: [    0.490014] pci 0000:00:0a.0: 
bridge window [mem 0xfda00000-0xfdafffff 64bit pref]
Oct  8 17:42:26 freehit kernel: [    0.490078] pci 0000:00:14.4: PCI 
bridge to [bus 03-03]
Oct  8 17:42:26 freehit kernel: [    0.490122] pci 0000:00:14.4: 
bridge window [io  0xc000-0xcfff]
Oct  8 17:42:26 freehit kernel: [    0.490169] pci 0000:00:14.4: 
bridge window [mem 0xfdc00000-0xfdcfffff]
Oct  8 17:42:26 freehit kernel: [    0.490216] pci 0000:00:14.4: 
bridge window [mem 0xfdb00000-0xfdbfffff pref]
Oct  8 17:42:26 freehit kernel: [    0.490297] pci 0000:00:0a.0: PCI INT 
A -> GSI 18 (level, low) -> IRQ 18
Oct  8 17:42:26 freehit kernel: [    0.490342] pci 0000:00:0a.0: setting 
latency timer to 64
Oct  8 17:42:26 freehit kernel: [    0.490392] pci_bus 0000:00: resource 
4 [io  0x0000-0x0cf7]
Oct  8 17:42:26 freehit kernel: [    0.490435] pci_bus 0000:00: resource 
5 [io  0x0d00-0xffff]
Oct  8 17:42:26 freehit kernel: [    0.490479] pci_bus 0000:00: resource 
6 [mem 0x000a0000-0x000bffff]
Oct  8 17:42:26 freehit kernel: [    0.490523] pci_bus 0000:00: resource 
7 [mem 0x000c0000-0x000dffff]
Oct  8 17:42:26 freehit kernel: [    0.490566] pci_bus 0000:00: resource 
8 [mem 0xd0000000-0xfebfffff]
Oct  8 17:42:26 freehit kernel: [    0.490611] pci_bus 0000:01: resource 
0 [io  0xe000-0xefff]
Oct  8 17:42:26 freehit kernel: [    0.490654] pci_bus 0000:01: resource 
1 [mem 0xfde00000-0xfdffffff]
Oct  8 17:42:26 freehit kernel: [    0.490698] pci_bus 0000:01: resource 
2 [mem 0xd0000000-0xdfffffff 64bit pref]
Oct  8 17:42:26 freehit kernel: [    0.490756] pci_bus 0000:02: resource 
0 [io  0xd000-0xdfff]
Oct  8 17:42:26 freehit kernel: [    0.490799] pci_bus 0000:02: resource 
1 [mem 0xfdd00000-0xfddfffff]
Oct  8 17:42:26 freehit kernel: [    0.490842] pci_bus 0000:02: resource 
2 [mem 0xfda00000-0xfdafffff 64bit pref]
Oct  8 17:42:26 freehit kernel: [    0.490900] pci_bus 0000:03: resource 
0 [io  0xc000-0xcfff]
Oct  8 17:42:26 freehit kernel: [    0.490943] pci_bus 0000:03: resource 
1 [mem 0xfdc00000-0xfdcfffff]
Oct  8 17:42:26 freehit kernel: [    0.490987] pci_bus 0000:03: resource 
2 [mem 0xfdb00000-0xfdbfffff pref]
Oct  8 17:42:26 freehit kernel: [    0.491046] pci_bus 0000:03: resource 
4 [io  0x0000-0x0cf7]
Oct  8 17:42:26 freehit kernel: [    0.491090] pci_bus 0000:03: resource 
5 [io  0x0d00-0xffff]
Oct  8 17:42:26 freehit kernel: [    0.491134] pci_bus 0000:03: resource 
6 [mem 0x000a0000-0x000bffff]
Oct  8 17:42:26 freehit kernel: [    0.491177] pci_bus 0000:03: resource 
7 [mem 0x000c0000-0x000dffff]
Oct  8 17:42:26 freehit kernel: [    0.491221] pci_bus 0000:03: resource 
8 [mem 0xd0000000-0xfebfffff]
Oct  8 17:42:26 freehit kernel: [    0.491307] NET: Registered protocol 
family 2
Oct  8 17:42:26 freehit kernel: [    0.491598] IP route cache hash table 
entries: 262144 (order: 9, 2097152 bytes)
Oct  8 17:42:26 freehit kernel: [    0.493188] TCP established hash 
table entries: 524288 (order: 11, 8388608 bytes)
Oct  8 17:42:26 freehit kernel: [    0.496993] TCP bind hash table 
entries: 65536 (order: 10, 4194304 bytes)
Oct  8 17:42:26 freehit kernel: [    0.500359] TCP: Hash tables 
configured (established 524288 bind 65536)
Oct  8 17:42:26 freehit kernel: [    0.500439] TCP reno registered
Oct  8 17:42:26 freehit kernel: [    0.500531] UDP hash table entries: 
4096 (order: 7, 655360 bytes)
Oct  8 17:42:26 freehit kernel: [    0.501088] UDP-Lite hash table 
entries: 4096 (order: 7, 655360 bytes)
Oct  8 17:42:26 freehit kernel: [    0.501733] NET: Registered protocol 
family 1
Oct  8 17:42:26 freehit kernel: [    0.502092] RPC: Registered named 
UNIX socket transport module.
Oct  8 17:42:26 freehit kernel: [    0.502136] RPC: Registered udp 
transport module.
Oct  8 17:42:26 freehit kernel: [    0.502178] RPC: Registered tcp 
transport module.
Oct  8 17:42:26 freehit kernel: [    0.502220] RPC: Registered tcp 
NFSv4.1 backchannel transport module.
Oct  8 17:42:26 freehit kernel: [    0.502271] pci 0000:00:01.0: MSI 
quirk detected; subordinate MSI disabled
Oct  8 17:42:26 freehit kernel: [    0.608085] pci 0000:01:05.0: Boot 
video device
Oct  8 17:42:26 freehit kernel: [    0.608144] PCI: CLS 4 bytes, default 64
Oct  8 17:42:26 freehit kernel: [    0.610578] PCI-DMA: Disabling AGP.
Oct  8 17:42:26 freehit kernel: [    0.610753] PCI-DMA: aperture base @ 
a4000000 size 65536 KB
Oct  8 17:42:26 freehit kernel: [    0.610798] PCI-DMA: using GART IOMMU.
Oct  8 17:42:26 freehit kernel: [    0.610841] PCI-DMA: Reserving 64MB 
of IOMMU area in the AGP aperture
Oct  8 17:42:26 freehit kernel: [    0.615115] kvm: Nested 
Virtualization enabled
Oct  8 17:42:26 freehit kernel: [    0.615168] kvm: Nested Paging enabled
Oct  8 17:42:26 freehit kernel: [    0.618622] microcode: CPU0: 
patch_level=0x01000086
Oct  8 17:42:26 freehit kernel: [    0.618678] microcode: CPU1: 
patch_level=0x01000086
Oct  8 17:42:26 freehit kernel: [    0.618748] microcode: CPU2: 
patch_level=0x01000086
Oct  8 17:42:26 freehit kernel: [    0.618800] microcode: CPU3: 
patch_level=0x01000086
Oct  8 17:42:26 freehit kernel: [    0.618925] microcode: Microcode 
Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Oct  8 17:42:26 freehit kernel: [    0.619453] audit: initializing 
netlink socket (disabled)
Oct  8 17:42:26 freehit kernel: [    0.619549] type=2000 
audit(1318075875.618:1): initialized
Oct  8 17:42:26 freehit kernel: [    0.653967] HugeTLB registered 2 MB 
page size, pre-allocated 0 pages
Oct  8 17:42:26 freehit kernel: [    0.660640] VFS: Disk quotas dquot_6.5.2
Oct  8 17:42:26 freehit kernel: [    0.660822] Dquot-cache hash table 
entries: 512 (order 0, 4096 bytes)
Oct  8 17:42:26 freehit kernel: [    0.662999] msgmni has been set to 10921
Oct  8 17:42:26 freehit kernel: [    0.663321] SELinux:  Registering 
netfilter hooks
Oct  8 17:42:26 freehit kernel: [    0.664388] Block layer SCSI generic 
(bsg) driver version 0.4 loaded (major 253)
Oct  8 17:42:26 freehit kernel: [    0.664459] io scheduler noop registered
Oct  8 17:42:26 freehit kernel: [    0.664501] io scheduler deadline 
registered
Oct  8 17:42:26 freehit kernel: [    0.664644] io scheduler cfq 
registered (default)
Oct  8 17:42:26 freehit kernel: [    0.664686] start plist test
Oct  8 17:42:26 freehit kernel: [    0.665500] end plist test
Oct  8 17:42:26 freehit kernel: [    0.665881] pcieport 0000:00:0a.0: 
setting latency timer to 64
Oct  8 17:42:26 freehit kernel: [    0.665968] pcieport 0000:00:0a.0: 
irq 40 for MSI/MSI-X
Oct  8 17:42:26 freehit kernel: [    0.666415] pci_hotplug: PCI Hot Plug 
PCI Core version: 0.5
Oct  8 17:42:26 freehit kernel: [    0.666577] Serial: 8250/16550 
driver, 4 ports, IRQ sharing enabled
Oct  8 17:42:26 freehit kernel: [    0.931200] serial8250: ttyS0 at I/O 
0x3f8 (irq = 4) is a 16550A
Oct  8 17:42:26 freehit kernel: [    1.009402] 00:09: ttyS0 at I/O 0x3f8 
(irq = 4) is a 16550A
Oct  8 17:42:26 freehit kernel: [    1.019710] Non-volatile memory 
driver v1.3
Oct  8 17:42:26 freehit kernel: [    1.019755] Linux agpgart interface 
v0.103
Oct  8 17:42:26 freehit kernel: [    1.020370] input: Power Button as 
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
Oct  8 17:42:26 freehit kernel: [    1.020461] ACPI: Power Button [PWRB]
Oct  8 17:42:26 freehit kernel: [    1.020618] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
Oct  8 17:42:26 freehit kernel: [    1.020677] ACPI: Power Button [PWRF]
Oct  8 17:42:26 freehit kernel: [    1.020965] ACPI: acpi_idle 
registered with cpuidle
Oct  8 17:42:26 freehit kernel: [    1.083346] [drm] Initialized drm 
1.1.0 20060810
Oct  8 17:42:26 freehit kernel: [    1.083525] [drm] radeon defaulting 
to kernel modesetting.
Oct  8 17:42:26 freehit kernel: [    1.083571] [drm] radeon kernel 
modesetting enabled.
Oct  8 17:42:26 freehit kernel: [    1.083743] radeon 0000:01:05.0: PCI 
INT A -> GSI 18 (level, low) -> IRQ 18
Oct  8 17:42:26 freehit kernel: [    1.083793] radeon 0000:01:05.0: 
setting latency timer to 64
Oct  8 17:42:26 freehit kernel: [    1.084361] [drm] initializing kernel 
modesetting (RS780 0x1002:0x9614 0x1458:0xD000).
Oct  8 17:42:26 freehit kernel: [    1.084475] [drm] register mmio base: 
0xFDFE0000
Oct  8 17:42:26 freehit kernel: [    1.084517] [drm] register mmio size: 
65536
Oct  8 17:42:26 freehit kernel: [    1.084942] ATOM BIOS: B27721
Oct  8 17:42:26 freehit kernel: [    1.085055] radeon 0000:01:05.0: 
VRAM: 640M 0x00000000C0000000 - 0x00000000E7FFFFFF (640M used)
Oct  8 17:42:26 freehit kernel: [    1.085113] radeon 0000:01:05.0: GTT: 
512M 0x00000000A0000000 - 0x00000000BFFFFFFF
Oct  8 17:42:26 freehit kernel: [    1.087971] [drm] Detected VRAM 
RAM=640M, BAR=256M
Oct  8 17:42:26 freehit kernel: [    1.088048] [drm] RAM width 32bits DDR
Oct  8 17:42:26 freehit kernel: [    1.088306] [TTM] Zone  kernel: 
Available graphics memory: 2795990 kiB.
Oct  8 17:42:26 freehit kernel: [    1.088350] [TTM] Zone   dma32: 
Available graphics memory: 2097152 kiB.
Oct  8 17:42:26 freehit kernel: [    1.088393] [TTM] Initializing pool 
allocator.
Oct  8 17:42:26 freehit kernel: [    1.088667] [drm] radeon: 640M of 
VRAM memory ready
Oct  8 17:42:26 freehit kernel: [    1.088710] [drm] radeon: 512M of GTT 
memory ready.
Oct  8 17:42:26 freehit kernel: [    1.088812] [drm] Supports vblank 
timestamp caching Rev 1 (10.10.2010).
Oct  8 17:42:26 freehit kernel: [    1.088855] [drm] Driver supports 
precise vblank timestamp query.
Oct  8 17:42:26 freehit kernel: [    1.088945] [drm] radeon: irq 
initialized.
Oct  8 17:42:26 freehit kernel: [    1.088990] [drm] GART: num cpu pages 
131072, num gpu pages 131072
Oct  8 17:42:26 freehit kernel: [    1.089917] [drm] Loading RS780 Microcode
Oct  8 17:42:26 freehit kernel: [    1.616162] Refined TSC clocksource 
calibration: 3006.401 MHz.
Oct  8 17:42:26 freehit kernel: [    1.616228] Switching to clocksource tsc
Oct  8 17:42:26 freehit kernel: [   61.920413] r600_cp: Failed to load 
firmware "radeon/R600_rlc.bin"
Oct  8 17:42:26 freehit kernel: [   61.920460] [drm:r600_startup] 
*ERROR* Failed to load firmware!
Oct  8 17:42:26 freehit kernel: [   61.920504] radeon 0000:01:05.0: 
disabling GPU acceleration
Oct  8 17:42:26 freehit kernel: [   61.921650] radeon 0000:01:05.0: 
ffff8801a8847400 unpin not necessary
Oct  8 17:42:26 freehit kernel: [   61.921695] radeon 0000:01:05.0: 
ffff8801a8847400 unpin not necessary
Oct  8 17:42:26 freehit kernel: [   61.921900] failed to evaluate ATIF 
got AE_BAD_PARAMETER
Oct  8 17:42:26 freehit kernel: [   61.922659] [drm] Radeon Display 
Connectors
Oct  8 17:42:26 freehit kernel: [   61.922702] [drm] Connector 0:
Oct  8 17:42:26 freehit kernel: [   61.922743] [drm]   VGA
Oct  8 17:42:26 freehit kernel: [   61.922786] [drm]   DDC: 0x7e40 
0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
Oct  8 17:42:26 freehit kernel: [   61.922842] [drm]   Encoders:
Oct  8 17:42:26 freehit kernel: [   61.922883] [drm]     CRT1: 
INTERNAL_KLDSCP_DAC1
Oct  8 17:42:26 freehit kernel: [   61.922926] [drm] Connector 1:
Oct  8 17:42:26 freehit kernel: [   61.922968] [drm]   HDMI-A
Oct  8 17:42:26 freehit kernel: [   61.923016] [drm]   HPD1
Oct  8 17:42:26 freehit kernel: [   61.923058] [drm]   DDC: 0x7e50 
0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
Oct  8 17:42:26 freehit kernel: [   61.923114] [drm]   Encoders:
Oct  8 17:42:26 freehit kernel: [   61.923156] [drm]     DFP1: 
INTERNAL_KLDSCP_LVTMA
Oct  8 17:42:26 freehit kernel: [   61.932862] [drm] Radeon display 
connector VGA-1: No monitor connected or invalid EDID
Oct  8 17:42:26 freehit kernel: [   62.035066] [drm] Radeon display 
connector HDMI-A-1: Found valid EDID
Oct  8 17:42:26 freehit kernel: [   62.035183] [drm] radeon: power 
management initialized
Oct  8 17:42:26 freehit kernel: [   62.165830] [drm] fb mappable at 
0xD0040000
Oct  8 17:42:26 freehit kernel: [   62.165874] [drm] vram apper at 
0xD0000000
Oct  8 17:42:26 freehit kernel: [   62.165916] [drm] size 8294400
Oct  8 17:42:26 freehit kernel: [   62.165957] [drm] fb depth is 24
Oct  8 17:42:26 freehit kernel: [   62.165998] [drm]    pitch is 7680
Oct  8 17:42:26 freehit kernel: [   62.166341] fbcon: radeondrmfb (fb0) 
is primary device
Oct  8 17:42:26 freehit kernel: [   62.184368] Console: switching to 
colour frame buffer device 240x67
Oct  8 17:42:26 freehit kernel: [   62.189544] fb0: radeondrmfb frame 
buffer device
Oct  8 17:42:26 freehit kernel: [   62.189566] drm: registered panic 
notifier
Oct  8 17:42:26 freehit kernel: [   62.189599] [drm] Initialized radeon 
2.10.0 20080528 for 0000:01:05.0 on minor 0
Oct  8 17:42:26 freehit kernel: [   62.189646] work_for_cpu used 
greatest stack depth: 3416 bytes left
Oct  8 17:42:26 freehit kernel: [   62.192536] brd: module loaded
Oct  8 17:42:26 freehit kernel: [   62.193845] loop: module loaded
Oct  8 17:42:26 freehit kernel: [   62.194355] ahci 0000:00:11.0: 
version 3.0
Oct  8 17:42:26 freehit kernel: [   62.194407] ahci 0000:00:11.0: PCI 
INT A -> GSI 22 (level, low) -> IRQ 22
Oct  8 17:42:26 freehit kernel: [   62.194558] ahci 0000:00:11.0: AHCI 
0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
Oct  8 17:42:26 freehit kernel: [   62.194596] ahci 0000:00:11.0: flags: 
64bit ncq sntf ilck pm led clo pmp pio slum part ccc
Oct  8 17:42:26 freehit kernel: [   62.195947] scsi0 : ahci
Oct  8 17:42:26 freehit kernel: [   62.196233] scsi1 : ahci
Oct  8 17:42:26 freehit kernel: [   62.196417] scsi2 : ahci
Oct  8 17:42:26 freehit kernel: [   62.196593] scsi3 : ahci
Oct  8 17:42:26 freehit kernel: [   62.196847] ata1: SATA max UDMA/133 
abar m1024@0xfe02f000 port 0xfe02f100 irq 22
Oct  8 17:42:26 freehit kernel: [   62.196882] ata2: SATA max UDMA/133 
abar m1024@0xfe02f000 port 0xfe02f180 irq 22
Oct  8 17:42:26 freehit kernel: [   62.196917] ata3: SATA max UDMA/133 
abar m1024@0xfe02f000 port 0xfe02f200 irq 22
Oct  8 17:42:26 freehit kernel: [   62.196951] ata4: SATA max UDMA/133 
abar m1024@0xfe02f000 port 0xfe02f280 irq 22
Oct  8 17:42:26 freehit kernel: [   62.197525] e1000: Intel(R) PRO/1000 
Network Driver - version 7.3.21-k8-NAPI
Oct  8 17:42:26 freehit kernel: [   62.197562] e1000: Copyright (c) 
1999-2006 Intel Corporation.
Oct  8 17:42:26 freehit kernel: [   62.197654] e100: Intel(R) PRO/100 
Network Driver, 3.5.24-k2-NAPI
Oct  8 17:42:26 freehit kernel: [   62.197682] e100: Copyright(c) 
1999-2006 Intel Corporation
Oct  8 17:42:26 freehit kernel: [   62.197842] sky2: driver version 1.28
Oct  8 17:42:26 freehit kernel: [   62.198116] r8169 Gigabit Ethernet 
driver 2.3LK-NAPI loaded
Oct  8 17:42:26 freehit kernel: [   62.198160] r8169 0000:02:00.0: PCI 
INT A -> GSI 18 (level, low) -> IRQ 18
Oct  8 17:42:26 freehit kernel: [   62.198219] r8169 0000:02:00.0: 
setting latency timer to 64
Oct  8 17:42:26 freehit kernel: [   62.198291] r8169 0000:02:00.0: irq 
41 for MSI/MSI-X
Oct  8 17:42:26 freehit kernel: [   62.198844] r8169 0000:02:00.0: eth0: 
RTL8168c/8111c at 0xffffc90000c1a000, 00:1f:d0:ae:b2:ae, XID 1c4000c0 IRQ 41
Oct  8 17:42:26 freehit kernel: [   62.199046] console [netcon0] enabled
Oct  8 17:42:26 freehit kernel: [   62.199067] netconsole: network 
logging started
Oct  8 17:42:26 freehit kernel: [   62.199499] ehci_hcd: USB 2.0 
'Enhanced' Host Controller (EHCI) Driver
Oct  8 17:42:26 freehit kernel: [   62.199530] ehci_hcd: block sizes: qh 
112 qtd 96 itd 192 sitd 96
Oct  8 17:42:26 freehit kernel: [   62.199643] ehci_hcd 0000:00:12.2: 
PCI INT B -> GSI 17 (level, low) -> IRQ 17
Oct  8 17:42:26 freehit kernel: [   62.199696] ehci_hcd 0000:00:12.2: 
EHCI Host Controller
Oct  8 17:42:26 freehit kernel: [   62.199911] drivers/usb/core/inode.c: 
creating file 'devices'
Oct  8 17:42:26 freehit kernel: [   62.199985] drivers/usb/core/inode.c: 
creating file '001'
Oct  8 17:42:26 freehit kernel: [   62.200259] ehci_hcd 0000:00:12.2: 
new USB bus registered, assigned bus number 1
Oct  8 17:42:26 freehit kernel: [   62.200300] ehci_hcd 0000:00:12.2: 
reset hcs_params 0x102306 dbg=1 cc=2 pcc=3 ordered !ppc ports=6
Oct  8 17:42:26 freehit kernel: [   62.200342] ehci_hcd 0000:00:12.2: 
reset hcc_params a072 thresh 7 uframes 256/512/1024
Oct  8 17:42:26 freehit kernel: [   62.200379] ehci_hcd 0000:00:12.2: 
applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
Oct  8 17:42:26 freehit kernel: [   62.200467] QUIRK: Enable AMD PLL fix
Oct  8 17:42:26 freehit kernel: [   62.200488] ehci_hcd 0000:00:12.2: 
applying AMD SB600/SB700 USB freeze workaround
Oct  8 17:42:26 freehit kernel: [   62.201698] ehci_hcd 0000:00:12.2: 
debug port 1
Oct  8 17:42:26 freehit kernel: [   62.202880] ehci_hcd 0000:00:12.2: 
reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
Oct  8 17:42:26 freehit kernel: [   62.204151] ehci_hcd 0000:00:12.2: 
MWI active
Oct  8 17:42:26 freehit kernel: [   62.205406] ehci_hcd 0000:00:12.2: 
supports USB remote wakeup
Oct  8 17:42:26 freehit kernel: [   62.206720] ehci_hcd 0000:00:12.2: 
irq 17, io mem 0xfe02c000
Oct  8 17:42:26 freehit kernel: [   62.207933] ehci_hcd 0000:00:12.2: 
reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
Oct  8 17:42:26 freehit kernel: [   62.209163] ehci_hcd 0000:00:12.2: 
init command 0010005 (park)=0 ithresh=1 period=512 RUN
Oct  8 17:42:26 freehit kernel: [   62.216037] ehci_hcd 0000:00:12.2: 
USB 2.0 started, EHCI 1.00
Oct  8 17:42:26 freehit kernel: [   62.217382] usb usb1: default 
language 0x0409
Oct  8 17:42:26 freehit kernel: [   62.218612] usb usb1: udev 1, busnum 
1, minor = 0
Oct  8 17:42:26 freehit kernel: [   62.219820] usb usb1: New USB device 
found, idVendor=1d6b, idProduct=0002
Oct  8 17:42:26 freehit kernel: [   62.221061] usb usb1: New USB device 
strings: Mfr=3, Product=2, SerialNumber=1
Oct  8 17:42:26 freehit kernel: [   62.222285] usb usb1: Product: EHCI 
Host Controller
Oct  8 17:42:26 freehit kernel: [   62.223465] usb usb1: Manufacturer: 
Linux 3.0.4-gentoo-r2 ehci_hcd
Oct  8 17:42:26 freehit kernel: [   62.224643] usb usb1: SerialNumber: 
0000:00:12.2
Oct  8 17:42:26 freehit kernel: [   62.226093] usb usb1: usb_probe_device
Oct  8 17:42:26 freehit kernel: [   62.227274] usb usb1: configuration 
#1 chosen from 1 choice
Oct  8 17:42:26 freehit kernel: [   62.228556] usb usb1: adding 1-0:1.0 
(config #1, interface 0)
Oct  8 17:42:26 freehit kernel: [   62.229953] hub 1-0:1.0: 
usb_probe_interface
Oct  8 17:42:26 freehit kernel: [   62.231136] hub 1-0:1.0: 
usb_probe_interface - got id
Oct  8 17:42:26 freehit kernel: [   62.232284] hub 1-0:1.0: USB hub found
Oct  8 17:42:26 freehit kernel: [   62.233448] hub 1-0:1.0: 6 ports detected
Oct  8 17:42:26 freehit kernel: [   62.234576] hub 1-0:1.0: standalone hub
Oct  8 17:42:26 freehit kernel: [   62.235683] hub 1-0:1.0: no power 
switching (usb 1.0)
Oct  8 17:42:26 freehit kernel: [   62.236792] hub 1-0:1.0: individual 
port over-current protection
Oct  8 17:42:26 freehit kernel: [   62.237911] hub 1-0:1.0: power on to 
power good time: 20ms
Oct  8 17:42:26 freehit kernel: [   62.239083] hub 1-0:1.0: local power 
source is good
Oct  8 17:42:26 freehit kernel: [   62.240191] hub 1-0:1.0: trying to 
enable port power on non-switchable hub
Oct  8 17:42:26 freehit kernel: [   62.241370] drivers/usb/core/inode.c: 
creating file '001'
Oct  8 17:42:26 freehit kernel: [   62.242685] ehci_hcd 0000:00:13.2: 
PCI INT B -> GSI 19 (level, low) -> IRQ 19
Oct  8 17:42:26 freehit kernel: [   62.243819] ehci_hcd 0000:00:13.2: 
EHCI Host Controller
Oct  8 17:42:26 freehit kernel: [   62.244953] drivers/usb/core/inode.c: 
creating file '002'
Oct  8 17:42:26 freehit kernel: [   62.246225] ehci_hcd 0000:00:13.2: 
new USB bus registered, assigned bus number 2
Oct  8 17:42:26 freehit kernel: [   62.247404] ehci_hcd 0000:00:13.2: 
reset hcs_params 0x102306 dbg=1 cc=2 pcc=3 ordered !ppc ports=6
Oct  8 17:42:26 freehit kernel: [   62.248580] ehci_hcd 0000:00:13.2: 
reset hcc_params a072 thresh 7 uframes 256/512/1024
Oct  8 17:42:26 freehit kernel: [   62.249768] ehci_hcd 0000:00:13.2: 
applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
Oct  8 17:42:26 freehit kernel: [   62.250991] ehci_hcd 0000:00:13.2: 
applying AMD SB600/SB700 USB freeze workaround
Oct  8 17:42:26 freehit kernel: [   62.252223] ehci_hcd 0000:00:13.2: 
debug port 1
Oct  8 17:42:26 freehit kernel: [   62.253424] ehci_hcd 0000:00:13.2: 
reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
Oct  8 17:42:26 freehit kernel: [   62.254654] ehci_hcd 0000:00:13.2: 
MWI active
Oct  8 17:42:26 freehit kernel: [   62.255854] ehci_hcd 0000:00:13.2: 
supports USB remote wakeup
Oct  8 17:42:26 freehit kernel: [   62.257077] ehci_hcd 0000:00:13.2: 
irq 19, io mem 0xfe029000
Oct  8 17:42:26 freehit kernel: [   62.258275] ehci_hcd 0000:00:13.2: 
reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
Oct  8 17:42:26 freehit kernel: [   62.259491] ehci_hcd 0000:00:13.2: 
init command 0010005 (park)=0 ithresh=1 period=512 RUN
Oct  8 17:42:26 freehit kernel: [   62.266030] ehci_hcd 0000:00:13.2: 
USB 2.0 started, EHCI 1.00
Oct  8 17:42:26 freehit kernel: [   62.267290] usb usb2: default 
language 0x0409
Oct  8 17:42:26 freehit kernel: [   62.268508] usb usb2: udev 1, busnum 
2, minor = 128
Oct  8 17:42:26 freehit kernel: [   62.269705] usb usb2: New USB device 
found, idVendor=1d6b, idProduct=0002
Oct  8 17:42:26 freehit kernel: [   62.270901] usb usb2: New USB device 
strings: Mfr=3, Product=2, SerialNumber=1
Oct  8 17:42:26 freehit kernel: [   62.272093] usb usb2: Product: EHCI 
Host Controller
Oct  8 17:42:26 freehit kernel: [   62.273266] usb usb2: Manufacturer: 
Linux 3.0.4-gentoo-r2 ehci_hcd
Oct  8 17:42:26 freehit kernel: [   62.274455] usb usb2: SerialNumber: 
0000:00:13.2
Oct  8 17:42:26 freehit kernel: [   62.275781] usb usb2: usb_probe_device
Oct  8 17:42:26 freehit kernel: [   62.276952] usb usb2: configuration 
#1 chosen from 1 choice
Oct  8 17:42:26 freehit kernel: [   62.278132] usb usb2: adding 2-0:1.0 
(config #1, interface 0)
Oct  8 17:42:26 freehit kernel: [   62.279428] hub 2-0:1.0: 
usb_probe_interface
Oct  8 17:42:26 freehit kernel: [   62.280600] hub 2-0:1.0: 
usb_probe_interface - got id
Oct  8 17:42:26 freehit kernel: [   62.281755] hub 2-0:1.0: USB hub found
Oct  8 17:42:26 freehit kernel: [   62.282905] hub 2-0:1.0: 6 ports detected
Oct  8 17:42:26 freehit kernel: [   62.284035] hub 2-0:1.0: standalone hub
Oct  8 17:42:26 freehit kernel: [   62.285140] hub 2-0:1.0: no power 
switching (usb 1.0)
Oct  8 17:42:26 freehit kernel: [   62.286245] hub 2-0:1.0: individual 
port over-current protection
Oct  8 17:42:26 freehit kernel: [   62.287348] hub 2-0:1.0: power on to 
power good time: 20ms
Oct  8 17:42:26 freehit kernel: [   62.288447] hub 2-0:1.0: local power 
source is good
Oct  8 17:42:26 freehit kernel: [   62.289529] hub 2-0:1.0: trying to 
enable port power on non-switchable hub
Oct  8 17:42:26 freehit kernel: [   62.290664] drivers/usb/core/inode.c: 
creating file '001'
Oct  8 17:42:26 freehit kernel: [   62.291966] ohci_hcd: USB 1.1 'Open' 
Host Controller (OHCI) Driver
Oct  8 17:42:26 freehit kernel: [   62.293111] ohci_hcd: block sizes: ed 
80 td 96
Oct  8 17:42:26 freehit kernel: [   62.294298] ohci_hcd 0000:00:12.0: 
PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct  8 17:42:26 freehit kernel: [   62.295451] ohci_hcd 0000:00:12.0: 
OHCI Host Controller
Oct  8 17:42:26 freehit kernel: [   62.296550] drivers/usb/core/inode.c: 
creating file '003'
Oct  8 17:42:26 freehit kernel: [   62.297813] ohci_hcd 0000:00:12.0: 
new USB bus registered, assigned bus number 3
Oct  8 17:42:26 freehit kernel: [   62.298957] ohci_hcd 0000:00:12.0: 
created debug files
Oct  8 17:42:26 freehit kernel: [   62.300062] ohci_hcd 0000:00:12.0: 
supports USB remote wakeup
Oct  8 17:42:26 freehit kernel: [   62.301181] ohci_hcd 0000:00:12.0: 
irq 16, io mem 0xfe02e000
Oct  8 17:42:26 freehit kernel: [   62.341160] hub 1-0:1.0: state 7 
ports 6 chg 0000 evt 0000
Oct  8 17:42:26 freehit kernel: [   62.357062] ohci_hcd 0000:00:12.0: 
OHCI controller state
Oct  8 17:42:26 freehit kernel: [   62.358190] ohci_hcd 0000:00:12.0: 
OHCI 1.0, NO legacy support registers
Oct  8 17:42:26 freehit kernel: [   62.359294] ohci_hcd 0000:00:12.0: 
control 0x283 RWC HCFS=operational CBSR=3
Oct  8 17:42:26 freehit kernel: [   62.360397] ohci_hcd 0000:00:12.0: 
cmdstatus 0x00000 SOC=0
Oct  8 17:42:26 freehit kernel: [   62.361493] ohci_hcd 0000:00:12.0: 
intrstatus 0x00000004 SF
Oct  8 17:42:26 freehit kernel: [   62.362590] ohci_hcd 0000:00:12.0: 
intrenable 0x8000005a MIE RHSC UE RD WDH
Oct  8 17:42:26 freehit kernel: [   62.363700] ohci_hcd 0000:00:12.0: 
hcca frame #000b
Oct  8 17:42:26 freehit kernel: [   62.364805] ohci_hcd 0000:00:12.0: 
roothub.a 02000203 POTPGT=2 NPS NDP=3(3)
Oct  8 17:42:26 freehit kernel: [   62.365925] ohci_hcd 0000:00:12.0: 
roothub.b 00000000 PPCM=0000 DR=0000
Oct  8 17:42:26 freehit kernel: [   62.367096] ohci_hcd 0000:00:12.0: 
roothub.status 00008000 DRWE
Oct  8 17:42:26 freehit kernel: [   62.368209] ohci_hcd 0000:00:12.0: 
roothub.portstatus [0] 0x00000100 PPS
Oct  8 17:42:26 freehit kernel: [   62.369315] ohci_hcd 0000:00:12.0: 
roothub.portstatus [1] 0x00000100 PPS
Oct  8 17:42:26 freehit kernel: [   62.370412] ohci_hcd 0000:00:12.0: 
roothub.portstatus [2] 0x00000100 PPS
Oct  8 17:42:26 freehit kernel: [   62.371535] usb usb3: default 
language 0x0409
Oct  8 17:42:26 freehit kernel: [   62.372614] usb usb3: udev 1, busnum 
3, minor = 256
Oct  8 17:42:26 freehit kernel: [   62.373676] usb usb3: New USB device 
found, idVendor=1d6b, idProduct=0001
Oct  8 17:42:26 freehit kernel: [   62.374748] usb usb3: New USB device 
strings: Mfr=3, Product=2, SerialNumber=1
Oct  8 17:42:26 freehit kernel: [   62.375824] usb usb3: Product: OHCI 
Host Controller
Oct  8 17:42:26 freehit kernel: [   62.376884] usb usb3: Manufacturer: 
Linux 3.0.4-gentoo-r2 ohci_hcd
Oct  8 17:42:26 freehit kernel: [   62.377939] usb usb3: SerialNumber: 
0000:00:12.0
Oct  8 17:42:26 freehit kernel: [   62.379151] usb usb3: usb_probe_device
Oct  8 17:42:26 freehit kernel: [   62.380189] usb usb3: configuration 
#1 chosen from 1 choice
Oct  8 17:42:26 freehit kernel: [   62.381235] usb usb3: adding 3-0:1.0 
(config #1, interface 0)
Oct  8 17:42:26 freehit kernel: [   62.382384] hub 3-0:1.0: 
usb_probe_interface
Oct  8 17:42:26 freehit kernel: [   62.383415] hub 3-0:1.0: 
usb_probe_interface - got id
Oct  8 17:42:26 freehit kernel: [   62.384429] hub 3-0:1.0: USB hub found
Oct  8 17:42:26 freehit kernel: [   62.385448] hub 3-0:1.0: 3 ports detected
Oct  8 17:42:26 freehit kernel: [   62.386457] hub 3-0:1.0: standalone hub
Oct  8 17:42:26 freehit kernel: [   62.387447] hub 3-0:1.0: no power 
switching (usb 1.0)
Oct  8 17:42:26 freehit kernel: [   62.388436] hub 3-0:1.0: global 
over-current protection
Oct  8 17:42:26 freehit kernel: [   62.389416] hub 3-0:1.0: power on to 
power good time: 4ms
Oct  8 17:42:26 freehit kernel: [   62.390427] hub 3-0:1.0: local power 
source is good
Oct  8 17:42:26 freehit kernel: [   62.390437] hub 2-0:1.0: state 7 
ports 6 chg 0000 evt 0000
Oct  8 17:42:26 freehit kernel: [   62.392366] hub 3-0:1.0: no 
over-current condition exists
Oct  8 17:42:26 freehit kernel: [   62.393334] hub 3-0:1.0: trying to 
enable port power on non-switchable hub
Oct  8 17:42:26 freehit kernel: [   62.394324] drivers/usb/core/inode.c: 
creating file '001'
Oct  8 17:42:26 freehit kernel: [   62.395335] ehci_hcd 0000:00:12.2: HS 
companion for 0000:00:12.0
Oct  8 17:42:26 freehit kernel: [   62.396416] ohci_hcd 0000:00:12.1: 
PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct  8 17:42:26 freehit kernel: [   62.397416] ohci_hcd 0000:00:12.1: 
OHCI Host Controller
Oct  8 17:42:26 freehit kernel: [   62.398402] drivers/usb/core/inode.c: 
creating file '004'
Oct  8 17:42:26 freehit kernel: [   62.399527] ohci_hcd 0000:00:12.1: 
new USB bus registered, assigned bus number 4
Oct  8 17:42:26 freehit kernel: [   62.400566] ohci_hcd 0000:00:12.1: 
created debug files
Oct  8 17:42:26 freehit kernel: [   62.401566] ohci_hcd 0000:00:12.1: 
supports USB remote wakeup
Oct  8 17:42:26 freehit kernel: [   62.402569] ohci_hcd 0000:00:12.1: 
irq 16, io mem 0xfe02d000
Oct  8 17:42:26 freehit kernel: [   62.458115] ohci_hcd 0000:00:12.1: 
OHCI controller state
Oct  8 17:42:26 freehit kernel: [   62.459128] ohci_hcd 0000:00:12.1: 
OHCI 1.0, NO legacy support registers
Oct  8 17:42:26 freehit kernel: [   62.460140] ohci_hcd 0000:00:12.1: 
control 0x283 RWC HCFS=operational CBSR=3
Oct  8 17:42:26 freehit kernel: [   62.461156] ohci_hcd 0000:00:12.1: 
cmdstatus 0x00000 SOC=0
Oct  8 17:42:26 freehit kernel: [   62.462166] ohci_hcd 0000:00:12.1: 
intrstatus 0x00000004 SF
Oct  8 17:42:26 freehit kernel: [   62.463172] ohci_hcd 0000:00:12.1: 
intrenable 0x8000005a MIE RHSC UE RD WDH
Oct  8 17:42:26 freehit kernel: [   62.464183] ohci_hcd 0000:00:12.1: 
hcca frame #000b
Oct  8 17:42:26 freehit kernel: [   62.465167] ohci_hcd 0000:00:12.1: 
roothub.a 02000203 POTPGT=2 NPS NDP=3(3)
Oct  8 17:42:26 freehit kernel: [   62.466159] ohci_hcd 0000:00:12.1: 
roothub.b 00000000 PPCM=0000 DR=0000
Oct  8 17:42:26 freehit kernel: [   62.467143] ohci_hcd 0000:00:12.1: 
roothub.status 00008000 DRWE
Oct  8 17:42:26 freehit kernel: [   62.468115] ohci_hcd 0000:00:12.1: 
roothub.portstatus [0] 0x00000100 PPS
Oct  8 17:42:26 freehit kernel: [   62.469083] ohci_hcd 0000:00:12.1: 
roothub.portstatus [1] 0x00000100 PPS
Oct  8 17:42:26 freehit kernel: [   62.470039] ohci_hcd 0000:00:12.1: 
roothub.portstatus [2] 0x00000100 PPS
Oct  8 17:42:26 freehit kernel: [   62.470975] usb usb4: default 
language 0x0409
Oct  8 17:42:26 freehit kernel: [   62.471912] usb usb4: udev 1, busnum 
4, minor = 384
Oct  8 17:42:26 freehit kernel: [   62.472834] usb usb4: New USB device 
found, idVendor=1d6b, idProduct=0001
Oct  8 17:42:26 freehit kernel: [   62.473782] usb usb4: New USB device 
strings: Mfr=3, Product=2, SerialNumber=1
Oct  8 17:42:26 freehit kernel: [   62.474730] usb usb4: Product: OHCI 
Host Controller
Oct  8 17:42:26 freehit kernel: [   62.475667] usb usb4: Manufacturer: 
Linux 3.0.4-gentoo-r2 ohci_hcd
Oct  8 17:42:26 freehit kernel: [   62.476612] usb usb4: SerialNumber: 
0000:00:12.1
Oct  8 17:42:26 freehit kernel: [   62.477707] usb usb4: usb_probe_device
Oct  8 17:42:26 freehit kernel: [   62.478644] usb usb4: configuration 
#1 chosen from 1 choice
Oct  8 17:42:26 freehit kernel: [   62.479597] usb usb4: adding 4-0:1.0 
(config #1, interface 0)
Oct  8 17:42:26 freehit kernel: [   62.480663] hub 4-0:1.0: 
usb_probe_interface
Oct  8 17:42:26 freehit kernel: [   62.481611] hub 4-0:1.0: 
usb_probe_interface - got id
Oct  8 17:42:26 freehit kernel: [   62.482553] hub 4-0:1.0: USB hub found
Oct  8 17:42:26 freehit kernel: [   62.483497] hub 4-0:1.0: 3 ports detected
Oct  8 17:42:26 freehit kernel: [   62.484428] hub 4-0:1.0: standalone hub
Oct  8 17:42:26 freehit kernel: [   62.485359] hub 4-0:1.0: no power 
switching (usb 1.0)
Oct  8 17:42:26 freehit kernel: [   62.486304] hub 4-0:1.0: global 
over-current protection
Oct  8 17:42:26 freehit kernel: [   62.487258] hub 4-0:1.0: power on to 
power good time: 4ms
Oct  8 17:42:26 freehit kernel: [   62.488210] hub 4-0:1.0: local power 
source is good
Oct  8 17:42:26 freehit kernel: [   62.489154] hub 4-0:1.0: no 
over-current condition exists
Oct  8 17:42:26 freehit kernel: [   62.490089] hub 4-0:1.0: trying to 
enable port power on non-switchable hub
Oct  8 17:42:26 freehit kernel: [   62.491057] drivers/usb/core/inode.c: 
creating file '001'
Oct  8 17:42:26 freehit kernel: [   62.492045] ehci_hcd 0000:00:12.2: HS 
companion for 0000:00:12.1
Oct  8 17:42:26 freehit kernel: [   62.493107] ohci_hcd 0000:00:13.0: 
PCI INT A -> GSI 18 (level, low) -> IRQ 18
Oct  8 17:42:26 freehit kernel: [   62.494098] ohci_hcd 0000:00:13.0: 
OHCI Host Controller
Oct  8 17:42:26 freehit kernel: [   62.494102] hub 3-0:1.0: state 7 
ports 3 chg 0000 evt 0000
Oct  8 17:42:26 freehit kernel: [   62.496024] drivers/usb/core/inode.c: 
creating file '005'
Oct  8 17:42:26 freehit kernel: [   62.497102] ohci_hcd 0000:00:13.0: 
new USB bus registered, assigned bus number 5
Oct  8 17:42:26 freehit kernel: [   62.498109] ohci_hcd 0000:00:13.0: 
created debug files
Oct  8 17:42:26 freehit kernel: [   62.499085] ohci_hcd 0000:00:13.0: 
supports USB remote wakeup
Oct  8 17:42:26 freehit kernel: [   62.500077] ohci_hcd 0000:00:13.0: 
irq 18, io mem 0xfe02b000
Oct  8 17:42:26 freehit kernel: [   62.502112] ata4: SATA link down 
(SStatus 0 SControl 300)
Oct  8 17:42:26 freehit kernel: [   62.503180] ata2: SATA link down 
(SStatus 0 SControl 300)
Oct  8 17:42:26 freehit kernel: [   62.556044] ohci_hcd 0000:00:13.0: 
OHCI controller state
Oct  8 17:42:26 freehit kernel: [   62.557061] ohci_hcd 0000:00:13.0: 
OHCI 1.0, NO legacy support registers
Oct  8 17:42:26 freehit kernel: [   62.558056] ohci_hcd 0000:00:13.0: 
control 0x283 RWC HCFS=operational CBSR=3
Oct  8 17:42:26 freehit kernel: [   62.559055] ohci_hcd 0000:00:13.0: 
cmdstatus 0x00000 SOC=0
Oct  8 17:42:26 freehit kernel: [   62.560047] ohci_hcd 0000:00:13.0: 
intrstatus 0x00000004 SF
Oct  8 17:42:26 freehit kernel: [   62.561039] ohci_hcd 0000:00:13.0: 
intrenable 0x8000005a MIE RHSC UE RD WDH
Oct  8 17:42:26 freehit kernel: [   62.562034] ohci_hcd 0000:00:13.0: 
hcca frame #000a
Oct  8 17:42:26 freehit kernel: [   62.563006] ohci_hcd 0000:00:13.0: 
roothub.a 02000203 POTPGT=2 NPS NDP=3(3)
Oct  8 17:42:26 freehit kernel: [   62.563978] ohci_hcd 0000:00:13.0: 
roothub.b 00000000 PPCM=0000 DR=0000
Oct  8 17:42:26 freehit kernel: [   62.564950] ohci_hcd 0000:00:13.0: 
roothub.status 00008000 DRWE
Oct  8 17:42:26 freehit kernel: [   62.565911] ohci_hcd 0000:00:13.0: 
roothub.portstatus [0] 0x00000100 PPS
Oct  8 17:42:26 freehit kernel: [   62.566873] ohci_hcd 0000:00:13.0: 
roothub.portstatus [1] 0x00000100 PPS
Oct  8 17:42:26 freehit kernel: [   62.567815] ohci_hcd 0000:00:13.0: 
roothub.portstatus [2] 0x00000100 PPS
Oct  8 17:42:26 freehit kernel: [   62.568760] usb usb5: default 
language 0x0409
Oct  8 17:42:26 freehit kernel: [   62.569695] usb usb5: udev 1, busnum 
5, minor = 512
Oct  8 17:42:26 freehit kernel: [   62.570625] usb usb5: New USB device 
found, idVendor=1d6b, idProduct=0001
Oct  8 17:42:26 freehit kernel: [   62.571570] usb usb5: New USB device 
strings: Mfr=3, Product=2, SerialNumber=1
Oct  8 17:42:26 freehit kernel: [   62.572522] usb usb5: Product: OHCI 
Host Controller
Oct  8 17:42:26 freehit kernel: [   62.573467] usb usb5: Manufacturer: 
Linux 3.0.4-gentoo-r2 ohci_hcd
Oct  8 17:42:26 freehit kernel: [   62.574416] usb usb5: SerialNumber: 
0000:00:13.0
Oct  8 17:42:26 freehit kernel: [   62.575524] usb usb5: usb_probe_device
Oct  8 17:42:26 freehit kernel: [   62.576475] usb usb5: configuration 
#1 chosen from 1 choice
Oct  8 17:42:26 freehit kernel: [   62.577438] usb usb5: adding 5-0:1.0 
(config #1, interface 0)
Oct  8 17:42:26 freehit kernel: [   62.578512] hub 5-0:1.0: 
usb_probe_interface
Oct  8 17:42:26 freehit kernel: [   62.579472] hub 5-0:1.0: 
usb_probe_interface - got id
Oct  8 17:42:26 freehit kernel: [   62.580425] hub 5-0:1.0: USB hub found
Oct  8 17:42:26 freehit kernel: [   62.581379] hub 5-0:1.0: 3 ports detected
Oct  8 17:42:26 freehit kernel: [   62.582335] hub 5-0:1.0: standalone hub
Oct  8 17:42:26 freehit kernel: [   62.583294] hub 5-0:1.0: no power 
switching (usb 1.0)
Oct  8 17:42:26 freehit kernel: [   62.584246] hub 5-0:1.0: global 
over-current protection
Oct  8 17:42:26 freehit kernel: [   62.585199] hub 5-0:1.0: power on to 
power good time: 4ms
Oct  8 17:42:26 freehit kernel: [   62.586153] hub 5-0:1.0: local power 
source is good
Oct  8 17:42:26 freehit kernel: [   62.587095] hub 5-0:1.0: no 
over-current condition exists
Oct  8 17:42:26 freehit kernel: [   62.588033] hub 5-0:1.0: trying to 
enable port power on non-switchable hub
Oct  8 17:42:26 freehit kernel: [   62.588996] drivers/usb/core/inode.c: 
creating file '001'
Oct  8 17:42:26 freehit kernel: [   62.589978] ehci_hcd 0000:00:13.2: HS 
companion for 0000:00:13.0
Oct  8 17:42:26 freehit kernel: [   62.591043] hub 4-0:1.0: state 7 
ports 3 chg 0000 evt 0000
Oct  8 17:42:26 freehit kernel: [   62.591065] ohci_hcd 0000:00:13.1: 
PCI INT A -> GSI 18 (level, low) -> IRQ 18
Oct  8 17:42:26 freehit kernel: [   62.591080] ohci_hcd 0000:00:13.1: 
OHCI Host Controller
Oct  8 17:42:26 freehit kernel: [   62.591089] drivers/usb/core/inode.c: 
creating file '006'
Oct  8 17:42:26 freehit kernel: [   62.591202] ohci_hcd 0000:00:13.1: 
new USB bus registered, assigned bus number 6
Oct  8 17:42:26 freehit kernel: [   62.591254] ohci_hcd 0000:00:13.1: 
created debug files
Oct  8 17:42:26 freehit kernel: [   62.591256] ohci_hcd 0000:00:13.1: 
supports USB remote wakeup
Oct  8 17:42:26 freehit kernel: [   62.591262] ohci_hcd 0000:00:13.1: 
irq 18, io mem 0xfe02a000
Oct  8 17:42:26 freehit kernel: [   62.646043] ohci_hcd 0000:00:13.1: 
OHCI controller state
Oct  8 17:42:26 freehit kernel: [   62.647068] ohci_hcd 0000:00:13.1: 
OHCI 1.0, NO legacy support registers
Oct  8 17:42:26 freehit kernel: [   62.648070] ohci_hcd 0000:00:13.1: 
control 0x283 RWC HCFS=operational CBSR=3
Oct  8 17:42:26 freehit kernel: [   62.649077] ohci_hcd 0000:00:13.1: 
cmdstatus 0x00000 SOC=0
Oct  8 17:42:26 freehit kernel: [   62.650081] ohci_hcd 0000:00:13.1: 
intrstatus 0x00000004 SF
Oct  8 17:42:26 freehit kernel: [   62.651077] ohci_hcd 0000:00:13.1: 
intrenable 0x8000005a MIE RHSC UE RD WDH
Oct  8 17:42:26 freehit kernel: [   62.652072] ohci_hcd 0000:00:13.1: 
hcca frame #000b
Oct  8 17:42:26 freehit kernel: [   62.653046] ohci_hcd 0000:00:13.1: 
roothub.a 02000203 POTPGT=2 NPS NDP=3(3)
Oct  8 17:42:26 freehit kernel: [   62.654025] ohci_hcd 0000:00:13.1: 
roothub.b 00000000 PPCM=0000 DR=0000
Oct  8 17:42:26 freehit kernel: [   62.654995] ohci_hcd 0000:00:13.1: 
roothub.status 00008000 DRWE
Oct  8 17:42:26 freehit kernel: [   62.655953] ohci_hcd 0000:00:13.1: 
roothub.portstatus [0] 0x00000100 PPS
Oct  8 17:42:26 freehit kernel: [   62.656913] ohci_hcd 0000:00:13.1: 
roothub.portstatus [1] 0x00000100 PPS
Oct  8 17:42:26 freehit kernel: [   62.657036] ata1: softreset failed 
(device not ready)
Oct  8 17:42:26 freehit kernel: [   62.657039] ata1: applying SB600 PMP 
SRST workaround and retrying
Oct  8 17:42:26 freehit kernel: [   62.659735] ohci_hcd 0000:00:13.1: 
roothub.portstatus [2] 0x00000100 PPS
Oct  8 17:42:26 freehit kernel: [   62.659755] ata3: softreset failed 
(device not ready)
Oct  8 17:42:26 freehit kernel: [   62.659758] ata3: applying SB600 PMP 
SRST workaround and retrying
Oct  8 17:42:26 freehit kernel: [   62.662629] usb usb6: default 
language 0x0409
Oct  8 17:42:26 freehit kernel: [   62.663604] usb usb6: udev 1, busnum 
6, minor = 640
Oct  8 17:42:26 freehit kernel: [   62.664575] usb usb6: New USB device 
found, idVendor=1d6b, idProduct=0001
Oct  8 17:42:26 freehit kernel: [   62.665557] usb usb6: New USB device 
strings: Mfr=3, Product=2, SerialNumber=1
Oct  8 17:42:26 freehit kernel: [   62.666544] usb usb6: Product: OHCI 
Host Controller
Oct  8 17:42:26 freehit kernel: [   62.667532] usb usb6: Manufacturer: 
Linux 3.0.4-gentoo-r2 ohci_hcd
Oct  8 17:42:26 freehit kernel: [   62.668530] usb usb6: SerialNumber: 
0000:00:13.1
Oct  8 17:42:26 freehit kernel: [   62.669688] usb usb6: usb_probe_device
Oct  8 17:42:26 freehit kernel: [   62.670673] usb usb6: configuration 
#1 chosen from 1 choice
Oct  8 17:42:26 freehit kernel: [   62.671678] usb usb6: adding 6-0:1.0 
(config #1, interface 0)
Oct  8 17:42:26 freehit kernel: [   62.672787] hub 6-0:1.0: 
usb_probe_interface
Oct  8 17:42:26 freehit kernel: [   62.673791] hub 6-0:1.0: 
usb_probe_interface - got id
Oct  8 17:42:26 freehit kernel: [   62.674799] hub 6-0:1.0: USB hub found
Oct  8 17:42:26 freehit kernel: [   62.675813] hub 6-0:1.0: 3 ports detected
Oct  8 17:42:26 freehit kernel: [   62.676810] hub 6-0:1.0: standalone hub
Oct  8 17:42:26 freehit kernel: [   62.677798] hub 6-0:1.0: no power 
switching (usb 1.0)
Oct  8 17:42:26 freehit kernel: [   62.678787] hub 6-0:1.0: global 
over-current protection
Oct  8 17:42:26 freehit kernel: [   62.679773] hub 6-0:1.0: power on to 
power good time: 4ms
Oct  8 17:42:26 freehit kernel: [   62.680756] hub 6-0:1.0: local power 
source is good
Oct  8 17:42:26 freehit kernel: [   62.681727] hub 6-0:1.0: no 
over-current condition exists
Oct  8 17:42:26 freehit kernel: [   62.682699] hub 6-0:1.0: trying to 
enable port power on non-switchable hub
Oct  8 17:42:26 freehit kernel: [   62.683706] drivers/usb/core/inode.c: 
creating file '001'
Oct  8 17:42:26 freehit kernel: [   62.684735] ehci_hcd 0000:00:13.2: HS 
companion for 0000:00:13.1
Oct  8 17:42:26 freehit kernel: [   62.685846] ohci_hcd 0000:00:14.5: 
PCI INT C -> GSI 18 (level, low) -> IRQ 18
Oct  8 17:42:26 freehit kernel: [   62.686859] ohci_hcd 0000:00:14.5: 
OHCI Host Controller
Oct  8 17:42:26 freehit kernel: [   62.687864] drivers/usb/core/inode.c: 
creating file '007'
Oct  8 17:42:26 freehit kernel: [   62.688906] hub 5-0:1.0: state 7 
ports 3 chg 0000 evt 0000
Oct  8 17:42:26 freehit kernel: [   62.689039] ohci_hcd 0000:00:14.5: 
new USB bus registered, assigned bus number 7
Oct  8 17:42:26 freehit kernel: [   62.689073] ohci_hcd 0000:00:14.5: 
created debug files
Oct  8 17:42:26 freehit kernel: [   62.689074] ohci_hcd 0000:00:14.5: 
supports USB remote wakeup
Oct  8 17:42:26 freehit kernel: [   62.689080] ohci_hcd 0000:00:14.5: 
irq 18, io mem 0xfe028000
Oct  8 17:42:26 freehit kernel: [   62.744045] ohci_hcd 0000:00:14.5: 
OHCI controller state
Oct  8 17:42:26 freehit kernel: [   62.745108] ohci_hcd 0000:00:14.5: 
OHCI 1.0, NO legacy support registers
Oct  8 17:42:26 freehit kernel: [   62.746147] ohci_hcd 0000:00:14.5: 
control 0x283 RWC HCFS=operational CBSR=3
Oct  8 17:42:26 freehit kernel: [   62.747183] ohci_hcd 0000:00:14.5: 
cmdstatus 0x00000 SOC=0
Oct  8 17:42:26 freehit kernel: [   62.748208] ohci_hcd 0000:00:14.5: 
intrstatus 0x00000004 SF
Oct  8 17:42:26 freehit kernel: [   62.749224] ohci_hcd 0000:00:14.5: 
intrenable 0x8000005a MIE RHSC UE RD WDH
Oct  8 17:42:26 freehit kernel: [   62.750240] ohci_hcd 0000:00:14.5: 
hcca frame #000b
Oct  8 17:42:26 freehit kernel: [   62.751237] ohci_hcd 0000:00:14.5: 
roothub.a 02000202 POTPGT=2 NPS NDP=2(2)
Oct  8 17:42:26 freehit kernel: [   62.752242] ohci_hcd 0000:00:14.5: 
roothub.b 00000000 PPCM=0000 DR=0000
Oct  8 17:42:26 freehit kernel: [   62.753240] ohci_hcd 0000:00:14.5: 
roothub.status 00008000 DRWE
Oct  8 17:42:26 freehit kernel: [   62.754223] ohci_hcd 0000:00:14.5: 
roothub.portstatus [0] 0x00000100 PPS
Oct  8 17:42:26 freehit kernel: [   62.755203] ohci_hcd 0000:00:14.5: 
roothub.portstatus [1] 0x00000100 PPS
Oct  8 17:42:26 freehit kernel: [   62.756175] usb usb7: default 
language 0x0409
Oct  8 17:42:26 freehit kernel: [   62.757152] usb usb7: udev 1, busnum 
7, minor = 768
Oct  8 17:42:26 freehit kernel: [   62.758124] usb usb7: New USB device 
found, idVendor=1d6b, idProduct=0001
Oct  8 17:42:26 freehit kernel: [   62.759116] usb usb7: New USB device 
strings: Mfr=3, Product=2, SerialNumber=1
Oct  8 17:42:26 freehit kernel: [   62.760105] usb usb7: Product: OHCI 
Host Controller
Oct  8 17:42:26 freehit kernel: [   62.761092] usb usb7: Manufacturer: 
Linux 3.0.4-gentoo-r2 ohci_hcd
Oct  8 17:42:26 freehit kernel: [   62.762089] usb usb7: SerialNumber: 
0000:00:14.5
Oct  8 17:42:26 freehit kernel: [   62.763245] usb usb7: usb_probe_device
Oct  8 17:42:26 freehit kernel: [   62.764240] usb usb7: configuration 
#1 chosen from 1 choice
Oct  8 17:42:26 freehit kernel: [   62.765246] usb usb7: adding 7-0:1.0 
(config #1, interface 0)
Oct  8 17:42:26 freehit kernel: [   62.766358] hub 7-0:1.0: 
usb_probe_interface
Oct  8 17:42:26 freehit kernel: [   62.767363] hub 7-0:1.0: 
usb_probe_interface - got id
Oct  8 17:42:26 freehit kernel: [   62.768363] hub 7-0:1.0: USB hub found
Oct  8 17:42:26 freehit kernel: [   62.769378] hub 7-0:1.0: 2 ports detected
Oct  8 17:42:26 freehit kernel: [   62.770369] hub 7-0:1.0: standalone hub
Oct  8 17:42:26 freehit kernel: [   62.771349] hub 7-0:1.0: no power 
switching (usb 1.0)
Oct  8 17:42:26 freehit kernel: [   62.772324] hub 7-0:1.0: global 
over-current protection
Oct  8 17:42:26 freehit kernel: [   62.773291] hub 7-0:1.0: power on to 
power good time: 4ms
Oct  8 17:42:26 freehit kernel: [   62.774261] hub 7-0:1.0: local power 
source is good
Oct  8 17:42:26 freehit kernel: [   62.775214] hub 7-0:1.0: no 
over-current condition exists
Oct  8 17:42:26 freehit kernel: [   62.776167] hub 7-0:1.0: trying to 
enable port power on non-switchable hub
Oct  8 17:42:26 freehit kernel: [   62.777148] drivers/usb/core/inode.c: 
creating file '001'
Oct  8 17:42:26 freehit kernel: [   62.778291] uhci_hcd: USB Universal 
Host Controller Interface driver
Oct  8 17:42:26 freehit kernel: [   62.779494] usbcore: registered new 
interface driver usblp
Oct  8 17:42:26 freehit kernel: [   62.780470] Initializing USB Mass 
Storage driver...
Oct  8 17:42:26 freehit kernel: [   62.781555] usbcore: registered new 
interface driver usb-storage
Oct  8 17:42:26 freehit kernel: [   62.782538] USB Mass Storage support 
registered.
Oct  8 17:42:26 freehit kernel: [   62.783715] usbcore: registered new 
interface driver libusual
Oct  8 17:42:26 freehit kernel: [   62.784034] hub 6-0:1.0: state 7 
ports 3 chg 0000 evt 0000
Oct  8 17:42:26 freehit kernel: [   62.785876] i8042: PNP: PS/2 
Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
Oct  8 17:42:26 freehit kernel: [   62.786889] i8042: PNP: PS/2 appears 
to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
Oct  8 17:42:26 freehit kernel: [   62.788201] serio: i8042 KBD port at 
0x60,0x64 irq 1
Oct  8 17:42:26 freehit kernel: [   62.789609] mousedev: PS/2 mouse 
device common for all mice
Oct  8 17:42:26 freehit kernel: [   62.791156] rtc_cmos 00:05: RTC can 
wake from S4
Oct  8 17:42:26 freehit kernel: [   62.792566] rtc_cmos 00:05: rtc core: 
registered rtc_cmos as rtc0
Oct  8 17:42:26 freehit kernel: [   62.793680] rtc0: alarms up to one 
month, 242 bytes nvram, hpet irqs
Oct  8 17:42:26 freehit kernel: [   62.795310] device-mapper: ioctl: 
4.20.0-ioctl (2011-02-02) initialised: dm-devel@redhat.com
Oct  8 17:42:26 freehit kernel: [   62.796581] cpuidle: using governor 
ladder
Oct  8 17:42:26 freehit kernel: [   62.797683] cpuidle: using governor menu
Oct  8 17:42:26 freehit kernel: [   62.798767] EFI Variables Facility 
v0.08 2004-May-17
Oct  8 17:42:26 freehit kernel: [   62.801162] usbcore: registered new 
interface driver usbhid
Oct  8 17:42:26 freehit kernel: [   62.802254] usbhid: USB HID core driver
Oct  8 17:42:26 freehit kernel: [   62.804691] HDA Intel 0000:00:14.2: 
PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct  8 17:42:26 freehit kernel: [   62.809079] input: AT Translated Set 
2 keyboard as /devices/platform/i8042/serio0/input/input2
Oct  8 17:42:26 freehit kernel: [   62.812058] ata1: SATA link up 3.0 
Gbps (SStatus 123 SControl 300)
Oct  8 17:42:26 freehit kernel: [   62.813829] ata1.00: ATA-7: WDC 
WD2500YD-01NVB1, 10.02E01, max UDMA/133
Oct  8 17:42:26 freehit kernel: [   62.814984] ata1.00: 490234752 
sectors, multi 16: LBA48 NCQ (depth 1), AA
Oct  8 17:42:26 freehit kernel: [   62.816135] ata3: SATA link up 3.0 
Gbps (SStatus 123 SControl 300)
Oct  8 17:42:26 freehit kernel: [   62.817896] ata1.00: configured for 
UDMA/133
Oct  8 17:42:26 freehit kernel: [   62.819390] hda_codec: ALC889A: BIOS 
auto-probing.
Oct  8 17:42:26 freehit kernel: [   62.819588] scsi 0:0:0:0: 
Direct-Access     ATA      WDC WD2500YD-01N 10.0 PQ: 0 ANSI: 5
Oct  8 17:42:26 freehit kernel: [   62.820231] sd 0:0:0:0: [sda] 
490234752 512-byte logical blocks: (251 GB/233 GiB)
Oct  8 17:42:26 freehit kernel: [   62.820353] sd 0:0:0:0: [sda] Write 
Protect is off
Oct  8 17:42:26 freehit kernel: [   62.820356] sd 0:0:0:0: [sda] Mode 
Sense: 00 3a 00 00
Oct  8 17:42:26 freehit kernel: [   62.820398] sd 0:0:0:0: [sda] Write 
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct  8 17:42:26 freehit kernel: [   62.820570] sd 0:0:0:0: Attached scsi 
generic sg0 type 0
Oct  8 17:42:26 freehit kernel: [   62.821296] ata3.00: HPA detected: 
current 3907027055, native 3907029168
Oct  8 17:42:26 freehit kernel: [   62.821368] ata3.00: ATA-8: WDC 
WD20EARS-00MVWB0, 51.0AB51, max UDMA/133
Oct  8 17:42:26 freehit kernel: [   62.821370] ata3.00: 3907027055 
sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Oct  8 17:42:26 freehit kernel: [   62.825342] ata3.00: configured for 
UDMA/133
Oct  8 17:42:26 freehit kernel: [   62.825488] scsi 2:0:0:0: 
Direct-Access     ATA      WDC WD20EARS-00M 51.0 PQ: 0 ANSI: 5
Oct  8 17:42:26 freehit kernel: [   62.825821] sd 2:0:0:0: [sdb] 
3907027055 512-byte logical blocks: (2.00 TB/1.81 TiB)
Oct  8 17:42:26 freehit kernel: [   62.825955] sd 2:0:0:0: [sdb] Write 
Protect is off
Oct  8 17:42:26 freehit kernel: [   62.825957] sd 2:0:0:0: [sdb] Mode 
Sense: 00 3a 00 00
Oct  8 17:42:26 freehit kernel: [   62.825963] sd 2:0:0:0: Attached scsi 
generic sg1 type 0
Oct  8 17:42:26 freehit kernel: [   62.826009] sd 2:0:0:0: [sdb] Write 
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct  8 17:42:26 freehit kernel: [   62.848698]  sda: sda1 sda2 sda3 sda4
Oct  8 17:42:26 freehit kernel: [   62.851074] sd 0:0:0:0: [sda] 
Attached SCSI disk
Oct  8 17:42:26 freehit kernel: [   62.852537] HDA Intel 0000:01:05.1: 
PCI INT B -> GSI 19 (level, low) -> IRQ 19
Oct  8 17:42:26 freehit kernel: [   62.853871] HDA Intel 0000:01:05.1: 
setting latency timer to 64
Oct  8 17:42:26 freehit kernel: [   62.859897] ALSA device list:
Oct  8 17:42:26 freehit kernel: [   62.861177]   #0: HDA ATI SB at 
0xfe024000 irq 16
Oct  8 17:42:26 freehit kernel: [   62.862445]   #1: HDA ATI HDMI at 
0xfdffc000 irq 19
Oct  8 17:42:26 freehit kernel: [   62.863794] Netfilter messages via 
NETLINK v0.30.
Oct  8 17:42:26 freehit kernel: [   62.865133] nf_conntrack version 
0.5.0 (16384 buckets, 65536 max)
Oct  8 17:42:26 freehit kernel: [   62.866869] ctnetlink v0.93: 
registering with nfnetlink.
Oct  8 17:42:26 freehit kernel: [   62.869188] ip_tables: (C) 2000-2006 
Netfilter Core Team
Oct  8 17:42:26 freehit kernel: [   62.870574] TCP cubic registered
Oct  8 17:42:26 freehit kernel: [   62.871887] Initializing XFRM netlink 
socket
Oct  8 17:42:26 freehit kernel: [   62.873613] NET: Registered protocol 
family 10
Oct  8 17:42:26 freehit kernel: [   62.876712] ip6_tables: (C) 2000-2006 
Netfilter Core Team
Oct  8 17:42:26 freehit kernel: [   62.878099] hub 7-0:1.0: state 7 
ports 2 chg 0000 evt 0000
Oct  8 17:42:26 freehit kernel: [   62.878160] IPv6 over IPv4 tunneling 
driver
Oct  8 17:42:26 freehit kernel: [   62.879284] NET: Registered protocol 
family 17
Oct  8 17:42:26 freehit kernel: [   62.879329] Registering the 
dns_resolver key type
Oct  8 17:42:26 freehit kernel: [   62.879697] PM: Hibernation image not 
present or could not be loaded.
Oct  8 17:42:26 freehit kernel: [   62.879717] registered taskstats 
version 1
Oct  8 17:42:26 freehit kernel: [   62.880039]   Magic number: 15:512:177
Oct  8 17:42:26 freehit kernel: [   62.880089] acpi device:0d: hash matches
Oct  8 17:42:26 freehit kernel: [   63.228561]  sdb: sdb1
Oct  8 17:42:26 freehit kernel: [   63.230421] sd 2:0:0:0: [sdb] 
Attached SCSI disk
Oct  8 17:42:26 freehit kernel: [   63.231781] md: Waiting for all 
devices to be available before autodetect
Oct  8 17:42:26 freehit kernel: [   63.233107] md: If you don't use 
raid, use raid=noautodetect
Oct  8 17:42:26 freehit kernel: [   63.235029] md: Autodetecting RAID 
arrays.
Oct  8 17:42:26 freehit kernel: [   63.236324] md: Scanned 0 and added 0 
devices.
Oct  8 17:42:26 freehit kernel: [   63.237575] md: autorun ...
Oct  8 17:42:26 freehit kernel: [   63.238813] md: ... autorun DONE.
Oct  8 17:42:26 freehit kernel: [   63.260139] EXT3-fs: barriers not enabled
Oct  8 17:42:26 freehit kernel: [   63.268832] kjournald starting. 
Commit interval 5 seconds
Oct  8 17:42:26 freehit kernel: [   63.269018] EXT3-fs (sda3): mounted 
filesystem with writeback data mode
Oct  8 17:42:26 freehit kernel: [   63.269086] VFS: Mounted root (ext3 
filesystem) readonly on device 8:3.
Oct  8 17:42:26 freehit kernel: [   63.273399] Freeing unused kernel 
memory: 660k freed
Oct  8 17:42:26 freehit kernel: [   63.274845] Write protecting the 
kernel read-only data: 14336k
Oct  8 17:42:26 freehit kernel: [   63.281378] Freeing unused kernel 
memory: 2012k freed
Oct  8 17:42:26 freehit kernel: [   63.284971] Freeing unused kernel 
memory: 612k freed
Oct  8 17:42:26 freehit kernel: [   63.454041] ohci_hcd 0000:00:12.0: 
auto-stop root hub
Oct  8 17:42:26 freehit kernel: [   63.704040] ohci_hcd 0000:00:12.1: 
auto-stop root hub
Oct  8 17:42:26 freehit kernel: [   63.705271] ohci_hcd 0000:00:13.0: 
auto-stop root hub
Oct  8 17:42:26 freehit kernel: [   63.706460] ohci_hcd 0000:00:13.1: 
auto-stop root hub
Oct  8 17:42:26 freehit kernel: [   63.954050] ohci_hcd 0000:00:14.5: 
auto-stop root hub
Oct  8 17:42:26 freehit kernel: [   64.027232] cat used greatest stack 
depth: 2064 bytes left
Oct  8 17:42:26 freehit [   65.548487] udevd[1161]: starting version 171
Oct  8 17:42:26 freehit kernel: [   68.515963] EXT3-fs (sda3): using 
internal journal
Oct  8 17:42:26 freehit kernel: [   68.652098] EXT3-fs: barriers not enabled
Oct  8 17:42:26 freehit kernel: [   68.659972] kjournald starting. 
Commit interval 5 seconds
Oct  8 17:42:26 freehit kernel: [   68.660237] EXT3-fs (sda4): using 
internal journal
Oct  8 17:42:26 freehit kernel: [   68.660245] EXT3-fs (sda4): mounted 
filesystem with writeback data mode
Oct  8 17:42:26 freehit kernel: [   68.820570] EXT4-fs (sdb1): mounted 
filesystem with ordered data mode. Opts: (null)
Oct  8 17:42:26 freehit kernel: [   70.088473] r8169 0000:02:00.0: eth0: 
link down
Oct  8 17:42:26 freehit kernel: [   70.088485] r8169 0000:02:00.0: eth0: 
link down
Oct  8 17:42:26 freehit kernel: [   70.089339] ADDRCONF(NETDEV_UP): 
eth0: link is not ready
Oct  8 17:42:26 freehit kernel: [   70.297224] Adding 2008120k swap on 
/dev/sda2.  Priority:-1 extents:1 across:2008120k
Oct  8 17:42:26 freehit kernel: [   71.702674] r8169 0000:02:00.0: eth0: 
link up
Oct  8 17:42:26 freehit kernel: [   71.703527] ADDRCONF(NETDEV_CHANGE): 
eth0: link becomes ready
Oct  8 17:42:26 freehit start-stop-daemon: 
pam_unix(start-stop-daemon:session): session opened for user nobody by 
(uid=0)
Oct  8 17:42:26 freehit sshd[2204]: Server listening on 0.0.0.0 port 22.
Oct  8 17:42:26 freehit sshd[2204]: Server listening on :: port 22.
Oct  8 17:42:26 freehit start-stop-daemon: 
pam_unix(start-stop-daemon:session): session opened for user nobody by 
(uid=0)
Oct  8 17:42:26 freehit cron[2229]: (CRON) STARTUP (V5.0)
Oct  8 17:42:27 freehit start-stop-daemon: 
pam_unix(start-stop-daemon:session): session opened for user nobody by 
(uid=0)
Oct  8 17:42:29 freehit /etc/init.d/local[2285]: /etc/conf.d/local 
should be removed.
Oct  8 17:42:29 freehit /etc/init.d/local[2286]: Please move the code 
from the local_start function
Oct  8 17:42:29 freehit /etc/init.d/local[2287]: to scripts with an 
.start extension
Oct  8 17:42:29 freehit /etc/init.d/local[2288]: in /etc/local.d
Oct  8 17:42:37 freehit kernel: [   82.434150] eth0: no IPv6 routers present
Oct  8 17:42:41 freehit sshd[2311]: SSH: Server;Ltype: Version;Remote: 
192.168.0.101-49777;Protocol: 2.0;Client: OpenSSH_5.8p1 Debian-1ubuntu3
Oct  8 17:42:41 freehit sshd[2311]: SSH: Server;Ltype: Kex;Remote: 
192.168.0.101-49777;Enc: aes128-ctr;MAC: hmac-md5;Comp: none [preauth]
Oct  8 17:42:41 freehit sshd[2311]: SSH: Server;Ltype: Authname;Remote: 
192.168.0.101-49777;Name: sushant [preauth]
Oct  8 17:42:41 freehit sshd[2311]: Accepted publickey for sushant from 
192.168.0.101 port 49777 ssh2
Oct  8 17:42:41 freehit sshd[2311]: pam_unix(sshd:session): session 
opened for user sushant by (uid=0)
Oct  8 17:42:41 freehit dbus[2158]: [system] Activating service 
name='org.freedesktop.ConsoleKit' (using servicehelper)
Oct  8 17:42:41 freehit dbus[2158]: [system] Activating service 
name='org.freedesktop.PolicyKit1' (using servicehelper)
Oct  8 17:42:42 freehit polkitd[2381]: started daemon version 0.102 
using authority implementation `local' version `0.102'
Oct  8 17:42:42 freehit dbus[2158]: [system] Successfully activated 
service 'org.freedesktop.PolicyKit1'
Oct  8 17:42:42 freehit dbus[2158]: [system] Successfully activated 
service 'org.freedesktop.ConsoleKit'
Oct  8 17:42:49 freehit su[2400]: Successful su for root by sushant
Oct  8 17:42:49 freehit su[2400]: + /dev/pts/0 sushant:root
Oct  8 17:42:49 freehit su[2400]: pam_unix(su:session): session opened 
for user root by sushant(uid=1000)
Oct  8 17:44:49 freehit sshd[2414]: SSH: Server;Ltype: Version;Remote: 
192.168.0.101-59974;Protocol: 2.0;Client: OpenSSH_5.8p1 Debian-1ubuntu3
Oct  8 17:44:49 freehit sshd[2414]: SSH: Server;Ltype: Kex;Remote: 
192.168.0.101-59974;Enc: aes128-ctr;MAC: hmac-md5;Comp: none [preauth]
Oct  8 17:44:49 freehit sshd[2414]: SSH: Server;Ltype: Authname;Remote: 
192.168.0.101-59974;Name: sushant [preauth]
Oct  8 17:44:49 freehit sshd[2414]: Accepted publickey for sushant from 
192.168.0.101 port 59974 ssh2
Oct  8 17:44:49 freehit sshd[2414]: pam_unix(sshd:session): session 
opened for user sushant by (uid=0)
Oct  8 17:46:26 freehit kernel: [  311.894072] ------------[ cut here 
]------------
Oct  8 17:46:26 freehit kernel: [  311.894082] WARNING: at 
kernel/lockdep.c:690 __lock_acquire+0x17d1/0x1d90()
Oct  8 17:46:26 freehit kernel: [  311.894084] Hardware name: 
GA-MA790GP-DS4H
Oct  8 17:46:26 freehit kernel: [  311.894086] Modules linked in:
Oct  8 17:46:26 freehit kernel: [  311.894089] Pid: 2433, comm: du Not 
tainted 3.0.4-gentoo-r2 #2
Oct  8 17:46:26 freehit kernel: [  311.894091] Call Trace:
Oct  8 17:46:26 freehit kernel: [  311.894096]  [<ffffffff81083e8a>] 
warn_slowpath_common+0x7a/0xb0
Oct  8 17:46:26 freehit kernel: [  311.894099]  [<ffffffff81083ed5>] 
warn_slowpath_null+0x15/0x20
Oct  8 17:46:26 freehit kernel: [  311.894102]  [<ffffffff810be801>] 
__lock_acquire+0x17d1/0x1d90
Oct  8 17:46:26 freehit kernel: [  311.894106]  [<ffffffff811e9910>] ? 
ext3_follow_link+0x20/0x20
Oct  8 17:46:26 freehit kernel: [  311.894109]  [<ffffffff8117fe9b>] ? 
find_inode_fast+0x4b/0xa0
Oct  8 17:46:26 freehit kernel: [  311.894112]  [<ffffffff810bf3b5>] 
lock_acquire+0x95/0x110
Oct  8 17:46:26 freehit kernel: [  311.894114]  [<ffffffff8117fe9b>] ? 
find_inode_fast+0x4b/0xa0
Oct  8 17:46:26 freehit kernel: [  311.894118]  [<ffffffff817f767c>] 
_raw_spin_lock+0x2c/0x40
Oct  8 17:46:26 freehit kernel: [  311.894120]  [<ffffffff8117fe9b>] ? 
find_inode_fast+0x4b/0xa0
Oct  8 17:46:26 freehit kernel: [  311.894123]  [<ffffffff817f7e46>] ? 
_raw_spin_unlock+0x26/0x30
Oct  8 17:46:26 freehit kernel: [  311.894125]  [<ffffffff8117fe9b>] 
find_inode_fast+0x4b/0xa0
Oct  8 17:46:26 freehit kernel: [  311.894127]  [<ffffffff81181698>] 
iget_locked+0x78/0x1d0
Oct  8 17:46:26 freehit kernel: [  311.894130]  [<ffffffff811dcd2f>] 
ext3_iget+0x2f/0x4b0
Oct  8 17:46:26 freehit kernel: [  311.894132]  [<ffffffff811e1e98>] 
ext3_lookup+0xa8/0x130
Oct  8 17:46:26 freehit kernel: [  311.894135]  [<ffffffff811712c0>] 
d_alloc_and_lookup+0x40/0x80
Oct  8 17:46:26 freehit kernel: [  311.894137]  [<ffffffff8117ea50>] ? 
d_lookup+0x30/0x50
Oct  8 17:46:26 freehit kernel: [  311.894140]  [<ffffffff81172ab2>] 
do_lookup+0x2a2/0x320
Oct  8 17:46:26 freehit kernel: [  311.894142]  [<ffffffff81173ff4>] 
path_lookupat+0x134/0x6c0
Oct  8 17:46:26 freehit kernel: [  311.894145]  [<ffffffff8113d4e0>] ? 
might_fault+0xa0/0xb0
Oct  8 17:46:26 freehit kernel: [  311.894147]  [<ffffffff8113d497>] ? 
might_fault+0x57/0xb0
Oct  8 17:46:26 freehit kernel: [  311.894150]  [<ffffffff812fe862>] ? 
__strncpy_from_user+0x22/0x60
Oct  8 17:46:26 freehit kernel: [  311.894153]  [<ffffffff811745ac>] 
do_path_lookup+0x2c/0xc0
Oct  8 17:46:26 freehit kernel: [  311.894155]  [<ffffffff8113d497>] ? 
might_fault+0x57/0xb0
Oct  8 17:46:26 freehit kernel: [  311.894157]  [<ffffffff811748d4>] 
user_path_at+0x54/0xa0
Oct  8 17:46:26 freehit kernel: [  311.894159]  [<ffffffff8113d4e0>] ? 
might_fault+0xa0/0xb0
Oct  8 17:46:26 freehit kernel: [  311.894162]  [<ffffffff8116b1b3>] ? 
cp_new_stat+0xf3/0x110
Oct  8 17:46:26 freehit kernel: [  311.894164]  [<ffffffff8116b484>] 
vfs_fstatat+0x44/0x80
Oct  8 17:46:26 freehit kernel: [  311.894166]  [<ffffffff8116b6bf>] 
sys_newfstatat+0x1f/0x40
Oct  8 17:46:26 freehit kernel: [  311.894169]  [<ffffffff817ff92c>] ? 
sysret_check+0x27/0x62
Oct  8 17:46:26 freehit kernel: [  311.894171]  [<ffffffff810bfddd>] ? 
trace_hardirqs_on_caller+0x13d/0x180
Oct  8 17:46:26 freehit kernel: [  311.894174]  [<ffffffff812fe56e>] ? 
trace_hardirqs_on_thunk+0x3a/0x3f
Oct  8 17:46:26 freehit kernel: [  311.894176]  [<ffffffff817ff8fb>] 
system_call_fastpath+0x16/0x1b
Oct  8 17:46:26 freehit kernel: [  311.894178] ---[ end trace 
06fd71e87731c820 ]---
Oct  8 17:46:34 freehit kernel: [  319.343054] BUG: spinlock bad magic 
on CPU#2, du/2433
Oct  8 17:46:34 freehit kernel: [  319.343061]  lock: ffff880101988d00, 
.magic: de8d4ead, .owner: <none>/-1, .owner_cpu: -1
Oct  8 17:46:34 freehit kernel: [  319.343064] Pid: 2433, comm: du 
Tainted: G        W   3.0.4-gentoo-r2 #2
Oct  8 17:46:34 freehit kernel: [  319.343066] Call Trace:
Oct  8 17:46:34 freehit kernel: [  319.343073]  [<ffffffff81303d62>] 
spin_bug+0xa2/0xf0
Oct  8 17:46:34 freehit kernel: [  319.343076]  [<ffffffff81303f32>] 
do_raw_spin_lock+0xa2/0x170
Oct  8 17:46:34 freehit kernel: [  319.343080]  [<ffffffff817f7684>] 
_raw_spin_lock+0x34/0x40
Oct  8 17:46:34 freehit kernel: [  319.343084]  [<ffffffff8117fe9b>] ? 
find_inode_fast+0x4b/0xa0
Oct  8 17:46:34 freehit kernel: [  319.343087]  [<ffffffff817f7e46>] ? 
_raw_spin_unlock+0x26/0x30
Oct  8 17:46:34 freehit kernel: [  319.343089]  [<ffffffff8117fe9b>] 
find_inode_fast+0x4b/0xa0
Oct  8 17:46:34 freehit kernel: [  319.343091]  [<ffffffff81181698>] 
iget_locked+0x78/0x1d0
Oct  8 17:46:34 freehit kernel: [  319.343095]  [<ffffffff811dcd2f>] 
ext3_iget+0x2f/0x4b0
Oct  8 17:46:34 freehit kernel: [  319.343097]  [<ffffffff811e1e98>] 
ext3_lookup+0xa8/0x130
Oct  8 17:46:34 freehit kernel: [  319.343101]  [<ffffffff811712c0>] 
d_alloc_and_lookup+0x40/0x80
Oct  8 17:46:34 freehit kernel: [  319.343103]  [<ffffffff8117ea50>] ? 
d_lookup+0x30/0x50
Oct  8 17:46:34 freehit kernel: [  319.343105]  [<ffffffff81172ab2>] 
do_lookup+0x2a2/0x320
Oct  8 17:46:34 freehit kernel: [  319.343108]  [<ffffffff81173ff4>] 
path_lookupat+0x134/0x6c0
Oct  8 17:46:34 freehit kernel: [  319.343111]  [<ffffffff8113d4e0>] ? 
might_fault+0xa0/0xb0
Oct  8 17:46:34 freehit kernel: [  319.343113]  [<ffffffff8113d497>] ? 
might_fault+0x57/0xb0
Oct  8 17:46:34 freehit kernel: [  319.343116]  [<ffffffff812fe862>] ? 
__strncpy_from_user+0x22/0x60
Oct  8 17:46:34 freehit kernel: [  319.343118]  [<ffffffff811745ac>] 
do_path_lookup+0x2c/0xc0
Oct  8 17:46:34 freehit kernel: [  319.343120]  [<ffffffff8113d497>] ? 
might_fault+0x57/0xb0
Oct  8 17:46:34 freehit kernel: [  319.343123]  [<ffffffff811748d4>] 
user_path_at+0x54/0xa0
Oct  8 17:46:34 freehit kernel: [  319.343125]  [<ffffffff8113d4e0>] ? 
might_fault+0xa0/0xb0
Oct  8 17:46:34 freehit kernel: [  319.343127]  [<ffffffff8116b1b3>] ? 
cp_new_stat+0xf3/0x110
Oct  8 17:46:34 freehit kernel: [  319.343129]  [<ffffffff8116b484>] 
vfs_fstatat+0x44/0x80
Oct  8 17:46:34 freehit kernel: [  319.343132]  [<ffffffff8116b6bf>] 
sys_newfstatat+0x1f/0x40
Oct  8 17:46:34 freehit kernel: [  319.343135]  [<ffffffff817ff92c>] ? 
sysret_check+0x27/0x62
Oct  8 17:46:34 freehit kernel: [  319.343138]  [<ffffffff810bfddd>] ? 
trace_hardirqs_on_caller+0x13d/0x180
Oct  8 17:46:34 freehit kernel: [  319.343140]  [<ffffffff812fe56e>] ? 
trace_hardirqs_on_thunk+0x3a/0x3f
Oct  8 17:46:34 freehit kernel: [  319.343143]  [<ffffffff817ff8fb>] 
system_call_fastpath+0x16/0x1b
Oct  8 17:46:34 freehit kernel: [  319.345370] general protection fault: 
0000 [#1] SMP
Oct  8 17:46:34 freehit kernel: [  319.345404] CPU 2
Oct  8 17:46:34 freehit kernel: [  319.345415] Modules linked in:
Oct  8 17:46:34 freehit kernel: [  319.345432]
Oct  8 17:46:34 freehit kernel: [  319.345441] Pid: 2433, comm: du 
Tainted: G        W   3.0.4-gentoo-r2 #2 Gigabyte Technology Co., Ltd. 
GA-MA790GP-DS4H/GA-MA790GP-DS4H
Oct  8 17:46:34 freehit kernel: [  319.345498] RIP: 
0010:[<ffffffff8117e78e>]  [<ffffffff8117e78e>] __d_lookup_rcu+0x7e/0x170
Oct  8 17:46:34 freehit kernel: [  319.345541] RSP: 
0018:ffff8801a5c89c18  EFLAGS: 00010286
Oct  8 17:46:34 freehit kernel: [  319.345566] RAX: ffff8801a5c89cd4 
RBX: ff7f88012100e9b0 RCX: 0000000000000014
Oct  8 17:46:34 freehit kernel: [  319.345598] RDX: 018721e0ebe72c6e 
RSI: ffff8801a5c89df8 RDI: ffff88006cef10f8
Oct  8 17:46:34 freehit kernel: [  319.345630] RBP: ffff8801a5c89c88 
R08: 0000000000000000 R09: 0000000000000000
Oct  8 17:46:34 freehit kernel: [  319.345662] R10: ffff8801a5c89df8 
R11: ffff8801a5c89d58 R12: ffff88006cef10f8
Oct  8 17:46:34 freehit kernel: [  319.345694] R13: ff7f88012100e9b8 
R14: ffff8801a5c89cd4 R15: 00000000ed9ae02b
Oct  8 17:46:34 freehit kernel: [  319.345726] FS: 
00007f14af2e8700(0000) GS:ffff8801afd00000(0000) knlGS:0000000000000000
Oct  8 17:46:34 freehit kernel: [  319.345762] CS:  0010 DS: 0000 ES: 
0000 CR0: 000000008005003b
Oct  8 17:46:34 freehit kernel: [  319.345788] CR2: 00007f14aeec17d4 
CR3: 00000001a7723000 CR4: 00000000000006e0
Oct  8 17:46:34 freehit kernel: [  319.345820] DR0: 0000000000000000 
DR1: 0000000000000000 DR2: 0000000000000000
Oct  8 17:46:34 freehit kernel: [  319.345851] DR3: 0000000000000000 
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct  8 17:46:34 freehit kernel: [  319.345883] Process du (pid: 2433, 
threadinfo ffff8801a5c88000, task ffff8801a79a6240)
Oct  8 17:46:34 freehit kernel: [  319.345918] Stack:
Oct  8 17:46:34 freehit kernel: [  319.345928]  0000000000000000 
0000000000000000 0000000000000000 ffff8801a4fec000
Oct  8 17:46:34 freehit kernel: [  319.345965]  ffff8801a5c89c48 
ffff8801a4fec000 ffff8801a5c89d08 000000000000000b
Oct  8 17:46:34 freehit kernel: [  319.346002]  0000000000000000 
ffff8801a5c89d48 ffff8801a5c89de8 ffff8801a5c89d58
Oct  8 17:46:34 freehit kernel: [  319.346002] Call Trace:
Oct  8 17:46:34 freehit kernel: [  319.346002]  [<ffffffff81172856>] 
do_lookup+0x46/0x320
Oct  8 17:46:34 freehit kernel: [  319.346002]  [<ffffffff817f7e46>] ? 
_raw_spin_unlock+0x26/0x30
Oct  8 17:46:34 freehit kernel: [  319.346002]  [<ffffffff81173ff4>] 
path_lookupat+0x134/0x6c0
Oct  8 17:46:34 freehit kernel: [  319.346002]  [<ffffffff8113d4e0>] ? 
might_fault+0xa0/0xb0
Oct  8 17:46:34 freehit kernel: [  319.346002]  [<ffffffff8113d497>] ? 
might_fault+0x57/0xb0
Oct  8 17:46:34 freehit kernel: [  319.346002]  [<ffffffff812fe862>] ? 
__strncpy_from_user+0x22/0x60
Oct  8 17:46:34 freehit kernel: [  319.346002]  [<ffffffff811745ac>] 
do_path_lookup+0x2c/0xc0
Oct  8 17:46:34 freehit kernel: [  319.346002]  [<ffffffff811748d4>] 
user_path_at+0x54/0xa0
Oct  8 17:46:34 freehit kernel: [  319.346002]  [<ffffffff8113d4e0>] ? 
might_fault+0xa0/0xb0
Oct  8 17:46:34 freehit kernel: [  319.346002]  [<ffffffff8116b1b3>] ? 
cp_new_stat+0xf3/0x110
Oct  8 17:46:34 freehit kernel: [  319.346002]  [<ffffffff8116b484>] 
vfs_fstatat+0x44/0x80
Oct  8 17:46:34 freehit kernel: [  319.346002]  [<ffffffff8116b6bf>] 
sys_newfstatat+0x1f/0x40
Oct  8 17:46:34 freehit kernel: [  319.346002]  [<ffffffff810c088a>] ? 
lockdep_sys_exit+0x2a/0x80
Oct  8 17:46:34 freehit kernel: [  319.346002]  [<ffffffff812fe56e>] ? 
trace_hardirqs_on_thunk+0x3a/0x3f
Oct  8 17:46:34 freehit kernel: [  319.346002]  [<ffffffff817ff8fb>] 
system_call_fastpath+0x16/0x1b
Oct  8 17:46:34 freehit kernel: [  319.346002] Code: ad cf d2 00 48 c1 
e0 03 48 03 05 a6 cf d2 00 4c 8b 28 49 83 e5 fe 74 6b 4c 89 d0 89 db 49 
89 f2 48 89 5d c8 49 89 c6 49 8d 5d f8
Oct  8 17:46:34 freehit [  319.346002]  39 7b 20 75 49 8b 43 04 a8 01 0f 
85 cd 00 00 00 41 89 06 4c
Oct  8 17:46:34 freehit kernel: [  319.346002] RIP  [<ffffffff8117e78e>] 
__d_lookup_rcu+0x7e/0x170
Oct  8 17:46:34 freehit kernel: [  319.346002]  RSP <ffff8801a5c89c18>
Oct  8 17:46:34 freehit kernel: [  319.357608] ---[ end trace 
06fd71e87731c821 ]---
Oct  8 17:47:34 freehit kernel: [  379.358005] INFO: rcu_sched_state 
detected stall on CPU 2 (t=60000 jiffies)

---
Gentoo Linux user
Paramonov Valeriy

