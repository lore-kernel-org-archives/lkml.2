Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab1HZU1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 16:27:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49919 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab1HZU1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 16:27:14 -0400
Date: Fri, 26 Aug 2011 23:30:28 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>
Subject: i915: 3.1.0-rc3+: WARNING: at fs/sysfs/dir.c:455
 sysfs_add_one+0xb8/0xf0()
Message-ID: <20110826233028.074830de@sf.home>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/sba6/q/4XIiFLFOf1WtUJh0"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/sba6/q/4XIiFLFOf1WtUJh0
Content-Type: multipart/mixed; boundary="MP_/w_Lw62m.EpigzYJH9eFIN+R"

--MP_/w_Lw62m.EpigzYJH9eFIN+R
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Around -rc2+ i've noticed the following warning in dmesg [1]

> WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0xb8/0xf0()
> sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:02.0=
/drm/card0/card0-LVDS-1/intel_backlight'

It tries to register backlight twice, so fails miserably.
The machine is compaq-2510p with 965GM.

Reverting commit aaa6fd2a004147bf32fce05720938236de3361d9 helps.
("Not all systems expose a firmware or platform mechanism for changing
the backlight intensity on i915,  so add native driver support.")

Attached dmesg before reverting the patch and after.

Thanks!

[1]:
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0xb8/0xf0()
Hardware name: HP Compaq 2510p Notebook PC
sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:02.0/d=
rm/card0/card0-LVDS-1/intel_backlight'
Modules linked in: i915(+) drm_kms_helper drm sdhci_pci sdhci iwl4965 yenta=
_socket pcmcia_core iwl_legacy mmc_core mac80211 snd_hda_codec_analog proce=
ssor i2c_algo_bit thermal pcmcia_
rsrc container cfg80211 e1000e battery button ac rfkill snd_hda_intel fan s=
nd_hda_codec snd_hwdep
Pid: 828, comm: modprobe Not tainted 3.1.0-rc2-00169-g5ccc387 #137
Call Trace:
 [<ffffffff8103e7ba>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8103e891>] warn_slowpath_fmt+0x41/0x50
 [<ffffffff81130878>] sysfs_add_one+0xb8/0xf0
 [<ffffffff8113136c>] create_dir+0x7c/0xd0
 [<ffffffff8113143c>] sysfs_create_dir+0x7c/0xd0
 [<ffffffff81035b7d>] ? sub_preempt_count+0x9d/0xd0
 [<ffffffff8123302d>] kobject_add_internal+0xbd/0x200
 [<ffffffff81233288>] kobject_add_varg+0x38/0x60
 [<ffffffff81233364>] kobject_add+0x44/0x70
 [<ffffffff81232e4a>] ? kobject_get+0x1a/0x30
 [<ffffffff812cb218>] device_add+0x98/0x690
 [<ffffffff812d4d81>] ? pm_runtime_init+0xd1/0xe0
 [<ffffffff812d3ef9>] ? device_pm_init+0x59/0x80
 [<ffffffff812cb829>] device_register+0x19/0x20
 [<ffffffff81274021>] backlight_device_register+0xf1/0x1c0
 [<ffffffffa0281e53>] intel_panel_setup_backlight+0x73/0xf0 [i915]
 [<ffffffffa027640b>] ? intel_crt_init+0xeb/0x1d0 [i915]
 [<ffffffffa026ddc9>] intel_modeset_init+0x7c9/0x1100 [i915]
 [<ffffffffa024adc1>] i915_driver_load+0xc81/0x1170 [i915]
 [<ffffffffa01fe251>] ? drm_sysfs_device_add+0x81/0xb0 [drm]
 [<ffffffff81233cb7>] ? kobject_uevent_env+0x1b7/0x470
 [<ffffffffa01fb203>] ? drm_get_minor+0x243/0x300 [drm]
 [<ffffffffa01fd3b8>] drm_get_pci_dev+0x188/0x2b0 [drm]
 [<ffffffff81035b7d>] ? sub_preempt_count+0x9d/0xd0
 [<ffffffffa028e4a0>] i915_pci_probe+0x1b/0x13f [i915]
 [<ffffffff81253aea>] local_pci_probe+0x5a/0xd0
 [<ffffffff81254680>] pci_device_probe+0x80/0xb0
 [<ffffffff812cd71a>] ? driver_sysfs_add+0x7a/0xb0
 [<ffffffff812cd866>] driver_probe_device+0x96/0x1c0
 [<ffffffff812cd990>] ? driver_probe_device+0x1c0/0x1c0
 [<ffffffff812cda23>] __driver_attach+0x93/0xa0
 [<ffffffff812cd990>] ? driver_probe_device+0x1c0/0x1c0
 [<ffffffff812ccf58>] bus_for_each_dev+0x68/0x90
 [<ffffffff812cd699>] driver_attach+0x19/0x20
 [<ffffffff812cc808>] bus_add_driver+0x198/0x260
 [<ffffffff812ce078>] driver_register+0x78/0x140
 [<ffffffff81254931>] __pci_register_driver+0x51/0xd0
 [<ffffffffa01fd5f9>] drm_pci_init+0x119/0x130 [drm]
 [<ffffffffa02ae000>] ? 0xffffffffa02adfff
 [<ffffffffa02ae08b>] i915_init+0x8b/0x8d [i915]
 [<ffffffff810001ce>] do_one_initcall+0x3e/0x170
 [<ffffffff81075b9a>] sys_init_module+0x8a/0x1e0
 [<ffffffff814325fb>] system_call_fastpath+0x16/0x1b
---[ end trace 1c7dd79996e79e7a ]---

--=20

  Sergei

--MP_/w_Lw62m.EpigzYJH9eFIN+R
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=before-revert.txt

Linux version 3.1.0-rc2-00169-g5ccc387 (slyfox@sf) (gcc version 4.4.6 (Gent=
oo 4.4.6-r1 p1.0, pie-0.4.5) ) #137 SMP PREEMPT Fri Aug 26 18:46:56 EEST 20=
11
Command line: root=3D/dev/sda2 video=3DSVIDEO-1:d
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007e7b0000 (usable)
 BIOS-e820: 000000007e7b0000 - 000000007e7c5400 (reserved)
 BIOS-e820: 000000007e7c5400 - 000000007e7e7fb8 (ACPI NVS)
 BIOS-e820: 000000007e7e7fb8 - 000000007f000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000fed9a000 (reserved)
 BIOS-e820: 00000000feda0000 - 00000000fedc0000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 00000000ffc00000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
NX (Execute Disable) protection: active
DMI 2.4 present.
DMI: Hewlett-Packard HP Compaq 2510p Notebook PC/30C9, BIOS 68MSP Ver. F.0E=
 11/04/2008
e820 update range: 0000000000000000 - 0000000000010000 (usable) =3D=3D> (re=
served)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn =3D 0x7e7b0 max_arch_pfn =3D 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CFFFF write-protect
  D0000-EFFFF uncachable
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask F80000000 write-back
  1 base 07F000000 mask FFF000000 uncachable
  2 base 07E800000 mask FFF800000 uncachable
  3 base 0FEDA0000 mask FFFFE0000 uncachable
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
initial memory mapped : 0 - 20000000
Base memory trampoline at [ffff88000009a000] 9a000 size 20480
init_memory_mapping: 0000000000000000-000000007e7b0000
 0000000000 - 007e600000 page 2M
 007e600000 - 007e7b0000 page 4k
kernel direct mapping tables up to 7e7b0000 @ 7e7ac000-7e7b0000
ACPI: RSDP 00000000000f7980 00024 (v02 HP    )
ACPI: XSDT 000000007e7c81c8 0007C (v01 HPQOEM SLIC-MPC 00000001 HP   000000=
01)
ACPI: FACP 000000007e7c8084 000F4 (v04 HP     30C9     00000003 HP   000000=
01)
ACPI: DSDT 000000007e7c8538 13484 (v01 HP       nc2500 00010000 MSFT 030000=
01)
ACPI: FACS 000000007e7e7d80 00040
ACPI: SLIC 000000007e7c8244 00176 (v01 HPQOEM SLIC-MPC 00000001 HP   000000=
01)
ACPI: HPET 000000007e7c83bc 00038 (v01 HP     30C9     00000001 HP   000000=
01)
ACPI: APIC 000000007e7c83f4 00068 (v01 HP     30C9     00000001 HP   000000=
01)
ACPI: MCFG 000000007e7c845c 0003C (v01 HP     30C9     00000001 HP   000000=
01)
ACPI: TCPA 000000007e7c8498 00032 (v02 HP     30C9     00000001 HP   000000=
01)
ACPI: ASF! 000000007e7c84cc 00069 (v16 HP     CHIMAYU  00000001 HP   000000=
00)
ACPI: SSDT 000000007e7db9bc 002BE (v01 HP       HPQPAT 00000001 MSFT 030000=
01)
ACPI: SSDT 000000007e7dc5fe 0025F (v01 HP      Cpu0Tst 00003000 INTL 200603=
17)
ACPI: SSDT 000000007e7dc85d 000A6 (v01 HP      Cpu1Tst 00003000 INTL 200603=
17)
ACPI: SSDT 000000007e7dc903 004D7 (v01 HP        CpuPm 00003000 INTL 200603=
17)
ACPI: Local APIC address 0xfee00000
 [ffffea0000000000-ffffea0001ffffff] PMD -> [ffff88007be00000-ffff88007ddff=
fff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   empty
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0007e7b0
On node 0 totalpages: 517951
  DMA zone: 64 pages used for memmap
  DMA zone: 5 pages reserved
  DMA zone: 3914 pages, LIFO batch:0
  DMA32 zone: 8031 pages used for memmap
  DMA32 zone: 505937 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
Allocating PCI resources starting at 7f000000 (gap: 7f000000:7fc00000)
setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 25 pages/cpu @ffff88007e400000 s69760 r8192 d24448 u1048576
pcpu-alloc: s69760 r8192 d24448 u1048576 alloc=3D1*2097152
pcpu-alloc: [0] 0 1=20
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 509851
Kernel command line: root=3D/dev/sda2 video=3DSVIDEO-1:d
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Checking aperture...
No AGP bridge found
Memory: 2026004k/2072256k available (4312k kernel code, 452k absent, 45800k=
 reserved, 4245k data, 452k init)
SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
Preemptible hierarchical RCU implementation.
NR_IRQS:320
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 1197.030 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. =
2394.06 BogoMIPS (lpj=3D1197030)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 256
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
CPU0: Thermal monitoring handled by SMI
using mwait in idle threads.
ACPI: Core revision 20110623
..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
CPU0: Intel(R) Core(TM)2 Duo CPU     U7600  @ 1.20GHz stepping 0d
Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
PEBS disabled due to CPU errata.
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
NMI watchdog enabled, takes one hw-pmu counter.
Booting Node   0, Processors  #1 Ok.
smpboot cpu 1: start_ip =3D 9a000
CPU1: Thermal monitoring handled by SMI
NMI watchdog enabled, takes one hw-pmu counter.
Brought up 2 CPUs
Total of 2 processors activated (4787.95 BogoMIPS).
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (b=
ase 0xf8000000)
PCI: not using MMCONFIG
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: EC: Look up EC in DSDT
ACPI: SSDT 000000007e7dbd42 0023D (v01 HP      Cpu0Ist 00003000 INTL 200603=
17)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 0023D (v01 HP      Cpu0Ist 00003000 INTL 200603=
17)
ACPI: SSDT 000000007e7dc004 005FA (v01 HP      Cpu0Cst 00003001 INTL 200603=
17)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 005FA (v01 HP      Cpu0Cst 00003001 INTL 200603=
17)
ACPI: SSDT 000000007e7dbc7a 000C8 (v01 HP      Cpu1Ist 00003000 INTL 200603=
17)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 000C8 (v01 HP      Cpu1Ist 00003000 INTL 200603=
17)
ACPI: SSDT 000000007e7dbf7f 00085 (v01 HP      Cpu1Cst 00003000 INTL 200603=
17)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00085 (v01 HP      Cpu1Cst 00003000 INTL 200603=
17)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (b=
ase 0xf8000000)
PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in ACPI motherboard r=
esources
ACPI: Power Resource [C29F] (on)
ACPI: Power Resource [C1C7] (off)
ACPI: Power Resource [C3AD] (off)
ACPI: Power Resource [C3B0] (off)
ACPI: Power Resource [C3C3] (off)
ACPI: Power Resource [C3C4] (off)
ACPI: Power Resource [C3C5] (off)
ACPI: Power Resource [C3C6] (off)
ACPI: Power Resource [C3C7] (off)
ACPI: EC: GPE =3D 0x16, I/O: command/status =3D 0x66, data =3D 0x62
ACPI: No dock devices found.
PCI: Using host bridge windows from ACPI; if necessary, use "pci=3Dnocrs" a=
nd report a bug
ACPI: PCI Root Bridge [C003] (domain 0000 [bus 00-ff])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0x7e800000-0xfedfffff]
pci_root PNP0A08:00: host bridge window [mem 0xfee01000-0xffffffff]
pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
pci 0000:00:00.0: [8086:2a00] type 0 class 0x000600
pci 0000:00:02.0: [8086:2a02] type 0 class 0x000300
pci 0000:00:02.0: reg 10: [mem 0xe0400000-0xe04fffff 64bit]
pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:00:02.0: reg 20: [io  0x2000-0x2007]
pci 0000:00:02.1: [8086:2a03] type 0 class 0x000380
pci 0000:00:02.1: reg 10: [mem 0xe0500000-0xe05fffff 64bit]
pci 0000:00:03.0: [8086:2a04] type 0 class 0x000780
pci 0000:00:03.0: reg 10: [mem 0xe0600000-0xe060000f 64bit]
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:03.2: [8086:2a06] type 0 class 0x000101
pci 0000:00:03.2: reg 10: [io  0x2008-0x200f]
pci 0000:00:03.2: reg 14: [io  0x2010-0x2013]
pci 0000:00:03.2: reg 18: [io  0x2018-0x201f]
pci 0000:00:03.2: reg 1c: [io  0x2020-0x2023]
pci 0000:00:03.2: reg 20: [io  0x2030-0x203f]
pci 0000:00:03.3: [8086:2a07] type 0 class 0x000700
pci 0000:00:03.3: reg 10: [io  0x2040-0x2047]
pci 0000:00:03.3: reg 14: [mem 0xe0601000-0xe0601fff]
pci 0000:00:19.0: [8086:1049] type 0 class 0x000200
pci 0000:00:19.0: reg 10: [mem 0xe0620000-0xe063ffff]
pci 0000:00:19.0: reg 14: [mem 0xe0640000-0xe0640fff]
pci 0000:00:19.0: reg 18: [io  0x2060-0x207f]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:19.0: PME# disabled
pci 0000:00:1a.0: [8086:2834] type 0 class 0x000c03
pci 0000:00:1a.0: reg 20: [io  0x2080-0x209f]
pci 0000:00:1a.1: [8086:2835] type 0 class 0x000c03
pci 0000:00:1a.1: reg 20: [io  0x20a0-0x20bf]
pci 0000:00:1a.7: [8086:283a] type 0 class 0x000c03
pci 0000:00:1a.7: reg 10: [mem 0xe0641000-0xe06413ff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: [8086:284b] type 0 class 0x000403
pci 0000:00:1b.0: reg 10: [mem 0xe0644000-0xe0647fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: [8086:283f] type 1 class 0x000604
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: [8086:2841] type 1 class 0x000604
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1d.0: [8086:2830] type 0 class 0x000c03
pci 0000:00:1d.0: reg 20: [io  0x20c0-0x20df]
pci 0000:00:1d.1: [8086:2831] type 0 class 0x000c03
pci 0000:00:1d.1: reg 20: [io  0x20e0-0x20ff]
pci 0000:00:1d.2: [8086:2832] type 0 class 0x000c03
pci 0000:00:1d.2: reg 20: [io  0x2100-0x211f]
pci 0000:00:1d.7: [8086:2836] type 0 class 0x000c03
pci 0000:00:1d.7: reg 10: [mem 0xe0648000-0xe06483ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
pci 0000:00:1f.0: [8086:2811] type 0 class 0x000601
pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: [io  0x1100-0x113f] claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0500 (mask 007f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 02e8 (mask 0007)
pci 0000:00:1f.1: [8086:2850] type 0 class 0x000101
pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 20: [io  0x2120-0x212f]
pci 0000:00:1c.0: PCI bridge to [bus 08-08]
pci 0000:10:00.0: [8086:4229] type 0 class 0x000280
pci 0000:10:00.0: reg 10: [mem 0xe0000000-0xe0001fff 64bit]
pci 0000:10:00.0: PME# supported from D0 D3hot D3cold
pci 0000:10:00.0: PME# disabled
pci 0000:00:1c.1: PCI bridge to [bus 10-10]
pci 0000:00:1c.1:   bridge window [mem 0xe0000000-0xe00fffff]
pci 0000:02:06.0: [1180:0476] type 2 class 0x000607
pci 0000:02:06.0: proprietary Ricoh MMC controller disabled (via cardbus fu=
nction)
pci 0000:02:06.0: MMC cards are now supported by standard SDHCI controller
pci 0000:02:06.0: reg 10: [mem 0xe0100000-0xe0100fff]
pci 0000:02:06.0: supports D1 D2
pci 0000:02:06.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:06.0: PME# disabled
pci 0000:02:06.1: [1180:0832] type 0 class 0x000c00
pci 0000:02:06.1: reg 10: [mem 0xe0101000-0xe01017ff]
pci 0000:02:06.1: supports D1 D2
pci 0000:02:06.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:06.1: PME# disabled
pci 0000:02:06.2: [1180:0822] type 0 class 0x000805
pci 0000:02:06.2: reg 10: [mem 0xe0102000-0xe01020ff]
pci 0000:02:06.2: supports D1 D2
pci 0000:02:06.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:06.2: PME# disabled
pci 0000:00:1e.0: PCI bridge to [bus 02-03] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xe0100000-0xe03fffff]
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive =
decode)
pci 0000:00:1e.0:   bridge window [mem 0x7e800000-0xfedfffff] (subtractive =
decode)
pci 0000:00:1e.0:   bridge window [mem 0xfee01000-0xffffffff] (subtractive =
decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive =
decode)
pci_bus 0000:03: [bus 03-06] partially hidden behind transparent bridge 000=
0:02 [bus 02-03]
pci 0000:00:1c.0: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:00:1c.0: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:00:1c.1: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:00:1c.1: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:10:00.0: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:10:00.0: Dev MPS 128 MPSS 128 MRRS 128
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.C003._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C0B2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C11F._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C133._PRT]
 pci0000:00: Requesting ACPI _OSC control (0x1d)
 pci0000:00: ACPI _OSC control (0x1d) granted
ACPI: PCI Interrupt Link [C12F] (IRQs *10 11)
ACPI: PCI Interrupt Link [C130] (IRQs *10 11)
ACPI: PCI Interrupt Link [C131] (IRQs 10 *11)
ACPI: PCI Interrupt Link [C132] (IRQs 10 11) *5
ACPI: PCI Interrupt Link [C142] (IRQs *10 11)
ACPI: PCI Interrupt Link [C143] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C144] (IRQs 10 *11)
ACPI Exception: AE_NOT_FOUND, Evaluating _PRS (20110623/pci_link-184)
vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=3Dio+mem,locks=
=3Dnone
vgaarb: loaded
vgaarb: bridge control possible 0000:00:02.0
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Advanced Linux Sound Architecture Driver Version 1.0.24.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
Expanded resource reserved due to conflict with PCI Bus 0000:00
reserve RAM buffer: 000000000009fc00 - 000000000009ffff=20
reserve RAM buffer: 000000007e7b0000 - 000000007fffffff=20
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [mem 0x00000000-0x0009ffff]
pnp 00:00: [mem 0x000e0000-0x000fffff]
pnp 00:00: [mem 0x00100000-0x7e7fffff]
system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:00: [mem 0x000e0000-0x000fffff] could not be reserved
Switched to NOHz mode on CPU #0
Switched to NOHz mode on CPU #1
system 00:00: [mem 0x00100000-0x7e7fffff] could not be reserved
system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:01: [bus 00-ff]
pnp 00:01: [io  0x0cf8-0x0cff]
pnp 00:01: [io  0x0000-0x0cf7 window]
pnp 00:01: [io  0x0d00-0xffff window]
pnp 00:01: [mem 0x000a0000-0x000bffff window]
pnp 00:01: [mem 0x7e800000-0xfedfffff window]
pnp 00:01: [mem 0xfee01000-0xffffffff window]
pnp 00:01: [mem 0x000d0000-0x000dffff window]
pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:02: [io  0x00f0-0x00ff]
pnp 00:02: [irq 13]
pnp 00:02: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:03: [io  0x0000-0x000f]
pnp 00:03: [io  0x0080-0x008f]
pnp 00:03: [io  0x00c0-0x00df]
pnp 00:03: [dma 4]
pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:04: [io  0x0061]
pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:05: [io  0x0070-0x0071]
pnp 00:05: [io  0x0072-0x0073]
pnp 00:05: [irq 8]
pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:06: [mem 0xfed00000-0xfed003ff]
pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:07: [io  0x0060]
pnp 00:07: [io  0x0064]
pnp 00:07: [irq 1]
pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:08: [irq 12]
pnp 00:08: Plug and Play ACPI device, IDs SYN0130 SYN0100 SYN0002 PNP0f13 (=
active)
pnp 00:09: [io  0x0010-0x001f]
pnp 00:09: [io  0x0024-0x003f]
pnp 00:09: [io  0x004e-0x004f]
pnp 00:09: [io  0x0050-0x0053]
pnp 00:09: [io  0x0063]
pnp 00:09: [io  0x0065]
pnp 00:09: [io  0x0067]
pnp 00:09: [io  0x0074-0x0077]
pnp 00:09: [io  0x0090-0x009f]
pnp 00:09: [io  0x00a4-0x00bd]
pnp 00:09: [io  0x0500-0x057f]
pnp 00:09: [io  0x0800-0x080f]
pnp 00:09: [mem 0xffb00000-0xffbfffff]
pnp 00:09: [mem 0xfff00000-0xffffffff]
system 00:09: [io  0x0500-0x057f] has been reserved
system 00:09: [io  0x0800-0x080f] has been reserved
system 00:09: [mem 0xffb00000-0xffbfffff] has been reserved
system 00:09: [mem 0xfff00000-0xffffffff] has been reserved
system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0a: [irq 23]
pnp 00:0a: Plug and Play ACPI device, IDs HPQ0004 (active)
pnp 00:0b: [io  0x04d0-0x04d1]
pnp 00:0b: [io  0x02f8-0x02ff]
pnp 00:0b: [io  0x03f8-0x03ff]
pnp 00:0b: [io  0x1000-0x107f]
pnp 00:0b: [io  0x1100-0x113f]
pnp 00:0b: [io  0x1200-0x121f]
pnp 00:0b: [mem 0xf8000000-0xfbffffff]
pnp 00:0b: [mem 0xfec00000-0xfec000ff]
pnp 00:0b: [mem 0xfed20000-0xfed3ffff]
pnp 00:0b: [mem 0xfed45000-0xfed8ffff]
pnp 00:0b: [mem 0xfed90000-0xfed99fff]
system 00:0b: [io  0x04d0-0x04d1] has been reserved
system 00:0b: [io  0x02f8-0x02ff] has been reserved
system 00:0b: [io  0x03f8-0x03ff] has been reserved
system 00:0b: [io  0x1000-0x107f] has been reserved
system 00:0b: [io  0x1100-0x113f] has been reserved
system 00:0b: [io  0x1200-0x121f] has been reserved
system 00:0b: [mem 0xf8000000-0xfbffffff] has been reserved
system 00:0b: [mem 0xfec00000-0xfec000ff] could not be reserved
system 00:0b: [mem 0xfed20000-0xfed3ffff] has been reserved
system 00:0b: [mem 0xfed45000-0xfed8ffff] has been reserved
system 00:0b: [mem 0xfed90000-0xfed99fff] has been reserved
system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0c: [mem 0x000cee00-0x000cffff]
pnp 00:0c: [mem 0xfeda0000-0xfedbffff]
pnp 00:0c: [mem 0xfee00000-0xfee00fff]
system 00:0c: [mem 0x000cee00-0x000cffff] has been reserved
system 00:0c: [mem 0xfeda0000-0xfedbffff] has been reserved
system 00:0c: [mem 0xfee00000-0xfee00fff] has been reserved
system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
PCI: max bus depth: 2 pci_try_num: 3
pci 0000:00:1e.0: BAR 9: assigned [mem 0x80000000-0x83ffffff pref]
pci 0000:00:1e.0: BAR 7: assigned [io  0x3000-0x3fff]
pci 0000:00:1c.0: PCI bridge to [bus 08-08]
pci 0000:00:1c.1: PCI bridge to [bus 10-10]
pci 0000:00:1c.1:   bridge window [mem 0xe0000000-0xe00fffff]
pci 0000:02:06.0: BAR 10: assigned [mem 0x84000000-0x87ffffff]
pci 0000:02:06.0: BAR 9: assigned [mem 0x80000000-0x83ffffff pref]
pci 0000:02:06.0: BAR 8: assigned [io  0x3000-0x30ff]
pci 0000:02:06.0: BAR 7: assigned [io  0x3400-0x34ff]
pci 0000:02:06.0: CardBus bridge to [bus 03-06]
pci 0000:02:06.0:   bridge window [io  0x3400-0x34ff]
pci 0000:02:06.0:   bridge window [io  0x3000-0x30ff]
pci 0000:02:06.0:   bridge window [mem 0x80000000-0x83ffffff pref]
pci 0000:02:06.0:   bridge window [mem 0x84000000-0x87ffffff]
pci 0000:00:1e.0: PCI bridge to [bus 02-03]
pci 0000:00:1e.0:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1e.0:   bridge window [mem 0xe0100000-0xe03fffff]
pci 0000:00:1e.0:   bridge window [mem 0x80000000-0x83ffffff pref]
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci 0000:02:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x7e800000-0xfedfffff]
pci_bus 0000:00: resource 8 [mem 0xfee01000-0xffffffff]
pci_bus 0000:00: resource 9 [mem 0x000d0000-0x000dffff]
pci_bus 0000:10: resource 1 [mem 0xe0000000-0xe00fffff]
pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
pci_bus 0000:02: resource 1 [mem 0xe0100000-0xe03fffff]
pci_bus 0000:02: resource 2 [mem 0x80000000-0x83ffffff pref]
pci_bus 0000:02: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:02: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:02: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:02: resource 7 [mem 0x7e800000-0xfedfffff]
pci_bus 0000:02: resource 8 [mem 0xfee01000-0xffffffff]
pci_bus 0000:02: resource 9 [mem 0x000d0000-0x000dffff]
pci_bus 0000:03: resource 0 [io  0x3400-0x34ff]
pci_bus 0000:03: resource 1 [io  0x3000-0x30ff]
pci_bus 0000:03: resource 2 [mem 0x80000000-0x83ffffff pref]
pci_bus 0000:03: resource 3 [mem 0x84000000-0x87ffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
UDP hash table entries: 1024 (order: 3, 32768 bytes)
UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
NET: Registered protocol family 1
pci 0000:00:02.0: Boot video device
PCI: CLS 64 bytes, default 64
microcode: CPU0 sig=3D0x6fd, pf=3D0x80, revision=3D0xa3
microcode: CPU1 sig=3D0x6fd, pf=3D0x80, revision=3D0xa3
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Pe=
ter Oruba
HugeTLB registered 2 MB page size, pre-allocated 0 pages
Btrfs loaded
msgmni has been set to 3957
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler cfq registered (default)
pcieport 0000:00:1c.0: setting latency timer to 64
pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
pcieport 0000:00:1c.1: setting latency timer to 64
pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
pci 0000:10:00.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
intel_idle: MWAIT substates: 0x22220
intel_idle: does not run on family 6 model 15
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 965GM Chipset
agpgart-intel 0000:00:00.0: detected gtt size: 524288K total, 262144K mappa=
ble
agpgart-intel 0000:00:00.0: detected 8192K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
ata_piix 0000:00:1f.1: version 2.13
ata_piix 0000:00:1f.1: quirky BIOS, skipping spindown on poweroff and hiber=
nation
ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x2120 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x2128 irq 15
ata2: port disabled--ignoring
console [netcon0] enabled
netconsole: network logging started
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe0641000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=3D1d6b, idProduct=3D0002
usb usb1: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 3.1.0-rc2-00169-g5ccc387 ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xe0648000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=3D1d6b, idProduct=3D0002
usb usb2: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 3.1.0-rc2-00169-g5ccc387 ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x00002080
usb usb3: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb3: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 3.1.0-rc2-00169-g5ccc387 uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 17, io base 0x000020a0
usb usb4: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb4: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 3.1.0-rc2-00169-g5ccc387 uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 20, io base 0x000020c0
usb usb5: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb5: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 3.1.0-rc2-00169-g5ccc387 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.0
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 22, io base 0x000020e0
usb usb6: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb6: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 3.1.0-rc2-00169-g5ccc387 uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.1
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002100
usb usb7: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb7: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 3.1.0-rc2-00169-g5ccc387 uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.2
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
usbcore: registered new interface driver libusual
i8042: PNP: PS/2 Controller [PNP0303:C29C,PNP0f13:C29D] at 0x60,0x64 irq 1,=
12
i8042: Detected active multiplexing controller, rev 1.1
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
rtc_cmos 00:05: RTC can wake from S4
rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
ALSA device list:
  No soundcards found.
TCP cubic registered
NET: Registered protocol family 17
registered taskstats version 1
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input=
/input0
ata1.00: ATA-8: SAMSUNG HM641JI, 2AJ10001, max UDMA/133
ata1.00: 1250263728 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HM641JI  2AJ1 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 1250263728 512-byte logical blocks: (640 GB/596 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
usb 5-2: new full speed USB device number 2 using uhci_hcd
usb 5-2: New USB device found, idVendor=3D08ff, idProduct=3D2580
usb 5-2: New USB device strings: Mfr=3D0, Product=3D1, SerialNumber=3D0
usb 5-2: Product: Fingerprint Sensor
input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input1
Refined TSC clocksource calibration: 1196.999 MHz.
Switching to clocksource tsc
Synaptics Touchpad, model: 1, fw: 6.3, id: 0x1a0b1, caps: 0xa04711/0xa00000=
/0x0
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/i=
nput2
device label SF_ROOT devid 1 transid 27433 /dev/root
btrfs: disk space caching is enabled
VFS: Mounted root (btrfs filesystem) readonly on device 0:12.
Freeing unused kernel memory: 452k freed
Write protecting the kernel read-only data: 8192k
Freeing unused kernel memory: 1812k freed
Freeing unused kernel memory: 420k freed
udevd[796]: starting version 171
ACPI: Fan [C3B1] (off)
ACPI: Fan [C3B2] (off)
ACPI: Fan [C3C8] (off)
ACPI: Fan [C3C9] (off)
ACPI: Fan [C3CA] (off)
ACPI: Fan [C3CB] (off)
ACPI: Fan [C3CC] (off)
snd_hda_intel 0000:00:1b.0: power state changed by ACPI to D0
snd_hda_intel 0000:00:1b.0: power state changed by ACPI to D0
snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
snd_hda_intel 0000:00:1b.0: irq 42 for MSI/MSI-X
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI=
_PROCFS_POWER cleared
ACPI: AC Adapter [C23B] (off-line)
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/inpu=
t3
ACPI: Sleep Button [C2BF]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input4
ACPI: Lid Switch [C155]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
ACPI: Power Button [PWRF]
e1000e: Intel(R) PRO/1000 Network Driver - 1.4.4-k
e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
cfg80211: Calling CRDA to update world regulatory domain
ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG=
_ACPI_PROCFS_POWER cleared
ACPI: Battery Slot [C23D] (battery present)
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [TZ6] (25 C)
thermal LNXTHERM:01: registered as thermal_zone1
ACPI: Thermal Zone [TZ0] (58 C)
thermal LNXTHERM:02: registered as thermal_zone2
ACPI: Thermal Zone [TZ1] (57 C)
thermal LNXTHERM:03: registered as thermal_zone3
ACPI: Thermal Zone [TZ3] (47 C)
thermal LNXTHERM:04: registered as thermal_zone4
ACPI: Thermal Zone [TZ4] (40 C)
thermal LNXTHERM:05: registered as thermal_zone5
ACPI: Thermal Zone [TZ5] (18 C)
ACPI: acpi_idle registered with cpuidle
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
Marking TSC unstable due to TSC halts in idle
Switching to clocksource hpet
e1000e 0000:00:19.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
yenta_cardbus 0000:02:06.0: CardBus bridge found [103c:30c9]
iwl4965: Intel(R) Wireless WiFi 4965 driver for Linux, in-tree:
iwl4965: Copyright(c) 2003-2011 Intel Corporation
iwl4965 0000:10:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwl4965 0000:10:00.0: setting latency timer to 64
iwl4965 0000:10:00.0: Detected Intel(R) Wireless WiFi Link 4965AGN, REV=3D0=
x4
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
[drm] Initialized drm 1.1.0 20060810
iwl4965 0000:10:00.0: device EEPROM VER=3D0x36, CALIB=3D0x5
iwl4965 0000:10:00.0: Tunable channels: 13 802.11bg, 19 802.11a channels
iwl4965 0000:10:00.0: irq 44 for MSI/MSI-X
e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:1e:68:51:e5:60
e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
e1000e 0000:00:19.0: eth0: MAC: 6, PHY: 6, PBA No: FFFFFF-0FF
yenta_cardbus 0000:02:06.0: ISA IRQ mask 0x0cb8, PCI irq 18
yenta_cardbus 0000:02:06.0: Socket status: 30000006
pci_bus 0000:02: Raising subordinate bus# of parent bus (#02) from #03 to #=
06
sdhci-pci 0000:02:06.2: SDHCI controller found [1180:0822] (rev 21)
sdhci-pci 0000:02:06.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
sdhci-pci 0000:02:06.2: Will use DMA mode even though HW doesn't fully clai=
m to support it.
Registered led device: mmc0::
mmc0: SDHCI controller on PCI [0000:02:06.2] using DMA
iwl4965 0000:10:00.0: loaded firmware version 228.61.2.24
Registered led device: phy0-led
ieee80211 phy0: Selected rate control algorithm 'iwl-4965-rs'
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
i915 0000:00:02.0: irq 45 for MSI/MSI-X
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=3Dio+mem,decode=
s=3Dio+mem:owns=3Dio+mem
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0xb8/0xf0()
Hardware name: HP Compaq 2510p Notebook PC
sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:02.0/d=
rm/card0/card0-LVDS-1/intel_backlight'
Modules linked in: i915(+) drm_kms_helper drm sdhci_pci sdhci iwl4965 yenta=
_socket pcmcia_core iwl_legacy mmc_core mac80211 snd_hda_codec_analog proce=
ssor i2c_algo_bit thermal pcmcia_rsrc container cfg80211 e1000e battery but=
ton ac rfkill snd_hda_intel fan snd_hda_codec snd_hwdep
Pid: 828, comm: modprobe Not tainted 3.1.0-rc2-00169-g5ccc387 #137
Call Trace:
 [<ffffffff8103e7ba>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8103e891>] warn_slowpath_fmt+0x41/0x50
 [<ffffffff81130878>] sysfs_add_one+0xb8/0xf0
 [<ffffffff8113136c>] create_dir+0x7c/0xd0
 [<ffffffff8113143c>] sysfs_create_dir+0x7c/0xd0
 [<ffffffff81035b7d>] ? sub_preempt_count+0x9d/0xd0
 [<ffffffff8123302d>] kobject_add_internal+0xbd/0x200
 [<ffffffff81233288>] kobject_add_varg+0x38/0x60
 [<ffffffff81233364>] kobject_add+0x44/0x70
 [<ffffffff81232e4a>] ? kobject_get+0x1a/0x30
 [<ffffffff812cb218>] device_add+0x98/0x690
 [<ffffffff812d4d81>] ? pm_runtime_init+0xd1/0xe0
 [<ffffffff812d3ef9>] ? device_pm_init+0x59/0x80
 [<ffffffff812cb829>] device_register+0x19/0x20
 [<ffffffff81274021>] backlight_device_register+0xf1/0x1c0
 [<ffffffffa0281e53>] intel_panel_setup_backlight+0x73/0xf0 [i915]
 [<ffffffffa027640b>] ? intel_crt_init+0xeb/0x1d0 [i915]
 [<ffffffffa026ddc9>] intel_modeset_init+0x7c9/0x1100 [i915]
 [<ffffffffa024adc1>] i915_driver_load+0xc81/0x1170 [i915]
 [<ffffffffa01fe251>] ? drm_sysfs_device_add+0x81/0xb0 [drm]
 [<ffffffff81233cb7>] ? kobject_uevent_env+0x1b7/0x470
 [<ffffffffa01fb203>] ? drm_get_minor+0x243/0x300 [drm]
 [<ffffffffa01fd3b8>] drm_get_pci_dev+0x188/0x2b0 [drm]
 [<ffffffff81035b7d>] ? sub_preempt_count+0x9d/0xd0
 [<ffffffffa028e4a0>] i915_pci_probe+0x1b/0x13f [i915]
 [<ffffffff81253aea>] local_pci_probe+0x5a/0xd0
 [<ffffffff81254680>] pci_device_probe+0x80/0xb0
 [<ffffffff812cd71a>] ? driver_sysfs_add+0x7a/0xb0
 [<ffffffff812cd866>] driver_probe_device+0x96/0x1c0
 [<ffffffff812cd990>] ? driver_probe_device+0x1c0/0x1c0
 [<ffffffff812cda23>] __driver_attach+0x93/0xa0
 [<ffffffff812cd990>] ? driver_probe_device+0x1c0/0x1c0
 [<ffffffff812ccf58>] bus_for_each_dev+0x68/0x90
 [<ffffffff812cd699>] driver_attach+0x19/0x20
 [<ffffffff812cc808>] bus_add_driver+0x198/0x260
 [<ffffffff812ce078>] driver_register+0x78/0x140
 [<ffffffff81254931>] __pci_register_driver+0x51/0xd0
 [<ffffffffa01fd5f9>] drm_pci_init+0x119/0x130 [drm]
 [<ffffffffa02ae000>] ? 0xffffffffa02adfff
 [<ffffffffa02ae08b>] i915_init+0x8b/0x8d [i915]
 [<ffffffff810001ce>] do_one_initcall+0x3e/0x170
 [<ffffffff81075b9a>] sys_init_module+0x8a/0x1e0
 [<ffffffff814325fb>] system_call_fastpath+0x16/0x1b
---[ end trace 1c7dd79996e79e7a ]---
kobject_add_internal failed for intel_backlight with -EEXIST, don't try to =
register things with the same name in the same directory.
Pid: 828, comm: modprobe Tainted: G        W   3.1.0-rc2-00169-g5ccc387 #137
Call Trace:
 [<ffffffff812330cb>] kobject_add_internal+0x15b/0x200
 [<ffffffff81233288>] kobject_add_varg+0x38/0x60
 [<ffffffff81233364>] kobject_add+0x44/0x70
 [<ffffffff81232e4a>] ? kobject_get+0x1a/0x30
 [<ffffffff812cb218>] device_add+0x98/0x690
 [<ffffffff812d4d81>] ? pm_runtime_init+0xd1/0xe0
 [<ffffffff812d3ef9>] ? device_pm_init+0x59/0x80
 [<ffffffff812cb829>] device_register+0x19/0x20
 [<ffffffff81274021>] backlight_device_register+0xf1/0x1c0
 [<ffffffffa0281e53>] intel_panel_setup_backlight+0x73/0xf0 [i915]
 [<ffffffffa027640b>] ? intel_crt_init+0xeb/0x1d0 [i915]
 [<ffffffffa026ddc9>] intel_modeset_init+0x7c9/0x1100 [i915]
 [<ffffffffa024adc1>] i915_driver_load+0xc81/0x1170 [i915]
 [<ffffffffa01fe251>] ? drm_sysfs_device_add+0x81/0xb0 [drm]
 [<ffffffff81233cb7>] ? kobject_uevent_env+0x1b7/0x470
 [<ffffffffa01fb203>] ? drm_get_minor+0x243/0x300 [drm]
 [<ffffffffa01fd3b8>] drm_get_pci_dev+0x188/0x2b0 [drm]
 [<ffffffff81035b7d>] ? sub_preempt_count+0x9d/0xd0
 [<ffffffffa028e4a0>] i915_pci_probe+0x1b/0x13f [i915]
 [<ffffffff81253aea>] local_pci_probe+0x5a/0xd0
 [<ffffffff81254680>] pci_device_probe+0x80/0xb0
 [<ffffffff812cd71a>] ? driver_sysfs_add+0x7a/0xb0
 [<ffffffff812cd866>] driver_probe_device+0x96/0x1c0
 [<ffffffff812cd990>] ? driver_probe_device+0x1c0/0x1c0
 [<ffffffff812cda23>] __driver_attach+0x93/0xa0
 [<ffffffff812cd990>] ? driver_probe_device+0x1c0/0x1c0
 [<ffffffff812ccf58>] bus_for_each_dev+0x68/0x90
 [<ffffffff812cd699>] driver_attach+0x19/0x20
 [<ffffffff812cc808>] bus_add_driver+0x198/0x260
 [<ffffffff812ce078>] driver_register+0x78/0x140
 [<ffffffff81254931>] __pci_register_driver+0x51/0xd0
 [<ffffffffa01fd5f9>] drm_pci_init+0x119/0x130 [drm]
 [<ffffffffa02ae000>] ? 0xffffffffa02adfff
 [<ffffffffa02ae08b>] i915_init+0x8b/0x8d [i915]
 [<ffffffff810001ce>] do_one_initcall+0x3e/0x170
 [<ffffffff81075b9a>] sys_init_module+0x8a/0x1e0
 [<ffffffff814325fb>] system_call_fastpath+0x16/0x1b
[drm:intel_panel_setup_backlight] *ERROR* Failed to register backlight: -17
[drm] initialized overlay support
[drm] forcing SVIDEO-1 connector OFF
fbcon: inteldrmfb (fb0) is primary device
Console: switching to colour frame buffer device 160x50
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
ACPI Exception: AE_AML_PACKAGE_LIMIT, Index (0x0000000000000004) is beyond =
end of object (20110623/exoparg2-418)
ACPI Error: Method parse/execution failed [\_SB_.C003.C09A._DOD] (Node ffff=
88007b832988), AE_AML_PACKAGE_LIMIT (20110623/psparse-536)
ACPI Exception: AE_AML_PACKAGE_LIMIT, Evaluating _DOD (20110623/video-1147)
acpi device:01: registered as cooling_device9
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/i=
nput/input6
ACPI: Video Device [C09A] (multi-head: yes  rom: no  post: no)
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
fuse init (API version 7.16)
loop: module loaded
btrfs: enabling auto defrag
Adding 2096476k swap on /dev/sda3.  Priority:-1 extents:1 across:2096476k=20
CE: hpet increased min_delta_ns to 20113 nsec
e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
e1000e 0000:00:19.0: irq 43 for MSI/MSI-X

--MP_/w_Lw62m.EpigzYJH9eFIN+R
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=after-revert.txt

Linux version 3.1.0-rc2-00170-gec5e0c3 (slyfox@sf) (gcc version 4.4.6 (Gent=
oo 4.4.6-r1 p1.0, pie-0.4.5) ) #136 SMP PREEMPT Fri Aug 26 18:40:14 EEST 20=
11
Command line: root=3D/dev/sda2 video=3DSVIDEO-1:d
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007e7b0000 (usable)
 BIOS-e820: 000000007e7b0000 - 000000007e7c5400 (reserved)
 BIOS-e820: 000000007e7c5400 - 000000007e7e7fb8 (ACPI NVS)
 BIOS-e820: 000000007e7e7fb8 - 000000007f000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000fed9a000 (reserved)
 BIOS-e820: 00000000feda0000 - 00000000fedc0000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 00000000ffc00000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
NX (Execute Disable) protection: active
DMI 2.4 present.
DMI: Hewlett-Packard HP Compaq 2510p Notebook PC/30C9, BIOS 68MSP Ver. F.0E=
 11/04/2008
e820 update range: 0000000000000000 - 0000000000010000 (usable) =3D=3D> (re=
served)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn =3D 0x7e7b0 max_arch_pfn =3D 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CFFFF write-protect
  D0000-EFFFF uncachable
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask F80000000 write-back
  1 base 07F000000 mask FFF000000 uncachable
  2 base 07E800000 mask FFF800000 uncachable
  3 base 0FEDA0000 mask FFFFE0000 uncachable
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
initial memory mapped : 0 - 20000000
Base memory trampoline at [ffff88000009a000] 9a000 size 20480
init_memory_mapping: 0000000000000000-000000007e7b0000
 0000000000 - 007e600000 page 2M
 007e600000 - 007e7b0000 page 4k
kernel direct mapping tables up to 7e7b0000 @ 7e7ac000-7e7b0000
ACPI: RSDP 00000000000f7980 00024 (v02 HP    )
ACPI: XSDT 000000007e7c81c8 0007C (v01 HPQOEM SLIC-MPC 00000001 HP   000000=
01)
ACPI: FACP 000000007e7c8084 000F4 (v04 HP     30C9     00000003 HP   000000=
01)
ACPI: DSDT 000000007e7c8538 13484 (v01 HP       nc2500 00010000 MSFT 030000=
01)
ACPI: FACS 000000007e7e7d80 00040
ACPI: SLIC 000000007e7c8244 00176 (v01 HPQOEM SLIC-MPC 00000001 HP   000000=
01)
ACPI: HPET 000000007e7c83bc 00038 (v01 HP     30C9     00000001 HP   000000=
01)
ACPI: APIC 000000007e7c83f4 00068 (v01 HP     30C9     00000001 HP   000000=
01)
ACPI: MCFG 000000007e7c845c 0003C (v01 HP     30C9     00000001 HP   000000=
01)
ACPI: TCPA 000000007e7c8498 00032 (v02 HP     30C9     00000001 HP   000000=
01)
ACPI: ASF! 000000007e7c84cc 00069 (v16 HP     CHIMAYU  00000001 HP   000000=
00)
ACPI: SSDT 000000007e7db9bc 002BE (v01 HP       HPQPAT 00000001 MSFT 030000=
01)
ACPI: SSDT 000000007e7dc5fe 0025F (v01 HP      Cpu0Tst 00003000 INTL 200603=
17)
ACPI: SSDT 000000007e7dc85d 000A6 (v01 HP      Cpu1Tst 00003000 INTL 200603=
17)
ACPI: SSDT 000000007e7dc903 004D7 (v01 HP        CpuPm 00003000 INTL 200603=
17)
ACPI: Local APIC address 0xfee00000
 [ffffea0000000000-ffffea0001ffffff] PMD -> [ffff88007be00000-ffff88007ddff=
fff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   empty
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0007e7b0
On node 0 totalpages: 517951
  DMA zone: 64 pages used for memmap
  DMA zone: 5 pages reserved
  DMA zone: 3914 pages, LIFO batch:0
  DMA32 zone: 8031 pages used for memmap
  DMA32 zone: 505937 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
Allocating PCI resources starting at 7f000000 (gap: 7f000000:7fc00000)
setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 25 pages/cpu @ffff88007e400000 s69760 r8192 d24448 u1048576
pcpu-alloc: s69760 r8192 d24448 u1048576 alloc=3D1*2097152
pcpu-alloc: [0] 0 1=20
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 509851
Kernel command line: root=3D/dev/sda2 video=3DSVIDEO-1:d
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Checking aperture...
No AGP bridge found
Memory: 2026004k/2072256k available (4312k kernel code, 452k absent, 45800k=
 reserved, 4245k data, 452k init)
SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
Preemptible hierarchical RCU implementation.
NR_IRQS:320
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 1197.192 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. =
2394.38 BogoMIPS (lpj=3D1197192)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 256
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
CPU0: Thermal monitoring handled by SMI
using mwait in idle threads.
ACPI: Core revision 20110623
..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
CPU0: Intel(R) Core(TM)2 Duo CPU     U7600  @ 1.20GHz stepping 0d
Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
PEBS disabled due to CPU errata.
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
NMI watchdog enabled, takes one hw-pmu counter.
Booting Node   0, Processors  #1 Ok.
smpboot cpu 1: start_ip =3D 9a000
CPU1: Thermal monitoring handled by SMI
NMI watchdog enabled, takes one hw-pmu counter.
Brought up 2 CPUs
Total of 2 processors activated (4788.27 BogoMIPS).
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (b=
ase 0xf8000000)
PCI: not using MMCONFIG
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: EC: Look up EC in DSDT
ACPI: SSDT 000000007e7dbd42 0023D (v01 HP      Cpu0Ist 00003000 INTL 200603=
17)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 0023D (v01 HP      Cpu0Ist 00003000 INTL 200603=
17)
ACPI: SSDT 000000007e7dc004 005FA (v01 HP      Cpu0Cst 00003001 INTL 200603=
17)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 005FA (v01 HP      Cpu0Cst 00003001 INTL 200603=
17)
ACPI: SSDT 000000007e7dbc7a 000C8 (v01 HP      Cpu1Ist 00003000 INTL 200603=
17)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 000C8 (v01 HP      Cpu1Ist 00003000 INTL 200603=
17)
ACPI: SSDT 000000007e7dbf7f 00085 (v01 HP      Cpu1Cst 00003000 INTL 200603=
17)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00085 (v01 HP      Cpu1Cst 00003000 INTL 200603=
17)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (b=
ase 0xf8000000)
PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in ACPI motherboard r=
esources
ACPI: Power Resource [C29F] (on)
ACPI: Power Resource [C1C7] (off)
ACPI: Power Resource [C3AD] (off)
ACPI: Power Resource [C3B0] (off)
ACPI: Power Resource [C3C3] (off)
ACPI: Power Resource [C3C4] (off)
ACPI: Power Resource [C3C5] (off)
ACPI: Power Resource [C3C6] (off)
ACPI: Power Resource [C3C7] (off)
ACPI: EC: GPE =3D 0x16, I/O: command/status =3D 0x66, data =3D 0x62
ACPI: No dock devices found.
PCI: Using host bridge windows from ACPI; if necessary, use "pci=3Dnocrs" a=
nd report a bug
ACPI: PCI Root Bridge [C003] (domain 0000 [bus 00-ff])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0x7e800000-0xfedfffff]
pci_root PNP0A08:00: host bridge window [mem 0xfee01000-0xffffffff]
pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
pci 0000:00:00.0: [8086:2a00] type 0 class 0x000600
pci 0000:00:02.0: [8086:2a02] type 0 class 0x000300
pci 0000:00:02.0: reg 10: [mem 0xe0400000-0xe04fffff 64bit]
pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:00:02.0: reg 20: [io  0x2000-0x2007]
pci 0000:00:02.1: [8086:2a03] type 0 class 0x000380
pci 0000:00:02.1: reg 10: [mem 0xe0500000-0xe05fffff 64bit]
pci 0000:00:03.0: [8086:2a04] type 0 class 0x000780
pci 0000:00:03.0: reg 10: [mem 0xe0600000-0xe060000f 64bit]
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:03.2: [8086:2a06] type 0 class 0x000101
pci 0000:00:03.2: reg 10: [io  0x2008-0x200f]
pci 0000:00:03.2: reg 14: [io  0x2010-0x2013]
pci 0000:00:03.2: reg 18: [io  0x2018-0x201f]
pci 0000:00:03.2: reg 1c: [io  0x2020-0x2023]
pci 0000:00:03.2: reg 20: [io  0x2030-0x203f]
pci 0000:00:03.3: [8086:2a07] type 0 class 0x000700
pci 0000:00:03.3: reg 10: [io  0x2040-0x2047]
pci 0000:00:03.3: reg 14: [mem 0xe0601000-0xe0601fff]
pci 0000:00:19.0: [8086:1049] type 0 class 0x000200
pci 0000:00:19.0: reg 10: [mem 0xe0620000-0xe063ffff]
pci 0000:00:19.0: reg 14: [mem 0xe0640000-0xe0640fff]
pci 0000:00:19.0: reg 18: [io  0x2060-0x207f]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:19.0: PME# disabled
pci 0000:00:1a.0: [8086:2834] type 0 class 0x000c03
pci 0000:00:1a.0: reg 20: [io  0x2080-0x209f]
pci 0000:00:1a.1: [8086:2835] type 0 class 0x000c03
pci 0000:00:1a.1: reg 20: [io  0x20a0-0x20bf]
pci 0000:00:1a.7: [8086:283a] type 0 class 0x000c03
pci 0000:00:1a.7: reg 10: [mem 0xe0641000-0xe06413ff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: [8086:284b] type 0 class 0x000403
pci 0000:00:1b.0: reg 10: [mem 0xe0644000-0xe0647fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: [8086:283f] type 1 class 0x000604
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: [8086:2841] type 1 class 0x000604
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1d.0: [8086:2830] type 0 class 0x000c03
pci 0000:00:1d.0: reg 20: [io  0x20c0-0x20df]
pci 0000:00:1d.1: [8086:2831] type 0 class 0x000c03
pci 0000:00:1d.1: reg 20: [io  0x20e0-0x20ff]
pci 0000:00:1d.2: [8086:2832] type 0 class 0x000c03
pci 0000:00:1d.2: reg 20: [io  0x2100-0x211f]
pci 0000:00:1d.7: [8086:2836] type 0 class 0x000c03
pci 0000:00:1d.7: reg 10: [mem 0xe0648000-0xe06483ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
pci 0000:00:1f.0: [8086:2811] type 0 class 0x000601
pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: [io  0x1100-0x113f] claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0500 (mask 007f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 02e8 (mask 0007)
pci 0000:00:1f.1: [8086:2850] type 0 class 0x000101
pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 20: [io  0x2120-0x212f]
pci 0000:00:1c.0: PCI bridge to [bus 08-08]
pci 0000:10:00.0: [8086:4229] type 0 class 0x000280
pci 0000:10:00.0: reg 10: [mem 0xe0000000-0xe0001fff 64bit]
pci 0000:10:00.0: PME# supported from D0 D3hot D3cold
pci 0000:10:00.0: PME# disabled
pci 0000:00:1c.1: PCI bridge to [bus 10-10]
pci 0000:00:1c.1:   bridge window [mem 0xe0000000-0xe00fffff]
pci 0000:02:06.0: [1180:0476] type 2 class 0x000607
pci 0000:02:06.0: proprietary Ricoh MMC controller disabled (via cardbus fu=
nction)
pci 0000:02:06.0: MMC cards are now supported by standard SDHCI controller
pci 0000:02:06.0: reg 10: [mem 0xe0100000-0xe0100fff]
pci 0000:02:06.0: supports D1 D2
pci 0000:02:06.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:06.0: PME# disabled
pci 0000:02:06.1: [1180:0832] type 0 class 0x000c00
pci 0000:02:06.1: reg 10: [mem 0xe0101000-0xe01017ff]
pci 0000:02:06.1: supports D1 D2
pci 0000:02:06.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:06.1: PME# disabled
pci 0000:02:06.2: [1180:0822] type 0 class 0x000805
pci 0000:02:06.2: reg 10: [mem 0xe0102000-0xe01020ff]
pci 0000:02:06.2: supports D1 D2
pci 0000:02:06.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:06.2: PME# disabled
pci 0000:00:1e.0: PCI bridge to [bus 02-03] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xe0100000-0xe03fffff]
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive =
decode)
pci 0000:00:1e.0:   bridge window [mem 0x7e800000-0xfedfffff] (subtractive =
decode)
pci 0000:00:1e.0:   bridge window [mem 0xfee01000-0xffffffff] (subtractive =
decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive =
decode)
pci_bus 0000:03: [bus 03-06] partially hidden behind transparent bridge 000=
0:02 [bus 02-03]
pci 0000:00:1c.0: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:00:1c.0: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:00:1c.1: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:00:1c.1: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:10:00.0: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:10:00.0: Dev MPS 128 MPSS 128 MRRS 128
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.C003._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C0B2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C11F._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C133._PRT]
 pci0000:00: Requesting ACPI _OSC control (0x1d)
 pci0000:00: ACPI _OSC control (0x1d) granted
ACPI: PCI Interrupt Link [C12F] (IRQs *10 11)
ACPI: PCI Interrupt Link [C130] (IRQs *10 11)
ACPI: PCI Interrupt Link [C131] (IRQs 10 *11)
ACPI: PCI Interrupt Link [C132] (IRQs 10 11) *5
ACPI: PCI Interrupt Link [C142] (IRQs *10 11)
ACPI: PCI Interrupt Link [C143] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C144] (IRQs 10 *11)
ACPI Exception: AE_NOT_FOUND, Evaluating _PRS (20110623/pci_link-184)
vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=3Dio+mem,locks=
=3Dnone
vgaarb: loaded
vgaarb: bridge control possible 0000:00:02.0
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Advanced Linux Sound Architecture Driver Version 1.0.24.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
Expanded resource reserved due to conflict with PCI Bus 0000:00
reserve RAM buffer: 000000000009fc00 - 000000000009ffff=20
reserve RAM buffer: 000000007e7b0000 - 000000007fffffff=20
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [mem 0x00000000-0x0009ffff]
pnp 00:00: [mem 0x000e0000-0x000fffff]
pnp 00:00: [mem 0x00100000-0x7e7fffff]
system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:00: [mem 0x000e0000-0x000fffff] could not be reserved
Switched to NOHz mode on CPU #0
Switched to NOHz mode on CPU #1
system 00:00: [mem 0x00100000-0x7e7fffff] could not be reserved
system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:01: [bus 00-ff]
pnp 00:01: [io  0x0cf8-0x0cff]
pnp 00:01: [io  0x0000-0x0cf7 window]
pnp 00:01: [io  0x0d00-0xffff window]
pnp 00:01: [mem 0x000a0000-0x000bffff window]
pnp 00:01: [mem 0x7e800000-0xfedfffff window]
pnp 00:01: [mem 0xfee01000-0xffffffff window]
pnp 00:01: [mem 0x000d0000-0x000dffff window]
pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:02: [io  0x00f0-0x00ff]
pnp 00:02: [irq 13]
pnp 00:02: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:03: [io  0x0000-0x000f]
pnp 00:03: [io  0x0080-0x008f]
pnp 00:03: [io  0x00c0-0x00df]
pnp 00:03: [dma 4]
pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:04: [io  0x0061]
pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:05: [io  0x0070-0x0071]
pnp 00:05: [io  0x0072-0x0073]
pnp 00:05: [irq 8]
pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:06: [mem 0xfed00000-0xfed003ff]
pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:07: [io  0x0060]
pnp 00:07: [io  0x0064]
pnp 00:07: [irq 1]
pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:08: [irq 12]
pnp 00:08: Plug and Play ACPI device, IDs SYN0130 SYN0100 SYN0002 PNP0f13 (=
active)
pnp 00:09: [io  0x0010-0x001f]
pnp 00:09: [io  0x0024-0x003f]
pnp 00:09: [io  0x004e-0x004f]
pnp 00:09: [io  0x0050-0x0053]
pnp 00:09: [io  0x0063]
pnp 00:09: [io  0x0065]
pnp 00:09: [io  0x0067]
pnp 00:09: [io  0x0074-0x0077]
pnp 00:09: [io  0x0090-0x009f]
pnp 00:09: [io  0x00a4-0x00bd]
pnp 00:09: [io  0x0500-0x057f]
pnp 00:09: [io  0x0800-0x080f]
pnp 00:09: [mem 0xffb00000-0xffbfffff]
pnp 00:09: [mem 0xfff00000-0xffffffff]
system 00:09: [io  0x0500-0x057f] has been reserved
system 00:09: [io  0x0800-0x080f] has been reserved
system 00:09: [mem 0xffb00000-0xffbfffff] has been reserved
system 00:09: [mem 0xfff00000-0xffffffff] has been reserved
system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0a: [irq 23]
pnp 00:0a: Plug and Play ACPI device, IDs HPQ0004 (active)
pnp 00:0b: [io  0x04d0-0x04d1]
pnp 00:0b: [io  0x02f8-0x02ff]
pnp 00:0b: [io  0x03f8-0x03ff]
pnp 00:0b: [io  0x1000-0x107f]
pnp 00:0b: [io  0x1100-0x113f]
pnp 00:0b: [io  0x1200-0x121f]
pnp 00:0b: [mem 0xf8000000-0xfbffffff]
pnp 00:0b: [mem 0xfec00000-0xfec000ff]
pnp 00:0b: [mem 0xfed20000-0xfed3ffff]
pnp 00:0b: [mem 0xfed45000-0xfed8ffff]
pnp 00:0b: [mem 0xfed90000-0xfed99fff]
system 00:0b: [io  0x04d0-0x04d1] has been reserved
system 00:0b: [io  0x02f8-0x02ff] has been reserved
system 00:0b: [io  0x03f8-0x03ff] has been reserved
system 00:0b: [io  0x1000-0x107f] has been reserved
system 00:0b: [io  0x1100-0x113f] has been reserved
system 00:0b: [io  0x1200-0x121f] has been reserved
system 00:0b: [mem 0xf8000000-0xfbffffff] has been reserved
system 00:0b: [mem 0xfec00000-0xfec000ff] could not be reserved
system 00:0b: [mem 0xfed20000-0xfed3ffff] has been reserved
system 00:0b: [mem 0xfed45000-0xfed8ffff] has been reserved
system 00:0b: [mem 0xfed90000-0xfed99fff] has been reserved
system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0c: [mem 0x000cee00-0x000cffff]
pnp 00:0c: [mem 0xfeda0000-0xfedbffff]
pnp 00:0c: [mem 0xfee00000-0xfee00fff]
system 00:0c: [mem 0x000cee00-0x000cffff] has been reserved
system 00:0c: [mem 0xfeda0000-0xfedbffff] has been reserved
system 00:0c: [mem 0xfee00000-0xfee00fff] has been reserved
system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
PCI: max bus depth: 2 pci_try_num: 3
pci 0000:00:1e.0: BAR 9: assigned [mem 0x80000000-0x83ffffff pref]
pci 0000:00:1e.0: BAR 7: assigned [io  0x3000-0x3fff]
pci 0000:00:1c.0: PCI bridge to [bus 08-08]
pci 0000:00:1c.1: PCI bridge to [bus 10-10]
pci 0000:00:1c.1:   bridge window [mem 0xe0000000-0xe00fffff]
pci 0000:02:06.0: BAR 10: assigned [mem 0x84000000-0x87ffffff]
pci 0000:02:06.0: BAR 9: assigned [mem 0x80000000-0x83ffffff pref]
pci 0000:02:06.0: BAR 8: assigned [io  0x3000-0x30ff]
pci 0000:02:06.0: BAR 7: assigned [io  0x3400-0x34ff]
pci 0000:02:06.0: CardBus bridge to [bus 03-06]
pci 0000:02:06.0:   bridge window [io  0x3400-0x34ff]
pci 0000:02:06.0:   bridge window [io  0x3000-0x30ff]
pci 0000:02:06.0:   bridge window [mem 0x80000000-0x83ffffff pref]
pci 0000:02:06.0:   bridge window [mem 0x84000000-0x87ffffff]
pci 0000:00:1e.0: PCI bridge to [bus 02-03]
pci 0000:00:1e.0:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1e.0:   bridge window [mem 0xe0100000-0xe03fffff]
pci 0000:00:1e.0:   bridge window [mem 0x80000000-0x83ffffff pref]
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci 0000:02:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x7e800000-0xfedfffff]
pci_bus 0000:00: resource 8 [mem 0xfee01000-0xffffffff]
pci_bus 0000:00: resource 9 [mem 0x000d0000-0x000dffff]
pci_bus 0000:10: resource 1 [mem 0xe0000000-0xe00fffff]
pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
pci_bus 0000:02: resource 1 [mem 0xe0100000-0xe03fffff]
pci_bus 0000:02: resource 2 [mem 0x80000000-0x83ffffff pref]
pci_bus 0000:02: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:02: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:02: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:02: resource 7 [mem 0x7e800000-0xfedfffff]
pci_bus 0000:02: resource 8 [mem 0xfee01000-0xffffffff]
pci_bus 0000:02: resource 9 [mem 0x000d0000-0x000dffff]
pci_bus 0000:03: resource 0 [io  0x3400-0x34ff]
pci_bus 0000:03: resource 1 [io  0x3000-0x30ff]
pci_bus 0000:03: resource 2 [mem 0x80000000-0x83ffffff pref]
pci_bus 0000:03: resource 3 [mem 0x84000000-0x87ffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
UDP hash table entries: 1024 (order: 3, 32768 bytes)
UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
NET: Registered protocol family 1
pci 0000:00:02.0: Boot video device
PCI: CLS 64 bytes, default 64
microcode: CPU0 sig=3D0x6fd, pf=3D0x80, revision=3D0xa3
microcode: CPU1 sig=3D0x6fd, pf=3D0x80, revision=3D0xa3
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Pe=
ter Oruba
HugeTLB registered 2 MB page size, pre-allocated 0 pages
Btrfs loaded
msgmni has been set to 3957
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler cfq registered (default)
pcieport 0000:00:1c.0: setting latency timer to 64
pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
pcieport 0000:00:1c.1: setting latency timer to 64
pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
pci 0000:10:00.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
intel_idle: MWAIT substates: 0x22220
intel_idle: does not run on family 6 model 15
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 965GM Chipset
agpgart-intel 0000:00:00.0: detected gtt size: 524288K total, 262144K mappa=
ble
agpgart-intel 0000:00:00.0: detected 8192K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
ata_piix 0000:00:1f.1: version 2.13
ata_piix 0000:00:1f.1: quirky BIOS, skipping spindown on poweroff and hiber=
nation
ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x2120 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x2128 irq 15
ata2: port disabled--ignoring
console [netcon0] enabled
netconsole: network logging started
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe0641000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=3D1d6b, idProduct=3D0002
usb usb1: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 3.1.0-rc2-00170-gec5e0c3 ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xe0648000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=3D1d6b, idProduct=3D0002
usb usb2: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 3.1.0-rc2-00170-gec5e0c3 ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x00002080
usb usb3: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb3: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 3.1.0-rc2-00170-gec5e0c3 uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 17, io base 0x000020a0
usb usb4: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb4: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 3.1.0-rc2-00170-gec5e0c3 uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 20, io base 0x000020c0
usb usb5: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb5: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 3.1.0-rc2-00170-gec5e0c3 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.0
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 22, io base 0x000020e0
usb usb6: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb6: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 3.1.0-rc2-00170-gec5e0c3 uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.1
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002100
usb usb7: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb7: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 3.1.0-rc2-00170-gec5e0c3 uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.2
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
usbcore: registered new interface driver libusual
i8042: PNP: PS/2 Controller [PNP0303:C29C,PNP0f13:C29D] at 0x60,0x64 irq 1,=
12
i8042: Detected active multiplexing controller, rev 1.1
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
rtc_cmos 00:05: RTC can wake from S4
rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
ALSA device list:
  No soundcards found.
TCP cubic registered
NET: Registered protocol family 17
registered taskstats version 1
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input=
/input0
ata1.00: ATA-8: SAMSUNG HM641JI, 2AJ10001, max UDMA/133
ata1.00: 1250263728 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HM641JI  2AJ1 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 1250263728 512-byte logical blocks: (640 GB/596 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
usb 5-2: new full speed USB device number 2 using uhci_hcd
usb 5-2: New USB device found, idVendor=3D08ff, idProduct=3D2580
usb 5-2: New USB device strings: Mfr=3D0, Product=3D1, SerialNumber=3D0
usb 5-2: Product: Fingerprint Sensor
input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input1
Refined TSC clocksource calibration: 1196.999 MHz.
Switching to clocksource tsc
Synaptics Touchpad, model: 1, fw: 6.3, id: 0x1a0b1, caps: 0xa04711/0xa00000=
/0x0
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/i=
nput2
device label SF_ROOT devid 1 transid 27416 /dev/root
btrfs: disk space caching is enabled
VFS: Mounted root (btrfs filesystem) readonly on device 0:12.
Freeing unused kernel memory: 452k freed
Write protecting the kernel read-only data: 8192k
Freeing unused kernel memory: 1812k freed
Freeing unused kernel memory: 420k freed
udevd[797]: starting version 171
e1000e: Intel(R) PRO/1000 Network Driver - 1.4.4-k
e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
e1000e 0000:00:19.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
ACPI: Fan [C3B1] (off)
ACPI: Fan [C3B2] (off)
ACPI: Fan [C3C8] (off)
ACPI: Fan [C3C9] (off)
ACPI: Fan [C3CA] (off)
ACPI: Fan [C3CB] (off)
ACPI: Fan [C3CC] (off)
ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG=
_ACPI_PROCFS_POWER cleared
ACPI: Battery Slot [C23D] (battery present)
cfg80211: Calling CRDA to update world regulatory domain
e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:1e:68:51:e5:60
e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
e1000e 0000:00:19.0: eth0: MAC: 6, PHY: 6, PBA No: FFFFFF-0FF
ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI=
_PROCFS_POWER cleared
ACPI: AC Adapter [C23B] (off-line)
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/inpu=
t3
ACPI: Sleep Button [C2BF]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input4
ACPI: Lid Switch [C155]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
ACPI: Power Button [PWRF]
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [TZ6] (25 C)
thermal LNXTHERM:01: registered as thermal_zone1
ACPI: Thermal Zone [TZ0] (61 C)
thermal LNXTHERM:02: registered as thermal_zone2
ACPI: Thermal Zone [TZ1] (62 C)
thermal LNXTHERM:03: registered as thermal_zone3
ACPI: Thermal Zone [TZ3] (51 C)
thermal LNXTHERM:04: registered as thermal_zone4
ACPI: Thermal Zone [TZ4] (40 C)
thermal LNXTHERM:05: registered as thermal_zone5
ACPI: Thermal Zone [TZ5] (0 C)
ACPI: acpi_idle registered with cpuidle
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
Marking TSC unstable due to TSC halts in idle
Switching to clocksource hpet
snd_hda_intel 0000:00:1b.0: power state changed by ACPI to D0
snd_hda_intel 0000:00:1b.0: power state changed by ACPI to D0
snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
snd_hda_intel 0000:00:1b.0: irq 43 for MSI/MSI-X
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
yenta_cardbus 0000:02:06.0: CardBus bridge found [103c:30c9]
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
iwl4965: Intel(R) Wireless WiFi 4965 driver for Linux, in-tree:
iwl4965: Copyright(c) 2003-2011 Intel Corporation
iwl4965 0000:10:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwl4965 0000:10:00.0: setting latency timer to 64
iwl4965 0000:10:00.0: Detected Intel(R) Wireless WiFi Link 4965AGN, REV=3D0=
x4
yenta_cardbus 0000:02:06.0: ISA IRQ mask 0x0cb8, PCI irq 18
yenta_cardbus 0000:02:06.0: Socket status: 30000006
pci_bus 0000:02: Raising subordinate bus# of parent bus (#02) from #03 to #=
06
[drm] Initialized drm 1.1.0 20060810
sdhci-pci 0000:02:06.2: SDHCI controller found [1180:0822] (rev 21)
sdhci-pci 0000:02:06.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
sdhci-pci 0000:02:06.2: Will use DMA mode even though HW doesn't fully clai=
m to support it.
Registered led device: mmc0::
mmc0: SDHCI controller on PCI [0000:02:06.2] using DMA
iwl4965 0000:10:00.0: device EEPROM VER=3D0x36, CALIB=3D0x5
iwl4965 0000:10:00.0: Tunable channels: 13 802.11bg, 19 802.11a channels
iwl4965 0000:10:00.0: irq 44 for MSI/MSI-X
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
iwl4965 0000:10:00.0: loaded firmware version 228.61.2.24
Registered led device: phy0-led
ieee80211 phy0: Selected rate control algorithm 'iwl-4965-rs'
i915 0000:00:02.0: irq 45 for MSI/MSI-X
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=3Dio+mem,decode=
s=3Dio+mem:owns=3Dio+mem
[drm] initialized overlay support
[drm] forcing SVIDEO-1 connector OFF
fbcon: inteldrmfb (fb0) is primary device
Console: switching to colour frame buffer device 160x50
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
ACPI Exception: AE_AML_PACKAGE_LIMIT, Index (0x0000000000000004) is beyond =
end of object (20110623/exoparg2-418)
ACPI Error: Method parse/execution failed [\_SB_.C003.C09A._DOD] (Node ffff=
88007b832988), AE_AML_PACKAGE_LIMIT (20110623/psparse-536)
ACPI Exception: AE_AML_PACKAGE_LIMIT, Evaluating _DOD (20110623/video-1147)
acpi device:01: registered as cooling_device9
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/i=
nput/input6
ACPI: Video Device [C09A] (multi-head: yes  rom: no  post: no)
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
fuse init (API version 7.16)
loop: module loaded
btrfs: enabling auto defrag
Adding 2096476k swap on /dev/sda3.  Priority:-1 extents:1 across:2096476k=20
e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
e1000e 0000:00:19.0: irq 42 for MSI/MSI-X

--MP_/w_Lw62m.EpigzYJH9eFIN+R
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename=0001-Revert-Not-all-systems-expose-a-firmware-or-platform.patch

=46rom ec5e0c336b3ca84df7ed17ab2ed8648bf0948998 Mon Sep 17 00:00:00 2001
From: Sergei Trofimovich <slyfox@gentoo.org>
Date: Fri, 26 Aug 2011 18:38:35 +0300
Subject: [PATCH] Revert "Not all systems expose a firmware or platform mech=
anism for changing the backlight intensity on i915, so add native driver su=
pport."

This reverts commit aaa6fd2a004147bf32fce05720938236de3361d9.
---
 drivers/gpu/drm/i915/i915_drv.h       |    4 --
 drivers/gpu/drm/i915/intel_dp.c       |    7 ---
 drivers/gpu/drm/i915/intel_drv.h      |    3 +-
 drivers/gpu/drm/i915/intel_lvds.c     |    5 --
 drivers/gpu/drm/i915/intel_opregion.c |    1 +
 drivers/gpu/drm/i915/intel_panel.c    |   72 +----------------------------=
----
 6 files changed, 3 insertions(+), 89 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_dr=
v.h
index 7916bd9..feb4f16 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -36,7 +36,6 @@
 #include <linux/io-mapping.h>
 #include <linux/i2c.h>
 #include <drm/intel-gtt.h>
-#include <linux/backlight.h>
=20
 /* General customization:
  */
@@ -691,7 +690,6 @@ typedef struct drm_i915_private {
 	int child_dev_num;
 	struct child_device_config *child_dev;
 	struct drm_connector *int_lvds_connector;
-	struct drm_connector *int_edp_connector;
=20
 	bool mchbar_need_disable;
=20
@@ -725,8 +723,6 @@ typedef struct drm_i915_private {
 	/* list of fbdev register on this device */
 	struct intel_fbdev *fbdev;
=20
-	struct backlight_device *backlight;
-
 	struct drm_property *broadcast_rgb_property;
 	struct drm_property *force_audio_property;
=20
diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_d=
p.c
index 44fef5e..0feae90 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1841,11 +1841,6 @@ done:
 static void
 intel_dp_destroy (struct drm_connector *connector)
 {
-	struct drm_device *dev =3D connector->dev;
-
-	if (intel_dpd_is_edp(dev))
-		intel_panel_destroy_backlight(dev);
-
 	drm_sysfs_connector_remove(connector);
 	drm_connector_cleanup(connector);
 	kfree(connector);
@@ -2077,8 +2072,6 @@ intel_dp_init(struct drm_device *dev, int output_reg)
 					DRM_MODE_TYPE_PREFERRED;
 			}
 		}
-		dev_priv->int_edp_connector =3D connector;
-		intel_panel_setup_backlight(dev);
 	}
=20
 	intel_dp_add_properties(intel_dp, connector);
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_=
drv.h
index 0b2ee9d..7b330e7 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -297,10 +297,9 @@ extern void intel_pch_panel_fitting(struct drm_device =
*dev,
 extern u32 intel_panel_get_max_backlight(struct drm_device *dev);
 extern u32 intel_panel_get_backlight(struct drm_device *dev);
 extern void intel_panel_set_backlight(struct drm_device *dev, u32 level);
-extern int intel_panel_setup_backlight(struct drm_device *dev);
+extern void intel_panel_setup_backlight(struct drm_device *dev);
 extern void intel_panel_enable_backlight(struct drm_device *dev);
 extern void intel_panel_disable_backlight(struct drm_device *dev);
-extern void intel_panel_destroy_backlight(struct drm_device *dev);
 extern enum drm_connector_status intel_panel_detect(struct drm_device *dev=
);
=20
 extern void intel_crtc_load_lut(struct drm_crtc *crtc);
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel=
_lvds.c
index 31da77f..8b521a2 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -552,8 +552,6 @@ static void intel_lvds_destroy(struct drm_connector *co=
nnector)
 	struct drm_device *dev =3D connector->dev;
 	struct drm_i915_private *dev_priv =3D dev->dev_private;
=20
-	intel_panel_destroy_backlight(dev);
-
 	if (dev_priv->lid_notifier.notifier_call)
 		acpi_lid_notifier_unregister(&dev_priv->lid_notifier);
 	drm_sysfs_connector_remove(connector);
@@ -1034,9 +1032,6 @@ out:
 	/* keep the LVDS connector */
 	dev_priv->int_lvds_connector =3D connector;
 	drm_sysfs_connector_add(connector);
-
-	intel_panel_setup_backlight(dev);
-
 	return true;
=20
 failed:
diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/i=
ntel_opregion.c
index b8e8158b..b7c5ddb 100644
--- a/drivers/gpu/drm/i915/intel_opregion.c
+++ b/drivers/gpu/drm/i915/intel_opregion.c
@@ -227,6 +227,7 @@ void intel_opregion_asle_intr(struct drm_device *dev)
 	asle->aslc =3D asle_stat;
 }
=20
+/* Only present on Ironlake+ */
 void intel_opregion_gse_intr(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv =3D dev->dev_private;
diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/inte=
l_panel.c
index a9e0c7b..05f500c 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -277,7 +277,7 @@ void intel_panel_enable_backlight(struct drm_device *de=
v)
 	dev_priv->backlight_enabled =3D true;
 }
=20
-static void intel_panel_init_backlight(struct drm_device *dev)
+void intel_panel_setup_backlight(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv =3D dev->dev_private;
=20
@@ -309,73 +309,3 @@ intel_panel_detect(struct drm_device *dev)
=20
 	return connector_status_unknown;
 }
-
-#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
-static int intel_panel_update_status(struct backlight_device *bd)
-{
-	struct drm_device *dev =3D bl_get_data(bd);
-	intel_panel_set_backlight(dev, bd->props.brightness);
-	return 0;
-}
-
-static int intel_panel_get_brightness(struct backlight_device *bd)
-{
-	struct drm_device *dev =3D bl_get_data(bd);
-	return intel_panel_get_backlight(dev);
-}
-
-static const struct backlight_ops intel_panel_bl_ops =3D {
-	.update_status =3D intel_panel_update_status,
-	.get_brightness =3D intel_panel_get_brightness,
-};
-
-int intel_panel_setup_backlight(struct drm_device *dev)
-{
-	struct drm_i915_private *dev_priv =3D dev->dev_private;
-	struct backlight_properties props;
-	struct drm_connector *connector;
-
-	intel_panel_init_backlight(dev);
-
-	if (dev_priv->int_lvds_connector)
-		connector =3D dev_priv->int_lvds_connector;
-	else if (dev_priv->int_edp_connector)
-		connector =3D dev_priv->int_edp_connector;
-	else
-		return -ENODEV;
-
-	props.type =3D BACKLIGHT_RAW;
-	props.max_brightness =3D intel_panel_get_max_backlight(dev);
-	dev_priv->backlight =3D
-		backlight_device_register("intel_backlight",
-					  &connector->kdev, dev,
-					  &intel_panel_bl_ops, &props);
-
-	if (IS_ERR(dev_priv->backlight)) {
-		DRM_ERROR("Failed to register backlight: %ld\n",
-			  PTR_ERR(dev_priv->backlight));
-		dev_priv->backlight =3D NULL;
-		return -ENODEV;
-	}
-	dev_priv->backlight->props.brightness =3D intel_panel_get_backlight(dev);
-	return 0;
-}
-
-void intel_panel_destroy_backlight(struct drm_device *dev)
-{
-	struct drm_i915_private *dev_priv =3D dev->dev_private;
-	if (dev_priv->backlight)
-		backlight_device_unregister(dev_priv->backlight);
-}
-#else
-int intel_panel_setup_backlight(struct drm_device *dev)
-{
-	intel_panel_init_backlight(dev);
-	return 0;
-}
-
-void intel_panel_destroy_backlight(struct drm_device *dev)
-{
-	return;
-}
-#endif
--=20
1.7.3.4


--MP_/w_Lw62m.EpigzYJH9eFIN+R--

--Sig_/sba6/q/4XIiFLFOf1WtUJh0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk5YAmQACgkQcaHudmEf86rE/gCcCHdBDK33oMjsoBHgEDKWSAUR
35EAnAqA2yiAodyKfL9VJq+4N0xNJASK
=ZAi/
-----END PGP SIGNATURE-----

--Sig_/sba6/q/4XIiFLFOf1WtUJh0--
