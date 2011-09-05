Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab1IEB6H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 21:58:07 -0400
Received: from outgoing-mail.its.caltech.edu ([131.215.239.19]:49032 "EHLO
	outgoing-mail.its.caltech.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751099Ab1IEB6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 21:58:00 -0400
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Sep 2011 21:58:00 EDT
X-Spam-Scanned: at Caltech-IMSS on earth-doxen by amavisd-new
From: Jameson Graef Rollins <jrollins@finestructure.net>
To: Tejun Heo <tj@kernel.org>, Jonathan Nieder <jrnieder@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Amit Shah <amit.shah@redhat.com>,
        David Zeuthen <zeuthen@gmail.com>,
        Martin Pitt <martin.pitt@ubuntu.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        Jean Schurger <jean@schurger.org>,
        Jan =?utf-8?Q?L=C3=BCbbe?= <jluebbe@debian.org>,
        Matthijs Kooijman <matthijs@stdin.nl>,
        Nacho Barrientos Arias <nacho@debian.org>
Subject: Re: [regression] CD-ROM polling blocks suspend on some machines (Re: [PATCH 1/2] cdrom: always check_disk_change() on open)
In-Reply-To: <20110904024244.GB3083@htj.dyndns.org>
References: <20110406121920.GC4142@mtj.dyndns.org> <20110903221456.GA2877@elie> <20110904024244.GB3083@htj.dyndns.org>
User-Agent: Notmuch/0.7-41-g7dce23e (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Sun, 04 Sep 2011 18:49:38 -0700
Message-ID: <87y5y37o7h.fsf@servo.factory.finestructure.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==-=-=
Content-Type: multipart/mixed; boundary="=-=-="

--=-=-=

On Sun, 4 Sep 2011 11:42:44 +0900, Tejun Heo <tj@kernel.org> wrote:
> Can you please build vanilla kernel with CONFIG_FRAME_POINTER turned
> on, reproduce the problem and attach full dmesg output?

Hi, Tejun.  I recompiled the kernel from the Debian linux-source-3.0.0
(following the instructions here [0]) with the following config:

CONFIG_FRAME_POINTER=y

I then rebooted into this new kernel and triggered the bug.  Attached is
the dmesg output from right before and right after the bug was
triggered.  The bug was triggered by ejecting my laptop from it's dock,
and then trying to put it to sleep (which of course it failed to do).

Please let me know if there's anything else I can do, or any other
information I can provide.  Thanks so much for the help.

jamie.

[0] http://kernel-handbook.alioth.debian.org/ch-common-tasks.html#s-common-building


--=-=-=
Content-Disposition: inline; filename=dmesg.before
Content-Transfer-Encoding: quoted-printable
Content-Description: dmesg output before bug triggered

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.0.0 (3.0.0) (jrollins@servo) (gcc version 4.=
6.1 (Debian 4.6.1-4) ) #2 SMP Sun Sep 4 15:59:16 PDT 2011
[    0.000000] Command line: BOOT_IMAGE=3D/vmlinuz-3.0.0 root=3D/dev/mapper=
/servo-root ro vga=3D788
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
[    0.000000]  BIOS-e820: 000000000009e800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bb27c000 (usable)
[    0.000000]  BIOS-e820: 00000000bb27c000 - 00000000bb282000 (reserved)
[    0.000000]  BIOS-e820: 00000000bb282000 - 00000000bb35f000 (usable)
[    0.000000]  BIOS-e820: 00000000bb35f000 - 00000000bb371000 (reserved)
[    0.000000]  BIOS-e820: 00000000bb371000 - 00000000bb3f2000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bb3f2000 - 00000000bb40f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bb40f000 - 00000000bb46f000 (usable)
[    0.000000]  BIOS-e820: 00000000bb46f000 - 00000000bb668000 (reserved)
[    0.000000]  BIOS-e820: 00000000bb668000 - 00000000bb6e8000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bb6e8000 - 00000000bb70f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bb70f000 - 00000000bb717000 (usable)
[    0.000000]  BIOS-e820: 00000000bb717000 - 00000000bb71f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bb71f000 - 00000000bb76c000 (usable)
[    0.000000]  BIOS-e820: 00000000bb76c000 - 00000000bb778000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bb778000 - 00000000bb77b000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bb77b000 - 00000000bb78b000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bb78b000 - 00000000bb78c000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bb78c000 - 00000000bb79f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bb79f000 - 00000000bb7ff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bb7ff000 - 00000000bb800000 (usable)
[    0.000000]  BIOS-e820: 00000000bb800000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000feaff000 - 00000000feb00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 00000001fc000000 (usable)
[    0.000000]  BIOS-e820: 0000000200000000 - 000000023c000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: LENOVO 3626WVF/3626WVF, BIOS 6QET62WW (1.32 ) 12/17/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usab=
le) =3D=3D> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usab=
le)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn =3D 0x23c000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 disabled
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 100000000 mask F00000000 write-back
[    0.000000]   4 base 200000000 mask FC0000000 write-back
[    0.000000]   5 base 23C000000 mask FFC000000 uncachable
[    0.000000]   6 base 0BC000000 mask FFC000000 uncachable
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] e820 update range: 00000000bc000000 - 0000000100000000 (usab=
le) =3D=3D> (reserved)
[    0.000000] last_pfn =3D 0xbb800 max_arch_pfn =3D 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f6910] f6910
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000bb800000
[    0.000000]  0000000000 - 00bb800000 page 2M
[    0.000000] kernel direct mapping tables up to bb800000 @ bb768000-bb76c=
000
[    0.000000] init_memory_mapping: 0000000100000000-000000023c000000
[    0.000000]  0100000000 - 023c000000 page 2M
[    0.000000] kernel direct mapping tables up to 23c000000 @ 23bff6000-23c=
000000
[    0.000000] RAMDISK: 30b3b000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f68e0 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000bb7f08bc 00094 (v01 LENOVO TP-6Q    00001=
320  LTP 00000000)
[    0.000000] ACPI: FACP 00000000bb7f0a00 000F4 (v04 LENOVO TP-6Q    00001=
320 LNVO 00000001)
[    0.000000] ACPI: DSDT 00000000bb7f0d6b 0DDDA (v01 LENOVO TP-6Q    00001=
320 MSFT 03000001)
[    0.000000] ACPI: FACS 00000000bb6e7000 00040
[    0.000000] ACPI: SSDT 00000000bb7f0bb4 001B7 (v01 LENOVO TP-6Q    00001=
320 MSFT 03000001)
[    0.000000] ACPI: ECDT 00000000bb7feb45 00052 (v01 LENOVO TP-6Q    00001=
320 LNVO 00000001)
[    0.000000] ACPI: APIC 00000000bb7feb97 00084 (v01 LENOVO TP-6Q    00001=
320 LNVO 00000001)
[    0.000000] ACPI: MCFG 00000000bb7fec53 0003C (v01 LENOVO TP-6Q    00001=
320 LNVO 00000001)
[    0.000000] ACPI: HPET 00000000bb7fec8f 00038 (v01 LENOVO TP-6Q    00001=
320 LNVO 00000001)
[    0.000000] ACPI: ASF! 00000000bb7fedbe 000A4 (v16 LENOVO TP-6Q    00001=
320 PTL  00000001)
[    0.000000] ACPI: SLIC 00000000bb7fee62 00176 (v01 LENOVO TP-6Q    00001=
320  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000bb7fefd8 00028 (v01 LENOVO TP-6Q    00001=
320  LTP 00000001)
[    0.000000] ACPI: SSDT 00000000bb6e590a 0085B (v01 LENOVO TP-6Q    00001=
320 INTL 20050513)
[    0.000000] ACPI: TCPA 00000000bb78b000 00032 (v02    PTL  CRESTLN 06040=
000      00005A52)
[    0.000000] ACPI: SSDT 00000000bb77a000 009F1 (v01  PmRef    CpuPm 00003=
000 INTL 20050513)
[    0.000000] ACPI: SSDT 00000000bb779000 00259 (v01  PmRef  Cpu0Tst 00003=
000 INTL 20050513)
[    0.000000] ACPI: SSDT 00000000bb778000 0049F (v01  PmRef    ApTst 00003=
000 INTL 20050513)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000023c000000
[    0.000000] Initmem setup node 0 0000000000000000-000000023c000000
[    0.000000]   NODE_DATA [000000023bffb000 - 000000023bffffff]
[    0.000000]  [ffffea0000000000-ffffea0007dfffff] PMD -> [ffff88023360000=
0-ffff88023a5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0023c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[9] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bb27c
[    0.000000]     0: 0x000bb282 -> 0x000bb35f
[    0.000000]     0: 0x000bb40f -> 0x000bb46f
[    0.000000]     0: 0x000bb70f -> 0x000bb717
[    0.000000]     0: 0x000bb71f -> 0x000bb76c
[    0.000000]     0: 0x000bb7ff -> 0x000bb800
[    0.000000]     0: 0x00100000 -> 0x001fc000
[    0.000000]     0: 0x00200000 -> 0x0023c000
[    0.000000] On node 0 totalpages: 2044829
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3921 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 748615 pages, LIFO batch:31
[    0.000000]   Normal zone: 17696 pages used for memmap
[    0.000000]   Normal zone: 1260256 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000=
9f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 00000000001=
00000
[    0.000000] PM: Registered nosave memory: 00000000bb27c000 - 00000000bb2=
82000
[    0.000000] PM: Registered nosave memory: 00000000bb35f000 - 00000000bb3=
71000
[    0.000000] PM: Registered nosave memory: 00000000bb371000 - 00000000bb3=
f2000
[    0.000000] PM: Registered nosave memory: 00000000bb3f2000 - 00000000bb4=
0f000
[    0.000000] PM: Registered nosave memory: 00000000bb46f000 - 00000000bb6=
68000
[    0.000000] PM: Registered nosave memory: 00000000bb668000 - 00000000bb6=
e8000
[    0.000000] PM: Registered nosave memory: 00000000bb6e8000 - 00000000bb7=
0f000
[    0.000000] PM: Registered nosave memory: 00000000bb717000 - 00000000bb7=
1f000
[    0.000000] PM: Registered nosave memory: 00000000bb76c000 - 00000000bb7=
78000
[    0.000000] PM: Registered nosave memory: 00000000bb778000 - 00000000bb7=
7b000
[    0.000000] PM: Registered nosave memory: 00000000bb77b000 - 00000000bb7=
8b000
[    0.000000] PM: Registered nosave memory: 00000000bb78b000 - 00000000bb7=
8c000
[    0.000000] PM: Registered nosave memory: 00000000bb78c000 - 00000000bb7=
9f000
[    0.000000] PM: Registered nosave memory: 00000000bb79f000 - 00000000bb7=
ff000
[    0.000000] PM: Registered nosave memory: 00000000bb800000 - 00000000c00=
00000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e00=
00000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f00=
00000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fea=
ff000
[    0.000000] PM: Registered nosave memory: 00000000feaff000 - 00000000feb=
00000
[    0.000000] PM: Registered nosave memory: 00000000feb00000 - 00000000fec=
00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec=
10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed=
00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed=
1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed=
90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000fee=
00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee=
01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff0=
00000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 00000001000=
00000
[    0.000000] PM: Registered nosave memory: 00000001fc000000 - 00000002000=
00000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000=
:20000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88023bc00000 s78976 r8192=
 d23424 u524288
[    0.000000] pcpu-alloc: s78976 r8192 d23424 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 2012792
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=3D/vmlinuz-3.0.0 root=3D/dev=
/mapper/servo-root ro vga=3D788
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 7870152k/9371648k available (3361k kernel code, 1192=
332k absent, 309164k reserved, 3334k data, 564k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:33024 nr_irqs:712 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 2659.700 MHz processor.
[    0.000003] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 5319.40 BogoMIPS (lpj=3D10638800)
[    0.000008] pid_max: default: 32768 minimum: 301
[    0.000062] Security Framework initialized
[    0.000066] SELinux:  Disabled at boot.
[    0.000590] Dentry cache hash table entries: 1048576 (order: 11, 8388608=
 bytes)
[    0.002580] Inode-cache hash table entries: 524288 (order: 10, 4194304 b=
ytes)
[    0.003428] Mount-cache hash table entries: 256
[    0.003542] Initializing cgroup subsys cpuacct
[    0.003547] Initializing cgroup subsys memory
[    0.003557] Initializing cgroup subsys devices
[    0.003560] Initializing cgroup subsys freezer
[    0.003564] Initializing cgroup subsys net_cls
[    0.003566] Initializing cgroup subsys blkio
[    0.003599] CPU: Physical Processor ID: 0
[    0.003601] CPU: Processor Core ID: 0
[    0.003607] mce: CPU supports 9 MCE banks
[    0.003618] CPU0: Thermal monitoring enabled (TM1)
[    0.003626] using mwait in idle threads.
[    0.003929] ACPI: Core revision 20110413
[    0.020140] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.059826] CPU0: Intel(R) Core(TM) i7 CPU       M 620  @ 2.67GHz steppi=
ng 05
[    0.165388] Performance Events: PEBS fmt1+, Westmere events, Intel PMU d=
river.
[    0.165396] ... version:                3
[    0.165398] ... bit width:              48
[    0.165400] ... generic registers:      4
[    0.165402] ... value mask:             0000ffffffffffff
[    0.165404] ... max period:             000000007fffffff
[    0.165406] ... fixed-purpose events:   3
[    0.165408] ... event mask:             000000070000000f
[    0.165566] NMI watchdog enabled, takes one hw-pmu counter.
[    0.165676] Booting Node   0, Processors  #1
[    0.165679] smpboot cpu 1: start_ip =3D 99000
[    0.273472] NMI watchdog enabled, takes one hw-pmu counter.
[    0.273604]  #2
[    0.273606] smpboot cpu 2: start_ip =3D 99000
[    0.381571] NMI watchdog enabled, takes one hw-pmu counter.
[    0.381703]  #3 Ok.
[    0.381705] smpboot cpu 3: start_ip =3D 99000
[    0.489568] NMI watchdog enabled, takes one hw-pmu counter.
[    0.489610] Brought up 4 CPUs
[    0.489613] Total of 4 processors activated (21279.02 BogoMIPS).
[    0.491832] devtmpfs: initialized
[    0.494891] PM: Registering ACPI NVS region at bb371000 (528384 bytes)
[    0.494914] PM: Registering ACPI NVS region at bb668000 (524288 bytes)
[    0.494935] PM: Registering ACPI NVS region at bb76c000 (49152 bytes)
[    0.494939] PM: Registering ACPI NVS region at bb77b000 (65536 bytes)
[    0.494943] PM: Registering ACPI NVS region at bb78c000 (77824 bytes)
[    0.495066] print_constraints: dummy:=20
[    0.495119] NET: Registered protocol family 16
[    0.495202] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    0.495206] ACPI: bus type pci registered
[    0.495266] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000=
-0xefffffff] (base 0xe0000000)
[    0.495271] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.535395] PCI: Using configuration type 1 for base access
[    0.535916] bio: create slab <bio-0> at 0
[    0.537381] ACPI: EC: EC description table is found, configuring boot EC
[    0.542692] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.629766] ACPI: SSDT 00000000bb71a598 004F3 (v01  PmRef  Cpu0Ist 00003=
000 INTL 20050513)
[    0.630099] ACPI: Dynamic OEM Table Load:
[    0.630103] ACPI: SSDT           (null) 004F3 (v01  PmRef  Cpu0Ist 00003=
000 INTL 20050513)
[    0.630244] ACPI: SSDT 00000000bb718718 006B2 (v01  PmRef  Cpu0Cst 00003=
001 INTL 20050513)
[    0.630595] ACPI: Dynamic OEM Table Load:
[    0.630598] ACPI: SSDT           (null) 006B2 (v01  PmRef  Cpu0Cst 00003=
001 INTL 20050513)
[    0.657783] ACPI: SSDT 00000000bb719a98 00303 (v01  PmRef    ApIst 00003=
000 INTL 20050513)
[    0.658175] ACPI: Dynamic OEM Table Load:
[    0.658178] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003=
000 INTL 20050513)
[    0.669624] ACPI: SSDT 00000000bb717d98 00119 (v01  PmRef    ApCst 00003=
000 INTL 20050513)
[    0.669969] ACPI: Dynamic OEM Table Load:
[    0.669972] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003=
000 INTL 20050513)
[    0.683143] ACPI: Interpreter enabled
[    0.683148] ACPI: (supports S0 S3 S4 S5)
[    0.683169] ACPI: Using IOAPIC for interrupt routing
[    0.686748] ACPI: Power Resource [PUBS] (on)
[    0.690008] ACPI: EC: GPE =3D 0x11, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.691190] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.691194] HEST: Table not found.
[    0.691197] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.691213] ACPI: PCI Root Bridge [UNCR] (domain 0000 [bus ff])
[    0.691255] pci 0000:ff:00.0: [8086:2c62] type 0 class 0x000600
[    0.691274] pci 0000:ff:00.1: [8086:2d01] type 0 class 0x000600
[    0.691290] pci 0000:ff:02.0: [8086:2d10] type 0 class 0x000600
[    0.691304] pci 0000:ff:02.1: [8086:2d11] type 0 class 0x000600
[    0.691317] pci 0000:ff:02.2: [8086:2d12] type 0 class 0x000600
[    0.691331] pci 0000:ff:02.3: [8086:2d13] type 0 class 0x000600
[    0.691359]  pci0000:ff: Requesting ACPI _OSC control (0x1d)
[    0.691364]  pci0000:ff: ACPI _OSC request failed (AE_NOT_FOUND), return=
ed control mask: 0x1d
[    0.691367] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.691659] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.691706] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.691710] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.691713] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x00=
0bffff]
[    0.691716] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x00=
0d3fff]
[    0.691719] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x00=
0d7fff]
[    0.691723] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x00=
0dbfff]
[    0.691726] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfe=
bfffff]
[    0.691737] pci 0000:00:00.0: [8086:0044] type 0 class 0x000600
[    0.691750] DMAR: BIOS has allocated no shadow GTT; disabling IOMMU for =
graphics
[    0.691768] pci 0000:00:02.0: [8086:0046] type 0 class 0x000300
[    0.691777] pci 0000:00:02.0: reg 10: [mem 0xf2000000-0xf23fffff 64bit]
[    0.691783] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit p=
ref]
[    0.691787] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.691843] pci 0000:00:16.0: [8086:3b64] type 0 class 0x000780
[    0.691870] pci 0000:00:16.0: reg 10: [mem 0xf2727800-0xf272780f 64bit]
[    0.691945] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.691950] pci 0000:00:16.0: PME# disabled
[    0.691980] pci 0000:00:16.3: [8086:3b67] type 0 class 0x000700
[    0.692002] pci 0000:00:16.3: reg 10: [io  0x1808-0x180f]
[    0.692013] pci 0000:00:16.3: reg 14: [mem 0xf2524000-0xf2524fff]
[    0.692118] pci 0000:00:19.0: [8086:10ea] type 0 class 0x000200
[    0.692142] pci 0000:00:19.0: reg 10: [mem 0xf2500000-0xf251ffff]
[    0.692153] pci 0000:00:19.0: reg 14: [mem 0xf2525000-0xf2525fff]
[    0.692164] pci 0000:00:19.0: reg 18: [io  0x1820-0x183f]
[    0.692233] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.692238] pci 0000:00:19.0: PME# disabled
[    0.692267] pci 0000:00:1a.0: [8086:3b3c] type 0 class 0x000c03
[    0.692292] pci 0000:00:1a.0: reg 10: [mem 0xf2728000-0xf27283ff]
[    0.692378] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.692383] pci 0000:00:1a.0: PME# disabled
[    0.692412] pci 0000:00:1b.0: [8086:3b56] type 0 class 0x000403
[    0.692432] pci 0000:00:1b.0: reg 10: [mem 0xf2520000-0xf2523fff 64bit]
[    0.692508] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.692513] pci 0000:00:1b.0: PME# disabled
[    0.692539] pci 0000:00:1c.0: [8086:3b42] type 1 class 0x000604
[    0.692613] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.692618] pci 0000:00:1c.0: PME# disabled
[    0.692647] pci 0000:00:1c.3: [8086:3b48] type 1 class 0x000604
[    0.692725] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.692729] pci 0000:00:1c.3: PME# disabled
[    0.692757] pci 0000:00:1c.4: [8086:3b4a] type 1 class 0x000604
[    0.692833] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.692837] pci 0000:00:1c.4: PME# disabled
[    0.692873] pci 0000:00:1d.0: [8086:3b34] type 0 class 0x000c03
[    0.692897] pci 0000:00:1d.0: reg 10: [mem 0xf2728400-0xf27287ff]
[    0.692982] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.692986] pci 0000:00:1d.0: PME# disabled
[    0.693010] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.693084] pci 0000:00:1f.0: [8086:3b07] type 0 class 0x000601
[    0.693200] pci 0000:00:1f.2: [8086:3b2f] type 0 class 0x000106
[    0.693226] pci 0000:00:1f.2: reg 10: [io  0x1860-0x1867]
[    0.693237] pci 0000:00:1f.2: reg 14: [io  0x1814-0x1817]
[    0.693247] pci 0000:00:1f.2: reg 18: [io  0x1818-0x181f]
[    0.693257] pci 0000:00:1f.2: reg 1c: [io  0x1810-0x1813]
[    0.693268] pci 0000:00:1f.2: reg 20: [io  0x1840-0x185f]
[    0.693279] pci 0000:00:1f.2: reg 24: [mem 0xf2727000-0xf27277ff]
[    0.693325] pci 0000:00:1f.2: PME# supported from D3hot
[    0.693329] pci 0000:00:1f.2: PME# disabled
[    0.693351] pci 0000:00:1f.3: [8086:3b30] type 0 class 0x000c05
[    0.693371] pci 0000:00:1f.3: reg 10: [mem 0xf2728800-0xf27288ff 64bit]
[    0.693401] pci 0000:00:1f.3: reg 20: [io  0x1880-0x189f]
[    0.693451] pci 0000:00:1f.6: [8086:3b32] type 0 class 0x001180
[    0.693479] pci 0000:00:1f.6: reg 10: [mem 0xf2526000-0xf2526fff 64bit]
[    0.693612] pci 0000:00:1c.0: PCI bridge to [bus 0d-0d]
[    0.693619] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disab=
led)
[    0.693623] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff=
] (disabled)
[    0.693630] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff=
 pref] (disabled)
[    0.693685] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.693691] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.693695] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.693702] pci 0000:00:1c.3:   bridge window [mem 0xf2800000-0xf28fffff=
 64bit pref]
[    0.693786] pci 0000:02:00.0: [8086:0084] type 0 class 0x000280
[    0.693824] pci 0000:02:00.0: reg 10: [mem 0xf2400000-0xf2401fff 64bit]
[    0.693971] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.693978] pci 0000:02:00.0: PME# disabled
[    0.694030] pci 0000:00:1c.4: PCI bridge to [bus 02-02]
[    0.694036] pci 0000:00:1c.4:   bridge window [io  0xf000-0x0000] (disab=
led)
[    0.694040] pci 0000:00:1c.4:   bridge window [mem 0xf2400000-0xf24fffff]
[    0.694047] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff=
 pref] (disabled)
[    0.694118] pci 0000:00:1e.0: PCI bridge to [bus 0e-0e] (subtractive dec=
ode)
[    0.694123] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disab=
led)
[    0.694128] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff=
] (disabled)
[    0.694135] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff=
 pref] (disabled)
[    0.694137] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtr=
active decode)
[    0.694139] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtr=
active decode)
[    0.694141] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff=
] (subtractive decode)
[    0.694143] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff=
] (subtractive decode)
[    0.694145] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff=
] (subtractive decode)
[    0.694147] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff=
] (subtractive decode)
[    0.694149] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff=
] (subtractive decode)
[    0.694174] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.694313] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.694349] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.694384] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP5._PRT]
[    0.694538]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.694740]  pci0000:00: ACPI _OSC request failed (AE_SUPPORT), returned=
 control mask: 0x0d
[    0.694744] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.697621] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.697691] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.697745] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11) *0,=
 disabled.
[    0.697812] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.697879] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.697932] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0,=
 disabled.
[    0.697987] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0,=
 disabled.
[    0.698054] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.698144] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.698153] vgaarb: loaded
[    0.698155] vgaarb: bridge control possible 0000:00:02.0
[    0.698186] PCI: Using ACPI for IRQ routing
[    0.707894] PCI: pci_cache_line_size set to 64 bytes
[    0.707969] reserve RAM buffer: 000000000009e800 - 000000000009ffff=20
[    0.707971] reserve RAM buffer: 00000000bb27c000 - 00000000bbffffff=20
[    0.707977] reserve RAM buffer: 00000000bb35f000 - 00000000bbffffff=20
[    0.707982] reserve RAM buffer: 00000000bb46f000 - 00000000bbffffff=20
[    0.707986] reserve RAM buffer: 00000000bb717000 - 00000000bbffffff=20
[    0.707990] reserve RAM buffer: 00000000bb76c000 - 00000000bbffffff=20
[    0.707993] reserve RAM buffer: 00000000bb800000 - 00000000bbffffff=20
[    0.708089] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.708096] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.710119] Switching to clocksource hpet
[    0.711410] pnp: PnP ACPI init
[    0.711425] ACPI: bus type pnp registered
[    0.712019] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    0.712021] pnp 00:00: [mem 0x000c0000-0x000c3fff]
[    0.712023] pnp 00:00: [mem 0x000c4000-0x000c7fff]
[    0.712025] pnp 00:00: [mem 0x000c8000-0x000cbfff]
[    0.712026] pnp 00:00: [mem 0x000cc000-0x000cffff]
[    0.712028] pnp 00:00: [mem 0x000d0000-0x000cffff disabled]
[    0.712030] pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
[    0.712031] pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
[    0.712033] pnp 00:00: [mem 0x000dc000-0x000dffff]
[    0.712034] pnp 00:00: [mem 0x000e0000-0x000e3fff]
[    0.712036] pnp 00:00: [mem 0x000e4000-0x000e7fff]
[    0.712037] pnp 00:00: [mem 0x000e8000-0x000ebfff]
[    0.712039] pnp 00:00: [mem 0x000ec000-0x000effff]
[    0.712040] pnp 00:00: [mem 0x000f0000-0x000fffff]
[    0.712042] pnp 00:00: [mem 0x00100000-0xbfffffff]
[    0.712043] pnp 00:00: [mem 0xfec00000-0xfed3ffff]
[    0.712045] pnp 00:00: [mem 0xfed4c000-0xffffffff]
[    0.712090] system 00:00: [mem 0x00000000-0x0009ffff] could not be reser=
ved
[    0.712094] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reser=
ved
[    0.712097] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reser=
ved
[    0.712101] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.712104] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.712108] system 00:00: [mem 0x000dc000-0x000dffff] could not be reser=
ved
[    0.712112] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reser=
ved
[    0.712115] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reser=
ved
[    0.712118] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reser=
ved
[    0.712122] system 00:00: [mem 0x000ec000-0x000effff] could not be reser=
ved
[    0.712125] system 00:00: [mem 0x000f0000-0x000fffff] could not be reser=
ved
[    0.712129] system 00:00: [mem 0x00100000-0xbfffffff] could not be reser=
ved
[    0.712133] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reser=
ved
[    0.712136] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reser=
ved
[    0.712140] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.712152] pnp 00:01: [bus ff]
[    0.712184] pnp 00:01: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.712198] pnp 00:02: [bus 00-fe]
[    0.712200] pnp 00:02: [io  0x0cf8-0x0cff]
[    0.712201] pnp 00:02: [io  0x0000-0x0cf7 window]
[    0.712203] pnp 00:02: [io  0x0d00-0xffff window]
[    0.712205] pnp 00:02: [mem 0x000a0000-0x000bffff window]
[    0.712206] pnp 00:02: [mem 0x000c0000-0x000c3fff window]
[    0.712208] pnp 00:02: [mem 0x000c4000-0x000c7fff window]
[    0.712209] pnp 00:02: [mem 0x000c8000-0x000cbfff window]
[    0.712211] pnp 00:02: [mem 0x000cc000-0x000cffff window]
[    0.712212] pnp 00:02: [mem 0x000d0000-0x000d3fff window]
[    0.712214] pnp 00:02: [mem 0x000d4000-0x000d7fff window]
[    0.712216] pnp 00:02: [mem 0x000d8000-0x000dbfff window]
[    0.712218] pnp 00:02: [mem 0x000dc000-0x000dffff window]
[    0.712220] pnp 00:02: [mem 0x000e0000-0x000e3fff window]
[    0.712221] pnp 00:02: [mem 0x000e4000-0x000e7fff window]
[    0.712223] pnp 00:02: [mem 0x000e8000-0x000ebfff window]
[    0.712224] pnp 00:02: [mem 0x000ec000-0x000effff window]
[    0.712226] pnp 00:02: [mem 0xc0000000-0xfebfffff window]
[    0.712228] pnp 00:02: [mem 0xfed40000-0xfed4bfff window]
[    0.712258] pnp 00:02: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (a=
ctive)
[    0.712518] pnp 00:03: [io  0x0010-0x001f]
[    0.712519] pnp 00:03: [io  0x0090-0x009f]
[    0.712521] pnp 00:03: [io  0x0024-0x0025]
[    0.712523] pnp 00:03: [io  0x0028-0x0029]
[    0.712524] pnp 00:03: [io  0x002c-0x002d]
[    0.712525] pnp 00:03: [io  0x0030-0x0031]
[    0.712527] pnp 00:03: [io  0x0034-0x0035]
[    0.712528] pnp 00:03: [io  0x0038-0x0039]
[    0.712530] pnp 00:03: [io  0x003c-0x003d]
[    0.712531] pnp 00:03: [io  0x00a4-0x00a5]
[    0.712532] pnp 00:03: [io  0x00a8-0x00a9]
[    0.712534] pnp 00:03: [io  0x00ac-0x00ad]
[    0.712535] pnp 00:03: [io  0x00b0-0x00b5]
[    0.712536] pnp 00:03: [io  0x00b8-0x00b9]
[    0.712538] pnp 00:03: [io  0x00bc-0x00bd]
[    0.712539] pnp 00:03: [io  0x0050-0x0053]
[    0.712540] pnp 00:03: [io  0x0072-0x0077]
[    0.712542] pnp 00:03: [io  0x164e-0x164f]
[    0.712543] pnp 00:03: [io  0x002e-0x002f]
[    0.712545] pnp 00:03: [io  0x1000-0x107f]
[    0.712546] pnp 00:03: [io  0x1180-0x11ff]
[    0.712547] pnp 00:03: [io  0x0800-0x080f]
[    0.712550] pnp 00:03: [io  0x15e0-0x15ef]
[    0.712552] pnp 00:03: [io  0x1600-0x1641]
[    0.712553] pnp 00:03: [io  0x1644-0x167f]
[    0.712555] pnp 00:03: [mem 0xe0000000-0xefffffff]
[    0.712556] pnp 00:03: [mem 0xfeaff000-0xfeafffff]
[    0.712558] pnp 00:03: [mem 0xfed1c000-0xfed1ffff]
[    0.712559] pnp 00:03: [mem 0xfed10000-0xfed13fff]
[    0.712561] pnp 00:03: [mem 0xfed18000-0xfed18fff]
[    0.712562] pnp 00:03: [mem 0xfed19000-0xfed19fff]
[    0.712564] pnp 00:03: [mem 0xfed45000-0xfed4bfff]
[    0.712619] system 00:03: [io  0x164e-0x164f] has been reserved
[    0.712623] system 00:03: [io  0x1000-0x107f] has been reserved
[    0.712626] system 00:03: [io  0x1180-0x11ff] has been reserved
[    0.712630] system 00:03: [io  0x0800-0x080f] has been reserved
[    0.712633] system 00:03: [io  0x15e0-0x15ef] has been reserved
[    0.712636] system 00:03: [io  0x1600-0x1641] has been reserved
[    0.712640] system 00:03: [io  0x1644-0x167f] could not be reserved
[    0.712643] system 00:03: [mem 0xe0000000-0xefffffff] has been reserved
[    0.712647] system 00:03: [mem 0xfeaff000-0xfeafffff] has been reserved
[    0.712651] system 00:03: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.712654] system 00:03: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.712658] system 00:03: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.712661] system 00:03: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.712665] system 00:03: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.712668] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.712697] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.712721] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.712730] pnp 00:05: [io  0x0000-0x000f]
[    0.712731] pnp 00:05: [io  0x0080-0x008f]
[    0.712733] pnp 00:05: [io  0x00c0-0x00df]
[    0.712735] pnp 00:05: [dma 4]
[    0.712755] pnp 00:05: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.712762] pnp 00:06: [io  0x0061]
[    0.712788] pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.712795] pnp 00:07: [io  0x00f0]
[    0.712804] pnp 00:07: [irq 13]
[    0.712825] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.712834] pnp 00:08: [io  0x0070-0x0071]
[    0.712839] pnp 00:08: [irq 8]
[    0.712860] pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.712868] pnp 00:09: [io  0x0060]
[    0.712870] pnp 00:09: [io  0x0064]
[    0.712874] pnp 00:09: [irq 1]
[    0.712897] pnp 00:09: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.712908] pnp 00:0a: [irq 12]
[    0.712930] pnp 00:0a: Plug and Play ACPI device, IDs LEN0018 PNP0f13 (a=
ctive)
[    0.713181] pnp 00:0b: [mem 0xfed40000-0xfed44fff]
[    0.713208] pnp 00:0b: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (a=
ctive)
[    0.713441] Switched to NOHz mode on CPU #0
[    0.713502] Switched to NOHz mode on CPU #1
[    0.713570] Switched to NOHz mode on CPU #3
[    0.713587] Switched to NOHz mode on CPU #2
[    0.713705] pnp: PnP ACPI: found 12 devices
[    0.713708] ACPI: ACPI bus type pnp unregistered
[    0.719502] PCI: max bus depth: 1 pci_try_num: 2
[    0.719541] pci 0000:00:1c.0: PCI bridge to [bus 0d-0d]
[    0.719544] pci 0000:00:1c.0:   bridge window [io  disabled]
[    0.719551] pci 0000:00:1c.0:   bridge window [mem disabled]
[    0.719556] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    0.719564] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.719569] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.719576] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.719582] pci 0000:00:1c.3:   bridge window [mem 0xf2800000-0xf28fffff=
 64bit pref]
[    0.719591] pci 0000:00:1c.4: PCI bridge to [bus 02-02]
[    0.719593] pci 0000:00:1c.4:   bridge window [io  disabled]
[    0.719600] pci 0000:00:1c.4:   bridge window [mem 0xf2400000-0xf24fffff]
[    0.719605] pci 0000:00:1c.4:   bridge window [mem pref disabled]
[    0.719613] pci 0000:00:1e.0: PCI bridge to [bus 0e-0e]
[    0.719616] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.719622] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.719628] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.719649] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.719656] pci 0000:00:1c.0: setting latency timer to 64
[    0.719667] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.719673] pci 0000:00:1c.3: setting latency timer to 64
[    0.719679] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.719685] pci 0000:00:1c.4: setting latency timer to 64
[    0.719692] pci 0000:00:1e.0: setting latency timer to 64
[    0.719696] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.719697] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.719699] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.719701] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.719702] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.719704] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.719705] pci_bus 0000:00: resource 10 [mem 0xc0000000-0xfebfffff]
[    0.719707] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    0.719709] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
[    0.719710] pci_bus 0000:05: resource 2 [mem 0xf2800000-0xf28fffff 64bit=
 pref]
[    0.719712] pci_bus 0000:02: resource 1 [mem 0xf2400000-0xf24fffff]
[    0.719714] pci_bus 0000:0e: resource 4 [io  0x0000-0x0cf7]
[    0.719715] pci_bus 0000:0e: resource 5 [io  0x0d00-0xffff]
[    0.719717] pci_bus 0000:0e: resource 6 [mem 0x000a0000-0x000bffff]
[    0.719718] pci_bus 0000:0e: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.719720] pci_bus 0000:0e: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.719721] pci_bus 0000:0e: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.719723] pci_bus 0000:0e: resource 10 [mem 0xc0000000-0xfebfffff]
[    0.719808] NET: Registered protocol family 2
[    0.720012] IP route cache hash table entries: 262144 (order: 9, 2097152=
 bytes)
[    0.721038] TCP established hash table entries: 524288 (order: 11, 83886=
08 bytes)
[    0.722761] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.722967] TCP: Hash tables configured (established 524288 bind 65536)
[    0.722971] TCP reno registered
[    0.722985] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.723023] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.723190] NET: Registered protocol family 1
[    0.723218] pci 0000:00:02.0: Boot video device
[    0.723320] PCI: CLS 64 bytes, default 64
[    0.723364] Unpacking initramfs...
[    2.620991] Freeing initrd memory: 119508k freed
[    2.646441] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.646451] Placing 64MB software IO TLB between ffff8800b727c000 - ffff=
8800bb27c000
[    2.646454] software IO TLB at phys 0xb727c000 - 0xbb27c000
[    2.646487] Simple Boot Flag at 0x35 set to 0x1
[    2.646960] audit: initializing netlink socket (disabled)
[    2.646974] type=3D2000 audit(1315186515.420:1): initialized
[    2.672043] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.701025] VFS: Disk quotas dquot_6.5.2
[    2.701063] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.701144] msgmni has been set to 15604
[    2.701312] alg: No test for stdrng (krng)
[    2.701349] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    2.701355] io scheduler noop registered
[    2.701357] io scheduler deadline registered
[    2.701381] io scheduler cfq registered (default)
[    2.701694] vesafb: mode is 800x600x16, linelength=3D1600, pages=3D0
[    2.701698] vesafb: scrolling: redraw
[    2.701701] vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
[    2.701910] vesafb: framebuffer at 0xd0000000, mapped to 0xffffc90011800=
000, using 960k, total 960k
[    2.734729] Console: switching to colour frame buffer device 100x37
[    2.767864] fb0: VESA VGA frame buffer device
[    2.768314] ERST: Table is not found!
[    2.768734] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.930565] serial 0000:00:16.3: PCI INT B -> GSI 17 (level, low) -> IRQ=
 17
[    2.951629] 0000:00:16.3: ttyS0 at I/O 0x1808 (irq =3D 17) is a 16550A
[    2.952432] Linux agpgart interface v0.103
[    2.952908] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    2.953640] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K tota=
l, 262144K mappable
[    2.955413] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    2.956207] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    2.957004] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    2.961002] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.977994] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.994799] mousedev: PS/2 mouse device common for all mice
[    3.011568] rtc_cmos 00:08: RTC can wake from S4
[    3.028181] rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
[    3.044564] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    3.061051] cpuidle: using governor ladder
[    3.077390] cpuidle: using governor menu
[    3.093610] TCP cubic registered
[    3.109537] NET: Registered protocol family 10
[    3.125355] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    3.142297] Mobile IPv6
[    3.158369] NET: Registered protocol family 17
[    3.174970] Registering the dns_resolver key type
[    3.191253] PM: Hibernation image not present or could not be loaded.
[    3.191263] registered taskstats version 1
[    3.221927] rtc_cmos 00:08: setting system clock to 2011-09-05 01:35:17 =
UTC (1315186517)
[    3.238405] Initializing network drop monitor service
[    3.255934] Freeing unused kernel memory: 564k freed
[    3.272643] Write protecting the kernel read-only data: 6144k
[    3.291958] Freeing unused kernel memory: 716k freed
[    3.311420] Freeing unused kernel memory: 776k freed
[    3.352713] udevd[58]: starting version 172
[    3.380786] usbcore: registered new interface driver usbfs
[    3.402216] thermal LNXTHERM:00: registered as thermal_zone0
[    3.407916] usbcore: registered new interface driver hub
[    3.411304] usbcore: registered new device driver usb
[    3.450990] ACPI: Thermal Zone [THM0] (61 C)
[    3.466983] e1000e: Intel(R) PRO/1000 Network Driver - 1.3.10-k2
[    3.482994] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    3.498830] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.498896] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[    3.498909] e1000e 0000:00:19.0: setting latency timer to 64
[    3.499038] e1000e 0000:00:19.0: irq 40 for MSI/MSI-X
[    3.530907] SCSI subsystem initialized
[    3.550069] libata version 3.00 loaded.
[    3.646414] Refined TSC clocksource calibration: 2659.999 MHz.
[    3.662577] Switching to clocksource tsc
[    3.665689] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) f0=
:de:f1:50:ad:9d
[    3.665691] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connect=
ion
[    3.665759] e1000e 0000:00:19.0: eth0: MAC: 9, PHY: 10, PBA No: A002FF-0=
FF
[    3.665792] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    3.665798] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    3.665808] ehci_hcd 0000:00:1a.0: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[    3.665831] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    3.665835] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    3.665857] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus =
number 1
[    3.665893] ehci_hcd 0000:00:1a.0: debug port 2
[    3.669788] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    3.669809] ehci_hcd 0000:00:1a.0: irq 23, io mem 0xf2728000
[    3.746419] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    3.746457] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    3.746460] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    3.746461] usb usb1: Product: EHCI Host Controller
[    3.746463] usb usb1: Manufacturer: Linux 3.0.0 ehci_hcd
[    3.746464] usb usb1: SerialNumber: 0000:00:1a.0
[    3.746624] hub 1-0:1.0: USB hub found
[    3.746629] hub 1-0:1.0: 3 ports detected
[    3.746700] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    3.746705] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    3.746719] ehci_hcd 0000:00:1d.0: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[    3.746733] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.746736] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    3.746742] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 2
[    3.746769] ehci_hcd 0000:00:1d.0: debug port 2
[    3.750677] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    3.750692] ehci_hcd 0000:00:1d.0: irq 19, io mem 0xf2728400
[    3.946444] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    3.946471] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    3.946473] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    3.946476] usb usb2: Product: EHCI Host Controller
[    3.946477] usb usb2: Manufacturer: Linux 3.0.0 ehci_hcd
[    3.946479] usb usb2: SerialNumber: 0000:00:1d.0
[    3.946613] hub 2-0:1.0: USB hub found
[    3.946624] hub 2-0:1.0: 3 ports detected
[    3.946720] ahci 0000:00:1f.2: version 3.0
[    3.946741] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    3.946792] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    3.946841] ahci: SSS flag set, parallel bus scan disabled
[    3.946892] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x=
33 impl SATA mode
[    3.946896] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led cl=
o pio slum part ems sxs apst=20
[    3.946901] ahci 0000:00:1f.2: setting latency timer to 64
[    4.263055] scsi0 : ahci
[    4.276421] scsi1 : ahci
[    4.289305] scsi2 : ahci
[    4.302244] scsi3 : ahci
[    4.314891] scsi4 : ahci
[    4.327252] scsi5 : ahci
[    4.339690] ata1: SATA max UDMA/133 abar m2048@0xf2727000 port 0xf272710=
0 irq 41
[    4.352376] ata2: SATA max UDMA/133 abar m2048@0xf2727000 port 0xf272718=
0 irq 41
[    4.364888] ata3: DUMMY
[    4.366487] usb 1-1: new high speed USB device number 2 using ehci_hcd
[    4.389826] ata4: DUMMY
[    4.402156] ata5: SATA max UDMA/133 abar m2048@0xf2727000 port 0xf272730=
0 irq 41
[    4.415031] ata6: SATA max UDMA/133 abar m2048@0xf2727000 port 0xf272738=
0 irq 41
[    4.518818] usb 1-1: New USB device found, idVendor=3D8087, idProduct=3D=
0020
[    4.531738] usb 1-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[    4.545007] hub 1-1:1.0: USB hub found
[    4.558188] hub 1-1:1.0: 6 ports detected
[    4.682530] usb 2-1: new high speed USB device number 2 using ehci_hcd
[    4.742549] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.756512] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[    4.756515] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[    4.770588] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[    4.784789] ata1.00: ATA-7: INTEL SSDSA2M160G2LE, 2CV102M3, max UDMA/133
[    4.798871] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    4.813560] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[    4.813566] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[    4.828300] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[    4.830964] usb 2-1: New USB device found, idVendor=3D8087, idProduct=3D=
0020
[    4.830966] usb 2-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[    4.872010] hub 2-1:1.0: USB hub found
[    4.872218] ata1.00: configured for UDMA/133
[    4.872341] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2M160 2C=
V1 PQ: 0 ANSI: 5
[    4.916232] hub 2-1:1.0: 8 ports detected
[    5.002618] usb 1-1.5: new high speed USB device number 3 using ehci_hcd
[    5.106880] usb 1-1.5: New USB device found, idVendor=3D17ef, idProduct=
=3D1005
[    5.122284] usb 1-1.5: New USB device strings: Mfr=3D0, Product=3D0, Ser=
ialNumber=3D0
[    5.137642] hub 1-1.5:1.0: USB hub found
[    5.152631] hub 1-1.5:1.0: 4 ports detected
[    5.238639] usb 1-1.6: new high speed USB device number 4 using ehci_hcd
[    5.242584] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.269028] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    5.269221] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    5.271786] ata2.00: ATAPI: HL-DT-ST DVDRAM GU40N, QX20, max UDMA/133
[    5.290881] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    5.291084] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    5.293715] ata2.00: configured for UDMA/133
[    5.311160] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GU40N     QX=
20 PQ: 0 ANSI: 5
[    5.368152] usb 1-1.6: New USB device found, idVendor=3D17ef, idProduct=
=3D4816
[    5.385448] usb 1-1.6: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    5.402597] usb 1-1.6: Product: Integrated Camera
[    5.419936] usb 1-1.6: Manufacturer: Chicony Electronics Co., Ltd.
[    5.522669] usb 1-1.5.1: new low speed USB device number 5 using ehci_hcd
[    5.646634] ata5: SATA link down (SStatus 0 SControl 300)
[    5.667307] usb 1-1.5.1: New USB device found, idVendor=3D045e, idProduc=
t=3D0084
[    5.684930] usb 1-1.5.1: New USB device strings: Mfr=3D1, Product=3D2, S=
erialNumber=3D0
[    5.702904] usb 1-1.5.1: Product: Basic Optical Mouse
[    5.702906] usb 1-1.5.1: Manufacturer: Microsoft
[    5.994664] ata6: SATA link down (SStatus 0 SControl 300)
[    6.015765] input: Microsoft Basic Optical Mouse as /devices/pci0000:00/=
0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/input/input1
[    6.052758] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB=
/149 GiB)
[    6.052862] generic-usb 0003:045E:0084.0001: input,hidraw0: USB HID v1.1=
0 Mouse [Microsoft Basic Optical Mouse] on usb-0000:00:1a.0-1.5.1/input0
[    6.052964] usbcore: registered new interface driver usbhid
[    6.052968] usbhid: USB HID core driver
[    6.147808] sd 0:0:0:0: [sda] Write Protect is off
[    6.149987] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 =
cdda tray
[    6.149988] cdrom: Uniform CD-ROM driver Revision: 3.20
[    6.150073] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    6.204855] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    6.204881] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    6.244049]  sda: sda1 sda2
[    6.263498] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.284891] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.303918] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    6.686776] md: raid1 personality registered for level 1
[    6.765182] md: md0 stopped.
[    6.784638] md: bind<sda2>
[    6.804281] bio: create slab <bio-1> at 1
[    6.822947] md/raid1:md0: active with 1 out of 2 mirrors
[    6.841438] md0: detected capacity change from 0 to 159739994112
[    6.861041]  md0: unknown partition table
[    6.936864] device-mapper: uevent: version 1.0.3
[    6.954883] device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised:=
 dm-devel@redhat.com
[   19.098247] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[   19.100679] alg: No test for __cbc-aes-aesni (cryptd(__driver-cbc-aes-ae=
sni))
[   32.043601] PM: Starting manual resume from disk
[   32.061463] PM: Hibernation image partition 253:4 present
[   32.061465] PM: Looking for hibernation image.
[   32.061703] PM: Image not found (code -22)
[   32.061707] PM: Hibernation image not present or could not be loaded.
[   32.092680] EXT4-fs (dm-1): mounted filesystem with ordered data mode. O=
pts: (null)
[   32.549219] udevd[435]: starting version 172
[   32.648859] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:=
00/input/input2
[   32.693111] ACPI: acpi_idle registered with cpuidle
[   32.708981] ACPI: Lid Switch [LID]
[   32.729229] Monitor-Mwait will be used to enter C-1 state
[   32.729262] Monitor-Mwait will be used to enter C-2 state
[   32.729282] Monitor-Mwait will be used to enter C-3 state
[   32.729494] input: PC Speaker as /devices/platform/pcspkr/input/input3
[   32.730142] wmi: Mapper loaded
[   32.747973] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0=
E:00/input/input4
[   32.747980] ACPI: Sleep Button [SLPB]
[   32.814132] intel ips 0000:00:1f.6: CPU TDP doesn't match expected value=
 (found 25, expected 29)
[   32.835789] intel ips 0000:00:1f.6: PCI INT D -> GSI 19 (level, low) -> =
IRQ 19
[   32.857040] intel ips 0000:00:1f.6: failed to get i915 symbols, graphics=
 turbo disabled
[   32.879023] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input5
[   32.900818] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp lim=
it 90
[   32.901531] ACPI: Power Button [PWRF]
[   32.947199] Non-volatile memory driver v1.3
[   32.975997] ACPI: AC Adapter [AC] (on-line)
[   33.001230] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) ->=
 IRQ 23
[   33.040679] ACPI: Battery Slot [BAT0] (battery present)
[   33.077572] tpm_tis 00:0b: 1.2 TPM (device-id 0x0, rev-id 78)
[   33.098400] cfg80211: Calling CRDA to update world regulatory domain
[   33.193391] [drm] Initialized drm 1.1.0 20060810
[   33.218763] Linux media interface: v0.10
[   33.255817] Linux video capture interface: v2.00
[   33.338739] i915 0000:00:02.0: power state changed by ACPI to D0
[   33.359245] i915 0000:00:02.0: power state changed by ACPI to D0
[   33.378916] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   33.399216] i915 0000:00:02.0: setting latency timer to 64
[   33.449986] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[   33.469474] thinkpad_acpi: http://ibm-acpi.sf.net/
[   33.488433] thinkpad_acpi: ThinkPad BIOS 6QET62WW (1.32 ), EC 6QHT31WW-1=
.12
[   33.507364] thinkpad_acpi: Lenovo ThinkPad X201, model 3626WVF
[   33.527777] i915 0000:00:02.0: irq 42 for MSI/MSI-X
[   33.527783] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   33.528618] [drm] Driver supports precise vblank timestamp query.
[   33.529965] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[   33.530469] thinkpad_acpi: radio switch found; radios are disabled
[   33.532507] uvcvideo: Found UVC 1.00 device Integrated Camera (17ef:4816)
[   33.532515] thinkpad_acpi: possible tablet mode switch found; ThinkPad i=
n laptop mode
[   33.532530] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=
=3Dio+mem,decodes=3Dio+mem:owns=3Dio+mem
[   33.537348] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is b=
locked
[   33.538498] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0=
/usb1/1-1/1-1.6/1-1.6:1.0/input/input6
[   33.540289] usbcore: registered new interface driver uvcvideo
[   33.541197] USB Video Class driver (v1.1.0)
[   33.542683] Registered led device: tpacpi::thinklight
[   33.542712] Registered led device: tpacpi::power
[   33.542730] Registered led device: tpacpi::standby
[   33.542748] Registered led device: tpacpi::thinkvantage
[   33.545015] thinkpad_acpi: Standard ACPI backlight interface available, =
not loading native one
[   33.546132] thinkpad_acpi: Console audio control enabled, mode: monitor =
(read only)
[   33.550124] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_=
acpi/input/input7
[   33.668938] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in=
-tree:
[   33.669891] iwlagn: Copyright(c) 2003-2011 Intel Corporation
[   33.670837] iwlagn 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ=
 16
[   33.671738] iwlagn 0000:02:00.0: setting latency timer to 64
[   33.671773] iwlagn 0000:02:00.0: Detected Intel(R) Centrino(R) Wireless-=
N 1000 BGN, REV=3D0x6C
[   33.693204] iwlagn 0000:02:00.0: device EEPROM VER=3D0x15d, CALIB=3D0x6
[   33.694179] iwlagn 0000:02:00.0: Device SKU: 0X9
[   33.695133] iwlagn 0000:02:00.0: Valid Tx ant: 0X1, Valid Rx ant: 0X3
[   33.696092] iwlagn 0000:02:00.0: Tunable channels: 13 802.11bg, 0 802.11=
a channels
[   33.697116] iwlagn 0000:02:00.0: irq 43 for MSI/MSI-X
[   33.756242] iwlagn 0000:02:00.0: loaded firmware version 39.31.5.1 build=
 35138
[   33.757374] Registered led device: phy0-led
[   33.761100] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   33.878351] checking generic (d0000000 f0000) vs hw (d0000000 10000000)
[   33.878359] fb: conflicting fb hw usage inteldrmfb vs VESA VGA - removin=
g generic driver
[   33.879936] Console: switching to colour dummy device 80x25
[   33.880579] fbcon: inteldrmfb (fb0) is primary device
[   33.920136] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   33.938879] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/seri=
o1/input/input8
[   34.219128] Console: switching to colour frame buffer device 160x50
[   34.221989] fb0: inteldrmfb frame buffer device
[   34.221991] drm: registered panic notifier
[   34.243982] acpi device:02: registered as cooling_device4
[   34.244224] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:0=
0/LNXVIDEO:00/input/input9
[   34.244354] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   34.244524] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on mi=
nor 0
[   34.244646] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[   34.244757] HDA Intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[   34.244792] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   34.299661] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.=
0/input/input10
[   34.306098] HDMI status: Pin=3D5 Presence_Detect=3D0 ELD_Valid=3D0
[   34.308319] input: HDA Intel HDMI/DP as /devices/pci0000:00/0000:00:1b.0=
/sound/card0/input11
[   34.422560] EXT4-fs (dm-1): re-mounted. Opts: (null)
[   34.449126] EXT4-fs (dm-1): re-mounted. Opts: errors=3Dremount-ro
[   34.485956] loop: module loaded
[   34.600431] Adding 4882428k swap on /dev/mapper/servo-swap.  Priority:-1=
 extents:1 across:4882428k=20
[   34.670439] EXT4-fs (sda1): mounted filesystem with ordered data mode. O=
pts: (null)
[   34.681817] EXT4-fs (dm-5): mounted filesystem with ordered data mode. O=
pts: (null)
[   34.687200] EXT4-fs (dm-3): mounted filesystem with ordered data mode. O=
pts: (null)
[   34.692753] EXT4-fs (dm-2): mounted filesystem with ordered data mode. O=
pts: (null)
[   34.887578] RPC: Registered named UNIX socket transport module.
[   34.889043] RPC: Registered udp transport module.
[   34.890456] RPC: Registered tcp transport module.
[   34.891817] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   34.915921] FS-Cache: Loaded
[   35.006425] FS-Cache: Netfs 'nfs' registered for caching
[   35.038959] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   35.156544] fuse init (API version 7.16)
[   35.237849] e1000e 0000:00:19.0: irq 40 for MSI/MSI-X
[   35.293606] e1000e 0000:00:19.0: irq 40 for MSI/MSI-X
[   35.294385] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   35.343730] GHES: HEST is not enabled!
[   35.421156] ipmi message handler version 39.2
[   35.496408] lp: driver loaded but no devices found
[   35.504348] ppdev: user-space parallel port driver
[   36.277256] input: ACPI Virtual Keyboard Device as /devices/virtual/inpu=
t/input12
[   38.161929] intel ips 0000:00:1f.6: i915 driver attached, reenabling gpu=
 turbo
[   38.310520] hda-intel: Invalid position buffer, using LPIB read method i=
nstead.
[   38.321802] hda-intel: Invalid position buffer, using LPIB read method i=
nstead.
[   38.411862] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Cont=
rol: Rx
[   38.412813] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   48.560395] hda-intel: IRQ timing workaround is activated for card #0. S=
uggest a bigger bdl_pos_adj.
[   48.731038] eth0: no IPv6 routers present

--=-=-=
Content-Disposition: inline; filename=dmesg.after
Content-Transfer-Encoding: quoted-printable
Content-Description: dmesg output after bug triggered

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.0.0 (3.0.0) (jrollins@servo) (gcc version 4.=
6.1 (Debian 4.6.1-4) ) #2 SMP Sun Sep 4 15:59:16 PDT 2011
[    0.000000] Command line: BOOT_IMAGE=3D/vmlinuz-3.0.0 root=3D/dev/mapper=
/servo-root ro vga=3D788
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
[    0.000000]  BIOS-e820: 000000000009e800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bb27c000 (usable)
[    0.000000]  BIOS-e820: 00000000bb27c000 - 00000000bb282000 (reserved)
[    0.000000]  BIOS-e820: 00000000bb282000 - 00000000bb35f000 (usable)
[    0.000000]  BIOS-e820: 00000000bb35f000 - 00000000bb371000 (reserved)
[    0.000000]  BIOS-e820: 00000000bb371000 - 00000000bb3f2000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bb3f2000 - 00000000bb40f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bb40f000 - 00000000bb46f000 (usable)
[    0.000000]  BIOS-e820: 00000000bb46f000 - 00000000bb668000 (reserved)
[    0.000000]  BIOS-e820: 00000000bb668000 - 00000000bb6e8000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bb6e8000 - 00000000bb70f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bb70f000 - 00000000bb717000 (usable)
[    0.000000]  BIOS-e820: 00000000bb717000 - 00000000bb71f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bb71f000 - 00000000bb76c000 (usable)
[    0.000000]  BIOS-e820: 00000000bb76c000 - 00000000bb778000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bb778000 - 00000000bb77b000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bb77b000 - 00000000bb78b000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bb78b000 - 00000000bb78c000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bb78c000 - 00000000bb79f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bb79f000 - 00000000bb7ff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bb7ff000 - 00000000bb800000 (usable)
[    0.000000]  BIOS-e820: 00000000bb800000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000feaff000 - 00000000feb00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 00000001fc000000 (usable)
[    0.000000]  BIOS-e820: 0000000200000000 - 000000023c000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: LENOVO 3626WVF/3626WVF, BIOS 6QET62WW (1.32 ) 12/17/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usab=
le) =3D=3D> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usab=
le)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn =3D 0x23c000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 disabled
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 100000000 mask F00000000 write-back
[    0.000000]   4 base 200000000 mask FC0000000 write-back
[    0.000000]   5 base 23C000000 mask FFC000000 uncachable
[    0.000000]   6 base 0BC000000 mask FFC000000 uncachable
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] e820 update range: 00000000bc000000 - 0000000100000000 (usab=
le) =3D=3D> (reserved)
[    0.000000] last_pfn =3D 0xbb800 max_arch_pfn =3D 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f6910] f6910
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000bb800000
[    0.000000]  0000000000 - 00bb800000 page 2M
[    0.000000] kernel direct mapping tables up to bb800000 @ bb768000-bb76c=
000
[    0.000000] init_memory_mapping: 0000000100000000-000000023c000000
[    0.000000]  0100000000 - 023c000000 page 2M
[    0.000000] kernel direct mapping tables up to 23c000000 @ 23bff6000-23c=
000000
[    0.000000] RAMDISK: 30b3b000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f68e0 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000bb7f08bc 00094 (v01 LENOVO TP-6Q    00001=
320  LTP 00000000)
[    0.000000] ACPI: FACP 00000000bb7f0a00 000F4 (v04 LENOVO TP-6Q    00001=
320 LNVO 00000001)
[    0.000000] ACPI: DSDT 00000000bb7f0d6b 0DDDA (v01 LENOVO TP-6Q    00001=
320 MSFT 03000001)
[    0.000000] ACPI: FACS 00000000bb6e7000 00040
[    0.000000] ACPI: SSDT 00000000bb7f0bb4 001B7 (v01 LENOVO TP-6Q    00001=
320 MSFT 03000001)
[    0.000000] ACPI: ECDT 00000000bb7feb45 00052 (v01 LENOVO TP-6Q    00001=
320 LNVO 00000001)
[    0.000000] ACPI: APIC 00000000bb7feb97 00084 (v01 LENOVO TP-6Q    00001=
320 LNVO 00000001)
[    0.000000] ACPI: MCFG 00000000bb7fec53 0003C (v01 LENOVO TP-6Q    00001=
320 LNVO 00000001)
[    0.000000] ACPI: HPET 00000000bb7fec8f 00038 (v01 LENOVO TP-6Q    00001=
320 LNVO 00000001)
[    0.000000] ACPI: ASF! 00000000bb7fedbe 000A4 (v16 LENOVO TP-6Q    00001=
320 PTL  00000001)
[    0.000000] ACPI: SLIC 00000000bb7fee62 00176 (v01 LENOVO TP-6Q    00001=
320  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000bb7fefd8 00028 (v01 LENOVO TP-6Q    00001=
320  LTP 00000001)
[    0.000000] ACPI: SSDT 00000000bb6e590a 0085B (v01 LENOVO TP-6Q    00001=
320 INTL 20050513)
[    0.000000] ACPI: TCPA 00000000bb78b000 00032 (v02    PTL  CRESTLN 06040=
000      00005A52)
[    0.000000] ACPI: SSDT 00000000bb77a000 009F1 (v01  PmRef    CpuPm 00003=
000 INTL 20050513)
[    0.000000] ACPI: SSDT 00000000bb779000 00259 (v01  PmRef  Cpu0Tst 00003=
000 INTL 20050513)
[    0.000000] ACPI: SSDT 00000000bb778000 0049F (v01  PmRef    ApTst 00003=
000 INTL 20050513)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000023c000000
[    0.000000] Initmem setup node 0 0000000000000000-000000023c000000
[    0.000000]   NODE_DATA [000000023bffb000 - 000000023bffffff]
[    0.000000]  [ffffea0000000000-ffffea0007dfffff] PMD -> [ffff88023360000=
0-ffff88023a5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0023c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[9] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bb27c
[    0.000000]     0: 0x000bb282 -> 0x000bb35f
[    0.000000]     0: 0x000bb40f -> 0x000bb46f
[    0.000000]     0: 0x000bb70f -> 0x000bb717
[    0.000000]     0: 0x000bb71f -> 0x000bb76c
[    0.000000]     0: 0x000bb7ff -> 0x000bb800
[    0.000000]     0: 0x00100000 -> 0x001fc000
[    0.000000]     0: 0x00200000 -> 0x0023c000
[    0.000000] On node 0 totalpages: 2044829
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3921 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 748615 pages, LIFO batch:31
[    0.000000]   Normal zone: 17696 pages used for memmap
[    0.000000]   Normal zone: 1260256 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000=
9f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 00000000001=
00000
[    0.000000] PM: Registered nosave memory: 00000000bb27c000 - 00000000bb2=
82000
[    0.000000] PM: Registered nosave memory: 00000000bb35f000 - 00000000bb3=
71000
[    0.000000] PM: Registered nosave memory: 00000000bb371000 - 00000000bb3=
f2000
[    0.000000] PM: Registered nosave memory: 00000000bb3f2000 - 00000000bb4=
0f000
[    0.000000] PM: Registered nosave memory: 00000000bb46f000 - 00000000bb6=
68000
[    0.000000] PM: Registered nosave memory: 00000000bb668000 - 00000000bb6=
e8000
[    0.000000] PM: Registered nosave memory: 00000000bb6e8000 - 00000000bb7=
0f000
[    0.000000] PM: Registered nosave memory: 00000000bb717000 - 00000000bb7=
1f000
[    0.000000] PM: Registered nosave memory: 00000000bb76c000 - 00000000bb7=
78000
[    0.000000] PM: Registered nosave memory: 00000000bb778000 - 00000000bb7=
7b000
[    0.000000] PM: Registered nosave memory: 00000000bb77b000 - 00000000bb7=
8b000
[    0.000000] PM: Registered nosave memory: 00000000bb78b000 - 00000000bb7=
8c000
[    0.000000] PM: Registered nosave memory: 00000000bb78c000 - 00000000bb7=
9f000
[    0.000000] PM: Registered nosave memory: 00000000bb79f000 - 00000000bb7=
ff000
[    0.000000] PM: Registered nosave memory: 00000000bb800000 - 00000000c00=
00000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e00=
00000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f00=
00000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fea=
ff000
[    0.000000] PM: Registered nosave memory: 00000000feaff000 - 00000000feb=
00000
[    0.000000] PM: Registered nosave memory: 00000000feb00000 - 00000000fec=
00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec=
10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed=
00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed=
1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed=
90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000fee=
00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee=
01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff0=
00000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 00000001000=
00000
[    0.000000] PM: Registered nosave memory: 00000001fc000000 - 00000002000=
00000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000=
:20000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88023bc00000 s78976 r8192=
 d23424 u524288
[    0.000000] pcpu-alloc: s78976 r8192 d23424 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 2012792
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=3D/vmlinuz-3.0.0 root=3D/dev=
/mapper/servo-root ro vga=3D788
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 7870152k/9371648k available (3361k kernel code, 1192=
332k absent, 309164k reserved, 3334k data, 564k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:33024 nr_irqs:712 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 2659.700 MHz processor.
[    0.000003] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 5319.40 BogoMIPS (lpj=3D10638800)
[    0.000008] pid_max: default: 32768 minimum: 301
[    0.000062] Security Framework initialized
[    0.000066] SELinux:  Disabled at boot.
[    0.000590] Dentry cache hash table entries: 1048576 (order: 11, 8388608=
 bytes)
[    0.002580] Inode-cache hash table entries: 524288 (order: 10, 4194304 b=
ytes)
[    0.003428] Mount-cache hash table entries: 256
[    0.003542] Initializing cgroup subsys cpuacct
[    0.003547] Initializing cgroup subsys memory
[    0.003557] Initializing cgroup subsys devices
[    0.003560] Initializing cgroup subsys freezer
[    0.003564] Initializing cgroup subsys net_cls
[    0.003566] Initializing cgroup subsys blkio
[    0.003599] CPU: Physical Processor ID: 0
[    0.003601] CPU: Processor Core ID: 0
[    0.003607] mce: CPU supports 9 MCE banks
[    0.003618] CPU0: Thermal monitoring enabled (TM1)
[    0.003626] using mwait in idle threads.
[    0.003929] ACPI: Core revision 20110413
[    0.020140] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.059826] CPU0: Intel(R) Core(TM) i7 CPU       M 620  @ 2.67GHz steppi=
ng 05
[    0.165388] Performance Events: PEBS fmt1+, Westmere events, Intel PMU d=
river.
[    0.165396] ... version:                3
[    0.165398] ... bit width:              48
[    0.165400] ... generic registers:      4
[    0.165402] ... value mask:             0000ffffffffffff
[    0.165404] ... max period:             000000007fffffff
[    0.165406] ... fixed-purpose events:   3
[    0.165408] ... event mask:             000000070000000f
[    0.165566] NMI watchdog enabled, takes one hw-pmu counter.
[    0.165676] Booting Node   0, Processors  #1
[    0.165679] smpboot cpu 1: start_ip =3D 99000
[    0.273472] NMI watchdog enabled, takes one hw-pmu counter.
[    0.273604]  #2
[    0.273606] smpboot cpu 2: start_ip =3D 99000
[    0.381571] NMI watchdog enabled, takes one hw-pmu counter.
[    0.381703]  #3 Ok.
[    0.381705] smpboot cpu 3: start_ip =3D 99000
[    0.489568] NMI watchdog enabled, takes one hw-pmu counter.
[    0.489610] Brought up 4 CPUs
[    0.489613] Total of 4 processors activated (21279.02 BogoMIPS).
[    0.491832] devtmpfs: initialized
[    0.494891] PM: Registering ACPI NVS region at bb371000 (528384 bytes)
[    0.494914] PM: Registering ACPI NVS region at bb668000 (524288 bytes)
[    0.494935] PM: Registering ACPI NVS region at bb76c000 (49152 bytes)
[    0.494939] PM: Registering ACPI NVS region at bb77b000 (65536 bytes)
[    0.494943] PM: Registering ACPI NVS region at bb78c000 (77824 bytes)
[    0.495066] print_constraints: dummy:=20
[    0.495119] NET: Registered protocol family 16
[    0.495202] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    0.495206] ACPI: bus type pci registered
[    0.495266] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000=
-0xefffffff] (base 0xe0000000)
[    0.495271] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.535395] PCI: Using configuration type 1 for base access
[    0.535916] bio: create slab <bio-0> at 0
[    0.537381] ACPI: EC: EC description table is found, configuring boot EC
[    0.542692] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.629766] ACPI: SSDT 00000000bb71a598 004F3 (v01  PmRef  Cpu0Ist 00003=
000 INTL 20050513)
[    0.630099] ACPI: Dynamic OEM Table Load:
[    0.630103] ACPI: SSDT           (null) 004F3 (v01  PmRef  Cpu0Ist 00003=
000 INTL 20050513)
[    0.630244] ACPI: SSDT 00000000bb718718 006B2 (v01  PmRef  Cpu0Cst 00003=
001 INTL 20050513)
[    0.630595] ACPI: Dynamic OEM Table Load:
[    0.630598] ACPI: SSDT           (null) 006B2 (v01  PmRef  Cpu0Cst 00003=
001 INTL 20050513)
[    0.657783] ACPI: SSDT 00000000bb719a98 00303 (v01  PmRef    ApIst 00003=
000 INTL 20050513)
[    0.658175] ACPI: Dynamic OEM Table Load:
[    0.658178] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003=
000 INTL 20050513)
[    0.669624] ACPI: SSDT 00000000bb717d98 00119 (v01  PmRef    ApCst 00003=
000 INTL 20050513)
[    0.669969] ACPI: Dynamic OEM Table Load:
[    0.669972] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003=
000 INTL 20050513)
[    0.683143] ACPI: Interpreter enabled
[    0.683148] ACPI: (supports S0 S3 S4 S5)
[    0.683169] ACPI: Using IOAPIC for interrupt routing
[    0.686748] ACPI: Power Resource [PUBS] (on)
[    0.690008] ACPI: EC: GPE =3D 0x11, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.691190] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.691194] HEST: Table not found.
[    0.691197] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.691213] ACPI: PCI Root Bridge [UNCR] (domain 0000 [bus ff])
[    0.691255] pci 0000:ff:00.0: [8086:2c62] type 0 class 0x000600
[    0.691274] pci 0000:ff:00.1: [8086:2d01] type 0 class 0x000600
[    0.691290] pci 0000:ff:02.0: [8086:2d10] type 0 class 0x000600
[    0.691304] pci 0000:ff:02.1: [8086:2d11] type 0 class 0x000600
[    0.691317] pci 0000:ff:02.2: [8086:2d12] type 0 class 0x000600
[    0.691331] pci 0000:ff:02.3: [8086:2d13] type 0 class 0x000600
[    0.691359]  pci0000:ff: Requesting ACPI _OSC control (0x1d)
[    0.691364]  pci0000:ff: ACPI _OSC request failed (AE_NOT_FOUND), return=
ed control mask: 0x1d
[    0.691367] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.691659] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.691706] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.691710] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.691713] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x00=
0bffff]
[    0.691716] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x00=
0d3fff]
[    0.691719] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x00=
0d7fff]
[    0.691723] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x00=
0dbfff]
[    0.691726] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfe=
bfffff]
[    0.691737] pci 0000:00:00.0: [8086:0044] type 0 class 0x000600
[    0.691750] DMAR: BIOS has allocated no shadow GTT; disabling IOMMU for =
graphics
[    0.691768] pci 0000:00:02.0: [8086:0046] type 0 class 0x000300
[    0.691777] pci 0000:00:02.0: reg 10: [mem 0xf2000000-0xf23fffff 64bit]
[    0.691783] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit p=
ref]
[    0.691787] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.691843] pci 0000:00:16.0: [8086:3b64] type 0 class 0x000780
[    0.691870] pci 0000:00:16.0: reg 10: [mem 0xf2727800-0xf272780f 64bit]
[    0.691945] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.691950] pci 0000:00:16.0: PME# disabled
[    0.691980] pci 0000:00:16.3: [8086:3b67] type 0 class 0x000700
[    0.692002] pci 0000:00:16.3: reg 10: [io  0x1808-0x180f]
[    0.692013] pci 0000:00:16.3: reg 14: [mem 0xf2524000-0xf2524fff]
[    0.692118] pci 0000:00:19.0: [8086:10ea] type 0 class 0x000200
[    0.692142] pci 0000:00:19.0: reg 10: [mem 0xf2500000-0xf251ffff]
[    0.692153] pci 0000:00:19.0: reg 14: [mem 0xf2525000-0xf2525fff]
[    0.692164] pci 0000:00:19.0: reg 18: [io  0x1820-0x183f]
[    0.692233] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.692238] pci 0000:00:19.0: PME# disabled
[    0.692267] pci 0000:00:1a.0: [8086:3b3c] type 0 class 0x000c03
[    0.692292] pci 0000:00:1a.0: reg 10: [mem 0xf2728000-0xf27283ff]
[    0.692378] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.692383] pci 0000:00:1a.0: PME# disabled
[    0.692412] pci 0000:00:1b.0: [8086:3b56] type 0 class 0x000403
[    0.692432] pci 0000:00:1b.0: reg 10: [mem 0xf2520000-0xf2523fff 64bit]
[    0.692508] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.692513] pci 0000:00:1b.0: PME# disabled
[    0.692539] pci 0000:00:1c.0: [8086:3b42] type 1 class 0x000604
[    0.692613] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.692618] pci 0000:00:1c.0: PME# disabled
[    0.692647] pci 0000:00:1c.3: [8086:3b48] type 1 class 0x000604
[    0.692725] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.692729] pci 0000:00:1c.3: PME# disabled
[    0.692757] pci 0000:00:1c.4: [8086:3b4a] type 1 class 0x000604
[    0.692833] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.692837] pci 0000:00:1c.4: PME# disabled
[    0.692873] pci 0000:00:1d.0: [8086:3b34] type 0 class 0x000c03
[    0.692897] pci 0000:00:1d.0: reg 10: [mem 0xf2728400-0xf27287ff]
[    0.692982] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.692986] pci 0000:00:1d.0: PME# disabled
[    0.693010] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.693084] pci 0000:00:1f.0: [8086:3b07] type 0 class 0x000601
[    0.693200] pci 0000:00:1f.2: [8086:3b2f] type 0 class 0x000106
[    0.693226] pci 0000:00:1f.2: reg 10: [io  0x1860-0x1867]
[    0.693237] pci 0000:00:1f.2: reg 14: [io  0x1814-0x1817]
[    0.693247] pci 0000:00:1f.2: reg 18: [io  0x1818-0x181f]
[    0.693257] pci 0000:00:1f.2: reg 1c: [io  0x1810-0x1813]
[    0.693268] pci 0000:00:1f.2: reg 20: [io  0x1840-0x185f]
[    0.693279] pci 0000:00:1f.2: reg 24: [mem 0xf2727000-0xf27277ff]
[    0.693325] pci 0000:00:1f.2: PME# supported from D3hot
[    0.693329] pci 0000:00:1f.2: PME# disabled
[    0.693351] pci 0000:00:1f.3: [8086:3b30] type 0 class 0x000c05
[    0.693371] pci 0000:00:1f.3: reg 10: [mem 0xf2728800-0xf27288ff 64bit]
[    0.693401] pci 0000:00:1f.3: reg 20: [io  0x1880-0x189f]
[    0.693451] pci 0000:00:1f.6: [8086:3b32] type 0 class 0x001180
[    0.693479] pci 0000:00:1f.6: reg 10: [mem 0xf2526000-0xf2526fff 64bit]
[    0.693612] pci 0000:00:1c.0: PCI bridge to [bus 0d-0d]
[    0.693619] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disab=
led)
[    0.693623] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff=
] (disabled)
[    0.693630] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff=
 pref] (disabled)
[    0.693685] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.693691] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.693695] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.693702] pci 0000:00:1c.3:   bridge window [mem 0xf2800000-0xf28fffff=
 64bit pref]
[    0.693786] pci 0000:02:00.0: [8086:0084] type 0 class 0x000280
[    0.693824] pci 0000:02:00.0: reg 10: [mem 0xf2400000-0xf2401fff 64bit]
[    0.693971] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.693978] pci 0000:02:00.0: PME# disabled
[    0.694030] pci 0000:00:1c.4: PCI bridge to [bus 02-02]
[    0.694036] pci 0000:00:1c.4:   bridge window [io  0xf000-0x0000] (disab=
led)
[    0.694040] pci 0000:00:1c.4:   bridge window [mem 0xf2400000-0xf24fffff]
[    0.694047] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff=
 pref] (disabled)
[    0.694118] pci 0000:00:1e.0: PCI bridge to [bus 0e-0e] (subtractive dec=
ode)
[    0.694123] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disab=
led)
[    0.694128] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff=
] (disabled)
[    0.694135] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff=
 pref] (disabled)
[    0.694137] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtr=
active decode)
[    0.694139] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtr=
active decode)
[    0.694141] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff=
] (subtractive decode)
[    0.694143] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff=
] (subtractive decode)
[    0.694145] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff=
] (subtractive decode)
[    0.694147] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff=
] (subtractive decode)
[    0.694149] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff=
] (subtractive decode)
[    0.694174] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.694313] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.694349] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.694384] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP5._PRT]
[    0.694538]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.694740]  pci0000:00: ACPI _OSC request failed (AE_SUPPORT), returned=
 control mask: 0x0d
[    0.694744] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.697621] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.697691] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.697745] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11) *0,=
 disabled.
[    0.697812] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.697879] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.697932] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0,=
 disabled.
[    0.697987] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0,=
 disabled.
[    0.698054] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.698144] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.698153] vgaarb: loaded
[    0.698155] vgaarb: bridge control possible 0000:00:02.0
[    0.698186] PCI: Using ACPI for IRQ routing
[    0.707894] PCI: pci_cache_line_size set to 64 bytes
[    0.707969] reserve RAM buffer: 000000000009e800 - 000000000009ffff=20
[    0.707971] reserve RAM buffer: 00000000bb27c000 - 00000000bbffffff=20
[    0.707977] reserve RAM buffer: 00000000bb35f000 - 00000000bbffffff=20
[    0.707982] reserve RAM buffer: 00000000bb46f000 - 00000000bbffffff=20
[    0.707986] reserve RAM buffer: 00000000bb717000 - 00000000bbffffff=20
[    0.707990] reserve RAM buffer: 00000000bb76c000 - 00000000bbffffff=20
[    0.707993] reserve RAM buffer: 00000000bb800000 - 00000000bbffffff=20
[    0.708089] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.708096] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.710119] Switching to clocksource hpet
[    0.711410] pnp: PnP ACPI init
[    0.711425] ACPI: bus type pnp registered
[    0.712019] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    0.712021] pnp 00:00: [mem 0x000c0000-0x000c3fff]
[    0.712023] pnp 00:00: [mem 0x000c4000-0x000c7fff]
[    0.712025] pnp 00:00: [mem 0x000c8000-0x000cbfff]
[    0.712026] pnp 00:00: [mem 0x000cc000-0x000cffff]
[    0.712028] pnp 00:00: [mem 0x000d0000-0x000cffff disabled]
[    0.712030] pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
[    0.712031] pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
[    0.712033] pnp 00:00: [mem 0x000dc000-0x000dffff]
[    0.712034] pnp 00:00: [mem 0x000e0000-0x000e3fff]
[    0.712036] pnp 00:00: [mem 0x000e4000-0x000e7fff]
[    0.712037] pnp 00:00: [mem 0x000e8000-0x000ebfff]
[    0.712039] pnp 00:00: [mem 0x000ec000-0x000effff]
[    0.712040] pnp 00:00: [mem 0x000f0000-0x000fffff]
[    0.712042] pnp 00:00: [mem 0x00100000-0xbfffffff]
[    0.712043] pnp 00:00: [mem 0xfec00000-0xfed3ffff]
[    0.712045] pnp 00:00: [mem 0xfed4c000-0xffffffff]
[    0.712090] system 00:00: [mem 0x00000000-0x0009ffff] could not be reser=
ved
[    0.712094] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reser=
ved
[    0.712097] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reser=
ved
[    0.712101] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.712104] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.712108] system 00:00: [mem 0x000dc000-0x000dffff] could not be reser=
ved
[    0.712112] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reser=
ved
[    0.712115] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reser=
ved
[    0.712118] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reser=
ved
[    0.712122] system 00:00: [mem 0x000ec000-0x000effff] could not be reser=
ved
[    0.712125] system 00:00: [mem 0x000f0000-0x000fffff] could not be reser=
ved
[    0.712129] system 00:00: [mem 0x00100000-0xbfffffff] could not be reser=
ved
[    0.712133] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reser=
ved
[    0.712136] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reser=
ved
[    0.712140] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.712152] pnp 00:01: [bus ff]
[    0.712184] pnp 00:01: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.712198] pnp 00:02: [bus 00-fe]
[    0.712200] pnp 00:02: [io  0x0cf8-0x0cff]
[    0.712201] pnp 00:02: [io  0x0000-0x0cf7 window]
[    0.712203] pnp 00:02: [io  0x0d00-0xffff window]
[    0.712205] pnp 00:02: [mem 0x000a0000-0x000bffff window]
[    0.712206] pnp 00:02: [mem 0x000c0000-0x000c3fff window]
[    0.712208] pnp 00:02: [mem 0x000c4000-0x000c7fff window]
[    0.712209] pnp 00:02: [mem 0x000c8000-0x000cbfff window]
[    0.712211] pnp 00:02: [mem 0x000cc000-0x000cffff window]
[    0.712212] pnp 00:02: [mem 0x000d0000-0x000d3fff window]
[    0.712214] pnp 00:02: [mem 0x000d4000-0x000d7fff window]
[    0.712216] pnp 00:02: [mem 0x000d8000-0x000dbfff window]
[    0.712218] pnp 00:02: [mem 0x000dc000-0x000dffff window]
[    0.712220] pnp 00:02: [mem 0x000e0000-0x000e3fff window]
[    0.712221] pnp 00:02: [mem 0x000e4000-0x000e7fff window]
[    0.712223] pnp 00:02: [mem 0x000e8000-0x000ebfff window]
[    0.712224] pnp 00:02: [mem 0x000ec000-0x000effff window]
[    0.712226] pnp 00:02: [mem 0xc0000000-0xfebfffff window]
[    0.712228] pnp 00:02: [mem 0xfed40000-0xfed4bfff window]
[    0.712258] pnp 00:02: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (a=
ctive)
[    0.712518] pnp 00:03: [io  0x0010-0x001f]
[    0.712519] pnp 00:03: [io  0x0090-0x009f]
[    0.712521] pnp 00:03: [io  0x0024-0x0025]
[    0.712523] pnp 00:03: [io  0x0028-0x0029]
[    0.712524] pnp 00:03: [io  0x002c-0x002d]
[    0.712525] pnp 00:03: [io  0x0030-0x0031]
[    0.712527] pnp 00:03: [io  0x0034-0x0035]
[    0.712528] pnp 00:03: [io  0x0038-0x0039]
[    0.712530] pnp 00:03: [io  0x003c-0x003d]
[    0.712531] pnp 00:03: [io  0x00a4-0x00a5]
[    0.712532] pnp 00:03: [io  0x00a8-0x00a9]
[    0.712534] pnp 00:03: [io  0x00ac-0x00ad]
[    0.712535] pnp 00:03: [io  0x00b0-0x00b5]
[    0.712536] pnp 00:03: [io  0x00b8-0x00b9]
[    0.712538] pnp 00:03: [io  0x00bc-0x00bd]
[    0.712539] pnp 00:03: [io  0x0050-0x0053]
[    0.712540] pnp 00:03: [io  0x0072-0x0077]
[    0.712542] pnp 00:03: [io  0x164e-0x164f]
[    0.712543] pnp 00:03: [io  0x002e-0x002f]
[    0.712545] pnp 00:03: [io  0x1000-0x107f]
[    0.712546] pnp 00:03: [io  0x1180-0x11ff]
[    0.712547] pnp 00:03: [io  0x0800-0x080f]
[    0.712550] pnp 00:03: [io  0x15e0-0x15ef]
[    0.712552] pnp 00:03: [io  0x1600-0x1641]
[    0.712553] pnp 00:03: [io  0x1644-0x167f]
[    0.712555] pnp 00:03: [mem 0xe0000000-0xefffffff]
[    0.712556] pnp 00:03: [mem 0xfeaff000-0xfeafffff]
[    0.712558] pnp 00:03: [mem 0xfed1c000-0xfed1ffff]
[    0.712559] pnp 00:03: [mem 0xfed10000-0xfed13fff]
[    0.712561] pnp 00:03: [mem 0xfed18000-0xfed18fff]
[    0.712562] pnp 00:03: [mem 0xfed19000-0xfed19fff]
[    0.712564] pnp 00:03: [mem 0xfed45000-0xfed4bfff]
[    0.712619] system 00:03: [io  0x164e-0x164f] has been reserved
[    0.712623] system 00:03: [io  0x1000-0x107f] has been reserved
[    0.712626] system 00:03: [io  0x1180-0x11ff] has been reserved
[    0.712630] system 00:03: [io  0x0800-0x080f] has been reserved
[    0.712633] system 00:03: [io  0x15e0-0x15ef] has been reserved
[    0.712636] system 00:03: [io  0x1600-0x1641] has been reserved
[    0.712640] system 00:03: [io  0x1644-0x167f] could not be reserved
[    0.712643] system 00:03: [mem 0xe0000000-0xefffffff] has been reserved
[    0.712647] system 00:03: [mem 0xfeaff000-0xfeafffff] has been reserved
[    0.712651] system 00:03: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.712654] system 00:03: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.712658] system 00:03: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.712661] system 00:03: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.712665] system 00:03: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.712668] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.712697] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.712721] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.712730] pnp 00:05: [io  0x0000-0x000f]
[    0.712731] pnp 00:05: [io  0x0080-0x008f]
[    0.712733] pnp 00:05: [io  0x00c0-0x00df]
[    0.712735] pnp 00:05: [dma 4]
[    0.712755] pnp 00:05: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.712762] pnp 00:06: [io  0x0061]
[    0.712788] pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.712795] pnp 00:07: [io  0x00f0]
[    0.712804] pnp 00:07: [irq 13]
[    0.712825] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.712834] pnp 00:08: [io  0x0070-0x0071]
[    0.712839] pnp 00:08: [irq 8]
[    0.712860] pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.712868] pnp 00:09: [io  0x0060]
[    0.712870] pnp 00:09: [io  0x0064]
[    0.712874] pnp 00:09: [irq 1]
[    0.712897] pnp 00:09: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.712908] pnp 00:0a: [irq 12]
[    0.712930] pnp 00:0a: Plug and Play ACPI device, IDs LEN0018 PNP0f13 (a=
ctive)
[    0.713181] pnp 00:0b: [mem 0xfed40000-0xfed44fff]
[    0.713208] pnp 00:0b: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (a=
ctive)
[    0.713441] Switched to NOHz mode on CPU #0
[    0.713502] Switched to NOHz mode on CPU #1
[    0.713570] Switched to NOHz mode on CPU #3
[    0.713587] Switched to NOHz mode on CPU #2
[    0.713705] pnp: PnP ACPI: found 12 devices
[    0.713708] ACPI: ACPI bus type pnp unregistered
[    0.719502] PCI: max bus depth: 1 pci_try_num: 2
[    0.719541] pci 0000:00:1c.0: PCI bridge to [bus 0d-0d]
[    0.719544] pci 0000:00:1c.0:   bridge window [io  disabled]
[    0.719551] pci 0000:00:1c.0:   bridge window [mem disabled]
[    0.719556] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    0.719564] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.719569] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.719576] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.719582] pci 0000:00:1c.3:   bridge window [mem 0xf2800000-0xf28fffff=
 64bit pref]
[    0.719591] pci 0000:00:1c.4: PCI bridge to [bus 02-02]
[    0.719593] pci 0000:00:1c.4:   bridge window [io  disabled]
[    0.719600] pci 0000:00:1c.4:   bridge window [mem 0xf2400000-0xf24fffff]
[    0.719605] pci 0000:00:1c.4:   bridge window [mem pref disabled]
[    0.719613] pci 0000:00:1e.0: PCI bridge to [bus 0e-0e]
[    0.719616] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.719622] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.719628] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.719649] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.719656] pci 0000:00:1c.0: setting latency timer to 64
[    0.719667] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.719673] pci 0000:00:1c.3: setting latency timer to 64
[    0.719679] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.719685] pci 0000:00:1c.4: setting latency timer to 64
[    0.719692] pci 0000:00:1e.0: setting latency timer to 64
[    0.719696] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.719697] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.719699] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.719701] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.719702] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.719704] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.719705] pci_bus 0000:00: resource 10 [mem 0xc0000000-0xfebfffff]
[    0.719707] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    0.719709] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
[    0.719710] pci_bus 0000:05: resource 2 [mem 0xf2800000-0xf28fffff 64bit=
 pref]
[    0.719712] pci_bus 0000:02: resource 1 [mem 0xf2400000-0xf24fffff]
[    0.719714] pci_bus 0000:0e: resource 4 [io  0x0000-0x0cf7]
[    0.719715] pci_bus 0000:0e: resource 5 [io  0x0d00-0xffff]
[    0.719717] pci_bus 0000:0e: resource 6 [mem 0x000a0000-0x000bffff]
[    0.719718] pci_bus 0000:0e: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.719720] pci_bus 0000:0e: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.719721] pci_bus 0000:0e: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.719723] pci_bus 0000:0e: resource 10 [mem 0xc0000000-0xfebfffff]
[    0.719808] NET: Registered protocol family 2
[    0.720012] IP route cache hash table entries: 262144 (order: 9, 2097152=
 bytes)
[    0.721038] TCP established hash table entries: 524288 (order: 11, 83886=
08 bytes)
[    0.722761] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.722967] TCP: Hash tables configured (established 524288 bind 65536)
[    0.722971] TCP reno registered
[    0.722985] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.723023] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.723190] NET: Registered protocol family 1
[    0.723218] pci 0000:00:02.0: Boot video device
[    0.723320] PCI: CLS 64 bytes, default 64
[    0.723364] Unpacking initramfs...
[    2.620991] Freeing initrd memory: 119508k freed
[    2.646441] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.646451] Placing 64MB software IO TLB between ffff8800b727c000 - ffff=
8800bb27c000
[    2.646454] software IO TLB at phys 0xb727c000 - 0xbb27c000
[    2.646487] Simple Boot Flag at 0x35 set to 0x1
[    2.646960] audit: initializing netlink socket (disabled)
[    2.646974] type=3D2000 audit(1315186515.420:1): initialized
[    2.672043] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.701025] VFS: Disk quotas dquot_6.5.2
[    2.701063] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.701144] msgmni has been set to 15604
[    2.701312] alg: No test for stdrng (krng)
[    2.701349] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    2.701355] io scheduler noop registered
[    2.701357] io scheduler deadline registered
[    2.701381] io scheduler cfq registered (default)
[    2.701694] vesafb: mode is 800x600x16, linelength=3D1600, pages=3D0
[    2.701698] vesafb: scrolling: redraw
[    2.701701] vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
[    2.701910] vesafb: framebuffer at 0xd0000000, mapped to 0xffffc90011800=
000, using 960k, total 960k
[    2.734729] Console: switching to colour frame buffer device 100x37
[    2.767864] fb0: VESA VGA frame buffer device
[    2.768314] ERST: Table is not found!
[    2.768734] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.930565] serial 0000:00:16.3: PCI INT B -> GSI 17 (level, low) -> IRQ=
 17
[    2.951629] 0000:00:16.3: ttyS0 at I/O 0x1808 (irq =3D 17) is a 16550A
[    2.952432] Linux agpgart interface v0.103
[    2.952908] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    2.953640] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K tota=
l, 262144K mappable
[    2.955413] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    2.956207] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    2.957004] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    2.961002] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.977994] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.994799] mousedev: PS/2 mouse device common for all mice
[    3.011568] rtc_cmos 00:08: RTC can wake from S4
[    3.028181] rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
[    3.044564] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    3.061051] cpuidle: using governor ladder
[    3.077390] cpuidle: using governor menu
[    3.093610] TCP cubic registered
[    3.109537] NET: Registered protocol family 10
[    3.125355] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    3.142297] Mobile IPv6
[    3.158369] NET: Registered protocol family 17
[    3.174970] Registering the dns_resolver key type
[    3.191253] PM: Hibernation image not present or could not be loaded.
[    3.191263] registered taskstats version 1
[    3.221927] rtc_cmos 00:08: setting system clock to 2011-09-05 01:35:17 =
UTC (1315186517)
[    3.238405] Initializing network drop monitor service
[    3.255934] Freeing unused kernel memory: 564k freed
[    3.272643] Write protecting the kernel read-only data: 6144k
[    3.291958] Freeing unused kernel memory: 716k freed
[    3.311420] Freeing unused kernel memory: 776k freed
[    3.352713] udevd[58]: starting version 172
[    3.380786] usbcore: registered new interface driver usbfs
[    3.402216] thermal LNXTHERM:00: registered as thermal_zone0
[    3.407916] usbcore: registered new interface driver hub
[    3.411304] usbcore: registered new device driver usb
[    3.450990] ACPI: Thermal Zone [THM0] (61 C)
[    3.466983] e1000e: Intel(R) PRO/1000 Network Driver - 1.3.10-k2
[    3.482994] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    3.498830] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.498896] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[    3.498909] e1000e 0000:00:19.0: setting latency timer to 64
[    3.499038] e1000e 0000:00:19.0: irq 40 for MSI/MSI-X
[    3.530907] SCSI subsystem initialized
[    3.550069] libata version 3.00 loaded.
[    3.646414] Refined TSC clocksource calibration: 2659.999 MHz.
[    3.662577] Switching to clocksource tsc
[    3.665689] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) f0=
:de:f1:50:ad:9d
[    3.665691] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connect=
ion
[    3.665759] e1000e 0000:00:19.0: eth0: MAC: 9, PHY: 10, PBA No: A002FF-0=
FF
[    3.665792] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    3.665798] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    3.665808] ehci_hcd 0000:00:1a.0: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[    3.665831] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    3.665835] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    3.665857] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus =
number 1
[    3.665893] ehci_hcd 0000:00:1a.0: debug port 2
[    3.669788] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    3.669809] ehci_hcd 0000:00:1a.0: irq 23, io mem 0xf2728000
[    3.746419] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    3.746457] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    3.746460] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    3.746461] usb usb1: Product: EHCI Host Controller
[    3.746463] usb usb1: Manufacturer: Linux 3.0.0 ehci_hcd
[    3.746464] usb usb1: SerialNumber: 0000:00:1a.0
[    3.746624] hub 1-0:1.0: USB hub found
[    3.746629] hub 1-0:1.0: 3 ports detected
[    3.746700] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    3.746705] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    3.746719] ehci_hcd 0000:00:1d.0: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[    3.746733] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.746736] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    3.746742] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 2
[    3.746769] ehci_hcd 0000:00:1d.0: debug port 2
[    3.750677] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    3.750692] ehci_hcd 0000:00:1d.0: irq 19, io mem 0xf2728400
[    3.946444] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    3.946471] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    3.946473] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    3.946476] usb usb2: Product: EHCI Host Controller
[    3.946477] usb usb2: Manufacturer: Linux 3.0.0 ehci_hcd
[    3.946479] usb usb2: SerialNumber: 0000:00:1d.0
[    3.946613] hub 2-0:1.0: USB hub found
[    3.946624] hub 2-0:1.0: 3 ports detected
[    3.946720] ahci 0000:00:1f.2: version 3.0
[    3.946741] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    3.946792] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    3.946841] ahci: SSS flag set, parallel bus scan disabled
[    3.946892] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x=
33 impl SATA mode
[    3.946896] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led cl=
o pio slum part ems sxs apst=20
[    3.946901] ahci 0000:00:1f.2: setting latency timer to 64
[    4.263055] scsi0 : ahci
[    4.276421] scsi1 : ahci
[    4.289305] scsi2 : ahci
[    4.302244] scsi3 : ahci
[    4.314891] scsi4 : ahci
[    4.327252] scsi5 : ahci
[    4.339690] ata1: SATA max UDMA/133 abar m2048@0xf2727000 port 0xf272710=
0 irq 41
[    4.352376] ata2: SATA max UDMA/133 abar m2048@0xf2727000 port 0xf272718=
0 irq 41
[    4.364888] ata3: DUMMY
[    4.366487] usb 1-1: new high speed USB device number 2 using ehci_hcd
[    4.389826] ata4: DUMMY
[    4.402156] ata5: SATA max UDMA/133 abar m2048@0xf2727000 port 0xf272730=
0 irq 41
[    4.415031] ata6: SATA max UDMA/133 abar m2048@0xf2727000 port 0xf272738=
0 irq 41
[    4.518818] usb 1-1: New USB device found, idVendor=3D8087, idProduct=3D=
0020
[    4.531738] usb 1-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[    4.545007] hub 1-1:1.0: USB hub found
[    4.558188] hub 1-1:1.0: 6 ports detected
[    4.682530] usb 2-1: new high speed USB device number 2 using ehci_hcd
[    4.742549] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.756512] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[    4.756515] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[    4.770588] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[    4.784789] ata1.00: ATA-7: INTEL SSDSA2M160G2LE, 2CV102M3, max UDMA/133
[    4.798871] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    4.813560] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[    4.813566] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[    4.828300] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[    4.830964] usb 2-1: New USB device found, idVendor=3D8087, idProduct=3D=
0020
[    4.830966] usb 2-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[    4.872010] hub 2-1:1.0: USB hub found
[    4.872218] ata1.00: configured for UDMA/133
[    4.872341] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2M160 2C=
V1 PQ: 0 ANSI: 5
[    4.916232] hub 2-1:1.0: 8 ports detected
[    5.002618] usb 1-1.5: new high speed USB device number 3 using ehci_hcd
[    5.106880] usb 1-1.5: New USB device found, idVendor=3D17ef, idProduct=
=3D1005
[    5.122284] usb 1-1.5: New USB device strings: Mfr=3D0, Product=3D0, Ser=
ialNumber=3D0
[    5.137642] hub 1-1.5:1.0: USB hub found
[    5.152631] hub 1-1.5:1.0: 4 ports detected
[    5.238639] usb 1-1.6: new high speed USB device number 4 using ehci_hcd
[    5.242584] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.269028] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    5.269221] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    5.271786] ata2.00: ATAPI: HL-DT-ST DVDRAM GU40N, QX20, max UDMA/133
[    5.290881] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    5.291084] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    5.293715] ata2.00: configured for UDMA/133
[    5.311160] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GU40N     QX=
20 PQ: 0 ANSI: 5
[    5.368152] usb 1-1.6: New USB device found, idVendor=3D17ef, idProduct=
=3D4816
[    5.385448] usb 1-1.6: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    5.402597] usb 1-1.6: Product: Integrated Camera
[    5.419936] usb 1-1.6: Manufacturer: Chicony Electronics Co., Ltd.
[    5.522669] usb 1-1.5.1: new low speed USB device number 5 using ehci_hcd
[    5.646634] ata5: SATA link down (SStatus 0 SControl 300)
[    5.667307] usb 1-1.5.1: New USB device found, idVendor=3D045e, idProduc=
t=3D0084
[    5.684930] usb 1-1.5.1: New USB device strings: Mfr=3D1, Product=3D2, S=
erialNumber=3D0
[    5.702904] usb 1-1.5.1: Product: Basic Optical Mouse
[    5.702906] usb 1-1.5.1: Manufacturer: Microsoft
[    5.994664] ata6: SATA link down (SStatus 0 SControl 300)
[    6.015765] input: Microsoft Basic Optical Mouse as /devices/pci0000:00/=
0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/input/input1
[    6.052758] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB=
/149 GiB)
[    6.052862] generic-usb 0003:045E:0084.0001: input,hidraw0: USB HID v1.1=
0 Mouse [Microsoft Basic Optical Mouse] on usb-0000:00:1a.0-1.5.1/input0
[    6.052964] usbcore: registered new interface driver usbhid
[    6.052968] usbhid: USB HID core driver
[    6.147808] sd 0:0:0:0: [sda] Write Protect is off
[    6.149987] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 =
cdda tray
[    6.149988] cdrom: Uniform CD-ROM driver Revision: 3.20
[    6.150073] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    6.204855] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    6.204881] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    6.244049]  sda: sda1 sda2
[    6.263498] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.284891] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.303918] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    6.686776] md: raid1 personality registered for level 1
[    6.765182] md: md0 stopped.
[    6.784638] md: bind<sda2>
[    6.804281] bio: create slab <bio-1> at 1
[    6.822947] md/raid1:md0: active with 1 out of 2 mirrors
[    6.841438] md0: detected capacity change from 0 to 159739994112
[    6.861041]  md0: unknown partition table
[    6.936864] device-mapper: uevent: version 1.0.3
[    6.954883] device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised:=
 dm-devel@redhat.com
[   19.098247] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[   19.100679] alg: No test for __cbc-aes-aesni (cryptd(__driver-cbc-aes-ae=
sni))
[   32.043601] PM: Starting manual resume from disk
[   32.061463] PM: Hibernation image partition 253:4 present
[   32.061465] PM: Looking for hibernation image.
[   32.061703] PM: Image not found (code -22)
[   32.061707] PM: Hibernation image not present or could not be loaded.
[   32.092680] EXT4-fs (dm-1): mounted filesystem with ordered data mode. O=
pts: (null)
[   32.549219] udevd[435]: starting version 172
[   32.648859] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:=
00/input/input2
[   32.693111] ACPI: acpi_idle registered with cpuidle
[   32.708981] ACPI: Lid Switch [LID]
[   32.729229] Monitor-Mwait will be used to enter C-1 state
[   32.729262] Monitor-Mwait will be used to enter C-2 state
[   32.729282] Monitor-Mwait will be used to enter C-3 state
[   32.729494] input: PC Speaker as /devices/platform/pcspkr/input/input3
[   32.730142] wmi: Mapper loaded
[   32.747973] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0=
E:00/input/input4
[   32.747980] ACPI: Sleep Button [SLPB]
[   32.814132] intel ips 0000:00:1f.6: CPU TDP doesn't match expected value=
 (found 25, expected 29)
[   32.835789] intel ips 0000:00:1f.6: PCI INT D -> GSI 19 (level, low) -> =
IRQ 19
[   32.857040] intel ips 0000:00:1f.6: failed to get i915 symbols, graphics=
 turbo disabled
[   32.879023] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input5
[   32.900818] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp lim=
it 90
[   32.901531] ACPI: Power Button [PWRF]
[   32.947199] Non-volatile memory driver v1.3
[   32.975997] ACPI: AC Adapter [AC] (on-line)
[   33.001230] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) ->=
 IRQ 23
[   33.040679] ACPI: Battery Slot [BAT0] (battery present)
[   33.077572] tpm_tis 00:0b: 1.2 TPM (device-id 0x0, rev-id 78)
[   33.098400] cfg80211: Calling CRDA to update world regulatory domain
[   33.193391] [drm] Initialized drm 1.1.0 20060810
[   33.218763] Linux media interface: v0.10
[   33.255817] Linux video capture interface: v2.00
[   33.338739] i915 0000:00:02.0: power state changed by ACPI to D0
[   33.359245] i915 0000:00:02.0: power state changed by ACPI to D0
[   33.378916] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   33.399216] i915 0000:00:02.0: setting latency timer to 64
[   33.449986] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[   33.469474] thinkpad_acpi: http://ibm-acpi.sf.net/
[   33.488433] thinkpad_acpi: ThinkPad BIOS 6QET62WW (1.32 ), EC 6QHT31WW-1=
.12
[   33.507364] thinkpad_acpi: Lenovo ThinkPad X201, model 3626WVF
[   33.527777] i915 0000:00:02.0: irq 42 for MSI/MSI-X
[   33.527783] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   33.528618] [drm] Driver supports precise vblank timestamp query.
[   33.529965] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[   33.530469] thinkpad_acpi: radio switch found; radios are disabled
[   33.532507] uvcvideo: Found UVC 1.00 device Integrated Camera (17ef:4816)
[   33.532515] thinkpad_acpi: possible tablet mode switch found; ThinkPad i=
n laptop mode
[   33.532530] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=
=3Dio+mem,decodes=3Dio+mem:owns=3Dio+mem
[   33.537348] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is b=
locked
[   33.538498] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0=
/usb1/1-1/1-1.6/1-1.6:1.0/input/input6
[   33.540289] usbcore: registered new interface driver uvcvideo
[   33.541197] USB Video Class driver (v1.1.0)
[   33.542683] Registered led device: tpacpi::thinklight
[   33.542712] Registered led device: tpacpi::power
[   33.542730] Registered led device: tpacpi::standby
[   33.542748] Registered led device: tpacpi::thinkvantage
[   33.545015] thinkpad_acpi: Standard ACPI backlight interface available, =
not loading native one
[   33.546132] thinkpad_acpi: Console audio control enabled, mode: monitor =
(read only)
[   33.550124] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_=
acpi/input/input7
[   33.668938] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in=
-tree:
[   33.669891] iwlagn: Copyright(c) 2003-2011 Intel Corporation
[   33.670837] iwlagn 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ=
 16
[   33.671738] iwlagn 0000:02:00.0: setting latency timer to 64
[   33.671773] iwlagn 0000:02:00.0: Detected Intel(R) Centrino(R) Wireless-=
N 1000 BGN, REV=3D0x6C
[   33.693204] iwlagn 0000:02:00.0: device EEPROM VER=3D0x15d, CALIB=3D0x6
[   33.694179] iwlagn 0000:02:00.0: Device SKU: 0X9
[   33.695133] iwlagn 0000:02:00.0: Valid Tx ant: 0X1, Valid Rx ant: 0X3
[   33.696092] iwlagn 0000:02:00.0: Tunable channels: 13 802.11bg, 0 802.11=
a channels
[   33.697116] iwlagn 0000:02:00.0: irq 43 for MSI/MSI-X
[   33.756242] iwlagn 0000:02:00.0: loaded firmware version 39.31.5.1 build=
 35138
[   33.757374] Registered led device: phy0-led
[   33.761100] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   33.878351] checking generic (d0000000 f0000) vs hw (d0000000 10000000)
[   33.878359] fb: conflicting fb hw usage inteldrmfb vs VESA VGA - removin=
g generic driver
[   33.879936] Console: switching to colour dummy device 80x25
[   33.880579] fbcon: inteldrmfb (fb0) is primary device
[   33.920136] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   33.938879] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/seri=
o1/input/input8
[   34.219128] Console: switching to colour frame buffer device 160x50
[   34.221989] fb0: inteldrmfb frame buffer device
[   34.221991] drm: registered panic notifier
[   34.243982] acpi device:02: registered as cooling_device4
[   34.244224] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:0=
0/LNXVIDEO:00/input/input9
[   34.244354] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   34.244524] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on mi=
nor 0
[   34.244646] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[   34.244757] HDA Intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[   34.244792] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   34.299661] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.=
0/input/input10
[   34.306098] HDMI status: Pin=3D5 Presence_Detect=3D0 ELD_Valid=3D0
[   34.308319] input: HDA Intel HDMI/DP as /devices/pci0000:00/0000:00:1b.0=
/sound/card0/input11
[   34.422560] EXT4-fs (dm-1): re-mounted. Opts: (null)
[   34.449126] EXT4-fs (dm-1): re-mounted. Opts: errors=3Dremount-ro
[   34.485956] loop: module loaded
[   34.600431] Adding 4882428k swap on /dev/mapper/servo-swap.  Priority:-1=
 extents:1 across:4882428k=20
[   34.670439] EXT4-fs (sda1): mounted filesystem with ordered data mode. O=
pts: (null)
[   34.681817] EXT4-fs (dm-5): mounted filesystem with ordered data mode. O=
pts: (null)
[   34.687200] EXT4-fs (dm-3): mounted filesystem with ordered data mode. O=
pts: (null)
[   34.692753] EXT4-fs (dm-2): mounted filesystem with ordered data mode. O=
pts: (null)
[   34.887578] RPC: Registered named UNIX socket transport module.
[   34.889043] RPC: Registered udp transport module.
[   34.890456] RPC: Registered tcp transport module.
[   34.891817] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   34.915921] FS-Cache: Loaded
[   35.006425] FS-Cache: Netfs 'nfs' registered for caching
[   35.038959] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   35.156544] fuse init (API version 7.16)
[   35.237849] e1000e 0000:00:19.0: irq 40 for MSI/MSI-X
[   35.293606] e1000e 0000:00:19.0: irq 40 for MSI/MSI-X
[   35.294385] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   35.343730] GHES: HEST is not enabled!
[   35.421156] ipmi message handler version 39.2
[   35.496408] lp: driver loaded but no devices found
[   35.504348] ppdev: user-space parallel port driver
[   36.277256] input: ACPI Virtual Keyboard Device as /devices/virtual/inpu=
t/input12
[   38.161929] intel ips 0000:00:1f.6: i915 driver attached, reenabling gpu=
 turbo
[   38.310520] hda-intel: Invalid position buffer, using LPIB read method i=
nstead.
[   38.321802] hda-intel: Invalid position buffer, using LPIB read method i=
nstead.
[   38.411862] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Cont=
rol: Rx
[   38.412813] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   48.560395] hda-intel: IRQ timing workaround is activated for card #0. S=
uggest a bigger bdl_pos_adj.
[   48.731038] eth0: no IPv6 routers present
[  120.451854] ata2.00: disabled
[  120.452054] ACPI: \_SB_.GDCK - undocking
[  120.452987] ata2.00: detaching (SCSI 1:0:0:0)
[  120.454003] ata2: exception Emask 0x10 SAct 0x0 SErr 0x4090000 action 0x=
e frozen
[  120.454010] ata2: irq_stat 0x00400040, connection status changed
[  120.454018] ata2: SError: { PHYRdyChg 10B8B DevExch }
[  120.454032] ata2: hard resetting link
[  120.477301] generic-usb 0003:045E:0084.0001: can't reset device, 0000:00=
:1a.0-1.5.1/input0, status -71
[  120.481270] usb 1-1.5: clear tt 1 (0050) error -71
[  120.493299] generic-usb 0003:045E:0084.0001: can't reset device, 0000:00=
:1a.0-1.5.1/input0, status -71
[  120.497275] usb 1-1.5: clear tt 1 (0050) error -71
[  120.509426] generic-usb 0003:045E:0084.0001: can't reset device, 0000:00=
:1a.0-1.5.1/input0, status -71
[  120.513405] usb 1-1.5: clear tt 1 (0050) error -71
[  120.517423] generic-usb 0003:045E:0084.0001: can't reset device, 0000:00=
:1a.0-1.5.1/input0, status -71
[  120.521406] usb 1-1.5: clear tt 1 (0050) error -71
[  120.525421] generic-usb 0003:045E:0084.0001: can't reset device, 0000:00=
:1a.0-1.5.1/input0, status -71
[  120.529406] usb 1-1.5: clear tt 1 (0050) error -71
[  120.533423] generic-usb 0003:045E:0084.0001: can't reset device, 0000:00=
:1a.0-1.5.1/input0, status -71
[  120.537399] usb 1-1.5: clear tt 1 (0050) error -71
[  120.549175] generic-usb 0003:045E:0084.0001: can't reset device, 0000:00=
:1a.0-1.5.1/input0, status -71
[  120.553151] usb 1-1.5: clear tt 1 (0050) error -71
[  120.557554] generic-usb 0003:045E:0084.0001: can't reset device, 0000:00=
:1a.0-1.5.1/input0, status -71
[  120.561528] usb 1-1.5: clear tt 1 (0050) error -71
[  120.573178] generic-usb 0003:045E:0084.0001: can't reset device, 0000:00=
:1a.0-1.5.1/input0, status -71
[  120.577155] usb 1-1.5: clear tt 1 (0050) error -71
[  120.581556] generic-usb 0003:045E:0084.0001: can't reset device, 0000:00=
:1a.0-1.5.1/input0, status -71
[  120.585530] usb 1-1.5: clear tt 1 (0050) error -71
[  120.597308] generic-usb 0003:045E:0084.0001: can't reset device, 0000:00=
:1a.0-1.5.1/input0, status -71
[  120.601285] usb 1-1.5: clear tt 1 (0050) error -71
[  120.605434] generic-usb 0003:045E:0084.0001: can't reset device, 0000:00=
:1a.0-1.5.1/input0, status -71
[  120.609405] usb 1-1.5: clear tt 1 (0050) error -71
[  120.621220] generic-usb 0003:045E:0084.0001: can't reset device, 0000:00=
:1a.0-1.5.1/input0, status -71
[  120.625279] usb 1-1.5: clear tt 1 (0050) error -71
[  120.637188] generic-usb 0003:045E:0084.0001: can't reset device, 0000:00=
:1a.0-1.5.1/input0, status -71
[  120.641161] usb 1-1.5: clear tt 1 (0050) error -71
[  120.645562] generic-usb 0003:045E:0084.0001: can't reset device, 0000:00=
:1a.0-1.5.1/input0, status -71
[  120.649535] usb 1-1.5: clear tt 1 (0050) error -71
[  120.661188] generic-usb 0003:045E:0084.0001: can't reset device, 0000:00=
:1a.0-1.5.1/input0, status -71
[  120.665162] usb 1-1.5: clear tt 1 (0050) error -71
[  120.669564] generic-usb 0003:045E:0084.0001: can't reset device, 0000:00=
:1a.0-1.5.1/input0, status -71
[  120.673538] usb 1-1.5: clear tt 1 (0050) error -71
[  120.678538] usb 1-1.5: USB disconnect, device number 3
[  120.678544] usb 1-1.5.1: USB disconnect, device number 5
[  121.175441] ata2: SATA link down (SStatus 0 SControl 300)
[  121.175461] ata2: EH complete
[  187.752395] ACPI: \_SB_.GDCK - undocking
[  188.059539] e1000e: eth0 NIC Link is Down
[  188.368708] thinkpad_acpi: EC reports that Thermal Table has changed
[  188.401750] EXT4-fs (dm-1): re-mounted. Opts: errors=3Dremount-ro,commit=
=3D600
[  188.419319] EXT4-fs (sda1): re-mounted. Opts: commit=3D600
[  188.424490] EXT4-fs (dm-5): re-mounted. Opts: commit=3D600
[  188.427958] EXT4-fs (dm-3): re-mounted. Opts: commit=3D600
[  188.433757] EXT4-fs (dm-2): re-mounted. Opts: commit=3D600
[  188.688615] EXT4-fs (dm-1): re-mounted. Opts: errors=3Dremount-ro,commit=
=3D600
[  188.693485] EXT4-fs (sda1): re-mounted. Opts: commit=3D600
[  188.697133] EXT4-fs (dm-5): re-mounted. Opts: commit=3D600
[  188.700639] EXT4-fs (dm-3): re-mounted. Opts: commit=3D600
[  188.738427] EXT4-fs (dm-2): re-mounted. Opts: commit=3D600
[  191.648771] e1000e 0000:00:19.0: irq 40 for MSI/MSI-X
[  191.703585] e1000e 0000:00:19.0: irq 40 for MSI/MSI-X
[  191.704678] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  192.351835] e1000e 0000:00:19.0: irq 40 for MSI/MSI-X
[  192.407691] e1000e 0000:00:19.0: irq 40 for MSI/MSI-X
[  192.409002] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  198.740415] EXT4-fs (dm-1): re-mounted. Opts: errors=3Dremount-ro,commit=
=3D0
[  198.747262] EXT4-fs (sda1): re-mounted. Opts: commit=3D0
[  198.752175] EXT4-fs (dm-5): re-mounted. Opts: commit=3D0
[  198.755515] EXT4-fs (dm-3): re-mounted. Opts: commit=3D0
[  198.764045] EXT4-fs (dm-2): re-mounted. Opts: commit=3D0
[  199.540657] e1000e 0000:00:19.0: irq 40 for MSI/MSI-X
[  199.596459] e1000e 0000:00:19.0: irq 40 for MSI/MSI-X
[  199.597806] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  200.196741] e1000e 0000:00:19.0: irq 40 for MSI/MSI-X
[  200.252541] e1000e 0000:00:19.0: irq 40 for MSI/MSI-X
[  200.253876] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  200.354073] PM: Syncing filesystems ... done.
[  200.355153] PM: Preparing system for mem sleep
[  201.290464] Freezing user space processes ...=20
[  221.306928] Freezing of tasks failed after 20.01 seconds (1 tasks refusi=
ng to freeze, wq_busy=3D0):
[  221.306959] cdrom_id        D 0000000000000000     0  2693   2689 0x0080=
0004
[  221.306969]  ffff88023180b8e8 0000000000000082 7fffffffffffffff ffff8802=
00000000
[  221.306978]  ffff8802314b83c0 ffff88023180bfd8 ffff88023180bfd8 00000000=
00012840
[  221.306987]  ffff880232e18f60 ffff8802314b83c0 ffff88023180b938 00000001=
8133e5cf
[  221.306995] Call Trace:
[  221.307011]  [<ffffffff8133ea82>] schedule_timeout+0x2f/0xd9
[  221.307017]  [<ffffffff81040e0a>] ? __cond_resched+0x23/0x2f
[  221.307021]  [<ffffffff8133e86e>] wait_for_common+0x9e/0x115
[  221.307025]  [<ffffffff8103e569>] ? try_to_wake_up+0x1a7/0x1a7
[  221.307029]  [<ffffffff8133e97b>] wait_for_completion+0x18/0x1a
[  221.307035]  [<ffffffff8105b0fe>] flush_work+0x29/0x2f
[  221.307038]  [<ffffffff8105a3ab>] ? do_work_for_cpu+0x24/0x24
[  221.307042]  [<ffffffff8105b48a>] flush_delayed_work+0x3a/0x3e
[  221.307047]  [<ffffffff81199bc6>] disk_clear_events+0x8f/0xf5
[  221.307073]  [<ffffffff81121827>] check_disk_change+0x29/0x5b
[  221.307081]  [<ffffffffa0069e71>] cdrom_open+0x44/0x4b2 [cdrom]
[  221.307086]  [<ffffffff811a5568>] ? kobject_get+0x18/0x20
[  221.307091]  [<ffffffff812478c9>] ? get_device+0x14/0x1a
[  221.307097]  [<ffffffffa010786b>] sr_block_open+0x90/0xb7 [sr_mod]
[  221.307101]  [<ffffffff811226dd>] __blkdev_get+0xe5/0x39b
[  221.307104]  [<ffffffff81122b5f>] blkdev_get+0x1cc/0x2bb
[  221.307108]  [<ffffffff81122c4e>] ? blkdev_get+0x2bb/0x2bb
[  221.307111]  [<ffffffff81122cb3>] blkdev_open+0x65/0x6a
[  221.307115]  [<ffffffff810f98f2>] __dentry_open+0x185/0x29f
[  221.307120]  [<ffffffff8133f9bc>] ? _raw_spin_lock+0x9/0xb
[  221.307125]  [<ffffffff8113a048>] ? generic_acl_chmod+0x93/0x93
[  221.307129]  [<ffffffff810fa842>] nameidata_to_filp+0x5b/0x62
[  221.307135]  [<ffffffff81105843>] do_last+0x448/0x55d
[  221.307138]  [<ffffffff81106483>] path_openat+0xc3/0x304
[  221.307142]  [<ffffffff811066f7>] do_filp_open+0x33/0x81
[  221.307146]  [<ffffffff8110fba5>] ? alloc_fd+0x6d/0x118
[  221.307150]  [<ffffffff810fa8b2>] do_sys_open+0x69/0xfb
[  221.307153]  [<ffffffff810fa95f>] sys_open+0x1b/0x1d
[  221.307157]  [<ffffffff81344d52>] system_call_fastpath+0x16/0x1b
[  221.307161]=20
[  221.307162] Restarting tasks ... done.
[  221.310930] video LNXVIDEO:00: Restoring backlight state
[  223.436574] EXT4-fs (dm-1): re-mounted. Opts: errors=3Dremount-ro,commit=
=3D600
[  223.441060] EXT4-fs (sda1): re-mounted. Opts: commit=3D600
[  223.444631] EXT4-fs (dm-5): re-mounted. Opts: commit=3D600
[  223.448333] EXT4-fs (dm-3): re-mounted. Opts: commit=3D600
[  223.454512] EXT4-fs (dm-2): re-mounted. Opts: commit=3D600
[  226.873139] e1000e 0000:00:19.0: irq 40 for MSI/MSI-X
[  226.927581] e1000e 0000:00:19.0: irq 40 for MSI/MSI-X
[  226.929725] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  242.681434] INFO: task cdrom_id:2693 blocked for more than 120 seconds.
[  242.681438] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[  242.681442] cdrom_id        D 0000000000000000     0  2693   2689 0x0000=
0004
[  242.681448]  ffff88023180b8e8 0000000000000082 7fffffffffffffff ffff8802=
00000000
[  242.681455]  ffff8802314b83c0 ffff88023180bfd8 ffff88023180bfd8 00000000=
00012840
[  242.681460]  ffff880232e18f60 ffff8802314b83c0 ffff88023180b938 00000001=
8133e5cf
[  242.681466] Call Trace:
[  242.681478]  [<ffffffff8133ea82>] schedule_timeout+0x2f/0xd9
[  242.681486]  [<ffffffff81040e0a>] ? __cond_resched+0x23/0x2f
[  242.681490]  [<ffffffff8133e86e>] wait_for_common+0x9e/0x115
[  242.681495]  [<ffffffff8103e569>] ? try_to_wake_up+0x1a7/0x1a7
[  242.681500]  [<ffffffff8133e97b>] wait_for_completion+0x18/0x1a
[  242.681507]  [<ffffffff8105b0fe>] flush_work+0x29/0x2f
[  242.681511]  [<ffffffff8105a3ab>] ? do_work_for_cpu+0x24/0x24
[  242.681516]  [<ffffffff8105b48a>] flush_delayed_work+0x3a/0x3e
[  242.681522]  [<ffffffff81199bc6>] disk_clear_events+0x8f/0xf5
[  242.681552]  [<ffffffff81121827>] check_disk_change+0x29/0x5b
[  242.681562]  [<ffffffffa0069e71>] cdrom_open+0x44/0x4b2 [cdrom]
[  242.681569]  [<ffffffff811a5568>] ? kobject_get+0x18/0x20
[  242.681575]  [<ffffffff812478c9>] ? get_device+0x14/0x1a
[  242.681584]  [<ffffffffa010786b>] sr_block_open+0x90/0xb7 [sr_mod]
[  242.681589]  [<ffffffff811226dd>] __blkdev_get+0xe5/0x39b
[  242.681593]  [<ffffffff81122b5f>] blkdev_get+0x1cc/0x2bb
[  242.681598]  [<ffffffff81122c4e>] ? blkdev_get+0x2bb/0x2bb
[  242.681602]  [<ffffffff81122cb3>] blkdev_open+0x65/0x6a
[  242.681607]  [<ffffffff810f98f2>] __dentry_open+0x185/0x29f
[  242.681612]  [<ffffffff8133f9bc>] ? _raw_spin_lock+0x9/0xb
[  242.681618]  [<ffffffff8113a048>] ? generic_acl_chmod+0x93/0x93
[  242.681623]  [<ffffffff810fa842>] nameidata_to_filp+0x5b/0x62
[  242.681629]  [<ffffffff81105843>] do_last+0x448/0x55d
[  242.681633]  [<ffffffff81106483>] path_openat+0xc3/0x304
[  242.681638]  [<ffffffff811066f7>] do_filp_open+0x33/0x81
[  242.681644]  [<ffffffff8110fba5>] ? alloc_fd+0x6d/0x118
[  242.681648]  [<ffffffff810fa8b2>] do_sys_open+0x69/0xfb
[  242.681652]  [<ffffffff810fa95f>] sys_open+0x1b/0x1d
[  242.681657]  [<ffffffff81344d52>] system_call_fastpath+0x16/0x1b

--=-=-=--

--==-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOZCqyAAoJEO00zqvie6q8arcP/jk+BzfQ/+exn4i2vvHKwkQy
pkxjX95E6YpmHoTqu1Xrg69DOpDDTen9u5ZFyXN8G+X3ZaZLx+83cc7DxmpyCdqX
c1iI+5VIY4TJNpJdoDms9cxr/yth0hiiT6sh3xADejlqBlz7xTE+o9NsWRQi29sk
GMJQgcEh8gX7/TxisxRx3Re5XUoxHZ257NULvGn0nNK4s+DA6DM+2WSDgEXN2Tml
ot1I9LC3qpJpPPWrf3qLSniT6fqZZbkx6w7USKJ12OWSiYRyqHmmUJiaOu9Z/pEj
lF8+oWoh/3I7DOY//bRvmVC9GfnPxx5btPTjXMojAiFcdrspoHhIymSnSqa7mfmm
YKkb5V7dm32zHRmETg0e55r1UxDAVKAxW9l/Ho4UcRBLQKFhEDTaYLTAOPnZYBUT
4nDl166I7Bh8VkGdHAk1cCw5YBjhej5ezBnWp0oOPsZO1OYhQZwv0tZNIN7mGWvm
RjKlgS1B+MA0mk21Qv1Fb/JuTrGOimS+7SBluDYYogWk0JJa/9HxveQRnUq9LMJT
UL4m/MKdItaRuAIe73Lbxw+5dismPgNxxCN0Z2VeaxE3hH/t9b/i9DvDIC8pIQXm
/tuyRzupAaV2DtGeAwwt+ryZm3gBT78zKBFOshS73vExtkTsYbe1oKwcMoSH9FhX
z9+I5f6j4OZQO2pwg5r5
=hTPH
-----END PGP SIGNATURE-----
--==-=-=--
