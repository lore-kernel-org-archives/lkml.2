Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab2IJAyQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 20:54:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:60558 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923Ab2IJAyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 20:54:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,396,1344236400"; 
   d="scan'208";a="220052450"
Date: Mon, 10 Sep 2012 08:54:05 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [signal] general protection fault
Message-ID: <20120910005405.GA27826@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <20120910004753.GB27699@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Al,

FYI, a different oops message on config:

x86_64-randconfig-s281      b______b___b_BBBBc_

--
12:	  f411932  
13:	B c2865bb  2012-09-10 kvm-fat      [    3.339124] general protection fault: 0000 [#1] PREEMPT  [show_regs __die die do_general_protection run_init_process general_protection run_init_process init_post loglevel]
14:	B 549bf9c  2012-09-10 kvm-inn      [    3.959841] general protection fault: 0000 [#1] PREEMPT  
15:	B 4e382ff  2012-09-10 kvm-stoakley [    3.724426] general protection fault: 0000 [#1] PREEMPT  
16:	B 23ddf94  2012-09-10 kvm-tyan     [   30.570378] general protection fault: 0000 [#1] PREEMPT  
17:	  f117e2a  

[    3.331671] Freeing unused kernel memory: 2044k freed
[    3.337454] Freeing unused kernel memory: 776k freed
[    3.339124] general protection fault: 0000 [#1] PREEMPT 
[    3.340009] Modules linked in:
[    3.340009] CPU 0 
[    3.340009] Pid: 1, comm: init Not tainted 3.6.0-rc3-00182-gc2865bb #43 Bochs Bochs
[    3.340009] RIP: 0000:[<0000000000000000>]  [<          (null)>]           (null)
[    3.340009] RSP: 0000:0000000000000000  EFLAGS: 00000000
[    3.340009] RAX: 0000000000000000 RBX: ffffffff813e6741 RCX: 0000000000000000
[    3.340009] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[    3.340009] RBP: ffff88000dc4df00 R08: 0000000000000000 R09: ffffffff81a626f5
[    3.340009] R10: ffffffff81a63410 R11: ffff88000dc4df40 R12: ffffffff813e66c8
[    3.340009] R13: ffff88000dc4def0 R14: 0000000000000008 R15: 0000000000000008
[    3.340009] FS:  0000000000000000(0000) GS:0000000000000000(0000) knlGS:ffffffff8183d000
[    3.340009] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    3.340009] CR2: 0000000000000000 CR3: 000000000fac9000 CR4: 00000000000006b0
[    3.340009] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    3.340009] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    3.340009] Process init (pid: 1, threadinfo ffff88000dc4c000, task ffff88000dc50000)
[    3.340009] Stack:
[    3.340009]  ffff88000dc4dd98 ffff88000dc4de00 ffff88000dc4ded0 0000000000000ac0
[    3.340009]  0000000000000000 0000000000000040 0000000000000008 ffff88000dc4de30
[    3.340009]  ffffffff81015723 ffff88000dc50000 0000000000000000 0000000000000000
[    3.340009] Call Trace:
[    3.340009]  [<ffffffff81015723>] ? show_regs+0xda/0x2b7
[    3.340009]  [<ffffffff813f211e>] ? __die+0xc7/0x123
[    3.340009]  [<ffffffff81016969>] ? die+0x5e/0x95
[    3.340009]  [<ffffffff813f1b47>] ? do_general_protection+0x1a5/0x1b5
[    3.340009]  [<ffffffff813e66c8>] ? run_init_process+0x25/0x2e
[    3.340009]  [<ffffffff813f1425>] ? general_protection+0x25/0x30
[    3.340009]  [<ffffffff813e66c8>] ? run_init_process+0x25/0x2e
[    3.340009]  [<ffffffff813e6741>] ? init_post+0x70/0x12a
[    3.340009]  [<ffffffff81a63410>] kernel_init+0x2c1/0x2c1
[    3.340009]  [<ffffffff81a626f5>] ? loglevel+0x46/0x46
[    3.340009] Code:  Bad RIP value.
[    3.340009] RIP  [<          (null)>]           (null)
[    3.340009]  RSP <0000000000000000>

Thanks,
Fengguang

--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-fat-30607-2012-09-10-08-39-09-3.6.0-rc3-00182-gc2865bb-43"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Linux version 3.6.0-rc3-00182-gc2865bb (kbuild@snb) (gcc ver=
sion 4.7.1 (Debian 4.7.1-6) ) #43 PREEMPT Mon Sep 10 08:38:26 CST 2012
[    0.000000] Command line: trinity=3D2m hung_task_panic=3D1 rcutree.rcu_c=
pu_stall_timeout=3D100 branch=3Dsignal/experimental-kernel_thread log_buf_l=
en=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_printk sysrq=
_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,115200 conso=
le=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3Dvmlinuz-2012-09-10-08-38=
-38-signal:experimental-kernel_thread:a392720-c2865bb-x86_64-randconfig-s28=
1-1-fat BOOT_IMAGE=3Dkernel-tests/kernels/x86_64-randconfig-s281/c2865bb/vm=
linuz-3.6.0-rc3-00182-gc2865bb
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at =
[ffff8800000fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x0e8540=
00-0x0e8d5fff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127984(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
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
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:185b981, boot clock
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
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 185adc0
[    0.000000] PM: Registered nosave memory: 0000000000093000 - 00000000000=
94000
[    0.000000] PM: Registered nosave memory: 0000000000094000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 00000000001=
00000
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64379
[    0.000000] Kernel command line: trinity=3D2m hung_task_panic=3D1 rcutre=
e.rcu_cpu_stall_timeout=3D100 branch=3Dsignal/experimental-kernel_thread lo=
g_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_print=
k sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,11520=
0 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3Dvmlinuz-2012-09-1=
0-08-38-38-signal:experimental-kernel_thread:a392720-c2865bb-x86_64-randcon=
fig-s281-1-fat BOOT_IMAGE=3Dkernel-tests/kernels/x86_64-randconfig-s281/c28=
65bb/vmlinuz-3.6.0-rc3-00182-gc2865bb
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 211236k/262136k available (4075k kernel code, 500k a=
bsent, 50400k reserved, 6544k data, 504k init)
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D1, Nodes=3D1
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 3200.098 MHz processor
[    0.003333] Calibrating delay loop (skipped) preset value.. 6402.87 Bogo=
MIPS (lpj=3D10666993)
[    0.003343] pid_max: default: 32768 minimum: 301
[    0.004346] Mount-cache hash table entries: 256
[    0.005503] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.005503] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.005503] tlb_flushall_shift is 0x6
[    0.006671] CPU: Intel Common KVM processor stepping 01
[    0.011055] ACPI: Core revision 20120711
[    0.012854] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.015072] Testing tracer nop: PASSED
[    0.016793] Getting VERSION: 50014
[    0.020017] Getting VERSION: 50014
[    0.020873] Getting ID: 0
[    0.021634] Getting ID: ff000000
[    0.022462] Getting LVT0: 8700
[    0.023340] Getting LVT1: 8400
[    0.024196] enabled ExtINT on CPU#0
[    0.025752] ENABLING IO-APIC IRQs
[    0.026673] init IO_APIC IRQs
[    0.027474]  apic 2 pin 0 not connected
[    0.028375] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.030017] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.031772] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.033348] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.035159] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.036682] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.040015] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.041752] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.043348] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.045091] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.046681] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.048442] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.050014] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.051824] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.053348] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.055109]  apic 2 pin 16 not connected
[    0.056668]  apic 2 pin 17 not connected
[    0.057560]  apic 2 pin 18 not connected
[    0.058453]  apic 2 pin 19 not connected
[    0.060001]  apic 2 pin 20 not connected
[    0.060893]  apic 2 pin 21 not connected
[    0.061785]  apic 2 pin 22 not connected
[    0.062676]  apic 2 pin 23 not connected
[    0.063472] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.064735] Using local APIC timer interrupts.
[    0.064735] calibrating APIC timer ...
[    0.069996] ... lapic delta =3D 6249953
[    0.069996] ... PM-Timer delta =3D 357951
[    0.069996] ... PM-Timer result ok
[    0.069996] ..... delta 6249953
[    0.069996] ..... mult: 268450940
[    0.069996] ..... calibration result: 3333308
[    0.069996] ..... CPU clock speed is 3200.1337 MHz.
[    0.069996] ..... host bus clock speed is 1000.0308 MHz.
[    0.074441] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.075883] dummy:=20
[    0.076701] NET: Registered protocol family 16
[    0.077941] ACPI: bus type pci registered
[    0.078965] PCI: Using configuration type 1 for base access
[    0.080326] bio: create slab <bio-0> at 0
[    0.081381] ACPI: Added _OSI(Module Device)
[    0.082407] ACPI: Added _OSI(Processor Device)
[    0.083333] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.084427] ACPI: Added _OSI(Processor Aggregator Device)
[    0.086688] ACPI: EC: Look up EC in DSDT
[    0.089693] ACPI: Interpreter enabled
[    0.089998] ACPI: (supports S0 S4 S5)
[    0.091201] ACPI: Using IOAPIC for interrupt routing
[    0.096142] PCI: Ignoring host bridge windows from ACPI; if necessary, u=
se "pci=3Duse_crs" and report a bug
[    0.096685] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.097989] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] =
(ignored)
[    0.099999] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] =
(ignored)
[    0.103332] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x00=
0bffff] (ignored)
[    0.105266] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfe=
bfffff] (ignored)
[    0.106665] PCI: root bus 00: using default resources
[    0.107830] PCI host bridge to bus 0000:00
[    0.108850] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under dom=
ain [bus 00-ff]
[    0.109998] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.111191] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.113331] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffff=
fff]
[    0.114768] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.116826] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.118464] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.121172] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    0.123421] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.125012] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.126674] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.128240] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.130099] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.132333] pci 0000:00:02.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    0.138299] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.140189] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.141813] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.143946] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.148211] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.150107] pci 0000:00:04.0: [8086:2668] type 00 class 0x040300
[    0.151615] pci 0000:00:04.0: reg 10: [mem 0xfebf0000-0xfebf3fff]
[    0.155204] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.156689] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    0.158521] pci 0000:00:05.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    0.163557] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.165209] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    0.166991] pci 0000:00:06.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    0.172126] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.173697] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.175528] pci 0000:00:07.0: reg 14: [mem 0xfebf7000-0xfebf7fff]
[    0.180546] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.182183] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    0.183953] pci 0000:00:08.0: reg 14: [mem 0xfebf8000-0xfebf8fff]
[    0.189049] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.190362] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    0.192191] pci 0000:00:09.0: reg 14: [mem 0xfebf9000-0xfebf9fff]
[    0.197212] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.198859] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    0.200618] pci 0000:00:0a.0: reg 14: [mem 0xfebfa000-0xfebfafff]
[    0.205715] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    0.206859] pci 0000:00:0b.0: reg 10: [mem 0xfebfb000-0xfebfb00f]
[    0.210855] pci_bus 0000:00: on NUMA node 0
[    0.211926] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.213941]  pci0000:00: ACPI _OSC support notification failed, disablin=
g PCIe ASPM
[    0.215818]  pci0000:00: Unable to request _OSC control (_OSC support ma=
sk: 0x08)
[    0.223424] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.225122] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.226757] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.228446] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.230083] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.231737] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.233327] vgaarb: loaded
[    0.234159] vgaarb: bridge control possible 0000:00:02.0
[    0.235384] PCI: Using ACPI for IRQ routing
[    0.236663] PCI: pci_cache_line_size set to 64 bytes
[    0.238033] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    0.239308] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.240375] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.243435] Switching to clocksource kvm-clock
[    0.252017] pnp: PnP ACPI init
[    0.252911] ACPI: bus type pnp registered
[    0.253965] pnp 00:00: [bus 00-ff]
[    0.254895] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.255909] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.257021] pnp 00:00: [io  0x0d00-0xffff window]
[    0.258124] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.259320] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    0.260562] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.261928] pnp 00:01: [io  0x0070-0x0071]
[    0.262971] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.264929] pnp 00:01: [irq 8]
[    0.265801] pnp 00:01: [io  0x0072-0x0077]
[    0.266858] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.268249] pnp 00:02: [io  0x0060]
[    0.269180] pnp 00:02: [io  0x0064]
[    0.270120] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.272040] pnp 00:02: [irq 1]
[    0.272949] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.274350] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.276328] pnp 00:03: [irq 12]
[    0.277253] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.278622] pnp 00:04: [io  0x03f2-0x03f5]
[    0.279636] pnp 00:04: [io  0x03f7]
[    0.280596] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.282525] pnp 00:04: [irq 6]
[    0.290029] pnp 00:04: [dma 2]
[    0.290934] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.292345] pnp 00:05: [io  0x0378-0x037f]
[    0.293380] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.295319] pnp 00:05: [irq 7]
[    0.296222] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.297644] pnp 00:06: [io  0x03f8-0x03ff]
[    0.298671] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.300618] pnp 00:06: [irq 4]
[    0.301514] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.303024] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    0.304194] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.305694] pnp: PnP ACPI: found 8 devices
[    0.306735] ACPI: ACPI bus type pnp unregistered
[    0.313454] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.314671] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[    0.316047] NET: Registered protocol family 2
[    0.317332] TCP established hash table entries: 8192 (order: 5, 131072 b=
ytes)
[    0.318817] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    0.320203] TCP: Hash tables configured (established 8192 bind 8192)
[    0.321560] TCP: reno registered
[    0.322466] UDP hash table entries: 256 (order: 1, 8192 bytes)
[    0.323733] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
[    0.325108] NET: Registered protocol family 1
[    0.326179] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.327467] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.328730] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.330065] pci 0000:00:02.0: Boot video device
[    0.331235] PCI: CLS 0 bytes, default 64
[    0.332311] Unpacking initramfs...
[    0.867058] Freeing initrd memory: 23656k freed
[    0.878461] DMA-API: preallocated 32768 debug entries
[    0.879617] DMA-API: debugging enabled by kernel config
[    0.891035] Testing tracer preemptoff: PASSED
[    0.892311] Testing tracer wakeup: PASSED
[    1.200632] Testing tracer wakeup_rt: PASSED
[    1.510940] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.514443] VFS: Disk quotas dquot_6.5.2
[    1.515496] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.517111] alg: No test for stdrng (krng)
[    1.518193] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    1.520049] io scheduler noop registered (default)
[    1.521297] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    1.523142] ACPI: Power Button [PWRF]
[    1.524481] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.547846] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    1.571391] 00:06: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    1.572769] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    1.575350] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.576519] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.577740] mousedev: PS/2 mouse device common for all mice
[    1.579252] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    1.581430] cpuidle: using governor ladder
[    1.582662]=20
[    1.582662] printing PIC contents
[    1.584172] ... PIC  IMR: ffff
[    1.585041] ... PIC  IRR: 1013
[    1.585926] ... PIC  ISR: 0000
[    1.586819] ... PIC ELCR: 0c00
[    1.587692] printing local APIC contents on CPU#0/0:
[    1.588827] ... APIC ID:      00000000 (0)
[    1.589842] ... APIC VERSION: 00050014
[    1.590141] ... APIC TASKPRI: 00000000 (00)
[    1.590141] ... APIC PROCPRI: 00000000
[    1.590141] ... APIC LDR: 01000000
[    1.590141] ... APIC DFR: ffffffff
[    1.590141] ... APIC SPIV: 000001ff
[    1.590141] ... APIC ISR field:
[    1.590141] 000000000000000000000000000000000000000000000000000000000000=
0000
[    1.590141] ... APIC TMR field:
[    1.590141] 000000000000000000000000000000000000000000000000000000000000=
0000
[    1.590141] ... APIC IRR field:
[    1.590141] 000000000000000000000000000000000000000000000000000000000000=
8000
[    1.590141] ... APIC ESR: 00000000
[    1.590141] ... APIC ICR: 00000831
[    1.590141] ... APIC ICR2: 01000000
[    1.590141] ... APIC LVTT: 000000ef
[    1.590141] ... APIC LVTPC: 00010000
[    1.590141] ... APIC LVT0: 00010700
[    1.590141] ... APIC LVT1: 00000400
[    1.590141] ... APIC LVTERR: 000000fe
[    1.590141] ... APIC TMICT: 00030acd
[    1.590141] ... APIC TMCCT: 00000000
[    1.590141] ... APIC TDCR: 00000003
[    1.590141]=20
[    1.615329] number of MP IRQ sources: 15.
[    1.616335] number of IO-APIC #2 registers: 24.
[    1.617415] testing the IO APIC.......................
[    1.618576] IO APIC #2......
[    1.619422] .... register #00: 00000000
[    1.620410] .......    : physical APIC id: 00
[    1.621459] .......    : Delivery Type: 0
[    1.622457] .......    : LTS          : 0
[    1.623464] .... register #01: 00170011
[    1.624446] .......     : max redirection entries: 17
[    1.625584] .......     : PRQ implemented: 0
[    1.626611] .......     : IO APIC version: 11
[    1.627667] .... register #02: 00000000
[    1.628638] .......     : arbitration: 00
[    1.629636] .... IRQ redirection table:
[    1.630622]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    1.631824]  00 00  1    0    0   0   0    0    0    00
[    1.633065]  01 01  0    0    0   0   0    1    1    31
[    1.634335]  02 01  0    0    0   0   0    1    1    30
[    1.635581]  03 01  0    0    0   0   0    1    1    33
[    1.636843]  04 01  1    0    0   0   0    1    1    34
[    1.638089]  05 01  1    1    0   0   0    1    1    35
[    1.639339]  06 01  0    0    0   0   0    1    1    36
[    1.640594]  07 01  0    0    0   0   0    1    1    37
[    1.641842]  08 01  0    0    0   0   0    1    1    38
[    1.643094]  09 01  0    1    0   0   0    1    1    39
[    1.644354]  0a 01  1    1    0   0   0    1    1    3A
[    1.645607]  0b 01  1    1    0   0   0    1    1    3B
[    1.646861]  0c 01  0    0    0   0   0    1    1    3C
[    1.648105]  0d 01  0    0    0   0   0    1    1    3D
[    1.649352]  0e 01  0    0    0   0   0    1    1    3E
[    1.650609]  0f 01  0    0    0   0   0    1    1    3F
[    1.651855]  10 00  1    0    0   0   0    0    0    00
[    1.653103]  11 00  1    0    0   0   0    0    0    00
[    1.654361]  12 00  1    0    0   0   0    0    0    00
[    1.655598]  13 00  1    0    0   0   0    0    0    00
[    1.656862]  14 00  1    0    0   0   0    0    0    00
[    1.658105]  15 00  1    0    0   0   0    0    0    00
[    1.659354]  16 00  1    0    0   0   0    0    0    00
[    1.660613]  17 00  1    0    0   0   0    0    0    00
[    1.661855] IRQ to pin mappings:
[    1.662757] IRQ0 -> 0:2
[    1.663709] IRQ1 -> 0:1
[    1.664651] IRQ3 -> 0:3
[    1.665586] IRQ4 -> 0:4
[    1.666536] IRQ5 -> 0:5
[    1.667490] IRQ6 -> 0:6
[    1.668461] IRQ7 -> 0:7
[    1.669401] IRQ8 -> 0:8
[    1.670351] IRQ9 -> 0:9
[    1.671287] IRQ10 -> 0:10
[    1.672246] IRQ11 -> 0:11
[    1.673203] IRQ12 -> 0:12
[    1.674179] IRQ13 -> 0:13
[    1.675133] IRQ14 -> 0:14
[    1.676087] IRQ15 -> 0:15
[    1.677065] .................................... done.
[    1.678314] registered taskstats version 1
[    1.679325] Running tests on trace events:
[    1.680347] Testing event kfree_skb: OK
[    1.687291] Testing event consume_skb: OK
[    1.693941] Testing event skb_copy_datagram_iovec: OK
[    1.700621] Testing event net_dev_xmit: OK
[    1.707281] Testing event net_dev_queue: OK
[    1.713938] Testing event netif_receive_skb: OK
[    1.720615] Testing event netif_rx: OK
[    1.727286] Testing event napi_poll: OK
[    1.733946] Testing event sock_rcvqueue_full: OK
[    1.740622] Testing event sock_exceed_buf_limit: OK
[    1.747281] Testing event udp_fail_queue_rcv_skb: OK
[    1.753948] Testing event regmap_reg_write: OK
[    1.760638] Testing event regmap_reg_read: OK
[    1.767288] Testing event regmap_reg_read_cache: OK
[    1.773949] Testing event regmap_hw_read_start: OK
[    1.780644] Testing event regmap_hw_read_done: OK
[    1.787291] Testing event regmap_hw_write_start: OK
[    1.793952] Testing event regmap_hw_write_done: OK
[    1.800618] Testing event regcache_sync: OK
[    1.807284] Testing event regmap_cache_only: OK
[    1.813945] Testing event regmap_cache_bypass: OK
[    1.820626] Testing event mix_pool_bytes: OK
[    1.827389] Testing event mix_pool_bytes_nolock: OK
[    1.833982] Testing event credit_entropy_bits: OK
[    1.840625] Testing event get_random_bytes: OK
[    1.847284] Testing event extract_entropy: OK
[    1.853948] Testing event extract_entropy_user: OK
[    1.860617] Testing event regulator_enable: OK
[    1.867288] Testing event regulator_enable_delay: OK
[    1.873953] Testing event regulator_enable_complete: OK
[    1.887227] tsc: Refined TSC clocksource calibration: 3200.112 MHz
[    1.888539] Testing event regulator_disable: OK
[    1.893952] Testing event regulator_disable_complete: OK
[    1.900617] Testing event regulator_set_voltage: OK
[    1.907281] Testing event regulator_set_voltage_complete: OK
[    1.913938] Testing event gpio_direction: OK
[    1.920625] Testing event gpio_value: OK
[    1.927287] Testing event block_rq_abort: OK
[    1.933944] Testing event block_rq_requeue: OK
[    1.940659] Testing event block_rq_complete: OK
[    1.947309] Testing event block_rq_insert: OK
[    1.953946] Testing event block_rq_issue: OK
[    1.960652] Testing event block_bio_bounce: OK
[    1.967317] Testing event block_bio_complete: OK
[    1.973944] Testing event block_bio_backmerge: OK
[    1.980620] Testing event block_bio_frontmerge: OK
[    1.987312] Testing event block_bio_queue: OK
[    1.993947] Testing event block_getrq: OK
[    2.000618] Testing event block_sleeprq: OK
[    2.007286] Testing event block_plug: OK
[    2.013941] Testing event block_unplug: OK
[    2.020656] Testing event block_split: OK
[    2.027311] Testing event block_bio_remap: OK
[    2.033943] Testing event block_rq_remap: OK
[    2.040651] Testing event writeback_nothread: OK
[    2.047290] Testing event writeback_queue: OK
[    2.053941] Testing event writeback_exec: OK
[    2.060652] Testing event writeback_start: OK
[    2.067280] Testing event writeback_written: OK
[    2.073941] Testing event writeback_wait: OK
[    2.080646] Testing event writeback_pages_written: OK
[    2.087323] Testing event writeback_nowork: OK
[    2.093979] Testing event writeback_wake_background: OK
[    2.100656] Testing event writeback_wake_thread: OK
[    2.107316] Testing event writeback_wake_forker_thread: OK
[    2.113988] Testing event writeback_bdi_register: OK
[    2.120647] Testing event writeback_bdi_unregister: OK
[    2.127316] Testing event writeback_thread_start: OK
[    2.133980] Testing event writeback_thread_stop: OK
[    2.140656] Testing event wbc_writepage: OK
[    2.147332] Testing event writeback_queue_io: OK
[    2.153992] Testing event global_dirty_state: OK
[    2.160670] Testing event bdi_dirty_ratelimit: OK
[    2.167337] Testing event balance_dirty_pages: OK
[    2.173955] Testing event writeback_sb_inodes_requeue: OK
[    2.180617] Testing event writeback_congestion_wait: OK
[    2.187292] Testing event writeback_wait_iff_congested: OK
[    2.193950] Testing event writeback_single_inode: OK
[    2.200640] Testing event mm_compaction_isolate_migratepages: OK
[    2.207287] Testing event mm_compaction_isolate_freepages: OK
[    2.213949] Testing event mm_compaction_migratepages: OK
[    2.220628] Testing event kmalloc: OK
[    2.227290] Testing event kmem_cache_alloc: OK
[    2.233954] Testing event kmalloc_node: OK
[    2.240625] Testing event kmem_cache_alloc_node: OK
[    2.247279] Testing event kfree: OK
[    2.253956] Testing event kmem_cache_free: OK
[    2.260619] Testing event mm_page_free: OK
[    2.267287] Testing event mm_page_free_batched: OK
[    2.273947] Testing event mm_page_alloc: OK
[    2.280622] Testing event mm_page_alloc_zone_locked: OK
[    2.287279] Testing event mm_page_pcpu_drain: OK
[    2.293954] Testing event mm_page_alloc_extfrag: OK
[    2.300663] Testing event mm_vmscan_kswapd_sleep: OK
[    2.307319] Testing event mm_vmscan_kswapd_wake: OK
[    2.313976] Testing event mm_vmscan_wakeup_kswapd: OK
[    2.320654] Testing event mm_vmscan_direct_reclaim_begin: OK
[    2.327327] Testing event mm_vmscan_memcg_reclaim_begin: OK
[    2.333972] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[    2.340651] Testing event mm_vmscan_direct_reclaim_end: OK
[    2.347325] Testing event mm_vmscan_memcg_reclaim_end: OK
[    2.353976] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[    2.360645] Testing event mm_shrink_slab_start: OK
[    2.367321] Testing event mm_shrink_slab_end: OK
[    2.373989] Testing event mm_vmscan_lru_isolate: OK
[    2.380655] Testing event mm_vmscan_memcg_isolate: OK
[    2.387317] Testing event mm_vmscan_writepage: OK
[    2.393976] Testing event mm_vmscan_lru_shrink_inactive: OK
[    2.400701] Testing event oom_score_adj_update: OK
[    2.407346] Testing event rpm_suspend: OK
[    2.413944] Testing event rpm_resume: OK
[    2.420634] Testing event rpm_idle: OK
[    2.427349] Testing event rpm_return_int: OK
[    2.433956] Testing event cpu_idle: OK
[    2.441096] Testing event cpu_frequency: OK
[    2.447783] Testing event machine_suspend: OK
[    2.454420] Testing event wakeup_source_activate: OK
[    2.460677] Testing event wakeup_source_deactivate: OK
[    2.467361] Testing event clock_enable: OK
[    2.473952] Testing event clock_disable: OK
[    2.480688] Testing event clock_set_rate: OK
[    2.487347] Testing event power_domain_target: OK
[    2.493947] Testing event ftrace_test_filter: OK
[    2.500684] Testing event module_load: OK
[    2.507351] Testing event module_free: OK
[    2.514002] Testing event module_get: OK
[    2.520626] Testing event module_put: OK
[    2.527353] Testing event module_request: OK
[    2.534016] Testing event sched_kthread_stop: OK
[    2.540693] Testing event sched_kthread_stop_ret: OK
[    2.547370] Testing event sched_wakeup: OK
[    2.553947] Testing event sched_wakeup_new: OK
[    2.560682] Testing event sched_switch: OK
[    2.567352] Testing event sched_migrate_task: OK
[    2.573945] Testing event sched_process_free: OK
[    2.580620] Testing event sched_process_exit: OK
[    2.587351] Testing event sched_wait_task: OK
[    2.593945] Testing event sched_process_wait: OK
[    2.600685] Testing event sched_process_fork: OK
[    2.607353] Testing event sched_process_exec: OK
[    2.613949] Testing event sched_stat_wait: OK
[    2.620679] Testing event sched_stat_sleep: OK
[    2.627287] Testing event sched_stat_iowait: OK
[    2.633947] Testing event sched_stat_blocked: OK
[    2.640687] Testing event sched_stat_runtime: OK
[    2.647348] Testing event sched_pi_setprio: OK
[    2.653953] Testing event rcu_utilization: OK
[    2.660690] Testing event workqueue_queue_work: OK
[    2.667368] Testing event workqueue_activate_work: OK
[    2.673950] Testing event workqueue_execute_start: OK
[    2.680690] Testing event workqueue_execute_end: OK
[    2.687297] Testing event signal_generate: OK
[    2.693953] Testing event signal_deliver: OK
[    2.700686] Testing event timer_init: OK
[    2.707347] Testing event timer_start: OK
[    2.713944] Testing event timer_expire_entry: OK
[    2.720684] Testing event timer_expire_exit: OK
[    2.727351] Testing event timer_cancel: OK
[    2.733948] Testing event hrtimer_init: OK
[    2.740688] Testing event hrtimer_start: OK
[    2.747352] Testing event hrtimer_expire_entry: OK
[    2.753947] Testing event hrtimer_expire_exit: OK
[    2.760686] Testing event hrtimer_cancel: OK
[    2.767354] Testing event itimer_state: OK
[    2.773946] Testing event itimer_expire: OK
[    2.780695] Testing event irq_handler_entry: OK
[    2.787361] Testing event irq_handler_exit: OK
[    2.793955] Testing event softirq_entry: OK
[    2.800698] Testing event softirq_exit: OK
[    2.807359] Testing event softirq_raise: OK
[    2.814014] Testing event console: OK
[    2.820685] Testing event task_newtask: OK
[    2.827354] Testing event task_rename: OK
[    2.834013] Testing event sys_enter: OK
[    2.840641] Testing event sys_exit: OK
[    2.847354] Testing event emulate_vsyscall: OK
[    2.853942] Testing event xen_mc_batch: OK
[    2.860692] Testing event xen_mc_issue: OK
[    2.867355] Testing event xen_mc_entry: OK
[    2.873953] Testing event xen_mc_entry_alloc: OK
[    2.880691] Testing event xen_mc_callback: OK
[    2.887365] Testing event xen_mc_flush_reason: OK
[    2.893947] Testing event xen_mc_flush: OK
[    2.900625] Testing event xen_mc_extend_args: OK
[    2.907351] Testing event xen_mmu_set_pte: OK
[    2.913948] Testing event xen_mmu_set_pte_atomic: OK
[    2.920680] Testing event xen_mmu_set_domain_pte: OK
[    2.927353] Testing event xen_mmu_set_pte_at: OK
[    2.933948] Testing event xen_mmu_pte_clear: OK
[    2.940680] Testing event xen_mmu_set_pmd: OK
[    2.947282] Testing event xen_mmu_pmd_clear: OK
[    2.953949] Testing event xen_mmu_set_pud: OK
[    2.960688] Testing event xen_mmu_set_pgd: OK
[    2.967350] Testing event xen_mmu_pud_clear: OK
[    2.973941] Testing event xen_mmu_pgd_clear: OK
[    2.980684] Testing event xen_mmu_ptep_modify_prot_start: OK
[    2.987352] Testing event xen_mmu_ptep_modify_prot_commit: OK
[    2.993947] Testing event xen_mmu_alloc_ptpage: OK
[    3.000689] Testing event xen_mmu_release_ptpage: OK
[    3.007283] Testing event xen_mmu_pgd_pin: OK
[    3.013947] Testing event xen_mmu_pgd_unpin: OK
[    3.020684] Testing event xen_mmu_flush_tlb: OK
[    3.027352] Testing event xen_mmu_flush_tlb_single: OK
[    3.034012] Testing event xen_mmu_flush_tlb_others: OK
[    3.040684] Testing event xen_mmu_write_cr3: OK
[    3.047351] Testing event xen_cpu_write_ldt_entry: OK
[    3.053947] Testing event xen_cpu_write_idt_entry: OK
[    3.060681] Testing event xen_cpu_load_idt: OK
[    3.067353] Testing event xen_cpu_write_gdt_entry: OK
[    3.073960] Testing event xen_cpu_set_ldt: OK
[    3.087371] Running tests on trace event systems:
[    3.088464] Testing event system skb: OK
[    3.094005] Testing event system net: OK
[    3.100748] Testing event system napi: OK
[    3.107365] Testing event system sock: OK
[    3.113986] Testing event system udp: OK
[    3.120703] Testing event system regmap: OK
[    3.127512] Testing event system random: OK
[    3.134050] Testing event system regulator: OK
[    3.140796] Testing event system gpio: OK
[    3.147384] Testing event system block: OK
[    3.154224] Testing event system writeback: OK
[    3.161081] Testing event system compaction: OK
[    3.167440] Testing event system kmem: OK
[    3.174196] Testing event system vmscan: OK
[    3.180913] Testing event system oom: OK
[    3.187365] Testing event system rpm: OK
[    3.194004] Testing event system power: OK
[    3.200828] Testing event system test: OK
[    3.207362] Testing event system module: OK
[    3.214031] Testing event system sched: OK
[    3.220899] Testing event system rcu: OK
[    3.227365] Testing event system workqueue: OK
[    3.234015] Testing event system signal: OK
[    3.240715] Testing event system timer: OK
[    3.247594] Testing event system irq: OK
[    3.254095] Testing event system printk: OK
[    3.260694] Testing event system task: OK
[    3.267314] Testing event system raw_syscalls: OK
[    3.273977] Testing event system vsyscall: OK
[    3.280696] Testing event system syscalls: OK
[    3.287425] Testing event system xen: OK
[    3.294555] Running tests on all trace events:
[    3.295617] Testing all events: OK
[    3.312923] Testing ftrace filter: OK
[    3.314407] Testing kprobe tracing: OK
[    3.319020] Freeing unused kernel memory: 504k freed
[    3.320313] Write protecting the kernel read-only data: 8192k
[    3.331671] Freeing unused kernel memory: 2044k freed
[    3.337454] Freeing unused kernel memory: 776k freed
[    3.339124] general protection fault: 0000 [#1] PREEMPT=20
[    3.340009] Modules linked in:
[    3.340009] CPU 0=20
[    3.340009] Pid: 1, comm: init Not tainted 3.6.0-rc3-00182-gc2865bb #43 =
Bochs Bochs
[    3.340009] RIP: 0000:[<0000000000000000>]  [<          (null)>]        =
   (null)
[    3.340009] RSP: 0000:0000000000000000  EFLAGS: 00000000
[    3.340009] RAX: 0000000000000000 RBX: ffffffff813e6741 RCX: 00000000000=
00000
[    3.340009] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000=
00000
[    3.340009] RBP: ffff88000dc4df00 R08: 0000000000000000 R09: ffffffff81a=
626f5
[    3.340009] R10: ffffffff81a63410 R11: ffff88000dc4df40 R12: ffffffff813=
e66c8
[    3.340009] R13: ffff88000dc4def0 R14: 0000000000000008 R15: 00000000000=
00008
[    3.340009] FS:  0000000000000000(0000) GS:0000000000000000(0000) knlGS:=
ffffffff8183d000
[    3.340009] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    3.340009] CR2: 0000000000000000 CR3: 000000000fac9000 CR4: 00000000000=
006b0
[    3.340009] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[    3.340009] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[    3.340009] Process init (pid: 1, threadinfo ffff88000dc4c000, task ffff=
88000dc50000)
[    3.340009] Stack:
[    3.340009]  ffff88000dc4dd98 ffff88000dc4de00 ffff88000dc4ded0 00000000=
00000ac0
[    3.340009]  0000000000000000 0000000000000040 0000000000000008 ffff8800=
0dc4de30
[    3.340009]  ffffffff81015723 ffff88000dc50000 0000000000000000 00000000=
00000000
[    3.340009] Call Trace:
[    3.340009]  [<ffffffff81015723>] ? show_regs+0xda/0x2b7
[    3.340009]  [<ffffffff813f211e>] ? __die+0xc7/0x123
[    3.340009]  [<ffffffff81016969>] ? die+0x5e/0x95
[    3.340009]  [<ffffffff813f1b47>] ? do_general_protection+0x1a5/0x1b5
[    3.340009]  [<ffffffff813e66c8>] ? run_init_process+0x25/0x2e
[    3.340009]  [<ffffffff813f1425>] ? general_protection+0x25/0x30
[    3.340009]  [<ffffffff813e66c8>] ? run_init_process+0x25/0x2e
[    3.340009]  [<ffffffff813e6741>] ? init_post+0x70/0x12a
[    3.340009]  [<ffffffff81a63410>] kernel_init+0x2c1/0x2c1
[    3.340009]  [<ffffffff81a626f5>] ? loglevel+0x46/0x46
[    3.340009] Code:  Bad RIP value.
[    3.340009] RIP  [<          (null)>]           (null)
[    3.340009]  RSP <0000000000000000>
[    3.340009] ---[ end trace c86266fcd1e18854 ]---
[    3.340009] BUG: sleeping function called from invalid context at /c/ker=
nel-tests/src/tip/kernel/rwsem.c:20
[    3.340009] in_atomic(): 0, irqs_disabled(): 1, pid: 1, name: init
[    3.340009] Pid: 1, comm: init Tainted: G      D      3.6.0-rc3-00182-gc=
2865bb #43
[    3.340009] Call Trace:
[    3.340009]  [<ffffffff81087b63>] __might_sleep+0x16b/0x177
[    3.340009]  [<ffffffff813ef08d>] down_read+0x23/0x50
[    3.340009]  [<ffffffff810b3606>] acct_collect+0x5b/0x1a8
[    3.340009]  [<ffffffff8105716d>] do_exit+0x2b8/0xba1
[    3.340009]  [<ffffffff813f204b>] oops_end+0xc7/0xd3
[    3.340009]  [<ffffffff8101698d>] die+0x82/0x95
[    3.340009]  [<ffffffff813f1b47>] do_general_protection+0x1a5/0x1b5
[    3.340009]  [<ffffffff813e66c8>] ? run_init_process+0x25/0x2e
[    3.340009]  [<ffffffff813f1425>] general_protection+0x25/0x30
[    3.340009]  [<ffffffff813e66c8>] ? run_init_process+0x25/0x2e
[    3.340009]  [<ffffffff813e6741>] ? init_post+0x70/0x12a
[    3.340009]  [<ffffffff81a63410>] kernel_init+0x2c1/0x2c1
[    3.340009]  [<ffffffff81a626f5>] ? loglevel+0x46/0x46
[    3.409723] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x0000000b
[    3.409723]=20
[    3.412218] Rebooting in 10 seconds..
--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.6.0-rc3-00182-gc2865bb"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.6.0-rc3 Kernel Configuration
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
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
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
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
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
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_FHANDLE is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
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
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# RCU Subsystem
#
CONFIG_TINY_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_BOOST is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_CGROUPS is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_IPC_NS=y
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EXPERT is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
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
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
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
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
CONFIG_ATARI_PARTITION=y
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=m
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
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
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PRIVILEGED_GUEST=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=500
CONFIG_XEN_SAVE_RESTORE=y
CONFIG_XEN_DEBUG_FS=y
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
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
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
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
CONFIG_MEMORY_ISOLATION=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
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
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
# CONFIG_FRONTSWAP is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
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
CONFIG_CPU_FREQ=y
# CONFIG_CPU_FREQ_STAT is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

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
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=m
# CONFIG_PCIEAER is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
# CONFIG_PCIEASPM_DEFAULT is not set
CONFIG_PCIEASPM_POWERSAVE=y
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
# CONFIG_XEN_PCIDEV_FRONTEND is not set
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=m
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_HOTPLUG_PCI=m
# CONFIG_HOTPLUG_PCI_FAKE is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
CONFIG_HOTPLUG_PCI_CPCI=y
# CONFIG_HOTPLUG_PCI_CPCI_ZT5550 is not set
# CONFIG_HOTPLUG_PCI_CPCI_GENERIC is not set
CONFIG_HOTPLUG_PCI_SHPC=m
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
# CONFIG_IA32_EMULATION is not set
# CONFIG_COMPAT_FOR_U64_ALIGNMENT is not set
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=m
CONFIG_XFRM_USER=m
CONFIG_XFRM_SUB_POLICY=y
# CONFIG_XFRM_MIGRATE is not set
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=m
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
# CONFIG_IP_ROUTE_VERBOSE is not set
CONFIG_IP_PNP=y
# CONFIG_IP_PNP_DHCP is not set
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IPGRE=m
# CONFIG_NET_IPGRE_BROADCAST is not set
CONFIG_IP_MROUTE=y
# CONFIG_IP_MROUTE_MULTIPLE_TABLES is not set
# CONFIG_IP_PIMSM_V1 is not set
# CONFIG_IP_PIMSM_V2 is not set
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_NET_IPVTI is not set
CONFIG_INET_AH=m
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=m
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=m
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_DEFAULT_RENO=y
CONFIG_DEFAULT_TCP_CONG="reno"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
# CONFIG_INET6_ESP is not set
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
# CONFIG_IPV6_SIT is not set
# CONFIG_IPV6_TUNNEL is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
# CONFIG_IPV6_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IPV6_PIMSM_V2=y
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_ACCT=m
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
# CONFIG_NETFILTER_NETLINK_LOG is not set
# CONFIG_NF_CONNTRACK is not set
# CONFIG_NETFILTER_TPROXY is not set
CONFIG_NETFILTER_XTABLES=m

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_CHECKSUM is not set
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
# CONFIG_NETFILTER_XT_TARGET_HMARK is not set
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
CONFIG_NETFILTER_XT_TARGET_LED=m
# CONFIG_NETFILTER_XT_TARGET_LOG is not set
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
# CONFIG_NETFILTER_XT_TARGET_TEE is not set
CONFIG_NETFILTER_XT_TARGET_TRACE=m
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
# CONFIG_NETFILTER_XT_MATCH_CPU is not set
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HL=m
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
# CONFIG_NETFILTER_XT_MATCH_LIMIT is not set
CONFIG_NETFILTER_XT_MATCH_MAC=m
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_NFACCT=m
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
# CONFIG_NETFILTER_XT_MATCH_STRING is not set
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
# CONFIG_IP_SET is not set
CONFIG_IP_VS=m
# CONFIG_IP_VS_IPV6 is not set
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
# CONFIG_IP_VS_PROTO_TCP is not set
# CONFIG_IP_VS_PROTO_UDP is not set
CONFIG_IP_VS_PROTO_AH_ESP=y
# CONFIG_IP_VS_PROTO_ESP is not set
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
# CONFIG_IP_VS_LC is not set
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
# CONFIG_IP_VS_LBLCR is not set
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
# CONFIG_IP_VS_SED is not set
# CONFIG_IP_VS_NQ is not set

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
# CONFIG_IP_NF_MATCH_RPFILTER is not set
CONFIG_IP_NF_MATCH_TTL=m
# CONFIG_IP_NF_FILTER is not set
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_ECN=m
# CONFIG_IP_NF_TARGET_TTL is not set
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_ARPTABLES=m
# CONFIG_IP_NF_ARPFILTER is not set
# CONFIG_IP_NF_ARP_MANGLE is not set

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV6 is not set
CONFIG_IP6_NF_IPTABLES=m
# CONFIG_IP6_NF_MATCH_AH is not set
CONFIG_IP6_NF_MATCH_EUI64=m
# CONFIG_IP6_NF_MATCH_FRAG is not set
CONFIG_IP6_NF_MATCH_OPTS=m
# CONFIG_IP6_NF_MATCH_HL is not set
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
# CONFIG_IP6_NF_MATCH_RPFILTER is not set
# CONFIG_IP6_NF_MATCH_RT is not set
CONFIG_IP6_NF_TARGET_HL=m
# CONFIG_IP6_NF_FILTER is not set
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m

#
# DECnet: Netfilter Configuration
#
# CONFIG_DECNET_NF_GRABULATOR is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
CONFIG_ATM=m
# CONFIG_ATM_CLIP is not set
# CONFIG_ATM_LANE is not set
CONFIG_ATM_BR2684=m
CONFIG_ATM_BR2684_IPFILTER=y
CONFIG_L2TP=m
# CONFIG_L2TP_DEBUGFS is not set
# CONFIG_L2TP_V3 is not set
# CONFIG_BRIDGE is not set
CONFIG_NET_DSA=m
# CONFIG_NET_DSA_TAG_DSA is not set
# CONFIG_NET_DSA_TAG_EDSA is not set
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=m
# CONFIG_VLAN_8021Q_GVRP is not set
CONFIG_DECNET=m
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=m
CONFIG_LLC2=m
# CONFIG_IPX is not set
CONFIG_ATALK=m
# CONFIG_DEV_APPLETALK is not set
CONFIG_X25=m
# CONFIG_LAPB is not set
CONFIG_WAN_ROUTER=m
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
CONFIG_BQL=y
CONFIG_BPF_JIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
CONFIG_NET_DROP_MONITOR=m
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
# CONFIG_CAN_BCM is not set
# CONFIG_CAN_GW is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_SLCAN is not set
# CONFIG_CAN_DEV is not set
CONFIG_CAN_DEBUG_DEVICES=y
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRCOMM=m
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
# CONFIG_IRDA_FAST_RR is not set
# CONFIG_IRDA_DEBUG is not set

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
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=m
# CONFIG_SMC_IRCC_FIR is not set
# CONFIG_ALI_FIR is not set
CONFIG_VLSI_FIR=m
CONFIG_VIA_FIR=m
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_LIB80211=m
CONFIG_LIB80211_CRYPT_WEP=m
CONFIG_LIB80211_CRYPT_CCMP=m
CONFIG_LIB80211_CRYPT_TKIP=m
CONFIG_LIB80211_DEBUG=y
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_MESSAGE_TRACING is not set
CONFIG_MAC80211_DEBUG_MENU=y
# CONFIG_MAC80211_NOINLINE is not set
# CONFIG_MAC80211_VERBOSE_DEBUG is not set
# CONFIG_MAC80211_MLME_DEBUG is not set
# CONFIG_MAC80211_STA_DEBUG is not set
CONFIG_MAC80211_HT_DEBUG=y
CONFIG_MAC80211_IBSS_DEBUG=y
# CONFIG_MAC80211_PS_DEBUG is not set
# CONFIG_MAC80211_TDLS_DEBUG is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
CONFIG_NFC=m
# CONFIG_NFC_NCI is not set
CONFIG_NFC_HCI=m
# CONFIG_NFC_SHDLC is not set
# CONFIG_NFC_LLCP is not set

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
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
# CONFIG_DMA_SHARED_BUFFER is not set
CONFIG_CONNECTOR=m
CONFIG_MTD=m
CONFIG_MTD_TESTS=m
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_CHAR=m
CONFIG_HAVE_MTD_OTP=y
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
CONFIG_MTD_BLOCK_RO=m
# CONFIG_FTL is not set
CONFIG_NFTL=m
CONFIG_NFTL_RW=y
CONFIG_INFTL=m
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
CONFIG_MTD_OOPS=m
CONFIG_MTD_SWAP=m

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
CONFIG_MTD_CFI_LE_BYTE_SWAP=y
# CONFIG_MTD_CFI_GEOMETRY is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_OTP=y
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=m
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
CONFIG_MTD_TS5500=m
CONFIG_MTD_AMD76XROM=m
CONFIG_MTD_ICHXROM=m
CONFIG_MTD_ESB2ROM=m
# CONFIG_MTD_CK804XROM is not set
CONFIG_MTD_SCB2_FLASH=m
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=m
CONFIG_MTD_INTEL_VR_NOR=m
CONFIG_MTD_PLATRAM=m

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=m
CONFIG_MTD_PHRAM=m
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOC2000=m
CONFIG_MTD_DOC2001=m
CONFIG_MTD_DOC2001PLUS=m
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_DOCPROBE=m
CONFIG_MTD_DOCECC=m
# CONFIG_MTD_DOCPROBE_ADVANCED is not set
CONFIG_MTD_DOCPROBE_ADDRESS=0x0
CONFIG_MTD_NAND_ECC=m
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=m
CONFIG_MTD_NAND_VERIFY_WRITE=y
CONFIG_MTD_NAND_BCH=m
CONFIG_MTD_NAND_ECC_BCH=y
CONFIG_MTD_SM_COMMON=m
CONFIG_MTD_NAND_MUSEUM_IDS=y
CONFIG_MTD_NAND_DENALI=m
CONFIG_MTD_NAND_DENALI_SCRATCH_REG_ADDR=0xFF108018
CONFIG_MTD_NAND_IDS=m
CONFIG_MTD_NAND_RICOH=m
# CONFIG_MTD_NAND_DISKONCHIP is not set
CONFIG_MTD_NAND_DOCG4=m
CONFIG_MTD_NAND_CAFE=m
CONFIG_MTD_NAND_NANDSIM=m
CONFIG_MTD_NAND_PLATFORM=m
CONFIG_MTD_ONENAND=m
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
# CONFIG_MTD_ONENAND_GENERIC is not set
CONFIG_MTD_ONENAND_OTP=y
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set
CONFIG_MTD_ONENAND_SIM=m

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
# CONFIG_MTD_UBI is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_XEN_BLKDEV_FRONTEND=y
# CONFIG_XEN_BLKDEV_BACKEND is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=m
CONFIG_INTEL_MID_PTI=m
CONFIG_SGI_IOC4=m
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=m
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_CS5535_MFGPT is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=m
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=m
# CONFIG_BMP085_I2C is not set
CONFIG_PCH_PHUB=m
CONFIG_USB_SWITCH_FSA9480=m
CONFIG_C2PORT=m
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=m
CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=m
CONFIG_SENSORS_LIS3_I2C=m

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
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
# CONFIG_SCSI_FC_TGT_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=m
# CONFIG_SCSI_SRP_TGT_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
CONFIG_ISCSI_BOOT_SYSFS=m
# CONFIG_SCSI_CXGB3_ISCSI is not set
CONFIG_SCSI_CXGB4_ISCSI=m
# CONFIG_SCSI_BNX2_ISCSI is not set
CONFIG_SCSI_BNX2X_FCOE=m
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
CONFIG_SCSI_HPSA=m
CONFIG_SCSI_3W_9XXX=m
# CONFIG_SCSI_3W_SAS is not set
CONFIG_SCSI_ACARD=m
CONFIG_SCSI_AACRAID=m
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC94XX is not set
CONFIG_SCSI_MVSAS=m
CONFIG_SCSI_MVSAS_DEBUG=y
# CONFIG_SCSI_MVSAS_TASKLET is not set
# CONFIG_SCSI_MVUMI is not set
CONFIG_SCSI_DPT_I2O=m
CONFIG_SCSI_ADVANSYS=m
# CONFIG_SCSI_ARCMSR is not set
CONFIG_MEGARAID_NEWGEN=y
# CONFIG_MEGARAID_MM is not set
CONFIG_MEGARAID_LEGACY=m
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
CONFIG_SCSI_UFSHCD=m
# CONFIG_SCSI_HPTIOP is not set
CONFIG_SCSI_BUSLOGIC=m
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_LIBFC=m
CONFIG_LIBFCOE=m
# CONFIG_FCOE is not set
CONFIG_FCOE_FNIC=m
CONFIG_SCSI_DMX3191D=m
# CONFIG_SCSI_EATA is not set
CONFIG_SCSI_FUTURE_DOMAIN=m
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_ISCI is not set
CONFIG_SCSI_IPS=m
CONFIG_SCSI_INITIO=m
CONFIG_SCSI_INIA100=m
CONFIG_SCSI_STEX=m
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
CONFIG_SCSI_QLOGIC_1280=m
CONFIG_SCSI_QLA_FC=m
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
CONFIG_SCSI_DC390T=m
CONFIG_SCSI_DEBUG=m
CONFIG_SCSI_PMCRAID=m
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_DH=m
CONFIG_SCSI_DH_RDAC=m
CONFIG_SCSI_DH_HP_SW=m
# CONFIG_SCSI_DH_EMC is not set
# CONFIG_SCSI_DH_ALUA is not set
CONFIG_SCSI_OSD_INITIATOR=m
# CONFIG_SCSI_OSD_ULD is not set
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_SATA_INIC162X is not set
CONFIG_SATA_ACARD_AHCI=m
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
CONFIG_SATA_QSTOR=m
CONFIG_SATA_SX4=m
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
CONFIG_SATA_SVW=m
# CONFIG_SATA_ULI is not set
CONFIG_SATA_VIA=m
CONFIG_SATA_VITESSE=m

#
# PATA SFF controllers with BMDMA
#
CONFIG_PATA_ALI=m
CONFIG_PATA_AMD=m
# CONFIG_PATA_ARASAN_CF is not set
# CONFIG_PATA_ARTOP is not set
CONFIG_PATA_ATIIXP=m
CONFIG_PATA_ATP867X=m
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
CONFIG_PATA_CS5536=m
CONFIG_PATA_CYPRESS=m
CONFIG_PATA_EFAR=m
# CONFIG_PATA_HPT366 is not set
CONFIG_PATA_HPT37X=m
CONFIG_PATA_HPT3X2N=m
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
CONFIG_PATA_JMICRON=m
CONFIG_PATA_MARVELL=m
# CONFIG_PATA_NETCELL is not set
CONFIG_PATA_NINJA32=m
# CONFIG_PATA_NS87415 is not set
CONFIG_PATA_OLDPIIX=m
# CONFIG_PATA_OPTIDMA is not set
CONFIG_PATA_PDC2027X=m
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
CONFIG_PATA_SC1200=m
CONFIG_PATA_SCH=m
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
CONFIG_PATA_SIS=m
# CONFIG_PATA_TOSHIBA is not set
CONFIG_PATA_TRIFLEX=m
CONFIG_PATA_VIA=m
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
CONFIG_PATA_CMD640_PCI=m
CONFIG_PATA_MPIIX=m
# CONFIG_PATA_NS87410 is not set
CONFIG_PATA_OPTI=m
CONFIG_PATA_RZ1000=m

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
CONFIG_ATA_GENERIC=m
CONFIG_PATA_LEGACY=m
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
# CONFIG_FIREWIRE_NET is not set
# CONFIG_FIREWIRE_NOSY is not set
CONFIG_I2O=m
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
# CONFIG_I2O_EXT_ADAPTEC is not set
# CONFIG_I2O_CONFIG is not set
# CONFIG_I2O_BUS is not set
# CONFIG_I2O_BLOCK is not set
# CONFIG_I2O_SCSI is not set
# CONFIG_I2O_PROC is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_BONDING=m
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
CONFIG_NET_FC=y
CONFIG_MII=m
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_TUN is not set
CONFIG_VETH=m
CONFIG_SUNGEM_PHY=m
# CONFIG_ARCNET is not set
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=m
CONFIG_ATM_TCP=m
CONFIG_ATM_LANAI=m
CONFIG_ATM_ENI=m
CONFIG_ATM_ENI_DEBUG=y
CONFIG_ATM_ENI_TUNE_BURST=y
# CONFIG_ATM_ENI_BURST_TX_16W is not set
# CONFIG_ATM_ENI_BURST_TX_8W is not set
CONFIG_ATM_ENI_BURST_TX_4W=y
CONFIG_ATM_ENI_BURST_TX_2W=y
CONFIG_ATM_ENI_BURST_RX_16W=y
# CONFIG_ATM_ENI_BURST_RX_8W is not set
CONFIG_ATM_ENI_BURST_RX_4W=y
CONFIG_ATM_ENI_BURST_RX_2W=y
CONFIG_ATM_FIRESTREAM=m
CONFIG_ATM_ZATM=m
CONFIG_ATM_ZATM_DEBUG=y
# CONFIG_ATM_NICSTAR is not set
CONFIG_ATM_IDT77252=m
# CONFIG_ATM_IDT77252_DEBUG is not set
CONFIG_ATM_IDT77252_RCV_ALL=y
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=m
# CONFIG_ATM_AMBASSADOR_DEBUG is not set
CONFIG_ATM_HORIZON=m
# CONFIG_ATM_HORIZON_DEBUG is not set
# CONFIG_ATM_IA is not set
CONFIG_ATM_FORE200E=m
# CONFIG_ATM_FORE200E_USE_TASKLET is not set
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
# CONFIG_ATM_HE is not set
CONFIG_ATM_SOLOS=m

#
# CAIF transport drivers
#

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
CONFIG_NET_DSA_MV88E6060=m
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
CONFIG_MDIO=m
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
CONFIG_NET_VENDOR_ALTEON=y
CONFIG_ACENIC=m
CONFIG_ACENIC_OMIT_TIGON_I=y
# CONFIG_NET_VENDOR_AMD is not set
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
CONFIG_ATL1=m
# CONFIG_ATL1E is not set
CONFIG_ATL1C=m
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
CONFIG_BNX2=m
CONFIG_CNIC=m
CONFIG_TIGON3=m
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
CONFIG_BNA=m
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
CONFIG_CHELSIO_T4=m
CONFIG_CHELSIO_T4VF=m
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
# CONFIG_DNET is not set
# CONFIG_NET_VENDOR_DEC is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
# CONFIG_NET_VENDOR_EXAR is not set
CONFIG_NET_VENDOR_HP=y
CONFIG_HP100=m
# CONFIG_NET_VENDOR_INTEL is not set
CONFIG_IP1000=m
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
CONFIG_NET_VENDOR_MICREL=y
CONFIG_KS8851_MLL=m
CONFIG_KSZ884X_PCI=m
# CONFIG_NET_VENDOR_MYRI is not set
CONFIG_FEALNX=m
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
CONFIG_NS83820=m
# CONFIG_NET_VENDOR_8390 is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
CONFIG_PCH_GBE=m
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
# CONFIG_NET_VENDOR_REALTEK is not set
# CONFIG_NET_VENDOR_RDC is not set
# CONFIG_NET_VENDOR_SEEQ is not set
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
# CONFIG_NET_VENDOR_SIS is not set
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_EPIC100 is not set
# CONFIG_SMSC9420 is not set
# CONFIG_NET_VENDOR_STMICRO is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
CONFIG_SUNGEM=m
# CONFIG_CASSINI is not set
CONFIG_NIU=m
CONFIG_NET_VENDOR_TEHUTI=y
CONFIG_TEHUTI=m
# CONFIG_NET_VENDOR_TI is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_NET_VENDOR_WIZNET is not set
CONFIG_FDDI=m
CONFIG_DEFXX=m
CONFIG_DEFXX_MMIO=y
# CONFIG_SKFP is not set
CONFIG_HIPPI=y
# CONFIG_ROADRUNNER is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
CONFIG_AMD_PHY=m
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
CONFIG_CICADA_PHY=m
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
# CONFIG_BCM87XX_PHY is not set
# CONFIG_ICPLUS_PHY is not set
CONFIG_REALTEK_PHY=m
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
CONFIG_LSI_ET1011C_PHY=m
CONFIG_MICREL_PHY=m
# CONFIG_MDIO_BITBANG is not set
# CONFIG_PPP is not set
CONFIG_SLIP=m
# CONFIG_SLIP_COMPRESSED is not set
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
CONFIG_WLAN=y
# CONFIG_LIBERTAS_THINFIRM is not set
CONFIG_AIRO=m
CONFIG_ATMEL=m
CONFIG_PCI_ATMEL=m
CONFIG_PRISM54=m
CONFIG_RTL8180=m
# CONFIG_ADM8211 is not set
CONFIG_MAC80211_HWSIM=m
# CONFIG_MWL8K is not set
CONFIG_ATH_COMMON=m
CONFIG_ATH_DEBUG=y
# CONFIG_ATH5K is not set
CONFIG_ATH5K_PCI=y
CONFIG_ATH9K_HW=m
CONFIG_ATH9K_COMMON=m
# CONFIG_ATH9K_BTCOEX_SUPPORT is not set
CONFIG_ATH9K=m
CONFIG_ATH9K_PCI=y
# CONFIG_ATH9K_AHB is not set
# CONFIG_ATH9K_DEBUGFS is not set
CONFIG_ATH9K_RATE_CONTROL=y
# CONFIG_ATH6KL is not set
# CONFIG_B43 is not set
CONFIG_B43LEGACY=m
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
CONFIG_B43LEGACY_HWRNG=y
# CONFIG_B43LEGACY_DEBUG is not set
CONFIG_B43LEGACY_DMA=y
CONFIG_B43LEGACY_PIO=y
CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
# CONFIG_B43LEGACY_DMA_MODE is not set
# CONFIG_B43LEGACY_PIO_MODE is not set
CONFIG_BRCMUTIL=m
CONFIG_BRCMSMAC=m
# CONFIG_BRCMFMAC is not set
# CONFIG_BRCMDBG is not set
# CONFIG_HOSTAP is not set
# CONFIG_IPW2100 is not set
CONFIG_IPW2200=m
# CONFIG_IPW2200_MONITOR is not set
# CONFIG_IPW2200_QOS is not set
CONFIG_IPW2200_DEBUG=y
CONFIG_LIBIPW=m
# CONFIG_LIBIPW_DEBUG is not set
CONFIG_IWLWIFI=m
CONFIG_IWLDVM=m

#
# Debugging Options
#
# CONFIG_IWLWIFI_DEBUG is not set
# CONFIG_IWLWIFI_DEVICE_TRACING is not set
# CONFIG_IWLWIFI_P2P is not set
# CONFIG_IWLWIFI_EXPERIMENTAL_MFP is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
# CONFIG_RT2X00 is not set
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_WL_TI is not set
# CONFIG_MWIFIEX is not set

#
# WiMAX Wireless Broadband devices
#

#
# Enable USB support to see WiMAX USB drivers
#
# CONFIG_WAN is not set
# CONFIG_XEN_NETDEV_FRONTEND is not set
# CONFIG_XEN_NETDEV_BACKEND is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=m
CONFIG_KEYBOARD_ADP5589=m
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
CONFIG_KEYBOARD_QT2160=m
CONFIG_KEYBOARD_LKKBD=m
# CONFIG_KEYBOARD_GPIO is not set
CONFIG_KEYBOARD_GPIO_POLLED=m
CONFIG_KEYBOARD_TCA6416=m
CONFIG_KEYBOARD_TCA8418=m
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
CONFIG_KEYBOARD_LM8333=m
CONFIG_KEYBOARD_MAX7359=m
CONFIG_KEYBOARD_MCS=m
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
CONFIG_KEYBOARD_STOWAWAY=m
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_OMAP4=m
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=m
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
CONFIG_TOUCHSCREEN_CY8CTMG110=m
CONFIG_TOUCHSCREEN_CYTTSP_CORE=m
# CONFIG_TOUCHSCREEN_CYTTSP_I2C is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=m
# CONFIG_TOUCHSCREEN_EGALAX is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=m
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=m
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
CONFIG_TOUCHSCREEN_MAX11801=m
CONFIG_TOUCHSCREEN_MCS5000=m
# CONFIG_TOUCHSCREEN_MMS114 is not set
CONFIG_TOUCHSCREEN_MTOUCH=m
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=m
CONFIG_TOUCHSCREEN_PENMOUNT=m
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=m
CONFIG_TOUCHSCREEN_PIXCIR=m
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=m
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_BMA150=m
CONFIG_INPUT_PCSPKR=m
CONFIG_INPUT_MMA8450=m
CONFIG_INPUT_MPU3050=m
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_GP2A is not set
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=m
# CONFIG_INPUT_KXTJ9_POLLED_MODE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=m
# CONFIG_INPUT_PCF8574 is not set
CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
CONFIG_INPUT_ADXL34X=m
# CONFIG_INPUT_ADXL34X_I2C is not set
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=m
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
CONFIG_MOXA_INTELLIO=m
CONFIG_MOXA_SMARTIO=m
CONFIG_SYNCLINK=m
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=m
CONFIG_NOZOMI=m
# CONFIG_ISI is not set
# CONFIG_N_HDLC is not set
CONFIG_N_GSM=m
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set
# CONFIG_STALDRV is not set

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
CONFIG_SERIAL_MFD_HSU=m
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_TIMBERDALE=m
CONFIG_SERIAL_ALTERA_JTAGUART=m
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
# CONFIG_HVC_XEN_FRONTEND is not set
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=m
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_TIMERIOMEM=m
# CONFIG_HW_RANDOM_INTEL is not set
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_NVRAM=m
# CONFIG_RTC is not set
CONFIG_GEN_RTC=m
# CONFIG_GEN_RTC_X is not set
CONFIG_R3964=m
CONFIG_APPLICOM=m
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=m
CONFIG_TCG_TIS=m
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=m
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
CONFIG_I2C_SIS5595=m
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=m
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
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_OCORES=m
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
CONFIG_I2C_DEBUG_ALGO=y
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_HSI=m
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set

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
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=m
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=m
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_SCH=m
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_VX855=m

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX7300=m
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=m
# CONFIG_GPIO_PCF857X is not set
CONFIG_GPIO_ADP5588=m

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_CS5535 is not set
CONFIG_GPIO_BT8XX=m
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_TIMBERDALE is not set
CONFIG_GPIO_RDC321X=m

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MCP23S08=m

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=m
CONFIG_W1=m
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=m
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=m
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2408=m
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=m
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=m
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=m
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2760=m
CONFIG_BATTERY_DS2780=m
CONFIG_BATTERY_DS2781=m
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=m
CONFIG_BATTERY_BQ27x00=m
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=m
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_LP8727=m
CONFIG_CHARGER_GPIO=m
CONFIG_CHARGER_SMB347=m
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=m
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=m
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=m
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=m
CONFIG_SENSORS_K8TEMP=m
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_GL518SM=m
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_GPIO_FAN=m
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IBMAEM=m
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=m
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=m
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=m
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=m
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
# CONFIG_SENSORS_ADM1275 is not set
# CONFIG_SENSORS_LM25066 is not set
CONFIG_SENSORS_LTC2978=m
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX34440 is not set
CONFIG_SENSORS_MAX8688=m
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
CONFIG_SENSORS_ZL6100=m
CONFIG_SENSORS_SHT15=m
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=m
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=m
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=m
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA2XX=m
CONFIG_SENSORS_THMC50=m
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=m
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_APPLESMC is not set

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
CONFIG_ACQUIRE_WDT=m
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
CONFIG_ALIM7101_WDT=m
CONFIG_F71808E_WDT=m
CONFIG_SP5100_TCO=m
CONFIG_SC520_WDT=m
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=m
# CONFIG_IE6XX_WDT is not set
CONFIG_ITCO_WDT=m
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=m
# CONFIG_SBC8360_WDT is not set
CONFIG_CPU5_WDT=m
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=m
# CONFIG_W83697HF_WDT is not set
CONFIG_W83697UG_WDT=m
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_XEN_WDT=m

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
CONFIG_SSB_B43_PCI_BRIDGE=y
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=m
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_MFD_LM3533=m
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_CS5535=m
CONFIG_MFD_TIMBERDALE=m
CONFIG_LPC_SCH=m
CONFIG_LPC_ICH=m
CONFIG_MFD_RDC321X=m
CONFIG_MFD_JANZ_CMODIO=m
CONFIG_MFD_VX855=m
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_DUMMY is not set
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_AD5398=m
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_MAX1586=m
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
# CONFIG_REGULATOR_MAX8952 is not set
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_LP3972 is not set
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=m
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
CONFIG_STUB_POULSBO=m
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=m
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=m
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
# CONFIG_FB_WMT_GE_ROPS is not set
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
CONFIG_FB_CYBER2000=m
CONFIG_FB_CYBER2000_DDC=y
CONFIG_FB_ARC=m
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=m
CONFIG_FB_N411=m
# CONFIG_FB_HGA is not set
CONFIG_FB_S1D13XXX=m
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
CONFIG_FB_I740=m
CONFIG_FB_LE80578=m
# CONFIG_FB_CARILLO_RANCH is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
CONFIG_FB_ATY=m
# CONFIG_FB_ATY_CT is not set
CONFIG_FB_ATY_GX=y
# CONFIG_FB_ATY_BACKLIGHT is not set
# CONFIG_FB_S3 is not set
CONFIG_FB_SAVAGE=m
# CONFIG_FB_SAVAGE_I2C is not set
# CONFIG_FB_SAVAGE_ACCEL is not set
CONFIG_FB_SIS=m
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
CONFIG_FB_VIA=m
# CONFIG_FB_VIA_DIRECT_PROCFS is not set
# CONFIG_FB_VIA_X_COMPATIBILITY is not set
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=m
# CONFIG_FB_3DFX is not set
CONFIG_FB_VOODOO1=m
CONFIG_FB_VT8623=m
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=m
CONFIG_FB_PM3=m
CONFIG_FB_CARMINE=m
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
CONFIG_FB_VIRTUAL=m
CONFIG_XEN_FBDEV_FRONTEND=m
# CONFIG_FB_METRONOME is not set
CONFIG_FB_MB862XX=m
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
CONFIG_FB_BROADSHEET=m
CONFIG_FB_AUO_K190X=m
# CONFIG_FB_AUO_K1900 is not set
CONFIG_FB_AUO_K1901=m
CONFIG_EXYNOS_VIDEO=y
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=m

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE is not set
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=m
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_SSB is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
CONFIG_UWB=m
# CONFIG_UWB_WHCI is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=m
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
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
CONFIG_LEDS_LM3530=m
CONFIG_LEDS_LM3533=m
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_PCA9532_GPIO=y
CONFIG_LEDS_GPIO=m
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP5521=m
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_CLEVO_MAIL=m
CONFIG_LEDS_PCA955X=m
# CONFIG_LEDS_PCA9633 is not set
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=m
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_TCA6507=m
# CONFIG_LEDS_LM3556 is not set
CONFIG_LEDS_OT200=m
# CONFIG_LEDS_BLINKM is not set
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGER_TIMER=m
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
CONFIG_LEDS_TRIGGER_GPIO=m
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_A11Y_BRAILLE_CONSOLE is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV=m
CONFIG_UIO_PDRV_GENIRQ=m
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
CONFIG_UIO_NETX=m

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set

#
# Xen driver support
#
# CONFIG_XEN_BALLOON is not set
CONFIG_XEN_DEV_EVTCHN=m
CONFIG_XEN_BACKEND=y
# CONFIG_XENFS is not set
# CONFIG_XEN_SYS_HYPERVISOR is not set
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_GNTDEV is not set
CONFIG_XEN_GRANT_DEV_ALLOC=m
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_TMEM=y
CONFIG_XEN_PCIDEV_BACKEND=m
CONFIG_XEN_PRIVCMD=m
CONFIG_XEN_ACPI_PROCESSOR=m
CONFIG_STAGING=y
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
CONFIG_ECHO=m
CONFIG_COMEDI=m
CONFIG_COMEDI_DEBUG=y
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
# CONFIG_COMEDI_MISC_DRIVERS is not set
# CONFIG_COMEDI_PCI_DRIVERS is not set
# CONFIG_COMEDI_8255 is not set
CONFIG_R8187SE=m
CONFIG_RTLLIB=m
CONFIG_RTLLIB_CRYPTO_CCMP=m
CONFIG_RTLLIB_CRYPTO_TKIP=m
# CONFIG_RTLLIB_CRYPTO_WEP is not set
CONFIG_RTL8192E=m
CONFIG_RTS_PSTOR=m
CONFIG_RTS_PSTOR_DEBUG=y
# CONFIG_IDE_PHISON is not set
CONFIG_VT6655=m
CONFIG_DX_SEP=m
CONFIG_ZRAM=m
# CONFIG_ZRAM_DEBUG is not set
CONFIG_ZSMALLOC=m
CONFIG_FB_SM7XX=m
CONFIG_CRYSTALHD=m
CONFIG_FB_XGI=m
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_FT1000=m

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
# CONFIG_ASHMEM is not set
CONFIG_ANDROID_LOGGER=m
CONFIG_ANDROID_TIMED_OUTPUT=y
# CONFIG_ANDROID_TIMED_GPIO is not set
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
CONFIG_PHONE=m
CONFIG_PHONE_IXJ=m
# CONFIG_IPACK_BUS is not set
CONFIG_WIMAX_GDM72XX=m
CONFIG_WIMAX_GDM72XX_QOS=y
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
# CONFIG_INTEL_IOMMU is not set
# CONFIG_IRQ_REMAP is not set

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
# CONFIG_VIRT_DRIVERS is not set
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
CONFIG_VME_BUS=m

#
# VME Bridge Drivers
#
# CONFIG_VME_CA91CX42 is not set
# CONFIG_VME_TSI148 is not set

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=m

#
# VME Device Drivers
#
# CONFIG_VME_USER is not set
CONFIG_VME_PIO2=m
# CONFIG_PWM is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=m
# CONFIG_DMIID is not set
# CONFIG_DMI_SYSFS is not set
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=m
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
# CONFIG_EXT2_FS_POSIX_ACL is not set
# CONFIG_EXT2_FS_SECURITY is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=m
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=m
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_XIP=y
CONFIG_JBD=m
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=m
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=m
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=m
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=m
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=m
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=m
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=m
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=m
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=m
# CONFIG_NLS_UTF8 is not set
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_SLUB_STATS=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_PREEMPT=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_LKDTM is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
# CONFIG_EVENT_POWER_TRACING_DEPRECATED is not set
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_PREEMPT_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_KPROBE_EVENT=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
# CONFIG_EVENT_TRACE_TEST_SYSCALLS is not set
CONFIG_MMIOTRACE=y
# CONFIG_MMIOTRACE_TEST is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_FIREWIRE_OHCI_REMOTE_DMA=y
CONFIG_BUILD_DOCSRC=y
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DMA_API_DEBUG=y
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_KSTRTOX=m
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
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
CONFIG_CRYPTO_USER=m
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
# CONFIG_CRYPTO_AUTHENC is not set
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER_X86=m
CONFIG_CRYPTO_GLUE_HELPER_X86=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
# CONFIG_CRYPTO_CBC is not set
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=m
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_GHASH=m
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=m
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
# CONFIG_CRYPTO_SHA256 is not set
CONFIG_CRYPTO_SHA512=m
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=m
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_X86_64=m
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA=m
# CONFIG_CRYPTO_CAMELLIA_X86_64 is not set
CONFIG_CRYPTO_CAST5=m
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_X86_64=m
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_CRC8=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=m
CONFIG_DDR=y

--OXfL5xGRrasGEqWY--
