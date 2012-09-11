Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab2IKGaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 02:30:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:29515 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952Ab2IKGaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 02:30:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,401,1344236400"; 
   d="scan'208";a="220584599"
Date: Tue, 11 Sep 2012 14:30:00 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: WARNING at lockdep.c:956 __bfs()
Message-ID: <20120911063000.GA28264@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

An one-shot warning that's rather hard to reproduce..

[   40.522075] ------------[ cut here ]------------
[   40.522796] WARNING: at /c/kernel-tests/src/i386/kernel/lockdep.c:956 __bfs+0x1a8/0x1d0()
[   40.523584] Modules linked in:
[   40.523584] Pid: 1, comm: init Not tainted 3.6.0-rc4-00155-gcaa631e #190
[   40.523584] Call Trace:
[   40.523584]  [<c1029fb4>] warn_slowpath_common+0x64/0x80
[   40.523584]  [<c107d2a8>] ? __bfs+0x1a8/0x1d0
[   40.523584]  [<c107d2a8>] ? __bfs+0x1a8/0x1d0
[   40.523584]  [<c1029ff2>] warn_slowpath_null+0x22/0x30
[   40.523584]  [<c107d2a8>] __bfs+0x1a8/0x1d0
[   40.523584]  [<c107d020>] ? noop_count+0x10/0x10
[   40.523584]  [<c107f063>] check_usage_backwards+0x63/0xe0
[   40.523584]  [<c100e8b0>] ? save_stack_trace+0x30/0x50
[   40.523584]  [<c107f000>] ? check_usage_forwards+0xe0/0xe0
[   40.523584]  [<c107f7f9>] mark_lock+0x139/0x260
[   40.523584]  [<c107f000>] ? check_usage_forwards+0xe0/0xe0
[   40.523584]  [<c107fe50>] __lock_acquire+0x530/0x15f0
[   40.523584]  [<c1128e10>] ? shrink_dcache_parent+0x60/0x2d0
[   40.523584]  [<c11b8fde>] ? do_raw_spin_lock+0x16e/0x190
[   40.523584]  [<c1081470>] lock_acquire+0x80/0x190
[   40.523584]  [<c112850d>] ? d_drop+0x1d/0x40
[   40.523584]  [<c129f263>] _raw_spin_lock+0x43/0x50
[   40.523584]  [<c112850d>] ? d_drop+0x1d/0x40
[   40.523584]  [<c112850d>] d_drop+0x1d/0x40
[   40.523584]  [<c116718f>] proc_flush_task+0x8f/0x190
[   40.523584]  [<c102e444>] ? release_task+0x94/0x590
[   40.523584]  [<c102e46a>] release_task+0xba/0x590
[   40.523584]  [<c102e3c0>] ? release_task+0x10/0x590
[   40.523584]  [<c10eff51>] ? might_fault+0x91/0xa0
[   40.523584]  [<c102f6d7>] wait_consider_task.part.24+0xd97/0xed0
[   40.523584]  [<c102f008>] ? wait_consider_task.part.24+0x6c8/0xed0
[   40.523584]  [<c102f8f0>] do_wait+0xe0/0x300
[   40.523584]  [<c110eec0>] ? do_sync_write+0xd0/0xd0
[   40.523584]  [<c1030de0>] sys_waitid+0x70/0x170
[   40.523584]  [<c102dd80>] ? task_stopped_code+0x50/0x50
[   40.523584]  [<c12a74c3>] sysenter_do_call+0x12/0x3c

Thanks,
Fengguang

--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-bay-3490-2012-09-10-18-11-45-3.6.0-rc4-00155-gcaa631e-190"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Linux version 3.6.0-rc4-00155-gcaa631e (kbuild@lkp-mb01) (gc=
c version 4.7.1 (GCC) ) #190 SMP Mon Sep 10 18:10:17 CST 2012
[    0.000000] KERNEL supported cpus:
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
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
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at =
[c00fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x01bfffff]
[    0.000000] Base memory trampoline at [c008f000] 8f000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x01bbd0=
00-0x01bfffff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 129128(98%)
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
[    0.000000] kvm-clock: cpu 0, msr 0:1479f81, boot clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00010000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000] free_area_init_node: node 0, pgdat c13f2480, node_mem_map cd=
cbf280
[    0.000000]   Normal zone: 640 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 64769 pages, LIFO batch:15
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
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 13 pages/cpu @cdca5000 s30304 r0 d22944 u53=
248
[    0.000000] pcpu-alloc: s30304 r0 d22944 u53248 alloc=3D13*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:dcabf81, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr dca7880
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64769
[    0.000000] Kernel command line: trinity=3D2m hung_task_panic=3D1 rcutre=
e.rcu_cpu_stall_timeout=3D100 branch=3Dasoc/for-next log_buf_len=3D8M ignor=
e_loglevel debug sched_debug apic=3Ddebug dynamic_printk sysrq_always_enabl=
ed panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=
=3Dnormal  root=3D/dev/ram0 rw link=3Dvmlinuz-2012-09-10-18-11-04-asoc:for-=
next:caa631e-caa631e-i386-randconfig-m041-9-bay BOOT_IMAGE=3Dkernel-tests/k=
ernels/i386-randconfig-m041/caa631e/vmlinuz-3.6.0-rc4-00155-gcaa631e
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 215068k/262136k available (2721k kernel code, 46568k=
 reserved, 1440k data, 424k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd36000 - 0xfffff000   (2852 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff7fe000   ( 752 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc1411000 - 0xc147b000   ( 424 kB)
[    0.000000]       .data : 0xc12a8460 - 0xc14106c0   (1440 kB)
[    0.000000]       .text : 0xc1000000 - 0xc12a8460   (2721 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D2, Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:2304 nr_irqs:56 16
[    0.000000] CPU 0 irqstacks, hard=3Dcd804000 soft=3Dcd806000
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
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2992.500 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.004000] Calibrating delay loop (skipped) preset value.. 5985.00 Bogo=
MIPS (lpj=3D11970000)
[    0.004000] pid_max: default: 32768 minimum: 301
[    0.004211] Security Framework initialized
[    0.004930] Mount-cache hash table entries: 512
[    0.007902] mce: CPU supports 10 MCE banks
[    0.008014] mce: unknown CPU type - not enabling MCE support
[    0.008828] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.008828] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.008828] tlb_flushall_shift is 0xffffffff
[    0.015125] debug: unmapping init [mem 0xc147b000-0xc147dfff]
[    0.016010] ACPI: Core revision 20120711
[    0.046999] ftrace: allocating 11057 entries in 22 pages
[    0.052528] Getting VERSION: 50014
[    0.053025] Getting VERSION: 50014
[    0.053514] Getting ID: 0
[    0.053890] Getting ID: f000000
[    0.054342] Getting LVT0: 8700
[    0.056014] Getting LVT1: 8400
[    0.056449] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.057273] enabled ExtINT on CPU#0
[    0.058876] ENABLING IO-APIC IRQs
[    0.059342] init IO_APIC IRQs
[    0.060010]  apic 2 pin 0 not connected
[    0.060567] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.061678] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.062790] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.063900] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.064032] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.065136] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.066236] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.068032] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.069134] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.070242] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.071362] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.072033] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.073169] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.074286] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.076032] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.077149]  apic 2 pin 16 not connected
[    0.077691]  apic 2 pin 17 not connected
[    0.078229]  apic 2 pin 18 not connected
[    0.078772]  apic 2 pin 19 not connected
[    0.079313]  apic 2 pin 20 not connected
[    0.080008]  apic 2 pin 21 not connected
[    0.080555]  apic 2 pin 22 not connected
[    0.081096]  apic 2 pin 23 not connected
[    0.081790] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.082794] smpboot: CPU0: GenuineIntel Common KVM processor stepping 01
[    0.084009] Using local APIC timer interrupts.
[    0.084009] calibrating APIC timer ...
[    0.088005] ... lapic delta =3D 6250027
[    0.088005] ... PM-Timer delta =3D 357956
[    0.088005] ... PM-Timer result ok
[    0.088005] ..... delta 6250027
[    0.088005] ..... mult: 268419839
[    0.088005] ..... calibration result: 4000017
[    0.088005] ..... CPU clock speed is 2992.2050 MHz.
[    0.088005] ..... host bus clock speed is 1000.0017 MHz.
[    0.088073] Performance Events:=20
[    0.091311] SMP alternatives: lockdep: fixing up alternatives
[    0.092092] CPU 1 irqstacks, hard=3Dcd8d0000 soft=3Dcd8d2000
[    0.093057] smpboot: Booting Node   0, Processors  #1 OK
[    0.004000] Initializing CPU#1
[    0.004000] kvm-clock: cpu 1, msr 0:dcb8f81, secondary cpu clock
[    0.004000] masked ExtINT on CPU#1
[    0.108041] KVM setup async PF for cpu 1
[    0.108054] Brought up 2 CPUs
[    0.108057] smpboot: Total of 2 processors activated (11970.00 BogoMIPS)
[    0.108478] CPU0 attaching sched-domain:
[    0.108481]  domain 0: span 0-1 level CPU
[    0.108484]   groups: 0 1
[    0.108491] CPU1 attaching sched-domain:
[    0.108493]  domain 0: span 0-1 level CPU
[    0.108495]   groups: 1 0
[    0.112335] device: 'platform': device_add
[    0.112569] bus: 'platform': registered
[    0.112654] bus: 'cpu': registered
[    0.112708] device: 'cpu': device_add
[    0.115316] NET: Registered protocol family 16
[    0.115486] device class 'bdi': registering
[    0.115750] device class 'pci_bus': registering
[    0.115927] bus: 'pci': registered
[    0.115938] device: 'rapidio': device_add
[    0.116107] bus: 'rapidio': registered
[    0.116111] device class 'tty': registering
[    0.116350] bus: 'eisa': registered
[    0.116351] EISA bus registered
[    0.108041] kvm-stealtime: cpu 1, msr dcb4880
[    0.123585] ACPI: bus type pci registered
[    0.123585] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=3D0
[    0.123585] PCI: Using configuration type 1 for base access
[    0.123585] device: 'cpu0': device_add
[    0.124034] bus: 'cpu': add device cpu0
[    0.124814] device: 'cpu1': device_add
[    0.125352] bus: 'cpu': add device cpu1
[    0.129324] device: 'default': device_add
[    0.132828] bio: create slab <bio-0> at 0
[    0.132828] device class 'block': registering
[    0.135342] ACPI: Added _OSI(Module Device)
[    0.135342] ACPI: Added _OSI(Processor Device)
[    0.135342] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.135342] ACPI: Added _OSI(Processor Aggregator Device)
[    0.135342] ACPI: EC: Look up EC in DSDT
[    0.195284] ACPI: Interpreter enabled
[    0.195812] ACPI: (supports S0 S5)
[    0.196234] ACPI: Using IOAPIC for interrupt routing
[    0.197183] bus: 'acpi': registered
[    0.197663] bus: 'acpi': add driver power
[    0.198472] device: 'LNXSYSTM:00': device_add
[    0.199112] bus: 'acpi': add device LNXSYSTM:00
[    0.200798] device: 'device:00': device_add
[    0.201402] bus: 'acpi': add device device:00
[    0.203012] device: 'PNP0A03:00': device_add
[    0.203624] bus: 'acpi': add device PNP0A03:00
[    0.206490] device: 'device:01': device_add
[    0.207152] bus: 'acpi': add device device:01
[    0.208820] device: 'device:02': device_add
[    0.209422] bus: 'acpi': add device device:02
[    0.210893] device: 'PNP0B00:00': device_add
[    0.211511] bus: 'acpi': add device PNP0B00:00
[    0.213318] device: 'PNP0303:00': device_add
[    0.213935] bus: 'acpi': add device PNP0303:00
[    0.215840] device: 'PNP0F13:00': device_add
[    0.216103] bus: 'acpi': add device PNP0F13:00
[    0.217947] device: 'PNP0700:00': device_add
[    0.218561] bus: 'acpi': add device PNP0700:00
[    0.222459] device: 'PNP0400:00': device_add
[    0.223072] bus: 'acpi': add device PNP0400:00
[    0.226069] device: 'PNP0501:00': device_add
[    0.226674] bus: 'acpi': add device PNP0501:00
[    0.228943] device: 'device:03': device_add
[    0.229540] bus: 'acpi': add device device:03
[    0.230967] device: 'device:04': device_add
[    0.231572] bus: 'acpi': add device device:04
[    0.232902] device: 'device:05': device_add
[    0.233500] bus: 'acpi': add device device:05
[    0.235078] device: 'device:06': device_add
[    0.235675] bus: 'acpi': add device device:06
[    0.236938] device: 'device:07': device_add
[    0.237602] bus: 'acpi': add device device:07
[    0.239124] device: 'device:08': device_add
[    0.240105] bus: 'acpi': add device device:08
[    0.241676] device: 'device:09': device_add
[    0.242280] bus: 'acpi': add device device:09
[    0.243856] device: 'device:0a': device_add
[    0.244046] bus: 'acpi': add device device:0a
[    0.245551] device: 'device:0b': device_add
[    0.246210] bus: 'acpi': add device device:0b
[    0.248364] device: 'device:0c': device_add
[    0.248965] bus: 'acpi': add device device:0c
[    0.250538] device: 'device:0d': device_add
[    0.251140] bus: 'acpi': add device device:0d
[    0.252835] device: 'device:0e': device_add
[    0.253444] bus: 'acpi': add device device:0e
[    0.254953] device: 'device:0f': device_add
[    0.255608] bus: 'acpi': add device device:0f
[    0.256934] device: 'device:10': device_add
[    0.257529] bus: 'acpi': add device device:10
[    0.259098] device: 'device:11': device_add
[    0.259697] bus: 'acpi': add device device:11
[    0.261051] device: 'device:12': device_add
[    0.261656] bus: 'acpi': add device device:12
[    0.263221] device: 'device:13': device_add
[    0.264109] bus: 'acpi': add device device:13
[    0.265618] device: 'device:14': device_add
[    0.266223] bus: 'acpi': add device device:14
[    0.268173] device: 'device:15': device_add
[    0.268774] bus: 'acpi': add device device:15
[    0.270369] device: 'device:16': device_add
[    0.270972] bus: 'acpi': add device device:16
[    0.272504] device: 'device:17': device_add
[    0.273173] bus: 'acpi': add device device:17
[    0.274769] device: 'device:18': device_add
[    0.275373] bus: 'acpi': add device device:18
[    0.276975] device: 'device:19': device_add
[    0.277570] bus: 'acpi': add device device:19
[    0.279249] device: 'device:1a': device_add
[    0.279850] bus: 'acpi': add device device:1a
[    0.281004] device: 'device:1b': device_add
[    0.281670] bus: 'acpi': add device device:1b
[    0.283188] device: 'device:1c': device_add
[    0.284046] bus: 'acpi': add device device:1c
[    0.285627] device: 'device:1d': device_add
[    0.286296] bus: 'acpi': add device device:1d
[    0.288080] device: 'device:1e': device_add
[    0.288679] bus: 'acpi': add device device:1e
[    0.290193] device: 'device:1f': device_add
[    0.290852] bus: 'acpi': add device device:1f
[    0.292387] device: 'device:20': device_add
[    0.292988] bus: 'acpi': add device device:20
[    0.294563] device: 'device:21': device_add
[    0.295166] bus: 'acpi': add device device:21
[    0.296754] device: 'device:22': device_add
[    0.297360] bus: 'acpi': add device device:22
[    0.301982] device: 'PNP0103:00': device_add
[    0.302663] bus: 'acpi': add device PNP0103:00
[    0.305591] device: 'PNP0C0F:00': device_add
[    0.306205] bus: 'acpi': add device PNP0C0F:00
[    0.308910] device: 'PNP0C0F:01': device_add
[    0.309529] bus: 'acpi': add device PNP0C0F:01
[    0.312334] device: 'PNP0C0F:02': device_add
[    0.312962] bus: 'acpi': add device PNP0C0F:02
[    0.315737] device: 'PNP0C0F:03': device_add
[    0.316062] bus: 'acpi': add device PNP0C0F:03
[    0.318948] device: 'PNP0C0F:04': device_add
[    0.319558] bus: 'acpi': add device PNP0C0F:04
[    0.321333] device: 'LNXCPU:00': device_add
[    0.321937] bus: 'acpi': add device LNXCPU:00
[    0.324400] device: 'LNXCPU:01': device_add
[    0.325006] bus: 'acpi': add device LNXCPU:01
[    0.326543] device: 'device:23': device_add
[    0.327144] bus: 'acpi': add device device:23
[    0.328030] device: 'LNXPWRBN:00': device_add
[    0.328649] bus: 'acpi': add device LNXPWRBN:00
[    0.329682] bus: 'acpi': add driver ec
[    0.330315] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.331536] bus: 'acpi': add driver pci_root
[    0.332048] bus: 'acpi': driver_probe_device: matched device PNP0A03:00 =
with driver pci_root
[    0.333185] bus: 'acpi': really_probe: probing driver pci_root with devi=
ce PNP0A03:00
[    0.334409] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.335453] pci_root PNP0A03:00: fail to add MMCONFIG information, can't=
 access extended PCI configuration space under this bridge.
[    0.336053] device: 'pci0000:00': device_add
[    0.336935] device: '0000:00': device_add
[    0.337806] PCI host bridge to bus 0000:00
[    0.338374] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under dom=
ain [bus 00-ff]
[    0.340026] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.340777] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.341618] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.342454] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.343382] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebffff=
f]
[    0.344127] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.345350] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.346718] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.349621] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    0.351303] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.352512] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.353505] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.354653] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.356173] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.357998] pci 0000:00:02.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    0.364164] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.365562] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.366726] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.368347] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.372068] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.373386] pci 0000:00:04.0: [8086:2668] type 00 class 0x040300
[    0.374450] pci 0000:00:04.0: reg 10: [mem 0xfebf0000-0xfebf3fff]
[    0.377793] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.378999] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    0.380354] pci 0000:00:05.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    0.384612] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.385816] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    0.387152] pci 0000:00:06.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    0.391695] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.392420] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.393749] pci 0000:00:07.0: reg 14: [mem 0xfebf7000-0xfebf7fff]
[    0.398690] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.399887] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    0.400634] pci 0000:00:08.0: reg 14: [mem 0xfebf8000-0xfebf8fff]
[    0.405492] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.406696] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    0.408069] pci 0000:00:09.0: reg 14: [mem 0xfebf9000-0xfebf9fff]
[    0.412591] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.413798] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    0.415137] pci 0000:00:0a.0: reg 14: [mem 0xfebfa000-0xfebfafff]
[    0.419275] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    0.420242] pci 0000:00:0b.0: reg 10: [mem 0xfebfb000-0xfebfb00f]
[    0.423464] pci_bus 0000:00: on NUMA node 0
[    0.424123] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.444902]  pci0000:00: ACPI _OSC support notification failed, disablin=
g PCIe ASPM
[    0.445950]  pci0000:00: Unable to request _OSC control (_OSC support ma=
sk: 0x08)
[    0.446974] device: '0000:00:00.0': device_add
[    0.463412] bus: 'pci': add device 0000:00:00.0
[    0.464432] device: '0000:00:01.0': device_add
[    0.480653] bus: 'pci': add device 0000:00:01.0
[    0.481808] device: '0000:00:01.1': device_add
[    0.498108] bus: 'pci': add device 0000:00:01.1
[    0.499093] device: '0000:00:01.3': device_add
[    0.515207] bus: 'pci': add device 0000:00:01.3
[    0.516195] device: '0000:00:02.0': device_add
[    0.532309] bus: 'pci': add device 0000:00:02.0
[    0.533292] device: '0000:00:03.0': device_add
[    0.549437] bus: 'pci': add device 0000:00:03.0
[    0.550410] device: '0000:00:04.0': device_add
[    0.566488] bus: 'pci': add device 0000:00:04.0
[    0.567419] device: '0000:00:05.0': device_add
[    0.583532] bus: 'pci': add device 0000:00:05.0
[    0.584334] device: '0000:00:06.0': device_add
[    0.600656] bus: 'pci': add device 0000:00:06.0
[    0.601579] device: '0000:00:07.0': device_add
[    0.617683] bus: 'pci': add device 0000:00:07.0
[    0.618660] device: '0000:00:08.0': device_add
[    0.634701] bus: 'pci': add device 0000:00:08.0
[    0.635690] device: '0000:00:09.0': device_add
[    0.651731] bus: 'pci': add device 0000:00:09.0
[    0.652411] device: '0000:00:0a.0': device_add
[    0.668768] bus: 'pci': add device 0000:00:0a.0
[    0.669756] device: '0000:00:0b.0': device_add
[    0.685811] bus: 'pci': add device 0000:00:0b.0
[    0.686857] driver: 'PNP0A03:00': driver_bound: bound to device 'pci_roo=
t'
[    0.687813] bus: 'acpi': really_probe: bound device PNP0A03:00 to driver=
 pci_root
[    0.688158] bus: 'acpi': add driver pci_link
[    0.688784] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 =
with driver pci_link
[    0.689920] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:00
[    0.692951] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.694117] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_lin=
k'
[    0.695045] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver=
 pci_link
[    0.696051] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 =
with driver pci_link
[    0.697182] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:01
[    0.699354] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.700542] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_lin=
k'
[    0.701476] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver=
 pci_link
[    0.702490] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 =
with driver pci_link
[    0.703625] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:02
[    0.705099] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.706256] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_lin=
k'
[    0.707188] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver=
 pci_link
[    0.708051] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 =
with driver pci_link
[    0.709188] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:03
[    0.712112] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.713265] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_lin=
k'
[    0.714196] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver=
 pci_link
[    0.715205] bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 =
with driver pci_link
[    0.716049] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:04
[    0.718052] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.719147] driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_lin=
k'
[    0.720055] bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver=
 pci_link
[    0.721340] bus: 'pnp': registered
[    0.721900] device class 'misc': registering
[    0.722606] device: 'vga_arbiter': device_add
[    0.723556] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.724126] vgaarb: loaded
[    0.724504] vgaarb: bridge control possible 0000:00:02.0
[    0.725232] sta2x11_sctl_init
[    0.725659] bus: 'platform': add driver sta2x11-sctl
[    0.726391] sta2x11_apbreg_init
[    0.726824] bus: 'platform': add driver sta2x11-apbreg
[    0.728340] bus: 'serio': registered
[    0.728838] device class 'input': registering
[    0.729541] device class 'power_supply': registering
[    0.730261] device class 'watchdog': registering
[    0.731009] device class 'devfreq': registering
[    0.732100] PCI: Using ACPI for IRQ routing
[    0.732673] PCI: pci_cache_line_size set to 64 bytes
[    0.733944] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    0.734774] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.735687] device class 'net': registering
[    0.736259] device: 'lo': device_add
[    0.738051] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.738797] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.743153] Switching to clocksource kvm-clock
[    0.747013] Warning: could not register annotated branches stats
[    0.781024] bus: 'pnp': add driver system
[    0.781678] pnp: PnP ACPI init
[    0.782121] device: 'pnp0': device_add
[    0.782842] ACPI: bus type pnp registered
[    0.783636] pnp 00:00: [bus 00-ff]
[    0.784110] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.784681] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.785347] pnp 00:00: [io  0x0d00-0xffff window]
[    0.785987] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.786725] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    0.787468] device: '00:00': device_add
[    0.788094] bus: 'pnp': add device 00:00
[    0.788879] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.789973] pnp 00:01: [io  0x0070-0x0071]
[    0.790552] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.791647] pnp 00:01: [irq 8]
[    0.792076] pnp 00:01: [io  0x0072-0x0077]
[    0.792651] device: '00:01': device_add
[    0.793257] bus: 'pnp': add device 00:01
[    0.794014] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.795427] pnp 00:02: [io  0x0060]
[    0.795920] pnp 00:02: [io  0x0064]
[    0.796409] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.797519] pnp 00:02: [irq 1]
[    0.797953] device: '00:02': device_add
[    0.798638] bus: 'pnp': add device 00:02
[    0.799391] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.800793] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.801932] pnp 00:03: [irq 12]
[    0.802381] device: '00:03': device_add
[    0.802978] bus: 'pnp': add device 00:03
[    0.803729] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.805127] pnp 00:04: [io  0x03f2-0x03f5]
[    0.805701] pnp 00:04: [io  0x03f7]
[    0.806179] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.807268] pnp 00:04: [irq 6]
[    0.807700] pnp 00:04: [dma 2]
[    0.808128] device: '00:04': device_add
[    0.808723] bus: 'pnp': add device 00:04
[    0.809479] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.811459] pnp 00:05: [io  0x0378-0x037f]
[    0.812022] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.813130] pnp 00:05: [irq 7]
[    0.813573] device: '00:05': device_add
[    0.814173] bus: 'pnp': add device 00:05
[    0.814963] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.817061] pnp 00:06: [io  0x03f8-0x03ff]
[    0.817678] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.818780] pnp 00:06: [irq 4]
[    0.819218] device: '00:06': device_add
[    0.819921] bus: 'pnp': add device 00:06
[    0.820601] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.824349] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    0.825028] device: '00:07': device_add
[    0.825866] bus: 'pnp': add device 00:07
[    0.826552] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.830085] pnp: PnP ACPI: found 8 devices
[    0.830659] ACPI: ACPI bus type pnp unregistered
[    0.831337] device class 'mem': registering
[    0.831979] device: 'mem': device_add
[    0.832905] device: 'kmem': device_add
[    0.833662] device: 'null': device_add
[    0.834397] device: 'port': device_add
[    0.835050] device: 'zero': device_add
[    0.835790] device: 'full': device_add
[    0.836593] device: 'random': device_add
[    0.837362] device: 'urandom': device_add
[    0.838042] device: 'kmsg': device_add
[    0.838774] device: 'oldmem': device_add
[    0.839610] device: 'tty': device_add
[    0.840398] device: 'console': device_add
[    0.875923] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.876697] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.877466] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.878315] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    0.879253] NET: Registered protocol family 1
[    0.879908] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.880737] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.881570] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.882462] pci 0000:00:02.0: Boot video device
[    0.883264] PCI: CLS 0 bytes, default 64
[    0.884642] Unpacking initramfs...
[    3.739853] debug: unmapping init [mem 0xce73f000-0xcffeffff]
[    3.741821] sta2x11_mfd_init
[    3.742229] bus: 'pci': add driver sta2x11-mfd
[    3.743286] Registering platform device 'pcspkr'. Parent at platform
[    3.744238] device: 'pcspkr': device_add
[    3.744865] bus: 'platform': add device pcspkr
[    3.746324] bus: 'clocksource': registered
[    3.747021] device: 'clocksource': device_add
[    3.747878] device: 'clocksource0': device_add
[    3.748575] bus: 'clocksource': add device clocksource0
[    3.749592] bus: 'platform': add driver alarmtimer
[    3.750445] Registering platform device 'alarmtimer'. Parent at platform
[    3.751657] device: 'alarmtimer': device_add
[    3.752255] bus: 'platform': add device alarmtimer
[    3.753069] bus: 'platform': driver_probe_device: matched device alarmti=
mer with driver alarmtimer
[    3.754359] bus: 'platform': really_probe: probing driver alarmtimer wit=
h device alarmtimer
[    3.755694] driver: 'alarmtimer': driver_bound: bound to device 'alarmti=
mer'
[    3.756706] bus: 'platform': really_probe: bound device alarmtimer to dr=
iver alarmtimer
[    3.758141] bus: 'rttest': registered
[    3.758853] device: 'rttest': device_add
[    3.759713] device: 'rttest0': device_add
[    3.760282] bus: 'rttest': add device rttest0
[    3.761523] device: 'rttest1': device_add
[    3.762094] bus: 'rttest': add device rttest1
[    3.763294] device: 'rttest2': device_add
[    3.763953] bus: 'rttest': add device rttest2
[    3.764895] device: 'rttest3': device_add
[    3.765669] bus: 'rttest': add device rttest3
[    3.766743] device: 'rttest4': device_add
[    3.767338] bus: 'rttest': add device rttest4
[    3.768404] device: 'rttest5': device_add
[    3.769038] bus: 'rttest': add device rttest5
[    3.770109] device: 'rttest6': device_add
[    3.770794] bus: 'rttest': add device rttest6
[    3.771743] device: 'rttest7': device_add
[    3.772429] bus: 'rttest': add device rttest7
[    3.773329] Initializing RT-Tester: OK
[    3.782617] Kprobe smoke test started
[    3.855460] Kprobe smoke test passed successfully
[    3.856918] bus: 'event_source': registered
[    3.857552] device: 'breakpoint': device_add
[    3.858164] bus: 'event_source': add device breakpoint
[    3.859008] device: 'tracepoint': device_add
[    3.859624] bus: 'event_source': add device tracepoint
[    3.860546] device: 'software': device_add
[    3.861251] bus: 'event_source': add device software
[    3.925220] VFS: Disk quotas dquot_6.5.2
[    3.926776] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    3.928033] msgmni has been set to 420
[    3.938883] cryptomgr_test (31) used greatest stack depth: 7364 bytes le=
ft
[    3.941578] device class 'bsg': registering
[    3.942207] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    3.943284] io scheduler noop registered (default)
[    3.944362] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    3.945130] crc32: self tests passed, processed 225944 bytes in 157793 n=
sec
[    3.946286] crc32c: CRC_LE_BITS =3D 64
[    3.946841] crc32c: self tests passed, processed 225944 bytes in 75570 n=
sec
[    3.947877] bus: 'platform': add driver sta2x11-gpio
[    3.949334] bus: 'pci_express': registered
[    3.949963] bus: 'pci': add driver pcieport
[    3.950675] bus: 'pci': add driver tsi721
[    3.951437] device: 'pnp1': device_add
[    3.952107] isapnp: Scanning for PnP cards...
[    4.316216] isapnp: No Plug & Play device found
[    4.316981] device: 'ptyp0': device_add
[    4.317863] device: 'ptyp1': device_add
[    4.318793] device: 'ptyp2': device_add
[    4.319757] device: 'ptyp3': device_add
[    4.320437] device: 'ptyp4': device_add
[    4.321295] device: 'ptyp5': device_add
[    4.322224] device: 'ptyp6': device_add
[    4.323065] device: 'ptyp7': device_add
[    4.323844] device: 'ptyp8': device_add
[    4.324682] device: 'ptyp9': device_add
[    4.325548] device: 'ptypa': device_add
[    4.326416] device: 'ptypb': device_add
[    4.327252] device: 'ptypc': device_add
[    4.328130] device: 'ptypd': device_add
[    4.328971] device: 'ptype': device_add
[    4.330031] device: 'ptypf': device_add
[    4.330873] device: 'ptyq0': device_add
[    4.331742] device: 'ptyq1': device_add
[    4.332585] device: 'ptyq2': device_add
[    4.333382] device: 'ptyq3': device_add
[    4.334221] device: 'ptyq4': device_add
[    4.335066] device: 'ptyq5': device_add
[    4.335940] device: 'ptyq6': device_add
[    4.336787] device: 'ptyq7': device_add
[    4.337653] device: 'ptyq8': device_add
[    4.338430] device: 'ptyq9': device_add
[    4.339266] device: 'ptyqa': device_add
[    4.340147] device: 'ptyqb': device_add
[    4.340987] device: 'ptyqc': device_add
[    4.341950] device: 'ptyqd': device_add
[    4.342796] device: 'ptyqe': device_add
[    4.343664] device: 'ptyqf': device_add
[    4.344343] device: 'ptyr0': device_add
[    4.345400] device: 'ptyr1': device_add
[    4.346238] device: 'ptyr2': device_add
[    4.347082] device: 'ptyr3': device_add
[    4.347859] device: 'ptyr4': device_add
[    4.348807] device: 'ptyr5': device_add
[    4.349788] device: 'ptyr6': device_add
[    4.350634] device: 'ptyr7': device_add
[    4.351315] device: 'ptyr8': device_add
[    4.352436] device: 'ptyr9': device_add
[    4.353422] device: 'ptyra': device_add
[    4.354261] device: 'ptyrb': device_add
[    4.355008] device: 'ptyrc': device_add
[    4.355886] device: 'ptyrd': device_add
[    4.356829] device: 'ptyre': device_add
[    4.357702] device: 'ptyrf': device_add
[    4.358381] device: 'ptys0': device_add
[    4.359225] device: 'ptys1': device_add
[    4.360204] device: 'ptys2': device_add
[    4.361052] device: 'ptys3': device_add
[    4.361817] device: 'ptys4': device_add
[    4.362665] device: 'ptys5': device_add
[    4.363732] device: 'ptys6': device_add
[    4.364689] device: 'ptys7': device_add
[    4.365394] device: 'ptys8': device_add
[    4.366241] device: 'ptys9': device_add
[    4.367087] device: 'ptysa': device_add
[    4.368067] device: 'ptysb': device_add
[    4.368818] device: 'ptysc': device_add
[    4.369808] device: 'ptysd': device_add
[    4.370655] device: 'ptyse': device_add
[    4.371443] device: 'ptysf': device_add
[    4.372316] device: 'ptyt0': device_add
[    4.373196] device: 'ptyt1': device_add
[    4.374044] device: 'ptyt2': device_add
[    4.374994] device: 'ptyt3': device_add
[    4.375877] device: 'ptyt4': device_add
[    4.376729] device: 'ptyt5': device_add
[    4.377599] device: 'ptyt6': device_add
[    4.378380] device: 'ptyt7': device_add
[    4.379221] device: 'ptyt8': device_add
[    4.380110] device: 'ptyt9': device_add
[    4.380959] device: 'ptyta': device_add
[    4.381929] device: 'ptytb': device_add
[    4.382674] device: 'ptytc': device_add
[    4.383661] device: 'ptytd': device_add
[    4.384445] device: 'ptyte': device_add
[    4.385320] device: 'ptytf': device_add
[    4.386163] device: 'ptyu0': device_add
[    4.387116] device: 'ptyu1': device_add
[    4.388001] device: 'ptyu2': device_add
[    4.388854] device: 'ptyu3': device_add
[    4.389748] device: 'ptyu4': device_add
[    4.390603] device: 'ptyu5': device_add
[    4.391595] device: 'ptyu6': device_add
[    4.392381] device: 'ptyu7': device_add
[    4.393145] device: 'ptyu8': device_add
[    4.393997] device: 'ptyu9': device_add
[    4.394947] device: 'ptyua': device_add
[    4.395837] device: 'ptyub': device_add
[    4.396585] device: 'ptyuc': device_add
[    4.397566] device: 'ptyud': device_add
[    4.398525] device: 'ptyue': device_add
[    4.399314] device: 'ptyuf': device_add
[    4.400202] device: 'ptyv0': device_add
[    4.401117] device: 'ptyv1': device_add
[    4.401969] device: 'ptyv2': device_add
[    4.402925] device: 'ptyv3': device_add
[    4.403701] device: 'ptyv4': device_add
[    4.404558] device: 'ptyv5': device_add
[    4.405364] device: 'ptyv6': device_add
[    4.406323] device: 'ptyv7': device_add
[    4.407064] device: 'ptyv8': device_add
[    4.407953] device: 'ptyv9': device_add
[    4.408908] device: 'ptyva': device_add
[    4.409904] device: 'ptyvb': device_add
[    4.410763] device: 'ptyvc': device_add
[    4.411680] device: 'ptyvd': device_add
[    4.412535] device: 'ptyve': device_add
[    4.413344] device: 'ptyvf': device_add
[    4.414198] device: 'ptyw0': device_add
[    4.415055] device: 'ptyw1': device_add
[    4.415939] device: 'ptyw2': device_add
[    4.416794] device: 'ptyw3': device_add
[    4.417674] device: 'ptyw4': device_add
[    4.418642] device: 'ptyw5': device_add
[    4.419443] device: 'ptyw6': device_add
[    4.420432] device: 'ptyw7': device_add
[    4.421200] device: 'ptyw8': device_add
[    4.422162] device: 'ptyw9': device_add
[    4.423017] device: 'ptywa': device_add
[    4.424007] device: 'ptywb': device_add
[    4.424812] device: 'ptywc': device_add
[    4.425800] device: 'ptywd': device_add
[    4.426656] device: 'ptywe': device_add
[    4.427542] device: 'ptywf': device_add
[    4.428223] device: 'ptyx0': device_add
[    4.429079] device: 'ptyx1': device_add
[    4.430186] device: 'ptyx2': device_add
[    4.431151] device: 'ptyx3': device_add
[    4.431935] device: 'ptyx4': device_add
[    4.432797] device: 'ptyx5': device_add
[    4.433780] device: 'ptyx6': device_add
[    4.434637] device: 'ptyx7': device_add
[    4.435321] device: 'ptyx8': device_add
[    4.436209] device: 'ptyx9': device_add
[    4.437310] device: 'ptyxa': device_add
[    4.438174] device: 'ptyxb': device_add
[    4.438921] device: 'ptyxc': device_add
[    4.439812] device: 'ptyxd': device_add
[    4.440667] device: 'ptyxe': device_add
[    4.441659] device: 'ptyxf': device_add
[    4.442522] device: 'ptyy0': device_add
[    4.443321] device: 'ptyy1': device_add
[    4.444208] device: 'ptyy2': device_add
[    4.445198] device: 'ptyy3': device_add
[    4.445946] device: 'ptyy4': device_add
[    4.446806] device: 'ptyy5': device_add
[    4.447688] device: 'ptyy6': device_add
[    4.448550] device: 'ptyy7': device_add
[    4.449368] device: 'ptyy8': device_add
[    4.450357] device: 'ptyy9': device_add
[    4.451215] device: 'ptyya': device_add
[    4.452110] device: 'ptyyb': device_add
[    4.452976] device: 'ptyyc': device_add
[    4.454020] device: 'ptyyd': device_add
[    4.454890] device: 'ptyye': device_add
[    4.455893] device: 'ptyyf': device_add
[    4.456759] device: 'ptyz0': device_add
[    4.457648] device: 'ptyz1': device_add
[    4.458439] device: 'ptyz2': device_add
[    4.459295] device: 'ptyz3': device_add
[    4.460075] device: 'ptyz4': device_add
[    4.461052] device: 'ptyz5': device_add
[    4.461930] device: 'ptyz6': device_add
[    4.462790] device: 'ptyz7': device_add
[    4.463568] device: 'ptyz8': device_add
[    4.464576] device: 'ptyz9': device_add
[    4.465573] device: 'ptyza': device_add
[    4.466370] device: 'ptyzb': device_add
[    4.467112] device: 'ptyzc': device_add
[    4.468010] device: 'ptyzd': device_add
[    4.468989] device: 'ptyze': device_add
[    4.469874] device: 'ptyzf': device_add
[    4.470754] device: 'ptya0': device_add
[    4.471649] device: 'ptya1': device_add
[    4.472629] device: 'ptya2': device_add
[    4.473514] device: 'ptya3': device_add
[    4.474312] device: 'ptya4': device_add
[    4.475172] device: 'ptya5': device_add
[    4.476179] device: 'ptya6': device_add
[    4.477178] device: 'ptya7': device_add
[    4.477930] device: 'ptya8': device_add
[    4.478794] device: 'ptya9': device_add
[    4.479687] device: 'ptyaa': device_add
[    4.480678] device: 'ptyab': device_add
[    4.481380] device: 'ptyac': device_add
[    4.482237] device: 'ptyad': device_add
[    4.483097] device: 'ptyae': device_add
[    4.484108] device: 'ptyaf': device_add
[    4.484855] device: 'ptyb0': device_add
[    4.485742] device: 'ptyb1': device_add
[    4.486436] device: 'ptyb2': device_add
[    4.487194] device: 'ptyb3': device_add
[    4.488013] device: 'ptyb4': device_add
[    4.488783] device: 'ptyb5': device_add
[    4.489574] device: 'ptyb6': device_add
[    4.490309] device: 'ptyb7': device_add
[    4.491075] device: 'ptyb8': device_add
[    4.491901] device: 'ptyb9': device_add
[    4.492672] device: 'ptyba': device_add
[    4.493396] device: 'ptybb': device_add
[    4.494158] device: 'ptybc': device_add
[    4.494931] device: 'ptybd': device_add
[    4.495854] device: 'ptybe': device_add
[    4.496662] device: 'ptybf': device_add
[    4.497383] device: 'ptyc0': device_add
[    4.498173] device: 'ptyc1': device_add
[    4.498943] device: 'ptyc2': device_add
[    4.499744] device: 'ptyc3': device_add
[    4.500420] device: 'ptyc4': device_add
[    4.501233] device: 'ptyc5': device_add
[    4.502004] device: 'ptyc6': device_add
[    4.502823] device: 'ptyc7': device_add
[    4.503602] device: 'ptyc8': device_add
[    4.504311] device: 'ptyc9': device_add
[    4.505125] device: 'ptyca': device_add
[    4.505902] device: 'ptycb': device_add
[    4.506646] device: 'ptycc': device_add
[    4.507377] device: 'ptycd': device_add
[    4.508268] device: 'ptyce': device_add
[    4.509046] device: 'ptycf': device_add
[    4.509813] device: 'ptyd0': device_add
[    4.510594] device: 'ptyd1': device_add
[    4.511321] device: 'ptyd2': device_add
[    4.512132] device: 'ptyd3': device_add
[    4.512877] device: 'ptyd4': device_add
[    4.513677] device: 'ptyd5': device_add
[    4.514380] device: 'ptyd6': device_add
[    4.515175] device: 'ptyd7': device_add
[    4.515957] device: 'ptyd8': device_add
[    4.516737] device: 'ptyd9': device_add
[    4.517560] device: 'ptyda': device_add
[    4.518292] device: 'ptydb': device_add
[    4.519040] device: 'ptydc': device_add
[    4.519849] device: 'ptydd': device_add
[    4.520619] device: 'ptyde': device_add
[    4.521346] device: 'ptydf': device_add
[    4.522113] device: 'ptye0': device_add
[    4.522891] device: 'ptye1': device_add
[    4.523699] device: 'ptye2': device_add
[    4.524434] device: 'ptye3': device_add
[    4.525229] device: 'ptye4': device_add
[    4.526049] device: 'ptye5': device_add
[    4.526828] device: 'ptye6': device_add
[    4.527665] device: 'ptye7': device_add
[    4.528371] device: 'ptye8': device_add
[    4.529168] device: 'ptye9': device_add
[    4.529944] device: 'ptyea': device_add
[    4.530726] device: 'ptyeb': device_add
[    4.531412] device: 'ptyec': device_add
[    4.532234] device: 'ptyed': device_add
[    4.533014] device: 'ptyee': device_add
[    4.533811] device: 'ptyef': device_add
[    4.534572] device: 'ttyp0': device_add
[    4.535313] device: 'ttyp1': device_add
[    4.536119] device: 'ttyp2': device_add
[    4.536892] device: 'ttyp3': device_add
[    4.537686] device: 'ttyp4': device_add
[    4.538393] device: 'ttyp5': device_add
[    4.539195] device: 'ttyp6': device_add
[    4.540004] device: 'ttyp7': device_add
[    4.540782] device: 'ttyp8': device_add
[    4.541580] device: 'ttyp9': device_add
[    4.542319] device: 'ttypa': device_add
[    4.543094] device: 'ttypb': device_add
[    4.543918] device: 'ttypc': device_add
[    4.544698] device: 'ttypd': device_add
[    4.545530] device: 'ttype': device_add
[    4.546237] device: 'ttypf': device_add
[    4.546981] device: 'ttyq0': device_add
[    4.547821] device: 'ttyq1': device_add
[    4.548602] device: 'ttyq2': device_add
[    4.549371] device: 'ttyq3': device_add
[    4.550113] device: 'ttyq4': device_add
[    4.550894] device: 'ttyq5': device_add
[    4.551703] device: 'ttyq6': device_add
[    4.552444] device: 'ttyq7': device_add
[    4.553206] device: 'ttyq8': device_add
[    4.553986] device: 'ttyq9': device_add
[    4.554766] device: 'ttyqa': device_add
[    4.555575] device: 'ttyqb': device_add
[    4.556285] device: 'ttyqc': device_add
[    4.557123] device: 'ttyqd': device_add
[    4.557932] device: 'ttyqe': device_add
[    4.558710] device: 'ttyqf': device_add
[    4.559433] device: 'ttyr0': device_add
[    4.560387] device: 'ttyr1': device_add
[    4.561195] device: 'ttyr2': device_add
[    4.562022] device: 'ttyr3': device_add
[    4.562802] device: 'ttyr4': device_add
[    4.563621] device: 'ttyr5': device_add
[    4.564335] device: 'ttyr6': device_add
[    4.565134] device: 'ttyr7': device_add
[    4.565880] device: 'ttyr8': device_add
[    4.566699] device: 'ttyr9': device_add
[    4.567543] device: 'ttyra': device_add
[    4.568260] device: 'ttyrb': device_add
[    4.569005] device: 'ttyrc': device_add
[    4.569842] device: 'ttyrd': device_add
[    4.570624] device: 'ttyre': device_add
[    4.571338] device: 'ttyrf': device_add
[    4.572115] device: 'ttys0': device_add
[    4.572904] device: 'ttys1': device_add
[    4.573776] device: 'ttys2': device_add
[    4.574561] device: 'ttys3': device_add
[    4.575236] device: 'ttys4': device_add
[    4.576054] device: 'ttys5': device_add
[    4.576871] device: 'ttys6': device_add
[    4.577709] device: 'ttys7': device_add
[    4.578388] device: 'ttys8': device_add
[    4.579166] device: 'ttys9': device_add
[    4.580065] device: 'ttysa': device_add
[    4.580854] device: 'ttysb': device_add
[    4.581625] device: 'ttysc': device_add
[    4.582341] device: 'ttysd': device_add
[    4.583117] device: 'ttyse': device_add
[    4.583968] device: 'ttysf': device_add
[    4.584716] device: 'ttyt0': device_add
[    4.585530] device: 'ttyt1': device_add
[    4.586246] device: 'ttyt2': device_add
[    4.587067] device: 'ttyt3': device_add
[    4.587887] device: 'ttyt4': device_add
[    4.588681] device: 'ttyt5': device_add
[    4.589418] device: 'ttyt6': device_add
[    4.590238] device: 'ttyt7': device_add
[    4.591021] device: 'ttyt8': device_add
[    4.591843] device: 'ttyt9': device_add
[    4.592629] device: 'ttyta': device_add
[    4.593365] device: 'ttytb': device_add
[    4.594149] device: 'ttytc': device_add
[    4.594935] device: 'ttytd': device_add
[    4.595749] device: 'ttyte': device_add
[    4.596534] device: 'ttytf': device_add
[    4.597274] device: 'ttyu0': device_add
[    4.598156] device: 'ttyu1': device_add
[    4.598946] device: 'ttyu2': device_add
[    4.599764] device: 'ttyu3': device_add
[    4.600441] device: 'ttyu4': device_add
[    4.601282] device: 'ttyu5': device_add
[    4.602068] device: 'ttyu6': device_add
[    4.602852] device: 'ttyu7': device_add
[    4.603634] device: 'ttyu8': device_add
[    4.604393] device: 'ttyu9': device_add
[    4.605199] device: 'ttyua': device_add
[    4.605986] device: 'ttyub': device_add
[    4.606776] device: 'ttyuc': device_add
[    4.607592] device: 'ttyud': device_add
[    4.608399] device: 'ttyue': device_add
[    4.609212] device: 'ttyuf': device_add
[    4.609957] device: 'ttyv0': device_add
[    4.610744] device: 'ttyv1': device_add
[    4.611604] device: 'ttyv2': device_add
[    4.612328] device: 'ttyv3': device_add
[    4.613067] device: 'ttyv4': device_add
[    4.613884] device: 'ttyv5': device_add
[    4.614709] device: 'ttyv6': device_add
[    4.615442] device: 'ttyv7': device_add
[    4.616262] device: 'ttyv8': device_add
[    4.617058] device: 'ttyv9': device_add
[    4.617866] device: 'ttyva': device_add
[    4.618739] device: 'ttyvb': device_add
[    4.619431] device: 'ttyvc': device_add
[    4.620238] device: 'ttyvd': device_add
[    4.621028] device: 'ttyve': device_add
[    4.621886] device: 'ttyvf': device_add
[    4.622635] device: 'ttyw0': device_add
[    4.623413] device: 'ttyw1': device_add
[    4.624223] device: 'ttyw2': device_add
[    4.625152] device: 'ttyw3': device_add
[    4.626006] device: 'ttyw4': device_add
[    4.626802] device: 'ttyw5': device_add
[    4.627632] device: 'ttyw6': device_add
[    4.628397] device: 'ttyw7': device_add
[    4.629216] device: 'ttyw8': device_add
[    4.630009] device: 'ttyw9': device_add
[    4.630800] device: 'ttywa': device_add
[    4.631629] device: 'ttywb': device_add
[    4.632353] device: 'ttywc': device_add
[    4.633165] device: 'ttywd': device_add
[    4.633955] device: 'ttywe': device_add
[    4.634804] device: 'ttywf': device_add
[    4.635582] device: 'ttyx0': device_add
[    4.636357] device: 'ttyx1': device_add
[    4.637166] device: 'ttyx2': device_add
[    4.637962] device: 'ttyx3': device_add
[    4.638749] device: 'ttyx4': device_add
[    4.639627] device: 'ttyx5': device_add
[    4.640401] device: 'ttyx6': device_add
[    4.641211] device: 'ttyx7': device_add
[    4.641956] device: 'ttyx8': device_add
[    4.642751] device: 'ttyx9': device_add
[    4.643626] device: 'ttyxa': device_add
[    4.644356] device: 'ttyxb': device_add
[    4.645122] device: 'ttyxc': device_add
[    4.645914] device: 'ttyxd': device_add
[    4.646758] device: 'ttyxe': device_add
[    4.647592] device: 'ttyxf': device_add
[    4.648267] device: 'ttyy0': device_add
[    4.649130] device: 'ttyy1': device_add
[    4.649970] device: 'ttyy2': device_add
[    4.650772] device: 'ttyy3': device_add
[    4.651555] device: 'ttyy4': device_add
[    4.652283] device: 'ttyy5': device_add
[    4.653159] device: 'ttyy6': device_add
[    4.654006] device: 'ttyy7': device_add
[    4.654753] device: 'ttyy8': device_add
[    4.655587] device: 'ttyy9': device_add
[    4.656320] device: 'ttyya': device_add
[    4.657227] device: 'ttyyb': device_add
[    4.657976] device: 'ttyyc': device_add
[    4.658775] device: 'ttyyd': device_add
[    4.659649] device: 'ttyye': device_add
[    4.660380] device: 'ttyyf': device_add
[    4.661196] device: 'ttyz0': device_add
[    4.661998] device: 'ttyz1': device_add
[    4.662794] device: 'ttyz2': device_add
[    4.663662] device: 'ttyz3': device_add
[    4.664394] device: 'ttyz4': device_add
[    4.665212] device: 'ttyz5': device_add
[    4.666009] device: 'ttyz6': device_add
[    4.666801] device: 'ttyz7': device_add
[    4.667635] device: 'ttyz8': device_add
[    4.668369] device: 'ttyz9': device_add
[    4.669182] device: 'ttyza': device_add
[    4.670027] device: 'ttyzb': device_add
[    4.670775] device: 'ttyzc': device_add
[    4.671721] device: 'ttyzd': device_add
[    4.672532] device: 'ttyze': device_add
[    4.673285] device: 'ttyzf': device_add
[    4.674087] device: 'ttya0': device_add
[    4.674937] device: 'ttya1': device_add
[    4.675769] device: 'ttya2': device_add
[    4.676569] device: 'ttya3': device_add
[    4.677268] device: 'ttya4': device_add
[    4.678075] device: 'ttya5': device_add
[    4.678925] device: 'ttya6': device_add
[    4.679755] device: 'ttya7': device_add
[    4.680554] device: 'ttya8': device_add
[    4.681315] device: 'ttya9': device_add
[    4.682159] device: 'ttyaa': device_add
[    4.682958] device: 'ttyab': device_add
[    4.683740] device: 'ttyac': device_add
[    4.684549] device: 'ttyad': device_add
[    4.685354] device: 'ttyae': device_add
[    4.686157] device: 'ttyaf': device_add
[    4.686905] device: 'ttyb0': device_add
[    4.687743] device: 'ttyb1': device_add
[    4.688541] device: 'ttyb2': device_add
[    4.689361] device: 'ttyb3': device_add
[    4.690173] device: 'ttyb4': device_add
[    4.691086] device: 'ttyb5': device_add
[    4.692051] device: 'ttyb6': device_add
[    4.692948] device: 'ttyb7': device_add
[    4.693722] device: 'ttyb8': device_add
[    4.694525] device: 'ttyb9': device_add
[    4.695255] device: 'ttyba': device_add
[    4.696096] device: 'ttybb': device_add
[    4.696899] device: 'ttybc': device_add
[    4.697725] device: 'ttybd': device_add
[    4.698525] device: 'ttybe': device_add
[    4.699258] device: 'ttybf': device_add
[    4.700099] device: 'ttyc0': device_add
[    4.700960] device: 'ttyc1': device_add
[    4.701785] device: 'ttyc2': device_add
[    4.702588] device: 'ttyc3': device_add
[    4.703325] device: 'ttyc4': device_add
[    4.704175] device: 'ttyc5': device_add
[    4.704977] device: 'ttyc6': device_add
[    4.705800] device: 'ttyc7': device_add
[    4.706544] device: 'ttyc8': device_add
[    4.707343] device: 'ttyc9': device_add
[    4.708239] device: 'ttyca': device_add
[    4.709144] device: 'ttycb': device_add
[    4.709895] device: 'ttycc': device_add
[    4.710760] device: 'ttycd': device_add
[    4.711655] device: 'ttyce': device_add
[    4.712399] device: 'ttycf': device_add
[    4.713163] device: 'ttyd0': device_add
[    4.713972] device: 'ttyd1': device_add
[    4.714832] device: 'ttyd2': device_add
[    4.715672] device: 'ttyd3': device_add
[    4.716354] device: 'ttyd4': device_add
[    4.717176] device: 'ttyd5': device_add
[    4.718039] device: 'ttyd6': device_add
[    4.718847] device: 'ttyd7': device_add
[    4.719624] device: 'ttyd8': device_add
[    4.720367] device: 'ttyd9': device_add
[    4.721244] device: 'ttyda': device_add
[    4.722109] device: 'ttydb': device_add
[    4.722858] device: 'ttydc': device_add
[    4.723704] device: 'ttydd': device_add
[    4.724439] device: 'ttyde': device_add
[    4.725386] device: 'ttydf': device_add
[    4.726130] device: 'ttye0': device_add
[    4.726942] device: 'ttye1': device_add
[    4.727848] device: 'ttye2': device_add
[    4.728719] device: 'ttye3': device_add
[    4.729422] device: 'ttye4': device_add
[    4.730230] device: 'ttye5': device_add
[    4.731034] device: 'ttye6': device_add
[    4.731886] device: 'ttye7': device_add
[    4.732753] device: 'ttye8': device_add
[    4.733588] device: 'ttye9': device_add
[    4.734331] device: 'ttyea': device_add
[    4.735134] device: 'ttyeb': device_add
[    4.735983] device: 'ttyec': device_add
[    4.736796] device: 'ttyed': device_add
[    4.737628] device: 'ttyee': device_add
[    4.738367] device: 'ttyef': device_add
[    4.739163] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    4.740189] Registering platform device 'serial8250'. Parent at platform
[    4.741190] device: 'serial8250': device_add
[    4.741857] bus: 'platform': add device serial8250
[    4.764954] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    4.765908] device: 'ttyS0': device_add
[    4.766901] device: 'ttyS1': device_add
[    4.767823] device: 'ttyS2': device_add
[    4.768712] device: 'ttyS3': device_add
[    4.769614] bus: 'platform': add driver serial8250
[    4.770291] bus: 'platform': driver_probe_device: matched device serial8=
250 with driver serial8250
[    4.771661] bus: 'platform': really_probe: probing driver serial8250 wit=
h device serial8250
[    4.772868] driver: 'serial8250': driver_bound: bound to device 'serial8=
250'
[    4.773908] bus: 'platform': really_probe: bound device serial8250 to dr=
iver serial8250
[    4.775215] device: 'ttyprintk': device_add
[    4.776035] device: 'hpet': device_add
[    4.776839] bus: 'acpi': add driver hpet
[    4.777517] bus: 'acpi': driver_probe_device: matched device PNP0103:00 =
with driver hpet
[    4.778666] bus: 'acpi': really_probe: probing driver hpet with device P=
NP0103:00
[    4.780001] hpet: probe of PNP0103:00 rejects match -19
[    4.780827] bus: 'pnp': add driver tpm_tis
[    4.781896] bus: 'isa': registered
[    4.782379] device: 'isa': device_add
[    4.783008] bus: 'pnp': add driver i8042 kbd
[    4.783724] bus: 'pnp': driver_probe_device: matched device 00:02 with d=
river i8042 kbd
[    4.784862] bus: 'pnp': really_probe: probing driver i8042 kbd with devi=
ce 00:02
[    4.786036] driver: '00:02': driver_bound: bound to device 'i8042 kbd'
[    4.786987] bus: 'pnp': really_probe: bound device 00:02 to driver i8042=
 kbd
[    4.788087] bus: 'pnp': add driver i8042 aux
[    4.788766] bus: 'pnp': driver_probe_device: matched device 00:03 with d=
river i8042 aux
[    4.789923] bus: 'pnp': really_probe: probing driver i8042 aux with devi=
ce 00:03
[    4.791007] driver: '00:03': driver_bound: bound to device 'i8042 aux'
[    4.791993] bus: 'pnp': really_probe: bound device 00:03 to driver i8042=
 aux
[    4.793051] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    4.794241] Registering platform device 'i8042'. Parent at platform
[    4.795156] device: 'i8042': device_add
[    4.795808] bus: 'platform': add device i8042
[    4.796637] bus: 'platform': add driver i8042
[    4.797274] bus: 'platform': driver_probe_device: matched device i8042 w=
ith driver i8042
[    4.798424] bus: 'platform': really_probe: probing driver i8042 with dev=
ice i8042
[    4.810589] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.811322] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.812171] driver: 'i8042': driver_bound: bound to device 'i8042'
[    4.813075] bus: 'platform': really_probe: bound device i8042 to driver =
i8042
[    4.814153] bus: 'serio': add driver atkbd
[    4.814927] bus: 'pci': add driver pci_eisa
[    4.815810] Registering platform device 'eisa.0'. Parent at platform
[    4.816744] device: 'eisa.0': device_add
[    4.817412] bus: 'platform': add device eisa.0
[    4.818235] EISA: Probing bus 0 at eisa.0
[    4.818860] EISA: Cannot allocate resource for mainboard
[    4.819858] bus: 'platform': remove device eisa.0
[    4.820623] cpuidle: using governor ladder
[    4.821359]=20
[    4.821359] printing PIC contents
[    4.822082] ... PIC  IMR: ffff
[    4.822577] ... PIC  IRR: 1013
[    4.823006] ... PIC  ISR: 0000
[    4.823444] ... PIC ELCR: 0c00
[    4.823972] printing local APIC contents on CPU#0/0:
[    4.824725] ... APIC ID:      00000000 (0)
[    4.825103] ... APIC VERSION: 00050014
[    4.825103] ... APIC TASKPRI: 00000000 (00)
[    4.825103] ... APIC PROCPRI: 00000000
[    4.825103] ... APIC LDR: 01000000
[    4.825103] ... APIC DFR: ffffffff
[    4.825103] ... APIC SPIV: 000001ff
[    4.825103] ... APIC ISR field:
[    4.825103] 000000000000000000000000000000000000000000000000000000000000=
0000
[    4.825103] ... APIC TMR field:
[    4.825103] 000000000000000000000000000000000000000000000000000000000000=
0000
[    4.825103] ... APIC IRR field:
[    4.825103] 000000000000000000000000000000000000000000000000000000000000=
8000
[    4.825103] ... APIC ESR: 00000000
[    4.825103] ... APIC ICR: 000008fd
[    4.825103] ... APIC ICR2: 02000000
[    4.825103] ... APIC LVTT: 000200ef
[    4.825103] ... APIC LVTPC: 00010000
[    4.825103] ... APIC LVT0: 00010700
[    4.825103] ... APIC LVT1: 00000400
[    4.825103] ... APIC LVTERR: 000000fe
[    4.825103] ... APIC TMICT: 0003d091
[    4.825103] ... APIC TMCCT: 00017ab4
[    4.825103] ... APIC TDCR: 00000003
[    4.825103]=20
[    4.845845] number of MP IRQ sources: 15.
[    4.846393] number of IO-APIC #2 registers: 24.
[    4.847069] testing the IO APIC.......................
[    4.847890] IO APIC #2......
[    4.848285] .... register #00: 00000000
[    4.848877] .......    : physical APIC id: 00
[    4.849557] .......    : Delivery Type: 0
[    4.850099] .......    : LTS          : 0
[    4.850712] .... register #01: 00170011
[    4.851230] .......     : max redirection entries: 17
[    4.852015] .......     : PRQ implemented: 0
[    4.852660] .......     : IO APIC version: 11
[    4.853264] .... register #02: 00000000
[    4.853854] .......     : arbitration: 00
[    4.854399] .... IRQ redirection table:
[    4.854983]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    4.855834]  00 00  1    0    0   0   0    0    0    00
[    4.856639]  01 03  0    0    0   0   0    1    1    31
[    4.857400]  02 03  0    0    0   0   0    1    1    30
[    4.858197]  03 03  0    0    0   0   0    1    1    33
[    4.859003]  04 03  1    0    0   0   0    1    1    34
[    4.859863]  05 03  1    1    0   0   0    1    1    35
[    4.860669]  06 03  0    0    0   0   0    1    1    36
[    4.861429]  07 03  0    0    0   0   0    1    1    37
[    4.862228]  08 03  0    0    0   0   0    1    1    38
[    4.863032]  09 03  0    1    0   0   0    1    1    39
[    4.863875]  0a 03  1    1    0   0   0    1    1    3A
[    4.864682]  0b 03  1    1    0   0   0    1    1    3B
[    4.865438]  0c 03  0    0    0   0   0    1    1    3C
[    4.866238]  0d 03  0    0    0   0   0    1    1    3D
[    4.867045]  0e 03  0    0    0   0   0    1    1    3E
[    4.867886]  0f 03  0    0    0   0   0    1    1    3F
[    4.868692]  10 00  1    0    0   0   0    0    0    00
[    4.869516]  11 00  1    0    0   0   0    0    0    00
[    4.870246]  12 00  1    0    0   0   0    0    0    00
[    4.871050]  13 00  1    0    0   0   0    0    0    00
[    4.871890]  14 00  1    0    0   0   0    0    0    00
[    4.872694]  15 00  1    0    0   0   0    0    0    00
[    4.873521]  16 00  1    0    0   0   0    0    0    00
[    4.874253]  17 00  1    0    0   0   0    0    0    00
[    4.875047] IRQ to pin mappings:
[    4.875592] IRQ0 -> 0:2
[    4.875971] IRQ1 -> 0:1
[    4.876353] IRQ3 -> 0:3
[    4.876798] IRQ4 -> 0:4
[    4.877198] IRQ5 -> 0:5
[    4.882870] IRQ6 -> 0:6
[    4.883250] IRQ7 -> 0:7
[    4.884718] IRQ8 -> 0:8
[    4.885117] IRQ9 -> 0:9
[    4.885570] IRQ10 -> 0:10
[    4.885974] IRQ11 -> 0:11
[    4.886382] IRQ12 -> 0:12
[    4.887887] IRQ13 -> 0:13
[    4.888289] IRQ14 -> 0:14
[    4.888765] IRQ15 -> 0:15
[    4.889238] .................................... done.
[    4.891006] Using IPI Shortcut mode
[    4.891640] device: 'cpu_dma_latency': device_add
[    4.892437] device: 'network_latency': device_add
[    4.894402] device: 'network_throughput': device_add
[    4.895440] IMA: No TPM chip found, activating TPM-bypass!
[    4.919704] device: 'serio0': device_add
[    4.920341] bus: 'serio': add device serio0
[    4.922757] bus: 'serio': driver_probe_device: matched device serio0 wit=
h driver atkbd
[    4.925352] bus: 'serio': really_probe: probing driver atkbd with device=
 serio0
[    4.928208] device: 'input0': device_add
[    4.932583] debug: unmapping init [mem 0xc1411000-0xc147afff]
[    4.937270] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    4.942881] driver: 'serio0': driver_bound: bound to device 'atkbd'
[    4.956543] bus: 'serio': really_probe: bound device serio0 to driver at=
kbd
[    4.960639] device: 'serio1': device_add
[    4.961422] bus: 'serio': add device serio1
[    4.965372] bus: 'serio': driver_probe_device: matched device serio1 wit=
h driver atkbd
[    4.970611] bus: 'serio': really_probe: probing driver atkbd with device=
 serio1
[    4.972978] atkbd: probe of serio1 rejects match -19
[    4.974742] bus: 'serio': driver_probe_device: matched device serio1 wit=
h driver atkbd
[    4.976893] bus: 'serio': really_probe: probing driver atkbd with device=
 serio1
[    4.979207] atkbd: probe of serio1 rejects match -19
modprobe: FATAL: Could not load /lib/modules/3.6.0-rc4-00155-gcaa631e/modul=
es.dep: No such file or directory

[    5.060709] modprobe (39) used greatest stack depth: 6444 bytes left
modprobe: FATAL: Could not load /lib/modules/3.6.0-rc4-00155-gcaa631e/modul=
es.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.6.0-rc4-00155-gcaa631e/modul=
es.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.6.0-rc4-00155-gcaa631e/modul=
es.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.6.0-rc4-00155-gcaa631e/modul=
es.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.6.0-rc4-00155-gcaa631e/modul=
es.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.6.0-rc4-00155-gcaa631e/modul=
es.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.6.0-rc4-00155-gcaa631e/modul=
es.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.6.0-rc4-00155-gcaa631e/modul=
es.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.6.0-rc4-00155-gcaa631e/modul=
es.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.6.0-rc4-00155-gcaa631e/modul=
es.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.6.0-rc4-00155-gcaa631e/modul=
es.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.6.0-rc4-00155-gcaa631e/modul=
es.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.6.0-rc4-00155-gcaa631e/modul=
es.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.6.0-rc4-00155-gcaa631e/modul=
es.dep: No such file or directory

[    8.787925] rm (191) used greatest stack depth: 6392 bytes left
[   21.106356] chown (722) used greatest stack depth: 6284 bytes left
[   38.573563] CPA self-test:
[   38.575565]  4k 65534 large 0 gb 0 x 65534[c0000000-cfffd000] miss 0
[   38.607846]  4k 65534 large 0 gb 0 x 65534[c0000000-cfffd000] miss 0
[   38.632543]  4k 65534 large 0 gb 0 x 65534[c0000000-cfffd000] miss 0
[   38.633420] ok.
[   40.522075] ------------[ cut here ]------------
[   40.522796] WARNING: at /c/kernel-tests/src/i386/kernel/lockdep.c:956 __=
bfs+0x1a8/0x1d0()
[   40.523584] Modules linked in:
[   40.523584] Pid: 1, comm: init Not tainted 3.6.0-rc4-00155-gcaa631e #190
[   40.523584] Call Trace:
[   40.523584]  [<c1029fb4>] warn_slowpath_common+0x64/0x80
[   40.523584]  [<c107d2a8>] ? __bfs+0x1a8/0x1d0
[   40.523584]  [<c107d2a8>] ? __bfs+0x1a8/0x1d0
[   40.523584]  [<c1029ff2>] warn_slowpath_null+0x22/0x30
[   40.523584]  [<c107d2a8>] __bfs+0x1a8/0x1d0
[   40.523584]  [<c107d020>] ? noop_count+0x10/0x10
[   40.523584]  [<c107f063>] check_usage_backwards+0x63/0xe0
[   40.523584]  [<c100e8b0>] ? save_stack_trace+0x30/0x50
[   40.523584]  [<c107f000>] ? check_usage_forwards+0xe0/0xe0
[   40.523584]  [<c107f7f9>] mark_lock+0x139/0x260
[   40.523584]  [<c107f000>] ? check_usage_forwards+0xe0/0xe0
[   40.523584]  [<c107fe50>] __lock_acquire+0x530/0x15f0
[   40.523584]  [<c1128e10>] ? shrink_dcache_parent+0x60/0x2d0
[   40.523584]  [<c11b8fde>] ? do_raw_spin_lock+0x16e/0x190
[   40.523584]  [<c1081470>] lock_acquire+0x80/0x190
[   40.523584]  [<c112850d>] ? d_drop+0x1d/0x40
[   40.523584]  [<c129f263>] _raw_spin_lock+0x43/0x50
[   40.523584]  [<c112850d>] ? d_drop+0x1d/0x40
[   40.523584]  [<c112850d>] d_drop+0x1d/0x40
[   40.523584]  [<c116718f>] proc_flush_task+0x8f/0x190
[   40.523584]  [<c102e444>] ? release_task+0x94/0x590
[   40.523584]  [<c102e46a>] release_task+0xba/0x590
[   40.523584]  [<c102e3c0>] ? release_task+0x10/0x590
[   40.523584]  [<c10eff51>] ? might_fault+0x91/0xa0
[   40.523584]  [<c102f6d7>] wait_consider_task.part.24+0xd97/0xed0
[   40.523584]  [<c102f008>] ? wait_consider_task.part.24+0x6c8/0xed0
[   40.523584]  [<c102f8f0>] do_wait+0xe0/0x300
[   40.523584]  [<c110eec0>] ? do_sync_write+0xd0/0xd0
[   40.523584]  [<c1030de0>] sys_waitid+0x70/0x170
[   40.523584]  [<c102dd80>] ? task_stopped_code+0x50/0x50
[   40.523584]  [<c12a74c3>] sysenter_do_call+0x12/0x3c
[   40.523584] ---[ end trace 6d77557c8d2782e1 ]---
[   40.523584] BUG: unable to handle kernel NULL pointer dereference at 000=
00008
[   40.523584] IP: [<c107d1b1>] __bfs+0xb1/0x1d0
[   40.523584] *pde =3D 00000000=20
[   40.523584] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   40.523584] Modules linked in:
[   40.523584] Pid: 1, comm: init Tainted: G        W    3.6.0-rc4-00155-gc=
aa631e #190 =20
[   40.523584] EIP: 0060:[<c107d1b1>] EFLAGS: 00010082 CPU: 1
[   40.523584] EIP is at __bfs+0xb1/0x1d0
[   40.523584] EAX: 00000000 EBX: c1766938 ECX: ac684d48 EDX: c102c5c8
[   40.523584] ESI: cd873d0c EDI: 00000000 EBP: cd873cf4 ESP: cd873cdc
[   40.523584]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   40.523584] CR0: 8005003b CR2: 00000008 CR3: 086c4000 CR4: 00000690
[   40.523584] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   40.523584] DR6: ffff0ff0 DR7: 00000400
[   40.523584] Process init (pid: 1, ti=3Dcd872000 task=3Dcd878000 task.ti=
=3Dcd872000)
[   40.523584] Stack:
[   40.523584]  ac684d48 c107d020 00000000 cd878450 cd878000 00000000 cd873=
d3c c107f063
[   40.523584]  cd873d08 00000000 00000000 c1766880 00000002 cd878450 c1766=
840 c100e8b0
[   40.523584]  00000000 c12aa0d8 c1766880 c1766880 00000000 c107f000 00000=
002 cd878450
[   40.523584] Call Trace:
[   40.523584]  [<c107d020>] ? noop_count+0x10/0x10
[   40.523584]  [<c107f063>] check_usage_backwards+0x63/0xe0
[   40.523584]  [<c100e8b0>] ? save_stack_trace+0x30/0x50
[   40.523584]  [<c107f000>] ? check_usage_forwards+0xe0/0xe0
[   40.523584]  [<c107f7f9>] mark_lock+0x139/0x260
[   40.523584]  [<c107f000>] ? check_usage_forwards+0xe0/0xe0
[   40.523584]  [<c107fe50>] __lock_acquire+0x530/0x15f0
[   40.523584]  [<c1128e10>] ? shrink_dcache_parent+0x60/0x2d0
[   40.523584]  [<c11b8fde>] ? do_raw_spin_lock+0x16e/0x190
[   40.523584]  [<c1081470>] lock_acquire+0x80/0x190
[   40.523584]  [<c112850d>] ? d_drop+0x1d/0x40
[   40.523584]  [<c129f263>] _raw_spin_lock+0x43/0x50
[   40.523584]  [<c112850d>] ? d_drop+0x1d/0x40
[   40.523584]  [<c112850d>] d_drop+0x1d/0x40
[   40.523584]  [<c116718f>] proc_flush_task+0x8f/0x190
[   40.523584]  [<c102e444>] ? release_task+0x94/0x590
[   40.523584]  [<c102e46a>] release_task+0xba/0x590
[   40.523584]  [<c102e3c0>] ? release_task+0x10/0x590
[   40.523584]  [<c10eff51>] ? might_fault+0x91/0xa0
[   40.523584]  [<c102f6d7>] wait_consider_task.part.24+0xd97/0xed0
[   40.523584]  [<c102f008>] ? wait_consider_task.part.24+0x6c8/0xed0
[   40.523584]  [<c102f8f0>] do_wait+0xe0/0x300
[   40.523584]  [<c110eec0>] ? do_sync_write+0xd0/0xd0
[   40.523584]  [<c1030de0>] sys_waitid+0x70/0x170
[   40.523584]  [<c102dd80>] ? task_stopped_code+0x50/0x50
[   40.523584]  [<c12a74c3>] sysenter_do_call+0x12/0x3c
[   40.523584] Code: f8 00 00 00 85 ff 0f 44 da 8b 3b 39 df 74 c3 89 f8 2d =
e0 21 55 c1 c1 f8 02 69 c8 39 8e e3 38 3b 0d a0 e1 54 c1 0f 83 e5 00 00 00 =
<8b> 47 08 8b 15 c8 21 55 c1 39 50 18 75 39 8b 3f 39 df 75 d0 a1
[   40.523584] EIP: [<c107d1b1>] __bfs+0xb1/0x1d0 SS:ESP 0068:cd873cdc
[   40.523584] CR2: 0000000000000008
[   40.523584] ---[ end trace 6d77557c8d2782e2 ]---
[   40.523584] Kernel panic - not syncing: Fatal exception
[   40.523584] Rebooting in 10 seconds..
--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.6.0-rc4-00155-gcaa631e"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.6.0-rc4 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
# CONFIG_NEED_DMA_MAP_STATE is not set
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
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
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
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
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_FHANDLE=y
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
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
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_TREE_RCU_TRACE=y
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
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
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
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
# CONFIG_EVENTFD is not set
# CONFIG_SHMEM is not set
# CONFIG_AIO is not set
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
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
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
# CONFIG_MODULE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y

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
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_BIGSMP=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_WANT_INTEL_MID is not set
CONFIG_X86_RDC321X=y
CONFIG_X86_32_NON_STANDARD=y
# CONFIG_X86_NUMAQ is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_STA2X11=y
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_ES7000 is not set
CONFIG_X86_32_IRIS=m
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
# CONFIG_LGUEST_GUEST is not set
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
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
# CONFIG_CPU_SUP_INTEL is not set
# CONFIG_CPU_SUP_CYRIX_32 is not set
# CONFIG_CPU_SUP_AMD is not set
# CONFIG_CPU_SUP_CENTAUR is not set
# CONFIG_CPU_SUP_TRANSMETA_32 is not set
# CONFIG_CPU_SUP_UMC_32 is not set
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
# CONFIG_ARCH_DMA_ADDR_T_64BIT is not set
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
CONFIG_ZONE_DMA_FLAG=0
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_CLEANCACHE=y
# CONFIG_HIGHPTE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_HOTPLUG_CPU is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
# CONFIG_ACPI_PROCESSOR is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=m
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_BGRT=m
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_POWERNOW_K6 is not set
CONFIG_X86_POWERNOW_K7=m
CONFIG_X86_GX_SUSPMOD=m
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_SPEEDSTEP_ICH=m
CONFIG_X86_P4_CLOCKMOD=m
CONFIG_X86_LONGRUN=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

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
CONFIG_PCIEPORTBUS=y
# CONFIG_PCIEAER is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
# CONFIG_PCIEASPM_DEFAULT is not set
# CONFIG_PCIEASPM_POWERSAVE is not set
CONFIG_PCIEASPM_PERFORMANCE=y
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=m
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_EISA=y
# CONFIG_EISA_VLB_PRIMING is not set
CONFIG_EISA_PCI_EISA=y
CONFIG_EISA_VIRTUAL_ROOT=y
CONFIG_EISA_NAMES=y
CONFIG_SCx200=m
# CONFIG_SCx200HR_TIMER is not set
# CONFIG_OLPC is not set
CONFIG_ALIX=y
CONFIG_NET5501=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_TSI721=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
# CONFIG_RAPIDIO_DMA_ENGINE is not set
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_TSI57X=y
# CONFIG_RAPIDIO_CPS_XX is not set
# CONFIG_RAPIDIO_TSI568 is not set
# CONFIG_RAPIDIO_CPS_GEN2 is not set
CONFIG_RAPIDIO_TSI500=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_X86_DMA_REMAP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETFILTER is not set
CONFIG_ATM=m
CONFIG_ATM_LANE=m
CONFIG_STP=m
CONFIG_BRIDGE=m
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=m
CONFIG_LLC=m
CONFIG_LLC2=m
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
CONFIG_PHONET=m
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
CONFIG_NET_9P=m
# CONFIG_NET_9P_VIRTIO is not set
CONFIG_NET_9P_DEBUG=y
CONFIG_CAIF=m
# CONFIG_CAIF_DEBUG is not set
# CONFIG_CAIF_NETDEV is not set
# CONFIG_CAIF_USB is not set

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
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_ISAPNP=y
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_XD is not set
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
# CONFIG_BLK_DEV_HD is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
CONFIG_PHANTOM=m
# CONFIG_INTEL_MID_PTI is not set
CONFIG_SGI_IOC4=m
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_HP_ILO=m
CONFIG_APDS9802ALS=m
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=m

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=m
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=m
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
# CONFIG_BLK_DEV_SR_VENDOR is not set
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_BOOT_SYSFS=m
CONFIG_SCSI_BNX2_ISCSI=m
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
CONFIG_SCSI_HPSA=m
CONFIG_SCSI_3W_9XXX=m
CONFIG_SCSI_3W_SAS=m
CONFIG_SCSI_7000FASST=m
CONFIG_SCSI_ACARD=m
CONFIG_SCSI_AHA152X=m
CONFIG_SCSI_AHA1542=m
CONFIG_SCSI_AHA1740=m
CONFIG_SCSI_AACRAID=m
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_BUILD_FIRMWARE is not set
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC7XXX_OLD=m
# CONFIG_SCSI_AIC79XX is not set
CONFIG_SCSI_AIC94XX=m
# CONFIG_AIC94XX_DEBUG is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
CONFIG_SCSI_DPT_I2O=m
CONFIG_SCSI_ADVANSYS=m
# CONFIG_SCSI_IN2000 is not set
CONFIG_SCSI_ARCMSR=m
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=m
# CONFIG_MEGARAID_MAILBOX is not set
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=m
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_UFSHCD is not set
CONFIG_SCSI_HPTIOP=m
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_LIBFC=m
CONFIG_LIBFCOE=m
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_DTC3280 is not set
CONFIG_SCSI_EATA=m
# CONFIG_SCSI_EATA_TAGGED_QUEUE is not set
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_GENERIC_NCR5380 is not set
CONFIG_SCSI_GENERIC_NCR5380_MMIO=m
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_NCR53C406A is not set
CONFIG_SCSI_STEX=m
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_PAS16 is not set
# CONFIG_SCSI_QLOGIC_FAS is not set
CONFIG_SCSI_QLOGIC_1280=m
CONFIG_SCSI_QLA_FC=m
# CONFIG_TCM_QLA2XXX is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_SIM710 is not set
# CONFIG_SCSI_SYM53C416 is not set
# CONFIG_SCSI_DC390T is not set
CONFIG_SCSI_T128=m
# CONFIG_SCSI_U14_34F is not set
# CONFIG_SCSI_ULTRASTOR is not set
CONFIG_SCSI_NSP32=m
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
CONFIG_SCSI_BFA_FC=m
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
CONFIG_TARGET_CORE=m
# CONFIG_TCM_IBLOCK is not set
CONFIG_TCM_FILEIO=m
# CONFIG_TCM_PSCSI is not set
CONFIG_LOOPBACK_TARGET=m
CONFIG_TCM_FC=m
# CONFIG_ISCSI_TARGET is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
# CONFIG_FUSION_FC is not set
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=m
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=m
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=m
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
CONFIG_MII=m
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_RIONET is not set
CONFIG_TUN=m
CONFIG_VETH=m
CONFIG_SUNGEM_PHY=m
CONFIG_ARCNET=m
# CONFIG_ARCNET_1201 is not set
CONFIG_ARCNET_1051=m
CONFIG_ARCNET_RAW=m
# CONFIG_ARCNET_CAP is not set
# CONFIG_ARCNET_COM90xx is not set
CONFIG_ARCNET_COM90xxIO=m
# CONFIG_ARCNET_RIM_I is not set
CONFIG_ARCNET_COM20020=m
# CONFIG_ARCNET_COM20020_ISA is not set
# CONFIG_ARCNET_COM20020_PCI is not set
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#
# CONFIG_CAIF_TTY is not set
CONFIG_CAIF_SPI_SLAVE=m
CONFIG_CAIF_SPI_SYNC=y
CONFIG_CAIF_HSI=m
CONFIG_ETHERNET=y
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
CONFIG_NET_VENDOR_ALTEON=y
CONFIG_ACENIC=m
CONFIG_ACENIC_OMIT_TIGON_I=y
# CONFIG_NET_VENDOR_AMD is not set
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
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_CALXEDA_XGMAC=m
# CONFIG_NET_VENDOR_CHELSIO is not set
# CONFIG_NET_VENDOR_CIRRUS is not set
# CONFIG_DNET is not set
# CONFIG_NET_VENDOR_DEC is not set
CONFIG_NET_VENDOR_DLINK=y
CONFIG_DL2K=m
# CONFIG_SUNDANCE is not set
# CONFIG_NET_VENDOR_EXAR is not set
CONFIG_NET_VENDOR_FUJITSU=y
CONFIG_ETH16I=m
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
# CONFIG_NET_VENDOR_INTEL is not set
CONFIG_JME=m
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_SKGE=m
# CONFIG_SKGE_DEBUG is not set
# CONFIG_SKGE_GENESIS is not set
CONFIG_SKY2=m
# CONFIG_SKY2_DEBUG is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
# CONFIG_NET_VENDOR_OKI is not set
# CONFIG_ETHOC is not set
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
# CONFIG_NET_VENDOR_RACAL is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_8139TOO is not set
# CONFIG_R8169 is not set
CONFIG_NET_VENDOR_RDC=y
CONFIG_R6040=m
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
CONFIG_SIS190=m
# CONFIG_NET_VENDOR_SMSC is not set
# CONFIG_NET_VENDOR_STMICRO is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
CONFIG_SUNGEM=m
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
# CONFIG_FDDI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
# CONFIG_AMD_PHY is not set
CONFIG_MARVELL_PHY=m
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=m
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM87XX_PHY is not set
CONFIG_ICPLUS_PHY=m
# CONFIG_REALTEK_PHY is not set
CONFIG_NATIONAL_PHY=m
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
CONFIG_MICREL_PHY=m
# CONFIG_MDIO_BITBANG is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_ISDN is not set

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
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=m
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_OMAP4 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_GAMEPORT=m
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=m
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=m
# CONFIG_CYCLADES is not set
CONFIG_MOXA_INTELLIO=m
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
CONFIG_SYNCLINKMP=m
# CONFIG_SYNCLINK_GT is not set
CONFIG_ISI=m
# CONFIG_N_HDLC is not set
CONFIG_TRACE_ROUTER=m
CONFIG_TRACE_SINK=m
CONFIG_DEVKMEM=y
# CONFIG_STALDRV is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=m
CONFIG_SERIAL_8250_PNP=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_FOURPORT is not set
# CONFIG_SERIAL_8250_ACCENT is not set
CONFIG_SERIAL_8250_BOCA=m
CONFIG_SERIAL_8250_EXAR_ST16C554=m
CONFIG_SERIAL_8250_HUB6=m
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_TIMBERDALE=m
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_PCH_UART=m
# CONFIG_SERIAL_XILINX_PS_UART is not set
CONFIG_TTY_PRINTK=y
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=m
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
# CONFIG_HW_RANDOM_INTEL is not set
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_GEODE is not set
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_NVRAM=m
# CONFIG_RTC is not set
CONFIG_GEN_RTC=m
CONFIG_GEN_RTC_X=y
CONFIG_DTLK=m
CONFIG_R3964=m
CONFIG_APPLICOM=m
CONFIG_MWAVE=m
CONFIG_SCx200_GPIO=m
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=m
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
# CONFIG_I2C_HELPER_AUTO is not set
# CONFIG_I2C_SMBUS is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_PIIX4=m
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=m
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=m
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_ISA is not set
# CONFIG_SCx200_I2C is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
CONFIG_I2C_DEBUG_ALGO=y
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
CONFIG_ARCH_REQUIRE_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_DEBUG_GPIO=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=m
CONFIG_GPIO_STA2X11=y
CONFIG_GPIO_SCH=m
CONFIG_GPIO_ICH=m
CONFIG_GPIO_VX855=m

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
# CONFIG_GPIO_PCH is not set
CONFIG_GPIO_ML_IOH=m
# CONFIG_GPIO_RDC321X is not set

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
# CONFIG_GPIO_JANZ_TTL is not set
CONFIG_W1=m

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS1WM is not set
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=m
CONFIG_W1_SLAVE_DS2423=m
CONFIG_W1_SLAVE_DS2431=m
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=m
CONFIG_W1_SLAVE_DS2780=m
# CONFIG_W1_SLAVE_DS2781 is not set
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2760=m
CONFIG_BATTERY_DS2780=m
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=m
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=m
CONFIG_CHARGER_MAX8903=m
CONFIG_CHARGER_LP8727=m
CONFIG_CHARGER_GPIO=m
CONFIG_CHARGER_SMB347=m
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_DS620=m
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_GL518SM=m
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=m
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=m
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SHT21 is not set
CONFIG_SENSORS_SIS5595=m
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=m
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=m
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_ADS1015=m
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=m
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83627HF=m
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_THERMAL=m
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_ACQUIRE_WDT=m
CONFIG_ADVANTECH_WDT=m
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=m
CONFIG_I6300ESB_WDT=m
CONFIG_IE6XX_WDT=m
CONFIG_ITCO_WDT=m
# CONFIG_ITCO_VENDOR_SUPPORT is not set
# CONFIG_IT8712F_WDT is not set
CONFIG_HP_WATCHDOG=m
CONFIG_HPWDT_NMI_DECODING=y
# CONFIG_SC1200_WDT is not set
# CONFIG_SCx200_WDT is not set
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=m
# CONFIG_RDC321X_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
CONFIG_SBC7240_WDT=m
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=m
# CONFIG_SMSC37B787_WDT is not set
CONFIG_VIA_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83697HF_WDT=m
CONFIG_W83697UG_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# ISA-based Watchdog Cards
#
CONFIG_PCWATCHDOG=m
CONFIG_MIXCOMWD=m
# CONFIG_WDT is not set

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
CONFIG_SSB_SILENT=y
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
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_MFD_LM3533=m
# CONFIG_TPS6105X is not set
CONFIG_TPS65010=m
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_ABX500_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_LPC_SCH=m
CONFIG_LPC_ICH=m
CONFIG_MFD_RDC321X=m
CONFIG_MFD_JANZ_CMODIO=m
CONFIG_MFD_VX855=m
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_STA2X11=y
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=m
CONFIG_AGP_ALI=m
CONFIG_AGP_ATI=m
# CONFIG_AGP_AMD is not set
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_NVIDIA is not set
CONFIG_AGP_SIS=m
# CONFIG_AGP_SWORKS is not set
CONFIG_AGP_VIA=m
CONFIG_AGP_EFFICEON=m
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
# CONFIG_DRM is not set
CONFIG_STUB_POULSBO=m
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=m
CONFIG_FIRMWARE_EDID=y
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
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=m
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=m
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=m
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=m
CONFIG_FB_NVIDIA_I2C=y
CONFIG_FB_NVIDIA_DEBUG=y
CONFIG_FB_NVIDIA_BACKLIGHT=y
# CONFIG_FB_RIVA is not set
CONFIG_FB_LE80578=m
CONFIG_FB_CARILLO_RANCH=m
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
CONFIG_FB_ATY128=m
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=m
CONFIG_FB_ATY_CT=y
# CONFIG_FB_ATY_GENERIC_LCD is not set
# CONFIG_FB_ATY_GX is not set
# CONFIG_FB_ATY_BACKLIGHT is not set
# CONFIG_FB_S3 is not set
CONFIG_FB_SIS=m
# CONFIG_FB_SIS_300 is not set
# CONFIG_FB_SIS_315 is not set
CONFIG_FB_VIA=m
CONFIG_FB_VIA_DIRECT_PROCFS=y
# CONFIG_FB_VIA_X_COMPATIBILITY is not set
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=m
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=m
CONFIG_FB_CARMINE=m
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
# CONFIG_FB_TMIO is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=m
# CONFIG_FB_AUO_K190X is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=m
CONFIG_BACKLIGHT_GENERIC=m
CONFIG_BACKLIGHT_LM3533=m
CONFIG_BACKLIGHT_PROGEAR=m
CONFIG_BACKLIGHT_CARILLO_RANCH=m
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=m
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LP855X is not set
# CONFIG_LOGO is not set
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_COMPRESS_OFFLOAD=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
CONFIG_SND_PCM_XRUN_DEBUG=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
CONFIG_SND_OPL3_LIB_SEQ=m
CONFIG_SND_OPL4_LIB_SEQ=m
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_OPL4_LIB=m
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_WSS_LIB=m
CONFIG_SND_SB_COMMON=m
CONFIG_SND_SB8_DSP=m
CONFIG_SND_SB16_DSP=m
CONFIG_SND_ISA=y
CONFIG_SND_ADLIB=m
CONFIG_SND_AD1816A=m
CONFIG_SND_AD1848=m
CONFIG_SND_ALS100=m
# CONFIG_SND_AZT1605 is not set
# CONFIG_SND_AZT2316 is not set
CONFIG_SND_AZT2320=m
CONFIG_SND_CMI8330=m
CONFIG_SND_CS4231=m
CONFIG_SND_CS4236=m
# CONFIG_SND_ES1688 is not set
CONFIG_SND_ES18XX=m
# CONFIG_SND_SC6000 is not set
# CONFIG_SND_GUSCLASSIC is not set
CONFIG_SND_GUSEXTREME=m
# CONFIG_SND_GUSMAX is not set
# CONFIG_SND_INTERWAVE is not set
# CONFIG_SND_INTERWAVE_STB is not set
CONFIG_SND_JAZZ16=m
CONFIG_SND_OPL3SA2=m
CONFIG_SND_OPTI92X_AD1848=m
# CONFIG_SND_OPTI92X_CS4231 is not set
CONFIG_SND_OPTI93X=m
# CONFIG_SND_MIRO is not set
CONFIG_SND_SB8=m
# CONFIG_SND_SB16 is not set
# CONFIG_SND_SBAWE is not set
CONFIG_SND_SSCAPE=m
# CONFIG_SND_WAVEFRONT is not set
# CONFIG_SND_PCI is not set
CONFIG_SND_SOC=m
CONFIG_SND_SOC_I2C_AND_SPI=m
# CONFIG_SND_SOC_ALL_CODECS is not set
CONFIG_SND_SIMPLE_CARD=m
CONFIG_SOUND_PRIME=m
# CONFIG_SOUND_MSNDCLAS is not set
# CONFIG_SOUND_MSNDPIN is not set
# CONFIG_SOUND_OSS is not set

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

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_MMC is not set
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
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3533 is not set
# CONFIG_LEDS_NET48XX is not set
CONFIG_LEDS_WRAP=m
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_LP3944=m
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=m
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA9633=m
CONFIG_LEDS_BD2802=m
CONFIG_LEDS_LT3593=m
CONFIG_LEDS_TCA6507=m
# CONFIG_LEDS_LM3556 is not set
CONFIG_LEDS_OT200=m
# CONFIG_LEDS_BLINKM is not set
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_GPIO is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
# CONFIG_ACCESSIBILITY is not set
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
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV=m
CONFIG_UIO_PDRV_GENIRQ=m
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
CONFIG_UIO_NETX=m
CONFIG_VIRTIO=m
CONFIG_VIRTIO_RING=m

#
# Virtio drivers
#
CONFIG_VIRTIO_BALLOON=m

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACERHDF=m
CONFIG_ASUS_LAPTOP=m
# CONFIG_FUJITSU_LAPTOP is not set
CONFIG_FUJITSU_TABLET=m
# CONFIG_AMILO_RFKILL is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
CONFIG_COMPAL_LAPTOP=m
CONFIG_SONY_LAPTOP=m
# CONFIG_SONYPI_COMPAT is not set
# CONFIG_IDEAPAD_LAPTOP is not set
CONFIG_THINKPAD_ACPI=m
# CONFIG_THINKPAD_ACPI_ALSA_SUPPORT is not set
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
CONFIG_THINKPAD_ACPI_DEBUG=y
CONFIG_THINKPAD_ACPI_UNSAFE_LEDS=y
# CONFIG_THINKPAD_ACPI_VIDEO is not set
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_SENSORS_HDAPS=m
# CONFIG_ACPI_WMI is not set
CONFIG_TOPSTAR_LAPTOP=m
# CONFIG_TOSHIBA_BT_RFKILL is not set
CONFIG_ACPI_CMPC=m
# CONFIG_INTEL_IPS is not set
CONFIG_IBM_RTL=m
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_INTEL_OAKTRAIL=m
# CONFIG_SAMSUNG_Q10 is not set
CONFIG_APPLE_GMUX=m

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
# CONFIG_VIRT_DRIVERS is not set
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
CONFIG_DEVFREQ_GOV_POWERSAVE=y
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=m

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=m
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_ISCSI_IBFT is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=m
CONFIG_EXT4_USE_FOR_EXT23=y
CONFIG_EXT4_FS_XATTR=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_EXT4_DEBUG=y
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
CONFIG_JFS_DEBUG=y
# CONFIG_JFS_STATISTICS is not set
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=m
CONFIG_OCFS2_FS=m
# CONFIG_OCFS2_FS_O2CB is not set
# CONFIG_OCFS2_FS_STATS is not set
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=m
CONFIG_QFMT_V1=m
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
# CONFIG_CUSE is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
# CONFIG_PROC_VMCORE is not set
CONFIG_PROC_SYSCTL=y
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_SYSFS=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=m
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=m
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=m
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=m
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=m
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=m
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=m
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=m
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=m

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_LKDTM=m
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
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
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_EVENT_POWER_TRACING_DEPRECATED=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_BRANCH_TRACER is not set
CONFIG_STACK_TRACER=y
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_KPROBE_EVENT=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
CONFIG_MMIOTRACE_TEST=m
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
CONFIG_DEBUG_NX_TEST=m
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
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
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
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
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=m
# CONFIG_CRYPTO_NULL is not set
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
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_LRW=m
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_AES_NI_INTEL=m
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_CAMELLIA=m
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=m
# CONFIG_CRYPTO_DES is not set
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_586=m
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_586=m

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=m
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=m
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
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set

--0OAP2g/MAC+5xKAE--
