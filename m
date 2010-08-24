Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab0HXVJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 17:09:31 -0400
Received: from mailout-us.gmx.com ([74.208.5.67]:56246 "HELO
	mailout-us.gmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755437Ab0HXVJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 17:09:05 -0400
X-Authenticated: #65048216
X-Provags-ID: V01U2FsdGVkX1/WB2k7yLnWX1ITtyF5LMqGlq5SJZtZj6q1H83tNM
	9dnaWKPAwiQfYf
Subject: Re: [PATCH] drm/i915/tv: After disabling the pipe, use
 wait_for_vblank_off()
From: Ivan Bulatovic <combuster@gmx.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-gfx@lists.freedesktop.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <1282662712-20493-1-git-send-email-chris@chris-wilson.co.uk>
References: <1282647815.2221.15.camel@localhost.localdomain>
	 <1282662712-20493-1-git-send-email-chris@chris-wilson.co.uk>
Content-Type: multipart/mixed; boundary="=-gzrXJ7R4q/csrWnn9wGU"
Date: Tue, 24 Aug 2010 23:08:50 +0200
Message-ID: <1282684130.2199.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gzrXJ7R4q/csrWnn9wGU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Tue, 2010-08-24 at 16:11 +0100, Chris Wilson wrote: 
> Hopefully this is a contributing factor to the spurious TV detection
> repoted by Ivan Bulatovic and others.
> 
> References:
> 
>   Bug 16871 - "TV1 connected" with no tv
>   https://bugzilla.kernel.org/show_bug.cgi?id=16871
> 
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Reported-by: Ivan Bulatovic <combuster@gmx.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> ---
>  drivers/gpu/drm/i915/intel_tv.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
> index f70bc76..f96289d 100644
> --- a/drivers/gpu/drm/i915/intel_tv.c
> +++ b/drivers/gpu/drm/i915/intel_tv.c
> @@ -1171,7 +1171,7 @@ intel_tv_mode_set(struct drm_encoder *encoder, struct drm_display_mode *mode,
>  		I915_WRITE(pipeconf_reg, pipeconf & ~PIPEACONF_ENABLE);
>  		POSTING_READ(pipeconf_reg);
>  		/* Wait for vblank for the disable to take effect. */
> -		intel_wait_for_vblank(dev, intel_crtc->pipe);
> +		intel_wait_for_vblank_off(dev, intel_crtc->pipe);
>  
>  		/* Filter ctl must be set before TV_WIN_SIZE */
>  		I915_WRITE(TV_FILTER_CTL_1, TV_AUTO_SCALE);

Unfotunately I still get TV connection detected :(

--=-gzrXJ7R4q/csrWnn9wGU
Content-Disposition: attachment; filename="dmesg.log"
Content-Type: text/x-log; name="dmesg.log"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.36-rc2-RC+ (root@vostro) (gcc version 4.5.1 (GCC) ) #3 SMP PREEMPT Tue Aug 24 22:43:34 CEST 2010
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
[    0.000000] Memory: 2040704k/2087744k available (3782k kernel code, 452k absent, 46588k reserved, 2897k data, 548k init)
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
[    0.000000] Detected 1795.493 MHz processor.
[    0.001015] Calibrating delay loop (skipped), value calculated using timer frequency.. 3590.98 BogoMIPS (lpj=1795493)
[    0.002006] pid_max: default: 32768 minimum: 301
[    0.002191] Security Framework initialized
[    0.002312] Smack:  Initializing.
[    0.002747] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004245] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.005026] Mount-cache hash table entries: 256
[    0.006350] Initializing cgroup subsys ns
[    0.006470] Initializing cgroup subsys cpuacct
[    0.006593] Initializing cgroup subsys freezer
[    0.006794] CPU: Physical Processor ID: 0
[    0.006914] CPU: Processor Core ID: 0
[    0.007006] mce: CPU supports 6 MCE banks
[    0.007130] CPU0: Thermal monitoring handled by SMI
[    0.007136] using mwait in idle threads.
[    0.007253] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.007502] PEBS disabled due to CPU errata.
[    0.007630] ... version:                2
[    0.007747] ... bit width:              40
[    0.007863] ... generic registers:      2
[    0.008005] ... value mask:             000000ffffffffff
[    0.008125] ... max period:             000000007fffffff
[    0.008244] ... fixed-purpose events:   3
[    0.008361] ... event mask:             0000000700000003
[    0.008607] ACPI: Core revision 20100702
[    0.027215] Setting APIC routing to flat
[    0.028371] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.038504] CPU0: Intel(R) Core(TM)2 Duo CPU     T5670  @ 1.80GHz stepping 0d
[    0.040426] NMI watchdog enabled, takes one hw-pmu counter.
[    0.042053] lockdep: fixing up alternatives.
[    0.043195] Booting Node   0, Processors  #1 Ok.
[    0.001999] CPU1: Thermal monitoring handled by SMI
[    0.115122] NMI watchdog enabled, takes one hw-pmu counter.
[    0.116013] Brought up 2 CPUs
[    0.116129] Total of 2 processors activated (7181.80 BogoMIPS).
[    0.117252] devtmpfs: initialized
[    0.118298] NET: Registered protocol family 16
[    0.119398] ACPI: bus type pci registered
[    0.119704] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.119898] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.175983] PCI: Using configuration type 1 for base access
[    0.177722] bio: create slab <bio-0> at 0
[    0.185730] ACPI: EC: Look up EC in DSDT
[    0.198055] ACPI: BIOS _OSI(Linux) query ignored
[    0.199752] ACPI: SSDT 000000007f6d7761 00238 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.201933] ACPI: Dynamic OEM Table Load:
[    0.202115] ACPI: SSDT (null) 00238 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.202761] ACPI: SSDT 000000007f6d70f2 005EA (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.204936] ACPI: Dynamic OEM Table Load:
[    0.205112] ACPI: SSDT (null) 005EA (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.205945] ACPI: SSDT 000000007f6d7999 000C8 (v01  PmRef  Cpu1Ist 00003000 INTL 20061109)
[    0.208144] ACPI: Dynamic OEM Table Load:
[    0.208344] ACPI: SSDT (null) 000C8 (v01  PmRef  Cpu1Ist 00003000 INTL 20061109)
[    0.208827] ACPI: SSDT 000000007f6d76dc 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20061109)
[    0.210981] ACPI: Dynamic OEM Table Load:
[    0.211158] ACPI: SSDT (null) 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20061109)
[    0.212117] ACPI: Interpreter enabled
[    0.212236] ACPI: (supports S0 S3 S4 S5)
[    0.212581] ACPI: Using IOAPIC for interrupt routing
[    0.296350] ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
[    0.297241] ACPI: No dock devices found.
[    0.297360] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.298594] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.300864] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.300986] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.301006] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.301197] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff]
[    0.301390] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    0.301578] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    0.301769] pci_root PNP0A08:00: host bridge window [mem 0x80000000-0xdfffffff]
[    0.302005] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfebfffff]
[    0.302409] pci 0000:00:02.0: reg 10: [mem 0xf8000000-0xf80fffff 64bit]
[    0.302427] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.302440] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.302552] pci 0000:00:02.1: reg 10: [mem 0xf8100000-0xf81fffff 64bit]
[    0.302802] pci 0000:00:1a.0: reg 20: [io  0x1820-0x183f]
[    0.303026] pci 0000:00:1a.1: reg 20: [io  0x1840-0x185f]
[    0.303147] pci 0000:00:1a.7: reg 10: [mem 0xf8504800-0xf8504bff]
[    0.303290] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.303298] pci 0000:00:1a.7: PME# disabled
[    0.303371] pci 0000:00:1b.0: reg 10: [mem 0xf8500000-0xf8503fff 64bit]
[    0.303493] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.303501] pci 0000:00:1b.0: PME# disabled
[    0.303659] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.303667] pci 0000:00:1c.0: PME# disabled
[    0.303840] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.303848] pci 0000:00:1c.1: PME# disabled
[    0.304030] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.304038] pci 0000:00:1c.3: PME# disabled
[    0.304208] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.304216] pci 0000:00:1c.4: PME# disabled
[    0.304352] pci 0000:00:1d.0: reg 20: [io  0x1860-0x187f]
[    0.304507] pci 0000:00:1d.1: reg 20: [io  0x1880-0x189f]
[    0.304653] pci 0000:00:1d.2: reg 20: [io  0x18a0-0x18bf]
[    0.304771] pci 0000:00:1d.7: reg 10: [mem 0xf8504c00-0xf8504fff]
[    0.304913] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.304921] pci 0000:00:1d.7: PME# disabled
[    0.305241] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
[    0.305432] pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
[    0.305558] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
[    0.305751] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 1640 (mask 007f)
[    0.306030] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    0.306049] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    0.306068] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
[    0.306087] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
[    0.306106] pci 0000:00:1f.1: reg 20: [io  0x1810-0x181f]
[    0.306223] pci 0000:00:1f.2: reg 10: [io  0x1c00-0x1c07]
[    0.306240] pci 0000:00:1f.2: reg 14: [io  0x18d4-0x18d7]
[    0.306258] pci 0000:00:1f.2: reg 18: [io  0x18d8-0x18df]
[    0.306275] pci 0000:00:1f.2: reg 1c: [io  0x18d0-0x18d3]
[    0.306291] pci 0000:00:1f.2: reg 20: [io  0x18e0-0x18ff]
[    0.306309] pci 0000:00:1f.2: reg 24: [mem 0xf8504000-0xf85047ff]
[    0.306379] pci 0000:00:1f.2: PME# supported from D3hot
[    0.306386] pci 0000:00:1f.2: PME# disabled
[    0.306439] pci 0000:00:1f.3: reg 10: [mem 0x00000000-0x000000ff]
[    0.306499] pci 0000:00:1f.3: reg 20: [io  0x1c20-0x1c3f]
[    0.306643] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.306766] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.306774] pci 0000:00:1c.0:   bridge window [mem 0xc4000000-0xc7ffffff]
[    0.306787] pci 0000:00:1c.0:   bridge window [mem 0xcc000000-0xcdffffff 64bit pref]
[    0.306882] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.307009] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.307017] pci 0000:00:1c.1:   bridge window [mem 0xf0000000-0xf3ffffff]
[    0.307030] pci 0000:00:1c.1:   bridge window [mem 0xfa000000-0xfbffffff 64bit pref]
[    0.307287] pci 0000:06:00.0: reg 10: [mem 0xf4000000-0xf4000fff]
[    0.307677] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    0.307692] pci 0000:06:00.0: PME# disabled
[    0.307759] pci 0000:06:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.308113] pci 0000:00:1c.3: PCI bridge to [bus 06-06]
[    0.308236] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.308244] pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf7ffffff]
[    0.308255] pci 0000:00:1c.3:   bridge window [mem 0xfc000000-0xfdffffff 64bit pref]
[    0.308488] pci 0000:07:00.0: reg 10: [io  0x5000-0x50ff]
[    0.308617] pci 0000:07:00.0: reg 18: [mem 0xf8610000-0xf8610fff 64bit pref]
[    0.308696] pci 0000:07:00.0: reg 20: [mem 0xf8600000-0xf860ffff 64bit pref]
[    0.308748] pci 0000:07:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.308928] pci 0000:07:00.0: supports D1 D2
[    0.308931] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.308949] pci 0000:07:00.0: PME# disabled
[    0.309139] pci 0000:00:1c.4: PCI bridge to [bus 07-07]
[    0.309263] pci 0000:00:1c.4:   bridge window [io  0x5000-0x5fff]
[    0.309271] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.309283] pci 0000:00:1c.4:   bridge window [mem 0xf8600000-0xf86fffff 64bit pref]
[    0.309398] pci 0000:08:05.0: reg 10: [mem 0xf8200000-0xf8200fff]
[    0.309417] pci 0000:08:05.0: reg 14: [mem 0xf8202000-0xf82027ff]
[    0.309535] pci 0000:08:05.0: supports D1 D2
[    0.309538] pci 0000:08:05.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.309546] pci 0000:08:05.0: PME# disabled
[    0.309616] pci 0000:08:05.2: reg 10: [mem 0xf8202800-0xf82028ff]
[    0.309756] pci 0000:08:05.2: supports D1 D2
[    0.309759] pci 0000:08:05.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.309767] pci 0000:08:05.2: PME# disabled
[    0.309837] pci 0000:08:05.3: reg 10: [mem 0xf8201000-0xf8201fff]
[    0.309981] pci 0000:08:05.3: supports D1 D2
[    0.309985] pci 0000:08:05.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.310004] pci 0000:08:05.3: PME# disabled
[    0.310098] pci 0000:00:1e.0: PCI bridge to [bus 08-08] (subtractive decode)
[    0.310226] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.310234] pci 0000:00:1e.0:   bridge window [mem 0xf8200000-0xf82fffff]
[    0.310247] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.310252] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.310256] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.310260] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.310264] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
[    0.310268] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.310272] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.310276] pci 0000:00:1e.0:   bridge window [mem 0x80000000-0xdfffffff] (subtractive decode)
[    0.310281] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
[    0.310332] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.310995] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.311149] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.311309] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    0.311458] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    0.311709] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.311883] Unable to assume PCIe control: Disabling ASPM
[    0.334632] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 *5 6 7 10 12 14 15)
[    0.335365] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.336133] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.336872] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.337610] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.338518] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.339241] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.340025] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.341307] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.341552] vgaarb: loaded
[    0.341807] usbcore: registered new interface driver usbfs
[    0.341968] usbcore: registered new interface driver hub
[    0.342039] usbcore: registered new device driver usb
[    0.342182] PCI: Using ACPI for IRQ routing
[    0.342233] PCI: pci_cache_line_size set to 64 bytes
[    0.342503] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
[    0.342508] reserve RAM buffer: 000000007f6d0000 - 000000007fffffff 
[    0.343706] cfg80211: Calling CRDA to update world regulatory domain
[    0.344201] NetLabel: Initializing
[    0.344318] NetLabel:  domain hash size = 128
[    0.344436] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.344632] NetLabel:  unlabeled traffic allowed by default
[    0.344912] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.345198] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.348065] Switching to clocksource tsc
[    0.355625] pnp: PnP ACPI init
[    0.355792] ACPI: bus type pnp registered
[    0.386759] pnp: PnP ACPI: found 10 devices
[    0.386877] ACPI: ACPI bus type pnp unregistered
[    0.387028] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.387152] system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
[    0.387274] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.387405] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.387527] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.387649] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.387770] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.387891] system 00:01: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.388025] system 00:04: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.388159] system 00:06: [io  0x0680-0x069f] has been reserved
[    0.388280] system 00:06: [io  0x0800-0x080f] has been reserved
[    0.388408] system 00:06: [io  0x1000-0x107f] has been reserved
[    0.388529] system 00:06: [io  0x1180-0x11bf] has been reserved
[    0.388649] system 00:06: [io  0xfe00] has been reserved
[    0.388768] system 00:06: [io  0xff00-0xff7f] has been reserved
[    0.398337] pci 0000:00:1c.4: BAR 8: assigned [mem 0x80000000-0x803fffff]
[    0.398464] pci 0000:00:1f.3: BAR 0: assigned [mem 0x80400000-0x804000ff]
[    0.398591] pci 0000:00:1f.3: BAR 0: set to [mem 0x80400000-0x804000ff] (PCI address [0x80400000-0x804000ff]
[    0.398788] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.398908] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.399033] pci 0000:00:1c.0:   bridge window [mem 0xc4000000-0xc7ffffff]
[    0.399160] pci 0000:00:1c.0:   bridge window [mem 0xcc000000-0xcdffffff 64bit pref]
[    0.399371] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.399491] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.399620] pci 0000:00:1c.1:   bridge window [mem 0xf0000000-0xf3ffffff]
[    0.399748] pci 0000:00:1c.1:   bridge window [mem 0xfa000000-0xfbffffff 64bit pref]
[    0.399947] pci 0000:00:1c.3: PCI bridge to [bus 06-06]
[    0.400071] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.400197] pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf7ffffff]
[    0.400334] pci 0000:00:1c.3:   bridge window [mem 0xfc000000-0xfdffffff 64bit pref]
[    0.400536] pci 0000:07:00.0: BAR 6: assigned [mem 0xf8620000-0xf862ffff pref]
[    0.400734] pci 0000:00:1c.4: PCI bridge to [bus 07-07]
[    0.400855] pci 0000:00:1c.4:   bridge window [io  0x5000-0x5fff]
[    0.400982] pci 0000:00:1c.4:   bridge window [mem 0x80000000-0x803fffff]
[    0.401111] pci 0000:00:1c.4:   bridge window [mem 0xf8600000-0xf86fffff 64bit pref]
[    0.401318] pci 0000:00:1e.0: PCI bridge to [bus 08-08]
[    0.401438] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.403493] pci 0000:00:1e.0:   bridge window [mem 0xf8200000-0xf82fffff]
[    0.403617] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.403774]   alloc irq_desc for 17 on node -1
[    0.403778]   alloc kstat_irqs on node -1
[    0.403787] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.403913] pci 0000:00:1c.0: setting latency timer to 64
[    0.403930]   alloc irq_desc for 16 on node -1
[    0.403933]   alloc kstat_irqs on node -1
[    0.403940] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.404065] pci 0000:00:1c.1: setting latency timer to 64
[    0.404082]   alloc irq_desc for 19 on node -1
[    0.404085]   alloc kstat_irqs on node -1
[    0.404091] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.404217] pci 0000:00:1c.3: setting latency timer to 64
[    0.404233] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.404366] pci 0000:00:1c.4: setting latency timer to 64
[    0.404379] pci 0000:00:1e.0: setting latency timer to 64
[    0.404386] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.404389] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.404393] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.404396] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.404400] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.404403] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.404407] pci_bus 0000:00: resource 10 [mem 0x80000000-0xdfffffff]
[    0.404410] pci_bus 0000:00: resource 11 [mem 0xf0000000-0xfebfffff]
[    0.404414] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.404417] pci_bus 0000:02: resource 1 [mem 0xc4000000-0xc7ffffff]
[    0.404421] pci_bus 0000:02: resource 2 [mem 0xcc000000-0xcdffffff 64bit pref]
[    0.404425] pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
[    0.404428] pci_bus 0000:03: resource 1 [mem 0xf0000000-0xf3ffffff]
[    0.404432] pci_bus 0000:03: resource 2 [mem 0xfa000000-0xfbffffff 64bit pref]
[    0.404435] pci_bus 0000:06: resource 0 [io  0x4000-0x4fff]
[    0.404439] pci_bus 0000:06: resource 1 [mem 0xf4000000-0xf7ffffff]
[    0.404442] pci_bus 0000:06: resource 2 [mem 0xfc000000-0xfdffffff 64bit pref]
[    0.404446] pci_bus 0000:07: resource 0 [io  0x5000-0x5fff]
[    0.404449] pci_bus 0000:07: resource 1 [mem 0x80000000-0x803fffff]
[    0.404453] pci_bus 0000:07: resource 2 [mem 0xf8600000-0xf86fffff 64bit pref]
[    0.404457] pci_bus 0000:08: resource 1 [mem 0xf8200000-0xf82fffff]
[    0.404460] pci_bus 0000:08: resource 4 [io  0x0000-0x0cf7]
[    0.404463] pci_bus 0000:08: resource 5 [io  0x0d00-0xffff]
[    0.404467] pci_bus 0000:08: resource 6 [mem 0x000a0000-0x000bffff]
[    0.404470] pci_bus 0000:08: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.404473] pci_bus 0000:08: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.404477] pci_bus 0000:08: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.404480] pci_bus 0000:08: resource 10 [mem 0x80000000-0xdfffffff]
[    0.404484] pci_bus 0000:08: resource 11 [mem 0xf0000000-0xfebfffff]
[    0.404569] NET: Registered protocol family 2
[    0.404992] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.406808] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.409904] TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
[    0.416634] TCP: Hash tables configured (established 262144 bind 65536)
[    0.416830] TCP reno registered
[    0.416991] UDP hash table entries: 1024 (order: 5, 131072 bytes)
[    0.417357] UDP-Lite hash table entries: 1024 (order: 5, 131072 bytes)
[    0.417920] NET: Registered protocol family 1
[    0.418072] pci 0000:00:02.0: Boot video device
[    0.418091] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x3e00
[    0.418095] pci 0000:00:1a.0: Performing full reset
[    0.418122] pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x2000
[    0.418126] pci 0000:00:1a.1: Performing full reset
[    0.418214] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x2e00
[    0.418218] pci 0000:00:1d.0: Performing full reset
[    0.418244] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x2000
[    0.418247] pci 0000:00:1d.1: Performing full reset
[    0.418274] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x2000
[    0.418277] pci 0000:00:1d.2: Performing full reset
[    0.418393] PCI: CLS 64 bytes, default 64
[    0.418712] Trying to unpack rootfs image as initramfs...
[    0.708019] Freeing initrd memory: 1204k freed
[    0.708796] Simple Boot Flag at 0x36 set to 0x1
[    0.710109] microcode: CPU0 sig=0x6fd, pf=0x80, revision=0xa1
[    0.710248] microcode: CPU1 sig=0x6fd, pf=0x80, revision=0xa1
[    0.710432] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.710619] Scanning for low memory corruption every 60 seconds
[    0.711137] cryptomgr_test used greatest stack depth: 6448 bytes left
[    0.711392] audit: initializing netlink socket (disabled)
[    0.711579] type=2000 audit(1282682880.710:1): initialized
[    0.738448] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.742818] VFS: Disk quotas dquot_6.5.2
[    0.743100] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.743697] msgmni has been set to 3988
[    0.744502] cryptomgr_test used greatest stack depth: 6080 bytes left
[    0.744984] alg: No test for stdrng (krng)
[    0.745216] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.745460] io scheduler noop registered
[    0.745575] io scheduler deadline registered
[    0.745778] io scheduler cfq registered (default)
[    0.746238] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.746479] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.746699] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.746923] pcieport 0000:00:1c.4: setting latency timer to 64
[    0.747298] intel_idle: MWAIT substates: 0x22220
[    0.747302] intel_idle: does not run on family 6 model 15
[    0.749656] ACPI: AC Adapter [ACAD] (on-line)
[    0.750026] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    0.750314] ACPI: Lid Switch [LID0]
[    0.750557] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    0.750804] ACPI: Power Button [PWRB]
[    0.751045] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    0.751235] ACPI: Sleep Button [SLPB]
[    0.751519] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.751707] ACPI: Power Button [PWRF]
[    0.751948] ACPI: acpi_idle registered with cpuidle
[    0.757749] Monitor-Mwait will be used to enter C-1 state
[    0.757814] Monitor-Mwait will be used to enter C-2 state
[    0.757869] Monitor-Mwait will be used to enter C-3 state
[    0.757880] Marking TSC unstable due to TSC halts in idle
[    0.758340] Switching to clocksource hpet
[    0.857416] ACPI: EC: GPE storm detected, transactions will use polling mode
[    1.052380] ACPI: Battery Slot [BAT1] (battery present)
[    1.052809] Non-volatile memory driver v1.3
[    1.053316] Linux agpgart interface v0.103
[    1.053688] agpgart-intel 0000:00:00.0: Intel 965GM Chipset
[    1.054700] agpgart-intel 0000:00:00.0: detected 7676K stolen memory
[    1.059476] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    1.059701] [drm] Initialized drm 1.1.0 20060810
[    1.059858] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.059982] i915 0000:00:02.0: setting latency timer to 64
[    1.135304] [drm:i915_init_phys_hws], Enabled hardware status page
[    1.135328] [drm] set up 7M of stolen space
[    1.136174] [drm:i915_gtt_to_phys], GTT addr: 0x00000000, PTE: 0x7f800001
[    1.136251] [drm:i915_gtt_to_phys], GTT addr: 0x00000000, phys addr: 0x7f800000
[    1.136397] [drm:i915_gtt_to_phys], GTT addr: 0x006c8000, PTE: 0x7e9eb001
[    1.136471] [drm:i915_gtt_to_phys], GTT addr: 0x006c8000, phys addr: 0x7e9eb000
[    1.136476] [drm:i915_setup_compression], FBC base 0x7f800000, ll base 0x7e9eb000, size 6M
[    1.136509] [drm:parse_general_definitions], crt_ddc_bus_pin: 2
[    1.136517] [drm:parse_lfp_panel_data], Found panel mode in BIOS VBT tables:
[    1.136521] [drm:drm_mode_debug_printmodeline], Modeline 0:"1280x800" 0 69300 1280 1304 1336 1416 800 804 810 817 0x8 0xa
[    1.136537] [drm:parse_sdvo_device_mapping], No SDVO device info is found in VBT
[    1.136728] [drm:intel_modeset_init], 2 display pipes available.
[    1.243665] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.244250] [drm] initialized overlay support
[    1.354702] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[    1.364862] [drm:drm_fb_helper_connector_parse_command_line], cmdline mode for connector LVDS-1 0x0@60Hz
[    1.364868] [drm] forcing LVDS-1 connector OFF
[    1.364985] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[    1.364990] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[    1.365050] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[    1.479265] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[    1.479270] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    1.479277] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[    1.479284] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[    1.479290] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[    1.479297] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[    1.479303] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[    1.479310] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[    1.479316] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[    1.479322] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[    1.479329] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[    1.479335] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[    1.479341] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[    1.479348] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[    1.479354] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[    1.479360] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[    1.479367] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[    1.479373] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[    1.479380] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[    1.479389] [drm:drm_crtc_helper_set_mode], [CRTC:3]
[    1.479397] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 0
[    1.489796] [drm:intel_crtc_mode_set], Mode for pipe A:
[    1.489800] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[    1.541013] [drm:intel_wait_for_vblank], vblank wait timed out
[    1.541017] [drm:intel_pipe_set_base], No FB bound
[    1.541022] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set [MODE:0:NTSC 480i]
[    1.551048] [drm:intel_update_watermarks], plane A (pipe 0) clock: 107520
[    1.551054] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[    1.551058] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[    1.551088] [drm:intel_update_fbc], 
[    1.602012] [drm:intel_wait_for_vblank], vblank wait timed out
[    1.653012] [drm:intel_wait_for_vblank], vblank wait timed out
[    1.704185] [drm:intel_wait_for_vblank], vblank wait timed out
[    1.704190] [drm:intel_tv_detect_type], No TV connection detected
[    1.824372] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[    1.834531] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[    1.834536] [drm:drm_setup_crtcs], 
[    1.834540] [drm:drm_enable_connectors], connector 5 enabled? no
[    1.834544] [drm:drm_enable_connectors], connector 12 enabled? yes
[    1.834548] [drm:drm_enable_connectors], connector 14 enabled? no
[    1.834553] [drm:drm_target_preferred], looking for cmdline mode on connector 12
[    1.834557] [drm:drm_target_preferred], looking for preferred mode on connector 12
[    1.834561] [drm:drm_target_preferred], found mode 1280x1024
[    1.834565] [drm:drm_setup_crtcs], picking CRTCs for 8192x8192 config
[    1.834572] [drm:drm_setup_crtcs], desired mode 1280x1024 set on crtc 3
[    1.844251] [drm:intelfb_create], allocated 1280x1024 fb: 0x00800000, bo ffff88007a28f400
[    1.846493] [drm:drm_crtc_helper_set_config], 
[    1.846497] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:47] #connectors=1 (x y) (0 0)
[    1.846505] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[    1.846508] [drm:drm_crtc_helper_set_config], modes are different, full mode set
[    1.846511] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[    1.846517] [drm:drm_mode_debug_printmodeline], Modeline 31:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    1.846526] [drm:drm_crtc_helper_set_config], encoder changed, full mode switch
[    1.846530] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[    1.846533] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[    1.846537] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[    1.846540] [drm:drm_mode_debug_printmodeline], Modeline 31:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    1.846548] [drm:drm_crtc_helper_set_mode], [CRTC:3]
[    1.846583] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 0
[    1.856981] [drm:intel_crtc_mode_set], Mode for pipe A:
[    1.856984] [drm:drm_mode_debug_printmodeline], Modeline 31:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    1.908012] [drm:intel_wait_for_vblank], vblank wait timed out
[    1.908043] [drm:intel_pipe_set_base], Writing base 00800000 00000000 0 0 5120
[    1.908047] [drm:intel_update_fbc], 
[    1.908050] [drm:intel_update_fbc], 1 pipes active
[    1.908053] [drm:intel_update_fbc], framebuffer not tiled, disabling compression
[    1.959013] [drm:intel_wait_for_vblank], vblank wait timed out
[    1.959018] [drm:drm_crtc_helper_set_mode], [ENCODER:13:DAC-13] set [MODE:31:1280x1024]
[    1.959023] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[    1.959026] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[    1.959030] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[    1.959058] [drm:intel_update_fbc], 
[    1.959061] [drm:intel_update_fbc], 1 pipes active
[    1.959063] [drm:intel_update_fbc], framebuffer not tiled, disabling compression
[    1.959078] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[    1.969234] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[    1.969238] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[    1.969241] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[    1.969246] [drm:drm_crtc_helper_set_config], 
[    1.969248] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:47] #connectors=0 (x y) (0 0)
[    1.969255] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[    1.969258] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[    1.969265] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[    1.979421] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[    1.979424] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[    1.979428] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[    1.980830] [drm:drm_crtc_helper_set_config], 
[    1.980832] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:47] #connectors=1 (x y) (0 0)
[    1.980841] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[    1.984967] [drm:drm_crtc_helper_set_config], 
[    1.984970] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:47] #connectors=1 (x y) (0 0)
[    1.984978] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[    1.989062] Console: switching to colour frame buffer device 160x64
[    1.989069] [drm:drm_crtc_helper_set_config], 
[    1.989071] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:47] #connectors=1 (x y) (0 0)
[    1.989079] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[    1.993219] fb0: inteldrmfb frame buffer device
[    1.993247] drm: registered panic notifier
[    1.993313] [drm:intel_opregion_init], graphic opregion physical addr: 0x7f6dfe3c
[    1.993332] [drm:intel_opregion_init], Public ACPI methods supported
[    1.993644] [drm:intel_opregion_init], SWSCI supported
[    1.993648] [drm:intel_opregion_init], ASLE supported
[    2.027127] acpi device:07: registered as cooling_device2
[    2.027667] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:01/input/input4
[    2.027739] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    2.027894] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    2.031328] brd: module loaded
[    2.031405] console [netcon0] enabled
[    2.031430] netconsole: network logging started
[    2.031754] usbcore: registered new interface driver libusual
[    2.031889] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    2.063248] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.063329] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.063547] mice: PS/2 mouse device common for all mice
[    2.063682] rtc_cmos 00:07: RTC can wake from S4
[    2.064065] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    2.064153] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    2.064213] i2c /dev entries driver
[    2.064768]   alloc irq_desc for 18 on node -1
[    2.064772]   alloc kstat_irqs on node -1
[    2.064810] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.064869] ACPI: resource 0000:00:1f.3 [io  0x1c20-0x1c3f] conflicts with ACPI region SMBI [io  0x1c20-0x1c2f disabled]
[    2.064936] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    2.065263] cpuidle: using governor ladder
[    2.066814] cpuidle: using governor menu
[    2.066924] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    2.067409] usbcore: registered new interface driver hiddev
[    2.067472] usbcore: registered new interface driver usbhid
[    2.067506] usbhid: USB HID core driver
[    2.067577] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    2.069822] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.069982] TCP cubic registered
[    2.070024] Initializing XFRM netlink socket
[    2.070085] NET: Registered protocol family 17
[    2.070124] lib80211: common routines for IEEE802.11 drivers
[    2.070174] lib80211_crypt: registered algorithm 'NULL'
[    2.070177] Registering the dns_resolver key type
[    2.071791] registered taskstats version 1
[    2.072662] rtc_cmos 00:07: setting system clock to 2010-08-24 20:48:02 UTC (1282682882)
[    2.072715] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.072754] EDD information not available.
[    2.072886] Initalizing network drop monitor service
[    2.075502] Freeing unused kernel memory: 548k freed
[    2.077713] Write protecting the kernel read-only data: 6144k
[    2.079940] Freeing unused kernel memory: 292k freed
[    2.082187] Freeing unused kernel memory: 260k freed
[    2.089271] busybox used greatest stack depth: 5688 bytes left
[    2.091649] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[    2.098516] mount used greatest stack depth: 5632 bytes left
[    2.111920] udev: starting version 161
[    2.113957] udevd (56): /proc/56/oom_adj is deprecated, please use /proc/56/oom_score_adj instead.
[    2.118845] init used greatest stack depth: 5576 bytes left
[    2.177337] load-modules.sh used greatest stack depth: 5400 bytes left
[    2.186377] sed used greatest stack depth: 5328 bytes left
[    2.278825] modprobe used greatest stack depth: 5248 bytes left
[    2.282724] modprobe used greatest stack depth: 4976 bytes left
[    2.440070] udevadm used greatest stack depth: 4112 bytes left
[    2.681430] SCSI subsystem initialized
[    2.702717] libata version 3.00 loaded.
[    2.714894] ahci 0000:00:1f.2: version 3.0
[    2.714923] ahci 0000:00:1f.2: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[    2.717217] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x7 impl SATA mode
[    2.719285] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc 
[    2.721355] ahci 0000:00:1f.2: setting latency timer to 64
[    2.721764] scsi0 : ahci
[    2.724465] scsi1 : ahci
[    2.726705] scsi2 : ahci
[    2.729207] ata1: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 18
[    2.731305] ata2: SATA max UDMA/133 abar m2048@0xf8504000 port 0xf8504180 irq 18
[    2.733359] ata3: SATA max UDMA/133 abar m2048@0xf8504000 port 0xf8504200 irq 18
[    2.735548] pata_acpi 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.737627] pata_acpi 0000:00:1f.1: setting latency timer to 64
[    2.737654] pata_acpi 0000:00:1f.1: PCI INT A disabled
[    3.040156] ata2: SATA link down (SStatus 0 SControl 300)
[    3.042221] ata3: SATA link down (SStatus 0 SControl 300)
[    3.458134] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.460876] ata1.00: unexpected _GTF length (8)
[    3.515143] ata1.00: ATA-8: WDC WD1600BEVT-75ZCT0, 11.01A11, max UDMA/133
[    3.517123] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    3.520156] ata1.00: unexpected _GTF length (8)
[    3.522455] ata1.00: configured for UDMA/133
[    3.536081] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600BEVT-7 11.0 PQ: 0 ANSI: 5
[    3.543532] ata_piix 0000:00:1f.1: version 2.13
[    3.543557] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.546237] ata_piix 0000:00:1f.1: setting latency timer to 64
[    3.546382] scsi3 : ata_piix
[    3.551186] scsi4 : ata_piix
[    3.554541] ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
[    3.554969] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    3.555140] sd 0:0:0:0: [sda] Write Protect is off
[    3.555144] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.555206] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.562534] ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
[    3.564618]  sda: sda1 sda2 sda3 sda4
[    3.567876] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.727199] ata4.00: ATAPI: TEAC   DVD+/-RW DVW28SLC, A.06, max UDMA/33
[    3.751470] ata4.00: configured for UDMA/33
[    3.767672] scsi 3:0:0:0: CD-ROM            TEAC     DVD+-RW DVW28SLC A.06 PQ: 0 ANSI: 5
[    3.819453] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda caddy
[    3.821590] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.824236] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    4.324869] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    5.736347] udev: starting version 161
[    6.339955] ACPI: WMI: Mapper loaded
[    6.379655] iTCO_vendor_support: vendor-support=0
[    6.379965] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.379969] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    6.380068] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.380101] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    6.380108] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    6.380671] drivers/usb/core/inode.c: creating file 'devices'
[    6.380832] drivers/usb/core/inode.c: creating file '001'
[    6.381482] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    6.381496] ehci_hcd 0000:00:1a.7: reset hcs_params 0x102204 dbg=1 cc=2 pcc=2 ordered !ppc ports=4
[    6.381503] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    6.381596] ehci_hcd 0000:00:1a.7: debug port 1
[    6.381603] ehci_hcd 0000:00:1a.7: reset command 0080032 (park)=0 ithresh=8 Async Periodic period=1024 Reset HALT
[    6.396638] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    6.396699] r8169 0000:07:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.396830] r8169 0000:07:00.0: setting latency timer to 64
[    6.396864] r8169 0000:07:00.0: no MSI. Back to INTx.
[    6.398053] r8169 0000:07:00.0: eth0: RTL8168c/8111c at 0xffffc90011374000, 00:1c:23:4e:23:72, XID 1c4000c0 IRQ 16
[    6.433562] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    6.433568] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    6.433587] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf8504800
[    6.433595] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    6.455698] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    6.464890] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    6.465224] usb usb1: default language 0x0409
[    6.465247] usb usb1: udev 1, busnum 1, minor = 0
[    6.465250] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    6.465254] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.465258] usb usb1: Product: EHCI Host Controller
[    6.465261] usb usb1: Manufacturer: Linux 2.6.36-rc2-RC+ ehci_hcd
[    6.465265] usb usb1: SerialNumber: 0000:00:1a.7
[    6.466239] usb usb1: usb_probe_device
[    6.466244] usb usb1: configuration #1 chosen from 1 choice
[    6.466480] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    6.466757] hub 1-0:1.0: usb_probe_interface
[    6.466761] hub 1-0:1.0: usb_probe_interface - got id
[    6.466770] hub 1-0:1.0: USB hub found
[    6.466833] hub 1-0:1.0: 4 ports detected
[    6.466836] hub 1-0:1.0: standalone hub
[    6.466839] hub 1-0:1.0: no power switching (usb 1.0)
[    6.466843] hub 1-0:1.0: individual port over-current protection
[    6.466847] hub 1-0:1.0: power on to power good time: 20ms
[    6.467029] hub 1-0:1.0: local power source is good
[    6.467033] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    6.467140] drivers/usb/core/inode.c: creating file '001'
[    6.467456]   alloc irq_desc for 23 on node -1
[    6.467460]   alloc kstat_irqs on node -1
[    6.467472] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    6.467514] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    6.467520] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    6.467536] drivers/usb/core/inode.c: creating file '002'
[    6.486770] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    6.486788] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    6.486795] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    6.486845] ehci_hcd 0000:00:1d.7: debug port 1
[    6.486852] ehci_hcd 0000:00:1d.7: reset command 0080032 (park)=0 ithresh=8 Async Periodic period=1024 Reset HALT
[    6.509225] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    6.509230] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    6.509277] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf8504c00
[    6.509284] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    6.515836] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[    6.516063] iTCO_wdt: Found a ICH8M TCO device (Version=2, TCOBASE=0x1060)
[    6.516460] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    6.522585] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    6.526430] input: Dell WMI hotkeys as /devices/virtual/input/input6
[    6.527597] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.527727] sr 3:0:0:0: Attached scsi generic sg1 type 5
[    6.539210] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    6.539515] usb usb2: default language 0x0409
[    6.539538] usb usb2: udev 1, busnum 2, minor = 128
[    6.539542] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    6.539546] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.539549] usb usb2: Product: EHCI Host Controller
[    6.539552] usb usb2: Manufacturer: Linux 2.6.36-rc2-RC+ ehci_hcd
[    6.539556] usb usb2: SerialNumber: 0000:00:1d.7
[    6.540881] usb usb2: usb_probe_device
[    6.540886] usb usb2: configuration #1 chosen from 1 choice
[    6.540914] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    6.541102] hub 2-0:1.0: usb_probe_interface
[    6.541106] hub 2-0:1.0: usb_probe_interface - got id
[    6.541113] hub 2-0:1.0: USB hub found
[    6.541129] hub 2-0:1.0: 6 ports detected
[    6.541133] hub 2-0:1.0: standalone hub
[    6.541136] hub 2-0:1.0: no power switching (usb 1.0)
[    6.541139] hub 2-0:1.0: individual port over-current protection
[    6.541143] hub 2-0:1.0: power on to power good time: 20ms
[    6.541161] hub 2-0:1.0: local power source is good
[    6.541165] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    6.541269] drivers/usb/core/inode.c: creating file '001'
[    6.567449] hub 1-0:1.0: state 7 ports 4 chg 0000 evt 0000
[    6.567719] coretemp coretemp.0: TjMax is assumed as 100 C!
[    6.568320] coretemp coretemp.1: TjMax is assumed as 100 C!
[    6.641452] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 001403 0  ACK POWER sig=k CSC CONNECT
[    6.641462] hub 2-0:1.0: port 2: status 0501 change 0001
[    6.649059] uhci_hcd: USB Universal Host Controller Interface driver
[    6.650070] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.650084] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    6.650091] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    6.650141] drivers/usb/core/inode.c: creating file '003'
[    6.650446] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    6.650458] uhci_hcd 0000:00:1a.0: detected 2 ports
[    6.650466] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    6.650470] uhci_hcd 0000:00:1a.0: Performing full reset
[    6.650488] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    6.650505] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00001820
[    6.650666] usb usb3: default language 0x0409
[    6.650689] usb usb3: udev 1, busnum 3, minor = 256
[    6.650692] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    6.650696] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.650700] usb usb3: Product: UHCI Host Controller
[    6.650703] usb usb3: Manufacturer: Linux 2.6.36-rc2-RC+ uhci_hcd
[    6.650706] usb usb3: SerialNumber: 0000:00:1a.0
[    6.651000] usb usb3: usb_probe_device
[    6.651023] usb usb3: configuration #1 chosen from 1 choice
[    6.651043] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    6.651180] hub 3-0:1.0: usb_probe_interface
[    6.651184] hub 3-0:1.0: usb_probe_interface - got id
[    6.651191] hub 3-0:1.0: USB hub found
[    6.651209] hub 3-0:1.0: 2 ports detected
[    6.651212] hub 3-0:1.0: standalone hub
[    6.651215] hub 3-0:1.0: no power switching (usb 1.0)
[    6.651219] hub 3-0:1.0: individual port over-current protection
[    6.651223] hub 3-0:1.0: power on to power good time: 2ms
[    6.651264] hub 3-0:1.0: local power source is good
[    6.651269] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    6.651335] drivers/usb/core/inode.c: creating file '001'
[    6.651538] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    6.651638]   alloc irq_desc for 21 on node -1
[    6.651642]   alloc kstat_irqs on node -1
[    6.651659] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    6.651672] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    6.651678] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    6.651693] drivers/usb/core/inode.c: creating file '004'
[    6.651907] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    6.651919] uhci_hcd 0000:00:1a.1: detected 2 ports
[    6.651927] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    6.651930] uhci_hcd 0000:00:1a.1: Performing full reset
[    6.651949] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[    6.651991] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001840
[    6.652096] usb usb4: default language 0x0409
[    6.652118] usb usb4: udev 1, busnum 4, minor = 384
[    6.652122] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    6.652126] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.652129] usb usb4: Product: UHCI Host Controller
[    6.652132] usb usb4: Manufacturer: Linux 2.6.36-rc2-RC+ uhci_hcd
[    6.652135] usb usb4: SerialNumber: 0000:00:1a.1
[    6.652402] usb usb4: usb_probe_device
[    6.652406] usb usb4: configuration #1 chosen from 1 choice
[    6.652426] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    6.652557] hub 4-0:1.0: usb_probe_interface
[    6.652561] hub 4-0:1.0: usb_probe_interface - got id
[    6.652568] hub 4-0:1.0: USB hub found
[    6.652581] hub 4-0:1.0: 2 ports detected
[    6.652585] hub 4-0:1.0: standalone hub
[    6.652588] hub 4-0:1.0: no power switching (usb 1.0)
[    6.652591] hub 4-0:1.0: individual port over-current protection
[    6.652595] hub 4-0:1.0: power on to power good time: 2ms
[    6.652611] hub 4-0:1.0: local power source is good
[    6.652615] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    6.652678] drivers/usb/core/inode.c: creating file '001'
[    6.652778] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
[    6.652862] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    6.652874] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    6.652879] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    6.652894] drivers/usb/core/inode.c: creating file '005'
[    6.653116] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    6.653128] uhci_hcd 0000:00:1d.0: detected 2 ports
[    6.653135] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    6.653138] uhci_hcd 0000:00:1d.0: Performing full reset
[    6.653156] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    6.653169] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001860
[    6.653251] usb usb5: default language 0x0409
[    6.653273] usb usb5: udev 1, busnum 5, minor = 512
[    6.653277] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    6.653281] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.653284] usb usb5: Product: UHCI Host Controller
[    6.653287] usb usb5: Manufacturer: Linux 2.6.36-rc2-RC+ uhci_hcd
[    6.653290] usb usb5: SerialNumber: 0000:00:1d.0
[    6.653567] usb usb5: usb_probe_device
[    6.653571] usb usb5: configuration #1 chosen from 1 choice
[    6.653589] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    6.653741] hub 5-0:1.0: usb_probe_interface
[    6.653745] hub 5-0:1.0: usb_probe_interface - got id
[    6.653752] hub 5-0:1.0: USB hub found
[    6.653767] hub 5-0:1.0: 2 ports detected
[    6.653771] hub 5-0:1.0: standalone hub
[    6.653773] hub 5-0:1.0: no power switching (usb 1.0)
[    6.653777] hub 5-0:1.0: individual port over-current protection
[    6.653781] hub 5-0:1.0: power on to power good time: 2ms
[    6.653797] hub 5-0:1.0: local power source is good
[    6.653801] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    6.653865] drivers/usb/core/inode.c: creating file '001'
[    6.654090] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    6.654149] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    6.654163] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    6.654169] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    6.654186] drivers/usb/core/inode.c: creating file '006'
[    6.654378] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    6.654390] uhci_hcd 0000:00:1d.1: detected 2 ports
[    6.654398] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    6.654401] uhci_hcd 0000:00:1d.1: Performing full reset
[    6.654419] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    6.654457] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001880
[    6.654559] usb usb6: default language 0x0409
[    6.654581] usb usb6: udev 1, busnum 6, minor = 640
[    6.654585] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    6.654589] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.654593] usb usb6: Product: UHCI Host Controller
[    6.654596] usb usb6: Manufacturer: Linux 2.6.36-rc2-RC+ uhci_hcd
[    6.654599] usb usb6: SerialNumber: 0000:00:1d.1
[    6.654864] usb usb6: usb_probe_device
[    6.654868] usb usb6: configuration #1 chosen from 1 choice
[    6.654888] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    6.655036] hub 6-0:1.0: usb_probe_interface
[    6.655040] hub 6-0:1.0: usb_probe_interface - got id
[    6.655046] hub 6-0:1.0: USB hub found
[    6.655061] hub 6-0:1.0: 2 ports detected
[    6.655064] hub 6-0:1.0: standalone hub
[    6.655067] hub 6-0:1.0: no power switching (usb 1.0)
[    6.655070] hub 6-0:1.0: individual port over-current protection
[    6.655074] hub 6-0:1.0: power on to power good time: 2ms
[    6.655091] hub 6-0:1.0: local power source is good
[    6.655095] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    6.655158] drivers/usb/core/inode.c: creating file '001'
[    6.655299] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    6.655371] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.655383] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    6.655388] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    6.655421] drivers/usb/core/inode.c: creating file '007'
[    6.655630] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    6.655642] uhci_hcd 0000:00:1d.2: detected 2 ports
[    6.655649] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    6.655652] uhci_hcd 0000:00:1d.2: Performing full reset
[    6.655672] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    6.655684] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018a0
[    6.655767] usb usb7: default language 0x0409
[    6.655789] usb usb7: udev 1, busnum 7, minor = 768
[    6.655792] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    6.655796] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.655800] usb usb7: Product: UHCI Host Controller
[    6.655803] usb usb7: Manufacturer: Linux 2.6.36-rc2-RC+ uhci_hcd
[    6.655806] usb usb7: SerialNumber: 0000:00:1d.2
[    6.656088] usb usb7: usb_probe_device
[    6.656092] usb usb7: configuration #1 chosen from 1 choice
[    6.656113] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    6.658067] hub 7-0:1.0: usb_probe_interface
[    6.658071] hub 7-0:1.0: usb_probe_interface - got id
[    6.658078] hub 7-0:1.0: USB hub found
[    6.658091] hub 7-0:1.0: 2 ports detected
[    6.658095] hub 7-0:1.0: standalone hub
[    6.658098] hub 7-0:1.0: no power switching (usb 1.0)
[    6.658101] hub 7-0:1.0: individual port over-current protection
[    6.658105] hub 7-0:1.0: power on to power good time: 2ms
[    6.658121] hub 7-0:1.0: local power source is good
[    6.658125] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    6.658192] drivers/usb/core/inode.c: creating file '001'
[    6.660784] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    6.712736]   alloc irq_desc for 22 on node -1
[    6.712741]   alloc kstat_irqs on node -1
[    6.712753] firewire_ohci 0000:08:05.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    6.732158] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:s
[    6.732163] iwl3945: Copyright(c) 2003-2010 Intel Corporation
[    6.732323] iwl3945 0000:06:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    6.732341] iwl3945 0000:06:00.0: setting latency timer to 64
[    6.744586] hub 2-0:1.0: state 7 ports 6 chg 0004 evt 0000
[    6.744622] hub 2-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[    6.744775] ehci_hcd 0000:00:1d.7: port 2 low speed --> companion
[    6.754045] uhci_hcd 0000:00:1d.0: port 2 portsc 01ab,00
[    6.754053] hub 5-0:1.0: port 2: status 0301 change 0003
[    6.763371] firewire_ohci: Added fw-ohci device 0000:08:05.0, OHCI v1.10, 8 IR + 8 IT contexts, quirks 0x0
[    6.795074] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    6.795209] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0004
[    6.795240] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    6.795252] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    6.795264] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    6.795275] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    6.795415] iwl3945 0000:06:00.0: Tunable channels: 13 802.11bg, 23 802.11a channels
[    6.795420] iwl3945 0000:06:00.0: Detected Intel Wireless WiFi Link 3945ABG
[    6.799273] udev-acl used greatest stack depth: 4096 bytes left
[    6.801187] phy0: Selected rate control algorithm 'iwl-3945-rs'
[    6.854611] hub 5-0:1.0: state 7 ports 2 chg 0004 evt 0000
[    6.854642] hub 5-0:1.0: port 2, status 0301, change 0000, 1.5 Mb/s
[    6.956073] usb 5-2: new low speed USB device using uhci_hcd and address 2
[    7.031596] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    7.031661] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    7.102294] usb 5-2: skipped 1 descriptor after interface
[    7.102299] usb 5-2: skipped 1 descriptor after interface
[    7.107285] usb 5-2: default language 0x0409
[    7.113264] hda_codec: ALC268: BIOS auto-probing.
[    7.125272] usb 5-2: udev 2, busnum 5, minor = 513
[    7.125277] usb 5-2: New USB device found, idVendor=046d, idProduct=c512
[    7.125281] usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.125285] usb 5-2: Product: 2.4GHz Cordless Desktop
[    7.125288] usb 5-2: Manufacturer: Logitech
[    7.125689] usb 5-2: usb_probe_device
[    7.125696] usb 5-2: configuration #1 chosen from 1 choice
[    7.129201] usb 5-2: adding 5-2:1.0 (config #1, interface 0)
[    7.129341] usbhid 5-2:1.0: usb_probe_interface
[    7.129346] usbhid 5-2:1.0: usb_probe_interface - got id
[    7.145955] input: Logitech 2.4GHz Cordless Desktop as /devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2:1.0/input/input7
[    7.146150] uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[    7.147681] logitech 0003:046D:C512.0001: input,hidraw0: USB HID v1.11 Keyboard [Logitech 2.4GHz Cordless Desktop] on usb-0000:00:1d.0-2/input0
[    7.147764] usb 5-2: adding 5-2:1.1 (config #1, interface 1)
[    7.147930] usbhid 5-2:1.1: usb_probe_interface
[    7.147935] usbhid 5-2:1.1: usb_probe_interface - got id
[    7.178166] input: Logitech 2.4GHz Cordless Desktop as /devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2:1.1/input/input8
[    7.178200] uhci_hcd 0000:00:1d.0: reserve dev 2 ep82-INT, period 8, phase 4, 118 us
[    7.178570] drivers/usb/core/file.c: looking for a minor, starting at 0
[    7.179488] logitech 0003:046D:C512.0002: input,hiddev0,hidraw1: USB HID v1.11 Mouse [Logitech 2.4GHz Cordless Desktop] on usb-0000:00:1d.0-2/input1
[    7.179702] drivers/usb/core/inode.c: creating file '002'
[    7.223652] fuse init (API version 7.15)
[    7.236090] input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input9
[    7.245064] edd_id used greatest stack depth: 3824 bytes left
[    7.267195] firewire_core: created device fw0: GUID 0000c010a000b000, S400
[    7.272252] input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio1/input/input10
[    7.704045] usb usb3: suspend_rh (auto-stop)
[    7.704081] usb usb4: suspend_rh (auto-stop)
[    7.704113] usb usb6: suspend_rh (auto-stop)
[    7.704146] usb usb7: suspend_rh (auto-stop)
[    8.028816] EXT4-fs (sda1): re-mounted. Opts: (null)
[    8.238423] EXT4-fs (sda1): re-mounted. Opts: (null)
[    8.422939] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
[    8.480587] Adding 4000180k swap on /dev/sda4.  Priority:-1 extents:1 across:4000180k 
[    8.704284] hub 1-0:1.0: hub_suspend
[    8.704400] usb usb1: bus auto-suspend
[    8.704405] ehci_hcd 0000:00:1a.7: suspend root hub
[    8.993366] find used greatest stack depth: 3024 bytes left
[    9.712189] hub 2-0:1.0: hub_suspend
[    9.712208] usb usb2: bus auto-suspend
[    9.712214] ehci_hcd 0000:00:1d.7: suspend root hub
[    9.712259] hub 3-0:1.0: hub_suspend
[    9.712268] usb usb3: bus auto-suspend
[    9.712286] usb usb3: suspend_rh
[    9.712311] hub 4-0:1.0: hub_suspend
[    9.712322] usb usb4: bus auto-suspend
[    9.712326] usb usb4: suspend_rh
[    9.712349] hub 6-0:1.0: hub_suspend
[    9.712357] usb usb6: bus auto-suspend
[    9.712360] usb usb6: suspend_rh
[    9.712384] hub 7-0:1.0: hub_suspend
[    9.712391] usb usb7: bus auto-suspend
[    9.712395] usb usb7: suspend_rh
[   10.965559] [drm:i915_driver_irq_handler], pipe a underrun
[   10.965571] r8169 0000:07:00.0: eth0: link up
[   10.965667] r8169 0000:07:00.0: eth0: link up
[   26.422524] [drm:drm_crtc_helper_set_config], 
[   26.422527] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:47] #connectors=1 (x y) (0 0)
[   26.422553] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   26.430105] [drm:i915_driver_open], 
[   26.430291] [drm:drm_crtc_helper_set_config], 
[   26.430295] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:47] #connectors=1 (x y) (0 0)
[   26.430319] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   26.430325] [drm:drm_crtc_helper_set_config], 
[   26.430328] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:47] #connectors=0 (x y) (0 0)
[   26.430335] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[   26.430339] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   26.430365] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   26.440524] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.440529] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   26.440534] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   26.440625] [drm:i915_driver_open], 
[   26.441112] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[3] ENCODERS[3]
[   26.441145] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[3] ENCODERS[3]
[   26.441367] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   26.441374] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   26.441379] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   26.441387] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   26.441392] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   26.441397] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   26.447195] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   26.447207] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[   26.557975] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[   26.557980] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   26.557988] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   26.557994] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   26.558019] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   26.558026] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   26.558033] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   26.558039] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   26.558046] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   26.558053] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   26.558060] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   26.558067] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   26.558074] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   26.558081] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   26.558088] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   26.558095] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   26.558102] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   26.558109] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   26.558127] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   26.558227] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   26.558235] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   26.558246] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[   26.558263] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   26.568421] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.568427] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   26.568431] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   26.568678] [drm:intel_crtc_mode_set], Mode for pipe B:
[   26.568682] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   26.569142] [drm:intel_pipe_set_base], No FB bound
[   26.569147] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.569152] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   26.569158] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   26.569165] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set [MODE:0:NTSC 480i]
[   26.594195] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.594200] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   26.594205] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   26.594234] [drm:intel_update_fbc], 
[   26.645012] [drm:intel_wait_for_vblank], vblank wait timed out
[   26.696011] [drm:intel_wait_for_vblank], vblank wait timed out
[   26.747011] [drm:intel_wait_for_vblank], vblank wait timed out
[   26.747016] [drm:intel_tv_detect_type], No TV connection detected
[   26.749568] [drm:i915_driver_irq_handler], pipe b underrun
[   26.766228] [drm:i915_driver_irq_handler], pipe b underrun
[   26.782888] [drm:i915_driver_irq_handler], pipe b underrun
[   26.799550] [drm:i915_driver_irq_handler], pipe b underrun
[   26.816212] [drm:i915_driver_irq_handler], pipe b underrun
[   26.832873] [drm:i915_driver_irq_handler], pipe b underrun
[   26.849534] [drm:i915_driver_irq_handler], pipe b underrun
[   26.857192] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.857197] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   26.857201] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   26.857206] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[   26.857215] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   26.857221] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   26.857230] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[   26.857237] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   26.867395] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.867400] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   26.867404] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   26.867648] [drm:intel_crtc_mode_set], Mode for pipe B:
[   26.867652] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   26.868112] [drm:intel_pipe_set_base], No FB bound
[   26.868117] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.868122] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   26.868128] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   26.868135] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set [MODE:0:NTSC 480i]
[   26.882858] [drm:i915_driver_irq_handler], pipe b underrun
[   26.893164] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   26.893169] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   26.893173] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   26.893203] [drm:intel_update_fbc], 
[   26.899519] [drm:i915_driver_irq_handler], pipe b underrun
[   26.899541] [drm:intel_tv_detect_type], Detected S-Video TV connection
[   26.916180] [drm:i915_driver_irq_handler], pipe b underrun
[   26.932842] [drm:i915_driver_irq_handler], pipe b underrun
[   26.949503] [drm:i915_driver_irq_handler], pipe b underrun
[   26.966165] [drm:i915_driver_irq_handler], pipe b underrun
[   26.982826] [drm:i915_driver_irq_handler], pipe b underrun
[   26.999487] [drm:i915_driver_irq_handler], pipe b underrun
[   27.016149] [drm:i915_driver_irq_handler], pipe b underrun
[   27.024718] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   27.024723] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   27.024727] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   27.024749] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] probed modes :
[   27.024753] [drm:drm_mode_debug_printmodeline], Modeline 51:"848x480" 30 14513 848 849 912 944 480 481 512 513 0x48 0x0
[   27.024760] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 30 11315 640 641 704 736 480 481 512 513 0x48 0x0
[   27.024766] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 30 26886 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   27.024772] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 30 16998 800 801 864 896 600 601 632 633 0x40 0x0
[   27.024788] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   27.024793] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   27.024801] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[   27.024808] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   27.034965] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   27.034970] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   27.034974] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   27.035236] [drm:intel_crtc_mode_set], Mode for pipe B:
[   27.035240] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   27.035699] [drm:intel_pipe_set_base], No FB bound
[   27.035703] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   27.035708] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   27.035713] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   27.035719] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set [MODE:0:NTSC 480i]
[   27.049471] [drm:i915_driver_irq_handler], pipe b underrun
[   27.060747] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   27.060752] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   27.060756] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   27.060785] [drm:intel_update_fbc], 
[   27.066133] [drm:i915_driver_irq_handler], pipe b underrun
[   27.066154] [drm:intel_tv_detect_type], Detected Composite TV connection
[   27.082794] [drm:i915_driver_irq_handler], pipe b underrun
[   27.099455] [drm:i915_driver_irq_handler], pipe b underrun
[   27.116117] [drm:i915_driver_irq_handler], pipe b underrun
[   27.132778] [drm:i915_driver_irq_handler], pipe b underrun
[   27.149439] [drm:i915_driver_irq_handler], pipe b underrun
[   27.166101] [drm:i915_driver_irq_handler], pipe b underrun
[   27.182762] [drm:i915_driver_irq_handler], pipe b underrun
[   27.191332] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   27.191336] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   27.191341] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   27.191367] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] probed modes :
[   27.191372] [drm:drm_mode_debug_printmodeline], Modeline 51:"848x480" 30 14513 848 849 912 944 480 481 512 513 0x48 0x0
[   27.191378] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 30 11315 640 641 704 736 480 481 512 513 0x48 0x0
[   27.191384] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 30 26886 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   27.191391] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 30 16998 800 801 864 896 600 601 632 633 0x40 0x0
[   27.191402] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   27.191493] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   27.191500] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   27.191505] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   27.191512] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   27.191517] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   27.191522] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   27.191582] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   27.191588] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[   27.199461] [drm:i915_driver_irq_handler], pipe b underrun
[   27.307971] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[   27.307978] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   27.307985] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   27.307992] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   27.307999] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   27.308025] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   27.308032] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   27.308038] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   27.308045] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   27.308051] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   27.308057] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   27.308064] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   27.308070] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   27.308078] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   27.308085] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   27.308092] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   27.308099] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   27.308106] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   27.308124] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   27.310858] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   27.310866] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   27.310877] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[   27.310888] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   27.321046] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   27.321051] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   27.321056] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   27.321301] [drm:intel_crtc_mode_set], Mode for pipe B:
[   27.321305] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   27.321765] [drm:intel_pipe_set_base], No FB bound
[   27.321769] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   27.321774] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   27.321779] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   27.321785] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set [MODE:0:NTSC 480i]
[   27.332732] [drm:i915_driver_irq_handler], pipe b underrun
[   27.346813] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   27.346817] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   27.346822] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   27.346852] [drm:intel_update_fbc], 
[   27.349478] [drm:i915_driver_irq_handler], pipe b underrun
[   27.349488] [drm:intel_tv_detect_type], Detected S-Video TV connection
[   27.366054] [drm:i915_driver_irq_handler], pipe b underrun
[   27.382716] [drm:i915_driver_irq_handler], pipe b underrun
[   27.399377] [drm:i915_driver_irq_handler], pipe b underrun
[   27.416038] [drm:i915_driver_irq_handler], pipe b underrun
[   27.432699] [drm:i915_driver_irq_handler], pipe b underrun
[   27.449361] [drm:i915_driver_irq_handler], pipe b underrun
[   27.459667] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   27.459672] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   27.459676] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   27.459703] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] probed modes :
[   27.459708] [drm:drm_mode_debug_printmodeline], Modeline 51:"848x480" 30 14513 848 849 912 944 480 481 512 513 0x48 0x0
[   27.459714] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 30 11315 640 641 704 736 480 481 512 513 0x48 0x0
[   27.459721] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 30 26886 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   27.459727] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 30 16998 800 801 864 896 600 601 632 633 0x40 0x0
[   27.459739] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   27.466029] [drm:i915_driver_irq_handler], pipe b underrun
[   27.555114] [drm:drm_mode_addfb], [FB:52]
[   27.555204] [drm:drm_mode_setcrtc], [CRTC:3]
[   27.555214] [drm:drm_mode_setcrtc], [CONNECTOR:12:VGA-1]
[   27.555219] [drm:drm_crtc_helper_set_config], 
[   27.555223] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:52] #connectors=1 (x y) (0 0)
[   27.555235] [drm:drm_crtc_helper_set_config], modes are different, full mode set
[   27.555239] [drm:drm_mode_debug_printmodeline], Modeline 31:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   27.555246] [drm:drm_mode_debug_printmodeline], Modeline 53:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x0 0xa
[   27.555254] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   27.555259] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[   27.555263] [drm:drm_mode_debug_printmodeline], Modeline 53:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x0 0xa
[   27.555272] [drm:drm_crtc_helper_set_mode], [CRTC:3]
[   27.675694] [drm:intel_crtc_mode_set], Mode for pipe A:
[   27.675699] [drm:drm_mode_debug_printmodeline], Modeline 53:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x0 0xa
[   27.727011] [drm:intel_wait_for_vblank], vblank wait timed out
[   27.731739] [drm:intel_pipe_set_base], Writing base 00D00000 00000000 0 0 4096
[   27.731747] [drm:intel_update_fbc], 
[   27.731751] [drm:intel_update_fbc], 1 pipes active
[   27.731766] [drm:i8xx_enable_fbc], enabled FBC, pitch 63, yoff 0, plane 0, 
[   27.782012] [drm:intel_wait_for_vblank], vblank wait timed out
[   27.782021] [drm:drm_crtc_helper_set_mode], [ENCODER:13:DAC-13] set [MODE:53:1024x768]
[   27.782026] [drm:intel_update_watermarks], plane A (pipe 0) clock: 65000
[   27.782031] [drm:i965_update_wm], self-refresh watermark: display plane 448 cursor 32
[   27.782035] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 448
[   27.782065] [drm:intel_update_fbc], 
[   27.782069] [drm:intel_update_fbc], 1 pipes active
[   27.782074] [drm:i8xx_disable_fbc], disabled FBC
[   27.782087] [drm:i8xx_enable_fbc], enabled FBC, pitch 63, yoff 0, plane 0, 
[   27.782105] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   27.792262] [drm:intel_update_watermarks], plane A (pipe 0) clock: 65000
[   27.792267] [drm:i965_update_wm], self-refresh watermark: display plane 448 cursor 32
[   27.792272] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 448
[   27.792343] [drm:drm_mode_setcrtc], [CRTC:4]
[   27.792354] [drm:drm_mode_setcrtc], [CONNECTOR:14:SVIDEO-1]
[   27.792358] [drm:drm_crtc_helper_set_config], 
[   27.792362] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:52] #connectors=1 (x y) (0 0)
[   27.792370] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[   27.792374] [drm:drm_crtc_helper_set_config], modes are different, full mode set
[   27.792378] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   27.792385] [drm:drm_mode_debug_printmodeline], Modeline 54:"1024x768" 0 26886 1024 1025 1088 1120 768 769 800 801 0x0 0x0
[   27.792393] [drm:drm_crtc_helper_set_config], encoder changed, full mode switch
[   27.792397] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   27.792402] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[   27.792406] [drm:drm_crtc_helper_set_config], [CONNECTOR:14:SVIDEO-1] to [CRTC:4]
[   27.792411] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[   27.792415] [drm:drm_mode_debug_printmodeline], Modeline 54:"1024x768" 0 26886 1024 1025 1088 1120 768 769 800 801 0x0 0x0
[   27.792424] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[   27.792431] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   27.802588] [drm:intel_update_watermarks], plane A (pipe 0) clock: 65000
[   27.802593] [drm:i965_update_wm], self-refresh watermark: display plane 448 cursor 32
[   27.802598] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 448
[   27.802843] [drm:intel_crtc_mode_set], Mode for pipe B:
[   27.802847] [drm:drm_mode_debug_printmodeline], Modeline 54:"1024x768" 0 26886 1024 1025 1088 1120 768 769 800 801 0x0 0x0
[   27.803321] [drm:intel_pipe_set_base], Writing base 00D00000 00000000 0 0 4096
[   27.803326] [drm:intel_update_fbc], 
[   27.803330] [drm:intel_update_fbc], 2 pipes active
[   27.803334] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   27.803338] [drm:intel_update_fbc], unsupported config, disabling FBC
[   27.803343] [drm:i8xx_disable_fbc], disabled FBC
[   27.854026] [drm:intel_wait_for_vblank], vblank wait timed out
[   27.854031] [drm:intel_update_watermarks], plane A (pipe 0) clock: 65000
[   27.854036] [drm:i965_update_wm], self-refresh watermark: display plane 448 cursor 32
[   27.854040] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 448
[   27.854046] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set [MODE:54:1024x768]
[   27.869073] [drm:intel_update_watermarks], plane A (pipe 0) clock: 65000
[   27.869078] [drm:intel_update_watermarks], plane B (pipe 1) clock: 26886
[   27.869082] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   27.869111] [drm:intel_update_fbc], 
[   27.869115] [drm:intel_update_fbc], 2 pipes active
[   27.869118] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   28.040121] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   28.511632] [drm:intel_crtc_cursor_set], 
[   28.511702] [drm:intel_crtc_cursor_set], 
[   29.012147] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   30.016073] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   30.516176] [drm:intel_crtc_idle_timer], idle timer fired, downclocking
[   30.516253] [drm:intel_crtc_idle_timer], idle timer fired, downclocking
[   32.579307] EXT4-fs (sda1): re-mounted. Opts: commit=0
[   32.583630] EXT4-fs (sda3): re-mounted. Opts: commit=0
[   33.355734] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   33.355745] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   33.355751] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   33.355759] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   33.355765] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   33.355769] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   33.355792] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   33.355799] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[   33.467585] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[   33.467591] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   33.467599] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   33.467605] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   33.467612] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   33.467619] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   33.467626] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   33.467632] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   33.467639] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   33.467645] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   33.467651] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   33.467658] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   33.467664] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   33.467671] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   33.467677] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   33.467683] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   33.467689] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   33.467696] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   33.467724] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   33.467803] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   33.467810] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   33.518015] [drm:intel_wait_for_vblank], vblank wait timed out
[   33.569012] [drm:intel_wait_for_vblank], vblank wait timed out
[   33.569016] [drm:intel_tv_detect_type], No TV connection detected
[   33.569023] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[   33.569029] [drm:drm_mode_debug_printmodeline], Modeline 51:"848x480" 30 14513 848 849 912 944 480 481 512 513 0x48 0x0
[   33.569036] [drm:drm_mode_prune_invalid], Not using 848x480 mode -3
[   33.569042] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 30 11315 640 641 704 736 480 481 512 513 0x48 0x0
[   33.569049] [drm:drm_mode_prune_invalid], Not using 640x480 mode -3
[   33.569054] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 30 26886 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   33.569060] [drm:drm_mode_prune_invalid], Not using 1024x768 mode -3
[   33.569066] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 30 16998 800 801 864 896 600 601 632 633 0x40 0x0
[   33.569072] [drm:drm_mode_prune_invalid], Not using 800x600 mode -3
[   33.569095] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   33.569102] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   33.620013] [drm:intel_wait_for_vblank], vblank wait timed out
[   33.671011] [drm:intel_wait_for_vblank], vblank wait timed out
[   33.671015] [drm:intel_tv_detect_type], No TV connection detected
[   33.671022] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[   33.677667] [drm:i915_driver_irq_handler], pipe b underrun
[   33.679441] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   33.679451] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   33.679456] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   33.679464] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   33.679470] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   33.679474] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   33.679492] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   33.679498] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[   33.801972] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[   33.801978] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   33.801985] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   33.801992] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   33.801999] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   33.802026] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   33.802032] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   33.802039] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   33.802045] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   33.802052] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   33.802058] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   33.802065] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   33.802071] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   33.802077] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   33.802084] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   33.802091] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   33.802098] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   33.802105] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   33.802141] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   33.803231] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   33.803239] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   33.854026] [drm:intel_wait_for_vblank], vblank wait timed out
[   33.905012] [drm:intel_wait_for_vblank], vblank wait timed out
[   33.905016] [drm:intel_tv_detect_type], No TV connection detected
[   33.905022] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[   33.905038] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   33.905044] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   33.956011] [drm:intel_wait_for_vblank], vblank wait timed out
[   34.007011] [drm:intel_wait_for_vblank], vblank wait timed out
[   34.007015] [drm:intel_tv_detect_type], No TV connection detected
[   34.007020] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[   34.068096] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   34.068107] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   34.068112] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   34.068121] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   34.068126] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   34.068131] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   34.068150] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   34.068157] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[   34.186599] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[   34.186605] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   34.186612] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   34.186619] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   34.186626] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   34.186632] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   34.186639] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   34.186646] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   34.186652] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   34.186659] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   34.186665] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   34.186671] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   34.186678] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   34.186684] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   34.186691] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   34.186697] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   34.186703] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   34.186710] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   34.186734] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   34.187713] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   34.187722] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   34.238011] [drm:intel_wait_for_vblank], vblank wait timed out
[   34.289012] [drm:intel_wait_for_vblank], vblank wait timed out
[   34.289016] [drm:intel_tv_detect_type], No TV connection detected
[   34.289021] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[   34.289038] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   34.289044] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   34.340011] [drm:intel_wait_for_vblank], vblank wait timed out
[   34.391012] [drm:intel_wait_for_vblank], vblank wait timed out
[   34.391017] [drm:intel_tv_detect_type], No TV connection detected
[   34.391023] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[   34.954380] [drm:intel_update_watermarks], plane A (pipe 0) clock: 65000
[   34.954388] [drm:i965_update_wm], self-refresh watermark: display plane 448 cursor 32
[   34.954392] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 448
[   34.954721] [drm:intel_crtc_cursor_set], 
[   34.954725] [drm:intel_crtc_cursor_set], cursor off
[   34.955037] [drm:intel_crtc_cursor_set], 
[   39.217180] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   39.718069] [drm:intel_crtc_idle_timer], idle timer fired, downclocking
[   39.718085] [drm:intel_crtc_idle_timer], idle timer fired, downclocking
[   43.833076] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   44.810288] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   44.810299] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   44.810304] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   44.810312] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   44.810318] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   44.810322] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   44.810341] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   44.810347] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[   44.920485] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[   44.920492] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   44.920499] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   44.920506] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   44.920512] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   44.920519] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   44.920525] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   44.920532] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   44.920539] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   44.920545] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   44.920551] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   44.920558] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   44.920564] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   44.920570] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   44.920577] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   44.920583] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   44.920589] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   44.920595] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   44.920627] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   44.921612] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   44.921621] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   44.921631] [drm:intel_tv_detect_type], Detected Component TV connection
[   44.921668] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] probed modes :
[   44.921674] [drm:drm_mode_debug_printmodeline], Modeline 55:"848x480" 60 29027 848 849 912 944 480 481 512 513 0x48 0x0
[   44.921681] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 60 22631 640 641 704 736 480 481 512 513 0x48 0x0
[   44.921689] [drm:drm_mode_debug_printmodeline], Modeline 57:"1920x1080" 60 134493 1920 1921 1984 2016 1080 1081 1112 1113 0x40 0x0
[   44.921696] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x1024" 60 87178 1280 1281 1344 1376 1024 1025 1056 1057 0x40 0x0
[   44.921703] [drm:drm_mode_debug_printmodeline], Modeline 56:"1280x720" 60 62105 1280 1281 1344 1376 720 721 752 753 0x40 0x0
[   44.921710] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 60 53773 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   44.921718] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 60 33996 800 801 864 896 600 601 632 633 0x40 0x0
[   44.921729] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   44.926122] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   44.926131] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   44.926136] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   44.926144] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   44.926149] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   44.926154] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   44.926170] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   44.926176] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[   45.036660] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[   45.036666] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   45.036673] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   45.036680] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   45.036687] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   45.036693] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   45.036700] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   45.036706] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   45.036713] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   45.036719] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   45.036726] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   45.036732] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   45.036738] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   45.036745] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   45.036751] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   45.036757] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   45.036764] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   45.036770] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   45.036793] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   45.037746] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   45.037754] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   45.037765] [drm:intel_tv_detect_type], Detected Component TV connection
[   45.037810] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] probed modes :
[   45.037816] [drm:drm_mode_debug_printmodeline], Modeline 55:"848x480" 60 29027 848 849 912 944 480 481 512 513 0x48 0x0
[   45.037823] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 60 22631 640 641 704 736 480 481 512 513 0x48 0x0
[   45.037830] [drm:drm_mode_debug_printmodeline], Modeline 57:"1920x1080" 60 134493 1920 1921 1984 2016 1080 1081 1112 1113 0x40 0x0
[   45.037837] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x1024" 60 87178 1280 1281 1344 1376 1024 1025 1056 1057 0x40 0x0
[   45.037844] [drm:drm_mode_debug_printmodeline], Modeline 56:"1280x720" 60 62105 1280 1281 1344 1376 720 721 752 753 0x40 0x0
[   45.037850] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 60 53773 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   45.037857] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 60 33996 800 801 864 896 600 601 632 633 0x40 0x0
[   45.037868] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   45.041558] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   45.041566] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   45.041571] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   45.041579] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   45.041585] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   45.041589] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   45.041607] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   45.041613] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[   45.154613] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[   45.154619] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   45.154626] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   45.154633] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   45.154639] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   45.154646] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   45.154652] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   45.154659] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   45.154665] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   45.154672] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   45.154678] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   45.154685] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   45.154691] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   45.154697] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   45.154704] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   45.154710] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   45.154716] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   45.154722] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   45.154923] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   45.155847] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   45.155855] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   45.155865] [drm:intel_tv_detect_type], Detected Component TV connection
[   45.155914] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] probed modes :
[   45.155919] [drm:drm_mode_debug_printmodeline], Modeline 55:"848x480" 60 29027 848 849 912 944 480 481 512 513 0x48 0x0
[   45.155927] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 60 22631 640 641 704 736 480 481 512 513 0x48 0x0
[   45.155934] [drm:drm_mode_debug_printmodeline], Modeline 57:"1920x1080" 60 134493 1920 1921 1984 2016 1080 1081 1112 1113 0x40 0x0
[   45.155941] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x1024" 60 87178 1280 1281 1344 1376 1024 1025 1056 1057 0x40 0x0
[   45.155949] [drm:drm_mode_debug_printmodeline], Modeline 56:"1280x720" 60 62105 1280 1281 1344 1376 720 721 752 753 0x40 0x0
[   45.155956] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 60 53773 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   45.155963] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 60 33996 800 801 864 896 600 601 632 633 0x40 0x0
[   45.155973] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   45.195113] [drm:intel_crtc_cursor_set], 
[   45.195125] [drm:intel_crtc_cursor_set], cursor off
[   45.195425] [drm:drm_mode_addfb], [FB:58]
[   45.195501] [drm:drm_mode_setcrtc], [CRTC:3]
[   45.195522] [drm:drm_mode_setcrtc], [CONNECTOR:12:VGA-1]
[   45.195531] [drm:drm_crtc_helper_set_config], 
[   45.195539] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:58] #connectors=1 (x y) (0 0)
[   45.195564] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   45.195574] [drm:drm_crtc_helper_set_config], [CONNECTOR:14:SVIDEO-1] to [CRTC:4]
[   45.208063] [drm:intel_pipe_set_base], Writing base 01EA3000 00000000 0 0 5120
[   45.208070] [drm:intel_update_fbc], 
[   45.208074] [drm:intel_update_fbc], 2 pipes active
[   45.208078] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   45.208148] [drm:drm_crtc_helper_set_config], 
[   45.208152] [drm:drm_crtc_helper_set_config], [CRTC:4] [NOFB] #connectors=0 (x y) (0 0)
[   45.208162] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   45.208167] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[   45.208171] [drm:drm_crtc_helper_set_config], [CONNECTOR:14:SVIDEO-1] to [NOCRTC]
[   45.208183] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   45.218340] [drm:intel_update_watermarks], plane A (pipe 0) clock: 65000
[   45.218346] [drm:i965_update_wm], self-refresh watermark: display plane 448 cursor 32
[   45.218350] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 448
[   45.218636] [drm:intel_crtc_cursor_set], 
[   45.221816] [drm:drm_mode_setcrtc], [CRTC:3]
[   45.221830] [drm:drm_mode_setcrtc], [CONNECTOR:12:VGA-1]
[   45.221834] [drm:drm_crtc_helper_set_config], 
[   45.221837] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:58] #connectors=1 (x y) (0 0)
[   45.221846] [drm:drm_crtc_helper_set_config], modes are different, full mode set
[   45.221850] [drm:drm_mode_debug_printmodeline], Modeline 53:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x0 0xa
[   45.221857] [drm:drm_mode_debug_printmodeline], Modeline 52:"" 0 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x0 0x5
[   45.221865] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   45.221871] [drm:drm_crtc_helper_set_config], [CONNECTOR:14:SVIDEO-1] to [NOCRTC]
[   45.221875] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[   45.221879] [drm:drm_mode_debug_printmodeline], Modeline 52:"" 0 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x0 0x5
[   45.221888] [drm:drm_crtc_helper_set_mode], [CRTC:3]
[   45.337303] [drm:intel_crtc_mode_set], Mode for pipe A:
[   45.337308] [drm:drm_mode_debug_printmodeline], Modeline 52:"" 0 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x0 0x5
[   45.388011] [drm:intel_wait_for_vblank], vblank wait timed out
[   45.391347] [drm:intel_pipe_set_base], Writing base 01EA3000 00000000 0 0 5120
[   45.391354] [drm:intel_update_fbc], 
[   45.391357] [drm:intel_update_fbc], 1 pipes active
[   45.391372] [drm:i8xx_enable_fbc], enabled FBC, pitch 71, yoff 0, plane 0, 
[   45.442011] [drm:intel_wait_for_vblank], vblank wait timed out
[   45.442019] [drm:drm_crtc_helper_set_mode], [ENCODER:13:DAC-13] set [MODE:52:]
[   45.442024] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   45.442029] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   45.442033] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   45.442063] [drm:intel_update_fbc], 
[   45.442066] [drm:intel_update_fbc], 1 pipes active
[   45.442071] [drm:i8xx_disable_fbc], disabled FBC
[   45.442085] [drm:i8xx_enable_fbc], enabled FBC, pitch 71, yoff 0, plane 0, 
[   45.442101] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   45.452258] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   45.452263] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   45.452267] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   46.188029] [drm:intel_crtc_idle_timer], idle timer fired, downclocking
[   48.811633] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   48.811644] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   48.811649] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   48.811657] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   48.811663] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   48.811667] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   48.811687] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   48.811693] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[   48.936324] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[   48.936330] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   48.936338] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   48.936344] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   48.936351] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   48.936357] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   48.936364] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   48.936371] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   48.936377] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   48.936383] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   48.936390] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   48.936396] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   48.936403] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   48.936409] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   48.936415] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   48.936421] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   48.936428] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   48.936434] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   48.936471] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   48.938560] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   48.938569] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   48.938583] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[   48.938595] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   48.948754] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   48.948760] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   48.948765] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   48.949024] [drm:intel_crtc_mode_set], Mode for pipe B:
[   48.949029] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   48.949489] [drm:intel_pipe_set_base], No FB bound
[   48.949493] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   48.949497] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   48.949502] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   48.949509] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set [MODE:0:NTSC 480i]
[   48.974540] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   48.974545] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   48.974550] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   48.974580] [drm:intel_update_fbc], 
[   49.025013] [drm:intel_wait_for_vblank], vblank wait timed out
[   49.076013] [drm:intel_wait_for_vblank], vblank wait timed out
[   49.127011] [drm:intel_wait_for_vblank], vblank wait timed out
[   49.127016] [drm:intel_tv_detect_type], No TV connection detected
[   49.223012] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   49.247196] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   49.247201] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   49.247206] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   49.247212] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[   49.247218] [drm:drm_mode_debug_printmodeline], Modeline 55:"848x480" 60 29027 848 849 912 944 480 481 512 513 0x48 0x0
[   49.247225] [drm:drm_mode_prune_invalid], Not using 848x480 mode -3
[   49.247234] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 60 22631 640 641 704 736 480 481 512 513 0x48 0x0
[   49.247241] [drm:drm_mode_prune_invalid], Not using 640x480 mode -3
[   49.247246] [drm:drm_mode_debug_printmodeline], Modeline 57:"1920x1080" 60 134493 1920 1921 1984 2016 1080 1081 1112 1113 0x40 0x0
[   49.247253] [drm:drm_mode_prune_invalid], Not using 1920x1080 mode -3
[   49.247258] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x1024" 60 87178 1280 1281 1344 1376 1024 1025 1056 1057 0x40 0x0
[   49.247265] [drm:drm_mode_prune_invalid], Not using 1280x1024 mode -3
[   49.247270] [drm:drm_mode_debug_printmodeline], Modeline 56:"1280x720" 60 62105 1280 1281 1344 1376 720 721 752 753 0x40 0x0
[   49.247277] [drm:drm_mode_prune_invalid], Not using 1280x720 mode -3
[   49.247282] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 60 53773 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   49.247289] [drm:drm_mode_prune_invalid], Not using 1024x768 mode -3
[   49.247294] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 60 33996 800 801 864 896 600 601 632 633 0x40 0x0
[   49.247300] [drm:drm_mode_prune_invalid], Not using 800x600 mode -3
[   49.247327] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   49.247334] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   49.247347] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[   49.247356] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   49.257513] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   49.257519] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   49.257524] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   49.257770] [drm:intel_crtc_mode_set], Mode for pipe B:
[   49.257774] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   49.258235] [drm:intel_pipe_set_base], No FB bound
[   49.258239] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   49.258244] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   49.258249] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   49.258255] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set [MODE:0:NTSC 480i]
[   49.278406] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   49.278411] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   49.278416] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   49.278445] [drm:intel_update_fbc], 
[   49.286528] [drm:intel_tv_detect_type], Detected S-Video TV connection
[   49.406709] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   49.406715] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   49.406720] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   49.406749] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] probed modes :
[   49.406754] [drm:drm_mode_debug_printmodeline], Modeline 51:"848x480" 30 14513 848 849 912 944 480 481 512 513 0x48 0x0
[   49.406761] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 30 11315 640 641 704 736 480 481 512 513 0x48 0x0
[   49.406767] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 30 26886 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   49.406773] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 30 16998 800 801 864 896 600 601 632 633 0x40 0x0
[   49.406810] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   49.406817] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   49.406826] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[   49.406836] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   49.416994] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   49.416999] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   49.417019] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   49.417265] [drm:intel_crtc_mode_set], Mode for pipe B:
[   49.417269] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   49.417729] [drm:intel_pipe_set_base], No FB bound
[   49.417733] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   49.417738] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   49.417743] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   49.417749] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set [MODE:0:NTSC 480i]
[   49.442777] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   49.442782] [drm:intel_update_watermarks], plane B (pipe 1) clock: 107520
[   49.442786] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   49.442816] [drm:intel_update_fbc], 
[   49.454034] [drm:intel_tv_detect_type], Detected Composite TV connection
[   49.574210] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   49.574216] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   49.574221] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   49.574254] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] probed modes :
[   49.574259] [drm:drm_mode_debug_printmodeline], Modeline 51:"848x480" 30 14513 848 849 912 944 480 481 512 513 0x48 0x0
[   49.574266] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 30 11315 640 641 704 736 480 481 512 513 0x48 0x0
[   49.574272] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 30 26886 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   49.574279] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 30 16998 800 801 864 896 600 601 632 633 0x40 0x0
[   49.574309] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   49.598932] [drm:intel_crtc_cursor_set], 
[   49.598937] [drm:intel_crtc_cursor_set], cursor off
[   49.601606] [drm:drm_mode_addfb], [FB:55]
[   49.601655] [drm:drm_mode_setcrtc], [CRTC:3]
[   49.601665] [drm:drm_mode_setcrtc], [CONNECTOR:12:VGA-1]
[   49.601669] [drm:drm_crtc_helper_set_config], 
[   49.601673] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:55] #connectors=1 (x y) (0 0)
[   49.601684] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   49.618051] [drm:intel_pipe_set_base], Writing base 043A3000 00000000 0 0 8704
[   49.618059] [drm:intel_update_fbc], 
[   49.618062] [drm:intel_update_fbc], 1 pipes active
[   49.618066] [drm:intel_update_fbc], framebuffer too large, disabling compression
[   49.618071] [drm:intel_update_fbc], unsupported config, disabling FBC
[   49.618076] [drm:i8xx_disable_fbc], disabled FBC
[   49.623558] [drm:intel_crtc_cursor_set], 
[   49.624317] [drm:drm_mode_setcrtc], [CRTC:4]
[   49.624331] [drm:drm_mode_setcrtc], [CONNECTOR:14:SVIDEO-1]
[   49.624335] [drm:drm_crtc_helper_set_config], 
[   49.624339] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:55] #connectors=1 (x y) (1280 0)
[   49.624349] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[   49.624353] [drm:drm_crtc_helper_set_config], modes are different, full mode set
[   49.624358] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[   49.624365] [drm:drm_mode_debug_printmodeline], Modeline 57:"" 0 14513 848 849 912 944 480 481 512 513 0x0 0x0
[   49.624372] [drm:drm_crtc_helper_set_config], encoder changed, full mode switch
[   49.624377] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   49.624381] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[   49.624385] [drm:drm_crtc_helper_set_config], [CONNECTOR:14:SVIDEO-1] to [CRTC:4]
[   49.624390] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[   49.624394] [drm:drm_mode_debug_printmodeline], Modeline 57:"" 0 14513 848 849 912 944 480 481 512 513 0x0 0x0
[   49.624403] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[   49.624413] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   49.634571] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   49.634577] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   49.634581] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   49.634828] [drm:intel_crtc_mode_set], Mode for pipe B:
[   49.634832] [drm:drm_mode_debug_printmodeline], Modeline 57:"" 0 14513 848 849 912 944 480 481 512 513 0x0 0x0
[   49.635295] [drm:intel_pipe_set_base], Writing base 043A3000 00001400 1280 0 8704
[   49.635301] [drm:intel_update_fbc], 
[   49.635305] [drm:intel_update_fbc], 2 pipes active
[   49.635308] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   49.637014] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   49.637019] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   49.637023] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   49.637029] [drm:drm_crtc_helper_set_mode], [ENCODER:15:TV-15] set [MODE:57:]
[   49.647059] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   49.647064] [drm:intel_update_watermarks], plane B (pipe 1) clock: 14513
[   49.647069] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   49.647098] [drm:intel_update_fbc], 
[   49.647102] [drm:intel_update_fbc], 2 pipes active
[   49.647106] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   49.647167] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   49.647173] [drm:intel_update_watermarks], plane B (pipe 1) clock: 14513
[   49.647177] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 1
[   49.647206] [drm:intel_update_fbc], 
[   49.647210] [drm:intel_update_fbc], 2 pipes active
[   49.647213] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   49.647335] [drm:intel_crtc_cursor_set], 
[   49.647338] [drm:intel_crtc_cursor_set], cursor off
[   52.820035] [drm:intel_crtc_idle_timer], idle timer fired, downclocking
[   52.820047] [drm:intel_crtc_idle_timer], idle timer fired, downclocking
[   55.317180] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   56.339129] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   57.338107] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   58.333179] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   60.326147] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   61.327171] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   65.319182] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   66.319181] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   68.321107] [drm:intel_gpu_idle_timer], idle timer fired, downclocking
[   72.736675] [drm:intel_crtc_cursor_set], 
[   72.736680] [drm:intel_crtc_cursor_set], cursor off
[   74.239426] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   74.239447] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   74.239459] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   74.239477] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   74.239490] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   74.239500] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] disconnected
[   74.239537] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   74.239551] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[   74.354564] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] probed modes :
[   74.354571] [drm:drm_mode_debug_printmodeline], Modeline 29:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   74.354578] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   74.354585] [drm:drm_mode_debug_printmodeline], Modeline 30:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   74.354591] [drm:drm_mode_debug_printmodeline], Modeline 46:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   74.354598] [drm:drm_mode_debug_printmodeline], Modeline 40:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   74.354604] [drm:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   74.354611] [drm:drm_mode_debug_printmodeline], Modeline 42:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   74.354618] [drm:drm_mode_debug_printmodeline], Modeline 43:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   74.354624] [drm:drm_mode_debug_printmodeline], Modeline 45:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   74.354630] [drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   74.354637] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   74.354643] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   74.354649] [drm:drm_mode_debug_printmodeline], Modeline 35:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   74.354656] [drm:drm_mode_debug_printmodeline], Modeline 34:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   74.354662] [drm:drm_mode_debug_printmodeline], Modeline 36:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   74.354669] [drm:drm_mode_debug_printmodeline], Modeline 37:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   74.354675] [drm:drm_mode_debug_printmodeline], Modeline 38:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   74.354742] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   74.355835] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   74.355844] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   74.406012] [drm:intel_wait_for_vblank], vblank wait timed out
[   74.457011] [drm:intel_wait_for_vblank], vblank wait timed out
[   74.457015] [drm:intel_tv_detect_type], No TV connection detected
[   74.457021] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[   74.457027] [drm:drm_mode_debug_printmodeline], Modeline 51:"848x480" 30 14513 848 849 912 944 480 481 512 513 0x48 0x0
[   74.457034] [drm:drm_mode_prune_invalid], Not using 848x480 mode -3
[   74.457040] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" 30 11315 640 641 704 736 480 481 512 513 0x48 0x0
[   74.457047] [drm:drm_mode_prune_invalid], Not using 640x480 mode -3
[   74.457052] [drm:drm_mode_debug_printmodeline], Modeline 50:"1024x768" 30 26886 1024 1025 1088 1120 768 769 800 801 0x40 0x0
[   74.457059] [drm:drm_mode_prune_invalid], Not using 1024x768 mode -3
[   74.457064] [drm:drm_mode_debug_printmodeline], Modeline 49:"800x600" 30 16998 800 801 864 896 600 601 632 633 0x40 0x0
[   74.457070] [drm:drm_mode_prune_invalid], Not using 800x600 mode -3
[   74.457090] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   74.457096] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1]
[   74.508011] [drm:intel_wait_for_vblank], vblank wait timed out
[   74.559011] [drm:intel_wait_for_vblank], vblank wait timed out
[   74.559015] [drm:intel_tv_detect_type], No TV connection detected
[   74.559020] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:SVIDEO-1] disconnected
[   74.682392] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   74.682398] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   74.682403] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   74.762649] [drm:drm_mode_addfb], [FB:48]
[   74.762701] [drm:drm_mode_setcrtc], [CRTC:3]
[   74.762711] [drm:drm_mode_setcrtc], [CONNECTOR:12:VGA-1]
[   74.762715] [drm:drm_crtc_helper_set_config], 
[   74.762718] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:48] #connectors=1 (x y) (0 0)
[   74.762730] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   74.762735] [drm:drm_crtc_helper_set_config], [CONNECTOR:14:SVIDEO-1] to [CRTC:4]
[   74.770898] [drm:intel_pipe_set_base], Writing base 05C51000 00000000 0 0 5120
[   74.770906] [drm:intel_update_fbc], 
[   74.770909] [drm:intel_update_fbc], 2 pipes active
[   74.770913] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   74.770985] [drm:drm_crtc_helper_set_config], 
[   74.770989] [drm:drm_crtc_helper_set_config], [CRTC:4] [NOFB] #connectors=0 (x y) (0 0)
[   74.770999] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:3]
[   74.771032] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[   74.771036] [drm:drm_crtc_helper_set_config], [CONNECTOR:14:SVIDEO-1] to [NOCRTC]
[   74.771051] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[   74.781209] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[   74.781214] [drm:i965_update_wm], self-refresh watermark: display plane 432 cursor 32
[   74.781219] [drm:i965_update_wm], Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 432
[   75.210017] [drm:intel_crtc_idle_timer], idle timer fired, downclocking
[   76.835824] [drm:intel_crtc_cursor_set], 
[   82.012620] [drm:intel_crtc_cursor_set], 
[   82.012631] [drm:intel_crtc_cursor_set], cursor off
[   83.329179] [drm:intel_gpu_idle_timer], idle timer fired, downclocking

--=-gzrXJ7R4q/csrWnn9wGU--

