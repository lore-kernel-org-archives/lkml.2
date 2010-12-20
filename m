Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848Ab0LTOea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 09:34:30 -0500
Received: from seehuhn.de ([80.68.93.199]:55756 "EHLO seehuhn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843Ab0LTOe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 09:34:27 -0500
X-Greylist: delayed 1686 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Dec 2010 09:34:26 EST
Date: Mon, 20 Dec 2010 14:06:16 +0000
From: Jochen Voss <voss@seehuhn.de>
To: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Dave Airlie <airlied@redhat.com>
Subject: post-rc4 regression (bisected): blank screen on ASUS P5KPL-AM
Message-ID: <20101220140615.GA3035@automatix>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

My system, when booted with recent kernels, fails to show any output
on the monitor.  The problem occurs very early during bootup (I never
see anything after the messages from grub), the monitor indicates that
there is no video signal at all and dmesg shows the following lines:

[    1.540465] usbhid: USB HID core driver
[    2.490014] No connectors reported connected with modes
[    2.490019] [drm] Cannot find any crtc or sizes - going 1024x768
[    2.496064] Console: switching to colour frame buffer device 128x48
[    2.497729] fb0: inteldrmfb frame buffer device

The machine seems fine otherwise: I can log in remotely and logging in
from the console (by typing blindly without visual feedback) also
works.

The problem is present in the current kernel as of this morning (I see
it with commit 55ec86f848a5f872fd43f5d7206464a0af419110).  Bisection
indicates that it is caused by the following commit.

    commit 541cc966915b6756e54c20eebe60ae957afdb537
    Author: Chris Wilson <chris@chris-wilson.co.uk>
    Date:   Mon Dec 6 11:24:07 2010 +0000

	drm: Don't try and disable an encoder that was never enabled

	Prevents code that assumes that the encoder is active when
	asked to be disabled from dying a horrible death.

	Reported-by: Daniel Vetter <daniel.vetter@ffwll.ch>
	Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
	Signed-off-by: Dave Airlie <airlied@redhat.com>

I verfied that the problem disappears when booting recent kernels
(i.e. 55ec86f848a5f872fd43f5d7206464a0af419110) with the offending
commit reverted.  The screen works again and the dmesg output now
changes to

[    1.542515] usbhid: USB HID core driver
[    1.547569] Console: switching to colour frame buffer device 210x65
[    1.551558] fb0: inteldrmfb frame buffer device

Note that the one second wait which was present in the bad dmesg
has now disappeared.

System information:

    ASUS P5KPL-AM mainboard (Intel G31 chipset)
    Intel Core2 quad core CPU
    Ubuntu 10.10

Appended files:

    dmesg.bad: dmesg for 55ec86f848a5f872fd43f5d7206464a0af419110
    dmesg.good: dmesg for 55ec86... with
        541cc966915b6756e54c20eebe60ae957afdb537 reverted
    lspci: "lspci -v" output (on a good kernel)

I'd be happy to send further information or to try patches etc.

I hope this helps,
Jochen
-- 
http://seehuhn.de/

--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.bad"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.37-rc6-jv (root@automatix) (gcc version 4.4.5 (Ubuntu/Linaro 4.4.4-14ubuntu5) ) #1 SMP PREEMPT Mon Dec 20 12:32:07 GMT 2010
[    0.000000] Command line: root=UUID=afafeaae-5b38-46d0-8bde-cf26eb46e29f ro quiet splash 
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000df690000 (usable)
[    0.000000]  BIOS-e820: 00000000df690000 - 00000000df69e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000df69e000 - 00000000df6d0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000df6d0000 - 00000000df6de000 (reserved)
[    0.000000]  BIOS-e820: 00000000df6e0000 - 00000000df700000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: P5KPL-AM/System Product Name, BIOS 0603    08/20/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   1 base 000000000 mask F00000000 write-back
[    0.000000]   2 base 100000000 mask FE0000000 write-back
[    0.000000]   3 base 0DF700000 mask FFFF00000 uncachable
[    0.000000]   4 base 0DF800000 mask FFF800000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000df700000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xdf690 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000df690000
[    0.000000]  0000000000 - 00df600000 page 2M
[    0.000000]  00df600000 - 00df690000 page 4k
[    0.000000] kernel direct mapping tables up to df690000 @ 1fffa000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-0000000120000000
[    0.000000]  0100000000 - 0120000000 page 2M
[    0.000000] kernel direct mapping tables up to 120000000 @ df68a000-df690000
[    0.000000] RAMDISK: 371be000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000fb630 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000df690100 00054 (v01 A_M_I_ OEMXSDT  08001020 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000df690290 000F4 (v03 A_M_I_ OEMFACP  08001020 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000df6905c0 07C37 (v01  A0846 A0846000 00000000 INTL 20060113)
[    0.000000] ACPI: FACS 00000000df69e000 00040
[    0.000000] ACPI: APIC 00000000df690390 0006C (v01 A_M_I_ OEMAPIC  08001020 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000df690400 0003C (v01 A_M_I_ OEMMCFG  08001020 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000df69e040 00080 (v01 A_M_I_ AMI_OEM  08001020 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000df698200 00038 (v01 A_M_I_ OEMHPET  08001020 MSFT 00000097)
[    0.000000] ACPI: GSCI 00000000df69e0c0 02024 (v01 A_M_I_ GMCHSCI  08001020 MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000120000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000120000000
[    0.000000]   NODE_DATA [000000011fffd000 - 000000011fffffff]
[    0.000000]  [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff88011be00000-ffff88011f7fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00120000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000df690
[    0.000000]     0: 0x00100000 -> 0x00120000
[    0.000000] On node 0 totalpages: 1046047
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3921 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 896712 pages, LIFO batch:31
[    0.000000]   Normal zone: 1792 pages used for memmap
[    0.000000]   Normal zone: 129280 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000df690000 - 00000000df69e000
[    0.000000] PM: Registered nosave memory: 00000000df69e000 - 00000000df6d0000
[    0.000000] PM: Registered nosave memory: 00000000df6d0000 - 00000000df6de000
[    0.000000] PM: Registered nosave memory: 00000000df6de000 - 00000000df6e0000
[    0.000000] PM: Registered nosave memory: 00000000df6e0000 - 00000000df700000
[    0.000000] PM: Registered nosave memory: 00000000df700000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000fff00000
[    0.000000] PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at df700000 (gap: df700000:1f700000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff8800df400000 s77440 r8192 d20864 u524288
[    0.000000] pcpu-alloc: s77440 r8192 d20864 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1029913
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=UUID=afafeaae-5b38-46d0-8bde-cf26eb46e29f ro quiet splash 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 4031296k/4718592k available (5637k kernel code, 534404k absent, 152892k reserved, 5242k data, 740k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 41943040 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2675.324 MHz processor.
[    0.003338] Calibrating delay loop (skipped), value calculated using timer frequency.. 5352.59 BogoMIPS (lpj=8917746)
[    0.003342] pid_max: default: 32768 minimum: 301
[    0.003362] Security Framework initialized
[    0.003378] AppArmor: AppArmor initialized
[    0.006760] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.008446] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.009187] Mount-cache hash table entries: 256
[    0.009328] Initializing cgroup subsys ns
[    0.009333] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.009335] Initializing cgroup subsys cpuacct
[    0.009339] Initializing cgroup subsys memory
[    0.009346] Initializing cgroup subsys devices
[    0.009348] Initializing cgroup subsys freezer
[    0.009350] Initializing cgroup subsys net_cls
[    0.009380] CPU: Physical Processor ID: 0
[    0.009382] CPU: Processor Core ID: 0
[    0.009383] mce: CPU supports 6 MCE banks
[    0.009390] CPU0: Thermal monitoring enabled (TM2)
[    0.009393] using mwait in idle threads.
[    0.009395] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.009402] ... version:                2
[    0.009403] ... bit width:              40
[    0.009405] ... generic registers:      2
[    0.009406] ... value mask:             000000ffffffffff
[    0.009408] ... max period:             000000007fffffff
[    0.009409] ... fixed-purpose events:   3
[    0.009410] ... event mask:             0000000700000003
[    0.010400] ACPI: Core revision 20101013
[    0.020009] ftrace: allocating 21108 entries in 83 pages
[    0.023385] Setting APIC routing to flat
[    0.023682] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.059797] CPU0: Intel(R) Core(TM)2 Quad CPU    Q8400  @ 2.66GHz stepping 0a
[    0.076686] Booting Node   0, Processors  #1 #2 #3 Ok.
[    0.380007] Brought up 4 CPUs
[    0.380011] Total of 4 processors activated (21412.93 BogoMIPS).
[    0.381203] devtmpfs: initialized
[    0.381203] regulator: core version 0.5
[    0.381203] regulator: dummy: 
[    0.381203] Time: 12:59:48  Date: 12/20/10
[    0.381203] NET: Registered protocol family 16
[    0.381203] ACPI: bus type pci registered
[    0.381203] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.381203] PCI: not using MMCONFIG
[    0.381203] PCI: Using configuration type 1 for base access
[    0.381466] bio: create slab <bio-0> at 0
[    0.384704] ACPI: EC: Look up EC in DSDT
[    0.386317] ACPI: Executed 1 blocks of module-level executable AML code
[    0.391197] ACPI: SSDT 00000000df6a00f0 001D2 (v01    AMI   CPU1PM 00000001 INTL 20060113)
[    0.391549] ACPI: Dynamic OEM Table Load:
[    0.391552] ACPI: SSDT           (null) 001D2 (v01    AMI   CPU1PM 00000001 INTL 20060113)
[    0.391800] ACPI: SSDT 00000000df6a02d0 00143 (v01    AMI   CPU2PM 00000001 INTL 20060113)
[    0.392150] ACPI: Dynamic OEM Table Load:
[    0.392153] ACPI: SSDT           (null) 00143 (v01    AMI   CPU2PM 00000001 INTL 20060113)
[    0.392400] ACPI: SSDT 00000000df6a0420 00143 (v01    AMI   CPU3PM 00000001 INTL 20060113)
[    0.392750] ACPI: Dynamic OEM Table Load:
[    0.392753] ACPI: SSDT           (null) 00143 (v01    AMI   CPU3PM 00000001 INTL 20060113)
[    0.393000] ACPI: SSDT 00000000df6a0570 00143 (v01    AMI   CPU4PM 00000001 INTL 20060113)
[    0.393367] ACPI: Dynamic OEM Table Load:
[    0.393370] ACPI: SSDT           (null) 00143 (v01    AMI   CPU4PM 00000001 INTL 20060113)
[    0.393595] ACPI: Interpreter enabled
[    0.393598] ACPI: (supports S0 S1 S3 S4 S5)
[    0.393616] ACPI: Using IOAPIC for interrupt routing
[    0.393643] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.394904] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in ACPI motherboard resources
[    0.409870] ACPI: No dock devices found.
[    0.409873] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.409953] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.410127] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.410129] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.410132] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.410134] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
[    0.410136] pci_root PNP0A08:00: host bridge window [mem 0xdf700000-0xffffffff]
[    0.410147] pci 0000:00:00.0: [8086:29c0] type 0 class 0x000600
[    0.410182] pci 0000:00:02.0: [8086:29c2] type 0 class 0x000300
[    0.410190] pci 0000:00:02.0: reg 10: [mem 0xfe980000-0xfe9fffff]
[    0.410196] pci 0000:00:02.0: reg 14: [io  0xcc00-0xcc07]
[    0.410200] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff pref]
[    0.410205] pci 0000:00:02.0: reg 1c: [mem 0xfe800000-0xfe8fffff]
[    0.410257] pci 0000:00:1b.0: [8086:27d8] type 0 class 0x000403
[    0.410270] pci 0000:00:1b.0: reg 10: [mem 0xfe978000-0xfe97bfff 64bit]
[    0.410317] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.410321] pci 0000:00:1b.0: PME# disabled
[    0.410337] pci 0000:00:1c.0: [8086:27d0] type 1 class 0x000604
[    0.410385] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.410388] pci 0000:00:1c.0: PME# disabled
[    0.410406] pci 0000:00:1c.1: [8086:27d2] type 1 class 0x000604
[    0.410453] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.410456] pci 0000:00:1c.1: PME# disabled
[    0.410477] pci 0000:00:1d.0: [8086:27c8] type 0 class 0x000c03
[    0.410511] pci 0000:00:1d.0: reg 20: [io  0xc400-0xc41f]
[    0.410537] pci 0000:00:1d.1: [8086:27c9] type 0 class 0x000c03
[    0.410572] pci 0000:00:1d.1: reg 20: [io  0xc480-0xc49f]
[    0.410597] pci 0000:00:1d.2: [8086:27ca] type 0 class 0x000c03
[    0.410631] pci 0000:00:1d.2: reg 20: [io  0xc800-0xc81f]
[    0.410657] pci 0000:00:1d.3: [8086:27cb] type 0 class 0x000c03
[    0.410691] pci 0000:00:1d.3: reg 20: [io  0xc880-0xc89f]
[    0.410726] pci 0000:00:1d.7: [8086:27cc] type 0 class 0x000c03
[    0.410743] pci 0000:00:1d.7: reg 10: [mem 0xfe977c00-0xfe977fff]
[    0.410803] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.410807] pci 0000:00:1d.7: PME# disabled
[    0.410822] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    0.410871] pci 0000:00:1f.0: [8086:27b8] type 0 class 0x000601
[    0.410940] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
[    0.410943] pci 0000:00:1f.0: quirk: [io  0x0480-0x04bf] claimed by ICH6 GPIO
[    0.410947] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0294 (mask 0003)
[    0.410977] pci 0000:00:1f.1: [8086:27df] type 0 class 0x000101
[    0.410988] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    0.410997] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    0.411005] pci 0000:00:1f.1: reg 18: [io  0x08f0-0x08f7]
[    0.411013] pci 0000:00:1f.1: reg 1c: [io  0x08f8-0x08fb]
[    0.411021] pci 0000:00:1f.1: reg 20: [io  0xffa0-0xffaf]
[    0.411050] pci 0000:00:1f.2: [8086:27c0] type 0 class 0x000101
[    0.411062] pci 0000:00:1f.2: reg 10: [io  0xc080-0xc087]
[    0.411069] pci 0000:00:1f.2: reg 14: [io  0xc000-0xc003]
[    0.411076] pci 0000:00:1f.2: reg 18: [io  0xbc00-0xbc07]
[    0.411083] pci 0000:00:1f.2: reg 1c: [io  0xb880-0xb883]
[    0.411090] pci 0000:00:1f.2: reg 20: [io  0xb800-0xb80f]
[    0.411114] pci 0000:00:1f.2: PME# supported from D3hot
[    0.411117] pci 0000:00:1f.2: PME# disabled
[    0.411129] pci 0000:00:1f.3: [8086:27da] type 0 class 0x000c05
[    0.411174] pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
[    0.411236] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.411240] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.411244] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.411249] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.411298] pci 0000:01:00.0: [10ec:8136] type 0 class 0x000200
[    0.411313] pci 0000:01:00.0: reg 10: [io  0xd800-0xd8ff]
[    0.411339] pci 0000:01:00.0: reg 18: [mem 0xfdfff000-0xfdffffff 64bit pref]
[    0.411356] pci 0000:01:00.0: reg 20: [mem 0xfdfe0000-0xfdfeffff 64bit pref]
[    0.411367] pci 0000:01:00.0: reg 30: [mem 0xfeaf0000-0xfeafffff pref]
[    0.411403] pci 0000:01:00.0: supports D1 D2
[    0.411404] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.411409] pci 0000:01:00.0: PME# disabled
[    0.416684] pci 0000:00:1c.1: PCI bridge to [bus 01-01]
[    0.416688] pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
[    0.416692] pci 0000:00:1c.1:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.416699] pci 0000:00:1c.1:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
[    0.416731] pci 0000:03:00.0: [1814:0301] type 0 class 0x000280
[    0.416748] pci 0000:03:00.0: reg 10: [mem 0xfebf8000-0xfebfffff]
[    0.416846] pci 0000:03:01.0: [1412:1724] type 0 class 0x000401
[    0.416861] pci 0000:03:01.0: reg 10: [io  0xec00-0xec1f]
[    0.416870] pci 0000:03:01.0: reg 14: [io  0xe880-0xe8ff]
[    0.416922] pci 0000:03:01.0: supports D2
[    0.416961] pci 0000:00:1e.0: PCI bridge to [bus 03-03] (subtractive decode)
[    0.416964] pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
[    0.416968] pci 0000:00:1e.0:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.416973] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.416975] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.416978] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.416980] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.416982] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.416984] pci 0000:00:1e.0:   bridge window [mem 0xdf700000-0xffffffff] (subtractive decode)
[    0.416998] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.417074] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.417124] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.417152] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    0.421881] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.421932] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.421981] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.422030] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.422078] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.422127] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.422177] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.422226] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.422253] HEST: Table is not found!
[    0.422309] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.422319] vgaarb: loaded
[    0.422423] SCSI subsystem initialized
[    0.422433] libata version 3.00 loaded.
[    0.422433] usbcore: registered new interface driver usbfs
[    0.422433] usbcore: registered new interface driver hub
[    0.422433] usbcore: registered new device driver usb
[    0.422433] wmi: Mapper loaded
[    0.422433] PCI: Using ACPI for IRQ routing
[    0.422433] PCI: pci_cache_line_size set to 64 bytes
[    0.422433] reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
[    0.422433] reserve RAM buffer: 00000000df690000 - 00000000dfffffff 
[    0.422433] NetLabel: Initializing
[    0.422433] NetLabel:  domain hash size = 128
[    0.422433] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.422433] NetLabel:  unlabeled traffic allowed by default
[    0.422433] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.422433] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.422433] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.433351] Switching to clocksource tsc
[    0.440359] AppArmor: AppArmor Filesystem Enabled
[    0.440376] pnp: PnP ACPI init
[    0.440397] ACPI: bus type pnp registered
[    0.440515] pnp 00:00: [bus 00-ff]
[    0.440517] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.440519] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.440521] pnp 00:00: [io  0x0d00-0xffff window]
[    0.440523] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.440526] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[    0.440528] pnp 00:00: [mem 0xdf700000-0xffffffff window]
[    0.440588] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.440597] pnp 00:01: [mem 0xfed14000-0xfed19fff]
[    0.440645] pnp 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.440677] pnp 00:02: [dma 4]
[    0.440678] pnp 00:02: [io  0x0000-0x000f]
[    0.440680] pnp 00:02: [io  0x0081-0x0083]
[    0.440685] pnp 00:02: [io  0x0087]
[    0.440686] pnp 00:02: [io  0x0089-0x008b]
[    0.440688] pnp 00:02: [io  0x008f]
[    0.440690] pnp 00:02: [io  0x00c0-0x00df]
[    0.440714] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.440723] pnp 00:03: [io  0x0070-0x0071]
[    0.440734] pnp 00:03: [irq 8]
[    0.440760] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.440767] pnp 00:04: [io  0x0061]
[    0.440790] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.440798] pnp 00:05: [io  0x00f0-0x00ff]
[    0.440802] pnp 00:05: [irq 13]
[    0.440828] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.441332] pnp 00:06: [irq 7]
[    0.441335] pnp 00:06: [dma 3]
[    0.441337] pnp 00:06: [io  0x0378-0x037f]
[    0.441338] pnp 00:06: [io  0x0778-0x077f]
[    0.441471] pnp 00:06: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.441502] pnp 00:07: [io  0x0000-0xffffffffffffffff disabled]
[    0.441505] pnp 00:07: [io  0x0000-0xffffffffffffffff disabled]
[    0.441507] pnp 00:07: [io  0x0290-0x0297]
[    0.441547] pnp 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.441651] pnp 00:08: [io  0x0010-0x001f]
[    0.441653] pnp 00:08: [io  0x0022-0x003f]
[    0.441655] pnp 00:08: [io  0x0044-0x005f]
[    0.441657] pnp 00:08: [io  0x0062-0x0063]
[    0.441658] pnp 00:08: [io  0x0065-0x006f]
[    0.441660] pnp 00:08: [io  0x0072-0x007f]
[    0.441662] pnp 00:08: [io  0x0080]
[    0.441664] pnp 00:08: [io  0x0084-0x0086]
[    0.441665] pnp 00:08: [io  0x0088]
[    0.441667] pnp 00:08: [io  0x008c-0x008e]
[    0.441671] pnp 00:08: [io  0x0090-0x009f]
[    0.441673] pnp 00:08: [io  0x00a2-0x00bf]
[    0.441674] pnp 00:08: [io  0x00e0-0x00ef]
[    0.441676] pnp 00:08: [io  0x04d0-0x04d1]
[    0.441678] pnp 00:08: [io  0x0800-0x087f]
[    0.441680] pnp 00:08: [io  0x0000-0xffffffffffffffff disabled]
[    0.441682] pnp 00:08: [io  0x0480-0x04bf]
[    0.441684] pnp 00:08: [mem 0xfed1c000-0xfed1ffff]
[    0.441685] pnp 00:08: [mem 0xfed20000-0xfed8ffff]
[    0.441738] pnp 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.441805] pnp 00:09: [mem 0xfed00000-0xfed003ff]
[    0.441831] pnp 00:09: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.441888] pnp 00:0a: [mem 0xffb00000-0xffbfffff]
[    0.441890] pnp 00:0a: [mem 0xfff00000-0xffffffff]
[    0.441922] pnp 00:0a: Plug and Play ACPI device, IDs INT0800 (active)
[    0.441976] pnp 00:0b: [mem 0xffc00000-0xffefffff]
[    0.442015] pnp 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.442071] pnp 00:0c: [mem 0xfec00000-0xfec00fff]
[    0.442073] pnp 00:0c: [mem 0xfee00000-0xfee00fff]
[    0.442115] pnp 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.442141] pnp 00:0d: [io  0x0060]
[    0.442142] pnp 00:0d: [io  0x0064]
[    0.442147] pnp 00:0d: [irq 1]
[    0.442174] pnp 00:0d: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.442218] pnp 00:0e: [irq 12]
[    0.442249] pnp 00:0e: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
[    0.442505] pnp 00:0f: [irq 4]
[    0.442507] pnp 00:0f: [dma 0 disabled]
[    0.442509] pnp 00:0f: [io  0x03f8-0x03ff]
[    0.442566] pnp 00:0f: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.442605] pnp 00:10: [mem 0xf0000000-0xf3ffffff]
[    0.442648] pnp 00:10: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.442835] pnp 00:11: [mem 0x00000000-0x0009ffff]
[    0.442837] pnp 00:11: [mem 0x000c0000-0x000cffff]
[    0.442839] pnp 00:11: [mem 0x000e0000-0x000fffff]
[    0.442841] pnp 00:11: [mem 0x00100000-0xdf6fffff]
[    0.442843] pnp 00:11: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.442893] pnp 00:11: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.443016] pnp: PnP ACPI: found 18 devices
[    0.443018] ACPI: ACPI bus type pnp unregistered
[    0.443028] system 00:01: [mem 0xfed14000-0xfed19fff] has been reserved
[    0.443035] system 00:07: [io  0x0290-0x0297] has been reserved
[    0.443040] system 00:08: [io  0x04d0-0x04d1] has been reserved
[    0.443043] system 00:08: [io  0x0800-0x087f] has been reserved
[    0.443046] system 00:08: [io  0x0480-0x04bf] has been reserved
[    0.443049] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.443052] system 00:08: [mem 0xfed20000-0xfed8ffff] has been reserved
[    0.443057] system 00:0b: [mem 0xffc00000-0xffefffff] has been reserved
[    0.443062] system 00:0c: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.443065] system 00:0c: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.443071] system 00:10: [mem 0xf0000000-0xf3ffffff] has been reserved
[    0.443076] system 00:11: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.443079] system 00:11: [mem 0x000c0000-0x000cffff] has been reserved
[    0.443082] system 00:11: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.443085] system 00:11: [mem 0x00100000-0xdf6fffff] could not be reserved
[    0.449156] pci 0000:00:1c.0: BAR 14: assigned [mem 0xdf700000-0xdf8fffff]
[    0.449160] pci 0000:00:1c.0: BAR 15: assigned [mem 0xdf900000-0xdfafffff 64bit pref]
[    0.449163] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.449165] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.449168] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.449173] pci 0000:00:1c.0:   bridge window [mem 0xdf700000-0xdf8fffff]
[    0.449177] pci 0000:00:1c.0:   bridge window [mem 0xdf900000-0xdfafffff 64bit pref]
[    0.449183] pci 0000:00:1c.1: PCI bridge to [bus 01-01]
[    0.449186] pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
[    0.449191] pci 0000:00:1c.1:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.449195] pci 0000:00:1c.1:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
[    0.449201] pci 0000:00:1e.0: PCI bridge to [bus 03-03]
[    0.449203] pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
[    0.449208] pci 0000:00:1e.0:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.449212] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.449221] pci 0000:00:1c.0: enabling device (0104 -> 0107)
[    0.449230] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.449234] pci 0000:00:1c.0: setting latency timer to 64
[    0.449241] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.449244] pci 0000:00:1c.1: setting latency timer to 64
[    0.449250] pci 0000:00:1e.0: setting latency timer to 64
[    0.449253] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.449255] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.449257] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.449259] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.449261] pci_bus 0000:00: resource 8 [mem 0xdf700000-0xffffffff]
[    0.449264] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    0.449266] pci_bus 0000:02: resource 1 [mem 0xdf700000-0xdf8fffff]
[    0.449268] pci_bus 0000:02: resource 2 [mem 0xdf900000-0xdfafffff 64bit pref]
[    0.449270] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.449272] pci_bus 0000:01: resource 1 [mem 0xfea00000-0xfeafffff]
[    0.449274] pci_bus 0000:01: resource 2 [mem 0xfdf00000-0xfdffffff 64bit pref]
[    0.449277] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
[    0.449278] pci_bus 0000:03: resource 1 [mem 0xfeb00000-0xfebfffff]
[    0.449281] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    0.449283] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    0.449284] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    0.449286] pci_bus 0000:03: resource 7 [mem 0x000d0000-0x000dffff]
[    0.449288] pci_bus 0000:03: resource 8 [mem 0xdf700000-0xffffffff]
[    0.449322] NET: Registered protocol family 2
[    0.449465] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.450530] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.453545] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.453913] TCP: Hash tables configured (established 524288 bind 65536)
[    0.453916] TCP reno registered
[    0.453924] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.453956] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.454082] NET: Registered protocol family 1
[    0.454100] pci 0000:00:02.0: Boot video device
[    0.454201] PCI: CLS 32 bytes, default 64
[    0.454253] Trying to unpack rootfs image as initramfs...
[    0.704154] Freeing initrd memory: 14536k freed
[    0.708381] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.708385] Placing 64MB software IO TLB between ffff8800db400000 - ffff8800df400000
[    0.708387] software IO TLB at phys 0xdb400000 - 0xdf400000
[    0.708714] Scanning for low memory corruption every 60 seconds
[    0.708847] audit: initializing netlink socket (disabled)
[    0.708859] type=2000 audit(1292849987.706:1): initialized
[    0.715261] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.717430] fuse init (API version 7.15)
[    0.717503] msgmni has been set to 7902
[    0.717816] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.717819] io scheduler noop registered
[    0.717820] io scheduler deadline registered
[    0.717852] io scheduler cfq registered (default)
[    0.718054] intel_idle: MWAIT substates: 0x22220
[    0.718056] intel_idle: does not run on family 6 model 23
[    0.718141] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.718145] ACPI: Power Button [PWRB]
[    0.718186] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.718189] ACPI: Power Button [PWRF]
[    0.718329] ACPI: acpi_idle registered with cpuidle
[    0.720574] ERST: Table is not found!
[    0.720730] Linux agpgart interface v0.103
[    0.720749] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.741220] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.830673] 00:0f: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.854342] brd: module loaded
[    0.854801] loop: module loaded
[    0.854937] ata_piix 0000:00:1f.1: version 2.13
[    0.854954] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.854981] ata_piix 0000:00:1f.1: setting latency timer to 64
[    0.855275] scsi0 : ata_piix
[    0.855376] scsi1 : ata_piix
[    0.856265] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    0.856267] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    0.856291] ata_piix 0000:00:1f.2: PCI INT B -> GSI 23 (level, low) -> IRQ 23
[    0.856296] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    0.856333] ata_piix 0000:00:1f.2: setting latency timer to 64
[    0.856627] scsi2 : ata_piix
[    0.856724] scsi3 : ata_piix
[    0.857751] ata3: SATA max UDMA/133 cmd 0xc080 ctl 0xc000 bmdma 0xb800 irq 23
[    0.857754] ata4: SATA max UDMA/133 cmd 0xbc00 ctl 0xb880 bmdma 0xb808 irq 23
[    0.858037] Fixed MDIO Bus: probed
[    0.858063] PPP generic driver version 2.4.2
[    0.858099] tun: Universal TUN/TAP device driver, 1.6
[    0.858100] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.858173] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.858187] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.858215] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.858218] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.858257] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    0.869974] ehci_hcd 0000:00:1d.7: using broken periodic workaround
[    0.869984] ehci_hcd 0000:00:1d.7: debug port 1
[    0.873875] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    0.873880] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfe977c00
[    0.886620] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.886747] hub 1-0:1.0: USB hub found
[    0.886753] hub 1-0:1.0: 8 ports detected
[    0.886838] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.886848] uhci_hcd: USB Universal Host Controller Interface driver
[    0.886894] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.886899] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.886901] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.886931] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.899968] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000c400
[    0.900094] hub 2-0:1.0: USB hub found
[    0.900099] hub 2-0:1.0: 2 ports detected
[    0.900172] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.900177] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.900180] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.900210] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    0.913306] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000c480
[    0.913430] hub 3-0:1.0: USB hub found
[    0.913435] hub 3-0:1.0: 2 ports detected
[    0.913503] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.913508] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.913511] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.913546] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    0.926625] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000c800
[    0.926750] hub 4-0:1.0: USB hub found
[    0.926755] hub 4-0:1.0: 2 ports detected
[    0.926825] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    0.926830] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    0.926833] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    0.926864] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    0.939946] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000c880
[    0.940076] hub 5-0:1.0: USB hub found
[    0.940080] hub 5-0:1.0: 2 ports detected
[    0.953284] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    0.955979] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.955991] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.956100] mice: PS/2 mouse device common for all mice
[    0.956199] rtc_cmos 00:03: RTC can wake from S4
[    0.972439] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.972462] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.972593] device-mapper: uevent: version 1.0.3
[    0.972714] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initialised: dm-devel@redhat.com
[    0.972809] device-mapper: multipath: version 1.1.1 loaded
[    0.972811] device-mapper: multipath round-robin: version 1.0.0 loaded
[    0.972980] cpuidle: using governor ladder
[    0.972982] cpuidle: using governor menu
[    0.973248] TCP cubic registered
[    0.973352] NET: Registered protocol family 10
[    0.973676] lo: Disabled Privacy Extensions
[    0.973892] NET: Registered protocol family 17
[    0.973907] Registering the dns_resolver key type
[    0.974596] PM: Hibernation image not present or could not be loaded.
[    0.974607] registered taskstats version 1
[    0.974804]   Magic number: 6:255:987
[    0.974886] rtc_cmos 00:03: setting system clock to 2010-12-20 12:59:48 UTC (1292849988)
[    0.974894] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.974895] EDD information not available.
[    0.976990] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    1.012429] ata4.01: NODEV after polling detection
[    1.019080] ata4.00: ATAPI: PIONEER DVD-RW  DVR-217F, 1.07, max UDMA/66
[    1.031072] ata3.00: ATA-8: Hitachi HDT721010SLA360, ST6OA31B, max UDMA/133
[    1.031074] ata3.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    1.032413] ata4.00: configured for UDMA/66
[    1.040310] ata3.00: configured for UDMA/133
[    1.040426] scsi 2:0:0:0: Direct-Access     ATA      Hitachi HDT72101 ST6O PQ: 0 ANSI: 5
[    1.040557] sd 2:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    1.040576] sd 2:0:0:0: Attached scsi generic sg0 type 0
[    1.040623] sd 2:0:0:0: [sda] Write Protect is off
[    1.040626] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.040661] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.064275]  sda: sda1 sda2 < sda5 sda6 > sda3
[    1.064590] sd 2:0:0:0: [sda] Attached SCSI disk
[    1.095173] scsi 3:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-217F 1.07 PQ: 0 ANSI: 5
[    1.218603] sr0: scsi3-mmc drive: 16x/16x writer cd/rw xa/form2 cdda tray
[    1.218607] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.218704] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    1.218762] sr 3:0:0:0: Attached scsi generic sg1 type 5
[    1.218825] Freeing unused kernel memory: 740k freed
[    1.218988] Write protecting the kernel read-only data: 10240k
[    1.219179] Freeing unused kernel memory: 488k freed
[    1.219447] Freeing unused kernel memory: 1744k freed

--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.good"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.37-rc6-jv (root@automatix) (gcc version 4.4.5 (Ubuntu/Linaro 4.4.4-14ubuntu5) ) #1 SMP PREEMPT Mon Dec 20 13:21:56 GMT 2010
[    0.000000] Command line: root=UUID=afafeaae-5b38-46d0-8bde-cf26eb46e29f ro quiet splash 
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000df690000 (usable)
[    0.000000]  BIOS-e820: 00000000df690000 - 00000000df69e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000df69e000 - 00000000df6d0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000df6d0000 - 00000000df6de000 (reserved)
[    0.000000]  BIOS-e820: 00000000df6e0000 - 00000000df700000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: P5KPL-AM/System Product Name, BIOS 0603    08/20/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   1 base 000000000 mask F00000000 write-back
[    0.000000]   2 base 100000000 mask FE0000000 write-back
[    0.000000]   3 base 0DF700000 mask FFFF00000 uncachable
[    0.000000]   4 base 0DF800000 mask FFF800000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000df700000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xdf690 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000df690000
[    0.000000]  0000000000 - 00df600000 page 2M
[    0.000000]  00df600000 - 00df690000 page 4k
[    0.000000] kernel direct mapping tables up to df690000 @ 1fffa000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-0000000120000000
[    0.000000]  0100000000 - 0120000000 page 2M
[    0.000000] kernel direct mapping tables up to 120000000 @ df68a000-df690000
[    0.000000] RAMDISK: 371be000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000fb630 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000df690100 00054 (v01 A_M_I_ OEMXSDT  08001020 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000df690290 000F4 (v03 A_M_I_ OEMFACP  08001020 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000df6905c0 07C37 (v01  A0846 A0846000 00000000 INTL 20060113)
[    0.000000] ACPI: FACS 00000000df69e000 00040
[    0.000000] ACPI: APIC 00000000df690390 0006C (v01 A_M_I_ OEMAPIC  08001020 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000df690400 0003C (v01 A_M_I_ OEMMCFG  08001020 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000df69e040 00080 (v01 A_M_I_ AMI_OEM  08001020 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000df698200 00038 (v01 A_M_I_ OEMHPET  08001020 MSFT 00000097)
[    0.000000] ACPI: GSCI 00000000df69e0c0 02024 (v01 A_M_I_ GMCHSCI  08001020 MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000120000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000120000000
[    0.000000]   NODE_DATA [000000011fffd000 - 000000011fffffff]
[    0.000000]  [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff88011be00000-ffff88011f7fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00120000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000df690
[    0.000000]     0: 0x00100000 -> 0x00120000
[    0.000000] On node 0 totalpages: 1046047
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3921 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 896712 pages, LIFO batch:31
[    0.000000]   Normal zone: 1792 pages used for memmap
[    0.000000]   Normal zone: 129280 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000df690000 - 00000000df69e000
[    0.000000] PM: Registered nosave memory: 00000000df69e000 - 00000000df6d0000
[    0.000000] PM: Registered nosave memory: 00000000df6d0000 - 00000000df6de000
[    0.000000] PM: Registered nosave memory: 00000000df6de000 - 00000000df6e0000
[    0.000000] PM: Registered nosave memory: 00000000df6e0000 - 00000000df700000
[    0.000000] PM: Registered nosave memory: 00000000df700000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000fff00000
[    0.000000] PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at df700000 (gap: df700000:1f700000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff8800df400000 s77440 r8192 d20864 u524288
[    0.000000] pcpu-alloc: s77440 r8192 d20864 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1029913
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=UUID=afafeaae-5b38-46d0-8bde-cf26eb46e29f ro quiet splash 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 4031296k/4718592k available (5637k kernel code, 534404k absent, 152892k reserved, 5242k data, 740k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 41943040 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2676.075 MHz processor.
[    0.003339] Calibrating delay loop (skipped), value calculated using timer frequency.. 5354.15 BogoMIPS (lpj=8920250)
[    0.003343] pid_max: default: 32768 minimum: 301
[    0.003363] Security Framework initialized
[    0.003379] AppArmor: AppArmor initialized
[    0.006762] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.008449] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.009190] Mount-cache hash table entries: 256
[    0.009332] Initializing cgroup subsys ns
[    0.009337] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.009339] Initializing cgroup subsys cpuacct
[    0.009343] Initializing cgroup subsys memory
[    0.009350] Initializing cgroup subsys devices
[    0.009352] Initializing cgroup subsys freezer
[    0.009354] Initializing cgroup subsys net_cls
[    0.009383] CPU: Physical Processor ID: 0
[    0.009385] CPU: Processor Core ID: 0
[    0.009387] mce: CPU supports 6 MCE banks
[    0.009393] CPU0: Thermal monitoring enabled (TM2)
[    0.009397] using mwait in idle threads.
[    0.009398] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.009406] ... version:                2
[    0.009407] ... bit width:              40
[    0.009409] ... generic registers:      2
[    0.009410] ... value mask:             000000ffffffffff
[    0.009412] ... max period:             000000007fffffff
[    0.009413] ... fixed-purpose events:   3
[    0.009414] ... event mask:             0000000700000003
[    0.010401] ACPI: Core revision 20101013
[    0.020009] ftrace: allocating 21108 entries in 83 pages
[    0.023386] Setting APIC routing to flat
[    0.023682] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.059413] CPU0: Intel(R) Core(TM)2 Quad CPU    Q8400  @ 2.66GHz stepping 0a
[    0.076686] Booting Node   0, Processors  #1 #2 #3 Ok.
[    0.380007] Brought up 4 CPUs
[    0.380010] Total of 4 processors activated (21414.52 BogoMIPS).
[    0.381212] devtmpfs: initialized
[    0.381212] regulator: core version 0.5
[    0.381212] regulator: dummy: 
[    0.381212] Time: 13:45:05  Date: 12/20/10
[    0.381212] NET: Registered protocol family 16
[    0.381212] ACPI: bus type pci registered
[    0.381212] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.381212] PCI: not using MMCONFIG
[    0.381212] PCI: Using configuration type 1 for base access
[    0.381472] bio: create slab <bio-0> at 0
[    0.384715] ACPI: EC: Look up EC in DSDT
[    0.386327] ACPI: Executed 1 blocks of module-level executable AML code
[    0.390659] ACPI: SSDT 00000000df6a00f0 001D2 (v01    AMI   CPU1PM 00000001 INTL 20060113)
[    0.391011] ACPI: Dynamic OEM Table Load:
[    0.391014] ACPI: SSDT           (null) 001D2 (v01    AMI   CPU1PM 00000001 INTL 20060113)
[    0.391263] ACPI: SSDT 00000000df6a02d0 00143 (v01    AMI   CPU2PM 00000001 INTL 20060113)
[    0.391613] ACPI: Dynamic OEM Table Load:
[    0.391616] ACPI: SSDT           (null) 00143 (v01    AMI   CPU2PM 00000001 INTL 20060113)
[    0.391862] ACPI: SSDT 00000000df6a0420 00143 (v01    AMI   CPU3PM 00000001 INTL 20060113)
[    0.392213] ACPI: Dynamic OEM Table Load:
[    0.392216] ACPI: SSDT           (null) 00143 (v01    AMI   CPU3PM 00000001 INTL 20060113)
[    0.392461] ACPI: SSDT 00000000df6a0570 00143 (v01    AMI   CPU4PM 00000001 INTL 20060113)
[    0.392813] ACPI: Dynamic OEM Table Load:
[    0.392816] ACPI: SSDT           (null) 00143 (v01    AMI   CPU4PM 00000001 INTL 20060113)
[    0.393041] ACPI: Interpreter enabled
[    0.393045] ACPI: (supports S0 S1 S3 S4 S5)
[    0.393062] ACPI: Using IOAPIC for interrupt routing
[    0.393088] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.394383] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in ACPI motherboard resources
[    0.409325] ACPI: No dock devices found.
[    0.409328] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.409407] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.409569] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.409571] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.409574] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.409576] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
[    0.409578] pci_root PNP0A08:00: host bridge window [mem 0xdf700000-0xffffffff]
[    0.409588] pci 0000:00:00.0: [8086:29c0] type 0 class 0x000600
[    0.409624] pci 0000:00:02.0: [8086:29c2] type 0 class 0x000300
[    0.409632] pci 0000:00:02.0: reg 10: [mem 0xfe980000-0xfe9fffff]
[    0.409637] pci 0000:00:02.0: reg 14: [io  0xcc00-0xcc07]
[    0.409642] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff pref]
[    0.409647] pci 0000:00:02.0: reg 1c: [mem 0xfe800000-0xfe8fffff]
[    0.409699] pci 0000:00:1b.0: [8086:27d8] type 0 class 0x000403
[    0.409712] pci 0000:00:1b.0: reg 10: [mem 0xfe978000-0xfe97bfff 64bit]
[    0.409758] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.409762] pci 0000:00:1b.0: PME# disabled
[    0.409779] pci 0000:00:1c.0: [8086:27d0] type 1 class 0x000604
[    0.409826] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.409829] pci 0000:00:1c.0: PME# disabled
[    0.409847] pci 0000:00:1c.1: [8086:27d2] type 1 class 0x000604
[    0.409894] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.409897] pci 0000:00:1c.1: PME# disabled
[    0.409928] pci 0000:00:1d.0: [8086:27c8] type 0 class 0x000c03
[    0.409973] pci 0000:00:1d.0: reg 20: [io  0xc400-0xc41f]
[    0.410008] pci 0000:00:1d.1: [8086:27c9] type 0 class 0x000c03
[    0.410043] pci 0000:00:1d.1: reg 20: [io  0xc480-0xc49f]
[    0.410068] pci 0000:00:1d.2: [8086:27ca] type 0 class 0x000c03
[    0.410103] pci 0000:00:1d.2: reg 20: [io  0xc800-0xc81f]
[    0.410128] pci 0000:00:1d.3: [8086:27cb] type 0 class 0x000c03
[    0.410162] pci 0000:00:1d.3: reg 20: [io  0xc880-0xc89f]
[    0.410197] pci 0000:00:1d.7: [8086:27cc] type 0 class 0x000c03
[    0.410213] pci 0000:00:1d.7: reg 10: [mem 0xfe977c00-0xfe977fff]
[    0.410274] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.410278] pci 0000:00:1d.7: PME# disabled
[    0.410293] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    0.410341] pci 0000:00:1f.0: [8086:27b8] type 0 class 0x000601
[    0.410410] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
[    0.410414] pci 0000:00:1f.0: quirk: [io  0x0480-0x04bf] claimed by ICH6 GPIO
[    0.410417] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0294 (mask 0003)
[    0.410448] pci 0000:00:1f.1: [8086:27df] type 0 class 0x000101
[    0.410459] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    0.410467] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    0.410475] pci 0000:00:1f.1: reg 18: [io  0x08f0-0x08f7]
[    0.410483] pci 0000:00:1f.1: reg 1c: [io  0x08f8-0x08fb]
[    0.410491] pci 0000:00:1f.1: reg 20: [io  0xffa0-0xffaf]
[    0.410520] pci 0000:00:1f.2: [8086:27c0] type 0 class 0x000101
[    0.410532] pci 0000:00:1f.2: reg 10: [io  0xc080-0xc087]
[    0.410539] pci 0000:00:1f.2: reg 14: [io  0xc000-0xc003]
[    0.410546] pci 0000:00:1f.2: reg 18: [io  0xbc00-0xbc07]
[    0.410553] pci 0000:00:1f.2: reg 1c: [io  0xb880-0xb883]
[    0.410560] pci 0000:00:1f.2: reg 20: [io  0xb800-0xb80f]
[    0.410584] pci 0000:00:1f.2: PME# supported from D3hot
[    0.410587] pci 0000:00:1f.2: PME# disabled
[    0.410599] pci 0000:00:1f.3: [8086:27da] type 0 class 0x000c05
[    0.410644] pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
[    0.410705] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.410709] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.410713] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.410718] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.410766] pci 0000:01:00.0: [10ec:8136] type 0 class 0x000200
[    0.410782] pci 0000:01:00.0: reg 10: [io  0xd800-0xd8ff]
[    0.410808] pci 0000:01:00.0: reg 18: [mem 0xfdfff000-0xfdffffff 64bit pref]
[    0.410824] pci 0000:01:00.0: reg 20: [mem 0xfdfe0000-0xfdfeffff 64bit pref]
[    0.410836] pci 0000:01:00.0: reg 30: [mem 0xfeaf0000-0xfeafffff pref]
[    0.410871] pci 0000:01:00.0: supports D1 D2
[    0.410873] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.410878] pci 0000:01:00.0: PME# disabled
[    0.416683] pci 0000:00:1c.1: PCI bridge to [bus 01-01]
[    0.416688] pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
[    0.416692] pci 0000:00:1c.1:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.416699] pci 0000:00:1c.1:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
[    0.416730] pci 0000:03:00.0: [1814:0301] type 0 class 0x000280
[    0.416748] pci 0000:03:00.0: reg 10: [mem 0xfebf8000-0xfebfffff]
[    0.416840] pci 0000:03:01.0: [1412:1724] type 0 class 0x000401
[    0.416855] pci 0000:03:01.0: reg 10: [io  0xec00-0xec1f]
[    0.416864] pci 0000:03:01.0: reg 14: [io  0xe880-0xe8ff]
[    0.416916] pci 0000:03:01.0: supports D2
[    0.416954] pci 0000:00:1e.0: PCI bridge to [bus 03-03] (subtractive decode)
[    0.416958] pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
[    0.416961] pci 0000:00:1e.0:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.416966] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.416969] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.416971] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.416973] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.416975] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.416978] pci 0000:00:1e.0:   bridge window [mem 0xdf700000-0xffffffff] (subtractive decode)
[    0.416992] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.417067] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.417119] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.417146] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    0.421886] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.421937] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.421985] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.422034] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.422082] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.422131] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.422182] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.422232] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.422258] HEST: Table is not found!
[    0.422313] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.422324] vgaarb: loaded
[    0.422427] SCSI subsystem initialized
[    0.422438] libata version 3.00 loaded.
[    0.422438] usbcore: registered new interface driver usbfs
[    0.422438] usbcore: registered new interface driver hub
[    0.422438] usbcore: registered new device driver usb
[    0.422438] wmi: Mapper loaded
[    0.422438] PCI: Using ACPI for IRQ routing
[    0.422438] PCI: pci_cache_line_size set to 64 bytes
[    0.422438] reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
[    0.422438] reserve RAM buffer: 00000000df690000 - 00000000dfffffff 
[    0.422438] NetLabel: Initializing
[    0.422438] NetLabel:  domain hash size = 128
[    0.422438] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.422438] NetLabel:  unlabeled traffic allowed by default
[    0.422438] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.422438] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.422438] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.433351] Switching to clocksource tsc
[    0.440371] AppArmor: AppArmor Filesystem Enabled
[    0.440388] pnp: PnP ACPI init
[    0.440409] ACPI: bus type pnp registered
[    0.440526] pnp 00:00: [bus 00-ff]
[    0.440528] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.440531] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.440533] pnp 00:00: [io  0x0d00-0xffff window]
[    0.440535] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.440537] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[    0.440539] pnp 00:00: [mem 0xdf700000-0xffffffff window]
[    0.440600] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.440609] pnp 00:01: [mem 0xfed14000-0xfed19fff]
[    0.440656] pnp 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.440688] pnp 00:02: [dma 4]
[    0.440690] pnp 00:02: [io  0x0000-0x000f]
[    0.440692] pnp 00:02: [io  0x0081-0x0083]
[    0.440697] pnp 00:02: [io  0x0087]
[    0.440698] pnp 00:02: [io  0x0089-0x008b]
[    0.440700] pnp 00:02: [io  0x008f]
[    0.440701] pnp 00:02: [io  0x00c0-0x00df]
[    0.440725] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.440735] pnp 00:03: [io  0x0070-0x0071]
[    0.440745] pnp 00:03: [irq 8]
[    0.440771] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.440779] pnp 00:04: [io  0x0061]
[    0.440802] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.440810] pnp 00:05: [io  0x00f0-0x00ff]
[    0.440814] pnp 00:05: [irq 13]
[    0.440840] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.441342] pnp 00:06: [irq 7]
[    0.441345] pnp 00:06: [dma 3]
[    0.441347] pnp 00:06: [io  0x0378-0x037f]
[    0.441349] pnp 00:06: [io  0x0778-0x077f]
[    0.441481] pnp 00:06: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.441512] pnp 00:07: [io  0x0000-0xffffffffffffffff disabled]
[    0.441514] pnp 00:07: [io  0x0000-0xffffffffffffffff disabled]
[    0.441516] pnp 00:07: [io  0x0290-0x0297]
[    0.441556] pnp 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.441660] pnp 00:08: [io  0x0010-0x001f]
[    0.441662] pnp 00:08: [io  0x0022-0x003f]
[    0.441664] pnp 00:08: [io  0x0044-0x005f]
[    0.441666] pnp 00:08: [io  0x0062-0x0063]
[    0.441667] pnp 00:08: [io  0x0065-0x006f]
[    0.441669] pnp 00:08: [io  0x0072-0x007f]
[    0.441671] pnp 00:08: [io  0x0080]
[    0.441672] pnp 00:08: [io  0x0084-0x0086]
[    0.441674] pnp 00:08: [io  0x0088]
[    0.441676] pnp 00:08: [io  0x008c-0x008e]
[    0.441680] pnp 00:08: [io  0x0090-0x009f]
[    0.441681] pnp 00:08: [io  0x00a2-0x00bf]
[    0.441683] pnp 00:08: [io  0x00e0-0x00ef]
[    0.441685] pnp 00:08: [io  0x04d0-0x04d1]
[    0.441687] pnp 00:08: [io  0x0800-0x087f]
[    0.441688] pnp 00:08: [io  0x0000-0xffffffffffffffff disabled]
[    0.441690] pnp 00:08: [io  0x0480-0x04bf]
[    0.441692] pnp 00:08: [mem 0xfed1c000-0xfed1ffff]
[    0.441694] pnp 00:08: [mem 0xfed20000-0xfed8ffff]
[    0.441746] pnp 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.441814] pnp 00:09: [mem 0xfed00000-0xfed003ff]
[    0.441840] pnp 00:09: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.441896] pnp 00:0a: [mem 0xffb00000-0xffbfffff]
[    0.441899] pnp 00:0a: [mem 0xfff00000-0xffffffff]
[    0.441930] pnp 00:0a: Plug and Play ACPI device, IDs INT0800 (active)
[    0.441984] pnp 00:0b: [mem 0xffc00000-0xffefffff]
[    0.442023] pnp 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.442078] pnp 00:0c: [mem 0xfec00000-0xfec00fff]
[    0.442081] pnp 00:0c: [mem 0xfee00000-0xfee00fff]
[    0.442123] pnp 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.442149] pnp 00:0d: [io  0x0060]
[    0.442150] pnp 00:0d: [io  0x0064]
[    0.442155] pnp 00:0d: [irq 1]
[    0.442183] pnp 00:0d: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.442226] pnp 00:0e: [irq 12]
[    0.442257] pnp 00:0e: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
[    0.442513] pnp 00:0f: [irq 4]
[    0.442515] pnp 00:0f: [dma 0 disabled]
[    0.442517] pnp 00:0f: [io  0x03f8-0x03ff]
[    0.442573] pnp 00:0f: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.442613] pnp 00:10: [mem 0xf0000000-0xf3ffffff]
[    0.442656] pnp 00:10: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.442843] pnp 00:11: [mem 0x00000000-0x0009ffff]
[    0.442845] pnp 00:11: [mem 0x000c0000-0x000cffff]
[    0.442847] pnp 00:11: [mem 0x000e0000-0x000fffff]
[    0.442849] pnp 00:11: [mem 0x00100000-0xdf6fffff]
[    0.442851] pnp 00:11: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.442901] pnp 00:11: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.443024] pnp: PnP ACPI: found 18 devices
[    0.443026] ACPI: ACPI bus type pnp unregistered
[    0.443035] system 00:01: [mem 0xfed14000-0xfed19fff] has been reserved
[    0.443042] system 00:07: [io  0x0290-0x0297] has been reserved
[    0.443047] system 00:08: [io  0x04d0-0x04d1] has been reserved
[    0.443050] system 00:08: [io  0x0800-0x087f] has been reserved
[    0.443053] system 00:08: [io  0x0480-0x04bf] has been reserved
[    0.443056] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.443059] system 00:08: [mem 0xfed20000-0xfed8ffff] has been reserved
[    0.443065] system 00:0b: [mem 0xffc00000-0xffefffff] has been reserved
[    0.443070] system 00:0c: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.443073] system 00:0c: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.443078] system 00:10: [mem 0xf0000000-0xf3ffffff] has been reserved
[    0.443083] system 00:11: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.443086] system 00:11: [mem 0x000c0000-0x000cffff] has been reserved
[    0.443089] system 00:11: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.443092] system 00:11: [mem 0x00100000-0xdf6fffff] could not be reserved
[    0.449176] pci 0000:00:1c.0: BAR 14: assigned [mem 0xdf700000-0xdf8fffff]
[    0.449180] pci 0000:00:1c.0: BAR 15: assigned [mem 0xdf900000-0xdfafffff 64bit pref]
[    0.449183] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.449186] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.449189] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.449194] pci 0000:00:1c.0:   bridge window [mem 0xdf700000-0xdf8fffff]
[    0.449198] pci 0000:00:1c.0:   bridge window [mem 0xdf900000-0xdfafffff 64bit pref]
[    0.449203] pci 0000:00:1c.1: PCI bridge to [bus 01-01]
[    0.449206] pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
[    0.449211] pci 0000:00:1c.1:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.449215] pci 0000:00:1c.1:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
[    0.449221] pci 0000:00:1e.0: PCI bridge to [bus 03-03]
[    0.449224] pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
[    0.449228] pci 0000:00:1e.0:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.449232] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.449242] pci 0000:00:1c.0: enabling device (0104 -> 0107)
[    0.449251] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.449255] pci 0000:00:1c.0: setting latency timer to 64
[    0.449262] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.449265] pci 0000:00:1c.1: setting latency timer to 64
[    0.449271] pci 0000:00:1e.0: setting latency timer to 64
[    0.449274] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.449276] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.449278] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.449280] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.449282] pci_bus 0000:00: resource 8 [mem 0xdf700000-0xffffffff]
[    0.449285] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    0.449287] pci_bus 0000:02: resource 1 [mem 0xdf700000-0xdf8fffff]
[    0.449289] pci_bus 0000:02: resource 2 [mem 0xdf900000-0xdfafffff 64bit pref]
[    0.449291] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.449293] pci_bus 0000:01: resource 1 [mem 0xfea00000-0xfeafffff]
[    0.449295] pci_bus 0000:01: resource 2 [mem 0xfdf00000-0xfdffffff 64bit pref]
[    0.449298] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
[    0.449299] pci_bus 0000:03: resource 1 [mem 0xfeb00000-0xfebfffff]
[    0.449301] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    0.449303] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    0.449305] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    0.449307] pci_bus 0000:03: resource 7 [mem 0x000d0000-0x000dffff]
[    0.449309] pci_bus 0000:03: resource 8 [mem 0xdf700000-0xffffffff]
[    0.449343] NET: Registered protocol family 2
[    0.449487] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.450558] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.453586] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.453956] TCP: Hash tables configured (established 524288 bind 65536)
[    0.453958] TCP reno registered
[    0.453966] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.453999] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.454124] NET: Registered protocol family 1
[    0.454143] pci 0000:00:02.0: Boot video device
[    0.454243] PCI: CLS 32 bytes, default 64
[    0.454295] Trying to unpack rootfs image as initramfs...
[    0.704246] Freeing initrd memory: 14536k freed
[    0.708482] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.708486] Placing 64MB software IO TLB between ffff8800db400000 - ffff8800df400000
[    0.708488] software IO TLB at phys 0xdb400000 - 0xdf400000
[    0.708816] Scanning for low memory corruption every 60 seconds
[    0.708949] audit: initializing netlink socket (disabled)
[    0.708961] type=2000 audit(1292852704.706:1): initialized
[    0.715361] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.717524] fuse init (API version 7.15)
[    0.717596] msgmni has been set to 7902
[    0.717908] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.717911] io scheduler noop registered
[    0.717912] io scheduler deadline registered
[    0.717944] io scheduler cfq registered (default)
[    0.718147] intel_idle: MWAIT substates: 0x22220
[    0.718149] intel_idle: does not run on family 6 model 23
[    0.718235] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.718241] ACPI: Power Button [PWRB]
[    0.718281] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.718284] ACPI: Power Button [PWRF]
[    0.718424] ACPI: acpi_idle registered with cpuidle
[    0.720637] ERST: Table is not found!
[    0.720800] Linux agpgart interface v0.103
[    0.720819] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.741287] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.833961] 00:0f: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.857615] brd: module loaded
[    0.858072] loop: module loaded
[    0.858208] ata_piix 0000:00:1f.1: version 2.13
[    0.858224] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.858252] ata_piix 0000:00:1f.1: setting latency timer to 64
[    0.858539] scsi0 : ata_piix
[    0.858644] scsi1 : ata_piix
[    0.859531] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    0.859533] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    0.859558] ata_piix 0000:00:1f.2: PCI INT B -> GSI 23 (level, low) -> IRQ 23
[    0.859563] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    0.859601] ata_piix 0000:00:1f.2: setting latency timer to 64
[    0.859888] scsi2 : ata_piix
[    0.859985] scsi3 : ata_piix
[    0.861024] ata3: SATA max UDMA/133 cmd 0xc080 ctl 0xc000 bmdma 0xb800 irq 23
[    0.861027] ata4: SATA max UDMA/133 cmd 0xbc00 ctl 0xb880 bmdma 0xb808 irq 23
[    0.861312] Fixed MDIO Bus: probed
[    0.861338] PPP generic driver version 2.4.2
[    0.861375] tun: Universal TUN/TAP device driver, 1.6
[    0.861376] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.861450] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.861463] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.861492] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.861495] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.861534] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    0.873254] ehci_hcd 0000:00:1d.7: using broken periodic workaround
[    0.873264] ehci_hcd 0000:00:1d.7: debug port 1
[    0.877143] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    0.877148] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfe977c00
[    0.889899] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.890027] hub 1-0:1.0: USB hub found
[    0.890033] hub 1-0:1.0: 8 ports detected
[    0.890118] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.890129] uhci_hcd: USB Universal Host Controller Interface driver
[    0.890173] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.890178] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.890181] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.890211] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.903234] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000c400
[    0.903361] hub 2-0:1.0: USB hub found
[    0.903366] hub 2-0:1.0: 2 ports detected
[    0.903440] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.903444] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.903447] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.903477] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    0.919902] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000c480
[    0.920026] hub 3-0:1.0: USB hub found
[    0.920031] hub 3-0:1.0: 2 ports detected
[    0.920099] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.920104] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.920107] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.920142] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    0.936544] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000c800
[    0.936670] hub 4-0:1.0: USB hub found
[    0.936675] hub 4-0:1.0: 2 ports detected
[    0.936744] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    0.936750] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    0.936752] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    0.936783] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    0.953195] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000c880
[    0.953324] hub 5-0:1.0: USB hub found
[    0.953328] hub 5-0:1.0: 2 ports detected
[    0.969867] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    0.972558] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.972569] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.972677] mice: PS/2 mouse device common for all mice
[    0.972775] rtc_cmos 00:03: RTC can wake from S4
[    0.988448] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.988471] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.988602] device-mapper: uevent: version 1.0.3
[    0.988723] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initialised: dm-devel@redhat.com
[    0.988817] device-mapper: multipath: version 1.1.1 loaded
[    0.988819] device-mapper: multipath round-robin: version 1.0.0 loaded
[    0.988991] cpuidle: using governor ladder
[    0.988993] cpuidle: using governor menu
[    0.989252] TCP cubic registered
[    0.989353] NET: Registered protocol family 10
[    0.989677] lo: Disabled Privacy Extensions
[    0.989886] NET: Registered protocol family 17
[    0.989901] Registering the dns_resolver key type
[    0.990607] PM: Hibernation image not present or could not be loaded.
[    0.990617] registered taskstats version 1
[    0.990814]   Magic number: 6:155:787
[    0.990896] rtc_cmos 00:03: setting system clock to 2010-12-20 13:45:05 UTC (1292852705)
[    0.990904] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.990905] EDD information not available.
[    0.993252] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    1.015141] ata4.01: NODEV after polling detection
[    1.021789] ata4.00: ATAPI: PIONEER DVD-RW  DVR-217F, 1.07, max UDMA/66
[    1.033759] ata3.00: ATA-8: Hitachi HDT721010SLA360, ST6OA31B, max UDMA/133
[    1.033762] ata3.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    1.035122] ata4.00: configured for UDMA/66
[    1.046975] ata3.00: configured for UDMA/133
[    1.047092] scsi 2:0:0:0: Direct-Access     ATA      Hitachi HDT72101 ST6O PQ: 0 ANSI: 5
[    1.047222] sd 2:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    1.047241] sd 2:0:0:0: Attached scsi generic sg0 type 0
[    1.047289] sd 2:0:0:0: [sda] Write Protect is off
[    1.047291] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.047318] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.076255]  sda: sda1 sda2 < sda5 sda6 > sda3
[    1.076525] sd 2:0:0:0: [sda] Attached SCSI disk
[    1.098119] scsi 3:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-217F 1.07 PQ: 0 ANSI: 5
[    1.221509] sr0: scsi3-mmc drive: 16x/16x writer cd/rw xa/form2 cdda tray
[    1.221512] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.221609] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    1.221667] sr 3:0:0:0: Attached scsi generic sg1 type 5
[    1.221730] Freeing unused kernel memory: 740k freed
[    1.221893] Write protecting the kernel read-only data: 10240k
[    1.222082] Freeing unused kernel memory: 488k freed
[    1.222351] Freeing unused kernel memory: 1744k freed

--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=lspci

00:00.0 Host bridge: Intel Corporation 82G33/G31/P35/P31 Express DRAM Controller (rev 10)
	Subsystem: ASUSTeK Computer Inc. P5KPL-VM Motherboard
	Flags: bus master, fast devsel, latency 0
	Capabilities: [e0] Vendor Specific Information: Len=0b <?>
	Kernel driver in use: agpgart-intel
	Kernel modules: intel-agp

00:02.0 VGA compatible controller: Intel Corporation 82G33/G31 Express Integrated Graphics Controller (rev 10) (prog-if 00 [VGA controller])
	Subsystem: ASUSTeK Computer Inc. P5KPL-VM Motherboard
	Flags: bus master, fast devsel, latency 0, IRQ 41
	Memory at fe980000 (32-bit, non-prefetchable) [size=512K]
	I/O ports at cc00 [size=8]
	Memory at e0000000 (32-bit, prefetchable) [size=256M]
	Memory at fe800000 (32-bit, non-prefetchable) [size=1M]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [d0] Power Management version 2
	Kernel driver in use: i915
	Kernel modules: i915

00:1b.0 Audio device: Intel Corporation N10/ICH 7 Family High Definition Audio Controller (rev 01)
	Subsystem: ASUSTeK Computer Inc. P5KPL-CM Motherboard
	Flags: bus master, fast devsel, latency 0, IRQ 42
	Memory at fe978000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Capabilities: [70] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [100] Virtual Channel
	Capabilities: [130] Root Complex Link
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port 1 (rev 01) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: df700000-df8fffff
	Prefetchable memory behind bridge: 00000000df900000-00000000dfafffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 8179
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Root Complex Link

00:1c.1 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port 2 (rev 01) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fea00000-feafffff
	Prefetchable memory behind bridge: 00000000fdf00000-00000000fdffffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 8179
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Root Complex Link

00:1d.0 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #1 (rev 01) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. P5KPL-VM,P5LD2-VM Mainboard
	Flags: bus master, medium devsel, latency 0, IRQ 23
	I/O ports at c400 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #2 (rev 01) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. P5KPL-VM,P5LD2-VM Mainboard
	Flags: bus master, medium devsel, latency 0, IRQ 19
	I/O ports at c480 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #3 (rev 01) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. P5KPL-VM,P5LD2-VM Mainboard
	Flags: bus master, medium devsel, latency 0, IRQ 18
	I/O ports at c800 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.3 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #4 (rev 01) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. P5KPL-VM,P5LD2-VM Mainboard
	Flags: bus master, medium devsel, latency 0, IRQ 16
	I/O ports at c880 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation N10/ICH 7 Family USB2 EHCI Controller (rev 01) (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. P5KPL-VM,P5LD2-VM Mainboard
	Flags: bus master, medium devsel, latency 0, IRQ 23
	Memory at fe977c00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1) (prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=32
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: feb00000-febfffff
	Capabilities: [50] Subsystem: ASUSTeK Computer Inc. Device 8179

00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC Interface Bridge (rev 01)
	Subsystem: ASUSTeK Computer Inc. P5KPL-VM Motherboard
	Flags: bus master, medium devsel, latency 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>
	Kernel modules: leds-ss4200, iTCO_wdt, intel-rng

00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 01) (prog-if 8a [Master SecP PriP])
	Subsystem: ASUSTeK Computer Inc. P5KPL-VM Motherboard
	Flags: bus master, medium devsel, latency 0, IRQ 18
	I/O ports at 01f0 [size=8]
	I/O ports at 03f4 [size=1]
	I/O ports at 0170 [size=8]
	I/O ports at 0374 [size=1]
	I/O ports at ffa0 [size=16]
	Kernel driver in use: ata_piix

00:1f.2 IDE interface: Intel Corporation N10/ICH7 Family SATA IDE Controller (rev 01) (prog-if 8f [Master SecP SecO PriP PriO])
	Subsystem: ASUSTeK Computer Inc. P5KPL-VM Motherboard
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 23
	I/O ports at c080 [size=8]
	I/O ports at c000 [size=4]
	I/O ports at bc00 [size=8]
	I/O ports at b880 [size=4]
	I/O ports at b800 [size=16]
	Capabilities: [70] Power Management version 2
	Kernel driver in use: ata_piix

00:1f.3 SMBus: Intel Corporation N10/ICH 7 Family SMBus Controller (rev 01)
	Subsystem: ASUSTeK Computer Inc. P5KPL-VM Motherboard
	Flags: medium devsel, IRQ 11
	I/O ports at 0400 [size=32]
	Kernel modules: i2c-i801

01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
	Subsystem: ASUSTeK Computer Inc. Device 8347
	Flags: bus master, fast devsel, latency 0, IRQ 40
	I/O ports at d800 [size=256]
	Memory at fdfff000 (64-bit, prefetchable) [size=4K]
	Memory at fdfe0000 (64-bit, prefetchable) [size=64K]
	Expansion ROM at feaf0000 [disabled] [size=64K]
	Capabilities: [40] Power Management version 3
	Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Capabilities: [70] Express Endpoint, MSI 01
	Capabilities: [ac] MSI-X: Enable- Count=2 Masked-
	Capabilities: [cc] Vital Product Data
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Virtual Channel
	Capabilities: [160] Device Serial Number 00-00-00-00-00-00-00-00
	Kernel driver in use: r8169
	Kernel modules: r8169

03:00.0 Network controller: RaLink RT2561/RT61 802.11g PCI
	Subsystem: Edimax Computer Co. Device 7128
	Flags: bus master, slow devsel, latency 64, IRQ 19
	Memory at febf8000 (32-bit, non-prefetchable) [size=32K]
	Capabilities: [40] Power Management version 2
	Kernel driver in use: rt61pci
	Kernel modules: rt61pci

03:01.0 Multimedia audio controller: VIA Technologies Inc. VT1720/24 [Envy24PT/HT] PCI Multi-Channel Audio Controller (rev 01)
	Subsystem: VIA Technologies Inc. M-Audio Revolution 5.1
	Flags: bus master, medium devsel, latency 64, IRQ 16
	I/O ports at ec00 [size=32]
	I/O ports at e880 [size=128]
	Capabilities: [80] Power Management version 1
	Kernel driver in use: ICE1724
	Kernel modules: snd-ice1724


--UlVJffcvxoiEqYs2--
