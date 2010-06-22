Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab0FVJKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 05:10:09 -0400
Received: from lider.pardus.org.tr ([193.140.100.216]:40243 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758954Ab0FVJJ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 05:09:59 -0400
From: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [BISECTED] Suspend regression in v2.6.31 with Lenovo 3000 v200
Date: Tue, 22 Jun 2010 12:09:25 +0300
User-Agent: KMail/1.13.3 (Linux/2.6.31.13-131-pae; KDE/4.4.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, rjw@sisk.pl
References: <Pine.LNX.4.44L0.1006211222470.1687-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1006211222470.1687-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006221209.26044.ozan@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pazartesi 21 Haziran 2010 günü (saat 19:25:30) Alan Stern şunları yazmıştı:
> On Mon, 21 Jun 2010, Ozan [utf-8] ÃaÄlayan wrote:

> 
> It may have been fixed already, depending on the device responsible.
> Or it may be possible to avoid the problem by changing a setting in
> sysfs.  Without the debug information I can't tell.
> 
> Alan Stern

Here's the debugged dmesg output. The second dmesg output is quiet similar to this, it's port 5
which causes the suspend to fail. I'll try to give you more details in case you want,

Thanks

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.31.13-131 (pardus@buildfarm) (gcc version 4.3.3 (Pardus Linux) ) #1 SMP Mon Jun 21 19:32:13 EEST 2010
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf6d0000 (usable)
[    0.000000]  BIOS-e820: 00000000bf6d0000 - 00000000bf6e3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf6e3000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] DMI present.
[    0.000000] last_pfn = 0xbf6d0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   1 base 000000000 mask F00000000 write-back
[    0.000000]   2 base 100000000 mask FC0000000 write-back
[    0.000000]   3 base 0BF800000 mask FFF800000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000bf800000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] e820 update range: 0000000000002000 - 0000000000006000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000002000 (usable)
[    0.000000]  modified: 0000000000002000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009f800 (usable)
[    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000bf6d0000 (usable)
[    0.000000]  modified: 00000000bf6d0000 - 00000000bf6e3000 (ACPI NVS)
[    0.000000]  modified: 00000000bf6e3000 - 00000000c0000000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  modified: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] initial memory mapped : 0 - 00c00000
[    0.000000] init_memory_mapping: 0000000000000000-00000000373fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037000000 page 2M
[    0.000000]  0037000000 - 00373fe000 page 4k
[    0.000000] kernel direct mapping tables up to 373fe000 @ 7000-d000
[    0.000000] RAMDISK: 37af1000 - 37fef772
[    0.000000] Allocated new RAMDISK: 007a7000 - 00ca5772
[    0.000000] Move RAMDISK from 0000000037af1000 - 0000000037fef771 to 007a7000 - 00ca5771
[    0.000000] ACPI: RSDP 000f7f00 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT bf6d742d 0007C (v01 LENOVO TP-65    06040000  LTP 00000000)
[    0.000000] ACPI: FACP bf6dfc3a 000F4 (v03 LENOVO TP-65    06040000 ALAN 00000001)
[    0.000000] ACPI: DSDT bf6d87ba 0740C (v02 LENOVO TP-65    06040000 MSFT 02000001)
[    0.000000] ACPI: FACS bf6e2fc0 00040
[    0.000000] ACPI: HPET bf6dfd2e 00038 (v01 INTEL  CRESTLNE 06040000 LOHR 0000005A)
[    0.000000] ACPI: MCFG bf6dfd66 0003C (v01 INTEL  CRESTLNE 06040000 LOHR 0000005A)
[    0.000000] ACPI: TCPA bf6dfda2 00032 (v01 Intel   CRESTLN 06040000      00005A52)
[    0.000000] ACPI: SLIC bf6dfdd4 00176 (v01 LENOVO TP-65    06040000 LNVO 00000001)
[    0.000000] ACPI: TMOR bf6dff4a 00026 (v01 PTLTD           06040000 PTL  00000003)
[    0.000000] ACPI: APIC bf6dff70 00068 (v01 PTLTD  	 APIC   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT bf6dffd8 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: SSDT bf6d84dd 002DD (v01 SataRe SataAhci 00001000 INTL 20061109)
[    0.000000] ACPI: SSDT bf6d8340 0019D (v01 BrtRef  DD01BRT 00001000 INTL 20061109)
[    0.000000] ACPI: SSDT bf6d74a9 004E6 (v01  PmRef    CpuPm 00003000 INTL 20061109)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 2178MB HIGHMEM available.
[    0.000000] 883MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 373fe000
[    0.000000]   low ram: 0 - 373fe000
[    0.000000]   node 0 low ram: 00000000 - 373fe000
[    0.000000]   node 0 bootmap 00009000 - 0000fe80
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00373fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 00007a2bcc]    TEXT DATA BSS ==> [0000100000 - 00007a2bcc]
[    0.000000]   #4 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
[    0.000000]   #5 [00007a3000 - 00007a6128]              BRK ==> [00007a3000 - 00007a6128]
[    0.000000]   #6 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
[    0.000000]   #7 [00007a7000 - 0000ca5772]      NEW RAMDISK ==> [00007a7000 - 0000ca5772]
[    0.000000]   #8 [0000009000 - 0000010000]          BOOTMAP ==> [0000009000 - 0000010000]
[    0.000000] found SMP MP-table at [c00f7fa0] f7fa0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000373fe
[    0.000000]   HighMem  0x000373fe -> 0x000bf6d0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000002
[    0.000000]     0: 0x00000006 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000bf6d0
[    0.000000] On node 0 totalpages: 783979
[    0.000000] free_area_init_node: node 0, pgdat c0663520, node_mem_map c1000000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3963 pages, LIFO batch:0
[    0.000000]   Normal zone: 1736 pages used for memmap
[    0.000000]   Normal zone: 220470 pages, LIFO batch:31
[    0.000000]   HighMem zone: 4358 pages used for memmap
[    0.000000]   HighMem zone: 553420 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000002000 - 0000000000006000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
[    0.000000] NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 14 pages at c2800000, static data 34492 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 777853
[    0.000000] Kernel command line: root=LABEL=PARDUS_ROOT resume=/dev/sda6 splash=silent quiet vga=0x317
[    0.000000] bootsplash: silent mode.
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] allocated 15681600 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Initializing HighMem for node 0 (000373fe:000bf6d0)
[    0.000000] Memory: 3082272k/3136320k available (3480k kernel code, 52756k reserved, 2076k data, 476k init, 2231112k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd55000 - 0xfffff000   (2728 kB)
[    0.000000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.000000]     vmalloc : 0xf7bfe000 - 0xff3fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf73fe000   ( 883 MB)
[    0.000000]       .init : 0xc066e000 - 0xc06e5000   ( 476 kB)
[    0.000000]       .data : 0xc046603b - 0xc066d170   (2076 kB)
[    0.000000]       .text : 0xc0100000 - 0xc046603b   (3480 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] NR_IRQS:1280
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2199.656 MHz processor.
[    0.000031] Console: colour dummy device 80x25
[    0.000033] console [tty0] enabled
[    0.000180] hpet clockevent registered
[    0.000183] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.000189] Calibrating delay loop (skipped), value calculated using timer frequency.. 4399.31 BogoMIPS (lpj=2199656)
[    0.000204] Security Framework initialized
[    0.000219] AppArmor: AppArmor initialized
[    0.000225] Mount-cache hash table entries: 512
[    0.000332] Initializing cgroup subsys ns
[    0.000336] Initializing cgroup subsys cpuacct
[    0.000340] Initializing cgroup subsys memory
[    0.000345] Initializing cgroup subsys devices
[    0.000347] Initializing cgroup subsys freezer
[    0.000363] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000365] CPU: L2 cache: 4096K
[    0.000367] CPU: Physical Processor ID: 0
[    0.000369] CPU: Processor Core ID: 0
[    0.000372] mce: CPU supports 6 MCE banks
[    0.000379] CPU0: Thermal monitoring handled by SMI
[    0.000382] using mwait in idle threads.
[    0.000388] Performance Counters: Core2 events, Intel PMU driver.
[    0.000394] ... version:                 2
[    0.000395] ... bit width:               40
[    0.000397] ... generic counters:        2
[    0.000398] ... value mask:              000000ffffffffff
[    0.000400] ... max period:              000000007fffffff
[    0.000401] ... fixed-purpose counters:  3
[    0.000403] ... counter mask:            0000000700000003
[    0.000406] Checking 'hlt' instruction... OK.
[    0.005078] ACPI: Core revision 20090521
[    0.015403] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.025754] CPU0: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0b
[    0.025996] Booting processor 1 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 4399.69 BogoMIPS (lpj=2199845)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 4096K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] mce: CPU supports 6 MCE banks
[    0.000999] CPU1: Thermal monitoring handled by SMI
[    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.097498] CPU1: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0b
[    0.097511] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.098042] Brought up 2 CPUs
[    0.098045] Total of 2 processors activated (8799.00 BogoMIPS).
[    0.098106] CPU0 attaching sched-domain:
[    0.098109]  domain 0: span 0-1 level MC
[    0.098111]   groups: 0 1
[    0.098115] CPU1 attaching sched-domain:
[    0.098117]  domain 0: span 0-1 level MC
[    0.098119]   groups: 1 0
[    0.098182] Booting paravirtualized kernel on bare hardware
[    0.099039] regulator: core version 0.5
[    0.099051] NET: Registered protocol family 16
[    0.099155] EISA bus registered
[    0.099168] ACPI: bus type pci registered
[    0.099230] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.099233] PCI: MCFG area at e0000000 reserved in E820
[    0.099234] PCI: Using MMCONFIG for extended config space
[    0.099236] PCI: Using configuration type 1 for base access
[    0.100182] bio: create slab <bio-0> at 0
[    0.100673] ACPI: EC: Look up EC in DSDT
[    0.103790] ACPI: BIOS _OSI(Linux) query ignored
[    0.117037] ACPI: Interpreter enabled
[    0.117043] ACPI: (supports S0 S3 S4 S5)
[    0.117062] ACPI: Using IOAPIC for interrupt routing
[    0.127287] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.128037] ACPI: Power Resource [PUBS] (on)
[    0.128303] ACPI: No dock devices found.
[    0.128988] ACPI Error (psargs-0359): [CDW1] Namespace lookup failure, AE_NOT_FOUND
[    0.128993] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f6c135b8), AE_NOT_FOUND
[    0.129019] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.129104] pci 0000:00:02.0: reg 10 64bit mmio: [0xf4000000-0xf40fffff]
[    0.129111] pci 0000:00:02.0: reg 18 64bit mmio: [0xd0000000-0xdfffffff]
[    0.129116] pci 0000:00:02.0: reg 20 io port: [0x1800-0x1807]
[    0.129154] pci 0000:00:02.1: reg 10 64bit mmio: [0xf4100000-0xf41fffff]
[    0.129266] pci 0000:00:1a.0: reg 20 io port: [0x1820-0x183f]
[    0.129286] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x003b
[    0.129288] pci 0000:00:1a.0: Performing full reset
[    0.129351] pci 0000:00:1a.1: reg 20 io port: [0x1840-0x185f]
[    0.129372] pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x0010
[    0.129374] pci 0000:00:1a.1: Performing full reset
[    0.129443] pci 0000:00:1a.7: reg 10 32bit mmio: [0xf4704800-0xf4704bff]
[    0.129520] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.129526] pci 0000:00:1a.7: PME# disabled
[    0.129581] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf4500000-0xf4503fff]
[    0.129644] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.129649] pci 0000:00:1b.0: PME# disabled
[    0.129735] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.129740] pci 0000:00:1c.0: PME# disabled
[    0.129830] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.129835] pci 0000:00:1c.1: PME# disabled
[    0.129924] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.129929] pci 0000:00:1c.2: PME# disabled
[    0.130000] pci 0000:00:1d.0: reg 20 io port: [0x1860-0x187f]
[    0.130020] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x003b
[    0.130022] pci 0000:00:1d.0: Performing full reset
[    0.130084] pci 0000:00:1d.1: reg 20 io port: [0x1880-0x189f]
[    0.130105] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0010
[    0.130106] pci 0000:00:1d.1: Performing full reset
[    0.130169] pci 0000:00:1d.2: reg 20 io port: [0x18a0-0x18bf]
[    0.130189] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0010
[    0.130191] pci 0000:00:1d.2: Performing full reset
[    0.130258] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf4704c00-0xf4704fff]
[    0.130306] pci 0000:00:1d.7: EHCI: BIOS handoff
[    1.230005] pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
[    1.230036] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.230042] pci 0000:00:1d.7: PME# disabled
[    1.230214] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[    1.230218] pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
[    1.230225] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0068 (mask 0007)
[    1.230282] pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
[    1.230290] pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
[    1.230298] pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
[    1.230306] pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
[    1.230314] pci 0000:00:1f.1: reg 20 io port: [0x1810-0x181f]
[    1.230391] pci 0000:00:1f.2: reg 10 io port: [0x1c00-0x1c07]
[    1.230399] pci 0000:00:1f.2: reg 14 io port: [0x18d4-0x18d7]
[    1.230407] pci 0000:00:1f.2: reg 18 io port: [0x18d8-0x18df]
[    1.230415] pci 0000:00:1f.2: reg 1c io port: [0x18d0-0x18d3]
[    1.230423] pci 0000:00:1f.2: reg 20 io port: [0x18e0-0x18ff]
[    1.230431] pci 0000:00:1f.2: reg 24 32bit mmio: [0xf4704000-0xf47047ff]
[    1.230475] pci 0000:00:1f.2: PME# supported from D3hot
[    1.230480] pci 0000:00:1f.2: PME# disabled
[    1.230514] pci 0000:00:1f.3: reg 10 32bit mmio: [0x000000-0x0000ff]
[    1.230539] pci 0000:00:1f.3: reg 20 io port: [0x1c20-0x1c3f]
[    1.230627] pci 0000:00:1c.0: bridge io port: [0x2000-0x2fff]
[    1.230632] pci 0000:00:1c.0: bridge 32bit mmio: [0xf2000000-0xf3ffffff]
[    1.230641] pci 0000:00:1c.0: bridge 64bit mmio pref: [0xf0000000-0xf1ffffff]
[    1.230866] pci 0000:05:00.0: reg 10 64bit mmio: [0xf4200000-0xf420ffff]
[    1.231104] pci 0000:05:00.0: PME# supported from D3hot D3cold
[    1.231116] pci 0000:05:00.0: PME# disabled
[    1.231618] pci 0000:00:1c.1: bridge 32bit mmio: [0xf4200000-0xf42fffff]
[    1.231718] pci 0000:06:00.0: reg 10 64bit mmio: [0xf4300000-0xf4301fff]
[    1.231837] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    1.231844] pci 0000:06:00.0: PME# disabled
[    1.234139] pci 0000:00:1c.2: bridge 32bit mmio: [0xf4300000-0xf43fffff]
[    1.234215] pci 0000:0a:09.0: reg 10 32bit mmio: [0xf4400000-0xf44007ff]
[    1.234291] pci 0000:0a:09.0: supports D1 D2
[    1.234293] pci 0000:0a:09.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.234298] pci 0000:0a:09.0: PME# disabled
[    1.234350] pci 0000:0a:09.1: reg 10 32bit mmio: [0xf4400800-0xf44008ff]
[    1.234425] pci 0000:0a:09.1: supports D1 D2
[    1.234427] pci 0000:0a:09.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.234433] pci 0000:0a:09.1: PME# disabled
[    1.234484] pci 0000:0a:09.2: reg 10 32bit mmio: [0xf4400c00-0xf4400cff]
[    1.234559] pci 0000:0a:09.2: supports D1 D2
[    1.234561] pci 0000:0a:09.2: PME# supported from D0 D1 D2 D3hot D3cold
[    1.234567] pci 0000:0a:09.2: PME# disabled
[    1.234618] pci 0000:0a:09.3: reg 10 32bit mmio: [0xf4401000-0xf44010ff]
[    1.234693] pci 0000:0a:09.3: supports D1 D2
[    1.234695] pci 0000:0a:09.3: PME# supported from D0 D1 D2 D3hot D3cold
[    1.234701] pci 0000:0a:09.3: PME# disabled
[    1.234763] pci 0000:00:1e.0: transparent bridge
[    1.234771] pci 0000:00:1e.0: bridge 32bit mmio: [0xf4400000-0xf44fffff]
[    1.234805] pci_bus 0000:00: on NUMA node 0
[    1.234809] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.235020] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    1.235090] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    1.235157] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    1.235252] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    1.235332] ACPI Error (psargs-0359): [CDW1] Namespace lookup failure, AE_NOT_FOUND
[    1.235337] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f6c135b8), AE_NOT_FOUND
[    1.245440] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 *5 6 7 10 12 14 15)
[    1.245533] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    1.245625] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    1.245715] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    1.245805] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    1.245896] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 *3 4 5 6 7 11 12 14 15)
[    1.245985] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 *4 5 6 7 10 12 14 15)
[    1.246077] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 *7 11 12 14 15)
[    1.246219] SCSI subsystem initialized
[    1.246227] libata version 3.00 loaded.
[    1.246227] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.246227] vgaarb: loaded
[    1.246227] usbcore: registered new interface driver usbfs
[    1.246227] usbcore: registered new interface driver hub
[    1.246227] usbcore: registered new device driver usb
[    1.246227] PCI: Using ACPI for IRQ routing
[    1.249015] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    1.249020] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    1.253006] Switched to high resolution mode on CPU 0
[    1.253575] Switched to high resolution mode on CPU 1
[    1.253906] AppArmor: AppArmor Filesystem Enabled
[    1.256257] pnp: PnP ACPI init
[    1.256265] ACPI: bus type pnp registered
[    1.260043] pnp: PnP ACPI: found 10 devices
[    1.260045] ACPI: ACPI bus type pnp unregistered
[    1.260048] PnPBIOS: Disabled by ACPI PNP
[    1.260056] system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    1.260059] system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
[    1.260062] system 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
[    1.260065] system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
[    1.260068] system 00:01: iomem range 0xe0000000-0xefffffff has been reserved
[    1.260071] system 00:01: iomem range 0xfed20000-0xfed3ffff has been reserved
[    1.260074] system 00:01: iomem range 0xfed45000-0xfed8ffff has been reserved
[    1.260083] system 00:06: iomem range 0xfed00000-0xfed003ff has been reserved
[    1.260089] system 00:08: ioport range 0x800-0x80f has been reserved
[    1.260092] system 00:08: ioport range 0x1000-0x107f has been reserved
[    1.260094] system 00:08: ioport range 0x1180-0x11bf has been reserved
[    1.260097] system 00:08: ioport range 0xfe00-0xfe00 has been reserved
[    1.294871] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    1.294875] pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
[    1.294882] pci 0000:00:1c.0:   MEM window: 0xf2000000-0xf3ffffff
[    1.294888] pci 0000:00:1c.0:   PREFETCH window: 0x000000f0000000-0x000000f1ffffff
[    1.294896] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:05
[    1.294898] pci 0000:00:1c.1:   IO window: disabled
[    1.294904] pci 0000:00:1c.1:   MEM window: 0xf4200000-0xf42fffff
[    1.294909] pci 0000:00:1c.1:   PREFETCH window: disabled
[    1.294914] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:06
[    1.294916] pci 0000:00:1c.2:   IO window: disabled
[    1.294923] pci 0000:00:1c.2:   MEM window: 0xf4300000-0xf43fffff
[    1.294927] pci 0000:00:1c.2:   PREFETCH window: disabled
[    1.294933] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0a
[    1.294934] pci 0000:00:1e.0:   IO window: disabled
[    1.294941] pci 0000:00:1e.0:   MEM window: 0xf4400000-0xf44fffff
[    1.294945] pci 0000:00:1e.0:   PREFETCH window: disabled
[    1.294960] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.294966] pci 0000:00:1c.0: setting latency timer to 64
[    1.294975] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.294980] pci 0000:00:1c.1: setting latency timer to 64
[    1.294990] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.294995] pci 0000:00:1c.2: setting latency timer to 64
[    1.295007] pci 0000:00:1e.0: setting latency timer to 64
[    1.295012] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    1.295014] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    1.295017] pci_bus 0000:02: resource 0 io:  [0x2000-0x2fff]
[    1.295019] pci_bus 0000:02: resource 1 mem: [0xf2000000-0xf3ffffff]
[    1.295021] pci_bus 0000:02: resource 2 pref mem [0xf0000000-0xf1ffffff]
[    1.295024] pci_bus 0000:05: resource 1 mem: [0xf4200000-0xf42fffff]
[    1.295026] pci_bus 0000:06: resource 1 mem: [0xf4300000-0xf43fffff]
[    1.295029] pci_bus 0000:0a: resource 1 mem: [0xf4400000-0xf44fffff]
[    1.295031] pci_bus 0000:0a: resource 3 io:  [0x00-0xffff]
[    1.295033] pci_bus 0000:0a: resource 4 mem: [0x000000-0xffffffff]
[    1.295059] NET: Registered protocol family 2
[    1.295131] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    1.295375] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.295703] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    1.295860] TCP: Hash tables configured (established 131072 bind 65536)
[    1.295862] TCP reno registered
[    1.295924] NET: Registered protocol family 1
[    1.295969] Unpacking initramfs...
[    1.436082] Freeing initrd memory: 5113k freed
[    1.438556] Simple Boot Flag at 0x35 set to 0x1
[    1.438717] cpufreq-nforce2: No nForce2 chipset.
[    1.438804] Scanning for low memory corruption every 60 seconds
[    1.438924] audit: initializing netlink socket (disabled)
[    1.438939] type=2000 audit(1277202026.438:1): initialized
[    1.447352] highmem bounce pool size: 64 pages
[    1.447356] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.448634] VFS: Disk quotas dquot_6.5.2
[    1.448684] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.449219] fuse init (API version 7.12)
[    1.449467] aufs 2-31
[    1.449472] msgmni has been set to 1674
[    1.449721] alg: No test for lzf (lzf-generic)
[    1.449778] alg: No test for stdrng (krng)
[    1.449820] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.449823] io scheduler noop registered
[    1.449824] io scheduler anticipatory registered
[    1.449826] io scheduler deadline registered
[    1.449860] io scheduler cfq registered (default)
[    1.449870] pci 0000:00:02.0: Boot video device
[    1.450016] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    1.450153] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    1.450284] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    1.450380] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.450438] ACPI Error (psargs-0359): [CDW1] Namespace lookup failure, AE_NOT_FOUND
[    1.450444] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f6c135b8), AE_NOT_FOUND
[    1.450508] ACPI Error (psargs-0359): [CDW1] Namespace lookup failure, AE_NOT_FOUND
[    1.450513] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f6c135b8), AE_NOT_FOUND
[    1.450568] ACPI Error (psargs-0359): [CDW1] Namespace lookup failure, AE_NOT_FOUND
[    1.450573] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f6c135b8), AE_NOT_FOUND
[    1.450641] ACPI Error (psargs-0359): [CDW1] Namespace lookup failure, AE_NOT_FOUND
[    1.450646] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f6c135b8), AE_NOT_FOUND
[    1.450700] ACPI Error (psargs-0359): [CDW1] Namespace lookup failure, AE_NOT_FOUND
[    1.450705] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f6c135b8), AE_NOT_FOUND
[    1.450758] ACPI Error (psargs-0359): [CDW1] Namespace lookup failure, AE_NOT_FOUND
[    1.450763] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f6c135b8), AE_NOT_FOUND
[    1.450799] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.450952] vesafb: framebuffer at 0xd0000000, mapped to 0xf7c80000, using 3072k, total 7616k
[    1.450954] vesafb: mode is 1024x768x16, linelength=2048, pages=3
[    1.450956] vesafb: scrolling: redraw
[    1.450959] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    1.451361] bootsplash 3.1.6-2004/03/31: looking for picture...
[    1.459479] bootsplash: silentjpeg size 48668 bytes
[    1.467752] bootsplash: ...found (1024x768, 37132 bytes, v3).
[    1.496170] Console: switching to colour frame buffer device 128x45
[    1.524867] fb0: VESA VGA frame buffer device
[    1.525792] ACPI: AC Adapter [ADP1] (on-line)
[    1.525867] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.525870] ACPI: Power Button [PWRF]
[    1.525919] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    1.527508] ACPI: Lid Switch [LID0]
[    1.527554] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    1.527560] ACPI: Sleep Button [SLPB]
[    1.528166] ACPI: SSDT bf6d7ffe 0027A (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    1.528603] ACPI: SSDT bf6d798f 005EA (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    1.529156] Monitor-Mwait will be used to enter C-1 state
[    1.529184] Monitor-Mwait will be used to enter C-2 state
[    1.529202] Monitor-Mwait will be used to enter C-3 state
[    1.529207] Marking TSC unstable due to TSC halts in idle
[    1.529228] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    1.529250] processor LNXCPU:00: registered as cooling_device0
[    1.529584] ACPI: SSDT bf6d8278 000C8 (v01  PmRef  Cpu1Ist 00003000 INTL 20061109)
[    1.529850] ACPI: SSDT bf6d7f79 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20061109)
[    1.530481] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    1.530498] processor LNXCPU:01: registered as cooling_device1
[    1.545039] thermal LNXTHERM:01: registered as thermal_zone0
[    1.545046] ACPI: Thermal Zone [TZS0] (63 C)
[    1.550525] thermal LNXTHERM:02: registered as thermal_zone1
[    1.550534] ACPI: Thermal Zone [TZS1] (62 C)
[    1.550597] isapnp: Scanning for PnP cards...
[    1.648519] ACPI: Battery Slot [BAT0] (battery present)
[    1.864351] isapnp: No Plug & Play device found
[    1.865367] Linux agpgart interface v0.103
[    1.865441] agpgart-intel 0000:00:00.0: Intel 965GM Chipset
[    1.866659] agpgart-intel 0000:00:00.0: detected 7676K stolen memory
[    1.869425] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    1.869499] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.870210] loop: module loaded
[    1.870266] input: Macintosh mouse button emulation as /devices/virtual/input/input3
[    1.870288] st: Version 20081215, fixed bufsize 32768, s/g segs 256
[    1.870363] Fixed MDIO Bus: probed
[    1.870386] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.870388] ehci_hcd: block sizes: qh 128 qtd 96 itd 160 sitd 96
[    1.870409] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.870419] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.870423] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.870439] drivers/usb/core/inode.c: creating file 'devices'
[    1.870442] drivers/usb/core/inode.c: creating file '001'
[    1.870445] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    1.870455] ehci_hcd 0000:00:1a.7: reset hcs_params 0x102204 dbg=1 cc=2 pcc=2 ordered !ppc ports=4
[    1.870460] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
[    1.870476] ehci_hcd 0000:00:1a.7: reset command 080032 (park)=0 ithresh=8 Async Periodic period=1024 Reset HALT
[    1.874364] ehci_hcd 0000:00:1a.7: debug port 1
[    1.874371] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    1.874373] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    1.874392] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf4704800
[    1.874397] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    1.878290] ehci_hcd 0000:00:1a.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    1.884018] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.884047] usb usb1: default language 0x0409
[    1.884054] usb usb1: udev 1, busnum 1, minor = 0
[    1.884056] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.884058] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.884061] usb usb1: Product: EHCI Host Controller
[    1.884062] usb usb1: Manufacturer: Linux 2.6.31.13-131 ehci_hcd
[    1.884065] usb usb1: SerialNumber: 0000:00:1a.7
[    1.884096] usb usb1: uevent
[    1.884105] usb usb1: usb_probe_device
[    1.884108] usb usb1: configuration #1 chosen from 1 choice
[    1.884113] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    1.884128] usb 1-0:1.0: uevent
[    1.884138] hub 1-0:1.0: usb_probe_interface
[    1.884140] hub 1-0:1.0: usb_probe_interface - got id
[    1.884142] hub 1-0:1.0: USB hub found
[    1.884148] hub 1-0:1.0: 4 ports detected
[    1.884150] hub 1-0:1.0: standalone hub
[    1.884151] hub 1-0:1.0: no power switching (usb 1.0)
[    1.884153] hub 1-0:1.0: individual port over-current protection
[    1.884155] hub 1-0:1.0: power on to power good time: 20ms
[    1.884159] hub 1-0:1.0: local power source is good
[    1.884161] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    1.884184] drivers/usb/core/inode.c: creating file '001'
[    1.884210] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.884219] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.884223] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.884228] drivers/usb/core/inode.c: creating file '002'
[    1.884231] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    1.884238] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    1.884243] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
[    1.884266] ehci_hcd 0000:00:1d.7: reset command 080032 (park)=0 ithresh=8 Async Periodic period=1024 Reset HALT
[    1.888155] ehci_hcd 0000:00:1d.7: debug port 1
[    1.888162] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    1.888164] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    1.888177] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf4704c00
[    1.888182] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    1.892053] ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    1.897018] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.897042] usb usb2: default language 0x0409
[    1.897048] usb usb2: udev 1, busnum 2, minor = 128
[    1.897050] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.897052] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.897055] usb usb2: Product: EHCI Host Controller
[    1.897057] usb usb2: Manufacturer: Linux 2.6.31.13-131 ehci_hcd
[    1.897059] usb usb2: SerialNumber: 0000:00:1d.7
[    1.897089] usb usb2: uevent
[    1.897097] usb usb2: usb_probe_device
[    1.897100] usb usb2: configuration #1 chosen from 1 choice
[    1.897105] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    1.897119] usb 2-0:1.0: uevent
[    1.897128] hub 2-0:1.0: usb_probe_interface
[    1.897130] hub 2-0:1.0: usb_probe_interface - got id
[    1.897132] hub 2-0:1.0: USB hub found
[    1.897137] hub 2-0:1.0: 6 ports detected
[    1.897139] hub 2-0:1.0: standalone hub
[    1.897140] hub 2-0:1.0: no power switching (usb 1.0)
[    1.897142] hub 2-0:1.0: individual port over-current protection
[    1.897144] hub 2-0:1.0: power on to power good time: 20ms
[    1.897148] hub 2-0:1.0: local power source is good
[    1.897150] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    1.897178] drivers/usb/core/inode.c: creating file '001'
[    1.897205] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.897207] ohci_hcd: block sizes: ed 64 td 64
[    1.897222] uhci_hcd: USB Universal Host Controller Interface driver
[    1.897260] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.897266] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.897270] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.897276] drivers/usb/core/inode.c: creating file '003'
[    1.897280] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    1.897288] uhci_hcd 0000:00:1a.0: detected 2 ports
[    1.897293] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    1.897295] uhci_hcd 0000:00:1a.0: Performing full reset
[    1.897323] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00001820
[    1.897350] usb usb3: default language 0x0409
[    1.897356] usb usb3: udev 1, busnum 3, minor = 256
[    1.897358] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.897361] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.897363] usb usb3: Product: UHCI Host Controller
[    1.897365] usb usb3: Manufacturer: Linux 2.6.31.13-131 uhci_hcd
[    1.897367] usb usb3: SerialNumber: 0000:00:1a.0
[    1.897399] usb usb3: uevent
[    1.897408] usb usb3: usb_probe_device
[    1.897410] usb usb3: configuration #1 chosen from 1 choice
[    1.897415] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    1.897427] usb 3-0:1.0: uevent
[    1.897436] hub 3-0:1.0: usb_probe_interface
[    1.897438] hub 3-0:1.0: usb_probe_interface - got id
[    1.897440] hub 3-0:1.0: USB hub found
[    1.897445] hub 3-0:1.0: 2 ports detected
[    1.897447] hub 3-0:1.0: standalone hub
[    1.897448] hub 3-0:1.0: no power switching (usb 1.0)
[    1.897450] hub 3-0:1.0: individual port over-current protection
[    1.897452] hub 3-0:1.0: power on to power good time: 2ms
[    1.897456] hub 3-0:1.0: local power source is good
[    1.897458] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    1.897470] drivers/usb/core/inode.c: creating file '001'
[    1.897499] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.897506] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    1.897509] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.897514] drivers/usb/core/inode.c: creating file '004'
[    1.897517] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    1.897525] uhci_hcd 0000:00:1a.1: detected 2 ports
[    1.897530] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    1.897532] uhci_hcd 0000:00:1a.1: Performing full reset
[    1.897559] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001840
[    1.897587] usb usb4: default language 0x0409
[    1.897594] usb usb4: udev 1, busnum 4, minor = 384
[    1.897596] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.897598] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.897600] usb usb4: Product: UHCI Host Controller
[    1.897602] usb usb4: Manufacturer: Linux 2.6.31.13-131 uhci_hcd
[    1.897604] usb usb4: SerialNumber: 0000:00:1a.1
[    1.897637] usb usb4: uevent
[    1.897646] usb usb4: usb_probe_device
[    1.897648] usb usb4: configuration #1 chosen from 1 choice
[    1.897653] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    1.897665] usb 4-0:1.0: uevent
[    1.897674] hub 4-0:1.0: usb_probe_interface
[    1.897676] hub 4-0:1.0: usb_probe_interface - got id
[    1.897678] hub 4-0:1.0: USB hub found
[    1.897683] hub 4-0:1.0: 2 ports detected
[    1.897685] hub 4-0:1.0: standalone hub
[    1.897686] hub 4-0:1.0: no power switching (usb 1.0)
[    1.897688] hub 4-0:1.0: individual port over-current protection
[    1.897690] hub 4-0:1.0: power on to power good time: 2ms
[    1.897693] hub 4-0:1.0: local power source is good
[    1.897695] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    1.897708] drivers/usb/core/inode.c: creating file '001'
[    1.898617] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    1.898623] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.898629] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.898632] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.898637] drivers/usb/core/inode.c: creating file '005'
[    1.898641] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    1.898649] uhci_hcd 0000:00:1d.0: detected 2 ports
[    1.898654] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    1.898656] uhci_hcd 0000:00:1d.0: Performing full reset
[    1.898671] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    1.898678] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001860
[    1.898705] usb usb5: default language 0x0409
[    1.898711] usb usb5: udev 1, busnum 5, minor = 512
[    1.898713] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.898715] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.898718] usb usb5: Product: UHCI Host Controller
[    1.898720] usb usb5: Manufacturer: Linux 2.6.31.13-131 uhci_hcd
[    1.898722] usb usb5: SerialNumber: 0000:00:1d.0
[    1.898754] usb usb5: uevent
[    1.898763] usb usb5: usb_probe_device
[    1.898765] usb usb5: configuration #1 chosen from 1 choice
[    1.898770] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    1.898782] usb 5-0:1.0: uevent
[    1.898792] hub 5-0:1.0: usb_probe_interface
[    1.898794] hub 5-0:1.0: usb_probe_interface - got id
[    1.898796] hub 5-0:1.0: USB hub found
[    1.898801] hub 5-0:1.0: 2 ports detected
[    1.898802] hub 5-0:1.0: standalone hub
[    1.898804] hub 5-0:1.0: no power switching (usb 1.0)
[    1.898806] hub 5-0:1.0: individual port over-current protection
[    1.898808] hub 5-0:1.0: power on to power good time: 2ms
[    1.898811] hub 5-0:1.0: local power source is good
[    1.898813] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    1.898826] drivers/usb/core/inode.c: creating file '001'
[    1.900070] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
[    1.900077] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.900083] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.900087] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.900092] drivers/usb/core/inode.c: creating file '006'
[    1.900095] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    1.900103] uhci_hcd 0000:00:1d.1: detected 2 ports
[    1.900108] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    1.900110] uhci_hcd 0000:00:1d.1: Performing full reset
[    1.900127] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    1.900140] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001880
[    1.900169] usb usb6: default language 0x0409
[    1.900175] usb usb6: udev 1, busnum 6, minor = 640
[    1.900178] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.900180] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.900182] usb usb6: Product: UHCI Host Controller
[    1.900184] usb usb6: Manufacturer: Linux 2.6.31.13-131 uhci_hcd
[    1.900186] usb usb6: SerialNumber: 0000:00:1d.1
[    1.900219] usb usb6: uevent
[    1.900227] usb usb6: usb_probe_device
[    1.900230] usb usb6: configuration #1 chosen from 1 choice
[    1.900235] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    1.900247] usb 6-0:1.0: uevent
[    1.900265] hub 6-0:1.0: usb_probe_interface
[    1.900267] hub 6-0:1.0: usb_probe_interface - got id
[    1.900269] hub 6-0:1.0: USB hub found
[    1.900274] hub 6-0:1.0: 2 ports detected
[    1.900276] hub 6-0:1.0: standalone hub
[    1.900277] hub 6-0:1.0: no power switching (usb 1.0)
[    1.900279] hub 6-0:1.0: individual port over-current protection
[    1.900281] hub 6-0:1.0: power on to power good time: 2ms
[    1.900285] hub 6-0:1.0: local power source is good
[    1.900287] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    1.900299] drivers/usb/core/inode.c: creating file '001'
[    1.900329] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.900335] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.900339] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.900345] drivers/usb/core/inode.c: creating file '007'
[    1.900348] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    1.900356] uhci_hcd 0000:00:1d.2: detected 2 ports
[    1.900361] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    1.900363] uhci_hcd 0000:00:1d.2: Performing full reset
[    1.900385] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018a0
[    1.900411] usb usb7: default language 0x0409
[    1.900418] usb usb7: udev 1, busnum 7, minor = 768
[    1.900420] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    1.900422] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.900425] usb usb7: Product: UHCI Host Controller
[    1.900426] usb usb7: Manufacturer: Linux 2.6.31.13-131 uhci_hcd
[    1.900429] usb usb7: SerialNumber: 0000:00:1d.2
[    1.900461] usb usb7: uevent
[    1.900470] usb usb7: usb_probe_device
[    1.900472] usb usb7: configuration #1 chosen from 1 choice
[    1.900477] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    1.900489] usb 7-0:1.0: uevent
[    1.900499] hub 7-0:1.0: usb_probe_interface
[    1.900501] hub 7-0:1.0: usb_probe_interface - got id
[    1.900502] hub 7-0:1.0: USB hub found
[    1.900508] hub 7-0:1.0: 2 ports detected
[    1.900509] hub 7-0:1.0: standalone hub
[    1.900511] hub 7-0:1.0: no power switching (usb 1.0)
[    1.900512] hub 7-0:1.0: individual port over-current protection
[    1.900514] hub 7-0:1.0: power on to power good time: 2ms
[    1.900518] hub 7-0:1.0: local power source is good
[    1.900520] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    1.900532] drivers/usb/core/inode.c: creating file '001'
[    1.900600] PNP: PS/2 Controller [PNP0303:KBD0,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.908316] i8042.c: Detected active multiplexing controller, rev 1.1.
[    1.917558] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.917564] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.917567] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.917570] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.917572] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.917620] mice: PS/2 mouse device common for all mice
[    1.918387] lirc_dev: IR Remote Control driver registered, major 252 
[    1.918411] rtc_cmos 00:09: RTC can wake from S4
[    1.918440] rtc_cmos 00:09: rtc core: registered rtc_cmos as rtc0
[    1.918470] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    1.918500] EISA: Probing bus 0 at eisa.0
[    1.918506] Cannot allocate resource for EISA slot 1
[    1.918508] Cannot allocate resource for EISA slot 2
[    1.918535] EISA: Detected 0 cards.
[    1.918643] cpuidle: using governor ladder
[    1.918750] cpuidle: using governor menu
[    1.918979] usbcore: registered new interface driver hiddev
[    1.918991] usbcore: registered new interface driver usbhid
[    1.918993] usbhid: v2.6:USB HID core driver
[    1.919300] NET: Registered protocol family 17
[    1.919895] Using IPI No-Shortcut mode
[    1.919943] TuxOnIce 3.1 (http://tuxonice.net)
[    1.919992] TuxOnIce: Ignoring late initcall, as requested.
[    1.940206] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    1.984138] ehci_hcd 0000:00:1a.7: GetStatus port 1 status 001803 POWER sig=j CSC CONNECT
[    1.984145] hub 1-0:1.0: port 1: status 0501 change 0001
[    1.997143] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
[    1.997149] hub 2-0:1.0: port 2: status 0501 change 0001
[    1.997168] ehci_hcd 0000:00:1d.7: GetStatus port 5 status 001803 POWER sig=j CSC CONNECT
[    1.997173] hub 2-0:1.0: port 5: status 0501 change 0001
[    1.997191] uhci_hcd 0000:00:1a.0: port 1 portsc 008a,00
[    1.997253] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.998338] uhci_hcd 0000:00:1d.0: port 2 portsc 008a,00
[    2.000127] Clocksource tsc unstable (delta = -71898849 ns)
[    2.000191] uhci_hcd 0000:00:1d.2: port 1 portsc 008a,00
[    2.000219] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    2.084205] hub 1-0:1.0: state 7 ports 4 chg 0002 evt 0000
[    2.084224] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    2.195073] ehci_hcd 0000:00:1a.7: port 1 full speed --> companion
[    2.195085] ehci_hcd 0000:00:1a.7: GetStatus port 1 status 003801 POWER OWNER sig=j CONNECT
[    2.195108] hub 1-0:1.0: port 1 not reset yet, waiting 50ms
[    2.246118] ehci_hcd 0000:00:1a.7: GetStatus port 1 status 003002 POWER OWNER sig=se0 CSC
[    2.246147] hub 2-0:1.0: state 7 ports 6 chg 0024 evt 0000
[    2.246156] hub 2-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[    2.297336] ehci_hcd 0000:00:1d.7: port 2 full speed --> companion
[    2.297347] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 003801 POWER OWNER sig=j CONNECT
[    2.297357] hub 2-0:1.0: port 2 not reset yet, waiting 50ms
[    2.348131] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
[    2.348173] hub 2-0:1.0: port 5, status 0501, change 0000, 480 Mb/s
[    2.399462] ehci_hcd 0000:00:1d.7: port 5 high speed
[    2.399474] ehci_hcd 0000:00:1d.7: GetStatus port 5 status 001005 POWER sig=se0 PE CONNECT
[    2.450062] usb 2-5: new high speed USB device using ehci_hcd and address 3
[    2.502338] ehci_hcd 0000:00:1d.7: port 5 high speed
[    2.502351] ehci_hcd 0000:00:1d.7: GetStatus port 5 status 001005 POWER sig=se0 PE CONNECT
[    2.572163] usb 2-5: default language 0x0409
[    2.573479] usb 2-5: udev 3, busnum 2, minor = 130
[    2.573487] usb 2-5: New USB device found, idVendor=0402, idProduct=5602
[    2.573493] usb 2-5: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    2.573499] usb 2-5: Product: USB2.0 Camera
[    2.573631] usb 2-5: uevent
[    2.573662] usb 2-5: usb_probe_device
[    2.573669] usb 2-5: configuration #1 chosen from 1 choice
[    2.573759] usb 2-5: adding 2-5:1.0 (config #1, interface 0)
[    2.573805] usb 2-5:1.0: uevent
[    2.573873] drivers/usb/core/inode.c: creating file '003'
[    2.573924] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    2.573943] uhci_hcd 0000:00:1a.0: port 1 portsc 0093,00
[    2.573958] hub 3-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[    2.677184] hub 3-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
[    2.779183] usb 3-1: new full speed USB device using uhci_hcd and address 2
[    2.899060] usb 3-1: ep0 maxpacket = 8
[    2.921379] usb 3-1: default language 0x0409
[    2.930377] usb 3-1: udev 2, busnum 3, minor = 257
[    2.930383] usb 3-1: New USB device found, idVendor=08ff, idProduct=1600
[    2.930390] usb 3-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    2.930396] usb 3-1: Product: Fingerprint Sensor
[    2.930511] usb 3-1: uevent
[    2.930541] usb 3-1: usb_probe_device
[    2.930548] usb 3-1: configuration #1 chosen from 1 choice
[    2.933381] usb 3-1: adding 3-1:1.0 (config #1, interface 0)
[    2.933426] usb 3-1:1.0: uevent
[    2.933493] drivers/usb/core/inode.c: creating file '002'
[    2.933541] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    2.933561] uhci_hcd 0000:00:1d.0: port 2 portsc 0093,00
[    2.933575] hub 5-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[    2.954164] usb usb4: suspend_rh (auto-stop)
[    2.954201] usb usb6: suspend_rh (auto-stop)
[    3.037154] hub 5-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
[    3.094398] Synaptics Touchpad, model: 1, fw: 6.3, id: 0x1c0b1, caps: 0xa04711/0xa00000
[    3.139071] usb 5-2: new full speed USB device using uhci_hcd and address 2
[    3.148250] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio2/input/input5
[    3.204176] usb usb7: suspend_rh (auto-stop)
[    3.260163] usb 5-2: ep0 maxpacket = 32
[    3.277154] registered taskstats version 1
[    3.277557] rtc_cmos 00:09: setting system clock to 2010-06-22 10:20:28 UTC (1277202028)
[    3.277698] Freeing unused kernel memory: 476k freed
[    3.278174] Write protecting the kernel text: 3484k
[    3.278297] Write protecting the kernel read-only data: 1636k
[    3.281162] initramfs: Starting init on initramfs
[    3.281735] usb 5-2: skipped 1 descriptor after interface
[    3.281744] usb 5-2: skipped 1 descriptor after interface
[    3.286727] usb 5-2: default language 0x0409
[    3.286990] initramfs: Calling coolplug to probe devices
[    3.297747] usb 5-2: udev 2, busnum 5, minor = 513
[    3.297754] usb 5-2: New USB device found, idVendor=046d, idProduct=c526
[    3.297761] usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.297767] usb 5-2: Product: USB Receiver
[    3.297772] usb 5-2: Manufacturer: Logitech
[    3.297888] usb 5-2: uevent
[    3.297918] usb 5-2: usb_probe_device
[    3.297925] usb 5-2: configuration #1 chosen from 1 choice
[    3.302745] usb 5-2: adding 5-2:1.0 (config #1, interface 0)
[    3.302784] usb 5-2:1.0: uevent
[    3.302814] usbhid 5-2:1.0: usb_probe_interface
[    3.302820] usbhid 5-2:1.0: usb_probe_interface - got id
[    3.304937] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2:1.0/input/input6
[    3.304991] generic-usb 0003:046D:C526.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1d.0-2/input0
[    3.305013] usb 5-2: adding 5-2:1.1 (config #1, interface 1)
[    3.305026] usb 5-2:1.1: uevent
[    3.305038] usbhid 5-2:1.1: usb_probe_interface
[    3.305040] usbhid 5-2:1.1: usb_probe_interface - got id
[    3.309815] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2:1.1/input/input7
[    3.309822] uhci_hcd 0000:00:1d.0: reserve dev 2 ep82-INT, period 1, phase 0, 26 us
[    3.309844] drivers/usb/core/file.c: looking for a minor, starting at 96
[    3.309888] generic-usb 0003:046D:C526.0002: input,hiddev96,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1d.0-2/input1
[    3.309901] drivers/usb/core/inode.c: creating file '002'
[    3.309917] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    3.309922] hub 1-0:1.0: state 7 ports 4 chg 0000 evt 0002
[    3.309930] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0004
[    3.379494] sdhci: Secure Digital Host Controller Interface driver
[    3.379497] sdhci: Copyright(c) Pierre Ossman
[    3.380516] sdhci-pci 0000:0a:09.1: SDHCI controller found [1180:0822] (rev 19)
[    3.380534] sdhci-pci 0000:0a:09.1: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[    3.382577] Registered led device: mmc0::
[    3.383623] mmc0: SDHCI controller on PCI [0000:0a:09.1] using PIO
[    3.385662] pata_acpi 0000:00:1f.1: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    3.385687] pata_acpi 0000:00:1f.1: setting latency timer to 64
[    3.385698] pata_acpi 0000:00:1f.1: PCI INT A disabled
[    3.388619] ata_piix 0000:00:1f.1: version 2.13
[    3.388626] ata_piix 0000:00:1f.1: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    3.388656] ata_piix 0000:00:1f.1: setting latency timer to 64
[    3.388754] scsi0 : ata_piix
[    3.388866] scsi1 : ata_piix
[    3.389439] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
[    3.389442] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
[    3.635616] ata1.00: ATAPI: HL-DT-ST DVDRAM GMA-4082N, ED01, max UDMA/33
[    3.688346] ata1.00: configured for UDMA/33
[    3.718581] scsi 0:0:0:0: CD-ROM            HL-DT-ST DVDRAM GMA-4082N ED01 PQ: 0 ANSI: 5
[    3.729649] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    3.729652] Uniform CD-ROM driver Revision: 3.20
[    3.729725] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    3.729771] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    3.733849] ahci 0000:00:1f.2: version 3.0
[    3.733863] ahci 0000:00:1f.2: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[    3.733932] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x7 impl SATA mode
[    3.733935] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part 
[    3.733940] ahci 0000:00:1f.2: setting latency timer to 64
[    3.734149] scsi2 : ahci
[    3.734227] scsi3 : ahci
[    3.734330] scsi4 : ahci
[    3.734430] ata3: SATA max UDMA/133 abar m2048@0xf4704000 port 0xf4704100 irq 18
[    3.734434] ata4: SATA max UDMA/133 abar m2048@0xf4704000 port 0xf4704180 irq 18
[    3.734437] ata5: SATA max UDMA/133 abar m2048@0xf4704000 port 0xf4704200 irq 18
[    4.039197] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.039238] ata4: SATA link down (SStatus 0 SControl 300)
[    4.039272] ata5: SATA link down (SStatus 0 SControl 300)
[    4.040535] ACPI Warning: \_SB_.PCI0.SATA.PRT0._GTF: Return type mismatch - found Integer, expected Buffer 20090521 nspredef-940
[    4.040556] ata3.00: _GTF unexpected object type 0x1
[    4.040763] ata3.00: ATA-8: HITACHI HTS542516K9SA00, BBCZC3HP, max UDMA/133
[    4.040770] ata3.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    4.042400] ata3.00: _GTF unexpected object type 0x1
[    4.042663] ata3.00: configured for UDMA/133
[    4.053331] scsi 2:0:0:0: Direct-Access     ATA      HITACHI HTS54251 BBCZ PQ: 0 ANSI: 5
[    4.053631] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    4.053686] sd 2:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    4.053800] sd 2:0:0:0: [sda] Write Protect is off
[    4.053807] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.053862] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.054140]  sda: sda1 sda2 < sda5 sda6 sda7 sda8 > sda3 sda4
[    4.121618] sd 2:0:0:0: [sda] Attached SCSI disk
[    4.136793] ohci1394 0000:0a:09.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.190255] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[16]  MMIO=[f4400000-f44007ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
[    4.276987] PM: Starting manual resume from disk
[    4.343584] TuxOnIce: No image found.
[    4.356167] initramfs: Mounting real root
[    4.615607] brd: module loaded
[    4.636985] initramfs: Module ext4 not found, probably built-in
[    4.645126] EXT4-fs (sda4): barriers enabled
[    4.653484] kjournald2 starting: pid 129, dev sda4:8, commit interval 5 seconds
[    4.653644] EXT4-fs (sda4): delayed allocation enabled
[    4.653650] EXT4-fs: file extents enabled
[    4.653970] EXT4-fs: mballoc enabled
[    4.653986] EXT4-fs (sda4): mounted filesystem with ordered data mode
[    4.654955] initramfs: Switching to the real root
[    4.704039] hub 4-0:1.0: hub_suspend
[    4.704048] usb usb4: bus auto-suspend
[    4.704052] usb usb4: suspend_rh
[    4.704072] hub 6-0:1.0: hub_suspend
[    4.704076] usb usb6: bus auto-suspend
[    4.704078] usb usb6: suspend_rh
[    5.452334] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[ffe40a00e2f0c9ff]
[    5.704062] hub 7-0:1.0: hub_suspend
[    5.704073] usb usb7: bus auto-suspend
[    5.704078] usb usb7: suspend_rh
[    5.704100] hub 1-0:1.0: hub_suspend
[    5.704105] usb usb1: bus auto-suspend
[    5.704109] ehci_hcd 0000:00:1a.7: suspend root hub
[    6.878368] udev: starting version 146
[    6.926706] usb usb3: uevent
[    6.926724] usb 3-0:1.0: uevent
[    6.926743] usb 3-1: uevent
[    6.926759] usb 3-1:1.0: uevent
[    6.926791] usb usb4: uevent
[    6.926807] usb 4-0:1.0: uevent
[    6.926839] usb usb1: uevent
[    6.926855] usb 1-0:1.0: uevent
[    6.927116] usb usb5: uevent
[    6.927132] usb 5-0:1.0: uevent
[    6.927152] usb 5-2: uevent
[    6.927170] usb 5-2:1.0: uevent
[    6.927283] usb 5-2:1.1: uevent
[    6.927418] usb usb6: uevent
[    6.927435] usb 6-0:1.0: uevent
[    6.927469] usb usb7: uevent
[    6.927485] usb 7-0:1.0: uevent
[    6.927517] usb usb2: uevent
[    6.927533] usb 2-0:1.0: uevent
[    6.927552] usb 2-5: uevent
[    6.927568] usb 2-5:1.0: uevent
[    6.969461] usb usb7: uevent
[    6.970856] usb usb2: uevent
[    6.972367] usb usb6: uevent
[    6.973758] usb usb5: uevent
[    6.976547] usb usb4: uevent
[    6.989870] usb usb1: uevent
[    6.994173] usb usb3: uevent
[    6.995877] usb 3-1: uevent
[    7.002144] usb 5-2: uevent
[    7.007632] usb 2-5: uevent
[    7.349937] usb 5-2:1.0: uevent
[    7.350043] usb 5-2: uevent
[    7.350782] usb 5-2:1.0: uevent
[    7.350859] usb 5-2: uevent
[    7.351264] usb 5-2:1.0: uevent
[    7.351734] usb 5-2:1.0: uevent
[    8.375213] tg3.c:v3.99 (April 20, 2009)
[    8.375277] tg3 0000:05:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    8.375292] tg3 0000:05:00.0: setting latency timer to 64
[    8.377097] tg3 0000:05:00.0: PME# disabled
[    8.406332] ACPI: WMI: Mapper loaded
[    8.434134] cfg80211: Using static regulatory domain info
[    8.434139] cfg80211: Regulatory domain: US
[    8.434141] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    8.434147] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    8.434151] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    8.434156] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    8.434161] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    8.434165] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    8.434170] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    8.434234] cfg80211: Calling CRDA for country: US
[    8.460610] eth0: Tigon3 [partno(BCM95906) rev c002] (PCI Express) MAC address 00:0a:e4:c9:f0:e2
[    8.460614] eth0: attached PHY is 5906 (10/100Base-TX Ethernet) (WireSpeed[0])
[    8.460618] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    8.460621] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    8.559888] iTCO_vendor_support: vendor-support=0
[    8.567536] input: PC Speaker as /devices/platform/pcspkr/input/input8
[    8.610416] usb 5-2:1.1: uevent
[    8.610531] usb 5-2: uevent
[    8.611961] usb 5-2:1.1: uevent
[    8.761660] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[    8.761752] iTCO_wdt: Found a ICH8M TCO device (Version=2, TCOBASE=0x1060)
[    8.761813] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    9.201161] Linux video capture interface: v2.00
[    9.256643] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27k
[    9.256646] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[    9.256715] iwlagn 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    9.256724] iwlagn 0000:06:00.0: setting latency timer to 64
[    9.256766] iwlagn 0000:06:00.0: Detected Intel Wireless WiFi Link 4965AGN REV=0x4
[    9.299558] iwlagn 0000:06:00.0: Tunable channels: 13 802.11bg, 19 802.11a channels
[    9.499048] gspca: main v2.9.0 registered
[    9.690882] phy0: Selected rate control algorithm 'iwl-agn-rs'
[    9.838986] ALi m5602 2-5:1.0: usb_probe_interface
[    9.838989] ALi m5602 2-5:1.0: usb_probe_interface - got id
[    9.838992] gspca: probing 0402:5602
[    9.838995] ALi m5602: Probing for a po1030 sensor
[    9.852853] ALi m5602: Probing for a mt9m111 sensor
[    9.869979] ALi m5602: Probing for a s5k4aa sensor
[    9.897729] ALi m5602: Detected a s5k4aa sensor
[    9.916437] cfg80211: Regulatory domain changed to country: US
[    9.916439] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    9.916442] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[    9.916445] 	(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[    9.916447] 	(5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    9.916449] 	(5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    9.916451] 	(5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    9.916454] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[    9.928790] gspca: video0 created
[    9.928825] usbcore: registered new interface driver ALi m5602
[    9.928830] ALi m5602: registered
[    9.963637] usb 2-5:1.0: uevent
[    9.963720] usb 2-5: uevent
[    9.965169] usb 2-5:1.0: uevent
[   10.223202] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   10.223248] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   10.340277] cfg80211: Calling CRDA for country: TR
[   10.342567] cfg80211: Regulatory domain changed to country: TR
[   10.342571] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   10.342575] 	(2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   10.342578] 	(5170000 KHz - 5250000 KHz @ 20000 KHz), (N/A, 2000 mBm)
[   10.342581] 	(5250000 KHz - 5330000 KHz @ 20000 KHz), (N/A, 2000 mBm)
[   10.955630] EXT4-fs (sda4): internal journal on sda4:8
[   11.174316] EXT4-fs (sda8): barriers enabled
[   11.182758] kjournald2 starting: pid 531, dev sda8:8, commit interval 5 seconds
[   11.183176] EXT4-fs (sda8): internal journal on sda8:8
[   11.183182] EXT4-fs (sda8): delayed allocation enabled
[   11.183187] EXT4-fs: file extents enabled
[   11.183263] EXT4-fs: mballoc enabled
[   11.183284] EXT4-fs (sda8): mounted filesystem with ordered data mode
[   11.211499] EXT4-fs (sda5): barriers enabled
[   11.219582] kjournald2 starting: pid 534, dev sda5:8, commit interval 5 seconds
[   11.219738] EXT4-fs (sda5): warning: maximal mount count reached, running e2fsck is recommended
[   11.220000] EXT4-fs (sda5): internal journal on sda5:8
[   11.220028] EXT4-fs (sda5): delayed allocation enabled
[   11.220033] EXT4-fs: file extents enabled
[   11.220769] EXT4-fs: mballoc enabled
[   11.220783] EXT4-fs (sda5): mounted filesystem with ordered data mode
[   11.256089] kjournald starting.  Commit interval 5 seconds
[   11.256097] EXT3-fs warning: checktime reached, running e2fsck is recommended
[   11.256374] EXT3 FS on sda7, internal journal
[   11.256381] EXT3-fs: mounted filesystem with writeback data mode.
[   11.569876] FAT: utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
[   11.652252] Adding 2273156k swap on /dev/sda6.  Priority:-1 extents:1 across:2273156k 
[   13.802873] tg3 0000:05:00.0: PME# disabled
[   15.029269] microcode: CPU0 sig=0x6fb, pf=0x80, revision=0xb6
[   15.029273] platform microcode: firmware: requesting intel-ucode/06-0f-0b
[   15.317428] microcode: CPU1 sig=0x6fb, pf=0x80, revision=0xb6
[   15.317440] platform microcode: firmware: requesting intel-ucode/06-0f-0b
[   15.349488] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   15.509741] tg3: eth0: Link is up at 100 Mbps, full duplex.
[   15.509741] tg3: eth0: Flow control is on for TX and on for RX.
[   17.903364] usb usb3: uevent
[   17.903467] usb 3-0:1.0: uevent
[   17.903516] usb 3-1: uevent
[   17.903593] usb 3-1:1.0: uevent
[   17.903675] usb usb4: uevent
[   17.903750] usb 4-0:1.0: uevent
[   17.903832] usb usb1: uevent
[   17.903923] usb 1-0:1.0: uevent
[   17.907540] usb usb5: uevent
[   17.907767] usb 5-0:1.0: uevent
[   17.907945] usb 5-2: uevent
[   17.908197] usb 5-2:1.0: uevent
[   17.909680] usb 5-2:1.1: uevent
[   17.910895] usb usb6: uevent
[   17.911159] usb 6-0:1.0: uevent
[   17.911460] usb usb7: uevent
[   17.911685] usb 7-0:1.0: uevent
[   17.911932] usb usb2: uevent
[   17.912181] usb 2-0:1.0: uevent
[   17.912322] usb 2-5: uevent
[   17.912546] usb 2-5:1.0: uevent
[   19.383381] bootsplash: status on console 0 changed to on
[   19.678736] NET: Registered protocol family 10
[   19.679260] lo: Disabled Privacy Extensions
[   19.837774] [drm] Initialized drm 1.1.0 20060810
[   20.043759] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   20.043765] pci 0000:00:02.0: setting latency timer to 64
[   20.045387] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[   20.045390] [drm] MTRR allocation failed.  Graphics performance may suffer.
[   20.062050] acpi device:04: registered as cooling_device2
[   20.062625] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/input/input9
[   20.063203] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   20.063267] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   22.996324] uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 17 us
[   30.314043] eth0: no IPv6 routers present
[   30.431324] usb usb1: uevent
[   30.431419] usb 1-0:1.0: uevent
[   30.431472] usb usb2: uevent
[   30.431551] usb 2-0:1.0: uevent
[   30.431602] usb usb3: uevent
[   30.431678] usb 3-0:1.0: uevent
[   30.431731] usb usb4: uevent
[   30.431807] usb 4-0:1.0: uevent
[   30.431858] usb usb5: uevent
[   30.431934] usb 5-0:1.0: uevent
[   30.431984] usb usb6: uevent
[   30.432162] usb 6-0:1.0: uevent
[   30.432214] usb usb7: uevent
[   30.432304] usb 7-0:1.0: uevent
[   30.432360] usb 2-5: uevent
[   30.432444] usb 2-5:1.0: uevent
[   30.432494] usb 3-1: uevent
[   30.432569] usb 3-1:1.0: uevent
[   30.432619] usb 5-2: uevent
[   30.432696] usb 5-2:1.0: uevent
[   30.432745] usb 5-2:1.1: uevent
[   76.955756] uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 17 us
[   79.101365] PM: Syncing filesystems ... done.
[   79.330189] Stopping fuse filesystems.
[   79.330196] Freezing user space processes ... (elapsed 0.01 seconds) done.
[   79.341097] Stopping normal filesystems.
[   79.493977] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[   79.494064] Suspending console(s) (use no_console_suspend to debug)
[   79.494450] pci 0000:00:02.0: PCI INT A disabled
[   79.511123] sd 2:0:0:0: [sda] Synchronizing SCSI cache
[   79.521382] sd 2:0:0:0: [sda] Stopping disk
[   80.017759] uhci_hcd 0000:00:1d.0: release dev 2 ep82-INT, period 1, phase 0, 26 us
[   80.019772] usb 5-2: usb suspend
[   80.031413] usb 3-1: usb suspend
[   80.042270] usb 2-5: usb suspend
[   80.048363] ehci_hcd 0000:00:1d.7: port 5 remote wakeup
[   80.546996] hub 5-0:1.0: hub_suspend
[   80.546999] usb usb5: bus suspend
[   80.547001] usb usb5: suspend_rh
[   80.547027] hub 3-0:1.0: hub_suspend
[   80.547030] usb usb3: bus suspend
[   80.547031] usb usb3: suspend_rh
[   80.547048] hub 2-0:1.0: hub_suspend
[   80.547050] usb usb2: bus suspend
[   80.547051] ehci_hcd 0000:00:1d.7: suspend root hub
[   80.547053] ehci_hcd 0000:00:1d.7: suspend failed because port 5 is resuming
[   80.547055] usb usb2: bus suspend fail, err -16
[   80.547057] hub 2-0:1.0: hub_resume
[   80.547100] ehci_hcd 0000:00:1d.7: GetStatus port 5 status 001005 POWER sig=se0 PE CONNECT
[   80.547103] hub 2-0:1.0: port 5: status 0503 change 0004
[   80.547112] pm_op(): usb_dev_suspend+0x0/0xf returns -16
[   80.547114] PM: Device usb2 failed to suspend: error -16
[   80.547115] PM: Some devices failed to suspend
[   80.547134] usb usb3: usb resume
[   80.547136] usb usb3: wakeup_rh
[   80.579101] hub 3-0:1.0: hub_resume
[   80.579112] hub 3-0:1.0: port 1: status 0107 change 0000
[   80.579127] usb usb5: usb resume
[   80.579130] usb usb5: wakeup_rh
[   80.611103] hub 5-0:1.0: hub_resume
[   80.611121] hub 5-0:1.0: port 2: status 0107 change 0000
[   80.619868] ehci_hcd 0000:00:1d.7: GetStatus port 5 status 001005 POWER sig=se0 PE CONNECT
[   80.619875] usb 2-5: finish resume
[   80.649411] usb 3-1: usb resume
[   80.675087] uhci_hcd 0000:00:1a.0: port 1 portsc 00a5,01
[   80.686076] usb 3-1: finish resume
[   80.688174] usb 5-2: usb resume
[   80.714145] uhci_hcd 0000:00:1d.0: port 2 portsc 00a5,01
[   80.725130] usb 5-2: finish resume
[   80.728160] uhci_hcd 0000:00:1d.0: reserve dev 2 ep82-INT, period 1, phase 0, 26 us
[   80.728181] sd 2:0:0:0: [sda] Starting disk
[   81.634117] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   81.634125] pci 0000:00:02.0: setting latency timer to 64
[   81.635274] usb usb1: usb resume
[   81.635277] ehci_hcd 0000:00:1a.7: resume root hub
[   81.676101] hub 1-0:1.0: hub_resume
[   81.676229] Restarting all filesystems ...
[   81.677853] Restarting tasks ... Restarting tasks ... 
[   81.678219] hub 2-0:1.0: state 7 ports 6 chg 0020 evt 0020
[   81.678226] hub 2-0:1.0: port 5, status 0503, change 0000, 480 Mb/s
[   81.678230] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   81.678233] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   81.678236] hub 1-0:1.0: state 7 ports 4 chg 0000 evt 0000
[   81.682245] done.
[   83.102319] uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 17 us
[   83.704079] hub 1-0:1.0: hub_suspend
[   83.704090] usb usb1: bus auto-suspend
[   83.704094] ehci_hcd 0000:00:1a.7: suspend root hub


---
Ozan Çağlayan
TUBITAK/UEKAE - Pardus Linux
http://www.pardus.org.tr/eng
