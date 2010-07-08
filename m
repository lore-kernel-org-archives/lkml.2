Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624Ab0GHU6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:58:47 -0400
Received: from mail.anarazel.de ([217.115.131.40]:40420 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758606Ab0GHU6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:58:36 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jul 2010 16:58:32 EDT
Date: Thu, 8 Jul 2010 22:51:13 +0200
From: Andres Freund <andres@anarazel.de>
To: linux-kernel@vger.kernel.org
Subject: INFO: rcu_sched_state detected stall on CPU 
Message-ID: <20100708205113.GA15117@anarazel.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

I recently got a dual-socket E5520 (only one cpu attached right now,
problems where the same with both though) system where I regularly get
errors like

[  288.281073] INFO: rcu_sched_state detected stall on CPU 1 (t=5890 jiffies)
[  288.281086] INFO: rcu_sched_state detected stall on CPU 5 (t=5890 jiffies)
[  288.281087] sending NMI to all CPUs:
[  288.281096] sending NMI to all CPUs:

After deactivating all power saving mechanisms it seems to have gotten
a bit more stable - it still crashes pretty reliably under
io-load. Graphics-intensive work seems also be able trigger it
reliably. The crashes also occured with the cheap on-board intel
graphics card.

Without the rcu debugging producing the messages above I pretty
regularly get hangs or missing inputs regularly - at times ending
fatal (no sysrq, no keyboard reaction)

Normally I would try to do a bisect, but in this case I am in the
unfortunate Sitation that with earlier kernels I get problems with
other hardware (particularly the sas controller which currently holds
the only disks). So I have no known good version to start from.
Perhaps you have and Idea?

dmesg of different, likely related crashes, lspci -v and my latest
.config are attached.

As I am not sure what kernel code is actually causing the problem -
the backtraces looked innocent enoug on a short, clueless glance - I
dont know who to explicitly CC.

As small additional datapoints: using latencytop I get latencies in
the second area for various things (creating md request, creating
block layer request, radeon_fence_wait).
The problems seem to get more frequent after I enabled lockdep and RCU
debugging - possibly simply making the race more likely?

Thanks,

Andres

--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.35-rc4-andres (andres@awork2) (gcc version 4.4.4 (Ubuntu 4.4.4-6ubuntu2) ) #9 SMP Mon Jul 5 23:36:59 CEST 2010
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.35-rc4-andres root=UUID=58ba7a04-b424-4a46-acbe-b6ca208f61e1 ro clocksource=hpet netconsole=4444@192.168.224.176/eth0,4444@192.168.224/00:21:86:60:5d:d6
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
[    0.000000]  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf790000 (usable)
[    0.000000]  BIOS-e820: 00000000bf790000 - 00000000bf79e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf79e000 - 00000000bf7d0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf7d0000 - 00000000bf7e0000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf7ec000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffa00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000440000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x440000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D7FFF write-protect
[    0.000000]   D8000-DFFFF uncachable
[    0.000000]   E0000-E3FFF write-protect
[    0.000000]   E4000-E7FFF write-through
[    0.000000]   E8000-EBFFF write-protect
[    0.000000]   EC000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FC00000000 write-back
[    0.000000]   1 base 0400000000 mask FFC0000000 write-back
[    0.000000]   2 base 00C0000000 mask FFC0000000 uncachable
[    0.000000]   3 base 00BF800000 mask FFFF800000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000bf800000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbf790 max_arch_pfn = 0x400000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009d800 (usable)
[    0.000000]  modified: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000bf790000 (usable)
[    0.000000]  modified: 00000000bf790000 - 00000000bf79e000 (ACPI data)
[    0.000000]  modified: 00000000bf79e000 - 00000000bf7d0000 (ACPI NVS)
[    0.000000]  modified: 00000000bf7d0000 - 00000000bf7e0000 (reserved)
[    0.000000]  modified: 00000000bf7ec000 - 00000000c0000000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ffa00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000440000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] init_memory_mapping: 0000000000000000-00000000bf790000
[    0.000000]  0000000000 - 00bf600000 page 2M
[    0.000000]  00bf600000 - 00bf790000 page 4k
[    0.000000] kernel direct mapping tables up to bf790000 @ 16000-1b000
[    0.000000] init_memory_mapping: 0000000100000000-0000000440000000
[    0.000000]  0100000000 - 0440000000 page 2M
[    0.000000] kernel direct mapping tables up to 440000000 @ 19000-2b000
[    0.000000] RAMDISK: 37c8f000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000fa800 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000bf790100 0005C (v01 031710 XSDT1617 20100317 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bf790290 000F4 (v04 031710 FACP1617 20100317 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bf7904f0 0573E (v02  7002_ 7002_001 00000001 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bf79e000 00040
[    0.000000] ACPI: APIC 00000000bf790390 0011E (v02 031710 APIC1617 20100317 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bf7904b0 0003C (v01 031710 OEMMCFG  20100317 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bf79e040 0007A (v01 031710 OEMB1617 20100317 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000bf79a4f0 00038 (v01 031710 OEMHPET  20100317 MSFT 00000097)
[    0.000000] ACPI: DMAR 00000000bf79e0c0 00138 (v01    AMI  OEMDMAR 00000001 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bf7a0220 00363 (v01 DpgPmm    CpuPm 00000012 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000440000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000440000000
[    0.000000]   NODE_DATA [0000000100000000 - 0000000100004fff]
[    0.000000]  [ffffea0000000000-ffffea000edfffff] PMD -> [ffff880100200000-ffff88010e1fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00440000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000bf790
[    0.000000]     0: 0x00100000 -> 0x00440000
[    0.000000] On node 0 totalpages: 4192029
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3925 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 765896 pages, LIFO batch:31
[    0.000000]   Normal zone: 46592 pages used for memmap
[    0.000000]   Normal zone: 3361280 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x88] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x89] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x8a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x8b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x8c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x8d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x8e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x8f] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x90] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x91] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x92] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x93] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x94] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x95] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x96] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x97] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec8a000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec8a000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 20 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 24 CPUs, 16 hotplug CPUs
[    0.000000] nr_irqs_gsi: 64
[    0.000000] early_res array is doubled to 64 at [26000 - 267ff]
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bf790000 - 00000000bf79e000
[    0.000000] PM: Registered nosave memory: 00000000bf79e000 - 00000000bf7d0000
[    0.000000] PM: Registered nosave memory: 00000000bf7d0000 - 00000000bf7e0000
[    0.000000] PM: Registered nosave memory: 00000000bf7e0000 - 00000000bf7ec000
[    0.000000] PM: Registered nosave memory: 00000000bf7ec000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffa00000
[    0.000000] PM: Registered nosave memory: 00000000ffa00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:24 nr_node_ids:1
[    0.000000] early_res array is doubled to 128 at [26800 - 277ff]
[    0.000000] PERCPU: Embedded 477 pages/cpu @ffff880003200000 s1922304 r8192 d23296 u2097152
[    0.000000] pcpu-alloc: s1922304 r8192 d23296 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 [0] 01 [0] 02 [0] 03 [0] 04 [0] 05 [0] 06 [0] 07 
[    0.000000] pcpu-alloc: [0] 08 [0] 09 [0] 10 [0] 11 [0] 12 [0] 13 [0] 14 [0] 15 
[    0.000000] pcpu-alloc: [0] 16 [0] 17 [0] 18 [0] 19 [0] 20 [0] 21 [0] 22 [0] 23 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4131101
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.35-rc4-andres root=UUID=58ba7a04-b424-4a46-acbe-b6ca208f61e1 ro clocksource=hpet netconsole=4444@192.168.224.176/eth0,4444@192.168.224/00:21:86:60:5d:d6
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Subtract (79 early reservations)
[    0.000000]   #1 [0001000000 - 0002f92a30]   TEXT DATA BSS
[    0.000000]   #2 [0037c8f000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [0002f93000 - 0002f93155]             BRK
[    0.000000]   #4 [00000ff790 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000ff780 - 00000ff790]    MP-table mpf
[    0.000000]   #6 [000009d800 - 00000fdc50]   BIOS reserved
[    0.000000]   #7 [00000fde44 - 00000ff780]   BIOS reserved
[    0.000000]   #8 [00000fdc50 - 00000fde44]    MP-table mpc
[    0.000000]   #9 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #10 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #11 [0000016000 - 0000019000]         PGTABLE
[    0.000000]   #12 [0000019000 - 0000026000]         PGTABLE
[    0.000000]   #13 [0100000000 - 0100005000]       NODE_DATA
[    0.000000]   #14 [0002f93180 - 0002f94180]         BOOTMEM
[    0.000000]   #15 [0002f94180 - 0002f95180]         BOOTMEM
[    0.000000]   #16 [0100005000 - 0100005c00]         BOOTMEM
[    0.000000]   #17 [0100006000 - 0100007000]         BOOTMEM
[    0.000000]   #18 [0100007000 - 0100008000]         BOOTMEM
[    0.000000]   #19 [0100200000 - 010e200000]        MEMMAP 0
[    0.000000]   #20 [0002f95180 - 0002fe5180]         BOOTMEM
[    0.000000]   #21 [0002fe5180 - 0003035180]         BOOTMEM
[    0.000000]   #22 [0003035180 - 0003085180]         BOOTMEM
[    0.000000]   #23 [0003086000 - 0003087000]         BOOTMEM
[    0.000000]   #24 [0002f92a40 - 0002f92a81]         BOOTMEM
[    0.000000]   #25 [0002f92ac0 - 0002f92b46]         BOOTMEM
[    0.000000]   #26 [0002f92b80 - 0002f92e58]         BOOTMEM
[    0.000000]   #27 [0002f92e80 - 0002f92ee8]         BOOTMEM
[    0.000000]   #28 [0002f92f00 - 0002f92f68]         BOOTMEM
[    0.000000]   #29 [0002f92f80 - 0002f92fe8]         BOOTMEM
[    0.000000]   #30 [0003085180 - 00030851e8]         BOOTMEM
[    0.000000]   #31 [0003085200 - 0003085268]         BOOTMEM
[    0.000000]   #32 [0003085280 - 00030852e8]         BOOTMEM
[    0.000000]   #33 [0003085300 - 0003085368]         BOOTMEM
[    0.000000]   #34 [0003085380 - 00030853e8]         BOOTMEM
[    0.000000]   #35 [0003085400 - 0003085468]         BOOTMEM
[    0.000000]   #36 [0003085480 - 00030854e8]         BOOTMEM
[    0.000000]   #37 [0003085500 - 0003085568]         BOOTMEM
[    0.000000]   #38 [0003085580 - 00030855e8]         BOOTMEM
[    0.000000]   #39 [0003085600 - 0003085620]         BOOTMEM
[    0.000000]   #40 [0003085640 - 0003085660]         BOOTMEM
[    0.000000]   #41 [0003085680 - 0003085731]         BOOTMEM
[    0.000000]   #42 [0003085740 - 00030857f1]         BOOTMEM
[    0.000000]   #43 [0003200000 - 00033dd000]         BOOTMEM
[    0.000000]   #44 [0003400000 - 00035dd000]         BOOTMEM
[    0.000000]   #45 [0003600000 - 00037dd000]         BOOTMEM
[    0.000000]   #46 [0003800000 - 00039dd000]         BOOTMEM
[    0.000000]   #47 [0003a00000 - 0003bdd000]         BOOTMEM
[    0.000000]   #48 [0003c00000 - 0003ddd000]         BOOTMEM
[    0.000000]   #49 [0003e00000 - 0003fdd000]         BOOTMEM
[    0.000000]   #50 [0004000000 - 00041dd000]         BOOTMEM
[    0.000000]   #51 [0004200000 - 00043dd000]         BOOTMEM
[    0.000000]   #52 [0004400000 - 00045dd000]         BOOTMEM
[    0.000000]   #53 [0004600000 - 00047dd000]         BOOTMEM
[    0.000000]   #54 [0004800000 - 00049dd000]         BOOTMEM
[    0.000000]   #55 [0004a00000 - 0004bdd000]         BOOTMEM
[    0.000000]   #56 [0004c00000 - 0004ddd000]         BOOTMEM
[    0.000000]   #57 [0004e00000 - 0004fdd000]         BOOTMEM
[    0.000000]   #58 [0005000000 - 00051dd000]         BOOTMEM
[    0.000000]   #59 [0005200000 - 00053dd000]         BOOTMEM
[    0.000000]   #60 [0005400000 - 00055dd000]         BOOTMEM
[    0.000000]   #61 [0005600000 - 00057dd000]         BOOTMEM
[    0.000000]   #62 [0005800000 - 00059dd000]         BOOTMEM
[    0.000000]   #63 [0005a00000 - 0005bdd000]         BOOTMEM
[    0.000000]   #64 [0005c00000 - 0005ddd000]         BOOTMEM
[    0.000000]   #65 [0005e00000 - 0005fdd000]         BOOTMEM
[    0.000000]   #66 [0006000000 - 00061dd000]         BOOTMEM
[    0.000000]   #67 [0003085800 - 0003085808]         BOOTMEM
[    0.000000]   #68 [0003085840 - 0003085848]         BOOTMEM
[    0.000000]   #69 [0003085880 - 00030858e0]         BOOTMEM
[    0.000000]   #70 [0003085900 - 00030859c0]         BOOTMEM
[    0.000000]   #71 [00030859c0 - 0003085b10]         BOOTMEM
[    0.000000]   #72 [0003085b40 - 0003085bc0]         BOOTMEM
[    0.000000]   #73 [0003085bc0 - 0003085c40]         BOOTMEM
[    0.000000]   #74 [0003087000 - 000308f000]         BOOTMEM
[    0.000000]   #75 [00061dd000 - 000a1dd000]         BOOTMEM
[    0.000000]   #76 [000308f000 - 00030af000]         BOOTMEM
[    0.000000]   #77 [00030af000 - 00030ef000]         BOOTMEM
[    0.000000]   #78 [0000027800 - 000002f800]         BOOTMEM
[    0.000000] Memory: 16390072k/17825792k available (10688k kernel code, 1057676k absent, 378044k reserved, 9163k data, 2648k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=24, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU lockdep checking is enabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:1280
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] allocated 167772160 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.003333] Detected 2267.112 MHz processor.
[    0.000023] Calibrating delay loop (skipped), value calculated using timer frequency.. 4536.15 BogoMIPS (lpj=7557040)
[    0.000245] pid_max: default: 32768 minimum: 301
[    0.002530] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.007109] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.009068] Mount-cache hash table entries: 256
[    0.010043] Initializing cgroup subsys ns
[    0.010182] Initializing cgroup subsys cpuacct
[    0.010298] Initializing cgroup subsys memory
[    0.010468] Initializing cgroup subsys devices
[    0.010571] Initializing cgroup subsys freezer
[    0.010690] Initializing cgroup subsys net_cls
[    0.010875] CPU: Physical Processor ID: 1
[    0.010983] CPU: Processor Core ID: 0
[    0.011102] mce: CPU supports 9 MCE banks
[    0.011227] CPU0: Thermal monitoring enabled (TM1)
[    0.011372] using mwait in idle threads.
[    0.011485] Performance Events: PEBS fmt1+, Nehalem events, Intel PMU driver.
[    0.011863] ... version:                3
[    0.011980] ... bit width:              48
[    0.012123] ... generic registers:      4
[    0.012855] ... value mask:             0000ffffffffffff
[    0.012980] ... max period:             000000007fffffff
[    0.013105] ... fixed-purpose events:   3
[    0.013224] ... event mask:             000000070000000f
[    0.013482] ACPI: Core revision 20100428
[    0.067048] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.067176] ftrace: allocating 33074 entries in 130 pages
[    0.078942] DMAR: Host address width 40
[    0.079084] DMAR: DRHD base: 0x000000fbffe000 flags: 0x1
[    0.079227] IOMMU 0: reg_base_addr fbffe000 ver 1:0 cap c90780106f0462 ecap f0207e
[    0.079388] DMAR: RMRR base: 0x000000000ec000 end: 0x000000000effff
[    0.079520] DMAR: RMRR base: 0x000000bf7ec000 end: 0x000000bf7fffff
[    0.079662] DMAR: ATSR flags: 0x0
[    0.079924] IOAPIC id 8 under DRHD base  0xfbffe000 IOMMU 0
[    0.080064] IOAPIC id 9 under DRHD base  0xfbffe000 IOMMU 0
[    0.080352] Enabled Interrupt-remapping
[    0.080470] Setting APIC routing to physical flat
[    0.080615]   alloc irq_desc for 64 on node 0
[    0.080618]   alloc kstat_irqs on node 0
[    0.080974] alloc irq_2_iommu on node 0
[    0.080994] alloc irq_2_iommu on node 0
[    0.081008] alloc irq_2_iommu on node 0
[    0.081021] alloc irq_2_iommu on node 0
[    0.081034] alloc irq_2_iommu on node 0
[    0.081048] alloc irq_2_iommu on node 0
[    0.081061] alloc irq_2_iommu on node 0
[    0.081074] alloc irq_2_iommu on node 0
[    0.081088] alloc irq_2_iommu on node 0
[    0.081099] alloc irq_2_iommu on node 0
[    0.081112] alloc irq_2_iommu on node 0
[    0.081126] alloc irq_2_iommu on node 0
[    0.081139] alloc irq_2_iommu on node 0
[    0.081152] alloc irq_2_iommu on node 0
[    0.081166] alloc irq_2_iommu on node 0
[    0.081366] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.114438] CPU0: Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz stepping 05
[    0.218899] lockdep: fixing up alternatives.
[    0.219127] 
[    0.219128] ===================================================
[    0.219364] [ INFO: suspicious rcu_dereference_check() usage. ]
[    0.219459] ---------------------------------------------------
[    0.219602] kernel/sched.c:616 invoked rcu_dereference_check() without protection!
[    0.219770] 
[    0.219771] other info that might help us debug this:
[    0.219771] 
[    0.220138] 
[    0.220138] rcu_scheduler_active = 1, debug_locks = 0
[    0.220374] 3 locks held by swapper/1:
[    0.220512]  #0:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff810822a7>] cpu_maps_update_begin+0x17/0x20
[    0.220999]  #1:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff810822fc>] cpu_hotplug_begin+0x2c/0x60
[    0.221488]  #2:  (&rq->lock){-.....}, at: [<ffffffff81a5c5c8>] init_idle+0x39/0x38b
[    0.221995] 
[    0.221996] stack backtrace:
[    0.222240] Pid: 1, comm: swapper Not tainted 2.6.35-rc4-andres #9
[    0.222367] Call Trace:
[    0.222494]  [<ffffffff810b3afb>] lockdep_rcu_dereference+0xbb/0xc0
[    0.222636]  [<ffffffff81a5c6e9>] init_idle+0x15a/0x38b
[    0.222776]  [<ffffffff81a5ccfc>] fork_idle+0xbb/0xca
[    0.222920]  [<ffffffff81a62aa2>] ? __mutex_unlock_slowpath+0xc2/0x140
[    0.223061]  [<ffffffff81a5b096>] do_fork_idle+0x1c/0x2e
[    0.223178]  [<ffffffff81a5a9a0>] do_boot_cpu+0x133/0x64d
[    0.223323]  [<ffffffff81a5b07a>] ? do_fork_idle+0x0/0x2e
[    0.223442]  [<ffffffff81a5af72>] native_cpu_up+0xb8/0x116
[    0.223562]  [<ffffffff81a5cddb>] _cpu_up+0xa0/0x11d
[    0.223691]  [<ffffffff81a5cf36>] cpu_up+0xde/0xf1
[    0.223812]  [<ffffffff8253a6a1>] kernel_init+0xe2/0x207
[    0.223953]  [<ffffffff81036ed4>] kernel_thread_helper+0x4/0x10
[    0.224073]  [<ffffffff81a65bfc>] ? restore_args+0x0/0x30
[    0.224194]  [<ffffffff8253a5bf>] ? kernel_init+0x0/0x207
[    0.224338]  [<ffffffff81036ed0>] ? kernel_thread_helper+0x0/0x10
[    0.224470] Booting Node   0, Processors  #1lockdep: fixing up alternatives.
[    0.338522]  #2lockdep: fixing up alternatives.
[    0.451645]  #3lockdep: fixing up alternatives.
[    0.564789]  #4lockdep: fixing up alternatives.
[    0.677901]  #5lockdep: fixing up alternatives.
[    0.791028]  #6lockdep: fixing up alternatives.
[    0.904108]  #7
[    1.017102] Brought up 8 CPUs
[    1.017342] Total of 8 processors activated (36280.83 BogoMIPS).
[    1.020811] devtmpfs: initialized
[    1.023661] xor: automatically using best checksumming function: generic_sse
[    1.040261]    generic_sse:  8437.200 MB/sec
[    1.040398] xor: using function: generic_sse (8437.200 MB/sec)
[    1.040516] regulator: core version 0.5
[    1.040641] Time: 18:59:56  Date: 07/07/10
[    1.040832] NET: Registered protocol family 16
[    1.041106] ACPI: bus type pci registered
[    1.041287] dca service started, version 1.12.1
[    1.041461] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    1.041609] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    1.094676] PCI: Using configuration type 1 for base access
[    1.098276] bio: create slab <bio-0> at 0
[    1.101399] ACPI: EC: Look up EC in DSDT
[    1.104934] ACPI: Executed 1 blocks of module-level executable AML code
[    1.114016] ACPI: SSDT 00000000bf79e200 015DC (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
[    1.115285] ACPI: Dynamic OEM Table Load:
[    1.115551] ACPI: SSDT (null) 015DC (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
[    1.116121] ACPI: SSDT 00000000bf79f7e0 00678 (v01  PmRef  P001Cst 00003001 INTL 20051117)
[    1.117295] ACPI: Dynamic OEM Table Load:
[    1.117589] ACPI: SSDT (null) 00678 (v01  PmRef  P001Cst 00003001 INTL 20051117)
[    1.118085] ACPI: SSDT 00000000bf79fe60 003BA (v01  PmRef  Cpu0Tst 00003000 INTL 20051117)
[    1.119298] ACPI: Dynamic OEM Table Load:
[    1.119598] ACPI: SSDT (null) 003BA (v01  PmRef  Cpu0Tst 00003000 INTL 20051117)
[    1.120261] ACPI: Interpreter enabled
[    1.120377] ACPI: (supports S0 S1 S3 S4 S5)
[    1.120948] ACPI: Using IOAPIC for interrupt routing
[    1.137522] ACPI: No dock devices found.
[    1.137630] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.137950] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.138396] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.138518] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.138651] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.138790] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
[    1.138967] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xdfffffff]
[    1.139141] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfed8ffff]
[    1.139383] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    1.139512] pci 0000:00:00.0: PME# disabled
[    1.139698] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.139834] pci 0000:00:01.0: PME# disabled
[    1.140018] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    1.140156] pci 0000:00:03.0: PME# disabled
[    1.140359] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    1.140504] pci 0000:00:07.0: PME# disabled
[    1.140700] pci 0000:00:08.0: PME# supported from D0 D3hot D3cold
[    1.140840] pci 0000:00:08.0: PME# disabled
[    1.141039] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    1.141175] pci 0000:00:09.0: PME# disabled
[    1.141338] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    1.141447] pci 0000:00:0a.0: PME# disabled
[    1.141624] pci 0000:00:13.0: reg 10: [mem 0xfec8a000-0xfec8afff]
[    1.141789] pci 0000:00:13.0: PME# supported from D0 D3hot D3cold
[    1.141926] pci 0000:00:13.0: PME# disabled
[    1.142298] pci 0000:00:16.0: reg 10: [mem 0xfb8d4000-0xfb8d7fff 64bit]
[    1.142506] pci 0000:00:16.1: reg 10: [mem 0xfb8d8000-0xfb8dbfff 64bit]
[    1.142696] pci 0000:00:16.2: reg 10: [mem 0xfb8dc000-0xfb8dffff 64bit]
[    1.142898] pci 0000:00:16.3: reg 10: [mem 0xfb8e0000-0xfb8e3fff 64bit]
[    1.143103] pci 0000:00:16.4: reg 10: [mem 0xfb8e4000-0xfb8e7fff 64bit]
[    1.143313] pci 0000:00:16.5: reg 10: [mem 0xfb8e8000-0xfb8ebfff 64bit]
[    1.143507] pci 0000:00:16.6: reg 10: [mem 0xfb8ec000-0xfb8effff 64bit]
[    1.143698] pci 0000:00:16.7: reg 10: [mem 0xfb8f0000-0xfb8f3fff 64bit]
[    1.143960] pci 0000:00:1a.0: reg 20: [io  0x7400-0x741f]
[    1.144186] pci 0000:00:1a.1: reg 20: [io  0x7480-0x749f]
[    1.144423] pci 0000:00:1a.2: reg 20: [io  0x7800-0x781f]
[    1.144651] pci 0000:00:1a.7: reg 10: [mem 0xfb8f6000-0xfb8f63ff]
[    1.144867] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    1.145016] pci 0000:00:1a.7: PME# disabled
[    1.145262] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.145386] pci 0000:00:1c.0: PME# disabled
[    1.145622] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    1.145751] pci 0000:00:1c.4: PME# disabled
[    1.145977] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    1.146102] pci 0000:00:1c.5: PME# disabled
[    1.146325] pci 0000:00:1d.0: reg 20: [io  0x7880-0x789f]
[    1.146526] pci 0000:00:1d.1: reg 20: [io  0x7c00-0x7c1f]
[    1.146769] pci 0000:00:1d.2: reg 20: [io  0x8000-0x801f]
[    1.147019] pci 0000:00:1d.7: reg 10: [mem 0xfb8f8000-0xfb8f83ff]
[    1.147230] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.147353] pci 0000:00:1d.7: PME# disabled
[    1.147648] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
[    1.147820] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
[    1.147961] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0a00 (mask 00ff)
[    1.148133] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca0 (mask 000f)
[    1.148392] pci 0000:00:1f.2: reg 10: [io  0x8c00-0x8c07]
[    1.148515] pci 0000:00:1f.2: reg 14: [io  0x8880-0x8883]
[    1.148648] pci 0000:00:1f.2: reg 18: [io  0x8800-0x8807]
[    1.148798] pci 0000:00:1f.2: reg 1c: [io  0x8480-0x8483]
[    1.148917] pci 0000:00:1f.2: reg 20: [io  0x8400-0x840f]
[    1.149037] pci 0000:00:1f.2: reg 24: [io  0x8080-0x808f]
[    1.149251] pci 0000:00:1f.3: reg 10: [mem 0xfb8fa000-0xfb8fa0ff 64bit]
[    1.149407] pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
[    1.149608] pci 0000:00:1f.5: reg 10: [io  0x9c00-0x9c07]
[    1.149742] pci 0000:00:1f.5: reg 14: [io  0x9880-0x9883]
[    1.149873] pci 0000:00:1f.5: reg 18: [io  0x9800-0x9807]
[    1.150006] pci 0000:00:1f.5: reg 1c: [io  0x9480-0x9483]
[    1.150113] pci 0000:00:1f.5: reg 20: [io  0x9400-0x940f]
[    1.150254] pci 0000:00:1f.5: reg 24: [io  0x9080-0x908f]
[    1.150519] pci 0000:0a:00.0: reg 10: [io  0xe000-0xe0ff]
[    1.151293] pci 0000:0a:00.0: reg 14: [mem 0xfbefc000-0xfbefffff 64bit]
[    1.151433] pci 0000:0a:00.0: reg 1c: [mem 0xfbee0000-0xfbeeffff 64bit]
[    1.151581] pci 0000:0a:00.0: reg 30: [mem 0xfbc00000-0xfbdfffff pref]
[    1.151729] pci 0000:0a:00.0: supports D1 D2
[    1.151870] pci 0000:0a:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    1.152050] pci 0000:00:01.0: PCI bridge to [bus 0a-0a]
[    1.152178] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    1.152322] pci 0000:00:01.0:   bridge window [mem 0xfbc00000-0xfbefffff]
[    1.152435] pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.152644] pci 0000:00:03.0: PCI bridge to [bus 09-09]
[    1.152775] pci 0000:00:03.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.152917] pci 0000:00:03.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.153084] pci 0000:00:03.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.153301] pci 0000:08:00.0: reg 10: [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.153431] pci 0000:08:00.0: reg 18: [mem 0xfbbe0000-0xfbbeffff 64bit]
[    1.153584] pci 0000:08:00.0: reg 20: [io  0xd000-0xd0ff]
[    1.153703] pci 0000:08:00.0: reg 30: [mem 0xfbbc0000-0xfbbdffff pref]
[    1.153850] pci 0000:08:00.0: supports D1 D2
[    1.154022] pci 0000:08:00.1: reg 10: [mem 0xfbbfc000-0xfbbfffff 64bit]
[    1.154201] pci 0000:08:00.1: supports D1 D2
[    1.160185] pci 0000:00:07.0: PCI bridge to [bus 08-08]
[    1.160318] pci 0000:00:07.0:   bridge window [io  0xd000-0xdfff]
[    1.160462] pci 0000:00:07.0:   bridge window [mem 0xfbb00000-0xfbbfffff]
[    1.160579] pci 0000:00:07.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.160763] pci 0000:00:08.0: PCI bridge to [bus 07-07]
[    1.160898] pci 0000:00:08.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.161030] pci 0000:00:08.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.161185] pci 0000:00:08.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.161380] pci 0000:00:09.0: PCI bridge to [bus 06-06]
[    1.161489] pci 0000:00:09.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.161596] pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.161754] pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.161975] pci 0000:00:0a.0: PCI bridge to [bus 05-05]
[    1.162095] pci 0000:00:0a.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.162225] pci 0000:00:0a.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.162403] pci 0000:00:0a.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.162633] pci 0000:00:1c.0: PCI bridge to [bus 04-04]
[    1.162763] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.162908] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.163093] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.163475] pci 0000:03:00.0: reg 10: [mem 0xfbae0000-0xfbafffff]
[    1.163673] pci 0000:03:00.0: reg 18: [io  0xcc00-0xcc1f]
[    1.163821] pci 0000:03:00.0: reg 1c: [mem 0xfbadc000-0xfbadffff]
[    1.164217] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    1.164371] pci 0000:03:00.0: PME# disabled
[    1.164656] pci 0000:00:1c.4: PCI bridge to [bus 03-03]
[    1.164791] pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
[    1.164917] pci 0000:00:1c.4:   bridge window [mem 0xfba00000-0xfbafffff]
[    1.165069] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.165402] pci 0000:02:00.0: reg 10: [mem 0xfb9e0000-0xfb9fffff]
[    1.165596] pci 0000:02:00.0: reg 18: [io  0xbc00-0xbc1f]
[    1.165743] pci 0000:02:00.0: reg 1c: [mem 0xfb9dc000-0xfb9dffff]
[    1.166143] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    1.166299] pci 0000:02:00.0: PME# disabled
[    1.166577] pci 0000:00:1c.5: PCI bridge to [bus 02-02]
[    1.166714] pci 0000:00:1c.5:   bridge window [io  0xb000-0xbfff]
[    1.166867] pci 0000:00:1c.5:   bridge window [mem 0xfb900000-0xfb9fffff]
[    1.166996] pci 0000:00:1c.5:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.167236] pci 0000:01:00.0: reg 10: [mem 0xfb000000-0xfb7fffff]
[    1.167386] pci 0000:01:00.0: reg 14: [mem 0xfafe0000-0xfaffffff]
[    1.167532] pci 0000:01:00.0: reg 18: [io  0xac00-0xac7f]
[    1.167707] pci 0000:01:00.0: supports D1 D2
[    1.167833] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.167983] pci 0000:01:00.0: PME# disabled
[    1.168272] pci 0000:00:1e.0: PCI bridge to [bus 01-01] (subtractive decode)
[    1.168401] pci 0000:00:1e.0:   bridge window [io  0xa000-0xafff]
[    1.168550] pci 0000:00:1e.0:   bridge window [mem 0xfaf00000-0xfb7fffff]
[    1.168685] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.168855] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    1.169025] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    1.169185] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.169339] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    1.169488] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xdfffffff] (subtractive decode)
[    1.169664] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfed8ffff] (subtractive decode)
[    1.169881] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.170315] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    1.170629] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    1.170830] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
[    1.171044] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
[    1.171252] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1._PRT]
[    1.171435] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE3._PRT]
[    1.171639] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE7._PRT]
[    1.238753] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12 14 15)
[    1.239921] ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
[    1.240407] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 11 12 14 *15)
[    1.241570] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 *11 12 14 15)
[    1.242749] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
[    1.244118] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 *7 10 11 12 14 15)
[    1.245324] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
[    1.246675] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 7 10 11 12 *14 15)
[    1.247790] HEST: Table is not found!
[    1.248031] vgaarb: device added: PCI:0000:08:00.0,decodes=io+mem,owns=io+mem,locks=none
[    1.248194] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=none,locks=none
[    1.248364] vgaarb: loaded
[    1.248593] SCSI subsystem initialized
[    1.248909] libata version 3.00 loaded.
[    1.249109] usbcore: registered new interface driver usbfs
[    1.249260] usbcore: registered new interface driver hub
[    1.249417] usbcore: registered new device driver usb
[    1.303156] raid6: int64x1   2058 MB/s
[    1.359706] raid6: int64x2   2491 MB/s
[    1.416270] raid6: int64x4   1822 MB/s
[    1.472851] raid6: int64x8   1858 MB/s
[    1.529412] raid6: sse2x1    5619 MB/s
[    1.585977] raid6: sse2x2    6587 MB/s
[    1.642546] raid6: sse2x4    7372 MB/s
[    1.642675] raid6: using algorithm sse2x4 (7372 MB/s)
[    1.642834] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    1.642957] PCI: Using ACPI for IRQ routing
[    1.643094] PCI: pci_cache_line_size set to 64 bytes
[    1.643610] reserve RAM buffer: 000000000009d800 - 000000000009ffff 
[    1.643706] reserve RAM buffer: 00000000bf790000 - 00000000bfffffff 
[    1.644029] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    1.644289] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    1.644847] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    1.666025] Switching to clocksource hpet
[    1.686220] pnp: PnP ACPI init
[    1.686363] ACPI: bus type pnp registered
[    1.691960] pnp: PnP ACPI: found 15 devices
[    1.692069] ACPI: ACPI bus type pnp unregistered
[    1.692209] system 00:01: [mem 0xfbf00000-0xfbffffff] has been reserved
[    1.692340] system 00:01: [mem 0xfc000000-0xfcffffff] has been reserved
[    1.692484] system 00:01: [mem 0xfd000000-0xfdffffff] has been reserved
[    1.692617] system 00:01: [mem 0xfe000000-0xfebfffff] has been reserved
[    1.692747] system 00:01: [mem 0xfec8a000-0xfec8afff] could not be reserved
[    1.692902] system 00:01: [mem 0xfed10000-0xfed10fff] has been reserved
[    1.693031] system 00:08: [io  0x0a00-0x0a0f] has been reserved
[    1.693166] system 00:08: [io  0x0a10-0x0a1f] has been reserved
[    1.693296] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    1.693431] system 00:09: [io  0x0800-0x087f] has been reserved
[    1.693574] system 00:09: [io  0x0500-0x057f] could not be reserved
[    1.693707] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.693837] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
[    1.693970] system 00:09: [mem 0xfed40000-0xfed8ffff] has been reserved
[    1.694114] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.694255] system 00:0b: [mem 0xfee00000-0xfee00fff] has been reserved
[    1.694374] system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
[    1.694524] system 00:0e: [mem 0x00000000-0x0009ffff] could not be reserved
[    1.694668] system 00:0e: [mem 0x000c0000-0x000cffff] has been reserved
[    1.694797] system 00:0e: [mem 0x000e0000-0x000fffff] could not be reserved
[    1.694917] system 00:0e: [mem 0x00100000-0xbfffffff] could not be reserved
[    1.695054] system 00:0e: [mem 0xfed90000-0xffffffff] could not be reserved
[    1.700427] pci 0000:00:1c.0: BAR 14: assigned [mem 0xc0000000-0xc01fffff]
[    1.700571] pci 0000:00:1c.0: BAR 15: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
[    1.700723] pci 0000:00:1c.4: BAR 15: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
[    1.700891] pci 0000:00:1c.5: BAR 15: assigned [mem 0xc0600000-0xc07fffff 64bit pref]
[    1.701039] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    1.701182] pci 0000:00:01.0: PCI bridge to [bus 0a-0a]
[    1.701322] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    1.701444] pci 0000:00:01.0:   bridge window [mem 0xfbc00000-0xfbefffff]
[    1.701590] pci 0000:00:01.0:   bridge window [mem pref disabled]
[    1.702357] pci 0000:00:03.0: PCI bridge to [bus 09-09]
[    1.702499] pci 0000:00:03.0:   bridge window [io  disabled]
[    1.702644] pci 0000:00:03.0:   bridge window [mem disabled]
[    1.702781] pci 0000:00:03.0:   bridge window [mem pref disabled]
[    1.702911] pci 0000:00:07.0: PCI bridge to [bus 08-08]
[    1.703044] pci 0000:00:07.0:   bridge window [io  0xd000-0xdfff]
[    1.703179] pci 0000:00:07.0:   bridge window [mem 0xfbb00000-0xfbbfffff]
[    1.703310] pci 0000:00:07.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.703483] pci 0000:00:08.0: PCI bridge to [bus 07-07]
[    1.703589] pci 0000:00:08.0:   bridge window [io  disabled]
[    1.703696] pci 0000:00:08.0:   bridge window [mem disabled]
[    1.703819] pci 0000:00:08.0:   bridge window [mem pref disabled]
[    1.703958] pci 0000:00:09.0: PCI bridge to [bus 06-06]
[    1.704075] pci 0000:00:09.0:   bridge window [io  disabled]
[    1.704192] pci 0000:00:09.0:   bridge window [mem disabled]
[    1.704324] pci 0000:00:09.0:   bridge window [mem pref disabled]
[    1.704451] pci 0000:00:0a.0: PCI bridge to [bus 05-05]
[    1.704588] pci 0000:00:0a.0:   bridge window [io  disabled]
[    1.704694] pci 0000:00:0a.0:   bridge window [mem disabled]
[    1.704796] pci 0000:00:0a.0:   bridge window [mem pref disabled]
[    1.704919] pci 0000:00:1c.0: PCI bridge to [bus 04-04]
[    1.705066] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    1.705196] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff]
[    1.705322] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
[    1.705494] pci 0000:00:1c.4: PCI bridge to [bus 03-03]
[    1.705624] pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
[    1.705762] pci 0000:00:1c.4:   bridge window [mem 0xfba00000-0xfbafffff]
[    1.705884] pci 0000:00:1c.4:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
[    1.706048] pci 0000:00:1c.5: PCI bridge to [bus 02-02]
[    1.706201] pci 0000:00:1c.5:   bridge window [io  0xb000-0xbfff]
[    1.706329] pci 0000:00:1c.5:   bridge window [mem 0xfb900000-0xfb9fffff]
[    1.706456] pci 0000:00:1c.5:   bridge window [mem 0xc0600000-0xc07fffff 64bit pref]
[    1.706632] pci 0000:00:1e.0: PCI bridge to [bus 01-01]
[    1.706771] pci 0000:00:1e.0:   bridge window [io  0xa000-0xafff]
[    1.706910] pci 0000:00:1e.0:   bridge window [mem 0xfaf00000-0xfb7fffff]
[    1.707033] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    1.707188] pci 0000:00:01.0: setting latency timer to 64
[    1.707326] pci 0000:00:03.0: setting latency timer to 64
[    1.707475] pci 0000:00:07.0: setting latency timer to 64
[    1.707582] pci 0000:00:08.0: setting latency timer to 64
[    1.707719] pci 0000:00:09.0: setting latency timer to 64
[    1.707861] pci 0000:00:0a.0: setting latency timer to 64
[    1.708010] pci 0000:00:1c.0: enabling device (0104 -> 0107)
[    1.708146]   alloc irq_desc for 17 on node -1
[    1.708271]   alloc kstat_irqs on node -1
[    1.708401] alloc irq_2_iommu on node -1
[    1.708505] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.708655] pci 0000:00:1c.0: setting latency timer to 64
[    1.708788] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.708912] pci 0000:00:1c.4: setting latency timer to 64
[    1.709059]   alloc irq_desc for 16 on node -1
[    1.709173]   alloc kstat_irqs on node -1
[    1.709297] alloc irq_2_iommu on node -1
[    1.709408] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    1.709569] pci 0000:00:1c.5: setting latency timer to 64
[    1.709697] pci 0000:00:1e.0: setting latency timer to 64
[    1.709808] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.709950] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.710085] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.710208] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    1.710315] pci_bus 0000:00: resource 8 [mem 0xc0000000-0xdfffffff]
[    1.710454] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfed8ffff]
[    1.710575] pci_bus 0000:0a: resource 0 [io  0xe000-0xefff]
[    1.710687] pci_bus 0000:0a: resource 1 [mem 0xfbc00000-0xfbefffff]
[    1.710790] pci_bus 0000:08: resource 0 [io  0xd000-0xdfff]
[    1.710904] pci_bus 0000:08: resource 1 [mem 0xfbb00000-0xfbbfffff]
[    1.711038] pci_bus 0000:08: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.711207] pci_bus 0000:04: resource 0 [io  0x1000-0x1fff]
[    1.711314] pci_bus 0000:04: resource 1 [mem 0xc0000000-0xc01fffff]
[    1.711443] pci_bus 0000:04: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
[    1.711611] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
[    1.711726] pci_bus 0000:03: resource 1 [mem 0xfba00000-0xfbafffff]
[    1.711869] pci_bus 0000:03: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
[    1.712023] pci_bus 0000:02: resource 0 [io  0xb000-0xbfff]
[    1.712166] pci_bus 0000:02: resource 1 [mem 0xfb900000-0xfb9fffff]
[    1.712302] pci_bus 0000:02: resource 2 [mem 0xc0600000-0xc07fffff 64bit pref]
[    1.712471] pci_bus 0000:01: resource 0 [io  0xa000-0xafff]
[    1.712585] pci_bus 0000:01: resource 1 [mem 0xfaf00000-0xfb7fffff]
[    1.712714] pci_bus 0000:01: resource 4 [io  0x0000-0x0cf7]
[    1.712862] pci_bus 0000:01: resource 5 [io  0x0d00-0xffff]
[    1.712985] pci_bus 0000:01: resource 6 [mem 0x000a0000-0x000bffff]
[    1.713101] pci_bus 0000:01: resource 7 [mem 0x000d0000-0x000dffff]
[    1.713242] pci_bus 0000:01: resource 8 [mem 0xc0000000-0xdfffffff]
[    1.713370] pci_bus 0000:01: resource 9 [mem 0xf0000000-0xfed8ffff]
[    1.713537] NET: Registered protocol family 2
[    1.714129] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    1.715765] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.717902] TCP bind hash table entries: 65536 (order: 10, 4718592 bytes)
[    1.719892] TCP: Hash tables configured (established 524288 bind 65536)
[    1.720029] TCP reno registered
[    1.720276] UDP hash table entries: 8192 (order: 8, 1310720 bytes)
[    1.720964] UDP-Lite hash table entries: 8192 (order: 8, 1310720 bytes)
[    1.721734] NET: Registered protocol family 1
[    1.722308] RPC: Registered udp transport module.
[    1.722432] RPC: Registered tcp transport module.
[    1.722550] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.723014] swapper:1 freeing invalid memtype fb8f8000-fb8f9000
[    1.723167] pci 0000:08:00.0: Boot video device
[    1.723388] PCI: CLS 256 bytes, default 64
[    1.723569] Trying to unpack rootfs image as initramfs...
[    1.791266] Freeing initrd memory: 3460k freed
[    1.791950] IOMMU 0 0xfbffe000: using Queued invalidation
[    1.792080] IOMMU: Setting RMRR:
[    1.792238] IOMMU: Setting identity map for device 0000:00:1d.0 [0xbf7ec000 - 0xbf800000]
[    1.792461] IOMMU: Setting identity map for device 0000:00:1d.1 [0xbf7ec000 - 0xbf800000]
[    1.792682] IOMMU: Setting identity map for device 0000:00:1d.2 [0xbf7ec000 - 0xbf800000]
[    1.792893] IOMMU: Setting identity map for device 0000:00:1d.7 [0xbf7ec000 - 0xbf800000]
[    1.793092] IOMMU: Setting identity map for device 0000:00:1a.0 [0xbf7ec000 - 0xbf800000]
[    1.793294] IOMMU: Setting identity map for device 0000:00:1a.1 [0xbf7ec000 - 0xbf800000]
[    1.793493] IOMMU: Setting identity map for device 0000:00:1a.2 [0xbf7ec000 - 0xbf800000]
[    1.793690] IOMMU: Setting identity map for device 0000:00:1a.7 [0xbf7ec000 - 0xbf800000]
[    1.793884] IOMMU: Setting identity map for device 0000:00:1d.0 [0xec000 - 0xf0000]
[    1.794064] IOMMU: Setting identity map for device 0000:00:1d.1 [0xec000 - 0xf0000]
[    1.794238] IOMMU: Setting identity map for device 0000:00:1d.2 [0xec000 - 0xf0000]
[    1.794387] IOMMU: Setting identity map for device 0000:00:1d.7 [0xec000 - 0xf0000]
[    1.794553] IOMMU: Setting identity map for device 0000:00:1a.0 [0xec000 - 0xf0000]
[    1.794735] IOMMU: Setting identity map for device 0000:00:1a.1 [0xec000 - 0xf0000]
[    1.794919] IOMMU: Setting identity map for device 0000:00:1a.2 [0xec000 - 0xf0000]
[    1.795096] IOMMU: Setting identity map for device 0000:00:1a.7 [0xec000 - 0xf0000]
[    1.795285] IOMMU: Prepare 0-16MiB unity mapping for LPC
[    1.795421] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0x1000000]
[    1.795722] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
[    1.799801] microcode: CPU0 sig=0x106a5, pf=0x1, revision=0x11
[    1.799955] microcode: CPU1 sig=0x106a5, pf=0x1, revision=0x11
[    1.800102] microcode: CPU2 sig=0x106a5, pf=0x1, revision=0x11
[    1.800252] microcode: CPU3 sig=0x106a5, pf=0x1, revision=0x11
[    1.800410] microcode: CPU4 sig=0x106a5, pf=0x1, revision=0x11
[    1.800562] microcode: CPU5 sig=0x106a5, pf=0x1, revision=0x11
[    1.800710] microcode: CPU6 sig=0x106a5, pf=0x1, revision=0x11
[    1.800847] microcode: CPU7 sig=0x106a5, pf=0x1, revision=0x11
[    1.801010] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.801182] Scanning for low memory corruption every 60 seconds
[    1.801453] audit: initializing netlink socket (disabled)
[    1.801597] type=2000 audit(1278529196.533:1): initialized
[    1.834232] rcu-torture:--- Start of test: nreaders=16 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3
[    1.836069] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.838994] VFS: Disk quotas dquot_6.5.2
[    1.839248] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.840685] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.841233] Slow work thread pool: Starting up
[    1.841453] Slow work thread pool: Ready
[    1.841569] NTFS driver 2.1.29 [Flags: R/W].
[    1.841831] fuse init (API version 7.14)
[    1.842154] SGI XFS with ACLs, security attributes, large block/inode numbers, debug enabled
[    1.843861] SGI XFS Quota Management subsystem
[    1.844199] Btrfs loaded
[    1.844327] msgmni has been set to 32147
[    1.845332] alg: No test for stdrng (krng)
[    1.845473] async_tx: api initialized (async)
[    1.846310] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.846488] io scheduler noop registered
[    1.846626] io scheduler deadline registered
[    1.846806] io scheduler cfq registered (default)
[    1.847118] pcieport 0000:00:01.0: setting latency timer to 64
[    1.847294]   alloc irq_desc for 65 on node -1
[    1.847410]   alloc kstat_irqs on node -1
[    1.847529] alloc irq_2_iommu on node -1
[    1.847672] pcieport 0000:00:01.0: irq 65 for MSI/MSI-X
[    1.847892] pcieport 0000:00:03.0: setting latency timer to 64
[    1.848066]   alloc irq_desc for 66 on node -1
[    1.848189]   alloc kstat_irqs on node -1
[    1.848329] alloc irq_2_iommu on node -1
[    1.848467] pcieport 0000:00:03.0: irq 66 for MSI/MSI-X
[    1.848682] pcieport 0000:00:07.0: setting latency timer to 64
[    1.848855]   alloc irq_desc for 67 on node -1
[    1.848987]   alloc kstat_irqs on node -1
[    1.849128] alloc irq_2_iommu on node -1
[    1.849274] pcieport 0000:00:07.0: irq 67 for MSI/MSI-X
[    1.849468] pcieport 0000:00:08.0: setting latency timer to 64
[    1.849625]   alloc irq_desc for 68 on node -1
[    1.849712]   alloc kstat_irqs on node -1
[    1.849848] alloc irq_2_iommu on node -1
[    1.849990] pcieport 0000:00:08.0: irq 68 for MSI/MSI-X
[    1.850205] pcieport 0000:00:09.0: setting latency timer to 64
[    1.850371]   alloc irq_desc for 69 on node -1
[    1.850506]   alloc kstat_irqs on node -1
[    1.850645] alloc irq_2_iommu on node -1
[    1.850775] pcieport 0000:00:09.0: irq 69 for MSI/MSI-X
[    1.850983] pcieport 0000:00:0a.0: setting latency timer to 64
[    1.851145]   alloc irq_desc for 70 on node -1
[    1.851280]   alloc kstat_irqs on node -1
[    1.851419] alloc irq_2_iommu on node -1
[    1.851549] pcieport 0000:00:0a.0: irq 70 for MSI/MSI-X
[    1.851775] pcieport 0000:00:1c.0: setting latency timer to 64
[    1.851940]   alloc irq_desc for 71 on node -1
[    1.852080]   alloc kstat_irqs on node -1
[    1.852203] alloc irq_2_iommu on node -1
[    1.852349] pcieport 0000:00:1c.0: irq 71 for MSI/MSI-X
[    1.852608] pcieport 0000:00:1c.4: setting latency timer to 64
[    1.852772]   alloc irq_desc for 72 on node -1
[    1.852893]   alloc kstat_irqs on node -1
[    1.853024] alloc irq_2_iommu on node -1
[    1.853144] pcieport 0000:00:1c.4: irq 72 for MSI/MSI-X
[    1.853396] pcieport 0000:00:1c.5: setting latency timer to 64
[    1.853556]   alloc irq_desc for 73 on node -1
[    1.853683]   alloc kstat_irqs on node -1
[    1.853798] alloc irq_2_iommu on node -1
[    1.853932] pcieport 0000:00:1c.5: irq 73 for MSI/MSI-X
[    1.854181] aer 0000:00:01.0:pcie02: AER service couldn't init device: no _OSC support
[    1.854363] aer 0000:00:03.0:pcie02: AER service couldn't init device: no _OSC support
[    1.854546] aer 0000:00:07.0:pcie02: AER service couldn't init device: no _OSC support
[    1.854722] aer 0000:00:08.0:pcie02: AER service couldn't init device: no _OSC support
[    1.854903] aer 0000:00:09.0:pcie02: AER service couldn't init device: no _OSC support
[    1.855078] aer 0000:00:0a.0:pcie02: AER service couldn't init device: no _OSC support
[    1.855290] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.855553] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.855688] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver version: 0.1
[    1.855850] cpcihp_generic: not configured, disabling.
[    1.856000] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    1.856130] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.856996] vga16fb: initializing
[    1.857133] vga16fb: mapped to 0xffff8800000a0000
[    1.997408] Console: switching to colour frame buffer device 80x30
[    2.006707] fb0: VGA16 VGA frame buffer device
[    2.007108] intel_idle: MWAIT substates: 0x1120
[    2.007554] intel_idle: v0.4 model 0x1A
[    2.007966] intel_idle: lapic_timer_reliable_states 0x2
[    2.008543] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    2.018024] ACPI: Power Button [PWRB]
[    2.023822] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.036987] ACPI: Power Button [PWRF]
[    2.045318] ACPI: acpi_idle yielding to intel_idle
[    2.057764] ERST: Table is not found!
[    2.074423] GHES: HEST is not enabled!
[    2.085354] Non-volatile memory driver v1.3
[    2.095082] Linux agpgart interface v0.103
[    2.105113] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    2.128579] Hangcheck: Using getrawmonotonic().
[    2.141265] [drm] Initialized drm 1.1.0 20060810
[    2.141282] [drm] radeon defaulting to kernel modesetting.
[    2.141283] [drm] radeon kernel modesetting enabled.
[    2.141340]   alloc irq_desc for 30 on node -1
[    2.141342]   alloc kstat_irqs on node -1
[    2.141346] alloc irq_2_iommu on node -1
[    2.141353] radeon 0000:08:00.0: PCI INT A -> GSI 30 (level, low) -> IRQ 30
[    2.141357] radeon 0000:08:00.0: setting latency timer to 64
[    2.142664] [drm] initializing kernel modesetting (RV710 0x1002:0x954F).
[    2.181561] [drm] register mmio base: 0xFBBE0000
[    2.181562] [drm] register mmio size: 65536
[    2.181725] swapper:1 freeing invalid memtype d0000000-d0040000
[    2.181757] ATOM BIOS: 954F.11.22.6.0.AS03
[    2.181767] [drm] Clocks initialized !
[    2.181793] radeon 0000:08:00.0: VRAM: 1024M 0x00000000 - 0x3FFFFFFF (1024M used)
[    2.181795] radeon 0000:08:00.0: GTT: 512M 0x40000000 - 0x5FFFFFFF
[    2.181811] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[    2.181813] [drm] Detected VRAM RAM=1024M, BAR=256M
[    2.181814] [drm] RAM width 64bits DDR
[    2.181907] [TTM] Zone  kernel: Available graphics memory: 8229740 kiB.
[    2.181909] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[    2.181911] [TTM] Initializing pool allocator.
[    2.181928] [drm] radeon: 1024M of VRAM memory ready
[    2.181930] [drm] radeon: 512M of GTT memory ready.
[    2.181982]   alloc irq_desc for 74 on node -1
[    2.181983]   alloc kstat_irqs on node -1
[    2.181987] alloc irq_2_iommu on node -1
[    2.181998] radeon 0000:08:00.0: irq 74 for MSI/MSI-X
[    2.182004] [drm] radeon: using MSI.
[    2.182035] [drm] radeon: irq initialized.
[    2.182037] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    2.182537] [drm] Loading RV710 Microcode
[    2.313360] swapper:1 freeing invalid memtype d0140000-d0141000
[    2.360330] [drm] ring test succeeded in 1 usecs
[    2.360714] [drm] radeon: ib pool ready.
[    2.360835] [drm] ib test succeeded in 0 usecs
[    2.360837] [drm] Enabling audio support
[    2.360916] [drm] Default TV standard: PAL
[    2.360962] [drm] Default TV standard: PAL
[    2.361012] [drm] Radeon Display Connectors
[    2.361013] [drm] Connector 0:
[    2.361014] [drm]   HDMI-A
[    2.361015] [drm]   HPD1
[    2.361017] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[    2.361018] [drm]   Encoders:
[    2.361019] [drm]     DFP1: INTERNAL_UNIPHY
[    2.361020] [drm] Connector 1:
[    2.361021] [drm]   VGA
[    2.361023] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[    2.361024] [drm]   Encoders:
[    2.361025] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
[    2.361026] [drm] Connector 2:
[    2.361027] [drm]   DVI-I
[    2.361028] [drm]   HPD4
[    2.361029] [drm]   DDC: 0x7f10 0x7f10 0x7f14 0x7f14 0x7f18 0x7f18 0x7f1c 0x7f1c
[    2.361030] [drm]   Encoders:
[    2.361031] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    2.361033] [drm]     DFP2: INTERNAL_UNIPHY2
[    2.419080] [drm] Internal thermal controller without fan control
[    2.419094] [drm] radeon: power management initialized
[    3.230715] [drm] fb mappable at 0xD0141000
[    3.247097] [drm] vram apper at 0xD0000000
[    3.263445] [drm] size 16384000
[    3.279873] [drm] fb depth is 24
[    3.296436] [drm]    pitch is 10240
[    3.313151] checking generic (a0000 10000) vs hw (d0000000 40000000)
[    3.330804] fb: conflicting fb hw usage radeondrmfb vs VGA16 VGA - removing generic driver
[    3.386747] Console: switching to colour VGA+ 80x25
[    4.611454] Console: switching to colour frame buffer device 320x100
[    4.621213] fb0: radeondrmfb frame buffer device
[    4.621214] drm: registered panic notifier
[    4.621276] [drm] Initialized radeon 2.5.0 20080528 for 0000:08:00.0 on minor 0
[    4.621337] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
[    4.621376] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.621537] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.621682] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    4.622011] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.622194] 00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    4.623889] brd: module loaded
[    4.624648] loop: module loaded
[    4.625204] Loading iSCSI transport class v2.0-870.
[    4.625401] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    4.625464] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    4.625527] megasas: 00.00.04.17.1-rc1 Thu. Oct. 29, 11:41:51 PST 2009
[    4.625596] mpt2sas version 05.100.00.02 loaded
[    4.625805] ata_piix 0000:00:1f.2: version 2.13
[    4.625856]   alloc irq_desc for 19 on node -1
[    4.625883]   alloc kstat_irqs on node -1
[    4.625908] alloc irq_2_iommu on node -1
[    4.625935] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    4.625982] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    4.626106] ata_piix 0000:00:1f.2: setting latency timer to 64
[    4.626261] scsi0 : ata_piix
[    4.626391] scsi1 : ata_piix
[    4.628361] ata1: SATA max UDMA/133 cmd 0x8c00 ctl 0x8880 bmdma 0x8400 irq 19
[    4.628406] ata2: SATA max UDMA/133 cmd 0x8800 ctl 0x8480 bmdma 0x8408 irq 19
[    4.628473] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    4.628514] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    4.628633] ata_piix 0000:00:1f.5: setting latency timer to 64
[    4.628765] scsi2 : ata_piix
[    4.628866] scsi3 : ata_piix
[    4.630594] ata3: SATA max UDMA/133 cmd 0x9c00 ctl 0x9880 bmdma 0x9400 irq 19
[    4.630637] ata4: SATA max UDMA/133 cmd 0x9800 ctl 0x9480 bmdma 0x9408 irq 19
[    4.631077] Fixed MDIO Bus: probed
[    4.631131] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k4
[    4.631162] e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
[    4.631307] e1000e 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.631380] e1000e 0000:03:00.0: setting latency timer to 64
[    4.631969]   alloc irq_desc for 75 on node -1
[    4.631994]   alloc kstat_irqs on node -1
[    4.632018] alloc irq_2_iommu on node -1
[    4.632044] e1000e 0000:03:00.0: irq 75 for MSI/MSI-X
[    4.632071]   alloc irq_desc for 76 on node -1
[    4.632095]   alloc kstat_irqs on node -1
[    4.632118] alloc irq_2_iommu on node -1
[    4.632144] e1000e 0000:03:00.0: irq 76 for MSI/MSI-X
[    4.632171]   alloc irq_desc for 77 on node -1
[    4.632195]   alloc kstat_irqs on node -1
[    4.632217] alloc irq_2_iommu on node -1
[    4.632243] e1000e 0000:03:00.0: irq 77 for MSI/MSI-X
[    4.632539] e1000e 0000:03:00.0: Disabling ASPM L0s 
[    4.740006] e1000e 0000:03:00.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:e0:81:b8:df:4a
[    4.740048] e1000e 0000:03:00.0: eth0: Intel(R) PRO/1000 Network Connection
[    4.740183] e1000e 0000:03:00.0: eth0: MAC: 3, PHY: 8, PBA No: ffffff-0ff
[    4.740259] e1000e 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    4.740332] e1000e 0000:02:00.0: setting latency timer to 64
[    4.740889]   alloc irq_desc for 78 on node -1
[    4.740915]   alloc kstat_irqs on node -1
[    4.740938] alloc irq_2_iommu on node -1
[    4.740965] e1000e 0000:02:00.0: irq 78 for MSI/MSI-X
[    4.740992]   alloc irq_desc for 79 on node -1
[    4.741016]   alloc kstat_irqs on node -1
[    4.741039] alloc irq_2_iommu on node -1
[    4.741065] e1000e 0000:02:00.0: irq 79 for MSI/MSI-X
[    4.741091]   alloc irq_desc for 80 on node -1
[    4.741116]   alloc kstat_irqs on node -1
[    4.741138] alloc irq_2_iommu on node -1
[    4.741164] e1000e 0000:02:00.0: irq 80 for MSI/MSI-X
[    4.741808] e1000e 0000:02:00.0: Disabling ASPM L0s 
[    4.851601] e1000e 0000:02:00.0: eth1: (PCI Express:2.5GB/s:Width x1) 00:e0:81:b8:df:4b
[    4.851642] e1000e 0000:02:00.0: eth1: Intel(R) PRO/1000 Network Connection
[    4.851782] e1000e 0000:02:00.0: eth1: MAC: 3, PHY: 8, PBA No: ffffff-0ff
[    4.851835] PPP generic driver version 2.4.2
[    4.852253] tun: Universal TUN/TAP device driver, 1.6
[    4.854090] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.856006] netconsole: local port 4444
[    4.857897] netconsole: local IP 192.168.224.176
[    4.859788] netconsole: interface 'eth0'
[    4.861701] netconsole: remote port 4444
[    4.863611] netconsole: remote IP 192.168.224.0
[    4.865550] netconsole: remote ethernet address 00:21:86:60:5d:d6
[    4.867494] netconsole: device eth0 not up yet, forcing it
[    5.271551] ata4: SATA link down (SStatus 0 SControl 300)
[    5.420027] ata2.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.420046] ata1.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.420065] ata1.01: SATA link down (SStatus 0 SControl 300)
[    5.426154] ata2.01: SATA link down (SStatus 0 SControl 0)
[    5.431273] ata1.00: ATA-7: Maxtor 6V320F0, VA111900, max UDMA/133
[    5.433380] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    5.436719] ata2.00: ATA-7: Maxtor 6V320F0, VA111900, max UDMA/133
[    5.438872] ata2.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    5.447900] ata1.00: configured for UDMA/133
[    5.450253] scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6V320F0   VA11 PQ: 0 ANSI: 5
[    5.452617] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.452643] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    5.452704] sd 0:0:0:0: [sda] Write Protect is off
[    5.452706] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.452732] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.452912]  sda:
[    5.454668] ata2.00: configured for UDMA/133
[    5.468100] scsi 1:0:0:0: Direct-Access     ATA      Maxtor 6V320F0   VA11 PQ: 0 ANSI: 5
[    5.470552] sd 1:0:0:0: [sdb] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    5.470564] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    5.475062]  sda1 sda2
[    5.475120] sd 1:0:0:0: [sdb] Write Protect is off
[    5.475122] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    5.475148] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.480247] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.486481]  sdb:
[    5.486645] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.486999] ata3.00: ATAPI: ATAPI   iHAS324   A, BL1P, max UDMA/100
[    5.499997] ata3.00: configured for UDMA/100
[    5.502833]  sdb1 sdb2
[    5.505451] sd 1:0:0:0: [sdb] Attached SCSI disk
[    5.507778] scsi 2:0:0:0: CD-ROM            ATAPI    iHAS324   A      BL1P PQ: 0 ANSI: 5
[    5.515994] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    5.518336] Uniform CD-ROM driver Revision: 3.20
[    5.520799] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    5.523171] sr 2:0:0:0: Attached scsi generic sg2 type 5
[    8.602701] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   10.740305] console [netcon0] enabled
[   10.740307] netconsole: network logging started
[   10.740328] Fusion MPT base driver 3.04.15
[   10.740329] Copyright (c) 1999-2008 LSI Corporation
[   10.740338] Fusion MPT SPI Host driver 3.04.15
[   10.740373] Fusion MPT FC Host driver 3.04.15
[   10.740402] Fusion MPT SAS Host driver 3.04.15
[   10.740437]   alloc irq_desc for 28 on node -1
[   10.740439]   alloc kstat_irqs on node -1
[   10.740442] alloc irq_2_iommu on node -1
[   10.740450] mptsas 0000:0a:00.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
[   10.741193] mptbase: ioc0: Initiating bringup
[   11.346752] ioc0: LSISAS1068E B3: Capabilities={Initiator}
[   11.349151] mptsas 0000:0a:00.0: setting latency timer to 64
[   22.181847] scsi4 : ioc0: LSISAS1068E B3, FwRev=011a0000h, Ports=1, MaxQ=266, IRQ=28
[   22.222876] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 9, phy 0, sas_addr 0x816f9b3796d4dac1
[   22.228637] scsi 4:0:0:0: Direct-Access     ATA      Hitachi HDS72202 A20N PQ: 0 ANSI: 5
[   22.232538] sd 4:0:0:0: Attached scsi generic sg3 type 0
[   22.235204] sd 4:0:0:0: [sdc] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   22.238360] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 13, phy 1, sas_addr 0x816f9b40abd2efc1
[   22.243999] scsi 4:0:1:0: Direct-Access     ATA      Hitachi HDS72202 A20N PQ: 0 ANSI: 5
[   22.248004] sd 4:0:1:0: Attached scsi generic sg4 type 0
[   22.250836] sd 4:0:1:0: [sdd] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   22.254054] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 8, phy 2, sas_addr 0x816f9b4881d8f4c1
[   22.259782] scsi 4:0:2:0: Direct-Access     ATA      Hitachi HDS72202 A20N PQ: 0 ANSI: 5
[   22.263858] sd 4:0:2:0: Attached scsi generic sg5 type 0
[   22.266762] sd 4:0:2:0: [sde] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   22.270065] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 11, phy 3, sas_addr 0x816f9b45a1b6e8c1
[   22.275895] scsi 4:0:3:0: Direct-Access     ATA      Hitachi HDS72202 A20N PQ: 0 ANSI: 5
[   22.280068] sd 4:0:3:0: Attached scsi generic sg6 type 0
[   22.283050] sd 4:0:3:0: [sdf] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   22.286358] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 10, phy 4, sas_addr 0x816f9b4598b701c2
[   22.292282] scsi 4:0:4:0: Direct-Access     ATA      Hitachi HDS72202 A20N PQ: 0 ANSI: 5
[   22.296546] sd 4:0:4:0: Attached scsi generic sg7 type 0
[   22.299569] sd 4:0:4:0: [sdg] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   22.303021] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 14, phy 5, sas_addr 0x816f9b40a7c1dec1
[   22.309004] scsi 4:0:5:0: Direct-Access     ATA      Hitachi HDS72202 A20N PQ: 0 ANSI: 5
[   22.313359] sd 4:0:5:0: Attached scsi generic sg8 type 0
[   22.316519] sd 4:0:5:0: [sdh] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   22.320090] Fusion MPT misc device (ioctl) driver 3.04.15
[   22.323017] mptctl: Registered with Fusion MPT base driver
[   22.325881] mptctl: /dev/mptctl @ (major,minor=10,220)
[   22.328762] Fusion MPT LAN driver 3.04.15
[   22.331605] mptlan: ioc0: PortNum=0, ProtocolFlags=09h (ItlB)
[   22.334467] mptlan: ioc0: Hmmm... LAN protocol seems to be disabled on this adapter port!
[   22.337401] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   22.340329]   alloc irq_desc for 18 on node -1
[   22.343209]   alloc kstat_irqs on node -1
[   22.346091] alloc irq_2_iommu on node -1
[   22.348968] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   22.351878] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[   22.354769] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[   22.357728] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[   22.360695] ehci_hcd 0000:00:1a.7: debug port 1
[   22.367507] ehci_hcd 0000:00:1a.7: cache line size of 256 is not supported
[   22.370470] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfb8f6000
[   22.385042] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   22.388118] hub 1-0:1.0: USB hub found
[   22.391030] hub 1-0:1.0: 6 ports detected
[   22.394097]   alloc irq_desc for 23 on node -1
[   22.397007]   alloc kstat_irqs on node -1
[   22.399933] alloc irq_2_iommu on node -1
[   22.402847] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   22.405807] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   22.408741] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   22.411715] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[   22.414687] ehci_hcd 0000:00:1d.7: debug port 1
[   22.421496] ehci_hcd 0000:00:1d.7: cache line size of 256 is not supported
[   22.424424] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfb8f8000
[   22.438284] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   22.441325] hub 2-0:1.0: USB hub found
[   22.444235] hub 2-0:1.0: 6 ports detected
[   22.447251] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   22.450162] uhci_hcd: USB Universal Host Controller Interface driver
[   22.453077] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   22.455953] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[   22.458808] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   22.461705] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[   22.464604] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00007400
[   22.467628] hub 3-0:1.0: USB hub found
[   22.470494] hub 3-0:1.0: 2 ports detected
[   22.473452]   alloc irq_desc for 21 on node -1
[   22.476261]   alloc kstat_irqs on node -1
[   22.479071] alloc irq_2_iommu on node -1
[   22.481864] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[   22.484677] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[   22.487478] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   22.490337] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[   22.493256] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00007480
[   22.496228] hub 4-0:1.0: USB hub found
[   22.499024] hub 4-0:1.0: 2 ports detected
[   22.501902] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[   22.504697] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[   22.507516] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   22.510344] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[   22.513171] uhci_hcd 0000:00:1a.2: irq 19, io base 0x00007800
[   22.516126] hub 5-0:1.0: USB hub found
[   22.518912] hub 5-0:1.0: 2 ports detected
[   22.521718] sd 4:0:0:0: [sdc] Write Protect is off
[   22.521888] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   22.521902] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   22.521911] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   22.521996] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[   22.522039] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00007880
[   22.522299] hub 6-0:1.0: USB hub found
[   22.522306] hub 6-0:1.0: 2 ports detected
[   22.522463] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   22.522484] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   22.522492] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   22.522564] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[   22.522608] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00007c00
[   22.522868] hub 7-0:1.0: USB hub found
[   22.522876] hub 7-0:1.0: 2 ports detected
[   22.523045] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   22.523061] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   22.523069] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   22.523139] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[   22.523184] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00008000
[   22.523451] hub 8-0:1.0: USB hub found
[   22.523458] hub 8-0:1.0: 2 ports detected
[   22.523628] Initializing USB Mass Storage driver...
[   22.523702] usbcore: registered new interface driver usb-storage
[   22.523707] USB Mass Storage support registered.
[   22.523783] usbcore: registered new interface driver libusual
[   22.523885] PNP: No PS/2 controller found. Probing ports directly.
[   22.526611] serio: i8042 KBD port at 0x60,0x64 irq 1
[   22.526626] serio: i8042 AUX port at 0x60,0x64 irq 12
[   22.526808] mice: PS/2 mouse device common for all mice
[   22.527051] rtc_cmos 00:03: RTC can wake from S4
[   22.527123] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[   22.527171] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[   22.527501] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   22.531467] sd 4:0:1:0: [sdd] Write Protect is off
[   22.531470] sd 4:0:1:0: [sdd] Mode Sense: 73 00 00 08
[   22.534225] sd 4:0:1:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   22.553972] sd 4:0:2:0: [sde] Write Protect is off
[   22.553976] sd 4:0:2:0: [sde] Mode Sense: 73 00 00 08
[   22.556714] sd 4:0:2:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   22.564375] sd 4:0:3:0: [sdf] Write Protect is off
[   22.564380] sd 4:0:3:0: [sdf] Mode Sense: 73 00 00 08
[   22.567122] sd 4:0:3:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   22.586982] sd 4:0:4:0: [sdg] Write Protect is off
[   22.586986] sd 4:0:4:0: [sdg] Mode Sense: 73 00 00 08
[   22.589736] sd 4:0:4:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   22.603749] sd 4:0:5:0: [sdh] Write Protect is off
[   22.603753] sd 4:0:5:0: [sdh] Mode Sense: 73 00 00 08
[   22.606500] sd 4:0:5:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   22.652501] sd 4:0:0:0: [sdc] Mode Sense: 73 00 00 08
[   22.657723] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   22.808745]  sdd: unknown partition table
[   22.831224]  sde:
[   22.841695]  sdf: unknown partition table
[   22.863015]  unknown partition table
[   22.865523]  sdg:
[   22.867627] w83793 3-002f: Registered watchdog chardev major 10, minor: 130
[   22.877246]  unknown partition table
[   22.882736]  sdh: unknown partition table
[   22.910835] usb 2-5: new high speed USB device using ehci_hcd and address 4
[   22.930867]  sdc: unknown partition table
[   23.038885] hub 2-5:1.0: USB hub found
[   23.041610] hub 2-5:1.0: 3 ports detected
[   23.108214] sd 4:0:1:0: [sdd] Attached SCSI disk
[   23.130747] sd 4:0:2:0: [sde] Attached SCSI disk
[   23.149452] sd 4:0:3:0: [sdf] Attached SCSI disk
[   23.163750] sd 4:0:4:0: [sdg] Attached SCSI disk
[   23.180499] sd 4:0:5:0: [sdh] Attached SCSI disk
[   23.230370] sd 4:0:0:0: [sdc] Attached SCSI disk
[   23.270232] usb 3-2: new low speed USB device using uhci_hcd and address 2
[   23.423318] i2c i2c-3: detect fail: unknown manuf, 0x38
[   23.436633] i2c i2c-3: detect fail: address match, 0x2e
[   23.636357] coretemp coretemp.0: TjMax is 97 C.
[   23.638835] coretemp coretemp.1: TjMax is 97 C.
[   23.641279] coretemp coretemp.2: TjMax is 97 C.
[   23.643704] coretemp coretemp.3: TjMax is 97 C.
[   23.646119] coretemp coretemp.4: TjMax is 97 C.
[   23.648525] coretemp coretemp.5: TjMax is 97 C.
[   23.650934] coretemp coretemp.6: TjMax is 97 C.
[   23.653349] coretemp coretemp.7: TjMax is 97 C.
[   23.679541] usb 6-1: new low speed USB device using uhci_hcd and address 2
[   23.879372] lis3lv02d driver loaded.
[   24.082211] usb 7-1: new full speed USB device using uhci_hcd and address 2
[   24.302032] usb 2-5.1: new high speed USB device using ehci_hcd and address 5
[   25.047296] pc87360: PC8736x not detected, module not inserted.
[   25.246944] via_cputemp: Not a VIA CPU
[   25.249384] w83627ehf: Forcibly enabling Super-I/O. Sensor is probably unusable.
[   25.251765] w83627ehf: Found W83627DHG-P chip at 0xa10
[   25.254506] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[   25.256952] iTCO_wdt: unable to reset NO_REBOOT flag, platform may have disabled it
[   25.259341] iTCO_vendor_support: vendor-support=0
[   25.261721] SoftDog: cannot register miscdev on minor=130 (err=-16)
[   25.264079] md: linear personality registered for level -1
[   25.266425] md: raid0 personality registered for level 0
[   25.268792] md: raid1 personality registered for level 1
[   25.271140] md: raid10 personality registered for level 10
[   25.273468] md: raid6 personality registered for level 6
[   25.275804] md: raid5 personality registered for level 5
[   25.278128] md: raid4 personality registered for level 4
[   25.280434] md: multipath personality registered for level -4
[   25.282736] md: faulty personality registered for level -5
[   25.285169] device-mapper: uevent: version 1.0.3
[   25.287621] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
[   25.290654] device-mapper: multipath: version 1.1.1 loaded
[   25.292965] device-mapper: multipath round-robin: version 1.0.0 loaded
[   25.295310] device-mapper: multipath queue-length: version 0.1.0 loaded
[   25.297624] device-mapper: multipath service-time: version 0.2.0 loaded
[   25.300073] device-mapper: dm-log-userspace: version 1.0.0 loaded
[   25.302387] EDAC MC: Ver: 2.1.0 Jul  5 2010
[   25.305133] PCI: Discovered peer bus fe
[   25.309614] EDAC MC0: Giving out device to 'i7core_edac.c' 'i7 core #0': DEV 0000:fe:03.0
[   25.311999] EDAC PCI0: Giving out device to module 'i7core_edac' controller 'EDAC PCI controller': DEV '0000:fe:03.0' (POLLED)
[   25.314401] EDAC i7core: Driver loaded.
[   25.317653] cpuidle: using governor ladder
[   25.320598] cpuidle: using governor menu
[   25.322962] ioatdma: Intel(R) QuickData Technology Driver 4.00
[   25.325398]   alloc irq_desc for 43 on node -1
[   25.327789]   alloc kstat_irqs on node -1
[   25.330195] alloc irq_2_iommu on node -1
[   25.332585] ioatdma 0000:00:16.0: PCI INT A -> GSI 43 (level, low) -> IRQ 43
[   25.335044] ioatdma 0000:00:16.0: setting latency timer to 64
[   25.337505]   alloc irq_desc for 81 on node -1
[   25.339899]   alloc kstat_irqs on node -1
[   25.342321] alloc irq_2_iommu on node -1
[   25.344729] ioatdma 0000:00:16.0: irq 81 for MSI/MSI-X
[   25.347716]   alloc irq_desc for 44 on node -1
[   25.350121]   alloc kstat_irqs on node -1
[   25.352589] alloc irq_2_iommu on node -1
[   25.355011] ioatdma 0000:00:16.1: PCI INT B -> GSI 44 (level, low) -> IRQ 44
[   25.355041] ioatdma 0000:00:16.1: setting latency timer to 64
[   25.355083]   alloc irq_desc for 82 on node -1
[   25.355085]   alloc kstat_irqs on node -1
[   25.355088] alloc irq_2_iommu on node -1
[   25.355094] ioatdma 0000:00:16.1: irq 82 for MSI/MSI-X
[   25.355550]   alloc irq_desc for 45 on node -1
[   25.355551]   alloc kstat_irqs on node -1
[   25.355555] alloc irq_2_iommu on node -1
[   25.355561] ioatdma 0000:00:16.2: PCI INT C -> GSI 45 (level, low) -> IRQ 45
[   25.355584] ioatdma 0000:00:16.2: setting latency timer to 64
[   25.355622]   alloc irq_desc for 83 on node -1
[   25.355623]   alloc kstat_irqs on node -1
[   25.355626] alloc irq_2_iommu on node -1
[   25.355631] ioatdma 0000:00:16.2: irq 83 for MSI/MSI-X
[   25.356075]   alloc irq_desc for 46 on node -1
[   25.356076]   alloc kstat_irqs on node -1
[   25.356079] alloc irq_2_iommu on node -1
[   25.356086] ioatdma 0000:00:16.3: PCI INT D -> GSI 46 (level, low) -> IRQ 46
[   25.356109] ioatdma 0000:00:16.3: setting latency timer to 64
[   25.356146]   alloc irq_desc for 84 on node -1
[   25.356148]   alloc kstat_irqs on node -1
[   25.356150] alloc irq_2_iommu on node -1
[   25.356156] ioatdma 0000:00:16.3: irq 84 for MSI/MSI-X
[   25.356599] ioatdma 0000:00:16.4: PCI INT A -> GSI 43 (level, low) -> IRQ 43
[   25.356625] ioatdma 0000:00:16.4: setting latency timer to 64
[   25.356662]   alloc irq_desc for 85 on node -1
[   25.356663]   alloc kstat_irqs on node -1
[   25.356666] alloc irq_2_iommu on node -1
[   25.356672] ioatdma 0000:00:16.4: irq 85 for MSI/MSI-X
[   25.357158] ioatdma 0000:00:16.5: PCI INT B -> GSI 44 (level, low) -> IRQ 44
[   25.357182] ioatdma 0000:00:16.5: setting latency timer to 64
[   25.357219]   alloc irq_desc for 86 on node -1
[   25.357221]   alloc kstat_irqs on node -1
[   25.357223] alloc irq_2_iommu on node -1
[   25.357229] ioatdma 0000:00:16.5: irq 86 for MSI/MSI-X
[   25.357685] ioatdma 0000:00:16.6: PCI INT C -> GSI 45 (level, low) -> IRQ 45
[   25.357709] ioatdma 0000:00:16.6: setting latency timer to 64
[   25.357746]   alloc irq_desc for 87 on node -1
[   25.357747]   alloc kstat_irqs on node -1
[   25.357750] alloc irq_2_iommu on node -1
[   25.357756] ioatdma 0000:00:16.6: irq 87 for MSI/MSI-X
[   25.358202] ioatdma 0000:00:16.7: PCI INT D -> GSI 46 (level, low) -> IRQ 46
[   25.358226] ioatdma 0000:00:16.7: setting latency timer to 64
[   25.358266]   alloc irq_desc for 88 on node -1
[   25.358267]   alloc kstat_irqs on node -1
[   25.358270] alloc irq_2_iommu on node -1
[   25.358276] ioatdma 0000:00:16.7: irq 88 for MSI/MSI-X
[   25.359073] usbcore: registered new interface driver hiddev
[   25.373969] input: Lite-On Technology Corp. ThinkPad USB Keyboard with TrackPoint as /devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2:1.0/input/input2
[   25.374040] generic-usb 0003:17EF:6009.0001: input,hidraw0: USB HID v1.10 Keyboard [Lite-On Technology Corp. ThinkPad USB Keyboard with TrackPoint] on usb-0000:00:1a.0-2/input0
[   25.421765] input: Lite-On Technology Corp. ThinkPad USB Keyboard with TrackPoint as /devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2:1.1/input/input3
[   25.421939] generic-usb 0003:17EF:6009.0002: input,hiddev96,hidraw1: USB HID v1.10 Mouse [Lite-On Technology Corp. ThinkPad USB Keyboard with TrackPoint] on usb-0000:00:1a.0-2/input1
[   25.436475] input: Microsoft Microsoft 3-Button Mouse with IntelliEye(TM) as /devices/pci0000:00/0000:00:1d.0/usb6/6-1/6-1:1.0/input/input4
[   25.436564] generic-usb 0003:045E:0040.0003: input,hidraw2: USB HID v1.10 Mouse [Microsoft Microsoft 3-Button Mouse with IntelliEye(TM)] on usb-0000:00:1d.0-1/input0
[   25.441929] input: HID 041e:30d3 as /devices/pci0000:00/0000:00:1d.1/usb7/7-1/7-1:1.3/input/input5
[   25.442009] generic-usb 0003:041E:30D3.0004: input,hidraw3: USB HID v1.00 Device [HID 041e:30d3] on usb-0000:00:1d.1-1/input3
[   25.442676] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1:1.0/input/input6
[   25.442765] generic-usb 0003:046B:FF10.0005: input,hidraw4: USB HID v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1d.7-5.1/input0
[   25.443444] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1:1.1/input/input7
[   25.443564] generic-usb 0003:046B:FF10.0006: input,hidraw5: USB HID v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1d.7-5.1/input1
[   25.443582] usbcore: registered new interface driver usbhid
[   25.443584] usbhid: USB HID core driver
[   25.519210] usbcore: registered new interface driver snd-usb-audio
[   25.522125] ALSA device list:
[   25.525037]   #0: USB Device 0x41e:0x30d3 at usb-0000:00:1d.1-1, full speed
[   25.527987] oprofile: using NMI interrupt.
[   25.531549] TCP cubic registered
[   25.534469] Initializing XFRM netlink socket
[   25.537567] NET: Registered protocol family 10
[   25.541294] lo: Disabled Privacy Extensions
[   25.546248] NET: Registered protocol family 17
[   25.549165] NET: Registered protocol family 15
[   25.552228] Bridge firewalling registered
[   26.176872] PM: Resume from disk failed.
[   26.179940] registered taskstats version 1
[   26.182888] ------------[ cut here ]------------
[   26.182956] ------------[ cut here ]------------
[   26.182964] WARNING: at /home/andres/src/kernel/arch/x86/include/asm/processor.h:1005 read_measured_perf_ctrs+0x5f/0x70()
[   26.182966] Hardware name: empty
[   26.182967] Modules linked in:
[   26.182970] Pid: 77, comm: kondemand/5 Not tainted 2.6.35-rc4-andres #9
[   26.182972] Call Trace:
[   26.182977]  [<ffffffff8108049f>] warn_slowpath_common+0x7f/0xc0
[   26.182980]  [<ffffffff8104f8b0>] ? read_measured_perf_ctrs+0x0/0x70
[   26.182983]  [<ffffffff810804fa>] warn_slowpath_null+0x1a/0x20
[   26.182986]  [<ffffffff8104f90f>] read_measured_perf_ctrs+0x5f/0x70
[   26.182990]  [<ffffffff810bfa59>] smp_call_function_single+0x89/0x170
[   26.182994]  [<ffffffff81a65870>] ? _raw_spin_unlock_irqrestore+0x40/0x60
[   26.182997]  [<ffffffff8104f83c>] cpufreq_get_measured_perf+0x2c/0xa0
[   26.183002]  [<ffffffff8188d6d8>] __cpufreq_driver_getavg+0x78/0x80
[   26.183004]  [<ffffffff818904c7>] do_dbs_timer+0xf7/0x390
[   26.183007]  [<ffffffff818903d0>] ? do_dbs_timer+0x0/0x390
[   26.183011]  [<ffffffff8109b46a>] worker_thread+0x21a/0x400
[   26.183014]  [<ffffffff8109b419>] ? worker_thread+0x1c9/0x400
[   26.183017]  [<ffffffff810a0630>] ? autoremove_wake_function+0x0/0x40
[   26.183020]  [<ffffffff8109b250>] ? worker_thread+0x0/0x400
[   26.183022]  [<ffffffff810a00c6>] kthread+0xb6/0xc0
[   26.183025]  [<ffffffff810b4859>] ? trace_hardirqs_on_caller+0x29/0x1a0
[   26.183030]  [<ffffffff81036ed4>] kernel_thread_helper+0x4/0x10
[   26.183031] ------------[ cut here ]------------
[   26.183036] WARNING: at /home/andres/src/kernel/arch/x86/include/asm/processor.h:1005 read_measured_perf_ctrs+0x5f/0x70()
[   26.183039]  [<ffffffff81a65820>] ? _raw_spin_unlock_irq+0x30/0x40
[   26.183041] Hardware name: empty
[   26.183042] Modules linked in: [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[   26.183045] 
[   26.183047] Pid: 72, comm: kondemand/0 Not tainted 2.6.35-rc4-andres #9
[   26.183049]  [<ffffffff81a65bfc>] ? restore_args+0x0/0x30
[   26.183051] Call Trace:
[   26.183053]  [<ffffffff810a0010>] ? kthread+0x0/0xc0
[   26.183056]  [<ffffffff81036ed0>] ? kernel_thread_helper+0x0/0x10
[   26.183059]  [<ffffffff8108049f>] warn_slowpath_common+0x7f/0xc0
[   26.183061] ---[ end trace beb90ede697983a9 ]---
[   26.183063]  [<ffffffff8104f8b0>] ? read_measured_perf_ctrs+0x0/0x70
[   26.183066]  [<ffffffff810804fa>] warn_slowpath_null+0x1a/0x20
[   26.183069]  [<ffffffff8104f90f>] read_measured_perf_ctrs+0x5f/0x70
[   26.183072]  [<ffffffff810bfa59>] smp_call_function_single+0x89/0x170
[   26.183075]  [<ffffffff81a65870>] ? _raw_spin_unlock_irqrestore+0x40/0x60
[   26.183078]  [<ffffffff8104f83c>] cpufreq_get_measured_perf+0x2c/0xa0
[   26.183081]  [<ffffffff8188d6d8>] __cpufreq_driver_getavg+0x78/0x80
[   26.183084]  [<ffffffff818904c7>] do_dbs_timer+0xf7/0x390
[   26.183086]  [<ffffffff818903d0>] ? do_dbs_timer+0x0/0x390
[   26.183089]  [<ffffffff8109b46a>] worker_thread+0x21a/0x400
[   26.183092]  [<ffffffff8109b419>] ? worker_thread+0x1c9/0x400
[   26.183095]  [<ffffffff810a0630>] ? autoremove_wake_function+0x0/0x40
[   26.183098]  [<ffffffff8109b250>] ? worker_thread+0x0/0x400
[   26.183100]  [<ffffffff810a00c6>] kthread+0xb6/0xc0
[   26.183102]  [<ffffffff810b4859>] ? trace_hardirqs_on_caller+0x29/0x1a0
[   26.183106]  [<ffffffff81036ed4>] kernel_thread_helper+0x4/0x10
[   26.183108]  [<ffffffff81a65820>] ? _raw_spin_unlock_irq+0x30/0x40
[   26.183110]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[   26.183112]  [<ffffffff81a65bfc>] ? restore_args+0x0/0x30
[   26.183115]  [<ffffffff810a0010>] ? kthread+0x0/0xc0
[   26.183117]  [<ffffffff81036ed0>] ? kernel_thread_helper+0x0/0x10
[   26.183119] ---[ end trace beb90ede697983aa ]---
[   26.183917]   Magic number: 2:882:998
[   26.183987] pnp 00:00: hash matches
[   26.338245] WARNING: at /home/andres/src/kernel/arch/x86/include/asm/processor.h:1005 read_measured_perf_ctrs+0x5f/0x70()
[   26.340734] Hardware name: empty
[   26.343212] Modules linked in:
[   26.345695] Pid: 74, comm: kondemand/2 Tainted: G        W   2.6.35-rc4-andres #9
[   26.348190] Call Trace:
[   26.350692]  [<ffffffff8108049f>] warn_slowpath_common+0x7f/0xc0
[   26.353213]  [<ffffffff8104f8b0>] ? read_measured_perf_ctrs+0x0/0x70
[   26.355702]  [<ffffffff810804fa>] warn_slowpath_null+0x1a/0x20
[   26.358140]  [<ffffffff8104f90f>] read_measured_perf_ctrs+0x5f/0x70
[   26.360557]  [<ffffffff810bfa59>] smp_call_function_single+0x89/0x170
[   26.362945]  [<ffffffff81a65870>] ? _raw_spin_unlock_irqrestore+0x40/0x60
[   26.365284]  [<ffffffff8104f83c>] cpufreq_get_measured_perf+0x2c/0xa0
[   26.367608]  [<ffffffff8188d6d8>] __cpufreq_driver_getavg+0x78/0x80
[   26.369896]  [<ffffffff818904c7>] do_dbs_timer+0xf7/0x390
[   26.372172]  [<ffffffff818903d0>] ? do_dbs_timer+0x0/0x390
[   26.372175]  [<ffffffff8109b46a>] worker_thread+0x21a/0x400
[   26.372177]  [<ffffffff8109b419>] ? worker_thread+0x1c9/0x400
[   26.372180]  [<ffffffff810a0630>] ? autoremove_wake_function+0x0/0x40
[   26.372182]  [<ffffffff8109b250>] ? worker_thread+0x0/0x400
[   26.372184]  [<ffffffff810a00c6>] kthread+0xb6/0xc0
[   26.372187]  [<ffffffff810b4859>] ? trace_hardirqs_on_caller+0x29/0x1a0
[   26.372190]  [<ffffffff81036ed4>] kernel_thread_helper+0x4/0x10
[   26.372193]  [<ffffffff81a65820>] ? _raw_spin_unlock_irq+0x30/0x40
[   26.372195]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[   26.372197]  [<ffffffff81a65bfc>] ? restore_args+0x0/0x30
[   26.372199]  [<ffffffff810a0010>] ? kthread+0x0/0xc0
[   26.372202]  [<ffffffff81036ed0>] ? kernel_thread_helper+0x0/0x10
[   26.372203] ---[ end trace beb90ede697983ab ]---
[   26.372221] rtc_cmos 00:03: setting system clock to 2010-07-07 19:00:21 UTC (1278529221)
[   26.372224] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   26.372225] EDD information not available.
[   26.420977] Freeing unused kernel memory: 2648k freed
[   26.424572] Write protecting the kernel read-only data: 18432k
[   26.429577] Freeing unused kernel memory: 1576k freed
[   26.433748] Freeing unused kernel memory: 1396k freed
[   26.467423] udev: starting version 151
[   26.562808] md: bind<sde>
[   26.625131] md: bind<sdb1>
[   26.633008] md: bind<sdb2>
[   26.652243] md: bind<sda2>
[   26.659858] md/raid1:md1: active with 2 out of 2 mirrors
[   26.665549] md: bind<sda1>
[   26.672361] md1: bitmap initialized from disk: read 9/9 pages, set 2 bits
[   26.676366] created bitmap (140 pages) for device md1
[   26.679897] md/raid1:md0: active with 2 out of 2 mirrors
[   26.687732] md1: detected capacity change from 0 to 149999779840
[   26.694052]  md1: unknown partition table
[   26.696011] md0: bitmap initialized from disk: read 15/15 pages, set 0 bits
[   26.696014] created bitmap (239 pages) for device md0
[   26.724635] md0: detected capacity change from 0 to 1998520320
[   26.729368]  md0: unknown partition table
[   26.763412] md: bind<sdc>
[   26.768840] md: bind<sdd>
[   26.910330] EXT4-fs (md1): INFO: recovery required on readonly filesystem
[   26.913433] EXT4-fs (md1): write access will be enabled during recovery
[   26.967879] md: bind<sdf>
[   27.172467] md: bind<sdh>
[   27.372025] md: bind<sdg>
[   27.381109] md/raid10:md3: not clean -- starting background reconstruction
[   27.383263] md/raid10:md3: active with 6 out of 6 devices
[   27.386943] md3: bitmap initialized from disk: read 1/1 pages, set 8 bits
[   27.389036] created bitmap (11 pages) for device md3
[   27.402704] md3: detected capacity change from 0 to 6001196335104
[   27.405297] md: resync of RAID array md3
[   27.407033]  md3: unknown partition table
[   27.410403] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[   27.412952] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
[   27.415194] md: using 128k window, over a total of 5860543296 blocks.
[   27.692140] EXT4-fs (md1): orphan cleanup on readonly fs
[   27.694393] EXT4-fs (md1): ext4_orphan_cleanup: deleting unreferenced inode 3283450
[   27.696691] EXT4-fs (md1): ext4_orphan_cleanup: deleting unreferenced inode 3283449
[   27.698920] EXT4-fs (md1): ext4_orphan_cleanup: deleting unreferenced inode 3682507
[   27.701181] EXT4-fs (md1): ext4_orphan_cleanup: deleting unreferenced inode 3283448
[   27.703552] EXT4-fs (md1): ext4_orphan_cleanup: deleting unreferenced inode 3283447
[   27.705780] EXT4-fs (md1): ext4_orphan_cleanup: deleting unreferenced inode 3283446
[   27.708030] EXT4-fs (md1): ext4_orphan_cleanup: deleting unreferenced inode 3283445
[   27.710259] EXT4-fs (md1): ext4_orphan_cleanup: deleting unreferenced inode 3283388
[   27.712461] EXT4-fs (md1): ext4_orphan_cleanup: deleting unreferenced inode 3283444
[   27.714660] EXT4-fs (md1): ext4_orphan_cleanup: deleting unreferenced inode 3283443
[   27.716884] EXT4-fs (md1): ext4_orphan_cleanup: deleting unreferenced inode 3283442
[   27.719049] EXT4-fs (md1): ext4_orphan_cleanup: deleting unreferenced inode 3283441
[   27.721196] EXT4-fs (md1): ext4_orphan_cleanup: deleting unreferenced inode 3283440
[   27.723282] EXT4-fs (md1): ext4_orphan_cleanup: deleting unreferenced inode 3283439
[   27.725357] EXT4-fs (md1): ext4_orphan_cleanup: deleting unreferenced inode 3283432
[   27.727476] EXT4-fs (md1): ext4_orphan_cleanup: deleting unreferenced inode 3283431
[   27.729576] EXT4-fs (md1): ext4_orphan_cleanup: deleting unreferenced inode 3283427
[   27.731678] EXT4-fs (md1): ext4_orphan_cleanup: deleting unreferenced inode 3283426
[   27.733751] EXT4-fs (md1): ext4_orphan_cleanup: deleting unreferenced inode 3283425
[   27.735771] EXT4-fs (md1): ext4_orphan_cleanup: deleting unreferenced inode 3283424
[   27.737812] EXT4-fs (md1): ext4_orphan_cleanup: deleting unreferenced inode 3283423
[   27.739838] EXT4-fs (md1): ext4_orphan_cleanup: deleting unreferenced inode 3283422
[   27.741810] EXT4-fs (md1): ext4_orphan_cleanup: deleting unreferenced inode 3283421
[   27.743791] EXT4-fs (md1): ext4_orphan_cleanup: deleting unreferenced inode 3283414
[   27.745739] EXT4-fs (md1): ext4_orphan_cleanup: deleting unreferenced inode 3283371
[   27.747719] EXT4-fs (md1): ext4_orphan_cleanup: deleting unreferenced inode 3283370
[   27.749638] EXT4-fs (md1): ext4_orphan_cleanup: deleting unreferenced inode 3283363
[   27.751532] EXT4-fs (md1): 27 orphan inodes deleted
[   27.753412] EXT4-fs (md1): recovery complete
[   27.921409] EXT4-fs (md1): mounted filesystem with ordered data mode. Opts: (null)
[   30.196178] EXT4-fs (md1): re-mounted. Opts: errors=remount-ro
[   30.239429] udev: starting version 151
[   32.327612] device fsid 734d2229ef3a6499-bf78c322745d7aa4 devid 1 transid 2789 /dev/mapper/data-backup
[   32.759413] EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts: (null)
[   33.600153] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
[   34.367045] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
[   45.417279] EXT4-fs (dm-4): mounted filesystem with ordered data mode. Opts: (null)
[   47.293726] vgaarb: device changed decodes: PCI:0000:08:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
[   47.293731] vgaarb: transferring owner from PCI:0000:08:00.0 to PCI:0000:01:00.0
[   48.483434] netconsole: network logging stopped, interface virbr0 unregistered
[   49.249555] lo: Disabled Privacy Extensions
[   49.336979] netconsole: network logging stopped, interface lo unregistered
[   77.225596] md: md3: resync done.
[   77.279503] RAID10 conf printout:
[   77.279507]  --- wd:6 rd:6
[   77.279510]  disk 0, wo:0, o:1, dev:sdc
[   77.279513]  disk 1, wo:0, o:1, dev:sdd
[   77.279516]  disk 2, wo:0, o:1, dev:sde
[   77.279519]  disk 3, wo:0, o:1, dev:sdf
[   77.279522]  disk 4, wo:0, o:1, dev:sdg
[   77.279524]  disk 5, wo:0, o:1, dev:sdh
[  288.281073] INFO: rcu_sched_state detected stall on CPU 1 (t=5890 jiffies)
[  288.281086] INFO: rcu_sched_state detected stall on CPU 5 (t=5890 jiffies)
[  288.281087] sending NMI to all CPUs:
[  288.281096] sending NMI to all CPUs:
[  288.281098] NMI backtrace for cpu 0
[  288.281101] CPU 0 
[  288.281104] Modules linked in:
[  288.281107] 
[  288.281111] Pid: 0, comm: swapper Tainted: G        W   2.6.35-rc4-andres #9 S7002/empty
[  288.281114] RIP: 0010:[<ffffffff8150a517>]  [<ffffffff8150a517>] intel_idle+0xc7/0x180
[  288.281124] RSP: 0018:ffffffff82201e78  EFLAGS: 00000046
[  288.281127] RAX: 0000000000000010 RBX: 0000000000000004 RCX: 0000000000000001
[  288.281130] RDX: 0000000000000000 RSI: ffffffff82201fd8 RDI: ffffffff8221b480
[  288.281134] RBP: ffffffff82201ed8 R08: 0000000000000002 R09: 0000000000000000
[  288.281137] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000010
[  288.281141] R13: 11be3fcab2af9ed9 R14: 0000000000000002 R15: 0000000000000000
[  288.281145] FS:  0000000000000000(0000) GS:ffff880003200000(0000) knlGS:0000000000000000
[  288.281149] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  288.281154] CR2: 00007f2c79dc1000 CR3: 0000000425039000 CR4: 00000000000006f0
[  288.281160] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  288.281164] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  288.281166] Process swapper (pid: 0, threadinfo ffffffff82200000, task ffffffff82211020)
[  288.281169] Stack:
[  288.281175]  0000000000000000 0000000000000001 ffffffff82201ed8 ffffffff81a695f6
[  288.281181] <0> ffffffff81a69570 0000000082211020 ffffffff82201ed8 ffff8800033dbf98
[  288.281190] <0> ffff8800033dc068 0000000000000000 ffffffffffffffff 0000000000000000
[  288.281196] Call Trace:
[  288.281204]  [<ffffffff81a695f6>] ? __atomic_notifier_call_chain+0x86/0xa0
[  288.281208]  [<ffffffff81a69570>] ? __atomic_notifier_call_chain+0x0/0xa0
[  288.281214]  [<ffffffff81892927>] cpuidle_idle_call+0xa7/0x140
[  288.281225]  [<ffffffff81035037>] cpu_idle+0xb7/0x110
[  288.281231]  [<ffffffff81a30d0f>] rest_init+0xcf/0xe0
[  288.281238]  [<ffffffff81a30c40>] ? rest_init+0x0/0xe0
[  288.281247]  [<ffffffff8253ae05>] start_kernel+0x417/0x424
[  288.281251]  [<ffffffff8253a31c>] x86_64_start_reservations+0x12c/0x130
[  288.281254]  [<ffffffff8253a404>] x86_64_start_kernel+0xe4/0xeb
[  288.281256] Code: ff ff a8 08 75 25 31 d2 48 8d 86 38 e0 ff ff 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e0 0f 01 c9 <e8> f4 b9 bf ff e8 4f 0b ba ff 4c 29 e8 48 89 c7 e8 54 bd b7 ff 
[  288.281449] Call Trace:
[  288.281454]  [<ffffffff81a695f6>] ? __atomic_notifier_call_chain+0x86/0xa0
[  288.281458]  [<ffffffff81a69570>] ? __atomic_notifier_call_chain+0x0/0xa0
[  288.281464]  [<ffffffff81892927>] cpuidle_idle_call+0xa7/0x140
[  288.281468]  [<ffffffff81035037>] cpu_idle+0xb7/0x110
[  288.281473]  [<ffffffff81a30d0f>] rest_init+0xcf/0xe0
[  288.281477]  [<ffffffff81a30c40>] ? rest_init+0x0/0xe0
[  288.281481]  [<ffffffff8253ae05>] start_kernel+0x417/0x424
[  288.281486]  [<ffffffff8253a31c>] x86_64_start_reservations+0x12c/0x130
[  288.281490]  [<ffffffff8253a404>] x86_64_start_kernel+0xe4/0xeb
[  288.281494] Pid: 0, comm: swapper Tainted: G        W   2.6.35-rc4-andres #9
[  288.281497] Call Trace:
[  288.281499]  <NMI>  [<ffffffff8103ea3b>] ? show_regs+0x2b/0x40
[  288.281508]  [<ffffffff81a675a2>] nmi_watchdog_tick+0x1b2/0x1e0
[  288.281512]  [<ffffffff81a66913>] do_nmi+0x1c3/0x2f0
[  288.281516]  [<ffffffff81a660ea>] nmi+0x1a/0x2c
[  288.281521]  [<ffffffff8150a517>] ? intel_idle+0xc7/0x180
[  288.281524]  <<EOE>>  [<ffffffff81a695f6>] ? __atomic_notifier_call_chain+0x86/0xa0
[  288.281532]  [<ffffffff81a69570>] ? __atomic_notifier_call_chain+0x0/0xa0
[  288.281537]  [<ffffffff81892927>] cpuidle_idle_call+0xa7/0x140
[  288.281541]  [<ffffffff81035037>] cpu_idle+0xb7/0x110
[  288.281545]  [<ffffffff81a30d0f>] rest_init+0xcf/0xe0
[  288.281550]  [<ffffffff81a30c40>] ? rest_init+0x0/0xe0
[  288.281554]  [<ffffffff8253ae05>] start_kernel+0x417/0x424
[  288.281558]  [<ffffffff8253a31c>] x86_64_start_reservations+0x12c/0x130
[  288.281563]  [<ffffffff8253a404>] x86_64_start_kernel+0xe4/0xeb
[  288.281566] NMI backtrace for cpu 3
[  288.281569] CPU 3 
[  288.281570] Modules linked in:
[  288.281572] Uhhuh. NMI received for unknown reason 2d on CPU 0.
[  288.281575] Do you have a strange power saving mode enabled?
[  288.281576] Dazed and confused, but trying to continue
[  288.281584] 
[  288.281586] Pid: 2636, comm: gnome-terminal Tainted: G        W   2.6.35-rc4-andres #9 S7002/empty
[  288.281589] RIP: 0010:[<ffffffff814a40fb>]  [<ffffffff814a40fb>] ioread8+0x1b/0x40
[  288.281594] RSP: 0000:ffff880003803ce8  EFLAGS: 00000006
[  288.281596] RAX: 0000000000000000 RBX: ffff88042a968248 RCX: 0000000000000000
[  288.281598] RDX: 0000000000009c03 RSI: ffff88042a968248 RDI: 0000000000019c03
[  288.281600] RBP: ffff880003803ce8 R08: 0000000000000000 R09: 0000000000000001
[  288.281603] R10: 0000000000000000 R11: 0000000000000046 R12: ffff88042a968000
[  288.281608] R13: ffff88042a969f18 R14: ffff88042a969da8 R15: ffff88042a969dd0
[  288.281614] FS:  00007fead078f920(0000) GS:ffff880003800000(0000) knlGS:0000000000000000
[  288.281618] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  288.281621] CR2: 00007fe294830000 CR3: 0000000425e66000 CR4: 00000000000006e0
[  288.281624] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  288.281629] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  288.281635] Process gnome-terminal (pid: 2636, threadinfo ffff880429ade000, task ffff8804290f0000)
[  288.281638] Stack:
[  288.281642]  ffff880003803d08 ffffffff81723552 ffff88042a968198 ffff88042a968000
[  288.281646] <0> ffff880003803d18 ffffffff81722c90 ffff880003803d48 ffffffff81713bae
[  288.281651] <0> ffff88042a968198 ffff88042a968000 0000000000000000 0000000000000001
[  288.281656] Call Trace:
[  288.281659]  <IRQ> 
[  288.281667]  [<ffffffff81723552>] ata_sff_tf_read+0x42/0x120
[  288.281671]  [<ffffffff81722c90>] ata_sff_qc_fill_rtf+0x20/0x30
[  288.281677]  [<ffffffff81713bae>] ata_qc_complete+0x1ce/0x230
[  288.281684]  [<ffffffff81724c7b>] ata_hsm_qc_complete+0x4b/0x120
[  288.281689]  [<ffffffff81724ed1>] ata_sff_hsm_move+0x181/0x730
[  288.281694]  [<ffffffff810b58b2>] ? print_lock_contention_bug+0x22/0xf0
[  288.281702]  [<ffffffff8172568c>] __ata_sff_port_intr+0xac/0x110
[  288.281705]  [<ffffffff8172572f>] ata_bmdma_port_intr+0x3f/0x130
[  288.281708]  [<ffffffff81725a00>] ata_bmdma_interrupt+0x1e0/0x240
[  288.281713]  [<ffffffff810e7ed1>] handle_IRQ_event+0x51/0x170
[  288.281716]  [<ffffffff810ea681>] handle_fasteoi_irq+0x81/0x100
[  288.281720]  [<ffffffff810388e2>] handle_irq+0x22/0x30
[  288.281724]  [<ffffffff81a6ccac>] do_IRQ+0x6c/0xf0
[  288.281727]  [<ffffffff81a65b53>] ret_from_intr+0x0/0xf
[  288.281729]  <EOI> 
[  288.281733] Code: 66 8b 07 0f b7 c0 c9 c3 0f 1f 84 00 00 00 00 00 55 48 81 ff ff ff 03 00 48 89 e5 77 2b 48 81 ff 00 00 01 00 76 0a 48 0f b7 d7 ec <0f> b6 c0 c9 c3 48 c7 c6 57 d0 fa 81 e8 e4 fa ff ff b8 ff 00 00 
[  288.281884] Call Trace:
[  288.281886]  <IRQ>  [<ffffffff81723552>] ata_sff_tf_read+0x42/0x120
[  288.281891]  [<ffffffff81722c90>] ata_sff_qc_fill_rtf+0x20/0x30
[  288.281894]  [<ffffffff81713bae>] ata_qc_complete+0x1ce/0x230
[  288.281897]  [<ffffffff81724c7b>] ata_hsm_qc_complete+0x4b/0x120
[  288.281900]  [<ffffffff81724ed1>] ata_sff_hsm_move+0x181/0x730
[  288.281903]  [<ffffffff810b58b2>] ? print_lock_contention_bug+0x22/0xf0
[  288.281906]  [<ffffffff8172568c>] __ata_sff_port_intr+0xac/0x110
[  288.281909]  [<ffffffff8172572f>] ata_bmdma_port_intr+0x3f/0x130
[  288.281912]  [<ffffffff81725a00>] ata_bmdma_interrupt+0x1e0/0x240
[  288.281916]  [<ffffffff810e7ed1>] handle_IRQ_event+0x51/0x170
[  288.281919]  [<ffffffff810ea681>] handle_fasteoi_irq+0x81/0x100
[  288.281922]  [<ffffffff810388e2>] handle_irq+0x22/0x30
[  288.281925]  [<ffffffff81a6ccac>] do_IRQ+0x6c/0xf0
[  288.281928]  [<ffffffff81a65b53>] ret_from_intr+0x0/0xf
[  288.281929]  <EOI> Pid: 2636, comm: gnome-terminal Tainted: G        W   2.6.35-rc4-andres #9
[  288.281933] Call Trace:
[  288.281934]  <NMI>  [<ffffffff8103ea3b>] ? show_regs+0x2b/0x40
[  288.281940]  [<ffffffff81a675a2>] nmi_watchdog_tick+0x1b2/0x1e0
[  288.281942]  [<ffffffff81a66913>] do_nmi+0x1c3/0x2f0
[  288.281945]  [<ffffffff81a660ea>] nmi+0x1a/0x2c
[  288.281948]  [<ffffffff814a40fb>] ? ioread8+0x1b/0x40
[  288.281950]  <<EOE>>  <IRQ>  [<ffffffff81723552>] ata_sff_tf_read+0x42/0x120
[  288.281956]  [<ffffffff81722c90>] ata_sff_qc_fill_rtf+0x20/0x30
[  288.281959]  [<ffffffff81713bae>] ata_qc_complete+0x1ce/0x230
[  288.281962]  [<ffffffff81724c7b>] ata_hsm_qc_complete+0x4b/0x120
[  288.281965]  [<ffffffff81724ed1>] ata_sff_hsm_move+0x181/0x730
[  288.281968]  [<ffffffff810b58b2>] ? print_lock_contention_bug+0x22/0xf0
[  288.281971]  [<ffffffff8172568c>] __ata_sff_port_intr+0xac/0x110
[  288.281974]  [<ffffffff8172572f>] ata_bmdma_port_intr+0x3f/0x130
[  288.281977]  [<ffffffff81725a00>] ata_bmdma_interrupt+0x1e0/0x240
[  288.281981]  [<ffffffff810e7ed1>] handle_IRQ_event+0x51/0x170
[  288.281983]  [<ffffffff810ea681>] handle_fasteoi_irq+0x81/0x100
[  288.281986]  [<ffffffff810388e2>] handle_irq+0x22/0x30
[  288.281989]  [<ffffffff81a6ccac>] do_IRQ+0x6c/0xf0
[  288.281992]  [<ffffffff81a65b53>] ret_from_intr+0x0/0xf
[  288.281994]  <EOI> 
[  288.281997] NMI backtrace for cpu 5
[  288.281999] CPU 5 
[  288.282001] Modules linked in:
[  288.282004] 
[  288.282007] Pid: 0, comm: swapper Tainted: G        W   2.6.35-rc4-andres #9 S7002/empty
[  288.282010] RIP: 0010:[<ffffffff8149f42a>]  [<ffffffff8149f42a>] delay_tsc+0x1a/0x60
[  288.282018] RSP: 0018:ffff880003c03d38  EFLAGS: 00000807
[  288.282021] RAX: 00000000a720be26 RBX: 0000000000000000 RCX: ffff880003c00000
[  288.282025] RDX: 00000000000000bc RSI: 0000000000000040 RDI: 0000000000037560
[  288.282028] RBP: ffff880003c03d38 R08: 0000000000000005 R09: 0000000000000000
[  288.282031] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000001000
[  288.282035] R13: ffffffff8235d648 R14: 0000000000000400 R15: 0000000000000096
[  288.282038] FS:  0000000000000000(0000) GS:ffff880003c00000(0000) knlGS:0000000000000000
[  288.282042] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  288.282045] CR2: 00007facdd681cc1 CR3: 0000000425e66000 CR4: 00000000000006e0
[  288.282048] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  288.282052] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  288.282055] Process swapper (pid: 0, threadinfo ffff88042e30c000, task ffff88042e310000)
[  288.282058] Stack:
[  288.282061] INFO: rcu_sched_state detected stalls on CPUs/tasks: { 1 2 3 4 5 6 7} (detected by 0, t=5890 jiffies)
[  288.282069] sending NMI to all CPUs:
[  288.282074]  ffff880003c03d48 ffffffff8149f500 ffff880003c03d68 ffffffff81052dda
[  288.282079] <0> 0000000000000002 000000000000d560 ffff880003c03db8 ffffffff8105356d
[  288.282086] <0> ffff880000000015 0000000000000006 ffff880003c03d98 0000000000000000
[  288.282093] Call Trace:
[  288.282098]  <IRQ> 
[  288.282107]  [<ffffffff8149f500>] __const_udelay+0x40/0x50
[  288.282113]  [<ffffffff81052dda>] native_safe_apic_wait_icr_idle+0x1a/0x50
[  288.282118]  [<ffffffff8105356d>] default_send_IPI_mask_sequence_phys+0xed/0x100
[  288.282124]  [<ffffffff810b0280>] ? tick_sched_timer+0x0/0xc0
[  288.282130]  [<ffffffff81057337>] physflat_send_IPI_all+0x17/0x20
[  288.282135]  [<ffffffff81053681>] arch_trigger_all_cpu_backtrace+0x41/0x70
[  288.282140]  [<ffffffff810ef83c>] __rcu_pending+0x1bc/0x380
[  288.282145]  [<ffffffff810e7657>] ? softlockup_tick+0x87/0x200
[  288.282150]  [<ffffffff810b0280>] ? tick_sched_timer+0x0/0xc0
[  288.282154]  [<ffffffff810efa6a>] rcu_check_callbacks+0x6a/0x120
[  288.282159]  [<ffffffff81091118>] update_process_times+0x48/0x70
[  288.282164]  [<ffffffff810b02e6>] tick_sched_timer+0x66/0xc0
[  288.282169]  [<ffffffff810a3efe>] __run_hrtimer+0x8e/0x1c0
[  288.282174]  [<ffffffff810a42c6>] hrtimer_interrupt+0xe6/0x250
[  288.282179]  [<ffffffff81a6cd9b>] smp_apic_timer_interrupt+0x6b/0x9b
[  288.282185]  [<ffffffff81036a93>] apic_timer_interrupt+0x13/0x20
[  288.282188]  <EOI> 
[  288.282198]  [<ffffffff8150a547>] ? intel_idle+0xf7/0x180
[  288.282203]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[  288.282207]  [<ffffffff8150a54e>] ? intel_idle+0xfe/0x180
[  288.282212]  [<ffffffff8150a547>] ? intel_idle+0xf7/0x180
[  288.282217]  [<ffffffff81a69570>] ? __atomic_notifier_call_chain+0x0/0xa0
[  288.282222]  [<ffffffff81892927>] cpuidle_idle_call+0xa7/0x140
[  288.282227]  [<ffffffff81035037>] cpu_idle+0xb7/0x110
[  288.282232]  [<ffffffff81a5b5ed>] start_secondary+0x207/0x20e
[  288.282235] Code: c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 1f 44 00 00 65 44 8b 04 25 58 d5 00 00 0f 1f 00 0f ae e8 0f 31 <89> c6 eb 11 66 90 f3 90 65 8b 0c 25 58 d5 00 00 44 39 c1 75 17 
[  288.282435] Call Trace:
[  288.282437]  <IRQ>  [<ffffffff8149f500>] __const_udelay+0x40/0x50
[  288.282445]  [<ffffffff81052dda>] native_safe_apic_wait_icr_idle+0x1a/0x50
[  288.282450]  [<ffffffff8105356d>] default_send_IPI_mask_sequence_phys+0xed/0x100
[  288.282455]  [<ffffffff810b0280>] ? tick_sched_timer+0x0/0xc0
[  288.282459]  [<ffffffff81057337>] physflat_send_IPI_all+0x17/0x20
[  288.282464]  [<ffffffff81053681>] arch_trigger_all_cpu_backtrace+0x41/0x70
[  288.282469]  [<ffffffff810ef83c>] __rcu_pending+0x1bc/0x380
[  288.282474]  [<ffffffff810e7657>] ? softlockup_tick+0x87/0x200
[  288.282478]  [<ffffffff810b0280>] ? tick_sched_timer+0x0/0xc0
[  288.282483]  [<ffffffff810efa6a>] rcu_check_callbacks+0x6a/0x120
[  288.282487]  [<ffffffff81091118>] update_process_times+0x48/0x70
[  288.282491]  [<ffffffff810b02e6>] tick_sched_timer+0x66/0xc0
[  288.282496]  [<ffffffff810a3efe>] __run_hrtimer+0x8e/0x1c0
[  288.282500]  [<ffffffff810a42c6>] hrtimer_interrupt+0xe6/0x250
[  288.282506]  [<ffffffff81a6cd9b>] smp_apic_timer_interrupt+0x6b/0x9b
[  288.282511]  [<ffffffff81036a93>] apic_timer_interrupt+0x13/0x20
[  288.282514]  <EOI>  [<ffffffff8150a547>] ? intel_idle+0xf7/0x180
[  288.282521]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[  288.282526]  [<ffffffff8150a54e>] ? intel_idle+0xfe/0x180
[  288.282530]  [<ffffffff8150a547>] ? intel_idle+0xf7/0x180
[  288.282535]  [<ffffffff81a69570>] ? __atomic_notifier_call_chain+0x0/0xa0
[  288.282540]  [<ffffffff81892927>] cpuidle_idle_call+0xa7/0x140
[  288.282544]  [<ffffffff81035037>] cpu_idle+0xb7/0x110
[  288.282548]  [<ffffffff81a5b5ed>] start_secondary+0x207/0x20e
[  288.282553] Pid: 0, comm: swapper Tainted: G        W   2.6.35-rc4-andres #9
[  288.282555] Call Trace:
[  288.282557]  <NMI>  [<ffffffff8103ea3b>] ? show_regs+0x2b/0x40
[  288.282564]  [<ffffffff81a675a2>] nmi_watchdog_tick+0x1b2/0x1e0
[  288.282569]  [<ffffffff81a66913>] do_nmi+0x1c3/0x2f0
[  288.282573]  [<ffffffff81a660ea>] nmi+0x1a/0x2c
[  288.282577]  [<ffffffff8149f42a>] ? delay_tsc+0x1a/0x60
[  288.282580]  <<EOE>>  <IRQ>  [<ffffffff8149f500>] __const_udelay+0x40/0x50
[  288.282589]  [<ffffffff81052dda>] native_safe_apic_wait_icr_idle+0x1a/0x50
[  288.282594]  [<ffffffff8105356d>] default_send_IPI_mask_sequence_phys+0xed/0x100
[  288.282599]  [<ffffffff810b0280>] ? tick_sched_timer+0x0/0xc0
[  288.282603]  [<ffffffff81057337>] physflat_send_IPI_all+0x17/0x20
[  288.282608]  [<ffffffff81053681>] arch_trigger_all_cpu_backtrace+0x41/0x70
[  288.282613]  [<ffffffff810ef83c>] __rcu_pending+0x1bc/0x380
[  288.282617]  [<ffffffff810e7657>] ? softlockup_tick+0x87/0x200
[  288.282622]  [<ffffffff810b0280>] ? tick_sched_timer+0x0/0xc0
[  288.282626]  [<ffffffff810efa6a>] rcu_check_callbacks+0x6a/0x120
[  288.282631]  [<ffffffff81091118>] update_process_times+0x48/0x70
[  288.282635]  [<ffffffff810b02e6>] tick_sched_timer+0x66/0xc0
[  288.282640]  [<ffffffff810a3efe>] __run_hrtimer+0x8e/0x1c0
[  288.282645]  [<ffffffff810a42c6>] hrtimer_interrupt+0xe6/0x250
[  288.282650]  [<ffffffff81a6cd9b>] smp_apic_timer_interrupt+0x6b/0x9b
[  288.282655]  [<ffffffff81036a93>] apic_timer_interrupt+0x13/0x20
[  288.282657]  <EOI>  [<ffffffff8150a547>] ? intel_idle+0xf7/0x180
[  288.282665]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[  288.282670]  [<ffffffff8150a54e>] ? intel_idle+0xfe/0x180
[  288.282674]  [<ffffffff8150a547>] ? intel_idle+0xf7/0x180
[  288.282679]  [<ffffffff81a69570>] ? __atomic_notifier_call_chain+0x0/0xa0
[  288.282684]  [<ffffffff81892927>] cpuidle_idle_call+0xa7/0x140
[  288.282688]  [<ffffffff81035037>] cpu_idle+0xb7/0x110
[  288.282692]  [<ffffffff81a5b5ed>] start_secondary+0x207/0x20e
[  288.282696] NMI backtrace for cpu 0
[  288.282698] CPU 0 
[  288.282699] Modules linked in:
[  288.282702] 
[  288.282706] Pid: 2584, comm: awesome Tainted: G        W   2.6.35-rc4-andres #9 S7002/empty
[  288.282709] RIP: 0010:[<ffffffff8149f4c1>]  [<ffffffff8149f4c1>] __const_udelay+0x1/0x50
[  288.282716] RSP: 0018:ffff880003203d48  EFLAGS: 00000006
[  288.282719] RAX: 0000000000001400 RBX: 0000000000000000 RCX: 0000000000000012
[  288.282722] RDX: 0000000000000001 RSI: 0000000000000040 RDI: 0000000000068dbc
[  288.282725] RBP: ffff880003203d68 R08: ffffffff8235d648 R09: 0000000000000000
[  288.282728] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000001000
[  288.282731] R13: ffffffff8235d648 R14: 0000000000000400 R15: 0000000000000096
[  288.282736] FS:  00007fe29498d880(0000) GS:ffff880003200000(0000) knlGS:0000000000000000
[  288.282739] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  288.282743] CR2: 00007f2c79dc1000 CR3: 0000000429a94000 CR4: 00000000000006f0
[  288.282746] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  288.282749] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  288.282752] Process awesome (pid: 2584, threadinfo ffff8804270da000, task ffff88042800c6c0)
[  288.282755] Stack:
[  288.282762]  ffff880003203d68 ffffffff81052dda 0000000000000002 000000000000d560
[  288.282767] <0> ffff880003203db8 ffffffff8105356d ffffffff00000012 0000000000000001
[  288.282774] <0> ffff880003203d98 0000000000000000 ffffffff82228b00 ffffffff82228b00
[  288.282781] Call Trace:
[  288.282785]  <IRQ> 
[  288.282795]  [<ffffffff81052dda>] ? native_safe_apic_wait_icr_idle+0x1a/0x50
[  288.282800]  [<ffffffff8105356d>] default_send_IPI_mask_sequence_phys+0xed/0x100
[  288.282805]  [<ffffffff81057337>] physflat_send_IPI_all+0x17/0x20
[  288.282810]  [<ffffffff81053681>] arch_trigger_all_cpu_backtrace+0x41/0x70
[  288.282815]  [<ffffffff810ef9d3>] __rcu_pending+0x353/0x380
[  288.282820]  [<ffffffff810b0280>] ? tick_sched_timer+0x0/0xc0
[  288.282825]  [<ffffffff810efa6a>] rcu_check_callbacks+0x6a/0x120
[  288.282829]  [<ffffffff81091118>] update_process_times+0x48/0x70
[  288.282834]  [<ffffffff810b02e6>] tick_sched_timer+0x66/0xc0
[  288.282839]  [<ffffffff810a3efe>] __run_hrtimer+0x8e/0x1c0
[  288.282843]  [<ffffffff810a42c6>] hrtimer_interrupt+0xe6/0x250
[  288.282849]  [<ffffffff81a64bb1>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  288.282854]  [<ffffffff81a6cd9b>] smp_apic_timer_interrupt+0x6b/0x9b
[  288.282859]  [<ffffffff81036a93>] apic_timer_interrupt+0x13/0x20
[  288.282862]  <EOI> 
[  288.282873]  [<ffffffff811d6258>] ? show_stat+0x1c8/0x700
[  288.282877]  [<ffffffff811d6264>] ? show_stat+0x1d4/0x700
[  288.282882]  [<ffffffff81a658bb>] ? _raw_spin_unlock+0x2b/0x40
[  288.282886]  [<ffffffff811cc8d6>] ? proc_reg_open+0x136/0x1e0
[  288.282891]  [<ffffffff811918d0>] ? single_release+0x0/0x50
[  288.282896]  [<ffffffff81192343>] seq_read+0xf3/0x450
[  288.282900]  [<ffffffff81192250>] ? seq_read+0x0/0x450
[  288.282904]  [<ffffffff811cceb4>] proc_reg_read+0x84/0xc0
[  288.282911]  [<ffffffff81173095>] vfs_read+0xb5/0x1a0
[  288.282916]  [<ffffffff81173271>] sys_read+0x51/0x80
[  288.282920]  [<ffffffff8103609b>] system_call_fastpath+0x16/0x1b
[  288.282923] Code: cd 20 cf 35 82 48 6b 94 0a 98 00 00 00 4b f7 e2 48 8d 7a 01 ff 15 90 32 db 00 c9 c3 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 <48> 89 e5 0f 1f 44 00 00 48 c7 c2 80 46 1d 00 48 8d 04 bd 00 00 
[  288.286856] Call Trace:
[  288.286858]  <IRQ>  [<ffffffff81052dda>] ? native_safe_apic_wait_icr_idle+0x1a/0x50
[  288.286866]  [<ffffffff8105356d>] default_send_IPI_mask_sequence_phys+0xed/0x100
[  288.286871]  [<ffffffff81057337>] physflat_send_IPI_all+0x17/0x20
[  288.286875]  [<ffffffff81053681>] arch_trigger_all_cpu_backtrace+0x41/0x70
[  288.286880]  [<ffffffff810ef9d3>] __rcu_pending+0x353/0x380
[  288.286884]  [<ffffffff810b0280>] ? tick_sched_timer+0x0/0xc0
[  288.286889]  [<ffffffff810efa6a>] rcu_check_callbacks+0x6a/0x120
[  288.286893]  [<ffffffff81091118>] update_process_times+0x48/0x70
[  288.286897]  [<ffffffff810b02e6>] tick_sched_timer+0x66/0xc0
[  288.286901]  [<ffffffff810a3efe>] __run_hrtimer+0x8e/0x1c0
[  288.286906]  [<ffffffff810a42c6>] hrtimer_interrupt+0xe6/0x250
[  288.286910]  [<ffffffff81a64bb1>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  288.286915]  [<ffffffff81a6cd9b>] smp_apic_timer_interrupt+0x6b/0x9b
[  288.286920]  [<ffffffff81036a93>] apic_timer_interrupt+0x13/0x20
[  288.286922]  <EOI>  [<ffffffff811d6258>] ? show_stat+0x1c8/0x700
[  288.286931]  [<ffffffff811d6264>] ? show_stat+0x1d4/0x700
[  288.286934]  [<ffffffff81a658bb>] ? _raw_spin_unlock+0x2b/0x40
[  288.286938]  [<ffffffff811cc8d6>] ? proc_reg_open+0x136/0x1e0
[  288.286942]  [<ffffffff811918d0>] ? single_release+0x0/0x50
[  288.286947]  [<ffffffff81192343>] seq_read+0xf3/0x450
[  288.286951]  [<ffffffff81192250>] ? seq_read+0x0/0x450
[  288.286955]  [<ffffffff811cceb4>] proc_reg_read+0x84/0xc0
[  288.286960]  [<ffffffff81173095>] vfs_read+0xb5/0x1a0
[  288.286964]  [<ffffffff81173271>] sys_read+0x51/0x80
[  288.286969]  [<ffffffff8103609b>] system_call_fastpath+0x16/0x1b
[  288.286973] Pid: 2584, comm: awesome Tainted: G        W   2.6.35-rc4-andres #9
[  288.286975] Call Trace:
[  288.286977]  <NMI>  [<ffffffff8103ea3b>] ? show_regs+0x2b/0x40
[  288.286984]  [<ffffffff81a675a2>] nmi_watchdog_tick+0x1b2/0x1e0
[  288.286988]  [<ffffffff81a66913>] do_nmi+0x1c3/0x2f0
[  288.286992]  [<ffffffff81a660ea>] nmi+0x1a/0x2c
[  288.286997]  [<ffffffff8149f4c1>] ? __const_udelay+0x1/0x50
[  288.286999]  <<EOE>>  <IRQ>  [<ffffffff81052dda>] ? native_safe_apic_wait_icr_idle+0x1a/0x50
[  288.287008]  [<ffffffff8105356d>] default_send_IPI_mask_sequence_phys+0xed/0x100
[  288.287012]  [<ffffffff81057337>] physflat_send_IPI_all+0x17/0x20
[  288.287017]  [<ffffffff81053681>] arch_trigger_all_cpu_backtrace+0x41/0x70
[  288.287021]  [<ffffffff810ef9d3>] __rcu_pending+0x353/0x380
[  288.287026]  [<ffffffff810b0280>] ? tick_sched_timer+0x0/0xc0
[  288.287030]  [<ffffffff810efa6a>] rcu_check_callbacks+0x6a/0x120
[  288.287034]  [<ffffffff81091118>] update_process_times+0x48/0x70
[  288.287038]  [<ffffffff810b02e6>] tick_sched_timer+0x66/0xc0
[  288.287042]  [<ffffffff810a3efe>] __run_hrtimer+0x8e/0x1c0
[  288.287047]  [<ffffffff810a42c6>] hrtimer_interrupt+0xe6/0x250
[  288.287051]  [<ffffffff81a64bb1>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  288.287056]  [<ffffffff81a6cd9b>] smp_apic_timer_interrupt+0x6b/0x9b
[  288.287061]  [<ffffffff81036a93>] apic_timer_interrupt+0x13/0x20
[  288.287063]  <EOI>  [<ffffffff811d6258>] ? show_stat+0x1c8/0x700
[  288.287071]  [<ffffffff811d6264>] ? show_stat+0x1d4/0x700
[  288.287075]  [<ffffffff81a658bb>] ? _raw_spin_unlock+0x2b/0x40
[  288.287079]  [<ffffffff811cc8d6>] ? proc_reg_open+0x136/0x1e0
[  288.287083]  [<ffffffff811918d0>] ? single_release+0x0/0x50
[  288.287088]  [<ffffffff81192343>] seq_read+0xf3/0x450
[  288.287092]  [<ffffffff81192250>] ? seq_read+0x0/0x450
[  288.287096]  [<ffffffff811cceb4>] proc_reg_read+0x84/0xc0
[  288.287100]  [<ffffffff81173095>] vfs_read+0xb5/0x1a0
[  288.287104]  [<ffffffff81173271>] sys_read+0x51/0x80
[  288.287109]  [<ffffffff8103609b>] system_call_fastpath+0x16/0x1b
[  288.287113] NMI backtrace for cpu 6
[  288.287115] CPU 6 
[  288.287117] Modules linked in:
[  288.287120] 
[  288.287123] Pid: 3109, comm: htop Tainted: G        W   2.6.35-rc4-andres #9 S7002/empty
[  288.287126] RIP: 0033:[<ffffffffff60017b>]  [<ffffffffff60017b>] vread_hpet+0xb/0x10
[  288.287134] RSP: 002b:00007fff18813970  EFLAGS: 00000246
[  288.287137] RAX: 00000000f67282d5 RBX: 00007fff18813c10 RCX: 00007f2c794317a0
[  288.287140] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007fff18813c10
[  288.287143] RBP: 00007fff18813970 R08: 0000000000414ddc R09: 0000000000000000
[  288.287146] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000001abca
[  288.287149] R13: 00007fff18813d70 R14: 0000000001245560 R15: 000000000129e9e0
[  288.287153] FS:  00007f2c79d9c700(0000) GS:ffff880003e00000(0000) knlGS:0000000000000000
[  288.287156] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  288.287159] CR2: 00007f2c79dc1000 CR3: 00000004291c7000 CR4: 00000000000006e0
[  288.287162] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  288.287165] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  288.287169] Process htop (pid: 3109, threadinfo ffff88042657a000, task ffff880429318000)
[  288.287171] 
[  288.287173] Call Trace:
[  288.287176] Pid: 3109, comm: htop Tainted: G        W   2.6.35-rc4-andres #9
[  288.287179] Call Trace:
[  288.287181]  <NMI>  [<ffffffff8103ea3b>] ? show_regs+0x2b/0x40
[  288.287189]  [<ffffffff81a675a2>] nmi_watchdog_tick+0x1b2/0x1e0
[  288.287193]  [<ffffffff81a66913>] do_nmi+0x1c3/0x2f0
[  288.287197]  [<ffffffff81a660ea>] nmi+0x1a/0x2c
[  288.287200]  <<EOE>> 
[  288.287203] NMI backtrace for cpu 7
[  288.287206] CPU 7 
[  288.287208] Modules linked in:
[  288.287210] 
[  288.287214] Pid: 125, comm: kslowd001 Tainted: G        W   2.6.35-rc4-andres #9 S7002/empty
[  288.287217] RIP: 0010:[<ffffffff8149f43a>]  [<ffffffff8149f43a>] delay_tsc+0x2a/0x60
[  288.287223] RSP: 0018:ffff88042b4d3bb0  EFLAGS: 00000202
[  288.287225] RAX: 00000000a74a7fd4 RBX: ffff88042b6abd18 RCX: 0000000000000007
[  288.287228] RDX: 00000000000018b7 RSI: 00000000a74a671d RDI: 000000000000588a
[  288.287230] RBP: ffff88042b4d3bb0 R08: 0000000000000007 R09: 0000000000000000
[  288.287233] R10: 2222222222222222 R11: 2222222222222222 R12: 00000000000000a0
[  288.287236] R13: 0000000000000002 R14: 0000000000000003 R15: 00000000000000a0
[  288.287240] FS:  0000000000000000(0000) GS:ffff880004000000(0000) knlGS:0000000000000000
[  288.287243] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  288.287246] CR2: 0000000000c1e278 CR3: 0000000425171000 CR4: 00000000000006e0
[  288.287249] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  288.287252] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  288.287256] Process kslowd001 (pid: 125, threadinfo ffff88042b4d2000, task ffff88042b4d8000)
[  288.287259] Stack:
[  288.287264]  ffff88042b4d3bc0 ffffffff8149f54f ffff88042b4d3bf0 ffffffff817d5b37
[  288.287270] <0> 0000000000000000 ffff88042b6ab800 0000000000000000 ffff88042b6abd18
[  288.287277] <0> ffff88042b4d3c40 ffffffff817d600c 000000000000037a ffff88042b6ab800
[  288.287284] Call Trace:
[  288.287290]  [<ffffffff8149f54f>] __udelay+0x3f/0x50
[  288.287296]  [<ffffffff817d5b37>] i2c_outb+0x77/0x100
[  288.287300]  [<ffffffff817d600c>] try_address+0x6c/0x80
[  288.287304]  [<ffffffff817d649a>] bit_xfer+0x47a/0x5a0
[  288.287308]  [<ffffffff817d3241>] i2c_transfer+0xb1/0x100
[  288.287314]  [<ffffffff815e2e4e>] radeon_ddc_probe+0x5e/0x70
[  288.287319]  [<ffffffff815db966>] radeon_dvi_detect+0x36/0x310
[  288.287325]  [<ffffffff8157e1a2>] output_poll_execute+0xc2/0x170
[  288.287331]  [<ffffffff811154a7>] slow_work_execute+0x287/0x2f0
[  288.287336]  [<ffffffff81115667>] slow_work_thread+0x157/0x350
[  288.287341]  [<ffffffff810a0630>] ? autoremove_wake_function+0x0/0x40
[  288.287345]  [<ffffffff81115510>] ? slow_work_thread+0x0/0x350
[  288.287350]  [<ffffffff810a00c6>] kthread+0xb6/0xc0
[  288.287354]  [<ffffffff810b4859>] ? trace_hardirqs_on_caller+0x29/0x1a0
[  288.287360]  [<ffffffff81036ed4>] kernel_thread_helper+0x4/0x10
[  288.287365]  [<ffffffff81a65820>] ? _raw_spin_unlock_irq+0x30/0x40
[  288.287369]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[  288.287373]  [<ffffffff81a65bfc>] ? restore_args+0x0/0x30
[  288.287377]  [<ffffffff810a0010>] ? kthread+0x0/0xc0
[  288.287381]  [<ffffffff81036ed0>] ? kernel_thread_helper+0x0/0x10
[  288.287383] Code: 00 55 48 89 e5 0f 1f 44 00 00 65 44 8b 04 25 58 d5 00 00 0f 1f 00 0f ae e8 0f 31 89 c6 eb 11 66 90 f3 90 65 8b 0c 25 58 d5 00 00 <44> 39 c1 75 17 0f 1f 00 0f ae e8 0f 31 89 c0 48 89 c2 48 29 f2 
[  288.287511] Call Trace:
[  288.287514] Uhhuh. NMI received for unknown reason 00 on CPU 5.
[  288.287518]  [<ffffffff8149f54f>] __udelay+0x3f/0x50
[  288.287522]  [<ffffffff817d5b37>] i2c_outb+0x77/0x100
[  288.287523] Do you have a strange power saving mode enabled?
[  288.287525] Dazed and confused, but trying to continue
[  288.287531]  [<ffffffff817d600c>] try_address+0x6c/0x80
[  288.287535]  [<ffffffff817d649a>] bit_xfer+0x47a/0x5a0
[  288.287540]  [<ffffffff817d3241>] i2c_transfer+0xb1/0x100
[  288.287545]  [<ffffffff815e2e4e>] radeon_ddc_probe+0x5e/0x70
[  288.287549]  [<ffffffff815db966>] radeon_dvi_detect+0x36/0x310
[  288.287553]  [<ffffffff8157e1a2>] output_poll_execute+0xc2/0x170
[  288.287558]  [<ffffffff811154a7>] slow_work_execute+0x287/0x2f0
[  288.287563]  [<ffffffff81115667>] slow_work_thread+0x157/0x350
[  288.287568]  [<ffffffff810a0630>] ? autoremove_wake_function+0x0/0x40
[  288.287572]  [<ffffffff81115510>] ? slow_work_thread+0x0/0x350
[  288.287576]  [<ffffffff810a00c6>] kthread+0xb6/0xc0
[  288.287581]  [<ffffffff810b4859>] ? trace_hardirqs_on_caller+0x29/0x1a0
[  288.287586]  [<ffffffff81036ed4>] kernel_thread_helper+0x4/0x10
[  288.287590]  [<ffffffff81a65820>] ? _raw_spin_unlock_irq+0x30/0x40
[  288.287594]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[  288.287598]  [<ffffffff81a65bfc>] ? restore_args+0x0/0x30
[  288.287602]  [<ffffffff810a0010>] ? kthread+0x0/0xc0
[  288.287607]  [<ffffffff81036ed0>] ? kernel_thread_helper+0x0/0x10
[  288.287611] Pid: 125, comm: kslowd001 Tainted: G        W   2.6.35-rc4-andres #9
[  288.287613] Call Trace:
[  288.287615] Uhhuh. NMI received for unknown reason 00 on CPU 6.
[  288.287618] Do you have a strange power saving mode enabled?
[  288.287620] Dazed and confused, but trying to continue
[  288.287623]  <NMI>  [<ffffffff8103ea3b>] ? show_regs+0x2b/0x40
[  288.287631]  [<ffffffff81a675a2>] nmi_watchdog_tick+0x1b2/0x1e0
[  288.287635]  [<ffffffff81a66913>] do_nmi+0x1c3/0x2f0
[  288.287639]  [<ffffffff81a660ea>] nmi+0x1a/0x2c
[  288.287644]  [<ffffffff8149f43a>] ? delay_tsc+0x2a/0x60
[  288.287646]  <<EOE>>  [<ffffffff8149f54f>] __udelay+0x3f/0x50
[  288.287653]  [<ffffffff817d5b37>] i2c_outb+0x77/0x100
[  288.287657]  [<ffffffff817d600c>] try_address+0x6c/0x80
[  288.287661]  [<ffffffff817d649a>] bit_xfer+0x47a/0x5a0
[  288.287665]  [<ffffffff817d3241>] i2c_transfer+0xb1/0x100
[  288.287670]  [<ffffffff815e2e4e>] radeon_ddc_probe+0x5e/0x70
[  288.287674]  [<ffffffff815db966>] radeon_dvi_detect+0x36/0x310
[  288.287678]  [<ffffffff8157e1a2>] output_poll_execute+0xc2/0x170
[  288.287683]  [<ffffffff811154a7>] slow_work_execute+0x287/0x2f0
[  288.287688]  [<ffffffff81115667>] slow_work_thread+0x157/0x350
[  288.287693]  [<ffffffff810a0630>] ? autoremove_wake_function+0x0/0x40
[  288.287697]  [<ffffffff81115510>] ? slow_work_thread+0x0/0x350
[  288.287701]  [<ffffffff810a00c6>] kthread+0xb6/0xc0
[  288.287706]  [<ffffffff810b4859>] ? trace_hardirqs_on_caller+0x29/0x1a0
[  288.287711]  [<ffffffff81036ed4>] kernel_thread_helper+0x4/0x10
[  288.287715]  [<ffffffff81a65820>] ? _raw_spin_unlock_irq+0x30/0x40
[  288.287719]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[  288.287723]  [<ffffffff81a65bfc>] ? restore_args+0x0/0x30
[  288.287727]  [<ffffffff810a0010>] ? kthread+0x0/0xc0
[  288.287732]  [<ffffffff81036ed0>] ? kernel_thread_helper+0x0/0x10
[  288.287735] NMI backtrace for cpu 1
[  288.287737] Uhhuh. NMI received for unknown reason 00 on CPU 7.
[  288.287739] Do you have a strange power saving mode enabled?
[  288.287741] Dazed and confused, but trying to continue
[  288.287745] CPU 1 
[  288.287747] Modules linked in:
[  288.287750] 
[  288.287753] Pid: 0, comm: swapper Tainted: G        W   2.6.35-rc4-andres #9 S7002/empty
[  288.287755] RIP: 0010:[<ffffffff8149f447>]  [<ffffffff8149f447>] delay_tsc+0x37/0x60
[  288.287761] RSP: 0018:ffff880003403d38  EFLAGS: 00000046
[  288.287764] RAX: 00000000a7165930 RBX: 0000000000000000 RCX: 0000000000000001
[  288.287766] RDX: 00000000000000bc RSI: 00000000a7134c75 RDI: 0000000000037560
[  288.287769] RBP: ffff880003403d38 R08: 0000000000000001 R09: 0000000000000000
[  288.287772] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000001000
[  288.287775] R13: ffffffff8235d648 R14: 0000000000000400 R15: 0000000000000096
[  288.287778] FS:  0000000000000000(0000) GS:ffff880003400000(0000) knlGS:0000000000000000
[  288.287782] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  288.287784] CR2: 00007f31cf61a000 CR3: 0000000425e66000 CR4: 00000000000006e0
[  288.287787] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  288.287790] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  288.287793] Process swapper (pid: 0, threadinfo ffff88042e188000, task ffff88042e1846c0)
[  288.287796] Stack:
[  288.287798]  ffff880003403d48 ffffffff8149f500 ffff880003403d68 ffffffff81052dda
[  288.287803] <0> 0000000000000002 000000000000d560 ffff880003403db8 ffffffff8105356d
[  288.287808] <0> ffff880000000012 0000000000000001 ffff880003403d98 0000000000000000
[  288.287815] Call Trace:
[  288.287818]  <IRQ> 
[  288.287824]  [<ffffffff8149f500>] __const_udelay+0x40/0x50
[  288.287828]  [<ffffffff81052dda>] native_safe_apic_wait_icr_idle+0x1a/0x50
[  288.287833]  [<ffffffff8105356d>] default_send_IPI_mask_sequence_phys+0xed/0x100
[  288.287837]  [<ffffffff810b0280>] ? tick_sched_timer+0x0/0xc0
[  288.287841]  [<ffffffff81057337>] physflat_send_IPI_all+0x17/0x20
[  288.287845]  [<ffffffff81053681>] arch_trigger_all_cpu_backtrace+0x41/0x70
[  288.287850]  [<ffffffff810ef83c>] __rcu_pending+0x1bc/0x380
[  288.287854]  [<ffffffff810e7657>] ? softlockup_tick+0x87/0x200
[  288.287858]  [<ffffffff810b0280>] ? tick_sched_timer+0x0/0xc0
[  288.287862]  [<ffffffff810efa6a>] rcu_check_callbacks+0x6a/0x120
[  288.287866]  [<ffffffff81091118>] update_process_times+0x48/0x70
[  288.287870]  [<ffffffff810b02e6>] tick_sched_timer+0x66/0xc0
[  288.287874]  [<ffffffff810a3efe>] __run_hrtimer+0x8e/0x1c0
[  288.287878]  [<ffffffff810a42c6>] hrtimer_interrupt+0xe6/0x250
[  288.287882]  [<ffffffff81a6cd9b>] smp_apic_timer_interrupt+0x6b/0x9b
[  288.287887]  [<ffffffff81036a93>] apic_timer_interrupt+0x13/0x20
[  288.287889]  <EOI> 
[  288.287896]  [<ffffffff810b07f2>] ? tick_nohz_restart_sched_tick+0x52/0x190
[  288.287900]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[  288.287904]  [<ffffffff810b07f7>] ? tick_nohz_restart_sched_tick+0x57/0x190
[  288.287908]  [<ffffffff8103506f>] cpu_idle+0xef/0x110
[  288.287912]  [<ffffffff81a5b5ed>] start_secondary+0x207/0x20e
[  288.287915] Code: 04 25 58 d5 00 00 0f 1f 00 0f ae e8 0f 31 89 c6 eb 11 66 90 f3 90 65 8b 0c 25 58 d5 00 00 44 39 c1 75 17 0f 1f 00 0f ae e8 0f 31 <89> c0 48 89 c2 48 29 f2 48 39 d7 77 dc c9 c3 48 29 c6 48 01 f7 
[  288.288034] Call Trace:
[  288.288036]  <IRQ>  [<ffffffff8149f500>] __const_udelay+0x40/0x50
[  288.288043]  [<ffffffff81052dda>] native_safe_apic_wait_icr_idle+0x1a/0x50
[  288.288047]  [<ffffffff8105356d>] default_send_IPI_mask_sequence_phys+0xed/0x100
[  288.288052]  [<ffffffff810b0280>] ? tick_sched_timer+0x0/0xc0
[  288.288056]  [<ffffffff81057337>] physflat_send_IPI_all+0x17/0x20
[  288.288060]  [<ffffffff81053681>] arch_trigger_all_cpu_backtrace+0x41/0x70
[  288.288065]  [<ffffffff810ef83c>] __rcu_pending+0x1bc/0x380
[  288.288069]  [<ffffffff810e7657>] ? softlockup_tick+0x87/0x200
[  288.288073]  [<ffffffff810b0280>] ? tick_sched_timer+0x0/0xc0
[  288.288077]  [<ffffffff810efa6a>] rcu_check_callbacks+0x6a/0x120
[  288.288081]  [<ffffffff81091118>] update_process_times+0x48/0x70
[  288.288085]  [<ffffffff810b02e6>] tick_sched_timer+0x66/0xc0
[  288.288089]  [<ffffffff810a3efe>] __run_hrtimer+0x8e/0x1c0
[  288.288093]  [<ffffffff810a42c6>] hrtimer_interrupt+0xe6/0x250
[  288.288098]  [<ffffffff81a6cd9b>] smp_apic_timer_interrupt+0x6b/0x9b
[  288.288102]  [<ffffffff81036a93>] apic_timer_interrupt+0x13/0x20
[  288.288105]  <EOI>  [<ffffffff810b07f2>] ? tick_nohz_restart_sched_tick+0x52/0x190
[  288.288112]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[  288.288116]  [<ffffffff810b07f7>] ? tick_nohz_restart_sched_tick+0x57/0x190
[  288.288121]  [<ffffffff8103506f>] cpu_idle+0xef/0x110
[  288.288125]  [<ffffffff81a5b5ed>] start_secondary+0x207/0x20e
[  288.288129] Pid: 0, comm: swapper Tainted: G        W   2.6.35-rc4-andres #9
[  288.288131] Call Trace:
[  288.288133]  <NMI>  [<ffffffff8103ea3b>] ? show_regs+0x2b/0x40
[  288.288140]  [<ffffffff81a675a2>] nmi_watchdog_tick+0x1b2/0x1e0
[  288.288145]  [<ffffffff81a66913>] do_nmi+0x1c3/0x2f0
[  288.288148]  [<ffffffff81a660ea>] nmi+0x1a/0x2c
[  288.288153]  [<ffffffff8149f447>] ? delay_tsc+0x37/0x60
[  288.288155]  <<EOE>>  <IRQ>  [<ffffffff8149f500>] __const_udelay+0x40/0x50
[  288.288162]  [<ffffffff81052dda>] native_safe_apic_wait_icr_idle+0x1a/0x50
[  288.288167]  [<ffffffff8105356d>] default_send_IPI_mask_sequence_phys+0xed/0x100
[  288.288171]  [<ffffffff810b0280>] ? tick_sched_timer+0x0/0xc0
[  288.288175]  [<ffffffff81057337>] physflat_send_IPI_all+0x17/0x20
[  288.288179]  [<ffffffff81053681>] arch_trigger_all_cpu_backtrace+0x41/0x70
[  288.288184]  [<ffffffff810ef83c>] __rcu_pending+0x1bc/0x380
[  288.288188]  [<ffffffff810e7657>] ? softlockup_tick+0x87/0x200
[  288.288192]  [<ffffffff810b0280>] ? tick_sched_timer+0x0/0xc0
[  288.288196]  [<ffffffff810efa6a>] rcu_check_callbacks+0x6a/0x120
[  288.288200]  [<ffffffff81091118>] update_process_times+0x48/0x70
[  288.288204]  [<ffffffff810b02e6>] tick_sched_timer+0x66/0xc0
[  288.288208]  [<ffffffff810a3efe>] __run_hrtimer+0x8e/0x1c0
[  288.288212]  [<ffffffff810a42c6>] hrtimer_interrupt+0xe6/0x250
[  288.288217]  [<ffffffff81a6cd9b>] smp_apic_timer_interrupt+0x6b/0x9b
[  288.288221]  [<ffffffff81036a93>] apic_timer_interrupt+0x13/0x20
[  288.288223]  <EOI>  [<ffffffff810b07f2>] ? tick_nohz_restart_sched_tick+0x52/0x190
[  288.288230]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[  288.288234]  [<ffffffff810b07f7>] ? tick_nohz_restart_sched_tick+0x57/0x190
[  288.288238]  [<ffffffff8103506f>] cpu_idle+0xef/0x110
[  288.288242]  [<ffffffff81a5b5ed>] start_secondary+0x207/0x20e
[  288.288246] NMI backtrace for cpu 2
[  288.288248] Uhhuh. NMI received for unknown reason 00 on CPU 1.
[  288.288250] Do you have a strange power saving mode enabled?
[  288.288252] Dazed and confused, but trying to continue
[  288.288255] Uhhuh. NMI received for unknown reason 00 on CPU 1.
[  288.288257] Do you have a strange power saving mode enabled?
[  288.288259] Dazed and confused, but trying to continue
[  288.288262] CPU 2 
[  288.288264] Modules linked in:
[  288.288267] 
[  288.288270] Pid: 0, comm: swapper Tainted: G        W   2.6.35-rc4-andres #9 S7002/empty
[  288.288273] RIP: 0010:[<ffffffff8150a517>]  [<ffffffff8150a517>] intel_idle+0xc7/0x180
[  288.288281] RSP: 0018:ffff88042e19de68  EFLAGS: 00000046
[  288.288283] RAX: 0000000000000020 RBX: 0000000000000008 RCX: 0000000000000001
[  288.288286] RDX: 0000000000000000 RSI: ffff88042e19dfd8 RDI: ffffffff8221b480
[  288.288290] RBP: ffff88042e19dec8 R08: 0000000000000002 R09: 0000000000000000
[  288.288292] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000020
[  288.288299] R13: 11be3fcab29af90e R14: 0000000000000003 R15: 0000000000000000
[  288.288303] FS:  0000000000000000(0000) GS:ffff880003600000(0000) knlGS:0000000000000000
[  288.288306] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  288.288309] CR2: 00002b4b8546b000 CR3: 0000000425e66000 CR4: 00000000000006e0
[  288.288313] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  288.288316] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  288.288320] Process swapper (pid: 0, threadinfo ffff88042e19c000, task ffff88042e1a0000)
[  288.288322] Stack:
[  288.288326]  0000000000000000 0000000000000001 ffff88042e19dec8 ffffffff81a695f6
[  288.288332] <0> ffffffff81a69570 000000022e1a0000 ffff88042e19dec8 ffff8800037dbf98
[  288.288338] <0> ffff8800037dc0c8 0000000000000000 0000000000000000 0000000000000000
[  288.288345] Call Trace:
[  288.288352]  [<ffffffff81a695f6>] ? __atomic_notifier_call_chain+0x86/0xa0
[  288.288357]  [<ffffffff81a69570>] ? __atomic_notifier_call_chain+0x0/0xa0
[  288.288363]  [<ffffffff81892927>] cpuidle_idle_call+0xa7/0x140
[  288.288368]  [<ffffffff81035037>] cpu_idle+0xb7/0x110
[  288.288372]  [<ffffffff81a5b5ed>] start_secondary+0x207/0x20e
[  288.288378] Code: ff ff a8 08 75 25 31 d2 48 8d 86 38 e0 ff ff 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e0 0f 01 c9 <e8> f4 b9 bf ff e8 4f 0b ba ff 4c 29 e8 48 89 c7 e8 54 bd b7 ff 
[  288.288520] Call Trace:
[  288.288525]  [<ffffffff81a695f6>] ? __atomic_notifier_call_chain+0x86/0xa0
[  288.288529]  [<ffffffff81a69570>] ? __atomic_notifier_call_chain+0x0/0xa0
[  288.288535]  [<ffffffff81892927>] cpuidle_idle_call+0xa7/0x140
[  288.288539]  [<ffffffff81035037>] cpu_idle+0xb7/0x110
[  288.288544]  [<ffffffff81a5b5ed>] start_secondary+0x207/0x20e
[  288.288549] Pid: 0, comm: swapper Tainted: G        W   2.6.35-rc4-andres #9
[  288.288551] Call Trace:
[  288.288553]  <NMI>  [<ffffffff8103ea3b>] ? show_regs+0x2b/0x40
[  288.288561]  [<ffffffff81a675a2>] nmi_watchdog_tick+0x1b2/0x1e0
[  288.288563] Uhhuh. NMI received for unknown reason 00 on CPU 5.
[  288.288565] Do you have a strange power saving mode enabled?
[  288.288567] Dazed and confused, but trying to continue
[  288.288573]  [<ffffffff81a66913>] do_nmi+0x1c3/0x2f0
[  288.288578]  [<ffffffff81a660ea>] nmi+0x1a/0x2c
[  288.288583]  [<ffffffff8150a517>] ? intel_idle+0xc7/0x180
[  288.288586]  <<EOE>>  [<ffffffff81a695f6>] ? __atomic_notifier_call_chain+0x86/0xa0
[  288.288594]  [<ffffffff81a69570>] ? __atomic_notifier_call_chain+0x0/0xa0
[  288.288599]  [<ffffffff81892927>] cpuidle_idle_call+0xa7/0x140
[  288.288604]  [<ffffffff81035037>] cpu_idle+0xb7/0x110
[  288.288610]  [<ffffffff81a5b5ed>] start_secondary+0x207/0x20e
[  288.288615] NMI backtrace for cpu 4
[  288.288617] Uhhuh. NMI received for unknown reason 00 on CPU 2.
[  288.288619] Do you have a strange power saving mode enabled?
[  288.288622] Dazed and confused, but trying to continue
[  288.288626] CPU 4 
[  288.288628] Modules linked in:
[  288.288630] 
[  288.288633] Pid: 0, comm: swapper Tainted: G        W   2.6.35-rc4-andres #9 S7002/empty
[  288.288636] RIP: 0010:[<ffffffff8150a517>]  [<ffffffff8150a517>] intel_idle+0xc7/0x180
[  288.288642] RSP: 0018:ffff88042e1f7e68  EFLAGS: 00000046
[  288.288644] RAX: 0000000000000020 RBX: 0000000000000008 RCX: 0000000000000001
[  288.288647] RDX: 0000000000000000 RSI: ffff88042e1f7fd8 RDI: ffffffff8221b480
[  288.288650] RBP: ffff88042e1f7ec8 R08: 0000000000000002 R09: 0000000000000000
[  288.288652] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000020
[  288.288655] R13: 11be3fcab2b49134 R14: 0000000000000003 R15: 0000000000000000
[  288.288659] FS:  0000000000000000(0000) GS:ffff880003a00000(0000) knlGS:0000000000000000
[  288.288662] Uhhuh. NMI received for unknown reason 00 on CPU 6.
[  288.288665] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  288.288667] CR2: 00007f39810c8000 CR3: 000000042405a000 CR4: 00000000000006e0
[  288.288669] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  288.288672] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  288.288675] Process swapper (pid: 0, threadinfo ffff88042e1f6000, task ffff88042e1ec6c0)
[  288.288677] Stack:
[  288.288678]  0000000000000000 0000000000000001 ffff88042e1f7ec8 ffffffff81a695f6
[  288.288682] <0> ffffffff81a69570 000000042e1ec6c0 ffff88042e1f7ec8 ffff880003bdbf98
[  288.288687] <0> ffff880003bdc0c8 0000000000000000 0000000000000000 0000000000000000
[  288.288692] Call Trace:
[  288.288696]  [<ffffffff81a695f6>] ? __atomic_notifier_call_chain+0x86/0xa0
[  288.288700]  [<ffffffff81a69570>] ? __atomic_notifier_call_chain+0x0/0xa0
[  288.288702] Do you have a strange power saving mode enabled?
[  288.288704] Dazed and confused, but trying to continue
[  288.288710]  [<ffffffff81892927>] cpuidle_idle_call+0xa7/0x140
[  288.288714]  [<ffffffff81035037>] cpu_idle+0xb7/0x110
[  288.288718]  [<ffffffff81a5b5ed>] start_secondary+0x207/0x20e
[  288.288721] Code: ff ff a8 08 75 25 31 d2 48 8d 86 38 e0 ff ff 48 
[  288.288763] Uhhuh. NMI received for unknown reason 00 on CPU 7.
[  288.288765] Do you have a strange power saving mode enabled?
[  288.288767] Dazed and confused, but trying to continue
[  288.288773] 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e0 0f 01 c9 <e8> f4 b9 bf ff e8 4f 0b ba ff 4c 29 e8 48 89 c7 e8 54 bd b7 ff 
[  288.288854] Call Trace:
[  288.288858]  [<ffffffff81a695f6>] ? __atomic_notifier_call_chain+0x86/0xa0
[  288.288862]  [<ffffffff81a69570>] ? __atomic_notifier_call_chain+0x0/0xa0
[  288.288867]  [<ffffffff81892927>] cpuidle_idle_call+0xa7/0x140
[  288.288872]  [<ffffffff81035037>] cpu_idle+0xb7/0x110
[  288.288877]  [<ffffffff81a5b5ed>] start_secondary+0x207/0x20e
[  288.288881] Pid: 0, comm: swapper Tainted: G        W   2.6.35-rc4-andres #9
[  288.288884] Call Trace:
[  288.288887]  <NMI>  [<ffffffff8103ea3b>] ? show_regs+0x2b/0x40
[  288.288896]  [<ffffffff81a675a2>] nmi_watchdog_tick+0x1b2/0x1e0
[  288.288901]  [<ffffffff81a66913>] do_nmi+0x1c3/0x2f0
[  288.288906]  [<ffffffff81a660ea>] nmi+0x1a/0x2c
[  288.288911]  [<ffffffff8150a517>] ? intel_idle+0xc7/0x180
[  288.288914]  <<EOE>>  [<ffffffff81a695f6>] ? __atomic_notifier_call_chain+0x86/0xa0
[  288.288923]  [<ffffffff81a69570>] ? __atomic_notifier_call_chain+0x0/0xa0
[  288.288929]  [<ffffffff81892927>] cpuidle_idle_call+0xa7/0x140
[  288.288934]  [<ffffffff81035037>] cpu_idle+0xb7/0x110
[  288.288939]  [<ffffffff81a5b5ed>] start_secondary+0x207/0x20e
[  288.288943] NMI backtrace for cpu 3
[  288.288945] Uhhuh. NMI received for unknown reason 00 on CPU 4.
[  288.288947] Do you have a strange power saving mode enabled?
[  288.288949] Dazed and confused, but trying to continue
[  288.288954] CPU 3 
[  288.288957] Modules linked in:
[  288.288961] 
[  288.288964] Pid: 2636, comm: gnome-terminal Tainted: G        W   2.6.35-rc4-andres #9 S7002/empty
[  288.288969] RIP: 0033:[<00007feacc63b27d>]  [<00007feacc63b27d>] 0x7feacc63b27d
[  288.288975] RSP: 002b:00007fff3181db88  EFLAGS: 00000283
[  288.288979] RAX: 00000000000007f0 RBX: 0000000000000001 RCX: 0000000000000000
[  288.288982] RDX: 000000000004fa00 RSI: 00007feacc8c5c8c RDI: 00007fff3181dc30
[  288.288985] RBP: 00007feacc8c5c8c R08: 0000000000000001 R09: 00007feacc63b300
[  288.288989] R10: 00000000000004ef R11: 0000000000000000 R12: 0000000000000002
[  288.288993] R13: 0000000000000001 R14: 00007feacc8c5c30 R15: 0000000000000003
[  288.288996] FS:  00007fead078f920(0000) GS:ffff880003800000(0000) knlGS:0000000000000000
[  288.289000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  288.289004] CR2: 00007fe294830000 CR3: 0000000425e66000 CR4: 00000000000006e0
[  288.289007] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  288.289011] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  288.289015] Process gnome-terminal (pid: 2636, threadinfo ffff880429ade000, task ffff8804290f0000)
[  288.289018] 
[  288.289022] Call Trace:
[  288.289026] Pid: 2636, comm: gnome-terminal Tainted: G        W   2.6.35-rc4-andres #9
[  288.289030] Call Trace:
[  288.289032]  <NMI>  [<ffffffff8103ea3b>] ? show_regs+0x2b/0x40
[  288.289043]  [<ffffffff81a675a2>] nmi_watchdog_tick+0x1b2/0x1e0
[  288.289048]  [<ffffffff81a66913>] do_nmi+0x1c3/0x2f0
[  288.289053]  [<ffffffff81a660ea>] nmi+0x1a/0x2c
[  288.289056]  <<EOE>> 
[  288.289063] Uhhuh. NMI received for unknown reason 00 on CPU 3.
[  288.289067] Do you have a strange power saving mode enabled?
[  288.289071] Dazed and confused, but trying to continue
[  288.347766] [drm:radeon_dvi_detect] *ERROR* DVI-I-1: probed a monitor but no|invalid EDID

--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.35-rc4-andres (andres@awork2) (gcc version 4.4.4 (Ubuntu 4.4.4-6ubuntu2) ) #9 SMP Mon Jul 5 23:36:59 CEST 2010
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.35-rc4-andres root=UUID=58ba7a04-b424-4a46-acbe-b6ca208f61e1 ro clocksource=hpet netconsole=4444@192.168.224.176/eth0,4444@192.168.224/00:21:86:60:5d:d6
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
[    0.000000]  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf790000 (usable)
[    0.000000]  BIOS-e820: 00000000bf790000 - 00000000bf79e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf79e000 - 00000000bf7d0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf7d0000 - 00000000bf7e0000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf7ec000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffa00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000440000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x440000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D7FFF write-protect
[    0.000000]   D8000-DFFFF uncachable
[    0.000000]   E0000-E3FFF write-protect
[    0.000000]   E4000-E7FFF write-through
[    0.000000]   E8000-EBFFF write-protect
[    0.000000]   EC000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FC00000000 write-back
[    0.000000]   1 base 0400000000 mask FFC0000000 write-back
[    0.000000]   2 base 00C0000000 mask FFC0000000 uncachable
[    0.000000]   3 base 00BF800000 mask FFFF800000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000bf800000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbf790 max_arch_pfn = 0x400000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009d800 (usable)
[    0.000000]  modified: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000bf790000 (usable)
[    0.000000]  modified: 00000000bf790000 - 00000000bf79e000 (ACPI data)
[    0.000000]  modified: 00000000bf79e000 - 00000000bf7d0000 (ACPI NVS)
[    0.000000]  modified: 00000000bf7d0000 - 00000000bf7e0000 (reserved)
[    0.000000]  modified: 00000000bf7ec000 - 00000000c0000000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ffa00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000440000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] init_memory_mapping: 0000000000000000-00000000bf790000
[    0.000000]  0000000000 - 00bf600000 page 2M
[    0.000000]  00bf600000 - 00bf790000 page 4k
[    0.000000] kernel direct mapping tables up to bf790000 @ 16000-1b000
[    0.000000] init_memory_mapping: 0000000100000000-0000000440000000
[    0.000000]  0100000000 - 0440000000 page 2M
[    0.000000] kernel direct mapping tables up to 440000000 @ 19000-2b000
[    0.000000] RAMDISK: 37c8f000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000fa800 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000bf790100 0005C (v01 031710 XSDT1617 20100317 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bf790290 000F4 (v04 031710 FACP1617 20100317 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bf7904f0 0573E (v02  7002_ 7002_001 00000001 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bf79e000 00040
[    0.000000] ACPI: APIC 00000000bf790390 0011E (v02 031710 APIC1617 20100317 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bf7904b0 0003C (v01 031710 OEMMCFG  20100317 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bf79e040 0007A (v01 031710 OEMB1617 20100317 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000bf79a4f0 00038 (v01 031710 OEMHPET  20100317 MSFT 00000097)
[    0.000000] ACPI: DMAR 00000000bf79e0c0 00138 (v01    AMI  OEMDMAR 00000001 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bf7a0220 00363 (v01 DpgPmm    CpuPm 00000012 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000440000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000440000000
[    0.000000]   NODE_DATA [0000000100000000 - 0000000100004fff]
[    0.000000]  [ffffea0000000000-ffffea000edfffff] PMD -> [ffff880100200000-ffff88010e1fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00440000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000bf790
[    0.000000]     0: 0x00100000 -> 0x00440000
[    0.000000] On node 0 totalpages: 4192029
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3925 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 765896 pages, LIFO batch:31
[    0.000000]   Normal zone: 46592 pages used for memmap
[    0.000000]   Normal zone: 3361280 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x88] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x89] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x8a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x8b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x8c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x8d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x8e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x8f] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x90] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x91] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x92] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x93] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x94] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x95] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x96] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x97] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec8a000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec8a000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 20 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 24 CPUs, 16 hotplug CPUs
[    0.000000] nr_irqs_gsi: 64
[    0.000000] early_res array is doubled to 64 at [26000 - 267ff]
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bf790000 - 00000000bf79e000
[    0.000000] PM: Registered nosave memory: 00000000bf79e000 - 00000000bf7d0000
[    0.000000] PM: Registered nosave memory: 00000000bf7d0000 - 00000000bf7e0000
[    0.000000] PM: Registered nosave memory: 00000000bf7e0000 - 00000000bf7ec000
[    0.000000] PM: Registered nosave memory: 00000000bf7ec000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffa00000
[    0.000000] PM: Registered nosave memory: 00000000ffa00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:24 nr_node_ids:1
[    0.000000] early_res array is doubled to 128 at [26800 - 277ff]
[    0.000000] PERCPU: Embedded 477 pages/cpu @ffff880003200000 s1922304 r8192 d23296 u2097152
[    0.000000] pcpu-alloc: s1922304 r8192 d23296 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 [0] 01 [0] 02 [0] 03 [0] 04 [0] 05 [0] 06 [0] 07 
[    0.000000] pcpu-alloc: [0] 08 [0] 09 [0] 10 [0] 11 [0] 12 [0] 13 [0] 14 [0] 15 
[    0.000000] pcpu-alloc: [0] 16 [0] 17 [0] 18 [0] 19 [0] 20 [0] 21 [0] 22 [0] 23 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4131101
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.35-rc4-andres root=UUID=58ba7a04-b424-4a46-acbe-b6ca208f61e1 ro clocksource=hpet netconsole=4444@192.168.224.176/eth0,4444@192.168.224/00:21:86:60:5d:d6
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Subtract (79 early reservations)
[    0.000000]   #1 [0001000000 - 0002f92a30]   TEXT DATA BSS
[    0.000000]   #2 [0037c8f000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [0002f93000 - 0002f93155]             BRK
[    0.000000]   #4 [00000ff790 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000ff780 - 00000ff790]    MP-table mpf
[    0.000000]   #6 [000009d800 - 00000fdc50]   BIOS reserved
[    0.000000]   #7 [00000fde44 - 00000ff780]   BIOS reserved
[    0.000000]   #8 [00000fdc50 - 00000fde44]    MP-table mpc
[    0.000000]   #9 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #10 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #11 [0000016000 - 0000019000]         PGTABLE
[    0.000000]   #12 [0000019000 - 0000026000]         PGTABLE
[    0.000000]   #13 [0100000000 - 0100005000]       NODE_DATA
[    0.000000]   #14 [0002f93180 - 0002f94180]         BOOTMEM
[    0.000000]   #15 [0002f94180 - 0002f95180]         BOOTMEM
[    0.000000]   #16 [0100005000 - 0100005c00]         BOOTMEM
[    0.000000]   #17 [0100006000 - 0100007000]         BOOTMEM
[    0.000000]   #18 [0100007000 - 0100008000]         BOOTMEM
[    0.000000]   #19 [0100200000 - 010e200000]        MEMMAP 0
[    0.000000]   #20 [0002f95180 - 0002fe5180]         BOOTMEM
[    0.000000]   #21 [0002fe5180 - 0003035180]         BOOTMEM
[    0.000000]   #22 [0003035180 - 0003085180]         BOOTMEM
[    0.000000]   #23 [0003086000 - 0003087000]         BOOTMEM
[    0.000000]   #24 [0002f92a40 - 0002f92a81]         BOOTMEM
[    0.000000]   #25 [0002f92ac0 - 0002f92b46]         BOOTMEM
[    0.000000]   #26 [0002f92b80 - 0002f92e58]         BOOTMEM
[    0.000000]   #27 [0002f92e80 - 0002f92ee8]         BOOTMEM
[    0.000000]   #28 [0002f92f00 - 0002f92f68]         BOOTMEM
[    0.000000]   #29 [0002f92f80 - 0002f92fe8]         BOOTMEM
[    0.000000]   #30 [0003085180 - 00030851e8]         BOOTMEM
[    0.000000]   #31 [0003085200 - 0003085268]         BOOTMEM
[    0.000000]   #32 [0003085280 - 00030852e8]         BOOTMEM
[    0.000000]   #33 [0003085300 - 0003085368]         BOOTMEM
[    0.000000]   #34 [0003085380 - 00030853e8]         BOOTMEM
[    0.000000]   #35 [0003085400 - 0003085468]         BOOTMEM
[    0.000000]   #36 [0003085480 - 00030854e8]         BOOTMEM
[    0.000000]   #37 [0003085500 - 0003085568]         BOOTMEM
[    0.000000]   #38 [0003085580 - 00030855e8]         BOOTMEM
[    0.000000]   #39 [0003085600 - 0003085620]         BOOTMEM
[    0.000000]   #40 [0003085640 - 0003085660]         BOOTMEM
[    0.000000]   #41 [0003085680 - 0003085731]         BOOTMEM
[    0.000000]   #42 [0003085740 - 00030857f1]         BOOTMEM
[    0.000000]   #43 [0003200000 - 00033dd000]         BOOTMEM
[    0.000000]   #44 [0003400000 - 00035dd000]         BOOTMEM
[    0.000000]   #45 [0003600000 - 00037dd000]         BOOTMEM
[    0.000000]   #46 [0003800000 - 00039dd000]         BOOTMEM
[    0.000000]   #47 [0003a00000 - 0003bdd000]         BOOTMEM
[    0.000000]   #48 [0003c00000 - 0003ddd000]         BOOTMEM
[    0.000000]   #49 [0003e00000 - 0003fdd000]         BOOTMEM
[    0.000000]   #50 [0004000000 - 00041dd000]         BOOTMEM
[    0.000000]   #51 [0004200000 - 00043dd000]         BOOTMEM
[    0.000000]   #52 [0004400000 - 00045dd000]         BOOTMEM
[    0.000000]   #53 [0004600000 - 00047dd000]         BOOTMEM
[    0.000000]   #54 [0004800000 - 00049dd000]         BOOTMEM
[    0.000000]   #55 [0004a00000 - 0004bdd000]         BOOTMEM
[    0.000000]   #56 [0004c00000 - 0004ddd000]         BOOTMEM
[    0.000000]   #57 [0004e00000 - 0004fdd000]         BOOTMEM
[    0.000000]   #58 [0005000000 - 00051dd000]         BOOTMEM
[    0.000000]   #59 [0005200000 - 00053dd000]         BOOTMEM
[    0.000000]   #60 [0005400000 - 00055dd000]         BOOTMEM
[    0.000000]   #61 [0005600000 - 00057dd000]         BOOTMEM
[    0.000000]   #62 [0005800000 - 00059dd000]         BOOTMEM
[    0.000000]   #63 [0005a00000 - 0005bdd000]         BOOTMEM
[    0.000000]   #64 [0005c00000 - 0005ddd000]         BOOTMEM
[    0.000000]   #65 [0005e00000 - 0005fdd000]         BOOTMEM
[    0.000000]   #66 [0006000000 - 00061dd000]         BOOTMEM
[    0.000000]   #67 [0003085800 - 0003085808]         BOOTMEM
[    0.000000]   #68 [0003085840 - 0003085848]         BOOTMEM
[    0.000000]   #69 [0003085880 - 00030858e0]         BOOTMEM
[    0.000000]   #70 [0003085900 - 00030859c0]         BOOTMEM
[    0.000000]   #71 [00030859c0 - 0003085b10]         BOOTMEM
[    0.000000]   #72 [0003085b40 - 0003085bc0]         BOOTMEM
[    0.000000]   #73 [0003085bc0 - 0003085c40]         BOOTMEM
[    0.000000]   #74 [0003087000 - 000308f000]         BOOTMEM
[    0.000000]   #75 [00061dd000 - 000a1dd000]         BOOTMEM
[    0.000000]   #76 [000308f000 - 00030af000]         BOOTMEM
[    0.000000]   #77 [00030af000 - 00030ef000]         BOOTMEM
[    0.000000]   #78 [0000027800 - 000002f800]         BOOTMEM
[    0.000000] Memory: 16390072k/17825792k available (10688k kernel code, 1057676k absent, 378044k reserved, 9163k data, 2648k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=24, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU lockdep checking is enabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:1280
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] allocated 167772160 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.003333] Detected 2266.751 MHz processor.
[    0.000022] Calibrating delay loop (skipped), value calculated using timer frequency.. 4535.39 BogoMIPS (lpj=7555836)
[    0.000245] pid_max: default: 32768 minimum: 301
[    0.002522] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.007132] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.009056] Mount-cache hash table entries: 256
[    0.010020] Initializing cgroup subsys ns
[    0.010137] Initializing cgroup subsys cpuacct
[    0.010249] Initializing cgroup subsys memory
[    0.010401] Initializing cgroup subsys devices
[    0.010529] Initializing cgroup subsys freezer
[    0.010652] Initializing cgroup subsys net_cls
[    0.010837] CPU: Physical Processor ID: 1
[    0.010956] CPU: Processor Core ID: 0
[    0.011083] mce: CPU supports 9 MCE banks
[    0.011213] CPU0: Thermal monitoring enabled (TM1)
[    0.011364] using mwait in idle threads.
[    0.011481] Performance Events: PEBS fmt1+, Nehalem events, Intel PMU driver.
[    0.011852] ... version:                3
[    0.011946] ... bit width:              48
[    0.012094] ... generic registers:      4
[    0.012825] ... value mask:             0000ffffffffffff
[    0.012934] ... max period:             000000007fffffff
[    0.013042] ... fixed-purpose events:   3
[    0.013148] ... event mask:             000000070000000f
[    0.013395] ACPI: Core revision 20100428
[    0.066593] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.066741] ftrace: allocating 33074 entries in 130 pages
[    0.078468] DMAR: Host address width 40
[    0.078591] DMAR: DRHD base: 0x000000fbffe000 flags: 0x1
[    0.078768] IOMMU 0: reg_base_addr fbffe000 ver 1:0 cap c90780106f0462 ecap f0207e
[    0.078914] DMAR: RMRR base: 0x000000000ec000 end: 0x000000000effff
[    0.079026] DMAR: RMRR base: 0x000000bf7ec000 end: 0x000000bf7fffff
[    0.079156] DMAR: ATSR flags: 0x0
[    0.079424] IOAPIC id 8 under DRHD base  0xfbffe000 IOMMU 0
[    0.079561] IOAPIC id 9 under DRHD base  0xfbffe000 IOMMU 0
[    0.079859] Enabled Interrupt-remapping
[    0.079983] Setting APIC routing to physical flat
[    0.080133]   alloc irq_desc for 64 on node 0
[    0.080136]   alloc kstat_irqs on node 0
[    0.080496] alloc irq_2_iommu on node 0
[    0.080513] alloc irq_2_iommu on node 0
[    0.080527] alloc irq_2_iommu on node 0
[    0.080540] alloc irq_2_iommu on node 0
[    0.080554] alloc irq_2_iommu on node 0
[    0.080567] alloc irq_2_iommu on node 0
[    0.080580] alloc irq_2_iommu on node 0
[    0.080594] alloc irq_2_iommu on node 0
[    0.080603] alloc irq_2_iommu on node 0
[    0.080617] alloc irq_2_iommu on node 0
[    0.080630] alloc irq_2_iommu on node 0
[    0.080644] alloc irq_2_iommu on node 0
[    0.080657] alloc irq_2_iommu on node 0
[    0.080670] alloc irq_2_iommu on node 0
[    0.080684] alloc irq_2_iommu on node 0
[    0.080873] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.113963] CPU0: Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz stepping 05
[    0.218917] lockdep: fixing up alternatives.
[    0.219117] 
[    0.219118] ===================================================
[    0.219389] [ INFO: suspicious rcu_dereference_check() usage. ]
[    0.219518] ---------------------------------------------------
[    0.219658] kernel/sched.c:616 invoked rcu_dereference_check() without protection!
[    0.219822] 
[    0.219822] other info that might help us debug this:
[    0.219823] 
[    0.220170] 
[    0.220170] rcu_scheduler_active = 1, debug_locks = 0
[    0.220427] 3 locks held by swapper/1:
[    0.220564]  #0:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff810822a7>] cpu_maps_update_begin+0x17/0x20
[    0.221053]  #1:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff810822fc>] cpu_hotplug_begin+0x2c/0x60
[    0.221567]  #2:  (&rq->lock){-.....}, at: [<ffffffff81a5c5c8>] init_idle+0x39/0x38b
[    0.222068] 
[    0.222068] stack backtrace:
[    0.222316] Pid: 1, comm: swapper Not tainted 2.6.35-rc4-andres #9
[    0.222448] Call Trace:
[    0.222569]  [<ffffffff810b3afb>] lockdep_rcu_dereference+0xbb/0xc0
[    0.222696]  [<ffffffff81a5c6e9>] init_idle+0x15a/0x38b
[    0.222799]  [<ffffffff81a5ccfc>] fork_idle+0xbb/0xca
[    0.222926]  [<ffffffff81a62aa2>] ? __mutex_unlock_slowpath+0xc2/0x140
[    0.223065]  [<ffffffff81a5b096>] do_fork_idle+0x1c/0x2e
[    0.223190]  [<ffffffff81a5a9a0>] do_boot_cpu+0x133/0x64d
[    0.223327]  [<ffffffff81a5b07a>] ? do_fork_idle+0x0/0x2e
[    0.223472]  [<ffffffff81a5af72>] native_cpu_up+0xb8/0x116
[    0.223602]  [<ffffffff81a5cddb>] _cpu_up+0xa0/0x11d
[    0.223722]  [<ffffffff81a5cf36>] cpu_up+0xde/0xf1
[    0.223845]  [<ffffffff8253a6a1>] kernel_init+0xe2/0x207
[    0.223984]  [<ffffffff81036ed4>] kernel_thread_helper+0x4/0x10
[    0.224106]  [<ffffffff81a65bfc>] ? restore_args+0x0/0x30
[    0.224251]  [<ffffffff8253a5bf>] ? kernel_init+0x0/0x207
[    0.224388]  [<ffffffff81036ed0>] ? kernel_thread_helper+0x0/0x10
[    0.224533] Booting Node   0, Processors  #1lockdep: fixing up alternatives.
[    0.338554]  #2lockdep: fixing up alternatives.
[    0.451698]  #3lockdep: fixing up alternatives.
[    0.564784]  #4lockdep: fixing up alternatives.
[    0.677902]  #5lockdep: fixing up alternatives.
[    0.791078]  #6lockdep: fixing up alternatives.
[    0.904180]  #7
[    1.017133] Brought up 8 CPUs
[    1.017365] Total of 8 processors activated (36280.26 BogoMIPS).
[    1.020837] devtmpfs: initialized
[    1.023690] xor: automatically using best checksumming function: generic_sse
[    1.040304]    generic_sse:  8438.400 MB/sec
[    1.040414] xor: using function: generic_sse (8438.400 MB/sec)
[    1.040568] regulator: core version 0.5
[    1.040697] Time: 18:43:28  Date: 07/06/10
[    1.040880] NET: Registered protocol family 16
[    1.041139] ACPI: bus type pci registered
[    1.041322] dca service started, version 1.12.1
[    1.041485] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    1.041642] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    1.095044] PCI: Using configuration type 1 for base access
[    1.098668] bio: create slab <bio-0> at 0
[    1.101785] ACPI: EC: Look up EC in DSDT
[    1.105320] ACPI: Executed 1 blocks of module-level executable AML code
[    1.114370] ACPI: SSDT 00000000bf79e200 015DC (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
[    1.115616] ACPI: Dynamic OEM Table Load:
[    1.115925] ACPI: SSDT (null) 015DC (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
[    1.116494] ACPI: SSDT 00000000bf79f7e0 00678 (v01  PmRef  P001Cst 00003001 INTL 20051117)
[    1.117656] ACPI: Dynamic OEM Table Load:
[    1.117964] ACPI: SSDT (null) 00678 (v01  PmRef  P001Cst 00003001 INTL 20051117)
[    1.118474] ACPI: SSDT 00000000bf79fe60 003BA (v01  PmRef  Cpu0Tst 00003000 INTL 20051117)
[    1.119680] ACPI: Dynamic OEM Table Load:
[    1.119957] ACPI: SSDT (null) 003BA (v01  PmRef  Cpu0Tst 00003000 INTL 20051117)
[    1.120632] ACPI: Interpreter enabled
[    1.120772] ACPI: (supports S0 S1 S3 S4 S5)
[    1.121309] ACPI: Using IOAPIC for interrupt routing
[    1.137867] ACPI: No dock devices found.
[    1.137988] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.138309] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.138761] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.138891] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.139025] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.139177] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
[    1.139339] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xdfffffff]
[    1.139516] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfed8ffff]
[    1.139760] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    1.139879] pci 0000:00:00.0: PME# disabled
[    1.140062] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.140200] pci 0000:00:01.0: PME# disabled
[    1.140399] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    1.140544] pci 0000:00:03.0: PME# disabled
[    1.140738] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    1.140859] pci 0000:00:07.0: PME# disabled
[    1.141050] pci 0000:00:08.0: PME# supported from D0 D3hot D3cold
[    1.141171] pci 0000:00:08.0: PME# disabled
[    1.141357] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    1.141487] pci 0000:00:09.0: PME# disabled
[    1.141677] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    1.141804] pci 0000:00:0a.0: PME# disabled
[    1.141993] pci 0000:00:13.0: reg 10: [mem 0xfec8a000-0xfec8afff]
[    1.142158] pci 0000:00:13.0: PME# supported from D0 D3hot D3cold
[    1.142290] pci 0000:00:13.0: PME# disabled
[    1.142655] pci 0000:00:16.0: reg 10: [mem 0xfb8d4000-0xfb8d7fff 64bit]
[    1.142851] pci 0000:00:16.1: reg 10: [mem 0xfb8d8000-0xfb8dbfff 64bit]
[    1.143049] pci 0000:00:16.2: reg 10: [mem 0xfb8dc000-0xfb8dffff 64bit]
[    1.143241] pci 0000:00:16.3: reg 10: [mem 0xfb8e0000-0xfb8e3fff 64bit]
[    1.143458] pci 0000:00:16.4: reg 10: [mem 0xfb8e4000-0xfb8e7fff 64bit]
[    1.143652] pci 0000:00:16.5: reg 10: [mem 0xfb8e8000-0xfb8ebfff 64bit]
[    1.143851] pci 0000:00:16.6: reg 10: [mem 0xfb8ec000-0xfb8effff 64bit]
[    1.144049] pci 0000:00:16.7: reg 10: [mem 0xfb8f0000-0xfb8f3fff 64bit]
[    1.144291] pci 0000:00:1a.0: reg 20: [io  0x7400-0x741f]
[    1.144503] pci 0000:00:1a.1: reg 20: [io  0x7480-0x749f]
[    1.144713] pci 0000:00:1a.2: reg 20: [io  0x7800-0x781f]
[    1.144913] pci 0000:00:1a.7: reg 10: [mem 0xfb8f6000-0xfb8f63ff]
[    1.145110] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    1.145245] pci 0000:00:1a.7: PME# disabled
[    1.145480] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.145625] pci 0000:00:1c.0: PME# disabled
[    1.145881] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    1.145998] pci 0000:00:1c.4: PME# disabled
[    1.146224] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    1.146364] pci 0000:00:1c.5: PME# disabled
[    1.146586] pci 0000:00:1d.0: reg 20: [io  0x7880-0x789f]
[    1.146809] pci 0000:00:1d.1: reg 20: [io  0x7c00-0x7c1f]
[    1.147041] pci 0000:00:1d.2: reg 20: [io  0x8000-0x801f]
[    1.147273] pci 0000:00:1d.7: reg 10: [mem 0xfb8f8000-0xfb8f83ff]
[    1.147454] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.147595] pci 0000:00:1d.7: PME# disabled
[    1.147908] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
[    1.148079] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
[    1.148206] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0a00 (mask 00ff)
[    1.148377] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca0 (mask 000f)
[    1.148637] pci 0000:00:1f.2: reg 10: [io  0x8c00-0x8c07]
[    1.148778] pci 0000:00:1f.2: reg 14: [io  0x8880-0x8883]
[    1.148885] pci 0000:00:1f.2: reg 18: [io  0x8800-0x8807]
[    1.149020] pci 0000:00:1f.2: reg 1c: [io  0x8480-0x8483]
[    1.149146] pci 0000:00:1f.2: reg 20: [io  0x8400-0x840f]
[    1.149257] pci 0000:00:1f.2: reg 24: [io  0x8080-0x808f]
[    1.149451] pci 0000:00:1f.3: reg 10: [mem 0xfb8fa000-0xfb8fa0ff 64bit]
[    1.149577] pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
[    1.149786] pci 0000:00:1f.5: reg 10: [io  0x9c00-0x9c07]
[    1.149917] pci 0000:00:1f.5: reg 14: [io  0x9880-0x9883]
[    1.150059] pci 0000:00:1f.5: reg 18: [io  0x9800-0x9807]
[    1.150211] pci 0000:00:1f.5: reg 1c: [io  0x9480-0x9483]
[    1.150349] pci 0000:00:1f.5: reg 20: [io  0x9400-0x940f]
[    1.150479] pci 0000:00:1f.5: reg 24: [io  0x9080-0x908f]
[    1.150744] pci 0000:0a:00.0: reg 10: [io  0xe000-0xe0ff]
[    1.151516] pci 0000:0a:00.0: reg 14: [mem 0xfbefc000-0xfbefffff 64bit]
[    1.151657] pci 0000:0a:00.0: reg 1c: [mem 0xfbee0000-0xfbeeffff 64bit]
[    1.151798] pci 0000:0a:00.0: reg 30: [mem 0xfbc00000-0xfbdfffff pref]
[    1.151954] pci 0000:0a:00.0: supports D1 D2
[    1.152102] pci 0000:0a:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    1.152286] pci 0000:00:01.0: PCI bridge to [bus 0a-0a]
[    1.152386] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    1.152519] pci 0000:00:01.0:   bridge window [mem 0xfbc00000-0xfbefffff]
[    1.152641] pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.152833] pci 0000:00:03.0: PCI bridge to [bus 09-09]
[    1.152965] pci 0000:00:03.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.153096] pci 0000:00:03.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.153275] pci 0000:00:03.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.153506] pci 0000:08:00.0: reg 10: [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.153646] pci 0000:08:00.0: reg 18: [mem 0xfbbe0000-0xfbbeffff 64bit]
[    1.153784] pci 0000:08:00.0: reg 20: [io  0xd000-0xd0ff]
[    1.153929] pci 0000:08:00.0: reg 30: [mem 0xfbbc0000-0xfbbdffff pref]
[    1.154080] pci 0000:08:00.0: supports D1 D2
[    1.154225] pci 0000:08:00.1: reg 10: [mem 0xfbbfc000-0xfbbfffff 64bit]
[    1.154397] pci 0000:08:00.1: supports D1 D2
[    1.160191] pci 0000:00:07.0: PCI bridge to [bus 08-08]
[    1.160340] pci 0000:00:07.0:   bridge window [io  0xd000-0xdfff]
[    1.160458] pci 0000:00:07.0:   bridge window [mem 0xfbb00000-0xfbbfffff]
[    1.160606] pci 0000:00:07.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.160815] pci 0000:00:08.0: PCI bridge to [bus 07-07]
[    1.160951] pci 0000:00:08.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.161088] pci 0000:00:08.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.161250] pci 0000:00:08.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.161471] pci 0000:00:09.0: PCI bridge to [bus 06-06]
[    1.161595] pci 0000:00:09.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.161730] pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.161889] pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.162110] pci 0000:00:0a.0: PCI bridge to [bus 05-05]
[    1.162231] pci 0000:00:0a.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.162355] pci 0000:00:0a.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.162522] pci 0000:00:0a.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.162731] pci 0000:00:1c.0: PCI bridge to [bus 04-04]
[    1.162844] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.162984] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.163148] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.163529] pci 0000:03:00.0: reg 10: [mem 0xfbae0000-0xfbafffff]
[    1.163686] pci 0000:03:00.0: reg 18: [io  0xcc00-0xcc1f]
[    1.163845] pci 0000:03:00.0: reg 1c: [mem 0xfbadc000-0xfbadffff]
[    1.164229] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    1.164369] pci 0000:03:00.0: PME# disabled
[    1.164682] pci 0000:00:1c.4: PCI bridge to [bus 03-03]
[    1.164829] pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
[    1.164954] pci 0000:00:1c.4:   bridge window [mem 0xfba00000-0xfbafffff]
[    1.165100] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.165440] pci 0000:02:00.0: reg 10: [mem 0xfb9e0000-0xfb9fffff]
[    1.165603] pci 0000:02:00.0: reg 18: [io  0xbc00-0xbc1f]
[    1.165769] pci 0000:02:00.0: reg 1c: [mem 0xfb9dc000-0xfb9dffff]
[    1.166164] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    1.166315] pci 0000:02:00.0: PME# disabled
[    1.166608] pci 0000:00:1c.5: PCI bridge to [bus 02-02]
[    1.166744] pci 0000:00:1c.5:   bridge window [io  0xb000-0xbfff]
[    1.166889] pci 0000:00:1c.5:   bridge window [mem 0xfb900000-0xfb9fffff]
[    1.167025] pci 0000:00:1c.5:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.167266] pci 0000:01:00.0: reg 10: [mem 0xfb000000-0xfb7fffff]
[    1.167395] pci 0000:01:00.0: reg 14: [mem 0xfafe0000-0xfaffffff]
[    1.167535] pci 0000:01:00.0: reg 18: [io  0xac00-0xac7f]
[    1.167730] pci 0000:01:00.0: supports D1 D2
[    1.167846] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.167973] pci 0000:01:00.0: PME# disabled
[    1.168245] pci 0000:00:1e.0: PCI bridge to [bus 01-01] (subtractive decode)
[    1.168374] pci 0000:00:1e.0:   bridge window [io  0xa000-0xafff]
[    1.168518] pci 0000:00:1e.0:   bridge window [mem 0xfaf00000-0xfb7fffff]
[    1.168632] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.168811] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    1.168989] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    1.169159] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.169335] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    1.169480] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xdfffffff] (subtractive decode)
[    1.169628] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfed8ffff] (subtractive decode)
[    1.169860] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.170329] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    1.170634] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    1.170841] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
[    1.171038] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
[    1.171239] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1._PRT]
[    1.171435] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE3._PRT]
[    1.171637] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE7._PRT]
[    1.238672] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12 14 15)
[    1.239827] ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
[    1.240340] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 11 12 14 *15)
[    1.241499] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 *11 12 14 15)
[    1.242667] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
[    1.244061] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 *7 10 11 12 14 15)
[    1.245210] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
[    1.246580] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 7 10 11 12 *14 15)
[    1.247706] HEST: Table is not found!
[    1.247924] vgaarb: device added: PCI:0000:08:00.0,decodes=io+mem,owns=io+mem,locks=none
[    1.248110] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=none,locks=none
[    1.248273] vgaarb: loaded
[    1.248506] SCSI subsystem initialized
[    1.248806] libata version 3.00 loaded.
[    1.248995] usbcore: registered new interface driver usbfs
[    1.249133] usbcore: registered new interface driver hub
[    1.249304] usbcore: registered new device driver usb
[    1.303204] raid6: int64x1   2058 MB/s
[    1.359771] raid6: int64x2   2493 MB/s
[    1.416324] raid6: int64x4   1821 MB/s
[    1.472903] raid6: int64x8   1858 MB/s
[    1.529472] raid6: sse2x1    5626 MB/s
[    1.586039] raid6: sse2x2    6591 MB/s
[    1.642605] raid6: sse2x4    7342 MB/s
[    1.642730] raid6: using algorithm sse2x4 (7342 MB/s)
[    1.642905] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    1.643044] PCI: Using ACPI for IRQ routing
[    1.643159] PCI: pci_cache_line_size set to 64 bytes
[    1.643672] reserve RAM buffer: 000000000009d800 - 000000000009ffff 
[    1.643769] reserve RAM buffer: 00000000bf790000 - 00000000bfffffff 
[    1.644091] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    1.644342] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    1.644875] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    1.662777] Switching to clocksource hpet
[    1.683011] pnp: PnP ACPI init
[    1.683154] ACPI: bus type pnp registered
[    1.688772] pnp: PnP ACPI: found 15 devices
[    1.688889] ACPI: ACPI bus type pnp unregistered
[    1.689025] system 00:01: [mem 0xfbf00000-0xfbffffff] has been reserved
[    1.689155] system 00:01: [mem 0xfc000000-0xfcffffff] has been reserved
[    1.689272] system 00:01: [mem 0xfd000000-0xfdffffff] has been reserved
[    1.689384] system 00:01: [mem 0xfe000000-0xfebfffff] has been reserved
[    1.689524] system 00:01: [mem 0xfec8a000-0xfec8afff] could not be reserved
[    1.689673] system 00:01: [mem 0xfed10000-0xfed10fff] has been reserved
[    1.689817] system 00:08: [io  0x0a00-0x0a0f] has been reserved
[    1.689950] system 00:08: [io  0x0a10-0x0a1f] has been reserved
[    1.690075] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    1.690218] system 00:09: [io  0x0800-0x087f] has been reserved
[    1.690350] system 00:09: [io  0x0500-0x057f] could not be reserved
[    1.690483] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.690623] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
[    1.690755] system 00:09: [mem 0xfed40000-0xfed8ffff] has been reserved
[    1.690882] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.691015] system 00:0b: [mem 0xfee00000-0xfee00fff] has been reserved
[    1.691163] system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
[    1.691305] system 00:0e: [mem 0x00000000-0x0009ffff] could not be reserved
[    1.691426] system 00:0e: [mem 0x000c0000-0x000cffff] has been reserved
[    1.691566] system 00:0e: [mem 0x000e0000-0x000fffff] could not be reserved
[    1.691704] system 00:0e: [mem 0x00100000-0xbfffffff] could not be reserved
[    1.691845] system 00:0e: [mem 0xfed90000-0xffffffff] could not be reserved
[    1.697202] pci 0000:00:1c.0: BAR 14: assigned [mem 0xc0000000-0xc01fffff]
[    1.697338] pci 0000:00:1c.0: BAR 15: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
[    1.697513] pci 0000:00:1c.4: BAR 15: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
[    1.697658] pci 0000:00:1c.5: BAR 15: assigned [mem 0xc0600000-0xc07fffff 64bit pref]
[    1.697830] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    1.697962] pci 0000:00:01.0: PCI bridge to [bus 0a-0a]
[    1.698101] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    1.698243] pci 0000:00:01.0:   bridge window [mem 0xfbc00000-0xfbefffff]
[    1.698374] pci 0000:00:01.0:   bridge window [mem pref disabled]
[    1.699150] pci 0000:00:03.0: PCI bridge to [bus 09-09]
[    1.699272] pci 0000:00:03.0:   bridge window [io  disabled]
[    1.699379] pci 0000:00:03.0:   bridge window [mem disabled]
[    1.699519] pci 0000:00:03.0:   bridge window [mem pref disabled]
[    1.699654] pci 0000:00:07.0: PCI bridge to [bus 08-08]
[    1.699784] pci 0000:00:07.0:   bridge window [io  0xd000-0xdfff]
[    1.699922] pci 0000:00:07.0:   bridge window [mem 0xfbb00000-0xfbbfffff]
[    1.700058] pci 0000:00:07.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.700216] pci 0000:00:08.0: PCI bridge to [bus 07-07]
[    1.700331] pci 0000:00:08.0:   bridge window [io  disabled]
[    1.700465] pci 0000:00:08.0:   bridge window [mem disabled]
[    1.700566] pci 0000:00:08.0:   bridge window [mem pref disabled]
[    1.700712] pci 0000:00:09.0: PCI bridge to [bus 06-06]
[    1.700844] pci 0000:00:09.0:   bridge window [io  disabled]
[    1.700958] pci 0000:00:09.0:   bridge window [mem disabled]
[    1.701070] pci 0000:00:09.0:   bridge window [mem pref disabled]
[    1.701212] pci 0000:00:0a.0: PCI bridge to [bus 05-05]
[    1.701326] pci 0000:00:0a.0:   bridge window [io  disabled]
[    1.701444] pci 0000:00:0a.0:   bridge window [mem disabled]
[    1.701580] pci 0000:00:0a.0:   bridge window [mem pref disabled]
[    1.701726] pci 0000:00:1c.0: PCI bridge to [bus 04-04]
[    1.701853] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    1.701969] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff]
[    1.702109] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
[    1.702283] pci 0000:00:1c.4: PCI bridge to [bus 03-03]
[    1.702420] pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
[    1.702559] pci 0000:00:1c.4:   bridge window [mem 0xfba00000-0xfbafffff]
[    1.702686] pci 0000:00:1c.4:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
[    1.702879] pci 0000:00:1c.5: PCI bridge to [bus 02-02]
[    1.703021] pci 0000:00:1c.5:   bridge window [io  0xb000-0xbfff]
[    1.703149] pci 0000:00:1c.5:   bridge window [mem 0xfb900000-0xfb9fffff]
[    1.703283] pci 0000:00:1c.5:   bridge window [mem 0xc0600000-0xc07fffff 64bit pref]
[    1.703459] pci 0000:00:1e.0: PCI bridge to [bus 01-01]
[    1.703604] pci 0000:00:1e.0:   bridge window [io  0xa000-0xafff]
[    1.703735] pci 0000:00:1e.0:   bridge window [mem 0xfaf00000-0xfb7fffff]
[    1.703869] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    1.704016] pci 0000:00:01.0: setting latency timer to 64
[    1.704142] pci 0000:00:03.0: setting latency timer to 64
[    1.704281] pci 0000:00:07.0: setting latency timer to 64
[    1.704424] pci 0000:00:08.0: setting latency timer to 64
[    1.704544] pci 0000:00:09.0: setting latency timer to 64
[    1.704657] pci 0000:00:0a.0: setting latency timer to 64
[    1.704794] pci 0000:00:1c.0: enabling device (0104 -> 0107)
[    1.704944]   alloc irq_desc for 17 on node -1
[    1.705056]   alloc kstat_irqs on node -1
[    1.705175] alloc irq_2_iommu on node -1
[    1.705279] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.705402] pci 0000:00:1c.0: setting latency timer to 64
[    1.705557] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.705691] pci 0000:00:1c.4: setting latency timer to 64
[    1.705844]   alloc irq_desc for 16 on node -1
[    1.705957]   alloc kstat_irqs on node -1
[    1.706092] alloc irq_2_iommu on node -1
[    1.706236] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    1.706371] pci 0000:00:1c.5: setting latency timer to 64
[    1.706517] pci 0000:00:1e.0: setting latency timer to 64
[    1.706641] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.706775] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.706911] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.707027] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    1.707142] pci_bus 0000:00: resource 8 [mem 0xc0000000-0xdfffffff]
[    1.707271] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfed8ffff]
[    1.707406] pci_bus 0000:0a: resource 0 [io  0xe000-0xefff]
[    1.707541] pci_bus 0000:0a: resource 1 [mem 0xfbc00000-0xfbefffff]
[    1.707642] pci_bus 0000:08: resource 0 [io  0xd000-0xdfff]
[    1.707784] pci_bus 0000:08: resource 1 [mem 0xfbb00000-0xfbbfffff]
[    1.707927] pci_bus 0000:08: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.708105] pci_bus 0000:04: resource 0 [io  0x1000-0x1fff]
[    1.708227] pci_bus 0000:04: resource 1 [mem 0xc0000000-0xc01fffff]
[    1.708349] pci_bus 0000:04: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
[    1.708517] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
[    1.708640] pci_bus 0000:03: resource 1 [mem 0xfba00000-0xfbafffff]
[    1.708764] pci_bus 0000:03: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
[    1.708938] pci_bus 0000:02: resource 0 [io  0xb000-0xbfff]
[    1.709045] pci_bus 0000:02: resource 1 [mem 0xfb900000-0xfb9fffff]
[    1.709188] pci_bus 0000:02: resource 2 [mem 0xc0600000-0xc07fffff 64bit pref]
[    1.709345] pci_bus 0000:01: resource 0 [io  0xa000-0xafff]
[    1.709452] pci_bus 0000:01: resource 1 [mem 0xfaf00000-0xfb7fffff]
[    1.709594] pci_bus 0000:01: resource 4 [io  0x0000-0x0cf7]
[    1.709721] pci_bus 0000:01: resource 5 [io  0x0d00-0xffff]
[    1.709860] pci_bus 0000:01: resource 6 [mem 0x000a0000-0x000bffff]
[    1.709984] pci_bus 0000:01: resource 7 [mem 0x000d0000-0x000dffff]
[    1.710128] pci_bus 0000:01: resource 8 [mem 0xc0000000-0xdfffffff]
[    1.710264] pci_bus 0000:01: resource 9 [mem 0xf0000000-0xfed8ffff]
[    1.710423] NET: Registered protocol family 2
[    1.711000] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    1.712608] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.714750] TCP bind hash table entries: 65536 (order: 10, 4718592 bytes)
[    1.716749] TCP: Hash tables configured (established 524288 bind 65536)
[    1.716880] TCP reno registered
[    1.717139] UDP hash table entries: 8192 (order: 8, 1310720 bytes)
[    1.717844] UDP-Lite hash table entries: 8192 (order: 8, 1310720 bytes)
[    1.718635] NET: Registered protocol family 1
[    1.719192] RPC: Registered udp transport module.
[    1.719313] RPC: Registered tcp transport module.
[    1.719434] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.719916] swapper:1 freeing invalid memtype fb8f8000-fb8f9000
[    1.720101] pci 0000:08:00.0: Boot video device
[    1.720320] PCI: CLS 256 bytes, default 64
[    1.720505] Trying to unpack rootfs image as initramfs...
[    1.788465] Freeing initrd memory: 3460k freed
[    1.789162] IOMMU 0 0xfbffe000: using Queued invalidation
[    1.789300] IOMMU: Setting RMRR:
[    1.789437] IOMMU: Setting identity map for device 0000:00:1d.0 [0xbf7ec000 - 0xbf800000]
[    1.789656] IOMMU: Setting identity map for device 0000:00:1d.1 [0xbf7ec000 - 0xbf800000]
[    1.789856] IOMMU: Setting identity map for device 0000:00:1d.2 [0xbf7ec000 - 0xbf800000]
[    1.790063] IOMMU: Setting identity map for device 0000:00:1d.7 [0xbf7ec000 - 0xbf800000]
[    1.790282] IOMMU: Setting identity map for device 0000:00:1a.0 [0xbf7ec000 - 0xbf800000]
[    1.790486] IOMMU: Setting identity map for device 0000:00:1a.1 [0xbf7ec000 - 0xbf800000]
[    1.790684] IOMMU: Setting identity map for device 0000:00:1a.2 [0xbf7ec000 - 0xbf800000]
[    1.790887] IOMMU: Setting identity map for device 0000:00:1a.7 [0xbf7ec000 - 0xbf800000]
[    1.791069] IOMMU: Setting identity map for device 0000:00:1d.0 [0xec000 - 0xf0000]
[    1.791243] IOMMU: Setting identity map for device 0000:00:1d.1 [0xec000 - 0xf0000]
[    1.791402] IOMMU: Setting identity map for device 0000:00:1d.2 [0xec000 - 0xf0000]
[    1.791582] IOMMU: Setting identity map for device 0000:00:1d.7 [0xec000 - 0xf0000]
[    1.791771] IOMMU: Setting identity map for device 0000:00:1a.0 [0xec000 - 0xf0000]
[    1.791960] IOMMU: Setting identity map for device 0000:00:1a.1 [0xec000 - 0xf0000]
[    1.792150] IOMMU: Setting identity map for device 0000:00:1a.2 [0xec000 - 0xf0000]
[    1.792339] IOMMU: Setting identity map for device 0000:00:1a.7 [0xec000 - 0xf0000]
[    1.792520] IOMMU: Prepare 0-16MiB unity mapping for LPC
[    1.792664] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0x1000000]
[    1.792948] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
[    1.797045] microcode: CPU0 sig=0x106a5, pf=0x1, revision=0x11
[    1.797181] microcode: CPU1 sig=0x106a5, pf=0x1, revision=0x11
[    1.797336] microcode: CPU2 sig=0x106a5, pf=0x1, revision=0x11
[    1.797483] microcode: CPU3 sig=0x106a5, pf=0x1, revision=0x11
[    1.797640] microcode: CPU4 sig=0x106a5, pf=0x1, revision=0x11
[    1.797796] microcode: CPU5 sig=0x106a5, pf=0x1, revision=0x11
[    1.797926] microcode: CPU6 sig=0x106a5, pf=0x1, revision=0x11
[    1.798079] microcode: CPU7 sig=0x106a5, pf=0x1, revision=0x11
[    1.798225] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.798402] Scanning for low memory corruption every 60 seconds
[    1.798671] audit: initializing netlink socket (disabled)
[    1.798813] type=2000 audit(1278441808.533:1): initialized
[    1.830870] rcu-torture:--- Start of test: nreaders=16 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3
[    1.832717] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.835455] VFS: Disk quotas dquot_6.5.2
[    1.835681] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.837149] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.837683] Slow work thread pool: Starting up
[    1.837903] Slow work thread pool: Ready
[    1.838024] NTFS driver 2.1.29 [Flags: R/W].
[    1.838301] fuse init (API version 7.14)
[    1.838602] SGI XFS with ACLs, security attributes, large block/inode numbers, debug enabled
[    1.840286] SGI XFS Quota Management subsystem
[    1.840620] Btrfs loaded
[    1.840745] msgmni has been set to 32147
[    1.841747] alg: No test for stdrng (krng)
[    1.841891] async_tx: api initialized (async)
[    1.842724] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.842887] io scheduler noop registered
[    1.842994] io scheduler deadline registered
[    1.843183] io scheduler cfq registered (default)
[    1.843506] pcieport 0000:00:01.0: setting latency timer to 64
[    1.843663]   alloc irq_desc for 65 on node -1
[    1.843798]   alloc kstat_irqs on node -1
[    1.843924] alloc irq_2_iommu on node -1
[    1.844054] pcieport 0000:00:01.0: irq 65 for MSI/MSI-X
[    1.844259] pcieport 0000:00:03.0: setting latency timer to 64
[    1.844433]   alloc irq_desc for 66 on node -1
[    1.844571]   alloc kstat_irqs on node -1
[    1.844695] alloc irq_2_iommu on node -1
[    1.844836] pcieport 0000:00:03.0: irq 66 for MSI/MSI-X
[    1.845050] pcieport 0000:00:07.0: setting latency timer to 64
[    1.845210]   alloc irq_desc for 67 on node -1
[    1.845345]   alloc kstat_irqs on node -1
[    1.845472] alloc irq_2_iommu on node -1
[    1.845610] pcieport 0000:00:07.0: irq 67 for MSI/MSI-X
[    1.845821] pcieport 0000:00:08.0: setting latency timer to 64
[    1.846002]   alloc irq_desc for 68 on node -1
[    1.846125]   alloc kstat_irqs on node -1
[    1.846269] alloc irq_2_iommu on node -1
[    1.846407] pcieport 0000:00:08.0: irq 68 for MSI/MSI-X
[    1.846623] pcieport 0000:00:09.0: setting latency timer to 64
[    1.846788]   alloc irq_desc for 69 on node -1
[    1.846916]   alloc kstat_irqs on node -1
[    1.847043] alloc irq_2_iommu on node -1
[    1.847187] pcieport 0000:00:09.0: irq 69 for MSI/MSI-X
[    1.847404] pcieport 0000:00:0a.0: setting latency timer to 64
[    1.847578]   alloc irq_desc for 70 on node -1
[    1.847695]   alloc kstat_irqs on node -1
[    1.847811] alloc irq_2_iommu on node -1
[    1.847953] pcieport 0000:00:0a.0: irq 70 for MSI/MSI-X
[    1.848163] pcieport 0000:00:1c.0: setting latency timer to 64
[    1.848335]   alloc irq_desc for 71 on node -1
[    1.848470]   alloc kstat_irqs on node -1
[    1.848590] alloc irq_2_iommu on node -1
[    1.848735] pcieport 0000:00:1c.0: irq 71 for MSI/MSI-X
[    1.848982] pcieport 0000:00:1c.4: setting latency timer to 64
[    1.849120]   alloc irq_desc for 72 on node -1
[    1.849248]   alloc kstat_irqs on node -1
[    1.849399] alloc irq_2_iommu on node -1
[    1.849519] pcieport 0000:00:1c.4: irq 72 for MSI/MSI-X
[    1.849757] pcieport 0000:00:1c.5: setting latency timer to 64
[    1.849938]   alloc irq_desc for 73 on node -1
[    1.850073]   alloc kstat_irqs on node -1
[    1.850181] alloc irq_2_iommu on node -1
[    1.850314] pcieport 0000:00:1c.5: irq 73 for MSI/MSI-X
[    1.850571] aer 0000:00:01.0:pcie02: AER service couldn't init device: no _OSC support
[    1.850757] aer 0000:00:03.0:pcie02: AER service couldn't init device: no _OSC support
[    1.850933] aer 0000:00:07.0:pcie02: AER service couldn't init device: no _OSC support
[    1.851117] aer 0000:00:08.0:pcie02: AER service couldn't init device: no _OSC support
[    1.851294] aer 0000:00:09.0:pcie02: AER service couldn't init device: no _OSC support
[    1.851479] aer 0000:00:0a.0:pcie02: AER service couldn't init device: no _OSC support
[    1.851683] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.851942] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.852079] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver version: 0.1
[    1.852257] cpcihp_generic: not configured, disabling.
[    1.852423] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    1.852548] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.853430] vga16fb: initializing
[    1.853568] vga16fb: mapped to 0xffff8800000a0000
[    1.993407] Console: switching to colour frame buffer device 80x30
[    2.002680] fb0: VGA16 VGA frame buffer device
[    2.003100] intel_idle: MWAIT substates: 0x1120
[    2.003514] intel_idle: v0.4 model 0x1A
[    2.003924] intel_idle: lapic_timer_reliable_states 0x2
[    2.004551] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    2.013488] ACPI: Power Button [PWRB]
[    2.019112] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.031879] ACPI: Power Button [PWRF]
[    2.039863] ACPI: acpi_idle yielding to intel_idle
[    2.052366] ERST: Table is not found!
[    2.068636] GHES: HEST is not enabled!
[    2.079530] Non-volatile memory driver v1.3
[    2.089116] Linux agpgart interface v0.103
[    2.099122] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    2.122511] Hangcheck: Using getrawmonotonic().
[    2.122548] [drm] Initialized drm 1.1.0 20060810
[    2.122566] [drm] radeon defaulting to kernel modesetting.
[    2.122567] [drm] radeon kernel modesetting enabled.
[    2.122623]   alloc irq_desc for 30 on node -1
[    2.122625]   alloc kstat_irqs on node -1
[    2.122629] alloc irq_2_iommu on node -1
[    2.122636] radeon 0000:08:00.0: PCI INT A -> GSI 30 (level, low) -> IRQ 30
[    2.122641] radeon 0000:08:00.0: setting latency timer to 64
[    2.123945] [drm] initializing kernel modesetting (RV710 0x1002:0x954F).
[    2.175331] [drm] register mmio base: 0xFBBE0000
[    2.175333] [drm] register mmio size: 65536
[    2.175491] swapper:1 freeing invalid memtype d0000000-d0040000
[    2.175524] ATOM BIOS: 954F.11.22.6.0.AS03
[    2.175534] [drm] Clocks initialized !
[    2.175560] radeon 0000:08:00.0: VRAM: 1024M 0x00000000 - 0x3FFFFFFF (1024M used)
[    2.175562] radeon 0000:08:00.0: GTT: 512M 0x40000000 - 0x5FFFFFFF
[    2.175578] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[    2.175580] [drm] Detected VRAM RAM=1024M, BAR=256M
[    2.175582] [drm] RAM width 64bits DDR
[    2.175674] [TTM] Zone  kernel: Available graphics memory: 8229740 kiB.
[    2.175676] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[    2.175678] [TTM] Initializing pool allocator.
[    2.175696] [drm] radeon: 1024M of VRAM memory ready
[    2.175697] [drm] radeon: 512M of GTT memory ready.
[    2.175749]   alloc irq_desc for 74 on node -1
[    2.175750]   alloc kstat_irqs on node -1
[    2.175754] alloc irq_2_iommu on node -1
[    2.175765] radeon 0000:08:00.0: irq 74 for MSI/MSI-X
[    2.175771] [drm] radeon: using MSI.
[    2.175803] [drm] radeon: irq initialized.
[    2.175805] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    2.176298] [drm] Loading RV710 Microcode
[    2.306748] swapper:1 freeing invalid memtype d0140000-d0141000
[    2.353728] [drm] ring test succeeded in 1 usecs
[    2.354116] [drm] radeon: ib pool ready.
[    2.354238] [drm] ib test succeeded in 0 usecs
[    2.354240] [drm] Enabling audio support
[    2.354319] [drm] Default TV standard: PAL
[    2.354365] [drm] Default TV standard: PAL
[    2.354415] [drm] Radeon Display Connectors
[    2.354416] [drm] Connector 0:
[    2.354417] [drm]   HDMI-A
[    2.354418] [drm]   HPD1
[    2.354420] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[    2.354421] [drm]   Encoders:
[    2.354422] [drm]     DFP1: INTERNAL_UNIPHY
[    2.354423] [drm] Connector 1:
[    2.354424] [drm]   VGA
[    2.354425] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[    2.354427] [drm]   Encoders:
[    2.354428] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
[    2.354429] [drm] Connector 2:
[    2.354430] [drm]   DVI-I
[    2.354430] [drm]   HPD4
[    2.354432] [drm]   DDC: 0x7f10 0x7f10 0x7f14 0x7f14 0x7f18 0x7f18 0x7f1c 0x7f1c
[    2.354433] [drm]   Encoders:
[    2.354434] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    2.354435] [drm]     DFP2: INTERNAL_UNIPHY2
[    2.412413] [drm] Internal thermal controller without fan control
[    2.412426] [drm] radeon: power management initialized
[    3.230292] [drm] fb mappable at 0xD0141000
[    3.246381] [drm] vram apper at 0xD0000000
[    3.262622] [drm] size 16384000
[    3.278975] [drm] fb depth is 24
[    3.295226] [drm]    pitch is 10240
[    3.312085] checking generic (a0000 10000) vs hw (d0000000 40000000)
[    3.329752] fb: conflicting fb hw usage radeondrmfb vs VGA16 VGA - removing generic driver
[    3.385022] Console: switching to colour VGA+ 80x25
[    4.608981] Console: switching to colour frame buffer device 320x100
[    4.619102] fb0: radeondrmfb frame buffer device
[    4.619103] drm: registered panic notifier
[    4.619166] [drm] Initialized radeon 2.5.0 20080528 for 0000:08:00.0 on minor 0
[    4.619229] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
[    4.619268] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.619423] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.619568] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    4.619898] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.620082] 00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    4.621796] brd: module loaded
[    4.622552] loop: module loaded
[    4.623099] Loading iSCSI transport class v2.0-870.
[    4.623298] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    4.623360] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    4.623422] megasas: 00.00.04.17.1-rc1 Thu. Oct. 29, 11:41:51 PST 2009
[    4.623489] mpt2sas version 05.100.00.02 loaded
[    4.623697] ata_piix 0000:00:1f.2: version 2.13
[    4.623747]   alloc irq_desc for 19 on node -1
[    4.623774]   alloc kstat_irqs on node -1
[    4.623798] alloc irq_2_iommu on node -1
[    4.623825] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    4.623871] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    4.623993] ata_piix 0000:00:1f.2: setting latency timer to 64
[    4.624148] scsi0 : ata_piix
[    4.624277] scsi1 : ata_piix
[    4.626249] ata1: SATA max UDMA/133 cmd 0x8c00 ctl 0x8880 bmdma 0x8400 irq 19
[    4.626292] ata2: SATA max UDMA/133 cmd 0x8800 ctl 0x8480 bmdma 0x8408 irq 19
[    4.626358] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    4.626398] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    4.626515] ata_piix 0000:00:1f.5: setting latency timer to 64
[    4.626644] scsi2 : ata_piix
[    4.626743] scsi3 : ata_piix
[    4.628497] ata3: SATA max UDMA/133 cmd 0x9c00 ctl 0x9880 bmdma 0x9400 irq 19
[    4.628539] ata4: SATA max UDMA/133 cmd 0x9800 ctl 0x9480 bmdma 0x9408 irq 19
[    4.628977] Fixed MDIO Bus: probed
[    4.629031] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k4
[    4.629061] e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
[    4.629207] e1000e 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.629279] e1000e 0000:03:00.0: setting latency timer to 64
[    4.629857]   alloc irq_desc for 75 on node -1
[    4.629882]   alloc kstat_irqs on node -1
[    4.629905] alloc irq_2_iommu on node -1
[    4.629931] e1000e 0000:03:00.0: irq 75 for MSI/MSI-X
[    4.629957]   alloc irq_desc for 76 on node -1
[    4.629980]   alloc kstat_irqs on node -1
[    4.630002] alloc irq_2_iommu on node -1
[    4.630027] e1000e 0000:03:00.0: irq 76 for MSI/MSI-X
[    4.630053]   alloc irq_desc for 77 on node -1
[    4.630076]   alloc kstat_irqs on node -1
[    4.630098] alloc irq_2_iommu on node -1
[    4.630123] e1000e 0000:03:00.0: irq 77 for MSI/MSI-X
[    4.630419] e1000e 0000:03:00.0: Disabling ASPM L0s 
[    4.736755] e1000e 0000:03:00.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:e0:81:b8:df:4a
[    4.736795] e1000e 0000:03:00.0: eth0: Intel(R) PRO/1000 Network Connection
[    4.736932] e1000e 0000:03:00.0: eth0: MAC: 3, PHY: 8, PBA No: ffffff-0ff
[    4.737006] e1000e 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    4.737080] e1000e 0000:02:00.0: setting latency timer to 64
[    4.737638]   alloc irq_desc for 78 on node -1
[    4.737663]   alloc kstat_irqs on node -1
[    4.737686] alloc irq_2_iommu on node -1
[    4.737711] e1000e 0000:02:00.0: irq 78 for MSI/MSI-X
[    4.737737]   alloc irq_desc for 79 on node -1
[    4.737761]   alloc kstat_irqs on node -1
[    4.737782] alloc irq_2_iommu on node -1
[    4.737807] e1000e 0000:02:00.0: irq 79 for MSI/MSI-X
[    4.737833]   alloc irq_desc for 80 on node -1
[    4.737857]   alloc kstat_irqs on node -1
[    4.737878] alloc irq_2_iommu on node -1
[    4.737903] e1000e 0000:02:00.0: irq 80 for MSI/MSI-X
[    4.738540] e1000e 0000:02:00.0: Disabling ASPM L0s 
[    4.848355] e1000e 0000:02:00.0: eth1: (PCI Express:2.5GB/s:Width x1) 00:e0:81:b8:df:4b
[    4.848395] e1000e 0000:02:00.0: eth1: Intel(R) PRO/1000 Network Connection
[    4.848531] e1000e 0000:02:00.0: eth1: MAC: 3, PHY: 8, PBA No: ffffff-0ff
[    4.848583] PPP generic driver version 2.4.2
[    4.849001] tun: Universal TUN/TAP device driver, 1.6
[    4.850793] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.852666] netconsole: local port 4444
[    4.854509] netconsole: local IP 192.168.224.176
[    4.856350] netconsole: interface 'eth0'
[    4.858213] netconsole: remote port 4444
[    4.860072] netconsole: remote IP 192.168.224.0
[    4.861958] netconsole: remote ethernet address 00:21:86:60:5d:d6
[    4.863851] netconsole: device eth0 not up yet, forcing it
[    4.962526] ata4: SATA link down (SStatus 0 SControl 300)
[    5.097327] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.104124] ata3.00: ATAPI: ATAPI   iHAS324   A, BL1P, max UDMA/100
[    5.117396] ata3.00: configured for UDMA/100
[    5.420143] ata1.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.422254] ata1.01: SATA link down (SStatus 0 SControl 300)
[    5.426821] ata2.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.428974] ata2.01: SATA link down (SStatus 0 SControl 300)
[    5.432407] ata1.00: ATA-7: Maxtor 6V320F0, VA111900, max UDMA/133
[    5.434611] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    5.441219] ata2.00: ATA-7: Maxtor 6V320F0, VA111900, max UDMA/133
[    5.443440] ata2.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    5.451196] ata1.00: configured for UDMA/133
[    5.453545] scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6V320F0   VA11 PQ: 0 ANSI: 5
[    5.455965] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.455996] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    5.456057] sd 0:0:0:0: [sda] Write Protect is off
[    5.456059] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.456085] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.456266]  sda:
[    5.457820] ata2.00: configured for UDMA/133
[    5.471765] scsi 1:0:0:0: Direct-Access     ATA      Maxtor 6V320F0   VA11 PQ: 0 ANSI: 5
[    5.474258] sd 1:0:0:0: [sdb] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    5.474286] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    5.475361] scsi 2:0:0:0: CD-ROM            ATAPI    iHAS324   A      BL1P PQ: 0 ANSI: 5
[    5.477335]  sda1 sda2
[    5.481378] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    5.481381] Uniform CD-ROM driver Revision: 3.20
[    5.481560] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    5.481622] sr 2:0:0:0: Attached scsi generic sg2 type 5
[    5.492817] sd 1:0:0:0: [sdb] Write Protect is off
[    5.492933] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.497482] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    5.499814] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.502294]  sdb: sdb1 sdb2
[    5.523356] sd 1:0:0:0: [sdb] Attached SCSI disk
[    8.930853] netconsole: timeout waiting for carrier
[    9.258330] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   11.019071] console [netcon0] enabled
[   11.021404] netconsole: network logging started
[   11.023767] Fusion MPT base driver 3.04.15
[   11.026160] Copyright (c) 1999-2008 LSI Corporation
[   11.028555] Fusion MPT SPI Host driver 3.04.15
[   11.030967] Fusion MPT FC Host driver 3.04.15
[   11.033367] Fusion MPT SAS Host driver 3.04.15
[   11.035770]   alloc irq_desc for 28 on node -1
[   11.038112]   alloc kstat_irqs on node -1
[   11.040450] alloc irq_2_iommu on node -1
[   11.042786] mptsas 0000:0a:00.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
[   11.045259] mptbase: ioc0: Initiating bringup
[   11.652986] ioc0: LSISAS1068E B3: Capabilities={Initiator}
[   11.655418] mptsas 0000:0a:00.0: setting latency timer to 64
[   22.488088] scsi4 : ioc0: LSISAS1068E B3, FwRev=011a0000h, Ports=1, MaxQ=266, IRQ=28
[   22.529147] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 9, phy 0, sas_addr 0x816f9b3796d4dac1
[   22.534647] scsi 4:0:0:0: Direct-Access     ATA      Hitachi HDS72202 A20N PQ: 0 ANSI: 5
[   22.538646] sd 4:0:0:0: Attached scsi generic sg3 type 0
[   22.541398] sd 4:0:0:0: [sdc] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   22.544564] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 13, phy 1, sas_addr 0x816f9b40abd2efc1
[   22.550280] scsi 4:0:1:0: Direct-Access     ATA      Hitachi HDS72202 A20N PQ: 0 ANSI: 5
[   22.554295] sd 4:0:1:0: Attached scsi generic sg4 type 0
[   22.557170] sd 4:0:1:0: [sdd] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   22.560418] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 8, phy 2, sas_addr 0x816f9b4881d8f4c1
[   22.566184] scsi 4:0:2:0: Direct-Access     ATA      Hitachi HDS72202 A20N PQ: 0 ANSI: 5
[   22.570362] sd 4:0:2:0: Attached scsi generic sg5 type 0
[   22.573296] sd 4:0:2:0: [sde] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   22.576632] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 11, phy 3, sas_addr 0x816f9b45a1b6e8c1
[   22.582490] scsi 4:0:3:0: Direct-Access     ATA      Hitachi HDS72202 A20N PQ: 0 ANSI: 5
[   22.586677] sd 4:0:3:0: Attached scsi generic sg6 type 0
[   22.589700] sd 4:0:3:0: [sdf] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   22.593112] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 10, phy 4, sas_addr 0x816f9b4598b701c2
[   22.599037] scsi 4:0:4:0: Direct-Access     ATA      Hitachi HDS72202 A20N PQ: 0 ANSI: 5
[   22.603344] sd 4:0:4:0: Attached scsi generic sg7 type 0
[   22.606452] sd 4:0:4:0: [sdg] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   22.609954] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 14, phy 5, sas_addr 0x816f9b40a7c1dec1
[   22.616011] scsi 4:0:5:0: Direct-Access     ATA      Hitachi HDS72202 A20N PQ: 0 ANSI: 5
[   22.620356] sd 4:0:5:0: Attached scsi generic sg8 type 0
[   22.623536] sd 4:0:5:0: [sdh] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   22.627133] Fusion MPT misc device (ioctl) driver 3.04.15
[   22.630080] mptctl: Registered with Fusion MPT base driver
[   22.632924] mptctl: /dev/mptctl @ (major,minor=10,220)
[   22.635774] Fusion MPT LAN driver 3.04.15
[   22.638613] mptlan: ioc0: PortNum=0, ProtocolFlags=09h (ItlB)
[   22.641434] mptlan: ioc0: Hmmm... LAN protocol seems to be disabled on this adapter port!
[   22.644335] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   22.647235]   alloc irq_desc for 18 on node -1
[   22.650075]   alloc kstat_irqs on node -1
[   22.652929] alloc irq_2_iommu on node -1
[   22.655776] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   22.658665] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[   22.661530] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[   22.664444] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[   22.667402] ehci_hcd 0000:00:1a.7: debug port 1
[   22.674212] ehci_hcd 0000:00:1a.7: cache line size of 256 is not supported
[   22.677153] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfb8f6000
[   22.691275] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   22.694332] hub 1-0:1.0: USB hub found
[   22.697284] hub 1-0:1.0: 6 ports detected
[   22.700367]   alloc irq_desc for 23 on node -1
[   22.703280]   alloc kstat_irqs on node -1
[   22.706209] alloc irq_2_iommu on node -1
[   22.709118] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   22.712082] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   22.715014] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   22.717989] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[   22.720964] ehci_hcd 0000:00:1d.7: debug port 1
[   22.727798] ehci_hcd 0000:00:1d.7: cache line size of 256 is not supported
[   22.730759] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfb8f8000
[   22.744518] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   22.747576] hub 2-0:1.0: USB hub found
[   22.750425] hub 2-0:1.0: 6 ports detected
[   22.753394] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   22.756265] uhci_hcd: USB Universal Host Controller Interface driver
[   22.759156] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   22.762001] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[   22.764817] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   22.767663] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[   22.770537] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00007400
[   22.773499] hub 3-0:1.0: USB hub found
[   22.776295] hub 3-0:1.0: 2 ports detected
[   22.779173]   alloc irq_desc for 21 on node -1
[   22.781909]   alloc kstat_irqs on node -1
[   22.784640] alloc irq_2_iommu on node -1
[   22.787337] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[   22.790093] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[   22.792842] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   22.795647] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[   22.798514] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00007480
[   22.801441] hub 4-0:1.0: USB hub found
[   22.804179] hub 4-0:1.0: 2 ports detected
[   22.807013] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[   22.809768] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[   22.812505] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   22.815264] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[   22.818016] uhci_hcd 0000:00:1a.2: irq 19, io base 0x00007800
[   22.820909] hub 5-0:1.0: USB hub found
[   22.823655] hub 5-0:1.0: 2 ports detected
[   22.823658] sd 4:0:0:0: [sdc] Write Protect is off
[   22.823661] sd 4:0:0:0: [sdc] Mode Sense: 73 00 00 08
[   22.831955] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   22.834727] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   22.834730] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   22.842421] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   22.844398] sd 4:0:1:0: [sdd] Write Protect is off
[   22.844400] sd 4:0:1:0: [sdd] Mode Sense: 73 00 00 08
[   22.854046] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[   22.856833] sd 4:0:1:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   22.856878] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00007880
[   22.857106] hub 6-0:1.0: USB hub found
[   22.857112] hub 6-0:1.0: 2 ports detected
[   22.857250] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   22.857265] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   22.857273] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   22.857331] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[   22.857373] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00007c00
[   22.857586] hub 7-0:1.0: USB hub found
[   22.857593] hub 7-0:1.0: 2 ports detected
[   22.857747] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   22.857762] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   22.857770] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   22.857827] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[   22.857868] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00008000
[   22.858085] hub 8-0:1.0: USB hub found
[   22.858091] hub 8-0:1.0: 2 ports detected
[   22.858233] Initializing USB Mass Storage driver...
[   22.858299] usbcore: registered new interface driver usb-storage
[   22.858301] USB Mass Storage support registered.
[   22.858368] usbcore: registered new interface driver libusual
[   22.858460] PNP: No PS/2 controller found. Probing ports directly.
[   22.861518] sd 4:0:2:0: [sde] Write Protect is off
[   22.861521] sd 4:0:2:0: [sde] Mode Sense: 73 00 00 08
[   22.861593] serio: i8042 KBD port at 0x60,0x64 irq 1
[   22.861601] serio: i8042 AUX port at 0x60,0x64 irq 12
[   22.861746] mice: PS/2 mouse device common for all mice
[   22.861912] rtc_cmos 00:03: RTC can wake from S4
[   22.861963] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[   22.862000] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[   22.862194] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   22.864380] sd 4:0:2:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   22.873694] sd 4:0:3:0: [sdf] Write Protect is off
[   22.873696] sd 4:0:3:0: [sdf] Mode Sense: 73 00 00 08
[   22.876417] sd 4:0:3:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   22.895507] sd 4:0:4:0: [sdg] Write Protect is off
[   22.895510] sd 4:0:4:0: [sdg] Mode Sense: 73 00 00 08
[   22.898240] sd 4:0:4:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   22.913297] sd 4:0:5:0: [sdh] Write Protect is off
[   22.913299] sd 4:0:5:0: [sdh] Mode Sense: 73 00 00 08
[   22.916036] sd 4:0:5:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   23.132970]  sdc:
[   23.138764]  sde: unknown partition table
[   23.151807]  sdf: unknown partition table
[   23.163974]  unknown partition table
[   23.172779]  sdg: unknown partition table
[   23.191588]  sdh: unknown partition table
[   23.207142] w83793 3-002f: Registered watchdog chardev major 10, minor: 130
[   23.217075] usb 2-5: new high speed USB device using ehci_hcd and address 4
[   23.241016]  sdd: unknown partition table
[   23.345278] hub 2-5:1.0: USB hub found
[   23.347891] hub 2-5:1.0: 3 ports detected
[   23.432459] sd 4:0:0:0: [sdc] Attached SCSI disk
[   23.446596] sd 4:0:2:0: [sde] Attached SCSI disk
[   23.451827] sd 4:0:3:0: [sdf] Attached SCSI disk
[   23.472293] sd 4:0:4:0: [sdg] Attached SCSI disk
[   23.490086] sd 4:0:5:0: [sdh] Attached SCSI disk
[   23.540514] sd 4:0:1:0: [sdd] Attached SCSI disk
[   23.580084] usb 3-2: new low speed USB device using uhci_hcd and address 2
[   23.762840] i2c i2c-3: detect fail: unknown manuf, 0x71
[   23.776144] i2c i2c-3: detect fail: address match, 0x2e
[   23.869343] usb 6-1: new low speed USB device using uhci_hcd and address 2
[   23.975879] coretemp coretemp.0: TjMax is 97 C.
[   23.978331] coretemp coretemp.1: TjMax is 97 C.
[   23.980790] coretemp coretemp.2: TjMax is 97 C.
[   23.983221] coretemp coretemp.3: TjMax is 97 C.
[   23.985594] coretemp coretemp.4: TjMax is 97 C.
[   23.988008] coretemp coretemp.5: TjMax is 97 C.
[   23.990418] coretemp coretemp.6: TjMax is 97 C.
[   23.992800] coretemp coretemp.7: TjMax is 97 C.
[   24.218860] lis3lv02d driver loaded.
[   24.275330] usb 7-1: new full speed USB device using uhci_hcd and address 2
[   24.495114] usb 2-5.1: new high speed USB device using ehci_hcd and address 5
[   25.376827] pc87360: PC8736x not detected, module not inserted.
[   25.576578] via_cputemp: Not a VIA CPU
[   25.579129] w83627ehf: Forcibly enabling Super-I/O. Sensor is probably unusable.
[   25.581460] w83627ehf: Found W83627DHG-P chip at 0xa10
[   25.584203] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[   25.586624] iTCO_wdt: unable to reset NO_REBOOT flag, platform may have disabled it
[   25.588979] iTCO_vendor_support: vendor-support=0
[   25.591342] SoftDog: cannot register miscdev on minor=130 (err=-16)
[   25.593688] md: linear personality registered for level -1
[   25.596003] md: raid0 personality registered for level 0
[   25.598336] md: raid1 personality registered for level 1
[   25.600666] md: raid10 personality registered for level 10
[   25.602975] md: raid6 personality registered for level 6
[   25.605310] md: raid5 personality registered for level 5
[   25.607620] md: raid4 personality registered for level 4
[   25.609908] md: multipath personality registered for level -4
[   25.612181] md: faulty personality registered for level -5
[   25.614586] device-mapper: uevent: version 1.0.3
[   25.616969] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
[   25.619983] device-mapper: multipath: version 1.1.1 loaded
[   25.622241] device-mapper: multipath round-robin: version 1.0.0 loaded
[   25.624515] device-mapper: multipath queue-length: version 0.1.0 loaded
[   25.626771] device-mapper: multipath service-time: version 0.2.0 loaded
[   25.629130] device-mapper: dm-log-userspace: version 1.0.0 loaded
[   25.631369] EDAC MC: Ver: 2.1.0 Jul  5 2010
[   25.633998] PCI: Discovered peer bus fe
[   25.638412] EDAC MC0: Giving out device to 'i7core_edac.c' 'i7 core #0': DEV 0000:fe:03.0
[   25.640725] EDAC PCI0: Giving out device to module 'i7core_edac' controller 'EDAC PCI controller': DEV '0000:fe:03.0' (POLLED)
[   25.643030] EDAC i7core: Driver loaded.
[   25.646190] cpuidle: using governor ladder
[   25.649022] cpuidle: using governor menu
[   25.651318] ioatdma: Intel(R) QuickData Technology Driver 4.00
[   25.653678]   alloc irq_desc for 43 on node -1
[   25.655961]   alloc kstat_irqs on node -1
[   25.658274] alloc irq_2_iommu on node -1
[   25.660583] ioatdma 0000:00:16.0: PCI INT A -> GSI 43 (level, low) -> IRQ 43
[   25.663286] ioatdma 0000:00:16.0: setting latency timer to 64
[   25.665603]   alloc irq_desc for 81 on node -1
[   25.667947]   alloc kstat_irqs on node -1
[   25.670289] alloc irq_2_iommu on node -1
[   25.672585] ioatdma 0000:00:16.0: irq 81 for MSI/MSI-X
[   25.675435]   alloc irq_desc for 44 on node -1
[   25.677674]   alloc kstat_irqs on node -1
[   25.679945] alloc irq_2_iommu on node -1
[   25.682183] ioatdma 0000:00:16.1: PCI INT B -> GSI 44 (level, low) -> IRQ 44
[   25.684569] ioatdma 0000:00:16.1: setting latency timer to 64
[   25.686917]   alloc irq_desc for 82 on node -1
[   25.689198]   alloc kstat_irqs on node -1
[   25.691511] alloc irq_2_iommu on node -1
[   25.693828] ioatdma 0000:00:16.1: irq 82 for MSI/MSI-X
[   25.696610]   alloc irq_desc for 45 on node -1
[   25.698882]   alloc kstat_irqs on node -1
[   25.701175] alloc irq_2_iommu on node -1
[   25.703482] ioatdma 0000:00:16.2: PCI INT C -> GSI 45 (level, low) -> IRQ 45
[   25.705764] ioatdma 0000:00:16.2: setting latency timer to 64
[   25.708117]   alloc irq_desc for 83 on node -1
[   25.710373]   alloc kstat_irqs on node -1
[   25.712643] alloc irq_2_iommu on node -1
[   25.714934] ioatdma 0000:00:16.2: irq 83 for MSI/MSI-X
[   25.717660]   alloc irq_desc for 46 on node -1
[   25.719868]   alloc kstat_irqs on node -1
[   25.722113] alloc irq_2_iommu on node -1
[   25.724351] ioatdma 0000:00:16.3: PCI INT D -> GSI 46 (level, low) -> IRQ 46
[   25.726695] ioatdma 0000:00:16.3: setting latency timer to 64
[   25.728938]   alloc irq_desc for 84 on node -1
[   25.731158]   alloc kstat_irqs on node -1
[   25.733472] alloc irq_2_iommu on node -1
[   25.735713] ioatdma 0000:00:16.3: irq 84 for MSI/MSI-X
[   25.738459] ioatdma 0000:00:16.4: PCI INT A -> GSI 43 (level, low) -> IRQ 43
[   25.740781] ioatdma 0000:00:16.4: setting latency timer to 64
[   25.743088]   alloc irq_desc for 85 on node -1
[   25.745324]   alloc kstat_irqs on node -1
[   25.747589] alloc irq_2_iommu on node -1
[   25.749867] ioatdma 0000:00:16.4: irq 85 for MSI/MSI-X
[   25.752581] ioatdma 0000:00:16.5: PCI INT B -> GSI 44 (level, low) -> IRQ 44
[   25.754937] ioatdma 0000:00:16.5: setting latency timer to 64
[   25.757303]   alloc irq_desc for 86 on node -1
[   25.759605]   alloc kstat_irqs on node -1
[   25.761953] alloc irq_2_iommu on node -1
[   25.764308] ioatdma 0000:00:16.5: irq 86 for MSI/MSI-X
[   25.767133] ioatdma 0000:00:16.6: PCI INT C -> GSI 45 (level, low) -> IRQ 45
[   25.769487] ioatdma 0000:00:16.6: setting latency timer to 64
[   25.771884]   alloc irq_desc for 87 on node -1
[   25.774211]   alloc kstat_irqs on node -1
[   25.776557] alloc irq_2_iommu on node -1
[   25.778887] ioatdma 0000:00:16.6: irq 87 for MSI/MSI-X
[   25.781708] ioatdma 0000:00:16.7: PCI INT D -> GSI 46 (level, low) -> IRQ 46
[   25.784138] ioatdma 0000:00:16.7: setting latency timer to 64
[   25.786587]   alloc irq_desc for 88 on node -1
[   25.788977]   alloc kstat_irqs on node -1
[   25.791469] alloc irq_2_iommu on node -1
[   25.793906] ioatdma 0000:00:16.7: irq 88 for MSI/MSI-X
[   25.794820] usbcore: registered new interface driver hiddev
[   25.809647] input: Lite-On Technology Corp. ThinkPad USB Keyboard with TrackPoint as /devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2:1.0/input/input2
[   25.812184] generic-usb 0003:17EF:6009.0001: input,hidraw0: USB HID v1.10 Keyboard [Lite-On Technology Corp. ThinkPad USB Keyboard with TrackPoint] on usb-0000:00:1a.0-2/input0
[   25.858468] input: Lite-On Technology Corp. ThinkPad USB Keyboard with TrackPoint as /devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2:1.1/input/input3
[   25.861242] generic-usb 0003:17EF:6009.0002: input,hiddev96,hidraw1: USB HID v1.10 Mouse [Lite-On Technology Corp. ThinkPad USB Keyboard with TrackPoint] on usb-0000:00:1a.0-2/input1
[   25.879193] input: Microsoft Microsoft 3-Button Mouse with IntelliEye(TM) as /devices/pci0000:00/0000:00:1d.0/usb6/6-1/6-1:1.0/input/input4
[   25.881966] generic-usb 0003:045E:0040.0003: input,hidraw2: USB HID v1.10 Mouse [Microsoft Microsoft 3-Button Mouse with IntelliEye(TM)] on usb-0000:00:1d.0-1/input0
[   25.890591] input: HID 041e:30d3 as /devices/pci0000:00/0000:00:1d.1/usb7/7-1/7-1:1.3/input/input5
[   25.893439] generic-usb 0003:041E:30D3.0004: input,hidraw3: USB HID v1.00 Device [HID 041e:30d3] on usb-0000:00:1d.1-1/input3
[   25.896976] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1:1.0/input/input6
[   25.899876] generic-usb 0003:046B:FF10.0005: input,hidraw4: USB HID v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1d.7-5.1/input0
[   25.903580] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1:1.1/input/input7
[   25.906597] generic-usb 0003:046B:FF10.0006: input,hidraw5: USB HID v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1d.7-5.1/input1
[   25.909594] usbcore: registered new interface driver usbhid
[   25.912466] usbhid: USB HID core driver
[   25.992819] usbcore: registered new interface driver snd-usb-audio
[   25.995657] ALSA device list:
[   25.998568]   #0: USB Device 0x41e:0x30d3 at usb-0000:00:1d.1-1, full speed
[   26.001484] oprofile: using NMI interrupt.
[   26.005036] TCP cubic registered
[   26.007959] Initializing XFRM netlink socket
[   26.011047] NET: Registered protocol family 10
[   26.014765] lo: Disabled Privacy Extensions
[   26.019792] NET: Registered protocol family 17
[   26.022795] NET: Registered protocol family 15
[   26.025840] Bridge firewalling registered
[   26.478392] ------------[ cut here ]------------
[   26.478435] ------------[ cut here ]------------
[   26.478443] WARNING: at /home/andres/src/kernel/arch/x86/include/asm/processor.h:1005 read_measured_perf_ctrs+0x5f/0x70()
[   26.478445] Hardware name: empty
[   26.478446] Modules linked in:
[   26.478448] Pid: 73, comm: kondemand/1 Not tainted 2.6.35-rc4-andres #9
[   26.478450] Call Trace:
[   26.478455]  [<ffffffff8108049f>] warn_slowpath_common+0x7f/0xc0
[   26.478458]  [<ffffffff8104f8b0>] ? read_measured_perf_ctrs+0x0/0x70
[   26.478461]  [<ffffffff810804fa>] warn_slowpath_null+0x1a/0x20
[   26.478464]  [<ffffffff8104f90f>] read_measured_perf_ctrs+0x5f/0x70
[   26.478468]  [<ffffffff810bfa59>] smp_call_function_single+0x89/0x170
[   26.478472]  [<ffffffff81a65870>] ? _raw_spin_unlock_irqrestore+0x40/0x60
[   26.478475]  [<ffffffff8104f83c>] cpufreq_get_measured_perf+0x2c/0xa0
[   26.478479]  [<ffffffff8188d6d8>] __cpufreq_driver_getavg+0x78/0x80
[   26.478482]  [<ffffffff818904c7>] do_dbs_timer+0xf7/0x390
[   26.478484]  [<ffffffff818903d0>] ? do_dbs_timer+0x0/0x390
[   26.478488]  [<ffffffff8109b46a>] worker_thread+0x21a/0x400
[   26.478491]  [<ffffffff8109b419>] ? worker_thread+0x1c9/0x400
[   26.478494]  [<ffffffff810a0630>] ? autoremove_wake_function+0x0/0x40
[   26.478497]  [<ffffffff8109b250>] ? worker_thread+0x0/0x400
[   26.478499]  [<ffffffff810a00c6>] kthread+0xb6/0xc0
[   26.478502]  [<ffffffff810b4859>] ? trace_hardirqs_on_caller+0x29/0x1a0
[   26.478507]  [<ffffffff81036ed4>] kernel_thread_helper+0x4/0x10
[   26.478509]  [<ffffffff81a65820>] ? _raw_spin_unlock_irq+0x30/0x40
[   26.478511]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[   26.478514]  [<ffffffff81a65bfc>] ? restore_args+0x0/0x30
[   26.478516]  [<ffffffff810a0010>] ? kthread+0x0/0xc0
[   26.478518]  [<ffffffff81036ed0>] ? kernel_thread_helper+0x0/0x10
[   26.478524] ---[ end trace 4e7410f12ebff241 ]---
[   26.562982] WARNING: at /home/andres/src/kernel/arch/x86/include/asm/processor.h:1005 read_measured_perf_ctrs+0x5f/0x70()
[   26.565765] Hardware name: empty
[   26.568532] Modules linked in:
[   26.571302] Pid: 72, comm: kondemand/0 Tainted: G        W   2.6.35-rc4-andres #9
[   26.574103] Call Trace:
[   26.576893]  [<ffffffff8108049f>] warn_slowpath_common+0x7f/0xc0
[   26.579693]  [<ffffffff8104f8b0>] ? read_measured_perf_ctrs+0x0/0x70
[   26.582503]  [<ffffffff810804fa>] warn_slowpath_null+0x1a/0x20
[   26.585316]  [<ffffffff8104f90f>] read_measured_perf_ctrs+0x5f/0x70
[   26.588114]  [<ffffffff810bfa59>] smp_call_function_single+0x89/0x170
[   26.590910]  [<ffffffff81a65870>] ? _raw_spin_unlock_irqrestore+0x40/0x60
[   26.593703]  [<ffffffff8104f83c>] cpufreq_get_measured_perf+0x2c/0xa0
[   26.596501]  [<ffffffff8188d6d8>] __cpufreq_driver_getavg+0x78/0x80
[   26.599304]  [<ffffffff818904c7>] do_dbs_timer+0xf7/0x390
[   26.602100]  [<ffffffff818903d0>] ? do_dbs_timer+0x0/0x390
[   26.604886]  [<ffffffff8109b46a>] worker_thread+0x21a/0x400
[   26.607665]  [<ffffffff8109b419>] ? worker_thread+0x1c9/0x400
[   26.610428]  [<ffffffff810a0630>] ? autoremove_wake_function+0x0/0x40
[   26.613193]  [<ffffffff8109b250>] ? worker_thread+0x0/0x400
[   26.615961]  [<ffffffff810a00c6>] kthread+0xb6/0xc0
[   26.618719]  [<ffffffff810b4859>] ? trace_hardirqs_on_caller+0x29/0x1a0
[   26.621480]  [<ffffffff81036ed4>] kernel_thread_helper+0x4/0x10
[   26.624230]  [<ffffffff81a65820>] ? _raw_spin_unlock_irq+0x30/0x40
[   26.626971]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[   26.629709]  [<ffffffff81a65bfc>] ? restore_args+0x0/0x30
[   26.632448]  [<ffffffff810a0010>] ? kthread+0x0/0xc0
[   26.635174]  [<ffffffff81036ed0>] ? kernel_thread_helper+0x0/0x10
[   26.637895] ---[ end trace 4e7410f12ebff242 ]---
[   26.642764] PM: Resume from disk failed.
[   26.646339] registered taskstats version 1
[   26.651292]   Magic number: 2:51:746
[   26.655477] rtc_cmos 00:03: setting system clock to 2010-07-06 18:43:54 UTC (1278441834)
[   26.659093] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   26.662687] EDD information not available.
[   26.666853] Freeing unused kernel memory: 2648k freed
[   26.669966] Write protecting the kernel read-only data: 18432k
[   26.674304] Freeing unused kernel memory: 1576k freed
[   26.678008] Freeing unused kernel memory: 1396k freed
[   26.710724] udev: starting version 151
[   26.793101] md: bind<sde>
[   26.917909] md: bind<sdb1>
[   26.926331] md: bind<sda2>
[   26.993395] md: bind<sdh>
[   27.001135] md: bind<sdg>
[   27.118957] md: bind<sda1>
[   27.126596] md/raid1:md0: active with 2 out of 2 mirrors
[   27.138374] md0: bitmap initialized from disk: read 15/15 pages, set 0 bits
[   27.141391] created bitmap (239 pages) for device md0
[   27.169206] md0: detected capacity change from 0 to 1998520320
[   27.173656] md: bind<sdb2>
[   27.174492]  md0: unknown partition table
[   27.187030] md/raid1:md1: active with 2 out of 2 mirrors
[   27.195869] md1: bitmap initialized from disk: read 9/9 pages, set 31 bits
[   27.198835] created bitmap (140 pages) for device md1
[   27.229274] md1: detected capacity change from 0 to 149999779840
[   27.233938] md: bind<sdd>
[   27.234299]  md1: unknown partition table
[   27.400318] md: bind<sdc>
[   27.426475] EXT4-fs (md1): mounted filesystem with ordered data mode. Opts: (null)
[   29.573272] udev: starting version 151
[   29.768037] EXT4-fs (md1): re-mounted. Opts: errors=remount-ro
[   30.626948] udisks-part-id:834 freeing invalid memtype 9e000-a0000
[   31.092430] md: bind<sdf>
[   31.115547] md/raid10:md3: not clean -- starting background reconstruction
[   31.115550] md/raid10:md3: active with 6 out of 6 devices
[   31.116107] md3: bitmap initialized from disk: read 1/1 pages, set 6 bits
[   31.116109] created bitmap (11 pages) for device md3
[   31.133703] md3: detected capacity change from 0 to 6001196335104
[   31.133985] md: resync of RAID array md3
[   31.133990] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[   31.133993] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
[   31.134008] md: using 128k window, over a total of 5860543296 blocks.
[   31.135665]  md3: unknown partition table
[   32.362274] device fsid 734d2229ef3a6499-bf78c322745d7aa4 devid 1 transid 2696 /dev/mapper/data-backup
[   34.073528] EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts: (null)
[  333.797609] INFO: rcu_sched_state detected stalls on CPUs/tasks: { 5 7} (detected by 2, t=88843 jiffies)
[  333.797765] sending NMI to all CPUs:
[  333.797772] NMI backtrace for cpu 0
[  333.797775] CPU 0 
[  333.797777] Modules linked in:
[  333.797780] 
[  333.797784] Pid: 0, comm: swapper Tainted: G        W   2.6.35-rc4-andres #9 S7002/empty
[  333.797787] RIP: 0010:[<ffffffff81090884>]  [<ffffffff81090884>] run_timer_softirq+0xb4/0x420
[  333.797796] RSP: 0018:ffff880003203df0  EFLAGS: 00000016
[  333.797799] RAX: 00000001000027f2 RBX: ffffffff826593c0 RCX: ffff880003203db0
[  333.797802] RDX: 00000000fffedd2f RSI: ffff880003203db0 RDI: ffffffff826593c0
[  333.797805] RBP: ffff880003203ec0 R08: 0000000000000002 R09: 0000000000000001
[  333.797808] R10: 0000000000000000 R11: 0000000000000046 R12: ffff880003203e80
[  333.797811] R13: ffff880003203e80 R14: 0000000000000100 R15: ffffffff82201fd8
[  333.797814] FS:  0000000000000000(0000) GS:ffff880003200000(0000) knlGS:0000000000000000
[  333.797818] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  333.797820] CR2: 00007ffe1f836315 CR3: 000000042a343000 CR4: 00000000000006f0
[  333.797823] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  333.797826] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  333.797830] Process swapper (pid: 0, threadinfo ffffffff82200000, task ffffffff82211020)
[  333.797832] Stack:
[  333.797858]  ffffffff8109090e 0000004dc95053ff 0000004dc91e5596 0000004dc95053ff
[  333.797864] <0> ffffffff8265b018 ffffffff8265ac18 ffffffff8265a818 ffffffff82201fd8
[  333.797869] <0> ffffffff82201fd8 ffffffff822f9cc8 ffffffff8109c060 ffffffff8265a418
[  333.797876] Call Trace:
[  333.797902]  <IRQ> 
[  333.797934]  [<ffffffff8109090e>] ? run_timer_softirq+0x13e/0x420
[  333.797941]  [<ffffffff8109c060>] ? delayed_work_timer_fn+0x0/0x50
[  333.797946]  [<ffffffff81087f2a>] __do_softirq+0xca/0x270
[  333.797953]  [<ffffffff81036fcc>] call_softirq+0x1c/0x50
[  333.797957]  [<ffffffff8103888d>] do_softirq+0x7d/0xb0
[  333.797961]  [<ffffffff81087a55>] irq_exit+0x95/0xa0
[  333.797967]  [<ffffffff81a6ccb5>] do_IRQ+0x75/0xf0
[  333.797971]  [<ffffffff81a65b53>] ret_from_intr+0x0/0xf
[  333.797974]  <EOI> 
[  333.798009]  [<ffffffff8150a547>] ? intel_idle+0xf7/0x180
[  333.798014]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[  333.798018]  [<ffffffff8150a54e>] ? intel_idle+0xfe/0x180
[  333.798022]  [<ffffffff8150a547>] ? intel_idle+0xf7/0x180
[  333.798027]  [<ffffffff81a69570>] ? __atomic_notifier_call_chain+0x0/0xa0
[  333.798033]  [<ffffffff81892927>] cpuidle_idle_call+0xa7/0x140
[  333.798038]  [<ffffffff81035037>] cpu_idle+0xb7/0x110
[  333.798044]  [<ffffffff81a30d0f>] rest_init+0xcf/0xe0
[  333.798048]  [<ffffffff81a30c40>] ? rest_init+0x0/0xe0
[  333.798055]  [<ffffffff8253ae05>] start_kernel+0x417/0x424
[  333.798059]  [<ffffffff8253a31c>] x86_64_start_reservations+0x12c/0x130
[  333.798064]  [<ffffffff8253a404>] x86_64_start_kernel+0xe4/0xeb
[  333.798066] Code: 58 ff ff ff 48 8d 83 58 1c 00 00 48 89 85 50 ff ff ff 0f 1f 44 00 00 48 8b 05 49 30 2d 01 48 8b 53 48 48 39 d0 0f 88 bc 01 00 00 <41> 89 d4 41 81 e4 ff 00 00 00 0f 84 84 01 00 00 48 ff c2 4d 63 
[  333.798408] Call Trace:
[  333.798409]  <IRQ>  [<ffffffff8109090e>] ? run_timer_softirq+0x13e/0x420
[  333.798419]  [<ffffffff8109c060>] ? delayed_work_timer_fn+0x0/0x50
[  333.798423]  [<ffffffff81087f2a>] __do_softirq+0xca/0x270
[  333.798428]  [<ffffffff81036fcc>] call_softirq+0x1c/0x50
[  333.798431]  [<ffffffff8103888d>] do_softirq+0x7d/0xb0
[  333.798433]  [<ffffffff81087a55>] irq_exit+0x95/0xa0
[  333.798442]  [<ffffffff81a6ccb5>] do_IRQ+0x75/0xf0
[  333.798446]  [<ffffffff81a65b53>] ret_from_intr+0x0/0xf
[  333.798449]  <EOI>  [<ffffffff8150a547>] ? intel_idle+0xf7/0x180
[  333.798459]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[  333.798465]  [<ffffffff8150a54e>] ? intel_idle+0xfe/0x180
[  333.798470]  [<ffffffff8150a547>] ? intel_idle+0xf7/0x180
[  333.798476]  [<ffffffff81a69570>] ? __atomic_notifier_call_chain+0x0/0xa0
[  333.798482]  [<ffffffff81892927>] cpuidle_idle_call+0xa7/0x140
[  333.798488]  [<ffffffff81035037>] cpu_idle+0xb7/0x110
[  333.798493]  [<ffffffff81a30d0f>] rest_init+0xcf/0xe0
[  333.798498]  [<ffffffff81a30c40>] ? rest_init+0x0/0xe0
[  333.798504]  [<ffffffff8253ae05>] start_kernel+0x417/0x424
[  333.798510]  [<ffffffff8253a31c>] x86_64_start_reservations+0x12c/0x130
[  333.798516]  [<ffffffff8253a404>] x86_64_start_kernel+0xe4/0xeb
[  333.798521] Pid: 0, comm: swapper Tainted: G        W   2.6.35-rc4-andres #9
[  333.798525] Call Trace:
[  333.798527]  <NMI>  [<ffffffff8103ea3b>] ? show_regs+0x2b/0x40
[  333.798538]  [<ffffffff81a675a2>] nmi_watchdog_tick+0x1b2/0x1e0
[  333.798543]  [<ffffffff81a66913>] do_nmi+0x1c3/0x2f0
[  333.798548]  [<ffffffff81a660ea>] nmi+0x1a/0x2c
[  333.798555]  [<ffffffff81090884>] ? run_timer_softirq+0xb4/0x420
[  333.798558]  <<EOE>>  <IRQ>  [<ffffffff8109090e>] ? run_timer_softirq+0x13e/0x420
[  333.798569]  [<ffffffff8109c060>] ? delayed_work_timer_fn+0x0/0x50
[  333.798576]  [<ffffffff81087f2a>] __do_softirq+0xca/0x270
[  333.798582]  [<ffffffff81036fcc>] call_softirq+0x1c/0x50
[  333.798587]  [<ffffffff8103888d>] do_softirq+0x7d/0xb0
[  333.798592]  [<ffffffff81087a55>] irq_exit+0x95/0xa0
[  333.798598]  [<ffffffff81a6ccb5>] do_IRQ+0x75/0xf0
[  333.798603]  [<ffffffff81a65b53>] ret_from_intr+0x0/0xf
[  333.798607]  <EOI>  [<ffffffff8150a547>] ? intel_idle+0xf7/0x180
[  333.798616]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[  333.798622]  [<ffffffff8150a54e>] ? intel_idle+0xfe/0x180
[  333.798628]  [<ffffffff8150a547>] ? intel_idle+0xf7/0x180
[  333.798634]  [<ffffffff81a69570>] ? __atomic_notifier_call_chain+0x0/0xa0
[  333.798641]  [<ffffffff81892927>] cpuidle_idle_call+0xa7/0x140
[  333.798647]  [<ffffffff81035037>] cpu_idle+0xb7/0x110
[  333.798652]  [<ffffffff81a30d0f>] rest_init+0xcf/0xe0
[  333.798658]  [<ffffffff81a30c40>] ? rest_init+0x0/0xe0
[  333.798664]  [<ffffffff8253ae05>] start_kernel+0x417/0x424
[  333.798670]  [<ffffffff8253a31c>] x86_64_start_reservations+0x12c/0x130
[  333.798676]  [<ffffffff8253a404>] x86_64_start_kernel+0xe4/0xeb
[  333.798680] NMI backtrace for cpu 2
[  333.798683] CPU 2 
[  333.798685] Modules linked in:
[  333.798688] 
[  333.798692] Pid: 0, comm: swapper Tainted: G        W   2.6.35-rc4-andres #9 S7002/empty
[  333.798696] RIP: 0010:[<ffffffff8149f447>]  [<ffffffff8149f447>] delay_tsc+0x37/0x60
[  333.798706] RSP: 0018:ffff880003603d38  EFLAGS: 00000807
[  333.798710] RAX: 00000000059fa1e8 RBX: 0000000000000000 RCX: ffff880003600000
[  333.798714] RDX: 00000000000000ce RSI: 00000000059fa1c6 RDI: 0000000000037568
[  333.798718] RBP: ffff880003603d38 R08: 0000000000000002 R09: 0000000000000000
[  333.798722] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000001000
[  333.798725] R13: ffffffff8235d648 R14: 0000000000000400 R15: 0000000000000096
[  333.798730] FS:  0000000000000000(0000) GS:ffff880003600000(0000) knlGS:0000000000000000
[  333.798734] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  333.798738] CR2: 00007f90c00fd088 CR3: 000000042c2fc000 CR4: 00000000000006e0
[  333.798742] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  333.798745] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  333.798750] Process swapper (pid: 0, threadinfo ffff88042e19c000, task ffff88042e1a0000)
[  333.798753] Stack:
[  333.798755]  ffff880003603d48 ffffffff8149f500 ffff880003603d68 ffffffff81052dda
[  333.798760] <0> 0000000000000002 000000000000d560 ffff880003603db8 ffffffff8105356d
[  333.798766] <0> ffffffff00000016 0000000000000003 ffff880003603d98 0000000000000000
[  333.798773] Call Trace:
[  333.798776]  <IRQ> 
[  333.798781]  [<ffffffff8149f500>] __const_udelay+0x40/0x50
[  333.798788]  [<ffffffff81052dda>] native_safe_apic_wait_icr_idle+0x1a/0x50
[  333.798794]  [<ffffffff8105356d>] default_send_IPI_mask_sequence_phys+0xed/0x100
[  333.798801]  [<ffffffff81057337>] physflat_send_IPI_all+0x17/0x20
[  333.798807]  [<ffffffff81053681>] arch_trigger_all_cpu_backtrace+0x41/0x70
[  333.798814]  [<ffffffff810ef9d3>] __rcu_pending+0x353/0x380
[  333.798821]  [<ffffffff810b0280>] ? tick_sched_timer+0x0/0xc0
[  333.798827]  [<ffffffff810efa6a>] rcu_check_callbacks+0x6a/0x120
[  333.798833]  [<ffffffff81091118>] update_process_times+0x48/0x70
[  333.798839]  [<ffffffff810b02e6>] tick_sched_timer+0x66/0xc0
[  333.798846]  [<ffffffff810a3efe>] __run_hrtimer+0x8e/0x1c0
[  333.798851]  [<ffffffff810a42c6>] hrtimer_interrupt+0xe6/0x250
[  333.798859]  [<ffffffff81a6cd9b>] smp_apic_timer_interrupt+0x6b/0x9b
[  333.798865]  [<ffffffff81036a93>] apic_timer_interrupt+0x13/0x20
[  333.798868]  <EOI> 
[  333.798875]  [<ffffffff8150a547>] ? intel_idle+0xf7/0x180
[  333.798880]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[  333.798886]  [<ffffffff8150a54e>] ? intel_idle+0xfe/0x180
[  333.798891]  [<ffffffff8150a547>] ? intel_idle+0xf7/0x180
[  333.798897]  [<ffffffff81a69570>] ? __atomic_notifier_call_chain+0x0/0xa0
[  333.798904]  [<ffffffff81892927>] cpuidle_idle_call+0xa7/0x140
[  333.798909]  [<ffffffff81035037>] cpu_idle+0xb7/0x110
[  333.798915]  [<ffffffff81a5b5ed>] start_secondary+0x207/0x20e
[  333.798919] Code: 04 25 58 d5 00 00 0f 1f 00 0f ae e8 0f 31 89 c6 eb 11 66 90 f3 90 65 8b 0c 25 58 d5 00 00 44 39 c1 75 17 0f 1f 00 0f ae e8 0f 31 <89> c0 48 89 c2 48 29 f2 48 39 d7 77 dc c9 c3 48 29 c6 48 01 f7 
[  333.798965] Call Trace:
[  333.798967]  <IRQ>  [<ffffffff8149f500>] __const_udelay+0x40/0x50
[  333.798977]  [<ffffffff81052dda>] native_safe_apic_wait_icr_idle+0x1a/0x50
[  333.798983]  [<ffffffff8105356d>] default_send_IPI_mask_sequence_phys+0xed/0x100
[  333.798989]  [<ffffffff81057337>] physflat_send_IPI_all+0x17/0x20
[  333.798995]  [<ffffffff81053681>] arch_trigger_all_cpu_backtrace+0x41/0x70
[  333.799001]  [<ffffffff810ef9d3>] __rcu_pending+0x353/0x380
[  333.799007]  [<ffffffff810b0280>] ? tick_sched_timer+0x0/0xc0
[  333.799012]  [<ffffffff810efa6a>] rcu_check_callbacks+0x6a/0x120
[  333.799017]  [<ffffffff81091118>] update_process_times+0x48/0x70
[  333.799023]  [<ffffffff810b02e6>] tick_sched_timer+0x66/0xc0
[  333.799028]  [<ffffffff810a3efe>] __run_hrtimer+0x8e/0x1c0
[  333.799034]  [<ffffffff810a42c6>] hrtimer_interrupt+0xe6/0x250
[  333.799040]  [<ffffffff81a6cd9b>] smp_apic_timer_interrupt+0x6b/0x9b
[  333.799046]  [<ffffffff81036a93>] apic_timer_interrupt+0x13/0x20
[  333.799049]  <EOI>  [<ffffffff8150a547>] ? intel_idle+0xf7/0x180
[  333.799058]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[  333.799064]  [<ffffffff8150a54e>] ? intel_idle+0xfe/0x180
[  333.799069]  [<ffffffff8150a547>] ? intel_idle+0xf7/0x180
[  333.799074]  [<ffffffff81a69570>] ? __atomic_notifier_call_chain+0x0/0xa0
[  333.799080]  [<ffffffff81892927>] cpuidle_idle_call+0xa7/0x140
[  333.799085]  [<ffffffff81035037>] cpu_idle+0xb7/0x110
[  333.799090]  [<ffffffff81a5b5ed>] start_secondary+0x207/0x20e
[  333.799096] Pid: 0, comm: swapper Tainted: G        W   2.6.35-rc4-andres #9
[  333.799099] Call Trace:
[  333.799101]  <NMI> 
[  333.799104] Hangcheck: hangcheck value past margin!
[  333.799111]  [<ffffffff8103ea3b>] ? show_regs+0x2b/0x40
[  333.799117]  [<ffffffff81a675a2>] nmi_watchdog_tick+0x1b2/0x1e0
[  333.799122]  [<ffffffff81a66913>] do_nmi+0x1c3/0x2f0
[  333.799127]  [<ffffffff81a660ea>] nmi+0x1a/0x2c
[  333.799132]  [<ffffffff8149f447>] ? delay_tsc+0x37/0x60
[  333.799135]  <<EOE>>  <IRQ>  [<ffffffff8149f500>] __const_udelay+0x40/0x50
[  333.799144]  [<ffffffff81052dda>] native_safe_apic_wait_icr_idle+0x1a/0x50
[  333.799149]  [<ffffffff8105356d>] default_send_IPI_mask_sequence_phys+0xed/0x100
[  333.799155]  [<ffffffff81057337>] physflat_send_IPI_all+0x17/0x20
[  333.799161]  [<ffffffff81053681>] arch_trigger_all_cpu_backtrace+0x41/0x70
[  333.799166]  [<ffffffff810ef9d3>] __rcu_pending+0x353/0x380
[  333.799172]  [<ffffffff810b0280>] ? tick_sched_timer+0x0/0xc0
[  333.799177]  [<ffffffff810efa6a>] rcu_check_callbacks+0x6a/0x120
[  333.799181]  [<ffffffff81091118>] update_process_times+0x48/0x70
[  333.799187]  [<ffffffff810b02e6>] tick_sched_timer+0x66/0xc0
[  333.799192]  [<ffffffff810a3efe>] __run_hrtimer+0x8e/0x1c0
[  333.799197]  [<ffffffff810a42c6>] hrtimer_interrupt+0xe6/0x250
[  333.799203]  [<ffffffff81a6cd9b>] smp_apic_timer_interrupt+0x6b/0x9b
[  333.799209]  [<ffffffff81036a93>] apic_timer_interrupt+0x13/0x20
[  333.799212]  <EOI>  [<ffffffff8150a547>] ? intel_idle+0xf7/0x180
[  333.799220]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[  333.799226]  [<ffffffff8150a54e>] ? intel_idle+0xfe/0x180
[  333.799231]  [<ffffffff8150a547>] ? intel_idle+0xf7/0x180
[  333.799236]  [<ffffffff81a69570>] ? __atomic_notifier_call_chain+0x0/0xa0
[  333.799242]  [<ffffffff81892927>] cpuidle_idle_call+0xa7/0x140
[  333.799247]  [<ffffffff81035037>] cpu_idle+0xb7/0x110
[  333.799253]  [<ffffffff81a5b5ed>] start_secondary+0x207/0x20e
[  333.799258] NMI backtrace for cpu 1
[  333.799260] CPU 1 
[  333.799262] Modules linked in:
[  333.799264] 
[  333.799267] Pid: 0, comm: swapper Tainted: G        W   2.6.35-rc4-andres #9 S7002/empty
[  333.799269] RIP: 0010:[<ffffffff8150a517>]  [<ffffffff8150a517>] intel_idle+0xc7/0x180
[  333.799276] RSP: 0018:ffff88042e189e68  EFLAGS: 00000046
[  333.799278] RAX: 0000000000000020 RBX: 0000000000000008 RCX: 0000000000000001
[  333.799281] RDX: 0000000000000000 RSI: ffff88042e189fd8 RDI: ffffffff8221b480
[  333.799283] RBP: ffff88042e189ec8 R08: ffffffff8221b400 R09: 0000000000000000
[  333.799285] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000020
[  333.799287] R13: 11bdf05ad4ece760 R14: 0000000000000003 R15: 0000000000000000
[  333.799290] FS:  0000000000000000(0000) GS:ffff880003400000(0000) knlGS:0000000000000000
[  333.799293] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  333.799295] CR2: 00007fabf8184ad0 CR3: 000000042c2fc000 CR4: 00000000000006e0
[  333.799298] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  333.799300] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  333.799303] Process swapper (pid: 0, threadinfo ffff88042e188000, task ffff88042e1846c0)
[  333.799305] Stack:
[  333.799306]  0000000000000000 0000000000000001 ffff88042e189ec8 ffffffff81a695f6
[  333.799309] <0> ffffffff81a69570 000000012e1846c0 ffff88042e189ec8 ffff8800035dbf98
[  333.799313] <0> ffff8800035dc0c8 0000000000000000 0000000000000000 0000000000000000
[  333.799317] Call Trace:
[  333.799322]  [<ffffffff81a695f6>] ? __atomic_notifier_call_chain+0x86/0xa0
[  333.799326]  [<ffffffff81a69570>] ? __atomic_notifier_call_chain+0x0/0xa0
[  333.799331]  [<ffffffff81892927>] cpuidle_idle_call+0xa7/0x140
[  333.799335]  [<ffffffff81035037>] cpu_idle+0xb7/0x110
[  333.799339]  [<ffffffff81a5b5ed>] start_secondary+0x207/0x20e
[  333.799341] Code: ff ff a8 08 75 25 31 d2 48 8d 86 38 e0 ff ff 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e0 0f 01 c9 <e8> f4 b9 bf ff e8 4f 0b ba ff 4c 29 e8 48 89 c7 e8 54 bd b7 ff 
[  333.799376] Call Trace:
[  333.799381]  [<ffffffff81a695f6>] ? __atomic_notifier_call_chain+0x86/0xa0
[  333.799387]  [<ffffffff81a69570>] ? __atomic_notifier_call_chain+0x0/0xa0
[  333.799393]  [<ffffffff81892927>] cpuidle_idle_call+0xa7/0x140
[  333.799398]  [<ffffffff81035037>] cpu_idle+0xb7/0x110
[  333.799403]  [<ffffffff81a5b5ed>] start_secondary+0x207/0x20e
[  333.799408] Pid: 0, comm: swapper Tainted: G        W   2.6.35-rc4-andres #9
[  333.799411] Call Trace:
[  333.799413]  <NMI>  [<ffffffff8103ea3b>] ? show_regs+0x2b/0x40
[  333.799421]  [<ffffffff81a675a2>] nmi_watchdog_tick+0x1b2/0x1e0
[  333.799426]  [<ffffffff81a66913>] do_nmi+0x1c3/0x2f0
[  333.799431]  [<ffffffff81a660ea>] nmi+0x1a/0x2c
[  333.799437]  [<ffffffff8150a517>] ? intel_idle+0xc7/0x180
[  333.799439]  <<EOE>>  [<ffffffff81a695f6>] ? __atomic_notifier_call_chain+0x86/0xa0
[  333.799448]  [<ffffffff81a69570>] ? __atomic_notifier_call_chain+0x0/0xa0
[  333.799454]  [<ffffffff81892927>] cpuidle_idle_call+0xa7/0x140
[  333.799459]  [<ffffffff81035037>] cpu_idle+0xb7/0x110
[  333.799464]  [<ffffffff81a5b5ed>] start_secondary+0x207/0x20e
[  333.799469] NMI backtrace for cpu 3
[  333.799472] CPU 3 
[  333.799474] Modules linked in:
[  333.799477] 
[  333.799481] Pid: 30, comm: events/3 Tainted: G        W   2.6.35-rc4-andres #9 S7002/empty
[  333.799485] RIP: 0010:[<ffffffff81080d1a>]  [<ffffffff81080d1a>] release_console_sem+0x1aa/0x240
[  333.799495] RSP: 0018:ffff88042e393d10  EFLAGS: 00000002
[  333.799498] RAX: ffffffff82618da0 RBX: 00000000fffe4069 RCX: 000000000003ffff
[  333.799502] RDX: 0000000000000004 RSI: 000000000001a4d4 RDI: 000000000001a4af
[  333.799505] RBP: ffff88042e393d30 R08: 000000000001a4ae R09: 0000000000000000
[  333.799509] R10: 0000000000000000 R11: 0000000000000000 R12: 000000000001a4d5
[  333.799512] R13: 000000000001bf97 R14: 0000000000000282 R15: 0000000000000007
[  333.799516] FS:  0000000000000000(0000) GS:ffff880003800000(0000) knlGS:0000000000000000
[  333.799520] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  333.799524] CR2: 00007f90be9ab0a0 CR3: 0000000002209000 CR4: 00000000000006e0
[  333.799527] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  333.799531] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  333.799535] Process events/3 (pid: 30, threadinfo ffff88042e392000, task ffff88042e398000)
[  333.799538] Stack:
[  333.799540]  ffff88042b6ae000 ffff880429b03c00 ffff88042b6ae2b8 ffff88042b6ae000
[  333.799545] <0> ffff88042e393da0 ffffffff814f85ea ffffffff00000000 ffff880429b03c00
[  333.799550] <0> ffff88042b6ae138 ffff880400000000 ffffffff814fe7d0 00000002039d79c0
[  333.799557] Call Trace:
[  333.799563]  [<ffffffff814f85ea>] fb_flashcursor+0x7a/0x2f0
[  333.799569]  [<ffffffff814fe7d0>] ? bit_cursor+0x0/0x6c0
[  333.799574]  [<ffffffff814f8570>] ? fb_flashcursor+0x0/0x2f0
[  333.799580]  [<ffffffff8109b46a>] worker_thread+0x21a/0x400
[  333.799585]  [<ffffffff8109b419>] ? worker_thread+0x1c9/0x400
[  333.799591]  [<ffffffff810a0630>] ? autoremove_wake_function+0x0/0x40
[  333.799597]  [<ffffffff8109b250>] ? worker_thread+0x0/0x400
[  333.799601]  [<ffffffff810a00c6>] kthread+0xb6/0xc0
[  333.799607]  [<ffffffff810b4859>] ? trace_hardirqs_on_caller+0x29/0x1a0
[  333.799614]  [<ffffffff81036ed4>] kernel_thread_helper+0x4/0x10
[  333.799619]  [<ffffffff81a65820>] ? _raw_spin_unlock_irq+0x30/0x40
[  333.799624]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[  333.799629]  [<ffffffff81a65bfc>] ? restore_args+0x0/0x30
[  333.799633]  [<ffffffff810a0010>] ? kthread+0x0/0xc0
[  333.799639]  [<ffffffff81036ed0>] ? kernel_thread_helper+0x0/0x10
[  333.799641] Code: 00 8b 0d c6 cd 19 01 48 8b 05 03 ce 19 01 ff c9 44 89 e6 41 ff c4 21 ce 80 3c 30 0a 0f 84 2f ff ff ff 45 39 e5 0f 84 f7 fe ff ff <eb> e3 0f 1f 40 00 e8 ab 3c 03 00 41 56 9d e9 73 fe ff ff 44 89 
[  333.799685] Call Trace:
[  333.799690]  [<ffffffff814f85ea>] fb_flashcursor+0x7a/0x2f0
[  333.799695]  [<ffffffff814fe7d0>] ? bit_cursor+0x0/0x6c0
[  333.799700]  [<ffffffff814f8570>] ? fb_flashcursor+0x0/0x2f0
[  333.799705]  [<ffffffff8109b46a>] worker_thread+0x21a/0x400
[  333.799710]  [<ffffffff8109b419>] ? worker_thread+0x1c9/0x400
[  333.799716]  [<ffffffff810a0630>] ? autoremove_wake_function+0x0/0x40
[  333.799721]  [<ffffffff8109b250>] ? worker_thread+0x0/0x400
[  333.799726]  [<ffffffff810a00c6>] kthread+0xb6/0xc0
[  333.799731]  [<ffffffff810b4859>] ? trace_hardirqs_on_caller+0x29/0x1a0
[  333.799737]  [<ffffffff81036ed4>] kernel_thread_helper+0x4/0x10
[  333.799742]  [<ffffffff81a65820>] ? _raw_spin_unlock_irq+0x30/0x40
[  333.799747]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[  333.799752]  [<ffffffff81a65bfc>] ? restore_args+0x0/0x30
[  333.799756]  [<ffffffff810a0010>] ? kthread+0x0/0xc0
[  333.799762]  [<ffffffff81036ed0>] ? kernel_thread_helper+0x0/0x10
[  333.799767] Pid: 30, comm: events/3 Tainted: G        W   2.6.35-rc4-andres #9
[  333.799770] Call Trace:
[  333.799772]  <NMI>  [<ffffffff8103ea3b>] ? show_regs+0x2b/0x40
[  333.799781]  [<ffffffff81a675a2>] nmi_watchdog_tick+0x1b2/0x1e0
[  333.799786]  [<ffffffff81a66913>] do_nmi+0x1c3/0x2f0
[  333.799791]  [<ffffffff81a660ea>] nmi+0x1a/0x2c
[  333.799797]  [<ffffffff81080d1a>] ? release_console_sem+0x1aa/0x240
[  333.799800]  <<EOE>>  [<ffffffff814f85ea>] fb_flashcursor+0x7a/0x2f0
[  333.799809]  [<ffffffff814fe7d0>] ? bit_cursor+0x0/0x6c0
[  333.799814]  [<ffffffff814f8570>] ? fb_flashcursor+0x0/0x2f0
[  333.799819]  [<ffffffff8109b46a>] worker_thread+0x21a/0x400
[  333.799824]  [<ffffffff8109b419>] ? worker_thread+0x1c9/0x400
[  333.799830]  [<ffffffff810a0630>] ? autoremove_wake_function+0x0/0x40
[  333.799836]  [<ffffffff8109b250>] ? worker_thread+0x0/0x400
[  333.799841]  [<ffffffff810a00c6>] kthread+0xb6/0xc0
[  333.799846]  [<ffffffff810b4859>] ? trace_hardirqs_on_caller+0x29/0x1a0
[  333.799852]  [<ffffffff81036ed4>] kernel_thread_helper+0x4/0x10
[  333.799857]  [<ffffffff81a65820>] ? _raw_spin_unlock_irq+0x30/0x40
[  333.799862]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[  333.799866]  [<ffffffff81a65bfc>] ? restore_args+0x0/0x30
[  333.799871]  [<ffffffff810a0010>] ? kthread+0x0/0xc0
[  333.799877]  [<ffffffff81036ed0>] ? kernel_thread_helper+0x0/0x10
[  333.799880] NMI backtrace for cpu 5
[  333.799882] CPU 5 
[  333.799884] Modules linked in:
[  333.799886] 
[  333.799888] Pid: 0, comm: swapper Tainted: G        W   2.6.35-rc4-andres #9 S7002/empty
[  333.799891] RIP: 0010:[<ffffffff8150a517>]  [<ffffffff8150a517>] intel_idle+0xc7/0x180
[  333.799896] RSP: 0018:ffff88042e30de68  EFLAGS: 00000046
[  333.799898] RAX: 0000000000000010 RBX: 0000000000000004 RCX: 0000000000000001
[  333.799901] RDX: 0000000000000000 RSI: ffff88042e30dfd8 RDI: ffffffff8221b480
[  333.799903] RBP: ffff88042e30dec8 R08: 0000000000000002 R09: 0000000000000000
[  333.799905] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000010
[  333.799908] R13: 11bdf05ad503b98b R14: 0000000000000002 R15: 0000000000000000
[  333.799910] FS:  0000000000000000(0000) GS:ffff880003c00000(0000) knlGS:0000000000000000
[  333.799913] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  333.799915] CR2: 00007f90be9ab0a0 CR3: 0000000427274000 CR4: 00000000000006e0
[  333.799918] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  333.799920] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  333.799923] Process swapper (pid: 0, threadinfo ffff88042e30c000, task ffff88042e310000)
[  333.799925] Stack:
[  333.799926]  0000000000000000 0000000000000001 ffff88042e30dec8 ffffffff81a695f6
[  333.799930] <0> ffffffff81a69570 000000052e310000 ffff88042e30dec8 ffff880003ddbf98
[  333.799933] <0> ffff880003ddc068 0000000000000000 0000000000000000 0000000000000000
[  333.799938] Call Trace:
[  333.799942]  [<ffffffff81a695f6>] ? __atomic_notifier_call_chain+0x86/0xa0
[  333.799946]  [<ffffffff81a69570>] ? __atomic_notifier_call_chain+0x0/0xa0
[  333.799950]  [<ffffffff81892927>] cpuidle_idle_call+0xa7/0x140
[  333.799954]  [<ffffffff81035037>] cpu_idle+0xb7/0x110
[  333.799957]  [<ffffffff81a5b5ed>] start_secondary+0x207/0x20e
[  333.799959] Code: ff ff a8 08 75 25 31 d2 48 8d 86 38 e0 ff ff 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e0 0f 01 c9 <e8> f4 b9 bf ff e8 4f 0b ba ff 4c 29 e8 48 89 c7 e8 54 bd b7 ff 
[  333.799990] Call Trace:
[  333.799994]  [<ffffffff81a695f6>] ? __atomic_notifier_call_chain+0x86/0xa0
[  333.799997]  [<ffffffff81a69570>] ? __atomic_notifier_call_chain+0x0/0xa0
[  333.800002]  [<ffffffff81892927>] cpuidle_idle_call+0xa7/0x140
[  333.800005]  [<ffffffff81035037>] cpu_idle+0xb7/0x110
[  333.800009]  [<ffffffff81a5b5ed>] start_secondary+0x207/0x20e
[  333.800012] Pid: 0, comm: swapper Tainted: G        W   2.6.35-rc4-andres #9
[  333.800014] Call Trace:
[  333.800016]  <NMI>  [<ffffffff8103ea3b>] ? show_regs+0x2b/0x40
[  333.800022]  [<ffffffff81a675a2>] nmi_watchdog_tick+0x1b2/0x1e0
[  333.800025]  [<ffffffff81a66913>] do_nmi+0x1c3/0x2f0
[  333.800029]  [<ffffffff81a660ea>] nmi+0x1a/0x2c
[  333.800033]  [<ffffffff8150a517>] ? intel_idle+0xc7/0x180
[  333.800035]  <<EOE>>  [<ffffffff81a695f6>] ? __atomic_notifier_call_chain+0x86/0xa0
[  333.800041]  [<ffffffff81a69570>] ? __atomic_notifier_call_chain+0x0/0xa0
[  333.800046]  [<ffffffff81892927>] cpuidle_idle_call+0xa7/0x140
[  333.800049]  [<ffffffff81035037>] cpu_idle+0xb7/0x110
[  333.800053]  [<ffffffff81a5b5ed>] start_secondary+0x207/0x20e
[  333.800057] NMI backtrace for cpu 7
[  333.800059] CPU 7 
[  333.800061] Modules linked in:
[  333.800064] 
[  333.800068] Pid: 0, comm: swapper Tainted: G        W   2.6.35-rc4-andres #9 S7002/empty
[  333.800072] RIP: 0010:[<ffffffff810908ce>]  [<ffffffff810908ce>] run_timer_softirq+0xfe/0x420
[  333.800080] RSP: 0018:ffff880004003e00  EFLAGS: 00000012
[  333.800084] RAX: ffff88042e32c528 RBX: ffff88042e32c000 RCX: ffff880004003dc0
[  333.800088] RDX: ffff880004003e90 RSI: ffff880004003dc0 RDI: ffff88042e32c000
[  333.800092] RBP: ffff880004003ed0 R08: 0000000000000002 R09: 0000000000000001
[  333.800096] R10: 0000000000000000 R11: 0000000000000046 R12: 0000000000000510
[  333.800100] R13: ffff880004003e90 R14: 0000000000000100 R15: ffff88042e34dfd8
[  333.800105] FS:  0000000000000000(0000) GS:ffff880004000000(0000) knlGS:0000000000000000
[  333.800109] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  333.800113] CR2: 00007f107e5c2620 CR3: 000000042714f000 CR4: 00000000000006e0
[  333.800117] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  333.800121] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  333.800126] Process swapper (pid: 0, threadinfo ffff88042e34c000, task ffff88042e3446c0)
[  333.800129] Stack:
[  333.800131]  ffffffff8109090e ffff880004003e88 ffff88042e3446c0 ffff88000400f018
[  333.800137] <0> ffff88042e32dc58 ffff88042e32d858 ffff88042e32d458 ffff88042e34dfd8
[  333.800143] <0> ffff88042e34dfd8 0000000000000007 ffffffff8104a910 ffff88042e32d058
[  333.800150] Call Trace:
[  333.800152]  <IRQ> 
[  333.800157]  [<ffffffff8109090e>] ? run_timer_softirq+0x13e/0x420
[  333.800164]  [<ffffffff8104a910>] ? mce_start_timer+0x0/0x130
[  333.800171]  [<ffffffff81087f2a>] __do_softirq+0xca/0x270
[  333.800177]  [<ffffffff81036fcc>] call_softirq+0x1c/0x50
[  333.800182]  [<ffffffff8103888d>] do_softirq+0x7d/0xb0
[  333.800187]  [<ffffffff81087a55>] irq_exit+0x95/0xa0
[  333.800193]  [<ffffffff81a6cda0>] smp_apic_timer_interrupt+0x70/0x9b
[  333.800199]  [<ffffffff81036a93>] apic_timer_interrupt+0x13/0x20
[  333.800202]  <EOI> 
[  333.800208]  [<ffffffff8150a547>] ? intel_idle+0xf7/0x180
[  333.800213]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[  333.800219]  [<ffffffff8150a54e>] ? intel_idle+0xfe/0x180
[  333.800225]  [<ffffffff8150a547>] ? intel_idle+0xf7/0x180
[  333.800231]  [<ffffffff81a69570>] ? __atomic_notifier_call_chain+0x0/0xa0
[  333.800237]  [<ffffffff81892927>] cpuidle_idle_call+0xa7/0x140
[  333.800243]  [<ffffffff81035037>] cpu_idle+0xb7/0x110
[  333.800249]  [<ffffffff81a5b5ed>] start_secondary+0x207/0x20e
[  333.800252] Code: c1 e4 04 49 8b 54 1c 18 4a 8d 44 23 18 48 89 55 c0 4c 89 6a 08 49 8b 54 1c 20 48 89 55 c8 4c 89 2a 49 89 44 1c 18 49 89 44 1c 20 <4c> 8b 65 c0 4d 39 ec 74 99 49 8b 44 24 20 48 89 45 80 49 8b 44 
[  333.800299] Call Trace:
[  333.800301]  <IRQ>  [<ffffffff8109090e>] ? run_timer_softirq+0x13e/0x420
[  333.800310]  [<ffffffff8104a910>] ? mce_start_timer+0x0/0x130
[  333.800316]  [<ffffffff81087f2a>] __do_softirq+0xca/0x270
[  333.800323]  [<ffffffff81036fcc>] call_softirq+0x1c/0x50
[  333.800328]  [<ffffffff8103888d>] do_softirq+0x7d/0xb0
[  333.800332]  [<ffffffff81087a55>] irq_exit+0x95/0xa0
[  333.800338]  [<ffffffff81a6cda0>] smp_apic_timer_interrupt+0x70/0x9b
[  333.800343]  [<ffffffff81036a93>] apic_timer_interrupt+0x13/0x20
[  333.800346]  <EOI>  [<ffffffff8150a547>] ? intel_idle+0xf7/0x180
[  333.800354]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[  333.800359]  [<ffffffff8150a54e>] ? intel_idle+0xfe/0x180
[  333.800365]  [<ffffffff8150a547>] ? intel_idle+0xf7/0x180
[  333.800370]  [<ffffffff81a69570>] ? __atomic_notifier_call_chain+0x0/0xa0
[  333.800377]  [<ffffffff81892927>] cpuidle_idle_call+0xa7/0x140
[  333.800382]  [<ffffffff81035037>] cpu_idle+0xb7/0x110
[  333.800387]  [<ffffffff81a5b5ed>] start_secondary+0x207/0x20e
[  333.800392] Pid: 0, comm: swapper Tainted: G        W   2.6.35-rc4-andres #9
[  333.800395] Call Trace:
[  333.800397]  <NMI>  [<ffffffff8103ea3b>] ? show_regs+0x2b/0x40
[  333.800406]  [<ffffffff81a675a2>] nmi_watchdog_tick+0x1b2/0x1e0
[  333.800411]  [<ffffffff81a66913>] do_nmi+0x1c3/0x2f0
[  333.800416]  [<ffffffff81a660ea>] nmi+0x1a/0x2c
[  333.800422]  [<ffffffff810908ce>] ? run_timer_softirq+0xfe/0x420
[  333.800425]  <<EOE>>  <IRQ>  [<ffffffff8109090e>] ? run_timer_softirq+0x13e/0x420
[  333.800435]  [<ffffffff8104a910>] ? mce_start_timer+0x0/0x130
[  333.800441]  [<ffffffff81087f2a>] __do_softirq+0xca/0x270
[  333.800447]  [<ffffffff81036fcc>] call_softirq+0x1c/0x50
[  333.800452]  [<ffffffff8103888d>] do_softirq+0x7d/0xb0
[  333.800457]  [<ffffffff81087a55>] irq_exit+0x95/0xa0
[  333.800463]  [<ffffffff81a6cda0>] smp_apic_timer_interrupt+0x70/0x9b
[  333.800469]  [<ffffffff81036a93>] apic_timer_interrupt+0x13/0x20
[  333.800472]  <EOI>  [<ffffffff8150a547>] ? intel_idle+0xf7/0x180
[  333.800481]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[  333.800487]  [<ffffffff8150a54e>] ? intel_idle+0xfe/0x180
[  333.800493]  [<ffffffff8150a547>] ? intel_idle+0xf7/0x180
[  333.800498]  [<ffffffff81a69570>] ? __atomic_notifier_call_chain+0x0/0xa0
[  333.800505]  [<ffffffff81892927>] cpuidle_idle_call+0xa7/0x140
[  333.800510]  [<ffffffff81035037>] cpu_idle+0xb7/0x110
[  333.800515]  [<ffffffff81a5b5ed>] start_secondary+0x207/0x20e
[  333.800520] NMI backtrace for cpu 6
[  333.800522] CPU 6 
[  333.800524] Modules linked in:
[  333.800526] 
[  333.800530] Pid: 1447, comm: flush-1:0 Tainted: G        W   2.6.35-rc4-andres #9 S7002/empty
[  333.800533] RIP: 0010:[<ffffffff8149f447>]  [<ffffffff8149f447>] delay_tsc+0x37/0x60
[  333.800539] RSP: 0018:ffff88042c361bd0  EFLAGS: 00000002
[  333.800542] RAX: 0000000005d33c59 RBX: ffff88042e32c000 RCX: 0000000000000001
[  333.800545] RDX: 00000000000000ce RSI: 0000000005d33c21 RDI: 0000000000000001
[  333.800548] RBP: ffff88042c361bd0 R08: 0000000000000006 R09: 0000000000000001
[  333.800551] R10: 0000000000000000 R11: 0000000000000001 R12: 000000008719e9c0
[  333.800555] R13: ffff880428e8c6c0 R14: ffff880428e8cb80 R15: 00000000000015e3
[  333.800558] FS:  0000000000000000(0000) GS:ffff880003e00000(0000) knlGS:0000000000000000
[  333.800562] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  333.800565] CR2: 00007f90be9ab0a0 CR3: 0000000002209000 CR4: 00000000000006e0
[  333.800568] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  333.800571] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  333.800575] Process flush-1:0 (pid: 1447, threadinfo ffff88042c360000, task ffff880428e8c6c0)
[  333.800578] Stack:
[  333.800579]  ffff88042c361be0 ffffffff8149f3ff ffff88042c361c30 ffffffff814b075c
[  333.800584] <0> ffff88042e32c000 0000000100000000 ffff88042c361c20 ffff88042e32c000
[  333.800589] <0> ffff88042e32c018 0000000000000282 ffff88042e32c000 0000000000000000
[  333.800594] Call Trace:
[  333.800599]  [<ffffffff8149f3ff>] __delay+0xf/0x20
[  333.800604]  [<ffffffff814b075c>] do_raw_spin_lock+0x10c/0x170
[  333.800609]  [<ffffffff81a64fd8>] _raw_spin_lock_irqsave+0x68/0x90
[  333.800613]  [<ffffffff81090d8c>] ? lock_timer_base+0x3c/0x70
[  333.800617]  [<ffffffff81090d8c>] lock_timer_base+0x3c/0x70
[  333.800622]  [<ffffffff81090deb>] try_to_del_timer_sync+0x2b/0xf0
[  333.800626]  [<ffffffff810b4859>] ? trace_hardirqs_on_caller+0x29/0x1a0
[  333.800631]  [<ffffffff8109140a>] del_timer_sync+0x7a/0xa0
[  333.800635]  [<ffffffff81091390>] ? del_timer_sync+0x0/0xa0
[  333.800641]  [<ffffffff81a625a3>] schedule_timeout+0x1c3/0x330
[  333.800646]  [<ffffffff81090fa0>] ? process_timeout+0x0/0x10
[  333.800652]  [<ffffffff81a6276e>] schedule_timeout_interruptible+0x1e/0x20
[  333.800658]  [<ffffffff81196fbc>] bdi_writeback_task+0x12c/0x160
[  333.800663]  [<ffffffff810a0507>] ? bit_waitqueue+0x17/0xc0
[  333.800670]  [<ffffffff81139c40>] ? bdi_start_fn+0x0/0x100
[  333.800675]  [<ffffffff81139cc6>] bdi_start_fn+0x86/0x100
[  333.800680]  [<ffffffff81139c40>] ? bdi_start_fn+0x0/0x100
[  333.800684]  [<ffffffff810a00c6>] kthread+0xb6/0xc0
[  333.800689]  [<ffffffff810b4859>] ? trace_hardirqs_on_caller+0x29/0x1a0
[  333.800695]  [<ffffffff81036ed4>] kernel_thread_helper+0x4/0x10
[  333.800700]  [<ffffffff81a65820>] ? _raw_spin_unlock_irq+0x30/0x40
[  333.800704]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[  333.800708]  [<ffffffff81a65bfc>] ? restore_args+0x0/0x30
[  333.800713]  [<ffffffff810a0010>] ? kthread+0x0/0xc0
[  333.800718]  [<ffffffff81036ed0>] ? kernel_thread_helper+0x0/0x10
[  333.800720] Code: 04 25 58 d5 00 00 0f 1f 00 0f ae e8 0f 31 89 c6 eb 11 66 90 f3 90 65 8b 0c 25 58 d5 00 00 44 39 c1 75 17 0f 1f 00 0f ae e8 0f 31 <89> c0 48 89 c2 48 29 f2 48 39 d7 77 dc c9 c3 48 29 c6 48 01 f7 
[  333.800761] Call Trace:
[  333.800765]  [<ffffffff8149f3ff>] __delay+0xf/0x20
[  333.800769]  [<ffffffff814b075c>] do_raw_spin_lock+0x10c/0x170
[  333.800774]  [<ffffffff81a64fd8>] _raw_spin_lock_irqsave+0x68/0x90
[  333.800778]  [<ffffffff81090d8c>] ? lock_timer_base+0x3c/0x70
[  333.800783]  [<ffffffff81090d8c>] lock_timer_base+0x3c/0x70
[  333.800787]  [<ffffffff81090deb>] try_to_del_timer_sync+0x2b/0xf0
[  333.800791]  [<ffffffff810b4859>] ? trace_hardirqs_on_caller+0x29/0x1a0
[  333.800796]  [<ffffffff8109140a>] del_timer_sync+0x7a/0xa0
[  333.800799]  [<ffffffff81091390>] ? del_timer_sync+0x0/0xa0
[  333.800804]  [<ffffffff81a625a3>] schedule_timeout+0x1c3/0x330
[  333.800809]  [<ffffffff81090fa0>] ? process_timeout+0x0/0x10
[  333.800814]  [<ffffffff81a6276e>] schedule_timeout_interruptible+0x1e/0x20
[  333.800819]  [<ffffffff81196fbc>] bdi_writeback_task+0x12c/0x160
[  333.800823]  [<ffffffff810a0507>] ? bit_waitqueue+0x17/0xc0
[  333.800828]  [<ffffffff81139c40>] ? bdi_start_fn+0x0/0x100
[  333.800833]  [<ffffffff81139cc6>] bdi_start_fn+0x86/0x100
[  333.800837]  [<ffffffff81139c40>] ? bdi_start_fn+0x0/0x100
[  333.800841]  [<ffffffff810a00c6>] kthread+0xb6/0xc0
[  333.800846]  [<ffffffff810b4859>] ? trace_hardirqs_on_caller+0x29/0x1a0
[  333.800852]  [<ffffffff81036ed4>] kernel_thread_helper+0x4/0x10
[  333.800856]  [<ffffffff81a65820>] ? _raw_spin_unlock_irq+0x30/0x40
[  333.800860]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[  333.800864]  [<ffffffff81a65bfc>] ? restore_args+0x0/0x30
[  333.800869]  [<ffffffff810a0010>] ? kthread+0x0/0xc0
[  333.800873]  [<ffffffff81036ed0>] ? kernel_thread_helper+0x0/0x10
[  333.800878] Pid: 1447, comm: flush-1:0 Tainted: G        W   2.6.35-rc4-andres #9
[  333.800880] Call Trace:
[  333.800882]  <NMI>  [<ffffffff8103ea3b>] ? show_regs+0x2b/0x40
[  333.800889]  [<ffffffff81a675a2>] nmi_watchdog_tick+0x1b2/0x1e0
[  333.800894]  [<ffffffff81a66913>] do_nmi+0x1c3/0x2f0
[  333.800898]  [<ffffffff81a660ea>] nmi+0x1a/0x2c
[  333.800902]  [<ffffffff8149f447>] ? delay_tsc+0x37/0x60
[  333.800905]  <<EOE>>  [<ffffffff8149f3ff>] __delay+0xf/0x20
[  333.800912]  [<ffffffff814b075c>] do_raw_spin_lock+0x10c/0x170
[  333.800916]  [<ffffffff81a64fd8>] _raw_spin_lock_irqsave+0x68/0x90
[  333.800920]  [<ffffffff81090d8c>] ? lock_timer_base+0x3c/0x70
[  333.800925]  [<ffffffff81090d8c>] lock_timer_base+0x3c/0x70
[  333.800929]  [<ffffffff81090deb>] try_to_del_timer_sync+0x2b/0xf0
[  333.800934]  [<ffffffff810b4859>] ? trace_hardirqs_on_caller+0x29/0x1a0
[  333.800939]  [<ffffffff8109140a>] del_timer_sync+0x7a/0xa0
[  333.800943]  [<ffffffff81091390>] ? del_timer_sync+0x0/0xa0
[  333.800947]  [<ffffffff81a625a3>] schedule_timeout+0x1c3/0x330
[  333.800952]  [<ffffffff81090fa0>] ? process_timeout+0x0/0x10
[  333.800957]  [<ffffffff81a6276e>] schedule_timeout_interruptible+0x1e/0x20
[  333.800962]  [<ffffffff81196fbc>] bdi_writeback_task+0x12c/0x160
[  333.800966]  [<ffffffff810a0507>] ? bit_waitqueue+0x17/0xc0
[  333.800971]  [<ffffffff81139c40>] ? bdi_start_fn+0x0/0x100
[  333.800976]  [<ffffffff81139cc6>] bdi_start_fn+0x86/0x100
[  333.800980]  [<ffffffff81139c40>] ? bdi_start_fn+0x0/0x100
[  333.800984]  [<ffffffff810a00c6>] kthread+0xb6/0xc0
[  333.800989]  [<ffffffff810b4859>] ? trace_hardirqs_on_caller+0x29/0x1a0
[  333.800995]  [<ffffffff81036ed4>] kernel_thread_helper+0x4/0x10
[  333.800999]  [<ffffffff81a65820>] ? _raw_spin_unlock_irq+0x30/0x40
[  333.801003]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[  333.801007]  [<ffffffff81a65bfc>] ? restore_args+0x0/0x30
[  333.801011]  [<ffffffff810a0010>] ? kthread+0x0/0xc0
[  333.801016]  [<ffffffff81036ed0>] ? kernel_thread_helper+0x0/0x10
[  333.801021] NMI backtrace for cpu 4
[  333.801024] CPU 4 
[  333.801026] Modules linked in:
[  333.801029] 
[  333.801033] Pid: 556, comm: md1_raid1 Tainted: G        W   2.6.35-rc4-andres #9 S7002/empty
[  333.801037] RIP: 0010:[<ffffffff8149f447>]  [<ffffffff8149f447>] delay_tsc+0x37/0x60
[  333.801045] RSP: 0018:ffff880429a3f740  EFLAGS: 00000006
[  333.801049] RAX: 0000000005cc4dd2 RBX: ffff88042e32c000 RCX: 0000000000000001
[  333.801052] RDX: 00000000000000ce RSI: 0000000005cc4d93 RDI: 0000000000000001
[  333.801056] RBP: ffff880429a3f740 R08: 0000000000000004 R09: 0000000000000001
[  333.801060] R10: 0000000000000000 R11: 0000000000000001 R12: 000000008719e9c0
[  333.801064] R13: ffff880428dca360 R14: ffff880428dca820 R15: 000000000000021e
[  333.801069] FS:  0000000000000000(0000) GS:ffff880003a00000(0000) knlGS:0000000000000000
[  333.801073] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  333.801077] CR2: 00007f164a839040 CR3: 000000042c729000 CR4: 00000000000006e0
[  333.801080] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  333.801084] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  333.801088] Process md1_raid1 (pid: 556, threadinfo ffff880429a3e000, task ffff880428dca360)
[  333.801091] Stack:
[  333.801093]  ffff880429a3f750 ffffffff8149f3ff ffff880429a3f7a0 ffffffff814b075c
[  333.801098] <0> ffff88042e32c000 000000012aa80758 ffff880429a3f790 ffff88042e32c000
[  333.801104] <0> ffff88042e32c018 0000000000000082 ffff88042e32c000 ffff88042aa80758
[  333.801110] Call Trace:
[  333.801115]  [<ffffffff8149f3ff>] __delay+0xf/0x20
[  333.801121]  [<ffffffff814b075c>] do_raw_spin_lock+0x10c/0x170
[  333.801126]  [<ffffffff81a64fd8>] _raw_spin_lock_irqsave+0x68/0x90
[  333.801131]  [<ffffffff81090d8c>] ? lock_timer_base+0x3c/0x70
[  333.801136]  [<ffffffff81090d8c>] lock_timer_base+0x3c/0x70
[  333.801141]  [<ffffffff810918b2>] mod_timer+0x92/0x2e0
[  333.801149]  [<ffffffff8148749f>] blk_add_timer+0xcf/0xe0
[  333.801154]  [<ffffffff81480353>] blk_start_request+0x33/0x50
[  333.801161]  [<ffffffff816b077b>] scsi_request_fn+0x13b/0x620
[  333.801166]  [<ffffffff81481f94>] __blk_run_queue+0x64/0x160
[  333.801172]  [<ffffffff8147bd04>] elv_insert+0x144/0x200
[  333.801178]  [<ffffffff8147be32>] __elv_add_request+0x72/0xd0
[  333.801183]  [<ffffffff8148281c>] __make_request+0x12c/0x4c0
[  333.801188]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[  333.801194]  [<ffffffff81480734>] generic_make_request+0x284/0x500
[  333.801201]  [<ffffffff81122ce3>] ? mempool_alloc+0x63/0x150
[  333.801206]  [<ffffffff81122be5>] ? mempool_alloc_slab+0x15/0x20
[  333.801211]  [<ffffffff81a64f58>] ? _raw_spin_lock_irq+0x68/0x80
[  333.801216]  [<ffffffff81480a32>] submit_bio+0x82/0x110
[  333.801222]  [<ffffffff811a2d2c>] ? bio_clone+0x4c/0x90
[  333.801228]  [<ffffffff8185f2c6>] md_super_write+0xd6/0xe0
[  333.801233]  [<ffffffff818664ab>] write_page+0x28b/0x3c0
[  333.801238]  [<ffffffff81866360>] ? write_page+0x140/0x3c0
[  333.801244]  [<ffffffff810b4859>] ? trace_hardirqs_on_caller+0x29/0x1a0
[  333.801249]  [<ffffffff81867a86>] bitmap_daemon_work+0x4c6/0x540
[  333.801254]  [<ffffffff81a65870>] ? _raw_spin_unlock_irqrestore+0x40/0x60
[  333.801260]  [<ffffffff8186129b>] md_check_recovery+0x2b/0x560
[  333.801265]  [<ffffffff81840a09>] raid1d+0x49/0x1200
[  333.801270]  [<ffffffff8109140a>] ? del_timer_sync+0x7a/0xa0
[  333.801275]  [<ffffffff81091390>] ? del_timer_sync+0x0/0xa0
[  333.801281]  [<ffffffff81a625a3>] ? schedule_timeout+0x1c3/0x330
[  333.801286]  [<ffffffff81a64f95>] ? _raw_spin_lock_irqsave+0x25/0x90
[  333.801291]  [<ffffffff81090fa0>] ? process_timeout+0x0/0x10
[  333.801296]  [<ffffffff8185eb1c>] md_thread+0x5c/0x130
[  333.801302]  [<ffffffff810a0630>] ? autoremove_wake_function+0x0/0x40
[  333.801306]  [<ffffffff8185eac0>] ? md_thread+0x0/0x130
[  333.801311]  [<ffffffff810a00c6>] kthread+0xb6/0xc0
[  333.801316]  [<ffffffff810b4859>] ? trace_hardirqs_on_caller+0x29/0x1a0
[  333.801323]  [<ffffffff81036ed4>] kernel_thread_helper+0x4/0x10
[  333.801328]  [<ffffffff81a65820>] ? _raw_spin_unlock_irq+0x30/0x40
[  333.801332]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[  333.801337]  [<ffffffff81a65bfc>] ? restore_args+0x0/0x30
[  333.801342]  [<ffffffff810a0010>] ? kthread+0x0/0xc0
[  333.801347]  [<ffffffff81036ed0>] ? kernel_thread_helper+0x0/0x10
[  333.801350] Code: 04 25 58 d5 00 00 0f 1f 00 0f ae e8 0f 31 89 c6 eb 11 66 90 f3 90 65 8b 0c 25 58 d5 00 00 44 39 c1 75 17 0f 1f 00 0f ae e8 0f 31 <89> c0 48 89 c2 48 29 f2 48 39 d7 77 dc c9 c3 48 29 c6 48 01 f7 
[  333.801393] Call Trace:
[  333.801397]  [<ffffffff8149f3ff>] __delay+0xf/0x20
[  333.801402]  [<ffffffff814b075c>] do_raw_spin_lock+0x10c/0x170
[  333.801407]  [<ffffffff81a64fd8>] _raw_spin_lock_irqsave+0x68/0x90
[  333.801412]  [<ffffffff81090d8c>] ? lock_timer_base+0x3c/0x70
[  333.801416]  [<ffffffff81090d8c>] lock_timer_base+0x3c/0x70
[  333.801421]  [<ffffffff810918b2>] mod_timer+0x92/0x2e0
[  333.801426]  [<ffffffff8148749f>] blk_add_timer+0xcf/0xe0
[  333.801431]  [<ffffffff81480353>] blk_start_request+0x33/0x50
[  333.801436]  [<ffffffff816b077b>] scsi_request_fn+0x13b/0x620
[  333.801441]  [<ffffffff81481f94>] __blk_run_queue+0x64/0x160
[  333.801447]  [<ffffffff8147bd04>] elv_insert+0x144/0x200
[  333.801452]  [<ffffffff8147be32>] __elv_add_request+0x72/0xd0
[  333.801457]  [<ffffffff8148281c>] __make_request+0x12c/0x4c0
[  333.801462]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[  333.801467]  [<ffffffff81480734>] generic_make_request+0x284/0x500
[  333.801472]  [<ffffffff81122ce3>] ? mempool_alloc+0x63/0x150
[  333.801477]  [<ffffffff81122be5>] ? mempool_alloc_slab+0x15/0x20
[  333.801482]  [<ffffffff81a64f58>] ? _raw_spin_lock_irq+0x68/0x80
[  333.801487]  [<ffffffff81480a32>] submit_bio+0x82/0x110
[  333.801492]  [<ffffffff811a2d2c>] ? bio_clone+0x4c/0x90
[  333.801497]  [<ffffffff8185f2c6>] md_super_write+0xd6/0xe0
[  333.801503]  [<ffffffff818664ab>] write_page+0x28b/0x3c0
[  333.801508]  [<ffffffff81866360>] ? write_page+0x140/0x3c0
[  333.801513]  [<ffffffff810b4859>] ? trace_hardirqs_on_caller+0x29/0x1a0
[  333.801518]  [<ffffffff81867a86>] bitmap_daemon_work+0x4c6/0x540
[  333.801523]  [<ffffffff81a65870>] ? _raw_spin_unlock_irqrestore+0x40/0x60
[  333.801529]  [<ffffffff8186129b>] md_check_recovery+0x2b/0x560
[  333.801533]  [<ffffffff81840a09>] raid1d+0x49/0x1200
[  333.801538]  [<ffffffff8109140a>] ? del_timer_sync+0x7a/0xa0
[  333.801543]  [<ffffffff81091390>] ? del_timer_sync+0x0/0xa0
[  333.801549]  [<ffffffff81a625a3>] ? schedule_timeout+0x1c3/0x330
[  333.801553]  [<ffffffff81a64f95>] ? _raw_spin_lock_irqsave+0x25/0x90
[  333.801559]  [<ffffffff81090fa0>] ? process_timeout+0x0/0x10
[  333.801564]  [<ffffffff8185eb1c>] md_thread+0x5c/0x130
[  333.801569]  [<ffffffff810a0630>] ? autoremove_wake_function+0x0/0x40
[  333.801574]  [<ffffffff8185eac0>] ? md_thread+0x0/0x130
[  333.801579]  [<ffffffff810a00c6>] kthread+0xb6/0xc0
[  333.801584]  [<ffffffff810b4859>] ? trace_hardirqs_on_caller+0x29/0x1a0
[  333.801590]  [<ffffffff81036ed4>] kernel_thread_helper+0x4/0x10
[  333.801595]  [<ffffffff81a65820>] ? _raw_spin_unlock_irq+0x30/0x40
[  333.801600]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[  333.801604]  [<ffffffff81a65bfc>] ? restore_args+0x0/0x30
[  333.801609]  [<ffffffff810a0010>] ? kthread+0x0/0xc0
[  333.801614]  [<ffffffff81036ed0>] ? kernel_thread_helper+0x0/0x10
[  333.801619] Pid: 556, comm: md1_raid1 Tainted: G        W   2.6.35-rc4-andres #9
[  333.801622] Call Trace:
[  333.801624]  <NMI>  [<ffffffff8103ea3b>] ? show_regs+0x2b/0x40
[  333.801632]  [<ffffffff81a675a2>] nmi_watchdog_tick+0x1b2/0x1e0
[  333.801637]  [<ffffffff81a66913>] do_nmi+0x1c3/0x2f0
[  333.801642]  [<ffffffff81a660ea>] nmi+0x1a/0x2c
[  333.801647]  [<ffffffff8149f447>] ? delay_tsc+0x37/0x60
[  333.801650]  <<EOE>>  [<ffffffff8149f3ff>] __delay+0xf/0x20
[  333.801658]  [<ffffffff814b075c>] do_raw_spin_lock+0x10c/0x170
[  333.801663]  [<ffffffff81a64fd8>] _raw_spin_lock_irqsave+0x68/0x90
[  333.801668]  [<ffffffff81090d8c>] ? lock_timer_base+0x3c/0x70
[  333.801673]  [<ffffffff81090d8c>] lock_timer_base+0x3c/0x70
[  333.801677]  [<ffffffff810918b2>] mod_timer+0x92/0x2e0
[  333.801683]  [<ffffffff8148749f>] blk_add_timer+0xcf/0xe0
[  333.801688]  [<ffffffff81480353>] blk_start_request+0x33/0x50
[  333.801693]  [<ffffffff816b077b>] scsi_request_fn+0x13b/0x620
[  333.801698]  [<ffffffff81481f94>] __blk_run_queue+0x64/0x160
[  333.801704]  [<ffffffff8147bd04>] elv_insert+0x144/0x200
[  333.801709]  [<ffffffff8147be32>] __elv_add_request+0x72/0xd0
[  333.801715]  [<ffffffff8148281c>] __make_request+0x12c/0x4c0
[  333.801720]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[  333.801725]  [<ffffffff81480734>] generic_make_request+0x284/0x500
[  333.801730]  [<ffffffff81122ce3>] ? mempool_alloc+0x63/0x150
[  333.801736]  [<ffffffff81122be5>] ? mempool_alloc_slab+0x15/0x20
[  333.801740]  [<ffffffff81a64f58>] ? _raw_spin_lock_irq+0x68/0x80
[  333.801746]  [<ffffffff81480a32>] submit_bio+0x82/0x110
[  333.801750]  [<ffffffff811a2d2c>] ? bio_clone+0x4c/0x90
[  333.801756]  [<ffffffff8185f2c6>] md_super_write+0xd6/0xe0
[  333.801761]  [<ffffffff818664ab>] write_page+0x28b/0x3c0
[  333.801766]  [<ffffffff81866360>] ? write_page+0x140/0x3c0
[  333.801772]  [<ffffffff810b4859>] ? trace_hardirqs_on_caller+0x29/0x1a0
[  333.801777]  [<ffffffff81867a86>] bitmap_daemon_work+0x4c6/0x540
[  333.801783]  [<ffffffff81a65870>] ? _raw_spin_unlock_irqrestore+0x40/0x60
[  333.801788]  [<ffffffff8186129b>] md_check_recovery+0x2b/0x560
[  333.801793]  [<ffffffff81840a09>] raid1d+0x49/0x1200
[  333.801798]  [<ffffffff8109140a>] ? del_timer_sync+0x7a/0xa0
[  333.801802]  [<ffffffff81091390>] ? del_timer_sync+0x0/0xa0
[  333.801808]  [<ffffffff81a625a3>] ? schedule_timeout+0x1c3/0x330
[  333.801813]  [<ffffffff81a64f95>] ? _raw_spin_lock_irqsave+0x25/0x90
[  333.801818]  [<ffffffff81090fa0>] ? process_timeout+0x0/0x10
[  333.801823]  [<ffffffff8185eb1c>] md_thread+0x5c/0x130
[  333.801828]  [<ffffffff810a0630>] ? autoremove_wake_function+0x0/0x40
[  333.801833]  [<ffffffff8185eac0>] ? md_thread+0x0/0x130
[  333.801838]  [<ffffffff810a00c6>] kthread+0xb6/0xc0
[  333.801844]  [<ffffffff810b4859>] ? trace_hardirqs_on_caller+0x29/0x1a0
[  333.801849]  [<ffffffff81036ed4>] kernel_thread_helper+0x4/0x10
[  333.801854]  [<ffffffff81a65820>] ? _raw_spin_unlock_irq+0x30/0x40
[  333.801859]  [<ffffffff810b49dd>] ? trace_hardirqs_on+0xd/0x10
[  333.801863]  [<ffffffff81a65bfc>] ? restore_args+0x0/0x30
[  333.801868]  [<ffffffff810a0010>] ? kthread+0x0/0xc0
[  333.801874]  [<ffffffff81036ed0>] ? kernel_thread_helper+0x0/0x10
[  335.913827] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
[  345.144972] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
[  350.017650] EXT4-fs (dm-4): mounted filesystem with ordered data mode. Opts: (null)
[  352.746761] vgaarb: device changed decodes: PCI:0000:08:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
[  352.746766] vgaarb: transferring owner from PCI:0000:08:00.0 to PCI:0000:01:00.0
[  353.425526] netconsole: network logging stopped, interface virbr0 unregistered
[  354.311381] lo: Disabled Privacy Extensions
[  354.398837] netconsole: network logging stopped, interface lo unregistered
[  370.617435] md: md3: resync done.
[  370.671299] RAID10 conf printout:
[  370.671305]  --- wd:6 rd:6
[  370.671310]  disk 0, wo:0, o:1, dev:sdc
[  370.671314]  disk 1, wo:0, o:1, dev:sdd
[  370.671319]  disk 2, wo:0, o:1, dev:sde
[  370.671322]  disk 3, wo:0, o:1, dev:sdf
[  370.671326]  disk 4, wo:0, o:1, dev:sdg
[  370.671331]  disk 5, wo:0, o:1, dev:sdh

--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=lspci

00:00.0 Host bridge: Intel Corporation 5500 I/O Hub to ESI Port (rev 13)
	Subsystem: Intel Corporation Device 0000
	Flags: fast devsel
	Capabilities: [60] Message Signalled Interrupts: Mask+ 64bit- Queue=0/1 Enable-
	Capabilities: [90] Express Root Port (Slot-), MSI 00
	Capabilities: [e0] Power Management version 3
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [150] Access Controls <?>
	Capabilities: [160] Vendor Specific Information <?>

00:01.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port 1 (rev 13)
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=0a, subordinate=0a, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fbc00000-fbefffff
	Capabilities: [40] Subsystem: Intel Corporation Device 0000
	Capabilities: [60] Message Signalled Interrupts: Mask+ 64bit- Queue=0/1 Enable+
	Capabilities: [90] Express Root Port (Slot+), MSI 00
	Capabilities: [e0] Power Management version 3
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [150] Access Controls <?>
	Capabilities: [160] Vendor Specific Information <?>
	Kernel driver in use: pcieport

00:03.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port 3 (rev 13)
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=09, subordinate=09, sec-latency=0
	Capabilities: [40] Subsystem: Intel Corporation Device 0000
	Capabilities: [60] Message Signalled Interrupts: Mask+ 64bit- Queue=0/1 Enable+
	Capabilities: [90] Express Root Port (Slot+), MSI 00
	Capabilities: [e0] Power Management version 3
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [150] Access Controls <?>
	Capabilities: [160] Vendor Specific Information <?>
	Kernel driver in use: pcieport

00:07.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port 7 (rev 13)
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=08, subordinate=08, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fbb00000-fbbfffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
	Capabilities: [40] Subsystem: Intel Corporation Device 0000
	Capabilities: [60] Message Signalled Interrupts: Mask+ 64bit- Queue=0/1 Enable+
	Capabilities: [90] Express Root Port (Slot+), MSI 00
	Capabilities: [e0] Power Management version 3
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [150] Access Controls <?>
	Capabilities: [160] Vendor Specific Information <?>
	Kernel driver in use: pcieport

00:08.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port 8 (rev 13)
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=07, subordinate=07, sec-latency=0
	Capabilities: [40] Subsystem: Intel Corporation Device 0000
	Capabilities: [60] Message Signalled Interrupts: Mask+ 64bit- Queue=0/1 Enable+
	Capabilities: [90] Express Root Port (Slot-), MSI 00
	Capabilities: [e0] Power Management version 3
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [150] Access Controls <?>
	Kernel driver in use: pcieport

00:09.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port 9 (rev 13)
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
	Capabilities: [40] Subsystem: Intel Corporation Device 0000
	Capabilities: [60] Message Signalled Interrupts: Mask+ 64bit- Queue=0/1 Enable+
	Capabilities: [90] Express Root Port (Slot-), MSI 00
	Capabilities: [e0] Power Management version 3
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [150] Access Controls <?>
	Kernel driver in use: pcieport

00:0a.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port 10 (rev 13)
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	Capabilities: [40] Subsystem: Intel Corporation Device 0000
	Capabilities: [60] Message Signalled Interrupts: Mask+ 64bit- Queue=0/1 Enable+
	Capabilities: [90] Express Root Port (Slot-), MSI 00
	Capabilities: [e0] Power Management version 3
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [150] Access Controls <?>
	Kernel driver in use: pcieport

00:13.0 PIC: Intel Corporation 5520/5500/X58 I/O Hub I/OxAPIC Interrupt Controller (rev 13) (prog-if 20)
	Flags: bus master, fast devsel, latency 0
	Memory at fec8a000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [6c] Power Management version 3

00:14.0 PIC: Intel Corporation 5520/5500/X58 I/O Hub System Management Registers (rev 13)
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00
	Kernel driver in use: i7core_edac

00:14.1 PIC: Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch Pad Registers (rev 13)
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

00:14.2 PIC: Intel Corporation 5520/5500/X58 I/O Hub Control Status and RAS Registers (rev 13)
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

00:14.3 PIC: Intel Corporation 5520/5500/X58 I/O Hub Throttle Registers (rev 13)
	Flags: fast devsel

00:16.0 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 13)
	Subsystem: Intel Corporation Device 0000
	Flags: bus master, fast devsel, latency 0, IRQ 43
	Memory at fb8d4000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable+ Mask- TabSize=1
	Capabilities: [90] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [e0] Power Management version 3
	Kernel driver in use: ioatdma

00:16.1 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 13)
	Subsystem: Intel Corporation Device 0000
	Flags: bus master, fast devsel, latency 0, IRQ 44
	Memory at fb8d8000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable+ Mask- TabSize=1
	Capabilities: [90] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [e0] Power Management version 3
	Kernel driver in use: ioatdma

00:16.2 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 13)
	Subsystem: Intel Corporation Device 0000
	Flags: bus master, fast devsel, latency 0, IRQ 45
	Memory at fb8dc000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable+ Mask- TabSize=1
	Capabilities: [90] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [e0] Power Management version 3
	Kernel driver in use: ioatdma

00:16.3 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 13)
	Subsystem: Intel Corporation Device 0000
	Flags: bus master, fast devsel, latency 0, IRQ 46
	Memory at fb8e0000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable+ Mask- TabSize=1
	Capabilities: [90] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [e0] Power Management version 3
	Kernel driver in use: ioatdma

00:16.4 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 13)
	Subsystem: Intel Corporation Device 0000
	Flags: bus master, fast devsel, latency 0, IRQ 43
	Memory at fb8e4000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable+ Mask- TabSize=1
	Capabilities: [90] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [e0] Power Management version 3
	Kernel driver in use: ioatdma

00:16.5 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 13)
	Subsystem: Intel Corporation Device 0000
	Flags: bus master, fast devsel, latency 0, IRQ 44
	Memory at fb8e8000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable+ Mask- TabSize=1
	Capabilities: [90] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [e0] Power Management version 3
	Kernel driver in use: ioatdma

00:16.6 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 13)
	Subsystem: Intel Corporation Device 0000
	Flags: bus master, fast devsel, latency 0, IRQ 45
	Memory at fb8ec000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable+ Mask- TabSize=1
	Capabilities: [90] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [e0] Power Management version 3
	Kernel driver in use: ioatdma

00:16.7 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 13)
	Subsystem: Intel Corporation Device 0000
	Flags: bus master, fast devsel, latency 0, IRQ 46
	Memory at fb8f0000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable+ Mask- TabSize=1
	Capabilities: [90] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [e0] Power Management version 3
	Kernel driver in use: ioatdma

00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #4
	Subsystem: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #4
	Flags: bus master, medium devsel, latency 0, IRQ 16
	I/O ports at 7400 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd

00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #5
	Subsystem: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #5
	Flags: bus master, medium devsel, latency 0, IRQ 21
	I/O ports at 7480 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd

00:1a.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #6
	Subsystem: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #6
	Flags: bus master, medium devsel, latency 0, IRQ 19
	I/O ports at 7800 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd

00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #2 (prog-if 20)
	Subsystem: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #2
	Flags: bus master, medium devsel, latency 0, IRQ 18
	Memory at fb8f6000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCIe advanced features <?>
	Kernel driver in use: ehci_hcd

00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Root Port 1
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: c0000000-c01fffff
	Prefetchable memory behind bridge: 00000000c0200000-00000000c03fffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
	Capabilities: [90] Subsystem: Intel Corporation 82801JI (ICH10 Family) PCI Express Root Port 1
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport

00:1c.4 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Root Port 5
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: fba00000-fbafffff
	Prefetchable memory behind bridge: 00000000c0400000-00000000c05fffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
	Capabilities: [90] Subsystem: Intel Corporation 82801JI (ICH10 Family) PCI Express Root Port 5
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport

00:1c.5 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Root Port 6
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000b000-0000bfff
	Memory behind bridge: fb900000-fb9fffff
	Prefetchable memory behind bridge: 00000000c0600000-00000000c07fffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
	Capabilities: [90] Subsystem: Intel Corporation 82801JI (ICH10 Family) PCI Express Root Port 6
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport

00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #1
	Subsystem: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #1
	Flags: bus master, medium devsel, latency 0, IRQ 23
	I/O ports at 7880 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #2
	Subsystem: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #2
	Flags: bus master, medium devsel, latency 0, IRQ 19
	I/O ports at 7c00 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #3
	Subsystem: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #3
	Flags: bus master, medium devsel, latency 0, IRQ 18
	I/O ports at 8000 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #1 (prog-if 20)
	Subsystem: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #1
	Flags: bus master, medium devsel, latency 0, IRQ 23
	Memory at fb8f8000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCIe advanced features <?>
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90) (prog-if 01)
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
	I/O behind bridge: 0000a000-0000afff
	Memory behind bridge: faf00000-fb7fffff
	Capabilities: [50] Subsystem: Intel Corporation 82801 PCI Bridge

00:1f.0 ISA bridge: Intel Corporation 82801JIR (ICH10R) LPC Interface Controller
	Subsystem: Intel Corporation 82801JIR (ICH10R) LPC Interface Controller
	Flags: bus master, medium devsel, latency 0
	Capabilities: [e0] Vendor Specific Information <?>

00:1f.2 IDE interface: Intel Corporation 82801JI (ICH10 Family) 4 port SATA IDE Controller #1 (prog-if 8f [Master SecP SecO PriP PriO])
	Subsystem: Intel Corporation 82801JI (ICH10 Family) 4 port SATA IDE Controller #1
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 19
	I/O ports at 8c00 [size=8]
	I/O ports at 8880 [size=4]
	I/O ports at 8800 [size=8]
	I/O ports at 8480 [size=4]
	I/O ports at 8400 [size=16]
	I/O ports at 8080 [size=16]
	Capabilities: [70] Power Management version 3
	Capabilities: [b0] PCIe advanced features <?>
	Kernel driver in use: ata_piix

00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
	Subsystem: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
	Flags: medium devsel, IRQ 18
	Memory at fb8fa000 (64-bit, non-prefetchable) [size=256]
	I/O ports at 0400 [size=32]
	Kernel driver in use: i801_smbus

00:1f.5 IDE interface: Intel Corporation 82801JI (ICH10 Family) 2 port SATA IDE Controller #2 (prog-if 85 [Master SecO PriO])
	Subsystem: Intel Corporation 82801JI (ICH10 Family) 2 port SATA IDE Controller #2
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 19
	I/O ports at 9c00 [size=8]
	I/O ports at 9880 [size=4]
	I/O ports at 9800 [size=8]
	I/O ports at 9480 [size=4]
	I/O ports at 9400 [size=16]
	I/O ports at 9080 [size=16]
	Capabilities: [70] Power Management version 3
	Capabilities: [b0] PCIe advanced features <?>
	Kernel driver in use: ata_piix

01:00.0 VGA compatible controller: ASPEED Technology, Inc. ASPEED Graphics Family (rev 10)
	Subsystem: ASPEED Technology, Inc. ASPEED Graphics Family
	Flags: medium devsel, IRQ 10
	Memory at fb000000 (32-bit, non-prefetchable) [disabled] [size=8M]
	Memory at fafe0000 (32-bit, non-prefetchable) [disabled] [size=128K]
	I/O ports at ac00 [disabled] [size=128]
	Capabilities: [40] Power Management version 3

02:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
	Subsystem: Intel Corporation Device 0000
	Flags: bus master, fast devsel, latency 0, IRQ 17
	Memory at fb9e0000 (32-bit, non-prefetchable) [size=128K]
	I/O ports at bc00 [size=32]
	Memory at fb9dc000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [c8] Power Management version 2
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
	Capabilities: [e0] Express Endpoint, MSI 00
	Capabilities: [a0] MSI-X: Enable+ Mask- TabSize=5
	Capabilities: [100] Advanced Error Reporting <?>
	Kernel driver in use: e1000e

03:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
	Subsystem: Intel Corporation Device 0000
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at fbae0000 (32-bit, non-prefetchable) [size=128K]
	I/O ports at cc00 [size=32]
	Memory at fbadc000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [c8] Power Management version 2
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
	Capabilities: [e0] Express Endpoint, MSI 00
	Capabilities: [a0] MSI-X: Enable+ Mask- TabSize=5
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [140] Device Serial Number 4a-df-b8-ff-ff-81-e0-00
	Kernel driver in use: e1000e

08:00.0 VGA compatible controller: ATI Technologies Inc RV710 [Radeon HD 4350]
	Subsystem: ASUSTeK Computer Inc. Device 032e
	Flags: bus master, fast devsel, latency 0, IRQ 74
	Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Memory at fbbe0000 (64-bit, non-prefetchable) [size=64K]
	I/O ports at d000 [size=256]
	Expansion ROM at fbbc0000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 3
	Capabilities: [58] Express Legacy Endpoint, MSI 00
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
	Capabilities: [100] Vendor Specific Information <?>
	Kernel driver in use: radeon

08:00.1 Audio device: ATI Technologies Inc RV710/730
	Subsystem: ASUSTeK Computer Inc. Device aa38
	Flags: bus master, fast devsel, latency 0, IRQ 5
	Memory at fbbfc000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 3
	Capabilities: [58] Express Legacy Endpoint, MSI 00
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
	Capabilities: [100] Vendor Specific Information <?>

0a:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068E PCI-Express Fusion-MPT SAS (rev 08)
	Subsystem: LSI Logic / Symbios Logic Device 1000
	Flags: bus master, fast devsel, latency 0, IRQ 28
	I/O ports at e000 [size=256]
	Memory at fbefc000 (64-bit, non-prefetchable) [size=16K]
	Memory at fbee0000 (64-bit, non-prefetchable) [size=64K]
	Expansion ROM at fbc00000 [disabled] [size=2M]
	Capabilities: [50] Power Management version 2
	Capabilities: [68] Express Endpoint, MSI 00
	Capabilities: [98] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
	Capabilities: [b0] MSI-X: Enable- Mask- TabSize=1
	Capabilities: [100] Advanced Error Reporting <?>
	Kernel driver in use: mptsas

fe:00.0 Host bridge: Intel Corporation Xeon 5500/Core i7 QuickPath Architecture Generic Non-Core Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

fe:00.1 Host bridge: Intel Corporation Xeon 5500/Core i7 QuickPath Architecture System Address Decoder (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

fe:02.0 Host bridge: Intel Corporation Xeon 5500/Core i7 QPI Link 0 (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

fe:02.1 Host bridge: Intel Corporation Xeon 5500/Core i7 QPI Physical 0 (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

fe:02.4 Host bridge: Intel Corporation Xeon 5500/Core i7 QPI Link 1 (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

fe:02.5 Host bridge: Intel Corporation Xeon 5500/Core i7 QPI Physical 1 (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

fe:03.0 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

fe:03.1 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Target Address Decoder (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

fe:03.2 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller RAS Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

fe:03.4 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Test Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

fe:04.0 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 0 Control Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

fe:04.1 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 0 Address Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

fe:04.2 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 0 Rank Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

fe:04.3 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 0 Thermal Control Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

fe:05.0 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 1 Control Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

fe:05.1 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 1 Address Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

fe:05.2 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 1 Rank Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

fe:05.3 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 1 Thermal Control Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

fe:06.0 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 2 Control Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

fe:06.1 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 2 Address Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

fe:06.2 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 2 Rank Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

fe:06.3 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 2 Thermal Control Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.35-rc4
# Thu Jul  8 00:53:19 2010
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
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
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
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
CONFIG_HAVE_INTEL_TXT=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION="-andres"
CONFIG_LOCALVERSION_AUTO=y
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
CONFIG_BSD_PROCESS_ACCT_V3=y
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
CONFIG_LOG_BUF_SHIFT=18
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_CGROUP_MEM_RES_CTLR=y
CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_BLK_CGROUP is not set
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
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
CONFIG_PERF_COUNTERS=y
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
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
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
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
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
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
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
# CONFIG_INLINE_SPIN_UNLOCK is not set
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
# CONFIG_X86_X2APIC is not set
CONFIG_SPARSE_IRQ=y
CONFIG_NUMA_IRQ_DESC=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
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
CONFIG_MCORE2=y
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=7
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
# CONFIG_AMD_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_IOMMU_API=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=64
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
# CONFIG_K8_NUMA is not set
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
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
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_HWPOISON_INJECT is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
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
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

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
CONFIG_SUSPEND_NVS=y
CONFIG_SUSPEND=y
CONFIG_PM_TEST_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_RUNTIME=y
CONFIG_PM_OPS=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_POWER_METER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
# CONFIG_ACPI_APEI_EINJ is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_INTEL_IDLE is not set

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
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_DMAR=y
CONFIG_DMAR_DEFAULT_ON=y
CONFIG_DMAR_FLOPPY_WA=y
CONFIG_INTR_REMAP=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
CONFIG_PCI_IOV=y
CONFIG_PCI_IOAPIC=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
CONFIG_HOTPLUG_PCI_CPCI=y
# CONFIG_HOTPLUG_PCI_CPCI_ZT5550 is not set
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=y
CONFIG_HOTPLUG_PCI_SHPC=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y

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
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
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
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
CONFIG_IP_MROUTE=y
# CONFIG_IP_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_HYBLA is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_VENO is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
# CONFIG_IPV6_SIT is not set
# CONFIG_IPV6_TUNNEL is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
# CONFIG_NETFILTER_NETLINK_LOG is not set
# CONFIG_NF_CONNTRACK is not set
# CONFIG_NETFILTER_XTABLES is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
# CONFIG_IP_NF_QUEUE is not set
# CONFIG_IP_NF_IPTABLES is not set
# CONFIG_IP_NF_ARPTABLES is not set

#
# IPv6: Netfilter Configuration
#
# CONFIG_IP6_NF_QUEUE is not set
# CONFIG_IP6_NF_IPTABLES is not set
# CONFIG_BRIDGE_NF_EBTABLES is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_INGRESS is not set

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
# CONFIG_NET_EMATCH_NBYTE is not set
# CONFIG_NET_EMATCH_U32 is not set
# CONFIG_NET_EMATCH_META is not set
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
# CONFIG_NET_ACT_GACT is not set
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_NAT is not set
# CONFIG_NET_ACT_PEDIT is not set
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_RPS=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#

#
# Some wireless drivers require a rate control algorithm
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE="radeon/R700_rlc.bin"
CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware"
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=65536
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_AD525X_DPOT is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_CS5535_MFGPT is not set
# CONFIG_HP_ILO is not set
# CONFIG_ISL29003 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_DS1682 is not set
# CONFIG_TI_DAC7512 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SAS_LIBSAS_DEBUG=y
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS_LOGGING=y
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
# CONFIG_SCSI_DH_HP_SW is not set
# CONFIG_SCSI_DH_EMC is not set
# CONFIG_SCSI_DH_ALUA is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_ACPI=y
CONFIG_ATA_GENERIC=y
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MULTICORE_RAID456=y
CONFIG_MD_RAID6_PQ=y
# CONFIG_ASYNC_RAID6_TEST is not set
CONFIG_MD_MULTIPATH=y
CONFIG_MD_FAULTY=y
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_MIRROR=y
CONFIG_DM_LOG_USERSPACE=y
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
CONFIG_DM_MULTIPATH_QL=y
CONFIG_DM_MULTIPATH_ST=y
CONFIG_DM_DELAY=y
CONFIG_DM_UEVENT=y
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
CONFIG_FUSION_LAN=y
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
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_IFB is not set
CONFIG_DUMMY=y
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=y
CONFIG_VETH=y
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
# CONFIG_MICREL_PHY is not set
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_GPIO=y
# CONFIG_NET_ETHERNET is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
CONFIG_E1000E=y
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PLIP is not set
CONFIG_PPP=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
# CONFIG_PPP_DEFLATE is not set
# CONFIG_PPP_BSDCOMP is not set
# CONFIG_PPP_MPPE is not set
# CONFIG_PPPOE is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VIRTIO_NET=y
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
# CONFIG_INPUT_SPARSEKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_DB9 is not set
# CONFIG_JOYSTICK_GAMECON is not set
# CONFIG_JOYSTICK_TURBOGRAFX is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_JOYSTICK_WALKERA0701 is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_GTCO is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
# CONFIG_TOUCHSCREEN_AD7877 is not set
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
# CONFIG_TOUCHSCREEN_AD7879_SPI is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_DA9034 is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_TWL4030_PWRBUTTON is not set
# CONFIG_INPUT_TWL4030_VIBRA is not set
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_WINBOND_CIR is not set
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_N_GSM is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=48
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=0
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_RAMOOPS is not set
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_PIIX4=y
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
CONFIG_I2C_SCMI=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_GPIO=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set

#
# PPS support
#
# CONFIG_PPS is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y

#
# Memory mapped GPIO expanders:
#
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_SCH is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_TWL4030 is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_CS5535 is not set
# CONFIG_GPIO_BT8XX is not set
CONFIG_GPIO_LANGWELL=y
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MCP23S08 is not set
# CONFIG_GPIO_MC33880 is not set

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9030 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADCXX=y
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_MAX1111=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=y
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_HDAPS is not set
CONFIG_SENSORS_LIS3_I2C=y
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ATK0110=y
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
# CONFIG_TWL4030_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=y
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_MFD_SUPPORT=y
CONFIG_MFD_CORE=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_CODEC is not set
# CONFIG_MFD_TC35892 is not set
# CONFIG_MFD_TMIO is not set
CONFIG_PMIC_DA903X=y
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_MC13783 is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_AB8500_CORE is not set
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_LPC_SCH=y
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_DUMMY is not set
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_BQ24022 is not set
# CONFIG_REGULATOR_MAX1586 is not set
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_TWL4030=y
# CONFIG_REGULATOR_DA903X is not set
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_TPS65023 is not set
# CONFIG_REGULATOR_TPS6507X is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_TTM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_KMS=y
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
CONFIG_FB_ASILIANT=y
CONFIG_FB_IMSTT=y
CONFIG_FB_VGA16=y
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_DA903X is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=256
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=y
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=y
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
# CONFIG_SND_PORTMAN2X4 is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_SPI=y
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=y
# CONFIG_SND_USB_UA101 is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set
# CONFIG_SND_USB_US122L is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
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
# CONFIG_HID_CANDO is not set
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EGALAX is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_KYE=y
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LOGITECH=y
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
# CONFIG_LOGIG940_FF is not set
CONFIG_HID_MICROSOFT=y
# CONFIG_HID_MOSART is not set
CONFIG_HID_MONTEREY=y
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_QUANTA is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_ROCCAT_KONE is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_STANTUM is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_TWL4030_USB is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_DA903X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_LT3593 is not set
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_DECODE_MCE is not set
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_MCE=y
CONFIG_EDAC_E752X=y
CONFIG_EDAC_I82975X=y
CONFIG_EDAC_I3000=y
CONFIG_EDAC_I3200=y
# CONFIG_EDAC_X38 is not set
CONFIG_EDAC_I5400=y
CONFIG_EDAC_I7CORE=y
CONFIG_EDAC_I5000=y
CONFIG_EDAC_I5100=y
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_TWL4030 is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_R9701 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_DS3234 is not set
# CONFIG_RTC_DRV_PCF2123 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH=y
CONFIG_INTEL_IOATDMA=y
# CONFIG_TIMB_DMA is not set
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
CONFIG_DCA=y
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_ISCSI_IBFT is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
CONFIG_XFS_DEBUG=y
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_NILFS2_FS is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
# CONFIG_QFMT_V1 is not set
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
CONFIG_CUSE=y
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
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=y
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
# CONFIG_NFS_V4_1 is not set
CONFIG_NFSD=y
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_RPCSEC_GSS_KRB5=y
CONFIG_RPCSEC_GSS_SPKM3=y
# CONFIG_SMB_FS is not set
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=y
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
# CONFIG_CIFS_WEAK_PW_HASH is not set
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DFS_UPCALL is not set
CONFIG_CIFS_EXPERIMENTAL=y
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-15"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
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
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_RCU_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST_RUNNABLE is not set
CONFIG_RCU_CPU_STALL_DETECTOR=y
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_LKDTM is not set
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FTRACE_NMI_ENTER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_FTRACE_NMI_ENTER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
CONFIG_FTRACE_SYSCALLS=y
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
CONFIG_DYNAMIC_FTRACE=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
# CONFIG_MMIOTRACE_TEST is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
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
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
# CONFIG_INTEL_TXT is not set
# CONFIG_DEFAULT_SECURITY_SELINUX is not set
# CONFIG_DEFAULT_SECURITY_SMACK is not set
# CONFIG_DEFAULT_SECURITY_TOMOYO is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
# CONFIG_CRYPTO_AES is not set
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
# CONFIG_KVM_AMD is not set
CONFIG_VHOST_NET=y
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y

--huq684BweRXVnRxX--
