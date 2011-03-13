Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab1CMOIg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 10:08:36 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:57072 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755166Ab1CMOIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 10:08:32 -0400
Message-ID: <4D7CCFC3.7030906@fastmail.fm>
Date: Sun, 13 Mar 2011 15:08:03 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20101003 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, alexdeucher@gmail.com,
        xorg-driver-ati@lists.x.org
Subject: Radeon jittery post 2.6.35
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.252.238.16
X-Scan-Result: No virus found in message 1Pylxq-0001U3-B6.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1Pylxq-0001U3-B6 fa876c37addc56c1f65bdd9b955365bd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi,

I've found what I guess is a radeon (or drm/kms) regression post 2.6.35.
I've got my TV conneced to my RS690G over HDMI, and the display has
always been jittery after POST and at the GRUB screen. Pre-KMS, the X
server (or driver got it sorted), and when KMS started, the display
stabilized right after the kernel driver was initiated. However, post
2.6.35, I see the jitter is back.

I've spent the last month trying to bisect it, but pretty much failed.
It appears that versions closer to 2.6.38-rcX are more prone to display
jitter, while 2.6.36 or so can have many successful runs. It also
appears to be related to device power-on order, or so I've come to
believe; A stable display can turn jittery, just by power cycling the TV.

I've uploaded a video of a 38-rc8 boot:
http://www.easy-share.com/1914220540/2.6.38-rc8_bad_x.mp4

You'll see jitter at the POST screen and GRUB. When KMS kicks in it
stabilizes, and when Freevo starts X, it's back to jitter.

The jitter is always of the same kind. It looks like an old tv set which
loses sync. The contents on the display is, for a split second, placed
at the wrong part of the screen (vertically and to some extent
horizontally), and every 5-15 seconds or so, there is a big reset when
the TV tries to restart things (I guess). At the resets, thee is a loud
'ping' in the nearby stereo too...

During the bisect  (and a t 38-rc8) I've seen this both at the console
(post KMS) and in X, so I'm not sure where the error is. I hope some of
you can get a better idea of where to hunt for the bug by looking at the
video.

-Anders

Here's dmesg and X.org log:


[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.38-rc8 (root@tv) (gcc version 4.4.4
(Gentoo 4.4.4-r2 p1.3, pie-0.4.5) ) #522 SMP PREEMPT Tue Mar 8 20:50:13
CET 2011
[    0.000000] Command line: root=/dev/sda3 hpet=disable
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000077ee0000 (usable)
[    0.000000]  BIOS-e820: 0000000077ee0000 - 0000000077ee3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000077ee3000 - 0000000077ef0000 (ACPI data)
[    0.000000]  BIOS-e820: 0000000077ef0000 - 0000000077f00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: System manufacturer System Product Name/M2A-VM HDMI,
BIOS ASUS M2A-VM HDMI ACPI BIOS Revision 2201 10/22/2008
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000
(usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000
(usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x77ee0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FFC0000000 write-back
[    0.000000]   1 base 0040000000 mask FFE0000000 write-back
[    0.000000]   2 base 0060000000 mask FFF0000000 write-back
[    0.000000]   3 base 0070000000 mask FFF8000000 write-back
[    0.000000]   4 base 0077F00000 mask FFFFF00000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new
0x7010600070106
[    0.000000] found SMP MP-table at [ffff8800000f6560] f6560
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-0000000077ee0000
[    0.000000]  0000000000 - 0077e00000 page 2M
[    0.000000]  0077e00000 - 0077ee0000 page 4k
[    0.000000] kernel direct mapping tables up to 77ee0000 @
1fffc000-20000000
[    0.000000] ACPI: RSDP 00000000000f8210 00024 (v02 ATI   )
[    0.000000] ACPI: XSDT 0000000077ee3100 00044 (v01 ATI    ASUSACPI
42302E31 AWRD 00000000)
[    0.000000] ACPI: FACP 0000000077ee8500 000F4 (v03 ATI    ASUSACPI
42302E31 AWRD 00000000)
[    0.000000] ACPI: DSDT 0000000077ee3280 05210 (v01 ATI    ASUSACPI
00001000 MSFT 03000000)
[    0.000000] ACPI: FACS 0000000077ee0000 00040
[    0.000000] ACPI: SSDT 0000000077ee8740 002CC (v01 PTLTD  POWERNOW
00000001  LTP 00000001)
[    0.000000] ACPI: MCFG 0000000077ee8b00 0003C (v01 ATI    ASUSACPI
42302E31 AWRD 00000000)
[    0.000000] ACPI: APIC 0000000077ee8640 00084 (v01 ATI    ASUSACPI
42302E31 AWRD 00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD ->
[ffff880075800000-ffff8800773fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x00077ee0
[    0.000000] On node 0 totalpages: 491119
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3921 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6661 pages used for memmap
[    0.000000]   DMA32 zone: 480475 pages, LIFO batch:31
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 -
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 -
00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 -
0000000000100000
[    0.000000] Allocating PCI resources starting at 77f00000 (gap:
77f00000:68100000)
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4
nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff880077c00000 s73088
r8192 d21120 u524288
[    0.000000] pcpu-alloc: s73088 r8192 d21120 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. 
Total pages: 484396
[    0.000000] Kernel command line: root=/dev/sda3 hpet=disable
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 262144 (order: 9,
2097152 bytes)
[    0.000000] Inode-cache hash table entries: 131072 (order: 8, 1048576
bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 1066000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Memory: 1924088k/1964928k available (4895k kernel code,
452k absent, 40388k reserved, 2084k data, 436k init)
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000]  CONFIG_RCU_FANOUT set to non-default value of 32
[    0.000000]  RCU-based detection of stalled CPUs is disabled.
[    0.000000]  Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:384
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 19660800 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't
want memory cgroups
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2799.707 MHz processor.
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[    0.002038] Calibrating delay loop (skipped), value calculated using
timer frequency.. 5599.41 BogoMIPS (lpj=2799707)
[    0.002110] pid_max: default: 32768 minimum: 301
[    0.002218] Mount-cache hash table entries: 256
[    0.002405] Initializing cgroup subsys ns
[    0.002441] ns_cgroup deprecated: consider using the 'clone_children'
flag without the ns_cgroup.
[    0.002480] Initializing cgroup subsys cpuacct
[    0.002523] Initializing cgroup subsys memory
[    0.002568] Initializing cgroup subsys devices
[    0.003002] Initializing cgroup subsys freezer
[    0.003037] Initializing cgroup subsys blkio
[    0.003093] tseg: 0077f00000
[    0.003095] CPU: Physical Processor ID: 0
[    0.003129] CPU: Processor Core ID: 0
[    0.003163] mce: CPU supports 5 MCE banks
[    0.003206] using C1E aware idle routine
[    0.003271] ACPI: Core revision 20110112
[    0.005069] Setting APIC routing to flat
[    0.005608] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.015691] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 5600+
stepping 03
[    0.015998] Performance Events: AMD PMU driver.
[    0.015998] ... version:                0
[    0.015998] ... bit width:              48
[    0.015998] ... generic registers:      4
[    0.015998] ... value mask:             0000ffffffffffff
[    0.015998] ... max period:             00007fffffffffff
[    0.015998] ... fixed-purpose events:   0
[    0.015998] ... event mask:             000000000000000f
[    0.021016] Booting Node   0, Processors  #1
[    0.092068] Brought up 2 CPUs
[    0.092133] Total of 2 processors activated (11198.16 BogoMIPS).
[    0.092366] NET: Registered protocol family 16
[    0.093028] node 0 link 0: io port [c000, ffff]
[    0.093028] TOM: 0000000080000000 aka 2048M
[    0.093045] node 0 link 0: mmio [a0000, bffff]
[    0.093047] node 0 link 0: mmio [f0000000, f7ffffff]
[    0.093050] node 0 link 0: mmio [80000000, dfffffff]
[    0.093052] node 0 link 0: mmio [f0000000, fe02ffff]
[    0.093054] node 0 link 0: mmio [e0000000, e03fffff]
[    0.093057] bus: [00, 03] on node 0 link 0
[    0.093059] bus: 00 index 0 [io  0x0000-0xffff]
[    0.093062] bus: 00 index 1 [mem 0x000a0000-0x000bffff]
[    0.093064] bus: 00 index 2 [mem 0xe0400000-0xfcffffffff]
[    0.093066] bus: 00 index 3 [mem 0x80000000-0xe03fffff]
[    0.093076] ACPI: bus type pci registered
[    0.093121] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.093121] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.113012] PCI: Using configuration type 1 for base access
[    0.119044] bio: create slab <bio-0> at 0
[    0.120623] ACPI: EC: Look up EC in DSDT
[    0.124474] ACPI: Interpreter enabled
[    0.124510] ACPI: (supports S0 S1 S3 S4 S5)
[    0.124705] ACPI: Using IOAPIC for interrupt routing
[    0.130092] ACPI: No dock devices found.
[    0.130130] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    0.130225] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.130299] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.130299] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.130299] pci_root PNP0A03:00: host bridge window [mem
0x000a0000-0x000bffff]
[    0.130299] pci_root PNP0A03:00: host bridge window [mem
0x000c0000-0x000dffff]
[    0.130299] pci_root PNP0A03:00: host bridge window [mem
0x80000000-0xfebfffff]
[    0.130299] pci 0000:00:00.0: [1002:7910] type 0 class 0x000600
[    0.130302] pci 0000:00:01.0: [1002:7912] type 1 class 0x000604
[    0.130335] pci 0000:00:07.0: [1002:7917] type 1 class 0x000604
[    0.130356] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.130359] pci 0000:00:07.0: PME# disabled
[    0.130388] pci 0000:00:12.0: [1002:4380] type 0 class 0x000101
[    0.130405] pci 0000:00:12.0: reg 10: [io  0xff00-0xff07]
[    0.130416] pci 0000:00:12.0: reg 14: [io  0xfe00-0xfe03]
[    0.130426] pci 0000:00:12.0: reg 18: [io  0xfd00-0xfd07]
[    0.130436] pci 0000:00:12.0: reg 1c: [io  0xfc00-0xfc03]
[    0.130446] pci 0000:00:12.0: reg 20: [io  0xfb00-0xfb0f]
[    0.130456] pci 0000:00:12.0: reg 24: [mem 0xfe02f000-0xfe02f3ff]
[    0.130477] pci 0000:00:12.0: set SATA to AHCI mode
[    0.130540] pci 0000:00:13.0: [1002:4387] type 0 class 0x000c03
[    0.130554] pci 0000:00:13.0: reg 10: [mem 0xfe02e000-0xfe02efff]
[    0.131053] pci 0000:00:13.1: [1002:4388] type 0 class 0x000c03
[    0.131067] pci 0000:00:13.1: reg 10: [mem 0xfe02d000-0xfe02dfff]
[    0.131134] pci 0000:00:13.2: [1002:4389] type 0 class 0x000c03
[    0.131148] pci 0000:00:13.2: reg 10: [mem 0xfe02c000-0xfe02cfff]
[    0.131214] pci 0000:00:13.3: [1002:438a] type 0 class 0x000c03
[    0.131228] pci 0000:00:13.3: reg 10: [mem 0xfe02b000-0xfe02bfff]
[    0.131294] pci 0000:00:13.4: [1002:438b] type 0 class 0x000c03
[    0.131308] pci 0000:00:13.4: reg 10: [mem 0xfe02a000-0xfe02afff]
[    0.131380] pci 0000:00:13.5: [1002:4386] type 0 class 0x000c03
[    0.131400] pci 0000:00:13.5: reg 10: [mem 0xfe029000-0xfe0290ff]
[    0.131472] pci 0000:00:13.5: supports D1 D2
[    0.131474] pci 0000:00:13.5: PME# supported from D0 D1 D2 D3hot
[    0.131478] pci 0000:00:13.5: PME# disabled
[    0.131501] pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
[    0.131524] pci 0000:00:14.0: reg 10: [io  0x0b00-0x0b0f]
[    0.131602] pci 0000:00:14.1: [1002:438c] type 0 class 0x000101
[    0.131617] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
[    0.131627] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
[    0.131637] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
[    0.131647] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
[    0.131657] pci 0000:00:14.1: reg 20: [io  0xf900-0xf90f]
[    0.131696] pci 0000:00:14.2: [1002:4383] type 0 class 0x000403
[    0.131718] pci 0000:00:14.2: reg 10: [mem 0xfe020000-0xfe023fff 64bit]
[    0.131778] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.131782] pci 0000:00:14.2: PME# disabled
[    0.131797] pci 0000:00:14.3: [1002:438d] type 0 class 0x000601
[    0.131873] pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
[    0.131920] pci 0000:00:18.0: [1022:1100] type 0 class 0x000600
[    0.131938] pci 0000:00:18.1: [1022:1101] type 0 class 0x000600
[    0.131952] pci 0000:00:18.2: [1022:1102] type 0 class 0x000600
[    0.131968] pci 0000:00:18.3: [1022:1103] type 0 class 0x000600
[    0.132015] pci 0000:01:05.0: [1002:791e] type 0 class 0x000300
[    0.132024] pci 0000:01:05.0: reg 10: [mem 0xf0000000-0xf7ffffff
64bit pref]
[    0.132030] pci 0000:01:05.0: reg 18: [mem 0xfdbe0000-0xfdbeffff 64bit]
[    0.132035] pci 0000:01:05.0: reg 20: [io  0xde00-0xdeff]
[    0.132039] pci 0000:01:05.0: reg 24: [mem 0xfda00000-0xfdafffff]
[    0.132050] pci 0000:01:05.0: supports D1 D2
[    0.132061] pci 0000:01:05.2: [1002:7919] type 0 class 0x000403
[    0.132069] pci 0000:01:05.2: reg 10: [mem 0xfdbfc000-0xfdbfffff 64bit]
[    0.132102] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.132139] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.132143] pci 0000:00:01.0:   bridge window [mem 0xfda00000-0xfdbfffff]
[    0.132146] pci 0000:00:01.0:   bridge window [mem
0xf0000000-0xf7ffffff 64bit pref]
[    0.132185] pci 0000:02:00.0: [10ec:8168] type 0 class 0x000200
[    0.132200] pci 0000:02:00.0: reg 10: [io  0xee00-0xeeff]
[    0.132224] pci 0000:02:00.0: reg 18: [mem 0xfdfff000-0xfdffffff 64bit]
[    0.132252] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.132287] pci 0000:02:00.0: supports D1 D2
[    0.132289] pci 0000:02:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.132294] pci 0000:02:00.0: PME# disabled
[    0.132308] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device. 
You can enable it with 'pcie_aspm=force'
[    0.132355] pci 0000:00:07.0: PCI bridge to [bus 02-02]
[    0.132392] pci 0000:00:07.0:   bridge window [io  0xe000-0xefff]
[    0.132395] pci 0000:00:07.0:   bridge window [mem 0xfdf00000-0xfdffffff]
[    0.132398] pci 0000:00:07.0:   bridge window [mem
0xfdc00000-0xfdcfffff 64bit pref]
[    0.132437] pci 0000:03:06.0: [1131:7133] type 0 class 0x000480
[    0.132460] pci 0000:03:06.0: reg 10: [mem 0xfdeff000-0xfdeff7ff]
[    0.132549] pci 0000:03:06.0: supports D1 D2
[    0.132572] pci 0000:03:07.0: [1106:3044] type 0 class 0x000c00
[    0.132596] pci 0000:03:07.0: reg 10: [mem 0xfdefe000-0xfdefe7ff]
[    0.132609] pci 0000:03:07.0: reg 14: [io  0xcf00-0xcf7f]
[    0.132692] pci 0000:03:07.0: supports D2
[    0.132694] pci 0000:03:07.0: PME# supported from D2 D3hot D3cold
[    0.132699] pci 0000:03:07.0: PME# disabled
[    0.132745] pci 0000:00:14.4: PCI bridge to [bus 03-03] (subtractive
decode)
[    0.132784] pci 0000:00:14.4:   bridge window [io  0xc000-0xcfff]
[    0.132789] pci 0000:00:14.4:   bridge window [mem 0xfde00000-0xfdefffff]
[    0.132793] pci 0000:00:14.4:   bridge window [mem
0xfdd00000-0xfddfffff pref]
[    0.132796] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7]
(subtractive decode)
[    0.132798] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff]
(subtractive decode)
[    0.132801] pci 0000:00:14.4:   bridge window [mem
0x000a0000-0x000bffff] (subtractive decode)
[    0.132803] pci 0000:00:14.4:   bridge window [mem
0x000c0000-0x000dffff] (subtractive decode)
[    0.132806] pci 0000:00:14.4:   bridge window [mem
0x80000000-0xfebfffff] (subtractive decode)
[    0.132817] pci_bus 0000:00: on NUMA node 0
[    0.132820] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.132972] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.133082] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
[    0.133109] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    0.133138]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.147285] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
[    0.148144] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
[    0.148540] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
[    0.148935] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
[    0.149325] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
[    0.149718] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
[    0.150114] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 *11)
[    0.150442] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
[    0.150823] vgaarb: device added:
PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    0.151002] vgaarb: loaded
[    0.151133] SCSI subsystem initialized
[    0.151133] libata version 3.00 loaded.
[    0.151133] usbcore: registered new interface driver usbfs
[    0.151133] usbcore: registered new interface driver hub
[    0.151133] usbcore: registered new device driver usb
[    0.151133] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    0.151133] PCI: Using ACPI for IRQ routing
[    0.151988] PCI: pci_cache_line_size set to 64 bytes
[    0.152067] reserve RAM buffer: 000000000009f000 - 000000000009ffff
[    0.152069] reserve RAM buffer: 0000000077ee0000 - 0000000077ffffff
[    0.152089] Bluetooth: Core ver 2.15
[    0.152089] NET: Registered protocol family 31
[    0.152089] Bluetooth: HCI device and connection manager initialized
[    0.152089] Bluetooth: HCI socket layer initialized
[    0.152114] pnp: PnP ACPI init
[    0.152114] ACPI: bus type pnp registered
[    0.152158] pnp 00:00: [bus 00-ff]
[    0.152160] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.152163] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.152165] pnp 00:00: [io  0x0d00-0xffff window]
[    0.152167] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.152169] pnp 00:00: [mem 0x000c0000-0x000dffff window]
[    0.152172] pnp 00:00: [mem 0x80000000-0xfebfffff window]
[    0.152224] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.152224] pnp 00:01: [io  0x4100-0x411f]
[    0.152224] pnp 00:01: [io  0x0228-0x022f]
[    0.152224] pnp 00:01: [io  0x040b]
[    0.152224] pnp 00:01: [io  0x04d6]
[    0.152224] pnp 00:01: [io  0x0c00-0x0c01]
[    0.152224] pnp 00:01: [io  0x0c14]
[    0.152224] pnp 00:01: [io  0x0c50-0x0c52]
[    0.152224] pnp 00:01: [io  0x0c6c-0x0c6d]
[    0.152224] pnp 00:01: [io  0x0c6f]
[    0.152224] pnp 00:01: [io  0x0cd0-0x0cd1]
[    0.152987] pnp 00:01: [io  0x0cd2-0x0cd3]
[    0.152990] pnp 00:01: [io  0x0cd4-0x0cdf]
[    0.152992] pnp 00:01: [io  0x4000-0x40fe]
[    0.152994] pnp 00:01: [io  0x4210-0x4217]
[    0.152997] pnp 00:01: [io  0x0b10-0x0b1f]
[    0.152999] pnp 00:01: [mem 0x00000000-0x00000fff window]
[    0.153002] pnp 00:01: [mem 0xfee00400-0xfee00fff window]
[    0.153031] pnp 00:01: disabling [mem 0x00000000-0x00000fff window]
because it overlaps 0000:02:00.0 BAR 6 [mem 0x00000000-0x0001ffff pref]
[    0.153103] system 00:01: [io  0x4100-0x411f] has been reserved
[    0.153103] system 00:01: [io  0x0228-0x022f] has been reserved
[    0.153103] system 00:01: [io  0x040b] has been reserved
[    0.153111] system 00:01: [io  0x04d6] has been reserved
[    0.153147] system 00:01: [io  0x0c00-0x0c01] has been reserved
[    0.153183] system 00:01: [io  0x0c14] has been reserved
[    0.153219] system 00:01: [io  0x0c50-0x0c52] has been reserved
[    0.153255] system 00:01: [io  0x0c6c-0x0c6d] has been reserved
[    0.153292] system 00:01: [io  0x0c6f] has been reserved
[    0.153327] system 00:01: [io  0x0cd0-0x0cd1] has been reserved
[    0.153994] system 00:01: [io  0x0cd2-0x0cd3] has been reserved
[    0.154030] system 00:01: [io  0x0cd4-0x0cdf] has been reserved
[    0.154065] system 00:01: [io  0x4000-0x40fe] has been reserved
[    0.154102] system 00:01: [io  0x4210-0x4217] has been reserved
[    0.154137] system 00:01: [io  0x0b10-0x0b1f] has been reserved
[    0.154174] system 00:01: [mem 0xfee00400-0xfee00fff window] has been
reserved
[    0.154214] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.154307] pnp 00:02: [dma 4]
[    0.154309] pnp 00:02: [io  0x0000-0x000f]
[    0.154311] pnp 00:02: [io  0x0080-0x0090]
[    0.154313] pnp 00:02: [io  0x0094-0x009f]
[    0.154315] pnp 00:02: [io  0x00c0-0x00df]
[    0.154348] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.154348] pnp 00:03: [io  0x0070-0x0073]
[    0.154348] pnp 00:03: [irq 8]
[    0.154348] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.154348] pnp 00:04: [io  0x0061]
[    0.154348] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.154348] pnp 00:05: [io  0x00f0-0x00ff]
[    0.154348] pnp 00:05: [irq 13]
[    0.154348] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.154348] pnp 00:06: [io  0x0010-0x001f]
[    0.154348] pnp 00:06: [io  0x0022-0x003f]
[    0.154348] pnp 00:06: [io  0x0044-0x005f]
[    0.154348] pnp 00:06: [io  0x0062-0x0063]
[    0.154348] pnp 00:06: [io  0x0065-0x006f]
[    0.154348] pnp 00:06: [io  0x0074-0x007f]
[    0.154348] pnp 00:06: [io  0x0091-0x0093]
[    0.154348] pnp 00:06: [io  0x00a2-0x00bf]
[    0.155004] pnp 00:06: [io  0x00e0-0x00ef]
[    0.155007] pnp 00:06: [io  0x04d0-0x04d1]
[    0.155010] pnp 00:06: [io  0x0220-0x0225]
[    0.155067] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    0.155067] system 00:06: [io  0x0220-0x0225] has been reserved
[    0.155076] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.155202] pnp 00:07: [io  0x03f0-0x03f5]
[    0.155205] pnp 00:07: [io  0x03f7]
[    0.155214] pnp 00:07: [irq 6]
[    0.155216] pnp 00:07: [dma 2]
[    0.155263] pnp 00:07: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.155263] pnp 00:08: [io  0x03f8-0x03ff]
[    0.155263] pnp 00:08: [irq 4]
[    0.155263] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.155263] pnp 00:09: [io  0x0378-0x037f]
[    0.155263] pnp 00:09: [irq 7]
[    0.155318] pnp 00:09: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.156090] pnp 00:0a: [mem 0xe0000000-0xefffffff]
[    0.156142] system 00:0a: [mem 0xe0000000-0xefffffff] has been reserved
[    0.156142] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.156167] pnp 00:0b: [mem 0x000cd600-0x000cffff]
[    0.156169] pnp 00:0b: [mem 0x000f0000-0x000f7fff]
[    0.156172] pnp 00:0b: [mem 0x000f8000-0x000fbfff]
[    0.156174] pnp 00:0b: [mem 0x000fc000-0x000fffff]
[    0.156176] pnp 00:0b: [mem 0x77ef0000-0x77feffff]
[    0.156178] pnp 00:0b: [mem 0xfed00000-0xfed000ff]
[    0.156180] pnp 00:0b: [mem 0x77ee0000-0x77efffff]
[    0.156182] pnp 00:0b: [mem 0xffff0000-0xffffffff]
[    0.156184] pnp 00:0b: [mem 0x00000000-0x0009ffff]
[    0.156187] pnp 00:0b: [mem 0x00100000-0x77edffff]
[    0.156189] pnp 00:0b: [mem 0x77ff0000-0x7ffeffff]
[    0.156191] pnp 00:0b: [mem 0xfec00000-0xfec00fff]
[    0.156193] pnp 00:0b: [mem 0xfee00000-0xfee00fff]
[    0.156195] pnp 00:0b: [mem 0xfff80000-0xfffeffff]
[    0.156256] system 00:0b: [mem 0x000cd600-0x000cffff] has been reserved
[    0.156256] system 00:0b: [mem 0x000f0000-0x000f7fff] could not be
reserved
[    0.156256] system 00:0b: [mem 0x000f8000-0x000fbfff] could not be
reserved
[    0.156256] system 00:0b: [mem 0x000fc000-0x000fffff] could not be
reserved
[    0.156256] system 00:0b: [mem 0x77ef0000-0x77feffff] could not be
reserved
[    0.156256] system 00:0b: [mem 0xfed00000-0xfed000ff] has been reserved
[    0.156256] system 00:0b: [mem 0x77ee0000-0x77efffff] could not be
reserved
[    0.156260] system 00:0b: [mem 0xffff0000-0xffffffff] has been reserved
[    0.156297] system 00:0b: [mem 0x00000000-0x0009ffff] could not be
reserved
[    0.156334] system 00:0b: [mem 0x00100000-0x77edffff] could not be
reserved
[    0.156370] system 00:0b: [mem 0x77ff0000-0x7ffeffff] could not be
reserved
[    0.156407] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be
reserved
[    0.156444] system 00:0b: [mem 0xfee00000-0xfee00fff] could not be
reserved
[    0.156480] system 00:0b: [mem 0xfff80000-0xfffeffff] has been reserved
[    0.156517] system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.156524] pnp: PnP ACPI: found 12 devices
[    0.157006] ACPI: ACPI bus type pnp unregistered
[    0.165222] Switching to clocksource acpi_pm
[    0.165299] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.165335] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.165372] pci 0000:00:01.0:   bridge window [mem 0xfda00000-0xfdbfffff]
[    0.165409] pci 0000:00:01.0:   bridge window [mem
0xf0000000-0xf7ffffff 64bit pref]
[    0.165452] pci 0000:02:00.0: BAR 6: assigned [mem
0xfdc00000-0xfdc1ffff pref]
[    0.165492] pci 0000:00:07.0: PCI bridge to [bus 02-02]
[    0.165528] pci 0000:00:07.0:   bridge window [io  0xe000-0xefff]
[    0.165565] pci 0000:00:07.0:   bridge window [mem 0xfdf00000-0xfdffffff]
[    0.165602] pci 0000:00:07.0:   bridge window [mem
0xfdc00000-0xfdcfffff 64bit pref]
[    0.165644] pci 0000:00:14.4: PCI bridge to [bus 03-03]
[    0.165680] pci 0000:00:14.4:   bridge window [io  0xc000-0xcfff]
[    0.165719] pci 0000:00:14.4:   bridge window [mem 0xfde00000-0xfdefffff]
[    0.165758] pci 0000:00:14.4:   bridge window [mem
0xfdd00000-0xfddfffff pref]
[    0.165810] pci 0000:00:07.0: setting latency timer to 64
[    0.165817] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.165819] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.165822] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.165824] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
[    0.165826] pci_bus 0000:00: resource 8 [mem 0x80000000-0xfebfffff]
[    0.165829] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.165831] pci_bus 0000:01: resource 1 [mem 0xfda00000-0xfdbfffff]
[    0.165833] pci_bus 0000:01: resource 2 [mem 0xf0000000-0xf7ffffff
64bit pref]
[    0.165835] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.165838] pci_bus 0000:02: resource 1 [mem 0xfdf00000-0xfdffffff]
[    0.165840] pci_bus 0000:02: resource 2 [mem 0xfdc00000-0xfdcfffff
64bit pref]
[    0.165843] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
[    0.165845] pci_bus 0000:03: resource 1 [mem 0xfde00000-0xfdefffff]
[    0.165847] pci_bus 0000:03: resource 2 [mem 0xfdd00000-0xfddfffff pref]
[    0.165849] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    0.165852] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    0.165855] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    0.165857] pci_bus 0000:03: resource 7 [mem 0x000c0000-0x000dffff]
[    0.165859] pci_bus 0000:03: resource 8 [mem 0x80000000-0xfebfffff]
[    0.165924] NET: Registered protocol family 2
[    0.165698] Switched to NOHz mode on CPU #0
[    0.165924] Switched to NOHz mode on CPU #1
[    0.165924] IP route cache hash table entries: 65536 (order: 7,
524288 bytes)
[    0.166272] TCP established hash table entries: 262144 (order: 10,
4194304 bytes)
[    0.168113] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.168651] TCP: Hash tables configured (established 262144 bind 65536)
[    0.168687] TCP reno registered
[    0.168723] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.168778] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.168960] NET: Registered protocol family 1
[    0.169156] RPC: Registered udp transport module.
[    0.169193] RPC: Registered tcp transport module.
[    0.169228] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.405052] pci 0000:01:05.0: Boot video device
[    0.405064] PCI: CLS 32 bytes, default 64
[    0.406442] audit: initializing netlink socket (disabled)
[    0.406487] type=2000 audit(1300024059.405:1): initialized
[    0.407653] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.407998] msgmni has been set to 3757
[    0.408432] Block layer SCSI generic (bsg) driver version 0.4 loaded
(major 254)
[    0.408473] io scheduler noop registered
[    0.408532] io scheduler cfq registered (default)
[    0.408693] pcieport 0000:00:07.0: setting latency timer to 64
[    0.408716] pcieport 0000:00:07.0: irq 40 for MSI/MSI-X
[    0.409544] input: Power Button as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.409588] ACPI: Power Button [PWRB]
[    0.409733] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.409774] ACPI: Power Button [PWRF]
[    0.409944] ACPI: Fan [FAN] (on)
[    0.410050] ACPI: acpi_idle registered with cpuidle
[    0.411586] ACPI Warning: For \_TZ_.THRM._PSL: Return Package type
mismatch at index 0 - found [NULL Object Descriptor], expected Reference
(20110112/nspredef-1059)
[    0.411694] ACPI: Expecting a [Reference] package element, found type 0
[    0.411729] ACPI: Invalid passive threshold
[    0.411938] thermal LNXTHERM:00: registered as thermal_zone0
[    0.411974] ACPI: Thermal Zone [THRM] (40 C)
[    0.412204] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.432915] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.517785] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.533330] [drm] Initialized drm 1.1.0 20060810
[    0.533425] [drm] radeon defaulting to kernel modesetting.
[    0.533460] [drm] radeon kernel modesetting enabled.
[    0.533560] radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low) ->
IRQ 18
[    0.535805] [drm] initializing kernel modesetting (RS690 0x1002:0x791E).
[    0.535864] [drm] register mmio base: 0xFDBE0000
[    0.535899] [drm] register mmio size: 65536
[    0.537505] ATOM BIOS: ATI
[    0.537559] radeon 0000:01:05.0: VRAM: 128M 0x0000000078000000 -
0x000000007FFFFFFF (128M used)
[    0.537599] radeon 0000:01:05.0: GTT: 512M 0x0000000080000000 -
0x000000009FFFFFFF
[    0.537640] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.537676] [drm] Driver supports precise vblank timestamp query.
[    0.537738] [drm] radeon: irq initialized.
[    0.538370] [drm] Detected VRAM RAM=128M, BAR=128M
[    0.538410] [drm] RAM width 128bits DDR
[    0.538523] [TTM] Zone  kernel: Available graphics memory: 962044 kiB.
[    0.538563] [TTM] Initializing pool allocator.
[    0.538615] [drm] radeon: 128M of VRAM memory ready
[    0.538650] [drm] radeon: 512M of GTT memory ready.
[    0.538688] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    0.542187] [drm] radeon: 1 quad pipes, 1 z pipes initialized.
[    0.548389] radeon 0000:01:05.0: WB enabled
[    0.548534] [drm] Loading RS690/RS740 Microcode
[    0.548748] [drm] radeon: ring at 0x0000000080001000
[    0.548799] [drm] ring test succeeded in 1 usecs
[    0.548948] [drm] radeon: ib pool ready.
[    0.548989] [drm] ib test succeeded in 0 usecs
[    0.549043] [drm] Enabling audio support
[    0.549082] failed to evaluate ATIF got AE_BAD_PARAMETER
[    0.549816] [drm] Radeon Display Connectors
[    0.549851] [drm] Connector 0:
[    0.549885] [drm]   VGA
[    0.549919] [drm]   DDC: 0x7e50 0x7e40 0x7e54 0x7e44 0x7e58 0x7e48
0x7e5c 0x7e4c
[    0.549957] [drm]   Encoders:
[    0.549991] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    0.550041] [drm] Connector 1:
[    0.550075] [drm]   S-video
[    0.550108] [drm]   Encoders:
[    0.550141] [drm]     TV1: INTERNAL_KLDSCP_DAC1
[    0.550176] [drm] Connector 2:
[    0.550209] [drm]   HDMI-A
[    0.550242] [drm]   HPD2
[    0.550276] [drm]   DDC: 0x7e40 0x7e60 0x7e44 0x7e64 0x7e48 0x7e68
0x7e4c 0x7e6c
[    0.550315] [drm]   Encoders:
[    0.550348] [drm]     DFP2: INTERNAL_DDI
[    0.550382] [drm] Connector 3:
[    0.550416] [drm]   DVI-D
[    0.550450] [drm]   DDC: 0x7e40 0x7e50 0x7e44 0x7e54 0x7e48 0x7e58
0x7e4c 0x7e5c
[    0.550488] [drm]   Encoders:
[    0.550522] [drm]     DFP3: INTERNAL_LVTM1
[    0.947828] [drm] fb mappable at 0xF0040000
[    0.947863] [drm] vram apper at 0xF0000000
[    0.947897] [drm] size 8294400
[    0.947930] [drm] fb depth is 24
[    0.947964] [drm]    pitch is 7680
[    0.953105] radeon 0000:01:05.0: Unsupported encoder type 0x19
[    0.992074] Console: switching to colour frame buffer device 240x67
[    1.010409] fb0: radeondrmfb frame buffer device
[    1.010478] drm: registered panic notifier
[    1.010542] [drm] Initialized radeon 2.8.0 20080528 for 0000:01:05.0
on minor 0
[    1.013277] brd: module loaded
[    1.014613] loop: module loaded
[    1.014659] Uniform Multi-Platform E-IDE driver
[    1.014871] ide-gd driver 1.18
[    1.015195] ahci 0000:00:12.0: version 3.0
[    1.015221] ahci 0000:00:12.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    1.015342] ahci 0000:00:12.0: ASUS M2A-VM: enabling 64bit DMA
[    1.015546] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps
0xf impl SATA mode
[    1.015671] ahci 0000:00:12.0: flags: 64bit ncq sntf ilck pm led clo
pmp pio slum part ccc
[    1.017285] scsi0 : ahci
[    1.017607] scsi1 : ahci
[    1.017835] scsi2 : ahci
[    1.018058] scsi3 : ahci
[    1.018304] ata1: SATA max UDMA/133 abar m1024@0xfe02f000 port
0xfe02f100 irq 22
[    1.018417] ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port
0xfe02f180 irq 22
[    1.018530] ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port
0xfe02f200 irq 22
[    1.018641] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port
0xfe02f280 irq 22
[    1.019170] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.019274] r8169 0000:02:00.0: PCI INT A -> GSI 19 (level, low) ->
IRQ 19
[    1.019393] r8169 0000:02:00.0: setting latency timer to 64
[    1.019444] r8169 0000:02:00.0: irq 41 for MSI/MSI-X
[    1.019679] r8169 0000:02:00.0: eth0: RTL8168b/8111b at
0xffffc90000010000, 00:1b:fc:89:fa:a2, XID 18000000 IRQ 41
[    1.022073] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.022189] ehci_hcd 0000:00:13.5: PCI INT D -> GSI 19 (level, low)
-> IRQ 19
[    1.022301] ehci_hcd 0000:00:13.5: EHCI Host Controller
[    1.022387] ehci_hcd 0000:00:13.5: new USB bus registered, assigned
bus number 1
[    1.024044] ehci_hcd 0000:00:13.5: applying AMD SB600/SB700 USB
freeze workaround
[    1.024167] ehci_hcd 0000:00:13.5: debug port 1
[    1.024267] ehci_hcd 0000:00:13.5: irq 19, io mem 0xfe029000
[    1.030026] ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00
[    1.030337] hub 1-0:1.0: USB hub found
[    1.030398] hub 1-0:1.0: 10 ports detected
[    1.030590] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.030702] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 16 (level, low)
-> IRQ 16
[    1.030815] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    1.030892] ohci_hcd 0000:00:13.0: new USB bus registered, assigned
bus number 2
[    1.037038] ohci_hcd 0000:00:13.0: irq 16, io mem 0xfe02e000
[    1.092210] hub 2-0:1.0: USB hub found
[    1.092275] hub 2-0:1.0: 2 ports detected
[    1.092404] ohci_hcd 0000:00:13.1: PCI INT B -> GSI 17 (level, low)
-> IRQ 17
[    1.092515] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    1.096274] ohci_hcd 0000:00:13.1: new USB bus registered, assigned
bus number 3
[    1.108038] ohci_hcd 0000:00:13.1: irq 17, io mem 0xfe02d000
[    1.166211] hub 3-0:1.0: USB hub found
[    1.169832] hub 3-0:1.0: 2 ports detected
[    1.173446] ohci_hcd 0000:00:13.2: PCI INT C -> GSI 18 (level, low)
-> IRQ 18
[    1.177270] ohci_hcd 0000:00:13.2: OHCI Host Controller
[    1.181085] ohci_hcd 0000:00:13.2: new USB bus registered, assigned
bus number 4
[    1.189024] ohci_hcd 0000:00:13.2: irq 18, io mem 0xfe02c000
[    1.247210] hub 4-0:1.0: USB hub found
[    1.251139] hub 4-0:1.0: 2 ports detected
[    1.254621] ohci_hcd 0000:00:13.3: PCI INT B -> GSI 17 (level, low)
-> IRQ 17
[    1.258549] ohci_hcd 0000:00:13.3: OHCI Host Controller
[    1.262432] ohci_hcd 0000:00:13.3: new USB bus registered, assigned
bus number 5
[    1.274023] ohci_hcd 0000:00:13.3: irq 17, io mem 0xfe02b000
[    1.332262] hub 5-0:1.0: USB hub found
[    1.336022] hub 5-0:1.0: 2 ports detected
[    1.339666] ohci_hcd 0000:00:13.4: PCI INT C -> GSI 18 (level, low)
-> IRQ 18
[    1.343623] ohci_hcd 0000:00:13.4: OHCI Host Controller
[    1.347578] ohci_hcd 0000:00:13.4: new USB bus registered, assigned
bus number 6
[    1.359022] ohci_hcd 0000:00:13.4: irq 18, io mem 0xfe02a000
[    1.417219] hub 6-0:1.0: USB hub found
[    1.420713] hub 6-0:1.0: 2 ports detected
[    1.424816] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.429155] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.433058] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.436811] mousedev: PS/2 mouse device common for all mice
[    1.440675] evbug: Connected device: input0 (Power Button at
PNP0C0C/button/input0)
[    1.440678] evbug: Connected device: input1 (Power Button at
LNXPWRBN/button/input0)
[    1.440857] md: linear personality registered for level -1
[    1.444857] device-mapper: uevent: version 1.0.3
[    1.448832] device-mapper: ioctl: 4.19.1-ioctl (2011-01-07)
initialised: dm-devel@redhat.com
[    1.452635] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    1.456389] usbcore: registered new interface driver btusb
[    1.460357] cpuidle: using governor ladder
[    1.464250] cpuidle: using governor menu
[    1.468605] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low)
-> IRQ 16
[    1.478023] ata1: softreset failed (device not ready)
[    1.482052] ata1: applying SB600 PMP SRST workaround and retrying
[    1.485973] ata2: softreset failed (device not ready)
[    1.491350] ata2: applying SB600 PMP SRST workaround and retrying
[    1.495537] ata4: softreset failed (device not ready)
[    1.495980] HDA Intel 0000:01:05.2: PCI INT B -> GSI 19 (level, low)
-> IRQ 19
[    1.496040] HDA Intel 0000:01:05.2: irq 42 for MSI/MSI-X
[    1.503686] ata4: applying SB600 PMP SRST workaround and retrying
[    1.583023] ata3: softreset failed (device not ready)
[    1.586861] ata3: applying SB600 PMP SRST workaround and retrying
[    1.616023] usb 3-2: new full speed USB device using ohci_hcd and
address 2
[    1.663033] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.667160] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.670841] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.674923] ata4.00: ATAPI: TSSTcorp CDDVDW SH-S203P, SB00, max UDMA/100
[    1.679015] ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.683187] ata2.00: ATA-8: WDC WD15EADS-00P8B0, 01.00A01, max UDMA/133
[    1.686987] ata2.00: 2930277168 sectors, multi 1: LBA48 NCQ (depth
31/32), AA
[    1.691051] ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.695356] ata1.00: ATA-8: SAMSUNG HD501LJ, CR100-11, max UDMA7
[    1.699514] ata1.00: 976773168 sectors, multi 1: LBA48 NCQ (depth
31/32), AA
[    1.703412] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.707537] ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.711666] ata4.00: configured for UDMA/100
[    1.715836] ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.719732] ata2.00: configured for UDMA/133
[    1.730143] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.734295] ata1.00: configured for UDMA/133
[    1.738146] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ 
CR10 PQ: 0 ANSI: 5
[    1.742606] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500
GB/465 GiB)
[    1.742803] scsi 1:0:0:0: Direct-Access     ATA      WDC WD15EADS-00P
01.0 PQ: 0 ANSI: 5
[    1.743013] sd 1:0:0:0: [sdb] 2930277168 512-byte logical blocks:
(1.50 TB/1.36 TiB)
[    1.743055] sd 1:0:0:0: [sdb] Write Protect is off
[    1.743058] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.743075] sd 1:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.753355]  sdb: sdb1 sdb2 sdb3 sdb4
[    1.768045] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.772148] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.776553] sd 0:0:0:0: [sda] Write Protect is off
[    1.780893] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.780910] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.790309]  sda: sda1 sda2 sda3 sda4
[    1.795045] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.836774] ata3.00: ATA-8: WDC WD3200BEVT-00ZCT0, 11.01A11, max UDMA/133
[    1.841098] ata3.00: 625142448 sectors, multi 1: LBA48 NCQ (depth
31/32), AA
[    1.845571] ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.850995] ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.854972] ata3.00: configured for UDMA/133
[    1.859430] scsi 2:0:0:0: Direct-Access     ATA      WDC WD3200BEVT-0
11.0 PQ: 0 ANSI: 5
[    1.864089] sd 2:0:0:0: [sdc] 625142448 512-byte logical blocks: (320
GB/298 GiB)
[    1.868621] sd 2:0:0:0: [sdc] Write Protect is off
[    1.872700] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.872730] sd 2:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.873340] scsi 3:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-S203P 
SB00 PQ: 0 ANSI: 5
[    1.884464] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw
xa/form2 cdda tray
[    1.888643] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.893412] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    1.939026] usb 5-1: new low speed USB device using ohci_hcd and
address 2
[    1.963460]  sdc: sdc1 sdc2 sdc3 sdc4 < sdc5 sdc6 sdc7 sdc8 >
[    1.971177] sd 2:0:0:0: [sdc] Attached SCSI disk
[    4.511009] hda-intel: azx_get_response timeout, switching to polling
mode: last cmd=0x000f0000
[    5.516011] hda-intel: No response from codec, disabling MSI: last
cmd=0x000f0000
[    6.521011] hda-intel: Codec #0 probe error; disabling it...
[    7.530009] hda_intel: azx_get_response timeout, switching to
single_cmd mode: last cmd=0x000f0000
[    7.535206] ALSA device list:
[    7.539964]   #0: HDA ATI SB at 0xfe020000 irq 16
[    7.544738]   #1: HDA ATI HDMI at 0xfdbfc000 irq 42
[    7.549447] TCP cubic registered
[    7.553773] NET: Registered protocol family 17
[    7.558519] Bluetooth: L2CAP ver 2.15
[    7.563146] Bluetooth: L2CAP socket layer initialized
[    7.567645] Bluetooth: SCO (Voice Link) ver 0.6
[    7.572051] Bluetooth: SCO socket layer initialized
[    7.576687] Bluetooth: RFCOMM TTY layer initialized
[    7.581160] Bluetooth: RFCOMM socket layer initialized
[    7.585334] Bluetooth: RFCOMM ver 1.11
[    7.589742] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    7.594153] Bluetooth: BNEP filters: protocol multicast
[    7.598528] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    7.602686] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core
Processor 5600+ (2 cpu cores) (version 2.20.00)
[    7.607328] powernow-k8:    0 : fid 0x14 (2800 MHz), vid 0x8
[    7.611913] powernow-k8:    1 : fid 0x12 (2600 MHz), vid 0xa
[    7.616350] powernow-k8:    2 : fid 0x10 (2400 MHz), vid 0xc
[    7.620436] powernow-k8:    3 : fid 0xe (2200 MHz), vid 0xe
[    7.624883] powernow-k8:    4 : fid 0xc (2000 MHz), vid 0x10
[    7.629274] powernow-k8:    5 : fid 0xa (1800 MHz), vid 0x10
[    7.633513] powernow-k8:    6 : fid 0x2 (1000 MHz), vid 0x12
[    7.638053] md: Skipping autodetection of RAID arrays.
(raid=autodetect will force)
[    7.726338] EXT3-fs: barriers not enabled
[    7.739980] kjournald starting.  Commit interval 5 seconds
[    7.740077] EXT3-fs (sda3): mounted filesystem with writeback data mode
[    7.740106] VFS: Mounted root (ext3 filesystem) readonly on device 8:3.
[    7.761062] Freeing unused kernel memory: 436k freed
[   10.772949] udev: starting version 151
[   10.773145] udevd (3935): /proc/3935/oom_adj is deprecated, please
use /proc/3935/oom_score_adj instead.
[   11.049536] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00,
revision 0
[   11.123893] rtc_cmos 00:03: RTC can wake from S4
[   11.126088] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[   11.126122] rtc0: alarms up to one month, 242 bytes nvram
[   11.145557] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   11.145593] sd 1:0:0:0: Attached scsi generic sg1 type 0
[   11.145627] sd 2:0:0:0: Attached scsi generic sg2 type 0
[   11.145660] sr 3:0:0:0: Attached scsi generic sg3 type 5
[   11.157521] k8temp 0000:00:18.3: Temperature readouts might be wrong
- check erratum #141
[   11.172941] input: PC Speaker as /devices/platform/pcspkr/input/input2
[   11.172986] evbug: Connected device: input2 (PC Speaker at
isa0061/input0)
[   11.194250] IT8716 SuperIO detected.
[   11.194647] parport_pc 00:09: reported by Plug and Play ACPI
[   11.194680] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]
[   11.229073] input: iMON Panel, Knob and Mouse(15c2:ffdc) as
/devices/pci0000:00/0000:00:13.3/usb5/5-1/5-1:1.0/input/input3
[   11.229178] evbug: Connected device: input3 (iMON Panel, Knob and
Mouse(15c2:ffdc) at usb-0000:00:13.3-1/input1)
[   11.241646] atiixp 0000:00:14.1: IDE controller (0x1002:0x438c rev 0x00)
[   11.241665] ATIIXP_IDE 0000:00:14.1: PCI INT A -> GSI 16 (level, low)
-> IRQ 16
[   11.241687] atiixp 0000:00:14.1: not 100% native mode: will probe
irqs later
[   11.241695]     ide0: BM-DMA at 0xf900-0xf907
[   11.241703] Probing IDE interface ide0...
[   11.246031] imon 5-1:1.0: 0xffdc iMON VFD, MCE IR (id 0x9e)
[   11.275028] Registered IR keymap rc-imon-mce
[   11.275193] input: iMON Remote (15c2:ffdc) as
/devices/pci0000:00/0000:00:13.3/usb5/5-1/5-1:1.0/rc/rc0/input4
[   11.275265] evbug: Connected device: input4 (iMON Remote (15c2:ffdc)
at usb-0000:00:13.3-1/input0)
[   11.275271] rc0: iMON Remote (15c2:ffdc) as
/devices/pci0000:00/0000:00:13.3/usb5/5-1/5-1:1.0/rc/rc0
[   11.286134] imon 5-1:1.0: iMON device (15c2:ffdc, intf0) on usb<5:2>
initialized
[   11.286162] usbcore: registered new interface driver imon
[   11.396229] Linux video capture interface: v2.00
[   11.449792] IR NEC protocol handler initialized
[   11.472967] IR RC5(x) protocol handler initialized
[   11.616550] saa7130/34: v4l2 driver version 0.2.16 loaded
[   11.616682] saa7134 0000:03:06.0: PCI INT A -> GSI 21 (level, low) ->
IRQ 21
[   11.616745] saa7133[0]: found at 0000:03:06.0, rev: 209, irq: 21,
latency: 64, mmio: 0xfdeff000
[   11.616761] saa7133[0]: subsystem: 11bd:002f, board: Pinnacle PCTV
310i [card=101,autodetected]
[   11.616800] saa7133[0]: board init: gpio is 600e000
[   11.623301] IR RC6 protocol handler initialized
[   11.719171] saa7133[0]: i2c eeprom read error (err=-5)
[   11.756255] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   11.968327] IR JVC protocol handler initialized
[   11.988959] i2c-core: driver [tuner] using legacy suspend method
[   11.988968] i2c-core: driver [tuner] using legacy resume method
[   12.118591] IR Sony protocol handler initialized
[   12.268202] tuner 5-004b: chip found @ 0x96 (saa7133[0])
[   12.275592] lirc_dev: IR Remote Control driver registered, major 252
[   12.283310] IR LIRC bridge handler initialized
[   12.304033] tda829x 5-004b: setting tuner address to 61
[   12.362046] tda829x 5-004b: type set to tda8290+75a
[   15.374171] saa7133[0]: registered device video0 [v4l2]
[   15.374409] saa7133[0]: registered device vbi0
[   15.374497] saa7133[0]: registered device radio0
[   15.435588] dvb_init() allocating 1 frontend
[   15.466210] DVB: registering new adapter (saa7133[0])
[   15.466222] DVB: registering adapter 0 frontend 0 (Philips TDA10046H
DVB-T)...
[   15.530025] tda1004x: setting up plls for 48MHz sampling clock
[   16.901025] tda1004x: found firmware revision 0 -- invalid
[   16.901034] tda1004x: trying to boot from eeprom
[   17.906021] tda1004x: found firmware revision 0 -- invalid
[   17.906027] tda1004x: waiting for firmware upload...
[   17.967756] tda1004x: no firmware upload (timeout or file not found?)
[   17.967765] tda1004x: firmware upload failed
[   18.088492] saa7134 ALSA driver for DMA sound loaded
[   18.088551] saa7133[0]/alsa: saa7133[0] at 0xfdeff000 irq 21
registered as card -1
[   42.991545] EXT3-fs (sda3): using internal journal
[   43.147182] EXT3-fs: barriers not enabled
[   43.149402] kjournald starting.  Commit interval 5 seconds
[   43.149731] EXT3-fs (sda1): using internal journal
[   43.149744] EXT3-fs (sda1): mounted filesystem with writeback data mode
[   43.163699] EXT3-fs: barriers not enabled
[   43.171382] kjournald starting.  Commit interval 5 seconds
[   43.171721] EXT3-fs (sda2): using internal journal
[   43.171730] EXT3-fs (sda2): mounted filesystem with writeback data mode
[   43.188335] EXT3-fs: barriers not enabled
[   43.201134] kjournald starting.  Commit interval 5 seconds
[   43.201472] EXT3-fs (dm-1): using internal journal
[   43.201481] EXT3-fs (dm-1): mounted filesystem with writeback data mode
[   43.264554] EXT3-fs: barriers not enabled
[   43.273130] kjournald starting.  Commit interval 5 seconds
[   43.273441] EXT3-fs (dm-2): using internal journal
[   43.273452] EXT3-fs (dm-2): mounted filesystem with writeback data mode
[   43.292280] EXT3-fs: barriers not enabled
[   43.306091] kjournald starting.  Commit interval 5 seconds
[   43.306776] EXT3-fs (dm-3): using internal journal
[   43.306785] EXT3-fs (dm-3): mounted filesystem with writeback data mode
[   43.368910] EXT4-fs (dm-4): mounted filesystem with ordered data
mode. Opts: (null)
[   43.934958] EXT4-fs (dm-7): mounted filesystem without journal. Opts:
(null)
[   43.969686] EXT3-fs: barriers not enabled
[   43.969905] kjournald starting.  Commit interval 5 seconds
[   43.970243] EXT3-fs (dm-5): using internal journal
[   43.970254] EXT3-fs (dm-5): mounted filesystem with writeback data mode
[   43.977238] EXT4-fs (dm-6): mounted filesystem with ordered data
mode. Opts: (null)
[   44.031052] EXT4-fs (dm-0): mounted filesystem without journal. Opts:
(null)
[   45.757776] r8169 0000:02:00.0: eth0: link down
[   47.477514] r8169 0000:02:00.0: eth0: link up
[   48.218469] NET: Registered protocol family 10
[   55.725765] svc: failed to register lockdv1 RPC service (errno 97).
[   58.914023] eth0: no IPv6 routers present
[   84.791051] radeon 0000:01:05.0: Unsupported encoder type 0x19
tv ~ #



X.org log:

[    83.816]
X.Org X Server 1.9.4
Release Date: 2011-02-04
[    83.816] X Protocol Version 11, Revision 0
[    83.816] Build Operating System: Linux 2.6.38-rc3+ x86_64 Gentoo
[    83.816] Current Operating System: Linux tv 2.6.38-rc8 #522 SMP
PREEMPT Tue Mar 8 20:50:13 CET 2011 x86_64
[    83.816] Kernel command line: root=/dev/sda3 hpet=disable
[    83.816] Build Date: 20 February 2011  10:41:42AM
[    83.816] 
[    83.816] Current version of pixman: 0.20.2
[    83.816]    Before reporting problems, check http://wiki.x.org
        to make sure that you have the latest version.
[    83.816] Markers: (--) probed, (**) from config file, (==) default
setting,
        (++) from command line, (!!) notice, (II) informational,
        (WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[    83.817] (==) Log file: "/var/log/Xorg.0.log", Time: Sun Mar 13
14:49:03 2011
[    83.860] (==) Using config file: "/etc/X11/xorg.conf"
[    83.860] (==) Using system config directory "/usr/share/X11/xorg.conf.d"
[    83.883] (==) ServerLayout "X.org Configured"
[    83.883] (**) |-->Screen "Screen0" (0)
[    83.883] (**) |   |-->Monitor "Monitor0"
[    83.884] (**) |   |-->Device "Card0"
[    83.884] (**) |-->Input Device "Mouse0"
[    83.884] (**) |-->Input Device "Keyboard0"
[    83.884] (==) Automatically adding devices
[    83.884] (==) Automatically enabling devices
[    83.905] (WW) The directory "/usr/share/fonts/TTF/" does not exist.
[    83.906]    Entry deleted from font path.
[    83.906] (WW) The directory "/usr/share/fonts/OTF" does not exist.
[    83.906]    Entry deleted from font path.
[    83.906] (WW) The directory "/usr/share/fonts/Type1/" does not exist.
[    83.906]    Entry deleted from font path.
[    83.941] (WW) The directory "/usr/share/fonts/TTF/" does not exist.
[    83.941]    Entry deleted from font path.
[    83.941] (WW) The directory "/usr/share/fonts/OTF/" does not exist.
[    83.941]    Entry deleted from font path.
[    83.941] (WW) The directory "/usr/share/fonts/Type1/" does not exist.
[    83.941]    Entry deleted from font path.
[    83.941] (**) FontPath set to:
        /usr/share/fonts/misc/,
        /usr/share/fonts/100dpi/,
        /usr/share/fonts/75dpi/,
        /usr/share/fonts/misc/,
        /usr/share/fonts/100dpi/,
        /usr/share/fonts/75dpi/
[    83.941] (**) ModulePath set to "/usr/lib64/xorg/modules"
[    83.941] (WW) AllowEmptyInput is on, devices using drivers 'kbd',
'mouse' or 'vmmouse' will be disabled.
[    83.941] (WW) Disabling Mouse0
[    83.941] (WW) Disabling Keyboard0
[    83.941] (II) Loader magic: 0x7c7140
[    83.941] (II) Module ABI versions:
[    83.941]    X.Org ANSI C Emulation: 0.4
[    83.941]    X.Org Video Driver: 8.0
[    83.941]    X.Org XInput driver : 11.0
[    83.941]    X.Org Server Extension : 4.0
[    83.943] (--) PCI:*(0:1:5:0) 1002:791e:1043:826d rev 0, Mem @
0xf0000000/134217728, 0xfdbe0000/65536, 0xfda00000/1048576, I/O @
0x0000de00/256
[    83.943] (II) Open ACPI successful (/var/run/acpid.socket)
[    83.943] (II) "extmod" will be loaded. This was enabled by default
and also specified in the config file.
[    83.943] (II) "dbe" will be loaded. This was enabled by default and
also specified in the config file.
[    83.943] (II) "glx" will be loaded. This was enabled by default and
also specified in the config file.
[    83.943] (II) "record" will be loaded. This was enabled by default
and also specified in the config file.
[    83.943] (II) "dri" will be loaded. This was enabled by default and
also specified in the config file.
[    83.943] (II) "dri2" will be loaded. This was enabled by default and
also specified in the config file.
[    83.943] (II) LoadModule: "record"
[    83.996] (II) Loading /usr/lib64/xorg/modules/extensions/librecord.so
[    84.006] (II) Module record: vendor="X.Org Foundation"
[    84.006]    compiled for 1.9.4, module version = 1.13.0
[    84.006]    Module class: X.Org Server Extension
[    84.006]    ABI class: X.Org Server Extension, version 4.0
[    84.006] (II) Loading extension RECORD
[    84.006] (II) LoadModule: "dbe"
[    84.007] (II) Loading /usr/lib64/xorg/modules/extensions/libdbe.so
[    84.007] (II) Module dbe: vendor="X.Org Foundation"
[    84.007]    compiled for 1.9.4, module version = 1.0.0
[    84.007]    Module class: X.Org Server Extension
[    84.007]    ABI class: X.Org Server Extension, version 4.0
[    84.007] (II) Loading extension DOUBLE-BUFFER
[    84.007] (II) LoadModule: "extmod"
[    84.008] (II) Loading /usr/lib64/xorg/modules/extensions/libextmod.so
[    84.009] (II) Module extmod: vendor="X.Org Foundation"
[    84.009]    compiled for 1.9.4, module version = 1.0.0
[    84.009]    Module class: X.Org Server Extension
[    84.009]    ABI class: X.Org Server Extension, version 4.0
[    84.009] (II) Loading extension MIT-SCREEN-SAVER
[    84.009] (II) Loading extension XFree86-VidModeExtension
[    84.009] (II) Loading extension XFree86-DGA
[    84.009] (II) Loading extension DPMS
[    84.009] (II) Loading extension XVideo
[    84.010] (II) Loading extension XVideo-MotionCompensation
[    84.010] (II) Loading extension X-Resource
[    84.010] (II) LoadModule: "dri2"
[    84.010] (II) Loading /usr/lib64/xorg/modules/extensions/libdri2.so
[    84.024] (II) Module dri2: vendor="X.Org Foundation"
[    84.024]    compiled for 1.9.4, module version = 1.2.0
[    84.024]    ABI class: X.Org Server Extension, version 4.0
[    84.024] (II) Loading extension DRI2
[    84.024] (II) LoadModule: "glx"
[    84.024] (II) Loading /usr/lib64/xorg/modules/extensions/libglx.so
[    84.047] (II) Module glx: vendor="X.Org Foundation"
[    84.047]    compiled for 1.9.4, module version = 1.0.0
[    84.047]    ABI class: X.Org Server Extension, version 4.0
[    84.047] (==) AIGLX enabled
[    84.047] (II) Loading extension GLX
[    84.048] (II) LoadModule: "dri"
[    84.048] (II) Loading /usr/lib64/xorg/modules/extensions/libdri.so
[    84.052] (II) Module dri: vendor="X.Org Foundation"
[    84.052]    compiled for 1.9.4, module version = 1.0.0
[    84.052]    ABI class: X.Org Server Extension, version 4.0
[    84.052] (II) Loading extension XFree86-DRI
[    84.052] (II) LoadModule: "radeon"
[    84.057] (II) Loading /usr/lib64/xorg/modules/drivers/radeon_drv.so
[    84.104] (II) Module radeon: vendor="X.Org Foundation"
[    84.104]    compiled for 1.9.4, module version = 6.14.0
[    84.105]    Module class: X.Org Video Driver
[    84.105]    ABI class: X.Org Video Driver, version 8.0
[    84.106] (II) RADEON: Driver for ATI Radeon chipsets:
        ATI Radeon Mobility X600 (M24) 3150 (PCIE), ATI FireMV 2400 (PCI),
        ATI Radeon Mobility X300 (M24) 3152 (PCIE),
        ATI FireGL M24 GL 3154 (PCIE), ATI FireMV 2400 3155 (PCI),
        ATI Radeon X600 (RV380) 3E50 (PCIE),
        ATI FireGL V3200 (RV380) 3E54 (PCIE), ATI Radeon IGP320 (A3) 4136,
        ATI Radeon IGP330/340/350 (A4) 4137, ATI Radeon 9500 AD (AGP),
        ATI Radeon 9500 AE (AGP), ATI Radeon 9600TX AF (AGP),
        ATI FireGL Z1 AG (AGP), ATI Radeon 9800SE AH (AGP),
        ATI Radeon 9800 AI (AGP), ATI Radeon 9800 AJ (AGP),
        ATI FireGL X2 AK (AGP), ATI Radeon 9600 AP (AGP),
        ATI Radeon 9600SE AQ (AGP), ATI Radeon 9600XT AR (AGP),
        ATI Radeon 9600 AS (AGP), ATI FireGL T2 AT (AGP), ATI Radeon 9650,
        ATI FireGL RV360 AV (AGP), ATI Radeon 7000 IGP (A4+) 4237,
        ATI Radeon 8500 AIW BB (AGP), ATI Radeon IGP320M (U1) 4336,
        ATI Radeon IGP330M/340M/350M (U2) 4337,
        ATI Radeon Mobility 7000 IGP 4437, ATI Radeon 9000/PRO If (AGP/PCI),
        ATI Radeon 9000 Ig (AGP/PCI), ATI Radeon X800 (R420) JH (AGP),
        ATI Radeon X800PRO (R420) JI (AGP),
        ATI Radeon X800SE (R420) JJ (AGP), ATI Radeon X800 (R420) JK (AGP),
        ATI Radeon X800 (R420) JL (AGP), ATI FireGL X3 (R420) JM (AGP),
        ATI Radeon Mobility 9800 (M18) JN (AGP),
        ATI Radeon X800 SE (R420) (AGP), ATI Radeon X800XT (R420) JP (AGP),
        ATI Radeon X800 VE (R420) JT (AGP), ATI Radeon X850 (R480) (AGP),
        ATI Radeon X850 XT (R480) (AGP), ATI Radeon X850 SE (R480) (AGP),
        ATI Radeon X850 PRO (R480) (AGP), ATI Radeon X850 XT PE (R480)
(AGP),
        ATI Radeon Mobility M7 LW (AGP),
        ATI Mobility FireGL 7800 M7 LX (AGP),
        ATI Radeon Mobility M6 LY (AGP), ATI Radeon Mobility M6 LZ (AGP),
        ATI FireGL Mobility 9000 (M9) Ld (AGP),
        ATI Radeon Mobility 9000 (M9) Lf (AGP),
        ATI Radeon Mobility 9000 (M9) Lg (AGP), ATI Radeon 9700 Pro ND
(AGP),
        ATI Radeon 9700/9500Pro NE (AGP), ATI Radeon 9600TX NF (AGP),
        ATI FireGL X1 NG (AGP), ATI Radeon 9800PRO NH (AGP),
        ATI Radeon 9800 NI (AGP), ATI FireGL X2 NK (AGP),
        ATI Radeon 9800XT NJ (AGP),
        ATI Radeon Mobility 9600/9700 (M10/M11) NP (AGP),
        ATI Radeon Mobility 9600 (M10) NQ (AGP),
        ATI Radeon Mobility 9600 (M11) NR (AGP),
        ATI Radeon Mobility 9600 (M10) NS (AGP),
        ATI FireGL Mobility T2 (M10) NT (AGP),
        ATI FireGL Mobility T2e (M11) NV (AGP), ATI Radeon QD (AGP),
        ATI Radeon QE (AGP), ATI Radeon QF (AGP), ATI Radeon QG (AGP),
        ATI FireGL 8700/8800 QH (AGP), ATI Radeon 8500 QL (AGP),
        ATI Radeon 9100 QM (AGP), ATI Radeon 7500 QW (AGP/PCI),
        ATI Radeon 7500 QX (AGP/PCI), ATI Radeon VE/7000 QY (AGP/PCI),
        ATI Radeon VE/7000 QZ (AGP/PCI), ATI ES1000 515E (PCI),
        ATI Radeon Mobility X300 (M22) 5460 (PCIE),
        ATI Radeon Mobility X600 SE (M24C) 5462 (PCIE),
        ATI FireGL M22 GL 5464 (PCIE), ATI Radeon X800 (R423) UH (PCIE),
        ATI Radeon X800PRO (R423) UI (PCIE),
        ATI Radeon X800LE (R423) UJ (PCIE),
        ATI Radeon X800SE (R423) UK (PCIE),
        ATI Radeon X800 XTP (R430) (PCIE), ATI Radeon X800 XL (R430) (PCIE),
        ATI Radeon X800 SE (R430) (PCIE), ATI Radeon X800 (R430) (PCIE),
        ATI FireGL V7100 (R423) (PCIE), ATI FireGL V5100 (R423) UQ (PCIE),
        ATI FireGL unknown (R423) UR (PCIE),
        ATI FireGL unknown (R423) UT (PCIE),
        ATI Mobility FireGL V5000 (M26) (PCIE),
        ATI Mobility FireGL V5000 (M26) (PCIE),
        ATI Mobility Radeon X700 XL (M26) (PCIE),
        ATI Mobility Radeon X700 (M26) (PCIE),
        ATI Mobility Radeon X700 (M26) (PCIE),
        ATI Radeon X550XTX 5657 (PCIE), ATI Radeon 9100 IGP (A5) 5834,
        ATI Radeon Mobility 9100 IGP (U3) 5835,
        ATI Radeon XPRESS 200 5954 (PCIE),
        ATI Radeon XPRESS 200M 5955 (PCIE), ATI Radeon 9250 5960 (AGP),
        ATI Radeon 9200 5961 (AGP), ATI Radeon 9200 5962 (AGP),
        ATI Radeon 9200SE 5964 (AGP), ATI FireMV 2200 (PCI),
        ATI ES1000 5969 (PCI), ATI Radeon XPRESS 200 5974 (PCIE),
        ATI Radeon XPRESS 200M 5975 (PCIE),
        ATI Radeon XPRESS 200 5A41 (PCIE),
        ATI Radeon XPRESS 200M 5A42 (PCIE),
        ATI Radeon XPRESS 200 5A61 (PCIE),
        ATI Radeon XPRESS 200M 5A62 (PCIE),
        ATI Radeon X300 (RV370) 5B60 (PCIE),
        ATI Radeon X600 (RV370) 5B62 (PCIE),
        ATI Radeon X550 (RV370) 5B63 (PCIE),
        ATI FireGL V3100 (RV370) 5B64 (PCIE),
        ATI FireMV 2200 PCIE (RV370) 5B65 (PCIE),
        ATI Radeon Mobility 9200 (M9+) 5C61 (AGP),
        ATI Radeon Mobility 9200 (M9+) 5C63 (AGP),
        ATI Mobility Radeon X800 XT (M28) (PCIE),
        ATI Mobility FireGL V5100 (M28) (PCIE),
        ATI Mobility Radeon X800 (M28) (PCIE), ATI Radeon X850 5D4C (PCIE),
        ATI Radeon X850 XT PE (R480) (PCIE),
        ATI Radeon X850 SE (R480) (PCIE), ATI Radeon X850 PRO (R480) (PCIE),
        ATI unknown Radeon / FireGL (R480) 5D50 (PCIE),
        ATI Radeon X850 XT (R480) (PCIE),
        ATI Radeon X800XT (R423) 5D57 (PCIE),
        ATI FireGL V5000 (RV410) (PCIE), ATI Radeon X700 XT (RV410) (PCIE),
        ATI Radeon X700 PRO (RV410) (PCIE),
        ATI Radeon X700 SE (RV410) (PCIE), ATI Radeon X700 (RV410) (PCIE),
        ATI Radeon X700 SE (RV410) (PCIE), ATI Radeon X1800,
        ATI Mobility Radeon X1800 XT, ATI Mobility Radeon X1800,
        ATI Mobility FireGL V7200, ATI FireGL V7200, ATI FireGL V5300,
        ATI Mobility FireGL V7100, ATI Radeon X1800, ATI Radeon X1800,
        ATI Radeon X1800, ATI Radeon X1800, ATI Radeon X1800,
        ATI FireGL V7300, ATI FireGL V7350, ATI Radeon X1600, ATI RV505,
        ATI Radeon X1300/X1550, ATI Radeon X1550, ATI M54-GL,
        ATI Mobility Radeon X1400, ATI Radeon X1300/X1550,
        ATI Radeon X1550 64-bit, ATI Mobility Radeon X1300,
        ATI Mobility Radeon X1300, ATI Mobility Radeon X1300,
        ATI Mobility Radeon X1300, ATI Radeon X1300, ATI Radeon X1300,
        ATI RV505, ATI RV505, ATI FireGL V3300, ATI FireGL V3350,
        ATI Radeon X1300, ATI Radeon X1550 64-bit, ATI Radeon X1300/X1550,
        ATI Radeon X1600, ATI Radeon X1300/X1550, ATI Mobility Radeon X1450,
        ATI Radeon X1300/X1550, ATI Mobility Radeon X2300,
        ATI Mobility Radeon X2300, ATI Mobility Radeon X1350,
        ATI Mobility Radeon X1350, ATI Mobility Radeon X1450,
        ATI Radeon X1300, ATI Radeon X1550, ATI Mobility Radeon X1350,
        ATI FireMV 2250, ATI Radeon X1550 64-bit, ATI Radeon X1600,
        ATI Radeon X1650, ATI Radeon X1600, ATI Radeon X1600,
        ATI Mobility FireGL V5200, ATI Mobility Radeon X1600,
        ATI Radeon X1650, ATI Radeon X1650, ATI Radeon X1600,
        ATI Radeon X1300 XT/X1600 Pro, ATI FireGL V3400,
        ATI Mobility FireGL V5250, ATI Mobility Radeon X1700,
        ATI Mobility Radeon X1700 XT, ATI FireGL V5200,
        ATI Mobility Radeon X1700, ATI Radeon X2300HD,
        ATI Mobility Radeon HD 2300, ATI Mobility Radeon HD 2300,
        ATI Radeon X1950, ATI Radeon X1900, ATI Radeon X1950,
        ATI Radeon X1900, ATI Radeon X1900, ATI Radeon X1900,
        ATI Radeon X1900, ATI Radeon X1900, ATI Radeon X1900,
        ATI Radeon X1900, ATI Radeon X1900, ATI Radeon X1900,
        ATI AMD Stream Processor, ATI Radeon X1900, ATI Radeon X1950,
        ATI RV560, ATI RV560, ATI Mobility Radeon X1900, ATI RV560,
        ATI Radeon X1950 GT, ATI RV570, ATI RV570, ATI FireGL V7400,
        ATI RV560, ATI Radeon X1650, ATI Radeon X1650, ATI RV560,
        ATI Radeon 9100 PRO IGP 7834, ATI Radeon Mobility 9200 IGP 7835,
        ATI Radeon X1200, ATI Radeon X1200, ATI Radeon X1200,
        ATI Radeon X1200, ATI Radeon X1200, ATI RS740, ATI RS740M, ATI
RS740,
        ATI RS740M, ATI Radeon HD 2900 XT, ATI Radeon HD 2900 XT,
        ATI Radeon HD 2900 XT, ATI Radeon HD 2900 Pro, ATI Radeon HD
2900 GT,
        ATI FireGL V8650, ATI FireGL V8600, ATI FireGL V7600,
        ATI Radeon 4800 Series, ATI Radeon HD 4870 x2,
        ATI Radeon 4800 Series, ATI Radeon HD 4850 x2,
        ATI FirePro V8750 (FireGL), ATI FirePro V7760 (FireGL),
        ATI Mobility RADEON HD 4850, ATI Mobility RADEON HD 4850 X2,
        ATI Radeon 4800 Series, ATI FirePro RV770, AMD FireStream 9270,
        AMD FireStream 9250, ATI FirePro V8700 (FireGL),
        ATI Mobility RADEON HD 4870, ATI Mobility RADEON M98,
        ATI Mobility RADEON HD 4870, ATI Radeon 4800 Series,
        ATI Radeon 4800 Series, ATI FirePro M7750, ATI M98, ATI M98, ATI
M98,
        ATI Mobility Radeon HD 4650, ATI Radeon RV730 (AGP),
        ATI Mobility Radeon HD 4670, ATI FirePro M5750,
        ATI Mobility Radeon HD 4670, ATI Radeon RV730 (AGP),
        ATI RV730XT [Radeon HD 4670], ATI RADEON E4600,
        ATI Radeon HD 4600 Series, ATI RV730 PRO [Radeon HD 4650],
        ATI FirePro V7750 (FireGL), ATI FirePro V5700 (FireGL),
        ATI FirePro V3750 (FireGL), ATI Mobility Radeon HD 4830,
        ATI Mobility Radeon HD 4850, ATI FirePro M7740, ATI RV740,
        ATI Radeon HD 4770, ATI Radeon HD 4700 Series, ATI Radeon HD 4770,
        ATI FirePro M5750, ATI RV610, ATI Radeon HD 2400 XT,
        ATI Radeon HD 2400 Pro, ATI Radeon HD 2400 PRO AGP, ATI FireGL
V4000,
        ATI RV610, ATI Radeon HD 2350, ATI Mobility Radeon HD 2400 XT,
        ATI Mobility Radeon HD 2400, ATI RADEON E2400, ATI RV610,
        ATI FireMV 2260, ATI RV670, ATI Radeon HD3870,
        ATI Mobility Radeon HD 3850, ATI Radeon HD3850,
        ATI Mobility Radeon HD 3850 X2, ATI RV670,
        ATI Mobility Radeon HD 3870, ATI Mobility Radeon HD 3870 X2,
        ATI Radeon HD3870 X2, ATI FireGL V7700, ATI Radeon HD3850,
        ATI Radeon HD3690, AMD Firestream 9170, ATI Radeon HD 4550,
        ATI Radeon RV710, ATI Radeon RV710, ATI Radeon RV710,
        ATI Radeon HD 4350, ATI Mobility Radeon 4300 Series,
        ATI Mobility Radeon 4500 Series, ATI Mobility Radeon 4500 Series,
        ATI FirePro RG220, ATI Mobility Radeon 4330, ATI RV630,
        ATI Mobility Radeon HD 2600, ATI Mobility Radeon HD 2600 XT,
        ATI Radeon HD 2600 XT AGP, ATI Radeon HD 2600 Pro AGP,
        ATI Radeon HD 2600 XT, ATI Radeon HD 2600 Pro, ATI Gemini RV630,
        ATI Gemini Mobility Radeon HD 2600 XT, ATI FireGL V5600,
        ATI FireGL V3600, ATI Radeon HD 2600 LE,
        ATI Mobility FireGL Graphics Processor, ATI Radeon HD 3470,
        ATI Mobility Radeon HD 3430, ATI Mobility Radeon HD 3400 Series,
        ATI Radeon HD 3450, ATI Radeon HD 3450, ATI Radeon HD 3430,
        ATI Radeon HD 3450, ATI FirePro V3700, ATI FireMV 2450,
        ATI FireMV 2260, ATI FireMV 2260, ATI Radeon HD 3600 Series,
        ATI Radeon HD 3650 AGP, ATI Radeon HD 3600 PRO,
        ATI Radeon HD 3600 XT, ATI Radeon HD 3600 PRO,
        ATI Mobility Radeon HD 3650, ATI Mobility Radeon HD 3670,
        ATI Mobility FireGL V5700, ATI Mobility FireGL V5725,
        ATI Radeon HD 3200 Graphics, ATI Radeon 3100 Graphics,
        ATI Radeon HD 3200 Graphics, ATI Radeon 3100 Graphics,
        ATI Radeon HD 3300 Graphics, ATI Radeon HD 3200 Graphics,
        ATI Radeon 3000 Graphics, ATI Radeon HD 4200, ATI Radeon 4100,
        ATI Mobility Radeon HD 4200, ATI Mobility Radeon 4100,
        ATI Radeon HD 4290, ATI Radeon HD 4250, AMD Radeon HD 6310 Graphics,
        AMD Radeon HD 6310 Graphics, AMD Radeon HD 6250 Graphics,
        AMD Radeon HD 6250 Graphics, CYPRESS,
        ATI FirePro (FireGL) Graphics Adapter,
        ATI FirePro (FireGL) Graphics Adapter,
        ATI FirePro (FireGL) Graphics Adapter, AMD Firestream 9370,
        AMD Firestream 9350, ATI Radeon HD 5800 Series,
        ATI Radeon HD 5800 Series, ATI Radeon HD 5800 Series,
        ATI Radeon HD 5900 Series, ATI Radeon HD 5900 Series,
        ATI Mobility Radeon HD 5800 Series,
        ATI Mobility Radeon HD 5800 Series,
        ATI FirePro (FireGL) Graphics Adapter,
        ATI FirePro (FireGL) Graphics Adapter,
        ATI Mobility Radeon HD 5800 Series, ATI Radeon HD 5700 Series,
        ATI Radeon HD 5700 Series, ATI Radeon HD 5700 Series,
        ATI Mobility Radeon HD 5000 Series,
        ATI Mobility Radeon HD 5000 Series, ATI Mobility Radeon HD 5570,
        ATI FirePro (FireGL) Graphics Adapter,
        ATI FirePro (FireGL) Graphics Adapter, ATI Radeon HD 5670,
        ATI Radeon HD 5570, ATI Radeon HD 5500 Series, REDWOOD,
        ATI Mobility Radeon HD 5000 Series,
        ATI Mobility Radeon HD 5000 Series, ATI Mobility Radeon Graphics,
        ATI Mobility Radeon Graphics, CEDAR,
        ATI FirePro (FireGL) Graphics Adapter,
        ATI FirePro (FireGL) Graphics Adapter, ATI FirePro 2270, CEDAR,
        ATI Radeon HD 5450, CEDAR, AMD Radeon HD 6900M Series,
        Mobility Radeon HD 6000 Series, BARTS, BARTS,
        Mobility Radeon HD 6000 Series, Mobility Radeon HD 6000 Series,
        BARTS, BARTS, BARTS, BARTS, AMD Radeon HD 6800 Series,
        AMD Radeon HD 6800 Series, TURKS, TURKS, TURKS, TURKS, TURKS, TURKS,
        TURKS, TURKS, TURKS, TURKS, TURKS, TURKS, TURKS, CAICOS, CAICOS,
        CAICOS, CAICOS, CAICOS, CAICOS, CAICOS, CAICOS, CAICOS, CAICOS,
        CAICOS
[    84.116] (--) using VT number 7

[    84.152] (II) [KMS] Kernel modesetting enabled.
[    84.153] (==) RADEON(0): Depth 24, (--) framebuffer bpp 32
[    84.153] (II) RADEON(0): Pixel depth = 24 bits stored in 4 bytes (32
bpp pixmaps)
[    84.153] (==) RADEON(0): Default visual is TrueColor
[    84.153] (**) RADEON(0): Option "EnablePageFlip" "off"
[    84.153] (**) RADEON(0): Option "ColorTiling" "off"
[    84.153] (==) RADEON(0): RGB weight 888
[    84.153] (II) RADEON(0): Using 8 bits per RGB (8 bit DAC)
[    84.153] (--) RADEON(0): Chipset: "ATI Radeon X1200" (ChipID = 0x791e)
[    84.153] (II) RADEON(0): PCI card detected
[    84.153] drmOpenDevice: node name is /dev/dri/card0
[    84.154] drmOpenDevice: open result is 11, (OK)
[    84.154] drmOpenByBusid: Searching for BusID pci:0000:01:05.0
[    84.154] drmOpenDevice: node name is /dev/dri/card0
[    84.154] drmOpenDevice: open result is 11, (OK)
[    84.154] drmOpenByBusid: drmOpenMinor returns 11
[    84.154] drmOpenByBusid: drmGetBusid reports pci:0000:01:05.0
[    84.154] (II) RADEON(0): KMS Color Tiling: disabled
[    84.154] (II) RADEON(0): KMS Pageflipping: disabled
[    84.154] (II) RADEON(0): SwapBuffers wait for vsync: enabled
[    84.218] (II) RADEON(0): Output VGA-0 using monitor section Monitor0
[    84.342] (II) RADEON(0): Output S-video has no monitor section
[    84.447] (II) RADEON(0): Output HDMI-0 has no monitor section
[    84.451] (II) RADEON(0): Output DVI-0 has no monitor section
[    84.509] (II) RADEON(0): EDID for output VGA-0
[    84.509] (II) RADEON(0): Manufacturer: SAM  Model: 29e  Serial#: 0
[    84.509] (II) RADEON(0): Year: 2006  Week: 45
[    84.509] (II) RADEON(0): EDID Version: 1.3
[    84.509] (II) RADEON(0): Analog Display Input,  Input Voltage Level:
0.700/0.700 V
[    84.509] (II) RADEON(0): Sync:  Separate
[    84.509] (II) RADEON(0): Max Image Size [cm]: horiz.: 102  vert.: 57
[    84.509] (II) RADEON(0): Gamma: 2.20
[    84.509] (II) RADEON(0): DPMS capabilities: Off; RGB/Color Display
[    84.509] (II) RADEON(0): First detailed timing is preferred mode
[    84.509] (II) RADEON(0): redX: 0.640 redY: 0.330   greenX: 0.300
greenY: 0.600
[    84.509] (II) RADEON(0): blueX: 0.150 blueY: 0.060   whiteX: 0.312
whiteY: 0.329
[    84.509] (II) RADEON(0): Supported established timings:
[    84.509] (II) RADEON(0): 720x400@70Hz
[    84.509] (II) RADEON(0): 640x480@60Hz
[    84.510] (II) RADEON(0): 640x480@72Hz
[    84.510] (II) RADEON(0): 640x480@75Hz
[    84.510] (II) RADEON(0): 800x600@56Hz
[    84.510] (II) RADEON(0): 800x600@60Hz
[    84.510] (II) RADEON(0): 800x600@72Hz
[    84.510] (II) RADEON(0): 800x600@75Hz
[    84.510] (II) RADEON(0): 1024x768@60Hz
[    84.510] (II) RADEON(0): 1024x768@70Hz
[    84.510] (II) RADEON(0): 1024x768@75Hz
[    84.510] (II) RADEON(0): 1280x1024@75Hz
[    84.510] (II) RADEON(0): Manufacturer's mask: 0
[    84.510] (II) RADEON(0): Supported standard timings:
[    84.510] (II) RADEON(0): #0: hsize: 1600  vsize 1200  refresh: 60 
vid: 16553
[    84.510] (II) RADEON(0): #1: hsize: 1280  vsize 1024  refresh: 60 
vid: 32897
[    84.510] (II) RADEON(0): #2: hsize: 1024  vsize 768  refresh: 60 
vid: 16481
[    84.510] (II) RADEON(0): Supported detailed timing:
[    84.510] (II) RADEON(0): clock: 138.5 MHz   Image Size:  1018 x 573 mm
[    84.510] (II) RADEON(0): h_active: 1920  h_sync: 1968  h_sync_end
2000 h_blank_end 2080 h_border: 0
[    84.510] (II) RADEON(0): v_active: 1080  v_sync: 1083  v_sync_end
1088 v_blanking: 1111 v_border: 0
[    84.510] (II) RADEON(0): Supported detailed timing:
[    84.510] (II) RADEON(0): clock: 108.0 MHz   Image Size:  1018 x 573 mm
[    84.510] (II) RADEON(0): h_active: 1280  h_sync: 1328  h_sync_end
1440 h_blank_end 1688 h_border: 0
[    84.510] (II) RADEON(0): v_active: 1024  v_sync: 1025  v_sync_end
1028 v_blanking: 1066 v_border: 0
[    84.510] (II) RADEON(0): Monitor name: SAMSUNG
[    84.510] (II) RADEON(0): Ranges: V min: 56 V max: 75 Hz, H min: 30 H
max: 80 kHz, PixClock max 145 MHz
[    84.510] (II) RADEON(0): EDID (in hex):
[    84.510] (II) RADEON(0):    00ffffffffffff004c2d9e0200000000
[    84.510] (II) RADEON(0):    2d100103686639782aee91a3544c9926
[    84.510] (II) RADEON(0):    0f5054afcf00a9408180614001010101
[    84.510] (II) RADEON(0):    0101010101011a3680a070381f403020
[    84.510] (II) RADEON(0):    3500fa3d3200001a302a009851002a40
[    84.510] (II) RADEON(0):    30701300fa3d3200001e000000fc0053
[    84.510] (II) RADEON(0):    414d53554e470a2020202020000000fd
[    84.510] (II) RADEON(0):    00384b1e500e000a20202020202000cc
[    84.510] (II) RADEON(0): EDID vendor "SAM", prod id 670
[    84.511] (II) RADEON(0): Using hsync ranges from config file
[    84.511] (II) RADEON(0): Using vrefresh ranges from config file
[    84.511] (II) RADEON(0): Printing DDC gathered Modelines:
[    84.511] (II) RADEON(0): Modeline "1920x1080"x0.0  138.50  1920 1968
2000 2080  1080 1083 1088 1111 +hsync -vsync (66.6 kHz)
[    84.511] (II) RADEON(0): Modeline "1280x1024"x0.0  108.00  1280 1328
1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    84.511] (II) RADEON(0): Modeline "800x600"x0.0   40.00  800 840 968
1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    84.511] (II) RADEON(0): Modeline "800x600"x0.0   36.00  800 824 896
1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    84.511] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 656 720
840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    84.511] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 664 704
832  480 489 492 520 -hsync -vsync (37.9 kHz)
[    84.511] (II) RADEON(0): Modeline "640x480"x0.0   25.18  640 656 752
800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    84.511] (II) RADEON(0): Modeline "720x400"x0.0   28.32  720 738 846
900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    84.511] (II) RADEON(0): Modeline "1280x1024"x0.0  135.00  1280 1296
1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    84.511] (II) RADEON(0): Modeline "1024x768"x0.0   78.75  1024 1040
1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    84.511] (II) RADEON(0): Modeline "1024x768"x0.0   75.00  1024 1048
1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    84.511] (II) RADEON(0): Modeline "1024x768"x0.0   65.00  1024 1048
1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    84.511] (II) RADEON(0): Modeline "800x600"x0.0   49.50  800 816 896
1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    84.511] (II) RADEON(0): Modeline "800x600"x0.0   50.00  800 856 976
1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    84.511] (II) RADEON(0): Modeline "1600x1200"x0.0  162.00  1600 1664
1856 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz)
[    84.511] (II) RADEON(0): Not using mode "1600x1200" (bad mode
clock/interlace/doublescan)
[    84.511] (II) RADEON(0): Not using mode "1280x1024" (vrefresh out of
range)
[    84.512] (II) RADEON(0): Not using mode "1024x768" (vrefresh out of
range)
[    84.512] (II) RADEON(0): Not using mode "800x600" (vrefresh out of
range)
[    84.512] (II) RADEON(0): Not using mode "800x600" (vrefresh out of
range)
[    84.512] (II) RADEON(0): Not using mode "640x480" (vrefresh out of
range)
[    84.512] (II) RADEON(0): Not using mode "640x480" (vrefresh out of
range)
[    84.512] (II) RADEON(0): Printing probed modes for output VGA-0
[    84.512] (II) RADEON(0): Modeline "1920x1080"x59.9  138.50  1920
1968 2000 2080  1080 1083 1088 1111 +hsync -vsync (66.6 kHz)
[    84.512] (II) RADEON(0): Modeline "1280x1024"x60.0  108.00  1280
1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    84.512] (II) RADEON(0): Modeline "1024x768"x70.1   75.00  1024 1048
1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    84.512] (II) RADEON(0): Modeline "1024x768"x60.0   65.00  1024 1048
1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    84.512] (II) RADEON(0): Modeline "800x600"x60.3   40.00  800 840
968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    84.512] (II) RADEON(0): Modeline "800x600"x56.2   36.00  800 824
896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    84.512] (II) RADEON(0): Modeline "640x480"x60.0   25.20  640 656
752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    84.512] (II) RADEON(0): Modeline "720x400"x70.1   28.32  720 738
846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    84.636] (II) RADEON(0): EDID for output S-video
[    84.741] (II) Quirked EDID physical size to 0x0 cm
[    84.741] (II) RADEON(0): EDID for output HDMI-0
[    84.741] (II) RADEON(0): Manufacturer: SAM  Model: 29f  Serial#: 0
[    84.742] (II) RADEON(0): Year: 2006  Week: 45
[    84.742] (II) RADEON(0): EDID Version: 1.3
[    84.742] (II) RADEON(0): Digital Display Input
[    84.742] (II) RADEON(0): Indeterminate output size
[    84.742] (II) RADEON(0): Gamma: 2.20
[    84.742] (II) RADEON(0): No DPMS capabilities specified
[    84.742] (II) RADEON(0): Supported color encodings: RGB 4:4:4 YCrCb
4:4:4
[    84.742] (II) RADEON(0): First detailed timing is preferred mode
[    84.742] (II) RADEON(0): redX: 0.650 redY: 0.330   greenX: 0.300
greenY: 0.600
[    84.742] (II) RADEON(0): blueX: 0.150 blueY: 0.080   whiteX: 0.313
whiteY: 0.329
[    84.742] (II) RADEON(0): Supported established timings:
[    84.742] (II) RADEON(0): 720x400@70Hz
[    84.742] (II) RADEON(0): 640x480@60Hz
[    84.742] (II) RADEON(0): 800x600@60Hz
[    84.742] (II) RADEON(0): 1024x768@60Hz
[    84.742] (II) RADEON(0): Manufacturer's mask: 0
[    84.742] (II) RADEON(0): Supported standard timings:
[    84.742] (II) RADEON(0): #0: hsize: 1280  vsize 1024  refresh: 60 
vid: 32897
[    84.742] (II) RADEON(0): Supported detailed timing:
[    84.742] (II) RADEON(0): clock: 148.5 MHz   Image Size:  160 x 90 mm
[    84.742] (II) RADEON(0): h_active: 1920  h_sync: 2008  h_sync_end
2052 h_blank_end 2200 h_border: 0
[    84.742] (II) RADEON(0): v_active: 1080  v_sync: 1084  v_sync_end
1089 v_blanking: 1125 v_border: 0
[    84.742] (II) RADEON(0): Supported detailed timing:
[    84.742] (II) RADEON(0): clock: 74.2 MHz   Image Size:  160 x 90 mm
[    84.742] (II) RADEON(0): h_active: 1280  h_sync: 1390  h_sync_end
1430 h_blank_end 1650 h_border: 0
[    84.742] (II) RADEON(0): v_active: 720  v_sync: 725  v_sync_end 730
v_blanking: 750 v_border: 0
[    84.742] (II) RADEON(0): Monitor name: SAMSUNG
[    84.742] (II) RADEON(0): Ranges: V min: 49 V max: 71 Hz, H min: 15 H
max: 70 kHz, PixClock max 235 MHz
[    84.742] (II) RADEON(0): Supported detailed timing:
[    84.742] (II) RADEON(0): clock: 74.2 MHz   Image Size:  160 x 90 mm
[    84.742] (II) RADEON(0): h_active: 1280  h_sync: 1720  h_sync_end
1760 h_blank_end 1980 h_border: 0
[    84.742] (II) RADEON(0): v_active: 720  v_sync: 725  v_sync_end 730
v_blanking: 750 v_border: 0
[    84.742] (II) RADEON(0): Supported detailed timing:
[    84.742] (II) RADEON(0): clock: 74.2 MHz   Image Size:  160 x 90 mm
[    84.742] (II) RADEON(0): h_active: 1920  h_sync: 2008  h_sync_end
2052 h_blank_end 2200 h_border: 0
[    84.743] (II) RADEON(0): v_active: 540  v_sync: 542  v_sync_end 547
v_blanking: 562 v_border: 0
[    84.743] (II) RADEON(0): Supported detailed timing:
[    84.743] (II) RADEON(0): clock: 74.2 MHz   Image Size:  160 x 90 mm
[    84.743] (II) RADEON(0): h_active: 1920  h_sync: 2448  h_sync_end
2492 h_blank_end 2640 h_border: 0
[    84.743] (II) RADEON(0): v_active: 540  v_sync: 542  v_sync_end 547
v_blanking: 562 v_border: 0
[    84.743] (II) RADEON(0): Supported detailed timing:
[    84.743] (II) RADEON(0): clock: 27.0 MHz   Image Size:  160 x 90 mm
[    84.743] (II) RADEON(0): h_active: 720  h_sync: 736  h_sync_end 798
h_blank_end 858 h_border: 0
[    84.743] (II) RADEON(0): v_active: 480  v_sync: 489  v_sync_end 495
v_blanking: 525 v_border: 0
[    84.743] (II) RADEON(0): Number of EDID sections to follow: 1
[    84.743] (II) RADEON(0): EDID (in hex):
[    84.743] (II) RADEON(0):    00ffffffffffff004c2d9f0200000000
[    84.743] (II) RADEON(0):    2d100103801009780aaea5a6544c9926
[    84.743] (II) RADEON(0):    145054a1080081800101010101010101
[    84.743] (II) RADEON(0):    010101010101023a801871382d40582c
[    84.743] (II) RADEON(0):    4500a05a0000001e011d007251d01e20
[    84.743] (II) RADEON(0):    6e285500a05a0000001e000000fc0053
[    84.743] (II) RADEON(0):    414d53554e470a2020202020000000fd
[    84.743] (II) RADEON(0):    0031470f4617000a202020202020019b
[    84.743] (II) RADEON(0):    020327f14b901f041305140312202122
[    84.743] (II) RADEON(0):    2309070783010000e2000fe305030167
[    84.743] (II) RADEON(0):    030c002000b82d011d00bc52d01e20b8
[    84.743] (II) RADEON(0):    285540a05a0000001e011d8018711c16
[    84.743] (II) RADEON(0):    20582c2500a05a0000009e011d80d072
[    84.743] (II) RADEON(0):    1c1620102c2580a05a0000009e8c0ad0
[    84.743] (II) RADEON(0):    8a20e02d10103e9600a05a0000001800
[    84.743] (II) RADEON(0):    000000000000000000000000000000dc
[    84.743] (II) RADEON(0): Printing probed modes for output HDMI-0
[    84.743] (II) RADEON(0): Modeline "1920x1080"x60.0  148.50  1920
2008 2052 2200  1080 1084 1089 1125 +hsync +vsync (67.5 kHz)
[    84.743] (II) RADEON(0): Modeline "1280x1024"x60.0  108.00  1280
1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    84.743] (II) RADEON(0): Modeline "1280x720"x50.0   74.25  1280 1720
1760 1980  720 725 730 750 +hsync +vsync (37.5 kHz)
[    84.744] (II) RADEON(0): Modeline "1280x720"x60.0   74.25  1280 1390
1430 1650  720 725 730 750 +hsync +vsync (45.0 kHz)
[    84.744] (II) RADEON(0): Modeline "1024x768"x60.0   65.00  1024 1048
1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    84.744] (II) RADEON(0): Modeline "800x600"x60.3   40.00  800 840
968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    84.744] (II) RADEON(0): Modeline "640x480"x60.0   25.20  640 656
752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    84.744] (II) RADEON(0): Modeline "720x400"x70.1   28.32  720 738
846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    84.748] (II) RADEON(0): EDID for output DVI-0
[    84.748] (II) RADEON(0): Output VGA-0 connected
[    84.748] (II) RADEON(0): Output S-video disconnected
[    84.748] (II) RADEON(0): Output HDMI-0 connected
[    84.748] (II) RADEON(0): Output DVI-0 disconnected
[    84.748] (II) RADEON(0): Using exact sizes for initial modes
[    84.748] (II) RADEON(0): Output VGA-0 using initial mode 1920x1080
[    84.748] (II) RADEON(0): Output HDMI-0 using initial mode 1920x1080
[    84.748] (II) RADEON(0): Using default gamma of (1.0, 1.0, 1.0)
unless otherwise stated.
[    84.748] (II) RADEON(0): mem size init: gart size :1fdff000 vram
size: s:8000000 visible:77d7000
[    84.748] (II) RADEON(0): EXA: Driver will allow EXA pixmaps in VRAM
[    84.748] (**) RADEON(0): Display dimensions: (1020, 570) mm
[    84.748] (**) RADEON(0): DPI set to (47, 48)
[    84.748] (II) Loading sub module "fb"
[    84.748] (II) LoadModule: "fb"
[    84.756] (II) Loading /usr/lib64/xorg/modules/libfb.so
[    84.767] (II) Module fb: vendor="X.Org Foundation"
[    84.767]    compiled for 1.9.4, module version = 1.0.0
[    84.767]    ABI class: X.Org ANSI C Emulation, version 0.4
[    84.767] (II) Loading sub module "ramdac"
[    84.767] (II) LoadModule: "ramdac"
[    84.767] (II) Module "ramdac" already built-in
[    84.767] (II) Loading sub module "exa"
[    84.768] (II) LoadModule: "exa"
[    84.768] (II) Loading /usr/lib64/xorg/modules/libexa.so
[    84.769] (II) Module exa: vendor="X.Org Foundation"
[    84.769]    compiled for 1.9.4, module version = 2.5.0
[    84.769]    ABI class: X.Org Video Driver, version 8.0
[    84.769] (--) Depth 24 pixmap format is 32 bpp
[    84.770] (II) RADEON(0): [DRI2] Setup complete
[    84.770] (II) RADEON(0): [DRI2]   DRI driver: r300
[    84.770] (II) RADEON(0): Front buffer size: 8100K
[    84.770] (II) RADEON(0): VRAM usage limit set to 103154K
[    84.773] (==) RADEON(0): Backing store disabled
[    84.773] (II) RADEON(0): Direct rendering enabled
[    84.776] (II) RADEON(0): Render acceleration enabled for
R300/R400/R500 type cards.
[    84.776] (II) RADEON(0): Setting EXA maxPitchBytes
[    84.776] (II) EXA(0): Driver allocated offscreen pixmaps
[    84.776] (II) EXA(0): Driver registered support for the following
operations:
[    84.776] (II)         Solid
[    84.776] (II)         Copy
[    84.776] (II)         Composite (RENDER acceleration)
[    84.776] (II)         UploadToScreen
[    84.776] (II)         DownloadFromScreen
[    84.776] (II) RADEON(0): Acceleration enabled
[    84.776] (==) RADEON(0): DPMS enabled
[    84.776] (==) RADEON(0): Silken mouse enabled
[    84.778] (II) RADEON(0): Set up textured video
[    84.778] (II) RADEON(0): RandR 1.2 enabled, ignore the following
RandR disabled message.
[    84.791] (WW) RADEON(0): Option "DisplayPriority" is not used
[    84.791] (--) RandR disabled
[    84.791] (II) Initializing built-in extension Generic Event Extension
[    84.791] (II) Initializing built-in extension SHAPE
[    84.791] (II) Initializing built-in extension MIT-SHM
[    84.791] (II) Initializing built-in extension XInputExtension
[    84.791] (II) Initializing built-in extension XTEST
[    84.791] (II) Initializing built-in extension BIG-REQUESTS
[    84.791] (II) Initializing built-in extension SYNC
[    84.791] (II) Initializing built-in extension XKEYBOARD
[    84.791] (II) Initializing built-in extension XC-MISC
[    84.791] (II) Initializing built-in extension XINERAMA
[    84.791] (II) Initializing built-in extension XFIXES
[    84.791] (II) Initializing built-in extension RENDER
[    84.791] (II) Initializing built-in extension RANDR
[    84.791] (II) Initializing built-in extension COMPOSITE
[    84.791] (II) Initializing built-in extension DAMAGE
[    84.896] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[    84.896] (II) AIGLX: enabled GLX_INTEL_swap_event
[    84.896] (II) AIGLX: enabled GLX_SGI_swap_control and
GLX_MESA_swap_control
[    84.896] (II) AIGLX: enabled GLX_SGI_make_current_read
[    84.896] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer
objects
[    84.897] (II) AIGLX: Loaded and initialized /usr/lib64/dri/r300_dri.so
[    84.897] (II) GLX: Initialized DRI2 GL provider for screen 0
[    84.899] (II) RADEON(0): Setting screen physical size to 508 x 285
[    85.407] (II) config/udev: Adding input device Power Button
(/dev/input/event1)
[    85.407] (**) Power Button: Applying InputClass "evdev keyboard
catchall"
[    85.407] (II) LoadModule: "evdev"
[    85.407] (II) Loading /usr/lib64/xorg/modules/input/evdev_drv.so
[    85.426] (II) Module evdev: vendor="X.Org Foundation"
[    85.426]    compiled for 1.9.4, module version = 2.6.0
[    85.426]    Module class: X.Org XInput Driver
[    85.426]    ABI class: X.Org XInput driver, version 11.0
[    85.426] (**) Power Button: always reports core events
[    85.426] (**) Power Button: Device: "/dev/input/event1"
[    85.432] (--) Power Button: Found keys
[    85.432] (II) Power Button: Configuring as keyboard
[    85.432] (II) XINPUT: Adding extended input device "Power Button"
(type: KEYBOARD)
[    85.432] (**) Option "xkb_rules" "evdev"
[    85.432] (**) Option "xkb_model" "evdev"
[    85.432] (**) Option "xkb_layout" "us"
[    85.496] (II) config/udev: Adding input device Power Button
(/dev/input/event0)
[    85.496] (**) Power Button: Applying InputClass "evdev keyboard
catchall"
[    85.496] (**) Power Button: always reports core events
[    85.496] (**) Power Button: Device: "/dev/input/event0"
[    85.502] (--) Power Button: Found keys
[    85.502] (II) Power Button: Configuring as keyboard
[    85.502] (II) XINPUT: Adding extended input device "Power Button"
(type: KEYBOARD)
[    85.502] (**) Option "xkb_rules" "evdev"
[    85.502] (**) Option "xkb_model" "evdev"
[    85.502] (**) Option "xkb_layout" "us"
[    85.521] (II) config/udev: Adding input device iMON Panel, Knob and
Mouse(15c2:ffdc) (/dev/input/event3)
[    85.521] (**) iMON Panel, Knob and Mouse(15c2:ffdc): Applying
InputClass "evdev pointer catchall"
[    85.521] (**) iMON Panel, Knob and Mouse(15c2:ffdc): Applying
InputClass "evdev keyboard catchall"
[    85.521] (**) iMON Panel, Knob and Mouse(15c2:ffdc): always reports
core events
[    85.521] (**) iMON Panel, Knob and Mouse(15c2:ffdc): Device:
"/dev/input/event3"
[    85.526] (--) iMON Panel, Knob and Mouse(15c2:ffdc): Found 3 mouse
buttons
[    85.526] (--) iMON Panel, Knob and Mouse(15c2:ffdc): Found scroll
wheel(s)
[    85.526] (--) iMON Panel, Knob and Mouse(15c2:ffdc): Found relative axes
[    85.526] (--) iMON Panel, Knob and Mouse(15c2:ffdc): Found x and y
relative axes
[    85.526] (--) iMON Panel, Knob and Mouse(15c2:ffdc): Found keys
[    85.526] (II) iMON Panel, Knob and Mouse(15c2:ffdc): Configuring as
mouse
[    85.526] (II) iMON Panel, Knob and Mouse(15c2:ffdc): Configuring as
keyboard
[    85.526] (II) iMON Panel, Knob and Mouse(15c2:ffdc): Adding
scrollwheel support
[    85.526] (**) iMON Panel, Knob and Mouse(15c2:ffdc): YAxisMapping:
buttons 4 and 5
[    85.526] (**) iMON Panel, Knob and Mouse(15c2:ffdc):
EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[    85.526] (II) XINPUT: Adding extended input device "iMON Panel, Knob
and Mouse(15c2:ffdc)" (type: KEYBOARD)
[    85.526] (**) Option "xkb_rules" "evdev"
[    85.526] (**) Option "xkb_model" "evdev"
[    85.526] (**) Option "xkb_layout" "us"
[    85.527] (**) iMON Panel, Knob and Mouse(15c2:ffdc): (accel) keeping
acceleration scheme 1
[    85.527] (**) iMON Panel, Knob and Mouse(15c2:ffdc): (accel)
acceleration profile 0
[    85.527] (**) iMON Panel, Knob and Mouse(15c2:ffdc): (accel)
acceleration factor: 2.000
[    85.527] (**) iMON Panel, Knob and Mouse(15c2:ffdc): (accel)
acceleration threshold: 4
[    85.527] (II) iMON Panel, Knob and Mouse(15c2:ffdc): initialized for
relative axes.
[    85.528] (II) config/udev: Adding input device iMON Panel, Knob and
Mouse(15c2:ffdc) (/dev/input/mouse0)
[    85.528] (II) No input driver/identifier specified (ignoring)
[    85.529] (II) config/udev: Adding input device iMON Remote
(15c2:ffdc) (/dev/input/event4)
[    85.529] (**) iMON Remote (15c2:ffdc): Applying InputClass "evdev
keyboard catchall"
[    85.529] (**) iMON Remote (15c2:ffdc): always reports core events
[    85.529] (**) iMON Remote (15c2:ffdc): Device: "/dev/input/event4"
[    85.534] (--) iMON Remote (15c2:ffdc): Found keys
[    85.534] (II) iMON Remote (15c2:ffdc): Configuring as keyboard
[    85.534] (II) XINPUT: Adding extended input device "iMON Remote
(15c2:ffdc)" (type: KEYBOARD)
[    85.534] (**) Option "xkb_rules" "evdev"
[    85.534] (**) Option "xkb_model" "evdev"
[    85.534] (**) Option "xkb_layout" "us"
[    85.543] (II) config/udev: Adding input device PC Speaker
(/dev/input/event2)
[    85.543] (II) No input driver/identifier specified (ignoring)


