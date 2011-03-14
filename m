Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab1CNTVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 15:21:25 -0400
Received: from aa012-1msr.fastwebnet.it ([62.101.93.132]:49512 "EHLO
	aa012-1msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab1CNTVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 15:21:22 -0400
Date: Mon, 14 Mar 2011 20:20:17 +0100
From: Paolo Ornati <ornati@fastwebnet.it>
To: Paolo Ornati <ornati@gmail.com>
Cc: Nick Bowler <nbowler@elliptictech.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [2.6.38-rc6] G965: i915 Hangcheck timer elapsed... GPU hung
 (not reproducible)
Message-ID: <20110314202017.1887e573@fastwebnet.it>
In-Reply-To: <20110303210152.5750c239@gmail.com>
References: <20110227101041.6b864352@gmail.com>
	<20110302155648.421f0292.akpm@linux-foundation.org>
	<20110303004326.GA18486@elliptictech.com>
	<20110303210152.5750c239@gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/g2ElFXTj4ZSUabSIjQUyYvn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/g2ElFXTj4ZSUabSIjQUyYvn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, 3 Mar 2011 21:01:52 +0100
Paolo Ornati <ornati@gmail.com> wrote:

> I'll see if it happens again...

Happened again today (two weeks later), always while starting a video
in SMplayer/MPlayer.

kernel: 2.6.38-rc8

dmesg
-------
[ 2512.924027] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
[ 2512.924719] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -11 (awaiting 261386 at 261385, next 261414)
[ 2512.924945] [drm:init_ring_common] *ERROR* render ring initialization failed ctl 00000000 head 00000000 tail 00000000 start 00000000
[ 2513.060468] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
...

Xorg.log
-----------
[  2512.240] [mi] EQ overflowing. The server is probably stuck in an infinite loop.
[  2512.240] 
Backtrace:
[  2512.254] 0: /usr/bin/X (xorg_backtrace+0x28) [0x4a1a78]
[  2512.254] 1: /usr/bin/X (mieqEnqueue+0x1f4) [0x4a1414]
[  2512.254] 2: /usr/bin/X (xf86PostMotionEventP+0xc4) [0x47e374]
[  2512.254] 3: /usr/lib64/xorg/modules/input/evdev_drv.so (0x7f0354270000+0x546c) [0x7f035427546c]
[  2512.254] 4: /usr/bin/X (0x400000+0x6c407) [0x46c407]
[  2512.254] 5: /usr/bin/X (0x400000+0x11a933) [0x51a933]
[  2512.254] 6: /lib/libpthread.so.0 (0x7f0358890000+0xf120) [0x7f035889f120]
[  2512.254] 7: /lib/libc.so.6 (ioctl+0x7) [0x7f03578c2107]
[  2512.254] 8: /usr/lib/libdrm.so.2 (drmIoctl+0x28) [0x7f0356290bf8]
[  2512.254] 9: /usr/lib/libdrm_intel.so.1 (drm_intel_gem_bo_map_gtt+0x7c) [0x7f0355a27f6c]
[  2512.254] 10: /usr/lib64/xorg/modules/drivers/intel_drv.so (0x7f0355c2d000+0x151c4) [0x7f0355c421c4]
[  2512.254] 11: /usr/lib64/xorg/modules/drivers/intel_drv.so (0x7f0355c2d000+0x159f9) [0x7f0355c429f9]
[  2512.254] 12: /usr/bin/X (0x400000+0x12d000) [0x52d000]
[  2512.254] 13: /usr/lib64/xorg/modules/extensions/libextmod.so (0x7f035690a000+0x10114) [0x7f035691a114]
[  2512.254] 14: /usr/bin/X (0x400000+0x2f1b9) [0x42f1b9]
[  2512.255] 15: /usr/bin/X (0x400000+0x247fb) [0x4247fb]
[  2512.255] 16: /lib/libc.so.6 (__libc_start_main+0xfd) [0x7f0357816bbd]
[  2512.255] 17: /usr/bin/X (0x400000+0x24389) [0x424389]
[  2517.380] [mi] EQ overflowing. The server is probably stuck in an infinite loop.
[  2517.380] 
Backtrace:
[  2517.380] 0: /usr/bin/X (xorg_backtrace+0x28) [0x4a1a78]
[  2517.380] 1: /usr/bin/X (mieqEnqueue+0x1f4) [0x4a1414]
[  2517.380] 2: /usr/bin/X (xf86PostMotionEventP+0xc4) [0x47e374]
[  2517.380] 3: /usr/lib64/xorg/modules/input/evdev_drv.so (0x7f0354270000+0x546c) [0x7f035427546c]
[  2517.380] 4: /usr/bin/X (0x400000+0x6c407) [0x46c407]
[  2517.380] 5: /usr/bin/X (0x400000+0x11a933) [0x51a933]
[  2517.380] 6: /lib/libpthread.so.0 (0x7f0358890000+0xf120) [0x7f035889f120]
[  2517.380] 7: /lib/libc.so.6 (ioctl+0x7) [0x7f03578c2107]
[  2517.380] 8: /usr/lib/libdrm.so.2 (drmIoctl+0x28) [0x7f0356290bf8]
[  2517.380] 9: /usr/lib/libdrm_intel.so.1 (drm_intel_gem_bo_map_gtt+0x7c) [0x7f0355a27f6c]
[  2517.380] 10: /usr/lib64/xorg/modules/drivers/intel_drv.so (0x7f0355c2d000+0x129b3) [0x7f0355c3f9b3]
[  2517.380] 11: /usr/lib64/xorg/modules/drivers/intel_drv.so (0x7f0355c2d000+0x2a102) [0x7f0355c57102]
[  2517.380] 12: /usr/bin/X (0x400000+0x157cf0) [0x557cf0]
[  2517.380] 13: /usr/bin/X (0x400000+0x30adb) [0x430adb]
[  2517.380] 14: /usr/bin/X (0x400000+0x2f1b9) [0x42f1b9]
[  2517.380] 15: /usr/bin/X (0x400000+0x247fb) [0x4247fb]
[  2517.380] 16: /lib/libc.so.6 (__libc_start_main+0xfd) [0x7f0357816bbd]
[  2517.380] 17: /usr/bin/X (0x400000+0x24389) [0x424389]

-- 
	Paolo Ornati
	Linux 2.6.38-rc8 on x86_64

--MP_/g2ElFXTj4ZSUabSIjQUyYvn
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=dmesg.txt

(usable)
[    0.000000]  BIOS-e820: 000000007e622000 - 000000007e6a5000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007e6a5000 - 000000007e6aa000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007e6aa000 - 000000007e6ab000 (usable)
[    0.000000]  BIOS-e820: 000000007e6ab000 - 000000007e6f2000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007e6f2000 - 000000007e6ff000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007e6ff000 - 000000007e700000 (usable)
[    0.000000]  BIOS-e820: 000000007e700000 - 000000007f000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI:                  /DG965SS, BIOS MQ96510J.86A.1687.2007.0510.0258 05/10/2007
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x7e700 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 07F000000 mask FFF000000 uncachable
[    0.000000]   2 base 07E800000 mask FFF800000 uncachable
[    0.000000]   3 base 07E700000 mask FFFF00000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] found SMP MP-table at [ffff8800000fe200] fe200
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-000000007e700000
[    0.000000]  0000000000 - 007e600000 page 2M
[    0.000000]  007e600000 - 007e700000 page 4k
[    0.000000] kernel direct mapping tables up to 7e700000 @ 1fffc000-20000000
[    0.000000] RAMDISK: 37dfc000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000fe020 00014 (v00 INTEL )
[    0.000000] ACPI: RSDT 000000007e6fd038 00050 (v01 INTEL  DG965SS  00000697      01000013)
[    0.000000] ACPI: FACP 000000007e6fc000 00074 (v01 INTEL  DG965SS  00000697 MSFT 01000013)
[    0.000000] ACPI: DSDT 000000007e6f7000 040ED (v01 INTEL  DG965SS  00000697 MSFT 01000013)
[    0.000000] ACPI: FACS 000000007e6ab000 00040
[    0.000000] ACPI: APIC 000000007e6f6000 00078 (v01 INTEL  DG965SS  00000697 MSFT 01000013)
[    0.000000] ACPI: WDDT 000000007e6f5000 00040 (v01 INTEL  DG965SS  00000697 MSFT 01000013)
[    0.000000] ACPI: MCFG 000000007e6f4000 0003C (v01 INTEL  DG965SS  00000697 MSFT 01000013)
[    0.000000] ACPI: ASF! 000000007e6f3000 000A6 (v32 INTEL  DG965SS  00000697 MSFT 01000013)
[    0.000000] ACPI: HPET 000000007e6f2000 00038 (v01 INTEL  DG965SS  00000697 MSFT 01000013)
[    0.000000] ACPI: SSDT 000000007e6a9000 001BC (v01 INTEL     CpuPm 00000697 MSFT 01000013)
[    0.000000] ACPI: SSDT 000000007e6a8000 00175 (v01 INTEL   Cpu0Ist 00000697 MSFT 01000013)
[    0.000000] ACPI: SSDT 000000007e6a7000 00175 (v01 INTEL   Cpu1Ist 00000697 MSFT 01000013)
[    0.000000] ACPI: SSDT 000000007e6a6000 00175 (v01 INTEL   Cpu2Ist 00000697 MSFT 01000013)
[    0.000000] ACPI: SSDT 000000007e6a5000 00175 (v01 INTEL   Cpu3Ist 00000697 MSFT 01000013)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff88007bc00000-ffff88007d7fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[5] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000008f
[    0.000000]     0: 0x00000100 -> 0x0007e599
[    0.000000]     0: 0x0007e5a6 -> 0x0007e622
[    0.000000]     0: 0x0007e6aa -> 0x0007e6ab
[    0.000000]     0: 0x0007e6ff -> 0x0007e700
[    0.000000] On node 0 totalpages: 517526
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3905 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7025 pages used for memmap
[    0.000000]   DMA32 zone: 506534 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000008f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 000000007e599000 - 000000007e5a6000
[    0.000000] PM: Registered nosave memory: 000000007e622000 - 000000007e6a5000
[    0.000000] PM: Registered nosave memory: 000000007e6a5000 - 000000007e6aa000
[    0.000000] PM: Registered nosave memory: 000000007e6ab000 - 000000007e6f2000
[    0.000000] PM: Registered nosave memory: 000000007e6f2000 - 000000007e6ff000
[    0.000000] Allocating PCI resources starting at 7f000000 (gap: 7f000000:80f00000)
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88007e200000 s73152 r8192 d21056 u524288
[    0.000000] pcpu-alloc: s73152 r8192 d21056 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 510439
[    0.000000] Kernel command line: root=/dev/sda2 ro i915.modeset=1
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 2025312k/2071552k available (4111k kernel code, 1448k absent, 44792k reserved, 4982k data, 624k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:512
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1864.824 MHz processor.
[    0.001004] Calibrating delay loop (skipped), value calculated using timer frequency.. 3729.64 BogoMIPS (lpj=1864824)
[    0.001100] pid_max: default: 32768 minimum: 301
[    0.001212] Mount-cache hash table entries: 256
[    0.001471] Initializing cgroup subsys blkio
[    0.001546] CPU: Physical Processor ID: 0
[    0.001590] CPU: Processor Core ID: 0
[    0.001634] mce: CPU supports 6 MCE banks
[    0.001684] CPU0: Thermal monitoring enabled (TM2)
[    0.001732] using mwait in idle threads.
[    0.002042] ACPI: Core revision 20110112
[    0.006012] ftrace: allocating 17578 entries in 69 pages
[    0.007052] Setting APIC routing to flat
[    0.007401] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.017526] CPU0: Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz stepping 06
[    0.017998] Performance Events: PEBS fmt0-, Core2 events, Intel PMU driver.
[    0.017998] PEBS disabled due to CPU errata.
[    0.017998] ... version:                2
[    0.017998] ... bit width:              40
[    0.017998] ... generic registers:      2
[    0.017998] ... value mask:             000000ffffffffff
[    0.017998] ... max period:             000000007fffffff
[    0.017998] ... fixed-purpose events:   3
[    0.017998] ... event mask:             0000000700000003
[    0.017998] Booting Node   0, Processors  #1
[    0.089012] Brought up 2 CPUs
[    0.089091] Total of 2 processors activated (7459.07 BogoMIPS).
[    0.090965] NET: Registered protocol family 16
[    0.091047] ACPI: bus type pci registered
[    0.091080] PCI: MMCONFIG for domain 0000 [bus 00-7f] at [mem 0xf0000000-0xf7ffffff] (base 0xf0000000)
[    0.091107] PCI: not using MMCONFIG
[    0.091150] PCI: Using configuration type 1 for base access
[    0.098154] bio: create slab <bio-0> at 0
[    0.099724] ACPI: EC: Look up EC in DSDT
[    0.102640] ACPI: Interpreter enabled
[    0.102686] ACPI: (supports S0 S3 S4 S5)
[    0.102825] ACPI: Using IOAPIC for interrupt routing
[    0.102889] PCI: MMCONFIG for domain 0000 [bus 00-7f] at [mem 0xf0000000-0xf7ffffff] (base 0xf0000000)
[    0.103162] PCI: MMCONFIG at [mem 0xf0000000-0xf7ffffff] reserved in ACPI motherboard resources
[    0.133145] ACPI: No dock devices found.
[    0.133192] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.134404] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.136362] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.136366] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.136369] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.136373] pci_root PNP0A03:00: host bridge window [mem 0x000e0000-0x000effff] (ignored)
[    0.136376] pci_root PNP0A03:00: host bridge window [mem 0xf8000000-0xfeafffff] (ignored)
[    0.136379] pci_root PNP0A03:00: host bridge window [mem 0x7f000000-0xefffffff] (ignored)
[    0.136393] pci 0000:00:00.0: [8086:29a0] type 0 class 0x000600
[    0.136438] pci 0000:00:02.0: [8086:29a2] type 0 class 0x000300
[    0.136450] pci 0000:00:02.0: reg 10: [mem 0x90200000-0x902fffff]
[    0.136463] pci 0000:00:02.0: reg 18: [mem 0x80000000-0x8fffffff 64bit pref]
[    0.136470] pci 0000:00:02.0: reg 20: [io  0x3410-0x3417]
[    0.136506] pci 0000:00:03.0: [8086:29a4] type 0 class 0x000780
[    0.136523] pci 0000:00:03.0: reg 10: [mem 0x90326100-0x9032610f 64bit]
[    0.136564] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.136568] pci 0000:00:03.0: PME# disabled
[    0.136613] pci 0000:00:19.0: [8086:104b] type 0 class 0x000200
[    0.136631] pci 0000:00:19.0: reg 10: [mem 0x90300000-0x9031ffff]
[    0.136641] pci 0000:00:19.0: reg 14: [mem 0x90324000-0x90324fff]
[    0.136650] pci 0000:00:19.0: reg 18: [io  0x30e0-0x30ff]
[    0.136698] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.136703] pci 0000:00:19.0: PME# disabled
[    0.136718] pci 0000:00:1a.0: [8086:2834] type 0 class 0x000c03
[    0.136760] pci 0000:00:1a.0: reg 20: [io  0x30c0-0x30df]
[    0.136791] pci 0000:00:1a.1: [8086:2835] type 0 class 0x000c03
[    0.136832] pci 0000:00:1a.1: reg 20: [io  0x30a0-0x30bf]
[    0.136874] pci 0000:00:1a.7: [8086:283a] type 0 class 0x000c03
[    0.136894] pci 0000:00:1a.7: reg 10: [mem 0x90325c00-0x90325fff]
[    0.136965] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.136970] pci 0000:00:1a.7: PME# disabled
[    0.136996] pci 0000:00:1b.0: [8086:284b] type 0 class 0x000403
[    0.137013] pci 0000:00:1b.0: reg 10: [mem 0x90320000-0x90323fff 64bit]
[    0.137070] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.137074] pci 0000:00:1b.0: PME# disabled
[    0.137094] pci 0000:00:1c.0: [8086:283f] type 1 class 0x000604
[    0.137151] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.137156] pci 0000:00:1c.0: PME# disabled
[    0.137177] pci 0000:00:1c.1: [8086:2841] type 1 class 0x000604
[    0.137234] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.137239] pci 0000:00:1c.1: PME# disabled
[    0.137260] pci 0000:00:1c.2: [8086:2843] type 1 class 0x000604
[    0.137317] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.137321] pci 0000:00:1c.2: PME# disabled
[    0.137342] pci 0000:00:1c.3: [8086:2845] type 1 class 0x000604
[    0.137399] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.137404] pci 0000:00:1c.3: PME# disabled
[    0.137425] pci 0000:00:1c.4: [8086:2847] type 1 class 0x000604
[    0.137482] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.137486] pci 0000:00:1c.4: PME# disabled
[    0.137508] pci 0000:00:1d.0: [8086:2830] type 0 class 0x000c03
[    0.137550] pci 0000:00:1d.0: reg 20: [io  0x3080-0x309f]
[    0.137582] pci 0000:00:1d.1: [8086:2831] type 0 class 0x000c03
[    0.137624] pci 0000:00:1d.1: reg 20: [io  0x3060-0x307f]
[    0.137655] pci 0000:00:1d.2: [8086:2832] type 0 class 0x000c03
[    0.137696] pci 0000:00:1d.2: reg 20: [io  0x3040-0x305f]
[    0.137737] pci 0000:00:1d.7: [8086:2836] type 0 class 0x000c03
[    0.137757] pci 0000:00:1d.7: reg 10: [mem 0x90325800-0x90325bff]
[    0.137828] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.137833] pci 0000:00:1d.7: PME# disabled
[    0.137852] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    0.137911] pci 0000:00:1f.0: [8086:2810] type 0 class 0x000601
[    0.137995] pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by ICH6 ACPI/GPIO/TCO
[    0.138066] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
[    0.138120] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
[    0.138228] pci 0000:00:1f.2: [8086:2824] type 0 class 0x000106
[    0.138246] pci 0000:00:1f.2: reg 10: [io  0x3408-0x340f]
[    0.138255] pci 0000:00:1f.2: reg 14: [io  0x341c-0x341f]
[    0.138264] pci 0000:00:1f.2: reg 18: [io  0x3400-0x3407]
[    0.138273] pci 0000:00:1f.2: reg 1c: [io  0x3418-0x341b]
[    0.138282] pci 0000:00:1f.2: reg 20: [io  0x3020-0x303f]
[    0.138291] pci 0000:00:1f.2: reg 24: [mem 0x90325000-0x903257ff]
[    0.138323] pci 0000:00:1f.2: PME# supported from D3hot
[    0.138327] pci 0000:00:1f.2: PME# disabled
[    0.138344] pci 0000:00:1f.3: [8086:283e] type 0 class 0x000c05
[    0.138356] pci 0000:00:1f.3: reg 10: [mem 0x90326000-0x903260ff]
[    0.138385] pci 0000:00:1f.3: reg 20: [io  0x3000-0x301f]
[    0.138452] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.138502] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.138507] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.138514] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.138573] pci 0000:02:00.0: [11ab:6101] type 0 class 0x000101
[    0.138590] pci 0000:02:00.0: reg 10: [io  0x2018-0x201f]
[    0.138603] pci 0000:02:00.0: reg 14: [io  0x2024-0x2027]
[    0.138616] pci 0000:02:00.0: reg 18: [io  0x2010-0x2017]
[    0.138629] pci 0000:02:00.0: reg 1c: [io  0x2020-0x2023]
[    0.138641] pci 0000:02:00.0: reg 20: [io  0x2000-0x200f]
[    0.138654] pci 0000:02:00.0: reg 24: [mem 0x90100000-0x901001ff]
[    0.138700] pci 0000:02:00.0: supports D1
[    0.138703] pci 0000:02:00.0: PME# supported from D0 D1 D3hot
[    0.138708] pci 0000:02:00.0: PME# disabled
[    0.138724] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.138773] pci 0000:00:1c.1:   bridge window [io  0x2000-0x2fff]
[    0.138778] pci 0000:00:1c.1:   bridge window [mem 0x90100000-0x901fffff]
[    0.138785] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.138827] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
[    0.138876] pci 0000:00:1c.2:   bridge window [io  0xf000-0x0000] (disabled)
[    0.138881] pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.138888] pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.138930] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
[    0.138979] pci 0000:00:1c.3:   bridge window [io  0xf000-0x0000] (disabled)
[    0.138984] pci 0000:00:1c.3:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.138997] pci 0000:00:1c.3:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.139039] pci 0000:00:1c.4: PCI bridge to [bus 05-05]
[    0.139089] pci 0000:00:1c.4:   bridge window [io  0xf000-0x0000] (disabled)
[    0.139094] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.139100] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.139135] pci 0000:06:01.0: [10ec:8139] type 0 class 0x000200
[    0.139154] pci 0000:06:01.0: reg 10: [io  0x1000-0x10ff]
[    0.139165] pci 0000:06:01.0: reg 14: [mem 0x90000000-0x900000ff]
[    0.139226] pci 0000:06:01.0: supports D1 D2
[    0.139229] pci 0000:06:01.0: PME# supported from D1 D2 D3hot D3cold
[    0.139234] pci 0000:06:01.0: PME# disabled
[    0.139281] pci 0000:00:1e.0: PCI bridge to [bus 06-06] (subtractive decode)
[    0.139334] pci 0000:00:1e.0:   bridge window [io  0x1000-0x1fff]
[    0.139339] pci 0000:00:1e.0:   bridge window [mem 0x90000000-0x900fffff]
[    0.139346] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.139349] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    0.139352] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xfffffffff] (subtractive decode)
[    0.139379] pci_bus 0000:00: on NUMA node 0
[    0.139383] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.139632] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
[    0.139819] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.139880] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[    0.139939] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
[    0.140005] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.140066] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.148069] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
[    0.148377] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
[    0.148682] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
[    0.149277] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
[    0.149581] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 *9 10 11 12)
[    0.149885] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 *10 11 12)
[    0.150204] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *9 10 11 12)
[    0.150508] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
[    0.150781] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.151029] vgaarb: loaded
[    0.151143] SCSI subsystem initialized
[    0.151143] libata version 3.00 loaded.
[    0.151143] usbcore: registered new interface driver usbfs
[    0.151143] usbcore: registered new interface driver hub
[    0.151143] usbcore: registered new device driver usb
[    0.152016] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    0.152067] PCI: Using ACPI for IRQ routing
[    0.152112] PCI: pci_cache_line_size set to 64 bytes
[    0.152207] reserve RAM buffer: 000000000008f000 - 000000000008ffff 
[    0.152210] reserve RAM buffer: 000000007e599000 - 000000007fffffff 
[    0.152215] reserve RAM buffer: 000000007e622000 - 000000007fffffff 
[    0.152220] reserve RAM buffer: 000000007e6ab000 - 000000007fffffff 
[    0.152224] reserve RAM buffer: 000000007e700000 - 000000007fffffff 
[    0.152245] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.152245] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.152245] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.155014] Switching to clocksource hpet
[    0.155756] Switched to NOHz mode on CPU #0
[    0.155874] Switched to NOHz mode on CPU #1
[    0.163097] pnp: PnP ACPI init
[    0.165071] ACPI: bus type pnp registered
[    0.166119] pnp 00:00: [bus 00-ff]
[    0.166122] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.166125] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.166128] pnp 00:00: [io  0x0d00-0xffff window]
[    0.166131] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.166134] pnp 00:00: [mem 0x000e0000-0x000effff window]
[    0.166137] pnp 00:00: [mem 0xf8000000-0xfeafffff window]
[    0.166142] pnp 00:00: [mem 0x7f000000-0xefffffff window]
[    0.166256] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.166271] pnp 00:01: [mem 0xf0000000-0xf7ffffff]
[    0.166274] pnp 00:01: [mem 0xfed13000-0xfed13fff]
[    0.166277] pnp 00:01: [mem 0xfed14000-0xfed17fff]
[    0.166279] pnp 00:01: [mem 0xfed18000-0xfed18fff]
[    0.166282] pnp 00:01: [mem 0xfed19000-0xfed19fff]
[    0.166284] pnp 00:01: [mem 0xfed1c000-0xfed1ffff]
[    0.166287] pnp 00:01: [mem 0xfed20000-0xfed3ffff]
[    0.166290] pnp 00:01: [mem 0xfed45000-0xfed99fff]
[    0.166292] pnp 00:01: [mem 0x000c0000-0x000dffff]
[    0.166295] pnp 00:01: [mem 0x000e0000-0x000fffff]
[    0.166405] system 00:01: [mem 0xf0000000-0xf7ffffff] has been reserved
[    0.166457] system 00:01: [mem 0xfed13000-0xfed13fff] has been reserved
[    0.166508] system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
[    0.166560] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.166611] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.166662] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.166713] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.166765] system 00:01: [mem 0xfed45000-0xfed99fff] has been reserved
[    0.166816] system 00:01: [mem 0x000c0000-0x000dffff] has been reserved
[    0.166867] system 00:01: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.166920] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.167090] pnp 00:02: [io  0x0000-0x000f]
[    0.167093] pnp 00:02: [io  0x0081-0x0083]
[    0.167096] pnp 00:02: [io  0x0087]
[    0.167098] pnp 00:02: [io  0x0089-0x008b]
[    0.167100] pnp 00:02: [io  0x008f]
[    0.167103] pnp 00:02: [io  0x00c0-0x00df]
[    0.167105] pnp 00:02: [dma 4]
[    0.167177] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.167191] pnp 00:03: [io  0x0070-0x0071]
[    0.167193] pnp 00:03: [io  0x0074-0x0077]
[    0.167205] pnp 00:03: [irq 8]
[    0.167279] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.167294] pnp 00:04: [io  0x00f0]
[    0.167300] pnp 00:04: [irq 13]
[    0.167372] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.167387] pnp 00:05: [io  0x0061]
[    0.167458] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.167472] pnp 00:06: [io  0x0500-0x053f]
[    0.167475] pnp 00:06: [io  0x0400-0x047f]
[    0.167477] pnp 00:06: [io  0x0092]
[    0.167480] pnp 00:06: [io  0x0680-0x06ff]
[    0.167482] pnp 00:06: [io  0x0010-0x001f]
[    0.167484] pnp 00:06: [io  0x0072-0x0073]
[    0.167487] pnp 00:06: [io  0x0080]
[    0.167489] pnp 00:06: [io  0x0084-0x0086]
[    0.167491] pnp 00:06: [io  0x0088]
[    0.167493] pnp 00:06: [io  0x008c-0x008e]
[    0.167496] pnp 00:06: [io  0x0090-0x009f]
[    0.167605] system 00:06: [io  0x0500-0x053f] has been reserved
[    0.167656] system 00:06: [io  0x0400-0x047f] has been reserved
[    0.167705] system 00:06: [io  0x0680-0x06ff] has been reserved
[    0.167756] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.168016] pnp 00:07: [io  0x03f0-0x03f5]
[    0.168019] pnp 00:07: [io  0x03f0]
[    0.168025] pnp 00:07: [irq 6]
[    0.168028] pnp 00:07: [dma 2]
[    0.168131] pnp 00:07: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.168289] pnp 00:08: [irq 12]
[    0.168365] pnp 00:08: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
[    0.168398] pnp 00:09: [io  0x0060]
[    0.168401] pnp 00:09: [io  0x0064]
[    0.168407] pnp 00:09: [irq 1]
[    0.168479] pnp 00:09: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.168636] pnp 00:0a: [mem 0xfec00000-0xfec000ff]
[    0.168713] pnp 00:0a: Plug and Play ACPI device, IDs PNP0003 (active)
[    0.168784] pnp 00:0b: [mem 0xfed00000-0xfed03fff]
[    0.168870] pnp 00:0b: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.168880] pnp: PnP ACPI: found 12 devices
[    0.168925] ACPI: ACPI bus type pnp unregistered
[    0.178353] pci 0000:00:1c.0: BAR 8: assigned [mem 0x90400000-0x905fffff]
[    0.178410] pci 0000:00:1c.0: BAR 9: assigned [mem 0x90600000-0x907fffff 64bit pref]
[    0.178483] pci 0000:00:1c.1: BAR 9: assigned [mem 0x90800000-0x909fffff 64bit pref]
[    0.178555] pci 0000:00:1c.2: BAR 8: assigned [mem 0x90a00000-0x90bfffff]
[    0.178611] pci 0000:00:1c.2: BAR 9: assigned [mem 0x90c00000-0x90dfffff 64bit pref]
[    0.178683] pci 0000:00:1c.3: BAR 8: assigned [mem 0x90e00000-0x90ffffff]
[    0.178738] pci 0000:00:1c.3: BAR 9: assigned [mem 0x91000000-0x911fffff 64bit pref]
[    0.178811] pci 0000:00:1c.4: BAR 8: assigned [mem 0x91200000-0x913fffff]
[    0.178866] pci 0000:00:1c.4: BAR 9: assigned [mem 0x91400000-0x915fffff 64bit pref]
[    0.178936] pci 0000:00:1c.0: BAR 7: assigned [io  0x4000-0x4fff]
[    0.178987] pci 0000:00:1c.2: BAR 7: assigned [io  0x5000-0x5fff]
[    0.179044] pci 0000:00:1c.3: BAR 7: assigned [io  0x6000-0x6fff]
[    0.179095] pci 0000:00:1c.4: BAR 7: assigned [io  0x7000-0x7fff]
[    0.179145] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.179194] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
[    0.179246] pci 0000:00:1c.0:   bridge window [mem 0x90400000-0x905fffff]
[    0.179299] pci 0000:00:1c.0:   bridge window [mem 0x90600000-0x907fffff 64bit pref]
[    0.179371] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.179419] pci 0000:00:1c.1:   bridge window [io  0x2000-0x2fff]
[    0.179472] pci 0000:00:1c.1:   bridge window [mem 0x90100000-0x901fffff]
[    0.179524] pci 0000:00:1c.1:   bridge window [mem 0x90800000-0x909fffff 64bit pref]
[    0.179596] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
[    0.179645] pci 0000:00:1c.2:   bridge window [io  0x5000-0x5fff]
[    0.179697] pci 0000:00:1c.2:   bridge window [mem 0x90a00000-0x90bfffff]
[    0.179750] pci 0000:00:1c.2:   bridge window [mem 0x90c00000-0x90dfffff 64bit pref]
[    0.179821] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
[    0.179870] pci 0000:00:1c.3:   bridge window [io  0x6000-0x6fff]
[    0.179922] pci 0000:00:1c.3:   bridge window [mem 0x90e00000-0x90ffffff]
[    0.179974] pci 0000:00:1c.3:   bridge window [mem 0x91000000-0x911fffff 64bit pref]
[    0.180052] pci 0000:00:1c.4: PCI bridge to [bus 05-05]
[    0.180100] pci 0000:00:1c.4:   bridge window [io  0x7000-0x7fff]
[    0.180152] pci 0000:00:1c.4:   bridge window [mem 0x91200000-0x913fffff]
[    0.180205] pci 0000:00:1c.4:   bridge window [mem 0x91400000-0x915fffff 64bit pref]
[    0.180277] pci 0000:00:1e.0: PCI bridge to [bus 06-06]
[    0.180325] pci 0000:00:1e.0:   bridge window [io  0x1000-0x1fff]
[    0.180377] pci 0000:00:1e.0:   bridge window [mem 0x90000000-0x900fffff]
[    0.180429] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.180496] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.180550] pci 0000:00:1c.0: setting latency timer to 64
[    0.180559] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.180612] pci 0000:00:1c.1: setting latency timer to 64
[    0.180620] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.180673] pci 0000:00:1c.2: setting latency timer to 64
[    0.180681] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.180734] pci 0000:00:1c.3: setting latency timer to 64
[    0.180741] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.180794] pci 0000:00:1c.4: setting latency timer to 64
[    0.180802] pci 0000:00:1e.0: setting latency timer to 64
[    0.180806] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.180809] pci_bus 0000:00: resource 1 [mem 0x00000000-0xfffffffff]
[    0.180812] pci_bus 0000:01: resource 0 [io  0x4000-0x4fff]
[    0.180815] pci_bus 0000:01: resource 1 [mem 0x90400000-0x905fffff]
[    0.180818] pci_bus 0000:01: resource 2 [mem 0x90600000-0x907fffff 64bit pref]
[    0.180821] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.180824] pci_bus 0000:02: resource 1 [mem 0x90100000-0x901fffff]
[    0.180827] pci_bus 0000:02: resource 2 [mem 0x90800000-0x909fffff 64bit pref]
[    0.180830] pci_bus 0000:03: resource 0 [io  0x5000-0x5fff]
[    0.180833] pci_bus 0000:03: resource 1 [mem 0x90a00000-0x90bfffff]
[    0.180836] pci_bus 0000:03: resource 2 [mem 0x90c00000-0x90dfffff 64bit pref]
[    0.180839] pci_bus 0000:04: resource 0 [io  0x6000-0x6fff]
[    0.180842] pci_bus 0000:04: resource 1 [mem 0x90e00000-0x90ffffff]
[    0.180845] pci_bus 0000:04: resource 2 [mem 0x91000000-0x911fffff 64bit pref]
[    0.180848] pci_bus 0000:05: resource 0 [io  0x7000-0x7fff]
[    0.180851] pci_bus 0000:05: resource 1 [mem 0x91200000-0x913fffff]
[    0.180854] pci_bus 0000:05: resource 2 [mem 0x91400000-0x915fffff 64bit pref]
[    0.180857] pci_bus 0000:06: resource 0 [io  0x1000-0x1fff]
[    0.180860] pci_bus 0000:06: resource 1 [mem 0x90000000-0x900fffff]
[    0.180863] pci_bus 0000:06: resource 4 [io  0x0000-0xffff]
[    0.180866] pci_bus 0000:06: resource 5 [mem 0x00000000-0xfffffffff]
[    0.180908] NET: Registered protocol family 2
[    0.181000] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.181351] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.183258] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.183784] TCP: Hash tables configured (established 262144 bind 65536)
[    0.183835] TCP reno registered
[    0.183879] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.183946] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.184165] NET: Registered protocol family 1
[    0.184231] pci 0000:00:02.0: Boot video device
[    0.184595] PCI: CLS 64 bytes, default 64
[    0.184649] Trying to unpack rootfs image as initramfs...
[    0.184745] rootfs image is not initramfs (junk in compressed archive); looks like an initrd
[    0.187025] Freeing initrd memory: 2000k freed
[    0.189393] audit: initializing netlink socket (disabled)
[    0.189458] type=2000 audit(1300127009.188:1): initialized
[    0.194973] fuse init (API version 7.16)
[    0.195296] msgmni has been set to 3959
[    0.195467] io scheduler noop registered
[    0.195512] io scheduler deadline registered
[    0.195639] io scheduler cfq registered (default)
[    0.196298] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
[    0.206035] ACPI: Sleep Button [SLPB]
[    0.206209] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.206291] ACPI: Power Button [PWRF]
[    0.206441] ACPI: acpi_idle registered with cpuidle
[    0.208232] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.262463] Real Time Clock Driver v1.12b
[    0.262737] Linux agpgart interface v0.103
[    0.262942] agpgart-intel 0000:00:00.0: Intel 965G Chipset
[    0.263136] agpgart-intel 0000:00:00.0: detected gtt size: 524288K total, 262144K mappable
[    0.263831] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
[    0.264073] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x80000000
[    0.264253] [drm] Initialized drm 1.1.0 20060810
[    0.264322] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.264375] i915 0000:00:02.0: setting latency timer to 64
[    0.329569] i915 0000:00:02.0: irq 40 for MSI/MSI-X
[    0.329576] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.329629] [drm] Driver supports precise vblank timestamp query.
[    0.334403] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    0.334789] [drm] initialized overlay support
[    0.420729] Console: switching to colour frame buffer device 160x64
[    0.424355] fb0: inteldrmfb frame buffer device
[    0.424380] drm: registered panic notifier
[    0.424560] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    0.436706] FDC 0 is a National Semiconductor PC87306
[    0.440180] brd: module loaded
[    0.441467] loop: module loaded
[    0.441711] ahci 0000:00:1f.2: version 3.0
[    0.441726] ahci 0000:00:1f.2: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.441807] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    0.441873] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0x33 impl SATA mode
[    0.441919] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slum part ccc ems 
[    0.441960] ahci 0000:00:1f.2: setting latency timer to 64
[    0.449491] scsi0 : ahci
[    0.449694] scsi1 : ahci
[    0.449855] scsi2 : ahci
[    0.450040] scsi3 : ahci
[    0.450200] scsi4 : ahci
[    0.450359] scsi5 : ahci
[    0.450644] ata1: SATA max UDMA/133 abar m2048@0x90325000 port 0x90325100 irq 41
[    0.450685] ata2: SATA max UDMA/133 abar m2048@0x90325000 port 0x90325180 irq 41
[    0.450723] ata3: DUMMY
[    0.450739] ata4: DUMMY
[    0.450755] ata5: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 41
[    0.450797] ata6: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 41
[    0.451203] pata_marvell 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.451266] pata_marvell 0000:02:00.0: setting latency timer to 64
[    0.451785] scsi6 : pata_marvell
[    0.451948] scsi7 : pata_marvell
[    0.452106] ata7: PATA max UDMA/100 cmd 0x2018 ctl 0x2024 bmdma 0x2000 irq 17
[    0.452145] ata8: DUMMY
[    0.452529] tun: Universal TUN/TAP device driver, 1.6
[    0.452558] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.452666] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.452719] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.452774] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    0.452779] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    0.452837] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    0.455082] ehci_hcd 0000:00:1a.7: debug port 1
[    0.459008] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    0.459025] ehci_hcd 0000:00:1a.7: irq 18, io mem 0x90325c00
[    0.470035] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    0.471565] hub 1-0:1.0: USB hub found
[    0.472862] hub 1-0:1.0: 4 ports detected
[    0.474228] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.475539] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.475543] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.476838] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    0.484062] ehci_hcd 0000:00:1d.7: debug port 1
[    0.489276] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    0.489291] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x90325800
[    0.500034] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.501515] hub 2-0:1.0: USB hub found
[    0.502770] hub 2-0:1.0: 6 ports detected
[    0.504127] uhci_hcd: USB Universal Host Controller Interface driver
[    0.505463] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.506729] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.506733] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    0.507972] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    0.514061] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000030c0
[    0.515512] hub 3-0:1.0: USB hub found
[    0.516737] hub 3-0:1.0: 2 ports detected
[    0.518024] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.519242] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    0.519246] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    0.520475] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    0.526059] uhci_hcd 0000:00:1a.1: irq 21, io base 0x000030a0
[    0.527509] hub 4-0:1.0: USB hub found
[    0.528747] hub 4-0:1.0: 2 ports detected
[    0.530044] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.531290] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.531294] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.532532] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    0.538050] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00003080
[    0.539489] hub 5-0:1.0: USB hub found
[    0.540714] hub 5-0:1.0: 2 ports detected
[    0.542012] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.543251] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.543255] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.544485] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    0.550062] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00003060
[    0.551486] hub 6-0:1.0: USB hub found
[    0.552715] hub 6-0:1.0: 2 ports detected
[    0.554026] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.555298] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.555302] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.556581] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    0.562051] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00003040
[    0.563551] hub 7-0:1.0: USB hub found
[    0.564855] hub 7-0:1.0: 2 ports detected
[    0.566307] usbcore: registered new interface driver cdc_acm
[    0.567611] cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
[    0.568985] usbcore: registered new interface driver usblp
[    0.570322] Initializing USB Mass Storage driver...
[    0.571719] usbcore: registered new interface driver usb-storage
[    0.573042] USB Mass Storage support registered.
[    0.574534] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    0.578986] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.580336] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.581891] mousedev: PS/2 mouse device common for all mice
[    0.583565] coretemp coretemp.0: TjMax is assumed as 100 C!
[    0.585034] coretemp coretemp.1: TjMax is assumed as 100 C!
[    0.586427] cpuidle: using governor ladder
[    0.587737] cpuidle: using governor menu
[    0.589424] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.590788] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[    0.590812] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    0.606406] ata7.00: ATAPI: _NEC DVD_RW ND-3520AW, 3.07, max UDMA/33
[    0.612950] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    0.613449] ata7.00: configured for UDMA/33
[    0.688225] ALSA device list:
[    0.689587]   #0: HDA Intel at 0x90320000 irq 42
[    0.690972] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    0.692544] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.693935] TCP cubic registered
[    0.695284] NET: Registered protocol family 17
[    0.696650] NET: Registered protocol family 15
[    0.755021] ata2: SATA link down (SStatus 0 SControl 300)
[    0.756433] ata1: SATA link down (SStatus 0 SControl 300)
[    1.173064] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.174466] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.175878] ata5.00: ATA-7: WDC WD1600AAJS-60PSA0, 21.12M21, max UDMA/100
[    1.177281] ata5.00: 312581808 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    1.179269] ata5.00: configured for UDMA/100
[    1.180732] scsi 4:0:0:0: Direct-Access     ATA      WDC WD1600AAJS-6 21.1 PQ: 0 ANSI: 5
[    1.182347] sd 4:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    1.182430] sd 4:0:0:0: Attached scsi generic sg0 type 0
[    1.185133] sd 4:0:0:0: [sda] Write Protect is off
[    1.186488] sd 4:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.186516] sd 4:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.190038] Refined TSC clocksource calibration: 1864.803 MHz.
[    1.191475] Switching to clocksource tsc
[    1.217921] ata6.00: ATA-7: MAXTOR STM3160215AS, 3.AAD, max UDMA/133
[    1.219369] ata6.00: 312581808 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.246657]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 >
[    1.248908] sd 4:0:0:0: [sda] Attached SCSI disk
[    1.276227] ata6.00: configured for UDMA/133
[    1.277731] scsi 5:0:0:0: Direct-Access     ATA      MAXTOR STM316021 3.AA PQ: 0 ANSI: 5
[    1.279360] sd 5:0:0:0: [sdb] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    1.279441] sd 5:0:0:0: Attached scsi generic sg1 type 0
[    1.282423] sd 5:0:0:0: [sdb] Write Protect is off
[    1.283845] sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.283857] scsi 6:0:0:0: CD-ROM            _NEC     DVD_RW ND-3520AW 3.07 PQ: 0 ANSI: 5
[    1.283873] sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.288178] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[    1.289669] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.291331] sr 6:0:0:0: Attached scsi CD-ROM sr0
[    1.291508] sr 6:0:0:0: Attached scsi generic sg2 type 5
[    1.324243]  sdb: sdb1 sdb2
[    1.326143] sd 5:0:0:0: [sdb] Attached SCSI disk
[    1.343155] input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio1/input/input3
[    1.347391] RAMDISK: ext2 filesystem found at block 0
[    1.348930] RAMDISK: Loading 2000KiB [1 disk] into ram disk... |/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|done.
[    1.365091] EXT2-fs (ram0): warning: mounting unchecked fs, running e2fsck is recommended
[    1.366670] VFS: Mounted root (ext2 filesystem) on device 1:0.
[    1.399135] EXT3-fs: barriers not enabled
[    1.403158] kjournald starting.  Commit interval 5 seconds
[    1.403189] EXT3-fs (sda2): mounted filesystem with ordered data mode
[    1.403197] VFS: Mounted root (ext3 filesystem) readonly on device 8:2.
[    1.403199] Trying to move old root to /initrd ... /initrd does not exist. Ignored.
[    1.409155] Unmounting old root
[    1.416033] Trying to free ramdisk memory ... okay
[    1.419282] Freeing unused kernel memory: 624k freed
[    1.420986] Write protecting the kernel read-only data: 8192k
[    1.431414] Freeing unused kernel memory: 2012k freed
[    1.434089] Freeing unused kernel memory: 92k freed
[    3.494497] udev: starting version 151
[    3.494579] udevd (900): /proc/900/oom_adj is deprecated, please use /proc/900/oom_score_adj instead.
[    3.649300] 8139too: 8139too Fast Ethernet driver 0.9.28
[    3.649345] 8139too 0000:06:01.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    3.649774] 8139too 0000:06:01.0: eth0: RealTek RTL8139 at 0xffffc9000006e000, 00:e0:4c:f0:a9:84, IRQ 22
[    3.725107] udev: renamed network interface eth0 to eth1
[    3.911774] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.20-k2
[    3.911777] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    3.911815] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    3.911824] e1000e 0000:00:19.0: setting latency timer to 64
[    3.911940] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[    4.180127] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:19:d1:00:44:f5
[    4.180132] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    4.180156] e1000e 0000:00:19.0: eth0: MAC: 6, PHY: 6, PBA No: FFFFFF-0FF
[    5.771377] EXT3-fs (sda2): using internal journal
[    7.171661] EXT3-fs: barriers not enabled
[    7.171888] kjournald starting.  Commit interval 5 seconds
[    7.172065] EXT3-fs (sda5): using internal journal
[    7.172070] EXT3-fs (sda5): mounted filesystem with ordered data mode
[    7.198360] EXT3-fs: barriers not enabled
[    7.198536] kjournald starting.  Commit interval 5 seconds
[    7.199042] EXT3-fs (sda6): using internal journal
[    7.199046] EXT3-fs (sda6): mounted filesystem with ordered data mode
[    7.209951] EXT3-fs: barriers not enabled
[    7.210126] kjournald starting.  Commit interval 5 seconds
[    7.210324] EXT3-fs (sda8): using internal journal
[    7.210328] EXT3-fs (sda8): mounted filesystem with ordered data mode
[    7.291940] SGI XFS with security attributes, large block/inode numbers, no debug enabled
[    7.312356] XFS mounting filesystem sda9
[    7.381555] Ending clean XFS mount for filesystem: sda9
[    7.496909] Adding 995992k swap on /dev/sda7.  Priority:-1 extents:1 across:995992k 
[   14.532215] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[   14.583074] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[   21.922463] eth1: link up, 100Mbps, full-duplex, lpa 0x45E1
[ 2512.924027] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
[ 2512.924719] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -11 (awaiting 261386 at 261385, next 261414)
[ 2512.924945] [drm:init_ring_common] *ERROR* render ring initialization failed ctl 00000000 head 00000000 tail 00000000 start 00000000
[ 2513.060468] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.064745] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.075016] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.078828] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.085310] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.095605] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.098827] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.105904] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.116197] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.118824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.126498] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.136792] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.138824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.147094] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.157386] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.158928] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.167689] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.177986] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.178907] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.188283] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.198580] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.198908] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.208879] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.218887] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.219180] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.229473] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.238886] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.239696] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.249992] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.258866] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.260301] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.270586] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.278866] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.280887] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.291184] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.298826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.301487] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.311782] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.318846] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.322082] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.332381] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.338845] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.342683] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.352977] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.358825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.363283] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.373578] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.378825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.383882] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.394177] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.398825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.404478] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.414857] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.418826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.425160] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.438846] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.445678] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.456057] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.458824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.466359] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.476573] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.478824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.486955] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.497175] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.498856] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.507556] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.517852] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.518907] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.528154] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.538449] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.538928] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.548754] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.558887] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.559052] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.569350] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.578886] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.579648] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.589944] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.598866] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.600247] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.610543] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.618866] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.620843] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.631137] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.638866] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.641444] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.651738] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.658846] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.662041] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.672334] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.678845] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.682636] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.692931] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.698826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.703234] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.713529] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.718825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.723831] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.734132] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.738847] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.744427] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.754724] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.758825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.765028] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.775322] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.778825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.785624] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.795921] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.798825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.806223] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.816519] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.818824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.826818] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.837115] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.838927] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.847415] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.857710] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.858927] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.868019] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.878306] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.878907] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.888612] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.898846] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.898908] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.909202] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.918886] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.919501] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.929798] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.938804] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.940100] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.950394] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.958866] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.960693] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.970990] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.978866] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.981291] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.991585] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2513.998846] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.001887] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.012182] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.018845] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.022482] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.032776] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.038852] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.043078] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.053372] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.058825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.063676] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.073971] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.078825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.084271] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.094567] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.098805] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.104869] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.115163] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.118825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.125462] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.135765] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.138826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.146062] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.156360] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.158825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.166659] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.176956] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.178824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.187258] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.197636] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.198847] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.207935] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.218228] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.218908] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.228529] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.238823] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.238887] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.249123] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.258887] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.259425] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.269719] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.278886] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.280028] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.290318] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.298846] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.300620] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.310915] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.318866] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.321215] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.331512] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.338846] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.341810] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.352108] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.358845] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.362408] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.372704] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.378825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.383009] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.393298] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.398825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.403603] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.413896] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.418826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.424197] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.434490] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.438826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.444794] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.455086] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.458825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.465388] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.475681] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.478825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.485985] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.496289] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.498825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.506579] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.516875] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.518824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.527177] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.537388] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.538927] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.547691] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.557985] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.558907] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.568287] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.578581] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.578908] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.588883] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.598845] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.599184] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.609482] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.618886] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.619782] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.630077] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.638866] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.640383] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.650676] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.658866] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.660977] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.671273] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.678845] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.681576] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.691872] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.698846] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.702175] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.712470] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.718825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.722692] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.732989] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.738826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.743288] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.753585] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.758825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.763886] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.774180] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.778824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.784482] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.794779] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.798825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.805081] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.815379] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.818825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.825679] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.835978] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.838825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.846280] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.856578] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.858824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.866882] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.877178] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.878927] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.887485] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.897866] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.898825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.908086] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.918463] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.918908] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.928686] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.938887] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.939068] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.949284] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.958906] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.959667] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.969963] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.978865] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.980277] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.990565] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2514.998825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.018825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.038824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.058845] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.073059] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.078825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.083362] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.093659] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.098824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.103964] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.114258] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.118825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.138823] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.158824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.178825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.198824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.218824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.238825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.258865] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.278886] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.279075] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.298823] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.318823] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.338845] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.358866] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.378824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.398886] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.418824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.438825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.458865] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.478825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.485082] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.498804] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.518825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.538845] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.558866] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.578824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.598803] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.618865] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.638823] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.658846] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.678824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.698825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.718845] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.738825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.758845] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.778825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.798845] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.818825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.838825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.858845] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.878825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.886676] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.897032] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.898826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.907248] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.917621] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.918907] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.927842] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.938220] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.938908] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.948441] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.958739] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.958887] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.969121] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.978886] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.979419] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.989635] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2515.998927] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.000024] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.010231] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.018867] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.020531] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.030830] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.038866] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.041213] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.051425] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.058846] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.061811] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.072104] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.078845] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.082406] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.092697] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.098825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.113224] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.118825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.123604] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.133911] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.138825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.144206] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.154499] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.158826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.164801] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.178827] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.198803] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.218825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.238825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.258845] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.278845] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.298823] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.318926] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.319390] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.338887] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.339995] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.350206] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.358866] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.360506] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.370886] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.378865] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.381185] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.391480] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.398846] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.401779] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.411993] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.418846] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.422377] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.432588] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.438825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.442973] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.453189] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.458825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.463569] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.473867] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.478825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.484087] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.494382] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.498804] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.504681] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.514978] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.518825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.525361] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.535658] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.538825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.545958] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.556253] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.558824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.566556] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.576852] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.578824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.587155] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.597448] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.598825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.607750] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.618047] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.618908] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.628347] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.638644] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.638825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.648946] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.658826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.678825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.698824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.718825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.738807] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.758845] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.778825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.798885] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.818824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.838845] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.858845] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.878824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.898824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.918825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.938825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.958845] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.978825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2516.998845] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.018845] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.038824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.058866] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.078824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.098823] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.118825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.138822] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.158824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.178825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.198824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.218825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.238825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.258865] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.278866] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.298866] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.318825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.338825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.358845] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.369939] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.378866] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.380969] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.390517] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.398805] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.400811] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.411110] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.418843] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.421409] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.431705] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.438843] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.442012] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.452304] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.458843] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.462606] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.472904] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.478823] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.483281] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.498823] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.503883] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.514102] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.518823] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.524404] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.534697] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.538823] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.544998] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.555300] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.558823] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.565595] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.575894] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.578822] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.586190] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.596487] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.598822] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.606792] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.618824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.638845] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.658824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.678825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.698822] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.709820] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.718823] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.738866] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.751019] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.758823] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.778825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.798822] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.818866] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.823176] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.838825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.858824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.878824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.898802] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.905488] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.915786] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.918823] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.926087] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.936463] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.938822] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.958803] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.978824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.987885] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.998260] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2517.998862] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.018805] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.029080] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.038884] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.039457] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.058824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.078825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.098823] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.118845] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.121775] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.138825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.158825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.173301] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.178823] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.198822] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.218846] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.238825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.258823] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.278825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.298822] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.318846] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.338824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.358824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.378825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.398822] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.418866] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.438865] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.441080] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.458824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.478825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.498802] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.518824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.538825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.558803] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.578825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.598802] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.618846] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.638825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.658824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.678824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.698822] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.718868] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.738867] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.749986] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.758864] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.760279] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.770563] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.778864] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.780860] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.791157] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.798822] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.801538] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.818866] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.838825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.858824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.863407] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.878824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.898822] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.904600] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.918824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.935495] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.938822] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.956020] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.958822] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.966311] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.976610] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.978822] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.986904] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.997203] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2518.998823] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.007502] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.018824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.038825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.058824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.072031] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
[ 2519.072049] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -11 (awaiting 261541 at 261385, next 261542)
[ 2519.072389] [drm:init_ring_common] *ERROR* render ring initialization failed ctl 00000000 head 00000000 tail 00000000 start 00000000
[ 2519.243804] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.244437] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.246828] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.254800] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.265010] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.266929] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.275389] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.285601] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.286908] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.295990] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.306200] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.306929] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.326802] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.326868] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.337179] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.346827] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.366887] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.368076] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.386828] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.398891] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.406828] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.426826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.446826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.466847] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.481282] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.486826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.491579] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.501794] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.506826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.512174] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.522465] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.526827] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.532770] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.543066] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.546826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.553366] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.563663] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.566826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.573965] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.584259] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.586825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.594481] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.604859] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.606827] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.615159] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.626827] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.646826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.666847] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.686826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.706906] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.707934] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.726826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.738829] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.746827] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.766867] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.769720] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.779943] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.786826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.806826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.826825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.831516] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.846828] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.866847] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.886826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.906846] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.924153] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.926826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.946826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.966907] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.975642] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2519.986847] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.006825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.016836] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.026826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.046826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.066867] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.086866] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.088902] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.106869] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.126825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.146846] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.150698] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.166849] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.186826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.206827] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.212489] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.226827] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.246826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.263978] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.266826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.274272] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.286827] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.294868] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.305162] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.306949] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.315463] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.325758] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.326908] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.336055] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.346351] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.346909] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.356653] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.366888] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.366949] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.377247] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.386827] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.406825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.426827] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.446826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.466846] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.486826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.506846] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.526826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.546846] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.566866] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.572933] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.586828] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.606805] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.626826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.646825] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.666867] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.686826] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.706824] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.726846] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
[ 2520.744007] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
[ 2520.744060] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -11 (awaiting 261710 at 261385, next 261711)
[ 2565.843553] SysRq : SAK
[ 2565.843571] SAK: killed process 5202 (X): task_session(p)==tty->session
[ 2565.843671] SAK: killed process 5202 (X): task_session(p)==tty->session
[ 2565.883166] SysRq : Kill All Tasks
[ 2567.915173] SysRq : Emergency Sync
[ 2567.915531] Emergency Sync complete

--MP_/g2ElFXTj4ZSUabSIjQUyYvn
Content-Type: text/x-log
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=Xorg.0.log

[    23.447] 
X.Org X Server 1.9.4
Release Date: 2011-02-04
[    23.447] X Protocol Version 11, Revision 0
[    23.447] Build Operating System: Linux 2.6.38-rc5-00100-g0cc9d52 x86_64 Gentoo
[    23.447] Current Operating System: Linux tux 2.6.38-rc8 #11 SMP Wed Mar 9 20:35:32 CET 2011 x86_64
[    23.447] Kernel command line: root=/dev/sda2 ro i915.modeset=1
[    23.447] Build Date: 19 February 2011  10:49:28AM
[    23.447]  
[    23.447] Current version of pixman: 0.20.2
[    23.447] 	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
[    23.447] Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[    23.447] (==) Log file: "/var/log/Xorg.0.log", Time: Mon Mar 14 19:23:53 2011
[    23.499] (==) Using config file: "/etc/X11/xorg.conf"
[    23.499] (==) Using system config directory "/usr/share/X11/xorg.conf.d"
[    23.525] (==) ServerLayout "Simple Layout"
[    23.525] (**) |-->Screen "Screen 1" (0)
[    23.525] (**) |   |-->Monitor "Philips"
[    23.526] (**) |   |-->Device "Intel"
[    23.526] (**) |-->Input Device "Mouse1"
[    23.526] (**) |-->Input Device "Keyboard1"
[    23.526] (==) Automatically adding devices
[    23.526] (==) Automatically enabling devices
[    23.555] (WW) The directory "/usr/share/fonts/CID" does not exist.
[    23.555] 	Entry deleted from font path.
[    23.585] (WW) The directory "/usr/share/fonts/local" does not exist.
[    23.585] 	Entry deleted from font path.
[    23.651] (**) FontPath set to:
	/usr/share/fonts/misc,
	/usr/share/fonts/Type1,
	/usr/share/fonts/75dpi,
	/usr/share/fonts/100dpi,
	/usr/local/share/fonts,
	/usr/share/fonts/misc/,
	/usr/share/fonts/TTF/,
	/usr/share/fonts/OTF/,
	/usr/share/fonts/Type1/,
	/usr/share/fonts/100dpi/,
	/usr/share/fonts/75dpi/
[    23.651] (==) ModulePath set to "/usr/lib64/xorg/modules"
[    23.651] (WW) AllowEmptyInput is on, devices using drivers 'kbd', 'mouse' or 'vmmouse' will be disabled.
[    23.651] (WW) Disabling Mouse1
[    23.651] (WW) Disabling Keyboard1
[    23.651] (II) Loader magic: 0x7cc080
[    23.651] (II) Module ABI versions:
[    23.651] 	X.Org ANSI C Emulation: 0.4
[    23.651] 	X.Org Video Driver: 8.0
[    23.651] 	X.Org XInput driver : 11.0
[    23.651] 	X.Org Server Extension : 4.0
[    23.652] (--) PCI:*(0:0:2:0) 8086:29a2:8086:514d rev 2, Mem @ 0x90200000/1048576, 0x80000000/268435456, I/O @ 0x00003410/8
[    23.652] (II) Open ACPI successful (/var/run/acpid.socket)
[    23.652] (II) "extmod" will be loaded. This was enabled by default and also specified in the config file.
[    23.652] (II) "dbe" will be loaded. This was enabled by default and also specified in the config file.
[    23.652] (II) "glx" will be loaded. This was enabled by default and also specified in the config file.
[    23.652] (II) "record" will be loaded by default.
[    23.652] (II) "dri" will be loaded. This was enabled by default and also specified in the config file.
[    23.652] (II) "dri2" will be loaded by default.
[    23.652] (II) LoadModule: "dbe"
[    23.659] (II) Loading /usr/lib64/xorg/modules/extensions/libdbe.so
[    23.670] (II) Module dbe: vendor="X.Org Foundation"
[    23.670] 	compiled for 1.9.4, module version = 1.0.0
[    23.670] 	Module class: X.Org Server Extension
[    23.670] 	ABI class: X.Org Server Extension, version 4.0
[    23.670] (II) Loading extension DOUBLE-BUFFER
[    23.671] (II) LoadModule: "extmod"
[    23.706] (II) Loading /usr/lib64/xorg/modules/extensions/libextmod.so
[    23.714] (II) Module extmod: vendor="X.Org Foundation"
[    23.714] 	compiled for 1.9.4, module version = 1.0.0
[    23.714] 	Module class: X.Org Server Extension
[    23.714] 	ABI class: X.Org Server Extension, version 4.0
[    23.714] (II) Loading extension MIT-SCREEN-SAVER
[    23.714] (II) Loading extension XFree86-VidModeExtension
[    23.714] (II) Loading extension DPMS
[    23.714] (II) Loading extension XVideo
[    23.714] (II) Loading extension XVideo-MotionCompensation
[    23.714] (II) Loading extension X-Resource
[    23.714] (II) LoadModule: "glx"
[    23.714] (II) Loading /usr/lib64/xorg/modules/extensions/libglx.so
[    23.732] (II) Module glx: vendor="X.Org Foundation"
[    23.732] 	compiled for 1.9.4, module version = 1.0.0
[    23.732] 	ABI class: X.Org Server Extension, version 4.0
[    23.732] (==) AIGLX enabled
[    23.732] (II) Loading extension GLX
[    23.732] (II) LoadModule: "dri"
[    23.733] (II) Loading /usr/lib64/xorg/modules/extensions/libdri.so
[    23.791] (II) Module dri: vendor="X.Org Foundation"
[    23.791] 	compiled for 1.9.4, module version = 1.0.0
[    23.792] 	ABI class: X.Org Server Extension, version 4.0
[    23.792] (II) Loading extension XFree86-DRI
[    23.792] (II) LoadModule: "record"
[    23.792] (II) Loading /usr/lib64/xorg/modules/extensions/librecord.so
[    23.792] (II) Module record: vendor="X.Org Foundation"
[    23.792] 	compiled for 1.9.4, module version = 1.13.0
[    23.792] 	Module class: X.Org Server Extension
[    23.792] 	ABI class: X.Org Server Extension, version 4.0
[    23.792] (II) Loading extension RECORD
[    23.792] (II) LoadModule: "dri2"
[    23.792] (II) Loading /usr/lib64/xorg/modules/extensions/libdri2.so
[    23.793] (II) Module dri2: vendor="X.Org Foundation"
[    23.793] 	compiled for 1.9.4, module version = 1.2.0
[    23.793] 	ABI class: X.Org Server Extension, version 4.0
[    23.793] (II) Loading extension DRI2
[    23.793] (II) LoadModule: "intel"
[    23.809] (II) Loading /usr/lib64/xorg/modules/drivers/intel_drv.so
[    23.871] (II) Module intel: vendor="X.Org Foundation"
[    23.871] 	compiled for 1.9.4, module version = 2.14.0
[    23.871] 	Module class: X.Org Video Driver
[    23.871] 	ABI class: X.Org Video Driver, version 8.0
[    23.871] (II) intel: Driver for Intel Integrated Graphics Chipsets: i810,
	i810-dc100, i810e, i815, i830M, 845G, 854, 852GM/855GM, 865G, 915G,
	E7221 (i915), 915GM, 945G, 945GM, 945GME, Pineview GM, Pineview G,
	965G, G35, 965Q, 946GZ, 965GM, 965GME/GLE, G33, Q35, Q33, GM45,
	4 Series, G45/G43, Q45/Q43, G41, B43, B43, Clarkdale, Arrandale,
	Sandybridge, Sandybridge, Sandybridge, Sandybridge, Sandybridge,
	Sandybridge, Sandybridge
[    23.871] (++) using VT number 7

[    23.921] drmOpenDevice: node name is /dev/dri/card0
[    23.921] drmOpenDevice: open result is 9, (OK)
[    23.922] drmOpenByBusid: Searching for BusID pci:0000:00:02.0
[    23.922] drmOpenDevice: node name is /dev/dri/card0
[    23.922] drmOpenDevice: open result is 9, (OK)
[    23.922] drmOpenByBusid: drmOpenMinor returns 9
[    23.922] drmOpenByBusid: drmGetBusid reports pci:0000:00:02.0
[    23.922] (**) intel(0): Depth 24, (--) framebuffer bpp 32
[    23.922] (==) intel(0): RGB weight 888
[    23.922] (==) intel(0): Default visual is TrueColor
[    23.922] (II) intel(0): Integrated Graphics Chipset: Intel(R) 965G
[    23.922] (--) intel(0): Chipset: "965G"
[    23.922] (**) intel(0): Tiling enabled
[    23.922] (**) intel(0): SwapBuffers wait enabled
[    23.922] (==) intel(0): video overlay key set to 0x101fe
[    23.989] (II) intel(0): Output VGA1 using monitor section Philips
[    24.057] (II) intel(0): EDID for output VGA1
[    24.057] (II) intel(0): Manufacturer: PHL  Model: 81e  Serial#: 40760
[    24.057] (II) intel(0): Year: 2005  Week: 2
[    24.058] (II) intel(0): EDID Version: 1.3
[    24.058] (II) intel(0): Analog Display Input,  Input Voltage Level: 0.700/0.300 V
[    24.058] (II) intel(0): Signal levels configurable
[    24.058] (II) intel(0): Sync:  Separate  Composite  SyncOnGreenSerration on. V.Sync Pulse req. if CompSync or SyncOnGreen
[    24.058] (II) intel(0): Max Image Size [cm]: horiz.: 34  vert.: 27
[    24.058] (II) intel(0): Gamma: 2.20
[    24.058] (II) intel(0): DPMS capabilities: StandBy Suspend Off; RGB/Color Display
[    24.058] (II) intel(0): Default color space is primary color space
[    24.058] (II) intel(0): First detailed timing is preferred mode
[    24.058] (II) intel(0): redX: 0.633 redY: 0.336   greenX: 0.300 greenY: 0.586
[    24.058] (II) intel(0): blueX: 0.146 blueY: 0.103   whiteX: 0.313 whiteY: 0.329
[    24.058] (II) intel(0): Supported established timings:
[    24.058] (II) intel(0): 720x400@70Hz
[    24.058] (II) intel(0): 640x480@60Hz
[    24.058] (II) intel(0): 640x480@67Hz
[    24.058] (II) intel(0): 640x480@72Hz
[    24.058] (II) intel(0): 640x480@75Hz
[    24.058] (II) intel(0): 800x600@56Hz
[    24.058] (II) intel(0): 800x600@60Hz
[    24.058] (II) intel(0): 800x600@72Hz
[    24.058] (II) intel(0): 800x600@75Hz
[    24.058] (II) intel(0): 832x624@75Hz
[    24.058] (II) intel(0): 1024x768@60Hz
[    24.058] (II) intel(0): 1024x768@70Hz
[    24.058] (II) intel(0): 1024x768@75Hz
[    24.058] (II) intel(0): 1280x1024@75Hz
[    24.058] (II) intel(0): 1152x864@75Hz
[    24.058] (II) intel(0): Manufacturer's mask: 0
[    24.058] (II) intel(0): Supported standard timings:
[    24.058] (II) intel(0): #0: hsize: 1152  vsize 864  refresh: 70  vid: 19057
[    24.058] (II) intel(0): #1: hsize: 1152  vsize 864  refresh: 75  vid: 20337
[    24.058] (II) intel(0): #2: hsize: 1280  vsize 960  refresh: 60  vid: 16513
[    24.058] (II) intel(0): #3: hsize: 1280  vsize 1024  refresh: 60  vid: 32897
[    24.058] (II) intel(0): Supported detailed timing:
[    24.058] (II) intel(0): clock: 108.0 MHz   Image Size:  338 x 270 mm
[    24.058] (II) intel(0): h_active: 1280  h_sync: 1328  h_sync_end 1440 h_blank_end 1688 h_border: 0
[    24.058] (II) intel(0): v_active: 1024  v_sync: 1025  v_sync_end 1028 v_blanking: 1066 v_border: 0
[    24.058] (II) intel(0): Serial No:  VN  040760
[    24.058] (II) intel(0): Monitor name: Philips 170S
[    24.058] (II) intel(0): Ranges: V min: 56 V max: 76 Hz, H min: 30 H max: 82 kHz, PixClock max 145 MHz
[    24.058] (II) intel(0): EDID (in hex):
[    24.058] (II) intel(0): 	00ffffffffffff00410c1e08389f0000
[    24.058] (II) intel(0): 	020f01031f221b78ee0c95a2564c9625
[    24.058] (II) intel(0): 	1a5054bfef80714a714f814081800101
[    24.058] (II) intel(0): 	010101010101302a009851002a403070
[    24.058] (II) intel(0): 	1300520e1100001e000000ff0020564e
[    24.058] (II) intel(0): 	20203034303736300a20000000fc0050
[    24.058] (II) intel(0): 	68696c69707320313730530a000000fd
[    24.058] (II) intel(0): 	00384c1e520e000a2020202020200014
[    24.058] (II) intel(0): EDID vendor "PHL", prod id 2078
[    24.080] (II) intel(0): Using hsync ranges from config file
[    24.080] (II) intel(0): Using vrefresh ranges from config file
[    24.080] (II) intel(0): Printing DDC gathered Modelines:
[    24.080] (II) intel(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    24.080] (II) intel(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    24.080] (II) intel(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    24.080] (II) intel(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    24.080] (II) intel(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
[    24.080] (II) intel(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[    24.080] (II) intel(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    24.080] (II) intel(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    24.080] (II) intel(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    24.080] (II) intel(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    24.080] (II) intel(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    24.080] (II) intel(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    24.080] (II) intel(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    24.080] (II) intel(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    24.080] (II) intel(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    24.080] (II) intel(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    24.080] (II) intel(0): Modeline "1152x864"x70.0   96.77  1152 1224 1344 1536  864 865 868 900 -hsync +vsync (63.0 kHz)
[    24.080] (II) intel(0): Modeline "1280x960"x0.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[    24.080] (II) intel(0): Not using mode "1280x1024" (vrefresh out of range)
[    24.080] (II) intel(0): Not using mode "1152x864" (vrefresh out of range)
[    24.080] (II) intel(0): Not using mode "1152x864" (vrefresh out of range)
[    24.080] (II) intel(0): Not using mode "1024x768" (vrefresh out of range)
[    24.080] (II) intel(0): Not using mode "1024x768" (vrefresh out of range)
[    24.080] (II) intel(0): Not using mode "832x624" (vrefresh out of range)
[    24.080] (II) intel(0): Not using mode "800x600" (vrefresh out of range)
[    24.080] (II) intel(0): Not using mode "800x600" (vrefresh out of range)
[    24.080] (II) intel(0): Not using mode "640x480" (vrefresh out of range)
[    24.080] (II) intel(0): Not using mode "640x480" (vrefresh out of range)
[    24.080] (II) intel(0): Not using mode "640x480" (vrefresh out of range)
[    24.080] (II) intel(0): Not using mode "720x400" (vrefresh out of range)
[    24.080] (II) intel(0): Printing probed modes for output VGA1
[    24.080] (II) intel(0): Modeline "1280x1024"x60.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    24.080] (II) intel(0): Modeline "1280x960"x60.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[    24.081] (II) intel(0): Modeline "1024x768"x60.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    24.081] (II) intel(0): Modeline "800x600"x60.3   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    24.081] (II) intel(0): Modeline "800x600"x56.2   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    24.081] (II) intel(0): Modeline "640x480"x60.0   25.20  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    24.081] (II) intel(0): Output VGA1 connected
[    24.081] (II) intel(0): Using user preference for initial modes
[    24.081] (II) intel(0): Output VGA1 using initial mode 1280x1024
[    24.081] (II) intel(0): Using default gamma of (1.0, 1.0, 1.0) unless otherwise stated.
[    24.081] (II) intel(0): Kernel page flipping support detected, enabling
[    24.081] (**) intel(0): Display dimensions: (340, 270) mm
[    24.081] (**) intel(0): DPI set to (95, 96)
[    24.081] (II) Loading sub module "fb"
[    24.081] (II) LoadModule: "fb"
[    24.081] (II) Loading /usr/lib64/xorg/modules/libfb.so
[    24.097] (II) Module fb: vendor="X.Org Foundation"
[    24.097] 	compiled for 1.9.4, module version = 1.0.0
[    24.097] 	ABI class: X.Org ANSI C Emulation, version 0.4
[    24.097] (==) Depth 24 pixmap format is 32 bpp
[    24.097] (==) intel(0): VideoRam: 262144 KB
[    24.097] (II) intel(0): [DRI2] Setup complete
[    24.097] (II) intel(0): [DRI2]   DRI driver: i965
[    24.097] (II) intel(0): Allocated new frame buffer 1280x1024 stride 5120, tiled
[    24.134] (II) UXA(0): Driver registered support for the following operations:
[    24.134] (II)         solid
[    24.134] (II)         copy
[    24.134] (II)         composite (RENDER acceleration)
[    24.134] (II)         put_image
[    24.134] (II)         get_image
[    24.134] (==) intel(0): Backing store disabled
[    24.134] (==) intel(0): Silken mouse enabled
[    24.136] (II) intel(0): Initializing HW Cursor
[    24.155] (II) intel(0): RandR 1.2 enabled, ignore the following RandR disabled message.
[    24.155] (**) intel(0): DPMS enabled
[    24.155] (==) intel(0): Intel XvMC decoder enabled
[    24.155] (II) intel(0): Set up textured video
[    24.155] (II) intel(0): Set up overlay video
[    24.155] (II) intel(0): [XvMC] i965_xvmc driver initialized.
[    24.155] (II) intel(0): direct rendering: DRI2 Enabled
[    24.155] (==) intel(0): hotplug detection: "enabled"
[    24.155] (--) RandR disabled
[    24.155] (II) Initializing built-in extension Generic Event Extension
[    24.155] (II) Initializing built-in extension SHAPE
[    24.155] (II) Initializing built-in extension MIT-SHM
[    24.155] (II) Initializing built-in extension XInputExtension
[    24.155] (II) Initializing built-in extension XTEST
[    24.155] (II) Initializing built-in extension BIG-REQUESTS
[    24.155] (II) Initializing built-in extension SYNC
[    24.155] (II) Initializing built-in extension XKEYBOARD
[    24.155] (II) Initializing built-in extension XC-MISC
[    24.155] (II) Initializing built-in extension XINERAMA
[    24.155] (II) Initializing built-in extension XFIXES
[    24.155] (II) Initializing built-in extension RENDER
[    24.155] (II) Initializing built-in extension RANDR
[    24.155] (II) Initializing built-in extension COMPOSITE
[    24.155] (II) Initializing built-in extension DAMAGE
[    24.404] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[    24.404] (II) AIGLX: enabled GLX_INTEL_swap_event
[    24.404] (II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_control
[    24.404] (II) AIGLX: enabled GLX_SGI_make_current_read
[    24.404] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects
[    24.404] (II) AIGLX: Loaded and initialized /usr/lib64/dri/i965_dri.so
[    24.404] (II) GLX: Initialized DRI2 GL provider for screen 0
[    24.405] (II) intel(0): Setting screen physical size to 338 x 270
[    24.834] (II) config/udev: Adding input device Power Button (/dev/input/event1)
[    24.834] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    24.834] (II) LoadModule: "evdev"
[    24.874] (II) Loading /usr/lib64/xorg/modules/input/evdev_drv.so
[    24.879] (II) Module evdev: vendor="X.Org Foundation"
[    24.879] 	compiled for 1.9.4, module version = 2.6.0
[    24.879] 	Module class: X.Org XInput Driver
[    24.879] 	ABI class: X.Org XInput driver, version 11.0
[    24.879] (**) Power Button: always reports core events
[    24.879] (**) Power Button: Device: "/dev/input/event1"
[    24.887] (--) Power Button: Found keys
[    24.887] (II) Power Button: Configuring as keyboard
[    24.887] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
[    24.887] (**) Option "xkb_rules" "evdev"
[    24.887] (**) Option "xkb_model" "evdev"
[    24.887] (**) Option "xkb_layout" "us"
[    24.913] (II) config/udev: Adding input device Sleep Button (/dev/input/event0)
[    24.913] (**) Sleep Button: Applying InputClass "evdev keyboard catchall"
[    24.913] (**) Sleep Button: always reports core events
[    24.913] (**) Sleep Button: Device: "/dev/input/event0"
[    24.916] (--) Sleep Button: Found keys
[    24.916] (II) Sleep Button: Configuring as keyboard
[    24.916] (II) XINPUT: Adding extended input device "Sleep Button" (type: KEYBOARD)
[    24.916] (**) Option "xkb_rules" "evdev"
[    24.916] (**) Option "xkb_model" "evdev"
[    24.916] (**) Option "xkb_layout" "us"
[    24.924] (II) config/udev: Adding input device AT Translated Set 2 keyboard (/dev/input/event2)
[    24.924] (**) AT Translated Set 2 keyboard: Applying InputClass "evdev keyboard catchall"
[    24.924] (**) AT Translated Set 2 keyboard: always reports core events
[    24.924] (**) AT Translated Set 2 keyboard: Device: "/dev/input/event2"
[    24.931] (--) AT Translated Set 2 keyboard: Found keys
[    24.931] (II) AT Translated Set 2 keyboard: Configuring as keyboard
[    24.931] (II) XINPUT: Adding extended input device "AT Translated Set 2 keyboard" (type: KEYBOARD)
[    24.931] (**) Option "xkb_rules" "evdev"
[    24.931] (**) Option "xkb_model" "evdev"
[    24.931] (**) Option "xkb_layout" "us"
[    24.931] (II) config/udev: Adding input device ImPS/2 Logitech Wheel Mouse (/dev/input/event3)
[    24.931] (**) ImPS/2 Logitech Wheel Mouse: Applying InputClass "evdev pointer catchall"
[    24.931] (**) ImPS/2 Logitech Wheel Mouse: always reports core events
[    24.931] (**) ImPS/2 Logitech Wheel Mouse: Device: "/dev/input/event3"
[    24.939] (--) ImPS/2 Logitech Wheel Mouse: Found 3 mouse buttons
[    24.939] (--) ImPS/2 Logitech Wheel Mouse: Found scroll wheel(s)
[    24.939] (--) ImPS/2 Logitech Wheel Mouse: Found relative axes
[    24.939] (--) ImPS/2 Logitech Wheel Mouse: Found x and y relative axes
[    24.939] (II) ImPS/2 Logitech Wheel Mouse: Configuring as mouse
[    24.939] (II) ImPS/2 Logitech Wheel Mouse: Adding scrollwheel support
[    24.939] (**) ImPS/2 Logitech Wheel Mouse: YAxisMapping: buttons 4 and 5
[    24.939] (**) ImPS/2 Logitech Wheel Mouse: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[    24.939] (II) XINPUT: Adding extended input device "ImPS/2 Logitech Wheel Mouse" (type: MOUSE)
[    24.939] (**) ImPS/2 Logitech Wheel Mouse: (accel) keeping acceleration scheme 1
[    24.939] (**) ImPS/2 Logitech Wheel Mouse: (accel) acceleration profile 0
[    24.939] (**) ImPS/2 Logitech Wheel Mouse: (accel) acceleration factor: 2.000
[    24.939] (**) ImPS/2 Logitech Wheel Mouse: (accel) acceleration threshold: 4
[    24.939] (II) ImPS/2 Logitech Wheel Mouse: initialized for relative axes.
[    24.939] (II) config/udev: Adding input device ImPS/2 Logitech Wheel Mouse (/dev/input/mouse0)
[    24.939] (II) No input driver/identifier specified (ignoring)
[    42.218] (II) intel(0): EDID vendor "PHL", prod id 2078
[    42.218] (II) intel(0): Using hsync ranges from config file
[    42.218] (II) intel(0): Using vrefresh ranges from config file
[    42.218] (II) intel(0): Printing DDC gathered Modelines:
[    42.218] (II) intel(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    42.218] (II) intel(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    42.218] (II) intel(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    42.218] (II) intel(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    42.218] (II) intel(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
[    42.218] (II) intel(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[    42.218] (II) intel(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    42.218] (II) intel(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    42.218] (II) intel(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    42.218] (II) intel(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    42.218] (II) intel(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    42.218] (II) intel(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    42.218] (II) intel(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    42.218] (II) intel(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    42.218] (II) intel(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    42.218] (II) intel(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    42.219] (II) intel(0): Modeline "1152x864"x70.0   96.77  1152 1224 1344 1536  864 865 868 900 -hsync +vsync (63.0 kHz)
[    42.219] (II) intel(0): Modeline "1280x960"x0.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[    56.830] (II) intel(0): EDID vendor "PHL", prod id 2078
[    56.830] (II) intel(0): Using hsync ranges from config file
[    56.830] (II) intel(0): Using vrefresh ranges from config file
[    56.830] (II) intel(0): Printing DDC gathered Modelines:
[    56.830] (II) intel(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    56.830] (II) intel(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    56.831] (II) intel(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    56.831] (II) intel(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    56.831] (II) intel(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
[    56.831] (II) intel(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[    56.831] (II) intel(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    56.831] (II) intel(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    56.831] (II) intel(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    56.831] (II) intel(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    56.831] (II) intel(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    56.831] (II) intel(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    56.831] (II) intel(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    56.831] (II) intel(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    56.831] (II) intel(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    56.831] (II) intel(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    56.831] (II) intel(0): Modeline "1152x864"x70.0   96.77  1152 1224 1344 1536  864 865 868 900 -hsync +vsync (63.0 kHz)
[    56.831] (II) intel(0): Modeline "1280x960"x0.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[  2512.240] [mi] EQ overflowing. The server is probably stuck in an infinite loop.
[  2512.240] 
Backtrace:
[  2512.254] 0: /usr/bin/X (xorg_backtrace+0x28) [0x4a1a78]
[  2512.254] 1: /usr/bin/X (mieqEnqueue+0x1f4) [0x4a1414]
[  2512.254] 2: /usr/bin/X (xf86PostMotionEventP+0xc4) [0x47e374]
[  2512.254] 3: /usr/lib64/xorg/modules/input/evdev_drv.so (0x7f0354270000+0x546c) [0x7f035427546c]
[  2512.254] 4: /usr/bin/X (0x400000+0x6c407) [0x46c407]
[  2512.254] 5: /usr/bin/X (0x400000+0x11a933) [0x51a933]
[  2512.254] 6: /lib/libpthread.so.0 (0x7f0358890000+0xf120) [0x7f035889f120]
[  2512.254] 7: /lib/libc.so.6 (ioctl+0x7) [0x7f03578c2107]
[  2512.254] 8: /usr/lib/libdrm.so.2 (drmIoctl+0x28) [0x7f0356290bf8]
[  2512.254] 9: /usr/lib/libdrm_intel.so.1 (drm_intel_gem_bo_map_gtt+0x7c) [0x7f0355a27f6c]
[  2512.254] 10: /usr/lib64/xorg/modules/drivers/intel_drv.so (0x7f0355c2d000+0x151c4) [0x7f0355c421c4]
[  2512.254] 11: /usr/lib64/xorg/modules/drivers/intel_drv.so (0x7f0355c2d000+0x159f9) [0x7f0355c429f9]
[  2512.254] 12: /usr/bin/X (0x400000+0x12d000) [0x52d000]
[  2512.254] 13: /usr/lib64/xorg/modules/extensions/libextmod.so (0x7f035690a000+0x10114) [0x7f035691a114]
[  2512.254] 14: /usr/bin/X (0x400000+0x2f1b9) [0x42f1b9]
[  2512.255] 15: /usr/bin/X (0x400000+0x247fb) [0x4247fb]
[  2512.255] 16: /lib/libc.so.6 (__libc_start_main+0xfd) [0x7f0357816bbd]
[  2512.255] 17: /usr/bin/X (0x400000+0x24389) [0x424389]
[  2517.380] [mi] EQ overflowing. The server is probably stuck in an infinite loop.
[  2517.380] 
Backtrace:
[  2517.380] 0: /usr/bin/X (xorg_backtrace+0x28) [0x4a1a78]
[  2517.380] 1: /usr/bin/X (mieqEnqueue+0x1f4) [0x4a1414]
[  2517.380] 2: /usr/bin/X (xf86PostMotionEventP+0xc4) [0x47e374]
[  2517.380] 3: /usr/lib64/xorg/modules/input/evdev_drv.so (0x7f0354270000+0x546c) [0x7f035427546c]
[  2517.380] 4: /usr/bin/X (0x400000+0x6c407) [0x46c407]
[  2517.380] 5: /usr/bin/X (0x400000+0x11a933) [0x51a933]
[  2517.380] 6: /lib/libpthread.so.0 (0x7f0358890000+0xf120) [0x7f035889f120]
[  2517.380] 7: /lib/libc.so.6 (ioctl+0x7) [0x7f03578c2107]
[  2517.380] 8: /usr/lib/libdrm.so.2 (drmIoctl+0x28) [0x7f0356290bf8]
[  2517.380] 9: /usr/lib/libdrm_intel.so.1 (drm_intel_gem_bo_map_gtt+0x7c) [0x7f0355a27f6c]
[  2517.380] 10: /usr/lib64/xorg/modules/drivers/intel_drv.so (0x7f0355c2d000+0x129b3) [0x7f0355c3f9b3]
[  2517.380] 11: /usr/lib64/xorg/modules/drivers/intel_drv.so (0x7f0355c2d000+0x2a102) [0x7f0355c57102]
[  2517.380] 12: /usr/bin/X (0x400000+0x157cf0) [0x557cf0]
[  2517.380] 13: /usr/bin/X (0x400000+0x30adb) [0x430adb]
[  2517.380] 14: /usr/bin/X (0x400000+0x2f1b9) [0x42f1b9]
[  2517.380] 15: /usr/bin/X (0x400000+0x247fb) [0x4247fb]
[  2517.380] 16: /lib/libc.so.6 (__libc_start_main+0xfd) [0x7f0357816bbd]
[  2517.380] 17: /usr/bin/X (0x400000+0x24389) [0x424389]

--MP_/g2ElFXTj4ZSUabSIjQUyYvn--
