Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933841Ab2HQJX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 05:23:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:56375 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933704Ab2HQJXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 05:23:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,783,1336374000"; 
   d="scan'208";a="203408516"
Date: Fri, 17 Aug 2012 17:23:07 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: rebalance_domains() triggered a lockdep warning
Message-ID: <20120817092307.GA30494@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

rebalance_domains() triggered this warning in lockdep.c:

                if (DEBUG_LOCKS_WARN_ON(!current->hardirqs_enabled)) {
                        printk("possible reason: unannotated irqs-on.\n");
                }

[    2.736251] Testing tracer branch: [    2.740329] tsc: Refined TSC clocksource calibration: 2833.318 MHz
[    2.784799] ------------[ cut here ]------------
[    2.785509] WARNING: at /c/kernel-tests/src/tip/kernel/lockdep.c:3493 check_flags+0xc0/0x1d0()
[    2.786661] Hardware name: Bochs

[    2.787155] Modules linked in:
[    2.787860] Pid: 0, comm: swapper/0 Not tainted 3.6.0-rc1-00010-g25cd20b #68
[    2.788736] Call Trace:
[    2.788736]  <IRQ>  [<ffffffff8105bb1e>] warn_slowpath_common+0xae/0xf0
[    2.788736]  [<ffffffff8105bb7a>] warn_slowpath_null+0x1a/0x20
[    2.788736]  [<ffffffff810e62f0>] check_flags+0xc0/0x1d0
[    2.788736]  [<ffffffff810ea162>] lock_acquire+0x72/0x230
[    2.788736]  [<ffffffff811319af>] ? rb_reserve_next_event+0x5f/0x370
[    2.788736]  [<ffffffff810c68cb>] rebalance_domains+0x7b/0x480
[    2.788736]  [<ffffffff810c6850>] ? load_balance+0xdb0/0xdb0
[    2.788736]  [<ffffffff81140845>] ? ftrace_likely_update+0xe5/0x260
[    2.788736]  [<ffffffff810c6d28>] run_rebalance_domains+0x58/0x220
[    2.788736]  [<ffffffff8106a697>] __do_softirq+0x127/0x6c0
[    2.788736]  [<ffffffff8144af7c>] call_softirq+0x1c/0x30
[    2.788736]  [<ffffffff81006145>] do_softirq+0x175/0x280
[    2.788736]  [<ffffffff8106b0b7>] irq_exit+0xc7/0x130
[    2.788736]  [<ffffffff810ba9fd>] scheduler_ipi+0xfd/0x150
[    2.788736]  [<ffffffff8103610a>] smp_reschedule_interrupt+0x2a/0x30
[    2.788736]  [<ffffffff8144aaef>] reschedule_interrupt+0x6f/0x80
[    2.788736]  <EOI>  [<ffffffff81040026>] ? native_safe_halt+0x6/0x10
[    2.788736]  [<ffffffff8101262d>] default_idle+0x56d/0x580
[    2.788736]  [<ffffffff81013886>] cpu_idle+0x156/0x160
[    2.788736]  [<ffffffff81416b2c>] rest_init+0x160/0x174
[    2.788736]  [<ffffffff814169cc>] ? csum_partial_copy_generic+0x16c/0x16c
[    2.788736]  [<ffffffff81e2f24a>] start_kernel+0x61c/0x629
[    2.788736]  [<ffffffff81e2e8f5>] ? repair_env_string+0x9f/0x9f
[    2.788736]  [<ffffffff81e2e369>] x86_64_start_reservations+0x165/0x169
[    2.788736]  [<ffffffff81e2e5ee>] x86_64_start_kernel+0x281/0x290

Thanks,
Fengguang

--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-stoakley-4575-2012-08-11-01-00-48-3.6.0-rc1-00010-g25cd20b-68"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Linux version 3.6.0-rc1-00010-g25cd20b (kbuild@snb) (gcc ver=
sion 4.7.1 (Debian 4.7.1-6) ) #68 SMP PREEMPT Sat Aug 11 00:49:07 CST 2012
[    0.000000] Command line: trinity=3D2m hung_task_panic=3D1 branch=3Dmikl=
os-vfs/overlayfs.v14 log_buf_len=3D8M ignore_loglevel debug sched_debug api=
c=3Ddebug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D=
0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw l=
ink=3Dvmlinuz-2012-08-11-00-50-38-miklos-vfs:overlayfs.v14:1182ebc-25cd20b-=
x86_64-randconfig-s059-1-stoakley BOOT_IMAGE=3Dkernel-tests/kernels/x86_64-=
randconfig-s059/25cd20b/vmlinuz-3.6.0-rc1-00010-g25cd20b
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f400-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffcfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffd000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffbc000-0x00000000ffffffff] reser=
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
[    0.000000] e820: last_pfn =3D 0xfffd max_arch_pfn =3D 0x400000000
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x0, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f8860-0x000f886f] mapped at =
[ffff8800000f8860]
[    0.000000]   mpc: f8870-f898c
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffcfff]
[    0.000000]  [mem 0x00000000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffcfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffcfff @ [mem 0x0e8540=
00-0x0e8d5fff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128060(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000f8810 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffde10 00034 (v01 BOCHS  BXPCRSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000ffffe40 00074 (v01 BOCHS  BXPCFACP 00000=
001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffdfd0 01E22 (v01   BXPC   BXDSDT 00000=
001 INTL 20090123)
[    0.000000] ACPI: FACS 000000000ffffe00 00040
[    0.000000] ACPI: SSDT 000000000fffdf80 00044 (v01 BOCHS  BXPCSSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000fffde90 0007A (v01 BOCHS  BXPCAPIC 00000=
001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000fffde50 00038 (v01 BOCHS  BXPCHPET 00000=
001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 12 and 11
[    0.000000] kvm-clock: cpu 0, msr 0:1e2d0c1, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffcfff]
[    0.000000] On node 0 totalpages: 65420
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3913 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 960 pages used for memmap
[    0.000000]   DMA32 zone: 60477 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
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
[    0.000000] e820: [mem 0x10000000-0xfffbbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 474 pages/cpu @ffff88000da00000 s1912256 r8=
192 d21056 u2097152
[    0.000000] pcpu-alloc: s1912256 r8192 d21056 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:dbd20c1, primary cpu clock
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64390
[    0.000000] Kernel command line: trinity=3D2m hung_task_panic=3D1 branch=
=3Dmiklos-vfs/overlayfs.v14 log_buf_len=3D8M ignore_loglevel debug sched_de=
bug apic=3Ddebug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ram=
disk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ra=
m0 rw link=3Dvmlinuz-2012-08-11-00-50-38-miklos-vfs:overlayfs.v14:1182ebc-2=
5cd20b-x86_64-randconfig-s059-1-stoakley BOOT_IMAGE=3Dkernel-tests/kernels/=
x86_64-randconfig-s059/25cd20b/vmlinuz-3.6.0-rc1-00010-g25cd20b
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 194932k/262132k available (4402k kernel code, 452k a=
bsent, 66748k reserved, 8244k data, 2448k init)
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D2, Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
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
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ODEBUG: 2 of 2 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2833.416 MHz processor
[    0.004000] Calibrating delay loop (skipped) preset value.. 5666.83 Bogo=
MIPS (lpj=3D11333664)
[    0.004000] pid_max: default: 32768 minimum: 301
[    0.004000] Security Framework initialized
[    0.004000] Yama: becoming mindful.
[    0.004174] Mount-cache hash table entries: 256
[    0.006516] Disabled fast string operations
[    0.007077] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.007077] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.007077] tlb_flushall_shift is 0x6
[    0.013262] ACPI: Core revision 20120711
[    0.016550] ftrace: allocating 11289 entries in 45 pages
[    0.020371] Getting VERSION: 50014
[    0.020823] Getting VERSION: 50014
[    0.021259] Getting ID: 0
[    0.021600] Getting ID: ff000000
[    0.022023] Getting LVT0: 8700
[    0.024015] Getting LVT1: 8400
[    0.024473] enabled ExtINT on CPU#0
[    0.025946] ENABLING IO-APIC IRQs
[    0.026377] init IO_APIC IRQs
[    0.026756]  apic 2 pin 0 not connected
[    0.027270] IOAPIC[0]: Set routing entry (2-1 -> 0x41 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.028038] IOAPIC[0]: Set routing entry (2-2 -> 0x51 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.029051] IOAPIC[0]: Set routing entry (2-3 -> 0x61 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.030068] IOAPIC[0]: Set routing entry (2-4 -> 0x71 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.031078] IOAPIC[0]: Set routing entry (2-5 -> 0x81 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.032072] IOAPIC[0]: Set routing entry (2-6 -> 0x91 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.033071] IOAPIC[0]: Set routing entry (2-7 -> 0xa1 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.034068] IOAPIC[0]: Set routing entry (2-8 -> 0xb1 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.035066] IOAPIC[0]: Set routing entry (2-9 -> 0xc1 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.036033] IOAPIC[0]: Set routing entry (2-10 -> 0xd1 -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.037051] IOAPIC[0]: Set routing entry (2-11 -> 0xe1 -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.038112] IOAPIC[0]: Set routing entry (2-12 -> 0x22 -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.040033] IOAPIC[0]: Set routing entry (2-13 -> 0x42 -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.041067] IOAPIC[0]: Set routing entry (2-14 -> 0x52 -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.042083] IOAPIC[0]: Set routing entry (2-15 -> 0x62 -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.043100]  apic 2 pin 16 not connected
[    0.043596]  apic 2 pin 17 not connected
[    0.044009]  apic 2 pin 18 not connected
[    0.044526]  apic 2 pin 19 not connected
[    0.045017]  apic 2 pin 20 not connected
[    0.045511]  apic 2 pin 21 not connected
[    0.046001]  apic 2 pin 22 not connected
[    0.046495]  apic 2 pin 23 not connected
[    0.047142] ..TIMER: vector=3D0x51 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.048009] smpboot: CPU0: Intel Common KVM processor stepping 01
[    0.049259] Using local APIC timer interrupts.
[    0.049259] calibrating APIC timer ...
[    0.052003] ... lapic delta =3D 6249955
[    0.052003] ... PM-Timer delta =3D 357952
[    0.052003] ... PM-Timer result ok
[    0.052003] ..... delta 6249955
[    0.052003] ..... mult: 268416747
[    0.052003] ..... calibration result: 3999971
[    0.052003] ..... CPU clock speed is 2833.1231 MHz.
[    0.052003] ..... host bus clock speed is 999.3971 MHz.
[    0.052068] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.072437] Testing tracer nop: PASSED
[    0.084121] SMP alternatives: lockdep: fixing up alternatives
[    0.085243] smpboot: Booting Node   0, Processors  #1 OK
[    0.004000] kvm-clock: cpu 1, msr 0:ddd20c1, secondary cpu clock
[    0.004000] masked ExtINT on CPU#1
[    0.004000] Disabled fast string operations
[    0.120138] Brought up 2 CPUs
[    0.120536] smpboot: Total of 2 processors activated (11333.66 BogoMIPS)
[    0.124256] x86 PAT enabled: cpu 0, old 0x70106, new 0x7010600070106
[    0.125311] CPU0 attaching sched-domain:
[    0.125852]  domain 0: span 0-1 level CPU
[    0.126375]   groups: 0 (cpu_power =3D 1023) 1
[    0.126994] CPU1 attaching sched-domain:
[    0.127482]  domain 0: span 0-1 level CPU
[    0.127995]   groups: 1 0 (cpu_power =3D 1023)
[    0.132037] devtmpfs: initialized
[    0.137983] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.139498] dummy:=20
[    0.140296] NET: Registered protocol family 16
[    0.141519] ACPI: bus type pci registered
[    0.142213] PCI: Using configuration type 1 for base access
[    0.143016] mtrr: your CPUs had inconsistent variable MTRR settings
[    0.143781] mtrr: your CPUs had inconsistent MTRRdefType settings
[    0.144020] mtrr: probably your BIOS does not setup all CPUs.
[    0.144722] mtrr: corrected configuration.
[    0.148387] ACPI: Added _OSI(Module Device)
[    0.148879] ACPI: Added _OSI(Processor Device)
[    0.152022] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.152613] ACPI: Added _OSI(Processor Aggregator Device)
[    0.157063] ACPI: EC: Look up EC in DSDT
[    0.164381] ACPI: Interpreter enabled
[    0.164844] ACPI: (supports S0 S3 S5)
[    0.165427] ACPI: Using IOAPIC for interrupt routing
[    0.181163] PCI: Ignoring host bridge windows from ACPI; if necessary, u=
se "pci=3Duse_crs" and report a bug
[    0.182440] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.183257] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] =
(ignored)
[    0.184025] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] =
(ignored)
[    0.184926] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x00=
0bffff] (ignored)
[    0.185969] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfe=
bfffff] (ignored)
[    0.186966] PCI: root bus 00: using default resources
[    0.188034] PCI host bridge to bus 0000:00
[    0.188564] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under dom=
ain [bus 00-ff]
[    0.189571] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.190276] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.191027] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffff=
fff]
[    0.191980] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.192469] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.193843] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.194936] pci 0000:00:01.1: reg 20: [io  0xc000-0xc00f]
[    0.196301] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.197609] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.198512] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.199573] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.203209] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf1ffffff pref]
[    0.205544] pci 0000:00:02.0: reg 14: [mem 0xf2000000-0xf2000fff]
[    0.214355] pci 0000:00:02.0: reg 30: [mem 0xf2010000-0xf201ffff pref]
[    0.216337] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.217220] pci 0000:00:03.0: reg 10: [mem 0xf2020000-0xf203ffff]
[    0.218143] pci 0000:00:03.0: reg 14: [io  0xc040-0xc07f]
[    0.219574] pci 0000:00:03.0: reg 30: [mem 0xf2040000-0xf2047fff pref]
[    0.220343] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.221271] pci 0000:00:04.0: reg 10: [io  0xc080-0xc0bf]
[    0.222032] pci 0000:00:04.0: reg 14: [mem 0xf2048000-0xf2048fff]
[    0.224061] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.224937] pci 0000:00:05.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.225723] pci 0000:00:05.0: reg 14: [mem 0xf2049000-0xf2049fff]
[    0.227208] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.228106] pci 0000:00:06.0: reg 10: [io  0xc100-0xc13f]
[    0.228858] pci 0000:00:06.0: reg 14: [mem 0xf204a000-0xf204afff]
[    0.230381] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.231259] pci 0000:00:07.0: reg 10: [io  0xc140-0xc17f]
[    0.232037] pci 0000:00:07.0: reg 14: [mem 0xf204b000-0xf204bfff]
[    0.233527] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.234428] pci 0000:00:08.0: reg 10: [io  0xc180-0xc1bf]
[    0.235180] pci 0000:00:08.0: reg 14: [mem 0xf204c000-0xf204cfff]
[    0.236673] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.237579] pci 0000:00:09.0: reg 10: [io  0xc1c0-0xc1ff]
[    0.238356] pci 0000:00:09.0: reg 14: [mem 0xf204d000-0xf204dfff]
[    0.239797] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.240120] pci 0000:00:0a.0: reg 10: [mem 0xf204e000-0xf204e00f]
[    0.241773] pci_bus 0000:00: on NUMA node 0
[    0.242382] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.245414]  pci0000:00: Unable to request _OSC control (_OSC support ma=
sk: 0x08)
[    0.265972] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.266914] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.267879] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.268393] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.269700] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.269700] vgaarb: loaded
[    0.272034] vgaarb: bridge control possible 0000:00:02.0
[    0.272793] PCI: Using ACPI for IRQ routing
[    0.273325] PCI: pci_cache_line_size set to 64 bytes
[    0.274439] e820: reserve RAM buffer [mem 0x0009f400-0x0009ffff]
[    0.275188] e820: reserve RAM buffer [mem 0x0fffd000-0x0fffffff]
[    0.277107] Switching to clocksource kvm-clock
[    0.293220] Warning: could not register all branches stats
[    0.293924] Warning: could not register annotated branches stats
[    0.310096] pnp: PnP ACPI init
[    0.310527] ACPI: bus type pnp registered
[    0.311096] pnp 00:00: [bus 00-ff]
[    0.311524] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.312093] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.312709] pnp 00:00: [io  0x0d00-0xffff window]
[    0.313296] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.313969] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    0.314854] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.316101] pnp 00:01: [io  0x0070-0x0071]
[    0.316671] pnp 00:01: [irq 8]
[    0.317056] pnp 00:01: [io  0x0072-0x0077]
[    0.317721] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.318602] pnp 00:02: [io  0x0060]
[    0.319047] pnp 00:02: [io  0x0064]
[    0.319486] pnp 00:02: [irq 1]
[    0.320090] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.320980] pnp 00:03: [irq 12]
[    0.321531] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.322425] pnp 00:04: [io  0x03f2-0x03f5]
[    0.322965] pnp 00:04: [io  0x03f7]
[    0.323406] pnp 00:04: [irq 6]
[    0.323797] pnp 00:04: [dma 2]
[    0.324419] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.325328] pnp 00:05: [io  0x0378-0x037f]
[    0.325853] pnp 00:05: [irq 7]
[    0.326399] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.327299] pnp 00:06: [io  0x03f8-0x03ff]
[    0.327826] pnp 00:06: [irq 4]
[    0.328443] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.329357] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    0.330140] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.331184] pnp: PnP ACPI: found 8 devices
[    0.331704] ACPI: ACPI bus type pnp unregistered
[    0.338516] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.339207] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[    0.340114] NET: Registered protocol family 1
[    0.340706] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.341454] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.342201] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.343015] pci 0000:00:02.0: Boot video device
[    0.343718] PCI: CLS 0 bytes, default 64
[    0.344626] Unpacking initramfs...
[    1.691578] Freeing initrd memory: 23656k freed
[    1.741569] DMA-API: preallocated 32768 debug entries
[    1.742231] DMA-API: debugging enabled by kernel config
[    1.756604] audit: initializing netlink socket (disabled)
[    1.757382] type=3D2000 audit(1344618040.756:1): initialized
[    1.766709] Testing tracer function: PASSED
[    1.974421] Testing dynamic ftrace: PASSED
[    2.240334] Testing dynamic ftrace ops #1: (1 0 1 1 0) (1 1 2 1 0) (2 1 =
3 1 37) (2 2 4 1 153) PASSED
[    2.374205] Testing dynamic ftrace ops #2: (1 0 1 69 0) (1 1 2 151 0) (2=
 1 3 2 48) (2 2 4 114 159) PASSED
[    2.580292] Testing tracer irqsoff: PASSED
[    2.736251] Testing tracer branch: [    2.740329] tsc: Refined TSC clock=
source calibration: 2833.318 MHz
[    2.784799] ------------[ cut here ]------------
[    2.785509] WARNING: at /c/kernel-tests/src/tip/kernel/lockdep.c:3493 ch=
eck_flags+0xc0/0x1d0()
[    2.786661] Hardware name: Bochs

[    2.787155] Modules linked in:
[    2.787860] Pid: 0, comm: swapper/0 Not tainted 3.6.0-rc1-00010-g25cd20b=
 #68
[    2.788736] Call Trace:
[    2.788736]  <IRQ>  [<ffffffff8105bb1e>] warn_slowpath_common+0xae/0xf0
[    2.788736]  [<ffffffff8105bb7a>] warn_slowpath_null+0x1a/0x20
[    2.788736]  [<ffffffff810e62f0>] check_flags+0xc0/0x1d0
[    2.788736]  [<ffffffff810ea162>] lock_acquire+0x72/0x230
[    2.788736]  [<ffffffff811319af>] ? rb_reserve_next_event+0x5f/0x370
[    2.788736]  [<ffffffff810c68cb>] rebalance_domains+0x7b/0x480
[    2.788736]  [<ffffffff810c6850>] ? load_balance+0xdb0/0xdb0
[    2.788736]  [<ffffffff81140845>] ? ftrace_likely_update+0xe5/0x260
[    2.788736]  [<ffffffff810c6d28>] run_rebalance_domains+0x58/0x220
[    2.788736]  [<ffffffff8106a697>] __do_softirq+0x127/0x6c0
[    2.788736]  [<ffffffff8144af7c>] call_softirq+0x1c/0x30
[    2.788736]  [<ffffffff81006145>] do_softirq+0x175/0x280
[    2.788736]  [<ffffffff8106b0b7>] irq_exit+0xc7/0x130
[    2.788736]  [<ffffffff810ba9fd>] scheduler_ipi+0xfd/0x150
[    2.788736]  [<ffffffff8103610a>] smp_reschedule_interrupt+0x2a/0x30
[    2.788736]  [<ffffffff8144aaef>] reschedule_interrupt+0x6f/0x80
[    2.788736]  <EOI>  [<ffffffff81040026>] ? native_safe_halt+0x6/0x10
[    2.788736]  [<ffffffff8101262d>] default_idle+0x56d/0x580
[    2.788736]  [<ffffffff81013886>] cpu_idle+0x156/0x160
[    2.788736]  [<ffffffff81416b2c>] rest_init+0x160/0x174
[    2.788736]  [<ffffffff814169cc>] ? csum_partial_copy_generic+0x16c/0x16c
[    2.788736]  [<ffffffff81e2f24a>] start_kernel+0x61c/0x629
[    2.788736]  [<ffffffff81e2e8f5>] ? repair_env_string+0x9f/0x9f
[    2.788736]  [<ffffffff81e2e369>] x86_64_start_reservations+0x165/0x169
[    2.788736]  [<ffffffff81e2e5ee>] x86_64_start_kernel+0x281/0x290
[    2.788736] ---[ end trace 284bb615d494e199 ]---
[    2.788736] possible reason: unannotated irqs-on.
[    2.788736] irq event stamp: 15967
[    2.788736] hardirqs last  enabled at (15966): [<ffffffff8106a5f8>] __do=
_softirq+0x88/0x6c0
[    2.788736] hardirqs last disabled at (15967): [<ffffffff811407f7>] ftra=
ce_likely_update+0x97/0x260
[    2.788736] softirqs last  enabled at (15964): [<ffffffff8106a433>] _loc=
al_bh_enable+0x13/0x20
[    2.788736] softirqs last disabled at (15965): [<ffffffff8144af7c>] call=
_softirq+0x1c/0x30
[    2.892256] PASSED
[    2.893356] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.898248] VFS: Disk quotas dquot_6.5.2
[    2.898878] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.900500] cryptomgr_test (27) used greatest stack depth: 6040 bytes le=
ft
[    2.903059] alg: No test for stdrng (krng)
[    2.904806] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    2.905734] ACPI: Power Button [PWRF]
[    2.953588] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.997778] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    3.039779] 00:06: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    3.040971] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    3.066116] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.066786] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.067518] cpuidle: using governor ladder
[    3.068211] cpuidle: using governor menu
[    3.089906]=20
[    3.089906] printing PIC contents
[    3.090530] ... PIC  IMR: ffff
[    3.090924] ... PIC  IRR: 1013
[    3.091315] ... PIC  ISR: 0000
[    3.091708] ... PIC ELCR: 0c00
[    3.092125] printing local APIC contents on CPU#0/0:
[    3.092772] ... APIC ID:      00000000 (0)
[    3.093280] ... APIC VERSION: 00050014
[    3.093686] ... APIC TASKPRI: 00000000 (00)
[    3.093686] ... APIC PROCPRI: 00000000
[    3.093686] ... APIC LDR: 01000000
[    3.093686] ... APIC DFR: ffffffff
[    3.093686] ... APIC SPIV: 000001ff
[    3.093686] ... APIC ISR field:
[    3.093686] 000000000000000000000000000000000000000000000000000000000000=
0000
[    3.093686] ... APIC TMR field:
[    3.093686] 000000000000000000000000000000000000000000000000000000000000=
0000
[    3.093686] ... APIC IRR field:
[    3.093686] 000000000000000000000000000000000000000000000000000000000000=
8000
[    3.093686] ... APIC ESR: 00000000
[    3.093686] ... APIC ICR: 000008fd
[    3.093686] ... APIC ICR2: 02000000
[    3.093686] ... APIC LVTT: 000000ef
[    3.093686] ... APIC LVTPC: 00010000
[    3.093686] ... APIC LVT0: 00010700
[    3.093686] ... APIC LVT1: 00000400
[    3.093686] ... APIC LVTERR: 000000fe
[    3.093686] ... APIC TMICT: 00025c99
[    3.093686] ... APIC TMCCT: 00000000
[    3.093686] ... APIC TDCR: 00000003
[    3.093686]=20
[    3.133696] number of MP IRQ sources: 15.
[    3.134209] number of IO-APIC #2 registers: 24.
[    3.134770] testing the IO APIC.......................
[    3.135408] IO APIC #2......
[    3.135773] .... register #00: 00000000
[    3.136325] .......    : physical APIC id: 00
[    3.136863] .......    : Delivery Type: 0
[    3.137354] .......    : LTS          : 0
[    3.137851] .... register #01: 00170011
[    3.138321] .......     : max redirection entries: 17
[    3.138941] .......     : PRQ implemented: 0
[    3.139463] .......     : IO APIC version: 11
[    3.140022] .... register #02: 00000000
[    3.140535] .......     : arbitration: 00
[    3.141034] .... IRQ redirection table:
[    3.141507]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    3.142195]  00 00  1    0    0   0   0    0    0    00
[    3.142872]  01 03  0    0    0   0   0    1    1    41
[    3.143541]  02 03  0    0    0   0   0    1    1    51
[    3.144254]  03 01  0    0    0   0   0    1    1    61
[    3.144949]  04 01  1    0    0   0   0    1    1    71
[    3.145615]  05 01  1    1    0   0   0    1    1    81
[    3.146287]  06 01  0    0    0   0   0    1    1    91
[    3.146958]  07 01  0    0    0   0   0    1    1    A1
[    3.147625]  08 01  0    0    0   0   0    1    1    B1
[    3.173610]  09 01  0    1    0   0   0    1    1    C1
[    3.174321]  0a 01  1    1    0   0   0    1    1    D1
[    3.175003]  0b 01  1    1    0   0   0    1    1    E1
[    3.175678]  0c 03  0    0    0   0   0    1    1    22
[    3.176369]  0d 01  0    0    0   0   0    1    1    42
[    3.177363]  0e 01  0    0    0   0   0    1    1    52
[    3.179080]  0f 01  0    0    0   0   0    1    1    62
[    3.179757]  10 00  1    0    0   0   0    0    0    00
[    3.186901]  11 00  1    0    0   0   0    0    0    00
[    3.187597]  12 00  1    0    0   0   0    0    0    00
[    3.190590]  13 00  [    3.195129] input: AT Translated Set 2 keyboard a=
s /devices/platform/i8042/serio0/input/input1
1    0    0   0   0    0    0    00
[    3.201184]  14 00  1    0    0   0   0    0    0    00
[    3.201867]  15 00  1    0    0   0   0    0    0    00
[    3.202536]  16 00  1    0    0   0   0    0    0    00
[    3.203257]  17 00  1    0    0   0   0    0    0    00
[    3.203925] IRQ to pin mappings:
[    3.207164] IRQ0 -> 0:2
[    3.207520] IRQ1 -> 0:1
[    3.207880] IRQ3 -> 0:3
[    3.210703] IRQ4 -> 0:4
[    3.211076] IRQ5 -> 0:5
[    3.211427] IRQ6 -> 0:6
[    3.211783] IRQ7 -> 0:7
[    3.213607] IRQ8 -> 0:8
[    3.213964] IRQ9 -> 0:9
[    3.214313] IRQ10 -> 0:10
[    3.214714] IRQ11 -> 0:11
[    3.215104] IRQ12 -> 0:12
[    3.215470] IRQ13 -> 0:13
[    3.215844] IRQ14 -> 0:14
[    3.218900] IRQ15 -> 0:15
[    3.219293] .................................... done.
[    3.220181] Running tests on trace events:
[    3.222934] Testing event kfree_skb: [    3.240154] test-events (33) use=
d greatest stack depth: 5912 bytes left
OK
[    3.241844] Testing event consume_skb: OK
[    3.256854] Testing event skb_copy_datagram_iovec: OK
[    3.272805] Testing event net_dev_xmit: [    3.288198] test-events (36) =
used greatest stack depth: 5832 bytes left
OK
[    3.289797] Testing event net_dev_queue: OK
[    3.304806] Testing event netif_receive_skb: OK
[    3.320824] Testing event netif_rx: OK
[    3.336923] Testing event napi_poll: OK
[    3.364162] Testing event sock_rcvqueue_full: OK
[    3.384835] Testing event sock_exceed_buf_limit: OK
[    3.400854] Testing event udp_fail_queue_rcv_skb: OK
[    3.416726] Testing event mix_pool_bytes: OK
[    3.432830] Testing event mix_pool_bytes_nolock: OK
[    3.448931] Testing event credit_entropy_bits: OK
[    3.464928] Testing event get_random_bytes: OK
[    3.480879] Testing event extract_entropy: OK
[    3.496898] Testing event extract_entropy_user: OK
[    3.512975] Testing event regulator_enable: OK
[    3.528839] Testing event regulator_enable_delay: OK
[    3.544886] Testing event regulator_enable_complete: OK
[    3.560841] Testing event regulator_disable: OK
[    3.576840] Testing event regulator_disable_complete: OK
[    3.592821] Testing event regulator_set_voltage: OK
[    3.608864] Testing event regulator_set_voltage_complete: OK
[    3.624926] Testing event gpio_direction: OK
[    3.641113] Testing event gpio_value: OK
[    3.657223] Testing event writeback_nothread: OK
[    3.672895] Testing event writeback_queue: OK
[    3.688933] Testing event writeback_exec: OK
[    3.704854] Testing event writeback_start: OK
[    3.720846] Testing event writeback_written: OK
[    3.736860] Testing event writeback_wait: OK
[    3.752810] Testing event writeback_pages_written: OK
[    3.768859] Testing event writeback_nowork: OK
[    3.784814] Testing event writeback_wake_background: OK
[    3.800815] Testing event writeback_wake_thread: OK
[    3.890287] Testing event writeback_wake_forker_thread: OK
[    4.060775] Testing event writeback_bdi_register: OK
[    4.146311] Testing event writeback_bdi_unregister: OK
[    4.354830] Testing event writeback_thread_start: OK
[    4.488819] Testing event writeback_thread_stop: OK
[    4.752890] Testing event wbc_writepage: OK
[    4.768470] Testing event writeback_queue_io: OK
[    4.784468] Testing event global_dirty_state: OK
[    4.800470] Testing event bdi_dirty_ratelimit: OK
[    4.816500] Testing event balance_dirty_pages: OK
[    4.832541] Testing event writeback_sb_inodes_requeue: OK
[    4.848513] Testing event writeback_congestion_wait: OK
[    4.864507] Testing event writeback_wait_iff_congested: OK
[    4.880510] Testing event writeback_single_inode: OK
[    4.896490] Testing event mm_compaction_isolate_migratepages: OK
[    4.912490] Testing event mm_compaction_isolate_freepages: OK
[    4.928489] Testing event mm_compaction_migratepages: OK
[    4.944490] Testing event kmalloc: OK
[    4.960682] Testing event kmem_cache_alloc: OK
[    4.992823] Testing event kmalloc_node: OK
[    5.008762] Testing event kmem_cache_alloc_node: OK
[    5.024757] Testing event kfree: OK
[    5.040877] Testing event kmem_cache_free: OK
[    5.056858] Testing event mm_page_free: OK
[    5.072870] Testing event mm_page_free_batched: OK
[    5.088861] Testing event mm_page_alloc: OK
[    5.104861] Testing event mm_page_alloc_zone_locked: OK
[    5.120846] Testing event mm_page_pcpu_drain: OK
[    5.136873] Testing event mm_page_alloc_extfrag: OK
[    5.152890] Testing event mm_vmscan_kswapd_sleep: OK
[    5.168842] Testing event mm_vmscan_kswapd_wake: OK
[    5.184853] Testing event mm_vmscan_wakeup_kswapd: OK
[    5.200835] Testing event mm_vmscan_direct_reclaim_begin: OK
[    5.216826] Testing event mm_vmscan_memcg_reclaim_begin: OK
[    5.232702] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[    5.248722] Testing event mm_vmscan_direct_reclaim_end: OK
[    5.264855] Testing event mm_vmscan_memcg_reclaim_end: OK
[    5.280767] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[    5.296751] Testing event mm_shrink_slab_start: OK
[    5.312832] Testing event mm_shrink_slab_end: OK
[    5.330217] Testing event mm_vmscan_lru_isolate: OK
[    5.344852] Testing event mm_vmscan_memcg_isolate: OK
[    5.360713] Testing event mm_vmscan_writepage: OK
[    5.376854] Testing event mm_vmscan_lru_shrink_inactive: OK
[    5.392859] Testing event oom_score_adj_update: OK
[    5.409151] Testing event cpu_idle: OK
[    5.425538] Testing event cpu_frequency: OK
[    5.440715] Testing event machine_suspend: OK
[    5.456925] Testing event wakeup_source_activate: OK
[    5.472833] Testing event wakeup_source_deactivate: OK
[    5.488850] Testing event clock_enable: OK
[    5.504718] Testing event clock_disable: OK
[    5.520715] Testing event clock_set_rate: OK
[    5.536723] Testing event power_domain_target: OK
[    5.552739] Testing event ftrace_test_filter: OK
[    5.568740] Testing event module_load: OK
[    5.584867] Testing event module_free: OK
[    5.600875] Testing event module_request: OK
[    5.616919] Testing event lock_acquire: OK
[    5.632973] Testing event lock_release: OK
[    5.648930] Testing event lock_contended: OK
[    5.664862] Testing event lock_acquired: OK
[    5.680838] Testing event sched_kthread_stop: OK
[    5.696848] Testing event sched_kthread_stop_ret: OK
[    5.712846] Testing event sched_wakeup: OK
[    5.728739] Testing event sched_wakeup_new: OK
[    5.745067] Testing event sched_switch: OK
[    5.760776] Testing event sched_migrate_task: OK
[    5.776857] Testing event sched_process_free: OK
[    5.792838] Testing event sched_process_exit: OK
[    5.808868] Testing event sched_wait_task: OK
[    5.824895] Testing event sched_process_wait: OK
[    5.840844] Testing event sched_process_fork: OK
[    5.856834] Testing event sched_process_exec: OK
[    5.872850] Testing event sched_stat_wait: OK
[    5.888856] Testing event sched_stat_sleep: OK
[    5.904859] Testing event sched_stat_iowait: OK
[    5.920863] Testing event sched_stat_blocked: OK
[    5.936848] Testing event sched_stat_runtime: OK
[    5.952856] Testing event sched_pi_setprio: OK
[    5.968823] Testing event rcu_utilization: OK
[    5.991382] Testing event rcu_grace_period: OK
[    6.009592] Testing event rcu_grace_period_init: OK
[    6.024895] Testing event rcu_preempt_task: OK
[    6.040841] Testing event rcu_unlock_preempted_task: OK
[    6.056861] Testing event rcu_quiescent_state_report: OK
[    6.072982] Testing event rcu_fqs: OK
[    6.088940] Testing event rcu_dyntick: OK
[    6.105436] Testing event rcu_prep_idle: OK
[    6.121736] Testing event rcu_callback: OK
[    6.136855] Testing event rcu_kfree_callback: OK
[    6.152842] Testing event rcu_batch_start: OK
[    6.168960] Testing event rcu_invoke_callback: OK
[    6.184842] Testing event rcu_invoke_kfree_callback: OK
[    6.200844] Testing event rcu_batch_end: OK
[    6.216956] Testing event rcu_torture_read: OK
[    6.232853] Testing event rcu_barrier: OK
[    6.248851] Testing event workqueue_queue_work: OK
[    6.264847] Testing event workqueue_activate_work: OK
[    6.280888] Testing event workqueue_execute_start: OK
[    6.296856] Testing event workqueue_execute_end: OK
[    6.312843] Testing event signal_generate: OK
[    6.328946] Testing event signal_deliver: OK
[    6.344845] Testing event timer_init: OK
[    6.360797] Testing event timer_start: OK
[    6.377170] Testing event timer_expire_entry: OK
[    6.392821] Testing event timer_expire_exit: OK
[    6.447164] Testing event timer_cancel: OK
[    6.465142] Testing event hrtimer_init: OK
[    6.480846] Testing event hrtimer_start: OK
[    6.496798] Testing event hrtimer_expire_entry: OK
[    6.512801] Testing event hrtimer_expire_exit: OK
[    6.528827] Testing event hrtimer_cancel: OK
[    6.545119] Testing event itimer_state: OK
[    6.560911] Testing event itimer_expire: OK
[    6.576916] Testing event irq_handler_entry: OK
[    6.592898] Testing event irq_handler_exit: OK
[    6.608915] Testing event softirq_entry: OK
[    6.624824] Testing event softirq_exit: OK
[    6.640825] Testing event softirq_raise: OK
[    6.656824] Testing event console: OK
[    6.672894] Testing event task_newtask: OK
[    6.688911] Testing event task_rename: OK
[    6.704917] Testing event sys_enter: OK
[    6.721476] Testing event sys_exit: OK
[    6.737269] Testing event emulate_vsyscall: OK
[    6.752896] Running tests on trace event systems:
[    6.753478] Testing event system skb: OK
[    6.773282] Testing event system net: OK
[    6.789267] Testing event system napi: OK
[    6.804843] Testing event system sock: OK
[    6.820937] Testing event system udp: OK
[    6.836762] Testing event system random: OK
[    6.853395] Testing event system regulator: OK
[    6.869501] Testing event system gpio: OK
[    6.885657] Testing event system writeback: OK
[    6.907608] Testing event system compaction: OK
[    6.925099] Testing event system kmem: OK
[    6.942196] Testing event system vmscan: [    6.960207] test-events (208=
) used greatest stack depth: 5824 bytes left
OK
[    6.962893] Testing event system oom: OK
[    6.981217] Testing event system power: OK
[    6.998139] Testing event system test: OK
[    7.012724] Testing event system module: OK
[    7.029094] Testing event system lock: OK
[    7.045260] Testing event system sched: OK
[    7.066541] Testing event system rcu: OK
[    7.096607] Testing event system workqueue: OK
[    7.113344] Testing event system signal: OK
[    7.129070] Testing event system timer: OK
[    7.151363] Testing event system irq: OK
[    7.169560] Testing event system printk: OK
[    7.184827] Testing event system task: OK
[    7.200994] Testing event system raw_syscalls: OK
[    7.216967] Testing event system vsyscall: OK
[    7.232837] Running tests on all trace events:
[    7.233379] Testing all events: OK
[    7.572772] Running tests again, along with the function tracer
[    7.573656] Running tests on trace events:
[    7.574300] Testing event kfree_skb: [    7.636196] test-events (225) us=
ed greatest stack depth: 5168 bytes left
OK
[    7.639485] Testing event consume_skb: OK
[    7.658077] Testing event skb_copy_datagram_iovec: OK
[    7.678081] Testing event net_dev_xmit: OK
[    7.698372] Testing event net_dev_queue: OK
[    7.717677] Testing event netif_receive_skb: OK
[    7.738179] Testing event netif_rx: OK
[    7.757667] Testing event napi_poll: OK
[    7.773812] Testing event sock_rcvqueue_full: OK
[    7.794042] Testing event sock_exceed_buf_limit: OK
[    7.814217] Testing event udp_fail_queue_rcv_skb: OK
[    7.834038] Testing event mix_pool_bytes: OK
[    7.854174] Testing event mix_pool_bytes_nolock: OK
[    7.874179] Testing event credit_entropy_bits: OK
[    7.894173] Testing event get_random_bytes: OK
[    7.914182] Testing event extract_entropy: OK
[    7.934210] Testing event extract_entropy_user: OK
[    7.953703] Testing event regulator_enable: OK
[    7.973923] Testing event regulator_enable_delay: OK
[    7.994185] Testing event regulator_enable_complete: [    8.012351] test=
-events (244) used greatest stack depth: 5144 bytes left
OK
[    8.015148] Testing event regulator_disable: OK
[    8.034159] Testing event regulator_disable_complete: OK
[    8.054157] Testing event regulator_set_voltage: OK
[    8.073741] Testing event regulator_set_voltage_complete: OK
[    8.094174] Testing event gpio_direction: OK
[    8.114860] Testing event gpio_value: OK
[    8.135036] Testing event writeback_nothread: OK
[    8.154141] Testing event writeback_queue: OK
[    8.174108] Testing event writeback_exec: OK
[    8.194055] Testing event writeback_start: OK
[    8.214017] Testing event writeback_written: OK
[    8.233674] Testing event writeback_wait: OK
[    8.253573] Testing event writeback_pages_written: OK
[    8.274034] Testing event writeback_nowork: OK
[    8.294087] Testing event writeback_wake_background: OK
[    8.313781] Testing event writeback_wake_thread: OK
[    8.334214] Testing event writeback_wake_forker_thread: OK
[    8.353753] Testing event writeback_bdi_register: OK
[    8.374177] Testing event writeback_bdi_unregister: OK
[    8.393784] Testing event writeback_thread_start: OK
[    8.413604] Testing event writeback_thread_stop: OK
[    8.434013] Testing event wbc_writepage: OK
[    8.454041] Testing event writeback_queue_io: OK
[    8.473977] Testing event global_dirty_state: OK
[    8.502975] Testing event bdi_dirty_ratelimit: OK
[    8.530027] Testing event balance_dirty_pages: OK
[    8.549849] Testing event writeback_sb_inodes_requeue: OK
[    8.570037] Testing event writeback_congestion_wait: OK
[    8.589634] Testing event writeback_wait_iff_congested: OK
[    8.609597] Testing event writeback_single_inode: OK
[    8.630005] Testing event mm_compaction_isolate_migratepages: OK
[    8.649939] Testing event mm_compaction_isolate_freepages: OK
[    8.669972] Testing event mm_compaction_migratepages: OK
[    8.689615] Testing event kmalloc: OK
[    8.710260] Testing event kmem_cache_alloc: OK
[    8.730007] Testing event kmalloc_node: OK
[    8.749867] Testing event kmem_cache_alloc_node: OK
[    8.769763] Testing event kfree: OK
[    8.790129] Testing event kmem_cache_free:=20
--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.6.0-rc1-00010-g25cd20b"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.6.0-rc1 Kernel Configuration
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
CONFIG_GENERIC_GPIO=y
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
CONFIG_ARCH_CPU_PROBE_RELEASE=y
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
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_FHANDLE=y
# CONFIG_TASKSTATS is not set
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
CONFIG_RCU_FAST_NO_HZ=y
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
CONFIG_RD_LZMA=y
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
# CONFIG_EVENTFD is not set
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
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
CONFIG_JUMP_LABEL=y
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
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
# CONFIG_MODULE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
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
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_PARAVIRT_DEBUG=y
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
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
CONFIG_I8K=m
CONFIG_MICROCODE=m
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
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
CONFIG_MEMORY_ISOLATION=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_ARCH_RANDOM is not set
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
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
# CONFIG_SFI is not set

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
# Memory power savings
#

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
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
CONFIG_PCCARD=m
CONFIG_PCMCIA=m
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
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
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETFILTER is not set
CONFIG_ATM=m
# CONFIG_ATM_LANE is not set
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_BRIDGE=m
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_DECNET=m
CONFIG_LLC=m
CONFIG_LLC2=m
CONFIG_IPX=m
CONFIG_IPX_INTERN=y
# CONFIG_ATALK is not set
CONFIG_PHONET=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
# CONFIG_NET_SCH_HTB is not set
CONFIG_NET_SCH_HFSC=m
# CONFIG_NET_SCH_ATM is not set
CONFIG_NET_SCH_PRIO=m
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
CONFIG_NET_SCH_SFB=m
# CONFIG_NET_SCH_SFQ is not set
CONFIG_NET_SCH_TEQL=m
# CONFIG_NET_SCH_TBF is not set
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=m
# CONFIG_NET_SCH_CHOKE is not set
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=m
# CONFIG_NET_SCH_INGRESS is not set
CONFIG_NET_SCH_PLUG=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_FW is not set
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
# CONFIG_CLS_U32_MARK is not set
CONFIG_NET_CLS_RSVP=m
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
# CONFIG_NET_EMATCH_NBYTE is not set
CONFIG_NET_EMATCH_U32=m
# CONFIG_NET_EMATCH_META is not set
# CONFIG_NET_EMATCH_TEXT is not set
# CONFIG_NET_EMATCH_CANID is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
# CONFIG_NET_ACT_MIRRED is not set
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_BQL=y
CONFIG_BPF_JIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
# CONFIG_CAN_GW is not set

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
CONFIG_CAN_SLCAN=m
CONFIG_CAN_DEV=m
# CONFIG_CAN_CALC_BITTIMING is not set
# CONFIG_PCH_CAN is not set
# CONFIG_CAN_SJA1000 is not set
CONFIG_CAN_C_CAN=m
# CONFIG_CAN_C_CAN_PLATFORM is not set
# CONFIG_CAN_C_CAN_PCI is not set
CONFIG_CAN_CC770=m
# CONFIG_CAN_CC770_ISA is not set
CONFIG_CAN_CC770_PLATFORM=m

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=m
# CONFIG_CAN_ESD_USB2 is not set
CONFIG_CAN_PEAK_USB=m
# CONFIG_CAN_SOFTING is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
CONFIG_IRCOMM=m
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
CONFIG_IRDA_DEBUG=y

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#

#
# FIR device drivers
#
CONFIG_USB_IRDA=m
CONFIG_BT=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
# CONFIG_BT_BNEP is not set
CONFIG_BT_CMTP=m
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTUSB is not set
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIDTL1 is not set
CONFIG_BT_HCIBT3C=m
# CONFIG_BT_HCIBLUECARD is not set
CONFIG_BT_HCIBTUART=m
CONFIG_BT_HCIVHCI=m
# CONFIG_BT_MRVL is not set
CONFIG_BT_WILINK=m
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
CONFIG_CAIF=m
# CONFIG_CAIF_DEBUG is not set
# CONFIG_CAIF_NETDEV is not set
# CONFIG_CAIF_USB is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=m
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
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

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
CONFIG_VMWARE_BALLOON=m
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

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
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
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
# CONFIG_CAPI_TRACE is not set
# CONFIG_ISDN_CAPI_MIDDLEWARE is not set
CONFIG_ISDN_CAPI_CAPI20=m

#
# CAPI hardware drivers
#
# CONFIG_CAPI_AVM is not set
# CONFIG_CAPI_EICON is not set
# CONFIG_ISDN_DRV_GIGASET is not set
# CONFIG_HYSDN is not set
# CONFIG_MISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=m

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
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
# CONFIG_MOUSE_PS2_SYNAPTICS is not set
CONFIG_MOUSE_PS2_LIFEBOOK=y
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
CONFIG_MOUSE_PS2_ELANTECH=y
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=m
# CONFIG_MOUSE_APPLETOUCH is not set
CONFIG_MOUSE_BCM5974=m
CONFIG_MOUSE_VSXXXAA=m
CONFIG_MOUSE_GPIO=m
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
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
CONFIG_SERIO_PS2MULT=m
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
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
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

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
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_XILINX_PS_UART=m
CONFIG_TTY_PRINTK=y
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=m
# CONFIG_RTC is not set
# CONFIG_GEN_RTC is not set
CONFIG_R3964=m
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
CONFIG_CARDMAN_4000=m
# CONFIG_CARDMAN_4040 is not set
CONFIG_MWAVE=m
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set
# CONFIG_SPI is not set
CONFIG_HSI=m
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=m

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
# CONFIG_DEBUG_GPIO is not set

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
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
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_W1=m
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2490 is not set
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2423=m
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=m
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=m
CONFIG_TEST_POWER=m
CONFIG_BATTERY_DS2780=m
CONFIG_BATTERY_DS2781=m
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_CHARGER_ISP1704=m
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_GPIO=m
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=m
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_PC87360=m
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_SHT15=m
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83627HF=m
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
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
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=m
CONFIG_MFD_SM501=m
# CONFIG_MFD_SM501_GPIO is not set
CONFIG_HTC_PASIC3=m
# CONFIG_MFD_TMIO is not set
CONFIG_ABX500_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_LPC_SCH is not set
# CONFIG_LPC_ICH is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=m
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
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
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
# CONFIG_FB is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=m
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=m
CONFIG_SOUND=m
# CONFIG_SOUND_OSS_CORE is not set
# CONFIG_SND is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=m
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=m
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_CYPRESS=m
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=m
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_HOLTEK is not set
CONFIG_HID_KEYTOUCH=m
# CONFIG_HID_KYE is not set
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=m
# CONFIG_HID_LOGITECH_DJ is not set
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=m
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_NTRIG=m
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_PRIMAX=m
CONFIG_HID_ROCCAT=m
CONFIG_HID_SAITEK=m
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SONY=m
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_SUNPLUS=m
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=m
CONFIG_HID_WIIMOTE_EXT=y
# CONFIG_HID_ZEROPLUS is not set
CONFIG_HID_ZYDACRON=m

#
# USB HID support
#
CONFIG_USB_HID=m
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=m
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=m
CONFIG_USB_DEBUG=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_OTG_BLACKLIST_HUB=y
CONFIG_USB_DWC3=m
# CONFIG_USB_DWC3_DEBUG is not set
CONFIG_USB_MON=m
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_EHCI_HCD is not set
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_U132_HCD=m
CONFIG_USB_SL811_HCD=m
# CONFIG_USB_SL811_HCD_ISO is not set
CONFIG_USB_SL811_CS=m
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_MUSB_HDRC=m
# CONFIG_USB_MUSB_TUSB6010 is not set
CONFIG_MUSB_PIO_ONLY=y
CONFIG_USB_CHIPIDEA=m
CONFIG_USB_CHIPIDEA_UDC=y
CONFIG_USB_CHIPIDEA_HOST=y
CONFIG_USB_CHIPIDEA_DEBUG=y
# CONFIG_USB_RENESAS_USBHS is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
CONFIG_USB_SEVSEG=m
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=m
# CONFIG_USB_LCD is not set
CONFIG_USB_LED=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=m
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=m
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_ATM=m
# CONFIG_USB_SPEEDTOUCH is not set
CONFIG_USB_CXACRU=m
# CONFIG_USB_UEAGLEATM is not set
# CONFIG_USB_XUSBATM is not set
CONFIG_USB_GADGET=m
CONFIG_USB_GADGET_DEBUG=y
CONFIG_USB_GADGET_DEBUG_FILES=y
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_R8A66597=m
CONFIG_USB_MV_UDC=m
# CONFIG_USB_GADGET_MUSB_HDRC is not set
CONFIG_USB_M66592=m
# CONFIG_USB_AMD5536UDC is not set
# CONFIG_USB_NET2272 is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
CONFIG_USB_DUMMY_HCD=m
CONFIG_USB_GADGET_DUALSPEED=y
CONFIG_USB_GADGET_SUPERSPEED=y
# CONFIG_USB_ZERO is not set
CONFIG_USB_ETH=m
# CONFIG_USB_ETH_RNDIS is not set
# CONFIG_USB_ETH_EEM is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_G_SERIAL is not set
CONFIG_USB_G_PRINTER=m
CONFIG_USB_CDC_COMPOSITE=m
# CONFIG_USB_G_NOKIA is not set
# CONFIG_USB_G_HID is not set
CONFIG_USB_G_DBGP=m
CONFIG_USB_G_DBGP_PRINTK=y
# CONFIG_USB_G_DBGP_SERIAL is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_OT200=m
# CONFIG_LEDS_TRIGGERS is not set

#
# LED Triggers
#
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_LEGACY_SYSFS=y
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_MM_EDAC is not set
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
CONFIG_ECHO=m
CONFIG_COMEDI=m
# CONFIG_COMEDI_DEBUG is not set
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
# CONFIG_COMEDI_MISC_DRIVERS is not set
# CONFIG_COMEDI_PCI_DRIVERS is not set
# CONFIG_COMEDI_PCMCIA_DRIVERS is not set
# CONFIG_COMEDI_USB_DRIVERS is not set
# CONFIG_COMEDI_8255 is not set
CONFIG_ASUS_OLED=m
CONFIG_TRANZPORT=m
# CONFIG_DX_SEP is not set
CONFIG_ZCACHE=y
CONFIG_ZSMALLOC=y
# CONFIG_CRYSTALHD is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_STAGING_MEDIA=y

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
# CONFIG_ANDROID_LOGGER is not set
CONFIG_ANDROID_TIMED_OUTPUT=y
# CONFIG_ANDROID_TIMED_GPIO is not set
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
# CONFIG_PHONE is not set
CONFIG_USB_WPAN_HCD=m
CONFIG_IPACK_BUS=m
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_WIMAX_GDM72XX=m
CONFIG_WIMAX_GDM72XX_QOS=y
# CONFIG_WIMAX_GDM72XX_K_MODE is not set
# CONFIG_WIMAX_GDM72XX_WIMAX2 is not set
CONFIG_WIMAX_GDM72XX_USB=y
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
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
CONFIG_EXTCON_GPIO=m
CONFIG_MEMORY=y
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=m
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_DEBUG=y
# CONFIG_QFMT_V1 is not set
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set
# CONFIG_OVERLAYFS_FS is not set

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_FSCACHE_OBJECT_LIST=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NCP_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=m
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=m
# CONFIG_NLS_MAC_TURKISH is not set
# CONFIG_NLS_UTF8 is not set

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
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
CONFIG_DEBUG_OBJECTS_WORK=y
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_STATS=y
# CONFIG_DEBUG_PREEMPT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_BUGVERBOSE is not set
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
# CONFIG_TEST_LIST_SORT is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_VERBOSE=y
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_LATENCYTOP=y
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
CONFIG_FUNCTION_TRACER=y
# CONFIG_FUNCTION_GRAPH_TRACER is not set
CONFIG_IRQSOFF_TRACER=y
# CONFIG_PREEMPT_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
CONFIG_STACK_TRACER=y
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
CONFIG_DYNAMIC_FTRACE=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
# CONFIG_EVENT_TRACE_TEST_SYSCALLS is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_TEST_KSTRTOX is not set
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_SET_MODULE_RONX=y
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
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
CONFIG_CPA_DEBUG=y
# CONFIG_OPTIMIZE_INLINING is not set
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
CONFIG_SECURITY_YAMA=y
CONFIG_INTEGRITY=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_AUDIT=y
CONFIG_DEFAULT_SECURITY_YAMA=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="yama"
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
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER_X86=m
CONFIG_CRYPTO_GLUE_HELPER_X86=m

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
CONFIG_CRYPTO_HMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_GHASH=m
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
# CONFIG_CRYPTO_SHA256 is not set
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=m
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=m
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=m
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=m
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
CONFIG_BINARY_PRINTF=y

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
CONFIG_CRC32_SELFTEST=y
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set

--9amGYk9869ThD9tj--
