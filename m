Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab0JDPgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 11:36:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39586 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287Ab0JDPgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 11:36:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type;
        b=YgocLopecQ4xjFYIsM5PHr2PdJWuUQwbhbaVRP/euzVGmTqOCD32Ng9ljsV3eV69uQ
         LYriEQ+YbQpvDpk8kXD5kXg6er8dehUAmt0Xu3LL9ADoSlJiQ00Pv/JoxL2sKcPwwIsv
         Twmaosl0Mr3Y1oih8EX1peYIGkg77CKRL3Z7c=
Message-ID: <4CA9F471.2080704@suse.cz>
Date: Mon, 04 Oct 2010 17:36:17 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.9) Gecko/20100914 SUSE/3.1.4 Thunderbird/3.1.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: clemens@ladisch.de, venki@google.com, Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: HPET causes tasks to freeze (still in 2.6.36-rc6)
X-Enigmail-Version: 1.1.2
Content-Type: multipart/mixed;
 boundary="------------040701010505050605080607"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040701010505050605080607
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit

Hi,

HPET as a clocksource has still issues in the latest kernels (confirmed
in 2.6.36-rc6) at least on x86_64. Unless clocksource=jiffies,
clocksource=tsc or nolapic_timer is used, the system is unusable. Tasks
are not woken unless mouse is moved, key is pressed (or other hard irq
triggered). 2.6.32 seems to be the last working.

The bug was originally reported in the bugzilla here:
https://bugzilla.novell.com/show_bug.cgi?id=579932

To quote:
"My clock is seriously lagging behind. After having used hpet for 10.5
hours now, the clock is 5.5 hours too late!"

dmesg is attached. Any ideas what's still wrong with HPET?

thanks,
-- 
js
suse labs

--------------040701010505050605080607
Content-Type: text/plain;
 name="dm"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dm"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.35.7-nordalkernel (nordal@singularitet) (gcc version 4.4.3 (Gentoo 4.4.3-r2 p1.2) ) #2 SMP Thu Sep 30 13:39:13 CEST 2010
[    0.000000] Command line: root=/dev/sda2
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fed0000 (usable)
[    0.000000]  BIOS-e820: 000000007fed0000 - 000000007fee3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007fee3000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!
[    0.000000] DMI present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x7fed0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 07FF00000 mask FFFF00000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 0000000000001000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009f800 (usable)
[    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000007fed0000 (usable)
[    0.000000]  modified: 000000007fed0000 - 000000007fee3000 (ACPI NVS)
[    0.000000]  modified: 000000007fee3000 - 0000000080000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  modified: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000f7bc0] f7bc0
[    0.000000] init_memory_mapping: 0000000000000000-000000007fed0000
[    0.000000]  0000000000 - 007fe00000 page 2M
[    0.000000]  007fe00000 - 007fed0000 page 4k
[    0.000000] kernel direct mapping tables up to 7fed0000 @ 16000-1a000
[    0.000000] ACPI: RSDP 00000000000f7b40 00024 (v02 Compal)
[    0.000000] ACPI: XSDT 000000007fed7c40 00094 (v01 Compal CRESTLNE 06040000  LTP 00000000)
[    0.000000] ACPI: FACP 000000007fedfbd2 000F4 (v03 INTEL  CRESTLNE 06040000 ALAN 00000001)
[    0.000000] ACPI: DSDT 000000007fed9b51 0600D (v02 Compal CRESTLNE 06040000 INTL 20061109)
[    0.000000] ACPI: FACS 000000007fee2fc0 00040
[    0.000000] ACPI: APIC 000000007fedfcc6 00068 (v01 INTEL  CRESTLNE 06040000 LOHR 0000005A)
[    0.000000] ACPI: HPET 000000007fedfd2e 00038 (v01 Compal CRESTLNE 06040000 LOHR 0000005A)
[    0.000000] ACPI: MCFG 000000007fedfd66 0003C (v01 INTEL  CRESTLNE 06040000 LOHR 0000005A)
[    0.000000] ACPI: TCPA 000000007fedfda2 00032 (v01 Intel  CRESTLNE 06040000 LOHR 0000005A)
[    0.000000] ACPI: TMOR 000000007fedfdd4 00026 (v01 PTLTD           06040000 PTL  00000003)
[    0.000000] ACPI: SLIC 000000007fedfdfa 00176 (v01 Compal CRESTLNE 06040000 TBD  00000001)
[    0.000000] ACPI: APIC 000000007fedff70 00068 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT 000000007fedffd8 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: SSDT 000000007fed9502 0064F (v01 SataRe  SataPri 00001000 INTL 20050624)
[    0.000000] ACPI: SSDT 000000007fed8e70 00692 (v01 SataRe  SataSec 00001000 INTL 20050624)
[    0.000000] ACPI: SSDT 000000007fed8260 0025F (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 000000007fed81ba 000A6 (v01  PmRef  Cpu1Tst 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 000000007fed7cd4 004E6 (v01  PmRef    CpuPm 00003000 INTL 20050624)
[    0.000000] ACPI: BIOS bug: multiple APIC/MADT found, using 0
[    0.000000] ACPI: If "acpi_apic_instance=2" works better, notify linux-acpi@vger.kernel.org
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff880002400000-ffff880003ffffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007fed0
[    0.000000] On node 0 totalpages: 523871
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3927 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7108 pages used for memmap
[    0.000000]   DMA32 zone: 512780 pages, LIFO batch:31
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
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:7ec00000)
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880001c00000 s78144 r8192 d24256 u1048576
[    0.000000] pcpu-alloc: s78144 r8192 d24256 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 516707
[    0.000000] Kernel command line: root=/dev/sda2
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Subtract (49 early reservations)
[    0.000000]   #1 [0001000000 - 0001a75684]   TEXT DATA BSS
[    0.000000]   #2 [0001a76000 - 0001a761a8]             BRK
[    0.000000]   #3 [00000f7bd0 - 0000100000]   BIOS reserved
[    0.000000]   #4 [00000f7bc0 - 00000f7bd0]    MP-table mpf
[    0.000000]   #5 [000009f800 - 000009fd71]   BIOS reserved
[    0.000000]   #6 [000009ff35 - 00000f7bc0]   BIOS reserved
[    0.000000]   #7 [000009fd71 - 000009ff35]    MP-table mpc
[    0.000000]   #8 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #9 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #10 [0000016000 - 0000018000]         PGTABLE
[    0.000000]   #11 [0001a761c0 - 0001a771c0]         BOOTMEM
[    0.000000]   #12 [0001a756c0 - 0001a75840]         BOOTMEM
[    0.000000]   #13 [0002278000 - 0002279000]         BOOTMEM
[    0.000000]   #14 [0002279000 - 000227a000]         BOOTMEM
[    0.000000]   #15 [0002400000 - 0004000000]        MEMMAP 0
[    0.000000]   #16 [0001a75840 - 0001a759c0]         BOOTMEM
[    0.000000]   #17 [0001a771c0 - 0001a831c0]         BOOTMEM
[    0.000000]   #18 [0001a84000 - 0001a85000]         BOOTMEM
[    0.000000]   #19 [0001a759c0 - 0001a75a01]         BOOTMEM
[    0.000000]   #20 [0001a75a40 - 0001a75a83]         BOOTMEM
[    0.000000]   #21 [0001a75ac0 - 0001a75d98]         BOOTMEM
[    0.000000]   #22 [0001a75dc0 - 0001a75e28]         BOOTMEM
[    0.000000]   #23 [0001a75e40 - 0001a75ea8]         BOOTMEM
[    0.000000]   #24 [0001a75ec0 - 0001a75f28]         BOOTMEM
[    0.000000]   #25 [0001a75f40 - 0001a75fa8]         BOOTMEM
[    0.000000]   #26 [0001a831c0 - 0001a83228]         BOOTMEM
[    0.000000]   #27 [0001a83240 - 0001a832a8]         BOOTMEM
[    0.000000]   #28 [0001a832c0 - 0001a83328]         BOOTMEM
[    0.000000]   #29 [0001a83340 - 0001a833a8]         BOOTMEM
[    0.000000]   #30 [0001a833c0 - 0001a83428]         BOOTMEM
[    0.000000]   #31 [0001a83440 - 0001a834a8]         BOOTMEM
[    0.000000]   #32 [0001a834c0 - 0001a83528]         BOOTMEM
[    0.000000]   #33 [0001a83540 - 0001a835a8]         BOOTMEM
[    0.000000]   #34 [0001a75fc0 - 0001a75fe0]         BOOTMEM
[    0.000000]   #35 [0001a835c0 - 0001a835cf]         BOOTMEM
[    0.000000]   #36 [0001a83600 - 0001a8360f]         BOOTMEM
[    0.000000]   #37 [0001c00000 - 0001c1b000]         BOOTMEM
[    0.000000]   #38 [0001d00000 - 0001d1b000]         BOOTMEM
[    0.000000]   #39 [0001a83640 - 0001a83648]         BOOTMEM
[    0.000000]   #40 [0001a83680 - 0001a83688]         BOOTMEM
[    0.000000]   #41 [0001a836c0 - 0001a836c8]         BOOTMEM
[    0.000000]   #42 [0001a83700 - 0001a83710]         BOOTMEM
[    0.000000]   #43 [0001a83740 - 0001a83880]         BOOTMEM
[    0.000000]   #44 [0001a83880 - 0001a838e0]         BOOTMEM
[    0.000000]   #45 [0001a83900 - 0001a83960]         BOOTMEM
[    0.000000]   #46 [0001a85000 - 0001a8d000]         BOOTMEM
[    0.000000]   #47 [0001d1b000 - 0001f1b000]         BOOTMEM
[    0.000000]   #48 [0001a8d000 - 0001b8d000]         BOOTMEM
[    0.000000] Memory: 2052680k/2095936k available (6430k kernel code, 452k absent, 42804k reserved, 3257k data, 464k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:512
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2095.050 MHz processor.
[    0.001008] Calibrating delay loop (skipped), value calculated using timer frequency.. 4190.10 BogoMIPS (lpj=2095050)
[    0.001439] pid_max: default: 32768 minimum: 301
[    0.001672] Security Framework initialized
[    0.002006] SELinux:  Initializing.
[    0.002228] SELinux:  Starting in permissive mode
[    0.002235] Mount-cache hash table entries: 256
[    0.002587] Initializing cgroup subsys ns
[    0.002804] Initializing cgroup subsys cpuacct
[    0.003004] Initializing cgroup subsys freezer
[    0.003239] CPU: Physical Processor ID: 0
[    0.003453] CPU: Processor Core ID: 0
[    0.003668] mce: CPU supports 6 MCE banks
[    0.004007] CPU0: Thermal monitoring handled by SMI
[    0.004010] using mwait in idle threads.
[    0.004223] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.004762] ... version:                2
[    0.005002] ... bit width:              40
[    0.005217] ... generic registers:      2
[    0.006002] ... value mask:             000000ffffffffff
[    0.007002] ... max period:             000000007fffffff
[    0.007217] ... fixed-purpose events:   3
[    0.007433] ... event mask:             0000000700000003
[    0.007690] ACPI: Core revision 20100428
[    0.016060] Setting APIC routing to flat
[    0.016624] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.027140] CPU0: Intel(R) Core(TM)2 Duo CPU     T8100  @ 2.10GHz stepping 06
[    0.027999] Booting Node   0, Processors  #1 Ok.
[    0.001999] CPU1: Thermal monitoring handled by SMI
[    0.099013] Brought up 2 CPUs
[    0.099231] Total of 2 processors activated (8379.38 BogoMIPS).
[    0.100089] NET: Registered protocol family 16
[    0.101026] ACPI: bus type pci registered
[    0.101230] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.101367] PCI: not using MMCONFIG
[    0.101580] PCI: Using configuration type 1 for base access
[    0.108093] bio: create slab <bio-0> at 0
[    0.112615] ACPI: BIOS _OSI(Linux) query ignored
[    0.113881] ACPI: SSDT 000000007fed8b2e 0027A (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.114519] ACPI: Dynamic OEM Table Load:
[    0.115001] ACPI: SSDT (null) 0027A (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.115811] ACPI: SSDT 000000007fed84bf 005EA (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.116723] ACPI: Dynamic OEM Table Load:
[    0.117212] ACPI: SSDT (null) 005EA (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.118154] ACPI: SSDT 000000007fed8da8 000C8 (v01  PmRef  Cpu1Ist 00003000 INTL 20050624)
[    0.118989] ACPI: Dynamic OEM Table Load:
[    0.119320] ACPI: SSDT (null) 000C8 (v01  PmRef  Cpu1Ist 00003000 INTL 20050624)
[    0.120087] ACPI: SSDT 000000007fed8aa9 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20050624)
[    0.120916] ACPI: Dynamic OEM Table Load:
[    0.121319] ACPI: SSDT (null) 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20050624)
[    0.121930] ACPI: Interpreter enabled
[    0.122002] ACPI: (supports S0 S3 S4 S5)
[    0.122648] ACPI: Using IOAPIC for interrupt routing
[    0.123040] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.124251] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.199052] ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
[    0.199430] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.200547] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.201923] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.201926] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.201929] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.201932] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff] (ignored)
[    0.201934] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff] (ignored)
[    0.201936] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff] (ignored)
[    0.201939] pci_root PNP0A08:00: host bridge window [mem 0x80000000-0xdfffffff] (ignored)
[    0.201942] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfebfffff] (ignored)
[    0.202023] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.202026] pci 0000:00:01.0: PME# disabled
[    0.202110] pci 0000:00:1a.0: reg 20: [io  0x1800-0x181f]
[    0.202182] pci 0000:00:1a.1: reg 20: [io  0x1820-0x183f]
[    0.202249] pci 0000:00:1a.7: reg 10: [mem 0xf8404000-0xf84043ff]
[    0.202315] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.202320] pci 0000:00:1a.7: PME# disabled
[    0.202363] pci 0000:00:1b.0: reg 10: [mem 0xf8400000-0xf8403fff 64bit]
[    0.202425] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.202429] pci 0000:00:1b.0: PME# disabled
[    0.202523] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.202528] pci 0000:00:1c.0: PME# disabled
[    0.202625] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.202629] pci 0000:00:1c.1: PME# disabled
[    0.202724] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.202729] pci 0000:00:1c.2: PME# disabled
[    0.202822] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.202826] pci 0000:00:1c.3: PME# disabled
[    0.202923] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.202928] pci 0000:00:1c.4: PME# disabled
[    0.203058] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.203063] pci 0000:00:1c.5: PME# disabled
[    0.203122] pci 0000:00:1d.0: reg 20: [io  0x1840-0x185f]
[    0.203183] pci 0000:00:1d.1: reg 20: [io  0x1860-0x187f]
[    0.203254] pci 0000:00:1d.2: reg 20: [io  0x1880-0x189f]
[    0.203318] pci 0000:00:1d.7: reg 10: [mem 0xf8404400-0xf84047ff]
[    0.203381] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.203386] pci 0000:00:1d.7: PME# disabled
[    0.203546] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
[    0.203874] pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
[    0.204003] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
[    0.204331] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0700 (mask 0003)
[    0.204658] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0068 (mask 0007)
[    0.205003] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 1640 (mask 007f)
[    0.205376] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    0.205384] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    0.205391] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
[    0.205399] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
[    0.205407] pci 0000:00:1f.1: reg 20: [io  0x18a0-0x18af]
[    0.205459] pci 0000:00:1f.2: reg 10: [io  0x18f8-0x18ff]
[    0.205466] pci 0000:00:1f.2: reg 14: [io  0x18cc-0x18cf]
[    0.205474] pci 0000:00:1f.2: reg 18: [io  0x18f0-0x18f7]
[    0.205481] pci 0000:00:1f.2: reg 1c: [io  0x18c8-0x18cb]
[    0.205489] pci 0000:00:1f.2: reg 20: [io  0x18e0-0x18ef]
[    0.205496] pci 0000:00:1f.2: reg 24: [io  0x18d0-0x18df]
[    0.205527] pci 0000:00:1f.2: PME# supported from D3hot
[    0.205531] pci 0000:00:1f.2: PME# disabled
[    0.205556] pci 0000:00:1f.3: reg 10: [mem 0x00000000-0x000000ff]
[    0.205581] pci 0000:00:1f.3: reg 20: [io  0x1c00-0x1c1f]
[    0.205715] pci 0000:01:00.0: reg 10: [mem 0xc6000000-0xc6ffffff]
[    0.205754] pci 0000:01:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.205792] pci 0000:01:00.0: reg 1c: [mem 0xc4000000-0xc5ffffff 64bit]
[    0.205813] pci 0000:01:00.0: reg 24: [io  0x2000-0x207f]
[    0.205833] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.206055] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.206272] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    0.206275] pci 0000:00:01.0:   bridge window [mem 0xc4000000-0xc6ffffff]
[    0.206279] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.206339] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.206557] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    0.206561] pci 0000:00:1c.0:   bridge window [mem 0xbc000000-0xbfffffff]
[    0.206568] pci 0000:00:1c.0:   bridge window [mem 0xcc000000-0xcdffffff 64bit pref]
[    0.206778] pci 0000:04:00.0: reg 10: [mem 0xf0000000-0xf000ffff 64bit]
[    0.207004] pci 0000:04:00.0: PME# supported from D3hot D3cold
[    0.207015] pci 0000:04:00.0: PME# disabled
[    0.207056] pci 0000:00:1c.1: PCI bridge to [bus 04-04]
[    0.207275] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
[    0.207280] pci 0000:00:1c.1:   bridge window [mem 0xf0000000-0xf3ffffff]
[    0.207288] pci 0000:00:1c.1:   bridge window [mem 0xfa000000-0xfbffffff 64bit pref]
[    0.207349] pci 0000:00:1c.2: PCI bridge to [bus 06-06]
[    0.207567] pci 0000:00:1c.2:   bridge window [io  0x5000-0x5fff]
[    0.207572] pci 0000:00:1c.2:   bridge window [mem 0xf4000000-0xf7ffffff]
[    0.207579] pci 0000:00:1c.2:   bridge window [mem 0xfc000000-0xfdffffff 64bit pref]
[    0.207641] pci 0000:00:1c.3: PCI bridge to [bus 08-08]
[    0.207858] pci 0000:00:1c.3:   bridge window [io  0x6000-0x6fff]
[    0.207863] pci 0000:00:1c.3:   bridge window [mem 0xb4000000-0xb7ffffff]
[    0.207871] pci 0000:00:1c.3:   bridge window [mem 0xc8000000-0xc9ffffff 64bit pref]
[    0.207932] pci 0000:00:1c.4: PCI bridge to [bus 0a-0a]
[    0.208004] pci 0000:00:1c.4:   bridge window [io  0xf000-0x0000] (disabled)
[    0.208009] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.208017] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.208159] pci 0000:0c:00.0: reg 10: [mem 0xf8000000-0xf8001fff 64bit]
[    0.208290] pci 0000:0c:00.0: PME# supported from D0 D3hot D3cold
[    0.208302] pci 0000:0c:00.0: PME# disabled
[    0.208338] pci 0000:00:1c.5: PCI bridge to [bus 0c-0c]
[    0.208557] pci 0000:00:1c.5:   bridge window [io  0xf000-0x0000] (disabled)
[    0.208562] pci 0000:00:1c.5:   bridge window [mem 0xf8000000-0xf80fffff]
[    0.208569] pci 0000:00:1c.5:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.208637] pci 0000:0e:06.0: reg 10: [mem 0xf8100000-0xf81007ff]
[    0.208697] pci 0000:0e:06.0: supports D1 D2
[    0.208699] pci 0000:0e:06.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.208704] pci 0000:0e:06.0: PME# disabled
[    0.208739] pci 0000:0e:06.1: reg 10: [mem 0xf8100800-0xf81008ff]
[    0.208799] pci 0000:0e:06.1: supports D1 D2
[    0.208801] pci 0000:0e:06.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.208806] pci 0000:0e:06.1: PME# disabled
[    0.208841] pci 0000:0e:06.2: reg 10: [mem 0xf8100c00-0xf8100cff]
[    0.209056] pci 0000:0e:06.2: supports D1 D2
[    0.209057] pci 0000:0e:06.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.209062] pci 0000:0e:06.2: PME# disabled
[    0.209098] pci 0000:0e:06.3: reg 10: [mem 0xf8101000-0xf81010ff]
[    0.209156] pci 0000:0e:06.3: supports D1 D2
[    0.209158] pci 0000:0e:06.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.209163] pci 0000:0e:06.3: PME# disabled
[    0.209222] pci 0000:00:1e.0: PCI bridge to [bus 0e-0e] (subtractive decode)
[    0.209442] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.209447] pci 0000:00:1e.0:   bridge window [mem 0xf8100000-0xf81fffff]
[    0.209455] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.209457] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    0.209460] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffffffffffff] (subtractive decode)
[    0.209506] pci_bus 0000:00: on NUMA node 0
[    0.209511] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.209703] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    0.209782] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.209850] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.209918] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.209986] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    0.210061] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    0.210128] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    0.210223] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.216211] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 *5 6 7 10 12 14 15)
[    0.218417] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.220089] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 *7 10 12 14 15)
[    0.221816] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.223508] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.225298] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.226925] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.228611] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.230251] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.230360] vgaarb: loaded
[    0.231069] SCSI subsystem initialized
[    0.231231] libata version 3.00 loaded.
[    0.231231] usbcore: registered new interface driver usbfs
[    0.231242] usbcore: registered new interface driver hub
[    0.232012] usbcore: registered new device driver usb
[    0.232234] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    0.232237] PCI: Using ACPI for IRQ routing
[    0.233014] PCI: pci_cache_line_size set to 64 bytes
[    0.233220] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
[    0.233223] reserve RAM buffer: 000000007fed0000 - 000000007fffffff 
[    0.233239] cfg80211: Calling CRDA to update world regulatory domain
[    0.233239] NetLabel: Initializing
[    0.234008] NetLabel:  domain hash size = 128
[    0.234223] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.234450] NetLabel:  unlabeled traffic allowed by default
[    0.234674] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.235016] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.235649] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.238019] Switching to clocksource tsc
[    0.238265] pnp: PnP ACPI init
[    0.238484] ACPI: bus type pnp registered
[    0.259893] pnp: PnP ACPI: found 11 devices
[    0.260109] ACPI: ACPI bus type pnp unregistered
[    0.260332] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.260549] system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
[    0.260770] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.260987] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.261204] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.261423] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.261641] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.261862] system 00:01: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.262083] system 00:05: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.262303] system 00:07: [io  0x0680-0x069f] has been reserved
[    0.262521] system 00:07: [io  0x0800-0x080f] has been reserved
[    0.262741] system 00:07: [io  0x1000-0x107f] has been reserved
[    0.262958] system 00:07: [io  0x1180-0x11bf] has been reserved
[    0.263174] system 00:07: [io  0x1640-0x164f] has been reserved
[    0.263391] system 00:07: [io  0xfe00] has been reserved
[    0.263608] system 00:07: [io  0xff00-0xff7f] has been reserved
[    0.271270] pci 0000:00:1c.4: BAR 8: assigned [mem 0x80000000-0x801fffff]
[    0.271490] pci 0000:00:1c.4: BAR 9: assigned [mem 0x80200000-0x803fffff 64bit pref]
[    0.271819] pci 0000:00:1c.5: BAR 9: assigned [mem 0x80400000-0x805fffff 64bit pref]
[    0.272146] pci 0000:00:1c.4: BAR 7: assigned [io  0x7000-0x7fff]
[    0.272363] pci 0000:00:1c.5: BAR 7: assigned [io  0x8000-0x8fff]
[    0.272580] pci 0000:00:1f.3: BAR 0: assigned [mem 0x80600000-0x806000ff]
[    0.272803] pci 0000:00:1f.3: BAR 0: set to [mem 0x80600000-0x806000ff] (PCI address [0x80600000-0x806000ff]
[    0.273135] pci 0000:01:00.0: BAR 6: can't assign mem pref (size 0x20000)
[    0.273352] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.273569] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    0.273791] pci 0000:00:01.0:   bridge window [mem 0xc4000000-0xc6ffffff]
[    0.274010] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.274337] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.274554] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    0.274778] pci 0000:00:1c.0:   bridge window [mem 0xbc000000-0xbfffffff]
[    0.274998] pci 0000:00:1c.0:   bridge window [mem 0xcc000000-0xcdffffff 64bit pref]
[    0.275329] pci 0000:00:1c.1: PCI bridge to [bus 04-04]
[    0.275546] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
[    0.275769] pci 0000:00:1c.1:   bridge window [mem 0xf0000000-0xf3ffffff]
[    0.275988] pci 0000:00:1c.1:   bridge window [mem 0xfa000000-0xfbffffff 64bit pref]
[    0.276322] pci 0000:00:1c.2: PCI bridge to [bus 06-06]
[    0.276538] pci 0000:00:1c.2:   bridge window [io  0x5000-0x5fff]
[    0.276762] pci 0000:00:1c.2:   bridge window [mem 0xf4000000-0xf7ffffff]
[    0.276982] pci 0000:00:1c.2:   bridge window [mem 0xfc000000-0xfdffffff 64bit pref]
[    0.277312] pci 0000:00:1c.3: PCI bridge to [bus 08-08]
[    0.277529] pci 0000:00:1c.3:   bridge window [io  0x6000-0x6fff]
[    0.277752] pci 0000:00:1c.3:   bridge window [mem 0xb4000000-0xb7ffffff]
[    0.277972] pci 0000:00:1c.3:   bridge window [mem 0xc8000000-0xc9ffffff 64bit pref]
[    0.278303] pci 0000:00:1c.4: PCI bridge to [bus 0a-0a]
[    0.278520] pci 0000:00:1c.4:   bridge window [io  0x7000-0x7fff]
[    0.278744] pci 0000:00:1c.4:   bridge window [mem 0x80000000-0x801fffff]
[    0.278963] pci 0000:00:1c.4:   bridge window [mem 0x80200000-0x803fffff 64bit pref]
[    0.279293] pci 0000:00:1c.5: PCI bridge to [bus 0c-0c]
[    0.279509] pci 0000:00:1c.5:   bridge window [io  0x8000-0x8fff]
[    0.279730] pci 0000:00:1c.5:   bridge window [mem 0xf8000000-0xf80fffff]
[    0.279952] pci 0000:00:1c.5:   bridge window [mem 0x80400000-0x805fffff 64bit pref]
[    0.280284] pci 0000:00:1e.0: PCI bridge to [bus 0e-0e]
[    0.280498] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.280718] pci 0000:00:1e.0:   bridge window [mem 0xf8100000-0xf81fffff]
[    0.280941] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.281171]   alloc irq_desc for 16 on node -1
[    0.281173]   alloc kstat_irqs on node -1
[    0.281178] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.281396] pci 0000:00:01.0: setting latency timer to 64
[    0.281405]   alloc irq_desc for 17 on node -1
[    0.281406]   alloc kstat_irqs on node -1
[    0.281410] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.281628] pci 0000:00:1c.0: setting latency timer to 64
[    0.281638] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.281860] pci 0000:00:1c.1: setting latency timer to 64
[    0.281869]   alloc irq_desc for 18 on node -1
[    0.281871]   alloc kstat_irqs on node -1
[    0.281874] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.282092] pci 0000:00:1c.2: setting latency timer to 64
[    0.282101]   alloc irq_desc for 19 on node -1
[    0.282103]   alloc kstat_irqs on node -1
[    0.282106] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.282325] pci 0000:00:1c.3: setting latency timer to 64
[    0.282334] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.282554] pci 0000:00:1c.4: setting latency timer to 64
[    0.282564] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.282786] pci 0000:00:1c.5: setting latency timer to 64
[    0.282794] pci 0000:00:1e.0: setting latency timer to 64
[    0.282798] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.282800] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
[    0.282802] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    0.282804] pci_bus 0000:01: resource 1 [mem 0xc4000000-0xc6ffffff]
[    0.282806] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.282809] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
[    0.282810] pci_bus 0000:02: resource 1 [mem 0xbc000000-0xbfffffff]
[    0.282813] pci_bus 0000:02: resource 2 [mem 0xcc000000-0xcdffffff 64bit pref]
[    0.282815] pci_bus 0000:04: resource 0 [io  0x4000-0x4fff]
[    0.282817] pci_bus 0000:04: resource 1 [mem 0xf0000000-0xf3ffffff]
[    0.282819] pci_bus 0000:04: resource 2 [mem 0xfa000000-0xfbffffff 64bit pref]
[    0.282821] pci_bus 0000:06: resource 0 [io  0x5000-0x5fff]
[    0.282823] pci_bus 0000:06: resource 1 [mem 0xf4000000-0xf7ffffff]
[    0.282825] pci_bus 0000:06: resource 2 [mem 0xfc000000-0xfdffffff 64bit pref]
[    0.282827] pci_bus 0000:08: resource 0 [io  0x6000-0x6fff]
[    0.282829] pci_bus 0000:08: resource 1 [mem 0xb4000000-0xb7ffffff]
[    0.282832] pci_bus 0000:08: resource 2 [mem 0xc8000000-0xc9ffffff 64bit pref]
[    0.282834] pci_bus 0000:0a: resource 0 [io  0x7000-0x7fff]
[    0.282836] pci_bus 0000:0a: resource 1 [mem 0x80000000-0x801fffff]
[    0.282838] pci_bus 0000:0a: resource 2 [mem 0x80200000-0x803fffff 64bit pref]
[    0.282840] pci_bus 0000:0c: resource 0 [io  0x8000-0x8fff]
[    0.282842] pci_bus 0000:0c: resource 1 [mem 0xf8000000-0xf80fffff]
[    0.282844] pci_bus 0000:0c: resource 2 [mem 0x80400000-0x805fffff 64bit pref]
[    0.282846] pci_bus 0000:0e: resource 1 [mem 0xf8100000-0xf81fffff]
[    0.282848] pci_bus 0000:0e: resource 4 [io  0x0000-0xffff]
[    0.282850] pci_bus 0000:0e: resource 5 [mem 0x00000000-0xffffffffffffffff]
[    0.282880] NET: Registered protocol family 2
[    0.283141] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.283712] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.288430] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.289226] TCP: Hash tables configured (established 262144 bind 65536)
[    0.289442] TCP reno registered
[    0.289659] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.289897] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.290245] NET: Registered protocol family 1
[    0.290486] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x3000
[    0.290488] pci 0000:00:1a.0: Performing full reset
[    0.290508] pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x2000
[    0.290510] pci 0000:00:1a.1: Performing full reset
[    0.290585] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x2000
[    0.290587] pci 0000:00:1d.0: Performing full reset
[    0.290605] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x2000
[    0.290607] pci 0000:00:1d.1: Performing full reset
[    0.290626] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x2000
[    0.290628] pci 0000:00:1d.2: Performing full reset
[    0.290719] pci 0000:01:00.0: Boot video device
[    0.290813] PCI: CLS 64 bytes, default 64
[    0.290996] Simple Boot Flag at 0x38 set to 0x1
[    0.292071] microcode: CPU0 sig=0x10676, pf=0x80, revision=0x607
[    0.292291] microcode: CPU1 sig=0x10676, pf=0x80, revision=0x607
[    0.292546] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.292879] Scanning for low memory corruption every 60 seconds
[    0.293344] audit: initializing netlink socket (disabled)
[    0.293571] type=2000 audit(1285919428.291:1): initialized
[    0.323118] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.326143] NTFS driver 2.1.29 [Flags: R/W].
[    0.326465] fuse init (API version 7.14)
[    0.326989] msgmni has been set to 4009
[    0.327228] SELinux:  Registering netfilter hooks
[    0.327558] alg: No test for stdrng (krng)
[    0.327881] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.328206] io scheduler noop registered
[    0.328422] io scheduler deadline registered
[    0.328688] io scheduler cfq registered (default)
[    0.329011] pcieport 0000:00:01.0: setting latency timer to 64
[    0.329036]   alloc irq_desc for 40 on node -1
[    0.329038]   alloc kstat_irqs on node -1
[    0.329046] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.329175] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.329221]   alloc irq_desc for 41 on node -1
[    0.329223]   alloc kstat_irqs on node -1
[    0.329231] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
[    0.329388] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.329434]   alloc irq_desc for 42 on node -1
[    0.329435]   alloc kstat_irqs on node -1
[    0.329444] pcieport 0000:00:1c.1: irq 42 for MSI/MSI-X
[    0.329599] pcieport 0000:00:1c.2: setting latency timer to 64
[    0.329645]   alloc irq_desc for 43 on node -1
[    0.329646]   alloc kstat_irqs on node -1
[    0.329655] pcieport 0000:00:1c.2: irq 43 for MSI/MSI-X
[    0.329829] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.329874]   alloc irq_desc for 44 on node -1
[    0.329876]   alloc kstat_irqs on node -1
[    0.329884] pcieport 0000:00:1c.3: irq 44 for MSI/MSI-X
[    0.330040] pcieport 0000:00:1c.4: setting latency timer to 64
[    0.330086]   alloc irq_desc for 45 on node -1
[    0.330087]   alloc kstat_irqs on node -1
[    0.330096] pcieport 0000:00:1c.4: irq 45 for MSI/MSI-X
[    0.330253] pcieport 0000:00:1c.5: setting latency timer to 64
[    0.330298]   alloc irq_desc for 46 on node -1
[    0.330300]   alloc kstat_irqs on node -1
[    0.330308] pcieport 0000:00:1c.5: irq 46 for MSI/MSI-X
[    0.330548] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.335389] ACPI: AC Adapter [ACAD] (on-line)
[    0.335714] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    0.336088] ACPI: Lid Switch [LID0]
[    0.336361] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    0.336689] ACPI: Power Button [PWRB]
[    0.336975] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.337299] ACPI: Power Button [PWRF]
[    0.352899] ACPI: EC: GPE storm detected, transactions will use polling mode
[    0.388785] acpi device:03: registered as cooling_device0
[    0.389155] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:01/LNXVIDEO:00/input/input3
[    0.389485] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[    0.389761] ACPI: acpi_idle registered with cpuidle
[    0.391742] Monitor-Mwait will be used to enter C-1 state
[    0.391759] Monitor-Mwait will be used to enter C-2 state
[    0.391774] Monitor-Mwait will be used to enter C-3 state
[    0.391779] Marking TSC unstable due to TSC halts in idle
[    0.392039] Switching to clocksource hpet
[    0.434501] ACPI: Battery Slot [BAT1] (battery present)
[    0.434941] Non-volatile memory driver v1.3
[    0.435170] Linux agpgart interface v0.103
[    0.435563] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    0.435891] Hangcheck: Using getrawmonotonic().
[    0.436159] [drm] Initialized drm 1.1.0 20060810
[    0.436442] nouveau 0000:01:00.0: power state changed by ACPI to D0
[    0.436668] nouveau 0000:01:00.0: power state changed by ACPI to D0
[    0.436896] nouveau 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.437134] nouveau 0000:01:00.0: setting latency timer to 64
[    0.440825] [drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x084700a2)
[    0.446048] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
[    0.535630] [drm] nouveau 0000:01:00.0: ... appears to be valid
[    0.535847] [drm] nouveau 0000:01:00.0: BIT BIOS found
[    0.536072] [drm] nouveau 0000:01:00.0: Bios version 60.84.42.00
[    0.536296] [drm] nouveau 0000:01:00.0: TMDS table revision 2.0 not currently supported
[    0.536621] [drm] nouveau 0000:01:00.0: BIT table 'd' not found
[    0.536837] [drm] nouveau 0000:01:00.0: Found Display Configuration Block version 4.0
[    0.537174] [drm] nouveau 0000:01:00.0: Raw DCB entry 0: 01000323 00000034
[    0.537400] [drm] nouveau 0000:01:00.0: Raw DCB entry 1: 02011300 00000028
[    0.537618] [drm] nouveau 0000:01:00.0: Raw DCB entry 2: 010223f1 0020c070
[    0.537836] [drm] nouveau 0000:01:00.0: Raw DCB entry 3: 0000000e 00000000
[    0.538063] [drm] nouveau 0000:01:00.0: DCB connector table: VHER 0x40 5 14 2
[    0.538286] [drm] nouveau 0000:01:00.0:   0: 0x00000040: type 0x40 idx 0 tag 0xff
[    0.538613] [drm] nouveau 0000:01:00.0:   1: 0x00000100: type 0x00 idx 1 tag 0xff
[    0.538938] [drm] nouveau 0000:01:00.0:   2: 0x00000210: type 0x10 idx 2 tag 0xff
[    0.539277] [drm] nouveau 0000:01:00.0:   3: 0x00000211: type 0x11 idx 3 tag 0xff
[    0.539612] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xBFAE
[    0.566131] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xC2EE
[    0.585014] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xCF2F
[    0.585348] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xD021
[    0.587105] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xD23A
[    0.587432] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xD29F
[    0.608022] [drm] nouveau 0000:01:00.0: 0xD29F: Condition still not met after 20ms, skipping following opcodes
[    0.608358] [drm] nouveau 0000:01:00.0: 0xB0B0: parsing output script 0
[    0.608575] [drm] nouveau 0000:01:00.0: 0xA89C: parsing output script 0
[    0.608801] [drm] nouveau 0000:01:00.0: Detected 512MiB VRAM
[    0.745128] [TTM] Zone  kernel: Available graphics memory: 1026340 kiB.
[    0.745355] [TTM] Initializing pool allocator.
[    0.777837] [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
[    0.779481] [drm] nouveau 0000:01:00.0: Allocating FIFO number 1
[    0.786638] [drm] nouveau 0000:01:00.0: nouveau_channel_alloc: initialised FIFO 1
[    0.787878] [drm] nouveau 0000:01:00.0: Detected a LVDS output
[    0.788109] [drm] nouveau 0000:01:00.0: Detected a DAC output
[    0.788335] [drm] nouveau 0000:01:00.0: DCB encoder 1 unknown
[    0.788554] [drm] nouveau 0000:01:00.0: Detected a LVDS connector
[    0.898304] [drm] nouveau 0000:01:00.0: Detected a VGA connector
[    0.898599] [drm] nouveau 0000:01:00.0: Detected a TV connector
[    0.898816] [drm] nouveau 0000:01:00.0:   no encoders, ignoring
[    1.954975] [drm] nouveau 0000:01:00.0: allocated 1680x1050 fb: 0x40250000, bo ffff88007e8ec400
[    1.958827] [drm] nouveau 0000:01:00.0: 0xB0B4: parsing output script 1
[    1.958853] [drm] nouveau 0000:01:00.0: 0xAF39: parsing clock script 0
[    1.963968] Console: switching to colour frame buffer device 210x65
[    1.967062] fb0: nouveaufb frame buffer device
[    1.967080] drm: registered panic notifier
[    1.967096] Slow work thread pool: Starting up
[    1.967158] Slow work thread pool: Ready
[    1.967168] [drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on minor 0
[    1.967227] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.969528] brd: module loaded
[    1.970414] loop: module loaded
[    1.970725] ata_piix 0000:00:1f.1: version 2.13
[    1.970739] ata_piix 0000:00:1f.1: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.970782] ata_piix 0000:00:1f.1: setting latency timer to 64
[    1.970857] scsi0 : ata_piix
[    1.970995] scsi1 : ata_piix
[    1.971637] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x18a0 irq 14
[    1.971646] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x18a8 irq 15
[    1.971671] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.971683] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    1.975517] [drm] nouveau 0000:01:00.0: 0xB073: parsing clock script 1
[    2.122053] ata_piix 0000:00:1f.2: setting latency timer to 64
[    2.122105] scsi2 : ata_piix
[    2.122195] scsi3 : ata_piix
[    2.123274] ata3: SATA max UDMA/133 cmd 0x18f8 ctl 0x18cc bmdma 0x18e0 irq 19
[    2.123288] ata4: SATA max UDMA/133 cmd 0x18f0 ctl 0x18c8 bmdma 0x18e8 irq 19
[    2.133525] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k6-NAPI
[    2.133533] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    2.133597] tg3.c:v3.110 (April 9, 2010)
[    2.133662] tg3 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.133682] tg3 0000:04:00.0: setting latency timer to 64
[    2.136368] ata1.00: ATAPI: MATSHITADVD-RAM UJ-850S, 1.60, max UDMA/33
[    2.144325] ata1.00: configured for UDMA/33
[    2.146611] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-850S  1.60 PQ: 0 ANSI: 5
[    2.151065] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.151074] Uniform CD-ROM driver Revision: 3.20
[    2.151208] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    2.151298] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    2.193262] tg3 0000:04:00.0: vpd r/w failed.  This is likely a firmware bug on this device.  Contact the card vendor for a firmware update.
[    2.246261] tg3 0000:04:00.0: vpd r/w failed.  This is likely a firmware bug on this device.  Contact the card vendor for a firmware update.
[    2.299262] tg3 0000:04:00.0: vpd r/w failed.  This is likely a firmware bug on this device.  Contact the card vendor for a firmware update.
[    2.300263] tg3 0000:04:00.0: eth0: Tigon3 [partno(none) rev b002] (PCI Express) MAC address 00:1b:38:cc:d8:84
[    2.300275] tg3 0000:04:00.0: eth0: attached PHY is 5787 (10/100/1000Base-T Ethernet) (WireSpeed[1])
[    2.300284] tg3 0000:04:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    2.300292] tg3 0000:04:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    2.300334] sky2: driver version 1.28
[    2.300419] usbcore: registered new interface driver asix
[    2.300461] usbcore: registered new interface driver cdc_ether
[    2.300504] usbcore: registered new interface driver net1080
[    2.300788] usbcore: registered new interface driver cdc_subset
[    2.301160] usbcore: registered new interface driver zaurus
[    2.301635] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[    2.302129] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[    2.302728] iwlagn 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.303218] iwlagn 0000:0c:00.0: setting latency timer to 64
[    2.303312] iwlagn 0000:0c:00.0: Detected Intel(R) Wireless WiFi Link 4965AGN, REV=0x4
[    2.346723] iwlagn 0000:0c:00.0: Tunable channels: 13 802.11bg, 19 802.11a channels
[    2.347094]   alloc irq_desc for 47 on node -1
[    2.347101]   alloc kstat_irqs on node -1
[    2.347140] iwlagn 0000:0c:00.0: irq 47 for MSI/MSI-X
[    2.347499] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.347763] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    2.347788] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.348307] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    2.348311] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    2.348896] drivers/usb/core/inode.c: creating file 'devices'
[    2.348900] drivers/usb/core/inode.c: creating file '001'
[    2.348957] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    2.349521] ehci_hcd 0000:00:1a.7: reset hcs_params 0x102204 dbg=1 cc=2 pcc=2 ordered !ppc ports=4
[    2.349526] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
[    2.349553] ehci_hcd 0000:00:1a.7: debug port 1
[    2.350124] ehci_hcd 0000:00:1a.7: reset command 080032 (park)=0 ithresh=8 Async Periodic period=1024 Reset HALT
[    2.354008] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    2.354010] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    2.354024] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf8404000
[    2.354333] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    2.358214] ehci_hcd 0000:00:1a.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    2.363264] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    2.363567] usb usb1: default language 0x0409
[    2.363573] usb usb1: udev 1, busnum 1, minor = 0
[    2.363575] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.364143] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.364813] usb usb1: Product: EHCI Host Controller
[    2.365484] usb usb1: Manufacturer: Linux 2.6.35.7-nordalkernel ehci_hcd
[    2.366160] usb usb1: SerialNumber: 0000:00:1a.7
[    2.366921] usb usb1: usb_probe_device
[    2.366924] usb usb1: configuration #1 chosen from 1 choice
[    2.366931] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    2.366982] hub 1-0:1.0: usb_probe_interface
[    2.366984] hub 1-0:1.0: usb_probe_interface - got id
[    2.366986] hub 1-0:1.0: USB hub found
[    2.367538] hub 1-0:1.0: 4 ports detected
[    2.368197] hub 1-0:1.0: standalone hub
[    2.368199] hub 1-0:1.0: no power switching (usb 1.0)
[    2.368201] hub 1-0:1.0: individual port over-current protection
[    2.368203] hub 1-0:1.0: power on to power good time: 20ms
[    2.368207] hub 1-0:1.0: local power source is good
[    2.368210] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    2.368234] drivers/usb/core/inode.c: creating file '001'
[    2.368287]   alloc irq_desc for 23 on node -1
[    2.368289]   alloc kstat_irqs on node -1
[    2.368293] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.368891] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.368895] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.369575] drivers/usb/core/inode.c: creating file '002'
[    2.369629] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    2.370269] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    2.370274] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
[    2.370301] ehci_hcd 0000:00:1d.7: debug port 1
[    2.370948] ehci_hcd 0000:00:1d.7: reset command 080032 (park)=0 ithresh=8 Async Periodic period=1024 Reset HALT
[    2.374848] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    2.374850] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    2.374864] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf8404400
[    2.375156] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    2.379027] ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    2.384263] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.384570] usb usb2: default language 0x0409
[    2.384577] usb usb2: udev 1, busnum 2, minor = 128
[    2.384579] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    2.385204] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.385897] usb usb2: Product: EHCI Host Controller
[    2.386565] usb usb2: Manufacturer: Linux 2.6.35.7-nordalkernel ehci_hcd
[    2.387234] usb usb2: SerialNumber: 0000:00:1d.7
[    2.387995] usb usb2: usb_probe_device
[    2.387998] usb usb2: configuration #1 chosen from 1 choice
[    2.388003] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    2.388052] hub 2-0:1.0: usb_probe_interface
[    2.388054] hub 2-0:1.0: usb_probe_interface - got id
[    2.388055] hub 2-0:1.0: USB hub found
[    2.388606] hub 2-0:1.0: 6 ports detected
[    2.389287] hub 2-0:1.0: standalone hub
[    2.389289] hub 2-0:1.0: no power switching (usb 1.0)
[    2.389291] hub 2-0:1.0: individual port over-current protection
[    2.389293] hub 2-0:1.0: power on to power good time: 20ms
[    2.389297] hub 2-0:1.0: local power source is good
[    2.389299] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    2.389328] drivers/usb/core/inode.c: creating file '001'
[    2.389396] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.389961] ohci_hcd: block sizes: ed 80 td 96
[    2.390014] uhci_hcd: USB Universal Host Controller Interface driver
[    2.390734] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.391362] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    2.391366] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    2.392027] drivers/usb/core/inode.c: creating file '003'
[    2.392080] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    2.392734] uhci_hcd 0000:00:1a.0: detected 2 ports
[    2.393423] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    2.393425] uhci_hcd 0000:00:1a.0: Performing full reset
[    2.393445] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00001800
[    2.394132] usb usb3: default language 0x0409
[    2.394138] usb usb3: udev 1, busnum 3, minor = 256
[    2.394140] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.394799] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.395482] usb usb3: Product: UHCI Host Controller
[    2.396160] usb usb3: Manufacturer: Linux 2.6.35.7-nordalkernel uhci_hcd
[    2.396868] usb usb3: SerialNumber: 0000:00:1a.0
[    2.397609] usb usb3: usb_probe_device
[    2.397611] usb usb3: configuration #1 chosen from 1 choice
[    2.397617] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    2.397666] hub 3-0:1.0: usb_probe_interface
[    2.397668] hub 3-0:1.0: usb_probe_interface - got id
[    2.397670] hub 3-0:1.0: USB hub found
[    2.398220] hub 3-0:1.0: 2 ports detected
[    2.398902] hub 3-0:1.0: standalone hub
[    2.398903] hub 3-0:1.0: no power switching (usb 1.0)
[    2.398905] hub 3-0:1.0: individual port over-current protection
[    2.398907] hub 3-0:1.0: power on to power good time: 2ms
[    2.398911] hub 3-0:1.0: local power source is good
[    2.398913] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    2.398926] drivers/usb/core/inode.c: creating file '001'
[    2.398958] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    2.398980]   alloc irq_desc for 21 on node -1
[    2.398981]   alloc kstat_irqs on node -1
[    2.398985] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    2.399579] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    2.399583] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    2.400229] drivers/usb/core/inode.c: creating file '004'
[    2.400293] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    2.400899] uhci_hcd 0000:00:1a.1: detected 2 ports
[    2.401559] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    2.401561] uhci_hcd 0000:00:1a.1: Performing full reset
[    2.401589] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001820
[    2.402216] usb usb4: default language 0x0409
[    2.402222] usb usb4: udev 1, busnum 4, minor = 384
[    2.402224] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.402838] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.403479] usb usb4: Product: UHCI Host Controller
[    2.404109] usb usb4: Manufacturer: Linux 2.6.35.7-nordalkernel uhci_hcd
[    2.404756] usb usb4: SerialNumber: 0000:00:1a.1
[    2.405460] usb usb4: usb_probe_device
[    2.405462] usb usb4: configuration #1 chosen from 1 choice
[    2.405467] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    2.405516] hub 4-0:1.0: usb_probe_interface
[    2.405518] hub 4-0:1.0: usb_probe_interface - got id
[    2.405519] hub 4-0:1.0: USB hub found
[    2.406041] hub 4-0:1.0: 2 ports detected
[    2.406703] hub 4-0:1.0: standalone hub
[    2.406705] hub 4-0:1.0: no power switching (usb 1.0)
[    2.406706] hub 4-0:1.0: individual port over-current protection
[    2.406708] hub 4-0:1.0: power on to power good time: 2ms
[    2.406712] hub 4-0:1.0: local power source is good
[    2.406714] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    2.406727] drivers/usb/core/inode.c: creating file '001'
[    2.406754] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
[    2.406777] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.407371] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.407375] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.408019] drivers/usb/core/inode.c: creating file '005'
[    2.408074] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    2.408698] uhci_hcd 0000:00:1d.0: detected 2 ports
[    2.409344] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    2.409346] uhci_hcd 0000:00:1d.0: Performing full reset
[    2.409365] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001840
[    2.410004] usb usb5: default language 0x0409
[    2.410010] usb usb5: udev 1, busnum 5, minor = 512
[    2.410012] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.410630] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.411278] usb usb5: Product: UHCI Host Controller
[    2.411910] usb usb5: Manufacturer: Linux 2.6.35.7-nordalkernel uhci_hcd
[    2.412571] usb usb5: SerialNumber: 0000:00:1d.0
[    2.413281] usb usb5: usb_probe_device
[    2.413283] usb usb5: configuration #1 chosen from 1 choice
[    2.413289] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    2.413335] hub 5-0:1.0: usb_probe_interface
[    2.413337] hub 5-0:1.0: usb_probe_interface - got id
[    2.413338] hub 5-0:1.0: USB hub found
[    2.413848] hub 5-0:1.0: 2 ports detected
[    2.414495] hub 5-0:1.0: standalone hub
[    2.414497] hub 5-0:1.0: no power switching (usb 1.0)
[    2.414499] hub 5-0:1.0: individual port over-current protection
[    2.414501] hub 5-0:1.0: power on to power good time: 2ms
[    2.414505] hub 5-0:1.0: local power source is good
[    2.414507] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    2.414519] drivers/usb/core/inode.c: creating file '001'
[    2.414551] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    2.414567] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.415147] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.415150] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.415806] drivers/usb/core/inode.c: creating file '006'
[    2.415862] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    2.416455] uhci_hcd 0000:00:1d.1: detected 2 ports
[    2.417082] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    2.417084] uhci_hcd 0000:00:1d.1: Performing full reset
[    2.417103] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001860
[    2.417756] usb usb6: default language 0x0409
[    2.417763] usb usb6: udev 1, busnum 6, minor = 640
[    2.417765] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    2.418362] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.418996] usb usb6: Product: UHCI Host Controller
[    2.419654] usb usb6: Manufacturer: Linux 2.6.35.7-nordalkernel uhci_hcd
[    2.420311] usb usb6: SerialNumber: 0000:00:1d.1
[    2.421006] usb usb6: usb_probe_device
[    2.421009] usb usb6: configuration #1 chosen from 1 choice
[    2.421014] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    2.421062] hub 6-0:1.0: usb_probe_interface
[    2.421064] hub 6-0:1.0: usb_probe_interface - got id
[    2.421066] hub 6-0:1.0: USB hub found
[    2.421606] hub 6-0:1.0: 2 ports detected
[    2.422228] hub 6-0:1.0: standalone hub
[    2.422230] hub 6-0:1.0: no power switching (usb 1.0)
[    2.422231] hub 6-0:1.0: individual port over-current protection
[    2.422233] hub 6-0:1.0: power on to power good time: 2ms
[    2.422237] hub 6-0:1.0: local power source is good
[    2.422238] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    2.422260] drivers/usb/core/inode.c: creating file '001'
[    2.422293] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    2.422309] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.422892] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.422896] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.423557] drivers/usb/core/inode.c: creating file '007'
[    2.423608] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    2.424203] uhci_hcd 0000:00:1d.2: detected 2 ports
[    2.424868] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    2.424870] uhci_hcd 0000:00:1d.2: Performing full reset
[    2.424890] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001880
[    2.425531] usb usb7: default language 0x0409
[    2.425537] usb usb7: udev 1, busnum 7, minor = 768
[    2.425539] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    2.426132] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.426786] usb usb7: Product: UHCI Host Controller
[    2.427432] usb usb7: Manufacturer: Linux 2.6.35.7-nordalkernel uhci_hcd
[    2.428084] usb usb7: SerialNumber: 0000:00:1d.2
[    2.428814] usb usb7: usb_probe_device
[    2.428817] usb usb7: configuration #1 chosen from 1 choice
[    2.428822] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    2.428868] hub 7-0:1.0: usb_probe_interface
[    2.428870] hub 7-0:1.0: usb_probe_interface - got id
[    2.428871] hub 7-0:1.0: USB hub found
[    2.429398] hub 7-0:1.0: 2 ports detected
[    2.430021] hub 7-0:1.0: standalone hub
[    2.430023] hub 7-0:1.0: no power switching (usb 1.0)
[    2.430024] hub 7-0:1.0: individual port over-current protection
[    2.430026] hub 7-0:1.0: power on to power good time: 2ms
[    2.430030] hub 7-0:1.0: local power source is good
[    2.430032] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    2.430047] drivers/usb/core/inode.c: creating file '001'
[    2.430078] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    2.430177] usbcore: registered new interface driver usblp
[    2.430679] Initializing USB Mass Storage driver...
[    2.431388] usbcore: registered new interface driver usb-storage
[    2.431958] USB Mass Storage support registered.
[    2.432673] usbcore: registered new interface driver libusual
[    2.433374] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    2.467978] ehci_hcd 0000:00:1a.7: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
[    2.467982] hub 1-0:1.0: port 2: status 0501 change 0001
[    2.467993] ehci_hcd 0000:00:1a.7: GetStatus port 4 status 001803 POWER sig=j CSC CONNECT
[    2.467996] hub 1-0:1.0: port 4: status 0501 change 0001
[    2.472281] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.472562] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.473290] mice: PS/2 mouse device common for all mice
[    2.475507] I2O subsystem v1.325
[    2.475790] i2o: max drivers = 8
[    2.476571] I2O Configuration OSM v1.323
[    2.477063] I2O Bus Adapter OSM v1.317
[    2.477709] I2O Block Device OSM v1.325
[    2.478455] I2O ProcFS OSM v1.316
[    2.478987] rtc_cmos 00:08: RTC can wake from S4
[    2.479623] rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
[    2.480203] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    2.480867] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 19 (level, low) -> IRQ 19
[    2.481591] Linux video capture interface: v2.00
[    2.482659] cpuidle: using governor ladder
[    2.483506] cpuidle: using governor menu
[    2.484651] usbcore: registered new interface driver hiddev
[    2.484979] usbcore: registered new interface driver usbhid
[    2.485513] usbhid: USB HID core driver
[    2.486132] compal-laptop: Identified laptop model 'FL92/JFL92'.
[    2.486981] compal-laptop: driver 0.2.6 successfully loaded.
[    2.487560]   alloc irq_desc for 20 on node -1
[    2.487563]   alloc kstat_irqs on node -1
[    2.487568] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.488065]   alloc irq_desc for 48 on node -1
[    2.488067]   alloc kstat_irqs on node -1
[    2.488078] HDA Intel 0000:00:1b.0: irq 48 for MSI/MSI-X
[    2.488107] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    2.489340] ehci_hcd 0000:00:1d.7: GetStatus port 6 status 001403 POWER sig=k CSC CONNECT
[    2.489346] hub 2-0:1.0: port 6: status 0501 change 0001
[    2.498269] uhci_hcd 0000:00:1a.0: port 2 portsc 0082,00
[    2.505106] ALSA device list:
[    2.505384]   #0: HDA Intel at 0xf8400000 irq 48
[    2.505984] Netfilter messages via NETLINK v0.30.
[    2.506607] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    2.507283] uhci_hcd 0000:00:1a.1: port 2 portsc 008a,00
[    2.507467] ctnetlink v0.93: registering with nfnetlink.
[    2.508227] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.508555] TCP cubic registered
[    2.509079] Initializing XFRM netlink socket
[    2.509990] NET: Registered protocol family 10
[    2.511065] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    2.511379] IPv6 over IPv4 tunneling driver
[    2.512487] NET: Registered protocol family 17
[    2.513477] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    2.513597] PM: Checking image partition /dev/sda1
[    2.516358] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    2.521330] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    2.534825] uhci_hcd 0000:00:1d.2: port 2 portsc 008a,00
[    2.567368] hub 1-0:1.0: state 7 ports 4 chg 0014 evt 0000
[    2.567390] hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[    2.618376] ehci_hcd 0000:00:1a.7: port 2 high speed
[    2.618389] ehci_hcd 0000:00:1a.7: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[    2.669058] usb 1-2: new high speed USB device using ehci_hcd and address 2
[    2.744629] ehci_hcd 0000:00:1a.7: port 2 high speed
[    2.744642] ehci_hcd 0000:00:1a.7: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[    2.826063] usb 1-2: skipped 1 descriptor after configuration
[    2.826071] usb 1-2: skipped 6 descriptors after interface
[    2.826078] usb 1-2: skipped 1 descriptor after endpoint
[    2.826084] usb 1-2: skipped 11 descriptors after interface
[    2.826460] usb 1-2: default language 0x0409
[    2.829341] usb 1-2: udev 2, busnum 1, minor = 1
[    2.829348] usb 1-2: New USB device found, idVendor=04f2, idProduct=b018
[    2.830034] usb 1-2: New USB device strings: Mfr=2, Product=1, SerialNumber=3
[    2.830737] usb 1-2: Product: USB 2.0 Camera
[    2.831428] usb 1-2: Manufacturer: Chicony Electronics Co., Ltd.
[    2.832099] usb 1-2: SerialNumber: SN0001
[    2.833069] usb 1-2: usb_probe_device
[    2.833078] usb 1-2: configuration #1 chosen from 1 choice
[    2.833298] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
[    2.834334] usb 1-2: adding 1-2:1.1 (config #1, interface 1)
[    2.834514] drivers/usb/core/inode.c: creating file '002'
[    2.834567] hub 1-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
[    2.885255] ehci_hcd 0000:00:1a.7: port 4 full speed --> companion
[    2.885268] ehci_hcd 0000:00:1a.7: GetStatus port 4 status 003801 POWER OWNER sig=j CONNECT
[    2.885291] hub 1-0:1.0: port 4 not reset yet, waiting 50ms
[    2.901167] ata3.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.901854] ata3.01: SATA link down (SStatus 0 SControl 300)
[    2.936337] ehci_hcd 0000:00:1a.7: GetStatus port 4 status 003002 POWER OWNER sig=se0 CSC
[    2.936381] hub 2-0:1.0: state 7 ports 6 chg 0040 evt 0000
[    2.936394] hub 2-0:1.0: port 6, status 0501, change 0000, 480 Mb/s
[    2.936409] ehci_hcd 0000:00:1d.7: port 6 low speed --> companion
[    2.959001] ata3.00: ATA-8: WDC WD3200BEVT-22ZCT0, 11.01A11, max UDMA/133
[    2.959704] ata3.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.966602] ata3.00: configured for UDMA/133
[    2.967561] scsi 2:0:0:0: Direct-Access     ATA      WDC WD3200BEVT-2 11.0 PQ: 0 ANSI: 5
[    2.968831] sd 2:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    2.969682] sd 2:0:0:0: [sda] Write Protect is off
[    2.969711] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    2.971051] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.971110] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.972111]  sda: sda1 sda2 sda3 sda4
[    2.984640] sd 2:0:0:0: [sda] Attached SCSI disk
[    2.987318] ehci_hcd 0000:00:1d.7: GetStatus port 6 status 003002 POWER OWNER sig=se0 CSC
[    2.987349] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    2.987354] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    2.987365] uhci_hcd 0000:00:1a.1: port 2 portsc 0093,00
[    2.987374] hub 4-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[    3.091074] hub 4-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
[    3.165034] elantech: assuming hardware version 1, firmware version 2.0.4
[    3.193436] usb 4-2: new full speed USB device using uhci_hcd and address 2
[    3.255873] elantech: Synaptics capabilities query result 0x10, 0x02, 0x64.
[    3.314077] usb 4-2: ep0 maxpacket = 8
[    3.335392] usb 4-2: default language 0x0409
[    3.354686] usb 4-2: udev 2, busnum 4, minor = 385
[    3.354694] usb 4-2: New USB device found, idVendor=147e, idProduct=2016
[    3.355427] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.356137] usb 4-2: Product: Fingerprint Sensor   
[    3.356142] usb 4-2: Manufacturer: TouchStrip        
[    3.356440] usb 4-2: usb_probe_device
[    3.356449] usb 4-2: configuration #1 chosen from 1 choice
[    3.359340] usb 4-2: adding 4-2:1.0 (config #1, interface 0)
[    3.359651] drivers/usb/core/inode.c: creating file '002'
[    3.359702] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    3.359720] uhci_hcd 0000:00:1d.2: port 2 portsc 01a3,00
[    3.359734] hub 7-0:1.0: port 2, status 0301, change 0001, 1.5 Mb/s
[    3.450077] ata4.01: failed to resume link (SControl 0)
[    3.462519] ata4.00: SATA link down (SStatus 0 SControl 300)
[    3.462525] usb usb5: suspend_rh (auto-stop)
[    3.462559] usb usb6: suspend_rh (auto-stop)
[    3.463272] ata4.01: SATA link down (SStatus 0 SControl 0)
[    3.463288] hub 7-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x301
[    3.565070] usb 7-2: new low speed USB device using uhci_hcd and address 2
[    3.704048] usb usb3: suspend_rh (auto-stop)
[    3.706592] usb 7-2: skipped 1 descriptor after interface
[    3.711897] usb 7-2: default language 0x0409
[    3.727858] usb 7-2: udev 2, busnum 7, minor = 769
[    3.727866] usb 7-2: New USB device found, idVendor=046d, idProduct=c019
[    3.728634] usb 7-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.729350] usb 7-2: Product: USB Optical Mouse
[    3.730063] usb 7-2: Manufacturer: Logitech
[    3.731098] usb 7-2: usb_probe_device
[    3.731107] usb 7-2: configuration #1 chosen from 1 choice
[    3.733637] usb 7-2: adding 7-2:1.0 (config #1, interface 0)
[    3.733883] usbhid 7-2:1.0: usb_probe_interface
[    3.733890] usbhid 7-2:1.0: usb_probe_interface - got id
[    3.747409] input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2:1.0/input/input5
[    3.748606] generic-usb 0003:046D:C019.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:1d.2-2/input0
[    3.749391] drivers/usb/core/inode.c: creating file '002'
[    3.749441] hub 1-0:1.0: state 7 ports 4 chg 0000 evt 0010
[    3.749459] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0040
[    3.749471] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    3.880605] input: ETPS/2 Elantech Touchpad as /devices/platform/i8042/serio1/input/input6
[    3.889995] PM: Resume from partition 8:1
[    3.890000] PM: Checking hibernation image.
[    3.890344] PM: Error -22 checking image file
[    3.890349] PM: Resume from disk failed.
[    3.890385] registered taskstats version 1
[    3.960761] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    3.961560] VFS: Mounted root (ext2 filesystem) readonly on device 8:2.
[    3.962423] Freeing unused kernel memory: 464k freed
[    5.846215] udev: starting version 151
[    5.977756] iwlagn 0000:0c:00.0: request for firmware file 'iwlwifi-4965-2.ucode' failed.
[    5.977761] iwlagn 0000:0c:00.0: no suitable firmware found!
[    5.978193] iwlagn 0000:0c:00.0: PCI INT A disabled
[    7.209492] EXT4-fs (sda2): re-mounted. Opts: (null)
[    7.889201] Adding 2095100k swap on /dev/sda1.  Priority:-1 extents:1 across:2095100k 
[   13.344965] tg3 0000:04:00.0: irq 47 for MSI/MSI-X
[   13.373942] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   15.029292] tg3 0000:04:00.0: eth0: Link is up at 100 Mbps, full duplex
[   15.029301] tg3 0000:04:00.0: eth0: Flow control is off for TX and off for RX
[   15.029385] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   41.434488] [drm] nouveau 0000:01:00.0: Allocating FIFO number 2
[   41.442872] [drm] nouveau 0000:01:00.0: nouveau_channel_alloc: initialised FIFO 2
[   42.362040] uhci_hcd 0000:00:1d.2: reserve dev 2 ep81-INT, period 8, phase 4, 99 us
[   47.896065] CPUFREQ: Per core ondemand sysfs interface is deprecated - up_threshold
[  633.636084] Hangcheck: hangcheck value past margin!
[  912.888310] CE: hpet increased min_delta_ns to 7500 nsec
[ 1205.228087] CE: hpet increased min_delta_ns to 11250 nsec
[ 1770.074021] CE: hpet increased min_delta_ns to 16875 nsec
[ 2570.638316] Hangcheck: hangcheck value past margin!
[ 2843.795472] INFO: rcu_sched_state detected stall on CPU 0 (t=10293 jiffies)
[ 2843.795480] sending NMI to all CPUs:
...

--------------040701010505050605080607--
