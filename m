Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab1HSNKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:10:48 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:50012 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751685Ab1HSNKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:10:43 -0400
X-Authenticated: #815327
X-Provags-ID: V01U2FsdGVkX18bZCpjheEb2FvXUwWLhaJcm10Jre7hgyH7hIPQ93
	oW+yMOtnBVKCA5
Message-ID: <4E4E60C8.2090209@gmx.de>
Date: Fri, 19 Aug 2011 15:10:32 +0200
From: =?ISO-8859-1?Q?Malte_Schr=F6der?= <maltesch@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Icedove/5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: linux 2.6.39 & 3.0 fail to boot on ION mainboard, bisected
X-Enigmail-Version: 1.2.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF9A8F47632958CE2EE5287E7"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF9A8F47632958CE2EE5287E7
Content-Type: multipart/mixed;
 boundary="------------070507000406000907090407"

This is a multi-part message in MIME format.
--------------070507000406000907090407
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,
starting with 2.6.39, linux fails to boot the ASUS AT3N7A-I.
git bisect shows

[8eb90c30e0e815a1308828352eabd03ca04229dd] sched: Switch
wait_task_inactive to schedule_hrtimeout()

as the responsible change. I reverted it on 3.0.3 and the system
actually boots. The system doesn't seem to "work right" that way, i.e.
VDR doesn't start and the system seems overall sluggish.

Without that patch reverted, the kernel stops here:
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.0.3-vdr3-00280-gc9c8f9f (root@highlander)
(gcc version 4.6.1 (Debian 4.6.1-7) ) #1 SMP PREEMPT Fri Aug 19 14:33:09
CEST 2011
[    0.000000] Command line:
BOOT_IMAGE=3D/vmlinuz-3.0.3-vdr3-00280-gc9c8f9f
root=3DUUID=3Dc900708e-25b3-4743-9c67-2b03a62f3d73 ro quiet fastboot
[    0.000000] Disabled fast string operations
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)=

[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)=

[    0.000000]  BIOS-e820: 0000000000100000 - 000000005ff90000 (usable)
[    0.000000]  BIOS-e820: 000000005ff90000 - 000000005ff9e000 (ACPI data=
)
[    0.000000]  BIOS-e820: 000000005ff9e000 - 000000005ffd0000 (ACPI NVS)=

[    0.000000]  BIOS-e820: 000000005ffd0000 - 0000000080000000 (reserved)=

[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)=

[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)=

[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)=

[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: System manufacturer System Product Name/AT3N7A-I,
BIOS 0216    10/12/2009
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000
(usable) =3D=3D> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000
(usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn =3D 0x5ff90 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask 080000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new
0x7010600070106
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 20=
480
[    0.000000] init_memory_mapping: 0000000000000000-000000005ff90000
[    0.000000]  0000000000 - 005fe00000 page 2M
[    0.000000]  005fe00000 - 005ff90000 page 4k
[    0.000000] kernel direct mapping tables up to 5ff90000 @
5ff8c000-5ff90000
[    0.000000] RAMDISK: 377f0000 - 37bf0000
[    0.000000] ACPI: RSDP 00000000000fbde0 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 000000005ff90100 0005C (v01 101209 XSDT0912
20091012 MSFT 00000097)
[    0.000000] ACPI: FACP 000000005ff90290 000F4 (v03 101209 FACP0912
20091012 MSFT 00000097)
[    0.000000] ACPI: DSDT 000000005ff904a0 0997C (v01  A1417 A1417000
00000000 INTL 20051117)
[    0.000000] ACPI: FACS 000000005ff9e000 00040
[    0.000000] ACPI: APIC 000000005ff90390 00080 (v01 101209 APIC0912
20091012 MSFT 00000097)
[    0.000000] ACPI: MCFG 000000005ff90410 0003C (v01 101209 OEMMCFG
20091012 MSFT 00000097)
[    0.000000] ACPI: WDRT 000000005ff90450 00047 (v01 101209 NV-WDRT
20091012 MSFT 00000097)
[    0.000000] ACPI: OEMB 000000005ff9e040 0007A (v01 101209 OEMB0912
20091012 MSFT 00000097)
[    0.000000] ACPI: HPET 000000005ff99e20 00038 (v01 101209 OEMHPET0
20091012 MSFT 00000097)
[    0.000000] ACPI: NVHD 000000005ff9e0c0 00284 (v01 101209  NVHDCP
20091012 MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00015fffff] PMD ->
[ffff88005de00000-ffff88005f3fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0005ff90
[    0.000000] On node 0 totalpages: 392991
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3922 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 5319 pages used for memmap
[    0.000000]   DMA32 zone: 383689 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level=
)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edg=
e)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edg=
e)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 -
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 -
00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 -
0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap:
80000000:7ec00000)
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:4
nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88005fc00000 s70016
r8192 d24192 u524288
[    0.000000] pcpu-alloc: s70016 r8192 d24192 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 387611
[    0.000000] Kernel command line:
BOOT_IMAGE=3D/vmlinuz-3.0.3-vdr3-00280-gc9c8f9f
root=3DUUID=3Dc900708e-25b3-4743-9c67-2b03a62f3d73 ro quiet fastboot
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 262144 (order: 9,
2097152 bytes)
[    0.000000] Inode-cache hash table entries: 131072 (order: 8, 1048576
bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 1534200k/1572416k available (4592k kernel code,
452k absent, 37764k reserved, 1907k data, 452k init)
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0,
CPUs=3D4, Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] Extended CMOS year: 8200
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1599.874 MHz processor.
[    0.003341] Calibrating delay loop (skipped), value calculated using
timer frequency.. 3201.07 BogoMIPS (lpj=3D5332913)
[    0.003351] pid_max: default: 32768 minimum: 301
[    0.003440] Mount-cache hash table entries: 256
[    0.003697] Initializing cgroup subsys cpuacct
[    0.003711] Initializing cgroup subsys freezer
[    0.003716] Initializing cgroup subsys blkio
[    0.003753] Disabled fast string operations
[    0.003761] CPU: Physical Processor ID: 0
[    0.003764] CPU: Processor Core ID: 0
[    0.003768] mce: CPU supports 5 MCE banks
[    0.003781] CPU0: Thermal monitoring enabled (TM2)
[    0.003788] using mwait in idle threads.
[    0.003823] ACPI: Core revision 20110413
[    0.016665] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.049709] CPU0: Intel(R) Atom(TM) CPU  330   @ 1.60GHz stepping 02
[    0.049997] Performance Events: PEBS fmt0+, Atom events, Intel PMU
driver.
[    0.049997] ... version:                3
[    0.049997] ... bit width:              40
[    0.049997] ... generic registers:      2
[    0.049997] ... value mask:             000000ffffffffff
[    0.049997] ... max period:             000000007fffffff
[    0.049997] ... fixed-purpose events:   3
[    0.049997] ... event mask:             0000000700000003
[    0.066700] Booting Node   0, Processors  #1

=2Econfig and full dmesg (from successful boot with the patch reverted ar=
e
attached.

I hope this can be fixed easily :)
--=20
Gru=DF
Malte Schr=F6der
---------------------------------------------------------------------
MalteSch@gmx.de

--------------070507000406000907090407
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="dmesg.txt"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.0.3-vdr3-00280-gc9c8f9f (root@highlander) =
(gcc version 4.6.1 (Debian 4.6.1-7) ) #1 SMP PREEMPT Fri Aug 19 14:33:09 =
CEST 2011
[    0.000000] Command line: BOOT_IMAGE=3D/vmlinuz-3.0.3-vdr3-00280-gc9c8=
f9f root=3DUUID=3Dc900708e-25b3-4743-9c67-2b03a62f3d73 ro quiet fastboot
[    0.000000] Disabled fast string operations
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)=

[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)=

[    0.000000]  BIOS-e820: 0000000000100000 - 000000005ff90000 (usable)
[    0.000000]  BIOS-e820: 000000005ff90000 - 000000005ff9e000 (ACPI data=
)
[    0.000000]  BIOS-e820: 000000005ff9e000 - 000000005ffd0000 (ACPI NVS)=

[    0.000000]  BIOS-e820: 000000005ffd0000 - 0000000080000000 (reserved)=

[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)=

[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)=

[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)=

[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: System manufacturer System Product Name/AT3N7A-I, BIO=
S 0216    10/12/2009
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (us=
able) =3D=3D> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (us=
able)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn =3D 0x5ff90 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask 080000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600=
070106
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 20=
480
[    0.000000] init_memory_mapping: 0000000000000000-000000005ff90000
[    0.000000]  0000000000 - 005fe00000 page 2M
[    0.000000]  005fe00000 - 005ff90000 page 4k
[    0.000000] kernel direct mapping tables up to 5ff90000 @ 5ff8c000-5ff=
90000
[    0.000000] RAMDISK: 377f0000 - 37bf0000
[    0.000000] ACPI: RSDP 00000000000fbde0 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 000000005ff90100 0005C (v01 101209 XSDT0912 200=
91012 MSFT 00000097)
[    0.000000] ACPI: FACP 000000005ff90290 000F4 (v03 101209 FACP0912 200=
91012 MSFT 00000097)
[    0.000000] ACPI: DSDT 000000005ff904a0 0997C (v01  A1417 A1417000 000=
00000 INTL 20051117)
[    0.000000] ACPI: FACS 000000005ff9e000 00040
[    0.000000] ACPI: APIC 000000005ff90390 00080 (v01 101209 APIC0912 200=
91012 MSFT 00000097)
[    0.000000] ACPI: MCFG 000000005ff90410 0003C (v01 101209 OEMMCFG  200=
91012 MSFT 00000097)
[    0.000000] ACPI: WDRT 000000005ff90450 00047 (v01 101209 NV-WDRT  200=
91012 MSFT 00000097)
[    0.000000] ACPI: OEMB 000000005ff9e040 0007A (v01 101209 OEMB0912 200=
91012 MSFT 00000097)
[    0.000000] ACPI: HPET 000000005ff99e20 00038 (v01 101209 OEMHPET0 200=
91012 MSFT 00000097)
[    0.000000] ACPI: NVHD 000000005ff9e0c0 00284 (v01 101209  NVHDCP  200=
91012 MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00015fffff] PMD -> [ffff88005de00=
000-ffff88005f3fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0005ff90
[    0.000000] On node 0 totalpages: 392991
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3922 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 5319 pages used for memmap
[    0.000000]   DMA32 zone: 383689 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level=
)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edg=
e)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edg=
e)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 000000000=
00a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 000000000=
00e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 000000000=
0100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 800000=
00:7ec00000)
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:4 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88005fc00000 s70016 r81=
92 d24192 u524288
[    0.000000] pcpu-alloc: s70016 r8192 d24192 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  To=
tal pages: 387611
[    0.000000] Kernel command line: BOOT_IMAGE=3D/vmlinuz-3.0.3-vdr3-0028=
0-gc9c8f9f root=3DUUID=3Dc900708e-25b3-4743-9c67-2b03a62f3d73 ro quiet fa=
stboot
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 262144 (order: 9, 2097152=
 bytes)
[    0.000000] Inode-cache hash table entries: 131072 (order: 8, 1048576 =
bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 1534200k/1572416k available (4592k kernel code, 45=
2k absent, 37764k reserved, 1907k data, 452k init)
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D4, Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] Extended CMOS year: 8200
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1599.874 MHz processor.
[    0.003341] Calibrating delay loop (skipped), value calculated using t=
imer frequency.. 3201.07 BogoMIPS (lpj=3D5332913)
[    0.003351] pid_max: default: 32768 minimum: 301
[    0.003440] Mount-cache hash table entries: 256
[    0.003697] Initializing cgroup subsys cpuacct
[    0.003711] Initializing cgroup subsys freezer
[    0.003716] Initializing cgroup subsys blkio
[    0.003753] Disabled fast string operations
[    0.003761] CPU: Physical Processor ID: 0
[    0.003764] CPU: Processor Core ID: 0
[    0.003768] mce: CPU supports 5 MCE banks
[    0.003781] CPU0: Thermal monitoring enabled (TM2)
[    0.003788] using mwait in idle threads.
[    0.003823] ACPI: Core revision 20110413
[    0.016665] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.049709] CPU0: Intel(R) Atom(TM) CPU  330   @ 1.60GHz stepping 02
[    0.049997] Performance Events: PEBS fmt0+, Atom events, Intel PMU dri=
ver.
[    0.049997] ... version:                3
[    0.049997] ... bit width:              40
[    0.049997] ... generic registers:      2
[    0.049997] ... value mask:             000000ffffffffff
[    0.049997] ... max period:             000000007fffffff
[    0.049997] ... fixed-purpose events:   3
[    0.049997] ... event mask:             0000000700000003
[    0.066700] Booting Node   0, Processors  #1
[    0.066708] smpboot cpu 1: start_ip =3D 9a000
[    0.006666] Disabled fast string operations
[    0.170030]  #2
[    0.170035] smpboot cpu 2: start_ip =3D 9a000
[    0.006666] Disabled fast string operations
[    0.273371]  #3 Ok.
[    0.273376] smpboot cpu 3: start_ip =3D 9a000
[    0.006666] Disabled fast string operations
[    0.369997] Brought up 4 CPUs
[    0.370005] Total of 4 processors activated (12804.96 BogoMIPS).
[    0.371280] PM: Registering ACPI NVS region at 5ff9e000 (204800 bytes)=

[    0.371280] Time: 12:48:41  Date: 08/19/11
[    0.371280] NET: Registered protocol family 16
[    0.373360] ACPI: bus type pci registered
[    0.373385] PCI: MMCONFIG for domain 0000 [bus 00-1f] at [mem 0xfc0000=
00-0xfdffffff] (base 0xfc000000)
[    0.373385] PCI: not using MMCONFIG
[    0.373385] PCI: Using configuration type 1 for base access
[    0.387056] bio: create slab <bio-0> at 0
[    0.392893] ACPI: EC: Look up EC in DSDT
[    0.396932] ACPI: Executed 1 blocks of module-level executable AML cod=
e
[    0.405909] ACPI: Interpreter enabled
[    0.405919] ACPI: (supports S0 S1 S3 S4 S5)
[    0.405967] ACPI: Using IOAPIC for interrupt routing
[    0.406042] PCI: MMCONFIG for domain 0000 [bus 00-1f] at [mem 0xfc0000=
00-0xfdffffff] (base 0xfc000000)
[    0.408829] PCI: MMCONFIG at [mem 0xfc000000-0xfdffffff] reserved in A=
CPI motherboard resources
[    0.446802] ACPI: No dock devices found.
[    0.446812] PCI: Using host bridge windows from ACPI; if necessary, us=
e "pci=3Dnocrs" and report a bug
[    0.447411] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.447488] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7=
]
[    0.447488] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff=
]
[    0.447488] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x=
000bffff]
[    0.447488] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x=
000dffff]
[    0.447488] pci_root PNP0A03:00: host bridge window [mem 0x80000000-0x=
fbffffff]
[    0.447488] pci_root PNP0A03:00: host bridge window [mem 0xfe000000-0x=
febfffff]
[    0.447488] pci 0000:00:00.0: [10de:0a82] type 0 class 0x000600
[    0.447488] pci 0000:00:00.1: [10de:0a88] type 0 class 0x000500
[    0.447488] pci 0000:00:03.0: [10de:0aad] type 0 class 0x000601
[    0.447488] pci 0000:00:03.0: reg 10: [io  0x4f00-0x4fff]
[    0.447542] pci 0000:00:03.1: [10de:0aa4] type 0 class 0x000500
[    0.447641] pci 0000:00:03.2: [10de:0aa2] type 0 class 0x000c05
[    0.447662] pci 0000:00:03.2: reg 10: [io  0x4900-0x493f]
[    0.447692] pci 0000:00:03.2: reg 20: [io  0x4d00-0x4d3f]
[    0.447703] pci 0000:00:03.2: reg 24: [io  0x4e00-0x4e3f]
[    0.447738] pci 0000:00:03.2: PME# supported from D3hot D3cold
[    0.447748] pci 0000:00:03.2: PME# disabled
[    0.447775] pci 0000:00:03.3: [10de:0a89] type 0 class 0x000500
[    0.447938] pci 0000:00:03.5: [10de:0aa3] type 0 class 0x000b40
[    0.447963] pci 0000:00:03.5: reg 10: [mem 0xf5f80000-0xf5ffffff]
[    0.448101] pci 0000:00:04.0: [10de:0aa5] type 0 class 0x000c03
[    0.448119] pci 0000:00:04.0: reg 10: [mem 0xf5f7f000-0xf5f7ffff]
[    0.448175] pci 0000:00:04.0: supports D1 D2
[    0.448180] pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.448188] pci 0000:00:04.0: PME# disabled
[    0.448211] pci 0000:00:04.1: [10de:0aa6] type 0 class 0x000c03
[    0.448231] pci 0000:00:04.1: reg 10: [mem 0xf5f7ec00-0xf5f7ecff]
[    0.448293] pci 0000:00:04.1: supports D1 D2
[    0.448298] pci 0000:00:04.1: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.448305] pci 0000:00:04.1: PME# disabled
[    0.448340] pci 0000:00:06.0: [10de:0aa7] type 0 class 0x000c03
[    0.448358] pci 0000:00:06.0: reg 10: [mem 0xf5f7d000-0xf5f7dfff]
[    0.448414] pci 0000:00:06.0: supports D1 D2
[    0.448419] pci 0000:00:06.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.448426] pci 0000:00:06.0: PME# disabled
[    0.448453] pci 0000:00:06.1: [10de:0aa9] type 0 class 0x000c03
[    0.448474] pci 0000:00:06.1: reg 10: [mem 0xf5f7e800-0xf5f7e8ff]
[    0.448537] pci 0000:00:06.1: supports D1 D2
[    0.448542] pci 0000:00:06.1: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.448549] pci 0000:00:06.1: PME# disabled
[    0.448582] pci 0000:00:08.0: [10de:0ac0] type 0 class 0x000403
[    0.448600] pci 0000:00:08.0: reg 10: [mem 0xf5f78000-0xf5f7bfff]
[    0.448657] pci 0000:00:08.0: PME# supported from D3hot D3cold
[    0.448664] pci 0000:00:08.0: PME# disabled
[    0.448685] pci 0000:00:09.0: [10de:0aab] type 1 class 0x000604
[    0.448747] pci 0000:00:0b.0: [10de:0ab4] type 0 class 0x000101
[    0.448766] pci 0000:00:0b.0: reg 10: [io  0xc080-0xc087]
[    0.448777] pci 0000:00:0b.0: reg 14: [io  0xc000-0xc003]
[    0.448788] pci 0000:00:0b.0: reg 18: [io  0xbc00-0xbc07]
[    0.448798] pci 0000:00:0b.0: reg 1c: [io  0xb880-0xb883]
[    0.448809] pci 0000:00:0b.0: reg 20: [io  0xb800-0xb80f]
[    0.448820] pci 0000:00:0b.0: reg 24: [mem 0xf5f76000-0xf5f77fff]
[    0.448876] pci 0000:00:10.0: [10de:0aa0] type 1 class 0x000604
[    0.448922] pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.448929] pci 0000:00:10.0: PME# disabled
[    0.448993] pci 0000:00:15.0: [10de:0ac6] type 1 class 0x000604
[    0.450130] pci 0000:00:15.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.450142] pci 0000:00:15.0: PME# disabled
[    0.450247] pci 0000:01:05.0: [14f1:8800] type 0 class 0x000400
[    0.450272] pci 0000:01:05.0: reg 10: [mem 0xf9000000-0xf9ffffff]
[    0.450370] pci 0000:01:05.1: [14f1:8801] type 0 class 0x000480
[    0.450391] pci 0000:01:05.1: reg 10: [mem 0xf8000000-0xf8ffffff]
[    0.450484] pci 0000:01:05.2: [14f1:8802] type 0 class 0x000480
[    0.450506] pci 0000:01:05.2: reg 10: [mem 0xf7000000-0xf7ffffff]
[    0.450597] pci 0000:01:05.4: [14f1:8804] type 0 class 0x000480
[    0.450617] pci 0000:01:05.4: reg 10: [mem 0xf6000000-0xf6ffffff]
[    0.450730] pci 0000:00:09.0: PCI bridge to [bus 01-01] (subtractive d=
ecode)
[    0.450739] pci 0000:00:09.0:   bridge window [io  0xf000-0x0000] (dis=
abled)
[    0.450746] pci 0000:00:09.0:   bridge window [mem 0xf6000000-0xf9ffff=
ff]
[    0.450754] pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fff=
ff pref] (disabled)
[    0.450760] pci 0000:00:09.0:   bridge window [io  0x0000-0x0cf7] (sub=
tractive decode)
[    0.450767] pci 0000:00:09.0:   bridge window [io  0x0d00-0xffff] (sub=
tractive decode)
[    0.450773] pci 0000:00:09.0:   bridge window [mem 0x000a0000-0x000bff=
ff] (subtractive decode)
[    0.450779] pci 0000:00:09.0:   bridge window [mem 0x000d0000-0x000dff=
ff] (subtractive decode)
[    0.450786] pci 0000:00:09.0:   bridge window [mem 0x80000000-0xfbffff=
ff] (subtractive decode)
[    0.450792] pci 0000:00:09.0:   bridge window [mem 0xfe000000-0xfebfff=
ff] (subtractive decode)
[    0.450842] pci 0000:02:00.0: [10de:087d] type 0 class 0x000300
[    0.450863] pci 0000:02:00.0: reg 10: [mem 0xfa000000-0xfaffffff]
[    0.450881] pci 0000:02:00.0: reg 14: [mem 0xe0000000-0xefffffff 64bit=
 pref]
[    0.450898] pci 0000:02:00.0: reg 1c: [mem 0xf2000000-0xf3ffffff 64bit=
 pref]
[    0.450911] pci 0000:02:00.0: reg 24: [io  0xdc00-0xdc7f]
[    0.450924] pci 0000:02:00.0: reg 30: [mem 0xfbee0000-0xfbefffff pref]=

[    0.450988] pci 0000:00:10.0: PCI bridge to [bus 02-02]
[    0.450996] pci 0000:00:10.0:   bridge window [io  0xd000-0xdfff]
[    0.451003] pci 0000:00:10.0:   bridge window [mem 0xfa000000-0xfbefff=
ff]
[    0.451012] pci 0000:00:10.0:   bridge window [mem 0xe0000000-0xf3ffff=
ff 64bit pref]
[    0.451181] pci 0000:03:00.0: [10ec:8168] type 0 class 0x000200
[    0.451202] pci 0000:03:00.0: reg 10: [io  0xe800-0xe8ff]
[    0.451232] pci 0000:03:00.0: reg 18: [mem 0xf4fff000-0xf4ffffff 64bit=
 pref]
[    0.451253] pci 0000:03:00.0: reg 20: [mem 0xf4ff8000-0xf4ffbfff 64bit=
 pref]
[    0.451269] pci 0000:03:00.0: reg 30: [mem 0xfbff0000-0xfbffffff pref]=

[    0.451311] pci 0000:03:00.0: supports D1 D2
[    0.451316] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.451324] pci 0000:03:00.0: PME# disabled
[    0.456672] pci 0000:00:15.0: PCI bridge to [bus 03-03]
[    0.456691] pci 0000:00:15.0:   bridge window [io  0xe000-0xefff]
[    0.456703] pci 0000:00:15.0:   bridge window [mem 0xfbf00000-0xfbffff=
ff]
[    0.456722] pci 0000:00:15.0:   bridge window [mem 0xf4f00000-0xf4ffff=
ff 64bit pref]
[    0.456753] pci_bus 0000:00: on NUMA node 0
[    0.456764] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.457048] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PBB0._PRT]
[    0.457148] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IXVE._PRT]
[    0.457240] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    0.457619]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.458085]  pci0000:00: ACPI _OSC request failed (AE_SUPPORT), return=
ed control mask: 0x0c
[    0.458091] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.473602] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *15
[    0.473855] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.474105] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.474354] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.474604] ACPI: PCI Interrupt Link [LN0A] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.474857] ACPI: PCI Interrupt Link [LN0B] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.475115] ACPI: PCI Interrupt Link [LN0C] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.476811] ACPI: PCI Interrupt Link [LN0D] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.477064] ACPI: PCI Interrupt Link [LN1A] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.477321] ACPI: PCI Interrupt Link [LN1B] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.477572] ACPI: PCI Interrupt Link [LN1C] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.477822] ACPI: PCI Interrupt Link [LN1D] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.478073] ACPI: PCI Interrupt Link [LN2A] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.478324] ACPI: PCI Interrupt Link [LN2B] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.478574] ACPI: PCI Interrupt Link [LN2C] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.478824] ACPI: PCI Interrupt Link [LN2D] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.479082] ACPI: PCI Interrupt Link [LN3A] (IRQs 16 17 18 19) *10
[    0.479332] ACPI: PCI Interrupt Link [LN3B] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.479583] ACPI: PCI Interrupt Link [LN3C] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.479834] ACPI: PCI Interrupt Link [LN3D] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.480112] ACPI: PCI Interrupt Link [LN4A] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.480364] ACPI: PCI Interrupt Link [LN4B] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.480616] ACPI: PCI Interrupt Link [LN4C] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.480867] ACPI: PCI Interrupt Link [LN4D] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.481118] ACPI: PCI Interrupt Link [LN5A] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.481369] ACPI: PCI Interrupt Link [LN5B] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.481621] ACPI: PCI Interrupt Link [LN5C] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.481873] ACPI: PCI Interrupt Link [LN5D] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.482125] ACPI: PCI Interrupt Link [LN6A] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.482377] ACPI: PCI Interrupt Link [LN6B] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.482631] ACPI: PCI Interrupt Link [LN6C] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.482889] ACPI: PCI Interrupt Link [LN6D] (IRQs 16 17 18 19) *0, dis=
abled.
[    0.483154] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *14
[    0.483451] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
[    0.483725] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, dis=
abled.
[    0.483985] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *9
[    0.484242] ACPI: PCI Interrupt Link [SGRU] (IRQs 20 21 22 23) *11
[    0.484500] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *9
[    0.484757] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *15
[    0.485023] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *5
[    0.485313] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, dis=
abled.
[    0.485573] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *10
[    0.485830] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *11
[    0.486091] ACPI: PCI Interrupt Link [LRP0] (IRQs 20 21 22 23) *0, dis=
abled.
[    0.486345] ACPI: PCI Interrupt Link [LRP1] (IRQs 20 21 22 23) *0, dis=
abled.
[    0.486598] ACPI: PCI Interrupt Link [LRP2] (IRQs 20 21 22 23) *0, dis=
abled.
[    0.486883] ACPI: PCI Interrupt Link [LRP3] (IRQs 20 21 22 23) *10
[    0.487146] ACPI: PCI Interrupt Link [LRP4] (IRQs 20 21 22 23) *0, dis=
abled.
[    0.487400] ACPI: PCI Interrupt Link [LRP5] (IRQs 20 21 22 23) *0, dis=
abled.
[    0.487654] ACPI: PCI Interrupt Link [LRP6] (IRQs 20 21 22 23) *0, dis=
abled.
[    0.487729] vgaarb: device added: PCI:0000:02:00.0,decodes=3Dio+mem,ow=
ns=3Dio+mem,locks=3Dnone
[    0.487729] vgaarb: loaded
[    0.487729] vgaarb: bridge control possible 0000:02:00.0
[    0.487729] SCSI subsystem initialized
[    0.487729] libata version 3.00 loaded.
[    0.487729] usbcore: registered new interface driver usbfs
[    0.487729] usbcore: registered new interface driver hub
[    0.487729] usbcore: registered new device driver usb
[    0.490024] Advanced Linux Sound Architecture Driver Version 1.0.24.
[    0.490024] PCI: Using ACPI for IRQ routing
[    0.490994] PCI: pci_cache_line_size set to 64 bytes
[    0.491137] reserve RAM buffer: 000000000009fc00 - 000000000009ffff=20
[    0.491144] reserve RAM buffer: 000000005ff90000 - 000000005fffffff=20
[    0.491191] HPET: 4 timers in total, 0 timers will be used for per-cpu=
 timer
[    0.491191] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31, 31
[    0.491191] hpet0: 4 comparators, 64-bit 25.000000 MHz counter
[    0.506692] Switching to clocksource hpet
[    0.506851] pnp: PnP ACPI init
[    0.506875] ACPI: bus type pnp registered
[    0.507189] pnp 00:00: [bus 00-ff]
[    0.507196] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.507202] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.507207] pnp 00:00: [io  0x0d00-0xffff window]
[    0.507213] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.507219] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[    0.507224] pnp 00:00: [mem 0x80000000-0xfbffffff window]
[    0.507230] pnp 00:00: [mem 0xfe000000-0xfebfffff window]
[    0.507495] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)=

[    0.507591] pnp 00:01: [dma 4]
[    0.507597] pnp 00:01: [io  0x0000-0x000f]
[    0.507602] pnp 00:01: [io  0x0081-0x0083]
[    0.507606] pnp 00:01: [io  0x0087]
[    0.507611] pnp 00:01: [io  0x0089-0x008b]
[    0.507615] pnp 00:01: [io  0x008f]
[    0.507620] pnp 00:01: [io  0x00c0-0x00df]
[    0.507773] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)=

[    0.507809] pnp 00:02: [io  0x0061]
[    0.507953] pnp 00:02: Plug and Play ACPI device, IDs PNP0800 (active)=

[    0.507983] pnp 00:03: [io  0x00f0-0x00ff]
[    0.508003] pnp 00:03: [irq 13]
[    0.508149] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)=

[    0.509078] pnp 00:04: [mem 0x000d0000-0x000d3fff window]
[    0.509085] pnp 00:04: [mem 0x000d4000-0x000d7fff window]
[    0.509090] pnp 00:04: [mem 0x000de000-0x000dffff window]
[    0.509096] pnp 00:04: [io  0x0010-0x001f]
[    0.509105] pnp 00:04: [io  0x0022-0x003f]
[    0.509109] pnp 00:04: [io  0x0044-0x004d]
[    0.509114] pnp 00:04: [io  0x0050-0x005f]
[    0.509119] pnp 00:04: [io  0x0062-0x0063]
[    0.509123] pnp 00:04: [io  0x0065-0x006f]
[    0.509128] pnp 00:04: [io  0x0072-0x007f]
[    0.509133] pnp 00:04: [io  0x0080]
[    0.509137] pnp 00:04: [io  0x0084-0x0086]
[    0.509142] pnp 00:04: [io  0x0088]
[    0.509146] pnp 00:04: [io  0x008c-0x008e]
[    0.509151] pnp 00:04: [io  0x0090-0x009f]
[    0.509155] pnp 00:04: [io  0x00a2-0x00bf]
[    0.509160] pnp 00:04: [io  0x00e0-0x00ef]
[    0.509165] pnp 00:04: [io  0x04d0-0x04d1]
[    0.509170] pnp 00:04: [io  0x0800-0x080f]
[    0.509175] pnp 00:04: [io  0x4000-0x407f]
[    0.509179] pnp 00:04: [io  0x4080-0x40ff]
[    0.509184] pnp 00:04: [io  0x4400-0x447f]
[    0.509189] pnp 00:04: [io  0x4480-0x44ff]
[    0.509193] pnp 00:04: [io  0x4800-0x487f]
[    0.509198] pnp 00:04: [io  0x4880-0x48ff]
[    0.509204] pnp 00:04: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.509209] pnp 00:04: [mem 0xfefe2000-0xfefe3fff]
[    0.509214] pnp 00:04: [mem 0xfefe1000-0xfefe1fff]
[    0.509219] pnp 00:04: [mem 0xfee01000-0xfeefffff]
[    0.509491] system 00:04: [io  0x04d0-0x04d1] has been reserved
[    0.509499] system 00:04: [io  0x0800-0x080f] has been reserved
[    0.509506] system 00:04: [io  0x4000-0x407f] has been reserved
[    0.509512] system 00:04: [io  0x4080-0x40ff] has been reserved
[    0.509518] system 00:04: [io  0x4400-0x447f] has been reserved
[    0.509525] system 00:04: [io  0x4480-0x44ff] has been reserved
[    0.509531] system 00:04: [io  0x4800-0x487f] has been reserved
[    0.509537] system 00:04: [io  0x4880-0x48ff] has been reserved
[    0.509545] system 00:04: [mem 0x000d0000-0x000d3fff window] has been =
reserved
[    0.509552] system 00:04: [mem 0x000d4000-0x000d7fff window] has been =
reserved
[    0.509559] system 00:04: [mem 0x000de000-0x000dffff window] has been =
reserved
[    0.509566] system 00:04: [mem 0xfefe2000-0xfefe3fff] has been reserve=
d
[    0.509572] system 00:04: [mem 0xfefe1000-0xfefe1fff] has been reserve=
d
[    0.509579] system 00:04: [mem 0xfee01000-0xfeefffff] has been reserve=
d
[    0.509588] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.509690] Switched to NOHz mode on CPU #0
[    0.509788] Switched to NOHz mode on CPU #2
[    0.509807] Switched to NOHz mode on CPU #1
[    0.509852] Switched to NOHz mode on CPU #3
[    0.509968] pnp 00:05: [mem 0xfed00000-0xfed00fff]
[    0.509976] pnp 00:05: [irq 2 disabled]
[    0.509993] pnp 00:05: [irq 8]
[    0.510209] pnp 00:05: Plug and Play ACPI device, IDs PNP0103 (active)=

[    0.510282] pnp 00:06: [io  0x0070-0x0071]
[    0.510450] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)=

[    0.511088] pnp 00:07: [io  0x0000-0xffffffffffffffff disabled]
[    0.511095] pnp 00:07: [io  0x0c00-0x0c0f]
[    0.511100] pnp 00:07: [io  0x0290-0x029f]
[    0.511105] pnp 00:07: [io  0x0a20-0x0a2f]
[    0.511109] pnp 00:07: [io  0x0a30-0x0a3f]
[    0.511348] system 00:07: [io  0x0c00-0x0c0f] has been reserved
[    0.511356] system 00:07: [io  0x0290-0x029f] has been reserved
[    0.511362] system 00:07: [io  0x0a20-0x0a2f] has been reserved
[    0.511368] system 00:07: [io  0x0a30-0x0a3f] has been reserved
[    0.511376] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.511619] pnp 00:08: [io  0x0060]
[    0.511624] pnp 00:08: [io  0x0064]
[    0.511630] pnp 00:08: [mem 0xfec00000-0xfec00fff]
[    0.511635] pnp 00:08: [mem 0xfee00000-0xfee00fff]
[    0.511862] system 00:08: [mem 0xfec00000-0xfec00fff] could not be res=
erved
[    0.511871] system 00:08: [mem 0xfee00000-0xfee00fff] has been reserve=
d
[    0.511879] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.512030] pnp 00:09: [mem 0xfc000000-0xfdffffff]
[    0.512244] system 00:09: [mem 0xfc000000-0xfdffffff] has been reserve=
d
[    0.512253] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.512754] pnp 00:0a: [mem 0x00000000-0x0009ffff]
[    0.512761] pnp 00:0a: [mem 0x000c0000-0x000cffff]
[    0.512766] pnp 00:0a: [mem 0x000e0000-0x000fffff]
[    0.512777] pnp 00:0a: [mem 0x00100000-0x7fffffff]
[    0.512782] pnp 00:0a: [mem 0xfec00000-0xffffffff]
[    0.513049] system 00:0a: [mem 0x00000000-0x0009ffff] could not be res=
erved
[    0.513058] system 00:0a: [mem 0x000c0000-0x000cffff] could not be res=
erved
[    0.513065] system 00:0a: [mem 0x000e0000-0x000fffff] could not be res=
erved
[    0.513071] system 00:0a: [mem 0x00100000-0x7fffffff] could not be res=
erved
[    0.513078] system 00:0a: [mem 0xfec00000-0xffffffff] could not be res=
erved
[    0.513086] system 00:0a: Plug and Play ACPI device, IDs PNP0c01 (acti=
ve)
[    0.514925] pnp: PnP ACPI: found 11 devices
[    0.514930] ACPI: ACPI bus type pnp unregistered
[    0.531172] PCI: max bus depth: 1 pci_try_num: 2
[    0.531234] pci 0000:00:09.0: PCI bridge to [bus 01-01]
[    0.531240] pci 0000:00:09.0:   bridge window [io  disabled]
[    0.531249] pci 0000:00:09.0:   bridge window [mem 0xf6000000-0xf9ffff=
ff]
[    0.531256] pci 0000:00:09.0:   bridge window [mem pref disabled]
[    0.531265] pci 0000:00:10.0: PCI bridge to [bus 02-02]
[    0.531272] pci 0000:00:10.0:   bridge window [io  0xd000-0xdfff]
[    0.531279] pci 0000:00:10.0:   bridge window [mem 0xfa000000-0xfbefff=
ff]
[    0.531287] pci 0000:00:10.0:   bridge window [mem 0xe0000000-0xf3ffff=
ff 64bit pref]
[    0.531296] pci 0000:00:15.0: PCI bridge to [bus 03-03]
[    0.531304] pci 0000:00:15.0:   bridge window [io  0xe000-0xefff]
[    0.531319] pci 0000:00:15.0:   bridge window [mem 0xfbf00000-0xfbffff=
ff]
[    0.531331] pci 0000:00:15.0:   bridge window [mem 0xf4f00000-0xf4ffff=
ff 64bit pref]
[    0.531360] pci 0000:00:09.0: setting latency timer to 64
[    0.531372] pci 0000:00:10.0: setting latency timer to 64
[    0.531825] ACPI: PCI Interrupt Link [LRP3] enabled at IRQ 23
[    0.531856] pci 0000:00:15.0: PCI INT A -> Link[LRP3] -> GSI 23 (level=
, low) -> IRQ 23
[    0.531870] pci 0000:00:15.0: setting latency timer to 64
[    0.531881] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.531887] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.531893] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.531899] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.531905] pci_bus 0000:00: resource 8 [mem 0x80000000-0xfbffffff]
[    0.531911] pci_bus 0000:00: resource 9 [mem 0xfe000000-0xfebfffff]
[    0.531917] pci_bus 0000:01: resource 1 [mem 0xf6000000-0xf9ffffff]
[    0.531923] pci_bus 0000:01: resource 4 [io  0x0000-0x0cf7]
[    0.531928] pci_bus 0000:01: resource 5 [io  0x0d00-0xffff]
[    0.531934] pci_bus 0000:01: resource 6 [mem 0x000a0000-0x000bffff]
[    0.531940] pci_bus 0000:01: resource 7 [mem 0x000d0000-0x000dffff]
[    0.531946] pci_bus 0000:01: resource 8 [mem 0x80000000-0xfbffffff]
[    0.531952] pci_bus 0000:01: resource 9 [mem 0xfe000000-0xfebfffff]
[    0.531958] pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
[    0.531963] pci_bus 0000:02: resource 1 [mem 0xfa000000-0xfbefffff]
[    0.531970] pci_bus 0000:02: resource 2 [mem 0xe0000000-0xf3ffffff 64b=
it pref]
[    0.531976] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
[    0.531981] pci_bus 0000:03: resource 1 [mem 0xfbf00000-0xfbffffff]
[    0.531988] pci_bus 0000:03: resource 2 [mem 0xf4f00000-0xf4ffffff 64b=
it pref]
[    0.532073] NET: Registered protocol family 2
[    0.532185] IP route cache hash table entries: 65536 (order: 7, 524288=
 bytes)
[    0.533221] TCP established hash table entries: 262144 (order: 10, 419=
4304 bytes)
[    0.536452] TCP bind hash table entries: 65536 (order: 8, 1048576 byte=
s)
[    0.537283] TCP: Hash tables configured (established 262144 bind 65536=
)
[    0.537290] TCP reno registered
[    0.537303] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.537335] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.537585] NET: Registered protocol family 1
[    0.706822] pci 0000:02:00.0: Boot video device
[    0.706834] PCI: CLS 64 bytes, default 64
[    0.706946] Trying to unpack rootfs image as initramfs...
[    0.883419] Freeing initrd memory: 4096k freed
[    0.891701] microcode: CPU0 sig=3D0x106c2, pf=3D0x8, revision=3D0x219
[    0.891726] microcode: CPU1 sig=3D0x106c2, pf=3D0x8, revision=3D0x219
[    0.891747] microcode: CPU2 sig=3D0x106c2, pf=3D0x8, revision=3D0x219
[    0.891773] microcode: CPU3 sig=3D0x106c2, pf=3D0x8, revision=3D0x219
[    0.891922] microcode: Microcode Update Driver: v2.00 <tigran@aivazian=
=2Efsnet.co.uk>, Peter Oruba
[    0.899819] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.927206] Btrfs loaded
[    0.927225] msgmni has been set to 3004
[    0.928592] Block layer SCSI generic (bsg) driver version 0.4 loaded (=
major 253)
[    0.928684] io scheduler noop registered
[    0.928690] io scheduler deadline registered
[    0.928903] io scheduler cfq registered (default)
[    0.929835] intel_idle: MWAIT substates: 0x10
[    0.929863] intel_idle: v0.4 model 0x1C
[    0.929867] intel_idle: lapic_timer_reliable_states 0x2
[    0.930790] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0=
C0C:00/input/input0
[    0.930802] ACPI: Power Button [PWRB]
[    0.931018] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/in=
put/input1
[    0.931028] ACPI: Power Button [PWRF]
[    0.931469] ACPI: acpi_idle yielding to intel_idle
[    0.944692] brd: module loaded
[    0.947677] loop: module loaded
[    0.948368] ahci 0000:00:0b.0: version 3.0
[    0.948835] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 22
[    0.948869] ahci 0000:00:0b.0: PCI INT A -> Link[LSA0] -> GSI 22 (leve=
l, low) -> IRQ 22
[    0.948954] ahci 0000:00:0b.0: irq 40 for MSI/MSI-X
[    0.948966] ahci 0000:00:0b.0: controller can't do PMP, turning off CA=
P_PMP
[    0.949066] ahci 0000:00:0b.0: AHCI 0001.0200 32 slots 6 ports 3 Gbps =
0xf impl IDE mode
[    0.949075] ahci 0000:00:0b.0: flags: 64bit ncq sntf led pio slum part=
 sxs=20
[    0.949083] ahci 0000:00:0b.0: setting latency timer to 64
[    0.952574] scsi0 : ahci
[    0.953073] scsi1 : ahci
[    0.953497] scsi2 : ahci
[    0.953898] scsi3 : ahci
[    0.954290] scsi4 : ahci
[    0.954669] scsi5 : ahci
[    0.955209] ata1: SATA max UDMA/133 abar m8192@0xf5f76000 port 0xf5f76=
100 irq 40
[    0.955217] ata2: SATA max UDMA/133 abar m8192@0xf5f76000 port 0xf5f76=
180 irq 40
[    0.955223] ata3: SATA max UDMA/133 abar m8192@0xf5f76000 port 0xf5f76=
200 irq 40
[    0.955229] ata4: SATA max UDMA/133 abar m8192@0xf5f76000 port 0xf5f76=
280 irq 40
[    0.955234] ata5: DUMMY
[    0.955237] ata6: DUMMY
[    0.955902] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.956379] ACPI: PCI Interrupt Link [LN3A] enabled at IRQ 19
[    0.956411] r8169 0000:03:00.0: PCI INT A -> Link[LN3A] -> GSI 19 (lev=
el, low) -> IRQ 19
[    0.956472] r8169 0000:03:00.0: setting latency timer to 64
[    0.956535] r8169 0000:03:00.0: irq 41 for MSI/MSI-X
[    0.957339] r8169 0000:03:00.0: eth0: RTL8168d/8111d at 0xffffc9000000=
c000, 90:e6:ba:cc:ba:19, XID 083000c0 IRQ 41
[    0.957541] console [netcon0] enabled
[    0.957545] netconsole: network logging started
[    0.957572] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.957577] ohci_hcd: block sizes: ed 80 td 96
[    0.958035] ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 21
[    0.958066] ohci_hcd 0000:00:04.0: PCI INT A -> Link[LUB0] -> GSI 21 (=
level, low) -> IRQ 21
[    0.958098] ohci_hcd 0000:00:04.0: setting latency timer to 64
[    0.958105] ohci_hcd 0000:00:04.0: OHCI Host Controller
[    0.958152] drivers/usb/core/inode.c: creating file 'devices'
[    0.958176] drivers/usb/core/inode.c: creating file '001'
[    0.958186] ohci_hcd 0000:00:04.0: new USB bus registered, assigned bu=
s number 1
[    0.958207] ohci_hcd 0000:00:04.0: created debug files
[    0.958212] ohci_hcd 0000:00:04.0: supports USB remote wakeup
[    0.958249] ohci_hcd 0000:00:04.0: irq 21, io mem 0xf5f7f000
[    1.012056] ohci_hcd 0000:00:04.0: OHCI controller state
[    1.012066] ohci_hcd 0000:00:04.0: OHCI 1.0, NO legacy support registe=
rs
[    1.012074] ohci_hcd 0000:00:04.0: control 0x683 RWE RWC HCFS=3Doperat=
ional CBSR=3D3
[    1.012080] ohci_hcd 0000:00:04.0: cmdstatus 0x00000 SOC=3D0
[    1.012087] ohci_hcd 0000:00:04.0: intrstatus 0x00000044 RHSC SF
[    1.012094] ohci_hcd 0000:00:04.0: intrenable 0x8000001a MIE UE RD WDH=

[    1.012102] ohci_hcd 0000:00:04.0: hcca frame #0003
[    1.012109] ohci_hcd 0000:00:04.0: roothub.a 01001206 POTPGT=3D1 NOCP =
NPS NDP=3D6(6)
[    1.012116] ohci_hcd 0000:00:04.0: roothub.b 00000000 PPCM=3D0000 DR=3D=
0000
[    1.012123] ohci_hcd 0000:00:04.0: roothub.status 00008000 DRWE
[    1.012130] ohci_hcd 0000:00:04.0: roothub.portstatus [0] 0x00000100 P=
PS
[    1.012138] ohci_hcd 0000:00:04.0: roothub.portstatus [1] 0x00000100 P=
PS
[    1.012145] ohci_hcd 0000:00:04.0: roothub.portstatus [2] 0x00000100 P=
PS
[    1.012153] ohci_hcd 0000:00:04.0: roothub.portstatus [3] 0x00010101 C=
SC PPS CCS
[    1.012161] ohci_hcd 0000:00:04.0: roothub.portstatus [4] 0x00010301 C=
SC LSDA PPS CCS
[    1.012169] ohci_hcd 0000:00:04.0: roothub.portstatus [5] 0x00010101 C=
SC PPS CCS
[    1.012200] usb usb1: default language 0x0409
[    1.012215] usb usb1: udev 1, busnum 1, minor =3D 0
[    1.012220] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.012226] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    1.012232] usb usb1: Product: OHCI Host Controller
[    1.012237] usb usb1: Manufacturer: Linux 3.0.3-vdr3-00280-gc9c8f9f oh=
ci_hcd
[    1.012242] usb usb1: SerialNumber: 0000:00:04.0
[    1.012526] usb usb1: usb_probe_device
[    1.012534] usb usb1: configuration #1 chosen from 1 choice
[    1.012553] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    1.012731] hub 1-0:1.0: usb_probe_interface
[    1.012737] hub 1-0:1.0: usb_probe_interface - got id
[    1.012742] hub 1-0:1.0: USB hub found
[    1.012754] hub 1-0:1.0: 6 ports detected
[    1.012759] hub 1-0:1.0: standalone hub
[    1.012763] hub 1-0:1.0: no power switching (usb 1.0)
[    1.012767] hub 1-0:1.0: no over-current protection
[    1.012772] hub 1-0:1.0: power on to power good time: 2ms
[    1.012781] hub 1-0:1.0: local power source is good
[    1.012787] hub 1-0:1.0: trying to enable port power on non-switchable=
 hub
[    1.012826] drivers/usb/core/inode.c: creating file '001'
[    1.013396] ACPI: PCI Interrupt Link [UB11] enabled at IRQ 20
[    1.013429] ohci_hcd 0000:00:06.0: PCI INT A -> Link[UB11] -> GSI 20 (=
level, low) -> IRQ 20
[    1.013466] ohci_hcd 0000:00:06.0: setting latency timer to 64
[    1.013473] ohci_hcd 0000:00:06.0: OHCI Host Controller
[    1.013488] drivers/usb/core/inode.c: creating file '002'
[    1.013501] ohci_hcd 0000:00:06.0: new USB bus registered, assigned bu=
s number 2
[    1.013524] ohci_hcd 0000:00:06.0: created debug files
[    1.013529] ohci_hcd 0000:00:06.0: supports USB remote wakeup
[    1.013567] ohci_hcd 0000:00:06.0: irq 20, io mem 0xf5f7d000
[    1.068725] ohci_hcd 0000:00:06.0: OHCI controller state
[    1.068733] ohci_hcd 0000:00:06.0: OHCI 1.0, NO legacy support registe=
rs
[    1.068741] ohci_hcd 0000:00:06.0: control 0x683 RWE RWC HCFS=3Doperat=
ional CBSR=3D3
[    1.068748] ohci_hcd 0000:00:06.0: cmdstatus 0x00000 SOC=3D0
[    1.068754] ohci_hcd 0000:00:06.0: intrstatus 0x00000004 SF
[    1.068761] ohci_hcd 0000:00:06.0: intrenable 0x8000005a MIE RHSC UE R=
D WDH
[    1.068769] ohci_hcd 0000:00:06.0: hcca frame #0003
[    1.068777] ohci_hcd 0000:00:06.0: roothub.a 01001206 POTPGT=3D1 NOCP =
NPS NDP=3D6(6)
[    1.068784] ohci_hcd 0000:00:06.0: roothub.b 00000000 PPCM=3D0000 DR=3D=
0000
[    1.068790] ohci_hcd 0000:00:06.0: roothub.status 00008000 DRWE
[    1.068798] ohci_hcd 0000:00:06.0: roothub.portstatus [0] 0x00000100 P=
PS
[    1.068805] ohci_hcd 0000:00:06.0: roothub.portstatus [1] 0x00000100 P=
PS
[    1.068813] ohci_hcd 0000:00:06.0: roothub.portstatus [2] 0x00000100 P=
PS
[    1.068821] ohci_hcd 0000:00:06.0: roothub.portstatus [3] 0x00000100 P=
PS
[    1.068828] ohci_hcd 0000:00:06.0: roothub.portstatus [4] 0x00000100 P=
PS
[    1.068836] ohci_hcd 0000:00:06.0: roothub.portstatus [5] 0x00000100 P=
PS
[    1.068865] usb usb2: default language 0x0409
[    1.068880] usb usb2: udev 1, busnum 2, minor =3D 128
[    1.068886] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.068892] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    1.068897] usb usb2: Product: OHCI Host Controller
[    1.068902] usb usb2: Manufacturer: Linux 3.0.3-vdr3-00280-gc9c8f9f oh=
ci_hcd
[    1.068907] usb usb2: SerialNumber: 0000:00:06.0
[    1.069174] usb usb2: usb_probe_device
[    1.069182] usb usb2: configuration #1 chosen from 1 choice
[    1.069202] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    1.069369] hub 2-0:1.0: usb_probe_interface
[    1.069375] hub 2-0:1.0: usb_probe_interface - got id
[    1.069380] hub 2-0:1.0: USB hub found
[    1.069392] hub 2-0:1.0: 6 ports detected
[    1.069396] hub 2-0:1.0: standalone hub
[    1.069400] hub 2-0:1.0: no power switching (usb 1.0)
[    1.069405] hub 2-0:1.0: no over-current protection
[    1.069409] hub 2-0:1.0: power on to power good time: 2ms
[    1.069419] hub 2-0:1.0: local power source is good
[    1.069424] hub 2-0:1.0: trying to enable port power on non-switchable=
 hub
[    1.069467] drivers/usb/core/inode.c: creating file '001'
[    1.069696] uhci_hcd: USB Universal Host Controller Interface driver
[    1.070103] usbcore: registered new interface driver libusual
[    1.070670] i8042: PNP: No PS/2 controller found. Probing ports direct=
ly.
[    1.071283] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.071348] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.071731] mousedev: PS/2 mouse device common for all mice
[    1.072227] rtc_cmos 00:06: RTC can wake from S4
[    1.072581] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    1.072646] rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet ir=
qs
[    1.073417] coretemp coretemp.0: Unable to read TjMax from CPU.
[    1.073457] coretemp coretemp.0: Unable to read TjMax from CPU.
[    1.074670] cpuidle: using governor ladder
[    1.076775] cpuidle: using governor menu
[    1.076781] EFI Variables Facility v0.08 2004-May-17
[    1.079107] usbcore: registered new interface driver usbhid
[    1.079113] usbhid: USB HID core driver
[    1.079434] HDA Intel 0000:00:08.0: power state changed by ACPI to D0
[    1.079445] HDA Intel 0000:00:08.0: power state changed by ACPI to D0
[    1.079870] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 23
[    1.079882] HDA Intel 0000:00:08.0: PCI INT A -> Link[LAZA] -> GSI 23 =
(level, low) -> IRQ 23
[    1.079889] hda_intel: Disabling MSI
[    1.079965] HDA Intel 0000:00:08.0: setting latency timer to 64
[    1.110070] ohci_hcd 0000:00:04.0: GetStatus roothub.portstatus [3] =3D=
 0x00010101 CSC PPS CCS
[    1.110080] hub 1-0:1.0: port 4: status 0101 change 0001
[    1.110091] ohci_hcd 0000:00:04.0: GetStatus roothub.portstatus [4] =3D=
 0x00010301 CSC LSDA PPS CCS
[    1.110098] hub 1-0:1.0: port 5: status 0301 change 0001
[    1.110108] ohci_hcd 0000:00:04.0: GetStatus roothub.portstatus [5] =3D=
 0x00010101 CSC PPS CCS
[    1.110115] hub 1-0:1.0: port 6: status 0101 change 0001
[    1.166765] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[    1.210057] hub 1-0:1.0: state 7 ports 6 chg 0070 evt 0000
[    1.210091] hub 1-0:1.0: port 4, status 0101, change 0000, 12 Mb/s
[    1.273387] ata3: SATA link down (SStatus 0 SControl 300)
[    1.273432] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.273462] ata2: SATA link down (SStatus 0 SControl 300)
[    1.273493] ata4: SATA link down (SStatus 0 SControl 300)
[    1.276720] ohci_hcd 0000:00:04.0: GetStatus roothub.portstatus [3] =3D=
 0x00100103 PRSC PPS PES CCS
[    1.279820] ata1.00: ATA-7: SAMSUNG HD103SI, 1AG01118, max UDMA7
[    1.279827] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31=
/32)
[    1.286260] ata1.00: configured for UDMA/133
[    1.286600] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD103SI  =
1AG0 PQ: 0 ANSI: 5
[    1.287346] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.0=
0 TB/931 GiB)
[    1.287545] sd 0:0:0:0: [sda] Write Protect is off
[    1.287554] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.287641] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    1.287729] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.322060]  sda: sda1 sda2 < sda5 sda6 sda7 >
[    1.323514] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.330056] usb 1-4: new full speed USB device number 2 using ohci_hcd=

[    1.406729] ohci_hcd 0000:00:04.0: GetStatus roothub.portstatus [3] =3D=
 0x00100103 PRSC PPS PES CCS
[    1.495089] usb 1-4: udev 2, busnum 1, minor =3D 1
[    1.495095] usb 1-4: New USB device found, idVendor=3D0a12, idProduct=3D=
0001
[    1.495101] usb 1-4: New USB device strings: Mfr=3D0, Product=3D0, Ser=
ialNumber=3D0
[    1.495397] usb 1-4: usb_probe_device
[    1.495406] usb 1-4: configuration #1 chosen from 1 choice
[    1.498089] usb 1-4: adding 1-4:1.0 (config #1, interface 0)
[    1.498334] usb 1-4: adding 1-4:1.1 (config #1, interface 1)
[    1.498543] drivers/usb/core/inode.c: creating file '002'
[    1.498593] hub 1-0:1.0: port 5, status 0301, change 0000, 1.5 Mb/s
[    1.563391] ohci_hcd 0000:00:04.0: GetStatus roothub.portstatus [4] =3D=
 0x00100303 PRSC LSDA PPS PES CCS
[    1.616716] usb 1-5: new low speed USB device number 3 using ohci_hcd
[    1.683381] ohci_hcd 0000:00:04.0: GetStatus roothub.portstatus [4] =3D=
 0x00100303 PRSC LSDA PPS PES CCS
[    1.765081] usb 1-5: skipped 1 descriptor after interface
[    1.765087] usb 1-5: skipped 1 descriptor after interface
[    1.768078] usb 1-5: default language 0x0409
[    1.777080] usb 1-5: udev 3, busnum 1, minor =3D 2
[    1.777086] usb 1-5: New USB device found, idVendor=3D0a81, idProduct=3D=
0205
[    1.777092] usb 1-5: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    1.777098] usb 1-5: Product: PS2 to USB Converter
[    1.777102] usb 1-5: Manufacturer: CHESEN
[    1.777343] usb 1-5: usb_probe_device
[    1.777350] usb 1-5: configuration #1 chosen from 1 choice
[    1.785081] usb 1-5: adding 1-5:1.0 (config #1, interface 0)
[    1.785299] usbhid 1-5:1.0: usb_probe_interface
[    1.785305] usbhid 1-5:1.0: usb_probe_interface - got id
[    1.794607] input: CHESEN PS2 to USB Converter as /devices/pci0000:00/=
0000:00:04.0/usb1/1-5/1-5:1.0/input/input2
[    1.794993] generic-usb 0003:0A81:0205.0001: input,hidraw0: USB HID v1=
=2E10 Keyboard [CHESEN PS2 to USB Converter] on usb-0000:00:04.0-5/input0=

[    1.795028] usb 1-5: adding 1-5:1.1 (config #1, interface 1)
[    1.795230] usbhid 1-5:1.1: usb_probe_interface
[    1.795237] usbhid 1-5:1.1: usb_probe_interface - got id
[    1.806661] input: CHESEN PS2 to USB Converter as /devices/pci0000:00/=
0000:00:04.0/usb1/1-5/1-5:1.1/input/input3
[    1.807274] generic-usb 0003:0A81:0205.0002: input,hidraw1: USB HID v1=
=2E10 Mouse [CHESEN PS2 to USB Converter] on usb-0000:00:04.0-5/input1
[    1.807310] drivers/usb/core/inode.c: creating file '003'
[    1.807360] hub 1-0:1.0: port 6, status 0101, change 0000, 12 Mb/s
[    1.873389] ohci_hcd 0000:00:04.0: GetStatus roothub.portstatus [5] =3D=
 0x00100103 PRSC PPS PES CCS
[    1.890056] Refined TSC clocksource calibration: 1599.992 MHz.
[    1.890067] Switching to clocksource tsc
[    1.926707] usb 1-6: new full speed USB device number 4 using ohci_hcd=

[    1.961400] ALSA device list:
[    1.961407]   #0: HDA NVidia at 0xf5f78000 irq 23
[    1.961923] TCP cubic registered
[    1.961928] Initializing XFRM netlink socket
[    1.962858] NET: Registered protocol family 10
[    1.964105] IPv6 over IPv4 tunneling driver
[    1.965296] NET: Registered protocol family 17
[    1.965316] Registering the dns_resolver key type
[    1.965829] PM: Hibernation image not present or could not be loaded.
[    1.972726]   Magic number: 7:499:835
[    1.972965] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.972970] EDD information not available.
[    1.973292] Freeing unused kernel memory: 452k freed
[    1.993439] ohci_hcd 0000:00:04.0: GetStatus roothub.portstatus [5] =3D=
 0x00100103 PRSC PPS PES CCS
[    2.071089] usb 1-6: udev 4, busnum 1, minor =3D 3
[    2.071097] usb 1-6: New USB device found, idVendor=3D0cf3, idProduct=3D=
3000
[    2.071104] usb 1-6: New USB device strings: Mfr=3D0, Product=3D0, Ser=
ialNumber=3D0
[    2.071434] usb 1-6: usb_probe_device
[    2.071443] usb 1-6: configuration #1 chosen from 1 choice
[    2.074107] usb 1-6: adding 1-6:1.0 (config #1, interface 0)
[    2.074416] drivers/usb/core/inode.c: creating file '004'
[    2.074489] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0040
[    2.096718] ohci_hcd 0000:00:06.0: auto-stop root hub
[    2.141839] udevd[898]: starting version 172
[    2.274148] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver=

[    2.274157] Warning! ehci_hcd should always be loaded before uhci_hcd =
and ohci_hcd, not after
[    2.274167] ehci_hcd: block sizes: qh 112 qtd 96 itd 192 sitd 96
[    2.274951] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[    2.274971] ehci_hcd 0000:00:04.1: PCI INT B -> Link[LUB2] -> GSI 22 (=
level, low) -> IRQ 22
[    2.275034] ehci_hcd 0000:00:04.1: setting latency timer to 64
[    2.275043] ehci_hcd 0000:00:04.1: EHCI Host Controller
[    2.275074] drivers/usb/core/inode.c: creating file '003'
[    2.275092] ehci_hcd 0000:00:04.1: new USB bus registered, assigned bu=
s number 3
[    2.275113] ehci_hcd 0000:00:04.1: reset hcs_params 0x101c86 dbg=3D1 c=
c=3D1 pcc=3D12 !ppc ports=3D6
[    2.275126] ehci_hcd 0000:00:04.1: reset portroute 0 0 0 0 0 0=20
[    2.275132] ehci_hcd 0000:00:04.1: reset hcc_params a086 caching frame=
 256/512/1024 park
[    2.275162] ehci_hcd 0000:00:04.1: park 0
[    2.275173] ehci_hcd 0000:00:04.1: debug port 1
[    2.275184] ehci_hcd 0000:00:04.1: reset command 0080b02  park=3D3 ith=
resh=3D8 period=3D1024 Reset HALT
[    2.275197] ehci_hcd 0000:00:04.1: cache line size of 64 is not suppor=
ted
[    2.275203] ehci_hcd 0000:00:04.1: supports USB remote wakeup
[    2.275251] ehci_hcd 0000:00:04.1: irq 22, io mem 0xf5f7ec00
[    2.275262] ehci_hcd 0000:00:04.1: reset command 0080b02  park=3D3 ith=
resh=3D8 period=3D1024 Reset HALT
[    2.275273] ehci_hcd 0000:00:04.1: init command 0010005 (park)=3D0 ith=
resh=3D1 period=3D512 RUN
[    2.275345] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0070
[    2.275365] ohci_hcd 0000:00:04.0: GetStatus roothub.portstatus [3] =3D=
 0x00030100 PESC CSC PPS
[    2.275388] hub 1-0:1.0: port 4, status 0100, change 0003, 12 Mb/s
[    2.275399] usb 1-4: USB disconnect, device number 2
[    2.275406] usb 1-4: unregistering device
[    2.275414] usb 1-4: unregistering interface 1-4:1.0
[    2.279369] usb 1-4: unregistering interface 1-4:1.1
[    2.279725] usb 1-4: usb_disable_device nuking all URBs
[    2.283544] ehci_hcd 0000:00:04.1: USB 2.0 started, EHCI 1.00
[    2.283737] usb usb3: default language 0x0409
[    2.283765] usb usb3: udev 1, busnum 3, minor =3D 256
[    2.283773] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    2.283781] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    2.283789] usb usb3: Product: EHCI Host Controller
[    2.283797] usb usb3: Manufacturer: Linux 3.0.3-vdr3-00280-gc9c8f9f eh=
ci_hcd
[    2.283804] usb usb3: SerialNumber: 0000:00:04.1
[    2.289535] usb usb3: usb_probe_device
[    2.289550] usb usb3: configuration #1 chosen from 1 choice
[    2.289586] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    2.289833] hub 3-0:1.0: usb_probe_interface
[    2.289842] hub 3-0:1.0: usb_probe_interface - got id
[    2.289851] hub 3-0:1.0: USB hub found
[    2.289872] hub 3-0:1.0: 6 ports detected
[    2.289880] hub 3-0:1.0: standalone hub
[    2.289886] hub 3-0:1.0: no power switching (usb 1.0)
[    2.289892] hub 3-0:1.0: individual port over-current protection
[    2.289899] hub 3-0:1.0: power on to power good time: 20ms
[    2.289917] hub 3-0:1.0: local power source is good
[    2.289925] hub 3-0:1.0: trying to enable port power on non-switchable=
 hub
[    2.290035] drivers/usb/core/inode.c: creating file '001'
[    2.290116] ehci_hcd 0000:00:04.1: HS companion for 0000:00:04.0
[    2.290880] ACPI: PCI Interrupt Link [UB12] enabled at IRQ 21
[    2.290899] ehci_hcd 0000:00:06.1: PCI INT B -> Link[UB12] -> GSI 21 (=
level, low) -> IRQ 21
[    2.290954] ehci_hcd 0000:00:06.1: setting latency timer to 64
[    2.290965] ehci_hcd 0000:00:06.1: EHCI Host Controller
[    2.290994] drivers/usb/core/inode.c: creating file '004'
[    2.291017] ehci_hcd 0000:00:06.1: new USB bus registered, assigned bu=
s number 4
[    2.291045] ehci_hcd 0000:00:06.1: reset hcs_params 0x101c86 dbg=3D1 c=
c=3D1 pcc=3D12 !ppc ports=3D6
[    2.291058] ehci_hcd 0000:00:06.1: reset portroute 0 0 0 0 0 0=20
[    2.291065] ehci_hcd 0000:00:06.1: reset hcc_params a086 caching frame=
 256/512/1024 park
[    2.291105] ehci_hcd 0000:00:06.1: park 0
[    2.291121] ehci_hcd 0000:00:06.1: debug port 1
[    2.291136] ehci_hcd 0000:00:06.1: reset command 0080b02  park=3D3 ith=
resh=3D8 period=3D1024 Reset HALT
[    2.291153] ehci_hcd 0000:00:06.1: cache line size of 64 is not suppor=
ted
[    2.291162] ehci_hcd 0000:00:06.1: supports USB remote wakeup
[    2.291191] ehci_hcd 0000:00:06.1: irq 21, io mem 0xf5f7e800
[    2.291205] ehci_hcd 0000:00:06.1: reset command 0080b02  park=3D3 ith=
resh=3D8 period=3D1024 Reset HALT
[    2.291220] ehci_hcd 0000:00:06.1: init command 0010005 (park)=3D0 ith=
resh=3D1 period=3D512 RUN
[    2.298080] ohci_hcd 0000:00:04.0: urb ffff88005d8ed840 path 5 ep1in 5=
e160000 cc 5 --> status -62
[    2.299072] ohci_hcd 0000:00:04.0: urb ffff88005d8e0540 path 5 ep2in 5=
e160000 cc 5 --> status -62
[    2.300088] ehci_hcd 0000:00:06.1: USB 2.0 started, EHCI 1.00
[    2.300147] usb usb4: default language 0x0409
[    2.300173] usb usb4: udev 1, busnum 4, minor =3D 384
[    2.300181] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    2.300189] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    2.300197] usb usb4: Product: EHCI Host Controller
[    2.300204] usb usb4: Manufacturer: Linux 3.0.3-vdr3-00280-gc9c8f9f eh=
ci_hcd
[    2.300212] usb usb4: SerialNumber: 0000:00:06.1
[    2.300712] usb usb4: usb_probe_device
[    2.300722] usb usb4: configuration #1 chosen from 1 choice
[    2.300750] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    2.301548] hub 4-0:1.0: usb_probe_interface
[    2.301558] hub 4-0:1.0: usb_probe_interface - got id
[    2.301567] hub 4-0:1.0: USB hub found
[    2.301592] hub 4-0:1.0: 6 ports detected
[    2.301599] hub 4-0:1.0: standalone hub
[    2.301605] hub 4-0:1.0: no power switching (usb 1.0)
[    2.301612] hub 4-0:1.0: individual port over-current protection
[    2.301619] hub 4-0:1.0: power on to power good time: 20ms
[    2.301636] hub 4-0:1.0: local power source is good
[    2.301645] hub 4-0:1.0: trying to enable port power on non-switchable=
 hub
[    2.301719] drivers/usb/core/inode.c: creating file '001'
[    2.301798] ehci_hcd 0000:00:06.1: HS companion for 0000:00:06.0
[    2.330079] ohci_hcd 0000:00:04.0: urb ffff88005d8ed840 path 5 ep1in 5=
e160000 cc 5 --> status -62
[    2.331075] ohci_hcd 0000:00:04.0: urb ffff88005d8e0540 path 5 ep2in 5=
e160000 cc 5 --> status -62
[    2.378086] ohci_hcd 0000:00:04.0: urb ffff88005d8ed840 path 5 ep1in 5=
e160000 cc 5 --> status -62
[    2.379083] ohci_hcd 0000:00:04.0: urb ffff88005d8e0540 path 5 ep2in 5=
e160000 cc 5 --> status -62
[    2.386838] ehci_hcd 0000:00:04.1: GetStatus port:4 status 001803 0  A=
CK POWER sig=3Dj CSC CONNECT
[    2.386856] hub 3-0:1.0: port 4: status 0501 change 0001
[    2.386879] ehci_hcd 0000:00:04.1: GetStatus port:5 status 001403 0  A=
CK POWER sig=3Dk CSC CONNECT
[    2.386893] hub 3-0:1.0: port 5: status 0501 change 0001
[    2.386914] ehci_hcd 0000:00:04.1: GetStatus port:6 status 001803 0  A=
CK POWER sig=3Dj CSC CONNECT
[    2.386927] hub 3-0:1.0: port 6: status 0501 change 0001
[    2.400064] hub 1-0:1.0: debounce: port 4: total 100ms stable 100ms st=
atus 0x100
[    2.400091] ohci_hcd 0000:00:04.0: GetStatus roothub.portstatus [4] =3D=
 0x00030300 PESC CSC LSDA PPS
[    2.400112] hub 1-0:1.0: port 5, status 0300, change 0003, 1.5 Mb/s
[    2.400120] usb 1-5: USB disconnect, device number 3
[    2.400125] usb 1-5: unregistering device
[    2.400132] usb 1-5: unregistering interface 1-5:1.0
[    2.437515] usb 1-5: unregistering interface 1-5:1.1
[    2.488246] usb 1-5: usb_disable_device nuking all URBs
[    2.626711] hub 1-0:1.0: debounce: port 5: total 100ms stable 100ms st=
atus 0x300
[    2.626725] ohci_hcd 0000:00:04.0: GetStatus roothub.portstatus [5] =3D=
 0x00030100 PESC CSC PPS
[    2.626738] hub 1-0:1.0: port 6, status 0100, change 0003, 12 Mb/s
[    2.626746] usb 1-6: USB disconnect, device number 4
[    2.626750] usb 1-6: unregistering device
[    2.626756] usb 1-6: unregistering interface 1-6:1.0
[    2.627012] usb 1-6: usb_disable_device nuking all URBs
[    2.746748] hub 1-0:1.0: debounce: port 6: total 100ms stable 100ms st=
atus 0x100
[    2.746759] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0000
[    2.746767] hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0000
[    2.746774] hub 3-0:1.0: state 7 ports 6 chg 0070 evt 0000
[    2.746786] hub 3-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
[    2.791708] EXT4-fs (sda5): mounted filesystem with ordered data mode.=
 Opts: (null)
[    2.800049] ehci_hcd 0000:00:04.1: port 4 full speed --> companion
[    2.800063] ehci_hcd 0000:00:04.1: GetStatus port:4 status 003001 0  A=
CK POWER OWNER sig=3Dse0 CONNECT
[    2.800076] hub 3-0:1.0: port 4 not reset yet, waiting 50ms
[    2.853392] ehci_hcd 0000:00:04.1: GetStatus port:4 status 003802 0  A=
CK POWER OWNER sig=3Dj CSC
[    2.853433] hub 3-0:1.0: port 5, status 0501, change 0000, 480 Mb/s
[    2.853450] ehci_hcd 0000:00:04.1: port 5 low speed --> companion
[    2.906733] ehci_hcd 0000:00:04.1: GetStatus port:5 status 003402 0  A=
CK POWER OWNER sig=3Dk CSC
[    2.906773] hub 3-0:1.0: port 6, status 0501, change 0000, 480 Mb/s
[    2.960079] ehci_hcd 0000:00:04.1: port 6 full speed --> companion
[    2.960097] ehci_hcd 0000:00:04.1: GetStatus port:6 status 003001 0  A=
CK POWER OWNER sig=3Dse0 CONNECT
[    2.960116] hub 3-0:1.0: port 6 not reset yet, waiting 50ms
[    2.967212] dracut: Remounting /dev/disk/by-uuid/c900708e-25b3-4743-9c=
67-2b03a62f3d73 with -o ro,relatime,errors=3Dremount-ro
[    2.975806] EXT4-fs (sda5): mounted filesystem with ordered data mode.=
 Opts: errors=3Dremount-ro
[    2.988713] dracut: Mounted root filesystem /dev/sda5
[    3.013382] ehci_hcd 0000:00:04.1: GetStatus port:6 status 003802 0  A=
CK POWER OWNER sig=3Dj CSC
[    3.013439] hub 3-0:1.0: state 7 ports 6 chg 0000 evt 0040
[    3.013451] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0010
[    3.013463] ohci_hcd 0000:00:04.0: GetStatus roothub.portstatus [3] =3D=
 0x00010101 CSC PPS CCS
[    3.013473] hub 1-0:1.0: port 4, status 0101, change 0001, 12 Mb/s
[    3.133373] hub 1-0:1.0: debounce: port 4: total 100ms stable 100ms st=
atus 0x101
[    3.200030] ohci_hcd 0000:00:04.0: GetStatus roothub.portstatus [3] =3D=
 0x00100103 PRSC PPS PES CCS
[    3.253417] usb 1-4: new full speed USB device number 5 using ohci_hcd=

[    3.282636] dracut: Switching root
[    3.323384] ohci_hcd 0000:00:04.0: GetStatus roothub.portstatus [3] =3D=
 0x00100103 PRSC PPS PES CCS
[    3.421115] usb 1-4: udev 5, busnum 1, minor =3D 4
[    3.421127] usb 1-4: New USB device found, idVendor=3D0a12, idProduct=3D=
0001
[    3.421136] usb 1-4: New USB device strings: Mfr=3D0, Product=3D0, Ser=
ialNumber=3D0
[    3.421478] usb 1-4: usb_probe_device
[    3.421487] usb 1-4: configuration #1 chosen from 1 choice
[    3.424093] usb 1-4: adding 1-4:1.0 (config #1, interface 0)
[    3.424372] usb 1-4: adding 1-4:1.1 (config #1, interface 1)
[    3.424566] drivers/usb/core/inode.c: creating file '005'
[    3.424613] ohci_hcd 0000:00:04.0: GetStatus roothub.portstatus [4] =3D=
 0x00010301 CSC LSDA PPS CCS
[    3.424627] hub 1-0:1.0: port 5, status 0301, change 0001, 1.5 Mb/s
[    3.543381] hub 1-0:1.0: debounce: port 5: total 100ms stable 100ms st=
atus 0x301
[    3.610036] ohci_hcd 0000:00:04.0: GetStatus roothub.portstatus [4] =3D=
 0x00100303 PRSC LSDA PPS PES CCS
[    3.663390] usb 1-5: new low speed USB device number 6 using ohci_hcd
[    3.730047] ohci_hcd 0000:00:04.0: GetStatus roothub.portstatus [4] =3D=
 0x00100303 PRSC LSDA PPS PES CCS
[    3.811087] usb 1-5: skipped 1 descriptor after interface
[    3.811096] usb 1-5: skipped 1 descriptor after interface
[    3.814078] usb 1-5: default language 0x0409
[    3.823075] usb 1-5: udev 6, busnum 1, minor =3D 5
[    3.823082] usb 1-5: New USB device found, idVendor=3D0a81, idProduct=3D=
0205
[    3.823088] usb 1-5: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    3.823094] usb 1-5: Product: PS2 to USB Converter
[    3.823099] usb 1-5: Manufacturer: CHESEN
[    3.823392] usb 1-5: usb_probe_device
[    3.823403] usb 1-5: configuration #1 chosen from 1 choice
[    3.831096] usb 1-5: adding 1-5:1.0 (config #1, interface 0)
[    3.831327] usbhid 1-5:1.0: usb_probe_interface
[    3.831335] usbhid 1-5:1.0: usb_probe_interface - got id
[    3.840610] input: CHESEN PS2 to USB Converter as /devices/pci0000:00/=
0000:00:04.0/usb1/1-5/1-5:1.0/input/input4
[    3.841082] generic-usb 0003:0A81:0205.0003: input,hidraw0: USB HID v1=
=2E10 Keyboard [CHESEN PS2 to USB Converter] on usb-0000:00:04.0-5/input0=

[    3.841200] usb 1-5: adding 1-5:1.1 (config #1, interface 1)
[    3.841408] usbhid 1-5:1.1: usb_probe_interface
[    3.841419] usbhid 1-5:1.1: usb_probe_interface - got id
[    3.852668] input: CHESEN PS2 to USB Converter as /devices/pci0000:00/=
0000:00:04.0/usb1/1-5/1-5:1.1/input/input5
[    3.853179] generic-usb 0003:0A81:0205.0004: input,hidraw1: USB HID v1=
=2E10 Mouse [CHESEN PS2 to USB Converter] on usb-0000:00:04.0-5/input1
[    3.853222] drivers/usb/core/inode.c: creating file '006'
[    3.853274] ohci_hcd 0000:00:04.0: GetStatus roothub.portstatus [5] =3D=
 0x00010101 CSC PPS CCS
[    3.853289] hub 1-0:1.0: port 6, status 0101, change 0001, 12 Mb/s
[    3.970058] hub 1-0:1.0: debounce: port 6: total 100ms stable 100ms st=
atus 0x101
[    4.036733] ohci_hcd 0000:00:04.0: GetStatus roothub.portstatus [5] =3D=
 0x00100103 PRSC PPS PES CCS
[    4.090069] usb 1-6: new full speed USB device number 7 using ohci_hcd=

[    4.156741] ohci_hcd 0000:00:04.0: GetStatus roothub.portstatus [5] =3D=
 0x00100103 PRSC PPS PES CCS
[    4.234082] usb 1-6: udev 7, busnum 1, minor =3D 6
[    4.234090] usb 1-6: New USB device found, idVendor=3D0cf3, idProduct=3D=
3000
[    4.234096] usb 1-6: New USB device strings: Mfr=3D0, Product=3D0, Ser=
ialNumber=3D0
[    4.234408] usb 1-6: usb_probe_device
[    4.234421] usb 1-6: configuration #1 chosen from 1 choice
[    4.237109] usb 1-6: adding 1-6:1.0 (config #1, interface 0)
[    4.237353] drivers/usb/core/inode.c: creating file '007'
[    4.237393] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0040
[    4.361331] udevd[1549]: starting version 172
[    4.874196] wmi: Mapper loaded
[    5.218752] nvidia: module license 'NVIDIA' taints kernel.
[    5.218761] Disabling lock debugging due to kernel taint
[    5.470054] Linux media interface: v0.10
[    5.549471] Linux video capture interface: v2.00
[    5.933864] IR NEC protocol handler initialized
[    5.947334] IR RC5(x) protocol handler initialized
[    5.960394] cx2388x alsa driver version 0.0.8 loaded
[    5.961095] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 18
[    5.961138] cx88_audio 0000:01:05.1: PCI INT A -> Link[LNKA] -> GSI 18=
 (level, low) -> IRQ 18
[    5.961886] cx88/0: cx2388x v4l2 driver version 0.0.8 loaded
[    5.967161] cx88[0]: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4=
000(Lite) DVB-S/S2 [card=3D69,autodetected], frontend(s): 1
[    5.967172] cx88[0]: TV tuner type -1, Radio tuner type -1
[    5.973461] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.8 loade=
d
[    5.988507] IR RC6 protocol handler initialized
[    6.019443] IR JVC protocol handler initialized
[    6.055152] IR Sony protocol handler initialized
[    6.084312] lirc_dev: IR Remote Control driver registered, major 250=20
[    6.085238] IR LIRC bridge handler initialized
[    6.166224] i2c-core: driver [tuner] using legacy suspend method
[    6.166232] i2c-core: driver [tuner] using legacy resume method
[    6.245634] tveeprom 0-0050: Hauppauge model 69100, rev B4C3, serial# =
7067407
[    6.245645] tveeprom 0-0050: MAC address is 00:0d:fe:6b:d7:0f
[    6.245654] tveeprom 0-0050: tuner model is Conexant CX24118A (idx 123=
, type 4)
[    6.245664] tveeprom 0-0050: TV standards ATSC/DVB Digital (eeprom 0x8=
0)
[    6.245671] tveeprom 0-0050: audio processor is None (idx 0)
[    6.245679] tveeprom 0-0050: decoder processor is CX880 (idx 20)
[    6.245686] tveeprom 0-0050: has no radio, has IR receiver, has no IR =
transmitter
[    6.245694] cx88[0]: hauppauge eeprom: model=3D69100
[    6.283417] Registered IR keymap rc-hauppauge
[    6.283689] input: cx88 IR (Hauppauge WinTV-HVR400 as /devices/pci0000=
:00/0000:00:09.0/0000:01:05.1/rc/rc0/input6
[    6.283813] rc0: cx88 IR (Hauppauge WinTV-HVR400 as /devices/pci0000:0=
0/0000:00:09.0/0000:01:05.1/rc/rc0
[    6.284004] rc rc0: lirc_dev: driver ir-lirc-codec (cx88xx) registered=
 at minor =3D 0
[    6.284110] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
[    6.284422] cx8800 0000:01:05.0: PCI INT A -> Link[LNKA] -> GSI 18 (le=
vel, low) -> IRQ 18
[    6.284448] cx88[0]/0: found at 0000:01:05.0, rev: 5, irq: 18, latency=
: 64, mmio: 0xf9000000
[    6.284678] cx88[0]/0: registered device video0 [v4l2]
[    6.284740] cx88[0]/0: registered device vbi0
[    6.284783] cx88[0]/2: cx2388x 8802 Driver Manager
[    6.284806] cx88-mpeg driver manager 0000:01:05.2: PCI INT A -> Link[L=
NKA] -> GSI 18 (level, low) -> IRQ 18
[    6.284821] cx88[0]/2: found at 0000:01:05.2, rev: 5, irq: 18, latency=
: 64, mmio: 0xf7000000
[    6.364794] cx88/2: cx2388x dvb driver version 0.0.8 loaded
[    6.364805] cx88/2: registering cx8802 driver, type: dvb access: share=
d
[    6.364815] cx88[0]/2: subsystem: 0070:6906, board: Hauppauge WinTV-HV=
R4000(Lite) DVB-S/S2 [card=3D69]
[    6.364824] cx88[0]/2: cx2388x based DVB/ATSC card
[    6.364830] cx8802_alloc_frontends() allocating 1 frontend(s)
[    6.585634] DVB: registering new adapter (cx88[0])
[    6.585649] DVB: registering adapter 0 frontend 0 (Conexant CX24116/CX=
24118)...
[    7.531617] ACPI: PCI Interrupt Link [LPMU] enabled at IRQ 20
[    7.531632] nvidia 0000:00:03.5: PCI INT B -> Link[LPMU] -> GSI 20 (le=
vel, low) -> IRQ 20
[    7.532080] ACPI: PCI Interrupt Link [SGRU] enabled at IRQ 23
[    7.532089] nvidia 0000:02:00.0: PCI INT A -> Link[SGRU] -> GSI 23 (le=
vel, low) -> IRQ 23
[    7.532105] nvidia 0000:02:00.0: setting latency timer to 64
[    7.532115] vgaarb: device changed decodes: PCI:0000:02:00.0,olddecode=
s=3Dio+mem,decodes=3Dnone:owns=3Dio+mem
[    7.532600] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  280.13  We=
d Jul 27 16:53:56 PDT 2011
[    8.384955] EXT4-fs (sda5): warning: checktime reached, running e2fsck=
 is recommended
[    8.385202] EXT4-fs (sda5): re-mounted. Opts: errors=3Dremount-ro
[    9.204497] EXT4-fs (sda1): warning: checktime reached, running e2fsck=
 is recommended
[    9.204877] EXT4-fs (sda1): mounted filesystem with ordered data mode.=
 Opts: (null)
[    9.329975] EXT4-fs (sda7): warning: checktime reached, running e2fsck=
 is recommended
[    9.571886] EXT4-fs (sda7): mounted filesystem with ordered data mode.=
 Opts: (null)
[    9.598102] EXT4-fs (sda6): warning: checktime reached, running e2fsck=
 is recommended
[    9.599374] EXT4-fs (sda6): mounted filesystem with ordered data mode.=
 Opts: (null)
[   11.094260] fuse init (API version 7.16)
[   11.312216] r8169 0000:03:00.0: eth0: link down
[   11.312229] r8169 0000:03:00.0: eth0: link down
[   11.313002] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   13.727174] r8169 0000:03:00.0: eth0: link up
[   13.727973] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   14.516247] r8169 0000:03:00.0: eth0: link down
[   16.809848] r8169 0000:03:00.0: eth0: link up
[   20.770977] cx24116_firmware_ondemand: Waiting for firmware upload (dv=
b-fe-cx24116.fw)...
[   20.797657] cx24116_firmware_ondemand: Waiting for firmware upload(2).=
=2E.
[   25.960038] cx24116_load_firmware: FW version 1.23.86.1
[   25.960062] cx24116_firmware_ondemand: Firmware upload complete
[   26.118176] hrtimer: interrupt took 1133 ns

--------------070507000406000907090407
Content-Type: text/plain;
 name="config-vdr3"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="config-vdr3"

#
# Automatically generated make config: don't edit
# Linux/x86_64 3.0.3-vdr3 Kernel Configuration
#
CONFIG_64BIT=3Dy
# CONFIG_X86_32 is not set
CONFIG_X86_64=3Dy
CONFIG_X86=3Dy
CONFIG_INSTRUCTION_DECODER=3Dy
CONFIG_OUTPUT_FORMAT=3D"elf64-x86-64"
CONFIG_ARCH_DEFCONFIG=3D"arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_CMOS_UPDATE=3Dy
CONFIG_CLOCKSOURCE_WATCHDOG=3Dy
CONFIG_GENERIC_CLOCKEVENTS=3Dy
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=3Dy
CONFIG_LOCKDEP_SUPPORT=3Dy
CONFIG_STACKTRACE_SUPPORT=3Dy
CONFIG_HAVE_LATENCYTOP_SUPPORT=3Dy
CONFIG_MMU=3Dy
CONFIG_ZONE_DMA=3Dy
CONFIG_NEED_DMA_MAP_STATE=3Dy
CONFIG_NEED_SG_DMA_LENGTH=3Dy
CONFIG_GENERIC_ISA_DMA=3Dy
CONFIG_GENERIC_IOMAP=3Dy
CONFIG_GENERIC_BUG=3Dy
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=3Dy
CONFIG_GENERIC_HWEIGHT=3Dy
CONFIG_ARCH_MAY_HAVE_PC_FDC=3Dy
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=3Dy
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=3Dy
CONFIG_GENERIC_CALIBRATE_DELAY=3Dy
CONFIG_GENERIC_TIME_VSYSCALL=3Dy
CONFIG_ARCH_HAS_CPU_RELAX=3Dy
CONFIG_ARCH_HAS_DEFAULT_IDLE=3Dy
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=3Dy
CONFIG_HAVE_SETUP_PER_CPU_AREA=3Dy
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=3Dy
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=3Dy
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=3Dy
CONFIG_ARCH_HIBERNATION_POSSIBLE=3Dy
CONFIG_ARCH_SUSPEND_POSSIBLE=3Dy
CONFIG_ZONE_DMA32=3Dy
CONFIG_ARCH_POPULATES_NODE_MAP=3Dy
CONFIG_AUDIT_ARCH=3Dy
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=3Dy
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=3Dy
CONFIG_HAVE_INTEL_TXT=3Dy
CONFIG_X86_64_SMP=3Dy
CONFIG_X86_HT=3Dy
CONFIG_ARCH_HWEIGHT_CFLAGS=3D"-fcall-saved-rdi -fcall-saved-rsi -fcall-sa=
ved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10=
 -fcall-saved-r11"
# CONFIG_KTIME_SCALAR is not set
CONFIG_ARCH_CPU_PROBE_RELEASE=3Dy
CONFIG_DEFCONFIG_LIST=3D"/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=3Dy
CONFIG_IRQ_WORK=3Dy

#
# General setup
#
CONFIG_EXPERIMENTAL=3Dy
CONFIG_INIT_ENV_ARG_LIMIT=3D32
CONFIG_CROSS_COMPILE=3D""
CONFIG_LOCALVERSION=3D""
CONFIG_LOCALVERSION_AUTO=3Dy
CONFIG_HAVE_KERNEL_GZIP=3Dy
CONFIG_HAVE_KERNEL_BZIP2=3Dy
CONFIG_HAVE_KERNEL_LZMA=3Dy
CONFIG_HAVE_KERNEL_XZ=3Dy
CONFIG_HAVE_KERNEL_LZO=3Dy
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=3Dy
CONFIG_DEFAULT_HOSTNAME=3D"(none)"
CONFIG_SWAP=3Dy
CONFIG_SYSVIPC=3Dy
CONFIG_SYSVIPC_SYSCTL=3Dy
CONFIG_POSIX_MQUEUE=3Dy
CONFIG_POSIX_MQUEUE_SYSCTL=3Dy
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_FHANDLE is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=3Dy

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=3Dy
CONFIG_HAVE_SPARSE_IRQ=3Dy
CONFIG_GENERIC_IRQ_PROBE=3Dy
CONFIG_GENERIC_IRQ_SHOW=3Dy
CONFIG_GENERIC_PENDING_IRQ=3Dy
CONFIG_IRQ_FORCED_THREADING=3Dy
CONFIG_SPARSE_IRQ=3Dy

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=3Dy
CONFIG_PREEMPT_RCU=3Dy
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=3D64
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_BOOST is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=3D18
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=3Dy
CONFIG_CGROUPS=3Dy
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=3Dy
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
CONFIG_CGROUP_CPUACCT=3Dy
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=3Dy
CONFIG_FAIR_GROUP_SCHED=3Dy
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=3Dy
# CONFIG_DEBUG_BLK_CGROUP is not set
CONFIG_NAMESPACES=3Dy
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=3Dy
CONFIG_BLK_DEV_INITRD=3Dy
CONFIG_INITRAMFS_SOURCE=3D""
CONFIG_RD_GZIP=3Dy
CONFIG_RD_BZIP2=3Dy
CONFIG_RD_LZMA=3Dy
CONFIG_RD_XZ=3Dy
CONFIG_RD_LZO=3Dy
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=3Dy
CONFIG_ANON_INODES=3Dy
# CONFIG_EXPERT is not set
CONFIG_UID16=3Dy
CONFIG_SYSCTL_SYSCALL=3Dy
CONFIG_KALLSYMS=3Dy
CONFIG_HOTPLUG=3Dy
CONFIG_PRINTK=3Dy
CONFIG_BUG=3Dy
CONFIG_ELF_CORE=3Dy
CONFIG_PCSPKR_PLATFORM=3Dy
CONFIG_BASE_FULL=3Dy
CONFIG_FUTEX=3Dy
CONFIG_EPOLL=3Dy
CONFIG_SIGNALFD=3Dy
CONFIG_TIMERFD=3Dy
CONFIG_EVENTFD=3Dy
CONFIG_SHMEM=3Dy
CONFIG_AIO=3Dy
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=3Dy

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=3Dy
# CONFIG_PERF_COUNTERS is not set
CONFIG_VM_EVENT_COUNTERS=3Dy
CONFIG_PCI_QUIRKS=3Dy
CONFIG_SLUB_DEBUG=3Dy
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=3Dy
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=3Dy
# CONFIG_KPROBES is not set
CONFIG_JUMP_LABEL=3Dy
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=3Dy
CONFIG_HAVE_IOREMAP_PROT=3Dy
CONFIG_HAVE_KPROBES=3Dy
CONFIG_HAVE_KRETPROBES=3Dy
CONFIG_HAVE_OPTPROBES=3Dy
CONFIG_HAVE_ARCH_TRACEHOOK=3Dy
CONFIG_HAVE_DMA_ATTRS=3Dy
CONFIG_USE_GENERIC_SMP_HELPERS=3Dy
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=3Dy
CONFIG_HAVE_DMA_API_DEBUG=3Dy
CONFIG_HAVE_HW_BREAKPOINT=3Dy
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=3Dy
CONFIG_HAVE_USER_RETURN_NOTIFIER=3Dy
CONFIG_HAVE_PERF_EVENTS_NMI=3Dy
CONFIG_HAVE_ARCH_JUMP_LABEL=3Dy

#
# GCOV-based kernel profiling
#
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=3Dy
CONFIG_RT_MUTEXES=3Dy
CONFIG_BASE_SMALL=3D0
CONFIG_MODULES=3Dy
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=3Dy
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=3Dy
CONFIG_BLOCK=3Dy
CONFIG_BLK_DEV_BSG=3Dy
CONFIG_BLK_DEV_INTEGRITY=3Dy
CONFIG_BLK_DEV_THROTTLING=3Dy
CONFIG_BLOCK_COMPAT=3Dy

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=3Dy
CONFIG_IOSCHED_DEADLINE=3Dy
CONFIG_IOSCHED_CFQ=3Dy
CONFIG_CFQ_GROUP_IOSCHED=3Dy
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=3Dy
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED=3D"cfq"
CONFIG_PADATA=3Dy
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
# CONFIG_INLINE_SPIN_UNLOCK is not set
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
CONFIG_MUTEX_SPIN_ON_OWNER=3Dy
CONFIG_FREEZER=3Dy

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=3Dy
CONFIG_NO_HZ=3Dy
CONFIG_HIGH_RES_TIMERS=3Dy
CONFIG_GENERIC_CLOCKEVENTS_BUILD=3Dy
CONFIG_SMP=3Dy
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=3Dy
CONFIG_SCHED_OMIT_FRAME_POINTER=3Dy
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_NO_BOOTMEM=3Dy
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
CONFIG_MATOM=3Dy
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=3D6
CONFIG_X86_CMPXCHG=3Dy
CONFIG_CMPXCHG_LOCAL=3Dy
CONFIG_X86_L1_CACHE_SHIFT=3D6
CONFIG_X86_XADD=3Dy
CONFIG_X86_WP_WORKS_OK=3Dy
CONFIG_X86_USE_PPRO_CHECKSUM=3Dy
CONFIG_X86_TSC=3Dy
CONFIG_X86_CMPXCHG64=3Dy
CONFIG_X86_CMOV=3Dy
CONFIG_X86_MINIMUM_CPU_FAMILY=3D64
CONFIG_X86_DEBUGCTLMSR=3Dy
CONFIG_CPU_SUP_INTEL=3Dy
CONFIG_CPU_SUP_AMD=3Dy
CONFIG_CPU_SUP_CENTAUR=3Dy
CONFIG_HPET_TIMER=3Dy
CONFIG_HPET_EMULATE_RTC=3Dy
CONFIG_DMI=3Dy
CONFIG_GART_IOMMU=3Dy
# CONFIG_CALGARY_IOMMU is not set
# CONFIG_AMD_IOMMU is not set
CONFIG_SWIOTLB=3Dy
CONFIG_IOMMU_HELPER=3Dy
CONFIG_IOMMU_API=3Dy
CONFIG_NR_CPUS=3D64
CONFIG_SCHED_SMT=3Dy
CONFIG_SCHED_MC=3Dy
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=3Dy
CONFIG_X86_LOCAL_APIC=3Dy
CONFIG_X86_IO_APIC=3Dy
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=3Dy
CONFIG_X86_MCE_INTEL=3Dy
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=3Dy
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=3Dy
# CONFIG_I8K is not set
CONFIG_MICROCODE=3Dy
CONFIG_MICROCODE_INTEL=3Dy
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=3Dy
CONFIG_X86_MSR=3Dy
CONFIG_X86_CPUID=3Dy
CONFIG_ARCH_PHYS_ADDR_T_64BIT=3Dy
CONFIG_ARCH_DMA_ADDR_T_64BIT=3Dy
CONFIG_DIRECT_GBPAGES=3Dy
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=3Dy
CONFIG_ARCH_SPARSEMEM_DEFAULT=3Dy
CONFIG_ARCH_SELECT_MEMORY_MODEL=3Dy
CONFIG_ARCH_PROC_KCORE_TEXT=3Dy
CONFIG_ILLEGAL_POINTER_VALUE=3D0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=3Dy
CONFIG_SPARSEMEM_MANUAL=3Dy
CONFIG_SPARSEMEM=3Dy
CONFIG_HAVE_MEMORY_PRESENT=3Dy
CONFIG_SPARSEMEM_EXTREME=3Dy
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=3Dy
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=3Dy
CONFIG_SPARSEMEM_VMEMMAP=3Dy
CONFIG_HAVE_MEMBLOCK=3Dy
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=3Dy
CONFIG_SPLIT_PTLOCK_CPUS=3D4
CONFIG_COMPACTION=3Dy
CONFIG_MIGRATION=3Dy
CONFIG_PHYS_ADDR_T_64BIT=3Dy
CONFIG_ZONE_DMA_FLAG=3D1
CONFIG_BOUNCE=3Dy
CONFIG_VIRT_TO_BUS=3Dy
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=3D4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=3Dy
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=3Dy
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=3Dy
# CONFIG_CLEANCACHE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=3Dy
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=3Dy
CONFIG_X86_RESERVE_LOW=3D64
CONFIG_MTRR=3Dy
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=3Dy
CONFIG_ARCH_USES_PG_UNCACHED=3Dy
CONFIG_EFI=3Dy
CONFIG_SECCOMP=3Dy
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=3Dy
# CONFIG_HZ_1000 is not set
CONFIG_HZ=3D300
CONFIG_SCHED_HRTICK=3Dy
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=3D0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=3D0x1000000
CONFIG_HOTPLUG_CPU=3Dy
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=3Dy

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=3Dy
CONFIG_SUSPEND=3Dy
CONFIG_SUSPEND_FREEZER=3Dy
CONFIG_HIBERNATE_CALLBACKS=3Dy
CONFIG_HIBERNATION=3Dy
CONFIG_PM_STD_PARTITION=3D""
CONFIG_PM_SLEEP=3Dy
CONFIG_PM_SLEEP_SMP=3Dy
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=3Dy
CONFIG_PM_DEBUG=3Dy
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_CAN_PM_TRACE=3Dy
CONFIG_PM_TRACE=3Dy
CONFIG_PM_TRACE_RTC=3Dy
CONFIG_ACPI=3Dy
CONFIG_ACPI_SLEEP=3Dy
CONFIG_ACPI_PROCFS=3Dy
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=3Dy
CONFIG_ACPI_AC=3Dy
CONFIG_ACPI_BATTERY=3Dy
CONFIG_ACPI_BUTTON=3Dy
CONFIG_ACPI_VIDEO=3Dy
CONFIG_ACPI_FAN=3Dy
CONFIG_ACPI_DOCK=3Dy
CONFIG_ACPI_PROCESSOR=3Dy
CONFIG_ACPI_HOTPLUG_CPU=3Dy
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=3Dy
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=3D0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=3Dy
CONFIG_ACPI_CONTAINER=3Dy
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=3Dy
CONFIG_CPU_FREQ_TABLE=3Dy
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=3Dy
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=3Dy
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=3Dy
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_PCC_CPUFREQ=3Dy
CONFIG_X86_ACPI_CPUFREQ=3Dy
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=3Dy
CONFIG_CPU_IDLE_GOV_LADDER=3Dy
CONFIG_CPU_IDLE_GOV_MENU=3Dy
CONFIG_INTEL_IDLE=3Dy

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=3Dy
CONFIG_PCI_DIRECT=3Dy
CONFIG_PCI_MMCONFIG=3Dy
CONFIG_PCI_DOMAINS=3Dy
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_DMAR=3Dy
# CONFIG_DMAR_DEFAULT_ON is not set
CONFIG_DMAR_FLOPPY_WA=3Dy
# CONFIG_INTR_REMAP is not set
CONFIG_PCIEPORTBUS=3Dy
CONFIG_PCIEAER=3Dy
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=3Dy
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_ARCH_SUPPORTS_MSI=3Dy
CONFIG_PCI_MSI=3Dy
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=3Dy
CONFIG_PCI_IOV=3Dy
CONFIG_PCI_IOAPIC=3Dy
CONFIG_PCI_LABEL=3Dy
CONFIG_ISA_DMA_API=3Dy
CONFIG_AMD_NB=3Dy
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=3Dy
CONFIG_COMPAT_BINFMT_ELF=3Dy
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=3Dy
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=3Dm
CONFIG_IA32_EMULATION=3Dy
CONFIG_IA32_AOUT=3Dm
CONFIG_COMPAT=3Dy
CONFIG_COMPAT_FOR_U64_ALIGNMENT=3Dy
CONFIG_SYSVIPC_COMPAT=3Dy
CONFIG_KEYS_COMPAT=3Dy
CONFIG_HAVE_TEXT_POKE_SMP=3Dy
CONFIG_NET=3Dy

#
# Networking options
#
CONFIG_PACKET=3Dy
CONFIG_UNIX=3Dy
CONFIG_XFRM=3Dy
CONFIG_XFRM_USER=3Dy
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=3Dy
CONFIG_IP_MULTICAST=3Dy
# CONFIG_IP_ADVANCED_ROUTER is not set
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=3Dy
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=3Dy
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=3Dy
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=3Dy
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=3Dy
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
CONFIG_DEFAULT_CUBIC=3Dy
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG=3D"cubic"
CONFIG_TCP_MD5SIG=3Dy
CONFIG_IPV6=3Dy
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=3Dy
CONFIG_INET6_ESP=3Dy
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=3Dy
CONFIG_INET6_XFRM_MODE_TUNNEL=3Dy
CONFIG_INET6_XFRM_MODE_BEET=3Dy
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=3Dy
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=3Dy
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETWORK_SECMARK=3Dy
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=3Dy

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_MQPRIO is not set
# CONFIG_NET_SCH_CHOKE is not set
# CONFIG_NET_SCH_QFQ is not set
# CONFIG_NET_SCH_INGRESS is not set

#
# Classification
#
CONFIG_NET_CLS=3Dy
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_EMATCH=3Dy
CONFIG_NET_EMATCH_STACK=3D32
# CONFIG_NET_EMATCH_CMP is not set
# CONFIG_NET_EMATCH_NBYTE is not set
# CONFIG_NET_EMATCH_U32 is not set
# CONFIG_NET_EMATCH_META is not set
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_CLS_ACT=3Dy
# CONFIG_NET_ACT_POLICE is not set
# CONFIG_NET_ACT_GACT is not set
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_NAT is not set
# CONFIG_NET_ACT_PEDIT is not set
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
# CONFIG_NET_ACT_CSUM is not set
CONFIG_NET_SCH_FIFO=3Dy
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=3Dy
# CONFIG_BATMAN_ADV is not set
CONFIG_RPS=3Dy
CONFIG_RFS_ACCEL=3Dy
CONFIG_XPS=3Dy
CONFIG_HAVE_BPF_JIT=3Dy
# CONFIG_BPF_JIT is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_WIRELESS=3Dy
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=3D"/sbin/hotplug"
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=3Dy
CONFIG_PREVENT_FIRMWARE_BUILD=3Dy
CONFIG_FW_LOADER=3Dy
CONFIG_FIRMWARE_IN_KERNEL=3Dy
CONFIG_EXTRA_FIRMWARE=3D""
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=3Dy
CONFIG_PROC_EVENTS=3Dy
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=3Dy
CONFIG_PNP_DEBUG_MESSAGES=3Dy

#
# Protocols
#
CONFIG_PNPACPI=3Dy
CONFIG_BLK_DEV=3Dy
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=3Dy
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=3Dy
CONFIG_BLK_DEV_RAM_COUNT=3D16
CONFIG_BLK_DEV_RAM_SIZE=3D16384
CONFIG_BLK_DEV_XIP=3Dy
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=3Dy
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=3Dy
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=3Dy
CONFIG_SCSI_DMA=3Dy
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=3Dy

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=3Dy
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=3Dy
CONFIG_BLK_DEV_SR_VENDOR=3Dy
CONFIG_CHR_DEV_SG=3Dy
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=3Dy
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=3Dm

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=3Dy
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=3Dy
CONFIG_ATA_ACPI=3Dy
CONFIG_SATA_PMP=3Dy

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=3Dy
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=3Dy
# CONFIG_IFB is not set
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
CONFIG_MII=3Dy
CONFIG_PHYLIB=3Dy

#
# MII PHY device drivers
#
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_NETDEV_1000=3Dy
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=3Dy
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
# CONFIG_STMMAC_ETH is not set
# CONFIG_PCH_GBE is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
CONFIG_USB_CATC=3Dm
CONFIG_USB_KAWETH=3Dm
CONFIG_USB_PEGASUS=3Dm
CONFIG_USB_RTL8150=3Dm
CONFIG_USB_USBNET=3Dm
CONFIG_USB_NET_AX8817X=3Dm
CONFIG_USB_NET_CDCETHER=3Dm
CONFIG_USB_NET_CDC_EEM=3Dm
CONFIG_USB_NET_CDC_NCM=3Dm
CONFIG_USB_NET_DM9601=3Dm
CONFIG_USB_NET_SMSC75XX=3Dm
CONFIG_USB_NET_SMSC95XX=3Dm
CONFIG_USB_NET_GL620A=3Dm
CONFIG_USB_NET_NET1080=3Dm
CONFIG_USB_NET_PLUSB=3Dm
CONFIG_USB_NET_MCS7830=3Dm
CONFIG_USB_NET_RNDIS_HOST=3Dm
CONFIG_USB_NET_CDC_SUBSET=3Dm
CONFIG_USB_ALI_M5632=3Dy
CONFIG_USB_AN2720=3Dy
CONFIG_USB_BELKIN=3Dy
CONFIG_USB_ARMLINUX=3Dy
CONFIG_USB_EPSON2888=3Dy
CONFIG_USB_KC2190=3Dy
CONFIG_USB_NET_ZAURUS=3Dm
CONFIG_USB_NET_CX82310_ETH=3Dm
CONFIG_USB_NET_KALMIA=3Dm
CONFIG_USB_NET_INT51X1=3Dm
CONFIG_USB_IPHETH=3Dm
CONFIG_USB_SIERRA_NET=3Dm
CONFIG_USB_VL600=3Dm
# CONFIG_WAN is not set

#
# CAIF transport drivers
#
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=3Dy
CONFIG_NETPOLL=3Dy
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=3Dy
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=3Dy
CONFIG_INPUT_FF_MEMLESS=3Dy
CONFIG_INPUT_POLLDEV=3Dy
CONFIG_INPUT_SPARSEKMAP=3Dy

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=3Dy
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=3D1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=3D768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=3Dy
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=3Dy
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=3Dy
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=3Dy
# CONFIG_MOUSE_PS2 is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=3Dy
CONFIG_SERIO_I8042=3Dy
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=3Dy
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=3Dy
CONFIG_CONSOLE_TRANSLATIONS=3Dy
CONFIG_VT_CONSOLE=3Dy
CONFIG_HW_CONSOLE=3Dy
CONFIG_VT_HW_CONSOLE_BINDING=3Dy
CONFIG_UNIX98_PTYS=3Dy
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=3Dy

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=3Dy

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=3Dy
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=3Dy
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=3Dy
# CONFIG_HPET_MMAP is not set
CONFIG_HANGCHECK_TIMER=3Dm
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=3Dy
# CONFIG_RAMOOPS is not set
CONFIG_I2C=3Dy
CONFIG_I2C_BOARDINFO=3Dy
CONFIG_I2C_COMPAT=3Dy
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=3Dy
CONFIG_I2C_ALGOBIT=3Dm

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=3Dy
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set
# CONFIG_I2C_EG20T is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set

#
# PPS generators support
#

#
# PTP clock support
#

#
# Enable Device Drivers -> PPS to see the PTP clock options.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=3Dy
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=3Dy
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ20Z75 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_HWMON=3Dy
# CONFIG_HWMON_VID is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_CORETEMP=3Dy
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=3Dy
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=3Dy
CONFIG_THERMAL_HWMON=3Dy
CONFIG_WATCHDOG=3Dy
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=3Dm
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=3Dm
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=3Dy

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=3Dy

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set
# CONFIG_MFD_SUPPORT is not set
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=3Dm

#
# Multimedia core support
#
CONFIG_MEDIA_CONTROLLER=3Dy
CONFIG_VIDEO_DEV=3Dm
CONFIG_VIDEO_V4L2_COMMON=3Dm
CONFIG_VIDEO_V4L2_SUBDEV_API=3Dy
CONFIG_DVB_CORE=3Dm
CONFIG_VIDEO_MEDIA=3Dm

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=3Dm
CONFIG_VIDEO_SAA7146_VV=3Dm
CONFIG_RC_CORE=3Dm
CONFIG_LIRC=3Dm
CONFIG_RC_MAP=3Dm
CONFIG_IR_NEC_DECODER=3Dm
CONFIG_IR_RC5_DECODER=3Dm
CONFIG_IR_RC6_DECODER=3Dm
CONFIG_IR_JVC_DECODER=3Dm
CONFIG_IR_SONY_DECODER=3Dm
CONFIG_IR_RC5_SZ_DECODER=3Dm
CONFIG_IR_LIRC_CODEC=3Dm
CONFIG_IR_ENE=3Dm
CONFIG_IR_IMON=3Dm
CONFIG_IR_MCEUSB=3Dm
CONFIG_IR_ITE_CIR=3Dm
CONFIG_IR_FINTEK=3Dm
CONFIG_IR_NUVOTON=3Dm
CONFIG_IR_REDRAT3=3Dm
CONFIG_IR_STREAMZAP=3Dm
CONFIG_IR_WINBOND_CIR=3Dm
CONFIG_RC_LOOPBACK=3Dm
CONFIG_MEDIA_ATTACH=3Dy
CONFIG_MEDIA_TUNER=3Dm
# CONFIG_MEDIA_TUNER_CUSTOMISE is not set
CONFIG_MEDIA_TUNER_SIMPLE=3Dm
CONFIG_MEDIA_TUNER_TDA8290=3Dm
CONFIG_MEDIA_TUNER_TDA827X=3Dm
CONFIG_MEDIA_TUNER_TDA18271=3Dm
CONFIG_MEDIA_TUNER_TDA9887=3Dm
CONFIG_MEDIA_TUNER_TEA5761=3Dm
CONFIG_MEDIA_TUNER_TEA5767=3Dm
CONFIG_MEDIA_TUNER_MT20XX=3Dm
CONFIG_MEDIA_TUNER_MT2060=3Dm
CONFIG_MEDIA_TUNER_MT2266=3Dm
CONFIG_MEDIA_TUNER_MT2131=3Dm
CONFIG_MEDIA_TUNER_QT1010=3Dm
CONFIG_MEDIA_TUNER_XC2028=3Dm
CONFIG_MEDIA_TUNER_XC5000=3Dm
CONFIG_MEDIA_TUNER_MXL5005S=3Dm
CONFIG_MEDIA_TUNER_MXL5007T=3Dm
CONFIG_MEDIA_TUNER_MC44S803=3Dm
CONFIG_MEDIA_TUNER_MAX2165=3Dm
CONFIG_MEDIA_TUNER_TDA18218=3Dm
CONFIG_MEDIA_TUNER_TDA18212=3Dm
CONFIG_VIDEO_V4L2=3Dm
CONFIG_VIDEOBUF_GEN=3Dm
CONFIG_VIDEOBUF_DMA_SG=3Dm
CONFIG_VIDEOBUF_VMALLOC=3Dm
CONFIG_VIDEOBUF_DVB=3Dm
CONFIG_VIDEO_BTCX=3Dm
CONFIG_VIDEO_TVEEPROM=3Dm
CONFIG_VIDEO_TUNER=3Dm
CONFIG_VIDEOBUF2_CORE=3Dm
CONFIG_VIDEO_CAPTURE_DRIVERS=3Dy
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=3Dy
CONFIG_VIDEO_IR_I2C=3Dm

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=3Dm
CONFIG_VIDEO_TDA7432=3Dm
CONFIG_VIDEO_TDA9840=3Dm
CONFIG_VIDEO_TEA6415C=3Dm
CONFIG_VIDEO_TEA6420=3Dm
CONFIG_VIDEO_MSP3400=3Dm
CONFIG_VIDEO_CS5345=3Dm
CONFIG_VIDEO_CS53L32A=3Dm
CONFIG_VIDEO_WM8775=3Dm
CONFIG_VIDEO_WM8739=3Dm
CONFIG_VIDEO_VP27SMPX=3Dm

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=3Dm

#
# Video decoders
#
CONFIG_VIDEO_BT819=3Dm
CONFIG_VIDEO_BT856=3Dm
CONFIG_VIDEO_BT866=3Dm
CONFIG_VIDEO_KS0127=3Dm
CONFIG_VIDEO_SAA7110=3Dm
CONFIG_VIDEO_SAA711X=3Dm
CONFIG_VIDEO_TVP5150=3Dm
CONFIG_VIDEO_VPX3220=3Dm

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=3Dm
CONFIG_VIDEO_CX25840=3Dm

#
# MPEG video encoders
#
CONFIG_VIDEO_CX2341X=3Dm

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=3Dm
CONFIG_VIDEO_SAA7185=3Dm
CONFIG_VIDEO_ADV7170=3Dm
CONFIG_VIDEO_ADV7175=3Dm

#
# Camera sensor devices
#
CONFIG_VIDEO_OV7670=3Dm
CONFIG_VIDEO_MT9V011=3Dm

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=3Dm
CONFIG_VIDEO_UPD64083=3Dm

#
# Miscelaneous helper chips
#
CONFIG_VIDEO_M52790=3Dm
CONFIG_VIDEO_BT848=3Dm
CONFIG_VIDEO_BT848_DVB=3Dy
CONFIG_VIDEO_CPIA2=3Dm
CONFIG_VIDEO_ZORAN=3Dm
CONFIG_VIDEO_ZORAN_DC30=3Dm
CONFIG_VIDEO_ZORAN_ZR36060=3Dm
CONFIG_VIDEO_ZORAN_BUZ=3Dm
CONFIG_VIDEO_ZORAN_DC10=3Dm
CONFIG_VIDEO_ZORAN_LML33=3Dm
CONFIG_VIDEO_ZORAN_LML33R10=3Dm
CONFIG_VIDEO_ZORAN_AVS6EYES=3Dm
CONFIG_VIDEO_SAA7134=3Dm
CONFIG_VIDEO_SAA7134_ALSA=3Dm
CONFIG_VIDEO_SAA7134_RC=3Dy
CONFIG_VIDEO_SAA7134_DVB=3Dm
CONFIG_VIDEO_MXB=3Dm
CONFIG_VIDEO_HEXIUM_ORION=3Dm
CONFIG_VIDEO_HEXIUM_GEMINI=3Dm
CONFIG_VIDEO_CX88=3Dm
CONFIG_VIDEO_CX88_ALSA=3Dm
CONFIG_VIDEO_CX88_BLACKBIRD=3Dm
CONFIG_VIDEO_CX88_DVB=3Dm
CONFIG_VIDEO_CX88_MPEG=3Dm
CONFIG_VIDEO_CX88_VP3054=3Dm
CONFIG_VIDEO_CX23885=3Dm
CONFIG_MEDIA_ALTERA_CI=3Dm
CONFIG_VIDEO_AU0828=3Dm
CONFIG_VIDEO_IVTV=3Dm
CONFIG_VIDEO_CX18=3Dm
CONFIG_VIDEO_CX18_ALSA=3Dm
CONFIG_VIDEO_SAA7164=3Dm
CONFIG_VIDEO_CAFE_CCIC=3Dm
CONFIG_VIDEO_SR030PC30=3Dm
CONFIG_VIDEO_NOON010PC30=3Dm
CONFIG_VIDEO_M5MOLS=3Dm
CONFIG_SOC_CAMERA=3Dm
CONFIG_SOC_CAMERA_IMX074=3Dm
CONFIG_SOC_CAMERA_MT9M001=3Dm
CONFIG_SOC_CAMERA_MT9M111=3Dm
CONFIG_SOC_CAMERA_MT9T031=3Dm
CONFIG_SOC_CAMERA_MT9T112=3Dm
CONFIG_SOC_CAMERA_MT9V022=3Dm
CONFIG_SOC_CAMERA_RJ54N1=3Dm
CONFIG_SOC_CAMERA_TW9910=3Dm
CONFIG_SOC_CAMERA_PLATFORM=3Dm
CONFIG_SOC_CAMERA_OV2640=3Dm
CONFIG_SOC_CAMERA_OV6650=3Dm
CONFIG_SOC_CAMERA_OV772X=3Dm
CONFIG_SOC_CAMERA_OV9640=3Dm
CONFIG_SOC_CAMERA_OV9740=3Dm
CONFIG_V4L_USB_DRIVERS=3Dy
# CONFIG_USB_VIDEO_CLASS is not set
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=3Dy
CONFIG_USB_GSPCA=3Dm
# CONFIG_USB_M5602 is not set
# CONFIG_USB_STV06XX is not set
# CONFIG_USB_GL860 is not set
# CONFIG_USB_GSPCA_BENQ is not set
# CONFIG_USB_GSPCA_CONEX is not set
# CONFIG_USB_GSPCA_CPIA1 is not set
# CONFIG_USB_GSPCA_ETOMS is not set
# CONFIG_USB_GSPCA_FINEPIX is not set
# CONFIG_USB_GSPCA_JEILINJ is not set
# CONFIG_USB_GSPCA_KINECT is not set
# CONFIG_USB_GSPCA_KONICA is not set
# CONFIG_USB_GSPCA_MARS is not set
# CONFIG_USB_GSPCA_MR97310A is not set
# CONFIG_USB_GSPCA_NW80X is not set
# CONFIG_USB_GSPCA_OV519 is not set
# CONFIG_USB_GSPCA_OV534 is not set
# CONFIG_USB_GSPCA_OV534_9 is not set
# CONFIG_USB_GSPCA_PAC207 is not set
# CONFIG_USB_GSPCA_PAC7302 is not set
# CONFIG_USB_GSPCA_PAC7311 is not set
# CONFIG_USB_GSPCA_SN9C2028 is not set
# CONFIG_USB_GSPCA_SN9C20X is not set
# CONFIG_USB_GSPCA_SONIXB is not set
# CONFIG_USB_GSPCA_SONIXJ is not set
# CONFIG_USB_GSPCA_SPCA500 is not set
# CONFIG_USB_GSPCA_SPCA501 is not set
# CONFIG_USB_GSPCA_SPCA505 is not set
# CONFIG_USB_GSPCA_SPCA506 is not set
# CONFIG_USB_GSPCA_SPCA508 is not set
# CONFIG_USB_GSPCA_SPCA561 is not set
# CONFIG_USB_GSPCA_SPCA1528 is not set
# CONFIG_USB_GSPCA_SQ905 is not set
# CONFIG_USB_GSPCA_SQ905C is not set
# CONFIG_USB_GSPCA_SQ930X is not set
# CONFIG_USB_GSPCA_STK014 is not set
# CONFIG_USB_GSPCA_STV0680 is not set
# CONFIG_USB_GSPCA_SUNPLUS is not set
# CONFIG_USB_GSPCA_T613 is not set
# CONFIG_USB_GSPCA_TV8532 is not set
# CONFIG_USB_GSPCA_VC032X is not set
# CONFIG_USB_GSPCA_VICAM is not set
# CONFIG_USB_GSPCA_XIRLINK_CIT is not set
# CONFIG_USB_GSPCA_ZC3XX is not set
CONFIG_VIDEO_PVRUSB2=3Dm
CONFIG_VIDEO_PVRUSB2_SYSFS=3Dy
CONFIG_VIDEO_PVRUSB2_DVB=3Dy
CONFIG_VIDEO_PVRUSB2_DEBUGIFC=3Dy
CONFIG_VIDEO_HDPVR=3Dm
CONFIG_VIDEO_EM28XX=3Dm
CONFIG_VIDEO_EM28XX_ALSA=3Dm
CONFIG_VIDEO_EM28XX_DVB=3Dm
CONFIG_VIDEO_TLG2300=3Dm
CONFIG_VIDEO_CX231XX=3Dm
CONFIG_VIDEO_CX231XX_RC=3Dy
CONFIG_VIDEO_CX231XX_ALSA=3Dm
CONFIG_VIDEO_CX231XX_DVB=3Dm
CONFIG_VIDEO_USBVISION=3Dm
CONFIG_USB_ET61X251=3Dm
CONFIG_USB_SN9C102=3Dm
CONFIG_USB_PWC=3Dm
# CONFIG_USB_PWC_DEBUG is not set
CONFIG_USB_PWC_INPUT_EVDEV=3Dy
CONFIG_USB_ZR364XX=3Dm
CONFIG_USB_STKWEBCAM=3Dm
CONFIG_USB_S2255=3Dm
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_RADIO_ADAPTERS is not set
CONFIG_DVB_MAX_ADAPTERS=3D8
CONFIG_DVB_DYNAMIC_MINORS=3Dy
CONFIG_DVB_CAPTURE_DRIVERS=3Dy

#
# Supported SAA7146 based PCI Adapters
#
CONFIG_TTPCI_EEPROM=3Dm
CONFIG_DVB_AV7110=3Dm
CONFIG_DVB_AV7110_OSD=3Dy
CONFIG_DVB_BUDGET_CORE=3Dm
CONFIG_DVB_BUDGET=3Dm
CONFIG_DVB_BUDGET_CI=3Dm
CONFIG_DVB_BUDGET_AV=3Dm
CONFIG_DVB_BUDGET_PATCH=3Dm

#
# Supported USB Adapters
#
CONFIG_DVB_USB=3Dm
# CONFIG_DVB_USB_DEBUG is not set
CONFIG_DVB_USB_A800=3Dm
CONFIG_DVB_USB_DIBUSB_MB=3Dm
# CONFIG_DVB_USB_DIBUSB_MB_FAULTY is not set
CONFIG_DVB_USB_DIBUSB_MC=3Dm
CONFIG_DVB_USB_DIB0700=3Dm
CONFIG_DVB_USB_UMT_010=3Dm
CONFIG_DVB_USB_CXUSB=3Dm
CONFIG_DVB_USB_M920X=3Dm
CONFIG_DVB_USB_GL861=3Dm
CONFIG_DVB_USB_AU6610=3Dm
CONFIG_DVB_USB_DIGITV=3Dm
CONFIG_DVB_USB_VP7045=3Dm
CONFIG_DVB_USB_VP702X=3Dm
CONFIG_DVB_USB_GP8PSK=3Dm
CONFIG_DVB_USB_NOVA_T_USB2=3Dm
CONFIG_DVB_USB_TTUSB2=3Dm
CONFIG_DVB_USB_DTT200U=3Dm
CONFIG_DVB_USB_OPERA1=3Dm
CONFIG_DVB_USB_AF9005=3Dm
CONFIG_DVB_USB_AF9005_REMOTE=3Dm
CONFIG_DVB_USB_DW2102=3Dm
CONFIG_DVB_USB_CINERGY_T2=3Dm
CONFIG_DVB_USB_ANYSEE=3Dm
CONFIG_DVB_USB_DTV5100=3Dm
CONFIG_DVB_USB_AF9015=3Dm
CONFIG_DVB_USB_CE6230=3Dm
CONFIG_DVB_USB_FRIIO=3Dm
CONFIG_DVB_USB_EC168=3Dm
CONFIG_DVB_USB_AZ6027=3Dm
CONFIG_DVB_USB_LME2510=3Dm
CONFIG_DVB_USB_TECHNISAT_USB2=3Dm
CONFIG_DVB_TTUSB_BUDGET=3Dm
CONFIG_DVB_TTUSB_DEC=3Dm
CONFIG_SMS_SIANO_MDTV=3Dm

#
# Siano module components
#
CONFIG_SMS_USB_DRV=3Dm

#
# Supported FlexCopII (B2C2) Adapters
#
CONFIG_DVB_B2C2_FLEXCOP=3Dm
CONFIG_DVB_B2C2_FLEXCOP_PCI=3Dm
CONFIG_DVB_B2C2_FLEXCOP_USB=3Dm
# CONFIG_DVB_B2C2_FLEXCOP_DEBUG is not set

#
# Supported BT878 Adapters
#
CONFIG_DVB_BT8XX=3Dm

#
# Supported Pluto2 Adapters
#
CONFIG_DVB_PLUTO2=3Dm

#
# Supported SDMC DM1105 Adapters
#
CONFIG_DVB_DM1105=3Dm

#
# Supported Earthsoft PT1 Adapters
#
CONFIG_DVB_PT1=3Dm

#
# Supported Mantis Adapters
#
CONFIG_MANTIS_CORE=3Dm
CONFIG_DVB_MANTIS=3Dm
CONFIG_DVB_HOPPER=3Dm

#
# Supported nGene Adapters
#
CONFIG_DVB_NGENE=3Dm

#
# Supported DVB Frontends
#
# CONFIG_DVB_FE_CUSTOMISE is not set

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=3Dm
CONFIG_DVB_STB6100=3Dm
CONFIG_DVB_STV090x=3Dm
CONFIG_DVB_STV6110x=3Dm

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=3Dm
CONFIG_DVB_CX24123=3Dm
CONFIG_DVB_MT312=3Dm
CONFIG_DVB_ZL10036=3Dm
CONFIG_DVB_ZL10039=3Dm
CONFIG_DVB_S5H1420=3Dm
CONFIG_DVB_STV0288=3Dm
CONFIG_DVB_STB6000=3Dm
CONFIG_DVB_STV0299=3Dm
CONFIG_DVB_STV6110=3Dm
CONFIG_DVB_STV0900=3Dm
CONFIG_DVB_TDA8083=3Dm
CONFIG_DVB_TDA10086=3Dm
CONFIG_DVB_TDA8261=3Dm
CONFIG_DVB_VES1X93=3Dm
CONFIG_DVB_TUNER_ITD1000=3Dm
CONFIG_DVB_TUNER_CX24113=3Dm
CONFIG_DVB_TDA826X=3Dm
CONFIG_DVB_TUA6100=3Dm
CONFIG_DVB_CX24116=3Dm
CONFIG_DVB_SI21XX=3Dm
CONFIG_DVB_DS3000=3Dm
CONFIG_DVB_MB86A16=3Dm

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=3Dm
CONFIG_DVB_SP887X=3Dm
CONFIG_DVB_CX22700=3Dm
CONFIG_DVB_CX22702=3Dm
CONFIG_DVB_DRXD=3Dm
CONFIG_DVB_L64781=3Dm
CONFIG_DVB_TDA1004X=3Dm
CONFIG_DVB_NXT6000=3Dm
CONFIG_DVB_MT352=3Dm
CONFIG_DVB_ZL10353=3Dm
CONFIG_DVB_DIB3000MB=3Dm
CONFIG_DVB_DIB3000MC=3Dm
CONFIG_DVB_DIB7000M=3Dm
CONFIG_DVB_DIB7000P=3Dm
CONFIG_DVB_TDA10048=3Dm
CONFIG_DVB_AF9013=3Dm
CONFIG_DVB_EC100=3Dm
CONFIG_DVB_STV0367=3Dm
CONFIG_DVB_CXD2820R=3Dm

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=3Dm
CONFIG_DVB_TDA10021=3Dm
CONFIG_DVB_TDA10023=3Dm
CONFIG_DVB_STV0297=3Dm

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=3Dm
CONFIG_DVB_OR51211=3Dm
CONFIG_DVB_OR51132=3Dm
CONFIG_DVB_BCM3510=3Dm
CONFIG_DVB_LGDT330X=3Dm
CONFIG_DVB_LGDT3305=3Dm
CONFIG_DVB_S5H1409=3Dm
CONFIG_DVB_AU8522=3Dm
CONFIG_DVB_S5H1411=3Dm

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=3Dm
CONFIG_DVB_DIB8000=3Dm
CONFIG_DVB_MB86A20S=3Dm

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=3Dm
CONFIG_DVB_TUNER_DIB0070=3Dm
CONFIG_DVB_TUNER_DIB0090=3Dm

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=3Dm
CONFIG_DVB_ISL6405=3Dm
CONFIG_DVB_ISL6421=3Dm
CONFIG_DVB_ISL6423=3Dm
CONFIG_DVB_LGS8GXX=3Dm
CONFIG_DVB_ATBM8830=3Dm
CONFIG_DVB_TDA665x=3Dm
CONFIG_DVB_IX2505V=3Dm

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=3Dy
CONFIG_VGA_ARB_MAX_GPUS=3D16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=3Dy
# CONFIG_FB is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=3Dy
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=3Dy
CONFIG_BACKLIGHT_GENERIC=3Dy
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=3Dy
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=3Dy
CONFIG_FONT_8x16=3Dy
CONFIG_SOUND=3Dy
# CONFIG_SOUND_OSS_CORE is not set
CONFIG_SND=3Dy
CONFIG_SND_TIMER=3Dy
CONFIG_SND_PCM=3Dy
CONFIG_SND_HWDEP=3Dy
CONFIG_SND_RAWMIDI=3Dm
# CONFIG_SND_SEQUENCER is not set
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_HRTIMER=3Dy
CONFIG_SND_DYNAMIC_MINORS=3Dy
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=3Dy
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=3Dy
CONFIG_SND_DMA_SGBUF=3Dy
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_PCI=3Dy
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=3Dy
CONFIG_SND_HDA_HWDEP=3Dy
# CONFIG_SND_HDA_RECONFIG is not set
# CONFIG_SND_HDA_INPUT_BEEP is not set
# CONFIG_SND_HDA_INPUT_JACK is not set
# CONFIG_SND_HDA_PATCH_LOADER is not set
CONFIG_SND_HDA_CODEC_REALTEK=3Dy
CONFIG_SND_HDA_CODEC_ANALOG=3Dy
CONFIG_SND_HDA_CODEC_SIGMATEL=3Dy
CONFIG_SND_HDA_CODEC_VIA=3Dy
CONFIG_SND_HDA_CODEC_HDMI=3Dy
CONFIG_SND_HDA_CODEC_CIRRUS=3Dy
CONFIG_SND_HDA_CODEC_CONEXANT=3Dy
CONFIG_SND_HDA_CODEC_CA0110=3Dy
CONFIG_SND_HDA_CODEC_CMEDIA=3Dy
CONFIG_SND_HDA_CODEC_SI3054=3Dy
CONFIG_SND_HDA_GENERIC=3Dy
# CONFIG_SND_HDA_POWER_SAVE is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_USB=3Dy
CONFIG_SND_USB_AUDIO=3Dm
CONFIG_SND_USB_UA101=3Dm
CONFIG_SND_USB_USX2Y=3Dm
CONFIG_SND_USB_CAIAQ=3Dm
CONFIG_SND_USB_CAIAQ_INPUT=3Dy
CONFIG_SND_USB_US122L=3Dm
CONFIG_SND_USB_6FIRE=3Dm
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=3Dy
CONFIG_HID=3Dy
CONFIG_HIDRAW=3Dy

#
# USB Input Devices
#
CONFIG_USB_HID=3Dy
CONFIG_HID_PID=3Dy
CONFIG_USB_HIDDEV=3Dy

#
# Special HID drivers
#
CONFIG_HID_A4TECH=3Dy
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=3Dy
CONFIG_HID_BELKIN=3Dy
CONFIG_HID_CHERRY=3Dy
CONFIG_HID_CHICONY=3Dy
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=3Dy
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_EZKEY=3Dy
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=3Dy
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=3Dy
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LOGITECH=3Dy
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWII_FF is not set
CONFIG_HID_MICROSOFT=3Dy
CONFIG_HID_MONTEREY=3Dy
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_QUANTA is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_ROCCAT_ARVO is not set
# CONFIG_HID_ROCCAT_KONE is not set
# CONFIG_HID_ROCCAT_KONEPLUS is not set
# CONFIG_HID_ROCCAT_KOVAPLUS is not set
# CONFIG_HID_ROCCAT_PYRA is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_USB_SUPPORT=3Dy
CONFIG_USB_ARCH_HAS_HCD=3Dy
CONFIG_USB_ARCH_HAS_OHCI=3Dy
CONFIG_USB_ARCH_HAS_EHCI=3Dy
CONFIG_USB=3Dy
CONFIG_USB_DEBUG=3Dy
CONFIG_USB_ANNOUNCE_NEW_DEVICES=3Dy

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=3Dy
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=3Dm
# CONFIG_USB_XHCI_HCD_DEBUGGING is not set
CONFIG_USB_EHCI_HCD=3Dm
CONFIG_USB_EHCI_ROOT_HUB_TT=3Dy
CONFIG_USB_EHCI_TT_NEWSCHED=3Dy
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=3Dy
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=3Dy
CONFIG_USB_UHCI_HCD=3Dy
# CONFIG_USB_U132_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=3Dm
CONFIG_USB_PRINTER=3Dm
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=3Dm
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=3Dm
CONFIG_USB_STORAGE_DATAFAB=3Dm
CONFIG_USB_STORAGE_FREECOM=3Dm
CONFIG_USB_STORAGE_ISD200=3Dm
CONFIG_USB_STORAGE_USBAT=3Dm
CONFIG_USB_STORAGE_SDDR09=3Dm
CONFIG_USB_STORAGE_SDDR55=3Dm
CONFIG_USB_STORAGE_JUMPSHOT=3Dm
CONFIG_USB_STORAGE_ALAUDA=3Dm
CONFIG_USB_STORAGE_ONETOUCH=3Dm
CONFIG_USB_STORAGE_KARMA=3Dm
CONFIG_USB_STORAGE_CYPRESS_ATACB=3Dm
CONFIG_USB_STORAGE_ENE_UB6250=3Dm
CONFIG_USB_UAS=3Dm
CONFIG_USB_LIBUSUAL=3Dy

#
# USB Imaging devices
#
CONFIG_USB_MDC800=3Dm
CONFIG_USB_MICROTEK=3Dm

#
# USB port drivers
#
CONFIG_USB_SERIAL=3Dm
CONFIG_USB_EZUSB=3Dy
CONFIG_USB_SERIAL_GENERIC=3Dy
CONFIG_USB_SERIAL_AIRCABLE=3Dm
CONFIG_USB_SERIAL_ARK3116=3Dm
CONFIG_USB_SERIAL_BELKIN=3Dm
CONFIG_USB_SERIAL_CH341=3Dm
CONFIG_USB_SERIAL_WHITEHEAT=3Dm
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=3Dm
CONFIG_USB_SERIAL_CP210X=3Dm
CONFIG_USB_SERIAL_CYPRESS_M8=3Dm
CONFIG_USB_SERIAL_EMPEG=3Dm
CONFIG_USB_SERIAL_FTDI_SIO=3Dm
CONFIG_USB_SERIAL_FUNSOFT=3Dm
CONFIG_USB_SERIAL_VISOR=3Dm
CONFIG_USB_SERIAL_IPAQ=3Dm
CONFIG_USB_SERIAL_IR=3Dm
CONFIG_USB_SERIAL_EDGEPORT=3Dm
CONFIG_USB_SERIAL_EDGEPORT_TI=3Dm
CONFIG_USB_SERIAL_GARMIN=3Dm
CONFIG_USB_SERIAL_IPW=3Dm
CONFIG_USB_SERIAL_IUU=3Dm
CONFIG_USB_SERIAL_KEYSPAN_PDA=3Dm
# CONFIG_USB_SERIAL_KEYSPAN is not set
CONFIG_USB_SERIAL_KLSI=3Dm
CONFIG_USB_SERIAL_KOBIL_SCT=3Dm
CONFIG_USB_SERIAL_MCT_U232=3Dm
CONFIG_USB_SERIAL_MOS7720=3Dm
CONFIG_USB_SERIAL_MOS7840=3Dm
CONFIG_USB_SERIAL_MOTOROLA=3Dm
CONFIG_USB_SERIAL_NAVMAN=3Dm
CONFIG_USB_SERIAL_PL2303=3Dm
CONFIG_USB_SERIAL_OTI6858=3Dm
CONFIG_USB_SERIAL_QCAUX=3Dm
CONFIG_USB_SERIAL_QUALCOMM=3Dm
CONFIG_USB_SERIAL_SPCP8X5=3Dm
CONFIG_USB_SERIAL_HP4X=3Dm
CONFIG_USB_SERIAL_SAFE=3Dm
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
CONFIG_USB_SERIAL_SIEMENS_MPI=3Dm
CONFIG_USB_SERIAL_SIERRAWIRELESS=3Dm
CONFIG_USB_SERIAL_SYMBOL=3Dm
CONFIG_USB_SERIAL_TI=3Dm
CONFIG_USB_SERIAL_CYBERJACK=3Dm
CONFIG_USB_SERIAL_XIRCOM=3Dm
CONFIG_USB_SERIAL_WWAN=3Dm
CONFIG_USB_SERIAL_OPTION=3Dm
CONFIG_USB_SERIAL_OMNINET=3Dm
CONFIG_USB_SERIAL_OPTICON=3Dm
CONFIG_USB_SERIAL_VIVOPAY_SERIAL=3Dm
CONFIG_USB_SERIAL_ZIO=3Dm
CONFIG_USB_SERIAL_SSU100=3Dm
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=3Dm
CONFIG_USB_EMI26=3Dm
CONFIG_USB_ADUTUX=3Dm
CONFIG_USB_SEVSEG=3Dm
CONFIG_USB_RIO500=3Dm
CONFIG_USB_LEGOTOWER=3Dm
CONFIG_USB_LCD=3Dm
CONFIG_USB_LED=3Dm
CONFIG_USB_CYPRESS_CY7C63=3Dm
CONFIG_USB_CYTHERM=3Dm
CONFIG_USB_IDMOUSE=3Dm
CONFIG_USB_FTDI_ELAN=3Dm
CONFIG_USB_APPLEDISPLAY=3Dm
CONFIG_USB_SISUSBVGA=3Dm
CONFIG_USB_SISUSBVGA_CON=3Dy
CONFIG_USB_LD=3Dm
CONFIG_USB_TRANCEVIBRATOR=3Dm
CONFIG_USB_IOWARRIOR=3Dm
CONFIG_USB_TEST=3Dm
CONFIG_USB_ISIGHTFW=3Dm
CONFIG_USB_YUREX=3Dm
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=3Dy
CONFIG_LEDS_CLASS=3Dy

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_DELL_NETBOOKS is not set
CONFIG_LEDS_TRIGGERS=3Dy

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_NFC_DEVICES is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=3Dy
CONFIG_RTC_CLASS=3Dy
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=3Dy
CONFIG_RTC_INTF_PROC=3Dy
CONFIG_RTC_INTF_DEV=3Dy
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=3Dy
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=3Dy
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WMI is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
CONFIG_ACPI_WMI=3Dm
# CONFIG_MSI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_MXM_WMI is not set

#
# Firmware Drivers
#
CONFIG_EDD=3Dy
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=3Dy
CONFIG_EFI_VARS=3Dy
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=3Dy
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_SIGMA is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=3Dy
CONFIG_EXT4_USE_FOR_EXT23=3Dy
CONFIG_EXT4_FS_XATTR=3Dy
CONFIG_EXT4_FS_POSIX_ACL=3Dy
CONFIG_EXT4_FS_SECURITY=3Dy
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=3Dy
CONFIG_FS_MBCACHE=3Dy
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
CONFIG_BTRFS_FS=3Dy
CONFIG_BTRFS_FS_POSIX_ACL=3Dy
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=3Dy
CONFIG_FILE_LOCKING=3Dy
CONFIG_FSNOTIFY=3Dy
CONFIG_DNOTIFY=3Dy
CONFIG_INOTIFY_USER=3Dy
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=3Dy
CONFIG_FUSE_FS=3Dm
CONFIG_CUSE=3Dm
CONFIG_GENERIC_ACL=3Dy

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=3Dm
CONFIG_JOLIET=3Dy
CONFIG_ZISOFS=3Dy
CONFIG_UDF_FS=3Dm
CONFIG_UDF_NLS=3Dy

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=3Dm
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=3Dm
CONFIG_FAT_DEFAULT_CODEPAGE=3D437
CONFIG_FAT_DEFAULT_IOCHARSET=3D"iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=3Dy
CONFIG_PROC_KCORE=3Dy
CONFIG_PROC_SYSCTL=3Dy
CONFIG_PROC_PAGE_MONITOR=3Dy
CONFIG_SYSFS=3Dy
CONFIG_TMPFS=3Dy
CONFIG_TMPFS_POSIX_ACL=3Dy
CONFIG_TMPFS_XATTR=3Dy
CONFIG_HUGETLBFS=3Dy
CONFIG_HUGETLB_PAGE=3Dy
# CONFIG_CONFIGFS_FS is not set
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=3Dy
CONFIG_NFS_FS=3Dm
CONFIG_NFS_V3=3Dy
CONFIG_NFS_V3_ACL=3Dy
CONFIG_NFS_V4=3Dy
CONFIG_NFS_V4_1=3Dy
CONFIG_PNFS_FILE_LAYOUT=3Dm
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=3Dy
CONFIG_NFS_USE_NEW_IDMAPPER=3Dy
# CONFIG_NFSD is not set
CONFIG_LOCKD=3Dm
CONFIG_LOCKD_V4=3Dy
CONFIG_NFS_ACL_SUPPORT=3Dm
CONFIG_NFS_COMMON=3Dy
CONFIG_SUNRPC=3Dm
CONFIG_SUNRPC_GSS=3Dm
CONFIG_RPCSEC_GSS_KRB5=3Dm
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=3Dm
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
CONFIG_CIFS_UPCALL=3Dy
CONFIG_CIFS_XATTR=3Dy
CONFIG_CIFS_POSIX=3Dy
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_ACL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=3Dy
CONFIG_NLS=3Dy
CONFIG_NLS_DEFAULT=3D"utf8"
CONFIG_NLS_CODEPAGE_437=3Dm
CONFIG_NLS_CODEPAGE_737=3Dm
CONFIG_NLS_CODEPAGE_775=3Dm
CONFIG_NLS_CODEPAGE_850=3Dm
CONFIG_NLS_CODEPAGE_852=3Dm
CONFIG_NLS_CODEPAGE_855=3Dm
CONFIG_NLS_CODEPAGE_857=3Dm
CONFIG_NLS_CODEPAGE_860=3Dm
CONFIG_NLS_CODEPAGE_861=3Dm
CONFIG_NLS_CODEPAGE_862=3Dm
CONFIG_NLS_CODEPAGE_863=3Dm
CONFIG_NLS_CODEPAGE_864=3Dm
CONFIG_NLS_CODEPAGE_865=3Dm
CONFIG_NLS_CODEPAGE_866=3Dm
CONFIG_NLS_CODEPAGE_869=3Dm
CONFIG_NLS_CODEPAGE_936=3Dm
CONFIG_NLS_CODEPAGE_950=3Dm
CONFIG_NLS_CODEPAGE_932=3Dm
CONFIG_NLS_CODEPAGE_949=3Dm
CONFIG_NLS_CODEPAGE_874=3Dm
CONFIG_NLS_ISO8859_8=3Dm
CONFIG_NLS_CODEPAGE_1250=3Dm
CONFIG_NLS_CODEPAGE_1251=3Dm
CONFIG_NLS_ASCII=3Dm
CONFIG_NLS_ISO8859_1=3Dm
CONFIG_NLS_ISO8859_2=3Dm
CONFIG_NLS_ISO8859_3=3Dm
CONFIG_NLS_ISO8859_4=3Dm
CONFIG_NLS_ISO8859_5=3Dm
CONFIG_NLS_ISO8859_6=3Dm
CONFIG_NLS_ISO8859_7=3Dm
CONFIG_NLS_ISO8859_9=3Dm
CONFIG_NLS_ISO8859_13=3Dm
CONFIG_NLS_ISO8859_14=3Dm
CONFIG_NLS_ISO8859_15=3Dm
CONFIG_NLS_KOI8_R=3Dm
CONFIG_NLS_KOI8_U=3Dm
CONFIG_NLS_UTF8=3Dm

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=3Dy
CONFIG_PRINTK_TIME=3Dy
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=3D4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=3Dy
CONFIG_FRAME_WARN=3D2048
CONFIG_MAGIC_SYSRQ=3Dy
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
# CONFIG_DEBUG_KERNEL is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_DEBUG_BUGVERBOSE=3Dy
CONFIG_DEBUG_MEMORY_INIT=3Dy
CONFIG_ARCH_WANT_FRAME_POINTERS=3Dy
# CONFIG_FRAME_POINTER is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=3D60
CONFIG_RCU_CPU_STALL_VERBOSE=3Dy
CONFIG_SYSCTL_SYSCALL_CHECK=3Dy
CONFIG_USER_STACKTRACE_SUPPORT=3Dy
CONFIG_HAVE_FUNCTION_TRACER=3Dy
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=3Dy
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=3Dy
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=3Dy
CONFIG_HAVE_DYNAMIC_FTRACE=3Dy
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=3Dy
CONFIG_HAVE_SYSCALL_TRACEPOINTS=3Dy
CONFIG_HAVE_C_RECORDMCOUNT=3Dy
CONFIG_TRACING_SUPPORT=3Dy
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=3Dy
CONFIG_HAVE_ARCH_KMEMCHECK=3Dy
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=3Dy
CONFIG_EARLY_PRINTK=3Dy
CONFIG_EARLY_PRINTK_DBGP=3Dy
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=3Dy
CONFIG_IO_DELAY_TYPE_0X80=3D0
CONFIG_IO_DELAY_TYPE_0XED=3D1
CONFIG_IO_DELAY_TYPE_UDELAY=3D2
CONFIG_IO_DELAY_TYPE_NONE=3D3
CONFIG_IO_DELAY_0X80=3Dy
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=3D0
CONFIG_OPTIMIZE_INLINING=3Dy

#
# Security options
#
CONFIG_KEYS=3Dy
CONFIG_KEYS_DEBUG_PROC_KEYS=3Dy
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
# CONFIG_INTEL_TXT is not set
CONFIG_DEFAULT_SECURITY_DAC=3Dy
CONFIG_DEFAULT_SECURITY=3D""
CONFIG_CRYPTO=3Dy

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=3Dy
CONFIG_CRYPTO_ALGAPI2=3Dy
CONFIG_CRYPTO_AEAD=3Dy
CONFIG_CRYPTO_AEAD2=3Dy
CONFIG_CRYPTO_BLKCIPHER=3Dy
CONFIG_CRYPTO_BLKCIPHER2=3Dy
CONFIG_CRYPTO_HASH=3Dy
CONFIG_CRYPTO_HASH2=3Dy
CONFIG_CRYPTO_RNG=3Dm
CONFIG_CRYPTO_RNG2=3Dy
CONFIG_CRYPTO_PCOMP=3Dm
CONFIG_CRYPTO_PCOMP2=3Dy
CONFIG_CRYPTO_MANAGER=3Dy
CONFIG_CRYPTO_MANAGER2=3Dy
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=3Dy
CONFIG_CRYPTO_GF128MUL=3Dm
CONFIG_CRYPTO_NULL=3Dm
CONFIG_CRYPTO_PCRYPT=3Dm
CONFIG_CRYPTO_WORKQUEUE=3Dy
CONFIG_CRYPTO_CRYPTD=3Dm
CONFIG_CRYPTO_AUTHENC=3Dy
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=3Dm
CONFIG_CRYPTO_GCM=3Dm
CONFIG_CRYPTO_SEQIV=3Dm

#
# Block modes
#
CONFIG_CRYPTO_CBC=3Dy
CONFIG_CRYPTO_CTR=3Dm
CONFIG_CRYPTO_CTS=3Dm
CONFIG_CRYPTO_ECB=3Dm
CONFIG_CRYPTO_LRW=3Dm
CONFIG_CRYPTO_PCBC=3Dm
CONFIG_CRYPTO_XTS=3Dm

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=3Dy
CONFIG_CRYPTO_XCBC=3Dm
CONFIG_CRYPTO_VMAC=3Dm

#
# Digest
#
CONFIG_CRYPTO_CRC32C=3Dy
CONFIG_CRYPTO_CRC32C_INTEL=3Dm
CONFIG_CRYPTO_GHASH=3Dm
CONFIG_CRYPTO_MD4=3Dm
CONFIG_CRYPTO_MD5=3Dy
CONFIG_CRYPTO_MICHAEL_MIC=3Dm
CONFIG_CRYPTO_RMD128=3Dm
CONFIG_CRYPTO_RMD160=3Dm
CONFIG_CRYPTO_RMD256=3Dm
CONFIG_CRYPTO_RMD320=3Dm
CONFIG_CRYPTO_SHA1=3Dy
CONFIG_CRYPTO_SHA256=3Dm
CONFIG_CRYPTO_SHA512=3Dm
CONFIG_CRYPTO_TGR192=3Dm
CONFIG_CRYPTO_WP512=3Dm
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=3Dm

#
# Ciphers
#
CONFIG_CRYPTO_AES=3Dm
CONFIG_CRYPTO_AES_X86_64=3Dm
CONFIG_CRYPTO_AES_NI_INTEL=3Dm
CONFIG_CRYPTO_ANUBIS=3Dm
CONFIG_CRYPTO_ARC4=3Dm
CONFIG_CRYPTO_BLOWFISH=3Dm
CONFIG_CRYPTO_CAMELLIA=3Dm
CONFIG_CRYPTO_CAST5=3Dm
CONFIG_CRYPTO_CAST6=3Dm
CONFIG_CRYPTO_DES=3Dy
CONFIG_CRYPTO_FCRYPT=3Dm
CONFIG_CRYPTO_KHAZAD=3Dm
CONFIG_CRYPTO_SALSA20=3Dm
CONFIG_CRYPTO_SALSA20_X86_64=3Dm
CONFIG_CRYPTO_SEED=3Dm
CONFIG_CRYPTO_SERPENT=3Dm
CONFIG_CRYPTO_TEA=3Dm
CONFIG_CRYPTO_TWOFISH=3Dm
CONFIG_CRYPTO_TWOFISH_COMMON=3Dm
CONFIG_CRYPTO_TWOFISH_X86_64=3Dm

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=3Dm
CONFIG_CRYPTO_ZLIB=3Dm
CONFIG_CRYPTO_LZO=3Dm

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=3Dm
CONFIG_CRYPTO_USER_API=3Dm
CONFIG_CRYPTO_USER_API_HASH=3Dm
CONFIG_CRYPTO_USER_API_SKCIPHER=3Dm
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=3Dy
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=3Dy
CONFIG_GENERIC_FIND_FIRST_BIT=3Dy
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=3Dy
CONFIG_CRC_T10DIF=3Dy
CONFIG_CRC_ITU_T=3Dm
CONFIG_CRC32=3Dy
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=3Dy
CONFIG_ZLIB_INFLATE=3Dy
CONFIG_ZLIB_DEFLATE=3Dy
CONFIG_LZO_COMPRESS=3Dy
CONFIG_LZO_DECOMPRESS=3Dy
CONFIG_XZ_DEC=3Dy
CONFIG_XZ_DEC_X86=3Dy
CONFIG_XZ_DEC_POWERPC=3Dy
CONFIG_XZ_DEC_IA64=3Dy
CONFIG_XZ_DEC_ARM=3Dy
CONFIG_XZ_DEC_ARMTHUMB=3Dy
CONFIG_XZ_DEC_SPARC=3Dy
CONFIG_XZ_DEC_BCJ=3Dy
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=3Dy
CONFIG_DECOMPRESS_BZIP2=3Dy
CONFIG_DECOMPRESS_LZMA=3Dy
CONFIG_DECOMPRESS_XZ=3Dy
CONFIG_DECOMPRESS_LZO=3Dy
CONFIG_HAS_IOMEM=3Dy
CONFIG_HAS_IOPORT=3Dy
CONFIG_HAS_DMA=3Dy
CONFIG_CHECK_SIGNATURE=3Dy
CONFIG_CPU_RMAP=3Dy
CONFIG_NLATTR=3Dy
# CONFIG_AVERAGE is not set

--------------070507000406000907090407--

--------------enigF9A8F47632958CE2EE5287E7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEUEARECAAYFAk5OYMwACgkQ4q3E2oMjYtWMdACYm58UygpDJVJRA8BxpxNjFd8o
nACgzPy+oI/xgcpd2LRbFpgQAEUME44=
=t3Kb
-----END PGP SIGNATURE-----

--------------enigF9A8F47632958CE2EE5287E7--
