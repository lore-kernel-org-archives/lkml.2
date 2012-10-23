Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941Ab2JWPFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 11:05:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:26379 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757032Ab2JWPFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 11:05:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,635,1344236400"; 
   d="scan'208";a="231154379"
Date: Tue, 23 Oct 2012 23:05:35 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Christoph Lameter <cl@linux.com>
Cc: Glauber Costa <glommer@parallels.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [CPU hotplug, __flush_cpu_slab] BUG: unable to handle kernel paging
 request at c19d50e4
Message-ID: <20121023150535.GC23850@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Christoph,

When doing CPU hotplug tests, I got this oops:

[   10.826675] CPU1 attaching NULL sched-domain.
[   10.827421] CPU0 attaching NULL sched-domain.
[   10.831165] BUG: unable to handle kernel paging request at c19d50e4
[   10.832068] IP: [<c11e2149>] __flush_cpu_slab+0x12/0x6e
[   10.832101] *pde = 0231a067 *pte = 019d5162 
[   10.832101] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   10.832101] Modules linked in:
[   10.832101] Pid: 459, comm: reboot Not tainted 3.7.0-rc1-00016-gb59d450 #44 Bochs Bochs
[   10.832101] EIP: 0060:[<c11e2149>] EFLAGS: 00010046 CPU: 0
[   10.832101] EIP is at __flush_cpu_slab+0x12/0x6e
[   10.832101] EAX: c19d50e4 EBX: c19d50e4 ECX: 00000006 EDX: 00000001
[   10.832101] ESI: 00000246 EDI: 00000001 EBP: c734ddf0 ESP: c734ddec
[   10.832101]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   10.832101] CR0: 8005003b CR2: c19d50e4 CR3: 0735b000 CR4: 00000690
[   10.832101] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   10.832101] DR6: ffff0ff0 DR7: 00000400
[   10.832101] Process reboot (pid: 459, ti=c734c000 task=c7380000 task.ti=c734c000)
[   10.832101] Stack:
[   10.832101]  c19d50e4 c734de04 c155b2ca c1962664 00000000 c19625ec c734de20 c15757a7
[   10.832101]  00000001 00000017 00000001 00000000 00000010 c734de30 c10990e8 fffffff6
[   10.832101]  00000000 c734de40 c105dc62 ffffffff 00000000 c734de4c c105dcd3 00000000
[   10.832101] Call Trace:
[   10.832101]  [<c155b2ca>] slab_cpuup_callback+0x9a/0x158
[   10.832101]  [<c15757a7>] notifier_call_chain+0x46/0x91
[   10.832101]  [<c10990e8>] __raw_notifier_call_chain+0x21/0x31
[   10.832101]  [<c105dc62>] __cpu_notify+0x28/0x79
[   10.832101]  [<c105dcd3>] cpu_notify+0x20/0x30
[   10.832101]  [<c105dcfe>] cpu_notify_nofail+0x1b/0x4d
[   10.832101]  [<c15343bd>] _cpu_down+0x2a2/0x426
[   10.832101]  [<c1560e1a>] ? printk+0x57/0x6a
[   10.832101]  [<c105e47a>] disable_nonboot_cpus+0xc9/0x20c
[   10.832101]  [<c107d0b6>] kernel_restart+0x31/0xb9
[   10.832101]  [<c107d30d>] sys_reboot+0x1a2/0x2f4
[   10.832101]  [<c1158e05>] ? time_hardirqs_off+0x47/0x5a
[   10.832101]  [<c10ade85>] ? local_clock+0x78/0xc7
[   10.832101]  [<c10e1a3f>] ? trace_hardirqs_off_caller+0x34/0x168
[   10.832101]  [<c10e1b9a>] ? trace_hardirqs_off+0x27/0x37
[   10.832101]  [<c10ade85>] ? local_clock+0x78/0xc7
[   10.832101]  [<c10e1ce1>] ? lock_release_holdtime+0xca/0xdd
[   10.832101]  [<c10e8142>] ? lock_release+0x39d/0x46e
[   10.832101]  [<c10973f9>] ? up_read+0x37/0x82
[   10.832101]  [<c157562e>] ? __do_page_fault+0x87d/0x985
[   10.832101]  [<c10e8142>] ? lock_release+0x39d/0x46e
[   10.832101]  [<c156f959>] ? restore_all+0xf/0xf
[   10.832101]  [<c12f45b4>] ? trace_hardirqs_on_thunk+0xc/0x10
[   10.832101]  [<c156f959>] ? restore_all+0xf/0xf
[   10.832101]  [<c1574947>] ? arch_init_optprobes+0xb5/0xb5
[   10.832101]  [<c156f959>] ? restore_all+0xf/0xf
[   10.832101]  [<c1574947>] ? arch_init_optprobes+0xb5/0xb5
[   10.832101]  [<c10e89b9>] ? trace_hardirqs_on_caller+0x291/0x390
[   10.832101]  [<c12f45b4>] ? trace_hardirqs_on_thunk+0xc/0x10
[   10.832101]  [<c157b92a>] sysenter_do_call+0x12/0x3c
[   10.832101] Code: 15 74 6c 1c c2 00 ff 43 04 c7 43 08 00 00 00 00 c7 03 00 00 00 00 5b 5d c3 83 05 38 7b 1c c2 01 55 83 15 3c 7b 1c c2 00 89 e5 53 <8b> 08 89 c3 03 0c 95 b0 78 96 c1 74 4c 83 05 40 7b 1c c2 01 89
[   10.832101] EIP: [<c11e2149>] __flush_cpu_slab+0x12/0x6e SS:ESP 0068:c734ddec
[   10.832101] CR2: 00000000c19d50e4

And it's bisected down to:

commit 911f72e18af709c7ea17f5f2aae29eaf4157bc60
Author: Christoph Lameter <cl@linux.com>
Date:   Fri Oct 19 14:51:48 2012 +0000

    CK2 [03/15] slub: Use a statically allocated kmem_cache boot structure for bootstrap

Thanks,
Fengguang

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-bay-3447-2012-10-22-20-17-08-3.7.0-rc1-00016-gb59d450-44"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.7.0-rc1-00016-gb59d450 (kbuild@lkp-mb01) (gc=
c version 4.7.1 (GCC) ) #44 SMP Mon Oct 22 20:13:39 CST 2012
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
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
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
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
[c00fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]
[    0.000000] Base memory trampoline at [c008f000] 8f000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x027bd0=
00-0x027fffff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128436(97%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC=
 00000001)
[    0.000000] ACPI: DSDT 0fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL=
 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: APIC 0ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC=
 00000001)
[    0.000000] ACPI: HPET 0ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC=
 00000001)
[    0.000000] ACPI: SSDT 0ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL=
 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1b43fa1, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000] free_area_init_node: node 0, pgdat c1960260, node_mem_map cd=
cbf280
[    0.000000]   DMA zone: 40 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3931 pages, LIFO batch:0
[    0.000000]   Normal zone: 600 pages used for memmap
[    0.000000]   Normal zone: 60838 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
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
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 333 pages/cpu @cda25000 s1341248 r0 d22720 =
u1363968
[    0.000000] pcpu-alloc: s1341248 r0 d22720 u1363968 alloc=3D333*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:db6bfa1, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr da27700
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64769
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 branch=3Dglommer-memcg/slab-common/kmalloc log_buf_len=3D8=
M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_printk sysrq_alway=
s_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dt=
ty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3Dvmlinuz-2012-10-22-20-16-08-gl=
ommer-memcg:slab-common:kmalloc:b59d450-b59d450-i386-randconfig-m032-9-bay =
BOOT_IMAGE=3Dkernel-tests/kernels/i386-randconfig-m032/b59d450/vmlinuz-3.7.=
0-rc1-00016-gb59d450
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 202904k/262136k available (5617k kernel code, 58732k=
 reserved, 4018k data, 1900k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffe6d000 - 0xfffff000   (1608 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff7fe000   ( 752 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc196a000 - 0xc1b45000   (1900 kB)
[    0.000000]       .data : 0xc157c708 - 0xc19690e0   (4018 kB)
[    0.000000]       .text : 0xc1000000 - 0xc157c708   (5617 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D2, =
Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3Dcd408000 soft=3Dcd40a000
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
[    0.000000]  memory used by lock dependency info: 3823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2992.556 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 5985.11 Bogo=
MIPS (lpj=3D2992556)
[    0.003424] pid_max: default: 32768 minimum: 301
[    0.005456] Mount-cache hash table entries: 512
[    0.012066] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.012066] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.012066] tlb_flushall_shift: 6
[    0.014719] debug: unmapping init [mem 0xc1b45000-0xc1b46fff]
[    0.018433] ACPI: Core revision 20120913
[    0.028616] ftrace: allocating 14844 entries in 29 pages
[    0.039474] Getting VERSION: 50014
[    0.040024] Getting VERSION: 50014
[    0.041019] Getting ID: 0
[    0.041408] Getting ID: f000000
[    0.042026] Getting LVT0: 8700
[    0.043015] Getting LVT1: 8400
[    0.043464] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.044099] enabled ExtINT on CPU#0
[    0.048451] ENABLING IO-APIC IRQs
[    0.049016] init IO_APIC IRQs
[    0.050013]  apic 2 pin 0 not connected
[    0.050607] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.051000] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.051000] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.051059] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.052036] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.053043] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.054035] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.055039] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.056036] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.057035] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.058035] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.059035] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.060035] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.062009] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.063035] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.064032]  apic 2 pin 16 not connected
[    0.065000]  apic 2 pin 17 not connected
[    0.065000]  apic 2 pin 18 not connected
[    0.065019]  apic 2 pin 19 not connected
[    0.065578]  apic 2 pin 20 not connected
[    0.066015]  apic 2 pin 21 not connected
[    0.067007]  apic 2 pin 22 not connected
[    0.067567]  apic 2 pin 23 not connected
[    0.068164] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.069013] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.071007] Using local APIC timer interrupts.
[    0.071007] calibrating APIC timer ...
[    0.073000] ... lapic delta =3D 6248765
[    0.073000] ... PM-Timer delta =3D 357883
[    0.073000] ... PM-Timer result ok
[    0.073000] ..... delta 6248765
[    0.073000] ..... mult: 268382413
[    0.073000] ..... calibration result: 999802
[    0.073000] ..... CPU clock speed is 2991.0901 MHz.
[    0.073000] ..... host bus clock speed is 999.0802 MHz.
[    0.073114] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.076804] Testing tracer nop: PASSED
[    0.079753] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.082300] SMP alternatives: lockdep: fixing up alternatives
[    0.083134] CPU 1 irqstacks, hard=3Dcd4b8000 soft=3Dcd4ba000
[    0.084007] smpboot: Booting Node   0, Processors  #1 OK
[    0.003000] Initializing CPU#1
[    0.003000] kvm-clock: cpu 1, msr 0:dcb8fa1, secondary cpu clock
[    0.003000] masked ExtINT on CPU#1
[    0.115197] Brought up 2 CPUs
[    0.116016] ----------------
[    0.116431] | NMI testsuite:
[    0.117005] --------------------
[    0.117460]   remote IPI:[    0.115040] KVM setup async PF for cpu 1
[    0.115040] kvm-stealtime: cpu 1, msr db74700
  ok  |
[    0.133199]    local IPI:  ok  |
[    0.141017] --------------------
[    0.141477] Good, all   2 testcases passed! |
[    0.142006] ---------------------------------
[    0.142617] smpboot: Total of 2 processors activated (11970.22 BogoMIPS)
[    0.150141] CPU0 attaching sched-domain:
[    0.151022]  domain 0: span 0-1 level CPU
[    0.152009]   groups: 0 (cpu_power =3D 1023) 1 (cpu_power =3D 1023)
[    0.153364] CPU1 attaching sched-domain:
[    0.154010]  domain 0: span 0-1 level CPU
[    0.155008]   groups: 1 (cpu_power =3D 1023) 0 (cpu_power =3D 1023)
[    0.160014] devtmpfs: initialized
[    0.162434] gcov: version magic: 0x3430372a
[    0.169363] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.170120] RTC time: 12:16:53, date: 10/22/12
[    0.171478] NET: Registered protocol family 16
[    0.174519] ACPI: bus type pci registered
[    0.176023] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=3D0
[    0.177006] PCI: Using configuration type 1 for base access
[    0.184115] bio: create slab <bio-0> at 0
[    0.185297] ACPI: Added _OSI(Module Device)
[    0.186010] ACPI: Added _OSI(Processor Device)
[    0.187009] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.188009] ACPI: Added _OSI(Processor Aggregator Device)
[    0.196160] ACPI: EC: Look up EC in DSDT
[    0.211981] ACPI: Interpreter enabled
[    0.212005] ACPI: (supports S0 S4 S5)
[    0.213244] ACPI: Using IOAPIC for interrupt routing
[    0.239070] PCI: Ignoring host bridge windows from ACPI; if necessary, u=
se "pci=3Duse_crs" and report a bug
[    0.241112] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.242077] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] =
(ignored)
[    0.243007] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] =
(ignored)
[    0.245008] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x00=
0bffff] (ignored)
[    0.246007] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfe=
bfffff] (ignored)
[    0.247008] PCI: root bus 00: using default resources
[    0.248057] pci_root PNP0A03:00: fail to add MMCONFIG information, can't=
 access extended PCI configuration space under this bridge.
[    0.251121] PCI host bridge to bus 0000:00
[    0.252000] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.252008] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.253008] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffff=
f]
[    0.254030] pci_bus 0000:00: scanning bus
[    0.255053] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.256022] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.257382] pci 0000:00:00.0: calling pci_fixed_bar_fixup+0x0/0x145
[    0.259136] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.261107] pci 0000:00:01.0: calling pci_fixed_bar_fixup+0x0/0x145
[    0.262145] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.264903] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    0.266402] pci 0000:00:01.1: calling pci_fixed_bar_fixup+0x0/0x145
[    0.267158] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.268022] pci 0000:00:01.3: calling acpi_pm_check_blacklist+0x0/0x6a
[    0.270231] pci 0000:00:01.3: calling quirk_piix4_acpi+0x0/0x200
[    0.271026] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.272024] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.273074] pci 0000:00:01.3: calling pci_fixup_piix4_acpi+0x0/0x1d
[    0.274008] pci 0000:00:01.3: calling pci_fixed_bar_fixup+0x0/0x145
[    0.275201] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.276562] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.279072] pci 0000:00:02.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    0.286074] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.287302] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.288926] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.290332] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.295309] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.296084] pci 0000:00:03.0: calling pci_fixed_bar_fixup+0x0/0x145
[    0.297191] pci 0000:00:04.0: [8086:2668] type 00 class 0x040300
[    0.298436] pci 0000:00:04.0: reg 10: [mem 0xfebf0000-0xfebf3fff]
[    0.301850] pci 0000:00:04.0: calling pci_fixed_bar_fixup+0x0/0x145
[    0.302415] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.304302] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    0.306007] pci 0000:00:05.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    0.311241] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.313316] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    0.314786] pci 0000:00:06.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    0.320279] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.321750] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.322638] pci 0000:00:07.0: reg 14: [mem 0xfebf7000-0xfebf7fff]
[    0.325503] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.327631] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    0.329008] pci 0000:00:08.0: reg 14: [mem 0xfebf8000-0xfebf8fff]
[    0.334354] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.336324] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    0.337691] pci 0000:00:09.0: reg 14: [mem 0xfebf9000-0xfebf9fff]
[    0.343360] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.345339] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    0.347008] pci 0000:00:0a.0: reg 14: [mem 0xfebfa000-0xfebfafff]
[    0.352241] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    0.353384] pci 0000:00:0b.0: reg 10: [mem 0xfebfb000-0xfebfb00f]
[    0.357235] pci 0000:00:0b.0: calling pci_fixed_bar_fixup+0x0/0x145
[    0.358374] pci_bus 0000:00: fixups for bus
[    0.359008] pci_bus 0000:00: bus scan returning with max=3D00
[    0.360014] pci_bus 0000:00: on NUMA node 0
[    0.361094] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.365481]  pci0000:00: ACPI _OSC support notification failed, disablin=
g PCIe ASPM
[    0.366007]  pci0000:00: Unable to request _OSC control (_OSC support ma=
sk: 0x08)
[    0.407138] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.408275] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.409361] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.410481] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.411469] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.413175] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.414027] vgaarb: loaded
[    0.415005] vgaarb: bridge control possible 0000:00:02.0
[    0.416561] PCI: Using ACPI for IRQ routing
[    0.417008] PCI: pci_cache_line_size set to 64 bytes
[    0.417762] pci 0000:00:01.1: BAR 0: reserving [io  0x01f0-0x01f7 flags =
0x110] (d=3D0, p=3D0)
[    0.419008] pci 0000:00:01.1: BAR 1: reserving [io  0x03f6 flags 0x110] =
(d=3D0, p=3D0)
[    0.420009] pci 0000:00:01.1: BAR 2: reserving [io  0x0170-0x0177 flags =
0x110] (d=3D0, p=3D0)
[    0.421009] pci 0000:00:01.1: BAR 3: reserving [io  0x0376 flags 0x110] =
(d=3D0, p=3D0)
[    0.422009] pci 0000:00:01.1: BAR 4: reserving [io  0xc1c0-0xc1cf flags =
0x40101] (d=3D0, p=3D0)
[    0.423042] pci 0000:00:02.0: BAR 0: reserving [mem 0xfc000000-0xfdfffff=
f flags 0x42208] (d=3D0, p=3D0)
[    0.424010] pci 0000:00:02.0: BAR 1: reserving [mem 0xfebf4000-0xfebf4ff=
f flags 0x40200] (d=3D0, p=3D0)
[    0.425026] pci 0000:00:03.0: BAR 0: reserving [mem 0xfeba0000-0xfebbfff=
f flags 0x40200] (d=3D0, p=3D0)
[    0.426000] pci 0000:00:03.0: BAR 1: reserving [io  0xc000-0xc03f flags =
0x40101] (d=3D0, p=3D0)
[    0.426026] pci 0000:00:04.0: BAR 0: reserving [mem 0xfebf0000-0xfebf3ff=
f flags 0x40200] (d=3D0, p=3D0)
[    0.427000] pci 0000:00:05.0: BAR 0: reserving [io  0xc040-0xc07f flags =
0x40101] (d=3D0, p=3D0)
[    0.427000] pci 0000:00:05.0: BAR 1: reserving [mem 0xfebf5000-0xfebf5ff=
f flags 0x40200] (d=3D0, p=3D0)
[    0.427000] pci 0000:00:06.0: BAR 0: reserving [io  0xc080-0xc0bf flags =
0x40101] (d=3D0, p=3D0)
[    0.427009] pci 0000:00:06.0: BAR 1: reserving [mem 0xfebf6000-0xfebf6ff=
f flags 0x40200] (d=3D0, p=3D0)
[    0.428000] pci 0000:00:07.0: BAR 0: reserving [io  0xc0c0-0xc0ff flags =
0x40101] (d=3D0, p=3D0)
[    0.428000] pci 0000:00:07.0: BAR 1: reserving [mem 0xfebf7000-0xfebf7ff=
f flags 0x40200] (d=3D0, p=3D0)
[    0.428000] pci 0000:00:08.0: BAR 0: reserving [io  0xc100-0xc13f flags =
0x40101] (d=3D0, p=3D0)
[    0.428009] pci 0000:00:08.0: BAR 1: reserving [mem 0xfebf8000-0xfebf8ff=
f flags 0x40200] (d=3D0, p=3D0)
[    0.429026] pci 0000:00:09.0: BAR 0: reserving [io  0xc140-0xc17f flags =
0x40101] (d=3D0, p=3D0)
[    0.430009] pci 0000:00:09.0: BAR 1: reserving [mem 0xfebf9000-0xfebf9ff=
f flags 0x40200] (d=3D0, p=3D0)
[    0.431026] pci 0000:00:0a.0: BAR 0: reserving [io  0xc180-0xc1bf flags =
0x40101] (d=3D0, p=3D0)
[    0.432000] pci 0000:00:0a.0: BAR 1: reserving [mem 0xfebfa000-0xfebfaff=
f flags 0x40200] (d=3D0, p=3D0)
[    0.432027] pci 0000:00:0b.0: BAR 0: reserving [mem 0xfebfb000-0xfebfb00=
f flags 0x40200] (d=3D0, p=3D0)
[    0.434063] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    0.434906] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.436918] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.438335] Switching to clocksource kvm-clock
[    0.553552] pnp: PnP ACPI init
[    0.554126] ACPI: bus type pnp registered
[    0.554765] pnp 00:00: [bus 00-ff]
[    0.555280] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.555851] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.556531] pnp 00:00: [io  0x0d00-0xffff window]
[    0.557217] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.557969] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    0.559090] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.560083] pnp 00:01: [io  0x0070-0x0071]
[    0.560676] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.561829] pnp 00:01: [irq 8]
[    0.562293] pnp 00:01: [io  0x0072-0x0077]
[    0.562982] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.564046] pnp 00:02: [io  0x0060]
[    0.564537] pnp 00:02: [io  0x0064]
[    0.565061] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.566194] pnp 00:02: [irq 1]
[    0.566793] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.567892] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.569105] pnp 00:03: [irq 12]
[    0.569654] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.570668] pnp 00:04: [io  0x03f2-0x03f5]
[    0.571270] pnp 00:04: [io  0x03f7]
[    0.571763] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.573105] pnp 00:04: [irq 6]
[    0.573538] pnp 00:04: [dma 2]
[    0.574110] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.575182] pnp 00:05: [io  0x0378-0x037f]
[    0.575761] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.576914] pnp 00:05: [irq 7]
[    0.577551] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.578620] pnp 00:06: [io  0x03f8-0x03ff]
[    0.579231] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.580374] pnp 00:06: [irq 4]
[    0.580928] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.582596] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    0.583506] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.584868] pnp: PnP ACPI: found 8 devices
[    0.585475] ACPI: ACPI bus type pnp unregistered
[    0.623618] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.624430] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[    0.625468] NET: Registered protocol family 2
[    0.626993] TCP established hash table entries: 8192 (order: 4, 65536 by=
tes)
[    0.630197] TCP bind hash table entries: 8192 (order: 6, 360448 bytes)
[    0.632649] TCP: Hash tables configured (established 8192 bind 8192)
[    0.633799] TCP: reno registered
[    0.634472] UDP hash table entries: 256 (order: 2, 24576 bytes)
[    0.635596] UDP-Lite hash table entries: 256 (order: 2, 24576 bytes)
[    0.637042] NET: Registered protocol family 1
[    0.637795] pci 0000:00:00.0: calling quirk_natoma+0x0/0x4f
[    0.638604] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.639463] pci 0000:00:00.0: calling quirk_passive_release+0x0/0xd0
[    0.640387] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.641235] pci 0000:00:00.0: calling pci_d3delay_fixup+0x0/0x69
[    0.642109] pci 0000:00:01.0: calling quirk_isa_dma_hangs+0x0/0x52
[    0.642967] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.643837] pci 0000:00:01.0: calling pci_d3delay_fixup+0x0/0x69
[    0.644709] pci 0000:00:01.1: calling pci_d3delay_fixup+0x0/0x69
[    0.645585] pci 0000:00:01.3: calling pci_d3delay_fixup+0x0/0x69
[    0.646465] pci 0000:00:02.0: calling pci_fixup_video+0x0/0x131
[    0.647326] pci 0000:00:02.0: Boot video device
[    0.647980] pci 0000:00:03.0: calling quirk_e100_interrupt+0x0/0x23a
[    0.648889] pci 0000:00:03.0: calling pci_d3delay_fixup+0x0/0x69
[    0.649766] pci 0000:00:04.0: calling pci_d3delay_fixup+0x0/0x69
[    0.650792] pci 0000:00:0b.0: calling pci_d3delay_fixup+0x0/0x69
[    0.651682] PCI: CLS 0 bytes, default 64
[    0.652936] Unpacking initramfs...
[    4.328807] debug: unmapping init [mem 0xce73f000-0xcffeffff]
[    4.335424] audit: initializing netlink socket (disabled)
[    4.336374] type=3D2000 audit(1350908217.336:1): initialized
[    4.545051] Testing tracer function: PASSED
[    4.703143] Testing dynamic ftrace: PASSED
[    4.979267] Testing dynamic ftrace ops #1: (1 0 1 1 0) (1 1 2 1 0) (2 1 =
3 1 26) (2 2 4 1 109) PASSED
[    5.115589] Testing dynamic ftrace ops #2: (1 0 1 9 0) (1 1 2 88 0) (2 1=
 3 1 90) (2 2 4 84 173) PASSED
[    5.260817] Testing ftrace recursion: PASSED
[    5.280450] Testing ftrace recursion safe: PASSED
[    5.291622] Testing ftrace regs: PASSED
[    5.336143] tsc: Refined TSC clocksource calibration: 2992.499 MHz
[    5.355043] Testing tracer irqsoff: PASSED
[    5.570963] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    5.591790] VFS: Disk quotas dquot_6.5.2
[    5.592672] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    5.594514] 9p: Installing v9fs 9p2000 file system support
[    5.598091] cryptomgr_test (27) used greatest stack depth: 6520 bytes le=
ft
[    5.599829] cryptomgr_test (28) used greatest stack depth: 6344 bytes le=
ft
[    5.609559] cryptomgr_test (29) used greatest stack depth: 6332 bytes le=
ft
[    5.619158] alg: No test for stdrng (krng)
[    5.620233] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 254)
[    5.621367] io scheduler noop registered (default)
[    5.622059] list_sort_test: start testing list_sort()
[    5.624608] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    5.625735] ACPI: Power Button [PWRF]
[    5.654134] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    5.654974] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:3)
[    5.666218] virtio-pci 0000:00:05.0: enabling bus mastering
[    5.667073] virtio-pci 0000:00:05.0: setting latency timer to 64
[    5.668972] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
[    5.669807] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:3)
[    5.671183] virtio-pci 0000:00:06.0: enabling bus mastering
[    5.671978] virtio-pci 0000:00:06.0: setting latency timer to 64
[    5.673600] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    5.674451] virtio-pci 0000:00:07.0: enabling bus mastering
[    5.685281] virtio-pci 0000:00:07.0: setting latency timer to 64
[    5.686936] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
[    5.687785] virtio-pci 0000:00:08.0: enabling bus mastering
[    5.688613] virtio-pci 0000:00:08.0: setting latency timer to 64
[    5.689943] virtio-pci 0000:00:09.0: enabling bus mastering
[    5.690774] virtio-pci 0000:00:09.0: setting latency timer to 64
[    5.692210] virtio-pci 0000:00:0a.0: enabling bus mastering
[    5.693043] virtio-pci 0000:00:0a.0: setting latency timer to 64
[    5.892914] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    5.916427] 00:06: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    5.920152] virtio-pci 0000:00:05.0: irq 40 for MSI/MSI-X
[    5.920948] virtio-pci 0000:00:05.0: irq 41 for MSI/MSI-X
[    5.938458]  vda: unknown partition table
[    5.955684] virtio-pci 0000:00:06.0: irq 42 for MSI/MSI-X
[    5.956583] virtio-pci 0000:00:06.0: irq 43 for MSI/MSI-X
[    5.987477]  vdb: unknown partition table
[    5.988983] virtio-pci 0000:00:07.0: irq 44 for MSI/MSI-X
[    5.989797] virtio-pci 0000:00:07.0: irq 45 for MSI/MSI-X
[    6.002420]  vdc: unknown partition table
[    6.003998] virtio-pci 0000:00:08.0: irq 46 for MSI/MSI-X
[    6.004820] virtio-pci 0000:00:08.0: irq 47 for MSI/MSI-X
[    6.034919]  vdd: unknown partition table
[    6.036583] virtio-pci 0000:00:09.0: irq 48 for MSI/MSI-X
[    6.037409] virtio-pci 0000:00:09.0: irq 49 for MSI/MSI-X
[    6.050292]  vde: unknown partition table
[    6.051988] virtio-pci 0000:00:0a.0: irq 50 for MSI/MSI-X
[    6.052812] virtio-pci 0000:00:0a.0: irq 51 for MSI/MSI-X
[    6.083297]  vdf: unknown partition table
[    6.085075] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    6.087563] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.088349] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.091108] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    6.092833] cpuidle: using governor ladder
[    6.098948] cpuidle: using governor menu
[    6.100166] TCP: cubic registered
[    6.100669] 9pnet: Installing 9P2000 support
[    6.132164]=20
[    6.132164] printing PIC contents
[    6.132847] ... PIC  IMR: ffff
[    6.133018] ... PIC  IRR: 1013
[    6.133760] ... PIC  ISR: 0000
[    6.134230] ... PIC ELCR: 0c00
[    6.102436] printing local APIC contents on CPU#0/0:
[    6.102436] ... APIC ID:      00000000 (0)
[    6.102436] ... APIC VERSION: 00050014
[    6.102436] ... APIC TASKPRI: 00000000 (00)
[    6.102436] ... APIC PROCPRI: 00000000
[    6.102436] ... APIC LDR: 01000000
[    6.102436] ... APIC DFR: ffffffff
[    6.102436] ... APIC SPIV: 000001ff
[    6.102436] ... APIC ISR field:
[    6.102436] 000000000000000000000000000000000000000000000000000000000000=
0000
[    6.102436] ... APIC TMR field:
[    6.102436] 000000000000000000000000000000000000000000000000000000000000=
0000
[    6.102436] ... APIC IRR field:
[    6.102436] 000000000000000000000000000000000000000000000000000000000000=
8000
[    6.102436] ... APIC ESR: 00000000
[    6.102436] ... APIC ICR: 000008fd
[    6.102436] ... APIC ICR2: 02000000
[    6.102436] ... APIC LVTT: 000000ef
[    6.102436] ... APIC LVTPC: 00010000
[    6.102436] ... APIC LVT0: 00010700
[    6.102436] ... APIC LVT1: 00000400
[    6.102436] ... APIC LVTERR: 000000fe
[    6.102436] ... APIC TMICT: 000087fb
[    6.102436] ... APIC TMCCT: 00000000
[    6.102436] ... APIC TDCR: 00000003
[    6.102436]=20
[    6.191902] number of MP IRQ sources: 15.
[    6.192494] number of IO-APIC #2 registers: 24.
[    6.193153] testing the IO APIC.......................
[    6.193887] IO APIC #2......
[    6.194317] .... register #00: 00000000
[    6.194850] .......    : physical APIC id: 00
[    6.195488] .......    : Delivery Type: 0
[    6.196084] .......    : LTS          : 0
[    6.196642] .... register #01: 00170011
[    6.197204] .......     : max redirection entries: 17
[    6.197906] .......     : PRQ implemented: 0
[    6.198524] .......     : IO APIC version: 11
[    6.199161] .... register #02: 00000000
[    6.199697] .......     : arbitration: 00
[    6.200286] .... IRQ redirection table:
[    6.200821]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    6.201624]  00 00  1    0    0   0   0    0    0    00
[    6.202419]  01 03  0    0    0   0   0    1    1    31
[    6.203204]  02 03  0    0    0   0   0    1    1    30
[    6.203969]  03 03  0    0    0   0   0    1    1    33
[    6.204753]  04 03  1    0    0   0   0    1    1    34
[    6.217550]  05 03  1    1    0   0   0    1    1    35
[    6.218334]  06 03  0    0    0   0   0    1    1    36
[    6.219121]  07 03  0    0    0   0   0    1    1    37
[    6.219881]  08 03  0    0    0   0   0    1    1    38
[    6.220664]  09 03  0    1    0   0   0    1    1    39
[    6.221448]  0a 03  1    1    0   0   0    1    1    3A
[    6.222234]  0b 03  1    1    0   0   0    1    1    3B
[    6.222997]  0c 03  0    0    0   0   0    1    1    3C
[    6.223778]  0d 03  0    0    0   0   0    1    1    3D
[    6.224559]  0e 03  0    0    0   0   0    1    1    3E
[    6.225345]  0f 03  0    0    0   0   0    1    1    3F
[    6.236134]  10 00  1    0    0   0   0    0    0    00
[    6.236899]  11 00  1    0    0   0   0    0    0    00
[    6.237682]  12 00  1    0    0   0   0    0    0    00
[    6.238467]  13 00  1    0    0   0   0    0    0    00
[    6.239256]  14 00  1    0    0   0   0    0    0    00
[    6.240043]  15 00  1    0    0   0   0    0    0    00
[    6.240799]  16 00  1    0    0   0   0    0    0    00
[    6.241584]  17 00  1    0    0   0   0    0    0    00
[    6.242355] IRQ to pin mappings:
[    6.242808] IRQ0 -> 0:2
[    6.243232] IRQ1 -> 0:1
[    6.243626] IRQ3 -> 0:3
[    6.244048] IRQ4 -> 0:4
[    6.244442] IRQ5 -> 0:5
[    6.244836] IRQ6 -> 0:6
[    6.255269] IRQ7 -> 0:7
[    6.255663] IRQ8 -> 0:8
[    6.256087] IRQ9 -> 0:9
[    6.256482] IRQ10 -> 0:10
[    6.256905] IRQ11 -> 0:11
[    6.257344] IRQ12 -> 0:12
[    6.257759] IRQ13 -> 0:13
[    6.258205] IRQ14 -> 0:14
[    6.258621] IRQ15 -> 0:15
[    6.259069] .................................... done.
[    6.259778] Using IPI No-Shortcut mode
[    6.261156] PM: Hibernation image not present or could not be loaded.
[    6.272245] Running tests on trace events:
[    6.272818] Testing event 9p_client_req: OK
[    6.284340] Testing event 9p_client_res: OK
[    6.309360] Testing event 9p_protocol_dump: OK
[    6.315370] Testing event kfree_skb: OK
[    6.321275] Testing event consume_skb: OK
[    6.332249] Testing event skb_copy_datagram_iovec: OK
[    6.338278] Testing event net_dev_xmit: OK
[    6.343290] Testing event net_dev_queue: OK
[    6.348293] Testing event netif_receive_skb: OK
[    6.353280] Testing event netif_rx: OK
[    6.358287] Testing event napi_poll: OK
[    6.368235] Testing event sock_rcvqueue_full: OK
[    6.374272] Testing event sock_exceed_buf_limit: OK
[    6.380370] Testing event udp_fail_queue_rcv_skb: OK
[    6.385290] Testing event regmap_reg_write: OK
[    6.390277] Testing event regmap_reg_read: OK
[    6.395308] Testing event regmap_reg_read_cache: OK
[    6.405326] Testing event regmap_hw_read_start: OK
[    6.411264] Testing event regmap_hw_read_done: OK
[    6.417386] Testing event regmap_hw_write_start: OK
[    6.422284] Testing event regmap_hw_write_done: OK
[    6.427313] Testing event regcache_sync: OK
[    6.432282] Testing event regmap_cache_only: OK
[    6.443438] Testing event regmap_cache_bypass: OK
[    6.448365] Testing event mix_pool_bytes: OK
[    6.453276] Testing event mix_pool_bytes_nolock: OK
[    6.458279] Testing event credit_entropy_bits: OK
[    6.463309] Testing event get_random_bytes: OK
[    6.473313] Testing event extract_entropy: OK
[    6.478279] Testing event extract_entropy_user: OK
[    6.483285] Testing event gpio_direction: OK
[    6.488358] Testing event gpio_value: OK
[    6.493288] Testing event block_rq_abort: OK
[    6.503230] Testing event block_rq_requeue: OK
[    6.509276] Testing event block_rq_complete: OK
[    6.515365] Testing event block_rq_insert: OK
[    6.520293] Testing event block_rq_issue: OK
[    6.525282] Testing event block_bio_bounce: OK
[    6.530311] Testing event block_bio_complete: OK
[    6.540321] Testing event block_bio_backmerge: OK
[    6.546274] Testing event block_bio_frontmerge: OK
[    6.552387] Testing event block_bio_queue: OK
[    6.557284] Testing event block_getrq: OK
[    6.562284] Testing event block_sleeprq: OK
[    6.567305] Testing event block_plug: OK
[    6.577323] Testing event block_unplug: OK
[    6.583248] Testing event block_split: OK
[    6.588281] Testing event block_bio_remap: OK
[    6.593279] Testing event block_rq_remap: OK
[    6.598307] Testing event writeback_nothread: OK
[    6.603280] Testing event writeback_queue: OK
[    6.613225] Testing event writeback_exec: OK
[    6.619264] Testing event writeback_start: OK
[    6.625359] Testing event writeback_written: OK
[    6.630286] Testing event writeback_wait: OK
[    6.635277] Testing event writeback_pages_written: OK
[    6.640303] Testing event writeback_nowork: OK
[    6.650322] Testing event writeback_wake_background: OK
[    6.656265] Testing event writeback_wake_thread: OK
[    6.662378] Testing event writeback_wake_forker_thread: OK
[    6.667276] Testing event writeback_bdi_register: OK
[    6.672305] Testing event writeback_bdi_unregister: OK
[    6.677279] Testing event writeback_thread_start: OK
[    6.688327] Testing event writeback_thread_stop: OK
[    6.694276] Testing event wbc_writepage: OK
[    6.700377] Testing event writeback_queue_io: OK
[    6.705296] Testing event global_dirty_state: OK
[    6.710305] Testing event bdi_dirty_ratelimit: OK
[    6.715280] Testing event balance_dirty_pages: OK
[    6.726223] Testing event writeback_sb_inodes_requeue: OK
[    6.735283] Testing event writeback_congestion_wait: OK
[    6.741368] Testing event writeback_wait_iff_congested: OK
[    6.746278] Testing event writeback_single_inode: OK
[    6.751312] Testing event mm_compaction_isolate_migratepages: OK
[    6.756280] Testing event mm_compaction_isolate_freepages: OK
[    6.765327] Testing event mm_compaction_migratepages: OK
[    6.771279] Testing event kmalloc: OK
[    6.777376] Testing event kmem_cache_alloc: OK
[    6.782275] Testing event kmalloc_node: OK
[    6.787280] Testing event kmem_cache_alloc_node: OK
[    6.798325] Testing event kfree: OK
[    6.804252] Testing event kmem_cache_free: OK
[    6.809281] Testing event mm_page_free: OK
[    6.814276] Testing event mm_page_free_batched: OK
[    6.819305] Testing event mm_page_alloc: OK
[    6.824279] Testing event mm_page_alloc_zone_locked: OK
[    6.829279] Testing event mm_page_pcpu_drain: OK
[    6.840342] Testing event mm_page_alloc_extfrag: OK
[    6.845346] Testing event mm_vmscan_kswapd_sleep: OK
[    6.850293] Testing event mm_vmscan_kswapd_wake: OK
[    6.855290] Testing event mm_vmscan_wakeup_kswapd: OK
[    6.860284] Testing event mm_vmscan_direct_reclaim_begin: OK
[    6.865382] Testing event mm_vmscan_memcg_reclaim_begin: OK
[    6.870326] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[    6.880324] Testing event mm_vmscan_direct_reclaim_end: OK
[    6.886281] Testing event mm_vmscan_memcg_reclaim_end: OK
[    6.892387] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[    6.897277] Testing event mm_shrink_slab_start: OK
[    6.902306] Testing event mm_shrink_slab_end: OK
[    6.912332] Testing event mm_vmscan_lru_isolate: OK
[    6.918265] Testing event mm_vmscan_memcg_isolate: OK
[    6.924398] Testing event mm_vmscan_writepage: OK
[    6.929289] Testing event mm_vmscan_lru_shrink_inactive: OK
[    6.934306] Testing event oom_score_adj_update: OK
[    6.944334] Testing event rpm_suspend: OK
[    6.950273] Testing event rpm_resume: OK
[    6.956378] Testing event rpm_idle: OK
[    6.961304] Testing event rpm_return_int: OK
[    6.966292] Testing event cpu_idle: OK
[    6.971287] Testing event cpu_frequency: OK
[    6.976305] Testing event machine_suspend: OK
[    6.985324] Testing event wakeup_source_activate: OK
[    6.991248] Testing event wakeup_source_deactivate: OK
[    6.996261] Testing event clock_enable: OK
[    7.001281] Testing event clock_disable: OK
[    7.006278] Testing event clock_set_rate: OK
[    7.016337] Testing event power_domain_target: OK
[    7.022279] Testing event ftrace_test_filter: OK
[    7.028282] Testing event module_load: OK
[    7.033282] Testing event module_free: OK
[    7.038283] Testing event module_request: OK
[    7.047339] Testing event lock_acquire: OK
[    7.053332] Testing event lock_release: OK
[    7.059313] Testing event lock_contended: OK
[    7.064304] Testing event lock_acquired: OK
[    7.069325] Testing event sched_kthread_stop: OK
[    7.074285] Testing event sched_kthread_stop_ret: OK
[    7.084340] Testing event sched_wakeup: OK
[    7.090266] Testing event sched_wakeup_new: OK
[    7.095281] Testing event sched_switch: OK
[    7.100282] Testing event sched_migrate_task: OK
[    7.105320] Testing event sched_process_free: OK
[    7.110293] Testing event sched_process_exit: OK
[    7.120345] Testing event sched_wait_task: OK
[    7.126294] Testing event sched_process_wait: OK
[    7.132297] Testing event sched_process_fork: OK
[    7.137321] Testing event sched_process_exec: OK
[    7.142281] Testing event sched_stat_wait: OK
[    7.151329] Testing event sched_stat_sleep: OK
[    7.156298] Testing event sched_stat_iowait: OK
[    7.161382] Testing event sched_stat_blocked: OK
[    7.166309] Testing event sched_stat_runtime: OK
[    7.171299] Testing event sched_pi_setprio: OK
[    7.177356] Testing event rcu_utilization: OK
[    7.187625] Testing event workqueue_queue_work: OK
[    7.198546] Testing event workqueue_activate_work: OK
[    7.203519] Testing event workqueue_execute_start: OK
[    7.208417] Testing event workqueue_execute_end: OK
[    7.214502] Testing event signal_generate: OK
[    7.220389] Testing event signal_deliver: OK
[    7.225485] Testing event timer_init: OK
[    7.230502] Testing event timer_start: OK
[    7.235434] Testing event timer_expire_entry: OK
[    7.240519] Testing event timer_expire_exit: OK
[    7.245502] Testing event timer_cancel: OK
[    7.250518] Testing event hrtimer_init: OK
[    7.255512] Testing event hrtimer_start: OK
[    7.260495] Testing event hrtimer_expire_entry: OK
[    7.265514] Testing event hrtimer_expire_exit: OK
[    7.270511] Testing event hrtimer_cancel: OK
[    7.275444] Testing event itimer_state: OK
[    7.280449] Testing event itimer_expire: OK
[    7.285351] Testing event irq_handler_entry: OK
[    7.290496] Testing event irq_handler_exit: OK
[    7.295360] Testing event softirq_entry: OK
[    7.300454] Testing event softirq_exit: OK
[    7.305332] Testing event softirq_raise: OK
[    7.316358] Testing event console: OK
[    7.323508] Testing event task_newtask: OK
[    7.342308] Testing event task_rename: OK
[    7.352321] Testing event sys_enter: OK
[    7.357391] Testing event sys_exit: OK
[    7.364203] Running tests on trace event systems:
[    7.364861] Testing event system raw_syscalls: OK
[    7.392509] Testing event system task: OK
[    7.398489] Testing event system printk: OK
[    7.404474] Testing event system irq: OK
[    7.409625] Testing event system timer: OK
[    7.414659] Testing event system signal: OK
[    7.419454] Testing event system workqueue: OK
[    7.424485] Testing event system rcu: OK
[    7.455573] Testing event system sched: OK
[    7.462795] Testing event system lock: OK
[    7.470125] Testing event system module: OK
[    7.477543] Testing event system test: OK
[    7.483455] Testing event system power: OK
[    7.488579] Testing event system rpm: OK
[    7.493585] Testing event system oom: OK
[    7.498534] Testing event system vmscan: OK
[    7.519709] Testing event system kmem: OK
[    7.524627] Testing event system compaction: OK
[    7.529545] Testing event system writeback: OK
[    7.535878] Testing event system block: OK
[    7.556679] Testing event system gpio: OK
[    7.561430] Testing event system random: OK
[    7.566600] Testing event system regmap: OK
[    7.571676] Testing event system syscalls: OK
[    7.600759] Testing event system udp: OK
[    7.613549] Testing event system sock: OK
[    7.618433] Testing event system napi: OK
[    7.623529] Testing event system net: OK
[    7.628461] Testing event system skb: OK
[    7.633507] Testing event system 9p: OK
[    7.638396] Running tests on all trace events:
[    7.639112] Testing all events: OK
[    7.754516] Running tests again, along with the function tracer
[    7.769985] Running tests on trace events:
[    7.770823] Testing event 9p_client_req: OK
[    7.777259] Testing event 9p_client_res: OK
[    7.785255] Testing event 9p_protocol_dump: OK
[    7.792519] Testing event kfree_skb: OK
[    7.804442] Testing event consume_skb: OK
[    7.811601] Testing event skb_copy_datagram_iovec: OK
[    7.824849] Testing event net_dev_xmit: OK
[    7.833405] Testing event net_dev_queue: OK
[    7.845251] Testing event netif_receive_skb: OK
[    7.855302] Testing event netif_rx: OK
[    7.867406] Testing event napi_poll: OK
[    7.875241] Testing event sock_rcvqueue_full: OK
[    7.889999] Testing event sock_exceed_buf_limit: OK
[    7.897316] Testing event udp_fail_queue_rcv_skb: OK
[    7.904432] Testing event regmap_reg_write: OK
[    7.932244] Testing event regmap_reg_read: OK
[    7.963265] Testing event regmap_reg_read_cache: OK
[    7.993303] Testing event regmap_hw_read_start: OK
[    8.040779] Testing event regmap_hw_read_done: OK
[    8.059318] Testing event regmap_hw_write_start: OK
[    8.075153] Testing event regmap_hw_write_done: OK
[    8.083650] Testing event regcache_sync: OK
[    8.090523] Testing event regmap_cache_only: OK
[    8.097320] Testing event regmap_cache_bypass: OK
[    8.104443] Testing event mix_pool_bytes: OK
[    8.112212] Testing event mix_pool_bytes_nolock: OK
[    8.119295] Testing event credit_entropy_bits: OK
[    8.126734] Testing event get_random_bytes: OK
[    8.134477] Testing event extract_entropy: OK
[    8.141515] Testing event extract_entropy_user: OK
[    8.149262] Testing event gpio_direction: OK
[    8.156397] Testing event gpio_value: OK
[    8.165625] Testing event block_rq_abort: OK
[    8.175741] Testing event block_rq_requeue: OK
[    8.183940] Testing event block_rq_complete: OK
[    8.198510] Testing event block_rq_insert: OK
[    8.206682] Testing event block_rq_issue: OK
[    8.215613] Testing event block_bio_bounce: OK
[    8.225561] Testing event block_bio_complete: OK
[    8.239335] Testing event block_bio_backmerge: OK
[    8.256175] Testing event block_bio_frontmerge: OK
[    8.263525] Testing event block_bio_queue: OK
[    8.276277] Testing event block_getrq: OK
[    8.284264] Testing event block_sleeprq: OK
[    8.294175] Testing event block_plug: OK
[    8.302498] Testing event block_unplug: OK
[    8.313405] Testing event block_split: OK
[    8.322953] Testing event block_bio_remap: OK
[    8.330513] Testing event block_rq_remap: OK
[    8.338381] Testing event writeback_nothread: OK
[    8.352816] Testing event writeback_queue: OK
[    8.364802] Testing event writeback_exec: OK
[    8.377350] Testing event writeback_start: OK
[    8.384721] Testing event writeback_written: OK
[    8.395505] Testing event writeback_wait: OK
[    8.402279] Testing event writeback_pages_written: OK
[    8.409466] Testing event writeback_nowork: OK
[    8.422459] Testing event writeback_wake_background: OK
[    8.429758] Testing event writeback_wake_thread: OK
[    8.437353] Testing event writeback_wake_forker_thread: OK
[    8.449391] Testing event writeback_bdi_register: OK
[    8.456585] Testing event writeback_bdi_unregister: OK
[    8.467491] Testing event writeback_thread_start: OK
[    8.475485] Testing event writeback_thread_stop: OK
[    8.482449] Testing event wbc_writepage: OK
[    8.495686] Testing event writeback_queue_io: OK
[    8.502389] Testing event global_dirty_state: OK
[    8.514671] Testing event bdi_dirty_ratelimit: OK
[    8.522743] Testing event balance_dirty_pages: OK
[    8.534852] Testing event writeback_sb_inodes_requeue: OK
[    8.541346] Testing event writeback_congestion_wait: OK
[    8.552727] Testing event writeback_wait_iff_congested: OK
[    8.558217] Testing event writeback_single_inode: OK
[    8.570843] Testing event mm_compaction_isolate_migratepages: OK
[    8.581921] Testing event mm_compaction_isolate_freepages: OK
[    8.594511] Testing event mm_compaction_migratepages: OK
[    8.603587] Testing event kmalloc: OK
[    8.613503] Testing event kmem_cache_alloc: OK
[    8.624582] Testing event kmalloc_node: OK
[    8.636197] Testing event kmem_cache_alloc_node: OK
[    8.647011] Testing event kfree: OK
[    8.655583] Testing event kmem_cache_free: OK
[    8.664725] Testing event mm_page_free: OK
[    8.675311] Testing event mm_page_free_batched: OK
[    8.685289] Testing event mm_page_alloc: OK
[    8.694576] Testing event mm_page_alloc_zone_locked: OK
[    8.703750] Testing event mm_page_pcpu_drain: OK
[    8.714787] Testing event mm_page_alloc_extfrag: OK
[    8.725260] Testing event mm_vmscan_kswapd_sleep: OK
[    8.740780] Testing event mm_vmscan_kswapd_wake: OK
[    8.751943] Testing event mm_vmscan_wakeup_kswapd: OK
[    8.762521] Testing event mm_vmscan_direct_reclaim_begin: OK
[    8.772704] Testing event mm_vmscan_memcg_reclaim_begin: OK
[    8.782579] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[    8.792909] Testing event mm_vmscan_direct_reclaim_end: OK
[    8.803770] Testing event mm_vmscan_memcg_reclaim_end: OK
[    8.814804] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[    8.826969] Testing event mm_shrink_slab_start: OK
[    8.839768] Testing event mm_shrink_slab_end: OK
[    8.849574] Testing event mm_vmscan_lru_isolate: OK
[    8.858967] Testing event mm_vmscan_memcg_isolate: OK
[    8.870823] Testing event mm_vmscan_writepage: OK
[    8.882875] Testing event mm_vmscan_lru_shrink_inactive: OK
[    8.894367] Testing event oom_score_adj_update: OK
[    8.904649] Testing event rpm_suspend: OK
[    8.913572] Testing event rpm_resume: OK
[    8.922942] Testing event rpm_idle: OK
[    8.933223] Testing event rpm_return_int: OK
[    8.943984] Testing event cpu_idle: OK
[    8.955613] Testing event cpu_frequency: OK
[    8.963825] Testing event machine_suspend: OK
[    8.974983] Testing event wakeup_source_activate: OK
[    8.987220] Testing event wakeup_source_deactivate: OK
[    8.995672] Testing event clock_enable: OK
[    9.006241] Testing event clock_disable: OK
[    9.015390] Testing event clock_set_rate: OK
[    9.023950] Testing event power_domain_target: OK
[    9.035839] Testing event ftrace_test_filter: OK
[    9.046433] Testing event module_load: OK
[    9.054767] Testing event module_free: OK
[    9.065911] Testing event module_request: OK
[    9.075288] Testing event lock_acquire: OK
[    9.088887] Testing event lock_release: OK
[    9.103892] Testing event lock_contended: OK
[    9.116458] Testing event lock_acquired: OK
[    9.129245] Testing event sched_kthread_stop: OK
[    9.138933] Testing event sched_kthread_stop_ret: OK
[    9.149803] Testing event sched_wakeup: OK
[    9.158901] Testing event sched_wakeup_new: OK
[    9.167940] Testing event sched_switch: OK
[    9.177341] Testing event sched_migrate_task: OK
[    9.187951] Testing event sched_process_free: OK
[    9.197668] Testing event sched_process_exit: OK
[    9.207202] Testing event sched_wait_task: OK
[    9.232234] Testing event sched_process_wait: OK
[    9.243712] Testing event sched_process_fork: OK
[    9.254316] Testing event sched_process_exec: OK
[    9.266879] Testing event sched_stat_wait: OK
[    9.278616] Testing event sched_stat_sleep: OK
[    9.288997] Testing event sched_stat_iowait: OK
[    9.299304] Testing event sched_stat_blocked: OK
[    9.310619] Testing event sched_stat_runtime: OK
[    9.322681] Testing event sched_pi_setprio: OK
[    9.332773] Testing event rcu_utilization: OK
[    9.344832] Testing event workqueue_queue_work: OK
[    9.352781] Testing event workqueue_activate_work: OK
[    9.364255] Testing event workqueue_execute_start: OK
[    9.375484] Testing event workqueue_execute_end: OK
[    9.386711] Testing event signal_generate: OK
[    9.397374] Testing event signal_deliver: OK
[    9.407567] Testing event timer_init: OK
[    9.418916] Testing event timer_start: OK
[    9.431720] Testing event timer_expire_entry: OK
[    9.441686] Testing event timer_expire_exit: OK
[    9.454833] Testing event timer_cancel: OK
[    9.466912] Testing event hrtimer_init: OK
[    9.479868] Testing event hrtimer_start: OK
[    9.492679] Testing event hrtimer_expire_entry: OK
[    9.505663] Testing event hrtimer_expire_exit: OK
[    9.518690] Testing event hrtimer_cancel: OK
[    9.530537] Testing event itimer_state: OK
[    9.540893] Testing event itimer_expire: OK
[    9.554691] Testing event irq_handler_entry: OK
[    9.567415] Testing event irq_handler_exit: OK
[    9.578978] Testing event softirq_entry: OK
[    9.589186] Testing event softirq_exit: OK
[    9.601677] Testing event softirq_raise: OK
[    9.613390] Testing event console: OK
[    9.621695] Testing event task_newtask: OK
[    9.633925] Testing event task_rename: OK
[    9.645757] Testing event sys_enter: OK
[    9.657469] Testing event sys_exit: OK
[    9.667430] Running tests on trace event systems:
[    9.668543] Testing event system raw_syscalls: OK
[    9.679892] Testing event system task: OK
[    9.693689] Testing event system printk: OK
[    9.706572] Testing event system irq: OK
[    9.722847] Testing event system timer: OK
[    9.739959] Testing event system signal: OK
[    9.753303] Testing event system workqueue: OK
[    9.764236] Testing event system rcu: OK
[    9.778833] Testing event system sched: OK
[    9.799288] Testing event system lock: OK
[    9.830303] Testing event system module: OK
[    9.843508] Testing event system test: OK
[    9.853805] Testing event system power: OK
[    9.865854] Testing event system rpm: OK
[    9.881857] Testing event system oom: OK
[    9.892729] Testing event system vmscan: OK
[    9.916626] Testing event system kmem: OK
[    9.938210] Testing event system compaction: OK
[    9.951745] Testing event system writeback: OK
[    9.983217] Testing event system block: OK
[   10.008706] Testing event system gpio: OK
[   10.020328] Testing event system random: OK
[   10.035862] Testing event system regmap: OK
[   10.054818] Testing event system syscalls: OK
[   10.080670] Testing event system udp: OK
[   10.090395] Testing event system sock: OK
[   10.102399] Testing event system napi: OK
[   10.113733] Testing event system net: OK
[   10.124813] Testing event system skb: OK
[   10.134317] Testing event system 9p: OK
[   10.148409] Running tests on all trace events:
[   10.149356] Testing all events: OK
[   10.373248] Testing ftrace filter: OK
[   10.375200] Testing kprobe tracing: OK
[   10.397753]   Magic number: 0:669:279
[   10.398362] tty ttyy7: hash matches
[   10.398874] tty ttyva: hash matches
[   10.399491] event_source tracepoint: hash matches
[   10.400295] hd: no drives specified - use hd=3Dcyl,head,sectors on kerne=
l command line
[   10.404696] debug: unmapping init [mem 0xc196a000-0xc1b44fff]
mountall: ply-event-loop.c:497: ply_event_loop_new: Assertion `loop->epoll_=
fd >=3D 0' failed.
[   10.711190] sh (453) used greatest stack depth: 6228 bytes left
General error mounting filesystems.
A maintenance shell will now be started.
CONTROL-D will terminate this shell and reboot the system.
wfg: rebooting
[   10.817411] Unregister pv shared memory for cpu 0
[   10.818115] Unregister pv shared memory for cpu 1
[   10.823845] Disabling non-boot CPUs ...
[   10.825929] CPU0 attaching NULL sched-domain.
[   10.826675] CPU1 attaching NULL sched-domain.
[   10.827421] CPU0 attaching NULL sched-domain.
[   10.831165] BUG: unable to handle kernel paging request at c19d50e4
[   10.832068] IP: [<c11e2149>] __flush_cpu_slab+0x12/0x6e
[   10.832101] *pde =3D 0231a067 *pte =3D 019d5162=20
[   10.832101] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   10.832101] Modules linked in:
[   10.832101] Pid: 459, comm: reboot Not tainted 3.7.0-rc1-00016-gb59d450 =
#44 Bochs Bochs
[   10.832101] EIP: 0060:[<c11e2149>] EFLAGS: 00010046 CPU: 0
[   10.832101] EIP is at __flush_cpu_slab+0x12/0x6e
[   10.832101] EAX: c19d50e4 EBX: c19d50e4 ECX: 00000006 EDX: 00000001
[   10.832101] ESI: 00000246 EDI: 00000001 EBP: c734ddf0 ESP: c734ddec
[   10.832101]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   10.832101] CR0: 8005003b CR2: c19d50e4 CR3: 0735b000 CR4: 00000690
[   10.832101] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   10.832101] DR6: ffff0ff0 DR7: 00000400
[   10.832101] Process reboot (pid: 459, ti=3Dc734c000 task=3Dc7380000 task=
=2Eti=3Dc734c000)
[   10.832101] Stack:
[   10.832101]  c19d50e4 c734de04 c155b2ca c1962664 00000000 c19625ec c734d=
e20 c15757a7
[   10.832101]  00000001 00000017 00000001 00000000 00000010 c734de30 c1099=
0e8 fffffff6
[   10.832101]  00000000 c734de40 c105dc62 ffffffff 00000000 c734de4c c105d=
cd3 00000000
[   10.832101] Call Trace:
[   10.832101]  [<c155b2ca>] slab_cpuup_callback+0x9a/0x158
[   10.832101]  [<c15757a7>] notifier_call_chain+0x46/0x91
[   10.832101]  [<c10990e8>] __raw_notifier_call_chain+0x21/0x31
[   10.832101]  [<c105dc62>] __cpu_notify+0x28/0x79
[   10.832101]  [<c105dcd3>] cpu_notify+0x20/0x30
[   10.832101]  [<c105dcfe>] cpu_notify_nofail+0x1b/0x4d
[   10.832101]  [<c15343bd>] _cpu_down+0x2a2/0x426
[   10.832101]  [<c1560e1a>] ? printk+0x57/0x6a
[   10.832101]  [<c105e47a>] disable_nonboot_cpus+0xc9/0x20c
[   10.832101]  [<c107d0b6>] kernel_restart+0x31/0xb9
[   10.832101]  [<c107d30d>] sys_reboot+0x1a2/0x2f4
[   10.832101]  [<c1158e05>] ? time_hardirqs_off+0x47/0x5a
[   10.832101]  [<c10ade85>] ? local_clock+0x78/0xc7
[   10.832101]  [<c10e1a3f>] ? trace_hardirqs_off_caller+0x34/0x168
[   10.832101]  [<c10e1b9a>] ? trace_hardirqs_off+0x27/0x37
[   10.832101]  [<c10ade85>] ? local_clock+0x78/0xc7
[   10.832101]  [<c10e1ce1>] ? lock_release_holdtime+0xca/0xdd
[   10.832101]  [<c10e8142>] ? lock_release+0x39d/0x46e
[   10.832101]  [<c10973f9>] ? up_read+0x37/0x82
[   10.832101]  [<c157562e>] ? __do_page_fault+0x87d/0x985
[   10.832101]  [<c10e8142>] ? lock_release+0x39d/0x46e
[   10.832101]  [<c156f959>] ? restore_all+0xf/0xf
[   10.832101]  [<c12f45b4>] ? trace_hardirqs_on_thunk+0xc/0x10
[   10.832101]  [<c156f959>] ? restore_all+0xf/0xf
[   10.832101]  [<c1574947>] ? arch_init_optprobes+0xb5/0xb5
[   10.832101]  [<c156f959>] ? restore_all+0xf/0xf
[   10.832101]  [<c1574947>] ? arch_init_optprobes+0xb5/0xb5
[   10.832101]  [<c10e89b9>] ? trace_hardirqs_on_caller+0x291/0x390
[   10.832101]  [<c12f45b4>] ? trace_hardirqs_on_thunk+0xc/0x10
[   10.832101]  [<c157b92a>] sysenter_do_call+0x12/0x3c
[   10.832101] Code: 15 74 6c 1c c2 00 ff 43 04 c7 43 08 00 00 00 00 c7 03 =
00 00 00 00 5b 5d c3 83 05 38 7b 1c c2 01 55 83 15 3c 7b 1c c2 00 89 e5 53 =
<8b> 08 89 c3 03 0c 95 b0 78 96 c1 74 4c 83 05 40 7b 1c c2 01 89
[   10.832101] EIP: [<c11e2149>] __flush_cpu_slab+0x12/0x6e SS:ESP 0068:c73=
4ddec
[   10.832101] CR2: 00000000c19d50e4
[   10.832101] ---[ end trace 7154dd145df01e40 ]---
[   10.832101] Kernel panic - not syncing: Fatal exception
[   10.832101] Rebooting in 10 seconds..
--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.7.0-rc1-00016-gb59d450"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.7.0-rc1 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
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
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
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
CONFIG_EXPERIMENTAL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_FHANDLE is not set
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set
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
CONFIG_KTIME_SCALAR=y
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
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_HAVE_UID16=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
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
# CONFIG_AIO is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_OPTPROBES=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
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
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_GENERIC_KERNEL_THREAD=y
CONFIG_GENERIC_KERNEL_EXECVE=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_REL=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
# CONFIG_MODULE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
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
CONFIG_IOSCHED_DEADLINE=m
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_BIGSMP is not set
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_WANT_INTEL_MID=y
CONFIG_X86_INTEL_MID=y
CONFIG_X86_MDFLD=y
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_32_NON_STANDARD is not set
CONFIG_X86_32_IRIS=m
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
CONFIG_LGUEST_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_PARAVIRT_DEBUG=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=5
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_XADD=y
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_CYRIX_32 is not set
CONFIG_CPU_SUP_AMD=y
# CONFIG_CPU_SUP_CENTAUR is not set
# CONFIG_CPU_SUP_TRANSMETA_32 is not set
# CONFIG_CPU_SUP_UMC_32 is not set
CONFIG_HPET_TIMER=y
CONFIG_APB_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=m
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=m
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_CLEANCACHE is not set
CONFIG_FRONTSWAP=y
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_SLEEP_DEBUG=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
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
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=m
# CONFIG_APM_IGNORE_USER_SUSPEND is not set
CONFIG_APM_DO_ENABLE=y
# CONFIG_APM_CPU_IDLE is not set
# CONFIG_APM_DISPLAY_BLANK is not set
# CONFIG_APM_ALLOW_INTS is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
CONFIG_PCIEAER_INJECT=m
# CONFIG_PCIEASPM is not set
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_DEBUG=y
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
# CONFIG_ALIX is not set
# CONFIG_NET5501 is not set
CONFIG_GEOS=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=m
CONFIG_PCMCIA=m
# CONFIG_PCMCIA_LOAD_CIS is not set
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
# CONFIG_YENTA_TI is not set
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
CONFIG_I82092=m
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=m
CONFIG_HOTPLUG_PCI_COMPAQ=m
# CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM is not set
# CONFIG_HOTPLUG_PCI_IBM is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=m
CONFIG_RAPIDIO=y
# CONFIG_RAPIDIO_TSI721 is not set
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
CONFIG_RAPIDIO_DMA_ENGINE=y
# CONFIG_RAPIDIO_DEBUG is not set
# CONFIG_RAPIDIO_TSI57X is not set
# CONFIG_RAPIDIO_CPS_XX is not set
# CONFIG_RAPIDIO_TSI568 is not set
CONFIG_RAPIDIO_CPS_GEN2=y
# CONFIG_RAPIDIO_TSI500 is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=m
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=m
CONFIG_XFRM_USER=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
CONFIG_IP_MULTIPLE_TABLES=y
# CONFIG_IP_ROUTE_MULTIPATH is not set
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
# CONFIG_IP_PNP_RARP is not set
# CONFIG_NET_IPIP is not set
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IPGRE=m
# CONFIG_NET_IPGRE_BROADCAST is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_NET_IPVTI is not set
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=m
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
# CONFIG_IPV6 is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=m

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
CONFIG_IP_DCCP_CCID2_DEBUG=y
# CONFIG_IP_DCCP_CCID3 is not set

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_NET_DCCPPROBE=m
# CONFIG_IP_SCTP is not set
CONFIG_RDS=m
# CONFIG_RDS_RDMA is not set
CONFIG_RDS_TCP=m
CONFIG_RDS_DEBUG=y
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
# CONFIG_L2TP_ETH is not set
CONFIG_STP=m
CONFIG_BRIDGE=m
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=m
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=m
CONFIG_LLC2=m
CONFIG_IPX=m
# CONFIG_IPX_INTERN is not set
# CONFIG_ATALK is not set
CONFIG_X25=m
# CONFIG_LAPB is not set
# CONFIG_WAN_ROUTER is not set
CONFIG_PHONET=m
CONFIG_IEEE802154=m
# CONFIG_MAC802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
CONFIG_NET_SCH_TEQL=m
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
CONFIG_NET_SCH_DSMARK=m
# CONFIG_NET_SCH_NETEM is not set
CONFIG_NET_SCH_DRR=m
# CONFIG_NET_SCH_MQPRIO is not set
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_CODEL=m
# CONFIG_NET_SCH_FQ_CODEL is not set
# CONFIG_NET_SCH_INGRESS is not set
CONFIG_NET_SCH_PLUG=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
# CONFIG_NET_EMATCH_NBYTE is not set
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
# CONFIG_NET_ACT_GACT is not set
CONFIG_NET_ACT_MIRRED=m
# CONFIG_NET_ACT_NAT is not set
CONFIG_NET_ACT_PEDIT=m
# CONFIG_NET_ACT_SIMP is not set
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
CONFIG_BATMAN_ADV=m
CONFIG_BATMAN_ADV_BLA=y
CONFIG_BATMAN_ADV_DEBUG=y
# CONFIG_OPENVSWITCH is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
CONFIG_NET_TCPPROBE=m
# CONFIG_NET_DROP_MONITOR is not set
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=m
CONFIG_AX25_DAMA_SLAVE=y
# CONFIG_NETROM is not set
CONFIG_ROSE=m

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
# CONFIG_6PACK is not set
CONFIG_BPQETHER=m
# CONFIG_BAYCOM_SER_FDX is not set
# CONFIG_BAYCOM_SER_HDX is not set
# CONFIG_YAM is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_CMTP=m
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
# CONFIG_BT_HCIUART_BCSP is not set
# CONFIG_BT_HCIUART_ATH3K is not set
# CONFIG_BT_HCIUART_LL is not set
# CONFIG_BT_HCIUART_3WIRE is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIDTL1 is not set
# CONFIG_BT_HCIBT3C is not set
# CONFIG_BT_HCIBLUECARD is not set
CONFIG_BT_HCIBTUART=m
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
# CONFIG_BT_MRVL_SDIO is not set
# CONFIG_BT_ATH3K is not set
CONFIG_BT_WILINK=m
CONFIG_AF_RXRPC=m
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=m
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
CONFIG_CFG80211_REG_DEBUG=y
CONFIG_CFG80211_CERTIFICATION_ONUS=y
# CONFIG_CFG80211_DEFAULT_PS is not set
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_LIB80211=m
CONFIG_LIB80211_CRYPT_WEP=m
CONFIG_LIB80211_CRYPT_CCMP=m
CONFIG_LIB80211_CRYPT_TKIP=m
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_PID=y
# CONFIG_MAC80211_RC_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT_PID=y
CONFIG_MAC80211_RC_DEFAULT="pid"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
CONFIG_MAC80211_MESSAGE_TRACING=y
CONFIG_MAC80211_DEBUG_MENU=y
CONFIG_MAC80211_NOINLINE=y
CONFIG_MAC80211_VERBOSE_DEBUG=y
# CONFIG_MAC80211_MLME_DEBUG is not set
# CONFIG_MAC80211_STA_DEBUG is not set
CONFIG_MAC80211_HT_DEBUG=y
# CONFIG_MAC80211_IBSS_DEBUG is not set
CONFIG_MAC80211_PS_DEBUG=y
CONFIG_MAC80211_MPL_DEBUG=y
# CONFIG_MAC80211_MPATH_DEBUG is not set
# CONFIG_MAC80211_MHWMP_DEBUG is not set
CONFIG_MAC80211_MESH_SYNC_DEBUG=y
CONFIG_MAC80211_TDLS_DEBUG=y
CONFIG_MAC80211_DEBUG_COUNTERS=y
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_RDMA is not set
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=m
CONFIG_CEPH_LIB_PRETTYDEBUG=y
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=m
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_IRQ=y
# CONFIG_DMA_SHARED_BUFFER is not set
# CONFIG_CMA is not set

#
# Bus devices
#
# CONFIG_OMAP_OCP2SCP is not set
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
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_NVME=m
# CONFIG_BLK_DEV_OSD is not set
CONFIG_BLK_DEV_SX8=m
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=y
CONFIG_BLK_DEV_HD=y
# CONFIG_BLK_DEV_RBD is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=m
CONFIG_AD525X_DPOT_I2C=m
CONFIG_AD525X_DPOT_SPI=m
CONFIG_IBM_ASM=m
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=m
# CONFIG_TIFM_7XX1 is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_HP_ILO=m
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=m
CONFIG_SENSORS_BH1770=m
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=m
# CONFIG_DS1682 is not set
# CONFIG_TI_DAC7512 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
CONFIG_BMP085_SPI=m
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=m
CONFIG_C2PORT=m
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
CONFIG_EEPROM_93XX46=m
CONFIG_CB710_CORE=m
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=m
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
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
# CONFIG_BLK_DEV_IDECS is not set
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=m
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
# CONFIG_BLK_DEV_PLATFORM is not set
CONFIG_BLK_DEV_CMD640=m
CONFIG_BLK_DEV_CMD640_ENHANCED=y
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_BLK_DEV_OFFBOARD=y
CONFIG_BLK_DEV_GENERIC=m
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
CONFIG_BLK_DEV_CMD64X=m
# CONFIG_BLK_DEV_TRIFLEX is not set
CONFIG_BLK_DEV_CS5520=m
# CONFIG_BLK_DEV_CS5530 is not set
CONFIG_BLK_DEV_CS5535=m
CONFIG_BLK_DEV_CS5536=m
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
CONFIG_BLK_DEV_SC1200=m
CONFIG_BLK_DEV_PIIX=m
CONFIG_BLK_DEV_IT8172=m
CONFIG_BLK_DEV_IT8213=m
CONFIG_BLK_DEV_IT821X=m
# CONFIG_BLK_DEV_NS87415 is not set
CONFIG_BLK_DEV_PDC202XX_OLD=m
CONFIG_BLK_DEV_PDC202XX_NEW=m
CONFIG_BLK_DEV_SVWKS=m
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
CONFIG_BLK_DEV_TRM290=m
# CONFIG_BLK_DEV_VIA82CXXX is not set
CONFIG_BLK_DEV_TC86C001=m
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
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=m
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=m
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=m
# CONFIG_SCSI_SRP_TGT_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
# CONFIG_ATA is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
# CONFIG_MULTICORE_RAID456 is not set
# CONFIG_MD_MULTIPATH is not set
CONFIG_MD_FAULTY=m
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=m
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
# CONFIG_DM_THIN_PROVISIONING is not set
# CONFIG_DM_MIRROR is not set
CONFIG_DM_RAID=m
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
CONFIG_TARGET_CORE=m
# CONFIG_TCM_IBLOCK is not set
# CONFIG_TCM_FILEIO is not set
# CONFIG_TCM_PSCSI is not set
CONFIG_LOOPBACK_TARGET=m
CONFIG_ISCSI_TARGET=m
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
CONFIG_I2O=m
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
# CONFIG_I2O_CONFIG is not set
# CONFIG_I2O_BUS is not set
# CONFIG_I2O_BLOCK is not set
# CONFIG_I2O_SCSI is not set
CONFIG_I2O_PROC=m
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
CONFIG_DUMMY=m
CONFIG_EQUALIZER=m
CONFIG_NET_FC=y
CONFIG_MII=m
# CONFIG_IFB is not set
CONFIG_NET_TEAM=m
CONFIG_NET_TEAM_MODE_BROADCAST=m
# CONFIG_NET_TEAM_MODE_ROUNDROBIN is not set
# CONFIG_NET_TEAM_MODE_ACTIVEBACKUP is not set
CONFIG_NET_TEAM_MODE_LOADBALANCE=m
# CONFIG_MACVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
CONFIG_RIONET=m
CONFIG_RIONET_TX_SIZE=128
CONFIG_RIONET_RX_SIZE=128
CONFIG_TUN=m
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=y
CONFIG_ARCNET=m
# CONFIG_ARCNET_1201 is not set
CONFIG_ARCNET_1051=m
# CONFIG_ARCNET_RAW is not set
# CONFIG_ARCNET_CAP is not set
# CONFIG_ARCNET_COM90xx is not set
# CONFIG_ARCNET_COM90xxIO is not set
CONFIG_ARCNET_RIM_I=m
# CONFIG_ARCNET_COM20020 is not set

#
# CAIF transport drivers
#
CONFIG_ETHERNET=y
CONFIG_MDIO=m
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_VENDOR_ATHEROS is not set
# CONFIG_NET_VENDOR_BROADCOM is not set
# CONFIG_NET_VENDOR_BROCADE is not set
CONFIG_NET_CALXEDA_XGMAC=m
CONFIG_NET_VENDOR_CHELSIO=y
CONFIG_CHELSIO_T1=m
# CONFIG_CHELSIO_T1_1G is not set
# CONFIG_CHELSIO_T3 is not set
CONFIG_CHELSIO_T4=m
CONFIG_CHELSIO_T4VF=m
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
# CONFIG_NET_VENDOR_DLINK is not set
# CONFIG_NET_VENDOR_EMULEX is not set
# CONFIG_NET_VENDOR_EXAR is not set
# CONFIG_NET_VENDOR_FUJITSU is not set
# CONFIG_NET_VENDOR_HP is not set
# CONFIG_NET_VENDOR_INTEL is not set
CONFIG_IP1000=m
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_SKGE=m
CONFIG_SKGE_DEBUG=y
CONFIG_SKGE_GENESIS=y
# CONFIG_SKY2 is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
# CONFIG_NET_VENDOR_MICREL is not set
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_ENC28J60 is not set
# CONFIG_NET_VENDOR_MYRI is not set
CONFIG_FEALNX=m
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_8390=y
CONFIG_PCMCIA_AXNET=m
# CONFIG_NE2K_PCI is not set
# CONFIG_PCMCIA_PCNET is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
CONFIG_PCH_GBE=m
# CONFIG_PCH_PTP is not set
# CONFIG_ETHOC is not set
CONFIG_NET_PACKET_ENGINE=y
CONFIG_HAMACHI=m
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=m
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
CONFIG_NETXEN_NIC=m
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_8139CP is not set
CONFIG_8139TOO=m
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
CONFIG_8139_OLD_RX_RESET=y
# CONFIG_R8169 is not set
# CONFIG_NET_VENDOR_RDC is not set
# CONFIG_NET_VENDOR_SEEQ is not set
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
CONFIG_SFC=m
CONFIG_SFC_MCDI_MON=y
CONFIG_SFC_SRIOV=y
CONFIG_SFC_PTP=y
CONFIG_NET_VENDOR_SMSC=y
CONFIG_PCMCIA_SMC91C92=m
# CONFIG_EPIC100 is not set
# CONFIG_SMSC9420 is not set
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
CONFIG_NET_VENDOR_TEHUTI=y
CONFIG_TEHUTI=m
# CONFIG_NET_VENDOR_TI is not set
CONFIG_NET_VENDOR_VIA=y
CONFIG_VIA_RHINE=m
# CONFIG_VIA_RHINE_MMIO is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_NET_VENDOR_WIZNET is not set
CONFIG_NET_VENDOR_XIRCOM=y
CONFIG_PCMCIA_XIRC2PS=m
# CONFIG_FDDI is not set
CONFIG_HIPPI=y
CONFIG_ROADRUNNER=m
CONFIG_ROADRUNNER_LARGE_RINGS=y
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
CONFIG_AMD_PHY=m
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
CONFIG_QSEMI_PHY=m
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
# CONFIG_BCM87XX_PHY is not set
CONFIG_ICPLUS_PHY=m
# CONFIG_REALTEK_PHY is not set
CONFIG_NATIONAL_PHY=m
CONFIG_STE10XP=m
CONFIG_LSI_ET1011C_PHY=m
CONFIG_MICREL_PHY=m
# CONFIG_MDIO_BITBANG is not set
# CONFIG_MICREL_KS8995MA is not set
CONFIG_PPP=m
CONFIG_PPP_BSDCOMP=m
# CONFIG_PPP_DEFLATE is not set
CONFIG_PPP_FILTER=y
# CONFIG_PPP_MPPE is not set
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPPOE=m
# CONFIG_PPTP is not set
# CONFIG_PPPOL2TP is not set
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
# CONFIG_SLIP is not set
CONFIG_SLHC=m

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_CDC_PHONET is not set
CONFIG_USB_IPHETH=m
CONFIG_WLAN=y
CONFIG_PCMCIA_RAYCS=m
# CONFIG_LIBERTAS_THINFIRM is not set
CONFIG_AIRO=m
CONFIG_ATMEL=m
# CONFIG_PCI_ATMEL is not set
CONFIG_PCMCIA_ATMEL=m
CONFIG_AT76C50X_USB=m
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
CONFIG_USB_ZD1201=m
# CONFIG_USB_NET_RNDIS_WLAN is not set
CONFIG_RTL8180=m
# CONFIG_RTL8187 is not set
CONFIG_ADM8211=m
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
CONFIG_ATH_COMMON=m
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
CONFIG_ATH9K_HW=m
CONFIG_ATH9K_COMMON=m
# CONFIG_ATH9K_BTCOEX_SUPPORT is not set
CONFIG_ATH9K=m
# CONFIG_ATH9K_PCI is not set
CONFIG_ATH9K_AHB=y
CONFIG_ATH9K_DEBUGFS=y
# CONFIG_ATH9K_DFS_CERTIFIED is not set
# CONFIG_ATH9K_MAC_DEBUG is not set
CONFIG_ATH9K_RATE_CONTROL=y
# CONFIG_ATH9K_HTC is not set
CONFIG_CARL9170=m
# CONFIG_CARL9170_LEDS is not set
CONFIG_CARL9170_DEBUGFS=y
CONFIG_CARL9170_WPC=y
CONFIG_CARL9170_HWRNG=y
# CONFIG_ATH6KL is not set
CONFIG_B43=m
CONFIG_B43_SSB=y
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
CONFIG_B43_PCMCIA=y
CONFIG_B43_SDIO=y
CONFIG_B43_PIO=y
CONFIG_B43_PHY_N=y
# CONFIG_B43_PHY_LP is not set
CONFIG_B43_PHY_HT=y
CONFIG_B43_LEDS=y
CONFIG_B43_HWRNG=y
CONFIG_B43_DEBUG=y
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMFMAC is not set
# CONFIG_HOSTAP is not set
CONFIG_IPW2100=m
CONFIG_IPW2100_MONITOR=y
CONFIG_IPW2100_DEBUG=y
# CONFIG_IPW2200 is not set
CONFIG_LIBIPW=m
CONFIG_LIBIPW_DEBUG=y
CONFIG_IWLWIFI=m
CONFIG_IWLDVM=m

#
# Debugging Options
#
CONFIG_IWLWIFI_DEBUG=y
# CONFIG_IWLWIFI_DEBUGFS is not set
CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE=y
# CONFIG_IWLWIFI_DEVICE_TRACING is not set
CONFIG_IWLWIFI_P2P=y
CONFIG_IWLWIFI_EXPERIMENTAL_MFP=y
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
CONFIG_LIBERTAS=m
# CONFIG_LIBERTAS_USB is not set
CONFIG_LIBERTAS_CS=m
CONFIG_LIBERTAS_SDIO=m
CONFIG_LIBERTAS_SPI=m
CONFIG_LIBERTAS_DEBUG=y
# CONFIG_LIBERTAS_MESH is not set
CONFIG_HERMES=m
# CONFIG_HERMES_PRISM is not set
CONFIG_HERMES_CACHE_FW_ON_INIT=y
# CONFIG_PLX_HERMES is not set
# CONFIG_TMD_HERMES is not set
# CONFIG_NORTEL_HERMES is not set
CONFIG_PCMCIA_HERMES=m
CONFIG_PCMCIA_SPECTRUM=m
CONFIG_ORINOCO_USB=m
CONFIG_P54_COMMON=m
CONFIG_P54_USB=m
# CONFIG_P54_PCI is not set
CONFIG_P54_SPI=m
# CONFIG_P54_SPI_DEFAULT_EEPROM is not set
CONFIG_P54_LEDS=y
# CONFIG_RT2X00 is not set
# CONFIG_RTL8192CE is not set
CONFIG_RTL8192SE=m
# CONFIG_RTL8192DE is not set
CONFIG_RTL8192CU=m
CONFIG_RTLWIFI=m
# CONFIG_RTLWIFI_DEBUG is not set
CONFIG_RTL8192C_COMMON=m
CONFIG_WL_TI=y
CONFIG_WL1251=m
# CONFIG_WL1251_SPI is not set
# CONFIG_WL1251_SDIO is not set
CONFIG_WL12XX=m
CONFIG_WL18XX=m
CONFIG_WLCORE=m
# CONFIG_WLCORE_SPI is not set
CONFIG_WLCORE_SDIO=m
CONFIG_WL12XX_PLATFORM_DATA=y
# CONFIG_ZD1211RW is not set
CONFIG_MWIFIEX=m
CONFIG_MWIFIEX_SDIO=m
# CONFIG_MWIFIEX_PCIE is not set
CONFIG_MWIFIEX_USB=m

#
# WiMAX Wireless Broadband devices
#
# CONFIG_WIMAX_I2400M_USB is not set
CONFIG_WAN=y
CONFIG_LANMEDIA=m
CONFIG_HDLC=m
# CONFIG_HDLC_RAW is not set
# CONFIG_HDLC_RAW_ETH is not set
CONFIG_HDLC_CISCO=m
# CONFIG_HDLC_FR is not set
CONFIG_HDLC_PPP=m

#
# X.25/LAPB support is disabled
#
# CONFIG_PCI200SYN is not set
CONFIG_WANXL=m
# CONFIG_WANXL_BUILD_FIRMWARE is not set
CONFIG_PC300TOO=m
CONFIG_FARSYNC=m
# CONFIG_DSCC4 is not set
CONFIG_DLCI=m
CONFIG_DLCI_MAX=8
CONFIG_SBNI=m
CONFIG_SBNI_MULTILINE=y
# CONFIG_IEEE802154_DRIVERS is not set
CONFIG_VMXNET3=m
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
CONFIG_ISDN_CAPI=m
# CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON is not set
CONFIG_CAPI_TRACE=y
CONFIG_ISDN_CAPI_MIDDLEWARE=y
# CONFIG_ISDN_CAPI_CAPI20 is not set

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
CONFIG_ISDN_DRV_AVMB1_B1PCI=m
CONFIG_ISDN_DRV_AVMB1_B1PCIV4=y
CONFIG_ISDN_DRV_AVMB1_B1PCMCIA=m
# CONFIG_ISDN_DRV_AVMB1_AVM_CS is not set
CONFIG_ISDN_DRV_AVMB1_T1PCI=m
# CONFIG_ISDN_DRV_AVMB1_C4 is not set
# CONFIG_CAPI_EICON is not set
# CONFIG_ISDN_DRV_GIGASET is not set
# CONFIG_HYSDN is not set
CONFIG_MISDN=m
CONFIG_MISDN_DSP=m
# CONFIG_MISDN_L1OIP is not set

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=m
CONFIG_MISDN_HFCMULTI=m
# CONFIG_MISDN_HFCUSB is not set
CONFIG_MISDN_AVMFRITZ=m
CONFIG_MISDN_SPEEDFAX=m
CONFIG_MISDN_INFINEON=m
# CONFIG_MISDN_W6692 is not set
# CONFIG_MISDN_NETJET is not set
CONFIG_MISDN_IPAC=m
CONFIG_MISDN_ISAR=m

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
# CONFIG_INPUT_SPARSEKMAP is not set
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=m
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5520 is not set
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ADP5589=m
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
CONFIG_KEYBOARD_QT2160=m
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_GPIO=m
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
CONFIG_KEYBOARD_MATRIX=m
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
CONFIG_KEYBOARD_NEWTON=m
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_STMPE=m
CONFIG_KEYBOARD_OMAP4=m
# CONFIG_KEYBOARD_TWL4030 is not set
CONFIG_KEYBOARD_XTKBD=m
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
CONFIG_MOUSE_BCM5974=m
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=m
# CONFIG_TOUCHSCREEN_ADS7846 is not set
# CONFIG_TOUCHSCREEN_AD7877 is not set
CONFIG_TOUCHSCREEN_AD7879=m
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
CONFIG_TOUCHSCREEN_AD7879_SPI=m
CONFIG_TOUCHSCREEN_ATMEL_MXT=m
CONFIG_TOUCHSCREEN_AUO_PIXCIR=m
CONFIG_TOUCHSCREEN_BU21013=m
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_DA9034 is not set
# CONFIG_TOUCHSCREEN_DA9052 is not set
CONFIG_TOUCHSCREEN_DYNAPRO=m
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
CONFIG_TOUCHSCREEN_EGALAX=m
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=m
CONFIG_TOUCHSCREEN_GUNZE=m
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=m
CONFIG_TOUCHSCREEN_MAX11801=m
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
CONFIG_TOUCHSCREEN_MTOUCH=m
CONFIG_TOUCHSCREEN_INEXIO=m
# CONFIG_TOUCHSCREEN_INTEL_MID is not set
CONFIG_TOUCHSCREEN_MK712=m
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
CONFIG_TOUCHSCREEN_EDT_FT5X06=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
CONFIG_TOUCHSCREEN_TOUCHWIN=m
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_WM831X is not set
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
CONFIG_TOUCHSCREEN_MC13783=m
# CONFIG_TOUCHSCREEN_USB_EGALAX is not set
# CONFIG_TOUCHSCREEN_USB_PANJIT is not set
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
# CONFIG_TOUCHSCREEN_USB_GOTOP is not set
# CONFIG_TOUCHSCREEN_USB_JASTEC is not set
# CONFIG_TOUCHSCREEN_USB_ELO is not set
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
# CONFIG_TOUCHSCREEN_USB_NEXIO is not set
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
CONFIG_TOUCHSCREEN_TOUCHIT213=m
CONFIG_TOUCHSCREEN_TSC_SERIO=m
CONFIG_TOUCHSCREEN_TSC2005=m
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
CONFIG_TOUCHSCREEN_STMPE=m
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=m
# CONFIG_CYCLADES is not set
CONFIG_MOXA_INTELLIO=m
CONFIG_MOXA_SMARTIO=m
CONFIG_SYNCLINK=m
# CONFIG_SYNCLINKMP is not set
CONFIG_SYNCLINK_GT=m
CONFIG_NOZOMI=m
CONFIG_ISI=m
# CONFIG_N_HDLC is not set
CONFIG_N_GSM=m
# CONFIG_TRACE_ROUTER is not set
CONFIG_TRACE_SINK=m
# CONFIG_DEVKMEM is not set
CONFIG_STALDRV=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=m
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_KGDB_NMI is not set
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
CONFIG_SERIAL_MFD_HSU=m
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_CONSOLE_POLL=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_TIMBERDALE=m
CONFIG_SERIAL_ALTERA_JTAGUART=m
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_IFX6X60 is not set
CONFIG_SERIAL_PCH_UART=m
CONFIG_SERIAL_XILINX_PS_UART=m
CONFIG_TTY_PRINTK=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=m
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
# CONFIG_HW_RANDOM_GEODE is not set
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=m
# CONFIG_NVRAM is not set
CONFIG_R3964=m
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=m
# CONFIG_CARDMAN_4040 is not set
CONFIG_IPWIRELESS=m
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=m
CONFIG_I2C_MUX_PCA9541=m
CONFIG_I2C_MUX_PCA954x=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=m
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
CONFIG_I2C_AMD8111=m
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=m
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_DESIGNWARE_CORE=m
CONFIG_I2C_DESIGNWARE_PCI=m
CONFIG_I2C_EG20T=m
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=m
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_SCx200_ACB=m
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=m
CONFIG_SPI_BITBANG=m
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_OC_TINY is not set
CONFIG_SPI_PXA2XX=m
CONFIG_SPI_PXA2XX_PCI=y
# CONFIG_SPI_SC18IS602 is not set
CONFIG_SPI_TOPCLIFF_PCH=m
# CONFIG_SPI_XCOMM is not set
CONFIG_SPI_XILINX=m
CONFIG_SPI_DESIGNWARE=m
# CONFIG_SPI_DW_PCI is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=m
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=m

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=m
# CONFIG_GPIO_DA9052 is not set

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
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=m
# CONFIG_GPIO_RC5T583 is not set
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_STMPE=y
# CONFIG_GPIO_TWL4030 is not set
# CONFIG_GPIO_WM831X is not set
# CONFIG_GPIO_WM8994 is not set
CONFIG_GPIO_ADP5520=m
CONFIG_GPIO_ADP5588=m

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=m
CONFIG_GPIO_AMD8111=m
CONFIG_GPIO_LANGWELL=y
CONFIG_GPIO_PCH=m
# CONFIG_GPIO_ML_IOH is not set
CONFIG_GPIO_TIMBERDALE=y
CONFIG_GPIO_RDC321X=m

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
CONFIG_GPIO_MCP23S08=m
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_74X164 is not set

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=m
CONFIG_GPIO_MSIC=y
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=m
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
CONFIG_TEST_POWER=m
# CONFIG_BATTERY_88PM860X is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=m
CONFIG_BATTERY_SBS=m
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9030=m
# CONFIG_BATTERY_DA9052 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_PCF50633 is not set
# CONFIG_BATTERY_INTEL_MID is not set
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_TWL4030=m
CONFIG_CHARGER_LP8727=m
# CONFIG_CHARGER_GPIO is not set
CONFIG_CHARGER_SMB347=m
CONFIG_POWER_AVS=y
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7314=m
CONFIG_SENSORS_AD7414=m
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=m
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=m
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_ASB100=m
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_DA9052_ADC is not set
CONFIG_SENSORS_I5K_AMB=m
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=m
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM70=m
CONFIG_SENSORS_LM73=m
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=m
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=m
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=m
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
CONFIG_SENSORS_LTC4245=m
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=m
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX16065=m
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=m
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=m
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=m
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NTC_THERMISTOR=m
CONFIG_SENSORS_PC87360=m
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=m
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_ADS7871=m
CONFIG_SENSORS_AMC6821=m
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=m
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=m
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_WM831X is not set
CONFIG_SENSORS_APPLESMC=m
# CONFIG_SENSORS_MC13783_ADC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_BLOCKIO=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
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
CONFIG_MFD_CORE=y
CONFIG_MFD_88PM860X=y
CONFIG_MFD_88PM800=m
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_SM501=m
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
CONFIG_MFD_LM3533=m
# CONFIG_TPS6105X is not set
CONFIG_TPS65010=m
CONFIG_TPS6507X=m
CONFIG_MFD_TPS65217=m
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_MADC is not set
# CONFIG_MFD_TWL4030_AUDIO is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
# CONFIG_STMPE_SPI is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_SMSC is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_SEC_CORE=y
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_MFD_PCF50633=m
# CONFIG_PCF50633_ADC is not set
# CONFIG_PCF50633_GPIO is not set
CONFIG_MFD_MC13783=m
CONFIG_MFD_MC13XXX=m
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_MFD_MC13XXX_I2C=m
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
# CONFIG_AB3100_OTP is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_TIMBERDALE=m
CONFIG_LPC_SCH=m
CONFIG_LPC_ICH=m
CONFIG_MFD_RDC321X=m
CONFIG_MFD_JANZ_CMODIO=m
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_WL1273_CORE=m
CONFIG_MFD_TPS65090=y
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_INTEL_MSIC=y
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_PALMAS is not set
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=m
# CONFIG_VIDEO_V4L2_SUBDEV_API is not set
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set

#
# Media drivers
#
CONFIG_RC_CORE=m
CONFIG_RC_MAP=m
CONFIG_RC_DECODERS=y
CONFIG_LIRC=m
CONFIG_IR_LIRC_CODEC=m
# CONFIG_IR_NEC_DECODER is not set
# CONFIG_IR_RC5_DECODER is not set
# CONFIG_IR_RC6_DECODER is not set
# CONFIG_IR_JVC_DECODER is not set
CONFIG_IR_SONY_DECODER=m
# CONFIG_IR_RC5_SZ_DECODER is not set
# CONFIG_IR_SANYO_DECODER is not set
# CONFIG_IR_MCE_KBD_DECODER is not set
# CONFIG_RC_DEVICES is not set
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_SI470X=y
CONFIG_USB_SI470X=m
CONFIG_I2C_SI470X=m
CONFIG_USB_MR800=m
# CONFIG_USB_DSBR is not set
CONFIG_RADIO_SHARK2=m
# CONFIG_I2C_SI4713 is not set
# CONFIG_RADIO_SI4713 is not set
# CONFIG_USB_KEENE is not set
# CONFIG_RADIO_TEA5764 is not set
CONFIG_RADIO_SAA7706H=m
CONFIG_RADIO_TEF6862=m
# CONFIG_RADIO_TIMBERDALE is not set
# CONFIG_RADIO_WL1273 is not set

#
# Texas Instruments WL128x FM driver (ST based)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_VIDEO_IR_I2C=m

#
# Audio decoders, processors and mixers
#

#
# RDS decoders
#

#
# Video decoders
#

#
# Video and audio decoders
#

#
# MPEG video encoders
#

#
# Video encoders
#

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#

#
# Miscelaneous helper chips
#

#
# Sensors used on soc_camera driver
#
# CONFIG_MEDIA_ATTACH is not set
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MC44S803=m

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

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
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=m
CONFIG_SOUND=m
# CONFIG_SOUND_OSS_CORE is not set
# CONFIG_SND is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=m
# CONFIG_HIDRAW is not set
CONFIG_UHID=m
CONFIG_HID_GENERIC=m

#
# Special HID drivers
#
CONFIG_HID_APPLE=m
CONFIG_HID_ELECOM=m
CONFIG_HID_MAGICMOUSE=m
# CONFIG_HID_PS3REMOTE is not set
CONFIG_HID_TIVO=m
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=m
# CONFIG_HID_WIIMOTE_EXT is not set

#
# USB HID support
#
# CONFIG_USB_HID is not set
# CONFIG_HID_PID is not set

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
CONFIG_USB_MOUSE=m
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=m
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=m
CONFIG_USB_WUSB=m
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
CONFIG_USB_XHCI_HCD=m
CONFIG_USB_XHCI_HCD_DEBUGGING=y
# CONFIG_USB_EHCI_HCD is not set
CONFIG_USB_OXU210HP_HCD=m
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_HCD_SSB is not set
CONFIG_USB_OHCI_HCD_PLATFORM=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_U132_HCD is not set
CONFIG_USB_SL811_HCD=m
CONFIG_USB_SL811_HCD_ISO=y
# CONFIG_USB_SL811_CS is not set
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_WHCI_HCD=m
# CONFIG_USB_HWA_HCD is not set
CONFIG_USB_HCD_SSB=m
# CONFIG_USB_CHIPIDEA is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=m
CONFIG_REALTEK_AUTOPM=y
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
CONFIG_USB_STORAGE_KARMA=m
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
# CONFIG_USB_UAS is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=m
# CONFIG_USB_LCD is not set
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=m
CONFIG_USB_TEST=m
CONFIG_USB_ISIGHTFW=m
CONFIG_USB_YUREX=m
# CONFIG_USB_EZUSB_FX2 is not set

#
# USB Physical Layer drivers
#
# CONFIG_OMAP_USB2 is not set
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=m
CONFIG_NOP_USB_XCEIV=m
CONFIG_UWB=m
# CONFIG_UWB_HWA is not set
CONFIG_UWB_WHCI=m
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
CONFIG_SDIO_UART=m
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_WBSD is not set
CONFIG_MMC_TIFM_SD=m
# CONFIG_MMC_SDRICOH_CS is not set
CONFIG_MMC_CB710=m
CONFIG_MMC_VIA_SDMMC=m
# CONFIG_MMC_VUB300 is not set
# CONFIG_MMC_USHC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
CONFIG_LEDS_88PM860X=m
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3533 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=m
# CONFIG_LEDS_PCA9633 is not set
CONFIG_LEDS_WM831X_STATUS=m
CONFIG_LEDS_DA903X=m
CONFIG_LEDS_DA9052=m
CONFIG_LEDS_DAC124S085=m
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=m
CONFIG_LEDS_LT3593=m
CONFIG_LEDS_ADP5520=m
CONFIG_LEDS_MC13783=m
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_LM355x is not set
CONFIG_LEDS_OT200=m
CONFIG_LEDS_BLINKM=m
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_GPIO=m
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
# CONFIG_INFINIBAND_AMSO1100 is not set
# CONFIG_INFINIBAND_CXGB4 is not set
# CONFIG_MLX4_INFINIBAND is not set
# CONFIG_INFINIBAND_NES is not set
# CONFIG_INFINIBAND_OCRDMA is not set
# CONFIG_INFINIBAND_IPOIB is not set
CONFIG_INFINIBAND_SRP=m
# CONFIG_INFINIBAND_SRPT is not set
CONFIG_INFINIBAND_ISER=m
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_PROC is not set
# CONFIG_RTC_INTF_DEV is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM860X=m
# CONFIG_RTC_DRV_88PM80X is not set
# CONFIG_RTC_DRV_DS1307 is not set
CONFIG_RTC_DRV_DS1374=m
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_MAX6900=m
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8563=m
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
CONFIG_RTC_DRV_BQ32K=m
CONFIG_RTC_DRV_TWL4030=m
# CONFIG_RTC_DRV_RC5T583 is not set
CONFIG_RTC_DRV_S35390A=m
CONFIG_RTC_DRV_FM3130=m
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m
CONFIG_RTC_DRV_EM3027=m
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=m
CONFIG_RTC_DRV_M41T94=m
CONFIG_RTC_DRV_DS1305=m
# CONFIG_RTC_DRV_DS1390 is not set
CONFIG_RTC_DRV_MAX6902=m
# CONFIG_RTC_DRV_R9701 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_DS3234 is not set
CONFIG_RTC_DRV_PCF2123=m

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_VRTC=m
# CONFIG_RTC_DRV_DS1286 is not set
CONFIG_RTC_DRV_DS1511=m
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_DA9052 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=m
# CONFIG_RTC_DRV_DS2404 is not set
CONFIG_RTC_DRV_WM831X=m
CONFIG_RTC_DRV_PCF50633=m
# CONFIG_RTC_DRV_AB3100 is not set

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MC13XXX is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
# CONFIG_DMADEVICES_VDEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=m
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=m
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
CONFIG_ET131X=m
# CONFIG_SLICOSS is not set
# CONFIG_USBIP_CORE is not set
# CONFIG_W35UND is not set
# CONFIG_PRISM2_USB is not set
# CONFIG_ECHO is not set
CONFIG_COMEDI=m
CONFIG_COMEDI_DEBUG=y
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
CONFIG_COMEDI_MISC_DRIVERS=y
# CONFIG_COMEDI_KCOMEDILIB is not set
CONFIG_COMEDI_TEST=m
CONFIG_COMEDI_PARPORT=m
# CONFIG_COMEDI_SERIAL2002 is not set
# CONFIG_COMEDI_SKEL is not set
# CONFIG_COMEDI_PCI_DRIVERS is not set
# CONFIG_COMEDI_PCMCIA_DRIVERS is not set
CONFIG_COMEDI_USB_DRIVERS=y
CONFIG_COMEDI_DT9812=m
CONFIG_COMEDI_USBDUX=m
# CONFIG_COMEDI_USBDUXFAST is not set
# CONFIG_COMEDI_USBDUXSIGMA is not set
# CONFIG_COMEDI_VMK80XX is not set
# CONFIG_COMEDI_8255 is not set
CONFIG_COMEDI_FC=m
# CONFIG_ASUS_OLED is not set
CONFIG_R8187SE=m
# CONFIG_RTL8192U is not set
CONFIG_RTLLIB=m
CONFIG_RTLLIB_CRYPTO_CCMP=m
CONFIG_RTLLIB_CRYPTO_TKIP=m
CONFIG_RTLLIB_CRYPTO_WEP=m
CONFIG_RTL8192E=m
# CONFIG_R8712U is not set
CONFIG_RTS_PSTOR=m
# CONFIG_RTS_PSTOR_DEBUG is not set
CONFIG_RTS5139=m
CONFIG_RTS5139_DEBUG=y
# CONFIG_TRANZPORT is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
CONFIG_DX_SEP=m
# CONFIG_ZRAM is not set
CONFIG_ZSMALLOC=m
# CONFIG_WLAGS49_H2 is not set
CONFIG_WLAGS49_H25=m
# CONFIG_CRYSTALHD is not set
CONFIG_CXT1E1=m
CONFIG_SBE_PMCC4_NCOMM=y
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_SBE_2T3E3=m
# CONFIG_USB_ENESTORAGE is not set
CONFIG_BCM_WIMAX=m
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
CONFIG_STAGING_MEDIA=y
# CONFIG_VIDEO_DT3155 is not set
# CONFIG_LIRC_STAGING is not set

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
CONFIG_ANDROID_LOGGER=m
# CONFIG_ANDROID_TIMED_OUTPUT is not set
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
CONFIG_ANDROID_INTF_ALARM_DEV=y
CONFIG_PHONE=m
CONFIG_PHONE_IXJ=m
CONFIG_PHONE_IXJ_PCMCIA=m
# CONFIG_USB_WPAN_HCD is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_WIMAX_GDM72XX is not set
CONFIG_CSR_WIFI=m
CONFIG_NET_VENDOR_SILICOM=y
# CONFIG_SBYPASS is not set
# CONFIG_BPCTL is not set
# CONFIG_CED1401 is not set
# CONFIG_DGRP is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
CONFIG_INTEL_SCU_IPC=y
# CONFIG_INTEL_SCU_IPC_UTIL is not set
# CONFIG_GPIO_INTEL_PMIC is not set
# CONFIG_INTEL_MID_POWER_BUTTON is not set
# CONFIG_INTEL_MFLD_THERMAL is not set
# CONFIG_INTEL_IPS is not set
CONFIG_IBM_RTL=m
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_DW_APB_TIMER=y
CONFIG_IOMMU_SUPPORT=y
# CONFIG_INTEL_IOMMU is not set

#
# Remoteproc drivers (EXPERIMENTAL)
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers (EXPERIMENTAL)
#
# CONFIG_VIRT_DRIVERS is not set
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
# CONFIG_PWM_TWL6030 is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=m
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=m
CONFIG_ISCSI_IBFT_FIND=y
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
# CONFIG_EXT4_FS_XATTR is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=m
CONFIG_OCFS2_FS=m
# CONFIG_OCFS2_FS_O2CB is not set
CONFIG_OCFS2_FS_STATS=y
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
CONFIG_OCFS2_DEBUG_FS=y
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=m
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=m
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
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
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
CONFIG_FSCACHE_DEBUG=y
CONFIG_FSCACHE_OBJECT_LIST=y
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
CONFIG_CACHEFILES_HISTOGRAM=y

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
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=m
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_LOGFS=m
CONFIG_CRAMFS=m
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=m
CONFIG_OMFS_FS=m
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=m
CONFIG_QNX6FS_FS=m
# CONFIG_QNX6FS_DEBUG is not set
CONFIG_ROMFS_FS=m
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=m
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
CONFIG_UFS_FS_WRITE=y
# CONFIG_UFS_DEBUG is not set
CONFIG_EXOFS_FS=m
# CONFIG_EXOFS_DEBUG is not set
CONFIG_ORE=m
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V2=m
CONFIG_NFS_V3=m
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=m
CONFIG_NFS_SWAP=y
# CONFIG_NFS_V4_1 is not set
# CONFIG_NFS_FSCACHE is not set
CONFIG_NFS_USE_LEGACY_DNS=y
CONFIG_NFS_DEBUG=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
# CONFIG_NFSD_FAULT_INJECTION is not set
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_XPRT_RDMA=m
CONFIG_SUNRPC_SWAP=y
CONFIG_SUNRPC_DEBUG=y
CONFIG_CEPH_FS=m
CONFIG_CIFS=m
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_UPCALL is not set
# CONFIG_CIFS_XATTR is not set
CONFIG_CIFS_DEBUG2=y
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_SMB2 is not set
CONFIG_CIFS_FSCACHE=y
CONFIG_NCP_FS=m
CONFIG_NCPFS_PACKET_SIGNING=y
# CONFIG_NCPFS_IOCTL_LOCKING is not set
CONFIG_NCPFS_STRONG=y
# CONFIG_NCPFS_NFS_NS is not set
# CONFIG_NCPFS_OS2_NS is not set
CONFIG_NCPFS_SMALLDOS=y
# CONFIG_NCPFS_NLS is not set
# CONFIG_NCPFS_EXTRAS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_9P_FS=y
CONFIG_9P_FS_POSIX_ACL=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=m
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=m
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=m
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=m
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=m
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=m
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
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
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_HIGHMEM=y
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_WRITECOUNT=y
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_LIST is not set
CONFIG_TEST_LIST_SORT=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_BLOCK_EXT_DEVT=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_LKDTM=m
CONFIG_NOTIFIER_ERROR_INJECTION=m
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
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
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
# CONFIG_EVENT_POWER_TRACING_DEPRECATED is not set
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_IRQSOFF_TRACER=y
# CONFIG_SCHED_TRACER is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_KPROBE_EVENT=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_EVENT_TRACE_TEST_SYSCALLS=y
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_DYNAMIC_DEBUG=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
# CONFIG_KGDB_TESTS is not set
CONFIG_KGDB_LOW_LEVEL_TRAP=y
CONFIG_KGDB_KDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_TEST_KSTRTOX is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
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
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=m
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=m
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
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
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
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
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=m
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_586=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_586=m
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_586=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=m
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_USER_API=m
CONFIG_CRYPTO_USER_API_HASH=m
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
# CONFIG_CRYPTO_DEV_GEODE is not set
CONFIG_CRYPTO_DEV_HIFN_795X=m
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_VHOST_NET is not set
# CONFIG_TCM_VHOST is not set
# CONFIG_LGUEST is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_BITREVERSE=y
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
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_CRC8=m
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=m
CONFIG_DDR=y

--gKMricLos+KVdGMg--
