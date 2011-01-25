Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab1AYMfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 07:35:50 -0500
Received: from mailout06.t-online.de ([194.25.134.19]:58519 "EHLO
	mailout06.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab1AYMfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 07:35:47 -0500
Message-ID: <4D3EC393.3010403@t-online.de>
Date: Tue, 25 Jan 2011 13:35:31 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: jesse.barnes@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [BUG/REGRESSION] DRM / i915 / 2.6.37 and 2.6.38-rc*: DVI output
 gets disabled/reenabled under load
References: <4D3DC997.5040605@t-online.de> <0d30dc$krk6f6@orsmga001.jf.intel.com> <4D3EB90C.9020901@t-online.de> <0d30dc$krt8da@orsmga001.jf.intel.com>
In-Reply-To: <0d30dc$krt8da@orsmga001.jf.intel.com>
Content-Type: multipart/mixed;
 boundary="------------060302090704010900070504"
X-ID: TW3hv8ZOYhja3BCoM1BocfitmTxX5rf2fdY646cB2mgCDgTfEa40KlO8EN2Sit5ZXD
X-TOI-MSGID: a840c553-456e-4123-a013-57bbd1e80972
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060302090704010900070504
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Am 25.01.2011 13:11, schrieb Chris Wilson:
>
>> LOG-2.6.38-rc2 is different. The kernel is a pure kernel 2.6.38-rc2 with one
>> exception: I changed  DRM_OUTPUT_POLL_PERIOD  to 3*HZ to increase
>> error probability.
>>
>> At log time [  678.598641]  you can see the status change of the VGA-2
>> connector (there is no physical VGA-2 connector on that mobo).
>>     
> I'm interested in knowing where the extra VGA-2 comes from. The only
> thing that comes to mind is a secondary function on the SDVO and knowing
> why that is unstable. Can you attach the complete drm.debug logs for
> 2.6.36 and 2.6.38 so I can see the initialisation order of the connectors.
>
>   

Attached find the startup logs. Both debuglevel 0xf.

Knut

--------------060302090704010900070504
Content-Type: text/plain;
 name="2.6.36.3.startup"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="2.6.36.3.startup"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.36.3-kape (knut@golem) (gcc version 4.5.0 20100604 [gcc-4_5-branch revision 160292] (SUSE Linux) ) #1 PREEMPT Sat Jan 22 07:26:54 CET 2011
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f7f0000 (usable)
[    0.000000]  BIOS-e820: 000000007f7f0000 - 000000007f7f3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007f7f3000 - 000000007f800000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] DMI 2.3 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x7f7f0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 07F800000 mask FFF800000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] initial memory mapped : 0 - 00c00000
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-c000
[    0.000000] RAMDISK: 3768e000 - 37ff0000
[    0.000000] Allocated new RAMDISK: 00698000 - 00ff902b
[    0.000000] Move RAMDISK from 000000003768e000 - 0000000037fef02a to 00698000 - 00ff902a
[    0.000000] ACPI: RSDP 000f9320 00014 (v00 AOpen )
[    0.000000] ACPI: RSDT 7f7f3040 00038 (v01 AOpen  AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: FACP 7f7f30c0 00074 (v01 AOpen  AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: DSDT 7f7f3180 042E3 (v01 AOPEN  AWRDACPI 00001000 MSFT 0100000E)
[    0.000000] ACPI: FACS 7f7f0000 00040
[    0.000000] ACPI: MCFG 7f7f7580 0003C (v01 AOpen  AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: APIC 7f7f74c0 0005A (v01 AOpen  AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: SSDT 7f7f7600 00222 (v01  PmRef  Cpu0Ist 00003000 INTL 20040311)
[    0.000000] ACPI: SSDT 7f7f7a00 000E0 (v01  PmRef    CpuPm 00003000 INTL 20040311)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1151MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0007f7f0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007f7f0
[    0.000000] On node 0 totalpages: 522126
[    0.000000] free_area_init_node: node 0, pgdat c05e7cd0, node_mem_map c1001020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3966 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2304 pages used for memmap
[    0.000000]   HighMem zone: 292594 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] nr_irqs_gsi: 40
[    0.000000] Allocating PCI resources starting at 7f800000 (gap: 7f800000:60800000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 518046
[    0.000000] Kernel command line: root=/dev/sdb5 drm.debug=0xf
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] early_res array is doubled to 64 at [1000 - 17ff]
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] allocated 10444460 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Subtract (32 early reservations)
[    0.000000]   #1 [0000100000 - 0000693068]   TEXT DATA BSS
[    0.000000]   #2 [000009f800 - 0000100000]   BIOS reserved
[    0.000000]   #3 [0000694000 - 00006970b6]             BRK
[    0.000000]   #4 [0000007000 - 0000008000]         PGTABLE
[    0.000000]   #5 [0000698000 - 0000ffa000]     NEW RAMDISK
[    0.000000]   #6 [0001000000 - 0001001000]         BOOTMEM
[    0.000000]   #7 [0001001000 - 0001ff1000]         BOOTMEM
[    0.000000]   #8 [0001ff1000 - 0001ff1004]         BOOTMEM
[    0.000000]   #9 [0001ff1040 - 0001ff10c0]         BOOTMEM
[    0.000000]   #10 [0001ff10c0 - 0001ff1114]         BOOTMEM
[    0.000000]   #11 [0001ff1140 - 0001ff3140]         BOOTMEM
[    0.000000]   #12 [0001ff3140 - 0001ff31ac]         BOOTMEM
[    0.000000]   #13 [0001ff31c0 - 0001ff71c0]         BOOTMEM
[    0.000000]   #14 [0001ff71c0 - 0001ff71e7]         BOOTMEM
[    0.000000]   #15 [0001ff7200 - 0001ff7334]         BOOTMEM
[    0.000000]   #16 [0001ff7340 - 0001ff7380]         BOOTMEM
[    0.000000]   #17 [0001ff7380 - 0001ff73c0]         BOOTMEM
[    0.000000]   #18 [0001ff73c0 - 0001ff7400]         BOOTMEM
[    0.000000]   #19 [0001ff7400 - 0001ff7440]         BOOTMEM
[    0.000000]   #20 [0001ff7440 - 0001ff7480]         BOOTMEM
[    0.000000]   #21 [0001ff7480 - 0001ff74c0]         BOOTMEM
[    0.000000]   #22 [0001ff74c0 - 0001ff7500]         BOOTMEM
[    0.000000]   #23 [0001ff7500 - 0001ff7540]         BOOTMEM
[    0.000000]   #24 [0001ff7540 - 0001ff7580]         BOOTMEM
[    0.000000]   #25 [0001ff7580 - 0001ff75c0]         BOOTMEM
[    0.000000]   #26 [0001ff75c0 - 0001ff75dd]         BOOTMEM
[    0.000000]   #27 [0001ff7600 - 0001ff761d]         BOOTMEM
[    0.000000]   #28 [0001ff7640 - 0001ffb640]         BOOTMEM
[    0.000000]   #29 [0001ffb640 - 000207b640]         BOOTMEM
[    0.000000]   #30 [000207b640 - 00020bb640]         BOOTMEM
[    0.000000]   #31 [00020bc000 - 0002ab1eac]         BOOTMEM
[    0.000000] Initializing HighMem for node 0 (000377fe:0007f7f0)
[    0.000000] Memory: 2045828k/2088896k available (3252k kernel code, 42676k reserved, 1785k data, 312k init, 1179592k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa3000 - 0xfffff000   ( 368 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc05ec000 - 0xc063a000   ( 312 kB)
[    0.000000]       .data : 0xc042d351 - 0xc05eb9a0   (1785 kB)
[    0.000000]       .text : 0xc0100000 - 0xc042d351   (3252 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:288
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1862.493 MHz processor.
[    0.008006] Calibrating delay loop (skipped), value calculated using timer frequency.. 3724.98 BogoMIPS (lpj=7449972)
[    0.008279] pid_max: default: 32768 minimum: 301
[    0.008457] Security Framework initialized
[    0.008602] AppArmor: AppArmor initialized
[    0.008751] Mount-cache hash table entries: 512
[    0.009022] Initializing cgroup subsys ns
[    0.009160] Initializing cgroup subsys cpuacct
[    0.009293] Initializing cgroup subsys memory
[    0.009433] Initializing cgroup subsys devices
[    0.009567] Initializing cgroup subsys freezer
[    0.012039] mce: CPU supports 5 MCE banks
[    0.012176] CPU0: Thermal monitoring enabled (TM2)
[    0.012318] Performance Events: p6 PMU driver.
[    0.012477] ... version:                0
[    0.012607] ... bit width:              32
[    0.012737] ... generic registers:      2
[    0.012867] ... value mask:             00000000ffffffff
[    0.013002] ... max period:             000000007fffffff
[    0.013137] ... fixed-purpose events:   0
[    0.013269] ... event mask:             0000000000000003
[    0.013402] CPU: Intel(R) Pentium(R) M processor 1.86GHz stepping 08
[    0.013920] ACPI: Core revision 20100702
[    0.024156] NMI watchdog enabled, takes one hw-pmu counter.
[    0.024318] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.024774] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.068000] NET: Registered protocol family 16
[    0.068000] ACPI: bus type pci registered
[    0.068000] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.068000] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.068000] PCI: Using MMCONFIG for extended config space
[    0.068000] PCI: Using configuration type 1 for base access
[    0.068000] bio: create slab <bio-0> at 0
[    0.068000] ACPI: EC: Look up EC in DSDT
[    0.073800] ACPI: Interpreter enabled
[    0.073934] ACPI: (supports S0 S5)
[    0.074117] ACPI: Using IOAPIC for interrupt routing
[    0.079607] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.079956] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.080202] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.080206] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.080210] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.080213] pci_root PNP0A08:00: host bridge window [mem 0x000c0000-0x000dffff] (ignored)
[    0.080217] pci_root PNP0A08:00: host bridge window [mem 0x7f800000-0xfebfffff] (ignored)
[    0.080275] pci 0000:00:02.0: reg 10: [mem 0xd2280000-0xd22fffff]
[    0.080282] pci 0000:00:02.0: reg 14: [io  0xe400-0xe407]
[    0.080289] pci 0000:00:02.0: reg 18: [mem 0xc0000000-0xcfffffff pref]
[    0.080295] pci 0000:00:02.0: reg 1c: [mem 0xd2300000-0xd233ffff]
[    0.080331] pci 0000:00:02.1: reg 10: [mem 0xd2200000-0xd227ffff]
[    0.080413] pci 0000:00:1b.0: reg 10: [mem 0xd2340000-0xd2343fff 64bit]
[    0.080466] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.080472] pci 0000:00:1b.0: PME# disabled
[    0.080540] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.080544] pci 0000:00:1c.0: PME# disabled
[    0.080613] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.080617] pci 0000:00:1c.1: PME# disabled
[    0.080688] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.080692] pci 0000:00:1c.2: PME# disabled
[    0.080761] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.080766] pci 0000:00:1c.3: PME# disabled
[    0.080822] pci 0000:00:1d.0: reg 20: [io  0xe000-0xe01f]
[    0.080886] pci 0000:00:1d.1: reg 20: [io  0xe100-0xe11f]
[    0.080951] pci 0000:00:1d.2: reg 20: [io  0xe200-0xe21f]
[    0.081015] pci 0000:00:1d.3: reg 20: [io  0xe300-0xe31f]
[    0.081064] pci 0000:00:1d.7: reg 10: [mem 0xd2344000-0xd23443ff]
[    0.081126] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.081131] pci 0000:00:1d.7: PME# disabled
[    0.081269] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.081276] pci 0000:00:1f.0: quirk: [io  0x4000-0x407f] claimed by ICH6 ACPI/GPIO/TCO
[    0.081517] pci 0000:00:1f.0: quirk: [io  0x4080-0x40bf] claimed by ICH6 GPIO
[    0.081660] pci 0000:00:1f.0: LPC Generic IO decode 1 PIO at 0280-02ff
[    0.081798] pci 0000:00:1f.0: LPC Generic IO decode 2 PIO at 1640-164f
[    0.081955] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    0.081965] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    0.081975] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
[    0.081984] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
[    0.081994] pci 0000:00:1f.1: reg 20: [io  0xf000-0xf00f]
[    0.082037] pci 0000:00:1f.2: reg 10: [io  0xe500-0xe507]
[    0.082045] pci 0000:00:1f.2: reg 14: [io  0xe600-0xe603]
[    0.082054] pci 0000:00:1f.2: reg 18: [io  0xe700-0xe707]
[    0.082063] pci 0000:00:1f.2: reg 1c: [io  0xe800-0xe803]
[    0.082071] pci 0000:00:1f.2: reg 20: [io  0xe900-0xe90f]
[    0.082080] pci 0000:00:1f.2: reg 24: [mem 0xd2345000-0xd23453ff]
[    0.082102] pci 0000:00:1f.2: PME# supported from D3hot
[    0.082106] pci 0000:00:1f.2: PME# disabled
[    0.082166] pci 0000:00:1f.3: reg 20: [io  0x5000-0x501f]
[    0.082234] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.082367] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.082372] pci 0000:00:1c.0:   bridge window [mem 0x00000000-0x000fffff] (disabled)
[    0.082379] pci 0000:00:1c.0:   bridge window [mem 0x00000000-0x000fffff pref] (disabled)
[    0.082459] pci 0000:02:00.0: reg 10: [mem 0xd2120000-0xd2123fff 64bit]
[    0.082472] pci 0000:02:00.0: reg 18: [io  0xb000-0xb0ff]
[    0.082515] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.082554] pci 0000:02:00.0: supports D1 D2
[    0.082556] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.082562] pci 0000:02:00.0: PME# disabled
[    0.082575] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.082822] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.082955] pci 0000:00:1c.1:   bridge window [io  0xb000-0xbfff]
[    0.082960] pci 0000:00:1c.1:   bridge window [mem 0xd2100000-0xd21fffff]
[    0.082966] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.083045] pci 0000:03:00.0: reg 10: [mem 0xd2020000-0xd2023fff 64bit]
[    0.083058] pci 0000:03:00.0: reg 18: [io  0xc000-0xc0ff]
[    0.083101] pci 0000:03:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.083140] pci 0000:03:00.0: supports D1 D2
[    0.083143] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.083148] pci 0000:03:00.0: PME# disabled
[    0.083161] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.083407] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
[    0.083542] pci 0000:00:1c.2:   bridge window [io  0xc000-0xcfff]
[    0.083547] pci 0000:00:1c.2:   bridge window [mem 0xd2000000-0xd20fffff]
[    0.083553] pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.083592] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
[    0.083728] pci 0000:00:1c.3:   bridge window [io  0xf000-0x0000] (disabled)
[    0.083733] pci 0000:00:1c.3:   bridge window [mem 0x00000000-0x000fffff] (disabled)
[    0.083740] pci 0000:00:1c.3:   bridge window [mem 0x00000000-0x000fffff pref] (disabled)
[    0.083789] pci 0000:05:03.0: reg 10: [mem 0xd1000000-0xd1000fff]
[    0.083853] pci 0000:05:03.0: supports D1 D2
[    0.083856] pci 0000:05:03.0: PME# supported from D0 D1 D2 D3hot
[    0.083861] pci 0000:05:03.0: PME# disabled
[    0.083885] pci 0000:05:04.0: reg 10: [io  0xd000-0xd03f]
[    0.084069] pci 0000:05:05.0: reg 10: [mem 0xd0000000-0xd0ffffff]
[    0.084157] pci 0000:00:1e.0: PCI bridge to [bus 05-05] (subtractive decode)
[    0.084299] pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
[    0.084303] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd1ffffff]
[    0.084310] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.084314] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    0.084317] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffff] (subtractive decode)
[    0.084339] pci_bus 0000:00: on NUMA node 0
[    0.084344] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.084513] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.084570] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[    0.084626] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
[    0.084682] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.084738] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.098907] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 7 9 10 11 12 14 15)
[    0.099381] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 11 *12 14 15)
[    0.099855] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 *10 11 12 14 15)
[    0.100332] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    0.100802] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 *9 10 11 12 14 15)
[    0.101273] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.101889] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.102504] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    0.103073] SCSI subsystem initialized
[    0.103235] libata version 3.00 loaded.
[    0.103272] usbcore: registered new interface driver usbfs
[    0.103425] usbcore: registered new interface driver hub
[    0.103585] usbcore: registered new device driver usb
[    0.103785] PCI: Using ACPI for IRQ routing
[    0.103917] PCI: pci_cache_line_size set to 64 bytes
[    0.104008] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
[    0.104011] reserve RAM buffer: 000000007f7f0000 - 000000007fffffff 
[    0.104225] hpet clockevent registered
[    0.104229] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.107344] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.107565] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.112038] Switching to clocksource tsc
[    0.112207] AppArmor: AppArmor Filesystem Enabled
[    0.112346] pnp: PnP ACPI init
[    0.112482] ACPI: bus type pnp registered
[    0.115490] pnp: PnP ACPI: found 14 devices
[    0.115623] ACPI: ACPI bus type pnp unregistered
[    0.115764] system 00:01: [io  0x0b78-0x0b7b] has been reserved
[    0.115902] system 00:01: [io  0x0f78-0x0f7b] has been reserved
[    0.115902] system 00:01: [io  0x0a78-0x0a7b] has been reserved
[    0.116019] system 00:01: [io  0x0e78-0x0e7b] has been reserved
[    0.116156] system 00:01: [io  0x0bbc-0x0bbf] has been reserved
[    0.116294] system 00:01: [io  0x0fbc-0x0fbf] has been reserved
[    0.116431] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.116568] system 00:01: [io  0x0290-0x0297] has been reserved
[    0.116707] system 00:01: [io  0x0880-0x088f] has been reserved
[    0.116848] system 00:0a: [io  0x4000-0x40bf] could not be reserved
[    0.116990] system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
[    0.117130] system 00:0d: [mem 0x000d3800-0x000d3fff] has been reserved
[    0.117270] system 00:0d: [mem 0x000f0000-0x000f7fff] could not be reserved
[    0.117409] system 00:0d: [mem 0x000f8000-0x000fbfff] could not be reserved
[    0.117548] system 00:0d: [mem 0x000fc000-0x000fffff] could not be reserved
[    0.117688] system 00:0d: [mem 0x7f7f0000-0x7f7fffff] could not be reserved
[    0.117827] system 00:0d: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.117968] system 00:0d: [mem 0x00100000-0x7f7effff] could not be reserved
[    0.118108] system 00:0d: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.118249] system 00:0d: [mem 0xfed13000-0xfed1dfff] has been reserved
[    0.118389] system 00:0d: [mem 0xfed20000-0xfed8ffff] has been reserved
[    0.118527] system 00:0d: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.118667] system 00:0d: [mem 0xffb00000-0xffb7ffff] has been reserved
[    0.118805] system 00:0d: [mem 0xfff00000-0xffffffff] has been reserved
[    0.118943] system 00:0d: [mem 0x000e0000-0x000effff] has been reserved
[    0.154906] pci 0000:00:1c.0: BAR 8: assigned [mem 0x80000000-0x801fffff]
[    0.155046] pci 0000:00:1c.0: BAR 9: assigned [mem 0x80200000-0x803fffff 64bit pref]
[    0.155289] pci 0000:00:1c.1: BAR 9: assigned [mem 0x80400000-0x805fffff pref]
[    0.155527] pci 0000:00:1c.2: BAR 9: assigned [mem 0x80600000-0x807fffff pref]
[    0.155766] pci 0000:00:1c.3: BAR 8: assigned [mem 0x80800000-0x809fffff]
[    0.155914] pci 0000:00:1c.3: BAR 9: assigned [mem 0x80a00000-0x80bfffff 64bit pref]
[    0.156154] pci 0000:00:1c.0: BAR 7: assigned [io  0x1000-0x1fff]
[    0.156291] pci 0000:00:1c.3: BAR 7: assigned [io  0x2000-0x2fff]
[    0.156429] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.156565] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.156704] pci 0000:00:1c.0:   bridge window [mem 0x80000000-0x801fffff]
[    0.156845] pci 0000:00:1c.0:   bridge window [mem 0x80200000-0x803fffff 64bit pref]
[    0.157088] pci 0000:02:00.0: BAR 6: assigned [mem 0x80400000-0x8041ffff pref]
[    0.157328] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.157463] pci 0000:00:1c.1:   bridge window [io  0xb000-0xbfff]
[    0.157604] pci 0000:00:1c.1:   bridge window [mem 0xd2100000-0xd21fffff]
[    0.157744] pci 0000:00:1c.1:   bridge window [mem 0x80400000-0x805fffff pref]
[    0.157988] pci 0000:03:00.0: BAR 6: assigned [mem 0x80600000-0x8061ffff pref]
[    0.158225] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
[    0.158361] pci 0000:00:1c.2:   bridge window [io  0xc000-0xcfff]
[    0.158502] pci 0000:00:1c.2:   bridge window [mem 0xd2000000-0xd20fffff]
[    0.158641] pci 0000:00:1c.2:   bridge window [mem 0x80600000-0x807fffff pref]
[    0.158884] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
[    0.159019] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.159160] pci 0000:00:1c.3:   bridge window [mem 0x80800000-0x809fffff]
[    0.159300] pci 0000:00:1c.3:   bridge window [mem 0x80a00000-0x80bfffff 64bit pref]
[    0.159544] pci 0000:00:1e.0: PCI bridge to [bus 05-05]
[    0.159679] pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
[    0.159818] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd1ffffff]
[    0.159968] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.160116] pci 0000:00:1c.0: enabling device (0100 -> 0103)
[    0.160258] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.160402] pci 0000:00:1c.0: setting latency timer to 64
[    0.160411] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.160551] pci 0000:00:1c.1: setting latency timer to 64
[    0.160560] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.160700] pci 0000:00:1c.2: setting latency timer to 64
[    0.160708] pci 0000:00:1c.3: enabling device (0100 -> 0103)
[    0.160846] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.160986] pci 0000:00:1c.3: setting latency timer to 64
[    0.160993] pci 0000:00:1e.0: setting latency timer to 64
[    0.160997] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.161001] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
[    0.161004] pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
[    0.161007] pci_bus 0000:01: resource 1 [mem 0x80000000-0x801fffff]
[    0.161010] pci_bus 0000:01: resource 2 [mem 0x80200000-0x803fffff 64bit pref]
[    0.161014] pci_bus 0000:02: resource 0 [io  0xb000-0xbfff]
[    0.161017] pci_bus 0000:02: resource 1 [mem 0xd2100000-0xd21fffff]
[    0.161020] pci_bus 0000:02: resource 2 [mem 0x80400000-0x805fffff pref]
[    0.161023] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
[    0.161026] pci_bus 0000:03: resource 1 [mem 0xd2000000-0xd20fffff]
[    0.161030] pci_bus 0000:03: resource 2 [mem 0x80600000-0x807fffff pref]
[    0.161033] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
[    0.161036] pci_bus 0000:04: resource 1 [mem 0x80800000-0x809fffff]
[    0.161039] pci_bus 0000:04: resource 2 [mem 0x80a00000-0x80bfffff 64bit pref]
[    0.161042] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]
[    0.161046] pci_bus 0000:05: resource 1 [mem 0xd0000000-0xd1ffffff]
[    0.161049] pci_bus 0000:05: resource 4 [io  0x0000-0xffff]
[    0.161052] pci_bus 0000:05: resource 5 [mem 0x00000000-0xffffffff]
[    0.161098] NET: Registered protocol family 2
[    0.161290] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.161694] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.162908] TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
[    0.163356] TCP: Hash tables configured (established 131072 bind 65536)
[    0.163494] TCP reno registered
[    0.163626] UDP hash table entries: 512 (order: 1, 8192 bytes)
[    0.163774] UDP-Lite hash table entries: 512 (order: 1, 8192 bytes)
[    0.164060] NET: Registered protocol family 1
[    0.164218] pci 0000:00:02.0: Boot video device
[    1.764009] pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
[    1.764183] PCI: CLS 32 bytes, default 64
[    1.764250] Unpacking initramfs...
[    2.083524] Freeing initrd memory: 9608k freed
[    2.091844] microcode: CPU0 sig=0x6d8, pf=0x20, revision=0x20
[    2.092041] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    2.092417] audit: initializing netlink socket (disabled)
[    2.092572] type=2000 audit(1295958031.092:1): initialized
[    2.115381] highmem bounce pool size: 64 pages
[    2.115518] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    2.115761] VFS: Disk quotas dquot_6.5.2
[    2.115921] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.116229] fuse init (API version 7.15)
[    2.116414] msgmni has been set to 1710
[    2.116689] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    2.116931] io scheduler noop registered
[    2.117062] io scheduler deadline registered
[    2.117211] io scheduler cfq registered (default)
[    2.117603] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    2.117847] ACPI: Power Button [PWRB]
[    2.118065] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.118305] ACPI: Power Button [PWRF]
[    2.118482] ACPI: Fan [FAN] (on)
[    2.118648] ACPI: acpi_idle registered with cpuidle
[    2.118728] ACPI: AOpen i915GMm-HFS detected: disabling all active thermal trip points
[    2.118968] ACPI: AOpen i915GMm-HFS detected: disabling all passive thermal trip points
[    2.119208] ACPI: AOpen i915GMm-HFS detected: enabling thermal zone polling
[    2.119761] thermal LNXTHERM:01: registered as thermal_zone0
[    2.119896] ACPI: Thermal Zone [THRM] (49 C)
[    2.122148] lp: driver loaded but no devices found
[    2.122358] Non-volatile memory driver v1.3
[    2.122491] Linux agpgart interface v0.103
[    2.122653] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
[    2.123474] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
[    2.126233] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    2.126439] [drm] Initialized drm 1.1.0 20060810
[    2.126572] [drm:drm_init], 
[    2.126584] [drm:drm_get_pci_dev], 
[    2.126596] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.126736] i915 0000:00:02.0: setting latency timer to 64
[    2.128433] [drm:drm_get_minor], 
[    2.128584] [drm:drm_get_minor], new minor assigned 64
[    2.128589] [drm:drm_get_minor], 
[    2.128671] [drm:drm_get_minor], new minor assigned 0
[    2.129969] [drm:i915_init_phys_hws], Enabled hardware status page
[    2.129986] [drm] set up 7M of stolen space
[    2.130234] [drm:drm_agp_bind_pages], 
[    2.130697] [drm:parse_general_definitions], crt_ddc_bus_pin: 2
[    2.130730] [drm:parse_lfp_panel_data], Found panel mode in BIOS VBT tables:
[    2.130733] [drm:drm_mode_debug_printmodeline], Modeline 0:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x8 0xa
[    2.130804] [drm:parse_sdvo_device_mapping], the SDVO device with slave addr 70 is found on SDVOB port
[    2.130811] [drm:parse_sdvo_device_mapping], the SDVO device with slave addr 72 is found on SDVOC port
[    2.130867] [drm:intel_modeset_init], 2 display pipes available.
[    2.130875] [drm:intel_crtc_init], swapping pipes & planes for FBC
[    2.130881] [drm:intel_crtc_init], swapping pipes & planes for FBC
[    2.130887] [drm:intel_no_lvds_dmi_callback], Skipping LVDS initialization for AOpen motherboard i915GMm-HFS
[    2.131000] [drm:drm_sysfs_connector_add], adding "VGA-1" to sysfs
[    2.131020] [drm:drm_sysfs_hotplug_event], generating hotplug event
[    2.131032] [drm:intel_setup_outputs], probing SDVOB
[    2.374066] [drm:intel_sdvo_debug_write], SDVOB: W: 02                         (SDVO_CMD_GET_DEVICE_CAPS)
[    2.411101] [drm:intel_sdvo_debug_response], SDVOB: R: 02 3C 06 01 01 01 01 00 (Success)
[    2.411110] [drm:intel_sdvo_debug_write], SDVOB: W: 9D                         (SDVO_CMD_GET_SUPP_ENCODE)
[    2.425402] [drm:intel_sdvo_debug_response], SDVOB: R: 00 00                   (Not supported)
[    2.425410] [drm:drm_sysfs_connector_add], adding "DVI-D-1" to sysfs
[    2.425429] [drm:drm_sysfs_hotplug_event], generating hotplug event
[    2.425440] [drm:intel_sdvo_debug_write], SDVOB: W: 10 00                      (SDVO_CMD_SET_TARGET_INPUT)
[    2.435045] [drm:intel_sdvo_debug_response], SDVOB: R:                         (Success)
[    2.435052] [drm:intel_sdvo_debug_write], SDVOB: W: 1D                         (SDVO_CMD_GET_INPUT_PIXEL_CLOCK_RANGE)
[    2.456927] [drm:intel_sdvo_debug_response], SDVOB: R: C4 09 20 4E             (Success)
[    2.456935] [drm:intel_sdvo_init], SDVOB device VID/DID: 02:3C.06, clock range 25MHz - 200MHz, input 1: Y, input 2: N, output 1: Y, output 2: N
[    2.456941] [drm:intel_setup_outputs], probing SDVOC
[    2.699943] [drm:intel_sdvo_debug_write], SDVOC: W: 02                         (SDVO_CMD_GET_DEVICE_CAPS)
[    2.736984] [drm:intel_sdvo_debug_response], SDVOC: R: 02 C2 01 01 01 3D 3E 00 (Success)
[    2.736993] [drm:drm_sysfs_connector_add], adding "SVIDEO-1" to sysfs
[    2.737012] [drm:drm_sysfs_hotplug_event], generating hotplug event
[    2.737022] [drm:intel_sdvo_debug_write], SDVOC: W: 11 08 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
[    2.749531] [drm:intel_sdvo_debug_response], SDVOC: R:                         (Success)
[    2.749539] [drm:intel_sdvo_debug_write], SDVOC: W: 27                         (SDVO_CMD_GET_SUPPORTED_TV_FORMATS)
[    2.778990] [drm:intel_sdvo_debug_response], SDVOC: R: FF FF FF FF FF 1F       (Success)
[    2.779006] [drm:intel_sdvo_debug_write], SDVOC: W: 84                         (SDVO_CMD_GET_SUPPORTED_ENHANCEMENTS)
[    2.793295] [drm:intel_sdvo_debug_response], SDVOC: R: FA DF                   (Success)
[    2.793302] [drm:intel_sdvo_debug_write], SDVOC: W: 61                         (SDVO_CMD_GET_MAX_OVERSCAN_H)
[    2.815169] [drm:intel_sdvo_debug_response], SDVOC: R: 2F 00 20 00             (Success)
[    2.815176] [drm:intel_sdvo_debug_write], SDVOC: W: 62                         (SDVO_CMD_GET_OVERSCAN_H)
[    2.829464] [drm:intel_sdvo_debug_response], SDVOC: R: 20 00                   (Success)
[    2.829473] [drm:intel_sdvo_create_enhance_property_tv], h_overscan: max 47, default 32, current 32
[    2.829477] [drm:intel_sdvo_debug_write], SDVOC: W: 64                         (SDVO_CMD_GET_MAX_OVERSCAN_V)
[    2.851346] [drm:intel_sdvo_debug_response], SDVOC: R: 2F 00 20 00             (Success)
[    2.851354] [drm:intel_sdvo_debug_write], SDVOC: W: 65                         (SDVO_CMD_GET_OVERSCAN_V)
[    2.865642] [drm:intel_sdvo_debug_response], SDVOC: R: 20 00                   (Success)
[    2.865650] [drm:intel_sdvo_create_enhance_property_tv], v_overscan: max 47, default 32, current 32
[    2.865654] [drm:intel_sdvo_debug_write], SDVOC: W: 67                         (SDVO_CMD_GET_MAX_HPOS)
[    2.887520] [drm:intel_sdvo_debug_response], SDVOC: R: FF 03 00 02             (Success)
[    2.887528] [drm:intel_sdvo_debug_write], SDVOC: W: 68                         (SDVO_CMD_GET_HPOS)
[    2.901816] [drm:intel_sdvo_debug_response], SDVOC: R: 00 02                   (Success)
[    2.901824] [drm:intel_sdvo_create_enhance_property_tv], hpos: max 1023, default 512, current 512
[    2.901828] [drm:intel_sdvo_debug_write], SDVOC: W: 6A                         (SDVO_CMD_GET_MAX_VPOS)
[    2.923695] [drm:intel_sdvo_debug_response], SDVOC: R: FF 03 00 02             (Success)
[    2.923703] [drm:intel_sdvo_debug_write], SDVOC: W: 6B                         (SDVO_CMD_GET_VPOS)
[    2.937991] [drm:intel_sdvo_debug_response], SDVOC: R: 00 02                   (Success)
[    2.937999] [drm:intel_sdvo_create_enhance_property_tv], vpos: max 1023, default 512, current 512
[    2.938003] [drm:intel_sdvo_debug_write], SDVOC: W: 55                         (SDVO_CMD_GET_MAX_SATURATION)
[    2.959870] [drm:intel_sdvo_debug_response], SDVOC: R: 7F 00 45 00             (Success)
[    2.959877] [drm:intel_sdvo_debug_write], SDVOC: W: 56                         (SDVO_CMD_GET_SATURATION)
[    2.974166] [drm:intel_sdvo_debug_response], SDVOC: R: 45 00                   (Success)
[    2.974174] [drm:intel_sdvo_create_enhance_property_tv], saturation: max 127, default 69, current 69
[    2.974178] [drm:intel_sdvo_debug_write], SDVOC: W: 5E                         (SDVO_CMD_GET_MAX_CONTRAST)
[    2.996050] [drm:intel_sdvo_debug_response], SDVOC: R: 7F 00 40 00             (Success)
[    2.996058] [drm:intel_sdvo_debug_write], SDVOC: W: 5F                         (SDVO_CMD_GET_CONTRAST)
[    3.010340] [drm:intel_sdvo_debug_response], SDVOC: R: 40 00                   (Success)
[    3.010348] [drm:intel_sdvo_create_enhance_property_tv], contrast: max 127, default 64, current 64
[    3.010352] [drm:intel_sdvo_debug_write], SDVOC: W: 58                         (SDVO_CMD_GET_MAX_HUE)
[    3.032225] [drm:intel_sdvo_debug_response], SDVOC: R: 7F 00 40 00             (Success)
[    3.032232] [drm:intel_sdvo_debug_write], SDVOC: W: 59                         (SDVO_CMD_GET_HUE)
[    3.046514] [drm:intel_sdvo_debug_response], SDVOC: R: 40 00                   (Success)
[    3.046522] [drm:intel_sdvo_create_enhance_property_tv], hue: max 127, default 64, current 64
[    3.046526] [drm:intel_sdvo_debug_write], SDVOC: W: 6D                         (SDVO_CMD_GET_MAX_SHARPNESS)
[    3.068400] [drm:intel_sdvo_debug_response], SDVOC: R: 07 00 04 00             (Success)
[    3.068408] [drm:intel_sdvo_debug_write], SDVOC: W: 6E                         (SDVO_CMD_GET_SHARPNESS)
[    3.082692] [drm:intel_sdvo_debug_response], SDVOC: R: 04 00                   (Success)
[    3.082700] [drm:intel_sdvo_create_enhance_property_tv], sharpness: max 7, default 4, current 4
[    3.082704] [drm:intel_sdvo_debug_write], SDVOC: W: 5B                         (SDVO_CMD_GET_MAX_BRIGHTNESS)
[    3.104576] [drm:intel_sdvo_debug_response], SDVOC: R: FF 00 80 00             (Success)
[    3.104583] [drm:intel_sdvo_debug_write], SDVOC: W: 5C                         (SDVO_CMD_GET_BRIGHTNESS)
[    3.118866] [drm:intel_sdvo_debug_response], SDVOC: R: 80 00                   (Success)
[    3.118874] [drm:intel_sdvo_create_enhance_property_tv], brightness: max 255, default 128, current 128
[    3.118878] [drm:intel_sdvo_debug_write], SDVOC: W: 7B                         (SDVO_CMD_GET_MAX_FLICKER_FILTER_ADAPTIVE)
[    3.140752] [drm:intel_sdvo_debug_response], SDVOC: R: 07 00 07 00             (Success)
[    3.140760] [drm:intel_sdvo_debug_write], SDVOC: W: 50                         (SDVO_CMD_GET_FLICKER_FILTER_ADAPTIVE)
[    3.155044] [drm:intel_sdvo_debug_response], SDVOC: R: 07 00                   (Success)
[    3.155052] [drm:intel_sdvo_create_enhance_property_tv], flicker_filter_adaptive: max 7, default 7, current 7
[    3.155057] [drm:intel_sdvo_debug_write], SDVOC: W: 74                         (SDVO_CMD_GET_MAX_TV_CHROMA_FILTER)
[    3.176930] [drm:intel_sdvo_debug_response], SDVOC: R: 03 00 01 00             (Success)
[    3.176938] [drm:intel_sdvo_debug_write], SDVOC: W: 75                         (SDVO_CMD_GET_TV_CHROMA_FILTER)
[    3.191220] [drm:intel_sdvo_debug_response], SDVOC: R: 01 00                   (Success)
[    3.191228] [drm:intel_sdvo_create_enhance_property_tv], tv_chroma_filter: max 3, default 1, current 1
[    3.191232] [drm:intel_sdvo_debug_write], SDVOC: W: 77                         (SDVO_CMD_GET_MAX_TV_LUMA_FILTER)
[    3.213105] [drm:intel_sdvo_debug_response], SDVOC: R: 02 00 00 00             (Success)
[    3.213112] [drm:intel_sdvo_debug_write], SDVOC: W: 78                         (SDVO_CMD_GET_TV_LUMA_FILTER)
[    3.227397] [drm:intel_sdvo_debug_response], SDVOC: R: 00 00                   (Success)
[    3.227404] [drm:intel_sdvo_create_enhance_property_tv], tv_luma_filter: max 2, default 0, current 0
[    3.227408] [drm:intel_sdvo_debug_write], SDVOC: W: 70                         (SDVO_CMD_GET_DOT_CRAWL)
[    3.241698] [drm:intel_sdvo_debug_response], SDVOC: R: 00 00                   (Success)
[    3.241706] [drm:intel_sdvo_create_enhance_property_tv], dot crawl: current 0
[    3.241710] [drm:drm_sysfs_connector_add], adding "SVIDEO-2" to sysfs
[    3.241730] [drm:drm_sysfs_hotplug_event], generating hotplug event
[    3.241740] [drm:intel_sdvo_debug_write], SDVOC: W: 11 04 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
[    3.254251] [drm:intel_sdvo_debug_response], SDVOC: R:                         (Success)
[    3.254259] [drm:intel_sdvo_debug_write], SDVOC: W: 27                         (SDVO_CMD_GET_SUPPORTED_TV_FORMATS)
[    3.283709] [drm:intel_sdvo_debug_response], SDVOC: R: FF FF FF FF FF 1F       (Success)
[    3.283725] [drm:intel_sdvo_debug_write], SDVOC: W: 84                         (SDVO_CMD_GET_SUPPORTED_ENHANCEMENTS)
[    3.298013] [drm:intel_sdvo_debug_response], SDVOC: R: FA DF                   (Success)
[    3.298020] [drm:intel_sdvo_debug_write], SDVOC: W: 61                         (SDVO_CMD_GET_MAX_OVERSCAN_H)
[    3.319887] [drm:intel_sdvo_debug_response], SDVOC: R: 2F 00 20 00             (Success)
[    3.319894] [drm:intel_sdvo_debug_write], SDVOC: W: 62                         (SDVO_CMD_GET_OVERSCAN_H)
[    3.334182] [drm:intel_sdvo_debug_response], SDVOC: R: 20 00                   (Success)
[    3.334191] [drm:intel_sdvo_create_enhance_property_tv], h_overscan: max 47, default 32, current 32
[    3.334195] [drm:intel_sdvo_debug_write], SDVOC: W: 64                         (SDVO_CMD_GET_MAX_OVERSCAN_V)
[    3.356067] [drm:intel_sdvo_debug_response], SDVOC: R: 2F 00 20 00             (Success)
[    3.356074] [drm:intel_sdvo_debug_write], SDVOC: W: 65                         (SDVO_CMD_GET_OVERSCAN_V)
[    3.370357] [drm:intel_sdvo_debug_response], SDVOC: R: 20 00                   (Success)
[    3.370366] [drm:intel_sdvo_create_enhance_property_tv], v_overscan: max 47, default 32, current 32
[    3.370370] [drm:intel_sdvo_debug_write], SDVOC: W: 67                         (SDVO_CMD_GET_MAX_HPOS)
[    3.392242] [drm:intel_sdvo_debug_response], SDVOC: R: FF 03 00 02             (Success)
[    3.392249] [drm:intel_sdvo_debug_write], SDVOC: W: 68                         (SDVO_CMD_GET_HPOS)
[    3.406534] [drm:intel_sdvo_debug_response], SDVOC: R: 00 02                   (Success)
[    3.406542] [drm:intel_sdvo_create_enhance_property_tv], hpos: max 1023, default 512, current 512
[    3.406546] [drm:intel_sdvo_debug_write], SDVOC: W: 6A                         (SDVO_CMD_GET_MAX_VPOS)
[    3.428420] [drm:intel_sdvo_debug_response], SDVOC: R: FF 03 00 02             (Success)
[    3.428427] [drm:intel_sdvo_debug_write], SDVOC: W: 6B                         (SDVO_CMD_GET_VPOS)
[    3.442712] [drm:intel_sdvo_debug_response], SDVOC: R: 00 02                   (Success)
[    3.442720] [drm:intel_sdvo_create_enhance_property_tv], vpos: max 1023, default 512, current 512
[    3.442724] [drm:intel_sdvo_debug_write], SDVOC: W: 55                         (SDVO_CMD_GET_MAX_SATURATION)
[    3.464596] [drm:intel_sdvo_debug_response], SDVOC: R: 7F 00 45 00             (Success)
[    3.464604] [drm:intel_sdvo_debug_write], SDVOC: W: 56                         (SDVO_CMD_GET_SATURATION)
[    3.478887] [drm:intel_sdvo_debug_response], SDVOC: R: 45 00                   (Success)
[    3.478895] [drm:intel_sdvo_create_enhance_property_tv], saturation: max 127, default 69, current 69
[    3.478899] [drm:intel_sdvo_debug_write], SDVOC: W: 5E                         (SDVO_CMD_GET_MAX_CONTRAST)
[    3.500771] [drm:intel_sdvo_debug_response], SDVOC: R: 7F 00 40 00             (Success)
[    3.500778] [drm:intel_sdvo_debug_write], SDVOC: W: 5F                         (SDVO_CMD_GET_CONTRAST)
[    3.515060] [drm:intel_sdvo_debug_response], SDVOC: R: 40 00                   (Success)
[    3.515068] [drm:intel_sdvo_create_enhance_property_tv], contrast: max 127, default 64, current 64
[    3.515072] [drm:intel_sdvo_debug_write], SDVOC: W: 58                         (SDVO_CMD_GET_MAX_HUE)
[    3.536947] [drm:intel_sdvo_debug_response], SDVOC: R: 7F 00 40 00             (Success)
[    3.536954] [drm:intel_sdvo_debug_write], SDVOC: W: 59                         (SDVO_CMD_GET_HUE)
[    3.551239] [drm:intel_sdvo_debug_response], SDVOC: R: 40 00                   (Success)
[    3.551247] [drm:intel_sdvo_create_enhance_property_tv], hue: max 127, default 64, current 64
[    3.551250] [drm:intel_sdvo_debug_write], SDVOC: W: 6D                         (SDVO_CMD_GET_MAX_SHARPNESS)
[    3.573125] [drm:intel_sdvo_debug_response], SDVOC: R: 07 00 04 00             (Success)
[    3.573132] [drm:intel_sdvo_debug_write], SDVOC: W: 6E                         (SDVO_CMD_GET_SHARPNESS)
[    3.587417] [drm:intel_sdvo_debug_response], SDVOC: R: 04 00                   (Success)
[    3.587425] [drm:intel_sdvo_create_enhance_property_tv], sharpness: max 7, default 4, current 4
[    3.587429] [drm:intel_sdvo_debug_write], SDVOC: W: 5B                         (SDVO_CMD_GET_MAX_BRIGHTNESS)
[    3.609301] [drm:intel_sdvo_debug_response], SDVOC: R: FF 00 80 00             (Success)
[    3.609308] [drm:intel_sdvo_debug_write], SDVOC: W: 5C                         (SDVO_CMD_GET_BRIGHTNESS)
[    3.623591] [drm:intel_sdvo_debug_response], SDVOC: R: 80 00                   (Success)
[    3.623599] [drm:intel_sdvo_create_enhance_property_tv], brightness: max 255, default 128, current 128
[    3.623603] [drm:intel_sdvo_debug_write], SDVOC: W: 7B                         (SDVO_CMD_GET_MAX_FLICKER_FILTER_ADAPTIVE)
[    3.645477] [drm:intel_sdvo_debug_response], SDVOC: R: 07 00 07 00             (Success)
[    3.645484] [drm:intel_sdvo_debug_write], SDVOC: W: 50                         (SDVO_CMD_GET_FLICKER_FILTER_ADAPTIVE)
[    3.659769] [drm:intel_sdvo_debug_response], SDVOC: R: 07 00                   (Success)
[    3.659777] [drm:intel_sdvo_create_enhance_property_tv], flicker_filter_adaptive: max 7, default 7, current 7
[    3.659781] [drm:intel_sdvo_debug_write], SDVOC: W: 74                         (SDVO_CMD_GET_MAX_TV_CHROMA_FILTER)
[    3.681654] [drm:intel_sdvo_debug_response], SDVOC: R: 03 00 01 00             (Success)
[    3.681662] [drm:intel_sdvo_debug_write], SDVOC: W: 75                         (SDVO_CMD_GET_TV_CHROMA_FILTER)
[    3.695945] [drm:intel_sdvo_debug_response], SDVOC: R: 01 00                   (Success)
[    3.695954] [drm:intel_sdvo_create_enhance_property_tv], tv_chroma_filter: max 3, default 1, current 1
[    3.695958] [drm:intel_sdvo_debug_write], SDVOC: W: 77                         (SDVO_CMD_GET_MAX_TV_LUMA_FILTER)
[    3.717830] [drm:intel_sdvo_debug_response], SDVOC: R: 02 00 00 00             (Success)
[    3.717837] [drm:intel_sdvo_debug_write], SDVOC: W: 78                         (SDVO_CMD_GET_TV_LUMA_FILTER)
[    3.732126] [drm:intel_sdvo_debug_response], SDVOC: R: 00 00                   (Success)
[    3.732134] [drm:intel_sdvo_create_enhance_property_tv], tv_luma_filter: max 2, default 0, current 0
[    3.732138] [drm:intel_sdvo_debug_write], SDVOC: W: 70                         (SDVO_CMD_GET_DOT_CRAWL)
[    3.746420] [drm:intel_sdvo_debug_response], SDVOC: R: 00 00                   (Success)
[    3.746428] [drm:intel_sdvo_create_enhance_property_tv], dot crawl: current 0
[    3.746432] [drm:drm_sysfs_connector_add], adding "VGA-2" to sysfs
[    3.746452] [drm:drm_sysfs_hotplug_event], generating hotplug event
[    3.746461] [drm:intel_sdvo_debug_write], SDVOC: W: 10 00                      (SDVO_CMD_SET_TARGET_INPUT)
[    3.756072] [drm:intel_sdvo_debug_response], SDVOC: R:                         (Success)
[    3.756079] [drm:intel_sdvo_debug_write], SDVOC: W: 1D                         (SDVO_CMD_GET_INPUT_PIXEL_CLOCK_RANGE)
[    3.777945] [drm:intel_sdvo_debug_response], SDVOC: R: C4 09 D8 40             (Success)
[    3.777953] [drm:intel_sdvo_init], SDVOC device VID/DID: 02:C2.01, clock range 25MHz - 166MHz, input 1: Y, input 2: N, output 1: Y, output 2: N
[    3.777979] [drm:drm_sysfs_connector_add], adding "SVIDEO-3" to sysfs
[    3.777998] [drm:drm_sysfs_hotplug_event], generating hotplug event
[    3.778393] [drm] initialized overlay support
[    3.778522] [drm:drm_irq_install], irq=16
[    3.778543] [drm:intel_sdvo_debug_write], SDVOB: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    3.791053] [drm:intel_sdvo_debug_response], SDVOB: R:                         (Success)
[    3.791062] [drm:intel_sdvo_debug_write], SDVOC: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    3.803573] [drm:intel_sdvo_debug_response], SDVOC: R:                         (Success)
[    3.813660] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[    3.818777] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[    3.823200] [drm:drm_crtc_helper_set_mode], [CRTC:3]
[    3.823203] [drm:intel_sdvo_debug_write], SDVOB: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    3.835713] [drm:intel_sdvo_debug_response], SDVOB: R:                         (Success)
[    3.835720] [drm:intel_sdvo_debug_write], SDVOC: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    3.848235] [drm:intel_sdvo_debug_response], SDVOC: R:                         (Success)
[    3.848244] [drm:drm_vblank_get], enabling vblank on crtc 0, ret: -22
[    3.848553] [drm:intel_crtc_mode_set], Mode for pipe A:
[    3.848556] [drm:drm_mode_debug_printmodeline], Modeline 0:"640x480" 0 31500 640 664 704 832 480 489 491 520 0x10 0xa
[    3.849033] [drm:intel_pipe_set_base], No FB bound
[    3.849037] [drm:drm_crtc_helper_set_mode], [ENCODER:6:DAC-6] set [MODE:0:640x480]
[    3.849041] [drm:intel_update_watermarks], plane B (pipe 0) clock: 31500
[    3.849045] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    3.849049] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    3.849053] [drm:intel_calculate_wm], FIFO entries required for mode: 0
[    3.849056] [drm:intel_calculate_wm], FIFO watermark level: 26
[    3.849059] [drm:intel_calculate_wm], FIFO entries required for mode: 10
[    3.849062] [drm:intel_calculate_wm], FIFO watermark level: 19
[    3.849065] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 19
[    3.849068] [drm:i9xx_update_wm], self-refresh entries: 40
[    3.849071] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 19, C: 2, SR 55
[    3.876507] [drm:intel_sdvo_debug_write], SDVOB: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    3.889017] [drm:intel_sdvo_debug_response], SDVOB: R:                         (Success)
[    3.889025] [drm:intel_sdvo_debug_write], SDVOC: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    3.901535] [drm:intel_sdvo_debug_response], SDVOC: R:                         (Success)
[    3.911615] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1] disconnected
[    3.911619] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1]
[    3.911623] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[    3.925914] [drm:intel_sdvo_debug_response], SDVOB: R: 01 00                   (Success)
[    3.925922] [drm:intel_sdvo_detect], SDVO response 1 0
[    3.925925] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    3.939281] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    4.050106] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    4.063463] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    4.174294] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1] probed modes :
[    4.174298] [drm:drm_mode_debug_printmodeline], Modeline 61:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    4.174304] [drm:drm_mode_debug_printmodeline], Modeline 65:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[    4.174310] [drm:drm_mode_debug_printmodeline], Modeline 62:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[    4.174316] [drm:drm_mode_debug_printmodeline], Modeline 63:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[    4.174322] [drm:drm_mode_debug_printmodeline], Modeline 64:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[    4.174328] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:SVIDEO-1]
[    4.174332] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[    4.218384] [drm:intel_sdvo_debug_response], SDVOC: R: 00 00                   (Success)
[    4.218392] [drm:intel_sdvo_detect], SDVO response 0 0
[    4.218395] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:SVIDEO-1] disconnected
[    4.218399] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:SVIDEO-2]
[    4.218403] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[    4.262455] [drm:intel_sdvo_debug_response], SDVOC: R: 00 00                   (Success)
[    4.262462] [drm:intel_sdvo_detect], SDVO response 0 0
[    4.262465] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:SVIDEO-2] disconnected
[    4.262469] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:44:VGA-2]
[    4.262473] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[    4.306524] [drm:intel_sdvo_debug_response], SDVOC: R: 00 00                   (Success)
[    4.306532] [drm:intel_sdvo_detect], SDVO response 0 0
[    4.306535] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:44:VGA-2] disconnected
[    4.306539] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:45:SVIDEO-3]
[    4.306545] [drm:drm_crtc_helper_set_mode], [CRTC:3]
[    4.306548] [drm:intel_sdvo_debug_write], SDVOB: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    4.319058] [drm:intel_sdvo_debug_response], SDVOB: R:                         (Success)
[    4.319065] [drm:intel_sdvo_debug_write], SDVOC: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    4.331574] [drm:intel_sdvo_debug_response], SDVOC: R:                         (Success)
[    4.331582] [drm:drm_vblank_get], enabling vblank on crtc 0, ret: -22
[    4.331887] [drm:intel_crtc_mode_set], Mode for pipe A:
[    4.331890] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[    4.332363] [drm:intel_pipe_set_base], No FB bound
[    4.332367] [drm:drm_crtc_helper_set_mode], [ENCODER:46:TV-46] set [MODE:0:NTSC 480i]
[    4.388003] [drm:intel_wait_for_vblank], vblank wait timed out
[    4.388036] [drm:intel_update_watermarks], plane B (pipe 0) clock: 107520
[    4.388039] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    4.388043] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    4.388046] [drm:intel_calculate_wm], FIFO entries required for mode: 0
[    4.388049] [drm:intel_calculate_wm], FIFO watermark level: 26
[    4.388052] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[    4.388055] [drm:intel_calculate_wm], FIFO watermark level: -5
[    4.388058] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 1
[    4.388062] [drm:i9xx_update_wm], self-refresh entries: 80
[    4.388065] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 1, C: 2, SR 15
[    4.464007] [drm:intel_tv_detect_type], No TV connection detected
[    4.464011] [drm:intel_sdvo_debug_write], SDVOB: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    4.476524] [drm:intel_sdvo_debug_response], SDVOB: R:                         (Success)
[    4.476532] [drm:intel_sdvo_debug_write], SDVOC: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    4.489042] [drm:intel_sdvo_debug_response], SDVOC: R:                         (Success)
[    4.514005] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:45:SVIDEO-3] disconnected
[    4.514009] [drm:drm_setup_crtcs], 
[    4.514012] [drm:drm_enable_connectors], connector 5 enabled? no
[    4.514016] [drm:drm_enable_connectors], connector 8 enabled? yes
[    4.514019] [drm:drm_enable_connectors], connector 10 enabled? no
[    4.514022] [drm:drm_enable_connectors], connector 27 enabled? no
[    4.514025] [drm:drm_enable_connectors], connector 44 enabled? no
[    4.514029] [drm:drm_enable_connectors], connector 45 enabled? no
[    4.514032] [drm:drm_target_preferred], looking for cmdline mode on connector 8
[    4.514036] [drm:drm_target_preferred], looking for preferred mode on connector 8
[    4.514039] [drm:drm_target_preferred], found mode 1280x1024
[    4.514042] [drm:drm_setup_crtcs], picking CRTCs for 4096x4096 config
[    4.514046] [drm:drm_setup_crtcs], desired mode 1280x1024 set on crtc 3
[    4.518747] [drm:drm_agp_bind_pages], 
[    4.522608] [drm:intelfb_create], allocated 1280x1024 fb: 0x007e0000, bo f7306300
[    4.524680] [drm:drm_crtc_helper_set_config], 
[    4.524683] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:67] #connectors=1 (x y) (0 0)
[    4.524692] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[    4.524695] [drm:drm_crtc_helper_set_config], modes are different, full mode set
[    4.524698] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[    4.524704] [drm:drm_mode_debug_printmodeline], Modeline 66:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    4.524711] [drm:drm_crtc_helper_set_config], encoder changed, full mode switch
[    4.524714] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[    4.524717] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:3]
[    4.524720] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[    4.524723] [drm:drm_mode_debug_printmodeline], Modeline 66:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    4.524732] [drm:drm_crtc_helper_set_mode], [CRTC:3]
[    4.524735] [drm:intel_sdvo_debug_write], SDVOB: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    4.537248] [drm:intel_sdvo_debug_response], SDVOB: R:                         (Success)
[    4.537254] [drm:intel_sdvo_debug_write], SDVOC: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    4.549763] [drm:intel_sdvo_debug_response], SDVOC: R:                         (Success)
[    4.549771] [drm:drm_vblank_get], enabling vblank on crtc 0, ret: -22
[    4.550083] [drm:intel_crtc_mode_set], Mode for pipe A:
[    4.550085] [drm:drm_mode_debug_printmodeline], Modeline 66:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    4.550556] [drm:intel_pipe_set_base_atomic], Writing base 007E0000 00000000 0 0 5120
[    4.567217] [drm:drm_crtc_helper_set_mode], [ENCODER:7:TMDS-7] set [MODE:66:1280x1024]
[    4.567221] [drm:intel_sdvo_debug_write], SDVOB: W: 07 01 00 00 00             (SDVO_CMD_SET_IN_OUT_MAP)
[    4.585539] [drm:intel_sdvo_debug_response], SDVOB: R:                         (Success)
[    4.585545] [drm:intel_sdvo_debug_write], SDVOB: W: 11 01 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
[    4.598052] [drm:intel_sdvo_debug_response], SDVOB: R:                         (Success)
[    4.598057] [drm:intel_sdvo_debug_write], SDVOB: W: 16 30 2A 00 98 51 00 2A 40 (SDVO_CMD_SET_OUTPUT_TIMINGS_PART1)
[    4.627985] [drm:intel_sdvo_debug_response], SDVOB: R:                         (Success)
[    4.627990] [drm:intel_sdvo_debug_write], SDVOB: W: 17 30 70 13 00 1E 00 00 00 (SDVO_CMD_SET_OUTPUT_TIMINGS_PART2)
[    4.657926] [drm:intel_sdvo_debug_response], SDVOB: R:                         (Success)
[    4.657931] [drm:intel_sdvo_debug_write], SDVOB: W: 10 00                      (SDVO_CMD_SET_TARGET_INPUT)
[    4.667533] [drm:intel_sdvo_debug_response], SDVOB: R:                         (Success)
[    4.667538] [drm:intel_sdvo_debug_write], SDVOB: W: 14 30 2A 00 98 51 00 2A 40 (SDVO_CMD_SET_INPUT_TIMINGS_PART1)
[    4.697471] [drm:intel_sdvo_debug_response], SDVOB: R:                         (Success)
[    4.697476] [drm:intel_sdvo_debug_write], SDVOB: W: 15 30 70 13 00 1E 00 00 00 (SDVO_CMD_SET_INPUT_TIMINGS_PART2)
[    4.727404] [drm:intel_sdvo_debug_response], SDVOB: R:                         (Success)
[    4.727409] [drm:intel_sdvo_debug_write], SDVOB: W: 21 01                      (SDVO_CMD_SET_CLOCK_RATE_MULT)
[    4.737018] [drm:intel_sdvo_debug_response], SDVOB: R:                         (Success)
[    4.737025] [drm:intel_update_watermarks], plane B (pipe 0) clock: 108000
[    4.737029] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    4.737033] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    4.737036] [drm:intel_calculate_wm], FIFO entries required for mode: 0
[    4.737038] [drm:intel_calculate_wm], FIFO watermark level: 26
[    4.737041] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[    4.737043] [drm:intel_calculate_wm], FIFO watermark level: -5
[    4.737046] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 1
[    4.737049] [drm:i9xx_update_wm], self-refresh entries: 80
[    4.737052] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 1, C: 2, SR 15
[    4.767173] [drm:intel_sdvo_debug_write], SDVOB: W: 03                         (SDVO_CMD_GET_TRAINED_INPUTS)
[    4.777668] [drm:intel_sdvo_debug_response], SDVOB: R: 01                      (Success)
[    4.777673] [drm:intel_sdvo_debug_write], SDVOB: W: 05 01 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    4.790184] [drm:intel_sdvo_debug_response], SDVOB: R:                         (Success)
[    4.790190] [drm:intel_sdvo_debug_write], SDVOC: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    4.802700] [drm:intel_sdvo_debug_response], SDVOC: R:                         (Success)
[    4.802707] [drm:drm_crtc_helper_set_config], 
[    4.802709] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:67] #connectors=0 (x y) (0 0)
[    4.802715] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[    4.802718] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:3]
[    4.802722] [drm:intel_sdvo_debug_write], SDVOC: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    4.815233] [drm:intel_sdvo_debug_response], SDVOC: R:                         (Success)
[    4.815264] [drm:drm_crtc_helper_set_config], 
[    4.815266] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:67] #connectors=1 (x y) (0 0)
[    4.815273] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:3]
[    4.822244] [drm:drm_crtc_helper_set_config], 
[    4.822246] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:67] #connectors=1 (x y) (0 0)
[    4.822253] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:3]
[    4.829198] Console: switching to colour frame buffer device 160x64
[    4.829204] [drm:drm_crtc_helper_set_config], 
[    4.829206] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:67] #connectors=1 (x y) (0 0)
[    4.829213] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:3]
[    4.836252] fb0: inteldrmfb frame buffer device
[    4.836293] drm: registered panic notifier
[    4.836335] [drm:intel_opregion_init], graphic opregion physical addr: 0x0
[    4.836338] [drm:intel_opregion_init], ACPI OpRegion not supported!
[    4.836463] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    4.836558] Serial: 8250/16550 driver, 8 ports, IRQ sharing enabled
[    4.856961] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.877364] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    4.898001] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.918421] 00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    4.918880] parport_pc 00:08: reported by Plug and Play ACPI
[    4.918979] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
[    5.016053] lp0: using parport0 (interrupt-driven).
[    5.016670] loop: module loaded
[    5.016700] Uniform Multi-Platform E-IDE driver
[    5.016783] piix 0000:00:1f.1: IDE controller (0x8086:0x266f rev 0x04)
[    5.016854] PIIX_IDE 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    5.016924] piix 0000:00:1f.1: IDE port disabled
[    5.016973] piix 0000:00:1f.1: not 100% native mode: will probe irqs later
[    5.017037]     ide0: BM-DMA at 0xf000-0xf007
[    5.017081] Probing IDE interface ide0...
[    5.752208] hda: PLEXTOR DVDR PX-755A, ATAPI CD/DVD-ROM drive
[    6.088036] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    6.088103] hda: UDMA/66 mode selected
[    6.088212] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    6.089964] ide-gd driver 1.18
[    6.090005] ide-cd driver 5.00
[    6.090702] ide-cd: hda: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
[    6.090799] cdrom: Uniform CD-ROM driver Revision: 3.20
[    6.100416] ata_piix 0000:00:1f.2: version 2.13
[    6.100428] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    6.100494] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
[    6.100596] ata_piix 0000:00:1f.2: setting latency timer to 64
[    6.100655] scsi0 : ata_piix
[    6.100751] scsi1 : ata_piix
[    6.100813] ata1: SATA max UDMA/133 cmd 0xe500 ctl 0xe600 bmdma 0xe900 irq 19
[    6.100876] ata2: SATA max UDMA/133 cmd 0xe700 ctl 0xe800 bmdma 0xe908 irq 19
[    6.100980] sky2: driver version 1.28
[    6.101032] sky2 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    6.101098] sky2 0000:02:00.0: setting latency timer to 64
[    6.101121] sky2 0000:02:00.0: Yukon-2 EC chip revision 1
[    6.101252] sky2 0000:02:00.0: irq 40 for MSI/MSI-X
[    6.101469] sky2 0000:02:00.0: eth0: addr 00:01:80:62:25:4b
[    6.101532] sky2 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    6.101597] sky2 0000:03:00.0: setting latency timer to 64
[    6.101618] sky2 0000:03:00.0: Yukon-2 EC chip revision 1
[    6.101744] sky2 0000:03:00.0: irq 41 for MSI/MSI-X
[    6.101952] sky2 0000:03:00.0: eth1: addr 00:01:80:62:25:4c
[    6.102037] ohci1394 0000:05:03.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    6.162024] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[20]  MMIO=[d1000000-d10007ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
[    6.171564] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.174135] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    6.176703] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    6.176707] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    6.179257] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    6.185723] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    6.185733] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xd2344000
[    6.204009] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    6.206518] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    6.208996] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.211464] usb usb1: Product: EHCI Host Controller
[    6.213949] usb usb1: Manufacturer: Linux 2.6.36.3-kape ehci_hcd
[    6.216418] usb usb1: SerialNumber: 0000:00:1d.7
[    6.218924] hub 1-0:1.0: USB hub found
[    6.221354] hub 1-0:1.0: 8 ports detected
[    6.223812] uhci_hcd: USB Universal Host Controller Interface driver
[    6.226273] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    6.228739] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    6.228743] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    6.231189] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    6.233703] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e000
[    6.236203] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    6.238672] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.241144] usb usb2: Product: UHCI Host Controller
[    6.243580] usb usb2: Manufacturer: Linux 2.6.36.3-kape uhci_hcd
[    6.246047] usb usb2: SerialNumber: 0000:00:1d.0
[    6.248553] hub 2-0:1.0: USB hub found
[    6.250962] hub 2-0:1.0: 2 ports detected
[    6.253415] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    6.255853] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    6.255857] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    6.258281] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    6.271622] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e100
[    6.274113] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    6.276673] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.279144] usb usb3: Product: UHCI Host Controller
[    6.281621] usb usb3: Manufacturer: Linux 2.6.36.3-kape uhci_hcd
[    6.284073] usb usb3: SerialNumber: 0000:00:1d.1
[    6.286548] hub 3-0:1.0: USB hub found
[    6.288979] hub 3-0:1.0: 2 ports detected
[    6.291408] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.294007] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    6.294011] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    6.296431] ata1.00: ATA-7: HDT722525DLA380, V44OA91A, max UDMA/133
[    6.298827] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    6.301267] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    6.303720] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e200
[    6.306216] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    6.308645] ata1.01: ATA-8: ST31000340NS, SN05, max UDMA/133
[    6.311069] ata1.01: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    6.313536] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.316158] usb usb4: Product: UHCI Host Controller
[    6.318620] usb usb4: Manufacturer: Linux 2.6.36.3-kape uhci_hcd
[    6.321107] usb usb4: SerialNumber: 0000:00:1d.2
[    6.323625] hub 4-0:1.0: USB hub found
[    6.326225] hub 4-0:1.0: 2 ports detected
[    6.328669] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    6.331138] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    6.331142] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    6.333752] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    6.336282] ata1.00: configured for UDMA/133
[    6.338893] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000e300
[    6.341395] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    6.343882] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.346533] usb usb5: Product: UHCI Host Controller
[    6.349032] usb usb5: Manufacturer: Linux 2.6.36.3-kape uhci_hcd
[    6.351534] usb usb5: SerialNumber: 0000:00:1d.3
[    6.354306] hub 5-0:1.0: USB hub found
[    6.356831] ata1.01: configured for UDMA/133
[    6.359275] hub 5-0:1.0: 2 ports detected
[    6.361728] usbcore: registered new interface driver usblp
[    6.364141] Initializing USB Mass Storage driver...
[    6.366581] usbcore: registered new interface driver usb-storage
[    6.369009] USB Mass Storage support registered.
[    6.371472] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    6.374008] scsi 0:0:0:0: Direct-Access     ATA      HDT722525DLA380  V44O PQ: 0 ANSI: 5
[    6.376581] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.379078] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    6.381656] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    6.384256] sd 0:0:0:0: [sda] Write Protect is off
[    6.386765] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    6.386823] scsi 0:0:1:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    6.390241] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.392835] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.395607] sd 0:0:1:0: Attached scsi generic sg1 type 0
[    6.398293] mice: PS/2 mouse device common for all mice
[    6.400960] sd 0:0:1:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    6.403646] sd 0:0:1:0: [sdb] Write Protect is off
[    6.406490] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    6.406651] input: PC Speaker as /devices/platform/pcspkr/input/input2
[    6.409374] rtc_cmos 00:03: RTC can wake from S4
[    6.412089] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    6.414751] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    6.417445] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    6.420185] w83627hf: Found W83627THF chip at 0x290
[    6.422968] ACPI: resource w83627hf [io  0x0295-0x0296] conflicts with ACPI region SEN1 [??? 0x00000295-0x00000296 flags 0x31]
[    6.425789] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    6.428690] device-mapper: uevent: version 1.0.3
[    6.431540] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initialised: dm-devel@redhat.com
[    6.434487] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.437435] cpuidle: using governor ladder
[    6.440313] cpuidle: using governor menu
[    6.443340] usbcore: registered new interface driver hiddev
[    6.446279] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    6.449292] usbcore: registered new interface driver usbhid
[    6.452216] usbhid: USB HID core driver
[    6.455384] TCP cubic registered
[    6.458573] Using IPI Shortcut mode
[    6.461514] registered taskstats version 1
[    6.464666] rtc_cmos 00:03: setting system clock to 2011-01-25 12:20:35 UTC (1295958035)
[    6.467585] BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
[    6.480032] Marking TSC unstable due to cpufreq changes
[    6.482765]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
[    6.485698] Switching to clocksource hpet
[    6.510424] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.547881]  sdb: sdb1 sdb2 sdb4 < sdb5 sdb6 sdb7 sdb8 sdb9 >
[    6.554704] sd 0:0:1:0: [sdb] Attached SCSI disk
[    6.560779] Freeing unused kernel memory: 312k freed
[    6.566971] Write protecting the kernel text: 3256k
[    6.570033] Write protecting the kernel read-only data: 1536k
[    6.656116] udev: starting version 157
[    6.658874] udevd (84): /proc/84/oom_adj is deprecated, please use /proc/84/oom_score_adj instead.
[    6.704040] usb 1-4: new high speed USB device using ehci_hcd and address 4
[    6.846724] usb 1-4: New USB device found, idVendor=04b8, idProduct=011b
[    6.849627] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.859738] usb 1-4: Product: EPSON Scanner
[    6.862584] usb 1-4: Manufacturer: EPSON
[    7.112033] usb 2-2: new low speed USB device using uhci_hcd and address 2
[    7.294135] usb 2-2: New USB device found, idVendor=046d, idProduct=c50e
[    7.300159] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.306050] usb 2-2: Product: USB RECEIVER
[    7.311839] usb 2-2: Manufacturer: Logitech
[    7.340494] input: Logitech USB RECEIVER as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input4
[    7.347135] generic-usb 0003:046D:C50E.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB RECEIVER] on usb-0000:00:1d.0-2/input0
[    7.440225] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[000180139462254b]
[    7.592061] usb 3-1: new full speed USB device using uhci_hcd and address 2
[    7.789040] usb 3-1: New USB device found, idVendor=03f0, idProduct=1d17
[    7.795121] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    7.801173] usb 3-1: Product: hp LaserJet 1320 series
[    7.807047] usb 3-1: Manufacturer: Hewlett-Packard
[    7.812932] usb 3-1: SerialNumber: 00CNHW646GZH
[    7.824304] usblp0: USB Bidirectional printer dev 2 if 0 alt 1 proto 2 vid 0x03F0 pid 0x1D17
[    8.493864] REISERFS (device sdb5): found reiserfs format "3.6" with standard journal
[    8.496594] REISERFS (device sdb5): using ordered data mode
[    8.503004] REISERFS (device sdb5): journal params: device sdb5, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[    8.508791] REISERFS (device sdb5): checking transaction log (sdb5)
[    8.543045] REISERFS (device sdb5): Using r5 hash to sort names
[    9.972608] udev: starting version 157
[   10.220416] intel_rng: FWH not detected
[   11.067734] RME Digi96 0000:05:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   11.528348] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   11.534523] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[   11.534538] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   11.708325] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input5
[   13.756865] NET: Registered protocol family 10
[   13.760047] lo: Disabled Privacy Extensions
[   13.907806] Adding 963896k swap on /dev/sda2.  Priority:-1 extents:1 across:963896k 
[   13.929411] Adding 4200992k swap on /dev/sdb2.  Priority:-2 extents:1 across:4200992k 
[   14.852503] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   14.878436] [drm:intel_sdvo_debug_response], SDVOB: R: 01 00                   (Success)
[   14.878457] [drm:intel_sdvo_detect], SDVO response 1 0
[   14.878467] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   14.899141] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   15.012166] REISERFS (device sda7): found reiserfs format "3.6" with standard journal
[   15.018709] REISERFS (device sda7): using ordered data mode
[   15.036023] REISERFS (device sda7): journal params: device sda7, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   15.049737] REISERFS (device sda7): checking transaction log (sda7)
[   15.096600] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   15.121901] REISERFS (device sda7): Using r5 hash to sort names
[   15.147139] [drm:intel_sdvo_debug_response], SDVOC: R: 00 00                   (Success)
[   15.147159] [drm:intel_sdvo_detect], SDVO response 0 0
[   17.878253] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   17.989974] ip_tables: (C) 2000-2006 Netfilter Core Team
[   18.103543] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   18.825347] [drm:drm_crtc_helper_set_config], 
[   18.825354] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:67] #connectors=1 (x y) (0 0)
[   18.825379] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:3]
[   20.393848] sky2 0000:02:00.0: eth0: enabling interface
[   20.396545] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   21.039490] sky2 0000:03:00.0: eth1: enabling interface
[   21.048188] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   22.739039] sky2 0000:02:00.0: eth0: Link is up at 1000 Mbps, full duplex, flow control both
[   22.739210] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   23.087777] PPP generic driver version 2.4.2
[   23.229479] NET: Registered protocol family 17
[   25.156531] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   25.172773] [drm:intel_sdvo_debug_response], SDVOB: R: 01 00                   (Success)
[   25.172793] [drm:intel_sdvo_detect], SDVO response 1 0
[   25.172803] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   25.187694] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   25.350159] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   25.394660] [drm:intel_sdvo_debug_response], SDVOC: R: 00 00                   (Success)
[   25.394679] [drm:intel_sdvo_detect], SDVO response 0 0
[   28.694288] SFW2-INint-ACC-TCP IN=eth0 OUT= MAC=00:01:80:62:25:4b:00:01:80:62:cf:b1:08:00 SRC=192.168.22.31 DST=192.168.24.15 LEN=60 TOS=0x00 PREC=0x00 TTL=64 ID=24483 DF PROTO=TCP SPT=41071 DPT=8765 WINDOW=4380 RES=0x00 SYN URGP=0 OPT (020405B40402080A0026ACE60000000001030306) 
[   32.832012] eth0: no IPv6 routers present
[   35.428493] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   35.443235] [drm:intel_sdvo_debug_response], SDVOB: R: 01 00                   (Success)
[   35.443255] [drm:intel_sdvo_detect], SDVO response 1 0
[   35.443264] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   35.457201] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   35.569337] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   35.613743] [drm:intel_sdvo_debug_response], SDVOC: R: 00 00                   (Success)
[   35.613762] [drm:intel_sdvo_detect], SDVO response 0 0
[   45.636489] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   45.651318] [drm:intel_sdvo_debug_response], SDVOB: R: 01 00                   (Success)
[   45.651337] [drm:intel_sdvo_detect], SDVO response 1 0
[   45.651347] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   45.665286] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   45.777418] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   45.821829] [drm:intel_sdvo_debug_response], SDVOC: R: 00 00                   (Success)
[   45.821848] [drm:intel_sdvo_detect], SDVO response 0 0

--------------060302090704010900070504
Content-Type: text/plain;
 name="2.6.38-rc2.startup"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="2.6.38-rc2.startup"

[    0.000000] Linux version 2.6.38-rc2-kape (knut@golem) (gcc version 4.5.0 20100604 [gcc-4_5-branch revision 160292] (SUSE Linux) ) #13 PREEMPT Mon Jan 24 18:31:22 CET 2011
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f7f0000 (usable)
[    0.000000]  BIOS-e820: 000000007f7f0000 - 000000007f7f3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007f7f3000 - 000000007f800000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] DMI 2.3 present.
[    0.000000] DMI: i915GMm-HFS/ , BIOS 6.00 PG 09/14/2005
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x7f7f0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 07F800000 mask FFF800000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] initial memory mapped : 0 - 01000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ ffb000-1000000
[    0.000000] RAMDISK: 3768f000 - 37ff0000
[    0.000000] Allocated new RAMDISK: 36d2e000 - 3768ee15
[    0.000000] Move RAMDISK from 000000003768f000 - 0000000037fefe14 to 36d2e000 - 3768ee14
[    0.000000] ACPI: RSDP 000f9320 00014 (v00 AOpen )
[    0.000000] ACPI: RSDT 7f7f3040 00038 (v01 AOpen  AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: FACP 7f7f30c0 00074 (v01 AOpen  AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: DSDT 7f7f3180 042E3 (v01 AOPEN  AWRDACPI 00001000 MSFT 0100000E)
[    0.000000] ACPI: FACS 7f7f0000 00040
[    0.000000] ACPI: MCFG 7f7f7580 0003C (v01 AOpen  AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: APIC 7f7f74c0 0005A (v01 AOpen  AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: SSDT 7f7f7600 00222 (v01  PmRef  Cpu0Ist 00003000 INTL 20040311)
[    0.000000] ACPI: SSDT 7f7f7a00 000E0 (v01  PmRef    CpuPm 00003000 INTL 20040311)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1151MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0007f7f0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007f7f0
[    0.000000] On node 0 totalpages: 522111
[    0.000000] free_area_init_node: node 0, pgdat c06a9444, node_mem_map f5d3e200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2304 pages used for memmap
[    0.000000]   HighMem zone: 292594 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] nr_irqs_gsi: 40
[    0.000000] Allocating PCI resources starting at 7f800000 (gap: 7f800000:60800000)
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 518031
[    0.000000] Kernel command line: root=/dev/sdb5 acpi_enforce_resources=lax drm.debug=0xf
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000377fe:0007f7f0)
[    0.000000] Memory: 2050084k/2088896k available (3546k kernel code, 38360k reserved, 2268k data, 336k init, 1179592k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa3000 - 0xfffff000   ( 368 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc06ae000 - 0xc0702000   ( 336 kB)
[    0.000000]       .data : 0xc0476957 - 0xc06ad9c0   (2268 kB)
[    0.000000]       .text : 0xc0100000 - 0xc0476957   (3546 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] NR_IRQS:288
[    0.000000] CPU 0 irqstacks, hard=f580a000 soft=f580c000
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
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1862.719 MHz processor.
[    0.008003] Calibrating delay loop (skipped), value calculated using timer frequency.. 3725.43 BogoMIPS (lpj=7450876)
[    0.008275] pid_max: default: 32768 minimum: 301
[    0.008499] Security Framework initialized
[    0.008667] AppArmor: AppArmor initialized
[    0.008842] Mount-cache hash table entries: 512
[    0.012521] mce: CPU supports 5 MCE banks
[    0.012663] CPU0: Thermal monitoring enabled (TM2)
[    0.012808] CPU: Intel(R) Pentium(R) M processor 1.86GHz stepping 08
[    0.013414] ACPI: Core revision 20110112
[    0.024216] Performance Events: p6 PMU driver.
[    0.024388] ... version:                0
[    0.024519] ... bit width:              32
[    0.024651] ... generic registers:      2
[    0.024783] ... value mask:             00000000ffffffff
[    0.024919] ... max period:             000000007fffffff
[    0.025053] ... fixed-purpose events:   0
[    0.025182] ... event mask:             0000000000000003
[    0.028381] NMI watchdog enabled, takes one hw-pmu counter.
[    0.028554] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.029069] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.072003] NET: Registered protocol family 16
[    0.072003] ACPI: bus type pci registered
[    0.072003] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.072003] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.072003] PCI: Using MMCONFIG for extended config space
[    0.072003] PCI: Using configuration type 1 for base access
[    0.074914] bio: create slab <bio-0> at 0
[    0.079403] ACPI: EC: Look up EC in DSDT
[    0.089926] ACPI: Interpreter enabled
[    0.090057] ACPI: (supports S0 S5)
[    0.090250] ACPI: Using IOAPIC for interrupt routing
[    0.101025] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.101471] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.102046] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.102050] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.102054] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.102058] pci_root PNP0A08:00: host bridge window [mem 0x000c0000-0x000dffff] (ignored)
[    0.102062] pci_root PNP0A08:00: host bridge window [mem 0x7f800000-0xfebfffff] (ignored)
[    0.102117] pci 0000:00:00.0: [8086:2590] type 0 class 0x000600
[    0.102246] pci 0000:00:02.0: [8086:2592] type 0 class 0x000300
[    0.102265] pci 0000:00:02.0: reg 10: [mem 0xd2280000-0xd22fffff]
[    0.102276] pci 0000:00:02.0: reg 14: [io  0xe400-0xe407]
[    0.102287] pci 0000:00:02.0: reg 18: [mem 0xc0000000-0xcfffffff pref]
[    0.102298] pci 0000:00:02.0: reg 1c: [mem 0xd2300000-0xd233ffff]
[    0.102356] pci 0000:00:02.1: [8086:2792] type 0 class 0x000380
[    0.102373] pci 0000:00:02.1: reg 10: [mem 0xd2200000-0xd227ffff]
[    0.102509] pci 0000:00:1b.0: [8086:2668] type 0 class 0x000403
[    0.102534] pci 0000:00:1b.0: reg 10: [mem 0xd2340000-0xd2343fff 64bit]
[    0.102621] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.102627] pci 0000:00:1b.0: PME# disabled
[    0.102655] pci 0000:00:1c.0: [8086:2660] type 1 class 0x000604
[    0.102743] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.102749] pci 0000:00:1c.0: PME# disabled
[    0.102782] pci 0000:00:1c.1: [8086:2662] type 1 class 0x000604
[    0.102870] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.102876] pci 0000:00:1c.1: PME# disabled
[    0.102906] pci 0000:00:1c.2: [8086:2664] type 1 class 0x000604
[    0.102994] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.103000] pci 0000:00:1c.2: PME# disabled
[    0.103030] pci 0000:00:1c.3: [8086:2666] type 1 class 0x000604
[    0.103118] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.103124] pci 0000:00:1c.3: PME# disabled
[    0.103157] pci 0000:00:1d.0: [8086:2658] type 0 class 0x000c03
[    0.103218] pci 0000:00:1d.0: reg 20: [io  0xe000-0xe01f]
[    0.103267] pci 0000:00:1d.1: [8086:2659] type 0 class 0x000c03
[    0.103328] pci 0000:00:1d.1: reg 20: [io  0xe100-0xe11f]
[    0.103373] pci 0000:00:1d.2: [8086:265a] type 0 class 0x000c03
[    0.103435] pci 0000:00:1d.2: reg 20: [io  0xe200-0xe21f]
[    0.103479] pci 0000:00:1d.3: [8086:265b] type 0 class 0x000c03
[    0.103541] pci 0000:00:1d.3: reg 20: [io  0xe300-0xe31f]
[    0.103596] pci 0000:00:1d.7: [8086:265c] type 0 class 0x000c03
[    0.103621] pci 0000:00:1d.7: reg 10: [mem 0xd2344000-0xd23443ff]
[    0.103717] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.103724] pci 0000:00:1d.7: PME# disabled
[    0.103749] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.103831] pci 0000:00:1f.0: [8086:2641] type 0 class 0x000601
[    0.103968] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.103976] pci 0000:00:1f.0: quirk: [io  0x4000-0x407f] claimed by ICH6 ACPI/GPIO/TCO
[    0.104014] pci 0000:00:1f.0: quirk: [io  0x4080-0x40bf] claimed by ICH6 GPIO
[    0.104158] pci 0000:00:1f.0: LPC Generic IO decode 1 PIO at 0280-02ff
[    0.104298] pci 0000:00:1f.0: LPC Generic IO decode 2 PIO at 1640-164f
[    0.104454] pci 0000:00:1f.1: [8086:266f] type 0 class 0x000101
[    0.104474] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    0.104488] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    0.104502] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
[    0.104516] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
[    0.104530] pci 0000:00:1f.1: reg 20: [io  0xf000-0xf00f]
[    0.104581] pci 0000:00:1f.2: [8086:2653] type 0 class 0x000101
[    0.104603] pci 0000:00:1f.2: reg 10: [io  0xe500-0xe507]
[    0.104616] pci 0000:00:1f.2: reg 14: [io  0xe600-0xe603]
[    0.104629] pci 0000:00:1f.2: reg 18: [io  0xe700-0xe707]
[    0.104642] pci 0000:00:1f.2: reg 1c: [io  0xe800-0xe803]
[    0.104655] pci 0000:00:1f.2: reg 20: [io  0xe900-0xe90f]
[    0.104668] pci 0000:00:1f.2: reg 24: [mem 0xd2345000-0xd23453ff]
[    0.104704] pci 0000:00:1f.2: PME# supported from D3hot
[    0.104710] pci 0000:00:1f.2: PME# disabled
[    0.104732] pci 0000:00:1f.3: [8086:266a] type 0 class 0x000c05
[    0.104804] pci 0000:00:1f.3: reg 20: [io  0x5000-0x501f]
[    0.104913] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.105052] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.105059] pci 0000:00:1c.0:   bridge window [mem 0x00000000-0x000fffff] (disabled)
[    0.105068] pci 0000:00:1c.0:   bridge window [mem 0x00000000-0x000fffff pref] (disabled)
[    0.105158] pci 0000:02:00.0: [11ab:4362] type 0 class 0x000200
[    0.105190] pci 0000:02:00.0: reg 10: [mem 0xd2120000-0xd2123fff 64bit]
[    0.105208] pci 0000:02:00.0: reg 18: [io  0xb000-0xb0ff]
[    0.105267] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.105321] pci 0000:02:00.0: supports D1 D2
[    0.105325] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.105332] pci 0000:02:00.0: PME# disabled
[    0.105350] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.105698] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.105833] pci 0000:00:1c.1:   bridge window [io  0xb000-0xbfff]
[    0.105839] pci 0000:00:1c.1:   bridge window [mem 0xd2100000-0xd21fffff]
[    0.105848] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.105938] pci 0000:03:00.0: [11ab:4362] type 0 class 0x000200
[    0.105970] pci 0000:03:00.0: reg 10: [mem 0xd2020000-0xd2023fff 64bit]
[    0.105988] pci 0000:03:00.0: reg 18: [io  0xc000-0xc0ff]
[    0.106047] pci 0000:03:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.106102] pci 0000:03:00.0: supports D1 D2
[    0.106105] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.106112] pci 0000:03:00.0: PME# disabled
[    0.106129] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.106381] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
[    0.106516] pci 0000:00:1c.2:   bridge window [io  0xc000-0xcfff]
[    0.106522] pci 0000:00:1c.2:   bridge window [mem 0xd2000000-0xd20fffff]
[    0.106531] pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.106594] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
[    0.106733] pci 0000:00:1c.3:   bridge window [io  0xf000-0x0000] (disabled)
[    0.106740] pci 0000:00:1c.3:   bridge window [mem 0x00000000-0x000fffff] (disabled)
[    0.106749] pci 0000:00:1c.3:   bridge window [mem 0x00000000-0x000fffff pref] (disabled)
[    0.106804] pci 0000:05:03.0: [11c1:5811] type 0 class 0x000c00
[    0.106829] pci 0000:05:03.0: reg 10: [mem 0xd1000000-0xd1000fff]
[    0.106927] pci 0000:05:03.0: supports D1 D2
[    0.106930] pci 0000:05:03.0: PME# supported from D0 D1 D2 D3hot
[    0.106992] pci 0000:05:03.0: PME# disabled
[    0.107014] pci 0000:05:04.0: [1360:0101] type 0 class 0x000880
[    0.107034] pci 0000:05:04.0: reg 10: [io  0xd000-0xd03f]
[    0.107129] pci 0000:05:05.0: [10ee:3fc3] type 0 class 0x000401
[    0.107150] pci 0000:05:05.0: reg 10: [mem 0xd0000000-0xd0ffffff]
[    0.107288] pci 0000:00:1e.0: PCI bridge to [bus 05-05] (subtractive decode)
[    0.107432] pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
[    0.107438] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd1ffffff]
[    0.107447] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.107452] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    0.107456] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffff] (subtractive decode)
[    0.107490] pci_bus 0000:00: on NUMA node 0
[    0.107497] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.108168] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.108277] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[    0.108382] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
[    0.108488] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.108593] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.109008]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.138805] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 7 9 10 11 12 14 15)
[    0.139332] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 11 *12 14 15)
[    0.139858] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 *10 11 12 14 15)
[    0.140405] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    0.140932] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 *9 10 11 12 14 15)
[    0.141456] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.142125] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.142795] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    0.143494] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.143772] vgaarb: loaded
[    0.144127] SCSI subsystem initialized
[    0.144365] libata version 3.00 loaded.
[    0.144434] usbcore: registered new interface driver usbfs
[    0.144596] usbcore: registered new interface driver hub
[    0.144785] usbcore: registered new device driver usb
[    0.145100] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    0.145238] PCI: Using ACPI for IRQ routing
[    0.145372] PCI: pci_cache_line_size set to 64 bytes
[    0.145544] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
[    0.145548] reserve RAM buffer: 000000007f7f0000 - 000000007fffffff 
[    0.146160] hpet clockevent registered
[    0.146166] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.146309] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.146532] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.152237] Switching to clocksource hpet
[    0.152856] AppArmor: AppArmor Filesystem Enabled
[    0.153023] pnp: PnP ACPI init
[    0.153181] ACPI: bus type pnp registered
[    0.153461] pnp 00:00: [bus 00-ff]
[    0.153466] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.153470] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.153473] pnp 00:00: [io  0x0d00-0xffff window]
[    0.153477] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.153480] pnp 00:00: [mem 0x000c0000-0x000dffff window]
[    0.153484] pnp 00:00: [mem 0x7f800000-0xfebfffff window]
[    0.153595] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.153727] pnp 00:01: [io  0x0010-0x001f]
[    0.153730] pnp 00:01: [io  0x0022-0x003f]
[    0.153733] pnp 00:01: [io  0x0044-0x005f]
[    0.153736] pnp 00:01: [io  0x0062-0x0063]
[    0.153739] pnp 00:01: [io  0x0065-0x006f]
[    0.153742] pnp 00:01: [io  0x0074-0x007f]
[    0.153745] pnp 00:01: [io  0x0091-0x0093]
[    0.153748] pnp 00:01: [io  0x00a2-0x00bf]
[    0.153751] pnp 00:01: [io  0x00e0-0x00ef]
[    0.153754] pnp 00:01: [io  0x0b78-0x0b7b]
[    0.153757] pnp 00:01: [io  0x0f78-0x0f7b]
[    0.153760] pnp 00:01: [io  0x0a78-0x0a7b]
[    0.153763] pnp 00:01: [io  0x0e78-0x0e7b]
[    0.153766] pnp 00:01: [io  0x0bbc-0x0bbf]
[    0.153769] pnp 00:01: [io  0x0fbc-0x0fbf]
[    0.153772] pnp 00:01: [io  0x04d0-0x04d1]
[    0.153775] pnp 00:01: [io  0x0290-0x0297]
[    0.153778] pnp 00:01: [io  0x0880-0x088f]
[    0.153937] system 00:01: [io  0x0b78-0x0b7b] has been reserved
[    0.154078] system 00:01: [io  0x0f78-0x0f7b] has been reserved
[    0.154217] system 00:01: [io  0x0a78-0x0a7b] has been reserved
[    0.154355] system 00:01: [io  0x0e78-0x0e7b] has been reserved
[    0.154494] system 00:01: [io  0x0bbc-0x0bbf] has been reserved
[    0.154632] system 00:01: [io  0x0fbc-0x0fbf] has been reserved
[    0.154770] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.154910] system 00:01: [io  0x0290-0x0297] has been reserved
[    0.155048] system 00:01: [io  0x0880-0x088f] has been reserved
[    0.155187] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.155218] pnp 00:02: [dma 4]
[    0.155221] pnp 00:02: [io  0x0000-0x000f]
[    0.155224] pnp 00:02: [io  0x0080-0x0090]
[    0.155227] pnp 00:02: [io  0x0094-0x009f]
[    0.155230] pnp 00:02: [io  0x00c0-0x00df]
[    0.155288] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.155319] pnp 00:03: [io  0x0070-0x0073]
[    0.155334] pnp 00:03: [irq 8]
[    0.155396] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.155419] pnp 00:04: [io  0x0061]
[    0.155482] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.155504] pnp 00:05: [io  0x00f0-0x00ff]
[    0.155512] pnp 00:05: [irq 13]
[    0.155577] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.155973] pnp 00:06: [io  0x03f8-0x03ff]
[    0.155983] pnp 00:06: [irq 4]
[    0.155983] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.156123] pnp 00:07: [io  0x02f8-0x02ff]
[    0.156132] pnp 00:07: [irq 3]
[    0.156233] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.156879] pnp 00:08: [io  0x0378-0x037f]
[    0.156883] pnp 00:08: [io  0x0778-0x077b]
[    0.156891] pnp 00:08: [irq 7]
[    0.156894] pnp 00:08: [dma 3]
[    0.157003] pnp 00:08: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.157088] pnp 00:09: [io  0x0060]
[    0.157091] pnp 00:09: [io  0x0064]
[    0.157100] pnp 00:09: [irq 1]
[    0.157168] pnp 00:09: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.157244] pnp 00:0a: [io  0x4000-0x40bf]
[    0.157369] system 00:0a: [io  0x4000-0x40bf] could not be reserved
[    0.157511] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.157557] pnp 00:0b: [mem 0xffb80000-0xffbfffff]
[    0.157630] pnp 00:0b: Plug and Play ACPI device, IDs INT0800 (active)
[    0.158155] pnp 00:0c: [mem 0xe0000000-0xefffffff]
[    0.158310] system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
[    0.158452] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.158700] pnp 00:0d: [mem 0x000d3800-0x000d3fff]
[    0.158704] pnp 00:0d: [mem 0x000f0000-0x000f7fff]
[    0.158707] pnp 00:0d: [mem 0x000f8000-0x000fbfff]
[    0.158711] pnp 00:0d: [mem 0x000fc000-0x000fffff]
[    0.158714] pnp 00:0d: [mem 0x7f7f0000-0x7f7fffff]
[    0.158717] pnp 00:0d: [mem 0x00000000-0x0009ffff]
[    0.158720] pnp 00:0d: [mem 0x00100000-0x7f7effff]
[    0.158724] pnp 00:0d: [mem 0xfec00000-0xfec00fff]
[    0.158727] pnp 00:0d: [mem 0xfed13000-0xfed1dfff]
[    0.158730] pnp 00:0d: [mem 0xfed20000-0xfed8ffff]
[    0.158737] pnp 00:0d: [mem 0xfee00000-0xfee00fff]
[    0.158740] pnp 00:0d: [mem 0xffb00000-0xffb7ffff]
[    0.158744] pnp 00:0d: [mem 0xfff00000-0xffffffff]
[    0.158747] pnp 00:0d: [mem 0x000e0000-0x000effff]
[    0.158914] system 00:0d: [mem 0x000d3800-0x000d3fff] has been reserved
[    0.159056] system 00:0d: [mem 0x000f0000-0x000f7fff] could not be reserved
[    0.159197] system 00:0d: [mem 0x000f8000-0x000fbfff] could not be reserved
[    0.159339] system 00:0d: [mem 0x000fc000-0x000fffff] could not be reserved
[    0.159481] system 00:0d: [mem 0x7f7f0000-0x7f7fffff] could not be reserved
[    0.159624] system 00:0d: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.159766] system 00:0d: [mem 0x00100000-0x7f7effff] could not be reserved
[    0.159907] system 00:0d: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.160065] system 00:0d: [mem 0xfed13000-0xfed1dfff] has been reserved
[    0.163127] system 00:0d: [mem 0xfed20000-0xfed8ffff] has been reserved
[    0.163264] system 00:0d: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.163401] system 00:0d: [mem 0xffb00000-0xffb7ffff] has been reserved
[    0.163538] system 00:0d: [mem 0xfff00000-0xffffffff] has been reserved
[    0.163678] system 00:0d: [mem 0x000e0000-0x000effff] has been reserved
[    0.163820] system 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.163844] pnp: PnP ACPI: found 14 devices
[    0.163977] ACPI: ACPI bus type pnp unregistered
[    0.201376] pci 0000:00:1c.0: BAR 8: assigned [mem 0x80000000-0x801fffff]
[    0.201520] pci 0000:00:1c.0: BAR 9: assigned [mem 0x80200000-0x803fffff 64bit pref]
[    0.201762] pci 0000:00:1c.1: BAR 9: assigned [mem 0x80400000-0x805fffff pref]
[    0.202005] pci 0000:00:1c.2: BAR 9: assigned [mem 0x80600000-0x807fffff pref]
[    0.202248] pci 0000:00:1c.3: BAR 8: assigned [mem 0x80800000-0x809fffff]
[    0.202389] pci 0000:00:1c.3: BAR 9: assigned [mem 0x80a00000-0x80bfffff 64bit pref]
[    0.202633] pci 0000:00:1c.0: BAR 7: assigned [io  0x1000-0x1fff]
[    0.202771] pci 0000:00:1c.3: BAR 7: assigned [io  0x2000-0x2fff]
[    0.202910] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.203047] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.203188] pci 0000:00:1c.0:   bridge window [mem 0x80000000-0x801fffff]
[    0.203331] pci 0000:00:1c.0:   bridge window [mem 0x80200000-0x803fffff 64bit pref]
[    0.203577] pci 0000:02:00.0: BAR 6: assigned [mem 0x80400000-0x8041ffff pref]
[    0.203817] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.203954] pci 0000:00:1c.1:   bridge window [io  0xb000-0xbfff]
[    0.204111] pci 0000:00:1c.1:   bridge window [mem 0xd2100000-0xd21fffff]
[    0.204254] pci 0000:00:1c.1:   bridge window [mem 0x80400000-0x805fffff pref]
[    0.204499] pci 0000:03:00.0: BAR 6: assigned [mem 0x80600000-0x8061ffff pref]
[    0.204738] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
[    0.204872] pci 0000:00:1c.2:   bridge window [io  0xc000-0xcfff]
[    0.205011] pci 0000:00:1c.2:   bridge window [mem 0xd2000000-0xd20fffff]
[    0.205150] pci 0000:00:1c.2:   bridge window [mem 0x80600000-0x807fffff pref]
[    0.205388] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
[    0.205522] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.205660] pci 0000:00:1c.3:   bridge window [mem 0x80800000-0x809fffff]
[    0.205800] pci 0000:00:1c.3:   bridge window [mem 0x80a00000-0x80bfffff 64bit pref]
[    0.206040] pci 0000:00:1e.0: PCI bridge to [bus 05-05]
[    0.206173] pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
[    0.206312] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd1ffffff]
[    0.206453] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.206603] pci 0000:00:1c.0: enabling device (0100 -> 0103)
[    0.206749] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.206895] pci 0000:00:1c.0: setting latency timer to 64
[    0.206909] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.207051] pci 0000:00:1c.1: setting latency timer to 64
[    0.207065] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.207208] pci 0000:00:1c.2: setting latency timer to 64
[    0.207217] pci 0000:00:1c.3: enabling device (0100 -> 0103)
[    0.207359] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.207503] pci 0000:00:1c.3: setting latency timer to 64
[    0.207513] pci 0000:00:1e.0: setting latency timer to 64
[    0.207518] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.207522] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
[    0.207526] pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
[    0.207529] pci_bus 0000:01: resource 1 [mem 0x80000000-0x801fffff]
[    0.207533] pci_bus 0000:01: resource 2 [mem 0x80200000-0x803fffff 64bit pref]
[    0.207536] pci_bus 0000:02: resource 0 [io  0xb000-0xbfff]
[    0.207540] pci_bus 0000:02: resource 1 [mem 0xd2100000-0xd21fffff]
[    0.207543] pci_bus 0000:02: resource 2 [mem 0x80400000-0x805fffff pref]
[    0.207547] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
[    0.207550] pci_bus 0000:03: resource 1 [mem 0xd2000000-0xd20fffff]
[    0.207554] pci_bus 0000:03: resource 2 [mem 0x80600000-0x807fffff pref]
[    0.207557] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
[    0.207560] pci_bus 0000:04: resource 1 [mem 0x80800000-0x809fffff]
[    0.207564] pci_bus 0000:04: resource 2 [mem 0x80a00000-0x80bfffff 64bit pref]
[    0.207568] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]
[    0.207571] pci_bus 0000:05: resource 1 [mem 0xd0000000-0xd1ffffff]
[    0.207574] pci_bus 0000:05: resource 4 [io  0x0000-0xffff]
[    0.207578] pci_bus 0000:05: resource 5 [mem 0x00000000-0xffffffff]
[    0.207670] NET: Registered protocol family 2
[    0.208056] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.208905] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.210268] TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
[    0.217515] TCP: Hash tables configured (established 131072 bind 65536)
[    0.217734] TCP reno registered
[    0.217878] UDP hash table entries: 512 (order: 3, 40960 bytes)
[    0.218137] UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
[    0.218696] NET: Registered protocol family 1
[    0.218869] pci 0000:00:02.0: Boot video device
[    1.816018] pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
[    1.816216] PCI: CLS 32 bytes, default 64
[    1.816584] Unpacking initramfs...
[    2.149450] Freeing initrd memory: 9604k freed
[    2.158427] microcode: CPU0 sig=0x6d8, pf=0x20, revision=0x20
[    2.158609] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    2.159117] audit: initializing netlink socket (disabled)
[    2.159317] type=2000 audit(1295958157.152:1): initialized
[    2.192535] highmem bounce pool size: 64 pages
[    2.192679] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    2.193098] VFS: Disk quotas dquot_6.5.2
[    2.193305] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.194033] fuse init (API version 7.16)
[    2.194249] msgmni has been set to 1718
[    2.194702] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    2.194961] io scheduler noop registered
[    2.195095] io scheduler deadline registered
[    2.195255] io scheduler cfq registered (default)
[    2.195674] pcieport 0000:00:1c.0: setting latency timer to 64
[    2.195773] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    2.195881] pcieport 0000:00:1c.1: setting latency timer to 64
[    2.195937] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    2.196064] pcieport 0000:00:1c.2: setting latency timer to 64
[    2.196120] pcieport 0000:00:1c.2: irq 42 for MSI/MSI-X
[    2.196217] pcieport 0000:00:1c.3: setting latency timer to 64
[    2.196273] pcieport 0000:00:1c.3: irq 43 for MSI/MSI-X
[    2.196751] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    2.197059] ACPI: Power Button [PWRB]
[    2.197345] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.197587] ACPI: Power Button [PWRF]
[    2.198029] ACPI: Fan [FAN] (on)
[    2.198275] ACPI: acpi_idle registered with cpuidle
[    2.198484] ACPI: AOpen i915GMm-HFS detected: disabling all active thermal trip points
[    2.198724] ACPI: AOpen i915GMm-HFS detected: disabling all passive thermal trip points
[    2.198966] ACPI: AOpen i915GMm-HFS detected: enabling thermal zone polling
[    2.200053] thermal LNXTHERM:00: registered as thermal_zone0
[    2.200189] ACPI: Thermal Zone [THRM] (52 C)
[    2.200431] Serial: 8250/16550 driver, 8 ports, IRQ sharing enabled
[    2.221058] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.241687] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.263216] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.283845] 00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.289630] lp: driver loaded but no devices found
[    2.289914] Non-volatile memory driver v1.3
[    2.290047] Linux agpgart interface v0.103
[    2.290306] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
[    2.290528] agpgart-intel 0000:00:00.0: detected gtt size: 262144K total, 262144K mappable
[    2.291373] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
[    2.294446] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    2.294729] [drm] Initialized drm 1.1.0 20060810
[    2.294863] [drm:drm_init], 
[    2.294885] [drm:drm_get_pci_dev], 
[    2.294902] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.295045] i915 0000:00:02.0: setting latency timer to 64
[    2.297060] [drm:drm_get_minor], 
[    2.297931] [drm:drm_get_minor], new minor assigned 64
[    2.297936] [drm:drm_get_minor], 
[    2.298441] [drm:drm_get_minor], new minor assigned 0
[    2.300548] [drm:intel_opregion_setup], graphic opregion physical addr: 0x0
[    2.300553] [drm:intel_opregion_setup], ACPI OpRegion not supported!
[    2.300584] [drm:i915_init_phys_hws], Enabled hardware status page
[    2.300597] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    2.300739] [drm] Driver supports precise vblank timestamp query.
[    2.301698] [drm:parse_general_definitions], crt_ddc_bus_pin: 2
[    2.301731] [drm:parse_lfp_panel_data], Found panel mode in BIOS VBT tables:
[    2.301735] [drm:drm_mode_debug_printmodeline], Modeline 0:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x8 0xa
[    2.301807] [drm:parse_sdvo_device_mapping], the SDVO device with slave addr 70 is found on SDVOB port
[    2.301813] [drm:parse_sdvo_device_mapping], SDVO device: dvo=1, addr=70, wiring=1, ddc_pin=29, i2c_pin=5, i2c_speed=83
[    2.301819] [drm:parse_sdvo_device_mapping], the SDVO device with slave addr 72 is found on SDVOC port
[    2.301824] [drm:parse_sdvo_device_mapping], SDVO device: dvo=2, addr=72, wiring=0, ddc_pin=29, i2c_pin=5, i2c_speed=32
[    2.302066] [drm:intel_modeset_init], 2 display pipes available.
[    2.302077] [drm:intel_crtc_init], swapping pipes & planes for FBC
[    2.302087] [drm:intel_crtc_init], swapping pipes & planes for FBC
[    2.302094] [drm:intel_no_lvds_dmi_callback], Skipping LVDS initialization for AOpen i915GMm-HFS
[    2.302105] [drm:drm_sysfs_connector_add], adding "VGA-1" to sysfs
[    2.302152] [drm:drm_sysfs_hotplug_event], generating hotplug event
[    2.302168] [drm:intel_setup_outputs], probing SDVOB
[    2.412341] [drm:intel_sdvo_debug_write], SDVOB: W: 02                         (SDVO_CMD_GET_DEVICE_CAPS)
[    2.417028] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 02 3C 06 01 01 01 01 00
[    2.430807] [drm:intel_sdvo_get_capabilities], SDVO capabilities:
[    2.430813]   vendor_id: 2
[    2.430814]   device_id: 60
[    2.430815]   device_rev_id: 6
[    2.430816]   sdvo_version_major: 1
[    2.430817]   sdvo_version_minor: 1
[    2.430818]   sdvo_inputs_mask: 1
[    2.430819]   smooth_scaling: 0
[    2.430820]   sharp_scaling: 0
[    2.430821]   up_scaling: 0
[    2.430822]   down_scaling: 0
[    2.430823]   stall_support: 0
[    2.430824]   output_flags: 1
[    2.432322] [drm:intel_sdvo_debug_write], SDVOB: W: 9D                         (SDVO_CMD_GET_SUPP_ENCODE)
[    2.435276] [drm:intel_sdvo_write_cmd], command returns response Not supported [2]
[    2.435283] [drm:drm_sysfs_connector_add], adding "DVI-D-1" to sysfs
[    2.435326] [drm:drm_sysfs_hotplug_event], generating hotplug event
[    2.435341] [drm:intel_sdvo_debug_write], SDVOB: W: 10 00                      (SDVO_CMD_SET_TARGET_INPUT)
[    2.439532] [drm:intel_sdvo_debug_write], SDVOB: W: 1D                         (SDVO_CMD_GET_INPUT_PIXEL_CLOCK_RANGE)
[    2.444223] [drm:intel_sdvo_read_response], SDVOB: R: (Success) C4 09 20 4E
[    2.451109] [drm:intel_sdvo_init], SDVOB device VID/DID: 02:3C.06, clock range 25MHz - 200MHz, input 1: Y, input 2: N, output 1: Y, output 2: N
[    2.451116] [drm:intel_setup_outputs], probing SDVOC
[    2.561275] [drm:intel_sdvo_debug_write], SDVOC: W: 02                         (SDVO_CMD_GET_DEVICE_CAPS)
[    2.565952] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 02 C2 01 01 01 3D 3E 00
[    2.579730] [drm:intel_sdvo_get_capabilities], SDVO capabilities:
[    2.579735]   vendor_id: 2
[    2.579736]   device_id: 194
[    2.579737]   device_rev_id: 1
[    2.579738]   sdvo_version_major: 1
[    2.579739]   sdvo_version_minor: 1
[    2.579740]   sdvo_inputs_mask: 1
[    2.579741]   smooth_scaling: 1
[    2.579742]   sharp_scaling: 1
[    2.579743]   up_scaling: 1
[    2.579744]   down_scaling: 1
[    2.579745]   stall_support: 0
[    2.579746]   output_flags: 62
[    2.581295] [drm:drm_sysfs_connector_add], adding "SVIDEO-1" to sysfs
[    2.581342] [drm:drm_sysfs_hotplug_event], generating hotplug event
[    2.581356] [drm:intel_sdvo_debug_write], SDVOC: W: 11 08 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
[    2.586769] [drm:intel_sdvo_debug_write], SDVOC: W: 27                         (SDVO_CMD_GET_SUPPORTED_TV_FORMATS)
[    2.591454] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF FF FF FF FF 1F
[    2.601828] [drm:intel_sdvo_debug_write], SDVOC: W: 84                         (SDVO_CMD_GET_SUPPORTED_ENHANCEMENTS)
[    2.606511] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FA DF
[    2.609965] [drm:intel_sdvo_debug_write], SDVOC: W: 61                         (SDVO_CMD_GET_MAX_OVERSCAN_H)
[    2.614650] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 2F 00 20 00
[    2.621545] [drm:intel_sdvo_debug_write], SDVOC: W: 62                         (SDVO_CMD_GET_OVERSCAN_H)
[    2.626222] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 20 00
[    2.629678] [drm:intel_sdvo_create_enhance_property_tv], h_overscan: max 47, default 32, current 32
[    2.629683] [drm:intel_sdvo_debug_write], SDVOC: W: 64                         (SDVO_CMD_GET_MAX_OVERSCAN_V)
[    2.634360] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 2F 00 20 00
[    2.641257] [drm:intel_sdvo_debug_write], SDVOC: W: 65                         (SDVO_CMD_GET_OVERSCAN_V)
[    2.645941] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 20 00
[    2.649393] [drm:intel_sdvo_create_enhance_property_tv], v_overscan: max 47, default 32, current 32
[    2.649398] [drm:intel_sdvo_debug_write], SDVOC: W: 67                         (SDVO_CMD_GET_MAX_HPOS)
[    2.654074] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 03 00 02
[    2.660966] [drm:intel_sdvo_debug_write], SDVOC: W: 68                         (SDVO_CMD_GET_HPOS)
[    2.665642] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 02
[    2.669092] [drm:intel_sdvo_create_enhance_property_tv], hpos: max 1023, default 512, current 512
[    2.669097] [drm:intel_sdvo_debug_write], SDVOC: W: 6A                         (SDVO_CMD_GET_MAX_VPOS)
[    2.673781] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 03 00 02
[    2.680677] [drm:intel_sdvo_debug_write], SDVOC: W: 6B                         (SDVO_CMD_GET_VPOS)
[    2.685361] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 02
[    2.688811] [drm:intel_sdvo_create_enhance_property_tv], vpos: max 1023, default 512, current 512
[    2.688816] [drm:intel_sdvo_debug_write], SDVOC: W: 55                         (SDVO_CMD_GET_MAX_SATURATION)
[    2.693493] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 45 00
[    2.700395] [drm:intel_sdvo_debug_write], SDVOC: W: 56                         (SDVO_CMD_GET_SATURATION)
[    2.705071] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 45 00
[    2.708528] [drm:intel_sdvo_create_enhance_property_tv], saturation: max 127, default 69, current 69
[    2.708532] [drm:intel_sdvo_debug_write], SDVOC: W: 5E                         (SDVO_CMD_GET_MAX_CONTRAST)
[    2.713211] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 40 00
[    2.720108] [drm:intel_sdvo_debug_write], SDVOC: W: 5F                         (SDVO_CMD_GET_CONTRAST)
[    2.724792] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 40 00
[    2.728248] [drm:intel_sdvo_create_enhance_property_tv], contrast: max 127, default 64, current 64
[    2.728253] [drm:intel_sdvo_debug_write], SDVOC: W: 58                         (SDVO_CMD_GET_MAX_HUE)
[    2.732932] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 40 00
[    2.739818] [drm:intel_sdvo_debug_write], SDVOC: W: 59                         (SDVO_CMD_GET_HUE)
[    2.744503] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 40 00
[    2.747947] [drm:intel_sdvo_create_enhance_property_tv], hue: max 127, default 64, current 64
[    2.747952] [drm:intel_sdvo_debug_write], SDVOC: W: 6D                         (SDVO_CMD_GET_MAX_SHARPNESS)
[    2.752634] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00 04 00
[    2.759520] [drm:intel_sdvo_debug_write], SDVOC: W: 6E                         (SDVO_CMD_GET_SHARPNESS)
[    2.764202] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 04 00
[    2.767649] [drm:intel_sdvo_create_enhance_property_tv], sharpness: max 7, default 4, current 4
[    2.767654] [drm:intel_sdvo_debug_write], SDVOC: W: 5B                         (SDVO_CMD_GET_MAX_BRIGHTNESS)
[    2.772336] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 00 80 00
[    2.779221] [drm:intel_sdvo_debug_write], SDVOC: W: 5C                         (SDVO_CMD_GET_BRIGHTNESS)
[    2.783898] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 80 00
[    2.787352] [drm:intel_sdvo_create_enhance_property_tv], brightness: max 255, default 128, current 128
[    2.787358] [drm:intel_sdvo_debug_write], SDVOC: W: 7B                         (SDVO_CMD_GET_MAX_FLICKER_FILTER_ADAPTIVE)
[    2.792040] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00 07 00
[    2.798931] [drm:intel_sdvo_debug_write], SDVOC: W: 50                         (SDVO_CMD_GET_FLICKER_FILTER_ADAPTIVE)
[    2.803616] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00
[    2.807066] [drm:intel_sdvo_create_enhance_property_tv], flicker_filter_adaptive: max 7, default 7, current 7
[    2.807071] [drm:intel_sdvo_debug_write], SDVOC: W: 74                         (SDVO_CMD_GET_MAX_TV_CHROMA_FILTER)
[    2.811756] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 03 00 01 00
[    2.818654] [drm:intel_sdvo_debug_write], SDVOC: W: 75                         (SDVO_CMD_GET_TV_CHROMA_FILTER)
[    2.823337] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 01 00
[    2.826794] [drm:intel_sdvo_create_enhance_property_tv], tv_chroma_filter: max 3, default 1, current 1
[    2.826798] [drm:intel_sdvo_debug_write], SDVOC: W: 77                         (SDVO_CMD_GET_MAX_TV_LUMA_FILTER)
[    2.831475] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 02 00 00 00
[    2.838374] [drm:intel_sdvo_debug_write], SDVOC: W: 78                         (SDVO_CMD_GET_TV_LUMA_FILTER)
[    2.843058] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    2.846515] [drm:intel_sdvo_create_enhance_property_tv], tv_luma_filter: max 2, default 0, current 0
[    2.846519] [drm:intel_sdvo_debug_write], SDVOC: W: 70                         (SDVO_CMD_GET_DOT_CRAWL)
[    2.851196] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    2.854654] [drm:intel_sdvo_create_enhance_property_tv], dot crawl: current 0
[    2.854661] [drm:drm_sysfs_connector_add], adding "SVIDEO-2" to sysfs
[    2.854708] [drm:drm_sysfs_hotplug_event], generating hotplug event
[    2.854722] [drm:intel_sdvo_debug_write], SDVOC: W: 11 04 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
[    2.860139] [drm:intel_sdvo_debug_write], SDVOC: W: 27                         (SDVO_CMD_GET_SUPPORTED_TV_FORMATS)
[    2.864823] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF FF FF FF FF 1F
[    2.875164] [drm:intel_sdvo_debug_write], SDVOC: W: 84                         (SDVO_CMD_GET_SUPPORTED_ENHANCEMENTS)
[    2.879842] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FA DF
[    2.883297] [drm:intel_sdvo_debug_write], SDVOC: W: 61                         (SDVO_CMD_GET_MAX_OVERSCAN_H)
[    2.887981] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 2F 00 20 00
[    2.894877] [drm:intel_sdvo_debug_write], SDVOC: W: 62                         (SDVO_CMD_GET_OVERSCAN_H)
[    2.899554] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 20 00
[    2.903010] [drm:intel_sdvo_create_enhance_property_tv], h_overscan: max 47, default 32, current 32
[    2.903014] [drm:intel_sdvo_debug_write], SDVOC: W: 64                         (SDVO_CMD_GET_MAX_OVERSCAN_V)
[    2.907691] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 2F 00 20 00
[    2.914589] [drm:intel_sdvo_debug_write], SDVOC: W: 65                         (SDVO_CMD_GET_OVERSCAN_V)
[    2.919273] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 20 00
[    2.922727] [drm:intel_sdvo_create_enhance_property_tv], v_overscan: max 47, default 32, current 32
[    2.922732] [drm:intel_sdvo_debug_write], SDVOC: W: 67                         (SDVO_CMD_GET_MAX_HPOS)
[    2.927409] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 03 00 02
[    2.934301] [drm:intel_sdvo_debug_write], SDVOC: W: 68                         (SDVO_CMD_GET_HPOS)
[    2.938977] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 02
[    2.942434] [drm:intel_sdvo_create_enhance_property_tv], hpos: max 1023, default 512, current 512
[    2.942438] [drm:intel_sdvo_debug_write], SDVOC: W: 6A                         (SDVO_CMD_GET_MAX_VPOS)
[    2.947123] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 03 00 02
[    2.954014] [drm:intel_sdvo_debug_write], SDVOC: W: 6B                         (SDVO_CMD_GET_VPOS)
[    2.958693] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 02
[    2.962143] [drm:intel_sdvo_create_enhance_property_tv], vpos: max 1023, default 512, current 512
[    2.962147] [drm:intel_sdvo_debug_write], SDVOC: W: 55                         (SDVO_CMD_GET_MAX_SATURATION)
[    2.966832] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 45 00
[    2.973730] [drm:intel_sdvo_debug_write], SDVOC: W: 56                         (SDVO_CMD_GET_SATURATION)
[    2.978414] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 45 00
[    2.981864] [drm:intel_sdvo_create_enhance_property_tv], saturation: max 127, default 69, current 69
[    2.981868] [drm:intel_sdvo_debug_write], SDVOC: W: 5E                         (SDVO_CMD_GET_MAX_CONTRAST)
[    2.986545] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 40 00
[    2.993436] [drm:intel_sdvo_debug_write], SDVOC: W: 5F                         (SDVO_CMD_GET_CONTRAST)
[    2.998113] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 40 00
[    3.001563] [drm:intel_sdvo_create_enhance_property_tv], contrast: max 127, default 64, current 64
[    3.001568] [drm:intel_sdvo_debug_write], SDVOC: W: 58                         (SDVO_CMD_GET_MAX_HUE)
[    3.006245] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 40 00
[    3.013136] [drm:intel_sdvo_debug_write], SDVOC: W: 59                         (SDVO_CMD_GET_HUE)
[    3.017812] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 40 00
[    3.021263] [drm:intel_sdvo_create_enhance_property_tv], hue: max 127, default 64, current 64
[    3.021267] [drm:intel_sdvo_debug_write], SDVOC: W: 6D                         (SDVO_CMD_GET_MAX_SHARPNESS)
[    3.025944] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00 04 00
[    3.032837] [drm:intel_sdvo_debug_write], SDVOC: W: 6E                         (SDVO_CMD_GET_SHARPNESS)
[    3.037513] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 04 00
[    3.040966] [drm:intel_sdvo_create_enhance_property_tv], sharpness: max 7, default 4, current 4
[    3.040971] [drm:intel_sdvo_debug_write], SDVOC: W: 5B                         (SDVO_CMD_GET_MAX_BRIGHTNESS)
[    3.045648] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 00 80 00
[    3.052547] [drm:intel_sdvo_debug_write], SDVOC: W: 5C                         (SDVO_CMD_GET_BRIGHTNESS)
[    3.057223] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 80 00
[    3.060678] [drm:intel_sdvo_create_enhance_property_tv], brightness: max 255, default 128, current 128
[    3.060683] [drm:intel_sdvo_debug_write], SDVOC: W: 7B                         (SDVO_CMD_GET_MAX_FLICKER_FILTER_ADAPTIVE)
[    3.065362] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00 07 00
[    3.072253] [drm:intel_sdvo_debug_write], SDVOC: W: 50                         (SDVO_CMD_GET_FLICKER_FILTER_ADAPTIVE)
[    3.076932] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00
[    3.080382] [drm:intel_sdvo_create_enhance_property_tv], flicker_filter_adaptive: max 7, default 7, current 7
[    3.080387] [drm:intel_sdvo_debug_write], SDVOC: W: 74                         (SDVO_CMD_GET_MAX_TV_CHROMA_FILTER)
[    3.085071] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 03 00 01 00
[    3.091963] [drm:intel_sdvo_debug_write], SDVOC: W: 75                         (SDVO_CMD_GET_TV_CHROMA_FILTER)
[    3.096653] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 01 00
[    3.100108] [drm:intel_sdvo_create_enhance_property_tv], tv_chroma_filter: max 3, default 1, current 1
[    3.100112] [drm:intel_sdvo_debug_write], SDVOC: W: 77                         (SDVO_CMD_GET_MAX_TV_LUMA_FILTER)
[    3.104793] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 02 00 00 00
[    3.111684] [drm:intel_sdvo_debug_write], SDVOC: W: 78                         (SDVO_CMD_GET_TV_LUMA_FILTER)
[    3.116374] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.119818] [drm:intel_sdvo_create_enhance_property_tv], tv_luma_filter: max 2, default 0, current 0
[    3.119823] [drm:intel_sdvo_debug_write], SDVOC: W: 70                         (SDVO_CMD_GET_DOT_CRAWL)
[    3.124505] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.127950] [drm:intel_sdvo_create_enhance_property_tv], dot crawl: current 0
[    3.127956] [drm:drm_sysfs_connector_add], adding "VGA-2" to sysfs
[    3.128017] [drm:drm_sysfs_hotplug_event], generating hotplug event
[    3.128032] [drm:intel_sdvo_debug_write], SDVOC: W: 10 00                      (SDVO_CMD_SET_TARGET_INPUT)
[    3.132223] [drm:intel_sdvo_debug_write], SDVOC: W: 1D                         (SDVO_CMD_GET_INPUT_PIXEL_CLOCK_RANGE)
[    3.136900] [drm:intel_sdvo_read_response], SDVOC: R: (Success) C4 09 D8 40
[    3.143791] [drm:intel_sdvo_init], SDVOC device VID/DID: 02:C2.01, clock range 25MHz - 166MHz, input 1: Y, input 2: N, output 1: Y, output 2: N
[    3.143848] [drm:drm_sysfs_connector_add], adding "SVIDEO-3" to sysfs
[    3.143894] [drm:drm_sysfs_hotplug_event], generating hotplug event
[    3.143909] [drm:intel_panel_get_backlight], get backlight PWM = 31250
[    3.143921] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    3.144719] [drm] initialized overlay support
[    3.144850] [drm:drm_irq_install], irq=16
[    3.144897] [drm:intel_sdvo_debug_write], SDVOB: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    3.150311] [drm:intel_sdvo_debug_write], SDVOC: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    3.155837] [drm:drm_calc_vbltimestamp_from_scanoutpos], crtc 0: Noop due to uninitialized mode.
[    3.156106] Refined TSC clocksource calibration: 1862.713 MHz.
[    3.156249] Switching to clocksource tsc
[    3.165952] [drm:intel_update_fbc], 
[    3.165956] [drm:intel_update_watermarks], plane A (pipe 1) clock: 0
[    3.165961] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    3.165965] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    3.165969] [drm:intel_calculate_wm], FIFO entries required for mode: 0
[    3.165973] [drm:intel_calculate_wm], FIFO watermark level: 26
[    3.165976] [drm:intel_calculate_wm], FIFO entries required for mode: 0
[    3.165980] [drm:intel_calculate_wm], FIFO watermark level: 29
[    3.165983] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 29
[    3.165988] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 29, C: 2, SR 1
[    3.165994] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[    3.165999] [drm:drm_calc_vbltimestamp_from_scanoutpos], crtc 1: Noop due to uninitialized mode.
[    3.166003] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[    3.166009] [drm:intel_update_fbc], 
[    3.166016] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[    3.169975] [drm:drm_crtc_helper_set_mode], [CRTC:3]
[    3.169980] [drm:intel_sdvo_debug_write], SDVOB: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    3.175391] [drm:intel_sdvo_debug_write], SDVOC: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    3.180806] [drm:drm_vblank_get], enabling vblank on crtc 0, ret: -22
[    3.181009] [drm:intel_crtc_mode_set], Mode for pipe A:
[    3.181013] [drm:drm_mode_debug_printmodeline], Modeline 0:"640x480" 0 31500 640 664 704 832 480 489 491 520 0x10 0xa
[    3.188012] [drm:intel_pipe_set_base], No FB bound
[    3.188017] [drm:drm_crtc_helper_set_mode], [ENCODER:6:DAC-6] set [MODE:0:640x480]
[    3.188022] [drm:intel_update_watermarks], plane B (pipe 0) clock: 31500
[    3.188026] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    3.188030] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    3.188034] [drm:intel_calculate_wm], FIFO entries required for mode: 0
[    3.188038] [drm:intel_calculate_wm], FIFO watermark level: 26
[    3.188041] [drm:intel_calculate_wm], FIFO entries required for mode: 10
[    3.188045] [drm:intel_calculate_wm], FIFO watermark level: 19
[    3.188048] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 19
[    3.188052] [drm:i9xx_update_wm], self-refresh entries: 40
[    3.188056] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 19, C: 2, SR 55
[    3.188240] [drm:intel_update_fbc], 
[    3.188244] [drm:drm_calc_timestamping_constants], crtc 3: hwmode: htotal 832, vtotal 520, vdisplay 480
[    3.188249] [drm:drm_calc_timestamping_constants], crtc 3: clock 31500 kHz framedur 13734240 linedur 26412, pixeldur 31
[    3.199951] [drm:intel_crt_load_detect], starting load-detect on CRT
[    3.212010] [drm:intel_sdvo_debug_write], SDVOB: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    3.217425] [drm:intel_sdvo_debug_write], SDVOC: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    3.222835] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1] disconnected
[    3.222840] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1]
[    3.222844] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[    3.227521] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    3.230972] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[    3.230976] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    3.236887] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    3.292050] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    3.297952] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    3.353130] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1] probed modes :
[    3.353134] [drm:drm_mode_debug_printmodeline], Modeline 61:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    3.353141] [drm:drm_mode_debug_printmodeline], Modeline 65:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[    3.353148] [drm:drm_mode_debug_printmodeline], Modeline 62:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[    3.353154] [drm:drm_mode_debug_printmodeline], Modeline 63:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[    3.353161] [drm:drm_mode_debug_printmodeline], Modeline 64:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[    3.353168] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:SVIDEO-1]
[    3.353172] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[    3.361295] [drm:intel_sdvo_write_cmd], command returns response Pending [4]
[    3.361300] [drm:intel_sdvo_debug_write], SDVOC: W: 11 00 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
[    3.366712] [drm:intel_sdvo_write_cmd], command returns response Invalid arg [3]
[    3.366717] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:SVIDEO-2]
[    3.366721] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[    3.374841] [drm:intel_sdvo_write_cmd], command returns response Pending [4]
[    3.374845] [drm:intel_sdvo_debug_write], SDVOC: W: 11 00 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
[    3.380263] [drm:intel_sdvo_write_cmd], command returns response Invalid arg [3]
[    3.380268] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:44:VGA-2]
[    3.380272] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[    3.388392] [drm:intel_sdvo_write_cmd], command returns response Pending [4]
[    3.388397] [drm:intel_sdvo_debug_write], SDVOC: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    3.396528] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:45:SVIDEO-3]
[    3.396535] [drm:drm_crtc_helper_set_mode], [CRTC:3]
[    3.396539] [drm:intel_sdvo_debug_write], SDVOB: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    3.401950] [drm:intel_sdvo_debug_write], SDVOC: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    3.407363] [drm:drm_calc_vbltimestamp_from_scanoutpos], crtc 0 : v 5 p(117,198)@ 1295958158.407366 -> 1295958158.402132 [e 1 us, 0 rep]
[    3.422407] [drm:intel_update_fbc], 
[    3.422411] [drm:drm_vblank_get], enabling vblank on crtc 0, ret: -22
[    3.422613] [drm:intel_crtc_mode_set], Mode for pipe A:
[    3.422616] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[    3.428010] [drm:intel_pipe_set_base], No FB bound
[    3.428014] [drm:drm_crtc_helper_set_mode], [ENCODER:46:TV-46] set [MODE:0:NTSC 480i]
[    3.447892] [drm:intel_update_watermarks], plane B (pipe 0) clock: 107520
[    3.447896] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    3.447900] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    3.447904] [drm:intel_calculate_wm], FIFO entries required for mode: 0
[    3.447908] [drm:intel_calculate_wm], FIFO watermark level: 26
[    3.447911] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[    3.447915] [drm:intel_calculate_wm], FIFO watermark level: -5
[    3.447919] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 1
[    3.447922] [drm:i9xx_update_wm], self-refresh entries: 80
[    3.447926] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 1, C: 2, SR 15
[    3.447970] [drm:intel_update_fbc], 
[    3.447973] [drm:drm_calc_timestamping_constants], crtc 3: hwmode: htotal 1712, vtotal 1104, vdisplay 1024
[    3.447978] [drm:drm_calc_timestamping_constants], crtc 3: clock 108000 kHz framedur 17499504 linedur 15851, pixeldur 9
[    3.524011] [drm:intel_sdvo_debug_write], SDVOB: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    3.529425] [drm:intel_sdvo_debug_write], SDVOC: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    3.534834] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:45:SVIDEO-3] disconnected
[    3.534839] [drm:drm_setup_crtcs], 
[    3.534843] [drm:drm_enable_connectors], connector 5 enabled? no
[    3.534847] [drm:drm_enable_connectors], connector 8 enabled? yes
[    3.534851] [drm:drm_enable_connectors], connector 10 enabled? no
[    3.534854] [drm:drm_enable_connectors], connector 27 enabled? no
[    3.534858] [drm:drm_enable_connectors], connector 44 enabled? no
[    3.534862] [drm:drm_enable_connectors], connector 45 enabled? no
[    3.534865] [drm:drm_target_preferred], looking for cmdline mode on connector 8
[    3.534870] [drm:drm_target_preferred], looking for preferred mode on connector 8
[    3.534874] [drm:drm_target_preferred], found mode 1280x1024
[    3.534877] [drm:drm_setup_crtcs], picking CRTCs for 4096x4096 config
[    3.534882] [drm:drm_setup_crtcs], desired mode 1280x1024 set on crtc 3
[    3.545231] [drm:intelfb_create], allocated 1280x1024 fb: 0x00020000, bo f53998c0
[    3.547992] [drm:drm_crtc_helper_set_config], 
[    3.548014] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:67] #connectors=1 (x y) (0 0)
[    3.548025] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[    3.548028] [drm:drm_crtc_helper_set_config], modes are different, full mode set
[    3.548031] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[    3.548037] [drm:drm_mode_debug_printmodeline], Modeline 66:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    3.548044] [drm:drm_crtc_helper_set_config], encoder changed, full mode switch
[    3.548047] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[    3.548050] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:3]
[    3.548054] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[    3.548057] [drm:drm_mode_debug_printmodeline], Modeline 66:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    3.548069] [drm:drm_crtc_helper_set_mode], [CRTC:3]
[    3.548072] [drm:intel_sdvo_debug_write], SDVOB: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    3.553481] [drm:intel_sdvo_debug_write], SDVOC: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    3.558925] [drm:drm_calc_vbltimestamp_from_scanoutpos], crtc 0 : v 5 p(1119,424)@ 1295958158.558927 -> 1295958158.552196 [e 2 us, 0 rep]
[    3.573970] [drm:intel_update_fbc], 
[    3.573975] [drm:drm_vblank_get], enabling vblank on crtc 0, ret: -22
[    3.574221] [drm:intel_crtc_mode_set], Mode for pipe A:
[    3.574223] [drm:drm_mode_debug_printmodeline], Modeline 66:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    3.580046] [drm:intel_pipe_set_base_atomic], Writing base 00020000 00000000 0 0 5120
[    3.580051] [drm:intel_update_fbc], 
[    3.580055] [drm:drm_crtc_helper_set_mode], [ENCODER:7:TMDS-7] set [MODE:66:1280x1024]
[    3.580059] [drm:intel_sdvo_debug_write], SDVOB: W: 07 01 00 00 00             (SDVO_CMD_SET_IN_OUT_MAP)
[    3.587916] [drm:intel_sdvo_debug_write], SDVOB: W: 11 01 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
[    3.593328] [drm:intel_sdvo_debug_write], SDVOB: W: 11 01 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
[    3.598735] [drm:intel_sdvo_debug_write], SDVOB: W: 16 30 2A 00 98 51 00 2A 40 (SDVO_CMD_SET_OUTPUT_TIMINGS_PART1)
[    3.611497] [drm:intel_sdvo_debug_write], SDVOB: W: 17 30 70 13 00 1E 00 00 00 (SDVO_CMD_SET_OUTPUT_TIMINGS_PART2)
[    3.624265] [drm:intel_sdvo_debug_write], SDVOB: W: 10 00                      (SDVO_CMD_SET_TARGET_INPUT)
[    3.628447] [drm:intel_sdvo_debug_write], SDVOB: W: 9F 00                      (SDVO_CMD_SET_ENCODE)
[    3.632630] [drm:intel_sdvo_write_cmd], command returns response Not supported [2]
[    3.632633] [drm:intel_sdvo_debug_write], SDVOB: W: 14 30 2A 00 98 51 00 2A 40 (SDVO_CMD_SET_INPUT_TIMINGS_PART1)
[    3.645394] [drm:intel_sdvo_debug_write], SDVOB: W: 15 30 70 13 00 1E 00 00 00 (SDVO_CMD_SET_INPUT_TIMINGS_PART2)
[    3.658398] [drm:intel_sdvo_debug_write], SDVOB: W: 21 01                      (SDVO_CMD_SET_CLOCK_RATE_MULT)
[    3.662586] [drm:intel_update_watermarks], plane B (pipe 0) clock: 108000
[    3.662590] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    3.662594] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    3.662597] [drm:intel_calculate_wm], FIFO entries required for mode: 0
[    3.662600] [drm:intel_calculate_wm], FIFO watermark level: 26
[    3.662603] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[    3.662606] [drm:intel_calculate_wm], FIFO watermark level: -5
[    3.662609] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 1
[    3.662612] [drm:i9xx_update_wm], self-refresh entries: 80
[    3.662615] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 1, C: 2, SR 15
[    3.662787] [drm:intel_update_fbc], 
[    3.692009] [drm:intel_sdvo_debug_write], SDVOB: W: 03                         (SDVO_CMD_GET_TRAINED_INPUTS)
[    3.696683] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01
[    3.698405] [drm:intel_sdvo_debug_write], SDVOB: W: 05 01 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    3.703809] [drm:drm_calc_timestamping_constants], crtc 3: hwmode: htotal 1688, vtotal 1066, vdisplay 1024
[    3.703813] [drm:drm_calc_timestamping_constants], crtc 3: clock 108000 kHz framedur 16660514 linedur 15629, pixeldur 9
[    3.703825] [drm:intel_sdvo_debug_write], SDVOC: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    3.709236] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[    3.709239] [drm:drm_crtc_helper_set_config], 	[CONNECTOR:8:DVI-D-1] set DPMS on
[    3.709244] [drm:drm_crtc_helper_set_config], 
[    3.709246] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:67] #connectors=0 (x y) (0 0)
[    3.709254] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[    3.709257] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:3]
[    3.709261] [drm:intel_sdvo_debug_write], SDVOC: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    3.714671] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[    3.714702] [drm:drm_crtc_helper_set_config], 
[    3.714704] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:67] #connectors=1 (x y) (0 0)
[    3.714713] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:3]
[    3.714717] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[    3.714720] [drm:drm_crtc_helper_set_config], 	[CONNECTOR:8:DVI-D-1] set DPMS on
[    3.721758] [drm:drm_crtc_helper_set_config], 
[    3.721760] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:67] #connectors=1 (x y) (0 0)
[    3.721769] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:3]
[    3.721772] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[    3.721775] [drm:drm_crtc_helper_set_config], 	[CONNECTOR:8:DVI-D-1] set DPMS on
[    3.728740] Console: switching to colour frame buffer device 160x64
[    3.728748] [drm:drm_crtc_helper_set_config], 
[    3.728750] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:67] #connectors=1 (x y) (0 0)
[    3.728758] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:3]
[    3.728762] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[    3.728765] [drm:drm_crtc_helper_set_config], 	[CONNECTOR:8:DVI-D-1] set DPMS on
[    3.735818] fb0: inteldrmfb frame buffer device
[    3.735860] drm: registered panic notifier
[    3.736108] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    3.736613] parport_pc 00:08: reported by Plug and Play ACPI
[    3.736764] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
[    3.832458] lp0: using parport0 (interrupt-driven).
[    3.834028] loop: module loaded
[    3.834060] Uniform Multi-Platform E-IDE driver
[    3.834188] piix 0000:00:1f.1: IDE controller (0x8086:0x266f rev 0x04)
[    3.834263] PIIX_IDE 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.834338] piix 0000:00:1f.1: IDE port disabled
[    3.834457] piix 0000:00:1f.1: not 100% native mode: will probe irqs later
[    3.834524]     ide0: BM-DMA at 0xf000-0xf007
[    3.834570] Probing IDE interface ide0...
[    4.568208] hda: PLEXTOR DVDR PX-755A, ATAPI CD/DVD-ROM drive
[    4.904157] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    4.904278] hda: UDMA/66 mode selected
[    4.904418] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    4.906846] ide-gd driver 1.18
[    4.906909] ide-cd driver 5.00
[    4.907663] ide-cd: hda: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
[    4.907765] cdrom: Uniform CD-ROM driver Revision: 3.20
[    4.920739] ata_piix 0000:00:1f.2: version 2.13
[    4.920754] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    4.920823] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
[    4.920989] ata_piix 0000:00:1f.2: setting latency timer to 64
[    4.921909] scsi0 : ata_piix
[    4.922242] scsi1 : ata_piix
[    4.922363] ata1: SATA max UDMA/133 cmd 0xe500 ctl 0xe600 bmdma 0xe900 irq 19
[    4.922428] ata2: SATA max UDMA/133 cmd 0xe700 ctl 0xe800 bmdma 0xe908 irq 19
[    4.922572] sky2: driver version 1.28
[    4.922642] sky2 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    4.922712] sky2 0000:02:00.0: setting latency timer to 64
[    4.922738] sky2 0000:02:00.0: Yukon-2 EC chip revision 1
[    4.922923] sky2 0000:02:00.0: irq 44 for MSI/MSI-X
[    4.924167] sky2 0000:02:00.0: eth0: addr 00:01:80:62:25:4b
[    4.924239] sky2 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    4.924309] sky2 0000:03:00.0: setting latency timer to 64
[    4.924334] sky2 0000:03:00.0: Yukon-2 EC chip revision 1
[    4.924493] sky2 0000:03:00.0: irq 45 for MSI/MSI-X
[    4.925139] sky2 0000:03:00.0: eth1: addr 00:01:80:62:25:4c
[    4.925225] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.925335] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    4.925411] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.925417] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.925656] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    4.929694] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    4.929719] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xd2344000
[    4.944023] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.946313] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    4.948399] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.950495] usb usb1: Product: EHCI Host Controller
[    4.952608] usb usb1: Manufacturer: Linux 2.6.38-rc2-kape ehci_hcd
[    4.954739] usb usb1: SerialNumber: 0000:00:1d.7
[    4.957481] hub 1-0:1.0: USB hub found
[    4.959679] hub 1-0:1.0: 8 ports detected
[    4.962151] uhci_hcd: USB Universal Host Controller Interface driver
[    4.964396] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    4.966647] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.966652] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.968917] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    4.971233] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e000
[    4.973633] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    4.975958] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.978328] usb usb2: Product: UHCI Host Controller
[    4.980703] usb usb2: Manufacturer: Linux 2.6.38-rc2-kape uhci_hcd
[    4.983101] usb usb2: SerialNumber: 0000:00:1d.0
[    4.985717] hub 2-0:1.0: USB hub found
[    4.988152] hub 2-0:1.0: 2 ports detected
[    4.990667] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    4.993094] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.993099] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.995501] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    4.997937] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e100
[    5.000392] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    5.002783] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.005207] usb usb3: Product: UHCI Host Controller
[    5.007617] usb usb3: Manufacturer: Linux 2.6.38-rc2-kape uhci_hcd
[    5.010008] usb usb3: SerialNumber: 0000:00:1d.1
[    5.012560] hub 3-0:1.0: USB hub found
[    5.014915] hub 3-0:1.0: 2 ports detected
[    5.017322] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    5.019659] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    5.019664] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.022006] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    5.024409] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e200
[    5.026807] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    5.029133] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.031455] usb usb4: Product: UHCI Host Controller
[    5.033756] usb usb4: Manufacturer: Linux 2.6.38-rc2-kape uhci_hcd
[    5.036066] usb usb4: SerialNumber: 0000:00:1d.2
[    5.038516] hub 4-0:1.0: USB hub found
[    5.040836] hub 4-0:1.0: 2 ports detected
[    5.043218] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    5.045570] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    5.045575] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    5.047897] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    5.050255] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000e300
[    5.052637] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    5.054939] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.057255] usb usb5: Product: UHCI Host Controller
[    5.059584] usb usb5: Manufacturer: Linux 2.6.38-rc2-kape uhci_hcd
[    5.062176] usb usb5: SerialNumber: 0000:00:1d.3
[    5.064692] hub 5-0:1.0: USB hub found
[    5.067013] hub 5-0:1.0: 2 ports detected
[    5.069500] usbcore: registered new interface driver usblp
[    5.071810] Initializing USB Mass Storage driver...
[    5.074194] usbcore: registered new interface driver usb-storage
[    5.076538] USB Mass Storage support registered.
[    5.078952] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    5.081596] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    5.095699] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.098500] mousedev: PS/2 mouse device common for all mice
[    5.101624] input: PC Speaker as /devices/platform/pcspkr/input/input2
[    5.104333] rtc_cmos 00:03: RTC can wake from S4
[    5.107176] ata1.00: ATA-7: HDT722525DLA380, V44OA91A, max UDMA/133
[    5.109731] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    5.112527] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    5.115043] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    5.117699] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    5.120253] ata1.01: ATA-8: ST31000340NS, SN05, max UDMA/133
[    5.122788] ata1.01: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    5.125543] w83627hf: w83627hf: Found W83627THF chip at 0x290
[    5.128139] ACPI: resource w83627hf [io  0x0295-0x0296] conflicts with ACPI region SEN1 [io 0x295-0x296]
[    5.130740] ACPI: This conflict may cause random problems and system instability
[    5.133502] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.136696] device-mapper: uevent: version 1.0.3
[    5.139613] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    5.142650] ata1.00: configured for UDMA/133
[    5.145496] device-mapper: ioctl: 4.19.1-ioctl (2011-01-07) initialised: dm-devel@redhat.com
[    5.148302] cpuidle: using governor ladder
[    5.151022] cpuidle: using governor menu
[    5.154631] usbcore: registered new interface driver usbhid
[    5.157353] usbhid: USB HID core driver
[    5.160710] ata1.01: configured for UDMA/133
[    5.174609] RME Digi96 0000:05:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    5.178000] scsi 0:0:0:0: Direct-Access     ATA      HDT722525DLA380  V44O PQ: 0 ANSI: 5
[    5.181534] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    5.184477] sd 0:0:0:0: [sda] Write Protect is off
[    5.187292] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.187829] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.192897] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.195779] HDA Intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[    5.195806] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    5.195879] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.199924] scsi 0:0:1:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    5.203619] sd 0:0:1:0: Attached scsi generic sg1 type 0
[    5.220385] sd 0:0:1:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    5.227194] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input4
[    5.233698] usbcore: registered new interface driver snd-usb-audio
[    5.236677] ALSA device list:
[    5.239634]   #0: Virtual MIDI Card 1
[    5.242580]   #1: RME Digi96/8 PAD at 0xd0000000, irq 17
[    5.245643]   #2: HDA Intel at 0xd2340000 irq 46
[    5.249463] TCP cubic registered
[    5.253313] Using IPI Shortcut mode
[    5.256407] registered taskstats version 1
[    5.259993] rtc_cmos 00:03: setting system clock to 2011-01-25 12:22:40 UTC (1295958160)
[    5.262989] BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
[    5.272227]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
[    5.275963] sd 0:0:1:0: [sdb] Write Protect is off
[    5.279031] Marking TSC unstable due to cpufreq changes
[    5.282029] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    5.282100] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.285180] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.288918] Switching to clocksource hpet
[    5.360111]  sdb: sdb1 sdb2 sdb4 < sdb5 sdb6 sdb7 sdb8 sdb9 >
[    5.368249] sd 0:0:1:0: [sdb] Attached SCSI disk
[    5.374738] Freeing unused kernel memory: 336k freed
[    5.381561] Write protecting the kernel text: 3548k
[    5.385219] Write protecting the kernel read-only data: 1712k
[    5.440080] usb 1-4: new high speed USB device using ehci_hcd and address 4
[    5.532259] udev: starting version 157
[    5.535144] udevd (80): /proc/80/oom_adj is deprecated, please use /proc/80/oom_score_adj instead.
[    5.584843] usb 1-4: New USB device found, idVendor=04b8, idProduct=011b
[    5.587687] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.667192] usb 1-4: Product: EPSON Scanner
[    5.727571] usb 1-4: Manufacturer: EPSON
[    6.032051] usb 2-2: new low speed USB device using uhci_hcd and address 2
[    6.238890] usb 2-2: New USB device found, idVendor=046d, idProduct=c50e
[    6.241660] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.244446] usb 2-2: Product: USB RECEIVER
[    6.247067] usb 2-2: Manufacturer: Logitech
[    6.273893] input: Logitech USB RECEIVER as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input5
[    6.285690] generic-usb 0003:046D:C50E.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB RECEIVER] on usb-0000:00:1d.0-2/input0
[    6.528054] usb 3-1: new full speed USB device using uhci_hcd and address 2
[    6.724654] usb 3-1: New USB device found, idVendor=03f0, idProduct=1d17
[    6.731492] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    6.740425] usb 3-1: Product: hp LaserJet 1320 series
[    6.747737] [drm:output_poll_execute], [CONNECTOR:5:VGA-1] status updated from 2 to 2
[    6.747750] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[    6.752586] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01
[    6.756040] usb 3-1: Manufacturer: Hewlett-Packard
[    6.762622]  00
[    6.768627] usb 3-1: SerialNumber: 00CNHW646GZH
[    6.774246] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[    6.774258] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    6.787350] usblp0: USB Bidirectional printer dev 2 if 0 alt 1 proto 2 vid 0x03F0 pid 0x1D17
[    6.793856] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    6.860947] [drm:output_poll_execute], [CONNECTOR:8:DVI-D-1] status updated from 1 to 1
[    6.860961] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[    6.871234] [drm:intel_sdvo_write_cmd], command returns response Pending [4]
[    6.871247] [drm:output_poll_execute], [CONNECTOR:44:VGA-2] status updated from 3 to 3
[    7.558365] REISERFS (device sdb5): found reiserfs format "3.6" with standard journal
[    7.561076] REISERFS (device sdb5): using ordered data mode
[    7.573399] REISERFS (device sdb5): journal params: device sdb5, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[    7.579696] REISERFS (device sdb5): checking transaction log (sdb5)
[    7.613635] REISERFS (device sdb5): Using r5 hash to sort names
[    9.285235] udev: starting version 157
[    9.883424] [drm:output_poll_execute], [CONNECTOR:5:VGA-1] status updated from 2 to 2
[    9.883432] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[    9.907086] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    9.910555] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[    9.910561] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    9.918130] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    9.979344] [drm:output_poll_execute], [CONNECTOR:8:DVI-D-1] status updated from 1 to 1
[    9.979351] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[    9.987472] [drm:intel_sdvo_write_cmd], command returns response Pending [4]
[    9.987477] [drm:output_poll_execute], [CONNECTOR:44:VGA-2] status updated from 3 to 3
[   12.996176] [drm:output_poll_execute], [CONNECTOR:5:VGA-1] status updated from 2 to 2
[   12.996186] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   13.001082] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[   13.004797] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[   13.004804] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   13.010731] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   13.102532] [drm:output_poll_execute], [CONNECTOR:8:DVI-D-1] status updated from 1 to 1
[   13.102542] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   13.118708] [drm:intel_sdvo_write_cmd], command returns response Pending [4]
[   13.118715] [drm:output_poll_execute], [CONNECTOR:44:VGA-2] status updated from 3 to 3
[   13.140129] NET: Registered protocol family 10
[   13.193676] Adding 963896k swap on /dev/sda2.  Priority:-1 extents:1 across:963896k 
[   13.208323] Adding 4200992k swap on /dev/sdb2.  Priority:-2 extents:1 across:4200992k 
[   14.245965] REISERFS (device sda7): found reiserfs format "3.6" with standard journal
[   14.248771] REISERFS (device sda7): using ordered data mode
[   14.251738] REISERFS (device sda7): journal params: device sda7, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   14.257809] REISERFS (device sda7): checking transaction log (sda7)
[   14.307502] REISERFS (device sda7): Using r5 hash to sort names
[   16.124593] [drm:output_poll_execute], [CONNECTOR:5:VGA-1] status updated from 2 to 2
[   16.124600] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   16.129344] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[   16.132804] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[   16.132810] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   16.138719] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   16.204514] [drm:output_poll_execute], [CONNECTOR:8:DVI-D-1] status updated from 1 to 1
[   16.204521] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   16.212643] [drm:intel_sdvo_write_cmd], command returns response Pending [4]
[   16.212648] [drm:output_poll_execute], [CONNECTOR:44:VGA-2] status updated from 3 to 3
[   17.776370] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   17.933793] ip_tables: (C) 2000-2006 Netfilter Core Team
[   18.031846] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   18.781039] [drm:drm_crtc_helper_set_config], 
[   18.781047] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:67] #connectors=1 (x y) (0 0)
[   18.781074] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:3]
[   18.781082] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[   18.781090] [drm:drm_crtc_helper_set_config], 	[CONNECTOR:8:DVI-D-1] set DPMS on
[   19.219984] [drm:output_poll_execute], [CONNECTOR:5:VGA-1] status updated from 2 to 2
[   19.219990] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   19.232185] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[   19.235630] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[   19.235636] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   19.248343] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   19.367713] [drm:output_poll_execute], [CONNECTOR:8:DVI-D-1] status updated from 1 to 1
[   19.367721] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   19.383860] [drm:intel_sdvo_write_cmd], command returns response Pending [4]
[   19.383867] [drm:output_poll_execute], [CONNECTOR:44:VGA-2] status updated from 3 to 3
[   21.243913] sky2 0000:02:00.0: eth0: enabling interface
[   21.247010] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   22.205089] sky2 0000:03:00.0: eth1: enabling interface
[   22.207741] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   22.392989] [drm:output_poll_execute], [CONNECTOR:5:VGA-1] status updated from 2 to 2
[   22.392996] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   22.398023] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[   22.405476] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[   22.405482] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   22.413005] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   22.521484] [drm:output_poll_execute], [CONNECTOR:8:DVI-D-1] status updated from 1 to 1
[   22.521491] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   22.537246] [drm:intel_sdvo_write_cmd], command returns response Pending [4]
[   22.537253] [drm:output_poll_execute], [CONNECTOR:44:VGA-2] status updated from 3 to 3
[   23.624684] sky2 0000:02:00.0: eth0: Link is up at 1000 Mbps, full duplex, flow control both
[   23.624933] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   25.041900] PPP generic driver version 2.4.2
[   25.121952] NET: Registered protocol family 17
[   25.553427] [drm:output_poll_execute], [CONNECTOR:5:VGA-1] status updated from 2 to 2
[   25.553442] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   25.563230] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[   25.572364] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[   25.572376] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   25.580845] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   25.674565] [drm:output_poll_execute], [CONNECTOR:8:DVI-D-1] status updated from 1 to 1
[   25.674581] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   25.685875] [drm:intel_sdvo_write_cmd], command returns response Pending [4]
[   25.685889] [drm:output_poll_execute], [CONNECTOR:44:VGA-2] status updated from 3 to 3
[   28.692090] [drm:output_poll_execute], [CONNECTOR:5:VGA-1] status updated from 2 to 2
[   28.692105] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   28.697421] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[   28.701025] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[   28.701036] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   28.707704] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   28.764158] [drm:output_poll_execute], [CONNECTOR:8:DVI-D-1] status updated from 1 to 1
[   28.764171] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   28.773004] [drm:intel_sdvo_write_cmd], command returns response Pending [4]
[   28.773016] [drm:output_poll_execute], [CONNECTOR:44:VGA-2] status updated from 3 to 3
[   31.780090] [drm:output_poll_execute], [CONNECTOR:5:VGA-1] status updated from 2 to 2
[   31.780104] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   31.785534] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[   31.789146] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[   31.789157] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   31.795903] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   31.852286] [drm:output_poll_execute], [CONNECTOR:8:DVI-D-1] status updated from 1 to 1
[   31.852299] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   31.861115] [drm:intel_sdvo_write_cmd], command returns response Pending [4]
[   31.861127] [drm:output_poll_execute], [CONNECTOR:44:VGA-2] status updated from 3 to 3
[   31.879533] SFW2-INint-ACC-TCP IN=eth0 OUT= MAC=00:01:80:62:25:4b:00:01:80:62:cf:b1:08:00 SRC=192.168.22.31 DST=192.168.24.15 LEN=60 TOS=0x00 PREC=0x00 TTL=64 ID=55448 DF PROTO=TCP SPT=41022 DPT=8765 WINDOW=4380 RES=0x00 SYN URGP=0 OPT (020405B40402080A00272B320000000001030306) 
[   34.624027] eth0: no IPv6 routers present
[   34.868224] [drm:output_poll_execute], [CONNECTOR:5:VGA-1] status updated from 2 to 2
[   34.868239] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   34.873673] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[   34.877287] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[   34.877299] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   34.891070] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   34.979575] [drm:output_poll_execute], [CONNECTOR:8:DVI-D-1] status updated from 1 to 1
[   34.979590] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   34.999957] [drm:intel_sdvo_write_cmd], command returns response Pending [4]
[   34.999971] [drm:output_poll_execute], [CONNECTOR:44:VGA-2] status updated from 3 to 3
[   38.004094] [drm:output_poll_execute], [CONNECTOR:5:VGA-1] status updated from 2 to 2
[   38.004108] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   38.009538] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[   38.013156] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[   38.013167] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   38.019912] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   38.077006] [drm:output_poll_execute], [CONNECTOR:8:DVI-D-1] status updated from 1 to 1
[   38.077019] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   38.085925] [drm:intel_sdvo_write_cmd], command returns response Pending [4]
[   38.085938] [drm:output_poll_execute], [CONNECTOR:44:VGA-2] status updated from 3 to 3
[   41.092088] [drm:output_poll_execute], [CONNECTOR:5:VGA-1] status updated from 2 to 2
[   41.092102] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   41.097464] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[   41.101068] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[   41.101079] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   41.107739] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   41.164117] [drm:output_poll_execute], [CONNECTOR:8:DVI-D-1] status updated from 1 to 1
[   41.164130] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   41.172940] [drm:intel_sdvo_write_cmd], command returns response Pending [4]
[   41.172952] [drm:output_poll_execute], [CONNECTOR:44:VGA-2] status updated from 3 to 3
[   44.180088] [drm:output_poll_execute], [CONNECTOR:5:VGA-1] status updated from 2 to 2
[   44.180101] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   44.185463] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[   44.189068] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[   44.189078] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   44.195739] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   44.252239] [drm:output_poll_execute], [CONNECTOR:8:DVI-D-1] status updated from 1 to 1
[   44.252252] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   44.261071] [drm:intel_sdvo_write_cmd], command returns response Pending [4]
[   44.261084] [drm:output_poll_execute], [CONNECTOR:44:VGA-2] status updated from 3 to 3
[   47.268088] [drm:output_poll_execute], [CONNECTOR:5:VGA-1] status updated from 2 to 2
[   47.268101] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   47.273477] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[   47.277089] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[   47.277100] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   47.283749] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   47.340149] [drm:output_poll_execute], [CONNECTOR:8:DVI-D-1] status updated from 1 to 1
[   47.340162] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   47.348972] [drm:intel_sdvo_write_cmd], command returns response Pending [4]
[   47.348984] [drm:output_poll_execute], [CONNECTOR:44:VGA-2] status updated from 3 to 3

--------------060302090704010900070504--
