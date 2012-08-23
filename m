Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098Ab2HWAzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 20:55:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:26973 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab2HWAza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 20:55:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,297,1344236400"; 
   d="scan'208";a="208999193"
Date: Thu, 23 Aug 2012 08:55:15 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Ido Yariv <ido@wizery.com>
Cc: Shai Fultheim <shai@scalemp.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: WARNING: at vsmp_64.c: is_vsmp_box()
Message-ID: <20120823005515.GA3071@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Ido,

The below warning should be introduced by this commit at tip/master:

commit c00679af441c5be76e195deed2c76fef65a5d102
Author:     Ido Yariv <ido@wizery.com>
CommitDate: Wed Aug 22 10:48:05 2012 +0200

    x86/vsmp: Use hypervisor layer for initialization
   
[    0.000000] tsc: Detected 3200.098 MHz processor
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at /c/kernel-tests/src/tip/arch/x86/kernel/vsmp_64.c:158 is_vsmp_box+0xa1/0xb0()
[    0.000000] Hardware name: Bochs
[    0.000000] Pid: 0, comm: swapper/0 Not tainted 3.6.0-rc2-01612-g595b3f3 #292
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8105a12a>] ? warn_slowpath_common+0x7a/0xb0
[    0.000000]  [<ffffffff810339f1>] ? is_vsmp_box+0xa1/0xb0
[    0.000000]  [<ffffffff818125d5>] ? apic_is_clustered_box+0x34/0x4c
[    0.000000]  [<ffffffff8180baa4>] ? unsynchronized_tsc+0x23/0x71
[    0.000000]  [<ffffffff81f8330c>] ? tsc_init+0xc2/0xed
[    0.000000]  [<ffffffff81f7cc0d>] ? start_kernel+0x3fd/0x47a
[    0.000000]  [<ffffffff81f7c627>] ? repair_env_string+0x5b/0x5b
[    0.000000]  [<ffffffff81f7c436>] ? x86_64_start_kernel+0x105/0x114

Thanks,
Fengguang

--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-fat-27986-2012-08-22-18-20-17-3.6.0-rc2-01612-g595b3f3-292"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.0-rc2-01612-g595b3f3 (kbuild@snb) (gcc ver=
sion 4.7.1 (Debian 4.7.1-6) ) #292 SMP Wed Aug 22 18:14:53 CST 2012
[    0.000000] Command line: trinity=3D2m hung_task_panic=3D1 branch=3Dtip/=
master log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dyna=
mic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3Dtt=
yS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3Dvmlinuz-=
2012-08-22-18-15-35-tip:master:595b3f3-595b3f3-x86_64-randconfig-s153-4-fat=
 BOOT_IMAGE=3Dkernel-tests/kernels/x86_64-randconfig-s153/595b3f3/vmlinuz-3=
=2E6.0-rc2-01612-g595b3f3
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
[    0.000000] early log buf free: 128020(97%)
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
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0e8c7000-0x0e8d5fff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1f7b041, boot clock
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
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
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
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88000de00000 s80960 r0 d2=
1440 u1048576
[    0.000000] pcpu-alloc: s80960 r0 d21440 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:de13041, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr de0de00
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 64379
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: trinity=3D2m hung_task_panic=3D1 branch=
=3Dtip/master log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddeb=
ug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 conso=
le=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3Dv=
mlinuz-2012-08-22-18-15-35-tip:master:595b3f3-595b3f3-x86_64-randconfig-s15=
3-4-fat BOOT_IMAGE=3Dkernel-tests/kernels/x86_64-randconfig-s153/595b3f3/vm=
linuz-3.6.0-rc2-01612-g595b3f3
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 207968k/262136k available (8404k kernel code, 500k a=
bsent, 53668k reserved, 7367k data, 628k init)
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D2, Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 3200.098 MHz processor
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at /c/kernel-tests/src/tip/arch/x86/kernel/vsmp_64.=
c:158 is_vsmp_box+0xa1/0xb0()
[    0.000000] Hardware name: Bochs
[    0.000000] Pid: 0, comm: swapper/0 Not tainted 3.6.0-rc2-01612-g595b3f3=
 #292
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8105a12a>] ? warn_slowpath_common+0x7a/0xb0
[    0.000000]  [<ffffffff810339f1>] ? is_vsmp_box+0xa1/0xb0
[    0.000000]  [<ffffffff818125d5>] ? apic_is_clustered_box+0x34/0x4c
[    0.000000]  [<ffffffff8180baa4>] ? unsynchronized_tsc+0x23/0x71
[    0.000000]  [<ffffffff81f8330c>] ? tsc_init+0xc2/0xed
[    0.000000]  [<ffffffff81f7cc0d>] ? start_kernel+0x3fd/0x47a
[    0.000000]  [<ffffffff81f7c627>] ? repair_env_string+0x5b/0x5b
[    0.000000]  [<ffffffff81f7c436>] ? x86_64_start_kernel+0x105/0x114
[    0.000000] ---[ end trace 349186f5d6d73a21 ]---
[    0.020001] Calibrating delay loop (skipped) preset value.. 6400.19 Bogo=
MIPS (lpj=3D12800392)
[    0.020001] pid_max: default: 32768 minimum: 301
[    0.020059] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.021355] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.022502] Mount-cache hash table entries: 256
[    0.024084] Initializing cgroup subsys debug
[    0.024902] Initializing cgroup subsys cpuacct
[    0.025727] Initializing cgroup subsys devices
[    0.026555] Initializing cgroup subsys freezer
[    0.027379] Initializing cgroup subsys net_prio
[    0.028062] mce: CPU supports 10 MCE banks
[    0.028843] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.028843] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.028843] tlb_flushall_shift: 6
[    0.034082] ACPI: Core revision 20120711
[    0.035727] Getting VERSION: 50014
[    0.036011] Getting VERSION: 50014
[    0.036676] Getting ID: 0
[    0.037271] Getting ID: ff000000
[    0.037972] Getting LVT0: 8700
[    0.038593] Getting LVT1: 8400
[    0.039310] enabled ExtINT on CPU#0
[    0.040675] ENABLING IO-APIC IRQs
[    0.041383] init IO_APIC IRQs
[    0.042004]  apic 2 pin 0 not connected
[    0.042717] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.044019] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.045421] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.046875] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.048018] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.049501] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.050936] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.052017] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.053444] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.056018] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.057469] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.058916] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.060018] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.061470] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.062971] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.064017]  apic 2 pin 16 not connected
[    0.064780]  apic 2 pin 17 not connected
[    0.065544]  apic 2 pin 18 not connected
[    0.066312]  apic 2 pin 19 not connected
[    0.068007]  apic 2 pin 20 not connected
[    0.068771]  apic 2 pin 21 not connected
[    0.069535]  apic 2 pin 22 not connected
[    0.070300]  apic 2 pin 23 not connected
[    0.071151] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.072007] smpboot: CPU0: Intel Common KVM processor stepping 01
[    0.073333] Using local APIC timer interrupts.
[    0.073333] calibrating APIC timer ...
[    0.076004] ... lapic delta =3D 6254221
[    0.076004] ... PM-Timer delta =3D 358195
[    0.076004] ... PM-Timer result ok
[    0.076004] ..... delta 6254221
[    0.076004] ..... mult: 268599959
[    0.076004] ..... calibration result: 4002701
[    0.076004] ..... CPU clock speed is 3202.1043 MHz.
[    0.076004] ..... host bus clock speed is 1000.2701 MHz.
[    0.076044] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.078154] Testing tracer nop: PASSED
[    0.079502] smpboot: Booting Node   0, Processors  #1 OK
[    0.020001] kvm-clock: cpu 1, msr 0:df13041, secondary cpu clock
[    0.020001] masked ExtINT on CPU#1
[    0.100032] Brought up 2 CPUs
[    0.100029] KVM setup async PF for cpu 1
[    0.100029] kvm-stealtime: cpu 1, msr df0de00
[    0.102099] smpboot: Total of 2 processors activated (12800.39 BogoMIPS)
[    0.103358] CPU0 attaching sched-domain:
[    0.104011]  domain 0: span 0-1 level CPU
[    0.104803]   groups: 0 1
[    0.105576] CPU1 attaching sched-domain:
[    0.106281]  domain 0: span 0-1 level CPU
[    0.107071]   groups: 1 0
[    0.108778] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.109237] dummy:=20
[    0.109815] NET: Registered protocol family 16
[    0.110764] i2c-core: driver [dummy] registered
[    0.112149] ACPI: bus type pci registered
[    0.112914] dca service started, version 1.12.1
[    0.113724] PCI: Using configuration type 1 for base access
[    0.115469] bio: create slab <bio-0> at 0
[    0.116075] ACPI: Added _OSI(Module Device)
[    0.116819] ACPI: Added _OSI(Processor Device)
[    0.117582] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.118377] ACPI: Added _OSI(Processor Aggregator Device)
[    0.120457] ACPI: EC: Look up EC in DSDT
[    0.122655] ACPI: Interpreter enabled
[    0.123343] ACPI: (supports S0 S5)
[    0.124010] ACPI: Using IOAPIC for interrupt routing
[    0.127083] PCI: Ignoring host bridge windows from ACPI; if necessary, u=
se "pci=3Duse_crs" and report a bug
[    0.128027] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.129002] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] =
(ignored)
[    0.130315] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] =
(ignored)
[    0.132012] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x00=
0bffff] (ignored)
[    0.133398] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfe=
bfffff] (ignored)
[    0.134780] PCI: root bus 00: using default resources
[    0.136040] PCI host bridge to bus 0000:00
[    0.136779] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under dom=
ain [bus 00-ff]
[    0.138152] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.139034] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.140013] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffff=
fff]
[    0.141103] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.142280] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.143577] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.145545] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    0.147325] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.148310] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.149607] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.150799] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.153135] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.155005] pci 0000:00:02.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    0.160090] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.161597] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.162882] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.164635] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.168653] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.170048] pci 0000:00:04.0: [8086:2668] type 00 class 0x040300
[    0.171203] pci 0000:00:04.0: reg 10: [mem 0xfebf0000-0xfebf3fff]
[    0.174405] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.175717] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    0.176636] pci 0000:00:05.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    0.181787] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.183093] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    0.184641] pci 0000:00:06.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    0.189168] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.190480] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.192042] pci 0000:00:07.0: reg 14: [mem 0xfebf7000-0xfebf7fff]
[    0.196554] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.197860] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    0.199360] pci 0000:00:08.0: reg 14: [mem 0xfebf8000-0xfebf8fff]
[    0.204126] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.205430] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    0.206947] pci 0000:00:09.0: reg 14: [mem 0xfebf9000-0xfebf9fff]
[    0.211345] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.212384] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    0.213876] pci 0000:00:0a.0: reg 14: [mem 0xfebfa000-0xfebfafff]
[    0.218682] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    0.219823] pci 0000:00:0b.0: reg 10: [mem 0xfebfb000-0xfebfb00f]
[    0.222316] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.224476]  pci0000:00: ACPI _OSC support notification failed, disablin=
g PCIe ASPM
[    0.225812]  pci0000:00: Unable to request _OSC control (_OSC support ma=
sk: 0x08)
[    0.231141] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.232395] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.233705] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.235018] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.236382] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.237623] i2c-core: driver [ad5398] registered
[    0.240024] i2c-core: driver [max8649] registered
[    0.240833] i2c-core: driver [max8660] registered
[    0.241659] i2c-core: driver [tps65023] registered
[    0.242556] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.244022] vgaarb: loaded
[    0.244601] vgaarb: bridge control possible 0000:00:02.0
[    0.245502] i2c-core: driver [88PM860x] registered
[    0.246317] i2c-core: driver [tps6105x] registered
[    0.248024] i2c-core: driver [twl] registered
[    0.248802] i2c-core: driver [da903x] registered
[    0.249602] i2c-core: driver [max8925] registered
[    0.250406] i2c-core: driver [max8998] registered
[    0.251213] i2c-core: driver [pcf50633] registered
[    0.252024] i2c-core: driver [ab3100] registered
[    0.252824] i2c-core: driver [tps65090] registered
[    0.253640] i2c-core: driver [rc5t583] registered
[    0.254572] SCSI subsystem initialized
[    0.255280] ACPI: bus type scsi registered
[    0.256063] libata version 3.00 loaded.
[    0.256815] i2c-core: driver [tca6416-keypad] registered
[    0.257689] i2c-core: driver [tca8418_keypad] registered
[    0.258658] PCI: Using ACPI for IRQ routing
[    0.259402] PCI: pci_cache_line_size set to 64 bytes
[    0.260242] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    0.261182] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.262298] NET: Registered protocol family 23
[    0.263101] NET: Registered protocol family 8
[    0.264019] NET: Registered protocol family 20
[    0.264989] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.272060] Switching to clocksource kvm-clock
[    0.272827] Warning: could not register annotated branches stats
[    0.278357] FS-Cache: Loaded
[    0.279007] pnp: PnP ACPI init
[    0.279652] ACPI: bus type pnp registered
[    0.280420] pnp 00:00: [bus 00-ff]
[    0.281093] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.281835] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.282705] pnp 00:00: [io  0x0d00-0xffff window]
[    0.283569] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.284520] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    0.285503] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.286540] pnp 00:01: [io  0x0070-0x0071]
[    0.287295] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.288851] pnp 00:01: [irq 8]
[    0.289532] pnp 00:01: [io  0x0072-0x0077]
[    0.290296] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.291413] pnp 00:02: [io  0x0060]
[    0.292158] pnp 00:02: [io  0x0064]
[    0.292939] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.294385] pnp 00:02: [irq 1]
[    0.295080] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.296207] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.297727] pnp 00:03: [irq 12]
[    0.298372] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.299546] pnp 00:04: [io  0x03f2-0x03f5]
[    0.300298] pnp 00:04: [io  0x03f7]
[    0.301071] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.302619] pnp 00:04: [irq 6]
[    0.303237] pnp 00:04: [dma 2]
[    0.303941] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.305079] pnp 00:05: [io  0x0378-0x037f]
[    0.305936] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.307400] pnp 00:05: [irq 7]
[    0.308103] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.309211] pnp 00:06: [io  0x03f8-0x03ff]
[    0.310007] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.311604] pnp 00:06: [irq 4]
[    0.312260] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.313496] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    0.314330] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.315617] pnp: PnP ACPI: found 8 devices
[    0.316370] ACPI: ACPI bus type pnp unregistered
[    0.322821] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.323782] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[    0.324926] NET: Registered protocol family 1
[    0.325824] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.326885] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.327926] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.329059] pci 0000:00:02.0: Boot video device
[    0.329985] PCI: CLS 0 bytes, default 64
[    0.330847] Trying to unpack rootfs image as initramfs...
[    0.820372] Freeing initrd memory: 23656k freed
[    0.824970] Machine check injector initialized
[    0.825801] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    0.827501] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    0.830079] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.831155] audit: initializing netlink socket (disabled)
[    0.832062] type=3D2000 audit(1345630812.832:1): initialized
[    0.908068] Testing tracer function: PASSED
[    1.108593] Testing ftrace regs(no arch support): PASSED
[    1.288154] Testing tracer wakeup: PASSED
[    1.768201] Testing tracer wakeup_rt: [    1.824153] tsc: Refined TSC cl=
ocksource calibration: 3200.115 MHz
PASSED
[    2.248191] Testing tracer branch: PASSED
[    2.533016] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.535126] VFS: Disk quotas dquot_6.5.2
[    2.535916] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.537341] OCFS2 1.5.0
[    2.538148] OCFS2 DLMFS 1.5.0
[    2.538894] OCFS2 User DLM kernel interface loaded
[    2.539715] OCFS2 Node Manager 1.5.0
[    2.542217] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    2.543562] io scheduler noop registered
[    2.544324] io scheduler cfq registered (default)
[    2.545288] xz_dec_test: module loaded
[    2.545990] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
252 0' and write .xz files to it.
[    2.547588] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.548531] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.549635] vmlfb: initializing
[    2.550287] no IO addresses supplied
[    2.551083] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    2.552422] ACPI: Power Button [PWRF]
[    2.553386] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    2.559320] HDLC line discipline maxframe=3D4096
[    2.560102] N_HDLC line discipline registered.
[    2.560898] r3964: Philips r3964 Driver $Revision: 1.10 $
[    2.561784] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.584052] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    2.606496] 00:06: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    2.607546] MOXA Intellio family driver version 6.0k
[    2.609559] SyncLink GT
[    2.610126] SyncLink GT, tty major#250
[    2.610840] SyncLink GT no devices found
[    2.611601] lp: driver loaded but no devices found
[    2.612467] Real Time Clock Driver v1.12b
[    2.613212] Non-volatile memory driver v1.3
[    2.613993] smapi::smapi_init, ERROR invalid usSmapiID
[    2.614854] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    2.616396] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    2.617696] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    2.618683] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    2.620283] Hangcheck: Using getrawmonotonic().
[    2.621098] parport_pc 00:05: reported by Plug and Play ACPI
[    2.622117] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    2.716073] lp0: using parport0 (interrupt-driven).
[    2.716922] lp0: console ready
[    2.718104] Floppy drive(s): fd0 is 1.44M
[    2.718735] brd: module loaded
[    2.718736] HP CISS Driver (v 3.6.26)
[    2.720858] nbd: registered device at major 43
[    2.722255] lkdtm: No crash points registered, enable through debugfs
[    2.723285] i2c-core: driver [at24] registered
[    2.724072] i2c-core: driver [eeprom] registered
[    2.724919] i2c-core: driver [lis3lv02d_i2c] registered
[    2.725835] Loading iSCSI transport class v2.0-870.
[    2.726776] rdac: device handler registered
[    2.727585] hp_sw: device handler registered
[    2.728573] Rounding down aligned max_sectors from 4294967295 to 8388600
[    2.730195] mkiss: AX.25 Multikiss, Hans Albas PE1AYX
[    2.731050] AX.25: 6pack driver, Revision: 0.3.0
[    2.731845] YAM driver version 0.8 by F1OAT/F6FBB
[    2.732845] AX.25: bpqether driver version 004
[    2.733630] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    2.733630] baycom_ser_fdx: version 0.10
[    2.735438] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[    2.736391] hdlcdrv: version 0.8
[    2.737027] baycom_par: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    2.737027] baycom_par: version 0.9
[    2.739209] aoe: AoE v47 initialised.
[    2.739400] FDC 0 is a S82078B
[    2.740770] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    2.742745] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.743594] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.747388] mousedev: PS/2 mouse device common for all mice
[    2.748341] i2c-core: driver [adp5588_keys] registered
[    2.749208] i2c-core: driver [lm8333] registered
[    2.750016] i2c-core: driver [max7359] registered
[    2.750838] i2c-core: driver [mpr121] registered
[    2.751686] i2c-core: driver [as5011] registered
[    2.752538] i2c-core: driver [ad714x_captouch] registered
[    2.753424] i2c-core: driver [bma150] registered
[    2.754231] i2c-core: driver [kxtj9] registered
[    2.755034] i2c-core: driver [mma8450] registered
[    2.755853] i2c-core: driver [mpu3050] registered
[    2.756725] input: PC Speaker as /devices/platform/pcspkr/input/input1
[    2.757784] I2O subsystem v1.325
[    2.758433] i2o: max drivers =3D 8
[    2.759320] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input2
[    2.760834] I2O Bus Adapter OSM v1.317
[    2.761585] I2O Block Device OSM v1.325
[    2.762378] I2O ProcFS OSM v1.316
[    2.763060] i2c-core: driver [smbus_alert] registered
[    2.763915] i2c /dev entries driver
[    2.764644] i2c-parport: adapter type unspecified
[    2.765502] ISDN subsystem Rev: 1.1.2.3/1.1.2.2/none/none/1.1.2.2
[    2.766877] CAPI 2.0 started up with major 68 (middleware)
[    2.767793] b1pci: revision 1.1.2.2
[    2.768484] b1: revision 1.1.2.2
[    2.769125] b1dma: revision 1.1.2.3
[    2.769797] t1pci: revision 1.1.2.2
[    2.770484] c4: revision 1.1.2.2
[    2.771148] dss1_divert module successfully installed
[    2.771992] HiSax: Linux Driver for passive ISDN cards
[    2.772862] HiSax: Version 3.5 (kernel)
[    2.773578] HiSax: Layer1 Revision 2.46.2.5
[    2.774329] HiSax: Layer2 Revision 2.30.2.4
[    2.775068] HiSax: TeiMgr Revision 2.20.2.3
[    2.775821] HiSax: Layer3 Revision 2.22.2.3
[    2.776603] HiSax: LinkLayer Revision 2.59.2.4
[    2.777382] HiSax: Total 1 card defined
[    2.778108] HiSax: Card 1 Protocol 1TR6 Id=3DHiSax (0)
[    2.778960] HiSax: Traverse Tech. NETspider-U driver Rev. 2.14.2.3
[    2.779927] NETspider-U: No PCI card found
[    2.780691] HiSax: Card NETspider-U not installed !
[    2.781536] gigaset: Driver for Gigaset 307x (debug build)
[    2.782422] gigaset: Kernel CAPI interface
[    2.783191] cpuidle: using governor ladder
[    2.783949] cpuidle: using governor menu
[    2.784691] sdhci: Secure Digital Host Controller Interface driver
[    2.785666] sdhci: Copyright(c) Pierre Ossman
[    2.786450] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    2.787382] wbsd: Copyright(c) Pierre Ossman
[    2.788157] via_sdmmc: VIA SD/MMC Card Reader driver (C) 2008 VIA Techno=
logies, Inc.
[    2.789561] sdhci-pltfm: SDHCI platform and OF driver helper
[    2.790523] cs5535-clockevt: Could not allocate MFGPT timer
[    2.902595] panel: driver version 0.9.5 registered on parport0 (io=3D0x3=
78).
[    2.903646] Initializing Realtek PCIE storage driver...
[    2.904559] BUG: unable to handle kernel NULL pointer dereference at 000=
0000000000070
[    2.906065] IP: [<ffffffff816f8350>] iio_buffer_register+0x20/0x380
[    2.907144] PGD 0=20
[    2.907720] Oops: 0000 [#1] SMP=20
[    2.908513] CPU 0=20
[    2.908528] Pid: 1, comm: swapper/0 Tainted: G        W    3.6.0-rc2-016=
12-g595b3f3 #292 Bochs Bochs
[    2.908528] RIP: 0010:[<ffffffff816f8350>]  [<ffffffff816f8350>] iio_buf=
fer_register+0x20/0x380
[    2.908528] RSP: 0018:ffff88000d0b7e50  EFLAGS: 00010246
[    2.908528] RAX: ffff88000d1ca6e8 RBX: 0000000000000000 RCX: 00000000000=
00000
[    2.908528] RDX: 0000000000000005 RSI: ffffffff81ea9a00 RDI: ffff88000d1=
ea800
[    2.908528] RBP: ffff88000d0b7eb0 R08: 000000000000000a R09: 00000000000=
0fffe
[    2.908528] R10: 0000000000000000 R11: 0000000000000006 R12: 00000000000=
00145
[    2.908528] R13: ffffffff81fb8a66 R14: ffff88000d1ea800 R15: 00000000000=
00000
[    2.908528] FS:  0000000000000000(0000) GS:ffff88000de00000(0000) knlGS:=
0000000000000000
[    2.908528] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    2.908528] CR2: 0000000000000070 CR3: 0000000001e15000 CR4: 00000000000=
006f0
[    2.908528] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[    2.908528] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[    2.908528] Process swapper/0 (pid: 1, threadinfo ffff88000d0b6000, task=
 ffff88000d032000)
[    2.908528] Stack:
[    2.908528]  ffff88000d0b7ea0 ffff88000d0b7e60 ffff88000d0b7e90 ffff8800=
0d1ea800
[    2.908528]  0000000000000000 000000000000023c 0000000000013fd0 00000000=
00000000
[    2.908528]  0000000000000145 ffffffff81fb8a66 0000000000000000 00000000=
00000000
[    2.908528] Call Trace:
[    2.908528]  [<ffffffff81fb8a66>] ? rtsx_init+0x25/0x25
[    2.908528]  [<ffffffff81fb8b6e>] ? iio_dummy_init+0x108/0x15a
[    2.908528]  [<ffffffff81f7ccff>] ? do_one_initcall+0x75/0x131
[    2.908528]  [<ffffffff81f7ced1>] ? kernel_init+0x116/0x19a
[    2.908528]  [<ffffffff81f7c5cc>] ? do_early_param+0x83/0x83
[    2.908528]  [<ffffffff81833084>] ? kernel_thread_helper+0x4/0x10
[    2.908528]  [<ffffffff81f7cdbb>] ? do_one_initcall+0x131/0x131
[    2.908528]  [<ffffffff81833080>] ? gs_change+0x13/0x13
[    2.908528] Code: 00 48 83 c7 50 5d e9 90 a0 98 ff 55 48 89 e5 41 57 41 =
56 41 55 41 54 53 48 83 ec 38 e8 7a 9a 13 00 4c 8b bf 48 02 00 00 49 89 fe =
<49> 8b 47 70 48 85 c0 74 1b 8b 8f b8 03 00 00 48 63 f9 83 c1 01=20
[    2.908528] RIP  [<ffffffff816f8350>] iio_buffer_register+0x20/0x380
[    2.908528]  RSP <ffff88000d0b7e50>
[    2.908528] CR2: 0000000000000070
[    2.948884] ---[ end trace 349186f5d6d73a22 ]---
[    2.949684] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x00000009
[    2.949684]=20
[    2.951518] Rebooting in 10 seconds..
--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.6.0-rc2-01612-g595b3f3"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.6.0-rc2 Kernel Configuration
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
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
# CONFIG_EXPERIMENTAL is not set
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
# CONFIG_KERNEL_BZIP2 is not set
CONFIG_KERNEL_LZMA=y
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_FHANDLE=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
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
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
CONFIG_CGROUP_CPUACCT=y
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
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
# CONFIG_JUMP_LABEL is not set
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
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
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
# CONFIG_ACORN_PARTITION_EESOX is not set
CONFIG_ACORN_PARTITION_ICS=y
# CONFIG_ACORN_PARTITION_ADFS is not set
# CONFIG_ACORN_PARTITION_POWERTEC is not set
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
# CONFIG_SOLARIS_X86_PARTITION is not set
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
CONFIG_ULTRIX_PARTITION=y
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
CONFIG_INLINE_READ_UNLOCK=y
# CONFIG_INLINE_READ_UNLOCK_BH is not set
CONFIG_INLINE_READ_UNLOCK_IRQ=y
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
CONFIG_INLINE_WRITE_UNLOCK=y
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_VSMP=y
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
# CONFIG_KVMTOOL_TEST_ENABLE is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=12
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
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
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
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
# CONFIG_FRONTSWAP is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
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
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_STAT is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

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
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
# CONFIG_PCIEAER is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
# CONFIG_PCIEASPM_DEFAULT is not set
CONFIG_PCIEASPM_POWERSAVE=y
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=y
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
CONFIG_RAPIDIO=y
# CONFIG_RAPIDIO_TSI721 is not set
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
CONFIG_RAPIDIO_DMA_ENGINE=y
# CONFIG_RAPIDIO_DEBUG is not set
CONFIG_RAPIDIO_TSI57X=y
# CONFIG_RAPIDIO_CPS_XX is not set
CONFIG_RAPIDIO_TSI568=y
# CONFIG_RAPIDIO_CPS_GEN2 is not set
# CONFIG_RAPIDIO_TSI500 is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_NET_KEY=y
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set
# CONFIG_BRIDGE_NF_EBTABLES is not set
CONFIG_ATM=y
CONFIG_ATM_LANE=y
CONFIG_STP=y
CONFIG_BRIDGE=y
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=y
# CONFIG_DEV_APPLETALK is not set
# CONFIG_PHONET is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=y
# CONFIG_NET_SCH_HFSC is not set
CONFIG_NET_SCH_ATM=y
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
CONFIG_NET_SCH_SFB=y
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
CONFIG_NET_SCH_CODEL=y
CONFIG_NET_SCH_FQ_CODEL=y
CONFIG_NET_SCH_INGRESS=y
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=y
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
CONFIG_NET_EMATCH_NBYTE=y
CONFIG_NET_EMATCH_U32=y
# CONFIG_NET_EMATCH_META is not set
# CONFIG_NET_EMATCH_TEXT is not set
# CONFIG_NET_EMATCH_CANID is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
# CONFIG_NET_ACT_GACT is not set
CONFIG_NET_ACT_MIRRED=y
CONFIG_NET_ACT_NAT=y
CONFIG_NET_ACT_PEDIT=y
# CONFIG_NET_ACT_SIMP is not set
CONFIG_NET_ACT_SKBEDIT=y
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NETPRIO_CGROUP=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
CONFIG_AX25_DAMA_SLAVE=y
CONFIG_NETROM=y
# CONFIG_ROSE is not set

#
# AX.25 network device drivers
#
CONFIG_MKISS=y
CONFIG_6PACK=y
CONFIG_BPQETHER=y
CONFIG_BAYCOM_SER_FDX=y
# CONFIG_BAYCOM_SER_HDX is not set
CONFIG_BAYCOM_PAR=y
CONFIG_YAM=y
CONFIG_CAN=y
CONFIG_CAN_RAW=y
# CONFIG_CAN_BCM is not set
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
# CONFIG_CAN_SLCAN is not set
# CONFIG_CAN_DEV is not set
CONFIG_CAN_DEBUG_DEVICES=y
CONFIG_IRDA=y

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
# CONFIG_IRCOMM is not set
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
# CONFIG_IRDA_FAST_RR is not set
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=y

#
# Dongle support
#
CONFIG_DONGLE=y
CONFIG_ESI_DONGLE=y
# CONFIG_ACTISYS_DONGLE is not set
CONFIG_TEKRAM_DONGLE=y
# CONFIG_TOIM3232_DONGLE is not set
CONFIG_LITELINK_DONGLE=y

#
# FIR device drivers
#
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
# CONFIG_SMC_IRCC_FIR is not set
# CONFIG_VIA_FIR is not set
# CONFIG_BT is not set
# CONFIG_WIRELESS is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_NET_9P=y
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
CONFIG_CAIF_NETDEV=y
# CONFIG_CAIF_USB is not set
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
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
CONFIG_BLK_CPQ_CISS_DA=y
CONFIG_CISS_SCSI_TAPE=y
CONFIG_BLK_DEV_DAC960=y
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
CONFIG_BLK_DEV_NBD=y
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
# CONFIG_CDROM_PKTCDVD is not set
CONFIG_ATA_OVER_ETH=y
# CONFIG_BLK_DEV_HD is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
# CONFIG_PHANTOM is not set
CONFIG_INTEL_MID_PTI=y
# CONFIG_SGI_IOC4 is not set
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
CONFIG_CS5535_CLOCK_EVENT_SRC=y
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_93CX6=y
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_ENCLOSURE=y
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
# CONFIG_SCSI_SAS_HOST_SMP is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
# CONFIG_SCSI_DH_EMC is not set
CONFIG_SCSI_OSD_INITIATOR=y
# CONFIG_SCSI_OSD_ULD is not set
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
CONFIG_SATA_AHCI_PLATFORM=y
# CONFIG_SATA_INIC162X is not set
CONFIG_SATA_ACARD_AHCI=y
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
# CONFIG_MD is not set
CONFIG_TARGET_CORE=y
# CONFIG_TCM_IBLOCK is not set
# CONFIG_TCM_FILEIO is not set
CONFIG_TCM_PSCSI=y
CONFIG_LOOPBACK_TARGET=y
CONFIG_ISCSI_TARGET=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
# CONFIG_I2O_EXT_ADAPTEC is not set
# CONFIG_I2O_CONFIG is not set
CONFIG_I2O_BUS=y
CONFIG_I2O_BLOCK=y
# CONFIG_I2O_SCSI is not set
CONFIG_I2O_PROC=y
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
# CONFIG_NETDEVICES is not set
CONFIG_ISDN=y
CONFIG_ISDN_I4L=y
# CONFIG_ISDN_AUDIO is not set

#
# ISDN feature submodules
#
CONFIG_ISDN_DIVERSION=y

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=y

#
# D-channel protocol features
#
# CONFIG_HISAX_EURO is not set
CONFIG_HISAX_1TR6=y
# CONFIG_HISAX_NI1 is not set
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
CONFIG_HISAX_16_3=y
# CONFIG_HISAX_TELESPCI is not set
CONFIG_HISAX_S0BOX=y
CONFIG_HISAX_FRITZPCI=y
# CONFIG_HISAX_AVM_A1_PCMCIA is not set
# CONFIG_HISAX_ELSA is not set
CONFIG_HISAX_DIEHLDIVA=y
CONFIG_HISAX_SEDLBAUER=y
CONFIG_HISAX_NETJET=y
CONFIG_HISAX_NETJET_U=y
# CONFIG_HISAX_NICCY is not set
CONFIG_HISAX_BKM_A4T=y
CONFIG_HISAX_SCT_QUADRO=y
# CONFIG_HISAX_GAZEL is not set
CONFIG_HISAX_HFC_PCI=y
# CONFIG_HISAX_W6692 is not set
# CONFIG_HISAX_HFC_SX is not set
CONFIG_HISAX_ENTERNOW_PCI=y
CONFIG_HISAX_DEBUG=y

#
# HiSax PCMCIA card service modules
#

#
# HiSax sub driver modules
#

#
# Active cards
#
CONFIG_ISDN_CAPI=y
# CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON is not set
# CONFIG_CAPI_TRACE is not set
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPI20=y
CONFIG_ISDN_CAPI_CAPIDRV=y

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
CONFIG_ISDN_DRV_AVMB1_B1PCI=y
# CONFIG_ISDN_DRV_AVMB1_B1PCIV4 is not set
CONFIG_ISDN_DRV_AVMB1_T1PCI=y
CONFIG_ISDN_DRV_AVMB1_C4=y
# CONFIG_CAPI_EICON is not set
CONFIG_ISDN_DRV_GIGASET=y
CONFIG_GIGASET_CAPI=y
# CONFIG_GIGASET_I4L is not set
# CONFIG_GIGASET_DUMMYLL is not set
CONFIG_GIGASET_M101=y
CONFIG_GIGASET_DEBUG=y
# CONFIG_MISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
# CONFIG_INPUT_SPARSEKMAP is not set
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=y
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_TCA6416=y
CONFIG_KEYBOARD_TCA8418=y
CONFIG_KEYBOARD_LM8333=y
CONFIG_KEYBOARD_MAX7359=y
# CONFIG_KEYBOARD_MCS is not set
CONFIG_KEYBOARD_MPR121=y
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_OPENCORES=y
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_OMAP4=y
CONFIG_KEYBOARD_TWL4030=y
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=y
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_ZHENHUA is not set
CONFIG_JOYSTICK_DB9=y
# CONFIG_JOYSTICK_GAMECON is not set
CONFIG_JOYSTICK_TURBOGRAFX=y
CONFIG_JOYSTICK_AS5011=y
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM860X_ONKEY=y
CONFIG_INPUT_AD714X=y
CONFIG_INPUT_AD714X_I2C=y
CONFIG_INPUT_BMA150=y
CONFIG_INPUT_PCSPKR=y
CONFIG_INPUT_MAX8925_ONKEY=y
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_MPU3050=y
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
CONFIG_INPUT_KXTJ9=y
# CONFIG_INPUT_KXTJ9_POLLED_MODE is not set
# CONFIG_INPUT_POWERMATE is not set
CONFIG_INPUT_TWL4030_PWRBUTTON=y
# CONFIG_INPUT_TWL4030_VIBRA is not set
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF50633_PMU=y
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PARKBD is not set
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
# CONFIG_GAMEPORT_L4 is not set
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
CONFIG_MOXA_INTELLIO=y
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
CONFIG_SYNCLINK_GT=y
# CONFIG_ISI is not set
CONFIG_N_HDLC=y
CONFIG_TRACE_ROUTER=y
CONFIG_TRACE_SINK=y
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
CONFIG_SERIAL_MFD_HSU=y
CONFIG_SERIAL_MFD_HSU_CONSOLE=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS=y
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
# CONFIG_PPDEV is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_NVRAM=y
CONFIG_RTC=y
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
CONFIG_MWAVE=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI15X3=y
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=y
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_DESIGNWARE_PCI=y
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=y
# CONFIG_I2C_PARPORT_LIGHT is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_DEBUG_CORE=y
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_HSI is not set

#
# PPS support
#

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
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_MAX8925_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9030 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_PCF50633 is not set
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_TWL4030 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_MAX8998 is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_POWER_AVS is not set
# CONFIG_HWMON is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_LM3533 is not set
CONFIG_TPS6105X=y
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS6586X is not set
CONFIG_TWL4030_CORE=y
CONFIG_TWL4030_MADC=y
# CONFIG_MFD_TWL4030_AUDIO is not set
# CONFIG_TWL6030_PWM is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_PMIC_DA903X=y
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
# CONFIG_PCF50633_GPIO is not set
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=y
CONFIG_MFD_CS5535=y
CONFIG_LPC_SCH=y
# CONFIG_LPC_ICH is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_TPS65090=y
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_PALMAS is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_AD5398=y
# CONFIG_REGULATOR_DA903X is not set
# CONFIG_REGULATOR_ISL6271A is not set
# CONFIG_REGULATOR_88PM8607 is not set
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8925 is not set
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8998=y
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_LP3972 is not set
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_RC5T583=y
# CONFIG_REGULATOR_AB3100 is not set
# CONFIG_REGULATOR_TPS6105X is not set
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_TPS65090 is not set
# CONFIG_REGULATOR_TWL4030 is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
CONFIG_STUB_POULSBO=y
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
# CONFIG_FB_WMT_GE_ROPS is not set
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
CONFIG_FB_RIVA=y
# CONFIG_FB_RIVA_I2C is not set
# CONFIG_FB_RIVA_DEBUG is not set
# CONFIG_FB_RIVA_BACKLIGHT is not set
CONFIG_FB_LE80578=y
# CONFIG_FB_CARILLO_RANCH is not set
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
CONFIG_FB_MATROX_MYSTIQUE=y
# CONFIG_FB_MATROX_G is not set
CONFIG_FB_MATROX_I2C=y
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
# CONFIG_FB_RADEON_BACKLIGHT is not set
CONFIG_FB_RADEON_DEBUG=y
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=y
CONFIG_FB_S3_DDC=y
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
CONFIG_FB_3DFX=y
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=y
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
CONFIG_FB_CARMINE=y
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
CONFIG_EXYNOS_VIDEO=y
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
# CONFIG_LOGO_LINUX_CLUT224 is not set
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
# CONFIG_SND is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set
# CONFIG_USB_CHIPIDEA is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# USB Physical Layer drivers
#
# CONFIG_USB_ISP1301 is not set
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
# CONFIG_USB_R8A66597 is not set
# CONFIG_USB_MV_UDC is not set
CONFIG_USB_M66592=y
# CONFIG_USB_AMD5536UDC is not set
# CONFIG_USB_NET2272 is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
CONFIG_USB_GADGET_DUALSPEED=y
# CONFIG_USB_ZERO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_FILE_STORAGE is not set
# CONFIG_USB_MASS_STORAGE is not set
CONFIG_USB_GADGET_TARGET=y
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
# CONFIG_TWL6030_USB is not set
CONFIG_NOP_USB_XCEIV=y
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
CONFIG_SDIO_UART=y
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_WBSD=y
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_MM_EDAC is not set
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
CONFIG_INTEL_IOATDMA=y
# CONFIG_TIMB_DMA is not set
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DCA=y
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set

#
# Virtio drivers
#
# CONFIG_VIRTIO_BALLOON is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
CONFIG_ECHO=y
CONFIG_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
# CONFIG_PANEL_CHANGE_MESSAGE is not set
CONFIG_RTS_PSTOR=y
CONFIG_RTS_PSTOR_DEBUG=y
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#
CONFIG_IIO_SW_RING=y

#
# Accelerometers
#

#
# Analog to digital converters
#
CONFIG_AD7291=y
# CONFIG_AD799X is not set
# CONFIG_ADT7410 is not set
CONFIG_MAX1363=y
CONFIG_MAX1363_RING_BUFFER=y

#
# Analog digital bi-direction converters
#

#
# Capacitance to digital converters
#
CONFIG_AD7150=y
CONFIG_AD7152=y
CONFIG_AD7746=y

#
# Direct Digital Synthesis
#

#
# Digital gyroscope sensors
#

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set

#
# Inertial measurement units
#

#
# Light sensors
#
# CONFIG_SENSORS_ISL29018 is not set
CONFIG_SENSORS_ISL29028=y
CONFIG_SENSORS_TSL2563=y
CONFIG_TSL2583=y
CONFIG_TSL2x7x=y

#
# Magnetometer sensors
#
CONFIG_SENSORS_HMC5843=y

#
# Active energy metering IC
#
CONFIG_ADE7854=y
# CONFIG_ADE7854_I2C is not set

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
CONFIG_IIO_SYSFS_TRIGGER=y
CONFIG_IIO_SIMPLE_DUMMY=y
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
CONFIG_ZRAM=y
CONFIG_ZRAM_DEBUG=y
CONFIG_ZCACHE=y
CONFIG_ZSMALLOC=y
# CONFIG_FB_SM7XX is not set
CONFIG_CRYSTALHD=y
CONFIG_FB_XGI=y
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_PHONE is not set
# CONFIG_USB_G_CCG is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_WIMAX_GDM72XX is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_AMILO_RFKILL is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set
# CONFIG_INTEL_IOMMU is not set

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
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
# CONFIG_IIO_KFIFO_BUF is not set
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Analog to digital converters
#

#
# Amplifiers
#

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
# CONFIG_VCNL4000 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
# CONFIG_AD5380 is not set
# CONFIG_MCP4725 is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
CONFIG_OCFS2_FS=y
# CONFIG_OCFS2_FS_O2CB is not set
CONFIG_OCFS2_FS_STATS=y
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
CONFIG_FSCACHE_DEBUG=y
CONFIG_FSCACHE_OBJECT_LIST=y
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
# CONFIG_PROC_VMCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
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
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_SPARSE_RCU_POINTER is not set
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
# CONFIG_FRAME_POINTER is not set
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_LKDTM=y
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
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
# CONFIG_FUNCTION_GRAPH_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
# CONFIG_STACK_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_DYNAMIC_FTRACE is not set
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_EVENT_TRACE_TEST_SYSCALLS=y
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_DYNAMIC_DEBUG=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
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
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
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
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_ZLIB_INFLATE=y
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
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
CONFIG_DDR=y

--Kj7319i9nmIyA2yE--
