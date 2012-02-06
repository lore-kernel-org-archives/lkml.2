Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab2BFBVB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 20:21:01 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:49410 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab2BFBU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 20:20:57 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.SOC.1.00.1202042204130.29659@math.ut.ee>
References: <alpine.SOC.1.00.1202042204130.29659@math.ut.ee>
Date: Mon, 6 Feb 2012 09:20:56 +0800
X-Google-Sender-Auth: Uw3vCh_Mh9OiFc_vS1FDOZ9UM_c
Message-ID: <CANejiEX2azVaA6EQBncZOaAcTHxY9r9EDu5wYk7-rK+Bxxjeug@mail.gmail.com>
Subject: Re: CFQ warning in 3.3.0-rc2-00110-gd125666
From: Shaohua Li <shaohua.li@intel.com>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: multipart/mixed; boundary=20cf306677d1740b3604b8417945
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf306677d1740b3604b8417945
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

so you are using a UP kernel, right?
please try attached patch.

Thanks,
Shaohua

2012/2/5 Meelis Roos <mroos@linux.ee>:
> Tested 3.3.0-rc2-00110-gd125666 on my PC. Seems to work fine but it
> gives a warning about run_timer_softirq+0x199/0x1ec for timer
> cfq_idle_slice_timer during bootup:
>
> WARNING: at kernel/timer.c:1122 run_timer_softirq+0x199/0x1ec()
> Hardware name: 939Dual-SATA2
> timer: cfq_idle_slice_timer+0x0/0xaa preempt leak: 00000102 -> 00000103
> Modules linked in: sr_mod cdrom videodev media drm_kms_helper ohci_hcd eh=
ci_hcd v4l2_compat_ioctl32 usbcore i2c_ali15x3 snd_seq drm snd_timer snd_se=
q
> Pid: 0, comm: swapper Not tainted 3.3.0-rc2-00110-gd125666 #176
> Call Trace:
> =A0<IRQ> =A0[<ffffffff81022aaa>] warn_slowpath_common+0x7e/0x96
> =A0[<ffffffff8114c485>] ? cfq_slice_expired+0x1d/0x1d
> =A0[<ffffffff81022b56>] warn_slowpath_fmt+0x41/0x43
> =A0[<ffffffff8114c526>] ? cfq_idle_slice_timer+0xa1/0xaa
> =A0[<ffffffff8114c485>] ? cfq_slice_expired+0x1d/0x1d
> =A0[<ffffffff8102c124>] run_timer_softirq+0x199/0x1ec
> =A0[<ffffffff81047a53>] ? timekeeping_get_ns+0x12/0x31
> =A0[<ffffffff810145fd>] ? apic_write+0x11/0x13
> =A0[<ffffffff81027475>] __do_softirq+0x74/0xfa
> =A0[<ffffffff812f337a>] call_softirq+0x1a/0x30
> =A0[<ffffffff81002ff9>] do_softirq+0x31/0x68
> =A0[<ffffffff810276cf>] irq_exit+0x3d/0xa3
> =A0[<ffffffff81014aca>] smp_apic_timer_interrupt+0x6b/0x77
> =A0[<ffffffff812f2de9>] apic_timer_interrupt+0x69/0x70
> =A0<EOI> =A0[<ffffffff81040136>] ? sched_clock_cpu+0x73/0x7d
> =A0[<ffffffff81040136>] ? sched_clock_cpu+0x73/0x7d
> =A0[<ffffffff8100801f>] ? default_idle+0x1e/0x32
> =A0[<ffffffff81008019>] ? default_idle+0x18/0x32
> =A0[<ffffffff810008b1>] cpu_idle+0x87/0xd1
> =A0[<ffffffff812de861>] rest_init+0x85/0x89
> =A0[<ffffffff81659a4d>] start_kernel+0x2eb/0x2f8
> =A0[<ffffffff8165926e>] x86_64_start_reservations+0x7e/0x82
> =A0[<ffffffff81659362>] x86_64_start_kernel+0xf0/0xf7
>
> Full dmesg:
>
> Linux version 3.3.0-rc2-00110-gd125666 (mroos@vaarikas) (gcc version 4.6.=
2 (Debian 4.6.2-12) ) #176 PREEMPT Sat Feb 4 17:30:42 EET 2012
> Command line: BOOT_IMAGE=3D/boot/vmlinuz-3.3.0-rc2-00110-gd125666 root=3D=
/dev/sda1 ro pata_ali.atapi_dma=3D1
> BIOS-provided physical RAM map:
> =A0BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> =A0BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
> =A0BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
> =A0BIOS-e820: 0000000000100000 - 000000009efb0000 (usable)
> =A0BIOS-e820: 000000009efb0000 - 000000009efc0000 (ACPI data)
> =A0BIOS-e820: 000000009efc0000 - 000000009eff0000 (ACPI NVS)
> =A0BIOS-e820: 000000009eff0000 - 000000009f000000 (reserved)
> =A0BIOS-e820: 00000000ff7c0000 - 0000000100000000 (reserved)
> NX (Execute Disable) protection: active
> DMI 2.3 present.
> DMI: =A0 =A0 =A0 =A0 =A0939Dual-SATA2/939Dual-SATA2, BIOS P2.30 09/25/200=
6
> e820 update range: 0000000000000000 - 0000000000010000 (usable) =3D=3D> (=
reserved)
> e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
> AGP bridge at 00:04:00
> Aperture from AGP @ d0000000 old size 32 MB
> Aperture size 4096 MB (APSIZE 0) is not right, using settings from NB
> Aperture from AGP @ d0000000 size 32 MB (APSIZE 0)
> last_pfn =3D 0x9efb0 max_arch_pfn =3D 0x400000000
> MTRR default type: uncachable
> MTRR fixed ranges enabled:
> =A000000-9FFFF write-back
> =A0A0000-EFFFF uncachable
> =A0F0000-FFFFF write-protect
> MTRR variable ranges enabled:
> =A00 base 0000000000 mask FF80000000 write-back
> =A01 base 0080000000 mask FFF0000000 write-back
> =A02 base 0090000000 mask FFF8000000 write-back
> =A03 base 0098000000 mask FFFC000000 write-back
> =A04 base 009C000000 mask FFFE000000 write-back
> =A05 base 009E000000 mask FFFF000000 write-back
> =A06 disabled
> =A07 disabled
> x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> found SMP MP-table at [ffff8800000ff780] ff780
> initial memory mapped : 0 - 20000000
> Base memory trampoline at [ffff88000009a000] 9a000 size 20480
> init_memory_mapping: 0000000000000000-000000009efb0000
> =A00000000000 - 009ee00000 page 2M
> =A0009ee00000 - 009efb0000 page 4k
> kernel direct mapping tables up to 9efb0000 @ 1fffb000-20000000
> ACPI: RSDP 00000000000f9a50 00014 (v00 ACPIAM)
> ACPI: RSDT 000000009efb0000 00034 (v01 A M I =A0OEMRSDT =A009000625 MSFT =
00000097)
> ACPI: FACP 000000009efb0200 00084 (v02 A M I =A0OEMFACP =A009000625 MSFT =
00000097)
> ACPI: DSDT 000000009efb0440 0474D (v01 =A0939M2 939M2222 00000222 INTL 02=
002026)
> ACPI: FACS 000000009efc0000 00040
> ACPI: APIC 000000009efb0390 00068 (v01 A M I =A0OEMAPIC =A009000625 MSFT =
00000097)
> ACPI: MCFG 000000009efb0400 0003C (v01 A M I =A0OEMMCFG =A009000625 MSFT =
00000097)
> ACPI: OEMB 000000009efc0040 00057 (v01 A M I =A0AMI_OEM =A009000625 MSFT =
00000097)
> ACPI: Local APIC address 0xfee00000
> =A0[ffffea0000000000-ffffea00023fffff] PMD -> [ffff88009be00000-ffff88009=
e1fffff] on node 0
> Zone PFN ranges:
> =A0DMA =A0 =A0 =A00x00000010 -> 0x00001000
> =A0DMA32 =A0 =A00x00001000 -> 0x00100000
> =A0Normal =A0 empty
> Movable zone start PFN for each node
> Early memory PFN ranges
> =A0 =A00: 0x00000010 -> 0x0000009f
> =A0 =A00: 0x00000100 -> 0x0009efb0
> On node 0 totalpages: 651071
> =A0DMA zone: 56 pages used for memmap
> =A0DMA zone: 5 pages reserved
> =A0DMA zone: 3922 pages, LIFO batch:0
> =A0DMA32 zone: 8847 pages used for memmap
> =A0DMA32 zone: 638241 pages, LIFO batch:31
> Detected use of extended apic ids on hypertransport bus
> ACPI: PM-Timer IO Port: 0x808
> ACPI: Local APIC address 0xfee00000
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> ACPI: LAPIC (acpi_id[0x02] lapic_id[0x81] disabled)
> ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
> IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
> ACPI: IOAPIC (id[0x02] address[0xfec10000] gsi_base[24])
> IOAPIC[1]: apic_id 2, version 17, address 0xfec10000, GSI 24-39
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
> ACPI: IRQ0 used by override.
> ACPI: IRQ2 used by override.
> ACPI: IRQ9 used by override.
> Using ACPI (MADT) for SMP configuration information
> nr_irqs_gsi: 56
> PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> PM: Registered nosave memory: 00000000000a0000 - 00000000000e8000
> PM: Registered nosave memory: 00000000000e8000 - 0000000000100000
> Allocating PCI resources starting at 9f000000 (gap: 9f000000:607c0000)
> pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
> pcpu-alloc: [0] 0
> Built 1 zonelists in Zone order, mobility grouping on. =A0Total pages: 64=
2163
> Kernel command line: BOOT_IMAGE=3D/boot/vmlinuz-3.3.0-rc2-00110-gd125666 =
root=3D/dev/sda1 ro pata_ali.atapi_dma=3D1
> PID hash table entries: 4096 (order: 3, 32768 bytes)
> Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
> Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> Checking aperture...
> AGP bridge at 00:04:00
> Aperture from AGP @ d0000000 old size 32 MB
> Aperture size 4096 MB (APSIZE 0) is not right, using settings from NB
> Aperture from AGP @ d0000000 size 32 MB (APSIZE 0)
> Node 0: aperture @ d0000000 size 256 MB
> Memory: 2553676k/2604736k available (3029k kernel code, 452k absent, 5060=
8k reserved, 3466k data, 396k init)
> NR_IRQS:4352 nr_irqs:256 16
> spurious 8259A interrupt: IRQ7.
> Console: colour VGA+ 80x25
> console [tty0] enabled
> Fast TSC calibration using PIT
> Detected 2199.954 MHz processor.
> Calibrating delay loop (skipped), value calculated using timer frequency.=
. 4399.90 BogoMIPS (lpj=3D8799816)
> pid_max: default: 32768 minimum: 301
> Security Framework initialized
> Mount-cache hash table entries: 256
> tseg: 0000000000
> mce: CPU supports 5 MCE banks
> CPU: AMD Athlon(tm) 64 Processor 3500+ stepping 02
> ACPI: Core revision 20120111
> Performance Events: AMD PMU driver.
> ... version: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00
> ... bit width: =A0 =A0 =A0 =A0 =A0 =A0 =A048
> ... generic registers: =A0 =A0 =A04
> ... value mask: =A0 =A0 =A0 =A0 =A0 =A0 0000ffffffffffff
> ... max period: =A0 =A0 =A0 =A0 =A0 =A0 00007fffffffffff
> ... fixed-purpose events: =A0 0
> ... event mask: =A0 =A0 =A0 =A0 =A0 =A0 000000000000000f
> NMI watchdog enabled, takes one hw-pmu counter.
> ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
> PM: Registering ACPI NVS region at 9efc0000 (196608 bytes)
> NET: Registered protocol family 16
> node 0 link 0: io port [1000, ffffff]
> TOM: 000000009f000000 aka 2544M
> node 0 link 0: mmio [e0000000, efffffff]
> node 0 link 0: mmio [a0000, bffff]
> node 0 link 0: mmio [9f000000, ffffffff]
> bus: [00, ff] on node 0 link 0
> bus: 00 index 0 [io =A00x0000-0xffff]
> bus: 00 index 1 [mem 0x9f000000-0xfcffffffff]
> bus: 00 index 2 [mem 0x000a0000-0x000bffff]
> ACPI: bus type pci registered
> PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] =
(base 0xe0000000)
> PCI: not using MMCONFIG
> PCI: Using configuration type 1 for base access
> bio: create slab <bio-0> at 0
> ACPI: Added _OSI(Module Device)
> ACPI: Added _OSI(Processor Device)
> ACPI: Added _OSI(3.0 _SCP Extensions)
> ACPI: Added _OSI(Processor Aggregator Device)
> ACPI: EC: Look up EC in DSDT
> ACPI: Executed 1 blocks of module-level executable AML code
> ACPI: Interpreter enabled
> ACPI: (supports S0 S1 S3 S4 S5)
> ACPI: Using IOAPIC for interrupt routing
> PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] =
(base 0xe0000000)
> PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard=
 resources
> ACPI: No dock devices found.
> PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=3Duse=
_crs" and report a bug
> ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> pci_root PNP0A03:00: host bridge window [io =A00x0000-0x0cf7] (ignored)
> pci_root PNP0A03:00: host bridge window [io =A00x0d00-0xffff] (ignored)
> pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (igno=
red)
> pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff] (igno=
red)
> pci_root PNP0A03:00: host bridge window [mem 0x9f000000-0xffffffff] (igno=
red)
> PCI: root bus 00: hardware-probed resources
> PCI host bridge to bus 0000:00
> pci_bus 0000:00: root bus resource [io =A00x0000-0xffff]
> pci_bus 0000:00: root bus resource [mem 0x9f000000-0xfcffffffff]
> pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> pci 0000:00:00.0: [10b9:1695] type 0 class 0x000600
> pci 0000:00:01.0: [10b9:524b] type 1 class 0x000604
> pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
> pci 0000:00:02.0: [10b9:524c] type 1 class 0x000604
> pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
> pci 0000:00:03.0: [10b9:524d] type 1 class 0x000604
> pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
> pci 0000:00:04.0: [10b9:1689] type 0 class 0x000600
> pci 0000:00:04.0: reg 10: [mem 0xd0000000-0xdfffffff pref]
> pci 0000:00:05.0: [10b9:5246] type 1 class 0x000604
> pci 0000:00:06.0: [10b9:5249] type 1 class 0x000604
> pci 0000:00:07.0: [10b9:1563] type 0 class 0x000601
> pci 0000:00:07.1: [10b9:7101] type 0 class 0x000680
> pci 0000:00:07.1: quirk: [io =A00x0800-0x083f] claimed by ali7101 ACPI
> pci 0000:00:12.0: [10b9:5229] type 0 class 0x000101
> pci 0000:00:12.0: reg 20: [io =A00xff00-0xff0f]
> pci 0000:00:12.1: [10b9:5289] type 0 class 0x000101
> pci 0000:00:12.1: reg 10: [io =A00xec00-0xec07]
> pci 0000:00:12.1: reg 14: [io =A00xe880-0xe883]
> pci 0000:00:12.1: reg 18: [io =A00xe800-0xe807]
> pci 0000:00:12.1: reg 1c: [io =A00xe480-0xe483]
> pci 0000:00:12.1: reg 20: [io =A00xe400-0xe40f]
> pci 0000:00:13.0: [10b9:5237] type 0 class 0x000c03
> pci 0000:00:13.0: reg 10: [mem 0xff6ff000-0xff6fffff]
> pci 0000:00:13.1: [10b9:5237] type 0 class 0x000c03
> pci 0000:00:13.1: reg 10: [mem 0xff6fe000-0xff6fefff]
> pci 0000:00:13.2: [10b9:5237] type 0 class 0x000c03
> pci 0000:00:13.2: reg 10: [mem 0xff6fd000-0xff6fdfff]
> pci 0000:00:13.3: [10b9:5239] type 0 class 0x000c03
> pci 0000:00:13.3: reg 10: [mem 0xff6fcc00-0xff6fccff]
> pci 0000:00:13.3: PME# supported from D0 D3hot D3cold
> pci 0000:00:18.0: [1022:1100] type 0 class 0x000600
> pci 0000:00:18.1: [1022:1101] type 0 class 0x000600
> pci 0000:00:18.2: [1022:1102] type 0 class 0x000600
> pci 0000:00:18.3: [1022:1103] type 0 class 0x000600
> pci 0000:01:00.0: [1002:954f] type 0 class 0x000300
> pci 0000:01:00.0: reg 10: [mem 0xa0000000-0xafffffff 64bit pref]
> pci 0000:01:00.0: reg 18: [mem 0xff0f0000-0xff0fffff 64bit]
> pci 0000:01:00.0: reg 20: [io =A00xa000-0xa0ff]
> pci 0000:01:00.0: reg 30: [mem 0xff0c0000-0xff0dffff pref]
> pci 0000:01:00.0: supports D1 D2
> pci 0000:01:00.1: [1002:aa38] type 0 class 0x000403
> pci 0000:01:00.1: reg 10: [mem 0xff0ec000-0xff0effff 64bit]
> pci 0000:01:00.1: supports D1 D2
> pci 0000:00:01.0: PCI bridge to [bus 01-01]
> pci 0000:00:01.0: =A0 bridge window [io =A00x8000-0xafff]
> pci 0000:00:01.0: =A0 bridge window [mem 0xff000000-0xff0fffff]
> pci 0000:00:01.0: =A0 bridge window [mem 0x9fe00000-0xbfdfffff pref]
> pci 0000:00:02.0: PCI bridge to [bus 02-02]
> pci 0000:00:02.0: =A0 bridge window [mem 0xff100000-0xff1fffff]
> pci 0000:03:00.0: [197b:2360] type 0 class 0x000106
> pci 0000:03:00.0: reg 10: [io =A00xbc00-0xbc07]
> pci 0000:03:00.0: reg 14: [io =A00xb880-0xb883]
> pci 0000:03:00.0: reg 18: [io =A00xb800-0xb807]
> pci 0000:03:00.0: reg 1c: [io =A00xb480-0xb483]
> pci 0000:03:00.0: reg 20: [io =A00xb400-0xb40f]
> pci 0000:03:00.0: reg 24: [mem 0x00000000-0x00001fff]
> pci 0000:03:00.0: PME# supported from D3hot
> pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device. =A0You can enabl=
e it with 'pcie_aspm=3Dforce'
> pci 0000:00:03.0: PCI bridge to [bus 03-03]
> pci 0000:00:03.0: =A0 bridge window [io =A00xb000-0xbfff]
> pci 0000:00:03.0: =A0 bridge window [mem 0xff200000-0xff2fffff]
> pci 0000:00:05.0: PCI bridge to [bus 04-04]
> pci 0000:00:05.0: =A0 bridge window [mem 0xff300000-0xff3fffff]
> pci 0000:05:05.0: [1102:0002] type 0 class 0x000001
> pci 0000:05:05.0: reg 10: [io =A00xd880-0xd89f]
> pci 0000:05:05.0: supports D1 D2
> pci 0000:05:05.1: [1102:7002] type 0 class 0x000980
> pci 0000:05:05.1: reg 10: [io =A00xdc00-0xdc07]
> pci 0000:05:05.1: supports D1 D2
> pci 0000:05:06.0: [8086:b154] type 1 class 0x000604
> pci 0000:05:06.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:05:07.0: [109e:036e] type 0 class 0x000400
> pci 0000:05:07.0: reg 10: [mem 0xbfeff000-0xbfefffff pref]
> pci 0000:05:07.1: [109e:0878] type 0 class 0x000480
> pci 0000:05:07.1: reg 10: [mem 0xbfefe000-0xbfefefff pref]
> pci 0000:00:06.0: PCI bridge to [bus 05-06] (subtractive decode)
> pci 0000:00:06.0: =A0 bridge window [io =A00xc000-0xdfff]
> pci 0000:00:06.0: =A0 bridge window [mem 0xff400000-0xff5fffff]
> pci 0000:00:06.0: =A0 bridge window [mem 0xbfe00000-0xbfefffff pref]
> pci 0000:00:06.0: =A0 bridge window [io =A00x0000-0xffff] (subtractive de=
code)
> pci 0000:00:06.0: =A0 bridge window [mem 0x9f000000-0xfcffffffff] (subtra=
ctive decode)
> pci 0000:00:06.0: =A0 bridge window [mem 0x000a0000-0x000bffff] (subtract=
ive decode)
> pci 0000:06:04.0: [8086:1229] type 0 class 0x000200
> pci 0000:06:04.0: reg 10: [mem 0xff4ff000-0xff4fffff]
> pci 0000:06:04.0: reg 14: [io =A00xcc00-0xcc3f]
> pci 0000:06:04.0: reg 18: [mem 0xff4c0000-0xff4dffff]
> pci 0000:06:04.0: supports D1 D2
> pci 0000:06:04.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:06:05.0: [8086:1229] type 0 class 0x000200
> pci 0000:06:05.0: reg 10: [mem 0xff4fe000-0xff4fefff]
> pci 0000:06:05.0: reg 14: [io =A00xc880-0xc8bf]
> pci 0000:06:05.0: reg 18: [mem 0xff4a0000-0xff4bffff]
> pci 0000:06:05.0: supports D1 D2
> pci 0000:06:05.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:05:06.0: PCI bridge to [bus 06-06]
> pci 0000:05:06.0: =A0 bridge window [io =A00xc000-0xcfff]
> pci 0000:05:06.0: =A0 bridge window [mem 0xff400000-0xff4fffff]
> pci_bus 0000:00: on NUMA node 0
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HTT_._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB1._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB2._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB3._PRT]
> =A0pci0000:00: Requesting ACPI _OSC control (0x1d)
> =A0pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control =
mask: 0x1d
> ACPI _OSC control for PCIe not granted, disabling ASPM
> ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11 12 14 *15), disable=
d.
> ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
> ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14 15)
> ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 12 14 15)
> ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 10 11 12 14 15)
> ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 15) *9
> ACPI: PCI Interrupt Link [LNKP] (IRQs 3 4 *5 6 7 10 11 12 14 15)
> vgaarb: device added: PCI:0000:01:00.0,decodes=3Dio+mem,owns=3Dio+mem,loc=
ks=3Dnone
> vgaarb: loaded
> vgaarb: bridge control possible 0000:01:00.0
> SCSI subsystem initialized
> libata version 3.00 loaded.
> PCI: Using ACPI for IRQ routing
> PCI: pci_cache_line_size set to 64 bytes
> pci 0000:00:04.0: address space collision: [mem 0xd0000000-0xdfffffff pre=
f] conflicts with GART [mem 0xd0000000-0xdfffffff]
> reserve RAM buffer: 000000000009fc00 - 000000000009ffff
> reserve RAM buffer: 000000009efb0000 - 000000009fffffff
> pnp: PnP ACPI init
> ACPI: bus type pnp registered
> pnp 00:00: [bus 00-ff]
> pnp 00:00: [io =A00x0cf8-0x0cff]
> pnp 00:00: [io =A00x0000-0x0cf7 window]
> pnp 00:00: [io =A00x0d00-0xffff window]
> pnp 00:00: [mem 0x000a0000-0x000bffff window]
> pnp 00:00: [mem 0x000d0000-0x000dffff window]
> pnp 00:00: [mem 0x9f000000-0xffffffff window]
> pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
> pnp 00:01: [dma 4]
> pnp 00:01: [io =A00x0000-0x000f]
> pnp 00:01: [io =A00x0081-0x0083]
> pnp 00:01: [io =A00x0087]
> pnp 00:01: [io =A00x0089-0x008b]
> pnp 00:01: [io =A00x008f]
> pnp 00:01: [io =A00x00c0-0x00df]
> pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
> pnp 00:02: [io =A00x0070-0x0071]
> pnp 00:02: [irq 8]
> pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
> pnp 00:03: [io =A00x0061]
> pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
> pnp 00:04: [io =A00x00f0-0x00ff]
> pnp 00:04: [irq 13]
> pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
> pnp 00:05: [io =A00x03f0-0x03f5]
> pnp 00:05: [io =A00x03f7]
> pnp 00:05: [irq 6]
> pnp 00:05: [dma 2]
> pnp 00:05: Plug and Play ACPI device, IDs PNP0700 (active)
> pnp 00:06: [io =A00x0378-0x037f]
> pnp 00:06: [io =A00x0778-0x077f]
> pnp 00:06: [irq 7]
> pnp 00:06: [dma 3]
> pnp 00:06: Plug and Play ACPI device, IDs PNP0401 (active)
> pnp 00:07: [io =A00x0010-0x001f]
> pnp 00:07: [io =A00x0022-0x003f]
> pnp 00:07: [io =A00x0044-0x005f]
> pnp 00:07: [io =A00x0062-0x0063]
> pnp 00:07: [io =A00x0065-0x006f]
> pnp 00:07: [io =A00x0072-0x007f]
> pnp 00:07: [io =A00x0080]
> pnp 00:07: [io =A00x0084-0x0086]
> pnp 00:07: [io =A00x0088]
> pnp 00:07: [io =A00x008c-0x008e]
> pnp 00:07: [io =A00x0090-0x009f]
> pnp 00:07: [io =A00x00a2-0x00bf]
> pnp 00:07: [io =A00x00e0-0x00ef]
> pnp 00:07: [io =A00x0480-0x048f]
> pnp 00:07: [io =A00x04d0-0x04d1]
> pnp 00:07: [io =A00x0800-0x087f]
> pnp 00:07: [io =A00x0400-0x040f]
> system 00:07: [io =A00x0480-0x048f] has been reserved
> system 00:07: [io =A00x04d0-0x04d1] has been reserved
> system 00:07: [io =A00x0800-0x087f] could not be reserved
> system 00:07: [io =A00x0400-0x040f] has been reserved
> system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
> pnp 00:08: [mem 0xfec00000-0xfec00fff]
> pnp 00:08: [mem 0xfee00000-0xfee00fff]
> pnp 00:08: [mem 0xe0000000-0xefffffff]
> pnp 00:08: [mem 0xfec10000-0xfec10fff]
> pnp 00:08: [mem 0xffb00000-0xffffffff]
> system 00:08: [mem 0xfec00000-0xfec00fff] could not be reserved
> system 00:08: [mem 0xfee00000-0xfee00fff] has been reserved
> system 00:08: [mem 0xe0000000-0xefffffff] has been reserved
> system 00:08: [mem 0xfec10000-0xfec10fff] could not be reserved
> system 00:08: [mem 0xffb00000-0xffffffff] has been reserved
> system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
> pnp 00:09: [io =A00x0060]
> pnp 00:09: [io =A00x0064]
> pnp 00:09: [irq 1]
> pnp 00:09: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
> pnp 00:0a: [io =A00x03f8-0x03ff]
> pnp 00:0a: [irq 4]
> pnp 00:0a: [dma 0 disabled]
> pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
> pnp 00:0b: [io =A00x0000-0xffffffffffffffff disabled]
> pnp 00:0b: [io =A00x0290-0x029f]
> system 00:0b: [io =A00x0290-0x029f] has been reserved
> system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
> pnp 00:0c: [mem 0x00000000-0x0009ffff]
> pnp 00:0c: [mem 0x000c0000-0x000cffff]
> pnp 00:0c: [mem 0x000e0000-0x000fffff]
> pnp 00:0c: [mem 0x00100000-0x9effffff]
> pnp 00:0c: [mem 0x00000000-0xffffffffffffffff disabled]
> pnp 00:0c: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000=
:00:04.0 BAR 0 [mem 0x00000000-0x0fffffff pref]
> pnp 00:0c: disabling [mem 0x000c0000-0x000cffff] because it overlaps 0000=
:00:04.0 BAR 0 [mem 0x00000000-0x0fffffff pref]
> pnp 00:0c: disabling [mem 0x000e0000-0x000fffff] because it overlaps 0000=
:00:04.0 BAR 0 [mem 0x00000000-0x0fffffff pref]
> pnp 00:0c: disabling [mem 0x00100000-0x9effffff] because it overlaps 0000=
:00:04.0 BAR 0 [mem 0x00000000-0x0fffffff pref]
> system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
> pnp: PnP ACPI: found 13 devices
> ACPI: ACPI bus type pnp unregistered
> Switching to clocksource acpi_pm
> PCI: max bus depth: 2 pci_try_num: 3
> pci 0000:00:01.0: PCI bridge to [bus 01-01]
> pci 0000:00:01.0: =A0 bridge window [io =A00x8000-0xafff]
> pci 0000:00:01.0: =A0 bridge window [mem 0xff000000-0xff0fffff]
> pci 0000:00:01.0: =A0 bridge window [mem 0x9fe00000-0xbfdfffff pref]
> pci 0000:00:02.0: PCI bridge to [bus 02-02]
> pci 0000:00:02.0: =A0 bridge window [mem 0xff100000-0xff1fffff]
> pci 0000:03:00.0: BAR 5: assigned [mem 0xff200000-0xff201fff]
> pci 0000:00:03.0: PCI bridge to [bus 03-03]
> pci 0000:00:03.0: =A0 bridge window [io =A00xb000-0xbfff]
> pci 0000:00:03.0: =A0 bridge window [mem 0xff200000-0xff2fffff]
> pci 0000:00:05.0: PCI bridge to [bus 04-04]
> pci 0000:00:05.0: =A0 bridge window [mem 0xff300000-0xff3fffff]
> pci 0000:05:06.0: PCI bridge to [bus 06-06]
> pci 0000:05:06.0: =A0 bridge window [io =A00xc000-0xcfff]
> pci 0000:05:06.0: =A0 bridge window [mem 0xff400000-0xff4fffff]
> pci 0000:00:06.0: PCI bridge to [bus 05-06]
> pci 0000:00:06.0: =A0 bridge window [io =A00xc000-0xdfff]
> pci 0000:00:06.0: =A0 bridge window [mem 0xff400000-0xff5fffff]
> pci 0000:00:06.0: =A0 bridge window [mem 0xbfe00000-0xbfefffff pref]
> pci 0000:00:05.0: setting latency timer to 64
> pci 0000:00:06.0: setting latency timer to 64
> pci_bus 0000:00: resource 4 [io =A00x0000-0xffff]
> pci_bus 0000:00: resource 5 [mem 0x9f000000-0xfcffffffff]
> pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> pci_bus 0000:01: resource 0 [io =A00x8000-0xafff]
> pci_bus 0000:01: resource 1 [mem 0xff000000-0xff0fffff]
> pci_bus 0000:01: resource 2 [mem 0x9fe00000-0xbfdfffff pref]
> pci_bus 0000:02: resource 1 [mem 0xff100000-0xff1fffff]
> pci_bus 0000:03: resource 0 [io =A00xb000-0xbfff]
> pci_bus 0000:03: resource 1 [mem 0xff200000-0xff2fffff]
> pci_bus 0000:04: resource 1 [mem 0xff300000-0xff3fffff]
> pci_bus 0000:05: resource 0 [io =A00xc000-0xdfff]
> pci_bus 0000:05: resource 1 [mem 0xff400000-0xff5fffff]
> pci_bus 0000:05: resource 2 [mem 0xbfe00000-0xbfefffff pref]
> pci_bus 0000:05: resource 4 [io =A00x0000-0xffff]
> pci_bus 0000:05: resource 5 [mem 0x9f000000-0xfcffffffff]
> pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff]
> pci_bus 0000:06: resource 0 [io =A00xc000-0xcfff]
> pci_bus 0000:06: resource 1 [mem 0xff400000-0xff4fffff]
> NET: Registered protocol family 2
> IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
> TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
> TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
> TCP: Hash tables configured (established 262144 bind 65536)
> TCP reno registered
> UDP hash table entries: 2048 (order: 4, 65536 bytes)
> UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
> NET: Registered protocol family 1
> pci 0000:00:00.0: Enabling HT MSI Mapping
> pci 0000:00:01.0: Enabling HT MSI Mapping
> pci 0000:00:02.0: Enabling HT MSI Mapping
> pci 0000:00:03.0: Enabling HT MSI Mapping
> pci 0000:01:00.0: Boot video device
> pci 0000:06:04.0: Firmware left e100 interrupts enabled; disabling
> pci 0000:06:05.0: Firmware left e100 interrupts enabled; disabling
> PCI: CLS 64 bytes, default 64
> HugeTLB registered 2 MB page size, pre-allocated 0 pages
> msgmni has been set to 4987
> Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
> io scheduler noop registered
> io scheduler deadline registered
> io scheduler cfq registered (default)
> start plist test
> end plist test
> pcieport 0000:00:01.0: irq 56 for MSI/MSI-X
> pcieport 0000:00:02.0: irq 57 for MSI/MSI-X
> pcieport 0000:00:03.0: irq 58 for MSI/MSI-X
> input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/in=
put0
> ACPI: Power Button [PWRB]
> input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
> ACPI: Power Button [PWRF]
> Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
> 00:0a: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
> Non-volatile memory driver v1.3
> Floppy drive(s): fd0 is 1.44M
> FDC 0 is a post-1991 82077
> ahci 0000:03:00.0: version 3.0
> ahci 0000:03:00.0: AHCI 0001.0000 32 slots 1 ports 3 Gbps 0x1 impl SATA m=
ode
> ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum part
> scsi0 : ahci
> ata1: SATA max UDMA/133 abar m8192@0xff200000 port 0xff200100 irq 35
> PPP generic driver version 2.4.2
> i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
> i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect =
please boot with i8042.nopnp
> serio: i8042 KBD port at 0x60,0x64 irq 1
> mousedev: PS/2 mouse device common for all mice
> rtc_cmos 00:02: RTC can wake from S4
> rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
> rtc0: alarms up to one month, 114 bytes nvram
> cpuidle: using governor ladder
> cpuidle: using governor menu
> TCP cubic registered
> NET: Registered protocol family 10
> NET: Registered protocol family 17
> Registering the dns_resolver key type
> registered taskstats version 1
> rtc_cmos 00:02: setting system clock to 2012-02-04 17:06:46 UTC (13283752=
06)
> input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/inp=
ut/input2
> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata1.00: ATA-7: WDC WD7500AAKS-00RBA0, 30.04G30, max UDMA/133
> ata1.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> ata1.00: configured for UDMA/133
> scsi 0:0:0:0: Direct-Access =A0 =A0 ATA =A0 =A0 =A0WDC WD7500AAKS-0 30.0 =
PQ: 0 ANSI: 5
> sd 0:0:0:0: [sda] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't supp=
ort DPO or FUA
> =A0sda: sda1 sda2 sda3
> sd 0:0:0:0: [sda] Attached SCSI disk
> EXT3-fs (sda1): error: couldn't mount because of unsupported optional fea=
tures (240)
> EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
> VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
> Freeing unused kernel memory: 396k freed
> Write protecting the kernel read-only data: 6144k
> Freeing unused kernel memory: 1048k freed
> Freeing unused kernel memory: 456k freed
> Refined TSC clocksource calibration: 2200.079 MHz.
> Switching to clocksource tsc
> Linux agpgart interface v0.103
> input: PC Speaker as /devices/platform/pcspkr/input/input3
> ACPI Warning: 0x0000000000000400-0x000000000000040f SystemIO conflicts wi=
th Region \SMIO 1 (20120111/utaddress-251)
> ACPI: If an ACPI driver is available for this device, you should use it i=
nstead of the native driver
> ali1563_smbus 0000:00:07.0: ALi1563 SMBus probe failed (-19)
> agpgart-amd64 0000:00:04.0: AGP bridge [10b9/1689]
> agpgart-amd64 0000:00:04.0: aperture size 4096 MB is not right, using set=
tings from NB
> agpgart-amd64 0000:00:04.0: setting up ULi AGP
> parport_pc 00:06: reported by Plug and Play ACPI
> parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,=
EPP,ECP,DMA]
> agpgart-amd64 0000:00:04.0: AGP aperture is 256M @ 0xd0000000
> e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
> e100: Copyright(c) 1999-2006 Intel Corporation
> e100 0000:06:04.0: eth0: addr 0xff4ff000, irq 21, MAC addr 00:02:b3:bc:9f=
:dd
> e100 0000:06:05.0: eth1: addr 0xff4fe000, irq 22, MAC addr 00:02:b3:bc:9f=
:de
> ali1535_smbus 0000:00:07.1: enabling device (0000 -> 0001)
> ali1535_smbus 0000:00:07.1: ALI1535_smb region uninitialized - upgrade BI=
OS?
> ali1535_smbus 0000:00:07.1: ALI1535 not detected, module not inserted.
> scsi1 : pata_ali
> scsi2 : pata_ali
> ata2: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
> ata3: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
> sata_uli 0000:00:12.1: version 1.3
> scsi3 : sata_uli
> scsi4 : sata_uli
> ata4: SATA max UDMA/133 cmd 0xec00 ctl 0xe880 bmdma 0xe400 irq 19
> ata5: SATA max UDMA/133 cmd 0xe800 ctl 0xe480 bmdma 0xe408 irq 19
> udevd[540]: renamed network interface eth0 to rename2
> udevd[541]: renamed network interface eth1 to eth0
> udevd[540]: renamed network interface rename2 to eth1
> [drm] Initialized drm 1.1.0 20060810
> ali15x3_smbus 0000:00:07.1: ALI15X3_smb region uninitialized - upgrade BI=
OS or use force_addr=3D0xaddr
> ali15x3_smbus 0000:00:07.1: ALI15X3 not detected, module not inserted.
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> ehci_hcd 0000:00:13.3: EHCI Host Controller
> ehci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 1
> ehci_hcd 0000:00:13.3: debug port 1
> ata2.00: ATAPI: _NEC DVD_RW ND-4571A, 1-01, max UDMA/33
> ehci_hcd 0000:00:13.3: irq 23, io mem 0xff6fcc00
> ehci_hcd 0000:00:13.3: USB 2.0 started, EHCI 1.00
> usb usb1: New USB device found, idVendor=3D1d6b, idProduct=3D0002
> usb usb1: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
> usb usb1: Product: EHCI Host Controller
> usb usb1: Manufacturer: Linux 3.3.0-rc2-00110-gd125666 ehci_hcd
> usb usb1: SerialNumber: 0000:00:13.3
> ata2.00: configured for UDMA/33
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 8 ports detected
> scsi 1:0:0:0: CD-ROM =A0 =A0 =A0 =A0 =A0 =A0_NEC =A0 =A0 DVD_RW ND-4571A =
=A01-01 PQ: 0 ANSI: 5
> ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> ohci_hcd 0000:00:13.0: OHCI Host Controller
> ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
> ohci_hcd 0000:00:13.0: irq 20, io mem 0xff6ff000
> usb usb2: New USB device found, idVendor=3D1d6b, idProduct=3D0001
> usb usb2: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
> usb usb2: Product: OHCI Host Controller
> usb usb2: Manufacturer: Linux 3.3.0-rc2-00110-gd125666 ohci_hcd
> usb usb2: SerialNumber: 0000:00:13.0
> hub 2-0:1.0: USB hub found
> hub 2-0:1.0: 3 ports detected
> ohci_hcd 0000:00:13.1: OHCI Host Controller
> ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
> ohci_hcd 0000:00:13.1: irq 21, io mem 0xff6fe000
> usb usb3: New USB device found, idVendor=3D1d6b, idProduct=3D0001
> usb usb3: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
> usb usb3: Product: OHCI Host Controller
> usb usb3: Manufacturer: Linux 3.3.0-rc2-00110-gd125666 ohci_hcd
> usb usb3: SerialNumber: 0000:00:13.1
> hub 3-0:1.0: USB hub found
> hub 3-0:1.0: 3 ports detected
> ohci_hcd 0000:00:13.2: OHCI Host Controller
> ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
> ohci_hcd 0000:00:13.2: irq 22, io mem 0xff6fd000
> usb usb4: New USB device found, idVendor=3D1d6b, idProduct=3D0001
> usb usb4: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
> usb usb4: Product: OHCI Host Controller
> usb usb4: Manufacturer: Linux 3.3.0-rc2-00110-gd125666 ohci_hcd
> usb usb4: SerialNumber: 0000:00:13.2
> hub 4-0:1.0: USB hub found
> hub 4-0:1.0: 3 ports detected
> Linux media interface: v0.10
> Linux video capture interface: v2.00
> sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
> cdrom: Uniform CD-ROM driver Revision: 3.20
> sr 1:0:0:0: Attached scsi CD-ROM sr0
> ------------[ cut here ]------------
> WARNING: at kernel/timer.c:1122 run_timer_softirq+0x199/0x1ec()
> Hardware name: 939Dual-SATA2
> timer: cfq_idle_slice_timer+0x0/0xaa preempt leak: 00000102 -> 00000103
> Modules linked in: sr_mod cdrom videodev media drm_kms_helper ohci_hcd eh=
ci_hcd v4l2_compat_ioctl32 usbcore i2c_ali15x3 snd_seq drm snd_timer snd_se=
q_device sata_uli pata_ali i2c_ali1535 backlight usb_common snd e100 mii pa=
rport_pc amd64_agp parport ssb k8temp hwmon i2c_ali1563 pcspkr agpgart i2c_=
algo_bit soundcore snd_page_alloc
> Pid: 0, comm: swapper Not tainted 3.3.0-rc2-00110-gd125666 #176
> Call Trace:
> =A0<IRQ> =A0[<ffffffff81022aaa>] warn_slowpath_common+0x7e/0x96
> =A0[<ffffffff8114c485>] ? cfq_slice_expired+0x1d/0x1d
> =A0[<ffffffff81022b56>] warn_slowpath_fmt+0x41/0x43
> =A0[<ffffffff8114c526>] ? cfq_idle_slice_timer+0xa1/0xaa
> =A0[<ffffffff8114c485>] ? cfq_slice_expired+0x1d/0x1d
> =A0[<ffffffff8102c124>] run_timer_softirq+0x199/0x1ec
> =A0[<ffffffff81047a53>] ? timekeeping_get_ns+0x12/0x31
> =A0[<ffffffff810145fd>] ? apic_write+0x11/0x13
> =A0[<ffffffff81027475>] __do_softirq+0x74/0xfa
> =A0[<ffffffff812f337a>] call_softirq+0x1a/0x30
> =A0[<ffffffff81002ff9>] do_softirq+0x31/0x68
> =A0[<ffffffff810276cf>] irq_exit+0x3d/0xa3
> =A0[<ffffffff81014aca>] smp_apic_timer_interrupt+0x6b/0x77
> =A0[<ffffffff812f2de9>] apic_timer_interrupt+0x69/0x70
> =A0<EOI> =A0[<ffffffff81040136>] ? sched_clock_cpu+0x73/0x7d
> =A0[<ffffffff81040136>] ? sched_clock_cpu+0x73/0x7d
> =A0[<ffffffff8100801f>] ? default_idle+0x1e/0x32
> =A0[<ffffffff81008019>] ? default_idle+0x18/0x32
> =A0[<ffffffff810008b1>] cpu_idle+0x87/0xd1
> =A0[<ffffffff812de861>] rest_init+0x85/0x89
> =A0[<ffffffff81659a4d>] start_kernel+0x2eb/0x2f8
> =A0[<ffffffff8165926e>] x86_64_start_reservations+0x7e/0x82
> =A0[<ffffffff81659362>] x86_64_start_kernel+0xf0/0xf7
> ---[ end trace 7ad33618aef64c5a ]---
>
> --
> Meelis Roos (mroos@linux.ee)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/

--20cf306677d1740b3604b8417945
Content-Type: text/x-patch; charset=US-ASCII; name="blk-icq-lock-fix.patch"
Content-Disposition: attachment; filename="blk-icq-lock-fix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gyat7vrw0

ClNpZ25lZC1vZmYtYnk6IFNoYW9odWEgTGkgPHNoYW9odWEubGlAaW50ZWwuY29tPgoKZGlmZiAt
LWdpdCBhL2Jsb2NrL2Jsay1pb2MuYyBiL2Jsb2NrL2Jsay1pb2MuYwppbmRleCAyN2EwNmUwLi43
NDkwYjZkIDEwMDY0NAotLS0gYS9ibG9jay9ibGstaW9jLmMKKysrIGIvYmxvY2svYmxrLWlvYy5j
CkBAIC0yMDQsNyArMjA0LDkgQEAgdm9pZCBwdXRfaW9fY29udGV4dChzdHJ1Y3QgaW9fY29udGV4
dCAqaW9jLCBzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqbG9ja2VkX3EpCiAJCQkJc3Bpbl91bmxvY2so
bGFzdF9xLT5xdWV1ZV9sb2NrKTsKIAkJCWxhc3RfcSA9IE5VTEw7CiAKLQkJCWlmICghc3Bpbl90
cnlsb2NrKHRoaXNfcS0+cXVldWVfbG9jaykpCisJCQkvKiBzcGluX3RyeWxvY2soKSBhbHdheXMg
c3VjY2Vzc2VzIGluIFVQIGNhc2UgKi8KKwkJCWlmICh0aGlzX3EgIT0gbG9ja2VkX3EgJiYKKwkJ
CSAgICAhc3Bpbl90cnlsb2NrKHRoaXNfcS0+cXVldWVfbG9jaykpCiAJCQkJYnJlYWs7CiAJCQls
YXN0X3EgPSB0aGlzX3E7CiAJCQljb250aW51ZTsK
--20cf306677d1740b3604b8417945--
