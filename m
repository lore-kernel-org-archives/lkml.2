Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab0HXBBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 21:01:14 -0400
Received: from mailout-us.gmx.com ([74.208.5.67]:57412 "HELO
	mailout-us.gmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751592Ab0HXBBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 21:01:09 -0400
X-Authenticated: #65048216
X-Provags-ID: V01U2FsdGVkX1/zu25qGzXz07/Lg+wLBQ7QiE8B/nDw/6Me40AAiK
	2T8prbr9gVrfiN
Subject: i915: 2.6.36-rc2 wrong resolution on gdm start
From: Ivan Bulatovic <combuster@gmx.com>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, jbarnes@virtuousgeek.org, eric@anholt.net
Content-Type: multipart/mixed; boundary="=-OBN4LlFZ77jFHrUcDmS8"
Date: Tue, 24 Aug 2010 03:00:55 +0200
Message-ID: <1282611655.2177.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OBN4LlFZ77jFHrUcDmS8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

While in init3, resolution is native, KMS works fine, no problems at
all. As soon as gdm starts it seems that TV1 output is recognized as
connected even if it isn't so resolution on VGA output is degraded from
native 1280x1024 to 1024x768 on startup.

I've disabled LVDS output with video=LVDS-1:d because the cable looses
connection in certain lid positions.

2.6.36-rc1 didn't have this issue, 2.6.36-rc2 did so I've bisected and
it came down to this commit:

9d0498a2bf7455159b317f19531a3e5db2ecc9c4 is the first bad commit
commit 9d0498a2bf7455159b317f19531a3e5db2ecc9c4
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Wed Aug 18 13:20:54 2010 -0700

    drm/i915: wait for actual vblank, not just 20ms
    
Waiting for a hard coded 20ms isn't always enough to make sure a vblank
period has actually occurred, so add code to make sure we really have
passed through a vblank period (or that the pipe is off when disabling).
    
This prevents problems with mode setting and link training, and seems to
fix a bug like https://bugs.freedesktop.org/show_bug.cgi?id=29278, but
on an HP 8440p instead.  Hopefully also fixes
https://bugs.freedesktop.org/show_bug.cgi?id=29141.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>

:040000 040000 9941813d0f0bc4e141a87696d34f1d1b9087711b
2e407ad1d03b60f0e5b020313a8a63bd176b4005 M drivers

I'm sending you dmesg, xorg and xrandr logs as attachements. GM965 on
DELL Vostro 1310 is in question. Thanks,

Ivan

--=-OBN4LlFZ77jFHrUcDmS8
Content-Disposition: attachment; filename="dmesg.log.1"
Content-Type: text/plain; name="dmesg.log.1"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.35-BISECT+ (root@vostro) (gcc version 4.5.1 (GCC) ) #8 SMP PREEMPT Tue Aug 24 02:13:06 CEST 2010
[    0.000000] Command line: root=/dev/sda1 ro video=LVDS-1:d
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f6d0000 (usable)
[    0.000000]  BIOS-e820: 000000007f6d0000 - 000000007f6e3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007f6e3000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x7f6d0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 07F700000 mask FFFF00000 uncachable
[    0.000000]   2 base 07F800000 mask FFF800000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2039MB, range: 1MB, type UC
[    0.000000] reg 2, base: 2040MB, range: 8MB, type UC
[    0.000000] total RAM covered: 2039M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 16M 	num_reg: 3  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2039MB, range: 1MB, type UC
[    0.000000] reg 2, base: 2040MB, range: 8MB, type UC
[    0.000000] e820 update range: 0000000000001000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009f800 (usable)
[    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000007f6d0000 (usable)
[    0.000000]  modified: 000000007f6d0000 - 000000007f6e3000 (ACPI NVS)
[    0.000000]  modified: 000000007f6e3000 - 0000000080000000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  modified: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000f7680] f7680
[    0.000000] init_memory_mapping: 0000000000000000-000000007f6d0000
[    0.000000]  0000000000 - 007f600000 page 2M
[    0.000000]  007f600000 - 007f6d0000 page 4k
[    0.000000] kernel direct mapping tables up to 7f6d0000 @ 16000-1a000
[    0.000000] RAMDISK: 37ec3000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f7600 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 000000007f6d6873 00094 (v01 DELL    M08     06040000  LTP 00000000)
[    0.000000] ACPI: FACP 000000007f6decd6 000F4 (v03 TOSCPL CRESTLNE 06040000 ALAN 00000001)
[    0.000000] ACPI: DSDT 000000007f6d7db1 06EB1 (v02 TOSCPL CRESTLNE 06040000 INTL 20060608)
[    0.000000] ACPI: FACS 000000007f6e2fc0 00040
[    0.000000] ACPI: APIC 000000007f6dedca 00068 (v01 INTEL  CRESTLNE 06040000 LOHR 0000005A)
[    0.000000] ACPI: HPET 000000007f6dee32 00038 (v01 INTEL  CRESTLNE 06040000 LOHR 0000005A)
[    0.000000] ACPI: MCFG 000000007f6dee6a 0003C (v01 INTEL  CRESTLNE 06040000 LOHR 0000005A)
[    0.000000] ACPI: TCPA 000000007f6deea6 00032 (v01 Intel  CRESTLNE 06040000 LOHR 0000005A)
[    0.000000] ACPI: TMOR 000000007f6deed8 00026 (v01 PTLTD           06040000 PTL  00000003)
[    0.000000] ACPI: OSFR 000000007f6deefe 00072 (v01 TOSHIB A+2nd ID 06040000 TASM 04010000)
[    0.000000] ACPI: APIC 000000007f6def70 00068 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT 000000007f6defd8 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: SSDT 000000007f6d7b04 002AD (v01 SataRe SataAhci 00001000 INTL 20061109)
[    0.000000] ACPI: SSDT 000000007f6d7a61 000A3 (v01 BrtRef  DD01BRT 00001000 INTL 20061109)
[    0.000000] ACPI: SSDT 000000007f6d6e93 0025F (v01  PmRef  Cpu0Tst 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 000000007f6d6ded 000A6 (v01  PmRef  Cpu1Tst 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 000000007f6d6907 004E6 (v01  PmRef    CpuPm 00003000 INTL 20061109)
[    0.000000] ACPI: BIOS bug: multiple APIC/MADT found, using 0
[    0.000000] ACPI: If "acpi_apic_instance=2" works better, notify linux-acpi@vger.kernel.org
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007f6d0000
[    0.000000] Initmem setup node 0 0000000000000000-000000007f6d0000
[    0.000000]   NODE_DATA [0000000001fdf1c0 - 0000000001fe41bf]
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff880002800000-ffff8800043fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007f6d0
[    0.000000] On node 0 totalpages: 521823
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3927 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7080 pages used for memmap
[    0.000000]   DMA32 zone: 510760 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [18000 - 187ff]
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:60000000)
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880002200000 s80832 r8192 d21568 u1048576
[    0.000000] pcpu-alloc: s80832 r8192 d21568 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 514687
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/sda1 ro video=LVDS-1:d
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Subtract (50 early reservations)
[    0.000000]   #1 [0001000000 - 0001fde4a8]   TEXT DATA BSS
[    0.000000]   #2 [0037ec3000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [0001fdf000 - 0001fdf184]             BRK
[    0.000000]   #4 [00000f7690 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000f7680 - 00000f7690]    MP-table mpf
[    0.000000]   #6 [000009f800 - 000009fd71]   BIOS reserved
[    0.000000]   #7 [000009ff15 - 00000f7680]   BIOS reserved
[    0.000000]   #8 [000009fd71 - 000009ff15]    MP-table mpc
[    0.000000]   #9 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #10 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #11 [0000016000 - 0000018000]         PGTABLE
[    0.000000]   #12 [0001fdf1c0 - 0001fe41c0]       NODE_DATA
[    0.000000]   #13 [0001fe41c0 - 0001fe51c0]         BOOTMEM
[    0.000000]   #14 [0001fde4c0 - 0001fde640]         BOOTMEM
[    0.000000]   #15 [00027e6000 - 00027e7000]         BOOTMEM
[    0.000000]   #16 [00027e7000 - 00027e8000]         BOOTMEM
[    0.000000]   #17 [0002800000 - 0004400000]        MEMMAP 0
[    0.000000]   #18 [0001fde640 - 0001fdea40]         BOOTMEM
[    0.000000]   #19 [0001fe51c0 - 00020051c0]         BOOTMEM
[    0.000000]   #20 [0002006000 - 0002007000]         BOOTMEM
[    0.000000]   #21 [0001fdea40 - 0001fdea81]         BOOTMEM
[    0.000000]   #22 [0001fdeac0 - 0001fdeb03]         BOOTMEM
[    0.000000]   #23 [0001fdeb40 - 0001fdee50]         BOOTMEM
[    0.000000]   #24 [0001fdee80 - 0001fdeee8]         BOOTMEM
[    0.000000]   #25 [0001fdef00 - 0001fdef68]         BOOTMEM
[    0.000000]   #26 [0001fdef80 - 0001fdefe8]         BOOTMEM
[    0.000000]   #27 [00020051c0 - 0002005228]         BOOTMEM
[    0.000000]   #28 [0002005240 - 00020052a8]         BOOTMEM
[    0.000000]   #29 [00020052c0 - 0002005328]         BOOTMEM
[    0.000000]   #30 [0002005340 - 00020053a8]         BOOTMEM
[    0.000000]   #31 [00020053c0 - 0002005428]         BOOTMEM
[    0.000000]   #32 [0002005440 - 00020054a8]         BOOTMEM
[    0.000000]   #33 [00020054c0 - 0002005528]         BOOTMEM
[    0.000000]   #34 [0002005540 - 00020055a8]         BOOTMEM
[    0.000000]   #35 [00020055c0 - 0002005628]         BOOTMEM
[    0.000000]   #36 [0002005640 - 00020056a8]         BOOTMEM
[    0.000000]   #37 [00020056c0 - 00020056e0]         BOOTMEM
[    0.000000]   #38 [0002005700 - 0002005721]         BOOTMEM
[    0.000000]   #39 [0002005740 - 0002005761]         BOOTMEM
[    0.000000]   #40 [0002200000 - 000221b000]         BOOTMEM
[    0.000000]   #41 [0002300000 - 000231b000]         BOOTMEM
[    0.000000]   #42 [0002005780 - 0002005788]         BOOTMEM
[    0.000000]   #43 [00020057c0 - 00020057c8]         BOOTMEM
[    0.000000]   #44 [0002005800 - 0002005808]         BOOTMEM
[    0.000000]   #45 [0002005840 - 0002005850]         BOOTMEM
[    0.000000]   #46 [0002005880 - 00020059c0]         BOOTMEM
[    0.000000]   #47 [00020059c0 - 0002005a20]         BOOTMEM
[    0.000000]   #48 [0002005a40 - 0002005aa0]         BOOTMEM
[    0.000000]   #49 [0002007000 - 000200f000]         BOOTMEM
[    0.000000] Memory: 2040716k/2087744k available (3754k kernel code, 452k absent, 46576k reserved, 2912k data, 548k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:512
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
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1795.467 MHz processor.
[    0.002016] Calibrating delay loop (skipped), value calculated using timer frequency.. 3590.93 BogoMIPS (lpj=1795467)
[    0.002253] pid_max: default: 32768 minimum: 301
[    0.002437] Security Framework initialized
[    0.002555] Smack:  Initializing.
[    0.003236] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004649] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.005404] Mount-cache hash table entries: 256
[    0.006715] Initializing cgroup subsys ns
[    0.006834] Initializing cgroup subsys cpuacct
[    0.006957] Initializing cgroup subsys freezer
[    0.007091] CPU: Physical Processor ID: 0
[    0.007208] CPU: Processor Core ID: 0
[    0.007326] mce: CPU supports 6 MCE banks
[    0.007447] CPU0: Thermal monitoring handled by SMI
[    0.007454] using mwait in idle threads.
[    0.007570] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.007819] PEBS disabled due to CPU errata.
[    0.008016] ... version:                2
[    0.008133] ... bit width:              40
[    0.008248] ... generic registers:      2
[    0.008365] ... value mask:             000000ffffffffff
[    0.008482] ... max period:             000000007fffffff
[    0.008600] ... fixed-purpose events:   3
[    0.008715] ... event mask:             0000000700000003
[    0.009021] ACPI: Core revision 20100702
[    0.011733] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.011854] no locks held by swapper/0.
[    0.011971] Modules linked in:
[    0.012117] Pid: 0, comm: swapper Not tainted 2.6.35-BISECT+ #8
[    0.012237] Call Trace:
[    0.012357]  [<ffffffff81065e28>] ? __debug_show_held_locks+0x22/0x24
[    0.012482]  [<ffffffff8102f9a6>] __schedule_bug+0x6d/0x72
[    0.012604]  [<ffffffff8139ee7f>] schedule+0xdb/0xa1a
[    0.012724]  [<ffffffff81069801>] ? trace_hardirqs_on_caller+0x108/0x12c
[    0.012847]  [<ffffffff810325d8>] __cond_resched+0x13/0x1f
[    0.013006]  [<ffffffff8139f8dd>] _cond_resched+0x29/0x30
[    0.013130]  [<ffffffff811dca19>] acpi_ps_complete_op+0x26d/0x284
[    0.013252]  [<ffffffff811dd216>] acpi_ps_parse_loop+0x7e6/0x950
[    0.013375]  [<ffffffff811e31d0>] ? acpi_ut_create_generic_state+0x2d/0x4a
[    0.013497]  [<ffffffff811e31d0>] ? acpi_ut_create_generic_state+0x2d/0x4a
[    0.013621]  [<ffffffff811dc588>] acpi_ps_parse_aml+0x94/0x2b8
[    0.013743]  [<ffffffff811dab3a>] acpi_ns_one_complete_parse+0xf2/0x10f
[    0.013866]  [<ffffffff813a240b>] ? _raw_spin_unlock_irqrestore+0x5f/0x64
[    0.013989]  [<ffffffff811dab72>] acpi_ns_parse_table+0x1b/0x35
[    0.014006]  [<ffffffff811d802a>] acpi_ns_load_table+0x4a/0x8c
[    0.014129]  [<ffffffff811df192>] acpi_load_tables+0xa1/0x162
[    0.014254]  [<ffffffff816bfcdb>] acpi_early_init+0x6c/0xf7
[    0.014376]  [<ffffffff81698b95>] start_kernel+0x39c/0x3b1
[    0.014497]  [<ffffffff816982a1>] x86_64_start_reservations+0xb1/0xb5
[    0.014618]  [<ffffffff8169838e>] x86_64_start_kernel+0xe9/0xf0
[    0.032188] Setting APIC routing to flat
[    0.032710] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.042836] CPU0: Intel(R) Core(TM)2 Duo CPU     T5670  @ 1.80GHz stepping 0d
[    0.045426] NMI watchdog enabled, takes one hw-pmu counter.
[    0.047052] lockdep: fixing up alternatives.
[    0.048204] Booting Node   0, Processors  #1 Ok.
[    0.002999] CPU1: Thermal monitoring handled by SMI
[    0.120123] NMI watchdog enabled, takes one hw-pmu counter.
[    0.121014] Brought up 2 CPUs
[    0.121131] Total of 2 processors activated (7181.75 BogoMIPS).
[    0.122209] devtmpfs: initialized
[    0.123296] NET: Registered protocol family 16
[    0.124354] ACPI: bus type pci registered
[    0.124660] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.124850] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.183599] PCI: Using configuration type 1 for base access
[    0.185364] bio: create slab <bio-0> at 0
[    0.193400] ACPI: EC: Look up EC in DSDT
[    0.206054] ACPI: BIOS _OSI(Linux) query ignored
[    0.207521] ACPI: SSDT 000000007f6d7761 00238 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.209646] ACPI: Dynamic OEM Table Load:
[    0.209846] ACPI: SSDT (null) 00238 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.210478] ACPI: SSDT 000000007f6d70f2 005EA (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.212590] ACPI: Dynamic OEM Table Load:
[    0.212787] ACPI: SSDT (null) 005EA (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.213563] ACPI: SSDT 000000007f6d7999 000C8 (v01  PmRef  Cpu1Ist 00003000 INTL 20061109)
[    0.215750] ACPI: Dynamic OEM Table Load:
[    0.215946] ACPI: SSDT (null) 000C8 (v01  PmRef  Cpu1Ist 00003000 INTL 20061109)
[    0.216323] ACPI: SSDT 000000007f6d76dc 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20061109)
[    0.218540] ACPI: Dynamic OEM Table Load:
[    0.218738] ACPI: SSDT (null) 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20061109)
[    0.219642] ACPI: Interpreter enabled
[    0.219759] ACPI: (supports S0 S3 S4 S5)
[    0.220120] ACPI: Using IOAPIC for interrupt routing
[    0.303367] ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
[    0.304242] ACPI: No dock devices found.
[    0.304361] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.305601] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.307885] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.308007] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.308129] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.308318] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff]
[    0.308508] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    0.308697] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    0.308887] pci_root PNP0A08:00: host bridge window [mem 0x80000000-0xdfffffff]
[    0.309006] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfebfffff]
[    0.309410] pci 0000:00:02.0: reg 10: [mem 0xf8000000-0xf80fffff 64bit]
[    0.309429] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.309442] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.309556] pci 0000:00:02.1: reg 10: [mem 0xf8100000-0xf81fffff 64bit]
[    0.309809] pci 0000:00:1a.0: reg 20: [io  0x1820-0x183f]
[    0.310053] pci 0000:00:1a.1: reg 20: [io  0x1840-0x185f]
[    0.310173] pci 0000:00:1a.7: reg 10: [mem 0xf8504800-0xf8504bff]
[    0.310316] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.310324] pci 0000:00:1a.7: PME# disabled
[    0.310397] pci 0000:00:1b.0: reg 10: [mem 0xf8500000-0xf8503fff 64bit]
[    0.310527] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.310535] pci 0000:00:1b.0: PME# disabled
[    0.310699] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.310706] pci 0000:00:1c.0: PME# disabled
[    0.310874] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.310882] pci 0000:00:1c.1: PME# disabled
[    0.311062] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.311070] pci 0000:00:1c.3: PME# disabled
[    0.311243] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.311251] pci 0000:00:1c.4: PME# disabled
[    0.311386] pci 0000:00:1d.0: reg 20: [io  0x1860-0x187f]
[    0.311539] pci 0000:00:1d.1: reg 20: [io  0x1880-0x189f]
[    0.311685] pci 0000:00:1d.2: reg 20: [io  0x18a0-0x18bf]
[    0.311805] pci 0000:00:1d.7: reg 10: [mem 0xf8504c00-0xf8504fff]
[    0.311949] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.311957] pci 0000:00:1d.7: PME# disabled
[    0.312281] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
[    0.312475] pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
[    0.312600] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
[    0.312790] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 1640 (mask 007f)
[    0.313070] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    0.313089] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    0.313108] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
[    0.313127] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
[    0.313146] pci 0000:00:1f.1: reg 20: [io  0x1810-0x181f]
[    0.313269] pci 0000:00:1f.2: reg 10: [io  0x1c00-0x1c07]
[    0.313288] pci 0000:00:1f.2: reg 14: [io  0x18d4-0x18d7]
[    0.313307] pci 0000:00:1f.2: reg 18: [io  0x18d8-0x18df]
[    0.313326] pci 0000:00:1f.2: reg 1c: [io  0x18d0-0x18d3]
[    0.313345] pci 0000:00:1f.2: reg 20: [io  0x18e0-0x18ff]
[    0.313364] pci 0000:00:1f.2: reg 24: [mem 0xf8504000-0xf85047ff]
[    0.313437] pci 0000:00:1f.2: PME# supported from D3hot
[    0.313444] pci 0000:00:1f.2: PME# disabled
[    0.313500] pci 0000:00:1f.3: reg 10: [mem 0x00000000-0x000000ff]
[    0.313565] pci 0000:00:1f.3: reg 20: [io  0x1c20-0x1c3f]
[    0.313716] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.313838] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.313846] pci 0000:00:1c.0:   bridge window [mem 0xc4000000-0xc7ffffff]
[    0.313858] pci 0000:00:1c.0:   bridge window [mem 0xcc000000-0xcdffffff 64bit pref]
[    0.313953] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.314009] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.314017] pci 0000:00:1c.1:   bridge window [mem 0xf0000000-0xf3ffffff]
[    0.314029] pci 0000:00:1c.1:   bridge window [mem 0xfa000000-0xfbffffff 64bit pref]
[    0.314292] pci 0000:06:00.0: reg 10: [mem 0xf4000000-0xf4000fff]
[    0.314681] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    0.314697] pci 0000:06:00.0: PME# disabled
[    0.314765] pci 0000:06:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.315165] pci 0000:00:1c.3: PCI bridge to [bus 06-06]
[    0.315288] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.315296] pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf7ffffff]
[    0.315308] pci 0000:00:1c.3:   bridge window [mem 0xfc000000-0xfdffffff 64bit pref]
[    0.315551] pci 0000:07:00.0: reg 10: [io  0x5000-0x50ff]
[    0.315679] pci 0000:07:00.0: reg 18: [mem 0xf8610000-0xf8610fff 64bit pref]
[    0.315760] pci 0000:07:00.0: reg 20: [mem 0xf8600000-0xf860ffff 64bit pref]
[    0.315812] pci 0000:07:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.316033] pci 0000:07:00.0: supports D1 D2
[    0.316037] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.316054] pci 0000:07:00.0: PME# disabled
[    0.316235] pci 0000:00:1c.4: PCI bridge to [bus 07-07]
[    0.316358] pci 0000:00:1c.4:   bridge window [io  0x5000-0x5fff]
[    0.316366] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.316378] pci 0000:00:1c.4:   bridge window [mem 0xf8600000-0xf86fffff 64bit pref]
[    0.316493] pci 0000:08:05.0: reg 10: [mem 0xf8200000-0xf8200fff]
[    0.316512] pci 0000:08:05.0: reg 14: [mem 0xf8202000-0xf82027ff]
[    0.316630] pci 0000:08:05.0: supports D1 D2
[    0.316633] pci 0000:08:05.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.316641] pci 0000:08:05.0: PME# disabled
[    0.316712] pci 0000:08:05.2: reg 10: [mem 0xf8202800-0xf82028ff]
[    0.316859] pci 0000:08:05.2: supports D1 D2
[    0.316862] pci 0000:08:05.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.316870] pci 0000:08:05.2: PME# disabled
[    0.316940] pci 0000:08:05.3: reg 10: [mem 0xf8201000-0xf8201fff]
[    0.317097] pci 0000:08:05.3: supports D1 D2
[    0.317100] pci 0000:08:05.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.317108] pci 0000:08:05.3: PME# disabled
[    0.317202] pci 0000:00:1e.0: PCI bridge to [bus 08-08] (subtractive decode)
[    0.317329] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.317337] pci 0000:00:1e.0:   bridge window [mem 0xf8200000-0xf82fffff]
[    0.317349] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.317354] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.317358] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.317362] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.317366] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
[    0.317370] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.317374] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.317379] pci 0000:00:1e.0:   bridge window [mem 0x80000000-0xdfffffff] (subtractive decode)
[    0.317383] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
[    0.317436] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.318084] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.318231] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.318390] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    0.318539] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    0.318791] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.318964] Unable to assume PCIe control: Disabling ASPM
[    0.342041] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 *5 6 7 10 12 14 15)
[    0.342783] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.343529] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.344283] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.345041] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.345927] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.346647] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.347403] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.348679] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.348919] vgaarb: loaded
[    0.349103] usbcore: registered new interface driver usbfs
[    0.349266] usbcore: registered new interface driver hub
[    0.349395] usbcore: registered new device driver usb
[    0.349395] PCI: Using ACPI for IRQ routing
[    0.349395] PCI: pci_cache_line_size set to 64 bytes
[    0.350196] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
[    0.350201] reserve RAM buffer: 000000007f6d0000 - 000000007fffffff 
[    0.351038] cfg80211: Calling CRDA to update world regulatory domain
[    0.351395] NetLabel: Initializing
[    0.351511] NetLabel:  domain hash size = 128
[    0.351629] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.352007] NetLabel:  unlabeled traffic allowed by default
[    0.352294] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.352583] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.355067] Switching to clocksource tsc
[    0.362822] pnp: PnP ACPI init
[    0.362992] ACPI: bus type pnp registered
[    0.376597] ACPI: EC: GPE storm detected, transactions will use polling mode
[    0.402413] pnp: PnP ACPI: found 10 devices
[    0.402531] ACPI: ACPI bus type pnp unregistered
[    0.402686] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.402811] system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
[    0.402947] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.403072] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.403196] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.403322] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.403444] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.403569] system 00:01: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.403707] system 00:04: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.403845] system 00:06: [io  0x0680-0x069f] has been reserved
[    0.403975] system 00:06: [io  0x0800-0x080f] has been reserved
[    0.404096] system 00:06: [io  0x1000-0x107f] has been reserved
[    0.404220] system 00:06: [io  0x1180-0x11bf] has been reserved
[    0.404344] system 00:06: [io  0xfe00] has been reserved
[    0.404466] system 00:06: [io  0xff00-0xff7f] has been reserved
[    0.414088] pci 0000:00:1c.4: BAR 8: assigned [mem 0x80000000-0x803fffff]
[    0.414215] pci 0000:00:1f.3: BAR 0: assigned [mem 0x80400000-0x804000ff]
[    0.414345] pci 0000:00:1f.3: BAR 0: set to [mem 0x80400000-0x804000ff] (PCI address [0x80400000-0x804000ff]
[    0.416448] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.416567] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.416692] pci 0000:00:1c.0:   bridge window [mem 0xc4000000-0xc7ffffff]
[    0.416816] pci 0000:00:1c.0:   bridge window [mem 0xcc000000-0xcdffffff 64bit pref]
[    0.417020] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.417140] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.417264] pci 0000:00:1c.1:   bridge window [mem 0xf0000000-0xf3ffffff]
[    0.417389] pci 0000:00:1c.1:   bridge window [mem 0xfa000000-0xfbffffff 64bit pref]
[    0.417586] pci 0000:00:1c.3: PCI bridge to [bus 06-06]
[    0.417706] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.417832] pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf7ffffff]
[    0.417964] pci 0000:00:1c.3:   bridge window [mem 0xfc000000-0xfdffffff 64bit pref]
[    0.418160] pci 0000:07:00.0: BAR 6: assigned [mem 0xf8620000-0xf862ffff pref]
[    0.418348] pci 0000:00:1c.4: PCI bridge to [bus 07-07]
[    0.418469] pci 0000:00:1c.4:   bridge window [io  0x5000-0x5fff]
[    0.418594] pci 0000:00:1c.4:   bridge window [mem 0x80000000-0x803fffff]
[    0.418717] pci 0000:00:1c.4:   bridge window [mem 0xf8600000-0xf86fffff 64bit pref]
[    0.418915] pci 0000:00:1e.0: PCI bridge to [bus 08-08]
[    0.419040] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.419165] pci 0000:00:1e.0:   bridge window [mem 0xf8200000-0xf82fffff]
[    0.419289] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.419446]   alloc irq_desc for 17 on node -1
[    0.419449]   alloc kstat_irqs on node -1
[    0.419458] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.419584] pci 0000:00:1c.0: setting latency timer to 64
[    0.419600]   alloc irq_desc for 16 on node -1
[    0.419603]   alloc kstat_irqs on node -1
[    0.419611] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.419734] pci 0000:00:1c.1: setting latency timer to 64
[    0.419750]   alloc irq_desc for 19 on node -1
[    0.419753]   alloc kstat_irqs on node -1
[    0.419759] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.419883] pci 0000:00:1c.3: setting latency timer to 64
[    0.419900] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.420031] pci 0000:00:1c.4: setting latency timer to 64
[    0.420045] pci 0000:00:1e.0: setting latency timer to 64
[    0.420052] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.420055] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.420059] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.420062] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.420066] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.420070] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.420073] pci_bus 0000:00: resource 10 [mem 0x80000000-0xdfffffff]
[    0.420077] pci_bus 0000:00: resource 11 [mem 0xf0000000-0xfebfffff]
[    0.420081] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.420084] pci_bus 0000:02: resource 1 [mem 0xc4000000-0xc7ffffff]
[    0.420088] pci_bus 0000:02: resource 2 [mem 0xcc000000-0xcdffffff 64bit pref]
[    0.420092] pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
[    0.420095] pci_bus 0000:03: resource 1 [mem 0xf0000000-0xf3ffffff]
[    0.420099] pci_bus 0000:03: resource 2 [mem 0xfa000000-0xfbffffff 64bit pref]
[    0.420102] pci_bus 0000:06: resource 0 [io  0x4000-0x4fff]
[    0.420106] pci_bus 0000:06: resource 1 [mem 0xf4000000-0xf7ffffff]
[    0.420109] pci_bus 0000:06: resource 2 [mem 0xfc000000-0xfdffffff 64bit pref]
[    0.420113] pci_bus 0000:07: resource 0 [io  0x5000-0x5fff]
[    0.420117] pci_bus 0000:07: resource 1 [mem 0x80000000-0x803fffff]
[    0.420120] pci_bus 0000:07: resource 2 [mem 0xf8600000-0xf86fffff 64bit pref]
[    0.420124] pci_bus 0000:08: resource 1 [mem 0xf8200000-0xf82fffff]
[    0.420128] pci_bus 0000:08: resource 4 [io  0x0000-0x0cf7]
[    0.420131] pci_bus 0000:08: resource 5 [io  0x0d00-0xffff]
[    0.420134] pci_bus 0000:08: resource 6 [mem 0x000a0000-0x000bffff]
[    0.420138] pci_bus 0000:08: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.420141] pci_bus 0000:08: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.420145] pci_bus 0000:08: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.420148] pci_bus 0000:08: resource 10 [mem 0x80000000-0xdfffffff]
[    0.420152] pci_bus 0000:08: resource 11 [mem 0xf0000000-0xfebfffff]
[    0.420234] NET: Registered protocol family 2
[    0.420661] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.422484] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.425589] TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
[    0.432317] TCP: Hash tables configured (established 262144 bind 65536)
[    0.432515] TCP reno registered
[    0.432677] UDP hash table entries: 1024 (order: 5, 131072 bytes)
[    0.433040] UDP-Lite hash table entries: 1024 (order: 5, 131072 bytes)
[    0.433592] NET: Registered protocol family 1
[    0.433748] pci 0000:00:02.0: Boot video device
[    0.433766] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x3e00
[    0.433770] pci 0000:00:1a.0: Performing full reset
[    0.433796] pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x2000
[    0.433799] pci 0000:00:1a.1: Performing full reset
[    0.433889] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x2e00
[    0.433893] pci 0000:00:1d.0: Performing full reset
[    0.433919] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x2000
[    0.433922] pci 0000:00:1d.1: Performing full reset
[    0.433957] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x2000
[    0.433961] pci 0000:00:1d.2: Performing full reset
[    0.434069] PCI: CLS 64 bytes, default 64
[    0.434392] Trying to unpack rootfs image as initramfs...
[    0.725133] Freeing initrd memory: 1204k freed
[    0.725900] Simple Boot Flag at 0x36 set to 0x1
[    0.727241] microcode: CPU0 sig=0x6fd, pf=0x80, revision=0xa1
[    0.727380] microcode: CPU1 sig=0x6fd, pf=0x80, revision=0xa1
[    0.727563] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.727749] Scanning for low memory corruption every 60 seconds
[    0.728293] cryptomgr_test used greatest stack depth: 6448 bytes left
[    0.728539] audit: initializing netlink socket (disabled)
[    0.728727] type=2000 audit(1282608915.726:1): initialized
[    0.754977] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.759435] VFS: Disk quotas dquot_6.5.2
[    0.759720] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.760317] msgmni has been set to 3988
[    0.761157] cryptomgr_test used greatest stack depth: 6096 bytes left
[    0.761584] alg: No test for stdrng (krng)
[    0.761817] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.762036] io scheduler noop registered
[    0.762151] io scheduler deadline registered
[    0.762355] io scheduler cfq registered (default)
[    0.762815] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.763052] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.763275] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.763497] pcieport 0000:00:1c.4: setting latency timer to 64
[    0.763855] intel_idle: MWAIT substates: 0x22220
[    0.763858] intel_idle: does not run on family 6 model 15
[    0.770298] ACPI: AC Adapter [ACAD] (on-line)
[    0.770805] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    0.771092] ACPI: Lid Switch [LID0]
[    0.771330] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    0.771574] ACPI: Power Button [PWRB]
[    0.771813] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    0.772010] ACPI: Sleep Button [SLPB]
[    0.772287] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.772475] ACPI: Power Button [PWRF]
[    0.772716] ACPI: acpi_idle registered with cpuidle
[    0.778616] Monitor-Mwait will be used to enter C-1 state
[    0.778681] Monitor-Mwait will be used to enter C-2 state
[    0.778735] Monitor-Mwait will be used to enter C-3 state
[    0.778745] Marking TSC unstable due to TSC halts in idle
[    0.779111] Switching to clocksource hpet
[    1.132383] ACPI: Battery Slot [BAT1] (battery present)
[    1.132809] Non-volatile memory driver v1.3
[    1.133322] Linux agpgart interface v0.103
[    1.133696] agpgart-intel 0000:00:00.0: Intel 965GM Chipset
[    1.134726] agpgart-intel 0000:00:00.0: detected 7676K stolen memory
[    1.139526] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    1.139757] [drm] Initialized drm 1.1.0 20060810
[    1.139914] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.140067] i915 0000:00:02.0: setting latency timer to 64
[    1.216361] [drm] set up 7M of stolen space
[    1.324996] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.325595] [drm] initialized overlay support
[    1.446200] [drm] forcing LVDS-1 connector OFF
[    2.109398] Console: switching to colour frame buffer device 160x64
[    2.113435] fb0: inteldrmfb frame buffer device
[    2.113464] drm: registered panic notifier
[    2.113526] [drm:drm_kms_helper_poll_enable] *ERROR* delayed enqueue failed 1
[    2.143122] acpi device:07: registered as cooling_device2
[    2.143742] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:01/input/input4
[    2.143815] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    2.143967] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    2.147442] brd: module loaded
[    2.147523] console [netcon0] enabled
[    2.147547] netconsole: network logging started
[    2.147880] usbcore: registered new interface driver libusual
[    2.148025] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    2.178218] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.178299] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.178514] mice: PS/2 mouse device common for all mice
[    2.178619] rtc_cmos 00:07: RTC can wake from S4
[    2.178970] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    2.179074] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    2.179133] i2c /dev entries driver
[    2.179719]   alloc irq_desc for 18 on node -1
[    2.179723]   alloc kstat_irqs on node -1
[    2.179761] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.179820] ACPI: resource 0000:00:1f.3 [io  0x1c20-0x1c3f] conflicts with ACPI region SMBI [io  0x1c20-0x1c2f pref disabled]
[    2.179883] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    2.180226] cpuidle: using governor ladder
[    2.180879] cpuidle: using governor menu
[    2.180989] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    2.181484] usbcore: registered new interface driver hiddev
[    2.181548] usbcore: registered new interface driver usbhid
[    2.181582] usbhid: USB HID core driver
[    2.181651] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    2.183915] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.184109] TCP cubic registered
[    2.184134] Initializing XFRM netlink socket
[    2.184197] NET: Registered protocol family 17
[    2.184239] lib80211: common routines for IEEE802.11 drivers
[    2.184285] lib80211_crypt: registered algorithm 'NULL'
[    2.184287] Registering the dns_resolver key type
[    2.185980] registered taskstats version 1
[    2.186837] rtc_cmos 00:07: setting system clock to 2010-08-24 00:15:17 UTC (1282608917)
[    2.186890] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.186929] EDD information not available.
[    2.188398] Initalizing network drop monitor service
[    2.190255] Freeing unused kernel memory: 548k freed
[    2.191885] Write protecting the kernel read-only data: 6144k
[    2.193556] Freeing unused kernel memory: 320k freed
[    2.195296] Freeing unused kernel memory: 284k freed
[    2.201643] busybox used greatest stack depth: 5704 bytes left
[    2.205262] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[    2.219327] udev: starting version 161
[    2.271751] modprobe used greatest stack depth: 5576 bytes left
[    2.273585] load-modules.sh used greatest stack depth: 5416 bytes left
[    2.364570] sed used greatest stack depth: 5312 bytes left
[    2.528501] load-modules.sh used greatest stack depth: 4872 bytes left
[    2.541481] udevadm used greatest stack depth: 4096 bytes left
[    2.770077] SCSI subsystem initialized
[    2.796558] libata version 3.00 loaded.
[    2.804253] ahci 0000:00:1f.2: version 3.0
[    2.804282] ahci 0000:00:1f.2: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[    2.806380] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x7 impl SATA mode
[    2.808308] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc 
[    2.810282] ahci 0000:00:1f.2: setting latency timer to 64
[    2.810688] scsi0 : ahci
[    2.813268] scsi1 : ahci
[    2.815540] scsi2 : ahci
[    2.817959] ata1: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 18
[    2.819942] ata2: SATA max UDMA/133 abar m2048@0xf8504000 port 0xf8504180 irq 18
[    2.821919] ata3: SATA max UDMA/133 abar m2048@0xf8504000 port 0xf8504200 irq 18
[    2.898324] pata_acpi 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.900394] pata_acpi 0000:00:1f.1: setting latency timer to 64
[    2.900420] pata_acpi 0000:00:1f.1: PCI INT A disabled
[    3.129158] ata2: SATA link down (SStatus 0 SControl 300)
[    3.131198] ata3: SATA link down (SStatus 0 SControl 300)
[    3.547134] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.549803] ata1.00: unexpected _GTF length (8)
[    3.595490] ata1.00: ATA-8: WDC WD1600BEVT-75ZCT0, 11.01A11, max UDMA/133
[    3.597444] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    3.600370] ata1.00: unexpected _GTF length (8)
[    3.602557] ata1.00: configured for UDMA/133
[    3.616028] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600BEVT-7 11.0 PQ: 0 ANSI: 5
[    3.623067] ata_piix 0000:00:1f.1: version 2.13
[    3.623090] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.625681] ata_piix 0000:00:1f.1: setting latency timer to 64
[    3.625831] scsi3 : ata_piix
[    3.628210] scsi4 : ata_piix
[    3.631466] ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
[    3.633535] ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
[    3.638710] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    3.640852] sd 0:0:0:0: [sda] Write Protect is off
[    3.642759] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.642813] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.645648]  sda: sda1 sda2 sda3 sda4
[    3.659173] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.816625] ata4.00: ATAPI: TEAC   DVD+/-RW DVW28SLC, A.06, max UDMA/33
[    3.840406] ata4.00: configured for UDMA/33
[    3.855937] scsi 3:0:0:0: CD-ROM            TEAC     DVD+-RW DVW28SLC A.06 PQ: 0 ANSI: 5
[    3.902166] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda caddy
[    3.904166] Uniform CD-ROM driver Revision: 3.20
[    3.906555] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    4.471852] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    6.817414] udev: starting version 161
[    7.202031] udevadm used greatest stack depth: 3936 bytes left
[    7.411800] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    7.411805] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    7.411885] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    7.411920] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    7.411926] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    7.412804] drivers/usb/core/inode.c: creating file 'devices'
[    7.412965] drivers/usb/core/inode.c: creating file '001'
[    7.413581] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    7.413594] ehci_hcd 0000:00:1a.7: reset hcs_params 0x102204 dbg=1 cc=2 pcc=2 ordered !ppc ports=4
[    7.413601] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
[    7.413688] ehci_hcd 0000:00:1a.7: debug port 1
[    7.413695] ehci_hcd 0000:00:1a.7: reset command 080032 (park)=0 ithresh=8 Async Periodic period=1024 Reset HALT
[    7.443550] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    7.443604] r8169 0000:07:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.443730] r8169 0000:07:00.0: setting latency timer to 64
[    7.443759] r8169 0000:07:00.0: no MSI. Back to INTx.
[    7.476700] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    7.476705] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    7.476724] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf8504800
[    7.476732] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    7.481033] r8169 0000:07:00.0: eth0: RTL8168c/8111c at 0xffffc90021422000, 00:1c:23:4e:23:72, XID 1c4000c0 IRQ 16
[    7.512504] ehci_hcd 0000:00:1a.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    7.518055] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    7.518366] usb usb1: default language 0x0409
[    7.518390] usb usb1: udev 1, busnum 1, minor = 0
[    7.518393] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    7.518397] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.518401] usb usb1: Product: EHCI Host Controller
[    7.518404] usb usb1: Manufacturer: Linux 2.6.35-BISECT+ ehci_hcd
[    7.518408] usb usb1: SerialNumber: 0000:00:1a.7
[    7.519332] usb usb1: usb_probe_device
[    7.519337] usb usb1: configuration #1 chosen from 1 choice
[    7.519582] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    7.519850] hub 1-0:1.0: usb_probe_interface
[    7.519854] hub 1-0:1.0: usb_probe_interface - got id
[    7.519863] hub 1-0:1.0: USB hub found
[    7.519923] hub 1-0:1.0: 4 ports detected
[    7.519927] hub 1-0:1.0: standalone hub
[    7.519929] hub 1-0:1.0: no power switching (usb 1.0)
[    7.519932] hub 1-0:1.0: individual port over-current protection
[    7.519936] hub 1-0:1.0: power on to power good time: 20ms
[    7.520120] hub 1-0:1.0: local power source is good
[    7.520125] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    7.520235] drivers/usb/core/inode.c: creating file '001'
[    7.520545]   alloc irq_desc for 23 on node -1
[    7.520549]   alloc kstat_irqs on node -1
[    7.520561] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    7.520602] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    7.520608] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    7.520625] drivers/usb/core/inode.c: creating file '002'
[    7.521057] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    7.521071] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    7.521078] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
[    7.521123] ehci_hcd 0000:00:1d.7: debug port 1
[    7.521130] ehci_hcd 0000:00:1d.7: reset command 080032 (park)=0 ithresh=8 Async Periodic period=1024 Reset HALT
[    7.525032] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    7.525037] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    7.525083] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf8504c00
[    7.525090] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    7.565374] ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    7.575709] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    7.575857] sr 3:0:0:0: Attached scsi generic sg1 type 5
[    7.576202] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    7.576340] usb usb2: default language 0x0409
[    7.576364] usb usb2: udev 1, busnum 2, minor = 128
[    7.576367] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    7.576371] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.576375] usb usb2: Product: EHCI Host Controller
[    7.576379] usb usb2: Manufacturer: Linux 2.6.35-BISECT+ ehci_hcd
[    7.576382] usb usb2: SerialNumber: 0000:00:1d.7
[    7.576622] usb usb2: usb_probe_device
[    7.576626] usb usb2: configuration #1 chosen from 1 choice
[    7.576648] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    7.579275] ACPI: WMI: Mapper loaded
[    7.580067] iTCO_vendor_support: vendor-support=0
[    7.583772] hub 2-0:1.0: usb_probe_interface
[    7.583778] hub 2-0:1.0: usb_probe_interface - got id
[    7.583787] hub 2-0:1.0: USB hub found
[    7.583807] hub 2-0:1.0: 6 ports detected
[    7.583810] hub 2-0:1.0: standalone hub
[    7.583813] hub 2-0:1.0: no power switching (usb 1.0)
[    7.583816] hub 2-0:1.0: individual port over-current protection
[    7.583820] hub 2-0:1.0: power on to power good time: 20ms
[    7.583839] hub 2-0:1.0: local power source is good
[    7.583843] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    7.584046] drivers/usb/core/inode.c: creating file '001'
[    7.607969] coretemp coretemp.0: TjMax is assumed as 100 C!
[    7.609465] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[    7.609661] iTCO_wdt: Found a ICH8M TCO device (Version=2, TCOBASE=0x1060)
[    7.610041] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    7.613383] coretemp coretemp.1: TjMax is assumed as 100 C!
[    7.620363] hub 1-0:1.0: state 7 ports 4 chg 0000 evt 0000
[    7.625212]   alloc irq_desc for 22 on node -1
[    7.625216]   alloc kstat_irqs on node -1
[    7.625230] firewire_ohci 0000:08:05.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    7.676289] firewire_ohci: Added fw-ohci device 0000:08:05.0, OHCI v1.10, 8 IR + 8 IT contexts, quirks 0x0
[    7.685475] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001403 POWER sig=k CSC CONNECT
[    7.685485] hub 2-0:1.0: port 2: status 0501 change 0001
[    7.686063] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:s
[    7.686067] iwl3945: Copyright(c) 2003-2010 Intel Corporation
[    7.686226] iwl3945 0000:06:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    7.686244] iwl3945 0000:06:00.0: setting latency timer to 64
[    7.705661] uhci_hcd: USB Universal Host Controller Interface driver
[    7.708528] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.708543] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    7.708550] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    7.708569] drivers/usb/core/inode.c: creating file '003'
[    7.708747] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    7.708760] uhci_hcd 0000:00:1a.0: detected 2 ports
[    7.708768] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    7.708771] uhci_hcd 0000:00:1a.0: Performing full reset
[    7.708791] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    7.708808] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00001820
[    7.708895] usb usb3: default language 0x0409
[    7.708918] usb usb3: udev 1, busnum 3, minor = 256
[    7.708921] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    7.708925] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.708929] usb usb3: Product: UHCI Host Controller
[    7.708932] usb usb3: Manufacturer: Linux 2.6.35-BISECT+ uhci_hcd
[    7.708935] usb usb3: SerialNumber: 0000:00:1a.0
[    7.709169] usb usb3: usb_probe_device
[    7.709174] usb usb3: configuration #1 chosen from 1 choice
[    7.709212] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    7.709309] hub 3-0:1.0: usb_probe_interface
[    7.709313] hub 3-0:1.0: usb_probe_interface - got id
[    7.709319] hub 3-0:1.0: USB hub found
[    7.709435] hub 3-0:1.0: 2 ports detected
[    7.709438] hub 3-0:1.0: standalone hub
[    7.709441] hub 3-0:1.0: no power switching (usb 1.0)
[    7.709444] hub 3-0:1.0: individual port over-current protection
[    7.709448] hub 3-0:1.0: power on to power good time: 2ms
[    7.709487] hub 3-0:1.0: local power source is good
[    7.709491] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    7.709557] drivers/usb/core/inode.c: creating file '001'
[    7.709661] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    7.709746]   alloc irq_desc for 21 on node -1
[    7.709750]   alloc kstat_irqs on node -1
[    7.709761] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    7.709773] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    7.709778] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    7.709797] drivers/usb/core/inode.c: creating file '004'
[    7.709993] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    7.710023] uhci_hcd 0000:00:1a.1: detected 2 ports
[    7.710031] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    7.710034] uhci_hcd 0000:00:1a.1: Performing full reset
[    7.710053] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[    7.710091] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001840
[    7.710177] usb usb4: default language 0x0409
[    7.710198] usb usb4: udev 1, busnum 4, minor = 384
[    7.710202] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    7.710206] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.710209] usb usb4: Product: UHCI Host Controller
[    7.710212] usb usb4: Manufacturer: Linux 2.6.35-BISECT+ uhci_hcd
[    7.710216] usb usb4: SerialNumber: 0000:00:1a.1
[    7.710420] usb usb4: usb_probe_device
[    7.710424] usb usb4: configuration #1 chosen from 1 choice
[    7.710441] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    7.710523] hub 4-0:1.0: usb_probe_interface
[    7.710526] hub 4-0:1.0: usb_probe_interface - got id
[    7.710532] hub 4-0:1.0: USB hub found
[    7.710545] hub 4-0:1.0: 2 ports detected
[    7.710548] hub 4-0:1.0: standalone hub
[    7.710551] hub 4-0:1.0: no power switching (usb 1.0)
[    7.710554] hub 4-0:1.0: individual port over-current protection
[    7.710557] hub 4-0:1.0: power on to power good time: 2ms
[    7.710574] hub 4-0:1.0: local power source is good
[    7.710577] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    7.710642] drivers/usb/core/inode.c: creating file '001'
[    7.711660] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
[    7.711771] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    7.711794] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    7.713927] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    7.713944] drivers/usb/core/inode.c: creating file '005'
[    7.714208] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    7.714220] uhci_hcd 0000:00:1d.0: detected 2 ports
[    7.714228] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    7.714232] uhci_hcd 0000:00:1d.0: Performing full reset
[    7.714251] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    7.714265] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001860
[    7.714347] usb usb5: default language 0x0409
[    7.714370] usb usb5: udev 1, busnum 5, minor = 512
[    7.714373] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    7.714377] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.714381] usb usb5: Product: UHCI Host Controller
[    7.714384] usb usb5: Manufacturer: Linux 2.6.35-BISECT+ uhci_hcd
[    7.714387] usb usb5: SerialNumber: 0000:00:1d.0
[    7.714685] usb usb5: usb_probe_device
[    7.714689] usb usb5: configuration #1 chosen from 1 choice
[    7.714708] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    7.714838] hub 5-0:1.0: usb_probe_interface
[    7.714841] hub 5-0:1.0: usb_probe_interface - got id
[    7.714847] hub 5-0:1.0: USB hub found
[    7.714860] hub 5-0:1.0: 2 ports detected
[    7.714864] hub 5-0:1.0: standalone hub
[    7.714866] hub 5-0:1.0: no power switching (usb 1.0)
[    7.714869] hub 5-0:1.0: individual port over-current protection
[    7.714873] hub 5-0:1.0: power on to power good time: 2ms
[    7.714890] hub 5-0:1.0: local power source is good
[    7.714893] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    7.714958] drivers/usb/core/inode.c: creating file '001'
[    7.715100] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    7.715157] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    7.715171] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    7.715177] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    7.715192] drivers/usb/core/inode.c: creating file '006'
[    7.715376] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    7.715388] uhci_hcd 0000:00:1d.1: detected 2 ports
[    7.715396] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    7.715399] uhci_hcd 0000:00:1d.1: Performing full reset
[    7.715418] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    7.715456] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001880
[    7.715533] usb usb6: default language 0x0409
[    7.715555] usb usb6: udev 1, busnum 6, minor = 640
[    7.715559] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    7.715563] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.715566] usb usb6: Product: UHCI Host Controller
[    7.715569] usb usb6: Manufacturer: Linux 2.6.35-BISECT+ uhci_hcd
[    7.715572] usb usb6: SerialNumber: 0000:00:1d.1
[    7.722712] usb usb6: usb_probe_device
[    7.722718] usb usb6: configuration #1 chosen from 1 choice
[    7.723082] input: Dell WMI hotkeys as /devices/virtual/input/input6
[    7.728355] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    7.728541] hub 6-0:1.0: usb_probe_interface
[    7.728545] hub 6-0:1.0: usb_probe_interface - got id
[    7.728553] hub 6-0:1.0: USB hub found
[    7.728569] hub 6-0:1.0: 2 ports detected
[    7.728572] hub 6-0:1.0: standalone hub
[    7.728575] hub 6-0:1.0: no power switching (usb 1.0)
[    7.728578] hub 6-0:1.0: individual port over-current protection
[    7.728581] hub 6-0:1.0: power on to power good time: 2ms
[    7.728599] hub 6-0:1.0: local power source is good
[    7.728603] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    7.728674] drivers/usb/core/inode.c: creating file '001'
[    7.728822] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    7.728890] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    7.728922] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    7.737691] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    7.737717] drivers/usb/core/inode.c: creating file '007'
[    7.744498] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    7.744512] uhci_hcd 0000:00:1d.2: detected 2 ports
[    7.744521] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    7.744524] uhci_hcd 0000:00:1d.2: Performing full reset
[    7.744545] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    7.744562] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018a0
[    7.744656] usb usb7: default language 0x0409
[    7.744679] usb usb7: udev 1, busnum 7, minor = 768
[    7.744683] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    7.744687] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.744690] usb usb7: Product: UHCI Host Controller
[    7.744694] usb usb7: Manufacturer: Linux 2.6.35-BISECT+ uhci_hcd
[    7.744697] usb usb7: SerialNumber: 0000:00:1d.2
[    7.744982] usb usb7: usb_probe_device
[    7.744987] usb usb7: configuration #1 chosen from 1 choice
[    7.745025] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    7.745683] hub 7-0:1.0: usb_probe_interface
[    7.745687] hub 7-0:1.0: usb_probe_interface - got id
[    7.745694] hub 7-0:1.0: USB hub found
[    7.745710] hub 7-0:1.0: 2 ports detected
[    7.745713] hub 7-0:1.0: standalone hub
[    7.745716] hub 7-0:1.0: no power switching (usb 1.0)
[    7.745719] hub 7-0:1.0: individual port over-current protection
[    7.745722] hub 7-0:1.0: power on to power good time: 2ms
[    7.745740] hub 7-0:1.0: local power source is good
[    7.745744] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    7.745817] drivers/usb/core/inode.c: creating file '001'
[    7.745948] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    7.760549] scsi_id used greatest stack depth: 3888 bytes left
[    7.787163] iwl3945 0000:06:00.0: Tunable channels: 13 802.11bg, 23 802.11a channels
[    7.787169] iwl3945 0000:06:00.0: Detected Intel Wireless WiFi Link 3945ABG
[    7.788225] hub 2-0:1.0: state 7 ports 6 chg 0004 evt 0000
[    7.788336] hub 2-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[    7.788518] ehci_hcd 0000:00:1d.7: port 2 low speed --> companion
[    7.792040] phy0: Selected rate control algorithm 'iwl-3945-rs'
[    7.814047] uhci_hcd 0000:00:1d.0: port 2 portsc 01ab,00
[    7.814057] hub 5-0:1.0: port 2: status 0301 change 0003
[    7.814767] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    7.814816] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    7.839142] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
[    7.839283] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0004
[    7.839312] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    7.839324] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    7.839336] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    7.847245] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    7.886859] hda_codec: ALC268: BIOS auto-probing.
[    7.914084] hub 5-0:1.0: state 7 ports 2 chg 0004 evt 0000
[    7.914112] hub 5-0:1.0: port 2, status 0301, change 0000, 1.5 Mb/s
[    7.957578] fuse init (API version 7.15)
[    8.016050] usb 5-2: new low speed USB device using uhci_hcd and address 2
[    8.160376] usb 5-2: skipped 1 descriptor after interface
[    8.160383] usb 5-2: skipped 1 descriptor after interface
[    8.165371] usb 5-2: default language 0x0409
[    8.178063] firewire_core: created device fw0: GUID 0000c010a000b000, S400
[    8.184389] usb 5-2: udev 2, busnum 5, minor = 513
[    8.184394] usb 5-2: New USB device found, idVendor=046d, idProduct=c512
[    8.184398] usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    8.184402] usb 5-2: Product: 2.4GHz Cordless Desktop
[    8.184405] usb 5-2: Manufacturer: Logitech
[    8.184837] usb 5-2: usb_probe_device
[    8.184843] usb 5-2: configuration #1 chosen from 1 choice
[    8.187396] usb 5-2: adding 5-2:1.0 (config #1, interface 0)
[    8.187563] usbhid 5-2:1.0: usb_probe_interface
[    8.187568] usbhid 5-2:1.0: usb_probe_interface - got id
[    8.202098] input: Logitech 2.4GHz Cordless Desktop as /devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2:1.0/input/input7
[    8.202273] uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[    8.203506] logitech 0003:046D:C512.0001: input,hidraw0: USB HID v1.11 Keyboard [Logitech 2.4GHz Cordless Desktop] on usb-0000:00:1d.0-2/input0
[    8.203581] usb 5-2: adding 5-2:1.1 (config #1, interface 1)
[    8.203680] usbhid 5-2:1.1: usb_probe_interface
[    8.203685] usbhid 5-2:1.1: usb_probe_interface - got id
[    8.234190] input: Logitech 2.4GHz Cordless Desktop as /devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2:1.1/input/input8
[    8.234220] uhci_hcd 0000:00:1d.0: reserve dev 2 ep82-INT, period 8, phase 4, 118 us
[    8.234535] drivers/usb/core/file.c: looking for a minor, starting at 0
[    8.235450] logitech 0003:046D:C512.0002: input,hiddev0,hidraw1: USB HID v1.11 Mouse [Logitech 2.4GHz Cordless Desktop] on usb-0000:00:1d.0-2/input1
[    8.235518] drivers/usb/core/inode.c: creating file '002'
[    8.303623] input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input9
[    8.343193] input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio1/input/input10
[    8.865057] EXT4-fs (sda1): re-mounted. Opts: (null)
[    8.954050] usb usb3: suspend_rh (auto-stop)
[    8.954086] usb usb4: suspend_rh (auto-stop)
[    8.954117] usb usb6: suspend_rh (auto-stop)
[    8.954148] usb usb7: suspend_rh (auto-stop)
[    9.712291] hub 1-0:1.0: hub_suspend
[    9.712393] usb usb1: bus auto-suspend
[    9.712397] ehci_hcd 0000:00:1a.7: suspend root hub
[   10.712104] hub 2-0:1.0: hub_suspend
[   10.712125] usb usb2: bus auto-suspend
[   10.712133] ehci_hcd 0000:00:1d.7: suspend root hub
[   10.712178] hub 3-0:1.0: hub_suspend
[   10.712191] usb usb3: bus auto-suspend
[   10.712223] usb usb3: suspend_rh
[   10.712256] hub 4-0:1.0: hub_suspend
[   10.712263] usb usb4: bus auto-suspend
[   10.712266] usb usb4: suspend_rh
[   10.712289] hub 6-0:1.0: hub_suspend
[   10.712296] usb usb6: bus auto-suspend
[   10.712299] usb usb6: suspend_rh
[   10.712321] hub 7-0:1.0: hub_suspend
[   10.712328] usb usb7: bus auto-suspend
[   10.712331] usb usb7: suspend_rh
[   21.686291] EXT4-fs (sda1): re-mounted. Opts: (null)
[   21.767568] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
[   21.792219] Adding 4000180k swap on /dev/sda4.  Priority:-1 extents:1 across:4000180k 
[   23.888053] r8169 0000:07:00.0: eth0: link up
[   23.888010] r8169 0000:07:00.0: eth0: link up
[   33.225346] 
[   33.225348] =================================
[   33.226017] [ INFO: inconsistent lock state ]
[   33.226017] 2.6.35-BISECT+ #8
[   33.226017] ---------------------------------
[   33.226017] inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
[   33.226017] iptables/1777 [HC0[0]:SC0[0]:HE1:SE1] takes:
[   33.226017]  (&(&lock->lock)->rlock){+.?...}, at: [<ffffffff81337748>] get_counters+0x9d/0x146
[   33.226017] {IN-SOFTIRQ-W} state was registered at:
[   33.226017]   [<ffffffff81067ab1>] __lock_acquire+0x635/0x16a3
[   33.226017]   [<ffffffff81069050>] lock_acquire+0xef/0x115
[   33.226017]   [<ffffffff813a1be9>] _raw_spin_lock+0x36/0x45
[   33.226017]   [<ffffffff81337898>] ipt_do_table+0xa7/0x3af
[   33.226017]   [<ffffffff81339bc7>] iptable_mangle_hook+0x105/0x11a
[   33.226017]   [<ffffffff812e7bbf>] nf_iterate+0x41/0x84
[   33.226017]   [<ffffffff812e7c9a>] nf_hook_slow+0x98/0x13a
[   33.226017]   [<ffffffff812f8f6c>] ip_rcv+0x26e/0x2aa
[   33.226017]   [<ffffffff812c3f9e>] __netif_receive_skb+0x47f/0x4df
[   33.226017]   [<ffffffff812c4b4c>] netif_receive_skb+0x125/0x134
[   33.226017]   [<ffffffffa01c94b9>] rtl8169_rx_interrupt.clone.36+0x345/0x428 [r8169]
[   33.226017]   [<ffffffffa01c96cb>] rtl8169_poll+0x30/0x16f [r8169]
[   33.226017]   [<ffffffff812c669e>] net_rx_action+0xbb/0x201
[   33.226017]   [<ffffffff81041865>] __do_softirq+0x126/0x218
[   33.226017]   [<ffffffff8100394c>] call_softirq+0x1c/0x28
[   33.226017]   [<ffffffff81004ef7>] do_softirq+0x38/0x81
[   33.226017]   [<ffffffff81041a12>] irq_exit+0x45/0x90
[   33.226017]   [<ffffffff81004b9c>] do_IRQ+0xac/0xc3
[   33.226017]   [<ffffffff813a2853>] ret_from_intr+0x0/0xf
[   33.226017]   [<ffffffff8129c3bf>] cpuidle_idle_call+0x98/0x12d
[   33.226017]   [<ffffffff81001189>] cpu_idle+0x65/0xed
[   33.226017]   [<ffffffff8138ff4f>] rest_init+0xf3/0xfa
[   33.226017]   [<ffffffff81698b9f>] start_kernel+0x3a6/0x3b1
[   33.226017]   [<ffffffff816982a1>] x86_64_start_reservations+0xb1/0xb5
[   33.226017]   [<ffffffff8169838e>] x86_64_start_kernel+0xe9/0xf0
[   33.226017] irq event stamp: 3211
[   33.226017] hardirqs last  enabled at (3211): [<ffffffff810413a0>] local_bh_enable+0xb8/0xd7
[   33.226017] hardirqs last disabled at (3209): [<ffffffff8104133a>] local_bh_enable+0x52/0xd7
[   33.226017] softirqs last  enabled at (3210): [<ffffffff8133771b>] get_counters+0x70/0x146
[   33.226017] softirqs last disabled at (3208): [<ffffffff813376d9>] get_counters+0x2e/0x146
[   33.226017] 
[   33.226017] other info that might help us debug this:
[   33.226017] 2 locks held by iptables/1777:
[   33.226017]  #0:  (sk_lock-AF_INET){+.+.+.}, at: [<ffffffff812fed5d>] ip_getsockopt+0x5d/0xa3
[   33.226017]  #1:  (&xt[i].mutex){+.+.+.}, at: [<ffffffff812f18d4>] xt_find_table_lock+0x3b/0x177
[   33.226017] 
[   33.226017] stack backtrace:
[   33.226017] Pid: 1777, comm: iptables Not tainted 2.6.35-BISECT+ #8
[   33.226017] Call Trace:
[   33.226017]  [<ffffffff81066f3b>] print_usage_bug+0x1a7/0x1b8
[   33.226017]  [<ffffffff8100d908>] ? save_stack_trace+0x2a/0x47
[   33.226017]  [<ffffffff81066672>] ? check_usage_backwards+0x0/0xd1
[   33.226017]  [<ffffffff81067235>] mark_lock+0x2e9/0x530
[   33.226017]  [<ffffffff81067b34>] __lock_acquire+0x6b8/0x16a3
[   33.226017]  [<ffffffff8119247c>] ? rb_insert_color+0xb8/0xe1
[   33.226017]  [<ffffffff810e858f>] ? __kmalloc_node+0x14f/0x213
[   33.226017]  [<ffffffff81337748>] ? get_counters+0x9d/0x146
[   33.226017]  [<ffffffff81069050>] lock_acquire+0xef/0x115
[   33.226017]  [<ffffffff81337748>] ? get_counters+0x9d/0x146
[   33.226017]  [<ffffffff813a1be9>] _raw_spin_lock+0x36/0x45
[   33.226017]  [<ffffffff81337748>] ? get_counters+0x9d/0x146
[   33.226017]  [<ffffffff810413a0>] ? local_bh_enable+0xb8/0xd7
[   33.226017]  [<ffffffff81337748>] get_counters+0x9d/0x146
[   33.226017]  [<ffffffff81338326>] alloc_counters.clone.4+0x2d/0x41
[   33.226017]  [<ffffffff81338709>] do_ipt_get_ctl+0x117/0x363
[   33.226017]  [<ffffffff813a0c48>] ? mutex_unlock+0x9/0xb
[   33.226017]  [<ffffffff812b7610>] ? lock_sock_nested+0x6e/0x79
[   33.226017]  [<ffffffff812e9005>] nf_sockopt+0x53/0x7f
[   33.226017]  [<ffffffff812e9044>] nf_getsockopt+0x13/0x15
[   33.226017]  [<ffffffff812fed74>] ip_getsockopt+0x74/0xa3
[   33.226017]  [<ffffffff813194cb>] raw_getsockopt+0x18/0x26
[   33.226017]  [<ffffffff812b6b20>] sock_common_getsockopt+0xf/0x11
[   33.226017]  [<ffffffff812b600b>] sys_getsockopt+0x75/0x96
[   33.226017]  [<ffffffff81002a2b>] system_call_fastpath+0x16/0x1b
[   39.940895] EXT4-fs (sda1): re-mounted. Opts: commit=0
[   39.944156] EXT4-fs (sda3): re-mounted. Opts: commit=0
[  304.204373] kworker/u:0 used greatest stack depth: 3408 bytes left

--=-OBN4LlFZ77jFHrUcDmS8
Content-Disposition: attachment; filename="xorg.log.1"
Content-Type: text/plain; name="xorg.log.1"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[    34.236] 
This is a pre-release version of the X server from The X.Org Foundation.
It is not supported in any way.
Bugs may be filed in the bugzilla at http://bugs.freedesktop.org/.
Select the "xorg" product for bugs you find in this release.
Before reporting bugs in pre-release versions please check the
latest version in the X.Org Foundation git repository.
See http://wiki.x.org/wiki/GitPage for git access instructions.
[    34.236] 
X.Org X Server 1.8.1.902 (1.8.2 RC 2)
Release Date: 2010-06-21
[    34.236] X Protocol Version 11, Revision 0
[    34.236] Build Operating System: Linux 2.6.34-ARCH x86_64 
[    34.236] Current Operating System: Linux vostro 2.6.35-BISECT+ #8 SMP PREEMPT Tue Aug 24 02:13:06 CEST 2010 x86_64
[    34.237] Kernel command line: root=/dev/sda1 ro video=LVDS-1:d
[    34.237] Build Date: 21 June 2010  12:01:49PM
[    34.237]  
[    34.237] Current version of pixman: 0.18.4
[    34.237] 	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
[    34.237] Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[    34.237] (==) Log file: "/var/log/Xorg.0.log", Time: Tue Aug 24 02:15:49 2010
[    34.238] (==) Using config directory: "/etc/X11/xorg.conf.d"
[    34.276] (==) No Layout section.  Using the first Screen section.
[    34.276] (==) No screen section available. Using defaults.
[    34.276] (**) |-->Screen "Default Screen Section" (0)
[    34.276] (**) |   |-->Monitor "<default monitor>"
[    34.277] (==) No monitor specified for screen "Default Screen Section".
	Using a default monitor configuration.
[    34.277] (==) Automatically adding devices
[    34.277] (==) Automatically enabling devices
[    34.278] (WW) The directory "/usr/share/fonts/OTF/" does not exist.
[    34.278] 	Entry deleted from font path.
[    34.278] (==) FontPath set to:
	/usr/share/fonts/misc/,
	/usr/share/fonts/TTF/,
	/usr/share/fonts/Type1/,
	/usr/share/fonts/100dpi/,
	/usr/share/fonts/75dpi/
[    34.278] (==) ModulePath set to "/usr/lib/xorg/modules"
[    34.278] (II) The server relies on udev to provide the list of input devices.
	If no devices become available, reconfigure udev or disable AutoAddDevices.
[    34.278] (II) Loader magic: 0x7ce880
[    34.278] (II) Module ABI versions:
[    34.278] 	X.Org ANSI C Emulation: 0.4
[    34.278] 	X.Org Video Driver: 7.0
[    34.278] 	X.Org XInput driver : 9.0
[    34.278] 	X.Org Server Extension : 3.0
[    34.291] (--) PCI:*(0:0:2:0) 8086:2a02:1028:026f Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller rev 12, Mem @ 0xf8000000/1048576, 0xd0000000/268435456, I/O @ 0x00001800/8
[    34.292] (--) PCI: (0:0:2:1) 8086:2a03:1028:026f Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller rev 12, Mem @ 0xf8100000/1048576
[    34.313] (WW) Open ACPI failed (/var/run/acpid.socket) (No such file or directory)
[    34.313] (II) LoadModule: "extmod"
[    34.314] (II) Loading /usr/lib/xorg/modules/extensions/libextmod.so
[    34.330] (II) Module extmod: vendor="X.Org Foundation"
[    34.330] 	compiled for 1.8.1.902, module version = 1.0.0
[    34.330] 	Module class: X.Org Server Extension
[    34.330] 	ABI class: X.Org Server Extension, version 3.0
[    34.330] (II) Loading extension MIT-SCREEN-SAVER
[    34.330] (II) Loading extension XFree86-VidModeExtension
[    34.330] (II) Loading extension XFree86-DGA
[    34.330] (II) Loading extension DPMS
[    34.330] (II) Loading extension XVideo
[    34.330] (II) Loading extension XVideo-MotionCompensation
[    34.330] (II) Loading extension X-Resource
[    34.330] (II) LoadModule: "dbe"
[    34.331] (II) Loading /usr/lib/xorg/modules/extensions/libdbe.so
[    34.344] (II) Module dbe: vendor="X.Org Foundation"
[    34.344] 	compiled for 1.8.1.902, module version = 1.0.0
[    34.344] 	Module class: X.Org Server Extension
[    34.344] 	ABI class: X.Org Server Extension, version 3.0
[    34.344] (II) Loading extension DOUBLE-BUFFER
[    34.344] (II) LoadModule: "glx"
[    34.344] (II) Loading /usr/lib/xorg/modules/extensions/libglx.so
[    34.352] (II) Module glx: vendor="X.Org Foundation"
[    34.352] 	compiled for 1.8.1.902, module version = 1.0.0
[    34.352] 	ABI class: X.Org Server Extension, version 3.0
[    34.352] (==) AIGLX enabled
[    34.352] (II) Loading extension GLX
[    34.353] (II) LoadModule: "record"
[    34.353] (II) Loading /usr/lib/xorg/modules/extensions/librecord.so
[    34.354] (II) Module record: vendor="X.Org Foundation"
[    34.354] 	compiled for 1.8.1.902, module version = 1.13.0
[    34.354] 	Module class: X.Org Server Extension
[    34.354] 	ABI class: X.Org Server Extension, version 3.0
[    34.354] (II) Loading extension RECORD
[    34.354] (II) LoadModule: "dri"
[    34.355] (II) Loading /usr/lib/xorg/modules/extensions/libdri.so
[    34.372] (II) Module dri: vendor="X.Org Foundation"
[    34.372] 	compiled for 1.8.1.902, module version = 1.0.0
[    34.373] 	ABI class: X.Org Server Extension, version 3.0
[    34.373] (II) Loading extension XFree86-DRI
[    34.373] (II) LoadModule: "dri2"
[    34.373] (II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
[    34.374] (II) Module dri2: vendor="X.Org Foundation"
[    34.374] 	compiled for 1.8.1.902, module version = 1.2.0
[    34.374] 	ABI class: X.Org Server Extension, version 3.0
[    34.374] (II) Loading extension DRI2
[    34.374] (==) Matched intel as autoconfigured driver 0
[    34.374] (==) Matched vesa as autoconfigured driver 1
[    34.374] (==) Matched fbdev as autoconfigured driver 2
[    34.374] (==) Assigned the driver to the xf86ConfigLayout
[    34.374] (II) LoadModule: "intel"
[    34.374] (II) Loading /usr/lib/xorg/modules/drivers/intel_drv.so
[    34.391] (II) Module intel: vendor="X.Org Foundation"
[    34.391] 	compiled for 1.8.1.902, module version = 2.12.0
[    34.391] 	Module class: X.Org Video Driver
[    34.391] 	ABI class: X.Org Video Driver, version 7.0
[    34.391] (II) LoadModule: "vesa"
[    34.392] (II) Loading /usr/lib/xorg/modules/drivers/vesa_drv.so
[    34.404] (II) Module vesa: vendor="X.Org Foundation"
[    34.404] 	compiled for 1.8.0, module version = 2.3.0
[    34.405] 	Module class: X.Org Video Driver
[    34.405] 	ABI class: X.Org Video Driver, version 7.0
[    34.405] (II) LoadModule: "fbdev"
[    34.406] (WW) Warning, couldn't open module fbdev
[    34.406] (II) UnloadModule: "fbdev"
[    34.406] (EE) Failed to load module "fbdev" (module does not exist, 0)
[    34.406] (II) intel: Driver for Intel Integrated Graphics Chipsets: i810,
	i810-dc100, i810e, i815, i830M, 845G, 852GM/855GM, 865G, 915G,
	E7221 (i915), 915GM, 945G, 945GM, 945GME, Pineview GM, Pineview G,
	965G, G35, 965Q, 946GZ, 965GM, 965GME/GLE, G33, Q35, Q33, GM45,
	4 Series, G45/G43, Q45/Q43, G41, B43, Clarkdale, Arrandale
[    34.409] (II) VESA: driver for VESA chipsets: vesa
[    34.409] (++) using VT number 7

[    34.419] (II) Primary Device is: PCI 00@00:02:0
[    34.419] (WW) Falling back to old probe method for vesa
[    34.421] drmOpenDevice: node name is /dev/dri/card0
[    34.421] drmOpenDevice: open result is 8, (OK)
[    34.431] drmOpenByBusid: Searching for BusID pci:0000:00:02.0
[    34.431] drmOpenDevice: node name is /dev/dri/card0
[    34.431] drmOpenDevice: open result is 8, (OK)
[    34.431] drmOpenByBusid: drmOpenMinor returns 8
[    34.431] drmOpenByBusid: drmGetBusid reports pci:0000:00:02.0
[    34.431] (II) intel(0): Creating default Display subsection in Screen section
	"Default Screen Section" for depth/fbbpp 24/32
[    34.431] (==) intel(0): Depth 24, (--) framebuffer bpp 32
[    34.431] (==) intel(0): RGB weight 888
[    34.431] (==) intel(0): Default visual is TrueColor
[    34.431] (II) intel(0): Integrated Graphics Chipset: Intel(R) 965GM
[    34.431] (--) intel(0): Chipset: "965GM"
[    34.431] (==) intel(0): video overlay key set to 0x101fe
[    34.432] (II) intel(0): Output LVDS1 has no monitor section
[    34.432] (II) intel(0): found backlight control interface /sys/class/backlight/acpi_video0
[    34.560] (II) intel(0): Output VGA1 has no monitor section
[    35.095] (II) intel(0): Output TV1 has no monitor section
[    35.095] (II) intel(0): EDID for output LVDS1
[    35.209] (II) intel(0): EDID for output VGA1
[    35.209] (II) intel(0): Manufacturer: SAM  Model: 217  Serial#: 1296380217
[    35.209] (II) intel(0): Year: 2007  Week: 31
[    35.209] (II) intel(0): EDID Version: 1.3
[    35.209] (II) intel(0): Analog Display Input,  Input Voltage Level: 0.700/0.300 V
[    35.209] (II) intel(0): Sync:  Separate  Composite  SyncOnGreen
[    35.209] (II) intel(0): Max Image Size [cm]: horiz.: 38  vert.: 30
[    35.209] (II) intel(0): Gamma: 2.20
[    35.209] (II) intel(0): DPMS capabilities: Off; RGB/Color Display
[    35.210] (II) intel(0): First detailed timing is preferred mode
[    35.210] (II) intel(0): redX: 0.648 redY: 0.339   greenX: 0.292 greenY: 0.603
[    35.210] (II) intel(0): blueX: 0.143 blueY: 0.070   whiteX: 0.313 whiteY: 0.329
[    35.210] (II) intel(0): Supported established timings:
[    35.210] (II) intel(0): 720x400@70Hz
[    35.210] (II) intel(0): 640x480@60Hz
[    35.210] (II) intel(0): 640x480@67Hz
[    35.210] (II) intel(0): 640x480@72Hz
[    35.210] (II) intel(0): 640x480@75Hz
[    35.210] (II) intel(0): 800x600@56Hz
[    35.210] (II) intel(0): 800x600@60Hz
[    35.210] (II) intel(0): 800x600@72Hz
[    35.210] (II) intel(0): 800x600@75Hz
[    35.210] (II) intel(0): 832x624@75Hz
[    35.210] (II) intel(0): 1024x768@60Hz
[    35.210] (II) intel(0): 1024x768@70Hz
[    35.210] (II) intel(0): 1024x768@75Hz
[    35.210] (II) intel(0): 1280x1024@75Hz
[    35.210] (II) intel(0): 1152x864@75Hz
[    35.210] (II) intel(0): Manufacturer's mask: 0
[    35.210] (II) intel(0): Supported standard timings:
[    35.210] (II) intel(0): #0: hsize: 1280  vsize 1024  refresh: 60  vid: 32897
[    35.210] (II) intel(0): #1: hsize: 1280  vsize 960  refresh: 60  vid: 16513
[    35.210] (II) intel(0): #2: hsize: 1152  vsize 864  refresh: 75  vid: 20337
[    35.210] (II) intel(0): Supported detailed timing:
[    35.210] (II) intel(0): clock: 108.0 MHz   Image Size:  376 x 301 mm
[    35.210] (II) intel(0): h_active: 1280  h_sync: 1328  h_sync_end 1440 h_blank_end 1688 h_border: 0
[    35.210] (II) intel(0): v_active: 1024  v_sync: 1025  v_sync_end 1028 v_blanking: 1066 v_border: 0
[    35.210] (II) intel(0): Ranges: V min: 56 V max: 75 Hz, H min: 30 H max: 81 kHz, PixClock max 140 MHz
[    35.210] (II) intel(0): Monitor name: SyncMaster
[    35.210] (II) intel(0): Serial No: H9LP801577
[    35.210] (II) intel(0): EDID (in hex):
[    35.211] (II) intel(0): 	00ffffffffffff004c2d17023931454d
[    35.211] (II) intel(0): 	1f1101030e261e782a3d85a6564a9a24
[    35.211] (II) intel(0): 	125054bfef8081808140714f01010101
[    35.211] (II) intel(0): 	010101010101302a009851002a403070
[    35.211] (II) intel(0): 	1300782d1100001e000000fd00384b1e
[    35.211] (II) intel(0): 	510e000a202020202020000000fc0053
[    35.211] (II) intel(0): 	796e634d61737465720a2020000000ff
[    35.211] (II) intel(0): 	0048394c503830313537370a2020002e
[    35.211] (II) intel(0): Printing probed modes for output VGA1
[    35.211] (II) intel(0): Modeline "1280x1024"x60.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    35.211] (II) intel(0): Modeline "1280x1024"x75.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    35.211] (II) intel(0): Modeline "1280x960"x60.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[    35.211] (II) intel(0): Modeline "1152x864"x75.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    35.211] (II) intel(0): Modeline "1024x768"x75.1   78.80  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.1 kHz)
[    35.211] (II) intel(0): Modeline "1024x768"x70.1   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    35.211] (II) intel(0): Modeline "1024x768"x60.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    35.211] (II) intel(0): Modeline "832x624"x74.6   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    35.211] (II) intel(0): Modeline "800x600"x72.2   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    35.211] (II) intel(0): Modeline "800x600"x75.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    35.211] (II) intel(0): Modeline "800x600"x60.3   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    35.211] (II) intel(0): Modeline "800x600"x56.2   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    35.211] (II) intel(0): Modeline "640x480"x72.8   31.50  640 664 704 832  480 489 491 520 -hsync -vsync (37.9 kHz)
[    35.211] (II) intel(0): Modeline "640x480"x75.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    35.211] (II) intel(0): Modeline "640x480"x66.7   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[    35.211] (II) intel(0): Modeline "640x480"x60.0   25.20  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    35.211] (II) intel(0): Modeline "720x400"x70.1   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    35.350] (II) intel(0): EDID for output TV1
[    35.350] (II) intel(0): Not using default mode "640x350" (vrefresh out of range)
[    35.350] (II) intel(0): Not using default mode "320x175" (doublescan mode not supported)
[    35.350] (II) intel(0): Not using default mode "640x400" (vrefresh out of range)
[    35.350] (II) intel(0): Not using default mode "320x200" (doublescan mode not supported)
[    35.350] (II) intel(0): Not using default mode "720x400" (vrefresh out of range)
[    35.350] (II) intel(0): Not using default mode "360x200" (doublescan mode not supported)
[    35.350] (II) intel(0): Not using default mode "640x480" (vrefresh out of range)
[    35.350] (II) intel(0): Not using default mode "320x240" (doublescan mode not supported)
[    35.350] (II) intel(0): Not using default mode "640x480" (vrefresh out of range)
[    35.350] (II) intel(0): Not using default mode "320x240" (doublescan mode not supported)
[    35.350] (II) intel(0): Not using default mode "640x480" (vrefresh out of range)
[    35.350] (II) intel(0): Not using default mode "320x240" (doublescan mode not supported)
[    35.350] (II) intel(0): Not using default mode "640x480" (vrefresh out of range)
[    35.350] (II) intel(0): Not using default mode "320x240" (doublescan mode not supported)
[    35.350] (II) intel(0): Not using default mode "800x600" (vrefresh out of range)
[    35.351] (II) intel(0): Not using default mode "400x300" (doublescan mode not supported)
[    35.351] (II) intel(0): Not using default mode "800x600" (vrefresh out of range)
[    35.351] (II) intel(0): Not using default mode "400x300" (doublescan mode not supported)
[    35.351] (II) intel(0): Not using default mode "800x600" (vrefresh out of range)
[    35.351] (II) intel(0): Not using default mode "400x300" (doublescan mode not supported)
[    35.351] (II) intel(0): Not using default mode "800x600" (vrefresh out of range)
[    35.351] (II) intel(0): Not using default mode "400x300" (doublescan mode not supported)
[    35.351] (II) intel(0): Not using default mode "800x600" (vrefresh out of range)
[    35.351] (II) intel(0): Not using default mode "400x300" (doublescan mode not supported)
[    35.351] (II) intel(0): Not using default mode "1024x768i" (interlace mode not supported)
[    35.351] (II) intel(0): Not using default mode "512x384i" (doublescan mode not supported)
[    35.351] (II) intel(0): Not using default mode "1024x768" (vrefresh out of range)
[    35.351] (II) intel(0): Not using default mode "512x384" (doublescan mode not supported)
[    35.351] (II) intel(0): Not using default mode "1024x768" (vrefresh out of range)
[    35.351] (II) intel(0): Not using default mode "512x384" (doublescan mode not supported)
[    35.351] (II) intel(0): Not using default mode "1024x768" (vrefresh out of range)
[    35.351] (II) intel(0): Not using default mode "512x384" (doublescan mode not supported)
[    35.351] (II) intel(0): Not using default mode "1024x768" (vrefresh out of range)
[    35.351] (II) intel(0): Not using default mode "512x384" (doublescan mode not supported)
[    35.351] (II) intel(0): Not using default mode "1152x864" (vrefresh out of range)
[    35.351] (II) intel(0): Not using default mode "576x432" (doublescan mode not supported)
[    35.351] (II) intel(0): Not using default mode "1280x960" (vrefresh out of range)
[    35.351] (II) intel(0): Not using default mode "640x480" (doublescan mode not supported)
[    35.351] (II) intel(0): Not using default mode "1280x960" (vrefresh out of range)
[    35.351] (II) intel(0): Not using default mode "640x480" (doublescan mode not supported)
[    35.351] (II) intel(0): Not using default mode "1280x1024" (vrefresh out of range)
[    35.351] (II) intel(0): Not using default mode "640x512" (doublescan mode not supported)
[    35.351] (II) intel(0): Not using default mode "1280x1024" (vrefresh out of range)
[    35.351] (II) intel(0): Not using default mode "640x512" (doublescan mode not supported)
[    35.351] (II) intel(0): Not using default mode "1280x1024" (vrefresh out of range)
[    35.351] (II) intel(0): Not using default mode "640x512" (doublescan mode not supported)
[    35.351] (II) intel(0): Not using default mode "1600x1200" (vrefresh out of range)
[    35.351] (II) intel(0): Not using default mode "800x600" (doublescan mode not supported)
[    35.351] (II) intel(0): Not using default mode "1600x1200" (vrefresh out of range)
[    35.351] (II) intel(0): Not using default mode "800x600" (doublescan mode not supported)
[    35.351] (II) intel(0): Not using default mode "1600x1200" (vrefresh out of range)
[    35.351] (II) intel(0): Not using default mode "800x600" (doublescan mode not supported)
[    35.351] (II) intel(0): Not using default mode "1600x1200" (vrefresh out of range)
[    35.351] (II) intel(0): Not using default mode "800x600" (doublescan mode not supported)
[    35.351] (II) intel(0): Not using default mode "1600x1200" (vrefresh out of range)
[    35.352] (II) intel(0): Not using default mode "800x600" (doublescan mode not supported)
[    35.352] (II) intel(0): Not using default mode "1792x1344" (vrefresh out of range)
[    35.352] (II) intel(0): Not using default mode "896x672" (doublescan mode not supported)
[    35.352] (II) intel(0): Not using default mode "1792x1344" (vrefresh out of range)
[    35.352] (II) intel(0): Not using default mode "896x672" (doublescan mode not supported)
[    35.352] (II) intel(0): Not using default mode "1856x1392" (vrefresh out of range)
[    35.352] (II) intel(0): Not using default mode "928x696" (doublescan mode not supported)
[    35.352] (II) intel(0): Not using default mode "1856x1392" (vrefresh out of range)
[    35.352] (II) intel(0): Not using default mode "928x696" (doublescan mode not supported)
[    35.352] (II) intel(0): Not using default mode "1920x1440" (vrefresh out of range)
[    35.352] (II) intel(0): Not using default mode "960x720" (doublescan mode not supported)
[    35.352] (II) intel(0): Not using default mode "1920x1440" (vrefresh out of range)
[    35.352] (II) intel(0): Not using default mode "960x720" (doublescan mode not supported)
[    35.352] (II) intel(0): Not using default mode "832x624" (vrefresh out of range)
[    35.352] (II) intel(0): Not using default mode "416x312" (doublescan mode not supported)
[    35.352] (II) intel(0): Not using default mode "1400x1050" (vrefresh out of range)
[    35.352] (II) intel(0): Not using default mode "700x525" (doublescan mode not supported)
[    35.352] (II) intel(0): Not using default mode "1400x1050" (vrefresh out of range)
[    35.352] (II) intel(0): Not using default mode "700x525" (doublescan mode not supported)
[    35.352] (II) intel(0): Not using default mode "1920x1440" (vrefresh out of range)
[    35.352] (II) intel(0): Not using default mode "960x720" (doublescan mode not supported)
[    35.352] (II) intel(0): Not using default mode "2048x1536" (vrefresh out of range)
[    35.352] (II) intel(0): Not using default mode "1024x768" (doublescan mode not supported)
[    35.352] (II) intel(0): Not using default mode "2048x1536" (vrefresh out of range)
[    35.352] (II) intel(0): Not using default mode "1024x768" (doublescan mode not supported)
[    35.352] (II) intel(0): Not using default mode "2048x1536" (vrefresh out of range)
[    35.352] (II) intel(0): Not using default mode "1024x768" (doublescan mode not supported)
[    35.352] (II) intel(0): Printing probed modes for output TV1
[    35.352] (II) intel(0): Modeline "848x480"x30.0   14.51  848 849 912 944  480 481 512 513 (15.4 kHz)
[    35.352] (II) intel(0): Modeline "640x480"x30.0   11.31  640 641 704 736  480 481 512 513 (15.4 kHz)
[    35.352] (II) intel(0): Modeline "1024x768"x30.0   26.89  1024 1025 1088 1120  768 769 800 801 (24.0 kHz)
[    35.352] (II) intel(0): Modeline "800x600"x30.0   17.00  800 801 864 896  600 601 632 633 (19.0 kHz)
[    35.352] (II) intel(0): Output LVDS1 disconnected
[    35.352] (II) intel(0): Output VGA1 connected
[    35.352] (II) intel(0): Output TV1 connected
[    35.352] (II) intel(0): Using fuzzy aspect match for initial modes
[    35.352] (II) intel(0): Output VGA1 using initial mode 1024x768
[    35.352] (II) intel(0): Output TV1 using initial mode 1024x768
[    35.353] (II) intel(0): Using default gamma of (1.0, 1.0, 1.0) unless otherwise stated.
[    35.353] (II) intel(0): Pageflipping enabled in kernel, but disabled in X
[    35.353] (II) intel(0): Don't panic: https://bugzilla.redhat.com/588421
[    35.353] (==) intel(0): DPI set to (96, 96)
[    35.353] (II) Loading sub module "fb"
[    35.353] (II) LoadModule: "fb"
[    35.353] (II) Loading /usr/lib/xorg/modules/libfb.so
[    35.367] (II) Module fb: vendor="X.Org Foundation"
[    35.367] 	compiled for 1.8.1.902, module version = 1.0.0
[    35.367] 	ABI class: X.Org ANSI C Emulation, version 0.4
[    35.367] (II) UnloadModule: "vesa"
[    35.367] (II) Unloading /usr/lib/xorg/modules/drivers/vesa_drv.so
[    35.367] (==) Depth 24 pixmap format is 32 bpp
[    35.367] (II) intel(0): [DRI2] Setup complete
[    35.367] (II) intel(0): [DRI2]   DRI driver: i965
[    35.367] (**) intel(0): Tiling enabled
[    35.367] (**) intel(0): SwapBuffers wait enabled
[    35.367] (==) intel(0): VideoRam: 262144 KB
[    35.367] (II) intel(0): Allocated new frame buffer 1024x768 stride 4096, tiled
[    35.394] (II) UXA(0): Driver registered support for the following operations:
[    35.394] (II)         solid
[    35.394] (II)         copy
[    35.394] (II)         composite (RENDER acceleration)
[    35.394] (II)         put_image
[    35.394] (II)         get_image
[    35.403] (==) intel(0): Backing store disabled
[    35.403] (==) intel(0): Silken mouse enabled
[    35.404] (II) intel(0): Initializing HW Cursor
[    35.663] (II) intel(0): RandR 1.2 enabled, ignore the following RandR disabled message.
[    35.687] (==) intel(0): DPMS enabled
[    35.687] (==) intel(0): Intel XvMC decoder enabled
[    35.687] (II) intel(0): Set up textured video
[    35.687] (II) intel(0): Set up overlay video
[    35.688] (II) intel(0): [XvMC] i965_xvmc driver initialized.
[    35.688] (II) intel(0): direct rendering: DRI2 Enabled
[    35.688] (--) RandR disabled
[    35.688] (II) Initializing built-in extension Generic Event Extension
[    35.688] (II) Initializing built-in extension SHAPE
[    35.688] (II) Initializing built-in extension MIT-SHM
[    35.688] (II) Initializing built-in extension XInputExtension
[    35.688] (II) Initializing built-in extension XTEST
[    35.688] (II) Initializing built-in extension BIG-REQUESTS
[    35.688] (II) Initializing built-in extension SYNC
[    35.688] (II) Initializing built-in extension XKEYBOARD
[    35.688] (II) Initializing built-in extension XC-MISC
[    35.688] (II) Initializing built-in extension SECURITY
[    35.688] (II) Initializing built-in extension XINERAMA
[    35.688] (II) Initializing built-in extension XFIXES
[    35.688] (II) Initializing built-in extension RENDER
[    35.688] (II) Initializing built-in extension RANDR
[    35.688] (II) Initializing built-in extension COMPOSITE
[    35.688] (II) Initializing built-in extension DAMAGE
[    35.778] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[    35.778] (II) AIGLX: enabled GLX_INTEL_swap_event
[    35.778] (II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_control
[    35.778] (II) AIGLX: enabled GLX_SGI_make_current_read
[    35.778] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects
[    35.779] (II) AIGLX: Loaded and initialized /usr/lib/xorg/modules/dri/i965_dri.so
[    35.779] (II) GLX: Initialized DRI2 GL provider for screen 0
[    35.780] (II) intel(0): Setting screen physical size to 270 x 203
[    36.194] (II) config/udev: Adding input device Power Button (/dev/input/event3)
[    36.194] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    36.194] (II) LoadModule: "evdev"
[    36.194] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    36.198] (II) Module evdev: vendor="X.Org Foundation"
[    36.198] 	compiled for 1.8.1.902, module version = 2.4.0
[    36.198] 	Module class: X.Org XInput Driver
[    36.198] 	ABI class: X.Org XInput driver, version 9.0
[    36.198] (**) Power Button: always reports core events
[    36.198] (**) Power Button: Device: "/dev/input/event3"
[    36.205] (II) Power Button: Found keys
[    36.205] (II) Power Button: Configuring as keyboard
[    36.205] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
[    36.205] (**) Option "xkb_rules" "evdev"
[    36.205] (**) Option "xkb_model" "evdev"
[    36.205] (**) Option "xkb_layout" "us"
[    36.249] (II) config/udev: Adding input device Video Bus (/dev/input/event4)
[    36.249] (**) Video Bus: Applying InputClass "evdev keyboard catchall"
[    36.249] (**) Video Bus: always reports core events
[    36.249] (**) Video Bus: Device: "/dev/input/event4"
[    36.252] (II) Video Bus: Found keys
[    36.252] (II) Video Bus: Configuring as keyboard
[    36.252] (II) XINPUT: Adding extended input device "Video Bus" (type: KEYBOARD)
[    36.252] (**) Option "xkb_rules" "evdev"
[    36.252] (**) Option "xkb_model" "evdev"
[    36.252] (**) Option "xkb_layout" "us"
[    36.257] (II) config/udev: Adding input device Power Button (/dev/input/event1)
[    36.257] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    36.257] (**) Power Button: always reports core events
[    36.257] (**) Power Button: Device: "/dev/input/event1"
[    36.260] (II) Power Button: Found keys
[    36.260] (II) Power Button: Configuring as keyboard
[    36.260] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
[    36.260] (**) Option "xkb_rules" "evdev"
[    36.260] (**) Option "xkb_model" "evdev"
[    36.260] (**) Option "xkb_layout" "us"
[    36.260] (II) config/udev: Adding input device Lid Switch (/dev/input/event0)
[    36.260] (II) No input driver/identifier specified (ignoring)
[    36.261] (II) config/udev: Adding input device Sleep Button (/dev/input/event2)
[    36.261] (**) Sleep Button: Applying InputClass "evdev keyboard catchall"
[    36.261] (**) Sleep Button: always reports core events
[    36.261] (**) Sleep Button: Device: "/dev/input/event2"
[    36.269] (II) Sleep Button: Found keys
[    36.269] (II) Sleep Button: Configuring as keyboard
[    36.269] (II) XINPUT: Adding extended input device "Sleep Button" (type: KEYBOARD)
[    36.269] (**) Option "xkb_rules" "evdev"
[    36.269] (**) Option "xkb_model" "evdev"
[    36.269] (**) Option "xkb_layout" "us"
[    36.281] (II) config/udev: Adding input device Logitech 2.4GHz Cordless Desktop (/dev/input/event7)
[    36.282] (**) Logitech 2.4GHz Cordless Desktop: Applying InputClass "evdev keyboard catchall"
[    36.282] (**) Logitech 2.4GHz Cordless Desktop: always reports core events
[    36.282] (**) Logitech 2.4GHz Cordless Desktop: Device: "/dev/input/event7"
[    36.289] (II) Logitech 2.4GHz Cordless Desktop: Found keys
[    36.289] (II) Logitech 2.4GHz Cordless Desktop: Configuring as keyboard
[    36.289] (II) XINPUT: Adding extended input device "Logitech 2.4GHz Cordless Desktop" (type: KEYBOARD)
[    36.289] (**) Option "xkb_rules" "evdev"
[    36.289] (**) Option "xkb_model" "evdev"
[    36.289] (**) Option "xkb_layout" "us"
[    36.291] (II) config/udev: Adding input device Logitech 2.4GHz Cordless Desktop (/dev/input/event8)
[    36.291] (**) Logitech 2.4GHz Cordless Desktop: Applying InputClass "evdev pointer catchall"
[    36.291] (**) Logitech 2.4GHz Cordless Desktop: Applying InputClass "evdev keyboard catchall"
[    36.291] (**) Logitech 2.4GHz Cordless Desktop: always reports core events
[    36.292] (**) Logitech 2.4GHz Cordless Desktop: Device: "/dev/input/event8"
[    36.297] (II) Logitech 2.4GHz Cordless Desktop: Found 10 mouse buttons
[    36.297] (II) Logitech 2.4GHz Cordless Desktop: Found scroll wheel(s)
[    36.297] (II) Logitech 2.4GHz Cordless Desktop: Found relative axes
[    36.297] (II) Logitech 2.4GHz Cordless Desktop: Found x and y relative axes
[    36.297] (II) Logitech 2.4GHz Cordless Desktop: Found absolute axes
[    36.297] (II) Logitech 2.4GHz Cordless Desktop: Found keys
[    36.297] (II) Logitech 2.4GHz Cordless Desktop: Configuring as mouse
[    36.297] (II) Logitech 2.4GHz Cordless Desktop: Configuring as keyboard
[    36.297] (**) Logitech 2.4GHz Cordless Desktop: YAxisMapping: buttons 4 and 5
[    36.297] (**) Logitech 2.4GHz Cordless Desktop: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[    36.297] (II) XINPUT: Adding extended input device "Logitech 2.4GHz Cordless Desktop" (type: KEYBOARD)
[    36.297] (**) Option "xkb_rules" "evdev"
[    36.298] (**) Option "xkb_model" "evdev"
[    36.298] (**) Option "xkb_layout" "us"
[    36.298] (**) Logitech 2.4GHz Cordless Desktop: (accel) keeping acceleration scheme 1
[    36.298] (**) Logitech 2.4GHz Cordless Desktop: (accel) acceleration profile 0
[    36.298] (**) Logitech 2.4GHz Cordless Desktop: (accel) acceleration factor: 2.000
[    36.298] (**) Logitech 2.4GHz Cordless Desktop: (accel) acceleration threshold: 4
[    36.298] (II) Logitech 2.4GHz Cordless Desktop: initialized for relative axes.
[    36.299] (WW) Logitech 2.4GHz Cordless Desktop: ignoring absolute axes.
[    36.299] (II) config/udev: Adding input device Logitech 2.4GHz Cordless Desktop (/dev/input/mouse0)
[    36.300] (II) No input driver/identifier specified (ignoring)
[    36.311] (II) config/udev: Adding input device AT Translated Set 2 keyboard (/dev/input/event5)
[    36.311] (**) AT Translated Set 2 keyboard: Applying InputClass "evdev keyboard catchall"
[    36.311] (**) AT Translated Set 2 keyboard: always reports core events
[    36.311] (**) AT Translated Set 2 keyboard: Device: "/dev/input/event5"
[    36.317] (II) AT Translated Set 2 keyboard: Found keys
[    36.317] (II) AT Translated Set 2 keyboard: Configuring as keyboard
[    36.317] (II) XINPUT: Adding extended input device "AT Translated Set 2 keyboard" (type: KEYBOARD)
[    36.317] (**) Option "xkb_rules" "evdev"
[    36.317] (**) Option "xkb_model" "evdev"
[    36.317] (**) Option "xkb_layout" "us"
[    36.318] (II) config/udev: Adding input device AlpsPS/2 ALPS GlidePoint (/dev/input/event10)
[    36.319] (**) AlpsPS/2 ALPS GlidePoint: Applying InputClass "evdev touchpad catchall"
[    36.319] (**) AlpsPS/2 ALPS GlidePoint: Applying InputClass "touchpad catchall"
[    36.319] (II) LoadModule: "synaptics"
[    36.319] (II) Loading /usr/lib/xorg/modules/input/synaptics_drv.so
[    36.326] (II) Module synaptics: vendor="X.Org Foundation"
[    36.326] 	compiled for 1.8.0.902, module version = 1.2.2
[    36.327] 	Module class: X.Org XInput Driver
[    36.327] 	ABI class: X.Org XInput driver, version 9.0
[    36.327] (II) Synaptics touchpad driver version 1.2.2
[    36.327] (**) Option "Device" "/dev/input/event10"
[    36.365] (II) AlpsPS/2 ALPS GlidePoint: x-axis range 0 - 1023
[    36.365] (II) AlpsPS/2 ALPS GlidePoint: y-axis range 0 - 767
[    36.365] (II) AlpsPS/2 ALPS GlidePoint: pressure range 0 - 127
[    36.365] (II) AlpsPS/2 ALPS GlidePoint: finger width range 0 - 0
[    36.365] (II) AlpsPS/2 ALPS GlidePoint: buttons: left right middle
[    36.365] (**) Option "TapButton1" "1"
[    36.365] (**) Option "TapButton2" "2"
[    36.365] (**) Option "TapButton3" "3"
[    36.397] (--) AlpsPS/2 ALPS GlidePoint: touchpad found
[    36.397] (**) AlpsPS/2 ALPS GlidePoint: always reports core events
[    36.413] (II) XINPUT: Adding extended input device "AlpsPS/2 ALPS GlidePoint" (type: TOUCHPAD)
[    36.413] (**) AlpsPS/2 ALPS GlidePoint: (accel) keeping acceleration scheme 1
[    36.413] (**) AlpsPS/2 ALPS GlidePoint: (accel) acceleration profile 0
[    36.413] (**) AlpsPS/2 ALPS GlidePoint: (accel) acceleration factor: 2.000
[    36.413] (**) AlpsPS/2 ALPS GlidePoint: (accel) acceleration threshold: 4
[    36.437] (--) AlpsPS/2 ALPS GlidePoint: touchpad found
[    36.438] (II) config/udev: Adding input device AlpsPS/2 ALPS GlidePoint (/dev/input/mouse2)
[    36.438] (**) AlpsPS/2 ALPS GlidePoint: Applying InputClass "touchpad catchall"
[    36.438] (II) Synaptics touchpad driver version 1.2.2
[    36.957] AlpsPS/2 ALPS GlidePoint no synaptics event device found
[    36.957] (**) Option "Device" "/dev/input/mouse2"
[    36.965] (**) Option "TapButton1" "1"
[    36.965] (**) Option "TapButton2" "2"
[    36.965] (**) Option "TapButton3" "3"
[    36.985] Query no Synaptics: 6003C8
[    36.985] (--) AlpsPS/2 ALPS GlidePoint: no supported touchpad found
[    36.986] (EE) AlpsPS/2 ALPS GlidePoint Unable to query/initialize Synaptics hardware.
[    36.998] (EE) PreInit failed for input device "AlpsPS/2 ALPS GlidePoint"
[    36.998] (II) UnloadModule: "synaptics"
[    36.999] (II) config/udev: Adding input device PS/2 Mouse (/dev/input/event9)
[    36.999] (**) PS/2 Mouse: Applying InputClass "evdev pointer catchall"
[    36.999] (**) PS/2 Mouse: always reports core events
[    36.999] (**) PS/2 Mouse: Device: "/dev/input/event9"
[    37.006] (II) PS/2 Mouse: Found 3 mouse buttons
[    37.006] (II) PS/2 Mouse: Found relative axes
[    37.006] (II) PS/2 Mouse: Found x and y relative axes
[    37.006] (II) PS/2 Mouse: Configuring as mouse
[    37.006] (**) PS/2 Mouse: YAxisMapping: buttons 4 and 5
[    37.006] (**) PS/2 Mouse: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[    37.006] (II) XINPUT: Adding extended input device "PS/2 Mouse" (type: MOUSE)
[    37.006] (**) PS/2 Mouse: (accel) keeping acceleration scheme 1
[    37.006] (**) PS/2 Mouse: (accel) acceleration profile 0
[    37.006] (**) PS/2 Mouse: (accel) acceleration factor: 2.000
[    37.007] (**) PS/2 Mouse: (accel) acceleration threshold: 4
[    37.007] (II) PS/2 Mouse: initialized for relative axes.
[    37.007] (II) config/udev: Adding input device PS/2 Mouse (/dev/input/mouse1)
[    37.007] (II) No input driver/identifier specified (ignoring)
[    37.016] (II) config/udev: Adding input device Dell WMI hotkeys (/dev/input/event6)
[    37.016] (**) Dell WMI hotkeys: Applying InputClass "evdev keyboard catchall"
[    37.016] (**) Dell WMI hotkeys: always reports core events
[    37.016] (**) Dell WMI hotkeys: Device: "/dev/input/event6"
[    37.022] (II) Dell WMI hotkeys: Found keys
[    37.022] (II) Dell WMI hotkeys: Configuring as keyboard
[    37.022] (II) XINPUT: Adding extended input device "Dell WMI hotkeys" (type: KEYBOARD)
[    37.022] (**) Option "xkb_rules" "evdev"
[    37.022] (**) Option "xkb_model" "evdev"
[    37.022] (**) Option "xkb_layout" "us"
[    40.397] (II) intel(0): EDID vendor "SAM", prod id 535
[    40.398] (II) intel(0): Using EDID range info for horizontal sync
[    40.398] (II) intel(0): Using EDID range info for vertical refresh
[    40.398] (II) intel(0): Printing DDC gathered Modelines:
[    40.398] (II) intel(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    40.398] (II) intel(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    40.398] (II) intel(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    40.398] (II) intel(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    40.398] (II) intel(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
[    40.398] (II) intel(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[    40.398] (II) intel(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    40.398] (II) intel(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    40.398] (II) intel(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    40.398] (II) intel(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    40.398] (II) intel(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    40.398] (II) intel(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    40.398] (II) intel(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    40.398] (II) intel(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    40.398] (II) intel(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    40.398] (II) intel(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    40.398] (II) intel(0): Modeline "1280x960"x0.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[    40.731] (II) intel(0): EDID vendor "SAM", prod id 535
[    40.731] (II) intel(0): Using hsync ranges from config file
[    40.731] (II) intel(0): Using vrefresh ranges from config file
[    40.732] (II) intel(0): Printing DDC gathered Modelines:
[    40.732] (II) intel(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    40.732] (II) intel(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    40.732] (II) intel(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    40.732] (II) intel(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    40.732] (II) intel(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
[    40.732] (II) intel(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[    40.732] (II) intel(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    40.732] (II) intel(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    40.732] (II) intel(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    40.732] (II) intel(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    40.732] (II) intel(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    40.732] (II) intel(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    40.732] (II) intel(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    40.732] (II) intel(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    40.732] (II) intel(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    40.732] (II) intel(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    40.732] (II) intel(0): Modeline "1280x960"x0.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[    48.557] (II) intel(0): EDID vendor "SAM", prod id 535
[    48.557] (II) intel(0): Using hsync ranges from config file
[    48.557] (II) intel(0): Using vrefresh ranges from config file
[    48.557] (II) intel(0): Printing DDC gathered Modelines:
[    48.557] (II) intel(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    48.557] (II) intel(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    48.557] (II) intel(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    48.557] (II) intel(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    48.557] (II) intel(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
[    48.557] (II) intel(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[    48.557] (II) intel(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    48.557] (II) intel(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    48.557] (II) intel(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    48.557] (II) intel(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    48.557] (II) intel(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    48.557] (II) intel(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    48.557] (II) intel(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    48.557] (II) intel(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    48.557] (II) intel(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    48.557] (II) intel(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    48.557] (II) intel(0): Modeline "1280x960"x0.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[    48.672] (II) intel(0): EDID vendor "SAM", prod id 535
[    48.672] (II) intel(0): Using hsync ranges from config file
[    48.672] (II) intel(0): Using vrefresh ranges from config file
[    48.672] (II) intel(0): Printing DDC gathered Modelines:
[    48.672] (II) intel(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    48.672] (II) intel(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    48.672] (II) intel(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    48.672] (II) intel(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    48.672] (II) intel(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
[    48.672] (II) intel(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[    48.672] (II) intel(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    48.672] (II) intel(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    48.672] (II) intel(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    48.672] (II) intel(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    48.672] (II) intel(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    48.672] (II) intel(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    48.672] (II) intel(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    48.672] (II) intel(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    48.673] (II) intel(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    48.673] (II) intel(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    48.673] (II) intel(0): Modeline "1280x960"x0.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[    48.789] (II) intel(0): EDID vendor "SAM", prod id 535
[    48.789] (II) intel(0): Using hsync ranges from config file
[    48.789] (II) intel(0): Using vrefresh ranges from config file
[    48.789] (II) intel(0): Printing DDC gathered Modelines:
[    48.789] (II) intel(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    48.789] (II) intel(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    48.789] (II) intel(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    48.790] (II) intel(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    48.790] (II) intel(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
[    48.790] (II) intel(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[    48.790] (II) intel(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    48.790] (II) intel(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    48.790] (II) intel(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    48.790] (II) intel(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    48.790] (II) intel(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    48.790] (II) intel(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    48.790] (II) intel(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    48.790] (II) intel(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    48.790] (II) intel(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    48.790] (II) intel(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    48.790] (II) intel(0): Modeline "1280x960"x0.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[    48.844] (II) intel(0): Allocated new frame buffer 1280x1024 stride 5120, tiled
[    51.945] (II) intel(0): EDID vendor "SAM", prod id 535
[    51.945] (II) intel(0): Using hsync ranges from config file
[    51.945] (II) intel(0): Using vrefresh ranges from config file
[    51.945] (II) intel(0): Printing DDC gathered Modelines:
[    51.945] (II) intel(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    51.945] (II) intel(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    51.945] (II) intel(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    51.945] (II) intel(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    51.945] (II) intel(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
[    51.945] (II) intel(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[    51.945] (II) intel(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    51.945] (II) intel(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    51.945] (II) intel(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    51.945] (II) intel(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    51.945] (II) intel(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    51.946] (II) intel(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    51.946] (II) intel(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    51.946] (II) intel(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    51.946] (II) intel(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    51.946] (II) intel(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    51.946] (II) intel(0): Modeline "1280x960"x0.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[    52.518] (II) intel(0): Allocated new frame buffer 2176x1024 stride 8704, tiled
[   167.513] (II) intel(0): EDID vendor "SAM", prod id 535
[   167.513] (II) intel(0): Using hsync ranges from config file
[   167.513] (II) intel(0): Using vrefresh ranges from config file
[   167.513] (II) intel(0): Printing DDC gathered Modelines:
[   167.513] (II) intel(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[   167.513] (II) intel(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[   167.513] (II) intel(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[   167.513] (II) intel(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[   167.513] (II) intel(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
[   167.513] (II) intel(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[   167.513] (II) intel(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[   167.513] (II) intel(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[   167.513] (II) intel(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[   167.514] (II) intel(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[   167.514] (II) intel(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[   167.514] (II) intel(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[   167.514] (II) intel(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[   167.514] (II) intel(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[   167.514] (II) intel(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[   167.514] (II) intel(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[   167.514] (II) intel(0): Modeline "1280x960"x0.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[   167.908] (II) intel(0): Allocated new frame buffer 1280x1024 stride 5120, tiled

--=-OBN4LlFZ77jFHrUcDmS8
Content-Disposition: attachment; filename="xrandr.log.1"
Content-Type: text/plain; name="xrandr.log.1"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Screen 0: minimum 320 x 200, current 1280 x 1024, maximum 8192 x 8192
LVDS1 disconnected (normal left inverted right x axis y axis)
VGA1 connected 1280x1024+0+0 (normal left inverted right x axis y axis) 376mm x 301mm
   1280x1024      60.0*+   75.0  
   1280x960       60.0  
   1152x864       75.0  
   1024x768       75.1     70.1     60.0  
   832x624        74.6  
   800x600        72.2     75.0     60.3     56.2  
   640x480        72.8     75.0     66.7     60.0  
   720x400        70.1  
TV1 connected 848x480+1280+0 (normal left inverted right x axis y axis) 0mm x 0mm
   848x480        30.0*+
   640x480        30.0 +
   1024x768       30.0  
   800x600        30.0  

--=-OBN4LlFZ77jFHrUcDmS8--

