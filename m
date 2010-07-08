Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018Ab0GHORB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 10:17:01 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:45586 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756544Ab0GHOQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 10:16:58 -0400
X-Greylist: delayed 1407 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jul 2010 10:16:57 EDT
Date: Thu, 8 Jul 2010 16:53:25 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: 2.6.35-rc* regression: ERROR: Unable to locate IOAPIC for GSI *
Message-ID: <alpine.SOC.1.00.1007081644200.15817@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just tried 2.6.35-rc4-00086-g2aa72f6 on Celeron 900 + i815 chipset PC.
I get these errors during bootup, and all interrupts become XT-PIC:

[    0.087302] pnp: PnP ACPI init
[    0.087482] ACPI: bus type pnp registered
[    0.087999] ERROR: Unable to locate IOAPIC for GSI 8
[    0.087999] ERROR: Unable to locate IOAPIC for GSI 13
[    0.087999] ERROR: Unable to locate IOAPIC for GSI 12
[    0.088091] ERROR: Unable to locate IOAPIC for GSI 1
[    0.089013] ERROR: Unable to locate IOAPIC for GSI 6
[    0.090612] ERROR: Unable to locate IOAPIC for GSI 4
[    0.092235] ERROR: Unable to locate IOAPIC for GSI 3
[    0.094382] ERROR: Unable to locate IOAPIC for GSI 7
[    0.097470] pnp: PnP ACPI: found 13 devices
[    0.097625] ACPI: ACPI bus type pnp unregistered

2.6.35-rc2-00001-g386f40c behaves the same.

2.6.34 worked fine, it reports just
[    0.104513] pnp: PnP ACPI init
[    0.104683] ACPI: bus type pnp registered
[    0.116002] pnp: PnP ACPI: found 13 devices
[    0.116158] ACPI: ACPI bus type pnp unregistered

Will bisect but it takes some time.

Full dmesg:
[    0.000000] Linux version 2.6.35-rc4-00086-g2aa72f6 (mroos@rhn) (gcc version 4.4.4 (Debian 4.4.4-6) ) #280 PREEMPT Thu Jul 8 16:15:55 EEST 2010
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001ffc0000 (usable)
[    0.000000]  BIOS-e820: 000000001ffc0000 - 000000001fff8000 (ACPI data)
[    0.000000]  BIOS-e820: 000000001fff8000 - 0000000020000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000ffb80000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!
[    0.000000] DMI 2.3 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x1ffc0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FE0000000 write-back
[    0.000000]   1 base 020000000 mask FFFF00000 write-back
[    0.000000]   2 base 020000000 mask FFFF00000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 512MB, type WB
[    0.000000] reg 1, base: 512MB, range: 1MB, type WB
[    0.000000] reg 2, base: 512MB, range: 1MB, type UC
[    0.000000] total RAM covered: 512M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 64K 	num_reg: 1  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 512MB, type WB
[    0.000000] initial memory mapped : 0 - 01800000
[    0.000000] init_memory_mapping: 0000000000000000-000000001ffc0000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 001fc00000 page 2M
[    0.000000]  001fc00000 - 001ffc0000 page 4k
[    0.000000] kernel direct mapping tables up to 1ffc0000 @ 7000-c000
[    0.000000] ACPI: RSDP 000ff980 00014 (v00 AMI   )
[    0.000000] ACPI: RSDT 1fff0000 0002C (v01 D815EA D815EEA2 20021106 MSFT 00001011)
[    0.000000] ACPI: FACP 1fff1000 00074 (v01 D815EA EA81510A 20021106 MSFT 00001011)
[    0.000000] ACPI: DSDT 1ffe0000 030E4 (v01 D815E2 EA81520A 00000023 MSFT 0100000B)
[    0.000000] ACPI: FACS 1fff8000 00040
[    0.000000] ACPI: SSDT 1ffe30e4 00035 (v01 D815EA EA81510A 00000015 MSFT 0100000B)
[    0.000000] 511MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 1ffc0000
[    0.000000]   low ram: 0 - 1ffc0000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x0001ffc0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0001ffc0
[    0.000000] On node 0 totalpages: 130910
[    0.000000] free_area_init_node: node 0, pgdat c135ec94, node_mem_map c13f6160
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3966 pages, LIFO batch:0
[    0.000000]   Normal zone: 992 pages used for memmap
[    0.000000]   Normal zone: 125920 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] Found and enabled local APIC!
[    0.000000] nr_irqs_gsi: 16
[    0.000000] Allocating PCI resources starting at 20000000 (gap: 20000000:dfb80000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129886
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.35-rc4-00086-g2aa72f6 root=/dev/sda3 ro
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Subtract (23 early reservations)
[    0.000000]   #0 [0001000000 - 00013eff30]   TEXT DATA BSS
[    0.000000]   #1 [000009fc00 - 0000100000]   BIOS reserved
[    0.000000]   #2 [00013f0000 - 00013f6140]             BRK
[    0.000000]   #3 [0000007000 - 0000008000]         PGTABLE
[    0.000000]   #4 [00013f6140 - 00017f6140]         BOOTMEM
[    0.000000]   #5 [00013eff40 - 00013eff44]         BOOTMEM
[    0.000000]   #6 [00013eff60 - 00013effe0]         BOOTMEM
[    0.000000]   #7 [00017f6140 - 00017f6170]         BOOTMEM
[    0.000000]   #8 [00017f6180 - 00017f7180]         BOOTMEM
[    0.000000]   #9 [00017f7180 - 00017f727c]         BOOTMEM
[    0.000000]   #10 [00017f7280 - 00017f72c0]         BOOTMEM
[    0.000000]   #11 [00017f72c0 - 00017f7300]         BOOTMEM
[    0.000000]   #12 [00017f7300 - 00017f7340]         BOOTMEM
[    0.000000]   #13 [00017f7340 - 00017f7380]         BOOTMEM
[    0.000000]   #14 [00017f7380 - 00017f73c0]         BOOTMEM
[    0.000000]   #15 [00017f73c0 - 00017f7400]         BOOTMEM
[    0.000000]   #16 [00017f7400 - 00017f7440]         BOOTMEM
[    0.000000]   #17 [00017f7440 - 00017f7480]         BOOTMEM
[    0.000000]   #18 [00017f7480 - 00017f74c5]         BOOTMEM
[    0.000000]   #19 [00017f74e0 - 00017f7525]         BOOTMEM
[    0.000000]   #20 [00017f7540 - 00017f9540]         BOOTMEM
[    0.000000]   #21 [00017f9540 - 0001839540]         BOOTMEM
[    0.000000]   #22 [0001839540 - 0001859540]         BOOTMEM
[    0.000000] Memory: 515084k/524032k available (2129k kernel code, 8556k reserved, 1334k data, 276k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa3000 - 0xfffff000   ( 368 kB)
[    0.000000]     vmalloc : 0xe07c0000 - 0xfffa1000   ( 503 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xdffc0000   ( 511 MB)
[    0.000000]       .init : 0xc1363000 - 0xc13a8000   ( 276 kB)
[    0.000000]       .data : 0xc12147e5 - 0xc13620e0   (1334 kB)
[    0.000000]       .text : 0xc1000000 - 0xc12147e5   (2129 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] NR_IRQS:288
[    0.000000] CPU 0 irqstacks, hard=c132c000 soft=c132d000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 897.199 MHz processor.
[    0.008014] Calibrating delay loop (skipped), value calculated using timer frequency.. 1794.39 BogoMIPS (lpj=3588796)
[    0.008302] pid_max: default: 32768 minimum: 301
[    0.008596] Mount-cache hash table entries: 512
[    0.009103] mce: CPU supports 5 MCE banks
[    0.009295] Performance Events: p6 PMU driver.
[    0.009465] ... version:                0
[    0.009605] ... bit width:              32
[    0.009744] ... generic registers:      2
[    0.009884] ... value mask:             00000000ffffffff
[    0.010028] ... max period:             000000007fffffff
[    0.010171] ... fixed-purpose events:   0
[    0.010310] ... event mask:             0000000000000003
[    0.010453] CPU: Intel Celeron (Coppermine) stepping 0a
[    0.012080] ACPI: Core revision 20100428
[    0.019677] ACPI: setting ELCR to 0200 (from 0e00)
[    0.021087] Enabling APIC mode:  Flat.  Using 0 I/O APICs
[    0.024000] NET: Registered protocol family 16
[    0.024000] ACPI: bus type pci registered
[    0.024000] PCI: PCI BIOS revision 2.10 entry at 0xfda95, last bus=2
[    0.024000] PCI: Using configuration type 1 for base access
[    0.030881] bio: create slab <bio-0> at 0
[    0.032711] ACPI: EC: Look up EC in DSDT
[    0.034633] ACPI: Executed 1 blocks of module-level executable AML code
[    0.044199] ACPI: Interpreter enabled
[    0.044353] ACPI: (supports S0 S5)
[    0.044547] ACPI: Using PIC for interrupt routing
[    0.065635] ACPI: Power Resource [FDDP] (off)
[    0.065881] ACPI: Power Resource [URP1] (off)
[    0.066112] ACPI: Power Resource [URP2] (off)
[    0.066350] ACPI: Power Resource [LPTP] (off)
[    0.066993] ACPI: No dock devices found.
[    0.067152] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.068202] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.070559] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.070570] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.070579] pci_root PNP0A03:00: host bridge window [mem 0x20000000-0xffefffff] (ignored)
[    0.070629] pci 0000:00:00.0: reg 10: [mem 0xf8000000-0xfbffffff pref]
[    0.070862] pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by ICH4 ACPI/GPIO/TCO
[    0.071139] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH4 GPIO
[    0.071341] pci 0000:00:1f.1: reg 20: [io  0xffa0-0xffaf]
[    0.071415] pci 0000:00:1f.2: reg 20: [io  0xef40-0xef5f]
[    0.071487] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefaf]
[    0.071558] pci 0000:00:1f.4: reg 20: [io  0xef80-0xef9f]
[    0.071611] pci 0000:00:1f.5: reg 10: [io  0xe800-0xe8ff]
[    0.071624] pci 0000:00:1f.5: reg 14: [io  0xef00-0xef3f]
[    0.071718] pci 0000:02:00.0: reg 10: [mem 0xf2000000-0xf3ffffff pref]
[    0.071731] pci 0000:02:00.0: reg 14: [mem 0xfeafc000-0xfeafffff]
[    0.071743] pci 0000:02:00.0: reg 18: [mem 0xfe000000-0xfe7fffff]
[    0.071768] pci 0000:02:00.0: reg 30: [mem 0xfeae0000-0xfeaeffff pref]
[    0.071845] pci 0000:00:01.0: PCI bridge to [bus 02-02]
[    0.072020] pci 0000:00:01.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.072030] pci 0000:00:01.0:   bridge window [mem 0xfda00000-0xfeafffff]
[    0.072041] pci 0000:00:01.0:   bridge window [mem 0xf1700000-0xf57fffff pref]
[    0.072106] pci 0000:01:08.0: reg 10: [mem 0xfd9f5000-0xfd9f5fff]
[    0.072119] pci 0000:01:08.0: reg 14: [io  0xdf00-0xdf3f]
[    0.072169] pci 0000:01:08.0: supports D1 D2
[    0.072176] pci 0000:01:08.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.072186] pci 0000:01:08.0: PME# disabled
[    0.072220] pci 0000:01:09.0: reg 10: [io  0xdf40-0xdf5f]
[    0.072233] pci 0000:01:09.0: reg 14: [mem 0xfd9f7800-0xfd9f781f]
[    0.072267] pci 0000:01:09.0: reg 30: [mem 0xfd9a0000-0xfd9affff pref]
[    0.072317] pci 0000:01:0d.0: reg 10: [io  0xdf80-0xdf9f]
[    0.072330] pci 0000:01:0d.0: reg 14: [mem 0xfd9f7c00-0xfd9f7c1f]
[    0.072364] pci 0000:01:0d.0: reg 30: [mem 0xfd9e0000-0xfd9effff pref]
[    0.072407] pci 0000:00:1e.0: PCI bridge to [bus 01-01] (subtractive decode)
[    0.072562] pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
[    0.072573] pci 0000:00:1e.0:   bridge window [mem 0xfd900000-0xfd9fffff]
[    0.072583] pci 0000:00:1e.0:   bridge window [mem 0xf1600000-0xf16fffff pref]
[    0.072592] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    0.072600] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffff] (subtractive decode)
[    0.072622] pci_bus 0000:00: on NUMA node 0
[    0.072642] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.072996] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.079345] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12)
[    0.079875] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 12)
[    0.080423] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12) *0, disabled.
[    0.081079] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12)
[    0.081592] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11 12)
[    0.082103] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11 12)
[    0.082614] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12) *0, disabled.
[    0.083267] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12)
[    0.084307] vgaarb: device added: PCI:0000:02:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.084588] vgaarb: loaded
[    0.085392] SCSI subsystem initialized
[    0.085649] libata version 3.00 loaded.
[    0.086220] PCI: Using ACPI for IRQ routing
[    0.086380] PCI: pci_cache_line_size set to 32 bytes
[    0.086487] reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
[    0.086495] reserve RAM buffer: 000000001ffc0000 - 000000001fffffff 
[    0.087056] Switching to clocksource tsc
[    0.087302] pnp: PnP ACPI init
[    0.087482] ACPI: bus type pnp registered
[    0.087999] ERROR: Unable to locate IOAPIC for GSI 8
[    0.087999] ERROR: Unable to locate IOAPIC for GSI 13
[    0.087999] ERROR: Unable to locate IOAPIC for GSI 12
[    0.088091] ERROR: Unable to locate IOAPIC for GSI 1
[    0.089013] ERROR: Unable to locate IOAPIC for GSI 6
[    0.090612] ERROR: Unable to locate IOAPIC for GSI 4
[    0.092235] ERROR: Unable to locate IOAPIC for GSI 3
[    0.094382] ERROR: Unable to locate IOAPIC for GSI 7
[    0.097470] pnp: PnP ACPI: found 13 devices
[    0.097625] ACPI: ACPI bus type pnp unregistered
[    0.097814] system 00:0c: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.097968] system 00:0c: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.098120] system 00:0c: [mem 0x00100000-0x1fffffff] could not be reserved
[    0.134386] pci 0000:00:01.0: PCI bridge to [bus 02-02]
[    0.134544] pci 0000:00:01.0:   bridge window [io  disabled]
[    0.134699] pci 0000:00:01.0:   bridge window [mem 0xfda00000-0xfeafffff]
[    0.134851] pci 0000:00:01.0:   bridge window [mem 0xf1700000-0xf57fffff pref]
[    0.135127] pci 0000:00:1e.0: PCI bridge to [bus 01-01]
[    0.135274] pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
[    0.135427] pci 0000:00:1e.0:   bridge window [mem 0xfd900000-0xfd9fffff]
[    0.135580] pci 0000:00:1e.0:   bridge window [mem 0xf1600000-0xf16fffff pref]
[    0.135873] pci 0000:00:1e.0: setting latency timer to 64
[    0.135885] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.135893] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
[    0.135902] pci_bus 0000:02: resource 1 [mem 0xfda00000-0xfeafffff]
[    0.135910] pci_bus 0000:02: resource 2 [mem 0xf1700000-0xf57fffff pref]
[    0.135918] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.135926] pci_bus 0000:01: resource 1 [mem 0xfd900000-0xfd9fffff]
[    0.135934] pci_bus 0000:01: resource 2 [mem 0xf1600000-0xf16fffff pref]
[    0.135942] pci_bus 0000:01: resource 4 [io  0x0000-0xffff]
[    0.135949] pci_bus 0000:01: resource 5 [mem 0x00000000-0xffffffff]
[    0.136077] NET: Registered protocol family 2
[    0.136329] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
[    0.136810] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.137519] TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
[    0.137978] TCP: Hash tables configured (established 16384 bind 16384)
[    0.138131] TCP reno registered
[    0.138281] UDP hash table entries: 256 (order: 0, 4096 bytes)
[    0.138450] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
[    0.138923] NET: Registered protocol family 1
[    0.139201] pci 0000:02:00.0: Boot video device
[    0.139246] pci 0000:01:08.0: Firmware left e100 interrupts enabled; disabling
[    0.139533] PCI: CLS 32 bytes, default 32
[    0.141918] VFS: Disk quotas dquot_6.5.2
[    0.142117] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.142485] msgmni has been set to 1006
[    0.143441] alg: No test for stdrng (krng)
[    0.143631] io scheduler noop registered
[    0.143823] io scheduler cfq registered (default)
[    0.157848] Non-volatile memory driver v1.3
[    0.158007] Linux agpgart interface v0.103
[    0.158280] agpgart-intel 0000:00:00.0: Intel i815 Chipset
[    0.163765] agpgart-intel 0000:00:00.0: AGP aperture is 64M @ 0xf8000000
[    0.164083] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    0.167636] Hangcheck: Using getrawmonotonic().
[    0.167980] [drm] Initialized drm 1.1.0 20060810
[    0.168132] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.420853] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.676832] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.678450] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.679202] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.680256] Floppy drive(s): fd0 is 1.44M
[    0.700128] FDC 0 is a post-1991 82077
[    0.702027] ata_piix 0000:00:1f.1: version 2.13
[    0.702194] ata_piix 0000:00:1f.1: setting latency timer to 64
[    0.702466] scsi0 : ata_piix
[    0.703188] scsi1 : ata_piix
[    0.706377] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    0.706540] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    0.707041] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    0.707197] e100: Copyright(c) 1999-2006 Intel Corporation
[    0.707833] ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 11
[    0.707984] PCI: setting IRQ 11 as level-triggered
[    0.707997] e100 0000:01:08.0: PCI INT A -> Link[LNKE] -> GSI 11 (level, low) -> IRQ 11
[    0.731041] e100 0000:01:08.0: PME# disabled
[    0.731711] ata2: port disabled. ignoring.
[    0.731872] e100 0000:01:08.0: eth0: addr 0xfd9f5000, irq 11, MAC addr 00:03:47:a4:64:d5
[    0.732387] console [netcon0] enabled
[    0.732533] netconsole: network logging started
[    0.733149] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    0.736681] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.736858] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.737902] mice: PS/2 mouse device common for all mice
[    0.738513] cpuidle: using governor ladder
[    0.738667] cpuidle: using governor menu
[    0.739331] TCP cubic registered
[    0.739487] NET: Registered protocol family 17
[    0.739662] Using IPI Shortcut mode
[    0.740488] registered taskstats version 1
[    0.761070] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.949216] ata1.00: ATA-6: ST380011A, 3.06, max UDMA/100
[    0.949373] ata1.00: 156301488 sectors, multi 16: LBA48 
[    0.965095] ata1.00: configured for UDMA/100
[    0.965593] scsi 0:0:0:0: Direct-Access     ATA      ST380011A        3.06 PQ: 0 ANSI: 5
[    0.967013] sd 0:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
[    0.967467] sd 0:0:0:0: [sda] Write Protect is off
[    0.967617] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.967697] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.968426]  sda: sda1 sda2 sda3 sda4
[    0.997973] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.826774] input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio1/input/input1
[    1.838327] EXT3-fs: barriers not enabled
[    1.849738] EXT3-fs (sda3): mounted filesystem with writeback data mode
[    1.849951] VFS: Mounted root (ext3 filesystem) readonly on device 8:3.
[    1.850124] Freeing unused kernel memory: 276k freed
[    1.851346] Write protecting the kernel text: 2132k
[    1.851542] Write protecting the kernel read-only data: 1108k
[    1.852002] kjournald starting.  Commit interval 5 seconds
[    4.931920] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input2
[    4.992541] ACPI: Power Button [PBTN]
[    4.993034] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    4.993316] ACPI: Power Button [PWRF]
[    5.211861] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 9
[    5.250913] ACPI: acpi_idle registered with cpuidle
[    5.265172] PCI: setting IRQ 9 as level-triggered
[    5.265191] i801_smbus 0000:00:1f.3: PCI INT B -> Link[LNKB] -> GSI 9 (level, low) -> IRQ 9
[    5.712440] tms380tr.c: v1.10 30/12/2002 by Christoph Goos, Adam Fritzler
[    5.722226] tmspci.c: v1.02 23/11/2000 by Adam Fritzler
[    5.722834] ACPI: PCI Interrupt Link [LNKF] enabled at IRQ 11
[    5.722991] tmspci 0000:01:09.0: PCI INT A -> Link[LNKF] -> GSI 11 (level, low) -> IRQ 11
[    5.723343] tr%d: 3Com Token Link Velocity
[    5.723487] tr%d:    IO: 0xdf40  IRQ: 11
[    5.723636] tr%d:    Ring Station Address: 00:a0:24:61:c4:df
[    5.746678] tmspci 0000:01:0d.0: PCI INT A -> Link[LNKF] -> GSI 11 (level, low) -> IRQ 11
[    5.747038] tr%d: 3Com Token Link Velocity
[    5.747183] tr%d:    IO: 0xdf80  IRQ: 11
[    5.747335] tr%d:    Ring Station Address: 00:a0:24:61:bd:96
[    5.747505] ------------[ cut here ]------------
[    5.747665] WARNING: at fs/proc/generic.c:583 proc_register+0x14a/0x18b()
[    5.747812] Hardware name:         
[    5.747953] proc_dir_entry '11/tr%d' already registered
[    5.748142] Modules linked in: evdev(+) tmspci(+) parport(+) rtc_core soundcore tms380tr tr processor rtc_lib snd_page_alloc i2c_i801 button
[    5.748584] Pid: 474, comm: modprobe Not tainted 2.6.35-rc4-00086-g2aa72f6 #280
[    5.748849] Call Trace:
[    5.749010]  [<c101db82>] warn_slowpath_common+0x65/0x7a
[    5.749160]  [<c10a4d9f>] ? proc_register+0x14a/0x18b
[    5.749308]  [<c101dbfb>] warn_slowpath_fmt+0x26/0x2a
[    5.749456]  [<c10a4d9f>] proc_register+0x14a/0x18b
[    5.749605]  [<c10a4f5f>] proc_mkdir_mode+0x2f/0x43
[    5.749752]  [<c10a4f82>] proc_mkdir+0xf/0x11
[    5.749905]  [<c1042bec>] register_handler_proc+0xd5/0xf5
[    5.750057]  [<c10412c8>] __setup_irq+0x21a/0x2c1
[    5.750205]  [<c1041708>] request_threaded_irq+0xb4/0x107
[    5.750364]  [<e08ec1f9>] ? tms380tr_interrupt+0x0/0xeb2 [tms380tr]
[    5.750521]  [<e0970291>] tms_pci_attach+0x1c5/0x232 [tmspci]
[    5.750687]  [<c10fb72e>] local_pci_probe+0xe/0x10
[    5.750834]  [<c10fb8f7>] pci_device_probe+0x43/0x66
[    5.750985]  [<c1159200>] driver_probe_device+0x7f/0xfa
[    5.751133]  [<c11592be>] __driver_attach+0x43/0x5f
[    5.751281]  [<c1158bf2>] bus_for_each_dev+0x3d/0x67
[    5.751428]  [<c11590d3>] driver_attach+0x14/0x16
[    5.751574]  [<c115927b>] ? __driver_attach+0x0/0x5f
[    5.751721]  [<c1158685>] bus_add_driver+0x94/0x1c4
[    5.751868]  [<c11594ee>] driver_register+0x7c/0xe3
[    5.752030]  [<c10fbad5>] __pci_register_driver+0x31/0x8e
[    5.752183]  [<e0973000>] ? tms_pci_init+0x0/0x19 [tmspci]
[    5.752336]  [<e0973017>] tms_pci_init+0x17/0x19 [tmspci]
[    5.752485]  [<c100104b>] do_one_initcall+0x4b/0x130
[    5.752649]  [<c103f835>] sys_init_module+0x77/0x197
[    5.752800]  [<c10026f7>] sysenter_do_call+0x12/0x26
[    5.752948] ---[ end trace 95130e7199e630e8 ]---
[    5.909760] usbcore: registered new interface driver usbfs
[    5.910975] usbcore: registered new interface driver hub
[    5.922142] usbcore: registered new device driver usb
[    6.124193] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.137039] rtc_cmos 00:02: RTC can wake from S4
[    6.137628] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    6.137815] rtc0: alarms up to one month, 114 bytes nvram
[    6.161059] parport_pc 00:0a: reported by Plug and Play ACPI
[    6.161268] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
[    6.184225] uhci_hcd: USB Universal Host Controller Interface driver
[    6.184926] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    6.195085] uhci_hcd 0000:00:1f.2: PCI INT D -> Link[LNKD] -> GSI 11 (level, low) -> IRQ 11
[    6.195389] uhci_hcd 0000:00:1f.2: setting latency timer to 64
[    6.195399] uhci_hcd 0000:00:1f.2: UHCI Host Controller
[    6.195574] uhci_hcd 0000:00:1f.2: new USB bus registered, assigned bus number 1
[    6.195891] uhci_hcd 0000:00:1f.2: irq 11, io base 0x0000ef40
[    6.196238] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    6.196392] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.196660] usb usb1: Product: UHCI Host Controller
[    6.196805] usb usb1: Manufacturer: Linux 2.6.35-rc4-00086-g2aa72f6 uhci_hcd
[    6.196953] usb usb1: SerialNumber: 0000:00:1f.2
[    6.198408] hub 1-0:1.0: USB hub found
[    6.198582] hub 1-0:1.0: 2 ports detected
[    6.204555] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 10
[    6.204719] PCI: setting IRQ 10 as level-triggered
[    6.204733] uhci_hcd 0000:00:1f.4: PCI INT C -> Link[LNKH] -> GSI 10 (level, low) -> IRQ 10
[    6.205028] uhci_hcd 0000:00:1f.4: setting latency timer to 64
[    6.205037] uhci_hcd 0000:00:1f.4: UHCI Host Controller
[    6.205217] uhci_hcd 0000:00:1f.4: new USB bus registered, assigned bus number 2
[    6.205536] uhci_hcd 0000:00:1f.4: irq 10, io base 0x0000ef80
[    6.205817] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    6.205970] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.206237] usb usb2: Product: UHCI Host Controller
[    6.206380] usb usb2: Manufacturer: Linux 2.6.35-rc4-00086-g2aa72f6 uhci_hcd
[    6.206527] usb usb2: SerialNumber: 0000:00:1f.4
[    6.213761] hub 2-0:1.0: USB hub found
[    6.213944] hub 2-0:1.0: 2 ports detected
[    7.545884] Intel ICH 0000:00:1f.5: PCI INT B -> Link[LNKB] -> GSI 9 (level, low) -> IRQ 9
[    7.546201] Intel ICH 0000:00:1f.5: setting latency timer to 64
[    8.164048] intel8x0_measure_ac97_clock: measured 55409 usecs (3102 samples)
[    8.164216] intel8x0: clocking to 41155
[    9.324468] Adding 1004056k swap on /dev/sda2.  Priority:-1 extents:1 across:1004056k 
[    9.602898] EXT3-fs (sda3): using internal journal
[    9.838929] NTFS driver 2.1.29 [Flags: R/W MODULE].
[   10.029953] usbcore: registered new interface driver libusual
[   10.059274] Initializing USB Mass Storage driver...
[   10.060610] usbcore: registered new interface driver usb-storage
[   10.060773] USB Mass Storage support registered.
[   10.114462] smsc47m1: Found SMSC LPC47M10x/LPC47M112/LPC47M13x
[   10.114643] ACPI: resource smsc47m1 [io  0x0804] conflicts with ACPI region RNT3 [??? 0x00000804 flags 0x33]
[   10.114911] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   11.003672] EXT3-fs: barriers not enabled
[   11.024441] kjournald starting.  Commit interval 5 seconds
[   11.024683] EXT3-fs (sda4): using internal journal
[   11.024859] EXT3-fs (sda4): mounted filesystem with writeback data mode
[   12.912205] e100 0000:01:08.0: eth0: NIC Link is Up 100 Mbps Full Duplex
[   14.618932] NET: Registered protocol family 10
[   14.619519] lo: Disabled Privacy Extensions
[   17.026155] RPC: Registered udp transport module.
[   17.026426] RPC: Registered tcp transport module.
[   17.026567] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   17.271947] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   18.069404] fuse init (API version 7.14)
[   19.082721] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input4
[   20.170721] svc: failed to register lockdv1 RPC service (errno 97).
[   20.179702] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   20.193587] NFSD: starting 90-second grace period
[   25.152030] eth0: no IPv6 routers present
[   27.549365] lp0: using parport0 (interrupt-driven).
[   27.588066] ppdev: user-space parallel port driver
[   35.829135] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[   35.829158] pci 0000:02:00.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
[   35.836153] [drm] Initialized mga 3.2.1 20051102 for 0000:02:00.0 on minor 0
[   35.838123] agpgart-intel 0000:00:00.0: AGP 2.0 bridge
[   35.838166] agpgart-intel 0000:00:00.0: putting AGP V2 device into 2x mode
[   35.838205] pci 0000:02:00.0: putting AGP V2 device into 2x mode
[   35.901905] [drm] Initialized card for AGP DMA.
[   47.865646] agpgart-intel 0000:00:00.0: AGP 2.0 bridge
[   47.865690] agpgart-intel 0000:00:00.0: putting AGP V2 device into 2x mode
[   47.865729] pci 0000:02:00.0: putting AGP V2 device into 2x mode
[   47.929436] [drm] Initialized card for AGP DMA.


-- 
Meelis Roos (mroos@linux.ee)
