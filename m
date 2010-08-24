Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab0HXLDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 07:03:53 -0400
Received: from mailout-us.gmx.com ([74.208.5.67]:43270 "HELO
	mailout-us.gmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751466Ab0HXLDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 07:03:50 -0400
X-Authenticated: #65048216
X-Provags-ID: V01U2FsdGVkX1/U+1J6plbUs5+4gFti+z2RD1iqnWIX9QYKI7CGF2
	odbSBNOGThVl6d
Subject: Re: [PATCH] drm/i915/tv: Flush register writes before sleeping.
From: Ivan Bulatovic <combuster@gmx.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        jbarnes@virtuousgeek.org, eric@anholt.net, penberg@kernel.org
In-Reply-To: <1282641677-27378-1-git-send-email-chris@chris-wilson.co.uk>
References: <1282641126.2259.15.camel@localhost.localdomain>
	 <1282641677-27378-1-git-send-email-chris@chris-wilson.co.uk>
Content-Type: multipart/mixed; boundary="=-iyRcT9vbBIlGh+yHTu+A"
Date: Tue, 24 Aug 2010 13:03:35 +0200
Message-ID: <1282647815.2221.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iyRcT9vbBIlGh+yHTu+A
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Tue, 2010-08-24 at 10:21 +0100, Chris Wilson wrote: 
> Ivan, can you try this patch?
> 
I've patched it, unfortunately it doesn't help. :( Dmesg is in
attachement. Symptoms are the same.

> Linus is going to make some more snide comments if he sees just how many
> of these trivial-ish patches that I have pending...
> 
I don't think so, this is fun, I haven't had problems with intel drivers
in months :D 
> ---
> 
> If we need to wait until the next vblank for the register to be updated
> and to take effect, make sure the write is actually flushed to the register
> prior to sleeping.
> 
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>



--=-iyRcT9vbBIlGh+yHTu+A
Content-Disposition: attachment; filename="dmesg.drm.36_2"
Content-Type: text/plain; name="dmesg.drm.36_2"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.36-rc2-RC (root@vostro) (gcc version 4.5.1 (GCC) ) #1 SMP PREEMPT Tue Aug 24 12:40:09 CEST 2010
[    0.000000] Command line: root=/dev/sda1 ro video=LVDS-1:d drm.debug=0x6
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
[    0.000000]   NODE_DATA [0000000001fe21c0 - 0000000001fe71bf]
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
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880002200000 s80896 r8192 d21504 u1048576
[    0.000000] pcpu-alloc: s80896 r8192 d21504 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 514687
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/sda1 ro video=LVDS-1:d drm.debug=0x6
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Subtract (50 early reservations)
[    0.000000]   #1 [0001000000 - 0001fe15a8]   TEXT DATA BSS
[    0.000000]   #2 [0037ec3000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [0001fe2000 - 0001fe2184]             BRK
[    0.000000]   #4 [00000f7690 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000f7680 - 00000f7690]    MP-table mpf
[    0.000000]   #6 [000009f800 - 000009fd71]   BIOS reserved
[    0.000000]   #7 [000009ff15 - 00000f7680]   BIOS reserved
[    0.000000]   #8 [000009fd71 - 000009ff15]    MP-table mpc
[    0.000000]   #9 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #10 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #11 [0000016000 - 0000018000]         PGTABLE
[    0.000000]   #12 [0001fe21c0 - 0001fe71c0]       NODE_DATA
[    0.000000]   #13 [0001fe71c0 - 0001fe81c0]         BOOTMEM
[    0.000000]   #14 [0001fe15c0 - 0001fe1740]         BOOTMEM
[    0.000000]   #15 [00027e9000 - 00027ea000]         BOOTMEM
[    0.000000]   #16 [00027ea000 - 00027eb000]         BOOTMEM
[    0.000000]   #17 [0002800000 - 0004400000]        MEMMAP 0
[    0.000000]   #18 [0001fe1740 - 0001fe1b40]         BOOTMEM
[    0.000000]   #19 [0001fe81c0 - 00020081c0]         BOOTMEM
[    0.000000]   #20 [0002009000 - 000200a000]         BOOTMEM
[    0.000000]   #21 [0001fe1b40 - 0001fe1b81]         BOOTMEM
[    0.000000]   #22 [0001fe1bc0 - 0001fe1c03]         BOOTMEM
[    0.000000]   #23 [0001fe1c40 - 0001fe1f50]         BOOTMEM
[    0.000000]   #24 [0001fe1f80 - 0001fe1fe8]         BOOTMEM
[    0.000000]   #25 [00020081c0 - 0002008228]         BOOTMEM
[    0.000000]   #26 [0002008240 - 00020082a8]         BOOTMEM
[    0.000000]   #27 [00020082c0 - 0002008328]         BOOTMEM
[    0.000000]   #28 [0002008340 - 00020083a8]         BOOTMEM
[    0.000000]   #29 [00020083c0 - 0002008428]         BOOTMEM
[    0.000000]   #30 [0002008440 - 00020084a8]         BOOTMEM
[    0.000000]   #31 [00020084c0 - 0002008528]         BOOTMEM
[    0.000000]   #32 [0002008540 - 00020085a8]         BOOTMEM
[    0.000000]   #33 [00020085c0 - 0002008628]         BOOTMEM
[    0.000000]   #34 [0002008640 - 00020086a8]         BOOTMEM
[    0.000000]   #35 [00020086c0 - 0002008728]         BOOTMEM
[    0.000000]   #36 [0002008740 - 00020087a8]         BOOTMEM
[    0.000000]   #37 [00020087c0 - 00020087e0]         BOOTMEM
[    0.000000]   #38 [0002008800 - 000200882f]         BOOTMEM
[    0.000000]   #39 [0002008840 - 000200886f]         BOOTMEM
[    0.000000]   #40 [0002200000 - 000221b000]         BOOTMEM
[    0.000000]   #41 [0002300000 - 000231b000]         BOOTMEM
[    0.000000]   #42 [0002008880 - 0002008888]         BOOTMEM
[    0.000000]   #43 [00020088c0 - 00020088c8]         BOOTMEM
[    0.000000]   #44 [0002008900 - 0002008908]         BOOTMEM
[    0.000000]   #45 [0002008940 - 0002008950]         BOOTMEM
[    0.000000]   #46 [0002008980 - 0002008ac0]         BOOTMEM
[    0.000000]   #47 [0002008ac0 - 0002008b20]         BOOTMEM
[    0.000000]   #48 [0002008b40 - 0002008ba0]         BOOTMEM
[    0.000000]   #49 [000200a000 - 0002012000]         BOOTMEM
[    0.000000] Memory: 2040704k/2087744k available (3781k kernel code, 452k absent, 46588k reserved, 2895k data, 548k init)
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
[    0.000000] Detected 1795.777 MHz processor.
[    0.001015] Calibrating delay loop (skipped), value calculated using timer frequency.. 3591.55 BogoMIPS (lpj=1795777)
[    0.001254] pid_max: default: 32768 minimum: 301
[    0.002071] Security Framework initialized
[    0.002192] Smack:  Initializing.
[    0.002631] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004174] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.004928] Mount-cache hash table entries: 256
[    0.006263] Initializing cgroup subsys ns
[    0.006381] Initializing cgroup subsys cpuacct
[    0.006507] Initializing cgroup subsys freezer
[    0.006708] CPU: Physical Processor ID: 0
[    0.006826] CPU: Processor Core ID: 0
[    0.006944] mce: CPU supports 6 MCE banks
[    0.007010] CPU0: Thermal monitoring handled by SMI
[    0.007016] using mwait in idle threads.
[    0.007134] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.007382] PEBS disabled due to CPU errata.
[    0.007511] ... version:                2
[    0.007628] ... bit width:              40
[    0.007746] ... generic registers:      2
[    0.007863] ... value mask:             000000ffffffffff
[    0.008004] ... max period:             000000007fffffff
[    0.008124] ... fixed-purpose events:   3
[    0.008242] ... event mask:             0000000700000003
[    0.008487] ACPI: Core revision 20100702
[    0.027214] Setting APIC routing to flat
[    0.028414] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.038618] CPU0: Intel(R) Core(TM)2 Duo CPU     T5670  @ 1.80GHz stepping 0d
[    0.040425] NMI watchdog enabled, takes one hw-pmu counter.
[    0.042052] lockdep: fixing up alternatives.
[    0.043195] Booting Node   0, Processors  #1 Ok.
[    0.001999] CPU1: Thermal monitoring handled by SMI
[    0.115124] NMI watchdog enabled, takes one hw-pmu counter.
[    0.116014] Brought up 2 CPUs
[    0.116130] Total of 2 processors activated (7182.37 BogoMIPS).
[    0.117253] devtmpfs: initialized
[    0.118299] NET: Registered protocol family 16
[    0.119401] ACPI: bus type pci registered
[    0.119705] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.119897] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.175807] PCI: Using configuration type 1 for base access
[    0.177546] bio: create slab <bio-0> at 0
[    0.185544] ACPI: EC: Look up EC in DSDT
[    0.198055] ACPI: BIOS _OSI(Linux) query ignored
[    0.199537] ACPI: SSDT 000000007f6d7761 00238 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.201720] ACPI: Dynamic OEM Table Load:
[    0.201917] ACPI: SSDT (null) 00238 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.202482] ACPI: SSDT 000000007f6d70f2 005EA (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.204714] ACPI: Dynamic OEM Table Load:
[    0.204912] ACPI: SSDT (null) 005EA (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.205671] ACPI: SSDT 000000007f6d7999 000C8 (v01  PmRef  Cpu1Ist 00003000 INTL 20061109)
[    0.207926] ACPI: Dynamic OEM Table Load:
[    0.208111] ACPI: SSDT (null) 000C8 (v01  PmRef  Cpu1Ist 00003000 INTL 20061109)
[    0.208599] ACPI: SSDT 000000007f6d76dc 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20061109)
[    0.210771] ACPI: Dynamic OEM Table Load:
[    0.210968] ACPI: SSDT (null) 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20061109)
[    0.211889] ACPI: Interpreter enabled
[    0.212005] ACPI: (supports S0 S3 S4 S5)
[    0.212351] ACPI: Using IOAPIC for interrupt routing
[    0.306336] ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
[    0.307222] ACPI: No dock devices found.
[    0.307342] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.308579] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.310853] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.310977] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.311006] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.311198] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff]
[    0.311385] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    0.311573] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    0.311763] pci_root PNP0A08:00: host bridge window [mem 0x80000000-0xdfffffff]
[    0.312226] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfebfffff]
[    0.312627] pci 0000:00:02.0: reg 10: [mem 0xf8000000-0xf80fffff 64bit]
[    0.312646] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.312659] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.312771] pci 0000:00:02.1: reg 10: [mem 0xf8100000-0xf81fffff 64bit]
[    0.313103] pci 0000:00:1a.0: reg 20: [io  0x1820-0x183f]
[    0.313255] pci 0000:00:1a.1: reg 20: [io  0x1840-0x185f]
[    0.313376] pci 0000:00:1a.7: reg 10: [mem 0xf8504800-0xf8504bff]
[    0.313517] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.313526] pci 0000:00:1a.7: PME# disabled
[    0.313600] pci 0000:00:1b.0: reg 10: [mem 0xf8500000-0xf8503fff 64bit]
[    0.313721] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.313729] pci 0000:00:1b.0: PME# disabled
[    0.313887] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.313895] pci 0000:00:1c.0: PME# disabled
[    0.314081] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.314089] pci 0000:00:1c.1: PME# disabled
[    0.314261] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.314268] pci 0000:00:1c.3: PME# disabled
[    0.314437] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.314444] pci 0000:00:1c.4: PME# disabled
[    0.314580] pci 0000:00:1d.0: reg 20: [io  0x1860-0x187f]
[    0.314729] pci 0000:00:1d.1: reg 20: [io  0x1880-0x189f]
[    0.314876] pci 0000:00:1d.2: reg 20: [io  0x18a0-0x18bf]
[    0.314994] pci 0000:00:1d.7: reg 10: [mem 0xf8504c00-0xf8504fff]
[    0.315157] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.315166] pci 0000:00:1d.7: PME# disabled
[    0.315867] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
[    0.316009] pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
[    0.316135] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
[    0.316325] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 1640 (mask 007f)
[    0.316598] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    0.316617] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    0.316636] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
[    0.316655] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
[    0.316675] pci 0000:00:1f.1: reg 20: [io  0x1810-0x181f]
[    0.316797] pci 0000:00:1f.2: reg 10: [io  0x1c00-0x1c07]
[    0.316814] pci 0000:00:1f.2: reg 14: [io  0x18d4-0x18d7]
[    0.316833] pci 0000:00:1f.2: reg 18: [io  0x18d8-0x18df]
[    0.316851] pci 0000:00:1f.2: reg 1c: [io  0x18d0-0x18d3]
[    0.316869] pci 0000:00:1f.2: reg 20: [io  0x18e0-0x18ff]
[    0.316887] pci 0000:00:1f.2: reg 24: [mem 0xf8504000-0xf85047ff]
[    0.317024] pci 0000:00:1f.2: PME# supported from D3hot
[    0.317032] pci 0000:00:1f.2: PME# disabled
[    0.317090] pci 0000:00:1f.3: reg 10: [mem 0x00000000-0x000000ff]
[    0.317152] pci 0000:00:1f.3: reg 20: [io  0x1c20-0x1c3f]
[    0.317295] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.317418] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.317426] pci 0000:00:1c.0:   bridge window [mem 0xc4000000-0xc7ffffff]
[    0.317439] pci 0000:00:1c.0:   bridge window [mem 0xcc000000-0xcdffffff 64bit pref]
[    0.317531] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.317652] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.317660] pci 0000:00:1c.1:   bridge window [mem 0xf0000000-0xf3ffffff]
[    0.317672] pci 0000:00:1c.1:   bridge window [mem 0xfa000000-0xfbffffff 64bit pref]
[    0.317931] pci 0000:06:00.0: reg 10: [mem 0xf4000000-0xf4000fff]
[    0.318322] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    0.318337] pci 0000:06:00.0: PME# disabled
[    0.318406] pci 0000:06:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.318762] pci 0000:00:1c.3: PCI bridge to [bus 06-06]
[    0.318885] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.318894] pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf7ffffff]
[    0.318906] pci 0000:00:1c.3:   bridge window [mem 0xfc000000-0xfdffffff 64bit pref]
[    0.319161] pci 0000:07:00.0: reg 10: [io  0x5000-0x50ff]
[    0.319289] pci 0000:07:00.0: reg 18: [mem 0xf8610000-0xf8610fff 64bit pref]
[    0.319369] pci 0000:07:00.0: reg 20: [mem 0xf8600000-0xf860ffff 64bit pref]
[    0.319421] pci 0000:07:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.319599] pci 0000:07:00.0: supports D1 D2
[    0.319602] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.319619] pci 0000:07:00.0: PME# disabled
[    0.319799] pci 0000:00:1c.4: PCI bridge to [bus 07-07]
[    0.319922] pci 0000:00:1c.4:   bridge window [io  0x5000-0x5fff]
[    0.319929] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.319942] pci 0000:00:1c.4:   bridge window [mem 0xf8600000-0xf86fffff 64bit pref]
[    0.320062] pci 0000:08:05.0: reg 10: [mem 0xf8200000-0xf8200fff]
[    0.320081] pci 0000:08:05.0: reg 14: [mem 0xf8202000-0xf82027ff]
[    0.320198] pci 0000:08:05.0: supports D1 D2
[    0.320201] pci 0000:08:05.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.320209] pci 0000:08:05.0: PME# disabled
[    0.320281] pci 0000:08:05.2: reg 10: [mem 0xf8202800-0xf82028ff]
[    0.320424] pci 0000:08:05.2: supports D1 D2
[    0.320428] pci 0000:08:05.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.320436] pci 0000:08:05.2: PME# disabled
[    0.320504] pci 0000:08:05.3: reg 10: [mem 0xf8201000-0xf8201fff]
[    0.320646] pci 0000:08:05.3: supports D1 D2
[    0.320649] pci 0000:08:05.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.320657] pci 0000:08:05.3: PME# disabled
[    0.320751] pci 0000:00:1e.0: PCI bridge to [bus 08-08] (subtractive decode)
[    0.320877] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.320885] pci 0000:00:1e.0:   bridge window [mem 0xf8200000-0xf82fffff]
[    0.320897] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.320901] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.320905] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.320909] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.320913] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
[    0.320918] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.320922] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.320926] pci 0000:00:1e.0:   bridge window [mem 0x80000000-0xdfffffff] (subtractive decode)
[    0.320930] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
[    0.320982] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.321656] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.321803] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.321963] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    0.322120] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    0.322371] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.322546] Unable to assume PCIe control: Disabling ASPM
[    0.345068] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 *5 6 7 10 12 14 15)
[    0.345814] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.346536] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.347284] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.348061] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.348953] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.349702] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.350480] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.351679] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.352027] vgaarb: loaded
[    0.352285] usbcore: registered new interface driver usbfs
[    0.352442] usbcore: registered new interface driver hub
[    0.352571] usbcore: registered new device driver usb
[    0.352571] PCI: Using ACPI for IRQ routing
[    0.353006] PCI: pci_cache_line_size set to 64 bytes
[    0.353272] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
[    0.353277] reserve RAM buffer: 000000007f6d0000 - 000000007fffffff 
[    0.354161] cfg80211: Calling CRDA to update world regulatory domain
[    0.354399] NetLabel: Initializing
[    0.354515] NetLabel:  domain hash size = 128
[    0.354630] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.355034] NetLabel:  unlabeled traffic allowed by default
[    0.355313] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.355596] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.357066] Switching to clocksource tsc
[    0.365691] pnp: PnP ACPI init
[    0.365860] ACPI: bus type pnp registered
[    0.378836] ACPI: EC: GPE storm detected, transactions will use polling mode
[    0.399283] pnp: PnP ACPI: found 10 devices
[    0.399403] ACPI: ACPI bus type pnp unregistered
[    0.399551] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.399677] system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
[    0.399799] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.399931] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.400054] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.400177] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.400297] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.400418] system 00:01: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.400553] system 00:04: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.400686] system 00:06: [io  0x0680-0x069f] has been reserved
[    0.400807] system 00:06: [io  0x0800-0x080f] has been reserved
[    0.400935] system 00:06: [io  0x1000-0x107f] has been reserved
[    0.401058] system 00:06: [io  0x1180-0x11bf] has been reserved
[    0.401178] system 00:06: [io  0xfe00] has been reserved
[    0.401299] system 00:06: [io  0xff00-0xff7f] has been reserved
[    0.410880] pci 0000:00:1c.4: BAR 8: assigned [mem 0x80000000-0x803fffff]
[    0.411005] pci 0000:00:1f.3: BAR 0: assigned [mem 0x80400000-0x804000ff]
[    0.411133] pci 0000:00:1f.3: BAR 0: set to [mem 0x80400000-0x804000ff] (PCI address [0x80400000-0x804000ff]
[    0.411328] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.411448] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.411577] pci 0000:00:1c.0:   bridge window [mem 0xc4000000-0xc7ffffff]
[    0.411702] pci 0000:00:1c.0:   bridge window [mem 0xcc000000-0xcdffffff 64bit pref]
[    0.411917] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.412038] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.412164] pci 0000:00:1c.1:   bridge window [mem 0xf0000000-0xf3ffffff]
[    0.412293] pci 0000:00:1c.1:   bridge window [mem 0xfa000000-0xfbffffff 64bit pref]
[    0.412490] pci 0000:00:1c.3: PCI bridge to [bus 06-06]
[    0.412610] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.412739] pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf7ffffff]
[    0.412873] pci 0000:00:1c.3:   bridge window [mem 0xfc000000-0xfdffffff 64bit pref]
[    0.413080] pci 0000:07:00.0: BAR 6: assigned [mem 0xf8620000-0xf862ffff pref]
[    0.413270] pci 0000:00:1c.4: PCI bridge to [bus 07-07]
[    0.413393] pci 0000:00:1c.4:   bridge window [io  0x5000-0x5fff]
[    0.413520] pci 0000:00:1c.4:   bridge window [mem 0x80000000-0x803fffff]
[    0.413645] pci 0000:00:1c.4:   bridge window [mem 0xf8600000-0xf86fffff 64bit pref]
[    0.413855] pci 0000:00:1e.0: PCI bridge to [bus 08-08]
[    0.415882] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.416007] pci 0000:00:1e.0:   bridge window [mem 0xf8200000-0xf82fffff]
[    0.416133] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.416290]   alloc irq_desc for 17 on node -1
[    0.416294]   alloc kstat_irqs on node -1
[    0.416303] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.416429] pci 0000:00:1c.0: setting latency timer to 64
[    0.416447]   alloc irq_desc for 16 on node -1
[    0.416450]   alloc kstat_irqs on node -1
[    0.416457] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.416580] pci 0000:00:1c.1: setting latency timer to 64
[    0.416597]   alloc irq_desc for 19 on node -1
[    0.416600]   alloc kstat_irqs on node -1
[    0.416606] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.416730] pci 0000:00:1c.3: setting latency timer to 64
[    0.416746] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.416879] pci 0000:00:1c.4: setting latency timer to 64
[    0.416892] pci 0000:00:1e.0: setting latency timer to 64
[    0.416899] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.416902] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.416906] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.416909] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.416913] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.416916] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.416920] pci_bus 0000:00: resource 10 [mem 0x80000000-0xdfffffff]
[    0.416923] pci_bus 0000:00: resource 11 [mem 0xf0000000-0xfebfffff]
[    0.416927] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.416931] pci_bus 0000:02: resource 1 [mem 0xc4000000-0xc7ffffff]
[    0.416934] pci_bus 0000:02: resource 2 [mem 0xcc000000-0xcdffffff 64bit pref]
[    0.416938] pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
[    0.416941] pci_bus 0000:03: resource 1 [mem 0xf0000000-0xf3ffffff]
[    0.416945] pci_bus 0000:03: resource 2 [mem 0xfa000000-0xfbffffff 64bit pref]
[    0.416948] pci_bus 0000:06: resource 0 [io  0x4000-0x4fff]
[    0.416952] pci_bus 0000:06: resource 1 [mem 0xf4000000-0xf7ffffff]
[    0.416955] pci_bus 0000:06: resource 2 [mem 0xfc000000-0xfdffffff 64bit pref]
[    0.416959] pci_bus 0000:07: resource 0 [io  0x5000-0x5fff]
[    0.416962] pci_bus 0000:07: resource 1 [mem 0x80000000-0x803fffff]
[    0.416966] pci_bus 0000:07: resource 2 [mem 0xf8600000-0xf86fffff 64bit pref]
[    0.416970] pci_bus 0000:08: resource 1 [mem 0xf8200000-0xf82fffff]
[    0.416973] pci_bus 0000:08: resource 4 [io  0x0000-0x0cf7]
[    0.416977] pci_bus 0000:08: resource 5 [io  0x0d00-0xffff]
[    0.416980] pci_bus 0000:08: resource 6 [mem 0x000a0000-0x000bffff]
[    0.416983] pci_bus 0000:08: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.416987] pci_bus 0000:08: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.416990] pci_bus 0000:08: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.416993] pci_bus 0000:08: resource 10 [mem 0x80000000-0xdfffffff]
[    0.416997] pci_bus 0000:08: resource 11 [mem 0xf0000000-0xfebfffff]
[    0.417083] NET: Registered protocol family 2
[    0.417507] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.419316] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.422417] TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
[    0.429114] TCP: Hash tables configured (established 262144 bind 65536)
[    0.429309] TCP reno registered
[    0.429470] UDP hash table entries: 1024 (order: 5, 131072 bytes)
[    0.429836] UDP-Lite hash table entries: 1024 (order: 5, 131072 bytes)
[    0.430396] NET: Registered protocol family 1
[    0.430549] pci 0000:00:02.0: Boot video device
[    0.430568] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x3e00
[    0.430572] pci 0000:00:1a.0: Performing full reset
[    0.430598] pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x2000
[    0.430601] pci 0000:00:1a.1: Performing full reset
[    0.430691] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x2e00
[    0.430694] pci 0000:00:1d.0: Performing full reset
[    0.430721] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x2000
[    0.430724] pci 0000:00:1d.1: Performing full reset
[    0.430750] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x2000
[    0.430754] pci 0000:00:1d.2: Performing full reset
[    0.430866] PCI: CLS 64 bytes, default 64
[    0.431188] Trying to unpack rootfs image as initramfs...
[    0.719911] Freeing initrd memory: 1204k freed
[    0.720674] Simple Boot Flag at 0x36 set to 0x1
[    0.722003] microcode: CPU0 sig=0x6fd, pf=0x80, revision=0xa1
[    0.722142] microcode: CPU1 sig=0x6fd, pf=0x80, revision=0xa1
[    0.722325] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.722510] Scanning for low memory corruption every 60 seconds
[    0.723048] cryptomgr_test used greatest stack depth: 6448 bytes left
[    0.723295] audit: initializing netlink socket (disabled)
[    0.723482] type=2000 audit(1282646625.721:1): initialized
[    0.750353] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.754700] VFS: Disk quotas dquot_6.5.2
[    0.754989] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.755576] msgmni has been set to 3988
[    0.756382] cryptomgr_test used greatest stack depth: 6080 bytes left
[    0.756889] alg: No test for stdrng (krng)
[    0.757128] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.757336] io scheduler noop registered
[    0.757451] io scheduler deadline registered
[    0.757655] io scheduler cfq registered (default)
[    0.758122] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.758353] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.758572] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.758802] pcieport 0000:00:1c.4: setting latency timer to 64
[    0.759161] intel_idle: MWAIT substates: 0x22220
[    0.759165] intel_idle: does not run on family 6 model 15
[    0.767137] ACPI: AC Adapter [ACAD] (on-line)
[    0.767507] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    0.767792] ACPI: Lid Switch [LID0]
[    0.768033] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    0.768278] ACPI: Power Button [PWRB]
[    0.768520] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    0.768710] ACPI: Sleep Button [SLPB]
[    0.768994] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.769183] ACPI: Power Button [PWRF]
[    0.769423] ACPI: acpi_idle registered with cpuidle
[    0.775239] Monitor-Mwait will be used to enter C-1 state
[    0.775305] Monitor-Mwait will be used to enter C-2 state
[    0.775361] Monitor-Mwait will be used to enter C-3 state
[    0.775372] Marking TSC unstable due to TSC halts in idle
[    0.775832] Switching to clocksource hpet
[    1.135380] ACPI: Battery Slot [BAT1] (battery present)
[    1.135807] Non-volatile memory driver v1.3
[    1.136321] Linux agpgart interface v0.103
[    1.136697] agpgart-intel 0000:00:00.0: Intel 965GM Chipset
[    1.137699] agpgart-intel 0000:00:00.0: detected 7676K stolen memory
[    1.142482] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    1.142709] [drm] Initialized drm 1.1.0 20060810
[    1.142865] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.142988] i915 0000:00:02.0: setting latency timer to 64
[    1.218434] [drm:i915_init_phys_hws], Enabled hardware status page
[    1.218459] [drm] set up 7M of stolen space
[    1.219299] [drm:i915_gtt_to_phys], GTT addr: 0x00000000, PTE: 0x7f800001
[    1.219376] [drm:i915_gtt_to_phys], GTT addr: 0x00000000, phys addr: 0x7f800000
[    1.219524] [drm:i915_gtt_to_phys], GTT addr: 0x006c8000, PTE: 0x79eee001
[    1.219598] [drm:i915_gtt_to_phys], GTT addr: 0x006c8000, phys addr: 0x79eee000
[    1.219603] [drm:i915_setup_compression], FBC base 0x7f800000, ll base 0x79eee000, size 6M
[    1.219637] [drm:parse_general_definitions], crt_ddc_bus_pin: 2
[    1.219645] [drm:parse_lfp_panel_data], Found panel mode in BIOS VBT tables:
[    1.219649] [drm:drm_mode_debug_printmodeline], Modeline 0:"1280x800" 0 69300 1280 1304 1336 1416 800 804 810 817 0x8 0xa
[    1.219666] [drm:parse_sdvo_device_mapping], No SDVO device info is found in VBT
[    1.219877] [drm:intel_modeset_init], 2 display pipes available.
[    1.326986] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.327588] [drm] initialized overlay support
[    1.438045] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[    1.448205] [drm:drm_fb_helper_connector_parse_command_line], cmdline mode for connector LVDS-1 0x0@60Hz
[    1.448211] [drm] forcing LVDS-1 connector OFF
[    1.448328] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[    1.448332] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[    1.448359] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[    1.562366] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[    1.562372] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    1.562379] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[    1.562386] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[    1.562392] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[    1.562399] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[    1.562405] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[    1.562412] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[    1.562418] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[    1.562425] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[    1.562431] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[    1.562438] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[    1.562444] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[    1.562450] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[    1.562457] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[    1.562463] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[    1.562469] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[    1.562476] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[    1.562483] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[    1.562492] [drm:drm_crtc_helper_set_mode], [CRTC:3]
[    1.562500] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 0
[    1.572897] [drm:intel_crtc_mode_set], Mode for pipe A:
[    1.572902] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[    1.624013] [drm:intel_wait_for_vblank], vblank wait timed out
[    1.624017] [drm:intel_pipe_set_base], No FB bound
[    1.624022] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set [MODE:0:NTSC 480i]
[    1.675012] [drm:intel_wait_for_vblank], vblank wait timed out
[    1.675033] [drm:intel_update_watermarks], plane A (pipe 0) clock: 107520
[    1.675038] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[    1.675042] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[    1.675072] [drm:intel_update_fbc], 
[    1.726011] [drm:intel_wait_for_vblank], vblank wait timed out
[    1.777013] [drm:intel_wait_for_vblank], vblank wait timed out
[    1.828011] [drm:intel_wait_for_vblank], vblank wait timed out
[    1.828016] [drm:intel_tv_detect_type], No TV connection detected
[    1.948189] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[    1.958347] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[    1.958353] [drm:drm_setup_crtcs], 
[    1.958357] [drm:drm_enable_connectors], connector 5 enabled? no
[    1.958361] [drm:drm_enable_connectors], connector 12 enabled? yes
[    1.958365] [drm:drm_enable_connectors], connector 14 enabled? no
[    1.958369] [drm:drm_target_preferred], looking for cmdline mode on connector 12
[    1.958374] [drm:drm_target_preferred], looking for preferred mode on connector 12
[    1.958378] [drm:drm_target_preferred], found mode 1280x1024
[    1.958382] [drm:drm_setup_crtcs], picking CRTCs for 8192x8192 config
[    1.958388] [drm:drm_setup_crtcs], desired mode 1280x1024 set on crtc 3
[    1.968165] [drm:intelfb_create], allocated 1280x1024 fb: 0x00800000, bo ffff88007a1d2200
[    1.970381] [drm:drm_crtc_helper_set_config], 
[    1.970385] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:47] #connectors=1 (x y) (0 0)
[    1.970393] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[    1.970396] [drm:drm_crtc_helper_set_config], modes are different, full mode set
[    1.970400] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[    1.970406] [drm:drm_mode_debug_printmodeline], Modeline 31:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    1.970415] [drm:drm_crtc_helper_set_config], encoder changed, full mode switch
[    1.970418] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[    1.970422] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[    1.970425] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[    1.970428] [drm:drm_mode_debug_printmodeline], Modeline 31:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    1.970436] [drm:drm_crtc_helper_set_mode], [CRTC:3]
[    1.970471] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 0
[    1.980868] [drm:intel_crtc_mode_set], Mode for pipe A:
[    1.980871] [drm:drm_mode_debug_printmodeline], Modeline 31:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    2.032012] [drm:intel_wait_for_vblank], vblank wait timed out
[    2.032043] [drm:intel_pipe_set_base], Writing base 00800000 00000000 0 0 5120
[    2.032048] [drm:intel_update_fbc], 
[    2.032051] [drm:intel_update_fbc], 1 pipes active
[    2.032053] [drm:intel_update_fbc], framebuffer not tiled, disabling compression
[    2.083013] [drm:intel_wait_for_vblank], vblank wait timed out
[    2.083018] [drm:drm_crtc_helper_set_mode], [ENCODER:13:DAC-13] set [MODE:31:1280x1024]
[    2.083022] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[    2.083026] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[    2.083030] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[    2.083058] [drm:intel_update_fbc], 
[    2.083061] [drm:intel_update_fbc], 1 pipes active
[    2.083063] [drm:intel_update_fbc], framebuffer not tiled, disabling compression
[    2.083079] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[    2.093234] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[    2.093238] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[    2.093241] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[    2.093246] [drm:drm_crtc_helper_set_config], 
[    2.093248] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:47] #connectors=0 (x y) (0 0)
[    2.093255] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[    2.093258] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[    2.093265] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[    2.103420] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[    2.103424] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[    2.103427] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[    2.104828] [drm:drm_crtc_helper_set_config], 
[    2.104830] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:47] #connectors=1 (x y) (0 0)
[    2.104839] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[    2.108962] [drm:drm_crtc_helper_set_config], 
[    2.108965] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:47] #connectors=1 (x y) (0 0)
[    2.108974] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[    2.113057] Console: switching to colour frame buffer device 160x64
[    2.113065] [drm:drm_crtc_helper_set_config], 
[    2.113067] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:47] #connectors=1 (x y) (0 0)
[    2.113075] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[    2.117219] fb0: inteldrmfb frame buffer device
[    2.117248] drm: registered panic notifier
[    2.117315] [drm:intel_opregion_init], graphic opregion physical addr: 0x7f6dfe3c
[    2.117333] [drm:intel_opregion_init], Public ACPI methods supported
[    2.117643] [drm:intel_opregion_init], SWSCI supported
[    2.117647] [drm:intel_opregion_init], ASLE supported
[    2.149122] acpi device:07: registered as cooling_device2
[    2.149666] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:01/input/input4
[    2.149737] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    2.149896] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    2.153333] brd: module loaded
[    2.153411] console [netcon0] enabled
[    2.153436] netconsole: network logging started
[    2.153762] usbcore: registered new interface driver libusual
[    2.153893] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    2.182567] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.182647] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.182845] mice: PS/2 mouse device common for all mice
[    2.182953] rtc_cmos 00:07: RTC can wake from S4
[    2.183298] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    2.183386] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    2.183445] i2c /dev entries driver
[    2.184038]   alloc irq_desc for 18 on node -1
[    2.184042]   alloc kstat_irqs on node -1
[    2.184080] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.184140] ACPI: resource 0000:00:1f.3 [io  0x1c20-0x1c3f] conflicts with ACPI region SMBI [io  0x1c20-0x1c2f disabled]
[    2.184205] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    2.184511] cpuidle: using governor ladder
[    2.185675] cpuidle: using governor menu
[    2.185780] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    2.186269] usbcore: registered new interface driver hiddev
[    2.186332] usbcore: registered new interface driver usbhid
[    2.186367] usbhid: USB HID core driver
[    2.186438] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    2.188720] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.188880] TCP cubic registered
[    2.188904] Initializing XFRM netlink socket
[    2.188959] NET: Registered protocol family 17
[    2.188994] lib80211: common routines for IEEE802.11 drivers
[    2.189062] lib80211_crypt: registered algorithm 'NULL'
[    2.189066] Registering the dns_resolver key type
[    2.190808] registered taskstats version 1
[    2.191692] rtc_cmos 00:07: setting system clock to 2010-08-24 10:43:48 UTC (1282646628)
[    2.191745] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.191784] EDD information not available.
[    2.191910] Initalizing network drop monitor service
[    2.194560] Freeing unused kernel memory: 548k freed
[    2.196754] Write protecting the kernel read-only data: 6144k
[    2.198994] Freeing unused kernel memory: 292k freed
[    2.201232] Freeing unused kernel memory: 260k freed
[    2.207110] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[    2.208351] busybox used greatest stack depth: 5688 bytes left
[    2.217670] grep used greatest stack depth: 5280 bytes left
[    2.227321] udev: starting version 161
[    2.227413] udevd (55): /proc/55/oom_adj is deprecated, please use /proc/55/oom_score_adj instead.
[    2.481581] load-modules.sh used greatest stack depth: 5096 bytes left
[    2.518309] udevadm used greatest stack depth: 4256 bytes left
[    2.804640] SCSI subsystem initialized
[    2.830749] libata version 3.00 loaded.
[    2.832958] pata_acpi 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.835219] pata_acpi 0000:00:1f.1: setting latency timer to 64
[    2.835305] pata_acpi 0000:00:1f.1: PCI INT A disabled
[    2.844666] ata_piix 0000:00:1f.1: version 2.13
[    2.844685] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.846931] ata_piix 0000:00:1f.1: setting latency timer to 64
[    2.847095] scsi0 : ata_piix
[    2.849694] scsi1 : ata_piix
[    2.852911] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
[    2.854977] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
[    2.857223] ahci 0000:00:1f.2: version 3.0
[    2.857247] ahci 0000:00:1f.2: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[    2.859411] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x7 impl SATA mode
[    2.861497] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc 
[    2.863558] ahci 0000:00:1f.2: setting latency timer to 64
[    2.863865] scsi2 : ahci
[    2.866215] scsi3 : ahci
[    2.868416] scsi4 : ahci
[    2.870848] ata3: SATA max UDMA/133 irq_stat 0x00400040, connection status changed
[    2.872863] ata4: SATA max UDMA/133 abar m2048@0xf8504000 port 0xf8504180 irq 18
[    2.874852] ata5: SATA max UDMA/133 abar m2048@0xf8504000 port 0xf8504200 irq 18
[    3.021896] ata1.00: ATAPI: TEAC   DVD+/-RW DVW28SLC, A.06, max UDMA/33
[    3.046463] ata1.00: configured for UDMA/33
[    3.063078] scsi 0:0:0:0: CD-ROM            TEAC     DVD+-RW DVW28SLC A.06 PQ: 0 ANSI: 5
[    3.182161] ata4: SATA link down (SStatus 0 SControl 300)
[    3.184243] ata5: SATA link down (SStatus 0 SControl 300)
[    3.600134] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.602872] ata3.00: unexpected _GTF length (8)
[    3.649645] ata3.00: ATA-8: WDC WD1600BEVT-75ZCT0, 11.01A11, max UDMA/133
[    3.651701] ata3.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    3.654748] ata3.00: unexpected _GTF length (8)
[    3.657091] ata3.00: configured for UDMA/133
[    3.670405] scsi 2:0:0:0: Direct-Access     ATA      WDC WD1600BEVT-7 11.0 PQ: 0 ANSI: 5
[    3.690088] sd 2:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    3.692222] sd 2:0:0:0: [sda] Write Protect is off
[    3.694157] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.694218] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.710228]  sda: sda1 sda2 sda3 sda4
[    3.713696] sd 2:0:0:0: [sda] Attached SCSI disk
[    3.747825] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda caddy
[    3.749893] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.752394] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    3.826304] scsi_id used greatest stack depth: 4208 bytes left
[    4.314966] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    6.148770] udev: starting version 161
[    6.549218] udevadm used greatest stack depth: 4112 bytes left
[    6.706130] iTCO_vendor_support: vendor-support=0
[    6.760764] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[    6.760986] iTCO_wdt: Found a ICH8M TCO device (Version=2, TCOBASE=0x1060)
[    6.761394] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    6.792288] ACPI: WMI: Mapper loaded
[    6.921184] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.921189] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    6.921266] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.921304] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    6.921310] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    6.921867] drivers/usb/core/inode.c: creating file 'devices'
[    6.929694] drivers/usb/core/inode.c: creating file '001'
[    6.930433] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    6.930447] ehci_hcd 0000:00:1a.7: reset hcs_params 0x102204 dbg=1 cc=2 pcc=2 ordered !ppc ports=4
[    6.930454] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    6.930550] ehci_hcd 0000:00:1a.7: debug port 1
[    6.930557] ehci_hcd 0000:00:1a.7: reset command 0080032 (park)=0 ithresh=8 Async Periodic period=1024 Reset HALT
[    6.934453] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    6.934456] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    6.934472] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf8504800
[    6.934479] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    6.945602] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    6.951072] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    6.951411] usb usb1: default language 0x0409
[    6.951434] usb usb1: udev 1, busnum 1, minor = 0
[    6.951438] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    6.951442] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.951445] usb usb1: Product: EHCI Host Controller
[    6.951448] usb usb1: Manufacturer: Linux 2.6.36-rc2-RC ehci_hcd
[    6.951452] usb usb1: SerialNumber: 0000:00:1a.7
[    6.952290] usb usb1: usb_probe_device
[    6.952296] usb usb1: configuration #1 chosen from 1 choice
[    6.952516] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    6.952719] hub 1-0:1.0: usb_probe_interface
[    6.952723] hub 1-0:1.0: usb_probe_interface - got id
[    6.952732] hub 1-0:1.0: USB hub found
[    6.952797] hub 1-0:1.0: 4 ports detected
[    6.952800] hub 1-0:1.0: standalone hub
[    6.952804] hub 1-0:1.0: no power switching (usb 1.0)
[    6.952807] hub 1-0:1.0: individual port over-current protection
[    6.952811] hub 1-0:1.0: power on to power good time: 20ms
[    6.952973] hub 1-0:1.0: local power source is good
[    6.952977] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    6.953106] drivers/usb/core/inode.c: creating file '001'
[    6.953420]   alloc irq_desc for 23 on node -1
[    6.953424]   alloc kstat_irqs on node -1
[    6.953437] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    6.953479] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    6.953485] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    6.953506] drivers/usb/core/inode.c: creating file '002'
[    6.953676] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    6.953689] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    6.953696] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    6.953742] ehci_hcd 0000:00:1d.7: debug port 1
[    6.953750] ehci_hcd 0000:00:1d.7: reset command 0080032 (park)=0 ithresh=8 Async Periodic period=1024 Reset HALT
[    6.958669] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    6.958674] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    6.958720] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf8504c00
[    6.958728] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    6.962614] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    6.966855] uhci_hcd: USB Universal Host Controller Interface driver
[    6.968674] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    6.968792] usb usb2: default language 0x0409
[    6.968815] usb usb2: udev 1, busnum 2, minor = 128
[    6.968819] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    6.968823] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.968827] usb usb2: Product: EHCI Host Controller
[    6.968830] usb usb2: Manufacturer: Linux 2.6.36-rc2-RC ehci_hcd
[    6.968833] usb usb2: SerialNumber: 0000:00:1d.7
[    6.969628] usb usb2: usb_probe_device
[    6.969634] usb usb2: configuration #1 chosen from 1 choice
[    6.969676] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    6.969831] hub 2-0:1.0: usb_probe_interface
[    6.969835] hub 2-0:1.0: usb_probe_interface - got id
[    6.969842] hub 2-0:1.0: USB hub found
[    6.969857] hub 2-0:1.0: 6 ports detected
[    6.969860] hub 2-0:1.0: standalone hub
[    6.969863] hub 2-0:1.0: no power switching (usb 1.0)
[    6.969867] hub 2-0:1.0: individual port over-current protection
[    6.969871] hub 2-0:1.0: power on to power good time: 20ms
[    6.969888] hub 2-0:1.0: local power source is good
[    6.969892] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    6.970078] drivers/usb/core/inode.c: creating file '001'
[    6.973139] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.973154] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    6.973161] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    6.973180] drivers/usb/core/inode.c: creating file '003'
[    6.973426] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    6.973440] uhci_hcd 0000:00:1a.0: detected 2 ports
[    6.973448] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    6.973451] uhci_hcd 0000:00:1a.0: Performing full reset
[    6.973470] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    6.973486] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00001820
[    6.973654] usb usb3: default language 0x0409
[    6.973676] usb usb3: udev 1, busnum 3, minor = 256
[    6.973680] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    6.973684] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.973687] usb usb3: Product: UHCI Host Controller
[    6.973690] usb usb3: Manufacturer: Linux 2.6.36-rc2-RC uhci_hcd
[    6.973693] usb usb3: SerialNumber: 0000:00:1a.0
[    6.973965] usb usb3: usb_probe_device
[    6.973970] usb usb3: configuration #1 chosen from 1 choice
[    6.973990] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    6.974182] hub 3-0:1.0: usb_probe_interface
[    6.974186] hub 3-0:1.0: usb_probe_interface - got id
[    6.974193] hub 3-0:1.0: USB hub found
[    6.974210] hub 3-0:1.0: 2 ports detected
[    6.974213] hub 3-0:1.0: standalone hub
[    6.974216] hub 3-0:1.0: no power switching (usb 1.0)
[    6.974220] hub 3-0:1.0: individual port over-current protection
[    6.974224] hub 3-0:1.0: power on to power good time: 2ms
[    6.974263] hub 3-0:1.0: local power source is good
[    6.974268] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    6.974335] drivers/usb/core/inode.c: creating file '001'
[    6.974435] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    6.974519]   alloc irq_desc for 21 on node -1
[    6.974523]   alloc kstat_irqs on node -1
[    6.974534] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    6.974546] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    6.974551] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    6.974566] drivers/usb/core/inode.c: creating file '004'
[    6.974705] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    6.974717] uhci_hcd 0000:00:1a.1: detected 2 ports
[    6.974724] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    6.974728] uhci_hcd 0000:00:1a.1: Performing full reset
[    6.974747] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[    6.974790] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001840
[    6.974868] usb usb4: default language 0x0409
[    6.974890] usb usb4: udev 1, busnum 4, minor = 384
[    6.974893] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    6.974897] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.974901] usb usb4: Product: UHCI Host Controller
[    6.974904] usb usb4: Manufacturer: Linux 2.6.36-rc2-RC uhci_hcd
[    6.974907] usb usb4: SerialNumber: 0000:00:1a.1
[    6.975139] usb usb4: usb_probe_device
[    6.975143] usb usb4: configuration #1 chosen from 1 choice
[    6.975161] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    6.975244] hub 4-0:1.0: usb_probe_interface
[    6.975247] hub 4-0:1.0: usb_probe_interface - got id
[    6.975254] hub 4-0:1.0: USB hub found
[    6.975267] hub 4-0:1.0: 2 ports detected
[    6.975270] hub 4-0:1.0: standalone hub
[    6.975273] hub 4-0:1.0: no power switching (usb 1.0)
[    6.975277] hub 4-0:1.0: individual port over-current protection
[    6.975281] hub 4-0:1.0: power on to power good time: 2ms
[    6.975297] hub 4-0:1.0: local power source is good
[    6.975301] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    6.975363] drivers/usb/core/inode.c: creating file '001'
[    6.975458] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
[    6.975541] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    6.975552] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    6.975558] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    6.975572] drivers/usb/core/inode.c: creating file '005'
[    6.975696] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    6.975708] uhci_hcd 0000:00:1d.0: detected 2 ports
[    6.975715] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    6.975719] uhci_hcd 0000:00:1d.0: Performing full reset
[    6.975738] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    6.975750] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001860
[    6.975829] usb usb5: default language 0x0409
[    6.975851] usb usb5: udev 1, busnum 5, minor = 512
[    6.975854] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    6.975858] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.975862] usb usb5: Product: UHCI Host Controller
[    6.975865] usb usb5: Manufacturer: Linux 2.6.36-rc2-RC uhci_hcd
[    6.975868] usb usb5: SerialNumber: 0000:00:1d.0
[    6.976097] usb usb5: usb_probe_device
[    6.976101] usb usb5: configuration #1 chosen from 1 choice
[    6.976119] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    6.976202] hub 5-0:1.0: usb_probe_interface
[    6.976205] hub 5-0:1.0: usb_probe_interface - got id
[    6.976212] hub 5-0:1.0: USB hub found
[    6.976224] hub 5-0:1.0: 2 ports detected
[    6.976228] hub 5-0:1.0: standalone hub
[    6.976231] hub 5-0:1.0: no power switching (usb 1.0)
[    6.976234] hub 5-0:1.0: individual port over-current protection
[    6.976238] hub 5-0:1.0: power on to power good time: 2ms
[    6.976254] hub 5-0:1.0: local power source is good
[    6.976258] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    6.976320] drivers/usb/core/inode.c: creating file '001'
[    6.976438] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    6.976492] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    6.976503] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    6.976509] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    6.976523] drivers/usb/core/inode.c: creating file '006'
[    6.976669] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    6.976681] uhci_hcd 0000:00:1d.1: detected 2 ports
[    6.976688] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    6.976691] uhci_hcd 0000:00:1d.1: Performing full reset
[    6.976710] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    6.976748] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001880
[    6.976824] usb usb6: default language 0x0409
[    6.976846] usb usb6: udev 1, busnum 6, minor = 640
[    6.976849] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    6.976853] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.976856] usb usb6: Product: UHCI Host Controller
[    6.976859] usb usb6: Manufacturer: Linux 2.6.36-rc2-RC uhci_hcd
[    6.976862] usb usb6: SerialNumber: 0000:00:1d.1
[    6.977094] usb usb6: usb_probe_device
[    6.977098] usb usb6: configuration #1 chosen from 1 choice
[    6.977116] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    6.977198] hub 6-0:1.0: usb_probe_interface
[    6.977201] hub 6-0:1.0: usb_probe_interface - got id
[    6.977208] hub 6-0:1.0: USB hub found
[    6.977220] hub 6-0:1.0: 2 ports detected
[    6.977224] hub 6-0:1.0: standalone hub
[    6.977227] hub 6-0:1.0: no power switching (usb 1.0)
[    6.977230] hub 6-0:1.0: individual port over-current protection
[    6.977234] hub 6-0:1.0: power on to power good time: 2ms
[    6.977250] hub 6-0:1.0: local power source is good
[    6.977254] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    6.977316] drivers/usb/core/inode.c: creating file '001'
[    6.977432] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    6.977486] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.977497] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    6.977503] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    6.977517] drivers/usb/core/inode.c: creating file '007'
[    6.977666] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    6.977677] uhci_hcd 0000:00:1d.2: detected 2 ports
[    6.977684] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    6.977688] uhci_hcd 0000:00:1d.2: Performing full reset
[    6.977708] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    6.977720] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018a0
[    6.977797] usb usb7: default language 0x0409
[    6.977818] usb usb7: udev 1, busnum 7, minor = 768
[    6.977821] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    6.977825] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.977829] usb usb7: Product: UHCI Host Controller
[    6.977832] usb usb7: Manufacturer: Linux 2.6.36-rc2-RC uhci_hcd
[    6.977835] usb usb7: SerialNumber: 0000:00:1d.2
[    6.979265] usb usb7: usb_probe_device
[    6.979270] usb usb7: configuration #1 chosen from 1 choice
[    6.979291] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    6.979427] hub 7-0:1.0: usb_probe_interface
[    6.979431] hub 7-0:1.0: usb_probe_interface - got id
[    6.979438] hub 7-0:1.0: USB hub found
[    6.979452] hub 7-0:1.0: 2 ports detected
[    6.979455] hub 7-0:1.0: standalone hub
[    6.979458] hub 7-0:1.0: no power switching (usb 1.0)
[    6.979462] hub 7-0:1.0: individual port over-current protection
[    6.979465] hub 7-0:1.0: power on to power good time: 2ms
[    6.979482] hub 7-0:1.0: local power source is good
[    6.979486] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    6.979555] drivers/usb/core/inode.c: creating file '001'
[    6.979678] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    6.989448] input: Dell WMI hotkeys as /devices/virtual/input/input6
[    7.001748] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    7.001915] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    7.019828] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    7.019882] r8169 0000:07:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.020038] r8169 0000:07:00.0: setting latency timer to 64
[    7.020067] r8169 0000:07:00.0: no MSI. Back to INTx.
[    7.021211] r8169 0000:07:00.0: eth0: RTL8168c/8111c at 0xffffc900215d0000, 00:1c:23:4e:23:72, XID 1c4000c0 IRQ 16
[    7.053350] hub 1-0:1.0: state 7 ports 4 chg 0000 evt 0000
[    7.069064] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 001403 0  ACK POWER sig=k CSC CONNECT
[    7.069074] hub 2-0:1.0: port 2: status 0501 change 0001
[    7.070873] coretemp coretemp.0: TjMax is assumed as 100 C!
[    7.072138] coretemp coretemp.1: TjMax is assumed as 100 C!
[    7.074091] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    7.075211] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    7.076069] uhci_hcd 0000:00:1d.0: port 2 portsc 008a,00
[    7.077076] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    7.079634] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    7.101886]   alloc irq_desc for 22 on node -1
[    7.101891]   alloc kstat_irqs on node -1
[    7.101903] firewire_ohci 0000:08:05.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    7.119861] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:s
[    7.119865] iwl3945: Copyright(c) 2003-2010 Intel Corporation
[    7.120100] iwl3945 0000:06:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    7.120118] iwl3945 0000:06:00.0: setting latency timer to 64
[    7.153367] firewire_ohci: Added fw-ohci device 0000:08:05.0, OHCI v1.10, 8 IR + 8 IT contexts, quirks 0x0
[    7.171684] hub 2-0:1.0: state 7 ports 6 chg 0004 evt 0000
[    7.171736] hub 2-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[    7.171891] ehci_hcd 0000:00:1d.7: port 2 low speed --> companion
[    7.178276] iwl3945 0000:06:00.0: Tunable channels: 13 802.11bg, 23 802.11a channels
[    7.178282] iwl3945 0000:06:00.0: Detected Intel Wireless WiFi Link 3945ABG
[    7.186061] phy0: Selected rate control algorithm 'iwl-3945-rs'
[    7.222124] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    7.222275] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0004
[    7.222302] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    7.222320] uhci_hcd 0000:00:1d.0: port 2 portsc 01a3,00
[    7.222338] hub 5-0:1.0: port 2, status 0301, change 0001, 1.5 Mb/s
[    7.328077] hub 5-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x301
[    7.430310] usb 5-2: new low speed USB device using uhci_hcd and address 2
[    7.465443] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    7.465505] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    7.534401] fuse init (API version 7.15)
[    7.557751] hda_codec: ALC268: BIOS auto-probing.
[    7.563633] modprobe used greatest stack depth: 3920 bytes left
[    7.578864] usb 5-2: skipped 1 descriptor after interface
[    7.578870] usb 5-2: skipped 1 descriptor after interface
[    7.583855] usb 5-2: default language 0x0409
[    7.602852] usb 5-2: udev 2, busnum 5, minor = 513
[    7.602857] usb 5-2: New USB device found, idVendor=046d, idProduct=c512
[    7.602861] usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.602865] usb 5-2: Product: 2.4GHz Cordless Desktop
[    7.602868] usb 5-2: Manufacturer: Logitech
[    7.603324] usb 5-2: usb_probe_device
[    7.603330] usb 5-2: configuration #1 chosen from 1 choice
[    7.605894] usb 5-2: adding 5-2:1.0 (config #1, interface 0)
[    7.606066] usbhid 5-2:1.0: usb_probe_interface
[    7.606071] usbhid 5-2:1.0: usb_probe_interface - got id
[    7.620969] input: Logitech 2.4GHz Cordless Desktop as /devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2:1.0/input/input7
[    7.621155] uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[    7.622206] logitech 0003:046D:C512.0001: input,hidraw0: USB HID v1.11 Keyboard [Logitech 2.4GHz Cordless Desktop] on usb-0000:00:1d.0-2/input0
[    7.622279] usb 5-2: adding 5-2:1.1 (config #1, interface 1)
[    7.622370] usbhid 5-2:1.1: usb_probe_interface
[    7.622375] usbhid 5-2:1.1: usb_probe_interface - got id
[    7.652836] input: Logitech 2.4GHz Cordless Desktop as /devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2:1.1/input/input8
[    7.652868] uhci_hcd 0000:00:1d.0: reserve dev 2 ep82-INT, period 8, phase 4, 118 us
[    7.653361] drivers/usb/core/file.c: looking for a minor, starting at 0
[    7.654901] logitech 0003:046D:C512.0002: input,hiddev0,hidraw1: USB HID v1.11 Mouse [Logitech 2.4GHz Cordless Desktop] on usb-0000:00:1d.0-2/input1
[    7.654977] drivers/usb/core/inode.c: creating file '002'
[    7.655879] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    7.657095] input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input9
[    7.661968] firewire_core: created device fw0: GUID 0000c010a000b000, S400
[    7.694386] input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio1/input/input10
[    8.204079] usb usb3: suspend_rh (auto-stop)
[    8.204113] usb usb4: suspend_rh (auto-stop)
[    8.204146] usb usb6: suspend_rh (auto-stop)
[    8.204182] usb usb7: suspend_rh (auto-stop)
[    8.296763] EXT4-fs (sda1): re-mounted. Opts: (null)
[    8.553681] EXT4-fs (sda1): re-mounted. Opts: (null)
[    8.668674] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
[    8.737369] Adding 4000180k swap on /dev/sda4.  Priority:-1 extents:1 across:4000180k 
[    9.261267] find used greatest stack depth: 3840 bytes left
[    9.704299] hub 7-0:1.0: hub_suspend
[    9.704414] usb usb7: bus auto-suspend
[    9.704430] usb usb7: suspend_rh
[    9.712054] hub 1-0:1.0: hub_suspend
[    9.712064] usb usb1: bus auto-suspend
[    9.712068] ehci_hcd 0000:00:1a.7: suspend root hub
[    9.712199] hub 3-0:1.0: hub_suspend
[    9.712208] usb usb3: bus auto-suspend
[    9.712211] usb usb3: suspend_rh
[    9.712235] hub 4-0:1.0: hub_suspend
[    9.712243] usb usb4: bus auto-suspend
[    9.712246] usb usb4: suspend_rh
[    9.712271] hub 6-0:1.0: hub_suspend
[    9.712279] usb usb6: bus auto-suspend
[    9.712282] usb usb6: suspend_rh
[    9.712306] hub 2-0:1.0: hub_suspend
[    9.712314] usb usb2: bus auto-suspend
[    9.712318] ehci_hcd 0000:00:1d.7: suspend root hub
[   10.741790] rc.sysinit used greatest stack depth: 3376 bytes left
[   11.333517] [drm:i915_driver_irq_handler], 
[   11.333522] r8169 0000:07:00.0: eth0: link up
[   11.333526] pipe a underrun
[   11.333636] r8169 0000:07:00.0: eth0: link up
[   27.123987] [drm:drm_crtc_helper_set_config], 
[   27.123991] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:47] #connectors=1 (x y) (0 0)
[   27.124037] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   27.131507] [drm:i915_driver_open], 
[   27.131682] [drm:drm_crtc_helper_set_config], 
[   27.131686] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:47] #connectors=1 (x y) (0 0)
[   27.131709] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   27.131714] [drm:drm_crtc_helper_set_config], 
[   27.131718] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:47] #connectors=0 (x y) (0 0)
[   27.131725] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[   27.131729] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   27.131755] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   27.141913] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   27.141918] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   27.141923] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   27.142031] [drm:i915_driver_open], 
[   27.142491] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[3] ENCODERS[3]
[   27.142525] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[3] ENCODERS[3]
[   27.142745] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   27.142752] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   27.142756] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   27.142764] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   27.142769] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   27.142774] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   27.148153] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   27.148165] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[   27.264602] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[   27.264607] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   27.264615] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   27.264621] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   27.264628] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   27.264635] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   27.264641] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   27.264648] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   27.264654] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   27.264661] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   27.264667] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   27.264674] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   27.264680] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   27.264687] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   27.264693] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   27.264700] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   27.264706] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   27.264713] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   27.264730] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   27.264833] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   27.264840] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   27.264851] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[   27.264867] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   27.275026] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   27.275032] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   27.275036] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   27.275282] [drm:intel_crtc_mode_set], Mode for pipe B:
[   27.275287] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   27.275747] [drm:intel_pipe_set_base], No FB bound
[   27.275751] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   27.275756] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   27.275761] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   27.275767] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set [MODE:0:NTSC 480i]
[   27.326011] [drm:intel_wait_for_vblank], vblank wait timed out
[   27.326033] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   27.326037] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   27.326042] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   27.326072] [drm:intel_update_fbc], 
[   27.377011] [drm:intel_wait_for_vblank], vblank wait timed out
[   27.428011] [drm:intel_wait_for_vblank], vblank wait timed out
[   27.479011] [drm:intel_wait_for_vblank], vblank wait timed out
[   27.479015] [drm:intel_tv_detect_type], No TV connection detected
[   27.489929] [drm:i915_driver_irq_handler], pipe b underrun
[   27.506590] [drm:i915_driver_irq_handler], pipe b underrun
[   27.506600] [drm:i915_driver_irq_handler], pipe b underrun
[   27.523251] [drm:i915_driver_irq_handler], pipe b underrun
[   27.539912] [drm:i915_driver_irq_handler], pipe b underrun
[   27.539922] [drm:i915_driver_irq_handler], pipe b underrun
[   27.556574] [drm:i915_driver_irq_handler], pipe b underrun
[   27.573235] [drm:i915_driver_irq_handler], pipe b underrun
[   27.589209] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   27.589214] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   27.589219] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   27.589224] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[   27.589232] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   27.589238] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   27.589247] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[   27.589255] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   27.589896] [drm:i915_driver_irq_handler], pipe b underrun
[   27.599414] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   27.599418] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   27.599423] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   27.599667] [drm:intel_crtc_mode_set], Mode for pipe B:
[   27.599671] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   27.600132] [drm:intel_pipe_set_base], No FB bound
[   27.600136] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   27.600142] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   27.600147] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   27.600154] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set [MODE:0:NTSC 480i]
[   27.606558] [drm:i915_driver_irq_handler], pipe b underrun
[   27.606592] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   27.606597] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   27.606601] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   27.606630] [drm:intel_update_fbc], 
[   27.606639] [drm:intel_tv_detect_type], Detected S-Video TV connection
[   27.623219] [drm:i915_driver_irq_handler], pipe b underrun
[   27.623229] [drm:i915_driver_irq_handler], pipe b underrun
[   27.639880] [drm:i915_driver_irq_handler], pipe b underrun
[   27.656542] [drm:i915_driver_irq_handler], pipe b underrun
[   27.673203] [drm:i915_driver_irq_handler], pipe b underrun
[   27.689865] [drm:i915_driver_irq_handler], pipe b underrun
[   27.706527] [drm:i915_driver_irq_handler], pipe b underrun
[   27.723188] [drm:i915_driver_irq_handler], pipe b underrun
[   27.731837] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   27.731841] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   27.731846] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   27.731868] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] probed modes :
[   27.731873] [drm:drm_mode_debug_printmodeline], Modeline 51:"848x480" 30 14513 848 849 912 944 480 481 512 513 0x48 0x0
[   27.731879] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 30 11315 640 641 704 736 480 481 512 513 0x48 0x0
[   27.731885] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 30 26886 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   27.731892] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 30 16998 800 801 864 896 600 601 632 633 0x40 0x0
[   27.731907] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   27.731913] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   27.731921] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[   27.731928] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   27.742087] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   27.742092] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   27.742097] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   27.742341] [drm:intel_crtc_mode_set], Mode for pipe B:
[   27.742345] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   27.742804] [drm:intel_pipe_set_base], No FB bound
[   27.742808] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   27.742813] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   27.742818] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   27.742824] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set [MODE:0:NTSC 480i]
[   27.756511] [drm:i915_driver_irq_handler], pipe b underrun
[   27.756519] [drm:i915_driver_irq_handler], pipe b underrun
[   27.756551] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   27.756556] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   27.756560] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   27.756590] [drm:intel_update_fbc], 
[   27.756599] [drm:intel_tv_detect_type], Detected Composite TV connection
[   27.773172] [drm:i915_driver_irq_handler], pipe b underrun
[   27.789833] [drm:i915_driver_irq_handler], pipe b underrun
[   27.806495] [drm:i915_driver_irq_handler], pipe b underrun
[   27.823157] [drm:i915_driver_irq_handler], pipe b underrun
[   27.839817] [drm:i915_driver_irq_handler], pipe b underrun
[   27.856479] [drm:i915_driver_irq_handler], pipe b underrun
[   27.871793] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   27.871798] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   27.871803] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   27.871829] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] probed modes :
[   27.871834] [drm:drm_mode_debug_printmodeline], Modeline 51:"848x480" 30 14513 848 849 912 944 480 481 512 513 0x48 0x0
[   27.871841] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 30 11315 640 641 704 736 480 481 512 513 0x48 0x0
[   27.871847] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 30 26886 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   27.871854] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 30 16998 800 801 864 896 600 601 632 633 0x40 0x0
[   27.871865] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   27.871959] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   27.871966] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   27.871971] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   27.871977] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   27.871983] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   27.871988] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   27.872074] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   27.872082] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[   27.873157] [drm:i915_driver_irq_handler], pipe b underrun
[   27.980551] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[   27.980556] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   27.980563] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   27.980570] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   27.980577] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   27.980583] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   27.980590] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   27.980596] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   27.980603] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   27.980609] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   27.980616] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   27.980622] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   27.980628] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   27.980635] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   27.980641] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   27.980647] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   27.980654] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   27.980660] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   27.980672] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   27.983383] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   27.983390] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   27.983400] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[   27.983408] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   27.993567] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   27.993572] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   27.993577] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   27.993821] [drm:intel_crtc_mode_set], Mode for pipe B:
[   27.993825] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   27.994286] [drm:intel_pipe_set_base], No FB bound
[   27.994291] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   27.994295] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   27.994300] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   27.994307] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set [MODE:0:NTSC 480i]
[   28.006432] [drm:i915_driver_irq_handler], pipe b underrun
[   28.006464] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   28.006469] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   28.006474] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   28.006503] [drm:intel_update_fbc], 
[   28.006512] [drm:intel_tv_detect_type], Detected S-Video TV connection
[   28.023093] [drm:i915_driver_irq_handler], pipe b underrun
[   28.039754] [drm:i915_driver_irq_handler], pipe b underrun
[   28.039764] [drm:i915_driver_irq_handler], pipe b underrun
[   28.056415] [drm:i915_driver_irq_handler], pipe b underrun
[   28.073077] [drm:i915_driver_irq_handler], pipe b underrun
[   28.073087] [drm:i915_driver_irq_handler], pipe b underrun
[   28.089739] [drm:i915_driver_irq_handler], pipe b underrun
[   28.106400] [drm:i915_driver_irq_handler], pipe b underrun
[   28.106410] [drm:i915_driver_irq_handler], pipe b underrun
[   28.123062] [drm:i915_driver_irq_handler], pipe b underrun
[   28.126708] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   28.126713] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   28.126718] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   28.126745] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] probed modes :
[   28.126750] [drm:drm_mode_debug_printmodeline], Modeline 51:"848x480" 30 14513 848 849 912 944 480 481 512 513 0x48 0x0
[   28.126756] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 30 11315 640 641 704 736 480 481 512 513 0x48 0x0
[   28.126763] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 30 26886 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   28.126769] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 30 16998 800 801 864 896 600 601 632 633 0x40 0x0
[   28.126780] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   28.223199] [drm:drm_mode_addfb], [FB:52]
[   28.223287] [drm:drm_mode_setcrtc], [CRTC:3]
[   28.223297] [drm:drm_mode_setcrtc], [CONNECTOR:12:VGA-1]
[   28.223302] [drm:drm_crtc_helper_set_config], 
[   28.223305] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:52] #connectors=1 (x y) (0 0)
[   28.223317] [drm:drm_crtc_helper_set_config], modes are different, full mode set
[   28.223321] [drm:drm_mode_debug_printmodeline], Modeline 31:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   28.223328] [drm:drm_mode_debug_printmodeline], Modeline 53:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x0 0xa
[   28.223336] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   28.223341] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[   28.223345] [drm:drm_mode_debug_printmodeline], Modeline 53:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x0 0xa
[   28.223354] [drm:drm_crtc_helper_set_mode], [CRTC:3]
[   28.348805] [drm:intel_crtc_mode_set], Mode for pipe A:
[   28.348809] [drm:drm_mode_debug_printmodeline], Modeline 53:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x0 0xa
[   28.400011] [drm:intel_wait_for_vblank], vblank wait timed out
[   28.404802] [drm:intel_pipe_set_base], Writing base 00D00000 00000000 0 0 4096
[   28.404809] [drm:intel_update_fbc], 
[   28.404813] [drm:intel_update_fbc], 1 pipes active
[   28.404829] [drm:i8xx_enable_fbc], enabled FBC, pitch 63, yoff 0, plane 0, 
[   28.455013] [drm:intel_wait_for_vblank], vblank wait timed out
[   28.455022] [drm:drm_crtc_helper_set_mode], [ENCODER:13:DAC-13] set [MODE:53:1024x768]
[   28.455028] [drm:intel_update_watermarks], plane A (pipe 0) clock: 65000
[   28.455032] [drm:i965_update_wm], self-refresh watermark: display plane 448 cursor 32
[   28.455037] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 448
[   28.455067] [drm:intel_update_fbc], 
[   28.455070] [drm:intel_update_fbc], 1 pipes active
[   28.455075] [drm:i8xx_disable_fbc], disabled FBC
[   28.455089] [drm:i8xx_enable_fbc], enabled FBC, pitch 63, yoff 0, plane 0, 
[   28.455107] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   28.465266] [drm:intel_update_watermarks], plane A (pipe 0) clock: 65000
[   28.465271] [drm:i965_update_wm], self-refresh watermark: display plane 448 cursor 32
[   28.465275] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 448
[   28.465346] [drm:drm_mode_setcrtc], [CRTC:4]
[   28.465357] [drm:drm_mode_setcrtc], [CONNECTOR:14:SVIDEO-1]
[   28.465361] [drm:drm_crtc_helper_set_config], 
[   28.465364] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:52] #connectors=1 (x y) (0 0)
[   28.465373] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[   28.465377] [drm:drm_crtc_helper_set_config], modes are different, full mode set
[   28.465381] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   28.465388] [drm:drm_mode_debug_printmodeline], Modeline 54:"1024x768" 0 26886 1024 1025 1088 1120 768 769 800 801 0x0 0x0
[   28.465396] [drm:drm_crtc_helper_set_config], encoder changed, full mode switch
[   28.465401] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   28.465405] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[   28.465409] [drm:drm_crtc_helper_set_config], [CONNECTOR:14:SVIDEO-1] to [CRTC:4]
[   28.465414] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[   28.465418] [drm:drm_mode_debug_printmodeline], Modeline 54:"1024x768" 0 26886 1024 1025 1088 1120 768 769 800 801 0x0 0x0
[   28.465427] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[   28.465435] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   28.475594] [drm:intel_update_watermarks], plane A (pipe 0) clock: 65000
[   28.475598] [drm:i965_update_wm], self-refresh watermark: display plane 448 cursor 32
[   28.475603] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 448
[   28.475856] [drm:intel_crtc_mode_set], Mode for pipe B:
[   28.475860] [drm:drm_mode_debug_printmodeline], Modeline 54:"1024x768" 0 26886 1024 1025 1088 1120 768 769 800 801 0x0 0x0
[   28.476322] [drm:intel_pipe_set_base], Writing base 00D00000 00000000 0 0 4096
[   28.476328] [drm:intel_update_fbc], 
[   28.476331] [drm:intel_update_fbc], 2 pipes active
[   28.476335] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   28.476340] [drm:intel_update_fbc], unsupported config, disabling FBC
[   28.476345] [drm:i8xx_disable_fbc], disabled FBC
[   28.527011] [drm:intel_wait_for_vblank], vblank wait timed out
[   28.527017] [drm:intel_update_watermarks], plane A (pipe 0) clock: 65000
[   28.527021] [drm:i965_update_wm], self-refresh watermark: display plane 448 cursor 32
[   28.527026] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 448
[   28.527031] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set [MODE:54:1024x768]
[   28.578011] [drm:intel_wait_for_vblank], vblank wait timed out
[   28.578032] [drm:intel_update_watermarks], plane A (pipe 0) clock: 65000
[   28.578037] [drm:intel_update_watermarks], plane B (pipe 1) clock: 26886
[   28.578041] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   28.578071] [drm:intel_update_fbc], 
[   28.578074] [drm:intel_update_fbc], 2 pipes active
[   28.578077] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   28.707182] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   29.189787] [drm:intel_crtc_cursor_set], 
[   29.189821] [drm:intel_crtc_cursor_set], 
[   29.690145] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   30.773067] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   31.274191] [drm:intel_crtc_idle_timer], idle timer fired, downclocking
[   31.274288] [drm:intel_crtc_idle_timer], idle timer fired, downclocking
[   33.831922] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   33.831933] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   33.831938] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   33.831946] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   33.831952] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   33.831956] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   33.831980] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   33.831987] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[   33.939629] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[   33.939635] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   33.939643] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   33.939649] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   33.939656] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   33.939663] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   33.939669] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   33.939676] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   33.939682] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   33.939689] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   33.939695] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   33.939702] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   33.939708] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   33.939715] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   33.939721] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   33.939727] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   33.939734] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   33.939740] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   33.939773] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   33.939853] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   33.939860] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   33.990014] [drm:intel_wait_for_vblank], vblank wait timed out
[   34.041011] [drm:intel_wait_for_vblank], vblank wait timed out
[   34.041016] [drm:intel_tv_detect_type], No TV connection detected
[   34.041023] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[   34.041029] [drm:drm_mode_debug_printmodeline], Modeline 51:"848x480" 30 14513 848 849 912 944 480 481 512 513 0x48 0x0
[   34.041035] [drm:drm_mode_prune_invalid], Not using 848x480 mode -3
[   34.041042] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 30 11315 640 641 704 736 480 481 512 513 0x48 0x0
[   34.041048] [drm:drm_mode_prune_invalid], Not using 640x480 mode -3
[   34.041054] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 30 26886 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   34.041060] [drm:drm_mode_prune_invalid], Not using 1024x768 mode -3
[   34.041065] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 30 16998 800 801 864 896 600 601 632 633 0x40 0x0
[   34.041072] [drm:drm_mode_prune_invalid], Not using 800x600 mode -3
[   34.041094] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   34.041101] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   34.049356] EXT4-fs (sda1): re-mounted. Opts: commit=0
[   34.055407] EXT4-fs (sda3): re-mounted. Opts: commit=0
[   34.092013] [drm:intel_wait_for_vblank], vblank wait timed out
[   34.143013] [drm:intel_wait_for_vblank], vblank wait timed out
[   34.143018] [drm:intel_tv_detect_type], No TV connection detected
[   34.143025] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[   34.146524] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   34.146534] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   34.146539] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   34.146547] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   34.146553] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   34.146557] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   34.146574] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   34.146581] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[   34.150170] [drm:i915_driver_irq_handler], pipe b underrun
[   34.259552] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[   34.259558] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   34.259565] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   34.259572] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   34.259579] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   34.259585] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   34.259592] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   34.259598] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   34.259605] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   34.259611] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   34.259618] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   34.259624] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   34.259630] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   34.259637] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   34.259643] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   34.259650] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   34.259656] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   34.259662] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   34.259696] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   34.260768] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   34.260777] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   34.311014] [drm:intel_wait_for_vblank], vblank wait timed out
[   34.362018] [drm:intel_wait_for_vblank], vblank wait timed out
[   34.362024] [drm:intel_tv_detect_type], No TV connection detected
[   34.362031] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[   34.362058] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   34.362066] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   34.413020] [drm:intel_wait_for_vblank], vblank wait timed out
[   34.464028] [drm:intel_wait_for_vblank], vblank wait timed out
[   34.464033] [drm:intel_tv_detect_type], No TV connection detected
[   34.464040] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[   34.502670] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   34.502680] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   34.502686] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   34.502694] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   34.502700] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   34.502704] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   34.502724] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   34.502731] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[   34.626815] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[   34.626821] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   34.626828] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   34.626835] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   34.626842] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   34.626848] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   34.626855] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   34.626862] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   34.626868] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   34.626874] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   34.626881] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   34.626887] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   34.626894] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   34.626900] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   34.626907] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   34.626913] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   34.626919] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   34.626926] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   34.626960] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   34.627981] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   34.627989] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   34.678011] [drm:intel_wait_for_vblank], vblank wait timed out
[   34.729011] [drm:intel_wait_for_vblank], vblank wait timed out
[   34.729016] [drm:intel_tv_detect_type], No TV connection detected
[   34.729021] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[   34.729038] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   34.729045] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   34.780011] [drm:intel_wait_for_vblank], vblank wait timed out
[   34.831011] [drm:intel_wait_for_vblank], vblank wait timed out
[   34.831016] [drm:intel_tv_detect_type], No TV connection detected
[   34.831021] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[   35.405340] [drm:intel_update_watermarks], plane A (pipe 0) clock: 65000
[   35.405348] [drm:i965_update_wm], self-refresh watermark: display plane 448 cursor 32
[   35.405353] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 448
[   35.405726] [drm:intel_crtc_cursor_set], 
[   35.405731] [drm:intel_crtc_cursor_set], cursor off
[   35.406047] [drm:intel_crtc_cursor_set], 
[   42.740028] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   43.240025] [drm:intel_crtc_idle_timer], idle timer fired, downclocking
[   43.240037] [drm:intel_crtc_idle_timer], idle timer fired, downclocking
[   43.592046] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   43.799895] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   43.799906] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   43.799911] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   43.799919] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   43.799925] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   43.799930] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   43.799949] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   43.799956] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[   43.920588] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[   43.920594] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   43.920602] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   43.920608] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   43.920615] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   43.920622] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   43.920628] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   43.920635] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   43.920641] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   43.920648] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   43.920654] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   43.920661] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   43.920667] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   43.920674] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   43.920680] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   43.920686] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   43.920693] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   43.920699] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   43.920733] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   43.921713] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   43.921722] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   43.921732] [drm:intel_tv_detect_type], Detected Component TV connection
[   43.921768] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] probed modes :
[   43.921774] [drm:drm_mode_debug_printmodeline], Modeline 55:"848x480" 60 29027 848 849 912 944 480 481 512 513 0x48 0x0
[   43.921781] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 60 22631 640 641 704 736 480 481 512 513 0x48 0x0
[   43.921788] [drm:drm_mode_debug_printmodeline], Modeline 57:"1920x1080" 60 134493 1920 1921 1984 2016 1080 1081 1112 1113 0x40 0x0
[   43.921796] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x1024" 60 87178 1280 1281 1344 1376 1024 1025 1056 1057 0x40 0x0
[   43.921803] [drm:drm_mode_debug_printmodeline], Modeline 56:"1280x720" 60 62105 1280 1281 1344 1376 720 721 752 753 0x40 0x0
[   43.921810] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 60 53773 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   43.921817] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 60 33996 800 801 864 896 600 601 632 633 0x40 0x0
[   43.921827] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   43.926124] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   43.926133] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   43.926138] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   43.926146] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   43.926152] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   43.926156] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   43.926174] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   43.926181] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[   44.038622] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[   44.038628] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   44.038635] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   44.038642] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   44.038649] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   44.038655] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   44.038662] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   44.038668] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   44.038675] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   44.038681] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   44.038688] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   44.038694] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   44.038701] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   44.038707] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   44.038713] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   44.038720] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   44.038726] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   44.038733] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   44.038756] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   44.039701] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   44.039710] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   44.039720] [drm:intel_tv_detect_type], Detected Component TV connection
[   44.039766] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] probed modes :
[   44.039772] [drm:drm_mode_debug_printmodeline], Modeline 55:"848x480" 60 29027 848 849 912 944 480 481 512 513 0x48 0x0
[   44.039779] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 60 22631 640 641 704 736 480 481 512 513 0x48 0x0
[   44.039786] [drm:drm_mode_debug_printmodeline], Modeline 57:"1920x1080" 60 134493 1920 1921 1984 2016 1080 1081 1112 1113 0x40 0x0
[   44.039793] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x1024" 60 87178 1280 1281 1344 1376 1024 1025 1056 1057 0x40 0x0
[   44.039800] [drm:drm_mode_debug_printmodeline], Modeline 56:"1280x720" 60 62105 1280 1281 1344 1376 720 721 752 753 0x40 0x0
[   44.039807] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 60 53773 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   44.039814] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 60 33996 800 801 864 896 600 601 632 633 0x40 0x0
[   44.039825] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   44.043548] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   44.043557] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   44.043562] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   44.043570] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   44.043576] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   44.043580] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   44.043598] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   44.043604] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[   44.155661] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[   44.155667] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   44.155674] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   44.155680] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   44.155687] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   44.155693] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   44.155700] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   44.155706] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   44.155713] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   44.155719] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   44.155726] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   44.155732] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   44.155739] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   44.155745] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   44.155751] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   44.155758] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   44.155764] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   44.155770] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   44.155794] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   44.156706] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   44.156715] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   44.156725] [drm:intel_tv_detect_type], Detected Component TV connection
[   44.156772] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] probed modes :
[   44.156777] [drm:drm_mode_debug_printmodeline], Modeline 55:"848x480" 60 29027 848 849 912 944 480 481 512 513 0x48 0x0
[   44.156785] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 60 22631 640 641 704 736 480 481 512 513 0x48 0x0
[   44.156792] [drm:drm_mode_debug_printmodeline], Modeline 57:"1920x1080" 60 134493 1920 1921 1984 2016 1080 1081 1112 1113 0x40 0x0
[   44.156799] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x1024" 60 87178 1280 1281 1344 1376 1024 1025 1056 1057 0x40 0x0
[   44.156806] [drm:drm_mode_debug_printmodeline], Modeline 56:"1280x720" 60 62105 1280 1281 1344 1376 720 721 752 753 0x40 0x0
[   44.156813] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 60 53773 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   44.156820] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 60 33996 800 801 864 896 600 601 632 633 0x40 0x0
[   44.156831] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   44.206516] [drm:intel_crtc_cursor_set], 
[   44.206521] [drm:intel_crtc_cursor_set], cursor off
[   44.206687] [drm:drm_mode_addfb], [FB:58]
[   44.206737] [drm:drm_mode_setcrtc], [CRTC:3]
[   44.206747] [drm:drm_mode_setcrtc], [CONNECTOR:12:VGA-1]
[   44.206752] [drm:drm_crtc_helper_set_config], 
[   44.206755] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:58] #connectors=1 (x y) (0 0)
[   44.206767] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   44.206772] [drm:drm_crtc_helper_set_config], [CONNECTOR:14:SVIDEO-1] to [CRTC:4]
[   44.214757] [drm:intel_pipe_set_base], Writing base 01EAF000 00000000 0 0 5120
[   44.214764] [drm:intel_update_fbc], 
[   44.214768] [drm:intel_update_fbc], 2 pipes active
[   44.214772] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   44.214843] [drm:drm_crtc_helper_set_config], 
[   44.214847] [drm:drm_crtc_helper_set_config], [CRTC:4] [NOFB] #connectors=0 (x y) (0 0)
[   44.214857] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   44.214861] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[   44.214866] [drm:drm_crtc_helper_set_config], [CONNECTOR:14:SVIDEO-1] to [NOCRTC]
[   44.214877] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   44.225035] [drm:intel_update_watermarks], plane A (pipe 0) clock: 65000
[   44.225040] [drm:i965_update_wm], self-refresh watermark: display plane 448 cursor 32
[   44.225044] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 448
[   44.225319] [drm:intel_crtc_cursor_set], 
[   44.228065] [drm:drm_mode_setcrtc], [CRTC:3]
[   44.228078] [drm:drm_mode_setcrtc], [CONNECTOR:12:VGA-1]
[   44.228083] [drm:drm_crtc_helper_set_config], 
[   44.228086] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:58] #connectors=1 (x y) (0 0)
[   44.228096] [drm:drm_crtc_helper_set_config], modes are different, full mode set
[   44.228100] [drm:drm_mode_debug_printmodeline], Modeline 53:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x0 0xa
[   44.228107] [drm:drm_mode_debug_printmodeline], Modeline 52:"" 0 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x0 0x5
[   44.228116] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   44.228121] [drm:drm_crtc_helper_set_config], [CONNECTOR:14:SVIDEO-1] to [NOCRTC]
[   44.228125] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[   44.228129] [drm:drm_mode_debug_printmodeline], Modeline 52:"" 0 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x0 0x5
[   44.228138] [drm:drm_crtc_helper_set_mode], [CRTC:3]
[   44.338560] [drm:intel_crtc_mode_set], Mode for pipe A:
[   44.338565] [drm:drm_mode_debug_printmodeline], Modeline 52:"" 0 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x0 0x5
[   44.390011] [drm:intel_wait_for_vblank], vblank wait timed out
[   44.393397] [drm:intel_pipe_set_base], Writing base 01EAF000 00000000 0 0 5120
[   44.393403] [drm:intel_update_fbc], 
[   44.393407] [drm:intel_update_fbc], 1 pipes active
[   44.393422] [drm:i8xx_enable_fbc], enabled FBC, pitch 71, yoff 0, plane 0, 
[   44.444026] [drm:intel_wait_for_vblank], vblank wait timed out
[   44.444034] [drm:drm_crtc_helper_set_mode], [ENCODER:13:DAC-13] set [MODE:52:]
[   44.444039] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   44.444044] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   44.444049] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   44.444078] [drm:intel_update_fbc], 
[   44.444081] [drm:intel_update_fbc], 1 pipes active
[   44.444086] [drm:i8xx_disable_fbc], disabled FBC
[   44.444100] [drm:i8xx_enable_fbc], enabled FBC, pitch 71, yoff 0, plane 0, 
[   44.444115] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   44.454272] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   44.454277] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   44.454282] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   46.162019] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   47.684496] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   47.684507] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   47.684512] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   47.684520] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   47.684526] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   47.684530] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   47.684551] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   47.684558] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[   47.797670] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[   47.797676] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   47.797683] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   47.797690] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   47.797697] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   47.797703] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   47.797710] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   47.797716] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   47.797723] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   47.797729] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   47.797736] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   47.797742] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   47.797748] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   47.797755] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   47.797761] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   47.797768] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   47.797774] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   47.797781] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   47.797819] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   47.798822] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   47.798830] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   47.798843] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[   47.798855] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   47.809016] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   47.809022] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   47.809027] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   47.809273] [drm:intel_crtc_mode_set], Mode for pipe B:
[   47.809278] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   47.809738] [drm:intel_pipe_set_base], No FB bound
[   47.809742] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   47.809747] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   47.809752] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   47.809758] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set [MODE:0:NTSC 480i]
[   47.860013] [drm:intel_wait_for_vblank], vblank wait timed out
[   47.860037] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   47.860042] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   47.860047] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   47.860077] [drm:intel_update_fbc], 
[   47.911012] [drm:intel_wait_for_vblank], vblank wait timed out
[   47.962012] [drm:intel_wait_for_vblank], vblank wait timed out
[   48.013011] [drm:intel_wait_for_vblank], vblank wait timed out
[   48.013015] [drm:intel_tv_detect_type], No TV connection detected
[   48.055024] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   48.133220] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   48.133227] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   48.133232] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   48.133238] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[   48.133244] [drm:drm_mode_debug_printmodeline], Modeline 55:"848x480" 60 29027 848 849 912 944 480 481 512 513 0x48 0x0
[   48.133251] [drm:drm_mode_prune_invalid], Not using 848x480 mode -3
[   48.133257] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 60 22631 640 641 704 736 480 481 512 513 0x48 0x0
[   48.133264] [drm:drm_mode_prune_invalid], Not using 640x480 mode -3
[   48.133269] [drm:drm_mode_debug_printmodeline], Modeline 57:"1920x1080" 60 134493 1920 1921 1984 2016 1080 1081 1112 1113 0x40 0x0
[   48.133276] [drm:drm_mode_prune_invalid], Not using 1920x1080 mode -3
[   48.133281] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x1024" 60 87178 1280 1281 1344 1376 1024 1025 1056 1057 0x40 0x0
[   48.133287] [drm:drm_mode_prune_invalid], Not using 1280x1024 mode -3
[   48.133293] [drm:drm_mode_debug_printmodeline], Modeline 56:"1280x720" 60 62105 1280 1281 1344 1376 720 721 752 753 0x40 0x0
[   48.133299] [drm:drm_mode_prune_invalid], Not using 1280x720 mode -3
[   48.133304] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 60 53773 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   48.133311] [drm:drm_mode_prune_invalid], Not using 1024x768 mode -3
[   48.133316] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 60 33996 800 801 864 896 600 601 632 633 0x40 0x0
[   48.133322] [drm:drm_mode_prune_invalid], Not using 800x600 mode -3
[   48.133350] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   48.133357] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   48.133370] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[   48.133380] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   48.143539] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   48.143544] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   48.143548] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   48.143794] [drm:intel_crtc_mode_set], Mode for pipe B:
[   48.143798] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   48.144259] [drm:intel_pipe_set_base], No FB bound
[   48.144264] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   48.144269] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   48.144274] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   48.144280] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set [MODE:0:NTSC 480i]
[   48.154520] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   48.154525] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   48.154530] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   48.154560] [drm:intel_update_fbc], 
[   48.154572] [drm:intel_tv_detect_type], Detected S-Video TV connection
[   48.274794] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   48.274800] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   48.274805] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   48.274834] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] probed modes :
[   48.274839] [drm:drm_mode_debug_printmodeline], Modeline 51:"848x480" 30 14513 848 849 912 944 480 481 512 513 0x48 0x0
[   48.274846] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 30 11315 640 641 704 736 480 481 512 513 0x48 0x0
[   48.274852] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 30 26886 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   48.274859] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 30 16998 800 801 864 896 600 601 632 633 0x40 0x0
[   48.274895] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   48.274901] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   48.274910] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[   48.274921] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   48.285084] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   48.285091] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   48.285095] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   48.285343] [drm:intel_crtc_mode_set], Mode for pipe B:
[   48.285348] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   48.285808] [drm:intel_pipe_set_base], No FB bound
[   48.285812] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   48.285816] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   48.285822] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   48.285828] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set [MODE:0:NTSC 480i]
[   48.287810] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   48.287815] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   48.287819] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   48.287849] [drm:intel_update_fbc], 
[   48.287861] [drm:intel_tv_detect_type], Detected Composite TV connection
[   48.398057] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   48.398062] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   48.398067] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   48.398097] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] probed modes :
[   48.398102] [drm:drm_mode_debug_printmodeline], Modeline 51:"848x480" 30 14513 848 849 912 944 480 481 512 513 0x48 0x0
[   48.398109] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 30 11315 640 641 704 736 480 481 512 513 0x48 0x0
[   48.398115] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 30 26886 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   48.398122] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 30 16998 800 801 864 896 600 601 632 633 0x40 0x0
[   48.398148] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   48.420277] [drm:intel_crtc_cursor_set], 
[   48.420283] [drm:intel_crtc_cursor_set], cursor off
[   48.423070] [drm:drm_mode_addfb], [FB:55]
[   48.423120] [drm:drm_mode_setcrtc], [CRTC:3]
[   48.423130] [drm:drm_mode_setcrtc], [CONNECTOR:12:VGA-1]
[   48.423135] [drm:drm_crtc_helper_set_config], 
[   48.423138] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:55] #connectors=1 (x y) (0 0)
[   48.423150] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   48.439751] [drm:intel_pipe_set_base], Writing base 043AF000 00000000 0 0 8704
[   48.439759] [drm:intel_update_fbc], 
[   48.439763] [drm:intel_update_fbc], 1 pipes active
[   48.439767] [drm:intel_update_fbc], framebuffer too large, disabling compression
[   48.439771] [drm:intel_update_fbc], unsupported config, disabling FBC
[   48.439776] [drm:i8xx_disable_fbc], disabled FBC
[   48.490013] [drm:intel_wait_for_vblank], vblank wait timed out
[   48.495596] [drm:intel_crtc_cursor_set], 
[   48.496598] [drm:drm_mode_setcrtc], [CRTC:4]
[   48.496612] [drm:drm_mode_setcrtc], [CONNECTOR:14:SVIDEO-1]
[   48.496617] [drm:drm_crtc_helper_set_config], 
[   48.496620] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:55] #connectors=1 (x y) (1280 0)
[   48.496630] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[   48.496635] [drm:drm_crtc_helper_set_config], modes are different, full mode set
[   48.496639] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   48.496646] [drm:drm_mode_debug_printmodeline], Modeline 57:"" 0 14513 848 849 912 944 480 481 512 513 0x0 0x0
[   48.496653] [drm:drm_crtc_helper_set_config], encoder changed, full mode switch
[   48.496658] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   48.496662] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[   48.496667] [drm:drm_crtc_helper_set_config], [CONNECTOR:14:SVIDEO-1] to [CRTC:4]
[   48.496671] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[   48.496675] [drm:drm_mode_debug_printmodeline], Modeline 57:"" 0 14513 848 849 912 944 480 481 512 513 0x0 0x0
[   48.496684] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[   48.496695] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   48.506854] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   48.506860] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   48.506864] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   48.507136] [drm:intel_crtc_mode_set], Mode for pipe B:
[   48.507140] [drm:drm_mode_debug_printmodeline], Modeline 57:"" 0 14513 848 849 912 944 480 481 512 513 0x0 0x0
[   48.507602] [drm:intel_pipe_set_base], Writing base 043AF000 00001400 1280 0 8704
[   48.507608] [drm:intel_update_fbc], 
[   48.507611] [drm:intel_update_fbc], 2 pipes active
[   48.507615] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   48.521053] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   48.521058] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   48.521063] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   48.521069] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set [MODE:57:]
[   48.537730] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   48.537735] [drm:intel_update_watermarks], plane B (pipe 1) clock: 14513
[   48.537740] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   48.537769] [drm:intel_update_fbc], 
[   48.537773] [drm:intel_update_fbc], 2 pipes active
[   48.537776] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   48.537825] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   48.537830] [drm:intel_update_watermarks], plane B (pipe 1) clock: 14513
[   48.537834] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   48.537864] [drm:intel_update_fbc], 
[   48.537867] [drm:intel_update_fbc], 2 pipes active
[   48.537870] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   48.537985] [drm:intel_crtc_cursor_set], 
[   48.537988] [drm:intel_crtc_cursor_set], cursor off
[   53.472178] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   54.354178] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   55.342182] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   56.342177] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   62.426171] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   64.342178] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   65.455176] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   70.431177] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   70.990294] [drm:intel_crtc_cursor_set], 
[   70.990300] [drm:intel_crtc_cursor_set], cursor off
[   70.998550] [drm:intel_crtc_cursor_set], 
[   75.344179] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   76.343180] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   77.633101] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   78.654720] [drm:intel_crtc_cursor_set], 
[   78.654725] [drm:intel_crtc_cursor_set], cursor off
[   80.544178] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   81.466168] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   82.144973] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   82.144984] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   82.144989] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   82.144997] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   82.145026] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   82.145031] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   82.145052] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   82.145058] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[   82.267641] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[   82.267647] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   82.267654] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   82.267661] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   82.267667] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   82.267674] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   82.267680] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   82.267687] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   82.267694] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   82.267700] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   82.267707] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   82.267713] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   82.267720] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   82.267726] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   82.267733] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   82.267739] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   82.267745] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   82.267752] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   82.267801] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   82.268844] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   82.268852] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   82.319011] [drm:intel_wait_for_vblank], vblank wait timed out
[   82.370011] [drm:intel_wait_for_vblank], vblank wait timed out
[   82.370015] [drm:intel_tv_detect_type], No TV connection detected
[   82.370021] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[   82.370026] [drm:drm_mode_debug_printmodeline], Modeline 51:"848x480" 30 14513 848 849 912 944 480 481 512 513 0x48 0x0
[   82.370032] [drm:drm_mode_prune_invalid], Not using 848x480 mode -3
[   82.370038] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 30 11315 640 641 704 736 480 481 512 513 0x48 0x0
[   82.370045] [drm:drm_mode_prune_invalid], Not using 640x480 mode -3
[   82.370050] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 30 26886 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   82.370057] [drm:drm_mode_prune_invalid], Not using 1024x768 mode -3
[   82.370062] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 30 16998 800 801 864 896 600 601 632 633 0x40 0x0
[   82.370068] [drm:drm_mode_prune_invalid], Not using 800x600 mode -3
[   82.370085] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   82.370091] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   82.421011] [drm:intel_wait_for_vblank], vblank wait timed out
[   82.472011] [drm:intel_wait_for_vblank], vblank wait timed out
[   82.472015] [drm:intel_tv_detect_type], No TV connection detected
[   82.472021] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[   82.596138] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   82.596145] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   82.596150] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   82.667520] [drm:drm_mode_addfb], [FB:48]
[   82.667570] [drm:drm_mode_setcrtc], [CRTC:3]
[   82.667580] [drm:drm_mode_setcrtc], [CONNECTOR:12:VGA-1]
[   82.667584] [drm:drm_crtc_helper_set_config], 
[   82.667588] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:48] #connectors=1 (x y) (0 0)
[   82.667599] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   82.667605] [drm:drm_crtc_helper_set_config], [CONNECTOR:14:SVIDEO-1] to [CRTC:4]
[   82.675919] [drm:intel_pipe_set_base], Writing base 09791000 00000000 0 0 5120
[   82.675926] [drm:intel_update_fbc], 
[   82.675930] [drm:intel_update_fbc], 2 pipes active
[   82.675934] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   82.726012] [drm:intel_wait_for_vblank], vblank wait timed out
[   82.726074] [drm:drm_crtc_helper_set_config], 
[   82.726078] [drm:drm_crtc_helper_set_config], [CRTC:4] [NOFB] #connectors=0 (x y) (0 0)
[   82.726087] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   82.726092] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[   82.726096] [drm:drm_crtc_helper_set_config], [CONNECTOR:14:SVIDEO-1] to [NOCRTC]
[   82.726107] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   82.736266] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   82.736272] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   82.736276] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   83.132039] [drm:intel_crtc_idle_timer], idle timer fired, downclocking
[   84.457175] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   86.341173] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   87.462176] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   89.341174] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   89.430433] [drm:intel_crtc_cursor_set], 
[   91.341087] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   92.342177] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   93.342583] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   95.340179] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   96.467167] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  100.342109] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  101.344180] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  102.344178] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  103.341174] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  104.341173] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  109.378176] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  112.383173] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  115.387177] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  118.392180] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  121.397178] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  124.401175] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  126.355173] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  127.342137] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  131.340079] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  132.493036] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  139.507060] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  143.340047] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  195.342134] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  198.523170] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  205.341048] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  228.547178] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  237.521171] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  238.341179] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  248.434050] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  252.341171] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  257.343073] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  259.341066] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  260.507057] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  261.708041] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  262.367069] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  263.510019] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  265.340019] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  266.513065] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  268.394066] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  271.397070] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  274.401068] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  277.403064] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  280.406059] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  283.409073] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  286.425179] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  289.343173] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  295.414056] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  296.499176] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  301.414172] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  303.344175] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  343.339047] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  347.374407] [drm:intel_crtc_cursor_set], 
[  347.374412] [drm:intel_crtc_cursor_set], cursor off
[  347.374483] [drm:intel_crtc_cursor_set], 
[  407.478178] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  409.548167] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  420.340169] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  422.438177] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  425.468167] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  437.396174] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  440.344170] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  441.511165] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  443.342133] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  444.513165] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  446.342169] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  447.516173] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  449.345065] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  452.460081] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  455.431178] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  458.436174] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  461.441178] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  463.342076] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  464.446177] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  466.343170] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  467.451179] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  469.343181] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  470.456146] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  472.342174] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  472.844425] [drm:intel_crtc_cursor_set], 
[  472.844436] [drm:intel_crtc_cursor_set], cursor off
[  472.844583] [drm:intel_crtc_cursor_set], 
[  474.343173] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  475.347181] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  478.342176] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  481.344176] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  482.492174] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  484.344173] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  487.342181] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  490.344171] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  491.504168] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  493.342177] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  494.509165] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  495.389174] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  496.342180] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  497.574040] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  504.405178] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  507.517166] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  509.379173] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  511.493169] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  513.498170] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  520.494177] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  524.423042] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  531.342042] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  532.445173] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  535.511172] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  536.400168] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  538.344173] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  543.363173] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  546.368172] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  547.677590] [drm:intel_crtc_cursor_set], 
[  547.677602] [drm:intel_crtc_cursor_set], cursor off
[  547.677746] [drm:intel_crtc_cursor_set], 
[  555.372144] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  561.371174] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  564.372180] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  567.465182] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  573.386169] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  581.525170] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  587.451166] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  590.343174] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  595.463176] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  597.340179] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  598.467176] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  606.402181] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  612.344175] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  620.341049] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  633.349110] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  634.550179] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  648.420177] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  654.343171] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  660.410173] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  661.343166] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  665.342175] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  668.433179] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  670.535171] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[  674.531171] [drm:intel_gpu_idle_timer], idle timer fired, downclocking

--=-iyRcT9vbBIlGh+yHTu+A--

