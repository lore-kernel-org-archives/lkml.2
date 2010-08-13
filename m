Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523Ab0HMTer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 15:34:47 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:52694 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494Ab0HMTeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 15:34:44 -0400
Date: Fri, 13 Aug 2010 12:34:42 -0700
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, hpa@zytor.com
Subject: BISECTED: 2.6.35 (and -git) fail to boot: APIC problems
Message-ID: <20100813193441.GD18691@ovro.caltech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Fri, 13 Aug 2010 12:34:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Eric,

I've recently tried to boot 2.6.35 (and -git) on one of my machines, and it
fails to boot. No messages are printed to the serial console. I have run git
bisect, and found that your commit cf7500c0ea133d is the cause.

Here is the output from the git bisect run:

git bisect start
# bad: [9fe6206f400646a2322096b56c59891d530e8d51] Linux 2.6.35
git bisect bad 9fe6206f400646a2322096b56c59891d530e8d51
# good: [e40152ee1e1c7a63f4777791863215e3faa37a86] Linus 2.6.34
git bisect good e40152ee1e1c7a63f4777791863215e3faa37a86
# bad: [e0bc5d4a54938eedcde14005210e6c08aa9727e4] Merge branch 'i2c-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging
git bisect bad e0bc5d4a54938eedcde14005210e6c08aa9727e4
# bad: [04afb40593f9a3007e5ea817d009529ef10fb685] Merge branch 'acpica' of git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6
git bisect bad 04afb40593f9a3007e5ea817d009529ef10fb685
# bad: [e4e47eb15b7884963efe7f98231009c5770a2c3d] Merge branch 'msm-core' of git://codeaurora.org/quic/kernel/dwalker/linux-msm
git bisect bad e4e47eb15b7884963efe7f98231009c5770a2c3d
# bad: [537b60d17894b7c19a6060feae40299d7109d6e7] Merge branch 'x86-uv-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect bad 537b60d17894b7c19a6060feae40299d7109d6e7
# good: [3de29cab1f8d62db557a4afed0fb17eebfe64438] perf record: Fix bug mismatch with -c option definition
git bisect good 3de29cab1f8d62db557a4afed0fb17eebfe64438
# good: [4d7b4ac22fbec1a03206c6cde353f2fd6942f828] Merge branch 'perf-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect good 4d7b4ac22fbec1a03206c6cde353f2fd6942f828
# good: [93c9d7f60c0cb7715890b1f9e159da6f4d1f5a65] Merge branch 'x86-atomic-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect good 93c9d7f60c0cb7715890b1f9e159da6f4d1f5a65
# good: [41d59102e146a4423a490b8eca68a5860af4fe1c] Merge branch 'x86-fpu-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect good 41d59102e146a4423a490b8eca68a5860af4fe1c
# bad: [cb41838bbc4403f7270a94b93a9a0d9fc9c2e7ea] Merge branch 'core-hweight-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect bad cb41838bbc4403f7270a94b93a9a0d9fc9c2e7ea
# bad: [7716a5c4ff5f1f3dc5e9edcab125cbf7fceef0af] x86, ioapic: Move nr_ioapic_registers calculation to mp_register_ioapic.
git bisect bad 7716a5c4ff5f1f3dc5e9edcab125cbf7fceef0af
# good: [0fd52670fb6400be0996ac492b5ed77f3d83d69a] x86, acpi/irq: Generalize mp_config_acpi_legacy_irqs
git bisect good 0fd52670fb6400be0996ac492b5ed77f3d83d69a
# good: [eddb0c55a14074d6bac8c2ef169aefd7e2c6f139] x86, ioapic: Fix the types of gsi values
git bisect good eddb0c55a14074d6bac8c2ef169aefd7e2c6f139
# bad: [cf7500c0ea133d66f8449d86392d83f840102632] x86, ioapic: In mpparse use mp_register_ioapic
git bisect bad cf7500c0ea133d66f8449d86392d83f840102632
# good: [5777372af5c929b8f3c706ed7b295b7279537c88] x86, ioapic: Teach mp_register_ioapic to compute a global gsi_end
git bisect good 5777372af5c929b8f3c706ed7b295b7279537c88


And here is what git bisect told me when it was done. It is snipped
down, since I'm sure you can look up the commit message yourself.

cf7500c0ea133d66f8449d86392d83f840102632 is the first bad commit
commit cf7500c0ea133d66f8449d86392d83f840102632
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Tue Mar 30 01:07:11 2010 -0700

    x86, ioapic: In mpparse use mp_register_ioapic

[snip commit message]

    Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
    LKML-Reference: <1269936436-7039-10-git-send-email-ebiederm@xmission.com>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

:040000 040000 6125cb7d9b0d66175e81f7081f2ae4ff59ca0254 5cc6ef21dbec694043fd0a245701a8e5c491d665 M	arch


I tried reverting the commit with "git revert", but it asks me to fix it
up by hand. After doing so, the system starts to boot, but eventually
hangs before starting userspace. Here is the serial console output from
that situation. Note the "IOAPIC[1]: Invalid reference to IRQ 0"
message. That was probably caused by the revert.

[    0.000000] Linux version 2.6.35-07788-g320b2b8-dirty (iws@rena) (gcc version 4.3.4 (Gentoo 4.3.4 p1.0, pie-10.1.5) ) #32 Fri Aug 13 10:54:17 PDT 2010
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 000000000009f800 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000040000000 (usable)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec02000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!
[    0.000000] DMI 2.3 present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x40000 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] Warning only 895MB will be used.
[    0.000000] Use a HIGHMEM enabled kernel.
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009f400 (usable)
[    0.000000]  modified: 000000000009f400 - 000000000009f800 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 0000000040000000 (usable)
[    0.000000]  modified: 00000000fec00000 - 00000000fec02000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 01800000
[    0.000000] found SMP MP-table at [c00ff780] ff780
[    0.000000] init_memory_mapping: 0000000000000000-0000000037fa1000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037c00000 page 2M
[    0.000000]  0037c00000 - 0037fa1000 page 4k
[    0.000000] kernel direct mapping tables up to 37fa1000 @ 10000-15000
[    0.000000] RAMDISK: 3ff25000 - 3ffdf000
[    0.000000] Allocated new RAMDISK: 00100000 - 001b9e5a
[    0.000000] Move RAMDISK from 000000003ff25000 - 000000003ffdee59 to 00100000 - 001b9e59
[    0.000000] ACPI Error: A valid RSDP was not found (20100702/tbxfroot-219)
[    0.000000] 895MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 37fa1000
[    0.000000]   low ram: 0 - 37fa1000
[    0.000000]   node 0 low ram: 00000000 - 37fa1000
[    0.000000]   node 0 bootmap 00011000 - 00017ff8
[    0.000000] (10/32 early reservations) ==> bootmem [0000000000 - 0037fa1000]
[    0.000000]   #0 [0001000000 - 000139d25c]    TEXT DATA BSS ==> [0001000000 - 000139d25c]
[    0.000000]   #1 [000139e000 - 00013a41dc]              BRK ==> [000139e000 - 00013a41dc]
[    0.000000]   #2 [00000ff790 - 0000100000]    BIOS reserved ==> [00000ff790 - 0000100000]
[    0.000000]   #3 [00000ff780 - 00000ff790]     MP-table mpf ==> [00000ff780 - 00000ff790]
[    0.000000]   #4 [000009f000 - 00000f0d70]    BIOS reserved ==> [000009f000 - 00000f0d70]
[    0.000000]   #5 [00000f0e70 - 00000ff780]    BIOS reserved ==> [00000f0e70 - 00000ff780]
[    0.000000]   #6 [00000f0d70 - 00000f0e70]     MP-table mpc ==> [00000f0d70 - 00000f0e70]
[    0.000000]   #7 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
[    0.000000]   #8 [0000100000 - 00001ba000]      NEW RAMDISK ==> [0000100000 - 00001ba000]
[    0.000000]   #9 [0000011000 - 0000018000]          BOOTMAP ==> [0000011000 - 0000018000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00037fa1
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x00037fa1
[    0.000000] On node 0 totalpages: 229168
[    0.000000] free_area_init_node: node 0, pgdat c1311764, node_mem_map c13a5200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223425 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] Intel MultiProcessor Specification v1.1
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000] MPTABLE: OEM ID: AMI
[    0.000000] MPTABLE: Product ID: CNB30LE
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] I/O APIC #4 Version 17 at 0xFEC00000.
[    0.000000] I/O APIC #5 Version 17 at 0xFEC01000.
[    0.000000] Processors: 1
[    0.000000] nr_irqs_gsi: 16
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:bec00000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 227376
[    0.000000] Kernel command line: initrd=initramfs-generic-i686.cpio.gz ignore_loglevel root=/dev/nfs ro console=ttyS0,115200 BOOT_IMAGE=bzImage-canbus-35re
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 904228k/917124k available (2048k kernel code, 12444k reserved, 1108k data, 292k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa3000 - 0xfffff000   ( 368 kB)
[    0.000000]     vmalloc : 0xf87a1000 - 0xfffa1000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf7fa1000   ( 895 MB)
[    0.000000]       .init : 0xc1316000 - 0xc135f000   ( 292 kB)
[    0.000000]       .data : 0xc1200333 - 0xc13154fc   (1108 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1200333   (2048 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:288
[    0.000000] CPU 0 irqstacks, hard=c12e9000 soft=c12ea000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 999.622 MHz processor.
[    0.012009] Calibrating delay loop (skipped), value calculated using timer frequency.. 1999.24 BogoMIPS (lpj=3998488)
[    0.020005] pid_max: default: 32768 minimum: 301
[    0.024037] Mount-cache hash table entries: 512
[    0.028238] CPU serial number disabled.
[    0.032009] mce: CPU supports 5 MCE banks
[    0.036029] Performance Events: p6 PMU driver.
[    0.041409] ... version:                0
[    0.044004] ... bit width:              32
[    0.048004] ... generic registers:      2
[    0.052004] ... value mask:             00000000ffffffff
[    0.056004] ... max period:             000000007fffffff
[    0.060004] ... fixed-purpose events:   0
[    0.064004] ... event mask:             0000000000000003
[    0.068004] CPU: Intel Pentium III (Coppermine) stepping 0a
[    0.076551] Enabling APIC mode:  Flat.  Using 2 I/O APICs
[    0.080017] ExtINT not setup in hardware but reported by MP table
[    0.084190] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.088000] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.088000] ...trying to set up timer (IRQ0) through the 8259A ...
[    0.088000] ..... (found apic 0 pin 0) ...
[    0.129995] ....... works.
[    0.240086] devtmpfs: initialized
[    0.243897] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.244130] NET: Registered protocol family 16
[    0.252406] PCI: PCI BIOS revision 2.10 entry at 0xfdbb1, last bus=1
[    0.256005] PCI: Using configuration type 1 for base access
[    0.265020] bio: create slab <bio-0> at 0
[    0.268444] ACPI: Interpreter disabled.
[    0.272258] vgaarb: loaded
[    0.276261] LinuxPPS API ver. 1 registered
[    0.280014] Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.284113] PCI: Probing PCI hardware
[    0.288016] PCI: Probing PCI hardware (bus 00)
[    0.292111] * The chipset may have PM-Timer Bug. Due to workarounds for a bug,
[    0.292115] * this clock source is slow. If you are sure your timer does not have
[    0.292120] * this bug, please use "acpi_pm_good" to disable the workaround
[    0.296024] pci 0000:00:00.0: CNB20LE PCI Host Bridge (domain 0000 [bus 00])
[    0.300006] pci 0000:00:00.0: host bridge window [io  0x01f0-0x01f7]
[    0.304005] pci 0000:00:00.0: host bridge window [io  0x03f6]
[    0.308005] pci 0000:00:00.0: host bridge window [io  0x0170-0x0177]
[    0.312005] pci 0000:00:00.0: host bridge window [io  0x0376]
[    0.316005] pci 0000:00:00.0: host bridge window [io  0xffa0-0xffaf]
[    0.320005] pci 0000:00:00.0: host bridge window [mem 0xfc200000-0xfeafffff]
[    0.324006] pci 0000:00:00.0: host bridge window [mem 0xfc000000-0xfc0fffff pref]
[    0.328005] pci 0000:00:00.0: host bridge window [io  0xd000-0xdffc]
[    0.332040] * The chipset may have PM-Timer Bug. Due to workarounds for a bug,
[    0.332044] * this clock source is slow. If you are sure your timer does not have
[    0.332048] * this bug, please use "acpi_pm_good" to disable the workaround
[    0.336010] pci 0000:00:00.1: CNB20LE PCI Host Bridge (domain 0000 [bus 01])
[    0.340006] pci 0000:00:00.1: host bridge window [mem 0xfeb00000-0xfebfffff]
[    0.344005] pci 0000:00:00.1: host bridge window [mem 0xfc100000-0xfc1fffff pref]
[    0.348005] pci 0000:00:00.1: host bridge window [io  0xe000-0xeffc]
[    0.352053] pci 0000:00:05.0: reg 10: [mem 0xfe2bd000-0xfe2bdfff]
[    0.356011] pci 0000:00:05.0: reg 14: [io  0xde80-0xdebf]
[    0.360011] pci 0000:00:05.0: reg 18: [mem 0xfcf00000-0xfcffffff]
[    0.364025] pci 0000:00:05.0: reg 30: [mem 0xfce00000-0xfcefffff pref]
[    0.368017] pci 0000:00:05.0: supports D1 D2
[    0.372006] pci 0000:00:05.0: PME# supported from D0 D1 D2 D3hot
[    0.376006] pci 0000:00:05.0: PME# disabled
[    0.380030] pci 0000:00:06.0: reg 10: [mem 0xfe2be000-0xfe2befff]
[    0.384011] pci 0000:00:06.0: reg 14: [io  0xdf00-0xdf3f]
[    0.388011] pci 0000:00:06.0: reg 18: [mem 0xfe100000-0xfe1fffff]
[    0.392025] pci 0000:00:06.0: reg 30: [mem 0xfe000000-0xfe0fffff pref]
[    0.396017] pci 0000:00:06.0: supports D1 D2
[    0.400005] pci 0000:00:06.0: PME# supported from D0 D1 D2 D3hot
[    0.404005] pci 0000:00:06.0: PME# disabled
[    0.408026] pci 0000:00:07.0: reg 10: [mem 0xfd000000-0xfdffffff]
[    0.412037] pci 0000:00:07.0: reg 30: [mem 0xfe2c0000-0xfe2fffff pref]
[    0.416107] pci 0000:00:0f.1: reg 20: [io  0xffa0-0xffaf]
[    0.420040] pci 0000:00:0f.2: reg 10: [mem 0xfe2bf000-0xfe2bffff]
[    0.424061] PCI: peer root bus 00 res updated from pci conf
[    0.428410] vgaarb: device added: PCI:0000:00:07.0,decodes=io+mem,owns=io+mem,locks=none
[    0.432520] PCI: peer root bus 01 res updar bus 01 [IRQ]
[    0.440018] pci 0000:00:0f.0: ServerWorks IRQ router [1166:0200]
[    0.444013] PCI: pci_cache_line_size set to 32 bytes
[    0.448041] reserve RAM buffer: 000000000009f400 - 000000000009ffff
[    0.452293] Switching to clocksource tsc
[    0.456059] pnp: PnP ACPI: disabled
[    0.466598] pci_bus 0000:00: resource 4 [io  0x01f0-0x01f7]
[    0.472274] pci_bus 0000:00: resource 5 [io  0x03f6]
[    0.477308] pci_bus 0000:00: resource 6 [io  0x0170-0x0177]
[    0.482908] pci_bus 0000:00: resource 7 [io  0x0376]
[    0.487873] pci_bus 0000:00: resource 8 [io  0xffa0-0xffaf]
[    0.493442] pci_bus 0000:00: resource 9 [mem 0xfc200000-0xfeafffff]
[    0.499708] pci_bus 0000:00: resource 10 [mem 0xfc000000-0xfc0fffff pref]
[    0.506491] pci_bus 0000:00: resource 11 [io  0xd000-0xdffc]
[    0.512149] pci_bus 0000:01: resource 4 [mem 0xfeb00000-0xfebfffff]
[    0.518412] pci_bus 0000:01: resource 5 [mem 0xfc100000-0xfc1fffff pref]
[    0.525108] pci_bus 0000:01: resource 6 [io  0xe000-0xeffc]
[    0.530729] NET: Registered protocol family 2
[    0.535154] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.542646] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.554656] TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
[    0.562450] TCP: Hash tables configured (established 131072 bind 65536)
[    0.569085] TCP reno registered
[    0.572233] UDP hash table entries: 512 (order: 1, 8192 bytes)
[    0.578111] UDP-Lite hash table entries: 512 (order: 1, 8192 bytes)
[    0.584560] NET: Registered protocol family 1
[    0.589130] RPC: Registered udp transport module.
[    0.593936] RPC: Registered tcp transport module.
[    0.598647] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.605143] pci 0000:00:05.0: Firmware left e100 interrupts enabled; disabling
[    0.612378] pci 0000:00:06.0: Firmware left e100 interrupts enabled; disabling
[    0.619603] pci 0000:00:07.0: Boot video device
[    0.624150] PCI: CLS 32 bytes, default 32
[    0.628271] Unpacking initramfs...
[    0.679788] Freeing initrd memory: 744k freed
[    0.686655] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    0.695342] microcode: CPU0 sig=0x68a, pf=0x10, revision=0x1
[    0.701165] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.709981] Scanning for low memory corruption every 60 seconds
[    0.723136] fuse init (API version 7.15)
[    0.727746] msgmni has been set to 1767
[    0.731978] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.739390] io scheduler noop registered
[    0.743311] io scheduler deadline registered (default)
[    0.748576] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.754713] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.781763] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.808459] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.815372] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k6-NAPI
[    0.822433] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    0.828268] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.7-k2
[    0.834214] e1000e: Copyright (c) 1999 - 2010 Intel Corporation.
[    0.840293] vcan: Virtual CAN interface driver
[    0.844742] CAN device driver interface
[    0.848570] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    0.854659] e100: Copyright(c) 1999-2006 Intel Corporation
[    0.860202] e100 0000:00:05.0: PCI->APIC IRQ transform: INT A -> IRQ 1
[    0.888701] e100 0000:00:05.0: PME# disabled
[    0.893248] e100 0000:00:05.0: eth0: addr 0xfe2bd000, irq 1, MAC addr 00:10:6f:07:10:00
[    0.901290] IOAPIC[1]: Invalid reference to IRQ 0
[    0.905994] e100 0000:00:06.0: PCI->APIC IRQ transform: INT A -> IRQ 2
[    0.934474] e100 0000:00:06.0: PME# disabled
[    0.938970] e100 0000:00:06.0: eth1: addr 0xfe2be000, irq 2, MAC addr 00:10:6f:07:10:01
[    0.947067] tun: Universal TUN/TAP device driver, 1.6
[    0.952122] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.958726] PNP: No PS/2 controller found. Probing ports directly.
[    1.217163] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.222481] mice: PS/2 mouse device common for all mice
[    1.228183] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[    1.234589] rtc0: alarms up to one day, 114 bytes nvram
[    1.239869] i2c /dev entries driver
[    1.243668] piix4_smbus 0000:00:0f.0: SMBus Host Controller at 0x440, revision 0
[    1.251325] cpuidle: using governor ladder
[    1.255437] cpuidle: using governor menu
[    1.259408] TCP cubic registered
[    1.262639] NET: Registered protocol family 17
[    1.267179] can: controller area network core (rev 20090105 abi 8)
[    1.273409] NET: Registered protocol family 29
[    1.277852] can: raw protocol (rev 20090105)
[    1.282119] can: broadcast manager protocol (rev 20090105 t)
[    1.287781] Using IPI Shortcut mode
[    1.291851] rtc_cmos rtc_cmos: setting system clock to 2010-08-13 17:56:26 UTC (1281722186)
[    1.300434] Freeing unused kernel memory: 292k freed
[    1.305925] Write protecting the kernel text: 2052k
[    1.310868] Write protecting the kernel read-only data: 920k
[    1.342867] udevd (362): /proc/362/oom_adj is deprecated, please use /proc/362/oom_score_adj instead.
[    1.453096] e100 0000:00:05.0: eth0: NIC Link is Up 100 Mbps Full Duplex


I also tried compiling a kernel with the last good commit,
5777372af5c929b8f3. Here is the serial console output from booting that
kernel with the extra options "apic=debug show_lapic=all". Hopefully the
output will help you track this down.


[    0.000000] Linux version 2.6.34-rc6-00115-g5777372 (iws@rena) (gcc version 4.3.4 (Gentoo 4.3.4 p1.0, pie-10.1.5) ) #37 Fri Aug 13 11:52:30 PDT 2010
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 000000000009f800 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000040000000 (usable)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec02000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!
[    0.000000] DMI 2.3 present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x40000 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] Warning only 895MB will be used.
[    0.000000] Use a HIGHMEM enabled kernel.
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009f400 (usable)
[    0.000000]  modified: 000000000009f400 - 000000000009f800 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 0000000040000000 (usable)
[    0.000000]  modified: 00000000fec00000 - 00000000fec02000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 01c00000
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [c00ff780] ff780
[    0.000000]   mpc: f0d70-f0e68
[    0.000000] init_memory_mapping: 0000000000000000-0000000037fa2000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037c00000 page 2M
[    0.000000]  0037c00000 - 0037fa2000 page 4k
[    0.000000] kernel direct mapping tables up to 37fa2000 @ 10000-15000
[    0.000000] RAMDISK: 3ff25000 - 3ffdf000
[    0.000000] Allocated new RAMDISK: 00100000 - 001b9e5a
[    0.000000] Move RAMDISK from 000000003ff25000 - 000000003ffdee59 to 00100000 - 001b9e59
[    0.000000] ACPI Error: A valid RSDP was not found (20100121/tbxfroot-219)
[    0.000000] 895MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 37fa2000
[    0.000000]   low ram: 0 - 37fa2000
[    0.000000]   node 0 low ram: 00000000 - 37fa2000
[    0.000000]   node 0 bootmap 00011000 - 00017ff8
[    0.000000] (10/32 early reservations) ==> bootmem [0000000000 - 0037fa2000]
[    0.000000]   #0 [0001000000 - 0001a1d2f8]    TEXT DATA BSS ==> [0001000000 - 0001a1d2f8]
[    0.000000]   #1 [0001a1e000 - 0001a251dc]              BRK ==> [0001a1e000 - 0001a251dc]
[    0.000000]   #2 [00000ff790 - 0000100000]    BIOS reserved ==> [00000ff790 - 0000100000]
[    0.000000]   #3 [00000ff780 - 00000ff790]     MP-table mpf ==> [00000ff780 - 00000ff790]
[    0.000000]   #4 [000009f000 - 00000f0d70]    BIOS reserved ==> [000009f000 - 00000f0d70]
[    0.000000]   #5 [00000f0e68 - 00000ff780]    BIOS reserved ==> [00000f0e68 - 00000ff780]
[    0.000000]   #6 [00000f0d70 - 00000f0e68]     MP-table mpc ==> [00000f0d70 - 00000f0e68]
[    0.000000]   #7 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
[    0.000000]   #8 [0000100000 - 00001ba000]      NEW RAMDISK ==> [0000100000 - 00001ba000]
[    0.000000]   #9 [0000011000 - 0000018000]          BOOTMAP ==> [0000011000 - 0000018000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00037fa2
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x00037fa2
[    0.000000] On node 0 totalpages: 229169
[    0.000000] free_area_init_node: node 0, pgdat c1476c74, node_mem_map c1a26200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223426 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] Intel MultiProcessor Specification v1.1
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000]   mpc: f0d70-f0e68
[    0.000000] MPTABLE: OEM ID: AMI
[    0.000000] MPTABLE: Product ID: CNB30LE
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Bus #0 is PCI
[    0.000000] Bus #1 is PCI
[    0.000000] Bus #2 is ISA
[    0.000000] I/O APIC #4 Version 17 at 0xFEC00000.
[    0.000000] I/O APIC #5 Version 17 at 0xFEC01000.
[    0.000000] Int: type 0, pol 3, trig 3, bus 00, IRQ 1c, APIC ID 5, APIC INT 03
[    0.000000] Int: type 0, pol 3, trig 3, bus 00, IRQ 3c, APIC ID 4, APIC INT 0a
[    0.000000] Int: type 0, pol 3, trig 3, bus 00, IRQ 18, APIC ID 5, APIC INT 02
[    0.000000] Int: type 0, pol 3, trig 3, bus 00, IRQ 14, APIC ID 5, APIC INT 01
[    0.000000] Int: type 0, pol 3, trig 3, bus 01, IRQ 38, APIC ID 5, APIC INT 06
[    0.000000] Int: type 3, pol 1, trig 1, bus 02, IRQ 00, APIC ID 4, APIC INT 00
[    0.000000] Int: type 0, pol 1, trig 1, bus 02, IRQ 01, APIC ID 4, APIC INT 01
[    0.000000] Int: type 0, pol 1, trig 1, bus 02, IRQ 00, APIC ID 4, APIC INT 02
[    0.000000] Int: type 0, pol 1, trig 1, bus 02, IRQ 03, APIC ID 4, APIC INT 03
[    0.000000] Int: type 0, pol 1, trig 1, bus 02, IRQ 04, APIC ID 4, APIC INT 04
[    0.000000] Int: type 0, pol 1, trig 1, bus 02, IRQ 05, APIC ID 4, APIC INT 05
[    0.000000] Int: type 0, pol 1, trig 1, bus 02, IRQ 06, APIC ID 4, APIC INT 06
[    0.000000] Int: type 0, pol 1, trig 1, bus 02, IRQ 08, APIC ID 4, APIC INT 08
[    0.000000] Int: type 0, pol 1, trig 1, bus 02, IRQ 0c, APIC ID 4, APIC INT 0c
[    0.000000] Int: type 0, pol 1, trig 1, bus 02, IRQ 0d, APIC ID 4, APIC INT 0d
[    0.000000] Int: type 0, pol 1, trig 1, bus 02, IRQ 0e, APIC ID 4, APIC INT 0e
[    0.000000] Lint: type 3, pol 1, trig 1, bus 02, IRQ 00, APIC ID ff, APIC LINT 00
[    0.000000] Lint: type 1, pol 1, trig 1, bus 00, IRQ 00, APIC ID ff, APIC LINT 01
[    0.000000] Processors: 1
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] mapped IOAPIC to ffff9000 (fec01000)
[    0.000000] nr_irqs_gsi: 32
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:bec00000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 227377
[    0.000000] Kernel command line: initrd=initramfs-generic-i686.cpio.gz ignore_loglevel root=/dev/nfs ro console=ttyS0,115200 apic=debug show_lapic=all BOOT_IMAGE=bzImage-canbus-biok
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 897536k/917128k available (2147k kernel code, 19140k reserved, 2439k data, 288k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa4000 - 0xfffff000   ( 364 kB)
[    0.000000]     vmalloc : 0xf87a2000 - 0xfffa2000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf7fa2000   ( 895 MB)
[    0.000000]       .init : 0xc147b000 - 0xc14c3000   ( 288 kB)
[    0.000000]       .data : 0xc1218c3f - 0xc147ab7c   (2439 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1218c3f   (2147 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] NR_IRQS:288
[    0.000000] CPU 0 irqstacks, hard=c1303000 soft=c1304000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 999.622 MHz processor.
[    0.012068] Calibrating delay loop (skipped), value calculated using timer frequency.. 1999.24 BogoMIPS (lpj=3998488)
[    0.020119] Mount-cache hash table entries: 512
[    0.026044] CPU serial number disabled.
[    0.028023] mce: CPU supports 5 MCE banks
[    0.032042] Performance Events: p6 PMU driver.
[    0.040072] ... version:                0
[    0.044012] ... bit width:              32
[    0.048011] ... generic registers:      2
[    0.052012] ... value mask:             00000000ffffffff
[    0.056012] ... max period:             000000007fffffff
[    0.060011] ... fixed-purpose events:   0
[    0.064011] ... event mask:             0000000000000003
[    0.068011] CPU: Intel Pentium III (Coppermine) stepping 0a
[    0.073243] Checking 'hlt' instruction... OK.
[    0.093496] Enabling APIC mode:  Flat.  Using 2 I/O APICs
[    0.096015] Getting VERSION: 40011
[    0.100012] Getting VERSION: 40011
[    0.104012] Getting ID: 0
[    0.108012] Getting ID: f000000
[    0.111146] Getting LVT0: 700
[    0.112012] Getting LVT1: 400
[    0.116016] enabled ExtINT on CPU#0
[    0.120161] ExtINT not setup in hardware but reported by MP table
[    0.124287] ESR value before enabling vector: 0x00000004  after: 0x00000000
[    0.128012] ENABLING IO-APIC IRQs
[    0.132016] Setting 4 in the phys_id_present_map
[    0.136013] ...changing IO-APIC physical APIC ID to 4 ... ok.
[    0.144015] Setting 5 in the phys_id_present_map
[    0.148012] ...changing IO-APIC physical APIC ID to 5 ... ok.
[    0.152551] Synchronizing Arb IDs.
[    0.156011] init IO_APIC IRQs
[    0.160012]  4-0 (apicid-pin) not connected
[    0.164035] IOAPIC[0]: Set routing entry (4-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    0.168030] IOAPIC[0]: Set routing entry (4-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
[    0.172027] IOAPIC[0]: Set routing entry (4-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
[    0.176000] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    0.176000] IOAPIC[0]: Set routing entry (4-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
[    0.176000] IOAPIC[0]: Set routing entry (4-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[  ot connected
[    0.176000] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    0.176000]  4-9 (apicid-pin) not connected
[    0.176000] IOAPIC[0]: Set routing entry (4-10 -> 0x3a -> IRQ 10 Mode:1 Active:1)
[    0.176000]  4-11 (apicid-pin) not connected
[    0.176000] IOAPIC[0]: Set routing entry (4-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    0.176000] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    0.176000] IOAPIC[0]: Set routing entry (4-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
[    0.176000]  4-15 5-0 (apicid-pin) not connected
[    0.176000]  5-4 5-5 (apicid-pin) not connected
[    0.176000]  5-7 5-8 5-9 5-10 5-11 5-12 5-13 5-14 5-15 (apicid-pin) not connected
[    0.176000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.176000] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.176000] ...trying to set up timer (IRQ0) through the 8259A ...
[    0.176000] ..... (found apic 0 pin 0) ...
[    0.217315] ....... works.
[    0.220010] Using local APIC timer interrupts.
[    0.220013] calibrating APIC timer ...
[    0.228000] ... lapic delta = 833143
[    0.228000] ... PM-Timer delta = 0
[    0.228000] ..... delta 833143
[    0.228000] ..... mult: 35780983
[    0.228000] ..... calibration result: 533211
[    0.228000] ..... CPU clock speed is 999.3085 MHz.
[    0.228000] ..... host bus clock speed is 133.1211 MHz.
[    0.228000] ... verify APIC timer
[    0.338806] ... jiffies delta = 25
[    0.340009] ... jiffies result ok
[    0.344745] devtmpfs: initialized
[    0.351436] NET: Registered protocol family 16
[    0.359145] PCI: PCI BIOS revision 2.10 entry at 0xfdbb1, last bus=1
[    0.360092] PCI: Using configuration type 1 for base access
[    0.385919] bio: create slab <bio-0> at 0
[    0.388487] ACPI: Interpreter disabled.
[    0.393664] vgaarb: loaded
[    0.397092] LinuxPPS API ver. 1 registered
[    0.400050] Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.404381] PCI: Probing PCI hardware
[    0.408091] PCI: Probing PCI hardware (bus 00)
[    0.412472] * The chipset may have PM-Timer Bug. Due to workarounds for a bug,
[    0.412476] * this clock source is slow. If you are sure your timer does not have
[    0.412480] * this bug, please use "acpi_pm_good" to disable the workaround
[    0.416214] * The chipset may have PM-Timer Bug. Due to workarounds for a bug,
[    0.416219] * this clock source is slow. If you are sure your timer does not have
[    0.416223] * this bug, please use "acpi_pm_good" to disable the workaround
[    0.420233] pci 0000:00:05.0: reg 10: [mem 0xfe2bd000-0xfe2bdfff]
[    0.424024] pci 0000:00:05.0: reg 14: [io  0xde80-0xdebf]
[    0.428024] pci 0000:00:05.0: reg 18: [mem 0xfcf00000-0xfcffffff]
[    0.432061] pci 0000:00:05.0: reg 30: [mem 0xfce00000-0xfcefffff pref]
[    0.436060] pci 0000:00:05.0: supports D1 D2
[    0.440010] pci 0000:00:05.0: PME# supported from D0 D1 D2 D3hot
[    0.444016] pci 0000:00:05.0: PME# disabled
[    0.448088] pci 0000:00:06.0: reg 10: [mem 0xfe2be000-0xfe2befff]
[    0.452024] pci 0000:00:06.0: reg 14: [io  0xdf00-0xdf3f]
[    0.456024] pci 0000:00:06.0: reg 18: [mem 0xfe100000-0xfe1fffff]
[    0.460061] pci 0000:00:06.0: reg 30: [mem 0xfe000000-0xfe0fffff pref]
[    0.464059] pci 0000:00:06.0: supports D1 D2
[    0.468010] pci 0000:00:06.0: PME# supported from D0 D1 D2 D3hot
[    0.472015] pci 0000:00:06.0: PME# disabled
[    0.476070] pci 0000:00:07.0: reg 10: [mem 0xfd000000-0xfdffffff]
[    0.480088] pci 0000:00:07.0: reg 30: [mem 0xfe2c0000-0xfe2fffff pref]
[    0.484312] pci 0000:00:0f.1: reg 20: [io  0xffa0-0xffaf]
[    0.488110] pci 0000:00:0f.2: reg 10: [mem 0xfe2bf000-0xfe2bffff]
[    0.496973] vgaarb: device added: PCI:0000:00:07.0,decodes=io+mem,owns=io+mem,locks=none
[    0.501210] PCI: Discovered peer bus 01
[    0.504494] pci 0000:01:0e.0: reg 10: [mem 0xfebffc00-0xfebffc7f]
[    0.508054] pci 0000:01:0e.0: reg 14: [io  0xec00-0xec7f]
[    0.512024] pci 0000:01:0e.0: reg 18: [mem 0xfebfe000-0xfebfefff]
[    0.516024] pci 0000:01:0e.0: reg 1c: [mem 0xfebfd000-0xfebfdfff]
[    0.520024] pci 0000:01:0e.0: reg 20: [mem 0xfebfc000-0xfebfcfff]
[    0.524117] pci 0000:01:0e.0: PME# supported from D0 D3hot
[    0.528016] pci 0000:01:0e.0: PME# disabled
[    0.532540] pci 0000:00:0f.0: ServerWorks IRQ router [1166:0200]
[    0.536098] PCI: pci_cache_line_size set to 32 bytes
[    0.540257] reserve RAM buffer: 000000000009f400 - 000000000009ffff
[    0.545526]
[    0.545529] printing PIC contents
[    0.548032] ... PIC  IMR: fffa
[    0.551081] ... PIC  IRR: 0001
[    0.552008] ... PIC  ISR: 0000
[    0.556008] ... PIC ELCR: 8e80
[    0.559059] printing local APIC contents on CPU#0/0:
[    0.560000] ... APIC ID:      00000000 (0)
[    0.560000] ... APIC VERSION: 00040011
[    0.560000] ... APIC TASKPRI: 00000000 (00)
[    0.560000] ... APIC ARBPRI: 000000e0 (e0)
[    0.560000] ... APIC PROCPRI: 00000000
[    0.560000] ... APIC LDR: 01000000
[    0.560000] ... APIC DFR: ffffffff
[    0.560000] ... APIC SPIV: 000001ff
[    0.560000] ... APIC ISR field:
[    0.560000] 0000000000000000000000000000000000000000000000000000000000000000
[    0.560000] ... APIC TMR field:
[    0.560000] 0000000000000000000000000000000000000000000000000000000000000000
[    0.560000] ... APIC IRR field:
[    0.560000] 0000000000000000000000000000000000000000000000000000000000008000
[    0.560000] ... APIC ESR: 00000000
[    0.560000] ... APIC ICR: 00088500
[    0.560000] ... APIC ICR2: 0e000000
[    0.560000] ... APIC LVTT: 000200ef
[    0.560000] ... APIC LVTPC: 00000400
[    0.560000] ... APIC LVT0: 00010700
[    0.560000] ... APIC LVT1: 00000400
[    0.560000] ... APIC LVTERR: 000000fe
[    0.560000] ... APIC TMICT: 0000822d
[    0.560000] ... APIC TMCCT: 000072c3
[    0.560000] ... APIC TDCR: 00000003
[    0.560000]
[    0.560008] number of MP IRQ sources: 16.
[    0.564008] number of IO-APIC #4 registers: 16.
[    0.568008] number of IO-APIC #5 registers: 16.
[    0.572007] testing the IO APIC.......................
[    0.576014]
[    0.580008] IO APIC #4......
[    0.582883] .... register #00: 04000000
[    0.584008] .......    : physical APIC id: 04
[    0.588008] .......    : Delivery Type: 0
[    0.592008] .......    : LTS          : 0
[    0.596008] .... register #01: 000F0011
[    0.600008] .......     : max redirection entries: 000F
[    0.604008] .......     : PRQ implemented: 0
[    0.608008] .......     : IO APIC version: 0011
[    0.612008] .... register #02: 00000000
[    0.616008] .......     : arbitration: 00
[    0.620007] .... IRQ redirection table:
[    0.624007]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    0.628013]  00 001 0    0    0   0   0    1    1    30
[    0.636012]  01 001 0    0    0   0   0    1    1    31
[    0.640013]  02 000 1    0    0   0   0    0    0    00
[    0.644013]  03 001 0    0    0   0   0    1    1    33
[    0.651235]  04 001 0    0    0   0   0    1    1    34
[    0.656012]  05 001 0    0    0   0   0    1    1    35
[    0.660012]  06 001 0    0    0   0   0    1    1    36
[    0.667235]  07 0A2 1    0    0   0   0    1    2    10
[    0.672012]  08 001 0    0    0   0   0    1    1    38
[    0.676012]  09 000 1    0    0   0   0    0    0    00
[    0.683235]  0a 001 1    1    0   1   0    1    1    3A
[    0.688012]  0b 000 1    0    0   0   0    0    0    00
[    0.692012]  0c 001 0    0    0   0   0    1    1    3C
[    0.696013]  0d 001 0    0    0   0   0    1    1    3D
[    0.704012]  0e 001 0    0    0   0   0    1    1    3E
[    0.708012]  0f 000 1    0    0   0   0    0    0    00
[    0.712013]
[    0.716008] IO APIC #5......
[    0.718884] .... register #00: 05000000
[    0.720008] .......    : physical APIC id: 05
[    0.724008] .......    : Delivery Type: 0
[    0.728008] .......    : LTS          : 0
[    0.732008] .... register #01: 000F0011
[    0.736008] .......     : max redirection entries: 000F
[    0.740008] .......     : PRQ implemented: 0
[    0.744008] .......     : IO APIC version: 0011
[    0.748008] .... register #02: 08000000
[    0.752008] .......     : arbitration: 08
[    0.756007] .... IRQ redirection table:
[    0.760007]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    0.764013]  00 000 1    0    0   0   0    0    0    00
[    0.771236]  01 000 1    0    0   0   0    0    0    00
[    0.776013]  02 000 1    0    0   0   0    0    0    00
[    0.780012]  03 000 1    0    0   0   0    0    0    00
[    0.787236]  04 000 1    0    0   0   0    0    0    00
[    0.792013]  05 000 1    0    0   0   0    0    0    00
[    0.796012]  06 000 1    0    0   0   0    0    0    00
[    0.803235]  07 000 1    0    0   0   0    0    0    00
[    0.808012]  08 000 1    0    0   0   0    0    0    00
[    0.812012]  09 000 1    0    0   0   0    0    0    00
[    0.816013]  0a 000 1    0    0   0   0    0    0    00
[    0.824012]  0b 000 1    0    0   0   0    0    0    00
[    0.828012]  0c 000 1    0    0   0   0    0    0    00
[    0.832013]  0d 000 1    0    0   0   0    0    0    00
[    0.840012]  0e 000 1    0    0   0   0    0    0    00
[    0.844012]  0f 000 1    0    0   0   0    0    0    00
[    0.848131] IRQ to pin mappings:
[    0.852009] IRQ0 -> 0:0
[    0.856193] IRQ1 -> 0:1
[    0.858660] IRQ3 -> 0:3
[    0.860725] IRQ4 -> 0:4
[    0.863189] IRQ5 -> 0:5
[    0.864724] IRQ6 -> 0:6
[    0.868726] IRQ8 -> 0:8
[    0.871195] IRQ10 -> 0:10
[    0.872813] IRQ12 -> 0:12
[    0.876193] IRQ13 -> 0:13
[    0.878834] IRQ14 -> 0:14
[    0.880856] .................................... done.
[    0.884100] Switching to clocksource tsc
[    0.888448] pnp: PnP ACPI: disabled
[    0.895079] PCI: max bus depth: 0 pci_try_num: 1
[    0.899765] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.905343] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
[    0.911613] pci_bus 0000:01: resource 0 [io  0x0000-0xffff]
[    0.917192] pci_bus 0000:01: resource 1 [mem 0x00000000-0xffffffff]
[    0.923555] NET: Registered protocol family 2
[    0.928182] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.936089] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.948455] TCP bind hash table entries: 65536 (order: 9, 2621440 bytes)
[    0.973224] TCP: Hash tables configured (established 131072 bind 65536)
[    0.979968] TCP reno registered
[    0.983154] UDP hash table entries: 512 (order: 3, 49152 bytes)
[    0.989375] UDP-Lite hash table entries: 512 (order: 3, 49152 bytes)
[    0.996285] NET: Registered protocol family 1
[    1.001298] RPC: Registered udp transport module.
[    1.006016] RPC: Registered tcp transport module.
[    1.010727] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.017430] pci 0000:00:05.0: Firmware left e100 interrupts enabled; disabling
[    1.024717] pci 0000:00:06.0: Firmware left e100 interrupts enabled; disabling
[    1.031965] pci 0000:00:07.0: Boot video device
[    1.036581] PCI: CLS 32 bytes, default 32
[    1.041104] Unpacking initramfs...
[    1.100485] Freeing initrd memory: 744k freed
[    1.129609] DMA-API: preallocated 32768 debug entries
[    1.134701] DMA-API: debugging enabled by kernel config
[    1.141462] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    1.152960] microcode: CPU0 sig=0x68a, pf=0x10, revision=0x1
[    1.159075] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.167974] Scanning for low memory corruption every 60 seconds
[    1.177709] Initializing RT-Tester: OK
[    1.206019] fuse init (API version 7.13)
[    1.211149] msgmni has been set to 1754
[    1.216420] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.223927] io scheduler noop registered
[    1.227859] io scheduler deadline registered (default)
[    1.233577] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.239474] ------------[ cut here ]------------
[    1.244116] WARNING: at /home/iws/devel/linux-2.6/fs/proc/generic.c:825 remove_proc_entry+0xc1/0x220()
[    1.253421] Hardware name: To Be Filled By O.E.M.
[    1.258129] name 'fan'
[    1.260484] Modules linked in:
[    1.263563] Pid: 1, comm: swapper Not tainted 2.6.34-rc6-00115-g5777372 #37
[    1.270525] Call Trace:
[    1.272985]  [<c10205a8>] warn_slowpath_common+0x60/0x90
[    1.278307]  [<c102060c>] warn_slowpath_fmt+0x24/0x27
[    1.283368]  [<c10a8025>] remove_proc_entry+0xc1/0x220
[    1.288527]  [<c103ce2a>] ? lock_release_holdtime+0x1c/0x17d
[    1.294194]  [<c10a883f>] ? proc_register+0x14b/0x15c
[    1.299263]  [<c1217ab2>] ? _raw_spin_unlock+0x1d/0x20
[    1.304409]  [<c10a883f>] ? proc_register+0x14b/0x15c
[    1.309611]  [<c147b1c1>] ? kernel_init+0x0/0x102
[    1.314333]  [<c1493cfe>] ? acpi_button_init+0x0/0x4a
[    1.319393]  [<c10a89e5>] ? proc_mkdir_mode+0x2f/0x43
[    1.324456]  [<c147b1c1>] ? kernel_init+0x0/0x102
[    1.329169]  [<c1493d48>] ? acpi_fan_init+0x0/0x2c
[    1.333970]  [<c1493d6b>] acpi_fan_init+0x23/0x2c
[    1.338682]  [<c100104b>] do_one_initcall+0x4b/0x135
[    1.343656]  [<c147b1c1>] ? kernel_init+0x0/0x102
[    1.348369]  [<c147b245>] kernel_init+0x84/0x102
[    1.352996]  [<c1002d42>] kernel_thread_helper+0x6/0x1a
[    1.358246] ---[ end trace 6d450e935ee1897c ]---
[    1.388089] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.395224] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.402320] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.412028] Intel(R) PRO/1000 Network Driver - version 7.3.21-k5-NAPI
[    1.418526] Copyright (c) 1999-2006 Intel Corporation.
[    1.424045] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[    1.430053] e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
[    1.436353] vcan: Virtual CAN interface driver
[    1.440821] CAN device driver interface
[    1.444662] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    1.450763] Clocksource tsc unstable (delta = 103084879 ns)
[    1.456420] e100: Copyright(c) 1999-2006 Intel Corporation
[    1.462006] querying PCI -> IRQ mapping bus:0, slot:5, pin:0.
[    1.467769] IOAPIC[1]: Set routing entry (5-1 -> 0x29 -> IRQ 17 Mode:1 Active:1)
[    1.475181] e100 0000:00:05.0: PCI->APIC IRQ transform: INT A -> IRQ 17
[    1.504028] e100 0000:00:05.0: PME# disabled
[    1.509187] Switching to clocksource jiffies
[    1.513903] e100: eth0: e100_probe: addr 0xfe2bd000, irq 17, MAC addr 00:10:6f:07:10:00
[    1.517568] querying PCI -> IRQ mapping bus:0, slot:6, pin:0.
[    1.521488] IOAPIC[1]: Set routing entry (5-2 -> 0x41 -> IRQ 18 Mode:1 Active:1)
[    1.525491] e100 0000:00:06.0: PCI->APIC IRQ transform: INT A -> IRQ 18
[    1.552289] e100 0000:00:06.0: PME# disabled
[    1.554199] e100: eth1: e100_probe: addr 0xfe2be000, irq 18, MAC addr 00:10:6f:07:10:01
[    1.561630] tun: Universal TUN/TAP device driver, 1.6
[    1.565481] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.574856] PNP: No PS/2 controller found. Probing ports directly.
[    1.583599] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.585560] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.591472] mice: PS/2 mouse device common for all mice
[    1.595695] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[    1.597611] rtc0: alarms up to one day, 114 bytes nvram
[    1.601711] i2c /dev entries driver
[    1.606601] piix4_smbus 0000:00:0f.0: SMBus Host Controller at 0x440, revision 0
[    1.614173] cpuidle: using governor ladder
[    1.617497] cpuidle: using governor menu
[    1.621874] TCP cubic registered
[    1.625512] NET: Registered protocol family 17
[    1.629731] can: controller area network core (rev 20090105 abi 8)
[    1.633624] NET: Registered protocol family 29
[    1.637483] can: raw protocol (rev 20090105)
[    1.641527] can: broadcast manager protocol (rev 20090105 t)
[    1.645502] Using IPI Shortcut mode
[    1.651202] rtc_cmos rtc_cmos: setting system clock to 2010-08-13 18:52:48 UTC (1281725568)
[    1.658687] Freeing unused kernel memory: 288k freed
[    1.662988] Write protecting the kernel text: 2148k
[    1.665844] Write protecting the kernel read-only data: 928k


I tried a few different things to make -git boot on this box.

1) revert the commit

This helped, but the box did not boot up completely. It never started
userspace. The kernel log is shown above.

2) CONFIG_X86_UP_APIC=n

This worked, and -git boots just fine. That proves this is an APIC
problem.

3) Extra kernel parameters

I added "noapic nolapic" to the kernel command line. This didn't boot at
all. No output to the serial console. Nothing. I guess these parameters
don't *really* shut off the APIC.


Here is the output of lspci -v on the machine, just in case it helps:

00:00.0 Host bridge: Broadcom CNB20LE Host Bridge (rev 06)
        Flags: bus master, medium devsel, latency 32

00:00.1 Host bridge: Broadcom CNB20LE Host Bridge (rev 06)
        Flags: bus master, medium devsel, latency 16

00:05.0 Ethernet controller: Intel Corporation 82557/8/9/0/1 Ethernet Pro 100 (rev 08)
        Flags: bus master, medium devsel, latency 64, IRQ 17
        Memory at fe2bd000 (32-bit, non-prefetchable) [size=4K]
        I/O ports at de80 [size=64]
        Memory at fcf00000 (32-bit, non-prefetchable) [size=1M]
        Expansion ROM at fce00000 [disabled] [size=1M]
        Capabilities: [dc] Power Management version 2

00:06.0 Ethernet controller: Intel Corporation 82557/8/9/0/1 Ethernet Pro 100 (rev 08)
        Flags: bus master, medium devsel, latency 64, IRQ 18
        Memory at fe2be000 (32-bit, non-prefetchable) [size=4K]
        I/O ports at df00 [size=64]
        Memory at fe100000 (32-bit, non-prefetchable) [size=1M]
        Expansion ROM at fe000000 [disabled] [size=1M]
        Capabilities: [dc] Power Management version 2

00:07.0 VGA compatible controller: Chips and Technologies F69030 (rev 61) (prog-if 00 [VGA controller])
        Subsystem: Chips and Technologies F69030
        Flags: stepping, 66MHz, medium devsel, IRQ 10
        Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
        Expansion ROM at fe2c0000 [disabled] [size=256K]

00:0f.0 ISA bridge: Broadcom OSB4 South Bridge (rev 50)
        Subsystem: Broadcom OSB4 South Bridge
        Flags: bus master, medium devsel, latency 0

00:0f.1 IDE interface: Broadcom OSB4 IDE Controller (prog-if 8a [Master SecP PriP])
        Flags: medium devsel
        [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
        [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
        [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
        [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
        I/O ports at ffa0 [disabled] [size=16]

00:0f.2 USB Controller: Broadcom OSB4/CSB5 OHCI USB Controller (rev 04) (prog-if 10 [OHCI])
        Subsystem: Broadcom OSB4/CSB5 OHCI USB Controller
        Flags: bus master, medium devsel, latency 64, IRQ 10
        Memory at fe2bf000 (32-bit, non-prefetchable) [size=4K]


I'm happy to test patches or provide more information as needed.

Thanks,
Ira
