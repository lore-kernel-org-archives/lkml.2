Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab0GHWYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 18:24:09 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:57526 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754912Ab0GHWYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 18:24:07 -0400
Date: Fri, 9 Jul 2010 01:24:03 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Yinghai Lu <yinghai@kernel.org>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.35-rc* regression: ERROR: Unable to locate IOAPIC for GSI
 *
In-Reply-To: <AANLkTinwbPAsCAwrbYVj7_K-YsgKAPyjXlUlQNDZ7eqa@mail.gmail.com>
Message-ID: <alpine.SOC.1.00.1007090121300.27187@math.ut.ee>
References: <alpine.SOC.1.00.1007081644200.15817@math.ut.ee> <AANLkTinwbPAsCAwrbYVj7_K-YsgKAPyjXlUlQNDZ7eqa@mail.gmail.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Do you have bootlog for 2.6.34 with "debug apic=debug"?

Below.

> Meelis do you have a boot trace from 2.6.34?  Meelis can you confirm
> that you don't come up in XT_PIC mode in 2.6.34?

Now that was a good question. It's XT-PIC in 2.6.34 too, just the ERROR: 
lines are not there.

[    0.000000] Linux version 2.6.34 (mroos@rhn) (gcc version 4.4.4 (Debian 4.4.4-1) ) #274 PREEMPT Mon May 17 19:43:06 EEST 2010
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
[    0.000000] free_area_init_node: node 0, pgdat c134abbc, node_mem_map c13e0160
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3966 pages, LIFO batch:0
[    0.000000]   Normal zone: 992 pages used for memmap
[    0.000000]   Normal zone: 125920 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] Found and enabled local APIC!
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] nr_irqs_gsi: 16
[    0.000000] Allocating PCI resources starting at 20000000 (gap: 20000000:dfb80000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129886
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.34 root=/dev/sda3 ro debug apic=debug
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Subtract (23 early reservations)
[    0.000000]   #0 [0001000000 - 00013d9428]   TEXT DATA BSS
[    0.000000]   #1 [000009fc00 - 0000100000]   BIOS reserved
[    0.000000]   #2 [00013da000 - 00013e0140]             BRK
[    0.000000]   #3 [0000007000 - 0000008000]         PGTABLE
[    0.000000]   #4 [00013e0140 - 00017e0140]         BOOTMEM
[    0.000000]   #5 [00013d9440 - 00013d9444]         BOOTMEM
[    0.000000]   #6 [00013d9460 - 00013d94e0]         BOOTMEM
[    0.000000]   #7 [00013d94e0 - 00013d9510]         BOOTMEM
[    0.000000]   #8 [00017e0140 - 00017e1140]         BOOTMEM
[    0.000000]   #9 [00013d9520 - 00013d961c]         BOOTMEM
[    0.000000]   #10 [00013d9620 - 00013d9660]         BOOTMEM
[    0.000000]   #11 [00013d9660 - 00013d96a0]         BOOTMEM
[    0.000000]   #12 [00013d96a0 - 00013d96e0]         BOOTMEM
[    0.000000]   #13 [00013d96e0 - 00013d9720]         BOOTMEM
[    0.000000]   #14 [00013d9720 - 00013d9760]         BOOTMEM
[    0.000000]   #15 [00013d9760 - 00013d97a0]         BOOTMEM
[    0.000000]   #16 [00013d97a0 - 00013d97e0]         BOOTMEM
[    0.000000]   #17 [00013d97e0 - 00013d9820]         BOOTMEM
[    0.000000]   #18 [00013d9820 - 00013d9863]         BOOTMEM
[    0.000000]   #19 [00013d9880 - 00013d98c3]         BOOTMEM
[    0.000000]   #20 [00017e1140 - 00017e3140]         BOOTMEM
[    0.000000]   #21 [00017e3140 - 0001823140]         BOOTMEM
[    0.000000]   #22 [0001823140 - 0001843140]         BOOTMEM
[    0.000000] Memory: 515172k/524032k available (2086k kernel code, 8468k reserved, 1297k data, 272k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa4000 - 0xfffff000   ( 364 kB)
[    0.000000]     vmalloc : 0xe07c0000 - 0xfffa2000   ( 503 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xdffc0000   ( 511 MB)
[    0.000000]       .init : 0xc134e000 - 0xc1392000   ( 272 kB)
[    0.000000]       .data : 0xc120993f - 0xc134df28   (1297 kB)
[    0.000000]       .text : 0xc1000000 - 0xc120993f   (2086 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] NR_IRQS:288
[    0.000000] CPU 0 irqstacks, hard=c1319000 soft=c131a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 897.166 MHz processor.
[    0.008012] Calibrating delay loop (skipped), value calculated using timer frequency.. 1794.33 BogoMIPS (lpj=3588664)
[    0.008449] Mount-cache hash table entries: 512
[    0.008932] mce: CPU supports 5 MCE banks
[    0.009127] Performance Events: p6 PMU driver.
[    0.009297] ... version:                0
[    0.009438] ... bit width:              32
[    0.009577] ... generic registers:      2
[    0.009717] ... value mask:             00000000ffffffff
[    0.009859] ... max period:             000000007fffffff
[    0.010001] ... fixed-purpose events:   0
[    0.010142] ... event mask:             0000000000000003
[    0.010284] CPU: Intel Celeron (Coppermine) stepping 0a
[    0.010475] Checking 'hlt' instruction... OK.
[    0.024596] ACPI: Core revision 20100121
[    0.034084] ACPI: setting ELCR to 0200 (from 0e00)
[    0.035590] Enabling APIC mode:  Flat.  Using 0 I/O APICs
[    0.035739] Getting VERSION: 40011
[    0.035877] Getting VERSION: 40011
[    0.036013] Getting ID: 0
[    0.036150] Getting ID: f000000
[    0.036289] Getting LVT0: 700
[    0.036426] Getting LVT1: 400
[    0.036571] enabled ExtINT on CPU#0
[    0.036715] Using local APIC timer interrupts.
[    0.036718] calibrating APIC timer ...
[    0.040000] ... lapic delta = 623014
[    0.040000] ... PM-Timer delta = 357975
[    0.040000] ... PM-Timer result ok
[    0.040000] ..... delta 623014
[    0.040000] ..... mult: 26756575
[    0.040000] ..... calibration result: 398728
[    0.040000] ..... CPU clock speed is 897.0562 MHz.
[    0.040000] ..... host bus clock speed is 99.2728 MHz.
[    0.040000] NET: Registered protocol family 16
[    0.040000] ACPI: bus type pci registered
[    0.040000] PCI: PCI BIOS revision 2.10 entry at 0xfda95, last bus=2
[    0.040000] PCI: Using configuration type 1 for base access
[    0.047286] bio: create slab <bio-0> at 0
[    0.049119] ACPI: EC: Look up EC in DSDT
[    0.051176] ACPI: Executed 1 blocks of module-level executable AML code
[    0.060800] ACPI: Interpreter enabled
[    0.060956] ACPI: (supports S0 S5)
[    0.061148] ACPI: Using PIC for interrupt routing
[    0.083148] ACPI: Power Resource [FDDP] (off)
[    0.083399] ACPI: Power Resource [URP1] (off)
[    0.083627] ACPI: Power Resource [URP2] (off)
[    0.083857] ACPI: Power Resource [LPTP] (off)
[    0.084516] ACPI: No dock devices found.
[    0.084672] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.085686] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.087351] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.087630] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.087897] pci_root PNP0A03:00: host bridge window [mem 0x20000000-0xffefffff] (ignored)
[    0.088058] pci 0000:00:00.0: reg 10: [mem 0xf8000000-0xfbffffff pref]
[    0.088430] pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by ICH4 ACPI/GPIO/TCO
[    0.088701] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH4 GPIO
[    0.092059] pci 0000:00:1f.1: reg 20: [io  0xffa0-0xffaf]
[    0.092273] pci 0000:00:1f.2: reg 20: [io  0xef40-0xef5f]
[    0.092483] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefaf]
[    0.092694] pci 0000:00:1f.4: reg 20: [io  0xef80-0xef9f]
[    0.092886] pci 0000:00:1f.5: reg 10: [io  0xe800-0xe8ff]
[    0.093040] pci 0000:00:1f.5: reg 14: [io  0xef00-0xef3f]
[    0.093273] pci 0000:02:00.0: reg 10: [mem 0xf2000000-0xf3ffffff pref]
[    0.093428] pci 0000:02:00.0: reg 14: [mem 0xfeafc000-0xfeafffff]
[    0.093581] pci 0000:02:00.0: reg 18: [mem 0xfe000000-0xfe7fffff]
[    0.093746] pci 0000:02:00.0: reg 30: [mem 0xfeae0000-0xfeaeffff pref]
[    0.093963] pci 0000:00:01.0: PCI bridge to [bus 02-02]
[    0.094112] pci 0000:00:01.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.094264] pci 0000:00:01.0:   bridge window [mem 0xfda00000-0xfeafffff]
[    0.094416] pci 0000:00:01.0:   bridge window [mem 0xf1700000-0xf57fffff pref]
[    0.094740] pci 0000:01:08.0: reg 10: [mem 0xfd9f5000-0xfd9f5fff]
[    0.094894] pci 0000:01:08.0: reg 14: [io  0xdf00-0xdf3f]
[    0.095083] pci 0000:01:08.0: supports D1 D2
[    0.095227] pci 0000:01:08.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.095379] pci 0000:01:08.0: PME# disabled
[    0.095548] pci 0000:01:09.0: reg 10: [io  0xdf40-0xdf5f]
[    0.096013] pci 0000:01:09.0: reg 14: [mem 0xfd9f7800-0xfd9f781f]
[    0.096187] pci 0000:01:09.0: reg 30: [mem 0xfd9a0000-0xfd9affff pref]
[    0.096372] pci 0000:01:0d.0: reg 10: [io  0xdf80-0xdf9f]
[    0.096522] pci 0000:01:0d.0: reg 14: [mem 0xfd9f7c00-0xfd9f7c1f]
[    0.096694] pci 0000:01:0d.0: reg 30: [mem 0xfd9e0000-0xfd9effff pref]
[    0.096876] pci 0000:00:1e.0: PCI bridge to [bus 01-01] (subtractive decode)
[    0.097026] pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
[    0.097174] pci 0000:00:1e.0:   bridge window [mem 0xfd900000-0xfd9fffff]
[    0.097324] pci 0000:00:1e.0:   bridge window [mem 0xf1600000-0xf16fffff pref]
[    0.097588] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    0.097858] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffff] (subtractive decode)
[    0.098144] pci_bus 0000:00: on NUMA node 0
[    0.098303] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.098818] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.105490] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12)
[    0.106010] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 12)
[    0.106509] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12) *0, disabled.
[    0.107151] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12)
[    0.107650] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11 12)
[    0.108270] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11 12)
[    0.108784] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12) *0, disabled.
[    0.109433] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12)
[    0.110418] vgaarb: device added: PCI:0000:02:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.110697] vgaarb: loaded
[    0.111519] SCSI subsystem initialized
[    0.111780] libata version 3.00 loaded.
[    0.112559] PCI: Using ACPI for IRQ routing
[    0.112715] PCI: pci_cache_line_size set to 32 bytes
[    0.112956] reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
[    0.112987] reserve RAM buffer: 000000001ffc0000 - 000000001fffffff 
[    0.113686] 
[    0.113690] printing PIC contents
[    0.114095] ... PIC  IMR: fdfa
[    0.114234] ... PIC  IRR: 0c00
[    0.114377] ... PIC  ISR: 0000
[    0.114517] ... PIC ELCR: 0200
[    0.114659] printing local APIC contents on CPU#0/0:
[    0.114803] ... APIC ID:      00000000 (0)
[    0.114942] ... APIC VERSION: 00040011
[    0.115083] ... APIC TASKPRI: 00000000 (00)
[    0.115224] ... APIC ARBPRI: 00000000 (00)
[    0.115363] ... APIC PROCPRI: 00000000
[    0.115503] ... APIC LDR: 01000000
[    0.115642] ... APIC DFR: ffffffff
[    0.115780] ... APIC SPIV: 000001ff
[    0.115920] ... APIC ISR field:
[    0.116000] 0000000000000000000000000000000000000000000000000000000000000000
[    0.116000] ... APIC TMR field:
[    0.116000] 0000000000000000000000000000000000000000000000000000000000000000
[    0.116000] ... APIC IRR field:
[    0.116000] 0000000000000000000000000000000000000000000000000000000000008000
[    0.116000] ... APIC ESR: 00000000
[    0.116000] ... APIC ICR: 000c461f
[    0.116000] ... APIC ICR2: 00000000
[    0.116000] ... APIC LVTT: 000200ef
[    0.116000] ... APIC LVTPC: 00000400
[    0.116000] ... APIC LVT0: 00000700
[    0.116000] ... APIC LVT1: 00000400
[    0.116000] ... APIC LVTERR: 000000fe
[    0.116000] ... APIC TMICT: 00006158
[    0.116000] ... APIC TMCCT: 000028ac
[    0.116000] ... APIC TDCR: 00000003
[    0.116000] 
[    0.116011] number of MP IRQ sources: 0.
[    0.116153] testing the IO APIC.......................
[    0.116296] IRQ to pin mappings:
[    0.116493] .................................... done.
[    0.116672] Switching to clocksource tsc
[    0.116912] pnp: PnP ACPI init
[    0.117094] ACPI: bus type pnp registered
[    0.128095] pnp: PnP ACPI: found 13 devices
[    0.128249] ACPI: ACPI bus type pnp unregistered
[    0.128464] system 00:0c: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.128617] system 00:0c: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.128767] system 00:0c: [mem 0x00100000-0x1fffffff] could not be reserved
[    0.165504] pci 0000:00:01.0: PCI bridge to [bus 02-02]
[    0.165660] pci 0000:00:01.0:   bridge window [io  disabled]
[    0.165812] pci 0000:00:01.0:   bridge window [mem 0xfda00000-0xfeafffff]
[    0.165963] pci 0000:00:01.0:   bridge window [mem 0xf1700000-0xf57fffff pref]
[    0.166237] pci 0000:00:1e.0: PCI bridge to [bus 01-01]
[    0.166384] pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
[    0.166536] pci 0000:00:1e.0:   bridge window [mem 0xfd900000-0xfd9fffff]
[    0.166688] pci 0000:00:1e.0:   bridge window [mem 0xf1600000-0xf16fffff pref]
[    0.166981] pci 0000:00:1e.0: setting latency timer to 64
[    0.167131] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.167277] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
[    0.167426] pci_bus 0000:02: resource 1 [mem 0xfda00000-0xfeafffff]
[    0.167574] pci_bus 0000:02: resource 2 [mem 0xf1700000-0xf57fffff pref]
[    0.167724] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.167870] pci_bus 0000:01: resource 1 [mem 0xfd900000-0xfd9fffff]
[    0.168018] pci_bus 0000:01: resource 2 [mem 0xf1600000-0xf16fffff pref]
[    0.168166] pci_bus 0000:01: resource 4 [io  0x0000-0xffff]
[    0.168312] pci_bus 0000:01: resource 5 [mem 0x00000000-0xffffffff]
[    0.168566] NET: Registered protocol family 2
[    0.168813] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
[    0.169244] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.169945] TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
[    0.170411] TCP: Hash tables configured (established 16384 bind 16384)
[    0.170567] TCP reno registered
[    0.170721] UDP hash table entries: 256 (order: 0, 4096 bytes)
[    0.170893] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
[    0.171339] NET: Registered protocol family 1
[    0.171614] pci 0000:02:00.0: Boot video device
[    0.171798] pci 0000:01:08.0: Firmware left e100 interrupts enabled; disabling
[    0.172084] PCI: CLS 32 bytes, default 32
[    0.174615] VFS: Disk quotas dquot_6.5.2
[    0.174830] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.175203] msgmni has been set to 1006
[    0.176123] alg: No test for stdrng (krng)
[    0.176314] io scheduler noop registered
[    0.176530] io scheduler cfq registered (default)
[    0.190905] Non-volatile memory driver v1.3
[    0.191064] Linux agpgart interface v0.103
[    0.191263] agpgart-intel 0000:00:00.0: Intel i815 Chipset
[    0.197385] agpgart-intel 0000:00:00.0: AGP aperture is 64M @ 0xf8000000
[    0.197705] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[    0.197979] Hangcheck: Using get_cycles().
[    0.198309] [drm] Initialized drm 1.1.0 20060810
[    0.198462] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.452519] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.708506] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.710109] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.710855] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.711878] Floppy drive(s): fd0 is 1.44M
[    0.731806] FDC 0 is a post-1991 82077
[    0.733658] ata_piix 0000:00:1f.1: version 2.13
[    0.733970] ata_piix 0000:00:1f.1: setting latency timer to 64
[    0.734399] scsi0 : ata_piix
[    0.735081] scsi1 : ata_piix
[    0.738297] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    0.738460] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    0.738953] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    0.739107] e100: Copyright(c) 1999-2006 Intel Corporation
[    0.739744] ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 11
[    0.739898] PCI: setting IRQ 11 as level-triggered
[    0.740047] e100 0000:01:08.0: PCI INT A -> Link[LNKE] -> GSI 11 (level, low) -> IRQ 11
[    0.763932] e100 0000:01:08.0: PME# disabled
[    0.764746] ata2: port disabled. ignoring.
[    0.765053] e100: eth0: e100_probe: addr 0xfd9f5000, irq 11, MAC addr 00:03:47:a4:64:d5
[    0.765570] console [netcon0] enabled
[    0.765715] netconsole: network logging started
[    0.766252] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    0.769816] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.769977] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.771023] mice: PS/2 mouse device common for all mice
[    0.775007] cpuidle: using governor ladder
[    0.775160] cpuidle: using governor menu
[    0.775823] TCP cubic registered
[    0.775977] NET: Registered protocol family 17
[    0.776151] Using IPI Shortcut mode
[    0.798273] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.984900] ata1.00: ATA-6: ST380011A, 3.06, max UDMA/100
[    0.985055] ata1.00: 156301488 sectors, multi 16: LBA48 
[    1.000810] ata1.00: configured for UDMA/100
[    1.001943] scsi 0:0:0:0: Direct-Access     ATA      ST380011A        3.06 PQ: 0 ANSI: 5
[    1.003389] sd 0:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
[    1.003831] sd 0:0:0:0: [sda] Write Protect is off
[    1.003980] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.004191] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.004918]  sda: sda1 sda2 sda3 sda4
[    1.034248] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.727855] input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio1/input/input1
[    1.752996] EXT3-fs (sda3): mounted filesystem with writeback data mode
[    1.753213] VFS: Mounted root (ext3 filesystem) readonly on device 8:3.
[    1.753386] Freeing unused kernel memory: 272k freed
[    1.754584] Write protecting the kernel text: 2088k
[    1.754780] Write protecting the kernel read-only data: 1076k
[    1.755227] kjournald starting.  Commit interval 5 seconds
[    5.073675] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input2
[    5.073979] ACPI: Power Button [PBTN]
[    5.074365] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    5.074642] ACPI: Power Button [PWRF]
[    5.529403] usbcore: registered new interface driver usbfs
[    5.530706] usbcore: registered new interface driver hub
[    5.543156] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 9
[    5.543318] PCI: setting IRQ 9 as level-triggered
[    5.543468] i801_smbus 0000:00:1f.3: PCI INT B -> Link[LNKB] -> GSI 9 (level, low) -> IRQ 9
[    5.549240] usbcore: registered new device driver usb
[    5.702226] tms380tr.c: v1.10 30/12/2002 by Christoph Goos, Adam Fritzler
[    5.737960] parport_pc 00:0a: reported by Plug and Play ACPI
[    5.738172] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
[    5.822314] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.961422] uhci_hcd: USB Universal Host Controller Interface driver
[    5.962138] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    5.962300] uhci_hcd 0000:00:1f.2: PCI INT D -> Link[LNKD] -> GSI 11 (level, low) -> IRQ 11
[    5.962590] uhci_hcd 0000:00:1f.2: setting latency timer to 64
[    5.962740] uhci_hcd 0000:00:1f.2: UHCI Host Controller
[    5.962909] uhci_hcd 0000:00:1f.2: new USB bus registered, assigned bus number 1
[    5.963228] uhci_hcd 0000:00:1f.2: irq 11, io base 0x0000ef40
[    5.963502] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    5.963655] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.963924] usb usb1: Product: UHCI Host Controller
[    5.964126] usb usb1: Manufacturer: Linux 2.6.34 uhci_hcd
[    5.964274] usb usb1: SerialNumber: 0000:00:1f.2
[    5.967581] hub 1-0:1.0: USB hub found
[    5.967764] hub 1-0:1.0: 2 ports detected
[    5.968576] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 10
[    5.968735] PCI: setting IRQ 10 as level-triggered
[    5.968886] uhci_hcd 0000:00:1f.4: PCI INT C -> Link[LNKH] -> GSI 10 (level, low) -> IRQ 10
[    5.969174] uhci_hcd 0000:00:1f.4: setting latency timer to 64
[    5.969323] uhci_hcd 0000:00:1f.4: UHCI Host Controller
[    5.969491] uhci_hcd 0000:00:1f.4: new USB bus registered, assigned bus number 2
[    5.976587] uhci_hcd 0000:00:1f.4: irq 10, io base 0x0000ef80
[    5.976887] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    5.977039] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.977308] usb usb2: Product: UHCI Host Controller
[    5.977452] usb usb2: Manufacturer: Linux 2.6.34 uhci_hcd
[    5.977598] usb usb2: SerialNumber: 0000:00:1f.4
[    5.978540] hub 2-0:1.0: USB hub found
[    5.978712] hub 2-0:1.0: 2 ports detected
[    5.985995] rtc_cmos 00:02: RTC can wake from S4
[    5.988918] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    5.989124] rtc0: alarms up to one month, 114 bytes nvram
[    6.008990] tmspci.c: v1.02 23/11/2000 by Adam Fritzler
[    6.009614] ACPI: PCI Interrupt Link [LNKF] enabled at IRQ 11
[    6.009770] tmspci 0000:01:09.0: PCI INT A -> Link[LNKF] -> GSI 11 (level, low) -> IRQ 11
[    6.010658] tr%d: 3Com Token Link Velocity
[    6.010817] tr%d:    IO: 0xdf40  IRQ: 11
[    6.010969] tr%d:    Ring Station Address: 00:a0:24:61:c4:df
[    6.011852] tmspci 0000:01:0d.0: PCI INT A -> Link[LNKF] -> GSI 11 (level, low) -> IRQ 11
[    6.012271] tr%d: 3Com Token Link Velocity
[    6.012419] tr%d:    IO: 0xdf80  IRQ: 11
[    6.012570] tr%d:    Ring Station Address: 00:a0:24:61:bd:96
[    6.012741] ------------[ cut here ]------------
[    6.012899] WARNING: at fs/proc/generic.c:598 proc_register+0x14a/0x18b()
[    6.013047] Hardware name:         
[    6.013187] proc_dir_entry '11/tr%d' already registered
[    6.013331] Modules linked in: tmspci(+) rtc_cmos uhci_hcd ehci_hcd soundcore parport_pc tms380tr rtc_core rtc_lib tr parport snd_page_alloc evdev i2c_i801 usbcore button processor
[    6.013955] Pid: 462, comm: modprobe Not tainted 2.6.34 #274
[    6.014101] Call Trace:
[    6.014261]  [<c101ccde>] warn_slowpath_common+0x65/0x7c
[    6.014410]  [<c10a0bcb>] ? proc_register+0x14a/0x18b
[    6.014558]  [<c101cd29>] warn_slowpath_fmt+0x24/0x27
[    6.014704]  [<c10a0bcb>] proc_register+0x14a/0x18b
[    6.014852]  [<c10a0d8b>] proc_mkdir_mode+0x2f/0x43
[    6.014996]  [<c10a0dae>] proc_mkdir+0xf/0x11
[    6.015145]  [<c104188c>] register_handler_proc+0xd5/0xf5
[    6.015311]  [<c103ffae>] __setup_irq+0x224/0x2cb
[    6.015460]  [<c104040a>] request_threaded_irq+0xd2/0x128
[    6.015618]  [<e08f21ef>] ? tms380tr_interrupt+0x0/0xeb1 [tms380tr]
[    6.015776]  [<e0989291>] tms_pci_attach+0x1c5/0x232 [tmspci]
[    6.015934]  [<c10f5062>] local_pci_probe+0xe/0x10
[    6.016110]  [<c10f522b>] pci_device_probe+0x43/0x66
[    6.016267]  [<c11512b8>] driver_probe_device+0x77/0xea
[    6.016416]  [<c115136e>] __driver_attach+0x43/0x5f
[    6.016564]  [<c1150cba>] bus_for_each_dev+0x3d/0x67
[    6.016710]  [<c1151193>] driver_attach+0x14/0x16
[    6.016856]  [<c115132b>] ? __driver_attach+0x0/0x5f
[    6.017131]  [<c1150765>] bus_add_driver+0x94/0x1c4
[    6.017285]  [<c115159e>] driver_register+0x7c/0xe3
[    6.017436]  [<c10f5409>] __pci_register_driver+0x31/0x8e
[    6.017590]  [<e098c000>] ? tms_pci_init+0x0/0x19 [tmspci]
[    6.017740]  [<e098c017>] tms_pci_init+0x17/0x19 [tmspci]
[    6.017891]  [<c100104b>] do_one_initcall+0x4b/0x130
[    6.018042]  [<c103e6f1>] sys_init_module+0xa7/0x1de
[    6.018191]  [<c1002717>] sysenter_do_call+0x12/0x26
[    6.018339] ---[ end trace 1c1db93f909cde7e ]---
[    7.525915] Intel ICH 0000:00:1f.5: PCI INT B -> Link[LNKB] -> GSI 9 (level, low) -> IRQ 9
[    7.526235] Intel ICH 0000:00:1f.5: setting latency timer to 64
[    8.148055] intel8x0_measure_ac97_clock: measured 55810 usecs (3126 samples)
[    8.148224] intel8x0: clocking to 41134
[    9.336125] Adding 1004056k swap on /dev/sda2.  Priority:-1 extents:1 across:1004056k 
[    9.638829] EXT3-fs (sda3): using internal journal
[    9.886421] NTFS driver 2.1.29 [Flags: R/W MODULE].
[   10.083811] usbcore: registered new interface driver libusual
[   10.119234] Initializing USB Mass Storage driver...
[   10.120574] usbcore: registered new interface driver usb-storage
[   10.120738] USB Mass Storage support registered.
[   10.187632] smsc47m1: Found SMSC LPC47M10x/LPC47M112/LPC47M13x
[   10.187819] ACPI: resource smsc47m1 [io  0x0804] conflicts with ACPI region RNT3 [??? 0x00000804 flags 0x33]
[   10.188134] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   11.069245] kjournald starting.  Commit interval 5 seconds
[   11.069593] EXT3-fs (sda4): using internal journal
[   11.069765] EXT3-fs (sda4): mounted filesystem with writeback data mode
[   13.004194] e100: eth0 NIC Link is Up 100 Mbps Full Duplex
[   18.625138] NET: Registered protocol family 10
[   18.625732] lo: Disabled Privacy Extensions
[   20.957755] RPC: Registered udp transport module.
[   20.958036] RPC: Registered tcp transport module.
[   20.958178] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   21.261975] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   22.049717] fuse init (API version 7.13)
[   23.045741] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input4
[   24.067823] svc: failed to register lockdv1 RPC service (errno 97).
[   24.075639] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   24.105691] NFSD: starting 90-second grace period
[   29.548031] eth0: no IPv6 routers present
[   31.462646] lp0: using parport0 (interrupt-driven).
[   31.498984] ppdev: user-space parallel port driver
[   39.808185] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[   39.808207] pci 0000:02:00.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
[   39.815022] [drm] Initialized mga 3.2.1 20051102 for 0000:02:00.0 on minor 0
[   39.817031] agpgart-intel 0000:00:00.0: AGP 2.0 bridge
[   39.817075] agpgart-intel 0000:00:00.0: putting AGP V2 device into 2x mode
[   39.817113] pci 0000:02:00.0: putting AGP V2 device into 2x mode
[   39.880149] [drm] Initialized card for AGP DMA.
[   39.949998] platform mga_warp.0: firmware: requesting matrox/g400_warp.fw
[   51.797834] agpgart-intel 0000:00:00.0: AGP 2.0 bridge
[   51.797878] agpgart-intel 0000:00:00.0: putting AGP V2 device into 2x mode
[   51.797915] pci 0000:02:00.0: putting AGP V2 device into 2x mode
[   51.860952] [drm] Initialized card for AGP DMA.
[   51.865590] platform mga_warp.0: firmware: requesting matrox/g400_warp.fw


-- 
Meelis Roos (mroos@linux.ee)
