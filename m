Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab0DROxq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 10:53:46 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46386 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822Ab0DROxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 10:53:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject;
        b=huiAILD0aPQKI4iluOe+0VFMXMDUeq0uIeLftjcOH+hsDLWgi+Np80Gzk7D1kReCzt
         tylUAgTYZkKZW9OWxo0RyWeOG48rc5oHNKXWjJz3f47u+s27CCu7WXdaZc/LQhamyYZN
         olS7CU2Qn6061XYb+tleDaQu3AZTslS/QvjZY=
Message-ID: <4bcb1cf2.116bdc0a.2008.6f5a@mx.google.com>
Date: Sun, 18 Apr 2010 07:53:38 -0700 (PDT)
From: Ben Gamari <bgamari.foss@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [REGRESSION 2.6.34] Suspend fails in pm_test=processor on Dell laptop
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey all,

It seems that something in the 2.6.34 merge cycle has broken suspend to RAM on
my Dell Latitude D830. While suspend has been rock solid for several release
cycles, as of 2.6.34-rc4 it locks up on suspend. All of the pm_test options up
to processor work fine, precluding a driver issue. Unfortunately, I've been
unable to get any useful output from the serial console during suspend. I'll
try bisecting and report back when I have more details. Let me know what else
I can do to help.

Cheers,

- Ben

dmesg after boot:
==============================
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.34-rc4-ben (ben@ben-laptop) (gcc version 4.5.0 (Ubuntu 4.5.0-1ubuntu1~ppa2) ) #154 SMP Thu Apr 15 19:07:22 EDT 2010
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.34-rc4-ben root=/dev/sda6 ro quiet splash pciehp.pciehp_force=1
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000df65a800 (usable)
[    0.000000]  BIOS-e820: 00000000df65a800 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000feda6000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FE0000000 write-back
[    0.000000]   3 base 100000000 mask FE0000000 write-back
[    0.000000]   4 base 0DF800000 mask FFF800000 uncachable
[    0.000000]   5 base 0DF700000 mask FFFF00000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000df700000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xdf65a max_arch_pfn = 0x400000000
[    0.000000] e820 update range: 0000000000001000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009f000 (usable)
[    0.000000]  modified: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000df65a800 (usable)
[    0.000000]  modified: 00000000df65a800 - 00000000e0000000 (reserved)
[    0.000000]  modified: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fed18000 - 00000000fed1c000 (reserved)
[    0.000000]  modified: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  modified: 00000000feda0000 - 00000000feda6000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  modified: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000df65a000
[    0.000000]  0000000000 - 00df600000 page 2M
[    0.000000]  00df600000 - 00df65a000 page 4k
[    0.000000] kernel direct mapping tables up to df65a000 @ 16000-1c000
[    0.000000] init_memory_mapping: 0000000100000000-0000000120000000
[    0.000000]  0100000000 - 0120000000 page 2M
[    0.000000] kernel direct mapping tables up to 120000000 @ 1a000-20000
[    0.000000] RAMDISK: 36c71000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000fbb10 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000df65d200 00064 (v01 DELL    M08     27D80C0B ASL  00000061)
[    0.000000] ACPI: FACP 00000000df65d09c 000F4 (v04 DELL    M08     27D80C0B ASL  00000061)
[    0.000000] ACPI: DSDT 00000000df65d800 063B2 (v02 INT430 SYSFexxx 00001001 INTL 20050624)
[    0.000000] ACPI: FACS 00000000df66c000 00040
[    0.000000] ACPI: HPET 00000000df65d300 00038 (v01 DELL    M08     00000001 ASL  00000061)
[    0.000000] ACPI: APIC 00000000df65d400 00068 (v01 DELL    M08     27D80C0B ASL  00000047)
[    0.000000] ACPI: ASF! 00000000df65d000 0007E (v32 DELL    M08     27D80C0B ASL  00000061)
[    0.000000] ACPI: MCFG 00000000df65d3c0 0003E (v16 DELL    M08     27D80C0B ASL  00000061)
[    0.000000] ACPI: TCPA 00000000df65d700 00032 (v01                 00000000 ASL  00000000)
[    0.000000] ACPI: SLIC 00000000df65d49c 00176 (v01 DELL    M08     27D80C0B ASL  00000061)
[    0.000000] ACPI: SSDT 00000000df65b9c0 004CC (v01  PmRef    CpuPm 00003000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000120000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000120000000
[    0.000000]   NODE_DATA [0000000100000000 - 0000000100004fff]
[    0.000000]  [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff880100200000-ffff880103bfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00120000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000df65a
[    0.000000]     0: 0x00100000 -> 0x00120000
[    0.000000] On node 0 totalpages: 1045993
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3927 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 896658 pages, LIFO batch:31
[    0.000000]   Normal zone: 1792 pages used for memmap
[    0.000000]   Normal zone: 129280 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] early_res array is doubled to 64 at [1b000 - 1b7ff]
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000df65a000 - 00000000df65b000
[    0.000000] PM: Registered nosave memory: 00000000df65b000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
[    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000feda0000
[    0.000000] PM: Registered nosave memory: 00000000feda0000 - 00000000feda6000
[    0.000000] PM: Registered nosave memory: 00000000feda6000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee10000
[    0.000000] PM: Registered nosave memory: 00000000fee10000 - 00000000ffe00000
[    0.000000] PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at e0000000 (gap: e0000000:18000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880002600000 s91880 r8192 d22808 u1048576
[    0.000000] pcpu-alloc: s91880 r8192 d22808 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1029865
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.34-rc4-ben root=/dev/sda6 ro quiet splash pciehp.pciehp_force=1
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Subtract (52 early reservations)
[    0.000000]   #1 [0001000000 - 00024d9d90]   TEXT DATA BSS
[    0.000000]   #2 [0036c71000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [000009f000 - 0000100000]   BIOS reserved
[    0.000000]   #4 [00024da000 - 00024da1ec]             BRK
[    0.000000]   #5 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #6 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #7 [0000016000 - 000001a000]         PGTABLE
[    0.000000]   #8 [000001a000 - 000001b000]         PGTABLE
[    0.000000]   #9 [0100000000 - 0100005000]       NODE_DATA
[    0.000000]   #10 [00024da200 - 00024db200]         BOOTMEM
[    0.000000]   #11 [00028db200 - 00028db500]         BOOTMEM
[    0.000000]   #12 [0100005000 - 0100006000]         BOOTMEM
[    0.000000]   #13 [0100006000 - 0100007000]         BOOTMEM
[    0.000000]   #14 [0100200000 - 0103c00000]        MEMMAP 0
[    0.000000]   #15 [00024db200 - 00024db600]         BOOTMEM
[    0.000000]   #16 [00024db600 - 000251b600]         BOOTMEM
[    0.000000]   #17 [000251b600 - 0002523600]         BOOTMEM
[    0.000000]   #18 [0002524000 - 0002525000]         BOOTMEM
[    0.000000]   #19 [00024d9dc0 - 00024d9e01]         BOOTMEM
[    0.000000]   #20 [00024d9e40 - 00024d9e83]         BOOTMEM
[    0.000000]   #21 [0002523600 - 00025238d8]         BOOTMEM
[    0.000000]   #22 [00024d9ec0 - 00024d9f28]         BOOTMEM
[    0.000000]   #23 [00024d9f40 - 00024d9fa8]         BOOTMEM
[    0.000000]   #24 [0002523900 - 0002523968]         BOOTMEM
[    0.000000]   #25 [0002523980 - 00025239e8]         BOOTMEM
[    0.000000]   #26 [0002523a00 - 0002523a68]         BOOTMEM
[    0.000000]   #27 [0002523a80 - 0002523ae8]         BOOTMEM
[    0.000000]   #28 [0002523b00 - 0002523b68]         BOOTMEM
[    0.000000]   #29 [0002523b80 - 0002523be8]         BOOTMEM
[    0.000000]   #30 [0002523c00 - 0002523c68]         BOOTMEM
[    0.000000]   #31 [0002523c80 - 0002523ce8]         BOOTMEM
[    0.000000]   #32 [0002523d00 - 0002523d68]         BOOTMEM
[    0.000000]   #33 [0002523d80 - 0002523de8]         BOOTMEM
[    0.000000]   #34 [00024d9fc0 - 00024d9fe0]         BOOTMEM
[    0.000000]   #35 [0002523e00 - 0002523e20]         BOOTMEM
[    0.000000]   #36 [0002523e40 - 0002523e98]         BOOTMEM
[    0.000000]   #37 [0002523ec0 - 0002523f18]         BOOTMEM
[    0.000000]   #38 [0002600000 - 000261e000]         BOOTMEM
[    0.000000]   #39 [0002700000 - 000271e000]         BOOTMEM
[    0.000000]   #40 [0002523f40 - 0002523f48]         BOOTMEM
[    0.000000]   #41 [0002523f80 - 0002523f88]         BOOTMEM
[    0.000000]   #42 [0002523fc0 - 0002523fc8]         BOOTMEM
[    0.000000]   #43 [0002527000 - 0002527010]         BOOTMEM
[    0.000000]   #44 [0002527040 - 0002527180]         BOOTMEM
[    0.000000]   #45 [0002527180 - 00025271e0]         BOOTMEM
[    0.000000]   #46 [0002527200 - 0002527260]         BOOTMEM
[    0.000000]   #47 [0002527280 - 000252f280]         BOOTMEM
[    0.000000]   #48 [00028dc000 - 00068dc000]         BOOTMEM
[    0.000000]   #49 [000252f280 - 000254f280]         BOOTMEM
[    0.000000]   #50 [000254f280 - 000258f280]         BOOTMEM
[    0.000000]   #51 [000001b800 - 0000023800]         BOOTMEM
[    0.000000] Memory: 4016656k/4718592k available (5940k kernel code, 534620k absent, 167316k reserved, 5251k data, 812k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:424
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] allocated 41943040 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2194.455 MHz processor.
[    0.004019] Calibrating delay loop (skipped), value calculated using timer frequency.. 4388.91 BogoMIPS (lpj=8777820)
[    0.004094] Security Framework initialized
[    0.004102] SELinux:  Disabled at boot.
[    0.004651] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.009063] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.010230] Mount-cache hash table entries: 256
[    0.011342] Initializing cgroup subsys ns
[    0.011348] Initializing cgroup subsys cpuacct
[    0.011355] Initializing cgroup subsys memory
[    0.011408] Initializing cgroup subsys freezer
[    0.011411] Initializing cgroup subsys net_cls
[    0.011414] Initializing cgroup subsys blkio
[    0.011494] CPU: Physical Processor ID: 0
[    0.011496] CPU: Processor Core ID: 0
[    0.011499] mce: CPU supports 6 MCE banks
[    0.011508] CPU0: Thermal monitoring enabled (TM2)
[    0.011513] using mwait in idle threads.
[    0.011515] Performance Events: Core2 events, Intel PMU driver.
[    0.011530] ... version:                2
[    0.011532] ... bit width:              40
[    0.011533] ... generic registers:      2
[    0.011535] ... value mask:             000000ffffffffff
[    0.011537] ... max period:             000000007fffffff
[    0.011539] ... fixed-purpose events:   3
[    0.011540] ... event mask:             0000000700000003
[    0.012816] ACPI: Core revision 20100121
[    0.026888] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.026895] ftrace: allocating 21404 entries in 84 pages
[    0.028154] Setting APIC routing to flat
[    0.028566] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.068405] CPU0: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0b
[    0.072000] lockdep: fixing up alternatives.
[    0.072000] Booting Node   0, Processors  #1 Ok.
[    0.160056] Brought up 2 CPUs
[    0.160061] Total of 2 processors activated (8777.88 BogoMIPS).
[    0.161337] Time: 14:41:40  Date: 04/18/10
[    0.161337] NET: Registered protocol family 16
[    0.164085] ACPI: bus type pci registered
[    0.164085] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.164085] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.181347] PCI: Using configuration type 1 for base access
[    0.188092] bio: create slab <bio-0> at 0
[    0.192718] ACPI: EC: Look up EC in DSDT
[    0.208333] ACPI: BIOS _OSI(Linux) query ignored
[    0.214459] ACPI: SSDT 00000000df66c080 00043 (v01  LMPWR  DELLLOM 00001001 INTL 20050624)
[    0.234358] ACPI: SSDT 00000000df65c4f6 00286 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.237368] ACPI: SSDT 00000000df65be8c 005E5 (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.238866] ACPI: SSDT 00000000df65c77c 000C4 (v01  PmRef  Cpu1Ist 00003000 INTL 20050624)
[    0.240096] ACPI: SSDT 00000000df65c471 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20050624)
[    0.241197] ACPI: Interpreter enabled
[    0.241201] ACPI: (supports S0 S3 S4 S5)
[    0.241249] ACPI: Using IOAPIC for interrupt routing
[    0.336227] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.336231] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.354111] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.389775] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.389779] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.389782] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.389785] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff]
[    0.389788] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xf7ffffff]
[    0.389791] pci_root PNP0A03:00: host bridge window [mem 0xfc000000-0xfebfffff]
[    0.389794] pci_root PNP0A03:00: host bridge window [mem 0xfec10000-0xfecfffff]
[    0.389797] pci_root PNP0A03:00: host bridge window [mem 0xfed1c000-0xfed1ffff]
[    0.389800] pci_root PNP0A03:00: host bridge window [mem 0xfed90000-0xfed9ffff]
[    0.389802] pci_root PNP0A03:00: host bridge window [mem 0xfed40000-0xfed44fff]
[    0.389805] pci_root PNP0A03:00: host bridge window [mem 0xfeda7000-0xfedfffff]
[    0.389808] pci_root PNP0A03:00: host bridge window [mem 0xfee10000-0xff9fffff]
[    0.389811] pci_root PNP0A03:00: host bridge window [mem 0xffc00000-0xffdfffff]
[    0.389951] pci 0000:00:02.0: reg 10: [mem 0xf6e00000-0xf6efffff 64bit]
[    0.389962] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.389968] pci 0000:00:02.0: reg 20: [io  0xeff8-0xefff]
[    0.390025] pci 0000:00:02.1: reg 10: [mem 0xf6f00000-0xf6ffffff 64bit]
[    0.390177] pci 0000:00:1a.0: reg 20: [io  0x6f20-0x6f3f]
[    0.390259] pci 0000:00:1a.1: reg 20: [io  0x6f00-0x6f1f]
[    0.390340] pci 0000:00:1a.7: reg 10: [mem 0xfed1c400-0xfed1c7ff]
[    0.390422] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.390429] pci 0000:00:1a.7: PME# disabled
[    0.390485] pci 0000:00:1b.0: reg 10: [mem 0xf6dfc000-0xf6dfffff 64bit]
[    0.390565] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.390571] pci 0000:00:1b.0: PME# disabled
[    0.390695] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.390701] pci 0000:00:1c.0: PME# disabled
[    0.390828] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.390834] pci 0000:00:1c.1: PME# disabled
[    0.390964] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.390970] pci 0000:00:1c.3: PME# disabled
[    0.391099] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.391105] pci 0000:00:1c.5: PME# disabled
[    0.391182] pci 0000:00:1d.0: reg 20: [io  0x6f80-0x6f9f]
[    0.391264] pci 0000:00:1d.1: reg 20: [io  0x6f60-0x6f7f]
[    0.391345] pci 0000:00:1d.2: reg 20: [io  0x6f40-0x6f5f]
[    0.391424] pci 0000:00:1d.7: reg 10: [mem 0xfed1c000-0xfed1c3ff]
[    0.391507] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.391513] pci 0000:00:1d.7: PME# disabled
[    0.391720] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
[    0.391726] pci 0000:00:1f.0: quirk: [io  0x1080-0x10bf] claimed by ICH6 GPIO
[    0.391731] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0900 (mask 007f)
[    0.391738] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0c80 (mask 003f)
[    0.391804] pci 0000:00:1f.1: reg 10: [io  0x01f0-0x01f7]
[    0.391813] pci 0000:00:1f.1: reg 14: [io  0x03f4-0x03f7]
[    0.391823] pci 0000:00:1f.1: reg 18: [io  0x0170-0x0177]
[    0.391832] pci 0000:00:1f.1: reg 1c: [io  0x0374-0x0377]
[    0.391842] pci 0000:00:1f.1: reg 20: [io  0x6fa0-0x6faf]
[    0.391922] pci 0000:00:1f.2: reg 10: [io  0x6eb0-0x6eb7]
[    0.391932] pci 0000:00:1f.2: reg 14: [io  0x6eb8-0x6ebb]
[    0.391942] pci 0000:00:1f.2: reg 18: [io  0x6ec0-0x6ec7]
[    0.391951] pci 0000:00:1f.2: reg 1c: [io  0x6ec8-0x6ecb]
[    0.391961] pci 0000:00:1f.2: reg 20: [io  0x6ee0-0x6eff]
[    0.391971] pci 0000:00:1f.2: reg 24: [mem 0xf6dfb800-0xf6dfbfff]
[    0.392035] pci 0000:00:1f.2: PME# supported from D3hot
[    0.392041] pci 0000:00:1f.2: PME# disabled
[    0.392082] pci 0000:00:1f.3: reg 10: [mem 0xf6dfb700-0xf6dfb7ff]
[    0.392113] pci 0000:00:1f.3: reg 20: [io  0x10c0-0x10df]
[    0.392229] pci 0000:00:1c.0: PCI bridge to [bus 0b-0b]
[    0.392235] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.392241] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.392251] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.392385] pci 0000:0c:00.0: reg 10: [mem 0xf6cf0000-0xf6cfffff 64bit]
[    0.392497] pci 0000:0c:00.0: supports D1
[    0.392499] pci 0000:0c:00.0: PME# supported from D0 D1 D3hot
[    0.392506] pci 0000:0c:00.0: PME# disabled
[    0.392538] pci 0000:00:1c.1: PCI bridge to [bus 0c-0c]
[    0.392544] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
[    0.392550] pci 0000:00:1c.1:   bridge window [mem 0xf6c00000-0xf6cfffff]
[    0.392560] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.392639] pci 0000:00:1c.3: PCI bridge to [bus 0d-0e]
[    0.392645] pci 0000:00:1c.3:   bridge window [io  0xd000-0xdfff]
[    0.392651] pci 0000:00:1c.3:   bridge window [mem 0xf6a00000-0xf6bfffff]
[    0.392661] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
[    0.392806] pci 0000:09:00.0: reg 10: [mem 0xf69f0000-0xf69fffff 64bit]
[    0.392935] pci 0000:09:00.0: PME# supported from D3hot D3cold
[    0.392942] pci 0000:09:00.0: PME# disabled
[    0.392966] pci 0000:00:1c.5: PCI bridge to [bus 09-09]
[    0.392972] pci 0000:00:1c.5:   bridge window [io  0xf000-0x0000] (disabled)
[    0.392978] pci 0000:00:1c.5:   bridge window [mem 0xf6900000-0xf69fffff]
[    0.392988] pci 0000:00:1c.5:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.393073] pci 0000:03:01.0: reg 10: [mem 0x00000000-0x00000fff]
[    0.393109] pci 0000:03:01.0: supports D1 D2
[    0.393111] pci 0000:03:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.393118] pci 0000:03:01.0: PME# disabled
[    0.393170] pci 0000:03:01.4: reg 10: [mem 0xf68ff000-0xf68fffff]
[    0.393180] pci 0000:03:01.4: reg 14: [mem 0xf68fe800-0xf68fefff]
[    0.393247] pci 0000:03:01.4: supports D1 D2
[    0.393249] pci 0000:03:01.4: PME# supported from D0 D1 D2 D3hot D3cold
[    0.393255] pci 0000:03:01.4: PME# disabled
[    0.393343] pci 0000:00:1e.0: PCI bridge to [bus 03-04] (subtractive decode)
[    0.393349] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.393355] pci 0000:00:1e.0:   bridge window [mem 0xf6800000-0xf68fffff]
[    0.393365] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.393367] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.393370] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.393373] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.393375] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.393378] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xf7ffffff] (subtractive decode)
[    0.393381] pci 0000:00:1e.0:   bridge window [mem 0xfc000000-0xfebfffff] (subtractive decode)
[    0.393383] pci 0000:00:1e.0:   bridge window [mem 0xfec10000-0xfecfffff] (subtractive decode)
[    0.393386] pci 0000:00:1e.0:   bridge window [mem 0xfed1c000-0xfed1ffff] (subtractive decode)
[    0.393389] pci 0000:00:1e.0:   bridge window [mem 0xfed90000-0xfed9ffff] (subtractive decode)
[    0.393391] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
[    0.393394] pci 0000:00:1e.0:   bridge window [mem 0xfeda7000-0xfedfffff] (subtractive decode)
[    0.393397] pci 0000:00:1e.0:   bridge window [mem 0xfee10000-0xff9fffff] (subtractive decode)
[    0.393399] pci 0000:00:1e.0:   bridge window [mem 0xffc00000-0xffdfffff] (subtractive decode)
[    0.393465] pci_bus 0000:04: [bus 04-07] partially hidden behind transparent bridge 0000:03 [bus 03-04]
[    0.393512] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.394027] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[    0.394312] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.394423] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.394543] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    0.394675] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    0.426808] ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 *11)
[    0.426808] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *3
[    0.426808] ACPI: PCI Interrupt Link [LNKC] (IRQs 9 *10 11)
[    0.426808] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 9 10 *11)
[    0.426808] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.428174] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[    0.428348] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    0.428499] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.428604] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.428604] vgaarb: loaded
[    0.428604] SCSI subsystem initialized
[    0.428604] libata version 3.00 loaded.
[    0.428604] usbcore: registered new interface driver usbfs
[    0.428604] usbcore: registered new interface driver hub
[    0.428604] usbcore: registered new device driver usb
[    0.428604] ACPI: WMI: Mapper loaded
[    0.428604] PCI: Using ACPI for IRQ routing
[    0.428604] PCI: pci_cache_line_size set to 64 bytes
[    0.428604] reserve RAM buffer: 000000000009f000 - 000000000009ffff 
[    0.428604] reserve RAM buffer: 00000000df65a800 - 00000000dfffffff 
[    0.428604] Bluetooth: Core ver 2.15
[    0.428604] NET: Registered protocol family 31
[    0.428604] Bluetooth: HCI device and connection manager initialized
[    0.428604] Bluetooth: HCI socket layer initialized
[    0.428604] NetLabel: Initializing
[    0.428604] NetLabel:  domain hash size = 128
[    0.428604] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.428604] NetLabel:  unlabeled traffic allowed by default
[    0.432086] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.432086] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.432086] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.440053] Switching to clocksource tsc
[    0.467254] pnp: PnP ACPI init
[    0.467295] ACPI: bus type pnp registered
[    0.517913] pnp 00:0b: disabling [io  0x1000-0x1005] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    0.517918] pnp 00:0b: disabling [io  0x1008-0x100f] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    0.518164] pnp 00:0c: disabling [io  0x1006-0x1007] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    0.518167] pnp 00:0c: disabling [io  0x100a-0x1059] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    0.518171] pnp 00:0c: disabling [io  0x1060-0x107f] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    0.518174] pnp 00:0c: disabling [io  0x1010-0x102f] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    0.542362] pnp: PnP ACPI: found 14 devices
[    0.542365] ACPI: ACPI bus type pnp unregistered
[    0.542385] system 00:05: [io  0x0c80-0x0caf] has been reserved
[    0.542389] system 00:05: [io  0x0cc0-0x0cff] could not be reserved
[    0.542401] system 00:08: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.542412] system 00:0a: [io  0x0cb0-0x0cbb] has been reserved
[    0.542415] system 00:0a: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.542426] system 00:0b: [io  0x0900-0x097f] has been reserved
[    0.542429] system 00:0b: [io  0x04d0-0x04d1] has been reserved
[    0.542439] system 00:0c: [io  0xf400-0xf4fe] has been reserved
[    0.542443] system 00:0c: [io  0x1080-0x10bf] has been reserved
[    0.542446] system 00:0c: [io  0x10c0-0x10df] has been reserved
[    0.542449] system 00:0c: [io  0x0809] has been reserved
[    0.542459] system 00:0d: [mem 0x00000000-0x0009efff] could not be reserved
[    0.542463] system 00:0d: [mem 0x0009f000-0x0009ffff] could not be reserved
[    0.542466] system 00:0d: [mem 0x000c0000-0x000cffff] has been reserved
[    0.542469] system 00:0d: [mem 0x000e0000-0x000fffff] has been reserved
[    0.542472] system 00:0d: [mem 0x00100000-0xdf65a7ff] could not be reserved
[    0.542475] system 00:0d: [mem 0xdf65a800-0xdf6fffff] has been reserved
[    0.542478] system 00:0d: [mem 0xdf700000-0xdf7fffff] has been reserved
[    0.542482] system 00:0d: [mem 0xdf700000-0xdfefffff] could not be reserved
[    0.542485] system 00:0d: [mem 0xffe00000-0xffffffff] has been reserved
[    0.542488] system 00:0d: [mem 0xffa00000-0xffbfffff] has been reserved
[    0.542491] system 00:0d: [mem 0xfec00000-0xfec0ffff] could not be reserved
[    0.542494] system 00:0d: [mem 0xfee00000-0xfee0ffff] has been reserved
[    0.542497] system 00:0d: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.542501] system 00:0d: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.542504] system 00:0d: [mem 0xfeda0000-0xfeda3fff] has been reserved
[    0.542507] system 00:0d: [mem 0xfeda4000-0xfeda4fff] has been reserved
[    0.542510] system 00:0d: [mem 0xfeda5000-0xfeda5fff] has been reserved
[    0.542513] system 00:0d: [mem 0xfeda6000-0xfeda6fff] has been reserved
[    0.542516] system 00:0d: [mem 0xfed18000-0xfed1bfff] has been reserved
[    0.542519] system 00:0d: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.547840] PCI: max bus depth: 2 pci_try_num: 3
[    0.547921] pci 0000:00:1e.0: BAR 9: can't assign mem pref (size 0x4000000)
[    0.547925] pci 0000:00:1c.0: BAR 8: assigned [mem 0xf0200000-0xf03fffff]
[    0.547930] pci 0000:00:1c.0: BAR 9: assigned [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.547934] pci 0000:00:1c.1: BAR 9: assigned [mem 0xf0600000-0xf07fffff 64bit pref]
[    0.547939] pci 0000:00:1c.5: BAR 9: assigned [mem 0xf0800000-0xf09fffff 64bit pref]
[    0.547943] pci 0000:00:1c.0: BAR 7: assigned [io  0x2000-0x2fff]
[    0.547946] pci 0000:00:1c.1: BAR 7: assigned [io  0x3000-0x3fff]
[    0.547950] pci 0000:00:1c.5: BAR 7: assigned [io  0x4000-0x4fff]
[    0.547953] pci 0000:00:1e.0: BAR 7: assigned [io  0x5000-0x5fff]
[    0.547956] pci 0000:00:1c.0: PCI bridge to [bus 0b-0b]
[    0.547960] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.547968] pci 0000:00:1c.0:   bridge window [mem 0xf0200000-0xf03fffff]
[    0.547975] pci 0000:00:1c.0:   bridge window [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.547985] pci 0000:00:1c.1: PCI bridge to [bus 0c-0c]
[    0.547989] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.547997] pci 0000:00:1c.1:   bridge window [mem 0xf6c00000-0xf6cfffff]
[    0.548003] pci 0000:00:1c.1:   bridge window [mem 0xf0600000-0xf07fffff 64bit pref]
[    0.548013] pci 0000:00:1c.3: PCI bridge to [bus 0d-0e]
[    0.548017] pci 0000:00:1c.3:   bridge window [io  0xd000-0xdfff]
[    0.548025] pci 0000:00:1c.3:   bridge window [mem 0xf6a00000-0xf6bfffff]
[    0.548031] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
[    0.548041] pci 0000:00:1c.5: PCI bridge to [bus 09-09]
[    0.548046] pci 0000:00:1c.5:   bridge window [io  0x4000-0x4fff]
[    0.548053] pci 0000:00:1c.5:   bridge window [mem 0xf6900000-0xf69fffff]
[    0.548059] pci 0000:00:1c.5:   bridge window [mem 0xf0800000-0xf09fffff 64bit pref]
[    0.548079] pci 0000:03:01.0: BAR 9: can't assign mem pref (size 0x4000000)
[    0.548089] pci 0000:03:01.0: BAR 10: can't assign mem (size 0x4000000)
[    0.548092] pci 0000:03:01.0: BAR 0: assigned [mem 0xf6800000-0xf6800fff]
[    0.548100] pci 0000:03:01.0: BAR 0: set to [mem 0xf6800000-0xf6800fff] (PCI address [0xf6800000-0xf6800fff]
[    0.548104] pci 0000:03:01.0: BAR 7: assigned [io  0x5000-0x50ff]
[    0.548106] pci 0000:03:01.0: BAR 8: assigned [io  0x5400-0x54ff]
[    0.548109] pci 0000:03:01.0: CardBus bridge to [bus 04-07]
[    0.548111] pci 0000:03:01.0:   bridge window [io  0x5000-0x50ff]
[    0.548117] pci 0000:03:01.0:   bridge window [io  0x5400-0x54ff]
[    0.548124] pci 0000:00:1e.0: PCI bridge to [bus 03-04]
[    0.548128] pci 0000:00:1e.0:   bridge window [io  0x5000-0x5fff]
[    0.548136] pci 0000:00:1e.0:   bridge window [mem 0xf6800000-0xf68fffff]
[    0.548142] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.548151] PCI: No. 2 try to assign unassigned res
[    0.548220] pci 0000:00:1e.0: BAR 9: can't assign mem pref (size 0x4000000)
[    0.548223] pci 0000:00:1c.0: PCI bridge to [bus 0b-0b]
[    0.548227] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.548235] pci 0000:00:1c.0:   bridge window [mem 0xf0200000-0xf03fffff]
[    0.548241] pci 0000:00:1c.0:   bridge window [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.548251] pci 0000:00:1c.1: PCI bridge to [bus 0c-0c]
[    0.548255] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.548263] pci 0000:00:1c.1:   bridge window [mem 0xf6c00000-0xf6cfffff]
[    0.548270] pci 0000:00:1c.1:   bridge window [mem 0xf0600000-0xf07fffff 64bit pref]
[    0.548279] pci 0000:00:1c.3: PCI bridge to [bus 0d-0e]
[    0.548284] pci 0000:00:1c.3:   bridge window [io  0xd000-0xdfff]
[    0.548291] pci 0000:00:1c.3:   bridge window [mem 0xf6a00000-0xf6bfffff]
[    0.548298] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
[    0.548307] pci 0000:00:1c.5: PCI bridge to [bus 09-09]
[    0.548312] pci 0000:00:1c.5:   bridge window [io  0x4000-0x4fff]
[    0.548319] pci 0000:00:1c.5:   bridge window [mem 0xf6900000-0xf69fffff]
[    0.548326] pci 0000:00:1c.5:   bridge window [mem 0xf0800000-0xf09fffff 64bit pref]
[    0.548344] pci 0000:03:01.0: BAR 9: can't assign mem pref (size 0x4000000)
[    0.548354] pci 0000:03:01.0: BAR 10: can't assign mem (size 0x4000000)
[    0.548357] pci 0000:03:01.0: CardBus bridge to [bus 04-07]
[    0.548359] pci 0000:03:01.0:   bridge window [io  0x0000-0x00ff]
[    0.548366] pci 0000:03:01.0:   bridge window [io  0x0000-0x00ff]
[    0.548372] pci 0000:00:1e.0: PCI bridge to [bus 03-04]
[    0.548376] pci 0000:00:1e.0:   bridge window [io  0x5000-0x5fff]
[    0.548384] pci 0000:00:1e.0:   bridge window [mem 0xf6800000-0xf68fffff]
[    0.548390] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.548399] PCI: No. 3 try to assign unassigned res
[    0.548402] release child resource [mem 0xf6800000-0xf6800fff]
[    0.548404] release child resource [mem 0xf68fe800-0xf68fefff]
[    0.548406] release child resource [mem 0xf68ff000-0xf68fffff]
[    0.548409] pci 0000:00:1e.0: resource 8 [mem 0xf6800000-0xf68fffff] released
[    0.548411] pci 0000:00:1e.0: PCI bridge to [bus 03-04]
[    0.548413] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.548486] pci 0000:00:1e.0: BAR 9: can't assign mem pref (size 0x4000000)
[    0.548492] pci 0000:00:1e.0: BAR 8: can't assign mem (size 0x6000000)
[    0.548494] pci 0000:00:1c.0: PCI bridge to [bus 0b-0b]
[    0.548498] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.548506] pci 0000:00:1c.0:   bridge window [mem 0xf0200000-0xf03fffff]
[    0.548513] pci 0000:00:1c.0:   bridge window [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.548523] pci 0000:00:1c.1: PCI bridge to [bus 0c-0c]
[    0.548527] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.548535] pci 0000:00:1c.1:   bridge window [mem 0xf6c00000-0xf6cfffff]
[    0.548541] pci 0000:00:1c.1:   bridge window [mem 0xf0600000-0xf07fffff 64bit pref]
[    0.548551] pci 0000:00:1c.3: PCI bridge to [bus 0d-0e]
[    0.548555] pci 0000:00:1c.3:   bridge window [io  0xd000-0xdfff]
[    0.548562] pci 0000:00:1c.3:   bridge window [mem 0xf6a00000-0xf6bfffff]
[    0.548569] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
[    0.548579] pci 0000:00:1c.5: PCI bridge to [bus 09-09]
[    0.548583] pci 0000:00:1c.5:   bridge window [io  0x4000-0x4fff]
[    0.548590] pci 0000:00:1c.5:   bridge window [mem 0xf6900000-0xf69fffff]
[    0.548597] pci 0000:00:1c.5:   bridge window [mem 0xf0800000-0xf09fffff 64bit pref]
[    0.548615] pci 0000:03:01.0: BAR 9: can't assign mem pref (size 0x4000000)
[    0.548625] pci 0000:03:01.0: BAR 10: can't assign mem (size 0x4000000)
[    0.548628] pci 0000:03:01.0: BAR 0: assigned [mem 0x000a0000-0x000a0fff]
[    0.548635] pci 0000:03:01.0: BAR 0: set to [mem 0x000a0000-0x000a0fff] (PCI address [0xa0000-0xa0fff]
[    0.548638] pci 0000:03:01.4: BAR 0: assigned [mem 0x000a1000-0x000a1fff]
[    0.548645] pci 0000:03:01.4: BAR 0: set to [mem 0x000a1000-0x000a1fff] (PCI address [0xa1000-0xa1fff]
[    0.548648] pci 0000:03:01.4: BAR 1: assigned [mem 0x000a2000-0x000a27ff]
[    0.548654] pci 0000:03:01.4: BAR 1: set to [mem 0x000a2000-0x000a27ff] (PCI address [0xa2000-0xa27ff]
[    0.548657] pci 0000:03:01.0: CardBus bridge to [bus 04-07]
[    0.548659] pci 0000:03:01.0:   bridge window [io  0x0000-0x00ff]
[    0.548665] pci 0000:03:01.0:   bridge window [io  0x0000-0x00ff]
[    0.548672] pci 0000:00:1e.0: PCI bridge to [bus 03-04]
[    0.548676] pci 0000:00:1e.0:   bridge window [io  0x5000-0x5fff]
[    0.548684] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.548689] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.548722]   alloc irq_desc for 16 on node -1
[    0.548725]   alloc kstat_irqs on node -1
[    0.548731] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.548738] pci 0000:00:1c.0: setting latency timer to 64
[    0.548752]   alloc irq_desc for 17 on node -1
[    0.548754]   alloc kstat_irqs on node -1
[    0.548759] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.548765] pci 0000:00:1c.1: setting latency timer to 64
[    0.548778]   alloc irq_desc for 19 on node -1
[    0.548780]   alloc kstat_irqs on node -1
[    0.548785] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.548791] pci 0000:00:1c.3: setting latency timer to 64
[    0.548804] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.548810] pci 0000:00:1c.5: setting latency timer to 64
[    0.548821] pci 0000:00:1e.0: setting latency timer to 64
[    0.548835] pci 0000:03:01.0: enabling device (0000 -> 0003)
[    0.548839] pci 0000:03:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.548849] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.548851] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.548854] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.548856] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.548859] pci_bus 0000:00: resource 8 [mem 0xe0000000-0xf7ffffff]
[    0.548861] pci_bus 0000:00: resource 9 [mem 0xfc000000-0xfebfffff]
[    0.548863] pci_bus 0000:00: resource 10 [mem 0xfec10000-0xfecfffff]
[    0.548866] pci_bus 0000:00: resource 11 [mem 0xfed1c000-0xfed1ffff]
[    0.548868] pci_bus 0000:00: resource 12 [mem 0xfed90000-0xfed9ffff]
[    0.548870] pci_bus 0000:00: resource 13 [mem 0xfed40000-0xfed44fff]
[    0.548873] pci_bus 0000:00: resource 14 [mem 0xfeda7000-0xfedfffff]
[    0.548875] pci_bus 0000:00: resource 15 [mem 0xfee10000-0xff9fffff]
[    0.548877] pci_bus 0000:00: resource 16 [mem 0xffc00000-0xffdfffff]
[    0.548880] pci_bus 0000:0b: resource 0 [io  0x2000-0x2fff]
[    0.548882] pci_bus 0000:0b: resource 1 [mem 0xf0200000-0xf03fffff]
[    0.548885] pci_bus 0000:0b: resource 2 [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.548888] pci_bus 0000:0c: resource 0 [io  0x3000-0x3fff]
[    0.548890] pci_bus 0000:0c: resource 1 [mem 0xf6c00000-0xf6cfffff]
[    0.548893] pci_bus 0000:0c: resource 2 [mem 0xf0600000-0xf07fffff 64bit pref]
[    0.548895] pci_bus 0000:0d: resource 0 [io  0xd000-0xdfff]
[    0.548898] pci_bus 0000:0d: resource 1 [mem 0xf6a00000-0xf6bfffff]
[    0.548900] pci_bus 0000:0d: resource 2 [mem 0xf0000000-0xf01fffff 64bit pref]
[    0.548903] pci_bus 0000:09: resource 0 [io  0x4000-0x4fff]
[    0.548905] pci_bus 0000:09: resource 1 [mem 0xf6900000-0xf69fffff]
[    0.548908] pci_bus 0000:09: resource 2 [mem 0xf0800000-0xf09fffff 64bit pref]
[    0.548910] pci_bus 0000:03: resource 0 [io  0x5000-0x5fff]
[    0.548913] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    0.548915] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    0.548917] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    0.548920] pci_bus 0000:03: resource 7 [mem 0x000d0000-0x000dffff]
[    0.548922] pci_bus 0000:03: resource 8 [mem 0xe0000000-0xf7ffffff]
[    0.548925] pci_bus 0000:03: resource 9 [mem 0xfc000000-0xfebfffff]
[    0.548927] pci_bus 0000:03: resource 10 [mem 0xfec10000-0xfecfffff]
[    0.548930] pci_bus 0000:03: resource 11 [mem 0xfed1c000-0xfed1ffff]
[    0.548932] pci_bus 0000:03: resource 12 [mem 0xfed90000-0xfed9ffff]
[    0.548935] pci_bus 0000:03: resource 13 [mem 0xfed40000-0xfed44fff]
[    0.548937] pci_bus 0000:03: resource 14 [mem 0xfeda7000-0xfedfffff]
[    0.548939] pci_bus 0000:03: resource 15 [mem 0xfee10000-0xff9fffff]
[    0.548942] pci_bus 0000:03: resource 16 [mem 0xffc00000-0xffdfffff]
[    0.548944] pci_bus 0000:04: resource 0 [io  0x0000-0x00ff]
[    0.548947] pci_bus 0000:04: resource 1 [io  0x0000-0x00ff]
[    0.549011] NET: Registered protocol family 2
[    0.549297] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.551186] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.555945] TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
[    0.561254] TCP: Hash tables configured (established 524288 bind 65536)
[    0.561318] TCP reno registered
[    0.561368] UDP hash table entries: 2048 (order: 6, 262144 bytes)
[    0.561729] UDP-Lite hash table entries: 2048 (order: 6, 262144 bytes)
[    0.562259] NET: Registered protocol family 1
[    0.562292] pci 0000:00:02.0: Boot video device
[    0.562545] PCI: CLS 64 bytes, default 64
[    0.562705] Trying to unpack rootfs image as initramfs...
[    1.012130] Freeing initrd memory: 19964k freed
[    1.023340] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.023346] Placing 64MB software IO TLB between ffff8800028dc000 - ffff8800068dc000
[    1.023349] software IO TLB at phys 0x28dc000 - 0x68dc000
[    1.024849] Scanning for low memory corruption every 60 seconds
[    1.025398] audit: initializing netlink socket (disabled)
[    1.025447] type=2000 audit(1271601700.024:1): initialized
[    1.037692] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.042743] VFS: Disk quotas dquot_6.5.2
[    1.042896] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.044858] fuse init (API version 7.13)
[    1.045809] Btrfs loaded
[    1.045818] msgmni has been set to 7884
[    1.046480] alg: No test for stdrng (krng)
[    1.046509] io scheduler noop registered
[    1.046511] io scheduler deadline registered
[    1.046711] io scheduler cfq registered (default)
[    1.046972] pcieport 0000:00:1c.0: setting latency timer to 64
[    1.047049]   alloc irq_desc for 24 on node -1
[    1.047052]   alloc kstat_irqs on node -1
[    1.047068] pcieport 0000:00:1c.0: irq 24 for MSI/MSI-X
[    1.047373] pcieport 0000:00:1c.1: setting latency timer to 64
[    1.047432]   alloc irq_desc for 25 on node -1
[    1.047434]   alloc kstat_irqs on node -1
[    1.047446] pcieport 0000:00:1c.1: irq 25 for MSI/MSI-X
[    1.047733] pcieport 0000:00:1c.3: setting latency timer to 64
[    1.047792]   alloc irq_desc for 26 on node -1
[    1.047794]   alloc kstat_irqs on node -1
[    1.047806] pcieport 0000:00:1c.3: irq 26 for MSI/MSI-X
[    1.048089] pcieport 0000:00:1c.5: setting latency timer to 64
[    1.048147]   alloc irq_desc for 27 on node -1
[    1.048150]   alloc kstat_irqs on node -1
[    1.048162] pcieport 0000:00:1c.5: irq 27 for MSI/MSI-X
[    1.048566] pcieport 0000:00:1c.0: Requesting control of PCIe PME from ACPI BIOS
[    1.048579] pcieport 0000:00:1c.0: Failed to receive control of PCIe PME service: no _OSC support
[    1.048596] pcie_pme: probe of 0000:00:1c.0:pcie01 failed with error -13
[    1.048606] pcieport 0000:00:1c.1: Requesting control of PCIe PME from ACPI BIOS
[    1.048610] pcieport 0000:00:1c.1: Failed to receive control of PCIe PME service: no _OSC support
[    1.048615] pcie_pme: probe of 0000:00:1c.1:pcie01 failed with error -13
[    1.048623] pcieport 0000:00:1c.3: Requesting control of PCIe PME from ACPI BIOS
[    1.048627] pcieport 0000:00:1c.3: Failed to receive control of PCIe PME service: no _OSC support
[    1.048633] pcie_pme: probe of 0000:00:1c.3:pcie01 failed with error -13
[    1.048641] pcieport 0000:00:1c.5: Requesting control of PCIe PME from ACPI BIOS
[    1.048645] pcieport 0000:00:1c.5: Failed to receive control of PCIe PME service: no _OSC support
[    1.048650] pcie_pme: probe of 0000:00:1c.5:pcie01 failed with error -13
[    1.048777] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.049097] pciehp 0000:00:1c.0:pcie04: Bypassing BIOS check for pciehp use on 0000:00:1c.0
[    1.049182] pciehp 0000:00:1c.0:pcie04: HPC vendor_id 8086 device_id 283f ss_vid 1028 ss_did 1fe
[    1.049557] pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
[    1.049567] pciehp 0000:00:1c.1:pcie04: Bypassing BIOS check for pciehp use on 0000:00:1c.1
[    1.049582] pciehp 0000:00:1c.1:pcie04: HPC vendor_id 8086 device_id 2841 ss_vid 1028 ss_did 1fe
[    1.152017] pciehp 0000:00:1c.1:pcie04: Device 0000:0c:00.0 already exists at 0000:0c:00, cannot hot-add
[    1.152028] pciehp 0000:00:1c.1:pcie04: Cannot add device at 0000:0c:00
[    1.152036] pciehp 0000:00:1c.1:pcie04: service driver pciehp loaded
[    1.152046] pciehp 0000:00:1c.3:pcie04: Bypassing BIOS check for pciehp use on 0000:00:1c.3
[    1.152062] pciehp 0000:00:1c.3:pcie04: HPC vendor_id 8086 device_id 2845 ss_vid 1028 ss_did 1fe
[    1.152166] pciehp 0000:00:1c.3:pcie04: service driver pciehp loaded
[    1.152176] pciehp 0000:00:1c.5:pcie04: Bypassing BIOS check for pciehp use on 0000:00:1c.5
[    1.152192] pciehp 0000:00:1c.5:pcie04: HPC vendor_id 8086 device_id 2849 ss_vid 1028 ss_did 1fe
[    1.256016] pciehp 0000:00:1c.5:pcie04: Device 0000:09:00.0 already exists at 0000:09:00, cannot hot-add
[    1.256024] pciehp 0000:00:1c.5:pcie04: Cannot add device at 0000:09:00
[    1.256032] pciehp 0000:00:1c.5:pcie04: service driver pciehp loaded
[    1.256089] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.256684] ACPI: AC Adapter [AC] (on-line)
[    1.257132] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    1.257681] ACPI: Lid Switch [LID]
[    1.257804] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    1.257809] ACPI: Power Button [PBTN]
[    1.257943] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    1.257947] ACPI: Sleep Button [SBTN]
[    1.258840] Monitor-Mwait will be used to enter C-1 state
[    1.258887] Monitor-Mwait will be used to enter C-2 state
[    1.258921] Monitor-Mwait will be used to enter C-3 state
[    1.258931] Marking TSC unstable due to TSC halts in idle
[    1.259320] Switching to clocksource hpet
[    1.295772] thermal LNXTHERM:01: registered as thermal_zone0
[    1.295788] ACPI: Thermal Zone [THM] (82 C)
[    1.326786] Linux agpgart interface v0.103
[    1.326954] ipmi message handler version 39.2
[    1.326983] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.327453] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.330637] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.338000] brd: module loaded
[    1.340430] ACPI: Battery Slot [BAT0] (battery present)
[    1.340502] ACPI: Battery Slot [BAT1] (battery absent)
[    1.340887] loop: module loaded
[    1.341556] ahci 0000:00:1f.2: version 3.0
[    1.341578]   alloc irq_desc for 18 on node -1
[    1.341581]   alloc kstat_irqs on node -1
[    1.341589] ahci 0000:00:1f.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.341651]   alloc irq_desc for 28 on node -1
[    1.341653]   alloc kstat_irqs on node -1
[    1.341667] ahci 0000:00:1f.2: irq 28 for MSI/MSI-X
[    1.341759] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x5 impl SATA mode
[    1.341763] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc ems 
[    1.341769] ahci 0000:00:1f.2: setting latency timer to 64
[    1.348303] scsi0 : ahci
[    1.348683] scsi1 : ahci
[    1.348878] scsi2 : ahci
[    1.349384] ata1: SATA max UDMA/133 abar m2048@0xf6dfb800 port 0xf6dfb900 irq 28
[    1.349387] ata2: DUMMY
[    1.349390] ata3: SATA max UDMA/133 abar m2048@0xf6dfb800 port 0xf6dfba00 irq 28
[    1.349588] ata_piix 0000:00:1f.1: version 2.13
[    1.349598] ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.349648] ata_piix 0000:00:1f.1: setting latency timer to 64
[    1.349756] scsi3 : ata_piix
[    1.349945] scsi4 : ata_piix
[    1.352516] ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x6fa0 irq 14
[    1.352519] ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x6fa8 irq 15
[    1.352663] ata5: port disabled. ignoring.
[    1.353093] Fixed MDIO Bus: probed
[    1.353099] PPP generic driver version 2.4.2
[    1.353545] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.353579]   alloc irq_desc for 22 on node -1
[    1.353582]   alloc kstat_irqs on node -1
[    1.353588] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    1.353607] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.353612] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.354155] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    1.354209] ehci_hcd 0000:00:1a.7: debug port 1
[    1.358084] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    1.358166] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
[    1.372041] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.372957] hub 1-0:1.0: USB hub found
[    1.372965] hub 1-0:1.0: 4 ports detected
[    1.373340]   alloc irq_desc for 20 on node -1
[    1.373343]   alloc kstat_irqs on node -1
[    1.373349] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.373365] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.373370] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.373501] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    1.373537] ehci_hcd 0000:00:1d.7: debug port 1
[    1.377432] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    1.377452] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
[    1.392020] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.392279] hub 2-0:1.0: USB hub found
[    1.392286] hub 2-0:1.0: 6 ports detected
[    1.392521] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.392598] uhci_hcd: USB Universal Host Controller Interface driver
[    1.392729] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.392738] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.392742] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.392871] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    1.392902] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f20
[    1.393185] hub 3-0:1.0: USB hub found
[    1.393234] hub 3-0:1.0: 2 ports detected
[    1.393393]   alloc irq_desc for 21 on node -1
[    1.393395]   alloc kstat_irqs on node -1
[    1.393401] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.393409] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    1.393414] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.393522] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    1.393567] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f00
[    1.393844] hub 4-0:1.0: USB hub found
[    1.393852] hub 4-0:1.0: 2 ports detected
[    1.394034] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.394043] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.394047] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.394154] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    1.394189] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f80
[    1.394474] hub 5-0:1.0: USB hub found
[    1.394482] hub 5-0:1.0: 2 ports detected
[    1.394614] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.394623] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.394627] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.394731] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    1.394765] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f60
[    1.395045] hub 6-0:1.0: USB hub found
[    1.395052] hub 6-0:1.0: 2 ports detected
[    1.395182] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    1.395191] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.395195] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.395303] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    1.395334] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
[    1.395609] hub 7-0:1.0: USB hub found
[    1.395618] hub 7-0:1.0: 2 ports detected
[    1.395955] usbcore: registered new interface driver usbserial
[    1.396020] USB Serial support registered for generic
[    1.396101] usbcore: registered new interface driver usbserial_generic
[    1.396104] usbserial: USB Serial Driver core
[    1.396268] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.399402] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.399440] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.399989] mice: PS/2 mouse device common for all mice
[    1.400507] rtc_cmos 00:03: RTC can wake from S4
[    1.400839] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.400877] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.401026] WDT driver for Acquire single board computer initialising.
[    1.401176] acquirewdt: I/O address 0x0043 already in use
[    1.401187] acquirewdt: probe of acquirewdt failed with error -5
[    1.401427] device-mapper: uevent: version 1.0.3
[    1.401685] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
[    1.401805] device-mapper: multipath: version 1.1.1 loaded
[    1.401825] device-mapper: multipath round-robin: version 1.0.0 loaded
[    1.402766] cpuidle: using governor ladder
[    1.404025] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    1.404417] cpuidle: using governor menu
[    1.405335] TCP cubic registered
[    1.406011] NET: Registered protocol family 10
[    1.406913] lo: Disabled Privacy Extensions
[    1.407623] NET: Registered protocol family 17
[    1.407761] Bluetooth: L2CAP ver 2.14
[    1.407763] Bluetooth: L2CAP socket layer initialized
[    1.407788] Bluetooth: SCO (Voice Link) ver 0.6
[    1.407789] Bluetooth: SCO socket layer initialized
[    1.407868] Bluetooth: RFCOMM TTY layer initialized
[    1.407876] Bluetooth: RFCOMM socket layer initialized
[    1.407878] Bluetooth: RFCOMM ver 1.11
[    1.411788] PM: Resume from disk failed.
[    1.411815] registered taskstats version 1
[    1.412324]   Magic number: 6:955:687
[    1.412484] rtc_cmos 00:03: setting system clock to 2010-04-18 14:41:41 UTC (1271601701)
[    1.412488] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.412490] EDD information not available.
[    1.516705] ata4.00: ATAPI: Optiarc DVD+/-RW AD-5560A, DD11, max UDMA/33
[    1.532538] ata4.00: configured for UDMA/33
[    1.668254] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.668289] ata3: SATA link down (SStatus 0 SControl 300)
[    1.670300] ata1.00: ATA-8: ST9500420AS, 0002SDM1, max UDMA/133
[    1.670305] ata1.00: 976773168 sectors, multi 8: LBA48 NCQ (depth 31/32)
[    1.672760] ata1.00: configured for UDMA/133
[    1.689895] scsi 0:0:0:0: Direct-Access     ATA      ST9500420AS      0002 PQ: 0 ANSI: 5
[    1.690856] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    1.690952] sd 0:0:0:0: [sda] Write Protect is off
[    1.690955] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.690995] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.691491] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.691625]  sda:
[    1.692759] scsi 3:0:0:0: CD-ROM            Optiarc  DVD+-RW AD-5560A DD11 PQ: 0 ANSI: 5
[    1.696852]  sda1 sda2 <sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    1.699447] Uniform CD-ROM driver Revision: 3.20
[    1.700074] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    1.700335] sr 3:0:0:0: Attached scsi generic sg1 type 5
[    1.702805]  sda5 sda6 >
[    1.704163] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.704205] Freeing unused kernel memory: 812k freed
[    1.704504] Write protecting the kernel read-only data: 10240k
[    1.704748] Freeing unused kernel memory: 184k freed
[    1.705257] Freeing unused kernel memory: 1676k freed
[    1.957778] tg3.c:v3.108 (February 17, 2010)
[    1.957805] tg3 0000:09:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.957818] tg3 0000:09:00.0: setting latency timer to 64
[    1.964328] ohci1394 0000:03:01.4: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.979565] tg3 0000:09:00.0: eth0: Tigon3 [partno(BCM95755m) rev a002] (PCI Express) MAC address 00:22:19:e5:83:a2
[    1.979569] tg3 0000:09:00.0: eth0: attached PHY is 5755 (10/100/1000Base-T Ethernet) (WireSpeed[1])
[    1.979572] tg3 0000:09:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    1.979575] tg3 0000:09:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    2.022182] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[a1000-a17ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
[    2.128093] usb 7-1: new full speed USB device using uhci_hcd and address 2
[    2.202977] device fsid aa42dc58a86076ac-da4384233df9d5b0 devid 1 transid 90696 /dev/sda6
[    2.279532] hub 7-1:1.0: USB hub found
[    2.281459] hub 7-1:1.0: 4 ports detected
[    2.561437] usb 7-1.2: new full speed USB device using uhci_hcd and address 3
[    3.296510] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[384fc0001a532da1]
[   13.921976] Adding 4883756k swap on /dev/sda5.  Priority:-1 extents:1 across:4883756k 
[   15.282342] udev: starting version 151
[   15.869886] btrfs: unlinked 4 orphans
[   19.980609] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   19.990857] agpgart-intel 0000:00:00.0: Intel 965GM Chipset
[   19.992067] agpgart-intel 0000:00:00.0: detected 7676K stolen memory
[   19.997076] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[   20.797325] cfg80211: Calling CRDA to update world regulatory domain
[   20.827730] input: Dell WMI hotkeys as /devices/virtual/input/input4
[   21.745060] yenta_cardbus 0000:03:01.0: CardBus bridge found [1028:01fe]
[   21.745102] yenta_cardbus 0000:03:01.0: CardBus bridge to [bus 04-07]
[   21.745105] yenta_cardbus 0000:03:01.0:   bridge window [io  0x0000-0x00ff]
[   21.745112] yenta_cardbus 0000:03:01.0:   bridge window [io  0x0000-0x00ff]
[   21.745119] yenta_cardbus 0000:03:01.0:   bridge window [mem 0xf0c00000-0xf0ffffff]
[   21.745126] yenta_cardbus 0000:03:01.0:   bridge window [mem 0xf1000000-0xf13fffff]
[   21.745137] yenta_cardbus 0000:03:01.0: O2: enabling read prefetch/write burst
[   21.865661] input: DualPoint Stick as /devices/platform/i8042/serio1/input/input5
[   21.873968] yenta_cardbus 0000:03:01.0: ISA IRQ mask 0x0cb8, PCI irq 19
[   21.873973] yenta_cardbus 0000:03:01.0: Socket status: 30000006
[   21.873977] pci_bus 0000:03: Raising subordinate bus# of parent bus (#03) from #04 to #07
[   21.874070] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge window: [io  0x5000-0x5fff]
[   21.874074] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge window: [io  0x0000-0x0cf7]
[   21.874077] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge window: [io  0x0d00-0xffff]
[   21.874080] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge window: [mem 0x000a0000-0x000bffff]
[   21.874083] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0a0000-0x0bffff: excluding 0xa0000-0xa3fff
[   21.874134] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge window: [mem 0x000d0000-0x000dffff]
[   21.874137] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0d0000-0x0dffff: clean.
[   21.874154] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge window: [mem 0xe0000000-0xf7ffffff]
[   21.874157] pcmcia_socket pcmcia_socket0: cs: memory probe 0xe0000000-0xf7ffffff: excluding 0xe0000000-0xf17fffff 0xf6800000-0xf6ffffff
[   21.874246] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge window: [mem 0xfc000000-0xfebfffff]
[   21.874249] pcmcia_socket pcmcia_socket0: cs: memory probe 0xfc000000-0xfebfffff: clean.
[   21.874281] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge window: [mem 0xfec10000-0xfecfffff]
[   21.874284] pcmcia_socket pcmcia_socket0: cs: memory probe 0xfec10000-0xfecfffff: excluding 0xfecfe000-0xfed0bfff
[   21.874321] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge window: [mem 0xfed1c000-0xfed1ffff]
[   21.874324] pcmcia_socket pcmcia_socket0: cs: memory probe 0xfed1c000-0xfed1ffff: excluding 0xfed1c000-0xfed1dfff
[   21.874333] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge window: [mem 0xfed90000-0xfed9ffff]
[   21.874336] pcmcia_socket pcmcia_socket0: cs: memory probe 0xfed90000-0xfed9ffff: clean.
[   21.874355] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge window: [mem 0xfed40000-0xfed44fff]
[   21.874358] pcmcia_socket pcmcia_socket0: cs: memory probe 0xfed40000-0xfed44fff: excluding 0xfed40000-0xfed45fff
[   21.874368] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge window: [mem 0xfeda7000-0xfedfffff]
[   21.874371] pcmcia_socket pcmcia_socket0: cs: memory probe 0xfeda7000-0xfedfffff: excluding 0xfedff000-0xfee02fff
[   21.874425] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge window: [mem 0xfee10000-0xff9fffff]
[   21.874428] pcmcia_socket pcmcia_socket0: cs: memory probe 0xfee10000-0xff9fffff: excluding 0xff9f0000-0xffaadfff
[   21.874470] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge window: [mem 0xffc00000-0xffdfffff]
[   21.874473] pcmcia_socket pcmcia_socket0: cs: memory probe 0xffc00000-0xffdfffff: clean.
[   21.886832] input: AlpsPS/2 ALPS DualPoint TouchPad as /devices/platform/i8042/serio1/input/input6
[   22.430439] [drm] Initialized drm 1.1.0 20060810
[   23.074741] cfg80211: World regulatory domain updated:
[   23.074744]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   23.074747]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   23.074750]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   23.074752]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   23.074755]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   23.074758]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   23.247123] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   23.247130] i915 0000:00:02.0: setting latency timer to 64
[   23.348145]   alloc irq_desc for 29 on node -1
[   23.348149]   alloc kstat_irqs on node -1
[   23.348162] i915 0000:00:02.0: irq 29 for MSI/MSI-X
[   23.348172] [drm] set up 7M of stolen space
[   23.530582] kjournald starting.  Commit interval 5 seconds
[   23.531072] EXT3-fs (sda1): using internal journal
[   23.531209] EXT3-fs (sda1): mounted filesystem with writeback data mode
[   23.683017] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0c0000-0x0fffff: excluding 0xc0000-0xcffff 0xe0000-0xfffff
[   23.683160] pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0xa0ffffff: excluding 0xa0000000-0xa0ffffff
[   23.683296] pcmcia_socket pcmcia_socket0: cs: memory probe 0x60000000-0x60ffffff: excluding 0x60000000-0x60ffffff
[   23.783226] [drm] initialized overlay support
[   24.484654] fb0: inteldrmfb frame buffer device
[   24.484657] registered panic notifier
[   24.485732] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/LNXVIDEO:01/input/input7
[   24.485783] ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
[   24.485873] [Firmware Bug]: Duplicate ACPI video bus devices for the same VGA controller, please try module parameter "video.allow_duplicates=1"if the current driver doesn't work.
[   24.485978] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   24.609801] RPC: Registered udp transport module.
[   24.609806] RPC: Registered tcp transport module.
[   24.609808] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   24.610051] ath9k 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   24.610065] ath9k 0000:0c:00.0: setting latency timer to 64
[   24.741245] ath: EEPROM regdomain: 0x6a
[   24.741248] ath: EEPROM indicates we should expect a direct regpair map
[   24.741252] ath: Country alpha2 being used: 00
[   24.741254] ath: Regpair used: 0x6a
[   24.781627] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[   24.781747]   alloc irq_desc for 30 on node -1
[   24.781750]   alloc kstat_irqs on node -1
[   24.781766] HDA Intel 0000:00:1b.0: irq 30 for MSI/MSI-X
[   24.781813] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   25.001051] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input8
[   25.020687] input: HDA Intel Mic at Ext Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   25.020871] input: HDA Intel HP Out at Ext Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   25.251563] Console: switching to colour frame buffer device 240x75
[   25.400316] phy0: Selected rate control algorithm 'ath9k_rate_control'
[   25.402135] Registered led device: ath9k-phy0::radio
[   25.402226] Registered led device: ath9k-phy0::assoc
[   25.402297] Registered led device: ath9k-phy0::tx
[   25.402362] Registered led device: ath9k-phy0::rx
[   25.402371] phy0: Atheros AR5418 MAC/BB Rev:2 AR5133 RF Rev:81 mem=0xffffc900053a0000, irq=17
[   28.168470] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[  146.261768] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  146.276800]   alloc irq_desc for 31 on node -1
[  146.276805]   alloc kstat_irqs on node -1
[  146.276850] tg3 0000:09:00.0: irq 31 for MSI/MSI-X
[  146.313039] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  159.312669] wlan0: deauthenticating from 00:21:63:2f:fe:6f by local choice (reason=3)
[  159.321313] wlan0: authenticate with 00:21:63:2f:fe:6f (try 1)
[  159.359787] wlan0: authenticated
[  159.360039] wlan0: associate with 00:21:63:2f:fe:6f (try 1)
[  159.380406] wlan0: RX AssocResp from 00:21:63:2f:fe:6f (capab=0x411 status=0 aid=2)
[  159.380415] wlan0: associated
[  159.384752] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  170.349053] wlan0: no IPv6 routers present
