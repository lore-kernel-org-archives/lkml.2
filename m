Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab2I3El1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 00:41:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:17970 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285Ab2I3ElY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 00:41:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,511,1344236400"; 
   d="scan'208";a="228208618"
Date: Sun, 30 Sep 2012 12:41:11 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Rob Herring <rob.herring@calxeda.com>
Cc: Leann Ogasawara <leann.ogasawara@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [ubuntu quantal] WARNING at __list_add()
Message-ID: <20120930044111.GB28972@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MW5yreqqjyrRcusr"
Content-Disposition: inline
In-Reply-To: <20120930042930.GA28244@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MW5yreqqjyrRcusr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 30, 2012 at 12:29:30PM +0800, Fengguang Wu wrote:
> Hi,
> 
> I got the below oops in tree:
> 
>    git://sources.calxeda.com/kernel/linux.git ubuntu-quantal

And:

[   59.993940] VFS: Close: file count is 0
[   60.027192] ------------[ cut here ]------------
[   60.031761] WARNING: at /c/kernel-tests/src/tip/lib/list_debug.c:29 __list_add+0x3d/0xad()
[   60.034934] list_add corruption. next->prev should be prev (ffff88000dbd5658), but was ffffffff810c2c8c. (next=ffff880006b8de00).
[   60.037075] Modules linked in:
[   60.040217] Pid: 44, comm: modprobe Not tainted 3.5.4-00413-g5feeb5e #2253
[   60.042560] Call Trace:
[   60.043470]  [<ffffffff810260e2>] warn_slowpath_common+0x62/0x79
[   60.045429]  [<ffffffff8102618d>] warn_slowpath_fmt+0x41/0x43
[   60.046500]  [<ffffffff810c2c8c>] ? sys_sendfile64+0x8d/0x8d
[   60.048339]  [<ffffffff81145fb8>] __list_add+0x3d/0xad
[   60.049319]  [<ffffffff810c3503>] file_sb_list_add+0x41/0x52
[   60.050372]  [<ffffffff810c13bd>] __dentry_open.isra.20+0xf8/0x276
[   60.052266]  [<ffffffff8111ada0>] ? common_lsm_audit+0x79/0x79
[   60.053335]  [<ffffffff810c1565>] vfs_open+0x2a/0x2c
[   60.055335]  [<ffffffff810c1668>] nameidata_to_filp+0x3d/0x7f
[   60.056402]  [<ffffffff810ce5d9>] do_last+0x795/0x7d9
[   60.058128]  [<ffffffff810ce7f3>] path_openat+0xce/0x36c
[   60.059137]  [<ffffffff81007a6d>] ? native_sched_clock+0x29/0x6f
[   60.060242]  [<ffffffff81007abc>] ? sched_clock+0x9/0xd
[   60.062068]  [<ffffffff810ceb7d>] do_filp_open+0x33/0x81
[   60.063107]  [<ffffffff81249609>] ? _raw_spin_unlock+0x24/0x48
[   60.064982]  [<ffffffff810d9074>] ? alloc_fd+0xe0/0xf2
[   60.065988]  [<ffffffff810c17b3>] do_sys_open+0x109/0x196
[   60.067040]  [<ffffffff810c185c>] sys_open+0x1c/0x1e
[   60.068980]  [<ffffffff8124e6f9>] system_call_fastpath+0x16/0x1b

Thanks,
Fengguang

--MW5yreqqjyrRcusr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-ant-2542-2012-09-30-07-30-28-3.5.4-00413-g5feeb5e-2253"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.5.4-00413-g5feeb5e (kbuild@snb) (gcc version=
 4.7.1 (Debian 4.7.1-6) ) #2253 SMP PREEMPT Sun Sep 30 07:31:17 CST 2012 ()
[    0.000000] Command line: trinity=3D5m hung_task_panic=3D1 rcutree.rcu_c=
pu_stall_timeout=3D100 branch=3Dcalxeda/ubuntu-quantal log_buf_len=3D8M ign=
ore_loglevel debug sched_debug apic=3Ddebug dynamic_printk sysrq_always_ena=
bled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 v=
ga=3Dnormal  root=3D/dev/ram0 rw link=3Dvmlinuz-2012-09-30-07-31-33-calxeda=
:ubuntu-quantal:c07f157-5feeb5e-x86_64-randconfig-s003-1-ant noapic nolapic=
 nohz=3Doff BOOT_IMAGE=3Dkernel-tests/kernels/x86_64-randconfig-s003/5feeb5=
e/vmlinuz-3.5.4-00413-g5feeb5e
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[ffff8800000fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x0e8540=
00-0x0e8d5fff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128584(98%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd930 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe550 00038 (v01 BOCHS  BXPCRSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000=
001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe590 01121 (v01   BXPC   BXDSDT 00000=
001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000=
001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffffd10 00038 (v01 BOCHS  BXPCHPET 00000=
001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000000ffff6c0 00644 (v01   BXPC BXSSDTPC 00000=
001 INTL 20100528)
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3901 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 960 pages used for memmap
[    0.000000]   DMA32 zone: 60478 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1        =20
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] Bus #0 is PCI  =20
[    0.000000] Bus #1 is ISA  =20
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 04, APIC ID 2, APIC =
INT 09
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC =
INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 10, APIC ID 2, APIC =
INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 14, APIC ID 2, APIC =
INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 18, APIC ID 2, APIC =
INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 1c, APIC ID 2, APIC =
INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 20, APIC ID 2, APIC =
INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 24, APIC ID 2, APIC =
INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 00, APIC ID 2, APIC =
INT 02
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 01, APIC ID 2, APIC =
INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 03, APIC ID 2, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 04, APIC ID 2, APIC =
INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 05, APIC ID 2, APIC =
INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 06, APIC ID 2, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 07, APIC ID 2, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 08, APIC ID 2, APIC =
INT 08
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0c, APIC ID 2, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0d, APIC ID 2, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0e, APIC ID 2, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0f, APIC ID 2, APIC =
INT 0f
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC=
 LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, API=
C LINT 01
[    0.000000] Processors: 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfffbffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 473 pages/cpu @ffff88000da00000 s1907264 r8=
192 d21952 u2097152
[    0.000000] pcpu-alloc: s1907264 r8192 d21952 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64379
[    0.000000] Kernel command line: trinity=3D5m hung_task_panic=3D1 rcutre=
e.rcu_cpu_stall_timeout=3D100 branch=3Dcalxeda/ubuntu-quantal log_buf_len=
=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_printk sysrq_a=
lways_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,115200 console=
=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3Dvmlinuz-2012-09-30-07-31-3=
3-calxeda:ubuntu-quantal:c07f157-5feeb5e-x86_64-randconfig-s003-1-ant noapi=
c nolapic nohz=3Doff BOOT_IMAGE=3Dkernel-tests/kernels/x86_64-randconfig-s0=
03/5feeb5e/vmlinuz-3.5.4-00413-g5feeb5e
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 202972k/262136k available (2375k kernel code, 500k a=
bsent, 58664k reserved, 4048k data, 2172k init)
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D2, Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration failed
[    0.000000] TSC: Unable to calibrate against PIT
[    0.000000] TSC: using HPET reference calibration
[    0.000000] Detected 3191.923 MHz processor.
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[    0.066663] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 6386.83 BogoMIPS (lpj=3D10639743)
[    0.068594] pid_max: default: 4096 minimum: 301
[    0.115270] Mount-cache hash table entries: 256
[    0.278311] Initializing cgroup subsys debug
[    0.283956] Initializing cgroup subsys devices
[    0.285036] Initializing cgroup subsys blkio
[    0.467537] Freeing SMP alternatives: 12k freed
[    0.477540] ACPI: Core revision 20120320
[    0.917665] ACPI: setting ELCR to 0200 (from 0c00)
[    0.971502] SMP disabled
[    0.977311] Performance Events:=20
[    0.978360] no APIC, boot with the "lapic" boot parameter to force-enabl=
e it.
[    0.980250] no hardware sampling interrupt available.
[    0.981580] Broken PMU hardware detected, using software events only.
[    1.083263] NMI watchdog: disabled (cpu0): hardware events not enabled
[    1.110911] Brought up 1 CPUs
[    1.113583] Total of 1 processors activated (6386.83 BogoMIPS).
[    1.298194] devtmpfs: initialized
[    1.318287] device: 'platform': device_add
[    1.343736] bus: 'platform': registered
[    1.350883] bus: 'cpu': registered
[    1.353852] device: 'cpu': device_add
[    1.367434] bus: 'memory': registered
[    1.373582] device: 'memory': device_add
[    1.380310] device: 'memory0': device_add
[    1.386992] bus: 'memory': add device memory0
[    1.414188] device: 'memory1': device_add
[    1.420495] bus: 'memory': add device memory1
[    1.504040] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    1.510383] device class 'regulator': registering
[    1.548661] Registering platform device 'reg-dummy'. Parent at platform
[    1.550244] device: 'reg-dummy': device_add
[    1.551500] bus: 'platform': add device reg-dummy
[    1.553232] bus: 'platform': add driver reg-dummy
[    1.553232] bus: 'platform': driver_probe_device: matched device reg-dum=
my with driver reg-dummy
[    1.553232] bus: 'platform': really_probe: probing driver reg-dummy with=
 device reg-dummy
[    1.558822] device: 'regulator.0': device_add
[    1.575239] dummy:=20
[    1.581550] driver: 'reg-dummy': driver_bound: bound to device 'reg-dumm=
y'
[    1.587270] bus: 'platform': really_probe: bound device reg-dummy to dri=
ver reg-dummy
[    1.598654] NET: Registered protocol family 16
[    1.608722] device class 'bdi': registering
[    1.613691] device class 'pci_bus': registering
[    1.617858] bus: 'pci': registered
[    1.618612] device class 'tty': registering
[    1.623656] bus: 'spi': registered
[    1.624392] device class 'spi_master': registering
[    1.631775] ACPI: bus type pci registered
[    1.635492] PCI: Using configuration type 1 for base access
[    1.638227] device: 'cpu0': device_add
[    1.640598] bus: 'cpu': add device cpu0
[    1.739172] device: 'default': device_add
[    1.757405] bio: create slab <bio-0> at 0
[    1.761881] device class 'block': registering
[    1.774626] ACPI: Added _OSI(Module Device)
[    1.775594] ACPI: Added _OSI(Processor Device)
[    1.776976] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.777935] ACPI: Added _OSI(Processor Aggregator Device)
[    2.067399] ACPI: EC: Look up EC in DSDT
[    2.693878] ACPI: Interpreter enabled
[    2.696840] ACPI: (supports S0 S5)
[    2.703870] ACPI: Using PIC for interrupt routing
[    2.707947] bus: 'acpi': registered
[    2.710145] bus: 'acpi': add driver power
[    2.720810] device: 'LNXSYSTM:00': device_add
[    2.725218] bus: 'acpi': add device LNXSYSTM:00
[    2.751406] device: 'device:00': device_add
[    2.754609] bus: 'acpi': add device device:00
[    2.766882] device: 'PNP0A03:00': device_add
[    2.768054] bus: 'acpi': add device PNP0A03:00
[    2.911236] device: 'device:01': device_add
[    2.914460] bus: 'acpi': add device device:01
[    2.926476] device: 'device:02': device_add
[    2.927128] bus: 'acpi': add device device:02
[    2.940243] device: 'PNP0B00:00': device_add
[    2.941526] bus: 'acpi': add device PNP0B00:00
[    2.957318] device: 'PNP0303:00': device_add
[    2.959137] bus: 'acpi': add device PNP0303:00
[    2.974634] device: 'PNP0F13:00': device_add
[    2.975828] bus: 'acpi': add device PNP0F13:00
[    2.990831] device: 'PNP0700:00': device_add
[    2.992183] bus: 'acpi': add device PNP0700:00
[    3.015864] device: 'PNP0400:00': device_add
[    3.017763] bus: 'acpi': add device PNP0400:00
[    3.037083] device: 'PNP0501:00': device_add
[    3.038889] bus: 'acpi': add device PNP0501:00
[    3.055776] device: 'device:03': device_add
[    3.057140] bus: 'acpi': add device device:03
[    3.073687] device: 'device:04': device_add
[    3.075446] bus: 'acpi': add device device:04
[    3.087044] device: 'device:05': device_add
[    3.088228] bus: 'acpi': add device device:05
[    3.103889] device: 'device:06': device_add
[    3.105068] bus: 'acpi': add device device:06
[    3.118802] device: 'device:07': device_add
[    3.120463] bus: 'acpi': add device device:07
[    3.133598] device: 'device:08': device_add
[    3.135426] bus: 'acpi': add device device:08
[    3.147872] device: 'device:09': device_add
[    3.150399] bus: 'acpi': add device device:09
[    3.163845] device: 'device:0a': device_add
[    3.165001] bus: 'acpi': add device device:0a
[    3.177834] device: 'device:0b': device_add
[    3.180399] bus: 'acpi': add device device:0b
[    3.191851] device: 'device:0c': device_add
[    3.194353] bus: 'acpi': add device device:0c
[    3.207873] device: 'device:0d': device_add
[    3.210367] bus: 'acpi': add device device:0d
[    3.223775] device: 'device:0e': device_add
[    3.224926] bus: 'acpi': add device device:0e
[    3.238526] device: 'device:0f': device_add
[    3.240433] bus: 'acpi': add device device:0f
[    3.253551] device: 'device:10': device_add
[    3.255436] bus: 'acpi': add device device:10
[    3.268051] device: 'device:11': device_add
[    3.271055] bus: 'acpi': add device device:11
[    3.284164] device: 'device:12': device_add
[    3.285264] bus: 'acpi': add device device:12
[    3.297694] device: 'device:13': device_add
[    3.300352] bus: 'acpi': add device device:13
[    3.311338] device: 'device:14': device_add
[    3.313743] bus: 'acpi': add device device:14
[    3.325152] device: 'device:15': device_add
[    3.327020] bus: 'acpi': add device device:15
[    3.339260] device: 'device:16': device_add
[    3.340434] bus: 'acpi': add device device:16
[    3.352471] device: 'device:17': device_add
[    3.354315] bus: 'acpi': add device device:17
[    3.365720] device: 'device:18': device_add
[    3.367087] bus: 'acpi': add device device:18
[    3.380236] device: 'device:19': device_add
[    3.381333] bus: 'acpi': add device device:19
[    3.393765] device: 'device:1a': device_add
[    3.395412] bus: 'acpi': add device device:1a
[    3.407618] device: 'device:1b': device_add
[    3.408706] bus: 'acpi': add device device:1b
[    3.421331] device: 'device:1c': device_add
[    3.423737] bus: 'acpi': add device device:1c
[    3.434759] device: 'device:1d': device_add
[    3.437095] bus: 'acpi': add device device:1d
[    3.448276] device: 'device:1e': device_add
[    3.450443] bus: 'acpi': add device device:1e
[    3.463410] device: 'device:1f': device_add
[    3.464581] bus: 'acpi': add device device:1f
[    3.475606] device: 'device:20': device_add
[    3.476953] bus: 'acpi': add device device:20
[    3.487929] device: 'device:21': device_add
[    3.490680] bus: 'acpi': add device device:21
[    3.503477] device: 'device:22': device_add
[    3.504726] bus: 'acpi': add device device:22
[    3.531228] device: 'PNP0103:00': device_add
[    3.533639] bus: 'acpi': add device PNP0103:00
[    3.555784] device: 'PNP0C0F:00': device_add
[    3.557043] bus: 'acpi': add device PNP0C0F:00
[    3.575795] device: 'PNP0C0F:01': device_add
[    3.577036] bus: 'acpi': add device PNP0C0F:01
[    3.595836] device: 'PNP0C0F:02': device_add
[    3.597041] bus: 'acpi': add device PNP0C0F:02
[    3.616997] device: 'PNP0C0F:03': device_add
[    3.618673] bus: 'acpi': add device PNP0C0F:03
[    3.635924] device: 'PNP0C0F:04': device_add
[    3.637050] bus: 'acpi': add device PNP0C0F:04
[    3.652251] device: 'LNXCPU:00': device_add
[    3.654318] bus: 'acpi': add device LNXCPU:00
[    3.666428] device: 'LNXCPU:01': device_add
[    3.667041] bus: 'acpi': add device LNXCPU:01
[    3.678974] device: 'device:23': device_add
[    3.680399] bus: 'acpi': add device device:23
[    3.685877] device: 'LNXPWRBN:00': device_add
[    3.686983] bus: 'acpi': add device LNXPWRBN:00
[    3.691987] bus: 'acpi': add driver ec
[    3.698717] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    3.700158] bus: 'acpi': add driver pci_root
[    3.701450] bus: 'acpi': driver_probe_device: matched device PNP0A03:00 =
with driver pci_root
[    3.703340] bus: 'acpi': really_probe: probing driver pci_root with devi=
ce PNP0A03:00
[    3.714437] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    3.721089] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    3.722429] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    3.723529] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x00=
0bffff]
[    3.724777] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfe=
bfffff]
[    3.730505] device: 'pci0000:00': device_add
[    3.734970] device: '0000:00': device_add
[    3.740489] PCI host bridge to bus 0000:00
[    3.741650] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    3.743495] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    3.744562] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    3.746793] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebffff=
f]
[    3.753642] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    3.764312] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    3.771590] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    3.783945] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    3.791321] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    3.798575] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    3.800221] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    3.804502] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    3.808220] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    3.813488] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    3.831485] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    3.834576] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    3.840181] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    3.843437] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    3.861404] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    3.865043] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    3.870083] pci 0000:00:04.0: reg 10: [io  0xc040-0xc07f]
[    3.874849] pci 0000:00:04.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
[    3.895020] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    3.900074] pci 0000:00:05.0: reg 10: [io  0xc080-0xc0bf]
[    3.904731] pci 0000:00:05.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[    3.924938] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    3.930075] pci 0000:00:06.0: reg 10: [io  0xc0c0-0xc0ff]
[    3.934736] pci 0000:00:06.0: reg 14: [mem 0xfebf3000-0xfebf3fff]
[    3.954763] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    3.960160] pci 0000:00:07.0: reg 10: [io  0xc100-0xc13f]
[    3.963417] pci 0000:00:07.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    3.985327] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    3.990114] pci 0000:00:08.0: reg 10: [io  0xc140-0xc17f]
[    3.994788] pci 0000:00:08.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    4.015156] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    4.020065] pci 0000:00:09.0: reg 10: [io  0xc180-0xc1bf]
[    4.024761] pci 0000:00:09.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    4.045167] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    4.048452] pci 0000:00:0a.0: reg 10: [mem 0xfebf7000-0xfebf700f]
[    4.067060] pci_bus 0000:00: on NUMA node 0
[    4.068305] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    4.164897]  pci0000:00: Unable to request _OSC control (_OSC support ma=
sk: 0x08)
[    4.167331] device: '0000:00:00.0': device_add
[    4.267503] bus: 'pci': add device 0000:00:00.0
[    4.273761] device: '0000:00:01.0': device_add
[    4.372502] bus: 'pci': add device 0000:00:01.0
[    4.377824] device: '0000:00:01.1': device_add
[    4.476766] bus: 'pci': add device 0000:00:01.1
[    4.481429] device: '0000:00:01.3': device_add
[    4.580651] bus: 'pci': add device 0000:00:01.3
[    4.585168] device: '0000:00:02.0': device_add
[    4.684343] bus: 'pci': add device 0000:00:02.0
[    4.688847] device: '0000:00:03.0': device_add
[    4.788168] bus: 'pci': add device 0000:00:03.0
[    4.793324] device: '0000:00:04.0': device_add
[    4.891777] bus: 'pci': add device 0000:00:04.0
[    4.897057] device: '0000:00:05.0': device_add
[    4.995266] bus: 'pci': add device 0000:00:05.0
[    5.000437] device: '0000:00:06.0': device_add
[    5.100389] bus: 'pci': add device 0000:00:06.0
[    5.104748] device: '0000:00:07.0': device_add
[    5.207403] bus: 'pci': add device 0000:00:07.0
[    5.212003] device: '0000:00:08.0': device_add
[    5.313752] bus: 'pci': add device 0000:00:08.0
[    5.318291] device: '0000:00:09.0': device_add
[    5.417474] bus: 'pci': add device 0000:00:09.0
[    5.422144] device: '0000:00:0a.0': device_add
[    5.520984] bus: 'pci': add device 0000:00:0a.0
[    5.525192] driver: 'PNP0A03:00': driver_bound: bound to device 'pci_roo=
t'
[    5.526766] bus: 'acpi': really_probe: bound device PNP0A03:00 to driver=
 pci_root
[    5.531803] bus: 'acpi': add driver pci_link
[    5.534994] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 =
with driver pci_link
[    5.536589] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:00
[    5.552391] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    5.557707] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_lin=
k'
[    5.559016] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver=
 pci_link
[    5.560152] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 =
with driver pci_link
[    5.563216] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:01
[    5.570191] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    5.573824] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_lin=
k'
[    5.575098] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver=
 pci_link
[    5.576801] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 =
with driver pci_link
[    5.578159] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:02
[    5.585419] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    5.588861] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_lin=
k'
[    5.590016] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver=
 pci_link
[    5.593400] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 =
with driver pci_link
[    5.594803] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:03
[    5.601813] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    5.605342] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_lin=
k'
[    5.606637] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver=
 pci_link
[    5.608090] bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 =
with driver pci_link
[    5.609947] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:04
[    5.617597] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    5.621191] driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_lin=
k'
[    5.622470] bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver=
 pci_link
[    5.627356] bus: 'pnp': registered
[    5.628092] device class 'misc': registering
[    5.633828] device: 'vga_arbiter': device_add
[    5.659097] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    5.663437] vgaarb: loaded
[    5.664113] vgaarb: bridge control possible 0000:00:02.0
[    5.665245] bus: 'spi': add driver wm831x
[    5.668738] bus: 'serio': registered
[    5.669948] device class 'input': registering
[    5.671595] device class 'rtc': registering
[    5.674136] device class 'power_supply': registering
[    5.677672] device class 'watchdog': registering
[    5.680290] PCI: Using ACPI for IRQ routing
[    5.681510] PCI: pci_cache_line_size set to 64 bytes
[    5.693737] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    5.695201] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    5.697183] device class 'net': registering
[    5.707103] device: 'lo': device_add
[    5.776646] Switching to clocksource hpet
[    5.812932] bus: 'pnp': add driver system
[    5.819351] pnp: PnP ACPI init
[    5.822421] device: 'pnp0': device_add
[    5.823613] ACPI: bus type pnp registered
[    5.833390] pnp 00:00: [bus 00-ff]
[    5.835974] pnp 00:00: [io  0x0cf8-0x0cff]
[    5.836935] pnp 00:00: [io  0x0000-0x0cf7 window]
[    5.839800] pnp 00:00: [io  0x0d00-0xffff window]
[    5.842566] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    5.843609] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    5.849312] device: '00:00': device_add
[    5.873437] bus: 'pnp': add device 00:00
[    5.883641] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    5.900217] pnp 00:01: [io  0x0070-0x0071]
[    5.903434] pnp 00:01: [irq 8]
[    5.908307] pnp 00:01: [io  0x0072-0x0077]
[    5.909217] device: '00:01': device_add
[    5.916382] bus: 'pnp': add device 00:01
[    5.923157] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    5.937207] pnp 00:02: [io  0x0060]
[    5.942569] pnp 00:02: [io  0x0064]
[    5.943271] pnp 00:02: [irq 1]
[    5.945591] device: '00:02': device_add
[    5.952685] bus: 'pnp': add device 00:02
[    5.961847] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    5.973168] pnp 00:03: [irq 12]
[    5.973945] device: '00:03': device_add
[    5.983151] bus: 'pnp': add device 00:03
[    5.990415] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    6.000629] pnp 00:04: [io  0x03f2-0x03f5]
[    6.006883] pnp 00:04: [io  0x03f7]
[    6.010568] pnp 00:04: [irq 6]
[    6.013295] pnp 00:04: [dma 2]
[    6.018169] device: '00:04': device_add
[    6.025607] bus: 'pnp': add device 00:04
[    6.032193] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    6.046777] pnp 00:05: [io  0x0378-0x037f]
[    6.051474] pnp 00:05: [irq 7]
[    6.054002] device: '00:05': device_add
[    6.062846] bus: 'pnp': add device 00:05
[    6.069256] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    6.089455] pnp 00:06: [io  0x03f8-0x03ff]
[    6.090265] pnp 00:06: [irq 4]
[    6.093613] device: '00:06': device_add
[    6.103124] bus: 'pnp': add device 00:06
[    6.106010] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    6.138841] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    6.139873] device: '00:07': device_add
[    6.148899] bus: 'pnp': add device 00:07
[    6.151525] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    6.169225] pnp: PnP ACPI: found 8 devices
[    6.170188] ACPI: ACPI bus type pnp unregistered
[    6.172900] device class 'mem': registering
[    6.175185] device: 'mem': device_add
[    6.181959] device: 'null': device_add
[    6.186629] device: 'port': device_add
[    6.191754] device: 'zero': device_add
[    6.196149] device: 'full': device_add
[    6.200612] device: 'random': device_add
[    6.206039] device: 'urandom': device_add
[    6.210648] device: 'kmsg': device_add
[    6.216206] device: 'oldmem': device_add
[    6.222280] device: 'tty': device_add
[    6.229247] device: 'console': device_add
[    6.235805] device class 'thermal': registering
[    6.250876] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    6.252570] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    6.253614] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    6.255480] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    6.259300] NET: Registered protocol family 2
[    6.267316] IP route cache hash table entries: 2048 (order: 2, 16384 byt=
es)
[    6.288862] TCP established hash table entries: 8192 (order: 5, 131072 b=
ytes)
[    6.294807] TCP bind hash table entries: 8192 (order: 7, 655360 bytes)
[    6.339362] TCP: Hash tables configured (established 8192 bind 8192)
[    6.342120] TCP: reno registered
[    6.343157] UDP hash table entries: 128 (order: 2, 24576 bytes)
[    6.346680] UDP-Lite hash table entries: 128 (order: 2, 24576 bytes)
[    6.353223] NET: Registered protocol family 1
[    6.355024] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    6.356477] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    6.359457] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    6.362364] pci 0000:00:02.0: Boot video device
[    6.366076] PCI: CLS 0 bytes, default 64
[    6.419853] Registering platform device 'pcspkr'. Parent at platform
[    6.421899] device: 'pcspkr': device_add
[    6.423096] bus: 'platform': add device pcspkr
[    6.444512] bus: 'clocksource': registered
[    6.464158] device: 'clocksource': device_add
[    6.466162] device: 'clocksource0': device_add
[    6.467281] bus: 'clocksource': add device clocksource0
[    6.479133] bus: 'platform': add driver alarmtimer
[    6.499572] Unpacking initramfs...
[    6.502193] Registering platform device 'alarmtimer'. Parent at platform
[    6.503320] device: 'alarmtimer': device_add
[    6.528756] bus: 'platform': add device alarmtimer
[    6.530595] bus: 'platform': driver_probe_device: matched device alarmti=
mer with driver alarmtimer
[    6.558897] bus: 'platform': really_probe: probing driver alarmtimer wit=
h device alarmtimer
[    6.561668] driver: 'alarmtimer': driver_bound: bound to device 'alarmti=
mer'
[    6.563038] bus: 'platform': really_probe: bound device alarmtimer to dr=
iver alarmtimer
[    6.576046] bus: 'rttest': registered
[    6.576917] device: 'rttest': device_add
[    6.592333] device: 'rttest0': device_add
[    6.593527] bus: 'rttest': add device rttest0
[    6.605652] device: 'rttest1': device_add
[    6.606973] bus: 'rttest': add device rttest1
[    6.613441] device: 'rttest2': device_add
[    6.615384] bus: 'rttest': add device rttest2
[    6.629149] device: 'rttest3': device_add
[    6.630442] bus: 'rttest': add device rttest3
[    6.642668] device: 'rttest4': device_add
[    6.643857] bus: 'rttest': add device rttest4
[    6.649965] device: 'rttest5': device_add
[    6.651988] bus: 'rttest': add device rttest5
[    6.665945] device: 'rttest6': device_add
[    6.667243] bus: 'rttest': add device rttest6
[    6.679116] device: 'rttest7': device_add
[    6.680396] bus: 'rttest': add device rttest7
[    6.683525] Initializing RT-Tester: OK
[    6.695017] audit: initializing netlink socket (disabled)
[    6.708351] type=3D2000 audit(1348961370.702:1): initialized
[    7.019762] kwatchdog (24) used greatest stack depth: 6472 bytes left
[    7.302850] Kprobe smoke test started
[    7.755794] Kprobe smoke test passed successfully
[    7.768645] bus: 'event_source': registered
[    7.769998] device: 'breakpoint': device_add
[    7.772357] bus: 'event_source': add device breakpoint
[    7.783938] device: 'software': device_add
[    7.792252] bus: 'event_source': add device software
[    7.826565] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    9.483668] VFS: Disk quotas dquot_6.5.2
[    9.523295] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    9.581878] msgmni has been set to 396
[    9.662547] cryptomgr_test (29) used greatest stack depth: 6376 bytes le=
ft
[    9.710575] device class 'bsg': registering
[    9.719512] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 252)
[    9.735534] io scheduler noop registered (default)
[    9.745354] bus: 'acpi': add driver ac
[    9.753399] bus: 'acpi': add driver button
[    9.763877] bus: 'acpi': driver_probe_device: matched device LNXPWRBN:00=
 with driver button
[    9.771675] bus: 'acpi': really_probe: probing driver button with device=
 LNXPWRBN:00
[    9.775898] device: 'input0': device_add
[    9.803314] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    9.807303] ACPI: Power Button [PWRF]
[    9.815697] driver: 'LNXPWRBN:00': driver_bound: bound to device 'button'
[    9.817062] bus: 'acpi': really_probe: bound device LNXPWRBN:00 to drive=
r button
[    9.825886] bus: 'acpi': add driver fan
[    9.835215] bus: 'acpi': add driver processor
[    9.845998] bus: 'acpi': driver_probe_device: matched device LNXCPU:00 w=
ith driver processor
[    9.848502] bus: 'acpi': really_probe: probing driver processor with dev=
ice LNXCPU:00
[    9.902570] device: 'cooling_device0': device_add
[    9.915673] driver: 'LNXCPU:00': driver_bound: bound to device 'processo=
r'
[    9.917029] bus: 'acpi': really_probe: bound device LNXCPU:00 to driver =
processor
[    9.928521] bus: 'acpi': driver_probe_device: matched device LNXCPU:01 w=
ith driver processor
[    9.929978] bus: 'acpi': really_probe: probing driver processor with dev=
ice LNXCPU:01
[    9.961998] driver: 'LNXCPU:01': driver_bound: bound to device 'processo=
r'
[    9.963370] bus: 'acpi': really_probe: bound device LNXCPU:01 to driver =
processor
[    9.973401] bus: 'acpi': add driver thermal
[    9.979378] bus: 'acpi': add driver battery
[   10.002243] device: 'ptyp0': device_add
[   10.012753] device: 'ptyp1': device_add
[   10.018225] device: 'ptyp2': device_add
[   10.029625] device: 'ptyp3': device_add
[   10.039298] device: 'ptyp4': device_add
[   10.049218] device: 'ptyp5': device_add
[   10.053995] device: 'ptyp6': device_add
[   10.066161] device: 'ptyp7': device_add
[   10.072180] device: 'ptyp8': device_add
[   10.082934] device: 'ptyp9': device_add
[   10.092841] device: 'ptypa': device_add
[   10.099287] device: 'ptypb': device_add
[   10.112141] device: 'ptypc': device_add
[   10.122806] device: 'ptypd': device_add
[   10.128904] device: 'ptype': device_add
[   10.139253] device: 'ptypf': device_add
[   10.152072] device: 'ptyq0': device_add
[   10.157122] device: 'ptyq1': device_add
[   10.169202] device: 'ptyq2': device_add
[   10.173916] device: 'ptyq3': device_add
[   10.185879] device: 'ptyq4': device_add
[   10.190664] device: 'ptyq5': device_add
[   10.202534] device: 'ptyq6': device_add
[   10.212052] device: 'ptyq7': device_add
[   10.222761] device: 'ptyq8': device_add
[   10.228737] device: 'ptyq9': device_add
[   10.239166] device: 'ptyqa': device_add
[   10.251873] device: 'ptyqb': device_add
[   10.256648] device: 'ptyqc': device_add
[   10.265851] device: 'ptyqd': device_add
[   10.278185] device: 'ptyqe': device_add
[   10.282935] device: 'ptyqf': device_add
[   10.292538] device: 'ptyr0': device_add
[   10.298351] device: 'ptyr1': device_add
[   10.309302] device: 'ptyr2': device_add
[   10.323132] device: 'ptyr3': device_add
[   10.336073] device: 'ptyr4': device_add
[   10.346094] device: 'ptyr5': device_add
[   10.352069] device: 'ptyr6': device_add
[   10.362965] device: 'ptyr7': device_add
[   10.372518] device: 'ptyr8': device_add
[   10.377286] device: 'ptyr9': device_add
[   10.389618] device: 'ptyra': device_add
[   10.399185] device: 'ptyrb': device_add
[   10.404146] device: 'ptyrc': device_add
[   10.416227] device: 'ptyrd': device_add
[   10.426175] device: 'ptyre': device_add
[   10.432214] device: 'ptyrf': device_add
[   10.442787] device: 'ptys0': device_add
[   10.453020] device: 'ptys1': device_add
[   10.458580] device: 'ptys2': device_add
[   10.469323] device: 'ptys3': device_add
[   10.479409] device: 'ptys4': device_add
[   10.485348] device: 'ptys5': device_add
[   10.496259] device: 'ptys6': device_add
[   10.506636] device: 'ptys7': device_add
[   10.512632] device: 'ptys8': device_add
[   10.522864] device: 'ptys9': device_add
[   10.532882] device: 'ptysa': device_add
[   10.542849] device: 'ptysb': device_add
[   10.548972] device: 'ptysc': device_add
[   10.559506] device: 'ptysd': device_add
[   10.569517] device: 'ptyse': device_add
[   10.579761] device: 'ptysf': device_add
[   10.589347] device: 'ptyt0': device_add
[   10.595526] device: 'ptyt1': device_add
[   10.606216] device: 'ptyt2': device_add
[   10.616332] device: 'ptyt3': device_add
[   10.626159] device: 'ptyt4': device_add
[   10.632243] device: 'ptyt5': device_add
[   10.642947] device: 'ptyt6': device_add
[   10.652923] device: 'ptyt7': device_add
[   10.662629] device: 'ptyt8': device_add
[   10.667507] device: 'ptyt9': device_add
[   10.679330] device: 'ptyta': device_add
[   10.692148] device: 'ptytb': device_add
[   10.697171] device: 'ptytc': device_add
[   10.709526] device: 'ptytd': device_add
[   10.715575] device: 'ptyte': device_add
[   10.726231] device: 'ptytf': device_add
[   10.736044] device: 'ptyu0': device_add
[   10.746344] device: 'ptyu1': device_add
[   10.752460] device: 'ptyu2': device_add
[   10.765370] device: 'ptyu3': device_add
[   10.776115] device: 'ptyu4': device_add
[   10.782194] device: 'ptyu5': device_add
[   10.792939] device: 'ptyu6': device_add
[   10.802864] device: 'ptyu7': device_add
[   10.816128] device: 'ptyu8': device_add
[   10.822166] device: 'ptyu9': device_add
[   10.832925] device: 'ptyua': device_add
[   10.839025] device: 'ptyub': device_add
[   10.849536] device: 'ptyuc': device_add
[   10.859503] device: 'ptyud': device_add
[   10.865526] device: 'ptyue': device_add
[   10.876289] device: 'ptyuf': device_add
[   10.886318] device: 'ptyv0': device_add
[   10.896306] device: 'ptyv1': device_add
[   10.906142] device: 'ptyv2': device_add
[   10.912101] device: 'ptyv3': device_add
[   10.922824] device: 'ptyv4': device_add
[   10.932877] device: 'ptyv5': device_add
[   10.942826] device: 'ptyv6': device_add
[   10.948910] device: 'ptyv7': device_add
[   10.959423] device: 'ptyv8': device_add
[   10.969435] device: 'ptyv9': device_add
[   10.979533] device: 'ptyva': device_add
[   10.989439] device: 'ptyvb': device_add
[   10.995469] device: 'ptyvc': device_add
[   11.006167] device: 'ptyvd': device_add
[   11.016136] device: 'ptyve': device_add
[   11.026223] device: 'ptyvf': device_add
[   11.036216] device: 'ptyw0': device_add
[   11.042668] device: 'ptyw1': device_add
[   11.055823] device: 'ptyw2': device_add
[   11.068364] device: 'ptyw3': device_add
[   11.073185] device: 'ptyw4': device_add
[   11.082777] device: 'ptyw5': device_add
[   11.092796] device: 'ptyw6': device_add
[   11.102773] device: 'ptyw7': device_add
[   11.112905] device: 'ptyw8': device_add
[   11.122920] device: 'ptyw9': device_add
[   11.129014] device: 'ptywa': device_add
[   11.139549] device: 'ptywb': device_add
[   11.149493] device: 'ptywc': device_add
[   11.159582] device: 'ptywd': device_add
[   11.165600] device: 'ptywe': device_add
[   11.176378] device: 'ptywf': device_add
[   11.186239] device: 'ptyx0': device_add
[   11.196361] device: 'ptyx1': device_add
[   11.206172] device: 'ptyx2': device_add
[   11.216191] device: 'ptyx3': device_add
[   11.222291] device: 'ptyx4': device_add
[   11.232782] device: 'ptyx5': device_add
[   11.242937] device: 'ptyx6': device_add
[   11.252884] device: 'ptyx7': device_add
[   11.258908] device: 'ptyx8': device_add
[   11.269450] device: 'ptyx9': device_add
[   11.279484] device: 'ptyxa': device_add
[   11.289502] device: 'ptyxb': device_add
[   11.295577] device: 'ptyxc': device_add
[   11.306356] device: 'ptyxd': device_add
[   11.319442] device: 'ptyxe': device_add
[   11.325676] device: 'ptyxf': device_add
[   11.336139] device: 'ptyy0': device_add
[   11.346328] device: 'ptyy1': device_add
[   11.356265] device: 'ptyy2': device_add
[   11.362368] device: 'ptyy3': device_add
[   11.375297] device: 'ptyy4': device_add
[   11.386150] device: 'ptyy5': device_add
[   11.396162] device: 'ptyy6': device_add
[   11.402335] device: 'ptyy7': device_add
[   11.412922] device: 'ptyy8': device_add
[   11.422888] device: 'ptyy9': device_add
[   11.432907] device: 'ptyya': device_add
[   11.439184] device: 'ptyyb': device_add
[   11.452102] device: 'ptyyc': device_add
[   11.462938] device: 'ptyyd': device_add
[   11.473023] device: 'ptyye': device_add
[   11.479230] device: 'ptyyf': device_add
[   11.492151] device: 'ptyz0': device_add
[   11.503027] device: 'ptyz1': device_add
[   11.510150] device: 'ptyz2': device_add
[   11.522937] device: 'ptyz3': device_add
[   11.532865] device: 'ptyz4': device_add
[   11.539659] device: 'ptyz5': device_add
[   11.549521] device: 'ptyz6': device_add
[   11.559650] device: 'ptyz7': device_add
[   11.569490] device: 'ptyz8': device_add
[   11.579564] device: 'ptyz9': device_add
[   11.589468] device: 'ptyza': device_add
[   11.595609] device: 'ptyzb': device_add
[   11.606128] device: 'ptyzc': device_add
[   11.622379] device: 'ptyzd': device_add
[   11.632583] device: 'ptyze': device_add
[   11.642326] device: 'ptyzf': device_add
[   11.655392] device: 'ptya0': device_add
[   11.666409] device: 'ptya1': device_add
[   11.676207] device: 'ptya2': device_add
[   11.682351] device: 'ptya3': device_add
[   11.695511] device: 'ptya4': device_add
[   11.706329] device: 'ptya5': device_add
[   11.712224] device: 'ptya6': device_add
[   11.722961] device: 'ptya7': device_add
[   11.732855] device: 'ptya8': device_add
[   11.742911] device: 'ptya9': device_add
[   11.748575] device: 'ptyaa': device_add
[   11.759513] device: 'ptyab': device_add
[   11.769487] device: 'ptyac': device_add
[   11.775599] device: 'ptyad': device_add
[   11.786167] device: 'ptyae': device_add
[   11.796248] device: 'ptyaf': device_add
[   11.806266] device: 'ptyb0': device_add
[   11.816338] device: 'ptyb1': device_add
[   11.822363] device: 'ptyb2': device_add
[   11.833587] device: 'ptyb3': device_add
[   11.846744] device: 'ptyb4': device_add
[   11.859555] device: 'ptyb5': device_add
[   11.865663] device: 'ptyb6': device_add
[   11.876174] device: 'ptyb7': device_add
[   11.886204] device: 'ptyb8': device_add
[   11.892042] device: 'ptyb9': device_add
[   11.902910] device: 'ptyba': device_add
[   11.912849] device: 'ptybb': device_add
[   11.918981] device: 'ptybc': device_add
[   11.929539] device: 'ptybd': device_add
[   11.939559] device: 'ptybe': device_add
[   11.949761] device: 'ptybf': device_add
[   11.962918] device: 'ptyc0': device_add
[   11.969287] device: 'ptyc1': device_add
[   11.982062] device: 'ptyc2': device_add
[   11.992906] device: 'ptyc3': device_add
[   11.999046] device: 'ptyc4': device_add
[   12.012137] device: 'ptyc5': device_add
[   12.022888] device: 'ptyc6': device_add
[   12.028950] device: 'ptyc7': device_add
[   12.039495] device: 'ptyc8': device_add
[   12.049578] device: 'ptyc9': device_add
[   12.059368] device: 'ptyca': device_add
[   12.065099] device: 'ptycb': device_add
[   12.076187] device: 'ptycc': device_add
[   12.086314] device: 'ptycd': device_add
[   12.099567] device: 'ptyce': device_add
[   12.125184] device: 'ptycf': device_add
[   12.136402] device: 'ptyd0': device_add
[   12.143347] device: 'ptyd1': device_add
[   12.153045] device: 'ptyd2': device_add
[   12.162835] device: 'ptyd3': device_add
[   12.172907] device: 'ptyd4': device_add
[   12.182945] device: 'ptyd5': device_add
[   12.189145] device: 'ptyd6': device_add
[   12.202135] device: 'ptyd7': device_add
[   12.212956] device: 'ptyd8': device_add
[   12.219157] device: 'ptyd9': device_add
[   12.235681] device: 'ptyda': device_add
[   12.241649] device: 'ptydb': device_add
[   12.250192] device: 'ptydc': device_add
[   12.262955] device: 'ptydd': device_add
[   12.276607] device: 'ptyde': device_add
[   12.289668] device: 'ptydf': device_add
[   12.296310] device: 'ptye0': device_add
[   12.310162] device: 'ptye1': device_add
[   12.316085] device: 'ptye2': device_add
[   12.332449] device: 'ptye3': device_add
[   12.338614] device: 'ptye4': device_add
[   12.349482] device: 'ptye5': device_add
[   12.359608] device: 'ptye6': device_add
[   12.369456] device: 'ptye7': device_add
[   12.375497] device: 'ptye8': device_add
[   12.386188] device: 'ptye9': device_add
[   12.396200] device: 'ptyea': device_add
[   12.406176] device: 'ptyeb': device_add
[   12.416199] device: 'ptyec': device_add
[   12.422358] device: 'ptyed': device_add
[   12.432785] device: 'ptyee': device_add
[   12.446476] device: 'ptyef': device_add
[   12.460355] device: 'ttyp0': device_add
[   12.473101] device: 'ttyp1': device_add
[   12.479563] device: 'ttyp2': device_add
[   12.509102] device: 'ttyp3': device_add
[   12.523260] device: 'ttyp4': device_add
[   12.536208] device: 'ttyp5': device_add
[   12.542403] device: 'ttyp6': device_add
[   12.555450] device: 'ttyp7': device_add
[   12.566182] device: 'ttyp8': device_add
[   12.579508] device: 'ttyp9': device_add
[   12.585634] device: 'ttypa': device_add
[   12.596254] device: 'ttypb': device_add
[   12.602423] device: 'ttypc': device_add
[   12.618933] device: 'ttypd': device_add
[   12.623919] device: 'ttype': device_add
[   12.636358] device: 'ttypf': device_add
[   12.642999] device: 'ttyq0': device_add
[   12.653050] device: 'ttyq1': device_add
[   12.662841] device: 'ttyq2': device_add
[   12.672888] device: 'ttyq3': device_add
[   12.682900] device: 'ttyq4': device_add
[   12.689119] device: 'ttyq5': device_add
[   12.701618] device: 'ttyq6': device_add
[   12.712841] device: 'ttyq7': device_add
[   12.719608] device: 'ttyq8': device_add
[   12.730201] device: 'ttyq9': device_add
[   12.742929] device: 'ttyqa': device_add
[   12.752811] device: 'ttyqb': device_add
[   12.762903] device: 'ttyqc': device_add
[   12.769084] device: 'ttyqd': device_add
[   12.779661] device: 'ttyqe': device_add
[   12.789347] device: 'ttyqf': device_add
[   12.802662] device: 'ttyr0': device_add
[   12.809569] device: 'ttyr1': device_add
[   12.819643] device: 'ttyr2': device_add
[   12.829557] device: 'ttyr3': device_add
[   12.839768] device: 'ttyr4': device_add
[   12.849565] device: 'ttyr5': device_add
[   12.882326] device: 'ttyr6': device_add
[   12.893291] device: 'ttyr7': device_add
[   12.899160] device: 'ttyr8': device_add
[   12.912504] device: 'ttyr9': device_add
[   12.925562] device: 'ttyra': device_add
[   12.936237] device: 'ttyrb': device_add
[   12.942447] device: 'ttyrc': device_add
[   12.958975] device: 'ttyrd': device_add
[   12.963926] device: 'ttyre': device_add
[   12.976284] device: 'ttyrf': device_add
[   12.982390] device: 'ttys0': device_add
[   12.995656] device: 'ttys1': device_add
[   13.006158] device: 'ttys2': device_add
[   13.016165] device: 'ttys3': device_add
[   13.022267] device: 'ttys4': device_add
[   13.032867] device: 'ttys5': device_add
[   13.042919] device: 'ttys6': device_add
[   13.052948] device: 'ttys7': device_add
[   13.059559] device: 'ttys8': device_add
[   13.069475] device: 'ttys9': device_add
[   13.079554] device: 'ttysa': device_add
[   13.089452] device: 'ttysb': device_add
[   13.099580] device: 'ttysc': device_add
[   13.110226] device: 'ttysd': device_add
[   13.122962] device: 'ttyse': device_add
[   13.129053] device: 'ttysf': device_add
[   13.139530] device: 'ttyt0': device_add
[   13.149733] device: 'ttyt1': device_add
[   13.159506] device: 'ttyt2': device_add
[   13.165638] device: 'ttyt3': device_add
[   13.176187] device: 'ttyt4': device_add
[   13.186141] device: 'ttyt5': device_add
[   13.196257] device: 'ttyt6': device_add
[   13.201985] device: 'ttyt7': device_add
[   13.212927] device: 'ttyt8': device_add
[   13.222982] device: 'ttyt9': device_add
[   13.232833] device: 'ttyta': device_add
[   13.238977] device: 'ttytb': device_add
[   13.249448] device: 'ttytc': device_add
[   13.259494] device: 'ttytd': device_add
[   13.269521] device: 'ttyte': device_add
[   13.279665] device: 'ttytf': device_add
[   13.286485] device: 'ttyu0': device_add
[   13.296449] device: 'ttyu1': device_add
[   13.309425] device: 'ttyu2': device_add
[   13.315745] device: 'ttyu3': device_add
[   13.326129] device: 'ttyu4': device_add
[   13.336226] device: 'ttyu5': device_add
[   13.346258] device: 'ttyu6': device_add
[   13.356082] device: 'ttyu7': device_add
[   13.362337] device: 'ttyu8': device_add
[   13.375555] device: 'ttyu9': device_add
[   13.386364] device: 'ttyua': device_add
[   13.396196] device: 'ttyub': device_add
[   13.402320] device: 'ttyuc': device_add
[   13.412652] device: 'ttyud': device_add
[   13.425831] device: 'ttyue': device_add
[   13.439054] device: 'ttyuf': device_add
[   13.444980] device: 'ttyv0': device_add
[   13.456364] device: 'ttyv1': device_add
[   13.462569] device: 'ttyv2': device_add
[   13.476790] device: 'ttyv3': device_add
[   13.490070] device: 'ttyv4': device_add
[   13.503086] device: 'ttyv5': device_add
[   13.509240] device: 'ttyv6': device_add
[   13.522782] device: 'ttyv7': device_add
[   13.533000] device: 'ttyv8': device_add
[   13.542829] device: 'ttyv9': device_add
[   13.552868] device: 'ttyva': device_add
[   13.562911] device: 'ttyvb': device_add
[   13.569129] device: 'ttyvc': device_add
[   13.582106] device: 'ttyvd': device_add
[   13.593044] device: 'ttyve': device_add
[   13.599224] device: 'ttyvf': device_add
[   13.625554] device: 'ttyw0': device_add
[   13.631736] device: 'ttyw1': device_add
[   13.642906] device: 'ttyw2': device_add
[   13.652927] device: 'ttyw3': device_add
[   13.659065] device: 'ttyw4': device_add
[   13.669538] device: 'ttyw5': device_add
[   13.679590] device: 'ttyw6': device_add
[   13.689512] device: 'ttyw7': device_add
[   13.702780] device: 'ttyw8': device_add
[   13.708950] device: 'ttyw9': device_add
[   13.719553] device: 'ttywa': device_add
[   13.729540] device: 'ttywb': device_add
[   13.735866] device: 'ttywc': device_add
[   13.748852] device: 'ttywd': device_add
[   13.759504] device: 'ttywe': device_add
[   13.765755] device: 'ttywf': device_add
[   13.778824] device: 'ttyx0': device_add
[   13.789659] device: 'ttyx1': device_add
[   13.795909] device: 'ttyx2': device_add
[   13.809185] device: 'ttyx3': device_add
[   13.822389] device: 'ttyx4': device_add
[   13.835346] device: 'ttyx5': device_add
[   13.840293] device: 'ttyx6': device_add
[   13.852887] device: 'ttyx7': device_add
[   13.858958] device: 'ttyx8': device_add
[   13.869519] device: 'ttyx9': device_add
[   13.879482] device: 'ttyxa': device_add
[   13.889489] device: 'ttyxb': device_add
[   13.895781] device: 'ttyxc': device_add
[   13.908870] device: 'ttyxd': device_add
[   13.919546] device: 'ttyxe': device_add
[   13.929569] device: 'ttyxf': device_add
[   13.936223] device: 'ttyy0': device_add
[   13.946313] device: 'ttyy1': device_add
[   13.956254] device: 'ttyy2': device_add
[   13.966189] device: 'ttyy3': device_add
[   13.976227] device: 'ttyy4': device_add
[   13.986182] device: 'ttyy5': device_add
[   13.992322] device: 'ttyy6': device_add
[   14.002801] device: 'ttyy7': device_add
[   14.016594] device: 'ttyy8': device_add
[   14.022581] device: 'ttyy9': device_add
[   14.039001] device: 'ttyya': device_add
[   14.045120] device: 'ttyyb': device_add
[   14.056263] device: 'ttyyc': device_add
[   14.066264] device: 'ttyyd': device_add
[   14.072488] device: 'ttyye': device_add
[   14.085727] device: 'ttyyf': device_add
[   14.098805] device: 'ttyz0': device_add
[   14.109840] device: 'ttyz1': device_add
[   14.115956] device: 'ttyz2': device_add
[   14.129493] device: 'ttyz3': device_add
[   14.135695] device: 'ttyz4': device_add
[   14.148858] device: 'ttyz5': device_add
[   14.159542] device: 'ttyz6': device_add
[   14.166175] device: 'ttyz7': device_add
[   14.176053] device: 'ttyz8': device_add
[   14.186077] device: 'ttyz9': device_add
[   14.196183] device: 'ttyza': device_add
[   14.205986] device: 'ttyzb': device_add
[   14.211618] device: 'ttyzc': device_add
[   14.222850] device: 'ttyzd': device_add
[   14.228519] device: 'ttyze': device_add
[   14.239522] device: 'ttyzf': device_add
[   14.249433] device: 'ttya0': device_add
[   14.255575] device: 'ttya1': device_add
[   14.266158] device: 'ttya2': device_add
[   14.276091] device: 'ttya3': device_add
[   14.286096] device: 'ttya4': device_add
[   14.292138] device: 'ttya5': device_add
[   14.302841] device: 'ttya6': device_add
[   14.312902] device: 'ttya7': device_add
[   14.322787] device: 'ttya8': device_add
[   14.328783] device: 'ttya9': device_add
[   14.339544] device: 'ttyaa': device_add
[   14.349540] device: 'ttyab': device_add
[   14.355599] device: 'ttyac': device_add
[   14.366145] device: 'ttyad': device_add
[   14.376178] device: 'ttyae': device_add
[   14.386159] device: 'ttyaf': device_add
[   14.392250] device: 'ttyb0': device_add
[   14.402754] device: 'ttyb1': device_add
[   14.415611] device: 'ttyb2': device_add
[   14.420558] device: 'ttyb3': device_add
[   14.432810] device: 'ttyb4': device_add
[   14.438762] device: 'ttyb5': device_add
[   14.449445] device: 'ttyb6': device_add
[   14.459357] device: 'ttyb7': device_add
[   14.469464] device: 'ttyb8': device_add
[   14.475880] device: 'ttyb9': device_add
[   14.487297] device: 'ttyba': device_add
[   14.499522] device: 'ttybb': device_add
[   14.505285] device: 'ttybc': device_add
[   14.516936] device: 'ttybd': device_add
[   14.529321] device: 'ttybe': device_add
[   14.535558] device: 'ttybf': device_add
[   14.546149] device: 'ttyc0': device_add
[   14.552240] device: 'ttyc1': device_add
[   14.562591] device: 'ttyc2': device_add
[   14.575391] device: 'ttyc3': device_add
[   14.580391] device: 'ttyc4': device_add
[   14.592816] device: 'ttyc5': device_add
[   14.598779] device: 'ttyc6': device_add
[   14.609499] device: 'ttyc7': device_add
[   14.619421] device: 'ttyc8': device_add
[   14.629428] device: 'ttyc9': device_add
[   14.635364] device: 'ttyca': device_add
[   14.646140] device: 'ttycb': device_add
[   14.656081] device: 'ttycc': device_add
[   14.662045] device: 'ttycd': device_add
[   14.672948] device: 'ttyce': device_add
[   14.682691] device: 'ttycf': device_add
[   14.692814] device: 'ttyd0': device_add
[   14.698926] device: 'ttyd1': device_add
[   14.709241] device: 'ttyd2': device_add
[   14.721821] device: 'ttyd3': device_add
[   14.726860] device: 'ttyd4': device_add
[   14.736029] device: 'ttyd5': device_add
[   14.746092] device: 'ttyd6': device_add
[   14.756103] device: 'ttyd7': device_add
[   14.762125] device: 'ttyd8': device_add
[   14.772672] device: 'ttyd9': device_add
[   14.782963] device: 'ttyda': device_add
[   14.788693] device: 'ttydb': device_add
[   14.799521] device: 'ttydc': device_add
[   14.809474] device: 'ttydd': device_add
[   14.815479] device: 'ttyde': device_add
[   14.826074] device: 'ttydf': device_add
[   14.836213] device: 'ttye0': device_add
[   14.846284] device: 'ttye1': device_add
[   14.851949] device: 'ttye2': device_add
[   14.862868] device: 'ttye3': device_add
[   14.872785] device: 'ttye4': device_add
[   14.878878] device: 'ttye5': device_add
[   14.889497] device: 'ttye6': device_add
[   14.899484] device: 'ttye7': device_add
[   14.909552] device: 'ttye8': device_add
[   14.915645] device: 'ttye9': device_add
[   14.926168] device: 'ttyea': device_add
[   14.936269] device: 'ttyeb': device_add
[   14.946124] device: 'ttyec': device_add
[   14.952147] device: 'ttyed': device_add
[   14.962829] device: 'ttyee': device_add
[   14.972918] device: 'ttyef': device_add
[   14.980353] device: 'ptmx': device_add
[   14.993265] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   15.003364] Registering platform device 'serial8250'. Parent at platform
[   15.011946] device: 'serial8250': device_add
[   15.013156] bus: 'platform': add device serial8250
[   15.079148] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   15.082220] device: 'ttyS0': device_add
[   15.119349] device: 'ttyS1': device_add
[   15.135504] device: 'ttyS2': device_add
[   15.149936] device: 'ttyS3': device_add
[   15.163598] bus: 'platform': add driver serial8250
[   15.166191] bus: 'platform': driver_probe_device: matched device serial8=
250 with driver serial8250
[   15.175306] bus: 'platform': really_probe: probing driver serial8250 wit=
h device serial8250
[   15.178579] driver: 'serial8250': driver_bound: bound to device 'serial8=
250'
[   15.179985] bus: 'platform': really_probe: bound device serial8250 to dr=
iver serial8250
[   15.189641] bus: 'pnp': add driver serial
[   15.192924] bus: 'pnp': driver_probe_device: matched device 00:06 with d=
river serial
[   15.201781] bus: 'pnp': really_probe: probing driver serial with device =
00:06
[   15.270863] device: 'ttyS0': device_unregister
[   15.339501] device: 'ttyS0': device_create_release
[   15.392025] 00:06: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   15.393359] device: 'ttyS0': device_add
[   15.407159] driver: '00:06': driver_bound: bound to device 'serial'
[   15.415386] bus: 'pnp': really_probe: bound device 00:06 to driver serial
[   15.418994] bus: 'pci': add driver serial
[   15.442219] device: 'ttyprintk': device_add
[   15.456121] bus: 'pnp': add driver i8042 kbd
[   15.465072] bus: 'pnp': driver_probe_device: matched device 00:02 with d=
river i8042 kbd
[   15.466471] bus: 'pnp': really_probe: probing driver i8042 kbd with devi=
ce 00:02
[   15.476477] driver: '00:02': driver_bound: bound to device 'i8042 kbd'
[   15.479058] bus: 'pnp': really_probe: bound device 00:02 to driver i8042=
 kbd
[   15.482433] bus: 'pnp': add driver i8042 aux
[   15.483941] bus: 'pnp': driver_probe_device: matched device 00:03 with d=
river i8042 aux
[   15.498397] bus: 'pnp': really_probe: probing driver i8042 aux with devi=
ce 00:03
[   15.500525] driver: '00:03': driver_bound: bound to device 'i8042 aux'
[   15.502891] bus: 'pnp': really_probe: bound device 00:03 to driver i8042=
 aux
[   15.506163] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   15.516225] Registering platform device 'i8042'. Parent at platform
[   15.518274] device: 'i8042': device_add
[   15.519452] bus: 'platform': add device i8042
[   15.529518] bus: 'platform': add driver i8042
[   15.532011] bus: 'platform': driver_probe_device: matched device i8042 w=
ith driver i8042
[   15.533381] bus: 'platform': really_probe: probing driver i8042 with dev=
ice i8042
[   15.571972] serio: i8042 KBD port at 0x60,0x64 irq 1
[   15.583799] device: 'serio0': device_add
[   15.586406] serio: i8042 AUX port at 0x60,0x64 irq 12
[   15.588666] driver: 'i8042': driver_bound: bound to device 'i8042'
[   15.589920] bus: 'platform': really_probe: bound device i8042 to driver =
i8042
[   15.603274] bus: 'serio': add driver atkbd
[   15.608822] bus: 'serio': add device serio0
[   15.620542] bus: 'serio': driver_probe_device: matched device serio0 wit=
h driver atkbd
[   15.632324] cpuidle: using governor ladder
[   15.633649] cpuidle: using governor menu
[   15.635770] bus: 'serio': really_probe: probing driver atkbd with device=
 serio0
[   15.709496] TCP: cubic registered
[   15.716314]=20
[   15.716314] printing PIC contents
[   15.725357] ... PIC  IMR: edf8
[   15.726057] ... PIC  IRR: 0010
[   15.726738] ... PIC  ISR: 0000
[   15.735152] ... PIC ELCR: 0200
[   15.736918] device: 'cpu_dma_latency': device_add
[   15.740206] device: 'input1': device_add
[   15.756434] device: 'network_latency': device_add
[   15.769811] device: 'network_throughput': device_add
[   15.795546] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   15.819409] driver: 'serio0': driver_bound: bound to device 'atkbd'
[   15.828636] bus: 'serio': really_probe: bound device serio0 to driver at=
kbd
[   15.842516] device: 'serio1': device_add
[   15.852630] bus: 'serio': add device serio1
[   15.866127] bus: 'serio': driver_probe_device: matched device serio1 wit=
h driver atkbd
[   15.875359] bus: 'serio': really_probe: probing driver atkbd with device=
 serio1
[   15.900939] atkbd: probe of serio1 rejects match -19
[   15.915739] /c/kernel-tests/src/tip/drivers/rtc/hctosys.c: unable to ope=
n rtc device (rtc0)
[   15.919741] bus: 'serio': driver_probe_device: matched device serio1 wit=
h driver atkbd
[   15.931907] bus: 'serio': really_probe: probing driver atkbd with device=
 serio1
[   15.952392] atkbd: probe of serio1 rejects match -19
[   37.028547] CPA self-test:
[   37.030434]  4k 1022 large 126 gb 0 x 633[ffff880000000000-ffff88000fc00=
000] miss 0
[   39.477104]  4k 63486 large 4 gb 0 x 62975[ffff880000000000-ffff88000fdf=
f000] miss 0
[   41.950624]  4k 63486 large 4 gb 0 x 62975[ffff880000000000-ffff88000fdf=
f000] miss 0
[   41.958230] ok.
[   52.573574] Freeing initrd memory: 23656k freed
[   52.955920] Freeing unused kernel memory: 2172k freed
[   53.048653] Write protecting the kernel read-only data: 6144k
[   53.219585] Testing CPA: undo ffffffff81000000-ffffffff81600000
[   53.401642] Testing CPA: again
[   53.941948] Freeing unused kernel memory: 1712k freed
[   53.993038] Freeing unused kernel memory: 872k freed
modprobe: FATAL: Could not load /lib/modules/3.5.4-00413-g5feeb5e/modules.d=
ep: No such file or directory

[   55.055118] modprobe (36) used greatest stack depth: 5384 bytes left
[   58.951310] sh (40) used greatest stack depth: 5152 bytes left
[   59.993940] VFS: Close: file count is 0
[   60.027192] ------------[ cut here ]------------
[   60.031761] WARNING: at /c/kernel-tests/src/tip/lib/list_debug.c:29 __li=
st_add+0x3d/0xad()
[   60.034934] list_add corruption. next->prev should be prev (ffff88000dbd=
5658), but was ffffffff810c2c8c. (next=3Dffff880006b8de00).
[   60.037075] Modules linked in:
[   60.040217] Pid: 44, comm: modprobe Not tainted 3.5.4-00413-g5feeb5e #22=
53
[   60.042560] Call Trace:
[   60.043470]  [<ffffffff810260e2>] warn_slowpath_common+0x62/0x79
[   60.045429]  [<ffffffff8102618d>] warn_slowpath_fmt+0x41/0x43
[   60.046500]  [<ffffffff810c2c8c>] ? sys_sendfile64+0x8d/0x8d
[   60.048339]  [<ffffffff81145fb8>] __list_add+0x3d/0xad
[   60.049319]  [<ffffffff810c3503>] file_sb_list_add+0x41/0x52
[   60.050372]  [<ffffffff810c13bd>] __dentry_open.isra.20+0xf8/0x276
[   60.052266]  [<ffffffff8111ada0>] ? common_lsm_audit+0x79/0x79
[   60.053335]  [<ffffffff810c1565>] vfs_open+0x2a/0x2c
[   60.055335]  [<ffffffff810c1668>] nameidata_to_filp+0x3d/0x7f
[   60.056402]  [<ffffffff810ce5d9>] do_last+0x795/0x7d9
[   60.058128]  [<ffffffff810ce7f3>] path_openat+0xce/0x36c
[   60.059137]  [<ffffffff81007a6d>] ? native_sched_clock+0x29/0x6f
[   60.060242]  [<ffffffff81007abc>] ? sched_clock+0x9/0xd
[   60.062068]  [<ffffffff810ceb7d>] do_filp_open+0x33/0x81
[   60.063107]  [<ffffffff81249609>] ? _raw_spin_unlock+0x24/0x48
[   60.064982]  [<ffffffff810d9074>] ? alloc_fd+0xe0/0xf2
[   60.065988]  [<ffffffff810c17b3>] do_sys_open+0x109/0x196
[   60.067040]  [<ffffffff810c185c>] sys_open+0x1c/0x1e
[   60.068980]  [<ffffffff8124e6f9>] system_call_fastpath+0x16/0x1b
[   60.070290] ---[ end trace 2f0c9a78a81db484 ]---
[   60.077875] BUG: unable to handle kernel paging request at 00000000ff880=
05c
[   60.077875] IP: [<ffff880006b8d387>] 0xffff880006b8d386
[   60.077875] PGD 6b89067 PUD 0=20
[   60.077875] Oops: 0000 [#1] PREEMPT SMP=20
[   60.077875] CPU 0=20
[   60.077875] Modules linked in:
[   60.077875]=20
[   60.077875] Pid: 42, comm: sh Tainted: G        W    3.5.4-00413-g5feeb5=
e #2253 =20
[   60.077875] RIP: 0010:[<ffff880006b8d387>]  [<ffff880006b8d387>] 0xffff8=
80006b8d386
[   60.077875] RSP: 0000:ffff88000da03e58  EFLAGS: 00000202
[   60.077875] RAX: 00000000ff880006 RBX: ffffffff81619b40 RCX: 00000000000=
20d00
[   60.077875] RDX: 000000000000400a RSI: ffff88000dbd53d0 RDI: ffff880006b=
8de00
[   60.077875] RBP: ffff88000da03ec0 R08: 00000000001d53d0 R09: 00000000000=
041a1
[   60.077875] R10: 00000000000041a1 R11: ffff8800080ad708 R12: ffff88000db=
cd7f0
[   60.077875] R13: ffff88000d0f27e0 R14: ffff880006b8de00 R15: ffff88000db=
cd7c0
[   60.077875] FS:  00007f1cd2689700(0000) GS:ffff88000da00000(0000) knlGS:=
0000000000000000
[   60.077875] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   60.077875] CR2: 00000000ff88005c CR3: 0000000006b65000 CR4: 00000000000=
006b0
[   60.077875] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[   60.077875] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 00000000000=
00000
[   60.077875] Process sh (pid: 42, threadinfo ffff880006b5a000, task ffff8=
8000cb1d9b0)
[   60.077875] Stack:
[   60.077875]  ffffffff81080b67 ffff88000da03e60 ffff88000cb1d9b0 ffff8800=
06b5bfd8
[   60.077875]  ffff88000d0f27e0 0000000100000000 ffff88000000000a 00000000=
0000000a
[   60.077875]  ffffffff81604148 0000000000000001 ffff880006b5bfd8 00000000=
0000000a
[   60.077875] Call Trace:
[   60.077875]  <IRQ>=20
[   60.077875]  [<ffffffff81080b67>] ? __rcu_process_callbacks+0x260/0x3e7
[   60.077875]  [<ffffffff81080d46>] rcu_process_callbacks+0x58/0x5a
[   60.077875]  [<ffffffff8102c648>] __do_softirq+0xa2/0x144
[   60.077875]  [<ffffffff81249609>] ? _raw_spin_unlock+0x24/0x48
[   60.077875]  [<ffffffff8124faac>] call_softirq+0x1c/0x30
[   60.077875]  [<ffffffff81003a7a>] do_softirq+0x45/0x9f
[   60.077875]  [<ffffffff8102c98e>] irq_exit+0x4c/0xb7
[   60.077875]  [<ffffffff81003890>] do_IRQ+0x98/0xaf
[   60.077875]  [<ffffffff81249a2f>] common_interrupt+0x6f/0x6f
[   60.077875]  <EOI>=20
[   60.077875]  [<ffffffff81249ad9>] ? retint_swapgs+0x13/0x1b
[   60.077875] Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 de b8 06 00 88 ff =
<ff> 58 56 bd 0d 00 88 ff ff 20 21 01 0d 00 88 ff ff 28 35 c0 0c=20
[   60.077875] RIP  [<ffff880006b8d387>] 0xffff880006b8d386
[   60.077875]  RSP <ffff88000da03e58>
[   60.077875] CR2: 00000000ff88005c
[   60.151696] ---[ end trace 2f0c9a78a81db485 ]---
[   60.153147] Kernel panic - not syncing: Fatal exception in interrupt
[   60.157060] Rebooting in 10 seconds..
--MW5yreqqjyrRcusr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.5.4-00413-g5feeb5e"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.5.4 Kernel Configuration
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
# CONFIG_GENERIC_ISA_DMA is not set
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
# CONFIG_ARCH_MAY_HAVE_PC_FDC is not set
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_INIT_PASS_ALL_PARAMS is not set
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_VERSION_SIGNATURE=""
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_POSIX_MQUEUE=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_FHANDLE is not set
# CONFIG_TASKSTATS is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
# CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_BOOST is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_CGROUP_MEM_RES_CTLR is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
CONFIG_RD_LZO=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
CONFIG_AIO=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLK_DEV_THROTTLING=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
# CONFIG_ACORN_PARTITION_EESOX is not set
# CONFIG_ACORN_PARTITION_ICS is not set
# CONFIG_ACORN_PARTITION_ADFS is not set
# CONFIG_ACORN_PARTITION_POWERTEC is not set
CONFIG_ACORN_PARTITION_RISCIX=y
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
# CONFIG_MSDOS_PARTITION is not set
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=m
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PADATA=y
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
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
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
# CONFIG_KVM_CLOCK is not set
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
# CONFIG_I8K is not set
CONFIG_MICROCODE=m
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_HOTPLUG_CPU is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_INTEL_IDLE=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
# CONFIG_ISA_DMA_API is not set
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=m
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=m
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_IPCOMP=m
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
# CONFIG_IP_MULTIPLE_TABLES is not set
CONFIG_IP_ROUTE_MULTIPATH=y
# CONFIG_IP_ROUTE_VERBOSE is not set
CONFIG_IP_PNP=y
# CONFIG_IP_PNP_DHCP is not set
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
# CONFIG_NET_IPIP is not set
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IPGRE=m
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
CONFIG_INET_XFRM_MODE_TUNNEL=m
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=m
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_BEET is not set
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=m
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
# CONFIG_NF_CONNTRACK_FTP is not set
CONFIG_NF_CONNTRACK_IRC=m
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_SIP is not set
CONFIG_NF_CT_NETLINK=m
CONFIG_NETFILTER_XTABLES=m

#
# Xtables combined modules
#
# CONFIG_NETFILTER_XT_MARK is not set

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_LOG is not set
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m

#
# Xtables matches
#
# CONFIG_NETFILTER_XT_MATCH_CONNTRACK is not set
CONFIG_NETFILTER_XT_MATCH_POLICY=m
# CONFIG_NETFILTER_XT_MATCH_STATE is not set
CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
# CONFIG_IP_SET_BITMAP_PORT is not set
# CONFIG_IP_SET_HASH_IP is not set
CONFIG_IP_SET_HASH_IPPORT=m
# CONFIG_IP_SET_HASH_IPPORTIP is not set
CONFIG_IP_SET_HASH_IPPORTNET=m
# CONFIG_IP_SET_HASH_NET is not set
# CONFIG_IP_SET_HASH_NETPORT is not set
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
# CONFIG_IP_VS_IPV6 is not set
CONFIG_IP_VS_DEBUG=y
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
# CONFIG_IP_VS_PROTO_UDP is not set
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
# CONFIG_IP_VS_PROTO_AH is not set
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
# CONFIG_IP_VS_RR is not set
# CONFIG_IP_VS_WRR is not set
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
# CONFIG_IP_VS_LBLCR is not set
# CONFIG_IP_VS_DH is not set
CONFIG_IP_VS_SH=m
# CONFIG_IP_VS_SED is not set
CONFIG_IP_VS_NQ=m

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#
# CONFIG_IP_VS_NFCT is not set

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
# CONFIG_NF_CONNTRACK_IPV4 is not set
# CONFIG_IP_NF_IPTABLES is not set

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
# CONFIG_IP6_NF_FILTER is not set
CONFIG_IP6_NF_MANGLE=m
# CONFIG_IP6_NF_RAW is not set
CONFIG_BRIDGE_NF_EBTABLES=m
# CONFIG_BRIDGE_EBT_BROUTE is not set
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
# CONFIG_BRIDGE_EBT_AMONG is not set
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
# CONFIG_BRIDGE_EBT_IP6 is not set
# CONFIG_BRIDGE_EBT_LIMIT is not set
CONFIG_BRIDGE_EBT_MARK=m
# CONFIG_BRIDGE_EBT_PKTTYPE is not set
# CONFIG_BRIDGE_EBT_STP is not set
# CONFIG_BRIDGE_EBT_VLAN is not set
CONFIG_BRIDGE_EBT_ARPREPLY=m
# CONFIG_BRIDGE_EBT_DNAT is not set
CONFIG_BRIDGE_EBT_MARK_T=m
# CONFIG_BRIDGE_EBT_REDIRECT is not set
CONFIG_BRIDGE_EBT_SNAT=m
# CONFIG_BRIDGE_EBT_LOG is not set
# CONFIG_BRIDGE_EBT_ULOG is not set
CONFIG_BRIDGE_EBT_NFLOG=m
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_HMAC_NONE is not set
CONFIG_SCTP_HMAC_SHA1=y
# CONFIG_SCTP_HMAC_MD5 is not set
# CONFIG_RDS is not set
CONFIG_TIPC=m
CONFIG_TIPC_ADVANCED=y
CONFIG_TIPC_PORTS=8191
CONFIG_TIPC_LOG=0
# CONFIG_TIPC_DEBUG is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
CONFIG_STP=m
CONFIG_BRIDGE=m
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=m
CONFIG_LLC2=m
CONFIG_IPX=m
CONFIG_IPX_INTERN=y
# CONFIG_ATALK is not set
CONFIG_X25=m
# CONFIG_LAPB is not set
CONFIG_WAN_ROUTER=m
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
CONFIG_NET_SCH_SFB=m
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
CONFIG_NET_SCH_DRR=m
# CONFIG_NET_SCH_MQPRIO is not set
# CONFIG_NET_SCH_CHOKE is not set
CONFIG_NET_SCH_QFQ=m
# CONFIG_NET_SCH_CODEL is not set
# CONFIG_NET_SCH_FQ_CODEL is not set
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
CONFIG_NET_CLS_TCINDEX=m
# CONFIG_NET_CLS_ROUTE4 is not set
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
# CONFIG_CLS_U32_PERF is not set
CONFIG_CLS_U32_MARK=y
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_CLS_CGROUP=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
# CONFIG_NET_EMATCH_NBYTE is not set
# CONFIG_NET_EMATCH_U32 is not set
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
# CONFIG_NET_CLS_ACT is not set
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=m
CONFIG_BATMAN_ADV=m
CONFIG_BATMAN_ADV_BLA=y
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=m
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NETPRIO_CGROUP=m
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set

#
# Network testing
#
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=m
CONFIG_AX25_DAMA_SLAVE=y
CONFIG_NETROM=m
# CONFIG_ROSE is not set

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
# CONFIG_6PACK is not set
# CONFIG_BPQETHER is not set
CONFIG_BAYCOM_SER_FDX=m
CONFIG_BAYCOM_SER_HDX=m
CONFIG_YAM=m
# CONFIG_CAN is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
CONFIG_IRCOMM=m
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
# CONFIG_IRDA_FAST_RR is not set
CONFIG_IRDA_DEBUG=y

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=m

#
# Dongle support
#
# CONFIG_DONGLE is not set

#
# FIR device drivers
#
# CONFIG_VLSI_FIR is not set
CONFIG_BT=m
CONFIG_BT_RFCOMM=m
# CONFIG_BT_RFCOMM_TTY is not set
CONFIG_BT_BNEP=m
# CONFIG_BT_BNEP_MC_FILTER is not set
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_CMTP=m
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_ATH3K=y
CONFIG_BT_HCIUART_LL=y
# CONFIG_BT_HCIVHCI is not set
CONFIG_BT_MRVL=m
CONFIG_AF_RXRPC=m
# CONFIG_AF_RXRPC_DEBUG is not set
# CONFIG_RXKAD is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_CFG80211=m
CONFIG_NL80211_TESTMODE=y
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
CONFIG_CFG80211_REG_DEBUG=y
# CONFIG_CFG80211_DEFAULT_PS is not set
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
# CONFIG_WIRELESS_EXT_SYSFS is not set
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_PID=y
# CONFIG_MAC80211_RC_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT_PID=y
CONFIG_MAC80211_RC_DEFAULT="pid"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
CONFIG_MAC80211_DEBUG_MENU=y
CONFIG_MAC80211_NOINLINE=y
# CONFIG_MAC80211_VERBOSE_DEBUG is not set
# CONFIG_MAC80211_HT_DEBUG is not set
# CONFIG_MAC80211_TKIP_DEBUG is not set
CONFIG_MAC80211_IBSS_DEBUG=y
# CONFIG_MAC80211_VERBOSE_PS_DEBUG is not set
# CONFIG_MAC80211_VERBOSE_MPL_DEBUG is not set
# CONFIG_MAC80211_VERBOSE_MPATH_DEBUG is not set
# CONFIG_MAC80211_VERBOSE_MHWMP_DEBUG is not set
# CONFIG_MAC80211_VERBOSE_MESH_SYNC_DEBUG is not set
# CONFIG_MAC80211_VERBOSE_TDLS_DEBUG is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
CONFIG_RFKILL_REGULATOR=m
CONFIG_NET_9P=m
# CONFIG_NET_9P_VIRTIO is not set
CONFIG_NET_9P_DEBUG=y
CONFIG_CAIF=m
CONFIG_CAIF_DEBUG=y
# CONFIG_CAIF_NETDEV is not set
CONFIG_CAIF_USB=m
CONFIG_CEPH_LIB=m
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
CONFIG_NFC=m
# CONFIG_NFC_NCI is not set
# CONFIG_NFC_HCI is not set
CONFIG_NFC_LLCP=y

#
# Near Field Communication (NFC) devices
#
# CONFIG_PN544_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=m
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPI=y
# CONFIG_DMA_SHARED_BUFFER is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=m
# CONFIG_BLK_DEV_HD is not set
CONFIG_BLK_DEV_RBD=m

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=m
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=m
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=m
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=m
CONFIG_DS1682=m
CONFIG_TI_DAC7512=m
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
# CONFIG_BMP085_SPI is not set
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=m
CONFIG_C2PORT=m
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
CONFIG_EEPROM_93XX46=m
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
# CONFIG_INTEL_MEI is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=m
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
CONFIG_SCSI_FC_ATTRS=m
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=m
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=m
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=m
CONFIG_SCSI_DH_RDAC=m
CONFIG_SCSI_DH_HP_SW=m
CONFIG_SCSI_DH_EMC=m
CONFIG_SCSI_DH_ALUA=m
# CONFIG_SCSI_OSD_INITIATOR is not set
# CONFIG_ATA is not set
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
# CONFIG_NETDEVICES is not set
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
CONFIG_ISDN_CAPI=m
# CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON is not set
CONFIG_CAPI_TRACE=y
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPI20=m

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
# CONFIG_ISDN_DRV_AVMB1_B1PCI is not set
# CONFIG_ISDN_DRV_AVMB1_T1PCI is not set
# CONFIG_ISDN_DRV_AVMB1_C4 is not set
# CONFIG_CAPI_EICON is not set
# CONFIG_ISDN_DRV_GIGASET is not set
CONFIG_MISDN=m
# CONFIG_MISDN_DSP is not set
# CONFIG_MISDN_L1OIP is not set

#
# mISDN hardware drivers
#
# CONFIG_MISDN_HFCPCI is not set
# CONFIG_MISDN_HFCMULTI is not set
# CONFIG_MISDN_AVMFRITZ is not set
# CONFIG_MISDN_SPEEDFAX is not set
# CONFIG_MISDN_INFINEON is not set
# CONFIG_MISDN_W6692 is not set
# CONFIG_MISDN_NETJET is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ADP5589=m
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_TCA6416=m
# CONFIG_KEYBOARD_TCA8418 is not set
CONFIG_KEYBOARD_LM8323=m
# CONFIG_KEYBOARD_LM8333 is not set
CONFIG_KEYBOARD_MAX7359=m
# CONFIG_KEYBOARD_MCS is not set
CONFIG_KEYBOARD_MPR121=m
CONFIG_KEYBOARD_NEWTON=m
CONFIG_KEYBOARD_OPENCORES=m
CONFIG_KEYBOARD_STOWAWAY=m
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_OMAP4 is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
CONFIG_MOUSE_SERIAL=m
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
CONFIG_JOYSTICK_A3D=m
# CONFIG_JOYSTICK_ADI is not set
CONFIG_JOYSTICK_COBRA=m
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=m
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
CONFIG_JOYSTICK_MAGELLAN=m
# CONFIG_JOYSTICK_SPACEORB is not set
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=m
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_ZHENHUA=m
# CONFIG_JOYSTICK_AS5011 is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=m
# CONFIG_TOUCHSCREEN_AD7877 is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=m
CONFIG_TOUCHSCREEN_BU21013=m
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=m
CONFIG_TOUCHSCREEN_EGALAX=m
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=m
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=m
CONFIG_TOUCHSCREEN_MAX11801=m
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_INEXIO=m
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_PENMOUNT=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
CONFIG_TOUCHSCREEN_TOUCHWIN=m
CONFIG_TOUCHSCREEN_PIXCIR=m
CONFIG_TOUCHSCREEN_WM831X=m
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_MC13783 is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_TOUCHSCREEN_TSC_SERIO=m
# CONFIG_TOUCHSCREEN_TSC2005 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=m
CONFIG_SERIO_PS2MULT=m
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=m
# CONFIG_SERIAL_MAX3107 is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=m
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_XILINX_PS_UART=m
CONFIG_TTY_PRINTK=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=m
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=m
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_NVRAM=m
CONFIG_R3964=m
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=m
CONFIG_TCG_TIS=m
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
# CONFIG_I2C_MUX is not set
# CONFIG_I2C_HELPER_AUTO is not set
# CONFIG_I2C_SMBUS is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
# CONFIG_I2C_ALGOPCF is not set
CONFIG_I2C_ALGOPCA=m

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
# CONFIG_I2C_I801 is not set
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
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=m

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
CONFIG_I2C_DEBUG_ALGO=y
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_TOPCLIFF_PCH is not set
# CONFIG_SPI_XILINX is not set
CONFIG_SPI_DESIGNWARE=m
# CONFIG_SPI_DW_PCI is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=m
CONFIG_SPI_TLE62X0=m
CONFIG_HSI=m
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set

#
# PPS support
#
CONFIG_PPS=m
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
# CONFIG_PTP_1588_CLOCK is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_MANAGER is not set
# CONFIG_CHARGER_SMB347 is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_ADM1021=m
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=m
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM70=m
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=m
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=m
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=m
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=m
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4151=m
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95241=m
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_MAX1111=m
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=m
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_PC87360=m
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=m
# CONFIG_SENSORS_PMBUS is not set
CONFIG_SENSORS_ADM1275=m
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX34440 is not set
CONFIG_SENSORS_MAX8688=m
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
CONFIG_SENSORS_ZL6100=m
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_ADS1015=m
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_ADS7871=m
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_VIA_CPUTEMP=m
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=m
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_WM831X is not set
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_MC13783_ADC=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
# CONFIG_WM831X_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=m
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=m
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
CONFIG_IT87_WDT=m
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=m
CONFIG_SBC8360_WDT=m
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=m
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=m
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=m
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
CONFIG_SBC_EPX_C3_WATCHDOG=m

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_SM501=m
CONFIG_HTC_PASIC3=m
# CONFIG_MFD_LM3533 is not set
CONFIG_TPS6105X=m
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_MC13783=m
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_SPI=m
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_ABX500_CORE=y
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_CS5535 is not set
# CONFIG_LPC_SCH is not set
# CONFIG_LPC_ICH is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=m
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_AD5398=m
CONFIG_REGULATOR_MC13XXX_CORE=m
# CONFIG_REGULATOR_MC13783 is not set
CONFIG_REGULATOR_MC13892=m
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_MAX8649=m
# CONFIG_REGULATOR_MAX8660 is not set
# CONFIG_REGULATOR_MAX8952 is not set
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_LP3972 is not set
# CONFIG_REGULATOR_TPS6105X is not set
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=m
# CONFIG_REGULATOR_TPS6524X is not set
CONFIG_REGULATOR_WM831X=m
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
# CONFIG_FB is not set
# CONFIG_EXYNOS_VIDEO is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
# CONFIG_SOUND is not set

#
# HID support
#
# CONFIG_HID is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_HCD_SSB is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_UWB is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=m
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_PCA9532=m
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_PCA955X=m
CONFIG_LEDS_PCA9633=m
# CONFIG_LEDS_WM831X_STATUS is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=m
CONFIG_LEDS_MC13783=m
CONFIG_LEDS_TCA6507=m
CONFIG_LEDS_OT200=m
CONFIG_LEDS_TRIGGERS=y

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
CONFIG_LEDS_TRIGGER_TRANSIENT=m
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=m
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
CONFIG_RTC_DRV_EM3027=m
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=m
# CONFIG_RTC_DRV_M41T94 is not set
CONFIG_RTC_DRV_DS1305=m
CONFIG_RTC_DRV_DS1390=m
CONFIG_RTC_DRV_MAX6902=m
# CONFIG_RTC_DRV_R9701 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
CONFIG_RTC_DRV_DS3234=m
# CONFIG_RTC_DRV_PCF2123 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
CONFIG_RTC_DRV_DS1286=m
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=m
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_BQ4802=m
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set
# CONFIG_RTC_DRV_WM831X is not set

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MC13XXX is not set
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
CONFIG_UIO=m
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV is not set
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
CONFIG_VIRTIO=m
CONFIG_VIRTIO_RING=m

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MMIO=m
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
CONFIG_ECHO=m
# CONFIG_COMEDI is not set
# CONFIG_RTS_PSTOR is not set
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#
# CONFIG_IIO_ST_HWMON is not set
CONFIG_IIO_SW_RING=m

#
# Accelerometers
#
CONFIG_ADIS16201=m
# CONFIG_ADIS16203 is not set
# CONFIG_ADIS16204 is not set
# CONFIG_ADIS16209 is not set
# CONFIG_ADIS16220 is not set
CONFIG_ADIS16240=m
# CONFIG_KXSD9 is not set
# CONFIG_SCA3000 is not set

#
# Analog to digital converters
#
# CONFIG_AD7291 is not set
CONFIG_AD7298=m
# CONFIG_AD799X is not set
CONFIG_AD7476=m
CONFIG_AD7887=m
# CONFIG_AD7793 is not set
CONFIG_AD7192=m
# CONFIG_ADT7310 is not set
CONFIG_ADT7410=m
CONFIG_AD7280=m
CONFIG_MAX1363=m
CONFIG_MAX1363_RING_BUFFER=y

#
# Analog digital bi-direction converters
#

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
CONFIG_AD7152=m
CONFIG_AD7746=m

#
# Digital to analog converters
#
CONFIG_AD5064=m
# CONFIG_AD5360 is not set
# CONFIG_AD5380 is not set
# CONFIG_AD5421 is not set
# CONFIG_AD5624R_SPI is not set
# CONFIG_AD5446 is not set
# CONFIG_AD5504 is not set
# CONFIG_AD5764 is not set
# CONFIG_AD5791 is not set
# CONFIG_AD5686 is not set
# CONFIG_MAX517 is not set

#
# Direct Digital Synthesis
#
CONFIG_AD5930=m
# CONFIG_AD9832 is not set
# CONFIG_AD9834 is not set
# CONFIG_AD9850 is not set
# CONFIG_AD9852 is not set
# CONFIG_AD9910 is not set
# CONFIG_AD9951 is not set

#
# Digital gyroscope sensors
#
CONFIG_ADIS16060=m
# CONFIG_ADIS16080 is not set
# CONFIG_ADIS16130 is not set
# CONFIG_ADIS16260 is not set
CONFIG_ADXRS450=m

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=m

#
# Inertial measurement units
#
CONFIG_ADIS16400=m

#
# Light sensors
#
# CONFIG_SENSORS_ISL29018 is not set
CONFIG_SENSORS_ISL29028=m
# CONFIG_SENSORS_TSL2563 is not set
# CONFIG_TSL2583 is not set
# CONFIG_TSL2x7x is not set

#
# Magnetometer sensors
#
CONFIG_SENSORS_HMC5843=m

#
# Active energy metering IC
#
CONFIG_ADE7753=m
# CONFIG_ADE7754 is not set
CONFIG_ADE7758=m
CONFIG_ADE7759=m
CONFIG_ADE7854=m
CONFIG_ADE7854_I2C=m
# CONFIG_ADE7854_SPI is not set

#
# Resolver to digital converters
#
CONFIG_AD2S90=m

#
# Triggers - standalone
#
# CONFIG_IIO_PERIODIC_RTC_TRIGGER is not set
# CONFIG_IIO_SYSFS_TRIGGER is not set
CONFIG_IIO_DUMMY_EVGEN=m
CONFIG_IIO_SIMPLE_DUMMY=m
CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
# CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set
# CONFIG_ZRAM is not set
# CONFIG_ZCACHE is not set
# CONFIG_ZSMALLOC is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_FT1000=m

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=m
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_PHONE=m
# CONFIG_PHONE_IXJ is not set
# CONFIG_IPACK_BUS is not set
CONFIG_WIMAX_GDM72XX=m
# CONFIG_WIMAX_GDM72XX_QOS is not set
CONFIG_WIMAX_GDM72XX_K_MODE=y
# CONFIG_WIMAX_GDM72XX_WIMAX2 is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
CONFIG_VIRT_DRIVERS=y
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=m

#
# Extcon Device Drivers
#
CONFIG_MEMORY=y
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Analog to digital converters
#

#
# Amplifiers
#
CONFIG_AD8366=m
# CONFIG_VME_BUS is not set

#
# Ubuntu Supplied Third-Party Device Drivers
#
# CONFIG_AUFS_FS is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=m
# CONFIG_DCDBAS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=m
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4_FS is not set
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
# CONFIG_REISERFS_FS_SECURITY is not set
CONFIG_JFS_FS=m
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=y
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=m
# CONFIG_BTRFS_FS_POSIX_ACL is not set
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=m
CONFIG_QFMT_V1=m
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set
# CONFIG_OVERLAYFS_FS is not set

#
# Caches
#
CONFIG_FSCACHE=m
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_CACHEFILES=m
CONFIG_CACHEFILES_DEBUG=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=m
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
CONFIG_BFS_FS=m
CONFIG_EFS_FS=m
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=m
CONFIG_SQUASHFS_XATTR=y
# CONFIG_SQUASHFS_ZLIB is not set
CONFIG_SQUASHFS_LZO=y
# CONFIG_SQUASHFS_XZ is not set
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=m
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
CONFIG_QNX6FS_FS=m
CONFIG_QNX6FS_DEBUG=y
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=m
CONFIG_UFS_FS_WRITE=y
CONFIG_UFS_DEBUG=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
# CONFIG_NFS_V2 is not set
# CONFIG_NFS_V3 is not set
# CONFIG_NFS_V4 is not set
CONFIG_NFS_FSCACHE=y
# CONFIG_NFSD is not set
CONFIG_LOCKD=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
# CONFIG_CIFS_UPCALL is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_FSCACHE is not set
CONFIG_CIFS_ACL=y
# CONFIG_NCP_FS is not set
CONFIG_CODA_FS=m
CONFIG_AFS_FS=m
# CONFIG_AFS_DEBUG is not set
# CONFIG_AFS_FSCACHE is not set
# CONFIG_9P_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=m
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=m
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=m
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=m
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
# CONFIG_NLS_UTF8 is not set
CONFIG_DLM=m
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_SLUB_STATS=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_PREEMPT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
# CONFIG_PROVE_RCU is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_BUGVERBOSE is not set
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_BLOCK_EXT_DEVT=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
# CONFIG_LKDTM is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
CONFIG_FAIL_IO_TIMEOUT=y
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_KSTRTOX=m
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
CONFIG_CPA_DEBUG=y
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_TRUSTED_KEYS=m
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=m
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=m
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=m
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=m
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=m
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA1_SSSE3=m
CONFIG_CRYPTO_SHA256=m
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=m
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=m
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_X86_64=m
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=m
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=m
CONFIG_CRYPTO_USER_API_HASH=m
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=m
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=m
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_CRC8=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=m
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
# CONFIG_CPUMASK_OFFSTACK is not set
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set

--MW5yreqqjyrRcusr--
