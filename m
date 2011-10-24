Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab1JXIBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 04:01:18 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:41502 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589Ab1JXIBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 04:01:15 -0400
X-Greylist: delayed 1748 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Oct 2011 04:01:14 EDT
Date: Mon, 24 Oct 2011 10:32:03 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Ben Skeggs <bskeggs@redhat.com>
cc: Francisco Jerez <currojerez@riseup.net>, Dave Airlie <airlied@redhat.com>
Subject: nouveau KMS fails with Vanta TNT2-M64
Message-ID: <alpine.SOC.1.00.1110241019510.16192@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

got an old Nvidia card, Vanta/TNT2-M64. Without KMS, text console and X 
work fine. With modeset=1, KMS logs a lot of errors and X screen is 
garbled (mostly understabdable but vertical bands of compressed double 
image and some horizontal distortions - sorry, no camera here with me 
today). Some other nvidia and radeon cards work fine in this computer.

Kernel is 3.1-rc10-dirty (the only patch to rc10 is about ps/2 mouse 
recognition and should be irrelevant).

When trying to use KMS, I get the following dmesg:

Oct 24 10:15:36 rhn kernel: [    0.000000] Initializing cgroup subsys cpu
Oct 24 10:15:36 rhn kernel: [    0.000000] Linux version 3.1.0-rc10-dirty (mroos@rhn) (gcc version 4.6.1 (Debian 4.6.1-15) ) #4 PREEMPT Tue Oct 18 14:44:44 EEST 2011
Oct 24 10:15:36 rhn kernel: [    0.000000] BIOS-provided physical RAM map:
Oct 24 10:15:36 rhn kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Oct 24 10:15:36 rhn kernel: [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Oct 24 10:15:36 rhn kernel: [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
Oct 24 10:15:36 rhn kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 000000001ffc0000 (usable)
Oct 24 10:15:36 rhn kernel: [    0.000000]  BIOS-e820: 000000001ffc0000 - 000000001fff8000 (ACPI data)
Oct 24 10:15:36 rhn kernel: [    0.000000]  BIOS-e820: 000000001fff8000 - 0000000020000000 (ACPI NVS)
Oct 24 10:15:36 rhn kernel: [    0.000000]  BIOS-e820: 00000000ffb80000 - 00000000ffc00000 (reserved)
Oct 24 10:15:36 rhn kernel: [    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
Oct 24 10:15:36 rhn kernel: [    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
Oct 24 10:15:36 rhn kernel: [    0.000000] DMI 2.3 present.
Oct 24 10:15:36 rhn kernel: [    0.000000] DMI:                  /D815EEA2                       , BIOS EA81520A.86A.0039.P21.0211061753 11/06/2002
Oct 24 10:15:36 rhn kernel: [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
Oct 24 10:15:36 rhn kernel: [    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
Oct 24 10:15:36 rhn kernel: [    0.000000] last_pfn = 0x1ffc0 max_arch_pfn = 0x100000
Oct 24 10:15:36 rhn kernel: [    0.000000] MTRR default type: uncachable
Oct 24 10:15:36 rhn kernel: [    0.000000] MTRR fixed ranges enabled:
Oct 24 10:15:36 rhn kernel: [    0.000000]   00000-9FFFF write-back
Oct 24 10:15:36 rhn kernel: [    0.000000]   A0000-BFFFF uncachable
Oct 24 10:15:36 rhn kernel: [    0.000000]   C0000-CFFFF write-protect
Oct 24 10:15:36 rhn kernel: [    0.000000]   D0000-DFFFF uncachable
Oct 24 10:15:36 rhn kernel: [    0.000000]   E0000-FFFFF write-protect
Oct 24 10:15:36 rhn kernel: [    0.000000] MTRR variable ranges enabled:
Oct 24 10:15:36 rhn kernel: [    0.000000]   0 base 000000000 mask FE0000000 write-back
Oct 24 10:15:36 rhn kernel: [    0.000000]   1 base 020000000 mask FFFF00000 write-back
Oct 24 10:15:36 rhn kernel: [    0.000000]   2 base 020000000 mask FFFF00000 uncachable
Oct 24 10:15:36 rhn kernel: [    0.000000]   3 disabled
Oct 24 10:15:36 rhn kernel: [    0.000000]   4 disabled
Oct 24 10:15:36 rhn kernel: [    0.000000]   5 disabled
Oct 24 10:15:36 rhn kernel: [    0.000000]   6 disabled
Oct 24 10:15:36 rhn kernel: [    0.000000]   7 disabled
Oct 24 10:15:36 rhn kernel: [    0.000000] PAT not supported by CPU.
Oct 24 10:15:36 rhn kernel: [    0.000000] original variable MTRRs
Oct 24 10:15:36 rhn kernel: [    0.000000] reg 0, base: 0GB, range: 512MB, type WB
Oct 24 10:15:36 rhn kernel: [    0.000000] reg 1, base: 512MB, range: 1MB, type WB
Oct 24 10:15:36 rhn kernel: [    0.000000] reg 2, base: 512MB, range: 1MB, type UC
Oct 24 10:15:36 rhn kernel: [    0.000000] total RAM covered: 512M
Oct 24 10:15:36 rhn kernel: [    0.000000] Found optimal setting for mtrr clean up
Oct 24 10:15:36 rhn kernel: [    0.000000]  gran_size: 64K ^Ichunk_size: 64K ^Inum_reg: 1  ^Ilose cover RAM: 0G
Oct 24 10:15:36 rhn kernel: [    0.000000] New variable MTRRs
Oct 24 10:15:36 rhn kernel: [    0.000000] reg 0, base: 0GB, range: 512MB, type WB
Oct 24 10:15:36 rhn kernel: [    0.000000] initial memory mapped : 0 - 01800000
Oct 24 10:15:36 rhn kernel: [    0.000000] Base memory trampoline at [c009e000] 9e000 size 4096
Oct 24 10:15:36 rhn kernel: [    0.000000] init_memory_mapping: 0000000000000000-000000001ffc0000
Oct 24 10:15:36 rhn kernel: [    0.000000]  0000000000 - 0000400000 page 4k
Oct 24 10:15:36 rhn kernel: [    0.000000]  0000400000 - 001fc00000 page 2M
Oct 24 10:15:36 rhn kernel: [    0.000000]  001fc00000 - 001ffc0000 page 4k
Oct 24 10:15:36 rhn kernel: [    0.000000] kernel direct mapping tables up to 1ffc0000 @ 17fb000-1800000
Oct 24 10:15:36 rhn kernel: [    0.000000] ACPI: RSDP 000ff980 00014 (v00 AMI   )
Oct 24 10:15:36 rhn kernel: [    0.000000] ACPI: RSDT 1fff0000 0002C (v01 D815EA D815EEA2 20021106 MSFT 00001011)
Oct 24 10:15:36 rhn kernel: [    0.000000] ACPI: FACP 1fff1000 00074 (v01 D815EA EA81510A 20021106 MSFT 00001011)
Oct 24 10:15:36 rhn kernel: [    0.000000] ACPI: DSDT 1ffe0000 030E4 (v01 D815E2 EA81520A 00000023 MSFT 0100000B)
Oct 24 10:15:36 rhn kernel: [    0.000000] ACPI: FACS 1fff8000 00040
Oct 24 10:15:36 rhn kernel: [    0.000000] ACPI: SSDT 1ffe30e4 00035 (v01 D815EA EA81510A 00000015 MSFT 0100000B)
Oct 24 10:15:36 rhn kernel: [    0.000000] 511MB LOWMEM available.
Oct 24 10:15:36 rhn kernel: [    0.000000]   mapped low ram: 0 - 1ffc0000
Oct 24 10:15:36 rhn kernel: [    0.000000]   low ram: 0 - 1ffc0000
Oct 24 10:15:36 rhn kernel: [    0.000000] Zone PFN ranges:
Oct 24 10:15:36 rhn kernel: [    0.000000]   DMA      0x00000010 -> 0x00001000
Oct 24 10:15:36 rhn kernel: [    0.000000]   Normal   0x00001000 -> 0x0001ffc0
Oct 24 10:15:36 rhn kernel: [    0.000000] Movable zone start PFN for each node
Oct 24 10:15:36 rhn kernel: [    0.000000] early_node_map[2] active PFN ranges
Oct 24 10:15:36 rhn kernel: [    0.000000]     0: 0x00000010 -> 0x0000009f
Oct 24 10:15:36 rhn kernel: [    0.000000]     0: 0x00000100 -> 0x0001ffc0
Oct 24 10:15:36 rhn kernel: [    0.000000] On node 0 totalpages: 130895
Oct 24 10:15:36 rhn kernel: [    0.000000] free_area_init_node: node 0, pgdat c139c5a4, node_mem_map dfbc0200
Oct 24 10:15:36 rhn kernel: [    0.000000]   DMA zone: 32 pages used for memmap
Oct 24 10:15:36 rhn kernel: [    0.000000]   DMA zone: 0 pages reserved
Oct 24 10:15:36 rhn kernel: [    0.000000]   DMA zone: 3951 pages, LIFO batch:0
Oct 24 10:15:36 rhn kernel: [    0.000000]   Normal zone: 992 pages used for memmap
Oct 24 10:15:36 rhn kernel: [    0.000000]   Normal zone: 125920 pages, LIFO batch:31
Oct 24 10:15:36 rhn kernel: [    0.000000] Using APIC driver default
Oct 24 10:15:36 rhn kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x408
Oct 24 10:15:36 rhn kernel: [    0.000000] Found and enabled local APIC!
Oct 24 10:15:36 rhn kernel: [    0.000000] Allocating PCI resources starting at 20000000 (gap: 20000000:dfb80000)
Oct 24 10:15:36 rhn kernel: [    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
Oct 24 10:15:36 rhn kernel: [    0.000000] pcpu-alloc: [0] 0 
Oct 24 10:15:36 rhn kernel: [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129871
Oct 24 10:15:36 rhn kernel: [    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.1.0-rc10-dirty root=/dev/sda3 ro lapic petconsole=1980@192.168.74.17/eth0,1975@192.168.74.24/00:50:8d:91:d9:f0
Oct 24 10:15:36 rhn kernel: [    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
Oct 24 10:15:36 rhn kernel: [    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Oct 24 10:15:36 rhn kernel: [    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Oct 24 10:15:36 rhn kernel: [    0.000000] Initializing CPU#0
Oct 24 10:15:36 rhn kernel: [    0.000000] Memory: 514724k/524032k available (2366k kernel code, 8856k reserved, 1348k data, 284k init, 0k highmem)
Oct 24 10:15:36 rhn kernel: [    0.000000] virtual kernel memory layout:
Oct 24 10:15:36 rhn kernel: [    0.000000]     fixmap  : 0xfffe3000 - 0xfffff000   ( 112 kB)
Oct 24 10:15:36 rhn kernel: [    0.000000]     vmalloc : 0xe07c0000 - 0xfffe1000   ( 504 MB)
Oct 24 10:15:36 rhn kernel: [    0.000000]     lowmem  : 0xc0000000 - 0xdffc0000   ( 511 MB)
Oct 24 10:15:36 rhn kernel: [    0.000000]       .init : 0xc13a1000 - 0xc13e8000   ( 284 kB)
Oct 24 10:15:36 rhn kernel: [    0.000000]       .data : 0xc124fa56 - 0xc13a0b40   (1348 kB)
Oct 24 10:15:36 rhn kernel: [    0.000000]       .text : 0xc1000000 - 0xc124fa56   (2366 kB)
Oct 24 10:15:36 rhn kernel: [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
Oct 24 10:15:36 rhn kernel: [    0.000000] NR_IRQS:16
Oct 24 10:15:36 rhn kernel: [    0.000000] CPU 0 irqstacks, hard=df406000 soft=df408000
Oct 24 10:15:36 rhn kernel: [    0.000000] Console: colour VGA+ 80x25
Oct 24 10:15:36 rhn kernel: [    0.000000] console [tty0] enabled
Oct 24 10:15:36 rhn kernel: [    0.000000] Fast TSC calibration using PIT
Oct 24 10:15:36 rhn kernel: [    0.000000] Detected 930.445 MHz processor.
Oct 24 10:15:36 rhn kernel: [    0.008004] Calibrating delay loop (skipped), value calculated using timer frequency.. 1860.89 BogoMIPS (lpj=3721780)
Oct 24 10:15:36 rhn kernel: [    0.008300] pid_max: default: 32768 minimum: 301
Oct 24 10:15:36 rhn kernel: [    0.008564] Mount-cache hash table entries: 512
Oct 24 10:15:36 rhn kernel: [    0.008935] Initializing cgroup subsys blkio
Oct 24 10:15:36 rhn kernel: [    0.009152] mce: CPU supports 5 MCE banks
Oct 24 10:15:36 rhn kernel: [    0.009327] CPU: Intel Pentium III (Coppermine) stepping 06
Oct 24 10:15:36 rhn kernel: [    0.009538] ACPI: Core revision 20110623
Oct 24 10:15:36 rhn kernel: [    0.014597] ACPI: setting ELCR to 0200 (from 0e00)
Oct 24 10:15:36 rhn kernel: [    0.015783] Performance Events: p6 PMU driver.
Oct 24 10:15:36 rhn kernel: [    0.015956] ... version:                0
Oct 24 10:15:36 rhn kernel: [    0.016008] ... bit width:              32
Oct 24 10:15:36 rhn kernel: [    0.016155] ... generic registers:      2
Oct 24 10:15:36 rhn kernel: [    0.016302] ... value mask:             00000000ffffffff
Oct 24 10:15:36 rhn kernel: [    0.016453] ... max period:             000000007fffffff
Oct 24 10:15:36 rhn kernel: [    0.016603] ... fixed-purpose events:   0
Oct 24 10:15:36 rhn kernel: [    0.016748] ... event mask:             0000000000000003
Oct 24 10:15:36 rhn kernel: [    0.017147] NMI watchdog enabled, takes one hw-pmu counter.
Oct 24 10:15:36 rhn kernel: [    0.020001] NET: Registered protocol family 16
Oct 24 10:15:36 rhn kernel: [    0.020001] ACPI: bus type pci registered
Oct 24 10:15:36 rhn kernel: [    0.020001] PCI: PCI BIOS revision 2.10 entry at 0xfda95, last bus=2
Oct 24 10:15:36 rhn kernel: [    0.020001] PCI: Using configuration type 1 for base access
Oct 24 10:15:36 rhn kernel: [    0.025692] bio: create slab <bio-0> at 0
Oct 24 10:15:36 rhn kernel: [    0.026151] ACPI: Added _OSI(Module Device)
Oct 24 10:15:36 rhn kernel: [    0.026303] ACPI: Added _OSI(Processor Device)
Oct 24 10:15:36 rhn kernel: [    0.026452] ACPI: Added _OSI(3.0 _SCP Extensions)
Oct 24 10:15:36 rhn kernel: [    0.026602] ACPI: Added _OSI(Processor Aggregator Device)
Oct 24 10:15:36 rhn kernel: [    0.027974] ACPI: EC: Look up EC in DSDT
Oct 24 10:15:36 rhn kernel: [    0.029752] ACPI: Executed 1 blocks of module-level executable AML code
Oct 24 10:15:36 rhn kernel: [    0.036673] ACPI: Interpreter enabled
Oct 24 10:15:36 rhn kernel: [    0.036828] ACPI: (supports S0 S5)
Oct 24 10:15:36 rhn kernel: [    0.037019] ACPI: Using PIC for interrupt routing
Oct 24 10:15:36 rhn kernel: [    0.040761] ACPI: Power Resource [FDDP] (off)
Oct 24 10:15:36 rhn kernel: [    0.041617] ACPI: Power Resource [URP1] (off)
Oct 24 10:15:36 rhn kernel: [    0.042506] ACPI: Power Resource [URP2] (off)
Oct 24 10:15:36 rhn kernel: [    0.042965] ACPI: Power Resource [LPTP] (off)
Oct 24 10:15:36 rhn kernel: [    0.049109] ACPI: No dock devices found.
Oct 24 10:15:36 rhn kernel: [    0.049276] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
Oct 24 10:15:36 rhn kernel: [    0.050130] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
Oct 24 10:15:36 rhn kernel: [    0.051358] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
Oct 24 10:15:36 rhn kernel: [    0.051368] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
Oct 24 10:15:36 rhn kernel: [    0.051378] pci_root PNP0A03:00: host bridge window [mem 0x20000000-0xffefffff] (ignored)
Oct 24 10:15:36 rhn kernel: [    0.051406] pci 0000:00:00.0: [8086:1130] type 0 class 0x000600
Oct 24 10:15:36 rhn kernel: [    0.051426] pci 0000:00:00.0: reg 10: [mem 0xf8000000-0xfbffffff pref]
Oct 24 10:15:36 rhn kernel: [    0.051488] pci 0000:00:01.0: [8086:1131] type 1 class 0x000604
Oct 24 10:15:36 rhn kernel: [    0.051566] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
Oct 24 10:15:36 rhn kernel: [    0.051625] pci 0000:00:1f.0: [8086:2440] type 0 class 0x000601
Oct 24 10:15:36 rhn kernel: [    0.051722] pci 0000:00:1f.1: [8086:244b] type 0 class 0x000101
Oct 24 10:15:36 rhn kernel: [    0.051775] pci 0000:00:1f.1: reg 20: [io  0xffa0-0xffaf]
Oct 24 10:15:36 rhn kernel: [    0.051822] pci 0000:00:1f.2: [8086:2442] type 0 class 0x000c03
Oct 24 10:15:36 rhn kernel: [    0.051877] pci 0000:00:1f.2: reg 20: [io  0xef40-0xef5f]
Oct 24 10:15:36 rhn kernel: [    0.051922] pci 0000:00:1f.3: [8086:2443] type 0 class 0x000c05
Oct 24 10:15:36 rhn kernel: [    0.051977] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefaf]
Oct 24 10:15:36 rhn kernel: [    0.052110] pci 0000:00:1f.4: [8086:2444] type 0 class 0x000c03
Oct 24 10:15:36 rhn kernel: [    0.052165] pci 0000:00:1f.4: reg 20: [io  0xef80-0xef9f]
Oct 24 10:15:36 rhn kernel: [    0.052211] pci 0000:00:1f.5: [8086:2445] type 0 class 0x000401
Oct 24 10:15:36 rhn kernel: [    0.052233] pci 0000:00:1f.5: reg 10: [io  0xe800-0xe8ff]
Oct 24 10:15:36 rhn kernel: [    0.052249] pci 0000:00:1f.5: reg 14: [io  0xef00-0xef3f]
Oct 24 10:15:36 rhn kernel: [    0.052338] pci 0000:02:00.0: [10de:002d] type 0 class 0x000300
Oct 24 10:15:36 rhn kernel: [    0.052362] pci 0000:02:00.0: reg 10: [mem 0xfd000000-0xfdffffff]
Oct 24 10:15:36 rhn kernel: [    0.052376] pci 0000:02:00.0: reg 14: [mem 0xf2000000-0xf3ffffff pref]
Oct 24 10:15:36 rhn kernel: [    0.052416] pci 0000:02:00.0: reg 30: [mem 0xfeaf0000-0xfeafffff pref]
Oct 24 10:15:36 rhn kernel: [    0.052483] pci 0000:00:01.0: PCI bridge to [bus 02-02]
Oct 24 10:15:36 rhn kernel: [    0.052646] pci 0000:00:01.0:   bridge window [mem 0xfca00000-0xfeafffff]
Oct 24 10:15:36 rhn kernel: [    0.052656] pci 0000:00:01.0:   bridge window [mem 0xf0700000-0xf47fffff pref]
Oct 24 10:15:36 rhn kernel: [    0.052705] pci 0000:01:08.0: [8086:2449] type 0 class 0x000200
Oct 24 10:15:36 rhn kernel: [    0.052728] pci 0000:01:08.0: reg 10: [mem 0xfc9fe000-0xfc9fefff]
Oct 24 10:15:36 rhn kernel: [    0.052744] pci 0000:01:08.0: reg 14: [io  0xdf00-0xdf3f]
Oct 24 10:15:36 rhn kernel: [    0.052806] pci 0000:01:08.0: supports D1 D2
Oct 24 10:15:36 rhn kernel: [    0.052813] pci 0000:01:08.0: PME# supported from D0 D1 D2 D3hot D3cold
Oct 24 10:15:36 rhn kernel: [    0.052824] pci 0000:01:08.0: PME# disabled
Oct 24 10:15:36 rhn kernel: [    0.052853] pci 0000:01:0b.0: [10b5:1147] type 0 class 0x000700
Oct 24 10:15:36 rhn kernel: [    0.052874] pci 0000:01:0b.0: reg 10: [mem 0xfc9ffc00-0xfc9ffc7f]
Oct 24 10:15:36 rhn kernel: [    0.052890] pci 0000:01:0b.0: reg 14: [io  0xdc00-0xdc7f]
Oct 24 10:15:36 rhn kernel: [    0.052906] pci 0000:01:0b.0: reg 18: [io  0xdff4-0xdff7]
Oct 24 10:15:36 rhn kernel: [    0.052922] pci 0000:01:0b.0: reg 1c: [io  0xdff0-0xdff3]
Oct 24 10:15:36 rhn kernel: [    0.052954] pci 0000:01:0b.0: reg 30: [mem 0xfc9ff000-0xfc9ff7ff pref]
Oct 24 10:15:36 rhn kernel: [    0.052997] pci 0000:00:1e.0: PCI bridge to [bus 01-01] (subtractive decode)
Oct 24 10:15:36 rhn kernel: [    0.053158] pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
Oct 24 10:15:36 rhn kernel: [    0.053169] pci 0000:00:1e.0:   bridge window [mem 0xfc900000-0xfc9fffff]
Oct 24 10:15:36 rhn kernel: [    0.053180] pci 0000:00:1e.0:   bridge window [mem 0xf0600000-0xf06fffff pref]
Oct 24 10:15:36 rhn kernel: [    0.053189] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
Oct 24 10:15:36 rhn kernel: [    0.053198] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffff] (subtractive decode)
Oct 24 10:15:36 rhn kernel: [    0.053218] pci_bus 0000:00: on NUMA node 0
Oct 24 10:15:36 rhn kernel: [    0.053229] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Oct 24 10:15:36 rhn kernel: [    0.053404] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
Oct 24 10:15:36 rhn kernel: [    0.053831]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
Oct 24 10:15:36 rhn kernel: [    0.057909] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12)
Oct 24 10:15:36 rhn kernel: [    0.058330] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 12)
Oct 24 10:15:36 rhn kernel: [    0.058741] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12) *0, disabled.
Oct 24 10:15:36 rhn kernel: [    0.059296] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12)
Oct 24 10:15:36 rhn kernel: [    0.059704] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11 12)
Oct 24 10:15:36 rhn kernel: [    0.060194] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12) *0, disabled.
Oct 24 10:15:36 rhn kernel: [    0.060757] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12) *0, disabled.
Oct 24 10:15:36 rhn kernel: [    0.061319] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12)
Oct 24 10:15:36 rhn kernel: [    0.062056] vgaarb: device added: PCI:0000:02:00.0,decodes=io+mem,owns=io+mem,locks=none
Oct 24 10:15:36 rhn kernel: [    0.062346] vgaarb: loaded
Oct 24 10:15:36 rhn kernel: [    0.062492] vgaarb: bridge control possible 0000:02:00.0
Oct 24 10:15:36 rhn kernel: [    0.063108] SCSI subsystem initialized
Oct 24 10:15:36 rhn kernel: [    0.063520] libata version 3.00 loaded.
Oct 24 10:15:36 rhn kernel: [    0.063891] PCI: Using ACPI for IRQ routing
Oct 24 10:15:36 rhn kernel: [    0.064096] PCI: pci_cache_line_size set to 32 bytes
Oct 24 10:15:36 rhn kernel: [    0.064182] reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
Oct 24 10:15:36 rhn kernel: [    0.064190] reserve RAM buffer: 000000001ffc0000 - 000000001fffffff 
Oct 24 10:15:36 rhn kernel: [    0.064774] pnp: PnP ACPI init
Oct 24 10:15:36 rhn kernel: [    0.064949] ACPI: bus type pnp registered
Oct 24 10:15:36 rhn kernel: [    0.065700] pnp 00:00: [bus 00-ff]
Oct 24 10:15:36 rhn kernel: [    0.065710] pnp 00:00: [io  0x0cf8-0x0cff]
Oct 24 10:15:36 rhn kernel: [    0.065718] pnp 00:00: [io  0x0000-0x0cf7 window]
Oct 24 10:15:36 rhn kernel: [    0.065726] pnp 00:00: [io  0x0d00-0xffff window]
Oct 24 10:15:36 rhn kernel: [    0.065734] pnp 00:00: [mem 0x20000000-0xffefffff window]
Oct 24 10:15:36 rhn kernel: [    0.065945] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
Oct 24 10:15:36 rhn kernel: [    0.066075] pnp 00:01: [dma 4]
Oct 24 10:15:36 rhn kernel: [    0.066083] pnp 00:01: [io  0x0000-0x000f]
Oct 24 10:15:36 rhn kernel: [    0.066090] pnp 00:01: [io  0x0081-0x0083]
Oct 24 10:15:36 rhn kernel: [    0.066097] pnp 00:01: [io  0x0087]
Oct 24 10:15:36 rhn kernel: [    0.066103] pnp 00:01: [io  0x0089-0x008b]
Oct 24 10:15:36 rhn kernel: [    0.066110] pnp 00:01: [io  0x008f]
Oct 24 10:15:36 rhn kernel: [    0.066116] pnp 00:01: [io  0x00c0-0x00df]
Oct 24 10:15:36 rhn kernel: [    0.066242] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
Oct 24 10:15:36 rhn kernel: [    0.066279] pnp 00:02: [io  0x0070-0x0071]
Oct 24 10:15:36 rhn kernel: [    0.066289] pnp 00:02: [irq 8]
Oct 24 10:15:36 rhn kernel: [    0.066406] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
Oct 24 10:15:36 rhn kernel: [    0.066436] pnp 00:03: [io  0x0061]
Oct 24 10:15:36 rhn kernel: [    0.066546] pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
Oct 24 10:15:36 rhn kernel: [    0.066578] pnp 00:04: [io  0x00f0-0x00ff]
Oct 24 10:15:36 rhn kernel: [    0.066587] pnp 00:04: [irq 13]
Oct 24 10:15:36 rhn kernel: [    0.066698] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
Oct 24 10:15:36 rhn kernel: [    0.066810] pnp 00:05: [irq 12]
Oct 24 10:15:36 rhn kernel: [    0.066947] pnp 00:05: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
Oct 24 10:15:36 rhn kernel: [    0.067042] pnp 00:06: [io  0x0060]
Oct 24 10:15:36 rhn kernel: [    0.067050] pnp 00:06: [io  0x0064]
Oct 24 10:15:36 rhn kernel: [    0.067057] pnp 00:06: [irq 1]
Oct 24 10:15:36 rhn kernel: [    0.067196] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
Oct 24 10:15:36 rhn kernel: [    0.068123] pnp 00:07: [io  0x03f0-0x03f1]
Oct 24 10:15:36 rhn kernel: [    0.068131] pnp 00:07: [io  0x03f2-0x03f3]
Oct 24 10:15:36 rhn kernel: [    0.068139] pnp 00:07: [io  0x03f4-0x03f5]
Oct 24 10:15:36 rhn kernel: [    0.068145] pnp 00:07: [io  0x03f7]
Oct 24 10:15:36 rhn kernel: [    0.068153] pnp 00:07: [irq 6]
Oct 24 10:15:36 rhn kernel: [    0.068160] pnp 00:07: [dma 2]
Oct 24 10:15:36 rhn kernel: [    0.068384] pnp 00:07: Plug and Play ACPI device, IDs PNP0700 (active)
Oct 24 10:15:36 rhn kernel: [    0.068976] pnp 00:08: [io  0x03f8-0x03ff]
Oct 24 10:15:36 rhn kernel: [    0.068984] pnp 00:08: [irq 4]
Oct 24 10:15:36 rhn kernel: [    0.069226] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
Oct 24 10:15:36 rhn kernel: [    0.069803] pnp 00:09: [io  0x02f8-0x02ff]
Oct 24 10:15:36 rhn kernel: [    0.069813] pnp 00:09: [irq 3]
Oct 24 10:15:36 rhn kernel: [    0.070045] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
Oct 24 10:15:36 rhn kernel: [    0.070895] pnp 00:0a: [io  0x0378-0x037f]
Oct 24 10:15:36 rhn kernel: [    0.070904] pnp 00:0a: [io  0x0778-0x077f]
Oct 24 10:15:36 rhn kernel: [    0.070924] pnp 00:0a: [irq 7]
Oct 24 10:15:36 rhn kernel: [    0.070931] pnp 00:0a: [dma 3]
Oct 24 10:15:36 rhn kernel: [    0.071274] pnp 00:0a: Plug and Play ACPI device, IDs PNP0401 (active)
Oct 24 10:15:36 rhn kernel: [    0.071434] pnp 00:0b: [mem 0xfff00000-0xffffffff]
Oct 24 10:15:36 rhn kernel: [    0.071442] pnp 00:0b: [mem 0xffb00000-0xffbfffff]
Oct 24 10:15:36 rhn kernel: [    0.071593] pnp 00:0b: Plug and Play ACPI device, IDs INT0800 (active)
Oct 24 10:15:36 rhn kernel: [    0.072577] pnp 00:0c: [mem 0x00000000-0x0009ffff]
Oct 24 10:15:36 rhn kernel: [    0.072586] pnp 00:0c: [mem 0x000e0000-0x000fffff]
Oct 24 10:15:36 rhn kernel: [    0.072594] pnp 00:0c: [mem 0x00100000-0x1fffffff]
Oct 24 10:15:36 rhn kernel: [    0.072602] pnp 00:0c: [mem 0x00000000-0xffffffff disabled]
Oct 24 10:15:36 rhn kernel: [    0.072610] pnp 00:0c: [mem 0x00000000-0xffffffff disabled]
Oct 24 10:15:36 rhn kernel: [    0.072847] system 00:0c: [mem 0x00000000-0x0009ffff] could not be reserved
Oct 24 10:15:36 rhn kernel: [    0.073012] system 00:0c: [mem 0x000e0000-0x000fffff] could not be reserved
Oct 24 10:15:36 rhn kernel: [    0.073166] system 00:0c: [mem 0x00100000-0x1fffffff] could not be reserved
Oct 24 10:15:36 rhn kernel: [    0.073322] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
Oct 24 10:15:36 rhn kernel: [    0.073344] pnp: PnP ACPI: found 13 devices
Oct 24 10:15:36 rhn kernel: [    0.073490] ACPI: ACPI bus type pnp unregistered
Oct 24 10:15:36 rhn kernel: [    0.116295] Switching to clocksource acpi_pm
Oct 24 10:15:36 rhn kernel: [    0.116490] PCI: max bus depth: 1 pci_try_num: 2
Oct 24 10:15:36 rhn kernel: [    0.116525] pci 0000:00:01.0: PCI bridge to [bus 02-02]
Oct 24 10:15:36 rhn kernel: [    0.116686] pci 0000:00:01.0:   bridge window [mem 0xfca00000-0xfeafffff]
Oct 24 10:15:36 rhn kernel: [    0.116846] pci 0000:00:01.0:   bridge window [mem 0xf0700000-0xf47fffff pref]
Oct 24 10:15:36 rhn kernel: [    0.117135] pci 0000:00:1e.0: PCI bridge to [bus 01-01]
Oct 24 10:15:36 rhn kernel: [    0.117289] pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
Oct 24 10:15:36 rhn kernel: [    0.117449] pci 0000:00:1e.0:   bridge window [mem 0xfc900000-0xfc9fffff]
Oct 24 10:15:36 rhn kernel: [    0.117609] pci 0000:00:1e.0:   bridge window [mem 0xf0600000-0xf06fffff pref]
Oct 24 10:15:36 rhn kernel: [    0.117920] pci 0000:00:1e.0: setting latency timer to 64
Oct 24 10:15:36 rhn kernel: [    0.117931] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
Oct 24 10:15:36 rhn kernel: [    0.117940] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
Oct 24 10:15:36 rhn kernel: [    0.117949] pci_bus 0000:02: resource 1 [mem 0xfca00000-0xfeafffff]
Oct 24 10:15:36 rhn kernel: [    0.117957] pci_bus 0000:02: resource 2 [mem 0xf0700000-0xf47fffff pref]
Oct 24 10:15:36 rhn kernel: [    0.117966] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
Oct 24 10:15:36 rhn kernel: [    0.117974] pci_bus 0000:01: resource 1 [mem 0xfc900000-0xfc9fffff]
Oct 24 10:15:36 rhn kernel: [    0.117983] pci_bus 0000:01: resource 2 [mem 0xf0600000-0xf06fffff pref]
Oct 24 10:15:36 rhn kernel: [    0.117991] pci_bus 0000:01: resource 4 [io  0x0000-0xffff]
Oct 24 10:15:36 rhn kernel: [    0.117999] pci_bus 0000:01: resource 5 [mem 0x00000000-0xffffffff]
Oct 24 10:15:36 rhn kernel: [    0.118128] NET: Registered protocol family 2
Oct 24 10:15:36 rhn kernel: [    0.118385] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
Oct 24 10:15:36 rhn kernel: [    0.118775] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
Oct 24 10:15:36 rhn kernel: [    0.119417] TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
Oct 24 10:15:36 rhn kernel: [    0.119766] TCP: Hash tables configured (established 16384 bind 16384)
Oct 24 10:15:36 rhn kernel: [    0.119922] TCP reno registered
Oct 24 10:15:36 rhn kernel: [    0.119922] Switched to NOHz mode on CPU #0
Oct 24 10:15:36 rhn kernel: [    0.119922] UDP hash table entries: 256 (order: 0, 4096 bytes)
Oct 24 10:15:36 rhn kernel: [    0.120045] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
Oct 24 10:15:36 rhn kernel: [    0.120451] NET: Registered protocol family 1
Oct 24 10:15:36 rhn kernel: [    0.120709] pci 0000:02:00.0: Boot video device
Oct 24 10:15:36 rhn kernel: [    0.120750] pci 0000:01:08.0: Firmware left e100 interrupts enabled; disabling
Oct 24 10:15:36 rhn kernel: [    0.121038] PCI: CLS 32 bytes, default 32
Oct 24 10:15:36 rhn kernel: [    0.128302] VFS: Disk quotas dquot_6.5.2
Oct 24 10:15:36 rhn kernel: [    0.128490] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Oct 24 10:15:36 rhn kernel: [    0.128819] msgmni has been set to 1005
Oct 24 10:15:36 rhn kernel: [    0.129462] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
Oct 24 10:15:36 rhn kernel: [    0.129743] io scheduler noop registered
Oct 24 10:15:36 rhn kernel: [    0.129910] io scheduler cfq registered (default)
Oct 24 10:15:36 rhn kernel: [    0.130552] Serial: 8250/16550 driver, 16 ports, IRQ sharing enabled
Oct 24 10:15:36 rhn kernel: [    0.404079] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Oct 24 10:15:36 rhn kernel: [    0.680079] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Oct 24 10:15:36 rhn kernel: [    0.702700] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Oct 24 10:15:36 rhn kernel: [    0.723459] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Oct 24 10:15:36 rhn kernel: [    0.724282] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 10
Oct 24 10:15:36 rhn kernel: [    0.724442] PCI: setting IRQ 10 as level-triggered
Oct 24 10:15:36 rhn kernel: [    0.724456] serial 0000:01:0b.0: PCI INT A -> Link[LNKH] -> GSI 10 (level, low) -> IRQ 10
Oct 24 10:15:36 rhn kernel: [    0.724765] serial 0000:01:0b.0: PCI INT A disabled
Oct 24 10:15:36 rhn kernel: [    0.725241] Non-volatile memory driver v1.3
Oct 24 10:15:36 rhn kernel: [    0.725394] Linux agpgart interface v0.103
Oct 24 10:15:36 rhn kernel: [    0.725663] agpgart-intel 0000:00:00.0: Intel i815 Chipset
Oct 24 10:15:36 rhn kernel: [    0.730180] agpgart-intel 0000:00:00.0: AGP aperture is 64M @ 0xf8000000
Oct 24 10:15:36 rhn kernel: [    0.730451] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
Oct 24 10:15:36 rhn kernel: [    0.730733] Hangcheck: Using getrawmonotonic().
Oct 24 10:15:36 rhn kernel: [    0.731003] [drm] Initialized drm 1.1.0 20060810
Oct 24 10:15:36 rhn kernel: [    0.731442] Floppy drive(s): fd0 is 1.44M
Oct 24 10:15:36 rhn kernel: [    0.745770] FDC 0 is a post-1991 82077
Oct 24 10:15:36 rhn kernel: [    0.747932] ata_piix 0000:00:1f.1: version 2.13
Oct 24 10:15:36 rhn kernel: [    0.748128] ata_piix 0000:00:1f.1: setting latency timer to 64
Oct 24 10:15:36 rhn kernel: [    0.749209] scsi0 : ata_piix
Oct 24 10:15:36 rhn kernel: [    0.749684] scsi1 : ata_piix
Oct 24 10:15:36 rhn kernel: [    0.752430] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
Oct 24 10:15:36 rhn kernel: [    0.752596] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
Oct 24 10:15:36 rhn kernel: [    0.753125] ata2: port disabled--ignoring
Oct 24 10:15:36 rhn kernel: [    0.753261] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
Oct 24 10:15:36 rhn kernel: [    0.753418] e100: Copyright(c) 1999-2006 Intel Corporation
Oct 24 10:15:36 rhn kernel: [    0.753864] ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 11
Oct 24 10:15:36 rhn kernel: [    0.754019] PCI: setting IRQ 11 as level-triggered
Oct 24 10:15:36 rhn kernel: [    0.754032] e100 0000:01:08.0: PCI INT A -> Link[LNKE] -> GSI 11 (level, low) -> IRQ 11
Oct 24 10:15:36 rhn kernel: [    0.776944] e100 0000:01:08.0: PME# disabled
Oct 24 10:15:36 rhn kernel: [    0.777297] e100 0000:01:08.0: eth0: addr 0xfc9fe000, irq 11, MAC addr 00:03:47:a4:64:d5
Oct 24 10:15:36 rhn kernel: [    0.777969] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
Oct 24 10:15:36 rhn kernel: [    0.781497] serio: i8042 KBD port at 0x60,0x64 irq 1
Oct 24 10:15:36 rhn kernel: [    0.785027] serio: i8042 AUX port at 0x60,0x64 irq 12
Oct 24 10:15:36 rhn kernel: [    0.785692] mousedev: PS/2 mouse device common for all mice
Oct 24 10:15:36 rhn kernel: [    0.786168] rtc_cmos 00:02: RTC can wake from S4
Oct 24 10:15:36 rhn kernel: [    0.786547] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
Oct 24 10:15:36 rhn kernel: [    0.786726] rtc0: alarms up to one month, 114 bytes nvram
Oct 24 10:15:36 rhn kernel: [    0.786970] cpuidle: using governor ladder
Oct 24 10:15:36 rhn kernel: [    0.787118] cpuidle: using governor menu
Oct 24 10:15:36 rhn kernel: [    0.788604] TCP cubic registered
Oct 24 10:15:36 rhn kernel: [    0.788783] NET: Registered protocol family 17
Oct 24 10:15:36 rhn kernel: [    0.788952] Registering the dns_resolver key type
Oct 24 10:15:36 rhn kernel: [    0.789123] Using IPI Shortcut mode
Oct 24 10:15:36 rhn kernel: [    0.789673] registered taskstats version 1
Oct 24 10:15:36 rhn kernel: [    0.790246] console [netcon0] enabled
Oct 24 10:15:36 rhn kernel: [    0.790394] netconsole: network logging started
Oct 24 10:15:36 rhn kernel: [    0.790599] rtc_cmos 00:02: setting system clock to 2011-10-24 10:15:04 UTC (1319451304)
Oct 24 10:15:36 rhn kernel: [    0.806861] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
Oct 24 10:15:36 rhn kernel: [    0.972477] ata1.00: ATA-6: ST380011A, 3.06, max UDMA/100
Oct 24 10:15:36 rhn kernel: [    0.972635] ata1.00: 156301488 sectors, multi 16: LBA48 
Oct 24 10:15:36 rhn kernel: [    0.988352] ata1.00: configured for UDMA/100
Oct 24 10:15:36 rhn kernel: [    0.988795] scsi 0:0:0:0: Direct-Access     ATA      ST380011A        3.06 PQ: 0 ANSI: 5
Oct 24 10:15:36 rhn kernel: [    0.989682] sd 0:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
Oct 24 10:15:36 rhn kernel: [    0.990108] sd 0:0:0:0: [sda] Write Protect is off
Oct 24 10:15:36 rhn kernel: [    0.990262] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Oct 24 10:15:36 rhn kernel: [    0.990324] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct 24 10:15:36 rhn kernel: [    1.024153]  sda: sda1 sda2 sda3 sda4
Oct 24 10:15:36 rhn kernel: [    1.025411] sd 0:0:0:0: [sda] Attached SCSI disk
Oct 24 10:15:36 rhn kernel: [    1.124022] Refined TSC clocksource calibration: 930.314 MHz.
Oct 24 10:15:36 rhn kernel: [    1.124183] Switching to clocksource tsc
Oct 24 10:15:36 rhn kernel: [    1.742819] input: ImExPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio1/input/input1
Oct 24 10:15:36 rhn kernel: [    1.769504] EXT3-fs (sda3): mounted filesystem with writeback data mode
Oct 24 10:15:36 rhn kernel: [    1.769690] VFS: Mounted root (ext3 filesystem) readonly on device 8:3.
Oct 24 10:15:36 rhn kernel: [    1.769912] Freeing unused kernel memory: 284k freed
Oct 24 10:15:36 rhn kernel: [    1.770728] Write protecting the kernel text: 2368k
Oct 24 10:15:36 rhn kernel: [    1.770929] Write protecting the kernel read-only data: 1180k
Oct 24 10:15:36 rhn kernel: [    1.771404] kjournald starting.  Commit interval 5 seconds
Oct 24 10:15:36 rhn kernel: [    4.676506] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
Oct 24 10:15:36 rhn kernel: [    4.676811] ACPI: Power Button [PBTN]
Oct 24 10:15:36 rhn kernel: [    4.677140] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
Oct 24 10:15:36 rhn kernel: [    4.677420] ACPI: Power Button [PWRF]
Oct 24 10:15:36 rhn kernel: [    4.682527] ACPI: acpi_idle registered with cpuidle
Oct 24 10:15:36 rhn kernel: [    4.932986] parport_pc 00:0a: reported by Plug and Play ACPI
Oct 24 10:15:36 rhn kernel: [    4.933199] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
Oct 24 10:15:36 rhn kernel: [    4.987916] usbcore: registered new interface driver usbfs
Oct 24 10:15:36 rhn kernel: [    5.019160] usbcore: registered new interface driver hub
Oct 24 10:15:36 rhn kernel: [    5.023397] usbcore: registered new device driver usb
Oct 24 10:15:36 rhn kernel: [    5.069800] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Oct 24 10:15:36 rhn kernel: [    5.091429] uhci_hcd: USB Universal Host Controller Interface driver
Oct 24 10:15:36 rhn kernel: [    5.091972] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
Oct 24 10:15:36 rhn kernel: [    5.092175] uhci_hcd 0000:00:1f.2: PCI INT D -> Link[LNKD] -> GSI 11 (level, low) -> IRQ 11
Oct 24 10:15:36 rhn kernel: [    5.092468] uhci_hcd 0000:00:1f.2: setting latency timer to 64
Oct 24 10:15:36 rhn kernel: [    5.092477] uhci_hcd 0000:00:1f.2: UHCI Host Controller
Oct 24 10:15:36 rhn kernel: [    5.092643] uhci_hcd 0000:00:1f.2: new USB bus registered, assigned bus number 1
Oct 24 10:15:36 rhn kernel: [    5.092962] uhci_hcd 0000:00:1f.2: irq 11, io base 0x0000ef40
Oct 24 10:15:36 rhn kernel: [    5.093208] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
Oct 24 10:15:36 rhn kernel: [    5.093367] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct 24 10:15:36 rhn kernel: [    5.093651] usb usb1: Product: UHCI Host Controller
Oct 24 10:15:36 rhn kernel: [    5.093801] usb usb1: Manufacturer: Linux 3.1.0-rc10-dirty uhci_hcd
Oct 24 10:15:36 rhn kernel: [    5.093956] usb usb1: SerialNumber: 0000:00:1f.2
Oct 24 10:15:36 rhn kernel: [    5.094351] hub 1-0:1.0: USB hub found
Oct 24 10:15:36 rhn kernel: [    5.094510] hub 1-0:1.0: 2 ports detected
Oct 24 10:15:36 rhn kernel: [    5.094774] uhci_hcd 0000:00:1f.4: PCI INT C -> Link[LNKH] -> GSI 10 (level, low) -> IRQ 10
Oct 24 10:15:36 rhn kernel: [    5.095070] uhci_hcd 0000:00:1f.4: setting latency timer to 64
Oct 24 10:15:36 rhn kernel: [    5.095079] uhci_hcd 0000:00:1f.4: UHCI Host Controller
Oct 24 10:15:36 rhn kernel: [    5.095239] uhci_hcd 0000:00:1f.4: new USB bus registered, assigned bus number 2
Oct 24 10:15:36 rhn kernel: [    5.095551] uhci_hcd 0000:00:1f.4: irq 10, io base 0x0000ef80
Oct 24 10:15:36 rhn kernel: [    5.095776] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
Oct 24 10:15:36 rhn kernel: [    5.095935] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct 24 10:15:36 rhn kernel: [    5.108434] usb usb2: Product: UHCI Host Controller
Oct 24 10:15:36 rhn kernel: [    5.108601] usb usb2: Manufacturer: Linux 3.1.0-rc10-dirty uhci_hcd
Oct 24 10:15:36 rhn kernel: [    5.108756] usb usb2: SerialNumber: 0000:00:1f.4
Oct 24 10:15:36 rhn kernel: [    5.109483] hub 2-0:1.0: USB hub found
Oct 24 10:15:36 rhn kernel: [    5.109645] hub 2-0:1.0: 2 ports detected
Oct 24 10:15:36 rhn kernel: [    5.342984] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 9
Oct 24 10:15:36 rhn kernel: [    5.343155] PCI: setting IRQ 9 as level-triggered
Oct 24 10:15:36 rhn kernel: [    5.343168] i801_smbus 0000:00:1f.3: PCI INT B -> Link[LNKB] -> GSI 9 (level, low) -> IRQ 9
Oct 24 10:15:36 rhn kernel: [    5.588141] wmi: Mapper loaded
Oct 24 10:15:36 rhn kernel: [    6.113920] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
Oct 24 10:15:36 rhn kernel: [    6.114095] nouveau 0000:02:00.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
Oct 24 10:15:36 rhn kernel: [    6.118358] [drm] nouveau 0000:02:00.0: Detected an NV 0 generation card (0x20154000)
Oct 24 10:15:36 rhn kernel: [    6.119076] [drm] nouveau 0000:02:00.0: Attempting to load BIOS image from PRAMIN
Oct 24 10:15:36 rhn kernel: [    6.193308] [drm] nouveau 0000:02:00.0: ... appears to be valid
Oct 24 10:15:36 rhn kernel: [    6.194347] [drm] nouveau 0000:02:00.0: BMP BIOS found
Oct 24 10:15:36 rhn kernel: [    6.194501] [drm] nouveau 0000:02:00.0: BMP version 5.1
Oct 24 10:15:36 rhn kernel: [    6.194656] [drm] nouveau 0000:02:00.0: Bios version 02.05.19.03
Oct 24 10:15:36 rhn kernel: [    6.229158] [drm] nouveau 0000:02:00.0: 0 available performance level(s)
Oct 24 10:15:36 rhn kernel: [    6.229343] [drm] nouveau 0000:02:00.0: c: memory 143MHz core 125MHz
Oct 24 10:15:36 rhn kernel: [    6.229730] [TTM] Zone  kernel: Available graphics memory: 257504 kiB.
Oct 24 10:15:36 rhn kernel: [    6.229885] [TTM] Initializing pool allocator.
Oct 24 10:15:36 rhn kernel: [    6.230062] [drm] nouveau 0000:02:00.0: Detected 32MiB VRAM
Oct 24 10:15:36 rhn kernel: [    6.230420] agpgart-intel 0000:00:00.0: AGP 2.0 bridge
Oct 24 10:15:36 rhn kernel: [    6.230610] agpgart-intel 0000:00:00.0: putting AGP V2 device into 4x mode
Oct 24 10:15:36 rhn kernel: [    6.230794] nouveau 0000:02:00.0: putting AGP V2 device into 4x mode
Oct 24 10:15:36 rhn kernel: [    6.230960] [drm] nouveau 0000:02:00.0: 64 MiB GART (aperture)
Oct 24 10:15:36 rhn kernel: [    6.231192] [drm] nouveau 0000:02:00.0: Saving VGA fonts
Oct 24 10:15:36 rhn kernel: [    6.276381] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
Oct 24 10:15:36 rhn kernel: [    6.276548] [drm] No driver support for vblank timestamp query.
Oct 24 10:15:36 rhn kernel: [    6.281474] [drm] nouveau 0000:02:00.0: Setting dpms mode 3 on vga encoder (output 0)
Oct 24 10:15:36 rhn kernel: [    6.344132] snd_intel8x0 0000:00:1f.5: PCI INT B -> Link[LNKB] -> GSI 9 (level, low) -> IRQ 9
Oct 24 10:15:36 rhn kernel: [    6.344457] snd_intel8x0 0000:00:1f.5: setting latency timer to 64
Oct 24 10:15:36 rhn kernel: [    6.411324] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: DATA_ERROR nstatus: BAD_ARGUMENT
Oct 24 10:15:36 rhn kernel: [    6.411692] [drm] nouveau 0000:02:00.0: PGRAPH - ch 0/2 class 0x0042 mthd 0x0304 data 0x20002000
Oct 24 10:15:36 rhn kernel: [    6.411976] [drm] nouveau 0000:02:00.0: allocated 2048x1536 fb: 0x44000, bo df645200
Oct 24 10:15:36 rhn kernel: [    6.412004] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: STATE_INVALID nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:36 rhn kernel: [    6.412004] [drm] nouveau 0000:02:00.0: PGRAPH - ch 0/3 class 0x004a mthd 0x0404 data 0x08000600
Oct 24 10:15:36 rhn kernel: [    6.413344] fbcon: nouveaufb (fb0) is primary device
Oct 24 10:15:36 rhn kernel: [    6.472073] [drm] nouveau 0000:02:00.0: Could not find a compatible set of PLL values
Oct 24 10:15:36 rhn kernel: [    6.550154] [drm] nouveau 0000:02:00.0: Setting dpms mode 0 on vga encoder (output 0)
Oct 24 10:15:36 rhn kernel: [    6.550168] [drm] nouveau 0000:02:00.0: Output VGA-1 is running on CRTC 0 using output A
Oct 24 10:15:36 rhn kernel: [    6.550500] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: STATE_INVALID nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:36 rhn kernel: [    6.550517] [drm] nouveau 0000:02:00.0: PGRAPH - ch 0/3 class 0x004a mthd 0x0c00 data 0x00000000
Oct 24 10:15:36 rhn kernel: [    6.550526] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: STATE_INVALID nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:36 rhn kernel: [    6.550540] [drm] nouveau 0000:02:00.0: PGRAPH - ch 0/3 class 0x004a mthd 0x0c04 data 0x00000000
Oct 24 10:15:36 rhn kernel: [    6.550549] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: STATE_INVALID nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:36 rhn kernel: [    6.550562] [drm] nouveau 0000:02:00.0: PGRAPH - ch 0/3 class 0x004a mthd 0x0c08 data 0x00000000
Oct 24 10:15:36 rhn kernel: [    6.550571] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: STATE_INVALID nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:36 rhn kernel: [    6.550585] [drm] nouveau 0000:02:00.0: PGRAPH - ch 0/3 class 0x004a mthd 0x0c0c data 0x00000000
Oct 24 10:15:36 rhn kernel: [    6.550990] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: STATE_INVALID nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:36 rhn kernel: [    6.551004] [drm] nouveau 0000:02:00.0: PGRAPH - ch 0/3 class 0x004a mthd 0x0c00 data 0x00000000
Oct 24 10:15:36 rhn kernel: [    6.551014] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: STATE_INVALID nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:36 rhn kernel: [    6.551027] [drm] nouveau 0000:02:00.0: PGRAPH - ch 0/3 class 0x004a mthd 0x0c04 data 0x00000000
Oct 24 10:15:36 rhn kernel: [    6.551036] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: STATE_INVALID nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:36 rhn kernel: [    6.551049] [drm] nouveau 0000:02:00.0: PGRAPH - ch 0/3 class 0x004a mthd 0x0c08 data 0x00000000
Oct 24 10:15:36 rhn kernel: [    6.551058] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: STATE_INVALID nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:36 rhn kernel: [    6.551072] [drm] nouveau 0000:02:00.0: PGRAPH - ch 0/3 class 0x004a mthd 0x0c0c data 0x00000000
Oct 24 10:15:36 rhn kernel: [    6.551081] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: STATE_INVALID nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:36 rhn kernel: [    6.551094] [drm] nouveau 0000:02:00.0: PGRAPH - ch 0/3 class 0x004a mthd 0x0c10 data 0x00000000
Oct 24 10:15:36 rhn kernel: [    6.551103] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: STATE_INVALID nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:36 rhn kernel: [    6.551116] [drm] nouveau 0000:02:00.0: PGRAPH - ch 0/3 class 0x004a mthd 0x0c14 data 0x00000000
Oct 24 10:15:36 rhn kernel: [    6.551126] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: STATE_INVALID nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:36 rhn kernel: [    6.551139] [drm] nouveau 0000:02:00.0: PGRAPH - ch 0/3 class 0x004a mthd 0x0c18 data 0x00000000
Oct 24 10:15:36 rhn kernel: [    6.551148] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: STATE_INVALID nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:36 rhn kernel: [    6.551161] [drm] nouveau 0000:02:00.0: PGRAPH - ch 0/3 class 0x004a mthd 0x0c1c data 0x00000000
Oct 24 10:15:36 rhn kernel: [    6.551170] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: STATE_INVALID nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:36 rhn kernel: [    6.551183] [drm] nouveau 0000:02:00.0: PGRAPH - ch 0/3 class 0x004a mthd 0x0c20 data 0x00000000
Oct 24 10:15:36 rhn kernel: [    6.551193] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: STATE_INVALID nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:36 rhn kernel: [    6.551206] [drm] nouveau 0000:02:00.0: PGRAPH - ch 0/3 class 0x004a mthd 0x0c24 data 0x00000000
Oct 24 10:15:36 rhn kernel: [    6.551215] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: STATE_INVALID nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:36 rhn kernel: [    6.551228] [drm] nouveau 0000:02:00.0: PGRAPH - ch 0/3 class 0x004a mthd 0x0c28 data 0x00000000
Oct 24 10:15:36 rhn kernel: [    6.551237] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: STATE_INVALID nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:36 rhn kernel: [    6.551251] [drm] nouveau 0000:02:00.0: PGRAPH - ch 0/3 class 0x004a mthd 0x0c2c data 0x00000000
Oct 24 10:15:37 rhn kernel: [    6.551260] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: STATE_INVALID nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:37 rhn kernel: [    6.551273] [drm] nouveau 0000:02:00.0: PGRAPH - ch 0/3 class 0x004a mthd 0x0c30 data 0x00000000
Oct 24 10:15:37 rhn kernel: [    6.551282] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: STATE_INVALID nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:37 rhn kernel: [    6.551295] [drm] nouveau 0000:02:00.0: PGRAPH - ch 0/3 class 0x004a mthd 0x0c34 data 0x00000000
Oct 24 10:15:37 rhn kernel: [    6.959568] Console: switching to colour frame buffer device 256x96
Oct 24 10:15:37 rhn kernel: [    6.989990] intel8x0_measure_ac97_clock: measured 57023 usecs (3192 samples)
Oct 24 10:15:37 rhn kernel: [    6.989999] intel8x0: clocking to 41159
Oct 24 10:15:37 rhn kernel: [    7.388778] [drm] nouveau 0000:02:00.0: GPU lockup - switching to software fbcon
Oct 24 10:15:37 rhn kernel: [    7.491162] fb0: nouveaufb frame buffer device
Oct 24 10:15:37 rhn kernel: [    7.491299] drm: registered panic notifier
Oct 24 10:15:37 rhn kernel: [    7.491448] [drm] Initialized nouveau 0.0.16 20090420 for 0000:02:00.0 on minor 0
Oct 24 10:15:37 rhn kernel: [    8.579524] Adding 1004056k swap on /dev/sda2.  Priority:-1 extents:1 across:1004056k 
Oct 24 10:15:37 rhn kernel: [    8.922670] EXT3-fs (sda3): using internal journal
Oct 24 10:15:37 rhn kernel: [    9.049874] NTFS driver 2.1.30 [Flags: R/W MODULE].
Oct 24 10:15:37 rhn kernel: [    9.267336] usbcore: registered new interface driver libusual
Oct 24 10:15:37 rhn kernel: [    9.273492] Initializing USB Mass Storage driver...
Oct 24 10:15:37 rhn kernel: [    9.274487] usbcore: registered new interface driver usb-storage
Oct 24 10:15:37 rhn kernel: [    9.274701] USB Mass Storage support registered.
Oct 24 10:15:37 rhn kernel: [    9.340665] smsc47m1: Found SMSC LPC47M10x/LPC47M112/LPC47M13x
Oct 24 10:15:37 rhn kernel: [   10.712719] kjournald starting.  Commit interval 5 seconds
Oct 24 10:15:37 rhn kernel: [   10.726569] EXT3-fs (sda4): using internal journal
Oct 24 10:15:37 rhn kernel: [   10.740223] EXT3-fs (sda4): mounted filesystem with writeback data mode
Oct 24 10:15:37 rhn kernel: [   11.580186] NET: Registered protocol family 8
Oct 24 10:15:37 rhn kernel: [   11.593559] NET: Registered protocol family 20
Oct 24 10:15:37 rhn kernel: [   12.703108] NET: Registered protocol family 10
Oct 24 10:15:37 rhn kernel: [   13.037192] ADDRCONF(NETDEV_UP): eth0: link is not ready
Oct 24 10:15:37 rhn kernel: [   13.050493] e100 0000:01:08.0: eth0: NIC Link is Up 100 Mbps Full Duplex
Oct 24 10:15:37 rhn kernel: [   13.063787] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
Oct 24 10:15:37 rhn kernel: [   17.177677] RPC: Registered named UNIX socket transport module.
Oct 24 10:15:37 rhn kernel: [   17.190795] RPC: Registered udp transport module.
Oct 24 10:15:37 rhn kernel: [   17.203745] RPC: Registered tcp transport module.
Oct 24 10:15:37 rhn kernel: [   17.216538] RPC: Registered tcp NFSv4.1 backchannel transport module.
Oct 24 10:15:37 rhn kernel: [   17.307746] Registering the id_resolver key type
Oct 24 10:15:37 rhn kernel: [   17.354657] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Oct 24 10:15:37 rhn kernel: [   18.324697] fuse init (API version 7.17)
Oct 24 10:15:37 rhn kernel: [   19.768635] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
Oct 24 10:15:37 rhn kernel: [   19.808415] NFSD: starting 90-second grace period
Oct 24 10:15:37 rhn kernel: [   20.329615] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input4
Oct 24 10:15:37 rhn kernel: [   23.480028] eth0: no IPv6 routers present
Oct 24 10:15:37 rhn kernel: [   25.644613] nouveau_ratelimit: 211782 callbacks suppressed
Oct 24 10:15:37 rhn kernel: [   25.644628] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: DATA_ERROR nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:37 rhn kernel: [   25.644648] [drm] nouveau 0000:02:00.0: PGRAPH - ch 1/7 class 0x0042 mthd 0x0304 data 0x20002000
Oct 24 10:15:37 rhn kernel: [   25.644658] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: STATE_INVALID nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:37 rhn kernel: [   25.644676] [drm] nouveau 0000:02:00.0: PGRAPH - ch 1/2 class 0x005f mthd 0x0308 data 0x06000800
Oct 24 10:15:37 rhn kernel: [   25.670888] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: DATA_ERROR nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:37 rhn kernel: [   25.670908] [drm] nouveau 0000:02:00.0: PGRAPH - ch 1/7 class 0x0042 mthd 0x0304 data 0x20002000
Oct 24 10:15:37 rhn kernel: [   26.068702] lp0: using parport0 (interrupt-driven).
Oct 24 10:15:37 rhn kernel: [   26.183787] ppdev: user-space parallel port driver
Oct 24 10:15:37 rhn kernel: [   27.130516] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: DATA_ERROR nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:37 rhn kernel: [   27.130547] [drm] nouveau 0000:02:00.0: PGRAPH - ch 1/7 class 0x0042 mthd 0x0304 data 0x20002000
Oct 24 10:15:37 rhn kernel: [   27.130558] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: STATE_INVALID nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:37 rhn kernel: [   27.130576] [drm] nouveau 0000:02:00.0: PGRAPH - ch 1/3 class 0x004a mthd 0x0404 data 0x08000600
Oct 24 10:15:37 rhn kernel: [   28.732658] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: DATA_ERROR nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:37 rhn kernel: [   28.732688] [drm] nouveau 0000:02:00.0: PGRAPH - ch 1/7 class 0x0042 mthd 0x0304 data 0x20002000
Oct 24 10:15:37 rhn kernel: [   28.872199] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: DATA_ERROR nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:37 rhn kernel: [   28.872230] [drm] nouveau 0000:02:00.0: PGRAPH - ch 1/7 class 0x0042 mthd 0x0304 data 0x20002000
Oct 24 10:15:37 rhn kernel: [   28.872240] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: STATE_INVALID nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:37 rhn kernel: [   28.872258] [drm] nouveau 0000:02:00.0: PGRAPH - ch 1/3 class 0x004a mthd 0x0404 data 0x08000600
Oct 24 10:15:37 rhn kernel: [   28.885315] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: DATA_ERROR nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:37 rhn kernel: [   28.885344] [drm] nouveau 0000:02:00.0: PGRAPH - ch 1/7 class 0x0042 mthd 0x0304 data 0x20002000
Oct 24 10:15:53 rhn kernel: [   49.724653] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: DATA_ERROR nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:53 rhn kernel: [   49.724684] [drm] nouveau 0000:02:00.0: PGRAPH - ch 1/7 class 0x0042 mthd 0x0304 data 0x20002000
Oct 24 10:15:53 rhn kernel: [   49.724694] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: STATE_INVALID nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:53 rhn kernel: [   49.724712] [drm] nouveau 0000:02:00.0: PGRAPH - ch 1/3 class 0x004a mthd 0x0404 data 0x00010011
Oct 24 10:15:53 rhn kernel: [   49.730472] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: DATA_ERROR nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:53 rhn kernel: [   49.730502] [drm] nouveau 0000:02:00.0: PGRAPH - ch 1/7 class 0x0042 mthd 0x0304 data 0x20002000
Oct 24 10:15:53 rhn kernel: [   49.730512] [drm] nouveau 0000:02:00.0: PGRAPH - NOTIFY nsource: STATE_INVALID nstatus: INVALID_STATE BAD_ARGUMENT
Oct 24 10:15:53 rhn kernel: [   49.730530] [drm] nouveau 0000:02:00.0: PGRAPH - ch 1/3 class 0x004a mthd 0x0404 data 0x00010011


-- 
Meelis Roos (mroos@linux.ee)
