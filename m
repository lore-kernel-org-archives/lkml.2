Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab1JQQfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 12:35:43 -0400
Received: from mailout09.t-online.de ([194.25.134.84]:54025 "EHLO
	mailout09.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab1JQQfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 12:35:42 -0400
Message-ID: <4E9C5959.1050404@t-online.de>
Date: Mon, 17 Oct 2011 18:35:37 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: hpa@zytor.com
CC: linux-kernel@vger.kernel.org
Subject: __cpuinit early_init_intel() called twice
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: bdOQ0EZT8hnARkPEULIhEWs79g+zr2T8fRYfbsaGUSAHhYRRdYwit73XRUBJw2ZgpP
X-TOI-MSGID: 62d32709-8cb6-4635-9bb3-e4a9c08bb2ef
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, I just realized that there are two "Disabled fast string operations"
entries in the boot log - that means early_init_intel() is called _twice_.
I had expected something else. Is this the expected behaviour or shall
I have a look at the call trees?

cu,
  Knut



<6>[    0.000000] Initializing cgroup subsys cpu
<5>[    0.000000] Linux version 3.0.6-main (knut@golem) (gcc version 4.5.1 20101208 [gcc-4_5-branch revision 167585] (SUSE Linux) ) #3 PREEMPT Tue Oct 4 13:58:23 CEST 2011
<6>[    0.000000] Disabled fast string operations
<6>[    0.000000] BIOS-provided physical RAM map:
<6>[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
<6>[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
<6>[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f7f0000 (usable)
<6>[    0.000000]  BIOS-e820: 000000007f7f0000 - 000000007f7f3000 (ACPI NVS)
<6>[    0.000000]  BIOS-e820: 000000007f7f3000 - 000000007f800000 (ACPI data)
<6>[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
<6>[    0.000000] NX (Execute Disable) protection: active
<6>[    0.000000] DMI 2.3 present.
<7>[    0.000000] DMI:    /i915GMm-HFS, BIOS 6.00 PG 09/14/2005
<7>[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
<7>[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
<6>[    0.000000] last_pfn = 0x7f7f0 max_arch_pfn = 0x1000000
<7>[    0.000000] MTRR default type: uncachable
<7>[    0.000000] MTRR fixed ranges enabled:
<7>[    0.000000]   00000-9FFFF write-back
<7>[    0.000000]   A0000-EFFFF uncachable
<7>[    0.000000]   F0000-FFFFF write-through
<7>[    0.000000] MTRR variable ranges enabled:
<7>[    0.000000]   0 base 000000000 mask F80000000 write-back
<7>[    0.000000]   1 base 07F800000 mask FFF800000 uncachable
<7>[    0.000000]   2 disabled
<7>[    0.000000]   3 disabled
<7>[    0.000000]   4 disabled
<7>[    0.000000]   5 disabled
<7>[    0.000000]   6 disabled
<7>[    0.000000]   7 disabled
<7>[    0.000000] initial memory mapped : 0 - 01000000
<7>[    0.000000] Base memory trampoline at [c009e000] 9e000 size 4096
<6>[    0.000000] init_memory_mapping: 0000000000000000-0000000037bfe000
<7>[    0.000000]  0000000000 - 0000200000 page 4k
<7>[    0.000000]  0000200000 - 0037a00000 page 2M
<7>[    0.000000]  0037a00000 - 0037bfe000 page 4k
<7>[    0.000000] kernel direct mapping tables up to 37bfe000 @ ffb000-1000000
<6>[    0.000000] RAMDISK: 375cc000 - 37ff0000
<6>[    0.000000] Allocated new RAMDISK: 36ba8000 - 375cb973
<6>[    0.000000] Move RAMDISK from 00000000375cc000 - 0000000037fef972 to 36ba8000 - 375cb972
<4>[    0.000000] ACPI: RSDP 000f9320 00014 (v00 AOpen )
<4>[    0.000000] ACPI: RSDT 7f7f3040 00038 (v01 AOpen  AWRDACPI 42302E31 AWRD 00000000)
<4>[    0.000000] ACPI: FACP 7f7f30c0 00074 (v01 AOpen  AWRDACPI 42302E31 AWRD 00000000)
<4>[    0.000000] ACPI: DSDT 7f7f3180 042E3 (v01 AOPEN  AWRDACPI 00001000 MSFT 0100000E)
<4>[    0.000000] ACPI: FACS 7f7f0000 00040
<4>[    0.000000] ACPI: MCFG 7f7f7580 0003C (v01 AOpen  AWRDACPI 42302E31 AWRD 00000000)
<4>[    0.000000] ACPI: APIC 7f7f74c0 0005A (v01 AOpen  AWRDACPI 42302E31 AWRD 00000000)
<4>[    0.000000] ACPI: SSDT 7f7f7600 00222 (v01  PmRef  Cpu0Ist 00003000 INTL 20040311)
<4>[    0.000000] ACPI: SSDT 7f7f7a00 000E0 (v01  PmRef    CpuPm 00003000 INTL 20040311)
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<5>[    0.000000] 1147MB HIGHMEM available.
<5>[    0.000000] 891MB LOWMEM available.
<6>[    0.000000]   mapped low ram: 0 - 37bfe000
<6>[    0.000000]   low ram: 0 - 37bfe000
<4>[    0.000000] Zone PFN ranges:
<4>[    0.000000]   DMA      0x00000010 -> 0x00001000
<4>[    0.000000]   Normal   0x00001000 -> 0x00037bfe
<4>[    0.000000]   HighMem  0x00037bfe -> 0x0007f7f0
<4>[    0.000000] Movable zone start PFN for each node
<4>[    0.000000] early_node_map[2] active PFN ranges
<4>[    0.000000]     0: 0x00000010 -> 0x0000009f
<4>[    0.000000]     0: 0x00000100 -> 0x0007f7f0
<7>[    0.000000] On node 0 totalpages: 522111
<7>[    0.000000] free_area_init_node: node 0, pgdat c060d234, node_mem_map f5bb8200
<7>[    0.000000]   DMA zone: 32 pages used for memmap
<7>[    0.000000]   DMA zone: 0 pages reserved
<7>[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
<7>[    0.000000]   Normal zone: 1752 pages used for memmap
<7>[    0.000000]   Normal zone: 222502 pages, LIFO batch:31
<7>[    0.000000]   HighMem zone: 2296 pages used for memmap
<7>[    0.000000]   HighMem zone: 291578 pages, LIFO batch:31
<6>[    0.000000] Using APIC driver default
<6>[    0.000000] ACPI: PM-Timer IO Port: 0x4008
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
<6>[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
<6>[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
<7>[    0.000000] ACPI: IRQ0 used by override.
<7>[    0.000000] ACPI: IRQ2 used by override.
<7>[    0.000000] ACPI: IRQ9 used by override.
<6>[    0.000000] Using ACPI (MADT) for SMP configuration information
<7>[    0.000000] nr_irqs_gsi: 40
<6>[    0.000000] Allocating PCI resources starting at 7f800000 (gap: 7f800000:60800000)
<7>[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
<7>[    0.000000] pcpu-alloc: [0] 0
<4>[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 518031
<5>[    0.000000] Kernel command line: root=/dev/sdb5 acpi_enforce_resources=lax drm.debug=0 5
<6>[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
<6>[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
<6>[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
<6>[    0.000000] Initializing CPU#0
<6>[    0.000000] Initializing HighMem for node 0 (00037bfe:0007f7f0)
<6>[    0.000000] Memory: 2049924k/2088896k available (3305k kernel code, 38520k reserved, 1886k data, 328k init, 1175496k highmem)
<6>[    0.000000] virtual kernel memory layout:
<6>[    0.000000]     fixmap  : 0xfffa3000 - 0xfffff000   ( 368 kB)
<6>[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
<6>[    0.000000]     vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
<6>[    0.000000]     lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
<6>[    0.000000]       .init : 0xc0612000 - 0xc0664000   ( 328 kB)
<6>[    0.000000]       .data : 0xc043a4d5 - 0xc0611f00   (1886 kB)
<6>[    0.000000]       .text : 0xc0100000 - 0xc043a4d5   (3305 kB)
<6>[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
<6>[    0.000000] Preemptible hierarchical RCU implementation.
<6>[    0.000000] NR_IRQS:288
<7>[    0.000000] CPU 0 irqstacks, hard=f540a000 soft=f540c000
<6>[    0.000000] Console: colour VGA+ 80x25
<6>[    0.000000] console [tty0] enabled
<4>[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
<4>[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
<4>[    0.000000] ... MAX_LOCK_DEPTH:          48
<4>[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
<4>[    0.000000] ... CLASSHASH_SIZE:          4096
<4>[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
<4>[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
<4>[    0.000000] ... CHAINHASH_SIZE:          16384
<4>[    0.000000]  memory used by lock dependency info: 3567 kB
<4>[    0.000000]  per task-struct memory footprint: 1152 bytes
<4>[    0.000000] Fast TSC calibration using PIT
<4>[    0.000000] Detected 1862.770 MHz processor.
<6>[    0.008003] Calibrating delay loop (skipped), value calculated using timer frequency.. 3725.54 BogoMIPS (lpj=7451080)
<6>[    0.008276] pid_max: default: 32768 minimum: 301
<6>[    0.008505] Security Framework initialized
<6>[    0.008672] AppArmor: AppArmor initialized
<6>[    0.008849] Mount-cache hash table entries: 512
<6>[    0.012676] Disabled fast string operations
<6>[    0.012816] mce: CPU supports 5 MCE banks
<6>[    0.012958] CPU0: Thermal monitoring enabled (TM2)
<6>[    0.013103] CPU: Intel(R) Pentium(R) M processor 1.86GHz stepping 08

