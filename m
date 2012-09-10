Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab2IJA5F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 20:57:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:29005 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923Ab2IJA5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 20:57:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,396,1344236400"; 
   d="scan'208";a="220052890"
Date: Mon, 10 Sep 2012 08:56:29 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [signal] divide error
Message-ID: <20120910005629.GB27826@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="E39vaYmALEf/7YXx"
Content-Disposition: inline
In-Reply-To: <20120910004753.GB27699@localhost>
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E39vaYmALEf/7YXx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

FYI, yet another dmesg, hope it helps debugging :)

x86_64-randconfig-s284      b______b___b_BBBBBB

--
12:	  f411932  
13:	B c2865bb  2012-09-10 kvm-waimea   [    2.295689] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC 
14:	B 549bf9c  2012-09-10 kvm-inn      [    2.779554] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC 
15:	B 4e382ff  2012-09-10 kvm-inn      [    2.751103] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC 
16:	B 23ddf94  2012-09-10 kvm-stoakley [    3.470572] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC 
17:	B f117e2a  2012-09-10 kvm-inn      [    4.024677] divide error: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC [update_sd_lb_stats find_busiest_group load_balance lock_acquire idle_balance __schedule schedule worker_thread rescuer_thread kthread retint_restore_args __init_kthread_worker gs_change]
18:	B a392720  2012-09-10 kvm-fat      [    2.739769] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC 
18:	B a392720  2012-09-10 kvm-inn      [    3.974984] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC 
18:	B a392720  2012-09-10 kvm-stoakley [    3.471390] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC 

[    4.022721] bus: 'serio': really_probe: probing driver atkbd with device serio1
[    4.023973] atkbd: probe of serio1 rejects match -19
[    4.024677] divide error: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    4.025627] Modules linked in:
[    4.026041] CPU 0 
[    4.026282] Pid: 21, comm: kworker/0:1 Not tainted 3.6.0-rc3-00186-gf117e2a #47 Bochs Bochs
[    4.026414] RIP: 0010:[<ffffffff810536e7>]  [<ffffffff810536e7>] update_sd_lb_stats+0x2a8/0x484
[    4.026414] RSP: 0018:ffff8800001dfac0  EFLAGS: 00010046
[    4.026414] RAX: 0000000000100000 RBX: ffff8800001dfcb0 RCX: 0000000000000000
[    4.026414] RDX: 0000000000000000 RSI: 00000000000000ff RDI: 0000000000000000
[    4.026414] RBP: ffff8800001dfb90 R08: ffff8800000812b8 R09: 0000000000000013
[    4.026414] R10: ffffffff813be9d0 R11: ffff88000ddd3240 R12: 0000000000000000
[    4.026414] R13: 0000000000000008 R14: ffff8800001dfba0 R15: ffff8800000812a0
[    4.026414] FS:  0000000000000000(0000) GS:ffff88000dc00000(0000) knlGS:0000000000000000
[    4.026414] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    4.026414] CR2: 0000000000000000 CR3: 00000000013a5000 CR4: 00000000000006b0
[    4.026414] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    4.026414] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    4.026414] Process kworker/0:1 (pid: 21, threadinfo ffff8800001de000, task ffff880000172000)
[    4.026414] Stack:
[    4.026414]  00000000001d3240 ffff8800000812b8 ffff8800001dfd4c 00000000001d3240
[    4.026414]  0000000000000001 0000000000000001 0000000000000000 0000000000000400
[    4.026414]  0000000000000001 0000000000000400 00000000ffffffff ffff8800001dfb20
[    4.026414] Call Trace:
[    4.026414]  [<ffffffff810538ef>] find_busiest_group+0x2c/0x1db
[    4.026414]  [<ffffffff81053b69>] load_balance+0xcb/0x5c5
[    4.026414]  [<ffffffff81061a2d>] ? lock_acquire+0xa6/0xb1
[    4.026414]  [<ffffffff81054273>] idle_balance+0x9c/0x111
[    4.026414]  [<ffffffff81239918>] __schedule+0x241/0x4bd
[    4.026414]  [<ffffffff81239c9e>] schedule+0x60/0x62
[    4.026414]  [<ffffffff810429ae>] worker_thread+0x21a/0x24b
[    4.026414]  [<ffffffff81042794>] ? rescuer_thread+0x17d/0x17d
[    4.026414]  [<ffffffff8104600f>] kthread+0x73/0x7b
[    4.026414]  [<ffffffff8123ce44>] kernel_thread_helper+0x4/0x10
[    4.026414]  [<ffffffff8123b3f4>] ? retint_restore_args+0x13/0x13
[    4.026414]  [<ffffffff81045f9c>] ? __init_kthread_worker+0x55/0x55
[    4.026414]  [<ffffffff8123ce40>] ? gs_change+0x13/0x13
[    4.026414] Code: 47 10 48 8b 15 3b b9 3a 00 48 3b 50 10 78 0b 8b 73 14 48 8b 3b e8 f8 fb ff ff 49 8b 57 10 48 8b 45 98 8b 4a 04 48 c1 e0 0a 31 d2 <48> f7 f1 48 8b 4d a0 48 89 45 90 31 c0 48 85 c9 74 09 48 8b 45 
[    4.026414] RIP  [<ffffffff810536e7>] update_sd_lb_stats+0x2a8/0x484
[    4.026414]  RSP <ffff8800001dfac0>

Thanks,
Fengguang

--E39vaYmALEf/7YXx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-inn-19896-2012-09-10-08-47-33-3.6.0-rc3-00186-gf117e2a-47"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 3.6.0-rc3-00186-gf117e2a (kbuild@snb) (gcc ver=
sion 4.7.1 (Debian 4.7.1-6) ) #47 SMP PREEMPT Mon Sep 10 08:45:25 CST 2012
[    0.000000] Command line: trinity=3D2m hung_task_panic=3D1 rcutree.rcu_c=
pu_stall_timeout=3D100 branch=3Dsignal/experimental-kernel_thread log_buf_l=
en=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_printk sysrq=
_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,115200 conso=
le=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3Dvmlinuz-2012-09-10-08-45=
-48-signal:experimental-kernel_thread:a392720-f117e2a-x86_64-randconfig-s28=
4-1-inn BOOT_IMAGE=3Dkernel-tests/kernels/x86_64-randconfig-s284/f117e2a/vm=
linuz-3.6.0-rc3-00186-gf117e2a
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
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x0e8540=
00-0x0e8d5fff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128176(97%)
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
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:15d3181, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00010000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000]   DMA32 zone: 1024 pages used for memmap
[    0.000000]   DMA32 zone: 6 pages reserved
[    0.000000]   DMA32 zone: 64379 pages, LIFO batch:15
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
[    0.000000] PERCPU: Embedded 475 pages/cpu @ffff88000dc00000 s1916544 r8=
192 d20864 u2097152
[    0.000000] pcpu-alloc: s1916544 r8192 d20864 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:ddd3181, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr dc0e980
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64379
[    0.000000] Kernel command line: trinity=3D2m hung_task_panic=3D1 rcutre=
e.rcu_cpu_stall_timeout=3D100 branch=3Dsignal/experimental-kernel_thread lo=
g_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_print=
k sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,11520=
0 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3Dvmlinuz-2012-09-1=
0-08-45-48-signal:experimental-kernel_thread:a392720-f117e2a-x86_64-randcon=
fig-s284-1-inn BOOT_IMAGE=3Dkernel-tests/kernels/x86_64-randconfig-s284/f11=
7e2a/vmlinuz-3.6.0-rc3-00186-gf117e2a
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Memory: 203908k/262136k available (2293k kernel code, 500k a=
bsent, 57728k reserved, 1798k data, 2264k init)
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D2, Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
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
[    0.000000] ODEBUG: 6 of 6 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.536 MHz processor
[    0.010000] Calibrating delay loop (skipped) preset value.. 5387.07 Bogo=
MIPS (lpj=3D26935360)
[    0.010000] pid_max: default: 32768 minimum: 301
[    0.010000] Mount-cache hash table entries: 256
[    0.010000] Initializing cgroup subsys debug
[    0.010000] Initializing cgroup subsys freezer
[    0.010000] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.010000] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.010000] tlb_flushall_shift is 0x6
[    0.010600] ACPI: Core revision 20120711
[    0.014646] Getting VERSION: 50014
[    0.015273] Getting VERSION: 50014
[    0.015837] Getting ID: 0
[    0.016284] Getting ID: ff000000
[    0.016826] Getting LVT0: 8700
[    0.017345] Getting LVT1: 8400
[    0.017930] enabled ExtINT on CPU#0
[    0.019755] ENABLING IO-APIC IRQs
[    0.020013] init IO_APIC IRQs
[    0.020512]  apic 2 pin 0 not connected
[    0.021168] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.022479] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.023793] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.025134] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.026440] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.027756] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.029064] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.030030] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.031326] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.032619] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.033945] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.035277] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.036591] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.037912] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.040033] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.041353]  apic 2 pin 16 not connected
[    0.041987]  apic 2 pin 17 not connected
[    0.042625]  apic 2 pin 18 not connected
[    0.043262]  apic 2 pin 19 not connected
[    0.043906]  apic 2 pin 20 not connected
[    0.044543]  apic 2 pin 21 not connected
[    0.045190]  apic 2 pin 22 not connected
[    0.045823]  apic 2 pin 23 not connected
[    0.046648] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.048132] smpboot: CPU0: Intel Common KVM processor stepping 01
[    0.049725] Using local APIC timer interrupts.
[    0.049725] calibrating APIC timer ...
[    0.060000] ... lapic delta =3D 6249943
[    0.060000] ... PM-Timer delta =3D 357950
[    0.060000] ... PM-Timer result ok
[    0.060000] ..... delta 6249943
[    0.060000] ..... mult: 268433007
[    0.060000] ..... calibration result: 9999908
[    0.060000] ..... CPU clock speed is 2693.4599 MHz.
[    0.060000] ..... host bus clock speed is 999.9908 MHz.
[    0.060000] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.120038] SMP alternatives: lockdep: fixing up alternatives
[    0.121521] smpboot: Booting Node   0, Processors  #1 OK
[    0.010000] kvm-clock: cpu 1, msr 0:dfd3181, secondary cpu clock
[    0.010000] masked ExtINT on CPU#1
[    0.161897] Brought up 2 CPUs
[    0.162422] ----------------
[    0.162884] | NMI testsuite:
[    0.170005] --------------------
[    0.170531]   remote IPI:[    0.165288] KVM setup async PF for cpu 1
[    0.165945] kvm-stealtime: cpu 1, msr de0e980
  ok  |
[    0.200266]    local IPI:  ok  |
[    0.260041] --------------------
[    0.260600] Good, all   2 testcases passed! |
[    0.261300] ---------------------------------
[    0.262000] smpboot: Total of 2 processors activated (10774.14 BogoMIPS)
[    0.272192] device: 'platform': device_add
[    0.272912] PM: Adding info for No Bus:platform
[    0.273739] bus: 'platform': registered
[    0.274427] bus: 'cpu': registered
[    0.275018] device: 'cpu': device_add
[    0.275675] PM: Adding info for No Bus:cpu
[    0.276640] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.277789] device class 'regulator': registering
[    0.278802] Registering platform device 'reg-dummy'. Parent at platform
[    0.279917] device: 'reg-dummy': device_add
[    0.280025] bus: 'platform': add device reg-dummy
[    0.280881] PM: Adding info for platform:reg-dummy
[    0.281748] bus: 'platform': add driver reg-dummy
[    0.282563] bus: 'platform': driver_probe_device: matched device reg-dum=
my with driver reg-dummy
[    0.284031] bus: 'platform': really_probe: probing driver reg-dummy with=
 device reg-dummy
[    0.285486] device: 'regulator.0': device_add
[    0.286339] PM: Adding info for No Bus:regulator.0
[    0.287216] dummy:=20
[    0.287647] driver: 'reg-dummy': driver_bound: bound to device 'reg-dumm=
y'
[    0.288769] bus: 'platform': really_probe: bound device reg-dummy to dri=
ver reg-dummy
[    0.290307] NET: Registered protocol family 16
[    0.291136] device class 'bdi': registering
[    0.291902] device class 'pci_bus': registering
[    0.292701] bus: 'pci': registered
[    0.293223] device class 'tty': registering
[    0.296112] ACPI: bus type pci registered
[    0.296781] device class 'dmi': registering
[    0.297469] device: 'id': device_add
[    0.298113] PM: Adding info for No Bus:id
[    0.298841] PCI: Using configuration type 1 for base access
[    0.300090] device: 'cpu0': device_add
[    0.300714] bus: 'cpu': add device cpu0
[    0.301358] PM: Adding info for cpu:cpu0
[    0.302054] device: 'cpu1': device_add
[    0.302685] bus: 'cpu': add device cpu1
[    0.303339] PM: Adding info for cpu:cpu1
[    0.304809] device: 'default': device_add
[    0.305484] PM: Adding info for No Bus:default
[    0.310233] bio: create slab <bio-0> at 0
[    0.310997] device class 'block': registering
[    0.312066] ACPI: Added _OSI(Module Device)
[    0.320009] ACPI: Added _OSI(Processor Device)
[    0.320600] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.321233] ACPI: Added _OSI(Processor Aggregator Device)
[    0.325701] ACPI: EC: Look up EC in DSDT
[    0.333887] ACPI: Interpreter enabled
[    0.334497] ACPI: (supports S0 S3 S5)
[    0.335225] ACPI: Using IOAPIC for interrupt routing
[    0.336054] bus: 'acpi': registered
[    0.336618] bus: 'acpi': add driver power
[    0.337353] device: 'LNXSYSTM:00': device_add
[    0.338083] bus: 'acpi': add device LNXSYSTM:00
[    0.338815] PM: Adding info for acpi:LNXSYSTM:00
[    0.339798] device: 'device:00': device_add
[    0.340016] bus: 'acpi': add device device:00
[    0.340822] PM: Adding info for acpi:device:00
[    0.341674] device: 'PNP0A03:00': device_add
[    0.342364] bus: 'acpi': add device PNP0A03:00
[    0.343145] PM: Adding info for acpi:PNP0A03:00
[    0.345284] device: 'device:01': device_add
[    0.345923] bus: 'acpi': add device device:01
[    0.346605] PM: Adding info for acpi:device:01
[    0.347404] device: 'device:02': device_add
[    0.348049] bus: 'acpi': add device device:02
[    0.348719] PM: Adding info for acpi:device:02
[    0.350070] device: 'PNP0B00:00': device_add
[    0.350738] bus: 'acpi': add device PNP0B00:00
[    0.351427] PM: Adding info for acpi:PNP0B00:00
[    0.352292] device: 'PNP0303:00': device_add
[    0.352939] bus: 'acpi': add device PNP0303:00
[    0.353666] PM: Adding info for acpi:PNP0303:00
[    0.354514] device: 'PNP0F13:00': device_add
[    0.355193] bus: 'acpi': add device PNP0F13:00
[    0.355872] PM: Adding info for acpi:PNP0F13:00
[    0.356714] device: 'PNP0700:00': device_add
[    0.357453] bus: 'acpi': add device PNP0700:00
[    0.358235] PM: Adding info for acpi:PNP0700:00
[    0.359337] device: 'PNP0400:00': device_add
[    0.360024] bus: 'acpi': add device PNP0400:00
[    0.360712] PM: Adding info for acpi:PNP0400:00
[    0.361666] device: 'PNP0501:00': device_add
[    0.362344] bus: 'acpi': add device PNP0501:00
[    0.363080] PM: Adding info for acpi:PNP0501:00
[    0.364090] device: 'device:03': device_add
[    0.364737] bus: 'acpi': add device device:03
[    0.365410] PM: Adding info for acpi:device:03
[    0.366241] device: 'device:04': device_add
[    0.366895] bus: 'acpi': add device device:04
[    0.367627] PM: Adding info for acpi:device:04
[    0.368504] device: 'device:05': device_add
[    0.369213] bus: 'acpi': add device device:05
[    0.369865] PM: Adding info for acpi:device:05
[    0.370143] device: 'device:06': device_add
[    0.370798] bus: 'acpi': add device device:06
[    0.371463] PM: Adding info for acpi:device:06
[    0.372274] device: 'device:07': device_add
[    0.373048] bus: 'acpi': add device device:07
[    0.373838] PM: Adding info for acpi:device:07
[    0.374763] device: 'device:08': device_add
[    0.375418] bus: 'acpi': add device device:08
[    0.376092] PM: Adding info for acpi:device:08
[    0.376886] device: 'device:09': device_add
[    0.377541] bus: 'acpi': add device device:09
[    0.378216] PM: Adding info for acpi:device:09
[    0.379035] device: 'device:0a': device_add
[    0.380018] bus: 'acpi': add device device:0a
[    0.380697] PM: Adding info for acpi:device:0a
[    0.381599] device: 'device:0b': device_add
[    0.382355] bus: 'acpi': add device device:0b
[    0.383213] PM: Adding info for acpi:device:0b
[    0.384039] device: 'device:0c': device_add
[    0.384699] bus: 'acpi': add device device:0c
[    0.385381] PM: Adding info for acpi:device:0c
[    0.386213] device: 'device:0d': device_add
[    0.386904] bus: 'acpi': add device device:0d
[    0.387587] PM: Adding info for acpi:device:0d
[    0.388514] device: 'device:0e': device_add
[    0.389280] bus: 'acpi': add device device:0e
[    0.390028] PM: Adding info for acpi:device:0e
[    0.390884] device: 'device:0f': device_add
[    0.391597] bus: 'acpi': add device device:0f
[    0.392290] PM: Adding info for acpi:device:0f
[    0.393120] device: 'device:10': device_add
[    0.393770] bus: 'acpi': add device device:10
[    0.394500] PM: Adding info for acpi:device:10
[    0.395415] device: 'device:11': device_add
[    0.396187] bus: 'acpi': add device device:11
[    0.396894] PM: Adding info for acpi:device:11
[    0.397730] device: 'device:12': device_add
[    0.398389] bus: 'acpi': add device device:12
[    0.399055] PM: Adding info for acpi:device:12
[    0.400142] device: 'device:13': device_add
[    0.400788] bus: 'acpi': add device device:13
[    0.401562] PM: Adding info for acpi:device:13
[    0.402475] device: 'device:14': device_add
[    0.403278] bus: 'acpi': add device device:14
[    0.403984] PM: Adding info for acpi:device:14
[    0.404801] device: 'device:15': device_add
[    0.405466] bus: 'acpi': add device device:15
[    0.406149] PM: Adding info for acpi:device:15
[    0.406978] device: 'device:16': device_add
[    0.407636] bus: 'acpi': add device device:16
[    0.408338] PM: Adding info for acpi:device:16
[    0.409155] device: 'device:17': device_add
[    0.410022] bus: 'acpi': add device device:17
[    0.410783] PM: Adding info for acpi:device:17
[    0.411725] device: 'device:18': device_add
[    0.412388] bus: 'acpi': add device device:18
[    0.413108] PM: Adding info for acpi:device:18
[    0.414040] device: 'device:19': device_add
[    0.414748] bus: 'acpi': add device device:19
[    0.415443] PM: Adding info for acpi:device:19
[    0.416262] device: 'device:1a': device_add
[    0.416907] bus: 'acpi': add device device:1a
[    0.417586] PM: Adding info for acpi:device:1a
[    0.418502] device: 'device:1b': device_add
[    0.419255] bus: 'acpi': add device device:1b
[    0.420018] PM: Adding info for acpi:device:1b
[    0.420849] device: 'device:1c': device_add
[    0.421545] bus: 'acpi': add device device:1c
[    0.422257] PM: Adding info for acpi:device:1c
[    0.423162] device: 'device:1d': device_add
[    0.423817] bus: 'acpi': add device device:1d
[    0.424490] PM: Adding info for acpi:device:1d
[    0.425331] device: 'device:1e': device_add
[    0.426070] bus: 'acpi': add device device:1e
[    0.426843] PM: Adding info for acpi:device:1e
[    0.427775] device: 'device:1f': device_add
[    0.428440] bus: 'acpi': add device device:1f
[    0.429032] PM: Adding info for acpi:device:1f
[    0.429695] device: 'device:20': device_add
[    0.430013] bus: 'acpi': add device device:20
[    0.430597] PM: Adding info for acpi:device:20
[    0.431402] device: 'device:21': device_add
[    0.432056] bus: 'acpi': add device device:21
[    0.432746] PM: Adding info for acpi:device:21
[    0.433592] device: 'device:22': device_add
[    0.434284] bus: 'acpi': add device device:22
[    0.435052] PM: Adding info for acpi:device:22
[    0.436227] device: 'PNP0103:00': device_add
[    0.436957] bus: 'acpi': add device PNP0103:00
[    0.437642] PM: Adding info for acpi:PNP0103:00
[    0.438666] device: 'PNP0C0F:00': device_add
[    0.439341] bus: 'acpi': add device PNP0C0F:00
[    0.440019] PM: Adding info for acpi:PNP0C0F:00
[    0.441010] device: 'PNP0C0F:01': device_add
[    0.441766] bus: 'acpi': add device PNP0C0F:01
[    0.442560] PM: Adding info for acpi:PNP0C0F:01
[    0.443614] device: 'PNP0C0F:02': device_add
[    0.444271] bus: 'acpi': add device PNP0C0F:02
[    0.444991] PM: Adding info for acpi:PNP0C0F:02
[    0.446000] device: 'PNP0C0F:03': device_add
[    0.446708] bus: 'acpi': add device PNP0C0F:03
[    0.447394] PM: Adding info for acpi:PNP0C0F:03
[    0.448436] device: 'PNP0C0F:04': device_add
[    0.449208] bus: 'acpi': add device PNP0C0F:04
[    0.450019] PM: Adding info for acpi:PNP0C0F:04
[    0.450878] device: 'LNXCPU:00': device_add
[    0.451532] bus: 'acpi': add device LNXCPU:00
[    0.452216] PM: Adding info for acpi:LNXCPU:00
[    0.453102] device: 'LNXCPU:01': device_add
[    0.453811] bus: 'acpi': add device LNXCPU:01
[    0.454549] PM: Adding info for acpi:LNXCPU:01
[    0.455467] device: 'device:23': device_add
[    0.456236] bus: 'acpi': add device device:23
[    0.456949] PM: Adding info for acpi:device:23
[    0.457635] device: 'LNXPWRBN:00': device_add
[    0.458193] bus: 'acpi': add device LNXPWRBN:00
[    0.458762] PM: Adding info for acpi:LNXPWRBN:00
[    0.459606] bus: 'acpi': add driver ec
[    0.460090] PCI: Ignoring host bridge windows from ACPI; if necessary, u=
se "pci=3Duse_crs" and report a bug
[    0.461480] bus: 'acpi': add driver pci_root
[    0.462238] bus: 'acpi': driver_probe_device: matched device PNP0A03:00 =
with driver pci_root
[    0.463725] bus: 'acpi': really_probe: probing driver pci_root with devi=
ce PNP0A03:00
[    0.465006] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.465995] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] =
(ignored)
[    0.467146] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] =
(ignored)
[    0.468263] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x00=
0bffff] (ignored)
[    0.469492] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfe=
bfffff] (ignored)
[    0.470009] PCI: root bus 00: using default resources
[    0.470770] device: 'pci0000:00': device_add
[    0.471464] PM: Adding info for No Bus:pci0000:00
[    0.472233] device: '0000:00': device_add
[    0.472917] PM: Adding info for No Bus:0000:00
[    0.473664] PCI host bridge to bus 0000:00
[    0.474321] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under dom=
ain [bus 00-ff]
[    0.475455] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.476130] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.476880] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffff=
fff]
[    0.477815] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.480199] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.481526] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.484244] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    0.486066] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.487367] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.488485] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.489825] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.491834] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.494429] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    0.501187] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.502894] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.504363] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.506006] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.510872] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.512442] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.513939] pci 0000:00:04.0: reg 10: [io  0xc040-0xc07f]
[    0.515699] pci 0000:00:04.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
[    0.521712] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.523266] pci 0000:00:05.0: reg 10: [io  0xc080-0xc0bf]
[    0.524968] pci 0000:00:05.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[    0.530934] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.532369] pci 0000:00:06.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.534072] pci 0000:00:06.0: reg 14: [mem 0xfebf3000-0xfebf3fff]
[    0.540355] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.541806] pci 0000:00:07.0: reg 10: [io  0xc100-0xc13f]
[    0.543581] pci 0000:00:07.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    0.549500] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.550528] pci 0000:00:08.0: reg 10: [io  0xc140-0xc17f]
[    0.552193] pci 0000:00:08.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    0.558191] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.560061] pci 0000:00:09.0: reg 10: [io  0xc180-0xc1bf]
[    0.561698] pci 0000:00:09.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    0.567381] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.568437] pci 0000:00:0a.0: reg 10: [mem 0xfebf7000-0xfebf700f]
[    0.572513] pci_bus 0000:00: on NUMA node 0
[    0.573096] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.575298]  pci0000:00: ACPI _OSC support notification failed, disablin=
g PCIe ASPM
[    0.576431]  pci0000:00: Unable to request _OSC control (_OSC support ma=
sk: 0x08)
[    0.577572] device: '0000:00:00.0': device_add
[    0.579803] bus: 'pci': add device 0000:00:00.0
[    0.580091] PM: Adding info for pci:0000:00:00.0
[    0.580931] device: '0000:00:01.0': device_add
[    0.582967] bus: 'pci': add device 0000:00:01.0
[    0.583578] PM: Adding info for pci:0000:00:01.0
[    0.584151] device: '0000:00:01.1': device_add
[    0.585887] bus: 'pci': add device 0000:00:01.1
[    0.586492] PM: Adding info for pci:0000:00:01.1
[    0.587068] device: '0000:00:01.3': device_add
[    0.589064] bus: 'pci': add device 0000:00:01.3
[    0.590066] PM: Adding info for pci:0000:00:01.3
[    0.590787] device: '0000:00:02.0': device_add
[    0.592867] bus: 'pci': add device 0000:00:02.0
[    0.593709] PM: Adding info for pci:0000:00:02.0
[    0.594500] device: '0000:00:03.0': device_add
[    0.596877] bus: 'pci': add device 0000:00:03.0
[    0.597506] PM: Adding info for pci:0000:00:03.0
[    0.598092] device: '0000:00:04.0': device_add
[    0.600240] bus: 'pci': add device 0000:00:04.0
[    0.600847] PM: Adding info for pci:0000:00:04.0
[    0.601430] device: '0000:00:05.0': device_add
[    0.606942] bus: 'pci': add device 0000:00:05.0
[    0.607645] PM: Adding info for pci:0000:00:05.0
[    0.608335] device: '0000:00:06.0': device_add
[    0.610166] bus: 'pci': add device 0000:00:06.0
[    0.610778] PM: Adding info for pci:0000:00:06.0
[    0.611367] device: '0000:00:07.0': device_add
[    0.613126] bus: 'pci': add device 0000:00:07.0
[    0.618477] PM: Adding info for pci:0000:00:07.0
[    0.619209] device: '0000:00:08.0': device_add
[    0.621285] bus: 'pci': add device 0000:00:08.0
[    0.622042] PM: Adding info for pci:0000:00:08.0
[    0.622775] device: '0000:00:09.0': device_add
[    0.624885] bus: 'pci': add device 0000:00:09.0
[    0.625714] PM: Adding info for pci:0000:00:09.0
[    0.626433] device: '0000:00:0a.0': device_add
[    0.628507] bus: 'pci': add device 0000:00:0a.0
[    0.629274] PM: Adding info for pci:0000:00:0a.0
[    0.630044] driver: 'PNP0A03:00': driver_bound: bound to device 'pci_roo=
t'
[    0.631107] bus: 'acpi': really_probe: bound device PNP0A03:00 to driver=
 pci_root
[    0.632369] bus: 'acpi': add driver pci_link
[    0.632962] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 =
with driver pci_link
[    0.638651] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:00
[    0.639769] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.640296] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_lin=
k'
[    0.641137] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver=
 pci_link
[    0.642041] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 =
with driver pci_link
[    0.643704] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:01
[    0.648255] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.649104] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_lin=
k'
[    0.650009] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver=
 pci_link
[    0.650979] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 =
with driver pci_link
[    0.652241] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:02
[    0.658308] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.659415] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_lin=
k'
[    0.660011] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver=
 pci_link
[    0.661224] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 =
with driver pci_link
[    0.662566] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:03
[    0.670143] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.671256] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_lin=
k'
[    0.680011] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver=
 pci_link
[    0.681270] bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 =
with driver pci_link
[    0.682620] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:04
[    0.690132] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.691158] driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_lin=
k'
[    0.692270] bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver=
 pci_link
[    0.700093] bus: 'pnp': registered
[    0.700698] bus: 'xen': registered
[    0.703460] device class 'misc': registering
[    0.704263] device: 'vga_arbiter': device_add
[    0.705062] PM: Adding info for No Bus:vga_arbiter
[    0.710134] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.720036] vgaarb: loaded
[    0.720487] vgaarb: bridge control possible 0000:00:02.0
[    0.721384] bus: 'serio': registered
[    0.721978] device class 'input': registering
[    0.730036] device class 'rtc': registering
[    0.730769] device class 'power_supply': registering
[    0.731592] device class 'watchdog': registering
[    0.732372] PCI: Using ACPI for IRQ routing
[    0.733056] PCI: pci_cache_line_size set to 64 bytes
[    0.740539] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    0.741523] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.742838] device class 'net': registering
[    0.746802] device: 'lo': device_add
[    0.747657] PM: Adding info for No Bus:lo
[    0.770348] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.771519] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.772421] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.813372] Switching to clocksource kvm-clock
[    0.814679] bus: 'pnp': add driver system
[    0.815384] pnp: PnP ACPI init
[    0.815918] device: 'pnp0': device_add
[    0.816538] PM: Adding info for No Bus:pnp0
[    0.817237] ACPI: bus type pnp registered
[    0.817944] pnp 00:00: [bus 00-ff]
[    0.818505] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.820000] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.820000] pnp 00:00: [io  0x0d00-0xffff window]
[    0.820000] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.820375] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    0.821261] device: '00:00': device_add
[    0.822032] bus: 'pnp': add device 00:00
[    0.822692] PM: Adding info for pnp:00:00
[    0.833492] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.834604] pnp 00:01: [io  0x0070-0x0071]
[    0.835314] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.839371] pnp 00:01: [irq 8]
[    0.839927] pnp 00:01: [io  0x0072-0x0077]
[    0.840604] device: '00:01': device_add
[    0.841275] bus: 'pnp': add device 00:01
[    0.841944] PM: Adding info for pnp:00:01
[    0.842643] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.846555] pnp 00:02: [io  0x0060]
[    0.847133] pnp 00:02: [io  0x0064]
[    0.847723] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.849043] pnp 00:02: [irq 1]
[    0.849554] device: '00:02': device_add
[    0.853102] bus: 'pnp': add device 00:02
[    0.853781] PM: Adding info for pnp:00:02
[    0.854441] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.855578] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.859770] pnp 00:03: [irq 12]
[    0.860296] device: '00:03': device_add
[    0.860977] bus: 'pnp': add device 00:03
[    0.861625] PM: Adding info for pnp:00:03
[    0.862302] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.866051] pnp 00:04: [io  0x03f2-0x03f5]
[    0.866759] pnp 00:04: [io  0x03f7]
[    0.867342] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.868627] pnp 00:04: [irq 6]
[    0.869168] pnp 00:04: [dma 2]
[    0.869681] device: '00:04': device_add
[    0.872967] bus: 'pnp': add device 00:04
[    0.873693] PM: Adding info for pnp:00:04
[    0.874349] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.875514] pnp 00:05: [io  0x0378-0x037f]
[    0.876224] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.880182] pnp 00:05: [irq 7]
[    0.880688] device: '00:05': device_add
[    0.881365] bus: 'pnp': add device 00:05
[    0.882026] PM: Adding info for pnp:00:05
[    0.882699] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.900034] pnp 00:06: [io  0x03f8-0x03ff]
[    0.900742] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.902042] pnp 00:06: [irq 4]
[    0.902547] device: '00:06': device_add
[    0.914021] bus: 'pnp': add device 00:06
[    0.914685] PM: Adding info for pnp:00:06
[    0.915361] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.916945] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    0.917732] device: '00:07': device_add
[    0.918505] bus: 'pnp': add device 00:07
[    0.919208] PM: Adding info for pnp:00:07
[    0.919879] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.921255] pnp: PnP ACPI: found 8 devices
[    0.921937] ACPI: ACPI bus type pnp unregistered
[    0.929813] device class 'mem': registering
[    0.930513] device: 'mem': device_add
[    0.931155] PM: Adding info for No Bus:mem
[    0.931888] device: 'null': device_add
[    0.932533] PM: Adding info for No Bus:null
[    0.933228] device: 'port': device_add
[    0.933884] PM: Adding info for No Bus:port
[    0.934571] device: 'zero': device_add
[    0.946194] PM: Adding info for No Bus:zero
[    0.946891] device: 'full': device_add
[    0.947790] PM: Adding info for No Bus:full
[    0.948811] device: 'random': device_add
[    0.949512] PM: Adding info for No Bus:random
[    0.950277] device: 'urandom': device_add
[    0.950956] PM: Adding info for No Bus:urandom
[    0.951696] device: 'kmsg': device_add
[    0.952335] PM: Adding info for No Bus:kmsg
[    0.955866] device: 'tty': device_add
[    0.957555] PM: Adding info for No Bus:tty
[    0.958290] device: 'console': device_add
[    0.960076] PM: Adding info for No Bus:console
[    0.973595] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.975290] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[    0.979865] NET: Registered protocol family 2
[    0.980999] TCP established hash table entries: 8192 (order: 5, 131072 b=
ytes)
[    0.982523] TCP bind hash table entries: 8192 (order: 7, 655360 bytes)
[    0.985101] TCP: Hash tables configured (established 8192 bind 8192)
[    0.986242] TCP: reno registered
[    0.986803] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    0.987882] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    1.000956] NET: Registered protocol family 1
[    1.001717] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.002723] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.003694] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.004755] pci 0000:00:02.0: Boot video device
[    1.005669] PCI: CLS 0 bytes, default 64
[    1.006728] Unpacking initramfs...
[    2.474072] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffe=
ffff]
[    2.502147] DMA-API: preallocated 32768 debug entries
[    2.502831] DMA-API: debugging enabled by kernel config
[    2.504004] bus: 'clocksource': registered
[    2.504546] device: 'clocksource': device_add
[    2.508583] PM: Adding info for No Bus:clocksource
[    2.509247] device: 'clocksource0': device_add
[    2.509835] bus: 'clocksource': add device clocksource0
[    2.510512] PM: Adding info for clocksource:clocksource0
[    2.511254] bus: 'platform': add driver alarmtimer
[    2.512004] Registering platform device 'alarmtimer'. Parent at platform
[    2.512858] device: 'alarmtimer': device_add
[    2.513407] bus: 'platform': add device alarmtimer
[    2.514037] PM: Adding info for platform:alarmtimer
[    2.518111] bus: 'platform': driver_probe_device: matched device alarmti=
mer with driver alarmtimer
[    2.519276] bus: 'platform': really_probe: probing driver alarmtimer wit=
h device alarmtimer
[    2.520340] driver: 'alarmtimer': driver_bound: bound to device 'alarmti=
mer'
[    2.521242] bus: 'platform': really_probe: bound device alarmtimer to dr=
iver alarmtimer
[    2.522440] audit: initializing netlink socket (disabled)
[    2.523198] type=3D2000 audit(1347238047.510:1): initialized
[    2.524046] bus: 'event_source': registered
[    2.524598] device: 'breakpoint': device_add
[    2.528608] bus: 'event_source': add device breakpoint
[    2.529334] PM: Adding info for event_source:breakpoint
[    2.530059] device: 'software': device_add
[    2.530595] bus: 'event_source': add device software
[    2.531246] PM: Adding info for event_source:software
[    2.548408] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.585390] VFS: Disk quotas dquot_6.5.2
[    2.586356] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.588064] msgmni has been set to 398
[    2.588937] device class 'bsg': registering
[    2.589632] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    2.591029] io scheduler noop registered (default)
[    2.591950] bus: 'pci': add driver langwell_gpio
[    2.592846] bus: 'platform': add driver wp_gpio
[    2.594262] bus: 'pci_express': registered
[    2.594997] bus: 'pci': add driver pcieport
[    2.595742] bus: 'pci_express': add driver aer
[    2.596613] bus: 'acpi': add driver hardware_error_device
[    2.597547] GHES: HEST is not enabled!
[    2.598169] bus: 'pci': add driver xen-platform-pci
[    2.599062] device: 'ptyp0': device_add
[    2.599719] PM: Adding info for No Bus:ptyp0
[    2.600419] device: 'ptyp1': device_add
[    2.601076] PM: Adding info for No Bus:ptyp1
[    2.601792] device: 'ptyp2': device_add
[    2.602453] PM: Adding info for No Bus:ptyp2
[    2.603157] device: 'ptyp3': device_add
[    2.603809] PM: Adding info for No Bus:ptyp3
[    2.604503] device: 'ptyp4': device_add
[    2.605132] PM: Adding info for No Bus:ptyp4
[    2.605849] device: 'ptyp5': device_add
[    2.606507] PM: Adding info for No Bus:ptyp5
[    2.607208] device: 'ptyp6': device_add
[    2.607874] PM: Adding info for No Bus:ptyp6
[    2.612653] device: 'ptyp7': device_add
[    2.613313] PM: Adding info for No Bus:ptyp7
[    2.614014] device: 'ptyp8': device_add
[    2.614660] PM: Adding info for No Bus:ptyp8
[    2.615367] device: 'ptyp9': device_add
[    2.616056] PM: Adding info for No Bus:ptyp9
[    2.616765] device: 'ptypa': device_add
[    2.617398] PM: Adding info for No Bus:ptypa
[    2.618114] device: 'ptypb': device_add
[    2.618733] PM: Adding info for No Bus:ptypb
[    2.623623] device: 'ptypc': device_add
[    2.624246] PM: Adding info for No Bus:ptypc
[    2.624915] device: 'ptypd': device_add
[    2.625539] PM: Adding info for No Bus:ptypd
[    2.626213] device: 'ptype': device_add
[    2.626819] PM: Adding info for No Bus:ptype
[    2.627473] device: 'ptypf': device_add
[    2.628085] PM: Adding info for No Bus:ptypf
[    2.628756] device: 'ptyq0': device_add
[    2.630089] PM: Adding info for No Bus:ptyq0
[    2.635078] device: 'ptyq1': device_add
[    2.637714] PM: Adding info for No Bus:ptyq1
[    2.638491] device: 'ptyq2': device_add
[    2.639185] PM: Adding info for No Bus:ptyq2
[    2.639932] device: 'ptyq3': device_add
[    2.640613] PM: Adding info for No Bus:ptyq3
[    2.641359] device: 'ptyq4': device_add
[    2.642063] PM: Adding info for No Bus:ptyq4
[    2.642846] device: 'ptyq5': device_add
[    2.643520] PM: Adding info for No Bus:ptyq5
[    2.644264] device: 'ptyq6': device_add
[    2.644952] PM: Adding info for No Bus:ptyq6
[    2.662731] device: 'ptyq7': device_add
[    2.663422] PM: Adding info for No Bus:ptyq7
[    2.664175] device: 'ptyq8': device_add
[    2.664890] PM: Adding info for No Bus:ptyq8
[    2.665654] device: 'ptyq9': device_add
[    2.666350] PM: Adding info for No Bus:ptyq9
[    2.667095] device: 'ptyqa': device_add
[    2.667786] PM: Adding info for No Bus:ptyqa
[    2.668522] device: 'ptyqb': device_add
[    2.669228] PM: Adding info for No Bus:ptyqb
[    2.669982] device: 'ptyqc': device_add
[    2.670673] PM: Adding info for No Bus:ptyqc
[    2.671406] device: 'ptyqd': device_add
[    2.672099] PM: Adding info for No Bus:ptyqd
[    2.672839] device: 'ptyqe': device_add
[    2.673521] PM: Adding info for No Bus:ptyqe
[    2.677165] device: 'ptyqf': device_add
[    2.677701] PM: Adding info for No Bus:ptyqf
[    2.678267] device: 'ptyr0': device_add
[    2.678786] PM: Adding info for No Bus:ptyr0
[    2.679343] device: 'ptyr1': device_add
[    2.679863] PM: Adding info for No Bus:ptyr1
[    2.680425] device: 'ptyr2': device_add
[    2.680959] PM: Adding info for No Bus:ptyr2
[    2.681515] device: 'ptyr3': device_add
[    2.682040] PM: Adding info for No Bus:ptyr3
[    2.682593] device: 'ptyr4': device_add
[    2.683114] PM: Adding info for No Bus:ptyr4
[    2.683697] device: 'ptyr5': device_add
[    2.684212] PM: Adding info for No Bus:ptyr5
[    2.701836] device: 'ptyr6': device_add
[    2.702397] PM: Adding info for No Bus:ptyr6
[    2.703037] device: 'ptyr7': device_add
[    2.703609] PM: Adding info for No Bus:ptyr7
[    2.704174] device: 'ptyr8': device_add
[    2.704693] PM: Adding info for No Bus:ptyr8
[    2.705248] device: 'ptyr9': device_add
[    2.705783] PM: Adding info for No Bus:ptyr9
[    2.706370] device: 'ptyra': device_add
[    2.706906] PM: Adding info for No Bus:ptyra
[    2.707465] device: 'ptyrb': device_add
[    2.707984] PM: Adding info for No Bus:ptyrb
[    2.708535] device: 'ptyrc': device_add
[    2.709055] PM: Adding info for No Bus:ptyrc
[    2.709609] device: 'ptyrd': device_add
[    2.710141] PM: Adding info for No Bus:ptyrd
[    2.710701] device: 'ptyre': device_add
[    2.711212] PM: Adding info for No Bus:ptyre
[    2.711773] device: 'ptyrf': device_add
[    2.712279] PM: Adding info for No Bus:ptyrf
[    2.712868] device: 'ptys0': device_add
[    2.713460] PM: Adding info for No Bus:ptys0
[    2.714135] device: 'ptys1': device_add
[    2.714762] PM: Adding info for No Bus:ptys1
[    2.715444] device: 'ptys2': device_add
[    2.716081] PM: Adding info for No Bus:ptys2
[    2.716684] device: 'ptys3': device_add
[    2.717204] PM: Adding info for No Bus:ptys3
[    2.720269] device: 'ptys4': device_add
[    2.720960] PM: Adding info for No Bus:ptys4
[    2.721691] device: 'ptys5': device_add
[    2.722336] PM: Adding info for No Bus:ptys5
[    2.723048] device: 'ptys6': device_add
[    2.723695] PM: Adding info for No Bus:ptys6
[    2.724401] device: 'ptys7': device_add
[    2.725040] PM: Adding info for No Bus:ptys7
[    2.725770] device: 'ptys8': device_add
[    2.726433] PM: Adding info for No Bus:ptys8
[    2.727974] device: 'ptys9': device_add
[    2.738271] PM: Adding info for No Bus:ptys9
[    2.739023] device: 'ptysa': device_add
[    2.739675] PM: Adding info for No Bus:ptysa
[    2.740370] device: 'ptysb': device_add
[    2.741036] PM: Adding info for No Bus:ptysb
[    2.741740] device: 'ptysc': device_add
[    2.742389] PM: Adding info for No Bus:ptysc
[    2.743973] device: 'ptysd': device_add
[    2.756180] PM: Adding info for No Bus:ptysd
[    2.756887] device: 'ptyse': device_add
[    2.757535] PM: Adding info for No Bus:ptyse
[    2.758234] device: 'ptysf': device_add
[    2.758901] PM: Adding info for No Bus:ptysf
[    2.759631] device: 'ptyt0': device_add
[    2.760285] PM: Adding info for No Bus:ptyt0
[    2.760997] device: 'ptyt1': device_add
[    2.761636] PM: Adding info for No Bus:ptyt1
[    2.762356] device: 'ptyt2': device_add
[    2.763004] PM: Adding info for No Bus:ptyt2
[    2.763717] device: 'ptyt3': device_add
[    2.764366] PM: Adding info for No Bus:ptyt3
[    2.765071] device: 'ptyt4': device_add
[    2.765744] PM: Adding info for No Bus:ptyt4
[    2.766467] device: 'ptyt5': device_add
[    2.782169] PM: Adding info for No Bus:ptyt5
[    2.782884] device: 'ptyt6': device_add
[    2.783555] PM: Adding info for No Bus:ptyt6
[    2.784261] device: 'ptyt7': device_add
[    2.784920] PM: Adding info for No Bus:ptyt7
[    2.785627] device: 'ptyt8': device_add
[    2.786288] PM: Adding info for No Bus:ptyt8
[    2.786993] device: 'ptyt9': device_add
[    2.787633] PM: Adding info for No Bus:ptyt9
[    2.788346] device: 'ptyta': device_add
[    2.789003] PM: Adding info for No Bus:ptyta
[    2.789722] device: 'ptytb': device_add
[    2.790359] PM: Adding info for No Bus:ptytb
[    2.791069] device: 'ptytc': device_add
[    2.791722] PM: Adding info for No Bus:ptytc
[    2.792425] device: 'ptytd': device_add
[    2.793184] PM: Adding info for No Bus:ptytd
[    2.793942] device: 'ptyte': device_add
[    2.794631] PM: Adding info for No Bus:ptyte
[    2.795341] device: 'ptytf': device_add
[    2.796056] PM: Adding info for No Bus:ptytf
[    2.796813] device: 'ptyu0': device_add
[    2.797900] PM: Adding info for No Bus:ptyu0
[    2.798835] device: 'ptyu1': device_add
[    2.799559] PM: Adding info for No Bus:ptyu1
[    2.800274] device: 'ptyu2': device_add
[    2.800985] PM: Adding info for No Bus:ptyu2
[    2.801756] device: 'ptyu3': device_add
[    2.802443] PM: Adding info for No Bus:ptyu3
[    2.803149] device: 'ptyu4': device_add
[    2.803874] PM: Adding info for No Bus:ptyu4
[    2.804675] device: 'ptyu5': device_add
[    2.805320] PM: Adding info for No Bus:ptyu5
[    2.806099] device: 'ptyu6': device_add
[    2.806803] PM: Adding info for No Bus:ptyu6
[    2.807654] device: 'ptyu7': device_add
[    2.809316] PM: Adding info for No Bus:ptyu7
[    2.810023] device: 'ptyu8': device_add
[    2.810798] PM: Adding info for No Bus:ptyu8
[    2.811510] device: 'ptyu9': device_add
[    2.812156] PM: Adding info for No Bus:ptyu9
[    2.812870] device: 'ptyua': device_add
[    2.813505] PM: Adding info for No Bus:ptyua
[    2.814246] device: 'ptyub': device_add
[    2.814898] PM: Adding info for No Bus:ptyub
[    2.816578] device: 'ptyuc': device_add
[    2.817241] PM: Adding info for No Bus:ptyuc
[    2.818007] device: 'ptyud': device_add
[    2.818715] PM: Adding info for No Bus:ptyud
[    2.819458] device: 'ptyue': device_add
[    2.820113] PM: Adding info for No Bus:ptyue
[    2.820863] device: 'ptyuf': device_add
[    2.821575] PM: Adding info for No Bus:ptyuf
[    2.822290] device: 'ptyv0': device_add
[    2.822991] PM: Adding info for No Bus:ptyv0
[    2.823741] device: 'ptyv1': device_add
[    2.824387] PM: Adding info for No Bus:ptyv1
[    2.825149] device: 'ptyv2': device_add
[    2.825859] PM: Adding info for No Bus:ptyv2
[    2.826693] device: 'ptyv3': device_add
[    2.827546] PM: Adding info for No Bus:ptyv3
[    2.828264] device: 'ptyv4': device_add
[    2.828970] PM: Adding info for No Bus:ptyv4
[    2.829889] device: 'ptyv5': device_add
[    2.830596] PM: Adding info for No Bus:ptyv5
[    2.831310] device: 'ptyv6': device_add
[    2.832035] PM: Adding info for No Bus:ptyv6
[    2.833961] device: 'ptyv7': device_add
[    2.834672] PM: Adding info for No Bus:ptyv7
[    2.842888] device: 'ptyv8': device_add
[    2.843582] PM: Adding info for No Bus:ptyv8
[    2.844284] device: 'ptyv9': device_add
[    2.844990] PM: Adding info for No Bus:ptyv9
[    2.845756] device: 'ptyva': device_add
[    2.846522] PM: Adding info for No Bus:ptyva
[    2.847235] device: 'ptyvb': device_add
[    2.847886] PM: Adding info for No Bus:ptyvb
[    2.848580] device: 'ptyvc': device_add
[    2.849182] PM: Adding info for No Bus:ptyvc
[    2.851569] device: 'ptyvd': device_add
[    2.852205] PM: Adding info for No Bus:ptyvd
[    2.852877] device: 'ptyve': device_add
[    2.853488] PM: Adding info for No Bus:ptyve
[    2.854182] device: 'ptyvf': device_add
[    2.855840] PM: Adding info for No Bus:ptyvf
[    2.856552] device: 'ptyw0': device_add
[    2.857198] PM: Adding info for No Bus:ptyw0
[    2.857912] device: 'ptyw1': device_add
[    2.858568] PM: Adding info for No Bus:ptyw1
[    2.859526] device: 'ptyw2': device_add
[    2.860177] PM: Adding info for No Bus:ptyw2
[    2.860979] device: 'ptyw3': device_add
[    2.861724] PM: Adding info for No Bus:ptyw3
[    2.862510] device: 'ptyw4': device_add
[    2.863179] PM: Adding info for No Bus:ptyw4
[    2.864000] device: 'ptyw5': device_add
[    2.864777] PM: Adding info for No Bus:ptyw5
[    2.865558] device: 'ptyw6': device_add
[    2.866232] PM: Adding info for No Bus:ptyw6
[    2.867063] device: 'ptyw7': device_add
[    2.867811] PM: Adding info for No Bus:ptyw7
[    2.868569] device: 'ptyw8': device_add
[    2.869268] PM: Adding info for No Bus:ptyw8
[    2.870276] device: 'ptyw9': device_add
[    2.871029] PM: Adding info for No Bus:ptyw9
[    2.871907] device: 'ptywa': device_add
[    2.872744] PM: Adding info for No Bus:ptywa
[    2.873542] device: 'ptywb': device_add
[    2.874234] PM: Adding info for No Bus:ptywb
[    2.875125] device: 'ptywc': device_add
[    2.875916] PM: Adding info for No Bus:ptywc
[    2.876867] device: 'ptywd': device_add
[    2.877514] PM: Adding info for No Bus:ptywd
[    2.878268] device: 'ptywe': device_add
[    2.878963] PM: Adding info for No Bus:ptywe
[    2.879621] device: 'ptywf': device_add
[    2.880442] PM: Adding info for No Bus:ptywf
[    2.881221] device: 'ptyx0': device_add
[    2.883136] PM: Adding info for No Bus:ptyx0
[    2.883921] device: 'ptyx1': device_add
[    2.884529] PM: Adding info for No Bus:ptyx1
[    2.886380] device: 'ptyx2': device_add
[    2.887143] PM: Adding info for No Bus:ptyx2
[    2.887963] device: 'ptyx3': device_add
[    2.888669] PM: Adding info for No Bus:ptyx3
[    2.889454] device: 'ptyx4': device_add
[    2.890133] PM: Adding info for No Bus:ptyx4
[    2.891012] device: 'ptyx5': device_add
[    2.891719] PM: Adding info for No Bus:ptyx5
[    2.892650] device: 'ptyx6': device_add
[    2.893492] PM: Adding info for No Bus:ptyx6
[    2.894258] device: 'ptyx7': device_add
[    2.895079] PM: Adding info for No Bus:ptyx7
[    2.895906] device: 'ptyx8': device_add
[    2.896561] PM: Adding info for No Bus:ptyx8
[    2.897356] device: 'ptyx9': device_add
[    2.898214] PM: Adding info for No Bus:ptyx9
[    2.898971] device: 'ptyxa': device_add
[    2.899598] PM: Adding info for No Bus:ptyxa
[    2.900479] device: 'ptyxb': device_add
[    2.901191] PM: Adding info for No Bus:ptyxb
[    2.901942] device: 'ptyxc': device_add
[    2.902584] PM: Adding info for No Bus:ptyxc
[    2.903347] device: 'ptyxd': device_add
[    2.904042] PM: Adding info for No Bus:ptyxd
[    2.904748] device: 'ptyxe': device_add
[    2.905562] PM: Adding info for No Bus:ptyxe
[    2.906346] device: 'ptyxf': device_add
[    2.907044] PM: Adding info for No Bus:ptyxf
[    2.907755] device: 'ptyy0': device_add
[    2.908454] PM: Adding info for No Bus:ptyy0
[    2.909199] device: 'ptyy1': device_add
[    2.910017] PM: Adding info for No Bus:ptyy1
[    2.910735] device: 'ptyy2': device_add
[    2.911370] PM: Adding info for No Bus:ptyy2
[    2.912088] device: 'ptyy3': device_add
[    2.912775] PM: Adding info for No Bus:ptyy3
[    2.913485] device: 'ptyy4': device_add
[    2.914088] PM: Adding info for No Bus:ptyy4
[    2.914780] device: 'ptyy5': device_add
[    2.917597] PM: Adding info for No Bus:ptyy5
[    2.918386] device: 'ptyy6': device_add
[    2.919147] PM: Adding info for No Bus:ptyy6
[    2.919951] device: 'ptyy7': device_add
[    2.920681] PM: Adding info for No Bus:ptyy7
[    2.921497] device: 'ptyy8': device_add
[    2.922273] PM: Adding info for No Bus:ptyy8
[    2.923149] device: 'ptyy9': device_add
[    2.923896] PM: Adding info for No Bus:ptyy9
[    2.924610] device: 'ptyya': device_add
[    2.925341] PM: Adding info for No Bus:ptyya
[    2.926152] device: 'ptyyb': device_add
[    2.926899] PM: Adding info for No Bus:ptyyb
[    2.927608] device: 'ptyyc': device_add
[    2.928427] PM: Adding info for No Bus:ptyyc
[    2.929216] device: 'ptyyd': device_add
[    2.930031] PM: Adding info for No Bus:ptyyd
[    2.930746] device: 'ptyye': device_add
[    2.931641] PM: Adding info for No Bus:ptyye
[    2.932428] device: 'ptyyf': device_add
[    2.933220] PM: Adding info for No Bus:ptyyf
[    2.933884] device: 'ptyz0': device_add
[    2.934491] PM: Adding info for No Bus:ptyz0
[    2.935162] device: 'ptyz1': device_add
[    2.935810] PM: Adding info for No Bus:ptyz1
[    2.936492] device: 'ptyz2': device_add
[    2.937097] PM: Adding info for No Bus:ptyz2
[    2.937755] device: 'ptyz3': device_add
[    2.938382] PM: Adding info for No Bus:ptyz3
[    2.941611] device: 'ptyz4': device_add
[    2.942218] PM: Adding info for No Bus:ptyz4
[    2.942900] device: 'ptyz5': device_add
[    2.943501] PM: Adding info for No Bus:ptyz5
[    2.944164] device: 'ptyz6': device_add
[    2.944781] PM: Adding info for No Bus:ptyz6
[    2.945419] device: 'ptyz7': device_add
[    2.946061] PM: Adding info for No Bus:ptyz7
[    2.946723] device: 'ptyz8': device_add
[    2.947329] PM: Adding info for No Bus:ptyz8
[    2.948000] device: 'ptyz9': device_add
[    2.948603] PM: Adding info for No Bus:ptyz9
[    2.949314] device: 'ptyza': device_add
[    2.949967] PM: Adding info for No Bus:ptyza
[    2.950637] device: 'ptyzb': device_add
[    2.951353] PM: Adding info for No Bus:ptyzb
[    2.952343] device: 'ptyzc': device_add
[    2.953179] PM: Adding info for No Bus:ptyzc
[    2.954080] device: 'ptyzd': device_add
[    2.954908] PM: Adding info for No Bus:ptyzd
[    2.955823] device: 'ptyze': device_add
[    2.956645] PM: Adding info for No Bus:ptyze
[    2.957547] device: 'ptyzf': device_add
[    2.958388] PM: Adding info for No Bus:ptyzf
[    2.959323] device: 'ptya0': device_add
[    2.960192] PM: Adding info for No Bus:ptya0
[    2.961133] device: 'ptya1': device_add
[    2.961962] PM: Adding info for No Bus:ptya1
[    2.962630] device: 'ptya2': device_add
[    2.963291] PM: Adding info for No Bus:ptya2
[    2.964025] device: 'ptya3': device_add
[    2.964703] PM: Adding info for No Bus:ptya3
[    2.965344] device: 'ptya4': device_add
[    2.965973] PM: Adding info for No Bus:ptya4
[    2.966705] device: 'ptya5': device_add
[    2.967366] PM: Adding info for No Bus:ptya5
[    2.968068] device: 'ptya6': device_add
[    2.968750] PM: Adding info for No Bus:ptya6
[    2.969913] device: 'ptya7': device_add
[    2.970508] PM: Adding info for No Bus:ptya7
[    2.971173] device: 'ptya8': device_add
[    2.971813] PM: Adding info for No Bus:ptya8
[    2.972350] device: 'ptya9': device_add
[    2.972850] PM: Adding info for No Bus:ptya9
[    2.973379] device: 'ptyaa': device_add
[    2.974979] PM: Adding info for No Bus:ptyaa
[    2.975514] device: 'ptyab': device_add
[    2.978492] PM: Adding info for No Bus:ptyab
[    2.979075] device: 'ptyac': device_add
[    2.979577] PM: Adding info for No Bus:ptyac
[    2.980357] device: 'ptyad': device_add
[    2.981247] PM: Adding info for No Bus:ptyad
[    2.982142] device: 'ptyae': device_add
[    2.982964] PM: Adding info for No Bus:ptyae
[    2.983912] device: 'ptyaf': device_add
[    2.984736] PM: Adding info for No Bus:ptyaf
[    2.985640] device: 'ptyb0': device_add
[    2.986478] PM: Adding info for No Bus:ptyb0
[    2.989695] device: 'ptyb1': device_add
[    2.993997] PM: Adding info for No Bus:ptyb1
[    2.994559] device: 'ptyb2': device_add
[    2.995058] PM: Adding info for No Bus:ptyb2
[    2.995586] device: 'ptyb3': device_add
[    2.996234] PM: Adding info for No Bus:ptyb3
[    2.996906] device: 'ptyb4': device_add
[    2.997513] PM: Adding info for No Bus:ptyb4
[    2.998191] device: 'ptyb5': device_add
[    2.998811] PM: Adding info for No Bus:ptyb5
[    2.999671] device: 'ptyb6': device_add
[    3.000357] PM: Adding info for No Bus:ptyb6
[    3.001094] device: 'ptyb7': device_add
[    3.001724] PM: Adding info for No Bus:ptyb7
[    3.002454] device: 'ptyb8': device_add
[    3.003040] PM: Adding info for No Bus:ptyb8
[    3.003571] device: 'ptyb9': device_add
[    3.004128] PM: Adding info for No Bus:ptyb9
[    3.004660] device: 'ptyba': device_add
[    3.005222] PM: Adding info for No Bus:ptyba
[    3.005792] device: 'ptybb': device_add
[    3.006338] PM: Adding info for No Bus:ptybb
[    3.007024] device: 'ptybc': device_add
[    3.007636] PM: Adding info for No Bus:ptybc
[    3.008385] device: 'ptybd': device_add
[    3.009100] PM: Adding info for No Bus:ptybd
[    3.009761] device: 'ptybe': device_add
[    3.010438] PM: Adding info for No Bus:ptybe
[    3.011207] device: 'ptybf': device_add
[    3.011820] PM: Adding info for No Bus:ptybf
[    3.012483] device: 'ptyc0': device_add
[    3.013091] PM: Adding info for No Bus:ptyc0
[    3.013750] device: 'ptyc1': device_add
[    3.014369] PM: Adding info for No Bus:ptyc1
[    3.015170] device: 'ptyc2': device_add
[    3.015821] PM: Adding info for No Bus:ptyc2
[    3.016413] device: 'ptyc3': device_add
[    3.016876] PM: Adding info for No Bus:ptyc3
[    3.017360] device: 'ptyc4': device_add
[    3.017841] PM: Adding info for No Bus:ptyc4
[    3.018399] device: 'ptyc5': device_add
[    3.018924] PM: Adding info for No Bus:ptyc5
[    3.019542] device: 'ptyc6': device_add
[    3.020023] PM: Adding info for No Bus:ptyc6
[    3.020501] device: 'ptyc7': device_add
[    3.020908] PM: Adding info for No Bus:ptyc7
[    3.021369] device: 'ptyc8': device_add
[    3.021814] PM: Adding info for No Bus:ptyc8
[    3.022280] device: 'ptyc9': device_add
[    3.022679] PM: Adding info for No Bus:ptyc9
[    3.023115] device: 'ptyca': device_add
[    3.023548] PM: Adding info for No Bus:ptyca
[    3.024012] device: 'ptycb': device_add
[    3.024421] PM: Adding info for No Bus:ptycb
[    3.024843] device: 'ptycc': device_add
[    3.025261] PM: Adding info for No Bus:ptycc
[    3.025699] device: 'ptycd': device_add
[    3.026093] PM: Adding info for No Bus:ptycd
[    3.026525] device: 'ptyce': device_add
[    3.026916] PM: Adding info for No Bus:ptyce
[    3.027438] device: 'ptycf': device_add
[    3.027968] PM: Adding info for No Bus:ptycf
[    3.028530] device: 'ptyd0': device_add
[    3.029068] PM: Adding info for No Bus:ptyd0
[    3.029635] device: 'ptyd1': device_add
[    3.030161] PM: Adding info for No Bus:ptyd1
[    3.030739] device: 'ptyd2': device_add
[    3.031260] PM: Adding info for No Bus:ptyd2
[    3.031827] device: 'ptyd3': device_add
[    3.032359] PM: Adding info for No Bus:ptyd3
[    3.032931] device: 'ptyd4': device_add
[    3.033450] PM: Adding info for No Bus:ptyd4
[    3.034035] device: 'ptyd5': device_add
[    3.034554] PM: Adding info for No Bus:ptyd5
[    3.035122] device: 'ptyd6': device_add
[    3.035659] PM: Adding info for No Bus:ptyd6
[    3.036323] device: 'ptyd7': device_add
[    3.036943] PM: Adding info for No Bus:ptyd7
[    3.037611] device: 'ptyd8': device_add
[    3.038224] PM: Adding info for No Bus:ptyd8
[    3.038994] device: 'ptyd9': device_add
[    3.039604] PM: Adding info for No Bus:ptyd9
[    3.040320] device: 'ptyda': device_add
[    3.041009] PM: Adding info for No Bus:ptyda
[    3.041732] device: 'ptydb': device_add
[    3.042338] PM: Adding info for No Bus:ptydb
[    3.043033] device: 'ptydc': device_add
[    3.043688] PM: Adding info for No Bus:ptydc
[    3.044421] device: 'ptydd': device_add
[    3.045046] PM: Adding info for No Bus:ptydd
[    3.045757] device: 'ptyde': device_add
[    3.046387] PM: Adding info for No Bus:ptyde
[    3.048153] device: 'ptydf': device_add
[    3.048757] PM: Adding info for No Bus:ptydf
[    3.049485] device: 'ptye0': device_add
[    3.050154] PM: Adding info for No Bus:ptye0
[    3.050823] device: 'ptye1': device_add
[    3.051490] PM: Adding info for No Bus:ptye1
[    3.052278] device: 'ptye2': device_add
[    3.053030] PM: Adding info for No Bus:ptye2
[    3.053787] device: 'ptye3': device_add
[    3.054463] PM: Adding info for No Bus:ptye3
[    3.055186] device: 'ptye4': device_add
[    3.055926] PM: Adding info for No Bus:ptye4
[    3.056598] device: 'ptye5': device_add
[    3.057222] PM: Adding info for No Bus:ptye5
[    3.057893] device: 'ptye6': device_add
[    3.058507] PM: Adding info for No Bus:ptye6
[    3.059224] device: 'ptye7': device_add
[    3.059839] PM: Adding info for No Bus:ptye7
[    3.060486] device: 'ptye8': device_add
[    3.061102] PM: Adding info for No Bus:ptye8
[    3.061782] device: 'ptye9': device_add
[    3.062409] PM: Adding info for No Bus:ptye9
[    3.063161] device: 'ptyea': device_add
[    3.063772] PM: Adding info for No Bus:ptyea
[    3.064445] device: 'ptyeb': device_add
[    3.065083] PM: Adding info for No Bus:ptyeb
[    3.065781] device: 'ptyec': device_add
[    3.066423] PM: Adding info for No Bus:ptyec
[    3.067162] device: 'ptyed': device_add
[    3.067829] PM: Adding info for No Bus:ptyed
[    3.068508] device: 'ptyee': device_add
[    3.069171] PM: Adding info for No Bus:ptyee
[    3.069919] device: 'ptyef': device_add
[    3.070562] PM: Adding info for No Bus:ptyef
[    3.071226] device: 'ttyp0': device_add
[    3.072538] PM: Adding info for No Bus:ttyp0
[    3.073267] device: 'ttyp1': device_add
[    3.073914] PM: Adding info for No Bus:ttyp1
[    3.074634] device: 'ttyp2': device_add
[    3.075299] PM: Adding info for No Bus:ttyp2
[    3.075963] device: 'ttyp3': device_add
[    3.076569] PM: Adding info for No Bus:ttyp3
[    3.077241] device: 'ttyp4': device_add
[    3.078000] PM: Adding info for No Bus:ttyp4
[    3.078763] device: 'ttyp5': device_add
[    3.079489] PM: Adding info for No Bus:ttyp5
[    3.080129] device: 'ttyp6': device_add
[    3.080729] PM: Adding info for No Bus:ttyp6
[    3.081385] device: 'ttyp7': device_add
[    3.082014] PM: Adding info for No Bus:ttyp7
[    3.082689] device: 'ttyp8': device_add
[    3.083295] PM: Adding info for No Bus:ttyp8
[    3.083957] device: 'ttyp9': device_add
[    3.084555] PM: Adding info for No Bus:ttyp9
[    3.085228] device: 'ttypa': device_add
[    3.085843] PM: Adding info for No Bus:ttypa
[    3.086395] device: 'ttypb': device_add
[    3.086901] PM: Adding info for No Bus:ttypb
[    3.087488] device: 'ttypc': device_add
[    3.088084] PM: Adding info for No Bus:ttypc
[    3.088751] device: 'ttypd': device_add
[    3.089355] PM: Adding info for No Bus:ttypd
[    3.090008] device: 'ttype': device_add
[    3.090636] PM: Adding info for No Bus:ttype
[    3.091315] device: 'ttypf': device_add
[    3.091924] PM: Adding info for No Bus:ttypf
[    3.092590] device: 'ttyq0': device_add
[    3.093220] PM: Adding info for No Bus:ttyq0
[    3.093905] device: 'ttyq1': device_add
[    3.094513] PM: Adding info for No Bus:ttyq1
[    3.095187] device: 'ttyq2': device_add
[    3.095850] PM: Adding info for No Bus:ttyq2
[    3.096524] device: 'ttyq3': device_add
[    3.097155] PM: Adding info for No Bus:ttyq3
[    3.097826] device: 'ttyq4': device_add
[    3.098436] PM: Adding info for No Bus:ttyq4
[    3.099145] device: 'ttyq5': device_add
[    3.099810] PM: Adding info for No Bus:ttyq5
[    3.100486] device: 'ttyq6': device_add
[    3.101109] PM: Adding info for No Bus:ttyq6
[    3.101778] device: 'ttyq7': device_add
[    3.102390] PM: Adding info for No Bus:ttyq7
[    3.103066] device: 'ttyq8': device_add
[    3.103691] PM: Adding info for No Bus:ttyq8
[    3.104392] device: 'ttyq9': device_add
[    3.105101] PM: Adding info for No Bus:ttyq9
[    3.105854] device: 'ttyqa': device_add
[    3.106441] PM: Adding info for No Bus:ttyqa
[    3.107102] device: 'ttyqb': device_add
[    3.107711] PM: Adding info for No Bus:ttyqb
[    3.108351] device: 'ttyqc': device_add
[    3.108872] PM: Adding info for No Bus:ttyqc
[    3.109409] device: 'ttyqd': device_add
[    3.109907] PM: Adding info for No Bus:ttyqd
[    3.110439] device: 'ttyqe': device_add
[    3.110937] PM: Adding info for No Bus:ttyqe
[    3.111468] device: 'ttyqf': device_add
[    3.112032] PM: Adding info for No Bus:ttyqf
[    3.112689] device: 'ttyr0': device_add
[    3.113221] PM: Adding info for No Bus:ttyr0
[    3.113766] device: 'ttyr1': device_add
[    3.114260] PM: Adding info for No Bus:ttyr1
[    3.114810] device: 'ttyr2': device_add
[    3.115302] PM: Adding info for No Bus:ttyr2
[    3.115868] device: 'ttyr3': device_add
[    3.116361] PM: Adding info for No Bus:ttyr3
[    3.116953] device: 'ttyr4': device_add
[    3.117575] PM: Adding info for No Bus:ttyr4
[    3.118294] device: 'ttyr5': device_add
[    3.118944] PM: Adding info for No Bus:ttyr5
[    3.119616] device: 'ttyr6': device_add
[    3.120219] PM: Adding info for No Bus:ttyr6
[    3.120888] device: 'ttyr7': device_add
[    3.121538] PM: Adding info for No Bus:ttyr7
[    3.122266] device: 'ttyr8': device_add
[    3.122917] PM: Adding info for No Bus:ttyr8
[    3.123558] device: 'ttyr9': device_add
[    3.124160] PM: Adding info for No Bus:ttyr9
[    3.124817] device: 'ttyra': device_add
[    3.125327] PM: Adding info for No Bus:ttyra
[    3.125890] device: 'ttyrb': device_add
[    3.126400] PM: Adding info for No Bus:ttyrb
[    3.126944] device: 'ttyrc': device_add
[    3.127444] PM: Adding info for No Bus:ttyrc
[    3.128065] device: 'ttyrd': device_add
[    3.128661] PM: Adding info for No Bus:ttyrd
[    3.129312] device: 'ttyre': device_add
[    3.129928] PM: Adding info for No Bus:ttyre
[    3.130582] device: 'ttyrf': device_add
[    3.131108] PM: Adding info for No Bus:ttyrf
[    3.131638] device: 'ttys0': device_add
[    3.132132] PM: Adding info for No Bus:ttys0
[    3.132670] device: 'ttys1': device_add
[    3.133163] PM: Adding info for No Bus:ttys1
[    3.133711] device: 'ttys2': device_add
[    3.134215] PM: Adding info for No Bus:ttys2
[    3.134753] device: 'ttys3': device_add
[    3.135241] PM: Adding info for No Bus:ttys3
[    3.135799] device: 'ttys4': device_add
[    3.136292] PM: Adding info for No Bus:ttys4
[    3.136854] device: 'ttys5': device_add
[    3.137356] PM: Adding info for No Bus:ttys5
[    3.137899] device: 'ttys6': device_add
[    3.138394] PM: Adding info for No Bus:ttys6
[    3.138933] device: 'ttys7': device_add
[    3.139421] PM: Adding info for No Bus:ttys7
[    3.140034] device: 'ttys8': device_add
[    3.140643] PM: Adding info for No Bus:ttys8
[    3.141302] device: 'ttys9': device_add
[    3.141931] PM: Adding info for No Bus:ttys9
[    3.142578] device: 'ttysa': device_add
[    3.143177] PM: Adding info for No Bus:ttysa
[    3.143847] device: 'ttysb': device_add
[    3.144447] PM: Adding info for No Bus:ttysb
[    3.145113] device: 'ttysc': device_add
[    3.145751] PM: Adding info for No Bus:ttysc
[    3.146453] device: 'ttysd': device_add
[    3.147072] PM: Adding info for No Bus:ttysd
[    3.147743] device: 'ttyse': device_add
[    3.148342] PM: Adding info for No Bus:ttyse
[    3.149000] device: 'ttysf': device_add
[    3.149624] PM: Adding info for No Bus:ttysf
[    3.150378] device: 'ttyt0': device_add
[    3.151076] PM: Adding info for No Bus:ttyt0
[    3.151752] device: 'ttyt1': device_add
[    3.152437] PM: Adding info for No Bus:ttyt1
[    3.153219] device: 'ttyt2': device_add
[    3.153926] PM: Adding info for No Bus:ttyt2
[    3.154723] device: 'ttyt3': device_add
[    3.155411] PM: Adding info for No Bus:ttyt3
[    3.156217] device: 'ttyt4': device_add
[    3.156942] PM: Adding info for No Bus:ttyt4
[    3.157641] device: 'ttyt5': device_add
[    3.158271] PM: Adding info for No Bus:ttyt5
[    3.158981] device: 'ttyt6': device_add
[    3.159647] PM: Adding info for No Bus:ttyt6
[    3.160360] device: 'ttyt7': device_add
[    3.160999] PM: Adding info for No Bus:ttyt7
[    3.161717] device: 'ttyt8': device_add
[    3.162415] PM: Adding info for No Bus:ttyt8
[    3.163098] device: 'ttyt9': device_add
[    3.163746] PM: Adding info for No Bus:ttyt9
[    3.164457] device: 'ttyta': device_add
[    3.165102] PM: Adding info for No Bus:ttyta
[    3.165762] device: 'ttytb': device_add
[    3.166375] PM: Adding info for No Bus:ttytb
[    3.167020] device: 'ttytc': device_add
[    3.167527] PM: Adding info for No Bus:ttytc
[    3.168068] device: 'ttytd': device_add
[    3.168558] PM: Adding info for No Bus:ttytd
[    3.169098] device: 'ttyte': device_add
[    3.169594] PM: Adding info for No Bus:ttyte
[    3.170134] device: 'ttytf': device_add
[    3.170619] PM: Adding info for No Bus:ttytf
[    3.171155] device: 'ttyu0': device_add
[    3.171646] PM: Adding info for No Bus:ttyu0
[    3.172184] device: 'ttyu1': device_add
[    3.172681] PM: Adding info for No Bus:ttyu1
[    3.173484] device: 'ttyu2': device_add
[    3.174135] PM: Adding info for No Bus:ttyu2
[    3.174798] device: 'ttyu3': device_add
[    3.175406] PM: Adding info for No Bus:ttyu3
[    3.176092] device: 'ttyu4': device_add
[    3.176710] PM: Adding info for No Bus:ttyu4
[    3.177383] device: 'ttyu5': device_add
[    3.177983] PM: Adding info for No Bus:ttyu5
[    3.178636] device: 'ttyu6': device_add
[    3.179265] PM: Adding info for No Bus:ttyu6
[    3.179942] device: 'ttyu7': device_add
[    3.180546] PM: Adding info for No Bus:ttyu7
[    3.181328] device: 'ttyu8': device_add
[    3.182067] PM: Adding info for No Bus:ttyu8
[    3.182854] device: 'ttyu9': device_add
[    3.183595] PM: Adding info for No Bus:ttyu9
[    3.184397] device: 'ttyua': device_add
[    3.184987] PM: Adding info for No Bus:ttyua
[    3.185519] device: 'ttyub': device_add
[    3.186036] PM: Adding info for No Bus:ttyub
[    3.186566] device: 'ttyuc': device_add
[    3.187062] PM: Adding info for No Bus:ttyuc
[    3.187592] device: 'ttyud': device_add
[    3.188103] PM: Adding info for No Bus:ttyud
[    3.188636] device: 'ttyue': device_add
[    3.189134] PM: Adding info for No Bus:ttyue
[    3.189671] device: 'ttyuf': device_add
[    3.190281] PM: Adding info for No Bus:ttyuf
[    3.190957] device: 'ttyv0': device_add
[    3.191574] PM: Adding info for No Bus:ttyv0
[    3.192246] device: 'ttyv1': device_add
[    3.192849] PM: Adding info for No Bus:ttyv1
[    3.193510] device: 'ttyv2': device_add
[    3.194136] PM: Adding info for No Bus:ttyv2
[    3.195000] device: 'ttyv3': device_add
[    3.195590] PM: Adding info for No Bus:ttyv3
[    3.196289] device: 'ttyv4': device_add
[    3.196947] PM: Adding info for No Bus:ttyv4
[    3.197686] device: 'ttyv5': device_add
[    3.198360] PM: Adding info for No Bus:ttyv5
[    3.199065] device: 'ttyv6': device_add
[    3.199650] PM: Adding info for No Bus:ttyv6
[    3.200313] device: 'ttyv7': device_add
[    3.200883] PM: Adding info for No Bus:ttyv7
[    3.201418] device: 'ttyv8': device_add
[    3.201915] PM: Adding info for No Bus:ttyv8
[    3.202444] device: 'ttyv9': device_add
[    3.202941] PM: Adding info for No Bus:ttyv9
[    3.203471] device: 'ttyva': device_add
[    3.203965] PM: Adding info for No Bus:ttyva
[    3.204494] device: 'ttyvb': device_add
[    3.205000] PM: Adding info for No Bus:ttyvb
[    3.205534] device: 'ttyvc': device_add
[    3.206051] PM: Adding info for No Bus:ttyvc
[    3.206585] device: 'ttyvd': device_add
[    3.207173] PM: Adding info for No Bus:ttyvd
[    3.207832] device: 'ttyve': device_add
[    3.208429] PM: Adding info for No Bus:ttyve
[    3.209152] device: 'ttyvf': device_add
[    3.209774] PM: Adding info for No Bus:ttyvf
[    3.210427] device: 'ttyw0': device_add
[    3.211138] PM: Adding info for No Bus:ttyw0
[    3.211936] device: 'ttyw1': device_add
[    3.212655] PM: Adding info for No Bus:ttyw1
[    3.213471] device: 'ttyw2': device_add
[    3.214140] PM: Adding info for No Bus:ttyw2
[    3.215937] device: 'ttyw3': device_add
[    3.216434] PM: Adding info for No Bus:ttyw3
[    3.216974] device: 'ttyw4': device_add
[    3.217461] PM: Adding info for No Bus:ttyw4
[    3.218017] device: 'ttyw5': device_add
[    3.218505] PM: Adding info for No Bus:ttyw5
[    3.222138] device: 'ttyw6': device_add
[    3.222781] PM: Adding info for No Bus:ttyw6
[    3.223452] device: 'ttyw7': device_add
[    3.224101] PM: Adding info for No Bus:ttyw7
[    3.224804] device: 'ttyw8': device_add
[    3.225466] PM: Adding info for No Bus:ttyw8
[    3.226166] device: 'ttyw9': device_add
[    3.226783] PM: Adding info for No Bus:ttyw9
[    3.227439] device: 'ttywa': device_add
[    3.227966] PM: Adding info for No Bus:ttywa
[    3.228497] device: 'ttywb': device_add
[    3.228999] PM: Adding info for No Bus:ttywb
[    3.229529] device: 'ttywc': device_add
[    3.230674] PM: Adding info for No Bus:ttywc
[    3.231210] device: 'ttywd': device_add
[    3.231775] PM: Adding info for No Bus:ttywd
[    3.232307] device: 'ttywe': device_add
[    3.232893] PM: Adding info for No Bus:ttywe
[    3.233588] device: 'ttywf': device_add
[    3.234182] PM: Adding info for No Bus:ttywf
[    3.234896] device: 'ttyx0': device_add
[    3.235564] PM: Adding info for No Bus:ttyx0
[    3.236266] device: 'ttyx1': device_add
[    3.236944] PM: Adding info for No Bus:ttyx1
[    3.237674] device: 'ttyx2': device_add
[    3.238395] PM: Adding info for No Bus:ttyx2
[    3.239202] device: 'ttyx3': device_add
[    3.239936] PM: Adding info for No Bus:ttyx3
[    3.240726] device: 'ttyx4': device_add
[    3.241473] PM: Adding info for No Bus:ttyx4
[    3.242307] device: 'ttyx5': device_add
[    3.242989] PM: Adding info for No Bus:ttyx5
[    3.243670] device: 'ttyx6': device_add
[    3.244287] PM: Adding info for No Bus:ttyx6
[    3.245034] device: 'ttyx7': device_add
[    3.245790] PM: Adding info for No Bus:ttyx7
[    3.246440] device: 'ttyx8': device_add
[    3.252864] PM: Adding info for No Bus:ttyx8
[    3.253600] device: 'ttyx9': device_add
[    3.254209] PM: Adding info for No Bus:ttyx9
[    3.254873] device: 'ttyxa': device_add
[    3.255480] PM: Adding info for No Bus:ttyxa
[    3.256304] device: 'ttyxb': device_add
[    3.257063] PM: Adding info for No Bus:ttyxb
[    3.257865] device: 'ttyxc': device_add
[    3.258594] PM: Adding info for No Bus:ttyxc
[    3.259391] device: 'ttyxd': device_add
[    3.260120] PM: Adding info for No Bus:ttyxd
[    3.260924] device: 'ttyxe': device_add
[    3.261650] PM: Adding info for No Bus:ttyxe
[    3.262444] device: 'ttyxf': device_add
[    3.263191] PM: Adding info for No Bus:ttyxf
[    3.263986] device: 'ttyy0': device_add
[    3.264718] PM: Adding info for No Bus:ttyy0
[    3.265512] device: 'ttyy1': device_add
[    3.266271] PM: Adding info for No Bus:ttyy1
[    3.267087] device: 'ttyy2': device_add
[    3.267846] PM: Adding info for No Bus:ttyy2
[    3.268645] device: 'ttyy3': device_add
[    3.269379] PM: Adding info for No Bus:ttyy3
[    3.275519] device: 'ttyy4': device_add
[    3.276271] PM: Adding info for No Bus:ttyy4
[    3.277095] device: 'ttyy5': device_add
[    3.277834] PM: Adding info for No Bus:ttyy5
[    3.278624] device: 'ttyy6': device_add
[    3.279365] PM: Adding info for No Bus:ttyy6
[    3.280161] device: 'ttyy7': device_add
[    3.280895] PM: Adding info for No Bus:ttyy7
[    3.281688] device: 'ttyy8': device_add
[    3.282419] PM: Adding info for No Bus:ttyy8
[    3.283209] device: 'ttyy9': device_add
[    3.283910] PM: Adding info for No Bus:ttyy9
[    3.284611] device: 'ttyya': device_add
[    3.285352] PM: Adding info for No Bus:ttyya
[    3.286181] device: 'ttyyb': device_add
[    3.286921] PM: Adding info for No Bus:ttyyb
[    3.287715] device: 'ttyyc': device_add
[    3.288445] PM: Adding info for No Bus:ttyyc
[    3.289236] device: 'ttyyd': device_add
[    3.289978] PM: Adding info for No Bus:ttyyd
[    3.294010] device: 'ttyye': device_add
[    3.294749] PM: Adding info for No Bus:ttyye
[    3.295544] device: 'ttyyf': device_add
[    3.296302] PM: Adding info for No Bus:ttyyf
[    3.297102] device: 'ttyz0': device_add
[    3.297840] PM: Adding info for No Bus:ttyz0
[    3.298632] device: 'ttyz1': device_add
[    3.299383] PM: Adding info for No Bus:ttyz1
[    3.300202] device: 'ttyz2': device_add
[    3.300926] PM: Adding info for No Bus:ttyz2
[    3.303527] device: 'ttyz3': device_add
[    3.304271] PM: Adding info for No Bus:ttyz3
[    3.305121] device: 'ttyz4': device_add
[    3.305963] PM: Adding info for No Bus:ttyz4
[    3.306850] device: 'ttyz5': device_add
[    3.307642] PM: Adding info for No Bus:ttyz5
[    3.308306] device: 'ttyz6': device_add
[    3.313363] PM: Adding info for No Bus:ttyz6
[    3.314167] device: 'ttyz7': device_add
[    3.314892] PM: Adding info for No Bus:ttyz7
[    3.315700] device: 'ttyz8': device_add
[    3.316443] PM: Adding info for No Bus:ttyz8
[    3.317245] device: 'ttyz9': device_add
[    3.317961] PM: Adding info for No Bus:ttyz9
[    3.318745] device: 'ttyza': device_add
[    3.319478] PM: Adding info for No Bus:ttyza
[    3.320264] device: 'ttyzb': device_add
[    3.321005] PM: Adding info for No Bus:ttyzb
[    3.321799] device: 'ttyzc': device_add
[    3.322528] PM: Adding info for No Bus:ttyzc
[    3.323323] device: 'ttyzd': device_add
[    3.324911] PM: Adding info for No Bus:ttyzd
[    3.326345] device: 'ttyze': device_add
[    3.331943] PM: Adding info for No Bus:ttyze
[    3.336799] device: 'ttyzf': device_add
[    3.337558] PM: Adding info for No Bus:ttyzf
[    3.338236] device: 'ttya0': device_add
[    3.338835] PM: Adding info for No Bus:ttya0
[    3.339493] device: 'ttya1': device_add
[    3.340234] PM: Adding info for No Bus:ttya1
[    3.341049] device: 'ttya2': device_add
[    3.341804] PM: Adding info for No Bus:ttya2
[    3.342597] device: 'ttya3': device_add
[    3.343343] PM: Adding info for No Bus:ttya3
[    3.344139] device: 'ttya4': device_add
[    3.344876] PM: Adding info for No Bus:ttya4
[    3.345721] device: 'ttya5': device_add
[    3.346453] PM: Adding info for No Bus:ttya5
[    3.347249] device: 'ttya6': device_add
[    3.349004] PM: Adding info for No Bus:ttya6
[    3.350444] device: 'ttya7': device_add
[    3.355743] PM: Adding info for No Bus:ttya7
[    3.360616] device: 'ttya8': device_add
[    3.361366] PM: Adding info for No Bus:ttya8
[    3.362164] device: 'ttya9': device_add
[    3.362896] PM: Adding info for No Bus:ttya9
[    3.363684] device: 'ttyaa': device_add
[    3.364431] PM: Adding info for No Bus:ttyaa
[    3.365235] device: 'ttyab': device_add
[    3.365992] PM: Adding info for No Bus:ttyab
[    3.366792] device: 'ttyac': device_add
[    3.367522] PM: Adding info for No Bus:ttyac
[    3.368320] device: 'ttyad': device_add
[    3.369077] PM: Adding info for No Bus:ttyad
[    3.370826] device: 'ttyae': device_add
[    3.376257] PM: Adding info for No Bus:ttyae
[    3.381096] device: 'ttyaf': device_add
[    3.381835] PM: Adding info for No Bus:ttyaf
[    3.382623] device: 'ttyb0': device_add
[    3.383371] PM: Adding info for No Bus:ttyb0
[    3.384177] device: 'ttyb1': device_add
[    3.384932] PM: Adding info for No Bus:ttyb1
[    3.385779] device: 'ttyb2': device_add
[    3.386507] PM: Adding info for No Bus:ttyb2
[    3.387311] device: 'ttyb3': device_add
[    3.388046] PM: Adding info for No Bus:ttyb3
[    3.388845] device: 'ttyb4': device_add
[    3.389585] PM: Adding info for No Bus:ttyb4
[    3.390419] device: 'ttyb5': device_add
[    3.391153] PM: Adding info for No Bus:ttyb5
[    3.392788] device: 'ttyb6': device_add
[    3.398334] PM: Adding info for No Bus:ttyb6
[    3.402907] device: 'ttyb7': device_add
[    3.403528] PM: Adding info for No Bus:ttyb7
[    3.404340] device: 'ttyb8': device_add
[    3.405096] PM: Adding info for No Bus:ttyb8
[    3.405920] device: 'ttyb9': device_add
[    3.406636] PM: Adding info for No Bus:ttyb9
[    3.407436] device: 'ttyba': device_add
[    3.408146] PM: Adding info for No Bus:ttyba
[    3.408956] device: 'ttybb': device_add
[    3.409707] PM: Adding info for No Bus:ttybb
[    3.410487] device: 'ttybc': device_add
[    3.411222] PM: Adding info for No Bus:ttybc
[    3.412024] device: 'ttybd': device_add
[    3.412760] PM: Adding info for No Bus:ttybd
[    3.413554] device: 'ttybe': device_add
[    3.414288] PM: Adding info for No Bus:ttybe
[    3.415078] device: 'ttybf': device_add
[    3.415855] PM: Adding info for No Bus:ttybf
[    3.416645] device: 'ttyc0': device_add
[    3.417265] PM: Adding info for No Bus:ttyc0
[    3.417959] device: 'ttyc1': device_add
[    3.418694] PM: Adding info for No Bus:ttyc1
[    3.419503] device: 'ttyc2': device_add
[    3.420333] PM: Adding info for No Bus:ttyc2
[    3.421188] device: 'ttyc3': device_add
[    3.421994] PM: Adding info for No Bus:ttyc3
[    3.422849] device: 'ttyc4': device_add
[    3.423627] PM: Adding info for No Bus:ttyc4
[    3.424459] device: 'ttyc5': device_add
[    3.425230] PM: Adding info for No Bus:ttyc5
[    3.426110] device: 'ttyc6': device_add
[    3.426915] PM: Adding info for No Bus:ttyc6
[    3.427768] device: 'ttyc7': device_add
[    3.428544] PM: Adding info for No Bus:ttyc7
[    3.429348] device: 'ttyc8': device_add
[    3.430137] PM: Adding info for No Bus:ttyc8
[    3.430988] device: 'ttyc9': device_add
[    3.431853] PM: Adding info for No Bus:ttyc9
[    3.432777] device: 'ttyca': device_add
[    3.433578] PM: Adding info for No Bus:ttyca
[    3.434388] device: 'ttycb': device_add
[    3.435291] PM: Adding info for No Bus:ttycb
[    3.436173] device: 'ttycc': device_add
[    3.437038] PM: Adding info for No Bus:ttycc
[    3.437840] device: 'ttycd': device_add
[    3.438690] PM: Adding info for No Bus:ttycd
[    3.439490] device: 'ttyce': device_add
[    3.440227] PM: Adding info for No Bus:ttyce
[    3.441014] device: 'ttycf': device_add
[    3.441747] PM: Adding info for No Bus:ttycf
[    3.442538] device: 'ttyd0': device_add
[    3.443271] PM: Adding info for No Bus:ttyd0
[    3.444004] device: 'ttyd1': device_add
[    3.444621] PM: Adding info for No Bus:ttyd1
[    3.445308] device: 'ttyd2': device_add
[    3.447137] PM: Adding info for No Bus:ttyd2
[    3.448101] device: 'ttyd3': device_add
[    3.448907] PM: Adding info for No Bus:ttyd3
[    3.449773] device: 'ttyd4': device_add
[    3.450572] PM: Adding info for No Bus:ttyd4
[    3.451618] device: 'ttyd5': device_add
[    3.452364] PM: Adding info for No Bus:ttyd5
[    3.453238] device: 'ttyd6': device_add
[    3.454030] PM: Adding info for No Bus:ttyd6
[    3.454879] device: 'ttyd7': device_add
[    3.455686] PM: Adding info for No Bus:ttyd7
[    3.456535] device: 'ttyd8': device_add
[    3.457296] PM: Adding info for No Bus:ttyd8
[    3.458156] device: 'ttyd9': device_add
[    3.458950] PM: Adding info for No Bus:ttyd9
[    3.459798] device: 'ttyda': device_add
[    3.460575] PM: Adding info for No Bus:ttyda
[    3.461369] device: 'ttydb': device_add
[    3.462111] PM: Adding info for No Bus:ttydb
[    3.462942] device: 'ttydc': device_add
[    3.463744] PM: Adding info for No Bus:ttydc
[    3.464673] device: 'ttydd': device_add
[    3.465270] PM: Adding info for No Bus:ttydd
[    3.465996] device: 'ttyde': device_add
[    3.466778] PM: Adding info for No Bus:ttyde
[    3.467559] device: 'ttydf': device_add
[    3.468283] PM: Adding info for No Bus:ttydf
[    3.469087] device: 'ttye0': device_add
[    3.471046] PM: Adding info for No Bus:ttye0
[    3.471992] device: 'ttye1': device_add
[    3.472793] PM: Adding info for No Bus:ttye1
[    3.473710] device: 'ttye2': device_add
[    3.474435] PM: Adding info for No Bus:ttye2
[    3.475288] device: 'ttye3': device_add
[    3.476028] PM: Adding info for No Bus:ttye3
[    3.476866] device: 'ttye4': device_add
[    3.477628] PM: Adding info for No Bus:ttye4
[    3.478458] device: 'ttye5': device_add
[    3.479108] PM: Adding info for No Bus:ttye5
[    3.479809] device: 'ttye6': device_add
[    3.480506] PM: Adding info for No Bus:ttye6
[    3.481206] device: 'ttye7': device_add
[    3.481857] PM: Adding info for No Bus:ttye7
[    3.482544] device: 'ttye8': device_add
[    3.483189] PM: Adding info for No Bus:ttye8
[    3.483938] device: 'ttye9': device_add
[    3.484584] PM: Adding info for No Bus:ttye9
[    3.485255] device: 'ttyea': device_add
[    3.485907] PM: Adding info for No Bus:ttyea
[    3.486565] device: 'ttyeb': device_add
[    3.487177] PM: Adding info for No Bus:ttyeb
[    3.487843] device: 'ttyec': device_add
[    3.488435] PM: Adding info for No Bus:ttyec
[    3.489080] device: 'ttyed': device_add
[    3.489703] PM: Adding info for No Bus:ttyed
[    3.490354] device: 'ttyee': device_add
[    3.491063] PM: Adding info for No Bus:ttyee
[    3.491770] device: 'ttyef': device_add
[    3.492457] PM: Adding info for No Bus:ttyef
[    3.493263] device: 'ptmx': device_add
[    3.493974] PM: Adding info for No Bus:ptmx
[    3.494793] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.495961] Registering platform device 'serial8250'. Parent at platform
[    3.497159] device: 'serial8250': device_add
[    3.497934] bus: 'platform': add device serial8250
[    3.498835] PM: Adding info for platform:serial8250
[    3.538823] tsc: Refined TSC clocksource calibration: 2693.507 MHz

[    3.797093] device: 'ttyS0': device_add
[    3.797797] PM: Adding info for No Bus:ttyS0
[    3.798479] device: 'ttyS1': device_add
[    3.799031] PM: Adding info for No Bus:ttyS1
[    3.799620] device: 'ttyS2': device_add
[    3.800124] PM: Adding info for No Bus:ttyS2
[    3.800765] device: 'ttyS3': device_add
[    3.801269] PM: Adding info for No Bus:ttyS3
[    3.801839] bus: 'platform': add driver serial8250
[    3.802433] bus: 'platform': driver_probe_device: matched device serial8=
250 with driver serial8250
[    3.803511] bus: 'platform': really_probe: probing driver serial8250 wit=
h device serial8250
[    3.804519] driver: 'serial8250': driver_bound: bound to device 'serial8=
250'
[    3.805538] bus: 'platform': really_probe: bound device serial8250 to dr=
iver serial8250
[    3.806831] device: 'ttyprintk': device_add
[    3.807499] PM: Adding info for No Bus:ttyprintk
[    3.808222] device: 'hpet': device_add
[    3.808832] PM: Adding info for No Bus:hpet
[    3.809492] bus: 'acpi': add driver hpet
[    3.810144] bus: 'acpi': driver_probe_device: matched device PNP0103:00 =
with driver hpet
[    3.811360] bus: 'acpi': really_probe: probing driver hpet with device P=
NP0103:00
[    3.812642] hpet: probe of PNP0103:00 rejects match -19
[    3.813545] bus: 'pnp': add driver i8042 kbd
[    3.814220] bus: 'pnp': driver_probe_device: matched device 00:02 with d=
river i8042 kbd
[    3.815424] bus: 'pnp': really_probe: probing driver i8042 kbd with devi=
ce 00:02
[    3.816578] driver: '00:02': driver_bound: bound to device 'i8042 kbd'
[    3.817590] bus: 'pnp': really_probe: bound device 00:02 to driver i8042=
 kbd
[    3.818704] bus: 'pnp': add driver i8042 aux
[    3.819419] bus: 'pnp': driver_probe_device: matched device 00:03 with d=
river i8042 aux
[    3.820514] bus: 'pnp': really_probe: probing driver i8042 aux with devi=
ce 00:03
[    3.821478] driver: '00:03': driver_bound: bound to device 'i8042 aux'
[    3.822312] bus: 'pnp': really_probe: bound device 00:03 to driver i8042=
 aux
[    3.823226] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    3.824447] Registering platform device 'i8042'. Parent at platform
[    3.825396] device: 'i8042': device_add
[    3.826002] bus: 'platform': add device i8042
[    3.826616] PM: Adding info for platform:i8042
[    3.827300] bus: 'platform': add driver i8042
[    3.828017] bus: 'platform': driver_probe_device: matched device i8042 w=
ith driver i8042
[    3.829380] bus: 'platform': really_probe: probing driver i8042 with dev=
ice i8042
[    3.846133] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.847066] device: 'serio0': device_add
[    3.847783] bus: 'serio': add device serio0
[    3.848502] PM: Adding info for serio:serio0
[    3.849221] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.851750] device: 'serio1': device_add
[    3.852294] bus: 'serio': add device serio1
[    3.852832] PM: Adding info for serio:serio1
[    3.853372] driver: 'i8042': driver_bound: bound to device 'i8042'
[    3.854124] bus: 'platform': really_probe: bound device i8042 to driver =
i8042
[    3.859368] bus: 'serio': add driver atkbd
[    3.860047] bus: 'serio': driver_probe_device: matched device serio0 wit=
h driver atkbd
[    3.861217] bus: 'serio': really_probe: probing driver atkbd with device=
 serio0
[    3.862631] cpuidle: using governor ladder
[    3.863596]=20
[    3.863596] printing PIC contents
[    3.864430] ... PIC  IMR: ffff
[    3.864819] ... PIC  IRR: 1013
[    3.865222] ... PIC  ISR: 0000
[    3.865618] ... PIC ELCR: 0c00
[    3.866012] printing local APIC contents on CPU#0/0:
[    3.866620] ... APIC ID:      00000000 (0)
[    3.867130] ... APIC VERSION: 00050014
[    3.867593] ... APIC TASKPRI: 00000000 (00)
[    3.868546] ... APIC PROCPRI: 00000000
[    3.869150] ... APIC LDR: 01000000
[    3.869677] ... APIC DFR: ffffffff
[    3.870197] ... APIC SPIV: 000001ff
[    3.870751] ... APIC ISR field:
[    3.871230] 000000000000000000000000000000000000000000000000000000000000=
0000
[    3.872512] ... APIC TMR field:
[    3.873010] 000000000000000000000000000000000000000000000000000000000000=
0000
[    3.874287] ... APIC IRR field:
[    3.874788] 000000000000000000000000000000000000000000000000000000002000=
8000
[    3.875608] ... APIC ESR: 00000000
[    3.875608] ... APIC ICR: 000008fb
[    3.875608] ... APIC ICR2: 02000000
[    3.875608] ... APIC LVTT: 000200ef
[    3.875608] ... APIC LVTPC: 00010000
[    3.875608] ... APIC LVT0: 00010700
[    3.875608] ... APIC LVT1: 00000400
[    3.875608] ... APIC LVTERR: 000000fe
[    3.875608] ... APIC TMICT: 00098962
[    3.875608] ... APIC TMCCT: 00045f41
[    3.875608] ... APIC TDCR: 00000003
[    3.875608]=20
[    3.882158] number of MP IRQ sources: 15.
[    3.882652] number of IO-APIC #2 registers: 24.
[    3.883206] testing the IO APIC.......................
[    3.883888] IO APIC #2......
[    3.884336] .... register #00: 00000000
[    3.884969] .......    : physical APIC id: 00
[    3.885720] .......    : Delivery Type: 0
[    3.886416] .......    : LTS          : 0
[    3.887041] .... register #01: 00170011
[    3.887606] .......     : max redirection entries: 17
[    3.888336] .......     : PRQ implemented: 0
[    3.888867] .......     : IO APIC version: 11
[    3.889393] .... register #02: 00000000
[    3.889864] .......     : arbitration: 00
[    3.890347] .... IRQ redirection table:
[    3.890819]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    3.891486]  00 00  1    0    0   0   0    0    0    00
[    3.892153]  01 03  0    0    0   0   0    1    1    31
[    3.892816]  02 03  0    0    0   0   0    1    1    30
[    3.893473]  03 03  1    0    0   0   0    1    1    33
[    3.894134]  04 03  1    0    0   0   0    1    1    34
[    3.894800]  05 03  1    1    0   0   0    1    1    35
[    3.895464]  06 03  1    0    0   0   0    1    1    36
[    3.896278]  07 03  1    0    0   0   0    1    1    37
[    3.897085]  08 03  1    0    0   0   0    1    1    38
[    3.920758]  09 03  0    1    0   0   0    1    1    39
[    3.921605]  0a 03  1    1    0   0   0    1    1    3A
[    3.922415]  0b 03  1    1    0   0   0    1    1    3B
[    3.923240]  0c 03  0    0    0   0   0    1    1    3C
[    3.924062]  0d 03  1    0    0   0   0    1    1    3D
[    3.924887]  0e 03  1    0    0   0   0    1    1    3E
[    3.925709]  0f 03  1    0    0   0   0    1    1    3F
[    3.926536]  10 00  1    0    0   0   0    0    0    00
[    3.927367]  11 00  1    0    0   0   0    0    0    00
[    3.928188]  12 00  1    0    0   0   0    0    0    00
[    3.929054]  13 00  1    0    0   0   0    0    0    00
[    3.929907]  14 00  1    0    0   0   0    0    0    00
[    3.930733]  15 00  1    0    0   0   0    0    0    00
[    3.931552]  16 00  1    0    0   0   0    0    0    00
[    3.932390]  17 00  1    0    0   0   0    0    0    00
[    3.933337] IRQ to pin mappings:
[    3.933761] IRQ0 -> 0:2
[    3.934123] IRQ1 -> 0:1
[    3.934482] IRQ3 -> 0:3
[    3.934847] IRQ4 -> 0:4
[    3.935207] IRQ5 -> 0:5
[    3.935567] IRQ6 -> 0:6
[    3.939918] IRQ7 -> 0:7
[    3.940346] IRQ8 -> 0:8
[    3.940765] IRQ9 -> 0:9
[    3.941187] IRQ10 -> 0:10
[    3.941632] IRQ11 -> 0:11
[    3.942088] IRQ12 -> 0:12
[    3.942560] IRQ13 -> 0:13
[    3.980098] IRQ14 -> 0:14
[    3.980652] IRQ15 -> 0:15
[    3.981201] .................................... done.
[    3.982152] device: 'cpu_dma_latency': device_add
[    3.983050] PM: Adding info for No Bus:cpu_dma_latency
[    3.999048] device: 'network_latency': device_add
[    3.999946] PM: Adding info for No Bus:network_latency
[    4.000816] device: 'network_throughput': device_add
[    4.001604] PM: Adding info for No Bus:network_throughput
[    4.002583] registered taskstats version 1
[    4.015081] debug: unmapping init [mem 0xffffffff81400000-0xffffffff8163=
5fff]
[    4.016504] device: 'input0': device_add
[    4.017410] PM: Adding info for No Bus:input0
[    4.018335] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    4.019790] driver: 'serio0': driver_bound: bound to device 'atkbd'
[    4.020791] bus: 'serio': really_probe: bound device serio0 to driver at=
kbd
[    4.021734] bus: 'serio': driver_probe_device: matched device serio1 wit=
h driver atkbd
[    4.022721] bus: 'serio': really_probe: probing driver atkbd with device=
 serio1
[    4.023973] atkbd: probe of serio1 rejects match -19
[    4.024677] divide error: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    4.025627] Modules linked in:
[    4.026041] CPU 0=20
[    4.026282] Pid: 21, comm: kworker/0:1 Not tainted 3.6.0-rc3-00186-gf117=
e2a #47 Bochs Bochs
[    4.026414] RIP: 0010:[<ffffffff810536e7>]  [<ffffffff810536e7>] update_=
sd_lb_stats+0x2a8/0x484
[    4.026414] RSP: 0018:ffff8800001dfac0  EFLAGS: 00010046
[    4.026414] RAX: 0000000000100000 RBX: ffff8800001dfcb0 RCX: 00000000000=
00000
[    4.026414] RDX: 0000000000000000 RSI: 00000000000000ff RDI: 00000000000=
00000
[    4.026414] RBP: ffff8800001dfb90 R08: ffff8800000812b8 R09: 00000000000=
00013
[    4.026414] R10: ffffffff813be9d0 R11: ffff88000ddd3240 R12: 00000000000=
00000
[    4.026414] R13: 0000000000000008 R14: ffff8800001dfba0 R15: ffff8800000=
812a0
[    4.026414] FS:  0000000000000000(0000) GS:ffff88000dc00000(0000) knlGS:=
0000000000000000
[    4.026414] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    4.026414] CR2: 0000000000000000 CR3: 00000000013a5000 CR4: 00000000000=
006b0
[    4.026414] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[    4.026414] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[    4.026414] Process kworker/0:1 (pid: 21, threadinfo ffff8800001de000, t=
ask ffff880000172000)
[    4.026414] Stack:
[    4.026414]  00000000001d3240 ffff8800000812b8 ffff8800001dfd4c 00000000=
001d3240
[    4.026414]  0000000000000001 0000000000000001 0000000000000000 00000000=
00000400
[    4.026414]  0000000000000001 0000000000000400 00000000ffffffff ffff8800=
001dfb20
[    4.026414] Call Trace:
[    4.026414]  [<ffffffff810538ef>] find_busiest_group+0x2c/0x1db
[    4.026414]  [<ffffffff81053b69>] load_balance+0xcb/0x5c5
[    4.026414]  [<ffffffff81061a2d>] ? lock_acquire+0xa6/0xb1
[    4.026414]  [<ffffffff81054273>] idle_balance+0x9c/0x111
[    4.026414]  [<ffffffff81239918>] __schedule+0x241/0x4bd
[    4.026414]  [<ffffffff81239c9e>] schedule+0x60/0x62
[    4.026414]  [<ffffffff810429ae>] worker_thread+0x21a/0x24b
[    4.026414]  [<ffffffff81042794>] ? rescuer_thread+0x17d/0x17d
[    4.026414]  [<ffffffff8104600f>] kthread+0x73/0x7b
[    4.026414]  [<ffffffff8123ce44>] kernel_thread_helper+0x4/0x10
[    4.026414]  [<ffffffff8123b3f4>] ? retint_restore_args+0x13/0x13
[    4.026414]  [<ffffffff81045f9c>] ? __init_kthread_worker+0x55/0x55
[    4.026414]  [<ffffffff8123ce40>] ? gs_change+0x13/0x13
[    4.026414] Code: 47 10 48 8b 15 3b b9 3a 00 48 3b 50 10 78 0b 8b 73 14 =
48 8b 3b e8 f8 fb ff ff 49 8b 57 10 48 8b 45 98 8b 4a 04 48 c1 e0 0a 31 d2 =
<48> f7 f1 48 8b 4d a0 48 89 45 90 31 c0 48 85 c9 74 09 48 8b 45=20
[    4.026414] RIP  [<ffffffff810536e7>] update_sd_lb_stats+0x2a8/0x484
[    4.026414]  RSP <ffff8800001dfac0>
[    4.026414] ---[ end trace f7d78ff4ba82407e ]---
[    4.026414] BUG: sleeping function called from invalid context at /c/ker=
nel-tests/src/tip/kernel/rwsem.c:20
[    4.026414] in_atomic(): 1, irqs_disabled(): 1, pid: 21, name: kworker/0=
:1
[    4.026414] INFO: lockdep is turned off.
[    4.026414] irq event stamp: 48988
[    4.028943] double fault: 0000 [#2] PREEMPT SMP DEBUG_PAGEALLOC
[    4.028943] Modules linked in:
[    4.028943] CPU 1=20
[    4.028943] Pid: 1, comm: init Tainted: G      D      3.6.0-rc3-00186-gf=
117e2a #47 Bochs Bochs
[    4.028943] RIP: 0010:[<ffffffff8105d75a>]  [<ffffffff8105d75a>] trace_h=
ardirqs_off_caller+0x4/0x11b
[    4.028943] RSP: 0018:ffff880000000000  EFLAGS: 00010082
[    4.028943] RAX: 000000008123b424 RBX: 0000000000000001 RCX: ffffffff812=
3b424
[    4.028943] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff812=
3b8b6
[    4.028943] RBP: ffff880000000000 R08: ffff88000ddd3240 R09: ffffffff815=
d4504
[    4.028943] R10: ffffffff815d4d9f R11: ffff88000005bf40 R12: ffffffff812=
32929
[    4.028943] R13: ffff88000005bef0 R14: 0000000000000008 R15: 00000000000=
00008
[    4.028943] FS:  0000000000000000(0000) GS:ffff88000de00000(0000) knlGS:=
0000000000000000
[    4.028943] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    4.028943] CR2: ffff87fffffffff8 CR3: 00000000001eb000 CR4: 00000000000=
006a0
[    4.028943] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[    4.028943] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[    4.028943] Process init (pid: 1, threadinfo ffff88000005a000, task ffff=
880000060000)
[    4.028943] Stack:
[    4.028943]=20
[    4.028943] Call Trace:
[    4.028943] Code: 48 c7 c7 8d 88 32 81 31 c0 e8 fa 73 1d 00 48 c7 c7 74 =
94 32 81 31 c0 e8 ec 73 1d 00 e8 5d 57 1d 00 5a 89 d8 5b 5d c3 55 48 89 e5 =
<41> 54 53 65 48 8b 1c 25 00 d7 00 00 83 3d c3 9c 37 00 00 0f 84=20
[    4.028943] RIP  [<ffffffff8105d75a>] trace_hardirqs_off_caller+0x4/0x11b
[    4.028943]  RSP <ffff880000000000>
[    4.028943] ---[ end trace f7d78ff4ba82407f ]---
[    4.028943] Kernel panic - not syncing: Fatal exception in interrupt
[    4.026414] hardirqs last  enabled at (48987): [<ffffffff81085593>] rcu_=
note_context_switch+0x188/0x19f
[    4.026414] hardirqs last disabled at (48988): [<ffffffff8123a641>] _raw=
_spin_lock_irq+0x18/0x7f
[    4.026414] softirqs last  enabled at (48564): [<ffffffff81035bad>] __do=
_softirq+0x145/0x170
[    4.026414] softirqs last disabled at (48559): [<ffffffff8123ceac>] call=
_softirq+0x1c/0x30
[    4.026414] Pid: 21, comm: kworker/0:1 Tainted: G      D      3.6.0-rc3-=
00186-gf117e2a #47
[    4.026414] Call Trace:
[    4.026414]  [<ffffffff8105f15d>] ? print_irqtrace_events+0x9e/0xa2
[    4.026414]  [<ffffffff8104d33f>] __might_sleep+0x113/0x118
[    4.026414]  [<ffffffff81239232>] down_read+0x26/0x7b
[    4.026414]  [<ffffffff81061a2d>] ? lock_acquire+0xa6/0xb1
[    4.026414]  [<ffffffff8103c163>] exit_signals+0x21/0x125
[    4.026414]  [<ffffffff81033c5b>] do_exit+0x114/0x772
[    4.026414]  [<ffffffff81031f64>] ? kmsg_dump+0xe5/0xee
[    4.026414]  [<ffffffff81031e9f>] ? kmsg_dump+0x20/0xee
[    4.026414]  [<ffffffff8100c144>] oops_end+0xaa/0xb2
[    4.026414]  [<ffffffff8100c295>] die+0x55/0x60
[    4.026414]  [<ffffffff810097f9>] do_trap+0x115/0x124
[    4.026414]  [<ffffffff8111b282>] ? vsnprintf+0x77/0x433
[    4.026414]  [<ffffffff810099ca>] do_divide_error+0x8d/0x96
[    4.026414]  [<ffffffff810536e7>] ? update_sd_lb_stats+0x2a8/0x484
[    4.026414]  [<ffffffff8105d82d>] ? trace_hardirqs_off_caller+0xd7/0x11b
[    4.026414]  [<ffffffff8111cd1d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[    4.026414]  [<ffffffff8123b424>] ? restore_args+0x30/0x30
[    4.026414]  [<ffffffff8123cc5b>] divide_error+0x1b/0x20
[    4.026414]  [<ffffffff810536e7>] ? update_sd_lb_stats+0x2a8/0x484
[    4.026414]  [<ffffffff810538ef>] find_busiest_group+0x2c/0x1db
[    4.026414]  [<ffffffff81053b69>] load_balance+0xcb/0x5c5
[    4.026414]  [<ffffffff81061a2d>] ? lock_acquire+0xa6/0xb1
[    4.026414]  [<ffffffff81054273>] idle_balance+0x9c/0x111
[    4.026414]  [<ffffffff81239918>] __schedule+0x241/0x4bd
[    4.026414]  [<ffffffff81239c9e>] schedule+0x60/0x62
[    4.026414]  [<ffffffff810429ae>] worker_thread+0x21a/0x24b
[    4.026414]  [<ffffffff81042794>] ? rescuer_thread+0x17d/0x17d
[    4.026414]  [<ffffffff8104600f>] kthread+0x73/0x7b
[    4.026414]  [<ffffffff8123ce44>] kernel_thread_helper+0x4/0x10
[    4.026414]  [<ffffffff8123b3f4>] ? retint_restore_args+0x13/0x13
[    4.026414]  [<ffffffff81045f9c>] ? __init_kthread_worker+0x55/0x55
[    4.026414]  [<ffffffff8123ce40>] ? gs_change+0x13/0x13
[    4.026414] note: kworker/0:1[21] exited with preempt_count 1
[    4.028943] Rebooting in 10 seconds..
--E39vaYmALEf/7YXx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.6.0-rc3-00186-gf117e2a"

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
# CONFIG_KERNEL_LZMA is not set
CONFIG_KERNEL_XZ=y
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
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
CONFIG_GENERIC_IRQ_CHIP=y
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
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_PERF is not set
# CONFIG_CGROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
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
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_SLUB_DEBUG is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_OPROFILE=m
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
# CONFIG_JUMP_LABEL is not set
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
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
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
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_VSMP=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PRIVILEGED_GUEST=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=500
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
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
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
CONFIG_I8K=m
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
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
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_EC_DEBUGFS=m
CONFIG_ACPI_AC=m
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_PROCESSOR is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_DEBUG_FUNC_TRACE is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_SBS is not set
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_BGRT=m
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
# CONFIG_ACPI_APEI_EINJ is not set
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
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
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
# CONFIG_PCIEASPM_DEFAULT is not set
CONFIG_PCIEASPM_POWERSAVE=y
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
# CONFIG_PCI_STUB is not set
# CONFIG_XEN_PCIDEV_FRONTEND is not set
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
# CONFIG_PCI_PRI is not set
CONFIG_PCI_PASID=y
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=m
CONFIG_HOTPLUG_PCI_FAKE=m
# CONFIG_HOTPLUG_PCI_ACPI is not set
CONFIG_HOTPLUG_PCI_CPCI=y
# CONFIG_HOTPLUG_PCI_CPCI_ZT5550 is not set
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=m
CONFIG_HOTPLUG_PCI_SHPC=m
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
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
CONFIG_NET_KEY=m
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
# CONFIG_IP_MULTIPLE_TABLES is not set
CONFIG_IP_ROUTE_MULTIPATH=y
# CONFIG_IP_ROUTE_VERBOSE is not set
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
# CONFIG_IP_PNP_RARP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_NET_IPVTI is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=m
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=m
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_DEFAULT_RENO=y
CONFIG_DEFAULT_TCP_CONG="reno"
CONFIG_IPV6=m
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_INET6_AH is not set
CONFIG_INET6_ESP=m
# CONFIG_INET6_IPCOMP is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
CONFIG_INET6_TUNNEL=m
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_BEET=m
# CONFIG_IPV6_SIT is not set
CONFIG_IPV6_TUNNEL=m
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_LOG=m
# CONFIG_NF_CONNTRACK is not set
CONFIG_NETFILTER_XTABLES=m

#
# Xtables combined modules
#
# CONFIG_NETFILTER_XT_MARK is not set

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_LOG=m
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m

#
# Xtables matches
#
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
# CONFIG_IP_SET is not set
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
CONFIG_IP_VS_DEBUG=y
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
# CONFIG_IP_VS_PROTO_TCP is not set
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
# CONFIG_IP_VS_PROTO_AH is not set
# CONFIG_IP_VS_PROTO_SCTP is not set

#
# IPVS scheduler
#
# CONFIG_IP_VS_RR is not set
CONFIG_IP_VS_WRR=m
# CONFIG_IP_VS_LC is not set
# CONFIG_IP_VS_WLC is not set
# CONFIG_IP_VS_LBLC is not set
CONFIG_IP_VS_LBLCR=m
# CONFIG_IP_VS_DH is not set
# CONFIG_IP_VS_SH is not set
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
CONFIG_IP_NF_IPTABLES=m
# CONFIG_IP_NF_FILTER is not set
# CONFIG_IP_NF_TARGET_ULOG is not set
# CONFIG_IP_NF_MANGLE is not set
# CONFIG_IP_NF_RAW is not set

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV6 is not set
# CONFIG_IP6_NF_IPTABLES is not set
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
# CONFIG_BRIDGE_EBT_T_NAT is not set
CONFIG_BRIDGE_EBT_802_3=m
# CONFIG_BRIDGE_EBT_AMONG is not set
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
# CONFIG_BRIDGE_EBT_LIMIT is not set
# CONFIG_BRIDGE_EBT_MARK is not set
CONFIG_BRIDGE_EBT_PKTTYPE=m
# CONFIG_BRIDGE_EBT_STP is not set
# CONFIG_BRIDGE_EBT_VLAN is not set
CONFIG_BRIDGE_EBT_ARPREPLY=m
# CONFIG_BRIDGE_EBT_DNAT is not set
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
# CONFIG_BRIDGE_EBT_SNAT is not set
CONFIG_BRIDGE_EBT_LOG=m
# CONFIG_BRIDGE_EBT_ULOG is not set
# CONFIG_BRIDGE_EBT_NFLOG is not set
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
CONFIG_ATM_CLIP_NO_ICMP=y
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
# CONFIG_ATM_BR2684 is not set
# CONFIG_L2TP is not set
CONFIG_STP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=m
CONFIG_LLC=m
# CONFIG_LLC2 is not set
CONFIG_IPX=m
# CONFIG_IPX_INTERN is not set
# CONFIG_ATALK is not set
# CONFIG_PHONET is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
CONFIG_NET_SCH_SFB=m
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
# CONFIG_NET_SCH_NETEM is not set
CONFIG_NET_SCH_DRR=m
# CONFIG_NET_SCH_MQPRIO is not set
# CONFIG_NET_SCH_CHOKE is not set
CONFIG_NET_SCH_QFQ=m
# CONFIG_NET_SCH_CODEL is not set
CONFIG_NET_SCH_FQ_CODEL=m
CONFIG_NET_SCH_INGRESS=m
CONFIG_NET_SCH_PLUG=m

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
CONFIG_NET_CLS_ROUTE4=m
# CONFIG_NET_CLS_FW is not set
CONFIG_NET_CLS_U32=m
# CONFIG_CLS_U32_PERF is not set
CONFIG_CLS_U32_MARK=y
# CONFIG_NET_CLS_RSVP is not set
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
# CONFIG_NET_EMATCH_NBYTE is not set
CONFIG_NET_EMATCH_U32=m
# CONFIG_NET_EMATCH_META is not set
CONFIG_NET_EMATCH_TEXT=m
# CONFIG_NET_EMATCH_CANID is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
# CONFIG_NET_ACT_IPT is not set
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
# CONFIG_NET_ACT_CSUM is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_BATMAN_ADV=m
CONFIG_BATMAN_ADV_BLA=y
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=m
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_BQL=y
CONFIG_BPF_JIT=y

#
# Network testing
#
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
CONFIG_CAN=m
# CONFIG_CAN_RAW is not set
CONFIG_CAN_BCM=m
# CONFIG_CAN_GW is not set

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
# CONFIG_CAN_SLCAN is not set
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
CONFIG_IRNET=m
# CONFIG_IRCOMM is not set
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
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
# CONFIG_NSC_FIR is not set
CONFIG_WINBOND_FIR=m
# CONFIG_SMC_IRCC_FIR is not set
# CONFIG_VIA_FIR is not set
CONFIG_BT=m
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTSDIO=m
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIVHCI is not set
# CONFIG_BT_MRVL is not set
# CONFIG_BT_WILINK is not set
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_CFG80211=m
CONFIG_NL80211_TESTMODE=y
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
CONFIG_CFG80211_REG_DEBUG=y
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
# CONFIG_CFG80211_DEFAULT_PS is not set
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_LIB80211=m
CONFIG_LIB80211_DEBUG=y
# CONFIG_MAC80211 is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_REGULATOR=m
CONFIG_NET_9P=m
CONFIG_NET_9P_DEBUG=y
# CONFIG_CAIF is not set
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
CONFIG_FW_LOADER=m
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
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
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_XEN_BLKDEV_FRONTEND=y
# CONFIG_BLK_DEV_HD is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_PHANTOM=m
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_CS5535_MFGPT is not set
# CONFIG_HP_ILO is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_PCH_PHUB is not set

#
# EEPROM support
#
CONFIG_EEPROM_93CX6=m
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=m

#
# Altera FPGA firmware download module
#
CONFIG_HAVE_IDE=y
CONFIG_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=m
# CONFIG_IDE_GD_ATA is not set
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
CONFIG_BLK_DEV_IDEPNP=m
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_BLK_DEV_OFFBOARD=y
CONFIG_BLK_DEV_GENERIC=m
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=m
CONFIG_BLK_DEV_ALI15X3=m
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
CONFIG_BLK_DEV_TRIFLEX=m
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT366 is not set
CONFIG_BLK_DEV_JMICRON=m
CONFIG_BLK_DEV_SC1200=m
CONFIG_BLK_DEV_PIIX=m
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
CONFIG_BLK_DEV_IT821X=m
# CONFIG_BLK_DEV_NS87415 is not set
CONFIG_BLK_DEV_PDC202XX_OLD=m
CONFIG_BLK_DEV_PDC202XX_NEW=m
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
CONFIG_BLK_DEV_VIA82CXXX=m
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=m
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=m
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=m
# CONFIG_SCSI_SRP_TGT_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
CONFIG_ISCSI_BOOT_SYSFS=m
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
CONFIG_SCSI_BNX2_ISCSI=m
# CONFIG_SCSI_BNX2X_FCOE is not set
CONFIG_BE2ISCSI=m
CONFIG_BLK_DEV_3W_XXXX_RAID=m
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
CONFIG_SCSI_3W_SAS=m
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
CONFIG_SCSI_AIC7XXX_OLD=m
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
# CONFIG_AIC79XX_BUILD_FIRMWARE is not set
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC94XX is not set
CONFIG_SCSI_MVSAS=m
# CONFIG_SCSI_MVSAS_DEBUG is not set
# CONFIG_SCSI_MVSAS_TASKLET is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
CONFIG_SCSI_ARCMSR=m
CONFIG_MEGARAID_NEWGEN=y
# CONFIG_MEGARAID_MM is not set
CONFIG_MEGARAID_LEGACY=m
CONFIG_MEGARAID_SAS=m
CONFIG_SCSI_MPT2SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS_LOGGING=y
CONFIG_SCSI_UFSHCD=m
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
CONFIG_VMWARE_PVSCSI=m
CONFIG_HYPERV_STORAGE=m
CONFIG_LIBFC=m
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
CONFIG_SCSI_DMX3191D=m
CONFIG_SCSI_EATA=m
CONFIG_SCSI_EATA_TAGGED_QUEUE=y
# CONFIG_SCSI_EATA_LINKED_COMMANDS is not set
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=m
# CONFIG_SCSI_GDTH is not set
CONFIG_SCSI_ISCI=m
CONFIG_SCSI_IPS=m
CONFIG_SCSI_INITIO=m
CONFIG_SCSI_INIA100=m
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
CONFIG_SCSI_IPR=m
CONFIG_SCSI_IPR_TRACE=y
CONFIG_SCSI_IPR_DUMP=y
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=m
# CONFIG_TCM_QLA2XXX is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
CONFIG_SCSI_SRP=m
CONFIG_SCSI_BFA_FC=m
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
CONFIG_SATA_ACARD_AHCI=m
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=m
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
# CONFIG_ATA_PIIX is not set
CONFIG_SATA_MV=m
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
CONFIG_SATA_SIS=m
# CONFIG_SATA_SVW is not set
CONFIG_SATA_ULI=m
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
CONFIG_PATA_ALI=m
# CONFIG_PATA_AMD is not set
CONFIG_PATA_ARTOP=m
# CONFIG_PATA_ATIIXP is not set
CONFIG_PATA_ATP867X=m
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_EFAR is not set
CONFIG_PATA_HPT366=m
# CONFIG_PATA_HPT37X is not set
CONFIG_PATA_HPT3X2N=m
CONFIG_PATA_HPT3X3=m
# CONFIG_PATA_HPT3X3_DMA is not set
# CONFIG_PATA_IT821X is not set
CONFIG_PATA_JMICRON=m
CONFIG_PATA_MARVELL=m
# CONFIG_PATA_NETCELL is not set
CONFIG_PATA_NINJA32=m
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
CONFIG_PATA_PDC2027X=m
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
CONFIG_PATA_SCH=m
CONFIG_PATA_SERVERWORKS=m
# CONFIG_PATA_SIL680 is not set
CONFIG_PATA_SIS=m
CONFIG_PATA_TRIFLEX=m
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_NS87410=m
# CONFIG_PATA_PLATFORM is not set
CONFIG_PATA_RZ1000=m

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
# CONFIG_ATA_GENERIC is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
# CONFIG_DM_CRYPT is not set
# CONFIG_DM_SNAPSHOT is not set
# CONFIG_DM_MIRROR is not set
# CONFIG_DM_RAID is not set
# CONFIG_DM_ZERO is not set
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
# CONFIG_DM_MULTIPATH_ST is not set
CONFIG_DM_UEVENT=y
CONFIG_TARGET_CORE=m
# CONFIG_TCM_IBLOCK is not set
CONFIG_TCM_FILEIO=m
# CONFIG_TCM_PSCSI is not set
# CONFIG_LOOPBACK_TARGET is not set
# CONFIG_TCM_FC is not set
CONFIG_ISCSI_TARGET=m
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
CONFIG_FUSION_FC=m
# CONFIG_FUSION_SAS is not set
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_CTL is not set
# CONFIG_FUSION_LAN is not set
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
# CONFIG_FIREWIRE_NOSY is not set
CONFIG_I2O=m
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
# CONFIG_I2O_EXT_ADAPTEC_DMA64 is not set
# CONFIG_I2O_CONFIG is not set
CONFIG_I2O_BUS=m
# CONFIG_I2O_BLOCK is not set
# CONFIG_I2O_SCSI is not set
# CONFIG_I2O_PROC is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
CONFIG_DUMMY=m
CONFIG_EQUALIZER=m
CONFIG_NET_FC=y
CONFIG_MII=m
CONFIG_IFB=m
CONFIG_NETCONSOLE=m
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_TUN is not set
CONFIG_VETH=m
CONFIG_ARCNET=m
CONFIG_ARCNET_1201=m
CONFIG_ARCNET_1051=m
CONFIG_ARCNET_RAW=m
CONFIG_ARCNET_CAP=m
# CONFIG_ARCNET_COM90xx is not set
CONFIG_ARCNET_COM90xxIO=m
CONFIG_ARCNET_RIM_I=m
CONFIG_ARCNET_COM20020=m
CONFIG_ARCNET_COM20020_PCI=m
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#
CONFIG_ETHERNET=y
CONFIG_MDIO=m
CONFIG_NET_VENDOR_3COM=y
# CONFIG_VORTEX is not set
CONFIG_TYPHOON=m
CONFIG_NET_VENDOR_ADAPTEC=y
CONFIG_ADAPTEC_STARFIRE=m
# CONFIG_NET_VENDOR_ALTEON is not set
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
CONFIG_ATL1=m
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=m
CONFIG_CNIC=m
CONFIG_TIGON3=m
CONFIG_BNX2X=m
# CONFIG_NET_VENDOR_BROCADE is not set
CONFIG_NET_CALXEDA_XGMAC=m
# CONFIG_NET_VENDOR_CHELSIO is not set
# CONFIG_NET_VENDOR_CISCO is not set
# CONFIG_DNET is not set
# CONFIG_NET_VENDOR_DEC is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=m
# CONFIG_NET_VENDOR_EXAR is not set
# CONFIG_NET_VENDOR_HP is not set
# CONFIG_NET_VENDOR_INTEL is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_SKGE=m
CONFIG_SKGE_DEBUG=y
# CONFIG_SKGE_GENESIS is not set
CONFIG_SKY2=m
# CONFIG_SKY2_DEBUG is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
CONFIG_MLX4_CORE=m
# CONFIG_MLX4_DEBUG is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MYRI is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
CONFIG_NATSEMI=m
CONFIG_NS83820=m
# CONFIG_NET_VENDOR_8390 is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
# CONFIG_NET_VENDOR_OKI is not set
# CONFIG_ETHOC is not set
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
# CONFIG_NET_VENDOR_REALTEK is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
# CONFIG_NET_VENDOR_SIS is not set
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_EPIC100 is not set
CONFIG_SMSC9420=m
CONFIG_NET_VENDOR_STMICRO=y
CONFIG_STMMAC_ETH=m
CONFIG_STMMAC_PLATFORM=y
CONFIG_STMMAC_DEBUG_FS=y
# CONFIG_STMMAC_DA is not set
CONFIG_STMMAC_RING=y
# CONFIG_STMMAC_CHAINED is not set
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
CONFIG_TLAN=m
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
# CONFIG_FDDI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
CONFIG_AMD_PHY=m
# CONFIG_MARVELL_PHY is not set
CONFIG_DAVICOM_PHY=m
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
# CONFIG_BCM87XX_PHY is not set
CONFIG_ICPLUS_PHY=m
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
CONFIG_MICREL_PHY=m
# CONFIG_MDIO_BITBANG is not set
CONFIG_PPP=m
CONFIG_PPP_BSDCOMP=m
# CONFIG_PPP_DEFLATE is not set
# CONFIG_PPP_FILTER is not set
# CONFIG_PPPOATM is not set
# CONFIG_PPP_ASYNC is not set
CONFIG_PPP_SYNC_TTY=m
CONFIG_SLIP=m
CONFIG_SLHC=m
CONFIG_SLIP_COMPRESSED=y
# CONFIG_SLIP_SMART is not set
# CONFIG_SLIP_MODE_SLIP6 is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
CONFIG_WAN=y
# CONFIG_HDLC is not set
# CONFIG_DLCI is not set
# CONFIG_SBNI is not set
CONFIG_XEN_NETDEV_FRONTEND=m
CONFIG_VMXNET3=m
CONFIG_HYPERV_NET=m
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_OMAP4 is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=m
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=m
CONFIG_JOYSTICK_GRIP=m
CONFIG_JOYSTICK_GRIP_MP=m
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
CONFIG_JOYSTICK_SIDEWINDER=m
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=m
# CONFIG_JOYSTICK_STINGER is not set
CONFIG_JOYSTICK_TWIDJOY=m
# CONFIG_JOYSTICK_ZHENHUA is not set
CONFIG_JOYSTICK_JOYDUMP=m
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_AD7879=m
CONFIG_TOUCHSCREEN_CYTTSP_CORE=m
CONFIG_TOUCHSCREEN_DYNAPRO=m
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=m
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_MTOUCH=m
CONFIG_TOUCHSCREEN_INEXIO=m
CONFIG_TOUCHSCREEN_MK712=m
CONFIG_TOUCHSCREEN_PENMOUNT=m
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
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
CONFIG_SERIO_RAW=m
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
CONFIG_GAMEPORT_EMU10K1=m
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
CONFIG_MOXA_INTELLIO=m
CONFIG_MOXA_SMARTIO=m
CONFIG_SYNCLINK=m
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
CONFIG_ISI=m
# CONFIG_N_HDLC is not set
CONFIG_TRACE_ROUTER=m
CONFIG_TRACE_SINK=m
# CONFIG_DEVKMEM is not set
# CONFIG_STALDRV is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
# CONFIG_SERIAL_8250_PCI is not set
CONFIG_SERIAL_8250_PNP=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
CONFIG_SERIAL_TIMBERDALE=m
CONFIG_SERIAL_ALTERA_JTAGUART=m
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
CONFIG_TTY_PRINTK=y
# CONFIG_HVC_XEN is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_R3964=m
# CONFIG_APPLICOM is not set
CONFIG_MWAVE=m
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=m
# CONFIG_TCG_TIS is not set
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set
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
CONFIG_GPIOLIB=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_GENERIC=m

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=m
CONFIG_GPIO_IT8761E=m
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set

#
# I2C GPIO expanders:
#

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_CS5535 is not set
CONFIG_GPIO_BT8XX=m
# CONFIG_GPIO_AMD8111 is not set
CONFIG_GPIO_LANGWELL=y
# CONFIG_GPIO_PCH is not set
CONFIG_GPIO_ML_IOH=m
CONFIG_GPIO_RDC321X=m

#
# SPI GPIO expanders:
#

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
CONFIG_W1_MASTER_DS1WM=m
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=m
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=m
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
CONFIG_TEST_POWER=m
CONFIG_BATTERY_DS2760=m
CONFIG_BATTERY_DS2780=m
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_BQ27x00=m
CONFIG_BATTERY_BQ27X00_PLATFORM=y
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MANAGER is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_K10TEMP=m
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_F71805F=m
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_SHT15=m
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83627HF=m
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_APPLESMC=m

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_THERMAL=m
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_ACQUIRE_WDT=m
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
# CONFIG_SP5100_TCO is not set
CONFIG_SC520_WDT=m
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
CONFIG_IE6XX_WDT=m
CONFIG_ITCO_WDT=m
# CONFIG_ITCO_VENDOR_SUPPORT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=m
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
CONFIG_CPU5_WDT=m
# CONFIG_SMSC_SCH311X_WDT is not set
CONFIG_SMSC37B787_WDT=m
CONFIG_VIA_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83697HF_WDT=m
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
CONFIG_SBC_EPX_C3_WATCHDOG=m
# CONFIG_XEN_WDT is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
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
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=m
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_CS5535=m
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_LPC_SCH=m
CONFIG_LPC_ICH=m
CONFIG_MFD_RDC321X=m
CONFIG_MFD_JANZ_CMODIO=m
# CONFIG_MFD_VX855 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=m
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_GPIO=m
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
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
# CONFIG_FB is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=m
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=m
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=m
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=m

#
# Special HID drivers
#
CONFIG_HID_APPLE=m
CONFIG_HID_ELECOM=m
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_HYPERV_MOUSE is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=m
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_OTG_BLACKLIST_HUB=y
# CONFIG_USB_CHIPIDEA is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# USB Physical Layer drivers
#
CONFIG_USB_GADGET=m
CONFIG_USB_GADGET_DEBUG=y
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_R8A66597=m
# CONFIG_USB_MV_UDC is not set
# CONFIG_USB_M66592 is not set
# CONFIG_USB_AMD5536UDC is not set
CONFIG_USB_NET2272=m
# CONFIG_USB_NET2272_DMA is not set
CONFIG_USB_NET2280=m
CONFIG_USB_GOKU=m
CONFIG_USB_EG20T=m
CONFIG_USB_GADGET_DUALSPEED=y
# CONFIG_USB_ZERO is not set
CONFIG_USB_ETH=m
# CONFIG_USB_ETH_RNDIS is not set
# CONFIG_USB_ETH_EEM is not set
CONFIG_USB_G_NCM=m
CONFIG_USB_FILE_STORAGE=m
CONFIG_USB_FILE_STORAGE_TEST=y
CONFIG_USB_MASS_STORAGE=m
# CONFIG_USB_GADGET_TARGET is not set
# CONFIG_USB_G_SERIAL is not set
CONFIG_USB_G_PRINTER=m
CONFIG_USB_CDC_COMPOSITE=m
# CONFIG_USB_G_ACM_MS is not set
CONFIG_USB_G_MULTI=m
CONFIG_USB_G_MULTI_RNDIS=y
# CONFIG_USB_G_MULTI_CDC is not set
CONFIG_USB_G_HID=m
CONFIG_USB_G_DBGP=m
CONFIG_USB_G_DBGP_PRINTK=y
# CONFIG_USB_G_DBGP_SERIAL is not set

#
# OTG and related infrastructure
#
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_NOP_USB_XCEIV is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
CONFIG_SDIO_UART=m
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_CB710 is not set
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_CLEVO_MAIL=m
CONFIG_LEDS_REGULATOR=m
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=m
CONFIG_LEDS_OT200=m
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGER_TIMER=m
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_ACCESSIBILITY=y
CONFIG_INFINIBAND=m
# CONFIG_INFINIBAND_USER_MAD is not set
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
# CONFIG_INFINIBAND_QIB is not set
CONFIG_INFINIBAND_AMSO1100=m
CONFIG_INFINIBAND_AMSO1100_DEBUG=y
CONFIG_MLX4_INFINIBAND=m
# CONFIG_INFINIBAND_NES is not set
CONFIG_INFINIBAND_OCRDMA=m
# CONFIG_INFINIBAND_IPOIB is not set
CONFIG_INFINIBAND_SRP=m
# CONFIG_INFINIBAND_SRPT is not set
CONFIG_INFINIBAND_ISER=m
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=m
# CONFIG_EDAC_E752X is not set
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=m

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=m
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_RP5C01=m
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
CONFIG_UIO=m
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
CONFIG_UIO_NETX=m

#
# Virtio drivers
#
# CONFIG_VIRTIO_BALLOON is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=m
# CONFIG_HYPERV_UTILS is not set

#
# Xen driver support
#
CONFIG_XEN_BALLOON=y
# CONFIG_XEN_SCRUB_PAGES is not set
# CONFIG_XEN_DEV_EVTCHN is not set
# CONFIG_XEN_BACKEND is not set
# CONFIG_XENFS is not set
# CONFIG_XEN_SYS_HYPERVISOR is not set
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_GNTDEV is not set
# CONFIG_XEN_GRANT_DEV_ALLOC is not set
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_PRIVCMD=m
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
# CONFIG_VIRT_DRIVERS is not set
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
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
# CONFIG_PWM is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=m
CONFIG_DELL_RBU=m
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=m
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=m
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=m
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=m
CONFIG_EXT4_FS_XATTR=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=m
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=m
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=m
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=m
CONFIG_OCFS2_FS=m
# CONFIG_OCFS2_FS_O2CB is not set
# CONFIG_OCFS2_FS_STATS is not set
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
CONFIG_OCFS2_DEBUG_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=m
CONFIG_QFMT_V1=m
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=m
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=m
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
# CONFIG_JOLIET is not set
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_HFSPLUS_FS is not set
CONFIG_CRAMFS=m
# CONFIG_SQUASHFS is not set
CONFIG_VXFS_FS=m
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
CONFIG_QNX6FS_FS=m
CONFIG_QNX6FS_DEBUG=y
CONFIG_ROMFS_FS=m
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_RAM is not set
CONFIG_SYSV_FS=m
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_CIFS=m
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_XATTR=y
# CONFIG_CIFS_POSIX is not set
CONFIG_CIFS_DEBUG2=y
CONFIG_CIFS_FSCACHE=y
CONFIG_NCP_FS=m
# CONFIG_NCPFS_PACKET_SIGNING is not set
# CONFIG_NCPFS_IOCTL_LOCKING is not set
# CONFIG_NCPFS_STRONG is not set
CONFIG_NCPFS_NFS_NS=y
CONFIG_NCPFS_OS2_NS=y
# CONFIG_NCPFS_SMALLDOS is not set
CONFIG_NCPFS_NLS=y
# CONFIG_NCPFS_EXTRAS is not set
CONFIG_CODA_FS=m
CONFIG_9P_FS=m
# CONFIG_9P_FS_POSIX_ACL is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=m
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=m
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=m
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=m
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
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
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
# CONFIG_DEBUG_OBJECTS_FREE is not set
CONFIG_DEBUG_OBJECTS_TIMERS=y
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_STATS=y
# CONFIG_DEBUG_PREEMPT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
# CONFIG_PROVE_RCU is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_LIST=y
# CONFIG_TEST_LIST_SORT is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_LKDTM=m
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_RING_BUFFER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_FIREWIRE_OHCI_REMOTE_DMA=y
# CONFIG_BUILD_DOCSRC is not set
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DMA_API_DEBUG=y
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_KSTRTOX=m
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=m

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=m
CONFIG_CRYPTO_ALGAPI2=m
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=m
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER2=m
CONFIG_CRYPTO_HASH=m
CONFIG_CRYPTO_HASH2=m
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=m
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=m
CONFIG_CRYPTO_MANAGER=m
CONFIG_CRYPTO_MANAGER2=m
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=m
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=m
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER_X86=m
CONFIG_CRYPTO_GLUE_HELPER_X86=m

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=m
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_INTEL=m
# CONFIG_CRYPTO_GHASH is not set
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=m
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=m
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=m
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=m
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
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
CONFIG_LZO_COMPRESS=m
CONFIG_LZO_DECOMPRESS=m
CONFIG_XZ_DEC=m
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set

--E39vaYmALEf/7YXx--
